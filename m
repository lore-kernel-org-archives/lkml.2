Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2HTQ0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:26:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:56614 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab2HTQ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/24] perf ui: Introduce struct ui_helpline
Date: Mon, 20 Aug 2012 13:26:11 -0300
Message-Id: <1345479985-18669-11-git-send-email-acme@infradead.org>
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

Add struct ui_helpline in order to provide flexible implementation of
helpline APIs.  And convert existing TUI implementation to use it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1345104894-14205-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile          |    5 ++-
 tools/perf/ui/helpline.c     |   56 ++++++++++++++---------------------------
 tools/perf/ui/helpline.h     |   10 ++++++-
 tools/perf/ui/tui/helpline.c |   57 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 88 insertions(+), 40 deletions(-)
 create mode 100644 tools/perf/ui/tui/helpline.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e457afa..483fb69 100644
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
index 2f950c2..78ba28a 100644
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
+static void nop_helpline__pop(void)
 {
 }
 
-char ui_helpline__current[512];
+static void nop_helpline__push(const char *msg __used)
+{
+}
 
-void ui_helpline__push(const char *msg)
+static struct ui_helpline default_helpline_fns = {
+	.pop	= nop_helpline__pop,
+	.push	= nop_helpline__push,
+};
+
+struct ui_helpline *helpline_fns = &default_helpline_fns;
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
index 7bab6b3..61118b2 100644
--- a/tools/perf/ui/helpline.h
+++ b/tools/perf/ui/helpline.h
@@ -4,13 +4,21 @@
 #include <stdio.h>
 #include <stdarg.h>
 
+struct ui_helpline {
+	void (*pop)(void);
+	void (*push)(const char *msg);
+};
+
+extern struct ui_helpline *helpline_fns;
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
index 0000000..2884d2f
--- /dev/null
+++ b/tools/perf/ui/tui/helpline.c
@@ -0,0 +1,57 @@
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
+struct ui_helpline tui_helpline_fns = {
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
1.7.1

