Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab1IMOOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:14:05 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:54649 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1IMOOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:14:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: thellstrom@vmware.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, dri-devel@lists.freedesktop.org,
        thomas@shipmail.org
Cc: Pekka Paalanen <pq@iki.fi>, bskeggs@redhat.com, j.glisse@redhat.com,
        airlied@redhat.com, airlied@linux.ie, alexdeucher@gmail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/7] ttm: Pass in 'struct device' to TTM so it can do DMA API on behalf of device.
Date: Tue, 13 Sep 2011 10:12:46 -0400
Message-Id: <1315923170-25568-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315923170-25568-1-git-send-email-konrad.wilk@oracle.com>
References: <1315923170-25568-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090209.4E6F64F6.002A,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to pass in the 'struct device' to the TTM layer so that
the TTM DMA pool code (if enabled) can use it. The DMA API code
needs the 'struct device' to do the DMA API operations.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/nouveau/nouveau_mem.c |    3 ++-
 drivers/gpu/drm/radeon/radeon_ttm.c   |    3 ++-
 drivers/gpu/drm/ttm/ttm_bo.c          |    4 +++-
 drivers/gpu/drm/ttm/ttm_page_alloc.c  |   17 ++++++++++-------
 drivers/gpu/drm/ttm/ttm_tt.c          |    5 +++--
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c   |    4 ++--
 include/drm/ttm/ttm_bo_driver.h       |    7 ++++++-
 include/drm/ttm/ttm_page_alloc.h      |   16 ++++++++++++----
 8 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_mem.c b/drivers/gpu/drm/nouveau/nouveau_mem.c
index 5ee14d2..a2d7e35 100644
--- a/drivers/gpu/drm/nouveau/nouveau_mem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_mem.c
@@ -417,7 +417,8 @@ nouveau_mem_vram_init(struct drm_device *dev)
 	ret = ttm_bo_device_init(&dev_priv->ttm.bdev,
 				 dev_priv->ttm.bo_global_ref.ref.object,
 				 &nouveau_bo_driver, DRM_FILE_PAGE_OFFSET,
-				 dma_bits <= 32 ? true : false);
+				 dma_bits <= 32 ? true : false,
+				 dev->dev);
 	if (ret) {
 		NV_ERROR(dev, "Error initialising bo driver: %d\n", ret);
 		return ret;
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 60125dd..dbc6bcb 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -517,7 +517,8 @@ int radeon_ttm_init(struct radeon_device *rdev)
 	r = ttm_bo_device_init(&rdev->mman.bdev,
 			       rdev->mman.bo_global_ref.ref.object,
 			       &radeon_bo_driver, DRM_FILE_PAGE_OFFSET,
-			       rdev->need_dma32);
+			       rdev->need_dma32,
+			       rdev->dev);
 	if (r) {
 		DRM_ERROR("failed initializing buffer object driver(%d).\n", r);
 		return r;
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 2e618b5..0358889 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -1527,12 +1527,14 @@ int ttm_bo_device_init(struct ttm_bo_device *bdev,
 		       struct ttm_bo_global *glob,
 		       struct ttm_bo_driver *driver,
 		       uint64_t file_page_offset,
-		       bool need_dma32)
+		       bool need_dma32,
+		       struct device *dev)
 {
 	int ret = -EINVAL;
 
 	rwlock_init(&bdev->vm_lock);
 	bdev->driver = driver;
+	bdev->dev = dev;
 
 	memset(bdev->man, 0, sizeof(bdev->man));
 
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index 6a888f8..f9a4d83 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -666,7 +666,7 @@ out:
  */
 int __ttm_get_pages(struct list_head *pages, int flags,
 		    enum ttm_caching_state cstate, unsigned count,
-		    dma_addr_t *dma_address)
+		    dma_addr_t *dma_address, struct device *dev)
 {
 	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
 	struct page *p = NULL;
@@ -724,7 +724,8 @@ int __ttm_get_pages(struct list_head *pages, int flags,
 			printk(KERN_ERR TTM_PFX
 			       "Failed to allocate extra pages "
 			       "for large request.");
-			ttm_put_pages(pages, 0, flags, cstate, NULL);
+			ttm_put_pages(pages, 0, flags, cstate, dma_address,
+				      dev);
 			return r;
 		}
 	}
@@ -735,7 +736,8 @@ int __ttm_get_pages(struct list_head *pages, int flags,
 
 /* Put all pages in pages list to correct pool to wait for reuse */
 void __ttm_put_pages(struct list_head *pages, unsigned page_count, int flags,
-		     enum ttm_caching_state cstate, dma_addr_t *dma_address)
+		     enum ttm_caching_state cstate, dma_addr_t *dma_address,
+		     struct device *dev)
 {
 	unsigned long irq_flags;
 	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
@@ -867,19 +869,20 @@ struct ttm_page_alloc_func ttm_page_alloc_default = {
 
 int ttm_get_pages(struct list_head *pages, int flags,
 		  enum ttm_caching_state cstate, unsigned count,
-		  dma_addr_t *dma_address)
+		  dma_addr_t *dma_address, struct device *dev)
 {
 	if (ttm_page_alloc && ttm_page_alloc->get_pages)
 		return ttm_page_alloc->get_pages(pages, flags, cstate, count,
-						 dma_address);
+						 dma_address, dev);
 	return -1;
 }
 void ttm_put_pages(struct list_head *pages, unsigned page_count, int flags,
-		   enum ttm_caching_state cstate, dma_addr_t *dma_address)
+		   enum ttm_caching_state cstate, dma_addr_t *dma_address,
+		   struct device *dev)
 {
 	if (ttm_page_alloc && ttm_page_alloc->put_pages)
 		ttm_page_alloc->put_pages(pages, page_count, flags, cstate,
-					  dma_address);
+					  dma_address, dev);
 }
 int ttm_page_alloc_init(struct ttm_mem_global *glob, unsigned max_pages)
 {
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 58c271e..1f11a33 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -111,7 +111,7 @@ static struct page *__ttm_tt_get_page(struct ttm_tt *ttm, int index)
 		INIT_LIST_HEAD(&h);
 
 		ret = ttm_get_pages(&h, ttm->page_flags, ttm->caching_state, 1,
-				    &ttm->dma_address[index]);
+				    &ttm->dma_address[index], ttm->dev);
 
 		if (ret != 0)
 			return NULL;
