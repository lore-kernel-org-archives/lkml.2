Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab2KTOcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:32:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:64733 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2KTOcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:32:05 -0500
X-AuditID: cbfee61b-b7f616d00000319b-fc-50ab946350ad
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Soren Moch <smoch@web.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Cooper <jason@lakedaemon.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH v2] mm: dmapool: use provided gfp flags for all
 dma_alloc_coherent() calls
Date: Tue, 20 Nov 2012 15:31:45 +0100
Message-id: <1353421905-3112-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <20121119144826.f59667b2.akpm@linux-foundation.org>
References: <20121119144826.f59667b2.akpm@linux-foundation.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJMWRmVeSWpSXmKPExsVy+t9jAd3kKasDDE4vsLK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZj59PYSlYIl+x+fh3pgbGa5JdjJwcEgImEs8u/GWCsMUkLtxb
	z9bFyMUhJLCIUeL4y00sEM4KJom/v5aAVbEJGEp0ve0CquLgEBGokZg3gxGkhlngC7PErb8L
	mUFqhAViJD43HmIEsVkEVCX+fVoEFucVcJe4+vIXI0ivhICCxJxJNiAmp4CDxPZ+QZAKIQF7
	iWm3p7JPYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyPY38+kdzCuarA4xCjAwajE
	w/swYVWAEGtiWXFl7iFGCQ5mJRFe157VAUK8KYmVValF+fFFpTmpxYcYpTlYlMR5mz1SAoQE
	0hNLUrNTUwtSi2CyTBycUg2MBp6fRfvl58u/e7jyyu7b334sfKM/veXnOaOdE3cyejzuuBbb
	Xj1x8YNl3aads49fykkoiREq8LSe0ixZWbmNT8Tu0yUTmbW7EhI/uE570Ptf+OOll/ybWYqT
	+5a7VTXb39tgP6tgU/7cZbzMr84ucTZep/j4S9vN2fs9ZX7MOmmb8oHZv/CmiBJLcUaioRZz
	UXEiAGh1IPTzAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

changelog
v2:
 - removed all waitq related stuff
 - extended commit message

 mm/dmapool.c |   31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index c5ab33b..da1b0f0 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -50,7 +50,6 @@ struct dma_pool {		/* the pool */
 	size_t allocation;
 	size_t boundary;
 	char name[32];
-	wait_queue_head_t waitq;
 	struct list_head pools;
 };
 
@@ -62,8 +61,6 @@ struct dma_page {		/* cacheable header for 'allocation' bytes */
 	unsigned int offset;
 };
 
-#define	POOL_TIMEOUT_JIFFIES	((100 /* msec */ * HZ) / 1000)
-
 static DEFINE_MUTEX(pools_lock);
 
 static ssize_t
@@ -172,7 +169,6 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 	retval->size = size;
 	retval->boundary = boundary;
 	retval->allocation = allocation;
-	init_waitqueue_head(&retval->waitq);
 
 	if (dev) {
 		int ret;
@@ -227,7 +223,6 @@ static struct dma_page *pool_alloc_page(struct dma_pool *pool, gfp_t mem_flags)
 		memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 #endif
 		pool_initialise_page(pool, page);
-		list_add(&page->page_list, &pool->page_list);
 		page->in_use = 0;
 		page->offset = 0;
 	} else {
@@ -315,30 +310,21 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
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
@@ -348,7 +334,6 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 #ifdef	DMAPOOL_DEBUG
 	memset(retval, POOL_POISON_ALLOCATED, pool->size);
 #endif
- done:
 	spin_unlock_irqrestore(&pool->lock, flags);
 	return retval;
 }
@@ -435,8 +420,6 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
 	page->in_use--;
 	*(int *)vaddr = page->offset;
 	page->offset = offset;
-	if (waitqueue_active(&pool->waitq))
-		wake_up_locked(&pool->waitq);
 	/*
 	 * Resist a temptation to do
 	 *    if (!is_page_busy(page)) pool_free_page(pool, page);
-- 
1.7.9.5

