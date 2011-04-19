Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1DSOs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:48:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52973 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752789Ab1DSOs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:48:56 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 4/8] gma500: Begin the GEMification of the cursor code
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 19 Apr 2011 15:27:53 +0100
Message-ID: <20110419142748.16479.22040.stgit@localhost.localdomain>
In-Reply-To: <20110419142432.16479.89255.stgit@localhost.localdomain>
References: <20110419142432.16479.89255.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do a first pass over the cursor code and rework it to use GEM objects for
the cursor buffer as we need.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_fb.c            |   32 ++--------------
 drivers/staging/gma500/psb_intel_display.c |   56 +++++++++++-----------------
 drivers/staging/gma500/psb_intel_drv.h     |   13 +------
 3 files changed, 26 insertions(+), 75 deletions(-)

diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index eaf960e..4ea39d6 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -732,39 +732,17 @@ static void psb_setup_outputs(struct drm_device *dev)
 	}
 }
 
-/* FIXME: rewrite these in terms of the gtt_range and GEM objects
+/* FIXME: rewrite this in terms of the gtt_range and GEM objects
    rather than faking them as we do now */
 
-static void *psb_bo_from_handle(struct drm_device *dev,
-				struct drm_file *file_priv,
-				unsigned int handle)
-{
-	return NULL;
-}
-
-static size_t psb_bo_size(struct drm_device *dev, void *bof)
-{
-	return 0;
-}
-
-static size_t psb_bo_offset(struct drm_device *dev, void *bof)
+static size_t psb_bo_offset(struct drm_device *dev, void *obj)
 {
 	struct psb_framebuffer *psbfb
-		= (struct psb_framebuffer *)bof;
+		= (struct psb_framebuffer *)obj;
 
 	return (size_t)psbfb->offset;
 }
 
-static int psb_bo_pin_for_scanout(struct drm_device *dev, void *bo)
-{
-	 return 0;
-}
-
-static int psb_bo_unpin_for_scanout(struct drm_device *dev, void *bo)
-{
-	return 0;
-}
-
 void psb_modeset_init(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv =
@@ -774,11 +752,7 @@ void psb_modeset_init(struct drm_device *dev)
 
 	PSB_DEBUG_ENTRY("\n");
 	/* Init mm functions */
-	mode_dev->bo_from_handle = psb_bo_from_handle;
-	mode_dev->bo_size = psb_bo_size;
 	mode_dev->bo_offset = psb_bo_offset;
-	mode_dev->bo_pin_for_scanout = psb_bo_pin_for_scanout;
-	mode_dev->bo_unpin_for_scanout = psb_bo_unpin_for_scanout;
 
 	drm_mode_config_init(dev);
 
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index 6e14657..697e1c3 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -1014,8 +1014,6 @@ static void psb_intel_crtc_restore(struct drm_crtc *crtc)
 		REG_WRITE(paletteReg + (i << 2), crtc_state->savePalette[i]);
 }
 
-#if 0
-/* FIXME */
 static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 				 struct drm_file *file_priv,
 				 uint32_t handle,
@@ -1024,17 +1022,14 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 	struct drm_device *dev = crtc->dev;
 	struct drm_psb_private *dev_priv =
 				(struct drm_psb_private *)dev->dev_private;
-	struct psb_gtt *pg = dev_priv->pg;
 	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
-	struct psb_intel_mode_device *mode_dev = psb_intel_crtc->mode_dev;
 	int pipe = psb_intel_crtc->pipe;
 	uint32_t control = (pipe == 0) ? CURACNTR : CURBCNTR;
 	uint32_t base = (pipe == 0) ? CURABASE : CURBBASE;
 	uint32_t temp;
 	size_t addr = 0;
-	uint32_t page_offset;
-	size_t size;
-	void *bo;
+	struct gtt_range *gt;
+	struct drm_gem_object *obj;
 	int ret;
 
 	DRM_DEBUG("\n");
