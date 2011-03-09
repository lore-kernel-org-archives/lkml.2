Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab1CIAtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:49:14 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:31349 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab1CIAtN (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 8 Mar 2011 19:49:13 -0500
Date: Tue, 8 Mar 2011 19:47:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Hellstrom <thomas@shipmail.org>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, Alex Deucher <alexdeucher@gmail.com>,
        Jerome Glisse <j.glisse@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH] cleanup: Add 'struct dev' in the TTM layer to be
 passed in for DMA API calls.
Message-ID: <20110309004718.GC10007@dumpdata.com>
References: <1299598789-20402-1-git-send-email-konrad.wilk@oracle.com>
 <4D769726.2030307@shipmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D769726.2030307@shipmail.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D76CE75.0091,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 09:52:54PM +0100, Thomas Hellstrom wrote:
> Hi, Konrad,
> 
> Is passing a struct device to the DMA api really *strictly* necessary?

It is allowed. As said, it is a cleanup patch so it can be dropped.
> 
> I'd like to avoid that at all cost, since we don't want pages that
> are backing buffer objects
> (coherent pages) to be associated with a specific device.

OK.
> 
> The reason for this is that we probably soon will want to move ttm
> buffer objects between devices, and that should ideally be a simple
> operation: If the memory type the buffer object currently resides in
> is not shared between two devices, then move it out to system memory
> and change its struct bo_device pointer.
> 
> If pages are associated with a specific device, this will become
> much harder. Basically we need to change backing pages and copy all
> the data.

<nods> Makes sense.

