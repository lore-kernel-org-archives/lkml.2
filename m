Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab2HTEpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:45:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2HTEpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:45:19 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        David Ahern <dsahern@gmail.com>
Subject: [RFC PATCH 5/7] perf: make newt support based on CONFIG_NEWT
Date: Sun, 19 Aug 2012 22:44:49 -0600
Message-Id: <1345437891-78830-6-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1345437891-78830-1-git-send-email-dsahern@gmail.com>
References: <1345437891-78830-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile                 |   60 ++++++++++++++++-------------------
 tools/perf/config/feature-tests.mak |    2 +-
 tools/perf/ui/gtk/util.c            |    4 +--
 tools/perf/ui/helpline.h            |   10 +++---
 tools/perf/util/annotate.h          |    9 +++---
 tools/perf/util/cache.h             |   12 +++----
 tools/perf/util/debug.c             |    2 +-
 tools/perf/util/debug.h             |    6 ++--
 tools/perf/util/hist.h              |   18 +++++------
 9 files changed, 60 insertions(+), 63 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 715c0ee..012434d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -34,8 +34,6 @@ include config/utilities.mak
 #
 # Define WERROR=0 to disable treating any warnings as errors.
 #
-# Define NO_NEWT if you do not want TUI support.
-#
 # Define NO_DEMANGLE if you do not want C++ symbol demangling.
 #
 # Define NO_LIBELF if you do not want libelf dependency (e.g. cross-builds)
@@ -552,35 +550,33 @@ else
 	LIB_OBJS += $(OUTPUT)util/unwind.o
 endif
 
-ifdef NO_NEWT
-	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
-else
-	FLAGS_NEWT=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lnewt
-	ifneq ($(call try-cc,$(SOURCE_NEWT),$(FLAGS_NEWT)),y)
-		msg := $(warning newt not found, disables TUI support. Please install newt-devel or libnewt-dev);
-		BASIC_CFLAGS += -DNO_NEWT_SUPPORT
-	else
-		# Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
-		BASIC_CFLAGS += -I/usr/include/slang
-		EXTLIBS += -lnewt -lslang
-		LIB_OBJS += $(OUTPUT)ui/setup.o
-		LIB_OBJS += $(OUTPUT)ui/browser.o
-		LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
-		LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
-		LIB_OBJS += $(OUTPUT)ui/browsers/map.o
-		LIB_OBJS += $(OUTPUT)ui/progress.o
-		LIB_OBJS += $(OUTPUT)ui/util.o
-		LIB_OBJS += $(OUTPUT)ui/tui/setup.o
-		LIB_OBJS += $(OUTPUT)ui/tui/util.o
-		LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
-		LIB_H += ui/browser.h
-		LIB_H += ui/browsers/map.h
-		LIB_H += ui/keysyms.h
-		LIB_H += ui/libslang.h
-		LIB_H += ui/progress.h
-		LIB_H += ui/util.h
-		LIB_H += ui/ui.h
-	endif
+ifdef CONFIG_NEWT
+    FLAGS_NEWT=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lnewt
+    ifneq ($(call try-cc,$(SOURCE_NEWT),$(FLAGS_NEWT)),y)
+        $(warning newt not found. Please install newt-devel or libnewt-dev or disable CONFIG_NEWT)
+        $(error )
+    endif
+
+    # Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
+    BASIC_CFLAGS += -I/usr/include/slang
+    EXTLIBS += -lnewt -lslang
+    LIB_OBJS += $(OUTPUT)ui/setup.o
+    LIB_OBJS += $(OUTPUT)ui/browser.o
+    LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
+    LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
+    LIB_OBJS += $(OUTPUT)ui/browsers/map.o
+    LIB_OBJS += $(OUTPUT)ui/progress.o
+    LIB_OBJS += $(OUTPUT)ui/util.o
+    LIB_OBJS += $(OUTPUT)ui/tui/setup.o
+    LIB_OBJS += $(OUTPUT)ui/tui/util.o
+    LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
+    LIB_H += ui/browser.h
+    LIB_H += ui/browsers/map.h
+    LIB_H += ui/keysyms.h
+    LIB_H += ui/libslang.h
+    LIB_H += ui/progress.h
+    LIB_H += ui/util.h
+    LIB_H += ui/ui.h
 endif
 
 ifdef CONFIG_GTK2
@@ -600,7 +596,7 @@ ifdef CONFIG_GTK2
     LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
 
     # Make sure that it'd be included only once.
-    ifneq ($(findstring -DNO_NEWT_SUPPORT,$(BASIC_CFLAGS)),)
+    ifndef CONFIG_NEWT
         LIB_OBJS += $(OUTPUT)ui/setup.o
         LIB_OBJS += $(OUTPUT)ui/util.o
     endif
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 56eb0b7..aabe4e4 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -52,7 +52,7 @@ int main(void)
 }
 endef
 
-ifndef NO_NEWT
+ifdef CONFIG_NEWT
 define SOURCE_NEWT
 #include <newt.h>
 
