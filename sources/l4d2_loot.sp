#include <sourcemod>

#define CVAR_FLAGS FCVAR_PLUGIN
#define PLUGIN_VERSION "1.8"
#define CSS_WEAPONS true
#define BASEBALL_BAT true
#define RIOT_SHIELD true
#define DEBUG false
#define PRINT_DROP false

public Plugin:myinfo = 
{
	name = "[L4D2] Loot of Zombies",
	author = "Jonny",
	description = "Plugin drops some items from killed special-infected",
	version = PLUGIN_VERSION,
	url = "http://forums.alliedmods.net/showthread.php?t=115763"
}

new IsMapFinished;

new Handle:IsPluginEnabled;
new Handle:DropItemsFromPlayers;
new Handle:DropGascansOnScavenge;
new Handle:DropDefibsOnSurvival;
new Handle:BotsCanFarm;
new Handle:NoFarm;
new Handle:NoFarmPanic;
new Handle:CheckPrechachedModels;

// Global
new Handle:l4d2_loot_g_chance_nodrop;
new Handle:l4d2_loot_g_bonus;

// Hunter
new Handle:l4d2_loot_h_drop_items;
new Handle:l4d2_loot_h_chance_health;
new Handle:l4d2_loot_h_chance_melee;
new Handle:l4d2_loot_h_chance_bullet;
new Handle:l4d2_loot_h_chance_explosive;
new Handle:l4d2_loot_h_chance_throw;
new Handle:l4d2_loot_h_chance_upgrades;
new Handle:l4d2_loot_h_chance_misc;
new Handle:l4d2_loot_h_chance_misc2;
new Handle:l4d2_loot_h_chance_nodrop;

// Boomer
new Handle:l4d2_loot_b_drop_items;
new Handle:l4d2_loot_b_chance_health;
new Handle:l4d2_loot_b_chance_melee;
new Handle:l4d2_loot_b_chance_bullet;
new Handle:l4d2_loot_b_chance_explosive;
new Handle:l4d2_loot_b_chance_throw;
new Handle:l4d2_loot_b_chance_upgrades;
new Handle:l4d2_loot_b_chance_misc;
new Handle:l4d2_loot_b_chance_misc2;
new Handle:l4d2_loot_b_chance_nodrop;

// Smoker
new Handle:l4d2_loot_s_drop_items;
new Handle:l4d2_loot_s_chance_health;
new Handle:l4d2_loot_s_chance_melee;
new Handle:l4d2_loot_s_chance_bullet;
new Handle:l4d2_loot_s_chance_explosive;
new Handle:l4d2_loot_s_chance_throw;
new Handle:l4d2_loot_s_chance_upgrades;
new Handle:l4d2_loot_s_chance_misc;
new Handle:l4d2_loot_s_chance_misc2;
new Handle:l4d2_loot_s_chance_nodrop;

// Charger
new Handle:l4d2_loot_c_drop_items;
new Handle:l4d2_loot_c_chance_health;
new Handle:l4d2_loot_c_chance_melee;
new Handle:l4d2_loot_c_chance_bullet;
new Handle:l4d2_loot_c_chance_explosive;
new Handle:l4d2_loot_c_chance_throw;
new Handle:l4d2_loot_c_chance_upgrades;
new Handle:l4d2_loot_c_chance_misc;
new Handle:l4d2_loot_c_chance_misc2;
new Handle:l4d2_loot_c_chance_nodrop;

// Spitter
new Handle:l4d2_loot_sp_drop_items;
new Handle:l4d2_loot_sp_chance_health;
new Handle:l4d2_loot_sp_chance_melee;
new Handle:l4d2_loot_sp_chance_bullet;
new Handle:l4d2_loot_sp_chance_explosive;
new Handle:l4d2_loot_sp_chance_throw;
new Handle:l4d2_loot_sp_chance_upgrades;
new Handle:l4d2_loot_sp_chance_misc;
new Handle:l4d2_loot_sp_chance_misc2;
new Handle:l4d2_loot_sp_chance_nodrop;

// Jockey
new Handle:l4d2_loot_j_drop_items;
new Handle:l4d2_loot_j_chance_health;
new Handle:l4d2_loot_j_chance_melee;
new Handle:l4d2_loot_j_chance_bullet;
new Handle:l4d2_loot_j_chance_explosive;
new Handle:l4d2_loot_j_chance_throw;
new Handle:l4d2_loot_j_chance_upgrades;
new Handle:l4d2_loot_j_chance_misc;
new Handle:l4d2_loot_j_chance_misc2;
new Handle:l4d2_loot_j_chance_nodrop;

// Tank
new Handle:l4d2_loot_t_drop_items;
new Handle:l4d2_loot_t_chance_health;
new Handle:l4d2_loot_t_chance_melee;
new Handle:l4d2_loot_t_chance_bullet;
new Handle:l4d2_loot_t_chance_explosive;
new Handle:l4d2_loot_t_chance_throw;
new Handle:l4d2_loot_t_chance_upgrades;
new Handle:l4d2_loot_t_chance_misc;
new Handle:l4d2_loot_t_chance_misc2;
new Handle:l4d2_loot_t_chance_nodrop;

new Handle:l4d2_loot_first_aid_kit;
new Handle:l4d2_loot_defibrillator;
new Handle:l4d2_loot_pain_pills;
new Handle:l4d2_loot_adrenaline;

new Handle:l4d2_loot_cricket_bat;
new Handle:l4d2_loot_crowbar;
new Handle:l4d2_loot_electric_guitar;
new Handle:l4d2_loot_chainsaw;
new Handle:l4d2_loot_katana;
new Handle:l4d2_loot_machete;
new Handle:l4d2_loot_tonfa;
new Handle:l4d2_loot_frying_pan;
new Handle:l4d2_loot_fireaxe;
new Handle:l4d2_loot_golfclub;

#if BASEBALL_BAT
new Handle:l4d2_loot_baseball_bat;
#endif

#if CSS_WEAPONS
new Handle:l4d2_loot_knife;
#endif

#if RIOT_SHIELD
new Handle:l4d2_loot_riotshield;
#endif

new Handle:l4d2_loot_pistol;
new Handle:l4d2_loot_pistol_magnum;
new Handle:l4d2_loot_smg;
new Handle:l4d2_loot_smg_silenced;
new Handle:l4d2_loot_pumpshotgun;
new Handle:l4d2_loot_shotgun_chrome;
new Handle:l4d2_loot_shotgun_spas;
new Handle:l4d2_loot_autoshotgun;
new Handle:l4d2_loot_sniper_military;
new Handle:l4d2_loot_hunting_rifle;
new Handle:l4d2_loot_rifle;
new Handle:l4d2_loot_rifle_desert;
new Handle:l4d2_loot_rifle_ak47;
new Handle:l4d2_loot_rifle_m60;

#if CSS_WEAPONS
new Handle:l4d2_loot_smg_mp5;
new Handle:l4d2_loot_sniper_scout;
new Handle:l4d2_loot_sniper_awp;
new Handle:l4d2_loot_rifle_sg552;
#endif

new Handle:l4d2_loot_grenade_launcher;

new Handle:l4d2_loot_pipe_bomb;
new Handle:l4d2_loot_molotov;
new Handle:l4d2_loot_vomitjar;

new Handle:l4d2_loot_upgradepack_exp;
new Handle:l4d2_loot_upgradepack_inc;

new Handle:l4d2_loot_fireworkcrate;
new Handle:l4d2_loot_gascan;
new Handle:l4d2_loot_oxygentank;
new Handle:l4d2_loot_propanetank;

new Handle:l4d2_loot_gnome;
new Handle:l4d2_loot_cola_bottles;

