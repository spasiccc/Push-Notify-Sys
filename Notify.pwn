	
	@ Script Name: Push Notify
	@ Author: Spasic Jovan (Spasic)
	@ Author Contat: https://www.facebook.com/profile.php?id=100074875885781&mibextid=ZbWKwL

	@ Request: https://github.com/pawn-lang/YSI-Includes/releases/tag/v5.10.0006
		   https://github.com/IS4Code/YSF/releases
	
	Example: NotifyShow(playerid, -654311169, "ADMIN COMMAND~n~Uspesno ste se %s", 5000, GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK ? "Unistili Jetpack" : "Stvorili Jetpack");


#include <a_samp>
#include <YSF>

#include <YSI_Storage\y_ini>
#include <YSI_Coding\y_timers>

new PlayerText:p_NotifyTD[MAX_PLAYERS][2] = { PlayerText:INVALID_TEXT_DRAW, ...},
	notifyCheking[MAX_PLAYERS],
	notifyChekingDestroy[MAX_PLAYERS],

	Timer:T_NotifyDestroy[MAX_PLAYERS],
	Timer:T_NotifyStart[MAX_PLAYERS];



enum e_TIMER_TYPE
{
    NOTIFY_DESTROY_TIMER,
    NOTIFY_START_TIMER
};

stock NotifyShow(playerid, color, const text[], showtime = 0, va_args<>) 
{
    if(p_NotifyTD[playerid][0] == PlayerText:INVALID_TEXT_DRAW)
    {
        p_NotifyTD[playerid][0] = CreatePlayerTextDraw(playerid, -80.8989, 124.044425, "!");
        PlayerTextDrawLetterSize(playerid, p_NotifyTD[playerid][0], 0.470958, 2.374411);
        PlayerTextDrawAlignment(playerid, p_NotifyTD[playerid][0], 1);
        PlayerTextDrawColor(playerid, p_NotifyTD[playerid][0], -5963521);
        PlayerTextDrawSetShadow(playerid, p_NotifyTD[playerid][0], 0);
        PlayerTextDrawBackgroundColor(playerid, p_NotifyTD[playerid][0], 255);
        PlayerTextDrawFont(playerid, p_NotifyTD[playerid][0], 0);
        PlayerTextDrawSetProportional(playerid, p_NotifyTD[playerid][0], true);

        p_NotifyTD[playerid][1] = CreatePlayerTextDraw(playerid, -70.498894, 126.118537, "KOMANDA_KOJU_STE_UNIJELI NE_POSTOJI");
        PlayerTextDrawLetterSize(playerid, p_NotifyTD[playerid][1], 0.146248, 0.870832);
        PlayerTextDrawAlignment(playerid, p_NotifyTD[playerid][1], 1);
        PlayerTextDrawColor(playerid, p_NotifyTD[playerid][1], -1);
        PlayerTextDrawSetShadow(playerid, p_NotifyTD[playerid][1], false);
        PlayerTextDrawBackgroundColor(playerid, p_NotifyTD[playerid][1], 255);
        PlayerTextDrawFont(playerid, p_NotifyTD[playerid][1], 2);
        PlayerTextDrawSetProportional(playerid, p_NotifyTD[playerid][1], true);
    }

    PlayerTextDrawSetPos(playerid, p_NotifyTD[playerid][0], -113.8989, 124.627761);

    PlayerTextDrawSetPos(playerid, p_NotifyTD[playerid][1], -105.498894, 129.668655);

    for(new i = 0; i < 2; i ++)
        PlayerTextDrawHide(playerid, p_NotifyTD[playerid][i]);


    if(notifyCheking[playerid]) 
        stop T_NotifyStart[playerid]; 

    if(notifyChekingDestroy[playerid]) 
    { 
        stop T_NotifyDestroy[playerid]; 
        notifyChekingDestroy[playerid] = false; 
    }


    if(showtime > 0) T_NotifyDestroy[playerid] = defer StartTimers[showtime](playerid, NOTIFY_DESTROY_TIMER);

    notifyChekingDestroy[playerid] = true;

    PlayerTextDrawColour(playerid, p_NotifyTD[playerid][0], color);
    PlayerTextDrawSetString(playerid, p_NotifyTD[playerid][1], va_return(text, va_start<4>));

    notifyCheking[playerid] = true;

    T_NotifyStart[playerid] = repeat StartTimers[15](playerid, NOTIFY_START_TIMER);
    return true;
}

timer StartTimers[1000](playerid, e_TIMER_TYPE:type)
{
    switch(type)
    {
	case NOTIFY_START_TIMER:
        {
            static Float:X, Float:Y;

            for(new i = 0; i < 2; i ++)
            {
                PlayerTextDrawGetPos(playerid, p_NotifyTD[playerid][i], X, Y);

                X = X+3.0; //3.0 clasic speed

                PlayerTextDrawSetPos(playerid, p_NotifyTD[playerid][i], X, Y);

                PlayerTextDrawShow(playerid, p_NotifyTD[playerid][i]);

                PlayerTextDrawGetPos(playerid, p_NotifyTD[playerid][0], X, Y);
            }   
            if(X >= 11.108459)
            {
                stop T_NotifyStart[playerid]; 
                notifyCheking[playerid] = false;
            }
        }

        case NOTIFY_DESTROY_TIMER:
        {
            for(new i = 0; i < 2; i ++)
            {
                PlayerTextDrawHide(playerid, p_NotifyTD[playerid][i]);
            }
            notifyChekingDestroy[playerid] = false; 
        }
     }
}