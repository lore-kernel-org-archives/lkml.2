Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2HTFAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 01:00:06 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44965 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab2HTE7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:59:11 -0400
X-AuditID: 9c930197-b7bb2ae0000011d9-24-5031c41cc70d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/7] perf hists: Introduce hist_period_print functions
Date: Mon, 20 Aug 2012 13:52:07 +0900
Message-Id: <1345438331-20234-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1345438331-20234-1-git-send-email-namhyung@kernel.org>
References: <1345438331-20234-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Current hist print functions are messy. Refactor them using the hpp
callbacks and move common code to ui/hist.c. This will make it easy to
add new features.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile        |   2 +
 tools/perf/builtin-diff.c  |   1 +
 tools/perf/ui/hist.c       | 326 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/ui/setup.c      |   8 +-
 tools/perf/ui/stdio/hist.c | 238 ++++++---------------------------
 tools/perf/util/hist.h     |  37 +++++
 6 files changed, 412 insertions(+), 200 deletions(-)
 create mode 100644 tools/perf/ui/hist.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index cb18b047c9c9..96dda3280ce9 100644
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
index d29d350fb2b7..3fc53f8b098e 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -235,6 +235,7 @@ int cmd_diff(int argc, const char **argv, const char *prefix __used)
 	if (symbol__init() < 0)
 		return -1;
 
