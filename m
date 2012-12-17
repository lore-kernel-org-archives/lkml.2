Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab2LQGl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 01:41:56 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54977 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab2LQGjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 01:39:13 -0500
X-AuditID: 9c930179-b7becae000000e51-84-50cebe0e4bc7
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 09/14] perf gtk/browser: Add support for event group view
Date: Mon, 17 Dec 2012 15:39:00 +0900
Message-Id: <1355726345-29553-10-git-send-email-namhyung@kernel.org>
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

Unlike other hpp backend, GTK+ needs to print dummy 0.00% output since
it's displayed with variable width fonts.  So that simply skipping
with %*s trick won't work well here.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/browser.c | 117 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 94 insertions(+), 23 deletions(-)

diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 0d94b3ba054a..a82e903703b4 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -45,34 +45,104 @@ static const char *perf_gtk__get_percent_color(double percent)
 	return NULL;
 }
 
-#define HPP__COLOR_FN(_name, _field)						\
-static int									\
-perf_gtk__hpp_color_ ## _name(struct perf_hpp_fmt *fmt __maybe_unused,		\
-					 struct perf_hpp *hpp,			\
-					 struct hist_entry *he)			\
+static int perf_gtk__percent_color_snprintf(char *buf, size_t size,
+					    double percent)
+{
+	int ret = 0;
+	const char *markup;
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
+
+static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
+			    u64 (*get_field)(struct hist_entry *))
+{
+	int ret;
+	double percent = 0.0;
+	struct hists *hists = he->hists;
+
+	if (hists->stats.total_period)
+		percent = 100.0 * get_field(he) / hists->stats.total_period;
+
+	ret = perf_gtk__percent_color_snprintf(hpp->buf, hpp->size, percent);
+
+	if (symbol_conf.event_group) {
+		int prev_idx, idx_delta;
+		struct perf_evsel *evsel = hists_to_evsel(hists);
+		struct hist_entry *pair;
+		int nr_members = evsel->nr_members;
+
+		if (nr_members <= 1)
+			return ret;
+
+		prev_idx = perf_evsel__group_idx(evsel);
+
+		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
+			u64 period = get_field(pair);
+			u64 total = pair->hists->stats.total_period;
+
+			evsel = hists_to_evsel(pair->hists);
+			idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
+
+			while (idx_delta--) {
+				ret += scnprintf(hpp->buf + ret, hpp->size -ret, " ");
+				ret += perf_gtk__percent_color_snprintf(hpp->buf + ret,
+									hpp->size - ret,
+									0.0);
+			}
+
+			percent = 100.0 * period / total;
+			ret += scnprintf(hpp->buf + ret, hpp->size -ret, " ");
+			ret += perf_gtk__percent_color_snprintf(hpp->buf + ret,
+								hpp->size - ret,
+								percent);
+
+			prev_idx = perf_evsel__group_idx(evsel);
+		}
+
+		idx_delta = nr_members - prev_idx - 1;
+
+		while (idx_delta--) {
+			ret += scnprintf(hpp->buf + ret, hpp->size -ret, " ");
+			ret += perf_gtk__percent_color_snprintf(hpp->buf + ret,
+								hpp->size - ret,
+								0.0);
+		}
+	}
+	return ret;
+}
+
+#define __HPP_COLOR_PERCENT_FN(_type, _field)					\
+static u64 he_get_##_field(struct hist_entry *he)				\
 {										\
-	struct hists *hists = he->hists;					\
-	double percent = 100.0 * he->stat._field / hists->stats.total_period;	\
-	const char *markup;							\
-	int ret = 0;								\
+	return he->stat._field;							\
+}										\
 										\
-	markup = perf_gtk__get_percent_color(percent);				\
-	if (markup)								\
-		ret += scnprintf(hpp->buf, hpp->size, "%s", markup);		\
-	ret += scnprintf(hpp->buf + ret, hpp->size - ret, "%6.2f%%", percent); 	\
-	if (markup)								\
-		ret += scnprintf(hpp->buf + ret, hpp->size - ret, "</span>"); 	\
-										\
-	return ret;								\
+static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *phf __maybe_unused,	\
+				       struct perf_hpp *hpp,			\
+				       struct hist_entry *he)			\
+{										\
+	return __hpp__color_fmt(hpp, he, he_get_##_field);			\
 }
 
-HPP__COLOR_FN(overhead, period)
-HPP__COLOR_FN(overhead_sys, period_sys)
-HPP__COLOR_FN(overhead_us, period_us)
-HPP__COLOR_FN(overhead_guest_sys, period_guest_sys)
-HPP__COLOR_FN(overhead_guest_us, period_guest_us)
+__HPP_COLOR_PERCENT_FN(overhead, period)
+__HPP_COLOR_PERCENT_FN(overhead_sys, period_sys)
+__HPP_COLOR_PERCENT_FN(overhead_us, period_us)
+__HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys)
+__HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
+
+#undef __HPP_COLOR_PERCENT_FN
 
-#undef HPP__COLOR_FN
 
 void perf_gtk__init_hpp(void)
 {
@@ -106,6 +176,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 	struct perf_hpp hpp = {
 		.buf		= s,
 		.size		= sizeof(s),
+		.ptr		= hists_to_evsel(hists),
 	};
 
 	nr_cols = 0;
-- 
1.7.11.7

