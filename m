Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2EAKgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 06:36:17 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:12501 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754533Ab2EAKgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 06:36:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAFAEC8n095Ldcn/2dsb2JhbABEr2eDAIEIgkocIykmJhgNJBMZh3O6GJAmYwSVfZBDgno
Date: Tue, 1 May 2012 20:36:09 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] radix-tree: fix preload vector size
Message-ID: <20120501103608.GA21212@hp.local0.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


radix-tree: fix preload vector size

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---

Verified behaviour with rtth.

This was brought to my attention by someone at some point a while
back, but I can't for the life of me work out who, and give proper
credit. Anyway:

Index: linux/lib/radix-tree.c
===================================================================
--- linux.orig/lib/radix-tree.c
+++ linux/lib/radix-tree.c
@@ -73,11 +73,24 @@ static unsigned long height_to_maxindex[
 static struct kmem_cache *radix_tree_node_cachep;
 
 /*
+ * The radix tree is variable-height, so an insert operation not only has
+ * to build the branch to its corresponding item, it also has to build the
+ * branch to existing items if the size has to be increased (by
+ * radix_tree_extend).
+ *
+ * The worst case is a zero height tree with just a single item at index 0,
+ * and then inserting an item at index ULONG_MAX. This requires 2 new branches
+ * of RADIX_TREE_MAX_PATH size to be created, with only the root node shared.
+ * Hence:
+ */
+#define RADIX_TREE_PRELOAD_SIZE (RADIX_TREE_MAX_PATH * 2 - 1)
+
+/*
  * Per-cpu pool of preloaded nodes
  */
 struct radix_tree_preload {
 	int nr;
-	struct radix_tree_node *nodes[RADIX_TREE_MAX_PATH];
+	struct radix_tree_node *nodes[RADIX_TREE_PRELOAD_SIZE];
 };
 static DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
 