+	perf_hpp__init(true, show_displacement);
 	setup_sorting(diff_usage, options);
 	setup_pager();
 
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
new file mode 100644
index 000000000000..8062b38f7971
--- /dev/null
+++ b/tools/perf/ui/hist.c
@@ -0,0 +1,326 @@
+#include <math.h>
+
+#include "../util/hist.h"
+#include "../util/util.h"
+#include "../util/sort.h"
+
+
+/* hist period print (hpp) functions */
+static int hpp_header_overhead(struct hpp_context *ctx)
+{
+	if (ctx->ptr)
+		return scnprintf(ctx->s, ctx->size, "Baseline");
+	else
+		return scnprintf(ctx->s, ctx->size, "Overhead");
+}
+
+static int hpp_width_overhead(struct hpp_context *ctx __used)
+{
+	return 8;
+}
+
+static int hpp_color_overhead(struct hpp_context *ctx,
+			      struct hist_entry *he)
+{
+	double percent = 100.0 * he->period / ctx->total_period;
+	return percent_color_snprintf(ctx->s, ctx->size, "  %5.2f%%", percent);
+}
+
+static int hpp_entry_overhead(struct hpp_context *ctx,
+			      struct hist_entry *he)
+{
+	double percent = 100.0 * he->period / ctx->total_period;
+	return scnprintf(ctx->s, ctx->size, "  %5.2f%%", percent);
+}
+
+static int hpp_header_overhead_sys(struct hpp_context *ctx)
+{
+	return scnprintf(ctx->s, ctx->size, " sys  ");
+}
+
+static int hpp_width_overhead_sys(struct hpp_context *ctx __used)
+{
+	return 6;
+}
+
+static int hpp_color_overhead_sys(struct hpp_context *ctx,
+				  struct hist_entry *he)
+{
+	double percent = 100.0 * he->period_sys / ctx->total_period;
+	return percent_color_snprintf(ctx->s, ctx->size, "%5.2f%%", percent);
+}
+
+static int hpp_entry_overhead_sys(struct hpp_context *ctx,
+				  struct hist_entry *he)
+{
+	double percent = 100.0 * he->period_sys / ctx->total_period;
+	return scnprintf(ctx->s, ctx->size, "%5.2f%%", percent);
+}
+
+static int hpp_header_overhead_us(struct hpp_context *ctx)
+{
+	return scnprintf(ctx->s, ctx->size, " user ");
+}
+
+static int hpp_width_overhead_us(struct hpp_context *ctx __used)
+{
+	return 6;
+}
+
+static int hpp_color_overhead_us(struct hpp_context *ctx,
+				 struct hist_entry *he)
+{
+	double percent = 100.0 * he->period_us / ctx->total_period;
+	return percent_color_snprintf(ctx->s, ctx->size, "%5.2f%%", percent);
+}
+
+static int hpp_entry_overhead_us(struct hpp_context *ctx,
+				 struct hist_entry *he)
+{
+	double percent = 100.0 * he->period_us / ctx->total_period;
+	return scnprintf(ctx->s, ctx->size, "%5.2f%%", percent);
+}
+
+static int hpp_header_overhead_guest_sys(struct hpp_context *ctx)
+{
+	return scnprintf(ctx->s, ctx->size, "guest sys");
+}
+
+static int hpp_width_overhead_guest_sys(struct hpp_context *ctx __used)
+{
+	return 9;
+}
+
+static int hpp_color_overhead_guest_sys(struct hpp_context *ctx,
+					struct hist_entry *he)
+{
+	double percent = 100.0 * he->period_guest_sys / ctx->total_period;
+	return percent_color_snprintf(ctx->s, ctx->size, "  %5.2f%% ", percent);
+}
+
+static int hpp_entry_overhead_guest_sys(struct hpp_context *ctx,
+					struct hist_entry *he)
+{
+	double percent = 100.0 * he->period_guest_sys / ctx->total_period;
+	return scnprintf(ctx->s, ctx->size, "  %5.2f%% ", percent);
+}
+
+static int hpp_header_overhead_guest_us(struct hpp_context *ctx)
+{
+	return scnprintf(ctx->s, ctx->size, "guest usr");
+}
+
+static int hpp_width_overhead_guest_us(struct hpp_context *ctx __used)
+{
+	return 9;
+}
+
+static int hpp_color_overhead_guest_us(struct hpp_context *ctx,
+				       struct hist_entry *he)
+{
+	double percent = 100.0 * he->period_guest_us / ctx->total_period;
+	return percent_color_snprintf(ctx->s, ctx->size, "  %5.2f%% ", percent);
+}
+
+static int hpp_entry_overhead_guest_us(struct hpp_context *ctx,
+				       struct hist_entry *he)
+{
+	double percent = 100.0 * he->period_guest_us / ctx->total_period;
+	return scnprintf(ctx->s, ctx->size, "  %5.2f%% ", percent);
+}
+
+static int hpp_header_samples(struct hpp_context *ctx)
+{
+	return scnprintf(ctx->s, ctx->size, "  Samples  ");
+}
+
+static int hpp_width_samples(struct hpp_context *ctx __used)
+{
+	return 11;
+}
+
+static int hpp_entry_samples(struct hpp_context *ctx,
+			     struct hist_entry *he)
+{
+	return scnprintf(ctx->s, ctx->size, "%11" PRIu64, he->nr_events);
+}
+
+static int hpp_header_period(struct hpp_context *ctx)
+{
+	return scnprintf(ctx->s, ctx->size, "   Period   ");
+}
+
+static int hpp_width_period(struct hpp_context *ctx __used)
+{
+	return 12;
+}
+
+static int hpp_entry_period(struct hpp_context *ctx,
+			    struct hist_entry *he)
+{
+	return scnprintf(ctx->s, ctx->size, "%12" PRIu64, he->period);
+}
+
+static int hpp_header_delta(struct hpp_context *ctx)
+{
+	return scnprintf(ctx->s, ctx->size, " Delta ");
+}
+
+static int hpp_width_delta(struct hpp_context *ctx __used)
+{
+	return 7;
+}
+
+static int hpp_entry_delta(struct hpp_context *ctx,
+			   struct hist_entry *he)
+{
+	struct hists *pair_hists = ctx->ptr;
+	u64 old_total, new_total;
+	double old_percent = 0, new_percent = 0;
+	double diff;
+	char buf[32];
+
+	old_total = pair_hists->stats.total_period;
+	if (old_total > 0)
+		old_percent = 100.0 * he->pair->period / old_total;
+
+	new_total = ctx->total_period;
+	if (new_total > 0)
+		new_percent = 100.0 * he->period / new_total;
+
+	diff = new_percent - old_percent;
+	if (fabs(diff) < 0.01)
+		return scnprintf(ctx->s, ctx->size, "       ");
+
+	scnprintf(buf, sizeof(buf), "%+4.2F%%", diff);
+	return scnprintf(ctx->s, ctx->size, "%7.7s", buf);
+}
+
+static int hpp_header_displ(struct hpp_context *ctx)
+{
+	return scnprintf(ctx->s, ctx->size, "Displ.");
+}
+
+static int hpp_width_displ(struct hpp_context *ctx __used)
+{
+	return 6;
+}
+
+static int hpp_entry_displ(struct hpp_context *ctx,
+			   struct hist_entry *he __used)
+{
+	char buf[32];
+
+	if (!ctx->displacement)
+		return scnprintf(ctx->s, ctx->size, "     ");
+
+	scnprintf(buf, sizeof(buf), "%+4ld", ctx->displacement);
+	return scnprintf(ctx->s, ctx->size, "%6.6s", buf);
+}
+
+#define HPP_COLOR_PRINT_FNS(_name)		\
+	.header	= hpp_header_ ## _name,		\
+	.width	= hpp_width_ ## _name,		\
+	.color	= hpp_color_ ## _name,		\
+	.entry	= hpp_entry_ ## _name
+
+#define HPP_PRINT_FNS(_name)			\
+	.header	= hpp_header_ ## _name,		\
+	.width	= hpp_width_ ## _name,		\
+	.entry	= hpp_entry_ ## _name
+
+struct hist_period_print hpp_functions[] = {
+	{ .cond = true,  HPP_COLOR_PRINT_FNS(overhead) },
+	{ .cond = false, HPP_COLOR_PRINT_FNS(overhead_sys) },
+	{ .cond = false, HPP_COLOR_PRINT_FNS(overhead_us) },
+	{ .cond = false, HPP_COLOR_PRINT_FNS(overhead_guest_sys) },
+	{ .cond = false, HPP_COLOR_PRINT_FNS(overhead_guest_us) },
+	{ .cond = false, HPP_PRINT_FNS(samples) },
+	{ .cond = false, HPP_PRINT_FNS(period) },
+	{ .cond = false, HPP_PRINT_FNS(delta) },
+	{ .cond = false, HPP_PRINT_FNS(displ) }
+};
+
+#undef HPP_COLOR_PRINT_FNS
+#undef HPP_PRINT_FNS
+
+void perf_hpp__init(bool need_pair, bool show_displacement)
+{
+	if (symbol_conf.show_cpu_utilization) {
+		hpp_functions[PERF_HPP__OVERHEAD_SYS].cond = true;
+		hpp_functions[PERF_HPP__OVERHEAD_US].cond = true;
+
+		if (perf_guest) {
+			hpp_functions[PERF_HPP__OVERHEAD_GUEST_SYS].cond = true;
+			hpp_functions[PERF_HPP__OVERHEAD_GUEST_US].cond = true;
+		}
+	}
+
+	if (symbol_conf.show_nr_samples)
+		hpp_functions[PERF_HPP__SAMPLES].cond = true;
+
+	if (symbol_conf.show_total_period)
+		hpp_functions[PERF_HPP__PERIOD].cond = true;
+
+	if (need_pair) {
+		hpp_functions[PERF_HPP__DELTA].cond = true;
+
+		if (show_displacement)
+			hpp_functions[PERF_HPP__DISPL].cond = true;
+	}
+}
+
+static inline void advance_hpp_context(struct hpp_context *ctx, int inc)
+{
+	ctx->s    += inc;
+	ctx->size -= inc;
+}
+
+int hist_entry__period_snprintf(struct hpp_context *ctx,
+				struct hist_entry *he, bool color)
+{
+	const char *sep = symbol_conf.field_sep;
+	char *start_s = ctx->s;
+	int i, ret;
+
+	if (symbol_conf.exclude_other && !he->parent)
+		return 0;
+
+	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
+		if (!hpp_functions[i].cond)
+			continue;
+
+		if (!sep || i > 0) {
+			ret = scnprintf(ctx->s, ctx->size, "%s", sep ?: "  ");
+			advance_hpp_context(ctx, ret);
+		}
+
+		if (color && hpp_functions[i].color)
+			ret = hpp_functions[i].color(ctx, he);
+		else
+			ret = hpp_functions[i].entry(ctx, he);
+
+		advance_hpp_context(ctx, ret);
+	}
+
+	return ctx->s - start_s;
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
index c7820e569660..bd7d460f844c 100644
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
index 9bf7e9e5a72e..c040b03cc6f4 100644
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
+	struct hpp_context ctx = {
+		.s		= bf,
+		.size		= size,
+		.total_period	= total_period,
+		.displacement	= displacement,
+		.ptr		= pair_hists,
+	};
 
 	if (size == 0 || size > sizeof(bf))
