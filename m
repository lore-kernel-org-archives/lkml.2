Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1DSOts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:49:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48195 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752911Ab1DSOtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:49:47 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 8/8] gma500: allow non stolen page backed framebuffer
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 19 Apr 2011 15:28:45 +0100
Message-ID: <20110419142837.16479.67731.stgit@localhost.localdomain>
In-Reply-To: <20110419142432.16479.89255.stgit@localhost.localdomain>
References: <20110419142432.16479.89255.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For Moorestown at least we may not have stolen RAM with which to back the
initial framebuffer. Allow a GEM backing.

At this point we should have all the bits in place needed to make it work once
it has been debugged.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_fb.c            |   43 ++++++++++++++++++++++++++--
 drivers/staging/gma500/psb_gem.c           |    2 +
 drivers/staging/gma500/psb_gtt.c           |    1 -
 drivers/staging/gma500/psb_intel_display.c |   36 +++++++++++++++--------
 4 files changed, 65 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index f36e83f..ae097cd 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -336,6 +336,38 @@ err:
 }
 
 /**
+ *	psbfb_alloc		-	allocate frame buffer memory
+ *	@dev: the DRM device
+ *	@aligned_size: space needed
+ *
+ *	Allocate the frame buffer. In the usual case we get a GTT range that
+ *	is stolen memory backed and life is simple. If there isn't sufficient
+ *	stolen memory or the system has no stolen memory we allocate a range
+ *	and back it with a GEM object.
+ *
+ *	In this case the GEM object has no handle. 
+ */
+static struct gtt_range *psbfb_alloc(struct drm_device *dev, int aligned_size)
+{
+	struct gtt_range *backing;
+	/* Begin by trying to use stolen memory backing */
+	backing = psb_gtt_alloc_range(dev, aligned_size, "fb", 1);
+	if (backing)
+		return backing;
+	/* Next try using GEM host memory */
+	backing = psb_gtt_alloc_range(dev, aligned_size, "fb(gem)", 0);
+	if (backing == NULL)
+		return NULL;
+
+	/* Now back it with an object */
+	if (drm_gem_object_init(dev, &backing->gem, aligned_size) != 0) {
+		psb_gtt_free_range(dev, backing);
+		return NULL;
+	}
+	return backing;
+}
+	
+/**
  *	psbfb_create		-	create a framebuffer
  *	@fbdev: the framebuffer device
  *	@sizes: specification of the layout
@@ -368,7 +400,7 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	aligned_size = ALIGN(size, PAGE_SIZE);
 
 	/* Allocate the framebuffer in the GTT with stolen page backing */
-	backing = psb_gtt_alloc_range(dev, aligned_size, "fb", 1);
+	backing = psbfb_alloc(dev, aligned_size);
 	if (backing == NULL)
 	        return -ENOMEM;
 
@@ -523,7 +555,13 @@ int psb_fbdev_destroy(struct drm_device *dev, struct psb_fbdev *fbdev)
 
 	if (fbdev->psb_fb_helper.fbdev) {
 		info = fbdev->psb_fb_helper.fbdev;
-		psb_gtt_free_range(dev, psbfb->gtt);
+		/* FIXME: this is a bit more inside knowledge than I'd like
+		   but I don't see how to make a fake GEM object of the
+		   stolen space nicely */
+		if (psbfb->gtt->stolen)
+			psb_gtt_free_range(dev, psbfb->gtt);
+		else
+			drm_gem_object_unreference(&psbfb->gtt->gem);
 		unregister_framebuffer(info);
 		iounmap(info->screen_base);
 		framebuffer_release(info);
@@ -571,7 +609,6 @@ void psb_fbdev_fini(struct drm_device *dev)
 	dev_priv->fbdev = NULL;
 }
 
-
 static void psbfb_output_poll_changed(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
diff --git a/drivers/staging/gma500/psb_gem.c b/drivers/staging/gma500/psb_gem.c
index 0438bf4..d47c187 100644
--- a/drivers/staging/gma500/psb_gem.c
+++ b/drivers/staging/gma500/psb_gem.c
@@ -39,6 +39,8 @@ int psb_gem_init_object(struct drm_gem_object *obj)
 
 void psb_gem_free_object(struct drm_gem_object *obj)
 {
+	struct gtt_range *gtt = container_of(obj, struct gtt_range, gem);
+	psb_gtt_free_range(obj->dev, gtt);
 	drm_gem_object_release(obj);
 }
 
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index a991c12..10d772a 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -298,7 +298,6 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 	return NULL;
 }
 
-
 static void psb_gtt_destroy(struct kref *kref)
 {
 	struct gtt_range *gt = container_of(kref, struct gtt_range, kref);
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index b5a36d2..9e1446f 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -361,7 +361,13 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 	if (!gma_power_begin(dev, true))
 		return 0;
 
+	/* We are displaying this buffer, make sure it is actually loaded
+	   into the GTT */
+	ret = psb_gtt_pin(dev, psbfb->gtt);
+	if (ret < 0)
+		goto psb_intel_pipe_set_base_exit;
 	start = psbfb->gtt->offset;
+
 	offset = y * crtc->fb->pitch + x * (crtc->fb->bits_per_pixel / 8);
 
 	REG_WRITE(dspstride, crtc->fb->pitch);
@@ -386,10 +392,12 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 	default:
 		DRM_ERROR("Unknown color depth\n");
 		ret = -EINVAL;
+		psb_gtt_unpin(dev, psbfb->gtt);
 		goto psb_intel_pipe_set_base_exit;
 	}
 	REG_WRITE(dspcntr_reg, dspcntr);
 
