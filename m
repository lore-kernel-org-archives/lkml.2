Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab2LNWaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:30:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:38702 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756868Ab2LNW3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:29:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Soeren Moch <smoch@web.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [ 09/28] mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls
Date: Fri, 14 Dec 2012 14:26:26 -0800
Message-Id: <20121214222252.565388274@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222250.501309822@linuxfoundation.org>
References: <20121214222250.501309822@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 387870f2d6d679746020fa8e25ef786ff338dc98 upstream.

dmapool always calls dma_alloc_coherent() with GFP_ATOMIC flag,
regardless the flags provided by the caller. This causes excessive
pruning of emergency memory pools without any good reason. Additionaly,
on ARM architecture any driver which is using dmapools will sooner or
later  trigger the following error:
"ERROR: 256 KiB atomic DMA coherent pool is too small!
Please increase it with coherent_pool= kernel parameter!".
Increasing the coherent pool size usually doesn't help much and only
delays such error, because all GFP_ATOMIC DMA allocations are always
served from the special, very limited memory pool.

This patch changes the dmapool code to correctly use gfp flags provided
by the dmapool caller.

Reported-by: Soeren Moch <smoch@web.de>
Reported-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Soeren Moch <smoch@web.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/dmapool.c |   31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -50,7 +50,6 @@ struct dma_pool {		/* the pool */
 	size_t allocation;
 	size_t boundary;
 	char name[32];
-	wait_queue_head_t waitq;
 	struct list_head pools;
 };
 
@@ -62,8 +61,6 @@ struct dma_page {		/* cacheable header f
 	unsigned int offset;
 };
 
-#define	POOL_TIMEOUT_JIFFIES	((100 /* msec */ * HZ) / 1000)
-
 static DEFINE_MUTEX(pools_lock);
 
 static ssize_t
@@ -172,7 +169,6 @@ struct dma_pool *dma_pool_create(const c
 	retval->size = size;
 	retval->boundary = boundary;
 	retval->allocation = allocation;
-	init_waitqueue_head(&retval->waitq);
 
 	if (dev) {
 		int ret;
@@ -227,7 +223,6 @@ static struct dma_page *pool_alloc_page(
 		memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 #endif
 		pool_initialise_page(pool, page);
-		list_add(&page->page_list, &pool->page_list);
 		page->in_use = 0;
 		page->offset = 0;
 	} else {
@@ -315,30 +310,21 @@ void *dma_pool_alloc(struct dma_pool *po
 	might_sleep_if(mem_flags & __GFP_WAIT);
 
 	spin_lock_irqsave(&pool->lock, flags);
- restart:
 	list_for_each_entry(page, &pool->page_list, page_list) {
 		if (page->offset < pool->allocation)
 			goto ready;
 	}
-	page = pool_alloc_page(pool, GFP_ATOMIC);
-	if (!page) {
-		if (mem_flags & __GFP_WAIT) {
-			DECLARE_WAITQUEUE(wait, current);
 
-			__set_current_state(TASK_UNINTERRUPTIBLE);
-			__add_wait_queue(&pool->waitq, &wait);
-			spin_unlock_irqrestore(&pool->lock, flags);
+	/* pool_alloc_page() might sleep, so temporarily drop &pool->lock */
+	spin_unlock_irqrestore(&pool->lock, flags);
 
-			schedule_timeout(POOL_TIMEOUT_JIFFIES);
+	page = pool_alloc_page(pool, mem_flags);
+	if (!page)
+		return NULL;
 
-			spin_lock_irqsave(&pool->lock, flags);
-			__remove_wait_queue(&pool->waitq, &wait);
-			goto restart;
-		}
-		retval = NULL;
-		goto done;
-	}
+	spin_lock_irqsave(&pool->lock, flags);
 
+	list_add(&page->page_list, &pool->page_list);
  ready:
 	page->in_use++;
 	offset = page->offset;
@@ -348,7 +334,6 @@ void *dma_pool_alloc(struct dma_pool *po
 #ifdef	DMAPOOL_DEBUG
 	memset(retval, POOL_POISON_ALLOCATED, pool->size);
 #endif
- done:
 	spin_unlock_irqrestore(&pool->lock, flags);
 	return retval;
 }
@@ -435,8 +420,6 @@ void dma_pool_free(struct dma_pool *pool
 	page->in_use--;
 	*(int *)vaddr = page->offset;
 	page->offset = offset;
-	if (waitqueue_active(&pool->waitq))
-		wake_up_locked(&pool->waitq);
 	/*
 	 * Resist a temptation to do
 	 *    if (!is_page_busy(page)) pool_free_page(pool, page);


