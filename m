Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab2JDMvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:51:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58823 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab2JDMvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:51:36 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 07/20] perf hists: Introduce struct he_stat
Date: Thu,  4 Oct 2012 21:49:41 +0900
Message-Id: <1349354994-17853-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1349354994-17853-1-git-send-email-namhyung@kernel.org>
References: <1349354994-17853-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The struct he_stat is for separating out statistics data of a hist
entry.  It is required for later changes.

It's just a mechanical change and should have no functional
differences.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c |    8 +++----
 tools/perf/ui/gtk/browser.c    |    2 +-
 tools/perf/ui/hist.c           |   30 +++++++++++------------
 tools/perf/ui/stdio/hist.c     |    2 +-
 tools/perf/util/hist.c         |   52 +++++++++++++++++++++-------------------
 tools/perf/util/sort.h         |   16 ++++++++-----
 6 files changed, 59 insertions(+), 51 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index d359795454d0..0568536ecf67 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -570,7 +570,7 @@ static int hist_browser__hpp_color_ ## _name(struct perf_hpp *hpp,	\
 					     struct hist_entry *he)	\
 {									\
 	struct hists *hists = he->hists;				\
-	double percent = 100.0 * he->_field / hists->stats.total_period;\
+	double percent = 100.0 * he->stat._field / hists->stats.total_period; \
 	*(double *)hpp->ptr = percent;					\
 	return scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);	\
 }
@@ -982,7 +982,7 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 		folded_sign = hist_entry__folded(he);
 
 	hist_entry__sort_snprintf(he, s, sizeof(s), browser->hists);
-	percent = (he->period * 100.0) / browser->hists->stats.total_period;
+	percent = (he->stat.period * 100.0) / browser->hists->stats.total_period;
 
 	if (symbol_conf.use_callchain)
 		printed += fprintf(fp, "%c ", folded_sign);
@@ -990,10 +990,10 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 	printed += fprintf(fp, " %5.2f%%", percent);
 
 	if (symbol_conf.show_nr_samples)
-		printed += fprintf(fp, " %11u", he->nr_events);
+		printed += fprintf(fp, " %11u", he->stat.nr_events);
 
 	if (symbol_conf.show_total_period)
-		printed += fprintf(fp, " %12" PRIu64, he->period);
+		printed += fprintf(fp, " %12" PRIu64, he->stat.period);
 
 	printed += fprintf(fp, "%s\n", rtrim(s));
 
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 3cbb1d622ed2..4125c6284114 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -50,7 +50,7 @@ static int perf_gtk__hpp_color_ ## _name(struct perf_hpp *hpp,			\
 					 struct hist_entry *he)			\
 {										\
 	struct hists *hists = he->hists;					\
-	double percent = 100.0 * he->_field / hists->stats.total_period;	\
+	double percent = 100.0 * he->stat._field / hists->stats.total_period;	\
 	const char *markup;							\
 	int ret = 0;								\
 										\
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 7f043394bef1..f5a1e4f65263 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -19,7 +19,7 @@ static int hpp__width_overhead(struct perf_hpp *hpp __maybe_unused)
 static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
-	double percent = 100.0 * he->period / hists->stats.total_period;
+	double percent = 100.0 * he->stat.period / hists->stats.total_period;
 
 	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
 }
@@ -27,7 +27,7 @@ static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
-	double percent = 100.0 * he->period / hists->stats.total_period;
+	double percent = 100.0 * he->stat.period / hists->stats.total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
@@ -48,7 +48,7 @@ static int hpp__width_overhead_sys(struct perf_hpp *hpp __maybe_unused)
 static int hpp__color_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
-	double percent = 100.0 * he->period_sys / hists->stats.total_period;
+	double percent = 100.0 * he->stat.period_sys / hists->stats.total_period;
 
 	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
 }
@@ -56,7 +56,7 @@ static int hpp__color_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
 static int hpp__entry_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
-	double percent = 100.0 * he->period_sys / hists->stats.total_period;
+	double percent = 100.0 * he->stat.period_sys / hists->stats.total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%6.2f%%";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
@@ -77,7 +77,7 @@ static int hpp__width_overhead_us(struct perf_hpp *hpp __maybe_unused)
 static int hpp__color_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
-	double percent = 100.0 * he->period_us / hists->stats.total_period;
+	double percent = 100.0 * he->stat.period_us / hists->stats.total_period;
 
 	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
 }
@@ -85,7 +85,7 @@ static int hpp__color_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
 static int hpp__entry_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
