Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab2GIXgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:36:03 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38226 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab2GIXf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:35:56 -0400
From: Michel Lespinasse <walken@google.com>
To: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH 10/13] rbtree: adjust node color in __rb_erase_color() only when necessary
Date: Mon,  9 Jul 2012 16:35:20 -0700
Message-Id: <1341876923-12469-11-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1341876923-12469-1-git-send-email-walken@google.com>
References: <1341876923-12469-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __rb_erase_color(), we were always setting a node to black after
exiting the main loop. And in one case, after fixing up the tree to
satisfy all rbtree invariants, we were setting the current node to root
just to guarantee a loop exit, at which point the root would be set to
black. However this is not necessary, as the root of an rbtree is already
known to be black. The only case where the color flip is required is when
we exit the loop due to the current node being red, and it's easiest to
just do the flip at that point instead of doing it after the loop.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rbtree.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index 56369d8..44cbbd5 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -209,10 +209,22 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 {
 	struct rb_node *other;
 
-	while ((!node || rb_is_black(node)) && node != root->rb_node)
-	{
-		if (parent->rb_left == node)
-		{
+	while (true) {
+		/*
+		 * Loop invariant: all leaf paths going through node have a
+		 * black node count that is 1 lower than other leaf paths.
+		 *
+		 * If node is red, we can flip it to black to adjust.
+		 * If node is the root, all leaf paths go through it.
+		 * Otherwise, we need to adjust the tree through color flips
+		 * and tree rotations as per one of the 4 cases below.
+		 */
+		if (node && rb_is_red(node)) {
+			rb_set_black(node);
+			break;
+		} else if (!parent) {
+			break;
+		} else if (parent->rb_left == node) {
 			other = parent->rb_right;
 			if (rb_is_red(other))
 			{
@@ -241,12 +253,9 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 				rb_set_black(parent);
 				rb_set_black(other->rb_right);
 				__rb_rotate_left(parent, root);
-				node = root->rb_node;
 				break;
 			}
-		}
-		else
-		{
+		} else {
 			other = parent->rb_left;
 			if (rb_is_red(other))
 			{
@@ -275,13 +284,10 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 				rb_set_black(parent);
 				rb_set_black(other->rb_left);
 				__rb_rotate_right(parent, root);
-				node = root->rb_node;
 				break;
 			}
 		}
 	}
-	if (node)
-		rb_set_black(node);
 }
 
 void rb_erase(struct rb_node *node, struct rb_root *root)
-- 
1.7.7.3

