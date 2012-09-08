Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab2IHUiG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 16:38:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36191 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab2IHUhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 16:37:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/9] perf hists: Use perf_hpp__format->width to calculate the column widths
Date: Sat,  8 Sep 2012 17:36:49 -0300
Message-Id: <1347136614-25598-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347136614-25598-1-git-send-email-acme@infradead.org>
References: <1347136614-25598-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346640790-17197-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/hist.c   |   27 +++++++++++++++++++++++++++
 tools/perf/util/hist.c |   33 ---------------------------------
 2 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 009adf2..031b349 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -360,3 +360,30 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
 
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
index b1817f1..0ba65ad 100644
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
1.7.1

