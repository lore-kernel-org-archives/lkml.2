Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab2GIXg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:36:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63850 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab2GIXf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:35:59 -0400
From: Michel Lespinasse <walken@google.com>
To: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH 13/13] rbtree: optimize color flips in __rb_erase_color()
Date: Mon,  9 Jul 2012 16:35:23 -0700
Message-Id: <1341876923-12469-14-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1341876923-12469-1-git-send-email-walken@google.com>
References: <1341876923-12469-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __rb_erase_color(), when the current node is red or when flipping
the sibling's color, the parent is already known so we can use the
more efficient rb_set_parent_color() function to set the desired color.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rbtree.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index c956248..f8c1a75 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -29,8 +29,6 @@
 #define rb_color(r)   ((r)->rb_parent_color & 1)
 #define rb_is_red(r)   (!rb_color(r))
 #define rb_is_black(r) rb_color(r)
-#define rb_set_red(r)  do { (r)->rb_parent_color &= ~1; } while (0)
-#define rb_set_black(r)  do { (r)->rb_parent_color |= 1; } while (0)
 
 static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
 {
@@ -170,7 +168,7 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 		 * and tree rotations as per one of the 4 cases below.
 		 */
 		if (node && rb_is_red(node)) {
-			rb_set_black(node);
+			rb_set_parent_color(node, parent, RB_BLACK);
 			break;
 		} else if (!parent) {
 			break;
@@ -190,7 +188,8 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 				tmp2 = sibling->rb_left;
 				if (!tmp2 || rb_is_black(tmp2)) {
 					/* Case 2 - sibling color flip */
-					rb_set_red(sibling);
+					rb_set_parent_color(sibling, parent,
+							    RB_RED);
 					node = parent;
 					parent = rb_parent(node);
 					continue;
@@ -230,7 +229,8 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 				tmp2 = sibling->rb_right;
 				if (!tmp2 || rb_is_black(tmp2)) {
 					/* Case 2 - sibling color flip */
-					rb_set_red(sibling);
+					rb_set_parent_color(sibling, parent,
+							    RB_RED);
 					node = parent;
 					parent = rb_parent(node);
 					continue;
-- 
1.7.7.3

