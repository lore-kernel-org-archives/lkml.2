Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966080Ab2FAXjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 19:39:54 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58135 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966064Ab2FAXjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 19:39:33 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: [PATCH 1/3] [RFC] Interval tree implementation
Date: Fri,  1 Jun 2012 16:38:44 -0700
Message-Id: <1338593926-17344-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1338593926-17344-1-git-send-email-john.stultz@linaro.org>
References: <1338593926-17344-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060123-2398-0000-0000-00000721F3DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After Andrew suggested something like his mumbletree idea
to better store a list of intervals, I worked on a few different
approaches, and this is what I've finally managed to get working.

The idea of storing intervals in a tree is nice, but has a number
of complications. When adding an interval, its possible that a
large interval will consume and merge a number of smaller intervals.
When removing a interval, its possible you may end up splitting an
existing interval, causing one interval to become two. This makes it
very difficult to provide generic list_head like behavior, as
the parent structures would need to be duplicated and removed,
and that has lots of memory ownership issues.

So, this is a much simplified and more list_head like
implementation. You can add a node to a tree, or remove a node
to a tree, but the generic implementation doesn't do the
merging or splitting for you. But it does provide helpers to
find overlapping and adjacent intervals.

Andrew also really wanted this interval-tree implementation to be
resuable so we don't duplicate the file locking logic. I'm not
totally convinced that the requirements between the volatile
intervals and file locking are really equivelent, but this reduced
impelementation may make it possible.

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

v7:
* Changed terminology from rangetree to intervaltree as suggested
  by Jan Kara

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
CC: Taras Glek <tgek@mozilla.com>
CC: Mike Hommey <mh@glandium.org>
CC: Jan Kara <jack@suse.cz>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/intervaltree.h |   55 +++++++++++++++++++
 lib/Makefile                 |    2 +-
 lib/intervaltree.c           |  119 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 175 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/intervaltree.h
 create mode 100644 lib/intervaltree.c

diff --git a/include/linux/intervaltree.h b/include/linux/intervaltree.h
new file mode 100644
index 0000000..cfaa174
--- /dev/null
+++ b/include/linux/intervaltree.h
@@ -0,0 +1,55 @@
+#ifndef _LINUX_INTERVALTREE_H
+#define _LINUX_INTERVALTREE_H
+
+#include <linux/types.h>
+#include <linux/rbtree.h>
+
+struct interval_tree_node {
+	struct rb_node rb;
+	u64 start;
+	u64 end;
+};
+
+struct interval_tree_root {
+	struct rb_root head;
+};
+
+static inline void interval_tree_init(struct interval_tree_root *root)
+{
+	root->head = RB_ROOT;
+}
+
+static inline void interval_tree_node_init(struct interval_tree_node *node)
+{
+	rb_init_node(&node->rb);
+	node->start = 0;
+	node->end = 0;
+}
+
+static inline int interval_tree_empty(struct interval_tree_root *root)
+{
+	return RB_EMPTY_ROOT(&root->head);
+}
+
+static inline
+struct interval_tree_node *interval_tree_root_node(
+						struct interval_tree_root *root)
+{
+	struct interval_tree_node *ret;
+	ret = container_of(root->head.rb_node, struct interval_tree_node, rb);
+	return ret;
+}
+
+extern struct interval_tree_node *interval_tree_in_interval(
+						struct interval_tree_root *root,
+						 u64 start, u64 end);
+extern struct interval_tree_node *interval_tree_next_in_interval(
+						struct interval_tree_node *node,
+						u64 start, u64 end);
+extern void interval_tree_add(struct interval_tree_root *root,
+					struct interval_tree_node *node);
+extern void interval_tree_remove(struct interval_tree_root *root,
+					struct interval_tree_node *node);
+#endif
+
+
diff --git a/lib/Makefile b/lib/Makefile
index 8c31a0c..2bbad25 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o
+	 is_single_threaded.o plist.o decompress.o intervaltree.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff --git a/lib/intervaltree.c b/lib/intervaltree.c
new file mode 100644
index 0000000..47c52e0
--- /dev/null
+++ b/lib/intervaltree.c
@@ -0,0 +1,119 @@
+#include <linux/intervaltree.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
+/* This code implements a naive interval tree, which stores a series of
+ * non-intersecting intervals.
+ * More complex interval trees can be read about here:
+ *		http://en.wikipedia.org/wiki/Interval_tree
+ */
+
+
+/**
+ * interval_tree_in_interval - Returns the first node that intersects with the
+ *                             given interval
+ * @root: interval_tree root
+ * @start: interval start
+ * @end: interval end
+ *
+ */
+struct interval_tree_node *interval_tree_in_interval(
+						struct interval_tree_root *root,
+						u64 start, u64 end)
+{
+	struct rb_node *p = root->head.rb_node;
+	struct interval_tree_node *candidate, *match = NULL;
+
+	while (p) {
+		candidate = rb_entry(p, struct interval_tree_node, rb);
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
+ * interval_tree_next_in_interval - Return the next interval in a intervaltree
+ *                                  thatintersects with a specified interval.
+ * @root: interval_tree root
+ * @start: interval start
+ * @end: interval end
+ *
+ */
+struct interval_tree_node *interval_tree_next_in_interval(
+						struct interval_tree_node *node,
+						u64 start, u64 end)
+{
+	struct rb_node *next;
+	struct interval_tree_node *candidate;
+	if (!node)
+		return NULL;
+	next = rb_next(&node->rb);
+	if (!next)
+		return NULL;
+
+	candidate = container_of(next, struct interval_tree_node, rb);
+
+	if ((candidate->start > end) || (candidate->end < start))
+		return NULL;
+
+	return candidate;
+}
+
+/**
+ * interval_tree_add - Add a node to a interval tree
+ * @root: interval tree to be added to
+ * @node: interval_tree_node to be added
+ *
+ * Adds a node to the interval tree. Added interval should not intersect with
+ * existing intervals in the tree.
+ */
+void interval_tree_add(struct interval_tree_root *root,
+					struct interval_tree_node *node)
+{
+	struct rb_node **p = &root->head.rb_node;
+	struct rb_node *parent = NULL;
+	struct interval_tree_node *ptr;
+
+	WARN_ON_ONCE(!RB_EMPTY_NODE(&node->rb));
+
+	/* XXX might want to conditionalize this on debugging checks */
+	WARN_ON_ONCE(!!interval_tree_in_interval(root, node->start, node->end));
+
+	while (*p) {
+		parent = *p;
+		ptr = rb_entry(parent, struct interval_tree_node, rb);
+		if (node->start < ptr->start)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&node->rb, parent, p);
+	rb_insert_color(&node->rb, &root->head);
+}
+
+
+/**
+ * interval_tree_remove: Removes a given node from the tree
+ * @root: root of tree
+ * @node: Node to be removed
+ *
+ * Removes a node and splays the tree
+ */
+void interval_tree_remove(struct interval_tree_root *root,
+					struct interval_tree_node *node)
+{
+	WARN_ON_ONCE(RB_EMPTY_NODE(&node->rb));
+
+	rb_erase(&node->rb, &root->head);
+	RB_CLEAR_NODE(&node->rb);
+}
-- 
1.7.3.2.146.gca209

