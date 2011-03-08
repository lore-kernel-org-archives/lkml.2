Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab1CHPli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:41:38 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:37676 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab1CHPlY (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 8 Mar 2011 10:41:24 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org,
        Thomas Hellstrom <thomas@shipmail.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] ttm: Include the 'struct dev' when using the DMA API.
Date: Tue,  8 Mar 2011 10:39:48 -0500
Message-Id: <1299598789-20402-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299598789-20402-1-git-send-email-konrad.wilk@oracle.com>
References: <1299598789-20402-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D764E12.01B0,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the accounting when using 'debug_dma_dump_mappings()'
and CONFIG_DMA_API_DEBUG=y be assigned to the correct device
instead of 'fallback'.

No functional change - just cosmetic.

At first it seems that we just need to keep a copy of
'struct device' in the struct ttm_bo_device and use that. However,
when 'ttm_tt_destroy' is called it sets ttm->be (which contains
the 'struct ttm_bo_device') to NULL so we cannot use it. Hence
we copy the 'struct device' pointer to the 'struct ttm_tm' and keep
it there.

[v2: Added 'struct device' in 'struct ttm_tm']

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/nouveau/nouveau_mem.c |    1 +
 drivers/gpu/drm/radeon/radeon_ttm.c   |    1 +
 drivers/gpu/drm/ttm/ttm_page_alloc.c  |   11 ++++++-----
 drivers/gpu/drm/ttm/ttm_tt.c          |    5 +++--
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c   |    2 +-
 include/drm/ttm/ttm_bo_driver.h       |    2 ++
 include/drm/ttm/ttm_page_alloc.h      |    8 ++++++--
 7 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_mem.c b/drivers/gpu/drm/nouveau/nouveau_mem.c
index 26347b7..7b57067 100644
--- a/drivers/gpu/drm/nouveau/nouveau_mem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_mem.c
@@ -409,6 +409,7 @@ nouveau_mem_vram_init(struct drm_device *dev)
 	if (ret)
 		return ret;
 
