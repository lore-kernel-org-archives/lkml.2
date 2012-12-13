Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab2LMNJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:09:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582Ab2LMNJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:09:47 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 07/14] perf hists: Marking dummy hists entries
Date: Thu, 13 Dec 2012 14:09:05 +0100
Message-Id: <1355404152-16523-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1355404152-16523-1-git-send-email-jolsa@redhat.com>
References: <1355404152-16523-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It does not make sense to make some computation (ratio, wdiff),
when the hist_entry is 'dummy' - added via hists__link.

Adding dummy field to struct hist_entry which indicates
that it was added by hists__link and avoiding some of
the processing for such entries.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c   | 21 ++++++++++++++-------
 tools/perf/util/hist.c |  1 +
 tools/perf/util/sort.h |  3 +++
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index a81f0c9..7da98ac 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -200,8 +200,11 @@ static int hpp__color_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
 {
 	double percent = baseline_percent(he);
 
-	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%",
-				      percent);
+	if (!he->dummy)
+		return percent_color_snprintf(hpp->buf, hpp->size,
+					      " %6.2f%%", percent);
+	else
+		return scnprintf(hpp->buf, hpp->size, "        ");
 }
 
 static int hpp__entry_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
@@ -210,7 +213,10 @@ static int hpp__entry_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
 	double percent = baseline_percent(he);
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
 
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
+	if (!he->dummy)
+		return scnprintf(hpp->buf, hpp->size, fmt, percent);
+	else
+		return scnprintf(hpp->buf, hpp->size, "            ");
 }
 
 static int hpp__header_samples(struct perf_hpp_fmt *_fmt __maybe_unused,
@@ -309,8 +315,7 @@ static int hpp__entry_delta(struct perf_hpp_fmt *_fmt __maybe_unused,
 			diff = he->diff.period_ratio_delta;
 		else
 			diff = perf_diff__compute_delta(he, pair);
-	} else
-		diff = perf_diff__period_percent(he, he->stat.period);
+	}
 
 	if (fabs(diff) >= 0.01)
 		scnprintf(buf, sizeof(buf), "%+4.2F%%", diff);
@@ -340,7 +345,8 @@ static int hpp__entry_ratio(struct perf_hpp_fmt *_fmt __maybe_unused,
 	char buf[32] = " ";
 	double ratio = 0.0;
 
-	if (pair) {
+	/* No point for ratio number if we are dummy.. */
+	if (!he->dummy && pair) {
 		if (he->diff.computed)
 			ratio = he->diff.period_ratio;
 		else
@@ -375,7 +381,8 @@ static int hpp__entry_wdiff(struct perf_hpp_fmt *_fmt __maybe_unused,
 	char buf[32] = " ";
 	s64 wdiff = 0;
 
-	if (pair) {
+	/* No point for wdiff number if we are dummy.. */
+	if (!he->dummy && pair) {
 		if (he->diff.computed)
 			wdiff = he->diff.wdiff;
 		else
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 37179af..677d1c9 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -761,6 +761,7 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 		rb_link_node(&he->rb_node_in, parent, p);
 		rb_insert_color(&he->rb_node_in, root);
 		hists__inc_nr_entries(hists, he);
+		he->dummy = true;
 	}
 out:
 	return he;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 7425f8d..a7f6e05 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -86,6 +86,9 @@ struct hist_entry {
 
 	struct hist_entry_diff	diff;
 
+	/* We are added by hists__add_dummy_entry. */
+	bool			dummy;
+
 	/* XXX These two should move to some tree widget lib */
 	u16			row_offset;
 	u16			nr_rows;
-- 
1.7.11.7

