Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab2GATYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 15:24:13 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:43646 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755830Ab2GATYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 15:24:12 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH] s3fb: Add Virge/MX (86C260)
Date: Sun, 1 Jul 2012 21:23:33 +0200
User-Agent: KMail/1.9.10
Cc: Ondrej Zajicek <santiago@crfreenet.org>, linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201207012123.38236.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Virge/MX (86C260) chip. Although this is a laptop chip,
there's an AGP card with this chip too.

Tested with AGP card, will probably not work correctly with laptops.
DDC does not work on this card (even in DOS or Windows).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/drivers/video/s3fb.c
+++ b/drivers/video/s3fb.c
@@ -84,7 +84,7 @@ static const char * const s3_names[] = {"S3 Unknown", "S3 Trio32", "S3 Trio64",
 			"S3 Virge/VX", "S3 Virge/DX", "S3 Virge/GX",
 			"S3 Virge/GX2", "S3 Virge/GX2+", "",
 			"S3 Trio3D/1X", "S3 Trio3D/2X", "S3 Trio3D/2X",
-			"S3 Trio3D"};
+			"S3 Trio3D", "S3 Virge/MX"};
 
 #define CHIP_UNKNOWN		0x00
 #define CHIP_732_TRIO32		0x01
@@ -105,6 +105,7 @@ static const char * const s3_names[] = {"S3 Unknown", "S3 Trio32", "S3 Trio64",
 #define CHIP_362_TRIO3D_2X	0x11
 #define CHIP_368_TRIO3D_2X	0x12
 #define CHIP_365_TRIO3D		0x13
+#define CHIP_260_VIRGE_MX	0x14
 
 #define CHIP_XXX_TRIO		0x80
 #define CHIP_XXX_TRIO64V2_DXGX	0x81
@@ -280,7 +281,8 @@ static int __devinit s3fb_setup_ddc_bus(struct fb_info *info)
 	 */
 /*	vga_wseq(par->state.vgabase, 0x08, 0x06); - not needed, already unlocked */
 	if (par->chip == CHIP_357_VIRGE_GX2 ||
-	    par->chip == CHIP_359_VIRGE_GX2P)
+	    par->chip == CHIP_359_VIRGE_GX2P ||
+	    par->chip == CHIP_260_VIRGE_MX)
 		svga_wseq_mask(par->state.vgabase, 0x0d, 0x01, 0x03);
 	else
 		svga_wseq_mask(par->state.vgabase, 0x0d, 0x00, 0x03);
@@ -487,7 +489,8 @@ static void s3_set_pixclock(struct fb_info *info, u32 pixclock)
 	    par->chip == CHIP_359_VIRGE_GX2P ||
 	    par->chip == CHIP_360_TRIO3D_1X ||
 	    par->chip == CHIP_362_TRIO3D_2X ||
-	    par->chip == CHIP_368_TRIO3D_2X) {
+	    par->chip == CHIP_368_TRIO3D_2X ||
+	    par->chip == CHIP_260_VIRGE_MX) {
 		vga_wseq(par->state.vgabase, 0x12, (n - 2) | ((r & 3) << 6));	/* n and two bits of r */
 		vga_wseq(par->state.vgabase, 0x29, r >> 2); /* remaining highest bit of r */
 	} else
@@ -690,7 +693,8 @@ static int s3fb_set_par(struct fb_info *info)
 	    par->chip != CHIP_359_VIRGE_GX2P &&
 	    par->chip != CHIP_360_TRIO3D_1X &&
 	    par->chip != CHIP_362_TRIO3D_2X &&
