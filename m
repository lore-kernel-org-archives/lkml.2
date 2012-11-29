Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab2K2GjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:39:10 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50052 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2K2GjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:39:06 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-b0-50b70308168d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 03/18] perf tools: Keep group information
Date: Thu, 29 Nov 2012 15:38:31 +0900
Message-Id: <1354171126-14387-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
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
index d0e1e821fe85..a446b5b91530 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -111,6 +111,9 @@ void __perf_evlist__set_leader(struct list_head *list)
 	struct perf_evsel *evsel, *leader;
 
 	leader = list_entry(list->next, struct perf_evsel, node);
+	evsel = list_entry(list->prev, struct perf_evsel, node);
+
+	leader->nr_members = evsel->idx - leader->idx + 1;
 
 	list_for_each_entry(evsel, list, node) {
 		if (evsel != leader)
@@ -120,8 +123,10 @@ void __perf_evlist__set_leader(struct list_head *list)
 
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
index 46c8004ca56b..887834ed0af1 100644
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
@@ -230,4 +231,9 @@ static inline bool perf_evsel__is_group_leader(const struct perf_evsel *evsel)
 {
 	return evsel->leader == evsel;
 }
+
+static inline int perf_evsel__group_idx(struct perf_evsel *evsel)
+{
+	return evsel->idx - evsel->leader->idx;
+}
 #endif /* __PERF_EVSEL_H */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 020323af3364..25a556cf74ee 100644
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
index f6399373d67d..5a42c6d7cc9a 100644
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
1.7.11.7