diff --git a/tools/perf/ui/gtk/util.c b/tools/perf/ui/gtk/util.c
index b8efb96..bdead4a 100644
--- a/tools/perf/ui/gtk/util.c
+++ b/tools/perf/ui/gtk/util.c
@@ -114,9 +114,9 @@ struct perf_error_ops perf_gtk_eops = {
 
 /*
  * FIXME: Functions below should be implemented properly.
- *        For now, just add stubs for NO_NEWT=1 build.
+ *        For now, just add stubs for !CONFIG_NEWT build.
  */
-#ifdef NO_NEWT_SUPPORT
+#ifndef CONFIG_NEWT
 void ui_progress__update(u64 curr __used, u64 total __used,
 			 const char *title __used)
 {
diff --git a/tools/perf/ui/helpline.h b/tools/perf/ui/helpline.h
index 5a84b7d..f287b34 100644
--- a/tools/perf/ui/helpline.h
+++ b/tools/perf/ui/helpline.h
@@ -24,16 +24,16 @@ void ui_helpline__puts(const char *msg);
 
 extern char ui_helpline__current[512];
 
-#ifdef NO_NEWT_SUPPORT
+#ifdef CONFIG_NEWT
+extern char ui_helpline__last_msg[];
+int ui_helpline__show_help(const char *format, va_list ap);
+#else
 static inline int ui_helpline__show_help(const char *format __used,
 					 va_list ap __used)
 {
 	return 0;
 }
-#else
-extern char ui_helpline__last_msg[];
-int ui_helpline__show_help(const char *format, va_list ap);
-#endif /* NO_NEWT_SUPPORT */
+#endif /* CONFIG_NEWT */
 
 #ifdef CONFIG_GTK2
 int perf_gtk__show_helpline(const char *format, va_list ap);
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 78a5692..c50e5b6 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -7,6 +7,7 @@
 #include "symbol.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
+#include "generated/autoconf.h"
 
 struct ins;
 
@@ -137,7 +138,10 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 			 bool print_lines, bool full_paths, int min_pcnt,
 			 int max_lines);
 
-#ifdef NO_NEWT_SUPPORT
+#ifdef CONFIG_NEWT
+int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
+			 void(*timer)(void *arg), void *arg, int delay_secs);
+#else
 static inline int symbol__tui_annotate(struct symbol *sym __used,
 				       struct map *map __used,
 				       int evidx __used,
@@ -146,9 +150,6 @@ static inline int symbol__tui_annotate(struct symbol *sym __used,
 {
 	return 0;
 }
-#else
-int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
-			 void(*timer)(void *arg), void *arg, int delay_secs);
 #endif
 
 extern const char	*disassembler_style;
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 45c7373..fa94fc9 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -34,7 +34,7 @@ extern int pager_use_color;
 
 extern int use_browser;
 
-#if defined(NO_NEWT_SUPPORT) && !defined(CONFIG_GTK2)
+#if !defined(CONFIG_NEWT) && !defined(CONFIG_GTK2)
 static inline void setup_browser(bool fallback_to_pager)
 {
 	if (fallback_to_pager)
@@ -45,15 +45,15 @@ static inline void exit_browser(bool wait_for_ok __used) {}
 void setup_browser(bool fallback_to_pager);
 void exit_browser(bool wait_for_ok);
 
-#ifdef NO_NEWT_SUPPORT
+#ifdef CONFIG_NEWT
+int ui__init(void);
+void ui__exit(bool wait_for_ok);
+#else
 static inline int ui__init(void)
 {
 	return -1;
 }
 static inline void ui__exit(bool wait_for_ok __used) {}
-#else
-int ui__init(void);
-void ui__exit(bool wait_for_ok);
 #endif
 
 #ifdef CONFIG_GTK2
@@ -66,7 +66,7 @@ static inline int perf_gtk__init(void)
 }
 static inline void perf_gtk__exit(bool wait_for_ok __used) {}
 #endif
-#endif /* NO_NEWT_SUPPORT && CONFIG_GTK2 */
+#endif /* CONFIG_NEWT && CONFIG_GTK2 */
 
 char *alias_lookup(const char *alias);
 int split_cmdline(char *cmdline, const char ***argv);
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 8507aee..2eb80bb 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -49,7 +49,7 @@ int dump_printf(const char *fmt, ...)
 	return ret;
 }
 
-#if defined(NO_NEWT_SUPPORT) && !defined(CONFIG_GTK2)
+#if !defined(CONFIG_NEWT) && !defined(CONFIG_GTK2)
 int ui__warning(const char *format, ...)
 {
 	va_list args;
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index fab793b..de2b6b0 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -16,7 +16,7 @@ void trace_event(union perf_event *event);
 struct ui_progress;
 struct perf_error_ops;
 
-#if defined(NO_NEWT_SUPPORT) && !defined(CONFIG_GTK2)
+#if !defined(CONFIG_NEWT) && !defined(CONFIG_GTK2)
 static inline void ui_progress__update(u64 curr __used, u64 total __used,
 				       const char *title __used) {}
 
@@ -34,13 +34,13 @@ perf_error__unregister(struct perf_error_ops *eops __used)
 	return 0;
 }
 
-#else /* NO_NEWT_SUPPORT && !CONFIG_GTK2 */
+#else /* !CONFIG_NEWT && !CONFIG_GTK2 */
 
 #include "../ui/progress.h"
 int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
 #include "../ui/util.h"
 
-#endif /* NO_NEWT_SUPPORT && !CONFIG_GTK2 */
+#endif /* !CONFIG_NEWT && !CONFIG_GTK2 */
 
 int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
 int ui__error_paranoid(void);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a8edb00..cb27fd6a 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -116,7 +116,15 @@ bool hists__new_col_len(struct hists *self, enum hist_column col, u16 len);
 
 struct perf_evlist;
 
-#ifdef NO_NEWT_SUPPORT
+#ifdef CONFIG_NEWT
+#include "../ui/keysyms.h"
+int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
+			     void(*timer)(void *arg), void *arg, int delay_secs);
+
+int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
+				  void(*timer)(void *arg), void *arg,
+				  int refresh);
+#else
 static inline
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __used,
 				  const char *help __used,
@@ -137,14 +145,6 @@ static inline int hist_entry__tui_annotate(struct hist_entry *self __used,
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
 
 #ifdef CONFIG_GTK2
-- 
1.7.10.1

