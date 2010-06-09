Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab0FIKOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:14:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:41296 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212Ab0FIKOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:14:19 -0400
Date: Wed, 9 Jun 2010 10:12:41 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       peterz@infradead.org, akpm@linux-foundation.org, fabio@gandalf.sssup.it,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu,
       venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       peterz@infradead.org, akpm@linux-foundation.org, fabio@gandalf.sssup.it,
       suresh.b.siddha@intel.com, tglx@linutronix.de, venki@google.com,
       mingo@elte.hu
In-Reply-To: <1275414172.27810.27961.camel@twins>
References: <1275414172.27810.27961.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/pat] rbtree: Undo augmented trees performance damage
Message-ID: <tip-2463eb8b3093995e09a0d41b3d78ee0cf5fb4249@git.kernel.org>
Git-Commit-ID: 2463eb8b3093995e09a0d41b3d78ee0cf5fb4249
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:12:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2463eb8b3093995e09a0d41b3d78ee0cf5fb4249
Gitweb:     http://git.kernel.org/tip/2463eb8b3093995e09a0d41b3d78ee0cf5fb4249
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sat, 29 May 2010 15:31:43 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 10:32:49 +0200

rbtree: Undo augmented trees performance damage

Reimplement augmented RB-trees without sprinkling extra branches
all over the RB-tree code (which lives in the scheduler hot path).

This approach is 'borrowed' from Fabio's BFQ implementation and
relies on traversing the rebalance path after the RB-tree-op to
correct the heap property for insertion/removal and make up for
the damage done by the tree rotations.

For insertion the rebalance path is trivially that from the new
node upwards to the root, for removal it is that from the deepest
node in the path from the to be removed node that will still
be around after the removal.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Fabio Checconi <fabio@gandalf.sssup.it>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1275414172.27810.27961.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pat_rbtree.c |   34 ++-----------
 include/linux/rbtree.h   |   13 ++++--
 lib/rbtree.c             |  116 ++++++++++++++++++++++++++++-----------------
 3 files changed, 87 insertions(+), 76 deletions(-)

diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
index f537087..a2903e6 100644
--- a/arch/x86/mm/pat_rbtree.c
+++ b/arch/x86/mm/pat_rbtree.c
@@ -34,8 +34,7 @@
  * memtype_lock protects the rbtree.
  */
 
-static void memtype_rb_augment_cb(struct rb_node *node);
-static struct rb_root memtype_rbroot = RB_AUGMENT_ROOT(&memtype_rb_augment_cb);
+static struct rb_root memtype_rbroot = RB_ROOT;
 
 static int is_node_overlap(struct memtype *node, u64 start, u64 end)
 {
@@ -56,7 +55,7 @@ static u64 get_subtree_max_end(struct rb_node *node)
 }
 
 /* Update 'subtree_max_end' for a node, based on node and its children */
-static void update_node_max_end(struct rb_node *node)
+static void memtype_rb_augment_cb(struct rb_node *node, void *__unused)
 {
 	struct memtype *data;
 	u64 max_end, child_max_end;
@@ -78,25 +77,6 @@ static void update_node_max_end(struct rb_node *node)
 	data->subtree_max_end = max_end;
 }
 
-/* Update 'subtree_max_end' for a node and all its ancestors */
-static void update_path_max_end(struct rb_node *node)
-{
-	u64 old_max_end, new_max_end;
-
-	while (node) {
-		struct memtype *data = container_of(node, struct memtype, rb);
-
-		old_max_end = data->subtree_max_end;
-		update_node_max_end(node);
-		new_max_end = data->subtree_max_end;
-
-		if (new_max_end == old_max_end)
-			break;
-
-		node = rb_parent(node);
-	}
-}
-
 /* Find the first (lowest start addr) overlapping range from rb tree */
 static struct memtype *memtype_rb_lowest_match(struct rb_root *root,
 				u64 start, u64 end)
@@ -190,12 +170,6 @@ failure:
 	return -EBUSY;
 }
 
