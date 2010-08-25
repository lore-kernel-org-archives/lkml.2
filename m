Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0HYOMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 10:12:33 -0400
Received: from queue02.mail.zen.net.uk ([212.23.3.27]:41932 "EHLO
	queue02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab0HYOM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 10:12:29 -0400
Date: Wed, 25 Aug 2010 15:11:12 +0100
From: Colin Watson <cjwatson@canonical.com>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Peter Jones <pjones@redhat.com>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] Add new linearfb driver
Message-ID: <20100825141111.GI21862@riva.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Originating-Smarthost01-IP: [82.69.40.219]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out linearfb from efifb so that boot loaders can program it as a
simple linear framebuffer on non-EFI systems.  This is useful for boot
loaders with their own graphics drivers, e.g. GRUB 2, since in some
cases on x86 they can set up non-VESA modes and thus can't program
vesafb.

efifb is reworked on top of this common code, and it should be possible
to do the same with some other framebuffer drivers in future.

Signed-off-by: Colin Watson <cjwatson@canonical.com>
Acked-by: Matthew Garrett <mjg@redhat.com>
Cc: Peter Jones <pjones@redhat.com>
---
 drivers/video/Kconfig       |   17 ++-
 drivers/video/Makefile      |    1 +
 drivers/video/efifb.c       |  222 +----------------------------
 drivers/video/linearfb.c    |  332 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/fb.h          |    8 +
 include/linux/screen_info.h |    2 +
 6 files changed, 364 insertions(+), 218 deletions(-)
 create mode 100644 drivers/video/linearfb.c

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 59c51d9..a7735ec 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -721,13 +721,24 @@ config FB_VESA
 	  You will get a boot time penguin logo at no additional cost. Please
 	  read <file:Documentation/fb/vesafb.txt>. If unsure, say Y.
 
-config FB_EFI
-	bool "EFI-based Framebuffer Support"
-	depends on (FB = y) && X86 && EFI
+config FB_LINEAR
+	bool "Simple linear framebuffer support"
+	depends on FB
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	help
+	  This is a simple linear frame buffer device driver. It has no
+	  hardware-specific programming capability, but must be programmed
+	  by the boot loader or by another frame buffer driver.
+
+	  If unsure, say N.
+
+config FB_EFI
+	bool "EFI-based Framebuffer Support"
+	depends on (FB = y) && X86 && EFI
+	select FB_LINEAR
+	help
 	  This is the EFI frame buffer device driver. If the firmware on
 	  your platform is EFI 1.10 or UEFI 2.0, select Y to add support for
 	  using the EFI framebuffer as your console.
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index ddc2af2..ad74d3b 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -133,6 +133,7 @@ obj-$(CONFIG_FB_MSM)              += msm/
 obj-$(CONFIG_FB_NUC900)           += nuc900fb.o
 
 # Platform or fallback drivers go here
+obj-$(CONFIG_FB_LINEAR)           += linearfb.o
 obj-$(CONFIG_FB_UVESA)            += uvesafb.o
 obj-$(CONFIG_FB_VESA)             += vesafb.o
 obj-$(CONFIG_FB_EFI)              += efifb.o
diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 4a56f46..72e5873 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -16,24 +16,6 @@
 
 #include <video/vga.h>
 
-static struct fb_var_screeninfo efifb_defined __initdata = {
-	.activate		= FB_ACTIVATE_NOW,
-	.height			= -1,
-	.width			= -1,
-	.right_margin		= 32,
-	.upper_margin		= 16,
-	.lower_margin		= 4,
-	.vsync_len		= 4,
-	.vmode			= FB_VMODE_NONINTERLACED,
-};
-
-static struct fb_fix_screeninfo efifb_fix __initdata = {
-	.id			= "EFI VGA",
-	.type			= FB_TYPE_PACKED_PIXELS,
-	.accel			= FB_ACCEL_NONE,
-	.visual			= FB_VISUAL_TRUECOLOR,
-};
-
 enum {
 	M_I17,		/* 17-Inch iMac */
 	M_I20,		/* 20-Inch iMac */
@@ -138,49 +120,6 @@ static int set_system(const struct dmi_system_id *id)
 	return 0;
 }
 
