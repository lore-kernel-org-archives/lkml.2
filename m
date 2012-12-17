Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab2LQGjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 01:39:20 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45648 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab2LQGjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 01:39:12 -0500
X-AuditID: 9c930179-b7becae000000e51-7b-50cebe0dc2fc
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 07/14] perf ui/hist: Add support for event group view
Date: Mon, 17 Dec 2012 15:38:58 +0900
Message-Id: <1355726345-29553-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
References: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Show group members' overhead also when showing the leader's if event
group is enabled.  Use macro for defining hpp functions which looks
almost identical.

Thanks to Arnaldo for suggesting a better way to print group members
without allocating temporary array.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c       | 348 +++++++++++++++++++++------------------------
 tools/perf/ui/stdio/hist.c |   2 +
 2 files changed, 167 insertions(+), 183 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 0db3b4480604..ea605be78a29 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -3,223 +3,194 @@
 #include "../util/hist.h"
 #include "../util/util.h"
 #include "../util/sort.h"
-
+#include "../util/evsel.h"
 
 /* hist period print (hpp) functions */
-static int hpp__header_overhead(struct perf_hpp_fmt *fmt __maybe_unused,
-				struct perf_hpp *hpp)
-{
-	return scnprintf(hpp->buf, hpp->size, "Overhead");
-}
-
-static int hpp__width_overhead(struct perf_hpp_fmt *fmt __maybe_unused,
-			       struct perf_hpp *hpp __maybe_unused)
-{
-	return 8;
-}
-
-static int hpp__color_overhead(struct perf_hpp_fmt *fmt __maybe_unused,
-			       struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period / hists->stats.total_period;
-
-	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
-}
 
-static int hpp__entry_overhead(struct perf_hpp_fmt *_fmt __maybe_unused,
-			       struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period / hists->stats.total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
-}
-
-static int hpp__header_overhead_sys(struct perf_hpp_fmt *_fmt __maybe_unused,
-				    struct perf_hpp *hpp)
-{
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, "sys");
-}
-
-static int hpp__width_overhead_sys(struct perf_hpp_fmt *fmt __maybe_unused,
-				   struct perf_hpp *hpp __maybe_unused)
-{
-	return 7;
-}
+typedef int (*hpp_snprint_fn)(char *buf, size_t size, const char *fmt, ...);
 
-static int hpp__color_overhead_sys(struct perf_hpp_fmt *fmt __maybe_unused,
-				   struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_sys / hists->stats.total_period;
-
-	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
-}
-
-static int hpp__entry_overhead_sys(struct perf_hpp_fmt *_fmt __maybe_unused,
-				   struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_sys / hists->stats.total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%6.2f%%";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
-}
-
-static int hpp__header_overhead_us(struct perf_hpp_fmt *_fmt __maybe_unused,
-				   struct perf_hpp *hpp)
-{
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
-
-	return scnprintf(hpp->buf, hpp->size, fmt, "user");
-}
-
-static int hpp__width_overhead_us(struct perf_hpp_fmt *fmt __maybe_unused,
-				  struct perf_hpp *hpp __maybe_unused)
-{
-	return 7;
-}
-
-static int hpp__color_overhead_us(struct perf_hpp_fmt *fmt __maybe_unused,
-				  struct perf_hpp *hpp, struct hist_entry *he)
+static int __hpp__percent_fmt(struct perf_hpp *hpp, struct hist_entry *he,
+			      u64 (*get_field)(struct hist_entry *),
+			      const char *fmt, hpp_snprint_fn print_fn)
 {
+	int ret;
+	double percent = 0.0;
 	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_us / hists->stats.total_period;
 
-	return percent_color_snprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
-}
+	if (hists->stats.total_period)
+		percent = 100.0 * get_field(he) / hists->stats.total_period;
 
