Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab0HYXi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:38:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46449 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab0HYXhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:37:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/6] perf hists browser: Introduce "expand/collapse all callchains" action
Date: Wed, 25 Aug 2010 20:36:53 -0300
Message-Id: <1282779415-8544-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1282779415-8544-1-git-send-email-acme@infradead.org>
References: <1282779415-8544-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When looking at a callchains enabled perf data file one can find it
tiresome to start with all callchains collapsed and then to have to go
one by one expanding them.

So associate 'E' with "Expand all callchains" and 'C' with "Collapse all
callchains".

This way now one can have the top level view and then switch to/from
having all callchains expanded.

More work is needed to allow expanding just from one branch down to its
leaves.

Reported-by: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |  112 +++++++++++++++++++++++++++++++++--
 1 files changed, 106 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index c17611f..2fc1ba3 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -58,6 +58,11 @@ static char callchain_list__folded(const struct callchain_list *self)
 	return map_symbol__folded(&self->ms);
 }
 
+static void map_symbol__set_folding(struct map_symbol *self, bool unfold)
+{
+	self->unfolded = unfold ? self->has_children : false;
+}
+
 static int callchain_node__count_rows_rb_tree(struct callchain_node *self)
 {
 	int n = 0;
@@ -196,11 +201,98 @@ static bool hist_browser__toggle_fold(struct hist_browser *self)
 	return false;
 }
 
+static int callchain_node__set_folding_rb_tree(struct callchain_node *self, bool unfold)
+{
+	int n = 0;
+	struct rb_node *nd;
+
+	for (nd = rb_first(&self->rb_root); nd; nd = rb_next(nd)) {
+		struct callchain_node *child = rb_entry(nd, struct callchain_node, rb_node);
+		struct callchain_list *chain;
+		bool has_children = false;
+
+		list_for_each_entry(chain, &child->val, list) {
+			++n;
+			map_symbol__set_folding(&chain->ms, unfold);
+			has_children = chain->ms.has_children;
+		}
+
+		if (has_children)
+			n += callchain_node__set_folding_rb_tree(child, unfold);
+	}
+
+	return n;
+}
+
+static int callchain_node__set_folding(struct callchain_node *node, bool unfold)
+{
+	struct callchain_list *chain;
+	bool has_children = false;
+	int n = 0;
+
+	list_for_each_entry(chain, &node->val, list) {
+		++n;
+		map_symbol__set_folding(&chain->ms, unfold);
+		has_children = chain->ms.has_children;
+	}
+
+	if (has_children)
+		n += callchain_node__set_folding_rb_tree(node, unfold);
+
+	return n;
+}
+
+static int callchain__set_folding(struct rb_root *chain, bool unfold)
+{
+	struct rb_node *nd;
+	int n = 0;
+
+	for (nd = rb_first(chain); nd; nd = rb_next(nd)) {
+		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
+		n += callchain_node__set_folding(node, unfold);
+	}
+
+	return n;
+}
+
+static void hist_entry__set_folding(struct hist_entry *self, bool unfold)
+{
+	hist_entry__init_have_children(self);
+	map_symbol__set_folding(&self->ms, unfold);
+
+	if (self->ms.has_children) {
+		int n = callchain__set_folding(&self->sorted_chain, unfold);
+		self->nr_rows = unfold ? n : 0;
+	} else
+		self->nr_rows = 0;
+}
+
+static void hists__set_folding(struct hists *self, bool unfold)
+{
+	struct rb_node *nd;
+
+	self->nr_entries = 0;
+
+	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
+		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
+		hist_entry__set_folding(he, unfold);
+		self->nr_entries += 1 + he->nr_rows;
+	}
+}
+
+static void hist_browser__set_folding(struct hist_browser *self, bool unfold)
+{
+	hists__set_folding(self->hists, unfold);
+	self->b.nr_entries = self->hists->nr_entries;
+	/* Go to the start, we may be way after valid entries after a collapse */
+	ui_browser__reset_index(&self->b);
+}
+
 static int hist_browser__run(struct hist_browser *self, const char *title)
 {
 	int key;
-	int exit_keys[] = { 'a', '?', 'h', 'd', 'D', 't', NEWT_KEY_ENTER,
-			    NEWT_KEY_RIGHT, NEWT_KEY_LEFT, 0, };
+	int exit_keys[] = { 'a', '?', 'h', 'C', 'd', 'D', 'E', 't',
+			    NEWT_KEY_ENTER, NEWT_KEY_RIGHT, NEWT_KEY_LEFT, 0, };
 	char str[256], unit;
 	unsigned long nr_events = self->hists->stats.nr_events[PERF_RECORD_SAMPLE];
 
@@ -237,7 +329,15 @@ static int hist_browser__run(struct hist_browser *self, const char *title)
 					   self->b.top_idx,
 					   h->row_offset, h->nr_rows);
 		}
-			continue;
+			break;
+		case 'C':
+			/* Collapse the whole world. */
+			hist_browser__set_folding(self, false);
+			break;
+		case 'E':
+			/* Expand the whole world. */
+			hist_browser__set_folding(self, true);
+			break;
 		case NEWT_KEY_ENTER:
 			if (hist_browser__toggle_fold(self))
 				break;
@@ -734,8 +834,6 @@ int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
 		dso = browser->selection->map ? browser->selection->map->dso : NULL;
 
 		switch (key) {
-		case NEWT_KEY_F1:
-			goto do_help;
 		case NEWT_KEY_TAB:
 		case NEWT_KEY_UNTAB:
 			/*
@@ -752,13 +850,15 @@ int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
 			goto zoom_dso;
 		case 't':
 			goto zoom_thread;
+		case NEWT_KEY_F1:
 		case 'h':
 		case '?':
-do_help:
 			ui__help_window("->        Zoom into DSO/Threads & Annotate current symbol\n"
 					"<-        Zoom out\n"
 					"a         Annotate current symbol\n"
 					"h/?/F1    Show this window\n"
+					"C         Collapse all callchains\n"
+					"E         Expand all callchains\n"
 					"d         Zoom into current DSO\n"
 					"t         Zoom into current Thread\n"
 					"q/CTRL+C  Exit browser");
-- 
1.6.2.5

