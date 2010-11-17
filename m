Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179Ab0KQKBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 05:01:31 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47380 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab0KQKB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 05:01:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=u/WjHUBdFPTQ3NeaEtolAWtWvJy9d4W+1x442EA3T7EGybYOpi2T0EiPPamJQMscVv
         but0w43JecdsWmqXPgadtviNawdMR39sK11SEcX/atUNXMjPLaCxeCLjnf5AbchV1bcl
         15F5Ly2iDndjsca6ZUJSmhTRfQ0MvW/XZY/U8=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, lethal@linux-sh.org,
        g.liakhovetski@gmx.de, linux-sh@vger.kernel.org
Date: Wed, 17 Nov 2010 18:53:25 +0900
Message-Id: <20101117095325.11039.18878.sendpatchset@t400s>
Subject: [PATCH] fbdev: sh_mipi_dsi: Require two I/O resources V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This is V2 of the MIPI-DSI two resources patch.

The second I/O resource specifies the base address
for the link hardware block. The base address for
the link hardware block seems to vary with SoC
type. Using two I/O resources to describe the
MIPI-DSI hardware allows us to support both newer
and older SoCs.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Changes since V1:
 - Do not depend on [PATCH 01/05] and use request_mem_region().

 drivers/video/sh_mipi_dsi.c |   55 ++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 16 deletions(-)

--- 0005/drivers/video/sh_mipi_dsi.c
+++ work/drivers/video/sh_mipi_dsi.c	2010-11-17 18:36:10.000000000 +0900
@@ -34,19 +34,20 @@
 #define DSIINTE		0x0060
 #define PHYCTRL		0x0070
 
-#define DTCTR		0x8000
-#define VMCTR1		0x8020
-#define VMCTR2		0x8024
-#define VMLEN1		0x8028
-#define CMTSRTREQ	0x8070
-#define CMTSRTCTR	0x80d0
-
+/* relative to linkbase */
+#define DTCTR		0x0000
+#define VMCTR1		0x0020
+#define VMCTR2		0x0024
+#define VMLEN1		0x0028
+#define CMTSRTREQ	0x0070
+#define CMTSRTCTR	0x00d0
 
 /* E.g., sh7372 has 2 MIPI-DSIs - one for each LCDC */
 #define MAX_SH_MIPI_DSI 2
 
 struct sh_mipi {
 	void __iomem	*base;
+	void __iomem	*linkbase;
 	struct clk	*dsit_clk;
 	struct clk	*dsip_clk;
 };
@@ -71,10 +72,10 @@ static int sh_mipi_send_short(struct sh_
 	int cnt = 100;
 
 	/* transmit a short packet to LCD panel */
-	iowrite32(1 | data, mipi->base + CMTSRTCTR);
-	iowrite32(1, mipi->base + CMTSRTREQ);
+	iowrite32(1 | data, mipi->linkbase + CMTSRTCTR);
+	iowrite32(1, mipi->linkbase + CMTSRTREQ);
 
-	while ((ioread32(mipi->base + CMTSRTREQ) & 1) && --cnt)
+	while ((ioread32(mipi->linkbase + CMTSRTREQ) & 1) && --cnt)
 		udelay(1);
 
 	return cnt ? 0 : -ETIMEDOUT;
@@ -106,7 +107,7 @@ static void sh_mipi_dsi_enable(struct sh
 	 * enable LCDC data tx, transition to LPS after completion of each HS
 	 * packet
 	 */
-	iowrite32(0x00000002 | enable, mipi->base + DTCTR);
+	iowrite32(0x00000002 | enable, mipi->linkbase + DTCTR);
 }
 
 static void sh_mipi_shutdown(struct platform_device *pdev)
@@ -291,20 +292,21 @@ static int __init sh_mipi_setup(struct s
 	 * Enable transmission of all packets,
 	 * transmit LPS after each HS packet completion
 	 */
-	iowrite32(0x00000006, base + DTCTR);
+	iowrite32(0x00000006, mipi->linkbase + DTCTR);
 	/* VSYNC width = 2 (<< 17) */
-	iowrite32(0x00040000 | (pctype << 12) | datatype, base + VMCTR1);
+	iowrite32(0x00040000 | (pctype << 12) | datatype,
+		  mipi->linkbase + VMCTR1);
 	/*
 	 * Non-burst mode with sync pulses: VSE and HSE are output,
 	 * HSA period allowed, no commands in LP
 	 */
-	iowrite32(0x00e00000, base + VMCTR2);
+	iowrite32(0x00e00000, mipi->linkbase + VMCTR2);
 	/*
 	 * 0x660 = 1632 bytes per line (RGB24, 544 pixels: see
 	 * sh_mobile_lcdc_info.ch[0].lcd_cfg[0].xres), HSALEN = 1 - default
 	 * (unused, since VMCTR2[HSABM] = 0)
 	 */
-	iowrite32(1 | (linelength << 16), base + VMLEN1);
+	iowrite32(1 | (linelength << 16), mipi->linkbase + VMLEN1);
 
 	msleep(5);
 
@@ -337,11 +339,12 @@ static int __init sh_mipi_probe(struct p
 	struct sh_mipi *mipi;
 	struct sh_mipi_dsi_info *pdata = pdev->dev.platform_data;
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	struct resource *res2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	unsigned long rate, f_current;
 	int idx = pdev->id, ret;
 	char dsip_clk[] = "dsi.p_clk";
 
-	if (!res || idx >= ARRAY_SIZE(mipi_dsi) || !pdata)
+	if (!res || !res2 || idx >= ARRAY_SIZE(mipi_dsi) || !pdata)
 		return -ENODEV;
 
 	mutex_lock(&array_lock);
@@ -372,6 +375,18 @@ static int __init sh_mipi_probe(struct p
 		goto emap;
 	}
 
+	if (!request_mem_region(res2->start, resource_size(res2), pdev->name)) {
+		dev_err(&pdev->dev, "MIPI register region 2 already claimed\n");
+		ret = -EBUSY;
+		goto ereqreg2;
+	}
+
+	mipi->linkbase = ioremap(res2->start, resource_size(res2));
+	if (!mipi->linkbase) {
+		ret = -ENOMEM;
+		goto emap2;
+	}
+
 	mipi->dsit_clk = clk_get(&pdev->dev, "dsit_clk");
 	if (IS_ERR(mipi->dsit_clk)) {
 		ret = PTR_ERR(mipi->dsit_clk);
@@ -447,6 +462,10 @@ eclkpget:
 esettrate:
 	clk_put(mipi->dsit_clk);
 eclktget:
+	iounmap(mipi->linkbase);
+emap2:
+	release_mem_region(res2->start, resource_size(res2));
+ereqreg2:
 	iounmap(mipi->base);
 emap:
 	release_mem_region(res->start, resource_size(res));
@@ -463,6 +482,7 @@ static int __exit sh_mipi_remove(struct 
 {
 	struct sh_mipi_dsi_info *pdata = pdev->dev.platform_data;
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	struct resource *res2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	struct sh_mipi *mipi = platform_get_drvdata(pdev);
 	int i, ret;
 
@@ -491,6 +511,9 @@ static int __exit sh_mipi_remove(struct 
 	clk_disable(mipi->dsit_clk);
 	clk_put(mipi->dsit_clk);
 	clk_put(mipi->dsip_clk);
+	iounmap(mipi->linkbase);
+	if (res2)
+		release_mem_region(res2->start, resource_size(res2));
 	iounmap(mipi->base);
 	if (res)
 		release_mem_region(res->start, resource_size(res));
