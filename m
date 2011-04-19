Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab1DSOtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:49:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52977 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753052Ab1DSOtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:49:06 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 5/8] gma500: GEMify the frame buffer base bits
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 19 Apr 2011 15:28:03 +0100
Message-ID: <20110419142759.16479.44771.stgit@localhost.localdomain>
In-Reply-To: <20110419142432.16479.89255.stgit@localhost.localdomain>
References: <20110419142432.16479.89255.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This then kills off the old bo_ interfaces

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mrst_crtc.c         |   15 +++++++--------
 drivers/staging/gma500/psb_2d.c            |    4 ++--
 drivers/staging/gma500/psb_drm.h           |   11 -----------
 drivers/staging/gma500/psb_drv.c           |    4 ++--
 drivers/staging/gma500/psb_drv.h           |    2 --
 drivers/staging/gma500/psb_fb.c            |   24 +++++-------------------
 drivers/staging/gma500/psb_fb.h            |    5 +----
 drivers/staging/gma500/psb_intel_display.c |   14 +++++++-------
 8 files changed, 24 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/gma500/mrst_crtc.c b/drivers/staging/gma500/mrst_crtc.c
index 664d0e7..e4a0c03 100644
--- a/drivers/staging/gma500/mrst_crtc.c
+++ b/drivers/staging/gma500/mrst_crtc.c
@@ -530,9 +530,8 @@ int mrst_pipe_set_base(struct drm_crtc *crtc,
 	/* struct drm_i915_master_private *master_priv; */
 	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
 	struct psb_framebuffer *psbfb = to_psb_fb(crtc->fb);
-	struct psb_intel_mode_device *mode_dev = psb_intel_crtc->mode_dev;
 	int pipe = psb_intel_crtc->pipe;
-	unsigned long Start, Offset;
+	unsigned long start, offset;
 	/* FIXME: check if we need this surely MRST is pipe 0 only */
 	int dspbase = (pipe == 0 ? DSPALINOFF : DSPBBASE);
 	int dspsurf = (pipe == 0 ? DSPASURF : DSPBSURF);
@@ -552,8 +551,8 @@ int mrst_pipe_set_base(struct drm_crtc *crtc,
 	if (!gma_power_begin(dev, true))
 		return 0;
 
-	Start = mode_dev->bo_offset(dev, psbfb);
-	Offset = y * crtc->fb->pitch + x * (crtc->fb->bits_per_pixel / 8);
+	start = psbfb->gtt->offset;
+	offset = y * crtc->fb->pitch + x * (crtc->fb->bits_per_pixel / 8);
 
 	REG_WRITE(dspstride, crtc->fb->pitch);
 
@@ -581,14 +580,14 @@ int mrst_pipe_set_base(struct drm_crtc *crtc,
 	}
 	REG_WRITE(dspcntr_reg, dspcntr);
 
-	DRM_DEBUG("Writing base %08lX %08lX %d %d\n", Start, Offset, x, y);
+	DRM_DEBUG("Writing base %08lX %08lX %d %d\n", start, offset, x, y);
 	if (0 /* FIXMEAC - check what PSB needs */) {
-		REG_WRITE(dspbase, Offset);
+		REG_WRITE(dspbase, offset);
 		REG_READ(dspbase);
-		REG_WRITE(dspsurf, Start);
+		REG_WRITE(dspsurf, start);
 		REG_READ(dspsurf);
 	} else {
-		REG_WRITE(dspbase, Start + Offset);
+		REG_WRITE(dspbase, start + offset);
 		REG_READ(dspbase);
 	}
 
diff --git a/drivers/staging/gma500/psb_2d.c b/drivers/staging/gma500/psb_2d.c
index 29959de..0bd834c 100644
--- a/drivers/staging/gma500/psb_2d.c
+++ b/drivers/staging/gma500/psb_2d.c
@@ -160,7 +160,7 @@ static void psbfb_fillrect_accel(struct fb_info *info,
 	if (!fb)
 		return;
 
-	offset = psbfb->offset;
+	offset = psbfb->gtt->offset;
 	stride = fb->pitch;
 
 	switch (fb->depth) {
@@ -303,7 +303,7 @@ static void psbfb_copyarea_accel(struct fb_info *info,
 	if (!fb)
 		return;
 
-	offset = psbfb->offset;
+	offset = psbfb->gtt->offset;
 	stride = fb->pitch;
 
 	switch (fb->depth) {
diff --git a/drivers/staging/gma500/psb_drm.h b/drivers/staging/gma500/psb_drm.h
index 28862c7..49ffdd5 100644
--- a/drivers/staging/gma500/psb_drm.h
+++ b/drivers/staging/gma500/psb_drm.h
@@ -219,17 +219,6 @@ struct drm_psb_register_rw_arg {
 	u32 subpicture_disable_mask;
 };
 
-struct psb_gtt_mapping_arg {
-	void *hKernelMemInfo;
-	u32 offset_pages;
-};
-
-struct drm_psb_getpageaddrs_arg {
-	u32 handle;
-	unsigned long *page_addrs;
-	unsigned long gtt_offset;
-};
-
 /* Controlling the kernel modesetting buffers */
 
 #define DRM_PSB_KMS_OFF		0x00
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index f501cd7..01f6ed7 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -870,11 +870,11 @@ static int psb_mode_operation_ioctl(struct drm_device *dev, void *data,
 		psb_fb = to_psb_fb(drm_fb);
 
 		if (gma_power_begin(dev, 0)) {
-			REG_WRITE(DSPASURF, psb_fb->offset);
+			REG_WRITE(DSPASURF, psb_fb->gtt->offset);
 			REG_READ(DSPASURF);
 			gma_power_end(dev);
 		} else {
-			dev_priv->saveDSPASURF = psb_fb->offset;
+			dev_priv->saveDSPASURF = psb_fb->gtt->offset;
 		}
 
 		return 0;
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 4c983ff..e19a454 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -35,8 +35,6 @@
 /*Append new drm mode definition here, align with libdrm definition*/
 #define DRM_MODE_SCALE_NO_SCALE   2
 
-extern struct ttm_bo_driver psb_ttm_bo_driver;
-
 enum {
 	CHIP_PSB_8108 = 0,
 	CHIP_PSB_8109 = 1,
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 4ea39d6..f36e83f 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -310,7 +310,7 @@ static struct fb_ops psbfb_ops = {
 
 static struct drm_framebuffer *psb_framebuffer_create
 			(struct drm_device *dev, struct drm_mode_fb_cmd *r,
-			 void *mm_private)
+			 struct gtt_range *gt)
 {
 	struct psb_framebuffer *fb;
 	int ret;
@@ -326,7 +326,7 @@ static struct drm_framebuffer *psb_framebuffer_create
 
 	drm_helper_mode_fill_fb_struct(&fb->base, r);
 
-	fb->mem = mm_private;
+	fb->gtt = gt;
 
 	return &fb->base;
 
@@ -380,7 +380,6 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 		goto out_err1;
 	}
 	psbfb = to_psb_fb(fb);
-	psbfb->size = size;
 
 	info = framebuffer_alloc(sizeof(struct psb_fbdev), device);
 	if (!info) {
@@ -524,7 +523,7 @@ int psb_fbdev_destroy(struct drm_device *dev, struct psb_fbdev *fbdev)
 
 	if (fbdev->psb_fb_helper.fbdev) {
 		info = fbdev->psb_fb_helper.fbdev;
-		psb_gtt_free_range(dev, psbfb->mem);
+		psb_gtt_free_range(dev, psbfb->gtt);
 		unregister_framebuffer(info);
 		iounmap(info->screen_base);
 		framebuffer_release(info);
@@ -611,7 +610,7 @@ static int psb_user_framebuffer_create_handle(struct drm_framebuffer *fb,
 					      unsigned int *handle)
 {
         struct psb_framebuffer *psbfb = to_psb_fb(fb);
-        struct gtt_range *r = psbfb->mem;
+        struct gtt_range *r = psbfb->gtt;
         return drm_gem_handle_create(file_priv, &r->gem, handle);
 }
 
@@ -626,7 +625,7 @@ static void psb_user_framebuffer_destroy(struct drm_framebuffer *fb)
 {
 	struct drm_device *dev = fb->dev;
 	struct psb_framebuffer *psbfb = to_psb_fb(fb);
-	struct gtt_range *r = psbfb->mem;
+	struct gtt_range *r = psbfb->gtt;
 
 	if (psbfb->fbdev)
 		psbfb_remove(dev, fb);
@@ -732,17 +731,6 @@ static void psb_setup_outputs(struct drm_device *dev)
 	}
 }
 
-/* FIXME: rewrite this in terms of the gtt_range and GEM objects
-   rather than faking them as we do now */
-
-static size_t psb_bo_offset(struct drm_device *dev, void *obj)
-{
-	struct psb_framebuffer *psbfb
-		= (struct psb_framebuffer *)obj;
-
-	return (size_t)psbfb->offset;
-}
-
 void psb_modeset_init(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv =
@@ -751,8 +739,6 @@ void psb_modeset_init(struct drm_device *dev)
 	int i;
 
 	PSB_DEBUG_ENTRY("\n");
-	/* Init mm functions */
-	mode_dev->bo_offset = psb_bo_offset;
 
 	drm_mode_config_init(dev);
 
diff --git a/drivers/staging/gma500/psb_fb.h b/drivers/staging/gma500/psb_fb.h
index b943a9f..c8ec0d6 100644
--- a/drivers/staging/gma500/psb_fb.h
+++ b/drivers/staging/gma500/psb_fb.h
@@ -32,10 +32,7 @@ struct psb_framebuffer {
 	struct drm_framebuffer base;
 	struct address_space *addr_space;
 	struct fb_info *fbdev;
-	struct gtt_range *mem;
-	void * hKernelMemInfo;
-	uint32_t size;
-	uint32_t offset;
+	struct gtt_range *gtt;
 };
 
 struct psb_fbdev {
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index 697e1c3..4d384d5 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -343,7 +343,7 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 	struct psb_framebuffer *psbfb = to_psb_fb(crtc->fb);
 	struct psb_intel_mode_device *mode_dev = psb_intel_crtc->mode_dev;
 	int pipe = psb_intel_crtc->pipe;
-	unsigned long Start, Offset;
+	unsigned long start, offset;
 	int dspbase = (pipe == 0 ? DSPABASE : DSPBBASE);
 	int dspsurf = (pipe == 0 ? DSPASURF : DSPBSURF);
 	int dspstride = (pipe == 0) ? DSPASTRIDE : DSPBSTRIDE;
@@ -362,8 +362,8 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 	if (!gma_power_begin(dev, true))
 		return 0;
 
-	Start = mode_dev->bo_offset(dev, psbfb);
-	Offset = y * crtc->fb->pitch + x * (crtc->fb->bits_per_pixel / 8);
+	start = psbfb->gtt->offset;
+	offset = y * crtc->fb->pitch + x * (crtc->fb->bits_per_pixel / 8);
 
 	REG_WRITE(dspstride, crtc->fb->pitch);
 
@@ -391,14 +391,14 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 	}
 	REG_WRITE(dspcntr_reg, dspcntr);
 
-	DRM_DEBUG("Writing base %08lX %08lX %d %d\n", Start, Offset, x, y);
+	DRM_DEBUG("Writing base %08lX %08lX %d %d\n", start, offset, x, y);
 	if (0 /* FIXMEAC - check what PSB needs */) {
-		REG_WRITE(dspbase, Offset);
+		REG_WRITE(dspbase, offset);
 		REG_READ(dspbase);
-		REG_WRITE(dspsurf, Start);
+		REG_WRITE(dspsurf, start);
 		REG_READ(dspsurf);
 	} else {
-		REG_WRITE(dspbase, Start + Offset);
+		REG_WRITE(dspbase, start + offset);
 		REG_READ(dspbase);
 	}
 