-static int efifb_setcolreg(unsigned regno, unsigned red, unsigned green,
-			   unsigned blue, unsigned transp,
-			   struct fb_info *info)
-{
-	/*
-	 *  Set a single color register. The values supplied are
-	 *  already rounded down to the hardware's capabilities
-	 *  (according to the entries in the `var' structure). Return
-	 *  != 0 for invalid regno.
-	 */
-
-	if (regno >= info->cmap.len)
-		return 1;
-
-	if (regno < 16) {
-		red   >>= 8;
-		green >>= 8;
-		blue  >>= 8;
-		((u32 *)(info->pseudo_palette))[regno] =
-			(red   << info->var.red.offset)   |
-			(green << info->var.green.offset) |
-			(blue  << info->var.blue.offset);
-	}
-	return 0;
-}
-
-static void efifb_destroy(struct fb_info *info)
-{
-	if (info->screen_base)
-		iounmap(info->screen_base);
-	release_mem_region(info->apertures->ranges[0].base, info->apertures->ranges[0].size);
-	framebuffer_release(info);
-}
-
-static struct fb_ops efifb_ops = {
-	.owner		= THIS_MODULE,
-	.fb_destroy	= efifb_destroy,
-	.fb_setcolreg	= efifb_setcolreg,
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
-	.fb_imageblit	= cfb_imageblit,
-};
-
 static int __init efifb_setup(char *options)
 {
 	char *this_opt;
@@ -215,171 +154,24 @@ static int __init efifb_setup(char *options)
 
 static int __devinit efifb_probe(struct platform_device *dev)
 {
-	struct fb_info *info;
 	int err;
-	unsigned int size_vmode;
-	unsigned int size_remap;
-	unsigned int size_total;
-	int request_succeeded = 0;
-
-	if (!screen_info.lfb_depth)
-		screen_info.lfb_depth = 32;
-	if (!screen_info.pages)
-		screen_info.pages = 1;
-	if (!screen_info.lfb_base) {
-		printk(KERN_DEBUG "efifb: invalid framebuffer address\n");
-		return -ENODEV;
-	}
-	printk(KERN_INFO "efifb: probing for efifb\n");
-
-	/* just assume they're all unset if any are */
-	if (!screen_info.blue_size) {
-		screen_info.blue_size = 8;
-		screen_info.blue_pos = 0;
-		screen_info.green_size = 8;
-		screen_info.green_pos = 8;
-		screen_info.red_size = 8;
-		screen_info.red_pos = 16;
-		screen_info.rsvd_size = 8;
-		screen_info.rsvd_pos = 24;
-	}
-
-	efifb_fix.smem_start = screen_info.lfb_base;
-	efifb_defined.bits_per_pixel = screen_info.lfb_depth;
-	efifb_defined.xres = screen_info.lfb_width;
-	efifb_defined.yres = screen_info.lfb_height;
-	efifb_fix.line_length = screen_info.lfb_linelength;
-
-	/*   size_vmode -- that is the amount of memory needed for the
-	 *                 used video mode, i.e. the minimum amount of
-	 *                 memory we need. */
-	size_vmode = efifb_defined.yres * efifb_fix.line_length;
-
-	/*   size_total -- all video memory we have. Used for
-	 *                 entries, ressource allocation and bounds
-	 *                 checking. */
-	size_total = screen_info.lfb_size;
-	if (size_total < size_vmode)
-		size_total = size_vmode;
-
-	/*   size_remap -- the amount of video memory we are going to
-	 *                 use for efifb.  With modern cards it is no
-	 *                 option to simply use size_total as that
-	 *                 wastes plenty of kernel address space. */
-	size_remap  = size_vmode * 2;
-	if (size_remap > size_total)
-		size_remap = size_total;
-	if (size_remap % PAGE_SIZE)
-		size_remap += PAGE_SIZE - (size_remap % PAGE_SIZE);
-	efifb_fix.smem_len = size_remap;
-
-	if (request_mem_region(efifb_fix.smem_start, size_remap, "efifb")) {
-		request_succeeded = 1;
-	} else {
-		/* We cannot make this fatal. Sometimes this comes from magic
-		   spaces our resource handlers simply don't know about */
-		printk(KERN_WARNING
-		       "efifb: cannot reserve video memory at 0x%lx\n",
-			efifb_fix.smem_start);
-	}
-
-	info = framebuffer_alloc(sizeof(u32) * 16, &dev->dev);
-	if (!info) {
-		printk(KERN_ERR "efifb: cannot allocate framebuffer\n");
-		err = -ENOMEM;
-		goto err_release_mem;
-	}
-	info->pseudo_palette = info->par;
-	info->par = NULL;
-
-	info->apertures = alloc_apertures(1);
-	if (!info->apertures) {
-		err = -ENOMEM;
-		goto err_release_fb;
-	}
-	info->apertures->ranges[0].base = efifb_fix.smem_start;
-	info->apertures->ranges[0].size = size_remap;
-
-	info->screen_base = ioremap(efifb_fix.smem_start, efifb_fix.smem_len);
-	if (!info->screen_base) {
-		printk(KERN_ERR "efifb: abort, cannot ioremap video memory "
-				"0x%x @ 0x%lx\n",
-			efifb_fix.smem_len, efifb_fix.smem_start);
-		err = -EIO;
-		goto err_release_fb;
-	}
-
-	printk(KERN_INFO "efifb: framebuffer at 0x%lx, mapped to 0x%p, "
-	       "using %dk, total %dk\n",
-	       efifb_fix.smem_start, info->screen_base,
-	       size_remap/1024, size_total/1024);
-	printk(KERN_INFO "efifb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
-	       efifb_defined.xres, efifb_defined.yres,
-	       efifb_defined.bits_per_pixel, efifb_fix.line_length,
-	       screen_info.pages);
-
-	efifb_defined.xres_virtual = efifb_defined.xres;
-	efifb_defined.yres_virtual = efifb_fix.smem_len /
-					efifb_fix.line_length;
-	printk(KERN_INFO "efifb: scrolling: redraw\n");
-	efifb_defined.yres_virtual = efifb_defined.yres;
-
-	/* some dummy values for timing to make fbset happy */
-	efifb_defined.pixclock     = 10000000 / efifb_defined.xres *
-					1000 / efifb_defined.yres;
-	efifb_defined.left_margin  = (efifb_defined.xres / 8) & 0xf8;
-	efifb_defined.hsync_len    = (efifb_defined.xres / 8) & 0xf8;
-
-	efifb_defined.red.offset    = screen_info.red_pos;
-	efifb_defined.red.length    = screen_info.red_size;
-	efifb_defined.green.offset  = screen_info.green_pos;
-	efifb_defined.green.length  = screen_info.green_size;
-	efifb_defined.blue.offset   = screen_info.blue_pos;
-	efifb_defined.blue.length   = screen_info.blue_size;
-	efifb_defined.transp.offset = screen_info.rsvd_pos;
-	efifb_defined.transp.length = screen_info.rsvd_size;
-
-	printk(KERN_INFO "efifb: %s: "
-	       "size=%d:%d:%d:%d, shift=%d:%d:%d:%d\n",
-	       "Truecolor",
-	       screen_info.rsvd_size,
-	       screen_info.red_size,
-	       screen_info.green_size,
-	       screen_info.blue_size,
-	       screen_info.rsvd_pos,
-	       screen_info.red_pos,
-	       screen_info.green_pos,
-	       screen_info.blue_pos);
-
-	efifb_fix.ypanstep  = 0;
-	efifb_fix.ywrapstep = 0;
+	struct fb_info *info;
 
-	info->fbops = &efifb_ops;
-	info->var = efifb_defined;
-	info->fix = efifb_fix;
-	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_MISC_FIRMWARE;
+	if ((err = linearfb_get_info(dev, &info)) < 0)
+		return err;
 
-	if ((err = fb_alloc_cmap(&info->cmap, 256, 0)) < 0) {
-		printk(KERN_ERR "efifb: cannot allocate colormap\n");
-		goto err_unmap;
-	}
+	strcpy(info->fix.id, "EFI VGA");
 	if ((err = register_framebuffer(info)) < 0) {
 		printk(KERN_ERR "efifb: cannot register framebuffer\n");
-		goto err_fb_dealoc;
+		goto err_fb_dealloc;
 	}
 	printk(KERN_INFO "fb%d: %s frame buffer device\n",
 		info->node, info->fix.id);
 	return 0;
 
-err_fb_dealoc:
+err_fb_dealloc:
 	fb_dealloc_cmap(&info->cmap);
-err_unmap:
-	iounmap(info->screen_base);
-err_release_fb:
-	framebuffer_release(info);
-err_release_mem:
-	if (request_succeeded)
-		release_mem_region(efifb_fix.smem_start, size_total);
+	linearfb_destroy(info);
 	return err;
 }
 
diff --git a/drivers/video/linearfb.c b/drivers/video/linearfb.c
new file mode 100644
index 0000000..c93eaac
--- /dev/null
+++ b/drivers/video/linearfb.c
@@ -0,0 +1,332 @@
+/*
+ * Simple linear framebuffer driver
+ *
+ * This driver does not have any real probing capability; using it requires
+ * programming, either by the boot loader or by another framebuffer driver.
+ *
+ * (c) 2006 Edgar Hucek <gimli@dark-green.com>
+ * Original efi driver written by Gerd Knorr <kraxel@goldbach.in-berlin.de>
+ * Split out to linearfb by Colin Watson <cjwatson@ubuntu.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/fb.h>
+#include <linux/platform_device.h>
+#include <linux/screen_info.h>
+
+#include <video/vga.h>
+
+static struct fb_var_screeninfo linearfb_defined __initdata = {
+	.activate		= FB_ACTIVATE_NOW,
+	.height			= -1,
+	.width			= -1,
+	.right_margin		= 32,
+	.upper_margin		= 16,
+	.lower_margin		= 4,
+	.vsync_len		= 4,
+	.vmode			= FB_VMODE_NONINTERLACED,
+};
+
+static struct fb_fix_screeninfo linearfb_fix __initdata = {
+	.id			= "Linear",
+	.type			= FB_TYPE_PACKED_PIXELS,
+	.accel			= FB_ACCEL_NONE,
+	.visual			= FB_VISUAL_TRUECOLOR,
+};
+
+static int linearfb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			      unsigned blue, unsigned transp,
+			      struct fb_info *info)
+{
+	/*
+	 *  Set a single color register. The values supplied are
+	 *  already rounded down to the hardware's capabilities
+	 *  (according to the entries in the `var' structure). Return
+	 *  != 0 for invalid regno.
+	 */
+
+	if (regno >= info->cmap.len)
+		return 1;
+
+	if (regno < 16) {
+		red   >>= 8;
+		green >>= 8;
+		blue  >>= 8;
+		((u32 *)(info->pseudo_palette))[regno] =
+			(red   << info->var.red.offset)   |
+			(green << info->var.green.offset) |
+			(blue  << info->var.blue.offset);
+	}
+	return 0;
+}
+
+void linearfb_destroy(struct fb_info *info)
+{
+	if (info->screen_base)
+		iounmap(info->screen_base);
+	release_mem_region(info->apertures->ranges[0].base, info->apertures->ranges[0].size);
+	framebuffer_release(info);
+}
+EXPORT_SYMBOL(linearfb_destroy);
+
+static struct fb_ops linearfb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_destroy	= linearfb_destroy,
+	.fb_setcolreg	= linearfb_setcolreg,
+	.fb_fillrect	= cfb_fillrect,
+	.fb_copyarea	= cfb_copyarea,
+	.fb_imageblit	= cfb_imageblit,
+};
+
+static int __init linearfb_setup(char *options)
+{
+	char *this_opt;
+
+	if (!options || !*options)
+		return 0;
+
+	while ((this_opt = strsep(&options, ",")) != NULL) {
+		if (!*this_opt) continue;
+
+		if (!strncmp(this_opt, "base:", 5))
+			screen_info.lfb_base = simple_strtoul(this_opt+5, NULL, 0);
+		else if (!strncmp(this_opt, "stride:", 7))
+			screen_info.lfb_linelength = simple_strtoul(this_opt+7, NULL, 0) * 4;
+		else if (!strncmp(this_opt, "height:", 7))
+			screen_info.lfb_height = simple_strtoul(this_opt+7, NULL, 0);
+		else if (!strncmp(this_opt, "width:", 6))
+			screen_info.lfb_width = simple_strtoul(this_opt+6, NULL, 0);
+	}
+	return 0;
+}
+
+int linearfb_get_info(struct platform_device *dev, struct fb_info **p_info)
+{
+	int err;
+	unsigned int size_vmode;
+	unsigned int size_remap;
+	unsigned int size_total;
+	int request_succeeded = 0;
+	struct fb_info *info;
+
+	if (!screen_info.lfb_depth)
+		screen_info.lfb_depth = 32;
+	if (!screen_info.pages)
+		screen_info.pages = 1;
+	if (!screen_info.lfb_base) {
+		printk(KERN_DEBUG "linearfb: invalid framebuffer address\n");
+		return -ENODEV;
+	}
+	printk(KERN_INFO "linearfb: probing for linearfb\n");
+
+	/* just assume they're all unset if any are */
+	if (!screen_info.blue_size) {
+		screen_info.blue_size = 8;
+		screen_info.blue_pos = 0;
+		screen_info.green_size = 8;
+		screen_info.green_pos = 8;
+		screen_info.red_size = 8;
+		screen_info.red_pos = 16;
+		screen_info.rsvd_size = 8;
+		screen_info.rsvd_pos = 24;
+	}
+
+	linearfb_fix.smem_start = screen_info.lfb_base;
+	linearfb_defined.bits_per_pixel = screen_info.lfb_depth;
+	linearfb_defined.xres = screen_info.lfb_width;
+	linearfb_defined.yres = screen_info.lfb_height;
+	linearfb_fix.line_length = screen_info.lfb_linelength;
+
+	/*   size_vmode -- that is the amount of memory needed for the
+	 *                 used video mode, i.e. the minimum amount of
+	 *                 memory we need. */
+	size_vmode = linearfb_defined.yres * linearfb_fix.line_length;
+
+	/*   size_total -- all video memory we have. Used for
+	 *                 entries, ressource allocation and bounds
+	 *                 checking. */
+	size_total = screen_info.lfb_size;
+	if (size_total < size_vmode)
+		size_total = size_vmode;
+
+	/*   size_remap -- the amount of video memory we are going to
+	 *                 use for linearfb.  With modern cards it is no
+	 *                 option to simply use size_total as that
+	 *                 wastes plenty of kernel address space. */
+	size_remap  = size_vmode * 2;
+	if (size_remap > size_total)
+		size_remap = size_total;
+	if (size_remap % PAGE_SIZE)
+		size_remap += PAGE_SIZE - (size_remap % PAGE_SIZE);
+	linearfb_fix.smem_len = size_remap;
+
+	if (request_mem_region(linearfb_fix.smem_start, size_remap,
+	    "linearfb")) {
+		request_succeeded = 1;
+	} else {
+		/* We cannot make this fatal. Sometimes this comes from magic
+		   spaces our resource handlers simply don't know about */
+		printk(KERN_WARNING
+		       "linearfb: cannot reserve video memory at 0x%lx\n",
+			linearfb_fix.smem_start);
+	}
+
+	info = framebuffer_alloc(sizeof(u32) * 16, &dev->dev);
+	if (!info) {
+		printk(KERN_ERR "linearfb: cannot allocate framebuffer\n");
+		err = -ENOMEM;
+		goto err_release_mem;
+	}
+	info->pseudo_palette = info->par;
+	info->par = NULL;
+
+	info->apertures = alloc_apertures(1);
+	if (!info->apertures) {
+		err = -ENOMEM;
+		goto err_release_fb;
+	}
+	info->apertures->ranges[0].base = linearfb_fix.smem_start;
+	info->apertures->ranges[0].size = size_remap;
+
+	info->screen_base = ioremap(linearfb_fix.smem_start,
+				    linearfb_fix.smem_len);
+	if (!info->screen_base) {
+		printk(KERN_ERR "linearfb: abort, cannot ioremap video memory "
+				"0x%x @ 0x%lx\n",
+			linearfb_fix.smem_len, linearfb_fix.smem_start);
+		err = -EIO;
+		goto err_release_fb;
+	}
+
+	printk(KERN_INFO "linearfb: framebuffer at 0x%lx, mapped to 0x%p, "
+	       "using %dk, total %dk\n",
+	       linearfb_fix.smem_start, info->screen_base,
+	       size_remap/1024, size_total/1024);
+	printk(KERN_INFO
+	       "linearfb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
+	       linearfb_defined.xres, linearfb_defined.yres,
+	       linearfb_defined.bits_per_pixel, linearfb_fix.line_length,
+	       screen_info.pages);
+
+	linearfb_defined.xres_virtual = linearfb_defined.xres;
+	linearfb_defined.yres_virtual = linearfb_fix.smem_len /
+					linearfb_fix.line_length;
+	printk(KERN_INFO "linearfb: scrolling: redraw\n");
+	linearfb_defined.yres_virtual = linearfb_defined.yres;
+
+	/* some dummy values for timing to make fbset happy */
+	linearfb_defined.pixclock     = 10000000 / linearfb_defined.xres *
+					1000 / linearfb_defined.yres;
+	linearfb_defined.left_margin  = (linearfb_defined.xres / 8) & 0xf8;
+	linearfb_defined.hsync_len    = (linearfb_defined.xres / 8) & 0xf8;
+
+	linearfb_defined.red.offset    = screen_info.red_pos;
+	linearfb_defined.red.length    = screen_info.red_size;
+	linearfb_defined.green.offset  = screen_info.green_pos;
+	linearfb_defined.green.length  = screen_info.green_size;
+	linearfb_defined.blue.offset   = screen_info.blue_pos;
+	linearfb_defined.blue.length   = screen_info.blue_size;
+	linearfb_defined.transp.offset = screen_info.rsvd_pos;
+	linearfb_defined.transp.length = screen_info.rsvd_size;
+
+	printk(KERN_INFO "linearfb: %s: "
+	       "size=%d:%d:%d:%d, shift=%d:%d:%d:%d\n",
+	       "Truecolor",
+	       screen_info.rsvd_size,
+	       screen_info.red_size,
+	       screen_info.green_size,
+	       screen_info.blue_size,
+	       screen_info.rsvd_pos,
+	       screen_info.red_pos,
+	       screen_info.green_pos,
+	       screen_info.blue_pos);
+
+	linearfb_fix.ypanstep  = 0;
+	linearfb_fix.ywrapstep = 0;
+
+	info->fbops = &linearfb_ops;
+	info->var = linearfb_defined;
+	info->fix = linearfb_fix;
+	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_MISC_FIRMWARE;
+
+	if ((err = fb_alloc_cmap(&info->cmap, 256, 0)) < 0) {
+		printk(KERN_ERR "linearfb: cannot allocate colormap\n");
+		goto err_unmap;
+	}
+	*p_info = info;
+	return 0;
+
+err_unmap:
+	iounmap(info->screen_base);
+err_release_fb:
+	framebuffer_release(info);
+err_release_mem:
+	if (request_succeeded)
+		release_mem_region(linearfb_fix.smem_start, size_total);
+	return err;
+}
+EXPORT_SYMBOL(linearfb_get_info);
+
+static int linearfb_probe(struct platform_device *dev)
+{
+	int err;
+	struct fb_info *info;
+
+	if ((err = linearfb_get_info(dev, &info)) < 0)
+		return err;
+
+	if ((err = register_framebuffer(info)) < 0) {
+		printk(KERN_ERR "linearfb: cannot register framebuffer\n");
+		goto err_fb_dealloc;
+	}
+	printk(KERN_INFO "fb%d: %s frame buffer device\n",
+		info->node, info->fix.id);
+	return 0;
+
+err_fb_dealloc:
+	fb_dealloc_cmap(&info->cmap);
+	linearfb_destroy(info);
+	return err;
+}
+
+static struct platform_driver linearfb_driver = {
+	.probe	= linearfb_probe,
+	.driver	= {
+		.name	= "linearfb",
+	},
+};
+
+static struct platform_device linearfb_device = {
+	.name	= "linearfb",
+};
+
+static int __init linearfb_init(void)
+{
+	int ret;
+	char *option = NULL;
+
+	if (screen_info.orig_video_isVGA != VIDEO_TYPE_LINEAR)
+		return -ENODEV;
+
+	if (fb_get_options("linearfb", &option))
+		return -ENODEV;
+	linearfb_setup(option);
+
+	if (!screen_info.lfb_linelength)
+		return -ENODEV;
+
+	ret = platform_driver_register(&linearfb_driver);
+
+	if (!ret) {
+		ret = platform_device_register(&linearfb_device);
+		if (ret)
+			platform_driver_unregister(&linearfb_driver);
+	}
+	return ret;
+}
+module_init(linearfb_init);
+
+MODULE_LICENSE("GPL");
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 8e5a9df..0913385 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -1137,6 +1137,14 @@ extern int fb_find_mode(struct fb_var_screeninfo *var,
 			const struct fb_videomode *default_mode,
 			unsigned int default_bpp);
 
+#ifdef CONFIG_FB_LINEAR
+struct platform_device;
+
+extern void linearfb_destroy(struct fb_info *info);
+extern int linearfb_get_info(struct platform_device *dev,
+			     struct fb_info **p_info);
+#endif /* CONFIG_FB_LINEAR */
+
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_FB_H */
diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
index 899fbb4..129f533 100644
--- a/include/linux/screen_info.h
+++ b/include/linux/screen_info.h
@@ -66,6 +66,8 @@ struct screen_info {
 
 #define VIDEO_TYPE_EFI		0x70	/* EFI graphic mode		*/
 
+#define VIDEO_TYPE_LINEAR	0x80	/* Simple linear frame bufffer	*/
+
 #define VIDEO_FLAGS_NOCURSOR	(1 << 0) /* The video mode has no cursor set */
 
 #ifdef __KERNEL__
-- 
1.7.1