-static int hpp__entry_overhead_us(struct perf_hpp_fmt *_fmt __maybe_unused,
-				  struct perf_hpp *hpp, struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_us / hists->stats.total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : "%6.2f%%";
+	ret = print_fn(hpp->buf, hpp->size, fmt, percent);
 
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
-}
+	if (symbol_conf.event_group) {
+		int prev_idx, idx_delta, i;
+		struct perf_evsel *evsel = hists_to_evsel(hists);
+		struct hist_entry *pair;
+		int nr_members = evsel->nr_members;
 
-static int
-hpp__header_overhead_guest_sys(struct perf_hpp_fmt *fmt __maybe_unused,
-			       struct perf_hpp *hpp)
-{
-	return scnprintf(hpp->buf, hpp->size, "guest sys");
-}
+		if (nr_members <= 1)
+			return ret;
 
-static int
-hpp__width_overhead_guest_sys(struct perf_hpp_fmt *fmt __maybe_unused,
-			      struct perf_hpp *hpp __maybe_unused)
-{
-	return 9;
-}
+		prev_idx = perf_evsel__group_idx(evsel);
 
-static int
-hpp__color_overhead_guest_sys(struct perf_hpp_fmt *fmt __maybe_unused,
-			      struct perf_hpp *hpp,
-			      struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_guest_sys / hists->stats.total_period;
+		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
+			u64 period = get_field(pair);
+			u64 total = pair->hists->stats.total_period;
 
-	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
-}
+			if (!total)
+				continue;
 
-static int
-hpp__entry_overhead_guest_sys(struct perf_hpp_fmt *_fmt __maybe_unused,
-			      struct perf_hpp *hpp,
-			      struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_guest_sys / hists->stats.total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%% ";
+			evsel = hists_to_evsel(pair->hists);
+			idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
 
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
-}
+			for (i = 0; i < idx_delta; i++) {
+				ret += print_fn(hpp->buf + ret, hpp->size - ret,
+						fmt, 0.0);
+			}
 
-static int
-hpp__header_overhead_guest_us(struct perf_hpp_fmt *fmt __maybe_unused,
-			      struct perf_hpp *hpp)
-{
-	return scnprintf(hpp->buf, hpp->size, "guest usr");
-}
+			ret += print_fn(hpp->buf + ret, hpp->size - ret,
+					fmt, 100.0 * period / total);
 
-static int
-hpp__width_overhead_guest_us(struct perf_hpp_fmt *fmt __maybe_unused,
-			     struct perf_hpp *hpp __maybe_unused)
-{
-	return 9;
-}
+			prev_idx += 1 + idx_delta;
+		}
 
-static int
-hpp__color_overhead_guest_us(struct perf_hpp_fmt *fmt __maybe_unused,
-			     struct perf_hpp *hpp,
-			     struct hist_entry *he)
-{
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_guest_us / hists->stats.total_period;
+		idx_delta = nr_members - prev_idx - 1;
 
-	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%% ", percent);
+		for (i = 0; i < idx_delta; i++) {
+			ret += print_fn(hpp->buf + ret, hpp->size - ret,
+					fmt, 0.0);
+		}
+	}
+	return ret;
 }
 
-static int
-hpp__entry_overhead_guest_us(struct perf_hpp_fmt *_fmt __maybe_unused,
-			     struct perf_hpp *hpp,
-			     struct hist_entry *he)
+static int __hpp__raw_fmt(struct perf_hpp *hpp, struct hist_entry *he,
+			  u64 (*get_field)(struct hist_entry *),
+			  const char *fmt, hpp_snprint_fn print_fn)
 {
-	struct hists *hists = he->hists;
-	double percent = 100.0 * he->stat.period_guest_us / hists->stats.total_period;
-	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%% ";
+	int ret;
+	ret = print_fn(hpp->buf, hpp->size, fmt, get_field(he));
 
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
-}
+	if (symbol_conf.event_group) {
+		int prev_idx, idx_delta, i;
+		struct perf_evsel *evsel = hists_to_evsel(he->hists);
+		struct hist_entry *pair;
+		int nr_members = evsel->nr_members;
 
-static int hpp__header_samples(struct perf_hpp_fmt *_fmt __maybe_unused,
-			       struct perf_hpp *hpp)
-{
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%11s";
+		if (nr_members <= 1)
+			return ret;
 
-	return scnprintf(hpp->buf, hpp->size, fmt, "Samples");
-}
+		prev_idx = perf_evsel__group_idx(evsel);
 
-static int hpp__width_samples(struct perf_hpp_fmt *fmt __maybe_unused,
-			      struct perf_hpp *hpp __maybe_unused)
-{
-	return 11;
-}
+		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
+			evsel = hists_to_evsel(pair->hists);
+			idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
 
-static int hpp__entry_samples(struct perf_hpp_fmt *_fmt __maybe_unused,
-			      struct perf_hpp *hpp, struct hist_entry *he)
-{
-	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%11" PRIu64;
+			for (i = 0; i < idx_delta; i++) {
+				ret += print_fn(hpp->buf + ret, hpp->size - ret,
+						fmt, 0.0);
+			}
 
-	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.nr_events);
-}
+			ret += print_fn(hpp->buf + ret, hpp->size - ret,
+					fmt, get_field(pair));
 
-static int hpp__header_period(struct perf_hpp_fmt *_fmt __maybe_unused,
-			      struct perf_hpp *hpp)
-{
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%12s";
+			prev_idx += 1 + idx_delta;
+		}
 
