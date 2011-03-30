Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab1C3JTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:19:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51201 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932263Ab1C3JTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:19:45 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 13/18] gma500: We don't support the CI either
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 30 Mar 2011 10:01:03 +0100
Message-ID: <20110330090059.5897.93820.stgit@localhost.localdomain>
In-Reply-To: <20110330085539.5897.67919.stgit@localhost.localdomain>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The camera interface is also not covered (and we won't be using TTM anyway
even if it ever re-emerges) so it to can go

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_buffer.c |   13 -------------
 drivers/staging/gma500/psb_drv.c    |   36 +----------------------------------
 drivers/staging/gma500/psb_drv.h    |    8 --------
 drivers/staging/gma500/psb_gtt.c    |   27 ++------------------------
 drivers/staging/gma500/psb_gtt.h    |    4 ----
 5 files changed, 3 insertions(+), 85 deletions(-)

diff --git a/drivers/staging/gma500/psb_buffer.c b/drivers/staging/gma500/psb_buffer.c
index a921f89..b5d79a5 100644
--- a/drivers/staging/gma500/psb_buffer.c
+++ b/drivers/staging/gma500/psb_buffer.c
@@ -68,14 +68,6 @@ static int psb_init_mem_type(struct ttm_bo_device *bdev, uint32_t type,
 		    TTM_PL_FLAG_UNCACHED | TTM_PL_FLAG_WC;
 		man->default_caching = TTM_PL_FLAG_WC;
 		break;
-	case TTM_PL_CI:
-		man->func = &ttm_bo_manager_func;
-		man->flags = TTM_MEMTYPE_FLAG_MAPPABLE |
-			TTM_MEMTYPE_FLAG_FIXED;
-		man->gpu_offset = pg->mmu_gatt_start + (pg->ci_start);
-		man->available_caching = TTM_PL_FLAG_UNCACHED;
-		man->default_caching = TTM_PL_FLAG_UNCACHED;
-		break;
 	case TTM_PL_TT:	/* Mappable GATT memory */
 		man->func = &ttm_bo_manager_func;
 #ifdef PSB_WORKING_HOST_MMU_ACCESS
@@ -373,11 +365,6 @@ static int psb_ttm_io_mem_reserve(struct ttm_bo_device *bdev,
 		mem->bus.offset = mm_node->start << PAGE_SHIFT;
 		mem->bus.base = 0x00000000;
 		break;
-	case TTM_PL_CI:
-		mem->bus.offset = mm_node->start << PAGE_SHIFT;
-		mem->bus.base = dev_priv->ci_region_start;;
-		mem->bus.is_iomem = true;
-		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 84bcfeb..cbb691e 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -316,11 +316,6 @@ static void psb_do_takedown(struct drm_device *dev)
 		ttm_bo_clean_mm(bdev, TTM_PL_TT);
 		dev_priv->have_tt = 0;
 	}
-
-	if (dev_priv->have_camera) {
-		ttm_bo_clean_mm(bdev, TTM_PL_CI);
-		dev_priv->have_camera = 0;
-	}
 }
 
 void mrst_get_fuse_settings(struct drm_device *dev)
@@ -639,12 +634,7 @@ static int psb_do_init(struct drm_device *dev)
       	PSB_WSGX32(pg->mmu_gatt_start, PSB_CR_BIF_TWOD_REQ_BASE);
 
 	/* TT region managed by TTM. */
