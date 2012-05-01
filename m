Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab2EAQAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 12:00:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36426 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab2EAQAN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 12:00:13 -0400
Message-ID: <1335888000.13683.158.camel@twins>
Subject: Re: Generic rbtree search & insert cores
From: Peter Zijlstra <peterz@infradead.org>
To: daniel.santos@pobox.com
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org
Date: Tue, 01 May 2012 18:00:00 +0200
In-Reply-To: <1335871228.13683.141.camel@twins>
References: <4F9E7365.2040907@att.net> <1335871228.13683.141.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-01 at 13:20 +0200, Peter Zijlstra wrote:
> On Mon, 2012-04-30 at 06:11 -0500, Daniel Santos wrote:
> > 
> > So as long as our struct rbtree_relationship is a compile-time
> > constant, the generated code will look pretty much (if not exactly)
> > like that of the example code in rbtree.h.  Please let me know what
> > you think.  I've tested this in a userspace program, but haven't fully
> > stress tested it in kernelspace yet. 
> 
> Right, this ought to work.
> 
> I'm not sure the root_offset thing is worth it though, passing in the
> rb_root pointer isn't much of a hassle, in fact I'd expect to pass rb
> related pointers to a function called rbtree_insert().
> 
> Also, using a macro to create the rbtree_relationship thing would make
> it easier. Something like:
> 
> 	RB_RELATION(struct mouse, node, name, name_cmp);
> 
> I'd think you'd also want to provide an insertion variant that does the
> leftmost thing, that's used in several places, and you'd also need one
> for the augmented rb-tree.

Something like the below,.. I wanted to add typechecking to
__RB_RELS_KEY and __RB_RELS_LEFT like:

#define __RB_RELS_KEY(_node_type, _node, _key) 				\
	(typecheck(struct rb_node *, &((_node_type *)NULL)->_node),	\
	 __REL_OFFSET(_node_type, _node, _key))

#define __RB_RELS_LEFT(_root_type, _root, _left) 			\
	(typecheck(struct rb_root *, &((_root_type *)NULL)->_root),	\
	 typecheck(struct rb_node *, ((_root_type *)NULL)->_left),	\
	 __REL_OFFSET(_root_type, _root, _left))

But I didn't find a way to make GCC like that.

The below compiles, I haven't looked at the generated asm, nor booted
the thing.

