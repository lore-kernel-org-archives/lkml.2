Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab0HJVyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 17:54:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:39636 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933234Ab0HJVyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:54:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/4] perf annotate: Cycle thru sorted lines with samples
Date: Tue, 10 Aug 2010 18:53:44 -0300
Message-Id: <1281477226-11504-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1281477226-11504-1-git-send-email-acme@infradead.org>
References: <1281477226-11504-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The annotate TUI now starts centered on the line with most samples, i.e.
the hottest line in the annotated function. Pressing TAB will center on
the second hottest function and so on. Shift+TAB goes in the other
direction.

This way one can more easily sift thru the function hotspots.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/annotate.c |  102 ++++++++++++++++++++++++--------
 1 files changed, 77 insertions(+), 25 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index d2156ae..73e78ef 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -17,6 +17,7 @@ static void ui__error_window(const char *fmt, ...)
 struct annotate_browser {
 	struct ui_browser b;
 	struct rb_root	  entries;
+	struct rb_node	  *curr_hot;
 };
 
 struct objdump_line_rb_node {
@@ -110,12 +111,83 @@ static void objdump__insert_line(struct rb_root *self,
 	rb_insert_color(&line->rb_node, self);
 }
 
+static void annotate_browser__set_top(struct annotate_browser *self,
+				      struct rb_node *nd)
+{
+	struct objdump_line_rb_node *rbpos;
+	struct objdump_line *pos;
+	unsigned back;
+
+	ui_browser__refresh_dimensions(&self->b);
+	back = self->b.height / 2;
+	rbpos = rb_entry(nd, struct objdump_line_rb_node, rb_node);
+	pos = ((struct objdump_line *)rbpos) - 1;
+	self->b.top_idx = self->b.index = rbpos->idx;
+
+	while (self->b.top_idx != 0 && back != 0) {
+		pos = list_entry(pos->node.prev, struct objdump_line, node);
+
+		--self->b.top_idx;
+		--back;
+	}
+
+	self->b.top = pos;
+	self->curr_hot = nd;
+}
+
+static int annotate_browser__run(struct annotate_browser *self,
+				 struct newtExitStruct *es)
+{
+	struct rb_node *nd;
+	struct hist_entry *he = self->b.priv;
+
+	if (ui_browser__show(&self->b, he->ms.sym->name) < 0)
+		return -1;
+
+	ui_helpline__fpush("<- or ESC: exit, TAB/shift+TAB: cycle thru samples");
+	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
+
+	nd = self->curr_hot;
+	if (nd) {
+		newtFormAddHotKey(self->b.form, NEWT_KEY_TAB);
+		newtFormAddHotKey(self->b.form, NEWT_KEY_UNTAB);
+	}
+
+	while (1) {
+		ui_browser__run(&self->b, es);
+
+		if (es->reason != NEWT_EXIT_HOTKEY)
+			break;
+
+		switch (es->u.key) {
+		case NEWT_KEY_TAB:
+			nd = rb_prev(nd);
+			if (nd == NULL)
+				nd = rb_last(&self->entries);
+			annotate_browser__set_top(self, nd);
+			break;
+		case NEWT_KEY_UNTAB:
+			nd = rb_next(nd);
+			if (nd == NULL)
+				nd = rb_first(&self->entries);
+			annotate_browser__set_top(self, nd);
+			break;
+		default:
+			goto out;
+		}
+	}
+out:
+	newtFormDestroy(self->b.form);
+	newtPopWindow();
+	ui_helpline__pop();
+	return 0;
+}
+
 int hist_entry__tui_annotate(struct hist_entry *self)
 {
 	struct newtExitStruct es;
 	struct objdump_line *pos, *n;
 	struct objdump_line_rb_node *rbpos;
-	struct rb_node *nd;
 	LIST_HEAD(head);
 	struct annotate_browser browser = {
 		.b = {
@@ -156,35 +228,15 @@ int hist_entry__tui_annotate(struct hist_entry *self)
 	/*
 	 * Position the browser at the hottest line.
 	 */
-	nd = rb_last(&browser.entries);
-	if (nd != NULL) {
-		unsigned back;
-
-		ui_browser__refresh_dimensions(&browser.b);
-		back = browser.b.height / 2;
-		rbpos = rb_entry(nd, struct objdump_line_rb_node, rb_node);
-		pos = ((struct objdump_line *)rbpos) - 1;
-		browser.b.top_idx = browser.b.index = rbpos->idx;
-
-		while (browser.b.top_idx != 0 && back != 0) {
-			pos = list_entry(pos->node.prev, struct objdump_line, node);
-
-			--browser.b.top_idx;
-			--back;
-		}
-
-		browser.b.top = pos;
-	}
+	browser.curr_hot = rb_last(&browser.entries);
+	if (browser.curr_hot)
+		annotate_browser__set_top(&browser, browser.curr_hot);
 
 	browser.b.width += 18; /* Percentage */
-	ui_browser__show(&browser.b, self->ms.sym->name);
-	ret = ui_browser__run(&browser.b, &es);
-	newtFormDestroy(browser.b.form);
-	newtPopWindow();
+	ret = annotate_browser__run(&browser, &es);
 	list_for_each_entry_safe(pos, n, &head, node) {
 		list_del(&pos->node);
 		objdump_line__free(pos);
 	}
-	ui_helpline__pop();
 	return ret;
 }
-- 
1.6.2.5

