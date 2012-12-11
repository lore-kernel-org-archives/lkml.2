Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab2LKWsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:48:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43793 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab2LKWsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:37 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/37] perf ui/helpline: Introduce ui_helpline__vshow()
Date: Tue, 11 Dec 2012 19:47:49 -0300
Message-Id: <1355266103-17238-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The ui_helpline__vshow() will be used for pr_* functions.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1352911664-24620-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/helpline.c |   23 ++++++++++++-----------
 tools/perf/ui/helpline.c     |   12 ++++++++++++
 tools/perf/ui/helpline.h     |   22 ++--------------------
 tools/perf/ui/tui/helpline.c |   29 +++++++++++++++--------------
 tools/perf/util/debug.c      |    6 ++----
 5 files changed, 43 insertions(+), 49 deletions(-)

diff --git a/tools/perf/ui/gtk/helpline.c b/tools/perf/ui/gtk/helpline.c
index 5db4432..3388cbd 100644
--- a/tools/perf/ui/gtk/helpline.c
+++ b/tools/perf/ui/gtk/helpline.c
@@ -24,17 +24,7 @@ static void gtk_helpline_push(const char *msg)
 			   pgctx->statbar_ctx_id, msg);
 }
 
-static struct ui_helpline gtk_helpline_fns = {
-	.pop	= gtk_helpline_pop,
-	.push	= gtk_helpline_push,
-};
-
-void perf_gtk__init_helpline(void)
-{
-	helpline_fns = &gtk_helpline_fns;
-}
-
-int perf_gtk__show_helpline(const char *fmt, va_list ap)
+static int gtk_helpline_show(const char *fmt, va_list ap)
 {
 	int ret;
 	char *ptr;
@@ -54,3 +44,14 @@ int perf_gtk__show_helpline(const char *fmt, va_list ap)
 
 	return ret;
 }
+
+static struct ui_helpline gtk_helpline_fns = {
+	.pop	= gtk_helpline_pop,
+	.push	= gtk_helpline_push,
+	.show	= gtk_helpline_show,
+};
+
+void perf_gtk__init_helpline(void)
+{
+	helpline_fns = &gtk_helpline_fns;
+}
diff --git a/tools/perf/ui/helpline.c b/tools/perf/ui/helpline.c
index a49bcf3..700fb3c 100644
--- a/tools/perf/ui/helpline.c
+++ b/tools/perf/ui/helpline.c
@@ -16,9 +16,16 @@ static void nop_helpline__push(const char *msg __maybe_unused)
 {
 }
 
+static int nop_helpline__show(const char *fmt __maybe_unused,
+			       va_list ap __maybe_unused)
+{
+	return 0;
+}
+
 static struct ui_helpline default_helpline_fns = {
 	.pop	= nop_helpline__pop,
 	.push	= nop_helpline__push,
+	.show	= nop_helpline__show,
 };
 
 struct ui_helpline *helpline_fns = &default_helpline_fns;
@@ -59,3 +66,8 @@ void ui_helpline__puts(const char *msg)
 	ui_helpline__pop();
 	ui_helpline__push(msg);
 }
+
+int ui_helpline__vshow(const char *fmt, va_list ap)
+{
+	return helpline_fns->show(fmt, ap);
+}
diff --git a/tools/perf/ui/helpline.h b/tools/perf/ui/helpline.h
index baa28a4..46181f4 100644
--- a/tools/perf/ui/helpline.h
+++ b/tools/perf/ui/helpline.h
@@ -9,6 +9,7 @@
 struct ui_helpline {
 	void (*pop)(void);
 	void (*push)(const char *msg);
+	int  (*show)(const char *fmt, va_list ap);
 };
 
 extern struct ui_helpline *helpline_fns;
@@ -20,28 +21,9 @@ void ui_helpline__push(const char *msg);
 void ui_helpline__vpush(const char *fmt, va_list ap);
 void ui_helpline__fpush(const char *fmt, ...);
 void ui_helpline__puts(const char *msg);
+int  ui_helpline__vshow(const char *fmt, va_list ap);
 
 extern char ui_helpline__current[512];
-
-#ifdef NEWT_SUPPORT
 extern char ui_helpline__last_msg[];
-int ui_helpline__show_help(const char *format, va_list ap);
-#else
-static inline int ui_helpline__show_help(const char *format __maybe_unused,
-					 va_list ap __maybe_unused)
-{
-	return 0;
-}
-#endif /* NEWT_SUPPORT */
-
-#ifdef GTK2_SUPPORT
-int perf_gtk__show_helpline(const char *format, va_list ap);
-#else
-static inline int perf_gtk__show_helpline(const char *format __maybe_unused,
-					  va_list ap __maybe_unused)
-{
-	return 0;
-}
-#endif /* GTK2_SUPPORT */
 
 #endif /* _PERF_UI_HELPLINE_H_ */
diff --git a/tools/perf/ui/tui/helpline.c b/tools/perf/ui/tui/helpline.c
index 2884d2f..1c8b9af 100644
--- a/tools/perf/ui/tui/helpline.c
+++ b/tools/perf/ui/tui/helpline.c
@@ -8,6 +8,8 @@
 #include "../ui.h"
 #include "../libslang.h"
 
+char ui_helpline__last_msg[1024];
+
 static void tui_helpline__pop(void)
 {
 }
@@ -23,20 +25,7 @@ static void tui_helpline__push(const char *msg)
 	strncpy(ui_helpline__current, msg, sz)[sz - 1] = '\0';
 }
 
-struct ui_helpline tui_helpline_fns = {
-	.pop	= tui_helpline__pop,
-	.push	= tui_helpline__push,
-};
-
-void ui_helpline__init(void)
-{
-	helpline_fns = &tui_helpline_fns;
-	ui_helpline__puts(" ");
-}
-
-char ui_helpline__last_msg[1024];
-
-int ui_helpline__show_help(const char *format, va_list ap)
+static int tui_helpline__show(const char *format, va_list ap)
 {
 	int ret;
 	static int backlog;
@@ -55,3 +44,15 @@ int ui_helpline__show_help(const char *format, va_list ap)
 
 	return ret;
 }
+
+struct ui_helpline tui_helpline_fns = {
+	.pop	= tui_helpline__pop,
+	.push	= tui_helpline__push,
+	.show	= tui_helpline__show,
+};
+
+void ui_helpline__init(void)
+{
+	helpline_fns = &tui_helpline_fns;
+	ui_helpline__puts(" ");
+}
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 39861a2a..391c9a9 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -23,10 +23,8 @@ int eprintf(int level, const char *fmt, ...)
 
 	if (verbose >= level) {
 		va_start(args, fmt);
-		if (use_browser == 1)
-			ret = ui_helpline__show_help(fmt, args);
-		else if (use_browser == 2)
-			ret = perf_gtk__show_helpline(fmt, args);
+		if (use_browser > 1)
+			ui_helpline__vshow(fmt, args);
 		else
 			ret = vfprintf(stderr, fmt, args);
 		va_end(args);
-- 
1.7.9.2.358.g22243

