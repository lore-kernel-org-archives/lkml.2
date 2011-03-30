Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab1C3JUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:20:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51205 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932263Ab1C3JT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:19:56 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 14/18] gma500: Clean up more unused structures and code
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 30 Mar 2011 10:01:13 +0100
Message-ID: <20110330090108.5897.11414.stgit@localhost.localdomain>
In-Reply-To: <20110330085539.5897.67919.stgit@localhost.localdomain>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need the 3D validation stuff so it and all the related gunge can
depart. While we are at it prune some unused definitions.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.c |   16 ------
 drivers/staging/gma500/psb_drv.h |  105 -------------------------------------
 drivers/staging/gma500/psb_sgx.c |  107 --------------------------------------
 3 files changed, 0 insertions(+), 228 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index cbb691e..6e9954c 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -284,20 +284,7 @@ static void psb_set_uopt(struct drm_psb_uopt *uopt)
 
 static void psb_lastclose(struct drm_device *dev)
 {
-	struct drm_psb_private *dev_priv =
-	    (struct drm_psb_private *) dev->dev_private;
-
 	return;
-
-	if (!dev->dev_private)
-		return;
-
-	mutex_lock(&dev_priv->cmdbuf_mutex);
-	if (dev_priv->context.buffers) {
-		vfree(dev_priv->context.buffers);
-		dev_priv->context.buffers = NULL;
-	}
-	mutex_unlock(&dev_priv->cmdbuf_mutex);
 }
 
 static void psb_do_takedown(struct drm_device *dev)
@@ -744,7 +731,6 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	dev_priv = kzalloc(sizeof(*dev_priv), GFP_KERNEL);
 	if (dev_priv == NULL)
 		return -ENOMEM;
-	INIT_LIST_HEAD(&dev_priv->video_ctx);
 
 	if (IS_MRST(dev))
 		dev_priv->num_pipe = 1;
@@ -767,8 +753,6 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	mutex_init(&dev_priv->temp_mem);
 	mutex_init(&dev_priv->cmdbuf_mutex);
 	mutex_init(&dev_priv->reset_mutex);
