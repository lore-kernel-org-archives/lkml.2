Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357Ab2D0IbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:31:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34215 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab2D0IbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:31:09 -0400
Date: Fri, 27 Apr 2012 01:30:46 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-nev4b97vdvv35we1qmooym52@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser: Rename disasm_line_rb_node
Git-Commit-ID: 887c0066a810234cfae9927b3781b6a1c617fb39
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:30:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  887c0066a810234cfae9927b3781b6a1c617fb39
Gitweb:     http://git.kernel.org/tip/887c0066a810234cfae9927b3781b6a1c617fb39
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 19 Apr 2012 10:29:53 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Apr 2012 10:29:53 -0300

perf annotate browser: Rename disasm_line_rb_node

Its not just an rb_node, it carries extra state that is private to the
browser. And will carry some more in the next patches.

Better name it browser_disasm_line, i.e. something derived from
disasm_line, that specializes it.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-nev4b97vdvv35we1qmooym52@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   76 ++++++++++++++++++------------------
 1 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index f7d2db3..58ebfd0 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -25,16 +25,16 @@ struct annotate_browser {
 	char		    search_bf[128];
 };
 
-struct disasm_line_rb_node {
+struct browser_disasm_line {
 	struct rb_node	rb_node;
 	double		percent;
 	u32		idx;
 	int		idx_asm;
 };
 
-static inline struct disasm_line_rb_node *disasm_line__rb(struct disasm_line *dl)
+static inline struct browser_disasm_line *disasm_line__browser(struct disasm_line *dl)
 {
-	return (struct disasm_line_rb_node *)(dl + 1);
+	return (struct browser_disasm_line *)(dl + 1);
 }
 
 static bool disasm_line__filter(struct ui_browser *browser, void *entry)
@@ -60,9 +60,9 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 	int width = self->width;
 
 	if (dl->offset != -1) {
-		struct disasm_line_rb_node *dlrb = disasm_line__rb(dl);
-		ui_browser__set_percent_color(self, dlrb->percent, current_entry);
-		slsmg_printf(" %7.2f ", dlrb->percent);
+		struct browser_disasm_line *bdl = disasm_line__browser(dl);
+		ui_browser__set_percent_color(self, bdl->percent, current_entry);
+		slsmg_printf(" %7.2f ", bdl->percent);
 	} else {
 		ui_browser__set_percent_color(self, 0, current_entry);
 		slsmg_write_nstring(" ", 9);
@@ -146,22 +146,22 @@ static double disasm_line__calc_percent(struct disasm_line *dl, struct symbol *s
 	return percent;
 }
 
-static void disasm_rb_tree__insert(struct rb_root *root, struct disasm_line_rb_node *dlrb)
+static void disasm_rb_tree__insert(struct rb_root *root, struct browser_disasm_line *bdl)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
-	struct disasm_line_rb_node *l;
+	struct browser_disasm_line *l;
 
 	while (*p != NULL) {
 		parent = *p;
-		l = rb_entry(parent, struct disasm_line_rb_node, rb_node);
-		if (dlrb->percent < l->percent)
+		l = rb_entry(parent, struct browser_disasm_line, rb_node);
+		if (bdl->percent < l->percent)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
 	}
-	rb_link_node(&dlrb->rb_node, parent, p);
-	rb_insert_color(&dlrb->rb_node, root);
+	rb_link_node(&bdl->rb_node, parent, p);
+	rb_insert_color(&bdl->rb_node, root);
 }
 
 static void annotate_browser__set_top(struct annotate_browser *self,
@@ -190,12 +190,12 @@ static void annotate_browser__set_top(struct annotate_browser *self,
 static void annotate_browser__set_rb_top(struct annotate_browser *browser,
 					 struct rb_node *nd)
 {
-	struct disasm_line_rb_node *rbpos;
+	struct browser_disasm_line *bpos;
 	struct disasm_line *pos;
 
-	rbpos = rb_entry(nd, struct disasm_line_rb_node, rb_node);
-	pos = ((struct disasm_line *)rbpos) - 1;
-	annotate_browser__set_top(browser, pos, rbpos->idx);
+	bpos = rb_entry(nd, struct browser_disasm_line, rb_node);
+	pos = ((struct disasm_line *)bpos) - 1;
+	annotate_browser__set_top(browser, pos, bpos->idx);
 	browser->curr_hot = nd;
 }
 
@@ -212,13 +212,13 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 	pthread_mutex_lock(&notes->lock);
 
 	list_for_each_entry(pos, &notes->src->source, node) {
-		struct disasm_line_rb_node *rbpos = disasm_line__rb(pos);
-		rbpos->percent = disasm_line__calc_percent(pos, sym, evidx);
-		if (rbpos->percent < 0.01) {
-			RB_CLEAR_NODE(&rbpos->rb_node);
+		struct browser_disasm_line *bpos = disasm_line__browser(pos);
+		bpos->percent = disasm_line__calc_percent(pos, sym, evidx);
+		if (bpos->percent < 0.01) {
+			RB_CLEAR_NODE(&bpos->rb_node);
 			continue;
 		}
-		disasm_rb_tree__insert(&browser->entries, rbpos);
+		disasm_rb_tree__insert(&browser->entries, bpos);
 	}
 	pthread_mutex_unlock(&notes->lock);
 
@@ -228,37 +228,37 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 static bool annotate_browser__toggle_source(struct annotate_browser *browser)
 {
 	struct disasm_line *dl;
-	struct disasm_line_rb_node *dlrb;
+	struct browser_disasm_line *bdl;
 	off_t offset = browser->b.index - browser->b.top_idx;
 
 	browser->b.seek(&browser->b, offset, SEEK_CUR);
 	dl = list_entry(browser->b.top, struct disasm_line, node);
-	dlrb = disasm_line__rb(dl);
+	bdl = disasm_line__browser(dl);
 
 	if (browser->hide_src_code) {
-		if (dlrb->idx_asm < offset)
-			offset = dlrb->idx;
+		if (bdl->idx_asm < offset)
+			offset = bdl->idx;
 
 		browser->b.nr_entries = browser->nr_entries;
 		browser->hide_src_code = false;
 		browser->b.seek(&browser->b, -offset, SEEK_CUR);
-		browser->b.top_idx = dlrb->idx - offset;
-		browser->b.index = dlrb->idx;
+		browser->b.top_idx = bdl->idx - offset;
+		browser->b.index = bdl->idx;
 	} else {
-		if (dlrb->idx_asm < 0) {
+		if (bdl->idx_asm < 0) {
 			ui_helpline__puts("Only available for assembly lines.");
 			browser->b.seek(&browser->b, -offset, SEEK_CUR);
 			return false;
 		}
 
-		if (dlrb->idx_asm < offset)
-			offset = dlrb->idx_asm;
+		if (bdl->idx_asm < offset)
+			offset = bdl->idx_asm;
 
 		browser->b.nr_entries = browser->nr_asm_entries;
 		browser->hide_src_code = true;
 		browser->b.seek(&browser->b, -offset, SEEK_CUR);
-		browser->b.top_idx = dlrb->idx_asm - offset;
-		browser->b.index = dlrb->idx_asm;
+		browser->b.top_idx = bdl->idx_asm - offset;
+		browser->b.index = bdl->idx_asm;
 	}
 
 	return true;
@@ -621,7 +621,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 	if (map->dso->annotate_warned)
 		return -1;
 
-	if (symbol__annotate(sym, map, sizeof(struct disasm_line_rb_node)) < 0) {
+	if (symbol__annotate(sym, map, sizeof(struct browser_disasm_line)) < 0) {
 		ui__error("%s", ui_helpline__last_msg);
 		return -1;
 	}
@@ -632,17 +632,17 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 	browser.start = map__rip_2objdump(map, sym->start);
 
 	list_for_each_entry(pos, &notes->src->source, node) {
-		struct disasm_line_rb_node *rbpos;
+		struct browser_disasm_line *bpos;
 		size_t line_len = strlen(pos->line);
 
 		if (browser.b.width < line_len)
 			browser.b.width = line_len;
-		rbpos = disasm_line__rb(pos);
-		rbpos->idx = browser.nr_entries++;
+		bpos = disasm_line__browser(pos);
+		bpos->idx = browser.nr_entries++;
 		if (pos->offset != -1)
-			rbpos->idx_asm = browser.nr_asm_entries++;
+			bpos->idx_asm = browser.nr_asm_entries++;
 		else
-			rbpos->idx_asm = -1;
+			bpos->idx_asm = -1;
 	}
 
 	browser.b.nr_entries = browser.nr_entries;
