Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab2K1N4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:56:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932125Ab2K1Nxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:53:49 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 06/14] perf diff: Change formula methods to work with pair directly
Date: Wed, 28 Nov 2012 14:52:41 +0100
Message-Id: <1354110769-2998-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing formula methods to operate over hist entry and its
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
 tools/perf/builtin-diff.c | 35 +++++++++++++----------------------
 tools/perf/ui/hist.c      |  5 ++++-
 tools/perf/util/hist.h    |  3 ++-
 3 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 342085a..d869029 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -184,13 +184,9 @@ s64 perf_diff__compute_wdiff(struct hist_entry *he, struct hist_entry *pair)
 	return he->diff.wdiff;
 }
 
-static int formula_delta(struct hist_entry *he, char *buf, size_t size)
+static int formula_delta(struct hist_entry *he, struct hist_entry *pair,
+			 char *buf, size_t size)
 {
-	struct hist_entry *pair = hist_entry__next_pair(he);
-
-	if (!pair)
-		return -1;
-
 	return scnprintf(buf, size,
 			 "(%" PRIu64 " * 100 / %" PRIu64 ") - "
 			 "(%" PRIu64 " * 100 / %" PRIu64 ")",
@@ -198,41 +194,36 @@ static int formula_delta(struct hist_entry *he, char *buf, size_t size)
 			  pair->stat.period, pair->hists->stats.total_period);
 }
 
-static int formula_ratio(struct hist_entry *he, char *buf, size_t size)
+static int formula_ratio(struct hist_entry *he, struct hist_entry *pair,
+			 char *buf, size_t size)
 {
-	struct hist_entry *pair = hist_entry__next_pair(he);
 	double new_period = he->stat.period;
-	double old_period = pair ? pair->stat.period : 0;
-
-	if (!pair)
-		return -1;
+	double old_period = pair->stat.period;
 
 	return scnprintf(buf, size, "%.0F / %.0F", new_period, old_period);
 }
 
-static int formula_wdiff(struct hist_entry *he, char *buf, size_t size)
+static int formula_wdiff(struct hist_entry *he, struct hist_entry *pair,
+			 char *buf, size_t size)
 {
-	struct hist_entry *pair = hist_entry__next_pair(he);
 	u64 new_period = he->stat.period;
-	u64 old_period = pair ? pair->stat.period : 0;
-
-	if (!pair)
-		return -1;
+	u64 old_period = pair->stat.period;
 
 	return scnprintf(buf, size,
 		  "(%" PRIu64 " * " "%" PRId64 ") - (%" PRIu64 " * " "%" PRId64 ")",
 		  new_period, compute_wdiff_w2, old_period, compute_wdiff_w1);
 }
 
-int perf_diff__formula(char *buf, size_t size, struct hist_entry *he)
+int perf_diff__formula(struct hist_entry *he, struct hist_entry *pair,
+		       char *buf, size_t size)
 {
 	switch (compute) {
 	case COMPUTE_DELTA:
-		return formula_delta(he, buf, size);
+		return formula_delta(he, pair, buf, size);
 	case COMPUTE_RATIO:
-		return formula_ratio(he, buf, size);
+		return formula_ratio(he, pair, buf, size);
 	case COMPUTE_WEIGHTED_DIFF:
-		return formula_wdiff(he, buf, size);
+		return formula_wdiff(he, pair, buf, size);
 	default:
 		BUG_ON(1);
 	}
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index a64c7f9..d6fdb00 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -446,10 +446,13 @@ static int hpp__width_formula(struct perf_hpp_fmt *fmt __maybe_unused,
 static int hpp__entry_formula(struct perf_hpp_fmt *_fmt __maybe_unused,
 			      struct perf_hpp *hpp, struct hist_entry *he)
 {
+	struct hist_entry *pair = hist_entry__next_pair(he);
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%-70s";
 	char buf[96] = " ";
 
-	perf_diff__formula(buf, sizeof(buf), he);
+	if (pair)
+		perf_diff__formula(he, pair, buf, sizeof(buf));
+
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 53a1679..7f5cce8 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -231,6 +231,7 @@ unsigned int hists__sort_list_width(struct hists *self);
 double perf_diff__compute_delta(struct hist_entry *he, struct hist_entry *pair);
 double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair);
 s64 perf_diff__compute_wdiff(struct hist_entry *he, struct hist_entry *pair);
-int perf_diff__formula(char *buf, size_t size, struct hist_entry *he);
+int perf_diff__formula(struct hist_entry *he, struct hist_entry *pair,
+		       char *buf, size_t size);
 double perf_diff__period_percent(struct hist_entry *he, u64 period);
 #endif	/* __PERF_HIST_H */
-- 
1.7.11.7

