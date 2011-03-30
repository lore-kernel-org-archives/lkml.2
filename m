Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab1C3JUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:20:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51213 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932249Ab1C3JUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:20:15 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 16/18] gma500; kill off TTM
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 30 Mar 2011 10:01:31 +0100
Message-ID: <20110330090127.5897.23106.stgit@localhost.localdomain>
In-Reply-To: <20110330085539.5897.67919.stgit@localhost.localdomain>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are not using TTM, we are not going to use TTM either

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile                 |    7 
 drivers/staging/gma500/psb_2d.c                 |    1 
 drivers/staging/gma500/psb_buffer.c             |  423 ---------------
 drivers/staging/gma500/psb_drm.h                |  111 ----
 drivers/staging/gma500/psb_drv.c                |  227 +-------
 drivers/staging/gma500/psb_drv.h                |  110 ----
 drivers/staging/gma500/psb_fb.c                 |    5 
 drivers/staging/gma500/psb_fence.c              |  122 ----
 drivers/staging/gma500/psb_gtt.c                |    2 
 drivers/staging/gma500/psb_sgx.c                |  131 -----
 drivers/staging/gma500/psb_sgx.h                |   32 -
 drivers/staging/gma500/psb_ttm_fence.c          |  605 ----------------------
 drivers/staging/gma500/psb_ttm_fence_api.h      |  272 ----------
 drivers/staging/gma500/psb_ttm_fence_driver.h   |  302 -----------
 drivers/staging/gma500/psb_ttm_fence_user.c     |  237 ---------
 drivers/staging/gma500/psb_ttm_fence_user.h     |  140 -----
 drivers/staging/gma500/psb_ttm_glue.c           |  349 -------------
 drivers/staging/gma500/psb_ttm_placement_user.c |  628 -----------------------
 drivers/staging/gma500/psb_ttm_userobj_api.h    |   85 ---
 19 files changed, 17 insertions(+), 3772 deletions(-)
 delete mode 100644 drivers/staging/gma500/psb_buffer.c
 delete mode 100644 drivers/staging/gma500/psb_fence.c
 delete mode 100644 drivers/staging/gma500/psb_sgx.c
 delete mode 100644 drivers/staging/gma500/psb_sgx.h
 delete mode 100644 drivers/staging/gma500/psb_ttm_fence.c
 delete mode 100644 drivers/staging/gma500/psb_ttm_fence_api.h
 delete mode 100644 drivers/staging/gma500/psb_ttm_fence_driver.h
 delete mode 100644 drivers/staging/gma500/psb_ttm_fence_user.c
 delete mode 100644 drivers/staging/gma500/psb_ttm_fence_user.h
 delete mode 100644 drivers/staging/gma500/psb_ttm_glue.c
 delete mode 100644 drivers/staging/gma500/psb_ttm_placement_user.c
 delete mode 100644 drivers/staging/gma500/psb_ttm_userobj_api.h

diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index 383a574..4d7aabe 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -16,15 +16,8 @@ psb_gfx-y += psb_bl.o \
 	  psb_intel_modes.o \
 	  psb_intel_sdvo.o \
 	  psb_reset.o \
-	  psb_sgx.o \
 	  psb_pvr_glue.o \
-	  psb_buffer.o \
-	  psb_fence.o \
 	  psb_mmu.o \
-	  psb_ttm_glue.o \
-	  psb_ttm_fence.o \
-	  psb_ttm_fence_user.o \
-	  psb_ttm_placement_user.o \
 	  psb_powermgmt.o \
 	  psb_irq.o \
 	  mrst_crtc.o \
diff --git a/drivers/staging/gma500/psb_2d.c b/drivers/staging/gma500/psb_2d.c
index e4cae5d..9a0691f 100644
--- a/drivers/staging/gma500/psb_2d.c
+++ b/drivers/staging/gma500/psb_2d.c
@@ -40,7 +40,6 @@
 #include "psb_reg.h"
 #include "psb_drv.h"
 #include "psb_fb.h"
-#include "psb_sgx.h"
 
 void psb_spank(struct drm_psb_private *dev_priv)
 {
diff --git a/drivers/staging/gma500/psb_buffer.c b/drivers/staging/gma500/psb_buffer.c
deleted file mode 100644
index b5d79a5..0000000
--- a/drivers/staging/gma500/psb_buffer.c
+++ /dev/null
@@ -1,423 +0,0 @@
-/**************************************************************************
- * Copyright (c) 2007, Intel Corporation.
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
- **************************************************************************/
-/*
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics.com>
- */
-#include "ttm/ttm_placement.h"
-#include "ttm/ttm_execbuf_util.h"
-#include "psb_ttm_fence_api.h"
-#include <drm/drmP.h>
-#include "psb_drv.h"
-
-#define DRM_MEM_TTM       26
-
-struct drm_psb_ttm_backend {
-	struct ttm_backend base;
-	struct page **pages;
-	unsigned int desired_tile_stride;
-	unsigned int hw_tile_stride;
-	int mem_type;
-	unsigned long offset;
-	unsigned long num_pages;
-};
-
-/*
- * MSVDX/TOPAZ GPU virtual space looks like this
- * (We currently use only one MMU context).
- * PSB_MEM_MMU_START: from 0x00000000~0xe000000, for generic buffers
- * TTM_PL_CI: from 0xe0000000+half GTT space, for camear/video buffer sharing
- * TTM_PL_RAR: from TTM_PL_CI+CI size, for RAR/video buffer sharing
- * TTM_PL_TT: from TTM_PL_RAR+RAR size, for buffers need to mapping into GTT
- */
-static int psb_init_mem_type(struct ttm_bo_device *bdev, uint32_t type,
-			     struct ttm_mem_type_manager *man)
-{
-
-	struct drm_psb_private *dev_priv =
-	    container_of(bdev, struct drm_psb_private, bdev);
-	struct psb_gtt *pg = dev_priv->pg;
-
-	switch (type) {
-	case TTM_PL_SYSTEM:
-		man->flags = TTM_MEMTYPE_FLAG_MAPPABLE;
-		man->available_caching = TTM_PL_FLAG_CACHED |
-		    TTM_PL_FLAG_UNCACHED | TTM_PL_FLAG_WC;
-		man->default_caching = TTM_PL_FLAG_CACHED;
-		break;
-	case DRM_PSB_MEM_MMU:
-		man->func = &ttm_bo_manager_func;
-		man->flags = TTM_MEMTYPE_FLAG_MAPPABLE |
-		    TTM_MEMTYPE_FLAG_CMA;
-		man->gpu_offset = PSB_MEM_MMU_START;
-		man->available_caching = TTM_PL_FLAG_CACHED |
-		    TTM_PL_FLAG_UNCACHED | TTM_PL_FLAG_WC;
-		man->default_caching = TTM_PL_FLAG_WC;
-		break;
-	case TTM_PL_TT:	/* Mappable GATT memory */
-		man->func = &ttm_bo_manager_func;
-#ifdef PSB_WORKING_HOST_MMU_ACCESS
-		man->flags = TTM_MEMTYPE_FLAG_MAPPABLE;
-#else
-		man->flags = TTM_MEMTYPE_FLAG_MAPPABLE |
-		    TTM_MEMTYPE_FLAG_CMA;
-#endif
-		man->available_caching = TTM_PL_FLAG_CACHED |
-		    TTM_PL_FLAG_UNCACHED | TTM_PL_FLAG_WC;
-		man->default_caching = TTM_PL_FLAG_WC;
-		man->gpu_offset = pg->mmu_gatt_start;
-		break;
-	default:
-		DRM_ERROR("Unsupported memory type %u\n", (unsigned) type);
-		return -EINVAL;
-	}
-	return 0;
-}
-
-
-static void psb_evict_mask(struct ttm_buffer_object *bo,
-					struct ttm_placement *placement)
-{
-	static uint32_t cur_placement;
-
-	cur_placement = bo->mem.placement & ~TTM_PL_MASK_MEM;
-	cur_placement |= TTM_PL_FLAG_SYSTEM;
-
-	placement->fpfn = 0;
-	placement->lpfn = 0;
-	placement->num_placement = 1;
-	placement->placement = &cur_placement;
-	placement->num_busy_placement = 0;
-	placement->busy_placement = NULL;
-
-	/* all buffers evicted to system memory */
-	/* return cur_placement | TTM_PL_FLAG_SYSTEM; */
-}
-
-static int psb_invalidate_caches(struct ttm_bo_device *bdev,
-				 uint32_t placement)
-{
-	return 0;
-}
-
-static int psb_move_blit(struct ttm_buffer_object *bo,
-			 bool evict, bool no_wait,
-			 struct ttm_mem_reg *new_mem)
-{
-	BUG();
-	return 0;
-}
-
-/*
- * Flip destination ttm into GATT,
- * then blit and subsequently move out again.
- */
-
-static int psb_move_flip(struct ttm_buffer_object *bo,
-			 bool evict, bool interruptible, bool no_wait,
-			 struct ttm_mem_reg *new_mem)
-{
-	/*struct ttm_bo_device *bdev = bo->bdev;*/
-	struct ttm_mem_reg tmp_mem;
-	int ret;
-	struct ttm_placement placement;
-	uint32_t flags = TTM_PL_FLAG_TT;
-
-	tmp_mem = *new_mem;
-	tmp_mem.mm_node = NULL;
-
-	placement.fpfn = 0;
-	placement.lpfn = 0;
-	placement.num_placement = 1;
-	placement.placement = &flags;
-	placement.num_busy_placement = 0; /* FIXME */
-	placement.busy_placement = NULL;
-
-	ret = ttm_bo_mem_space(bo, &placement, &tmp_mem, interruptible,
-							false, no_wait);
-	if (ret)
-		return ret;
-	ret = ttm_tt_bind(bo->ttm, &tmp_mem);
-	if (ret)
-		goto out_cleanup;
-	ret = psb_move_blit(bo, true, no_wait, &tmp_mem);
-	if (ret)
-		goto out_cleanup;
-
-	ret = ttm_bo_move_ttm(bo, evict, false, no_wait, new_mem);
-out_cleanup:
-	if (tmp_mem.mm_node) {
-		drm_mm_put_block(tmp_mem.mm_node);
-		tmp_mem.mm_node = NULL;
-	}
-	return ret;
-}
-
-static int psb_move(struct ttm_buffer_object *bo,
-		    bool evict, bool interruptible, bool no_wait_reserve,
-		    bool no_wait, struct ttm_mem_reg *new_mem)
-{
-	struct ttm_mem_reg *old_mem = &bo->mem;
-
-	if ((old_mem->mem_type == TTM_PL_RAR) ||
-	    (new_mem->mem_type == TTM_PL_RAR)) {
-		if (old_mem->mm_node) {
-			spin_lock(&bo->glob->lru_lock);
-			drm_mm_put_block(old_mem->mm_node);
-			spin_unlock(&bo->glob->lru_lock);
-		}
-		old_mem->mm_node = NULL;
-		*old_mem = *new_mem;
-	} else if (old_mem->mem_type == TTM_PL_SYSTEM) {
-		return ttm_bo_move_memcpy(bo, evict, false, no_wait, new_mem);
-	} else if (new_mem->mem_type == TTM_PL_SYSTEM) {
-		int ret = psb_move_flip(bo, evict, interruptible,
-					no_wait, new_mem);
-		if (unlikely(ret != 0)) {
-			if (ret == -ERESTART)
-				return ret;
-			else
-				return ttm_bo_move_memcpy(bo, evict, false,
-						no_wait, new_mem);
-		}
-	} else {
-		if (psb_move_blit(bo, evict, no_wait, new_mem))
-			return ttm_bo_move_memcpy(bo, evict, false, no_wait,
-						  new_mem);
-	}
-	return 0;
-}
-
-static int drm_psb_tbe_populate(struct ttm_backend *backend,
-				unsigned long num_pages,
-				struct page **pages,
-				struct page *dummy_read_page,
-				dma_addr_t *dma_addrs)
-{
-	struct drm_psb_ttm_backend *psb_be =
-	    container_of(backend, struct drm_psb_ttm_backend, base);
-
-	psb_be->pages = pages;
-	return 0;
-}
-
-static int drm_psb_tbe_unbind(struct ttm_backend *backend)
-{
-	struct ttm_bo_device *bdev = backend->bdev;
-	struct drm_psb_private *dev_priv =
-	    container_of(bdev, struct drm_psb_private, bdev);
-	struct drm_psb_ttm_backend *psb_be =
-	    container_of(backend, struct drm_psb_ttm_backend, base);
-	struct psb_mmu_pd *pd = psb_mmu_get_default_pd(dev_priv->mmu);
-	/* struct ttm_mem_type_manager *man = &bdev->man[psb_be->mem_type]; */
-
-	if (psb_be->mem_type == TTM_PL_TT) {
-		uint32_t gatt_p_offset =
-			(psb_be->offset - dev_priv->pg->mmu_gatt_start)
-								>> PAGE_SHIFT;
-
-		(void) psb_gtt_remove_pages(dev_priv->pg, gatt_p_offset,
-					    psb_be->num_pages,
-					    psb_be->desired_tile_stride,
-					    psb_be->hw_tile_stride, 0);
-	}
-
-	psb_mmu_remove_pages(pd, psb_be->offset,
-			     psb_be->num_pages,
-			     psb_be->desired_tile_stride,
-			     psb_be->hw_tile_stride);
-
-	return 0;
-}
-
-static int drm_psb_tbe_bind(struct ttm_backend *backend,
-			    struct ttm_mem_reg *bo_mem)
-{
-	struct ttm_bo_device *bdev = backend->bdev;
-	struct drm_psb_private *dev_priv =
-	    container_of(bdev, struct drm_psb_private, bdev);
-	struct drm_psb_ttm_backend *psb_be =
-	    container_of(backend, struct drm_psb_ttm_backend, base);
-	struct psb_mmu_pd *pd = psb_mmu_get_default_pd(dev_priv->mmu);
-	struct ttm_mem_type_manager *man = &bdev->man[bo_mem->mem_type];
-	struct drm_mm_node *mm_node = bo_mem->mm_node;
-	int type;
-	int ret = 0;
-
-	psb_be->mem_type = bo_mem->mem_type;
-	psb_be->num_pages = bo_mem->num_pages;
-	psb_be->desired_tile_stride = 0;
-	psb_be->hw_tile_stride = 0;
-	psb_be->offset = (mm_node->start << PAGE_SHIFT) +
-	    man->gpu_offset;
-
-	type =
-	    (bo_mem->
-	     placement & TTM_PL_FLAG_CACHED) ? PSB_MMU_CACHED_MEMORY : 0;
-
-	if (psb_be->mem_type == TTM_PL_TT) {
-		uint32_t gatt_p_offset =
-				(psb_be->offset - dev_priv->pg->mmu_gatt_start)
-								>> PAGE_SHIFT;
-
-		ret = psb_gtt_insert_pages(dev_priv->pg, psb_be->pages,
-					   gatt_p_offset,
-					   psb_be->num_pages,
-					   psb_be->desired_tile_stride,
-					   psb_be->hw_tile_stride, type);
-	}
-
-	ret = psb_mmu_insert_pages(pd, psb_be->pages,
-				   psb_be->offset, psb_be->num_pages,
-				   psb_be->desired_tile_stride,
-				   psb_be->hw_tile_stride, type);
-	if (ret)
-		goto out_err;
-
-	return 0;
-out_err:
-	drm_psb_tbe_unbind(backend);
-	return ret;
-
-}
-
-static void drm_psb_tbe_clear(struct ttm_backend *backend)
-{
-	struct drm_psb_ttm_backend *psb_be =
-	    container_of(backend, struct drm_psb_ttm_backend, base);
-
-	psb_be->pages = NULL;
-	return;
-}
-
-static void drm_psb_tbe_destroy(struct ttm_backend *backend)
-{
-	struct drm_psb_ttm_backend *psb_be =
-	    container_of(backend, struct drm_psb_ttm_backend, base);
-
-	if (backend)
-		kfree(psb_be);
-}
-
-static struct ttm_backend_func psb_ttm_backend = {
-	.populate = drm_psb_tbe_populate,
-	.clear = drm_psb_tbe_clear,
-	.bind = drm_psb_tbe_bind,
-	.unbind = drm_psb_tbe_unbind,
-	.destroy = drm_psb_tbe_destroy,
-};
-
-static struct ttm_backend *drm_psb_tbe_init(struct ttm_bo_device *bdev)
-{
-	struct drm_psb_ttm_backend *psb_be;
-
-	psb_be = kzalloc(sizeof(*psb_be), GFP_KERNEL);
-	if (!psb_be)
-		return NULL;
-	psb_be->pages = NULL;
-	psb_be->base.func = &psb_ttm_backend;
-	psb_be->base.bdev = bdev;
-	return &psb_be->base;
-}
-
-static int psb_ttm_io_mem_reserve(struct ttm_bo_device *bdev,
-						struct ttm_mem_reg *mem)
-{
-	struct ttm_mem_type_manager *man = &bdev->man[mem->mem_type];
-	struct drm_psb_private *dev_priv =
-	    container_of(bdev, struct drm_psb_private, bdev);
-	struct psb_gtt *pg = dev_priv->pg;
-	struct drm_mm_node *mm_node = mem->mm_node;
-
-	mem->bus.addr = NULL;
-	mem->bus.offset = 0;
-	mem->bus.size = mem->num_pages << PAGE_SHIFT;
-	mem->bus.base = 0;
-	mem->bus.is_iomem = false;
-	if (!(man->flags & TTM_MEMTYPE_FLAG_MAPPABLE))
-		return -EINVAL;
-	switch (mem->mem_type) {
-	case TTM_PL_SYSTEM:
-		/* system memory */
-		return 0;
-	case TTM_PL_TT:
-		mem->bus.offset = mm_node->start << PAGE_SHIFT;
-		mem->bus.base = pg->gatt_start;
-		mem->bus.is_iomem = false;
-		/* Don't know whether it is IO_MEM, this flag
-						used in vm_fault handle */
-		break;
-	case DRM_PSB_MEM_MMU:
-		mem->bus.offset = mm_node->start << PAGE_SHIFT;
-		mem->bus.base = 0x00000000;
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static void psb_ttm_io_mem_free(struct ttm_bo_device *bdev,
-						struct ttm_mem_reg *mem)
-{
-}
-
-/*
- * Use this memory type priority if no eviction is needed.
- */
-/*
-static uint32_t psb_mem_prios[] = {
-	TTM_PL_CI,
-	TTM_PL_RAR,
-	TTM_PL_TT,
-	DRM_PSB_MEM_MMU,
-	TTM_PL_SYSTEM
-};
-*/
-/*
- * Use this memory type priority if need to evict.
- */
-/*
-static uint32_t psb_busy_prios[] = {
-	TTM_PL_TT,
-	TTM_PL_CI,
-	TTM_PL_RAR,
-	DRM_PSB_MEM_MMU,
-	TTM_PL_SYSTEM
-};
-*/
-struct ttm_bo_driver psb_ttm_bo_driver = {
-/*
-	.mem_type_prio = psb_mem_prios,
-	.mem_busy_prio = psb_busy_prios,
-	.num_mem_type_prio = ARRAY_SIZE(psb_mem_prios),
-	.num_mem_busy_prio = ARRAY_SIZE(psb_busy_prios),
-*/
-	.create_ttm_backend_entry = &drm_psb_tbe_init,
-	.invalidate_caches = &psb_invalidate_caches,
-	.init_mem_type = &psb_init_mem_type,
-	.evict_flags = &psb_evict_mask,
-	.move = &psb_move,
-	.verify_access = &psb_verify_access,
-	.sync_obj_signaled = &ttm_fence_sync_obj_signaled,
-	.sync_obj_wait = &ttm_fence_sync_obj_wait,
-	.sync_obj_flush = &ttm_fence_sync_obj_flush,
-	.sync_obj_unref = &ttm_fence_sync_obj_unref,
-	.sync_obj_ref = &ttm_fence_sync_obj_ref,
-	.io_mem_reserve = &psb_ttm_io_mem_reserve,
-	.io_mem_free = &psb_ttm_io_mem_free
-};
diff --git a/drivers/staging/gma500/psb_drm.h b/drivers/staging/gma500/psb_drm.h
index fb9b424..28862c7 100644
--- a/drivers/staging/gma500/psb_drm.h
+++ b/drivers/staging/gma500/psb_drm.h
@@ -28,9 +28,6 @@
 #include "drm_mode.h"
 #endif
 
-#include "psb_ttm_fence_user.h"
-#include "psb_ttm_placement_user.h"
-
 #define DRM_PSB_SAREA_MAJOR 0
 #define DRM_PSB_SAREA_MINOR 2
 #define PSB_FIXED_SHIFT 16
@@ -41,15 +38,6 @@
  * Public memory types.
  */
 
-#define DRM_PSB_MEM_MMU 	TTM_PL_PRIV1
-#define DRM_PSB_FLAG_MEM_MMU	TTM_PL_FLAG_PRIV1
-
-#define TTM_PL_CI               TTM_PL_PRIV0
-#define TTM_PL_FLAG_CI          TTM_PL_FLAG_PRIV0
-
-#define TTM_PL_RAR              TTM_PL_PRIV2
-#define TTM_PL_FLAG_RAR         TTM_PL_FLAG_PRIV2
-
 typedef s32 psb_fixed;
 typedef u32 psb_ufixed;
 
@@ -112,111 +100,12 @@ struct drm_psb_sarea {
 	u32 num_active_scanouts;
 };
 
-#define PSB_RELOC_MAGIC         0x67676767
-#define PSB_RELOC_SHIFT_MASK    0x0000FFFF
-#define PSB_RELOC_SHIFT_SHIFT   0
-#define PSB_RELOC_ALSHIFT_MASK  0xFFFF0000
-#define PSB_RELOC_ALSHIFT_SHIFT 16
-
-#define PSB_RELOC_OP_OFFSET     0	/* Offset of the indicated
-					 * buffer
-					 */
-
-struct drm_psb_reloc {
-	u32 reloc_op;
-	u32 where;		/* offset in destination buffer */
-	u32 buffer;	/* Buffer reloc applies to */
-	u32 mask;		/* Destination format: */
-	u32 shift;		/* Destination format: */
-	u32 pre_add;	/* Destination format: */
-	u32 background;	/* Destination add */
-	u32 dst_buffer;	/* Destination buffer. Index into buffer_list */
-	u32 arg0;		/* Reloc-op dependant */
-	u32 arg1;
-};
-
-
 #define PSB_GPU_ACCESS_READ         (1ULL << 32)
 #define PSB_GPU_ACCESS_WRITE        (1ULL << 33)
 #define PSB_GPU_ACCESS_MASK         (PSB_GPU_ACCESS_READ | PSB_GPU_ACCESS_WRITE)
 
 #define PSB_BO_FLAG_COMMAND         (1ULL << 52)
 
-#define PSB_ENGINE_2D 0
-#define PSB_ENGINE_VIDEO 1
-#define LNC_ENGINE_ENCODE 5
-
-/*
- * For this fence class we have a couple of
- * fence types.
- */
-
-#define _PSB_FENCE_EXE_SHIFT           0
-#define _PSB_FENCE_FEEDBACK_SHIFT      4
-
-#define _PSB_FENCE_TYPE_EXE         (1 << _PSB_FENCE_EXE_SHIFT)
-#define _PSB_FENCE_TYPE_FEEDBACK    (1 << _PSB_FENCE_FEEDBACK_SHIFT)
-
-#define PSB_NUM_ENGINES 6
-
-
-#define PSB_FEEDBACK_OP_VISTEST (1 << 0)
-
-struct drm_psb_extension_rep {
-	s32 exists;
-	u32 driver_ioctl_offset;
-	u32 sarea_offset;
-	u32 major;
-	u32 minor;
-	u32 pl;
-};
-
-#define DRM_PSB_EXT_NAME_LEN 128
-
-union drm_psb_extension_arg {
-	char extension[DRM_PSB_EXT_NAME_LEN];
-	struct drm_psb_extension_rep rep;
-};
-
-struct psb_validate_req {
-	u64 set_flags;
-	u64 clear_flags;
-	u64 next;
-	u64 presumed_gpu_offset;
-	u32 buffer_handle;
-	u32 presumed_flags;
-	u32 group;
-	u32 pad64;
-};
-
-struct psb_validate_rep {
-	u64 gpu_offset;
-	u32 placement;
-	u32 fence_type_mask;
-};
-
-#define PSB_USE_PRESUMED     (1 << 0)
-
-struct psb_validate_arg {
-	int handled;
-	int ret;
-	union {
-		struct psb_validate_req req;
-		struct psb_validate_rep rep;
-	} d;
-};
-
-
-#define DRM_PSB_FENCE_NO_USER        (1 << 0)
-
-struct psb_ttm_fence_rep {
-	u32 handle;
-	u32 fence_class;
-	u32 fence_type;
-	u32 signaled_types;
-	u32 error;
-};
-
 /*
  * Feedback components:
  */
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 6e9954c..ba08b07 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -111,9 +111,6 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 #define DRM_IOCTL_PSB_GTT_UNMAP	\
 		DRM_IOW(DRM_PSB_GTT_UNMAP + DRM_COMMAND_BASE, \
 			struct psb_gtt_mapping_arg)
-#define DRM_IOCTL_PSB_GETPAGEADDRS	\
-		DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_GETPAGEADDRS,\
-			 struct drm_psb_getpageaddrs_arg)
 #define DRM_IOCTL_PSB_UPDATE_GUARD	\
 		DRM_IOWR(DRM_PSB_UPDATE_GUARD + DRM_COMMAND_BASE, \
 			 uint32_t)
@@ -130,69 +127,8 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 		DRM_IOWR(DRM_PSB_GET_PIPE_FROM_CRTC_ID + DRM_COMMAND_BASE, \
 			 struct drm_psb_get_pipe_from_crtc_id_arg)
 
-/*
- * TTM execbuf extension.
- */
-
-#define DRM_PSB_CMDBUF		  0x23
-#define DRM_PSB_SCENE_UNREF	  0x24
 #define DRM_IOCTL_PSB_KMS_OFF	  DRM_IO(DRM_PSB_KMS_OFF + DRM_COMMAND_BASE)
 #define DRM_IOCTL_PSB_KMS_ON	  DRM_IO(DRM_PSB_KMS_ON + DRM_COMMAND_BASE)
-/*
- * TTM placement user extension.
- */
-
-#define DRM_PSB_PLACEMENT_OFFSET   (DRM_PSB_SCENE_UNREF + 1)
-
-#define DRM_PSB_TTM_PL_CREATE	 (TTM_PL_CREATE + DRM_PSB_PLACEMENT_OFFSET)
-#define DRM_PSB_TTM_PL_REFERENCE (TTM_PL_REFERENCE + DRM_PSB_PLACEMENT_OFFSET)
-#define DRM_PSB_TTM_PL_UNREF	 (TTM_PL_UNREF + DRM_PSB_PLACEMENT_OFFSET)
-#define DRM_PSB_TTM_PL_SYNCCPU	 (TTM_PL_SYNCCPU + DRM_PSB_PLACEMENT_OFFSET)
-#define DRM_PSB_TTM_PL_WAITIDLE  (TTM_PL_WAITIDLE + DRM_PSB_PLACEMENT_OFFSET)
-#define DRM_PSB_TTM_PL_SETSTATUS (TTM_PL_SETSTATUS + DRM_PSB_PLACEMENT_OFFSET)
-#define DRM_PSB_TTM_PL_CREATE_UB (TTM_PL_CREATE_UB + DRM_PSB_PLACEMENT_OFFSET)
-
-/*
- * TTM fence extension.
- */
-
-#define DRM_PSB_FENCE_OFFSET	   (DRM_PSB_TTM_PL_CREATE_UB + 1)
-#define DRM_PSB_TTM_FENCE_SIGNALED (TTM_FENCE_SIGNALED + DRM_PSB_FENCE_OFFSET)
-#define DRM_PSB_TTM_FENCE_FINISH   (TTM_FENCE_FINISH + DRM_PSB_FENCE_OFFSET)
-#define DRM_PSB_TTM_FENCE_UNREF    (TTM_FENCE_UNREF + DRM_PSB_FENCE_OFFSET)
-
-#define DRM_PSB_FLIP	   (DRM_PSB_TTM_FENCE_UNREF + 1)	/*20*/
-
-#define DRM_IOCTL_PSB_TTM_PL_CREATE    \
-	DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_TTM_PL_CREATE,\
-		 union ttm_pl_create_arg)
-#define DRM_IOCTL_PSB_TTM_PL_REFERENCE \
-	DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_TTM_PL_REFERENCE,\
-		 union ttm_pl_reference_arg)
-#define DRM_IOCTL_PSB_TTM_PL_UNREF    \
-	DRM_IOW(DRM_COMMAND_BASE + DRM_PSB_TTM_PL_UNREF,\
-		struct ttm_pl_reference_req)
-#define DRM_IOCTL_PSB_TTM_PL_SYNCCPU	\
-	DRM_IOW(DRM_COMMAND_BASE + DRM_PSB_TTM_PL_SYNCCPU,\
-		struct ttm_pl_synccpu_arg)
-#define DRM_IOCTL_PSB_TTM_PL_WAITIDLE	 \
-	DRM_IOW(DRM_COMMAND_BASE + DRM_PSB_TTM_PL_WAITIDLE,\
-		struct ttm_pl_waitidle_arg)
-#define DRM_IOCTL_PSB_TTM_PL_SETSTATUS \
-	DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_TTM_PL_SETSTATUS,\
-		 union ttm_pl_setstatus_arg)
-#define DRM_IOCTL_PSB_TTM_PL_CREATE_UB    \
-	DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_TTM_PL_CREATE_UB,\
-		 union ttm_pl_create_ub_arg)
-#define DRM_IOCTL_PSB_TTM_FENCE_SIGNALED \
-	DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_TTM_FENCE_SIGNALED,	\
-		  union ttm_fence_signaled_arg)
-#define DRM_IOCTL_PSB_TTM_FENCE_FINISH \
-	DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_TTM_FENCE_FINISH,	\
-		 union ttm_fence_finish_arg)
-#define DRM_IOCTL_PSB_TTM_FENCE_UNREF \
-	DRM_IOW(DRM_COMMAND_BASE + DRM_PSB_TTM_FENCE_UNREF,	\
-		 struct ttm_fence_unref_arg)
 
 static int psb_vt_leave_ioctl(struct drm_device *dev, void *data,
 			      struct drm_file *file_priv);
