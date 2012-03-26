Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab2CZIwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 04:52:13 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46627 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab2CZIvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 04:51:40 -0400
X-AuditID: 9c93016f-b7cc6ae00000317e-1f-4f702e19894e
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 3/5] perf ui: Add gtk2 support into setup_browser()
Date: Mon, 26 Mar 2012 17:51:34 +0900
Message-Id: <1332751896-11210-4-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332751896-11210-1-git-send-email-namhyung.kim@lge.com>
References: <1332751896-11210-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now setup_browser can handle gtk2 front-end so move the
code to a new location ui/setup.c in order to remove
dependency on TUI support. To this end, make ui__init/exit
global symbols and take an argument.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/Makefile         |    7 ++++++-
 tools/perf/builtin-report.c |    5 +----
 tools/perf/ui/setup.c       |   42 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/cache.h     |   15 ++++++++++++++-
 tools/perf/util/gtk/gtk.h   |    4 ++++
 tools/perf/util/ui/setup.c  |   37 ++++++++-----------------------------
 6 files changed, 75 insertions(+), 35 deletions(-)
 create mode 100644 tools/perf/ui/setup.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b492e3a51268..3885ad061db9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -498,6 +498,7 @@ else
 		LIB_OBJS += $(OUTPUT)util/ui/helpline.o
 		LIB_OBJS += $(OUTPUT)util/ui/progress.o
 		LIB_OBJS += $(OUTPUT)util/ui/util.o
+		LIB_OBJS += $(OUTPUT)ui/setup.o
 		LIB_H += util/ui/browser.h
 		LIB_H += util/ui/browsers/map.h
 		LIB_H += util/ui/helpline.h
@@ -510,7 +511,7 @@ else
 endif
 
 ifdef NO_GTK2
-	BASIC_CFLAGS += -DNO_GTK2
+	BASIC_CFLAGS += -DNO_GTK2_SUPPORT
 else
 	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0)
 	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
@@ -520,6 +521,10 @@ else
 		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0)
 		EXTLIBS += $(shell pkg-config --libs gtk+-2.0)
 		LIB_OBJS += $(OUTPUT)util/gtk/browser.o
+		# Make sure that it'd be included only once.
+		ifneq ($(findstring -DNO_NEWT_SUPPORT,$(BASIC_CFLAGS)),)
+			LIB_OBJS += $(OUTPUT)ui/setup.o
+		endif
 	endif
 endif
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 50a05739091d..815b57001d04 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -674,10 +674,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	}
 
 	if (strcmp(report.input_name, "-") != 0) {
-		if (report.use_gtk)
-			perf_gtk_setup_browser(true);
-		else
-			setup_browser(true);
+		setup_browser(true);
 	} else {
 		use_browser = 0;
 	}
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
new file mode 100644
index 000000000000..228221a11830
--- /dev/null
+++ b/tools/perf/ui/setup.c
@@ -0,0 +1,42 @@
+#include "../util/cache.h"
+#include "../util/debug.h"
+#include "../util/ui/ui.h"
+#include "../util/ui/util.h"
+#include "../util/gtk/gtk.h"
+
+void setup_browser(bool fallback_to_pager)
+{
+	if (!isatty(1) || dump_trace)
+		use_browser = 0;
+
+	switch (use_browser) {
+	case 2:
+		perf_gtk_setup_browser(fallback_to_pager);
+		break;
+
+	case 1:
+		ui__init(fallback_to_pager);
+		break;
+
+	default:
+		if (fallback_to_pager)
+			setup_pager();
+		break;
+	}
+}
+
+void exit_browser(bool wait_for_ok)
+{
+	switch (use_browser) {
+	case 2:
+		perf_gtk_exit_browser(wait_for_ok);
+		break;
+
+	case 1:
+		ui__exit(wait_for_ok);
+		break;
+
+	default:
+		break;
+	}
+}
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index d22ca689fb15..60ad454e9a8b 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -33,7 +33,7 @@ extern int pager_use_color;
 
 extern int use_browser;
 
-#ifdef NO_NEWT_SUPPORT
+#if defined(NO_NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
 static inline void setup_browser(bool fallback_to_pager)
 {
 	if (fallback_to_pager)
@@ -43,6 +43,18 @@ static inline void exit_browser(bool wait_for_ok __used) {}
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
@@ -56,6 +68,7 @@ static inline void perf_gtk_exit_browser(bool wait_for_ok __used) {}
 void perf_gtk_setup_browser(bool fallback_to_pager);
 void perf_gtk_exit_browser(bool wait_for_ok);
 #endif
+#endif /* NO_NEWT_SUPPORT && NO_GTK2_SUPPORT */
 
 char *alias_lookup(const char *alias);
 int split_cmdline(char *cmdline, const char ***argv);
diff --git a/tools/perf/util/gtk/gtk.h b/tools/perf/util/gtk/gtk.h
index 75177ee04032..f5ac81832704 100644
--- a/tools/perf/util/gtk/gtk.h
+++ b/tools/perf/util/gtk/gtk.h
@@ -1,8 +1,12 @@
 #ifndef _PERF_GTK_H_
 #define _PERF_GTK_H_ 1
 
+#ifndef NO_GTK2_SUPPORT
+
 #pragma GCC diagnostic ignored "-Wstrict-prototypes"
 #include <gtk/gtk.h>
 #pragma GCC diagnostic error "-Wstrict-prototypes"
 
+#endif /* NO_GTK2_SUPPORT */
+
 #endif /* _PERF_GTK_H_ */
diff --git a/tools/perf/util/ui/setup.c b/tools/perf/util/ui/setup.c
index becdcd0d9ce7..907adfb4e99c 100644
--- a/tools/perf/util/ui/setup.c
+++ b/tools/perf/util/ui/setup.c
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
-- 
1.7.7.6