public OnPluginStart()
{
    decl String:gamedir[11];
    GetGameFolderName(gamedir, sizeof(gamedir));
    if (!StrEqual(gamedir, "left4dead2", false))
	{
        SetFailState("L4D2 only.");
	}
	else
	{
		AddServerTag("loot");
		CreateConVar("l4d2_loot_version", PLUGIN_VERSION, "Version of the [L4D2] Loot.", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
		IsPluginEnabled = CreateConVar("l4d2_loot", "1", "Is the plugin enabled.", FCVAR_PLUGIN);
		DropGascansOnScavenge = CreateConVar("l4d2_loot_scavenge_gascans", "0", "", FCVAR_PLUGIN);
		DropDefibsOnSurvival = CreateConVar("l4d2_loot_survival_defibs", "0", "", FCVAR_PLUGIN);
		DropItemsFromPlayers = CreateConVar("l4d2_loot_from_players", "0", "", FCVAR_PLUGIN);
		NoFarm = CreateConVar("l4d2_loot_nofarm", "1", "No farm", FCVAR_PLUGIN);
		NoFarmPanic = CreateConVar("l4d2_loot_nofarm_panic", "0", "Panic event on no-farm mode", FCVAR_PLUGIN);
		BotsCanFarm = CreateConVar("l4d2_loot_botscanfarm", "6", "Bots can farm if players count <= X", FCVAR_PLUGIN);
		CheckPrechachedModels = CreateConVar("l4d2_loot_checkprecache", "0", "", FCVAR_PLUGIN);

		HookEvent("player_entered_checkpoint", Event_CheckPoint);
		HookEvent("round_start_post_nav", Event_RoundStart);
		HookEvent("player_death", Event_PlayerDeath);

		l4d2_loot_g_chance_nodrop = CreateConVar("l4d2_loot_g_chance_nodrop", "0", "", FCVAR_PLUGIN);
		l4d2_loot_g_bonus = CreateConVar("l4d2_loot_g_bonus", "0", "", FCVAR_PLUGIN);

		l4d2_loot_h_drop_items = CreateConVar("l4d2_loot_h_drop_items", "1", "", FCVAR_PLUGIN);
		l4d2_loot_b_drop_items = CreateConVar("l4d2_loot_b_drop_items", "1", "", FCVAR_PLUGIN);
		l4d2_loot_s_drop_items = CreateConVar("l4d2_loot_s_drop_items", "1", "", FCVAR_PLUGIN);
		l4d2_loot_c_drop_items = CreateConVar("l4d2_loot_c_drop_items", "1", "", FCVAR_PLUGIN);
		l4d2_loot_sp_drop_items = CreateConVar("l4d2_loot_sp_drop_items", "1", "", FCVAR_PLUGIN);
		l4d2_loot_j_drop_items = CreateConVar("l4d2_loot_j_drop_items", "1", "", FCVAR_PLUGIN);
		l4d2_loot_t_drop_items = CreateConVar("l4d2_loot_t_drop_items", "1", "", FCVAR_PLUGIN);

		l4d2_loot_h_chance_health = CreateConVar("l4d2_loot_h_chance_health", "16", "", FCVAR_PLUGIN);
		l4d2_loot_h_chance_melee = CreateConVar("l4d2_loot_h_chance_melee", "12", "", FCVAR_PLUGIN);
		l4d2_loot_h_chance_bullet = CreateConVar("l4d2_loot_h_chance_bullet", "15", "", FCVAR_PLUGIN);
		l4d2_loot_h_chance_explosive = CreateConVar("l4d2_loot_h_chance_explosive", "1", "", FCVAR_PLUGIN);
		l4d2_loot_h_chance_throw = CreateConVar("l4d2_loot_h_chance_throw", "20", "", FCVAR_PLUGIN);
		l4d2_loot_h_chance_upgrades = CreateConVar("l4d2_loot_h_chance_upgrades", "10", "", FCVAR_PLUGIN);
		l4d2_loot_h_chance_misc = CreateConVar("l4d2_loot_h_chance_misc", "10", "", FCVAR_PLUGIN);
		l4d2_loot_h_chance_misc2 = CreateConVar("l4d2_loot_h_chance_misc2", "10", "", FCVAR_PLUGIN);
		l4d2_loot_h_chance_nodrop = CreateConVar("l4d2_loot_h_chance_nodrop", "30", "", FCVAR_PLUGIN);

		l4d2_loot_b_chance_health = CreateConVar("l4d2_loot_b_chance_health", "16", "", FCVAR_PLUGIN);
		l4d2_loot_b_chance_melee = CreateConVar("l4d2_loot_b_chance_melee", "12", "", FCVAR_PLUGIN);
		l4d2_loot_b_chance_bullet = CreateConVar("l4d2_loot_b_chance_bullet", "15", "", FCVAR_PLUGIN);
		l4d2_loot_b_chance_explosive = CreateConVar("l4d2_loot_b_chance_explosive", "1", "", FCVAR_PLUGIN);
		l4d2_loot_b_chance_throw = CreateConVar("l4d2_loot_b_chance_throw", "20", "", FCVAR_PLUGIN);
		l4d2_loot_b_chance_upgrades = CreateConVar("l4d2_loot_b_chance_upgrades", "10", "", FCVAR_PLUGIN);
		l4d2_loot_b_chance_misc = CreateConVar("l4d2_loot_b_chance_misc", "10", "", FCVAR_PLUGIN);
		l4d2_loot_b_chance_misc2 = CreateConVar("l4d2_loot_b_chance_misc2", "10", "", FCVAR_PLUGIN);
		l4d2_loot_b_chance_nodrop = CreateConVar("l4d2_loot_b_chance_nodrop", "30", "", FCVAR_PLUGIN);

		l4d2_loot_s_chance_health = CreateConVar("l4d2_loot_s_chance_health", "16", "", FCVAR_PLUGIN);
		l4d2_loot_s_chance_melee = CreateConVar("l4d2_loot_s_chance_melee", "12", "", FCVAR_PLUGIN);
		l4d2_loot_s_chance_bullet = CreateConVar("l4d2_loot_s_chance_bullet", "15", "", FCVAR_PLUGIN);
		l4d2_loot_s_chance_explosive = CreateConVar("l4d2_loot_s_chance_explosive", "1", "", FCVAR_PLUGIN);
		l4d2_loot_s_chance_throw = CreateConVar("l4d2_loot_s_chance_throw", "20", "", FCVAR_PLUGIN);
		l4d2_loot_s_chance_upgrades = CreateConVar("l4d2_loot_s_chance_upgrades", "10", "", FCVAR_PLUGIN);
		l4d2_loot_s_chance_misc = CreateConVar("l4d2_loot_s_chance_misc", "10", "", FCVAR_PLUGIN);
		l4d2_loot_s_chance_misc2 = CreateConVar("l4d2_loot_s_chance_misc2", "10", "", FCVAR_PLUGIN);
		l4d2_loot_s_chance_nodrop = CreateConVar("l4d2_loot_s_chance_nodrop", "30", "", FCVAR_PLUGIN);

		l4d2_loot_c_chance_health = CreateConVar("l4d2_loot_c_chance_health", "16", "", FCVAR_PLUGIN);
		l4d2_loot_c_chance_melee = CreateConVar("l4d2_loot_c_chance_melee", "12", "", FCVAR_PLUGIN);
		l4d2_loot_c_chance_bullet = CreateConVar("l4d2_loot_c_chance_bullet", "15", "", FCVAR_PLUGIN);
		l4d2_loot_c_chance_explosive = CreateConVar("l4d2_loot_c_chance_explosive", "1", "", FCVAR_PLUGIN);
		l4d2_loot_c_chance_throw = CreateConVar("l4d2_loot_c_chance_throw", "20", "", FCVAR_PLUGIN);
		l4d2_loot_c_chance_upgrades = CreateConVar("l4d2_loot_c_chance_upgrades", "10", "", FCVAR_PLUGIN);
		l4d2_loot_c_chance_misc = CreateConVar("l4d2_loot_c_chance_misc", "10", "", FCVAR_PLUGIN);
		l4d2_loot_c_chance_misc2 = CreateConVar("l4d2_loot_c_chance_misc2", "10", "", FCVAR_PLUGIN);
		l4d2_loot_c_chance_nodrop = CreateConVar("l4d2_loot_c_chance_nodrop", "30", "", FCVAR_PLUGIN);

		l4d2_loot_sp_chance_health = CreateConVar("l4d2_loot_sp_chance_health", "16", "", FCVAR_PLUGIN);
		l4d2_loot_sp_chance_melee = CreateConVar("l4d2_loot_sp_chance_melee", "12", "", FCVAR_PLUGIN);
		l4d2_loot_sp_chance_bullet = CreateConVar("l4d2_loot_sp_chance_bullet", "15", "", FCVAR_PLUGIN);
		l4d2_loot_sp_chance_explosive = CreateConVar("l4d2_loot_sp_chance_explosive", "1", "", FCVAR_PLUGIN);
		l4d2_loot_sp_chance_throw = CreateConVar("l4d2_loot_sp_chance_throw", "20", "", FCVAR_PLUGIN);
		l4d2_loot_sp_chance_upgrades = CreateConVar("l4d2_loot_sp_chance_upgrades", "10", "", FCVAR_PLUGIN);
		l4d2_loot_sp_chance_misc = CreateConVar("l4d2_loot_sp_chance_misc", "10", "", FCVAR_PLUGIN);
		l4d2_loot_sp_chance_misc2 = CreateConVar("l4d2_loot_sp_chance_misc2", "10", "", FCVAR_PLUGIN);
		l4d2_loot_sp_chance_nodrop = CreateConVar("l4d2_loot_sp_chance_nodrop", "30", "", FCVAR_PLUGIN);

		l4d2_loot_j_chance_health = CreateConVar("l4d2_loot_j_chance_health", "16", "", FCVAR_PLUGIN);
		l4d2_loot_j_chance_melee = CreateConVar("l4d2_loot_j_chance_melee", "12", "", FCVAR_PLUGIN);
		l4d2_loot_j_chance_bullet = CreateConVar("l4d2_loot_j_chance_bullet", "15", "", FCVAR_PLUGIN);
		l4d2_loot_j_chance_explosive = CreateConVar("l4d2_loot_j_chance_explosive", "1", "", FCVAR_PLUGIN);
		l4d2_loot_j_chance_throw = CreateConVar("l4d2_loot_j_chance_throw", "20", "", FCVAR_PLUGIN);
		l4d2_loot_j_chance_upgrades = CreateConVar("l4d2_loot_j_chance_upgrades", "10", "", FCVAR_PLUGIN);
		l4d2_loot_j_chance_misc = CreateConVar("l4d2_loot_j_chance_misc", "10", "", FCVAR_PLUGIN);
		l4d2_loot_j_chance_misc2 = CreateConVar("l4d2_loot_j_chance_misc2", "10", "", FCVAR_PLUGIN);
		l4d2_loot_j_chance_nodrop = CreateConVar("l4d2_loot_j_chance_nodrop", "30", "", FCVAR_PLUGIN);

		l4d2_loot_t_chance_health = CreateConVar("l4d2_loot_t_chance_health", "15", "", FCVAR_PLUGIN);
		l4d2_loot_t_chance_melee = CreateConVar("l4d2_loot_t_chance_melee", "2", "", FCVAR_PLUGIN);
		l4d2_loot_t_chance_bullet = CreateConVar("l4d2_loot_t_chance_bullet", "3", "", FCVAR_PLUGIN);
		l4d2_loot_t_chance_explosive = CreateConVar("l4d2_loot_t_chance_explosive", "1", "", FCVAR_PLUGIN);
		l4d2_loot_t_chance_throw = CreateConVar("l4d2_loot_t_chance_throw", "4", "", FCVAR_PLUGIN);
		l4d2_loot_t_chance_upgrades = CreateConVar("l4d2_loot_t_chance_upgrades", "6", "", FCVAR_PLUGIN);
		l4d2_loot_t_chance_misc = CreateConVar("l4d2_loot_t_chance_misc", "1", "", FCVAR_PLUGIN);
		l4d2_loot_t_chance_misc2 = CreateConVar("l4d2_loot_t_chance_misc2", "1", "", FCVAR_PLUGIN);
		l4d2_loot_t_chance_nodrop = CreateConVar("l4d2_loot_t_chance_nodrop", "0", "", FCVAR_PLUGIN);

		l4d2_loot_first_aid_kit = CreateConVar("l4d2_loot_first_aid_kit", "4", "", FCVAR_PLUGIN);
		l4d2_loot_defibrillator = CreateConVar("l4d2_loot_defibrillator", "4", "", FCVAR_PLUGIN);
		l4d2_loot_pain_pills = CreateConVar("l4d2_loot_pain_pills", "5", "", FCVAR_PLUGIN);
		l4d2_loot_adrenaline = CreateConVar("l4d2_loot_adrenaline", "7", "", FCVAR_PLUGIN);

		l4d2_loot_cricket_bat = CreateConVar("l4d2_loot_cricket_bat", "10", "", FCVAR_PLUGIN);
		l4d2_loot_crowbar = CreateConVar("l4d2_loot_crowbar", "10", "", FCVAR_PLUGIN);
		l4d2_loot_electric_guitar = CreateConVar("l4d2_loot_electric_guitar", "10", "", FCVAR_PLUGIN);
		l4d2_loot_chainsaw = CreateConVar("l4d2_loot_chainsaw", "10", "", FCVAR_PLUGIN);
		l4d2_loot_katana = CreateConVar("l4d2_loot_katana", "10", "", FCVAR_PLUGIN);
		l4d2_loot_machete = CreateConVar("l4d2_loot_machete", "10", "", FCVAR_PLUGIN);
		l4d2_loot_tonfa = CreateConVar("l4d2_loot_tonfa", "10", "", FCVAR_PLUGIN);
		l4d2_loot_frying_pan = CreateConVar("l4d2_loot_frying_pan", "10", "", FCVAR_PLUGIN);
		l4d2_loot_fireaxe = CreateConVar("l4d2_loot_fireaxe", "10", "", FCVAR_PLUGIN);
		l4d2_loot_golfclub = CreateConVar("l4d2_loot_golfclub", "10", "", FCVAR_PLUGIN);
		l4d2_loot_riotshield = CreateConVar("l4d2_loot_riotshield", "10", "", FCVAR_PLUGIN);

#if BASEBALL_BAT
		l4d2_loot_baseball_bat = CreateConVar("l4d2_loot_baseball_bat", "10", "", FCVAR_PLUGIN);
#endif

#if CSS_WEAPONS
		l4d2_loot_knife = CreateConVar("l4d2_loot_knife", "10", "", FCVAR_PLUGIN);
#endif		

		l4d2_loot_pistol = CreateConVar("l4d2_loot_pistol", "10", "", FCVAR_PLUGIN);
		l4d2_loot_pistol_magnum = CreateConVar("l4d2_loot_pistol_magnum", "10", "", FCVAR_PLUGIN);
		l4d2_loot_smg = CreateConVar("l4d2_loot_smg", "10", "", FCVAR_PLUGIN);
		l4d2_loot_smg_silenced = CreateConVar("l4d2_loot_smg_silenced", "10", "", FCVAR_PLUGIN);
		l4d2_loot_pumpshotgun = CreateConVar("l4d2_loot_pumpshotgun", "10", "", FCVAR_PLUGIN);
		l4d2_loot_shotgun_chrome = CreateConVar("l4d2_loot_shotgun_chrome", "10", "", FCVAR_PLUGIN);
		l4d2_loot_shotgun_spas = CreateConVar("l4d2_loot_shotgun_spas", "10", "", FCVAR_PLUGIN);
		l4d2_loot_autoshotgun = CreateConVar("l4d2_loot_autoshotgun", "10", "", FCVAR_PLUGIN);
		l4d2_loot_sniper_military = CreateConVar("l4d2_loot_sniper_military", "10", "", FCVAR_PLUGIN);
		l4d2_loot_hunting_rifle = CreateConVar("l4d2_loot_hunting_rifle", "10", "", FCVAR_PLUGIN);
		l4d2_loot_rifle = CreateConVar("l4d2_loot_rifle", "10", "", FCVAR_PLUGIN);
		l4d2_loot_rifle_desert = CreateConVar("l4d2_loot_rifle_desert", "10", "", FCVAR_PLUGIN);
		l4d2_loot_rifle_ak47 = CreateConVar("l4d2_loot_rifle_ak47", "10", "", FCVAR_PLUGIN);
		l4d2_loot_rifle_m60 = CreateConVar("l4d2_loot_rifle_m60", "10", "", FCVAR_PLUGIN);

#if CSS_WEAPONS
		l4d2_loot_smg_mp5 = CreateConVar("l4d2_loot_smg_mp5", "10", "", FCVAR_PLUGIN);
		l4d2_loot_sniper_scout = CreateConVar("l4d2_loot_sniper_scout", "10", "", FCVAR_PLUGIN);
		l4d2_loot_sniper_awp = CreateConVar("l4d2_loot_sniper_awp", "10", "", FCVAR_PLUGIN);
		l4d2_loot_rifle_sg552 = CreateConVar("l4d2_loot_rifle_sg552", "10", "", FCVAR_PLUGIN);
#endif

		l4d2_loot_grenade_launcher = CreateConVar("l4d2_loot_grenade_launcher", "100", "", FCVAR_PLUGIN);

		l4d2_loot_pipe_bomb = CreateConVar("l4d2_loot_pipe_bomb", "10", "", FCVAR_PLUGIN);
		l4d2_loot_molotov = CreateConVar("l4d2_loot_molotov", "10", "", FCVAR_PLUGIN);
		l4d2_loot_vomitjar = CreateConVar("l4d2_loot_vomitjar", "10", "", FCVAR_PLUGIN);

		l4d2_loot_upgradepack_exp = CreateConVar("l4d2_loot_upgradepack_exp", "50", "", FCVAR_PLUGIN);
		l4d2_loot_upgradepack_inc = CreateConVar("l4d2_loot_upgradepack_inc", "50", "", FCVAR_PLUGIN);

		l4d2_loot_fireworkcrate = CreateConVar("l4d2_loot_fireworkcrate", "25", "", FCVAR_PLUGIN);
		l4d2_loot_gascan = CreateConVar("l4d2_loot_gascan", "25", "", FCVAR_PLUGIN);
		l4d2_loot_oxygentank = CreateConVar("l4d2_loot_oxygentank", "25", "", FCVAR_PLUGIN);
		l4d2_loot_propanetank = CreateConVar("l4d2_loot_propanetank", "25", "", FCVAR_PLUGIN);

		l4d2_loot_gnome = CreateConVar("l4d2_loot_gnome", "100", "", FCVAR_PLUGIN);
		l4d2_loot_cola_bottles = CreateConVar("l4d2_loot_cola_bottles", "0", "", FCVAR_PLUGIN);		

#if DEBUG
		RegConsoleCmd("sm_loot_test_group", LootTestGroup);
		RegConsoleCmd("sm_checkmodel", CheckModel);
#endif	
		
		RegAdminCmd("sm_loot_hunter", CMD_LootHunter, ADMFLAG_CHEATS, "");
		RegAdminCmd("sm_loot_smoker", CMD_LootSmoker, ADMFLAG_CHEATS, "");
		RegAdminCmd("sm_loot_boomer", CMD_LootBoomer, ADMFLAG_CHEATS, "");
		RegAdminCmd("sm_loot_charger", CMD_LootCharger, ADMFLAG_CHEATS, "");
		RegAdminCmd("sm_loot_spitter", CMD_LootSpitter, ADMFLAG_CHEATS, "");
		RegAdminCmd("sm_loot_jockey", CMD_LootJockey, ADMFLAG_CHEATS, "");
		RegAdminCmd("sm_loot_tank", CMD_LootTank, ADMFLAG_CHEATS, "");
		
//		AutoExecConfig(true, "l4d2_loot");
	}
}

#if DEBUG
public Action:CheckModel(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[L4D2LOOT] Usage: sm_checkmodel <model_name>");
		return Plugin_Handled;
	}

	decl String:argstring[256];
	GetCmdArgString(argstring, sizeof(argstring));

	if (IsModelPrecachedEx(argstring))
	{
		ReplyToCommand(client, "[precached]: %s", argstring);
	}
	else
	{
		ReplyToCommand(client, "[not precached]: %s", argstring);
	}
	return Plugin_Handled;
}
#endif

