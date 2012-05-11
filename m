Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695Ab2EKGhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:37:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57170 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759161Ab2EKGg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:36:57 -0400
Date: Thu, 10 May 2012 23:36:21 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-281ef544a8476f750b9f378593c42b3e8a0b8788@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@gmail.com
In-Reply-To: <1335761711-31403-5-git-send-email-namhyung.kim@lge.com>
References: <1335761711-31403-5-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui: Add gtk2 support into setup_browser()
Git-Commit-ID: 281ef544a8476f750b9f378593c42b3e8a0b8788
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:36:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  281ef544a8476f750b9f378593c42b3e8a0b8788
Gitweb:     http://git.kernel.org/tip/281ef544a8476f750b9f378593c42b3e8a0b8788
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 30 Apr 2012 13:55:08 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 2 May 2012 16:17:34 -0300

perf ui: Add gtk2 support into setup_browser()

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
 tools/perf/Makefile             |    6 ++
 tools/perf/builtin-report.c     |   10 +--
 tools/perf/ui/gtk/browser.c     |   10 ---
 tools/perf/ui/gtk/setup.c       |   12 +++
 tools/perf/ui/setup.c           |  169 ++++++---------------------------------
 tools/perf/ui/{ => tui}/setup.c |   53 ++++---------
 tools/perf/util/cache.h         |   23 ++++-
 7 files changed, 81 insertions(+), 202 deletions(-)

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
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/tui/setup.c
similarity index 75%
copy from tools/perf/ui/setup.c
copy to tools/perf/ui/tui/setup.c
index becdcd0..0194cea 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/tui/setup.c
@@ -2,14 +2,14 @@
 #include <signal.h>
 #include <stdbool.h>
 
-#include "../cache.h"
-#include "../debug.h"
-#include "browser.h"
-#include "helpline.h"
-#include "ui.h"
-#include "util.h"
-#include "libslang.h"
-#include "keysyms.h"
+#include "../../util/cache.h"
+#include "../../util/debug.h"
+#include "../browser.h"
+#include "../helpline.h"
+#include "../ui.h"
+#include "../util.h"
+#include "../libslang.h"
+#include "../keysyms.h"
 
 pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
 
@@ -93,16 +93,14 @@ static void newt_suspend(void *d __used)
 	newtResume();
 }
 
-static void ui__exit(void);
-
 static void ui__signal(int sig)
 {
-	ui__exit();
+	ui__exit(false);
 	psignal(sig, "perf");
 	exit(0);
 }
 
-static int ui__init(void)
+int ui__init(bool fallback_to_pager __used)
 {
 	int err;
 
@@ -128,34 +126,15 @@ out:
 	return err;
 }
 
-static void ui__exit(void)
+void ui__exit(bool wait_for_ok)
 {
+	if (wait_for_ok)
+		ui__question_window("Fatal Error",
+				    ui_helpline__last_msg,
+				    "Press any key...", 0);
+
 	SLtt_set_cursor_visibility(1);
 	SLsmg_refresh();
 	SLsmg_reset_smg();
 	SLang_reset_tty();
 }
-
-void setup_browser(bool fallback_to_pager)
-{
-	if (!isatty(1) || !use_browser || dump_trace) {
-		use_browser = 0;
-		if (fallback_to_pager)
-			setup_pager();
-		return;
-	}
-
-	use_browser = 1;
-	ui__init();
-}
-
-void exit_browser(bool wait_for_ok)
-{
-	if (use_browser > 0) {
-		if (wait_for_ok)
-			ui__question_window("Fatal Error",
-					    ui_helpline__last_msg,
-					    "Press any key...", 0);
-		ui__exit();
-	}
-}
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
