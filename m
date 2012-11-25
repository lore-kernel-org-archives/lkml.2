Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab2KYCoh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 21:44:37 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35277 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab2KYCog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 21:44:36 -0500
From: Michel Lespinasse <walken@google.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Pekka Enberg <penberg@kernel.org>, Asias He <asias.hejun@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] kvm: ensure non-overlapping intervals in rb_int_insert()
Date: Sat, 24 Nov 2012 18:44:22 -0800
Message-Id: <1353811464-6462-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <CANN689EzEDuYFdcM3=ir=UZgOhiNeKNpc_ydP8vH00f0nM6PXw@mail.gmail.com>
References: <CANN689EzEDuYFdcM3=ir=UZgOhiNeKNpc_ydP8vH00f0nM6PXw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rbtree interval API is designed for handling non-overlapping intervals;
modify rb_int_insert() to guarantee this property is maintained by
returning -EEXIST when attempting to insert a new interval that overlaps
an existing interval.

Also fix an issue where the computation of 'result' could trigger an
integer overflow which would break the rbtree ordering.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 tools/kvm/util/rbtree-interval.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/kvm/util/rbtree-interval.c b/tools/kvm/util/rbtree-interval.c
index d7fa96a06a92..fd69252bea02 100644
--- a/tools/kvm/util/rbtree-interval.c
+++ b/tools/kvm/util/rbtree-interval.c
@@ -99,13 +99,13 @@ int rb_int_insert(struct rb_root *root, struct rb_int_node *i_node)
 	struct rb_node **node = &root->rb_node, *parent = NULL;
 
 	while (*node) {
-		int result = i_node->low - rb_int(*node)->low;
+		struct rb_int_node *cur = rb_int(*node);
 
 		parent = *node;
-		if (result < 0)
-			node	= &((*node)->rb_left);
-		else if (result > 0)
-			node	= &((*node)->rb_right);
+		if (i_node->high <= cur->low)
+			node = &cur->node.rb_left;
+		else if (cur->high <= i_node->low)
+			node = &cur->node.rb_right;
 		else
 			return -EEXIST;
 	}
-- 
1.7.7.3
