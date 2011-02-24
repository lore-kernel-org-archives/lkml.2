Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab1BXRSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:18:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47683 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751107Ab1BXRSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:18:11 -0500
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 1/2] gma500: Add 2D acceleration
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Thu, 24 Feb 2011 16:24:50 +0000
Message-ID: <20110224162440.27093.80825.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is taken from Richard Purdie's previous attempt to rip the heart out
of the PVR driver and stake it.

Accelerate copies and fills.

[Revised patch which disables the methods until we can finish debugging them]

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile  |    1 
 drivers/staging/gma500/psb_2d.c  |  411 ++++++++++++++++++++++++++++++++++++++
 drivers/staging/gma500/psb_drv.c |   12 +
 drivers/staging/gma500/psb_drv.h |   13 +
 drivers/staging/gma500/psb_fb.c  |    8 -
 drivers/staging/gma500/psb_irq.c |    4 
 6 files changed, 444 insertions(+), 5 deletions(-)
 create mode 100644 drivers/staging/gma500/psb_2d.c

diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index dba41e3..b9a7d2e 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -6,6 +6,7 @@ ccflags-y += -Iinclude/drm
 psb_gfx-y += psb_bl.o \
 	  psb_drv.o \
 	  psb_fb.o \
+	  psb_2d.o \
 	  psb_gtt.o \
 	  psb_intel_bios.o \
 	  psb_intel_display.o \
