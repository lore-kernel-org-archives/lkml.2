Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1DSOst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:48:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52970 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752422Ab1DSOsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:48:47 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 3/8] gma500: Add support for inserting and removing pages from
 the GART
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 19 Apr 2011 15:27:43 +0100
Message-ID: <20110419142733.16479.26838.stgit@localhost.localdomain>
In-Reply-To: <20110419142432.16479.89255.stgit@localhost.localdomain>
References: <20110419142432.16479.89255.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two chunks of code we need to do this. The first one is the code
to insert and remove the pages from the GART, the second is the code to build
page table lists from the GEM object. Surprisingly this latter one doesn't seem
to have a nice GEM helper.

While we are at it we can begin dismantling the semi redundant struct pg,
and finish pruning out the old now unused gtt code as well as the last bits
of helper glue from the old driver base.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile            |    1 
 drivers/staging/gma500/psb_drv.c           |   24 -
 drivers/staging/gma500/psb_drv.h           |    7 
 drivers/staging/gma500/psb_fb.c            |   34 -
 drivers/staging/gma500/psb_gtt.c           | 1108 ++++++++--------------------
 drivers/staging/gma500/psb_gtt.h           |   52 -
 drivers/staging/gma500/psb_intel_display.c |    7 
 drivers/staging/gma500/psb_powermgmt.c     |    5 
 drivers/staging/gma500/psb_pvr_glue.c      |   73 --
 drivers/staging/gma500/psb_pvr_glue.h      |   25 -
 10 files changed, 338 insertions(+), 998 deletions(-)
 delete mode 100644 drivers/staging/gma500/psb_pvr_glue.c
 delete mode 100644 drivers/staging/gma500/psb_pvr_glue.h

diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index 0c4f7b6..db73ec6 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -17,7 +17,6 @@ psb_gfx-y += psb_bl.o \
 	  psb_intel_modes.o \
 	  psb_intel_sdvo.o \
 	  psb_lid.o \
-	  psb_pvr_glue.o \
 	  psb_mmu.o \
 	  psb_powermgmt.o \
 	  psb_irq.o \
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index d871061..f501cd7 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -499,15 +499,15 @@ static int psb_driver_unload(struct drm_device *dev)
 
 			down_read(&pg->sem);
 			psb_mmu_remove_pfn_sequence(
-					psb_mmu_get_default_pd
-					(dev_priv->mmu),
-					pg->mmu_gatt_start,
-					pg->vram_stolen_size >> PAGE_SHIFT);
+				psb_mmu_get_default_pd
+				(dev_priv->mmu),
+				pg->mmu_gatt_start,
+				dev_priv->vram_stolen_size >> PAGE_SHIFT);
 			up_read(&pg->sem);
 			psb_mmu_driver_takedown(dev_priv->mmu);
 			dev_priv->mmu = NULL;
 		}
