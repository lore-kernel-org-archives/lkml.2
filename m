Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2GSPoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 11:44:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33560 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab2GSPn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 11:43:58 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/5] perf tools: Refactor some functions
Date: Fri, 20 Jul 2012 00:42:35 +0900
Message-Id: <1342712558-8185-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1342712558-8185-1-git-send-email-namhyung@kernel.org>
References: <1342712558-8185-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Rename functions for inconsistency and move callchain print function
into hist_entry__fprintf().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c |    4 +--
 tools/perf/ui/hist.c           |   65 +++++++++++++++++++++-------------------
 tools/perf/util/hist.h         |    4 +--
 3 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 482f0517b61e..c58f9bb15038 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -576,7 +576,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 	}
 
 	if (row_offset == 0) {
-		hist_entry__snprintf(entry, s, sizeof(s), browser->hists);
+		hist_entry__sort_snprintf(entry, s, sizeof(s), browser->hists);
 		percent = (entry->period * 100.0) / browser->hists->stats.total_period;
 
 		ui_browser__set_percent_color(&browser->b, percent, current_entry);
@@ -920,7 +920,7 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 	if (symbol_conf.use_callchain)
 		folded_sign = hist_entry__folded(he);
 
-	hist_entry__snprintf(he, s, sizeof(s), browser->hists);
+	hist_entry__sort_snprintf(he, s, sizeof(s), browser->hists);
 	percent = (he->period * 100.0) / browser->hists->stats.total_period;
 
 	if (symbol_conf.use_callchain)
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index e87e4f72664c..c0649f5dc9b4 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -262,9 +262,9 @@ static size_t callchain__fprintf_flat(FILE *fp, struct rb_root *self,
 	return ret;
 }
 
-static size_t hist_entry_callchain__fprintf(struct hist_entry *he,
-					    u64 total_samples, int left_margin,
-					    FILE *fp)
+static size_t callchain__fprintf(struct hist_entry *he,
+				 u64 total_samples, int left_margin,
+				 FILE *fp)
 {
 	switch (callchain_param.mode) {
 	case CHAIN_GRAPH_REL:
@@ -287,10 +287,10 @@ static size_t hist_entry_callchain__fprintf(struct hist_entry *he,
 	return 0;
 }
 
-static int hist_entry__pcnt_snprintf(struct hist_entry *he, char *s,
-				     size_t size, struct hists *pair_hists,
-				     bool show_displacement, long displacement,
-				     bool color, u64 total_period)
+static int hist_entry__period_snprintf(struct hist_entry *he, char *s,
+				       size_t size, struct hists *pair_hists,
+				       bool show_displacement, long displacement,
+				       bool color, u64 total_period)
 {
 	u64 period, total, period_sys, period_us, period_guest_sys, period_guest_us;
 	u64 nr_events;
@@ -400,8 +400,8 @@ static int hist_entry__pcnt_snprintf(struct hist_entry *he, char *s,
 	return ret;
 }
 
-int hist_entry__snprintf(struct hist_entry *he, char *s, size_t size,
-			 struct hists *hists)
+int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
+			      struct hists *hists)
 {
 	const char *sep = symbol_conf.field_sep;
 	struct sort_entry *se;
@@ -419,25 +419,7 @@ int hist_entry__snprintf(struct hist_entry *he, char *s, size_t size,
 	return ret;
 }
 
-static int hist_entry__fprintf(struct hist_entry *he, size_t size,
-			       struct hists *hists, struct hists *pair_hists,
-			       bool show_displacement, long displacement,
-			       u64 total_period, FILE *fp)
-{
-	char bf[512];
-	int ret;
-
-	if (size == 0 || size > sizeof(bf))
-		size = sizeof(bf);
-
-	ret = hist_entry__pcnt_snprintf(he, bf, size, pair_hists,
-					show_displacement, displacement,
-					true, total_period);
-	hist_entry__snprintf(he, bf + ret, size - ret, hists);
-	return fprintf(fp, "%s\n", bf);
-}
-
-static size_t hist_entry__fprintf_callchain(struct hist_entry *he,
+static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
 					    struct hists *hists,
 					    u64 total_period, FILE *fp)
 {
@@ -450,7 +432,30 @@ static size_t hist_entry__fprintf_callchain(struct hist_entry *he,
 		left_margin -= thread__comm_len(he->thread);
 	}
 
-	return hist_entry_callchain__fprintf(he, total_period, left_margin, fp);
+	return callchain__fprintf(he, total_period, left_margin, fp);
+}
+
+static int hist_entry__fprintf(struct hist_entry *he, size_t size,
+			       struct hists *hists, struct hists *pair_hists,
+			       bool show_displacement, long displacement,
+			       u64 total_period, FILE *fp)
+{
+	char bf[512];
+	int ret;
+
+	if (size == 0 || size > sizeof(bf))
+		size = sizeof(bf);
+
+	ret = hist_entry__period_snprintf(he, bf, size, pair_hists,
+					  show_displacement, displacement,
+					  true, total_period);
+	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
+	ret = fprintf(fp, "%s\n", bf);
+
+	if (symbol_conf.use_callchain)
+		ret += hist_entry__callchain_fprintf(he, hists,
+						     total_period, fp);
+	return ret;
 }
 
 size_t hists__fprintf(struct hists *hists, struct hists *pair,
@@ -604,8 +609,6 @@ print_entries:
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
1.7.9.2