diff --git a/drivers/staging/gma500/psb_2d.c b/drivers/staging/gma500/psb_2d.c
new file mode 100644
index 0000000..e4cae5d
--- /dev/null
+++ b/drivers/staging/gma500/psb_2d.c
@@ -0,0 +1,411 @@
+/**************************************************************************
+ * Copyright (c) 2007, Intel Corporation.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Intel funded Tungsten Graphics (http://www.tungstengraphics.com) to
+ * develop this driver.
+ *
+ **************************************************************************/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/tty.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/console.h>
+
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc.h>
+
+#include "psb_drv.h"
+#include "psb_reg.h"
+#include "psb_drv.h"
+#include "psb_fb.h"
+#include "psb_sgx.h"
+
+void psb_spank(struct drm_psb_private *dev_priv)
+{
+        PSB_WSGX32(_PSB_CS_RESET_BIF_RESET | _PSB_CS_RESET_DPM_RESET |
+		_PSB_CS_RESET_TA_RESET | _PSB_CS_RESET_USE_RESET |
+		_PSB_CS_RESET_ISP_RESET | _PSB_CS_RESET_TSP_RESET |
+		_PSB_CS_RESET_TWOD_RESET, PSB_CR_SOFT_RESET);
+	(void) PSB_RSGX32(PSB_CR_SOFT_RESET);
+
+	msleep(1);
+
+	PSB_WSGX32(0, PSB_CR_SOFT_RESET);
+	wmb();
+	PSB_WSGX32(PSB_RSGX32(PSB_CR_BIF_CTRL) | _PSB_CB_CTRL_CLEAR_FAULT,
+		   PSB_CR_BIF_CTRL);
+	wmb();
+	(void) PSB_RSGX32(PSB_CR_BIF_CTRL);
+
+	msleep(1);
+	PSB_WSGX32(PSB_RSGX32(PSB_CR_BIF_CTRL) & ~_PSB_CB_CTRL_CLEAR_FAULT,
+		   PSB_CR_BIF_CTRL);
+	(void) PSB_RSGX32(PSB_CR_BIF_CTRL);
+	PSB_WSGX32(dev_priv->pg->gatt_start, PSB_CR_BIF_TWOD_REQ_BASE);
+}
+
+static int psb_2d_wait_available(struct drm_psb_private *dev_priv,
+			  unsigned size)
+{
+	uint32_t avail = PSB_RSGX32(PSB_CR_2D_SOCIF);
+	unsigned long t = jiffies + HZ;
+
+	while(avail < size) {
+		avail = PSB_RSGX32(PSB_CR_2D_SOCIF);
+		if (time_after(jiffies, t)) {
+			psb_spank(dev_priv);
+			return -EIO;
+		}
+	}
+	return 0;
+}
+
+/* FIXME: Remember if we expose the 2D engine to the DRM we need to serialize
+   it with console use */
+
+static int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
+	 	  	   unsigned size)
+{
+	int ret = 0;
+	int i;
+	unsigned submit_size;
+
+	while (size > 0) {
+		submit_size = (size < 0x60) ? size : 0x60;
+		size -= submit_size;
+		ret = psb_2d_wait_available(dev_priv, submit_size);
+		if (ret)
+			return ret;
+
+		submit_size <<= 2;
+		for (i = 0; i < submit_size; i += 4) {
+			PSB_WSGX32(*cmdbuf++, PSB_SGX_2D_SLAVE_PORT + i);
+		}
+		(void)PSB_RSGX32(PSB_SGX_2D_SLAVE_PORT + i - 4);
+	}
+	return 0;
+}
+
+static int psb_accel_2d_fillrect(struct drm_psb_private *dev_priv,
+				 uint32_t dst_offset, uint32_t dst_stride,
+				 uint32_t dst_format, uint16_t dst_x,
+				 uint16_t dst_y, uint16_t size_x,
+				 uint16_t size_y, uint32_t fill)
+{
+	uint32_t buffer[10];
+	uint32_t *buf;
+
+	buf = buffer;
+
+	*buf++ = PSB_2D_FENCE_BH;
+
+	*buf++ =
+	    PSB_2D_DST_SURF_BH | dst_format | (dst_stride <<
+					       PSB_2D_DST_STRIDE_SHIFT);
+	*buf++ = dst_offset;
+
+	*buf++ =
+	    PSB_2D_BLIT_BH |
+	    PSB_2D_ROT_NONE |
+	    PSB_2D_COPYORDER_TL2BR |
+	    PSB_2D_DSTCK_DISABLE |
+	    PSB_2D_SRCCK_DISABLE | PSB_2D_USE_FILL | PSB_2D_ROP3_PATCOPY;
+
+	*buf++ = fill << PSB_2D_FILLCOLOUR_SHIFT;
+	*buf++ =
+	    (dst_x << PSB_2D_DST_XSTART_SHIFT) | (dst_y <<
+						  PSB_2D_DST_YSTART_SHIFT);
+	*buf++ =
+	    (size_x << PSB_2D_DST_XSIZE_SHIFT) | (size_y <<
+						  PSB_2D_DST_YSIZE_SHIFT);
+	*buf++ = PSB_2D_FLUSH_BH;
+
+	return psbfb_2d_submit(dev_priv, buffer, buf - buffer);
+}
+
+static void psbfb_fillrect_accel(struct fb_info *info,
+				 const struct fb_fillrect *r)
+{
+	struct psb_fbdev *fbdev = info->par;
+	struct psb_framebuffer *psbfb = fbdev->pfb;
+	struct drm_device *dev = psbfb->base.dev;
+	struct drm_framebuffer *fb = fbdev->psb_fb_helper.fb;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	uint32_t offset;
+	uint32_t stride;
+	uint32_t format;
+
+	if (!fb)
+		return;
+
+	offset = psbfb->offset;
+	stride = fb->pitch;
+
+	switch (fb->depth) {
+	case 8:
+		format = PSB_2D_DST_332RGB;
+		break;
+	case 15:
+		format = PSB_2D_DST_555RGB;
+		break;
+	case 16:
+		format = PSB_2D_DST_565RGB;
+		break;
+	case 24:
+	case 32:
+		/* this is wrong but since we don't do blending its okay */
+		format = PSB_2D_DST_8888ARGB;
+		break;
+	default:
+		/* software fallback */
+		cfb_fillrect(info, r);
+		return;
+	}
+
+	psb_accel_2d_fillrect(dev_priv,
+			      offset, stride, format,
+			      r->dx, r->dy, r->width, r->height, r->color);
+}
+
+void psbfb_fillrect(struct fb_info *info,
+			   const struct fb_fillrect *rect)
+{
+	if (unlikely(info->state != FBINFO_STATE_RUNNING))
+		return;
+
+	if (1 || (info->flags & FBINFO_HWACCEL_DISABLED))
+		return cfb_fillrect(info, rect);
+
+	/*psb_check_power_state(dev, PSB_DEVICE_SGX); */
+	psbfb_fillrect_accel(info, rect);
+	/* Drop power again here on MRST FIXMEAC */
+}
+
+static u32 psb_accel_2d_copy_direction(int xdir, int ydir)
+{
+	if (xdir < 0)
+		return (ydir < 0) ? PSB_2D_COPYORDER_BR2TL :
+                			PSB_2D_COPYORDER_TR2BL;
+	else
+		return (ydir < 0) ? PSB_2D_COPYORDER_BL2TR :
+                			PSB_2D_COPYORDER_TL2BR;
+}
+
+/*
+ * @src_offset in bytes
+ * @src_stride in bytes
+ * @src_format psb 2D format defines
+ * @dst_offset in bytes
+ * @dst_stride in bytes
+ * @dst_format psb 2D format defines
+ * @src_x offset in pixels
+ * @src_y offset in pixels
+ * @dst_x offset in pixels
+ * @dst_y offset in pixels
+ * @size_x of the copied area
+ * @size_y of the copied area
+ */
+static int psb_accel_2d_copy(struct drm_psb_private *dev_priv,
+			     uint32_t src_offset, uint32_t src_stride,
+			     uint32_t src_format, uint32_t dst_offset,
+			     uint32_t dst_stride, uint32_t dst_format,
+			     uint16_t src_x, uint16_t src_y,
+			     uint16_t dst_x, uint16_t dst_y,
+			     uint16_t size_x, uint16_t size_y)
+{
+	uint32_t blit_cmd;
+	uint32_t buffer[10];
+	uint32_t *buf;
+	uint32_t direction;
+
+	buf = buffer;
+
+	direction =
+	    psb_accel_2d_copy_direction(src_x - dst_x, src_y - dst_y);
+
+	if (direction == PSB_2D_COPYORDER_BR2TL ||
+	    direction == PSB_2D_COPYORDER_TR2BL) {
+		src_x += size_x - 1;
+		dst_x += size_x - 1;
+	}
+	if (direction == PSB_2D_COPYORDER_BR2TL ||
+	    direction == PSB_2D_COPYORDER_BL2TR) {
+		src_y += size_y - 1;
+		dst_y += size_y - 1;
+	}
+
+	blit_cmd =
+	    PSB_2D_BLIT_BH |
+	    PSB_2D_ROT_NONE |
+	    PSB_2D_DSTCK_DISABLE |
+	    PSB_2D_SRCCK_DISABLE |
+	    PSB_2D_USE_PAT | PSB_2D_ROP3_SRCCOPY | direction;
+
+	*buf++ = PSB_2D_FENCE_BH;
+	*buf++ =
+	    PSB_2D_DST_SURF_BH | dst_format | (dst_stride <<
+					       PSB_2D_DST_STRIDE_SHIFT);
+	*buf++ = dst_offset;
+	*buf++ =
+	    PSB_2D_SRC_SURF_BH | src_format | (src_stride <<
+					       PSB_2D_SRC_STRIDE_SHIFT);
+	*buf++ = src_offset;
+	*buf++ =
+	    PSB_2D_SRC_OFF_BH | (src_x << PSB_2D_SRCOFF_XSTART_SHIFT) |
+	    (src_y << PSB_2D_SRCOFF_YSTART_SHIFT);
+	*buf++ = blit_cmd;
+	*buf++ =
+	    (dst_x << PSB_2D_DST_XSTART_SHIFT) | (dst_y <<
+						  PSB_2D_DST_YSTART_SHIFT);
+	*buf++ =
+	    (size_x << PSB_2D_DST_XSIZE_SHIFT) | (size_y <<
+						  PSB_2D_DST_YSIZE_SHIFT);
+	*buf++ = PSB_2D_FLUSH_BH;
+
+	return psbfb_2d_submit(dev_priv, buffer, buf - buffer);
+}
+
+static void psbfb_copyarea_accel(struct fb_info *info,
+				 const struct fb_copyarea *a)
+{
+	struct psb_fbdev *fbdev = info->par;
+	struct psb_framebuffer *psbfb = fbdev->pfb;
+	struct drm_device *dev = psbfb->base.dev;
+	struct drm_framebuffer *fb = fbdev->psb_fb_helper.fb;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	uint32_t offset;
+	uint32_t stride;
+	uint32_t src_format;
+	uint32_t dst_format;
+
+	if (!fb)
+		return;
+
+	offset = psbfb->offset;
+	stride = fb->pitch;
+
+	switch (fb->depth) {
+	case 8:
+		src_format = PSB_2D_SRC_332RGB;
+		dst_format = PSB_2D_DST_332RGB;
+		break;
+	case 15:
+		src_format = PSB_2D_SRC_555RGB;
+		dst_format = PSB_2D_DST_555RGB;
+		break;
+	case 16:
+		src_format = PSB_2D_SRC_565RGB;
+		dst_format = PSB_2D_DST_565RGB;
+		break;
+	case 24:
+	case 32:
+		/* this is wrong but since we don't do blending its okay */
+		src_format = PSB_2D_SRC_8888ARGB;
+		dst_format = PSB_2D_DST_8888ARGB;
+		break;
+	default:
+		/* software fallback */
+		cfb_copyarea(info, a);
+		return;
+	}
+
+	psb_accel_2d_copy(dev_priv,
+			  offset, stride, src_format,
+			  offset, stride, dst_format,
+			  a->sx, a->sy, a->dx, a->dy, a->width, a->height);
+}
+
+void psbfb_copyarea(struct fb_info *info,
+			   const struct fb_copyarea *region)
+{
+	if (unlikely(info->state != FBINFO_STATE_RUNNING))
+		return;
+
+	if (1 || (info->flags & FBINFO_HWACCEL_DISABLED))
+		return cfb_copyarea(info, region);
+
+	/* psb_check_power_state(dev, PSB_DEVICE_SGX); */
+	psbfb_copyarea_accel(info, region);
+	/* Need to power back off here for MRST FIXMEAC */
+}
+
+void psbfb_imageblit(struct fb_info *info, const struct fb_image *image)
+{
+        /* For now */
+	cfb_imageblit(info, image);
+}
+
+int psbfb_sync(struct fb_info *info)
+{
+	struct psb_fbdev *fbdev = info->par;
+	struct psb_framebuffer *psbfb = fbdev->pfb;
+	struct drm_device *dev = psbfb->base.dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	unsigned long _end = jiffies + DRM_HZ;
+	int busy = 0;
+
+#if 0
+        /* Just a way to quickly test if cmd issue explodes */
+	u32 test[2] = {
+	        PSB_2D_FENCE_BH,
+        };
+	psbfb_2d_submit(dev_priv, test, 1);
+#endif	
+	/*
+	 * First idle the 2D engine.
+	 */
+
+	if ((PSB_RSGX32(PSB_CR_2D_SOCIF) == _PSB_C2_SOCIF_EMPTY) &&
+	    ((PSB_RSGX32(PSB_CR_2D_BLIT_STATUS) & _PSB_C2B_STATUS_BUSY) == 0))
+		goto out;
+
+	do {
+		busy = (PSB_RSGX32(PSB_CR_2D_SOCIF) != _PSB_C2_SOCIF_EMPTY);
+		cpu_relax();
+	} while (busy && !time_after_eq(jiffies, _end));
+
+	if (busy)
+		busy = (PSB_RSGX32(PSB_CR_2D_SOCIF) != _PSB_C2_SOCIF_EMPTY);
+	if (busy)
+		goto out;
+
+	do {
+		busy = ((PSB_RSGX32(PSB_CR_2D_BLIT_STATUS) &
+						_PSB_C2B_STATUS_BUSY) != 0);
+		cpu_relax();
+	} while (busy && !time_after_eq(jiffies, _end));
+	if (busy)
+		busy = ((PSB_RSGX32(PSB_CR_2D_BLIT_STATUS) &
+					_PSB_C2B_STATUS_BUSY) != 0);
+
+out:
+	return (busy) ? -EBUSY : 0;
+}
+
+/*
+	info->fix.accel = FB_ACCEL_I830;
+	info->flags = FBINFO_DEFAULT;
+*/
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 6deec79..d82d544 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -424,6 +424,7 @@ static int psb_do_init(struct drm_device *dev)
 		goto out_err;
 	}
 
