Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab2HVFzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:55:35 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49264 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab2HVFz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:55:29 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-30-5034744dd80d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/5] perf hists: Use perf_hpp__format->width to calculate the column widths
Date: Wed, 22 Aug 2012 14:48:35 +0900
Message-Id: <1345614517-5753-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1345614517-5753-1-git-send-email-namhyung@kernel.org>
References: <1345614517-5753-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c   | 27 +++++++++++++++++++++++++++
 tools/perf/util/hist.c | 33 ---------------------------------
 2 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 802a8659c15a..16dc486d02be 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -337,3 +337,30 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
 
 	return ret;
 }
+
+/*
+ * See hists__fprintf to match the column widths
+ */
+unsigned int hists__sort_list_width(struct hists *hists)
+{
+	struct sort_entry *se;
+	int i, ret = 0;
+
+	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
+		if (!perf_hpp__format[i].cond)
+			continue;
+		if (i)
+			ret += 2;
+
+		ret += perf_hpp__format[i].width(NULL);
+	}
+
+	list_for_each_entry(se, &hist_entry__sort_list, list)
+		if (!se->elide)
+			ret += 2 + hists__col_len(hists, se->se_width_idx);
+
+	if (verbose) /* Addr + origin */
+		ret += 3 + BITS_PER_LONG / 4;
+
+	return ret;
+}
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b1817f15bb87..0ba65ad07cd1 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -563,39 +563,6 @@ void hists__output_resort_threaded(struct hists *hists)
 	return __hists__output_resort(hists, true);
 }
 
-/*
- * See hists__fprintf to match the column widths
- */
-unsigned int hists__sort_list_width(struct hists *hists)
-{
-	struct sort_entry *se;
-	int ret = 9; /* total % */
-
-	if (symbol_conf.show_cpu_utilization) {
-		ret += 7; /* count_sys % */
-		ret += 6; /* count_us % */
-		if (perf_guest) {
-			ret += 13; /* count_guest_sys % */
-			ret += 12; /* count_guest_us % */
-		}
-	}
-
-	if (symbol_conf.show_nr_samples)
-		ret += 11;
-
-	if (symbol_conf.show_total_period)
-		ret += 13;
-
-	list_for_each_entry(se, &hist_entry__sort_list, list)
-		if (!se->elide)
-			ret += 2 + hists__col_len(hists, se->se_width_idx);
-
-	if (verbose) /* Addr + origin */
-		ret += 3 + BITS_PER_LONG / 4;
-
-	return ret;
-}
-
 static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h,
 				       enum hist_filter filter)
 {
-- 
1.7.11.4

