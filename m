Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab2K1NyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:54:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210Ab2K1NyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:54:19 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 13/14] perf diff: Display zero calculation results
Date: Wed, 28 Nov 2012 14:52:48 +0100
Message-Id: <1354110769-2998-14-git-send-email-jolsa@redhat.com>
In-Reply-To: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forcing zero calculation outputs to appear in final output,
so we can differ between zero output calculation result and
empty space for missing pair of baseline hist_entry.

Also skipping the compute and period output for dummy entries.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c | 24 +++++++++++++++---------
 tools/perf/util/hist.c    |  1 +
 tools/perf/util/sort.h    |  3 +++
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 50e1ea3..b801d0c 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -779,13 +779,15 @@ static int hpp__color_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
 		container_of(fmt, struct diff_data__fmt, fmt);
 	char pfmt[20] = " ";
 
-	if (percent) {
+	if (!he->dummy) {
 		scnprintf(pfmt, 20, "%%%d.2f%%%%", dfmt->header_width - 1);
 		return percent_color_snprintf(hpp->buf, hpp->size,
 					      pfmt, percent);
 	} else
 		return scnprintf(hpp->buf, hpp->size, "%*s",
 				 dfmt->header_width, pfmt);
+
+	return percent_color_snprintf(hpp->buf, hpp->size, pfmt, percent);
 }
 
 static int hpp__entry_baseline(struct perf_hpp_fmt *_fmt, struct perf_hpp *hpp,
@@ -797,7 +799,7 @@ static int hpp__entry_baseline(struct perf_hpp_fmt *_fmt, struct perf_hpp *hpp,
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
 	char buf[32] = " ";
 
-	if ((percent && he->pairs) || symbol_conf.field_sep)
+	if ((he->pairs) || symbol_conf.field_sep)
 		return scnprintf(hpp->buf, hpp->size, fmt, percent);
 	else
 		return scnprintf(hpp->buf, hpp->size, "%*s",
@@ -828,7 +830,8 @@ hpp__entry_unpair(struct hist_entry *he, int idx, char *buf, size_t size)
 {
 	switch (idx) {
 	case PERF_HPP_DIFF__PERIOD_BASELINE:
-		scnprintf(buf, size, "%" PRIu64, he->stat.period);
+		if (!he->dummy)
+			scnprintf(buf, size, "%" PRIu64, he->stat.period);
 		break;
 
 	default:
@@ -852,28 +855,31 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
 		else
 			diff = compute_delta(he, pair);
 
-		if (fabs(diff) >= 0.01)
-			scnprintf(buf, size, "%+4.2F%%", diff);
+		scnprintf(buf, size, "%+4.2F%%", diff);
 		break;
 
 	case PERF_HPP_DIFF__RATIO:
+		if (he->dummy)
+			break;
+
 		if (pair->diff.computed)
 			ratio = pair->diff.period_ratio;
 		else
 			ratio = compute_ratio(he, pair);
 
-		if (ratio > 0.0)
-			scnprintf(buf, size, "%14.6F", ratio);
+		scnprintf(buf, size, "%14.6F", ratio);
 		break;
 
 	case PERF_HPP_DIFF__WEIGHTED_DIFF:
+		if (he->dummy)
+			break;
+
 		if (pair->diff.computed)
 			wdiff = pair->diff.wdiff;
 		else
 			wdiff = compute_wdiff(he, pair);
 
-		if (wdiff != 0)
-			scnprintf(buf, size, "%14ld", wdiff);
+		scnprintf(buf, size, "%14ld", wdiff);
 		break;
 
 	case PERF_HPP_DIFF__DISPL:
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 25f94a4..531b5dc 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -745,6 +745,7 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 		rb_link_node(&he->rb_node, parent, p);
 		rb_insert_color(&he->rb_node, &hists->entries);
 		hists__inc_nr_entries(hists, he);
+		he->dummy = true;
 	}
 out:
 	return he;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 377b144..0e06872 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -93,6 +93,9 @@ struct hist_entry {
 	unsigned long		position;
 	struct rb_root		sorted_chain;
 
+	/* Added by hists__add_dummy_entry via hists__link */
+	bool			dummy;
+
 	/* diff related */
 	union {
 		struct hist_entry	**pairs;
-- 
1.7.11.7

