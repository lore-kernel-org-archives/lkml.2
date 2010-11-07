Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab0KGQbz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 11:31:55 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64280 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab0KGQbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 11:31:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VsOHcPvryha/nxCeagbQClii3DTZtVm0CTwYeqYTbxoxIM+G4DLqr93lRMR8epwOeF
         /x3/L3/gTR3gpKhnx9eg3TeK6F24olPGpDetKBf/Fg8Z8z3mTiRbpZlVIcxKFwpqPQan
         NUl6q/ke6j4SUtQMK0RW+RZxTjNhzxu8OPRmc=
From: Alexey Charkov <alchark@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        Alexey Charkov <alchark@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6 v2] ARM: Add support for the display controllers in VT8500 and WM8505
Date: Sun,  7 Nov 2010 19:28:57 +0300
Message-Id: <1289147348-31969-6-git-send-email-alchark@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1289147348-31969-1-git-send-email-alchark@gmail.com>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds drivers for the LCD controller found in VIA VT8500 SoC,
GOVR display controller found in WonderMedia WM8505 SoC and for the
Graphics Engine present in both of them that provides hardware
accelerated raster operations (used for copyarea and fillrect).

Signed-off-by: Alexey Charkov <alchark@gmail.com>
---

Please review and (if appropriate) commit to a relevant git tree for
further integration in 2.6.38.

Compared to the previous submission, this code just contains a rebase
against the latest changes introduced in 2.6.37 merge window.

Relevant platform definitions are introduced by PATCH 1/6 in this series,
so one would need that to make use of this code.

Due credits go to the community for providing feedback, advice and
testing. Driver for WM8505 is by Ed Spiridonov, as stated in the
relevant copyright header, parts modified by myself.

Invaluable work wrt the Graphics Engine documentation has been done
by Giuseppe Gatta aka nextvolume. Also special thanks go to Angus
Gratton aka projectgus for convincing VIA to partly release GPL
kernel sources for the vendor-provided images, which greatly helped
in understanding some parts of WM8505's complex video handling chain.

 drivers/video/Kconfig         |   26 +++
 drivers/video/Makefile        |    3 +
 drivers/video/vt8500lcdfb.c   |  452 +++++++++++++++++++++++++++++++++++++++++
 drivers/video/vt8500lcdfb.h   |   34 +++
 drivers/video/wm8505fb.c      |  438 +++++++++++++++++++++++++++++++++++++++
 drivers/video/wm8505fb_regs.h |   76 +++++++
 drivers/video/wmt_ge_rops.c   |  186 +++++++++++++++++
 drivers/video/wmt_ge_rops.h   |    5 +
 8 files changed, 1220 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/vt8500lcdfb.c
 create mode 100644 drivers/video/vt8500lcdfb.h
 create mode 100644 drivers/video/wm8505fb.c
 create mode 100644 drivers/video/wm8505fb_regs.h
 create mode 100644 drivers/video/wmt_ge_rops.c
 create mode 100644 drivers/video/wmt_ge_rops.h

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 27c1fb4..954f6e9 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -186,6 +186,14 @@ config FB_SYS_FOPS
        depends on FB
        default n
 
+config FB_WMT_GE_ROPS
+	tristate
+	depends on FB
+	default n
+	---help---
+	  Include functions for accelerated rectangle filling and area
+	  copying using WonderMedia Graphics Engine operations.
+
 config FB_DEFERRED_IO
 	bool
 	depends on FB
@@ -1722,6 +1730,24 @@ config FB_AU1200
 	  various panels and CRTs by passing in kernel cmd line option
 	  au1200fb:panel=<name>.
 
+config FB_VT8500
+	bool "VT8500 LCD Driver"
+	depends on (FB = y) && ARM && ARCH_VT8500 && VTWM_VERSION_VT8500
+	select FB_WMT_GE_ROPS
+	select FB_SYS_IMAGEBLIT
+	help
+	  This is the framebuffer driver for VIA VT8500 integrated LCD
+	  controller.
+
+config FB_WM8505
+	bool "WM8505 frame buffer support"
+	depends on (FB = y) && ARM && ARCH_VT8500 && VTWM_VERSION_WM8505
+	select FB_WMT_GE_ROPS
+	select FB_SYS_IMAGEBLIT
+	help
+	  This is the framebuffer driver for WonderMedia WM8505
+	  integrated LCD controller.
+
 source "drivers/video/geode/Kconfig"
 
 config FB_HIT
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 485e8ed..8d916dc 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_FB_SVGALIB)       += svgalib.o
 obj-$(CONFIG_FB_MACMODES)      += macmodes.o
 obj-$(CONFIG_FB_DDC)           += fb_ddc.o
 obj-$(CONFIG_FB_DEFERRED_IO)   += fb_defio.o
+obj-$(CONFIG_FB_WMT_GE_ROPS)   += wmt_ge_rops.o
 
 # Hardware specific drivers go first
 obj-$(CONFIG_FB_AMIGA)            += amifb.o c2p_planar.o
@@ -104,6 +105,8 @@ obj-$(CONFIG_FB_W100)		  += w100fb.o
 obj-$(CONFIG_FB_TMIO)		  += tmiofb.o
 obj-$(CONFIG_FB_AU1100)		  += au1100fb.o
 obj-$(CONFIG_FB_AU1200)		  += au1200fb.o
+obj-$(CONFIG_FB_VT8500)		  += vt8500lcdfb.o
+obj-$(CONFIG_FB_WM8505)		  += wm8505fb.o
 obj-$(CONFIG_FB_PMAG_AA)	  += pmag-aa-fb.o
 obj-$(CONFIG_FB_PMAG_BA)	  += pmag-ba-fb.o
 obj-$(CONFIG_FB_PMAGB_B)	  += pmagb-b-fb.o
diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
new file mode 100644
index 0000000..3dd2296
--- /dev/null
+++ b/drivers/video/vt8500lcdfb.c
@@ -0,0 +1,452 @@
+/*
+ *  linux/drivers/video/vt8500lcdfb.c
+ *
+ *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ *
+ * Based on skeletonfb.c and pxafb.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <linux/wait.h>
+
+#include <asm/irq.h>
+
+#include <mach/vt8500fb.h>
+
+#include "vt8500lcdfb.h"
+#include "wmt_ge_rops.h"
+
+static int vt8500lcd_set_par(struct fb_info *info)
+{
+	struct vt8500lcd_info *fbi = container_of(info,
+						  struct vt8500lcd_info,
+						  fb);
+	int reg_bpp = 5; /* 16bpp */
+	int i;
+	unsigned long control0;
+
+	if (!fbi)
+		return -EINVAL;
+
+	if (info->var.bits_per_pixel <= 8) {
+		/* palettized */
+		info->var.red.offset    = 0;
+		info->var.red.length    = info->var.bits_per_pixel;
+		info->var.red.msb_right = 0;
+
+		info->var.green.offset  = 0;
+		info->var.green.length  = info->var.bits_per_pixel;
+		info->var.green.msb_right = 0;
+
+		info->var.blue.offset   = 0;
+		info->var.blue.length   = info->var.bits_per_pixel;
+		info->var.blue.msb_right = 0;
+
+		info->var.transp.offset = 0;
+		info->var.transp.length = 0;
+		info->var.transp.msb_right = 0;
+
+		info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
+		info->fix.line_length = info->var.xres_virtual /
+						(8/info->var.bits_per_pixel);
+	} else {
+		/* non-palettized */
+		info->var.transp.offset = 0;
+		info->var.transp.length = 0;
+		info->var.transp.msb_right = 0;
+
+		if (info->var.bits_per_pixel == 16) {
+			/* RGB565 */
+			info->var.red.offset = 11;
+			info->var.red.length = 5;
+			info->var.red.msb_right = 0;
+			info->var.green.offset = 5;
+			info->var.green.length = 6;
+			info->var.green.msb_right = 0;
+			info->var.blue.offset = 0;
+			info->var.blue.length = 5;
+			info->var.blue.msb_right = 0;
+		} else {
+			/* Equal depths per channel */
+			info->var.red.offset = info->var.bits_per_pixel
+							* 2 / 3;
+			info->var.red.length = info->var.bits_per_pixel / 3;
+			info->var.red.msb_right = 0;
+			info->var.green.offset = info->var.bits_per_pixel / 3;
+			info->var.green.length = info->var.bits_per_pixel / 3;
+			info->var.green.msb_right = 0;
+			info->var.blue.offset = 0;
+			info->var.blue.length = info->var.bits_per_pixel / 3;
+			info->var.blue.msb_right = 0;
+		}
+
+		info->fix.visual = FB_VISUAL_TRUECOLOR;
+		info->fix.line_length = info->var.bits_per_pixel > 16 ?
+					info->var.xres_virtual << 2 :
+					info->var.xres_virtual << 1;
+	}
+
+	for (i = 0; i < 8; i++) {
+		if (bpp_values[i] == info->var.bits_per_pixel) {
+			reg_bpp = i;
+			continue;
+		}
+	}
+
+	control0 = readl(fbi->regbase) & ~0xf;
+	writel(0, fbi->regbase);
+	while (readl(fbi->regbase + 0x38) & 0x10)
+		/* wait */;
+	writel((((info->var.hsync_len - 1) & 0x3f) << 26)
+		| ((info->var.left_margin & 0xff) << 18)
+		| (((info->var.xres - 1) & 0x3ff) << 8)
+		| (info->var.right_margin & 0xff), fbi->regbase + 0x4);
+	writel((((info->var.vsync_len - 1) & 0x3f) << 26)
+		| ((info->var.upper_margin & 0xff) << 18)
+		| (((info->var.yres - 1) & 0x3ff) << 8)
+		| (info->var.lower_margin & 0xff), fbi->regbase + 0x8);
+	writel((((info->var.yres - 1) & 0x400) << 2)
+		| ((info->var.xres - 1) & 0x400), fbi->regbase + 0x10);
+	writel(0x80000000, fbi->regbase + 0x20);
+	writel(control0 | (reg_bpp << 1) | 0x100, fbi->regbase);
+
+	return 0;
+}
+
+static inline u_int chan_to_field(u_int chan, struct fb_bitfield *bf)
+{
+	chan &= 0xffff;
+	chan >>= 16 - bf->length;
+	return chan << bf->offset;
+}
+
+static int vt8500lcd_setcolreg(unsigned regno, unsigned red, unsigned green,
+			   unsigned blue, unsigned transp,
+			   struct fb_info *info) {
+	struct vt8500lcd_info *fbi = container_of(info,
+						  struct vt8500lcd_info,
+						  fb);
+	int ret = 1;
+	unsigned int val;
+	if (regno >= 256)
+		return -EINVAL;
+
+	if (info->var.grayscale)
+		red = green = blue =
+			(19595 * red + 38470 * green + 7471 * blue) >> 16;
+
+	switch (fbi->fb.fix.visual) {
+	case FB_VISUAL_TRUECOLOR:
+		if (regno < 16) {
+			u32 *pal = fbi->fb.pseudo_palette;
+
+			val  = chan_to_field(red, &fbi->fb.var.red);
+			val |= chan_to_field(green, &fbi->fb.var.green);
+			val |= chan_to_field(blue, &fbi->fb.var.blue);
+
+			pal[regno] = val;
+			ret = 0;
+		}
+		break;
+
+	case FB_VISUAL_STATIC_PSEUDOCOLOR:
+	case FB_VISUAL_PSEUDOCOLOR:
+		writew((red & 0xf800)
+		      | ((green >> 5) & 0x7e0)
+		      | ((blue >> 11) & 0x1f),
+		       fbi->palette_cpu + sizeof(u16) * regno);
+		break;
+	}
+
+	return ret;
+}
+
+static int vt8500lcd_ioctl(struct fb_info *info, unsigned int cmd,
+			 unsigned long arg)
+{
+	int ret = 0;
+	struct vt8500lcd_info *fbi = container_of(info,
+						  struct vt8500lcd_info,
+						  fb);
+
+	if (cmd == FBIO_WAITFORVSYNC) {
+		/* Unmask End of Frame interrupt */
+		writel(0xffffffff ^ (1 << 3), fbi->regbase + 0x3c);
+		ret = wait_event_interruptible_timeout(fbi->wait,
+			readl(fbi->regbase + 0x38) & (1 << 3), HZ / 10);
+		/* Mask back to reduce unwanted interrupt traffic */
+		writel(0xffffffff, fbi->regbase + 0x3c);
+		if (ret < 0)
+			return ret;
+		if (ret == 0)
+			return -ETIMEDOUT;
+	}
+
+	return ret;
+}
+
+static int vt8500lcd_pan_display(struct fb_var_screeninfo *var,
+				struct fb_info *info)
+{
+	unsigned pixlen = info->fix.line_length / info->var.xres_virtual;
+	unsigned off = pixlen * var->xoffset
+		      + info->fix.line_length * var->yoffset;
+	struct vt8500lcd_info *fbi = container_of(info,
+						  struct vt8500lcd_info,
+						  fb);
+	writel((1 << 31)
+		| (((var->xres_virtual - var->xres) * pixlen / 4) << 20)
+		| (off >> 2), fbi->regbase + 0x20);
+	return 0;
+}
+
+static struct fb_ops vt8500lcd_ops = {
+	.owner		= THIS_MODULE,
+	.fb_set_par	= vt8500lcd_set_par,
+	.fb_setcolreg	= vt8500lcd_setcolreg,
+	.fb_fillrect	= wmt_ge_fillrect,
+	.fb_copyarea	= wmt_ge_copyarea,
+	.fb_imageblit	= sys_imageblit,
+	.fb_sync	= wmt_ge_sync,
+	.fb_ioctl	= vt8500lcd_ioctl,
+	.fb_pan_display	= vt8500lcd_pan_display,
+};
+
+static irqreturn_t vt8500lcd_handle_irq(int irq, void *dev_id)
+{
+	struct vt8500lcd_info *fbi = dev_id;
+
+	if (readl(fbi->regbase + 0x38) & (1 << 3))
+		wake_up_interruptible(&fbi->wait);
+
+	writel(0xffffffff, fbi->regbase + 0x38);
+	return IRQ_HANDLED;
+}
+
+static int __devinit vt8500lcd_probe(struct platform_device *pdev)
+{
+	struct vt8500lcd_info *fbi;
+	struct resource *res;
+	struct vt8500fb_platform_data *pdata = pdev->dev.platform_data;
+	void *addr;
+	int irq, ret;
+
+	ret = -ENOMEM;
+	fbi = NULL;
+
+	fbi = kzalloc(sizeof(struct vt8500lcd_info) + sizeof(u32) * 16,
+							GFP_KERNEL);
+	if (!fbi) {
+		dev_err(&pdev->dev, "Failed to initialize framebuffer device\n");
+		ret = -ENOMEM;
+		goto failed;
+	}
+
+	strcpy(fbi->fb.fix.id, "VT8500 LCD");
+
+	fbi->fb.fix.type	= FB_TYPE_PACKED_PIXELS;
+	fbi->fb.fix.xpanstep	= 0;
+	fbi->fb.fix.ypanstep	= 1;
+	fbi->fb.fix.ywrapstep	= 0;
+	fbi->fb.fix.accel	= FB_ACCEL_NONE;
+
+	fbi->fb.var.nonstd	= 0;
+	fbi->fb.var.activate	= FB_ACTIVATE_NOW;
+	fbi->fb.var.height	= -1;
+	fbi->fb.var.width	= -1;
+	fbi->fb.var.vmode	= FB_VMODE_NONINTERLACED;
+
+	fbi->fb.fbops		= &vt8500lcd_ops;
+	fbi->fb.flags		= FBINFO_DEFAULT
+				| FBINFO_HWACCEL_COPYAREA
+				| FBINFO_HWACCEL_FILLRECT
+				| FBINFO_HWACCEL_YPAN
+				| FBINFO_VIRTFB
+				| FBINFO_PARTIAL_PAN_OK;
+	fbi->fb.node		= -1;
+
+	addr = fbi;
+	addr = addr + sizeof(struct vt8500lcd_info);
+	fbi->fb.pseudo_palette	= addr;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "no I/O memory resource defined\n");
+		ret = -ENODEV;
+		goto failed_fbi;
+	}
+
+	res = request_mem_region(res->start, resource_size(res), "vt8500lcd");
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to request I/O memory\n");
+		ret = -EBUSY;
+		goto failed_fbi;
+	}
+
+	fbi->regbase = ioremap(res->start, resource_size(res));
+	if (fbi->regbase == NULL) {
+		dev_err(&pdev->dev, "failed to map I/O memory\n");
+		ret = -EBUSY;
+		goto failed_free_res;
+	}
+
+	fbi->fb.fix.smem_start	= pdata->video_mem_phys;
+	fbi->fb.fix.smem_len	= pdata->video_mem_len;
+	fbi->fb.screen_base	= pdata->video_mem_virt;
+
+	fbi->palette_size	= PAGE_ALIGN(512);
+	fbi->palette_cpu	= dma_alloc_coherent(&pdev->dev,
+						     fbi->palette_size,
+						     &fbi->palette_phys,
+						     GFP_KERNEL);
+	if (fbi->fb.pseudo_palette == NULL) {
+		dev_err(&pdev->dev, "Failed to allocate palette buffer\n");
+		ret = -ENOMEM;
+		goto failed_free_io;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "no IRQ defined\n");
+		ret = -ENODEV;
+		goto failed_free_palette;
+	}
+
+	ret = request_irq(irq, vt8500lcd_handle_irq, IRQF_DISABLED, "LCD", fbi);
+	if (ret) {
+		dev_err(&pdev->dev, "request_irq failed: %d\n", ret);
+		ret = -EBUSY;
+		goto failed_free_palette;
+	}
+
+	init_waitqueue_head(&fbi->wait);
+
+	if (fb_alloc_cmap(&fbi->fb.cmap, 256, 0) < 0) {
+		dev_err(&pdev->dev, "Failed to allocate color map\n");
+		ret = -ENOMEM;
+		goto failed_free_irq;
+	}
+
+	fb_videomode_to_var(&fbi->fb.var, &pdata->mode);
+	fbi->fb.var.bits_per_pixel	= pdata->bpp;
+	fbi->fb.var.xres_virtual	= pdata->xres_virtual;
+	fbi->fb.var.yres_virtual	= pdata->yres_virtual;
+
+	ret = vt8500lcd_set_par(&fbi->fb);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to set parameters\n");
+		goto failed_free_cmap;
+	}
+
+	writel(fbi->fb.fix.smem_start >> 22, fbi->regbase + 0x1c);
+	writel((fbi->palette_phys & 0xfffffe00) | 1, fbi->regbase + 0x18);
+
+	platform_set_drvdata(pdev, fbi);
+
+	ret = register_framebuffer(&fbi->fb);
+	if (ret < 0) {
+		dev_err(&pdev->dev,
+			"Failed to register framebuffer device: %d\n", ret);
+		goto failed_free_cmap;
+	}
+
+	/*
+	 * Ok, now enable the LCD controller
+	 */
+	writel(readl(fbi->regbase) | 1, fbi->regbase);
+
+	return 0;
+
+failed_free_cmap:
+	if (fbi->fb.cmap.len)
+		fb_dealloc_cmap(&fbi->fb.cmap);
+failed_free_irq:
+	free_irq(irq, fbi);
+failed_free_palette:
+	dma_free_coherent(&pdev->dev, fbi->palette_size,
+			  fbi->fb.pseudo_palette, fbi->palette_phys);
+failed_free_io:
+	iounmap(fbi->regbase);
+failed_free_res:
+	release_mem_region(res->start, resource_size(res));
+failed_fbi:
+	platform_set_drvdata(pdev, NULL);
+	kfree(fbi);
+failed:
+	return ret;
+}
+
+static int __devexit vt8500lcd_remove(struct platform_device *pdev)
+{
+	struct vt8500lcd_info *fbi = platform_get_drvdata(pdev);
+	struct resource *res;
+	int irq;
+
+	if (!fbi)
+		return 0;
+
+	unregister_framebuffer(&fbi->fb);
+
+	writel(0, fbi->regbase);
+
+	if (fbi->fb.cmap.len)
+		fb_dealloc_cmap(&fbi->fb.cmap);
+
+	irq = platform_get_irq(pdev, 0);
+	free_irq(irq, fbi);
+
+	iounmap(fbi->regbase);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(res->start, resource_size(res));
+
+	kfree(fbi);
+
+	return 0;
+}
+
+static struct platform_driver vt8500lcd_driver = {
+	.probe		= vt8500lcd_probe,
+	.remove		= vt8500lcd_remove,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "vt8500-lcd",
+	},
+};
+
+static int __init vt8500lcd_init(void)
+{
+	return platform_driver_register(&vt8500lcd_driver);
+}
+
+static void __exit vt8500lcd_exit(void)
+{
+	platform_driver_unregister(&vt8500lcd_driver);
+}
+
+module_init(vt8500lcd_init);
+module_exit(vt8500lcd_exit);
+
+MODULE_DESCRIPTION("LCD controller driver for VIA VT8500");
+MODULE_LICENSE("GPL");
diff --git a/drivers/video/vt8500lcdfb.h b/drivers/video/vt8500lcdfb.h
new file mode 100644
index 0000000..36ca3ca
--- /dev/null
+++ b/drivers/video/vt8500lcdfb.h
@@ -0,0 +1,34 @@
+/*
+ *  linux/drivers/video/vt8500lcdfb.h
+ *
+ *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+struct vt8500lcd_info {
+	struct fb_info		fb;
+	void __iomem		*regbase;
+	void __iomem		*palette_cpu;
+	dma_addr_t		palette_phys;
+	size_t			palette_size;
+	wait_queue_head_t	wait;
+};
+
+static int bpp_values[] = {
+	1,
+	2,
+	4,
+	8,
+	12,
+	16,
+	18,
+	24,
+};
diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
new file mode 100644
index 0000000..9a1cc70
--- /dev/null
+++ b/drivers/video/wm8505fb.c
@@ -0,0 +1,438 @@
+/*
+ *  WonderMedia WM8505 Frame Buffer device driver
+ *
+ *  Copyright (C) 2010 Ed Spiridonov <edo.rus@gmail.com>
+ *    Based on vt8500lcdfb.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <linux/wait.h>
+
+#include <asm/irq.h>
+
+#include <mach/vt8500fb.h>
+
+#include "wm8505fb_regs.h"
+#include "wmt_ge_rops.h"
+
+#define DRIVER_NAME "wm8505-fb"
+
+struct wm8505fb_info {
+	struct fb_info		fb;
+	void __iomem		*regbase;
+	unsigned int		contrast;
+};
+
+
+static int wm8505fb_init_hw(struct fb_info *info)
+{
+	struct wm8505fb_info *fbi = container_of(info,
+						  struct wm8505fb_info,
+						  fb);
+
+	int i;
+
+	/* I know the purpose only of few registers, so clear unknown */
+	for (i = 0; i < 0x200; i += 4)
+		writel(0, fbi->regbase + i);
+
+	/* Set frame buffer address */
+	writel(fbi->fb.fix.smem_start, fbi->regbase + WMT_GOVR_FBADDR);
+	writel(fbi->fb.fix.smem_start, fbi->regbase + WMT_GOVR_FBADDR1);
+
+	/* Set in-memory picture format to RGB 32bpp */
+	writel(0x1c,		       fbi->regbase + WMT_GOVR_COLORSPACE);
+	writel(1,		       fbi->regbase + WMT_GOVR_COLORSPACE1);
+
+	/* Virtual buffer size */
+	writel(info->var.xres,	       fbi->regbase + WMT_GOVR_XRES);
+	writel(info->var.xres_virtual, fbi->regbase + WMT_GOVR_XRES_VIRTUAL);
+
+	/* black magic ;) */
+	writel(0xf,		       fbi->regbase + WMT_GOVR_FHI);
+	writel(4,		       fbi->regbase + WMT_GOVR_DVO_SET);
+	writel(1,		       fbi->regbase + WMT_GOVR_MIF_ENABLE);
+	writel(1,		       fbi->regbase + WMT_GOVR_REG_UPDATE);
+
+	return 0;
+}
+
+static int wm8505fb_set_timing(struct fb_info *info)
+{
+	struct wm8505fb_info *fbi = container_of(info,
+						  struct wm8505fb_info,
+						  fb);
+
+	int h_start = info->var.left_margin;
+	int h_end = h_start + info->var.xres;
+	int h_all = h_end + info->var.right_margin;
+	int h_sync = info->var.hsync_len;
+
+	int v_start = info->var.upper_margin;
+	int v_end = v_start + info->var.yres;
+	int v_all = v_end + info->var.lower_margin;
+	int v_sync = info->var.vsync_len + 1;
+
+	writel(0, fbi->regbase + WMT_GOVR_TG);
+
+	writel(h_start, fbi->regbase + WMT_GOVR_TIMING_H_START);
+	writel(h_end,   fbi->regbase + WMT_GOVR_TIMING_H_END);
+	writel(h_all,   fbi->regbase + WMT_GOVR_TIMING_H_ALL);
+	writel(h_sync,  fbi->regbase + WMT_GOVR_TIMING_H_SYNC);
+
+	writel(v_start, fbi->regbase + WMT_GOVR_TIMING_V_START);
+	writel(v_end,   fbi->regbase + WMT_GOVR_TIMING_V_END);
+	writel(v_all,   fbi->regbase + WMT_GOVR_TIMING_V_ALL);
+	writel(v_sync,  fbi->regbase + WMT_GOVR_TIMING_V_SYNC);
+
+	writel(1, fbi->regbase + WMT_GOVR_TG);
+
+	return 0;
+}
+
+
+static int wm8505fb_set_par(struct fb_info *info)
+{
+	struct wm8505fb_info *fbi = container_of(info,
+						  struct wm8505fb_info,
+						  fb);
+
+	if (!fbi)
+		return -EINVAL;
+
+	if (info->var.bits_per_pixel == 32) {
+		info->var.red.offset = 16;
+		info->var.red.length = 8;
+		info->var.red.msb_right = 0;
+		info->var.green.offset = 8;
+		info->var.green.length = 8;
+		info->var.green.msb_right = 0;
+		info->var.blue.offset = 0;
+		info->var.blue.length = 8;
+		info->var.blue.msb_right = 0;
+		info->fix.visual = FB_VISUAL_TRUECOLOR;
+		info->fix.line_length = info->var.xres_virtual << 2;
+	}
+
+	wm8505fb_set_timing(info);
+
+	writel(fbi->contrast<<16 | fbi->contrast<<8 | fbi->contrast,
+		fbi->regbase + WMT_GOVR_CONTRAST);
+
+	return 0;
+}
+
+static ssize_t contrast_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct fb_info *info = dev_get_drvdata(dev);
+	struct wm8505fb_info *fbi = container_of(info,
+						  struct wm8505fb_info,
+						  fb);
+
+	return sprintf(buf, "%d\n", fbi->contrast);
+}
+
+static ssize_t contrast_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct fb_info *info = dev_get_drvdata(dev);
+	struct wm8505fb_info *fbi = container_of(info,
+						  struct wm8505fb_info,
+						  fb);
+
+	fbi->contrast = strict_strtoul(buf, NULL, 10) & 0xff;
+	wm8505fb_set_par(info);
+
+	return count;
+}
+
+static DEVICE_ATTR(contrast, 0644, contrast_show, contrast_store);
+
+static inline u_int chan_to_field(u_int chan, struct fb_bitfield *bf)
+{
+	chan &= 0xffff;
+	chan >>= 16 - bf->length;
+	return chan << bf->offset;
+}
+
+static int wm8505fb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			   unsigned blue, unsigned transp,
+			   struct fb_info *info) {
+	struct wm8505fb_info *fbi = container_of(info,
+						  struct wm8505fb_info,
+						  fb);
+	int ret = 1;
+	unsigned int val;
+	if (regno >= 256)
+		return -EINVAL;
+
+	if (info->var.grayscale)
+		red = green = blue =
+			(19595 * red + 38470 * green + 7471 * blue) >> 16;
+
+	switch (fbi->fb.fix.visual) {
+	case FB_VISUAL_TRUECOLOR:
+		if (regno < 16) {
+			u32 *pal = info->pseudo_palette;
+
+			val  = chan_to_field(red, &fbi->fb.var.red);
+			val |= chan_to_field(green, &fbi->fb.var.green);
+			val |= chan_to_field(blue, &fbi->fb.var.blue);
+
+			pal[regno] = val;
+			ret = 0;
+		}
+		break;
+	}
+
+	return ret;
+}
+
+static int wm8505fb_pan_display(struct fb_var_screeninfo *var,
+				struct fb_info *info)
+{
+	struct wm8505fb_info *fbi = container_of(info,
+						  struct wm8505fb_info,
+						  fb);
+
+	writel(var->xoffset, fbi->regbase + WMT_GOVR_XPAN);
+	writel(var->yoffset, fbi->regbase + WMT_GOVR_YPAN);
+	return 0;
+}
+
+static int wm8505fb_blank(int blank, struct fb_info *info)
+{
+	struct wm8505fb_info *fbi = container_of(info,
+						  struct wm8505fb_info,
+						  fb);
+
+	switch (blank) {
+	case FB_BLANK_UNBLANK:
+		wm8505fb_set_timing(info);
+		break;
+	default:
+		writel(0,  fbi->regbase + WMT_GOVR_TIMING_V_SYNC);
+		break;
+	}
+
+	return 0;
+}
+
+static struct fb_ops wm8505fb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_set_par	= wm8505fb_set_par,
+	.fb_setcolreg	= wm8505fb_setcolreg,
+	.fb_fillrect	= wmt_ge_fillrect,
+	.fb_copyarea	= wmt_ge_copyarea,
+	.fb_imageblit	= sys_imageblit,
+	.fb_sync	= wmt_ge_sync,
+	.fb_pan_display	= wm8505fb_pan_display,
+	.fb_blank	= wm8505fb_blank,
+};
+
+static int __devinit wm8505fb_probe(struct platform_device *pdev)
+{
+	struct wm8505fb_info	*fbi;
+	struct resource		*res;
+	void			*addr;
+	struct vt8500fb_platform_data *pdata;
+	int ret;
+
+	pdata = pdev->dev.platform_data;
+
+	ret = -ENOMEM;
+	fbi = NULL;
+
+	fbi = kzalloc(sizeof(struct wm8505fb_info) + sizeof(u32) * 16,
+							GFP_KERNEL);
+	if (!fbi) {
+		dev_err(&pdev->dev, "Failed to initialize framebuffer device\n");
+		ret = -ENOMEM;
+		goto failed;
+	}
+
+	strcpy(fbi->fb.fix.id, DRIVER_NAME);
+
+	fbi->fb.fix.type	= FB_TYPE_PACKED_PIXELS;
+	fbi->fb.fix.xpanstep	= 1;
+	fbi->fb.fix.ypanstep	= 1;
+	fbi->fb.fix.ywrapstep	= 0;
+	fbi->fb.fix.accel	= FB_ACCEL_NONE;
+
+	fbi->fb.fbops		= &wm8505fb_ops;
+	fbi->fb.flags		= FBINFO_DEFAULT
+				| FBINFO_HWACCEL_COPYAREA
+				| FBINFO_HWACCEL_FILLRECT
+				| FBINFO_HWACCEL_XPAN
+				| FBINFO_HWACCEL_YPAN
+				| FBINFO_VIRTFB
+				| FBINFO_PARTIAL_PAN_OK;
+	fbi->fb.node		= -1;
+
+	addr = fbi;
+	addr = addr + sizeof(struct wm8505fb_info);
+	fbi->fb.pseudo_palette	= addr;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "no I/O memory resource defined\n");
+		ret = -ENODEV;
+		goto failed_fbi;
+	}
+
+	res = request_mem_region(res->start, resource_size(res), "wm8505fb");
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to request I/O memory\n");
+		ret = -EBUSY;
+		goto failed_fbi;
+	}
+
+	fbi->regbase = ioremap(res->start, resource_size(res));
+	if (fbi->regbase == NULL) {
+		dev_err(&pdev->dev, "failed to map I/O memory\n");
+		ret = -EBUSY;
+		goto failed_free_res;
+	}
+
+	fb_videomode_to_var(&fbi->fb.var, &pdata->mode);
+
+	fbi->fb.var.nonstd		= 0;
+	fbi->fb.var.activate		= FB_ACTIVATE_NOW;
+
+	fbi->fb.var.height		= -1;
+	fbi->fb.var.width		= -1;
+	fbi->fb.var.xres_virtual	= pdata->xres_virtual;
+	fbi->fb.var.yres_virtual	= pdata->yres_virtual;
+	fbi->fb.var.bits_per_pixel	= pdata->bpp;
+
+	fbi->fb.fix.smem_start	= pdata->video_mem_phys;
+	fbi->fb.fix.smem_len	= pdata->video_mem_len;
+	fbi->fb.screen_base	= pdata->video_mem_virt;
+	fbi->fb.screen_size	= pdata->video_mem_len;
+
+	if (fb_alloc_cmap(&fbi->fb.cmap, 256, 0) < 0) {
+		dev_err(&pdev->dev, "Failed to allocate color map\n");
+		ret = -ENOMEM;
+		goto failed_free_mem;
+	}
+
+	wm8505fb_init_hw(&fbi->fb);
+
+	fbi->contrast = 0x50;
+	ret = wm8505fb_set_par(&fbi->fb);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to set parameters\n");
+		goto failed_free_cmap;
+	}
+
+	platform_set_drvdata(pdev, fbi);
+
+	ret = register_framebuffer(&fbi->fb);
+	if (ret < 0) {
+		dev_err(&pdev->dev,
+			"Failed to register framebuffer device: %d\n", ret);
+		goto failed_free_cmap;
+	}
+
+	ret = device_create_file(&pdev->dev, &dev_attr_contrast);
+	if (ret < 0) {
+		printk(KERN_WARNING "fb%d: failed to register attributes (%d)\n",
+			fbi->fb.node, ret);
+	}
+
+	printk(KERN_INFO "fb%d: %s frame buffer at 0x%lx-0x%lx\n",
+	       fbi->fb.node, fbi->fb.fix.id, fbi->fb.fix.smem_start,
+	       fbi->fb.fix.smem_start + fbi->fb.fix.smem_len - 1);
+
+	return 0;
+
+failed_free_cmap:
+	if (fbi->fb.cmap.len)
+		fb_dealloc_cmap(&fbi->fb.cmap);
+failed_free_mem:
+	free_pages_exact(fbi->fb.screen_base, fbi->fb.screen_size);
+failed_free_io:
+	iounmap(fbi->regbase);
+failed_free_res:
+	release_mem_region(res->start, resource_size(res));
+failed_fbi:
+	platform_set_drvdata(pdev, NULL);
+	kfree(fbi);
+failed:
+	return ret;
+}
+
+static int __devexit wm8505fb_remove(struct platform_device *pdev)
+{
+	struct wm8505fb_info *fbi = platform_get_drvdata(pdev);
+	struct resource *res;
+
+	if (!fbi)
+		return 0;
+
+	unregister_framebuffer(&fbi->fb);
+
+	writel(0, fbi->regbase);
+
+	if (fbi->fb.cmap.len)
+		fb_dealloc_cmap(&fbi->fb.cmap);
+
+	free_pages_exact(fbi->fb.screen_base, fbi->fb.screen_size);
+
+	iounmap(fbi->regbase);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(res->start, resource_size(res));
+
+	kfree(fbi);
+
+	return 0;
+}
+
+static struct platform_driver wm8505fb_driver = {
+	.probe		= wm8505fb_probe,
+	.remove		= wm8505fb_remove,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= DRIVER_NAME,
+	},
+};
+
+static int __init wm8505fb_init(void)
+{
+	return platform_driver_register(&wm8505fb_driver);
+}
+
+static void __exit wm8505fb_exit(void)
+{
+	platform_driver_unregister(&wm8505fb_driver);
+}
+
+module_init(wm8505fb_init);
+module_exit(wm8505fb_exit);
+
+MODULE_DESCRIPTION("Framebuffer driver for WMT WM8505");
+MODULE_LICENSE("GPL");
diff --git a/drivers/video/wm8505fb_regs.h b/drivers/video/wm8505fb_regs.h
new file mode 100644
index 0000000..4dd4166
--- /dev/null
+++ b/drivers/video/wm8505fb_regs.h
@@ -0,0 +1,76 @@
+/*
+ *  GOVR registers list for WM8505 chips
+ *
+ *  Copyright (C) 2010 Ed Spiridonov <edo.rus@gmail.com>
+ *   Based on VIA/WonderMedia wm8510-govrh-reg.h
+ *   http://github.com/projectgus/kernel_wm8505/blob/wm8505_2.6.29/
+ *         drivers/video/wmt/register/wm8510/wm8510-govrh-reg.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _WM8505FB_REGS_H
+#define _WM8505FB_REGS_H
+
+/*
+ * Color space select register, default value 0x1c
+ *   BIT0 GOVRH_DVO_YUV2RGB_ENABLE
+ *   BIT1 GOVRH_VGA_YUV2RGB_ENABLE
+ *   BIT2 GOVRH_RGB_MODE
+ *   BIT3 GOVRH_DAC_CLKINV
+ *   BIT4 GOVRH_BLANK_ZERO
+ */
+#define WMT_GOVR_COLORSPACE	0x1e4
+/*
+ * Another colorspace select register, default value 1
+ *   BIT0 GOVRH_DVO_RGB
+ *   BIT1 GOVRH_DVO_YUV422
+ */
+#define WMT_GOVR_COLORSPACE1	 0x30
+
+#define WMT_GOVR_CONTRAST	0x1b8
+#define WMT_GOVR_BRGHTNESS	0x1bc /* incompatible with RGB? */
+
+/* Framubeffer address */
+#define WMT_GOVR_FBADDR		 0x90
+#define WMT_GOVR_FBADDR1	 0x94 /* UV offset in YUV mode */
+
+/* Offset of visible window */
+#define WMT_GOVR_XPAN		 0xa4
+#define WMT_GOVR_YPAN		 0xa0
+
+#define WMT_GOVR_XRES		 0x98
+#define WMT_GOVR_XRES_VIRTUAL	 0x9c
+
+#define WMT_GOVR_MIF_ENABLE	 0x80
+#define WMT_GOVR_FHI		 0xa8
+#define WMT_GOVR_REG_UPDATE	 0xe4
+
+/*
+ *   BIT0 GOVRH_DVO_OUTWIDTH
+ *   BIT1 GOVRH_DVO_SYNC_POLAR
+ *   BIT2 GOVRH_DVO_ENABLE
+ */
+#define WMT_GOVR_DVO_SET	0x148
+
+/* Timing generator? */
+#define WMT_GOVR_TG		0x100
+
+/* Timings */
+#define WMT_GOVR_TIMING_H_ALL	0x108
+#define WMT_GOVR_TIMING_V_ALL	0x10c
+#define WMT_GOVR_TIMING_V_START	0x110
+#define WMT_GOVR_TIMING_V_END	0x114
+#define WMT_GOVR_TIMING_H_START	0x118
+#define WMT_GOVR_TIMING_H_END	0x11c
+#define WMT_GOVR_TIMING_V_SYNC	0x128
+#define WMT_GOVR_TIMING_H_SYNC	0x12c
+
+#endif /* _WM8505FB_REGS_H */
diff --git a/drivers/video/wmt_ge_rops.c b/drivers/video/wmt_ge_rops.c
new file mode 100644
index 0000000..c71f97e
--- /dev/null
+++ b/drivers/video/wmt_ge_rops.c
@@ -0,0 +1,186 @@
+/*
+ *  linux/drivers/video/wmt_ge_rops.c
+ *
+ *  Accelerators for raster operations using WonderMedia Graphics Engine
+ *
+ *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/fb.h>
+#include <linux/platform_device.h>
+#include "fb_draw.h"
+
+#define GE_COMMAND_OFF		0x00
+#define GE_DEPTH_OFF		0x04
+#define GE_HIGHCOLOR_OFF	0x08
+#define GE_ROPCODE_OFF		0x14
+#define GE_FIRE_OFF		0x18
+#define GE_SRCBASE_OFF		0x20
+#define GE_SRCDISPW_OFF		0x24
+#define GE_SRCDISPH_OFF		0x28
+#define GE_SRCAREAX_OFF		0x2c
+#define GE_SRCAREAY_OFF		0x30
+#define GE_SRCAREAW_OFF		0x34
+#define GE_SRCAREAH_OFF		0x38
+#define GE_DESTBASE_OFF		0x3c
+#define GE_DESTDISPW_OFF	0x40
+#define GE_DESTDISPH_OFF	0x44
+#define GE_DESTAREAX_OFF	0x48
+#define GE_DESTAREAY_OFF	0x4c
+#define GE_DESTAREAW_OFF	0x50
+#define GE_DESTAREAH_OFF	0x54
+#define GE_PAT0C_OFF		0x88	/* Pattern 0 color */
+#define GE_ENABLE_OFF		0xec
+#define GE_INTEN_OFF		0xf0
+#define GE_STATUS_OFF		0xf8
+
+void __iomem *regbase;
+
+void wmt_ge_fillrect(struct fb_info *p, const struct fb_fillrect *rect)
+{
+	unsigned long fg, pat;
+
+	if (p->state != FBINFO_STATE_RUNNING)
+		return;
+
+	if (p->fix.visual == FB_VISUAL_TRUECOLOR ||
+	    p->fix.visual == FB_VISUAL_DIRECTCOLOR)
+		fg = ((u32 *) (p->pseudo_palette))[rect->color];
+	else
+		fg = rect->color;
+
+	pat = pixel_to_pat(p->var.bits_per_pixel, fg);
+
+	if (p->fbops->fb_sync)
+		p->fbops->fb_sync(p);
+
+	writel(p->var.bits_per_pixel == 32 ? 3 :
+	      (p->var.bits_per_pixel == 8 ? 0 : 1), regbase + GE_DEPTH_OFF);
+	writel(p->var.bits_per_pixel == 15 ? 1 : 0, regbase + GE_HIGHCOLOR_OFF);
+	writel(p->fix.smem_start, regbase + GE_DESTBASE_OFF);
+	writel(p->var.xres_virtual - 1, regbase + GE_DESTDISPW_OFF);
+	writel(p->var.yres_virtual - 1, regbase + GE_DESTDISPH_OFF);
+	writel(rect->dx, regbase + GE_DESTAREAX_OFF);
+	writel(rect->dy, regbase + GE_DESTAREAY_OFF);
+	writel(rect->width - 1, regbase + GE_DESTAREAW_OFF);
+	writel(rect->height - 1, regbase + GE_DESTAREAH_OFF);
+
+	writel(pat, regbase + GE_PAT0C_OFF);
+	writel(1, regbase + GE_COMMAND_OFF);
+	writel(rect->rop == ROP_XOR ? 0x5a : 0xf0, regbase + GE_ROPCODE_OFF);
+	writel(1, regbase + GE_FIRE_OFF);
+}
+EXPORT_SYMBOL(wmt_ge_fillrect);
+
+void wmt_ge_copyarea(struct fb_info *p, const struct fb_copyarea *area)
+{
+	if (p->state != FBINFO_STATE_RUNNING)
+		return;
+
+	if (p->fbops->fb_sync)
+		p->fbops->fb_sync(p);
+
+	writel(p->var.bits_per_pixel > 16 ? 3 :
+	      (p->var.bits_per_pixel > 8 ? 1 : 0), regbase + GE_DEPTH_OFF);
+
+	writel(p->fix.smem_start, regbase + GE_SRCBASE_OFF);
+	writel(p->var.xres_virtual - 1, regbase + GE_SRCDISPW_OFF);
+	writel(p->var.yres_virtual - 1, regbase + GE_SRCDISPH_OFF);
+	writel(area->sx, regbase + GE_SRCAREAX_OFF);
+	writel(area->sy, regbase + GE_SRCAREAY_OFF);
+	writel(area->width - 1, regbase + GE_SRCAREAW_OFF);
+	writel(area->height - 1, regbase + GE_SRCAREAH_OFF);
+
+	writel(p->fix.smem_start, regbase + GE_DESTBASE_OFF);
+	writel(p->var.xres_virtual - 1, regbase + GE_DESTDISPW_OFF);
+	writel(p->var.yres_virtual - 1, regbase + GE_DESTDISPH_OFF);
+	writel(area->dx, regbase + GE_DESTAREAX_OFF);
+	writel(area->dy, regbase + GE_DESTAREAY_OFF);
+	writel(area->width - 1, regbase + GE_DESTAREAW_OFF);
+	writel(area->height - 1, regbase + GE_DESTAREAH_OFF);
+
+	writel(0xcc, regbase + GE_ROPCODE_OFF);
+	writel(1, regbase + GE_COMMAND_OFF);
+	writel(1, regbase + GE_FIRE_OFF);
+}
+EXPORT_SYMBOL(wmt_ge_copyarea);
+
+int wmt_ge_sync(struct fb_info *p)
+{
+	while (readl(regbase + GE_STATUS_OFF) & 4)
+		/* busy wait */;
+
+	return 0;
+}
+EXPORT_SYMBOL(wmt_ge_sync);
+
+static int __devinit wmt_ge_rops_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	int ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "no I/O memory resource defined\n");
+		ret = -ENODEV;
+		goto error;
+	}
+
+	regbase = ioremap(res->start, resource_size(res));
+	if (regbase == NULL) {
+		dev_err(&pdev->dev, "failed to map I/O memory\n");
+		ret = -EBUSY;
+		goto error;
+	}
+
+	writel(1, regbase + GE_ENABLE_OFF);
+	printk(KERN_INFO "Enabled support for WMT GE raster acceleration\n");
+
+	return 0;
+
+error:
+	return ret;
+}
+
+static int __devexit wmt_ge_rops_remove(struct platform_device *pdev)
+{
+	iounmap(regbase);
+	return 0;
+}
+
+static struct platform_driver wmt_ge_rops_driver = {
+	.probe		= wmt_ge_rops_probe,
+	.remove		= wmt_ge_rops_remove,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "wmt_ge_rops",
+	},
+};
+
+static int __init wmt_ge_rops_init(void)
+{
+	return platform_driver_register(&wmt_ge_rops_driver);
+}
+
+static void __exit wmt_ge_rops_exit(void)
+{
+	platform_driver_unregister(&wmt_ge_rops_driver);
+}
+
+module_init(wmt_ge_rops_init);
+module_exit(wmt_ge_rops_exit);
+
+MODULE_AUTHOR("Alexey Charkov <alchark@gmail.com");
+MODULE_DESCRIPTION("Accelerators for raster operations using "
+		   "WonderMedia Graphics Engine");
+MODULE_LICENSE("GPL");
diff --git a/drivers/video/wmt_ge_rops.h b/drivers/video/wmt_ge_rops.h
new file mode 100644
index 0000000..8738075
--- /dev/null
+++ b/drivers/video/wmt_ge_rops.h
@@ -0,0 +1,5 @@
+extern void wmt_ge_fillrect(struct fb_info *info,
+			    const struct fb_fillrect *rect);
+extern void wmt_ge_copyarea(struct fb_info *info,
+			    const struct fb_copyarea *area);
+extern int wmt_ge_sync(struct fb_info *info);
-- 
1.7.3.2