-	double percent = 100.0 * he->period_us / hists->stats.total_period;
+	double percent = 100.0 * he->stat.period_us / hists->stats.total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%6.2f%%";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
@@ -105,7 +105,7 @@ static int hpp__color_overhead_guest_sys(struct perf_hpp *hpp,
 					 struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
-	double percent = 100.0 * he->period_guest_sys / hists->stats.total_period;
+	double percent = 100.0 * he->stat.period_guest_sys / hists->stats.total_period;
 
 	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
 }
@@ -114,7 +114,7 @@ static int hpp__entry_overhead_guest_sys(struct perf_hpp *hpp,
 					 struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
-	double percent = 100.0 * he->period_guest_sys / hists->stats.total_period;
+	double percent = 100.0 * he->stat.period_guest_sys / hists->stats.total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%% ";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
@@ -134,7 +134,7 @@ static int hpp__color_overhead_guest_us(struct perf_hpp *hpp,
 					struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
-	double percent = 100.0 * he->period_guest_us / hists->stats.total_period;
+	double percent = 100.0 * he->stat.period_guest_us / hists->stats.total_period;
 
 	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
 }
@@ -143,7 +143,7 @@ static int hpp__entry_overhead_guest_us(struct perf_hpp *hpp,
 					struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
-	double percent = 100.0 * he->period_guest_us / hists->stats.total_period;
+	double percent = 100.0 * he->stat.period_guest_us / hists->stats.total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%% ";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
@@ -167,7 +167,7 @@ static double baseline_percent(struct hist_entry *he)
 
 	if (pair) {
 		u64 total_period = pair_hists->stats.total_period;
-		u64 base_period  = pair->period;
+		u64 base_period  = pair->stat.period;
 
 		percent = 100.0 * base_period / total_period;
 	}
@@ -206,7 +206,7 @@ static int hpp__entry_samples(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%11" PRIu64;
 
-	return scnprintf(hpp->buf, hpp->size, fmt, he->nr_events);
+	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.nr_events);
 }
 
 static int hpp__header_period(struct perf_hpp *hpp)
@@ -225,7 +225,7 @@ static int hpp__entry_period(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%12" PRIu64;
 
-	return scnprintf(hpp->buf, hpp->size, fmt, he->period);
+	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.period);
 }
 
 static int hpp__header_delta(struct perf_hpp *hpp)
@@ -253,11 +253,11 @@ static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
 
 	old_total = pair_hists ? pair_hists->stats.total_period : 0;
 	if (old_total > 0 && pair)
-		old_percent = 100.0 * pair->period / old_total;
+		old_percent = 100.0 * pair->stat.period / old_total;
 
 	new_total = hists->stats.total_period;
 	if (new_total > 0)