> 
> /Thomas
> 
> 
> On 03/08/2011 04:39 PM, Konrad Rzeszutek Wilk wrote:
> >These two patches are not strictly required but they do a bit of
> >cleanup and also fix a false reporting issue when the kernel is compiled
> >with CONFIG_DEBUG_DMA_API.
> >
> >Essentially the patchset modifies 'struct ttm_tt' and 'struct ttm_bo_device'
> >to contain a pointer to 'struct device'. Passing of the 'struct device'
> >is done via the 'tt_bo_device_init'. The 'struct device' is then used
> >during the allocation/deallocation of pages when TTM_PAGE_FLAG_DMA32 flag
> >is set.
> >
> >At first it seems that we would need to keep a copy of
> >'struct device' in the struct ttm_bo_device only and use that. However,
> >when 'ttm_tt_destroy' is called it sets ttm->be (which contains
> >the 'struct ttm_bo_device') to NULL so we cannot use it. Hence
> >we copy the 'struct device' pointer to the 'struct ttm_tm' and keep
> >it there.
> >
> >I've put the patches on:
> >
> >git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/ttm.pci-api.v5
> >
> >The testing was a bit difficult b/c I could not persuade the machine to unload
> >either the nouveau or radeon driver (I had a serial console hooked so I figured
> >it would fallback to that?). Ended up calling 'unbind' on the
> >/sys/pci/.../$BDF/driver/[radeon,nouveau] to trigger the de-allocation path.
> >
> >Thomas,
> >
> >What is the best way to test vmw-gfx*? Does the Workstation (5?) support
> >this particular frontend?
> >
> >Konrad Rzeszutek Wilk (2):
> >       ttm: Include the 'struct dev' when using the DMA API.
> >       ttm: Pass in 'struct device' to TTM so it can do DMA API on behalf of device.
> >
> >  drivers/gpu/drm/nouveau/nouveau_mem.c |    3 ++-
> >  drivers/gpu/drm/radeon/radeon_ttm.c   |    3 ++-
> >  drivers/gpu/drm/ttm/ttm_bo.c          |    4 +++-
> >  drivers/gpu/drm/ttm/ttm_page_alloc.c  |   11 ++++++-----
> >  drivers/gpu/drm/ttm/ttm_tt.c          |    5 +++--
> >  drivers/gpu/drm/vmwgfx/vmwgfx_drv.c   |    4 ++--
> >  include/drm/ttm/ttm_bo_driver.h       |    7 ++++++-
> >  include/drm/ttm/ttm_page_alloc.h      |    8 ++++++--
> >  8 files changed, 30 insertions(+), 15 deletions(-)
> >
> >
> >The full diff:
> >
> >diff --git a/drivers/gpu/drm/nouveau/nouveau_mem.c b/drivers/gpu/drm/nouveau/nouveau_mem.c
> >index 26347b7..3706156 100644
> >--- a/drivers/gpu/drm/nouveau/nouveau_mem.c
> >+++ b/drivers/gpu/drm/nouveau/nouveau_mem.c
> >@@ -412,7 +412,8 @@ nouveau_mem_vram_init(struct drm_device *dev)
> >  	ret = ttm_bo_device_init(&dev_priv->ttm.bdev,
> >  				 dev_priv->ttm.bo_global_ref.ref.object,
> >  				&nouveau_bo_driver, DRM_FILE_PAGE_OFFSET,
> >-				 dma_bits<= 32 ? true : false);
> >+				 dma_bits<= 32 ? true : false,
> >+				 dev->dev);
> >  	if (ret) {
> >  		NV_ERROR(dev, "Error initialising bo driver: %d\n", ret);
> >  		return ret;
> >diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
> >index 9ead11f..371890c 100644
> >--- a/drivers/gpu/drm/radeon/radeon_ttm.c
> >+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
> >@@ -517,7 +517,8 @@ int radeon_ttm_init(struct radeon_device *rdev)
> >  	r = ttm_bo_device_init(&rdev->mman.bdev,
> >  			       rdev->mman.bo_global_ref.ref.object,
> >  			&radeon_bo_driver, DRM_FILE_PAGE_OFFSET,
> >-			       rdev->need_dma32);
> >+			       rdev->need_dma32,
> >+			       rdev->dev);
> >  	if (r) {
> >  		DRM_ERROR("failed initializing buffer object driver(%d).\n", r);
> >  		return r;
> >diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
> >index af61fc2..278a2d3 100644
> >--- a/drivers/gpu/drm/ttm/ttm_bo.c
> >+++ b/drivers/gpu/drm/ttm/ttm_bo.c
> >@@ -1526,12 +1526,14 @@ int ttm_bo_device_init(struct ttm_bo_device *bdev,
> >  		       struct ttm_bo_global *glob,
> >  		       struct ttm_bo_driver *driver,
> >  		       uint64_t file_page_offset,
> >-		       bool need_dma32)
> >+		       bool need_dma32,
> >+		       struct device *dev)
> >  {
> >  	int ret = -EINVAL;
> >
> >  	rwlock_init(&bdev->vm_lock);
> >  	bdev->driver = driver;
> >+	bdev->dev = dev;
> >
> >  	memset(bdev->man, 0, sizeof(bdev->man));
> >
> >diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
> >index 737a2a2..35849db 100644
> >--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
> >+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
> >@@ -664,7 +664,7 @@ out:
> >   */
> >  int ttm_get_pages(struct list_head *pages, int flags,
> >  		  enum ttm_caching_state cstate, unsigned count,
> >-		  dma_addr_t *dma_address)
> >+		  dma_addr_t *dma_address, struct device *dev)
> >  {
> >  	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
> >  	struct page *p = NULL;
> >@@ -685,7 +685,7 @@ int ttm_get_pages(struct list_head *pages, int flags,
> >  		for (r = 0; r<  count; ++r) {
> >  			if ((flags&  TTM_PAGE_FLAG_DMA32)&&  dma_address) {
> >  				void *addr;
> >-				addr = dma_alloc_coherent(NULL, PAGE_SIZE,
> >+				addr = dma_alloc_coherent(dev, PAGE_SIZE,
> >  							&dma_address[r],
> >  							  gfp_flags);
> >  				if (addr == NULL)
> >@@ -730,7 +730,7 @@ int ttm_get_pages(struct list_head *pages, int flags,
> >  			printk(KERN_ERR TTM_PFX
> >  			       "Failed to allocate extra pages "
> >  			       "for large request.");
> >-			ttm_put_pages(pages, 0, flags, cstate, NULL);
> >+			ttm_put_pages(pages, 0, flags, cstate, NULL, NULL);
> >  			return r;
> >  		}
> >  	}
> >@@ -741,7 +741,8 @@ int ttm_get_pages(struct list_head *pages, int flags,
> >
> >  /* Put all pages in pages list to correct pool to wait for reuse */
> >  void ttm_put_pages(struct list_head *pages, unsigned page_count, int flags,
> >-		   enum ttm_caching_state cstate, dma_addr_t *dma_address)
> >+		   enum ttm_caching_state cstate, dma_addr_t *dma_address,
> >+		   struct device *dev)
> >  {
> >  	unsigned long irq_flags;
> >  	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
> >@@ -757,7 +758,7 @@ void ttm_put_pages(struct list_head *pages, unsigned page_count, int flags,
> >  				void *addr = page_address(p);
> >  				WARN_ON(!addr || !dma_address[r]);
> >  				if (addr)
> >-					dma_free_coherent(NULL, PAGE_SIZE,
> >+					dma_free_coherent(dev, PAGE_SIZE,
> >  							  addr,
> >  							  dma_address[r]);
> >  				dma_address[r] = 0;
> >diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
> >index 86d5b17..354f9d9 100644
> >--- a/drivers/gpu/drm/ttm/ttm_tt.c
> >+++ b/drivers/gpu/drm/ttm/ttm_tt.c
> >@@ -110,7 +110,7 @@ static struct page *__ttm_tt_get_page(struct ttm_tt *ttm, int index)
> >  		INIT_LIST_HEAD(&h);
> >
> >  		ret = ttm_get_pages(&h, ttm->page_flags, ttm->caching_state, 1,
> >-				&ttm->dma_address[index]);
> >+				&ttm->dma_address[index], ttm->dev);
> >
> >  		if (ret != 0)
> >  			return NULL;
> >@@ -304,7 +304,7 @@ static void ttm_tt_free_alloced_pages(struct ttm_tt *ttm)
> >  		}
> >  	}
> >  	ttm_put_pages(&h, count, ttm->page_flags, ttm->caching_state,
> >-		      ttm->dma_address);
> >+		      ttm->dma_address, ttm->dev);
> >  	ttm->state = tt_unpopulated;
> >  	ttm->first_himem_page = ttm->num_pages;
> >  	ttm->last_lomem_page = -1;
> >@@ -397,6 +397,7 @@ struct ttm_tt *ttm_tt_create(struct ttm_bo_device *bdev, unsigned long size,
> >  	ttm->last_lomem_page = -1;
> >  	ttm->caching_state = tt_cached;
> >  	ttm->page_flags = page_flags;
> >+	ttm->dev = bdev->dev;
> >
> >  	ttm->dummy_read_page = dummy_read_page;
> >
> >diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> >index 10ca97e..803d979 100644
> >--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> >+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> >@@ -322,11 +322,11 @@ static int vmw_driver_load(struct drm_device *dev, unsigned long chipset)
> >  	ttm_lock_set_kill(&dev_priv->fbdev_master.lock, false, SIGTERM);
> >  	dev_priv->active_master =&dev_priv->fbdev_master;
> >
> >-
> >  	ret = ttm_bo_device_init(&dev_priv->bdev,
> >  				 dev_priv->bo_global_ref.ref.object,
> >  				&vmw_bo_driver, VMWGFX_FILE_PAGE_OFFSET,
> >-				 false);
> >+				 false,
> >+				 dev->dev);
> >  	if (unlikely(ret != 0)) {
> >  		DRM_ERROR("Failed initializing TTM buffer object driver.\n");
> >  		goto out_err1;
> >diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
> >index efed082..2024a74 100644
> >--- a/include/drm/ttm/ttm_bo_driver.h
> >+++ b/include/drm/ttm/ttm_bo_driver.h
> >@@ -177,6 +177,7 @@ struct ttm_tt {
> >  		tt_unpopulated,
> >  	} state;
> >  	dma_addr_t *dma_address;
> >+	struct device *dev;
> >  };
> >
> >  #define TTM_MEMTYPE_FLAG_FIXED         (1<<  0)	/* Fixed (on-card) PCI memory */
> >@@ -551,6 +552,7 @@ struct ttm_bo_device {
> >  	struct list_head device_list;
> >  	struct ttm_bo_global *glob;
> >  	struct ttm_bo_driver *driver;
> >+	struct device *dev;
> >  	rwlock_t vm_lock;
> >  	struct ttm_mem_type_manager man[TTM_NUM_MEM_TYPES];
> >  	spinlock_t fence_lock;
> >@@ -791,6 +793,8 @@ extern int ttm_bo_device_release(struct ttm_bo_device *bdev);
> >   * @file_page_offset: Offset into the device address space that is available
> >   * for buffer data. This ensures compatibility with other users of the
> >   * address space.
> >+ * @need_dma32: Allocate pages under 4GB
> >+ * @dev: 'struct device' of the PCI device.
> >   *
> >   * Initializes a struct ttm_bo_device:
> >   * Returns:
> >@@ -799,7 +803,8 @@ extern int ttm_bo_device_release(struct ttm_bo_device *bdev);
> >  extern int ttm_bo_device_init(struct ttm_bo_device *bdev,
> >  			      struct ttm_bo_global *glob,
> >  			      struct ttm_bo_driver *driver,
> >-			      uint64_t file_page_offset, bool need_dma32);
> >+			      uint64_t file_page_offset, bool need_dma32,
> >+			      struct device *dev);
> >
> >  /**
> >   * ttm_bo_unmap_virtual
> >diff --git a/include/drm/ttm/ttm_page_alloc.h b/include/drm/ttm/ttm_page_alloc.h
> >index 8062890..ccb6b7a 100644
> >--- a/include/drm/ttm/ttm_page_alloc.h
> >+++ b/include/drm/ttm/ttm_page_alloc.h
> >@@ -37,12 +37,14 @@
> >   * @cstate: ttm caching state for the page.
> >   * @count: number of pages to allocate.
> >   * @dma_address: The DMA (bus) address of pages (if TTM_PAGE_FLAG_DMA32 set).
> >+ * @dev: struct device for appropiate DMA accounting.
> >   */
> >  int ttm_get_pages(struct list_head *pages,
> >  		  int flags,
> >  		  enum ttm_caching_state cstate,
> >  		  unsigned count,
> >-		  dma_addr_t *dma_address);
> >+		  dma_addr_t *dma_address,
> >+		  struct device *dev);
> >  /**
> >   * Put linked list of pages to pool.
> >   *
> >@@ -52,12 +54,14 @@ int ttm_get_pages(struct list_head *pages,
> >   * @flags: ttm flags for page allocation.
> >   * @cstate: ttm caching state.
> >   * @dma_address: The DMA (bus) address of pages (if TTM_PAGE_FLAG_DMA32 set).
> >+ * @dev: struct device for appropiate DMA accounting.
> >   */
> >  void ttm_put_pages(struct list_head *pages,
> >  		   unsigned page_count,
> >  		   int flags,
> >  		   enum ttm_caching_state cstate,
> >-		   dma_addr_t *dma_address);
> >+		   dma_addr_t *dma_address,
> >+		   struct device *dev);
> >  /**
> >   * Initialize pool allocator.
> >   */
