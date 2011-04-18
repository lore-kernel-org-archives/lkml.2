Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1DRKPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 06:15:10 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:38275 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752324Ab1DRKPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 06:15:05 -0400
To: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH v4] [resend] s3fb: add DDC support
Cc: Ondrej Zajicek <santiago@crfreenet.org>, linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Mon, 18 Apr 2011 12:14:57 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104181214.57501.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add I2C support for the DDC bus and also default mode initialization by
reading monitor EDID to the s3fb driver.

Tested on Trio64V+ (2 cards), Trio64V2/DX, Virge (3 cards),
Virge/DX (3 cards), Virge/GX2, Trio3D/2X (4 cards), Trio3D.

Will probably not work on Trio32 - my 2 cards have DDC support in BIOS that
looks different from the other cards but the DDC pins on the VGA connector
are not connected.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-/drivers/video/s3fb.c	2011-04-11 23:29:44.000000000 +0200
+++ linux-2.6.39-rc2/drivers/video/s3fb.c	2011-04-11 23:10:35.000000000 +0200
@@ -25,6 +25,9 @@
 #include <linux/console.h> /* Why should fb driver call console functions? because console_lock() */
 #include <video/vga.h>
 
+#include <linux/i2c.h>
+#include <linux/i2c-algo-bit.h>
+
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
 #endif
@@ -36,6 +39,12 @@ struct s3fb_info {
 	struct mutex open_lock;
 	unsigned int ref_count;
 	u32 pseudo_palette[16];
+#ifdef CONFIG_FB_S3_DDC
+	u8 __iomem *mmio;
+	bool ddc_registered;
+	struct i2c_adapter ddc_adapter;
+	struct i2c_algo_bit_data ddc_algo;
+#endif
 };
 
 