@@ -1043,8 +1038,7 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 	if (!handle) {
 		DRM_DEBUG("cursor off\n");
 		/* turn off the cursor */
-		temp = 0;
-		temp |= CURSOR_MODE_DISABLE;
+		temp = CURSOR_MODE_DISABLE;
 
         	if (gma_power_begin(dev, false)) {
 			REG_WRITE(control, temp);
@@ -1052,12 +1046,10 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 			gma_power_end(dev);
 		}
 
-		/* unpin the old bo */
-		if (psb_intel_crtc->cursor_bo) {
-			mode_dev->bo_unpin_for_scanout(dev,
-						       psb_intel_crtc->
-						       cursor_bo);
-			psb_intel_crtc->cursor_bo = NULL;
+		/* Unpin the old GEM object */
+		if (psb_intel_crtc->cursor_obj) {
+			drm_gem_object_unreference(psb_intel_crtc->cursor_obj);
+			psb_intel_crtc->cursor_obj = NULL;
 		}
 
 		return 0;
@@ -1069,15 +1061,11 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 		return -EINVAL;
 	}
 
-	bo = mode_dev->bo_from_handle(dev, file_priv, handle);
-	if (!bo)
+	obj = drm_gem_object_lookup(dev, file_priv, handle);
+	if (!obj)
 		return -ENOENT;
 
-	ret = mode_dev->bo_pin_for_scanout(dev, bo);
-	if (ret)
-		return ret;
-	size = mode_dev->bo_size(dev, bo);
-	if (size < width * height * 4) {
+	if (obj->size < width * height * 4) {
 		DRM_ERROR("buffer is to small\n");
 		return -ENOMEM;
 	}
@@ -1086,15 +1074,15 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 	DRM_DEBUG("%s: map meminfo for hw cursor. handle %x\n",
 						__func__, handle);
 
-	ret = psb_gtt_map_meminfo(dev, (void *)handle, &page_offset);
+/* Pin : FIXME
 	if (ret) {
 		DRM_ERROR("Can not map meminfo to GTT. handle 0x%x\n", handle);
 		return ret;
 	}
+*/
+	gt = container_of(obj, struct gtt_range, gem);
 
-	addr = page_offset << PAGE_SHIFT;
-
-	addr += dev_priv->stolen_base;
+	addr = gt->resource.start;
 
 	psb_intel_crtc->cursor_addr = addr;
 
@@ -1110,9 +1098,9 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 	}
 
 	/* unpin the old bo */
-	if (psb_intel_crtc->cursor_bo && psb_intel_crtc->cursor_bo != bo) {
-		mode_dev->bo_unpin_for_scanout(dev, psb_intel_crtc->cursor_bo);
-		psb_intel_crtc->cursor_bo = bo;
+	if (psb_intel_crtc->cursor_obj && psb_intel_crtc->cursor_obj != obj) {
+		drm_gem_object_unreference(psb_intel_crtc->cursor_obj);
+		psb_intel_crtc->cursor_obj = obj;
 	}
 
 	return 0;
@@ -1124,7 +1112,7 @@ static int psb_intel_crtc_cursor_move(struct drm_crtc *crtc, int x, int y)
 	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
 	int pipe = psb_intel_crtc->pipe;
 	uint32_t temp = 0;
-	uint32_t adder;
+	uint32_t addr;
 
 
 	if (x < 0) {
@@ -1139,16 +1127,15 @@ static int psb_intel_crtc_cursor_move(struct drm_crtc *crtc, int x, int y)
 	temp |= ((x & CURSOR_POS_MASK) << CURSOR_X_SHIFT);
 	temp |= ((y & CURSOR_POS_MASK) << CURSOR_Y_SHIFT);
 
-	adder = psb_intel_crtc->cursor_addr;
+	addr = psb_intel_crtc->cursor_addr;
 
        	if (gma_power_begin(dev, false)) {
 		REG_WRITE((pipe == 0) ? CURAPOS : CURBPOS, temp);
-		REG_WRITE((pipe == 0) ? CURABASE : CURBBASE, adder);
+		REG_WRITE((pipe == 0) ? CURABASE : CURBBASE, addr);
 		gma_power_end(dev);
 	}
 	return 0;
 }
-#endif
 
 static void psb_intel_crtc_gamma_set(struct drm_crtc *crtc, u16 *red,
 			 u16 *green, u16 *blue, uint32_t type, uint32_t size)
@@ -1315,6 +1302,7 @@ static void psb_intel_crtc_destroy(struct drm_crtc *crtc)
 {
 	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
 
+	/* FIXME: do we need to put the final GEM cursor ? */
 	kfree(psb_intel_crtc->crtc_state);
 	drm_crtc_cleanup(crtc);
 	kfree(psb_intel_crtc);
@@ -1332,10 +1320,8 @@ static const struct drm_crtc_helper_funcs psb_intel_helper_funcs = {
 const struct drm_crtc_funcs psb_intel_crtc_funcs = {
 	.save = psb_intel_crtc_save,
 	.restore = psb_intel_crtc_restore,
-/* FIXME 
 	.cursor_set = psb_intel_crtc_cursor_set,
 	.cursor_move = psb_intel_crtc_cursor_move,
-*/	
 	.gamma_set = psb_intel_crtc_gamma_set,
 	.set_config = psb_crtc_set_config,
 	.destroy = psb_intel_crtc_destroy,
diff --git a/drivers/staging/gma500/psb_intel_drv.h b/drivers/staging/gma500/psb_intel_drv.h
index f6229c5..6006ddd 100644
--- a/drivers/staging/gma500/psb_intel_drv.h
+++ b/drivers/staging/gma500/psb_intel_drv.h
@@ -76,13 +76,7 @@ struct psb_intel_mode_device {
 	/*
 	 * Abstracted memory manager operations
 	 */
-	void *(*bo_from_handle) (struct drm_device *dev,
-				 struct drm_file *file_priv,
-				 unsigned int handle);
-	 size_t(*bo_size) (struct drm_device *dev, void *bo);
 	 size_t(*bo_offset) (struct drm_device *dev, void *bo);
-	int (*bo_pin_for_scanout) (struct drm_device *dev, void *bo);
-	int (*bo_unpin_for_scanout) (struct drm_device *dev, void *bo);
 
 	/*
 	 * Cursor
@@ -156,11 +150,8 @@ struct psb_intel_crtc {
 	/* a mode_set for fbdev users on this crtc */
 	struct drm_mode_set mode_set;
 
-	/* current bo we scanout from */
-	void *scanout_bo;
-
-	/* current bo we cursor from */
-	void *cursor_bo;
+	/* GEM object that holds our cursor */
+	struct drm_gem_object *cursor_obj;
 
 	struct drm_display_mode saved_mode;
 	struct drm_display_mode saved_adjusted_mode;

