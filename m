Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab1IARxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 13:53:48 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49118 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094Ab1IARxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 13:53:23 -0400
From: crquan@gmail.com
To: linux-kbuild@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Nir Tzachar <nir.tzachar@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        c.rq541@comcast.net
Subject: [PATCH V3 4/5] scripts/kconfig/nconf: fix editing long strings
Date: Thu,  1 Sep 2011 10:52:21 -0700
Message-Id: <1314899542-5848-4-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314899542-5848-3-git-send-email-crquan@gmail.com>
References: <CAH5vBdKxbaKDrA2gAj5CoDYShN+5dnfu6Bmd=4+oV-XmnYQnFA@mail.gmail.com>
 <1314899542-5848-1-git-send-email-crquan@gmail.com>
 <1314899542-5848-2-git-send-email-crquan@gmail.com>
 <1314899542-5848-3-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

The original dialog_inputbox doesn't work with longer than prompt_width
strings, here fixed it in this way:
1) add variable cursor_form_win to record cursor of form_win,
   keep its value always between [0, prompt_width-1];
   reuse the original cursor_position as cursor of the string result,
   use (cursor_position-cursor_form_win) as begin offset to show part of
   the string in form_win;

Signed-off-by: Cheng Renquan <crquan@gmail.com>
Cc: Arnaud Lacombe <lacombar@gmail.com>
Cc: Nir Tzachar <nir.tzachar@gmail.com>
---
 scripts/kconfig/nconf.gui.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
index d64bc1c..4b9d8b6 100644
--- a/scripts/kconfig/nconf.gui.c
+++ b/scripts/kconfig/nconf.gui.c
@@ -367,6 +367,7 @@ int dialog_inputbox(WINDOW *main_window,
 	int i, x, y;
 	int res = -1;
 	int cursor_position = strlen(init);
+	int cursor_form_win;
 	char *result = *resultp;
 
 	if (strlen(init)+1 > *result_len) {
@@ -410,7 +411,9 @@ int dialog_inputbox(WINDOW *main_window,
 	fill_window(prompt_win, prompt);
 
 	mvwprintw(form_win, 0, 0, "%*s", prompt_width, " ");
-	mvwprintw(form_win, 0, 0, "%s", result);
+	cursor_form_win = min(cursor_position, prompt_width-1);
+	mvwprintw(form_win, 0, 0, "%s",
+		  result + cursor_position-cursor_form_win);
 
 	/* create panels */
 	panel = new_panel(win);
@@ -436,6 +439,8 @@ int dialog_inputbox(WINDOW *main_window,
 						&result[cursor_position],
 						len-cursor_position+1);
 				cursor_position--;
+				cursor_form_win--;
+				len--;
 			}
 			break;
 		case KEY_DC:
@@ -443,18 +448,22 @@ int dialog_inputbox(WINDOW *main_window,
 				memmove(&result[cursor_position],
 						&result[cursor_position+1],
 						len-cursor_position+1);
+				len--;
 			}
 			break;
 		case KEY_UP:
 		case KEY_RIGHT:
-			if (cursor_position < len &&
-			    cursor_position < min(*result_len, prompt_width))
+			if (cursor_position < len) {
 				cursor_position++;
+				cursor_form_win++;
+			}
 			break;
 		case KEY_DOWN:
 		case KEY_LEFT:
-			if (cursor_position > 0)
+			if (cursor_position > 0) {
 				cursor_position--;
+				cursor_form_win--;
+			}
 			break;
 		default:
 			if ((isgraph(res) || isspace(res))) {
@@ -470,16 +479,24 @@ int dialog_inputbox(WINDOW *main_window,
 						len-cursor_position+1);
 				result[cursor_position] = res;
 				cursor_position++;
+				cursor_form_win++;
+				len++;
 			} else {
 				mvprintw(0, 0, "unknown key: %d\n", res);
 			}
 			break;
 		}
+		if (cursor_form_win < 0)
+			cursor_form_win = 0;
+		else if (cursor_form_win > prompt_width-1)
+			cursor_form_win = prompt_width-1;
+
 		wmove(form_win, 0, 0);
 		wclrtoeol(form_win);
 		mvwprintw(form_win, 0, 0, "%*s", prompt_width, " ");
-		mvwprintw(form_win, 0, 0, "%s", result);
-		wmove(form_win, 0, cursor_position);
+		mvwprintw(form_win, 0, 0, "%s",
+			result + cursor_position-cursor_form_win);
+		wmove(form_win, 0, cursor_form_win);
 		touchwin(win);
 		refresh_all_windows(main_window);
 
-- 
1.7.6

