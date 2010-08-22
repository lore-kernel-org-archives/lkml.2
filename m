Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0HVVPp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 17:15:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46134 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab0HVVPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 17:15:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=BezGM/TzQslKmGzZC42kwfrW7avP+nBTO2Jc5aGrJopyAHZMEscR0cSJGWH3sZHq4L
         pVNAqB+kyr7dvXCh8o6PZ6HrZLYZot8UOCfOx7wMPLl46wfQ2QvICgDPCuTvevQWlcKA
         uqocWSb1CVXUN8nLLFGRVRZ4JGBerqTMvJvE4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] perf: Keep track of the max depth of a callchain
Date: Sun, 22 Aug 2010 23:15:38 +0200
Message-Id: <1282511740-22631-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1282511740-22631-1-git-send-regression-fweisbec@gmail.com>
References: <1282511740-22631-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to implement callchains collapsing, we need to keep
track of the maximum depth in a histogram tree of callchains.
This way we'll avoid allocating an arbitrary temporary buffer
size on callchain merge time.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>
---
 tools/perf/util/callchain.c |   23 +++++++++++++----------
 tools/perf/util/callchain.h |   22 ++++++++++++++--------
 tools/perf/util/hist.c      |    2 +-
 tools/perf/util/sort.h      |    2 +-
 4 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index f231f43..f0b23f3 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -86,10 +86,10 @@ __sort_chain_flat(struct rb_root *rb_root, struct callchain_node *node,
  * sort them by hit
  */
 static void
-sort_chain_flat(struct rb_root *rb_root, struct callchain_node *node,
+sort_chain_flat(struct rb_root *rb_root, struct callchain_root *root,
 		u64 min_hit, struct callchain_param *param __used)
 {
-	__sort_chain_flat(rb_root, node, min_hit);
+	__sort_chain_flat(rb_root, &root->node, min_hit);
 }
 
 static void __sort_chain_graph_abs(struct callchain_node *node,
@@ -108,11 +108,11 @@ static void __sort_chain_graph_abs(struct callchain_node *node,
 }
 
 static void
-sort_chain_graph_abs(struct rb_root *rb_root, struct callchain_node *chain_root,
+sort_chain_graph_abs(struct rb_root *rb_root, struct callchain_root *chain_root,
 		     u64 min_hit, struct callchain_param *param __used)
 {
-	__sort_chain_graph_abs(chain_root, min_hit);
-	rb_root->rb_node = chain_root->rb_root.rb_node;
+	__sort_chain_graph_abs(&chain_root->node, min_hit);
+	rb_root->rb_node = chain_root->node.rb_root.rb_node;
 }
 
 static void __sort_chain_graph_rel(struct callchain_node *node,
@@ -133,11 +133,11 @@ static void __sort_chain_graph_rel(struct callchain_node *node,
 }
 
 static void
-sort_chain_graph_rel(struct rb_root *rb_root, struct callchain_node *chain_root,
+sort_chain_graph_rel(struct rb_root *rb_root, struct callchain_root *chain_root,
 		     u64 min_hit __used, struct callchain_param *param)
 {
-	__sort_chain_graph_rel(chain_root, param->min_percent / 100.0);
-	rb_root->rb_node = chain_root->rb_root.rb_node;
+	__sort_chain_graph_rel(&chain_root->node, param->min_percent / 100.0);
+	rb_root->rb_node = chain_root->node.rb_root.rb_node;
 }
 
 int register_callchain_param(struct callchain_param *param)
@@ -380,7 +380,7 @@ static void filter_context(struct ip_callchain *old, struct resolved_chain *new,
 }
 
 
-int append_chain(struct callchain_node *root, struct ip_callchain *chain,
+int append_chain(struct callchain_root *root, struct ip_callchain *chain,
 		 struct map_symbol *syms, u64 period)
 {
 	struct resolved_chain *filtered;
@@ -398,7 +398,10 @@ int append_chain(struct callchain_node *root, struct ip_callchain *chain,
 	if (!filtered->nr)
 		goto end;
 
-	__append_chain_children(root, filtered, 0, period);
+	__append_chain_children(&root->node, filtered, 0, period);
+
+	if (filtered->nr > root->max_depth)
+		root->max_depth = filtered->nr;
 end:
 	free(filtered);
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 624a96c..9b93a38 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -26,9 +26,14 @@ struct callchain_node {
 	u64			children_hit;
 };
 
+struct callchain_root {
+	u64			max_depth;
+	struct callchain_node	node;
+};
+
 struct callchain_param;
 
-typedef void (*sort_chain_func_t)(struct rb_root *, struct callchain_node *,
+typedef void (*sort_chain_func_t)(struct rb_root *, struct callchain_root *,
 				 u64, struct callchain_param *);
 
 struct callchain_param {
@@ -44,14 +49,15 @@ struct callchain_list {
 	struct list_head	list;
 };
 
-static inline void callchain_init(struct callchain_node *node)
+static inline void callchain_init(struct callchain_root *root)
 {
-	INIT_LIST_HEAD(&node->brothers);
-	INIT_LIST_HEAD(&node->children);
-	INIT_LIST_HEAD(&node->val);
+	INIT_LIST_HEAD(&root->node.brothers);
+	INIT_LIST_HEAD(&root->node.children);
+	INIT_LIST_HEAD(&root->node.val);
 
-	node->parent = NULL;
-	node->hit = 0;
+	root->node.parent = NULL;
+	root->node.hit = 0;
+	root->max_depth = 0;
 }
 
 static inline u64 cumul_hits(struct callchain_node *node)
@@ -60,7 +66,7 @@ static inline u64 cumul_hits(struct callchain_node *node)
 }
 
 int register_callchain_param(struct callchain_param *param);
-int append_chain(struct callchain_node *root, struct ip_callchain *chain,
+int append_chain(struct callchain_root *root, struct ip_callchain *chain,
 		 struct map_symbol *syms, u64 period);
 
 bool ip_callchain__valid(struct ip_callchain *chain, const event_t *event);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index be22ae6..e77ff77 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -87,7 +87,7 @@ static void hist_entry__add_cpumode_period(struct hist_entry *self,
 
 static struct hist_entry *hist_entry__new(struct hist_entry *template)
 {
-	size_t callchain_size = symbol_conf.use_callchain ? sizeof(struct callchain_node) : 0;
+	size_t callchain_size = symbol_conf.use_callchain ? sizeof(struct callchain_root) : 0;
 	struct hist_entry *self = malloc(sizeof(*self) + callchain_size);
 
 	if (self != NULL) {
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 46e531d..0b91053 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -70,7 +70,7 @@ struct hist_entry {
 		struct hist_entry *pair;
 		struct rb_root	  sorted_chain;
 	};
-	struct callchain_node	callchain[0];
+	struct callchain_root	callchain[0];
 };
 
 enum sort_type {
-- 
1.6.2.3