#if DEBUG
public Action:LootTestGroup(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[L4D2LOOT] Usage: sm_loot_test_group <Hunter|Boomer|Smoker|Spitter|Charger|Jockey|Tank>");
		return Plugin_Handled;
	}

	decl String:argstring[10];
	GetCmdArgString(argstring, sizeof(argstring));

	new GroupCount[9];
		
	for (new i = 0; i < 100; i++)
	{
		GroupCount[GetRandomGroup(argstring)]++;
	}
	
	ReplyToCommand(client, "Group #1 (Health): %d", GroupCount[1]);
	ReplyToCommand(client, "Group #2 (Melee): %d", GroupCount[2]);
	ReplyToCommand(client, "Group #3 (Bullet): %d", GroupCount[3]);
	ReplyToCommand(client, "Group #4 (Explosive): %d", GroupCount[4]);
	ReplyToCommand(client, "Group #5 (Throw): %d", GroupCount[5]);
	ReplyToCommand(client, "Group #6 (Upgrades): %d", GroupCount[6]);
	ReplyToCommand(client, "Group #7 (Misc): %d", GroupCount[7]);
	ReplyToCommand(client, "Group #8 (No-Drop): %d", GroupCount[0]);
	
	return Plugin_Handled;
}
#endif

public GetClientZC(client)
{
	if (!IsValidEntity(client) || !IsValidEdict(client))
	{
		return 0;
	}
	return GetEntProp(client, Prop_Send, "m_zombieClass");
}

public Action:CMD_LootHunter(client, args)
{
	LootDropItem(client, GetRandomItem(GetRandomGroup("Hunter")));
}

public Action:CMD_LootBoomer(client, args)
{
	LootDropItem(client, GetRandomItem(GetRandomGroup("Boomer")));
}

public Action:CMD_LootSmoker(client, args)
{
	LootDropItem(client, GetRandomItem(GetRandomGroup("Smoker")));
}

public Action:CMD_LootCharger(client, args)
{
	LootDropItem(client, GetRandomItem(GetRandomGroup("Charger")));
}

public Action:CMD_LootJockey(client, args)
{
	LootDropItem(client, GetRandomItem(GetRandomGroup("Jockey")));
}

public Action:CMD_LootSpitter(client, args)
{
	LootDropItem(client, GetRandomItem(GetRandomGroup("Spitter")));
}

public Action:CMD_LootTank(client, args)
{
	LootDropItem(client, GetRandomItem(GetRandomGroup("Tank")));
}

public CheckPointReached(any:client)
{
	IsMapFinished = 1;
	if (GetConVarInt(NoFarmPanic) > 0 && GetConVarInt(IsPluginEnabled) > 0)
	{
		new String:command[] = "director_force_panic_event";
		new flags = GetCommandFlags(command);
		SetCommandFlags(command, flags & ~FCVAR_CHEAT);
		FakeClientCommand(client, command);
		SetCommandFlags(command, flags);
	}
}

