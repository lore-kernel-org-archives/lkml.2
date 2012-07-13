Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162160Ab2GMAeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 20:34:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab2GMAdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 20:33:01 -0400
From: Michel Lespinasse <walken@google.com>
To: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: [PATCH v2 09/12] rbtree: adjust node color in __rb_erase_color() only when necessary
Date: Thu, 12 Jul 2012 17:31:54 -0700
Message-Id: <1342139517-3451-10-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1342139517-3451-1-git-send-email-walken@google.com>
References: <1342139517-3451-1-git-send-email-walken@google.com>
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
index 41cf19b..baf7c83 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -259,10 +259,22 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
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
@@ -291,12 +303,9 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
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
@@ -325,13 +334,10 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
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

