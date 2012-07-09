Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab2GIXhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:37:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40310 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab2GIXfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:35:54 -0400
From: Michel Lespinasse <walken@google.com>
To: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH 09/13] rbtree: optimize color flips and parent fetching in rb_insert_color()
Date: Mon,  9 Jul 2012 16:35:19 -0700
Message-Id: <1341876923-12469-10-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1341876923-12469-1-git-send-email-walken@google.com>
References: <1341876923-12469-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Use the newly introduced rb_set_parent_color() function to flip the color
  of nodes whose parent is already known.
- Optimize rb_parent() when the node is known to be red - there is no need
  to mask out the color in that case.
- Flipping gparent's color to red requires us to fetch its rb_parent_color
  field, so we can reuse it as the parent value for the next loop iteration.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rbtree.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index f668886..56369d8 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -47,6 +47,11 @@ static inline void rb_set_parent_color(struct rb_node *rb,
 	rb->rb_parent_color = (unsigned long)p | color;
 }
 
+static inline struct rb_node *rb_red_parent(struct rb_node *red)
+{
+	return (struct rb_node *)red->rb_parent_color;
+}
+
 static void __rb_rotate_left(struct rb_node *node, struct rb_root *root)
 {
 	struct rb_node *right = node->rb_right;
@@ -116,7 +121,7 @@ __rb_rotate_set_parents(struct rb_node *old, struct rb_node *new,
 
 void rb_insert_color(struct rb_node *node, struct rb_root *root)
 {
-	struct rb_node *parent, *gparent, *tmp;
+	struct rb_node *parent = rb_red_parent(node), *gparent, *tmp;
 
 	while (true) {
 		/*
@@ -126,23 +131,23 @@ void rb_insert_color(struct rb_node *node, struct rb_root *root)
 		 * Otherwise, take some corrective action as we don't
 		 * want a red root or two consecutive red nodes.
 		 */
-		parent = rb_parent(node);
 		if (!parent) {
-			rb_set_black(node);
+			rb_set_parent_color(node, NULL, RB_BLACK);
 			break;
 		} else if (rb_is_black(parent))
 			break;
 
-		gparent = rb_parent(parent);
+		gparent = rb_red_parent(parent);
 
 		if (parent == gparent->rb_left) {
 			tmp = gparent->rb_right;
 			if (tmp && rb_is_red(tmp)) {
 				/* Case 1 - color flips */
-				rb_set_black(tmp);
-				rb_set_black(parent);
-				rb_set_red(gparent);
+				rb_set_parent_color(tmp, gparent, RB_BLACK);
+				rb_set_parent_color(parent, gparent, RB_BLACK);
 				node = gparent;
+				parent = rb_parent(node);
+				rb_set_parent_color(node, parent, RB_RED);
 				continue;
 			}
 
@@ -168,10 +173,11 @@ void rb_insert_color(struct rb_node *node, struct rb_root *root)
 			tmp = gparent->rb_left;
 			if (tmp && rb_is_red(tmp)) {
 				/* Case 1 - color flips */
-				rb_set_black(tmp);
-				rb_set_black(parent);
-				rb_set_red(gparent);
+				rb_set_parent_color(tmp, gparent, RB_BLACK);
+				rb_set_parent_color(parent, gparent, RB_BLACK);
 				node = gparent;
+				parent = rb_parent(node);
+				rb_set_parent_color(node, parent, RB_RED);
 				continue;
 			}
 
-- 
1.7.7.3

