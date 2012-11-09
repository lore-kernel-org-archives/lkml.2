Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab2KIVrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:47:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48152 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab2KIVn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:43:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 08/21] perf diff: Start moving to support matching more than two hists
Date: Fri,  9 Nov 2012 18:42:57 -0300
Message-Id: <1352497390-17716-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352497390-17716-1-git-send-email-acme@infradead.org>
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We want to match more than two hists, so that we can match more than two
perf.data files and moreover, match hist_entries (buckets) in multiple
events in a group.

So the "baseline"/"leader" will instead of a ->pair pointer, use a
list_head, that will link to the pairs and hists__match use it.

Following that perf_evlist__link will link the hists in its evsel
groups.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-2kbmzepoi544ygj9godseqpv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c |   21 ++++++++++++---------
 tools/perf/ui/hist.c      |   10 +++++-----
 tools/perf/util/hist.c    |    2 ++
 tools/perf/util/sort.h    |   27 +++++++++++++++++++++++----
 4 files changed, 42 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 380683d..8a9db38 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -154,7 +154,7 @@ static double get_period_percent(struct hist_entry *he, u64 period)
 
 double perf_diff__compute_delta(struct hist_entry *he)
 {
-	struct hist_entry *pair = he->pair;
+	struct hist_entry *pair = hist_entry__next_pair(he);
 	double new_percent = get_period_percent(he, he->stat.period);
 	double old_percent = pair ? get_period_percent(pair, pair->stat.period) : 0.0;
 
@@ -165,7 +165,7 @@ double perf_diff__compute_delta(struct hist_entry *he)
 
 double perf_diff__compute_ratio(struct hist_entry *he)
 {
-	struct hist_entry *pair = he->pair;
+	struct hist_entry *pair = hist_entry__next_pair(he);
 	double new_period = he->stat.period;
 	double old_period = pair ? pair->stat.period : 0;
 
@@ -176,7 +176,7 @@ double perf_diff__compute_ratio(struct hist_entry *he)
 
 s64 perf_diff__compute_wdiff(struct hist_entry *he)
 {
-	struct hist_entry *pair = he->pair;
+	struct hist_entry *pair = hist_entry__next_pair(he);
 	u64 new_period = he->stat.period;
 	u64 old_period = pair ? pair->stat.period : 0;
 
@@ -193,7 +193,7 @@ s64 perf_diff__compute_wdiff(struct hist_entry *he)
 
 static int formula_delta(struct hist_entry *he, char *buf, size_t size)
 {
-	struct hist_entry *pair = he->pair;
+	struct hist_entry *pair = hist_entry__next_pair(he);
 
 	if (!pair)
 		return -1;
@@ -207,7 +207,7 @@ static int formula_delta(struct hist_entry *he, char *buf, size_t size)
 
 static int formula_ratio(struct hist_entry *he, char *buf, size_t size)
 {
-	struct hist_entry *pair = he->pair;
+	struct hist_entry *pair = hist_entry__next_pair(he);
 	double new_period = he->stat.period;
 	double old_period = pair ? pair->stat.period : 0;
 
@@ -219,7 +219,7 @@ static int formula_ratio(struct hist_entry *he, char *buf, size_t size)
 
 static int formula_wdiff(struct hist_entry *he, char *buf, size_t size)
 {
-	struct hist_entry *pair = he->pair;
+	struct hist_entry *pair = hist_entry__next_pair(he);
 	u64 new_period = he->stat.period;
 	u64 old_period = pair ? pair->stat.period : 0;
 
@@ -359,8 +359,11 @@ static void hists__match(struct hists *older, struct hists *newer)
 	struct rb_node *nd;
 
 	for (nd = rb_first(&newer->entries); nd; nd = rb_next(nd)) {
-		struct hist_entry *pos = rb_entry(nd, struct hist_entry, rb_node);
-		pos->pair = hists__find_entry(older, pos);
+		struct hist_entry *pos = rb_entry(nd, struct hist_entry, rb_node),
+				  *pair = hists__find_entry(older, pos);
+
+		if (pair)
+			hist__entry_add_pair(pos, pair);
 	}
 }
 
@@ -402,7 +405,7 @@ static void hists__baseline_only(struct hists *hists)
 		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
 
 		next = rb_next(&he->rb_node);
-		if (!he->pair) {
+		if (!hist_entry__next_pair(he)) {
 			rb_erase(&he->rb_node, &hists->entries);
 			hist_entry__free(he);
 		}
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 4f5f475..aa84130 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -161,7 +161,7 @@ static int hpp__width_baseline(struct perf_hpp *hpp __maybe_unused)
 
 static double baseline_percent(struct hist_entry *he)
 {
-	struct hist_entry *pair = he->pair;
+	struct hist_entry *pair = hist_entry__next_pair(he);
 	struct hists *pair_hists = pair ? pair->hists : NULL;
 	double percent = 0.0;
 
@@ -179,7 +179,7 @@ static int hpp__color_baseline(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = baseline_percent(he);
 
-	if (he->pair)
+	if (hist_entry__has_pairs(he))
 		return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
 	else
 		return scnprintf(hpp->buf, hpp->size, "        ");
@@ -190,7 +190,7 @@ static int hpp__entry_baseline(struct perf_hpp *hpp, struct hist_entry *he)
 	double percent = baseline_percent(he);
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
 
-	if (he->pair || symbol_conf.field_sep)
+	if (hist_entry__has_pairs(he) || symbol_conf.field_sep)
 		return scnprintf(hpp->buf, hpp->size, fmt, percent);
 	else
 		return scnprintf(hpp->buf, hpp->size, "            ");
@@ -248,7 +248,7 @@ static int hpp__width_period_baseline(struct perf_hpp *hpp __maybe_unused)
 
 static int hpp__entry_period_baseline(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	struct hist_entry *pair = he->pair;
+	struct hist_entry *pair = hist_entry__next_pair(he);
 	u64 period = pair ? pair->stat.period : 0;
 	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%12" PRIu64;
 
@@ -354,7 +354,7 @@ static int hpp__width_displ(struct perf_hpp *hpp __maybe_unused)
 static int hpp__entry_displ(struct perf_hpp *hpp,
 			    struct hist_entry *he)
 {
-	struct hist_entry *pair = he->pair;
+	struct hist_entry *pair = hist_entry__next_pair(he);
 	long displacement = pair ? pair->position - he->position : 0;
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%6.6s";
 	char buf[32] = " ";
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index a1b823f..f42de79 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -244,6 +244,8 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 			he->ms.map->referenced = true;
 		if (symbol_conf.use_callchain)
 			callchain_init(he->callchain);
+
+		INIT_LIST_HEAD(&he->pairs.node);
 	}
 
 	return he;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 13761d8..b4e8c3b 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -77,6 +77,10 @@ struct hist_entry_diff {
 struct hist_entry {
 	struct rb_node		rb_node_in;
 	struct rb_node		rb_node;
+	union {
+		struct list_head node;
+		struct list_head head;
+	} pairs;
 	struct he_stat		stat;
 	struct map_symbol	ms;
 	struct thread		*thread;
@@ -96,15 +100,30 @@ struct hist_entry {
 	char			*srcline;
 	struct symbol		*parent;
 	unsigned long		position;
-	union {
-		struct hist_entry *pair;
-		struct rb_root	  sorted_chain;
-	};
+	struct rb_root		sorted_chain;
 	struct branch_info	*branch_info;
 	struct hists		*hists;
 	struct callchain_root	callchain[0];
 };
 
+static inline bool hist_entry__has_pairs(struct hist_entry *he)
+{
+	return !list_empty(&he->pairs.node);
+}
+
+static inline struct hist_entry *hist_entry__next_pair(struct hist_entry *he)
+{
+	if (hist_entry__has_pairs(he))
+		return list_entry(he->pairs.node.next, struct hist_entry, pairs.node);
+	return NULL;
+}
+
+static inline void hist__entry_add_pair(struct hist_entry *he,
+					struct hist_entry *pair)
+{
+	list_add_tail(&he->pairs.head, &pair->pairs.node);
+}
+
 enum sort_type {
 	SORT_PID,
 	SORT_COMM,
-- 
1.7.9.2.358.g22243

