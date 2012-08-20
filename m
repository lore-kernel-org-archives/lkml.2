Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2HTEpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:45:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61856 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab2HTEpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:45:15 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        David Ahern <dsahern@gmail.com>
Subject: [RFC PATCH 4/7] perf: make gtk2 support based on CONFIG_GTK2
Date: Sun, 19 Aug 2012 22:44:48 -0600
Message-Id: <1345437891-78830-5-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1345437891-78830-1-git-send-email-dsahern@gmail.com>
References: <1345437891-78830-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile                 |   46 ++++++++++++++++-------------------
 tools/perf/config/feature-tests.mak |    2 +-
 tools/perf/ui/helpline.h            |    9 ++++---
 tools/perf/util/cache.h             |   13 +++++-----
 tools/perf/util/debug.c             |    2 +-
 tools/perf/util/debug.h             |    7 +++---
 tools/perf/util/hist.h              |   12 ++++-----
 7 files changed, 45 insertions(+), 46 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 35448ef..715c0ee 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -36,8 +36,6 @@ include config/utilities.mak
 #
 # Define NO_NEWT if you do not want TUI support.
 #
-# Define NO_GTK2 if you do not want GTK+ GUI support.
-#
 # Define NO_DEMANGLE if you do not want C++ symbol demangling.
 #
 # Define NO_LIBELF if you do not want libelf dependency (e.g. cross-builds)
@@ -585,29 +583,27 @@ else
 	endif
 endif
 
-ifdef NO_GTK2
-	BASIC_CFLAGS += -DNO_GTK2_SUPPORT
-else
-	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
-	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
-		msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
-		BASIC_CFLAGS += -DNO_GTK2_SUPPORT
-	else
-		ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2)),y)
-			BASIC_CFLAGS += -DHAVE_GTK_INFO_BAR
-		endif
-		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
-		EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
-		LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/util.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
-		# Make sure that it'd be included only once.
-		ifneq ($(findstring -DNO_NEWT_SUPPORT,$(BASIC_CFLAGS)),)
-			LIB_OBJS += $(OUTPUT)ui/setup.o
-			LIB_OBJS += $(OUTPUT)ui/util.o
-		endif
-	endif
+ifdef CONFIG_GTK2
+    FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
+    ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
+        $(warning GTK2 not found. Please install gtk2-devel or libgtk2.0-dev or unset CONFIG_GTK2)
+        $(error )
+    endif
+    ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2)),y)
+        BASIC_CFLAGS += -DHAVE_GTK_INFO_BAR
+    endif
+    BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
+    EXTLIBS += $(shell pkg-config --libs gtk+-2.0)
+    LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
+    LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
+    LIB_OBJS += $(OUTPUT)ui/gtk/util.o
+    LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
+
+    # Make sure that it'd be included only once.
+    ifneq ($(findstring -DNO_NEWT_SUPPORT,$(BASIC_CFLAGS)),)
+        LIB_OBJS += $(OUTPUT)ui/setup.o
+        LIB_OBJS += $(OUTPUT)ui/util.o
+    endif
 endif
 
 ifdef CONFIG_LIBPERL
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index dbf1127..56eb0b7 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -65,7 +65,7 @@ int main(void)
 endef
 endif
 
-ifndef NO_GTK2
+ifdef CONFIG_GTK2
 define SOURCE_GTK2
 #pragma GCC diagnostic ignored \"-Wstrict-prototypes\"
 #include <gtk/gtk.h>
diff --git a/tools/perf/ui/helpline.h b/tools/perf/ui/helpline.h
index a2487f9..5a84b7d 100644
--- a/tools/perf/ui/helpline.h
+++ b/tools/perf/ui/helpline.h
@@ -5,6 +5,7 @@
 #include <stdarg.h>
 
 #include "../util/cache.h"
