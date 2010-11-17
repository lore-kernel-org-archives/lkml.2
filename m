Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934524Ab0KQGle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:41:34 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39401 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934511Ab0KQGld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:41:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=HPOLTY2dfpRnMpQAaRiKOgXoIHJYYAsOKpOsyOtm5n1HRBaD2YrrZPlnCpKonWzWnU
         p7HR0r73zI18wfdYt19ZCprFyogDXg74p/IEuYoLRoZX8ken3ITj01NygLx3zOx1BUG/
         +gGF6vM6YvnopYhmCBy+rvtv8HdjFRf4PuGfY=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, lethal@linux-sh.org,
        g.liakhovetski@gmx.de, linux-sh@vger.kernel.org
Date: Wed, 17 Nov 2010 15:44:25 +0900
Message-Id: <20101117064425.18139.44448.sendpatchset@t400s>
In-Reply-To: <20101117064405.18139.57035.sendpatchset@t400s>
References: <20101117064405.18139.57035.sendpatchset@t400s>
Subject: [PATCH 02/05] fbdev: sh_mipi_dsi: Make use of register names
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Keep MIPI-DSI registers in one place instead of
using magic values together with comments.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/video/sh_mipi_dsi.c |   62 +++++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 23 deletions(-)

--- 0005/drivers/video/sh_mipi_dsi.c
+++ work/drivers/video/sh_mipi_dsi.c	2010-11-16 16:48:37.000000000 +0900
@@ -21,10 +21,26 @@
 #include <video/sh_mipi_dsi.h>
 #include <video/sh_mobile_lcdc.h>
 
-#define CMTSRTCTR	0x80d0
+#define SYSCTRL		0x0000
+#define SYSCONF		0x0004
+#define TIMSET		0x0008
+#define RESREQSET0	0x0018
+#define RESREQSET1	0x001c
+#define HSTTOVSET	0x0020
+#define LPRTOVSET	0x0024
+#define TATOVSET	0x0028
+#define PRTOVSET	0x002c
+#define DSICTRL		0x0030
+#define DSIINTE		0x0060
+#define PHYCTRL		0x0070
+
+#define DTCTR		0x8000
+#define VMCTR1		0x8020
+#define VMCTR2		0x8024
+#define VMLEN1		0x8028
 #define CMTSRTREQ	0x8070
+#define CMTSRTCTR	0x80d0
 
-#define DSIINTE		0x0060
 
 /* E.g., sh7372 has 2 MIPI-DSIs - one for each LCDC */
 #define MAX_SH_MIPI_DSI 2