-		size = sizeof(bf);
+		size = ctx.size = sizeof(bf);
 
-	ret = hist_entry__period_snprintf(he, bf, size, pair_hists,
-					  show_displacement, displacement,
-					  true, total_period);
+	ret = hist_entry__period_snprintf(&ctx, he, true);
 	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
 
 	ret = fprintf(fp, "%s\n", bf);
@@ -477,59 +348,29 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 	unsigned int width;
 	const char *sep = symbol_conf.field_sep;
 	const char *col_width = symbol_conf.col_width_list_str;
-	int nr_rows = 0;
+	int idx, nr_rows = 0;
+	char bf[64];
+	struct hpp_context dummy_ctx = {
+		.s	= bf,
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
+		if (!hpp_functions[idx].cond)
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
+		hpp_functions[idx].header(&dummy_ctx);
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
+		if (!hpp_functions[idx].cond)
+			continue;
+
+		if (idx)
+			fprintf(fp, "%s", sep ?: "  ");
+
+		width = hpp_functions[idx].width(&dummy_ctx);
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
index 2e650ffb7d23..a387e2aa4602 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -115,6 +115,43 @@ bool hists__new_col_len(struct hists *self, enum hist_column col, u16 len);
 void hists__reset_col_len(struct hists *hists);
 void hists__calc_col_len(struct hists *hists, struct hist_entry *he);
 
+struct hpp_context {
+	char *s;
+	size_t size;
+	u64 total_period;
+	const char *sep;
+	long displacement;
+	void *ptr;
+};
+
+struct hist_period_print {
+	bool cond;
+	int (*header)(struct hpp_context *ctx);
+	int (*width)(struct hpp_context *ctx);
+	int (*color)(struct hpp_context *ctx, struct hist_entry *he);
+	int (*entry)(struct hpp_context *ctx, struct hist_entry *he);
+};
+
+extern struct hist_period_print hpp_functions[];
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
+int hist_entry__period_snprintf(struct hpp_context *ctx,
+				struct hist_entry *he, bool color);
+
 struct perf_evlist;
 
 #ifdef NO_NEWT_SUPPORT
-- 
1.7.11.2

