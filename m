Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab0LGCJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:09:05 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47207 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab0LGCIl (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 21:08:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/7] ttm: Introduce a placeholder for DMA (bus) addresses.
Date: Mon,  6 Dec 2010 21:07:20 -0500
Message-Id: <1291687646-31994-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291687646-31994-1-git-send-email-konrad.wilk@oracle.com>
References: <1291687646-31994-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is right now limited to only non-pool constructs.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/ttm/ttm_page_alloc.c |    9 ++++++---
 drivers/gpu/drm/ttm/ttm_tt.c         |   10 ++++++++--
 include/drm/ttm/ttm_bo_driver.h      |    2 ++
 include/drm/ttm/ttm_page_alloc.h     |    8 ++++++--
 4 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index b1e02ff..6859288 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -38,6 +38,7 @@
 #include <linux/mm.h>
 #include <linux/seq_file.h> /* for seq_printf */
 #include <linux/slab.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/atomic.h>
 
@@ -662,7 +663,8 @@ out:
  * cached pages.
  */
 int ttm_get_pages(struct list_head *pages, int flags,
-		enum ttm_caching_state cstate, unsigned count)
+		enum ttm_caching_state cstate, unsigned count,
+		dma_addr_t *dma_address)
 {
 	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
 	struct page *p = NULL;
@@ -720,7 +722,7 @@ int ttm_get_pages(struct list_head *pages, int flags,
 			printk(KERN_ERR TTM_PFX
 			       "Failed to allocate extra pages "
 			       "for large request.");
-			ttm_put_pages(pages, 0, flags, cstate);
+			ttm_put_pages(pages, 0, flags, cstate, NULL);
 			return r;
 		}
 	}
@@ -731,7 +733,8 @@ int ttm_get_pages(struct list_head *pages, int flags,
 
 /* Put all pages in pages list to correct pool to wait for reuse */
 void ttm_put_pages(struct list_head *pages, unsigned page_count, int flags,
-		enum ttm_caching_state cstate)
+		enum ttm_caching_state cstate,
+		dma_addr_t *dma_address)
 {
 	unsigned long irq_flags;
 	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index af789dc..0d39001 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -49,12 +49,16 @@ static int ttm_tt_swapin(struct ttm_tt *ttm);
 static void ttm_tt_alloc_page_directory(struct ttm_tt *ttm)
 {
 	ttm->pages = drm_calloc_large(ttm->num_pages, sizeof(*ttm->pages));
+	ttm->dma_address = drm_calloc_large(ttm->num_pages,
+					    sizeof(*ttm->dma_address));
 }
 
 static void ttm_tt_free_page_directory(struct ttm_tt *ttm)
 {
 	drm_free_large(ttm->pages);
 	ttm->pages = NULL;
+	drm_free_large(ttm->dma_address);
+	ttm->dma_address = NULL;
 }
 
 static void ttm_tt_free_user_pages(struct ttm_tt *ttm)
@@ -105,7 +109,8 @@ static struct page *__ttm_tt_get_page(struct ttm_tt *ttm, int index)
 
 		INIT_LIST_HEAD(&h);
 
-		ret = ttm_get_pages(&h, ttm->page_flags, ttm->caching_state, 1);
+		ret = ttm_get_pages(&h, ttm->page_flags, ttm->caching_state, 1,
+				    &ttm->dma_address[index]);
 
 		if (ret != 0)
 			return NULL;
@@ -298,7 +303,8 @@ static void ttm_tt_free_alloced_pages(struct ttm_tt *ttm)
 			count++;
 		}
 	}
-	ttm_put_pages(&h, count, ttm->page_flags, ttm->caching_state);
+	ttm_put_pages(&h, count, ttm->page_flags, ttm->caching_state,
+		      ttm->dma_address);
 	ttm->state = tt_unpopulated;
 	ttm->first_himem_page = ttm->num_pages;
 	ttm->last_lomem_page = -1;
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index 8e0c848..6dc4fcc 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -149,6 +149,7 @@ enum ttm_caching_state {
  * @swap_storage: Pointer to shmem struct file for swap storage.
  * @caching_state: The current caching state of the pages.
  * @state: The current binding state of the pages.
+ * @dma_address: The DMA (bus) addresses of the pages (if TTM_PAGE_FLAG_DMA32)
  *
  * This is a structure holding the pages, caching- and aperture binding
  * status for a buffer object that isn't backed by fixed (VRAM / AGP)
@@ -173,6 +174,7 @@ struct ttm_tt {
 		tt_unbound,
 		tt_unpopulated,
 	} state;
+	dma_addr_t *dma_address;
 };
 
 #define TTM_MEMTYPE_FLAG_FIXED         (1 << 0)	/* Fixed (on-card) PCI memory */
diff --git a/include/drm/ttm/ttm_page_alloc.h b/include/drm/ttm/ttm_page_alloc.h
index 1168214..8062890 100644
--- a/include/drm/ttm/ttm_page_alloc.h
+++ b/include/drm/ttm/ttm_page_alloc.h
@@ -36,11 +36,13 @@
  * @flags: ttm flags for page allocation.
  * @cstate: ttm caching state for the page.
  * @count: number of pages to allocate.
+ * @dma_address: The DMA (bus) address of pages (if TTM_PAGE_FLAG_DMA32 set).
  */
 int ttm_get_pages(struct list_head *pages,
 		  int flags,
 		  enum ttm_caching_state cstate,
-		  unsigned count);
+		  unsigned count,
+		  dma_addr_t *dma_address);
 /**
  * Put linked list of pages to pool.
  *
@@ -49,11 +51,13 @@ int ttm_get_pages(struct list_head *pages,
  * count.
  * @flags: ttm flags for page allocation.
  * @cstate: ttm caching state.
+ * @dma_address: The DMA (bus) address of pages (if TTM_PAGE_FLAG_DMA32 set).
  */
 void ttm_put_pages(struct list_head *pages,
 		   unsigned page_count,
 		   int flags,
-		   enum ttm_caching_state cstate);
+		   enum ttm_caching_state cstate,
+		   dma_addr_t *dma_address);
 /**
  * Initialize pool allocator.
  */
-- 
1.7.1

