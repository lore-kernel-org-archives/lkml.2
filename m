Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1H2JK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 05:10:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62749 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab1H2JKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 05:10:21 -0400
MIME-Version: 1.0
From: Cheng Renquan <crquan@gmail.com>
Date: Mon, 29 Aug 2011 02:09:59 -0700
Message-ID: <CAH5vBdKxbaKDrA2gAj5CoDYShN+5dnfu6Bmd=4+oV-XmnYQnFA@mail.gmail.com>
Subject: [RFC] nconf bug fixes and improvements
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>,
        crquan@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bug fixes:
1) char dialog_input_result[256]; is not enough for config item like:
   CONFIG_EXTRA_FIRMWARE="iwlwifi-100-5.ucode iwlwifi-1000-3.ucode
iwlwifi-3945-2.ucode iwlwifi-4965-2.ucode iwlwifi-5000-1.ucode
iwlwifi-5000-2.ucode iwlwifi-5150-2.ucode iwlwifi-6000-4.ucode
iwlwifi-6000g2a-5.ucode iwlwifi-6000g2b-5.ucode iwlwifi-6050-4.ucode
iwlwifi-6050-5.ucode radeon/CEDAR_me.bin radeon/CEDAR_pfp.bin
radeon/CEDAR_rlc.bin radeon/CYPRESS_me.bin radeon/CYPRESS_pfp.bin
radeon/CYPRESS_rlc.bin radeon/JUNIPER_me.bin radeon/JUNIPER_pfp.bin
radeon/JUNIPER_rlc.bin radeon/R600_rlc.bin radeon/R700_rlc.bin
radeon/REDWOOD_me.bin radeon/REDWOOD_pfp.bin radeon/REDWOOD_rlc.bin"

   the original nconf just stack overflow / crashed when dealing with
longer than 256 bytes strings; Since the original menuconfig also just
uses a fixed length buffer [MAX_LEN=2048] which works for the years,
here I just append a 0 make it work in the easiest way; if required,
it could also be changed to a dynamically allocated buffer;

   char dialog_input_result[MAX_LEN + 1];

2) memmove's 3rd argument should be len-cursor_position+1, the
original len+1 may cause segment fault in theory;
 				memmove(&result[cursor_position+1],
 						&result[cursor_position],
-						len+1);
+						len-cursor_position+1);

3) typo:

-				mvprintw(0, 0, "unknow key: %d\n", res);
+				mvprintw(0, 0, "unknown key: %d\n", res);


improvement:
1) its original conf_string doesn't work with longer string values
(longer than its dialog box width), not at all
   (or may work in an invisible way if anyone has tried that)
   Here I added a new variable cursor_form_win to record that new state:
   cursor of the input box; and make it fun:
   when you move cursor to almost left/right edge, it auto adjust text
to center, by half prompt box width;

2) Remove KEY_UP as RIGHT and KEY_DOWN as LEFT,
   Add Home/End to locate the string begin/end;
   Emacs-like key bind (C-a/C-e as Home/End, C-f/C-b as forward/backward);
   this keybind I'd like but may be controversial, it could be
discussed and separated;

This is just [Request for Comments], it just works here on one of my
distributor kernels,
if anyone may think it's useful, please feedback and I would like to
split it into
patch series and rebase to linus latest branch;

Thanks,

