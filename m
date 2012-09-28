Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab2I1Jk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:40:27 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60959 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489Ab2I1JkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:40:22 -0400
X-AuditID: 9c930197-b7b6dae000000e70-6d-506570831ce9
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 07/12] perf tools: Convert to GTK2_SUPPORT
Date: Fri, 28 Sep 2012 18:32:03 +0900
Message-Id: <1348824728-14025-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For building perf without gtk+2, we can set NO_GTK2=1 as a argument of
make.  It then defines NO_GTK2_SUPPORT macro for C code to do the
proper handling.  However it usually used in a negative semantics -
e.g. #ifndef - so we saw double negations which can be misleading.
Convert it to a positive form to make it more readable.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile      |  6 ++----
 tools/perf/ui/helpline.h |  8 ++++----
 tools/perf/util/cache.h  | 28 +++++++++++++++-------------
 tools/perf/util/debug.c  |  2 +-
 tools/perf/util/debug.h  | 17 +++++++++--------
 tools/perf/util/hist.h   | 11 +++++------
 6 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3d2181c57507..31a07f95fd98 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -583,17 +583,15 @@ ifndef NO_NEWT
 	endif
 endif
 
-ifdef NO_GTK2
-	BASIC_CFLAGS += -DNO_GTK2_SUPPORT
-else
+ifndef NO_GTK2
 	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
 	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
 		msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
-		BASIC_CFLAGS += -DNO_GTK2_SUPPORT
 	else
 		ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2)),y)
 			BASIC_CFLAGS += -DHAVE_GTK_INFO_BAR
 		endif
+		BASIC_CFLAGS += -DGTK2_SUPPORT
 		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
 		EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
 		LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
diff --git a/tools/perf/ui/helpline.h b/tools/perf/ui/helpline.h
index e1f126ba0690..baa28a4d16b9 100644
--- a/tools/perf/ui/helpline.h
+++ b/tools/perf/ui/helpline.h
@@ -34,14 +34,14 @@ static inline int ui_helpline__show_help(const char *format __maybe_unused,
 }
 #endif /* NEWT_SUPPORT */
 
-#ifdef NO_GTK2_SUPPORT
+#ifdef GTK2_SUPPORT
+int perf_gtk__show_helpline(const char *format, va_list ap);
+#else
 static inline int perf_gtk__show_helpline(const char *format __maybe_unused,
 					  va_list ap __maybe_unused)
 {
 	return 0;
 }
-#else
-int perf_gtk__show_helpline(const char *format, va_list ap);
-#endif /* NO_GTK2_SUPPORT */
+#endif /* GTK2_SUPPORT */
 
 #endif /* _PERF_UI_HELPLINE_H_ */
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 70f318dc1d9a..07aec06e4443 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -33,14 +33,7 @@ extern int pager_use_color;
 
 extern int use_browser;
 
-#if !defined(NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
-static inline void setup_browser(bool fallback_to_pager)
-{
-	if (fallback_to_pager)
-		setup_pager();
-}
-static inline void exit_browser(bool wait_for_ok __maybe_unused) {}
-#else
+#if defined(NEWT_SUPPORT) || defined(GTK2_SUPPORT)
 void setup_browser(bool fallback_to_pager);
 void exit_browser(bool wait_for_ok);
 
@@ -55,17 +48,26 @@ static inline int ui__init(void)
 static inline void ui__exit(bool wait_for_ok __maybe_unused) {}
 #endif
 
-#ifdef NO_GTK2_SUPPORT
+#ifdef GTK2_SUPPORT
+int perf_gtk__init(void);
+void perf_gtk__exit(bool wait_for_ok);
+#else
 static inline int perf_gtk__init(void)
 {
 	return -1;
 }
 static inline void perf_gtk__exit(bool wait_for_ok __maybe_unused) {}
-#else
-int perf_gtk__init(void);
-void perf_gtk__exit(bool wait_for_ok);
 #endif
-#endif /* !NEWT_SUPPORT && NO_GTK2_SUPPORT */
+
+#else /* NEWT_SUPPORT || GTK2_SUPPORT */
+
+static inline void setup_browser(bool fallback_to_pager)
+{
+	if (fallback_to_pager)
+		setup_pager();
+}
+static inline void exit_browser(bool wait_for_ok __maybe_unused) {}
+#endif /* NEWT_SUPPORT || GTK2_SUPPORT */
 
 char *alias_lookup(const char *alias);
 int split_cmdline(char *cmdline, const char ***argv);
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 0f6ad7037d9c..03f830b48148 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -49,7 +49,7 @@ int dump_printf(const char *fmt, ...)
 	return ret;
 }
 
-#if !defined(NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
+#if !defined(NEWT_SUPPORT) && !defined(GTK2_SUPPORT)
 int ui__warning(const char *format, ...)
 {
 	va_list args;
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 3fe9ade7a2c2..dec98750b484 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -15,7 +15,14 @@ void trace_event(union perf_event *event);
 struct ui_progress;
 struct perf_error_ops;
 
-#if !defined(NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
+#if defined(NEWT_SUPPORT) || defined(GTK2_SUPPORT)
+
+#include "../ui/progress.h"
+int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
+#include "../ui/util.h"
+
+#else
+
 static inline void ui_progress__update(u64 curr __maybe_unused,
 				       u64 total __maybe_unused,
 				       const char *title __maybe_unused) {}
@@ -34,13 +41,7 @@ perf_error__unregister(struct perf_error_ops *eops __maybe_unused)
 	return 0;
 }
 
-#else /* !NEWT_SUPPORT && NO_GTK2_SUPPORT */
-
-#include "../ui/progress.h"
-int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
-#include "../ui/util.h"
-
-#endif /* !NEWT_SUPPORT && NO_GTK2_SUPPORT */
+#endif /* NEWT_SUPPORT || GTK2_SUPPORT */
 
 int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
 int ui__error_paranoid(void);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 843638d0287f..6ca74079d5c9 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -187,7 +187,11 @@ static inline int hist_entry__tui_annotate(struct hist_entry *self
 #define K_RIGHT -2
 #endif
 
-#ifdef NO_GTK2_SUPPORT
+#ifdef GTK2_SUPPORT
+int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
+				  void(*timer)(void *arg), void *arg,
+				  int refresh);
+#else
 static inline
 int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __maybe_unused,
 				  const char *help __maybe_unused,
@@ -197,11 +201,6 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __maybe_unused,
 {
 	return 0;
 }
-
-#else
-int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
-				  void(*timer)(void *arg), void *arg,
-				  int refresh);
 #endif
 
 unsigned int hists__sort_list_width(struct hists *self);
-- 
1.7.11.4