+
 	stolen_gtt = (pg->stolen_size >> PAGE_SHIFT) * 4;
 	stolen_gtt = (stolen_gtt + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	stolen_gtt =
@@ -449,6 +450,7 @@ static int psb_do_init(struct drm_device *dev)
 		     _PSB_CC_REVISION_DESIGNER_SHIFT);
 	}
 
+
 	spin_lock_init(&dev_priv->irqmask_lock);
 
 	tt_pages = (pg->gatt_pages < PSB_TT_PRIV0_PLIMIT) ?
@@ -457,6 +459,14 @@ static int psb_do_init(struct drm_device *dev)
 	tt_pages -= tt_start >> PAGE_SHIFT;
 	dev_priv->sizes.ta_mem_size = 0;
 
+	PSB_WSGX32(0x00000000, PSB_CR_BIF_BANK0);
+	PSB_WSGX32(0x00000000, PSB_CR_BIF_BANK1);
+	PSB_RSGX32(PSB_CR_BIF_BANK1);
+        PSB_WSGX32(PSB_RSGX32(PSB_CR_BIF_CTRL) | _PSB_MMU_ER_MASK,
+							PSB_CR_BIF_CTRL);
+	psb_spank(dev_priv);
+       
+      	PSB_WSGX32(pg->mmu_gatt_start, PSB_CR_BIF_TWOD_REQ_BASE);
 
 	/* TT region managed by TTM. */
 	if (!ttm_bo_init_mm(bdev, TTM_PL_TT,
@@ -478,7 +488,6 @@ static int psb_do_init(struct drm_device *dev)
 			PSB_MEM_TT_START / (1024*1024);
 	}
 
-
 	PSB_DEBUG_INIT("Init MSVDX\n");
 	return 0;
 out_err:
@@ -763,6 +772,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	dev_priv->pipestat[1] = 0;
 	dev_priv->pipestat[2] = 0;
 	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
+	PSB_WVDC32(0xFFFFFFFF, PSB_HWSTAM);
 	PSB_WVDC32(0x00000000, PSB_INT_ENABLE_R);
 	PSB_WVDC32(0xFFFFFFFF, PSB_INT_MASK_R);
 	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index cbc18ad..80b5c8d 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -901,6 +901,19 @@ extern int psbfb_kms_on_ioctl(struct drm_device *dev, void *data,
 extern void *psbfb_vdc_reg(struct drm_device* dev);
 
 /*
+ * psb_2d.c
+ */
+extern void psbfb_fillrect(struct fb_info *info,
+					const struct fb_fillrect *rect);
+extern void psbfb_copyarea(struct fb_info *info,
+					const struct fb_copyarea *region);
+extern void psbfb_imageblit(struct fb_info *info,
+					const struct fb_image *image);
+extern int psbfb_sync(struct fb_info *info);
+
+extern void psb_spank(struct drm_psb_private *dev_priv);
+
+/*
  *psb_reset.c
  */
 
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 6585e88..94d8457 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -279,10 +279,11 @@ static struct fb_ops psbfb_ops = {
 	.fb_set_par = drm_fb_helper_set_par,
 	.fb_blank = drm_fb_helper_blank,
 	.fb_setcolreg = psbfb_setcolreg,
-	.fb_fillrect = cfb_fillrect,
-	.fb_copyarea = cfb_copyarea,
-	.fb_imageblit = cfb_imageblit,
+	.fb_fillrect = psbfb_fillrect,
+	.fb_copyarea = psbfb_copyarea,
+	.fb_imageblit = psbfb_imageblit,
 	.fb_mmap = psbfb_mmap,
+	.fb_sync = psbfb_sync,
 };
 
 static struct drm_framebuffer *psb_framebuffer_create
@@ -394,6 +395,7 @@ static struct drm_framebuffer *psb_user_framebuffer_create
 	strcpy(info->fix.id, "psbfb");
 
 	info->flags = FBINFO_DEFAULT;
+	info->fix.accel = FB_ACCEL_I830;	/*FIXMEAC*/
 	info->fbops = &psbfb_ops;
 
 	info->fix.smem_start = dev->mode_config.fb_base;
diff --git a/drivers/staging/gma500/psb_irq.c b/drivers/staging/gma500/psb_irq.c
index a0ef4bb..4597c88 100644
--- a/drivers/staging/gma500/psb_irq.c
+++ b/drivers/staging/gma500/psb_irq.c
@@ -256,6 +256,7 @@ irqreturn_t psb_irq_handler(DRM_IRQ_ARGS)
 		PSB_WSGX32(s2, PSB_CR_EVENT_HOST_CLEAR2);
 		/* if s & _PSB_CE_TWOD_COMPLETE we have 2D done but
 		   we may as well poll even if we add that ! */
+		handled = 1;
 	}
 
 	PSB_WVDC32(vdc_stat, PSB_INT_IDENTITY_R);
@@ -300,9 +301,10 @@ void psb_irq_preinstall_islands(struct drm_device *dev, int hw_islands)
 						_MDFLD_PIPEC_EVENT_FLAG;
 		}
 	}
+/* NO I DONT WANT ANY IRQS GRRR FIXMEAC */
 	if (hw_islands & OSPM_GRAPHICS_ISLAND)
 		dev_priv->vdc_irq_mask |= _PSB_IRQ_SGX_FLAG;
-
+/* */
 	/*This register is safe even if display island is off*/
 	PSB_WVDC32(~dev_priv->vdc_irq_mask, PSB_INT_MASK_R);
 

