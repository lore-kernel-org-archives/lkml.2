Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab2KMNb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:31:29 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37184 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab2KMNbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:31:16 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 6/6] perf ui: Always compile error printing code
Date: Tue, 13 Nov 2012 22:30:36 +0900
Message-Id: <1352813436-14173-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352813436-14173-1-git-send-email-namhyung@kernel.org>
References: <1352813436-14173-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It is used everywhere so always build it regardless of ui engine.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile     |   14 +++++---------
 tools/perf/ui/util.c    |   10 ++++++++++
 tools/perf/util/debug.c |   22 ----------------------
 tools/perf/util/debug.h |   33 ++-------------------------------
 4 files changed, 17 insertions(+), 62 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a7c6aa8d4a8b..cd1f346a9f8b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -350,8 +350,11 @@ LIB_H += util/rblist.h
 LIB_H += util/intlist.h
 LIB_H += util/perf_regs.h
 LIB_H += util/unwind.h
-LIB_H += ui/helpline.h
 LIB_H += util/vdso.h
+LIB_H += ui/helpline.h
+LIB_H += ui/progress.h
+LIB_H += ui/util.h
+LIB_H += ui/ui.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -425,6 +428,7 @@ LIB_OBJS += $(OUTPUT)util/stat.o
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
 LIB_OBJS += $(OUTPUT)ui/progress.o
+LIB_OBJS += $(OUTPUT)ui/util.o
 LIB_OBJS += $(OUTPUT)ui/hist.o
 LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
 
@@ -618,7 +622,6 @@ ifndef NO_NEWT
 		LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/map.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
-		LIB_OBJS += $(OUTPUT)ui/util.o
 		LIB_OBJS += $(OUTPUT)ui/tui/setup.o
 		LIB_OBJS += $(OUTPUT)ui/tui/util.o
 		LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
@@ -627,9 +630,6 @@ ifndef NO_NEWT
 		LIB_H += ui/browsers/map.h
 		LIB_H += ui/keysyms.h
 		LIB_H += ui/libslang.h
-		LIB_H += ui/progress.h
-		LIB_H += ui/util.h
-		LIB_H += ui/ui.h
 	endif
 endif
 
@@ -649,10 +649,6 @@ ifndef NO_GTK2
 		LIB_OBJS += $(OUTPUT)ui/gtk/util.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
-		# Make sure that it'd be included only once.
-		ifeq ($(findstring -DNEWT_SUPPORT,$(BASIC_CFLAGS)),)
-			LIB_OBJS += $(OUTPUT)ui/util.o
-		endif
 	endif
 endif
 
diff --git a/tools/perf/ui/util.c b/tools/perf/ui/util.c
index 4f989774c8c6..3014a7cd5271 100644
--- a/tools/perf/ui/util.c
+++ b/tools/perf/ui/util.c
@@ -52,6 +52,16 @@ int ui__warning(const char *format, ...)
 	return ret;
 }
 
+int ui__error_paranoid(void)
+{
+	return ui__error("Permission error - are you root?\n"
+		    "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
+		    " -1 - Not paranoid at all\n"
+		    "  0 - Disallow raw tracepoint access for unpriv\n"
+		    "  1 - Disallow cpu events for unpriv\n"
+		    "  2 - Disallow kernel profiling for unpriv\n");
+}
+
 
 /**
  * perf_error__register - Register error logging functions
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 03f830b48148..39861a2a7d18 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -49,28 +49,6 @@ int dump_printf(const char *fmt, ...)
 	return ret;
 }
 
-#if !defined(NEWT_SUPPORT) && !defined(GTK2_SUPPORT)
-int ui__warning(const char *format, ...)
-{
-	va_list args;
-
-	va_start(args, format);
-	vfprintf(stderr, format, args);
-	va_end(args);
-	return 0;
-}
-#endif
-
-int ui__error_paranoid(void)
-{
-	return ui__error("Permission error - are you root?\n"
-		    "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
-		    " -1 - Not paranoid at all\n"
-		    "  0 - Disallow raw tracepoint access for unpriv\n"
-		    "  1 - Disallow cpu events for unpriv\n"
-		    "  2 - Disallow kernel profiling for unpriv\n");
-}
-
 void trace_event(union perf_event *event)
 {
 	unsigned char *raw_event = (void *)event;
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 83e8d234af6b..6e2667fb8211 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -5,6 +5,8 @@
 #include <stdbool.h>
 #include "event.h"
 #include "../ui/helpline.h"
+#include "../ui/progress.h"
+#include "../ui/util.h"
 
 extern int verbose;
 extern bool quiet, dump_trace;
@@ -12,38 +14,7 @@ extern bool quiet, dump_trace;
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void trace_event(union perf_event *event);
 
-struct ui_progress;
-struct perf_error_ops;
-
-#if defined(NEWT_SUPPORT) || defined(GTK2_SUPPORT)
-
-#include "../ui/progress.h"
 int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
-#include "../ui/util.h"
-
-#else
-
-static inline void ui_progress__update(u64 curr __maybe_unused,
-				       u64 total __maybe_unused,
-				       const char *title __maybe_unused) {}
-static inline void ui_progress__finish(void) {}
-
-#define ui__error(format, arg...) ui__warning(format, ##arg)
-
-static inline int
-perf_error__register(struct perf_error_ops *eops __maybe_unused)
-{
-	return 0;
-}
-
-static inline int
-perf_error__unregister(struct perf_error_ops *eops __maybe_unused)
-{
-	return 0;
-}
-
-#endif /* NEWT_SUPPORT || GTK2_SUPPORT */
-
 int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
 int ui__error_paranoid(void);
 
-- 
1.7.9.2

