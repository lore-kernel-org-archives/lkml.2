Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934279Ab2GMAdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 20:33:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642Ab2GMAdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 20:33:09 -0400
From: Michel Lespinasse <walken@google.com>
To: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: [PATCH v2 11/12] rbtree: low level optimizations in __rb_erase_color()
Date: Thu, 12 Jul 2012 17:31:56 -0700
Message-Id: <1342139517-3451-12-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1342139517-3451-1-git-send-email-walken@google.com>
References: <1342139517-3451-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __rb_erase_color(), we often already have pointers to the nodes
being rotated and/or know what their colors must be, so we can
generate more efficient code than the generic __rb_rotate_left()
and __rb_rotate_right() functions.

Also when the current node is red or when flipping the sibling's color,
the parent is already known so we can use the more efficient
rb_set_parent_color() function to set the desired color.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rbtree.c |  208 ++++++++++++++++++++++++++++++++--------------------------
 1 files changed, 115 insertions(+), 93 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index eb823a3..a38e473 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -39,7 +39,8 @@
  *  5), then the longest possible path due to 4 is 2B.
  *
  *  We shall indicate color with case, where black nodes are uppercase and red
- *  nodes will be lowercase.
+ *  nodes will be lowercase. Unknown color nodes shall be drawn as red within
+ *  parentheses and have some accompanying text comment.
  */
 
 #define	RB_RED		0
@@ -48,17 +49,11 @@
 #define rb_color(r)   ((r)->__rb_parent_color & 1)
 #define rb_is_red(r)   (!rb_color(r))
 #define rb_is_black(r) rb_color(r)
-#define rb_set_red(r)  do { (r)->__rb_parent_color &= ~1; } while (0)
-#define rb_set_black(r)  do { (r)->__rb_parent_color |= 1; } while (0)
 
 static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
 {
 	rb->__rb_parent_color = rb_color(rb) | (unsigned long)p;
 }
-static inline void rb_set_color(struct rb_node *rb, int color)
-{
-	rb->__rb_parent_color = (rb->__rb_parent_color & ~1) | color;
-}
 
 static inline void rb_set_parent_color(struct rb_node *rb,
 				       struct rb_node *p, int color)
@@ -71,52 +66,6 @@ static inline struct rb_node *rb_red_parent(struct rb_node *red)
 	return (struct rb_node *)red->__rb_parent_color;
 }
 
