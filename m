Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab2KIR3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:29:22 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52364 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab2KIR3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:29:16 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/13] perf annotate browser: Support event group view on TUI
Date: Sat, 10 Nov 2012 02:27:23 +0900
Message-Id: <1352482044-3443-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
References: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically allocate browser_disasm_line according to a number of
group members and save nr_pcnt to the struct.  This way we can
handle multiple events in a general manner.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/annotate.c |   69 ++++++++++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 12 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 7df1fa990ec2..0826f8954795 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -17,6 +17,7 @@ struct browser_disasm_line {
 	u32		idx;
 	int		idx_asm;
 	int		jump_sources;
+	int		nr_pcnt;
 	double		percent[1];
 };
 
@@ -95,14 +96,25 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 			     (!current_entry || (browser->use_navkeypressed &&
 					         !browser->navkeypressed)));
 	int width = browser->width, printed;
+	int i, pcnt_width = 7 * bdl->nr_pcnt;
+	double percent_max = 0.0;
 	char bf[256];
 
-	if (dl->offset != -1 && bdl->percent[0] != 0.0) {
-		ui_browser__set_percent_color(browser, bdl->percent[0], current_entry);
-		slsmg_printf("%6.2f ", bdl->percent[0]);
+	for (i = 0; i < bdl->nr_pcnt; i++) {
+		if (bdl->percent[i] > percent_max)
+			percent_max = bdl->percent[i];
+	}
+
+	if (dl->offset != -1 && percent_max != 0.0) {
+		for (i = 0; i < bdl->nr_pcnt; i++) {
+			ui_browser__set_percent_color(browser,
+						      bdl->percent[i],
+						      current_entry);
+			slsmg_printf("%6.2f ", bdl->percent[i]);
+		}
 	} else {
 		ui_browser__set_percent_color(browser, 0, current_entry);
-		slsmg_write_nstring(" ", 7);
+		slsmg_write_nstring(" ", pcnt_width);
 	}
 
 	SLsmg_write_char(' ');
@@ -112,14 +124,14 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 		width += 1;
 
 	if (!*dl->line)
-		slsmg_write_nstring(" ", width - 7);
+		slsmg_write_nstring(" ", width - pcnt_width);
 	else if (dl->offset == -1) {
 		printed = scnprintf(bf, sizeof(bf), "%*s  ",
 				    ab->addr_width, " ");
 		slsmg_write_nstring(bf, printed);
-		slsmg_write_nstring(dl->line, width - printed - 6);
+		slsmg_write_nstring(dl->line, width - printed - pcnt_width + 1);
 	} else if (!dl->name) {
-		slsmg_write_nstring(" ", width - 7);
+		slsmg_write_nstring(" ", width - pcnt_width);
 	} else {
 		u64 addr = dl->offset;
 		int color = -1;
@@ -178,7 +190,7 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 		}
 
 		disasm_line__scnprintf(dl, bf, sizeof(bf), !annotate_browser__opts.use_offset);
-		slsmg_write_nstring(bf, width - 10 - printed);
+		slsmg_write_nstring(bf, width - pcnt_width - 3 - printed);
 	}
 
 	if (current_entry)
@@ -193,6 +205,7 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 	unsigned int from, to;
 	struct map_symbol *ms = ab->b.priv;
 	struct symbol *sym = ms->sym;
+	u8 pcnt_width = 7;
 
 	/* PLT symbols contain external offsets */
 	if (strstr(sym->name, "@plt"))
@@ -217,22 +230,43 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 		to = (u64)btarget->idx;
 	}
 
+	pcnt_width *= bcursor->nr_pcnt;
+
 	ui_browser__set_color(browser, HE_COLORSET_CODE);
-	__ui_browser__line_arrow(browser, 9 + ab->addr_width, from, to);
+	__ui_browser__line_arrow(browser, pcnt_width + 2 + ab->addr_width,
+				 from, to);
 }
 
 static unsigned int annotate_browser__refresh(struct ui_browser *browser)
 {
+	struct annotate_browser *ab = container_of(browser, struct annotate_browser, b);
+	struct disasm_line *cursor = ab->offsets[0];
+	struct browser_disasm_line *bcursor = disasm_line__browser(cursor);
 	int ret = ui_browser__list_head_refresh(browser);
+	int pcnt_width = 7 * bcursor->nr_pcnt;
 
 	if (annotate_browser__opts.jump_arrows)
 		annotate_browser__draw_current_jump(browser);
 
 	ui_browser__set_color(browser, HE_COLORSET_NORMAL);
-	__ui_browser__vline(browser, 7, 0, browser->height - 1);
+	__ui_browser__vline(browser, pcnt_width, 0, browser->height - 1);
 	return ret;
 }
 
+static int disasm__cmp(struct browser_disasm_line *a,
+		       struct browser_disasm_line *b)
+{
+	int i;
+
+	for (i = 0; i < a->nr_pcnt; i++) {
+		if (a->percent[i] == b->percent[i])
+			continue;
+		return a->percent[i] < b->percent[i];
+	}
+
+	return 0;
+}
+
 static void disasm_rb_tree__insert(struct rb_root *root, struct browser_disasm_line *bdl)
 {
 	struct rb_node **p = &root->rb_node;
@@ -242,7 +276,8 @@ static void disasm_rb_tree__insert(struct rb_root *root, struct browser_disasm_l
 	while (*p != NULL) {
 		parent = *p;
 		l = rb_entry(parent, struct browser_disasm_line, rb_node);
-		if (bdl->percent[0] < l->percent[0])
+
+		if (disasm__cmp(bdl, l))
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -830,6 +865,8 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map,
 		},
 	};
 	int ret = -1;
+	int nr_pcnt = 1;
+	size_t sizeof_bdl = sizeof(struct browser_disasm_line);
 
 	if (sym == NULL)
 		return -1;
@@ -845,7 +882,14 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map,
 		return -1;
 	}
 
-	if (symbol__annotate(sym, map, sizeof(struct browser_disasm_line)) < 0) {
+	if (symbol_conf.event_group) {
+		if (perf_evsel__is_group_leader(evsel)) {
+			sizeof_bdl += sizeof(double) * evsel->nr_members;
+			nr_pcnt += evsel->nr_members;
+		}
+	}
+
+	if (symbol__annotate(sym, map, sizeof_bdl) < 0) {
 		ui__error("%s", ui_helpline__last_msg);
 		goto out_free_offsets;
 	}
@@ -862,6 +906,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map,
 		if (browser.b.width < line_len)
 			browser.b.width = line_len;
 		bpos = disasm_line__browser(pos);
+		bpos->nr_pcnt = nr_pcnt;
 		bpos->idx = browser.nr_entries++;
 		if (pos->offset != -1) {
 			bpos->idx_asm = browser.nr_asm_entries++;
-- 
1.7.9.2

