Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab2LQGjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 01:39:22 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56269 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2LQGjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 01:39:12 -0500
X-AuditID: 9c930179-b7becae000000e51-7e-50cebe0d75f7
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 08/14] perf hist browser: Add support for event group view
Date: Mon, 17 Dec 2012 15:38:59 +0900
Message-Id: <1355726345-29553-9-git-send-email-namhyung@kernel.org>
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

Also move coloring logic into the hpp function so that each value can
be colored independently.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 159 ++++++++++++++++++++++++++++++++---------
 tools/perf/ui/hist.c           |   5 +-
 2 files changed, 130 insertions(+), 34 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index d774efcc46d8..b467546ce7d4 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -567,25 +567,130 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 	return row - first_row;
 }
 
-#define HPP__COLOR_FN(_name, _field)					\
-static int hist_browser__hpp_color_ ## _name(				\
-			struct perf_hpp_fmt *fmt __maybe_unused,	\
-			struct perf_hpp *hpp,				\
-			struct hist_entry *he)				\
+struct hpp_arg {
+	struct ui_browser *b;
+	char folded_sign;
+	bool current_entry;
+};
+
+static int hist_browser__hpp_color_callchain(struct hpp_arg *arg)
+{
+	if (!symbol_conf.use_callchain)
+		return 0;
+
+	slsmg_printf("%c ", arg->folded_sign);
+	return 2;
+}
+
+static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
+			    u64 (*get_field)(struct hist_entry *),
+			    int (*callchain_cb)(struct hpp_arg *))
+{
+	int ret = 0;
+	double percent = 0.0;
+	struct hists *hists = he->hists;
+	struct hpp_arg *arg = hpp->ptr;
+
+	if (hists->stats.total_period)
+		percent = 100.0 * get_field(he) / hists->stats.total_period;
+
+	ui_browser__set_percent_color(arg->b, percent, arg->current_entry);
+
+	if (callchain_cb)
+		ret += callchain_cb(arg);
+
+	ret += scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
+	slsmg_printf("%s", hpp->buf);
+
+	if (symbol_conf.event_group) {
+		int prev_idx, idx_delta, i;
+		struct perf_evsel *evsel = hists_to_evsel(hists);
+		struct hist_entry *pair;
+		int nr_members = evsel->nr_members;
+
+		if (nr_members <= 1)
+			goto out;
+
+		prev_idx = perf_evsel__group_idx(evsel);
+
+		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
+			u64 period = get_field(pair);
+			u64 total = pair->hists->stats.total_period;
+
+			if (!total)
+				continue;
+
+			evsel = hists_to_evsel(pair->hists);
+			idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
+
+			for (i = 0; i < idx_delta; i++) {
+				ui_browser__set_percent_color(arg->b, 0.0,
+							arg->current_entry);
+				ret += scnprintf(hpp->buf, hpp->size,
+						 " %6.2f%%", 0.0);
+				slsmg_printf("%s", hpp->buf);
+			}
+
+			percent = 100.0 * period / total;
+			ui_browser__set_percent_color(arg->b, percent,
+						      arg->current_entry);
+			ret += scnprintf(hpp->buf, hpp->size,
+					 " %6.2f%%", percent);
+			slsmg_printf("%s", hpp->buf);
+
+			prev_idx += 1 + idx_delta;
+		}
+
+		idx_delta = nr_members - prev_idx - 1;
+
+		for (i = 0; i < idx_delta; i++) {
+			ui_browser__set_percent_color(arg->b, 0.0,
+						      arg->current_entry);
+			ret += scnprintf(hpp->buf, hpp->size, " %6.2f%%", 0.0);
+			slsmg_printf("%s", hpp->buf);
+		}
+	}
+out:
+	if (!arg->current_entry || !arg->b->navkeypressed)
+		ui_browser__set_color(arg->b, HE_COLORSET_NORMAL);
+
+	return ret;
+}
+
+static u64 __hpp_get_period(struct hist_entry *he)
+{
+	return he->stat.period;
+}
+
+static int hist_browser__hpp_color_overhead(struct perf_hpp_fmt *fmt
+						__maybe_unused,
+					    struct perf_hpp *hpp,
+					    struct hist_entry *he)
+{
+	return __hpp__color_fmt(hpp, he, __hpp_get_period,
+				hist_browser__hpp_color_callchain);
+}
+
+#define __HPP_COLOR_PERCENT_FN(_type, _field)				\
+static u64 __hpp_get_##_field(struct hist_entry *he)			\
+{									\
+	return he->stat._field;						\
+}									\
+									\
+static int hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt	\
+						__maybe_unused,		\
+					   struct perf_hpp *hpp,	\
+					   struct hist_entry *he)	\
 {									\
-	struct hists *hists = he->hists;				\
-	double percent = 100.0 * he->stat._field / hists->stats.total_period; \
-	*(double *)hpp->ptr = percent;					\
-	return scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);	\
+	return __hpp__color_fmt(hpp, he, __hpp_get_##_field, NULL);	\
 }
 
