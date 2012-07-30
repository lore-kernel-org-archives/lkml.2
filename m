Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab2G3TX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:23:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62821 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab2G3TXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:23:04 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 3/6] menuconfig: Extend dialog_textbox so that it can return to a scrolled position
Date: Mon, 30 Jul 2012 15:22:07 -0400
Message-Id: <1343676130-29770-4-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1343676130-29770-1-git-send-email-bpoirier@suse.de>
References: <1343676130-29770-1-git-send-email-bpoirier@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
---
 scripts/kconfig/lxdialog/dialog.h  |    2 +-
 scripts/kconfig/lxdialog/textbox.c |   24 +++++++++++++++++++++++-
 scripts/kconfig/mconf.c            |    8 ++++----
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/scripts/kconfig/lxdialog/dialog.h b/scripts/kconfig/lxdialog/dialog.h
index 014c029..8e7f43b 100644
--- a/scripts/kconfig/lxdialog/dialog.h
+++ b/scripts/kconfig/lxdialog/dialog.h
@@ -210,7 +210,7 @@ int dialog_yesno(const char *title, const char *prompt, int height, int width);
 int dialog_msgbox(const char *title, const char *prompt, int height,
 		  int width, int pause);
 int dialog_textbox(const char *title, const char *file, int height, int width,
-		   int *keys);
+		   int *keys, int *_vscroll, int *_hscroll);
 int dialog_menu(const char *title, const char *prompt,
 		const void *selected, int *s_scroll);
 int dialog_checklist(const char *title, const char *prompt, int height,
diff --git a/scripts/kconfig/lxdialog/textbox.c b/scripts/kconfig/lxdialog/textbox.c
index eb4ee92..506a095 100644
--- a/scripts/kconfig/lxdialog/textbox.c
+++ b/scripts/kconfig/lxdialog/textbox.c
@@ -51,7 +51,7 @@ static void refresh_text_box(WINDOW *dialog, WINDOW *box, int boxh, int boxw,
  * keys is a null-terminated array
  */
 int dialog_textbox(const char *title, const char *tbuf, int initial_height,
-		   int initial_width, int *keys)
+		   int initial_width, int *keys, int *_vscroll, int *_hscroll)
 {
 	int i, x, y, cur_x, cur_y, key = 0;
 	int height, width, boxh, boxw;
@@ -65,6 +65,15 @@ int dialog_textbox(const char *title, const char *tbuf, int initial_height,
 	buf = tbuf;
 	page = buf;	/* page is pointer to start of page to be displayed */
 
+	if (_vscroll && *_vscroll) {
+		begin_reached = 0;
+
+		for (i = 0; i < *_vscroll; i++)
+			get_line();
+	}
+	if (_hscroll)
+		hscroll = *_hscroll;
+
 do_resize:
 	getmaxyx(stdscr, height, width);
 	if (height < 8 || width < 8)
@@ -275,6 +284,19 @@ do_resize:
 	}
 	delwin(box);
 	delwin(dialog);
+	if (_vscroll) {
+		const char *s;
+
+		s = buf;
+		*_vscroll = 0;
+		back_lines(page_length);
+		while (s < page && (s = strchr(s, '\n'))) {
+			(*_vscroll)++;
+			s++;
+		}
+	}
+	if (_hscroll)
+		*_hscroll = hscroll;
 	return key;
 }
 
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 116e5da..c57cc6a 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -281,7 +281,7 @@ static void conf_string(struct menu *menu);
 static void conf_load(void);
 static void conf_save(void);
 static int show_textbox_ext(const char *title, const char *text, int r, int c,
-			    int *keys);
+			    int *keys, int *vscroll, int *hscroll);
 static void show_textbox(const char *title, const char *text, int r, int c);
 static void show_helptext(const char *title, const char *text);
 static void show_help(struct menu *menu);
@@ -622,15 +622,15 @@ static void conf(struct menu *menu)
 }
 
 static int show_textbox_ext(const char *title, const char *text, int r, int c,
-			    int *keys)
+			    int *keys, int *vscroll, int *hscroll)
 {
 	dialog_clear();
-	return dialog_textbox(title, text, r, c, keys);
+	return dialog_textbox(title, text, r, c, keys, vscroll, hscroll);
 }
 
 static void show_textbox(const char *title, const char *text, int r, int c)
 {
-	show_textbox_ext(title, text, r, c, (int []) {0});
+	show_textbox_ext(title, text, r, c, (int []) {0}, NULL, NULL);
 }
 
 static void show_helptext(const char *title, const char *text)
-- 
1.7.7

