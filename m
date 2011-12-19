Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1LSGnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 01:43:51 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40676 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab1LSGnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 01:43:50 -0500
Date: Sun, 18 Dec 2011 22:43:46 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <rdunlap@xenotime.net>, Naveen Yadav <yad.naveen@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/5] rtth: copy latest radix_tree source
In-Reply-To: <alpine.LSU.2.00.1112162347440.1981@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1112182242150.1503@eggly.anvils>
References: <alpine.LSU.2.00.1112162347440.1981@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update rtth's radix-tree.c and test.h from the kernel version using parent
pointer in struct radix_tree_node instead of radix_tree_path array on stack.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 radix-tree.c |  148 +++++++++++++++++++++++--------------------------
 test.h       |    5 +
 2 files changed, 74 insertions(+), 79 deletions(-)

--- rtth5/radix-tree.c	2011-12-16 18:44:04.551896997 -0800
+++ rtth6/radix-tree.c	2011-12-16 18:44:07.659897014 -0800
@@ -48,16 +48,14 @@
 struct radix_tree_node {
 	unsigned int	height;		/* Height from the bottom */
 	unsigned int	count;
-	struct rcu_head	rcu_head;
+	union {
+		struct radix_tree_node *parent;	/* Used when ascending tree */
+		struct rcu_head	rcu_head;	/* Used when freeing node */
+	};
 	void __rcu	*slots[RADIX_TREE_MAP_SIZE];
 	unsigned long	tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
 };
 
-struct radix_tree_path {
-	struct radix_tree_node *node;
-	int offset;
-};
-
 #define RADIX_TREE_INDEX_BITS  (8 /* CHAR_BIT */ * sizeof(unsigned long))
 #define RADIX_TREE_MAX_PATH (DIV_ROUND_UP(RADIX_TREE_INDEX_BITS, \
 					  RADIX_TREE_MAP_SHIFT))