public Action:Event_RoundStart(Handle:hEvent, const String:strName[], bool:DontBroadcast)
{
	IsMapFinished = 0;
}

public Action:Event_CheckPoint(Handle:event, const String:name[], bool:dontBroadcast)
{
#if DEBUG
	PrintToChatAll("\x05Event: CheckPoint (Start)");
#endif

	if (IsMapFinished > 0)
	{
		return Plugin_Continue;
	}

	new Target = GetClientOfUserId(GetEventInt(event, "userid"));
	decl String:strBuffer[128];
	GetEventString(event, "doorname", strBuffer, sizeof(strBuffer));

#if DEBUG
	PrintToChatAll("\x05Event: \x03CheckPoint ( \x01%N :: %s :: %d \x03 )", Target, strBuffer, GetEventInt(event, "area"));
#endif

	if (Target && (GetClientTeam(Target)) == 2)
	{
		if (StrEqual(strBuffer, "checkpoint_entrance", false))
		{
			CheckPointReached(Target);
		}
		else
		{
			new String:current_map[64];
			GetCurrentMap(current_map, 63);
			new area = GetEventInt(event, "area");
			if (StrEqual(current_map, "c2m1_highway", false))
			{
				if (area == 89583)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "c4m4_milltown_b", false))
			{
				if (area == 502575)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "c5m1_waterfront", false))
			{
				if (area == 54867)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "c5m2_park", false))
			{
				if (area == 196623)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "c7m1_docks", false))
			{
				if (area == 4475)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "c7m2_barge", false))
			{
				if (area == 52626)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "l4d_ihm01_forest", false))
			{
				if (area == 10116)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "l4d_ihm02_manor", false))
			{
				if (area == 3976)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "l4d_ihm03_underground", false))
			{
				if (area == 5360)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "c9m1_alleys", false))
			{
				if (area == 21211)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "c10m4_mainstreet", false))
			{
				if (area == 85038)
					CheckPointReached(Target);
				if (area == 85093)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "C12m1_hilltop", false))
			{
				if (area == 60481)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "c13m1_alpinecreek", false))
			{
				if (area == 14681)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "c13m2_southpinestream", false))
			{
				if (area == 2910)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "c13m3_memorialbridge", false))
			{
				if (area == 154511)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "evac2", false))
			{
				if (area == 48189)
					CheckPointReached(Target);
				if (area == 48994)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "l4d_viennacalling_kaiserfranz", false))
			{
				if (area == 7025)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "l4d_viennacalling_gloomy", false))
			{
				if (area == 15716)
					CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "uf1_boulevard", false))
			{
				if (area == 77346)
				CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "uf2_rooftops", false))
			{
				if (area == 12535)
				CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "uf3_harbor", false))
			{
				if (area == 190081)
				CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "uf4_airfield", false))
			{
				if (area == 147)
				CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "p84m1_crash", false))
			{
				if (area == 17314)
				CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "p84m2_train", false))
			{
				if (area == 26813)
				CheckPointReached(Target);
			}
			else if (StrEqual(current_map, "p84m3_clubd", false))
			{
				if (area == 20148)
				CheckPointReached(Target);
			}
		}
	}

#if DEBUG
	PrintToChatAll("\x05Event: CheckPoint (End)");
#endif

	return Plugin_Continue;
}

stock GetRealClientCount(bool:inGameOnly = true)
{
	new clients = 0;
	decl String:ClientSteamID[12];

	for (new i = 1; i <= GetMaxClients(); i++)
	{
		if (IsClientConnected(i))
		{
			GetClientAuthString(i, ClientSteamID, sizeof(ClientSteamID));
			if (!StrEqual(ClientSteamID, "BOT", false))
			{
				if (IsClientInGame(i) && !IsFakeClient(i))
				{
					clients++;
				}
			}
		}
	}
	return clients;
}

public Action:Event_PlayerDeath(Handle:hEvent, const String:strName[], bool:DontBroadcast)
{
#if DEBUG
//	PrintToChatAll("\x05Event: PlayerDeath (Start)");
#endif

	if (GetConVarInt(NoFarm) > 0 && IsMapFinished > 0)
	{
		return Plugin_Continue;
	}

	decl String:strBuffer[48];
	new Attacker = GetClientOfUserId(GetEventInt(hEvent, "attacker"));
	if (GetEventBool(hEvent, "attackerisbot") == true && GetConVarInt(BotsCanFarm) < GetRealClientCount(true))
	{
		return Plugin_Continue;
	}

	if (Attacker == 0)
	{
#if DEBUG
		PrintToChatAll("\x05Event: PlayerDeath : Attacker = 0");
#endif
//		return Plugin_Continue;
	}

	new Target = GetClientOfUserId(GetEventInt(hEvent, "userid"));

	if (Target == 0)
		return Plugin_Continue;

	if (GetEventBool(hEvent, "victimisbot") == false && GetConVarInt(DropItemsFromPlayers) == 0) return Plugin_Continue;

	GetEventString(hEvent, "victimname", strBuffer, sizeof(strBuffer));
	
	if (StrEqual(strBuffer, "", false) == true) return Plugin_Continue;

#if PRINT_DROP
	PrintToServer("[L4D2LOOT] DEAD :: %s", strBuffer);
#endif
	
#if DEBUG
	PrintToChatAll("\x05Event: PlayerDeath Target name : %s", strBuffer);
#endif

//	PrintToChatAll("%s = %d", strBuffer, GetClientZC(Target));

	if (GetClientTeam(Target) != 3)
		return Plugin_Continue;
	
//Smoker = 1
//Boomer = 2
//Hunter = 3
//Spitter = 4
//Jockey = 5
//Charger = 6
//Tank = 8


	if (GetClientZC(Target) == 3)
	{
#if DEBUG
		PrintToChatAll("\x05Event: PlayerDeath : %s (%d)", strBuffer, GetConVarInt(l4d2_loot_h_drop_items));
#endif

		for (new i = 0; i < GetConVarInt(l4d2_loot_h_drop_items) + GetConVarInt(l4d2_loot_g_bonus); i++)
			LootDropItem(Target, GetRandomItem(GetRandomGroup("Hunter")));
	}
	if (GetClientZC(Target) == 2)
	{
#if DEBUG
		PrintToChatAll("\x05Event: PlayerDeath : %s (%d)", strBuffer, GetConVarInt(l4d2_loot_b_drop_items));
#endif

		for (new i = 0; i < GetConVarInt(l4d2_loot_b_drop_items) + GetConVarInt(l4d2_loot_g_bonus); i++)
			LootDropItem(Target, GetRandomItem(GetRandomGroup("Boomer")));
	}
	else if (GetClientZC(Target) == 1)
	{
#if DEBUG
		PrintToChatAll("\x05Event: PlayerDeath : %s (%d)", strBuffer, GetConVarInt(l4d2_loot_s_drop_items));
#endif

		for (new i = 0; i < GetConVarInt(l4d2_loot_s_drop_items) + GetConVarInt(l4d2_loot_g_bonus); i++)
			LootDropItem(Target, GetRandomItem(GetRandomGroup("Smoker")));
	}
	else if (GetClientZC(Target) == 6)
	{
#if DEBUG
		PrintToChatAll("\x05Event: PlayerDeath : %s (%d)", strBuffer, GetConVarInt(l4d2_loot_c_drop_items));
#endif

		for (new i = 0; i < GetConVarInt(l4d2_loot_c_drop_items) + GetConVarInt(l4d2_loot_g_bonus); i++)
			LootDropItem(Target, GetRandomItem(GetRandomGroup("Charger")));
	}
	else if (GetClientZC(Target) == 4)
	{
#if DEBUG
		PrintToChatAll("\x05Event: PlayerDeath : %s (%d)", strBuffer, GetConVarInt(l4d2_loot_sp_drop_items));
#endif

		for (new i = 0; i < GetConVarInt(l4d2_loot_sp_drop_items) + GetConVarInt(l4d2_loot_g_bonus); i++)
			LootDropItem(Target, GetRandomItem(GetRandomGroup("Spitter")));
	}
	else if (GetClientZC(Target) == 5)
	{
#if DEBUG
		PrintToChatAll("\x05Event: PlayerDeath : %s (%d)", strBuffer, GetConVarInt(l4d2_loot_j_drop_items));
#endif

		for (new i = 0; i < GetConVarInt(l4d2_loot_j_drop_items) + GetConVarInt(l4d2_loot_g_bonus); i++)
			LootDropItem(Target, GetRandomItem(GetRandomGroup("Jockey")));
	}
	else if (GetClientZC(Target) == 8)
	{
#if DEBUG
		PrintToChatAll("\x05Event: PlayerDeath : %s (%d)", strBuffer, GetConVarInt(l4d2_loot_t_drop_items));
#endif

		for (new i = 0; i < GetConVarInt(l4d2_loot_t_drop_items) + GetConVarInt(l4d2_loot_g_bonus); i++)
			LootDropItem(Target, GetRandomItem(GetRandomGroup("Tank")));
	}

	return Plugin_Continue;
}

