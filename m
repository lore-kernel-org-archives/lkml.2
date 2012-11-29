Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab2K2GjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:39:21 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50052 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab2K2GjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:39:14 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-d9-50b7030bce3c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 14/18] perf gtk/browser: Add support for event group view
Date: Thu, 29 Nov 2012 15:38:42 +0900
Message-Id: <1354171126-14387-16-git-send-email-namhyung@kernel.org>
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
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/browser.c | 87 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 70 insertions(+), 17 deletions(-)

diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 253b6219a39e..04ed0cbbc090 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -45,30 +45,82 @@ static const char *perf_gtk__get_percent_color(double percent)
 	return NULL;
 }
 
-#define HPP__COLOR_FN(_name, _field)						\
-static int perf_gtk__hpp_color_ ## _name(struct perf_hpp *hpp,			\
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
+#define __HPP_COLOR_PERCENT_FN(_type, _field)					\
+static int perf_gtk__hpp_color_##_type(struct perf_hpp *hpp,			\
+				       struct hist_entry *he)			\
 {										\
+	int ret;								\
+	double percent = 0.0;							\
 	struct hists *hists = he->hists;					\
-	double percent = 100.0 * he->stat._field / hists->stats.total_period;	\
-	const char *markup;							\
-	int ret = 0;								\
 										\
-	markup = perf_gtk__get_percent_color(percent);				\
-	if (markup)								\
-		ret += scnprintf(hpp->buf, hpp->size, "%s", markup);		\
-	ret += scnprintf(hpp->buf + ret, hpp->size - ret, "%6.2f%%", percent); 	\
-	if (markup)								\
-		ret += scnprintf(hpp->buf + ret, hpp->size - ret, "</span>"); 	\
+	if (hists->stats.total_period)						\
+		percent = 100.0 * he->stat._field / hists->stats.total_period; 	\
+										\
+	ret = perf_gtk__percent_color_snprintf(hpp->buf, hpp->size, percent);	\
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
 										\
+		for (i = 1; i < nr_members; i++) {				\
+			ret += scnprintf(hpp->buf + ret, hpp->size -ret, " ");	\
+			ret += perf_gtk__percent_color_snprintf(hpp->buf + ret,	\
+								hpp->size - ret,\
+								percents[i]);	\
+		}								\
+		free(percents);							\
+	}									\
 	return ret;								\
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
 
 #undef HPP__COLOR_FN
 
@@ -103,6 +155,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 	struct perf_hpp hpp = {
 		.buf		= s,
 		.size		= sizeof(s),
+		.ptr		= hists_to_evsel(hists),
 	};
 
 	nr_cols = 0;
-- 
1.7.11.7

