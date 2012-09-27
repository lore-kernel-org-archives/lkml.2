Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab2I0LKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:10:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792Ab2I0LKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:10:43 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 09/14] perf diff: Add option to sort entries based on diff computation
Date: Thu, 27 Sep 2012 13:09:30 +0200
Message-Id: <1348744175-11115-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to sort hist entries based on the outcome of selected
computation. It's now possible to specify '+' as a first character
of '-c' option value to make such sort.

Example:

  $ ./perf diff -cratio -b
  # Event 'cache-misses'
  #
  #   Baseline           Ratio      Shared Object                            Symbol
  #   ........  ..............  .................  ................................
  #
        19.64%            0.69  [kernel.kallsyms]  [k] clear_page
         0.30%            0.17  [kernel.kallsyms]  [k] mm_alloc
         0.04%            0.20  [kernel.kallsyms]  [k] kmem_cache_alloc

  $ ./perf diff -c+ratio -b
  # Event 'cache-misses'
  #
  #   Baseline           Ratio      Shared Object                            Symbol
  #   ........  ..............  .................  ................................
  #
        19.64%            0.69  [kernel.kallsyms]  [k] clear_page
         0.04%            0.20  [kernel.kallsyms]  [k] kmem_cache_alloc
         0.30%            0.17  [kernel.kallsyms]  [k] mm_alloc

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt |   2 +
 tools/perf/builtin-diff.c              | 137 +++++++++++++++++++++++++++++++++
 tools/perf/ui/hist.c                   |  29 +++----
 tools/perf/util/hist.h                 |   2 +
 tools/perf/util/sort.h                 |  15 ++++
 5 files changed, 167 insertions(+), 18 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index 8fff061..cff3d9b 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -79,6 +79,8 @@ OPTIONS
 -c::
 --compute::
         Differential computation selection - delta,ratio (default is delta).
+        If '+' is specified as a first character, the output is sorted based
+        on the computation results.
         See COMPARISON METHODS section for more info.
 
 COMPARISON METHODS
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index b5c15f3..14bc244 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -25,6 +25,7 @@ static char	  diff__default_sort_order[] = "dso,symbol";
 static bool  force;
 static bool show_displacement;
 static bool show_baseline_only;
+static bool sort_compute;
 
 enum {
 	COMPUTE_DELTA,
@@ -50,6 +51,13 @@ static int setup_compute(const struct option *opt, const char *str,
 		return 0;
 	}
 
+	if (*str == '+') {
+		sort_compute = true;
+		str++;
+		if (!*str)
+			return 0;
+	}
+
 	for (i = 0; i < COMPUTE_MAX; i++)
 		if (!strcmp(str, compute_names[i])) {
 			*cp = i;
@@ -60,6 +68,34 @@ static int setup_compute(const struct option *opt, const char *str,
 	return -EINVAL;
 }
 
+static double get_period_percent(struct hist_entry *he, u64 period)
+{
+	u64 total = he->hists->stats.total_period;
+	return (period * 100.0) / total;
+}
+
+double perf_diff__compute_delta(struct hist_entry *he)
+{
+	struct hist_entry *pair = he->pair;
+	double new_percent = get_period_percent(he, he->period);
+	double old_percent = pair ? get_period_percent(pair, pair->period) : 0.0;
+
+	he->diff.period_ratio_delta = new_percent - old_percent;
+	he->diff.computed = true;
+	return he->diff.period_ratio_delta;
+}
+
+double perf_diff__compute_ratio(struct hist_entry *he)
+{
+	struct hist_entry *pair = he->pair;
+	double new_period = he->period;
+	double old_period = pair ? pair->period : 0;
+
+	he->diff.computed = true;
+	he->diff.period_ratio = pair ? (new_period / old_period) : 0;
+	return he->diff.period_ratio;
+}
+
 static int hists__add_entry(struct hists *self,
 			    struct addr_location *al, u64 period)
 {
@@ -222,6 +258,102 @@ static void hists__baseline_only(struct hists *hists)
 	}
 }
 
+static void hists__precompute(struct hists *hists)
+{
+	struct rb_node *next = rb_first(&hists->entries);
+
+	while (next != NULL) {
+		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
+
+		next = rb_next(&he->rb_node);
+
+		switch (compute) {
+		case COMPUTE_DELTA:
+			perf_diff__compute_delta(he);
+			break;
+		case COMPUTE_RATIO:
+			perf_diff__compute_ratio(he);
+			break;
+		default:
+			BUG_ON(1);
+		}
+	}
+}
+
+static int64_t cmp_doubles(double l, double r)
+{
+	if (l > r)
+		return -1;
+	else if (l < r)
+		return 1;
+	else
+		return 0;
+}
+
+static int64_t
+hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
+			int c)
+{
+	switch (c) {
+	case COMPUTE_DELTA:
+	{
+		double l = left->diff.period_ratio_delta;
+		double r = right->diff.period_ratio_delta;
+
+		return cmp_doubles(l, r);
+	}
+	case COMPUTE_RATIO:
+	{
+		double l = left->diff.period_ratio;
+		double r = right->diff.period_ratio;
+
+		return cmp_doubles(l, r);
+	}
+	default:
+		BUG_ON(1);
+	}
+
+	return 0;
+}
+
+static void insert_hist_entry_by_compute(struct rb_root *root,
+					 struct hist_entry *he,
+					 int c)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct hist_entry *iter;
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct hist_entry, rb_node);
+		if (hist_entry__cmp_compute(he, iter, c) < 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&he->rb_node, parent, p);
+	rb_insert_color(&he->rb_node, root);
+}
+
+static void hists__compute_resort(struct hists *hists)
+{
+	struct rb_root tmp = RB_ROOT;
+	struct rb_node *next = rb_first(&hists->entries);
+
+	while (next != NULL) {
+		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
+
+		next = rb_next(&he->rb_node);
+
+		rb_erase(&he->rb_node, &hists->entries);
+		insert_hist_entry_by_compute(&tmp, he, compute);
+	}
+
+	hists->entries = tmp;
+}
+
 static void hists__process(struct hists *old, struct hists *new)
 {
 	hists__match(old, new);
@@ -229,6 +361,11 @@ static void hists__process(struct hists *old, struct hists *new)
 	if (show_baseline_only)
 		hists__baseline_only(new);
 
+	if (sort_compute) {
+		hists__precompute(new);
+		hists__compute_resort(new);
+	}
+
 	hists__fprintf(new, true, 0, 0, stdout);
 }
 
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 81f3b4f..21b57a2 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -242,24 +242,15 @@ static int hpp__width_delta(struct perf_hpp *hpp __maybe_unused)
 
 static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	struct hist_entry *pair = he->pair;
