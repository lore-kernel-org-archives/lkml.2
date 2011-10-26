Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816Ab1JZRst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:48:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37752 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933788Ab1JZRsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:48:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/11] perf ui: Improve handling sigwinch a bit
Date: Wed, 26 Oct 2011 15:48:26 -0200
Message-Id: <1319651314-29404-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319651314-29404-1-git-send-email-acme@infradead.org>
References: <1319651314-29404-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

No need to unblock it at each ui__getch() and also allow other users to
check if a resize is needed, or force an refresh of terminal dimensions.

The 'force' one shouldn't be needed, but its in a slow path, so leave it
like that for now, I'll revisit this another day.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-aujchu6yx3bfy64non1rky0w@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browser.c  |   49 +-------------------------
 tools/perf/util/ui/progress.c |    1 +
 tools/perf/util/ui/setup.c    |   75 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/ui/ui.h       |    3 ++
 tools/perf/util/ui/util.h     |    1 +
 5 files changed, 82 insertions(+), 47 deletions(-)

diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 5359f37..370c470 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -4,6 +4,7 @@
 #include "libslang.h"
 #include <newt.h>
 #include "ui.h"
+#include "util.h"
 #include <linux/compiler.h>
 #include <linux/list.h>
 #include <linux/rbtree.h>
@@ -291,53 +292,10 @@ void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries)
 	browser->seek(browser, browser->top_idx, SEEK_SET);
 }
 
-static int ui__getch(int delay_secs)
-{
-	struct timeval timeout, *ptimeout = delay_secs ? &timeout : NULL;
-	fd_set read_set;
-	int err, key;
-
-	FD_ZERO(&read_set);
-	FD_SET(0, &read_set);
-
-	if (delay_secs) {
-		timeout.tv_sec = delay_secs;
-		timeout.tv_usec = 0;
-	}
-
-        err = select(1, &read_set, NULL, NULL, ptimeout);
-
-	if (err == 0)
-		return K_TIMER;
-
-	if (err == -1) {
-		if (errno == EINTR)
-			return K_RESIZE;
-		return K_ERROR;
-	}
-
-	key = SLang_getkey();
-	if (key != K_ESC)
-		return key;
-
-	FD_ZERO(&read_set);
-	FD_SET(0, &read_set);
-	timeout.tv_sec = 0;
-	timeout.tv_usec = 20;
-        err = select(1, &read_set, NULL, NULL, &timeout);
-	if (err == 0)
-		return K_ESC;
-
-	SLang_ungetkey(key);
-	return SLkp_getkey();
-}
-
 int ui_browser__run(struct ui_browser *self, int delay_secs)
 {
 	int err, key;
 
-	pthread__unblock_sigwinch();
-
 	while (1) {
 		off_t offset;
 
@@ -351,10 +309,7 @@ int ui_browser__run(struct ui_browser *self, int delay_secs)
 		key = ui__getch(delay_secs);
 
 		if (key == K_RESIZE) {
-			pthread_mutex_lock(&ui__lock);
-			SLtt_get_screen_size();
-			SLsmg_reinit_smg();
-			pthread_mutex_unlock(&ui__lock);
+			ui__refresh_dimensions(false);
 			ui_browser__refresh_dimensions(self);
 			__ui_browser__show_title(self, self->title);
 			ui_helpline__puts(self->helpline);
diff --git a/tools/perf/util/ui/progress.c b/tools/perf/util/ui/progress.c
index 68d2c54..295e366 100644
--- a/tools/perf/util/ui/progress.c
+++ b/tools/perf/util/ui/progress.c
@@ -14,6 +14,7 @@ void ui_progress__update(u64 curr, u64 total, const char *title)
 	if (use_browser <= 0)
 		return;
 
+	ui__refresh_dimensions(true);
 	pthread_mutex_lock(&ui__lock);
 	y = SLtt_Screen_Rows / 2 - 2;
 	SLsmg_set_color(0);
diff --git a/tools/perf/util/ui/setup.c b/tools/perf/util/ui/setup.c
index 1e6ba06..c4e025f 100644
--- a/tools/perf/util/ui/setup.c
+++ b/tools/perf/util/ui/setup.c
@@ -7,10 +7,85 @@
 #include "browser.h"
 #include "helpline.h"
 #include "ui.h"
+#include "util.h"
 #include "libslang.h"
+#include "keysyms.h"
 
 pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
 
+static volatile int ui__need_resize;
+
+void ui__refresh_dimensions(bool force)
+{
+	if (force || ui__need_resize) {
+		ui__need_resize = 0;
+		pthread_mutex_lock(&ui__lock);
+		SLtt_get_screen_size();
+		SLsmg_reinit_smg();
+		pthread_mutex_unlock(&ui__lock);
+	}
+}
+
+static void ui__sigwinch(int sig __used)
+{
+	ui__need_resize = 1;
+}
+
+static void ui__setup_sigwinch(void)
+{
+	static bool done;
+
+	if (done)
+		return;
+
+	done = true;
+	pthread__unblock_sigwinch();
+	signal(SIGWINCH, ui__sigwinch);
+}
+
+int ui__getch(int delay_secs)
+{
+	struct timeval timeout, *ptimeout = delay_secs ? &timeout : NULL;
+	fd_set read_set;
+	int err, key;
+
+	ui__setup_sigwinch();
+
+	FD_ZERO(&read_set);
+	FD_SET(0, &read_set);
+
+	if (delay_secs) {
+		timeout.tv_sec = delay_secs;
+		timeout.tv_usec = 0;
+	}
+
+        err = select(1, &read_set, NULL, NULL, ptimeout);
+
+	if (err == 0)
+		return K_TIMER;
+
+	if (err == -1) {
+		if (errno == EINTR)
+			return K_RESIZE;
+		return K_ERROR;
+	}
+
+	key = SLang_getkey();
+	if (key != K_ESC)
+		return key;
+
+	FD_ZERO(&read_set);
+	FD_SET(0, &read_set);
+	timeout.tv_sec = 0;
+	timeout.tv_usec = 20;
+        err = select(1, &read_set, NULL, NULL, &timeout);
+	if (err == 0)
+		return K_ESC;
+
+	SLang_ungetkey(key);
+	return SLkp_getkey();
+}
+
 static void newt_suspend(void *d __used)
 {
 	newtSuspend();
diff --git a/tools/perf/util/ui/ui.h b/tools/perf/util/ui/ui.h
index d264e05..7b67045 100644
--- a/tools/perf/util/ui/ui.h
+++ b/tools/perf/util/ui/ui.h
@@ -2,7 +2,10 @@
 #define _PERF_UI_H_ 1
 
 #include <pthread.h>
+#include <stdbool.h>
 
 extern pthread_mutex_t ui__lock;
 
+void ui__refresh_dimensions(bool force);
+
 #endif /* _PERF_UI_H_ */
diff --git a/tools/perf/util/ui/util.h b/tools/perf/util/ui/util.h
index afcbc1d..e53c3d3 100644
--- a/tools/perf/util/ui/util.h
+++ b/tools/perf/util/ui/util.h
@@ -3,6 +3,7 @@
 
 #include <stdbool.h>
 
+int ui__getch(int delay_secs);
 int ui__popup_menu(int argc, char * const argv[]);
 int ui__help_window(const char *text);
 bool ui__dialog_yesno(const char *msg);
-- 
1.6.2.5

