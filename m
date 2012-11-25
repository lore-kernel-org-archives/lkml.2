Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab2KYCol (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 21:44:41 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33891 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab2KYCoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 21:44:38 -0500
From: Michel Lespinasse <walken@google.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Pekka Enberg <penberg@kernel.org>, Asias He <asias.hejun@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] kvm: rb_int_search_single simplification
Date: Sat, 24 Nov 2012 18:44:23 -0800
Message-Id: <1353811464-6462-2-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <CANN689EzEDuYFdcM3=ir=UZgOhiNeKNpc_ydP8vH00f0nM6PXw@mail.gmail.com>
References: <CANN689EzEDuYFdcM3=ir=UZgOhiNeKNpc_ydP8vH00f0nM6PXw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the rbtree intervals are not overlapping, rb_int_search_single can
trivially be implemented without making use of the max_high field.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 tools/kvm/util/rbtree-interval.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/tools/kvm/util/rbtree-interval.c b/tools/kvm/util/rbtree-interval.c
index fd69252bea02..740ff0d87536 100644
--- a/tools/kvm/util/rbtree-interval.c
+++ b/tools/kvm/util/rbtree-interval.c
@@ -5,27 +5,19 @@
 struct rb_int_node *rb_int_search_single(struct rb_root *root, u64 point)
 {
 	struct rb_node *node = root->rb_node;
-	struct rb_node *lowest = NULL;
 
 	while (node) {
 		struct rb_int_node *cur = rb_int(node);
 
-		if (node->rb_left && (rb_int(node->rb_left)->max_high > point)) {
+		if (point < cur->low)
 			node = node->rb_left;
-		} else if (cur->low <= point && cur->high > point) {
-			lowest = node;
-			break;
-		} else if (point > cur->low) {
+		else if (cur->high <= point)
 			node = node->rb_right;
-		} else {
-			break;
-		}
+		else
+			return cur;
 	}
 
-	if (lowest == NULL)
-		return NULL;
-
-	return rb_int(lowest);
+	return NULL;
 }
 
 struct rb_int_node *rb_int_search_range(struct rb_root *root, u64 low, u64 high)
-- 
1.7.7.3
