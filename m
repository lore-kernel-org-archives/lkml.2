Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab1C3JTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:19:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51197 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932144Ab1C3JTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:19:37 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 12/18] gma500: delete the RAR handling
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 30 Mar 2011 10:00:54 +0100
Message-ID: <20110330090048.5897.6720.stgit@localhost.localdomain>
In-Reply-To: <20110330085539.5897.67919.stgit@localhost.localdomain>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RAR registers are used on MID platforms for various protected video
playback activities using video playback engines we don't support.

So Rasputin can keep his Rars

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_buffer.c |   16 +---------------
 drivers/staging/gma500/psb_drv.c    |   29 +----------------------------
 drivers/staging/gma500/psb_drv.h    |    6 ------
 drivers/staging/gma500/psb_gtt.c    |   22 ----------------------
 4 files changed, 2 insertions(+), 71 deletions(-)

diff --git a/drivers/staging/gma500/psb_buffer.c b/drivers/staging/gma500/psb_buffer.c
index 3077f6a..a921f89 100644
--- a/drivers/staging/gma500/psb_buffer.c
+++ b/drivers/staging/gma500/psb_buffer.c
@@ -76,14 +76,6 @@ static int psb_init_mem_type(struct ttm_bo_device *bdev, uint32_t type,
 		man->available_caching = TTM_PL_FLAG_UNCACHED;
 		man->default_caching = TTM_PL_FLAG_UNCACHED;
 		break;
-	case TTM_PL_RAR:	/* Unmappable RAR memory */
-		man->func = &ttm_bo_manager_func;
-		man->flags = TTM_MEMTYPE_FLAG_MAPPABLE |
-			TTM_MEMTYPE_FLAG_FIXED;
-		man->available_caching = TTM_PL_FLAG_UNCACHED;
-		man->default_caching = TTM_PL_FLAG_UNCACHED;
-		man->gpu_offset = pg->mmu_gatt_start + (pg->rar_start);
-		break;
 	case TTM_PL_TT:	/* Mappable GATT memory */
 		man->func = &ttm_bo_manager_func;
 #ifdef PSB_WORKING_HOST_MMU_ACCESS
@@ -95,8 +87,7 @@ static int psb_init_mem_type(struct ttm_bo_device *bdev, uint32_t type,
 		man->available_caching = TTM_PL_FLAG_CACHED |
 		    TTM_PL_FLAG_UNCACHED | TTM_PL_FLAG_WC;
 		man->default_caching = TTM_PL_FLAG_WC;
-		man->gpu_offset = pg->mmu_gatt_start +
-				(pg->rar_start + dev_priv->rar_region_size);
+		man->gpu_offset = pg->mmu_gatt_start;
 		break;
 	default:
 		DRM_ERROR("Unsupported memory type %u\n", (unsigned) type);
@@ -387,11 +378,6 @@ static int psb_ttm_io_mem_reserve(struct ttm_bo_device *bdev,
 		mem->bus.base = dev_priv->ci_region_start;;
 		mem->bus.is_iomem = true;
 		break;
-	case TTM_PL_RAR:
-		mem->bus.offset = mm_node->start << PAGE_SHIFT;
-		mem->bus.base = dev_priv->rar_region_start;;
-		mem->bus.is_iomem = true;
-		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index b9256e3..84bcfeb 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -321,11 +321,6 @@ static void psb_do_takedown(struct drm_device *dev)
 		ttm_bo_clean_mm(bdev, TTM_PL_CI);
 		dev_priv->have_camera = 0;
 	}
-	if (dev_priv->have_rar) {
-		ttm_bo_clean_mm(bdev, TTM_PL_RAR);
-		dev_priv->have_rar = 0;
-	}
-
 }
 
 void mrst_get_fuse_settings(struct drm_device *dev)
@@ -647,7 +642,7 @@ static int psb_do_init(struct drm_device *dev)
 	if (!ttm_bo_init_mm(bdev, TTM_PL_TT,
 			pg->gatt_pages -
 			(pg->ci_start >> PAGE_SHIFT) -
-			((dev_priv->ci_region_size + dev_priv->rar_region_size)
+			((dev_priv->ci_region_size)
 			 >> PAGE_SHIFT))) {
 
 		dev_priv->have_tt = 1;
@@ -707,12 +702,6 @@ static int psb_driver_unload(struct drm_device *dev)
 					(dev_priv->mmu),
 					pg->ci_start,
 					pg->ci_stolen_size >> PAGE_SHIFT);
-			if (pg->rar_stolen_size != 0)
-				psb_mmu_remove_pfn_sequence(
-					psb_mmu_get_default_pd
-					(dev_priv->mmu),
-					pg->rar_start,
-					pg->rar_stolen_size >> PAGE_SHIFT);
 			up_read(&pg->sem);
 			psb_mmu_driver_takedown(dev_priv->mmu);
 			dev_priv->mmu = NULL;
@@ -883,7 +872,6 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 
 	/* CI/RAR use the lower half of TT. */
 	pg->ci_start = (tt_pages / 2) << PAGE_SHIFT;
-	pg->rar_start = pg->ci_start + pg->ci_stolen_size;
 
 
 	/*
@@ -901,21 +889,6 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 			goto out_err;
 	}
 
-	/*
-	 * Make MSVDX/TOPAZ MMU aware of the rar stolen memory area.
-	 */
-	if (dev_priv->pg->rar_stolen_size != 0) {
-		down_read(&pg->sem);
-		ret = psb_mmu_insert_pfn_sequence(
-				psb_mmu_get_default_pd(dev_priv->mmu),
-				dev_priv->rar_region_start >> PAGE_SHIFT,
-				pg->mmu_gatt_start + pg->rar_start,
-				pg->rar_stolen_size >> PAGE_SHIFT, 0);
-		up_read(&pg->sem);
-		if (ret)
-			goto out_err;
-	}
-
 	dev_priv->pf_pd = psb_mmu_alloc_pd(dev_priv->mmu, 1, 0);
 	if (!dev_priv->pf_pd)
 		goto out_err;
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index dbb3fbb..2aa7abc 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -606,12 +606,6 @@ struct drm_psb_private {
 	unsigned int ci_region_size;
 
 	/*
-	 * RAR share buffer;
-	 */
-	unsigned int rar_region_start;
-	unsigned int rar_region_size;
-
-	/*
 	 *Memory managers
 	 */
 
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 53c1e1e..0e5ee6c 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -76,7 +76,6 @@ int psb_gtt_init(struct psb_gtt *pg, int resume)
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	unsigned gtt_pages;
 	unsigned long stolen_size, vram_stolen_size, ci_stolen_size;
-	unsigned long rar_stolen_size;
 	unsigned i, num_pages;
 	unsigned pfn_base;
 	uint32_t ci_pages, vram_pages;
@@ -118,8 +117,6 @@ int psb_gtt_init(struct psb_gtt *pg, int resume)
 	 * managed by TTM to stolen_size */
 	stolen_size = vram_stolen_size;
 
-	rar_stolen_size = dev_priv->rar_region_size;
-
 	printk(KERN_INFO"GMMADR(region 0) start: 0x%08x (%dM).\n",
 		pg->gatt_start, pg->gatt_pages/256);
 	printk(KERN_INFO"GTTADR(region 3) start: 0x%08x (can map %dM RAM), and actual RAM base 0x%08x.\n",
@@ -136,10 +133,6 @@ int psb_gtt_init(struct psb_gtt *pg, int resume)
 		printk(KERN_INFO"CI Stole memory: RAM base = 0x%08x, size = %lu M\n",
 				dev_priv->ci_region_start,
 				ci_stolen_size / 1024 / 1024);
-	if (rar_stolen_size > 0)
-		printk(KERN_INFO "RAR Stole memory: RAM base = 0x%08x, size = %lu M\n",
-			dev_priv->rar_region_start,
-			rar_stolen_size / 1024 / 1024);
 
 	if (resume && (gtt_pages != pg->gtt_pages) &&
 	    (stolen_size != pg->stolen_size)) {
@@ -152,7 +145,6 @@ int psb_gtt_init(struct psb_gtt *pg, int resume)
 	pg->stolen_size = stolen_size;
 	pg->vram_stolen_size = vram_stolen_size;
 	pg->ci_stolen_size = ci_stolen_size;
-	pg->rar_stolen_size = rar_stolen_size;
 	pg->gtt_map =
 	    ioremap_nocache(pg->gtt_phys_start, gtt_pages << PAGE_SHIFT);
 	if (!pg->gtt_map) {
@@ -210,20 +202,6 @@ int psb_gtt_init(struct psb_gtt *pg, int resume)
 	}
 
 	/*
-	 * insert RAR stolen pages
-	 */
-	if (rar_stolen_size != 0) {
-		pfn_base = dev_priv->rar_region_start >> PAGE_SHIFT;
-		num_pages = rar_stolen_size >> PAGE_SHIFT;
-		printk(KERN_INFO"Set up %d RAR stolen pages starting at 0x%08x, GTT offset %dK\n",
-			num_pages, pfn_base,
-			(ttm_gtt_map - pg->gtt_map + i) * 4);
-		for (; i < num_pages + ci_pages; ++i) {
-			pte = psb_gtt_mask_pte(pfn_base + i - ci_pages, 0);
-			iowrite32(pte, ttm_gtt_map + i);
-		}
-	}
-	/*
 	 * Init rest of gtt managed by TTM.
 	 */
 