-HPP__COLOR_FN(overhead, period)
-HPP__COLOR_FN(overhead_sys, period_sys)
-HPP__COLOR_FN(overhead_us, period_us)
-HPP__COLOR_FN(overhead_guest_sys, period_guest_sys)
-HPP__COLOR_FN(overhead_guest_us, period_guest_us)
+__HPP_COLOR_PERCENT_FN(overhead_sys, period_sys)
+__HPP_COLOR_PERCENT_FN(overhead_us, period_us)
+__HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys)
+__HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
 
-#undef HPP__COLOR_FN
+#undef __HPP_COLOR_PERCENT_FN
 
 void hist_browser__init_hpp(void)
 {
@@ -608,7 +713,6 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 				    unsigned short row)
 {
 	char s[256];
-	double percent;
 	int printed = 0;
 	int width = browser->b.width;
 	char folded_sign = ' ';
@@ -628,11 +732,16 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 	}
 
 	if (row_offset == 0) {
+		struct hpp_arg arg = {
+			.b		= &browser->b,
+			.folded_sign	= folded_sign,
+			.current_entry	= current_entry,
+		};
 		struct perf_hpp hpp = {
 			.buf		= s,
 			.size		= sizeof(s),
+			.ptr		= &arg,
 		};
-		int i = 0;
 
 		ui_browser__gotorc(&browser->b, row, 0);
 
@@ -645,27 +754,11 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			first = false;
 
 			if (fmt->color) {
-				hpp.ptr = &percent;
-				/* It will set percent for us. See HPP__COLOR_FN above. */
 				width -= fmt->color(fmt, &hpp, entry);
-
-				ui_browser__set_percent_color(&browser->b, percent, current_entry);
-
-				if (!i && symbol_conf.use_callchain) {
-					slsmg_printf("%c ", folded_sign);
-					width -= 2;
-				}
-
-				slsmg_printf("%s", s);
-
-				if (!current_entry || !browser->b.navkeypressed)
-					ui_browser__set_color(&browser->b, HE_COLORSET_NORMAL);
 			} else {
 				width -= fmt->entry(fmt, &hpp, entry);
 				slsmg_printf("%s", s);
 			}
-
-			i++;
 		}
 
 		/* The scroll bar isn't being used */
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index ea605be78a29..22480c0c0803 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -332,12 +332,15 @@ unsigned int hists__sort_list_width(struct hists *hists)
 	struct perf_hpp_fmt *fmt;
 	struct sort_entry *se;
 	int i = 0, ret = 0;
+	struct perf_hpp dummy_hpp = {
+		.ptr	= hists_to_evsel(hists),
+	};
 
 	perf_hpp__for_each_format(fmt) {
 		if (i)
 			ret += 2;
 
-		ret += fmt->width(fmt, NULL);
+		ret += fmt->width(fmt, &dummy_hpp);
 	}
 
 	list_for_each_entry(se, &hist_entry__sort_list, list)
-- 
1.7.11.7

