Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab1ANDwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:52:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51164 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499Ab1ANDwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:52:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=G3qyT9NgEhDTlxRni1qD4sY4GsZOczEh9mKxjirCl7zBzkVsEEwjE2p9+fLe1Id3si
         iFOcaXt/pxTQ3NCtHq6M75Vq/89zSo+jIvS2MaC7Ja+LdlFuUVirUDltY9BA+fO6+cDB
         Z1EPPSJyhObEAqPlICiF3TWU0vSFGicq5V2fQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/4] perf: Feed callchains into a cursor
Date: Fri, 14 Jan 2011 04:51:58 +0100
Message-Id: <1294977121-5700-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1294977121-5700-1-git-send-email-fweisbec@gmail.com>
References: <1294977121-5700-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callchains are fed with an array of a fixed size.
As a result we iterate over each callchains three times:

- 1st to resolve symbols
- 2nd to filter out context boundaries
- 3rd for the insertion into the tree

This also involves some pairs of memory allocation/deallocation
everytime we insert a callchain, for the filtered out array of
addresses and for the array of symbols that comes along.

Instead, feed the callchains through a linked list with persistent
allocations. It brings several pros like:

- Merge the 1st and 2nd iterations in one. That was possible before
but in a way that would involve allocating an array slightly taller
than necessary because we don't know in advance the number of context
boundaries to filter out.

- Much lesser allocations/deallocations. The linked list keeps
persistent empty entries for the next usages and is extendable at
will.

- Makes it easier for multiple sources of callchains to feed a
stacktrace together. This is deemed to pave the way for cfi based
callchains wherein traditional frame pointer based kernel
stacktraces will precede cfi based user ones, producing an overall
callchain which size is hardly predictable. This requirement
makes the static array obsolete and makes a linked list based
iterator a much more flexible fit.

Basic testing on a big perf file containing callchains (~ 176 MB)
has shown a throughput gain of about 11% with perf report.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/builtin-report.c |   25 +++---
 tools/perf/util/callchain.c |  204 +++++++++++++++++++++----------------------
 tools/perf/util/callchain.h |   66 +++++++++++++-
 tools/perf/util/hist.c      |   13 ++-
 tools/perf/util/hist.h      |    2 +
 tools/perf/util/session.c   |   22 +++--
 tools/perf/util/session.h   |   11 ++-
 7 files changed, 204 insertions(+), 139 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 75183a4..6451869 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -81,18 +81,17 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 					struct addr_location *al,
 					struct sample_data *data)
 {
-	struct map_symbol *syms = NULL;
 	struct symbol *parent = NULL;
-	int err = -ENOMEM;
+	int err = 0;
 	struct hist_entry *he;
 	struct hists *hists;
 	struct perf_event_attr *attr;
 
 	if ((sort__has_parent || symbol_conf.use_callchain) && data->callchain) {
-		syms = perf_session__resolve_callchain(self, al->thread,
-						       data->callchain, &parent);
-		if (syms == NULL)
-			return -ENOMEM;
+		err = perf_session__resolve_callchain(self, al->thread,
+						      data->callchain, &parent);
+		if (err)
+			return err;
 	}
 
 	attr = perf_header__find_attr(data->id, &self->header);
@@ -101,16 +100,17 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	else
 		hists = perf_session__hists_findnew(self, data->id, 0, 0);
 	if (hists == NULL)
-		goto out_free_syms;
+		return -ENOMEM;
+
 	he = __hists__add_entry(hists, al, parent, data->period);
 	if (he == NULL)
-		goto out_free_syms;
-	err = 0;
+		return -ENOMEM;
+
 	if (symbol_conf.use_callchain) {
-		err = callchain_append(he->callchain, data->callchain, syms,
+		err = callchain_append(he->callchain, &self->callchain_cursor,
 				       data->period);
 		if (err)
-			goto out_free_syms;
+			return err;
 	}
 	/*
 	 * Only in the newt browser we are doing integrated annotation,
@@ -119,8 +119,7 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	 */
 	if (use_browser > 0)
 		err = hist_entry__inc_addr_samples(he, al->addr);
-out_free_syms:
-	free(syms);
+
 	return err;
 }
 
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index e12d539..53a49e0 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2009-2010, Frederic Weisbecker <fweisbec@gmail.com>
+ * Copyright (C) 2009-2011, Frederic Weisbecker <fweisbec@gmail.com>
  *
  * Handle the callchains from the stream in an ad-hoc radix tree and then
  * sort them in an rbtree.
@@ -195,26 +195,21 @@ create_child(struct callchain_node *parent, bool inherit_children)
 }
 
 
