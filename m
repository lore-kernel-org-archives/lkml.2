Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab2EBT1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:27:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:56707 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318Ab2EBTZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:25:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/15] perf ui: Add gtk2 support into setup_browser()
Date: Wed,  2 May 2012 16:25:01 -0300
Message-Id: <1335986702-9408-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335986702-9408-1-git-send-email-acme@infradead.org>
References: <1335986702-9408-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Now setup_browser can handle gtk2 front-end so split the TUI code to
ui/tui/setup.c in order to remove dependency.

To this end, make ui__init/exit global symbols and take an argument.
Also split gtk code to ui/gtk/setup.c.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1335761711-31403-5-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile         |    6 ++
 tools/perf/builtin-report.c |   10 +--
 tools/perf/ui/gtk/browser.c |   10 ---
 tools/perf/ui/gtk/setup.c   |   12 +++
 tools/perf/ui/setup.c       |  169 +++++++------------------------------------
 tools/perf/ui/tui/setup.c   |  140 +++++++++++++++++++++++++++++++++++
 tools/perf/util/cache.h     |   23 ++++--
 7 files changed, 205 insertions(+), 165 deletions(-)
 create mode 100644 tools/perf/ui/gtk/setup.c
 create mode 100644 tools/perf/ui/tui/setup.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4122a66..4734f41 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -483,6 +483,7 @@ else
 		LIB_OBJS += $(OUTPUT)ui/helpline.o
 		LIB_OBJS += $(OUTPUT)ui/progress.o
 		LIB_OBJS += $(OUTPUT)ui/util.o
+		LIB_OBJS += $(OUTPUT)ui/tui/setup.o
 		LIB_H += ui/browser.h
 		LIB_H += ui/browsers/map.h
 		LIB_H += ui/helpline.h
@@ -505,6 +506,11 @@ else
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
index 06115ff..5df829f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -676,14 +676,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 
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
index 5eafd9b..0656c38 100644
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
index 0000000..8c3b573
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
index becdcd0..98130e0 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -1,161 +1,44 @@
-#include <newt.h>
-#include <signal.h>
-#include <stdbool.h>
-
 #include "../cache.h"
 #include "../debug.h"
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
+	if (!isatty(1) || dump_trace)
+		use_browser = 0;
 
-	newtSetSuspendCallback(newt_suspend, NULL);
-	ui_helpline__init();
-	ui_browser__init();
+	/* default to TUI */
+	if (use_browser < 0)
+		use_browser = 1;
 
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
index 0000000..0194cea
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
index 3428b77..761d4e9 100644
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
1.7.9.2.358.g22243