--- /mnt/static/usr/src/linux-3.0-gentoo-r1/scripts/kconfig/nconf.c	2011-07-21
19:17:23.000000000 -0700
+++ /mnt/dynamic/usr/src/linux-3.0-gentoo-r1/scripts/kconfig/nconf.c	2011-08-28
18:08:05.699883340 -0700
@@ -1360,7 +1360,7 @@ static void conf_choice(struct menu *men
 static void conf_string(struct menu *menu)
 {
 	const char *prompt = menu_get_prompt(menu);
-	char dialog_input_result[256];
+	char dialog_input_result[2560];

 	while (1) {
 		int res;
--- /mnt/static/usr/src/linux-3.0-gentoo-r1/scripts/kconfig/nconf.gui.c	2011-07-21
19:17:23.000000000 -0700
+++ /mnt/dynamic/usr/src/linux-3.0-gentoo-r1/scripts/kconfig/nconf.gui.c	2011-08-28
18:00:56.441862565 -0700
@@ -367,7 +367,15 @@ int dialog_inputbox(WINDOW *main_window,
 	int i, x, y;
 	int res = -1;
 	int cursor_position = strlen(init);
+	int cursor_form_win;

+	if (strlen(init) +80 > result_len) {
+		(void) attrset(attributes[FUNCTION_HIGHLIGHT] | A_BLINK);
+		mvprintw(0, 0, "result_len(%d) not enough to contain
init_strlen(%d) in %s:%d:%s\n",
+			 result_len, strlen(init),
+			 __FILE__, __LINE__, __func__);
+		flash();
+	}

 	/* find the widest line of msg: */
 	prompt_lines = get_line_no(prompt);
@@ -405,7 +413,11 @@ int dialog_inputbox(WINDOW *main_window,
 	fill_window(prompt_win, prompt);

 	mvwprintw(form_win, 0, 0, "%*s", prompt_width, " ");
-	mvwprintw(form_win, 0, 0, "%s", result);
+	cursor_form_win = min(cursor_position, prompt_width-1);
+	mvwprintw(form_win, 0, 0, "%s",
+		  result + cursor_position-cursor_form_win);
+	mvprintw(0, 0, "cursor_position=%d, cursor_form_win=%d, prompt_width=%d\n",
+		 cursor_position, cursor_form_win, prompt_width);

 	/* create panels */
 	panel = new_panel(win);
@@ -416,6 +428,8 @@ int dialog_inputbox(WINDOW *main_window,
 	touchwin(win);
 	refresh_all_windows(main_window);
 	while ((res = wgetch(form_win))) {
+		mvprintw(0, 0, "got key: %d\n", res);
+
 		int len = strlen(result);
 		switch (res) {
 		case 10: /* ENTER */
@@ -431,6 +445,13 @@ int dialog_inputbox(WINDOW *main_window,
 						&result[cursor_position],
 						len-cursor_position+1);
 				cursor_position--;
+				if (cursor_form_win < 5
+				    && cursor_position > 5)
+					cursor_form_win += prompt_width/2;
+				else
+					cursor_form_win--;
+				if (cursor_form_win > cursor_position)
+					cursor_form_win = cursor_position;
 			}
 			break;
 		case KEY_DC:
@@ -440,16 +461,41 @@ int dialog_inputbox(WINDOW *main_window,
 						len-cursor_position+1);
 			}
 			break;
-		case KEY_UP:
+		case 6: /* Ctrl-F */
 		case KEY_RIGHT:
-			if (cursor_position < len &&
-			    cursor_position < min(result_len, prompt_width))
+			if (cursor_position < len) {
 				cursor_position++;
+				if (cursor_form_win > prompt_width-5
+				    && cursor_position < len-5)
+					cursor_form_win -= prompt_width/2;
+				else
+					cursor_form_win++;
+				if (cursor_form_win < min(cursor_position, prompt_width-1) -
(len-cursor_position))
+					cursor_form_win = min(cursor_position, prompt_width-1) -
(len-cursor_position);
+			}
 			break;
-		case KEY_DOWN:
+		case 2: /* Ctrl-B */
 		case KEY_LEFT:
-			if (cursor_position > 0)
+			if (cursor_position > 0) {
 				cursor_position--;
+				if (cursor_form_win < 5
+				    && cursor_position > 5)
+					cursor_form_win += prompt_width/2;
+				else
+					cursor_form_win--;
+				if (cursor_form_win > cursor_position)
+					cursor_form_win = cursor_position;
+			}
+			break;
+		case 1: /* Ctrl-A */
+		case KEY_HOME:
+			cursor_position = 0;
+			cursor_form_win = 0;
+			break;
+		case 5: /* Ctrl-E */
+		case KEY_END:
+			cursor_position = len;
+			cursor_form_win = min(cursor_position, prompt_width-1);
 			break;
 		default:
 			if ((isgraph(res) || isspace(res)) &&
@@ -457,19 +503,24 @@ int dialog_inputbox(WINDOW *main_window,
 				/* insert the char at the proper position */
 				memmove(&result[cursor_position+1],
 						&result[cursor_position],
-						len+1);
+						len-cursor_position+1);
 				result[cursor_position] = res;
 				cursor_position++;
+				if (cursor_form_win < prompt_width-1)
+					cursor_form_win++;
 			} else {
-				mvprintw(0, 0, "unknow key: %d\n", res);
+				mvprintw(0, 0, "unknown key: %d\n", res);
 			}
 			break;
 		}
+		mvprintw(0, 0, "got key: %d, cursor_position=%d, cursor_form_win=%d\n",
+			 res, cursor_position, cursor_form_win);
 		wmove(form_win, 0, 0);
 		wclrtoeol(form_win);
 		mvwprintw(form_win, 0, 0, "%*s", prompt_width, " ");
-		mvwprintw(form_win, 0, 0, "%s", result);
-		wmove(form_win, 0, cursor_position);
+		mvwprintw(form_win, 0, 0, "%s",
+			  result + cursor_position-cursor_form_win);
+		wmove(form_win, 0, cursor_form_win);
 		touchwin(win);
 		refresh_all_windows(main_window);


--
Cheng Renquan (程任全)
