Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab2GRLbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:31:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64129 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab2GRLbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:31:39 -0400
Date: Wed, 18 Jul 2012 04:31:35 -0700
From: Michel Lespinasse <walken@google.com>
To: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: [PATCH] rbtree: fix jffs2 build issue due to renamed
 __rb_parent_color field
Message-ID: <20120718113135.GB32698@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When renaming rb_parent_color into __rb_parent_color to highlight the
fact that people aren't expected to directly manipulate this, I broke
the jffs2 build which was doing such direct manipulation in
fs/jffs2/readinode.c . Fix this and add a comment explaining why
this direct use is safe here.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 fs/jffs2/readinode.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/jffs2/readinode.c b/fs/jffs2/readinode.c
index dc0437e..b00fc50 100644
--- a/fs/jffs2/readinode.c
+++ b/fs/jffs2/readinode.c
@@ -395,7 +395,9 @@ static int jffs2_add_tn_to_tree(struct jffs2_sb_info *c,
 
 /* Trivial function to remove the last node in the tree. Which by definition
    has no right-hand -- so can be removed just by making its only child (if
-   any) take its place under its parent. */
+   any) take its place under its parent. Note that we don't maintain the
+   usual rbtree invariants as there won't be further insert or erase
+   operations on the tree.*/
 static void eat_last(struct rb_root *root, struct rb_node *node)
 {
 	struct rb_node *parent = rb_parent(node);
@@ -414,7 +416,7 @@ static void eat_last(struct rb_root *root, struct rb_node *node)
 	*link = node->rb_left;
 	/* Colour doesn't matter now. Only the parent pointer. */
 	if (node->rb_left)
-		node->rb_left->rb_parent_color = node->rb_parent_color;
+		node->rb_left->__rb_parent_color = node->__rb_parent_color;
 }
 
 /* We put this in reverse order, so we can just use eat_last */
-- 
1.7.7.3
