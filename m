Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab0HJUR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:17:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:35967 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789Ab0HJUPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:15:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/9] perf ui: Move ui_helpline routines to separate file in util/ui/
Date: Tue, 10 Aug 2010 17:15:32 -0300
Message-Id: <1281471339-10878-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1281471339-10878-1-git-send-email-acme@infradead.org>
References: <1281471339-10878-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile           |    2 +
 tools/perf/util/newt.c        |   38 +-----------------------------------
 tools/perf/util/ui/helpline.c |   43 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/ui/helpline.h |    9 ++++++++
 4 files changed, 55 insertions(+), 37 deletions(-)
 create mode 100644 tools/perf/util/ui/helpline.c
 create mode 100644 tools/perf/util/ui/helpline.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d5bce76..d77a101 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -569,7 +569,9 @@ else
 		EXTLIBS += -lnewt -lslang
 		LIB_OBJS += $(OUTPUT)util/newt.o
 		LIB_OBJS += $(OUTPUT)util/ui/browser.o
+		LIB_OBJS += $(OUTPUT)util/ui/helpline.o
 		LIB_H += util/ui/browser.h
+		LIB_H += util/ui/helpline.h
 	endif
 endif
 
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 9768be3..23f3b7d 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -24,6 +24,7 @@
 #include "sort.h"
 #include "symbol.h"
 #include "ui/browser.h"
+#include "ui/helpline.h"
 
 #if SLANG_VERSION < 20104
 #define slsmg_printf(msg, args...) SLsmg_printf((char *)msg, ##args)
@@ -94,43 +95,6 @@ void ui_progress__delete(struct ui_progress *self)
 	free(self);
 }
 
-static void ui_helpline__pop(void)
-{
-	newtPopHelpLine();
-}
-
-static void ui_helpline__push(const char *msg)
-{
-	newtPushHelpLine(msg);
-}
-
-static void ui_helpline__vpush(const char *fmt, va_list ap)
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
-static void ui_helpline__fpush(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	ui_helpline__vpush(fmt, ap);
-	va_end(ap);
-}
-
-static void ui_helpline__puts(const char *msg)
-{
-	ui_helpline__pop();
-	ui_helpline__push(msg);
-}
-
 static int ui_entry__read(const char *title, char *bf, size_t size, int width)
 {
 	struct newtExitStruct es;
diff --git a/tools/perf/util/ui/helpline.c b/tools/perf/util/ui/helpline.c
new file mode 100644
index 0000000..6a11e13
--- /dev/null
+++ b/tools/perf/util/ui/helpline.c
@@ -0,0 +1,43 @@
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <newt.h>
+
+#include "helpline.h"
+
+void ui_helpline__pop(void)
+{
+	newtPopHelpLine();
+}
+
+void ui_helpline__push(const char *msg)
+{
+	newtPushHelpLine(msg);
+}
+
+static void ui_helpline__vpush(const char *fmt, va_list ap)
+{
+	char *s;
+
+	if (vasprintf(&s, fmt, ap) < 0)
+		vfprintf(stderr, fmt, ap);
+	else {
+		ui_helpline__push(s);
+		free(s);
+	}
+}
+
+void ui_helpline__fpush(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	ui_helpline__vpush(fmt, ap);
+	va_end(ap);
+}
+
+void ui_helpline__puts(const char *msg)
+{
+	ui_helpline__pop();
+	ui_helpline__push(msg);
+}
diff --git a/tools/perf/util/ui/helpline.h b/tools/perf/util/ui/helpline.h
new file mode 100644
index 0000000..56d8c1d
--- /dev/null
+++ b/tools/perf/util/ui/helpline.h
@@ -0,0 +1,9 @@
+#ifndef _PERF_UI_HELPLINE_H_
+#define _PERF_UI_HELPLINE_H_ 1
+
+void ui_helpline__pop(void);
+void ui_helpline__push(const char *msg);
+void ui_helpline__fpush(const char *fmt, ...);
+void ui_helpline__puts(const char *msg);
+
+#endif /* _PERF_UI_HELPLINE_H_ */
-- 
1.6.2.5