-	    par->chip != CHIP_368_TRIO3D_2X) {
+	    par->chip != CHIP_368_TRIO3D_2X &&
+	    par->chip != CHIP_260_VIRGE_MX) {
 		vga_wcrt(par->state.vgabase, 0x54, 0x18); /* M parameter */
 		vga_wcrt(par->state.vgabase, 0x60, 0xff); /* N parameter */
 		vga_wcrt(par->state.vgabase, 0x61, 0xff); /* L parameter */
@@ -739,7 +743,8 @@ static int s3fb_set_par(struct fb_info *info)
 	    par->chip == CHIP_368_TRIO3D_2X ||
 	    par->chip == CHIP_365_TRIO3D    ||
 	    par->chip == CHIP_375_VIRGE_DX  ||
-	    par->chip == CHIP_385_VIRGE_GX) {
+	    par->chip == CHIP_385_VIRGE_GX  ||
+	    par->chip == CHIP_260_VIRGE_MX) {
 		dbytes = info->var.xres * ((bpp+7)/8);
 		vga_wcrt(par->state.vgabase, 0x91, (dbytes + 7) / 8);
 		vga_wcrt(par->state.vgabase, 0x90, (((dbytes + 7) / 8) >> 8) | 0x80);
@@ -751,7 +756,8 @@ static int s3fb_set_par(struct fb_info *info)
 	    par->chip == CHIP_359_VIRGE_GX2P ||
 	    par->chip == CHIP_360_TRIO3D_1X ||
 	    par->chip == CHIP_362_TRIO3D_2X ||
-	    par->chip == CHIP_368_TRIO3D_2X)
+	    par->chip == CHIP_368_TRIO3D_2X ||
+	    par->chip == CHIP_260_VIRGE_MX)
 		vga_wcrt(par->state.vgabase, 0x34, 0x00);
 	else	/* enable Data Transfer Position Control (DTPC) */
 		vga_wcrt(par->state.vgabase, 0x34, 0x10);
@@ -807,7 +813,8 @@ static int s3fb_set_par(struct fb_info *info)
 		    par->chip == CHIP_359_VIRGE_GX2P ||
 		    par->chip == CHIP_360_TRIO3D_1X ||
 		    par->chip == CHIP_362_TRIO3D_2X ||
-		    par->chip == CHIP_368_TRIO3D_2X)
+		    par->chip == CHIP_368_TRIO3D_2X ||
+		    par->chip == CHIP_260_VIRGE_MX)
 			svga_wcrt_mask(par->state.vgabase, 0x67, 0x00, 0xF0);
 		else {
 			svga_wcrt_mask(par->state.vgabase, 0x67, 0x10, 0xF0);
@@ -837,7 +844,8 @@ static int s3fb_set_par(struct fb_info *info)
 			    par->chip != CHIP_359_VIRGE_GX2P &&
 			    par->chip != CHIP_360_TRIO3D_1X &&
 			    par->chip != CHIP_362_TRIO3D_2X &&
-			    par->chip != CHIP_368_TRIO3D_2X)
+			    par->chip != CHIP_368_TRIO3D_2X &&
+			    par->chip != CHIP_260_VIRGE_MX)
 				hmul = 2;
 		}
 		break;
@@ -864,7 +872,8 @@ static int s3fb_set_par(struct fb_info *info)
 			    par->chip != CHIP_359_VIRGE_GX2P &&
 			    par->chip != CHIP_360_TRIO3D_1X &&
 			    par->chip != CHIP_362_TRIO3D_2X &&
-			    par->chip != CHIP_368_TRIO3D_2X)
+			    par->chip != CHIP_368_TRIO3D_2X &&
+			    par->chip != CHIP_260_VIRGE_MX)
 				hmul = 2;
 		}
 		break;
@@ -1208,7 +1217,8 @@ static int __devinit s3_pci_probe(struct pci_dev *dev, const struct pci_device_i
 			break;
 		}
 	} else if (par->chip == CHIP_357_VIRGE_GX2 ||
-		   par->chip == CHIP_359_VIRGE_GX2P) {
+		   par->chip == CHIP_359_VIRGE_GX2P ||
+		   par->chip == CHIP_260_VIRGE_MX) {
 		switch ((regval & 0xC0) >> 6) {
 		case 1: /* 4MB */
 			info->screen_size = 4 << 20;
@@ -1515,6 +1525,7 @@ static struct pci_device_id s3_devices[] __devinitdata = {
 	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8A12), .driver_data = CHIP_359_VIRGE_GX2P},
 	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8A13), .driver_data = CHIP_36X_TRIO3D_1X_2X},
 	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8904), .driver_data = CHIP_365_TRIO3D},
+	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8C01), .driver_data = CHIP_260_VIRGE_MX},
 
 	{0, 0, 0, 0, 0, 0, 0}
 };

-- 
Ondrej Zary