@@ -246,35 +182,12 @@ static struct drm_ioctl_desc psb_ioctls[] = {
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GTT_UNMAP,
 			psb_gtt_unmap_meminfo_ioctl,
 			DRM_AUTH),
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GETPAGEADDRS,
-			psb_getpageaddrs_ioctl,
-			DRM_AUTH),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_DPST, psb_dpst_ioctl, DRM_AUTH),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GAMMA, psb_gamma_ioctl, DRM_AUTH),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_DPST_BL, psb_dpst_bl_ioctl, DRM_AUTH),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GET_PIPE_FROM_CRTC_ID,
 					psb_intel_get_pipe_from_crtc_id, 0),
 
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_PL_CREATE, psb_pl_create_ioctl,
-		      DRM_AUTH),
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_PL_REFERENCE, psb_pl_reference_ioctl,
-		      DRM_AUTH),
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_PL_UNREF, psb_pl_unref_ioctl,
-		      DRM_AUTH),
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_PL_SYNCCPU, psb_pl_synccpu_ioctl,
-		      DRM_AUTH),
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_PL_WAITIDLE, psb_pl_waitidle_ioctl,
-		      DRM_AUTH),
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_PL_SETSTATUS, psb_pl_setstatus_ioctl,
-		      DRM_AUTH),
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_PL_CREATE_UB, psb_pl_ub_create_ioctl,
-		      DRM_AUTH),
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_FENCE_SIGNALED,
-		      psb_fence_signaled_ioctl, DRM_AUTH),
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_FENCE_FINISH, psb_fence_finish_ioctl,
-		      DRM_AUTH),
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_FENCE_UNREF, psb_fence_unref_ioctl,
-		      DRM_AUTH),
 };
 
 static void psb_set_uopt(struct drm_psb_uopt *uopt)
@@ -289,20 +202,7 @@ static void psb_lastclose(struct drm_device *dev)
 
 static void psb_do_takedown(struct drm_device *dev)
 {
-	struct drm_psb_private *dev_priv =
-	    (struct drm_psb_private *) dev->dev_private;
-	struct ttm_bo_device *bdev = &dev_priv->bdev;
-
-
-	if (dev_priv->have_mem_mmu) {
-		ttm_bo_clean_mm(bdev, DRM_PSB_MEM_MMU);
-		dev_priv->have_mem_mmu = 0;
-	}
-
-	if (dev_priv->have_tt) {
-		ttm_bo_clean_mm(bdev, TTM_PL_TT);
-		dev_priv->have_tt = 0;
-	}
+	/* FIXME: do we need to clean up the gtt here ? */
 }
 
 void mrst_get_fuse_settings(struct drm_device *dev)