-struct resolved_ip {
-	u64		  ip;
-	struct map_symbol ms;
-};
-
-struct resolved_chain {
-	u64			nr;
-	struct resolved_ip	ips[0];
-};
-
-
 /*
  * Fill the node with callchain values
  */
 static void
-fill_node(struct callchain_node *node, struct resolved_chain *chain, int start)
+fill_node(struct callchain_node *node, struct callchain_cursor *cursor)
 {
-	unsigned int i;
+	struct callchain_cursor_node *cursor_node;
+
+	node->val_nr = cursor->nr - cursor->pos;
+	if (!node->val_nr)
+		pr_warning("Warning: empty node in callchain tree\n");
 
-	for (i = start; i < chain->nr; i++) {
+	cursor_node = callchain_cursor_current(cursor);
+
+	while (cursor_node) {
 		struct callchain_list *call;
 
 		call = zalloc(sizeof(*call));
@@ -222,23 +217,25 @@ fill_node(struct callchain_node *node, struct resolved_chain *chain, int start)
 			perror("not enough memory for the code path tree");
 			return;
 		}
-		call->ip = chain->ips[i].ip;
-		call->ms = chain->ips[i].ms;
+		call->ip = cursor_node->ip;
+		call->ms.sym = cursor_node->sym;
+		call->ms.map = cursor_node->map;
 		list_add_tail(&call->list, &node->val);
+
+		callchain_cursor_advance(cursor);
+		cursor_node = callchain_cursor_current(cursor);
 	}
-	node->val_nr = chain->nr - start;
-	if (!node->val_nr)
-		pr_warning("Warning: empty node in callchain tree\n");
 }
 
 static void
