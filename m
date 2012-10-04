Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab2JDMxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:53:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62392 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab2JDMwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:52:04 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 15/20] perf ui/hist: Add support for event group view
Date: Thu,  4 Oct 2012 21:49:49 +0900
Message-Id: <1349354994-17853-16-git-send-email-namhyung@kernel.org>
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
 tools/perf/ui/hist.c       |   66 ++++++++++++++++++++++++++++++++++++++++----
 tools/perf/ui/stdio/hist.c |    2 ++
 2 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index f5a1e4f65263..ad4efb772796 100644
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
index fbd4e32d0743..1d4f1ddc8bf8 100644
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
1.7.9.2

