Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab2LQGjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 01:39:17 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56269 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2LQGjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 01:39:11 -0500
X-AuditID: 9c930179-b7becae000000e51-77-50cebe0d043c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 06/14] perf hists: Resort hist entries using group members for output
Date: Mon, 17 Dec 2012 15:38:57 +0900
Message-Id: <1355726345-29553-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
References: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When event group is enabled, sorting hist entries on periods for
output should consider groups members' period also.  To do that, build
period table using link/pair information and compare the table.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evsel.h |  2 ++
 tools/perf/util/hist.c  | 59 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3b48b87d7e2d..e86402ddaa71 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -78,6 +78,8 @@ struct perf_evsel {
 	char			*group_name;
 };
 
+#define hists_to_evsel(h) container_of(h, struct perf_evsel, hists)
+
 struct cpu_map;
 struct thread_map;
 struct perf_evlist;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 677d1c96be02..7ed93842d489 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -4,6 +4,7 @@
 #include "hist.h"
 #include "session.h"
 #include "sort.h"
+#include "evsel.h"
 #include <math.h>
 
 static bool hists__filter_entry_by_dso(struct hists *hists,
@@ -529,6 +530,62 @@ void hists__collapse_resort_threaded(struct hists *hists)
  * reverse the map, sort on period.
  */
 
+static int period_cmp(u64 period_a, u64 period_b)
+{
+	if (period_a > period_b)
+		return 1;
+	if (period_a < period_b)
+		return -1;
+	return 0;
+}
+
+static int hist_entry__sort_on_period(struct hist_entry *a,
+				      struct hist_entry *b)
+{
+	int ret;
+	int i, nr_members;
+	struct perf_evsel *evsel;
+	struct hist_entry *pair;
+	u64 *periods_a, *periods_b;
+
+	ret = period_cmp(a->stat.period, b->stat.period);
+	if (ret || !symbol_conf.event_group)
+		return ret;
+
+	evsel = hists_to_evsel(a->hists);
+	nr_members = evsel->nr_members;
+	if (nr_members <= 1)
+		return ret;
+
+	periods_a = zalloc(sizeof(periods_a) * nr_members);
+	periods_b = zalloc(sizeof(periods_b) * nr_members);
+
+	if (!periods_a || !periods_b)
+		goto out;
+
+	list_for_each_entry(pair, &a->pairs.head, pairs.node) {
+		evsel = hists_to_evsel(pair->hists);
+		periods_a[perf_evsel__group_idx(evsel)] = pair->stat.period;
+	}
+
+	list_for_each_entry(pair, &b->pairs.head, pairs.node) {
+		evsel = hists_to_evsel(pair->hists);
+		periods_b[perf_evsel__group_idx(evsel)] = pair->stat.period;
+	}
+
+	for (i = 1; i < nr_members; i++) {
+		ret = period_cmp(periods_a[i], periods_b[i]);
+		if (ret)
+			break;
+	}
+
+out:
+	free(periods_a);
+	free(periods_b);
+
+	return ret;
+}
+
 static void __hists__insert_output_entry(struct rb_root *entries,
 					 struct hist_entry *he,
 					 u64 min_callchain_hits)
@@ -545,7 +602,7 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node);
 
-		if (he->stat.period > iter->stat.period)
+		if (hist_entry__sort_on_period(he, iter) > 0)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
-- 
1.7.11.7

