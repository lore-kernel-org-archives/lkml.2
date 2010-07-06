Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab0GFSiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 14:38:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:43186 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab0GFSig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 14:38:36 -0400
Date: Tue, 6 Jul 2010 18:37:42 GMT
Message-Id: <201007061837.o66IbgRt006590@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venki@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ali Gholami Rudi <ali@rudi.ir>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86 fixes for 2.6.35-rc5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Jul 2010 18:37:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 980019d74e4b2428362b36a0506519d6d9460800:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/staging-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Darrick J. Wong (1):
      x86, Calgary: Limit the max PHB number to 256

Peter Zijlstra (1):
      rbtree: Undo augmented trees performance damage and regression

 arch/x86/kernel/pci-calgary_64.c |    4 +-
 arch/x86/mm/pat_rbtree.c         |   34 ++---------
 include/linux/rbtree.h           |   13 +++-
 lib/rbtree.c                     |  116 +++++++++++++++++++++++--------------
 4 files changed, 88 insertions(+), 79 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 0b96b55..078d4ec 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -110,7 +110,7 @@ int use_calgary __read_mostly = 0;
  * x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
  * x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
  */
-#define MAX_PHB_BUS_NUM		384
+#define MAX_PHB_BUS_NUM		256
 
 #define PHBS_PER_CALGARY	  4
 
@@ -1056,8 +1056,6 @@ static int __init calgary_init_one(struct pci_dev *dev)
 	struct iommu_table *tbl;
 	int ret;
 
-	BUG_ON(dev->bus->number >= MAX_PHB_BUS_NUM);
-
 	bbar = busno_to_bbar(dev->bus->number);
 	ret = calgary_setup_tar(dev, bbar);
 	if (ret)
diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
index f20eeec..8acaddd 100644
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
@@ -234,13 +209,16 @@ int rbt_memtype_check_insert(struct memtype *new, unsigned long *ret_type)
 
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
