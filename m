Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab2IFPuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:50:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758604Ab2IFPsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:48:16 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 08/12] perf diff: Add option to sort entries based on diff computation
Date: Thu,  6 Sep 2012 17:47:02 +0200
Message-Id: <1346946426-13496-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
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
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt |   2 +
 tools/perf/builtin-diff.c              | 140 +++++++++++++++++++++++++++++++++
 tools/perf/ui/stdio/hist.c             |  20 +++--
 tools/perf/ui/stdio/hist.h             |   4 +
 tools/perf/util/sort.h                 |  15 ++++
 5 files changed, 173 insertions(+), 8 deletions(-)

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
index cde08d4..f72a2e4 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -26,6 +26,7 @@ static char	  diff__default_sort_order[] = "dso,symbol";
 static bool  force;
 static bool show_displacement;
 static bool show_baseline_only;
+static bool sort_compute;
 
 enum {
 	COMPUTE_DELTA,
@@ -50,6 +51,13 @@ static int setup_compute(void)
 		return 0;
 	}
 
+	if (*compute_str == '+') {
+		sort_compute = true;
+		compute_str++;
+		if (!*compute_str)
+			return 0;
+	}
+
 	for (i = 0; i < COMPUTE_MAX; i++)
 		if (!strcmp(compute_str, compute_names[i])) {
 			compute = i;
@@ -60,6 +68,34 @@ static int setup_compute(void)
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
@@ -222,6 +258,105 @@ static void hists__baseline_only(struct hists *hists)
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
+		if (!he->pair)
+			continue;
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
@@ -229,6 +364,11 @@ static void hists__process(struct hists *old, struct hists *new)
 	if (show_baseline_only)
 		hists__baseline_only(new);
 
+	if (sort_compute) {
+		hists__precompute(new);
+		hists__compute_resort(new);
+	}
+
 	hists__fprintf(new, true, 0, 0, stdout);
 }
 
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 02ba1c7..8c717ab 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -16,12 +16,14 @@ static int
 hists_stdio_column__delta_snprintf(struct hist_entry *he, char *bf,
 				   size_t size, unsigned int width __used)
 {
-	struct hist_entry *pair = he->pair;
-	double new_percent = get_period_percent(he, he->period);
-	double old_percent = pair ? get_period_percent(pair, pair->period) : 0.0;
-	double diff = new_percent - old_percent;
+	double diff;
 	int ret;
 
+	if (he->diff.computed)
+		diff = he->diff.period_ratio_delta;
+	else
+		diff = perf_diff__compute_delta(he);
+
 	if (fabs(diff) >= 0.01)
 		ret = percent_color_snprintf(bf, size, "%+7.2F%%", diff);
 	else
@@ -34,10 +36,12 @@ static int
 hists_stdio_column__ratio_snprintf(struct hist_entry *he, char *bf,
 				   size_t size, unsigned int width __used)
 {
-	struct hist_entry *pair = he->pair;
-	double new_period = he->period;
-	double old_period = pair ? pair->period : 0;
-	double ratio = pair ? new_period / old_period : 0;
+	double ratio;
+
+	if (he->diff.computed)
+		ratio = he->diff.period_ratio;
+	else
+		ratio = perf_diff__compute_ratio(he);
 
 	return percent_color_snprintf(bf, size, "%14.3F", ratio);
 }
diff --git a/tools/perf/ui/stdio/hist.h b/tools/perf/ui/stdio/hist.h
index 8e15d88..c8ac633 100644
--- a/tools/perf/ui/stdio/hist.h
+++ b/tools/perf/ui/stdio/hist.h
@@ -16,4 +16,8 @@ struct hists_stdio_column {
 int hists_stdio_column__register_idx(int idx);
 void hists_stdio_column__register_global(void);
 void hists_stdio_column__set_width(struct hists *hists);
+
+double perf_diff__compute_delta(struct hist_entry *he);
+double perf_diff__compute_ratio(struct hist_entry *he);
+
 #endif /* __PERF_UI_STDIO_HIST_H */
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 967d381..9f707b7 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -42,6 +42,19 @@ extern struct sort_entry sort_sym_from;
 extern struct sort_entry sort_sym_to;
 extern enum sort_type sort__first_dimension;
 
+struct hist_entry_diff {
+	bool	computed;
+
+	/* HISTC_DISPLACEMENT */
+	int	displacement;
+
+	/* HISTC_DELTA */
+	double	period_ratio_delta;
+
+	/* HISTC_RATIO */
+	double	period_ratio;
+};
+
 /**
  * struct hist_entry - histogram entry
  *
@@ -62,6 +75,8 @@ struct hist_entry {
 	s32			cpu;
 	u32			nr_events;
 
+	struct hist_entry_diff	diff;
+
 	/* XXX These two should move to some tree widget lib */
 	u16			row_offset;
 	u16			nr_rows;
-- 
1.7.11.4

