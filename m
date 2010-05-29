Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0E2Nbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 09:31:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:44098 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab0E2Nbn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 09:31:43 -0400
Subject: [PATCH] rbtree: undo augmented damage -v2
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venki@google.com>, suresh.b.siddha@intel.com,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Fabio Checconi <fabio@gandalf.sssup.it>
In-Reply-To: <1275136178.27810.13539.camel@twins>
References: <20100210232343.GA11465@linux-os.sc.intel.com>
	 <tip-17d9ddc72fb8bba0d4f67868c9c612e472a594a9@git.kernel.org>
	 <1275136178.27810.13539.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 29 May 2010 15:31:42 +0200
Message-ID: <1275139902.27810.13737.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A better changelog, and I guess we can keep the explanation of
the augmented rb-tree since it doesn't actually mentions the
interface, merely the idea of adding a heap to the binary tree.

The patch simply reverts the rbtree.c hunk, and keeps the non-conforming
style it has..

---
Subject: rbtree: Undo augmented damage
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Sat May 29 15:14:02 CEST 2010

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

Cc: Fabio Checconi <fabio@gandalf.sssup.it>
Cc: suresh.b.siddha@intel.com
Cc: venki@google.com
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/mm/pat_rbtree.c |    9 ++--
 include/linux/rbtree.h   |   13 ++++--
 lib/rbtree.c             |   97 +++++++++++++++++++++++++----------------------
 3 files changed, 68 insertions(+), 51 deletions(-)

Index: linux-2.6/arch/x86/mm/pat_rbtree.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat_rbtree.c
+++ linux-2.6/arch/x86/mm/pat_rbtree.c
@@ -34,8 +34,7 @@
  * memtype_lock protects the rbtree.
  */
 
-static void memtype_rb_augment_cb(struct rb_node *node);
-static struct rb_root memtype_rbroot = RB_AUGMENT_ROOT(&memtype_rb_augment_cb);
+static struct rb_root memtype_rbroot = RB_ROOT;
 
 static int is_node_overlap(struct memtype *node, u64 start, u64 end)
 {
@@ -190,7 +189,7 @@ failure:
 	return -EBUSY;
 }
 
-static void memtype_rb_augment_cb(struct rb_node *node)
+static void memtype_rb_augment_cb(struct rb_node *node, void *data)
 {
 	if (node)
 		update_path_max_end(node);
@@ -213,6 +212,7 @@ static void memtype_rb_insert(struct rb_
 
 	rb_link_node(&newdata->rb, parent, node);
 	rb_insert_color(&newdata->rb, root);
+	rb_augment_insert(&newdata->rb, memtype_rb_augment_cb, NULL);
 }
 
 int rbt_memtype_check_insert(struct memtype *new, unsigned long *ret_type)
@@ -233,13 +233,16 @@ int rbt_memtype_check_insert(struct memt
 
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
Index: linux-2.6/include/linux/rbtree.h
===================================================================
--- linux-2.6.orig/include/linux/rbtree.h
+++ linux-2.6/include/linux/rbtree.h
@@ -110,7 +110,6 @@ struct rb_node
 struct rb_root
 {
 	struct rb_node *rb_node;
-	void (*augment_cb)(struct rb_node *node);
 };
 
 
@@ -130,9 +129,7 @@ static inline void rb_set_color(struct r
 	rb->rb_parent_color = (rb->rb_parent_color & ~1) | color;
 }
 
-#define RB_ROOT	(struct rb_root) { NULL, NULL, }
-#define RB_AUGMENT_ROOT(x)	(struct rb_root) { NULL, x}
-
+#define RB_ROOT	(struct rb_root) { NULL, }
 #define	rb_entry(ptr, type, member) container_of(ptr, type, member)
 
 #define RB_EMPTY_ROOT(root)	((root)->rb_node == NULL)
@@ -142,6 +139,14 @@ static inline void rb_set_color(struct r
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
Index: linux-2.6/lib/rbtree.c
===================================================================
--- linux-2.6.orig/lib/rbtree.c
+++ linux-2.6/lib/rbtree.c
@@ -44,11 +44,6 @@ static void __rb_rotate_left(struct rb_n
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
@@ -72,20 +67,12 @@ static void __rb_rotate_right(struct rb_
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
@@ -240,15 +227,12 @@ void rb_erase(struct rb_node *node, stru
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
@@ -263,10 +247,8 @@ void rb_erase(struct rb_node *node, stru
 		if (parent == old) {
 			parent = node;
 		} else {
-			successor_parent_cb = 1;
 			if (child)
 				rb_set_parent(child, parent);
-
 			parent->rb_left = child;
 
 			node->rb_right = old->rb_right;
@@ -277,24 +259,6 @@ void rb_erase(struct rb_node *node, stru
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
 
@@ -303,19 +267,15 @@ void rb_erase(struct rb_node *node, stru
 
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
@@ -324,6 +284,55 @@ void rb_erase(struct rb_node *node, stru
 EXPORT_SYMBOL(rb_erase);
 
 /*
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
+	func(node, data);
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
+		func(node, data);
+}
+
+/*
  * This function returns the first node (in sort order) of the tree.
  */
 struct rb_node *rb_first(const struct rb_root *root)

