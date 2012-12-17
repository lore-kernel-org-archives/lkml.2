Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab2LQGm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 01:42:29 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56269 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2LQGjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 01:39:09 -0500
X-AuditID: 9c930179-b7becae000000e51-64-50cebe0bac0d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 01/14] perf tools: Keep group information
Date: Mon, 17 Dec 2012 15:38:52 +0900
Message-Id: <1355726345-29553-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
References: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
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
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evlist.c       |  7 ++++++-
 tools/perf/util/evlist.h       |  1 +
 tools/perf/util/evsel.h        |  6 ++++++
 tools/perf/util/parse-events.c |  1 +
 tools/perf/util/parse-events.h |  1 +
 tools/perf/util/parse-events.y | 10 ++++++++++
 6 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index dc8aee97a488..eddd5ebcd690 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -117,6 +117,9 @@ void __perf_evlist__set_leader(struct list_head *list)
 	struct perf_evsel *evsel, *leader;
 
 	leader = list_entry(list->next, struct perf_evsel, node);
+	evsel = list_entry(list->prev, struct perf_evsel, node);
+
+	leader->nr_members = evsel->idx - leader->idx + 1;
 
 	list_for_each_entry(evsel, list, node) {
 		if (evsel != leader)
@@ -126,8 +129,10 @@ void __perf_evlist__set_leader(struct list_head *list)
 
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
index 457e2350d21d..73579a25a93e 100644
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
index 9cb8a0215711..3b48b87d7e2d 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -73,6 +73,7 @@ struct perf_evsel {
 	bool 			needs_swap;
 	/* parse modifier helper */
 	int			exclude_GH;
+	int			nr_members;
 	struct perf_evsel	*leader;
 	char			*group_name;
 };
@@ -251,4 +252,9 @@ struct perf_attr_details {
 
 int perf_evsel__fprintf(struct perf_evsel *evsel,
 			struct perf_attr_details *details, FILE *fp);
+
+static inline int perf_evsel__group_idx(struct perf_evsel *evsel)
+{
+	return evsel->idx - evsel->leader->idx;
+}
 #endif /* __PERF_EVSEL_H */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 2d8d53bec17e..398f04c01f7e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -843,6 +843,7 @@ int parse_events(struct perf_evlist *evlist, const char *str,
 	if (!ret) {
 		int entries = data.idx - evlist->nr_entries;
 		perf_evlist__splice_list_tail(evlist, &data.list, entries);
+		evlist->nr_groups += data.nr_groups;
 		return 0;
 	}
 
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index b7af80b8bdda..330b8896876b 100644
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
index 0f9914ae6bac..7f2d63afcf38 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -23,6 +23,14 @@ do { \
 		YYABORT; \
 } while (0)
 
+static inc_group_count(struct list_head *list,
+		       struct parse_events_data__events *data)
+{
+	/* Count groups only have more than 1 members */
+	if (!list_is_last(list->next, list))
+		data->nr_groups++;
+}
+
 %}
 
 %token PE_START_EVENTS PE_START_TERMS
@@ -123,6 +131,7 @@ PE_NAME '{' events '}'
 {
 	struct list_head *list = $3;
 
+	inc_group_count(list, _data);
 	parse_events__set_leader($1, list);
 	$$ = list;
 }
@@ -131,6 +140,7 @@ PE_NAME '{' events '}'
 {
 	struct list_head *list = $2;
 
+	inc_group_count(list, _data);
 	parse_events__set_leader(NULL, list);
 	$$ = list;
 }
-- 
1.7.11.7