+	dev_priv->ttm.bdev.dev = dev->dev;
 	ret = ttm_bo_device_init(&dev_priv->ttm.bdev,
 				 dev_priv->ttm.bo_global_ref.ref.object,
 				 &nouveau_bo_driver, DRM_FILE_PAGE_OFFSET,
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 9ead11f..d19bfcf 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -513,6 +513,7 @@ int radeon_ttm_init(struct radeon_device *rdev)
 	if (r) {
 		return r;
 	}
+	rdev->mman.bdev.dev = rdev->dev;
 	/* No others user of address space so set it to 0 */
 	r = ttm_bo_device_init(&rdev->mman.bdev,
 			       rdev->mman.bo_global_ref.ref.object,
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index 737a2a2..35849db 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -664,7 +664,7 @@ out:
  */
 int ttm_get_pages(struct list_head *pages, int flags,
 		  enum ttm_caching_state cstate, unsigned count,
-		  dma_addr_t *dma_address)
+		  dma_addr_t *dma_address, struct device *dev)
 {
 	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
 	struct page *p = NULL;
@@ -685,7 +685,7 @@ int ttm_get_pages(struct list_head *pages, int flags,
 		for (r = 0; r < count; ++r) {
 			if ((flags & TTM_PAGE_FLAG_DMA32) && dma_address) {
 				void *addr;
-				addr = dma_alloc_coherent(NULL, PAGE_SIZE,
+				addr = dma_alloc_coherent(dev, PAGE_SIZE,
 							  &dma_address[r],
 							  gfp_flags);
 				if (addr == NULL)
@@ -730,7 +730,7 @@ int ttm_get_pages(struct list_head *pages, int flags,
 			printk(KERN_ERR TTM_PFX
 			       "Failed to allocate extra pages "
 			       "for large request.");
-			ttm_put_pages(pages, 0, flags, cstate, NULL);
+			ttm_put_pages(pages, 0, flags, cstate, NULL, NULL);
 			return r;
 		}
 	}
@@ -741,7 +741,8 @@ int ttm_get_pages(struct list_head *pages, int flags,
 
 /* Put all pages in pages list to correct pool to wait for reuse */
 void ttm_put_pages(struct list_head *pages, unsigned page_count, int flags,
-		   enum ttm_caching_state cstate, dma_addr_t *dma_address)
+		   enum ttm_caching_state cstate, dma_addr_t *dma_address,
+		   struct device *dev)
 {
 	unsigned long irq_flags;
 	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
@@ -757,7 +758,7 @@ void ttm_put_pages(struct list_head *pages, unsigned page_count, int flags,
 				void *addr = page_address(p);
 				WARN_ON(!addr || !dma_address[r]);
 				if (addr)
-					dma_free_coherent(NULL, PAGE_SIZE,
+					dma_free_coherent(dev, PAGE_SIZE,
 							  addr,
 							  dma_address[r]);
 				dma_address[r] = 0;
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 86d5b17..354f9d9 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -110,7 +110,7 @@ static struct page *__ttm_tt_get_page(struct ttm_tt *ttm, int index)
 		INIT_LIST_HEAD(&h);
 
 		ret = ttm_get_pages(&h, ttm->page_flags, ttm->caching_state, 1,
-				    &ttm->dma_address[index]);
+				    &ttm->dma_address[index], ttm->dev);
 
 		if (ret != 0)
 			return NULL;
@@ -304,7 +304,7 @@ static void ttm_tt_free_alloced_pages(struct ttm_tt *ttm)
 		}
 	}
 	ttm_put_pages(&h, count, ttm->page_flags, ttm->caching_state,
-		      ttm->dma_address);
+		      ttm->dma_address, ttm->dev);
 	ttm->state = tt_unpopulated;
 	ttm->first_himem_page = ttm->num_pages;
 	ttm->last_lomem_page = -1;
@@ -397,6 +397,7 @@ struct ttm_tt *ttm_tt_create(struct ttm_bo_device *bdev, unsigned long size,
 	ttm->last_lomem_page = -1;
 	ttm->caching_state = tt_cached;
 	ttm->page_flags = page_flags;
+	ttm->dev = bdev->dev;
 
 	ttm->dummy_read_page = dummy_read_page;
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 10ca97e..4a8c789 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -322,7 +322,7 @@ static int vmw_driver_load(struct drm_device *dev, unsigned long chipset)
 	ttm_lock_set_kill(&dev_priv->fbdev_master.lock, false, SIGTERM);
 	dev_priv->active_master = &dev_priv->fbdev_master;
 
-
+	dev_priv->bdev.dev = dev->dev;
 	ret = ttm_bo_device_init(&dev_priv->bdev,
 				 dev_priv->bo_global_ref.ref.object,
 				 &vmw_bo_driver, VMWGFX_FILE_PAGE_OFFSET,
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index efed082..7589c0a 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -177,6 +177,7 @@ struct ttm_tt {
 		tt_unpopulated,
 	} state;
 	dma_addr_t *dma_address;
+	struct device *dev;
 };
 
 #define TTM_MEMTYPE_FLAG_FIXED         (1 << 0)	/* Fixed (on-card) PCI memory */
@@ -551,6 +552,7 @@ struct ttm_bo_device {
 	struct list_head device_list;
 	struct ttm_bo_global *glob;
 	struct ttm_bo_driver *driver;
+	struct device *dev;
 	rwlock_t vm_lock;
 	struct ttm_mem_type_manager man[TTM_NUM_MEM_TYPES];
 	spinlock_t fence_lock;
diff --git a/include/drm/ttm/ttm_page_alloc.h b/include/drm/ttm/ttm_page_alloc.h
index 8062890..ccb6b7a 100644
--- a/include/drm/ttm/ttm_page_alloc.h
+++ b/include/drm/ttm/ttm_page_alloc.h
@@ -37,12 +37,14 @@
  * @cstate: ttm caching state for the page.
  * @count: number of pages to allocate.
  * @dma_address: The DMA (bus) address of pages (if TTM_PAGE_FLAG_DMA32 set).
+ * @dev: struct device for appropiate DMA accounting.
  */
 int ttm_get_pages(struct list_head *pages,
 		  int flags,
 		  enum ttm_caching_state cstate,
 		  unsigned count,
-		  dma_addr_t *dma_address);
+		  dma_addr_t *dma_address,
+		  struct device *dev);
 /**
  * Put linked list of pages to pool.
  *
@@ -52,12 +54,14 @@ int ttm_get_pages(struct list_head *pages,
  * @flags: ttm flags for page allocation.
  * @cstate: ttm caching state.
  * @dma_address: The DMA (bus) address of pages (if TTM_PAGE_FLAG_DMA32 set).
+ * @dev: struct device for appropiate DMA accounting.
  */
 void ttm_put_pages(struct list_head *pages,
 		   unsigned page_count,
 		   int flags,
 		   enum ttm_caching_state cstate,
-		   dma_addr_t *dma_address);
+		   dma_addr_t *dma_address,
+		   struct device *dev);
 /**
  * Initialize pool allocator.
  */
-- 
1.7.1

