Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab2GKNYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:24:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52946 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297Ab2GKNX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:23:57 -0400
Message-ID: <1342012996.3462.154.camel@twins>
Subject: Re: [PATCH 00/13] rbtree updates
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        daniel.santos@pobox.com, axboe@kernel.dk, ebiederm@xmission.com,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Wed, 11 Jul 2012 15:23:16 +0200
In-Reply-To: <1341876923-12469-1-git-send-email-walken@google.com>
References: <1341876923-12469-1-git-send-email-walken@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Looks nice.. How about something like the below on top.. I couldn't
immediately find a sane reason for the grand-parent to always be red in
the insertion case.

---
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -23,6 +23,25 @@
 #include <linux/rbtree.h>
 #include <linux/export.h>
 
+/*
+ * red-black trees properties:  http://en.wikipedia.org/wiki/Rbtree
+ *
+ *  1) A node is either red or black
+ *  2) The root is black
+ *  3) All leaves (NULL) are black
+ *  4) Both children of every red node are black
+ *  5) Every simple path from a given node to any of its descendant leaves
+ *     contains the same number of black nodes.
+ *
+ *  4 and 5 give the O(log n) guarantee, since 4 implies you cannot have two
+ *  consecutive red nodes in a path and every red node is therefore followed by
+ *  a black. So if B is the number of black nodes on every simple path (as per
+ *  5), then the longest possible path due to 4 is 2B.
+ *
+ *  We shall indicate color with case, where black nodes are uppercase and red
+ *  nodes will be lowercase.
+ */
+
 #define	RB_RED		0
 #define	RB_BLACK	1
 
@@ -85,12 +104,27 @@ void rb_insert_color(struct rb_node *nod
 		} else if (rb_is_black(parent))
 			break;
 
