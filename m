Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab2GIXhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:37:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63850 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab2GIXfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:35:51 -0400
From: Michel Lespinasse <walken@google.com>
To: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH 07/13] rbtree: adjust root color in rb_insert_color() only when necessary
Date: Mon,  9 Jul 2012 16:35:17 -0700
Message-Id: <1341876923-12469-8-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1341876923-12469-1-git-send-email-walken@google.com>
References: <1341876923-12469-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The root node of an rbtree must always be black. However, rb_insert_color()
only needs to maintain this invariant when it has been broken - that is,
when it exits the loop due to the current (red) node being the root.
In all other cases (exiting after tree rotations, or exiting due to
an existing black parent) the invariant is already satisfied, so there
is no need to adjust the root node color.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rbtree.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index 19bee6c..0d9d184 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -91,8 +91,21 @@ void rb_insert_color(struct rb_node *node, struct rb_root *root)
 {
 	struct rb_node *parent, *gparent;
 
-	while ((parent = rb_parent(node)) && rb_is_red(parent))
-	{
+	while (true) {
+		/*
+		 * Loop invariant: node is red
+		 *
+		 * If there is a black parent, we are done.
+		 * Otherwise, take some corrective action as we don't
+		 * want a red root or two consecutive red nodes.
+		 */
+		parent = rb_parent(node);
+		if (!parent) {
+			rb_set_black(node);
+			break;
+		} else if (rb_is_black(parent))
+			break;
+
 		gparent = rb_parent(parent);
 
 		if (parent == gparent->rb_left)
@@ -142,8 +155,6 @@ void rb_insert_color(struct rb_node *node, struct rb_root *root)
 			break;
 		}
 	}
-
-	rb_set_black(root->rb_node);
 }
 EXPORT_SYMBOL(rb_insert_color);
 
-- 
1.7.7.3

