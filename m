Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab2LEG4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 01:56:53 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44066 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab2LEG4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 01:56:48 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-35-50bef02da20c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/3] perf hists: Link hist entries before inserting to an output tree
Date: Wed,  5 Dec 2012 15:56:42 +0900
Message-Id: <1354690603-31364-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354690603-31364-1-git-send-email-namhyung@kernel.org>
References: <1354690603-31364-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For matching and/or linking hist entries, they need to be sorted by
given sort keys.  However current hists__match/link did this on the
output trees, so that the entries in the output tree need to be resort
before doing it.

This looks not so good since we have trees for collecting or
collapsing entries before passing them to an output tree and they're
already sorted by the given sort keys.  Since we don't need to print
anything at the time of matching/linking, we can use these internal
trees directly instead of bothering with double resort on the output
tree.

Its only user - at the time of this writing - perf diff can be easily
converted to use the internal tree and can save some lines too by
getting rid of unnecessary resorting codes.

It seems we need to do output resort on baseline hists for
displacement prior to the match/link.  But AFAIK it's okay since the
resort doesn't make any change to the internal tree - i.e. every
entries in the internal tree remain as is and just linked to both of
internal and output tree using different keys.  So linking entries in
the internal tree after output resorting will not cause any harm IMHO.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c | 73 ++++++++++++++++++-----------------------------
 tools/perf/util/hist.c    | 49 +++++++++++++++++++++++--------
 2 files changed, 65 insertions(+), 57 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index d869029fb75e..b52f5d8c4a6b 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -276,46 +276,19 @@ static struct perf_tool tool = {
 	.ordering_requires_timestamps = true,
 };
 
-static void insert_hist_entry_by_name(struct rb_root *root,
-				      struct hist_entry *he)
-{
-	struct rb_node **p = &root->rb_node;
-	struct rb_node *parent = NULL;
-	struct hist_entry *iter;
-
-	while (*p != NULL) {
-		parent = *p;
-		iter = rb_entry(parent, struct hist_entry, rb_node);
-		if (hist_entry__cmp(he, iter) < 0)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, root);
-}
-
-static void hists__name_resort(struct hists *self, bool sort)
+static void hists__compute_position(struct hists *hists)
 {
 	unsigned long position = 1;
-	struct rb_root tmp = RB_ROOT;
-	struct rb_node *next = rb_first(&self->entries);
+	struct rb_node *next = rb_first(&hists->entries);
 
 	while (next != NULL) {
-		struct hist_entry *n = rb_entry(next, struct hist_entry, rb_node);
+		struct hist_entry *he;
 
-		next = rb_next(&n->rb_node);
-		n->position = position++;
+		he = rb_entry(next, struct hist_entry, rb_node);
+		he->position = position++;
 
-		if (sort) {
-			rb_erase(&n->rb_node, &self->entries);
-			insert_hist_entry_by_name(&tmp, n);
-		}
+		next = rb_next(next);
 	}
-
-	if (sort)
-		self->entries = tmp;
 }
 
 static struct perf_evsel *evsel_match(struct perf_evsel *evsel,
@@ -330,34 +303,39 @@ static struct perf_evsel *evsel_match(struct perf_evsel *evsel,
 	return NULL;
 }
 
-static void perf_evlist__resort_hists(struct perf_evlist *evlist, bool name)
+static void perf_evlist__resort_hists(struct perf_evlist *evlist, bool base)
 {
 	struct perf_evsel *evsel;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		struct hists *hists = &evsel->hists;
 
-		hists__output_resort(hists);
+		hists__collapse_resort(hists);
 
-		/*
-		 * The hists__name_resort only sets possition
-		 * if name is false.
-		 */
-		if (name || ((!name) && show_displacement))
-			hists__name_resort(hists, name);
+		if (base && show_displacement) {
+			hists__output_resort(hists);
+			hists__compute_position(hists);
+		}
 	}
 }
 
 static void hists__baseline_only(struct hists *hists)
 {
-	struct rb_node *next = rb_first(&hists->entries);
+	struct rb_root *root;
+	struct rb_node *next;
+
+	if (sort__need_collapse)
+		root = &hists->entries_collapsed;
+	else
+		root = hists->entries_in;
 
+	next = rb_first(root);
 	while (next != NULL) {
-		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
+		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node_in);
 
-		next = rb_next(&he->rb_node);
+		next = rb_next(&he->rb_node_in);
 		if (!hist_entry__next_pair(he)) {
-			rb_erase(&he->rb_node, &hists->entries);
+			rb_erase(&he->rb_node_in, root);
 			hist_entry__free(he);
 		}
 	}
