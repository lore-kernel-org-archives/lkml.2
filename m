Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab2DNBIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 21:08:19 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51629 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2DNBIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 21:08:17 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/2] [RFC] Range tree implementation
Date: Fri, 13 Apr 2012 18:08:00 -0700
Message-Id: <1334365681-21586-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1334365681-21586-1-git-send-email-john.stultz@linaro.org>
References: <1334365681-21586-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041401-4242-0000-0000-00000157B334
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

Andrew also really wanted this range-tree implementation to be
resuable so we don't duplicate the file locking logic. I'm not
totally convinced that the requirements between the volatile
ranges and file locking are really equivelent, but this reduced
impelementation may make it possible.

Do let me know what you think or if you have other ideas for
better ways to do the same.

Changelog:
v2:
* Reworked code to use an rbtree instead of splaying

v3:
* Added range_tree_next_in_range() to avoid having to start
  lookups from the root every time.
* Fixed some comments and return NULL instead of 0, as suggested
  by Aneesh Kumar K.V

v6:
* Fixed range_tree_in_range() so that it finds the earliest range,
  rather then the first. This allows the next_in_range() function
  to properly cover all the ranges in the tree.
* Minor clenaups to simplify some of the functions

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Android Kernel Team <kernel-team@android.com>
CC: Robert Love <rlove@google.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Hugh Dickins <hughd@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Rik van Riel <riel@redhat.com>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Neil Brown <neilb@suse.de>
CC: Andrea Righi <andrea@betterlinux.com>
CC: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/rangetree.h |   56 ++++++++++++++++++++
 lib/Makefile              |    2 +-
 lib/rangetree.c           |  128 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 185 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/rangetree.h
 create mode 100644 lib/rangetree.c

diff --git a/include/linux/rangetree.h b/include/linux/rangetree.h
new file mode 100644
index 0000000..c61ce7c
--- /dev/null
+++ b/include/linux/rangetree.h
@@ -0,0 +1,56 @@
+#ifndef _LINUX_RANGETREE_H
+#define _LINUX_RANGETREE_H
+
+#include <linux/types.h>
+#include <linux/rbtree.h>
+
+struct range_tree_node {
+	struct rb_node rb;
+	u64 start;
+	u64 end;
+};
+
+struct range_tree_root {
+	struct rb_root head;
+};
+
+static inline void range_tree_init(struct range_tree_root *root)
+{
+	root->head = RB_ROOT;
+}
+
+static inline void range_tree_node_init(struct range_tree_node *node)
+{
+	rb_init_node(&node->rb);
+	node->start = 0;
+	node->end = 0;
+}
+
+static inline int range_tree_empty(struct range_tree_root *root)
+{
+	return RB_EMPTY_ROOT(&root->head);
+}
+
+static inline
+struct range_tree_node *range_tree_root_node(struct range_tree_root *root)
+{
+	struct range_tree_node *ret;
+	ret = container_of(root->head.rb_node, struct range_tree_node, rb);
+	return ret;
+}
+
+extern struct range_tree_node *range_tree_in_range(struct range_tree_root *root,
+							 u64 start, u64 end);
+extern struct range_tree_node *range_tree_in_range_adjacent(
+						struct range_tree_root *root,
+							 u64 start, u64 end);
+extern struct range_tree_node *range_tree_next_in_range(
+						struct range_tree_node *node,
+						u64 start, u64 end);
+extern void range_tree_add(struct range_tree_root *root,
+						struct range_tree_node *node);
+extern void range_tree_remove(struct range_tree_root *root,
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
index 0000000..08185bc
--- /dev/null
+++ b/lib/rangetree.c
@@ -0,0 +1,128 @@
+#include <linux/rangetree.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
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
+struct range_tree_node *range_tree_in_range(struct range_tree_root *root,
+						u64 start, u64 end)
+{
+	struct rb_node *p = root->head.rb_node;
+	struct range_tree_node *candidate, *match = NULL;
+
+	while (p) {
+		candidate = rb_entry(p, struct range_tree_node, rb);
+		if (end < candidate->start)
+			p = p->rb_left;
+		else if (start > candidate->end)
+			p = p->rb_right;
+		else {
+			/* We found one, but try to find an earlier match */
+			match = candidate;
+			p = p->rb_left;
+		}
+	}
+
+	return match;
+}
+
+
+/**
+ * range_tree_in_range_adjacent - Returns the first node that overlaps or
+ *                                is adjacent with the given range.
+ * @root: range_tree root
+ * @start: range start
+ * @end: range end
+ *
+ */
+struct range_tree_node *range_tree_in_range_adjacent(
+					struct range_tree_root *root,
+					u64 start, u64 end)
+{
+	struct rb_node *p = root->head.rb_node;
+	struct range_tree_node *candidate;
+
+	while (p) {
+		candidate = rb_entry(p, struct range_tree_node, rb);
+		if (end+1 < candidate->start)
+			p = p->rb_left;
+		else if (start > candidate->end + 1)
+			p = p->rb_right;
+		else
+			return candidate;
+	}
+	return NULL;
+}
+
+struct range_tree_node *range_tree_next_in_range(struct range_tree_node *node,
+							u64 start, u64 end)
+{
+	struct rb_node *next;
+	struct range_tree_node *candidate;
+	if (!node)
+		return NULL;
+	next = rb_next(&node->rb);
+	if (!next)
+		return NULL;
+
+	candidate = container_of(next, struct range_tree_node, rb);
+
+	if ((candidate->start > end) || (candidate->end < start))
+		return NULL;
+
+	return candidate;
+}
+
+/**
+ * range_tree_add - Add a node to a range tree
+ * @root: range tree to be added to
+ * @node: range_tree_node to be added
+ *
+ * Adds a node to the range tree.
+ */
+void range_tree_add(struct range_tree_root *root,
+					struct range_tree_node *node)
+{
+	struct rb_node **p = &root->head.rb_node;
+	struct rb_node *parent = NULL;
+	struct range_tree_node *ptr;
+
+	WARN_ON_ONCE(!RB_EMPTY_NODE(&node->rb));
+
+	while (*p) {
+		parent = *p;
+		ptr = rb_entry(parent, struct range_tree_node, rb);
+		if (node->start < ptr->start)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&node->rb, parent, p);
+	rb_insert_color(&node->rb, &root->head);
+
+}
+
+
+/**
+ * range_tree_remove: Removes a given node from the tree
+ * @root: root of tree
+ * @node: Node to be removed
+ *
+ * Removes a node and splays the tree
+ */
+void range_tree_remove(struct range_tree_root *root,
+						struct range_tree_node *node)
+{
+	WARN_ON_ONCE(RB_EMPTY_NODE(&node->rb));
+
+	rb_erase(&node->rb, &root->head);
+	RB_CLEAR_NODE(&node->rb);
+}
-- 
1.7.3.2.146.gca209