-static void __rb_rotate_left(struct rb_node *node, struct rb_root *root)
-{
-	struct rb_node *right = node->rb_right;
-	struct rb_node *parent = rb_parent(node);
-
-	if ((node->rb_right = right->rb_left))
-		rb_set_parent(right->rb_left, node);
-	right->rb_left = node;
-
-	rb_set_parent(right, parent);
-
-	if (parent)
-	{
-		if (node == parent->rb_left)
-			parent->rb_left = right;
-		else
-			parent->rb_right = right;
-	}
-	else
-		root->rb_node = right;
-	rb_set_parent(node, right);
-}
-
-static void __rb_rotate_right(struct rb_node *node, struct rb_root *root)
-{
-	struct rb_node *left = node->rb_left;
-	struct rb_node *parent = rb_parent(node);
-
-	if ((node->rb_left = left->rb_right))
-		rb_set_parent(left->rb_right, node);
-	left->rb_right = node;
-
-	rb_set_parent(left, parent);
-
-	if (parent)
-	{
-		if (node == parent->rb_right)
-			parent->rb_right = left;
-		else
-			parent->rb_left = left;
-	}
-	else
-		root->rb_node = left;
-	rb_set_parent(node, left);
-}
-
 /*
  * Helper function for rotations:
  * - old's parent and color get assigned to new
@@ -257,7 +206,7 @@ EXPORT_SYMBOL(rb_insert_color);
 static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 			     struct rb_root *root)
 {
-	struct rb_node *other;
+	struct rb_node *sibling, *tmp1, *tmp2;
 
 	while (true) {
 		/*
@@ -270,63 +219,136 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 		 * and tree rotations as per one of the 4 cases below.
 		 */
 		if (node && rb_is_red(node)) {
-			rb_set_black(node);
+			rb_set_parent_color(node, parent, RB_BLACK);
 			break;
 		} else if (!parent) {
 			break;
 		} else if (parent->rb_left == node) {
-			other = parent->rb_right;
-			if (rb_is_red(other))
-			{
-				rb_set_black(other);
-				rb_set_red(parent);
-				__rb_rotate_left(parent, root);
-				other = parent->rb_right;
+			sibling = parent->rb_right;
+			if (rb_is_red(sibling)) {
+				/*
+				 * Case 1 - left rotate at parent
+				 *
+				 *     P               S
+				 *    / \             / \
+				 *   N   s    -->    p   Sr
+				 *      / \         / \
+				 *     Sl  Sr      N   Sl
+				 */
+				parent->rb_right = tmp1 = sibling->rb_left;
+				sibling->rb_left = parent;
+				rb_set_parent_color(tmp1, parent, RB_BLACK);
+				__rb_rotate_set_parents(parent, sibling, root,
+							RB_RED);
+				sibling = tmp1;
 			}
-			if (!other->rb_right || rb_is_black(other->rb_right)) {
-				if (!other->rb_left ||
-				    rb_is_black(other->rb_left)) {
-					rb_set_red(other);
+			tmp1 = sibling->rb_right;
+			if (!tmp1 || rb_is_black(tmp1)) {
+				tmp2 = sibling->rb_left;
+				if (!tmp2 || rb_is_black(tmp2)) {
+					/*
+					 * Case 2 - sibling color flip
+					 * (p could be either color here)
+					 *
+					 *    (p)           (p)
+					 *    / \           / \
+					 *   N   S    -->  N   s
+					 *      / \           / \
+					 *     Sl  Sr        Sl  Sr
+					 *
+					 * This leaves us violating 5), so
+					 * recurse at p. If p is red, the
+					 * recursion will just flip it to black
+					 * and exit. If coming from Case 1,
+					 * p is known to be red.
+					 */
+					rb_set_parent_color(sibling, parent,
+							    RB_RED);
 					node = parent;
 					parent = rb_parent(node);
 					continue;
 				}
-				rb_set_black(other->rb_left);
-				rb_set_red(other);
-				__rb_rotate_right(other, root);
-				other = parent->rb_right;
+				/*
+				 * Case 3 - right rotate at sibling
+				 * (p could be either color here)
+				 *
+				 *   (p)           (p)
+				 *   / \           / \
+				 *  N   S    -->  N   Sl
+				 *     / \             \
+				 *    sl  Sr            s
+				 *                       \
+				 *                        Sr
+				 */
+				sibling->rb_left = tmp1 = tmp2->rb_right;
+				tmp2->rb_right = sibling;
+				parent->rb_right = tmp2;
+				if (tmp1)
+					rb_set_parent_color(tmp1, sibling,
+							    RB_BLACK);
+				tmp1 = sibling;
+				sibling = tmp2;
 			}
-			rb_set_color(other, rb_color(parent));
-			rb_set_black(parent);
-			rb_set_black(other->rb_right);
-			__rb_rotate_left(parent, root);
+			/*
+			 * Case 4 - left rotate at parent + color flips
+			 * (p and sl could be either color here.
+			 *  After rotation, p becomes black, s acquires
+			 *  p's color, and sl keeps its color)
+			 *
+			 *      (p)             (s)
+			 *      / \             / \
+			 *     N   S     -->   P   Sr
+			 *        / \         / \
+			 *      (sl) sr      N  (sl)
+			 */
+			parent->rb_right = tmp2 = sibling->rb_left;
+			sibling->rb_left = parent;
+			rb_set_parent_color(tmp1, sibling, RB_BLACK);
+			if (tmp2)
+				rb_set_parent(tmp2, parent);
+			__rb_rotate_set_parents(parent, sibling, root,
+						RB_BLACK);
 			break;
 		} else {
-			other = parent->rb_left;
-			if (rb_is_red(other))
-			{
-				rb_set_black(other);
-				rb_set_red(parent);
-				__rb_rotate_right(parent, root);
-				other = parent->rb_left;
+			sibling = parent->rb_left;
+			if (rb_is_red(sibling)) {
+				/* Case 1 - right rotate at parent */
+				parent->rb_left = tmp1 = sibling->rb_right;
+				sibling->rb_right = parent;
+				rb_set_parent_color(tmp1, parent, RB_BLACK);
+				__rb_rotate_set_parents(parent, sibling, root,
+							RB_RED);
+				sibling = tmp1;
 			}
-			if (!other->rb_left || rb_is_black(other->rb_left)) {
-				if (!other->rb_right ||
-				    rb_is_black(other->rb_right)) {
-					rb_set_red(other);
+			tmp1 = sibling->rb_left;
+			if (!tmp1 || rb_is_black(tmp1)) {
+				tmp2 = sibling->rb_right;
+				if (!tmp2 || rb_is_black(tmp2)) {
+					/* Case 2 - sibling color flip */
+					rb_set_parent_color(sibling, parent,
+							    RB_RED);
 					node = parent;
 					parent = rb_parent(node);
 					continue;
 				}
-				rb_set_black(other->rb_right);
-				rb_set_red(other);
-				__rb_rotate_left(other, root);
-				other = parent->rb_left;
+				/* Case 3 - right rotate at sibling */
+				sibling->rb_right = tmp1 = tmp2->rb_left;
+				tmp2->rb_left = sibling;
+				parent->rb_left = tmp2;
+				if (tmp1)
+					rb_set_parent_color(tmp1, sibling,
+							    RB_BLACK);
+				tmp1 = sibling;
+				sibling = tmp2;
 			}
-			rb_set_color(other, rb_color(parent));
-			rb_set_black(parent);
-			rb_set_black(other->rb_left);
-			__rb_rotate_right(parent, root);
+			/* Case 4 - left rotate at parent + color flips */
+			parent->rb_left = tmp2 = sibling->rb_right;
+			sibling->rb_right = parent;
+			rb_set_parent_color(tmp1, sibling, RB_BLACK);
+			if (tmp2)
+				rb_set_parent(tmp2, parent);
+			__rb_rotate_set_parents(parent, sibling, root,
+						RB_BLACK);
 			break;
 		}
 	}
-- 
1.7.7.3