+
 	DRM_DEBUG("Writing base %08lX %08lX %d %d\n", start, offset, x, y);
 	if (0 /* FIXMEAC - check what PSB needs */) {
 		REG_WRITE(dspbase, offset);
@@ -401,10 +409,12 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 		REG_READ(dspbase);
 	}
 
-psb_intel_pipe_set_base_exit:
+	/* If there was a previous display we can now unpin it */
+	if (old_fb)
+		psb_gtt_unpin(dev, to_psb_fb(old_fb)->gtt);
 
+psb_intel_pipe_set_base_exit:
 	gma_power_end(dev);
-
 	return ret;
 }
 
@@ -1037,7 +1047,7 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 		/* turn off the cursor */
 		temp = CURSOR_MODE_DISABLE;
 
-        	if (gma_power_begin(dev, false)) {
+		if (gma_power_begin(dev, false)) {
 			REG_WRITE(control, temp);
 			REG_WRITE(base, 0);
 			gma_power_end(dev);
@@ -1045,8 +1055,8 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 
 		/* Unpin the old GEM object */
 		if (psb_intel_crtc->cursor_obj) {
-                	gt = container_of(psb_intel_crtc->cursor_obj,
-                	                        struct gtt_range, gem);
+			gt = container_of(psb_intel_crtc->cursor_obj,
+							struct gtt_range, gem);
 			psb_gtt_unpin(crtc->dev, gt);
 			drm_gem_object_unreference(psb_intel_crtc->cursor_obj);
 			psb_intel_crtc->cursor_obj = NULL;
@@ -1089,7 +1099,7 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 	temp |= (pipe << 28);
 	temp |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
 
-       	if (gma_power_begin(dev, false)) {
+	if (gma_power_begin(dev, false)) {
 		REG_WRITE(control, temp);
 		REG_WRITE(base, addr);
 		gma_power_end(dev);
@@ -1097,8 +1107,8 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 
 	/* unpin the old bo */
 	if (psb_intel_crtc->cursor_obj && psb_intel_crtc->cursor_obj != obj) {
-               	gt = container_of(psb_intel_crtc->cursor_obj,
-               	                        struct gtt_range, gem);
+		gt = container_of(psb_intel_crtc->cursor_obj,
+							struct gtt_range, gem);
 		psb_gtt_unpin(crtc->dev, gt);
 		drm_gem_object_unreference(psb_intel_crtc->cursor_obj);
 		psb_intel_crtc->cursor_obj = obj;
@@ -1130,7 +1140,7 @@ static int psb_intel_crtc_cursor_move(struct drm_crtc *crtc, int x, int y)
 
 	addr = psb_intel_crtc->cursor_addr;
 
-       	if (gma_power_begin(dev, false)) {
+	if (gma_power_begin(dev, false)) {
 		REG_WRITE((pipe == 0) ? CURAPOS : CURBPOS, temp);
 		REG_WRITE((pipe == 0) ? CURABASE : CURBBASE, addr);
 		gma_power_end(dev);
@@ -1183,7 +1193,7 @@ static int psb_intel_crtc_clock_get(struct drm_device *dev,
 	bool is_lvds;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 
-       	if (gma_power_begin(dev, false)) {
+	if (gma_power_begin(dev, false)) {
 		dpll = REG_READ((pipe == 0) ? DPLL_A : DPLL_B);
 		if ((dpll & DISPLAY_RATE_SELECT_FPA1) == 0)
 			fp = REG_READ((pipe == 0) ? FPA0 : FPB0);
@@ -1262,7 +1272,7 @@ struct drm_display_mode *psb_intel_crtc_mode_get(struct drm_device *dev,
 	int vsync;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 
-       	if (gma_power_begin(dev, false)) {
+	if (gma_power_begin(dev, false)) {
 		htot = REG_READ((pipe == 0) ? HTOTAL_A : HTOTAL_B);
 		hsync = REG_READ((pipe == 0) ? HSYNC_A : HSYNC_B);
 		vtot = REG_READ((pipe == 0) ? VTOTAL_A : VTOTAL_B);
@@ -1387,10 +1397,10 @@ void psb_intel_crtc_init(struct drm_device *dev, int pipe,
 	psb_intel_crtc->cursor_addr = 0;
 
 	if (IS_MRST(dev))
-        	drm_crtc_helper_add(&psb_intel_crtc->base,
+		drm_crtc_helper_add(&psb_intel_crtc->base,
 				    &mrst_helper_funcs);
 	else
-        	drm_crtc_helper_add(&psb_intel_crtc->base,
+		drm_crtc_helper_add(&psb_intel_crtc->base,
 				    &psb_intel_helper_funcs);
 
 	/* Setup the array of drm_connector pointer array */