-	if (!ttm_bo_init_mm(bdev, TTM_PL_TT,
-			pg->gatt_pages -
-			(pg->ci_start >> PAGE_SHIFT) -
-			((dev_priv->ci_region_size)
-			 >> PAGE_SHIFT))) {
-
+	if (!ttm_bo_init_mm(bdev, TTM_PL_TT, pg->gatt_pages)) {
 		dev_priv->have_tt = 1;
 		dev_priv->sizes.tt_size =
 			(tt_pages << PAGE_SHIFT) / (1024 * 1024) / 2;
@@ -696,12 +686,6 @@ static int psb_driver_unload(struct drm_device *dev)
 					(dev_priv->mmu),
 					pg->mmu_gatt_start,
 					pg->vram_stolen_size >> PAGE_SHIFT);
-			if (pg->ci_stolen_size != 0)
-				psb_mmu_remove_pfn_sequence(
-					psb_mmu_get_default_pd
-					(dev_priv->mmu),
-					pg->ci_start,
-					pg->ci_stolen_size >> PAGE_SHIFT);
 			up_read(&pg->sem);
 			psb_mmu_driver_takedown(dev_priv->mmu);
 			dev_priv->mmu = NULL;
@@ -870,24 +854,6 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	tt_pages = (pg->gatt_pages < PSB_TT_PRIV0_PLIMIT) ?
 		(pg->gatt_pages) : PSB_TT_PRIV0_PLIMIT;
 
-	/* CI/RAR use the lower half of TT. */
-	pg->ci_start = (tt_pages / 2) << PAGE_SHIFT;
-
-
-	/*
-	 * Make MSVDX/TOPAZ MMU aware of the CI stolen memory area.
-	 */
-	if (dev_priv->pg->ci_stolen_size != 0) {
-		down_read(&pg->sem);
-		ret = psb_mmu_insert_pfn_sequence(psb_mmu_get_default_pd
-				(dev_priv->mmu),
-				dev_priv->ci_region_start >> PAGE_SHIFT,
-				pg->mmu_gatt_start + pg->ci_start,
-				pg->ci_stolen_size >> PAGE_SHIFT, 0);
-		up_read(&pg->sem);
-		if (ret)
-			goto out_err;
-	}
 
 	dev_priv->pf_pd = psb_mmu_alloc_pd(dev_priv->mmu, 1, 0);
 	if (!dev_priv->pf_pd)
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 2aa7abc..7c83c8d 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -600,17 +600,9 @@ struct drm_psb_private {
 	uint32_t num_pipe;
 
 	/*
-	 * CI share buffer
-	 */
-	unsigned int ci_region_start;
-	unsigned int ci_region_size;
-
-	/*
 	 *Memory managers
 	 */
 
-	int have_camera;
-	int have_rar;
 	int have_tt;
 	int have_mem_mmu;
 	struct mutex temp_mem;
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 0e5ee6c..d129b75 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -75,10 +75,10 @@ int psb_gtt_init(struct psb_gtt *pg, int resume)
 	struct drm_device *dev = pg->dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	unsigned gtt_pages;
-	unsigned long stolen_size, vram_stolen_size, ci_stolen_size;
+	unsigned long stolen_size, vram_stolen_size;
 	unsigned i, num_pages;
 	unsigned pfn_base;
-	uint32_t ci_pages, vram_pages;
+	uint32_t vram_pages;
 	uint32_t tt_pages;
 	uint32_t *ttm_gtt_map;
 	uint32_t dvmt_mode = 0;
@@ -111,10 +111,6 @@ int psb_gtt_init(struct psb_gtt *pg, int resume)
 	pci_read_config_dword(dev->pdev, PSB_BSM, &pg->stolen_base);
 	vram_stolen_size = pg->gtt_phys_start - pg->stolen_base - PAGE_SIZE;
 
-	/* CI is not included in the stolen size since the TOPAZ MMU bug */
-	ci_stolen_size = dev_priv->ci_region_size;
-	/* Don't add CI & RAR share buffer space
-	 * managed by TTM to stolen_size */
 	stolen_size = vram_stolen_size;
 
 	printk(KERN_INFO"GMMADR(region 0) start: 0x%08x (%dM).\n",
@@ -129,11 +125,6 @@ int psb_gtt_init(struct psb_gtt *pg, int resume)
 	printk(KERN_INFO "      the correct size should be: %dM(dvmt mode=%d)\n",
 		(dvmt_mode == 1) ? 1 : (2 << (dvmt_mode - 1)), dvmt_mode);
 
-	if (ci_stolen_size > 0)
-		printk(KERN_INFO"CI Stole memory: RAM base = 0x%08x, size = %lu M\n",
-				dev_priv->ci_region_start,
-				ci_stolen_size / 1024 / 1024);
-
 	if (resume && (gtt_pages != pg->gtt_pages) &&
 	    (stolen_size != pg->stolen_size)) {
 		DRM_ERROR("GTT resume error.\n");
@@ -144,7 +135,6 @@ int psb_gtt_init(struct psb_gtt *pg, int resume)
 	pg->gtt_pages = gtt_pages;
 	pg->stolen_size = stolen_size;
 	pg->vram_stolen_size = vram_stolen_size;
-	pg->ci_stolen_size = ci_stolen_size;
 	pg->gtt_map =
 	    ioremap_nocache(pg->gtt_phys_start, gtt_pages << PAGE_SHIFT);
 	if (!pg->gtt_map) {
@@ -189,19 +179,6 @@ int psb_gtt_init(struct psb_gtt *pg, int resume)
 		iowrite32(pte, pg->gtt_map + i);
 
 	/*
-	 * insert CI stolen pages
-	 */
-
-	pfn_base = dev_priv->ci_region_start >> PAGE_SHIFT;
-	ci_pages = num_pages = ci_stolen_size >> PAGE_SHIFT;
-	printk(KERN_INFO"Set up %d CI stolen pages starting at 0x%08x, GTT offset %dK\n",
-	       num_pages, pfn_base, (ttm_gtt_map - pg->gtt_map) * 4);
-	for (i = 0; i < num_pages; ++i) {
-		pte = psb_gtt_mask_pte(pfn_base + i, 0);
-		iowrite32(pte, ttm_gtt_map + i);
-	}
-
-	/*
 	 * Init rest of gtt managed by TTM.
 	 */
 
diff --git a/drivers/staging/gma500/psb_gtt.h b/drivers/staging/gma500/psb_gtt.h
index 0272f83..8a0ef77 100644
--- a/drivers/staging/gma500/psb_gtt.h
+++ b/drivers/staging/gma500/psb_gtt.h
@@ -29,8 +29,6 @@ struct psb_gtt {
 	int initialized;
 	uint32_t gatt_start;
 	uint32_t mmu_gatt_start;
-	uint32_t ci_start;
-	uint32_t rar_start;
 	uint32_t gtt_start;
 	uint32_t gtt_phys_start;
 	unsigned gtt_pages;
@@ -41,8 +39,6 @@ struct psb_gtt {
 	u16 gmch_ctrl;
 	unsigned long stolen_size;
 	unsigned long vram_stolen_size;
-	unsigned long ci_stolen_size;
-	unsigned long rar_stolen_size;
 	uint32_t *gtt_map;
 	struct rw_semaphore sem;
 };

