Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab2HUQVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:21:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60981 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab2HUQVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:21:18 -0400
Date: Tue, 21 Aug 2012 09:20:58 -0700
From: tip-bot for Namhyung Kim <namhyung@kernel.org>
Message-ID: <tip-e6e9046879493d8bf8f44ac1f2718c4a5628aa52@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1345104894-14205-1-git-send-email-namhyung@kernel.org>
References: <1345104894-14205-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui: Introduce struct ui_helpline
Git-Commit-ID: e6e9046879493d8bf8f44ac1f2718c4a5628aa52
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:21:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6e9046879493d8bf8f44ac1f2718c4a5628aa52
Gitweb:     http://git.kernel.org/tip/e6e9046879493d8bf8f44ac1f2718c4a5628aa52
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 16 Aug 2012 17:14:50 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 16 Aug 2012 14:17:01 -0300

perf ui: Introduce struct ui_helpline

Add struct ui_helpline in order to provide flexible implementation of
helpline APIs.  And convert existing TUI implementation to use it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1345104894-14205-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                |    5 ++-
 tools/perf/ui/helpline.c           |   56 ++++++++++++-----------------------
 tools/perf/ui/helpline.h           |   10 ++++++-
 tools/perf/ui/{ => tui}/helpline.c |   46 ++++++++----------------------
 4 files changed, 43 insertions(+), 74 deletions(-)

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
diff --git a/tools/perf/ui/helpline.c b/tools/perf/ui/tui/helpline.c
similarity index 59%
copy from tools/perf/ui/helpline.c
copy to tools/perf/ui/tui/helpline.c
index 2f950c2..2884d2f 100644
--- a/tools/perf/ui/helpline.c
+++ b/tools/perf/ui/tui/helpline.c
@@ -1,19 +1,18 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <pthread.h>
 
-#include "../debug.h"
-#include "helpline.h"
-#include "ui.h"
-#include "libslang.h"
+#include "../../util/debug.h"
+#include "../helpline.h"
+#include "../ui.h"
+#include "../libslang.h"
 
-void ui_helpline__pop(void)
+static void tui_helpline__pop(void)
 {
 }
 
-char ui_helpline__current[512];
-
-void ui_helpline__push(const char *msg)
+static void tui_helpline__push(const char *msg)
 {
 	const size_t sz = sizeof(ui_helpline__current);
 
@@ -24,35 +23,14 @@ void ui_helpline__push(const char *msg)
 	strncpy(ui_helpline__current, msg, sz)[sz - 1] = '\0';
 }
 
-void ui_helpline__vpush(const char *fmt, va_list ap)
-{
-	char *s;
-
-	if (vasprintf(&s, fmt, ap) < 0)
-		vfprintf(stderr, fmt, ap);
-	else {
-		ui_helpline__push(s);
-		free(s);
-	}
-}
-
-void ui_helpline__fpush(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	ui_helpline__vpush(fmt, ap);
-	va_end(ap);
-}
-
-void ui_helpline__puts(const char *msg)
-{
-	ui_helpline__pop();
-	ui_helpline__push(msg);
-}
+struct ui_helpline tui_helpline_fns = {
+	.pop	= tui_helpline__pop,
+	.push	= tui_helpline__push,
+};
 
 void ui_helpline__init(void)
 {
+	helpline_fns = &tui_helpline_fns;
 	ui_helpline__puts(" ");
 }
 
