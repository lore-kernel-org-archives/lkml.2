Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab2BJARH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:17:07 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:34570 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab2BJARF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:17:05 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH 1/2] [RFC] Range tree implementation
Date: Thu,  9 Feb 2012 16:16:32 -0800
Message-Id: <1328832993-23228-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021000-4242-0000-0000-000000BB2401
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After Andrew suggested something like his mumbletree idea
to better store a list of ranges, I worked on a few different
approaches, and this is what I've finally managed to get working.

I suspect range-tree isn't a totally accurate name, but I
couldn't quite make out the difference between range trees
and interval trees, so I just picked one to call it. Do
let me know if you have a better name.

The idea of storing ranges in a tree is nice, but has a number
of complications. When adding a range, its possible that a
large range will consume and merge a number of smaller ranges.
When removing a range, its possible you may end up splitting an
existing range, causing one range to become two. This makes it
very difficult to provide generic list_head like behavior, as
the parent structures would need to be duplicated and removed,
and that has lots of memory ownership issues.

So, this is a much simplified and more list_head like
implementation. You can add a node to a tree, or remove a node
to a tree, but the generic implementation doesn't do the
merging or splitting for you. But it does provide helpers to
find overlapping and adjacent ranges.

I made the tree self-balancing via splaying as it seemed easier
to handle with the merging/splitting cases I originally tried to
make the generic code handle, but since I've dropped that, I
suspect it can be reworked to use a rbtree. I just wanted to get
this out for initial review.

Andrew also really wanted this range-tree implementation to be
resuable so we don't duplicate the file locking logic. I'm not
totally convinced that the requirements between the volatile
ranges and file locking are really equivelent, but this reduced
impelementation may make it possible.

Do let me know what you think or if you have other ideas for
better ways to do the same.

thanks
-john

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Android Kernel Team <kernel-team@android.com>
CC: Robert Love <rlove@google.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Hugh Dickins <hughd@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Rik van Riel <riel@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/rangetree.h |   35 +++++
 lib/Makefile              |    2 +-
 lib/rangetree.c           |  325 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 361 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/rangetree.h
 create mode 100644 lib/rangetree.c

