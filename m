Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab2HTE74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:59:56 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56341 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab2HTE7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:59:09 -0400
X-AuditID: 9c930197-b7bb2ae0000011d9-22-5031c41cfe03
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/7] perf hists: Refactor some functions
Date: Mon, 20 Aug 2012 13:52:06 +0900
Message-Id: <1345438331-20234-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1345438331-20234-1-git-send-email-namhyung@kernel.org>
References: <1345438331-20234-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Rename functions for consistency and move callchain print function
into hist_entry__fprintf().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c |  4 ++--
 tools/perf/ui/stdio/hist.c     | 51 +++++++++++++++++++++++-------------------
 tools/perf/util/hist.h         |  4 ++--
 3 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index b8094692c153..81bd8c2af730 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -586,7 +586,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 	}
 
 	if (row_offset == 0) {
-		hist_entry__snprintf(entry, s, sizeof(s), browser->hists);
+		hist_entry__sort_snprintf(entry, s, sizeof(s), browser->hists);
 		percent = (entry->period * 100.0) / browser->hists->stats.total_period;
 
 		ui_browser__set_percent_color(&browser->b, percent, current_entry);
@@ -931,7 +931,7 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 	if (symbol_conf.use_callchain)
 		folded_sign = hist_entry__folded(he);
 
-	hist_entry__snprintf(he, s, sizeof(s), browser->hists);
+	hist_entry__sort_snprintf(he, s, sizeof(s), browser->hists);
 	percent = (he->period * 100.0) / browser->hists->stats.total_period;
 
 	if (symbol_conf.use_callchain)
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 7881d625e17a..9bf7e9e5a72e 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -291,7 +291,7 @@ static size_t hist_entry_callchain__fprintf(struct hist_entry *he,
 	return 0;
 }
 
-static int hist_entry__pcnt_snprintf(struct hist_entry *he, char *s,
+static int hist_entry__period_snprintf(struct hist_entry *he, char *s,
 				     size_t size, struct hists *pair_hists,
 				     bool show_displacement, long displacement,
 				     bool color, u64 total_period)
@@ -404,8 +404,8 @@ static int hist_entry__pcnt_snprintf(struct hist_entry *he, char *s,
 	return ret;
 }
 
-int hist_entry__snprintf(struct hist_entry *he, char *s, size_t size,
-			 struct hists *hists)
+int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
+			      struct hists *hists)
 {
 	const char *sep = symbol_conf.field_sep;
 	struct sort_entry *se;
@@ -423,6 +423,22 @@ int hist_entry__snprintf(struct hist_entry *he, char *s, size_t size,
 	return ret;
 }
 
+static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
+					    struct hists *hists,
+					    u64 total_period, FILE *fp)
+{
+	int left_margin = 0;
+
+	if (sort__first_dimension == SORT_COMM) {
+		struct sort_entry *se = list_first_entry(&hist_entry__sort_list,
+							 typeof(*se), list);
+		left_margin = hists__col_len(hists, se->se_width_idx);
+		left_margin -= thread__comm_len(he->thread);
+	}
+
+	return hist_entry_callchain__fprintf(he, total_period, left_margin, fp);
+}
+
 static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 			       struct hists *hists, struct hists *pair_hists,
 			       bool show_displacement, long displacement,
@@ -434,27 +450,18 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 	if (size == 0 || size > sizeof(bf))
 		size = sizeof(bf);
 
-	ret = hist_entry__pcnt_snprintf(he, bf, size, pair_hists,
-					show_displacement, displacement,
-					true, total_period);
-	hist_entry__snprintf(he, bf + ret, size - ret, hists);
-	return fprintf(fp, "%s\n", bf);
-}
+	ret = hist_entry__period_snprintf(he, bf, size, pair_hists,
+					  show_displacement, displacement,
+					  true, total_period);
+	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
 
-static size_t hist_entry__fprintf_callchain(struct hist_entry *he,
-					    struct hists *hists,
-					    u64 total_period, FILE *fp)
-{
-	int left_margin = 0;
+	ret = fprintf(fp, "%s\n", bf);
 
-	if (sort__first_dimension == SORT_COMM) {
-		struct sort_entry *se = list_first_entry(&hist_entry__sort_list,
-							 typeof(*se), list);
-		left_margin = hists__col_len(hists, se->se_width_idx);
-		left_margin -= thread__comm_len(he->thread);
-	}
+	if (symbol_conf.use_callchain)
+		ret += hist_entry__callchain_fprintf(he, hists,
+						     total_period, fp);
 
-	return hist_entry_callchain__fprintf(he, total_period, left_margin, fp);
+	return ret;
 }
 
 size_t hists__fprintf(struct hists *hists, struct hists *pair,
@@ -608,8 +615,6 @@ print_entries:
 		ret += hist_entry__fprintf(h, max_cols, hists, pair, show_displacement,
 					   displacement, total_period, fp);
 
-		if (symbol_conf.use_callchain)
-			ret += hist_entry__fprintf_callchain(h, hists, total_period, fp);
 		if (max_rows && ++nr_rows >= max_rows)
 			goto out;
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 69fab7d9abcd..2e650ffb7d23 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -75,8 +75,8 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct symbol *parent, u64 period);
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
-int hist_entry__snprintf(struct hist_entry *self, char *bf, size_t size,
-			 struct hists *hists);
+int hist_entry__sort_snprintf(struct hist_entry *self, char *bf, size_t size,
+			      struct hists *hists);
 void hist_entry__free(struct hist_entry *);
 
 struct hist_entry *__hists__add_branch_entry(struct hists *self,
-- 
1.7.11.2