-static void memtype_rb_augment_cb(struct rb_node *node)
-{
-	if (node)
-		update_path_max_end(node);
-}
-
 static void memtype_rb_insert(struct rb_root *root, struct memtype *newdata)
 {
 	struct rb_node **node = &(root->rb_node);
@@ -213,6 +187,7 @@ static void memtype_rb_insert(struct rb_root *root, struct memtype *newdata)
 
 	rb_link_node(&newdata->rb, parent, node);
 	rb_insert_color(&newdata->rb, root);
+	rb_augment_insert(&newdata->rb, memtype_rb_augment_cb, NULL);
 }
 
 int rbt_memtype_check_insert(struct memtype *new, unsigned long *ret_type)
@@ -233,13 +208,16 @@ int rbt_memtype_check_insert(struct memtype *new, unsigned long *ret_type)
 
 struct memtype *rbt_memtype_erase(u64 start, u64 end)
 {
+	struct rb_node *deepest;
 	struct memtype *data;
 
 	data = memtype_rb_exact_match(&memtype_rbroot, start, end);
 	if (!data)
 		goto out;
 
+	deepest = rb_augment_erase_begin(&data->rb);
 	rb_erase(&data->rb, &memtype_rbroot);
+	rb_augment_erase_end(deepest, memtype_rb_augment_cb, NULL);
 out:
 	return data;
 }
diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index fe1872e..7066acb 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -110,7 +110,6 @@ struct rb_node
 struct rb_root
 {
 	struct rb_node *rb_node;
-	void (*augment_cb)(struct rb_node *node);
 };
 
 
@@ -130,9 +129,7 @@ static inline void rb_set_color(struct rb_node *rb, int color)
 	rb->rb_parent_color = (rb->rb_parent_color & ~1) | color;
 }
 
-#define RB_ROOT	(struct rb_root) { NULL, NULL, }
-#define RB_AUGMENT_ROOT(x)	(struct rb_root) { NULL, x}
-
+#define RB_ROOT	(struct rb_root) { NULL, }
 #define	rb_entry(ptr, type, member) container_of(ptr, type, member)
 
 #define RB_EMPTY_ROOT(root)	((root)->rb_node == NULL)
@@ -142,6 +139,14 @@ static inline void rb_set_color(struct rb_node *rb, int color)
 extern void rb_insert_color(struct rb_node *, struct rb_root *);
 extern void rb_erase(struct rb_node *, struct rb_root *);
 
+typedef void (*rb_augment_f)(struct rb_node *node, void *data);
+
+extern void rb_augment_insert(struct rb_node *node,
+			      rb_augment_f func, void *data);
+extern struct rb_node *rb_augment_erase_begin(struct rb_node *node);
+extern void rb_augment_erase_end(struct rb_node *node,
+				 rb_augment_f func, void *data);
+
 /* Find logical next and previous nodes in a tree */
 extern struct rb_node *rb_next(const struct rb_node *);
 extern struct rb_node *rb_prev(const struct rb_node *);
diff --git a/lib/rbtree.c b/lib/rbtree.c
index 15e10b1..4693f79 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -44,11 +44,6 @@ static void __rb_rotate_left(struct rb_node *node, struct rb_root *root)
 	else
 		root->rb_node = right;
 	rb_set_parent(node, right);
-
-	if (root->augment_cb) {
-		root->augment_cb(node);
-		root->augment_cb(right);
-	}
 }
 
 static void __rb_rotate_right(struct rb_node *node, struct rb_root *root)
@@ -72,20 +67,12 @@ static void __rb_rotate_right(struct rb_node *node, struct rb_root *root)
 	else
 		root->rb_node = left;
 	rb_set_parent(node, left);
