Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab2HTQcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:32:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:56621 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab2HTQ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/24] perf ui gtk: Add perf_gtk__show_helpline() for pr_*
Date: Mon, 20 Aug 2012 13:26:14 -0300
Message-Id: <1345479985-18669-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345479985-18669-1-git-send-email-acme@infradead.org>
References: <1345479985-18669-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Use helpline for printing error/debug messages. The code resembles a TUI
counter part and only print the first line of the message.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1345104894-14205-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/helpline.c |   26 ++++++++++++++++++++++++++
 tools/perf/ui/gtk/util.c     |    5 -----
 tools/perf/ui/helpline.h     |   23 +++++++++++++++++++++++
 tools/perf/ui/setup.c        |    4 ++++
 tools/perf/ui/tui/setup.c    |    2 --
 tools/perf/util/debug.c      |    4 +++-
 tools/perf/util/debug.h      |    8 +-------
 7 files changed, 57 insertions(+), 15 deletions(-)

diff --git a/tools/perf/ui/gtk/helpline.c b/tools/perf/ui/gtk/helpline.c
index 2511b37..5db4432 100644
--- a/tools/perf/ui/gtk/helpline.c
+++ b/tools/perf/ui/gtk/helpline.c
@@ -1,5 +1,10 @@
+#include <stdio.h>
+#include <string.h>
+
 #include "gtk.h"
+#include "../ui.h"
 #include "../helpline.h"
+#include "../../util/debug.h"
 
 static void gtk_helpline_pop(void)
 {
@@ -28,3 +33,24 @@ void perf_gtk__init_helpline(void)
 {
 	helpline_fns = &gtk_helpline_fns;
 }
+
+int perf_gtk__show_helpline(const char *fmt, va_list ap)
+{
+	int ret;
+	char *ptr;
+	static int backlog;
+
+	ret = vscnprintf(ui_helpline__current + backlog,
+			 sizeof(ui_helpline__current) - backlog, fmt, ap);
+	backlog += ret;
+
+	/* only first line can be displayed */
+	ptr = strchr(ui_helpline__current, '\n');
+	if (ptr && (ptr - ui_helpline__current) <= backlog) {
+		*ptr = '\0';
+		ui_helpline__puts(ui_helpline__current);
+		backlog = 0;
+	}
+
+	return ret;
+}
diff --git a/tools/perf/ui/gtk/util.c b/tools/perf/ui/gtk/util.c
index 0ead373..b8efb96 100644
--- a/tools/perf/ui/gtk/util.c
+++ b/tools/perf/ui/gtk/util.c
@@ -117,11 +117,6 @@ struct perf_error_ops perf_gtk_eops = {
  *        For now, just add stubs for NO_NEWT=1 build.
  */
 #ifdef NO_NEWT_SUPPORT
-int ui_helpline__show_help(const char *format __used, va_list ap __used)
-{
-	return 0;
-}
-
 void ui_progress__update(u64 curr __used, u64 total __used,
 			 const char *title __used)
 {
diff --git a/tools/perf/ui/helpline.h b/tools/perf/ui/helpline.h
index 61118b2..a2487f9 100644
--- a/tools/perf/ui/helpline.h
+++ b/tools/perf/ui/helpline.h
@@ -4,6 +4,8 @@
 #include <stdio.h>
 #include <stdarg.h>
 
+#include "../util/cache.h"
+
 struct ui_helpline {
 	void (*pop)(void);
 	void (*push)(const char *msg);
@@ -21,4 +23,25 @@ void ui_helpline__puts(const char *msg);
 
 extern char ui_helpline__current[512];
 
+#ifdef NO_NEWT_SUPPORT
+static inline int ui_helpline__show_help(const char *format __used,
+					 va_list ap __used)
+{
+	return 0;
+}
+#else
+extern char ui_helpline__last_msg[];
+int ui_helpline__show_help(const char *format, va_list ap);
+#endif /* NO_NEWT_SUPPORT */
+
+#ifdef NO_GTK2_SUPPORT
+static inline int perf_gtk__show_helpline(const char *format __used,
+					  va_list ap __used)
+{
+	return 0;
+}
+#else
+int perf_gtk__show_helpline(const char *format, va_list ap);
+#endif /* NO_GTK2_SUPPORT */
+
 #endif /* _PERF_UI_HELPLINE_H_ */
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 791fb15..c7820e5 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -1,7 +1,11 @@
+#include <pthread.h>
+
 #include "../cache.h"
 #include "../debug.h"
 
 
+pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
+
 void setup_browser(bool fallback_to_pager)
 {
 	if (!isatty(1) || dump_trace)
diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
index e813c1d..4c936e0 100644
--- a/tools/perf/ui/tui/setup.c
+++ b/tools/perf/ui/tui/setup.c
@@ -11,8 +11,6 @@
 #include "../libslang.h"
 #include "../keysyms.h"
 
-pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
-
 static volatile int ui__need_resize;
 
 extern struct perf_error_ops perf_tui_eops;
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 4dfe0bb..66eb382 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -23,8 +23,10 @@ int eprintf(int level, const char *fmt, ...)
 
 	if (verbose >= level) {
 		va_start(args, fmt);
-		if (use_browser > 0)
+		if (use_browser == 1)
 			ret = ui_helpline__show_help(fmt, args);
+		else if (use_browser == 2)
+			ret = perf_gtk__show_helpline(fmt, args);
 		else
 			ret = vfprintf(stderr, fmt, args);
 		va_end(args);
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 015c91d..05e660c 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -4,6 +4,7 @@
 
 #include <stdbool.h>
 #include "event.h"
+#include "../ui/helpline.h"
 
 extern int verbose;
 extern bool quiet, dump_trace;
@@ -15,11 +16,6 @@ struct ui_progress;
 struct perf_error_ops;
 
 #if defined(NO_NEWT_SUPPORT) && defined(NO_GTK2_SUPPORT)
-static inline int ui_helpline__show_help(const char *format __used, va_list ap __used)
-{
-	return 0;
-}
-
 static inline void ui_progress__update(u64 curr __used, u64 total __used,
 				       const char *title __used) {}
 
@@ -39,8 +35,6 @@ perf_error__unregister(struct perf_error_ops *eops __used)
 
 #else /* NO_NEWT_SUPPORT && NO_GTK2_SUPPORT */
 
-extern char ui_helpline__last_msg[];
-int ui_helpline__show_help(const char *format, va_list ap);
 #include "../ui/progress.h"
 int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
 #include "../ui/util.h"
-- 
1.7.1

