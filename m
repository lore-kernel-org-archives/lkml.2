Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934493Ab0KQGly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:41:54 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57973 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933297Ab0KQGlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:41:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dtWgiQCtdQiin+e+A/gf9bOOADh/zz4TsGV5LWlmZKhWncqRr5tdWzQ6mRsiNDlARB
         qkzc3RQnIA/fqV2FvQpRq1Kp0eYp/vdnj4cK7zvftvtHrs5sjRAwI35cVWBoy/iUDfZV
         4CP6mlB/oDMITpauljNqMEvDa7EUszvS9g6v8=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, lethal@linux-sh.org,
        g.liakhovetski@gmx.de, linux-sh@vger.kernel.org
Date: Wed, 17 Nov 2010 15:44:44 +0900
Message-Id: <20101117064444.18139.93049.sendpatchset@t400s>
In-Reply-To: <20101117064405.18139.57035.sendpatchset@t400s>
References: <20101117064405.18139.57035.sendpatchset@t400s>
Subject: [PATCH 04/05] fbdev: sh_mipi_dsi: Require two I/O resources
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch updates the MIPI-DSI driver to use a
second I/O resource to specify the base address
for the link hardware block. The base address for
the link hardware block seems to vary with SoC
type. Using two I/O resources to describe the
MIPI-DSI hardware allows us to support both newer
and older SoCs.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/video/sh_mipi_dsi.c |   44 +++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

--- 0006/drivers/video/sh_mipi_dsi.c
+++ work/drivers/video/sh_mipi_dsi.c	2010-11-16 17:30:10.000000000 +0900
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
@@ -366,6 +369,12 @@ static int __init sh_mipi_probe(struct p
 		goto emap;
 	}
 
+	mipi->linkbase = ioremap(res2->start, resource_size(res2));
+	if (!mipi->linkbase) {
+		ret = -ENOMEM;
+		goto emap2;
+	}
+
 	mipi->dsit_clk = clk_get(&pdev->dev, "dsit_clk");
 	if (IS_ERR(mipi->dsit_clk)) {
 		ret = PTR_ERR(mipi->dsit_clk);
@@ -441,6 +450,8 @@ eclkpget:
 esettrate:
 	clk_put(mipi->dsit_clk);
 eclktget:
+	iounmap(mipi->linkbase);
+emap2:
 	iounmap(mipi->base);
 emap:
 	kfree(mipi);
@@ -483,6 +494,7 @@ static int __exit sh_mipi_remove(struct 
 	clk_disable(mipi->dsit_clk);
 	clk_put(mipi->dsit_clk);
 	clk_put(mipi->dsip_clk);
+	iounmap(mipi->linkbase);
 	iounmap(mipi->base);
 	platform_set_drvdata(pdev, NULL);
 	kfree(mipi);
