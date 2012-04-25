Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075Ab2DYUvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:51:48 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:47883 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab2DYUvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:51:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAOtimE9bdWOb/2dsb2JhbABFsU6BB4I3UoECGyISiAEDD7FwDYlTiX2GYwSVe4s9hQGCa4FSFg
X-IronPort-AV: E=Sophos;i="4.75,483,1330902000"; 
   d="scan'208";a="505301722"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com,
        boyod.yang@siliconmotion.com.cn, wuzhangjin@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH] staging: sm7xx: code improvements and cleanup
Date: Wed, 25 Apr 2012 22:50:28 +0200
Message-Id: <1335387028-29652-1-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements some code improvements and cleanup.

New code uses dynamic debug support. Old debug calls updated/tested to
use this API.

Cleanup on obsolete references, internal versions and some
comments. Dead code removal.

Patch tested with SM712.

Changes:

- Code improvements and cleanup
- Use dynamic debug support
- Remove out-of-date comments/references
- Remove dead code

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xx/smtcfb.c |  344 ++++++++++++++++------------------------
 drivers/staging/sm7xx/smtcfb.h |    8 -
 2 files changed, 136 insertions(+), 216 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 83c582e..ce56698 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -2,31 +2,19 @@
  * Silicon Motion SM7XX frame buffer device
  *
  * Copyright (C) 2006 Silicon Motion Technology Corp.
- * Authors: Ge Wang, gewang@siliconmotion.com
- *	    Boyod boyod.yang@siliconmotion.com.cn
+ * Authors:  Ge Wang, gewang@siliconmotion.com
+ *	     Boyod boyod.yang@siliconmotion.com.cn
  *
  * Copyright (C) 2009 Lemote, Inc.
- * Author: Wu Zhangjin, wuzhangjin@gmail.com
+ * Author:   Wu Zhangjin, wuzhangjin@gmail.com
  *
  * Copyright (C) 2011 Igalia, S.L.
- * Author: Javier M. Mellid <jmunhoz@igalia.com>
+ * Author:   Javier M. Mellid <jmunhoz@igalia.com>
  *
- *  This file is subject to the terms and conditions of the GNU General Public
- *  License. See the file COPYING in the main directory of this archive for
- *  more details.
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file COPYING in the main directory of this archive for
+ * more details.
  *
- * Version 0.10.26192.21.01
- *	- Add PowerPC/Big endian support
- *	- Verified on 2.6.19.2
- *	Boyod.yang <boyod.yang@siliconmotion.com.cn>
- *
- * Version 0.09.2621.00.01
- *	- Only support Linux Kernel's version 2.6.21
- *	Boyod.yang <boyod.yang@siliconmotion.com.cn>
- *
- * Version 0.09
- *	- Only support Linux Kernel's version 2.6.12
- *	Boyod.yang <boyod.yang@siliconmotion.com.cn>
  */
 
 #include <linux/io.h>
@@ -45,40 +33,19 @@
 
 #include "smtcfb.h"
 
-#ifdef DEBUG
-#define smdbg(format, arg...) printk(KERN_DEBUG format , ## arg)
-#else
-#define smdbg(format, arg...)
-#endif
-
 struct screen_info smtc_screen_info;
 
 /*
 * Private structure
 */
 struct smtcfb_info {
-	/*
-	 * The following is a pointer to be passed into the
-	 * functions below.  The modules outside the main
-	 * voyager.c driver have no knowledge as to what
-	 * is within this structure.
-	 */
 	struct fb_info fb;
-	struct display_switch *dispsw;
-	struct pci_dev *dev;
-	signed int currcon;
-
+	struct pci_dev *pdev;
 	struct {
 		u8 red, green, blue;
 	} palette[NR_RGB];
-
 	u_int palette_size;
-};
 
