Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab2G3TXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:23:05 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47581 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2G3TXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:23:01 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 2/6] menuconfig: Extend dialog_textbox so that it can exit on arbitrary keypresses
Date: Mon, 30 Jul 2012 15:22:06 -0400
Message-Id: <1343676130-29770-3-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1343676130-29770-1-git-send-email-bpoirier@suse.de>
References: <1343676130-29770-1-git-send-email-bpoirier@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
---
 scripts/kconfig/lxdialog/dialog.h  |    3 ++-
 scripts/kconfig/lxdialog/textbox.c |   31 +++++++++++++++++++++----------
 scripts/kconfig/mconf.c            |   12 ++++++++++--
 3 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/scripts/kconfig/lxdialog/dialog.h b/scripts/kconfig/lxdialog/dialog.h
index b5211fc..014c029 100644
--- a/scripts/kconfig/lxdialog/dialog.h
+++ b/scripts/kconfig/lxdialog/dialog.h
@@ -209,7 +209,8 @@ int first_alpha(const char *string, const char *exempt);
 int dialog_yesno(const char *title, const char *prompt, int height, int width);
 int dialog_msgbox(const char *title, const char *prompt, int height,
 		  int width, int pause);
-int dialog_textbox(const char *title, const char *file, int height, int width);
+int dialog_textbox(const char *title, const char *file, int height, int width,
+		   int *keys);
 int dialog_menu(const char *title, const char *prompt,
 		const void *selected, int *s_scroll);
 int dialog_checklist(const char *title, const char *prompt, int height,
diff --git a/scripts/kconfig/lxdialog/textbox.c b/scripts/kconfig/lxdialog/textbox.c
index 264a2b9..eb4ee92 100644
--- a/scripts/kconfig/lxdialog/textbox.c
+++ b/scripts/kconfig/lxdialog/textbox.c
@@ -47,14 +47,16 @@ static void refresh_text_box(WINDOW *dialog, WINDOW *box, int boxh, int boxw,
 
 /*
  * Display text from a file in a dialog box.
+ *
+ * keys is a null-terminated array
  */
-int dialog_textbox(const char *title, const char *tbuf,
-		   int initial_height, int initial_width)
+int dialog_textbox(const char *title, const char *tbuf, int initial_height,
+		   int initial_width, int *keys)
 {
 	int i, x, y, cur_x, cur_y, key = 0;
 	int height, width, boxh, boxw;
-	int passed_end;
 	WINDOW *dialog, *box;
+	bool done = false;
 
 	begin_reached = 1;
 	end_reached = 0;
@@ -122,7 +124,7 @@ do_resize:
 	attr_clear(box, boxh, boxw, dlg.dialog.atr);
 	refresh_text_box(dialog, box, boxh, boxw, cur_y, cur_x);
 
-	while ((key != KEY_ESC) && (key != '\n')) {
+	while (!done) {
 		key = wgetch(dialog);
 		switch (key) {
 		case 'E':	/* Exit */
@@ -130,9 +132,9 @@ do_resize:
 		case 'X':
 		case 'x':
 		case 'q':
-			delwin(box);
-			delwin(dialog);
-			return 0;
+		case '\n':
+			done = true;
+			break;
 		case 'g':	/* First page */
 		case KEY_HOME:
 			if (!begin_reached) {
@@ -156,6 +158,8 @@ do_resize:
 		case 'k':
 		case KEY_UP:
 			if (!begin_reached) {
+				int passed_end = 0;
+
 				back_lines(page_length + 1);
 
 				/* We don't call print_page() here but use
@@ -169,7 +173,6 @@ do_resize:
 				wscrl(box, -1);	/* Scroll box region down one line */
 				scrollok(box, FALSE);
 				page_length = 0;
-				passed_end = 0;
 				for (i = 0; i < boxh; i++) {
 					if (!i) {
 						/* print first line of page */
@@ -252,7 +255,8 @@ do_resize:
 					 cur_y, cur_x);
 			break;
 		case KEY_ESC:
-			key = on_key_esc(dialog);
+			if (on_key_esc(dialog) == KEY_ESC)
+				done = true;
 			break;
 		case KEY_RESIZE:
 			back_lines(height);
@@ -260,11 +264,18 @@ do_resize:
 			delwin(dialog);
 			on_key_resize();
 			goto do_resize;
+		default:
+			for (i = 0; keys[i]; i++) {
+				if (key == keys[i]) {
+					done = true;
+					break;
+				}
+			}
 		}
 	}
 	delwin(box);
 	delwin(dialog);
-	return key;		/* ESC pressed */
+	return key;
 }
 
 /*
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index f584a28..116e5da 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -280,6 +280,8 @@ static void conf_choice(struct menu *menu);
 static void conf_string(struct menu *menu);
 static void conf_load(void);
 static void conf_save(void);
+static int show_textbox_ext(const char *title, const char *text, int r, int c,
+			    int *keys);
 static void show_textbox(const char *title, const char *text, int r, int c);
 static void show_helptext(const char *title, const char *text);
 static void show_help(struct menu *menu);
@@ -619,10 +621,16 @@ static void conf(struct menu *menu)
 	}
 }
 
-static void show_textbox(const char *title, const char *text, int r, int c)
+static int show_textbox_ext(const char *title, const char *text, int r, int c,
+			    int *keys)
 {
 	dialog_clear();
-	dialog_textbox(title, text, r, c);
+	return dialog_textbox(title, text, r, c, keys);
+}
+
+static void show_textbox(const char *title, const char *text, int r, int c)
+{
+	show_textbox_ext(title, text, r, c, (int []) {0});
 }
 
 static void show_helptext(const char *title, const char *text)
-- 
1.7.7

