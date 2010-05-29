Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab0E2M3l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 08:29:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:54521 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575Ab0E2M3i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 08:29:38 -0400
Subject: [RFC][PATCH] rbtree: undo augmented damage
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org, Fabio Checconi <fabio@gandalf.sssup.it>
In-Reply-To: <tip-17d9ddc72fb8bba0d4f67868c9c612e472a594a9@git.kernel.org>
References: <20100210232343.GA11465@linux-os.sc.intel.com>
	 <tip-17d9ddc72fb8bba0d4f67868c9c612e472a594a9@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 29 May 2010 14:29:38 +0200
Message-ID: <1275136178.27810.13539.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 00:21 +0000, tip-bot for Pallipadi, Venkatesh wrote:
> Commit-ID:  17d9ddc72fb8bba0d4f67868c9c612e472a594a9
> Gitweb:     http://git.kernel.org/tip/17d9ddc72fb8bba0d4f67868c9c612e472a594a9
> Author:     Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
> AuthorDate: Wed, 10 Feb 2010 15:23:44 -0800
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Thu, 18 Feb 2010 15:40:56 -0800
> 
> rbtree: Add support for augmented rbtrees
> 
> Add support for augmented rbtrees in core rbtree code.
> 
> This will be used in subsequent patches, in x86 PAT code, which needs
> interval trees to efficiently keep track of PAT ranges.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> LKML-Reference: <20100210232343.GA11465@linux-os.sc.intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com> 

How about the below, which undoes all the damage to the rb_tree code?

Its likely this method is faster than the previously implemented one,
simply because it only does the whole update pass a single time, not on
every rotate.

It certainly removes all the extra conditionals in the RB-tree code,
which live on the scheduler hot-path.

(Compile tested only)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/rbtree.txt |   58 ---------------------------
 arch/x86/mm/pat_rbtree.c |    9 +++-
 include/linux/rbtree.h   |   13 ++++--
 lib/rbtree.c             |   97 +++++++++++++++++++++++++---------------------
 4 files changed, 68 insertions(+), 109 deletions(-)

diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
index 221f38b..aae8355 100644
--- a/Documentation/rbtree.txt
+++ b/Documentation/rbtree.txt
@@ -190,61 +190,3 @@ Example:
   for (node = rb_first(&mytree); node; node = rb_next(node))
 	printk("key=%s\n", rb_entry(node, struct mytype, node)->keystring);
 
-Support for Augmented rbtrees
------------------------------
-
-Augmented rbtree is an rbtree with "some" additional data stored in each node.
-This data can be used to augment some new functionality to rbtree.
-Augmented rbtree is an optional feature built on top of basic rbtree
-infrastructure. rbtree user who wants this feature will have an augment
-callback function in rb_root initialized.
-
-This callback function will be called from rbtree core routines whenever
-a node has a change in one or both of its children. It is the responsibility
-of the callback function to recalculate the additional data that is in the
-rb node using new children information. Note that if this new additional
-data affects the parent node's additional data, then callback function has
-to handle it and do the recursive updates.
-
-
-Interval tree is an example of augmented rb tree. Reference -
-"Introduction to Algorithms" by Cormen, Leiserson, Rivest and Stein.
-More details about interval trees:
-
-Classical rbtree has a single key and it cannot be directly used to store
-interval ranges like [lo:hi] and do a quick lookup for any overlap with a new
-lo:hi or to find whether there is an exact match for a new lo:hi.
-
-However, rbtree can be augmented to store such interval ranges in a structured
-way making it possible to do efficient lookup and exact match.
-
-This "extra information" stored in each node is the maximum hi
-(max_hi) value among all the nodes that are its descendents. This
-information can be maintained at each node just be looking at the node
-and its immediate children. And this will be used in O(log n) lookup
-for lowest match (lowest start address among all possible matches)
-with something like:
-
-find_lowest_match(lo, hi, node)
-{
-	lowest_match = NULL;
-	while (node) {
-		if (max_hi(node->left) > lo) {
-			// Lowest overlap if any must be on left side
-			node = node->left;
-		} else if (overlap(lo, hi, node)) {
-			lowest_match = node;
-			break;
-		} else if (lo > node->lo) {
-			// Lowest overlap if any must be on right side
-			node = node->right;
-		} else {
-			break;
-		}
-	}
-	return lowest_match;
-}
-
-Finding exact match will be to first find lowest match and then to follow
-successor nodes looking for exact match, until the start of a node is beyond
-the hi value we are looking for.
diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
index f537087..ece5a67 100644
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
@@ -190,7 +189,7 @@ failure:
 	return -EBUSY;
 }
 
-static void memtype_rb_augment_cb(struct rb_node *node)
+static void memtype_rb_augment_cb(struct rb_node *node, void *data)
 {
 	if (node)
 		update_path_max_end(node);
@@ -213,6 +212,7 @@ static void memtype_rb_insert(struct rb_root *root, struct memtype *newdata)
 
 	rb_link_node(&newdata->rb, parent, node);
 	rb_insert_color(&newdata->rb, root);
+	rb_augment_insert(&newdata->rb, memtype_rb_augment_cb, NULL);
 }
 
 int rbt_memtype_check_insert(struct memtype *new, unsigned long *ret_type)
@@ -233,13 +233,16 @@ int rbt_memtype_check_insert(struct memtype *new, unsigned long *ret_type)
 
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
index 15e10b1..945bff4 100644
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
@@ -324,6 +284,55 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
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
+ * that will still be there after @se gets removed
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