+		/*
+		 * XXX
+		 */
 		gparent = rb_red_parent(parent);
 
 		if (parent == gparent->rb_left) {
 			tmp = gparent->rb_right;
 			if (tmp && rb_is_red(tmp)) {
-				/* Case 1 - color flips */
+				/* 
+				 * Case 1 - color flips
+				 *
+				 *       G            g
+				 *      / \          / \
+				 *     p   u  -->   P   U
+				 *    /            /
+				 *   n            N
+				 *
+				 * However, since g's parent might be red, and
+				 * 4) does not allow this, we need to recurse
+				 * at g.
+				 */
 				rb_set_parent_color(tmp, gparent, RB_BLACK);
 				rb_set_parent_color(parent, gparent, RB_BLACK);
 				node = gparent;
@@ -100,17 +134,35 @@ void rb_insert_color(struct rb_node *nod
 			}
 
 			if (parent->rb_right == node) {
-				/* Case 2 - left rotate at parent */
+				/* 
+				 * Case 2 - left rotate at parent
+				 *
+				 *      G             G
+				 *     / \           / \
+				 *    p   U  -->    n   U
+				 *     \           /
+				 *      n         p
+				 *
+				 * This still leaves us in violation of 4), the
+				 * continuation into Case 3 will fix that.
+				 */
 				parent->rb_right = tmp = node->rb_left;
 				node->rb_left = parent;
 				if (tmp)
-					rb_set_parent_color(tmp, parent,
-							    RB_BLACK);
+					rb_set_parent_color(tmp, parent, RB_BLACK);
 				rb_set_parent_color(parent, node, RB_RED);
 				parent = node;
 			}
 
-			/* Case 3 - right rotate at gparent */
+			/* 
+			 * Case 3 - right rotate at gparent
+			 *
+			 *        G           P
+			 *       / \         / \
+			 *      p   U  -->  n   g
+			 *     /                 \
+			 *    n                   U
+			 */
 			gparent->rb_left = tmp = parent->rb_right;
 			parent->rb_right = gparent;
 			if (tmp)
@@ -134,8 +186,7 @@ void rb_insert_color(struct rb_node *nod
 				parent->rb_left = tmp = node->rb_right;
 				node->rb_right = parent;
 				if (tmp)
-					rb_set_parent_color(tmp, parent,
-							    RB_BLACK);
+					rb_set_parent_color(tmp, parent, RB_BLACK);
 				rb_set_parent_color(parent, node, RB_RED);
 				parent = node;
 			}
@@ -175,43 +226,75 @@ static void __rb_erase_color(struct rb_n
 		} else if (parent->rb_left == node) {
 			sibling = parent->rb_right;
 			if (rb_is_red(sibling)) {
-				/* Case 1 - left rotate at parent */
+				/* 
+				 * Case 1 - left rotate at parent
+				 *
+				 *     P               S
+				 *    / \             / \
+				 *   N   s    -->    p   Sr
+				 *      / \         / \
+				 *     Sl  Sr      N   Sl
+				 */
 				parent->rb_right = tmp1 = sibling->rb_left;
 				sibling->rb_left = parent;
 				rb_set_parent_color(tmp1, parent, RB_BLACK);
-				__rb_rotate_set_parents(parent, sibling, root,
-							RB_RED);
+				__rb_rotate_set_parents(parent, sibling, root, RB_RED);
 				sibling = tmp1;
 			}
 			tmp1 = sibling->rb_right;
 			if (!tmp1 || rb_is_black(tmp1)) {
 				tmp2 = sibling->rb_left;
 				if (!tmp2 || rb_is_black(tmp2)) {
-					/* Case 2 - sibling color flip */
-					rb_set_parent_color(sibling, parent,
-							    RB_RED);
+					/* 
+					 * Case 2 - sibling color flip
+					 *
+					 *     P             P
+					 *    / \           / \
+					 *   N   S    -->  N   s
+					 *      / \           / \
+					 *     Sl  Sr        Sl  Sr
+					 *
+					 * This leaves us violating 5), recurse at p.
+					 */
+					rb_set_parent_color(sibling, parent, RB_RED);
 					node = parent;
 					parent = rb_parent(node);
 					continue;
 				}
-				/* Case 3 - right rotate at sibling */
+				/* 
+				 * Case 3 - right rotate at sibling 
+				 *
+				 *    P             P
+				 *   / \           / \
+				 *  N   S    -->  N   sl
+				 *     / \           / \
+				 *    sl  Sr        1   S
+				 *   / \               / \
+				 *  1   2             2   Sr
+				 */
 				sibling->rb_left = tmp1 = tmp2->rb_right;
 				tmp2->rb_right = sibling;
 				parent->rb_right = tmp2;
 				if (tmp1)
-					rb_set_parent_color(tmp1, sibling,
-							    RB_BLACK);
+					rb_set_parent_color(tmp1, sibling, RB_BLACK);
 				tmp1 = sibling;
 				sibling = tmp2;
 			}
-			/* Case 4 - left rotate at parent + color flips */
+			/* 
+			 * Case 4 - left rotate at parent + color flips 
+			 *
+			 *       P               S
+			 *      / \             / \
+			 *     N   S     -->   P   Sr
+			 *        / \         / \
+			 *       Sl  Sr      N   Sl
+			 */
 			parent->rb_right = tmp2 = sibling->rb_left;
 			sibling->rb_left = parent;
 			rb_set_parent_color(tmp1, sibling, RB_BLACK);
 			if (tmp2)
 				rb_set_parent(tmp2, parent);
-			__rb_rotate_set_parents(parent, sibling, root,
-						RB_BLACK);
+			__rb_rotate_set_parents(parent, sibling, root, RB_BLACK);
 			break;
 		} else {
 			sibling = parent->rb_left;
@@ -220,8 +303,7 @@ static void __rb_erase_color(struct rb_n
 				parent->rb_left = tmp1 = sibling->rb_right;
 				sibling->rb_right = parent;
 				rb_set_parent_color(tmp1, parent, RB_BLACK);
-				__rb_rotate_set_parents(parent, sibling, root,
-							RB_RED);
+				__rb_rotate_set_parents(parent, sibling, root, RB_RED);
 				sibling = tmp1;
 			}
 			tmp1 = sibling->rb_left;
@@ -229,8 +311,7 @@ static void __rb_erase_color(struct rb_n
 				tmp2 = sibling->rb_right;
 				if (!tmp2 || rb_is_black(tmp2)) {
 					/* Case 2 - sibling color flip */
-					rb_set_parent_color(sibling, parent,
-							    RB_RED);
+					rb_set_parent_color(sibling, parent, RB_RED);
 					node = parent;
 					parent = rb_parent(node);
 					continue;
@@ -240,8 +321,7 @@ static void __rb_erase_color(struct rb_n
 				tmp2->rb_left = sibling;
 				parent->rb_left = tmp2;
 				if (tmp1)
-					rb_set_parent_color(tmp1, sibling,
-							    RB_BLACK);
+					rb_set_parent_color(tmp1, sibling, RB_BLACK);
 				tmp1 = sibling;
 				sibling = tmp2;
 			}
@@ -251,8 +331,7 @@ static void __rb_erase_color(struct rb_n
 			rb_set_parent_color(tmp1, sibling, RB_BLACK);
 			if (tmp2)
 				rb_set_parent(tmp2, parent);
-			__rb_rotate_set_parents(parent, sibling, root,
-						RB_BLACK);
+			__rb_rotate_set_parents(parent, sibling, root, RB_BLACK);
 			break;
 		}
 	}
@@ -267,8 +346,7 @@ void rb_erase(struct rb_node *node, stru
 		child = node->rb_right;
 	else if (!node->rb_right)
 		child = node->rb_left;
-	else
-	{
+	else {
 		struct rb_node *old = node, *left;
 
 		node = node->rb_right;
@@ -310,17 +388,15 @@ void rb_erase(struct rb_node *node, stru
 
 	if (child)
 		rb_set_parent(child, parent);
-	if (parent)
-	{
+	if (parent) {
 		if (parent->rb_left == node)
 			parent->rb_left = child;
 		else
 			parent->rb_right = child;
-	}
-	else
+	} else
 		root->rb_node = child;
 
- color:
+color:
 	if (color == RB_BLACK)
 		__rb_erase_color(child, parent, root);
 }
@@ -433,8 +509,10 @@ struct rb_node *rb_next(const struct rb_
 	if (RB_EMPTY_NODE(node))
 		return NULL;
 
-	/* If we have a right-hand child, go down and then left as far
-	   as we can. */
+	/* 
+	 * If we have a right-hand child, go down and then left as far as we
+	 * can. 
+	 */
 	if (node->rb_right) {
 		node = node->rb_right; 
 		while (node->rb_left)
@@ -442,12 +520,13 @@ struct rb_node *rb_next(const struct rb_
 		return (struct rb_node *)node;
 	}
 
-	/* No right-hand children.  Everything down and left is
-	   smaller than us, so any 'next' node must be in the general
-	   direction of our parent. Go up the tree; any time the
-	   ancestor is a right-hand child of its parent, keep going
-	   up. First time it's a left-hand child of its parent, said
-	   parent is our 'next' node. */
+	/* 
+	 * No right-hand children. Everything down and left is smaller than
+	 * us, so any 'next' node must be in the general direction of our
+	 * parent. Go up the tree; any time the ancestor is a right-hand child
+	 * of its parent, keep going up. First time it's a left-hand child of
+	 * its parent, said parent is our 'next' node. 
+	 */ 
 	while ((parent = rb_parent(node)) && node == parent->rb_right)
 		node = parent;
 
@@ -462,8 +541,10 @@ struct rb_node *rb_prev(const struct rb_
 	if (RB_EMPTY_NODE(node))
 		return NULL;
 
-	/* If we have a left-hand child, go down and then right as far
-	   as we can. */
+	/* 
+	 * If we have a left-hand child, go down and then right as far as we
+	 * can. 
+	 */
 	if (node->rb_left) {
 		node = node->rb_left; 
 		while (node->rb_right)
@@ -471,8 +552,10 @@ struct rb_node *rb_prev(const struct rb_
 		return (struct rb_node *)node;
 	}
 
-	/* No left-hand children. Go up till we find an ancestor which
-	   is a right-hand child of its parent */
+	/*
+	 * No left-hand children. Go up till we find an ancestor which is a
+	 * right-hand child of its parent 
+	 */
 	while ((parent = rb_parent(node)) && node == parent->rb_left)
 		node = parent;
 

