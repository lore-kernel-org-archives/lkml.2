Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2GIXgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:36:00 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42625 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab2GIXf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:35:57 -0400
From: Michel Lespinasse <walken@google.com>
To: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH 11/13] rbtree: optimize case selection logic in __rb_erase_color()
Date: Mon,  9 Jul 2012 16:35:21 -0700
Message-Id: <1341876923-12469-12-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1341876923-12469-1-git-send-email-walken@google.com>
References: <1341876923-12469-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __rb_erase_color(), we have to select one of 3 cases depending on the
color on the 'other' node children. If both children are black, we flip
a few node colors and iterate. Otherwise, we do either one or two
tree rotations, depending on the color of the 'other' child opposite
to 'node', and then we are done.

The corresponding logic had duplicate checks for the color of the 'other'
child opposite to 'node'. It was checking it first to determine if both
children are black, and then to determine how many tree rotations are
required. Rearrange the logic to avoid that extra check.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rbtree.c |   68 +++++++++++++++++++++++++--------------------------------
 1 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index 44cbbd5..597c1b9 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -233,28 +233,24 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 				__rb_rotate_left(parent, root);
 				other = parent->rb_right;
 			}
-			if ((!other->rb_left || rb_is_black(other->rb_left)) &&
-			    (!other->rb_right || rb_is_black(other->rb_right)))
-			{
-				rb_set_red(other);
-				node = parent;
-				parent = rb_parent(node);
-			}
-			else
-			{
-				if (!other->rb_right || rb_is_black(other->rb_right))
-				{
-					rb_set_black(other->rb_left);
+			if (!other->rb_right || rb_is_black(other->rb_right)) {
+				if (!other->rb_left ||
+				    rb_is_black(other->rb_left)) {
 					rb_set_red(other);
-					__rb_rotate_right(other, root);
-					other = parent->rb_right;
+					node = parent;
+					parent = rb_parent(node);
+					continue;
 				}
-				rb_set_color(other, rb_color(parent));
-				rb_set_black(parent);
-				rb_set_black(other->rb_right);
-				__rb_rotate_left(parent, root);
-				break;
+				rb_set_black(other->rb_left);
+				rb_set_red(other);
+				__rb_rotate_right(other, root);
+				other = parent->rb_right;
 			}
+			rb_set_color(other, rb_color(parent));
+			rb_set_black(parent);
+			rb_set_black(other->rb_right);
+			__rb_rotate_left(parent, root);
+			break;
 		} else {
 			other = parent->rb_left;
 			if (rb_is_red(other))
@@ -264,28 +260,24 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 				__rb_rotate_right(parent, root);
 				other = parent->rb_left;
 			}
-			if ((!other->rb_left || rb_is_black(other->rb_left)) &&
-			    (!other->rb_right || rb_is_black(other->rb_right)))
-			{
-				rb_set_red(other);
-				node = parent;
-				parent = rb_parent(node);
-			}
-			else
-			{
-				if (!other->rb_left || rb_is_black(other->rb_left))
-				{
-					rb_set_black(other->rb_right);
+			if (!other->rb_left || rb_is_black(other->rb_left)) {
+				if (!other->rb_right ||
+				    rb_is_black(other->rb_right)) {
 					rb_set_red(other);
-					__rb_rotate_left(other, root);
-					other = parent->rb_left;
+					node = parent;
+					parent = rb_parent(node);
+					continue;
 				}
-				rb_set_color(other, rb_color(parent));
-				rb_set_black(parent);
-				rb_set_black(other->rb_left);
-				__rb_rotate_right(parent, root);
-				break;
+				rb_set_black(other->rb_right);
+				rb_set_red(other);
+				__rb_rotate_left(other, root);
+				other = parent->rb_left;
 			}
+			rb_set_color(other, rb_color(parent));
+			rb_set_black(parent);
+			rb_set_black(other->rb_left);
+			__rb_rotate_right(parent, root);
+			break;
 		}
 	}
 }
-- 
1.7.7.3