-		new_percent = 100.0 * he->period / new_total;
+		new_percent = 100.0 * he->stat.period / new_total;
 
 	diff = new_percent - old_percent;
 	if (fabs(diff) >= 0.01)
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 850c6d293f46..fbd4e32d0743 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -271,7 +271,7 @@ static size_t hist_entry_callchain__fprintf(struct hist_entry *he,
 {
 	switch (callchain_param.mode) {
 	case CHAIN_GRAPH_REL:
-		return callchain__fprintf_graph(fp, &he->sorted_chain, he->period,
+		return callchain__fprintf_graph(fp, &he->sorted_chain, he->stat.period,
 						left_margin);
 		break;
 	case CHAIN_GRAPH_ABS:
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 040f34c79a53..3197f3f50018 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -135,16 +135,16 @@ static void hist_entry__add_cpumode_period(struct hist_entry *he,
 {
 	switch (cpumode) {
 	case PERF_RECORD_MISC_KERNEL:
-		he->period_sys += period;
+		he->stat.period_sys += period;
 		break;
 	case PERF_RECORD_MISC_USER:
-		he->period_us += period;
+		he->stat.period_us += period;
 		break;
 	case PERF_RECORD_MISC_GUEST_KERNEL:
-		he->period_guest_sys += period;
+		he->stat.period_guest_sys += period;
 		break;
 	case PERF_RECORD_MISC_GUEST_USER:
-		he->period_guest_us += period;
+		he->stat.period_guest_us += period;
 		break;
 	default:
 		break;
@@ -153,13 +153,13 @@ static void hist_entry__add_cpumode_period(struct hist_entry *he,
 
 static void hist_entry__decay(struct hist_entry *he)
 {
-	he->period = (he->period * 7) / 8;
-	he->nr_events = (he->nr_events * 7) / 8;
+	he->stat.period = (he->stat.period * 7) / 8;
+	he->stat.nr_events = (he->stat.nr_events * 7) / 8;
 }
 
 static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 {
-	u64 prev_period = he->period;
+	u64 prev_period = he->stat.period;
 
 	if (prev_period == 0)
 		return true;
@@ -167,9 +167,9 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 	hist_entry__decay(he);
 
 	if (!he->filtered)
-		hists->stats.total_period -= prev_period - he->period;
+		hists->stats.total_period -= prev_period - he->stat.period;
 
-	return he->period == 0;
+	return he->stat.period == 0;
 }
 
 static void __hists__decay_entries(struct hists *hists, bool zap_user,
@@ -223,7 +223,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 
 	if (he != NULL) {
 		*he = *template;
-		he->nr_events = 1;
+		he->stat.nr_events = 1;
 		if (he->ms.map)
 			he->ms.map->referenced = true;
 		if (symbol_conf.use_callchain)
@@ -238,7 +238,7 @@ static void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 	if (!h->filtered) {
 		hists__calc_col_len(hists, h);
 		++hists->nr_entries;
-		hists->stats.total_period += h->period;
+		hists->stats.total_period += h->stat.period;
 	}
 }
 
@@ -270,8 +270,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		cmp = hist_entry__cmp(entry, he);
 
 		if (!cmp) {
-			he->period += period;
-			++he->nr_events;
+			he->stat.period += period;
+			++he->stat.nr_events;
 
 			/* If the map of an existing hist_entry has
 			 * become out-of-date due to an exec() or
@@ -321,7 +321,9 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 		.cpu	= al->cpu,
 		.ip	= bi->to.addr,
 		.level	= al->level,
-		.period	= period,
+		.stat = {
+			.period	= period,
+		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
 		.branch_info = bi,
@@ -344,7 +346,9 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.cpu	= al->cpu,
 		.ip	= al->addr,
 		.level	= al->level,
-		.period	= period,
+		.stat = {
+			.period	= period,
+		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
 		.hists	= self,
@@ -412,12 +416,12 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 		cmp = hist_entry__collapse(iter, he);
 
 		if (!cmp) {
-			iter->period		+= he->period;
-			iter->period_sys	+= he->period_sys;
-			iter->period_us		+= he->period_us;
-			iter->period_guest_sys	+= he->period_guest_sys;
-			iter->period_guest_us	+= he->period_guest_us;
-			iter->nr_events		+= he->nr_events;
+			iter->stat.period		+= he->stat.period;
+			iter->stat.period_sys		+= he->stat.period_sys;
+			iter->stat.period_us		+= he->stat.period_us;
+			iter->stat.period_guest_sys	+= he->stat.period_guest_sys;
+			iter->stat.period_guest_us	+= he->stat.period_guest_us;
+			iter->stat.nr_events		+= he->stat.nr_events;
 
 			if (symbol_conf.use_callchain) {
 				callchain_cursor_reset(&callchain_cursor);
@@ -520,7 +524,7 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node);
 
-		if (he->period > iter->period)
+		if (he->stat.period > iter->stat.period)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -581,8 +585,8 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
 	if (h->ms.unfolded)
 		hists->nr_entries += h->nr_rows;
 	h->row_offset = 0;
-	hists->stats.total_period += h->period;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] += h->nr_events;
+	hists->stats.total_period += h->stat.period;
+	hists->stats.nr_events[PERF_RECORD_SAMPLE] += h->stat.nr_events;
 
 	hists__calc_col_len(hists, h);
 }
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index f070b523c81a..5786f323b597 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -43,6 +43,15 @@ extern struct sort_entry sort_sym_from;
 extern struct sort_entry sort_sym_to;
 extern enum sort_type sort__first_dimension;
 
+struct he_stat {
+	u64			period;
+	u64			period_sys;
+	u64			period_us;
+	u64			period_guest_sys;
+	u64			period_guest_us;
+	u32			nr_events;
+};
+
 /**
  * struct hist_entry - histogram entry
  *
@@ -52,16 +61,11 @@ extern enum sort_type sort__first_dimension;
 struct hist_entry {
 	struct rb_node		rb_node_in;
 	struct rb_node		rb_node;
-	u64			period;
-	u64			period_sys;
-	u64			period_us;
-	u64			period_guest_sys;
-	u64			period_guest_us;
+	struct he_stat		stat;
 	struct map_symbol	ms;
 	struct thread		*thread;
 	u64			ip;
 	s32			cpu;
-	u32			nr_events;
 
 	/* XXX These two should move to some tree widget lib */
 	u16			row_offset;
-- 
1.7.9.2

