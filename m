Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab0CVQJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:09:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:48204 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab0CVQJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:09:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/6] perf: Fix orphan callchain branches
Date: Mon, 22 Mar 2010 13:09:33 -0300
Message-Id: <1269274173-20328-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Callchains have markers inside their capture to tell we
enter a context (kernel, user, ...).

Those are not displayed in the callchains but they are
incidentally an active part of the radix tree where
callchains are stored, just like any other address.

If we have the two following callchains:

addr1 -> addr2 -> user context -> addr3
addr1 -> addr2 -> user context -> addr4
addr1 -> addr2 -> addr 5

This is pretty common if addr1 and addr2 are part of an
interrupt path, addr3 and addr4 are user addresses and
addr5 is a kernel non interrupt path.

This will be stored as follows in the tree:

                   addr1
                   addr2
                   /   \
                  /     addr5
            user context
               /    \
             addr3  addr4

But we ignore the context markers in the report, hence
the addr3 and addr4 will appear as orphan branches:

    |--28.30%-- hrtimer_interrupt
    |          smp_apic_timer_interrupt
    |          apic_timer_interrupt
    |          |           <------------- here, no parent!
    |          |          |
    |          |          |--11.11%-- 0x7fae7bccb875
    |          |          |
    |          |          |--11.11%-- 0xffffffffff60013b
    |          |          |
    |          |          |--11.11%-- __pthread_mutex_lock_internal
    |          |          |
    |          |          |--11.11%-- __errno_location

Fix this by removing the context markers when we process the
callchains to the tree.

Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    6 ++-
 tools/perf/util/callchain.c |  109 ++++++++++++++++++++++++++++++++-----------
 tools/perf/util/callchain.h |    4 +-
 tools/perf/util/hist.c      |    5 --
 4 files changed, 88 insertions(+), 36 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1f9f869..d609afb 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -83,6 +83,7 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 {
 	struct symbol **syms = NULL, *parent = NULL;
 	bool hit;
+	int err;
 	struct hist_entry *he;
 	struct event_stat_id *stats;
 	struct perf_event_attr *attr;
@@ -109,8 +110,11 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	if (symbol_conf.use_callchain) {
 		if (!hit)
 			callchain_init(&he->callchain);
-		append_chain(&he->callchain, data->callchain, syms);
+		err = append_chain(&he->callchain, data->callchain, syms);
 		free(syms);
+
+		if (err)
+			return err;
 	}
 
 	return 0;
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index b3b7125..883844e 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2009, Frederic Weisbecker <fweisbec@gmail.com>
+ * Copyright (C) 2009-2010, Frederic Weisbecker <fweisbec@gmail.com>
  *
  * Handle the callchains from the stream in an ad-hoc radix tree and then
  * sort them in an rbtree.
@@ -183,12 +183,23 @@ create_child(struct callchain_node *parent, bool inherit_children)
 	return new;
 }
 
+
+struct resolved_ip {
+	u64		ip;
+	struct symbol	*sym;
+};
+
+struct resolved_chain {
+	u64			nr;
+	struct resolved_ip	ips[0];
+};
+
+
 /*
  * Fill the node with callchain values
  */
 static void
-fill_node(struct callchain_node *node, struct ip_callchain *chain,
-	  int start, struct symbol **syms)
+fill_node(struct callchain_node *node, struct resolved_chain *chain, int start)
 {
 	unsigned int i;
 
@@ -200,8 +211,8 @@ fill_node(struct callchain_node *node, struct ip_callchain *chain,
 			perror("not enough memory for the code path tree");
 			return;
 		}
-		call->ip = chain->ips[i];
-		call->sym = syms[i];
+		call->ip = chain->ips[i].ip;
+		call->sym = chain->ips[i].sym;
 		list_add_tail(&call->list, &node->val);
 	}
 	node->val_nr = chain->nr - start;
@@ -210,13 +221,13 @@ fill_node(struct callchain_node *node, struct ip_callchain *chain,
 }
 
 static void
