Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab2K2Gnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:43:52 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63188 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab2K2GjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:39:08 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-c5-50b703095eb8
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 08/18] perf hists: Add hists__{match,link}_collapsed
Date: Thu, 29 Nov 2012 15:38:36 +0900
Message-Id: <1354171126-14387-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The current hists__match/link functions are worked on the output tree
(hists->entries).  However for event group view it needs to be
matched/linked before the final resort.  Thus add new helpers for
doing it on the collapsed tree.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 117 +++++++++++++++++++++++++++++++++++++++++--------
 tools/perf/util/hist.h |   2 +
 2 files changed, 101 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 161c35e7ed0e..2af8ec6e8e26 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -717,19 +717,72 @@ void hists__inc_nr_events(struct hists *hists, u32 type)
 	++hists->stats.nr_events[type];
 }
 
+struct rb_hist_fns {
+	struct rb_root * (*get_rb_root)(struct hists *);
+	struct rb_node * (*get_rb_node)(struct hist_entry *);
+	struct hist_entry * (*get_hist_entry)(struct rb_node *);
+	int64_t (*cmp_hist_entry)(struct hist_entry *, struct hist_entry *);
+};
+
+static struct rb_root *get_output_rb_root(struct hists *hists)
+{
+	return &hists->entries;
+}
+
+static struct rb_node *get_output_rb_node(struct hist_entry *he)
+{
+	return &he->rb_node;
+}
+
+static struct hist_entry *get_output_hist_entry(struct rb_node *node)
+{
+	return rb_entry(node, struct hist_entry, rb_node);
+}
+
+static const struct rb_hist_fns output_fns = {
+	.get_rb_root		= get_output_rb_root,
+	.get_rb_node		= get_output_rb_node,
+	.get_hist_entry		= get_output_hist_entry,
+	.cmp_hist_entry		= hist_entry__cmp,
+};
+
+static struct rb_root *get_collapsed_rb_root(struct hists *hists)
+{
+	return &hists->entries_collapsed;
+}
+
+static struct rb_node *get_collapsed_rb_node(struct hist_entry *he)
+{
+	return &he->rb_node_in;
+}
+
+static struct hist_entry *get_collapsed_hist_entry(struct rb_node *node)
+{
+	return rb_entry(node, struct hist_entry, rb_node_in);
+}
+
+static const struct rb_hist_fns collapsed_fns = {
+	.get_rb_root		= get_collapsed_rb_root,
+	.get_rb_node		= get_collapsed_rb_node,
+	.get_hist_entry		= get_collapsed_hist_entry,
+	.cmp_hist_entry		= hist_entry__collapse,
+};
+
 static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
