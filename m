Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2HBWfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 18:35:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62801 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab2HBWeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 18:34:36 -0400
From: Michel Lespinasse <walken@google.com>
To: riel@redhat.com, peterz@infradead.org, daniel.santos@pobox.com,
        aarcange@redhat.com, dwmw2@infradead.org, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: [PATCH v2 3/9] rbtree: add __rb_change_child() helper function
Date: Thu,  2 Aug 2012 15:34:12 -0700
Message-Id: <1343946858-8170-4-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343946858-8170-1-git-send-email-walken@google.com>
References: <1343946858-8170-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __rb_change_child() as an inline helper function to replace code that
would otherwise be duplicated 4 times in the source.

No changes to binary size or speed.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rbtree.c |   46 +++++++++++++++++-----------------------------
 1 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index 61cdd0e..de89a61 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -66,6 +66,19 @@ static inline struct rb_node *rb_red_parent(struct rb_node *red)
 	return (struct rb_node *)red->__rb_parent_color;
 }
 
+static inline void
+__rb_change_child(struct rb_node *old, struct rb_node *new,
+		  struct rb_node *parent, struct rb_root *root)
+{
+	if (parent) {
+		if (parent->rb_left == old)
+			parent->rb_left = new;
+		else
+			parent->rb_right = new;
+	} else
+		root->rb_node = new;
+}
+
 /*
  * Helper function for rotations:
  * - old's parent and color get assigned to new
@@ -78,13 +91,7 @@ __rb_rotate_set_parents(struct rb_node *old, struct rb_node *new,
 	struct rb_node *parent = rb_parent(old);
 	new->__rb_parent_color = old->__rb_parent_color;
 	rb_set_parent_color(old, new, color);
-	if (parent) {
-		if (parent->rb_left == old)
-			parent->rb_left = new;
-		else
-			parent->rb_right = new;
-	} else
-		root->rb_node = new;
+	__rb_change_child(old, new, parent, root);
 }
 
 void rb_insert_color(struct rb_node *node, struct rb_root *root)
@@ -375,13 +382,7 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 		while ((left = node->rb_left) != NULL)
 			node = left;
 
-		if (rb_parent(old)) {
-			if (rb_parent(old)->rb_left == old)
-				rb_parent(old)->rb_left = node;
-			else
-				rb_parent(old)->rb_right = node;
-		} else
-			root->rb_node = node;
+		__rb_change_child(old, node, rb_parent(old), root);
 
 		child = node->rb_right;
 		parent = rb_parent(node);
@@ -410,13 +411,7 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 
 	if (child)
 		rb_set_parent(child, parent);
-	if (parent) {
-		if (parent->rb_left == node)
-			parent->rb_left = child;
-		else
-			parent->rb_right = child;
-	} else
-		root->rb_node = child;
+	__rb_change_child(node, child, parent, root);
 
 color:
 	if (color == RB_BLACK)
@@ -591,14 +586,7 @@ void rb_replace_node(struct rb_node *victim, struct rb_node *new,
 	struct rb_node *parent = rb_parent(victim);
 
 	/* Set the surrounding nodes to point to the replacement */
-	if (parent) {
-		if (victim == parent->rb_left)
-			parent->rb_left = new;
-		else
-			parent->rb_right = new;
-	} else {
-		root->rb_node = new;
-	}
+	__rb_change_child(victim, new, parent, root);
 	if (victim->rb_left)
 		rb_set_parent(victim->rb_left, new);
 	if (victim->rb_right)
-- 
1.7.7.3

