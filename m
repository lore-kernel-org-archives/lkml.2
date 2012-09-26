Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab2IZH6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:58:53 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44645 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab2IZH4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:56:09 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-45-5062b51611a7
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 08/16] perf hists: Collapse group hist_entries to a leader
Date: Wed, 26 Sep 2012 16:47:35 +0900
Message-Id: <1348645663-25303-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
References: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

To support viewing an event group together, collapse all of members in
the group to the leader's tree.  The entries in the leaders' tree will
have group_stats to store those information.

This patch introduced an additional field 'event_group' in symbol_conf
to distinguish whether event grouping is enabled or not.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evsel.h  |   5 +++
 tools/perf/util/hist.c   | 106 +++++++++++++++++++++++++++++++++++++++++++----
 tools/perf/util/sort.h   |   1 +
 tools/perf/util/symbol.c |   4 ++
 tools/perf/util/symbol.h |   3 +-
 5 files changed, 110 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 820f005096c4..95f0bf17e79c 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -221,4 +221,9 @@ static inline bool perf_evsel__is_group_leader(struct perf_evsel *evsel)
 {
 	return evsel->leader == NULL;
 }
+
+static inline struct perf_evsel *hists_2_evsel(struct hists *hists)
+{
+	return container_of(hists, struct perf_evsel, hists);
+}
 #endif /* __PERF_EVSEL_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index c742a723e850..319822dee77b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -4,6 +4,7 @@
 #include "hist.h"
 #include "session.h"
 #include "sort.h"
+#include "evsel.h"
 #include <math.h>
 
 static bool hists__filter_entry_by_dso(struct hists *hists,
@@ -167,6 +168,32 @@ static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
 	dest->nr_events		+= src->nr_events;
 }
 
