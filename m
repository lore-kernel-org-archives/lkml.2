Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2KIQo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:44:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63528 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2KIQoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:44:55 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 01/12] perf tools: Keep group information
Date: Sat, 10 Nov 2012 01:43:23 +0900
Message-Id: <1352479414-2324-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352479414-2324-1-git-send-email-namhyung@kernel.org>
References: <1352479414-2324-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/util/evlist.c       |   10 ++++++++--
 tools/perf/util/evlist.h       |    1 +
 tools/perf/util/evsel.h        |   10 ++++++++++
 tools/perf/util/parse-events.c |    1 +
 tools/perf/util/parse-events.h |    1 +
 tools/perf/util/parse-events.y |   10 ++++++++++
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
index 6f94d6dea00f..81b6a9740024 100644
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
index c0b785b50849..8e15c374d600 100644
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
index ac9a6aacf2f5..824784b03410 100644
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
index 0f9914ae6bac..69cff676dcb1 100644
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
1.7.9.2

