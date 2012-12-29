Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab2L2WfH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 17:35:07 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:54887 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab2L2WfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 17:35:04 -0500
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Sat, 29 Dec 2012 23:34:16 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: Dmitry Voytik <dvv.kernel@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH 1/2] nconf:  add keybindings for vi-style menu navigation,
 rewrite help texts
Message-ID: <20121229223415.GB28355@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: Dmitry Voytik <dvv.kernel@gmail.com>,
	Michal Marek <mmarek@suse.cz>, Stephen Boyd <sboyd@codeaurora.org>,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
References: <20121228185108.GA13644@voyt-hp>
 <1356723607-17027-1-git-send-email-dvv.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <1356723607-17027-1-git-send-email-dvv.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-12-28 Friday at 23:40 +0400 Dmitry Voytik wrote:
> Add alternative vi-style keys for the menu navigation:
> <j>/<k> for down/up navigation, <C-f>/<C-b> for
> page down/up, <g>/<G> for first/last menu item selection
> and <l> for entering to a submenu.

Good starting point, thanks for your initial work.
Here is completion of the work:


>From: Roland Eggner <edvx1@systemanalysen.net>

=E2=80=A2  Completed vi-style navigation <k> <j> <l> <h>.  Using <?> <H> in=
stead of
   <?> <h> for help related to current menu entry avoids conflict.

=E2=80=A2  Added keybindings <C-n> <C-p> additionally to <C-f> <C-b> for mo=
ving pagewise
   down and up.  <C-f> <C-b> is used for characterwise right and left movem=
ent
   by libreadline (bash, xfsprogs, bc, gdb, python, ruby, hunspell, mysql,
   sqlite, gnupg, xine-ui, parted =E2=80=A6).  Thus pagewise movement by <C=
-n> <C-p> is
   less confusing than by <C-f> <C-b> for my fingers.

=E2=80=A2  Rewrote all help texts.  During several years lazy (incomplete) =
updates had
   left behind a rather thick layer of dust.  Intentions:
   (1)  Global help called by <F1> should document  _all_  implemented
	keybindings.
   (2)  Different help texts called by <F3> resp. <F8><F1> should be consis=
tent
	with (1) and with implementation:
	=E2=80=A2  on plain menu entry
	=E2=80=A2  in radiolist window
      	=E2=80=A2  in input windows for text, decimal or hexadecimal values
      	=E2=80=A2  in filename selection windows <F6> <F7>
      	=E2=80=A2  SymSearch specific help called by <F8> followed by <F1>

=E2=80=A2  Function keys line:  =E2=80=9CHelp 2=E2=80=9D instead of =E2=80=
=9CInsts=E2=80=9D and =E2=80=9CShowAll=E2=80=9D instead of
   =E2=80=9CConfig=E2=80=9D should be more intuitiv.

Signed-off-by: Dmitry Voytik <dvv.kernel@gmail.com>
Signed-off-by: Roland Eggner <edvx1@systemanalysen.net>
---
--- a/scripts/kconfig/nconf.c	2012-08-19 19:15:38.000000000 +0200
+++ b/scripts/kconfig/nconf.c	2012-12-29 21:21:11.109733174 +0100
@@ -12,210 +12,196 @@
 #include "nconf.h"
 #include <ctype.h>