-add_child(struct callchain_node *parent, struct resolved_chain *chain,
-	  int start, u64 period)
+add_child(struct callchain_node *parent,
+	  struct callchain_cursor *cursor,
+	  u64 period)
 {
 	struct callchain_node *new;
 
 	new = create_child(parent, false);
-	fill_node(new, chain, start);
+	fill_node(new, cursor);
 
 	new->children_hit = 0;
 	new->hit = period;
@@ -250,9 +247,10 @@ add_child(struct callchain_node *parent, struct resolved_chain *chain,
  * Then create another child to host the given callchain of new branch
  */
 static void
-split_add_child(struct callchain_node *parent, struct resolved_chain *chain,
-		struct callchain_list *to_split, int idx_parents, int idx_local,
-		u64 period)
+split_add_child(struct callchain_node *parent,
+		struct callchain_cursor *cursor,
+		struct callchain_list *to_split,
+		u64 idx_parents, u64 idx_local, u64 period)
 {
 	struct callchain_node *new;
 	struct list_head *old_tail;
@@ -277,9 +275,9 @@ split_add_child(struct callchain_node *parent, struct resolved_chain *chain,
 	parent->val_nr = idx_local;
 
 	/* create a new child for the new branch if any */
-	if (idx_total < chain->nr) {
+	if (idx_total < cursor->nr) {
 		parent->hit = 0;
-		add_child(parent, chain, idx_total, period);
+		add_child(parent, cursor, period);
 		parent->children_hit += period;
 	} else {
 		parent->hit = period;
@@ -287,36 +285,41 @@ split_add_child(struct callchain_node *parent, struct resolved_chain *chain,
 }
 
 static int
-append_chain(struct callchain_node *root, struct resolved_chain *chain,
-	     unsigned int start, u64 period);
+append_chain(struct callchain_node *root,
+	     struct callchain_cursor *cursor,
+	     u64 period);
 
 static void
-append_chain_children(struct callchain_node *root, struct resolved_chain *chain,
-		      unsigned int start, u64 period)
+append_chain_children(struct callchain_node *root,
+		      struct callchain_cursor *cursor,
+		      u64 period)
 {
 	struct callchain_node *rnode;
 
 	/* lookup in childrens */
 	chain_for_each_child(rnode, root) {
-		unsigned int ret = append_chain(rnode, chain, start, period);
+		unsigned int ret = append_chain(rnode, cursor, period);
 
 		if (!ret)
 			goto inc_children_hit;
 	}
 	/* nothing in children, add to the current node */
-	add_child(root, chain, start, period);
+	add_child(root, cursor, period);
 
 inc_children_hit:
 	root->children_hit += period;
 }
 
 static int
-append_chain(struct callchain_node *root, struct resolved_chain *chain,
-	     unsigned int start, u64 period)
+append_chain(struct callchain_node *root,
+	     struct callchain_cursor *cursor,
+	     u64 period)
 {
+	struct callchain_cursor_node *curr_snap = cursor->curr;
 	struct callchain_list *cnode;
-	unsigned int i = start;
+	u64 start = cursor->pos;
 	bool found = false;
+	u64 matches;
 
 	/*
 	 * Lookup in the current node
@@ -324,114 +327,95 @@ append_chain(struct callchain_node *root, struct resolved_chain *chain,
 	 * anywhere inside a function.
 	 */
 	list_for_each_entry(cnode, &root->val, list) {
+		struct callchain_cursor_node *node;
 		struct symbol *sym;
 
-		if (i == chain->nr)
+		node = callchain_cursor_current(cursor);
+		if (!node)
 			break;
 
-		sym = chain->ips[i].ms.sym;
+		sym = node->sym;
 
 		if (cnode->ms.sym && sym) {
 			if (cnode->ms.sym->start != sym->start)
 				break;
-		} else if (cnode->ip != chain->ips[i].ip)
+		} else if (cnode->ip != node->ip)
 			break;
 
 		if (!found)
 			found = true;
-		i++;
+
+		callchain_cursor_advance(cursor);
 	}
 
 	/* matches not, relay on the parent */
-	if (!found)
+	if (!found) {
+		cursor->curr = curr_snap;
+		cursor->pos = start;
 		return -1;
+	}
+
+	matches = cursor->pos - start;
 
 	/* we match only a part of the node. Split it and add the new chain */
-	if (i - start < root->val_nr) {
-		split_add_child(root, chain, cnode, start, i - start, period);
+	if (matches < root->val_nr) {
+		split_add_child(root, cursor, cnode, start, matches, period);
 		return 0;
 	}
 
 	/* we match 100% of the path, increment the hit */
-	if (i - start == root->val_nr && i == chain->nr) {
+	if (matches == root->val_nr && cursor->pos == cursor->nr) {
 		root->hit += period;
 		return 0;
 	}
 
 	/* We match the node and still have a part remaining */
-	append_chain_children(root, chain, i, period);
+	append_chain_children(root, cursor, period);
 
 	return 0;
 }
 
-static void filter_context(struct ip_callchain *old, struct resolved_chain *new,
-			   struct map_symbol *syms)
-{
-	int i, j = 0;
-
-	for (i = 0; i < (int)old->nr; i++) {
-		if (old->ips[i] >= PERF_CONTEXT_MAX)
-			continue;
-
-		new->ips[j].ip = old->ips[i];
-		new->ips[j].ms = syms[i];
-		j++;
-	}
-
-	new->nr = j;
-}
-
-
-int callchain_append(struct callchain_root *root, struct ip_callchain *chain,
-		     struct map_symbol *syms, u64 period)
+int callchain_append(struct callchain_root *root,
+		     struct callchain_cursor *cursor,
+		     u64 period)
 {
-	struct resolved_chain *filtered;
-
-	if (!chain->nr)
+	if (!cursor->nr)
 		return 0;
 
-	filtered = zalloc(sizeof(*filtered) +
-			  chain->nr * sizeof(struct resolved_ip));
-	if (!filtered)
-		return -ENOMEM;
-
-	filter_context(chain, filtered, syms);
-
-	if (!filtered->nr)
-		goto end;
+	callchain_cursor_commit(cursor);
 
-	append_chain_children(&root->node, filtered, 0, period);
+	append_chain_children(&root->node, cursor, period);
 
-	if (filtered->nr > root->max_depth)
-		root->max_depth = filtered->nr;
-end:
-	free(filtered);
+	if (cursor->nr > root->max_depth)
+		root->max_depth = cursor->nr;
 
 	return 0;
 }
 
 static int
-merge_chain_branch(struct callchain_node *dst, struct callchain_node *src,
-		   struct resolved_chain *chain)
+merge_chain_branch(struct callchain_cursor *cursor,
+		   struct callchain_node *dst, struct callchain_node *src)
 {
+	struct callchain_cursor_node **old_last = cursor->last;
 	struct callchain_node *child, *next_child;
 	struct callchain_list *list, *next_list;
-	int old_pos = chain->nr;
+	int old_pos = cursor->nr;
 	int err = 0;
 
 	list_for_each_entry_safe(list, next_list, &src->val, list) {
-		chain->ips[chain->nr].ip = list->ip;
-		chain->ips[chain->nr].ms = list->ms;
-		chain->nr++;
+		callchain_cursor_append(cursor, list->ip,
+					list->ms.map, list->ms.sym);
 		list_del(&list->list);
 		free(list);
 	}
 
-	if (src->hit)
-		append_chain_children(dst, chain, 0, src->hit);
+	if (src->hit) {
+		callchain_cursor_commit(cursor);
+		append_chain_children(dst, cursor, src->hit);
+	}
 
 	chain_for_each_child_safe(child, next_child, src) {
-		err = merge_chain_branch(dst, child, chain);
+		err = merge_chain_branch(cursor, dst, child);
 		if (err)
 			break;
 
@@ -439,26 +423,38 @@ merge_chain_branch(struct callchain_node *dst, struct callchain_node *src,
 		free(child);
 	}
 
-	chain->nr = old_pos;
+	cursor->nr = old_pos;
+	cursor->last = old_last;
 
 	return err;
 }
 
-int callchain_merge(struct callchain_root *dst, struct callchain_root *src)
+int callchain_merge(struct callchain_cursor *cursor,
+		    struct callchain_root *dst, struct callchain_root *src)
+{
+	return merge_chain_branch(cursor, &dst->node, &src->node);
+}
+
+int callchain_cursor_append(struct callchain_cursor *cursor,
+			    u64 ip, struct map *map, struct symbol *sym)
 {
-	struct resolved_chain *chain;
-	int err;
+	struct callchain_cursor_node *node = *cursor->last;
 
-	chain = malloc(sizeof(*chain) +
-		       src->max_depth * sizeof(struct resolved_ip));
-	if (!chain)
-		return -ENOMEM;
+	if (!node) {
+		node = calloc(sizeof(*node), 1);
+		if (!node)
+			return -ENOMEM;
 
-	chain->nr = 0;
+		*cursor->last = node;
+	}
 
-	err = merge_chain_branch(&dst->node, &src->node, chain);
+	node->ip = ip;
+	node->map = map;
+	node->sym = sym;
 
-	free(chain);
+	cursor->nr++;
 
-	return err;
+	cursor->last = &node->next;
+
+	return 0;
 }
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index c15fb8c..d74a19a 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -49,6 +49,27 @@ struct callchain_list {
 	struct list_head	list;
 };
 
+/*
+ * A callchain cursor is a single linked list that
+ * let one feed a callchain progressively.
+ * It keeps persitent allocated entries to minimize
+ * allocations.
+ */
+struct callchain_cursor_node {
+	u64				ip;
+	struct map			*map;
+	struct symbol			*sym;
+	struct callchain_cursor_node	*next;
+};
+
+struct callchain_cursor {
+	u64				nr;
+	struct callchain_cursor_node	*first;
+	struct callchain_cursor_node	**last;
+	u64				pos;
+	struct callchain_cursor_node	*curr;
+};
+
 static inline void callchain_init(struct callchain_root *root)
 {
 	INIT_LIST_HEAD(&root->node.brothers);
@@ -67,9 +88,48 @@ static inline u64 cumul_hits(struct callchain_node *node)
 }
 
 int register_callchain_param(struct callchain_param *param);
-int callchain_append(struct callchain_root *root, struct ip_callchain *chain,
-		     struct map_symbol *syms, u64 period);
-int callchain_merge(struct callchain_root *dst, struct callchain_root *src);
+int callchain_append(struct callchain_root *root,
+		     struct callchain_cursor *cursor,
+		     u64 period);
+
+int callchain_merge(struct callchain_cursor *cursor,
+		    struct callchain_root *dst, struct callchain_root *src);
 
 bool ip_callchain__valid(struct ip_callchain *chain, const event_t *event);
+
+/*
+ * Initialize a cursor before adding entries inside, but keep
+ * the previously allocated entries as a cache.
+ */
+static inline void callchain_cursor_reset(struct callchain_cursor *cursor)
+{
+	cursor->nr = 0;
+	cursor->last = &cursor->first;
+}
+
+int callchain_cursor_append(struct callchain_cursor *cursor, u64 ip,
+			    struct map *map, struct symbol *sym);
+
+/* Close a cursor writing session. Initialize for the reader */
+static inline void callchain_cursor_commit(struct callchain_cursor *cursor)
+{
+	cursor->curr = cursor->first;
+	cursor->pos = 0;
+}
+
+/* Cursor reading iteration helpers */
+static inline struct callchain_cursor_node *
+callchain_cursor_current(struct callchain_cursor *cursor)
+{
+	if (cursor->pos == cursor->nr)
+		return NULL;
+
+	return cursor->curr;
+}
+
+static inline void callchain_cursor_advance(struct callchain_cursor *cursor)
+{
+	cursor->curr = cursor->curr->next;
+	cursor->pos++;
+}
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index c749ba6..e876a66 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -211,7 +211,9 @@ void hist_entry__free(struct hist_entry *he)
  * collapse the histogram
  */
 
-static bool collapse__insert_entry(struct rb_root *root, struct hist_entry *he)
+static bool hists__collapse_insert_entry(struct hists *self,
+					 struct rb_root *root,
+					 struct hist_entry *he)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
@@ -226,8 +228,11 @@ static bool collapse__insert_entry(struct rb_root *root, struct hist_entry *he)
 
 		if (!cmp) {
 			iter->period += he->period;
-			if (symbol_conf.use_callchain)
-				callchain_merge(iter->callchain, he->callchain);
+			if (symbol_conf.use_callchain) {
+				callchain_cursor_reset(&self->callchain_cursor);
+				callchain_merge(&self->callchain_cursor, iter->callchain,
+						he->callchain);
+			}
 			hist_entry__free(he);
 			return false;
 		}
@@ -262,7 +267,7 @@ void hists__collapse_resort(struct hists *self)
 		next = rb_next(&n->rb_node);
 
 		rb_erase(&n->rb_node, &self->entries);
-		if (collapse__insert_entry(&tmp, n))
+		if (hists__collapse_insert_entry(self, &tmp, n))
 			hists__inc_nr_entries(self, n);
 	}
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index ee78985..889559b 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -77,6 +77,8 @@ struct hists {
 	u64			event_stream;
 	u32			type;
 	u16			col_len[HISTC_NR_COLS];
+	/* Best would be to reuse the session callchain cursor */
+	struct callchain_cursor	callchain_cursor;
 };
 
 struct hist_entry *__hists__add_entry(struct hists *self,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 313dac2..0c84afa 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -242,17 +242,16 @@ static bool symbol__match_parent_regex(struct symbol *sym)
 	return 0;
 }
 
-struct map_symbol *perf_session__resolve_callchain(struct perf_session *self,
-						   struct thread *thread,
-						   struct ip_callchain *chain,
-						   struct symbol **parent)
+int perf_session__resolve_callchain(struct perf_session *self,
+				    struct thread *thread,
+				    struct ip_callchain *chain,
+				    struct symbol **parent)
 {
 	u8 cpumode = PERF_RECORD_MISC_USER;
 	unsigned int i;
-	struct map_symbol *syms = calloc(chain->nr, sizeof(*syms));
+	int err;
 
-	if (!syms)
-		return NULL;
+	callchain_cursor_reset(&self->callchain_cursor);
 
 	for (i = 0; i < chain->nr; i++) {
 		u64 ip = chain->ips[i];
@@ -281,12 +280,15 @@ struct map_symbol *perf_session__resolve_callchain(struct perf_session *self,
 				*parent = al.sym;
 			if (!symbol_conf.use_callchain)
 				break;
-			syms[i].map = al.map;
-			syms[i].sym = al.sym;
 		}
+
+		err = callchain_cursor_append(&self->callchain_cursor,
+					      ip, al.map, al.sym);
+		if (err)
+			return err;
 	}
 
-	return syms;
+	return 0;
 }
 
 static int process_event_synth_stub(event_t *event __used,
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index decd83f..e815468 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -51,7 +51,8 @@ struct perf_session {
 	int			cwdlen;
 	char			*cwd;
 	struct ordered_samples	ordered_samples;
-	char filename[0];
+	struct callchain_cursor	callchain_cursor;
+	char			filename[0];
 };
 
 struct perf_event_ops;
@@ -94,10 +95,10 @@ int __perf_session__process_events(struct perf_session *self,
 int perf_session__process_events(struct perf_session *self,
 				 struct perf_event_ops *event_ops);
 
-struct map_symbol *perf_session__resolve_callchain(struct perf_session *self,
-						   struct thread *thread,
-						   struct ip_callchain *chain,
-						   struct symbol **parent);
+int perf_session__resolve_callchain(struct perf_session *self,
+				    struct thread *thread,
+				    struct ip_callchain *chain,
+				    struct symbol **parent);
 
 bool perf_session__has_traces(struct perf_session *self, const char *msg);
 
-- 
1.7.3.2

