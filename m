Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab2JEIeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:34:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60668 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab2JEIeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:34:03 -0400
Date: Fri, 5 Oct 2012 01:33:43 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-1254b51e32649f2d34ec6b070ed36717c5a6b825@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1348824728-14025-7-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-7-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Convert to NEWT_SUPPORT
Git-Commit-ID: 1254b51e32649f2d34ec6b070ed36717c5a6b825
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:33:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1254b51e32649f2d34ec6b070ed36717c5a6b825
Gitweb:     http://git.kernel.org/tip/1254b51e32649f2d34ec6b070ed36717c5a6b825
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 28 Sep 2012 18:32:02 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:22 -0300

perf tools: Convert to NEWT_SUPPORT

For building perf without libnewt, we can set NO_NEWT=1 as a argument of
make.  It then defines NO_NEWT_SUPPORT macro for C code to do the proper
handling.  However it usually used in a negative semantics - e.g.  #ifndef -
so we saw double negations which can be misleading.  Convert it to a
positive form to make it more readable.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1348824728-14025-7-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        |    8 +++-----
 tools/perf/ui/gtk/util.c   |    2 +-
 tools/perf/ui/helpline.h   |   10 +++++-----
 tools/perf/util/annotate.h |    8 ++++----
 tools/perf/util/cache.h    |   12 ++++++------
 tools/perf/util/debug.c    |    2 +-
 tools/perf/util/debug.h    |    6 +++---
 tools/perf/util/hist.h     |   18 +++++++++---------
 8 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 99b2bb3..3d2181c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -554,16 +554,14 @@ ifndef NO_LIBAUDIT
 	endif
 endif
 
-ifdef NO_NEWT
-	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
-else
+ifndef NO_NEWT
 	FLAGS_NEWT=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lnewt
 	ifneq ($(call try-cc,$(SOURCE_NEWT),$(FLAGS_NEWT)),y)
 		msg := $(warning newt not found, disables TUI support. Please install newt-devel or libnewt-dev);
-		BASIC_CFLAGS += -DNO_NEWT_SUPPORT
 	else
 		# Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
 		BASIC_CFLAGS += -I/usr/include/slang
+		BASIC_CFLAGS += -DNEWT_SUPPORT
 		EXTLIBS += -lnewt -lslang
 		LIB_OBJS += $(OUTPUT)ui/setup.o
 		LIB_OBJS += $(OUTPUT)ui/browser.o
@@ -603,7 +601,7 @@ else
 		LIB_OBJS += $(OUTPUT)ui/gtk/util.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
 		# Make sure that it'd be included only once.
-		ifneq ($(findstring -DNO_NEWT_SUPPORT,$(BASIC_CFLAGS)),)
+		ifeq ($(findstring -DNEWT_SUPPORT,$(BASIC_CFLAGS)),)
 			LIB_OBJS += $(OUTPUT)ui/setup.o
 			LIB_OBJS += $(OUTPUT)ui/util.o
 		endif
diff --git a/tools/perf/ui/gtk/util.c b/tools/perf/ui/gtk/util.c
index 8aada5b..ccb046a 100644
--- a/tools/perf/ui/gtk/util.c
+++ b/tools/perf/ui/gtk/util.c
@@ -116,7 +116,7 @@ struct perf_error_ops perf_gtk_eops = {
  * FIXME: Functions below should be implemented properly.
  *        For now, just add stubs for NO_NEWT=1 build.
  */
-#ifdef NO_NEWT_SUPPORT
+#ifndef NEWT_SUPPORT
 void ui_progress__update(u64 curr __maybe_unused, u64 total __maybe_unused,
 			 const char *title __maybe_unused)
 {
diff --git a/tools/perf/ui/helpline.h b/tools/perf/ui/helpline.h
index 2b667ee..e1f126b 100644
--- a/tools/perf/ui/helpline.h
+++ b/tools/perf/ui/helpline.h
@@ -23,16 +23,16 @@ void ui_helpline__puts(const char *msg);
 
 extern char ui_helpline__current[512];
 
-#ifdef NO_NEWT_SUPPORT
+#ifdef NEWT_SUPPORT
+extern char ui_helpline__last_msg[];
+int ui_helpline__show_help(const char *format, va_list ap);
+#else
 static inline int ui_helpline__show_help(const char *format __maybe_unused,
 					 va_list ap __maybe_unused)
 {
 	return 0;
 }
-#else
-extern char ui_helpline__last_msg[];
-int ui_helpline__show_help(const char *format, va_list ap);
-#endif /* NO_NEWT_SUPPORT */
+#endif /* NEWT_SUPPORT */
 
 #ifdef NO_GTK2_SUPPORT
 static inline int perf_gtk__show_helpline(const char *format __maybe_unused,
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 9b5b21e..39242dc 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -138,7 +138,10 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 			 bool print_lines, bool full_paths, int min_pcnt,
 			 int max_lines);
 
-#ifdef NO_NEWT_SUPPORT
+#ifdef NEWT_SUPPORT
+int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
+			 void(*timer)(void *arg), void *arg, int delay_secs);
+#else
 static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
 				       struct map *map __maybe_unused,
 				       int evidx __maybe_unused,
@@ -148,9 +151,6 @@ static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
 {
 	return 0;
 }
-#else
-int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
-			 void(*timer)(void *arg), void *arg, int delay_secs);
 #endif
 
 extern const char	*disassembler_style;
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index ab17694..70f318d 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -33,7 +33,7 @@ extern int pager_use_color;
 
 extern int use_browser;
 
