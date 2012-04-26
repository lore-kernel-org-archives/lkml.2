Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab2DZSqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:46:10 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:41316 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab2DZSqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:46:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAE+XmU9bdWOb/2dsb2JhbABFsXCBB4IKAQUnUhBRPBsHEogRuniQZQSVfYlYhmiCag
X-IronPort-AV: E=Sophos;i="4.75,487,1330902000"; 
   d="scan'208";a="981960576"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com,
        boyod.yang@siliconmotion.com.cn, wuzhangjin@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH RESEND 5/7] staging: sm7xx: merge hardware information in smtcfb_info struct
Date: Thu, 26 Apr 2012 20:45:53 +0200
Message-Id: <1335465955-32057-6-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20120425205532.GA9642@kroah.com>
References: <20120425205532.GA9642@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch smtcfb_info becomes the main structure to reach/handle
state. fb_info struct links this struct via its private data field.

This change improves encapsulation in functions. It reduces the number
of arguments used in signatures too.

Tested with SM712

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xx/smtcfb.c |  128 +++++++++++++++++----------------------
 1 files changed, 56 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index e351e08..5defdaf 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -40,21 +40,12 @@ struct screen_info smtc_screen_info;
 */
 struct smtcfb_info {
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
@@ -97,7 +88,6 @@ char __iomem *smtc_RegBaseAddress;	/* Memory Map IO starting address */
 char __iomem *smtc_VRAMBaseAddress;	/* video memory starting address */
 
 static u32 colreg[17];
-static struct par_info hw;	/* hardware information */
 
 static struct fb_var_screeninfo smtcfb_var = {
 	.xres           = 1024,
@@ -122,32 +112,29 @@ static struct fb_fix_screeninfo smtcfb_fix = {
 	.accel          = FB_ACCEL_SMI_LYNX,
 };
 
-static void sm712_set_timing(struct smtcfb_info *sfb,
-			     struct par_info *ppar_info)
+static void sm712_set_timing(struct smtcfb_info *sfb)
 {
 	int i = 0, j = 0;
 	u32 m_nScreenStride;
 
-	dev_dbg(&sfb->dev->dev,
-	       "ppar_info->width=%d ppar_info->height=%d"
-			"sfb->fb.var.bits_per_pixel=%d ppar_info->hz=%d\n",
-			ppar_info->width, ppar_info->height,
-			sfb->fb.var.bits_per_pixel, ppar_info->hz);
+	dev_dbg(&sfb->pdev->dev,
+		"sfb->width=%d sfb->height=%d "
+		"sfb->fb.var.bits_per_pixel=%d sfb->hz=%d\n",
+		sfb->width, sfb->height, sfb->fb.var.bits_per_pixel, sfb->hz);
 
 	for (j = 0; j < numVGAModes; j++) {
-		if (VGAMode[j].mmSizeX == ppar_info->width &&
-		    VGAMode[j].mmSizeY == ppar_info->height &&
+		if (VGAMode[j].mmSizeX == sfb->width &&
+		    VGAMode[j].mmSizeY == sfb->height &&
 		    VGAMode[j].bpp == sfb->fb.var.bits_per_pixel &&
-		    VGAMode[j].hz == ppar_info->hz) {
+		    VGAMode[j].hz == sfb->hz) {
 
-			dev_dbg(&sfb->dev->dev,
-				"VGAMode[j].mmSizeX=%d VGAMode[j].mmSizeY=%d"
+			dev_dbg(&sfb->pdev->dev,
+				"VGAMode[j].mmSizeX=%d VGAMode[j].mmSizeY=%d "
 				"VGAMode[j].bpp=%d VGAMode[j].hz=%d\n",
 				VGAMode[j].mmSizeX, VGAMode[j].mmSizeY,
 				VGAMode[j].bpp, VGAMode[j].hz);
 
-			dev_dbg(&sfb->dev->dev,
-				"VGAMode index=%d\n", j);
+			dev_dbg(&sfb->pdev->dev, "VGAMode index=%d\n", j);
 
 			smtc_mmiowb(0x0, 0x3c6);
 
@@ -208,37 +195,37 @@ static void sm712_set_timing(struct smtcfb_info *sfb,
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
 	writel((u32) (((m_nScreenStride + 2) << 16) | m_nScreenStride),
-	       ppar_info->m_pVPR + 0x10);
+	       sfb->m_pVPR + 0x10);
 
 }
 
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
@@ -253,14 +240,13 @@ static void sm712_setpalette(int regno, unsigned red, unsigned green,
 	smtc_mmiowb(blue >> 10, dac_val);
 }
 
-static void smtc_set_timing(struct smtcfb_info *sfb, struct par_info
-		*ppar_info)
+static void smtc_set_timing(struct smtcfb_info *sfb)
 {
-	switch (ppar_info->chipID) {
+	switch (sfb->chipID) {
 	case 0x710:
 	case 0x712:
 	case 0x720:
-		sm712_set_timing(sfb, ppar_info);
+		sm712_set_timing(sfb);
 		break;
 	}
 }
@@ -630,10 +616,10 @@ void smtcfb_setmode(struct smtcfb_info *sfb)
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
@@ -680,8 +666,7 @@ static struct fb_ops smtcfb_ops = {
 /*
  * Alloc struct smtcfb_info and assign the default value
  */
-static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *dev,
-							char *name)
+static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *pdev, char *name)
 {
 	struct smtcfb_info *sfb;
 
@@ -690,8 +675,7 @@ static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *dev,
 	if (!sfb)
 		return NULL;
 
-	sfb->currcon = -1;
-	sfb->dev = dev;
+	sfb->pdev = pdev;
 
 	/*** Init sfb->fb with default value ***/
 	sfb->fb.flags = FBINFO_FLAG_DEFAULT;
@@ -715,7 +699,9 @@ static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *dev,
 	/* text mode acceleration */
 	sfb->fb.var.accel_flags = FB_ACCELF_TEXT;
 	sfb->fb.var.vmode = FB_VMODE_NONINTERLACED;
-	sfb->fb.par = &hw;
+
+	sfb->fb.par = sfb;
+
 	sfb->fb.pseudo_palette = colreg;
 
 	return sfb;
@@ -842,14 +828,14 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	if (err)
 		return err;
 
-	hw.chipID = ent->device;
-	sprintf(name, "sm%Xfb", hw.chipID);
-
 	sfb = smtc_alloc_fb_info(pdev, name);
 
 	if (!sfb)
 		goto failed_free;
 
+	sfb->chipID = ent->device;
+	sprintf(name, "sm%Xfb", sfb->chipID);
+
 	pci_set_drvdata(pdev, sfb);
 
 	sm7xx_init_hw();
@@ -872,29 +858,29 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 #endif
 	/* Map address and memory detection */
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
+			sfb->m_pLFB += 0x800000;
 			dev_info(&pdev->dev,
 				 "smtc_VRAMBaseAddress=%p sfb->m_pLFB=%p",
 				  smtc_VRAMBaseAddress, sfb->m_pLFB);
@@ -924,12 +910,12 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
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
@@ -954,18 +940,16 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 
 	smtcfb_setmode(sfb);
 	/* Primary display starting from 0 position */
-	hw.BaseAddressInVRAM = 0;
-	sfb->fb.par = &hw;
+	sfb->BaseAddressInVRAM = 0;
 
 	err = register_framebuffer(&sfb->fb);
 	if (err < 0)
 		goto failed;
 
 	dev_info(&pdev->dev,
-		"Silicon Motion SM%X Rev%X primary display mode"
-		"%dx%d-%d Init Complete.\n", hw.chipID, hw.chipRevID,
-		sfb->fb.var.xres, sfb->fb.var.yres,
-		sfb->fb.var.bits_per_pixel);
+		 "Silicon Motion SM%X Rev%X primary display mode %dx%d-%d Init Complete.",
+		 sfb->chipID, sfb->chipRevID, sfb->fb.var.xres,
+		 sfb->fb.var.yres, sfb->fb.var.bits_per_pixel);
 
 	return 0;
 
@@ -1037,7 +1021,7 @@ static int smtcfb_pci_resume(struct device *device)
 
 	/* reinit hardware */
 	sm7xx_init_hw();
-	switch (hw.chipID) {
+	switch (sfb->chipID) {
 	case 0x710:
 	case 0x712:
 		/* set MCLK = 14.31818 *  (0x16 / 0x2) */
-- 
1.7.2.5

