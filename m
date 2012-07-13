Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350Ab2GMAdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 20:33:13 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42733 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933656Ab2GMAdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 20:33:06 -0400
From: Michel Lespinasse <walken@google.com>
To: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: [PATCH v2 10/12] rbtree: optimize case selection logic in __rb_erase_color()
Date: Thu, 12 Jul 2012 17:31:55 -0700
Message-Id: <1342139517-3451-11-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1342139517-3451-1-git-send-email-walken@google.com>
References: <1342139517-3451-1-git-send-email-walken@google.com>
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
index baf7c83..eb823a3 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -283,28 +283,24 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
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
@@ -314,28 +310,24 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
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

