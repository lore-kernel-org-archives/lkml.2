Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab2JWHoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:44:44 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46570 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab2JWHol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:44:41 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-50-50864ae6c84f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/12] perf ui/hist: Add support for event group view
Date: Tue, 23 Oct 2012 16:44:00 +0900
Message-Id: <1350978246-3686-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1350978246-3686-1-git-send-email-namhyung@kernel.org>
References: <1350978246-3686-1-git-send-email-namhyung@kernel.org>
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
Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c       | 66 ++++++++++++++++++++++++++++++++++++++++++----
 tools/perf/ui/stdio/hist.c |  2 ++
 2 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 4f5f4756faac..c406c94cbe53 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -3,34 +3,90 @@
 #include "../util/hist.h"
 #include "../util/util.h"
 #include "../util/sort.h"
+#include "../util/evsel.h"
 
 
 /* hist period print (hpp) functions */
 static int hpp__header_overhead(struct perf_hpp *hpp)
 {
-	return scnprintf(hpp->buf, hpp->size, "Overhead");
+	int len = 8;
+
+	if (symbol_conf.event_group) {
+		struct perf_evsel *evsel = hpp->ptr;
+
+		BUG_ON(!perf_evsel__is_group_leader(evsel));
+
+		len += evsel->nr_members * 8;
+	}
+	return scnprintf(hpp->buf, hpp->size, "%*s", len, "Overhead");
 }
 
-static int hpp__width_overhead(struct perf_hpp *hpp __maybe_unused)
+static int hpp__width_overhead(struct perf_hpp *hpp)
 {
-	return 8;
+	int len = 8;
+
+	if (symbol_conf.event_group) {
+		struct perf_evsel *evsel = hpp->ptr;
+
+		len += evsel->nr_members * 8;
+	}
+	return len;
 }
 
 static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 {
+	int ret;
 	struct hists *hists = he->hists;
 	double percent = 100.0 * he->stat.period / hists->stats.total_period;
 
-	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
+	ret = percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
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
 	struct hists *hists = he->hists;
 	double percent = 100.0 * he->stat.period / hists->stats.total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
 
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
+	ret = scnprintf(hpp->buf, hpp->size, fmt, percent);
+
+	if (symbol_conf.event_group) {
+		int i;
+		struct perf_evsel *evsel = hists_2_evsel(hists);
+
+		for (i = 0; i < evsel->nr_members; i++) {
+			u64 period = he->group_stats[i].period;
+			u64 total = hists->group_stats[i].total_period;
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
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index f0ee204f99bb..ca5ee86ab437 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -3,6 +3,7 @@
 #include "../../util/util.h"
 #include "../../util/hist.h"
 #include "../../util/sort.h"
+#include "../../util/evsel.h"
 
 
 static size_t callchain__fprintf_left_margin(FILE *fp, int left_margin)
@@ -346,6 +347,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	struct perf_hpp dummy_hpp = {
 		.buf	= bf,
 		.size	= sizeof(bf),
+		.ptr	= hists_2_evsel(hists),
 	};
 	bool first = true;
 
-- 
1.7.11.7

