Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab1BPW4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:56:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:60603 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab1BPWy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:54:57 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/6] perf ui: Serialize screen updates
Date: Wed, 16 Feb 2011 20:54:42 -0200
Message-Id: <1297896887-9983-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297896887-9983-1-git-send-email-acme@infradead.org>
References: <1297896887-9983-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The ui operations so far were used by just one thread, but 'perf top
--tui' now has two threads updating the screen, so we need to use a
mutex to avoid garbling the screen.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile           |    1 +
 tools/perf/util/ui/browser.c  |    7 +++++++
 tools/perf/util/ui/helpline.c |    5 ++++-
 tools/perf/util/ui/setup.c    |    3 +++
 tools/perf/util/ui/ui.h       |    8 ++++++++
 5 files changed, 23 insertions(+), 1 deletions(-)
 create mode 100644 tools/perf/util/ui/ui.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index bc4d9bf..ffd1047 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -637,6 +637,7 @@ else
 		LIB_H += util/ui/libslang.h
 		LIB_H += util/ui/progress.h
 		LIB_H += util/ui/util.h
+		LIB_H += util/ui/ui.h
 	endif
 endif
 
diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 8bc010e..60d6c81 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -1,4 +1,5 @@
 #include "libslang.h"
+#include "ui.h"
 #include <linux/compiler.h>
 #include <linux/list.h>
 #include <linux/rbtree.h>
@@ -178,6 +179,7 @@ int ui_browser__show(struct ui_browser *self, const char *title,
 	if (self->sb == NULL)
 		return -1;
 
+	pthread_mutex_lock(&ui__lock);
 	SLsmg_gotorc(0, 0);
 	ui_browser__set_color(self, NEWT_COLORSET_ROOT);
 	slsmg_write_nstring(title, self->width);
@@ -188,25 +190,30 @@ int ui_browser__show(struct ui_browser *self, const char *title,
 	va_start(ap, helpline);
 	ui_helpline__vpush(helpline, ap);
 	va_end(ap);
+	pthread_mutex_unlock(&ui__lock);
 	return 0;
 }
 
 void ui_browser__hide(struct ui_browser *self)
 {
+	pthread_mutex_lock(&ui__lock);
 	newtFormDestroy(self->form);
 	self->form = NULL;
 	ui_helpline__pop();
+	pthread_mutex_unlock(&ui__lock);
 }
 
 int ui_browser__refresh(struct ui_browser *self)
 {
 	int row;
 
+	pthread_mutex_lock(&ui__lock);
 	newtScrollbarSet(self->sb, self->index, self->nr_entries - 1);
 	row = self->refresh(self);
 	ui_browser__set_color(self, HE_COLORSET_NORMAL);
 	SLsmg_fill_region(self->y + row, self->x,
 			  self->height - row, self->width, ' ');
+	pthread_mutex_unlock(&ui__lock);
 
 	return 0;
 }
diff --git a/tools/perf/util/ui/helpline.c b/tools/perf/util/ui/helpline.c
index 8d79daa..f36d2ff 100644
--- a/tools/perf/util/ui/helpline.c
+++ b/tools/perf/util/ui/helpline.c
@@ -5,6 +5,7 @@
 
 #include "../debug.h"
 #include "helpline.h"
+#include "ui.h"
 
 void ui_helpline__pop(void)
 {
@@ -55,7 +56,8 @@ int ui_helpline__show_help(const char *format, va_list ap)
 	int ret;
 	static int backlog;
 
-        ret = vsnprintf(ui_helpline__last_msg + backlog,
+	pthread_mutex_lock(&ui__lock);
+	ret = vsnprintf(ui_helpline__last_msg + backlog,
 			sizeof(ui_helpline__last_msg) - backlog, format, ap);
 	backlog += ret;
 
@@ -64,6 +66,7 @@ int ui_helpline__show_help(const char *format, va_list ap)
 		newtRefresh();
 		backlog = 0;
 	}
+	pthread_mutex_unlock(&ui__lock);
 
 	return ret;
 }
diff --git a/tools/perf/util/ui/setup.c b/tools/perf/util/ui/setup.c
index fbf1a14..ee46d67 100644
--- a/tools/perf/util/ui/setup.c
+++ b/tools/perf/util/ui/setup.c
@@ -6,6 +6,9 @@
 #include "../debug.h"
 #include "browser.h"
 #include "helpline.h"
+#include "ui.h"
+
+pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
 
 static void newt_suspend(void *d __used)
 {
diff --git a/tools/perf/util/ui/ui.h b/tools/perf/util/ui/ui.h
new file mode 100644
index 0000000..d264e05
--- /dev/null
+++ b/tools/perf/util/ui/ui.h
@@ -0,0 +1,8 @@
+#ifndef _PERF_UI_H_
+#define _PERF_UI_H_ 1
+
+#include <pthread.h>
+
+extern pthread_mutex_t ui__lock;
+
+#endif /* _PERF_UI_H_ */
-- 
1.6.2.5

