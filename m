Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab2JDSLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:11:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:39833 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2JDSJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 39/42] perf diff: Removing the total_period argument from output code
Date: Thu,  4 Oct 2012 15:08:39 -0300
Message-Id: <1349374122-27806-40-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The total_period is available in struct hists data via the 'struct
hist_entry::hists' pointer. There's no need to carry it through the
output code path.

Removing 'struct perf_hpp::total_period' pointer, because it's no longer
needed.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1349354994-17853-7-git-send-email-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c |    4 ++--
 tools/perf/ui/gtk/browser.c    |    4 ++--
 tools/perf/ui/hist.c           |   37 ++++++++++++++++++++++++++-----------
 tools/perf/ui/stdio/hist.c     |   15 +++++----------
 tools/perf/util/hist.h         |    1 -
 5 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index bbd11c2..d359795 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -569,7 +569,8 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 static int hist_browser__hpp_color_ ## _name(struct perf_hpp *hpp,	\
 					     struct hist_entry *he)	\
 {									\
-	double percent = 100.0 * he->_field / hpp->total_period;	\
+	struct hists *hists = he->hists;				\
+	double percent = 100.0 * he->_field / hists->stats.total_period;\
 	*(double *)hpp->ptr = percent;					\
 	return scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);	\
 }
@@ -624,7 +625,6 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 		struct perf_hpp hpp = {
 			.buf		= s,
 			.size		= sizeof(s),
-			.total_period	= browser->hists->stats.total_period,
 		};
 
 		ui_browser__gotorc(&browser->b, row, 0);
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 2bc08f6..3cbb1d6 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -49,7 +49,8 @@ static const char *perf_gtk__get_percent_color(double percent)
 static int perf_gtk__hpp_color_ ## _name(struct perf_hpp *hpp,			\
 					 struct hist_entry *he)			\
 {										\
-	double percent = 100.0 * he->_field / hpp->total_period;		\
+	struct hists *hists = he->hists;					\
+	double percent = 100.0 * he->_field / hists->stats.total_period;	\
 	const char *markup;							\
 	int ret = 0;								\
 										\
@@ -102,7 +103,6 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 	struct perf_hpp hpp = {
 		.buf		= s,
 		.size		= sizeof(s),
-		.total_period	= hists->stats.total_period,
 	};
 
 	nr_cols = 0;
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index e8853f7..7f04339 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -18,14 +18,16 @@ static int hpp__width_overhead(struct perf_hpp *hpp __maybe_unused)
 
 static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	double percent = 100.0 * he->period / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->period / hists->stats.total_period;
 
 	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
 }
 
 static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	double percent = 100.0 * he->period / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->period / hists->stats.total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
@@ -45,13 +47,16 @@ static int hpp__width_overhead_sys(struct perf_hpp *hpp __maybe_unused)
 
 static int hpp__color_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	double percent = 100.0 * he->period_sys / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->period_sys / hists->stats.total_period;
+
 	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
 }
 
 static int hpp__entry_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	double percent = 100.0 * he->period_sys / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->period_sys / hists->stats.total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%6.2f%%";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
@@ -71,13 +76,16 @@ static int hpp__width_overhead_us(struct perf_hpp *hpp __maybe_unused)
 
 static int hpp__color_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	double percent = 100.0 * he->period_us / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->period_us / hists->stats.total_period;
+
 	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
 }
 
 static int hpp__entry_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
 {
-	double percent = 100.0 * he->period_us / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->period_us / hists->stats.total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%6.2f%%";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
@@ -96,14 +104,17 @@ static int hpp__width_overhead_guest_sys(struct perf_hpp *hpp __maybe_unused)
 static int hpp__color_overhead_guest_sys(struct perf_hpp *hpp,
 					 struct hist_entry *he)
 {
-	double percent = 100.0 * he->period_guest_sys / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->period_guest_sys / hists->stats.total_period;
+
 	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
 }
 
 static int hpp__entry_overhead_guest_sys(struct perf_hpp *hpp,
 					 struct hist_entry *he)
 {
-	double percent = 100.0 * he->period_guest_sys / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->period_guest_sys / hists->stats.total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%% ";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
@@ -122,14 +133,17 @@ static int hpp__width_overhead_guest_us(struct perf_hpp *hpp __maybe_unused)
 static int hpp__color_overhead_guest_us(struct perf_hpp *hpp,
 					struct hist_entry *he)
 {
-	double percent = 100.0 * he->period_guest_us / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->period_guest_us / hists->stats.total_period;
+
 	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
 }
 
 static int hpp__entry_overhead_guest_us(struct perf_hpp *hpp,
 					struct hist_entry *he)
 {
-	double percent = 100.0 * he->period_guest_us / hpp->total_period;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->period_guest_us / hists->stats.total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%% ";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
@@ -230,6 +244,7 @@ static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hist_entry *pair = he->pair;
 	struct hists *pair_hists = pair ? pair->hists : NULL;
+	struct hists *hists = he->hists;
 	u64 old_total, new_total;
 	double old_percent = 0, new_percent = 0;
 	double diff;
@@ -240,7 +255,7 @@ static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
 	if (old_total > 0 && pair)
 		old_percent = 100.0 * pair->period / old_total;
 
-	new_total = hpp->total_period;
+	new_total = hists->stats.total_period;
 	if (new_total > 0)
 		new_percent = 100.0 * he->period / new_total;
 
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 1340c93..850c6d2 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -292,9 +292,10 @@ static size_t hist_entry_callchain__fprintf(struct hist_entry *he,
 
 static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
 					    struct hists *hists,
-					    u64 total_period, FILE *fp)
+					    FILE *fp)
 {
 	int left_margin = 0;
+	u64 total_period = hists->stats.total_period;
 
 	if (sort__first_dimension == SORT_COMM) {
 		struct sort_entry *se = list_first_entry(&hist_entry__sort_list,
@@ -307,14 +308,13 @@ static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
 }
 
 static int hist_entry__fprintf(struct hist_entry *he, size_t size,
-			       struct hists *hists, u64 total_period, FILE *fp)
+			       struct hists *hists, FILE *fp)
 {
 	char bf[512];
 	int ret;
 	struct perf_hpp hpp = {
 		.buf		= bf,
 		.size		= size,
-		.total_period	= total_period,
 	};
 	bool color = !symbol_conf.field_sep;
 
@@ -327,8 +327,7 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 	ret = fprintf(fp, "%s\n", bf);
 
 	if (symbol_conf.use_callchain)
-		ret += hist_entry__callchain_fprintf(he, hists,
-						     total_period, fp);
+		ret += hist_entry__callchain_fprintf(he, hists, fp);
 
 	return ret;
 }
@@ -339,7 +338,6 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	struct sort_entry *se;
 	struct rb_node *nd;
 	size_t ret = 0;
-	u64 total_period;
 	unsigned int width;
 	const char *sep = symbol_conf.field_sep;
 	const char *col_width = symbol_conf.col_width_list_str;
@@ -441,16 +439,13 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		goto out;
 
 print_entries:
-	total_period = hists->stats.total_period;
-
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
 		if (h->filtered)
 			continue;
 
-		ret += hist_entry__fprintf(h, max_cols, hists,
-					   total_period, fp);
+		ret += hist_entry__fprintf(h, max_cols, hists, fp);
 
 		if (max_rows && ++nr_rows >= max_rows)
 			goto out;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a7f69d6..66cb31f 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -117,7 +117,6 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *he);
 struct perf_hpp {
 	char *buf;
 	size_t size;
-	u64 total_period;
 	const char *sep;
 	void *ptr;
 };
-- 
1.7.1

