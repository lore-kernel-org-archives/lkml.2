Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab0HKUSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 16:18:24 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:59824 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756965Ab0HKUSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 16:18:22 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Ondrej Zajicek <santiago@crfreenet.org>
Subject: [PATCH] s3fb: add DDC support
Date: Wed, 11 Aug 2010 22:18:09 +0200
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008112218.11535.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add I2C support for the DDC bus to s3fb driver. This is only bus support,
driver does not use EDID.

Tested on Trio64V+, Trio64V2/DX, Virge (2 cards), Virge/DX (4 cards) and
Trio3D/2X (3 cards) with i2cdetect and decode-edid.

Will probably not work on Trio32 - my 2 cards have DDC support in BIOS that
looks different from the other cards but the DDC pins on the VGA connector
are not connected.

Virge/GX, Virge/GX2 and Virge/VX are untested.


Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.35-rc2/drivers/video/s3fb.c	2010-06-06 05:43:24.000000000 +0200
+++ linux-2.6.35-rc3/drivers/video/s3fb.c	2010-08-10 19:42:38.000000000 +0200
@@ -25,6 +25,10 @@
 #include <linux/console.h> /* Why should fb driver call console functions? because acquire_console_sem() */
 #include <video/vga.h>
 
+#include <linux/i2c.h>
+#include <linux/i2c-id.h>
+#include <linux/i2c-algo-bit.h>
+
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
 #endif
@@ -36,6 +40,12 @@
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
 
 
@@ -102,6 +112,9 @@
 #define CHIP_UNDECIDED_FLAG	0x80
 #define CHIP_MASK		0xFF
 
+#define MMIO_OFFSET		0x1000000
+#define MMIO_SIZE		0x10000
+
 /* CRT timing register sets */
 
 static const struct vga_regset s3_h_total_regs[]        = {{0x00, 0, 7}, {0x5D, 0, 0}, VGA_REGSET_END};
@@ -164,6 +177,118 @@
 
 /* ------------------------------------------------------------------------- */
 
+#ifdef CONFIG_FB_S3_DDC
+
+#define DDC_REG		0xaa		/* Trio 3D and probably Virge/GX2 */
+#define DDC_MMIO_REG	0xff20		/* Trio, Virge, Virge/DX, not sure about Virge/GX and VX */
+#define DDC_SCL_OUT	(1 << 0)
+#define DDC_SDA_OUT	(1 << 1)
+#define DDC_SCL_IN	(1 << 2)
+#define DDC_SDA_IN	(1 << 3)
+#define DDC_DRIVE_EN	(1 << 4)
+
+static bool s3fb_ddc_needs_mmio(int chip)
+{
+	return !(chip == CHIP_356_VIRGE_GX2  ||
+		 chip == CHIP_357_VIRGE_GX2P ||
+		 chip == CHIP_359_VIRGE_GX2P ||
+		 chip == CHIP_360_TRIO3D_1X  ||
+		 chip == CHIP_362_TRIO3D_2X  ||
+		 chip == CHIP_368_TRIO3D_2X);
+}
+
+static u8 s3fb_ddc_read(struct s3fb_info *par)
+{
+	if (s3fb_ddc_needs_mmio(par->chip))
+		return readb(par->mmio + DDC_MMIO_REG);
+	else
+		return vga_rcrt(NULL, DDC_REG);
+}
+
+static void s3fb_ddc_write(struct s3fb_info *par, u8 val)
+{
+	if (s3fb_ddc_needs_mmio(par->chip))
+		writeb(val, par->mmio + DDC_MMIO_REG);
+	else
+		vga_wcrt(NULL, DDC_REG, val);
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
+/*	vga_wseq(NULL, 0x08, 0x06); - not needed, already unlocked */
+	svga_wseq_mask(0x0d, 0x00, 0x03);
+	/* some Virge need this or the DDC is ignored */
+	svga_wcrt_mask(0x5c, 0x03, 0x03);
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
@@ -1019,6 +1144,21 @@
 	info->fix.accel = FB_ACCEL_NONE;
 	info->pseudo_palette = (void*) (par->pseudo_palette);
 
+#ifdef CONFIG_FB_S3_DDC
+	/* Enable MMIO if needed */
+	if (s3fb_ddc_needs_mmio(par->chip)) {
+		par->mmio = ioremap(info->fix.smem_start + MMIO_OFFSET, MMIO_SIZE);
+		if (par->mmio)
+			svga_wcrt_mask(0x53, 0x08, 0x08);	/* enable MMIO */
+		else
+			dev_err(info->device, "unable to map MMIO at 0x%lx, disabling DDC",
+				info->fix.smem_start + MMIO_OFFSET);
+	}
+	if (!s3fb_ddc_needs_mmio(par->chip) || par->mmio)
+		if (s3fb_setup_ddc_bus(info) == 0)
+			par->ddc_registered = true;
+#endif
+
 	/* Prepare startup mode */
 	rc = fb_find_mode(&(info->var), info, mode_option, NULL, 0, NULL, 8);
 	if (! ((rc == 1) || (rc == 2))) {
@@ -1064,6 +1204,12 @@
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
@@ -1095,6 +1241,13 @@
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


-- 
Ondrej Zary
