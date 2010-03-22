Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab0CVQLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:11:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56549 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab0CVQKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:10:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/5] perf newt: Properly restore the screen when error exiting
Date: Mon, 22 Mar 2010 13:10:25 -0300
Message-Id: <1269274229-20442-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Show an OK message box with the last message sent via pr_err, etc.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.c       |    4 ++--
 tools/perf/util/cache.h |    4 ++--
 tools/perf/util/newt.c  |   19 +++++++++++++------
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index d2de839..2826e70 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -264,11 +264,11 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 	set_debugfs_path();
 
 	status = p->fn(argc, argv, prefix);
+	exit_browser(status);
+
 	if (status)
 		return status & 0xff;
 
-	exit_browser();
-
 	/* Somebody closed stdout? */
 	if (fstat(fileno(stdout), &st))
 		return 0;
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 47b12a3..4b9aab7 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -77,10 +77,10 @@ static inline void setup_browser(void)
 {
 	setup_pager();
 }
-static inline void exit_browser(void) {}
+static inline void exit_browser(bool wait_for_ok __used) {}
 #else
 void setup_browser(void);
-void exit_browser(void);
+void exit_browser(bool wait_for_ok);
 #endif
 
 extern const char *editor_program;
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 2d19e7a..3c2ef95 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -170,18 +170,20 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 	newtFormDestroy(form);
 }
 
+static char browser__last_msg[1024];
+
 int browser__show_help(const char *format, va_list ap)
 {
 	int ret;
 	static int backlog;
-	static char msg[1024];
 
-        ret = vsnprintf(msg + backlog, sizeof(msg) - backlog, format, ap);
+        ret = vsnprintf(browser__last_msg + backlog,
+			sizeof(browser__last_msg) - backlog, format, ap);
 	backlog += ret;
 
-	if (msg[backlog - 1] == '\n') {
+	if (browser__last_msg[backlog - 1] == '\n') {
 		newtPopHelpLine();
-		newtPushHelpLine(msg);
+		newtPushHelpLine(browser__last_msg);
 		newtRefresh();
 		backlog = 0;
 	}
@@ -200,8 +202,13 @@ void setup_browser(void)
 	newtPushHelpLine(" ");
 }
 
-void exit_browser(void)
+void exit_browser(bool wait_for_ok)
 {
-	if (use_browser)
+	if (use_browser) {
+		if (wait_for_ok) {
+			char title[] = "Fatal Error", ok[] = "Ok";
+			newtWinMessage(title, ok, browser__last_msg);
+		}
 		newtFinished();
+	}
 }
-- 
1.6.2.5

