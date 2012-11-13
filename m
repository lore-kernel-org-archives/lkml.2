Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2KMNbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:31:17 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50638 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2KMNbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:31:14 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 5/6] perf ui: Always compile browser setup code
Date: Tue, 13 Nov 2012 22:30:35 +0900
Message-Id: <1352813436-14173-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352813436-14173-1-git-send-email-namhyung@kernel.org>
References: <1352813436-14173-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

We now have proper fallback logic, so always build it regardless of
TUI or GTK setting.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile     |    3 +--
 tools/perf/ui/ui.h      |   28 ++++++++++++++++++++++++++++
 tools/perf/util/cache.h |   39 +--------------------------------------
 3 files changed, 30 insertions(+), 40 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5a9075ea218e..a7c6aa8d4a8b 100644
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
index 7b67045479f6..d86359c99907 100644
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
index 2bd51370ad28..26e367239873 100644
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
 
-- 
1.7.9.2