+static void hist_entry__add_group_stat(struct hist_entry *he_dest,
+				       struct he_stat *src,
+				       struct perf_evsel *evsel)
+{
+	struct perf_evsel *leader = evsel->leader;
+
+	if (perf_evsel__is_group_leader(evsel))
+		leader = evsel;
+
+	if (leader->nr_members && !he_dest->group_stats) {
+		/*
+		 * A group whose nr_members equals to 0 is a leader-only group.
+		 * So no need to allocate group_stats.
+		 */
+		he_dest->group_stats = calloc(leader->nr_members,
+					      sizeof(struct he_stat));
+		if (!he_dest->group_stats)
+			return;
+	}
+
+	if (perf_evsel__is_group_leader(evsel))
+		he_stat__add_stat(&he_dest->stat, src);
+	else
+		he_stat__add_stat(&he_dest->group_stats[evsel->group_idx], src);
+}
+
 static void hist_entry__decay(struct hist_entry *he)
 {
 	he->stat.period = (he->stat.period * 7) / 8;
@@ -415,13 +442,14 @@ void hist_entry__free(struct hist_entry *he)
  * collapse the histogram
  */
 
-static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
+static bool hists__collapse_insert_entry(struct hists *hists,
 					 struct rb_root *root,
 					 struct hist_entry *he)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *iter;
+	struct perf_evsel *evsel = hists_2_evsel(hists);
 	int64_t cmp;
 
 	while (*p != NULL) {
@@ -431,7 +459,10 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 		cmp = hist_entry__collapse(iter, he);
 
 		if (!cmp) {
-			he_stat__add_stat(&iter->stat, &he->stat);
+			if (symbol_conf.event_group)
+				hist_entry__add_group_stat(iter, &he->stat, evsel);
+			else
+				he_stat__add_stat(&iter->stat, &he->stat);
 
 			if (symbol_conf.use_callchain) {
 				callchain_cursor_reset(&callchain_cursor);
@@ -449,6 +480,17 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 			p = &(*p)->rb_right;
 	}
 
+	if (symbol_conf.event_group) {
+		/*
+		 * 'he' is not found in the leader's tree.
+		 * Insert it to the tree and setup stats properly.
+		 */
+		hist_entry__add_group_stat(he, &he->stat, evsel);
+
+		if (!perf_evsel__is_group_leader(evsel))
+			memset(&he->stat, 0, sizeof(he->stat));
+	}
+
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, root);
 	return true;
@@ -479,6 +521,7 @@ static void hists__apply_filters(struct hists *hists, struct hist_entry *he)
 static void __hists__collapse_resort(struct hists *hists, bool threaded)
 {
 	struct rb_root *root;
+	struct rb_root *dest;
 	struct rb_node *next;
 	struct hist_entry *n;
 
@@ -486,14 +529,26 @@ static void __hists__collapse_resort(struct hists *hists, bool threaded)
 		return;
 
 	root = hists__get_rotate_entries_in(hists);
+	dest = &hists->entries_collapsed;
 	next = rb_first(root);
 
+	if (symbol_conf.event_group) {
+		/*
+		 * Collapse hist entries to the leader's tree.
+		 * If evsel->leader == NULL, it's the leader.
+		 */
+		struct perf_evsel *leader = hists_2_evsel(hists)->leader;
+
+		if (leader)
+			dest = &leader->hists.entries_collapsed;
+	}
+
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node_in);
 		next = rb_next(&n->rb_node_in);
 
 		rb_erase(&n->rb_node_in, root);
-		if (hists__collapse_insert_entry(hists, &hists->entries_collapsed, n)) {
+		if (hists__collapse_insert_entry(hists, dest, n)) {
 			/*
 			 * If it wasn't combined with one of the entries already
 			 * collapsed, we need to apply the filters that may have
@@ -518,13 +573,38 @@ void hists__collapse_resort_threaded(struct hists *hists)
  * reverse the map, sort on period.
  */
 
-static void __hists__insert_output_entry(struct rb_root *entries,
+static int __hists__output_cmp(struct hist_entry *left,
+			       struct hist_entry *right,
+			       int nr_group_stats)
+{
+	if (left->stat.period > right->stat.period)
+		return 1;
+	if (left->stat.period < right->stat.period)
+		return -1;
+
+	if (symbol_conf.event_group) {
+		int i;
+
+		for (i = 0; i < nr_group_stats; i++) {
+			if (left->group_stats[i].period >
+			    right->group_stats[i].period)
+				return 1;
+			if (left->group_stats[i].period <
+			    right->group_stats[i].period)
+				return -1;
+		}
+	}
+	return 0;
+}
+
+static void __hists__insert_output_entry(struct hists *hists,
 					 struct hist_entry *he,
 					 u64 min_callchain_hits)
 {
-	struct rb_node **p = &entries->rb_node;
+	struct rb_node **p = &hists->entries.rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *iter;
+	struct perf_evsel *evsel = hists_2_evsel(hists);
 
 	if (symbol_conf.use_callchain)
 		callchain_param.sort(&he->sorted_chain, he->callchain,
@@ -534,14 +614,14 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node);
 
-		if (he->stat.period > iter->stat.period)
+		if (__hists__output_cmp(he, iter, evsel->nr_members) > 0)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
 	}
 
 	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, entries);
+	rb_insert_color(&he->rb_node, &hists->entries);
 }
 
 static void __hists__output_resort(struct hists *hists, bool threaded)
@@ -551,6 +631,16 @@ static void __hists__output_resort(struct hists *hists, bool threaded)
 	struct hist_entry *n;
 	u64 min_callchain_hits;
 
+	if (symbol_conf.event_group) {
+		struct perf_evsel *evsel = hists_2_evsel(hists);
+
+		/*
+		 * We've collapsed all member entries to the leader.
+		 */
+		if (!perf_evsel__is_group_leader(evsel))
+			return;
+	}
+
 	min_callchain_hits = hists->stats.total_period * (callchain_param.min_percent / 100);
 
 	if (sort__need_collapse || threaded)
@@ -569,7 +659,7 @@ static void __hists__output_resort(struct hists *hists, bool threaded)
 		n = rb_entry(next, struct hist_entry, rb_node_in);
 		next = rb_next(&n->rb_node_in);
 
-		__hists__insert_output_entry(&hists->entries, n, min_callchain_hits);
+		__hists__insert_output_entry(hists, n, min_callchain_hits);
 		hists__inc_nr_entries(hists, n);
 	}
 }
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 30f2ae5be146..1780bfc348d2 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -62,6 +62,7 @@ struct hist_entry {
 	struct rb_node		rb_node_in;
 	struct rb_node		rb_node;
 	struct he_stat		stat;
+	struct he_stat		*group_stats;
 	struct map_symbol	ms;
 	struct thread		*thread;
 	u64			ip;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e2e8c697cffe..bb2ef6920ccf 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -11,6 +11,7 @@
 #include <inttypes.h>
 #include "build-id.h"
 #include "util.h"
+#include "sort.h"
 #include "debug.h"
 #include "symbol.h"
 #include "strlist.h"
@@ -2033,6 +2034,9 @@ int symbol__init(void)
 
 	symbol_conf.kptr_restrict = symbol__read_kptr_restrict();
 
+	if (symbol_conf.event_group)
+		sort__need_collapse = 1;
+
 	symbol_conf.initialized = true;
 	return 0;
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index b441b07172b7..5f2304acea95 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -97,7 +97,8 @@ struct symbol_conf {
 			initialized,
 			kptr_restrict,
 			annotate_asm_raw,
-			annotate_src;
+			annotate_src,
+			event_group;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
-- 
1.7.11.4

