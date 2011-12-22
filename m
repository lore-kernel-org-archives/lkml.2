Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab1LVVpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 16:45:50 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34340 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab1LVVpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 16:45:42 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/7] mempool: factor out mempool_fill()
Date: Thu, 22 Dec 2011 13:45:23 -0800
Message-Id: <1324590326-10135-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1324590326-10135-1-git-send-email-tj@kernel.org>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out mempool_fill() from mempool_create() and mempool_resize().
When called, it fills the reservoir upto the configured min_nr
elements.

After the change, gotos in mempool_resize() exit paths don't make
whole lot of sense, unlock and return directly.

Note that mempool_create() repeatedly locks and unlocks pool->lock
while filling the pool initially and mempool_resize() may go through
one extra locking cycle.  This shouldn't result in noticeable
difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 mm/mempool.c |   75 ++++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 47 insertions(+), 28 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 6326cc6..4747283 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -47,6 +47,43 @@ void mempool_destroy(mempool_t *pool)
 EXPORT_SYMBOL(mempool_destroy);
 
 /**
+ * mempool_fill - fill a memory pool
+ * @pool:	memory pool to fill
+ * @gfp_mask:	allocation mask to use
+ *
+ * Allocate new elements with @gfp_mask and fill @pool so that it has
+ * @pool->min_nr elements.  Returns 0 on success, -errno on failure.
+ */
+static int mempool_fill(mempool_t *pool, gfp_t gfp_mask)
+{
+	/*
+	 * If curr_nr == min_nr is visible, we're correct regardless of
+	 * locking.
+	 */
+	while (pool->curr_nr < pool->min_nr) {
+		void *elem;
+		unsigned long flags;
+
+		elem = pool->alloc(gfp_mask, pool->pool_data);
+		if (unlikely(!elem))
+			return -ENOMEM;
+
+		spin_lock_irqsave(&pool->lock, flags);
+		if (pool->curr_nr < pool->min_nr) {
+			add_element(pool, elem);
+			elem = NULL;
+		}
+		spin_unlock_irqrestore(&pool->lock, flags);
+
+		if (elem) {
+			pool->free(elem, pool->pool_data);
+			return 0;
+		}
+	}
+	return 0;
+}
+
+/**
  * mempool_create - create a memory pool
  * @min_nr:    the minimum number of elements guaranteed to be
  *             allocated for this pool.
@@ -90,16 +127,11 @@ mempool_t *mempool_create_node(int min_nr, mempool_alloc_t *alloc_fn,
 	/*
 	 * First pre-allocate the guaranteed number of buffers.
 	 */
-	while (pool->curr_nr < pool->min_nr) {
-		void *element;
-
-		element = pool->alloc(GFP_KERNEL, pool->pool_data);
-		if (unlikely(!element)) {
-			mempool_destroy(pool);
-			return NULL;
-		}
-		add_element(pool, element);
+	if (mempool_fill(pool, GFP_KERNEL)) {
+		mempool_destroy(pool);
+		return NULL;
 	}
+
 	return pool;
 }
 EXPORT_SYMBOL(mempool_create_node);
@@ -137,7 +169,8 @@ int mempool_resize(mempool_t *pool, int new_min_nr, gfp_t gfp_mask)
 			spin_lock_irqsave(&pool->lock, flags);
 		}
 		pool->min_nr = new_min_nr;
-		goto out_unlock;
+		spin_unlock_irqrestore(&pool->lock, flags);
+		return 0;
 	}
 	spin_unlock_irqrestore(&pool->lock, flags);
 
@@ -151,31 +184,17 @@ int mempool_resize(mempool_t *pool, int new_min_nr, gfp_t gfp_mask)
 		/* Raced, other resize will do our work */
 		spin_unlock_irqrestore(&pool->lock, flags);
 		kfree(new_elements);
-		goto out;
+		return 0;
 	}
 	memcpy(new_elements, pool->elements,
 			pool->curr_nr * sizeof(*new_elements));
 	kfree(pool->elements);
 	pool->elements = new_elements;
 	pool->min_nr = new_min_nr;
-
-	while (pool->curr_nr < pool->min_nr) {
-		spin_unlock_irqrestore(&pool->lock, flags);
-		element = pool->alloc(gfp_mask, pool->pool_data);
-		if (!element)
-			goto out;
-		spin_lock_irqsave(&pool->lock, flags);
-		if (pool->curr_nr < pool->min_nr) {
-			add_element(pool, element);
-		} else {
-			spin_unlock_irqrestore(&pool->lock, flags);
-			pool->free(element, pool->pool_data);	/* Raced */
-			goto out;
-		}
-	}
-out_unlock:
 	spin_unlock_irqrestore(&pool->lock, flags);
-out:
+
+	mempool_fill(pool, gfp_mask);
+
 	return 0;
 }
 EXPORT_SYMBOL(mempool_resize);
-- 
1.7.3.1