-struct par_info {
-	/*
-	 * Hardware
-	 */
 	u16 chipID;
 	unsigned char __iomem *m_pMMIO;
 	char __iomem *m_pLFB;
@@ -121,15 +88,6 @@ char __iomem *smtc_RegBaseAddress;	/* Memory Map IO starting address */
 char __iomem *smtc_VRAMBaseAddress;	/* video memory starting address */
 
 static u32 colreg[17];
-static struct par_info hw;	/* hardware information */
-
-u16 smtc_ChipIDs[] = {
-	0x710,
-	0x712,
-	0x720
-};
-
-#define numSMTCchipIDs ARRAY_SIZE(smtc_ChipIDs)
 
 static struct fb_var_screeninfo smtcfb_var = {
 	.xres           = 1024,
@@ -154,30 +112,29 @@ static struct fb_fix_screeninfo smtcfb_fix = {
 	.accel          = FB_ACCEL_SMI_LYNX,
 };
 
-static void sm712_set_timing(struct smtcfb_info *sfb,
-			     struct par_info *ppar_info)
+static void sm712_set_timing(struct smtcfb_info *sfb)
 {
 	int i = 0, j = 0;
 	u32 m_nScreenStride;
 
-	smdbg("\nppar_info->width = %d ppar_info->height = %d"
-			"sfb->fb.var.bits_per_pixel = %d ppar_info->hz = %d\n",
-			ppar_info->width, ppar_info->height,
-			sfb->fb.var.bits_per_pixel, ppar_info->hz);
+	dev_dbg(&sfb->pdev->dev,
+		"sfb->width=%d sfb->height=%d "
+		"sfb->fb.var.bits_per_pixel=%d sfb->hz=%d\n",
+		 sfb->width, sfb->height, sfb->fb.var.bits_per_pixel, sfb->hz);
 
 	for (j = 0; j < numVGAModes; j++) {
-		if (VGAMode[j].mmSizeX == ppar_info->width &&
-		    VGAMode[j].mmSizeY == ppar_info->height &&
+		if (VGAMode[j].mmSizeX == sfb->width &&
+		    VGAMode[j].mmSizeY == sfb->height &&
 		    VGAMode[j].bpp == sfb->fb.var.bits_per_pixel &&
-		    VGAMode[j].hz == ppar_info->hz) {
+		    VGAMode[j].hz == sfb->hz) {
 
-			smdbg("\nVGAMode[j].mmSizeX  = %d VGAMode[j].mmSizeY ="
-					"%d VGAMode[j].bpp = %d"
-					"VGAMode[j].hz=%d\n",
-					VGAMode[j].mmSizeX, VGAMode[j].mmSizeY,
-					VGAMode[j].bpp, VGAMode[j].hz);
+			dev_dbg(&sfb->pdev->dev,
+				"VGAMode[j].mmSizeX=%d VGAMode[j].mmSizeY=%d "
+				"VGAMode[j].bpp=%d VGAMode[j].hz=%d\n",
+				 VGAMode[j].mmSizeX, VGAMode[j].mmSizeY,
+				 VGAMode[j].bpp, VGAMode[j].hz);
 
-			smdbg("VGAMode index=%d\n", j);
+			dev_dbg(&sfb->pdev->dev, "VGAMode index=%d\n", j);
 
 			smtc_mmiowb(0x0, 0x3c6);
 
@@ -238,37 +195,49 @@ static void sm712_set_timing(struct smtcfb_info *sfb,
 	smtc_mmiowb(0x67, 0x3c2);
 
 	/* set VPR registers */
-	writel(0x0, ppar_info->m_pVPR + 0x0C);
-	writel(0x0, ppar_info->m_pVPR + 0x40);
+	writel(0x0, sfb->m_pVPR + 0x0C);
+	writel(0x0, sfb->m_pVPR + 0x40);
 
 	/* set data width */
 	m_nScreenStride =
-		(ppar_info->width * sfb->fb.var.bits_per_pixel) / 64;
+		(sfb->width * sfb->fb.var.bits_per_pixel) / 64;
 	switch (sfb->fb.var.bits_per_pixel) {
 	case 8:
-		writel(0x0, ppar_info->m_pVPR + 0x0);
+		writel(0x0, sfb->m_pVPR + 0x0);
 		break;
 	case 16:
-		writel(0x00020000, ppar_info->m_pVPR + 0x0);
+		writel(0x00020000, sfb->m_pVPR + 0x0);
 		break;
 	case 24:
-		writel(0x00040000, ppar_info->m_pVPR + 0x0);
+		writel(0x00040000, sfb->m_pVPR + 0x0);
 		break;
 	case 32:
-		writel(0x00030000, ppar_info->m_pVPR + 0x0);
+		writel(0x00030000, sfb->m_pVPR + 0x0);
 		break;
 	}
+
 	writel((u32) (((m_nScreenStride + 2) << 16) | m_nScreenStride),
-	       ppar_info->m_pVPR + 0x10);
+	       sfb->m_pVPR + 0x10);
 
 }
 
+static void smtc_set_timing(struct smtcfb_info *sfb)
+{
+	switch (sfb->chipID) {
+	case 0x710:
+	case 0x712:
+	case 0x720:
+		sm712_set_timing(sfb);
+		break;
+	}
+}
+
 static void sm712_setpalette(int regno, unsigned red, unsigned green,
 			     unsigned blue, struct fb_info *info)
 {
-	struct par_info *cur_par = (struct par_info *)info->par;
+	struct smtcfb_info *sfb = info->par;
 
-	if (cur_par->BaseAddressInVRAM)
+	if (sfb->BaseAddressInVRAM)
 		/*
 		 * second display palette for dual head. Enable CRT RAM, 6-bit
 		 * RAM
@@ -283,34 +252,7 @@ static void sm712_setpalette(int regno, unsigned red, unsigned green,
 	smtc_mmiowb(blue >> 10, dac_val);
 }
 
-static void smtc_set_timing(struct smtcfb_info *sfb, struct par_info
-		*ppar_info)
-{
-	switch (ppar_info->chipID) {
-	case 0x710:
-	case 0x712:
-	case 0x720:
-		sm712_set_timing(sfb, ppar_info);
-		break;
-	}
-}
-
-/* chan_to_field
- *
- * convert a colour value into a field position
- *
- * from pxafb.c
- */
-
-static inline unsigned int chan_to_field(unsigned int chan,
-					 struct fb_bitfield *bf)
-{
-	chan &= 0xffff;
-	chan >>= 16 - bf->length;
-	return chan << bf->offset;
-}
-
-static int cfb_blank(int blank_mode, struct fb_info *info)
+static int smtc_blank(int blank_mode, struct fb_info *info)
 {
 	/* clear DPMS setting */
 	switch (blank_mode) {
@@ -381,6 +323,17 @@ static int cfb_blank(int blank_mode, struct fb_info *info)
 	return 0;
 }
 
+/*
+ * Convert a colour value into a field position
+ */
+static inline unsigned int chan_to_field(unsigned int chan,
+					 struct fb_bitfield *bf)
+{
+	chan &= 0xffff;
+	chan >>= 16 - bf->length;
+	return chan << bf->offset;
+}
+
 static int smtc_setcolreg(unsigned regno, unsigned red, unsigned green,
 			  unsigned blue, unsigned trans, struct fb_info *info)
 {
@@ -620,7 +573,6 @@ void smtcfb_setmode(struct smtcfb_info *sfb)
 		sfb->fb.var.red.offset = 16;
 		sfb->fb.var.green.offset = 8;
 		sfb->fb.var.blue.offset = 0;
-
 		break;
 	case 8:
 		sfb->fb.fix.visual = FB_VISUAL_PSEUDOCOLOR;
@@ -638,32 +590,27 @@ void smtcfb_setmode(struct smtcfb_info *sfb)
 		sfb->fb.var.red.length = 8;
 		sfb->fb.var.green.length = 8;
 		sfb->fb.var.blue.length = 8;
-
 		sfb->fb.var.red.offset = 16;
 		sfb->fb.var.green.offset = 8;
 		sfb->fb.var.blue.offset = 0;
-
 		break;
 	case 16:
 	default:
 		sfb->fb.fix.visual = FB_VISUAL_TRUECOLOR;
 		sfb->fb.fix.line_length = sfb->fb.var.xres * 2;
-
 		sfb->fb.var.red.length = 5;
 		sfb->fb.var.green.length = 6;
 		sfb->fb.var.blue.length = 5;
-
 		sfb->fb.var.red.offset = 11;
 		sfb->fb.var.green.offset = 5;
 		sfb->fb.var.blue.offset = 0;
-
 		break;
 	}
 
-	hw.width = sfb->fb.var.xres;
-	hw.height = sfb->fb.var.yres;
-	hw.hz = 60;
-	smtc_set_timing(sfb, &hw);
+	sfb->width = sfb->fb.var.xres;
+	sfb->height = sfb->fb.var.yres;
+	sfb->hz = 60;
+	smtc_set_timing(sfb);
 }
 
 static int smtc_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
@@ -697,7 +644,7 @@ static struct fb_ops smtcfb_ops = {
 	.fb_check_var = smtc_check_var,
 	.fb_set_par   = smtc_set_par,
 	.fb_setcolreg = smtc_setcolreg,
-	.fb_blank     = cfb_blank,
+	.fb_blank     = smtc_blank,
 	.fb_fillrect  = cfb_fillrect,
 	.fb_imageblit = cfb_imageblit,
 	.fb_copyarea  = cfb_copyarea,
@@ -710,8 +657,7 @@ static struct fb_ops smtcfb_ops = {
 /*
  * Alloc struct smtcfb_info and assign the default value
  */
-static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *dev,
-							char *name)
+static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *pdev, char *name)
 {
 	struct smtcfb_info *sfb;
 
@@ -720,23 +666,22 @@ static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *dev,
 	if (!sfb)
 		return NULL;
 
-	sfb->currcon = -1;
-	sfb->dev = dev;
+	sfb->pdev = pdev;
 
-	/*** Init sfb->fb with default value ***/
+	/* init sfb->fb with default value */
 	sfb->fb.flags = FBINFO_FLAG_DEFAULT;
 	sfb->fb.fbops = &smtcfb_ops;
-	sfb->fb.var = smtcfb_var;
-	sfb->fb.fix = smtcfb_fix;
+	sfb->fb.var   = smtcfb_var;
+	sfb->fb.fix   = smtcfb_fix;
 
 	strcpy(sfb->fb.fix.id, name);
 
-	sfb->fb.fix.type = FB_TYPE_PACKED_PIXELS;
-	sfb->fb.fix.type_aux = 0;
-	sfb->fb.fix.xpanstep = 0;
-	sfb->fb.fix.ypanstep = 0;
+	sfb->fb.fix.type      = FB_TYPE_PACKED_PIXELS;
+	sfb->fb.fix.type_aux  = 0;
+	sfb->fb.fix.xpanstep  = 0;
+	sfb->fb.fix.ypanstep  = 0;
 	sfb->fb.fix.ywrapstep = 0;
-	sfb->fb.fix.accel = FB_ACCEL_SMI_LYNX;
+	sfb->fb.fix.accel     = FB_ACCEL_SMI_LYNX;
 
 	sfb->fb.var.nonstd = 0;
 	sfb->fb.var.activate = FB_ACTIVATE_NOW;
@@ -745,7 +690,9 @@ static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *dev,
 	/* text mode acceleration */
 	sfb->fb.var.accel_flags = FB_ACCELF_TEXT;
 	sfb->fb.var.vmode = FB_VMODE_NONINTERLACED;
-	sfb->fb.par = &hw;
+
+	sfb->fb.par = sfb;
+
 	sfb->fb.pseudo_palette = colreg;
 
 	return sfb;
@@ -754,7 +701,6 @@ static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *dev,
 /*
  * Unmap in the memory mapped IO registers
  */
-
 static void smtc_unmap_mmio(struct smtcfb_info *sfb)
 {
 	if (sfb && smtc_RegBaseAddress)
@@ -764,19 +710,17 @@ static void smtc_unmap_mmio(struct smtcfb_info *sfb)
 /*
  * Map in the screen memory
  */
-
-static int smtc_map_smem(struct smtcfb_info *sfb,
-		struct pci_dev *dev, u_long smem_len)
+static int smtc_map_smem(struct smtcfb_info *sfb, u_long smem_len)
 {
 	if (sfb->fb.var.bits_per_pixel == 32) {
 #ifdef __BIG_ENDIAN
-		sfb->fb.fix.smem_start = pci_resource_start(dev, 0)
-			+ 0x800000;
+		sfb->fb.fix.smem_start =
+			pci_resource_start(sfb->pdev, 0) + 0x800000;
 #else
-		sfb->fb.fix.smem_start = pci_resource_start(dev, 0);
+		sfb->fb.fix.smem_start = pci_resource_start(sfb->pdev, 0);
 #endif
 	} else {
-		sfb->fb.fix.smem_start = pci_resource_start(dev, 0);
+		sfb->fb.fix.smem_start = pci_resource_start(sfb->pdev, 0);
 	}
 
 	sfb->fb.fix.smem_len = smem_len;
@@ -784,8 +728,8 @@ static int smtc_map_smem(struct smtcfb_info *sfb,
 	sfb->fb.screen_base = smtc_VRAMBaseAddress;
 
 	if (!sfb->fb.screen_base) {
-		printk(KERN_ERR "%s: unable to map screen memory\n",
-				sfb->fb.fix.id);
+		dev_err(&sfb->pdev->dev,
+		"%s: unable to map screen memory!", sfb->fb.fix.id);
 		return -ENOMEM;
 	}
 
@@ -822,26 +766,19 @@ static void smtc_free_fb_info(struct smtcfb_info *sfb)
 }
 
 /*
- *	sm712vga_setup - process command line options, get vga parameter
- *	@options: string of options
- *	Returns zero.
- *
+ * Process command line options, get vga parameter
  */
 static int __init sm712vga_setup(char *options)
 {
 	int index;
 
-	if (!options || !*options) {
-		smdbg("\n No vga parameter\n");
+	if (!options || !*options)
 		return -EINVAL;
-	}
 
 	smtc_screen_info.lfb_width = 0;
 	smtc_screen_info.lfb_height = 0;
 	smtc_screen_info.lfb_depth = 0;
 
-	smdbg("\nsm712vga_setup = %s\n", options);
-
 	for (index = 0;
 	     index < ARRAY_SIZE(vesa_mode);
 	     index++) {
@@ -856,14 +793,11 @@ static int __init sm712vga_setup(char *options)
 
 	return -1;
 }
+
 __setup("vga=", sm712vga_setup);
 
-/* Jason (08/13/2009)
- * Original init function changed to probe method to be used by pci_drv
- * process used to detect chips replaced with kernel process in pci_drv
- */
 static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
-				   const struct pci_device_id *ent)
+				      const struct pci_device_id *ent)
 {
 	struct smtcfb_info *sfb;
 	u_long smem_size = 0x00800000;	/* default 8MB */
@@ -871,29 +805,26 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	int err;
 	unsigned long pFramebufferPhysical;
 
-	printk(KERN_INFO
-		"Silicon Motion display driver " SMTC_LINUX_FB_VERSION "\n");
+	dev_info(&pdev->dev, "Silicon Motion display driver.");
 
 	err = pci_enable_device(pdev);	/* enable SMTC chip */
 	if (err)
 		return err;
 
-	hw.chipID = ent->device;
-	sprintf(name, "sm%Xfb", hw.chipID);
-
 	sfb = smtc_alloc_fb_info(pdev, name);
 
 	if (!sfb)
 		goto failed_free;
-	/* Jason (08/13/2009)
-	 * Store fb_info to be further used when suspending and resuming
-	 */
+
+	sfb->chipID = ent->device;
+	sprintf(name, "sm%Xfb", sfb->chipID);
+
 	pci_set_drvdata(pdev, sfb);
 
 	sm7xx_init_hw();
 
-	/*get mode parameter from smtc_screen_info */
 	if (smtc_screen_info.lfb_width != 0) {
+		/* get mode parameter from smtc_screen_info */
 		sfb->fb.var.xres = smtc_screen_info.lfb_width;
 		sfb->fb.var.yres = smtc_screen_info.lfb_height;
 		sfb->fb.var.bits_per_pixel = smtc_screen_info.lfb_depth;
@@ -908,39 +839,40 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	if (sfb->fb.var.bits_per_pixel == 24)
 		sfb->fb.var.bits_per_pixel = (smtc_screen_info.lfb_depth = 32);
 #endif
-	/* Map address and memory detection */
+
+	/* map address and memory detection */
 	pFramebufferPhysical = pci_resource_start(pdev, 0);
-	pci_read_config_byte(pdev, PCI_REVISION_ID, &hw.chipRevID);
+	pci_read_config_byte(pdev, PCI_REVISION_ID, &sfb->chipRevID);
 
-	switch (hw.chipID) {
+	switch (sfb->chipID) {
 	case 0x710:
 	case 0x712:
 		sfb->fb.fix.mmio_start = pFramebufferPhysical + 0x00400000;
 		sfb->fb.fix.mmio_len = 0x00400000;
 		smem_size = SM712_VIDEOMEMORYSIZE;
 #ifdef __BIG_ENDIAN
-		hw.m_pLFB = (smtc_VRAMBaseAddress =
+		sfb->m_pLFB = (smtc_VRAMBaseAddress =
 		    ioremap(pFramebufferPhysical, 0x00c00000));
 #else
-		hw.m_pLFB = (smtc_VRAMBaseAddress =
+		sfb->m_pLFB = (smtc_VRAMBaseAddress =
 		    ioremap(pFramebufferPhysical, 0x00800000));
 #endif
-		hw.m_pMMIO = (smtc_RegBaseAddress =
+		sfb->m_pMMIO = (smtc_RegBaseAddress =
 		    smtc_VRAMBaseAddress + 0x00700000);
-		hw.m_pDPR = smtc_VRAMBaseAddress + 0x00408000;
-		hw.m_pVPR = hw.m_pLFB + 0x0040c000;
+		sfb->m_pDPR = smtc_VRAMBaseAddress + 0x00408000;
+		sfb->m_pVPR = sfb->m_pLFB + 0x0040c000;
 #ifdef __BIG_ENDIAN
 		if (sfb->fb.var.bits_per_pixel == 32) {
 			smtc_VRAMBaseAddress += 0x800000;
-			hw.m_pLFB += 0x800000;
-			printk(KERN_INFO
-				"\nsmtc_VRAMBaseAddress=%p hw.m_pLFB=%p\n",
-					smtc_VRAMBaseAddress, hw.m_pLFB);
+			sfb->m_pLFB += 0x800000;
+			dev_info(&pdev->dev,
+				"smtc_VRAMBaseAddress=%p sfb->m_pLFB=%p",
+					smtc_VRAMBaseAddress, sfb->m_pLFB);
 		}
 #endif
 		if (!smtc_RegBaseAddress) {
-			printk(KERN_ERR
-				"%s: unable to map memory mapped IO\n",
+			dev_err(&pdev->dev,
+				"%s: unable to map memory mapped IO!",
 				sfb->fb.fix.id);
 			err = -ENOMEM;
 			goto failed_fb;
@@ -962,20 +894,20 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 		sfb->fb.fix.mmio_start = pFramebufferPhysical;
 		sfb->fb.fix.mmio_len = 0x00200000;
 		smem_size = SM722_VIDEOMEMORYSIZE;
-		hw.m_pDPR = ioremap(pFramebufferPhysical, 0x00a00000);
-		hw.m_pLFB = (smtc_VRAMBaseAddress =
-		    hw.m_pDPR + 0x00200000);
-		hw.m_pMMIO = (smtc_RegBaseAddress =
-		    hw.m_pDPR + 0x000c0000);
-		hw.m_pVPR = hw.m_pDPR + 0x800;
+		sfb->m_pDPR = ioremap(pFramebufferPhysical, 0x00a00000);
+		sfb->m_pLFB = (smtc_VRAMBaseAddress =
+		    sfb->m_pDPR + 0x00200000);
+		sfb->m_pMMIO = (smtc_RegBaseAddress =
+		    sfb->m_pDPR + 0x000c0000);
+		sfb->m_pVPR = sfb->m_pDPR + 0x800;
 
 		smtc_seqw(0x62, 0xff);
 		smtc_seqw(0x6a, 0x0d);
 		smtc_seqw(0x6b, 0x02);
 		break;
 	default:
-		printk(KERN_ERR
-		"No valid Silicon Motion display chip was detected!\n");
+		dev_err(&pdev->dev,
+		"No valid Silicon Motion display chip was detected!");
 
 		goto failed_fb;
 	}
@@ -986,31 +918,31 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 
 	sfb->fb.var.xres_virtual = sfb->fb.var.xres;
 	sfb->fb.var.yres_virtual = sfb->fb.var.yres;
-	err = smtc_map_smem(sfb, pdev, smem_size);
+	err = smtc_map_smem(sfb, smem_size);
 	if (err)
 		goto failed;
 
 	smtcfb_setmode(sfb);
+
 	/* Primary display starting from 0 position */
-	hw.BaseAddressInVRAM = 0;
-	sfb->fb.par = &hw;
+	sfb->BaseAddressInVRAM = 0;
 
 	err = register_framebuffer(&sfb->fb);
 	if (err < 0)
 		goto failed;
 
-	printk(KERN_INFO "Silicon Motion SM%X Rev%X primary display mode"
-			"%dx%d-%d Init Complete.\n", hw.chipID, hw.chipRevID,
-			sfb->fb.var.xres, sfb->fb.var.yres,
-			sfb->fb.var.bits_per_pixel);
+	dev_info(&pdev->dev,
+	       "Silicon Motion SM%X Rev%X primary display mode %dx%d-%d Init Complete.",
+		sfb->chipID, sfb->chipRevID, sfb->fb.var.xres,
+		sfb->fb.var.yres, sfb->fb.var.bits_per_pixel);
 
 	return 0;
 
 failed:
-	printk(KERN_ERR "Silicon Motion, Inc.  primary display init fail\n");
-
+	dev_err(&pdev->dev, "Silicon Motion, Inc. primary display init fail.");
 	smtc_unmap_smem(sfb);
 	smtc_unmap_mmio(sfb);
+
 failed_fb:
 	smtc_free_fb_info(sfb);
 
@@ -1020,8 +952,6 @@ failed_free:
 	return err;
 }
 
-
-/* Jason (08/11/2009) PCI_DRV wrapper essential structs */
 static DEFINE_PCI_DEVICE_TABLE(smtcfb_pci_table) = {
 	{ PCI_DEVICE(0x126f, 0x710), },
 	{ PCI_DEVICE(0x126f, 0x712), },
@@ -1029,10 +959,6 @@ static DEFINE_PCI_DEVICE_TABLE(smtcfb_pci_table) = {
 	{0,}
 };
 
-
-/* Jason (08/14/2009)
- * do some clean up when the driver module is removed
- */
 static void __devexit smtcfb_pci_remove(struct pci_dev *pdev)
 {
 	struct smtcfb_info *sfb;
@@ -1077,8 +1003,10 @@ static int smtcfb_pci_resume(struct device *device)
 	sfb = pci_get_drvdata(pdev);
 
 	/* reinit hardware */
+
 	sm7xx_init_hw();
-	switch (hw.chipID) {
+
+	switch (sfb->chipID) {
 	case 0x710:
 	case 0x712:
 		/* set MCLK = 14.31818 *  (0x16 / 0x2) */
@@ -1112,12 +1040,12 @@ static int smtcfb_pci_resume(struct device *device)
 }
 
 static const struct dev_pm_ops sm7xx_pm_ops = {
-	.suspend = smtcfb_pci_suspend,
-	.resume = smtcfb_pci_resume,
-	.freeze = smtcfb_pci_suspend,
-	.thaw = smtcfb_pci_resume,
+	.suspend  = smtcfb_pci_suspend,
+	.resume   = smtcfb_pci_resume,
+	.freeze   = smtcfb_pci_suspend,
+	.thaw     = smtcfb_pci_resume,
 	.poweroff = smtcfb_pci_suspend,
-	.restore = smtcfb_pci_resume,
+	.restore  = smtcfb_pci_resume,
 };
 
 #define SM7XX_PM_OPS (&sm7xx_pm_ops)
@@ -1129,11 +1057,11 @@ static const struct dev_pm_ops sm7xx_pm_ops = {
 #endif /* !CONFIG_PM */
 
 static struct pci_driver smtcfb_driver = {
-	.name = "smtcfb",
-	.id_table = smtcfb_pci_table,
-	.probe = smtcfb_pci_probe,
-	.remove = __devexit_p(smtcfb_pci_remove),
-	.driver.pm  = SM7XX_PM_OPS,
+	.name      = "smtcfb",
+	.id_table  = smtcfb_pci_table,
+	.probe     = smtcfb_pci_probe,
+	.remove    = __devexit_p(smtcfb_pci_remove),
+	.driver.pm = SM7XX_PM_OPS,
 };
 
 static int __init smtcfb_init(void)
diff --git a/drivers/staging/sm7xx/smtcfb.h b/drivers/staging/sm7xx/smtcfb.h
index ab95af2..43d86f8 100644
--- a/drivers/staging/sm7xx/smtcfb.h
+++ b/drivers/staging/sm7xx/smtcfb.h
@@ -13,19 +13,11 @@
  *  more details.
  */
 
-#define SMTC_LINUX_FB_VERSION	"version 0.11.2619.21.01 July 27, 2008"
-
 #define NR_PALETTE        256
 #define NR_RGB            2
 
 #define FB_ACCEL_SMI_LYNX 88
 
-#ifdef __BIG_ENDIAN
-#define PC_VGA            0
-#else
-#define PC_VGA            1
-#endif
-
 #define SCREEN_X_RES      1024
 #define SCREEN_Y_RES      600
 #define SCREEN_BPP        16
-- 
1.7.2.5