@@ -551,7 +451,6 @@ static int psb_do_init(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv =
 	    (struct drm_psb_private *) dev->dev_private;
-	struct ttm_bo_device *bdev = &dev_priv->bdev;
 	struct psb_gtt *pg = dev_priv->pg;
 
 	uint32_t stolen_gtt;
@@ -560,16 +459,6 @@ static int psb_do_init(struct drm_device *dev)
 
 	int ret = -ENOMEM;
 
-
-	/*
-	 * Initialize sequence numbers for the different command
-	 * submission mechanisms.
-	 */
-
-	dev_priv->sequence[PSB_ENGINE_2D] = 0;
-	dev_priv->sequence[PSB_ENGINE_VIDEO] = 0;
-	dev_priv->sequence[LNC_ENGINE_ENCODE] = 0;
-
 	if (pg->mmu_gatt_start & 0x0FFFFFFF) {
 		DRM_ERROR("Gatt must be 256M aligned. This is a bug.\n");
 		ret = -EINVAL;
@@ -620,22 +509,6 @@ static int psb_do_init(struct drm_device *dev)
        
       	PSB_WSGX32(pg->mmu_gatt_start, PSB_CR_BIF_TWOD_REQ_BASE);
 
-	/* TT region managed by TTM. */
-	if (!ttm_bo_init_mm(bdev, TTM_PL_TT, pg->gatt_pages)) {
-		dev_priv->have_tt = 1;
-		dev_priv->sizes.tt_size =
-			(tt_pages << PAGE_SHIFT) / (1024 * 1024) / 2;
-	}
-
-	if (!ttm_bo_init_mm(bdev,
-			DRM_PSB_MEM_MMU,
-			PSB_MEM_TT_START >> PAGE_SHIFT)) {
-		dev_priv->have_mem_mmu = 1;
-		dev_priv->sizes.mmu_size =
-			PSB_MEM_TT_START / (1024*1024);
-	}
-
-	PSB_DEBUG_INIT("Init MSVDX\n");
 	return 0;
 out_err:
 	psb_do_takedown(dev);
@@ -682,14 +555,6 @@ static int psb_driver_unload(struct drm_device *dev)
 			__free_page(dev_priv->scratch_page);
 			dev_priv->scratch_page = NULL;
 		}
-		if (dev_priv->has_bo_device) {
-			ttm_bo_device_release(&dev_priv->bdev);
-			dev_priv->has_bo_device = 0;
-		}
-		if (dev_priv->has_fence_device) {
-			ttm_fence_device_release(&dev_priv->fdev);
-			dev_priv->has_fence_device = 0;
-		}
 		if (dev_priv->vdc_reg) {
 			iounmap(dev_priv->vdc_reg);
 			dev_priv->vdc_reg = NULL;
@@ -699,12 +564,6 @@ static int psb_driver_unload(struct drm_device *dev)
 			dev_priv->sgx_reg = NULL;
 		}
 
-		if (dev_priv->tdev)
-			ttm_object_device_release(&dev_priv->tdev);
-
-		if (dev_priv->has_global)
-			psb_ttm_global_release(dev_priv);
-
 		kfree(dev_priv);
 		dev->dev_private = NULL;
 
@@ -721,7 +580,6 @@ static int psb_driver_unload(struct drm_device *dev)
 static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 {
 	struct drm_psb_private *dev_priv;
-	struct ttm_bo_device *bdev;
 	unsigned long resource_start;
 	struct psb_gtt *pg;
 	unsigned long irqflags;
@@ -738,24 +596,10 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 		dev_priv->num_pipe = 2;
 
 	dev_priv->dev = dev;
-	bdev = &dev_priv->bdev;
-
-	ret = psb_ttm_global_init(dev_priv);
-	if (unlikely(ret != 0))
-		goto out_err;
-	dev_priv->has_global = 1;
-
-	dev_priv->tdev = ttm_object_device_init
-		(dev_priv->mem_global_ref.object, PSB_OBJECT_HASH_ORDER);
-	if (unlikely(dev_priv->tdev == NULL))
-		goto out_err;
 
 	mutex_init(&dev_priv->temp_mem);
 	mutex_init(&dev_priv->cmdbuf_mutex);
 	mutex_init(&dev_priv->reset_mutex);
-
-/*	mutex_init(&dev_priv->dsr_mutex); */
-
 	spin_lock_init(&dev_priv->reloc_lock);
 
 	DRM_INIT_WAITQUEUE(&dev_priv->rel_mapped_queue);
@@ -788,25 +632,9 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 		psb_intel_init_bios(dev);
 	}
 
-	PSB_DEBUG_INIT("Init TTM fence and BO driver\n");
-
 	/* Init OSPM support */
 	ospm_power_init(dev);
 
-	ret = psb_ttm_fence_device_init(&dev_priv->fdev);
-	if (unlikely(ret != 0))
-		goto out_err;
-
-	dev_priv->has_fence_device = 1;
-	ret = ttm_bo_device_init(bdev,
-				 dev_priv->bo_global_ref.ref.object,
-				 &psb_ttm_bo_driver,
-				 DRM_PSB_FILE_PAGE_OFFSET, false);
-	if (unlikely(ret != 0))
-		goto out_err;
-	dev_priv->has_bo_device = 1;
-	ttm_lock_init(&dev_priv->ttm_lock);
-
 	ret = -ENOMEM;
 
 	dev_priv->scratch_page = alloc_page(GFP_DMA32 | __GFP_ZERO);
@@ -846,10 +674,6 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	psb_mmu_set_pd_context(psb_mmu_get_default_pd(dev_priv->mmu), 0);
 	psb_mmu_set_pd_context(dev_priv->pf_pd, 1);
 
-	spin_lock_init(&dev_priv->sequence_lock);
-
-	PSB_DEBUG_INIT("Begin to init MSVDX/Topaz\n");
-
 	ret = psb_do_init(dev);
 	if (ret)
 		return ret;
@@ -901,11 +725,6 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 #endif
 	/*Intel drm driver load is done, continue doing pvr load*/
 	DRM_DEBUG("Pvr driver load\n");
-
-/*	if (PVRCore_Init() < 0)
-		goto out_err; */
-/*	if (MRSTLFBInit(dev) < 0)
-		goto out_err;*/
 	return 0;
 out_err:
 	psb_driver_unload(dev);
@@ -921,40 +740,13 @@ int psb_driver_device_is_agp(struct drm_device *dev)
 static int psb_vt_leave_ioctl(struct drm_device *dev, void *data,
 			      struct drm_file *file_priv)
 {
-	struct drm_psb_private *dev_priv = psb_priv(dev);
-	struct ttm_bo_device *bdev = &dev_priv->bdev;
-	struct ttm_mem_type_manager *man;
-	int ret;
-
-	ret = ttm_vt_lock(&dev_priv->ttm_lock, 1,
-			     psb_fpriv(file_priv)->tfile);
-	if (unlikely(ret != 0))
-		return ret;
-
-	ret = ttm_bo_evict_mm(&dev_priv->bdev, TTM_PL_TT);
-	if (unlikely(ret != 0))
-		goto out_unlock;
-
-	man = &bdev->man[TTM_PL_TT];
-
-#if 0		/* What to do with this ? */
-	if (unlikely(!drm_mm_clean(&man->manager)))
-		DRM_INFO("Warning: GATT was not clean after VT switch.\n");
-#endif
-
-	ttm_bo_swapout_all(&dev_priv->bdev);
-
 	return 0;
-out_unlock:
-	(void) ttm_vt_unlock(&dev_priv->ttm_lock);
-	return ret;
 }
 
 static int psb_vt_enter_ioctl(struct drm_device *dev, void *data,
 			      struct drm_file *file_priv)
 {
-	struct drm_psb_private *dev_priv = psb_priv(dev);
-	return ttm_vt_unlock(&dev_priv->ttm_lock);
+	return 0;
 }
 
 static int psb_sizes_ioctl(struct drm_device *dev, void *data,
@@ -1636,8 +1428,7 @@ static long psb_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		dev_priv->rpm_enabled = 1;
 	}
 	/*
-	 * The driver private ioctls and TTM ioctls should be
-	 * thread-safe.
+	 * The driver private ioctls should be thread-safe.
 	 */
 
 	if ((nr >= DRM_COMMAND_BASE) && (nr < DRM_COMMAND_END)
@@ -1675,6 +1466,16 @@ static void psb_remove(struct pci_dev *pdev)
 	drm_put_dev(dev);
 }
 
+static int psb_open(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+static int psb_release(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
 
 static const struct dev_pm_ops psb_pm_ops = {
 	.runtime_suspend = psb_runtime_suspend,
@@ -1714,7 +1515,7 @@ static struct drm_driver driver = {
 		 .open = psb_open,
 		 .release = psb_release,
 		 .unlocked_ioctl = psb_unlocked_ioctl,
-		 .mmap = psb_mmap,
+		/* .mmap = psb_mmap, */
 		 .poll = psb_poll,
 		 .fasync = drm_fasync,
 		 .read = drm_read,
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index c2fd475..aad09fb 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -30,11 +30,6 @@
 #include "psb_gtt.h"
 #include "psb_powermgmt.h"
 #include "mrst.h"
-#include "ttm/ttm_object.h"
-#include "psb_ttm_fence_driver.h"
-#include "psb_ttm_userobj_api.h"
-#include "ttm/ttm_bo_driver.h"
-#include "ttm/ttm_lock.h"
 
 /*Append new drm mode definition here, align with libdrm definition*/
 #define DRM_MODE_SCALE_NO_SCALE   2
@@ -92,9 +87,6 @@ enum {
 #define PSB_TT_PRIV0_PLIMIT	 (PSB_TT_PRIV0_LIMIT >> PAGE_SHIFT)
 #define PSB_NUM_VALIDATE_BUFFERS 2048
 
-#define PSB_MEM_MMU_START       0x00000000
-#define PSB_MEM_TT_START        0xE0000000
-
 /*
  *Flags for external memory type field.
  */
@@ -251,22 +243,8 @@ struct drm_psb_private {
 	void * dbi_dsr_info;
 	void * dsi_configs[2];
 
-	/*
-	 *TTM Glue.
-	 */
-
-	struct drm_global_reference mem_global_ref;
-	struct ttm_bo_global_ref bo_global_ref;
-	int has_global;
-
 	struct drm_device *dev;
-	struct ttm_object_device *tdev;
-	struct ttm_fence_device fdev;
-	struct ttm_bo_device bdev;
-	struct ttm_lock ttm_lock;
 	struct vm_operations_struct *ttm_vm_ops;
-	int has_fence_device;
-	int has_bo_device;
 
 	unsigned long chipset;
 
@@ -276,11 +254,7 @@ struct drm_psb_private {
 
 	/*GTT Memory manager*/
 	struct psb_gtt_mm *gtt_mm;
-
 	struct page *scratch_page;
-	uint32_t sequence[PSB_NUM_ENGINES];
-	uint32_t last_sequence[PSB_NUM_ENGINES];
-	uint32_t last_submitted_seq[PSB_NUM_ENGINES];
 
 	struct psb_mmu_driver *mmu;
 	struct psb_mmu_pd *pf_pd;
@@ -299,7 +273,6 @@ struct drm_psb_private {
 	bool vblanksEnabledForFlips;
 
 	spinlock_t irqmask_lock;
-	spinlock_t sequence_lock;
 
 	/*
 	 *Modesetting
@@ -637,46 +610,6 @@ static inline struct drm_psb_private *psb_priv(struct drm_device *dev)
 }
 
 /*
- *TTM glue. psb_ttm_glue.c
- */
-
-extern int psb_open(struct inode *inode, struct file *filp);
-extern int psb_release(struct inode *inode, struct file *filp);
-extern int psb_mmap(struct file *filp, struct vm_area_struct *vma);
-
-extern int psb_fence_signaled_ioctl(struct drm_device *dev, void *data,
-				    struct drm_file *file_priv);
-extern int psb_verify_access(struct ttm_buffer_object *bo,
-			     struct file *filp);
-extern ssize_t psb_ttm_read(struct file *filp, char __user *buf,
-			    size_t count, loff_t *f_pos);
-extern ssize_t psb_ttm_write(struct file *filp, const char __user *buf,
-			    size_t count, loff_t *f_pos);
-extern int psb_fence_finish_ioctl(struct drm_device *dev, void *data,
-				  struct drm_file *file_priv);
-extern int psb_fence_unref_ioctl(struct drm_device *dev, void *data,
-				 struct drm_file *file_priv);
-extern int psb_pl_waitidle_ioctl(struct drm_device *dev, void *data,
-				 struct drm_file *file_priv);
-extern int psb_pl_setstatus_ioctl(struct drm_device *dev, void *data,
-				  struct drm_file *file_priv);
-extern int psb_pl_synccpu_ioctl(struct drm_device *dev, void *data,
-				struct drm_file *file_priv);
-extern int psb_pl_unref_ioctl(struct drm_device *dev, void *data,
-			      struct drm_file *file_priv);
-extern int psb_pl_reference_ioctl(struct drm_device *dev, void *data,
-				  struct drm_file *file_priv);
-extern int psb_pl_create_ioctl(struct drm_device *dev, void *data,
-			       struct drm_file *file_priv);
-extern int psb_pl_ub_create_ioctl(struct drm_device *dev, void *data,
-			       struct drm_file *file_priv);
-extern int psb_extension_ioctl(struct drm_device *dev, void *data,
-			       struct drm_file *file_priv);
-extern int psb_ttm_global_init(struct drm_psb_private *dev_priv);
-extern void psb_ttm_global_release(struct drm_psb_private *dev_priv);
-extern int psb_getpageaddrs_ioctl(struct drm_device *dev, void *data,
-				struct drm_file *file_priv);
-/*
  *MMU stuff.
  */
 
@@ -719,26 +652,6 @@ extern void psb_mmu_remove_pages(struct psb_mmu_pd *pd,
 				 uint32_t desired_tile_stride,
 				 uint32_t hw_tile_stride);
 /*
- *psb_sgx.c
- */
-
-
-
-extern int psb_cmdbuf_ioctl(struct drm_device *dev, void *data,
-			    struct drm_file *file_priv);
-extern int psb_reg_submit(struct drm_psb_private *dev_priv,
-			  uint32_t *regs, unsigned int cmds);
-
-
-extern void psb_fence_or_sync(struct drm_file *file_priv,
-			      uint32_t engine,
-			      uint32_t fence_types,
-			      uint32_t fence_flags,
-			      struct list_head *list,
-			      struct psb_ttm_fence_rep *fence_arg,
-			      struct ttm_fence_object **fence_p);
-
-/*
  *psb_irq.c
  */
 
@@ -767,29 +680,6 @@ psb_disable_pipestat(struct drm_psb_private *dev_priv, int pipe, u32 mask);
 extern u32 psb_get_vblank_counter(struct drm_device *dev, int crtc);
 
 /*
- *psb_fence.c
- */
-
-extern void psb_fence_handler(struct drm_device *dev, uint32_t class);
-
-extern int psb_fence_emit_sequence(struct ttm_fence_device *fdev,
-				   uint32_t fence_class,
-				   uint32_t flags, uint32_t *sequence,
-				   unsigned long *timeout_jiffies);
-extern void psb_fence_error(struct drm_device *dev,
-			    uint32_t class,
-			    uint32_t sequence, uint32_t type, int error);
-extern int psb_ttm_fence_device_init(struct ttm_fence_device *fdev);
-
-/* MSVDX/Topaz stuff */
-extern int psb_remove_videoctx(struct drm_psb_private *dev_priv, struct file *filp);
-
-extern int lnc_video_frameskip(struct drm_device *dev,
-			       uint64_t user_pointer);
-extern int lnc_video_getparam(struct drm_device *dev, void *data,
-			      struct drm_file *file_priv);
-
-/*
  * psb_opregion.c
  */
 extern int psb_intel_opregion_init(struct drm_device *dev);
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 53a270e..c15e2f9 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -36,9 +36,7 @@
 #include "psb_drv.h"
 #include "psb_intel_reg.h"
 #include "psb_intel_drv.h"
-#include "psb_ttm_userobj_api.h"
 #include "psb_fb.h"
-#include "psb_sgx.h"
 #include "psb_pvr_glue.h"
 
 static void psb_user_framebuffer_destroy(struct drm_framebuffer *fb);
@@ -317,6 +315,8 @@ static struct drm_framebuffer *psb_user_framebuffer_create
 			(struct drm_device *dev, struct drm_file *filp,
 			 struct drm_mode_fb_cmd *r)
 {
+        return NULL;
+#if 0
 	struct ttm_buffer_object *bo = NULL;
 	uint64_t size;
 
@@ -332,7 +332,6 @@ static struct drm_framebuffer *psb_user_framebuffer_create
 	/* JB: TODO not drop, refcount buffer */
 	return psb_framebuffer_create(dev, r, bo);
 
-#if 0
 	struct psb_framebuffer *psbfb;
 	struct drm_framebuffer *fb;
 	struct fb_info *info;
diff --git a/drivers/staging/gma500/psb_fence.c b/drivers/staging/gma500/psb_fence.c
deleted file mode 100644
index a70aa64..0000000
--- a/drivers/staging/gma500/psb_fence.c
+++ /dev/null
@@ -1,122 +0,0 @@
-/*
- * Copyright (c) 2007, Intel Corporation.
- * All Rights Reserved.
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
- *
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
- */
-
-#include <drm/drmP.h>
-#include "psb_drv.h"
-
-
-static void psb_fence_poll(struct ttm_fence_device *fdev,
-			   uint32_t fence_class, uint32_t waiting_types)
-{
-	struct drm_psb_private *dev_priv =
-	    container_of(fdev, struct drm_psb_private, fdev);
-
-
-	if (unlikely(!dev_priv))
-		return;
-
-	if (waiting_types == 0)
-		return;
-
-	/* DRM_ERROR("Polling fence sequence, got 0x%08x\n", sequence); */
-	ttm_fence_handler(fdev, fence_class, 0 /* Sequence */,
-			_PSB_FENCE_TYPE_EXE, 0);
-}
-
-void psb_fence_error(struct drm_device *dev,
-		     uint32_t fence_class,
-		     uint32_t sequence, uint32_t type, int error)
-{
-	struct drm_psb_private *dev_priv = psb_priv(dev);
-	struct ttm_fence_device *fdev = &dev_priv->fdev;
-	unsigned long irq_flags;
-	struct ttm_fence_class_manager *fc =
-	    &fdev->fence_class[fence_class];
-
-	BUG_ON(fence_class >= PSB_NUM_ENGINES);
-	write_lock_irqsave(&fc->lock, irq_flags);
-	ttm_fence_handler(fdev, fence_class, sequence, type, error);
-	write_unlock_irqrestore(&fc->lock, irq_flags);
-}
-
-int psb_fence_emit_sequence(struct ttm_fence_device *fdev,
-			    uint32_t fence_class,
-			    uint32_t flags, uint32_t *sequence,
-			    unsigned long *timeout_jiffies)
-{
-	struct drm_psb_private *dev_priv =
-	    container_of(fdev, struct drm_psb_private, fdev);
-
-	if (!dev_priv)
-		return -EINVAL;
-
-	if (fence_class >= PSB_NUM_ENGINES)
-		return -EINVAL;
-
-	DRM_ERROR("Unexpected fence class\n");
-	return -EINVAL;
-}
-
-static void psb_fence_lockup(struct ttm_fence_object *fence,
-			     uint32_t fence_types)
-{
-	DRM_ERROR("Unsupported fence class\n");
-}
-
-void psb_fence_handler(struct drm_device *dev, uint32_t fence_class)
-{
-	struct drm_psb_private *dev_priv = psb_priv(dev);
-	struct ttm_fence_device *fdev = &dev_priv->fdev;
-	struct ttm_fence_class_manager *fc =
-	    &fdev->fence_class[fence_class];
-	unsigned long irq_flags;
-
-	write_lock_irqsave(&fc->lock, irq_flags);
-	psb_fence_poll(fdev, fence_class, fc->waiting_types);
-	write_unlock_irqrestore(&fc->lock, irq_flags);
-}
-
-
-static struct ttm_fence_driver psb_ttm_fence_driver = {
-	.has_irq = NULL,
-	.emit = psb_fence_emit_sequence,
-	.flush = NULL,
-	.poll = psb_fence_poll,
-	.needed_flush = NULL,
-	.wait = NULL,
-	.signaled = NULL,
-	.lockup = psb_fence_lockup,
-};
-
-int psb_ttm_fence_device_init(struct ttm_fence_device *fdev)
-{
-	struct drm_psb_private *dev_priv =
-		container_of(fdev, struct drm_psb_private, fdev);
-	struct ttm_fence_class_init fci = {.wrap_diff = (1 << 30),
-		.flush_diff = (1 << 29),
-		.sequence_mask = 0xFFFFFFFF
-	};
-
-	return ttm_fence_device_init(PSB_NUM_ENGINES,
-				     dev_priv->mem_global_ref.object,
-				     fdev, &fci, 1,
-				     &psb_ttm_fence_driver);
-}
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index d129b75..c1283e8 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -101,7 +101,7 @@ int psb_gtt_init(struct psb_gtt *pg, int resume)
 	pg->gatt_start = pci_resource_start(dev->pdev, PSB_GATT_RESOURCE);
 	/* fix me: video mmu has hw bug to access 0x0D0000000,
 	 * then make gatt start at 0x0e000,0000 */
-	pg->mmu_gatt_start = PSB_MEM_TT_START;
+	pg->mmu_gatt_start = 0xE0000000;
 	pg->gtt_start = pci_resource_start(dev->pdev, PSB_GTT_RESOURCE);
 	gtt_pages =
 	    pci_resource_len(dev->pdev, PSB_GTT_RESOURCE) >> PAGE_SHIFT;
diff --git a/drivers/staging/gma500/psb_sgx.c b/drivers/staging/gma500/psb_sgx.c
deleted file mode 100644
index 91fbb6a..0000000
--- a/drivers/staging/gma500/psb_sgx.c
+++ /dev/null
@@ -1,131 +0,0 @@
-/**************************************************************************
- * Copyright (c) 2007, Intel Corporation.
- * All Rights Reserved.
- * Copyright (c) 2008, Tungsten Graphics, Inc. Cedar Park, TX. USA.
- * All Rights Reserved.
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
- **************************************************************************/
-
-#include <drm/drmP.h>
-#include "psb_drv.h"
-#include "psb_drm.h"
-#include "psb_reg.h"
-#include "ttm/ttm_bo_api.h"
-#include "ttm/ttm_execbuf_util.h"
-#include "psb_ttm_userobj_api.h"
-#include "ttm/ttm_placement.h"
-#include "psb_sgx.h"
-#include "psb_intel_reg.h"
-#include "psb_powermgmt.h"
-
-
-static inline int psb_same_page(unsigned long offset,
-				unsigned long offset2)
-{
-	return (offset & PAGE_MASK) == (offset2 & PAGE_MASK);
-}
-
-static inline unsigned long psb_offset_end(unsigned long offset,
-					      unsigned long end)
-{
-	offset = (offset + PAGE_SIZE) & PAGE_MASK;
-	return (end < offset) ? end : offset;
-}
-
-struct psb_dstbuf_cache {
-	unsigned int dst;
-	struct ttm_buffer_object *dst_buf;
-	unsigned long dst_offset;
-	uint32_t *dst_page;
-	unsigned int dst_page_offset;
-	struct ttm_bo_kmap_obj dst_kmap;
-	bool dst_is_iomem;
-};
-
-struct psb_validate_buffer {
-	struct ttm_validate_buffer base;
-	struct psb_validate_req req;
-	int ret;
-	struct psb_validate_arg __user *user_val_arg;
-	uint32_t flags;
-	uint32_t offset;
-	int po_correct;
-};
-void psb_fence_or_sync(struct drm_file *file_priv,
-		       uint32_t engine,
-		       uint32_t fence_types,
-		       uint32_t fence_flags,
-		       struct list_head *list,
-		       struct psb_ttm_fence_rep *fence_arg,
-		       struct ttm_fence_object **fence_p)
-{
-	struct drm_device *dev = file_priv->minor->dev;
-	struct drm_psb_private *dev_priv = psb_priv(dev);
-	struct ttm_fence_device *fdev = &dev_priv->fdev;
-	int ret;
-	struct ttm_fence_object *fence;
-	struct ttm_object_file *tfile = psb_fpriv(file_priv)->tfile;
-	uint32_t handle;
-
-	ret = ttm_fence_user_create(fdev, tfile,
-				    engine, fence_types,
-				    TTM_FENCE_FLAG_EMIT, &fence, &handle);
-	if (ret) {
-
-		/*
-		 * Fence creation failed.
-		 * Fall back to synchronous operation and idle the engine.
-		 */
-
-		if (!(fence_flags & DRM_PSB_FENCE_NO_USER)) {
-
-			/*
-			 * Communicate to user-space that
-			 * fence creation has failed and that
-			 * the engine is idle.
-			 */
-
-			fence_arg->handle = ~0;
-			fence_arg->error = ret;
-		}
-
-		ttm_eu_backoff_reservation(list);
-		if (fence_p)
-			*fence_p = NULL;
-		return;
-	}
-
-	ttm_eu_fence_buffer_objects(list, fence);
-	if (!(fence_flags & DRM_PSB_FENCE_NO_USER)) {
-		struct ttm_fence_info info = ttm_fence_get_info(fence);
-		fence_arg->handle = handle;
-		fence_arg->fence_class = ttm_fence_class(fence);
-		fence_arg->fence_type = ttm_fence_types(fence);
-		fence_arg->signaled_types = info.signaled_types;
-		fence_arg->error = 0;
-	} else {
-		ret =
-		    ttm_ref_object_base_unref(tfile, handle,
-					      ttm_fence_type);
-		BUG_ON(ret);
-	}
-
-	if (fence_p)
-		*fence_p = fence;
-	else if (fence)
-		ttm_fence_object_unref(&fence);
-}
-
diff --git a/drivers/staging/gma500/psb_sgx.h b/drivers/staging/gma500/psb_sgx.h
deleted file mode 100644
index 9300e2d..0000000
--- a/drivers/staging/gma500/psb_sgx.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * Copyright (c) 2008, Intel Corporation
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
- * Authors:
- *    Eric Anholt <eric@anholt.net>
- *
- **/
-#ifndef _PSB_SGX_H_
-#define _PSB_SGX_H_
-
-extern int psb_submit_video_cmdbuf(struct drm_device *dev,
-			       struct ttm_buffer_object *cmd_buffer,
-			       unsigned long cmd_offset,
-			       unsigned long cmd_size,
-			       struct ttm_fence_object *fence);
-
-extern int drm_idle_check_interval;
-
-#endif
diff --git a/drivers/staging/gma500/psb_ttm_fence.c b/drivers/staging/gma500/psb_ttm_fence.c
deleted file mode 100644
index d1c3590..0000000
--- a/drivers/staging/gma500/psb_ttm_fence.c
+++ /dev/null
@@ -1,605 +0,0 @@
-/**************************************************************************
- *
- * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
- * All Rights Reserved.
- * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
- * All Rights Reserved.
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
- **************************************************************************/
-/*
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
- */
-
-#include "psb_ttm_fence_api.h"
-#include "psb_ttm_fence_driver.h"
-#include <linux/wait.h>
-#include <linux/sched.h>
-
-#include <drm/drmP.h>
-
-/*
- * Simple implementation for now.
- */
-
-static void ttm_fence_lockup(struct ttm_fence_object *fence, uint32_t mask)
-{
-	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
-
-	printk(KERN_ERR "GPU lockup dectected on engine %u "
-	       "fence type 0x%08x\n",
-	       (unsigned int)fence->fence_class, (unsigned int)mask);
-	/*
-	 * Give engines some time to idle?
-	 */
-
-	write_lock(&fc->lock);
-	ttm_fence_handler(fence->fdev, fence->fence_class,
-			  fence->sequence, mask, -EBUSY);
-	write_unlock(&fc->lock);
-}
-
-/*
- * Convenience function to be called by fence::wait methods that
- * need polling.
- */
-
-int ttm_fence_wait_polling(struct ttm_fence_object *fence, bool lazy,
-			   bool interruptible, uint32_t mask)
-{
-	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
-	const struct ttm_fence_driver *driver = ttm_fence_driver(fence);
-	uint32_t count = 0;
-	int ret;
-	unsigned long end_jiffies = fence->timeout_jiffies;
-
-	DECLARE_WAITQUEUE(entry, current);
-	add_wait_queue(&fc->fence_queue, &entry);
-
-	ret = 0;
-
-	for (;;) {
-		__set_current_state((interruptible) ?
-				    TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE);
-		if (ttm_fence_object_signaled(fence, mask))
-			break;
-		if (time_after_eq(jiffies, end_jiffies)) {
-			if (driver->lockup)
-				driver->lockup(fence, mask);
-			else
-				ttm_fence_lockup(fence, mask);
-			continue;
-		}
-		if (lazy)
-			schedule_timeout(1);
-		else if ((++count & 0x0F) == 0) {
-			__set_current_state(TASK_RUNNING);
-			schedule();
-			__set_current_state((interruptible) ?
-					    TASK_INTERRUPTIBLE :
-					    TASK_UNINTERRUPTIBLE);
-		}
-		if (interruptible && signal_pending(current)) {
-			ret = -ERESTART;
-			break;
-		}
-	}
-	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&fc->fence_queue, &entry);
-	return ret;
-}
-
-/*
- * Typically called by the IRQ handler.
- */
-
-void ttm_fence_handler(struct ttm_fence_device *fdev, uint32_t fence_class,
-		       uint32_t sequence, uint32_t type, uint32_t error)
-{
-	int wake = 0;
-	uint32_t diff;
-	uint32_t relevant_type;
-	uint32_t new_type;
-	struct ttm_fence_class_manager *fc = &fdev->fence_class[fence_class];
-	const struct ttm_fence_driver *driver = ttm_fence_driver_from_dev(fdev);
-	struct list_head *head;
-	struct ttm_fence_object *fence, *next;
-	bool found = false;
-
-	if (list_empty(&fc->ring))
-		return;
-
-	list_for_each_entry(fence, &fc->ring, ring) {
-		diff = (sequence - fence->sequence) & fc->sequence_mask;
-		if (diff > fc->wrap_diff) {
-			found = true;
-			break;
-		}
-	}
-
-	fc->waiting_types &= ~type;
-	head = (found) ? &fence->ring : &fc->ring;
-
-	list_for_each_entry_safe_reverse(fence, next, head, ring) {
-		if (&fence->ring == &fc->ring)
-			break;
-
-		DRM_DEBUG("Fence 0x%08lx, sequence 0x%08x, type 0x%08x\n",
-			  (unsigned long)fence, fence->sequence,
-			  fence->fence_type);
-
-		if (error) {
-			fence->info.error = error;
-			fence->info.signaled_types = fence->fence_type;
-			list_del_init(&fence->ring);
-			wake = 1;
-			break;
-		}
-
-		relevant_type = type & fence->fence_type;
-		new_type = (fence->info.signaled_types | relevant_type) ^
-		    fence->info.signaled_types;
-
-		if (new_type) {
-			fence->info.signaled_types |= new_type;
-			DRM_DEBUG("Fence 0x%08lx signaled 0x%08x\n",
-				  (unsigned long)fence,
-				  fence->info.signaled_types);
-
-			if (unlikely(driver->signaled))
-				driver->signaled(fence);
-
-			if (driver->needed_flush)
-				fc->pending_flush |=
-				    driver->needed_flush(fence);
-
-			if (new_type & fence->waiting_types)
-				wake = 1;
-		}
-
-		fc->waiting_types |=
-		    fence->waiting_types & ~fence->info.signaled_types;
-
-		if (!(fence->fence_type & ~fence->info.signaled_types)) {
-			DRM_DEBUG("Fence completely signaled 0x%08lx\n",
-				  (unsigned long)fence);
-			list_del_init(&fence->ring);
-		}
-	}
-
-	/*
-	 * Reinstate lost waiting types.
-	 */
-
-	if ((fc->waiting_types & type) != type) {
-		head = head->prev;
-		list_for_each_entry(fence, head, ring) {
-			if (&fence->ring == &fc->ring)
-				break;
-			diff =
-			    (fc->highest_waiting_sequence -
-			     fence->sequence) & fc->sequence_mask;
-			if (diff > fc->wrap_diff)
-				break;
-
-			fc->waiting_types |=
-			    fence->waiting_types & ~fence->info.signaled_types;
-		}
-	}
-
-	if (wake)
-		wake_up_all(&fc->fence_queue);
-}
-
-static void ttm_fence_unring(struct ttm_fence_object *fence)
-{
-	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
-	unsigned long irq_flags;
-
-	write_lock_irqsave(&fc->lock, irq_flags);
-	list_del_init(&fence->ring);
-	write_unlock_irqrestore(&fc->lock, irq_flags);
-}
-
-bool ttm_fence_object_signaled(struct ttm_fence_object *fence, uint32_t mask)
-{
-	unsigned long flags;
-	bool signaled;
-	const struct ttm_fence_driver *driver = ttm_fence_driver(fence);
-	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
-
-	mask &= fence->fence_type;
-	read_lock_irqsave(&fc->lock, flags);
-	signaled = (mask & fence->info.signaled_types) == mask;
-	read_unlock_irqrestore(&fc->lock, flags);
-	if (!signaled && driver->poll) {
-		write_lock_irqsave(&fc->lock, flags);
-		driver->poll(fence->fdev, fence->fence_class, mask);
-		signaled = (mask & fence->info.signaled_types) == mask;
-		write_unlock_irqrestore(&fc->lock, flags);
-	}
-	return signaled;
-}
-
-int ttm_fence_object_flush(struct ttm_fence_object *fence, uint32_t type)
-{
-	const struct ttm_fence_driver *driver = ttm_fence_driver(fence);
-	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
-	unsigned long irq_flags;
-	uint32_t saved_pending_flush;
-	uint32_t diff;
-	bool call_flush;
-
-	if (type & ~fence->fence_type) {
-		DRM_ERROR("Flush trying to extend fence type, "
-			  "0x%x, 0x%x\n", type, fence->fence_type);
-		return -EINVAL;
-	}
-
-	write_lock_irqsave(&fc->lock, irq_flags);
-	fence->waiting_types |= type;
-	fc->waiting_types |= fence->waiting_types;
-	diff = (fence->sequence - fc->highest_waiting_sequence) &
-	    fc->sequence_mask;
-
-	if (diff < fc->wrap_diff)
-		fc->highest_waiting_sequence = fence->sequence;
-
-	/*
-	 * fence->waiting_types has changed. Determine whether
-	 * we need to initiate some kind of flush as a result of this.
-	 */
-
-	saved_pending_flush = fc->pending_flush;
-	if (driver->needed_flush)
-		fc->pending_flush |= driver->needed_flush(fence);
-
-	if (driver->poll)
-		driver->poll(fence->fdev, fence->fence_class,
-			     fence->waiting_types);
-
-	call_flush = (fc->pending_flush != 0);
-	write_unlock_irqrestore(&fc->lock, irq_flags);
-
-	if (call_flush && driver->flush)
-		driver->flush(fence->fdev, fence->fence_class);
-
-	return 0;
-}
-
-/*
- * Make sure old fence objects are signaled before their fence sequences are
- * wrapped around and reused.
- */
-
-void ttm_fence_flush_old(struct ttm_fence_device *fdev,
-			 uint32_t fence_class, uint32_t sequence)
-{
-	struct ttm_fence_class_manager *fc = &fdev->fence_class[fence_class];
-	struct ttm_fence_object *fence;
-	unsigned long irq_flags;
-	const struct ttm_fence_driver *driver = fdev->driver;
-	bool call_flush;
-
-	uint32_t diff;
-
-	write_lock_irqsave(&fc->lock, irq_flags);
-
-	list_for_each_entry_reverse(fence, &fc->ring, ring) {
-		diff = (sequence - fence->sequence) & fc->sequence_mask;
-		if (diff <= fc->flush_diff)
-			break;
-
-		fence->waiting_types = fence->fence_type;
-		fc->waiting_types |= fence->fence_type;
-
-		if (driver->needed_flush)
-			fc->pending_flush |= driver->needed_flush(fence);
-	}
-
-	if (driver->poll)
-		driver->poll(fdev, fence_class, fc->waiting_types);
-
-	call_flush = (fc->pending_flush != 0);
-	write_unlock_irqrestore(&fc->lock, irq_flags);
-
-	if (call_flush && driver->flush)
-		driver->flush(fdev, fence->fence_class);
-
-	/*
-	 * FIXME: Shold we implement a wait here for really old fences?
-	 */
-
-}
-
-int ttm_fence_object_wait(struct ttm_fence_object *fence,
-			  bool lazy, bool interruptible, uint32_t mask)
-{
-	const struct ttm_fence_driver *driver = ttm_fence_driver(fence);
-	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
-	int ret = 0;
-	unsigned long timeout;
-	unsigned long cur_jiffies;
-	unsigned long to_jiffies;
-
-	if (mask & ~fence->fence_type) {
-		DRM_ERROR("Wait trying to extend fence type"
-			  " 0x%08x 0x%08x\n", mask, fence->fence_type);
-		BUG();
-		return -EINVAL;
-	}
-
-	if (driver->wait)
-		return driver->wait(fence, lazy, interruptible, mask);
-
-	ttm_fence_object_flush(fence, mask);
-retry:
-	if (!driver->has_irq ||
-	    driver->has_irq(fence->fdev, fence->fence_class, mask)) {
-
-		cur_jiffies = jiffies;
-		to_jiffies = fence->timeout_jiffies;
-
-		timeout = (time_after(to_jiffies, cur_jiffies)) ?
-		    to_jiffies - cur_jiffies : 1;
-
-		if (interruptible)
-			ret = wait_event_interruptible_timeout
-			    (fc->fence_queue,
-			     ttm_fence_object_signaled(fence, mask), timeout);
-		else
-			ret = wait_event_timeout
-			    (fc->fence_queue,
-			     ttm_fence_object_signaled(fence, mask), timeout);
-
-		if (unlikely(ret == -ERESTARTSYS))
-			return -ERESTART;
-
-		if (unlikely(ret == 0)) {
-			if (driver->lockup)
-				driver->lockup(fence, mask);
-			else
-				ttm_fence_lockup(fence, mask);
-			goto retry;
-		}
-
-		return 0;
-	}
-
-	return ttm_fence_wait_polling(fence, lazy, interruptible, mask);
-}
-
-int ttm_fence_object_emit(struct ttm_fence_object *fence, uint32_t fence_flags,
-			  uint32_t fence_class, uint32_t type)
-{
-	const struct ttm_fence_driver *driver = ttm_fence_driver(fence);
-	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
-	unsigned long flags;
-	uint32_t sequence;
-	unsigned long timeout;
-	int ret;
-
-	ttm_fence_unring(fence);
-	ret = driver->emit(fence->fdev,
-			   fence_class, fence_flags, &sequence, &timeout);
-	if (ret)
-		return ret;
-
-	write_lock_irqsave(&fc->lock, flags);
-	fence->fence_class = fence_class;
-	fence->fence_type = type;
-	fence->waiting_types = 0;
-	fence->info.signaled_types = 0;
-	fence->info.error = 0;
-	fence->sequence = sequence;
-	fence->timeout_jiffies = timeout;
-	if (list_empty(&fc->ring))
-		fc->highest_waiting_sequence = sequence - 1;
-	list_add_tail(&fence->ring, &fc->ring);
-	fc->latest_queued_sequence = sequence;
-	write_unlock_irqrestore(&fc->lock, flags);
-	return 0;
-}
-
-int ttm_fence_object_init(struct ttm_fence_device *fdev,
-			  uint32_t fence_class,
-			  uint32_t type,
-			  uint32_t create_flags,
-			  void (*destroy) (struct ttm_fence_object *),
-			  struct ttm_fence_object *fence)
-{
-	int ret = 0;
-
-	kref_init(&fence->kref);
-	fence->fence_class = fence_class;
-	fence->fence_type = type;
-	fence->info.signaled_types = 0;
-	fence->waiting_types = 0;
-	fence->sequence = 0;
-	fence->info.error = 0;
-	fence->fdev = fdev;
-	fence->destroy = destroy;
-	INIT_LIST_HEAD(&fence->ring);
-	atomic_inc(&fdev->count);
-
-	if (create_flags & TTM_FENCE_FLAG_EMIT) {
-		ret = ttm_fence_object_emit(fence, create_flags,
-					    fence->fence_class, type);
-	}
-
-	return ret;
-}
-
-int ttm_fence_object_create(struct ttm_fence_device *fdev,
-			    uint32_t fence_class,
-			    uint32_t type,
-			    uint32_t create_flags,
-			    struct ttm_fence_object **c_fence)
-{
-	struct ttm_fence_object *fence;
-	int ret;
-
-	ret = ttm_mem_global_alloc(fdev->mem_glob,
-				   sizeof(*fence),
-				   false,
-				   false);
-	if (unlikely(ret != 0)) {
-		printk(KERN_ERR "Out of memory creating fence object\n");
-		return ret;
-	}
-
-	fence = kmalloc(sizeof(*fence), GFP_KERNEL);
-	if (!fence) {
-		printk(KERN_ERR "Out of memory creating fence object\n");
-		ttm_mem_global_free(fdev->mem_glob, sizeof(*fence));
-		return -ENOMEM;
-	}
-
-	ret = ttm_fence_object_init(fdev, fence_class, type,
-				    create_flags, NULL, fence);
-	if (ret) {
-		ttm_fence_object_unref(&fence);
-		return ret;
-	}
-	*c_fence = fence;
-
-	return 0;
-}
-
-static void ttm_fence_object_destroy(struct kref *kref)
-{
-	struct ttm_fence_object *fence =
-	    container_of(kref, struct ttm_fence_object, kref);
-	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
-	unsigned long irq_flags;
-
-	write_lock_irqsave(&fc->lock, irq_flags);
-	list_del_init(&fence->ring);
-	write_unlock_irqrestore(&fc->lock, irq_flags);
-
-	atomic_dec(&fence->fdev->count);
-	if (fence->destroy)
-		fence->destroy(fence);
-	else {
-		ttm_mem_global_free(fence->fdev->mem_glob,
-				    sizeof(*fence));
-		kfree(fence);
-	}
-}
-
-void ttm_fence_device_release(struct ttm_fence_device *fdev)
-{
-	kfree(fdev->fence_class);
-}
-
-int
-ttm_fence_device_init(int num_classes,
-		      struct ttm_mem_global *mem_glob,
-		      struct ttm_fence_device *fdev,
-		      const struct ttm_fence_class_init *init,
-		      bool replicate_init,
-		      const struct ttm_fence_driver *driver)
-{
-	struct ttm_fence_class_manager *fc;
-	const struct ttm_fence_class_init *fci;
-	int i;
-
-	fdev->mem_glob = mem_glob;
-	fdev->fence_class = kzalloc(num_classes *
-				    sizeof(*fdev->fence_class), GFP_KERNEL);
-
-	if (unlikely(!fdev->fence_class))
-		return -ENOMEM;
-
-	fdev->num_classes = num_classes;
-	atomic_set(&fdev->count, 0);
-	fdev->driver = driver;
-
-	for (i = 0; i < fdev->num_classes; ++i) {
-		fc = &fdev->fence_class[i];
-		fci = &init[(replicate_init) ? 0 : i];
-
-		fc->wrap_diff = fci->wrap_diff;
-		fc->flush_diff = fci->flush_diff;
-		fc->sequence_mask = fci->sequence_mask;
-
-		rwlock_init(&fc->lock);
-		INIT_LIST_HEAD(&fc->ring);
-		init_waitqueue_head(&fc->fence_queue);
-	}
-
-	return 0;
-}
-
-struct ttm_fence_info ttm_fence_get_info(struct ttm_fence_object *fence)
-{
-	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
-	struct ttm_fence_info tmp;
-	unsigned long irq_flags;
-
-	read_lock_irqsave(&fc->lock, irq_flags);
-	tmp = fence->info;
-	read_unlock_irqrestore(&fc->lock, irq_flags);
-
-	return tmp;
-}
-
-void ttm_fence_object_unref(struct ttm_fence_object **p_fence)
-{
-	struct ttm_fence_object *fence = *p_fence;
-
-	*p_fence = NULL;
-	(void)kref_put(&fence->kref, &ttm_fence_object_destroy);
-}
-
-/*
- * Placement / BO sync object glue.
- */
-
-bool ttm_fence_sync_obj_signaled(void *sync_obj, void *sync_arg)
-{
-	struct ttm_fence_object *fence = (struct ttm_fence_object *)sync_obj;
-	uint32_t fence_types = (uint32_t) (unsigned long)sync_arg;
-
-	return ttm_fence_object_signaled(fence, fence_types);
-}
-
-int ttm_fence_sync_obj_wait(void *sync_obj, void *sync_arg,
-			    bool lazy, bool interruptible)
-{
-	struct ttm_fence_object *fence = (struct ttm_fence_object *)sync_obj;
-	uint32_t fence_types = (uint32_t) (unsigned long)sync_arg;
-
-	return ttm_fence_object_wait(fence, lazy, interruptible, fence_types);
-}
-
-int ttm_fence_sync_obj_flush(void *sync_obj, void *sync_arg)
-{
-	struct ttm_fence_object *fence = (struct ttm_fence_object *)sync_obj;
-	uint32_t fence_types = (uint32_t) (unsigned long)sync_arg;
-
-	return ttm_fence_object_flush(fence, fence_types);
-}
-
-void ttm_fence_sync_obj_unref(void **sync_obj)
-{
-	ttm_fence_object_unref((struct ttm_fence_object **)sync_obj);
-}
-
-void *ttm_fence_sync_obj_ref(void *sync_obj)
-{
-	return (void *)
-	    ttm_fence_object_ref((struct ttm_fence_object *)sync_obj);
-}
diff --git a/drivers/staging/gma500/psb_ttm_fence_api.h b/drivers/staging/gma500/psb_ttm_fence_api.h
deleted file mode 100644
index b14a427..0000000
--- a/drivers/staging/gma500/psb_ttm_fence_api.h
+++ /dev/null
@@ -1,272 +0,0 @@
-/**************************************************************************
- *
- * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
- * All Rights Reserved.
- * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
- * All Rights Reserved.
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
- **************************************************************************/
-/*
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
- */
-#ifndef _TTM_FENCE_API_H_
-#define _TTM_FENCE_API_H_
-
-#include <linux/list.h>
-#include <linux/kref.h>
-
-#define TTM_FENCE_FLAG_EMIT (1 << 0)
-#define TTM_FENCE_TYPE_EXE  (1 << 0)
-
-struct ttm_fence_device;
-
-/**
- * struct ttm_fence_info
- *
- * @fence_class:    The fence class.
- * @fence_type:     Bitfield indicating types for this fence.
- * @signaled_types: Bitfield indicating which types are signaled.
- * @error:          Last error reported from the device.
- *
- * Used as output from the ttm_fence_get_info
- */
-
-struct ttm_fence_info {
-	uint32_t signaled_types;
-	uint32_t error;
-};
-
-/**
- * struct ttm_fence_object
- *
- * @fdev:            Pointer to the fence device struct.
- * @kref:            Holds the reference count of this fence object.
- * @ring:            List head used for the circular list of not-completely
- *                   signaled fences.
- * @info:            Data for fast retrieval using the ttm_fence_get_info()
- * function.
- * @timeout_jiffies: Absolute jiffies value indicating when this fence
- *                   object times out and, if waited on, calls ttm_fence_lockup
- *                   to check for and resolve a GPU lockup.
- * @sequence:        Fence sequence number.
- * @waiting_types:   Types currently waited on.
- * @destroy:         Called to free the fence object, when its refcount has
- *                   reached zero. If NULL, kfree is used.
- *
- * This struct is provided in the driver interface so that drivers can
- * derive from it and create their own fence implementation. All members
- * are private to the fence implementation and the fence driver callbacks.
- * Otherwise a driver may access the derived object using container_of().
- */
-
-struct ttm_fence_object {
-	struct ttm_fence_device *fdev;
-	struct kref kref;
-	uint32_t fence_class;
-	uint32_t fence_type;
-
-	/*
-	 * The below fields are protected by the fence class
-	 * manager spinlock.
-	 */
-
-	struct list_head ring;
-	struct ttm_fence_info info;
-	unsigned long timeout_jiffies;
-	uint32_t sequence;
-	uint32_t waiting_types;
-	void (*destroy) (struct ttm_fence_object *);
-};
-
-/**
- * ttm_fence_object_init
- *
- * @fdev: Pointer to a struct ttm_fence_device.
- * @fence_class: Fence class for this fence.
- * @type: Fence type for this fence.
- * @create_flags: Flags indicating varios actions at init time. At this point
- * there's only TTM_FENCE_FLAG_EMIT, which triggers a sequence emission to
- * the command stream.
- * @destroy: Destroy function. If NULL, kfree() is used.
- * @fence: The struct ttm_fence_object to initialize.
- *
- * Initialize a pre-allocated fence object. This function, together with the
- * destroy function makes it possible to derive driver-specific fence objects.
- */
-
-extern int
-ttm_fence_object_init(struct ttm_fence_device *fdev,
-		      uint32_t fence_class,
-		      uint32_t type,
-		      uint32_t create_flags,
-		      void (*destroy) (struct ttm_fence_object *fence),
-		      struct ttm_fence_object *fence);
-
-/**
- * ttm_fence_object_create
- *
- * @fdev: Pointer to a struct ttm_fence_device.
- * @fence_class: Fence class for this fence.
- * @type: Fence type for this fence.
- * @create_flags: Flags indicating varios actions at init time. At this point
- * there's only TTM_FENCE_FLAG_EMIT, which triggers a sequence emission to
- * the command stream.
- * @c_fence: On successful termination, *(@c_fence) will point to the created
- * fence object.
- *
- * Create and initialize a struct ttm_fence_object. The destroy function will
- * be set to kfree().
- */
-
-extern int
-ttm_fence_object_create(struct ttm_fence_device *fdev,
-			uint32_t fence_class,
-			uint32_t type,
-			uint32_t create_flags,
-			struct ttm_fence_object **c_fence);
-
-/**
- * ttm_fence_object_wait
- *
- * @fence: The fence object to wait on.
- * @lazy: Allow sleeps to reduce the cpu-usage if polling.
- * @interruptible: Sleep interruptible when waiting.
- * @type_mask: Wait for the given type_mask to signal.
- *
- * Wait for a fence to signal the given type_mask. The function will
- * perform a fence_flush using type_mask. (See ttm_fence_object_flush).
- *
- * Returns
- * -ERESTART if interrupted by a signal.
- * May return driver-specific error codes if timed-out.
- */
-
-extern int
-ttm_fence_object_wait(struct ttm_fence_object *fence,
-		      bool lazy, bool interruptible, uint32_t type_mask);
-
-/**
- * ttm_fence_object_flush
- *
- * @fence: The fence object to flush.
- * @flush_mask: Fence types to flush.
- *
- * Make sure that the given fence eventually signals the
- * types indicated by @flush_mask. Note that this may or may not
- * map to a CPU or GPU flush.
- */
-
-extern int
-ttm_fence_object_flush(struct ttm_fence_object *fence, uint32_t flush_mask);
-
-/**
- * ttm_fence_get_info
- *
- * @fence: The fence object.
- *
- * Copy the info block from the fence while holding relevant locks.
- */
-
-struct ttm_fence_info ttm_fence_get_info(struct ttm_fence_object *fence);
-
-/**
- * ttm_fence_object_ref
- *
- * @fence: The fence object.
- *
- * Return a ref-counted pointer to the fence object indicated by @fence.
- */
-
-static inline struct ttm_fence_object *ttm_fence_object_ref(struct
-							    ttm_fence_object
-							    *fence)
-{
-	kref_get(&fence->kref);
-	return fence;
-}
-
-/**
- * ttm_fence_object_unref
- *
- * @p_fence: Pointer to a ref-counted pinter to a struct ttm_fence_object.
- *
- * Unreference the fence object pointed to by *(@p_fence), clearing
- * *(p_fence).
- */
-
-extern void ttm_fence_object_unref(struct ttm_fence_object **p_fence);
-
-/**
- * ttm_fence_object_signaled
- *
- * @fence: Pointer to the struct ttm_fence_object.
- * @mask: Type mask to check whether signaled.
- *
- * This function checks (without waiting) whether the fence object
- * pointed to by @fence has signaled the types indicated by @mask,
- * and returns 1 if true, 0 if false. This function does NOT perform
- * an implicit fence flush.
- */
-
-extern bool
-ttm_fence_object_signaled(struct ttm_fence_object *fence, uint32_t mask);
-
-/**
- * ttm_fence_class
- *
- * @fence: Pointer to the struct ttm_fence_object.
- *
- * Convenience function that returns the fence class of a
- * struct ttm_fence_object.
- */
-
-static inline uint32_t ttm_fence_class(const struct ttm_fence_object *fence)
-{
-	return fence->fence_class;
-}
-
-/**
- * ttm_fence_types
- *
- * @fence: Pointer to the struct ttm_fence_object.
- *
- * Convenience function that returns the fence types of a
- * struct ttm_fence_object.
- */
-
-static inline uint32_t ttm_fence_types(const struct ttm_fence_object *fence)
-{
-	return fence->fence_type;
-}
-
-/*
- * The functions below are wrappers to the above functions, with
- * similar names but with sync_obj omitted. These wrappers are intended
- * to be plugged directly into the buffer object driver's sync object
- * API, if the driver chooses to use ttm_fence_objects as buffer object
- * sync objects. In the prototypes below, a sync_obj is cast to a
- * struct ttm_fence_object, whereas a sync_arg is cast to an
- * uint32_t representing a fence_type argument.
- */
-
-extern bool ttm_fence_sync_obj_signaled(void *sync_obj, void *sync_arg);
-extern int ttm_fence_sync_obj_wait(void *sync_obj, void *sync_arg,
-				   bool lazy, bool interruptible);
-extern int ttm_fence_sync_obj_flush(void *sync_obj, void *sync_arg);
-extern void ttm_fence_sync_obj_unref(void **sync_obj);
-extern void *ttm_fence_sync_obj_ref(void *sync_obj);
-
-#endif
diff --git a/drivers/staging/gma500/psb_ttm_fence_driver.h b/drivers/staging/gma500/psb_ttm_fence_driver.h
deleted file mode 100644
index c35c569..0000000
--- a/drivers/staging/gma500/psb_ttm_fence_driver.h
+++ /dev/null
@@ -1,302 +0,0 @@
-/**************************************************************************
- *
- * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
- * All Rights Reserved.
- * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
- * All Rights Reserved.
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
- **************************************************************************/
-/*
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
- */
-#ifndef _TTM_FENCE_DRIVER_H_
-#define _TTM_FENCE_DRIVER_H_
-
-#include <linux/kref.h>
-#include <linux/spinlock.h>
-#include <linux/wait.h>
-#include "psb_ttm_fence_api.h"
-#include "ttm/ttm_memory.h"
-
-/** @file ttm_fence_driver.h
- *
- * Definitions needed for a driver implementing the
- * ttm_fence subsystem.
- */
-
-/**
- * struct ttm_fence_class_manager:
- *
- * @wrap_diff: Sequence difference to catch 32-bit wrapping.
- * if (seqa - seqb) > @wrap_diff, then seqa < seqb.
- * @flush_diff: Sequence difference to trigger fence flush.
- * if (cur_seq - seqa) > @flush_diff, then consider fence object with
- * seqa as old an needing a flush.
- * @sequence_mask: Mask of valid bits in a fence sequence.
- * @lock: Lock protecting this struct as well as fence objects
- * associated with this struct.
- * @ring: Circular sequence-ordered list of fence objects.
- * @pending_flush: Fence types currently needing a flush.
- * @waiting_types: Fence types that are currently waited for.
- * @fence_queue: Queue of waiters on fences belonging to this fence class.
- * @highest_waiting_sequence: Sequence number of the fence with highest
- * sequence number and that is waited for.
- * @latest_queued_sequence: Sequence number of the fence latest queued
- * on the ring.
- */
-
-struct ttm_fence_class_manager {
-
-	/*
-	 * Unprotected constant members.
-	 */
-
-	uint32_t wrap_diff;
-	uint32_t flush_diff;
-	uint32_t sequence_mask;
-
-	/*
-	 * The rwlock protects this structure as well as
-	 * the data in all fence objects belonging to this
-	 * class. This should be OK as most fence objects are
-	 * only read from once they're created.
-	 */
-
-	rwlock_t lock;
-	struct list_head ring;
-	uint32_t pending_flush;
-	uint32_t waiting_types;
-	wait_queue_head_t fence_queue;
-	uint32_t highest_waiting_sequence;
-	uint32_t latest_queued_sequence;
-};
-
-/**
- * struct ttm_fence_device
- *
- * @fence_class:  Array of fence class managers.
- * @num_classes:  Array dimension of @fence_class.
- * @count:        Current number of fence objects for statistics.
- * @driver:       Driver struct.
- *
- * Provided in the driver interface so that the driver can derive
- * from this struct for its driver_private, and accordingly
- * access the driver_private from the fence driver callbacks.
- *
- * All members except "count" are initialized at creation and
- * never touched after that. No protection needed.
- *
- * This struct is private to the fence implementation and to the fence
- * driver callbacks, and may otherwise be used by drivers only to
- * obtain the derived device_private object using container_of().
- */
-
-struct ttm_fence_device {
-	struct ttm_mem_global *mem_glob;
-	struct ttm_fence_class_manager *fence_class;
-	uint32_t num_classes;
-	atomic_t count;
-	const struct ttm_fence_driver *driver;
-};
-
-/**
- * struct ttm_fence_class_init
- *
- * @wrap_diff:    Fence sequence number wrap indicator. If
- * (sequence1 - sequence2) > @wrap_diff, then sequence1 is
- * considered to be older than sequence2.
- * @flush_diff:   Fence sequence number flush indicator.
- * If a non-completely-signaled fence has a fence sequence number
- * sequence1 and (sequence1 - current_emit_sequence) > @flush_diff,
- * the fence is considered too old and it will be flushed upon the
- * next call of ttm_fence_flush_old(), to make sure no fences with
- * stale sequence numbers remains unsignaled. @flush_diff should
- * be sufficiently less than @wrap_diff.
- * @sequence_mask: Mask with valid bits of the fence sequence
- * number set to 1.
- *
- * This struct is used as input to ttm_fence_device_init.
- */
-
-struct ttm_fence_class_init {
-	uint32_t wrap_diff;
-	uint32_t flush_diff;
-	uint32_t sequence_mask;
-};
-
-/**
- * struct ttm_fence_driver
- *
- * @has_irq: Called by a potential waiter. Should return 1 if a
- * fence object with indicated parameters is expected to signal
- * automatically, and 0 if the fence implementation needs to
- * repeatedly call @poll to make it signal.
- * @emit:    Make sure a fence with the given parameters is
- * present in the indicated command stream. Return its sequence number
- * in "breadcrumb".
- * @poll:    Check and report sequences of the given "fence_class"
- *           that have signaled "types"
- * @flush:   Make sure that the types indicated by the bitfield
- *           ttm_fence_class_manager::pending_flush will eventually
- *           signal. These bits have been put together using the
- *           result from the needed_flush function described below.
- * @needed_flush: Given the fence_class and fence_types indicated by
- *           "fence", and the last received fence sequence of this
- *           fence class, indicate what types need a fence flush to
- *           signal. Return as a bitfield.
- * @wait:    Set to non-NULL if the driver wants to override the fence
- *           wait implementation. Return 0 on success, -EBUSY on failure,
- *           and -ERESTART if interruptible and a signal is pending.
- * @signaled:  Driver callback that is called whenever a
- *           ttm_fence_object::signaled_types has changed status.
- *           This function is called from atomic context,
- *           with the ttm_fence_class_manager::lock held in write mode.
- * @lockup:  Driver callback that is called whenever a wait has exceeded
- *           the lifetime of a fence object.
- *           If there is a GPU lockup,
- *           this function should, if possible, reset the GPU,
- *           call the ttm_fence_handler with an error status, and
- *           return. If no lockup was detected, simply extend the
- *           fence timeout_jiffies and return. The driver might
- *           want to protect the lockup check with a mutex and cache a
- *           non-locked-up status for a while to avoid an excessive
- *           amount of lockup checks from every waiting thread.
- */
-
-struct ttm_fence_driver {
-	bool (*has_irq) (struct ttm_fence_device *fdev,
-			uint32_t fence_class, uint32_t flags);
-	int (*emit) (struct ttm_fence_device *fdev,
-		     uint32_t fence_class,
-		     uint32_t flags,
-		     uint32_t *breadcrumb, unsigned long *timeout_jiffies);
-	void (*flush) (struct ttm_fence_device *fdev, uint32_t fence_class);
-	void (*poll) (struct ttm_fence_device *fdev,
-		      uint32_t fence_class, uint32_t types);
-	 uint32_t(*needed_flush)
-	 (struct ttm_fence_object *fence);
-	int (*wait) (struct ttm_fence_object *fence, bool lazy,
-		     bool interruptible, uint32_t mask);
-	void (*signaled) (struct ttm_fence_object *fence);
-	void (*lockup) (struct ttm_fence_object *fence, uint32_t fence_types);
-};
-
-/**
- * function ttm_fence_device_init
- *
- * @num_classes:      Number of fence classes for this fence implementation.
- * @mem_global:       Pointer to the global memory accounting info.
- * @fdev:             Pointer to an uninitialised struct ttm_fence_device.
- * @init:             Array of initialization info for each fence class.
- * @replicate_init:   Use the first @init initialization info for all classes.
- * @driver:           Driver callbacks.
- *
- * Initialize a struct ttm_fence_driver structure. Returns -ENOMEM if
- * out-of-memory. Otherwise returns 0.
- */
-extern int
-ttm_fence_device_init(int num_classes,
-		      struct ttm_mem_global *mem_glob,
-		      struct ttm_fence_device *fdev,
-		      const struct ttm_fence_class_init *init,
-		      bool replicate_init,
-		      const struct ttm_fence_driver *driver);
-
-/**
- * function ttm_fence_device_release
- *
- * @fdev:             Pointer to the fence device.
- *
- * Release all resources held by a fence device. Note that before
- * this function is called, the caller must have made sure all fence
- * objects belonging to this fence device are completely signaled.
- */
-
-extern void ttm_fence_device_release(struct ttm_fence_device *fdev);
-
-/**
- * ttm_fence_handler - the fence handler.
- *
- * @fdev:        Pointer to the fence device.
- * @fence_class: Fence class that signals.
- * @sequence:    Signaled sequence.
- * @type:        Types that signal.
- * @error:       Error from the engine.
- *
- * This function signals all fences with a sequence previous to the
- * @sequence argument, and belonging to @fence_class. The signaled fence
- * types are provided in @type. If error is non-zero, the error member
- * of the fence with sequence = @sequence is set to @error. This value
- * may be reported back to user-space, indicating, for example an illegal
- * 3D command or illegal mpeg data.
- *
- * This function is typically called from the driver::poll method when the
- * command sequence preceding the fence marker has executed. It should be
- * called with the ttm_fence_class_manager::lock held in write mode and
- * may be called from interrupt context.
- */
-
-extern void
-ttm_fence_handler(struct ttm_fence_device *fdev,
-		  uint32_t fence_class,
-		  uint32_t sequence, uint32_t type, uint32_t error);
-
-/**
- * ttm_fence_driver_from_dev
- *
- * @fdev:        The ttm fence device.
- *
- * Returns a pointer to the fence driver struct.
- */
-
-static inline const struct ttm_fence_driver *ttm_fence_driver_from_dev(
-						struct ttm_fence_device *fdev)
-{
-	return fdev->driver;
-}
-
-/**
- * ttm_fence_driver
- *
- * @fence:        Pointer to a ttm fence object.
- *
- * Returns a pointer to the fence driver struct.
- */
-
-static inline const struct ttm_fence_driver *ttm_fence_driver(struct
-							      ttm_fence_object
-							      *fence)
-{
-	return ttm_fence_driver_from_dev(fence->fdev);
-}
-
-/**
- * ttm_fence_fc
- *
- * @fence:        Pointer to a ttm fence object.
- *
- * Returns a pointer to the struct ttm_fence_class_manager for the
- * fence class of @fence.
- */
-
-static inline struct ttm_fence_class_manager *ttm_fence_fc(struct
-							   ttm_fence_object
-							   *fence)
-{
-	return &fence->fdev->fence_class[fence->fence_class];
-}
-
-#endif
diff --git a/drivers/staging/gma500/psb_ttm_fence_user.c b/drivers/staging/gma500/psb_ttm_fence_user.c
deleted file mode 100644
index 36f974f..0000000
--- a/drivers/staging/gma500/psb_ttm_fence_user.c
+++ /dev/null
@@ -1,237 +0,0 @@
-/**************************************************************************
- *
- * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
- * All Rights Reserved.
- * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
- * All Rights Reserved.
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
- **************************************************************************/
-/*
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
- */
-
-#include <drm/drmP.h>
-#include "psb_ttm_fence_user.h"
-#include "ttm/ttm_object.h"
-#include "psb_ttm_fence_driver.h"
-#include "psb_ttm_userobj_api.h"
-
-/**
- * struct ttm_fence_user_object
- *
- * @base:    The base object used for user-space visibility and refcounting.
- *
- * @fence:   The fence object itself.
- *
- */
-
-struct ttm_fence_user_object {
-	struct ttm_base_object base;
-	struct ttm_fence_object fence;
-};
-
-static struct ttm_fence_user_object *ttm_fence_user_object_lookup(
-					struct ttm_object_file *tfile,
-					uint32_t handle)
-{
-	struct ttm_base_object *base;
-
-	base = ttm_base_object_lookup(tfile, handle);
-	if (unlikely(base == NULL)) {
-		printk(KERN_ERR "Invalid fence handle 0x%08lx\n",
-		       (unsigned long)handle);
-		return NULL;
-	}
-
-	if (unlikely(base->object_type != ttm_fence_type)) {
-		ttm_base_object_unref(&base);
-		printk(KERN_ERR "Invalid fence handle 0x%08lx\n",
-		       (unsigned long)handle);
-		return NULL;
-	}
-
-	return container_of(base, struct ttm_fence_user_object, base);
-}
-
-/*
- * The fence object destructor.
- */
-
-static void ttm_fence_user_destroy(struct ttm_fence_object *fence)
-{
-	struct ttm_fence_user_object *ufence =
-	    container_of(fence, struct ttm_fence_user_object, fence);
-
-	ttm_mem_global_free(fence->fdev->mem_glob, sizeof(*ufence));
-	kfree(ufence);
-}
-
-/*
- * The base object destructor. We basically unly unreference the
- * attached fence object.
- */
-
-static void ttm_fence_user_release(struct ttm_base_object **p_base)
-{
-	struct ttm_fence_user_object *ufence;
-	struct ttm_base_object *base = *p_base;
-	struct ttm_fence_object *fence;
-
-	*p_base = NULL;
-
-	if (unlikely(base == NULL))
-		return;
-
-	ufence = container_of(base, struct ttm_fence_user_object, base);
-	fence = &ufence->fence;
-	ttm_fence_object_unref(&fence);
-}
-
-int
-ttm_fence_user_create(struct ttm_fence_device *fdev,
-		      struct ttm_object_file *tfile,
-		      uint32_t fence_class,
-		      uint32_t fence_types,
-		      uint32_t create_flags,
-		      struct ttm_fence_object **fence,
-		      uint32_t *user_handle)
-{
-	int ret;
-	struct ttm_fence_object *tmp;
-	struct ttm_fence_user_object *ufence;
-
-	ret = ttm_mem_global_alloc(fdev->mem_glob,
-				   sizeof(*ufence),
-				   false,
-				   false);
-	if (unlikely(ret != 0))
-		return -ENOMEM;
-
-	ufence = kmalloc(sizeof(*ufence), GFP_KERNEL);
-	if (unlikely(ufence == NULL)) {
-		ttm_mem_global_free(fdev->mem_glob, sizeof(*ufence));
-		return -ENOMEM;
-	}
-
-	ret = ttm_fence_object_init(fdev,
-				    fence_class,
-				    fence_types, create_flags,
-				    &ttm_fence_user_destroy, &ufence->fence);
-
-	if (unlikely(ret != 0))
-		goto out_err0;
-
-	/*
-	 * One fence ref is held by the fence ptr we return.
-	 * The other one by the base object. Need to up the
-	 * fence refcount before we publish this object to
-	 * user-space.
-	 */
-
-	tmp = ttm_fence_object_ref(&ufence->fence);
-	ret = ttm_base_object_init(tfile, &ufence->base,
-				   false, ttm_fence_type,
-				   &ttm_fence_user_release, NULL);
-
-	if (unlikely(ret != 0))
-		goto out_err1;
-
-	*fence = &ufence->fence;
-	*user_handle = ufence->base.hash.key;
-
-	return 0;
-out_err1:
-	ttm_fence_object_unref(&tmp);
-	tmp = &ufence->fence;
-	ttm_fence_object_unref(&tmp);
-	return ret;
-out_err0:
-	ttm_mem_global_free(fdev->mem_glob, sizeof(*ufence));
-	kfree(ufence);
-	return ret;
-}
-
-int ttm_fence_signaled_ioctl(struct ttm_object_file *tfile, void *data)
-{
-	int ret;
-	union ttm_fence_signaled_arg *arg = data;
-	struct ttm_fence_object *fence;
-	struct ttm_fence_info info;
-	struct ttm_fence_user_object *ufence;
-	struct ttm_base_object *base;
-	ret = 0;
-
-	ufence = ttm_fence_user_object_lookup(tfile, arg->req.handle);
-	if (unlikely(ufence == NULL))
-		return -EINVAL;
-
-	fence = &ufence->fence;
-
-	if (arg->req.flush) {
-		ret = ttm_fence_object_flush(fence, arg->req.fence_type);
-		if (unlikely(ret != 0))
-			goto out;
-	}
-
-	info = ttm_fence_get_info(fence);
-	arg->rep.signaled_types = info.signaled_types;
-	arg->rep.fence_error = info.error;
-
-out:
-	base = &ufence->base;
-	ttm_base_object_unref(&base);
-	return ret;
-}
-
-int ttm_fence_finish_ioctl(struct ttm_object_file *tfile, void *data)
-{
-	int ret;
-	union ttm_fence_finish_arg *arg = data;
-	struct ttm_fence_user_object *ufence;
-	struct ttm_base_object *base;
-	struct ttm_fence_object *fence;
-	ret = 0;
-
-	ufence = ttm_fence_user_object_lookup(tfile, arg->req.handle);
-	if (unlikely(ufence == NULL))
-		return -EINVAL;
-
-	fence = &ufence->fence;
-
-	ret = ttm_fence_object_wait(fence,
-				    arg->req.mode & TTM_FENCE_FINISH_MODE_LAZY,
-				    true, arg->req.fence_type);
-	if (likely(ret == 0)) {
-		struct ttm_fence_info info = ttm_fence_get_info(fence);
-
-		arg->rep.signaled_types = info.signaled_types;
-		arg->rep.fence_error = info.error;
-	}
-
-	base = &ufence->base;
-	ttm_base_object_unref(&base);
-
-	return ret;
-}
-
-int ttm_fence_unref_ioctl(struct ttm_object_file *tfile, void *data)
-{
-	struct ttm_fence_unref_arg *arg = data;
-	int ret = 0;
-
-	ret = ttm_ref_object_base_unref(tfile, arg->handle, ttm_fence_type);
-	return ret;
-}
diff --git a/drivers/staging/gma500/psb_ttm_fence_user.h b/drivers/staging/gma500/psb_ttm_fence_user.h
deleted file mode 100644
index fc13f89..0000000
--- a/drivers/staging/gma500/psb_ttm_fence_user.h
+++ /dev/null
@@ -1,140 +0,0 @@
-/**************************************************************************
- *
- * Copyright 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
- * All Rights Reserved.
- * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
- * All Rights Reserved.
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
- **************************************************************************/
-/*
- * Authors
- * Thomas Hellström <thomas-at-tungstengraphics-dot-com>
- */
-
-#ifndef TTM_FENCE_USER_H
-#define TTM_FENCE_USER_H
-
-#if !defined(__KERNEL__) && !defined(_KERNEL)
-#include <stdint.h>
-#endif
-
-#define TTM_FENCE_MAJOR 0
-#define TTM_FENCE_MINOR 1
-#define TTM_FENCE_PL    0
-#define TTM_FENCE_DATE  "080819"
-
-/**
- * struct ttm_fence_signaled_req
- *
- * @handle: Handle to the fence object. Input.
- *
- * @fence_type: Fence types we want to flush. Input.
- *
- * @flush: Boolean. Flush the indicated fence_types. Input.
- *
- * Argument to the TTM_FENCE_SIGNALED ioctl.
- */
-
-struct ttm_fence_signaled_req {
-	uint32_t handle;
-	uint32_t fence_type;
-	int32_t flush;
-	uint32_t pad64;
-};
-
-/**
- * struct ttm_fence_rep
- *
- * @signaled_types: Fence type that has signaled.
- *
- * @fence_error: Command execution error.
- * Hardware errors that are consequences of the execution
- * of the command stream preceding the fence are reported
- * here.
- *
- * Output argument to the TTM_FENCE_SIGNALED and
- * TTM_FENCE_FINISH ioctls.
- */
-
-struct ttm_fence_rep {
-	uint32_t signaled_types;
-	uint32_t fence_error;
-};
-
-union ttm_fence_signaled_arg {
-	struct ttm_fence_signaled_req req;
-	struct ttm_fence_rep rep;
-};
-
-/*
- * Waiting mode flags for the TTM_FENCE_FINISH ioctl.
- *
- * TTM_FENCE_FINISH_MODE_LAZY: Allow for sleeps during polling
- * wait.
- *
- * TTM_FENCE_FINISH_MODE_NO_BLOCK: Don't block waiting for GPU,
- * but return -EBUSY if the buffer is busy.
- */
-
-#define TTM_FENCE_FINISH_MODE_LAZY     (1 << 0)
-#define TTM_FENCE_FINISH_MODE_NO_BLOCK (1 << 1)
-
-/**
- * struct ttm_fence_finish_req
- *
- * @handle: Handle to the fence object. Input.
- *
- * @fence_type: Fence types we want to finish.
- *
- * @mode: Wait mode.
- *
- * Input to the TTM_FENCE_FINISH ioctl.
- */
-
-struct ttm_fence_finish_req {
-	uint32_t handle;
-	uint32_t fence_type;
-	uint32_t mode;
-	uint32_t pad64;
-};
-
-union ttm_fence_finish_arg {
-	struct ttm_fence_finish_req req;
-	struct ttm_fence_rep rep;
-};
-
-/**
- * struct ttm_fence_unref_arg
- *
- * @handle: Handle to the fence object.
- *
- * Argument to the TTM_FENCE_UNREF ioctl.
- */
-
-struct ttm_fence_unref_arg {
-	uint32_t handle;
-	uint32_t pad64;
-};
-
-/*
- * Ioctl offsets frome extenstion start.
- */
-
-#define TTM_FENCE_SIGNALED 0x01
-#define TTM_FENCE_FINISH   0x02
-#define TTM_FENCE_UNREF    0x03
-
-#endif
diff --git a/drivers/staging/gma500/psb_ttm_glue.c b/drivers/staging/gma500/psb_ttm_glue.c
deleted file mode 100644
index d1d965e..0000000
--- a/drivers/staging/gma500/psb_ttm_glue.c
+++ /dev/null
@@ -1,349 +0,0 @@
-/**************************************************************************
- * Copyright (c) 2008, Intel Corporation.
- * All Rights Reserved.
- * Copyright (c) 2008, Tungsten Graphics Inc.  Cedar Park, TX., USA.
- * All Rights Reserved.
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
- **************************************************************************/
-
-
-#include <drm/drmP.h>
-#include "psb_drv.h"
-#include "psb_ttm_userobj_api.h"
-#include <linux/io.h>
-
-
-static struct vm_operations_struct psb_ttm_vm_ops;
-
-/**
- * NOTE: driver_private of drm_file is now a struct psb_file_data struct
- * pPriv in struct psb_file_data contains the original psb_fpriv;
- */
-int psb_open(struct inode *inode, struct file *filp)
-{
-	struct drm_file *file_priv;
-	struct drm_psb_private *dev_priv;
-	struct psb_fpriv *psb_fp;
-	struct psb_file_data *pvr_file_priv;
-	int ret;
-
-	DRM_DEBUG("\n");
-
-	ret = drm_open(inode, filp);
-	if (unlikely(ret))
-		return ret;
-
-	psb_fp = kzalloc(sizeof(*psb_fp), GFP_KERNEL);
-
-	if (unlikely(psb_fp == NULL))
-		goto out_err0;
-
-	file_priv = (struct drm_file *) filp->private_data;
-	dev_priv = psb_priv(file_priv->minor->dev);
-
-	DRM_DEBUG("is_master %d\n", file_priv->is_master ? 1 : 0);
-
-	psb_fp->tfile = ttm_object_file_init(dev_priv->tdev,
-					     PSB_FILE_OBJECT_HASH_ORDER);
-	if (unlikely(psb_fp->tfile == NULL))
-		goto out_err1;
-
-	pvr_file_priv = (struct psb_file_data *)file_priv->driver_priv;
-	if (!pvr_file_priv) {
-		DRM_ERROR("drm file private is NULL\n");
-		goto out_err1;
-	}
-
-	pvr_file_priv->priv = psb_fp;
-	if (unlikely(dev_priv->bdev.dev_mapping == NULL))
-		dev_priv->bdev.dev_mapping = dev_priv->dev->dev_mapping;
-
-	return 0;
-
-out_err1:
-	kfree(psb_fp);
-out_err0:
-	(void) drm_release(inode, filp);
-	return ret;
-}
-
-int psb_release(struct inode *inode, struct file *filp)
-{
-	struct drm_file *file_priv;
-	struct psb_fpriv *psb_fp;
-	struct drm_psb_private *dev_priv;
-	int ret;
-	file_priv = (struct drm_file *) filp->private_data;
-	psb_fp = psb_fpriv(file_priv);
-	dev_priv = psb_priv(file_priv->minor->dev);
-
-	ttm_object_file_release(&psb_fp->tfile);
-	kfree(psb_fp);
-
-	ret = drm_release(inode, filp);
-
-	return ret;
-}
-
-int psb_fence_signaled_ioctl(struct drm_device *dev, void *data,
-			     struct drm_file *file_priv)
-{
-
-	return ttm_fence_signaled_ioctl(psb_fpriv(file_priv)->tfile, data);
-}
-
-int psb_fence_finish_ioctl(struct drm_device *dev, void *data,
-			   struct drm_file *file_priv)
-{
-	return ttm_fence_finish_ioctl(psb_fpriv(file_priv)->tfile, data);
-}
-
-int psb_fence_unref_ioctl(struct drm_device *dev, void *data,
-			  struct drm_file *file_priv)
-{
-	return ttm_fence_unref_ioctl(psb_fpriv(file_priv)->tfile, data);
-}
-
-int psb_pl_waitidle_ioctl(struct drm_device *dev, void *data,
-			  struct drm_file *file_priv)
-{
-	return ttm_pl_waitidle_ioctl(psb_fpriv(file_priv)->tfile, data);
-}
-
-int psb_pl_setstatus_ioctl(struct drm_device *dev, void *data,
-			   struct drm_file *file_priv)
-{
-	return ttm_pl_setstatus_ioctl(psb_fpriv(file_priv)->tfile,
-				      &psb_priv(dev)->ttm_lock, data);
-
-}
-
-int psb_pl_synccpu_ioctl(struct drm_device *dev, void *data,
-			 struct drm_file *file_priv)
-{
-	return ttm_pl_synccpu_ioctl(psb_fpriv(file_priv)->tfile, data);
-}
-
-int psb_pl_unref_ioctl(struct drm_device *dev, void *data,
-		       struct drm_file *file_priv)
-{
-	return ttm_pl_unref_ioctl(psb_fpriv(file_priv)->tfile, data);
-
-}
-
-int psb_pl_reference_ioctl(struct drm_device *dev, void *data,
-			   struct drm_file *file_priv)
-{
-	return  ttm_pl_reference_ioctl(psb_fpriv(file_priv)->tfile, data);
-
-}
-
-int psb_pl_create_ioctl(struct drm_device *dev, void *data,
-			struct drm_file *file_priv)
-{
-	struct drm_psb_private *dev_priv = psb_priv(dev);
-
-	return ttm_pl_create_ioctl(psb_fpriv(file_priv)->tfile,
-				   &dev_priv->bdev, &dev_priv->ttm_lock, data);
-
-}
-
-int psb_pl_ub_create_ioctl(struct drm_device *dev, void *data,
-			struct drm_file *file_priv)
-{
-	struct drm_psb_private *dev_priv = psb_priv(dev);
-
-	return ttm_pl_ub_create_ioctl(psb_fpriv(file_priv)->tfile,
-				   &dev_priv->bdev, &dev_priv->ttm_lock, data);
-
-}
-/**
- * psb_ttm_fault - Wrapper around the ttm fault method.
- *
- * @vma: The struct vm_area_struct as in the vm fault() method.
- * @vmf: The struct vm_fault as in the vm fault() method.
- *
- * Since ttm_fault() will reserve buffers while faulting,
- * we need to take the ttm read lock around it, as this driver
- * relies on the ttm_lock in write mode to exclude all threads from
- * reserving and thus validating buffers in aperture- and memory shortage
- * situations.
- */
-
-static int psb_ttm_fault(struct vm_area_struct *vma,
-			 struct vm_fault *vmf)
-{
-	struct ttm_buffer_object *bo = (struct ttm_buffer_object *)
-		vma->vm_private_data;
-	struct drm_psb_private *dev_priv =
-		container_of(bo->bdev, struct drm_psb_private, bdev);
-	int ret;
-
-	ret = ttm_read_lock(&dev_priv->ttm_lock, true);
-	if (unlikely(ret != 0))
-		return VM_FAULT_NOPAGE;
-
-	ret = dev_priv->ttm_vm_ops->fault(vma, vmf);
-
-	ttm_read_unlock(&dev_priv->ttm_lock);
-	return ret;
-}
-
-/**
- * if vm_pgoff < DRM_PSB_FILE_PAGE_OFFSET call directly to
- * PVRMMap
- */
-int psb_mmap(struct file *filp, struct vm_area_struct *vma)
-{
-	struct drm_file *file_priv;
-	struct drm_psb_private *dev_priv;
-	int ret;
-
-	if (vma->vm_pgoff < DRM_PSB_FILE_PAGE_OFFSET ||
-	    vma->vm_pgoff > 2 * DRM_PSB_FILE_PAGE_OFFSET)
-#if 0		/* FIXMEAC */
-		return PVRMMap(filp, vma);
-#else
-		return -EINVAL;
-#endif
-
-	file_priv = (struct drm_file *) filp->private_data;
-	dev_priv = psb_priv(file_priv->minor->dev);
-
-	ret = ttm_bo_mmap(filp, vma, &dev_priv->bdev);
-	if (unlikely(ret != 0))
-		return ret;
-
-	if (unlikely(dev_priv->ttm_vm_ops == NULL)) {
-		dev_priv->ttm_vm_ops = (struct vm_operations_struct *)
-								vma->vm_ops;
-		psb_ttm_vm_ops = *vma->vm_ops;
-		psb_ttm_vm_ops.fault = &psb_ttm_fault;
-	}
-
-	vma->vm_ops = &psb_ttm_vm_ops;
-
-	return 0;
-}
-/*
-ssize_t psb_ttm_write(struct file *filp, const char __user *buf,
-		      size_t count, loff_t *f_pos)
-{
-	struct drm_file *file_priv = (struct drm_file *)filp->private_data;
-	struct drm_psb_private *dev_priv = psb_priv(file_priv->minor->dev);
-
-	return ttm_bo_io(&dev_priv->bdev, filp, buf, NULL, count, f_pos, 1);
-}
-
-ssize_t psb_ttm_read(struct file *filp, char __user *buf,
-		     size_t count, loff_t *f_pos)
-{
-	struct drm_file *file_priv = (struct drm_file *)filp->private_data;
-	struct drm_psb_private *dev_priv = psb_priv(file_priv->minor->dev);
-
-	return ttm_bo_io(&dev_priv->bdev, filp, NULL, buf, count, f_pos, 1);
-}
-*/
-int psb_verify_access(struct ttm_buffer_object *bo,
-		      struct file *filp)
-{
-	struct drm_file *file_priv = (struct drm_file *)filp->private_data;
-
-	if (capable(CAP_SYS_ADMIN))
-		return 0;
-
-	if (unlikely(!file_priv->authenticated))
-		return -EPERM;
-
-	return ttm_pl_verify_access(bo, psb_fpriv(file_priv)->tfile);
-}
-
-static int psb_ttm_mem_global_init(struct drm_global_reference *ref)
-{
-	return ttm_mem_global_init(ref->object);
-}
-
-static void psb_ttm_mem_global_release(struct drm_global_reference *ref)
-{
-	ttm_mem_global_release(ref->object);
-}
-
-int psb_ttm_global_init(struct drm_psb_private *dev_priv)
-{
-	struct drm_global_reference *global_ref;
-	int ret;
-
-	global_ref = &dev_priv->mem_global_ref;
-	global_ref->global_type = DRM_GLOBAL_TTM_MEM;
-	global_ref->size = sizeof(struct ttm_mem_global);
-	global_ref->init = &psb_ttm_mem_global_init;
-	global_ref->release = &psb_ttm_mem_global_release;
-
-	ret = drm_global_item_ref(global_ref);
-	if (unlikely(ret != 0)) {
-		DRM_ERROR("Failed referencing a global TTM memory object.\n");
-		return ret;
-	}
-
-	dev_priv->bo_global_ref.mem_glob = dev_priv->mem_global_ref.object;
-	global_ref = &dev_priv->bo_global_ref.ref;
-	global_ref->global_type = DRM_GLOBAL_TTM_BO;
-	global_ref->size = sizeof(struct ttm_bo_global);
-	global_ref->init = &ttm_bo_global_init;
-	global_ref->release = &ttm_bo_global_release;
-	ret = drm_global_item_ref(global_ref);
-	if (ret != 0) {
-		DRM_ERROR("Failed setting up TTM BO subsystem.\n");
-		drm_global_item_unref(global_ref);
-		return ret;
-	}
-	return 0;
-}
-
-void psb_ttm_global_release(struct drm_psb_private *dev_priv)
-{
-	drm_global_item_unref(&dev_priv->mem_global_ref);
-}
-
-int psb_getpageaddrs_ioctl(struct drm_device *dev, void *data,
-		struct drm_file *file_priv)
-{
-	struct drm_psb_getpageaddrs_arg *arg = data;
-	struct ttm_buffer_object *bo;
-	struct ttm_tt *ttm;
-	struct page **tt_pages;
-	unsigned long i, num_pages;
-	unsigned long *p = arg->page_addrs;
-	int ret = 0;
-
-	bo = ttm_buffer_object_lookup(psb_fpriv(file_priv)->tfile,
-					arg->handle);
-	if (unlikely(bo == NULL)) {
-		printk(KERN_ERR
-			"Could not find buffer object for getpageaddrs.\n");
-		return -EINVAL;
-	}
-
-	arg->gtt_offset = bo->offset;
-	ttm = bo->ttm;
-	num_pages = ttm->num_pages;
-	tt_pages = ttm->pages;
-
-	for (i = 0; i < num_pages; i++)
-		p[i] = (unsigned long)page_to_phys(tt_pages[i]);
-
-	return ret;
-}
diff --git a/drivers/staging/gma500/psb_ttm_placement_user.c b/drivers/staging/gma500/psb_ttm_placement_user.c
deleted file mode 100644
index 272b397..0000000
--- a/drivers/staging/gma500/psb_ttm_placement_user.c
+++ /dev/null
@@ -1,628 +0,0 @@
-/**************************************************************************
- *
- * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
- * All Rights Reserved.
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
- **************************************************************************/
-/*
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
- */
-
-#include "psb_ttm_placement_user.h"
-#include "ttm/ttm_bo_driver.h"
-#include "ttm/ttm_object.h"
-#include "psb_ttm_userobj_api.h"
-#include "ttm/ttm_lock.h"
-#include <linux/slab.h>
-#include <linux/sched.h>
-
-struct ttm_bo_user_object {
-	struct ttm_base_object base;
-	struct ttm_buffer_object bo;
-};
-
-static size_t pl_bo_size;
-
-static uint32_t psb_busy_prios[] = {
-	TTM_PL_TT,
-	TTM_PL_PRIV0, /* CI */
-	TTM_PL_PRIV2, /* RAR */
-	TTM_PL_PRIV1, /* DRM_PSB_MEM_MMU */
-	TTM_PL_SYSTEM
-};
-
-static const struct ttm_placement default_placement = {
-				0, 0, 0, NULL, 5, psb_busy_prios
-};
-
-static size_t ttm_pl_size(struct ttm_bo_device *bdev, unsigned long num_pages)
-{
-	size_t page_array_size =
-	    (num_pages * sizeof(void *) + PAGE_SIZE - 1) & PAGE_MASK;
-
-	if (unlikely(pl_bo_size == 0)) {
-		pl_bo_size = bdev->glob->ttm_bo_extra_size +
-		    ttm_round_pot(sizeof(struct ttm_bo_user_object));
-	}
-
-	return bdev->glob->ttm_bo_size + 2 * page_array_size;
-}
-
-static struct ttm_bo_user_object *ttm_bo_user_lookup(struct ttm_object_file
-						     *tfile, uint32_t handle)
-{
-	struct ttm_base_object *base;
-
-	base = ttm_base_object_lookup(tfile, handle);
-	if (unlikely(base == NULL)) {
-		printk(KERN_ERR "Invalid buffer object handle 0x%08lx.\n",
-		       (unsigned long)handle);
-		return NULL;
-	}
-
-	if (unlikely(base->object_type != ttm_buffer_type)) {
-		ttm_base_object_unref(&base);
-		printk(KERN_ERR "Invalid buffer object handle 0x%08lx.\n",
-		       (unsigned long)handle);
-		return NULL;
-	}
-
-	return container_of(base, struct ttm_bo_user_object, base);
-}
-
-struct ttm_buffer_object *ttm_buffer_object_lookup(struct ttm_object_file
-						   *tfile, uint32_t handle)
-{
-	struct ttm_bo_user_object *user_bo;
-	struct ttm_base_object *base;
-
-	user_bo = ttm_bo_user_lookup(tfile, handle);
-	if (unlikely(user_bo == NULL))
-		return NULL;
-
-	(void)ttm_bo_reference(&user_bo->bo);
-	base = &user_bo->base;
-	ttm_base_object_unref(&base);
-	return &user_bo->bo;
-}
-
-static void ttm_bo_user_destroy(struct ttm_buffer_object *bo)
-{
-	struct ttm_bo_user_object *user_bo =
-	    container_of(bo, struct ttm_bo_user_object, bo);
-
-	ttm_mem_global_free(bo->glob->mem_glob, bo->acc_size);
-	kfree(user_bo);
-}
-
-static void ttm_bo_user_release(struct ttm_base_object **p_base)
-{
-	struct ttm_bo_user_object *user_bo;
-	struct ttm_base_object *base = *p_base;
-	struct ttm_buffer_object *bo;
-
-	*p_base = NULL;
-
-	if (unlikely(base == NULL))
-		return;
-
-	user_bo = container_of(base, struct ttm_bo_user_object, base);
-	bo = &user_bo->bo;
-	ttm_bo_unref(&bo);
-}
-
-static void ttm_bo_user_ref_release(struct ttm_base_object *base,
-				    enum ttm_ref_type ref_type)
-{
-	struct ttm_bo_user_object *user_bo =
-	    container_of(base, struct ttm_bo_user_object, base);
-	struct ttm_buffer_object *bo = &user_bo->bo;
-
-	switch (ref_type) {
-	case TTM_REF_SYNCCPU_WRITE:
-		ttm_bo_synccpu_write_release(bo);
-		break;
-	default:
-		BUG();
-	}
-}
-
-static void ttm_pl_fill_rep(struct ttm_buffer_object *bo,
-			    struct ttm_pl_rep *rep)
-{
-	struct ttm_bo_user_object *user_bo =
-	    container_of(bo, struct ttm_bo_user_object, bo);
-
-	rep->gpu_offset = bo->offset;
-	rep->bo_size = bo->num_pages << PAGE_SHIFT;
-	rep->map_handle = bo->addr_space_offset;
-	rep->placement = bo->mem.placement;
-	rep->handle = user_bo->base.hash.key;
-	rep->sync_object_arg = (uint32_t) (unsigned long)bo->sync_obj_arg;
-}
-
-/* FIXME Copy from upstream TTM */
-static inline size_t ttm_bo_size(struct ttm_bo_global *glob,
-				 unsigned long num_pages)
-{
-	size_t page_array_size = (num_pages * sizeof(void *) + PAGE_SIZE - 1) &
-	    PAGE_MASK;
-
-	return glob->ttm_bo_size + 2 * page_array_size;
-}
-
-/* FIXME Copy from upstream TTM "ttm_bo_create", upstream TTM does not
-   export this, so copy it here */
-static int ttm_bo_create_private(struct ttm_bo_device *bdev,
-			unsigned long size,
-			enum ttm_bo_type type,
-			struct ttm_placement *placement,
-			uint32_t page_alignment,
-			unsigned long buffer_start,
-			bool interruptible,
-			struct file *persistant_swap_storage,
-			struct ttm_buffer_object **p_bo)
-{
-	struct ttm_buffer_object *bo;
-	struct ttm_mem_global *mem_glob = bdev->glob->mem_glob;
-	int ret;
-
-	size_t acc_size =
-	    ttm_bo_size(bdev->glob, (size + PAGE_SIZE - 1) >> PAGE_SHIFT);
-	ret = ttm_mem_global_alloc(mem_glob, acc_size, false, false);
-	if (unlikely(ret != 0))
-		return ret;
-
-	bo = kzalloc(sizeof(*bo), GFP_KERNEL);
-
-	if (unlikely(bo == NULL)) {
-		ttm_mem_global_free(mem_glob, acc_size);
-		return -ENOMEM;
-	}
-
-	ret = ttm_bo_init(bdev, bo, size, type, placement, page_alignment,
-				buffer_start, interruptible,
-				persistant_swap_storage, acc_size, NULL);
-	if (likely(ret == 0))
-		*p_bo = bo;
-
-	return ret;
-}
-
-int psb_ttm_bo_check_placement(struct ttm_buffer_object *bo,
-				struct ttm_placement *placement)
-{
-	int i;
-
-	for (i = 0; i < placement->num_placement; i++) {
-		if (!capable(CAP_SYS_ADMIN)) {
-			if (placement->placement[i] & TTM_PL_FLAG_NO_EVICT) {
-				printk(KERN_ERR TTM_PFX "Need to be root to "
-					"modify NO_EVICT status.\n");
-				return -EINVAL;
-			}
-		}
-	}
-	for (i = 0; i < placement->num_busy_placement; i++) {
-		if (!capable(CAP_SYS_ADMIN)) {
-			if (placement->busy_placement[i]
-						& TTM_PL_FLAG_NO_EVICT) {
-				printk(KERN_ERR TTM_PFX "Need to be root to modify NO_EVICT status.\n");
-				return -EINVAL;
-			}
-		}
-	}
-	return 0;
-}
-
-int ttm_buffer_object_create(struct ttm_bo_device *bdev,
-			unsigned long size,
-			enum ttm_bo_type type,
-			uint32_t flags,
-			uint32_t page_alignment,
-			unsigned long buffer_start,
-			bool interruptible,
-			struct file *persistant_swap_storage,
-			struct ttm_buffer_object **p_bo)
-{
-	struct ttm_placement placement = default_placement;
-	int ret;
-
-	if ((flags & TTM_PL_MASK_CACHING) == 0)
-		flags |= TTM_PL_FLAG_WC | TTM_PL_FLAG_UNCACHED;
-
-	placement.num_placement = 1;
-	placement.placement = &flags;
-
-	ret = ttm_bo_create_private(bdev,
-			size,
-			type,
-			&placement,
-			page_alignment,
-			buffer_start,
-			interruptible,
-			persistant_swap_storage,
-			p_bo);
-
-	return ret;
-}
-
-
-int ttm_pl_create_ioctl(struct ttm_object_file *tfile,
-			struct ttm_bo_device *bdev,
-			struct ttm_lock *lock, void *data)
-{
-	union ttm_pl_create_arg *arg = data;
-	struct ttm_pl_create_req *req = &arg->req;
-	struct ttm_pl_rep *rep = &arg->rep;
-	struct ttm_buffer_object *bo;
-	struct ttm_buffer_object *tmp;
-	struct ttm_bo_user_object *user_bo;
-	uint32_t flags;
-	int ret = 0;
-	struct ttm_mem_global *mem_glob = bdev->glob->mem_glob;
-	struct ttm_placement placement = default_placement;
-	size_t acc_size =
-	    ttm_pl_size(bdev, (req->size + PAGE_SIZE - 1) >> PAGE_SHIFT);
-	ret = ttm_mem_global_alloc(mem_glob, acc_size, false, false);
-	if (unlikely(ret != 0))
-		return ret;
-
-	flags = req->placement;
-	user_bo = kzalloc(sizeof(*user_bo), GFP_KERNEL);
-	if (unlikely(user_bo == NULL)) {
-		ttm_mem_global_free(mem_glob, acc_size);
-		return -ENOMEM;
-	}
-
-	bo = &user_bo->bo;
-	ret = ttm_read_lock(lock, true);
-	if (unlikely(ret != 0)) {
-		ttm_mem_global_free(mem_glob, acc_size);
-		kfree(user_bo);
-		return ret;
-	}
-
-	placement.num_placement = 1;
-	placement.placement = &flags;
-
-	if ((flags & TTM_PL_MASK_CACHING) == 0)
-		flags |=  TTM_PL_FLAG_WC | TTM_PL_FLAG_UNCACHED;
-
-	ret = ttm_bo_init(bdev, bo, req->size,
-				     ttm_bo_type_device, &placement,
-				     req->page_alignment, 0, true,
-				     NULL, acc_size, &ttm_bo_user_destroy);
-	ttm_read_unlock(lock);
-
-	/*
-	 * Note that the ttm_buffer_object_init function
-	 * would've called the destroy function on failure!!
-	 */
-
-	if (unlikely(ret != 0))
-		goto out;
-
-	tmp = ttm_bo_reference(bo);
-	ret = ttm_base_object_init(tfile, &user_bo->base,
-				   flags & TTM_PL_FLAG_SHARED,
-				   ttm_buffer_type,
-				   &ttm_bo_user_release,
-				   &ttm_bo_user_ref_release);
-	if (unlikely(ret != 0))
-		goto out_err;
-
-	ttm_pl_fill_rep(bo, rep);
-	ttm_bo_unref(&bo);
-out:
-	return 0;
-out_err:
-	ttm_bo_unref(&tmp);
-	ttm_bo_unref(&bo);
-	return ret;
-}
-
-int ttm_pl_ub_create_ioctl(struct ttm_object_file *tfile,
-			   struct ttm_bo_device *bdev,
-			   struct ttm_lock *lock, void *data)
-{
-	union ttm_pl_create_ub_arg *arg = data;
-	struct ttm_pl_create_ub_req *req = &arg->req;
-	struct ttm_pl_rep *rep = &arg->rep;
-	struct ttm_buffer_object *bo;
-	struct ttm_buffer_object *tmp;
-	struct ttm_bo_user_object *user_bo;
-	uint32_t flags;
-	int ret = 0;
-	struct ttm_mem_global *mem_glob = bdev->glob->mem_glob;
-	struct ttm_placement placement = default_placement;
-	size_t acc_size =
-	    ttm_pl_size(bdev, (req->size + PAGE_SIZE - 1) >> PAGE_SHIFT);
-	ret = ttm_mem_global_alloc(mem_glob, acc_size, false, false);
-	if (unlikely(ret != 0))
-		return ret;
-
-	flags = req->placement;
-	user_bo = kzalloc(sizeof(*user_bo), GFP_KERNEL);
-	if (unlikely(user_bo == NULL)) {
-		ttm_mem_global_free(mem_glob, acc_size);
-		return -ENOMEM;
-	}
-	ret = ttm_read_lock(lock, true);
-	if (unlikely(ret != 0)) {
-		ttm_mem_global_free(mem_glob, acc_size);
-		kfree(user_bo);
-		return ret;
-	}
-	bo = &user_bo->bo;
-
-	placement.num_placement = 1;
-	placement.placement = &flags;
-
-	ret = ttm_bo_init(bdev,
-					bo,
-					req->size,
-					ttm_bo_type_user,
-					&placement,
-					req->page_alignment,
-					req->user_address,
-					true,
-					NULL,
-					acc_size,
-					&ttm_bo_user_destroy);
-
-	/*
-	 * Note that the ttm_buffer_object_init function
-	 * would've called the destroy function on failure!!
-	 */
-	ttm_read_unlock(lock);
-	if (unlikely(ret != 0))
-		goto out;
-
-	tmp = ttm_bo_reference(bo);
-	ret = ttm_base_object_init(tfile, &user_bo->base,
-				   flags & TTM_PL_FLAG_SHARED,
-				   ttm_buffer_type,
-				   &ttm_bo_user_release,
-				   &ttm_bo_user_ref_release);
-	if (unlikely(ret != 0))
-		goto out_err;
-
-	ttm_pl_fill_rep(bo, rep);
-	ttm_bo_unref(&bo);
-out:
-	return 0;
-out_err:
-	ttm_bo_unref(&tmp);
-	ttm_bo_unref(&bo);
-	return ret;
-}
-
-int ttm_pl_reference_ioctl(struct ttm_object_file *tfile, void *data)
-{
-	union ttm_pl_reference_arg *arg = data;
-	struct ttm_pl_rep *rep = &arg->rep;
-	struct ttm_bo_user_object *user_bo;
-	struct ttm_buffer_object *bo;
-	struct ttm_base_object *base;
-	int ret;
-
-	user_bo = ttm_bo_user_lookup(tfile, arg->req.handle);
-	if (unlikely(user_bo == NULL)) {
-		printk(KERN_ERR "Could not reference buffer object.\n");
-		return -EINVAL;
-	}
-
-	bo = &user_bo->bo;
-	ret = ttm_ref_object_add(tfile, &user_bo->base, TTM_REF_USAGE, NULL);
-	if (unlikely(ret != 0)) {
-		printk(KERN_ERR
-		       "Could not add a reference to buffer object.\n");
-		goto out;
-	}
-
-	ttm_pl_fill_rep(bo, rep);
-
-out:
-	base = &user_bo->base;
-	ttm_base_object_unref(&base);
-	return ret;
-}
-
-int ttm_pl_unref_ioctl(struct ttm_object_file *tfile, void *data)
-{
-	struct ttm_pl_reference_req *arg = data;
-
-	return ttm_ref_object_base_unref(tfile, arg->handle, TTM_REF_USAGE);
-}
-
-int ttm_pl_synccpu_ioctl(struct ttm_object_file *tfile, void *data)
-{
-	struct ttm_pl_synccpu_arg *arg = data;
-	struct ttm_bo_user_object *user_bo;
-	struct ttm_buffer_object *bo;
-	struct ttm_base_object *base;
-	bool existed;
-	int ret;
-
-	switch (arg->op) {
-	case TTM_PL_SYNCCPU_OP_GRAB:
-		user_bo = ttm_bo_user_lookup(tfile, arg->handle);
-		if (unlikely(user_bo == NULL)) {
-			printk(KERN_ERR
-			       "Could not find buffer object for synccpu.\n");
-			return -EINVAL;
-		}
-		bo = &user_bo->bo;
-		base = &user_bo->base;
-		ret = ttm_bo_synccpu_write_grab(bo,
-						arg->access_mode &
-						TTM_PL_SYNCCPU_MODE_NO_BLOCK);
-		if (unlikely(ret != 0)) {
-			ttm_base_object_unref(&base);
-			goto out;
-		}
-		ret = ttm_ref_object_add(tfile, &user_bo->base,
-					 TTM_REF_SYNCCPU_WRITE, &existed);
-		if (existed || ret != 0)
-			ttm_bo_synccpu_write_release(bo);
-		ttm_base_object_unref(&base);
-		break;
-	case TTM_PL_SYNCCPU_OP_RELEASE:
-		ret = ttm_ref_object_base_unref(tfile, arg->handle,
-						TTM_REF_SYNCCPU_WRITE);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-out:
-	return ret;
-}
-
-int ttm_pl_setstatus_ioctl(struct ttm_object_file *tfile,
-			   struct ttm_lock *lock, void *data)
-{
-	union ttm_pl_setstatus_arg *arg = data;
-	struct ttm_pl_setstatus_req *req = &arg->req;
-	struct ttm_pl_rep *rep = &arg->rep;
-	struct ttm_buffer_object *bo;
-	struct ttm_bo_device *bdev;
-	struct ttm_placement placement = default_placement;
-	uint32_t flags[2];
-	int ret;
-
-	bo = ttm_buffer_object_lookup(tfile, req->handle);
-	if (unlikely(bo == NULL)) {
-		printk(KERN_ERR
-		       "Could not find buffer object for setstatus.\n");
-		return -EINVAL;
-	}
-
-	bdev = bo->bdev;
-
-	ret = ttm_read_lock(lock, true);
-	if (unlikely(ret != 0))
-		goto out_err0;
-
-	ret = ttm_bo_reserve(bo, true, false, false, 0);
-	if (unlikely(ret != 0))
-		goto out_err1;
-
-	ret = ttm_bo_wait_cpu(bo, false);
-	if (unlikely(ret != 0))
-		goto out_err2;
-
-	flags[0] = req->set_placement;
-	flags[1] = req->clr_placement;
-
-	placement.num_placement = 2;
-	placement.placement = flags;
-
-	/* Review internal locking ? FIXMEAC */
-	ret = psb_ttm_bo_check_placement(bo, &placement);
-	if (unlikely(ret != 0))
-		goto out_err2;
-
-	placement.num_placement = 1;
-	flags[0] = (req->set_placement | bo->mem.placement)
-						& ~req->clr_placement;
-
-	ret = ttm_bo_validate(bo, &placement, true, false, false);
-	if (unlikely(ret != 0))
-		goto out_err2;
-
-	ttm_pl_fill_rep(bo, rep);
-out_err2:
-	ttm_bo_unreserve(bo);
-out_err1:
-	ttm_read_unlock(lock);
-out_err0:
-	ttm_bo_unref(&bo);
-	return ret;
-}
-
-static int psb_ttm_bo_block_reservation(struct ttm_buffer_object *bo,
-				bool interruptible, bool no_wait)
-{
-	int ret;
-
-	while (unlikely(atomic_cmpxchg(&bo->reserved, 0, 1) != 0)) {
-		if (no_wait)
-			return -EBUSY;
-		else if (interruptible) {
-			ret = wait_event_interruptible(bo->event_queue,
-					atomic_read(&bo->reserved) == 0);
-			if (unlikely(ret != 0))
-				return -ERESTART;
-		} else {
-			wait_event(bo->event_queue,
-				atomic_read(&bo->reserved) == 0);
-		}
-	}
-	return 0;
-}
-
-static void psb_ttm_bo_unblock_reservation(struct ttm_buffer_object *bo)
-{
-	atomic_set(&bo->reserved, 0);
-	wake_up_all(&bo->event_queue);
-}
-
-int ttm_pl_waitidle_ioctl(struct ttm_object_file *tfile, void *data)
-{
-	struct ttm_pl_waitidle_arg *arg = data;
-	struct ttm_buffer_object *bo;
-	int ret;
-
-	bo = ttm_buffer_object_lookup(tfile, arg->handle);
-	if (unlikely(bo == NULL)) {
-		printk(KERN_ERR "Could not find buffer object for waitidle.\n");
-		return -EINVAL;
-	}
-
-	ret =
-	    psb_ttm_bo_block_reservation(bo, true,
-				     arg->mode & TTM_PL_WAITIDLE_MODE_NO_BLOCK);
-	if (unlikely(ret != 0))
-		goto out;
-	ret = ttm_bo_wait(bo,
-			  arg->mode & TTM_PL_WAITIDLE_MODE_LAZY,
-			  true, arg->mode & TTM_PL_WAITIDLE_MODE_NO_BLOCK);
-	psb_ttm_bo_unblock_reservation(bo);
-out:
-	ttm_bo_unref(&bo);
-	return ret;
-}
-
-int ttm_pl_verify_access(struct ttm_buffer_object *bo,
-			 struct ttm_object_file *tfile)
-{
-	struct ttm_bo_user_object *ubo;
-
-	/*
-	 * Check bo subclass.
-	 */
-
-	if (unlikely(bo->destroy != &ttm_bo_user_destroy))
-		return -EPERM;
-
-	ubo = container_of(bo, struct ttm_bo_user_object, bo);
-	if (likely(ubo->base.shareable || ubo->base.tfile == tfile))
-		return 0;
-
-	return -EPERM;
-}
diff --git a/drivers/staging/gma500/psb_ttm_userobj_api.h b/drivers/staging/gma500/psb_ttm_userobj_api.h
deleted file mode 100644
index 6a8f7c4..0000000
--- a/drivers/staging/gma500/psb_ttm_userobj_api.h
+++ /dev/null
@@ -1,85 +0,0 @@
-/**************************************************************************
- *
- * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
- * All Rights Reserved.
- * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
- * All Rights Reserved.
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
- **************************************************************************/
-/*
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
- */
-
-#ifndef _TTM_USEROBJ_API_H_
-#define _TTM_USEROBJ_API_H_
-
-#include "psb_ttm_placement_user.h"
-#include "psb_ttm_fence_user.h"
-#include "ttm/ttm_object.h"
-#include "psb_ttm_fence_api.h"
-#include "ttm/ttm_bo_api.h"
-
-struct ttm_lock;
-
-/*
- * User ioctls.
- */
-
-extern int ttm_pl_create_ioctl(struct ttm_object_file *tfile,
-			       struct ttm_bo_device *bdev,
-			       struct ttm_lock *lock, void *data);
-extern int ttm_pl_ub_create_ioctl(struct ttm_object_file *tfile,
-				  struct ttm_bo_device *bdev,
-				  struct ttm_lock *lock, void *data);
-extern int ttm_pl_reference_ioctl(struct ttm_object_file *tfile, void *data);
-extern int ttm_pl_unref_ioctl(struct ttm_object_file *tfile, void *data);
-extern int ttm_pl_synccpu_ioctl(struct ttm_object_file *tfile, void *data);
-extern int ttm_pl_setstatus_ioctl(struct ttm_object_file *tfile,
-				  struct ttm_lock *lock, void *data);
-extern int ttm_pl_waitidle_ioctl(struct ttm_object_file *tfile, void *data);
-extern int ttm_fence_signaled_ioctl(struct ttm_object_file *tfile, void *data);
-extern int ttm_fence_finish_ioctl(struct ttm_object_file *tfile, void *data);
-extern int ttm_fence_unref_ioctl(struct ttm_object_file *tfile, void *data);
-
-extern int
-ttm_fence_user_create(struct ttm_fence_device *fdev,
-		      struct ttm_object_file *tfile,
-		      uint32_t fence_class,
-		      uint32_t fence_types,
-		      uint32_t create_flags,
-		      struct ttm_fence_object **fence, uint32_t * user_handle);
-
-extern struct ttm_buffer_object *ttm_buffer_object_lookup(struct ttm_object_file
-							  *tfile,
-							  uint32_t handle);
-
-extern int
-ttm_pl_verify_access(struct ttm_buffer_object *bo,
-		     struct ttm_object_file *tfile);
-
-extern int ttm_buffer_object_create(struct ttm_bo_device *bdev,
-			unsigned long size,
-			enum ttm_bo_type type,
-			uint32_t flags,
-			uint32_t page_alignment,
-			unsigned long buffer_start,
-			bool interruptible,
-			struct file *persistant_swap_storage,
-			struct ttm_buffer_object **p_bo);
-
-extern int psb_ttm_bo_check_placement(struct ttm_buffer_object *bo,
-				struct ttm_placement *placement);
-#endif

