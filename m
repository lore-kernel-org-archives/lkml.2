Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab1JFRWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:22:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:44275 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758703Ab1JFRWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:22:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/15] perf hists: Stop using 'self' for struct hists
Date: Thu,  6 Oct 2011 14:22:24 -0300
Message-Id: <1317921758-4154-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317921758-4154-1-git-send-email-acme@infradead.org>
References: <1317921758-4154-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Stop using this python/OOP convention, doesn't really helps. Will do
more from time to time till we get it cleaned up in all of /perf.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-91i56jwnzq9edhsj9y2y9l3b@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |  156 ++++++++++++++++++++++++------------------------
 1 files changed, 78 insertions(+), 78 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 677e1da..dd27789 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -18,56 +18,56 @@ struct callchain_param	callchain_param = {
 	.order  = ORDER_CALLEE
 };
 
-u16 hists__col_len(struct hists *self, enum hist_column col)
+u16 hists__col_len(struct hists *hists, enum hist_column col)
 {
-	return self->col_len[col];
+	return hists->col_len[col];
 }
 
-void hists__set_col_len(struct hists *self, enum hist_column col, u16 len)
+void hists__set_col_len(struct hists *hists, enum hist_column col, u16 len)
 {
-	self->col_len[col] = len;
+	hists->col_len[col] = len;
 }
 