-#if defined(NO_NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
+#if !defined(NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
 static inline void setup_browser(bool fallback_to_pager)
 {
 	if (fallback_to_pager)
@@ -44,15 +44,15 @@ static inline void exit_browser(bool wait_for_ok __maybe_unused) {}
 void setup_browser(bool fallback_to_pager);
 void exit_browser(bool wait_for_ok);
 
-#ifdef NO_NEWT_SUPPORT
+#ifdef NEWT_SUPPORT
+int ui__init(void);
+void ui__exit(bool wait_for_ok);
+#else
 static inline int ui__init(void)
 {
 	return -1;
 }
 static inline void ui__exit(bool wait_for_ok __maybe_unused) {}
-#else
-int ui__init(void);
-void ui__exit(bool wait_for_ok);
 #endif
 
 #ifdef NO_GTK2_SUPPORT
@@ -65,7 +65,7 @@ static inline void perf_gtk__exit(bool wait_for_ok __maybe_unused) {}
 int perf_gtk__init(void);
 void perf_gtk__exit(bool wait_for_ok);
 #endif
-#endif /* NO_NEWT_SUPPORT && NO_GTK2_SUPPORT */
+#endif /* !NEWT_SUPPORT && NO_GTK2_SUPPORT */
 
 char *alias_lookup(const char *alias);
 int split_cmdline(char *cmdline, const char ***argv);
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 66eb382..0f6ad70 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -49,7 +49,7 @@ int dump_printf(const char *fmt, ...)
 	return ret;
 }
 
-#if defined(NO_NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
+#if !defined(NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
 int ui__warning(const char *format, ...)
 {
 	va_list args;
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index bb2e7d1..3fe9ade 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -15,7 +15,7 @@ void trace_event(union perf_event *event);
 struct ui_progress;
 struct perf_error_ops;
 
-#if defined(NO_NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
+#if !defined(NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
 static inline void ui_progress__update(u64 curr __maybe_unused,
 				       u64 total __maybe_unused,
 				       const char *title __maybe_unused) {}
@@ -34,13 +34,13 @@ perf_error__unregister(struct perf_error_ops *eops __maybe_unused)
 	return 0;
 }
 
-#else /* NO_NEWT_SUPPORT && NO_GTK2_SUPPORT */
+#else /* !NEWT_SUPPORT && NO_GTK2_SUPPORT */
 
 #include "../ui/progress.h"
 int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
 #include "../ui/util.h"
 
-#endif /* NO_NEWT_SUPPORT && NO_GTK2_SUPPORT */
+#endif /* !NEWT_SUPPORT && NO_GTK2_SUPPORT */
 
 int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
 int ui__error_paranoid(void);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index f011ad4..843638d 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -154,7 +154,15 @@ int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
 
 struct perf_evlist;
 
-#ifdef NO_NEWT_SUPPORT
+#ifdef NEWT_SUPPORT
+#include "../ui/keysyms.h"
+int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
+			     void(*timer)(void *arg), void *arg, int delay_secs);
+
+int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
+				  void(*timer)(void *arg), void *arg,
+				  int refresh);
+#else
 static inline
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __maybe_unused,
 				  const char *help __maybe_unused,
@@ -177,14 +185,6 @@ static inline int hist_entry__tui_annotate(struct hist_entry *self
 }
 #define K_LEFT -1
 #define K_RIGHT -2
-#else
-#include "../ui/keysyms.h"
-int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
-			     void(*timer)(void *arg), void *arg, int delay_secs);
-
-int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
-				  void(*timer)(void *arg), void *arg,
-				  int refresh);
 #endif
 
 #ifdef NO_GTK2_SUPPORT
