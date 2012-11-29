Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab2K2GjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:39:23 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57376 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2K2GjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:39:13 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-d1-50b7030a69f9
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 12/18] perf ui/hist: Add support for event group view
Date: Thu, 29 Nov 2012 15:38:40 +0900
Message-Id: <1354171126-14387-14-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Show group members' overhead also when showing the leader's if event
group is enabled.  Use macro for defining hpp functions which looks
almost identical.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c       | 370 +++++++++++++++++++++++----------------------
 tools/perf/ui/stdio/hist.c |   2 +
 2 files changed, 191 insertions(+), 181 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index aa84130024d5..b42bd15af3f5 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -3,152 +3,198 @@
 #include "../util/hist.h"
 #include "../util/util.h"
 #include "../util/sort.h"
-
+#include "../util/evsel.h"
 
 /* hist period print (hpp) functions */
-static int hpp__header_overhead(struct perf_hpp *hpp)
-{
-	return scnprintf(hpp->buf, hpp->size, "Overhead");
-}
-
-static int hpp__width_overhead(struct perf_hpp *hpp __maybe_unused)
-{
-	return 8;
-}
-
-static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period / hists->stats.total_period;
-
-	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
-}
-
-static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period / hists->stats.total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
-}
-
-static int hpp__header_overhead_sys(struct perf_hpp *hpp)
-{
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, "sys");
-}
-
-static int hpp__width_overhead_sys(struct perf_hpp *hpp __maybe_unused)
-{
-	return 7;
-}
-
-static int hpp__color_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_sys / hists->stats.total_period;
-
-	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
-}
-
-static int hpp__entry_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_sys / hists->stats.total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%6.2f%%";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
-}
-
-static int hpp__header_overhead_us(struct perf_hpp *hpp)
-{
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, "user");
-}
-
-static int hpp__width_overhead_us(struct perf_hpp *hpp __maybe_unused)
-{
-	return 7;
-}
-
-static int hpp__color_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_us / hists->stats.total_period;
-
-	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
-}
-
-static int hpp__entry_overhead_us(struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_us / hists->stats.total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%6.2f%%";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
-}
-
-static int hpp__header_overhead_guest_sys(struct perf_hpp *hpp)
-{
-	return scnprintf(hpp->buf, hpp->size, "guest sys");
-}
-
-static int hpp__width_overhead_guest_sys(struct perf_hpp *hpp __maybe_unused)
-{
-	return 9;
-}
-
-static int hpp__color_overhead_guest_sys(struct perf_hpp *hpp,
-					 struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_guest_sys / hists->stats.total_period;
-
-	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
-}
-
-static int hpp__entry_overhead_guest_sys(struct perf_hpp *hpp,
-					 struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_guest_sys / hists->stats.total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%% ";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
-}
-
-static int hpp__header_overhead_guest_us(struct perf_hpp *hpp)
-{
-	return scnprintf(hpp->buf, hpp->size, "guest usr");
-}
-
-static int hpp__width_overhead_guest_us(struct perf_hpp *hpp __maybe_unused)
-{
-	return 9;
-}
-
-static int hpp__color_overhead_guest_us(struct perf_hpp *hpp,
-					struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_guest_us / hists->stats.total_period;
-
-	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
-}
-
-static int hpp__entry_overhead_guest_us(struct perf_hpp *hpp,
-					struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_guest_us / hists->stats.total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%% ";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
-}
 
