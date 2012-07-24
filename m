Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab2GXJJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 05:09:35 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55515 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab2GXJHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 05:07:01 -0400
X-AuditID: 9c930179-b7bdcae000003d91-04-500e65b28dcd
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Ulrich Drepper <drepper@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 07/12] perf ui/hist: Add support to group viewing
Date: Tue, 24 Jul 2012 18:01:28 +0900
Message-Id: <1343120493-23059-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1343120493-23059-1-git-send-email-namhyung@kernel.org>
References: <1343120493-23059-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show group members' overhead also when showing the leader's.

Cc: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c |  132 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 119 insertions(+), 13 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 8092a621bbec..57d00b75b6fa 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -4,32 +4,83 @@
 #include "../util/util.h"
 #include "../util/hist.h"
 #include "../util/sort.h"
+#include "../util/evsel.h"
 
 static int hpp_header_overhead(struct hist_print_context *ctx)
 {
+	int len = 8;
+	const char *str = "Overhead";
+
 	if (ctx->pair_hists)
-		return scnprintf(ctx->s, ctx->size, "Baseline");
-	else
-		return scnprintf(ctx->s, ctx->size, "Overhead");
+		str = "Baseline";
+
+	if (symbol_conf.report_group) {
+		struct perf_evsel *evsel = hists_2_evsel(ctx->hists);
+
+		BUG_ON(!perf_evsel__is_group_leader(evsel));
+
+		len *= evsel->nr_children + 1;
+	}
+	return scnprintf(ctx->s, ctx->size, "%-*s", len, str);
 }
 
 static int hpp_width_overhead(struct hist_print_context *ctx __used)
 {
-	return 8;
+	int len = 8;
+
+	if (symbol_conf.report_group) {
+		struct perf_evsel *evsel = hists_2_evsel(ctx->hists);
+		len *= evsel->nr_children + 1;
+	}
+	return len;
 }
 
 static int hpp_color_overhead(struct hist_print_context *ctx,
 			      struct hist_entry *he)
 {
+	int ret;
 	double percent = 100.0 * he->stat.period / ctx->total_period;
-	return percent_color_snprintf(ctx->s, ctx->size, "  %5.2f%%", percent);
+
+	ret = percent_color_snprintf(ctx->s, ctx->size, "  %5.2f%%", percent);
+
+	if (symbol_conf.report_group) {
+		struct perf_evsel *evsel = hists_2_evsel(ctx->hists);
+		int i;
+
+		for (i = 0; i < evsel->nr_children; i++) {
+			u64 period = he->group_stats[i].period;
+			u64 total_period = ctx->hists->group_stats[i].total_period;
+
+			percent = 100.0 * period / total_period;
+			ret += percent_color_snprintf(ctx->s + ret, ctx->size - ret,
+						      "  %5.2f%%", percent);
+		}
+	}
+	return ret;
 }
 
 static int hpp_entry_overhead(struct hist_print_context *ctx,
 			      struct hist_entry *he)
 {
+	int ret;
 	double percent = 100.0 * he->stat.period / ctx->total_period;
-	return scnprintf(ctx->s, ctx->size, "  %5.2f%%", percent);
+
+	ret = scnprintf(ctx->s, ctx->size, "  %5.2f%%", percent);
+
+	if (symbol_conf.report_group) {
+		struct perf_evsel *evsel = hists_2_evsel(ctx->hists);
+		int i;
+
+		for (i = 0; i < evsel->nr_children; i++) {
+			u64 period = he->group_stats[i].period;
+			u64 total_period = ctx->hists->group_stats[i].total_period;
+
+			percent = 100.0 * period / total_period;
+			ret += scnprintf(ctx->s + ret, ctx->size - ret,
+					 "  %5.2f%%", percent);
+		}
+	}
+	return ret;
 }
 
 static int hpp_header_overhead_sys(struct hist_print_context *ctx)