@@ -105,6 +114,9 @@ static const char * const s3_names[] = {
 #define CHIP_UNDECIDED_FLAG	0x80
 #define CHIP_MASK		0xFF
 
+#define MMIO_OFFSET		0x1000000
+#define MMIO_SIZE		0x10000
+
 /* CRT timing register sets */
 
 static const struct vga_regset s3_h_total_regs[]        = {{0x00, 0, 7}, {0x5D, 0, 0}, VGA_REGSET_END};
@@ -140,7 +152,7 @@ static const struct svga_timing_regs s3_
 /* Module parameters */
 
 
-static char *mode_option __devinitdata = "640x480-8@60";
+static char *mode_option __devinitdata;
 
 #ifdef CONFIG_MTRR
 static int mtrr __devinitdata = 1;
@@ -169,6 +181,119 @@ MODULE_PARM_DESC(fasttext, "Enable S3 fa
 
 /* ------------------------------------------------------------------------- */
 
+#ifdef CONFIG_FB_S3_DDC
+
+#define DDC_REG		0xaa		/* Trio 3D/1X/2X */
+#define DDC_MMIO_REG	0xff20		/* all other chips */
+#define DDC_SCL_OUT	(1 << 0)
+#define DDC_SDA_OUT	(1 << 1)
+#define DDC_SCL_IN	(1 << 2)
+#define DDC_SDA_IN	(1 << 3)
+#define DDC_DRIVE_EN	(1 << 4)
+
+static bool s3fb_ddc_needs_mmio(int chip)
+{
+	return !(chip == CHIP_360_TRIO3D_1X  ||
+		 chip == CHIP_362_TRIO3D_2X  ||
+		 chip == CHIP_368_TRIO3D_2X);
+}
+
+static u8 s3fb_ddc_read(struct s3fb_info *par)
+{
+	if (s3fb_ddc_needs_mmio(par->chip))
+		return readb(par->mmio + DDC_MMIO_REG);
+	else
+		return vga_rcrt(par->state.vgabase, DDC_REG);
+}
+
+static void s3fb_ddc_write(struct s3fb_info *par, u8 val)
+{
+	if (s3fb_ddc_needs_mmio(par->chip))
+		writeb(val, par->mmio + DDC_MMIO_REG);
+	else
+		vga_wcrt(par->state.vgabase, DDC_REG, val);
+}
+
+static void s3fb_ddc_setscl(void *data, int val)
+{
+	struct s3fb_info *par = data;
+	unsigned char reg;
+
+	reg = s3fb_ddc_read(par) | DDC_DRIVE_EN;
+	if (val)
+		reg |= DDC_SCL_OUT;
+	else
+		reg &= ~DDC_SCL_OUT;
+	s3fb_ddc_write(par, reg);
+}
+
+static void s3fb_ddc_setsda(void *data, int val)
+{
+	struct s3fb_info *par = data;
+	unsigned char reg;
+
+	reg = s3fb_ddc_read(par) | DDC_DRIVE_EN;
+	if (val)
+		reg |= DDC_SDA_OUT;
+	else
+		reg &= ~DDC_SDA_OUT;
+	s3fb_ddc_write(par, reg);
+}
+
+static int s3fb_ddc_getscl(void *data)
+{
+	struct s3fb_info *par = data;
+
+	return !!(s3fb_ddc_read(par) & DDC_SCL_IN);
+}
+
+static int s3fb_ddc_getsda(void *data)
+{
+	struct s3fb_info *par = data;
+
+	return !!(s3fb_ddc_read(par) & DDC_SDA_IN);
+}
+
+static int __devinit s3fb_setup_ddc_bus(struct fb_info *info)
+{
+	struct s3fb_info *par = info->par;
+
+	strlcpy(par->ddc_adapter.name, info->fix.id,
+		sizeof(par->ddc_adapter.name));
+	par->ddc_adapter.owner		= THIS_MODULE;
+	par->ddc_adapter.class		= I2C_CLASS_DDC;
+	par->ddc_adapter.algo_data	= &par->ddc_algo;
+	par->ddc_adapter.dev.parent	= info->device;
+	par->ddc_algo.setsda		= s3fb_ddc_setsda;
+	par->ddc_algo.setscl		= s3fb_ddc_setscl;
+	par->ddc_algo.getsda		= s3fb_ddc_getsda;
+	par->ddc_algo.getscl		= s3fb_ddc_getscl;
+	par->ddc_algo.udelay		= 10;
+	par->ddc_algo.timeout		= 20;
+	par->ddc_algo.data		= par;
+
+	i2c_set_adapdata(&par->ddc_adapter, par);
+
+	/*
+	 * some Virge cards have external MUX to switch chip I2C bus between
+	 * DDC and extension pins - switch it do DDC
+	 */
+/*	vga_wseq(par->state.vgabase, 0x08, 0x06); - not needed, already unlocked */
+	if (par->chip == CHIP_357_VIRGE_GX2 ||
+	    par->chip == CHIP_359_VIRGE_GX2P)
+		svga_wseq_mask(par->state.vgabase, 0x0d, 0x01, 0x03);
+	else
+		svga_wseq_mask(par->state.vgabase, 0x0d, 0x00, 0x03);
+	/* some Virge need this or the DDC is ignored */
+	svga_wcrt_mask(par->state.vgabase, 0x5c, 0x03, 0x03);
+
+	return i2c_bit_add_bus(&par->ddc_adapter);
+}
+#endif /* CONFIG_FB_S3_DDC */
+
+
+/* ------------------------------------------------------------------------- */
+
 /* Set font in S3 fast text mode */
 
 static void s3fb_settile_fast(struct fb_info *info, struct fb_tilemap *map)
@@ -994,6 +1119,7 @@ static int __devinit s3_pci_probe(struct
 	struct s3fb_info *par;
 	int rc;
 	u8 regval, cr38, cr39;
+	bool found = false;
 
 	/* Ignore secondary VGA device because there is no VGA arbitration */
 	if (! svga_primary_device(dev)) {
@@ -1110,12 +1236,69 @@ static int __devinit s3_pci_probe(struct
 	info->fix.ypanstep = 0;
 	info->fix.accel = FB_ACCEL_NONE;
 	info->pseudo_palette = (void*) (par->pseudo_palette);
+	info->var.bits_per_pixel = 8;
+
+#ifdef CONFIG_FB_S3_DDC
+	/* Enable MMIO if needed */
+	if (s3fb_ddc_needs_mmio(par->chip)) {
+		par->mmio = ioremap(info->fix.smem_start + MMIO_OFFSET, MMIO_SIZE);
+		if (par->mmio)
+			svga_wcrt_mask(par->state.vgabase, 0x53, 0x08, 0x08);	/* enable MMIO */
+		else
+			dev_err(info->device, "unable to map MMIO at 0x%lx, disabling DDC",
+				info->fix.smem_start + MMIO_OFFSET);
+	}
+	if (!s3fb_ddc_needs_mmio(par->chip) || par->mmio)
+		if (s3fb_setup_ddc_bus(info) == 0) {
+			u8 *edid = fb_ddc_read(&par->ddc_adapter);
+			par->ddc_registered = true;
+			if (edid) {
+				fb_edid_to_monspecs(edid, &info->monspecs);
+				kfree(edid);
+				if (!info->monspecs.modedb)
+					dev_err(info->device, "error getting mode database\n");
+				else {
+					const struct fb_videomode *m;
+
+					fb_videomode_to_modelist(info->monspecs.modedb,
+								 info->monspecs.modedb_len,
+								 &info->modelist);
+					m = fb_find_best_display(&info->monspecs, &info->modelist);
+					if (m) {
+						fb_videomode_to_var(&info->var, m);
+						/* fill all other info->var's fields */
+						if (s3fb_check_var(&info->var, info) == 0)
+							found = true;
+					}
+				}
+			}
+		}
+#endif
+	if (!mode_option && !found)
+		mode_option = "640x480-8@60";
 
 	/* Prepare startup mode */
-	rc = fb_find_mode(&(info->var), info, mode_option, NULL, 0, NULL, 8);
-	if (! ((rc == 1) || (rc == 2))) {
-		rc = -EINVAL;
-		dev_err(info->device, "mode %s not found\n", mode_option);
+	if (mode_option) {
+		rc = fb_find_mode(&info->var, info, mode_option,
+				   info->monspecs.modedb, info->monspecs.modedb_len,
+				   NULL, info->var.bits_per_pixel);
+		if (!rc || rc == 4) {
+			rc = -EINVAL;
+			dev_err(info->device, "mode %s not found\n", mode_option);
+			fb_destroy_modedb(info->monspecs.modedb);
+			info->monspecs.modedb = NULL;
+			goto err_find_mode;
+		}
+	}
+
+	fb_destroy_modedb(info->monspecs.modedb);
+	info->monspecs.modedb = NULL;
+
+	/* maximize virtual vertical size for fast scrolling */
+	info->var.yres_virtual = info->fix.smem_len * 8 /
+			(info->var.bits_per_pixel * info->var.xres_virtual);
+	if (info->var.yres_virtual < info->var.yres) {
+		dev_err(info->device, "virtual vertical size smaller than real\n");
 		goto err_find_mode;
 	}
 
@@ -1164,6 +1347,12 @@ err_reg_fb:
 	fb_dealloc_cmap(&info->cmap);
 err_alloc_cmap:
 err_find_mode:
+#ifdef CONFIG_FB_S3_DDC
+	if (par->ddc_registered)
+		i2c_del_adapter(&par->ddc_adapter);
+	if (par->mmio)
+		iounmap(par->mmio);
+#endif
 	pci_iounmap(dev, info->screen_base);
 err_iomap:
 	pci_release_regions(dev);
@@ -1195,6 +1384,13 @@ static void __devexit s3_pci_remove(stru
 		unregister_framebuffer(info);
 		fb_dealloc_cmap(&info->cmap);
 
+#ifdef CONFIG_FB_S3_DDC
+		if (par->ddc_registered)
+			i2c_del_adapter(&par->ddc_adapter);
+		if (par->mmio)
+			iounmap(par->mmio);
+#endif
+
 		pci_iounmap(dev, info->screen_base);
 		pci_release_regions(dev);
 /*		pci_disable_device(dev); */
--- linux-2.6.39-rc2-orig/drivers/video/Kconfig	2011-04-06 03:30:43.000000000 +0200
+++ linux-2.6.39-rc2/drivers/video/Kconfig	2011-04-11 22:41:18.000000000 +0200
@@ -1463,6 +1463,14 @@ config FB_S3
 	---help---
 	  Driver for graphics boards with S3 Trio / S3 Virge chip.
 
+config FB_S3_DDC
+	bool "DDC for S3 support"
+	depends on FB_S3
+	select FB_DDC
+	default y
+	help
+	  Say Y here if you want DDC support for your S3 graphics card.
+
 config FB_SAVAGE
 	tristate "S3 Savage support"
 	depends on FB && PCI && EXPERIMENTAL


-- 
Ondrej Zary