+#define __HPP_HEADER_FN(_type, _str, _min_width, _unit_width) 		\
+static int hpp__header_##_type(struct perf_hpp *hpp)			\
+{									\
+	int len = _min_width;						\
+									\
+	if (symbol_conf.event_group) {					\
+		struct perf_evsel *evsel = hpp->ptr;			\
+									\
+		len = max(len, evsel->nr_members * _unit_width);	\
+	}								\
+	return scnprintf(hpp->buf, hpp->size, "%*s", len, _str);	\
+}
+
+#define __HPP_WIDTH_FN(_type, _min_width, _unit_width) 			\
+static int hpp__width_##_type(struct perf_hpp *hpp)			\
+{									\
+	int len = _min_width;						\
+									\
+	if (symbol_conf.event_group) {					\
+		struct perf_evsel *evsel = hpp->ptr;			\
+									\
+		len = max(len, evsel->nr_members * _unit_width);	\
+	}								\
+	return len;							\
+}
+
+#define __HPP_COLOR_PERCENT_FN(_type, _field)					\
+static int hpp__color_##_type(struct perf_hpp *hpp, struct hist_entry *he) 	\
+{										\
+	int ret;								\
+	double percent = 0.0;							\
+	struct hists *hists = he->hists;					\
+										\
+	if (hists->stats.total_period)						\
+		percent = 100.0 * he->stat._field / hists->stats.total_period; 	\
+										\
+	ret = percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);	\
+										\
+	if (symbol_conf.event_group) {						\
+		int i;								\
+		struct perf_evsel *evsel = hists_to_evsel(hists);		\
+		struct hist_entry *pair;					\
+		int nr_members = evsel->nr_members;				\
+		double *percents;						\
+										\
+		if (nr_members <= 1)						\
+			return ret;						\
+										\
+		percents = zalloc(sizeof(*percents) * nr_members);		\
+		if (percents == NULL) {						\
+			pr_warning("Not enough memory!\n");			\
+			return ret;						\
+		}								\
+										\
+		list_for_each_entry(pair, &he->pairs.head, pairs.node) { 	\
+			u64 period = pair->stat._field;				\
+			u64 total = pair->hists->stats.total_period;		\
+										\
+			if (!total)						\
+				continue;					\
+										\
+			evsel = hists_to_evsel(pair->hists);			\
+			i = perf_evsel__group_idx(evsel);			\
+			percents[i] = 100.0 * period / total;			\
+		}								\
+										\
+		for (i = 1; i < nr_members; i++) {				\
+			ret += percent_color_snprintf(hpp->buf + ret,		\
+						      hpp->size - ret,		\
+						      " %6.2f%%", percents[i]);	\
+		}								\
+		free(percents);							\
+	}									\
+	return ret;								\
+}
+
+#define __HPP_ENTRY_PERCENT_FN(_type, _field)					\
+static int hpp__entry_##_type(struct perf_hpp *hpp, struct hist_entry *he) 	\
+{										\
+	int ret;								\
+	double percent = 0.0;							\
+	struct hists *hists = he->hists;					\
+	const char *fmt = symbol_conf.field_sep ? " %.2f" : " %6.2f%%";		\
+										\
+	if (hists->stats.total_period)						\
+		percent = 100.0 * he->stat._field / hists->stats.total_period; 	\
+										\
+	ret = scnprintf(hpp->buf, hpp->size, fmt, percent);			\
+										\
+	if (symbol_conf.event_group) {						\
+		int i;								\
+		struct perf_evsel *evsel = hists_to_evsel(hists);		\
+		struct hist_entry *pair;					\
+		int nr_members = evsel->nr_members;				\
+		double *percents;						\
+										\
+		if (nr_members <= 1)						\
+			return ret;						\
+										\
+		percents = zalloc(sizeof(*percents) * nr_members);		\
+		if (percents == NULL) {						\
+			pr_warning("Not enough memory!\n");			\
+			return ret;						\
+		}								\
+										\
+		list_for_each_entry(pair, &he->pairs.head, pairs.node) { 	\
+			u64 period = pair->stat._field;				\
+			u64 total = pair->hists->stats.total_period;		\
+										\
+			if (!total)						\
+				continue;					\
+										\
+			evsel = hists_to_evsel(pair->hists);			\
+			i = perf_evsel__group_idx(evsel);			\
+			percents[i] = 100.0 * period / total;			\
+		}								\
+										\
+		for (i = 1; i < nr_members; i++) {				\
+			ret += scnprintf(hpp->buf + ret, hpp->size - ret,	\
+					 fmt, percents[i]);			\
+		}								\
+		free(percents);							\
+	}									\
+	return ret;								\
+}
+
+#define __HPP_ENTRY_RAW_FN(_type, _field)					\
+static int hpp__entry_##_type(struct perf_hpp *hpp, struct hist_entry *he) 	\
+{										\
+	int ret;								\
+	const char *fmt = symbol_conf.field_sep ? " %"PRIu64 : " %11"PRIu64; 	\
+										\
+	ret = scnprintf(hpp->buf, hpp->size, fmt, he->stat._field);		\
+										\
+	if (symbol_conf.event_group) {						\
+		int i;								\
+		struct perf_evsel *evsel = hists_to_evsel(he->hists);		\
+		struct hist_entry *pair;					\
+		int nr_members = evsel->nr_members;				\
+		u64 *numbers;							\
+										\
+		if (nr_members <= 1)						\
+			return ret;						\
+										\
+		numbers = zalloc(sizeof(*numbers) * nr_members);		\
+		if (numbers == NULL) {						\
+			pr_warning("Not enough memory!\n");			\
+			return ret;						\
+		}								\
+										\
+		list_for_each_entry(pair, &he->pairs.head, pairs.node) { 	\
+			evsel = hists_to_evsel(pair->hists);			\
+			i = perf_evsel__group_idx(evsel);			\
+			numbers[i] = pair->stat._field;				\
+		}								\
+										\
+		for (i = 1; i < nr_members; i++) {				\
+			ret += scnprintf(hpp->buf + ret, hpp->size - ret,	\
+					 fmt, numbers[i]);			\
+		}								\
+		free(numbers);							\
+	}									\
+	return ret;								\
+}
+
+#define HPP_PERCENT_FNS(_type, _str, _field, _min_width, _unit_width)	\
+__HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
+__HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
+__HPP_COLOR_PERCENT_FN(_type, _field)					\
+__HPP_ENTRY_PERCENT_FN(_type, _field)
+
+#define HPP_RAW_FNS(_type, _str, _field, _min_width, _unit_width)	\
+__HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
+__HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
+__HPP_ENTRY_RAW_FN(_type, _field)
+
+
+HPP_PERCENT_FNS(overhead, "Overhead", period, 8, 8)
+HPP_PERCENT_FNS(overhead_sys, "sys", period_sys, 8, 8)
+HPP_PERCENT_FNS(overhead_us, "usr", period_sys, 8, 8)
+HPP_PERCENT_FNS(overhead_guest_sys, "guest sys", period_sys, 9, 8)
+HPP_PERCENT_FNS(overhead_guest_us, "guest usr", period_sys, 9, 8)
+
+HPP_RAW_FNS(samples, "Samples", nr_events, 12, 12)
+HPP_RAW_FNS(period, "Period", period, 12, 12)
+
+
+/* diff-specific hpp functions */
 static int hpp__header_baseline(struct perf_hpp *hpp)
 {
 	return scnprintf(hpp->buf, hpp->size, "Baseline");
@@ -196,44 +242,6 @@ static int hpp__entry_baseline(struct perf_hpp *hpp, struct hist_entry *he)
 		return scnprintf(hpp->buf, hpp->size, "            ");
 }
 
