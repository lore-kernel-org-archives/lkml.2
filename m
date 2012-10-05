Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab2JEIfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:35:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60680 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2JEIe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:34:58 -0400
Date: Fri, 5 Oct 2012 01:34:40 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-f9f526ecdc09a851f4f5567ebcf9bc553778f6c2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1348824728-14025-8-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-8-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Convert to GTK2_SUPPORT
Git-Commit-ID: f9f526ecdc09a851f4f5567ebcf9bc553778f6c2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:34:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9f526ecdc09a851f4f5567ebcf9bc553778f6c2
Gitweb:     http://git.kernel.org/tip/f9f526ecdc09a851f4f5567ebcf9bc553778f6c2
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 28 Sep 2012 18:32:03 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:23 -0300

perf tools: Convert to GTK2_SUPPORT

For building perf without gtk+2, we can set NO_GTK2=1 as a argument of
make.  It then defines NO_GTK2_SUPPORT macro for C code to do the
proper handling.  However it usually used in a negative semantics -
e.g. #ifndef - so we saw double negations which can be misleading.
Convert it to a positive form to make it more readable.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1348824728-14025-8-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile      |    6 ++----
 tools/perf/ui/helpline.h |    8 ++++----
 tools/perf/util/cache.h  |   28 +++++++++++++++-------------
 tools/perf/util/debug.c  |    2 +-
 tools/perf/util/debug.h  |   17 +++++++++--------
 tools/perf/util/hist.h   |   11 +++++------
 6 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3d2181c..31a07f9 100644
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
index e1f126b..baa28a4 100644
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
index 70f318d..07aec06 100644
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
index 0f6ad70..03f830b 100644
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
index 3fe9ade..dec9875 100644
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
index 843638d..6ca7407 100644
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
