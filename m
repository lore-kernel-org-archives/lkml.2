Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab1BVSzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:55:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab1BVSzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:55:09 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [RFC PATCH 1/3] Weight-balanced tree
To: avi@redhat.com
Cc: alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, mtosatti@redhat.com, xiaoguangrong@cn.fujitsu.com
Date: Tue, 22 Feb 2011 11:55:05 -0700
Message-ID: <20110222185456.22026.28200.stgit@s20.home>
In-Reply-To: <20110222183822.22026.62832.stgit@s20.home>
References: <20110222183822.22026.62832.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 include/linux/wbtree.h |   55 ++++++++++++++++
 lib/Makefile           |    3 +
 lib/wbtree.c           |  170 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 227 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/wbtree.h
 create mode 100644 lib/wbtree.c

diff --git a/include/linux/wbtree.h b/include/linux/wbtree.h
new file mode 100644
index 0000000..ef70f6f
--- /dev/null
+++ b/include/linux/wbtree.h
@@ -0,0 +1,55 @@
+/*
+ * Weight-balanced binary tree
+ *
+ * The balance of this tree is based on search probability.  The
+ * heaviest weighted nodes (the ones we're most likely to hit), are
+ * at the top of each subtree.
+ *
+ * Copywrite (C) 2011 Red Hat, Inc.
+ *
+ * Authors:
+ *   Alex Williamson <alex.williamson@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ */
+#ifndef _LINUX_WBTREE_H
+#define _LINUX_WBTREE_H
+
+#include <linux/kernel.h>
+#include <linux/stddef.h>
+
+struct wb_node {
+	struct wb_node *wb_parent;
+	struct wb_node *wb_left;
+	struct wb_node *wb_right;
+	unsigned long wb_weight;
+};
+
+struct wb_root {
+	struct wb_node *wb_node;
+};
+
+#define WB_ROOT (struct wb_root) { NULL, }
+#define wb_entry(ptr, type, member) container_of(ptr, type, member)
+
+extern void wb_rebalance(struct wb_node *node, struct wb_root *root);
+extern void wb_erase(struct wb_node *node, struct wb_root *root);
+extern struct wb_node *wb_first(struct wb_root *root);
+extern struct wb_node *wb_last(struct wb_root *root);
+extern struct wb_node *wb_next(struct wb_node *node);
+extern struct wb_node *wb_prev(struct wb_node *node);
+
+static inline void wb_set_weight(struct wb_node *node, unsigned long weight)
+{
+	node->wb_weight = weight;
+}
+
+static inline void wb_link_node(struct wb_node *node, struct wb_node *parent,
+				struct wb_node **wb_link)
+{
+	node->wb_left = node->wb_right = NULL;
+	node->wb_parent = parent;
+	*wb_link = node;
+}
+#endif /* _LINUX_WBTREE_H */
diff --git a/lib/Makefile b/lib/Makefile
index cbb774f..5c42e63 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -21,7 +21,8 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o
+	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o \
+	 wbtree.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff --git a/lib/wbtree.c b/lib/wbtree.c
new file mode 100644
index 0000000..54c3817
--- /dev/null
+++ b/lib/wbtree.c
@@ -0,0 +1,170 @@
+/*
+ * Weight-balanced binary tree
+ *
+ * The balance of this tree is based on search probability.  The
+ * heaviest weighted nodes (the ones we're most likely to hit), are
+ * at the top of each subtree.
+ *
+ * Copywrite (C) 2011 Red Hat, Inc.
+ *
+ * Authors:
+ *   Alex Williamson <alex.williamson@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ */
+#include <linux/wbtree.h>
+#include <linux/module.h>
+
+static void __wb_rotate_left(struct wb_node *node, struct wb_root *root)
+{
+	struct wb_node *right = node->wb_right;
+	struct wb_node *parent = node->wb_parent;
+
+	if ((node->wb_right = right->wb_left))
+		right->wb_left->wb_parent = node;
+	right->wb_left = node;
+
+	right->wb_parent = parent;
+
+	if (parent) {
+		if (node == parent->wb_left)
+			parent->wb_left = right;
+		else
+			parent->wb_right = right;
+	} else
+		root->wb_node = right;
+
+	node->wb_parent = right;
+}
+
+static void __wb_rotate_right(struct wb_node *node, struct wb_root *root)
+{
+	struct wb_node *left = node->wb_left;
+	struct wb_node *parent = node->wb_parent;
+
+	if ((node->wb_left = left->wb_right))
+		left->wb_right->wb_parent = node;
+	left->wb_right = node;
+
+	left->wb_parent = parent;
+
+	if (parent) {
+		if (node == parent->wb_right)
+			parent->wb_right = left;
+		else
+			parent->wb_left = left;
+	} else
+		root->wb_node = left;
+
+	node->wb_parent = left;
+}
+
+void wb_rebalance(struct wb_node *node, struct wb_root *root)
+{
+	while (node->wb_parent && node->wb_parent->wb_weight < node->wb_weight) {
+		if (node == node->wb_parent->wb_left)
+			__wb_rotate_right(node->wb_parent, root);
+		else
+			__wb_rotate_left(node->wb_parent, root);
+	}
+}
+EXPORT_SYMBOL(wb_rebalance);
+
+void wb_erase(struct wb_node *node, struct wb_root *root)
+{
+	while (node->wb_left || node->wb_right) {
+		if (!node->wb_left)
+			__wb_rotate_left(node, root);
+		else if (!node->wb_right)
+			__wb_rotate_right(node, root);
+		else {
+			if (node->wb_left->wb_weight >
+			    node->wb_right->wb_weight)
+				__wb_rotate_right(node, root);
+			else
+				__wb_rotate_left(node, root);
+		}
+	}
+
+	if (node->wb_parent) {
+		if (node->wb_parent->wb_left == node)
+			node->wb_parent->wb_left = NULL;
+		else
+			node->wb_parent->wb_right = NULL;
+	} else
+		root->wb_node = NULL;
+}
+EXPORT_SYMBOL(wb_erase);
+
+struct wb_node *wb_first(struct wb_root *root)
+{
+	struct wb_node *node;
+
+	node = root->wb_node;
+	if (!node)
+		return NULL;
+
+	while (node->wb_left)
+		node = node->wb_left;
+
+	return node;
+}
+EXPORT_SYMBOL(wb_first);
+
+struct wb_node *wb_last(struct wb_root *root)
+{
+	struct wb_node *node;
+
+	node = root->wb_node;
+	if (!node)
+		return NULL;
+
+	while (node->wb_right)
+		node = node->wb_right;
+
+	return node;
+}
+EXPORT_SYMBOL(wb_last);
+
+struct wb_node *wb_next(struct wb_node *node)
+{
+	struct wb_node *parent;
+
+	if (node->wb_parent == node)
+		return NULL;
+
+	if (node->wb_right) {
+		node = node->wb_right;
+		while (node->wb_left)
+			node = node->wb_left;
+		return node;
+	}
+
+	while ((parent = node->wb_parent) && node == parent->wb_right)
+		node = parent;
+
+	return parent;
+}
+EXPORT_SYMBOL(wb_next);
+
+struct wb_node *wb_prev(struct wb_node *node)
+{
+	struct wb_node *parent;
+
+	if (node->wb_parent == node)
+		return NULL;
+
+	if (node->wb_left) {
+		node = node->wb_left;
+		while (node->wb_right)
+			node = node->wb_right;
+		return node;
+	}
+
+	while ((parent = node->wb_parent) && node == parent->wb_left)
+		node = parent;
+
+	return parent;
+}
+EXPORT_SYMBOL(wb_prev);

