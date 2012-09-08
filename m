Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab2IHUiN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 16:38:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:52467 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab2IHUhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 16:37:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/9] perf hists: Introduce perf_hpp for hist period printing
Date: Sat,  8 Sep 2012 17:36:47 -0300
Message-Id: <1347136614-25598-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347136614-25598-1-git-send-email-acme@infradead.org>
References: <1347136614-25598-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Current hist print functions are messy because it has to consider many
of command line options and the code doing that is scattered around to
places. So when someone wants to add an option to manipulate the hist
output it'd very easy to miss to update all of them in sync. And things
getting worse as more options/features are added continuously.

So I'd like to refactor them using hpp formats and move common code to
ui/hist.c in order to make it easy to maintain and to add new features.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346640790-17197-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        |    2 +
 tools/perf/builtin-diff.c  |    1 +
 tools/perf/ui/hist.c       |  340 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/ui/setup.c      |    8 +-
 tools/perf/ui/stdio/hist.c |  238 ++++++-------------------------
 tools/perf/util/hist.h     |   37 +++++
 6 files changed, 426 insertions(+), 200 deletions(-)
 create mode 100644 tools/perf/ui/hist.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3eda492..e4b2e8f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -403,7 +403,9 @@ LIB_OBJS += $(OUTPUT)util/cgroup.o
 LIB_OBJS += $(OUTPUT)util/target.o
 LIB_OBJS += $(OUTPUT)util/rblist.o
 LIB_OBJS += $(OUTPUT)util/intlist.o
+
 LIB_OBJS += $(OUTPUT)ui/helpline.o
+LIB_OBJS += $(OUTPUT)ui/hist.o
 LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index e9933fd..c4c6d76 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -264,6 +264,7 @@ int cmd_diff(int argc, const char **argv, const char *prefix __used)
 	if (symbol__init() < 0)
 		return -1;
 
