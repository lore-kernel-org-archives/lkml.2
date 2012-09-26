Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab2IZH6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:58:12 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55720 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab2IZH4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:56:11 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-56-5062b517c9e9
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 12/16] perf ui/browser: Add support for event group view
Date: Wed, 26 Sep 2012 16:47:39 +0900
Message-Id: <1348645663-25303-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
References: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
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
 tools/perf/ui/browsers/hists.c | 29 ++++++++++++++++++++++++++++-
 tools/perf/ui/hist.c           |  5 ++++-
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index b9b1b173637c..da3d1e4a44fa 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -565,6 +565,33 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 	return row - first_row;
 }
 
+static int hist_browser__hpp_color_overhead(struct perf_hpp *hpp,
+					    struct hist_entry *he)
+{
+	int ret;
+	double percent = 100.0 * he->stat.period / hpp->total_period;
+
+	/* the leader determines color */
+	*(double *) hpp->ptr = percent;
+
+	ret = scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
+
+	if (symbol_conf.event_group) {
+		int i;
+		struct perf_evsel *evsel = hists_2_evsel(hpp->hists);
+
+		for (i = 0; i < evsel->nr_members; i++) {
+			u64 period = he->group_stats[i].period;
+			u64 total = hpp->hists->group_stats[i].total_period;
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
@@ -574,7 +601,6 @@ static int hist_browser__hpp_color_ ## _name(struct perf_hpp *hpp,	\
 	return scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);	\
 }
 
-HPP__COLOR_FN(overhead, period)
 HPP__COLOR_FN(overhead_sys, period_sys)
 HPP__COLOR_FN(overhead_us, period_us)
 HPP__COLOR_FN(overhead_guest_sys, period_guest_sys)
@@ -625,6 +651,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			.buf		= s,
 			.size		= sizeof(s),
 			.total_period	= browser->hists->stats.total_period,
+			.hists		= browser->hists,
 		};
 
 		ui_browser__gotorc(&browser->b, row, 0);
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index b8e97c3577c1..d8491fcff6ee 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -422,6 +422,9 @@ unsigned int hists__sort_list_width(struct hists *hists)
 {
 	struct sort_entry *se;
 	int i, ret = 0;
+	struct perf_hpp dummy_hpp = {
+		.hists	= hists,
+	};
 
 	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
 		if (!perf_hpp__format[i].cond)
@@ -429,7 +432,7 @@ unsigned int hists__sort_list_width(struct hists *hists)
 		if (i)
 			ret += 2;
 
-		ret += perf_hpp__format[i].width(NULL);
+		ret += perf_hpp__format[i].width(&dummy_hpp);
 	}
 
 	list_for_each_entry(se, &hist_entry__sort_list, list)
-- 
1.7.11.4

