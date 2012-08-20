Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab2HTQaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:30:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56355 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab2HTQ0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:43 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/24] perf hists: Rename and move some functions
Date: Mon, 20 Aug 2012 13:26:25 -0300
Message-Id: <1345479985-18669-25-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345479985-18669-1-git-send-email-acme@infradead.org>
References: <1345479985-18669-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Rename functions for consistency and move callchain print function
into hist_entry__fprintf().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1345438331-20234-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c |    4 +-
 tools/perf/ui/stdio/hist.c     |   51 ++++++++++++++++++++++------------------
 tools/perf/util/hist.h         |    4 +-
 3 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index b809469..81bd8c2 100644
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
index 7881d62..9bf7e9e 100644
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
index 69fab7d..2e650ff 100644
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
1.7.1

