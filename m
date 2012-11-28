Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab2K1Nxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:53:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109Ab2K1Nxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:53:48 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 02/14] perf tool: Add struct perf_hpp_fmt into hpp callbacks
Date: Wed, 28 Nov 2012 14:52:37 +0100
Message-Id: <1354110769-2998-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding 'struct perf_hpp_fmt' into hpp callbacks, so commands
can access their private data.

It'll be handy for diff command in future to be able to access
file related data for each column.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c |  10 ++-
 tools/perf/ui/hist.c           | 169 +++++++++++++++++++++++++++--------------
 tools/perf/ui/stdio/hist.c     |   4 +-
 tools/perf/util/hist.h         |  10 ++-
 4 files changed, 127 insertions(+), 66 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 96fdbc8..4e06ba5 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -568,8 +568,10 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 }
 
 #define HPP__COLOR_FN(_name, _field)					\
-static int hist_browser__hpp_color_ ## _name(struct perf_hpp *hpp,	\
-					     struct hist_entry *he)	\
+static int hist_browser__hpp_color_ ## _name(				\
+			struct perf_hpp_fmt *fmt __maybe_unused,	\
+			struct perf_hpp *hpp,				\
+			struct hist_entry *he)				\
 {									\
 	struct hists *hists = he->hists;				\
 	double percent = 100.0 * he->stat._field / hists->stats.total_period; \
@@ -647,7 +649,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			if (fmt->color) {
 				hpp.ptr = &percent;
 				/* It will set percent for us. See HPP__COLOR_FN above. */
-				width -= fmt->color(&hpp, entry);
+				width -= fmt->color(fmt, &hpp, entry);
 
 				ui_browser__set_percent_color(&browser->b, percent, current_entry);
 
@@ -661,7 +663,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 				if (!current_entry || !browser->b.navkeypressed)
 					ui_browser__set_color(&browser->b, HE_COLORSET_NORMAL);
 			} else {
-				width -= fmt->entry(&hpp, entry);
+				width -= fmt->entry(fmt, &hpp, entry);
 				slsmg_printf("%s", s);
 			}
 
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 0a5281f..5452960 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -6,17 +6,20 @@
 
 
 /* hist period print (hpp) functions */
-static int hpp__header_overhead(struct perf_hpp *hpp)
+static int hpp__header_overhead(struct perf_hpp_fmt *fmt __maybe_unused,
+				struct perf_hpp *hpp)
 {
 	return scnprintf(hpp->buf, hpp->size, "Overhead");
 }
 
-static int hpp__width_overhead(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_overhead(struct perf_hpp_fmt *fmt __maybe_unused,
+			       struct perf_hpp *hpp __maybe_unused)
 {
 	return 8;
 }
 
-static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__color_overhead(struct perf_hpp_fmt *fmt __maybe_unused,
+			       struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
 	double percent = 100.0 * he->stat.period / hists->stats.total_period;
@@ -24,7 +27,8 @@ static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
 }
 
-static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__entry_overhead(struct perf_hpp_fmt *_fmt __maybe_unused,
+			       struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
 	double percent = 100.0 * he->stat.period / hists->stats.total_period;
@@ -33,19 +37,22 @@ static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
-static int hpp__header_overhead_sys(struct perf_hpp *hpp)
+static int hpp__header_overhead_sys(struct perf_hpp_fmt *_fmt __maybe_unused,
+				    struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, "sys");
 }
 
-static int hpp__width_overhead_sys(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_overhead_sys(struct perf_hpp_fmt *fmt __maybe_unused,
+				   struct perf_hpp *hpp __maybe_unused)
 {
 	return 7;
 }
 
-static int hpp__color_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__color_overhead_sys(struct perf_hpp_fmt *fmt __maybe_unused,
+				   struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
 	double percent = 100.0 * he->stat.period_sys / hists->stats.total_period;
@@ -53,7 +60,8 @@ static int hpp__color_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
 	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
 }
 
-static int hpp__entry_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__entry_overhead_sys(struct perf_hpp_fmt *_fmt __maybe_unused,
+				   struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
 	double percent = 100.0 * he->stat.period_sys / hists->stats.total_period;
@@ -62,19 +70,22 @@ static int hpp__entry_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
-static int hpp__header_overhead_us(struct perf_hpp *hpp)
+static int hpp__header_overhead_us(struct perf_hpp_fmt *_fmt __maybe_unused,
+				   struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, "user");
 }
 
-static int hpp__width_overhead_us(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_overhead_us(struct perf_hpp_fmt *fmt __maybe_unused,
+				  struct perf_hpp *hpp __maybe_unused)
 {
 	return 7;
 }
 
-static int hpp__color_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__color_overhead_us(struct perf_hpp_fmt *fmt __maybe_unused,
+				  struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
 	double percent = 100.0 * he->stat.period_us / hists->stats.total_period;
@@ -82,7 +93,8 @@ static int hpp__color_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
 	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
 }
 
-static int hpp__entry_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__entry_overhead_us(struct perf_hpp_fmt *_fmt __maybe_unused,
+				  struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
 	double percent = 100.0 * he->stat.period_us / hists->stats.total_period;
@@ -91,18 +103,24 @@ static int hpp__entry_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
-static int hpp__header_overhead_guest_sys(struct perf_hpp *hpp)
+static int
+hpp__header_overhead_guest_sys(struct perf_hpp_fmt *fmt __maybe_unused,
+			       struct perf_hpp *hpp)
 {
 	return scnprintf(hpp->buf, hpp->size, "guest sys");
 }
 
-static int hpp__width_overhead_guest_sys(struct perf_hpp *hpp __maybe_unused)
+static int
+hpp__width_overhead_guest_sys(struct perf_hpp_fmt *fmt __maybe_unused,
+			      struct perf_hpp *hpp __maybe_unused)
 {
 	return 9;
 }
 
-static int hpp__color_overhead_guest_sys(struct perf_hpp *hpp,
-					 struct hist_entry *he)
+static int
+hpp__color_overhead_guest_sys(struct perf_hpp_fmt *fmt __maybe_unused,
+			      struct perf_hpp *hpp,
+			      struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
 	double percent = 100.0 * he->stat.period_guest_sys / hists->stats.total_period;
@@ -110,8 +128,10 @@ static int hpp__color_overhead_guest_sys(struct perf_hpp *hpp,
 	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
 }
 
-static int hpp__entry_overhead_guest_sys(struct perf_hpp *hpp,
-					 struct hist_entry *he)
+static int
+hpp__entry_overhead_guest_sys(struct perf_hpp_fmt *_fmt __maybe_unused,
+			      struct perf_hpp *hpp,
+			      struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
 	double percent = 100.0 * he->stat.period_guest_sys / hists->stats.total_period;
@@ -120,18 +140,24 @@ static int hpp__entry_overhead_guest_sys(struct perf_hpp *hpp,
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
-static int hpp__header_overhead_guest_us(struct perf_hpp *hpp)
+static int
+hpp__header_overhead_guest_us(struct perf_hpp_fmt *fmt __maybe_unused,
+			      struct perf_hpp *hpp)
 {
 	return scnprintf(hpp->buf, hpp->size, "guest usr");
 }
 
-static int hpp__width_overhead_guest_us(struct perf_hpp *hpp __maybe_unused)
+static int
+hpp__width_overhead_guest_us(struct perf_hpp_fmt *fmt __maybe_unused,
+			     struct perf_hpp *hpp __maybe_unused)
 {
 	return 9;
 }
 
-static int hpp__color_overhead_guest_us(struct perf_hpp *hpp,
-					struct hist_entry *he)
+static int
+hpp__color_overhead_guest_us(struct perf_hpp_fmt *fmt __maybe_unused,
+			     struct perf_hpp *hpp,
+			     struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
 	double percent = 100.0 * he->stat.period_guest_us / hists->stats.total_period;
@@ -139,8 +165,10 @@ static int hpp__color_overhead_guest_us(struct perf_hpp *hpp,
 	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
 }
 
-static int hpp__entry_overhead_guest_us(struct perf_hpp *hpp,
-					struct hist_entry *he)
+static int
+hpp__entry_overhead_guest_us(struct perf_hpp_fmt *_fmt __maybe_unused,
+			     struct perf_hpp *hpp,
+			     struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
 	double percent = 100.0 * he->stat.period_guest_us / hists->stats.total_period;
@@ -149,12 +177,14 @@ static int hpp__entry_overhead_guest_us(struct perf_hpp *hpp,
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
-static int hpp__header_baseline(struct perf_hpp *hpp)
+static int hpp__header_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
+				struct perf_hpp *hpp)
 {
 	return scnprintf(hpp->buf, hpp->size, "Baseline");
 }
 
-static int hpp__width_baseline(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
+			       struct perf_hpp *hpp __maybe_unused)
 {
 	return 8;
 }
@@ -175,7 +205,8 @@ static double baseline_percent(struct hist_entry *he)
 	return percent;
 }
 
-static int hpp__color_baseline(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__color_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
+			       struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = baseline_percent(he);
 
@@ -185,7 +216,8 @@ static int hpp__color_baseline(struct perf_hpp *hpp, struct hist_entry *he)
 		return scnprintf(hpp->buf, hpp->size, "        ");
 }
 
-static int hpp__entry_baseline(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__entry_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
+			       struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = baseline_percent(he);
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
@@ -196,57 +228,67 @@ static int hpp__entry_baseline(struct perf_hpp *hpp, struct hist_entry *he)
 		return scnprintf(hpp->buf, hpp->size, "            ");
 }
 
-static int hpp__header_samples(struct perf_hpp *hpp)
+static int hpp__header_samples(struct perf_hpp_fmt *_fmt __maybe_unused,
+			       struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%11s";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, "Samples");
 }
 
-static int hpp__width_samples(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_samples(struct perf_hpp_fmt *fmt __maybe_unused,
+			      struct perf_hpp *hpp __maybe_unused)
 {
 	return 11;
 }
 
-static int hpp__entry_samples(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__entry_samples(struct perf_hpp_fmt *_fmt __maybe_unused,
+			      struct perf_hpp *hpp, struct hist_entry *he)
 {
 	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%11" PRIu64;
 
 	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.nr_events);
 }
 
-static int hpp__header_period(struct perf_hpp *hpp)
+static int hpp__header_period(struct perf_hpp_fmt *_fmt __maybe_unused,
+			      struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%12s";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, "Period");
 }
 
-static int hpp__width_period(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_period(struct perf_hpp_fmt *fmt __maybe_unused,
+			     struct perf_hpp *hpp __maybe_unused)
 {
 	return 12;
 }
 
-static int hpp__entry_period(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__entry_period(struct perf_hpp_fmt *_fmt __maybe_unused,
+			     struct perf_hpp *hpp, struct hist_entry *he)
 {
 	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%12" PRIu64;
 
 	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.period);
 }
 
-static int hpp__header_period_baseline(struct perf_hpp *hpp)
+static int hpp__header_period_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
+				       struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%12s";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, "Period Base");
 }
 
-static int hpp__width_period_baseline(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_period_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
+				      struct perf_hpp *hpp __maybe_unused)
 {
 	return 12;
 }
 
-static int hpp__entry_period_baseline(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__entry_period_baseline(struct perf_hpp_fmt *_fmt __maybe_unused,
+				      struct perf_hpp *hpp,
+				      struct hist_entry *he)
 {
 	struct hist_entry *pair = hist_entry__next_pair(he);
 	u64 period = pair ? pair->stat.period : 0;
@@ -254,19 +296,23 @@ static int hpp__entry_period_baseline(struct perf_hpp *hpp, struct hist_entry *h
 
 	return scnprintf(hpp->buf, hpp->size, fmt, period);
 }
-static int hpp__header_delta(struct perf_hpp *hpp)
+
+static int hpp__header_delta(struct perf_hpp_fmt *_fmt __maybe_unused,
+			     struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, "Delta");
 }
 
-static int hpp__width_delta(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_delta(struct perf_hpp_fmt *fmt __maybe_unused,
+			    struct perf_hpp *hpp __maybe_unused)
 {
 	return 7;
 }
 
-static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__entry_delta(struct perf_hpp_fmt *_fmt __maybe_unused,
+			    struct perf_hpp *hpp, struct hist_entry *he)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%7.7s";
 	char buf[32] = " ";
@@ -283,19 +329,22 @@ static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
-static int hpp__header_ratio(struct perf_hpp *hpp)
+static int hpp__header_ratio(struct perf_hpp_fmt *_fmt __maybe_unused,
+			     struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, "Ratio");
 }
 
-static int hpp__width_ratio(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_ratio(struct perf_hpp_fmt *_fmt __maybe_unused,
+			    struct perf_hpp *hpp __maybe_unused)
 {
 	return 14;
 }
 
-static int hpp__entry_ratio(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__entry_ratio(struct perf_hpp_fmt *_fmt __maybe_unused,
+			    struct perf_hpp *hpp, struct hist_entry *he)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
 	char buf[32] = " ";
@@ -312,19 +361,22 @@ static int hpp__entry_ratio(struct perf_hpp *hpp, struct hist_entry *he)
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
-static int hpp__header_wdiff(struct perf_hpp *hpp)
+static int hpp__header_wdiff(struct perf_hpp_fmt *_fmt __maybe_unused,
+			     struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, "Weighted diff");
 }
 
-static int hpp__width_wdiff(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_wdiff(struct perf_hpp_fmt *fmt __maybe_unused,
+			    struct perf_hpp *hpp __maybe_unused)
 {
 	return 14;
 }
 
-static int hpp__entry_wdiff(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__entry_wdiff(struct perf_hpp_fmt *_fmt __maybe_unused,
+			    struct perf_hpp *hpp, struct hist_entry *he)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
 	char buf[32] = " ";
@@ -341,18 +393,20 @@ static int hpp__entry_wdiff(struct perf_hpp *hpp, struct hist_entry *he)
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
-static int hpp__header_displ(struct perf_hpp *hpp)
+static int hpp__header_displ(struct perf_hpp_fmt *_fmt __maybe_unused,
+			     struct perf_hpp *hpp)
 {
 	return scnprintf(hpp->buf, hpp->size, "Displ.");
 }
 
-static int hpp__width_displ(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_displ(struct perf_hpp_fmt *fmt __maybe_unused,
+			    struct perf_hpp *hpp __maybe_unused)
 {
 	return 6;
 }
 
-static int hpp__entry_displ(struct perf_hpp *hpp,
-			    struct hist_entry *he)
+static int hpp__entry_displ(struct perf_hpp_fmt *_fmt __maybe_unused,
+			    struct perf_hpp *hpp, struct hist_entry *he)
 {
 	struct hist_entry *pair = hist_entry__next_pair(he);
 	long displacement = pair ? pair->position - he->position : 0;
@@ -365,19 +419,22 @@ static int hpp__entry_displ(struct perf_hpp *hpp,
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
-static int hpp__header_formula(struct perf_hpp *hpp)
+static int hpp__header_formula(struct perf_hpp_fmt *_fmt __maybe_unused,
+			       struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%70s";
 
 	return scnprintf(hpp->buf, hpp->size, fmt, "Formula");
 }
 
-static int hpp__width_formula(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_formula(struct perf_hpp_fmt *fmt __maybe_unused,
+			      struct perf_hpp *hpp __maybe_unused)
 {
 	return 70;
 }
 
-static int hpp__entry_formula(struct perf_hpp *hpp, struct hist_entry *he)
+static int hpp__entry_formula(struct perf_hpp_fmt *_fmt __maybe_unused,
+			      struct perf_hpp *hpp, struct hist_entry *he)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%-70s";
 	char buf[96] = " ";
@@ -479,9 +536,9 @@ int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
 		}
 
 		if (color && fmt->color)
-			ret = fmt->color(hpp, he);
+			ret = fmt->color(fmt, hpp, he);
 		else
-			ret = fmt->entry(hpp, he);
+			ret = fmt->entry(fmt, hpp, he);
 
 		advance_hpp(hpp, ret);
 	}
@@ -521,7 +578,7 @@ unsigned int hists__sort_list_width(struct hists *hists)
 		if (i)
 			ret += 2;
 
-		ret += fmt->width(NULL);
+		ret += fmt->width(fmt, NULL);
 	}
 
 	list_for_each_entry(se, &hist_entry__sort_list, list)
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 0eae3b2..531bc7a 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -363,7 +363,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		else
 			first = false;
 
-		fmt->header(&dummy_hpp);
+		fmt->header(fmt, &dummy_hpp);
 		fprintf(fp, "%s", bf);
 	}
 
@@ -408,7 +408,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		else
 			first = false;
 
-		width = fmt->width(&dummy_hpp);
+		width = fmt->width(fmt, &dummy_hpp);
 		for (i = 0; i < width; i++)
 			fprintf(fp, ".");
 	}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a935a60..e899e2d 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -126,10 +126,12 @@ struct perf_hpp {
 };
 
 struct perf_hpp_fmt {
-	int (*header)(struct perf_hpp *hpp);
-	int (*width)(struct perf_hpp *hpp);
-	int (*color)(struct perf_hpp *hpp, struct hist_entry *he);
-	int (*entry)(struct perf_hpp *hpp, struct hist_entry *he);
+	int (*header)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp);
+	int (*width)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp);
+	int (*color)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+		     struct hist_entry *he);
+	int (*entry)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+		     struct hist_entry *he);
 
 	struct list_head list;
 };
-- 
1.7.11.7

