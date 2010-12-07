Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab0LGCIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:08:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:45960 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab0LGCIG (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 21:08:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/7] ttm: Utilize the dma_addr_t array for pages that are to in DMA32 pool.
Date: Mon,  6 Dec 2010 21:07:21 -0500
Message-Id: <1291687646-31994-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291687646-31994-1-git-send-email-konrad.wilk@oracle.com>
References: <1291687646-31994-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only use the "if (pool == NULL)" path for right now.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/ttm/ttm_page_alloc.c |   26 +++++++++++++++++++++++---
 1 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index 6859288..5d09677 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -683,14 +683,22 @@ int ttm_get_pages(struct list_head *pages, int flags,
 			gfp_flags |= GFP_HIGHUSER;
 
 		for (r = 0; r < count; ++r) {
-			p = alloc_page(gfp_flags);
+			if ((flags & TTM_PAGE_FLAG_DMA32) && dma_address) {
+				void *addr;
+				addr = dma_alloc_coherent(NULL, PAGE_SIZE,
+							&dma_address[r],
+							gfp_flags);
+				if (addr == NULL)
+					return -ENOMEM;
+				p = virt_to_page(addr);
+			} else
+				p = alloc_page(gfp_flags);
 			if (!p) {
 
 				printk(KERN_ERR TTM_PFX
 				       "Unable to allocate page.");
 				return -ENOMEM;
 			}
-
 			list_add(&p->lru, pages);
 		}
 		return 0;
@@ -739,12 +747,24 @@ void ttm_put_pages(struct list_head *pages, unsigned page_count, int flags,
 	unsigned long irq_flags;
 	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
 	struct page *p, *tmp;
+	unsigned r;
 
 	if (pool == NULL) {
 		/* No pool for this memory type so free the pages */
 
+		r = page_count-1;
 		list_for_each_entry_safe(p, tmp, pages, lru) {
-			__free_page(p);
+			if ((flags & TTM_PAGE_FLAG_DMA32) && dma_address) {
+				void *addr = page_address(p);
+				WARN_ON(!addr || !dma_address[r]);
+				if (addr)
+					dma_free_coherent(NULL, PAGE_SIZE,
+							addr,
+							dma_address[r]);
+				dma_address[r] = 0;
+			} else
+				__free_page(p);
+			r--;
 		}
 		/* Make the pages list empty */
 		INIT_LIST_HEAD(pages);
-- 
1.7.1