stock c1m4_atrium()
{
	new String:current_map[13];
	GetCurrentMap(current_map, 12);
	if (StrEqual(current_map, "c1m4_atrium", false) == true)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

stock GetGameMode()
{
	new String:GameMode[13];
	new Handle:gamecvar_mp_gamemode = FindConVar("mp_gamemode");
	GetConVarString(gamecvar_mp_gamemode, GameMode, sizeof(GameMode));
	if (StrEqual(GameMode, "coop", false) == true || StrEqual(GameMode, "mutation3", false) == true || StrEqual(GameMode, "mutation9", false) == true)
	{
		return 1;
	}
	else if (StrEqual(GameMode, "realism", false) == true)
	{
		return 2;
	}
	else if (StrEqual(GameMode, "survival", false) == true)
	{
		return 3;
	}
	else if (StrEqual(GameMode, "versus", false) == true || StrEqual(GameMode, "mutation12", false) == true)
	{
		return 4;
	}
	else if (StrEqual(GameMode, "teamversus", false) == true)
	{
		return 5;
	}
	else if (StrEqual(GameMode, "scavenge", false) == true)
	{
		return 6;
	}
	else if (StrEqual(GameMode, "teamscavenge", false) == true)
	{
		return 7;
	}
	return 0;
}

GetRandomGroup(const String:BotDiedName[])
{
	if (GetConVarInt(l4d2_loot_g_chance_nodrop) > 0)
	{
		new RND = GetRandomInt(1, 100);
		if (GetConVarInt(l4d2_loot_g_chance_nodrop) >= RND)
		{
			// Global No-Drop

#if DEBUG
			PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 0 (global)", BotDiedName);
#endif

			return 0;
		}
	}

	new Sum = 0;
	if (StrEqual("Hunter", BotDiedName))
	{
		Sum = GetConVarInt(l4d2_loot_h_chance_health);
		Sum += GetConVarInt(l4d2_loot_h_chance_melee);
		Sum += GetConVarInt(l4d2_loot_h_chance_bullet);
		if (IsModelPrecachedEx("models/w_models/weapons/w_grenade_launcher.mdl"))
		{
			Sum += GetConVarInt(l4d2_loot_h_chance_explosive);
		}
		Sum += GetConVarInt(l4d2_loot_h_chance_throw);
		Sum += GetConVarInt(l4d2_loot_h_chance_upgrades);
		Sum += GetConVarInt(l4d2_loot_h_chance_misc);
		Sum += GetConVarInt(l4d2_loot_h_chance_misc2);
		Sum += GetConVarInt(l4d2_loot_h_chance_nodrop);
		if (Sum > 0)
		{
			new Float:X = 100.0 / Sum;
			new Float:Y = GetRandomFloat(0.0, 100.0);
			new Float:A = 0.0;
			new Float:B = GetConVarInt(l4d2_loot_h_chance_health) * X;
			if (Y >= A && Y < A + B)
			{
				// Health Based Items

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 1", BotDiedName);
#endif

				return 1;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_h_chance_melee) * X;
			if (Y >= A && Y < A + B)
			{
				// Meele Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 2", BotDiedName);
#endif

				return 2;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_h_chance_bullet) * X;
			if (Y >= A && Y < A + B)
			{
				// Bullet-Based Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: GetRandomGroup ( %s ): return 3", BotDiedName);
#endif

				return 3;
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_grenade_launcher.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_h_chance_explosive) * X;
				if (Y >= A && Y < A + B)
				{
					// Explosive-Based Weapon

#if DEBUG
					PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 4", BotDiedName);
#endif

					return 4;
				}
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_h_chance_throw) * X;
			if (Y >= A && Y < A + B)
			{
				// Throw-Based Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 5", BotDiedName);
#endif

				return 5;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_h_chance_upgrades) * X;
			if (Y >= A && Y < A + B)
			{
				// Upgrades

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 6", BotDiedName);
#endif

				return 6;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_h_chance_misc) * X;
			if (Y >= A && Y < A + B)
			{
				// Misc

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 7", BotDiedName);
#endif

				return 7;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_h_chance_misc2) * X;
			if (Y >= A && Y < A + B)
			{
				// Misc 2

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 8", BotDiedName);
#endif

				return 8;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_h_chance_nodrop) * X;
			if (Y >= A && Y < A + B)
			{
				// Hunter No-Drop

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 0 (hunter)", BotDiedName);
#endif

				return 0;
			}
		}
		else
		{
#if DEBUG
			PrintToChatAll("\x05 Function: GetRandomGroup ( %s ): return 0 (else)", BotDiedName);
#endif

			return 0;
		}
	}
	if (StrEqual("Boomer", BotDiedName))
	{
		Sum = GetConVarInt(l4d2_loot_b_chance_health);
		Sum += GetConVarInt(l4d2_loot_b_chance_melee);
		Sum += GetConVarInt(l4d2_loot_b_chance_bullet);
		if (IsModelPrecachedEx("models/w_models/weapons/w_grenade_launcher.mdl"))
		{
			Sum += GetConVarInt(l4d2_loot_b_chance_explosive);
		}
		Sum += GetConVarInt(l4d2_loot_b_chance_throw);
		Sum += GetConVarInt(l4d2_loot_b_chance_upgrades);
		Sum += GetConVarInt(l4d2_loot_b_chance_misc);
		Sum += GetConVarInt(l4d2_loot_b_chance_misc2);
		Sum += GetConVarInt(l4d2_loot_b_chance_nodrop);
		if (Sum > 0)
		{
			new Float:X = 100.0 / Sum;
			new Float:Y = GetRandomFloat(0.0, 100.0);
			new Float:A = 0.0;
			new Float:B = GetConVarInt(l4d2_loot_b_chance_health) * X;
			if (Y >= A && Y < A + B)
			{
				// Health Based Items

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 1", BotDiedName);
#endif

				return 1;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_b_chance_melee) * X;
			if (Y >= A && Y < A + B)
			{
				// Meele Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 2", BotDiedName);
#endif

				return 2;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_b_chance_bullet) * X;
			if (Y >= A && Y < A + B)
			{
				// Bullet-Based Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 3", BotDiedName);
#endif

				return 3;
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_grenade_launcher.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_b_chance_explosive) * X;
				if (Y >= A && Y < A + B)
				{
					// Explosive-Based Weapon

#if DEBUG
					PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 4", BotDiedName);
#endif

					return 4;
				}
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_b_chance_throw) * X;
			if (Y >= A && Y < A + B)
			{
				// Throw-Based Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 5", BotDiedName);
#endif

				return 5;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_b_chance_upgrades) * X;
			if (Y >= A && Y < A + B)
			{
				// Upgrades

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 6", BotDiedName);
#endif

				return 6;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_b_chance_misc) * X;
			if (Y >= A && Y < A + B)
			{
				// Misc

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 7", BotDiedName);
#endif

				return 7;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_b_chance_misc2) * X;
			if (Y >= A && Y < A + B)
			{
				// Misc 2

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 8", BotDiedName);
#endif

				return 8;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_b_chance_nodrop) * X;
			if (Y >= A && Y < A + B)
			{
				// Boomer No-Drop

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 0 (boomer)", BotDiedName);
#endif

				return 0;
			}
		}
		else
		{
#if DEBUG
			PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 0 (else)", BotDiedName);
#endif

			return 0;
		}
	}
	if (StrEqual("Smoker", BotDiedName))
	{

#if DEBUG
		PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 )", BotDiedName);
#endif

		Sum = GetConVarInt(l4d2_loot_s_chance_health);
		Sum += GetConVarInt(l4d2_loot_s_chance_melee);
		Sum += GetConVarInt(l4d2_loot_s_chance_bullet);
		if (IsModelPrecachedEx("models/w_models/weapons/w_grenade_launcher.mdl"))
		{
			Sum += GetConVarInt(l4d2_loot_s_chance_explosive);
		}
		Sum += GetConVarInt(l4d2_loot_s_chance_throw);
		Sum += GetConVarInt(l4d2_loot_s_chance_upgrades);
		Sum += GetConVarInt(l4d2_loot_s_chance_misc);
		Sum += GetConVarInt(l4d2_loot_s_chance_misc2);
		Sum += GetConVarInt(l4d2_loot_s_chance_nodrop);

#if DEBUG
		PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : Sum = %d", Sum);
