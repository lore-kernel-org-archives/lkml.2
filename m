Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab2JDMwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:52:11 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58823 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881Ab2JDMwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:52:08 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 16/20] perf ui/browser: Add support for event group view
Date: Thu,  4 Oct 2012 21:49:50 +0900
Message-Id: <1349354994-17853-17-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1349354994-17853-1-git-send-email-namhyung@kernel.org>
References: <1349354994-17853-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Show group members' overhead also when showing the leader's if event
group is enabled.  At this time, only implemented overhead part in
order to ease review and other parts can be added later once this
patch settled down.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c |   33 +++++++++++++++++++++++++++++++--
 tools/perf/ui/hist.c           |    5 ++++-
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 0568536ecf67..df0ddeeeb860 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -565,6 +565,34 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 	return row - first_row;
 }
 
+static int hist_browser__hpp_color_overhead(struct perf_hpp *hpp,
+					    struct hist_entry *he)
+{
+	int ret;
+	struct hists *hists = he->hists;
+	double percent = 100.0 * he->stat.period / hists->stats.total_period;
+
+	/* the leader determines color */
+	*(double *) hpp->ptr = percent;
+
+	ret = scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
+
+	if (symbol_conf.event_group) {
+		int i;
+		struct perf_evsel *evsel = hists_2_evsel(hists);
+
+		for (i = 0; i < evsel->nr_members; i++) {
+			u64 period = he->group_stats[i].period;
+			u64 total = hists->group_stats[i].total_period;
+
+			percent = 100.0 * period / total;
+			ret += scnprintf(hpp->buf + ret, hpp->size - ret,
+					 " %6.2f%%", percent);
+		}
+	}
+	return ret;
+}
+
 #define HPP__COLOR_FN(_name, _field)					\
 static int hist_browser__hpp_color_ ## _name(struct perf_hpp *hpp,	\
 					     struct hist_entry *he)	\
@@ -575,7 +603,6 @@ static int hist_browser__hpp_color_ ## _name(struct perf_hpp *hpp,	\
 	return scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);	\
 }
 
-HPP__COLOR_FN(overhead, period)
 HPP__COLOR_FN(overhead_sys, period_sys)
 HPP__COLOR_FN(overhead_us, period_us)
 HPP__COLOR_FN(overhead_guest_sys, period_guest_sys)
@@ -610,6 +637,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 	char folded_sign = ' ';
 	bool current_entry = ui_browser__is_current_entry(&browser->b, row);
 	off_t row_offset = entry->row_offset;
+	bool first = true;
 
 	if (current_entry) {
 		browser->he_selection = entry;
@@ -633,10 +661,11 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			if (!perf_hpp__format[i].cond)
 				continue;
 
-			if (i) {
+			if (!first) {
 				slsmg_printf("  ");
 				width -= 2;
 			}
+			first = false;
 
 			if (perf_hpp__format[i].color) {
 				hpp.ptr = &percent;
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index ad4efb772796..624f3d08937f 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -462,6 +462,9 @@ unsigned int hists__sort_list_width(struct hists *hists)
 {
 	struct sort_entry *se;
 	int i, ret = 0;
+	struct perf_hpp dummy_hpp = {
+		.ptr	= hists_2_evsel(hists),
+	};
 
 	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
 		if (!perf_hpp__format[i].cond)
@@ -469,7 +472,7 @@ unsigned int hists__sort_list_width(struct hists *hists)
 		if (i)
 			ret += 2;
 
-		ret += perf_hpp__format[i].width(NULL);
+		ret += perf_hpp__format[i].width(&dummy_hpp);
 	}
 
 	list_for_each_entry(se, &hist_entry__sort_list, list)
-- 
1.7.9.2

