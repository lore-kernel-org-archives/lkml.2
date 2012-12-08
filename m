Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587Ab2LHPGb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 10:06:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49739 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab2LHPG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 10:06:29 -0500
Date: Sat, 8 Dec 2012 07:06:09 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-59ed16b315681a08cf8aa13ee949e9405801f442@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, penberg@kernel.org,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, penberg@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1352813436-14173-5-git-send-email-namhyung@kernel.org>
References: <1352813436-14173-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui: Always compile browser setup code
Git-Commit-ID: 59ed16b315681a08cf8aa13ee949e9405801f442
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 08 Dec 2012 07:06:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59ed16b315681a08cf8aa13ee949e9405801f442
Gitweb:     http://git.kernel.org/tip/59ed16b315681a08cf8aa13ee949e9405801f442
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 13 Nov 2012 22:30:35 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Nov 2012 16:53:03 -0300

perf ui: Always compile browser setup code

We now have proper fallback logic, so always build it regardless of TUI
or GTK setting.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1352813436-14173-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile     |  3 +--
 tools/perf/ui/ui.h      | 28 ++++++++++++++++++++++++++++
 tools/perf/util/cache.h | 39 +--------------------------------------
 3 files changed, 30 insertions(+), 40 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5a9075e..a7c6aa8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -422,6 +422,7 @@ LIB_OBJS += $(OUTPUT)util/intlist.o
 LIB_OBJS += $(OUTPUT)util/vdso.o
 LIB_OBJS += $(OUTPUT)util/stat.o
 
+LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
 LIB_OBJS += $(OUTPUT)ui/progress.o
 LIB_OBJS += $(OUTPUT)ui/hist.o
@@ -612,7 +613,6 @@ ifndef NO_NEWT
 		BASIC_CFLAGS += -I/usr/include/slang
 		BASIC_CFLAGS += -DNEWT_SUPPORT
 		EXTLIBS += -lnewt -lslang
-		LIB_OBJS += $(OUTPUT)ui/setup.o
 		LIB_OBJS += $(OUTPUT)ui/browser.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
@@ -651,7 +651,6 @@ ifndef NO_GTK2
 		LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
 		# Make sure that it'd be included only once.
 		ifeq ($(findstring -DNEWT_SUPPORT,$(BASIC_CFLAGS)),)
-			LIB_OBJS += $(OUTPUT)ui/setup.o
 			LIB_OBJS += $(OUTPUT)ui/util.o
 		endif
 	endif
diff --git a/tools/perf/ui/ui.h b/tools/perf/ui/ui.h
index 7b67045..d86359c 100644
--- a/tools/perf/ui/ui.h
+++ b/tools/perf/ui/ui.h
@@ -3,9 +3,37 @@
 
 #include <pthread.h>
 #include <stdbool.h>
+#include <linux/compiler.h>
 
 extern pthread_mutex_t ui__lock;
 
+extern int use_browser;
+
+void setup_browser(bool fallback_to_pager);
+void exit_browser(bool wait_for_ok);
+
+#ifdef NEWT_SUPPORT
+int ui__init(void);
+void ui__exit(bool wait_for_ok);
+#else
+static inline int ui__init(void)
+{
+	return -1;
+}
+static inline void ui__exit(bool wait_for_ok __maybe_unused) {}
+#endif
+
+#ifdef GTK2_SUPPORT
+int perf_gtk__init(void);
+void perf_gtk__exit(bool wait_for_ok);
+#else
+static inline int perf_gtk__init(void)
+{
+	return -1;
+}
+static inline void perf_gtk__exit(bool wait_for_ok __maybe_unused) {}
+#endif
+
 void ui__refresh_dimensions(bool force);
 
 #endif /* _PERF_UI_H_ */
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 2bd5137..26e3672 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -5,6 +5,7 @@
 #include "util.h"
 #include "strbuf.h"
 #include "../perf.h"
+#include "../ui/ui.h"
 
 #define CMD_EXEC_PATH "--exec-path"
 #define CMD_PERF_DIR "--perf-dir="
@@ -31,44 +32,6 @@ extern const char *pager_program;
 extern int pager_in_use(void);
 extern int pager_use_color;
 
-extern int use_browser;
-
-#if defined(NEWT_SUPPORT) || defined(GTK2_SUPPORT)
-void setup_browser(bool fallback_to_pager);
-void exit_browser(bool wait_for_ok);
-
-#ifdef NEWT_SUPPORT
-int ui__init(void);
-void ui__exit(bool wait_for_ok);
-#else
-static inline int ui__init(void)
-{
-	return -1;
-}
-static inline void ui__exit(bool wait_for_ok __maybe_unused) {}
-#endif
-
-#ifdef GTK2_SUPPORT
-int perf_gtk__init(void);
-void perf_gtk__exit(bool wait_for_ok);
-#else
-static inline int perf_gtk__init(void)
-{
-	return -1;
-}
-static inline void perf_gtk__exit(bool wait_for_ok __maybe_unused) {}
-#endif
-
-#else /* NEWT_SUPPORT || GTK2_SUPPORT */
-
-static inline void setup_browser(bool fallback_to_pager)
-{
-	if (fallback_to_pager)
-		setup_pager();
-}
-static inline void exit_browser(bool wait_for_ok __maybe_unused) {}
-#endif /* NEWT_SUPPORT || GTK2_SUPPORT */
-
 char *alias_lookup(const char *alias);
 int split_cmdline(char *cmdline, const char ***argv);
 