+	perf_hpp__init(true, show_displacement);
 	setup_sorting(diff_usage, options);
 	setup_pager();
 
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
new file mode 100644
index 0000000..8ccd1f2
--- /dev/null
+++ b/tools/perf/ui/hist.c
@@ -0,0 +1,340 @@
+#include <math.h>
+
+#include "../util/hist.h"
+#include "../util/util.h"
+#include "../util/sort.h"
+
+
+/* hist period print (hpp) functions */
+static int hpp__header_overhead(struct perf_hpp *hpp)
+{
+	if (hpp->ptr)
+		return scnprintf(hpp->buf, hpp->size, "Baseline");
+	else
+		return scnprintf(hpp->buf, hpp->size, "Overhead");
+}
+
+static int hpp__width_overhead(struct perf_hpp *hpp __used)
+{
+	return 8;
+}
+
+static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	double percent = 100.0 * he->period / hpp->total_period;
+
+	if (hpp->ptr) {
+		struct hists *old_hists = hpp->ptr;
+		u64 total_period = old_hists->stats.total_period;
+		u64 base_period = he->pair ? he->pair->period : 0;
+
+		if (total_period)
+			percent = 100.0 * base_period / total_period;
+		else
+			percent = 0.0;
+	}
+
+	return percent_color_snprintf(hpp->buf, hpp->size, "  %5.2f%%", percent);
+}
+
+static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	double percent = 100.0 * he->period / hpp->total_period;
+
+	if (hpp->ptr) {
+		struct hists *old_hists = hpp->ptr;
+		u64 total_period = old_hists->stats.total_period;
+		u64 base_period = he->pair ? he->pair->period : 0;
+
+		if (total_period)
+			percent = 100.0 * base_period / total_period;
+		else
+			percent = 0.0;
+	}
+
+	return scnprintf(hpp->buf, hpp->size, "  %5.2f%%", percent);
+}
+
+static int hpp__header_overhead_sys(struct perf_hpp *hpp)
+{
+	return scnprintf(hpp->buf, hpp->size, " sys  ");
+}
+
+static int hpp__width_overhead_sys(struct perf_hpp *hpp __used)
+{
+	return 6;
+}
+
+static int hpp__color_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	double percent = 100.0 * he->period_sys / hpp->total_period;
+	return percent_color_snprintf(hpp->buf, hpp->size, "%5.2f%%", percent);
+}
+
+static int hpp__entry_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	double percent = 100.0 * he->period_sys / hpp->total_period;
+	return scnprintf(hpp->buf, hpp->size, "%5.2f%%", percent);
+}
+
+static int hpp__header_overhead_us(struct perf_hpp *hpp)
+{
+	return scnprintf(hpp->buf, hpp->size, " user ");
+}
+
+static int hpp__width_overhead_us(struct perf_hpp *hpp __used)
+{
+	return 6;
+}
+
+static int hpp__color_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	double percent = 100.0 * he->period_us / hpp->total_period;
+	return percent_color_snprintf(hpp->buf, hpp->size, "%5.2f%%", percent);
+}
+
+static int hpp__entry_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	double percent = 100.0 * he->period_us / hpp->total_period;
+	return scnprintf(hpp->buf, hpp->size, "%5.2f%%", percent);
+}
+
+static int hpp__header_overhead_guest_sys(struct perf_hpp *hpp)
+{
+	return scnprintf(hpp->buf, hpp->size, "guest sys");
+}
+
+static int hpp__width_overhead_guest_sys(struct perf_hpp *hpp __used)
+{
+	return 9;
+}
+
+static int hpp__color_overhead_guest_sys(struct perf_hpp *hpp,
+					 struct hist_entry *he)
+{
+	double percent = 100.0 * he->period_guest_sys / hpp->total_period;
+	return percent_color_snprintf(hpp->buf, hpp->size, "  %5.2f%% ", percent);
+}
+
+static int hpp__entry_overhead_guest_sys(struct perf_hpp *hpp,
+					 struct hist_entry *he)
+{
+	double percent = 100.0 * he->period_guest_sys / hpp->total_period;
+	return scnprintf(hpp->buf, hpp->size, "  %5.2f%% ", percent);
+}
+
+static int hpp__header_overhead_guest_us(struct perf_hpp *hpp)
+{
+	return scnprintf(hpp->buf, hpp->size, "guest usr");
+}
+
+static int hpp__width_overhead_guest_us(struct perf_hpp *hpp __used)
+{
+	return 9;
+}
+
+static int hpp__color_overhead_guest_us(struct perf_hpp *hpp,
+					struct hist_entry *he)
+{
+	double percent = 100.0 * he->period_guest_us / hpp->total_period;
+	return percent_color_snprintf(hpp->buf, hpp->size, "  %5.2f%% ", percent);
+}
+
+static int hpp__entry_overhead_guest_us(struct perf_hpp *hpp,
+					struct hist_entry *he)
+{
+	double percent = 100.0 * he->period_guest_us / hpp->total_period;
+	return scnprintf(hpp->buf, hpp->size, "  %5.2f%% ", percent);
+}
+
+static int hpp__header_samples(struct perf_hpp *hpp)
+{
+	return scnprintf(hpp->buf, hpp->size, "  Samples  ");
+}
+
+static int hpp__width_samples(struct perf_hpp *hpp __used)
+{
+	return 11;
+}
+
+static int hpp__entry_samples(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	return scnprintf(hpp->buf, hpp->size, "%11" PRIu64, he->nr_events);
+}
+
+static int hpp__header_period(struct perf_hpp *hpp)
+{
+	return scnprintf(hpp->buf, hpp->size, "   Period   ");
+}
+
+static int hpp__width_period(struct perf_hpp *hpp __used)
+{
+	return 12;
+}
+
+static int hpp__entry_period(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	return scnprintf(hpp->buf, hpp->size, "%12" PRIu64, he->period);
+}
+
+static int hpp__header_delta(struct perf_hpp *hpp)
+{
+	return scnprintf(hpp->buf, hpp->size, " Delta ");
+}
+
+static int hpp__width_delta(struct perf_hpp *hpp __used)
+{
+	return 7;
+}
+
+static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
+{
+	struct hists *pair_hists = hpp->ptr;
+	u64 old_total, new_total;
+	double old_percent = 0, new_percent = 0;
+	double diff;
+	char buf[32];
+
+	old_total = pair_hists->stats.total_period;
+	if (old_total > 0 && he->pair)
+		old_percent = 100.0 * he->pair->period / old_total;
+
+	new_total = hpp->total_period;
+	if (new_total > 0)
+		new_percent = 100.0 * he->period / new_total;
+
+	diff = new_percent - old_percent;
+	if (fabs(diff) < 0.01)
+		return scnprintf(hpp->buf, hpp->size, "       ");
+
+	scnprintf(buf, sizeof(buf), "%+4.2F%%", diff);
+	return scnprintf(hpp->buf, hpp->size, "%7.7s", buf);
+}
+
+static int hpp__header_displ(struct perf_hpp *hpp)
+{
+	return scnprintf(hpp->buf, hpp->size, "Displ.");
+}
+
+static int hpp__width_displ(struct perf_hpp *hpp __used)
+{
+	return 6;
+}
+
+static int hpp__entry_displ(struct perf_hpp *hpp, struct hist_entry *he __used)
+{
+	char buf[32];
+
+	if (!hpp->displacement)
+		return scnprintf(hpp->buf, hpp->size, "     ");
+
+	scnprintf(buf, sizeof(buf), "%+4ld", hpp->displacement);
+	return scnprintf(hpp->buf, hpp->size, "%6.6s", buf);
+}
+
+#define HPP__COLOR_PRINT_FNS(_name)		\
+	.header	= hpp__header_ ## _name,		\
+	.width	= hpp__width_ ## _name,		\
+	.color	= hpp__color_ ## _name,		\
+	.entry	= hpp__entry_ ## _name
+
+#define HPP__PRINT_FNS(_name)			\
+	.header	= hpp__header_ ## _name,		\
+	.width	= hpp__width_ ## _name,		\
+	.entry	= hpp__entry_ ## _name
+
+struct perf_hpp_fmt perf_hpp__format[] = {
+	{ .cond = true,  HPP__COLOR_PRINT_FNS(overhead) },
+	{ .cond = false, HPP__COLOR_PRINT_FNS(overhead_sys) },
+	{ .cond = false, HPP__COLOR_PRINT_FNS(overhead_us) },
+	{ .cond = false, HPP__COLOR_PRINT_FNS(overhead_guest_sys) },
+	{ .cond = false, HPP__COLOR_PRINT_FNS(overhead_guest_us) },
+	{ .cond = false, HPP__PRINT_FNS(samples) },
+	{ .cond = false, HPP__PRINT_FNS(period) },
+	{ .cond = false, HPP__PRINT_FNS(delta) },
+	{ .cond = false, HPP__PRINT_FNS(displ) }
+};
+
+#undef HPP__COLOR_PRINT_FNS
+#undef HPP__PRINT_FNS
+
+void perf_hpp__init(bool need_pair, bool show_displacement)
+{
+	if (symbol_conf.show_cpu_utilization) {
+		perf_hpp__format[PERF_HPP__OVERHEAD_SYS].cond = true;
+		perf_hpp__format[PERF_HPP__OVERHEAD_US].cond = true;
+
+		if (perf_guest) {
+			perf_hpp__format[PERF_HPP__OVERHEAD_GUEST_SYS].cond = true;
+			perf_hpp__format[PERF_HPP__OVERHEAD_GUEST_US].cond = true;
+		}
+	}
+
+	if (symbol_conf.show_nr_samples)
+		perf_hpp__format[PERF_HPP__SAMPLES].cond = true;
+
+	if (symbol_conf.show_total_period)
+		perf_hpp__format[PERF_HPP__PERIOD].cond = true;
+
+	if (need_pair) {
+		perf_hpp__format[PERF_HPP__DELTA].cond = true;
+
+		if (show_displacement)
+			perf_hpp__format[PERF_HPP__DISPL].cond = true;
+	}
+}
+
+static inline void advance_hpp(struct perf_hpp *hpp, int inc)
+{
+	hpp->buf  += inc;
+	hpp->size -= inc;
+}
+
+int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
+				bool color)
+{
+	const char *sep = symbol_conf.field_sep;
+	char *start = hpp->buf;
+	int i, ret;
+
+	if (symbol_conf.exclude_other && !he->parent)
+		return 0;
+
+	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
+		if (!perf_hpp__format[i].cond)
+			continue;
+
+		if (!sep || i > 0) {
+			ret = scnprintf(hpp->buf, hpp->size, "%s", sep ?: "  ");
+			advance_hpp(hpp, ret);
+		}
+
+		if (color && perf_hpp__format[i].color)
+			ret = perf_hpp__format[i].color(hpp, he);
+		else
+			ret = perf_hpp__format[i].entry(hpp, he);
+
+		advance_hpp(hpp, ret);
+	}
+
+	return hpp->buf - start;
+}
+
+int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
+			      struct hists *hists)
+{
+	const char *sep = symbol_conf.field_sep;
+	struct sort_entry *se;
+	int ret = 0;
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (se->elide)
+			continue;
+
+		ret += scnprintf(s + ret, size - ret, "%s", sep ?: "  ");
+		ret += se->se_snprintf(he, s + ret, size - ret,
+				       hists__col_len(hists, se->se_width_idx));
+	}
+
+	return ret;
+}
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index c7820e5..bd7d460 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -1,8 +1,8 @@
 #include <pthread.h>
 