---
 include/linux/rbtree.h |   84 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/fair.c    |   51 ++++++-----------------------
 2 files changed, 93 insertions(+), 42 deletions(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 033b507..2a5f803 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -96,6 +96,8 @@ static inline struct page * rb_insert_page_cache(struct inode * inode,
 
 #include <linux/kernel.h>
 #include <linux/stddef.h>
+#include <linux/typecheck.h>
+#include <linux/bug.h>
 
 struct rb_node
 {
@@ -174,4 +176,86 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
 	*rb_link = node;
 }
 
+struct rbtree_relations {
+	size_t key_offset;
+	size_t left_offset;
+
+	bool (*less)(const void *a, const void *b);
+};
+
+#define __REL_OFFSET(_t, _f1, _f2) \
+	(offsetof(_t, _f2) - offsetof(_t, _f1))
+
+#define __RB_RELS_KEY(_node_type, _node, _key) 				\
+	__REL_OFFSET(_node_type, _node, _key)
+
+#define __RB_RELS_LEFT(_root_type, _root, _left) 			\
+	__REL_OFFSET(_root_type, _root, _left)
+
+#define RB_RELATIONS(_node_type, _node, _key, _less) 			\
+	(const struct rbtree_relations){				\
+		.key_offset = __RB_RELS_KEY(_node_type, _node, _key),	\
+		.less = (bool (*)(const void *, const void *))_less,	\
+	}
+
+#define RB_RELATIONS_LEFT(_root_type, _root, _left, _node_type, _node, _key, _less) \
+	(const struct rbtree_relations){				\
+		.key_offset = __RB_RELS_KEY(_node_type, _node, _key),	\
+		.left_offset = __RB_RELS_LEFT(_root_type, _root, _left), \
+		.less = (bool (*)(const void *, const void *))_less,	\
+	}
+
+static __always_inline 
+const void *__rb_node_to_key(const struct rbtree_relations *rel, struct rb_node *node)
+{
+	BUILD_BUG_ON(!__builtin_constant_p(rel->key_offset));
+	return (const void *)((char *)node + rel->key_offset);
+}
+
+static __always_inline
+struct rb_node **__rb_root_to_left(const struct rbtree_relations *rel, struct rb_root *root)
+{
+	BUILD_BUG_ON(!__builtin_constant_p(rel->left_offset));
+	return (struct rb_node **)((char *)root + rel->left_offset);
+}
+
+static __always_inline 
+void rbtree_insert(struct rb_root *root, struct rb_node *node,
+		   const struct rbtree_relations *rel)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	const void *key = __rb_node_to_key(rel, node);
+	int leftmost = 1;
+
+	while (*p) {
+		parent = *p;
+		if (rel->less(key, __rb_node_to_key(rel, *p)))
+			p = &(*p)->rb_left;
+		else {
+			p = &(*p)->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	if (rel->left_offset && leftmost)
+		*__rb_root_to_left(rel, root) = node;
+
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, root);
+}
+
+static __always_inline
+void rbtree_remove(struct rb_root *root, struct rb_node *node,
+		   const struct rbtree_relations *rel)
+{
+	if (rel->left_offset) {
+		struct rb_node **left = __rb_root_to_left(rel, root);
+		
+		if (*left == node)
+			*left = rb_next(node);
+	}
+	rb_erase(node, root);
+}
+
 #endif	/* _LINUX_RBTREE_H */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e955364..81424a9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -441,8 +441,8 @@ static inline u64 min_vruntime(u64 min_vruntime, u64 vruntime)
 	return min_vruntime;
 }
 
-static inline int entity_before(struct sched_entity *a,
-				struct sched_entity *b)
+static inline bool entity_before(struct sched_entity *a,
+				 struct sched_entity *b)
 {
 	return (s64)(a->vruntime - b->vruntime) < 0;
 }
@@ -472,55 +472,22 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq)
 #endif
 }
 
+static const struct rbtree_relations fair_tree_rels = 
+	RB_RELATIONS_LEFT(struct cfs_rq, tasks_timeline, rb_leftmost,
+			  struct sched_entity, run_node, vruntime,
+			  entity_before);
+
 /*
  * Enqueue an entity into the rb-tree:
  */
 static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
-	struct rb_node *parent = NULL;
-	struct sched_entity *entry;
-	int leftmost = 1;
-
-	/*
-	 * Find the right place in the rbtree:
-	 */
-	while (*link) {
-		parent = *link;
-		entry = rb_entry(parent, struct sched_entity, run_node);
-		/*
-		 * We dont care about collisions. Nodes with
-		 * the same key stay together.
-		 */
-		if (entity_before(se, entry)) {
-			link = &parent->rb_left;
-		} else {
-			link = &parent->rb_right;
-			leftmost = 0;
-		}
-	}
-
-	/*
-	 * Maintain a cache of leftmost tree entries (it is frequently
-	 * used):
-	 */
-	if (leftmost)
-		cfs_rq->rb_leftmost = &se->run_node;
-
-	rb_link_node(&se->run_node, parent, link);
-	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
+	rbtree_insert(&cfs_rq->tasks_timeline, &se->run_node, &fair_tree_rels);
 }
 
 static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	if (cfs_rq->rb_leftmost == &se->run_node) {
-		struct rb_node *next_node;
-
-		next_node = rb_next(&se->run_node);
-		cfs_rq->rb_leftmost = next_node;
-	}
-
-	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+	rbtree_remove(&cfs_rq->tasks_timeline, &se->run_node, &fair_tree_rels);
 }
 
 struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)

