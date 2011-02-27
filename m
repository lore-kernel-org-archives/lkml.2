Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab1B0QC6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 11:02:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:58602 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab1B0QCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 11:02:13 -0500
From: Guan Xuetao <epip@hera.kernel.org>
To: arnd@arndb.de
Cc: GuanXuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
Subject: [PATCH 15/17] unicore32 machine related: add frame buffer driver for pkunity-v3 soc
Date: Sun, 27 Feb 2011 15:59:43 +0000
Message-Id: <a336d8ba89b5afe129cb9178f26216b22d6beb63.1298821856.git.epip@hera.kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 27 Feb 2011 16:01:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GuanXuetao <gxt@mprc.pku.edu.cn>

change from original version -- by advice of Paul Mundt
1. remove videomemorysize definitions
2. remove unifb_enable and unifb_setup
3. use dev_warn instead of printk in fb driver
4. remove judgement for FB_ACCEL_PUV3_UNIGFX
5. adjust clk_get and clk_set_rate calls
6. add resources definitions
7. remove unifb_option
8. adjust register for platform_device
9. adjust unifb_ops position and unifb_regs assignment position

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 MAINTAINERS                            |    1 +
 arch/unicore32/configs/debug_defconfig |    3 +-
 arch/unicore32/include/mach/memory.h   |    2 +-
 arch/unicore32/kernel/puv3-core.c      |   15 +
 drivers/video/Kconfig                  |   11 +
 drivers/video/Makefile                 |    1 +
 drivers/video/fb-puv3.c                |  846 ++++++++++++++++++++++++++++++++
 include/linux/fb.h                     |    2 +
 8 files changed, 879 insertions(+), 2 deletions(-)
 create mode 100644 drivers/video/fb-puv3.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 1058d59..c44a484 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4889,6 +4889,7 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git
 F:	drivers/input/serio/i8042-unicore32io.h
 F:	drivers/i2c/busses/i2c-puv3.c
+F:	drivers/video/fb-puv3.c
 
 PMC SIERRA MaxRAID DRIVER
 M:	Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
diff --git a/arch/unicore32/configs/debug_defconfig b/arch/unicore32/configs/debug_defconfig
index bf42abd..b5fbde9 100644
--- a/arch/unicore32/configs/debug_defconfig
+++ b/arch/unicore32/configs/debug_defconfig
@@ -66,7 +66,6 @@ CONFIG_LCD_BACKLIGHT=n
 
 CONFIG_PUV3_RTC=y
 CONFIG_PUV3_UMAL=y
-CONFIG_PUV3_UNIGFX=y
 CONFIG_PUV3_MUSB=n
 CONFIG_PUV3_AC97=n
 CONFIG_PUV3_NAND=n
@@ -130,6 +129,8 @@ CONFIG_VIDEO_DEV=n
 CONFIG_USB_VIDEO_CLASS=n
 
 #	Graphics support
+CONFIG_FB=y
+CONFIG_FB_PUV3_UNIGFX=y
 #	Console display driver support
 CONFIG_VGA_CONSOLE=n
 CONFIG_FRAMEBUFFER_CONSOLE=y
diff --git a/arch/unicore32/include/mach/memory.h b/arch/unicore32/include/mach/memory.h
index 541949d..b774eff 100644
--- a/arch/unicore32/include/mach/memory.h
+++ b/arch/unicore32/include/mach/memory.h
@@ -50,7 +50,7 @@ void puv3_pci_adjust_zones(unsigned long *size, unsigned long *holes);
 
 /* kuser area */
 #define KUSER_VECPAGE_BASE	(KUSER_BASE + UL(0x3fff0000))
-#define KUSER_UNIGFX_BASE	(KUSER_BASE + PKUNITY_UNIGFX_MMAP_BASE)
+#define KUSER_UNIGFX_BASE	(PAGE_OFFSET + PKUNITY_UNIGFX_MMAP_BASE)
 /* kuser_vecpage (0xbfff0000) is ro, and vectors page (0xffff0000) is rw */
 #define kuser_vecpage_to_vectors(x)	((x) - (KUSER_VECPAGE_BASE)	\
 					+ (VECTORS_BASE))
diff --git a/arch/unicore32/kernel/puv3-core.c b/arch/unicore32/kernel/puv3-core.c
index 6edf928..7d10e7b 100644
--- a/arch/unicore32/kernel/puv3-core.c
+++ b/arch/unicore32/kernel/puv3-core.c
@@ -93,6 +93,19 @@ static struct resource puv3_mmc_resources[] = {
 	},
 };
 
