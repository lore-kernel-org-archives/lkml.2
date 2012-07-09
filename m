Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2GIXfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:35:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38226 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab2GIXft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:35:49 -0400
From: Michel Lespinasse <walken@google.com>
To: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH 06/13] rbtree: break out of rb_insert_color loop after tree rotation
Date: Mon,  9 Jul 2012 16:35:16 -0700
Message-Id: <1341876923-12469-7-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1341876923-12469-1-git-send-email-walken@google.com>
References: <1341876923-12469-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a well known property of rbtrees that insertion never requires
more than two tree rotations.  In our implementation, after one loop
iteration identified one or two necessary tree rotations, we would iterate
and look for more.  However at that point the node's parent would always
be black, which would cause us to exit the loop.

We can make the code flow more obvious by just adding a break statement
after the tree rotations, where we know we are done.  Additionally, in the
cases where two tree rotations are necessary, we don't have to update the
'node' pointer as it wouldn't be used until the next loop iteration, which
we now avoid due to this break statement.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rbtree.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index d0ec339..19bee6c 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -109,18 +109,15 @@ void rb_insert_color(struct rb_node *node, struct rb_root *root)
 				}
 			}
 
-			if (parent->rb_right == node)
-			{
-				register struct rb_node *tmp;
+			if (parent->rb_right == node) {
 				__rb_rotate_left(parent, root);
-				tmp = parent;
 				parent = node;
-				node = tmp;
 			}
 
 			rb_set_black(parent);
 			rb_set_red(gparent);
 			__rb_rotate_right(gparent, root);
+			break;
 		} else {
 			{
 				register struct rb_node *uncle = gparent->rb_left;
@@ -134,18 +131,15 @@ void rb_insert_color(struct rb_node *node, struct rb_root *root)
 				}
 			}
 
-			if (parent->rb_left == node)
-			{
-				register struct rb_node *tmp;
+			if (parent->rb_left == node) {
 				__rb_rotate_right(parent, root);
-				tmp = parent;
 				parent = node;
-				node = tmp;
 			}
 
 			rb_set_black(parent);
 			rb_set_red(gparent);
 			__rb_rotate_left(gparent, root);
+			break;
 		}
 	}
 
-- 
1.7.7.3

