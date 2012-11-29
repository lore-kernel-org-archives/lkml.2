Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab2K2GjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:39:17 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44879 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab2K2GjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:39:14 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-d3-50b7030a01bd
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 13/18] perf hist browser: Add support for event group view
Date: Thu, 29 Nov 2012 15:38:41 +0900
Message-Id: <1354171126-14387-15-git-send-email-namhyung@kernel.org>
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
 tools/perf/ui/browsers/hists.c | 171 ++++++++++++++++++++++++++++++++++-------
 tools/perf/ui/hist.c           |   5 +-
 2 files changed, 146 insertions(+), 30 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index ccc4bd161420..7ac47adc8e09 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -567,23 +567,145 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 	return row - first_row;
 }
 
-#define HPP__COLOR_FN(_name, _field)					\
-static int hist_browser__hpp_color_ ## _name(struct perf_hpp *hpp,	\
-					     struct hist_entry *he)	\
-{									\
-	struct hists *hists = he->hists;				\
-	double percent = 100.0 * he->stat._field / hists->stats.total_period; \
-	*(double *)hpp->ptr = percent;					\
-	return scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);	\
+struct hpp_arg {
+	struct ui_browser *b;
+	char folded_sign;
+	bool current_entry;
+};
+
+static int hist_browser__hpp_color_overhead(struct perf_hpp *hpp,
+					    struct hist_entry *he)
+{
+	int ret;
+	double percent = 0.0;
+	struct hists *hists = he->hists;
+	struct hpp_arg *arg = hpp->ptr;
+
+	if (hists->stats.total_period)
+		percent = 100.0 * he->stat.period / hists->stats.total_period;
+
+	ui_browser__set_percent_color(arg->b, percent, arg->current_entry);
+
+	if (symbol_conf.use_callchain) {
+		slsmg_printf("%c ", arg->folded_sign);
+		ret += 2;
+	}
+
+	ret = scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
+	slsmg_printf("%s", hpp->buf);
+
+	if (symbol_conf.event_group) {
+		int i;
+		struct perf_evsel *evsel = hists_to_evsel(hists);
+		struct hist_entry *pair;
+		int nr_members = evsel->nr_members;
+		double *percents;
+
+		if (nr_members <= 1)
+			goto out;
+
+		percents = zalloc(sizeof(*percents) * nr_members);
+		if (percents == NULL) {
+			pr_warning("Not enough memory!\n");
+			goto out;
+		}
+
+		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
+			int idx;
+			u64 period = pair->stat.period;
+			u64 total = pair->hists->stats.total_period;
+
+			if (!total)
+				continue;
+
+			evsel = hists_to_evsel(pair->hists);
+			idx = perf_evsel__group_idx(evsel);
+			percents[idx] = 100.0 * period / total;
+		}
+
+		for (i = 1; i < nr_members; i++) {
+			ui_browser__set_percent_color(arg->b, percents[i],
+						      arg->current_entry);
+			ret += scnprintf(hpp->buf, hpp->size,
+					 " %6.2f%%", percents[i]);
+			slsmg_printf("%s", hpp->buf);
+		}
+		free(percents);
+	}
+out:
+	if (!arg->current_entry || !arg->b->navkeypressed)
+		ui_browser__set_color(arg->b, HE_COLORSET_NORMAL);
+
+	return ret;
+}
+
+#define __HPP_COLOR_PERCENT_FN(_type, _field)					\
+static int hist_browser__hpp_color_##_type(struct perf_hpp *hpp, 		\
+					   struct hist_entry *he)		\
+{										\
+	int ret;								\
+	double percent = 0.0;							\
+	struct hists *hists = he->hists;					\
+	struct hpp_arg *arg = hpp->ptr;						\
+										\
+	if (hists->stats.total_period)						\
+		percent = 100.0 * he->stat._field / hists->stats.total_period;	\
+										\
+	ui_browser__set_percent_color(arg->b, percent, arg->current_entry); 	\
+	ret = scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);		\
+	slsmg_printf("%s", hpp->buf);						\
+										\
+	if (symbol_conf.event_group) {						\
+		int i;								\
+		struct perf_evsel *evsel = hists_to_evsel(hists);		\
+		struct hist_entry *pair;					\
+		int nr_members = evsel->nr_members;				\
+		double *percents;						\
+										\
+		if (nr_members <= 1)						\
+			goto out;						\
+										\
+		percents = zalloc(sizeof(*percents) * nr_members);		\
+		if (percents == NULL) {						\
+			pr_warning("Not enough memory!\n");			\
+			goto out;						\
+		}								\
+										\
+		list_for_each_entry(pair, &he->pairs.head, pairs.node) { 	\
+			int idx;						\
+			u64 period = pair->stat._field;				\
+			u64 total = pair->hists->stats.total_period;		\
+										\
+			if (!total)						\
+				continue;					\
+										\
+			evsel = hists_to_evsel(pair->hists);			\
+			idx = perf_evsel__group_idx(evsel);			\
+			percents[idx] = 100.0 * period / total;			\
+		}								\
+										\
+		for (i = 1; i < nr_members; i++) {				\
+			ui_browser__set_percent_color(arg->b, percents[i],	\
+						      arg->current_entry); 	\
+			ret += scnprintf(hpp->buf, hpp->size,			\
+					 " %6.2f%%", percents[i]);		\
+			slsmg_printf("%s", hpp->buf);				\
+		}								\
+		free(percents);							\
+	}									\
+out:										\
+	if (!arg->current_entry || !arg->b->navkeypressed)			\
+		ui_browser__set_color(arg->b, HE_COLORSET_NORMAL);		\
+										\
+	return ret;								\
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
@@ -606,7 +728,6 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 				    unsigned short row)
 {
 	char s[256];
-	double percent;
 	int i, printed = 0;
 	int width = browser->b.width;
 	char folded_sign = ' ';
@@ -625,9 +746,15 @@ static int hist_browser__show_entry(struct hist_browser *browser,
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
 
 		ui_browser__gotorc(&browser->b, row, 0);
@@ -643,21 +770,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			first = false;
 
 			if (perf_hpp__format[i].color) {
-				hpp.ptr = &percent;
-				/* It will set percent for us. See HPP__COLOR_FN above. */
 				width -= perf_hpp__format[i].color(&hpp, entry);
-
-				ui_browser__set_percent_color(&browser->b, percent, current_entry);
-
-				if (i == PERF_HPP__OVERHEAD && symbol_conf.use_callchain) {
-					slsmg_printf("%c ", folded_sign);
-					width -= 2;
-				}
-
-				slsmg_printf("%s", s);
-
-				if (!current_entry || !browser->b.navkeypressed)
-					ui_browser__set_color(&browser->b, HE_COLORSET_NORMAL);
 			} else {
 				width -= perf_hpp__format[i].entry(&hpp, entry);
 				slsmg_printf("%s", s);
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index b42bd15af3f5..118274f29bb7 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -514,6 +514,9 @@ unsigned int hists__sort_list_width(struct hists *hists)
 {
 	struct sort_entry *se;
 	int i, ret = 0;
+	struct perf_hpp dummy_hpp = {
+		.ptr	= hists_to_evsel(hists),
+	};
 
 	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
 		if (!perf_hpp__format[i].cond)
@@ -521,7 +524,7 @@ unsigned int hists__sort_list_width(struct hists *hists)
 		if (i)
 			ret += 2;
 
-		ret += perf_hpp__format[i].width(NULL);
+		ret += perf_hpp__format[i].width(&dummy_hpp);
 	}
 
 	list_for_each_entry(se, &hist_entry__sort_list, list)
-- 
1.7.11.7