+#include "generated/autoconf.h"
 
 struct ui_helpline {
 	void (*pop)(void);
@@ -34,14 +35,14 @@ extern char ui_helpline__last_msg[];
 int ui_helpline__show_help(const char *format, va_list ap);
 #endif /* NO_NEWT_SUPPORT */
 
-#ifdef NO_GTK2_SUPPORT
+#ifdef CONFIG_GTK2
+int perf_gtk__show_helpline(const char *format, va_list ap);
+#else
 static inline int perf_gtk__show_helpline(const char *format __used,
 					  va_list ap __used)
 {
 	return 0;
 }
-#else
-int perf_gtk__show_helpline(const char *format, va_list ap);
-#endif /* NO_GTK2_SUPPORT */
+#endif /* CONFIG_GTK2 */
 
 #endif /* _PERF_UI_HELPLINE_H_ */
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index cff18c6..45c7373 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -5,6 +5,7 @@
 #include "util.h"
 #include "strbuf.h"
 #include "../perf.h"
+#include "generated/autoconf.h"
 
 #define CMD_EXEC_PATH "--exec-path"
 #define CMD_PERF_DIR "--perf-dir="
@@ -33,7 +34,7 @@ extern int pager_use_color;
 
 extern int use_browser;
 
-#if defined(NO_NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
+#if defined(NO_NEWT_SUPPORT) && !defined(CONFIG_GTK2)
 static inline void setup_browser(bool fallback_to_pager)
 {
 	if (fallback_to_pager)
@@ -55,17 +56,17 @@ int ui__init(void);
 void ui__exit(bool wait_for_ok);
 #endif
 
-#ifdef NO_GTK2_SUPPORT
+#ifdef CONFIG_GTK2
+int perf_gtk__init(void);
+void perf_gtk__exit(bool wait_for_ok);
+#else
 static inline int perf_gtk__init(void)
 {
 	return -1;
 }
 static inline void perf_gtk__exit(bool wait_for_ok __used) {}
-#else
-int perf_gtk__init(void);
-void perf_gtk__exit(bool wait_for_ok);
 #endif
-#endif /* NO_NEWT_SUPPORT && NO_GTK2_SUPPORT */
+#endif /* NO_NEWT_SUPPORT && CONFIG_GTK2 */
 
 char *alias_lookup(const char *alias);
 int split_cmdline(char *cmdline, const char ***argv);
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 66eb382..8507aee 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -49,7 +49,7 @@ int dump_printf(const char *fmt, ...)
 	return ret;
 }
 
-#if defined(NO_NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
+#if defined(NO_NEWT_SUPPORT) && !defined(CONFIG_GTK2)
 int ui__warning(const char *format, ...)
 {
 	va_list args;
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 05e660c..fab793b 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -5,6 +5,7 @@
 #include <stdbool.h>
 #include "event.h"
 #include "../ui/helpline.h"
+#include "generated/autoconf.h"
 
 extern int verbose;
 extern bool quiet, dump_trace;
@@ -15,7 +16,7 @@ void trace_event(union perf_event *event);
 struct ui_progress;
 struct perf_error_ops;
 
-#if defined(NO_NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
+#if defined(NO_NEWT_SUPPORT) && !defined(CONFIG_GTK2)
 static inline void ui_progress__update(u64 curr __used, u64 total __used,
 				       const char *title __used) {}
 
@@ -33,13 +34,13 @@ perf_error__unregister(struct perf_error_ops *eops __used)
 	return 0;
 }
 
-#else /* NO_NEWT_SUPPORT && NO_GTK2_SUPPORT */
+#else /* NO_NEWT_SUPPORT && !CONFIG_GTK2 */
 
 #include "../ui/progress.h"
 int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
 #include "../ui/util.h"
 
-#endif /* NO_NEWT_SUPPORT && NO_GTK2_SUPPORT */
+#endif /* NO_NEWT_SUPPORT && !CONFIG_GTK2 */
 
 int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
 int ui__error_paranoid(void);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 0b096c2..a8edb00 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <pthread.h>
 #include "callchain.h"
+#include "generated/autoconf.h"
 
 extern struct callchain_param callchain_param;
 
@@ -146,7 +147,11 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 				  int refresh);
 #endif
 
-#ifdef NO_GTK2_SUPPORT
+#ifdef CONFIG_GTK2
+int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
+				  void(*timer)(void *arg), void *arg,
+				  int refresh);
+#else
 static inline
 int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __used,
 				  const char *help __used,
@@ -156,11 +161,6 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __used,
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
1.7.10.1

