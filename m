Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2C2Ghm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:37:42 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45958 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab2C2Gg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:36:59 -0400
X-AuditID: 9c93016f-b7c86ae000005478-28-4f7402ff01c9
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 6/7] perf ui: Add gtk2 support into setup_browser()
Date: Thu, 29 Mar 2012 15:36:43 +0900
Message-Id: <1333003004-6391-7-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333003004-6391-1-git-send-email-namhyung.kim@lge.com>
References: <1333003004-6391-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now setup_browser can handle gtk2 front-end so split the
TUI code to ui/tui/setup.c in order to remove dependency.
To this end, make ui__init/exit global symbols and take
an argument. Also split gtk code to ui/gtk/setup.c.

Acked-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/Makefile         |    6 ++
 tools/perf/builtin-report.c |   10 +--
 tools/perf/ui/gtk/browser.c |   10 ---
 tools/perf/ui/gtk/setup.c   |   12 +++
 tools/perf/ui/setup.c       |  167 ++++++-------------------------------------
 tools/perf/ui/tui/setup.c   |  140 ++++++++++++++++++++++++++++++++++++
 tools/perf/util/cache.h     |   23 +++++--
 7 files changed, 202 insertions(+), 166 deletions(-)
 create mode 100644 tools/perf/ui/gtk/setup.c
 create mode 100644 tools/perf/ui/tui/setup.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c8e71f073c6f..3374ed990ea3 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -498,6 +498,7 @@ else
 		LIB_OBJS += $(OUTPUT)ui/helpline.o
 		LIB_OBJS += $(OUTPUT)ui/progress.o
 		LIB_OBJS += $(OUTPUT)ui/util.o
+		LIB_OBJS += $(OUTPUT)ui/tui/setup.o
 		LIB_H += ui/browser.h
 		LIB_H += ui/browsers/map.h
 		LIB_H += ui/helpline.h
@@ -520,6 +521,11 @@ else
 		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0)
 		EXTLIBS += $(shell pkg-config --libs gtk+-2.0)
 		LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
+		LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
+		# Make sure that it'd be included only once.
+		ifneq ($(findstring -DNO_NEWT_SUPPORT,$(BASIC_CFLAGS)),)
+			LIB_OBJS += $(OUTPUT)ui/setup.o
+		endif
 	endif
 endif
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 38a05fee017a..fc39473f8588 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -673,14 +673,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 
 	}
 
