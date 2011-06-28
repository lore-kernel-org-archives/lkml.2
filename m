Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1F1WHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:07:53 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40991 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab1F1WH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:07:28 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 17/29] gma500: 2D polish
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:07:04 +0100
Message-ID: <20110628220702.898.47749.stgit@bob.linux.org.uk>
In-Reply-To: <20110628220151.898.15775.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Tidy up the 2D bits. For the fill case the CPU seems to be able to
outperform the graphics engine for the cases we get, so don't bother
fixing it but throw it out.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_2d.c  |  191 ++++++++++++++------------------------
 drivers/staging/gma500/psb_drv.h |    6 -
 drivers/staging/gma500/psb_fb.c  |    4 -
 3 files changed, 74 insertions(+), 127 deletions(-)


diff --git a/drivers/staging/gma500/psb_2d.c b/drivers/staging/gma500/psb_2d.c
index dea4bc1..df4c519 100644
--- a/drivers/staging/gma500/psb_2d.c
+++ b/drivers/staging/gma500/psb_2d.c
@@ -41,6 +41,14 @@
 #include "psb_drv.h"
 #include "psb_fb.h"
 
+/**
+ *	psb_spank		-	reset the 2D engine
+ *	@dev_priv: our PSB DRM device
+ *
+ *	Soft reset the graphics engine and then reload the necessary registers.
+ *	We use this at initialisation time but it will become relevant for
+ *	accelerated X later
+ */
 void psb_spank(struct drm_psb_private *dev_priv)
 {
 	PSB_WSGX32(_PSB_CS_RESET_BIF_RESET | _PSB_CS_RESET_DPM_RESET |
@@ -65,6 +73,14 @@ void psb_spank(struct drm_psb_private *dev_priv)
 	PSB_WSGX32(dev_priv->pg->gatt_start, PSB_CR_BIF_TWOD_REQ_BASE);
 }
 
+/**
+ *	psb2_2d_wait_available	-	wait for FIFO room
+ *	@dev_priv: our DRM device
+ *	@size: size (in dwords) of the command we want to issue
+ *
+ *	Wait until there is room to load the FIFO with our data. If the
+ *	device is not responding then reset it
+ */
 static int psb_2d_wait_available(struct drm_psb_private *dev_priv,
 			  unsigned size)
 {
@@ -81,9 +97,15 @@ static int psb_2d_wait_available(struct drm_psb_private *dev_priv,
 	return 0;
 }
 
-/* FIXME: Remember if we expose the 2D engine to the DRM we need to serialize
-   it with console use */
-
+/**
+ *	psb_2d_submit		-	submit a 2D command
+ *	@dev_priv: our DRM device
+ *	@cmdbuf: command to issue
+ *	@size: length (in dwords)
+ *
+ *	Issue one or more 2D commands to the accelerator. This needs to be
+ *	serialized later when we add the GEM interfaces for acceleration
+ */
 int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
 								unsigned size)
 {
@@ -108,104 +130,15 @@ int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
 	return 0;
 }
 
-static int psb_accel_2d_fillrect(struct drm_psb_private *dev_priv,
-				 uint32_t dst_offset, uint32_t dst_stride,
-				 uint32_t dst_format, uint16_t dst_x,
-				 uint16_t dst_y, uint16_t size_x,
-				 uint16_t size_y, uint32_t fill)
-{
-	uint32_t buffer[10];
-	uint32_t *buf;
-
-	buf = buffer;
-
-	*buf++ = PSB_2D_FENCE_BH;
-
-	*buf++ =
-	    PSB_2D_DST_SURF_BH | dst_format | (dst_stride <<
-					       PSB_2D_DST_STRIDE_SHIFT);
-	*buf++ = dst_offset;
-
-	*buf++ =
-	    PSB_2D_BLIT_BH |
-	    PSB_2D_ROT_NONE |
-	    PSB_2D_COPYORDER_TL2BR |
-	    PSB_2D_DSTCK_DISABLE |
-	    PSB_2D_SRCCK_DISABLE | PSB_2D_USE_FILL | PSB_2D_ROP3_PATCOPY;
-
-	*buf++ = fill << PSB_2D_FILLCOLOUR_SHIFT;
-	*buf++ =
-	    (dst_x << PSB_2D_DST_XSTART_SHIFT) | (dst_y <<
-						  PSB_2D_DST_YSTART_SHIFT);
-	*buf++ =
-	    (size_x << PSB_2D_DST_XSIZE_SHIFT) | (size_y <<
-						  PSB_2D_DST_YSIZE_SHIFT);
-	*buf++ = PSB_2D_FLUSH_BH;
-
-	return psbfb_2d_submit(dev_priv, buffer, buf - buffer);
-}
-
-static void psbfb_fillrect_accel(struct fb_info *info,
-				 const struct fb_fillrect *r)
-{
-	struct psb_fbdev *fbdev = info->par;
-	struct psb_framebuffer *psbfb = &fbdev->pfb;
-	struct drm_device *dev = psbfb->base.dev;
-	struct drm_framebuffer *fb = fbdev->psb_fb_helper.fb;
-	struct drm_psb_private *dev_priv = dev->dev_private;
-
-	uint32_t offset;
-	uint32_t stride;
-	uint32_t format;
-
-	if (!fb)
-		return;
-
-	offset = psbfb->gtt->offset;
-	stride = fb->pitch;
-
-	switch (fb->depth) {
-	case 8:
-		format = PSB_2D_DST_332RGB;
-		break;
-	case 15:
-		format = PSB_2D_DST_555RGB;
-		break;
-	case 16:
-		format = PSB_2D_DST_565RGB;
-		break;
-	case 24:
-	case 32:
-		/* this is wrong but since we don't do blending its okay */
-		format = PSB_2D_DST_8888ARGB;
-		break;
-	default:
-		/* software fallback */
-		cfb_fillrect(info, r);
-		return;
-	}
-	if (!gma_power_begin(dev, false)) {
-		cfb_fillrect(info, r);
-		return;
-	}
-	psb_accel_2d_fillrect(dev_priv,
-			      offset, stride, format,
-			      r->dx, r->dy, r->width, r->height, r->color);
-	gma_power_end(dev);
-}
-
-void psbfb_fillrect(struct fb_info *info,
-			   const struct fb_fillrect *rect)
-{
-	if (unlikely(info->state != FBINFO_STATE_RUNNING))
-		return;
-
-	if (1 || (info->flags & FBINFO_HWACCEL_DISABLED))
-		return cfb_fillrect(info, rect);
-
-	psbfb_fillrect_accel(info, rect);
-}
 
+/**
+ *	psb_accel_2d_copy_direction	-	compute blit order
+ *	@xdir: X direction of move
+ *	@ydir: Y direction of move
+ *
+ *	Compute the correct order setings to ensure that an overlapping blit
+ *	correctly copies all the pixels.
+ */
 static u32 psb_accel_2d_copy_direction(int xdir, int ydir)
 {
 	if (xdir < 0)
@@ -216,19 +149,23 @@ static u32 psb_accel_2d_copy_direction(int xdir, int ydir)
 						PSB_2D_COPYORDER_TL2BR;
 }
 
-/*
- * @src_offset in bytes
- * @src_stride in bytes
- * @src_format psb 2D format defines
- * @dst_offset in bytes
- * @dst_stride in bytes
- * @dst_format psb 2D format defines
- * @src_x offset in pixels
- * @src_y offset in pixels
- * @dst_x offset in pixels
- * @dst_y offset in pixels
- * @size_x of the copied area
- * @size_y of the copied area
+/**
+ *	psb_accel_2d_copy		-	accelerated 2D copy
+ *	@dev_priv: our DRM device
+ *	@src_offset in bytes
+ *	@src_stride in bytes
+ *	@src_format psb 2D format defines
+ *	@dst_offset in bytes
+ *	@dst_stride in bytes
+ *	@dst_format psb 2D format defines
+ *	@src_x offset in pixels
+ *	@src_y offset in pixels
+ *	@dst_x offset in pixels
+ *	@dst_y offset in pixels
+ *	@size_x of the copied area
+ *	@size_y of the copied area
+ *
+ *	Format and issue a 2D accelerated copy command.
  */
 static int psb_accel_2d_copy(struct drm_psb_private *dev_priv,
 			     uint32_t src_offset, uint32_t src_stride,
@@ -290,6 +227,13 @@ static int psb_accel_2d_copy(struct drm_psb_private *dev_priv,
 	return psbfb_2d_submit(dev_priv, buffer, buf - buffer);
 }
 
+/**
+ *	psbfb_copyarea_accel	-	copyarea acceleration for /dev/fb
+ *	@info: our framebuffer
+ *	@a: copyarea parameters from the framebuffer core
+ *
+ *	Perform a 2D copy via the accelerator
+ */
 static void psbfb_copyarea_accel(struct fb_info *info,
 				 const struct fb_copyarea *a)
 {
@@ -345,6 +289,14 @@ static void psbfb_copyarea_accel(struct fb_info *info,
 	gma_power_end(dev);
 }
 
+/**
+ *	psbfb_copyarea	-	2D copy interface
+ *	@info: our framebuffer
+ *	@region: region to copy
+ *
+ *	Copy an area of the framebuffer console either by the accelerator
+ *	or directly using the cfb helpers according to the request
+ */
 void psbfb_copyarea(struct fb_info *info,
 			   const struct fb_copyarea *region)
 {
@@ -359,12 +311,13 @@ void psbfb_copyarea(struct fb_info *info,
 	psbfb_copyarea_accel(info, region);
 }
 
-void psbfb_imageblit(struct fb_info *info, const struct fb_image *image)
-{
-	/* For now */
-	cfb_imageblit(info, image);
-}
-
+/**
+ *	psbfb_sync	-	synchronize 2D
+ *	@info: our framebuffer
+ *
+ *	Wait for the 2D engine to quiesce so that we can do CPU
+ *	access to the framebuffer again
+ */
 int psbfb_sync(struct fb_info *info)
 {
 	struct psb_fbdev *fbdev = info->par;
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 1114021..cafbfcd 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -587,16 +587,10 @@ extern void *psbfb_vdc_reg(struct drm_device* dev);
 /*
  * psb_2d.c
  */
-extern void psbfb_fillrect(struct fb_info *info,
-					const struct fb_fillrect *rect);
 extern void psbfb_copyarea(struct fb_info *info,
 					const struct fb_copyarea *region);
-extern void psbfb_imageblit(struct fb_info *info,
-					const struct fb_image *image);
 extern int psbfb_sync(struct fb_info *info);
-
 extern void psb_spank(struct drm_psb_private *dev_priv);
-
 extern int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
 					unsigned size);
 
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index f1a7e8d..c2d4b23 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -289,9 +289,9 @@ static struct fb_ops psbfb_ops = {
 	.fb_set_par = drm_fb_helper_set_par,
 	.fb_blank = drm_fb_helper_blank,
 	.fb_setcolreg = psbfb_setcolreg,
-	.fb_fillrect = psbfb_fillrect,
+	.fb_fillrect = cfb_fillrect,
 	.fb_copyarea = psbfb_copyarea,
-	.fb_imageblit = psbfb_imageblit,
+	.fb_imageblit = cfb_imageblit,
 	.fb_mmap = psbfb_mmap,
 	.fb_sync = psbfb_sync,
 	.fb_ioctl = psbfb_ioctl,