-#include "../cache.h"
-#include "../debug.h"
-
+#include "../util/cache.h"
+#include "../util/debug.h"
+#include "../util/hist.h"
 
 pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
 
@@ -29,6 +29,8 @@ void setup_browser(bool fallback_to_pager)
 		use_browser = 0;
 		if (fallback_to_pager)
 			setup_pager();
+
+		perf_hpp__init(false, false);
 		break;
 	}
 }
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 9bf7e9e..4228b4c 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -1,5 +1,4 @@
 #include <stdio.h>
-#include <math.h>
 
 #include "../../util/util.h"
 #include "../../util/hist.h"
@@ -291,138 +290,6 @@ static size_t hist_entry_callchain__fprintf(struct hist_entry *he,
 	return 0;
 }
 
-static int hist_entry__period_snprintf(struct hist_entry *he, char *s,
-				     size_t size, struct hists *pair_hists,
-				     bool show_displacement, long displacement,
-				     bool color, u64 total_period)
-{
-	u64 period, total, period_sys, period_us, period_guest_sys, period_guest_us;
-	u64 nr_events;
-	const char *sep = symbol_conf.field_sep;
-	int ret;
-
-	if (symbol_conf.exclude_other && !he->parent)
-		return 0;
-
-	if (pair_hists) {
-		period = he->pair ? he->pair->period : 0;
-		nr_events = he->pair ? he->pair->nr_events : 0;
-		total = pair_hists->stats.total_period;
-		period_sys = he->pair ? he->pair->period_sys : 0;
-		period_us = he->pair ? he->pair->period_us : 0;
-		period_guest_sys = he->pair ? he->pair->period_guest_sys : 0;
-		period_guest_us = he->pair ? he->pair->period_guest_us : 0;
-	} else {
-		period = he->period;
-		nr_events = he->nr_events;
-		total = total_period;
-		period_sys = he->period_sys;
-		period_us = he->period_us;
-		period_guest_sys = he->period_guest_sys;
-		period_guest_us = he->period_guest_us;
-	}
-
-	if (total) {
-		if (color)
-			ret = percent_color_snprintf(s, size,
-						     sep ? "%.2f" : "   %6.2f%%",
-						     (period * 100.0) / total);
-		else
-			ret = scnprintf(s, size, sep ? "%.2f" : "   %6.2f%%",
-				       (period * 100.0) / total);
-		if (symbol_conf.show_cpu_utilization) {
-			ret += percent_color_snprintf(s + ret, size - ret,
-					sep ? "%.2f" : "   %6.2f%%",
-					(period_sys * 100.0) / total);
-			ret += percent_color_snprintf(s + ret, size - ret,
-					sep ? "%.2f" : "   %6.2f%%",
-					(period_us * 100.0) / total);
-			if (perf_guest) {
-				ret += percent_color_snprintf(s + ret,
-						size - ret,
-						sep ? "%.2f" : "   %6.2f%%",
-						(period_guest_sys * 100.0) /
-								total);
-				ret += percent_color_snprintf(s + ret,
-						size - ret,
-						sep ? "%.2f" : "   %6.2f%%",
-						(period_guest_us * 100.0) /
-								total);
-			}
-		}
-	} else
-		ret = scnprintf(s, size, sep ? "%" PRIu64 : "%12" PRIu64 " ", period);
-
-	if (symbol_conf.show_nr_samples) {
-		if (sep)
-			ret += scnprintf(s + ret, size - ret, "%c%" PRIu64, *sep, nr_events);
-		else
-			ret += scnprintf(s + ret, size - ret, "%11" PRIu64, nr_events);
-	}
-
-	if (symbol_conf.show_total_period) {
-		if (sep)
-			ret += scnprintf(s + ret, size - ret, "%c%" PRIu64, *sep, period);
-		else
-			ret += scnprintf(s + ret, size - ret, " %12" PRIu64, period);
-	}
-
-	if (pair_hists) {
-		char bf[32];
-		double old_percent = 0, new_percent = 0, diff;
-
-		if (total > 0)
-			old_percent = (period * 100.0) / total;
-		if (total_period > 0)
-			new_percent = (he->period * 100.0) / total_period;
-
-		diff = new_percent - old_percent;
-
-		if (fabs(diff) >= 0.01)
-			scnprintf(bf, sizeof(bf), "%+4.2F%%", diff);
-		else
-			scnprintf(bf, sizeof(bf), " ");
-
-		if (sep)
-			ret += scnprintf(s + ret, size - ret, "%c%s", *sep, bf);
-		else
-			ret += scnprintf(s + ret, size - ret, "%11.11s", bf);
-
-		if (show_displacement) {
-			if (displacement)
-				scnprintf(bf, sizeof(bf), "%+4ld", displacement);
-			else
-				scnprintf(bf, sizeof(bf), " ");
-
-			if (sep)
-				ret += scnprintf(s + ret, size - ret, "%c%s", *sep, bf);
-			else
-				ret += scnprintf(s + ret, size - ret, "%6.6s", bf);
-		}
-	}
-
-	return ret;
-}
-
-int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
-			      struct hists *hists)
-{
-	const char *sep = symbol_conf.field_sep;
-	struct sort_entry *se;
-	int ret = 0;
-
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
-			continue;
-
-		ret += scnprintf(s + ret, size - ret, "%s", sep ?: "  ");
-		ret += se->se_snprintf(he, s + ret, size - ret,
-				       hists__col_len(hists, se->se_width_idx));
-	}
-
-	return ret;
-}
-
 static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
 					    struct hists *hists,
 					    u64 total_period, FILE *fp)