@@ -305,7 +305,7 @@ static void ttm_tt_free_alloced_pages(struct ttm_tt *ttm)
 		}
 	}
 	ttm_put_pages(&h, count, ttm->page_flags, ttm->caching_state,
-		      ttm->dma_address);
+		      ttm->dma_address, ttm->dev);
 	ttm->state = tt_unpopulated;
 	ttm->first_himem_page = ttm->num_pages;
 	ttm->last_lomem_page = -1;
@@ -398,6 +398,7 @@ struct ttm_tt *ttm_tt_create(struct ttm_bo_device *bdev, unsigned long size,
 	ttm->last_lomem_page = -1;
 	ttm->caching_state = tt_cached;
 	ttm->page_flags = page_flags;
+	ttm->dev = bdev->dev;
 
 	ttm->dummy_read_page = dummy_read_page;
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 96949b9..d266ae7 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -322,11 +322,11 @@ static int vmw_driver_load(struct drm_device *dev, unsigned long chipset)
 	ttm_lock_set_kill(&dev_priv->fbdev_master.lock, false, SIGTERM);
 	dev_priv->active_master = &dev_priv->fbdev_master;
 
-
 	ret = ttm_bo_device_init(&dev_priv->bdev,
 				 dev_priv->bo_global_ref.ref.object,
 				 &vmw_bo_driver, VMWGFX_FILE_PAGE_OFFSET,
-				 false);
+				 false,
+				 dev->dev);
 	if (unlikely(ret != 0)) {
 		DRM_ERROR("Failed initializing TTM buffer object driver.\n");
 		goto out_err1;
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index 09af2d7..9a7ecae 100644
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
@@ -791,6 +793,8 @@ extern int ttm_bo_device_release(struct ttm_bo_device *bdev);
  * @file_page_offset: Offset into the device address space that is available
  * for buffer data. This ensures compatibility with other users of the
  * address space.
+ * @need_dma32: Allocate pages under 4GB
+ * @dev: 'struct device' of the PCI device.
  *
  * Initializes a struct ttm_bo_device:
  * Returns:
@@ -799,7 +803,8 @@ extern int ttm_bo_device_release(struct ttm_bo_device *bdev);
 extern int ttm_bo_device_init(struct ttm_bo_device *bdev,
 			      struct ttm_bo_global *glob,
 			      struct ttm_bo_driver *driver,
-			      uint64_t file_page_offset, bool need_dma32);
+			      uint64_t file_page_offset, bool need_dma32,
+			      struct device *dev);
 
 /**
  * ttm_bo_unmap_virtual
diff --git a/include/drm/ttm/ttm_page_alloc.h b/include/drm/ttm/ttm_page_alloc.h
index 6e8d73a..8fc92f2 100644
--- a/include/drm/ttm/ttm_page_alloc.h
+++ b/include/drm/ttm/ttm_page_alloc.h
@@ -39,12 +39,14 @@ struct ttm_page_alloc_func {
 	 * @cstate: ttm caching state for the page.
 	 * @count: number of pages to allocate.
 	 * @dma_address: The DMA (bus) address of pages (by default zero).
+	 * @dev: The device that needs this.
 	 */
 	int (*get_pages) (struct list_head *pages,
 			  int flags,
 			  enum ttm_caching_state cstate,
 			  unsigned count,
-			  dma_addr_t *dma_address);
+			  dma_addr_t *dma_address,
+			  struct device *dev);
 	/**
 	 * struct ttm_page_alloc_func member put_pages.
 	 *
@@ -56,12 +58,14 @@ struct ttm_page_alloc_func {
 	 * @flags: ttm flags for page allocation.
 	 * @cstate: ttm caching state.
 	 * @dma_address: The DMA (bus) address of pages (by default zero).
+	 * @dev: The device that needs this.
 	 */
 	void (*put_pages)(struct list_head *pages,
 			  unsigned page_count,
 			  int flags,
 			  enum ttm_caching_state cstate,
-			  dma_addr_t *dma_address);
+			  dma_addr_t *dma_address,
+			  struct device *dev);
 	/**
 	 * struct ttm_page_alloc_func member alloc_init.
 	 *
@@ -97,12 +101,14 @@ extern struct ttm_page_alloc_func ttm_page_alloc_default;
  * @cstate: ttm caching state for the page.
  * @count: number of pages to allocate.
  * @dma_address: The DMA (bus) address of pages - (by default zero).
+ * @dev: The device that needs this.
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
@@ -112,12 +118,14 @@ int ttm_get_pages(struct list_head *pages,
  * @flags: ttm flags for page allocation.
  * @cstate: ttm caching state.
  * @dma_address: The DMA (bus) address of pages (by default zero).
+ * @dev: The device that needs this.
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
1.7.4.1

