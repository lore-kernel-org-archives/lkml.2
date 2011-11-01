Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab1KATCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:02:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28579 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab1KATCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:02:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, thellstrom@vmware.com, thomas@shipmail.org,
        airlied@redhat.com, jglisse@redhat.com, bskeggs@redhat.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 05/11] ttm: Get rid of temporary scaffolding
Date: Tue,  1 Nov 2011 14:47:26 -0400
Message-Id: <1320173252-2812-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
References: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4EB04232.014C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

which was used in the "ttm: Wrap ttm_[put|get]_pages and
extract GFP_* and caching states from 'struct ttm_tt" patch.

Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/ttm/ttm_page_alloc.c |   83 ++++++++++++++++-----------------
 1 files changed, 40 insertions(+), 43 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index c30d62b..24c0340 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -660,9 +660,48 @@ out:
 	return count;
 }
 
+/* Put all pages in pages list to correct pool to wait for reuse */
 static void __ttm_put_pages(struct list_head *pages, unsigned page_count,
 			    int flags, enum ttm_caching_state cstate,
-			    dma_addr_t *dma_address);
+			    dma_addr_t *dma_address)
+{
+	unsigned long irq_flags;
+	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
+	struct page *p, *tmp;
+
+	if (pool == NULL) {
+		/* No pool for this memory type so free the pages */
+
+		list_for_each_entry_safe(p, tmp, pages, lru) {
+			__free_page(p);
+		}
+		/* Make the pages list empty */
+		INIT_LIST_HEAD(pages);
+		return;
+	}
+	if (page_count == 0) {
+		list_for_each_entry_safe(p, tmp, pages, lru) {
+			++page_count;
+		}
+	}
+
+	spin_lock_irqsave(&pool->lock, irq_flags);
+	list_splice_init(pages, &pool->list);
+	pool->npages += page_count;
+	/* Check that we don't go over the pool limit */
+	page_count = 0;
+	if (pool->npages > _manager->options.max_size) {
+		page_count = pool->npages - _manager->options.max_size;
+		/* free at least NUM_PAGES_TO_ALLOC number of pages
+		 * to reduce calls to set_memory_wb */
+		if (page_count < NUM_PAGES_TO_ALLOC)
+			page_count = NUM_PAGES_TO_ALLOC;
+	}
+	spin_unlock_irqrestore(&pool->lock, irq_flags);
+	if (page_count)
+		ttm_page_pool_free(pool, page_count);
+}
+
 /*
  * On success pages list will hold count number of correctly
  * cached pages.
@@ -736,48 +775,6 @@ static int __ttm_get_pages(struct list_head *pages, int flags,
 	return 0;
 }
 
-/* Put all pages in pages list to correct pool to wait for reuse */
-static void __ttm_put_pages(struct list_head *pages, unsigned page_count,
-			    int flags, enum ttm_caching_state cstate,
-			    dma_addr_t *dma_address)
-{
-	unsigned long irq_flags;
-	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
-	struct page *p, *tmp;
-
-	if (pool == NULL) {
-		/* No pool for this memory type so free the pages */
-
-		list_for_each_entry_safe(p, tmp, pages, lru) {
-			__free_page(p);
-		}
-		/* Make the pages list empty */
-		INIT_LIST_HEAD(pages);
-		return;
-	}
-	if (page_count == 0) {
-		list_for_each_entry_safe(p, tmp, pages, lru) {
-			++page_count;
-		}
-	}
-
-	spin_lock_irqsave(&pool->lock, irq_flags);
-	list_splice_init(pages, &pool->list);
-	pool->npages += page_count;
-	/* Check that we don't go over the pool limit */
-	page_count = 0;
-	if (pool->npages > _manager->options.max_size) {
-		page_count = pool->npages - _manager->options.max_size;
-		/* free at least NUM_PAGES_TO_ALLOC number of pages
-		 * to reduce calls to set_memory_wb */
-		if (page_count < NUM_PAGES_TO_ALLOC)
-			page_count = NUM_PAGES_TO_ALLOC;
-	}
-	spin_unlock_irqrestore(&pool->lock, irq_flags);
-	if (page_count)
-		ttm_page_pool_free(pool, page_count);
-}
-
 static void ttm_page_pool_init_locked(struct ttm_page_pool *pool, int flags,
 		char *name)
 {
-- 
1.7.6.4

