Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab2GXJG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 05:06:59 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55075 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab2GXJG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 05:06:58 -0400
X-AuditID: 9c930179-b7bdcae000003d91-f8-500e65b1a2ff
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Ulrich Drepper <drepper@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 01/12] perf tools: Add a couple of helper routines to handle groups
Date: Tue, 24 Jul 2012 18:01:22 +0900
Message-Id: <1343120493-23059-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1343120493-23059-1-git-send-email-namhyung@kernel.org>
References: <1343120493-23059-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation for upcoming event grouping feature.

Cc: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evsel.h        |   19 +++++++++++++++++++
 tools/perf/util/parse-events.c |    6 +++++-
 tools/perf/util/sort.h         |   10 ++++++++++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index a4a11f8dfcf5..efc9e5c42210 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -70,8 +70,27 @@ struct perf_evsel {
 	int			exclude_GH;
 	struct perf_evsel	*leader;
 	char			*group_name;
+	union {
+		int		nr_children;
+		int		group_idx;
+	};
 };
 
+static inline struct perf_evsel *hists_2_evsel(struct hists *hists)
+{
+	return container_of(hists, struct perf_evsel, hists);
+}
+
+static inline bool perf_evsel__is_group_leader(struct perf_evsel *evsel)
+{
+	return evsel->leader == NULL;
+}
+
+#define for_each_group_member(_evsel, _leader)				   \
+for ((_evsel) = list_entry((_leader)->node.next, struct perf_evsel, node); \
+     (_evsel) && (_evsel)->leader == (_leader);				   \
+     (_evsel) = list_entry((_evsel)->node.next, struct perf_evsel, node))
+
 struct cpu_map;
 struct thread_map;
 struct perf_evlist;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9eaae05c088d..25dcf9043902 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -611,15 +611,19 @@ int parse_events_add_pmu(struct list_head **list, int *idx,
 
 struct perf_evsel *parse_events__group_leader(struct list_head *list)
 {
+	int idx = 0;
 	struct perf_evsel *evsel, *leader;
 
 	leader = list_entry(list->next, struct perf_evsel, node);
 	leader->leader = NULL;
 
 	list_for_each_entry(evsel, list, node)
-		if (evsel != leader)
+		if (evsel != leader) {
 			evsel->leader = leader;
+			evsel->group_idx = idx++;
+		}
 
+	leader->nr_children = idx;
 	return leader;
 }
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index e724b26acd51..9fdd5039339f 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -43,6 +43,15 @@ extern struct sort_entry sort_sym_from;
 extern struct sort_entry sort_sym_to;
 extern enum sort_type sort__first_dimension;
 
+struct he_stat {
+	u64			period;
+	u64			period_sys;
+	u64			period_us;
+	u64			period_guest_sys;
+	u64			period_guest_us;
+	u32			nr_events;
+};
+
 /**
  * struct hist_entry - histogram entry
  *
@@ -57,6 +66,7 @@ struct hist_entry {
 	u64			period_us;
 	u64			period_guest_sys;
 	u64			period_guest_us;
+	struct he_stat		*group_stats;
 	struct map_symbol	ms;
 	struct thread		*thread;
 	u64			ip;
-- 
1.7.10.4