@@ -256,6 +254,7 @@ unsigned long radix_tree_maxindex(unsign
 static int radix_tree_extend(struct radix_tree_root *root, unsigned long index)
 {
 	struct radix_tree_node *node;
+	struct radix_tree_node *slot;
 	unsigned int height;
 	int tag;
 
@@ -274,18 +273,23 @@ static int radix_tree_extend(struct radi
 		if (!(node = radix_tree_node_alloc(root)))
 			return -ENOMEM;
 
-		/* Increase the height.  */
-		node->slots[0] = indirect_to_ptr(root->rnode);
-
 		/* Propagate the aggregated tag info into the new root */
 		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
 			if (root_tag_get(root, tag))
 				tag_set(node, tag, 0);
 		}
 
+		/* Increase the height.  */
 		newheight = root->height+1;
 		node->height = newheight;
 		node->count = 1;
+		node->parent = NULL;
+		slot = root->rnode;
+		if (newheight > 1) {
+			slot = indirect_to_ptr(slot);
+			slot->parent = node;
+		}
+		node->slots[0] = slot;
 		node = ptr_to_indirect(node);
 		rcu_assign_pointer(root->rnode, node);
 		root->height = newheight;
@@ -331,6 +335,7 @@ int radix_tree_insert(struct radix_tree_
 			if (!(slot = radix_tree_node_alloc(root)))
 				return -ENOMEM;
 			slot->height = height;
+			slot->parent = node;
 			if (node) {
 				rcu_assign_pointer(node->slots[offset], slot);
 				node->count++;
@@ -504,47 +509,41 @@ EXPORT_SYMBOL(radix_tree_tag_set);
 void *radix_tree_tag_clear(struct radix_tree_root *root,
 			unsigned long index, unsigned int tag)
 {
-	/*
-	 * The radix tree path needs to be one longer than the maximum path
-	 * since the "list" is null terminated.
-	 */
-	struct radix_tree_path path[RADIX_TREE_MAX_PATH + 1], *pathp = path;
+	struct radix_tree_node *node = NULL;
 	struct radix_tree_node *slot = NULL;
 	unsigned int height, shift;
+	int uninitialized_var(offset);
 
 	height = root->height;
 	if (index > radix_tree_maxindex(height))
 		goto out;
 
-	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
-	pathp->node = NULL;
+	shift = height * RADIX_TREE_MAP_SHIFT;
 	slot = indirect_to_ptr(root->rnode);
 
-	while (height > 0) {
-		int offset;
-
+	while (shift) {
 		if (slot == NULL)
 			goto out;
 
+		shift -= RADIX_TREE_MAP_SHIFT;
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		pathp[1].offset = offset;
-		pathp[1].node = slot;
+		node = slot;
 		slot = slot->slots[offset];
-		pathp++;
-		shift -= RADIX_TREE_MAP_SHIFT;
-		height--;
 	}
 
 	if (slot == NULL)
 		goto out;
 
-	while (pathp->node) {
-		if (!tag_get(pathp->node, tag, pathp->offset))
+	while (node) {
+		if (!tag_get(node, tag, offset))
 			goto out;
-		tag_clear(pathp->node, tag, pathp->offset);
-		if (any_tag_set(pathp->node, tag))
+		tag_clear(node, tag, offset);
+		if (any_tag_set(node, tag))
 			goto out;
-		pathp--;
+
+		index >>= RADIX_TREE_MAP_SHIFT;
+		offset = index & RADIX_TREE_MAP_MASK;
+		node = node->parent;
 	}
 
 	/* clear the root's tag bit */
@@ -646,8 +645,7 @@ unsigned long radix_tree_range_tag_if_ta
 		unsigned int iftag, unsigned int settag)
 {
 	unsigned int height = root->height;
-	struct radix_tree_path path[height];
-	struct radix_tree_path *pathp = path;
+	struct radix_tree_node *node = NULL;
 	struct radix_tree_node *slot;
 	unsigned int shift;
 	unsigned long tagged = 0;
@@ -671,14 +669,8 @@ unsigned long radix_tree_range_tag_if_ta
 	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
 	slot = indirect_to_ptr(root->rnode);
 
-	/*
-	 * we fill the path from (root->height - 2) to 0, leaving the index at
-	 * (root->height - 1) as a terminator. Zero the node in the terminator
-	 * so that we can use this to end walk loops back up the path.
-	 */
-	path[height - 1].node = NULL;
-
 	for (;;) {
+		unsigned long upindex;
 		int offset;
 
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
@@ -686,12 +678,10 @@ unsigned long radix_tree_range_tag_if_ta
 			goto next;
 		if (!tag_get(slot, iftag, offset))
 			goto next;
-		if (height > 1) {
+		if (shift) {
 			/* Go down one level */
-			height--;
 			shift -= RADIX_TREE_MAP_SHIFT;
-			path[height - 1].node = slot;
-			path[height - 1].offset = offset;
+			node = slot;
 			slot = slot->slots[offset];
 			continue;
 		}
@@ -701,15 +691,21 @@ unsigned long radix_tree_range_tag_if_ta
 		tag_set(slot, settag, offset);
 
 		/* walk back up the path tagging interior nodes */
-		pathp = &path[0];
-		while (pathp->node) {
+		upindex = index;
+		while (node) {
+			upindex >>= RADIX_TREE_MAP_SHIFT;
+			offset = upindex & RADIX_TREE_MAP_MASK;
+
 			/* stop if we find a node with the tag already set */
-			if (tag_get(pathp->node, settag, pathp->offset))
+			if (tag_get(node, settag, offset))
 				break;
-			tag_set(pathp->node, settag, pathp->offset);
-			pathp++;
+			tag_set(node, settag, offset);
+			node = node->parent;
 		}
 
+		/* optimization: no need to walk up from this node again */
+		node = NULL;
+
 next:
 		/* Go to next item at level determined by 'shift' */
 		index = ((index >> shift) + 1) << shift;
@@ -724,8 +720,7 @@ next:
 			 * last_index is guaranteed to be in the tree, what
 			 * we do below cannot wander astray.
 			 */
-			slot = path[height - 1].node;
-			height++;
+			slot = slot->parent;
 			shift += RADIX_TREE_MAP_SHIFT;
 		}
 	}
@@ -1299,7 +1294,7 @@ static inline void radix_tree_shrink(str
 	/* try to shrink tree height */
 	while (root->height > 0) {
 		struct radix_tree_node *to_free = root->rnode;
-		void *newptr;
+		struct radix_tree_node *slot;
 
 		BUG_ON(!radix_tree_is_indirect_ptr(to_free));
 		to_free = indirect_to_ptr(to_free);
@@ -1320,10 +1315,12 @@ static inline void radix_tree_shrink(str
 		 * (to_free->slots[0]), it will be safe to dereference the new
 		 * one (root->rnode) as far as dependent read barriers go.
 		 */
-		newptr = to_free->slots[0];
-		if (root->height > 1)
-			newptr = ptr_to_indirect(newptr);
-		root->rnode = newptr;
+		slot = to_free->slots[0];
+		if (root->height > 1) {
+			slot->parent = NULL;
+			slot = ptr_to_indirect(slot);
+		}
+		root->rnode = slot;
 		root->height--;
 
 		/*
@@ -1363,16 +1360,12 @@ static inline void radix_tree_shrink(str
  */
 void *radix_tree_delete(struct radix_tree_root *root, unsigned long index)
 {
-	/*
-	 * The radix tree path needs to be one longer than the maximum path
-	 * since the "list" is null terminated.
-	 */
-	struct radix_tree_path path[RADIX_TREE_MAX_PATH + 1], *pathp = path;
+	struct radix_tree_node *node = NULL;
 	struct radix_tree_node *slot = NULL;
 	struct radix_tree_node *to_free;
 	unsigned int height, shift;
 	int tag;
-	int offset;
+	int uninitialized_var(offset);
 
 	height = root->height;
 	if (index > radix_tree_maxindex(height))
@@ -1385,39 +1378,35 @@ void *radix_tree_delete(struct radix_tre
 		goto out;
 	}
 	slot = indirect_to_ptr(slot);
-
-	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
-	pathp->node = NULL;
+	shift = height * RADIX_TREE_MAP_SHIFT;
 
 	do {
 		if (slot == NULL)
 			goto out;
 
-		pathp++;
+		shift -= RADIX_TREE_MAP_SHIFT;
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		pathp->offset = offset;
-		pathp->node = slot;
+		node = slot;
 		slot = slot->slots[offset];
-		shift -= RADIX_TREE_MAP_SHIFT;
-		height--;
-	} while (height > 0);
+	} while (shift);
 
 	if (slot == NULL)
 		goto out;
 
 	/*
-	 * Clear all tags associated with the just-deleted item
+	 * Clear all tags associated with the item to be deleted.
+	 * This way of doing it would be inefficient, but seldom is any set.
 	 */
 	for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
-		if (tag_get(pathp->node, tag, pathp->offset))
+		if (tag_get(node, tag, offset))
 			radix_tree_tag_clear(root, index, tag);
 	}
 
 	to_free = NULL;
 	/* Now free the nodes we do not need anymore */
-	while (pathp->node) {
-		pathp->node->slots[pathp->offset] = NULL;
-		pathp->node->count--;
+	while (node) {
+		node->slots[offset] = NULL;
+		node->count--;
 		/*
 		 * Queue the node for deferred freeing after the
 		 * last reference to it disappears (set NULL, above).
@@ -1425,17 +1414,20 @@ void *radix_tree_delete(struct radix_tre
 		if (to_free)
 			radix_tree_node_free(to_free);
 
-		if (pathp->node->count) {
-			if (pathp->node == indirect_to_ptr(root->rnode))
+		if (node->count) {
+			if (node == indirect_to_ptr(root->rnode))
 				radix_tree_shrink(root);
 			goto out;
 		}
 
 		/* Node with zero slots in use so free it */
-		to_free = pathp->node;
-		pathp--;
+		to_free = node;
 
+		index >>= RADIX_TREE_MAP_SHIFT;
+		offset = index & RADIX_TREE_MAP_MASK;
+		node = node->parent;
 	}
+
 	root_tag_clear_all(root);
 	root->height = 0;
 	root->rnode = NULL;
--- rtth5/test.h	2011-12-16 18:44:04.551896997 -0800
+++ rtth6/test.h	2011-12-16 18:44:07.659897014 -0800
@@ -14,7 +14,10 @@
 struct radix_tree_node {
 	unsigned int	height;		/* Height from the bottom */
 	unsigned int	count;
-	struct rcu_head	rcu_head;
+	union {
+		struct radix_tree_node *parent;	/* Used when ascending tree */
+		struct rcu_head	rcu_head;	/* Used when freeing node */
+	};
 	void __rcu	*slots[RADIX_TREE_MAP_SIZE];
 	unsigned long	tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
 };