-add_child(struct callchain_node *parent, struct ip_callchain *chain,
-	  int start, struct symbol **syms)
+add_child(struct callchain_node *parent, struct resolved_chain *chain,
+	  int start)
 {
 	struct callchain_node *new;
 
 	new = create_child(parent, false);
-	fill_node(new, chain, start, syms);
+	fill_node(new, chain, start);
 
 	new->children_hit = 0;
 	new->hit = 1;
@@ -228,9 +239,8 @@ add_child(struct callchain_node *parent, struct ip_callchain *chain,
  * Then create another child to host the given callchain of new branch
  */
 static void
-split_add_child(struct callchain_node *parent, struct ip_callchain *chain,
-		struct callchain_list *to_split, int idx_parents, int idx_local,
-		struct symbol **syms)
+split_add_child(struct callchain_node *parent, struct resolved_chain *chain,
+		struct callchain_list *to_split, int idx_parents, int idx_local)
 {
 	struct callchain_node *new;
 	struct list_head *old_tail;
@@ -257,7 +267,7 @@ split_add_child(struct callchain_node *parent, struct ip_callchain *chain,
 	/* create a new child for the new branch if any */
 	if (idx_total < chain->nr) {
 		parent->hit = 0;
-		add_child(parent, chain, idx_total, syms);
+		add_child(parent, chain, idx_total);
 		parent->children_hit++;
 	} else {
 		parent->hit = 1;
@@ -265,32 +275,33 @@ split_add_child(struct callchain_node *parent, struct ip_callchain *chain,
 }
 
 static int
-__append_chain(struct callchain_node *root, struct ip_callchain *chain,
-	       unsigned int start, struct symbol **syms);
+__append_chain(struct callchain_node *root, struct resolved_chain *chain,
+	       unsigned int start);
 
 static void
-__append_chain_children(struct callchain_node *root, struct ip_callchain *chain,
-			struct symbol **syms, unsigned int start)
+__append_chain_children(struct callchain_node *root,
+			struct resolved_chain *chain,
+			unsigned int start)
 {
 	struct callchain_node *rnode;
 
 	/* lookup in childrens */
 	chain_for_each_child(rnode, root) {
-		unsigned int ret = __append_chain(rnode, chain, start, syms);
+		unsigned int ret = __append_chain(rnode, chain, start);
 
 		if (!ret)
 			goto inc_children_hit;
 	}
 	/* nothing in children, add to the current node */
-	add_child(root, chain, start, syms);
+	add_child(root, chain, start);
 
 inc_children_hit:
 	root->children_hit++;
 }
 
 static int
-__append_chain(struct callchain_node *root, struct ip_callchain *chain,
-	       unsigned int start, struct symbol **syms)
+__append_chain(struct callchain_node *root, struct resolved_chain *chain,
+	       unsigned int start)
 {
 	struct callchain_list *cnode;
 	unsigned int i = start;
@@ -302,13 +313,19 @@ __append_chain(struct callchain_node *root, struct ip_callchain *chain,
 	 * anywhere inside a function.
 	 */
 	list_for_each_entry(cnode, &root->val, list) {
+		struct symbol *sym;
+
 		if (i == chain->nr)
 			break;
-		if (cnode->sym && syms[i]) {
-			if (cnode->sym->start != syms[i]->start)
+
+		sym = chain->ips[i].sym;
+
+		if (cnode->sym && sym) {
+			if (cnode->sym->start != sym->start)
 				break;
-		} else if (cnode->ip != chain->ips[i])
+		} else if (cnode->ip != chain->ips[i].ip)
 			break;
+
 		if (!found)
 			found = true;
 		i++;
@@ -320,7 +337,7 @@ __append_chain(struct callchain_node *root, struct ip_callchain *chain,
 
 	/* we match only a part of the node. Split it and add the new chain */
 	if (i - start < root->val_nr) {
-		split_add_child(root, chain, cnode, start, i - start, syms);
+		split_add_child(root, chain, cnode, start, i - start);
 		return 0;
 	}
 
@@ -331,15 +348,51 @@ __append_chain(struct callchain_node *root, struct ip_callchain *chain,
 	}
 
 	/* We match the node and still have a part remaining */
-	__append_chain_children(root, chain, syms, i);
+	__append_chain_children(root, chain, i);
 
 	return 0;
 }
 
-void append_chain(struct callchain_node *root, struct ip_callchain *chain,
+static void
+filter_context(struct ip_callchain *old, struct resolved_chain *new,
+	       struct symbol **syms)
+{
+	int i, j = 0;
+
+	for (i = 0; i < (int)old->nr; i++) {
+		if (old->ips[i] >= PERF_CONTEXT_MAX)
+			continue;
+
+		new->ips[j].ip = old->ips[i];
+		new->ips[j].sym = syms[i];
+		j++;
+	}
+
+	new->nr = j;
+}
+
+
+int append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		  struct symbol **syms)
 {
+	struct resolved_chain *filtered;
+
 	if (!chain->nr)
-		return;
-	__append_chain_children(root, chain, syms, 0);
+		return 0;
+
+	filtered = malloc(sizeof(*filtered) +
+			  chain->nr * sizeof(struct resolved_ip));
+	if (!filtered)
+		return -ENOMEM;
+
+	filter_context(chain, filtered, syms);
+
+	if (!filtered->nr)
+		goto end;
+
+	__append_chain_children(root, filtered, 0);
+end:
+	free(filtered);
+
+	return 0;
 }
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index ad4626d..bbd76da 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -56,6 +56,6 @@ static inline u64 cumul_hits(struct callchain_node *node)
 }
 
 int register_callchain_param(struct callchain_param *param);
-void append_chain(struct callchain_node *root, struct ip_callchain *chain,
-		  struct symbol **syms);
+int append_chain(struct callchain_node *root, struct ip_callchain *chain,
+		 struct symbol **syms);
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index c37da8b..5843a9c 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -328,8 +328,6 @@ static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 						   left_margin);
 		i = 0;
 		list_for_each_entry(chain, &child->val, list) {
-			if (chain->ip >= PERF_CONTEXT_MAX)
-				continue;
 			ret += ipchain__fprintf_graph(fp, chain, depth,
 						      new_depth_mask, i++,
 						      new_total,
@@ -368,9 +366,6 @@ static size_t callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 	int ret = 0;
 
 	list_for_each_entry(chain, &self->val, list) {
-		if (chain->ip >= PERF_CONTEXT_MAX)
-			continue;
-
 		if (!i++ && sort__first_dimension == SORT_SYM)
 			continue;
 
-- 
1.6.2.5

