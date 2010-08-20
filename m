Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab0HTFWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 01:22:42 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:53782 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751016Ab0HTFWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 01:22:38 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, npiggin@kernel.dk
Subject: [PATCH 1/2] radix-tree: clear all tags in radix_tree_node_rcu_free
Date: Fri, 20 Aug 2010 15:22:06 +1000
Message-Id: <1282281727-15088-2-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282281727-15088-1-git-send-email-david@fromorbit.com>
References: <1282281727-15088-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Commit f446daaea9d4a420d16c606f755f3689dcb2d0ce ("mm: implement
writeback livelock avoidance using page tagging") introduced a new
radix tree tag, increasing the number of tags in each node from 2 to
3. It did not, however, fix up the code in
radix_tree_node_rcu_free() that cleans up after radix_tree_shrink()
and hence could leave stray tags set in the new tag array.

The result is that the livelock avoidance code added in the the
above commit would hit stale tags when doing tag based lookups,
resulting in livelocks when trying to traverse the tree.

Fix this problem in radix_tree_node_rcu_free() so it doesn't happen
again in the future by using a loop to walk all the tags up to
RADIX_TREE_MAX_TAGS to clear the stray tags radix_tree_shrink()
leaves behind.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 lib/radix-tree.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index e907858..1014171 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -174,14 +174,16 @@ static void radix_tree_node_rcu_free(struct rcu_head *head)
 {
 	struct radix_tree_node *node =
 			container_of(head, struct radix_tree_node, rcu_head);
+	int i;
 
 	/*
 	 * must only free zeroed nodes into the slab. radix_tree_shrink
 	 * can leave us with a non-NULL entry in the first slot, so clear
 	 * that here to make sure.
 	 */
-	tag_clear(node, 0, 0);
-	tag_clear(node, 1, 0);
+	for (i = 0; i < RADIX_TREE_MAX_TAGS; i++)
+		tag_clear(node, i, 0);
+
 	node->slots[0] = NULL;
 	node->count = 0;
 
-- 
1.7.1