-	INIT_LIST_HEAD(&dev_priv->context.validate_list);
-	INIT_LIST_HEAD(&dev_priv->context.kern_validate_list);
 
 /*	mutex_init(&dev_priv->dsr_mutex); */
 
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 7c83c8d..014035f 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -94,23 +94,10 @@ enum {
 #define PSB_MEM_MMU_START       0x00000000
 #define PSB_MEM_TT_START        0xE0000000
 
-#define PSB_GL3_CACHE_CTL	0x2100
-#define PSB_GL3_CACHE_STAT	0x2108
-
 /*
  *Flags for external memory type field.
  */
 
-#define MRST_MSVDX_OFFSET	0x90000	/*MSVDX Base offset */
-#define PSB_MSVDX_OFFSET	0x50000	/*MSVDX Base offset */
-/* MSVDX MMIO region is 0x50000 - 0x57fff ==> 32KB */
-#define PSB_MSVDX_SIZE		0x10000
-
-#define LNC_TOPAZ_OFFSET	0xA0000
-#define PNW_TOPAZ_OFFSET	0xC0000
-#define PNW_GL3_OFFSET		0xB0000
-#define LNC_TOPAZ_SIZE		0x10000
-#define PNW_TOPAZ_SIZE		0x30000 /* PNW VXE285 has two cores */
 #define PSB_MMU_CACHED_MEMORY	  0x0001	/* Bind to MMU only */
 #define PSB_MMU_RO_MEMORY	  0x0002	/* MMU RO memory */
 #define PSB_MMU_WO_MEMORY	  0x0004	/* MMU WO memory */
@@ -222,20 +209,6 @@ enum {
 #define MDFLD_PNW_B0 0x04
 #define MDFLD_PNW_C0 0x08
 
-#define MDFLD_DSR_2D_3D_0 BIT0
-#define MDFLD_DSR_2D_3D_2 BIT1
-#define MDFLD_DSR_CURSOR_0 BIT2
-#define MDFLD_DSR_CURSOR_2 BIT3
-#define MDFLD_DSR_OVERLAY_0 BIT4
-#define MDFLD_DSR_OVERLAY_2 BIT5
-#define MDFLD_DSR_MIPI_CONTROL	BIT6
-#define MDFLD_DSR_2D_3D 	(MDFLD_DSR_2D_3D_0 | MDFLD_DSR_2D_3D_2)
-
-#define MDFLD_DSR_RR 45
-#define MDFLD_DPU_ENABLE BIT31
-#define MDFLD_DSR_FULLSCREEN BIT30
-#define MDFLD_DSR_DELAY (DRM_HZ / MDFLD_DSR_RR)
-
 #define PSB_PWR_STATE_ON		1
 #define PSB_PWR_STATE_OFF		2
 
@@ -249,9 +222,6 @@ enum {
 #define PSB_PCIx_MSI_ADDR_LOC		0x94
 #define PSB_PCIx_MSI_DATA_LOC		0x98
 
-#define MDFLD_PLANE_MAX_WIDTH		2048
-#define MDFLD_PLANE_MAX_HEIGHT		2048
-
 struct opregion_header;
 struct opregion_acpi;
 struct opregion_swsci;
@@ -273,66 +243,6 @@ struct drm_psb_uopt {
 	int pad; /*keep it here in case we use it in future*/
 };
 
-/**
- *struct psb_context
- *
- *@buffers:	 array of pre-allocated validate buffers.
- *@used_buffers: number of buffers in @buffers array currently in use.
- *@validate_buffer: buffers validated from user-space.
- *@kern_validate_buffers : buffers validated from kernel-space.
- *@fence_flags : Fence flags to be used for fence creation.
- *
- *This structure is used during execbuf validation.
- */
-
-struct psb_context {
-	struct psb_validate_buffer *buffers;
-	uint32_t used_buffers;
-	struct list_head validate_list;
-	struct list_head kern_validate_list;
-	uint32_t fence_types;
-	uint32_t val_seq;
-};
-
-struct psb_validate_buffer;
-
-/* Currently defined profiles */
-enum VAProfile {
-	VAProfileMPEG2Simple		= 0,
-	VAProfileMPEG2Main		= 1,
-	VAProfileMPEG4Simple		= 2,
-	VAProfileMPEG4AdvancedSimple	= 3,
-	VAProfileMPEG4Main		= 4,
-	VAProfileH264Baseline		= 5,
-	VAProfileH264Main		= 6,
-	VAProfileH264High		= 7,
-	VAProfileVC1Simple		= 8,
-	VAProfileVC1Main		= 9,
-	VAProfileVC1Advanced		= 10,
-	VAProfileH263Baseline		= 11,
-	VAProfileJPEGBaseline           = 12,
-	VAProfileH264ConstrainedBaseline = 13
-};
-
-/* Currently defined entrypoints */
-enum VAEntrypoint {
-	VAEntrypointVLD		= 1,
-	VAEntrypointIZZ		= 2,
-	VAEntrypointIDCT	= 3,
-	VAEntrypointMoComp	= 4,
-	VAEntrypointDeblocking	= 5,
-	VAEntrypointEncSlice	= 6,	/* slice level encode */
-	VAEntrypointEncPicture 	= 7	/* pictuer encode, JPEG, etc */
-};
-
-
-struct psb_video_ctx {
-	struct list_head head;
-	struct file *filp; /* DRM device file pointer */
-	int ctx_type; /* profile<<8|entrypoint */
-	/* todo: more context specific data for multi-context support */
-};
-
 struct mrst_vbt {
 	s8 signature[4];	/*4 bytes,"$GCT" */
 	u8 revision;
@@ -574,10 +484,6 @@ struct drm_psb_private {
 	uint8_t *vdc_reg;
 	uint32_t gatt_free_offset;
 
-	/* IMG video context */
-	struct list_head video_ctx;
-
-
 
 	/*
 	 *Fencing / irq.
@@ -870,12 +776,6 @@ struct drm_psb_private {
 	atomic_t val_seq;
 
 	/*
-	 *TODO: change this to be per drm-context.
-	 */
-
-	struct psb_context context;
-
-	/*
 	 * LID-Switch
 	 */
 	spinlock_t lid_lock;
@@ -1032,11 +932,6 @@ extern void psb_fence_or_sync(struct drm_file *file_priv,
 			      struct list_head *list,
 			      struct psb_ttm_fence_rep *fence_arg,
 			      struct ttm_fence_object **fence_p);
-extern int psb_validate_kernel_buffer(struct psb_context *context,
-				      struct ttm_buffer_object *bo,
-				      uint32_t fence_class,
-				      uint64_t set_flags,
-				      uint64_t clr_flags);
 
 /*
  *psb_irq.c
diff --git a/drivers/staging/gma500/psb_sgx.c b/drivers/staging/gma500/psb_sgx.c
index 973134b..91fbb6a 100644
--- a/drivers/staging/gma500/psb_sgx.c
+++ b/drivers/staging/gma500/psb_sgx.c
@@ -64,113 +64,6 @@ struct psb_validate_buffer {
 	uint32_t offset;
 	int po_correct;
 };
-static int
-psb_placement_fence_type(struct ttm_buffer_object *bo,
-			 uint64_t set_val_flags,
-			 uint64_t clr_val_flags,
-			 uint32_t new_fence_class,
-			 uint32_t *new_fence_type)
-{
-	int ret;
-	uint32_t n_fence_type;
-	/*
-	uint32_t set_flags = set_val_flags & 0xFFFFFFFF;
-	uint32_t clr_flags = clr_val_flags & 0xFFFFFFFF;
-	*/
-	struct ttm_fence_object *old_fence;
-	uint32_t old_fence_type;
-	struct ttm_placement placement;
-
-	if (unlikely
-	    (!(set_val_flags &
-	       (PSB_GPU_ACCESS_READ | PSB_GPU_ACCESS_WRITE)))) {
-		DRM_ERROR
-		    ("GPU access type (read / write) is not indicated.\n");
-		return -EINVAL;
-	}
-
-	/* User space driver doesn't set any TTM placement flags in
-					set_val_flags or clr_val_flags */
-	placement.num_placement = 0;/* FIXME  */
-	placement.num_busy_placement = 0;
-	placement.fpfn = 0;
-	placement.lpfn = 0;
-	ret = psb_ttm_bo_check_placement(bo, &placement);
-	if (unlikely(ret != 0))
-		return ret;
-
-	switch (new_fence_class) {
-	default:
-		n_fence_type = _PSB_FENCE_TYPE_EXE;
-	}
-
-	*new_fence_type = n_fence_type;
-	old_fence = (struct ttm_fence_object *) bo->sync_obj;
-	old_fence_type = (uint32_t) (unsigned long) bo->sync_obj_arg;
-
-	if (old_fence && ((new_fence_class != old_fence->fence_class) ||
-			  ((n_fence_type ^ old_fence_type) &
-			   old_fence_type))) {
-		ret = ttm_bo_wait(bo, 0, 1, 0);
-		if (unlikely(ret != 0))
-			return ret;
-	}
-	/*
-	bo->proposed_flags = (bo->proposed_flags | set_flags)
-		& ~clr_flags & TTM_PL_MASK_MEMTYPE;
-	*/
-	return 0;
-}
-
-int psb_validate_kernel_buffer(struct psb_context *context,
-			       struct ttm_buffer_object *bo,
-			       uint32_t fence_class,
-			       uint64_t set_flags, uint64_t clr_flags)
-{
-	struct psb_validate_buffer *item;
-	uint32_t cur_fence_type;
-	int ret;
-
-	if (unlikely(context->used_buffers >= PSB_NUM_VALIDATE_BUFFERS)) {
-		DRM_ERROR("Out of free validation buffer entries for "
-			  "kernel buffer validation.\n");
-		return -ENOMEM;
-	}
-
-	item = &context->buffers[context->used_buffers];
-	item->user_val_arg = NULL;
-	item->base.reserved = 0;
-
-	ret = ttm_bo_reserve(bo, 1, 0, 1, context->val_seq);
-	if (unlikely(ret != 0))
-	        return ret;
-
-	ret = psb_placement_fence_type(bo, set_flags, clr_flags, fence_class,
-				       &cur_fence_type);
-	if (unlikely(ret != 0)) {
-		ttm_bo_unreserve(bo);
-		return ret;
-	}
-
-	item->base.bo = ttm_bo_reference(bo);
-	item->base.new_sync_obj_arg = (void *) (unsigned long) cur_fence_type;
-	item->base.reserved = 1;
-
-	/* Internal locking ??? FIXMEAC */
-	list_add_tail(&item->base.head, &context->kern_validate_list);
-	context->used_buffers++;
-	/*
-	ret = ttm_bo_validate(bo, 1, 0, 0);
-	if (unlikely(ret != 0))
-		goto out_unlock;
-	*/
-	item->offset = bo->offset;
-	item->flags = bo->mem.placement;
-	context->fence_types |= cur_fence_type;
-
-	return ret;
-}
-
 void psb_fence_or_sync(struct drm_file *file_priv,
 		       uint32_t engine,
 		       uint32_t fence_types,

