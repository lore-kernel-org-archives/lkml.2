Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab2HFPTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:19:52 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:44429
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932081Ab2HFPTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:19:50 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q76FJjmr024447
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [RFC] kconfig/mconf.c: revision of curses initialization.
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Mon, 06 Aug 2012 17:19:43 +0200
Message-ID: <gi628woxo0.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Mon, 06 Aug 2012 17:19:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I noticed that in mconf, initscr() is called twice -- as far as I found
out since commit d0e1e09568.

In case you see a need to fix that:

I first thought about simply removing the call in init_dialog() in
util.c but then had the feeling that saving of initial cursor positions
also perhaps is better done in that function...

Dirk

------------------------------------------------------------------------
>From 1a4022eedbee6032dea16f67bbe4028a8d3d07a0 Mon Sep 17 00:00:00 2001
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Date: Mon, 6 Aug 2012 16:48:23 +0200
Subject: [PATCH] kconfig/mconf.c: revision of curses initialization.

Since commit d0e1e09568 initscr() is called twice in mconf.

Do it only in init_dialog() in util.c and there also save the
cursor position for the signal handler in mconf.c.

Signed-off-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
---
 scripts/kconfig/lxdialog/dialog.h |    1 +
 scripts/kconfig/lxdialog/util.c   |    7 +++++++
 scripts/kconfig/mconf.c           |    4 ----
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/lxdialog/dialog.h b/scripts/kconfig/lxdialog/dialog.h
index b5211fc..43a58ec 100644
--- a/scripts/kconfig/lxdialog/dialog.h
+++ b/scripts/kconfig/lxdialog/dialog.h
@@ -144,6 +144,7 @@ struct dialog_info {
  */
 extern struct dialog_info dlg;
 extern char dialog_input_result[];
+extern int saved_x, saved_y;		/* Needed in signal handler in mconf.c */
 
 /*
  * Function prototypes
diff --git a/scripts/kconfig/lxdialog/util.c b/scripts/kconfig/lxdialog/util.c
index f2375ad..109d531 100644
--- a/scripts/kconfig/lxdialog/util.c
+++ b/scripts/kconfig/lxdialog/util.c
@@ -23,6 +23,9 @@
 
 #include "dialog.h"
 
+/* Needed in signal handler in mconf.c */
+int saved_x, saved_y;
+
 struct dialog_info dlg;
 
 static void set_mono_theme(void)
@@ -273,6 +276,10 @@ int init_dialog(const char *backtitle)
 	int height, width;
 
 	initscr();		/* Init curses */
+
+	/* Get current cursor position for signal handler in mconf.c */
+	getyx(stdscr, saved_y, saved_x);
+
 	getmaxyx(stdscr, height, width);
 	if (height < 19 || width < 80) {
 		endwin();
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index f584a28..d856d40 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -273,7 +273,6 @@ static struct menu *current_menu;
 static int child_count;
 static int single_menu_mode;
 static int show_all_options;
-static int saved_x, saved_y;
 
 static void conf(struct menu *menu);
 static void conf_choice(struct menu *menu);
@@ -862,9 +861,6 @@ int main(int ac, char **av)
 			single_menu_mode = 1;
 	}
 
-	initscr();
-
-	getyx(stdscr, saved_y, saved_x);
 	if (init_dialog(NULL)) {
 		fprintf(stderr, N_("Your display is too small to run Menuconfig!\n"));
 		fprintf(stderr, N_("It must be at least 19 lines by 80 columns.\n"));
-- 
1.7.8.6