-
-	if (root->augment_cb) {
-		root->augment_cb(node);
-		root->augment_cb(left);
-	}
 }
 
 void rb_insert_color(struct rb_node *node, struct rb_root *root)
 {
 	struct rb_node *parent, *gparent;
 
-	if (root->augment_cb)
-		root->augment_cb(node);
-
 	while ((parent = rb_parent(node)) && rb_is_red(parent))
 	{
 		gparent = rb_parent(parent);
@@ -240,15 +227,12 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 	else
 	{
 		struct rb_node *old = node, *left;
-		int old_parent_cb = 0;
-		int successor_parent_cb = 0;
 
 		node = node->rb_right;
 		while ((left = node->rb_left) != NULL)
 			node = left;
 
 		if (rb_parent(old)) {
-			old_parent_cb = 1;
 			if (rb_parent(old)->rb_left == old)
 				rb_parent(old)->rb_left = node;
 			else
@@ -263,10 +247,8 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 		if (parent == old) {
 			parent = node;
 		} else {
-			successor_parent_cb = 1;
 			if (child)
 				rb_set_parent(child, parent);
-
 			parent->rb_left = child;
 
 			node->rb_right = old->rb_right;
@@ -277,24 +259,6 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 		node->rb_left = old->rb_left;
 		rb_set_parent(old->rb_left, node);
 
-		if (root->augment_cb) {
-			/*
-			 * Here, three different nodes can have new children.
-			 * The parent of the successor node that was selected
-			 * to replace the node to be erased.
-			 * The node that is getting erased and is now replaced
-			 * by its successor.
-			 * The parent of the node getting erased-replaced.
-			 */
-			if (successor_parent_cb)
-				root->augment_cb(parent);
-
-			root->augment_cb(node);
-
-			if (old_parent_cb)
-				root->augment_cb(rb_parent(old));
-		}
-
 		goto color;
 	}
 
@@ -303,19 +267,15 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 
 	if (child)
 		rb_set_parent(child, parent);
-
-	if (parent) {
+	if (parent)
+	{
 		if (parent->rb_left == node)
 			parent->rb_left = child;
 		else
 			parent->rb_right = child;
-
-		if (root->augment_cb)
-			root->augment_cb(parent);
-
-	} else {
-		root->rb_node = child;
 	}
+	else
+		root->rb_node = child;
 
  color:
 	if (color == RB_BLACK)
@@ -323,6 +283,74 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 }
 EXPORT_SYMBOL(rb_erase);
 
+static void rb_augment_path(struct rb_node *node, rb_augment_f func, void *data)
+{
+	struct rb_node *parent;
+
+up:
+	func(node, data);
+	parent = rb_parent(node);
+	if (!parent)
+		return;
+
+	if (node == parent->rb_left && parent->rb_right)
+		func(parent->rb_right, data);
+	else if (parent->rb_left)
+		func(parent->rb_left, data);
+
+	node = parent;
+	goto up;
+}
+
+/*
+ * after inserting @node into the tree, update the tree to account for
+ * both the new entry and any damage done by rebalance
+ */
+void rb_augment_insert(struct rb_node *node, rb_augment_f func, void *data)
+{
+	if (node->rb_left)
+		node = node->rb_left;
+	else if (node->rb_right)
+		node = node->rb_right;
+
+	rb_augment_path(node, func, data);
+}
+
+/*
+ * before removing the node, find the deepest node on the rebalance path
+ * that will still be there after @node gets removed
+ */
+struct rb_node *rb_augment_erase_begin(struct rb_node *node)
+{
+	struct rb_node *deepest;
+
+	if (!node->rb_right && !node->rb_left)
+		deepest = rb_parent(node);
+	else if (!node->rb_right)
+		deepest = node->rb_left;
+	else if (!node->rb_left)
+		deepest = node->rb_right;
+	else {
+		deepest = rb_next(node);
+		if (deepest->rb_right)
+			deepest = deepest->rb_right;
+		else if (rb_parent(deepest) != node)
+			deepest = rb_parent(deepest);
+	}
+
+	return deepest;
+}
+
+/*
+ * after removal, update the tree to account for the removed entry
+ * and any rebalance damage.
+ */
+void rb_augment_erase_end(struct rb_node *node, rb_augment_f func, void *data)
+{
+	if (node)
+		rb_augment_path(node, func, data);
+}
+
 /*
  * This function returns the first node (in sort order) of the tree.
  */