#endif

		if (Sum > 0)
		{
			new Float:X = 100.0 / Sum;
			new Float:Y = GetRandomFloat(0.0, 100.0);
			new Float:A = 0.0;
			new Float:B = GetConVarInt(l4d2_loot_s_chance_health) * X;

#if DEBUG
			PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : X = %f", X);
#endif

			if (Y >= A && Y < A + B)
			{
				// Health Based Items

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 1", BotDiedName);
#endif

				return 1;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_s_chance_melee) * X;
			if (Y >= A && Y < A + B)
			{
				// Meele Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 2", BotDiedName);
#endif

				return 2;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_s_chance_bullet) * X;
			if (Y >= A && Y < A + B)
			{
				// Bullet-Based Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 3", BotDiedName);
#endif

				return 3;
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_grenade_launcher.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_s_chance_explosive) * X;
				if (Y >= A && Y < A + B)
				{
					// Explosive-Based Weapon

#if DEBUG
					PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 4", BotDiedName);
#endif

					return 4;
				}
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_s_chance_throw) * X;
			if (Y >= A && Y < A + B)
			{
				// Throw-Based Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 5", BotDiedName);
#endif

				return 5;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_s_chance_upgrades) * X;
			if (Y >= A && Y < A + B)
			{
				// Upgrades

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 6", BotDiedName);
#endif

				return 6;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_s_chance_misc) * X;
			if (Y >= A && Y < A + B)
			{
				// Misc

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 7", BotDiedName);
#endif

				return 7;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_s_chance_misc2) * X;
			if (Y >= A && Y < A + B)
			{
				// Misc

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 8", BotDiedName);
#endif

				return 8;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_s_chance_nodrop) * X;
			if (Y >= A && Y < A + B)
			{
				// Smoker No-Drop

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 0 (smoker)", BotDiedName);
#endif

				return 0;
			}
		}
		else
		{
#if DEBUG
			PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 0 (else)", BotDiedName);
#endif

			return 0;
		}
	}
	if (StrEqual("Charger", BotDiedName))
	{
		Sum = GetConVarInt(l4d2_loot_c_chance_health);
		Sum += GetConVarInt(l4d2_loot_c_chance_melee);
		Sum += GetConVarInt(l4d2_loot_c_chance_bullet);
		if (IsModelPrecachedEx("models/w_models/weapons/w_grenade_launcher.mdl"))
		{
			Sum += GetConVarInt(l4d2_loot_c_chance_explosive);
		}
		Sum += GetConVarInt(l4d2_loot_c_chance_throw);
		Sum += GetConVarInt(l4d2_loot_c_chance_upgrades);
		Sum += GetConVarInt(l4d2_loot_c_chance_misc);
		Sum += GetConVarInt(l4d2_loot_c_chance_misc2);
		Sum += GetConVarInt(l4d2_loot_c_chance_nodrop);
		if (Sum > 0)
		{
			new Float:X = 100.0 / Sum;
			new Float:Y = GetRandomFloat(0.0, 100.0);
			new Float:A = 0.0;
			new Float:B = GetConVarInt(l4d2_loot_c_chance_health) * X;
			if (Y >= A && Y < A + B)
			{
				// Health Based Items

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 1", BotDiedName);
#endif

				return 1;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_c_chance_melee) * X;
			if (Y >= A && Y < A + B)
			{
				// Meele Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 2", BotDiedName);
#endif

				return 2;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_c_chance_bullet) * X;
			if (Y >= A && Y < A + B)
			{
				// Bullet-Based Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 3", BotDiedName);
#endif

				return 3;
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_grenade_launcher.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_c_chance_explosive) * X;
				if (Y >= A && Y < A + B)
				{
					// Explosive-Based Weapon

#if DEBUG
					PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 4", BotDiedName);
#endif

					return 4;
				}
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_c_chance_throw) * X;
			if (Y >= A && Y < A + B)
			{
				// Throw-Based Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 5", BotDiedName);
#endif

				return 5;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_c_chance_upgrades) * X;
			if (Y >= A && Y < A + B)
			{
				// Upgrades

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 6", BotDiedName);
#endif

				return 6;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_c_chance_misc) * X;
			if (Y >= A && Y < A + B)
			{
				// Misc

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 7", BotDiedName);
#endif

				return 7;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_c_chance_misc2) * X;
			if (Y >= A && Y < A + B)
			{
				// Misc 2

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 8", BotDiedName);
#endif

				return 8;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_c_chance_nodrop) * X;
			if (Y >= A && Y < A + B)
			{
				// Charger No-Drop

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 0 (charger)", BotDiedName);
#endif

				return 0;
			}
		}
		else
		{
#if DEBUG
			PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 0 (else)", BotDiedName);
#endif

			return 0;
		}
	}
	if (StrEqual("Spitter", BotDiedName))
	{
		Sum = GetConVarInt(l4d2_loot_sp_chance_health);
		Sum += GetConVarInt(l4d2_loot_sp_chance_melee);
		Sum = Sum + GetConVarInt(l4d2_loot_sp_chance_bullet);
		if (IsModelPrecachedEx("models/w_models/weapons/w_grenade_launcher.mdl"))
		{
			Sum += GetConVarInt(l4d2_loot_sp_chance_explosive);
		}
		Sum += GetConVarInt(l4d2_loot_sp_chance_throw);
		Sum += GetConVarInt(l4d2_loot_sp_chance_upgrades);
		Sum += GetConVarInt(l4d2_loot_sp_chance_misc);
		Sum += GetConVarInt(l4d2_loot_sp_chance_misc2);
		Sum += GetConVarInt(l4d2_loot_sp_chance_nodrop);
		if (Sum > 0)
		{
			new Float:X = 100.0 / Sum;
			new Float:Y = GetRandomFloat(0.0, 100.0);
			new Float:A = 0.0;
			new Float:B = GetConVarInt(l4d2_loot_sp_chance_health) * X;
			if (Y >= A && Y < A + B)
			{
				// Health Based Items

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 1", BotDiedName);
#endif

				return 1;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_sp_chance_melee) * X;
			if (Y >= A && Y < A + B)
			{
				// Meele Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 2", BotDiedName);
#endif

				return 2;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_sp_chance_bullet) * X;
			if (Y >= A && Y < A + B)
			{
				// Bullet-Based Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 3", BotDiedName);
#endif

				return 3;
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_grenade_launcher.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_sp_chance_explosive) * X;
				if (Y >= A && Y < A + B)
				{
					// Explosive-Based Weapon

#if DEBUG
					PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 4", BotDiedName);
#endif

					return 4;
				}
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_sp_chance_throw) * X;
			if (Y >= A && Y < A + B)
			{
				// Throw-Based Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 5", BotDiedName);
#endif

				return 5;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_sp_chance_upgrades) * X;
			if (Y >= A && Y < A + B)
			{
				// Upgrades

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 6", BotDiedName);
#endif

				return 6;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_sp_chance_misc) * X;
			if (Y >= A && Y < A + B)
			{
				// Misc

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 7", BotDiedName);
#endif

				return 7;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_sp_chance_misc2) * X;
			if (Y >= A && Y < A + B)
			{
				// Misc 2

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 8", BotDiedName);
#endif

				return 8;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_sp_chance_nodrop) * X;
			if (Y >= A && Y < A + B)
			{
				// Spitter No-Drop

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 0 (spitter)", BotDiedName);
#endif

				return 0;
			}
		}
		else
		{
#if DEBUG
			PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 0 (else)", BotDiedName);
#endif

			return 0;
		}
	}
	if (StrEqual("Jockey", BotDiedName))
	{
		Sum = GetConVarInt(l4d2_loot_j_chance_health);
		Sum += GetConVarInt(l4d2_loot_j_chance_melee);
		Sum += GetConVarInt(l4d2_loot_j_chance_bullet);
		if (IsModelPrecachedEx("models/w_models/weapons/w_grenade_launcher.mdl"))
		{
			Sum += GetConVarInt(l4d2_loot_j_chance_explosive);
		}
		Sum += GetConVarInt(l4d2_loot_j_chance_throw);
		Sum += GetConVarInt(l4d2_loot_j_chance_upgrades);
		Sum += GetConVarInt(l4d2_loot_j_chance_misc);
		Sum += GetConVarInt(l4d2_loot_j_chance_misc2);
		Sum += GetConVarInt(l4d2_loot_j_chance_nodrop);
		if (Sum > 0)
		{
			new Float:X = 100.0 / Sum;
			new Float:Y = GetRandomFloat(0.0, 100.0);
			new Float:A = 0.0;
			new Float:B = GetConVarInt(l4d2_loot_j_chance_health) * X;
			if (Y >= A && Y < A + B)
			{
				// Health Based Items

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 1", BotDiedName);
#endif

				return 1;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_j_chance_melee) * X;
			if (Y >= A && Y < A + B)
			{
				// Meele Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 2", BotDiedName);
#endif

				return 2;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_j_chance_bullet) * X;
			if (Y >= A && Y < A + B)
			{
				// Bullet-Based Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 3", BotDiedName);
#endif

				return 3;
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_grenade_launcher.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_j_chance_explosive) * X;
				if (Y >= A && Y < A + B)
				{
					// Explosive-Based Weapon

#if DEBUG
					PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 4", BotDiedName);
#endif

					return 4;
				}
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_j_chance_throw) * X;
			if (Y >= A && Y < A + B)
			{
				// Throw-Based Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 5", BotDiedName);
#endif

				return 5;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_j_chance_upgrades) * X;
			if (Y >= A && Y < A + B)
			{
				// Upgrades

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 6", BotDiedName);
#endif

				return 6;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_j_chance_misc) * X;
			if (Y >= A && Y < A + B)
			{
				// Misc

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 7", BotDiedName);
#endif

				return 7;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_j_chance_misc2) * X;
			if (Y >= A && Y < A + B)
			{
				// Misc 2

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 8", BotDiedName);
#endif

				return 8;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_j_chance_nodrop) * X;
			if (Y >= A && Y < A + B)
			{
				// Jockey No-Drop

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 0 (jockey)", BotDiedName);
#endif

				return 0;
			}
		}
		else
		{
#if DEBUG
			PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 0 (else)", BotDiedName);
#endif

			return 0;
		}
	}
	if (StrEqual("Tank", BotDiedName))
	{
		Sum = GetConVarInt(l4d2_loot_t_chance_health);
		Sum += GetConVarInt(l4d2_loot_t_chance_melee);
		Sum += GetConVarInt(l4d2_loot_t_chance_bullet);
		if (IsModelPrecachedEx("models/w_models/weapons/w_grenade_launcher.mdl"))
		{
			Sum += GetConVarInt(l4d2_loot_t_chance_explosive);
		}
		Sum += GetConVarInt(l4d2_loot_t_chance_throw);
		Sum += GetConVarInt(l4d2_loot_t_chance_upgrades);
		Sum += GetConVarInt(l4d2_loot_t_chance_misc);
		Sum += GetConVarInt(l4d2_loot_t_chance_misc2);
		Sum += GetConVarInt(l4d2_loot_t_chance_nodrop);
		if (Sum > 0)
		{
			new Float:X = 100.0 / Sum;
			new Float:Y = GetRandomFloat(0.0, 100.0);
			new Float:A = 0.0;
			new Float:B = GetConVarInt(l4d2_loot_t_chance_health) * X;
			if (Y >= A && Y < A + B)
			{
				// Health Based Items

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 1", BotDiedName);
#endif

				return 1;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_t_chance_melee) * X;
			if (Y >= A && Y < A + B)
			{
				// Meele Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 2", BotDiedName);
#endif

				return 2;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_t_chance_bullet) * X;
			if (Y >= A && Y < A + B)
			{
				// Bullet-Based Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 3", BotDiedName);
#endif

				return 3;
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_grenade_launcher.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_t_chance_explosive) * X;
				if (Y >= A && Y < A + B)
				{
					// Explosive-Based Weapon

#if DEBUG
					PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 4", BotDiedName);
#endif

					return 4;
				}
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_t_chance_throw) * X;
			if (Y >= A && Y < A + B)
			{
				// Throw-Based Weapon

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 5", BotDiedName);
#endif

				return 5;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_t_chance_upgrades) * X;
			if (Y >= A && Y < A + B)
			{
				// Upgrades

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 6", BotDiedName);
#endif

				return 6;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_t_chance_misc) * X;
			if (Y >= A && Y < A + B)
			{
				// Misc

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 7", BotDiedName);
#endif

				return 7;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_t_chance_misc2) * X;
			if (Y >= A && Y < A + B)
			{
				// Misc 2

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 8", BotDiedName);
#endif

				return 8;
			}
			A = A + B;
			B = GetConVarInt(l4d2_loot_t_chance_nodrop) * X;
			if (Y >= A && Y < A + B)
			{
				// Tank No-Drop

#if DEBUG
				PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 0 (tank)", BotDiedName);
#endif

				return 0;
			}
		}
		else
		{
#if DEBUG
			PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 0 (else)", BotDiedName);
#endif

			return 0;
		}
	}

#if DEBUG
	PrintToChatAll("\x05 Function: \x04GetRandomGroup ( \x01%s\x04 ) : return 0 (end of function)", BotDiedName);
#endif

	return 0;
}

