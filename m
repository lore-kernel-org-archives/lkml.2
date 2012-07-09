Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2GIXgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:36:45 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49683 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab2GIXf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:35:59 -0400
From: Michel Lespinasse <walken@google.com>
To: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH 12/13] rbtree: optimize tree rotations in __rb_erase_color()
Date: Mon,  9 Jul 2012 16:35:22 -0700
Message-Id: <1341876923-12469-13-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1341876923-12469-1-git-send-email-walken@google.com>
References: <1341876923-12469-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __rb_erase_color(), we often already have pointers to the nodes
being rotated and/or know what their colors must be, so we can
generate more efficient code than the generic __rb_rotate_left()
and __rb_rotate_right() functions.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rbtree.c |  154 ++++++++++++++++++++++++---------------------------------
 1 files changed, 65 insertions(+), 89 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index 597c1b9..c956248 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -36,10 +36,6 @@ static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
 {
 	rb->rb_parent_color = (rb->rb_parent_color & 3) | (unsigned long)p;
 }
-static inline void rb_set_color(struct rb_node *rb, int color)
-{
-	rb->rb_parent_color = (rb->rb_parent_color & ~1) | color;
-}
 
 static inline void rb_set_parent_color(struct rb_node *rb,
 				       struct rb_node *p, int color)
@@ -52,52 +48,6 @@ static inline struct rb_node *rb_red_parent(struct rb_node *red)
 	return (struct rb_node *)red->rb_parent_color;
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
@@ -207,7 +157,7 @@ EXPORT_SYMBOL(rb_insert_color);
 static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 			     struct rb_root *root)
 {
-	struct rb_node *other;
+	struct rb_node *sibling, *tmp1, *tmp2;
 
 	while (true) {
 		/*
@@ -225,58 +175,84 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
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
+				/* Case 1 - left rotate at parent */
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
+					/* Case 2 - sibling color flip */
+					rb_set_red(sibling);
 					node = parent;
 					parent = rb_parent(node);
 					continue;
 				}
-				rb_set_black(other->rb_left);
-				rb_set_red(other);
-				__rb_rotate_right(other, root);
-				other = parent->rb_right;
+				/* Case 3 - right rotate at sibling */
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
+			/* Case 4 - left rotate at parent + color flips */
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
+					rb_set_red(sibling);
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

