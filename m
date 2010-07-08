Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab0GHEhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 00:37:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42753 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab0GHEhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 00:37:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=s3r6zpVC3AFfsd3mYE8oSpNsl43PIVqpISWXFlM1w1iW9ch6QdG+G10rn3MAJg/KNX
         IhsJ2V9M3MZxhIzUyRM15/VEphAJg2THAhGR1v073qWtWihzEoAIHzRhS/cgmKQxL+MG
         8e/57+Lj84I9DbUOICn3i4Shtye1Cu5GJGAPs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf: Sync callchains with period based hits
Date: Thu,  8 Jul 2010 06:36:51 +0200
Message-Id: <1278563811-21818-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1278563811-21818-1-git-send-regression-fweisbec@gmail.com>
References: <1278563811-21818-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hists have their hits increased by the event period. And this
period based counting is the foundation of all the stats in
perf report.

But callchains still use the raw number of hits, without taking
the period into account. So when we compute the percentage,
absolute based percentages are totally broken, and relative ones
too in the first parent level. Because we pass the number of events
muliplied by their period as the total number of hits to the
callchain filtering, while callchains expect this number to be
the number of raw hits.

perf report -g graph was simply not working, showing no graph unless
the min percent was zero. And even there the percentage of the
branches was always 0. And may be fractal filtering was broken on
the first branch level too.

flat also was broken, but it was hidden because of other breakages.

Anyway fix this by counting using periods on callchains.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/builtin-report.c |    2 +-
 tools/perf/util/callchain.c |   35 ++++++++++++++++++-----------------
 tools/perf/util/callchain.h |    2 +-
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3592057..fd7407c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -107,7 +107,7 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 		goto out_free_syms;
 	err = 0;
 	if (symbol_conf.use_callchain) {
-		err = append_chain(he->callchain, data->callchain, syms);
+		err = append_chain(he->callchain, data->callchain, syms, data->period);
 		if (err)
 			goto out_free_syms;
 	}
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 62b69ad..52c777e 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -230,7 +230,7 @@ fill_node(struct callchain_node *node, struct resolved_chain *chain, int start)
 
 static void
 add_child(struct callchain_node *parent, struct resolved_chain *chain,
-	  int start)
+	  int start, u64 period)
 {
 	struct callchain_node *new;
 
@@ -238,7 +238,7 @@ add_child(struct callchain_node *parent, struct resolved_chain *chain,
 	fill_node(new, chain, start);
 
 	new->children_hit = 0;
-	new->hit = 1;
+	new->hit = period;
 }
 
 /*
@@ -248,7 +248,8 @@ add_child(struct callchain_node *parent, struct resolved_chain *chain,
  */
 static void
 split_add_child(struct callchain_node *parent, struct resolved_chain *chain,
-		struct callchain_list *to_split, int idx_parents, int idx_local)
+		struct callchain_list *to_split, int idx_parents, int idx_local,
+		u64 period)
 {
 	struct callchain_node *new;
 	struct list_head *old_tail;
@@ -275,41 +276,41 @@ split_add_child(struct callchain_node *parent, struct resolved_chain *chain,
 	/* create a new child for the new branch if any */
 	if (idx_total < chain->nr) {
 		parent->hit = 0;
-		add_child(parent, chain, idx_total);
-		parent->children_hit++;
+		add_child(parent, chain, idx_total, period);
+		parent->children_hit += period;
 	} else {
-		parent->hit = 1;
+		parent->hit = period;
 	}
 }
 
 static int
 __append_chain(struct callchain_node *root, struct resolved_chain *chain,
-	       unsigned int start);
+	       unsigned int start, u64 period);
 
 static void
 __append_chain_children(struct callchain_node *root,
 			struct resolved_chain *chain,
-			unsigned int start)
+			unsigned int start, u64 period)
 {
 	struct callchain_node *rnode;
 
 	/* lookup in childrens */
 	chain_for_each_child(rnode, root) {
-		unsigned int ret = __append_chain(rnode, chain, start);
+		unsigned int ret = __append_chain(rnode, chain, start, period);
 
 		if (!ret)
 			goto inc_children_hit;
 	}
 	/* nothing in children, add to the current node */
-	add_child(root, chain, start);
+	add_child(root, chain, start, period);
 
 inc_children_hit:
-	root->children_hit++;
+	root->children_hit += period;
 }
 
 static int
 __append_chain(struct callchain_node *root, struct resolved_chain *chain,
-	       unsigned int start)
+	       unsigned int start, u64 period)
 {
 	struct callchain_list *cnode;
 	unsigned int i = start;
@@ -345,18 +346,18 @@ __append_chain(struct callchain_node *root, struct resolved_chain *chain,
 
 	/* we match only a part of the node. Split it and add the new chain */
 	if (i - start < root->val_nr) {
-		split_add_child(root, chain, cnode, start, i - start);
+		split_add_child(root, chain, cnode, start, i - start, period);
 		return 0;
 	}
 
 	/* we match 100% of the path, increment the hit */
 	if (i - start == root->val_nr && i == chain->nr) {
-		root->hit++;
+		root->hit += period;
 		return 0;
 	}
 
 	/* We match the node and still have a part remaining */
-	__append_chain_children(root, chain, i);
+	__append_chain_children(root, chain, i, period);
 
 	return 0;
 }
@@ -380,7 +381,7 @@ static void filter_context(struct ip_callchain *old, struct resolved_chain *new,
 
 
 int append_chain(struct callchain_node *root, struct ip_callchain *chain,
-		 struct map_symbol *syms)
+		 struct map_symbol *syms, u64 period)
 {
 	struct resolved_chain *filtered;
 
@@ -397,7 +398,7 @@ int append_chain(struct callchain_node *root, struct ip_callchain *chain,
 	if (!filtered->nr)
 		goto end;
 
-	__append_chain_children(root, filtered, 0);
+	__append_chain_children(root, filtered, 0, period);
 end:
 	free(filtered);
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 22dbaec..f2e9ee1 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -61,7 +61,7 @@ static inline u64 cumul_hits(struct callchain_node *node)
 
 int register_callchain_param(struct callchain_param *param);
 int append_chain(struct callchain_node *root, struct ip_callchain *chain,
-		 struct map_symbol *syms);
+		 struct map_symbol *syms, u64 period);
 
 bool ip_callchain__valid(struct ip_callchain *chain, event_t *event);
 #endif	/* __PERF_CALLCHAIN_H */
-- 
1.6.2.3

