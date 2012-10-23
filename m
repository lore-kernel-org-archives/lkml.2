Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab2JWHom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:44:42 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46570 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab2JWHoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:44:39 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-44-50864ae5f782
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/12] perf tools: Keep group information
Date: Tue, 23 Oct 2012 16:43:55 +0900
Message-Id: <1350978246-3686-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1350978246-3686-1-git-send-email-namhyung@kernel.org>
References: <1350978246-3686-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add a few of group-related field in struct perf_{evlist,evsel} so that
the group information in a evlist can be known easily.  It only counts
groups which have more than 1 members since leader-only groups are
treated as non-group events.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evlist.c       | 10 ++++++++--
 tools/perf/util/evlist.h       |  1 +
 tools/perf/util/evsel.h        | 10 ++++++++++
 tools/perf/util/parse-events.c |  1 +
 tools/perf/util/parse-events.h |  1 +
 tools/perf/util/parse-events.y | 10 ++++++++++
 6 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a41dc4a5c2de..561bdfbf8d4f 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -111,20 +111,26 @@ void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 void __perf_evlist__set_leader(struct list_head *list)
 {
 	struct perf_evsel *evsel, *leader;
+	int count = 0;
 
 	leader = list_entry(list->next, struct perf_evsel, node);
 	leader->leader = NULL;
 
 	list_for_each_entry(evsel, list, node) {
-		if (evsel != leader)
+		if (evsel != leader) {
 			evsel->leader = leader;
+			evsel->group_idx = count++;
+		}
 	}
+	leader->nr_members = count;
 }
 
 void perf_evlist__set_leader(struct perf_evlist *evlist)
 {
-	if (evlist->nr_entries)
+	if (evlist->nr_entries) {
+		evlist->nr_groups = evlist->nr_entries > 1 ? 1 : 0;
 		__perf_evlist__set_leader(&evlist->entries);
+	}
 }
 
 int perf_evlist__add_default(struct perf_evlist *evlist)
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 56003f779e60..fa76bf91c7e0 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -21,6 +21,7 @@ struct perf_evlist {
 	struct list_head entries;
 	struct hlist_head heads[PERF_EVLIST__HLIST_SIZE];
 	int		 nr_entries;
+	int		 nr_groups;
 	int		 nr_fds;
 	int		 nr_mmaps;
 	int		 mmap_len;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3ead0d59c03d..407c8e84fee3 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -74,6 +74,10 @@ struct perf_evsel {
 	int			exclude_GH;
 	struct perf_evsel	*leader;
 	char			*group_name;
+	union {
+		int		nr_members;
+		int		group_idx;
+	};
 };
 
 struct cpu_map;
@@ -225,4 +229,10 @@ static inline struct perf_evsel *perf_evsel__next(struct perf_evsel *evsel)
 {
 	return list_entry(evsel->node.next, struct perf_evsel, node);
 }
+
+/* Treat a non-group event as a leader */
+static inline bool perf_evsel__is_group_leader(struct perf_evsel *evsel)
+{
+	return evsel->leader == NULL;
+}
 #endif /* __PERF_EVSEL_H */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index e14e4365e8bd..b9b5eb711e75 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -819,6 +819,7 @@ int parse_events(struct perf_evlist *evlist, const char *str,
 	if (!ret) {
 		int entries = data.idx - evlist->nr_entries;
 		perf_evlist__splice_list_tail(evlist, &data.list, entries);
+		evlist->nr_groups += data.nr_groups;
 		return 0;
 	}
 
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index c356e443448d..f6b0254afe17 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -65,6 +65,7 @@ struct parse_events__term {
 struct parse_events_data__events {
 	struct list_head list;
 	int idx;
+	int nr_groups;
 };
 
 struct parse_events_data__terms {
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index cd88209e3c58..a7810dd0938a 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -122,6 +122,11 @@ group_def:
 PE_NAME '{' events '}'
 {
 	struct list_head *list = $3;
+	struct parse_events_data__events *data = _data;
+
+	/* Count groups only have more than 1 members */
+	if (!list_is_last(list->next, list))
+		data->nr_groups++;
 
 	parse_events__set_leader($1, list);
 	$$ = list;
@@ -130,6 +135,11 @@ PE_NAME '{' events '}'
 '{' events '}'
 {
 	struct list_head *list = $2;
+	struct parse_events_data__events *data = _data;
+
+	/* Count groups only have more than 1 members */
+	if (!list_is_last(list->next, list))
+		data->nr_groups++;
 
 	parse_events__set_leader(NULL, list);
 	$$ = list;
-- 
1.7.11.7