-bool hists__new_col_len(struct hists *self, enum hist_column col, u16 len)
+bool hists__new_col_len(struct hists *hists, enum hist_column col, u16 len)
 {
-	if (len > hists__col_len(self, col)) {
-		hists__set_col_len(self, col, len);
+	if (len > hists__col_len(hists, col)) {
+		hists__set_col_len(hists, col, len);
 		return true;
 	}
 	return false;
 }
 
-static void hists__reset_col_len(struct hists *self)
+static void hists__reset_col_len(struct hists *hists)
 {
 	enum hist_column col;
 
 	for (col = 0; col < HISTC_NR_COLS; ++col)
-		hists__set_col_len(self, col, 0);
+		hists__set_col_len(hists, col, 0);
 }
 
-static void hists__calc_col_len(struct hists *self, struct hist_entry *h)
+static void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 {
 	u16 len;
 
 	if (h->ms.sym)
-		hists__new_col_len(self, HISTC_SYMBOL, h->ms.sym->namelen);
+		hists__new_col_len(hists, HISTC_SYMBOL, h->ms.sym->namelen);
 	else {
 		const unsigned int unresolved_col_width = BITS_PER_LONG / 4;
 
-		if (hists__col_len(self, HISTC_DSO) < unresolved_col_width &&
+		if (hists__col_len(hists, HISTC_DSO) < unresolved_col_width &&
 		    !symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
 		    !symbol_conf.dso_list)
-			hists__set_col_len(self, HISTC_DSO,
+			hists__set_col_len(hists, HISTC_DSO,
 					   unresolved_col_width);
 	}
 
 	len = thread__comm_len(h->thread);
-	if (hists__new_col_len(self, HISTC_COMM, len))
-		hists__set_col_len(self, HISTC_THREAD, len + 6);
+	if (hists__new_col_len(hists, HISTC_COMM, len))
+		hists__set_col_len(hists, HISTC_THREAD, len + 6);
 
 	if (h->ms.map) {
 		len = dso__name_len(h->ms.map->dso);
-		hists__new_col_len(self, HISTC_DSO, len);
+		hists__new_col_len(hists, HISTC_DSO, len);
 	}
 }
 
@@ -113,11 +113,11 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 	return self;
 }
 
-static void hists__inc_nr_entries(struct hists *self, struct hist_entry *h)
+static void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 {
 	if (!h->filtered) {
-		hists__calc_col_len(self, h);
-		++self->nr_entries;
+		hists__calc_col_len(hists, h);
+		++hists->nr_entries;
 	}
 }
 
@@ -128,11 +128,11 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 	return 0;
 }
 
-struct hist_entry *__hists__add_entry(struct hists *self,
+struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct addr_location *al,
 				      struct symbol *sym_parent, u64 period)
 {
-	struct rb_node **p = &self->entries.rb_node;
+	struct rb_node **p = &hists->entries.rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
 	struct hist_entry entry = {
@@ -172,8 +172,8 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 	if (!he)
 		return NULL;
 	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, &self->entries);
-	hists__inc_nr_entries(self, he);
+	rb_insert_color(&he->rb_node, &hists->entries);
+	hists__inc_nr_entries(hists, he);
 out:
 	hist_entry__add_cpumode_period(he, al->cpumode, period);
 	return he;
@@ -222,7 +222,7 @@ void hist_entry__free(struct hist_entry *he)
  * collapse the histogram
  */
 
-static bool hists__collapse_insert_entry(struct hists *self,
+static bool hists__collapse_insert_entry(struct hists *hists,
 					 struct rb_root *root,
 					 struct hist_entry *he)
 {
@@ -240,8 +240,8 @@ static bool hists__collapse_insert_entry(struct hists *self,
 		if (!cmp) {
 			iter->period += he->period;
 			if (symbol_conf.use_callchain) {
-				callchain_cursor_reset(&self->callchain_cursor);
-				callchain_merge(&self->callchain_cursor, iter->callchain,
+				callchain_cursor_reset(&hists->callchain_cursor);
+				callchain_merge(&hists->callchain_cursor, iter->callchain,
 						he->callchain);
 			}
 			hist_entry__free(he);
@@ -259,7 +259,7 @@ static bool hists__collapse_insert_entry(struct hists *self,
 	return true;
 }
 
-void hists__collapse_resort(struct hists *self)
+void hists__collapse_resort(struct hists *hists)
 {
 	struct rb_root tmp;
 	struct rb_node *next;
@@ -269,20 +269,20 @@ void hists__collapse_resort(struct hists *self)
 		return;
 
 	tmp = RB_ROOT;
-	next = rb_first(&self->entries);
-	self->nr_entries = 0;
-	hists__reset_col_len(self);
+	next = rb_first(&hists->entries);
+	hists->nr_entries = 0;
+	hists__reset_col_len(hists);
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
-		rb_erase(&n->rb_node, &self->entries);
-		if (hists__collapse_insert_entry(self, &tmp, n))
-			hists__inc_nr_entries(self, n);
+		rb_erase(&n->rb_node, &hists->entries);
+		if (hists__collapse_insert_entry(hists, &tmp, n))
+			hists__inc_nr_entries(hists, n);
 	}
 
-	self->entries = tmp;
+	hists->entries = tmp;
 }
 
 /*
@@ -315,31 +315,31 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 	rb_insert_color(&he->rb_node, entries);
 }
 
-void hists__output_resort(struct hists *self)
+void hists__output_resort(struct hists *hists)
 {
 	struct rb_root tmp;
 	struct rb_node *next;
 	struct hist_entry *n;
 	u64 min_callchain_hits;
 
-	min_callchain_hits = self->stats.total_period * (callchain_param.min_percent / 100);
+	min_callchain_hits = hists->stats.total_period * (callchain_param.min_percent / 100);
 
 	tmp = RB_ROOT;
-	next = rb_first(&self->entries);
+	next = rb_first(&hists->entries);
 
-	self->nr_entries = 0;
-	hists__reset_col_len(self);
+	hists->nr_entries = 0;
+	hists__reset_col_len(hists);
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
-		rb_erase(&n->rb_node, &self->entries);
+		rb_erase(&n->rb_node, &hists->entries);
 		__hists__insert_output_entry(&tmp, n, min_callchain_hits);
-		hists__inc_nr_entries(self, n);
+		hists__inc_nr_entries(hists, n);
 	}
 
-	self->entries = tmp;
+	hists->entries = tmp;
 }
 
 static size_t callchain__fprintf_left_margin(FILE *fp, int left_margin)
@@ -738,7 +738,7 @@ static size_t hist_entry__fprintf_callchain(struct hist_entry *self,
 					     left_margin);
 }
 
-size_t hists__fprintf(struct hists *self, struct hists *pair,
+size_t hists__fprintf(struct hists *hists, struct hists *pair,
 		      bool show_displacement, FILE *fp)
 {
 	struct sort_entry *se;
@@ -803,15 +803,15 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 		width = strlen(se->se_header);
 		if (symbol_conf.col_width_list_str) {
 			if (col_width) {
-				hists__set_col_len(self, se->se_width_idx,
+				hists__set_col_len(hists, se->se_width_idx,
 						   atoi(col_width));
 				col_width = strchr(col_width, ',');
 				if (col_width)
 					++col_width;
 			}
 		}
-		if (!hists__new_col_len(self, se->se_width_idx, width))
-			width = hists__col_len(self, se->se_width_idx);
+		if (!hists__new_col_len(hists, se->se_width_idx, width))
+			width = hists__col_len(hists, se->se_width_idx);
 		fprintf(fp, "  %*s", width, se->se_header);
 	}
 	fprintf(fp, "\n");
@@ -834,7 +834,7 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 			continue;
 
 		fprintf(fp, "  ");
-		width = hists__col_len(self, se->se_width_idx);
+		width = hists__col_len(hists, se->se_width_idx);
 		if (width == 0)
 			width = strlen(se->se_header);
 		for (i = 0; i < width; i++)
@@ -844,7 +844,7 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 	fprintf(fp, "\n#\n");
 
 print_entries:
-	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
 		if (h->filtered)
@@ -858,12 +858,12 @@ print_entries:
 				displacement = 0;
 			++position;
 		}
-		ret += hist_entry__fprintf(h, self, pair, show_displacement,
-					   displacement, fp, self->stats.total_period);
+		ret += hist_entry__fprintf(h, hists, pair, show_displacement,
+					   displacement, fp, hists->stats.total_period);
 
 		if (symbol_conf.use_callchain)
-			ret += hist_entry__fprintf_callchain(h, self, fp,
-							     self->stats.total_period);
+			ret += hist_entry__fprintf_callchain(h, hists, fp,
+							     hists->stats.total_period);
 		if (h->ms.map == NULL && verbose > 1) {
 			__map_groups__fprintf_maps(&h->thread->mg,
 						   MAP__FUNCTION, verbose, fp);
@@ -879,7 +879,7 @@ print_entries:
 /*
  * See hists__fprintf to match the column widths
  */
-unsigned int hists__sort_list_width(struct hists *self)
+unsigned int hists__sort_list_width(struct hists *hists)
 {
 	struct sort_entry *se;
 	int ret = 9; /* total % */
@@ -898,7 +898,7 @@ unsigned int hists__sort_list_width(struct hists *self)
 
 	list_for_each_entry(se, &hist_entry__sort_list, list)
 		if (!se->elide)
-			ret += 2 + hists__col_len(self, se->se_width_idx);
+			ret += 2 + hists__col_len(hists, se->se_width_idx);
 
 	if (verbose) /* Addr + origin */
 		ret += 3 + BITS_PER_LONG / 4;
@@ -906,32 +906,32 @@ unsigned int hists__sort_list_width(struct hists *self)
 	return ret;
 }
 
-static void hists__remove_entry_filter(struct hists *self, struct hist_entry *h,
+static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h,
 				       enum hist_filter filter)
 {
 	h->filtered &= ~(1 << filter);
 	if (h->filtered)
 		return;
 
-	++self->nr_entries;
+	++hists->nr_entries;
 	if (h->ms.unfolded)
-		self->nr_entries += h->nr_rows;
+		hists->nr_entries += h->nr_rows;
 	h->row_offset = 0;
-	self->stats.total_period += h->period;
-	self->stats.nr_events[PERF_RECORD_SAMPLE] += h->nr_events;
+	hists->stats.total_period += h->period;
+	hists->stats.nr_events[PERF_RECORD_SAMPLE] += h->nr_events;
 
-	hists__calc_col_len(self, h);
+	hists__calc_col_len(hists, h);
 }
 
-void hists__filter_by_dso(struct hists *self, const struct dso *dso)
+void hists__filter_by_dso(struct hists *hists, const struct dso *dso)
 {
 	struct rb_node *nd;
 
-	self->nr_entries = self->stats.total_period = 0;
-	self->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
-	hists__reset_col_len(self);
+	hists->nr_entries = hists->stats.total_period = 0;
+	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists__reset_col_len(hists);
 
-	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
 		if (symbol_conf.exclude_other && !h->parent)
@@ -942,19 +942,19 @@ void hists__filter_by_dso(struct hists *self, const struct dso *dso)
 			continue;
 		}
 
-		hists__remove_entry_filter(self, h, HIST_FILTER__DSO);
+		hists__remove_entry_filter(hists, h, HIST_FILTER__DSO);
 	}
 }
 
-void hists__filter_by_thread(struct hists *self, const struct thread *thread)
+void hists__filter_by_thread(struct hists *hists, const struct thread *thread)
 {
 	struct rb_node *nd;
 
-	self->nr_entries = self->stats.total_period = 0;
-	self->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
-	hists__reset_col_len(self);
+	hists->nr_entries = hists->stats.total_period = 0;
+	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists__reset_col_len(hists);
 
-	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
 		if (thread != NULL && h->thread != thread) {
@@ -962,7 +962,7 @@ void hists__filter_by_thread(struct hists *self, const struct thread *thread)
 			continue;
 		}
 
-		hists__remove_entry_filter(self, h, HIST_FILTER__THREAD);
+		hists__remove_entry_filter(hists, h, HIST_FILTER__THREAD);
 	}
 }
 
@@ -976,13 +976,13 @@ int hist_entry__annotate(struct hist_entry *he, size_t privsize)
 	return symbol__annotate(he->ms.sym, he->ms.map, privsize);
 }
 
-void hists__inc_nr_events(struct hists *self, u32 type)
+void hists__inc_nr_events(struct hists *hists, u32 type)
 {
-	++self->stats.nr_events[0];
-	++self->stats.nr_events[type];
+	++hists->stats.nr_events[0];
+	++hists->stats.nr_events[type];
 }
 
-size_t hists__fprintf_nr_events(struct hists *self, FILE *fp)
+size_t hists__fprintf_nr_events(struct hists *hists, FILE *fp)
 {
 	int i;
 	size_t ret = 0;
@@ -990,7 +990,7 @@ size_t hists__fprintf_nr_events(struct hists *self, FILE *fp)
 	for (i = 0; i < PERF_RECORD_HEADER_MAX; ++i) {
 		const char *name;
 
-		if (self->stats.nr_events[i] == 0)
+		if (hists->stats.nr_events[i] == 0)
 			continue;
 
 		name = perf_event__name(i);
@@ -998,7 +998,7 @@ size_t hists__fprintf_nr_events(struct hists *self, FILE *fp)
 			continue;
 
 		ret += fprintf(fp, "%16s events: %10d\n", name,
-			       self->stats.nr_events[i]);
+			       hists->stats.nr_events[i]);
 	}
 
 	return ret;
-- 
1.6.2.5

