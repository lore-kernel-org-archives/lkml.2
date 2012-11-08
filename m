Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab2KHGj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 01:39:26 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:34666 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2KHGjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 01:39:24 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-d2-509b539bcb87
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Soren Moch <smoch@web.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH] mm: dmapool: use provided gfp flags for all
 dma_alloc_coherent() calls
Date: Thu, 08 Nov 2012 07:38:57 +0100
Message-id: <1352356737-14413-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBJMWRmVeSWpSXmKPExsVy+t9jAd3ZwbMDDLomyVpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M54dMCm6IVnQ8/M/YwPhLsIuRk0NCwETi0+XVLBC2mMSFe+vZ
	uhi5OIQEFjFKbJp7nwnCWcEkcWTrZlaQKjYBQ4mut11AVRwcIgI1EvNmMILUMAusZZI4Puc8
	I0iNsECkxMudrcwgNouAqsS59z/ZQGxeAQ+JubNOgPVKCChIzJlkM4GRewEjwypG0dSC5ILi
	pPRcQ73ixNzi0rx0veT83E2MYP89k9rBuLLB4hCjAAejEg+vhuTsACHWxLLiytxDjBIczEoi
	vMucgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5mz1SAoQE0hNLUrNTUwtSi2CyTBycUg2Mx9Y4
	8u3xKOB5cLn0fxuv1kmvsrsJ+5b9v1WxffLqLrlpenO7uxR3CsYcntXON6E/0iZU9M2PLU/S
	24/0nHO8xe5a395+jEN8u9DfVauk768XYV9y6sGz2vq4rze5S/bqL4pNL3iY0rvS4pGK6cEm
	Hknh/1yv9y442tkWmZFtE+O/NJPnc+JFJZbijERDLeai4kQAYi31rtsBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmapool always calls dma_alloc_coherent() with GFP_ATOMIC flag, regardless
the flags provided by the caller. This causes excessive pruning of
emergency memory pools without any good reason. This patch changes the code
to correctly use gfp flags provided by the dmapool caller. This should
solve the dmapool usage on ARM architecture, where GFP_ATOMIC DMA
allocations can be served only from the special, very limited memory pool.

Reported-by: Soren Moch <smoch@web.de>
Reported-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 mm/dmapool.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index c5ab33b..86de9b2 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -62,8 +62,6 @@ struct dma_page {		/* cacheable header for 'allocation' bytes */
 	unsigned int offset;
 };
 
-#define	POOL_TIMEOUT_JIFFIES	((100 /* msec */ * HZ) / 1000)
-
 static DEFINE_MUTEX(pools_lock);
 
 static ssize_t
@@ -227,7 +225,6 @@ static struct dma_page *pool_alloc_page(struct dma_pool *pool, gfp_t mem_flags)
 		memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 #endif
 		pool_initialise_page(pool, page);
-		list_add(&page->page_list, &pool->page_list);
 		page->in_use = 0;
 		page->offset = 0;
 	} else {
@@ -315,30 +312,21 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
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
@@ -348,7 +336,6 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 #ifdef	DMAPOOL_DEBUG
 	memset(retval, POOL_POISON_ALLOCATED, pool->size);
 #endif
- done:
 	spin_unlock_irqrestore(&pool->lock, flags);
 	return retval;
 }
-- 
1.7.9.5