GetRandomItem(const Group)
{
#if DEBUG
	PrintToChatAll("\x05 Function: GetRandomItem ( %d )", Group);
#endif

	if (Group == 0)
	{

#if DEBUG
		PrintToChatAll("\x05 Function: GetRandomItem ( %d ) : return 0", Group);
#endif				
	
		return 0;
	}
	if (Group == 1)
	{
		new Sum = 0;
		if (IsModelPrecachedEx("models/w_models/weapons/w_eq_Medkit.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_first_aid_kit);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_eq_defibrillator.mdl"))
		{
			// 3 = "survival"
			if (GetGameMode() != 3)
			{
				Sum = Sum + GetConVarInt(l4d2_loot_defibrillator);
			}
			else if (GetConVarInt(DropDefibsOnSurvival) == 1)
			{
				Sum = Sum + GetConVarInt(l4d2_loot_defibrillator);
			}
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_eq_painpills.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_pain_pills);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_eq_adrenaline.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_adrenaline);
		}
		if (Sum > 0)
		{
			new Float:X = 100.0 / Sum;
			new Float:Y = GetRandomFloat(0.0, 100.0);
			new Float:A = 0.0;
			new Float:B = 0.0;
			if (IsModelPrecachedEx("models/w_models/weapons/w_eq_Medkit.mdl"))
			{
				B = GetConVarInt(l4d2_loot_first_aid_kit) * X;
				if (Y >= A && Y < A + B)
				{
					return 1;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_eq_defibrillator.mdl"))
			{
				// 3 = "survival"
				if (GetGameMode() != 3)
				{
					A = A + B;
					B = GetConVarInt(l4d2_loot_defibrillator) * X;
					if (Y >= A && Y < A + B)
					{
						return 2;
					}
				}
				else if (GetConVarInt(DropDefibsOnSurvival) == 1)
				{
					A = A + B;
					B = GetConVarInt(l4d2_loot_defibrillator) * X;
					if (Y >= A && Y < A + B)
					{
						return 2;
					}
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_eq_painpills.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_pain_pills) * X;
				if (Y >= A && Y < A + B)
				{
					return 3;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_eq_adrenaline.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_adrenaline) * X;
				if (Y >= A && Y < A + B)
				{
					return 4;
				}
			}
		}
		else
		{
		
#if DEBUG
			PrintToChatAll("\x05 Function: GetRandomItem ( %d ) : return 0", Group);
#endif				
		
			return 0;
		}
	}
	if (Group == 2)
	{
		new Sum = 0;
		if (IsModelPrecachedEx("models/weapons/melee/w_cricket_bat.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_cricket_bat);
		}
		if (IsModelPrecachedEx("models/weapons/melee/w_crowbar.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_crowbar);
		}
		if (IsModelPrecachedEx("models/weapons/melee/w_electric_guitar.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_electric_guitar);
		}
		if (IsModelPrecachedEx("models/weapons/melee/w_chainsaw.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_chainsaw);
		}
		if (IsModelPrecachedEx("models/weapons/melee/w_katana.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_katana);
		}
		if (IsModelPrecachedEx("models/weapons/melee/w_machete.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_machete);
		}
		if (IsModelPrecachedEx("models/weapons/melee/w_tonfa.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_tonfa);
		}
		if (IsModelPrecachedEx("models/weapons/melee/w_frying_pan.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_frying_pan);
		}
		if (IsModelPrecachedEx("models/weapons/melee/w_fireaxe.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_fireaxe);
		}
#if BASEBALL_BAT
		if (IsModelPrecachedEx("models/w_models/Weapons/w_bat.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_baseball_bat);
		}
#endif
#if CSS_WEAPONS
		if (IsModelPrecachedEx("models/w_models/weapons/w_knife_t.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_knife);
		}
#endif
#if RIOT_SHIELD
		if (IsModelPrecachedEx("models/weapons/melee/w_riotshield.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_riotshield);
		}
#endif
		if (IsModelPrecachedEx("models/weapons/melee/w_golfclub.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_golfclub);
		}
		if (Sum > 0)
		{
			new Float:X = 100.0 / Sum;
			new Float:Y = GetRandomFloat(0.0, 100.0);
			new Float:A = 0.0;
			new Float:B = 0.0;
			if (IsModelPrecachedEx("models/weapons/melee/w_cricket_bat.mdl"))
			{
				B = GetConVarInt(l4d2_loot_cricket_bat) * X;
				if (Y >= A && Y < A + B)
				{
					return 5;
				}
			}
			if (IsModelPrecachedEx("models/weapons/melee/w_crowbar.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_crowbar) * X;
				if (Y >= A && Y < A + B)
				{
					return 6;
				}
			}
			if (IsModelPrecachedEx("models/weapons/melee/w_electric_guitar.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_electric_guitar) * X;
				if (Y >= A && Y < A + B)
				{
					return 7;
				}
			}
			if (IsModelPrecachedEx("models/weapons/melee/w_chainsaw.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_chainsaw) * X;
				if (Y >= A && Y < A + B)
				{
					return 8;
				}
			}
			if (IsModelPrecachedEx("models/weapons/melee/w_katana.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_katana) * X;
				if (Y >= A && Y < A + B)
				{
					return 9;
				}
			}
			if (IsModelPrecachedEx("models/weapons/melee/w_machete.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_machete) * X;
				if (Y >= A && Y < A + B)
				{
					return 10;
				}
			}
			if (IsModelPrecachedEx("models/weapons/melee/w_tonfa.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_tonfa) * X;
				if (Y >= A && Y < A + B)
				{
					return 11;
				}
			}
			if (IsModelPrecachedEx("models/weapons/melee/w_frying_pan.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_frying_pan) * X;
				if (Y >= A && Y < A + B)
				{
					return 13;
				}
			}
			if (IsModelPrecachedEx("models/weapons/melee/w_fireaxe.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_fireaxe) * X;
				if (Y >= A && Y < A + B)
				{
					return 14;
				}
			}
#if BASEBALL_BAT
			if (IsModelPrecachedEx("models/w_models/Weapons/w_bat.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_baseball_bat) * X;
				if (Y >= A && Y < A + B)
				{
					return 12;
				}
			}
#endif
#if CSS_WEAPONS
			if (IsModelPrecachedEx("models/w_models/weapons/w_knife_t.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_knife) * X;
				if (Y >= A && Y < A + B)
				{
					return 40;
				}
			}
#endif			
			if (IsModelPrecachedEx("models/weapons/melee/w_golfclub.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_knife) * X;
				if (Y >= A && Y < A + B)
				{
					return 43;
				}
			}
#if RIOT_SHIELD
			if (IsModelPrecachedEx("models/weapons/melee/w_riotshield.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_riotshield) * X;
				if (Y >= A && Y < A + B)
				{
					return 45;
				}
			}
#endif
		}
		else
		{
		
#if DEBUG
			PrintToChatAll("\x05 Function: GetRandomItem ( %d ) : return 0", Group);
#endif		
		
			return 0;
		}
	}
	if (Group == 3)
	{
		new Sum = 0;
		if (IsModelPrecachedEx("models/w_models/weapons/w_pistol_B.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_pistol);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_desert_eagle.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_pistol_magnum);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_smg_uzi.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_smg);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_smg_a.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_smg_silenced);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_shotgun.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_pumpshotgun);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_pumpshotgun_A.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_shotgun_chrome);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_shotgun_spas.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_shotgun_spas);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_autoshot_m4super.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_autoshotgun);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_sniper_military.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_sniper_military);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_sniper_mini14.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_hunting_rifle);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_rifle_m16a2.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_rifle);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_desert_rifle.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_rifle_desert);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_rifle_ak47.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_rifle_ak47);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_m60.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_rifle_m60);
		}
#if CSS_WEAPONS
		if (IsModelPrecachedEx("models/w_models/weapons/w_smg_mp5.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_smg_mp5);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_sniper_scout.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_sniper_scout);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_sniper_awp.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_sniper_awp);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_rifle_sg552.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_rifle_sg552);
		}
#endif
		if (Sum > 0)
		{
			new Float:X = 100.0 / Sum;
			new Float:Y = GetRandomFloat(0.0, 100.0);
			new Float:A = 0.0;
			new Float:B = 0.0;
			if (IsModelPrecachedEx("models/w_models/weapons/w_pistol_B.mdl"))
			{
				B = GetConVarInt(l4d2_loot_pistol) * X;
				if (Y >= A && Y < A + B)
				{
					return 15;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_desert_eagle.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_pistol_magnum) * X;
				if (Y >= A && Y < A + B)
				{
					return 16;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_smg_uzi.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_smg) * X;
				if (Y >= A && Y < A + B)
				{
					return 17;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_smg_a.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_smg_silenced) * X;
				if (Y >= A && Y < A + B)
				{
					return 19;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_shotgun.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_pumpshotgun) * X;
				if (Y >= A && Y < A + B)
				{
					return 20;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_pumpshotgun_A.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_shotgun_chrome) * X;
				if (Y >= A && Y < A + B)
				{
					return 21;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_shotgun_spas.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_shotgun_spas) * X;
				if (Y >= A && Y < A + B)
				{
					return 22;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_autoshot_m4super.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_autoshotgun) * X;
				if (Y >= A && Y < A + B)
				{
					return 39;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_sniper_military.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_sniper_military) * X;
				if (Y >= A && Y < A + B)
				{
					return 24;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_sniper_mini14.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_hunting_rifle) * X;
				if (Y >= A && Y < A + B)
				{
					return 26;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_rifle_m16a2.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_rifle) * X;
				if (Y >= A && Y < A + B)
				{
					return 27;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_desert_rifle.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_rifle_desert) * X;
				if (Y >= A && Y < A + B)
				{
					return 28;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_rifle_ak47.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_rifle_ak47) * X;
				if (Y >= A && Y < A + B)
				{
					return 29;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_m60.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_rifle_m60) * X;
				if (Y >= A && Y < A + B)
				{
					return 44;
				}
			}
#if CSS_WEAPONS
			if (IsModelPrecachedEx("models/w_models/weapons/w_smg_mp5.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_smg_mp5) * X;
				if (Y >= A && Y < A + B)
				{
					return 18;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_sniper_scout.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_sniper_scout) * X;
				if (Y >= A && Y < A + B)
				{
					return 23;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_sniper_awp.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_sniper_awp) * X;
				if (Y >= A && Y < A + B)
				{
					return 25;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_rifle_sg552.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_rifle_sg552) * X;
				if (Y >= A && Y < A + B)
				{
					return 30;
				}
			}
#endif
		}
		else
		{
		
#if DEBUG
			PrintToChatAll("\x05 Function: GetRandomItem ( %d ) : return 0", Group);
#endif				
			return 0;
		}
	}
	if (Group == 4)
	{
		new Sum = GetConVarInt(l4d2_loot_grenade_launcher);
		if (Sum > 0)
		{
			new Float:X = 100.0 / Sum;
			new Float:Y = GetRandomFloat(0.0, 100.0);
			new Float:A = 0.0;
			new Float:B = GetConVarInt(l4d2_loot_grenade_launcher) * X;
			if (Y >= A && Y < A + B)
			{
				return 31;
			}
		}
		else
		{
		
#if DEBUG
			PrintToChatAll("\x05 Function: GetRandomItem ( %d ) : return 0", Group);
#endif				
		
			return 0;
		}
	}
	if (Group == 5)
	{
		new Sum = 0;
		if (IsModelPrecachedEx("models/w_models/weapons/w_eq_pipebomb.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_pipe_bomb);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_eq_molotov.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_molotov);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_eq_bile_flask.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_vomitjar);
		}
		if (Sum > 0)
		{
			new Float:X = 100.0 / Sum;
			new Float:Y = GetRandomFloat(0.0, 100.0);
			new Float:A = 0.0;
			new Float:B = 0.0;
			if (IsModelPrecachedEx("models/w_models/weapons/w_eq_pipebomb.mdl"))
			{
				B = GetConVarInt(l4d2_loot_pipe_bomb) * X;
				if (Y >= A && Y < A + B)
				{
					return 32;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_eq_molotov.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_molotov) * X;
				if (Y >= A && Y < A + B)
				{
					return 33;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_eq_bile_flask.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_vomitjar) * X;
				if (Y >= A && Y < A + B)
				{
					return 34;
				}
			}
		}
		else
		{
		
#if DEBUG
			PrintToChatAll("\x05 Function: GetRandomItem ( %d ) : return 0", Group);
#endif				
		
			return 0;
		}
	}
	if (Group == 6)
	{
		new Sum = 0;
		if (IsModelPrecachedEx("models/w_models/weapons/w_eq_explosive_ammopack.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_upgradepack_exp);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_eq_incendiary_ammopack.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_upgradepack_inc);
		}
		if (Sum > 0)
		{
			new Float:X = 100.0 / Sum;
			new Float:Y = GetRandomFloat(0.0, 100.0);
			new Float:A = 0.0;
			new Float:B = 0.0;
			if (IsModelPrecachedEx("models/w_models/weapons/w_eq_explosive_ammopack.mdl"))
			{
				B = GetConVarInt(l4d2_loot_upgradepack_exp) * X;
				if (Y >= A && Y < A + B)
				{
					return 35;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_eq_incendiary_ammopack.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_upgradepack_inc) * X;
				if (Y >= A && Y < A + B)
				{
					return 36;
				}
			}
		}
		else
		{
		
#if DEBUG
			PrintToChatAll("\x05 Function: GetRandomItem ( %d ) : return 0", Group);
#endif				
		
			return 0;
		}
	}
	if (Group == 7)
	{
		new Sum = 0;
		if (IsModelPrecachedEx("models/props_junk/explosive_box001.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_fireworkcrate);
		}
		if (GetGameMode() == 6 || GetGameMode() == 7)
		{
			if (GetConVarInt(DropGascansOnScavenge) == 1)
			{
				if (IsModelPrecachedEx("models/props_junk/gascan001a.mdl"))
				{
					Sum = Sum + GetConVarInt(l4d2_loot_gascan);
				}
			}
		}
		else if (IsModelPrecachedEx("models/props_junk/gascan001a.mdl"))
		{
			if (c1m4_atrium() && GetGameMode() < 3)
			{
				if (GetConVarInt(DropGascansOnScavenge) == 1)
				{
					Sum = Sum + GetConVarInt(l4d2_loot_gascan);
				}
			}
			else
			{
				Sum = Sum + GetConVarInt(l4d2_loot_gascan);
			}
		}
		if (IsModelPrecachedEx("models/props_equipment/oxygentank01.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_oxygentank);
		}
		if (IsModelPrecachedEx("models/props_junk/propanecanister001a.mdl"))
		{
			Sum = Sum + GetConVarInt(l4d2_loot_propanetank);
		}
		if (Sum > 0)
		{
			new Float:X = 100.0 / Sum;
			new Float:Y = GetRandomFloat(0.0, 100.0);
			new Float:A = 0.0;
			new Float:B = 0.0;
			if (IsModelPrecachedEx("models/props_junk/explosive_box001.mdl"))
			{
				B = GetConVarInt(l4d2_loot_fireworkcrate) * X;
				if (Y >= A && Y < A + B)
				{
					return 37;
				}
			}
			if (GetGameMode() == 6 || GetGameMode() == 7)
			{
				if (GetConVarInt(DropGascansOnScavenge) == 1)
				{
					if (IsModelPrecachedEx("models/props_junk/gascan001a.mdl"))
					{
						A = A + B;
						B = GetConVarInt(l4d2_loot_gascan) * X;
						if (Y >= A && Y < A + B)
						{
							return 38;
						}
					}
				}
			}
			else if (IsModelPrecachedEx("models/props_junk/gascan001a.mdl"))
			{
				if (c1m4_atrium() && GetGameMode() < 3)
				{
					if (GetConVarInt(DropGascansOnScavenge) == 1)
					{
						A = A + B;
						B = GetConVarInt(l4d2_loot_gascan) * X;
						if (Y >= A && Y < A + B)
						{
							return 38;
						}
					}
				}
				else
				{
					A = A + B;
					B = GetConVarInt(l4d2_loot_gascan) * X;
					if (Y >= A && Y < A + B)
					{
						return 38;
					}
				}
			}
			if (IsModelPrecachedEx("models/props_equipment/oxygentank01.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_oxygentank) * X;
				if (Y >= A && Y < A + B)
				{
					return 41;
				}
			}
			if (IsModelPrecachedEx("models/props_junk/propanecanister001a.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_propanetank) * X;
				if (Y >= A && Y < A + B)
				{
					return 42;
				}
			}
		}
		else
		{

#if DEBUG
			PrintToChatAll("\x05 Function: GetRandomItem ( %d ) : return 0", Group);
#endif				
		
			return 0;
		}
	}
	if (Group == 8)
	{
		new Sum = 0;
		if (IsModelPrecachedEx("models/props_junk/gnome.mdl"))
		{
			Sum += GetConVarInt(l4d2_loot_gnome);
		}
		if (IsModelPrecachedEx("models/w_models/weapons/w_cola.mdl"))
		{
			Sum += GetConVarInt(l4d2_loot_cola_bottles);
		}
		if (Sum > 0)
		{
			new Float:X = 100.0 / Sum;
			new Float:Y = GetRandomFloat(0.0, 100.0);
			new Float:A = 0.0;
			new Float:B = 0.0;
			if (IsModelPrecachedEx("models/props_junk/gnome.mdl"))
			{
				B = GetConVarInt(l4d2_loot_gnome) * X;
				if (Y >= A && Y < A + B)
				{
					return 46;
				}
			}
			if (IsModelPrecachedEx("models/w_models/weapons/w_cola.mdl"))
			{
				A = A + B;
				B = GetConVarInt(l4d2_loot_cola_bottles) * X;
				if (Y >= A && Y < A + B)
				{
					return 47;
				}
			}
		}
	}

#if DEBUG
	PrintToChatAll("\x05 Function: GetRandomItem ( %d ) : return 0");
#endif				
	
	return 0;
}

public LootDropItem(any:client, ItemNumber)
{
	if (GetConVarInt(IsPluginEnabled) < 1) return;
#if DEBUG
	PrintToChatAll("\x05Function: LootDropItem (%d)", ItemNumber);
#endif
	if (IsMapFinished > 0)
	{
		if (GetConVarInt(NoFarm) > 0)
			return;
	}
		
	if (ItemNumber > 0)
	{
		new String:ItemName[24];
		switch (ItemNumber)
		{
			case 1: ItemName = "first_aid_kit";
			case 2: ItemName = "defibrillator";
			case 3: ItemName = "pain_pills";
			case 4: ItemName = "adrenaline";
			case 5: ItemName = "cricket_bat";
			case 6: ItemName = "crowbar";
			case 7: ItemName = "electric_guitar";
			case 8: ItemName = "chainsaw";
			case 9: ItemName = "katana";
			case 10: ItemName = "machete";
			case 11: ItemName = "tonfa";
			case 12: ItemName = "baseball_bat";
			case 13: ItemName = "frying_pan";
			case 14: ItemName = "fireaxe";
			case 15: ItemName = "pistol";
			case 16: ItemName = "pistol_magnum";
			case 17: ItemName = "smg";
			case 18: ItemName = "smg_mp5"; // need precache
			case 19: ItemName = "smg_silenced";
			case 20: ItemName = "pumpshotgun";
			case 21: ItemName = "shotgun_chrome";
			case 22: ItemName = "shotgun_spas";
			case 23: ItemName = "sniper_scout"; // need precache
			case 24: ItemName = "sniper_military";
			case 25: ItemName = "sniper_awp"; // need precache
			case 26: ItemName = "hunting_rifle";
			case 27: ItemName = "rifle";
			case 28: ItemName = "rifle_desert";
			case 29: ItemName = "rifle_ak47";
			case 30: ItemName = "rifle_sg552"; // need precache
			case 31: ItemName = "grenade_launcher";
			case 32: ItemName = "pipe_bomb";
			case 33: ItemName = "molotov";
			case 34: ItemName = "vomitjar";
			case 35: ItemName = "upgradepack_explosive";
			case 36: ItemName = "upgradepack_incendiary";
			case 37: ItemName = "fireworkcrate";
			case 38: ItemName = "gascan";
			case 39: ItemName = "autoshotgun";
			case 40: ItemName = "knife"; // protected
			case 41: ItemName = "oxygentank";
			case 42: ItemName = "propanetank";
			case 43: ItemName = "golfclub";
			case 44: ItemName = "rifle_m60"; // need precache on some maps
			case 45: ItemName = "riotshield"; // need precache on some maps
			case 46: ItemName = "gnome"; // need precache on some maps
			case 47: ItemName = "cola_bottles"; // need precache on some maps
		}
		
		new flags = GetCommandFlags("give");
		SetCommandFlags("give", flags & ~FCVAR_CHEAT);

#if PRINT_DROP
		PrintToServer("[L4D2LOOT] LOOT :: %s", ItemName);
#endif		

		FakeClientCommand(client, "give %s", ItemName);
		SetCommandFlags("give", flags);
	}
}

bool:IsModelPrecachedEx(const String:ModelName[])
{
	if (GetConVarInt(CheckPrechachedModels)) return IsModelPrecached(ModelName);
	return true;
}