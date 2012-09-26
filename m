Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2IZH6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:58:30 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44645 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab2IZH4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:56:11 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-51-5062b51637f3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 11/16] perf ui/hist: Add support for event group view
Date: Wed, 26 Sep 2012 16:47:38 +0900
Message-Id: <1348645663-25303-12-git-send-email-namhyung@kernel.org>
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
 tools/perf/ui/hist.c       | 67 +++++++++++++++++++++++++++++++++++++++++-----
 tools/perf/ui/stdio/hist.c |  2 ++
 tools/perf/util/hist.h     |  1 +
 3 files changed, 63 insertions(+), 7 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index d6ddeb10e678..b8e97c3577c1 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -3,23 +3,40 @@
 #include "../util/hist.h"
 #include "../util/util.h"
 #include "../util/sort.h"
+#include "../util/evsel.h"
 
 
 /* hist period print (hpp) functions */
 static int hpp__header_overhead(struct perf_hpp *hpp)
 {
+	int len = 8;
 	const char *fmt = hpp->ptr ? "Baseline" : "Overhead";
 
-	return scnprintf(hpp->buf, hpp->size, fmt);
+	if (symbol_conf.event_group) {
+		struct perf_evsel *evsel = hists_2_evsel(hpp->hists);
+
+		BUG_ON(!perf_evsel__is_group_leader(evsel));
+
+		len += evsel->nr_members * 8;
+	}
+	return scnprintf(hpp->buf, hpp->size, "%*s", len, fmt);
 }
 
-static int hpp__width_overhead(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_overhead(struct perf_hpp *hpp)
 {
-	return 8;
+	int len = 8;
+
+	if (symbol_conf.event_group) {
+		struct perf_evsel *evsel = hists_2_evsel(hpp->hists);
+
+		len += evsel->nr_members * 8;
+	}
+	return len;
 }
 
 static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 {
+	int ret;
 	double percent = 100.0 * he->stat.period / hpp->total_period;
 
 	if (hpp->ptr) {
@@ -33,11 +50,29 @@ static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 			percent = 0.0;
 	}
 
-	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
+	ret = percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
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
+			ret += percent_color_snprintf(hpp->buf + ret,
+						      hpp->size - ret,
+						      " %6.2f%%", percent);
+		}
+
+	}
+	return ret;
 }
 
 static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 {
+	int ret;
 	double percent = 100.0 * he->stat.period / hpp->total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
 
@@ -52,13 +87,32 @@ static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 			percent = 0.0;
 	}
 
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
+	ret = scnprintf(hpp->buf, hpp->size, fmt, percent);
+
+	if (symbol_conf.event_group) {
+		int i;
+		struct perf_evsel *evsel = hists_2_evsel(hpp->hists);
+
+		for (i = 0; i < evsel->nr_members; i++) {
+			u64 period = he->group_stats[i].period;
+			u64 total = hpp->hists->group_stats[i].total_period;
+
+			if (symbol_conf.field_sep) {
+				ret += scnprintf(hpp->buf + ret,
+						 hpp->size - ret, " ");
+			}
+			percent = 100.0 * period / total;
+			ret += scnprintf(hpp->buf + ret, hpp->size - ret,
+					 fmt, percent);
+		}
+
+	}
+	return ret;
 }
 
 static int hpp__header_overhead_sys(struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
-
 	return scnprintf(hpp->buf, hpp->size, fmt, "sys");
 }
 
@@ -84,7 +138,6 @@ static int hpp__entry_overhead_sys(struct perf_hpp *hpp, struct hist_entry *he)
 static int hpp__header_overhead_us(struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%7s";
-
 	return scnprintf(hpp->buf, hpp->size, fmt, "user");
 }
 
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 4382a1995cda..8c417f036613 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -316,6 +316,7 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 		.buf		= bf,
 		.size		= size,
 		.total_period	= total_period,
+		.hists		= hists,
 		.displacement	= displacement,
 		.ptr		= pair_hists,
 	};
@@ -354,6 +355,7 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 	struct perf_hpp dummy_hpp = {
 		.buf	= bf,
 		.size	= sizeof(bf),
+		.hists	= hists,
 		.ptr	= pair,
 	};
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index e13db91bc246..a7ccaad65f21 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -120,6 +120,7 @@ struct perf_hpp {
 	char *buf;
 	size_t size;
 	u64 total_period;
+	struct hists* hists;
 	const char *sep;
 	long displacement;
 	void *ptr;
-- 
1.7.11.4