diff --git a/include/linux/rangetree.h b/include/linux/rangetree.h
new file mode 100644
index 0000000..998ebcc
--- /dev/null
+++ b/include/linux/rangetree.h
@@ -0,0 +1,35 @@
+#ifndef _LINUX_RANGETREE_H
+#define _LINUX_RANGETREE_H
+
+#include <linux/types.h>
+#include <linux/fs.h>
+
+struct range_tree_node {
+	struct range_tree_node *parent;
+	struct range_tree_node *left;
+	struct range_tree_node *right;
+	u64 start;
+	u64 end;
+};
+
+static inline void range_tree_node_init(struct range_tree_node *node)
+{
+	node->parent = NULL;
+	node->left = NULL;
+	node->right = NULL;
+	node->start = 0;
+	node->end = 0;
+}
+
+extern struct range_tree_node *range_tree_in_range(struct range_tree_node *root,
+							 u64 start, u64 end);
+extern struct range_tree_node *range_tree_in_range_adjacent(
+						struct range_tree_node *root,
+							 u64 start, u64 end);
+extern struct range_tree_node *range_tree_add(struct range_tree_node *root,
+						struct range_tree_node *node);
+extern struct range_tree_node *range_tree_remove(struct range_tree_node *root,
+						struct range_tree_node *node);
+#endif
+
+
diff --git a/lib/Makefile b/lib/Makefile
index 18515f0..f43ef0d 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o
+	 is_single_threaded.o plist.o decompress.o rangetree.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff --git a/lib/rangetree.c b/lib/rangetree.c
new file mode 100644
index 0000000..db20665
--- /dev/null
+++ b/lib/rangetree.c
@@ -0,0 +1,325 @@
+#include <linux/rangetree.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
+/**
+ * rotate_right - Splay tree helper
+ * @node: node to be rotated right
+ * @root: tree root
+ *
+ * Returns the tree root after rotating the node right
+ */
+static struct range_tree_node *rotate_right(struct range_tree_node *node,
+						struct range_tree_node *root)
+{
+	struct range_tree_node *new_root, *new_right;
+
+	if (!node->left)
+		return root;
+
+	new_root = node->left;
+	new_right = node;
+
+	if (root == node)
+		root = new_root;
+
+	new_right->left = new_root->right;
+	new_root->parent = new_right->parent;
+	if (new_root->parent) {
+		if (new_root->parent->right == new_right)
+			new_root->parent->right = new_root;
+		else
+			new_root->parent->left = new_root;
+	}
+	new_right->parent = new_root;
+
+	new_root->right = new_right;
+
+	if (new_right->left)
+		new_right->left->parent = new_right;
+
+
+	/* Paranoid sanity checking */
+	if (new_root->left)
+		BUG_ON(new_root->left->parent != new_root);
+	if (new_root->right)
+		BUG_ON(new_root->right->parent != new_root);
+	if (new_right->left)
+		BUG_ON(new_right->left->parent != new_right);
+	if (new_right->right)
+		BUG_ON(new_right->right->parent != new_right);
+
+
+	return root;
+
+}
+
+/**
+ * rotate_left - Splay tree helper
+ * @node: node to be rotated left
+ * @root: tree root
+ *
+ * Returns the tree root after rotating the node left
+ */
+static struct range_tree_node *rotate_left(struct range_tree_node *node,
+						struct range_tree_node *root)
+{
+	struct range_tree_node *new_root, *new_left;
+
+	if (!node->right)
+		return root;
+
+	new_root = node->right;
+	new_left = node;
+
+	if (root == node)
+		root = new_root;
+
+	new_left->right = new_root->left;
+	if (new_left->right)
+		new_left->right->parent = new_left;
+	new_root->parent = new_left->parent;
+	if (new_root->parent) {
+		if (new_root->parent->left == new_left)
+			new_root->parent->left = new_root;
+		else
+			new_root->parent->right = new_root;
+	}
+	new_left->parent = new_root;
+	new_root->left = new_left;
+
+
+	/* Paranoid sanity checking */
+	if (new_root->left)
+		BUG_ON(new_root->left->parent != new_root);
+	if (new_root->right)
+		BUG_ON(new_root->right->parent != new_root);
+	if (new_left->left)
+		BUG_ON(new_left->left->parent != new_left);
+	if (new_left->right)
+		BUG_ON(new_left->right->parent != new_left);
+
+	return root;
+}
+
+/**
+ * splay_tree Splays a node to the top of a tree
+ * @root: root of the splay tree
+ * @node: node to be splayed to the root
+ *
+ * Returns the root of a tree after splaying
+ */
+static struct range_tree_node *splay_tree(struct range_tree_node *root,
+						struct range_tree_node *node)
+{
+restart:
+	if (root == node)
+		return root;
+
+	if (node->parent == root) {
+		if (root->left == node)
+			root = rotate_right(root, root);
+		else
+			root = rotate_left(root, root);
+		return root;
+	} else {
+		struct range_tree_node *parent, *grandparent;
+
+		parent = node->parent;
+		grandparent = parent->parent;
+
+		if ((node == parent->left) && (parent == grandparent->left)) {
+			root = rotate_right(grandparent, root);
+			root = rotate_right(parent, root);
+		} else if ((node == parent->right) &&
+					(parent == grandparent->right)) {
+			root = rotate_left(grandparent, root);
+			root = rotate_left(parent, root);
+		} else if ((node == parent->right) &&
+					(parent == grandparent->left)) {
+			root = rotate_left(parent, root);
+			root = rotate_right(grandparent, root);
+		} else if ((node == parent->left) &&
+					(parent == grandparent->right)) {
+			root = rotate_right(parent, root);
+			root = rotate_left(grandparent, root);
+		} else {
+			BUG_ON(1); /* Something is odd */
+		}
+		goto restart;
+	}
+}
+
+
+/**
+ * range_tree_in_range - Returns the first node that overlaps with the
+ *                       given range
+ * @root: range_tree root
+ * @start: range start
+ * @end: range end
+ *
+ */
+struct range_tree_node *range_tree_in_range(struct range_tree_node *root,
+						u64 start, u64 end)
+{
+	struct range_tree_node *candidate = root;
+
+	if (!candidate)
+		return 0;
+restart:
+	if (end < candidate->start) {
+		if (candidate->left) {
+			candidate = candidate->left;
+			goto restart;
+		}
+	} else if (start > candidate->end) {
+		if (candidate->right) {
+			candidate = candidate->right;
+			goto restart;
+		}
+	} else
+		return candidate;
+	return 0;
+}
+
+
+/**
+ * range_tree_in_range - Returns the first node that overlaps or is adjacent
+ *                       with the given range
+ * @root: range_tree root
+ * @start: range start
+ * @end: range end
+ *
+ */
+struct range_tree_node *range_tree_in_range_adjacent(
+					struct range_tree_node *root,
+					u64 start, u64 end)
+{
+	struct range_tree_node *candidate = root;
+
+	if (!candidate)
+		return 0;
+restart:
+	if (end + 1 < candidate->start) {
+		if (candidate->left) {
+			candidate = candidate->left;
+			goto restart;
+		}
+	} else if (start > candidate->end + 1) {
+		if (candidate->right) {
+			candidate = candidate->right;
+			goto restart;
+		}
+	} else
+		return candidate;
+	return 0;
+}
+
+/**
+ * range_tree_add - Add a node to a range tree
+ * @root: range tree to be added to
+ * @node: range_tree_node to be added
+ *
+ * Adds a node to the range tree.
+ */
+struct range_tree_node *range_tree_add(struct range_tree_node *root,
+					struct range_tree_node *node)
+{
+	struct range_tree_node *candidate;
+	/* make sure its not connected */
+	BUG_ON(node->parent || node->left || node->right);
+
+	if (!root)
+		return node;
+
+	candidate = root;
+restart:
+	if (node->start < candidate->start) {
+		if (candidate->left) {
+			candidate = candidate->left;
+			goto restart;
+		}
+		candidate->left = node;
+		node->parent = candidate;
+	} else if (node->start > candidate->start) {
+		if (candidate->right) {
+			candidate = candidate->right;
+			goto restart;
+		}
+		candidate->right = node;
+		node->parent = candidate;
+	}
+
+	root = splay_tree(root, node);
+	return root;
+}
+
+/**
+ * range_tree_merge - Helper to merge two range sub-trees
+ * @left: left subtree to be merged
+ * @right: right subtree to be merged
+ *
+ * Returns a merged range tree of two subtrees. left subtree
+ * must be all less then the right subtree.
+ */
+static struct range_tree_node *range_tree_merge(struct range_tree_node *left,
+						struct range_tree_node *right)
+{
+	struct range_tree_node *merge;
+
+	if (!left)
+		return right;
+	if (!right)
+		return left;
+
+	merge = left;
+	/* grab the right-most node on the left side */
+	while (merge->right)
+		merge = merge->right;
+	merge->right = right;
+	if (right)
+		right->parent = merge;
+
+	return left;
+}
+
+/**
+ * null_node: Helper that clears node data
+ * @node: Node to be cleared
+ */
+static void null_node(struct range_tree_node *node)
+{
+	node->left = node->right = node->parent = NULL;
+	node->start = node->end = 0;
+}
+
+/**
+ * range_tree_remove: Removes a given node from the tree
+ * @root: root of tree
+ * @node: Node to be removed
+ *
+ * Removes a node and splays the tree
+ */
+struct range_tree_node *range_tree_remove(struct range_tree_node *root,
+						struct range_tree_node *node)
+{
+	struct range_tree_node *subtree;
+
+	subtree = range_tree_merge(node->left, node->right);
+
+	if (subtree)
+		subtree->parent = node->parent;
+
+	if (node->parent && node->parent->left == node)
+		node->parent->left = subtree;
+	if (node->parent && node->parent->right == node)
+		node->parent->right = subtree;
+
+	null_node(node);
+	if (node == root)
+		return subtree;
+
+	if (subtree)
+		root = splay_tree(root, subtree);
+	return root;
+}
-- 
1.7.3.2.146.gca209