=20
-static const char nconf_readme[] =3D N_(
-"Overview\n"
-"--------\n"
-"This interface let you select features and parameters for the build.\n"
-"Features can either be built-in, modularized, or ignored. Parameters\n"
-"must be entered in as decimal or hexadecimal numbers or text.\n"
-"\n"
-"Menu items beginning with following braces represent features that\n"
-"  [ ] can be built in or removed\n"
-"  < > can be built in, modularized or removed\n"
-"  { } can be built in or modularized (selected by other feature)\n"
-"  - - are selected by other feature,\n"
-"  XXX cannot be selected. Use Symbol Info to find out why,\n"
-"while *, M or whitespace inside braces means to build in, build as\n"
-"a module or to exclude the feature respectively.\n"
-"\n"
-"To change any of these features, highlight it with the cursor\n"
-"keys and press <Y> to build it in, <M> to make it a module or\n"
-"<N> to removed it.  You may also press the <Space Bar> to cycle\n"
-"through the available options (ie. Y->N->M->Y).\n"
-"\n"
-"Some additional keyboard hints:\n"
-"\n"
-"Menus\n"
-"----------\n"
-"o  Use the Up/Down arrow keys (cursor keys) to highlight the item\n"
-"   you wish to change use <Enter> or <Space>. Goto submenu by \n"
-"   pressing <Enter> of <right-arrow>. Use <Esc> or <left-arrow> to go bac=
k.\n"
-"   Submenus are designated by \"--->\".\n"
-"\n"
-"   Searching: pressing '/' triggers interactive search mode.\n"
-"              nconfig performs a case insensitive search for the string\n"
-"              in the menu prompts (no regex support).\n"
-"              Pressing the up/down keys highlights the previous/next\n"
-"              matching item. Backspace removes one character from the\n"
-"              match string. Pressing either '/' again or ESC exits\n"
-"              search mode. All other keys behave normally.\n"
-"\n"
-"   You may also use the <PAGE UP> and <PAGE DOWN> keys to scroll\n"
-"   unseen options into view.\n"
-"\n"
-"o  To exit a menu use the just press <ESC> <F5> <F8> or <left-arrow>.\n"
+#define KEY_CONTROL(k) ((k) & 0x1f)
+
+static const char nconf_global_help[] =3D N_(
+"Help windows\n"
+"------------\n"
+"o  Global help:  Unless in a data entry window, key <F1> will give you\n"
+"   the global help window, which you are just reading.\n"
+"\n"
+"o  A short version of the global help is available by key <F3>.\n"
+"\n"
+"o  Local help:  To get help related to the current menu entry, use any\n"
+"   of <?> <H> keys, or if in a data entry window then use <F1> key.\n"
+"\n"
+"\n"
+"Menu entries\n"
+"------------\n"
+"This interface lets you select features and parameters for the kernel\n"
+"build.  Kernel features can either be built-in, modularized, or removed.\=
n"
+"Parameters must be entered as decimal or hexadecimal numbers or text.\n"
+"\n"
+"Menu entries beginning with following braces represent features that\n"
+"  [ ]  can be built in or removed\n"
+"  < >  can be built in, modularized or removed\n"
+"  { }  can be built in or modularized, are selected by another feature\n"
+"  - -  are selected by another feature\n"
+"  XXX  cannot be selected.  Symbol Info <F2> tells you why.\n"
+"*, M or whitespace inside braces means to build in, build as a module\n"
+"or to exclude the feature respectively.\n"
+"\n"
+"To change any of these features, highlight it with the movement keys\n"
+"listed below and press <y> to build it in, <m> to make it a module or\n"
+"<n> to remove it.  You may press the <Space> key to cycle through the\n"
+"available options.\n"
+"\n"
+"A trailing \"--->\" designates a submenu.\n"
+"\n"
+"\n"
+"Menu navigation keys        plain style             vi-style\n"
+"----------------------------------------------------------------------\n"
+"Linewise up                 <Up>                    <k>\n"
+"Linewise down               <Down>                  <j>\n"
+"Pagewise up                 <Page Up>               <Ctrl-b>  <Ctrl-p>\n"
+"Pagewise down               <Page Down>             <Ctrl-f>  <Ctrl-n>\n"
+"First entry                 <Home>                  <g>\n"
+"Last entry                  <End>                   <G>\n"
+"Enter a submenu             <Right>  <Enter>        <l>\n"
+"Go back to parent menu      <Left>   <Esc>  <F5>    <h>\n"
+"Close a help window         <Enter>  <Esc>  <F5>\n"
+"Close entry window, apply   <Enter>\n"
+"Close entry window, forget  <Esc>  <F5>\n"
+"Start incremental, case-insensitive search for STRING in menu entries,\n"
+"    no regex support, STRING is displayed in upper left corner\n"
+"                            </>STRING\n"
+"    Remove last character   <Backspace>\n"
+"    Jump to next hit        <Down>\n"
+"    Jump to previous hit    <Up>\n"
+"Exit menu search mode       </>  <Esc>\n"
+"Search for configuration variables with or without leading CONFIG_\n"
+"                            <F8>RegExpr<Enter>\n"
+"Verbose search help         <F8><F1>\n"
 "\n"
-"o  To get help with an item, press <F1>\n"
-"   Shortcut: Press <h> or <?>.\n"
+"Unless in a data entry window, key <1> may be used instead of <F1>,\n"
+"<2> instead of <F2>, etc.\n"
 "\n"
 "\n"
 "Radiolists  (Choice lists)\n"
-"-----------\n"
-"o  Use the cursor keys to select the option you wish to set and press\n"
-"   <S> or the <SPACE BAR>.\n"
-"\n"
-"   Shortcut: Press the first letter of the option you wish to set then\n"
-"             press <S> or <SPACE BAR>.\n"
-"\n"
-"o  To see available help for the item, press <F1>\n"
-"   Shortcut: Press <H> or <?>.\n"
-"\n"
-"\n"
-"Data Entry\n"
-"-----------\n"
-"o  Enter the requested information and press <ENTER>\n"
-"   If you are entering hexadecimal values, it is not necessary to\n"
-"   add the '0x' prefix to the entry.\n"
+"--------------------------\n"
+"Use the movement keys listed above to select the option you wish to set\n"
+"and press <s> or <Space>.\n"
 "\n"
-"o  For help, press <F1>.\n"
 "\n"
-"\n"
-"Text Box    (Help Window)\n"
-"--------\n"
-"o  Use the cursor keys to scroll up/down/left/right.  The VI editor\n"
-"   keys h,j,k,l function here as do <SPACE BAR> for those\n"
-"   who are familiar with less and lynx.\n"
-"\n"
-"o  Press <Enter>, <F1>, <F5>, <F7> or <Esc> to exit.\n"
+"Data entry\n"
+"----------\n"
+"Enter the requested information and press <Enter>.  Hexadecimal values\n"
+"may be entered without \"0x\" prefix.\n"
 "\n"
 "\n"
-"Alternate Configuration Files\n"
+"Alternate configuration files\n"
 "-----------------------------\n"
-"nconfig supports the use of alternate configuration files for\n"
-"those who, for various reasons, find it necessary to switch\n"
-"between different configurations.\n"
-"\n"
-"At the end of the main menu you will find two options.  One is\n"
-"for saving the current configuration to a file of your choosing.\n"
-"The other option is for loading a previously saved alternate\n"
-"configuration.\n"
-"\n"
-"Even if you don't use alternate configuration files, but you\n"
-"find during a nconfig session that you have completely messed\n"
-"up your settings, you may use the \"Load Alternate...\" option to\n"
-"restore your previously saved settings from \".config\" without\n"
-"restarting nconfig.\n"
-"\n"
-"Other information\n"
-"-----------------\n"
-"If you use nconfig in an XTERM window make sure you have your\n"
-"$TERM variable set to point to a xterm definition which supports color.\n"
-"Otherwise, nconfig will look rather bad.  nconfig will not\n"
-"display correctly in a RXVT window because rxvt displays only one\n"
-"intensity of color, bright.\n"
-"\n"
-"nconfig will display larger menus on screens or xterms which are\n"
-"set to display more than the standard 25 row by 80 column geometry.\n"
-"In order for this to work, the \"stty size\" command must be able to\n"
-"display the screen's current row and column geometry.  I STRONGLY\n"
-"RECOMMEND that you make sure you do NOT have the shell variables\n"
-"LINES and COLUMNS exported into your environment.  Some distributions\n"
-"export those variables via /etc/profile.  Some ncurses programs can\n"
-"become confused when those variables (LINES & COLUMNS) don't reflect\n"
-"the true screen size.\n"
-"\n"
-"Optional personality available\n"
-"------------------------------\n"
-"If you prefer to have all of the options listed in a single menu, rather\=
n"
-"than the default multimenu hierarchy, run the nconfig with NCONFIG_MODE\n"
-"environment variable set to single_menu. Example:\n"
+"nconfig supports switching between different configurations.\n"
+"Use <F6> to save your current configuration.  Use <F7> and enter a\n"
+"file name to load a previously saved configuration.\n"
+"\n"
+"\n"
+"Terminal configuration\n"
+"----------------------\n"
+"If you use nconfig in a xterm window, make sure your TERM environment\n"
+"variable specifies a terminal configuration which supports at least\n"
+"16 colors.  Otherwise nconfig will look rather bad.\n"
+"\n"
+"If the \"stty size\" command reports the current terminalsize correctly,\=
n"
+"nconfig will adapt to sizes larger than the traditional 80x25 \"standard\=
"\n"
+"and display longer menus properly.\n"
+"\n"
+"\n"
+"Single menu mode\n"
+"----------------\n"
+"If you prefer to have all of the menu entries listed in a single menu,\n"
+"rather than the default multimenu hierarchy, run nconfig with\n"
+"NCONFIG_MODE environment variable set to single_menu.  Example:\n"
 "\n"
 "make NCONFIG_MODE=3Dsingle_menu nconfig\n"
 "\n"
-"<Enter> will then unroll the appropriate category, or enfold it if it\n"
-"is already unrolled.\n"
+"<Enter> will then unfold the appropriate category, or fold it if it\n"
+"is already unfolded.  Folded menu entries will be designated by a\n"
+"leading \"++>\" and unfolded entries by a leading \"-->\".\n"
 "\n"
-"Note that this mode can eventually be a little more CPU expensive\n"
-"(especially with a larger number of unrolled categories) than the\n"
-"default mode.\n"
+"Note that this mode can eventually be a little more CPU expensive than\n"
+"the default mode, especially with a larger number of unfolded submenus.\n"
 "\n"),
 menu_no_f_instructions[] =3D N_(
-" You do not have function keys support. Please follow the\n"
-" following instructions:\n"
-" Arrow keys navigate the menu.\n"
-" <Enter> or <right-arrow> selects submenus --->.\n"
-" Capital Letters are hotkeys.\n"
-" Pressing <Y> includes, <N> excludes, <M> modularizes features.\n"
-" Pressing SpaceBar toggles between the above options.\n"
-" Press <Esc> or <left-arrow> to go back one menu,\n"
-" <?> or <h> for Help, </> for Search.\n"
-" <1> is interchangeable with <F1>, <2> with <F2>, etc.\n"
-" Legend: [*] built-in  [ ] excluded  <M> module  < > module capable.\n"
-" <Esc> always leaves the current window.\n"),
+"Legend:  [*] built-in  [ ] excluded  <M> module  < > module capable.\n"
+"Submenus are designated by a trailing \"--->\".\n"
+"\n"
+"Use the following keys to navigate the menus:\n"
+"Move up or down by any of <Up> <Down> <k> <j> keys.\n"
+"To enter a submenu use any of <Enter> <Right> <l> keys.\n"
+"To go back to the parent menu use any of <Esc> <Left> <h> keys.\n"
+"Pressing <y> includes, <n> excludes, <m> modularizes features.\n"
+"Pressing <Space> cycles through the available options.\n"
+"To search for menu entries use key </>.\n"
+"<Esc> always leaves the current window.\n"
+"\n"
+"You do not have function keys support.\n"
+"Use key <1> instead of <F1>, <2> instead of <F2>, etc.\n"
+"For verbose global help use key <1>.\n"
+"For help related to the current menu entry use any of <?> <H> keys.\n"),
 menu_instructions[] =3D N_(
-" Arrow keys navigate the menu.\n"
-" <Enter> or <right-arrow> selects submenus --->.\n"
-" Capital Letters are hotkeys.\n"
-" Pressing <Y> includes, <N> excludes, <M> modularizes features.\n"
-" Pressing SpaceBar toggles between the above options\n"
-" Press <Esc>, <F5> or <left-arrow> to go back one menu,\n"
-" <?>, <F1> or <h> for Help, </> for Search.\n"
-" <1> is interchangeable with <F1>, <2> with <F2>, etc.\n"
-" Legend: [*] built-in  [ ] excluded  <M> module  < > module capable.\n"
-" <Esc> always leaves the current window\n"),
+"Legend:  [*] built-in  [ ] excluded  <M> module  < > module capable.\n"
+"Submenus are designated by a trailing \"--->\".\n"
+"\n"
+"Use the following keys to navigate the menus:\n"
+"Move up or down by any of <Up> <Down> <k> <j> keys.\n"
+"To enter a submenu use any of <Enter> <Right> <l> keys.\n"
+"To go back to the parent menu use any of <Esc> <Left> <h> keys.\n"
+"Pressing <y> includes, <n> excludes, <m> modularizes features.\n"
+"Pressing <Space> cycles through the available options.\n"
+"To search for menu entries use key </>.\n"
+"<Esc> always leaves the current window.\n"
+"\n"
+"Key <1> may be used instead of <F1>, <2> instead of <F2>, etc.\n"
+"For verbose global help use key <F1>.\n"
+"For help related to the current menu entry use any of <?> <H> keys.\n"),
 radiolist_instructions[] =3D N_(
-" Use the arrow keys to navigate this window or\n"
-" press the hotkey of the item you wish to select\n"
-" followed by the <SPACE BAR>.\n"
-" Press <?>, <F1> or <h> for additional information about this option.\n"),
+"Use <Up> <Down> <Home> <End> <k> <j> <g> <G> keys to navigate this\n"
+"radiolist followed by the <Space>.\n"
+"For help related to the current entry use any of <?> <H> keys.\n"
+"For global help use key <F1>.\n"),
 inputbox_instructions_int[] =3D N_(
 "Please enter a decimal value.\n"
 "Fractions will not be accepted.\n"
-"Press <RETURN> to accept, <ESC> to cancel."),
+"Press <Enter> to apply, <Esc> to cancel."),
 inputbox_instructions_hex[] =3D N_(
 "Please enter a hexadecimal value.\n"
-"Press <RETURN> to accept, <ESC> to cancel."),
+"Press <Enter> to apply, <Esc> to cancel."),
 inputbox_instructions_string[] =3D N_(
 "Please enter a string value.\n"
-"Press <RETURN> to accept, <ESC> to cancel."),
+"Press <Enter> to apply, <Esc> to cancel."),
 setmod_text[] =3D N_(
-"This feature depends on another which\n"
-"has been configured as a module.\n"
-"As a result, this feature will be built as a module."),
+"This feature depends on another feature which has been configured as a\n"
+"module.  As a result, the current feature will be built as a module too."=
),
 load_config_text[] =3D N_(
 "Enter the name of the configuration file you wish to load.\n"
-"Accept the name shown to restore the configuration you\n"
-"last retrieved.  Leave blank to abort."),
+"Accept the name shown to restore the configuration you retrieved\n"
+"last.  Leave blank to abort."),
 load_config_help[] =3D N_(
-"\n"
 "For various reasons, one may wish to keep several different\n"
 "configurations available on a single machine.\n"
 "\n"
 "If you have saved a previous configuration in a file other than the\n"
-"default one, entering its name here will allow you to modify that\n"
-"configuration.\n"
+"default one, entering its name here will allow you to load and modify\n"
+"that configuration.\n"
 "\n"
-"If you are uncertain, then you have probably never used alternate\n"
-"configuration files.  You should therefor leave this blank to abort.\n"),
+"Leave blank to abort.\n"),
 save_config_text[] =3D N_(
 "Enter a filename to which this configuration should be saved\n"
 "as an alternate.  Leave blank to abort."),
 save_config_help[] =3D N_(
-"\n"
-"For various reasons, one may wish to keep different configurations\n"
-"available on a single machine.\n"
+"For various reasons, one may wish to keep several different\n"
+"configurations available on a single machine.\n"
 "\n"
 "Entering a file name here will allow you to later retrieve, modify\n"
 "and use the current configuration as an alternate to whatever\n"
 "configuration options you have selected at that time.\n"
 "\n"
-"If you are uncertain what all this means then you should probably\n"
-"leave this blank.\n"),
+"Leave blank to abort.\n"),
 search_help[] =3D N_(
-"\n"
-"Search for symbols and display their relations. Regular expressions\n"
-"are allowed.\n"
-"Example: search for \"^FOO\"\n"
+"Search for symbols (configuration variable names CONFIG_*) and display\n"
+"their relations.  Regular expressions are supported.\n"
+"Example:  Search for \"^FOO\".\n"
 "Result:\n"
 "-----------------------------------------------------------------\n"
 "Symbol: FOO [ =3D m]\n"
@@ -229,26 +215,26 @@ search_help[] =3D N_(
 "Selects: LIBCRC32\n"
 "Selected by: BAR\n"
 "-----------------------------------------------------------------\n"
-"o The line 'Prompt:' shows the text used in the menu structure for\n"
-"  this symbol\n"
-"o The 'Defined at' line tell at what file / line number the symbol\n"
-"  is defined\n"
-"o The 'Depends on:' line tell what symbols needs to be defined for\n"
-"  this symbol to be visible in the menu (selectable)\n"
-"o The 'Location:' lines tell where in the menu structure this symbol\n"
-"  is located\n"
-"    A location followed by a [ =3D y] indicate that this is a selectable\=
n"
-"    menu item - and current value is displayed inside brackets.\n"
-"o The 'Selects:' line tell what symbol will be automatically\n"
-"  selected if this symbol is selected (y or m)\n"
-"o The 'Selected by' line tell what symbol has selected this symbol\n"
+"o  The line 'Prompt:' shows the menu text displayed for this symbol in\n"
+"   the menu hierarchy.\n"
+"o  The 'Defined at' line tells at what file / line number the symbol is\n"
+"   defined.\n"
+"o  The 'Depends on:' line tells, what symbols need to be defined for\n"
+"   this symbol to be visible and selectable in the menu.\n"
+"o  The 'Location:' lines tell, where in the menu structure this symbol\n"
+"   is located.  A location followed by a [ =3D y] indicates that this is\=
n"
+"   a selectable menu item, and the current value is displayed inside\n"
+"   brackets.\n"
+"o  The 'Selects:' line tells, what symbol will be automatically selected\=
n"
+"   if this symbol is selected (y or m).\n"
+"o  The 'Selected by' line tells what symbol has selected this symbol.\n"
 "\n"
 "Only relevant lines are shown.\n"
 "\n\n"
 "Search examples:\n"
-"Examples: USB  =3D> find all symbols containing USB\n"
-"          ^USB =3D> find all symbols starting with USB\n"
-"          USB$ =3D> find all symbols ending with USB\n"
+"USB  =3D> find all symbols containing USB\n"
+"^USB =3D> find all symbols starting with USB\n"
+"USB$ =3D> find all symbols ending with USB\n"
 "\n");
=20
 struct mitem {
@@ -319,19 +305,19 @@ struct function_keys function_keys[] =3D {
 	},
 	{
 		.key_str =3D "F2",
-		.func =3D "Sym Info",
+		.func =3D "SymInfo",
 		.key =3D F_SYMBOL,
 		.handler =3D handle_f2,
 	},
 	{
 		.key_str =3D "F3",
-		.func =3D "Insts",
+		.func =3D "Help 2",
 		.key =3D F_INSTS,
 		.handler =3D handle_f3,
 	},
 	{
 		.key_str =3D "F4",
-		.func =3D "Config",
+		.func =3D "ShowAll",
 		.key =3D F_CONF,
 		.handler =3D handle_f4,
 	},
@@ -355,7 +341,7 @@ struct function_keys function_keys[] =3D {
 	},
 	{
 		.key_str =3D "F8",
-		.func =3D "Sym Search",
+		.func =3D "SymSearch",
 		.key =3D F_SEARCH,
 		.handler =3D handle_f8,
 	},
@@ -392,7 +378,7 @@ static void print_function_line(void)
 static void handle_f1(int *key, struct menu *current_item)
 {
 	show_scroll_win(main_window,
-			_("README"), _(nconf_readme));
+			_("Global help"), _(nconf_global_help));
 	return;
 }
=20
@@ -407,7 +393,7 @@ static void handle_f2(int *key, struct m
 static void handle_f3(int *key, struct menu *current_item)
 {
 	show_scroll_win(main_window,
-			_("Instructions"),
+			_("Short help"),
 			_(current_instructions));
 	return;
 }
@@ -1108,24 +1094,32 @@ static void conf(struct menu *menu)
 				break;
 			switch (res) {
 			case KEY_DOWN:
+			case 'j':
 				menu_driver(curses_menu, REQ_DOWN_ITEM);
 				break;
 			case KEY_UP:
+			case 'k':
 				menu_driver(curses_menu, REQ_UP_ITEM);
 				break;
 			case KEY_NPAGE:
+			case KEY_CONTROL('f'):
+			case KEY_CONTROL('n'):
 				menu_driver(curses_menu, REQ_SCR_DPAGE);
 				break;
 			case KEY_PPAGE:
+			case KEY_CONTROL('b'):
+			case KEY_CONTROL('p'):
 				menu_driver(curses_menu, REQ_SCR_UPAGE);
 				break;
 			case KEY_HOME:
+			case 'g':
 				menu_driver(curses_menu, REQ_FIRST_ITEM);
 				break;
 			case KEY_END:
+			case 'G':
 				menu_driver(curses_menu, REQ_LAST_ITEM);
 				break;
-			case 'h':
+			case 'H':
 			case '?':
 				show_help((struct menu *) item_data());
 				break;
@@ -1133,14 +1127,15 @@ static void conf(struct menu *menu)
 			if (res =3D=3D 10 || res =3D=3D 27 ||
 				res =3D=3D 32 || res =3D=3D 'n' || res =3D=3D 'y' ||
 				res =3D=3D KEY_LEFT || res =3D=3D KEY_RIGHT ||
-				res =3D=3D 'm')
+				res =3D=3D 'h' || res =3D=3D 'l' || res =3D=3D 'm')
 				break;
 			refresh_all_windows(main_window);
 		}
=20
 		refresh_all_windows(main_window);
 		/* if ESC or left*/
-		if (res =3D=3D 27 || (menu !=3D &rootmenu && res =3D=3D KEY_LEFT))
+		if (res =3D=3D 27 || (menu !=3D &rootmenu
+			&& (res =3D=3D 'h' || res =3D=3D KEY_LEFT)))
 			break;
=20
 		/* remember location in the menu */
@@ -1162,6 +1157,7 @@ static void conf(struct menu *menu)
 			else if (item_is_tag('m'))
 				conf(submenu);
 			break;
+		case 'l':
 		case KEY_RIGHT:
 		case 10: /* ENTER WAS PRESSED */
 			switch (item_tag()) {
@@ -1293,36 +1289,44 @@ static void conf_choice(struct menu *men
 				break;
 			switch (res) {
 			case KEY_DOWN:
+			case 'j':
 				menu_driver(curses_menu, REQ_DOWN_ITEM);
 				break;
 			case KEY_UP:
+			case 'k':
 				menu_driver(curses_menu, REQ_UP_ITEM);
 				break;
 			case KEY_NPAGE:
+			case KEY_CONTROL('f'):
+			case KEY_CONTROL('n'):
 				menu_driver(curses_menu, REQ_SCR_DPAGE);
 				break;
 			case KEY_PPAGE:
+			case KEY_CONTROL('b'):
+			case KEY_CONTROL('p'):
 				menu_driver(curses_menu, REQ_SCR_UPAGE);
 				break;
 			case KEY_HOME:
+			case 'g':
 				menu_driver(curses_menu, REQ_FIRST_ITEM);
 				break;
 			case KEY_END:
+			case 'G':
 				menu_driver(curses_menu, REQ_LAST_ITEM);
 				break;
-			case 'h':
+			case 'H':
 			case '?':
 				show_help((struct menu *) item_data());
 				break;
 			}
-			if (res =3D=3D 10 || res =3D=3D 27 || res =3D=3D ' ' ||
-					res =3D=3D KEY_LEFT){
+			if (res =3D=3D 10 || res =3D=3D 27 || res =3D=3D ' '
+				|| res =3D=3D 'h' || res =3D=3D KEY_LEFT){
 				break;
 			}
 			refresh_all_windows(main_window);
 		}
 		/* if ESC or left */
-		if (res =3D=3D 27 || res =3D=3D KEY_LEFT)
+		if (res =3D=3D 27 || res =3D=3D 'h' || res =3D=3D KEY_LEFT)
 			break;
=20
 		child =3D item_data();
@@ -1331,10 +1335,11 @@ static void conf_choice(struct menu *men
 		switch (res) {
 		case ' ':
 		case  10:
+		case 'l':
 		case KEY_RIGHT:
 			sym_set_tristate_value(child->sym, yes);
 			return;
-		case 'h':
+		case 'H':
 		case '?':
 			show_help(child);
 			active =3D child->sym;

--=20
Roland Eggner

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlDfb+cACgkQdN/hKfT7G/KI7ACgi2FPGth8c4mbHlve74RaYH2d
qHMAn3iAezQc9cgULslsyG/aY83HPRt2
=oymZ
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
