Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2GTMbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 08:31:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55638 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab2GTMba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 08:31:30 -0400
From: Michel Lespinasse <walken@google.com>
To: riel@redhat.com, peterz@infradead.org, daniel.santos@pobox.com,
        aarcange@redhat.com, dwmw2@infradead.org, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] rbtree: rb_erase updates and comments
Date: Fri, 20 Jul 2012 05:31:02 -0700
Message-Id: <1342787467-5493-2-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1342787467-5493-1-git-send-email-walken@google.com>
References: <1342787467-5493-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor updates to the rb_erase() function:
- Reorder code to put simplest / common case (no more than 1 child) first.
- Fetch the parent first, since it ends up being required in all 3 cases.
- Add a few comments to illustrate case 2 (node to remove has 2 childs,
  but one of them is the successor) and case 3 (node to remove has 2 childs,
  successor is a left-descendant of the right child).

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rbtree.c |  115 ++++++++++++++++++++++++++++++++++++----------------------
 1 files changed, 72 insertions(+), 43 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index 0892670..3b6ec98 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -2,7 +2,8 @@
   Red Black Trees
   (C) 1999  Andrea Arcangeli <andrea@suse.de>
   (C) 2002  David Woodhouse <dwmw2@infradead.org>
-  
+  (C) 2012  Michel Lespinasse <walken@google.com>
+
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
@@ -356,65 +357,93 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 
 void rb_erase(struct rb_node *node, struct rb_root *root)
 {
-	struct rb_node *child, *parent;
-	int color;
+	struct rb_node *parent = rb_parent(node);
+	struct rb_node *child = node->rb_right;
+	struct rb_node *tmp = node->rb_left;
+	bool black;
+
+	if (!tmp) {
+		/* Case 1: node to erase has no more than 1 child (easy!) */
+		if (child)
+one_child:
+			rb_set_parent(child, parent);
+		if (parent) {
+			if (parent->rb_left == node)
+				parent->rb_left = child;
+			else
+				parent->rb_right = child;
+		} else
+			root->rb_node = child;
 
-	if (!node->rb_left)
-		child = node->rb_right;
-	else if (!node->rb_right)
-		child = node->rb_left;
-	else {
-		struct rb_node *old = node, *left;
+		black = rb_is_black(node);
+	} else if (!child) {
+		/* Still case 1, but this time the child is node->rb_left */
+		child = tmp;
+		goto one_child;
+	} else {
+		struct rb_node *old = node;
 
+		/*
+		 * Old is the node we want to erase. It's got left and right
+		 * children, which makes things difficult. Let's find the
+		 * next node in the tree to have it fill old's position.
+		 */
 		node = node->rb_right;
-		while ((left = node->rb_left) != NULL)
-			node = left;
+		while ((tmp = node->rb_left) != NULL)
+			node = tmp;
 
-		if (rb_parent(old)) {
-			if (rb_parent(old)->rb_left == old)
-				rb_parent(old)->rb_left = node;
+		/* Graft node (old's successor) under old's parent. */
+		if (parent) {
+			if (parent->rb_left == old)
+				parent->rb_left = node;
 			else
-				rb_parent(old)->rb_right = node;
+				parent->rb_right = node;
 		} else
 			root->rb_node = node;
 
-		child = node->rb_right;
 		parent = rb_parent(node);
-		color = rb_color(node);
+		black = rb_is_black(node);
+		node->__rb_parent_color = old->__rb_parent_color;
+
+		/*
+		 * Node doesn't have a left child, since it is old's successor,
+		 * so we can take old's left child and graft it under node.
+		 */
+		node->rb_left = tmp = old->rb_left;
+		rb_set_parent(tmp, node);
 
+		child = node->rb_right;
 		if (parent == old) {
+			/*
+			 * Case 2: old is node's parent (we are done!)
+			 *
+			 *    (o)          (n)
+			 *    / \          / \
+			 *  (x) (n)  ->  (x) (c)
+			 *        \
+			 *        (c)
+			 */
 			parent = node;
 		} else {
+			/*
+			 * Case 3: old is node's ancestor but not its parent
+			 *
+			 *    (o)          (n)
+			 *    / \          / \
+			 *  (x) (y)  ->  (x) (y)
+			 *      /            /
+			 *    (n)          (c)
+			 *      \
+			 *      (c)
+			 */
+			node->rb_right = tmp = old->rb_right;
+			parent->rb_left = child;
+			rb_set_parent(tmp, node);
 			if (child)
 				rb_set_parent(child, parent);
-			parent->rb_left = child;
-
-			node->rb_right = old->rb_right;
-			rb_set_parent(old->rb_right, node);
 		}
-
-		node->__rb_parent_color = old->__rb_parent_color;
-		node->rb_left = old->rb_left;
-		rb_set_parent(old->rb_left, node);
-
-		goto color;
 	}
-
-	parent = rb_parent(node);
-	color = rb_color(node);
-
-	if (child)
-		rb_set_parent(child, parent);
-	if (parent) {
-		if (parent->rb_left == node)
-			parent->rb_left = child;
-		else
-			parent->rb_right = child;
-	} else
-		root->rb_node = child;
-
-color:
-	if (color == RB_BLACK)
+	if (black)
 		__rb_erase_color(child, parent, root);
 }
 EXPORT_SYMBOL(rb_erase);
-- 
1.7.7.3