-	return scnprintf(hpp->buf, hpp->size, fmt, "Period");
-}
+		idx_delta = nr_members - prev_idx - 1;
 
-static int hpp__width_period(struct perf_hpp_fmt *fmt __maybe_unused,
-			     struct perf_hpp *hpp __maybe_unused)
-{
-	return 12;
+		for (i = 0; i < idx_delta; i++) {
+			ret += print_fn(hpp->buf + ret, hpp->size - ret,
+					fmt, 0.0);
+		}
+	}
+	return ret;
 }
 
-static int hpp__entry_period(struct perf_hpp_fmt *_fmt __maybe_unused,
-			     struct perf_hpp *hpp, struct hist_entry *he)
-{
-	const char *fmt = symbol_conf.field_sep ? "%" PRIu64 : "%12" PRIu64;
 
-	return scnprintf(hpp->buf, hpp->size, fmt, he->stat.period);
-}
+#define __HPP_HEADER_FN(_type, _str, _min_width, _unit_width) 		\
+static int hpp__header_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
+			       struct perf_hpp *hpp)			\
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
+static int hpp__width_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
+			      struct perf_hpp *hpp)			\
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
+static u64 he_get_##_field(struct hist_entry *he)				\
+{										\
+	return he->stat._field;							\
+}										\
+										\
+static int hpp__color_##_type(struct perf_hpp_fmt *phf __maybe_unused,		\
+			      struct perf_hpp *hpp, struct hist_entry *he) 	\
+{										\
+	return __hpp__percent_fmt(hpp, he, he_get_##_field, " %6.2f%%",		\
+				  (hpp_snprint_fn)percent_color_snprintf); 	\
+}
+
+#define __HPP_ENTRY_PERCENT_FN(_type, _field)					\
+static int hpp__entry_##_type(struct perf_hpp_fmt *phf __maybe_unused,		\
+			      struct perf_hpp *hpp, struct hist_entry *he) 	\
+{										\
+	const char *fmt = symbol_conf.field_sep ? " %.2f" : " %6.2f%%";		\
+	return __hpp__percent_fmt(hpp, he, he_get_##_field, fmt,		\
+				  scnprintf);					\
+}
+
+#define __HPP_ENTRY_RAW_FN(_type, _field)					\
+static u64 he_get_raw_##_field(struct hist_entry *he)				\
+{										\
+	return he->stat._field;							\
+}										\
+										\
+static int hpp__entry_##_type(struct perf_hpp_fmt *phf __maybe_unused,		\
+			      struct perf_hpp *hpp, struct hist_entry *he) 	\
+{										\
+	const char *fmt = symbol_conf.field_sep ? " %"PRIu64 : " %11"PRIu64;	\
+	return __hpp__raw_fmt(hpp, he, he_get_raw_##_field, fmt, scnprintf);	\
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
+HPP_PERCENT_FNS(overhead_us, "usr", period_us, 8, 8)
+HPP_PERCENT_FNS(overhead_guest_sys, "guest sys", period_guest_sys, 9, 8)
+HPP_PERCENT_FNS(overhead_guest_us, "guest usr", period_guest_us, 9, 8)
+
+HPP_RAW_FNS(samples, "Samples", nr_events, 12, 12)
+HPP_RAW_FNS(period, "Period", period, 12, 12)
 
 #define HPP__COLOR_PRINT_FNS(_name)			\
 	{						\
@@ -248,9 +219,20 @@ struct perf_hpp_fmt perf_hpp__format[] = {
 
 LIST_HEAD(perf_hpp__list);
 
+
 #undef HPP__COLOR_PRINT_FNS
 #undef HPP__PRINT_FNS
 
+#undef HPP_PERCENT_FNS
+#undef HPP_RAW_FNS
+
+#undef __HPP_HEADER_FN
+#undef __HPP_WIDTH_FN
+#undef __HPP_COLOR_PERCENT_FN
+#undef __HPP_ENTRY_PERCENT_FN
+#undef __HPP_ENTRY_RAW_FN
+
+
 void perf_hpp__init(void)
 {
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 531bc7aca772..2fc218a36ba1 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -3,6 +3,7 @@
 #include "../../util/util.h"
 #include "../../util/hist.h"
 #include "../../util/sort.h"
+#include "../../util/evsel.h"
 
 
 static size_t callchain__fprintf_left_margin(FILE *fp, int left_margin)
@@ -347,6 +348,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	struct perf_hpp dummy_hpp = {
 		.buf	= bf,
 		.size	= sizeof(bf),
+		.ptr	= hists_to_evsel(hists),
 	};
 	bool first = true;
 
-- 
1.7.11.7

