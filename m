Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab2K1Nxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:53:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206Ab2K1Nxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:53:45 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 05/14] perf diff: Change compute methods to work with pair directly
Date: Wed, 28 Nov 2012 14:52:40 +0100
Message-Id: <1354110769-2998-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing compute methods to operate over hist entry and its
pair directly. This makes the code more obvious and readable,
instead of all time checking for pair being != NULL.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c | 38 +++++++++++++++++---------------------
 tools/perf/ui/hist.c      | 40 +++++++++++++++++++++++++---------------
 tools/perf/util/hist.h    |  7 ++++---
 3 files changed, 46 insertions(+), 39 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 9fbbc01..342085a 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -146,47 +146,40 @@ static int setup_compute(const struct option *opt, const char *str,
 	return -EINVAL;
 }
 
-static double get_period_percent(struct hist_entry *he, u64 period)
+double perf_diff__period_percent(struct hist_entry *he, u64 period)
 {
 	u64 total = he->hists->stats.total_period;
 	return (period * 100.0) / total;
 }
 
-double perf_diff__compute_delta(struct hist_entry *he)
+double perf_diff__compute_delta(struct hist_entry *he, struct hist_entry *pair)
 {
-	struct hist_entry *pair = hist_entry__next_pair(he);
-	double new_percent = get_period_percent(he, he->stat.period);
-	double old_percent = pair ? get_period_percent(pair, pair->stat.period) : 0.0;
+	double new_percent = perf_diff__period_percent(he, he->stat.period);
+	double old_percent = perf_diff__period_percent(pair, pair->stat.period);
 
 	he->diff.period_ratio_delta = new_percent - old_percent;
 	he->diff.computed = true;
 	return he->diff.period_ratio_delta;
 }
 
-double perf_diff__compute_ratio(struct hist_entry *he)
+double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair)
 {
-	struct hist_entry *pair = hist_entry__next_pair(he);
 	double new_period = he->stat.period;
-	double old_period = pair ? pair->stat.period : 0;
+	double old_period = pair->stat.period;
 
 	he->diff.computed = true;
-	he->diff.period_ratio = pair ? (new_period / old_period) : 0;
+	he->diff.period_ratio = new_period / old_period;
 	return he->diff.period_ratio;
 }
 
-s64 perf_diff__compute_wdiff(struct hist_entry *he)
+s64 perf_diff__compute_wdiff(struct hist_entry *he, struct hist_entry *pair)
 {
-	struct hist_entry *pair = hist_entry__next_pair(he);
 	u64 new_period = he->stat.period;
-	u64 old_period = pair ? pair->stat.period : 0;
+	u64 old_period = pair->stat.period;
 
 	he->diff.computed = true;
-
-	if (!pair)
-		he->diff.wdiff = 0;
-	else
-		he->diff.wdiff = new_period * compute_wdiff_w2 -
-				 old_period * compute_wdiff_w1;
+	he->diff.wdiff = new_period * compute_wdiff_w2 -
+			 old_period * compute_wdiff_w1;
 
 	return he->diff.wdiff;
 }
@@ -385,18 +378,21 @@ static void hists__precompute(struct hists *hists)
 
 	while (next != NULL) {
 		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
+		struct hist_entry *pair = hist_entry__next_pair(he);
 
 		next = rb_next(&he->rb_node);
+		if (!pair)
+			continue;
 
 		switch (compute) {
 		case COMPUTE_DELTA:
-			perf_diff__compute_delta(he);
+			perf_diff__compute_delta(he, pair);
 			break;
 		case COMPUTE_RATIO:
-			perf_diff__compute_ratio(he);
+			perf_diff__compute_ratio(he, pair);
 			break;
 		case COMPUTE_WEIGHTED_DIFF:
-			perf_diff__compute_wdiff(he);
+			perf_diff__compute_wdiff(he, pair);
 			break;
 		default:
 			BUG_ON(1);
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 20a4392..a64c7f9 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -314,14 +314,18 @@ static int hpp__width_delta(struct perf_hpp_fmt *fmt __maybe_unused,
 static int hpp__entry_delta(struct perf_hpp_fmt *_fmt __maybe_unused,
 			    struct perf_hpp *hpp, struct hist_entry *he)
 {
+	struct hist_entry *pair = hist_entry__next_pair(he);
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%7.7s";
 	char buf[32] = " ";
-	double diff;
+	double diff = 0.0;
 
-	if (he->diff.computed)
-		diff = he->diff.period_ratio_delta;
-	else
-		diff = perf_diff__compute_delta(he);
+	if (pair) {
+		if (he->diff.computed)
+			diff = he->diff.period_ratio_delta;
+		else
+			diff = perf_diff__compute_delta(he, pair);
+	} else
+		diff = perf_diff__period_percent(he, he->stat.period);
 
 	if (fabs(diff) >= 0.01)
 		scnprintf(buf, sizeof(buf), "%+4.2F%%", diff);
@@ -346,14 +350,17 @@ static int hpp__width_ratio(struct perf_hpp_fmt *_fmt __maybe_unused,
 static int hpp__entry_ratio(struct perf_hpp_fmt *_fmt __maybe_unused,
 			    struct perf_hpp *hpp, struct hist_entry *he)
 {
+	struct hist_entry *pair = hist_entry__next_pair(he);
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
 	char buf[32] = " ";
-	double ratio;
+	double ratio = 0.0;
 
-	if (he->diff.computed)
-		ratio = he->diff.period_ratio;
-	else
-		ratio = perf_diff__compute_ratio(he);
+	if (pair) {
+		if (he->diff.computed)
+			ratio = he->diff.period_ratio;
+		else
+			ratio = perf_diff__compute_ratio(he, pair);
+	}
 
 	if (ratio > 0.0)
 		scnprintf(buf, sizeof(buf), "%+14.6F", ratio);
@@ -378,14 +385,17 @@ static int hpp__width_wdiff(struct perf_hpp_fmt *fmt __maybe_unused,
 static int hpp__entry_wdiff(struct perf_hpp_fmt *_fmt __maybe_unused,
 			    struct perf_hpp *hpp, struct hist_entry *he)
 {
+	struct hist_entry *pair = hist_entry__next_pair(he);
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
 	char buf[32] = " ";
-	s64 wdiff;
+	s64 wdiff = 0;
 
-	if (he->diff.computed)
-		wdiff = he->diff.wdiff;
-	else
-		wdiff = perf_diff__compute_wdiff(he);
+	if (pair) {
+		if (he->diff.computed)
+			wdiff = he->diff.wdiff;
+		else
+			wdiff = perf_diff__compute_wdiff(he, pair);
+	}
 
 	if (wdiff != 0)
 		scnprintf(buf, sizeof(buf), "%14ld", wdiff);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index e899e2d..53a1679 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -228,8 +228,9 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __maybe_unused,
 
 unsigned int hists__sort_list_width(struct hists *self);
 
-double perf_diff__compute_delta(struct hist_entry *he);
-double perf_diff__compute_ratio(struct hist_entry *he);
-s64 perf_diff__compute_wdiff(struct hist_entry *he);
+double perf_diff__compute_delta(struct hist_entry *he, struct hist_entry *pair);
+double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair);
+s64 perf_diff__compute_wdiff(struct hist_entry *he, struct hist_entry *pair);
 int perf_diff__formula(char *buf, size_t size, struct hist_entry *he);
+double perf_diff__period_percent(struct hist_entry *he, u64 period);
 #endif	/* __PERF_HIST_H */
-- 
1.7.11.7

