Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1LLUKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:10:41 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:44006 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab1LLUKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:10:33 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, j.glisse@gmail.com,
        dri-devel@lists.freedesktop.org
Cc: bskeggs@redhat.com, thellstrom@vmware.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/3] drm/ttm/dma: Fix accounting error when calling ttm_mem_global_free_page.
Date: Mon, 12 Dec 2011 15:09:28 -0500
Message-Id: <1323720569-15435-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323720569-15435-1-git-send-email-konrad.wilk@oracle.com>
References: <1323720569-15435-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4EE65FB5.005F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code to figure out how many pages to shrink the pool
ends up capping the 'count' at _manager->options.max_size - which is OK.
Except that the 'count' is also used when accounting for how many pages
are recycled - which we end up with the invalid values. This fixes
it by using a different value for the amount of pages to shrink.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
index 6c06d0b..e57aa24 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -949,7 +949,7 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
 	struct dma_page *d_page, *next;
 	enum pool_type type;
 	bool is_cached = false;
-	unsigned count = 0, i;
+	unsigned count = 0, i, npages;
 	unsigned long irq_flags;
 
 	type = ttm_to_type(ttm->page_flags, ttm->caching_state);
@@ -971,11 +971,13 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
 	pool->npages_in_use -= count;
 	if (is_cached) {
 		pool->nfrees += count;
+		npages = count;
 	} else {
 		pool->npages_free += count;
 		list_splice(&ttm_dma->pages_list, &pool->free_list);
+		npages = count;
 		if (pool->npages_free > _manager->options.max_size) {
-			count = pool->npages_free - _manager->options.max_size;
+			npages = pool->npages_free - _manager->options.max_size;
 		}
 	}
 	spin_unlock_irqrestore(&pool->lock, irq_flags);
@@ -1000,8 +1002,8 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
 	}
 
 	/* shrink pool if necessary */
-	if (count)
-		ttm_dma_page_pool_free(pool, count);
+	if (npages)
+		ttm_dma_page_pool_free(pool, npages);
 	ttm->state = tt_unpopulated;
 }
 EXPORT_SYMBOL_GPL(ttm_dma_unpopulate);
-- 
1.7.7.3

