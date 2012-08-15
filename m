Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab2HOO6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:58:46 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:46440 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2HOO6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:58:44 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] perf ui: Introduce struct perf_helpline
Date: Wed, 15 Aug 2012 23:57:31 +0900
Message-Id: <1345042655-27862-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add struct perf_helpline in order to provide flexible implementation
of helpline APIs. And convert existing TUI implementation to use it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile          |    5 ++--
 tools/perf/ui/helpline.c     |   56 ++++++++++++++--------------------------
 tools/perf/ui/helpline.h     |   10 +++++++-
 tools/perf/ui/tui/helpline.c |   58 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+), 40 deletions(-)
 create mode 100644 tools/perf/ui/tui/helpline.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e457afa04b59..483fb69fa4ae 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -335,6 +335,7 @@ LIB_H += util/rblist.h
 LIB_H += util/intlist.h
 LIB_H += util/perf_regs.h
 LIB_H += util/unwind.h
+LIB_H += ui/helpline.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -402,6 +403,7 @@ LIB_OBJS += $(OUTPUT)util/cgroup.o
 LIB_OBJS += $(OUTPUT)util/target.o
 LIB_OBJS += $(OUTPUT)util/rblist.o
 LIB_OBJS += $(OUTPUT)util/intlist.o
+LIB_OBJS += $(OUTPUT)ui/helpline.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 
@@ -567,14 +569,13 @@ else
 		LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/map.o
-		LIB_OBJS += $(OUTPUT)ui/helpline.o
 		LIB_OBJS += $(OUTPUT)ui/progress.o
 		LIB_OBJS += $(OUTPUT)ui/util.o
 		LIB_OBJS += $(OUTPUT)ui/tui/setup.o
 		LIB_OBJS += $(OUTPUT)ui/tui/util.o
+		LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
 		LIB_H += ui/browser.h
 		LIB_H += ui/browsers/map.h
-		LIB_H += ui/helpline.h
 		LIB_H += ui/keysyms.h
 		LIB_H += ui/libslang.h
 		LIB_H += ui/progress.h
diff --git a/tools/perf/ui/helpline.c b/tools/perf/ui/helpline.c
index 2f950c2641c8..ac52dd0af49e 100644
--- a/tools/perf/ui/helpline.c
+++ b/tools/perf/ui/helpline.c
@@ -5,23 +5,32 @@
 #include "../debug.h"
 #include "helpline.h"
 #include "ui.h"
-#include "libslang.h"
 
-void ui_helpline__pop(void)
+char ui_helpline__current[512];
+
+static void perf_helpline__pop(void)
 {
 }
 
-char ui_helpline__current[512];
+static void perf_helpline__push(const char *msg __used)
+{
+}
 
-void ui_helpline__push(const char *msg)
+static struct perf_helpline default_helpline_fns = {
+	.pop	= perf_helpline__pop,
+	.push	= perf_helpline__push,
+};
+
+struct perf_helpline *helpline_fns = &default_helpline_fns;
+
+void ui_helpline__pop(void)
 {
-	const size_t sz = sizeof(ui_helpline__current);
+	helpline_fns->pop();
+}
 
-	SLsmg_gotorc(SLtt_Screen_Rows - 1, 0);
-	SLsmg_set_color(0);
-	SLsmg_write_nstring((char *)msg, SLtt_Screen_Cols);
-	SLsmg_refresh();
-	strncpy(ui_helpline__current, msg, sz)[sz - 1] = '\0';
+void ui_helpline__push(const char *msg)
+{
+	helpline_fns->push(msg);
 }
 
 void ui_helpline__vpush(const char *fmt, va_list ap)
@@ -50,30 +59,3 @@ void ui_helpline__puts(const char *msg)
 	ui_helpline__pop();
 	ui_helpline__push(msg);
 }
-
-void ui_helpline__init(void)
-{
-	ui_helpline__puts(" ");
-}
-
-char ui_helpline__last_msg[1024];
-
-int ui_helpline__show_help(const char *format, va_list ap)
-{
-	int ret;
-	static int backlog;
-
-	pthread_mutex_lock(&ui__lock);
-	ret = vscnprintf(ui_helpline__last_msg + backlog,
-			sizeof(ui_helpline__last_msg) - backlog, format, ap);
-	backlog += ret;
-
-	if (ui_helpline__last_msg[backlog - 1] == '\n') {
-		ui_helpline__puts(ui_helpline__last_msg);
-		SLsmg_refresh();
-		backlog = 0;
-	}
-	pthread_mutex_unlock(&ui__lock);
-
-	return ret;
-}
diff --git a/tools/perf/ui/helpline.h b/tools/perf/ui/helpline.h
index 7bab6b34e35e..eee8e2ff51d8 100644
--- a/tools/perf/ui/helpline.h
+++ b/tools/perf/ui/helpline.h
@@ -4,13 +4,21 @@
 #include <stdio.h>
 #include <stdarg.h>
 
+struct perf_helpline {
+	void (*pop)(void);
+	void (*push)(const char *msg);
+};
+
+extern struct perf_helpline *helpline_fns;
+
 void ui_helpline__init(void);
+
 void ui_helpline__pop(void);
 void ui_helpline__push(const char *msg);
 void ui_helpline__vpush(const char *fmt, va_list ap);
 void ui_helpline__fpush(const char *fmt, ...);
 void ui_helpline__puts(const char *msg);
 
-extern char ui_helpline__current[];
+extern char ui_helpline__current[512];
 
 #endif /* _PERF_UI_HELPLINE_H_ */
diff --git a/tools/perf/ui/tui/helpline.c b/tools/perf/ui/tui/helpline.c
new file mode 100644
index 000000000000..b63a9326d06b
--- /dev/null
+++ b/tools/perf/ui/tui/helpline.c
@@ -0,0 +1,58 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <pthread.h>
+
+#include "../../util/debug.h"
+#include "../helpline.h"
+#include "../ui.h"
+#include "../libslang.h"
+
+
+static void tui_helpline__pop(void)
+{
+}
+
+static void tui_helpline__push(const char *msg)
+{
+	const size_t sz = sizeof(ui_helpline__current);
+
+	SLsmg_gotorc(SLtt_Screen_Rows - 1, 0);
+	SLsmg_set_color(0);
+	SLsmg_write_nstring((char *)msg, SLtt_Screen_Cols);
+	SLsmg_refresh();
+	strncpy(ui_helpline__current, msg, sz)[sz - 1] = '\0';
+}
+
+struct perf_helpline tui_helpline_fns = {
+	.pop	= tui_helpline__pop,
+	.push	= tui_helpline__push,
+};
+
+void ui_helpline__init(void)
+{
+	helpline_fns = &tui_helpline_fns;
+	ui_helpline__puts(" ");
+}
+
+char ui_helpline__last_msg[1024];
+
+int ui_helpline__show_help(const char *format, va_list ap)
+{
+	int ret;
+	static int backlog;
+
+	pthread_mutex_lock(&ui__lock);
+	ret = vscnprintf(ui_helpline__last_msg + backlog,
+			sizeof(ui_helpline__last_msg) - backlog, format, ap);
+	backlog += ret;
+
+	if (ui_helpline__last_msg[backlog - 1] == '\n') {
+		ui_helpline__puts(ui_helpline__last_msg);
+		SLsmg_refresh();
+		backlog = 0;
+	}
+	pthread_mutex_unlock(&ui__lock);
+
+	return ret;
+}
-- 
1.7.9.2

