Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab2ADVg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 16:36:59 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:60046 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935Ab2ADVg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 16:36:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        j.glisse@gmail.com, bskeggs@redhat.com, thellstrom@vmware.co,
        airlied@linux.ie
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/3] drm/ttm/dma: Fix accounting error when calling ttm_mem_global_free_page and don't try to free freed pages.
Date: Wed,  4 Jan 2012 16:35:15 -0500
Message-Id: <1325712916-27962-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1325712916-27962-1-git-send-email-konrad.wilk@oracle.com>
References: <1325712916-27962-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F04C674.0016,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code to figure out how many pages to shrink the pool
ends up capping the 'count' at _manager->options.max_size - which is OK.
Except that the 'count' is also used when accounting for how many pages
are recycled - which we end up with the invalid values. This fixes
it by using a different value for the amount of pages to shrink.

On top of that we would free the cached page pool - which is nonsense
as they are deleted from the pool - so there are no free pages in that
pool..

Also we also missed the opportunity to batch the amount of pages
to free (similar to how ttm_page_alloc.c does it). This reintroduces
the code that was lost during rebasing.

Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
index 6c06d0b..156ddcd 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -949,7 +949,7 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
 	struct dma_page *d_page, *next;
 	enum pool_type type;
 	bool is_cached = false;
-	unsigned count = 0, i;
+	unsigned count = 0, i, npages = 0;
 	unsigned long irq_flags;
 
 	type = ttm_to_type(ttm->page_flags, ttm->caching_state);
@@ -974,8 +974,13 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
 	} else {
 		pool->npages_free += count;
 		list_splice(&ttm_dma->pages_list, &pool->free_list);
+		npages = count;
 		if (pool->npages_free > _manager->options.max_size) {
-			count = pool->npages_free - _manager->options.max_size;
+			npages = pool->npages_free - _manager->options.max_size;
+			/* free at least NUM_PAGES_TO_ALLOC number of pages
+			 * to reduce calls to set_memory_wb */
+			if (npages < NUM_PAGES_TO_ALLOC)
+				npages = NUM_PAGES_TO_ALLOC;
 		}
 	}
 	spin_unlock_irqrestore(&pool->lock, irq_flags);
@@ -999,9 +1004,9 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
 		ttm_dma->dma_address[i] = 0;
 	}
 
-	/* shrink pool if necessary */
-	if (count)
-		ttm_dma_page_pool_free(pool, count);
+	/* shrink pool if necessary (only on !is_cached pools)*/
+	if (npages)
+		ttm_dma_page_pool_free(pool, npages);
 	ttm->state = tt_unpopulated;
 }
 EXPORT_SYMBOL_GPL(ttm_dma_unpopulate);
-- 
1.7.7.4

