Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab1LVVpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 16:45:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37320 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab1LVVph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 16:45:37 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/7] mempool: drop unnecessary and incorrect BUG_ON() from mempool_destroy()
Date: Thu, 22 Dec 2011 13:45:21 -0800
Message-Id: <1324590326-10135-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1324590326-10135-1-git-send-email-tj@kernel.org>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mempool_destroy() is a thin wrapper around free_pool().  The only
thing it adds is BUG_ON(pool->curr_nr != pool->min_nr).  The intention
seems to be to enforce that all allocated elements are freed; however,
the BUG_ON() can't achieve that (it doesn't know anything about
objects above min_nr) and incorrect as mempool_resize() is allowed to
leave the pool extended but not filled.  Furthermore, panicking is way
worse than any memory leak and there are better debug tools to track
memory leaks.

Drop the BUG_ON() from mempool_destory() and as that leaves the
function identical to free_pool(), replace it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/mempool.c |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 11f0d0a..e3a802a 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -27,7 +27,15 @@ static void *remove_element(mempool_t *pool)
 	return pool->elements[--pool->curr_nr];
 }
 
-static void free_pool(mempool_t *pool)
+/**
+ * mempool_destroy - deallocate a memory pool
+ * @pool:      pointer to the memory pool which was allocated via
+ *             mempool_create().
+ *
+ * Free all reserved elements in @pool and @pool itself.  This function
+ * only sleeps if the free_fn() function sleeps.
+ */
+void mempool_destroy(mempool_t *pool)
 {
 	while (pool->curr_nr) {
 		void *element = remove_element(pool);
@@ -36,6 +44,7 @@ static void free_pool(mempool_t *pool)
 	kfree(pool->elements);
 	kfree(pool);
 }
+EXPORT_SYMBOL(mempool_destroy);
 
 /**
  * mempool_create - create a memory pool
@@ -86,7 +95,7 @@ mempool_t *mempool_create_node(int min_nr, mempool_alloc_t *alloc_fn,
 
 		element = pool->alloc(GFP_KERNEL, pool->pool_data);
 		if (unlikely(!element)) {
-			free_pool(pool);
+			mempool_destroy(pool);
 			return NULL;
 		}
 		add_element(pool, element);
@@ -172,23 +181,6 @@ out:
 EXPORT_SYMBOL(mempool_resize);
 
 /**
- * mempool_destroy - deallocate a memory pool
- * @pool:      pointer to the memory pool which was allocated via
- *             mempool_create().
- *
- * this function only sleeps if the free_fn() function sleeps. The caller
- * has to guarantee that all elements have been returned to the pool (ie:
- * freed) prior to calling mempool_destroy().
- */
-void mempool_destroy(mempool_t *pool)
-{
-	/* Check for outstanding elements */
-	BUG_ON(pool->curr_nr != pool->min_nr);
-	free_pool(pool);
-}
-EXPORT_SYMBOL(mempool_destroy);
-
-/**
  * mempool_alloc - allocate an element from a specific memory pool
  * @pool:      pointer to the memory pool which was allocated via
  *             mempool_create().
-- 
1.7.3.1