+static struct resource puv3_unigfx_resources[] = {
+	[0] = {
+		.start	= PKUNITY_UNIGFX_BASE,
+		.end	= PKUNITY_UNIGFX_BASE + 0xfff,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= PKUNITY_UNIGFX_MMAP_BASE,
+		.end	= PKUNITY_UNIGFX_MMAP_BASE + PKUNITY_UNIGFX_MMAP_SIZE,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
 static struct resource puv3_rtc_resources[] = {
 	[0] = {
 		.start = PKUNITY_RTC_BASE,
@@ -256,6 +269,8 @@ void __init puv3_core_init(void)
 			puv3_umal_resources, ARRAY_SIZE(puv3_umal_resources));
 	platform_device_register_simple("PKUnity-v3-MMC", -1,
 			puv3_mmc_resources, ARRAY_SIZE(puv3_mmc_resources));
+	platform_device_register_simple("PKUnity-v3-UNIGFX", -1,
+			puv3_unigfx_resources, ARRAY_SIZE(puv3_unigfx_resources));
 	platform_device_register_simple("PKUnity-v3-PWM", -1,
 			puv3_pwm_resources, ARRAY_SIZE(puv3_pwm_resources));
 	platform_device_register_simple("PKUnity-v3-UART", 0,
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 6bafb51b..ec55a87 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2365,6 +2365,17 @@ config FB_JZ4740
 	help
 	  Framebuffer support for the JZ4740 SoC.
 
+config FB_PUV3_UNIGFX
+	tristate "PKUnity v3 Unigfx framebuffer support"
+	depends on FB && UNICORE32 && ARCH_PUV3
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	help
+	  Choose this option if you want to use the Unigfx device as a
+	  framebuffer device. Without the support of PCI & AGP.
+
 source "drivers/video/omap/Kconfig"
 source "drivers/video/omap2/Kconfig"
 
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 8c8fabd..b0eb3da 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -139,6 +139,7 @@ obj-$(CONFIG_FB_MB862XX)	  += mb862xx/
 obj-$(CONFIG_FB_MSM)              += msm/
 obj-$(CONFIG_FB_NUC900)           += nuc900fb.o
 obj-$(CONFIG_FB_JZ4740)		  += jz4740_fb.o
+obj-$(CONFIG_FB_PUV3_UNIGFX)      += fb-puv3.o
 
 # Platform or fallback drivers go here
 obj-$(CONFIG_FB_UVESA)            += uvesafb.o
diff --git a/drivers/video/fb-puv3.c b/drivers/video/fb-puv3.c
new file mode 100644
index 0000000..dbd2dc4
--- /dev/null
+++ b/drivers/video/fb-puv3.c
@@ -0,0 +1,846 @@
+/*
+ * Frame Buffer Driver for PKUnity-v3 Unigfx
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/vmalloc.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/console.h>
+
+#include <asm/sizes.h>
+#include <mach/hardware.h>
+
+/* Platform_data reserved for unifb registers. */
+#define UNIFB_REGS_NUM		10
+/* RAM reserved for the frame buffer. */
+#define UNIFB_MEMSIZE		(SZ_4M)		/* 4 MB for 1024*768*32b */
+
+/*
+ * cause UNIGFX don not have EDID
+ * all the modes are organized as follow
+ */
+static const struct fb_videomode unifb_modes[] = {
+	/* 0 640x480-60 VESA */
+	{ "640x480@60",  60,  640, 480,  25175000,  48, 16, 34, 10,  96, 1,
+	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
+	/* 1 640x480-75 VESA */
+	{ "640x480@75",  75,  640, 480,  31500000, 120, 16, 18,  1,  64, 1,
+	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
+	/* 2 800x600-60 VESA */
+	{ "800x600@60",  60,  800, 600,  40000000,  88, 40, 26,  1, 128, 1,
+	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
+	/* 3 800x600-75 VESA */
+	{ "800x600@75",  75,  800, 600,  49500000, 160, 16, 23,  1,  80, 1,
+	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
+	/* 4 1024x768-60 VESA */
+	{ "1024x768@60", 60, 1024, 768,  65000000, 160, 24, 34,  3, 136, 1,
+	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
+	/* 5 1024x768-75 VESA */
+	{ "1024x768@75", 75, 1024, 768,  78750000, 176, 16, 30,  1,  96, 1,
+	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
+	/* 6 1280x960-60 VESA */
+	{ "1280x960@60", 60, 1280, 960, 108000000, 312, 96, 38,  1, 112, 1,
+	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
+	/* 7 1440x900-60 VESA */
+	{ "1440x900@60", 60, 1440, 900, 106500000, 232, 80, 30,  3, 152, 1,
+	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
+	/* 8 FIXME 9 1024x600-60 VESA UNTESTED */
+	{ "1024x600@60", 60, 1024, 600,  50650000, 160, 24, 26,  1, 136, 1,
+	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
+	/* 9 FIXME 10 1024x600-75 VESA UNTESTED */
+	{ "1024x600@75", 75, 1024, 600,  61500000, 176, 16, 23,  1,  96, 1,
+	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
+	/* 10 FIXME 11 1366x768-60 VESA UNTESTED */
+	{ "1366x768@60", 60, 1366, 768,  85500000, 256, 58, 18,  1,  112, 3,
+	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
+};
+
+static struct fb_var_screeninfo unifb_default = {
+	.xres =		640,
+	.yres =		480,
+	.xres_virtual =	640,
+	.yres_virtual =	480,
+	.bits_per_pixel = 16,
+	.red =		{ 11, 5, 0 },
+	.green =	{ 5,  6, 0 },
+	.blue =		{ 0,  5, 0 },
+	.activate =	FB_ACTIVATE_NOW,
+	.height =	-1,
+	.width =	-1,
+	.pixclock =	25175000,
+	.left_margin =	48,
+	.right_margin =	16,
+	.upper_margin =	33,
+	.lower_margin =	10,
+	.hsync_len =	96,
+	.vsync_len =	2,
+	.vmode =	FB_VMODE_NONINTERLACED,
+};
+
+static struct fb_fix_screeninfo unifb_fix = {
+	.id =		"UNIGFX FB",
+	.type =		FB_TYPE_PACKED_PIXELS,
+	.visual =	FB_VISUAL_TRUECOLOR,
+	.xpanstep =	1,
+	.ypanstep =	1,
+	.ywrapstep =	1,
+	.accel =	FB_ACCEL_NONE,
+};
+
+static void unifb_sync(struct fb_info *info)
+{
+	/* TODO: may, this can be replaced by interrupt */
+	int cnt;
+
+	for (cnt = 0; cnt < 0x10000000; cnt++) {
+		if (readl(UGE_COMMAND) & 0x1000000)
+			return;
+	}
+
+	if (cnt > 0x8000000)
+		dev_warn(info->device, "Warning: UniGFX GE time out ...\n");
+}
+
+static void unifb_prim_fillrect(struct fb_info *info,
+				const struct fb_fillrect *region)
+{
+	int awidth = region->width;
+	int aheight = region->height;
+	int m_iBpp = info->var.bits_per_pixel;
+	int screen_width = info->var.xres;
+	int src_sel = 1;	/* from fg_color */
+	int pat_sel = 1;
+	int src_x0 = 0;
+	int dst_x0 = region->dx;
+	int src_y0 = 0;
+	int dst_y0 = region->dy;
+	int rop_alpha_sel = 0;
+	int rop_alpha_code = 0xCC;
+	int x_dir = 1;
+	int y_dir = 1;
+	int alpha_r = 0;
+	int alpha_sel = 0;
+	int dst_pitch = screen_width * (m_iBpp / 8);
+	int dst_offset = dst_y0 * dst_pitch + dst_x0 * (m_iBpp / 8);
+	int src_pitch = screen_width * (m_iBpp / 8);
+	int src_offset = src_y0 * src_pitch + src_x0 * (m_iBpp / 8);
+	unsigned int command = 0;
+	int clip_region = 0;
+	int clip_en = 0;
+	int tp_en = 0;
+	int fg_color = 0;
+	int bottom = info->var.yres - 1;
+	int right = info->var.xres - 1;
+	int top = 0;
+
+	bottom = (bottom << 16) | right;
+	command = (rop_alpha_sel << 26) | (pat_sel << 18) | (src_sel << 16)
+		| (x_dir << 20) | (y_dir << 21) | (command << 24)
+		| (clip_region << 23) | (clip_en << 22) | (tp_en << 27);
+	src_pitch = (dst_pitch << 16) | src_pitch;
+	awidth = awidth | (aheight << 16);
+	alpha_r = ((rop_alpha_code & 0xff) << 8) | (alpha_r & 0xff)
+		| (alpha_sel << 16);
+	src_x0 = (src_x0 & 0x1fff) | ((src_y0 & 0x1fff) << 16);
+	dst_x0 = (dst_x0 & 0x1fff) | ((dst_y0 & 0x1fff) << 16);
+	fg_color = region->color;
+
+	unifb_sync(info);
+
+	writel(((u32 *)(info->pseudo_palette))[fg_color], UGE_FCOLOR);
+	writel(0, UGE_BCOLOR);
+	writel(src_pitch, UGE_PITCH);
+	writel(src_offset, UGE_SRCSTART);
+	writel(dst_offset, UGE_DSTSTART);
+	writel(awidth, UGE_WIDHEIGHT);
+	writel(top, UGE_CLIP0);
+	writel(bottom, UGE_CLIP1);
+	writel(alpha_r, UGE_ROPALPHA);
+	writel(src_x0, UGE_SRCXY);
+	writel(dst_x0, UGE_DSTXY);
+	writel(command, UGE_COMMAND);
+}
+
+static void unifb_fillrect(struct fb_info *info,
+		const struct fb_fillrect *region)
+{
+	struct fb_fillrect modded;
+	int vxres, vyres;
+
+	if (info->flags & FBINFO_HWACCEL_DISABLED) {
+		sys_fillrect(info, region);
+		return;
+	}
+
+	vxres = info->var.xres_virtual;
+	vyres = info->var.yres_virtual;
+
+	memcpy(&modded, region, sizeof(struct fb_fillrect));
+
+	if (!modded.width || !modded.height ||
+	    modded.dx >= vxres || modded.dy >= vyres)
+		return;
+
+	if (modded.dx + modded.width > vxres)
+		modded.width = vxres - modded.dx;
+	if (modded.dy + modded.height > vyres)
+		modded.height = vyres - modded.dy;
+
+	unifb_prim_fillrect(info, &modded);
+}
+
+static void unifb_prim_copyarea(struct fb_info *info,
+				const struct fb_copyarea *area)
+{
+	int awidth = area->width;
+	int aheight = area->height;
+	int m_iBpp = info->var.bits_per_pixel;
+	int screen_width = info->var.xres;
+	int src_sel = 2;	/* from mem */
+	int pat_sel = 0;
+	int src_x0 = area->sx;
+	int dst_x0 = area->dx;
+	int src_y0 = area->sy;
+	int dst_y0 = area->dy;
+
+	int rop_alpha_sel = 0;
+	int rop_alpha_code = 0xCC;
+	int x_dir = 1;
+	int y_dir = 1;
+
+	int alpha_r = 0;
+	int alpha_sel = 0;
+	int dst_pitch = screen_width * (m_iBpp / 8);
+	int dst_offset = dst_y0 * dst_pitch + dst_x0 * (m_iBpp / 8);
+	int src_pitch = screen_width * (m_iBpp / 8);
+	int src_offset = src_y0 * src_pitch + src_x0 * (m_iBpp / 8);
+	unsigned int command = 0;
+	int clip_region = 0;
+	int clip_en = 1;
+	int tp_en = 0;
+	int top = 0;
+	int bottom = info->var.yres;
+	int right = info->var.xres;
+	int fg_color = 0;
+	int bg_color = 0;
+
+	if (src_x0 < 0)
+		src_x0 = 0;
+	if (src_y0 < 0)
+		src_y0 = 0;
+
+	if (src_y0 - dst_y0 > 0) {
+		y_dir = 1;
+	} else {
+		y_dir = 0;
+		src_offset = (src_y0 + aheight) * src_pitch +
+				src_x0 * (m_iBpp / 8);
+		dst_offset = (dst_y0 + aheight) * dst_pitch +
+				dst_x0 * (m_iBpp / 8);
+		src_y0 += aheight;
+		dst_y0 += aheight;
+	}
+
+	command = (rop_alpha_sel << 26) | (pat_sel << 18) | (src_sel << 16) |
+		(x_dir << 20) | (y_dir << 21) | (command << 24) |
+		(clip_region << 23) | (clip_en << 22) | (tp_en << 27);
+	src_pitch = (dst_pitch << 16) | src_pitch;
+	awidth = awidth | (aheight << 16);
+	alpha_r = ((rop_alpha_code & 0xff) << 8) | (alpha_r & 0xff) |
+		(alpha_sel << 16);
+	src_x0 = (src_x0 & 0x1fff) | ((src_y0 & 0x1fff) << 16);
+	dst_x0 = (dst_x0 & 0x1fff) | ((dst_y0 & 0x1fff) << 16);
+	bottom = (bottom << 16) | right;
+
+	unifb_sync(info);
+
+	writel(src_pitch, UGE_PITCH);
+	writel(src_offset, UGE_SRCSTART);
+	writel(dst_offset, UGE_DSTSTART);
+	writel(awidth, UGE_WIDHEIGHT);
+	writel(top, UGE_CLIP0);
+	writel(bottom, UGE_CLIP1);
+	writel(bg_color, UGE_BCOLOR);
+	writel(fg_color, UGE_FCOLOR);
+	writel(alpha_r, UGE_ROPALPHA);
+	writel(src_x0, UGE_SRCXY);
+	writel(dst_x0, UGE_DSTXY);
+	writel(command, UGE_COMMAND);
+}
+
+static void unifb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
+{
+	struct fb_copyarea modded;
+	u32 vxres, vyres;
+	modded.sx = area->sx;
+	modded.sy = area->sy;
+	modded.dx = area->dx;
+	modded.dy = area->dy;
+	modded.width = area->width;
+	modded.height = area->height;
+
+	if (info->flags & FBINFO_HWACCEL_DISABLED) {
+		sys_copyarea(info, area);
+		return;
+	}
+
+	vxres = info->var.xres_virtual;
+	vyres = info->var.yres_virtual;
+
+	if (!modded.width || !modded.height ||
+	    modded.sx >= vxres || modded.sy >= vyres ||
+	    modded.dx >= vxres || modded.dy >= vyres)
+		return;
+
+	if (modded.sx + modded.width > vxres)
+		modded.width = vxres - modded.sx;
+	if (modded.dx + modded.width > vxres)
+		modded.width = vxres - modded.dx;
+	if (modded.sy + modded.height > vyres)
+		modded.height = vyres - modded.sy;
+	if (modded.dy + modded.height > vyres)
+		modded.height = vyres - modded.dy;
+
+	unifb_prim_copyarea(info, &modded);
+}
+
+static void unifb_imageblit(struct fb_info *info, const struct fb_image *image)
+{
+	sys_imageblit(info, image);
+}
+
+static u_long get_line_length(int xres_virtual, int bpp)
+{
+	u_long length;
+
+	length = xres_virtual * bpp;
+	length = (length + 31) & ~31;
+	length >>= 3;
+	return length;
+}
+
+/*
+ *  Setting the video mode has been split into two parts.
+ *  First part, xxxfb_check_var, must not write anything
+ *  to hardware, it should only verify and adjust var.
+ *  This means it doesn't alter par but it does use hardware
+ *  data from it to check this var.
+ */
+static int unifb_check_var(struct fb_var_screeninfo *var,
+			 struct fb_info *info)
+{
+	u_long line_length;
+
+	/*
+	 *  FB_VMODE_CONUPDATE and FB_VMODE_SMOOTH_XPAN are equal!
+	 *  as FB_VMODE_SMOOTH_XPAN is only used internally
+	 */
+
+	if (var->vmode & FB_VMODE_CONUPDATE) {
+		var->vmode |= FB_VMODE_YWRAP;
+		var->xoffset = info->var.xoffset;
+		var->yoffset = info->var.yoffset;
+	}
+
+	/*
+	 *  Some very basic checks
+	 */
+	if (!var->xres)
+		var->xres = 1;
+	if (!var->yres)
+		var->yres = 1;
+	if (var->xres > var->xres_virtual)
+		var->xres_virtual = var->xres;
+	if (var->yres > var->yres_virtual)
+		var->yres_virtual = var->yres;
+	if (var->bits_per_pixel <= 1)
+		var->bits_per_pixel = 1;
+	else if (var->bits_per_pixel <= 8)
+		var->bits_per_pixel = 8;
+	else if (var->bits_per_pixel <= 16)
+		var->bits_per_pixel = 16;
+	else if (var->bits_per_pixel <= 24)
+		var->bits_per_pixel = 24;
+	else if (var->bits_per_pixel <= 32)
+		var->bits_per_pixel = 32;
+	else
+		return -EINVAL;
+
+	if (var->xres_virtual < var->xoffset + var->xres)
+		var->xres_virtual = var->xoffset + var->xres;
+	if (var->yres_virtual < var->yoffset + var->yres)
+		var->yres_virtual = var->yoffset + var->yres;
+
+	/*
+	 *  Memory limit
+	 */
+	line_length =
+	    get_line_length(var->xres_virtual, var->bits_per_pixel);
+	if (line_length * var->yres_virtual > UNIFB_MEMSIZE)
+		return -ENOMEM;
+
+	/*
+	 * Now that we checked it we alter var. The reason being is that the
+	 * video mode passed in might not work but slight changes to it might
+	 * make it work. This way we let the user know what is acceptable.
+	 */
+	switch (var->bits_per_pixel) {
+	case 1:
+	case 8:
+		var->red.offset = 0;
+		var->red.length = 8;
+		var->green.offset = 0;
+		var->green.length = 8;
+		var->blue.offset = 0;
+		var->blue.length = 8;
+		var->transp.offset = 0;
+		var->transp.length = 0;
+		break;
+	case 16:		/* RGBA 5551 */
+		if (var->transp.length) {
+			var->red.offset = 0;
+			var->red.length = 5;
+			var->green.offset = 5;
+			var->green.length = 5;
+			var->blue.offset = 10;
+			var->blue.length = 5;
+			var->transp.offset = 15;
+			var->transp.length = 1;
+		} else {	/* RGB 565 */
+			var->red.offset = 11;
+			var->red.length = 5;
+			var->green.offset = 5;
+			var->green.length = 6;
+			var->blue.offset = 0;
+			var->blue.length = 5;
+			var->transp.offset = 0;
+			var->transp.length = 0;
+		}
+		break;
+	case 24:		/* RGB 888 */
+		var->red.offset = 0;
+		var->red.length = 8;
+		var->green.offset = 8;
+		var->green.length = 8;
+		var->blue.offset = 16;
+		var->blue.length = 8;
+		var->transp.offset = 0;
+		var->transp.length = 0;
+		break;
+	case 32:		/* RGBA 8888 */
+		var->red.offset = 16;
+		var->red.length = 8;
+		var->green.offset = 8;
+		var->green.length = 8;
+		var->blue.offset = 0;
+		var->blue.length = 8;
+		var->transp.offset = 24;
+		var->transp.length = 8;
+		break;
+	}
+	var->red.msb_right = 0;
+	var->green.msb_right = 0;
+	var->blue.msb_right = 0;
+	var->transp.msb_right = 0;
+
+	return 0;
+}
+
+/*
+ * This routine actually sets the video mode. It's in here where we
+ * the hardware state info->par and fix which can be affected by the
+ * change in par. For this driver it doesn't do much.
+ */
+static int unifb_set_par(struct fb_info *info)
+{
+	int hTotal, vTotal, hSyncStart, hSyncEnd, vSyncStart, vSyncEnd;
+	int format;
+
+#ifdef CONFIG_PUV3_PM
+	struct clk *clk_vga;
+	u32 pixclk = 0;
+	int i;
+
+	for (i = 0; i <= 10; i++) {
+		if    (info->var.xres         == unifb_modes[i].xres
+		    && info->var.yres         == unifb_modes[i].yres
+		    && info->var.upper_margin == unifb_modes[i].upper_margin
+		    && info->var.lower_margin == unifb_modes[i].lower_margin
+		    && info->var.left_margin  == unifb_modes[i].left_margin
+		    && info->var.right_margin == unifb_modes[i].right_margin
+		    && info->var.hsync_len    == unifb_modes[i].hsync_len
+		    && info->var.vsync_len    == unifb_modes[i].vsync_len) {
+			pixclk = unifb_modes[i].pixclock;
+			break;
+		}
+	}
+
+	/* set clock rate */
+	clk_vga = clk_get(info->device, "VGA_CLK");
+	if (clk_vga == ERR_PTR(-ENOENT))
+		return -ENOENT;
+
+	if (pixclk != 0) {
+		if (clk_set_rate(clk_vga, pixclk)) { /* set clock failed */
+			info->fix = unifb_fix;
+			info->var = unifb_default;
+			if (clk_set_rate(clk_vga, unifb_default.pixclock))
+				return -EINVAL;
+		}
+	}
+#endif
+
+	info->fix.line_length = get_line_length(info->var.xres_virtual,
+						info->var.bits_per_pixel);
+
+	hSyncStart = info->var.xres + info->var.right_margin;
+	hSyncEnd = hSyncStart + info->var.hsync_len;
+	hTotal = hSyncEnd + info->var.left_margin;
+
+	vSyncStart = info->var.yres + info->var.lower_margin;
+	vSyncEnd = vSyncStart + info->var.vsync_len;
+	vTotal = vSyncEnd + info->var.upper_margin;
+
+	switch (info->var.bits_per_pixel) {
+	case 8:
+		format = UDE_CFG_DST8;
+		break;
+	case 16:
+		format = UDE_CFG_DST16;
+		break;
+	case 24:
+		format = UDE_CFG_DST24;
+		break;
+	case 32:
+		format = UDE_CFG_DST32;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	writel(PKUNITY_UNIGFX_MMAP_BASE, UDE_FSA);
+	writel(info->var.yres, UDE_LS);
+	writel(get_line_length(info->var.xres,
+			info->var.bits_per_pixel) >> 3, UDE_PS);
+			/* >> 3 for hardware required. */
+	writel((hTotal << 16) | (info->var.xres), UDE_HAT);
+	writel(((hTotal - 1) << 16) | (info->var.xres - 1), UDE_HBT);
+	writel(((hSyncEnd - 1) << 16) | (hSyncStart - 1), UDE_HST);
+	writel((vTotal << 16) | (info->var.yres), UDE_VAT);
+	writel(((vTotal - 1) << 16) | (info->var.yres - 1), UDE_VBT);
+	writel(((vSyncEnd - 1) << 16) | (vSyncStart - 1), UDE_VST);
+	writel(UDE_CFG_GDEN_ENABLE | UDE_CFG_TIMEUP_ENABLE
+			| format | 0xC0000001, UDE_CFG);
+
+	return 0;
+}
+
+/*
+ *  Set a single color register. The values supplied are already
+ *  rounded down to the hardware's capabilities (according to the
+ *  entries in the var structure). Return != 0 for invalid regno.
+ */
+static int unifb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
+			 u_int transp, struct fb_info *info)
+{
+	if (regno >= 256)	/* no. of hw registers */
+		return 1;
+
+	/* grayscale works only partially under directcolor */
+	if (info->var.grayscale) {
+		/* grayscale = 0.30*R + 0.59*G + 0.11*B */
+		red = green = blue =
+		    (red * 77 + green * 151 + blue * 28) >> 8;
+	}
+
+#define CNVT_TOHW(val, width) ((((val)<<(width))+0x7FFF-(val))>>16)
+	switch (info->fix.visual) {
+	case FB_VISUAL_TRUECOLOR:
+	case FB_VISUAL_PSEUDOCOLOR:
+		red = CNVT_TOHW(red, info->var.red.length);
+		green = CNVT_TOHW(green, info->var.green.length);
+		blue = CNVT_TOHW(blue, info->var.blue.length);
+		transp = CNVT_TOHW(transp, info->var.transp.length);
+		break;
+	case FB_VISUAL_DIRECTCOLOR:
+		red = CNVT_TOHW(red, 8);	/* expect 8 bit DAC */
+		green = CNVT_TOHW(green, 8);
+		blue = CNVT_TOHW(blue, 8);
+		/* hey, there is bug in transp handling... */
+		transp = CNVT_TOHW(transp, 8);
+		break;
+	}
+#undef CNVT_TOHW
+	/* Truecolor has hardware independent palette */
+	if (info->fix.visual == FB_VISUAL_TRUECOLOR) {
+		u32 v;
+
+		if (regno >= 16)
+			return 1;
+
+		v = (red << info->var.red.offset) |
+		    (green << info->var.green.offset) |
+		    (blue << info->var.blue.offset) |
+		    (transp << info->var.transp.offset);
+		switch (info->var.bits_per_pixel) {
+		case 8:
+			break;
+		case 16:
+		case 24:
+		case 32:
+			((u32 *) (info->pseudo_palette))[regno] = v;
+			break;
+		default:
+			return 1;
+		}
+		return 0;
+	}
+	return 0;
+}
+
+/*
+ *  Pan or Wrap the Display
+ *
+ *  This call looks only at xoffset, yoffset and the FB_VMODE_YWRAP flag
+ */
+static int unifb_pan_display(struct fb_var_screeninfo *var,
+			   struct fb_info *info)
+{
+	if (var->vmode & FB_VMODE_YWRAP) {
+		if (var->yoffset < 0
+		    || var->yoffset >= info->var.yres_virtual
+		    || var->xoffset)
+			return -EINVAL;
+	} else {
+		if (var->xoffset + var->xres > info->var.xres_virtual ||
+		    var->yoffset + var->yres > info->var.yres_virtual)
+			return -EINVAL;
+	}
+	info->var.xoffset = var->xoffset;
+	info->var.yoffset = var->yoffset;
+	if (var->vmode & FB_VMODE_YWRAP)
+		info->var.vmode |= FB_VMODE_YWRAP;
+	else
+		info->var.vmode &= ~FB_VMODE_YWRAP;
+	return 0;
+}
+
+int unifb_mmap(struct fb_info *info,
+		    struct vm_area_struct *vma)
+{
+	unsigned long size = vma->vm_end - vma->vm_start;
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long pos = info->fix.smem_start + offset;
+
+	if (offset + size > info->fix.smem_len)
+		return -EINVAL;
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	if (io_remap_pfn_range(vma, vma->vm_start, pos >> PAGE_SHIFT, size,
+				vma->vm_page_prot))
+		return -EAGAIN;
+
+	vma->vm_flags |= VM_RESERVED;	/* avoid to swap out this VMA */
+	return 0;
+
+}
+
+static struct fb_ops unifb_ops = {
+	.fb_read        = fb_sys_read,
+	.fb_write       = fb_sys_write,
+	.fb_check_var	= unifb_check_var,
+	.fb_set_par	= unifb_set_par,
+	.fb_setcolreg	= unifb_setcolreg,
+	.fb_pan_display	= unifb_pan_display,
+	.fb_fillrect	= unifb_fillrect,
+	.fb_copyarea	= unifb_copyarea,
+	.fb_imageblit   = unifb_imageblit,
+	.fb_mmap	= unifb_mmap,
+};
+
+/*
+ *  Initialisation
+ */
+static int unifb_probe(struct platform_device *dev)
+{
+	struct fb_info *info;
+	u32 unifb_regs[UNIFB_REGS_NUM];
+	int retval = -ENOMEM;
+	struct resource *iomem, *mapmem;
+
+	info = framebuffer_alloc(sizeof(u32)*256, &dev->dev);
+	if (!info)
+		goto err;
+
+	info->screen_base = (char __iomem *)KUSER_UNIGFX_BASE;
+	info->fbops = &unifb_ops;
+
+	retval = fb_find_mode(&info->var, info, NULL,
+			      unifb_modes, 10, &unifb_modes[0], 16);
+
+	if (!retval || (retval == 4))
+		info->var = unifb_default;
+
+	iomem = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	unifb_fix.mmio_start = iomem->start;
+
+	mapmem = platform_get_resource(dev, IORESOURCE_MEM, 1);
+	unifb_fix.smem_start = mapmem->start;
+	unifb_fix.smem_len = UNIFB_MEMSIZE;
+
+	info->fix = unifb_fix;
+	info->pseudo_palette = info->par;
+	info->par = NULL;
+	info->flags = FBINFO_FLAG_DEFAULT;
+#ifdef FB_ACCEL_PUV3_UNIGFX
+	info->fix.accel = FB_ACCEL_PUV3_UNIGFX;
+#endif
+
+	retval = fb_alloc_cmap(&info->cmap, 256, 0);
+	if (retval < 0)
+		goto err1;
+
+	retval = register_framebuffer(info);
+	if (retval < 0)
+		goto err2;
+	platform_set_drvdata(dev, info);
+	platform_device_add_data(dev, unifb_regs, sizeof(u32) * UNIFB_REGS_NUM);
+
+	printk(KERN_INFO
+	       "fb%d: Virtual frame buffer device, using %dM of video memory\n",
+	       info->node, UNIFB_MEMSIZE >> 20);
+	return 0;
+err2:
+	fb_dealloc_cmap(&info->cmap);
+err1:
+	framebuffer_release(info);
+err:
+	return retval;
+}
+
+static int unifb_remove(struct platform_device *dev)
+{
+	struct fb_info *info = platform_get_drvdata(dev);
+
+	if (info) {
+		unregister_framebuffer(info);
+		fb_dealloc_cmap(&info->cmap);
+		framebuffer_release(info);
+	}
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int unifb_resume(struct platform_device *dev)
+{
+	int rc = 0;
+	u32 *unifb_regs = dev->dev.platform_data;
+
+	if (dev->dev.power.power_state.event == PM_EVENT_ON)
+		return 0;
+
+	console_lock();
+
+	if (dev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
+		writel(unifb_regs[0], UDE_FSA);
+		writel(unifb_regs[1], UDE_LS);
+		writel(unifb_regs[2], UDE_PS);
+		writel(unifb_regs[3], UDE_HAT);
+		writel(unifb_regs[4], UDE_HBT);
+		writel(unifb_regs[5], UDE_HST);
+		writel(unifb_regs[6], UDE_VAT);
+		writel(unifb_regs[7], UDE_VBT);
+		writel(unifb_regs[8], UDE_VST);
+		writel(unifb_regs[9], UDE_CFG);
+	}
+	dev->dev.power.power_state = PMSG_ON;
+
+	console_unlock();
+
+	return rc;
+}
+
+static int unifb_suspend(struct platform_device *dev, pm_message_t mesg)
+{
+	u32 *unifb_regs = dev->dev.platform_data;
+
+	unifb_regs[0] = readl(UDE_FSA);
+	unifb_regs[1] = readl(UDE_LS);
+	unifb_regs[2] = readl(UDE_PS);
+	unifb_regs[3] = readl(UDE_HAT);
+	unifb_regs[4] = readl(UDE_HBT);
+	unifb_regs[5] = readl(UDE_HST);
+	unifb_regs[6] = readl(UDE_VAT);
+	unifb_regs[7] = readl(UDE_VBT);
+	unifb_regs[8] = readl(UDE_VST);
+	unifb_regs[9] = readl(UDE_CFG);
+
+	if (mesg.event == dev->dev.power.power_state.event)
+		return 0;
+
+	switch (mesg.event) {
+	case PM_EVENT_FREEZE:		/* about to take snapshot */
+	case PM_EVENT_PRETHAW:		/* before restoring snapshot */
+		goto done;
+	}
+
+	console_lock();
+
+	/* do nothing... */
+
+	console_unlock();
+
+done:
+	dev->dev.power.power_state = mesg;
+
+	return 0;
+}
+#else
+#define	unifb_resume	NULL
+#define unifb_suspend	NULL
+#endif
+
+static struct platform_driver unifb_driver = {
+	.probe	 = unifb_probe,
+	.remove  = unifb_remove,
+	.resume  = unifb_resume,
+	.suspend = unifb_suspend,
+	.driver  = {
+		.name	= "PKUnity-v3-UNIGFX",
+	},
+};
+
+static int __init unifb_init(void)
+{
+#ifndef MODULE
+	if (fb_get_options("unifb", NULL))
+		return -ENODEV;
+#endif
+
+	return platform_driver_register(&unifb_driver);
+}
+
+module_init(unifb_init);
+
+static void __exit unifb_exit(void)
+{
+	platform_driver_unregister(&unifb_driver);
+}
+
+module_exit(unifb_exit);
+
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 68ba85a..b2a3639 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -152,6 +152,8 @@
 #define FB_ACCEL_PROSAVAGE_DDR  0x8d	/* S3 ProSavage DDR             */
 #define FB_ACCEL_PROSAVAGE_DDRK 0x8e	/* S3 ProSavage DDR-K           */
 
+#define FB_ACCEL_PUV3_UNIGFX	0xa0	/* PKUnity-v3 Unigfx		*/
+
 struct fb_fix_screeninfo {
 	char id[16];			/* identification string eg "TT Builtin" */
 	unsigned long smem_start;	/* Start of frame buffer mem */
-- 
1.7.4.1