@@ -130,34 +181,86 @@ static int hpp_entry_overhead_guest_us(struct hist_print_context *ctx,
 
 static int hpp_header_samples(struct hist_print_context *ctx)
 {
-	return scnprintf(ctx->s, ctx->size, "  Samples  ");
+	int len = 11;
+	const char str[] = "  Samples  ";
+
+	if (symbol_conf.report_group) {
+		struct perf_evsel *evsel = hists_2_evsel(ctx->hists);
+		len += (len + 2) * evsel->nr_children;
+	}
+	return scnprintf(ctx->s, ctx->size, "%-*s", len, str);
 }
 
 static int hpp_width_samples(struct hist_print_context *ctx __used)
 {
-	return 11;
+	int len = 11;
+
+	if (symbol_conf.report_group) {
+		struct perf_evsel *evsel = hists_2_evsel(ctx->hists);
+		len += (len + 2) * evsel->nr_children;
+	}
+	return len;
 }
 
 static int hpp_entry_samples(struct hist_print_context *ctx,
 			     struct hist_entry *he)
 {
-	return scnprintf(ctx->s, ctx->size, "%11" PRIu64, he->stat.nr_events);
+	int ret;
+
+	ret = scnprintf(ctx->s, ctx->size, "%11" PRIu64, he->stat.nr_events);
+
+	if (symbol_conf.report_group) {
+		struct perf_evsel *evsel = hists_2_evsel(ctx->hists);
+		int i;
+
+		for (i = 0; i < evsel->nr_children; i++) {
+			ret += scnprintf(ctx->s + ret, ctx->size - ret,
+				"  %11" PRIu64, he->group_stats[i].nr_events);
+		}
+	}
+	return ret;
 }
 
 static int hpp_header_period(struct hist_print_context *ctx)
 {
-	return scnprintf(ctx->s, ctx->size, "   Period   ");
+	int len = 12;
+	const char str[] = "   Period   ";
+
+	if (symbol_conf.report_group) {
+		struct perf_evsel *evsel = hists_2_evsel(ctx->hists);
+		len += (len + 2) * evsel->nr_children;
+	}
+	return scnprintf(ctx->s, ctx->size, "%-*s", len, str);
 }
 
 static int hpp_width_period(struct hist_print_context *ctx __used)
 {
-	return 12;
+	int len = 12;
+
+	if (symbol_conf.report_group) {
+		struct perf_evsel *evsel = hists_2_evsel(ctx->hists);
+		len += (len + 2) * evsel->nr_children;
+	}
+	return len;
 }
 
 static int hpp_entry_period(struct hist_print_context *ctx,
 			    struct hist_entry *he)
 {
-	return scnprintf(ctx->s, ctx->size, "%12" PRIu64, he->stat.period);
+	int ret;
+
+	ret = scnprintf(ctx->s, ctx->size, "%12" PRIu64, he->stat.period);
+
+	if (symbol_conf.report_group) {
+		struct perf_evsel *evsel = hists_2_evsel(ctx->hists);
+		int i;
+
+		for (i = 0; i < evsel->nr_children; i++) {
+			ret += scnprintf(ctx->s + ret, ctx->size - ret,
+				"  %12" PRIu64, he->group_stats[i].period);
+		}
+	}
+	return ret;
 }
 
 static int hpp_header_delta(struct hist_print_context *ctx)
@@ -801,6 +904,9 @@ unsigned int hists__sort_list_width(struct hists *hists)
 {
 	struct sort_entry *se;
 	int i, ret = 0;
+	struct hist_print_context dummy_ctx = {
+		.hists	= hists,
+	};
 
 	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
 		if (!hpp_functions[i].cond)
@@ -808,7 +914,7 @@ unsigned int hists__sort_list_width(struct hists *hists)
 		if (i)
 			ret += 2;
 
-		ret += hpp_functions[i].width(NULL);
+		ret += hpp_functions[i].width(&dummy_ctx);
 	}
 
 	list_for_each_entry(se, &hist_entry__sort_list, list)
-- 
1.7.10.4

