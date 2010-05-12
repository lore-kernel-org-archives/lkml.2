Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab0ELC3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 22:29:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:33150 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab0ELC3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 22:29:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/2] perf ui: Add ui_helpline methods
Date: Tue, 11 May 2010 23:29:31 -0300
Message-Id: <1273631372-8206-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273631372-8206-1-git-send-email-acme@infradead.org>
References: <1273631372-8206-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Initially this was just to be able to have a printf like method to
prepare the formatted string and then pass to newtPushHelpLine, but as
we already have for ui_progress, etc, its a step in identifying a
restricted, highlevel set of widgets we can then have implementations
for multiple widget sets (GTK, etc).

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   69 ++++++++++++++++++++++++++++++++++-------------
 1 files changed, 50 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 638b519..daa86ef 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -57,6 +57,43 @@ void ui_progress__delete(struct ui_progress *self)
 	free(self);
 }
 
+static void ui_helpline__pop(void)
+{
+	newtPopHelpLine();
+}
+
+static void ui_helpline__push(const char *msg)
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
+static void ui_helpline__fpush(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	ui_helpline__vpush(fmt, ap);
+	va_end(ap);
+}
+
+static void ui_helpline__puts(const char *msg)
+{
+	ui_helpline__pop();
+	ui_helpline__push(msg);
+}
+
 static char browser__last_msg[1024];
 
 int browser__show_help(const char *format, va_list ap)
@@ -69,8 +106,7 @@ int browser__show_help(const char *format, va_list ap)
 	backlog += ret;
 
 	if (browser__last_msg[backlog - 1] == '\n') {
-		newtPopHelpLine();
-		newtPushHelpLine(browser__last_msg);
+		ui_helpline__puts(browser__last_msg);
 		newtRefresh();
 		backlog = 0;
 	}
@@ -340,7 +376,7 @@ static void map_symbol__annotate_browser(const struct map_symbol *self,
 	if (fp == NULL)
 		goto out_free_str;
 
-	newtPushHelpLine("Press ESC to exit");
+	ui_helpline__push("Press ESC to exit");
 	newtGetScreenSize(&cols, &rows);
 	tree = newtListbox(0, 0, rows - 5, NEWT_FLAG_SCROLL);
 
@@ -370,7 +406,7 @@ static void map_symbol__annotate_browser(const struct map_symbol *self,
 	newtFormRun(form, &es);
 	newtFormDestroy(form);
 	newtPopWindow();
-	newtPopHelpLine();
+	ui_helpline__pop();
 out_free_str:
 	free(str);
 }
@@ -539,7 +575,7 @@ int hists__browse(struct hists *self, const char *helpline, const char *input_na
 	if (browser == NULL)
 		return -1;
 
-	newtPushHelpLine(helpline);
+	ui_helpline__push(helpline);
 
 	hist_browser__title(msg, sizeof(msg), input_name,
 			    dso_filter, thread_filter);
@@ -602,8 +638,7 @@ int hists__browse(struct hists *self, const char *helpline, const char *input_na
 do_annotate:
 		if (choice == annotate) {
 			if (browser->selection->map->dso->origin == DSO__ORIG_KERNEL) {
-				newtPopHelpLine();
-				newtPushHelpLine("No vmlinux file found, can't "
+				ui_helpline__puts("No vmlinux file found, can't "
 						 "annotate with just a "
 						 "kallsyms file");
 				continue;
@@ -611,13 +646,11 @@ do_annotate:
 			map_symbol__annotate_browser(browser->selection, input_name);
 		} else if (choice == zoom_dso) {
 			if (dso_filter) {
-				newtPopHelpLine();
+				ui_helpline__pop();
 				dso_filter = NULL;
 			} else {
-				snprintf(msg, sizeof(msg),
-					 "To zoom out press -> + \"Zoom out of %s DSO\"",
-					 dso->kernel ? "the Kernel" : dso->short_name);
-				newtPushHelpLine(msg);
+				ui_helpline__fpush("To zoom out press -> + \"Zoom out of %s DSO\"",
+						   dso->kernel ? "the Kernel" : dso->short_name);
 				dso_filter = dso;
 			}
 			hists__filter_by_dso(self, dso_filter);
@@ -627,14 +660,12 @@ do_annotate:
 				goto out;
 		} else if (choice == zoom_thread) {
 			if (thread_filter) {
-				newtPopHelpLine();
+				ui_helpline__pop();
 				thread_filter = NULL;
 			} else {
-				snprintf(msg, sizeof(msg),
-					 "To zoom out press -> + \"Zoom out of %s(%d) thread\"",
-					 (thread->comm_set ? thread->comm : ""),
-					 thread->pid);
-				newtPushHelpLine(msg);
+				ui_helpline__fpush("To zoom out press -> + \"Zoom out of %s(%d) thread\"",
+						   thread->comm_set ? thread->comm : "",
+						   thread->pid);
 				thread_filter = thread;
 			}
 			hists__filter_by_thread(self, thread_filter);
@@ -658,7 +689,7 @@ void setup_browser(void)
 	use_browser = true;
 	newtInit();
 	newtCls();
-	newtPushHelpLine(" ");
+	ui_helpline__puts(" ");
 }
 
 void exit_browser(bool wait_for_ok)
-- 
1.6.2.5