-		psb_gtt_takedown(dev_priv->pg, 1);
+		psb_gtt_takedown(dev);
 		if (dev_priv->scratch_page) {
 			__free_page(dev_priv->scratch_page);
 			dev_priv->scratch_page = NULL;
@@ -592,15 +592,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 
 	set_pages_uc(dev_priv->scratch_page, 1);
 
-	dev_priv->pg = psb_gtt_alloc(dev);
-	if (!dev_priv->pg)
-		goto out_err;
-
-	ret = psb_gtt_init(dev_priv->pg, 0);
-	if (ret)
-		goto out_err;
-
-	ret = psb_gtt_mm_init(dev_priv->pg);
+	ret = psb_gtt_init(dev, 0);
 	if (ret)
 		goto out_err;
 
@@ -955,8 +947,8 @@ static int psb_stolen_memory_ioctl(struct drm_device *dev, void *data,
 	struct drm_psb_private *dev_priv = psb_priv(dev);
 	struct drm_psb_stolen_memory_arg *arg = data;
 
-	arg->base = dev_priv->pg->stolen_base;
-	arg->size = dev_priv->pg->vram_stolen_size;
+	arg->base = dev_priv->stolen_base;
+	arg->size = dev_priv->vram_stolen_size;
 
 	return 0;
 }
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index aa68ae7..4c983ff 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -240,6 +240,13 @@ struct drm_psb_private {
 	/* GTT Memory manager */
 	struct psb_gtt_mm *gtt_mm;
 	struct page *scratch_page;
+	u32 *gtt_map;
+	uint32_t stolen_base;
+	void *vram_addr;
+	unsigned long vram_stolen_size;
+	int gtt_initialized;
+	u16 gmch_ctrl;		/* Saved GTT setup */
+	u32 pge_ctl;
 
 	struct mutex gtt_mutex;
 	struct resource *gtt_mem;	/* Our PCI resource */
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index ffbbbb6..eaf960e 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -37,7 +37,6 @@
 #include "psb_intel_reg.h"
 #include "psb_intel_drv.h"
 #include "psb_fb.h"
-#include "psb_pvr_glue.h"
 
 static void psb_user_framebuffer_destroy(struct drm_framebuffer *fb);
 static int psb_user_framebuffer_create_handle(struct drm_framebuffer *fb,
@@ -191,8 +190,7 @@ static int psbfb_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct psb_framebuffer *psbfb = vma->vm_private_data;
 	struct drm_device *dev = psbfb->base.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct psb_gtt *pg = dev_priv->pg;
-	unsigned long phys_addr = (unsigned long)pg->stolen_base;
+	unsigned long phys_addr = (unsigned long)dev_priv->stolen_base;
 
 	page_num = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 
@@ -241,7 +239,6 @@ static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 	char *fb_screen_base = NULL;
 	struct drm_device *dev = psbfb->base.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct psb_gtt *pg = dev_priv->pg;
 
 	if (vma->vm_pgoff != 0)
 		return -EINVAL;
@@ -254,10 +251,11 @@ static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 	fb_screen_base = (char *)info->screen_base;
 
 	DRM_DEBUG("vm_pgoff 0x%lx, screen base %p vram_addr %p\n",
-				vma->vm_pgoff, fb_screen_base, pg->vram_addr);
+				vma->vm_pgoff, fb_screen_base,
+                                dev_priv->vram_addr);
 
         /* FIXME: ultimately this needs to become 'if entirely stolen memory' */
-	if (1 || fb_screen_base == pg->vram_addr) {
+	if (1 || fb_screen_base == dev_priv->vram_addr) {
 		vma->vm_ops = &psbfb_vm_ops;
 		vma->vm_private_data = (void *)psbfb;
 		vma->vm_flags |= VM_RESERVED | VM_IO |
@@ -349,7 +347,6 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 {
 	struct drm_device *dev = fbdev->psb_fb_helper.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct psb_gtt *pg = dev_priv->pg;
 	struct fb_info *info;
 	struct drm_framebuffer *fb;
 	struct psb_framebuffer *psbfb;
@@ -409,7 +406,7 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	/* Accessed via stolen memory directly, This only works for stolem
 	   memory however. Need to address this once we start using gtt
 	   pages we allocate */
-	info->screen_base = (char *)pg->vram_addr + backing->offset;
+	info->screen_base = (char *)dev_priv->vram_addr + backing->offset;
 	info->screen_size = size;
 	memset(info->screen_base, 0, size);
 
@@ -735,32 +732,19 @@ static void psb_setup_outputs(struct drm_device *dev)
 	}
 }
 
+/* FIXME: rewrite these in terms of the gtt_range and GEM objects
+   rather than faking them as we do now */
+
 static void *psb_bo_from_handle(struct drm_device *dev,
 				struct drm_file *file_priv,
 				unsigned int handle)
 {
-	void *psKernelMemInfo = NULL;
-	void * hKernelMemInfo = (void *)handle;
-	int ret;
-
-	ret = psb_get_meminfo_by_handle(hKernelMemInfo, &psKernelMemInfo);
-	if (ret) {
-		DRM_ERROR("Cannot get meminfo for handle 0x%x\n",
-			  (u32)hKernelMemInfo);
-		return NULL;
-	}
-
-	return (void *)psKernelMemInfo;
+	return NULL;
 }
 
 static size_t psb_bo_size(struct drm_device *dev, void *bof)
 {
-#if 0
-	void *psKernelMemInfo	= (void *)bof;
-	return (size_t)psKernelMemInfo->ui32AllocSize;
-#else
 	return 0;
-#endif
 }
 
 static size_t psb_bo_offset(struct drm_device *dev, void *bof)
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 4846fef..090d30e 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -16,12 +16,24 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  *
  * Authors: Thomas Hellstrom <thomas-at-tungstengraphics.com>
+ *	    Alan Cox <alan@linux.intel.com>
  */
 
 #include <drm/drmP.h>
 #include "psb_drv.h"
-#include "psb_pvr_glue.h"
 
+
+/*
+ *	GTT resource allocator - manage page mappings in GTT space
+ */
+
+/**
+ *	psb_gtt_mask_pte	-	generate GART pte entry
+ *	@pfn: page number to encode
+ *	@type: type of memory in the GART
+ *
+ *	Set the GART entry for the appropriate memory type.
+ */
 static inline uint32_t psb_gtt_mask_pte(uint32_t pfn, int type)
 {
 	uint32_t mask = PSB_PTE_VALID;
@@ -36,854 +48,162 @@ static inline uint32_t psb_gtt_mask_pte(uint32_t pfn, int type)
 	return (pfn << PAGE_SHIFT) | mask;
 }
 
-struct psb_gtt *psb_gtt_alloc(struct drm_device *dev)
-{
-	struct psb_gtt *tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
-
-	if (!tmp)
-		return NULL;
-
-	init_rwsem(&tmp->sem);
-	tmp->dev = dev;
-
-	return tmp;
-}
-
-void psb_gtt_takedown(struct psb_gtt *pg, int free)
-{
-	struct drm_psb_private *dev_priv = pg->dev->dev_private;
-
-	if (!pg)
-		return;
-
-	if (pg->gtt_map) {
-		iounmap(pg->gtt_map);
-		pg->gtt_map = NULL;
-	}
-	if (pg->initialized) {
-		pci_write_config_word(pg->dev->pdev, PSB_GMCH_CTRL,
-				      pg->gmch_ctrl);
-		PSB_WVDC32(pg->pge_ctl, PSB_PGETBL_CTL);
-		(void) PSB_RVDC32(PSB_PGETBL_CTL);
-	}
-	if (free)
-		kfree(pg);
-}
-
-int psb_gtt_init(struct psb_gtt *pg, int resume)
-{
-	struct drm_device *dev = pg->dev;
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	unsigned gtt_pages;
-	unsigned long stolen_size, vram_stolen_size;
-	unsigned i, num_pages;
-	unsigned pfn_base;
-	uint32_t vram_pages;
-	uint32_t tt_pages;
-	uint32_t *ttm_gtt_map;
-	uint32_t dvmt_mode = 0;
-
-	int ret = 0;
-	uint32_t pte;
-
-	pci_read_config_word(dev->pdev, PSB_GMCH_CTRL, &pg->gmch_ctrl);
-	pci_write_config_word(dev->pdev, PSB_GMCH_CTRL,
-			      pg->gmch_ctrl | _PSB_GMCH_ENABLED);
-
-	pg->pge_ctl = PSB_RVDC32(PSB_PGETBL_CTL);
-	PSB_WVDC32(pg->pge_ctl | _PSB_PGETBL_ENABLED, PSB_PGETBL_CTL);
-	(void) PSB_RVDC32(PSB_PGETBL_CTL);
-
-	/* The root resource we allocate address space from */
-	dev_priv->gtt_mem = &dev->pdev->resource[PSB_GATT_RESOURCE];
-
-	pg->initialized = 1;
-	pg->gtt_phys_start = pg->pge_ctl & PAGE_MASK;
-
-	pg->gatt_start = pci_resource_start(dev->pdev, PSB_GATT_RESOURCE);
-	/* fix me: video mmu has hw bug to access 0x0D0000000,
-	 * then make gatt start at 0x0e000,0000 */
-	pg->mmu_gatt_start = 0xE0000000;
-	pg->gtt_start = pci_resource_start(dev->pdev, PSB_GTT_RESOURCE);
-	gtt_pages =
-	    pci_resource_len(dev->pdev, PSB_GTT_RESOURCE) >> PAGE_SHIFT;
-	pg->gatt_pages = pci_resource_len(dev->pdev, PSB_GATT_RESOURCE)
-	    >> PAGE_SHIFT;
-
-	pci_read_config_dword(dev->pdev, PSB_BSM, &pg->stolen_base);
-	vram_stolen_size = pg->gtt_phys_start - pg->stolen_base - PAGE_SIZE;
-
-	stolen_size = vram_stolen_size;
-
-	printk(KERN_INFO"GMMADR(region 0) start: 0x%08x (%dM).\n",
-		pg->gatt_start, pg->gatt_pages/256);
-	printk(KERN_INFO"GTTADR(region 3) start: 0x%08x (can map %dM RAM), and actual RAM base 0x%08x.\n",
-		pg->gtt_start, gtt_pages * 4, pg->gtt_phys_start);
-	printk(KERN_INFO "Stolen memory information\n");
-	printk(KERN_INFO "       base in RAM: 0x%x\n", pg->stolen_base);
-	printk(KERN_INFO "       size: %luK, calculated by (GTT RAM base) - (Stolen base), seems wrong\n",
-		vram_stolen_size/1024);
-	dvmt_mode = (pg->gmch_ctrl >> 4) & 0x7;
-	printk(KERN_INFO "      the correct size should be: %dM(dvmt mode=%d)\n",
-		(dvmt_mode == 1) ? 1 : (2 << (dvmt_mode - 1)), dvmt_mode);
-
-	if (resume && (gtt_pages != pg->gtt_pages) &&
-	    (stolen_size != pg->stolen_size)) {
-		DRM_ERROR("GTT resume error.\n");
-		ret = -EINVAL;
-		goto out_err;
-	}
-
-	pg->gtt_pages = gtt_pages;
-	pg->stolen_size = stolen_size;
-	pg->vram_stolen_size = vram_stolen_size;
-	pg->gtt_map =
-	    ioremap_nocache(pg->gtt_phys_start, gtt_pages << PAGE_SHIFT);
-	if (!pg->gtt_map) {
-		DRM_ERROR("Failure to map gtt.\n");
-		ret = -ENOMEM;
-		goto out_err;
-	}
-
-	pg->vram_addr = ioremap_wc(pg->stolen_base, stolen_size);
-	if (!pg->vram_addr) {
-		DRM_ERROR("Failure to map stolen base.\n");
-		ret = -ENOMEM;
-		goto out_err;
-	}
-
-	DRM_DEBUG("%s: vram kernel virtual address %p\n", pg->vram_addr);
-
-	tt_pages = (pg->gatt_pages < PSB_TT_PRIV0_PLIMIT) ?
-		(pg->gatt_pages) : PSB_TT_PRIV0_PLIMIT;
-
-	ttm_gtt_map = pg->gtt_map + tt_pages / 2;
-
-	/*
-	 * insert vram stolen pages.
-	 */
-
-	pfn_base = pg->stolen_base >> PAGE_SHIFT;
-	vram_pages = num_pages = vram_stolen_size >> PAGE_SHIFT;
-	printk(KERN_INFO"Set up %d stolen pages starting at 0x%08x, GTT offset %dK\n",
-		num_pages, pfn_base, 0);
-	for (i = 0; i < num_pages; ++i) {
-		pte = psb_gtt_mask_pte(pfn_base + i, 0);
-		iowrite32(pte, pg->gtt_map + i);
-	}
-
-	/*
-	 * Init rest of gtt managed by IMG.
-	 */
-	pfn_base = page_to_pfn(dev_priv->scratch_page);
-	pte = psb_gtt_mask_pte(pfn_base, 0);
-	for (; i < tt_pages / 2 - 1; ++i)
-		iowrite32(pte, pg->gtt_map + i);
-
-	/*
-	 * Init rest of gtt managed by TTM.
-	 */
-
-	pfn_base = page_to_pfn(dev_priv->scratch_page);
-	pte = psb_gtt_mask_pte(pfn_base, 0);
-	PSB_DEBUG_INIT("Initializing the rest of a total "
-		       "of %d gtt pages.\n", pg->gatt_pages);
-
-	for (; i < pg->gatt_pages - tt_pages / 2; ++i)
-		iowrite32(pte, ttm_gtt_map + i);
-	(void) ioread32(pg->gtt_map + i - 1);
-
-	return 0;
-
-out_err:
-	psb_gtt_takedown(pg, 0);
-	return ret;
-}
-
-int psb_gtt_insert_pages(struct psb_gtt *pg, struct page **pages,
-			 unsigned offset_pages, unsigned num_pages,
-			 unsigned desired_tile_stride,
-			 unsigned hw_tile_stride, int type)
-{
-	unsigned rows = 1;
-	unsigned add;
-	unsigned row_add;
-	unsigned i;
-	unsigned j;
-	uint32_t *cur_page = NULL;
-	uint32_t pte;
-
-	if (hw_tile_stride)
-		rows = num_pages / desired_tile_stride;
-	else
-		desired_tile_stride = num_pages;
-
-	add = desired_tile_stride;
-	row_add = hw_tile_stride;
-
-	down_read(&pg->sem);
-	for (i = 0; i < rows; ++i) {
-		cur_page = pg->gtt_map + offset_pages;
-		for (j = 0; j < desired_tile_stride; ++j) {
-			pte =
-			    psb_gtt_mask_pte(page_to_pfn(*pages++), type);
-			iowrite32(pte, cur_page++);
-		}
-		offset_pages += add;
-	}
-	(void) ioread32(cur_page - 1);
-	up_read(&pg->sem);
-
-	return 0;
-}
-
-int psb_gtt_insert_phys_addresses(struct psb_gtt *pg, dma_addr_t *pPhysFrames,
-			unsigned offset_pages, unsigned num_pages, int type)
-{
-	unsigned j;
-	uint32_t *cur_page = NULL;
-	uint32_t pte;
-	u32 ba;
-
-	down_read(&pg->sem);
-	cur_page = pg->gtt_map + offset_pages;
-	for (j = 0; j < num_pages; ++j) {
-		ba = *pPhysFrames++;
-		pte =  psb_gtt_mask_pte(ba >> PAGE_SHIFT, type);
-		iowrite32(pte, cur_page++);
-	}
-	(void) ioread32(cur_page - 1);
-	up_read(&pg->sem);
-	return 0;
-}
-
-int psb_gtt_remove_pages(struct psb_gtt *pg, unsigned offset_pages,
-			 unsigned num_pages, unsigned desired_tile_stride,
-			 unsigned hw_tile_stride, int rc_prot)
-{
-	struct drm_psb_private *dev_priv = pg->dev->dev_private;
-	unsigned rows = 1;
-	unsigned add;
-	unsigned row_add;
-	unsigned i;
-	unsigned j;
-	uint32_t *cur_page = NULL;
-	unsigned pfn_base = page_to_pfn(dev_priv->scratch_page);
-	uint32_t pte = psb_gtt_mask_pte(pfn_base, 0);
-
-	if (hw_tile_stride)
-		rows = num_pages / desired_tile_stride;
-	else
-		desired_tile_stride = num_pages;
-
-	add = desired_tile_stride;
-	row_add = hw_tile_stride;
-
-	if (rc_prot)
-		down_read(&pg->sem);
-	for (i = 0; i < rows; ++i) {
-		cur_page = pg->gtt_map + offset_pages;
-		for (j = 0; j < desired_tile_stride; ++j)
-			iowrite32(pte, cur_page++);
-
-		offset_pages += add;
-	}
-	(void) ioread32(cur_page - 1);
-	if (rc_prot)
-		up_read(&pg->sem);
-
-	return 0;
-}
-
-int psb_gtt_mm_init(struct psb_gtt *pg)
-{
-	struct psb_gtt_mm *gtt_mm;
-	struct drm_psb_private *dev_priv = pg->dev->dev_private;
-	struct drm_open_hash *ht;
-	struct drm_mm *mm;
-	int ret;
-	uint32_t tt_start;
-	uint32_t tt_size;
-
-	if (!pg || !pg->initialized) {
-		DRM_DEBUG("Invalid gtt struct\n");
-		return -EINVAL;
-	}
-
-	gtt_mm =  kzalloc(sizeof(struct psb_gtt_mm), GFP_KERNEL);
-	if (!gtt_mm)
-		return -ENOMEM;
-
-	spin_lock_init(&gtt_mm->lock);
-
-	ht = &gtt_mm->hash;
-	ret = drm_ht_create(ht, 20);
-	if (ret) {
-		DRM_DEBUG("Create hash table failed(%d)\n", ret);
-		goto err_free;
-	}
-
-	tt_start = (pg->stolen_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	tt_start = (tt_start < pg->gatt_pages) ? tt_start : pg->gatt_pages;
-	tt_size = (pg->gatt_pages < PSB_TT_PRIV0_PLIMIT) ?
-			(pg->gatt_pages) : PSB_TT_PRIV0_PLIMIT;
-
-	mm = &gtt_mm->base;
-
-	/*will use tt_start ~ 128M for IMG TT buffers*/
-	ret = drm_mm_init(mm, tt_start, ((tt_size / 2) - tt_start));
-	if (ret) {
-		DRM_DEBUG("drm_mm_int error(%d)\n", ret);
-		goto err_mm_init;
-	}
-
-	gtt_mm->count = 0;
-
-	dev_priv->gtt_mm = gtt_mm;
-
-	DRM_INFO("PSB GTT mem manager ready, tt_start %ld, tt_size %ld pages\n",
-		(unsigned long)tt_start,
-		(unsigned long)((tt_size / 2) - tt_start));
-	return 0;
-err_mm_init:
-	drm_ht_remove(ht);
-
-err_free:
-	kfree(gtt_mm);
-	return ret;
-}
-
 /**
- * Delete all hash entries;
+ *	psb_gtt_entry		-	find the GART entries for a gtt_range
+ *	@dev: our DRM device
+ *	@r: our GTT range
+ * 
+ *	Given a gtt_range object return the GART offset of the page table
+ *	entries for this gtt_range
  */
-void psb_gtt_mm_takedown(void)
-{
-	return;
-}
-
-static int psb_gtt_mm_get_ht_by_pid_locked(struct psb_gtt_mm *mm,
-				    u32 tgid,
-				    struct psb_gtt_hash_entry **hentry)
+u32 *psb_gtt_entry(struct drm_device *dev, struct gtt_range *r)
 {
-	struct drm_hash_item *entry;
-	struct psb_gtt_hash_entry *psb_entry;
-	int ret;
-
-	ret = drm_ht_find_item(&mm->hash, tgid, &entry);
-	if (ret) {
-		DRM_DEBUG("Cannot find entry pid=%ld\n", tgid);
-		return ret;
-	}
+        struct drm_psb_private *dev_priv = dev->dev_private;
+	unsigned long offset;
 
-	psb_entry = container_of(entry, struct psb_gtt_hash_entry, item);
-	if (!psb_entry) {
-		DRM_DEBUG("Invalid entry");
-		return -EINVAL;
-	}
+	offset = r->resource.start - dev_priv->gtt_mem->start;
 
-	*hentry = psb_entry;
-	return 0;
+	return dev_priv->gtt_map + (offset >> PAGE_SHIFT);
 }
 
 
-static int psb_gtt_mm_insert_ht_locked(struct psb_gtt_mm *mm,
-				       u32 tgid,
-				       struct psb_gtt_hash_entry *hentry)
-{
-	struct drm_hash_item *item;
-	int ret;
-
-	if (!hentry) {
-		DRM_DEBUG("Invalid parameters\n");
-		return -EINVAL;
-	}
-
-	item = &hentry->item;
-	item->key = tgid;
-
-	/**
-	 * NOTE: drm_ht_insert_item will perform such a check
-	ret = psb_gtt_mm_get_ht_by_pid(mm, tgid, &tmp);
-	if (!ret) {
-		DRM_DEBUG("Entry already exists for pid %ld\n", tgid);
-		return -EAGAIN;
-	}
-	*/
-
-	/*Insert the given entry*/
-	ret = drm_ht_insert_item(&mm->hash, item);
-	if (ret) {
-		DRM_DEBUG("Insert failure\n");
-		return ret;
-	}
-
-	mm->count++;
-
-	return 0;
-}
-
-static int psb_gtt_mm_alloc_insert_ht(struct psb_gtt_mm *mm,
-				      u32 tgid,
-				      struct psb_gtt_hash_entry **entry)
+/**
+ *	psb_gtt_insert	-	put an object into the GART
+ *	@dev: our DRM device
+ *	@r: our GTT range
+ *
+ *	Take our preallocated GTT range and insert the GEM object into
+ *	the GART.
+ *
+ *	FIXME: gtt lock ?
+ */
+int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 {
-	struct psb_gtt_hash_entry *hentry;
-	int ret;
+	u32 *gtt_slot, pte;
+	int numpages = (r->resource.end + 1 - r->resource.start) >> PAGE_SHIFT;
+	struct page **pages;
+	int i;
 
-	/*if the hentry for this tgid exists, just get it and return*/
-	spin_lock(&mm->lock);
-	ret = psb_gtt_mm_get_ht_by_pid_locked(mm, tgid, &hentry);
-	if (!ret) {
-		DRM_DEBUG("Entry for tgid %ld exist, hentry %p\n",
-			  tgid, hentry);
-		*entry = hentry;
-		spin_unlock(&mm->lock);
+	if (r->stolen)
 		return 0;
-	}
-	spin_unlock(&mm->lock);
-
-	DRM_DEBUG("Entry for tgid %ld doesn't exist, will create it\n", tgid);
-
-	hentry = kzalloc(sizeof(struct psb_gtt_hash_entry), GFP_KERNEL);
-	if (!hentry) {
-		DRM_DEBUG("Kmalloc failled\n");
-		return -ENOMEM;
-	}
-
-	ret = drm_ht_create(&hentry->ht, 20);
-	if (ret) {
-		DRM_DEBUG("Create hash table failed\n");
-		return ret;
-	}
-
-	spin_lock(&mm->lock);
-	ret = psb_gtt_mm_insert_ht_locked(mm, tgid, hentry);
-	spin_unlock(&mm->lock);
-
-	if (!ret)
-		*entry = hentry;
-
-	return ret;
-}
-
-static struct psb_gtt_hash_entry *
-psb_gtt_mm_remove_ht_locked(struct psb_gtt_mm *mm, u32 tgid)
-{
-	struct psb_gtt_hash_entry *tmp;
-	int ret;
-
-	ret = psb_gtt_mm_get_ht_by_pid_locked(mm, tgid, &tmp);
-	if (ret) {
-		DRM_DEBUG("Cannot find entry pid %ld\n", tgid);
-		return NULL;
-	}
-
-	/*remove it from ht*/
-	drm_ht_remove_item(&mm->hash, &tmp->item);
-
-	mm->count--;
-
-	return tmp;
-}
-
-static int psb_gtt_mm_remove_free_ht_locked(struct psb_gtt_mm *mm, u32 tgid)
-{
-	struct psb_gtt_hash_entry *entry;
-
-	entry = psb_gtt_mm_remove_ht_locked(mm, tgid);
-
-	if (!entry) {
-		DRM_DEBUG("Invalid entry");
+	if (r->pages == NULL) {
+		WARN_ON(1);
 		return -EINVAL;
 	}
 
-	/*delete ht*/
-	drm_ht_remove(&entry->ht);
+	WARN_ON(r->in_gart);	/* refcount these maybe ? */
 
-	/*free this entry*/
-	kfree(entry);
-	return 0;
-}
+	gtt_slot = psb_gtt_entry(dev, r);
+	pages = r->pages;
 
-static int
-psb_gtt_mm_get_mem_mapping_locked(struct drm_open_hash *ht,
-			   u32 key,
-			   struct psb_gtt_mem_mapping **hentry)
-{
-	struct drm_hash_item *entry;
-	struct psb_gtt_mem_mapping *mapping;
-	int ret;
-
-	ret = drm_ht_find_item(ht, key, &entry);
-	if (ret) {
-		DRM_DEBUG("Cannot find key %ld\n", key);
-		return ret;
+	/* Write our page entries into the GART itself */
+	for (i = 0; i < numpages; i++) {
+		pte = psb_gtt_mask_pte(page_to_pfn(*pages++), 0/*type*/);
+		iowrite32(pte, gtt_slot++);
 	}
-
-	mapping =  container_of(entry, struct psb_gtt_mem_mapping, item);
-	if (!mapping) {
-		DRM_DEBUG("Invalid entry\n");
-		return -EINVAL;
-	}
-
-	*hentry = mapping;
-	return 0;
-}
-
-static int
-psb_gtt_mm_insert_mem_mapping_locked(struct drm_open_hash *ht,
-			      u32 key,
-			      struct psb_gtt_mem_mapping *hentry)
-{
-	struct drm_hash_item *item;
-	struct psb_gtt_hash_entry *entry;
-	int ret;
-
-	if (!hentry) {
-		DRM_DEBUG("hentry is NULL\n");
-		return -EINVAL;
-	}
-
-	item = &hentry->item;
-	item->key = key;
-
-	ret = drm_ht_insert_item(ht, item);
-	if (ret) {
-		DRM_DEBUG("insert_item failed\n");
-		return ret;
-	}
-
-	entry = container_of(ht, struct psb_gtt_hash_entry, ht);
-	if (entry)
-		entry->count++;
+	/* Make sure all the entries are set before we return */
+	ioread32(gtt_slot - 1);
+	
+	r->in_gart = 1;
 
 	return 0;
 }
 
-static int
-psb_gtt_mm_alloc_insert_mem_mapping(struct psb_gtt_mm *mm,
-				    struct drm_open_hash *ht,
-				    u32 key,
-				    struct drm_mm_node *node,
-				    struct psb_gtt_mem_mapping **entry)
-{
-	struct psb_gtt_mem_mapping *mapping;
-	int ret;
-
-	if (!node || !ht) {
-		DRM_DEBUG("parameter error\n");
-		return -EINVAL;
-	}
-
-	/*try to get this mem_map */
-	spin_lock(&mm->lock);
-	ret = psb_gtt_mm_get_mem_mapping_locked(ht, key, &mapping);
-	if (!ret) {
-		DRM_DEBUG("mapping entry for key %ld exists, entry %p\n",
-			  key, mapping);
-		*entry = mapping;
-		spin_unlock(&mm->lock);
-		return 0;
-	}
-	spin_unlock(&mm->lock);
-
-	DRM_DEBUG("Mapping entry for key %ld doesn't exist, will create it\n",
-		  key);
-
-	mapping = kzalloc(sizeof(struct psb_gtt_mem_mapping), GFP_KERNEL);
-	if (!mapping) {
-		DRM_DEBUG("kmalloc failed\n");
-		return -ENOMEM;
-	}
-
-	mapping->node = node;
-
-	spin_lock(&mm->lock);
-	ret = psb_gtt_mm_insert_mem_mapping_locked(ht, key, mapping);
-	spin_unlock(&mm->lock);
-
-	if (!ret)
-		*entry = mapping;
-
-	return ret;
-}
-
-static struct psb_gtt_mem_mapping *
-psb_gtt_mm_remove_mem_mapping_locked(struct drm_open_hash *ht, u32 key)
-{
-	struct psb_gtt_mem_mapping *tmp;
-	struct psb_gtt_hash_entry *entry;
-	int ret;
-
-	ret = psb_gtt_mm_get_mem_mapping_locked(ht, key, &tmp);
-	if (ret) {
-		DRM_DEBUG("Cannot find key %ld\n", key);
-		return NULL;
-	}
-
-	drm_ht_remove_item(ht, &tmp->item);
-
-	entry = container_of(ht, struct psb_gtt_hash_entry, ht);
-	if (entry)
-		entry->count--;
-
-	return tmp;
-}
-
-static int psb_gtt_mm_remove_free_mem_mapping_locked(struct drm_open_hash *ht,
-					      u32 key,
-					      struct drm_mm_node **node)
-{
-	struct psb_gtt_mem_mapping *entry;
-
-	entry = psb_gtt_mm_remove_mem_mapping_locked(ht, key);
-	if (!entry) {
-		DRM_DEBUG("entry is NULL\n");
-		return -EINVAL;
-	}
-
-	*node = entry->node;
-
-	kfree(entry);
-	return 0;
-}
+/**
+ *	psb_gtt_remove	-	remove an object from the GART
+ *	@dev: our DRM device
+ *	@r: our GTT range
+ *
+ *	Remove a preallocated GTT range from the GART. Overwrite all the
+ *	page table entries with the dummy page
+ */
 
-static int psb_gtt_add_node(struct psb_gtt_mm *mm,
-			    u32 tgid,
-			    u32 key,
-			    struct drm_mm_node *node,
-			    struct psb_gtt_mem_mapping **entry)
+void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
 {
-	struct psb_gtt_hash_entry *hentry;
-	struct psb_gtt_mem_mapping *mapping;
-	int ret;
-
-	ret = psb_gtt_mm_alloc_insert_ht(mm, tgid, &hentry);
-	if (ret) {
-		DRM_DEBUG("alloc_insert failed\n");
-		return ret;
-	}
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	u32 *gtt_slot, pte;
+	int numpages = (r->resource.end + 1 - r->resource.start) >> PAGE_SHIFT;
+	int i;
 
-	ret = psb_gtt_mm_alloc_insert_mem_mapping(mm,
-						  &hentry->ht,
-						  key,
-						  node,
-						  &mapping);
-	if (ret) {
-		DRM_DEBUG("mapping alloc_insert failed\n");
-		return ret;
-	}
+	if (r->stolen)
+		return;
+	WARN_ON(!r->in_gart);
 
-	*entry = mapping;
+	gtt_slot = psb_gtt_entry(dev, r);
+	pte = psb_gtt_mask_pte(page_to_pfn(dev_priv->scratch_page), 0);;
 
-	return 0;
+	for (i = 0; i < numpages; i++)
+		iowrite32(pte, gtt_slot++);
+	ioread32(gtt_slot - 1);
+	
+	r->in_gart = 0;
 }
 
-static int psb_gtt_remove_node(struct psb_gtt_mm *mm,
-			       u32 tgid,
-			       u32 key,
-			       struct drm_mm_node **node)
+/**
+ *	psb_gtt_attach_pages	-	attach and pin GEM pages
+ *	@gt: the gtt range
+ *
+ *	Pin and build an in kernel list of the pages that back our GEM object.
+ *	While we hold this the pages cannot be swapped out
+ */
+int psb_gtt_attach_pages(struct gtt_range *gt)
 {
-	struct psb_gtt_hash_entry *hentry;
-	struct drm_mm_node *tmp;
-	int ret;
-
-	spin_lock(&mm->lock);
-	ret = psb_gtt_mm_get_ht_by_pid_locked(mm, tgid, &hentry);
-	if (ret) {
-		DRM_DEBUG("Cannot find entry for pid %ld\n", tgid);
-		spin_unlock(&mm->lock);
-		return ret;
-	}
-	spin_unlock(&mm->lock);
-
-	/*remove mapping entry*/
-	spin_lock(&mm->lock);
-	ret = psb_gtt_mm_remove_free_mem_mapping_locked(&hentry->ht,
-							key,
-							&tmp);
-	if (ret) {
-		DRM_DEBUG("remove_free failed\n");
-		spin_unlock(&mm->lock);
-		return ret;
-	}
+	struct inode *inode;
+	struct address_space *mapping;
+	int i;
+	struct page *p;
+	int pages = (gt->resource.end + 1 - gt->resource.start) >> PAGE_SHIFT;
 
-	*node = tmp;
+	WARN_ON(gt->pages);
 
-	/*check the count of mapping entry*/
-	if (!hentry->count) {
-		DRM_DEBUG("count of mapping entry is zero, tgid=%ld\n", tgid);
-		psb_gtt_mm_remove_free_ht_locked(mm, tgid);
-	}
-
-	spin_unlock(&mm->lock);
-
-	return 0;
-}
-
-static int psb_gtt_mm_alloc_mem(struct psb_gtt_mm *mm,
-				uint32_t pages,
-				uint32_t align,
-				struct drm_mm_node **node)
-{
-	struct drm_mm_node *tmp_node;
-	int ret;
+	/* This is the shared memory object that backs the GEM resource */
+	inode = gt->gem.filp->f_path.dentry->d_inode;
+	mapping = inode->i_mapping;
 
-	do {
-		ret = drm_mm_pre_get(&mm->base);
-		if (unlikely(ret)) {
-			DRM_DEBUG("drm_mm_pre_get error\n");
-			return ret;
-		}
-
-		spin_lock(&mm->lock);
-		tmp_node = drm_mm_search_free(&mm->base, pages, align, 1);
-		if (unlikely(!tmp_node)) {
-			DRM_DEBUG("No free node found\n");
-			spin_unlock(&mm->lock);
-			break;
-		}
-
-		tmp_node = drm_mm_get_block_atomic(tmp_node, pages, align);
-		spin_unlock(&mm->lock);
-	} while (!tmp_node);
-
-	if (!tmp_node) {
-		DRM_DEBUG("Node allocation failed\n");
+	gt->pages = kmalloc(pages * sizeof(struct page *), GFP_KERNEL);
+	if (gt->pages == NULL)
 		return -ENOMEM;
+	for (i = 0; i < pages; i++) {
+		/* FIXME: review flags later */
+		p = read_cache_page_gfp(mapping, i,
+					__GFP_COLD | GFP_KERNEL);
+		if (IS_ERR(p))
+			goto err;
+		gt->pages[i] = p;
 	}
-
-	*node = tmp_node;
 	return 0;
-}
 
-static void psb_gtt_mm_free_mem(struct psb_gtt_mm *mm, struct drm_mm_node *node)
-{
-	spin_lock(&mm->lock);
-	drm_mm_put_block(node);
-	spin_unlock(&mm->lock);
+err:
+	while (i--)
+		page_cache_release(gt->pages[i]);
+	kfree(gt->pages);
+	gt->pages = NULL;
+	return PTR_ERR(p);
 }
 
-int psb_gtt_map_meminfo(struct drm_device *dev,
-			void *hKernelMemInfo,
-			uint32_t *offset)
+/**
+ *	psb_gtt_detach_pages	-	attach and pin GEM pages
+ *	@gt: the gtt range
+ *
+ *	Undo the effect of psb_gtt_attach_pages. At this point the pages
+ *	must have been removed from the GART as they could now be paged out
+ *	and move bus address.
+ */
+void psb_gtt_detach_pages(struct gtt_range *gt)
 {
-	return -EINVAL;
-	/* FIXMEAC */
-#if 0
-	struct drm_psb_private *dev_priv
-	       = (struct drm_psb_private *)dev->dev_private;
-	void *psKernelMemInfo;
-	struct psb_gtt_mm *mm = dev_priv->gtt_mm;
-	struct psb_gtt *pg = dev_priv->pg;
-	uint32_t size, pages, offset_pages;
-	void *kmem;
-	struct drm_mm_node *node;
-	struct page **page_list;
-	struct psb_gtt_mem_mapping *mapping = NULL;
-	int ret;
-
-	ret = psb_get_meminfo_by_handle(hKernelMemInfo, &psKernelMemInfo);
-	if (ret) {
-		DRM_DEBUG("Cannot find kernelMemInfo handle %ld\n",
-			  hKernelMemInfo);
-		return -EINVAL;
-	}
-
-	DRM_DEBUG("Got psKernelMemInfo %p for handle %lx\n",
-		  psKernelMemInfo, (u32)hKernelMemInfo);
-	size = psKernelMemInfo->ui32AllocSize;
-	kmem = psKernelMemInfo->pvLinAddrKM;
-	pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
-
-	DRM_DEBUG("KerMemInfo size %ld, cpuVadr %lx, pages %ld, osMemHdl %lx\n",
-		  size, kmem, pages, psKernelMemInfo->sMemBlk.hOSMemHandle);
-
-	if (!kmem)
-		DRM_DEBUG("kmem is NULL");
-
-	/*get pages*/
-	ret = psb_get_pages_by_mem_handle(psKernelMemInfo->sMemBlk.hOSMemHandle,
-					  &page_list);
-	if (ret) {
-		DRM_DEBUG("get pages error\n");
-		return ret;
-	}
+	int i;
+	int pages = (gt->resource.end + 1 - gt->resource.start) >> PAGE_SHIFT;
 
-	DRM_DEBUG("get %ld pages\n", pages);
+	WARN_ON(gt->in_gart);
 
-	/*alloc memory in TT apeture*/
-	ret = psb_gtt_mm_alloc_mem(mm, pages, 0, &node);
-	if (ret) {
-		DRM_DEBUG("alloc TT memory error\n");
-		goto failed_pages_alloc;
+	for (i = 0; i < pages; i++) {
+		/* FIXME: do we need to force dirty */
+		set_page_dirty(gt->pages[i]);
+		/* Undo the reference we took when populating the table */
+		page_cache_release(gt->pages[i]);
 	}
-
-	/*update psb_gtt_mm*/
-	ret = psb_gtt_add_node(mm,
-			       task_tgid_nr(current),
-			       (u32)hKernelMemInfo,
-			       node,
-			       &mapping);
-	if (ret) {
-		DRM_DEBUG("add_node failed");
-		goto failed_add_node;
-	}
-
-	node = mapping->node;
-	offset_pages = node->start;
-
-	DRM_DEBUG("get free node for %ld pages, offset %ld pages",
-		  pages, offset_pages);
-
-	/*update gtt*/
-	psb_gtt_insert_pages(pg, page_list,
-			     (unsigned)offset_pages,
-			     (unsigned)pages,
-			     0,
-			     0,
-			     0);
-
-	*offset = offset_pages;
-	return 0;
-
-failed_add_node:
-	psb_gtt_mm_free_mem(mm, node);
-failed_pages_alloc:
-	kfree(page_list);
-	return ret;
-#endif
-}
-
-int psb_gtt_unmap_meminfo(struct drm_device *dev, void * hKernelMemInfo)
-{
-	struct drm_psb_private *dev_priv
-	       = (struct drm_psb_private *)dev->dev_private;
-	struct psb_gtt_mm *mm = dev_priv->gtt_mm;
-	struct psb_gtt *pg = dev_priv->pg;
-	uint32_t pages, offset_pages;
-	struct drm_mm_node *node;
-	int ret;
-
-	ret = psb_gtt_remove_node(mm,
-			task_tgid_nr(current),
-			(u32)hKernelMemInfo,
-			&node);
-	if (ret) {
-		DRM_DEBUG("remove node failed\n");
-		return ret;
-	}
-
-	/*remove gtt entries*/
-	offset_pages = node->start;
-	pages = node->size;
-
-	psb_gtt_remove_pages(pg, offset_pages, pages, 0, 0, 1);
-
-
-	/*free tt node*/
-
-	psb_gtt_mm_free_mem(mm, node);
-	return 0;
+	kfree(gt->pages);
+	gt->pages = NULL;
 }
 
 /*
@@ -941,10 +261,14 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 	return NULL;
 }
 
+
 static void psb_gtt_destroy(struct kref *kref)
 {
 	struct gtt_range *gt = container_of(kref, struct gtt_range, kref);
-	WARN_ON(gt->in_gart && !gt->stolen);
+	if (gt->in_gart && !gt->stolen)
+		psb_gtt_remove(gt->gem.dev, gt);
+	if (gt->pages)
+		psb_gtt_detach_pages(gt);
 	release_resource(&gt->resource);
 	kfree(gt);
 }
@@ -971,3 +295,171 @@ void psb_gtt_free_range(struct drm_device *dev, struct gtt_range *gt)
 {
 	psb_gtt_kref_put(gt);
 }
+
+
+struct psb_gtt *psb_gtt_alloc(struct drm_device *dev)
+{
+	struct psb_gtt *tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
+
+	if (!tmp)
+		return NULL;
+
+	init_rwsem(&tmp->sem);
+	tmp->dev = dev;
+
+	return tmp;
+}
+
+void psb_gtt_takedown(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	/* FIXME: iounmap dev_priv->vram_addr etc */
+	if (dev_priv->gtt_map) {
+		iounmap(dev_priv->gtt_map);
+		dev_priv->gtt_map = NULL;
+	}
+	if (dev_priv->gtt_initialized) {
+		pci_write_config_word(dev->pdev, PSB_GMCH_CTRL,
+				      dev_priv->gmch_ctrl);
+		PSB_WVDC32(dev_priv->pge_ctl, PSB_PGETBL_CTL);
+		(void) PSB_RVDC32(PSB_PGETBL_CTL);
+	}
+	kfree(dev_priv->pg);
+	dev_priv->pg = NULL;
+}
+
+int psb_gtt_init(struct drm_device *dev, int resume)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	unsigned gtt_pages;
+	unsigned long stolen_size, vram_stolen_size;
+	unsigned i, num_pages;
+	unsigned pfn_base;
+	uint32_t vram_pages;
+	uint32_t tt_pages;
+	uint32_t *ttm_gtt_map;
+	uint32_t dvmt_mode = 0;
+	struct psb_gtt *pg;
+
+	int ret = 0;
+	uint32_t pte;
+
+	dev_priv->pg = pg = psb_gtt_alloc(dev);
+	if (pg == NULL)
+	        return -ENOMEM;
+
+	pci_read_config_word(dev->pdev, PSB_GMCH_CTRL, &dev_priv->gmch_ctrl);
+	pci_write_config_word(dev->pdev, PSB_GMCH_CTRL,
+			      dev_priv->gmch_ctrl | _PSB_GMCH_ENABLED);
+
+	dev_priv->pge_ctl = PSB_RVDC32(PSB_PGETBL_CTL);
+	PSB_WVDC32(dev_priv->pge_ctl | _PSB_PGETBL_ENABLED, PSB_PGETBL_CTL);
+	(void) PSB_RVDC32(PSB_PGETBL_CTL);
+
+	/* The root resource we allocate address space from */
+	dev_priv->gtt_mem = &dev->pdev->resource[PSB_GATT_RESOURCE];
+
+	dev_priv->gtt_initialized = 1;
+
+	pg->gtt_phys_start = dev_priv->pge_ctl & PAGE_MASK;
+
+	pg->gatt_start = pci_resource_start(dev->pdev, PSB_GATT_RESOURCE);
+	/* fix me: video mmu has hw bug to access 0x0D0000000,
+	 * then make gatt start at 0x0e000,0000 */
+	pg->mmu_gatt_start = 0xE0000000;
+	pg->gtt_start = pci_resource_start(dev->pdev, PSB_GTT_RESOURCE);
+	gtt_pages =
+	    pci_resource_len(dev->pdev, PSB_GTT_RESOURCE) >> PAGE_SHIFT;
+	pg->gatt_pages = pci_resource_len(dev->pdev, PSB_GATT_RESOURCE)
+	    >> PAGE_SHIFT;
+
+	pci_read_config_dword(dev->pdev, PSB_BSM, &dev_priv->stolen_base);
+	vram_stolen_size = pg->gtt_phys_start - dev_priv->stolen_base - PAGE_SIZE;
+
+	stolen_size = vram_stolen_size;
+
+	printk(KERN_INFO"GMMADR(region 0) start: 0x%08x (%dM).\n",
+		pg->gatt_start, pg->gatt_pages/256);
+	printk(KERN_INFO"GTTADR(region 3) start: 0x%08x (can map %dM RAM), and actual RAM base 0x%08x.\n",
+		pg->gtt_start, gtt_pages * 4, pg->gtt_phys_start);
+	printk(KERN_INFO "Stolen memory information\n");
+	printk(KERN_INFO "       base in RAM: 0x%x\n", dev_priv->stolen_base);
+	printk(KERN_INFO "       size: %luK, calculated by (GTT RAM base) - (Stolen base), seems wrong\n",
+		vram_stolen_size/1024);
+	dvmt_mode = (dev_priv->gmch_ctrl >> 4) & 0x7;
+	printk(KERN_INFO "      the correct size should be: %dM(dvmt mode=%d)\n",
+		(dvmt_mode == 1) ? 1 : (2 << (dvmt_mode - 1)), dvmt_mode);
+
+	if (resume && (gtt_pages != pg->gtt_pages) &&
+	    (stolen_size != pg->stolen_size)) {
+		DRM_ERROR("GTT resume error.\n");
+		ret = -EINVAL;
+		goto out_err;
+	}
+
+	pg->gtt_pages = gtt_pages;
+	pg->stolen_size = stolen_size;
+	dev_priv->vram_stolen_size = vram_stolen_size;
+	dev_priv->gtt_map =
+	    ioremap_nocache(pg->gtt_phys_start, gtt_pages << PAGE_SHIFT);
+	if (!dev_priv->gtt_map) {
+		DRM_ERROR("Failure to map gtt.\n");
+		ret = -ENOMEM;
+		goto out_err;
+	}
+
+	dev_priv->vram_addr = ioremap_wc(dev_priv->stolen_base, stolen_size);
+	if (!dev_priv->vram_addr) {
+		DRM_ERROR("Failure to map stolen base.\n");
+		ret = -ENOMEM;
+		goto out_err;
+	}
+
+	DRM_DEBUG("%s: vram kernel virtual address %p\n", dev_priv->vram_addr);
+
+	tt_pages = (pg->gatt_pages < PSB_TT_PRIV0_PLIMIT) ?
+		(pg->gatt_pages) : PSB_TT_PRIV0_PLIMIT;
+
+	ttm_gtt_map = dev_priv->gtt_map + tt_pages / 2;
+
+	/*
+	 * insert vram stolen pages.
+	 */
+
+	pfn_base = dev_priv->stolen_base >> PAGE_SHIFT;
+	vram_pages = num_pages = vram_stolen_size >> PAGE_SHIFT;
+	printk(KERN_INFO"Set up %d stolen pages starting at 0x%08x, GTT offset %dK\n",
+		num_pages, pfn_base, 0);
+	for (i = 0; i < num_pages; ++i) {
+		pte = psb_gtt_mask_pte(pfn_base + i, 0);
+		iowrite32(pte, dev_priv->gtt_map + i);
+	}
+
+	/*
+	 * Init rest of gtt managed by IMG.
+	 */
+	pfn_base = page_to_pfn(dev_priv->scratch_page);
+	pte = psb_gtt_mask_pte(pfn_base, 0);
+	for (; i < tt_pages / 2 - 1; ++i)
+		iowrite32(pte, dev_priv->gtt_map + i);
+
+	/*
+	 * Init rest of gtt managed by TTM.
+	 */
+
+	pfn_base = page_to_pfn(dev_priv->scratch_page);
+	pte = psb_gtt_mask_pte(pfn_base, 0);
+	PSB_DEBUG_INIT("Initializing the rest of a total "
+		       "of %d gtt pages.\n", pg->gatt_pages);
+
+	for (; i < pg->gatt_pages - tt_pages / 2; ++i)
+		iowrite32(pte, ttm_gtt_map + i);
+	(void) ioread32(dev_priv->gtt_map + i - 1);
+
+	return 0;
+
+out_err:
+	psb_gtt_takedown(dev);
+	return ret;
+}
diff --git a/drivers/staging/gma500/psb_gtt.h b/drivers/staging/gma500/psb_gtt.h
index 1b5bec0..b5d6530 100644
--- a/drivers/staging/gma500/psb_gtt.h
+++ b/drivers/staging/gma500/psb_gtt.h
@@ -22,66 +22,22 @@
 
 #include <drm/drmP.h>
 
-/*#include "img_types.h"*/
-
 struct psb_gtt {
 	struct drm_device *dev;
-	int initialized;
 	uint32_t gatt_start;
 	uint32_t mmu_gatt_start;
 	uint32_t gtt_start;
 	uint32_t gtt_phys_start;
 	unsigned gtt_pages;
 	unsigned gatt_pages;
-	uint32_t stolen_base;
-	void *vram_addr;
-	uint32_t pge_ctl;
-	u16 gmch_ctrl;
 	unsigned long stolen_size;
 	unsigned long vram_stolen_size;
-	uint32_t *gtt_map;
 	struct rw_semaphore sem;
 };
 
-struct psb_gtt_mm {
-	struct drm_mm base;
-	struct drm_open_hash hash;
-	uint32_t count;
-	spinlock_t lock;
-};
-
-struct psb_gtt_hash_entry {
-	struct drm_open_hash ht;
-	uint32_t count;
-	struct drm_hash_item item;
-};
-
-struct psb_gtt_mem_mapping {
-	struct drm_mm_node *node;
-	struct drm_hash_item item;
-};
-
 /*Exported functions*/
-extern int psb_gtt_init(struct psb_gtt *pg, int resume);
-extern int psb_gtt_insert_pages(struct psb_gtt *pg, struct page **pages,
-				unsigned offset_pages, unsigned num_pages,
-				unsigned desired_tile_stride,
-				unsigned hw_tile_stride, int type);
-extern int psb_gtt_remove_pages(struct psb_gtt *pg, unsigned offset_pages,
-				unsigned num_pages,
-				unsigned desired_tile_stride,
-				unsigned hw_tile_stride,
-				int rc_prot);
-
-extern struct psb_gtt *psb_gtt_alloc(struct drm_device *dev);
-extern void psb_gtt_takedown(struct psb_gtt *pg, int free);
-extern int psb_gtt_map_meminfo(struct drm_device *dev,
-				void * hKernelMemInfo,
-				uint32_t *offset);
-extern int psb_gtt_unmap_meminfo(struct drm_device *dev,
-				 void * hKernelMemInfo);
-extern int psb_gtt_mm_init(struct psb_gtt *pg);
-extern void psb_gtt_mm_takedown(void);
+extern int psb_gtt_init(struct drm_device *dev, int resume);
+extern void psb_gtt_takedown(struct drm_device *dev);
 
 /* Each gtt_range describes an allocation in the GTT area */
 struct gtt_range {
@@ -91,8 +47,12 @@ struct gtt_range {
         struct drm_gem_object gem;	/* GEM high level stuff */
         int in_gart;			/* Currently in the GART */
         int stolen;			/* Backed from stolen RAM */
+        struct page **pages;		/* Backing pages if present */
 };
 
+extern int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r);
+extern void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r);
+
 extern struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 						const char *name, int backed);
 extern void psb_gtt_kref_put(struct gtt_range *gt);
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index b462f32..6e14657 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -1014,6 +1014,8 @@ static void psb_intel_crtc_restore(struct drm_crtc *crtc)
 		REG_WRITE(paletteReg + (i << 2), crtc_state->savePalette[i]);
 }
 
+#if 0
+/* FIXME */
 static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 				 struct drm_file *file_priv,
 				 uint32_t handle,
@@ -1092,7 +1094,7 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 
 	addr = page_offset << PAGE_SHIFT;
 
-	addr += pg->stolen_base;
+	addr += dev_priv->stolen_base;
 
 	psb_intel_crtc->cursor_addr = addr;
 
@@ -1146,6 +1148,7 @@ static int psb_intel_crtc_cursor_move(struct drm_crtc *crtc, int x, int y)
 	}
 	return 0;
 }
+#endif
 
 static void psb_intel_crtc_gamma_set(struct drm_crtc *crtc, u16 *red,
 			 u16 *green, u16 *blue, uint32_t type, uint32_t size)
@@ -1329,8 +1332,10 @@ static const struct drm_crtc_helper_funcs psb_intel_helper_funcs = {
 const struct drm_crtc_funcs psb_intel_crtc_funcs = {
 	.save = psb_intel_crtc_save,
 	.restore = psb_intel_crtc_restore,
+/* FIXME 
 	.cursor_set = psb_intel_crtc_cursor_set,
 	.cursor_move = psb_intel_crtc_cursor_move,
+*/	
 	.gamma_set = psb_intel_crtc_gamma_set,
 	.set_config = psb_crtc_set_config,
 	.destroy = psb_intel_crtc_destroy,
diff --git a/drivers/staging/gma500/psb_powermgmt.c b/drivers/staging/gma500/psb_powermgmt.c
index fc0ed7a..1495415 100644
--- a/drivers/staging/gma500/psb_powermgmt.c
+++ b/drivers/staging/gma500/psb_powermgmt.c
@@ -269,7 +269,6 @@ static void gma_resume_display(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct psb_gtt *pg = dev_priv->pg;
 
 	if (dev_priv->suspended == false)
 		return;
@@ -277,9 +276,9 @@ static void gma_resume_display(struct pci_dev *pdev)
 	/* turn on the display power island */
 	power_up(dev);
 
-	PSB_WVDC32(pg->pge_ctl | _PSB_PGETBL_ENABLED, PSB_PGETBL_CTL);
+	PSB_WVDC32(dev_priv->pge_ctl | _PSB_PGETBL_ENABLED, PSB_PGETBL_CTL);
 	pci_write_config_word(pdev, PSB_GMCH_CTRL,
-			pg->gmch_ctrl | _PSB_GMCH_ENABLED);
+			dev_priv->gmch_ctrl | _PSB_GMCH_ENABLED);
 
 	/* Don't reinitialize the GTT as it is unnecessary.  The gtt is
 	 * stored in memory so it will automatically be restored.  All
diff --git a/drivers/staging/gma500/psb_pvr_glue.c b/drivers/staging/gma500/psb_pvr_glue.c
deleted file mode 100644
index da78946..0000000
--- a/drivers/staging/gma500/psb_pvr_glue.c
+++ /dev/null
@@ -1,73 +0,0 @@
-/*
- * Copyright (c) 2009, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
- */
-
-#include "psb_pvr_glue.h"
-
-/**
- * FIXME: should NOT use these file under env/linux directly
- */
-
-int psb_get_meminfo_by_handle(void *hKernelMemInfo,
-				void **ppsKernelMemInfo)
-{
-	return -EINVAL;
-#if 0
-	void *psKernelMemInfo = IMG_NULL;
-	PVRSRV_PER_PROCESS_DATA *psPerProc = IMG_NULL;
-	PVRSRV_ERROR eError;
-
-	psPerProc = PVRSRVPerProcessData(task_tgid_nr(current));
-	eError = PVRSRVLookupHandle(psPerProc->psHandleBase,
-				    (IMG_VOID *)&psKernelMemInfo,
-				    hKernelMemInfo,
-				    PVRSRV_HANDLE_TYPE_MEM_INFO);
-	if (eError != PVRSRV_OK) {
-		DRM_ERROR("Cannot find kernel meminfo for handle 0x%x\n",
-			  (u32)hKernelMemInfo);
-		return -EINVAL;
-	}
-
-	*ppsKernelMemInfo = psKernelMemInfo;
-
-	DRM_DEBUG("Got Kernel MemInfo for handle %lx\n",
-		  (u32)hKernelMemInfo);
-	return 0;
-#endif
-}
-
-int psb_get_pages_by_mem_handle(void *hOSMemHandle, struct page ***pages)
-{
-	return -EINVAL;
-#if 0
-	LinuxMemArea *psLinuxMemArea = (LinuxMemArea *)hOSMemHandle;
-	struct page **page_list;
-	if (psLinuxMemArea->eAreaType != LINUX_MEM_AREA_ALLOC_PAGES) {
-		DRM_ERROR("MemArea type is not LINUX_MEM_AREA_ALLOC_PAGES\n");
-		return -EINVAL;
-	}
-
-	page_list = psLinuxMemArea->uData.sPageList.pvPageList;
-	if (!page_list) {
-		DRM_DEBUG("Page List is NULL\n");
-		return -ENOMEM;
-	}
-
-	*pages = page_list;
-	return 0;
-#endif
-}
diff --git a/drivers/staging/gma500/psb_pvr_glue.h b/drivers/staging/gma500/psb_pvr_glue.h
deleted file mode 100644
index dee8cb2..0000000
--- a/drivers/staging/gma500/psb_pvr_glue.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * Copyright (c) 2009, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
- */
-
-#include "psb_drv.h"
-
-extern int psb_get_meminfo_by_handle(void * hKernelMemInfo,
-				void **ppsKernelMemInfo);
-extern u32 psb_get_tgid(void);
-extern int psb_get_pages_by_mem_handle(void * hOSMemHandle,
-					struct page ***pages);