-						 struct hist_entry *pair)
+						 struct hist_entry *pair,
+						 const struct rb_hist_fns *fns)
 {
-	struct rb_node **p = &hists->entries.rb_node;
+	struct rb_root *root = fns->get_rb_root(hists);
+	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
 	int cmp;
 
 	while (*p != NULL) {
 		parent = *p;
-		he = rb_entry(parent, struct hist_entry, rb_node);
+		he = fns->get_hist_entry(parent);
 
-		cmp = hist_entry__cmp(pair, he);
+		cmp = fns->cmp_hist_entry(pair, he);
 
 		if (!cmp)
 			goto out;
@@ -742,10 +795,12 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 
 	he = hist_entry__new(pair);
 	if (he) {
+		struct rb_node *n = fns->get_rb_node(he);
+
 		memset(&he->stat, 0, sizeof(he->stat));
 		he->hists = hists;
-		rb_link_node(&he->rb_node, parent, p);
-		rb_insert_color(&he->rb_node, &hists->entries);
+		rb_link_node(n, parent, p);
+		rb_insert_color(n, root);
 		hists__inc_nr_entries(hists, he);
 	}
 out:
@@ -753,13 +808,15 @@ out:
 }
 
 static struct hist_entry *hists__find_entry(struct hists *hists,
-					    struct hist_entry *he)
+					    struct hist_entry *he,
+					    const struct rb_hist_fns *fns)
 {
-	struct rb_node *n = hists->entries.rb_node;
+	struct rb_root *root = fns->get_rb_root(hists);
+	struct rb_node *n = root->rb_node;
 
 	while (n) {
-		struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node);
-		int64_t cmp = hist_entry__cmp(he, iter);
+		struct hist_entry *iter = fns->get_hist_entry(n);
+		int64_t cmp = fns->cmp_hist_entry(he, iter);
 
 		if (cmp < 0)
 			n = n->rb_left;
@@ -775,35 +832,49 @@ static struct hist_entry *hists__find_entry(struct hists *hists,
 /*
  * Look for pairs to link to the leader buckets (hist_entries):
  */
-void hists__match(struct hists *leader, struct hists *other)
+static void __hists__match(struct hists *leader, struct hists *other,
+			   const struct rb_hist_fns *fns)
 {
+	struct rb_root *root = fns->get_rb_root(leader);
 	struct rb_node *nd;
 	struct hist_entry *pos, *pair;
 
-	for (nd = rb_first(&leader->entries); nd; nd = rb_next(nd)) {
-		pos  = rb_entry(nd, struct hist_entry, rb_node);
-		pair = hists__find_entry(other, pos);
+	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
+		pos  = fns->get_hist_entry(nd);
+		pair = hists__find_entry(other, pos, fns);
 
 		if (pair)
 			hist_entry__add_pair(pair, pos);
 	}
 }
 
+void hists__match(struct hists *leader, struct hists *other)
+{
+	__hists__match(leader, other, &output_fns);
+}
+
+void hists__match_collapsed(struct hists *leader, struct hists *other)
+{
+	__hists__match(leader, other, &collapsed_fns);
+}
+
 /*
  * Look for entries in the other hists that are not present in the leader, if
  * we find them, just add a dummy entry on the leader hists, with period=0,
  * nr_events=0, to serve as the list header.
  */
-int hists__link(struct hists *leader, struct hists *other)
+static int __hists__link(struct hists *leader, struct hists *other,
+			 const struct rb_hist_fns *fns)
 {
+	struct rb_root *root = fns->get_rb_root(other);
 	struct rb_node *nd;
 	struct hist_entry *pos, *pair;
 
-	for (nd = rb_first(&other->entries); nd; nd = rb_next(nd)) {
-		pos = rb_entry(nd, struct hist_entry, rb_node);
+	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
+		pos = fns->get_hist_entry(nd);
 
 		if (!hist_entry__has_pairs(pos)) {
-			pair = hists__add_dummy_entry(leader, pos);
+			pair = hists__add_dummy_entry(leader, pos, fns);
 			if (pair == NULL)
 				return -1;
 			hist_entry__add_pair(pos, pair);
@@ -812,3 +883,13 @@ int hists__link(struct hists *leader, struct hists *other)
 
 	return 0;
 }
+
+int hists__link(struct hists *leader, struct hists *other)
+{
+	return __hists__link(leader, other, &output_fns);
+}
+
+int hists__link_collapsed(struct hists *leader, struct hists *other)
+{
+	return __hists__link(leader, other, &collapsed_fns);
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 8b091a51e4a2..43ee5e4fc33e 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -116,7 +116,9 @@ void hists__reset_col_len(struct hists *hists);
 void hists__calc_col_len(struct hists *hists, struct hist_entry *he);
 
 void hists__match(struct hists *leader, struct hists *other);
+void hists__match_collapsed(struct hists *leader, struct hists *other);
 int hists__link(struct hists *leader, struct hists *other);
+int hists__link_collapsed(struct hists *leader, struct hists *other);
 
 struct perf_hpp {
 	char *buf;
-- 
1.7.11.7

