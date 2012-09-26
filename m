Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab2IZH5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:57:55 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54410 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab2IZH4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:56:12 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-58-5062b5176a3e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 13/16] perf ui/gtk: Add support for event group view
Date: Wed, 26 Sep 2012 16:47:40 +0900
Message-Id: <1348645663-25303-14-git-send-email-namhyung@kernel.org>
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
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/browser.c | 58 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 13 deletions(-)

diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 7107edc6c08d..775f209fe795 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -45,25 +45,56 @@ static const char *perf_gtk__get_percent_color(double percent)
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
+
+	ret = perf_gtk__percent_color_snprintf(hpp->buf, hpp->size,
+				       he->stat.period, hpp->total_period);
+
+	if (symbol_conf.event_group) {
+		int i;
+		struct perf_evsel *evsel = hists_2_evsel(hpp->hists);
+
+		for (i = 0; i < evsel->nr_members; i++) {
+			ret += scnprintf(hpp->buf + ret, hpp->size - ret, " ");
+			ret += perf_gtk__percent_color_snprintf(hpp->buf + ret,
+					hpp->size - ret,
+					he->group_stats[i].period,
+					hpp->hists->group_stats[i].total_period);
+		}
+	}
+	return ret;
+}
+
 #define HPP__COLOR_FN(_name, _field)						\
 static int perf_gtk__hpp_color_ ## _name(struct perf_hpp *hpp,			\
 					 struct hist_entry *he)			\
 {										\
-	double percent = 100.0 * he->stat._field / hpp->total_period;		\
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
+					he->stat._field, hpp->total_period);	\
 }
 
-HPP__COLOR_FN(overhead, period)
 HPP__COLOR_FN(overhead_sys, period_sys)
 HPP__COLOR_FN(overhead_us, period_us)
 HPP__COLOR_FN(overhead_guest_sys, period_guest_sys)
@@ -103,6 +134,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 		.buf		= s,
 		.size		= sizeof(s),
 		.total_period	= hists->stats.total_period,
+		.hists		= hists,
 	};
 
 	nr_cols = 0;
-- 
1.7.11.4

