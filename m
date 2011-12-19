Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab1LSWkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:40:52 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:52265 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab1LSWkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:40:49 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH] s3fb: fix Virge/VX
Date: Mon, 19 Dec 2011 23:39:47 +0100
User-Agent: KMail/1.9.10
Cc: Paul Mundt <lethal@linux-sh.org>, Ondrej Zajicek <santiago@crfreenet.org>,
        linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201112192339.52676.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add memory size detection for Virge/VX and small delay in mode setting (same
as in X.org driver) to fix blank screen problem.

Also adjust DTPC position to fix garbled screen in some modes (tested that
this adjustment does not break other cards - at least Trio32, Trio64V+,
Trio64V2/DX, Virge, Virge/DX).

Tested on ELSA Winner 2000AVI/3D.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-3.1-orig/drivers/video/s3fb.c	2011-10-24 09:10:05.000000000 +0200
+++ linux-3.1/drivers/video/s3fb.c	2011-12-19 23:28:34.000000000 +0100
@@ -727,7 +727,7 @@
 	if (par->chip == CHIP_988_VIRGE_VX) {
 		vga_wcrt(par->state.vgabase, 0x50, 0x00);
 		vga_wcrt(par->state.vgabase, 0x67, 0x50);
-
+		msleep(10); /* screen remains blank sometimes without this */
 		vga_wcrt(par->state.vgabase, 0x63, (mode <= 2) ? 0x90 : 0x09);
 		vga_wcrt(par->state.vgabase, 0x66, 0x90);
 	}
@@ -901,7 +901,8 @@
 
 	/* Set Data Transfer Position */
 	hsstart = ((info->var.xres + info->var.right_margin) * hmul) / 8;
-	value = clamp((htotal + hsstart + 1) / 2, hsstart + 4, htotal + 1);
+	/* + 2 is needed for Virge/VX, does no harm on other cards */
+	value = clamp((htotal + hsstart + 1) / 2 + 2, hsstart + 4, htotal + 1);
 	svga_wcrt_multi(par->state.vgabase, s3_dtpc_regs, value);
 
 	memset_io(info->screen_base, 0x00, screen_size);
@@ -1215,6 +1216,31 @@
 			info->screen_size = 2 << 20;
 			break;
 		}
+	} else if (par->chip == CHIP_988_VIRGE_VX) {
+		switch ((regval & 0x60) >> 5) {
+		case 0: /* 2MB */
+			info->screen_size = 2 << 20;
+			break;
+		case 1: /* 4MB */
+			info->screen_size = 4 << 20;
+			break;
+		case 2: /* 6MB */
+			info->screen_size = 6 << 20;
+			break;
+		case 3: /* 8MB */
+			info->screen_size = 8 << 20;
+			break;
+		}
+		/* off-screen memory */
+		regval = vga_rcrt(par->state.vgabase, 0x37);
+		switch ((regval & 0x60) >> 5) {
+		case 1: /* 4MB */
+			info->screen_size -= 4 << 20;
+			break;
+		case 2: /* 2MB */
+			info->screen_size -= 2 << 20;
+			break;
+		}
 	} else
 		info->screen_size = s3_memsizes[regval >> 5] << 10;
 	info->fix.smem_len = info->screen_size;


-- 
Ondrej Zary
