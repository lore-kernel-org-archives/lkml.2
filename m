Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab2E3HwC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:52:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35413 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184Ab2E3Hv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:51:59 -0400
Date: Wed, 30 May 2012 00:51:34 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-0h0tah1zj59p01581snjufne@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf annotate browser:
  Make feature toggles global
Git-Commit-ID: e9823b21bab7ff0c39e14a7a970a40fad74ce778
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 00:51:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9823b21bab7ff0c39e14a7a970a40fad74ce778
Gitweb:     http://git.kernel.org/tip/e9823b21bab7ff0c39e14a7a970a40fad74ce778
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 29 May 2012 21:24:05 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 29 May 2012 21:24:05 -0300

perf annotate browser: Make feature toggles global

So that when navigating to another function from a call site or when
going to another annotation browser thru the main report/top browser the
options (hide source code, jump arrows, jumpy lines, etc) remains the
last ones selected.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-0h0tah1zj59p01581snjufne@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |  101 ++++++++++++++++++++++++-------------
 1 files changed, 66 insertions(+), 35 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index aaf36ce..02afa03 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -19,6 +19,16 @@ struct browser_disasm_line {
 	int		jump_sources;
 };
 
+static struct annotate_browser_opt {
+	bool hide_src_code,
+	     use_offset,
+	     jump_arrows,
+	     show_nr_jumps;
+} annotate_browser__opts = {
+	.use_offset	= true,
+	.jump_arrows	= true,
+};
+
 struct annotate_browser {
 	struct ui_browser b;
 	struct rb_root	  entries;
@@ -30,10 +40,6 @@ struct annotate_browser {
 	int		    nr_entries;
 	int		    max_jump_sources;
 	int		    nr_jumps;
-	bool		    hide_src_code;
-	bool		    use_offset;
-	bool		    jump_arrows;
-	bool		    show_nr_jumps;
 	bool		    searching_backwards;
 	u8		    addr_width;
 	u8		    jumps_width;
@@ -48,11 +54,9 @@ static inline struct browser_disasm_line *disasm_line__browser(struct disasm_lin
 	return (struct browser_disasm_line *)(dl + 1);
 }
 
-static bool disasm_line__filter(struct ui_browser *browser, void *entry)
+static bool disasm_line__filter(struct ui_browser *browser __used, void *entry)
 {
-	struct annotate_browser *ab = container_of(browser, struct annotate_browser, b);
-
-	if (ab->hide_src_code) {
+	if (annotate_browser__opts.hide_src_code) {
 		struct disasm_line *dl = list_entry(entry, struct disasm_line, node);
 		return dl->offset == -1;
 	}
@@ -85,7 +89,7 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 	struct disasm_line *dl = list_entry(entry, struct disasm_line, node);
 	struct browser_disasm_line *bdl = disasm_line__browser(dl);
 	bool current_entry = ui_browser__is_current_entry(self, row);
-	bool change_color = (!ab->hide_src_code &&
+	bool change_color = (!annotate_browser__opts.hide_src_code &&
 			     (!current_entry || (self->use_navkeypressed &&
 					         !self->navkeypressed)));
 	int width = self->width, printed;
@@ -116,14 +120,14 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		u64 addr = dl->offset;
 		int color = -1;
 
-		if (!ab->use_offset)
+		if (!annotate_browser__opts.use_offset)
 			addr += ab->start;
 
-		if (!ab->use_offset) {
+		if (!annotate_browser__opts.use_offset) {
 			printed = scnprintf(bf, sizeof(bf), "%" PRIx64 ": ", addr);
 		} else {
 			if (bdl->jump_sources) {
-				if (ab->show_nr_jumps) {
+				if (annotate_browser__opts.show_nr_jumps) {
 					int prev;
 					printed = scnprintf(bf, sizeof(bf), "%*d ",
 							    ab->jumps_width,
@@ -169,7 +173,7 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 			}
 		}
 
-		disasm_line__scnprintf(dl, bf, sizeof(bf), !ab->use_offset);
+		disasm_line__scnprintf(dl, bf, sizeof(bf), !annotate_browser__opts.use_offset);
 		slsmg_write_nstring(bf, width - 10 - printed);
 	}
 
@@ -184,7 +188,7 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 	struct browser_disasm_line *btarget, *bcursor;
 	unsigned int from, to;
 
-	if (!cursor->ins || !ins__is_jump(cursor->ins) ||
+	if (!cursor || !cursor->ins || !ins__is_jump(cursor->ins) ||
 	    !disasm_line__has_offset(cursor))
 		return;
 
@@ -195,7 +199,7 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 	bcursor = disasm_line__browser(cursor);
 	btarget = disasm_line__browser(target);
 
-	if (ab->hide_src_code) {
+	if (annotate_browser__opts.hide_src_code) {
 		from = bcursor->idx_asm;
 		to = btarget->idx_asm;
 	} else {
@@ -209,10 +213,9 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 
 static unsigned int annotate_browser__refresh(struct ui_browser *browser)
 {
-	struct annotate_browser *ab = container_of(browser, struct annotate_browser, b);
 	int ret = ui_browser__list_head_refresh(browser);
 
-	if (ab->jump_arrows)
+	if (annotate_browser__opts.jump_arrows)
 		annotate_browser__draw_current_jump(browser);
 
 	ui_browser__set_color(browser, HE_COLORSET_NORMAL);
@@ -305,7 +308,7 @@ static void annotate_browser__set_rb_top(struct annotate_browser *browser,
 	bpos = rb_entry(nd, struct browser_disasm_line, rb_node);
 	pos = ((struct disasm_line *)bpos) - 1;
 	idx = bpos->idx;
-	if (browser->hide_src_code)
+	if (annotate_browser__opts.hide_src_code)
 		idx = bpos->idx_asm;
 	annotate_browser__set_top(browser, pos, idx);
 	browser->curr_hot = nd;
@@ -347,12 +350,12 @@ static bool annotate_browser__toggle_source(struct annotate_browser *browser)
 	dl = list_entry(browser->b.top, struct disasm_line, node);
 	bdl = disasm_line__browser(dl);
 
-	if (browser->hide_src_code) {
+	if (annotate_browser__opts.hide_src_code) {
 		if (bdl->idx_asm < offset)
 			offset = bdl->idx;
 
 		browser->b.nr_entries = browser->nr_entries;
-		browser->hide_src_code = false;
+		annotate_browser__opts.hide_src_code = false;
 		browser->b.seek(&browser->b, -offset, SEEK_CUR);
 		browser->b.top_idx = bdl->idx - offset;
 		browser->b.index = bdl->idx;
@@ -367,7 +370,7 @@ static bool annotate_browser__toggle_source(struct annotate_browser *browser)
 			offset = bdl->idx_asm;
 
 		browser->b.nr_entries = browser->nr_asm_entries;
-		browser->hide_src_code = true;
+		annotate_browser__opts.hide_src_code = true;
 		browser->b.seek(&browser->b, -offset, SEEK_CUR);
 		browser->b.top_idx = bdl->idx_asm - offset;
 		browser->b.index = bdl->idx_asm;
@@ -376,6 +379,12 @@ static bool annotate_browser__toggle_source(struct annotate_browser *browser)
 	return true;
 }
 
+static void annotate_browser__init_asm_mode(struct annotate_browser *browser)
+{
+	ui_browser__reset_index(&browser->b);
+	browser->b.nr_entries = browser->nr_asm_entries;
+}
+
 static bool annotate_browser__callq(struct annotate_browser *browser,
 				    int evidx, void (*timer)(void *arg),
 				    void *arg, int delay_secs)
@@ -578,6 +587,19 @@ bool annotate_browser__continue_search_reverse(struct annotate_browser *browser,
 	return __annotate_browser__search_reverse(browser);
 }
 
+static void annotate_browser__update_addr_width(struct annotate_browser *browser)
+{
+	if (annotate_browser__opts.use_offset)
+		browser->target_width = browser->min_addr_width;
+	else
+		browser->target_width = browser->max_addr_width;
+
+	browser->addr_width = browser->target_width;
+
+	if (annotate_browser__opts.show_nr_jumps)
+		browser->addr_width += browser->jumps_width + 1;
+}
+
 static int annotate_browser__run(struct annotate_browser *self, int evidx,
 				 void(*timer)(void *arg),
 				 void *arg, int delay_secs)
@@ -663,22 +685,16 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 				ui_helpline__puts(help);
 			continue;
 		case 'o':
-			self->use_offset = !self->use_offset;
-			if (self->use_offset)
-				self->target_width = self->min_addr_width;
-			else
-				self->target_width = self->max_addr_width;
-update_addr_width:
-			self->addr_width = self->target_width;
-			if (self->show_nr_jumps)
-				self->addr_width += self->jumps_width + 1;
+			annotate_browser__opts.use_offset = !annotate_browser__opts.use_offset;
+			annotate_browser__update_addr_width(self);
 			continue;
 		case 'j':
-			self->jump_arrows = !self->jump_arrows;
+			annotate_browser__opts.jump_arrows = !annotate_browser__opts.jump_arrows;
 			continue;
 		case 'J':
-			self->show_nr_jumps = !self->show_nr_jumps;
-			goto update_addr_width;
+			annotate_browser__opts.show_nr_jumps = !annotate_browser__opts.show_nr_jumps;
+			annotate_browser__update_addr_width(self);
+			continue;
 		case '/':
 			if (annotate_browser__search(self, delay_secs)) {
 show_help:
@@ -695,6 +711,17 @@ show_help:
 			if (annotate_browser__search_reverse(self, delay_secs))
 				goto show_help;
 			continue;
+		case 'D': {
+			static int seq;
+			ui_helpline__pop();
+			ui_helpline__fpush("%d: nr_ent=%d, height=%d, idx=%d, top_idx=%d, nr_asm_entries=%d",
+					   seq++, self->b.nr_entries,
+					   self->b.height,
+					   self->b.index,
+					   self->b.top_idx,
+					   self->nr_asm_entries);
+		}
+			continue;
 		case K_ENTER:
 		case K_RIGHT:
 			if (self->selection == NULL)
@@ -801,8 +828,6 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 			.priv	 = &ms,
 			.use_navkeypressed = true,
 		},
-		.use_offset = true,
-		.jump_arrows = true,
 	};
 	int ret = -1;
 
@@ -859,6 +884,12 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 	browser.b.nr_entries = browser.nr_entries;
 	browser.b.entries = &notes->src->source,
 	browser.b.width += 18; /* Percentage */
+
+	if (annotate_browser__opts.hide_src_code)
+		annotate_browser__init_asm_mode(&browser);
+
+	annotate_browser__update_addr_width(&browser);
+
 	ret = annotate_browser__run(&browser, evidx, timer, arg, delay_secs);
 	list_for_each_entry_safe(pos, n, &notes->src->source, node) {
 		list_del(&pos->node);