@@ -55,10 +71,10 @@ static int sh_mipi_send_short(struct sh_
 	int cnt = 100;
 
 	/* transmit a short packet to LCD panel */
-	iowrite32(1 | data, mipi->base + 0x80d0); /* CMTSRTCTR */
-	iowrite32(1, mipi->base + 0x8070); /* CMTSRTREQ */
+	iowrite32(1 | data, mipi->base + CMTSRTCTR);
+	iowrite32(1, mipi->base + CMTSRTREQ);
 
-	while ((ioread32(mipi->base + 0x8070) & 1) && --cnt)
+	while ((ioread32(mipi->base + CMTSRTREQ) & 1) && --cnt)
 		udelay(1);
 
 	return cnt ? 0 : -ETIMEDOUT;
@@ -90,7 +106,7 @@ static void sh_mipi_dsi_enable(struct sh
 	 * enable LCDC data tx, transition to LPS after completion of each HS
 	 * packet
 	 */
-	iowrite32(0x00000002 | enable, mipi->base + 0x8000); /* DTCTR */
+	iowrite32(0x00000002 | enable, mipi->base + DTCTR);
 }
 
 static void sh_mipi_shutdown(struct platform_device *pdev)
@@ -223,10 +239,10 @@ static int __init sh_mipi_setup(struct s
 		return -EINVAL;
 
 	/* reset DSI link */
-	iowrite32(0x00000001, base); /* SYSCTRL */
+	iowrite32(0x00000001, base + SYSCTRL);
 	/* Hold reset for 100 cycles of the slowest of bus, HS byte and LP clock */
 	udelay(50);
-	iowrite32(0x00000000, base); /* SYSCTRL */
+	iowrite32(0x00000000, base + SYSCTRL);
 
 	/* setup DSI link */
 
@@ -238,7 +254,7 @@ static int __init sh_mipi_setup(struct s
 	 *	ECC check enable
 	 * additionally enable first two lanes
 	 */
-	iowrite32(0x00003703, base + 0x04); /* SYSCONF */
+	iowrite32(0x00003703, base + SYSCONF);
 	/*
 	 * T_wakeup = 0x7000
 	 * T_hs-trail = 3
@@ -246,28 +262,28 @@ static int __init sh_mipi_setup(struct s
 	 * T_clk-trail = 3
 	 * T_clk-prepare = 2
 	 */
-	iowrite32(0x70003332, base + 0x08); /* TIMSET */
+	iowrite32(0x70003332, base + TIMSET);
 	/* no responses requested */
-	iowrite32(0x00000000, base + 0x18); /* RESREQSET0 */
+	iowrite32(0x00000000, base + RESREQSET0);
 	/* request response to packets of type 0x28 */
-	iowrite32(0x00000100, base + 0x1c); /* RESREQSET1 */
+	iowrite32(0x00000100, base + RESREQSET1);
 	/* High-speed transmission timeout, default 0xffffffff */
-	iowrite32(0x0fffffff, base + 0x20); /* HSTTOVSET */
+	iowrite32(0x0fffffff, base + HSTTOVSET);
 	/* LP reception timeout, default 0xffffffff */
-	iowrite32(0x0fffffff, base + 0x24); /* LPRTOVSET */
+	iowrite32(0x0fffffff, base + LPRTOVSET);
 	/* Turn-around timeout, default 0xffffffff */
-	iowrite32(0x0fffffff, base + 0x28); /* TATOVSET */
+	iowrite32(0x0fffffff, base + TATOVSET);
 	/* Peripheral reset timeout, default 0xffffffff */
-	iowrite32(0x0fffffff, base + 0x2c); /* PRTOVSET */
+	iowrite32(0x0fffffff, base + PRTOVSET);
 	/* Enable timeout counters */
-	iowrite32(0x00000f00, base + 0x30); /* DSICTRL */
+	iowrite32(0x00000f00, base + DSICTRL);
 	/* Interrupts not used, disable all */
 	iowrite32(0, base + DSIINTE);
 	/* DSI-Tx bias on */
-	iowrite32(0x00000001, base + 0x70); /* PHYCTRL */
+	iowrite32(0x00000001, base + PHYCTRL);
 	udelay(200);
 	/* Deassert resets, power on, set multiplier */
-	iowrite32(0x03070b01, base + 0x70); /* PHYCTRL */
+	iowrite32(0x03070b01, base + PHYCTRL);
 
 	/* setup l-bridge */
 
@@ -275,20 +291,20 @@ static int __init sh_mipi_setup(struct s
 	 * Enable transmission of all packets,
 	 * transmit LPS after each HS packet completion
 	 */
-	iowrite32(0x00000006, base + 0x8000); /* DTCTR */
+	iowrite32(0x00000006, base + DTCTR);
 	/* VSYNC width = 2 (<< 17) */
-	iowrite32(0x00040000 | (pctype << 12) | datatype, base + 0x8020); /* VMCTR1 */
+	iowrite32(0x00040000 | (pctype << 12) | datatype, base + VMCTR1);
 	/*
 	 * Non-burst mode with sync pulses: VSE and HSE are output,
 	 * HSA period allowed, no commands in LP
 	 */
-	iowrite32(0x00e00000, base + 0x8024); /* VMCTR2 */
+	iowrite32(0x00e00000, base + VMCTR2);
 	/*
 	 * 0x660 = 1632 bytes per line (RGB24, 544 pixels: see
 	 * sh_mobile_lcdc_info.ch[0].lcd_cfg[0].xres), HSALEN = 1 - default
 	 * (unused, since VMCTR2[HSABM] = 0)
 	 */
-	iowrite32(1 | (linelength << 16), base + 0x8028); /* VMLEN1 */
+	iowrite32(1 | (linelength << 16), base + VMLEN1);
 
 	msleep(5);
 