@@ -481,6 +459,11 @@ static void hists__process(struct hists *old, struct hists *new)
 	else
 		hists__link(new, old);
 
+	hists__output_resort(new);
+
+	if (show_displacement)
+		hists__compute_position(new);
+
 	if (sort_compute) {
 		hists__precompute(new);
 		hists__compute_resort(new);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index d4471c21ed17..b0c9952d7c3f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -720,16 +720,24 @@ void hists__inc_nr_events(struct hists *hists, u32 type)
 static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 						 struct hist_entry *pair)
 {
-	struct rb_node **p = &hists->entries.rb_node;
+	struct rb_root *root;
+	struct rb_node **p;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
 	int cmp;
 
+	if (sort__need_collapse)
+		root = &hists->entries_collapsed;
+	else
+		root = hists->entries_in;
+
+	p = &root->rb_node;
+
 	while (*p != NULL) {
 		parent = *p;
-		he = rb_entry(parent, struct hist_entry, rb_node);
+		he = rb_entry(parent, struct hist_entry, rb_node_in);
 
-		cmp = hist_entry__cmp(he, pair);
+		cmp = hist_entry__collapse(he, pair);
 
 		if (!cmp)
 			goto out;
@@ -744,8 +752,8 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 	if (he) {
 		memset(&he->stat, 0, sizeof(he->stat));
 		he->hists = hists;
-		rb_link_node(&he->rb_node, parent, p);
-		rb_insert_color(&he->rb_node, &hists->entries);
+		rb_link_node(&he->rb_node_in, parent, p);
+		rb_insert_color(&he->rb_node_in, root);
 		hists__inc_nr_entries(hists, he);
 	}
 out:
@@ -755,11 +763,16 @@ out:
 static struct hist_entry *hists__find_entry(struct hists *hists,
 					    struct hist_entry *he)
 {
-	struct rb_node *n = hists->entries.rb_node;
+	struct rb_node *n;
+
+	if (sort__need_collapse)
+		n = hists->entries_collapsed.rb_node;
+	else
+		n = hists->entries_in->rb_node;
 
 	while (n) {
-		struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node);
-		int64_t cmp = hist_entry__cmp(iter, he);
+		struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node_in);
+		int64_t cmp = hist_entry__collapse(iter, he);
 
 		if (cmp < 0)
 			n = n->rb_left;
@@ -777,11 +790,17 @@ static struct hist_entry *hists__find_entry(struct hists *hists,
  */
 void hists__match(struct hists *leader, struct hists *other)
 {
+	struct rb_root *root;
 	struct rb_node *nd;
 	struct hist_entry *pos, *pair;
 
-	for (nd = rb_first(&leader->entries); nd; nd = rb_next(nd)) {
-		pos  = rb_entry(nd, struct hist_entry, rb_node);
+	if (sort__need_collapse)
+		root = &leader->entries_collapsed;
+	else
+		root = leader->entries_in;
+
+	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
+		pos  = rb_entry(nd, struct hist_entry, rb_node_in);
 		pair = hists__find_entry(other, pos);
 
 		if (pair)
@@ -796,11 +815,17 @@ void hists__match(struct hists *leader, struct hists *other)
  */
 int hists__link(struct hists *leader, struct hists *other)
 {
+	struct rb_root *root;
 	struct rb_node *nd;
 	struct hist_entry *pos, *pair;
 
-	for (nd = rb_first(&other->entries); nd; nd = rb_next(nd)) {
-		pos = rb_entry(nd, struct hist_entry, rb_node);
+	if (sort__need_collapse)
+		root = &other->entries_collapsed;
+	else
+		root = other->entries_in;
+
+	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
+		pos = rb_entry(nd, struct hist_entry, rb_node_in);
 
 		if (!hist_entry__has_pairs(pos)) {
 			pair = hists__add_dummy_entry(leader, pos);
-- 
1.7.11.7

