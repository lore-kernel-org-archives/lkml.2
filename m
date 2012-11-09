Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab2KIQrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:47:16 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53884 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab2KIQpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:45:13 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 08/12] perf ui/gtk: Add support for event group view
Date: Sat, 10 Nov 2012 01:43:30 +0900
Message-Id: <1352479414-2324-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352479414-2324-1-git-send-email-namhyung@kernel.org>
References: <1352479414-2324-1-git-send-email-namhyung@kernel.org>
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
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/browser.c |   60 +++++++++++++++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 14 deletions(-)

diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 253b6219a39e..293eb4ac5e9c 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -45,26 +45,57 @@ static const char *perf_gtk__get_percent_color(double percent)
 	return NULL;
 }
 
+static int perf_gtk__percent_color_snprintf(char *buf, size_t size,
+					    u64 period, u64 total_period)
+{
+	int ret = 0;
+	const char *markup;
+	double percent = 100.0 * period / total_period;
+
+	markup = perf_gtk__get_percent_color(percent);
+	if (markup)
+		ret += scnprintf(buf, size, markup);
+
+	ret += scnprintf(buf + ret, size - ret, "%6.2f%%", percent);
+
+	if (markup)
+		ret += scnprintf(buf + ret, size - ret, "</span>");
+
+	return ret;
+}
+
+static int perf_gtk__hpp_color_overhead(struct perf_hpp *hpp,
+					struct hist_entry *he)
+{
+	int ret;
+	struct hists *hists = he->hists;
+
+	ret = perf_gtk__percent_color_snprintf(hpp->buf, hpp->size,
+				he->stat.period, hists->stats.total_period);
+
+	if (symbol_conf.event_group) {
+		int i;
+		struct perf_evsel *evsel = hists_2_evsel(hists);
+
+		for (i = 0; i < evsel->nr_members; i++) {
+			ret += scnprintf(hpp->buf + ret, hpp->size - ret, " ");
+			ret += perf_gtk__percent_color_snprintf(hpp->buf + ret,
+					hpp->size - ret,
+					he->group_stats[i].period,
+					hists->group_stats[i].total_period);
+		}
+	}
+	return ret;
+}
+
 #define HPP__COLOR_FN(_name, _field)						\
 static int perf_gtk__hpp_color_ ## _name(struct perf_hpp *hpp,			\
 					 struct hist_entry *he)			\
 {										\
-	struct hists *hists = he->hists;					\
-	double percent = 100.0 * he->stat._field / hists->stats.total_period;	\
-	const char *markup;							\
-	int ret = 0;								\
-										\
-	markup = perf_gtk__get_percent_color(percent);				\
-	if (markup)								\
-		ret += scnprintf(hpp->buf, hpp->size, "%s", markup);		\
-	ret += scnprintf(hpp->buf + ret, hpp->size - ret, "%6.2f%%", percent); 	\
-	if (markup)								\
-		ret += scnprintf(hpp->buf + ret, hpp->size - ret, "</span>"); 	\
-										\
-	return ret;								\
+	return perf_gtk__percent_color_snprintf(hpp->buf, hpp->size, 		\
+			he->stat._field, he->hists->stats.total_period);	\
 }
 
-HPP__COLOR_FN(overhead, period)
 HPP__COLOR_FN(overhead_sys, period_sys)
 HPP__COLOR_FN(overhead_us, period_us)
 HPP__COLOR_FN(overhead_guest_sys, period_guest_sys)
@@ -103,6 +134,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 	struct perf_hpp hpp = {
 		.buf		= s,
 		.size		= sizeof(s),
+		.ptr		= hists_2_evsel(hists),
 	};
 
 	nr_cols = 0;
-- 
1.7.9.2

