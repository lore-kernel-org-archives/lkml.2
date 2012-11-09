Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab2KIRav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:30:51 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49098 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab2KIR2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:28:54 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 05/13] perf annotate: Pass evsel instead of evidx on annotation functions
Date: Sat, 10 Nov 2012 02:27:16 +0900
Message-Id: <1352482044-3443-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
References: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Pass evsel instead of evidx.  This is a preparation for supporting
event group view in annotation and no functional change is intended.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c     |   14 ++++++++------
 tools/perf/builtin-top.c          |    2 +-
 tools/perf/ui/browsers/annotate.c |   30 +++++++++++++++++-------------
 tools/perf/ui/browsers/hists.c    |    2 +-
 tools/perf/util/annotate.c        |   33 ++++++++++++++++++---------------
 tools/perf/util/annotate.h        |   17 +++++++++--------
 tools/perf/util/hist.h            |    5 +++--
 7 files changed, 57 insertions(+), 46 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index dc870cf31b79..0c6edd60d67e 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -108,14 +108,16 @@ static int process_sample_event(struct perf_tool *tool,
 	return 0;
 }
 
-static int hist_entry__tty_annotate(struct hist_entry *he, int evidx,
+static int hist_entry__tty_annotate(struct hist_entry *he,
+				    struct perf_evsel *evsel,
 				    struct perf_annotate *ann)
 {
-	return symbol__tty_annotate(he->ms.sym, he->ms.map, evidx,
+	return symbol__tty_annotate(he->ms.sym, he->ms.map, evsel,
 				    ann->print_line, ann->full_paths, 0, 0);
 }
 
-static void hists__find_annotations(struct hists *self, int evidx,
+static void hists__find_annotations(struct hists *self,
+				    struct perf_evsel *evsel,
 				    struct perf_annotate *ann)
 {
 	struct rb_node *nd = rb_first(&self->entries), *next;
@@ -139,7 +141,7 @@ find_next:
 		}
 
 		if (use_browser > 0) {
-			key = hist_entry__tui_annotate(he, evidx, NULL);
+			key = hist_entry__tui_annotate(he, evsel, NULL);
 			switch (key) {
 			case K_RIGHT:
 				next = rb_next(nd);
@@ -154,7 +156,7 @@ find_next:
 			if (next != NULL)
 				nd = next;
 		} else {
-			hist_entry__tty_annotate(he, evidx, ann);
+			hist_entry__tty_annotate(he, evsel, ann);
 			nd = rb_next(nd);
 			/*
 			 * Since we have a hist_entry per IP for the same
@@ -216,7 +218,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 			total_nr_samples += nr_samples;
 			hists__collapse_resort(hists);
 			hists__output_resort(hists);
-			hists__find_annotations(hists, pos->idx, ann);
+			hists__find_annotations(hists, pos, ann);
 		}
 	}
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c9ff3950cd4b..16d5ef1bd1b9 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -251,7 +251,7 @@ static void perf_top__show_details(struct perf_top *top)
 	printf("Showing %s for %s\n", perf_evsel__name(top->sym_evsel), symbol->name);
 	printf("  Events  Pcnt (>=%d%%)\n", top->sym_pcnt_filter);
 
-	more = symbol__annotate_printf(symbol, he->ms.map, top->sym_evsel->idx,
+	more = symbol__annotate_printf(symbol, he->ms.map, top->sym_evsel,
 				       0, top->sym_pcnt_filter, top->print_entries, 4);
 	if (top->zero)
 		symbol__annotate_zero_histogram(symbol, top->sym_evsel->idx);
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index bb393dd26ba2..ad943164ece9 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -8,6 +8,7 @@
 #include "../../util/hist.h"
 #include "../../util/sort.h"
 #include "../../util/symbol.h"
+#include "../../util/evsel.h"
 #include <pthread.h>
 #include <newt.h>
 
@@ -324,7 +325,7 @@ static void annotate_browser__set_rb_top(struct annotate_browser *browser,
 }
 
 static void annotate_browser__calc_percent(struct annotate_browser *browser,
-					   int evidx)
+					   struct perf_evsel *evsel)
 {
 	struct map_symbol *ms = browser->b.priv;
 	struct symbol *sym = ms->sym;
@@ -337,7 +338,7 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 
 	list_for_each_entry(pos, &notes->src->source, node) {
 		struct browser_disasm_line *bpos = disasm_line__browser(pos);
-		bpos->percent = disasm_line__calc_percent(pos, sym, evidx);
+		bpos->percent = disasm_line__calc_percent(pos, sym, evsel->idx);
 		if (bpos->percent < 0.01) {
 			RB_CLEAR_NODE(&bpos->rb_node);
 			continue;
@@ -394,7 +395,8 @@ static void annotate_browser__init_asm_mode(struct annotate_browser *browser)
 	browser->b.nr_entries = browser->nr_asm_entries;
 }
 
-static bool annotate_browser__callq(struct annotate_browser *browser, int evidx,
+static bool annotate_browser__callq(struct annotate_browser *browser,
+				    struct perf_evsel *evsel,
 				    struct hist_browser_timer *hbt)
 {
 	struct map_symbol *ms = browser->b.priv;
@@ -425,7 +427,7 @@ static bool annotate_browser__callq(struct annotate_browser *browser, int evidx,
 	}
 
 	pthread_mutex_unlock(&notes->lock);
-	symbol__tui_annotate(target, ms->map, evidx, hbt);
+	symbol__tui_annotate(target, ms->map, evsel, hbt);
 	ui_browser__show_title(&browser->b, sym->name);
 	return true;
 }
@@ -608,7 +610,8 @@ static void annotate_browser__update_addr_width(struct annotate_browser *browser
 		browser->addr_width += browser->jumps_width + 1;
 }
 
-static int annotate_browser__run(struct annotate_browser *browser, int evidx,
+static int annotate_browser__run(struct annotate_browser *browser,
+				 struct perf_evsel *evsel,
 				 struct hist_browser_timer *hbt)
 {
 	struct rb_node *nd = NULL;
@@ -621,7 +624,7 @@ static int annotate_browser__run(struct annotate_browser *browser, int evidx,
 	if (ui_browser__show(&browser->b, sym->name, help) < 0)
 		return -1;
 
-	annotate_browser__calc_percent(browser, evidx);
+	annotate_browser__calc_percent(browser, evsel);
 
 	if (browser->curr_hot) {
 		annotate_browser__set_rb_top(browser, browser->curr_hot);
@@ -634,7 +637,7 @@ static int annotate_browser__run(struct annotate_browser *browser, int evidx,
 		key = ui_browser__run(&browser->b, delay_secs);
 
 		if (delay_secs != 0) {
-			annotate_browser__calc_percent(browser, evidx);
+			annotate_browser__calc_percent(browser, evsel);
 			/*
 			 * Current line focus got out of the list of most active
 			 * lines, NULL it so that if TAB|UNTAB is pressed, we
@@ -650,7 +653,7 @@ static int annotate_browser__run(struct annotate_browser *browser, int evidx,
 				hbt->timer(hbt->arg);
 
 			if (delay_secs != 0)
-				symbol__annotate_decay_histogram(sym, evidx);
+				symbol__annotate_decay_histogram(sym, evsel->idx);
 			continue;
 		case K_TAB:
 			if (nd != NULL) {
@@ -747,7 +750,7 @@ show_help:
 					goto show_sup_ins;
 				goto out;
 			} else if (!(annotate_browser__jump(browser) ||
-				     annotate_browser__callq(browser, evidx, hbt))) {
+				     annotate_browser__callq(browser, evsel, hbt))) {
 show_sup_ins:
 				ui_helpline__puts("Actions are only available for 'callq', 'retq' & jump instructions.");
 			}
@@ -769,10 +772,10 @@ out:
 	return key;
 }
 
-int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
+int hist_entry__tui_annotate(struct hist_entry *he, struct perf_evsel *evsel,
 			     struct hist_browser_timer *hbt)
 {
-	return symbol__tui_annotate(he->ms.sym, he->ms.map, evidx, hbt);
+	return symbol__tui_annotate(he->ms.sym, he->ms.map, evsel, hbt);
 }
 
 static void annotate_browser__mark_jump_targets(struct annotate_browser *browser,
@@ -827,7 +830,8 @@ static inline int width_jumps(int n)
 	return 1;
 }
 
-int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
+int symbol__tui_annotate(struct symbol *sym, struct map *map,
+			 struct perf_evsel *evsel,
 			 struct hist_browser_timer *hbt)
 {
 	struct disasm_line *pos, *n;
@@ -910,7 +914,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 
 	annotate_browser__update_addr_width(&browser);
 
-	ret = annotate_browser__run(&browser, evidx, hbt);
+	ret = annotate_browser__run(&browser, evsel, hbt);
 	list_for_each_entry_safe(pos, n, &notes->src->source, node) {
 		list_del(&pos->node);
 		disasm_line__free(pos);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 893c07f172f5..a1229a449fa5 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1439,7 +1439,7 @@ do_annotate:
 			 * Don't let this be freed, say, by hists__decay_entry.
 			 */
 			he->used = true;
-			err = hist_entry__tui_annotate(he, evsel->idx, hbt);
+			err = hist_entry__tui_annotate(he, evsel, hbt);
 			he->used = false;
 			/*
 			 * offer option to annotate the other branch source or target
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 0ac9cc4c5e7d..3a088a367c52 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -14,6 +14,7 @@
 #include "symbol.h"
 #include "debug.h"
 #include "annotate.h"
+#include "evsel.h"
 #include <pthread.h>
 #include <linux/bitops.h>
 
@@ -635,7 +636,7 @@ struct disasm_line *disasm__get_next_ip_line(struct list_head *head, struct disa
 }
 
 static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 start,
-		      int evidx, u64 len, int min_pcnt, int printed,
+		      struct perf_evsel *evsel, u64 len, int min_pcnt, int printed,
 		      int max_lines, struct disasm_line *queue)
 {
 	static const char *prev_line;
@@ -648,7 +649,7 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 		const char *color;
 		struct annotation *notes = symbol__annotation(sym);
 		struct source_line *src_line = notes->src->lines;
-		struct sym_hist *h = annotation__histogram(notes, evidx);
+		struct sym_hist *h = annotation__histogram(notes, evsel->idx);
 		s64 offset = dl->offset;
 		const u64 addr = start + offset;
 		struct disasm_line *next;
@@ -680,7 +681,7 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 			list_for_each_entry_from(queue, &notes->src->source, node) {
 				if (queue == dl)
 					break;
-				disasm_line__print(queue, sym, start, evidx, len,
+				disasm_line__print(queue, sym, start, evsel, len,
 						    0, 0, 1, NULL);
 			}
 		}
@@ -967,7 +968,8 @@ static void symbol__free_source_line(struct symbol *sym, int len)
 
 /* Get the filename:line for the colored entries */
 static int symbol__get_source_line(struct symbol *sym, struct map *map,
-				   int evidx, struct rb_root *root, int len,
+				   struct perf_evsel *evsel,
+				   struct rb_root *root, int len,
 				   const char *filename)
 {
 	u64 start;
@@ -975,7 +977,7 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 	char cmd[PATH_MAX * 2];
 	struct source_line *src_line;
 	struct annotation *notes = symbol__annotation(sym);
-	struct sym_hist *h = annotation__histogram(notes, evidx);
+	struct sym_hist *h = annotation__histogram(notes, evsel->idx);
 	struct rb_root tmp_root = RB_ROOT;
 
 	if (!h->sum)
@@ -1050,10 +1052,10 @@ static void print_summary(struct rb_root *root, const char *filename)
 	}
 }
 
-static void symbol__annotate_hits(struct symbol *sym, int evidx)
+static void symbol__annotate_hits(struct symbol *sym, struct perf_evsel *evsel)
 {
 	struct annotation *notes = symbol__annotation(sym);
-	struct sym_hist *h = annotation__histogram(notes, evidx);
+	struct sym_hist *h = annotation__histogram(notes, evsel->idx);
 	u64 len = symbol__size(sym), offset;
 
 	for (offset = 0; offset < len; ++offset)
@@ -1063,9 +1065,9 @@ static void symbol__annotate_hits(struct symbol *sym, int evidx)
 	printf("%*s: %" PRIu64 "\n", BITS_PER_LONG / 2, "h->sum", h->sum);
 }
 
-int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
-			    bool full_paths, int min_pcnt, int max_lines,
-			    int context)
+int symbol__annotate_printf(struct symbol *sym, struct map *map,
+			    struct perf_evsel *evsel, bool full_paths,
+			    int min_pcnt, int max_lines, int context)
 {
 	struct dso *dso = map->dso;
 	char *filename;
@@ -1092,7 +1094,7 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 	printf("------------------------------------------------\n");
 
 	if (verbose)
-		symbol__annotate_hits(sym, evidx);
+		symbol__annotate_hits(sym, evsel);
 
 	list_for_each_entry(pos, &notes->src->source, node) {
 		if (context && queue == NULL) {
@@ -1100,7 +1102,7 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 			queue_len = 0;
 		}
 
-		switch (disasm_line__print(pos, sym, start, evidx, len,
+		switch (disasm_line__print(pos, sym, start, evsel, len,
 					    min_pcnt, printed, max_lines,
 					    queue)) {
 		case 0:
@@ -1195,7 +1197,8 @@ size_t disasm__fprintf(struct list_head *head, FILE *fp)
 	return printed;
 }
 
-int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
+int symbol__tty_annotate(struct symbol *sym, struct map *map,
+			 struct perf_evsel *evsel,
 			 bool print_lines, bool full_paths, int min_pcnt,
 			 int max_lines)
 {
@@ -1210,12 +1213,12 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 	len = symbol__size(sym);
 
 	if (print_lines) {
-		symbol__get_source_line(sym, map, evidx, &source_line,
+		symbol__get_source_line(sym, map, evsel, &source_line,
 					len, filename);
 		print_summary(&source_line, filename);
 	}
 
-	symbol__annotate_printf(sym, map, evidx, full_paths,
+	symbol__annotate_printf(sym, map, evsel, full_paths,
 				min_pcnt, max_lines, 0);
 	if (print_lines)
 		symbol__free_source_line(sym, len);
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 8eec94358a4a..5ce9ff3ffcd7 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -129,24 +129,25 @@ void symbol__annotate_zero_histograms(struct symbol *sym);
 
 int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize);
 int symbol__annotate_init(struct map *map __maybe_unused, struct symbol *sym);
-int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
-			    bool full_paths, int min_pcnt, int max_lines,
-			    int context);
+int symbol__annotate_printf(struct symbol *sym, struct map *map,
+			    struct perf_evsel *evsel, bool full_paths,
+			    int min_pcnt, int max_lines, int context);
 void symbol__annotate_zero_histogram(struct symbol *sym, int evidx);
 void symbol__annotate_decay_histogram(struct symbol *sym, int evidx);
 void disasm__purge(struct list_head *head);
 
-int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
-			 bool print_lines, bool full_paths, int min_pcnt,
-			 int max_lines);
+int symbol__tty_annotate(struct symbol *sym, struct map *map,
+			 struct perf_evsel *evsel, bool print_lines,
+			 bool full_paths, int min_pcnt, int max_lines);
 
 #ifdef NEWT_SUPPORT
-int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
+int symbol__tui_annotate(struct symbol *sym, struct map *map,
+			 struct perf_evsel *evsel,
 			 struct hist_browser_timer *hbt);
 #else
 static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
 				       struct map *map __maybe_unused,
-				       int evidx __maybe_unused,
+				       struct perf_evsel *evsel  __maybe_unused,
 				       struct hist_browser_timer *hbt
 				       __maybe_unused)
 {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 99ac4d34c917..71035cea22ae 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -167,7 +167,7 @@ struct hist_browser_timer {
 
 #ifdef NEWT_SUPPORT
 #include "../ui/keysyms.h"
-int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
+int hist_entry__tui_annotate(struct hist_entry *he, struct perf_evsel *evsel,
 			     struct hist_browser_timer *hbt);
 
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
@@ -186,7 +186,8 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __maybe_unused,
 
 static inline int hist_entry__tui_annotate(struct hist_entry *self
 					   __maybe_unused,
-					   int evidx __maybe_unused,
+					   struct perf_evsel *evsel
+					   __maybe_unused,
 					   struct hist_browser_timer *hbt
 					   __maybe_unused)
 {
-- 
1.7.9.2