@@ -441,18 +308,22 @@ static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
 
 static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 			       struct hists *hists, struct hists *pair_hists,
-			       bool show_displacement, long displacement,
-			       u64 total_period, FILE *fp)
+			       long displacement, u64 total_period, FILE *fp)
 {
 	char bf[512];
 	int ret;
+	struct perf_hpp hpp = {
+		.buf		= bf,
+		.size		= size,
+		.total_period	= total_period,
+		.displacement	= displacement,
+		.ptr		= pair_hists,
+	};
 
 	if (size == 0 || size > sizeof(bf))
-		size = sizeof(bf);
+		size = hpp.size = sizeof(bf);
 
-	ret = hist_entry__period_snprintf(he, bf, size, pair_hists,
-					  show_displacement, displacement,
-					  true, total_period);
+	ret = hist_entry__period_snprintf(&hpp, he, true);
 	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
 
 	ret = fprintf(fp, "%s\n", bf);
@@ -477,59 +348,29 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 	unsigned int width;
 	const char *sep = symbol_conf.field_sep;
 	const char *col_width = symbol_conf.col_width_list_str;
-	int nr_rows = 0;
+	int idx, nr_rows = 0;
+	char bf[64];
+	struct perf_hpp dummy_hpp = {
+		.buf	= bf,
+		.size	= sizeof(bf),
+		.ptr	= pair,
+	};
 
 	init_rem_hits();
 
 	if (!show_header)
 		goto print_entries;
 
-	fprintf(fp, "# %s", pair ? "Baseline" : "Overhead");
-
-	if (symbol_conf.show_cpu_utilization) {
-		if (sep) {
-			ret += fprintf(fp, "%csys", *sep);
-			ret += fprintf(fp, "%cus", *sep);
-			if (perf_guest) {
-				ret += fprintf(fp, "%cguest sys", *sep);
-				ret += fprintf(fp, "%cguest us", *sep);
-			}
-		} else {
-			ret += fprintf(fp, "     sys  ");
-			ret += fprintf(fp, "      us  ");
-			if (perf_guest) {
-				ret += fprintf(fp, "  guest sys  ");
-				ret += fprintf(fp, "  guest us  ");
-			}
-		}
-	}
-
-	if (symbol_conf.show_nr_samples) {
-		if (sep)
-			fprintf(fp, "%cSamples", *sep);
-		else
-			fputs("  Samples  ", fp);
-	}
-
-	if (symbol_conf.show_total_period) {
-		if (sep)
-			ret += fprintf(fp, "%cPeriod", *sep);
-		else
-			ret += fprintf(fp, "   Period    ");
-	}
+	fprintf(fp, "# ");
+	for (idx = 0; idx < PERF_HPP__MAX_INDEX; idx++) {
+		if (!perf_hpp__format[idx].cond)
+			continue;
 
-	if (pair) {
-		if (sep)
-			ret += fprintf(fp, "%cDelta", *sep);
-		else
-			ret += fprintf(fp, "  Delta    ");
+		if (idx)
+			fprintf(fp, "%s", sep ?: "  ");
 
-		if (show_displacement) {
-			if (sep)
-				ret += fprintf(fp, "%cDisplacement", *sep);
-			else
-				ret += fprintf(fp, " Displ");
-		}
+		perf_hpp__format[idx].header(&dummy_hpp);
+		fprintf(fp, "%s", bf);
 	}
 
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
@@ -561,18 +402,21 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 	if (sep)
 		goto print_entries;
 
-	fprintf(fp, "# ........");
-	if (symbol_conf.show_cpu_utilization)
-		fprintf(fp, "   .......   .......");
-	if (symbol_conf.show_nr_samples)
-		fprintf(fp, " ..........");
-	if (symbol_conf.show_total_period)
-		fprintf(fp, " ............");
-	if (pair) {
-		fprintf(fp, " ..........");
-		if (show_displacement)
-			fprintf(fp, " .....");
+	fprintf(fp, "# ");
+	for (idx = 0; idx < PERF_HPP__MAX_INDEX; idx++) {
+		unsigned int i;
+
+		if (!perf_hpp__format[idx].cond)
+			continue;
+
+		if (idx)
+			fprintf(fp, "%s", sep ?: "  ");
+
+		width = perf_hpp__format[idx].width(&dummy_hpp);
+		for (i = 0; i < width; i++)
+			fprintf(fp, ".");
 	}
+
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		unsigned int i;
 
@@ -612,8 +456,8 @@ print_entries:
 				displacement = 0;
 			++position;
 		}
-		ret += hist_entry__fprintf(h, max_cols, hists, pair, show_displacement,
-					   displacement, total_period, fp);
+		ret += hist_entry__fprintf(h, max_cols, hists, pair, displacement,
+					   total_period, fp);
 
 		if (max_rows && ++nr_rows >= max_rows)
 			goto out;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 2e650ff..4146f51 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -115,6 +115,43 @@ bool hists__new_col_len(struct hists *self, enum hist_column col, u16 len);
 void hists__reset_col_len(struct hists *hists);
 void hists__calc_col_len(struct hists *hists, struct hist_entry *he);
 
+struct perf_hpp {
+	char *buf;
+	size_t size;
+	u64 total_period;
+	const char *sep;
+	long displacement;
+	void *ptr;
+};
+
+struct perf_hpp_fmt {
+	bool cond;
+	int (*header)(struct perf_hpp *hpp);
+	int (*width)(struct perf_hpp *hpp);
+	int (*color)(struct perf_hpp *hpp, struct hist_entry *he);
+	int (*entry)(struct perf_hpp *hpp, struct hist_entry *he);
+};
+
+extern struct perf_hpp_fmt perf_hpp__format[];
+
+enum {
+	PERF_HPP__OVERHEAD,
+	PERF_HPP__OVERHEAD_SYS,
+	PERF_HPP__OVERHEAD_US,
+	PERF_HPP__OVERHEAD_GUEST_SYS,
+	PERF_HPP__OVERHEAD_GUEST_US,
+	PERF_HPP__SAMPLES,
+	PERF_HPP__PERIOD,
+	PERF_HPP__DELTA,
+	PERF_HPP__DISPL,
+
+	PERF_HPP__MAX_INDEX
+};
+
+void perf_hpp__init(bool need_pair, bool show_displacement);
+int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
+				bool color);
+
 struct perf_evlist;
 
 #ifdef NO_NEWT_SUPPORT
-- 
1.7.1

