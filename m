Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab1CATS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:18:29 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:41161 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757044Ab1CATS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:18:26 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Ondrej Zajicek <santiago@crfreenet.org>
Subject: [PATCH 2/5] s3fb: add support for 86C365 Trio3D
Date: Tue, 1 Mar 2011 20:18:17 +0100
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103012018.19557.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for S3 Trio3D (86C365) cards to s3fb driver. Tested with one 4MB card.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.38-rc4-/drivers/video/s3fb.c	2011-02-20 20:11:18.000000000 +0100
+++ linux-2.6.38-rc4/drivers/video/s3fb.c	2011-02-20 20:31:34.000000000 +0100
@@ -64,6 +64,8 @@ static const struct svga_fb_format s3fb_
 
 static const struct svga_pll s3_pll = {3, 129, 3, 33, 0, 3,
 	35000, 240000, 14318};
+static const struct svga_pll s3_trio3d_pll = {3, 129, 3, 31, 0, 4,
+	230000, 460000, 14318};
 
 static const int s3_memsizes[] = {4096, 0, 3072, 8192, 2048, 6144, 1024, 512};
 
@@ -72,7 +74,8 @@ static const char * const s3_names[] = {
 			"S3 Plato/PX", "S3 Aurora64VP", "S3 Virge",
 			"S3 Virge/VX", "S3 Virge/DX", "S3 Virge/GX",
 			"S3 Virge/GX2", "S3 Virge/GX2P", "S3 Virge/GX2P",
-			"S3 Trio3D/1X", "S3 Trio3D/2X", "S3 Trio3D/2X"};
+			"S3 Trio3D/1X", "S3 Trio3D/2X", "S3 Trio3D/2X",
+			"S3 Trio3D"};
 
 #define CHIP_UNKNOWN		0x00
 #define CHIP_732_TRIO32		0x01
@@ -93,6 +96,7 @@ static const char * const s3_names[] = {
 #define CHIP_360_TRIO3D_1X	0x10
 #define CHIP_362_TRIO3D_2X	0x11
 #define CHIP_368_TRIO3D_2X	0x12
+#define CHIP_365_TRIO3D		0x13
 
 #define CHIP_XXX_TRIO		0x80
 #define CHIP_XXX_TRIO64V2_DXGX	0x81
@@ -341,7 +345,8 @@ static void s3_set_pixclock(struct fb_in
 	u8 regval;
 	int rv;
 
-	rv = svga_compute_pll(&s3_pll, 1000000000 / pixclock, &m, &n, &r, info->node);
+	rv = svga_compute_pll((par->chip == CHIP_365_TRIO3D) ? &s3_trio3d_pll : &s3_pll,
+			      1000000000 / pixclock, &m, &n, &r, info->node);
 	if (rv < 0) {
 		printk(KERN_ERR "fb%d: cannot set requested pixclock, keeping old value\n", info->node);
 		return;
@@ -598,7 +603,8 @@ static int s3fb_set_par(struct fb_info *
 
 	if (par->chip == CHIP_360_TRIO3D_1X ||
 	    par->chip == CHIP_362_TRIO3D_2X ||
-	    par->chip == CHIP_368_TRIO3D_2X) {
+	    par->chip == CHIP_368_TRIO3D_2X ||
+	    par->chip == CHIP_365_TRIO3D) {
 		dbytes = info->var.xres * ((bpp+7)/8);
 		vga_wcrt(par->state.vgabase, 0x91, (dbytes + 7) / 8);
 		vga_wcrt(par->state.vgabase, 0x90, (((dbytes + 7) / 8) >> 8) | 0x80);
@@ -1012,13 +1018,15 @@ static int __devinit s3_pci_probe(struct
 	regval = vga_rcrt(par->state.vgabase, 0x36);
 	if (par->chip == CHIP_360_TRIO3D_1X ||
 	    par->chip == CHIP_362_TRIO3D_2X ||
-	    par->chip == CHIP_368_TRIO3D_2X) {
+	    par->chip == CHIP_368_TRIO3D_2X ||
+	    par->chip == CHIP_365_TRIO3D) {
 		switch ((regval & 0xE0) >> 5) {
 		case 0: /* 8MB -- only 4MB usable for display */
 		case 1: /* 4MB with 32-bit bus */
 		case 2:	/* 4MB */
 			info->screen_size = 4 << 20;
 			break;
+		case 4: /* 2MB on 365 Trio3D */
 		case 6: /* 2MB */
 			info->screen_size = 2 << 20;
 			break;
@@ -1233,6 +1241,7 @@ static struct pci_device_id s3_devices[]
 	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8A11), .driver_data = CHIP_357_VIRGE_GX2P},
 	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8A12), .driver_data = CHIP_359_VIRGE_GX2P},
 	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8A13), .driver_data = CHIP_36X_TRIO3D_1X_2X},
+	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8904), .driver_data = CHIP_365_TRIO3D},
 
 	{0, 0, 0, 0, 0, 0, 0}
 };

-- 
Ondrej Zary
