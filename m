Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab2GIXf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:35:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63850 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab2GIXfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:35:53 -0400
From: Michel Lespinasse <walken@google.com>
To: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH 08/13] rbtree: optimize tree rotations in rb_insert_color()
Date: Mon,  9 Jul 2012 16:35:18 -0700
Message-Id: <1341876923-12469-9-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1341876923-12469-1-git-send-email-walken@google.com>
References: <1341876923-12469-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rb_insert_color(), we can do better than calling __rb_rotate_left()
and __rb_rotate_right() to handle tree rotations: we already have
pointers to all relevant nodes, and know their colors (either because
we want to adjust it, or because we've tested it, or we can deduce it
as black due to the node proximity to a known red node). So we can
generate more efficient code by making use of the node pointers
we already have, and setting both the parent and color attributes for
nodes all at once. Also in case 2, some node attributes don't have to
be set because we know another tree rotation (case 3) will always follow
and override them.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rbtree.c |  102 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 71 insertions(+), 31 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index 0d9d184..f668886 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -41,6 +41,12 @@ static inline void rb_set_color(struct rb_node *rb, int color)
 	rb->rb_parent_color = (rb->rb_parent_color & ~1) | color;
 }
 
+static inline void rb_set_parent_color(struct rb_node *rb,
+				       struct rb_node *p, int color)
+{
+	rb->rb_parent_color = (unsigned long)p | color;
+}
+
 static void __rb_rotate_left(struct rb_node *node, struct rb_root *root)
 {
 	struct rb_node *right = node->rb_right;
@@ -87,9 +93,30 @@ static void __rb_rotate_right(struct rb_node *node, struct rb_root *root)
 	rb_set_parent(node, left);
 }
 
+/*
+ * Helper function for rotations:
+ * - old's parent and color get assigned to new
+ * - old gets assigned new as a parent and 'color' as a color.
+ */
+static inline void
+__rb_rotate_set_parents(struct rb_node *old, struct rb_node *new,
+			struct rb_root *root, int color)
+{
+	struct rb_node *parent = rb_parent(old);
+	new->rb_parent_color = old->rb_parent_color;
+	rb_set_parent_color(old, new, color);
+	if (parent) {
+		if (parent->rb_left == old)
+			parent->rb_left = new;
+		else
+			parent->rb_right = new;
+	} else
+		root->rb_node = new;
+}
+
 void rb_insert_color(struct rb_node *node, struct rb_root *root)
 {
-	struct rb_node *parent, *gparent;
+	struct rb_node *parent, *gparent, *tmp;
 
 	while (true) {
 		/*
@@ -108,50 +135,63 @@ void rb_insert_color(struct rb_node *node, struct rb_root *root)
 
 		gparent = rb_parent(parent);
 
-		if (parent == gparent->rb_left)
-		{
-			{
-				register struct rb_node *uncle = gparent->rb_right;
-				if (uncle && rb_is_red(uncle))
-				{
-					rb_set_black(uncle);
-					rb_set_black(parent);
-					rb_set_red(gparent);
-					node = gparent;
-					continue;
-				}
+		if (parent == gparent->rb_left) {
+			tmp = gparent->rb_right;
+			if (tmp && rb_is_red(tmp)) {
+				/* Case 1 - color flips */
+				rb_set_black(tmp);
+				rb_set_black(parent);
+				rb_set_red(gparent);
+				node = gparent;
+				continue;
 			}
 
 			if (parent->rb_right == node) {
-				__rb_rotate_left(parent, root);
+				/* Case 2 - left rotate at parent */
+				parent->rb_right = tmp = node->rb_left;
+				node->rb_left = parent;
+				if (tmp)
+					rb_set_parent_color(tmp, parent,
+							    RB_BLACK);
+				rb_set_parent_color(parent, node, RB_RED);
 				parent = node;
 			}
 
-			rb_set_black(parent);
-			rb_set_red(gparent);
-			__rb_rotate_right(gparent, root);
+			/* Case 3 - right rotate at gparent */
+			gparent->rb_left = tmp = parent->rb_right;
+			parent->rb_right = gparent;
+			if (tmp)
+				rb_set_parent_color(tmp, gparent, RB_BLACK);
+			__rb_rotate_set_parents(gparent, parent, root, RB_RED);
 			break;
 		} else {
-			{
-				register struct rb_node *uncle = gparent->rb_left;
-				if (uncle && rb_is_red(uncle))
-				{
-					rb_set_black(uncle);
-					rb_set_black(parent);
-					rb_set_red(gparent);
-					node = gparent;
-					continue;
-				}
+			tmp = gparent->rb_left;
+			if (tmp && rb_is_red(tmp)) {
+				/* Case 1 - color flips */
+				rb_set_black(tmp);
+				rb_set_black(parent);
+				rb_set_red(gparent);
+				node = gparent;
+				continue;
 			}
 
 			if (parent->rb_left == node) {
-				__rb_rotate_right(parent, root);
+				/* Case 2 - right rotate at parent */
+				parent->rb_left = tmp = node->rb_right;
+				node->rb_right = parent;
+				if (tmp)
+					rb_set_parent_color(tmp, parent,
+							    RB_BLACK);
+				rb_set_parent_color(parent, node, RB_RED);
 				parent = node;
 			}
 
-			rb_set_black(parent);
-			rb_set_red(gparent);
-			__rb_rotate_left(gparent, root);
+			/* Case 3 - left rotate at gparent */
+			gparent->rb_right = tmp = parent->rb_left;
+			parent->rb_left = gparent;
+			if (tmp)
+				rb_set_parent_color(tmp, gparent, RB_BLACK);
+			__rb_rotate_set_parents(gparent, parent, root, RB_RED);
 			break;
 		}
 	}
-- 
1.7.7.3

