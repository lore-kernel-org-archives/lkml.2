Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab1LVASJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:18:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41572 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab1LVASF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:18:05 -0500
Date: Wed, 21 Dec 2011 16:18:00 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mempool: drop unnecessary and incorrect BUG_ON() from
 mempool_destroy()
Message-ID: <20111222001800.GL9213@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
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
Cc: stable@kernel.org
---
These patches are on top of "mempool: fix and document synchronization
and memory barrier usage" patch[1].  Both are fixes and it probably is
a good idea to forward to -stable.

[1] http://thread.gmane.org/gmane.linux.kernel/1231609/focus=1232127

 mm/mempool.c |   30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

Index: work/mm/mempool.c
===================================================================
--- work.orig/mm/mempool.c
+++ work/mm/mempool.c
@@ -27,7 +27,15 @@ static void *remove_element(mempool_t *p
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
@@ -86,7 +95,7 @@ mempool_t *mempool_create_node(int min_n
 
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
