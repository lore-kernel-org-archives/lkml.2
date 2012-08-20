Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab2HTWHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 18:07:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63641 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab2HTWFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 18:05:49 -0400
From: Michel Lespinasse <walken@google.com>
To: riel@redhat.com, peterz@infradead.org, daniel.santos@pobox.com,
        aarcange@redhat.com, dwmw2@infradead.org, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: [PATCH v3 3/9] rbtree: place easiest case first in rb_erase()
Date: Mon, 20 Aug 2012 15:05:25 -0700
Message-Id: <1345500331-10546-4-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1345500331-10546-1-git-send-email-walken@google.com>
References: <1345500331-10546-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rb_erase, move the easy case (node to erase has no more than
1 child) first. I feel the code reads easier that way.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>

---
 lib/rbtree.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index de89a614b1ba..bde1b5c5fb33 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -368,17 +368,28 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 
 void rb_erase(struct rb_node *node, struct rb_root *root)
 {
-	struct rb_node *child, *parent;
+	struct rb_node *child = node->rb_right, *tmp = node->rb_left;
+	struct rb_node *parent;
 	int color;
 
-	if (!node->rb_left)
-		child = node->rb_right;
-	else if (!node->rb_right)
-		child = node->rb_left;
-	else {
+	if (!tmp) {
+	case1:
+		/* Case 1: node to erase has no more than 1 child (easy!) */
+
+		parent = rb_parent(node);
+		color = rb_color(node);
+
+		if (child)
+			rb_set_parent(child, parent);
+		__rb_change_child(node, child, parent, root);
+	} else if (!child) {
+		/* Still case 1, but this time the child is node->rb_left */
+		child = tmp;
+		goto case1;
+	} else {
 		struct rb_node *old = node, *left;
 
-		node = node->rb_right;
+		node = child;
 		while ((left = node->rb_left) != NULL)
 			node = left;
 
@@ -402,18 +413,8 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 		node->__rb_parent_color = old->__rb_parent_color;
 		node->rb_left = old->rb_left;
 		rb_set_parent(old->rb_left, node);
-
-		goto color;
 	}
 
-	parent = rb_parent(node);
-	color = rb_color(node);
-
-	if (child)
-		rb_set_parent(child, parent);
-	__rb_change_child(node, child, parent, root);
-
-color:
 	if (color == RB_BLACK)
 		__rb_erase_color(child, parent, root);
 }
-- 
1.7.7.3
