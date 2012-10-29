Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab2J2MMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 08:12:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:15928 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab2J2MML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 08:12:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,671,1344236400"; 
   d="scan'208";a="234017663"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Pekka Enberg <penberg@kernel.org>, Asias He <asias.hejun@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kvm tools: fix rbtree-interval search
Date: Mon, 29 Oct 2012 14:12:57 +0200
Message-Id: <1351512780-8563-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

I've noticed message on kvm exit:

  Warning: serial8250__exit failed.

kvm tool is not able to remove ioport range which was added previously.

The issue is caused by bug in rbtree-interval. Search algorithm in
rb_int_search_single() expects correct value of max_high. But the tree
can contain leaf nodes, which never were updated by propagate_callback().
For this kind of nodes high_max will be 0 and we will not be able to
find and remove them.

Let's initialize max_high on RB_INT_INIT() time.

Fixing this bug makes other bug visible: propagate_callback() can be
called for empty tree: node == NULL. The callback is not ready for empty
tree. Let's fix that as well.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 tools/kvm/include/kvm/rbtree-interval.h |    3 ++-
 tools/kvm/util/rbtree-interval.c        |    6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/kvm/include/kvm/rbtree-interval.h b/tools/kvm/include/kvm/rbtree-interval.h
index e97d05b..fb2102a 100644
--- a/tools/kvm/include/kvm/rbtree-interval.h
+++ b/tools/kvm/include/kvm/rbtree-interval.h
@@ -4,7 +4,8 @@
 #include <linux/rbtree_augmented.h>
 #include <linux/types.h>
 
-#define RB_INT_INIT(l, h) (struct rb_int_node){.low = l, .high = h}
+#define RB_INT_INIT(l, h) \
+	(struct rb_int_node){.low = l, .high = h, .max_high = h}
 #define rb_int(n) rb_entry(n, struct rb_int_node, node)
 
 struct rb_int_node {
diff --git a/tools/kvm/util/rbtree-interval.c b/tools/kvm/util/rbtree-interval.c
index c82ce98..d7fa96a 100644
--- a/tools/kvm/util/rbtree-interval.c
+++ b/tools/kvm/util/rbtree-interval.c
@@ -48,8 +48,12 @@ struct rb_int_node *rb_int_search_range(struct rb_root *root, u64 low, u64 high)
  */
 static void propagate_callback(struct rb_node *node, struct rb_node *stop)
 {
-	struct rb_int_node *i_node = rb_int(node);
+	struct rb_int_node *i_node;
 
+	if (node == stop)
+		return;
+
+	i_node = rb_int(node);
 	i_node->max_high = i_node->high;
 
 	if (node->rb_left)
-- 
1.7.10.4

