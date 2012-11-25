Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab2KYCoy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 21:44:54 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35277 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab2KYCoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 21:44:39 -0500
From: Michel Lespinasse <walken@google.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Pekka Enberg <penberg@kernel.org>, Asias He <asias.hejun@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] kvm: remove max_high field in rb_int_node structure
Date: Sat, 24 Nov 2012 18:44:24 -0800
Message-Id: <1353811464-6462-3-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <CANN689EzEDuYFdcM3=ir=UZgOhiNeKNpc_ydP8vH00f0nM6PXw@mail.gmail.com>
References: <CANN689EzEDuYFdcM3=ir=UZgOhiNeKNpc_ydP8vH00f0nM6PXw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since nothing depends on the max_high field values anymore, we can just
remove the field and the code that was used to maintain it.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 tools/kvm/include/kvm/rbtree-interval.h |   13 ++++---
 tools/kvm/util/rbtree-interval.c        |   58 +------------------------------
 2 files changed, 8 insertions(+), 63 deletions(-)

diff --git a/tools/kvm/include/kvm/rbtree-interval.h b/tools/kvm/include/kvm/rbtree-interval.h
index fb2102ab33a6..730eb5e8551d 100644
--- a/tools/kvm/include/kvm/rbtree-interval.h
+++ b/tools/kvm/include/kvm/rbtree-interval.h
@@ -1,20 +1,17 @@
 #ifndef KVM__INTERVAL_RBTREE_H
 #define KVM__INTERVAL_RBTREE_H
 
-#include <linux/rbtree_augmented.h>
+#include <linux/rbtree.h>
 #include <linux/types.h>
 
 #define RB_INT_INIT(l, h) \
-	(struct rb_int_node){.low = l, .high = h, .max_high = h}
+	(struct rb_int_node){.low = l, .high = h}
 #define rb_int(n) rb_entry(n, struct rb_int_node, node)
 
 struct rb_int_node {
 	struct rb_node	node;
 	u64		low;
 	u64		high;
-
-	/* max_high will store the highest high of it's 2 children. */
-	u64		max_high;
 };
 
 /* Return the rb_int_node interval in which 'point' is located. */
@@ -24,6 +21,10 @@ struct rb_int_node *rb_int_search_single(struct rb_root *root, u64 point);
 struct rb_int_node *rb_int_search_range(struct rb_root *root, u64 low, u64 high);
 
 int rb_int_insert(struct rb_root *root, struct rb_int_node *data);
-void rb_int_erase(struct rb_root *root, struct rb_int_node *node);
+
+static inline void rb_int_erase(struct rb_root *root, struct rb_int_node *node)
+{
+	rb_erase(&node->node, root);
+}
 
 #endif
diff --git a/tools/kvm/util/rbtree-interval.c b/tools/kvm/util/rbtree-interval.c
index 740ff0d87536..3630a6d80d6e 100644
--- a/tools/kvm/util/rbtree-interval.c
+++ b/tools/kvm/util/rbtree-interval.c
@@ -35,57 +35,6 @@ struct rb_int_node *rb_int_search_range(struct rb_root *root, u64 low, u64 high)
 	return range;
 }
 
-/*
- * Update a node after it has been linked into the tree:
- */
-static void propagate_callback(struct rb_node *node, struct rb_node *stop)
-{
-	struct rb_int_node *i_node;
-
-	if (node == stop)
-		return;
-
-	i_node = rb_int(node);
-	i_node->max_high = i_node->high;
-
-	if (node->rb_left)
-		i_node->max_high = max(i_node->max_high, rb_int(node->rb_left)->max_high);
-	if (node->rb_right)
-		i_node->max_high = max(i_node->max_high, rb_int(node->rb_right)->max_high);
-}
-
-/*
- * Copy the extra data to a new node:
- */
-static void copy_callback(struct rb_node *node_old, struct rb_node *node_new)
-{
-	struct rb_int_node *i_node_old = rb_int(node_old);
-	struct rb_int_node *i_node_new = rb_int(node_new);
-
-	i_node_new->low		= i_node_old->low;
-	i_node_new->high	= i_node_old->high;
-
-	i_node_new->max_high	= i_node_old->max_high;
-}
-
-/*
- * Update after tree rotation:
- */
-static void rotate_callback(struct rb_node *node_old, struct rb_node *node_new)
-{
-	propagate_callback(node_old, NULL);
-	propagate_callback(node_new, NULL);
-}
-
-/*
- * All augmented rbtree callbacks:
- */
-struct rb_augment_callbacks callbacks = {
-	.propagate	= propagate_callback,
-	.copy		= copy_callback,
-	.rotate		= rotate_callback,
-};
-
 int rb_int_insert(struct rb_root *root, struct rb_int_node *i_node)
 {
 	struct rb_node **node = &root->rb_node, *parent = NULL;
@@ -103,12 +52,7 @@ int rb_int_insert(struct rb_root *root, struct rb_int_node *i_node)
 	}
 
 	rb_link_node(&i_node->node, parent, node);
-	rb_insert_augmented(&i_node->node, root, &callbacks);
+	rb_insert_color(&i_node->node, root);
 
 	return 0;
 }
-
-void rb_int_erase(struct rb_root *root, struct rb_int_node *node)
-{
-	rb_erase_augmented(&node->node, root, &callbacks);
-}
-- 
1.7.7.3
