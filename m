Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474Ab2FEDnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 23:43:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43604 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761428Ab2FEDlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 23:41:16 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        fengguang.wu@intel.com, hughd@google.com, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/10] mempool: add @gfp_mask to mempool_create_node()
Date: Mon,  4 Jun 2012 20:40:53 -0700
Message-Id: <1338867660-4689-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1338867660-4689-1-git-send-email-tj@kernel.org>
References: <1338867660-4689-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mempool_create_node() currently assumes %GFP_KERNEL.  Its only user,
blk_init_free_list(), is about to be updated to use other allocation
flags - add @gfp_mask argument to the function.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
---
 block/blk-core.c        |    4 ++--
 include/linux/mempool.h |    3 ++-
 mm/mempool.c            |   12 +++++++-----
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3c923a7..7465d89 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -518,8 +518,8 @@ static int blk_init_free_list(struct request_queue *q)
 	init_waitqueue_head(&rl->wait[BLK_RW_ASYNC]);
 
 	rl->rq_pool = mempool_create_node(BLKDEV_MIN_RQ, mempool_alloc_slab,
-				mempool_free_slab, request_cachep, q->node);
-
+					  mempool_free_slab, request_cachep,
+					  GFP_KERNEL, q->node);
 	if (!rl->rq_pool)
 		return -ENOMEM;
 
diff --git a/include/linux/mempool.h b/include/linux/mempool.h
index 7c08052..39ed62a 100644
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -26,7 +26,8 @@ typedef struct mempool_s {
 extern mempool_t *mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
 			mempool_free_t *free_fn, void *pool_data);
 extern mempool_t *mempool_create_node(int min_nr, mempool_alloc_t *alloc_fn,
-			mempool_free_t *free_fn, void *pool_data, int nid);
+			mempool_free_t *free_fn, void *pool_data,
+			gfp_t gfp_mask, int nid);
 
 extern int mempool_resize(mempool_t *pool, int new_min_nr, gfp_t gfp_mask);
 extern void mempool_destroy(mempool_t *pool);
diff --git a/mm/mempool.c b/mm/mempool.c
index d904981..5499047 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -63,19 +63,21 @@ EXPORT_SYMBOL(mempool_destroy);
 mempool_t *mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
 				mempool_free_t *free_fn, void *pool_data)
 {
-	return  mempool_create_node(min_nr,alloc_fn,free_fn, pool_data,-1);
+	return mempool_create_node(min_nr,alloc_fn,free_fn, pool_data,
+				   GFP_KERNEL, NUMA_NO_NODE);
 }
 EXPORT_SYMBOL(mempool_create);
 
 mempool_t *mempool_create_node(int min_nr, mempool_alloc_t *alloc_fn,
-			mempool_free_t *free_fn, void *pool_data, int node_id)
+			       mempool_free_t *free_fn, void *pool_data,
+			       gfp_t gfp_mask, int node_id)
 {
 	mempool_t *pool;
-	pool = kmalloc_node(sizeof(*pool), GFP_KERNEL | __GFP_ZERO, node_id);
+	pool = kmalloc_node(sizeof(*pool), gfp_mask | __GFP_ZERO, node_id);
 	if (!pool)
 		return NULL;
 	pool->elements = kmalloc_node(min_nr * sizeof(void *),
-					GFP_KERNEL, node_id);
+				      gfp_mask, node_id);
 	if (!pool->elements) {
 		kfree(pool);
 		return NULL;
@@ -93,7 +95,7 @@ mempool_t *mempool_create_node(int min_nr, mempool_alloc_t *alloc_fn,
 	while (pool->curr_nr < pool->min_nr) {
 		void *element;
 
-		element = pool->alloc(GFP_KERNEL, pool->pool_data);
+		element = pool->alloc(gfp_mask, pool->pool_data);
 		if (unlikely(!element)) {
 			mempool_destroy(pool);
 			return NULL;
-- 
1.7.7.3

