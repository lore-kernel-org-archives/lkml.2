Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab2K1NyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:54:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab2K1Nx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:53:57 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 11/14] perf diff: Making compute functions static
Date: Wed, 28 Nov 2012 14:52:46 +0100
Message-Id: <1354110769-2998-12-git-send-email-jolsa@redhat.com>
In-Reply-To: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All compute functions are now local to the diff command,
making them static.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c | 24 ++++++++++++------------
 tools/perf/util/hist.h    |  6 ------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 9f4ef76..81f7529 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -233,7 +233,7 @@ static double get_period_percent(struct hist_entry *he, u64 period)
 	return (period * 100.0) / total;
 }
 
-double perf_diff__compute_delta(struct hist_entry *he, struct hist_entry *pair)
+static double compute_delta(struct hist_entry *he, struct hist_entry *pair)
 {
 	double old_percent = get_period_percent(he, he->stat.period);
 	double new_percent = get_period_percent(pair, pair->stat.period);
@@ -243,7 +243,7 @@ double perf_diff__compute_delta(struct hist_entry *he, struct hist_entry *pair)
 	return pair->diff.period_ratio_delta;
 }
 
-double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair)
+static double compute_ratio(struct hist_entry *he, struct hist_entry *pair)
 {
 	double old_period = he->stat.period ?: 1;
 	double new_period = pair->stat.period;
@@ -253,7 +253,7 @@ double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair)
 	return pair->diff.period_ratio;
 }
 
-s64 perf_diff__compute_wdiff(struct hist_entry *he, struct hist_entry *pair)
+static s64 compute_wdiff(struct hist_entry *he, struct hist_entry *pair)
 {
 	u64 old_period = he->stat.period;
 	u64 new_period = pair->stat.period;
@@ -295,8 +295,8 @@ static int formula_wdiff(struct hist_entry *he, struct hist_entry *pair,
 		  new_period, compute_wdiff_w1, old_period, compute_wdiff_w2);
 }
 
-int perf_diff__formula(struct hist_entry *he, struct hist_entry *pair,
-		       char *buf, size_t size)
+static int formula_fprintf(struct hist_entry *he, struct hist_entry *pair,
+			   char *buf, size_t size)
 {
 	switch (compute) {
 	case COMPUTE_DELTA:
@@ -457,13 +457,13 @@ static void __hists__precompute(struct hist_entry *he)
 
 		switch (compute) {
 		case COMPUTE_DELTA:
-			perf_diff__compute_delta(he, pair);
+			compute_delta(he, pair);
 			break;
 		case COMPUTE_RATIO:
-			perf_diff__compute_ratio(he, pair);
+			compute_ratio(he, pair);
 			break;
 		case COMPUTE_WEIGHTED_DIFF:
-			perf_diff__compute_wdiff(he, pair);
+			compute_wdiff(he, pair);
 			break;
 		default:
 			BUG_ON(1);
@@ -834,7 +834,7 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
 		if (pair->diff.computed)
 			diff = pair->diff.period_ratio_delta;
 		else
-			diff = perf_diff__compute_delta(he, pair);
+			diff = compute_delta(he, pair);
 
 		if (fabs(diff) >= 0.01)
 			scnprintf(buf, size, "%+4.2F%%", diff);
@@ -844,7 +844,7 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
 		if (pair->diff.computed)
 			ratio = pair->diff.period_ratio;
 		else
-			ratio = perf_diff__compute_ratio(he, pair);
+			ratio = compute_ratio(he, pair);
 
 		if (ratio > 0.0)
 			scnprintf(buf, size, "%14.6F", ratio);
@@ -854,7 +854,7 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
 		if (pair->diff.computed)
 			wdiff = pair->diff.wdiff;
 		else
-			wdiff = perf_diff__compute_wdiff(he, pair);
+			wdiff = compute_wdiff(he, pair);
 
 		if (wdiff != 0)
 			scnprintf(buf, size, "%14ld", wdiff);
@@ -868,7 +868,7 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
 		break;
 
 	case PERF_HPP_DIFF__FORMULA:
-		perf_diff__formula(he, pair, buf, size);
+		formula_fprintf(he, pair, buf, size);
 		break;
 
 	case PERF_HPP_DIFF__PERIOD:
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index d4f19eb..e00b6b9 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -225,10 +225,4 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __maybe_unused,
 #endif
 
 unsigned int hists__sort_list_width(struct hists *self);
-
-double perf_diff__compute_delta(struct hist_entry *he, struct hist_entry *pair);
-double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair);
-s64 perf_diff__compute_wdiff(struct hist_entry *he, struct hist_entry *pair);
-int perf_diff__formula(struct hist_entry *he, struct hist_entry *pair,
-		       char *buf, size_t size);
 #endif	/* __PERF_HIST_H */
-- 
1.7.11.7