-static int hpp__header_samples(struct perf_hpp *hpp)
-{
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%11s";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, "Samples");
-}
-
-static int hpp__width_samples(struct perf_hpp *hpp __maybe_unused)
-{
-	return 11;
-}
-
-static int hpp__entry_samples(struct perf_hpp *hpp, struct hist_entry *he)
-{
-	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%11" PRIu64;
-
-	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.nr_events);
-}
-
-static int hpp__header_period(struct perf_hpp *hpp)
-{
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%12s";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, "Period");
-}
-
-static int hpp__width_period(struct perf_hpp *hpp __maybe_unused)
-{
-	return 12;
-}
-
-static int hpp__entry_period(struct perf_hpp *hpp, struct hist_entry *he)
-{
-	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%12" PRIu64;
-
-	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.period);
-}
-
 static int hpp__header_period_baseline(struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%12s";
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index f0ee204f99bb..07421d6da5a2 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -3,6 +3,7 @@
 #include "../../util/util.h"
 #include "../../util/hist.h"
 #include "../../util/sort.h"
+#include "../../util/evsel.h"
 
 
 static size_t callchain__fprintf_left_margin(FILE *fp, int left_margin)
@@ -346,6 +347,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	struct perf_hpp dummy_hpp = {
 		.buf	= bf,
 		.size	= sizeof(bf),
+		.ptr	= hists_to_evsel(hists),
 	};
 	bool first = true;
 
-- 
1.7.11.7