-	if (strcmp(report.input_name, "-") != 0) {
-		if (report.use_gtk)
-			perf_gtk__setup_browser(true);
-		else
-			setup_browser(true);
-	} else {
+	if (strcmp(report.input_name, "-") != 0)
+		setup_browser(true);
+	else
 		use_browser = 0;
-	}
 
 	/*
 	 * Only in the newt browser we are doing integrated annotation,
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 1a7c8bec407e..0acd0c53e7a5 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -9,16 +9,6 @@
 
 #define MAX_COLUMNS			32
 
-void perf_gtk__setup_browser(bool fallback_to_pager __used)
-{
-	gtk_init(NULL, NULL);
-}
-
-void perf_gtk__exit_browser(bool wait_for_ok __used)
-{
-	gtk_main_quit();
-}
-
 static void perf_gtk__signal(int sig)
 {
 	psignal(sig, "perf");
diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
new file mode 100644
index 000000000000..8c3b573e863d
--- /dev/null
+++ b/tools/perf/ui/gtk/setup.c
@@ -0,0 +1,12 @@
+#include "gtk.h"
+#include "../../util/cache.h"
+
+void perf_gtk__init(bool fallback_to_pager __used)
+{
+	gtk_init(NULL, NULL);
+}
+
+void perf_gtk__exit(bool wait_for_ok __used)
+{
+	gtk_main_quit();
+}
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 9947ec0f7fd1..8a2b13378f26 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -1,161 +1,40 @@
-#include <newt.h>
-#include <signal.h>
-#include <stdbool.h>
-
 #include "../util/cache.h"
 #include "../util/debug.h"
-#include "browser.h"
-#include "helpline.h"
-#include "ui.h"
-#include "util.h"
-#include "libslang.h"
-#include "keysyms.h"
-
-pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
-
-static volatile int ui__need_resize;
-
-void ui__refresh_dimensions(bool force)
-{
-	if (force || ui__need_resize) {
-		ui__need_resize = 0;
-		pthread_mutex_lock(&ui__lock);
-		SLtt_get_screen_size();
-		SLsmg_reinit_smg();
-		pthread_mutex_unlock(&ui__lock);
-	}
-}
-
-static void ui__sigwinch(int sig __used)
-{
-	ui__need_resize = 1;
-}
-
-static void ui__setup_sigwinch(void)
-{
-	static bool done;
-
-	if (done)
-		return;
-
-	done = true;
-	pthread__unblock_sigwinch();
-	signal(SIGWINCH, ui__sigwinch);
-}
-
-int ui__getch(int delay_secs)
-{
-	struct timeval timeout, *ptimeout = delay_secs ? &timeout : NULL;
-	fd_set read_set;
-	int err, key;
-
-	ui__setup_sigwinch();
-
-	FD_ZERO(&read_set);
-	FD_SET(0, &read_set);
-
-	if (delay_secs) {
-		timeout.tv_sec = delay_secs;
-		timeout.tv_usec = 0;
-	}
-
-        err = select(1, &read_set, NULL, NULL, ptimeout);
-
-	if (err == 0)
-		return K_TIMER;
-
-	if (err == -1) {
-		if (errno == EINTR)
-			return K_RESIZE;
-		return K_ERROR;
-	}
 
-	key = SLang_getkey();
-	if (key != K_ESC)
-		return key;
 
-	FD_ZERO(&read_set);
-	FD_SET(0, &read_set);
-	timeout.tv_sec = 0;
-	timeout.tv_usec = 20;
-        err = select(1, &read_set, NULL, NULL, &timeout);
-	if (err == 0)
-		return K_ESC;
-
-	SLang_ungetkey(key);
-	return SLkp_getkey();
-}
-
-static void newt_suspend(void *d __used)
-{
-	newtSuspend();
-	raise(SIGTSTP);
-	newtResume();
-}
-
-static void ui__exit(void);
-
-static void ui__signal(int sig)
-{
-	ui__exit();
-	psignal(sig, "perf");
-	exit(0);
-}
-
-static int ui__init(void)
+void setup_browser(bool fallback_to_pager)
 {
-	int err;
-
-	newtInit();
-	err = SLkp_init();
-	if (err < 0) {
-		pr_err("TUI initialization failed.\n");
-		goto out;
-	}
-
-	SLkp_define_keysym((char *)"^(kB)", SL_KEY_UNTAB);
-
-	newtSetSuspendCallback(newt_suspend, NULL);
-	ui_helpline__init();
-	ui_browser__init();
+	if (!isatty(1) || dump_trace)
+		use_browser = 0;
 
-	signal(SIGSEGV, ui__signal);
-	signal(SIGFPE, ui__signal);
-	signal(SIGINT, ui__signal);
-	signal(SIGQUIT, ui__signal);
-	signal(SIGTERM, ui__signal);
-out:
-	return err;
-}
+	switch (use_browser) {
+	case 2:
+		perf_gtk__init(fallback_to_pager);
+		break;
 
-static void ui__exit(void)
-{
-	SLtt_set_cursor_visibility(1);
-	SLsmg_refresh();
-	SLsmg_reset_smg();
-	SLang_reset_tty();
-}
+	case 1:
+		ui__init(fallback_to_pager);
+		break;
 
-void setup_browser(bool fallback_to_pager)
-{
-	if (!isatty(1) || !use_browser || dump_trace) {
-		use_browser = 0;
+	default:
 		if (fallback_to_pager)
 			setup_pager();
-		return;
+		break;
 	}
-
-	use_browser = 1;
-	ui__init();
 }
 
 void exit_browser(bool wait_for_ok)
 {
-	if (use_browser > 0) {
-		if (wait_for_ok)
-			ui__question_window("Fatal Error",
-					    ui_helpline__last_msg,
-					    "Press any key...", 0);
-		ui__exit();
+	switch (use_browser) {
+	case 2:
+		perf_gtk__exit(wait_for_ok);
+		break;
+
+	case 1:
+		ui__exit(wait_for_ok);
+		break;
+
+	default:
+		break;
 	}
 }
diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
new file mode 100644
index 000000000000..0194cea2ea0e
--- /dev/null
+++ b/tools/perf/ui/tui/setup.c
@@ -0,0 +1,140 @@
+#include <newt.h>
+#include <signal.h>
+#include <stdbool.h>
+
+#include "../../util/cache.h"
+#include "../../util/debug.h"
+#include "../browser.h"
+#include "../helpline.h"
+#include "../ui.h"
+#include "../util.h"
+#include "../libslang.h"
+#include "../keysyms.h"
+
+pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
+
+static volatile int ui__need_resize;
+
+void ui__refresh_dimensions(bool force)
+{
+	if (force || ui__need_resize) {
+		ui__need_resize = 0;
+		pthread_mutex_lock(&ui__lock);
+		SLtt_get_screen_size();
+		SLsmg_reinit_smg();
+		pthread_mutex_unlock(&ui__lock);
+	}
+}
+
+static void ui__sigwinch(int sig __used)
+{
+	ui__need_resize = 1;
+}
+
+static void ui__setup_sigwinch(void)
+{
+	static bool done;
+
+	if (done)
+		return;
+
+	done = true;
+	pthread__unblock_sigwinch();
+	signal(SIGWINCH, ui__sigwinch);
+}
+
+int ui__getch(int delay_secs)
+{
+	struct timeval timeout, *ptimeout = delay_secs ? &timeout : NULL;
+	fd_set read_set;
+	int err, key;
+
+	ui__setup_sigwinch();
+
+	FD_ZERO(&read_set);
+	FD_SET(0, &read_set);
+
+	if (delay_secs) {
+		timeout.tv_sec = delay_secs;
+		timeout.tv_usec = 0;
+	}
+
+        err = select(1, &read_set, NULL, NULL, ptimeout);
+
+	if (err == 0)
+		return K_TIMER;
+
+	if (err == -1) {
+		if (errno == EINTR)
+			return K_RESIZE;
+		return K_ERROR;
+	}
+
+	key = SLang_getkey();
+	if (key != K_ESC)
+		return key;
+
+	FD_ZERO(&read_set);
+	FD_SET(0, &read_set);
+	timeout.tv_sec = 0;
+	timeout.tv_usec = 20;
+        err = select(1, &read_set, NULL, NULL, &timeout);
+	if (err == 0)
+		return K_ESC;
+
+	SLang_ungetkey(key);
+	return SLkp_getkey();
+}
+
+static void newt_suspend(void *d __used)
+{
+	newtSuspend();
+	raise(SIGTSTP);
+	newtResume();
+}
+
+static void ui__signal(int sig)
+{
+	ui__exit(false);
+	psignal(sig, "perf");
+	exit(0);
+}
+
+int ui__init(bool fallback_to_pager __used)
+{
+	int err;
+
+	newtInit();
+	err = SLkp_init();
+	if (err < 0) {
+		pr_err("TUI initialization failed.\n");
+		goto out;
+	}
+
+	SLkp_define_keysym((char *)"^(kB)", SL_KEY_UNTAB);
+
+	newtSetSuspendCallback(newt_suspend, NULL);
+	ui_helpline__init();
+	ui_browser__init();
+
+	signal(SIGSEGV, ui__signal);
+	signal(SIGFPE, ui__signal);
+	signal(SIGINT, ui__signal);
+	signal(SIGQUIT, ui__signal);
+	signal(SIGTERM, ui__signal);
+out:
+	return err;
+}
+
+void ui__exit(bool wait_for_ok)
+{
+	if (wait_for_ok)
+		ui__question_window("Fatal Error",
+				    ui_helpline__last_msg,
+				    "Press any key...", 0);
+
+	SLtt_set_cursor_visibility(1);
+	SLsmg_refresh();
+	SLsmg_reset_smg();
+	SLang_reset_tty();
+}
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 3428b777396d..761d4e998101 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -33,7 +33,7 @@ extern int pager_use_color;
 
 extern int use_browser;
 
-#ifdef NO_NEWT_SUPPORT
+#if defined(NO_NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
 static inline void setup_browser(bool fallback_to_pager)
 {
 	if (fallback_to_pager)
@@ -43,19 +43,32 @@ static inline void exit_browser(bool wait_for_ok __used) {}
 #else
 void setup_browser(bool fallback_to_pager);
 void exit_browser(bool wait_for_ok);
+
+#ifdef NO_NEWT_SUPPORT
+static inline int ui__init(bool fallback_to_pager)
+{
+	if (fallback_to_pager)
+		setup_pager();
+	return 0;
+}
+static inline void ui__exit(bool wait_for_ok __used) {}
+#else
+int ui__init(bool fallback_to_pager);
+void ui__exit(bool wait_for_ok);
 #endif
 
 #ifdef NO_GTK2_SUPPORT
-static inline void perf_gtk__setup_browser(bool fallback_to_pager)
+static inline void perf_gtk__init(bool fallback_to_pager)
 {
 	if (fallback_to_pager)
 		setup_pager();
 }
-static inline void perf_gtk__exit_browser(bool wait_for_ok __used) {}
+static inline void perf_gtk__exit(bool wait_for_ok __used) {}
 #else
-void perf_gtk__setup_browser(bool fallback_to_pager);
-void perf_gtk__exit_browser(bool wait_for_ok);
+void perf_gtk__init(bool fallback_to_pager);
+void perf_gtk__exit(bool wait_for_ok);
 #endif
+#endif /* NO_NEWT_SUPPORT && NO_GTK2_SUPPORT */
 
 char *alias_lookup(const char *alias);
 int split_cmdline(char *cmdline, const char ***argv);
-- 
1.7.7.6