-	struct hists *pair_hists = pair ? pair->hists : NULL;
-	struct hists *hists = he->hists;
-	u64 old_total, new_total;
-	double old_percent = 0, new_percent = 0;
-	double diff;
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%7.7s";
 	char buf[32] = " ";
+	double diff;
 
-	old_total = pair_hists ? pair_hists->stats.total_period : 0;
-	if (old_total > 0 && pair)
-		old_percent = 100.0 * pair->period / old_total;
-
-	new_total = hists->stats.total_period;
-	if (new_total > 0)
-		new_percent = 100.0 * he->period / new_total;
+	if (he->diff.computed)
+		diff = he->diff.period_ratio_delta;
+	else
+		diff = perf_diff__compute_delta(he);
 
-	diff = new_percent - old_percent;
 	if (fabs(diff) >= 0.01)
 		scnprintf(buf, sizeof(buf), "%+4.2F%%", diff);
 
@@ -280,12 +271,14 @@ static int hpp__width_ratio(struct perf_hpp *hpp __maybe_unused)
 
 static int hpp__entry_ratio(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	struct hist_entry *pair = he->pair;
-	double new_period = he->period;
-	double old_period = pair ? pair->period : 0;
-	double ratio = pair ? new_period / old_period : 0;
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
 	char buf[32] = " ";
+	double ratio;
+
+	if (he->diff.computed)
+		ratio = he->diff.period_ratio;
+	else
+		ratio = perf_diff__compute_ratio(he);
 
 	if (ratio > 0.0)
 		scnprintf(buf, sizeof(buf), "%+14.6F", ratio);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index b239504..2dbb340 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -206,4 +206,6 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
 
 unsigned int hists__sort_list_width(struct hists *self);
 
+double perf_diff__compute_delta(struct hist_entry *he);
+double perf_diff__compute_ratio(struct hist_entry *he);
 #endif	/* __PERF_HIST_H */
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index f070b52..2090670 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -43,6 +43,19 @@ extern struct sort_entry sort_sym_from;
 extern struct sort_entry sort_sym_to;
 extern enum sort_type sort__first_dimension;
 
+struct hist_entry_diff {
+	bool	computed;
+
+	/* PERF_HPP__DISPL */
+	int	displacement;
+
+	/* PERF_HPP__DELTA */
+	double	period_ratio_delta;
+
+	/* PERF_HPP__RATIO */
+	double	period_ratio;
+};
+
 /**
  * struct hist_entry - histogram entry
  *
@@ -63,6 +76,8 @@ struct hist_entry {
 	s32			cpu;
 	u32			nr_events;
 
+	struct hist_entry_diff	diff;
+
 	/* XXX These two should move to some tree widget lib */
 	u16			row_offset;
 	u16			nr_rows;
-- 
1.7.11.4

