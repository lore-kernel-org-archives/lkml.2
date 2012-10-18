Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab2JRO3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:29:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42206 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab2JRO1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:27:43 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        kernel@pengutronix.de, devicetree-discuss@lists.ozlabs.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v5 4/4] misc: sram: add support for configurable allocation order
Date: Thu, 18 Oct 2012 16:27:33 +0200
Message-Id: <1350570453-24546-5-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350570453-24546-1-git-send-email-p.zabel@pengutronix.de>
References: <1350570453-24546-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Porter <mporter@ti.com>

Adds support for setting the genalloc pool's minimum allocation
order via DT or platform data. The allocation order is optional
for both the DT property and platform data case. If it is not
present then the order defaults to PAGE_SHIFT to preserve the
current behavior.

Signed-off-by: Matt Porter <mporter@ti.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 Documentation/devicetree/bindings/misc/sram.txt |   12 ++++++++++-
 drivers/misc/sram.c                             |   14 ++++++++++++-
 include/linux/platform_data/sram.h              |   25 +++++++++++++++++++++++
 3 files changed, 49 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/platform_data/sram.h

diff --git a/Documentation/devicetree/bindings/misc/sram.txt b/Documentation/devicetree/bindings/misc/sram.txt
index b64136c..b1705ec 100644
--- a/Documentation/devicetree/bindings/misc/sram.txt
+++ b/Documentation/devicetree/bindings/misc/sram.txt
@@ -8,10 +8,20 @@ Required properties:
 
 - reg : SRAM iomem address range
 
-Example:
+Optional properties:
+
+- alloc-order : Minimum allocation order for the SRAM pool
+
+Examples:
+
+sram: sram@5c000000 {
+	compatible = "sram";
+	reg = <0x5c000000 0x40000>; /* 256 KiB SRAM at address 0x5c000000 */
+};
 
 sram: sram@5c000000 {
 	compatible = "sram";
 	reg = <0x5c000000 0x40000>; /* 256 KiB SRAM at address 0x5c000000 */
+	alloc-order = <9>; /* Minimum 512 byte allocation */
 };
 
diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
index 0cc2e75..3a04b77 100644
--- a/drivers/misc/sram.c
+++ b/drivers/misc/sram.c
@@ -28,6 +28,7 @@
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
 #include <linux/genalloc.h>
+#include <linux/platform_data/sram.h>
 
 struct sram_dev {
 	struct gen_pool *pool;
@@ -40,6 +41,7 @@ static int __devinit sram_probe(struct platform_device *pdev)
 	struct sram_dev *sram;
 	struct resource *res;
 	unsigned long size;
+	u32 alloc_order = PAGE_SHIFT;
 	int ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -60,7 +62,17 @@ static int __devinit sram_probe(struct platform_device *pdev)
 	if (!IS_ERR(sram->clk))
 		clk_prepare_enable(sram->clk);
 
-	sram->pool = gen_pool_create(PAGE_SHIFT, -1);
+	if (pdev->dev.of_node)
+		of_property_read_u32(pdev->dev.of_node,
+				     "alloc-order", &alloc_order);
+	else
+		if (pdev->dev.platform_data) {
+			struct sram_pdata *pdata = pdev->dev.platform_data;
+			if (pdata->alloc_order)
+				alloc_order = pdata->alloc_order;
+		}
+
+	sram->pool = gen_pool_create(alloc_order, -1);
 	if (!sram->pool)
 		return -ENOMEM;
 
diff --git a/include/linux/platform_data/sram.h b/include/linux/platform_data/sram.h
new file mode 100644
index 0000000..e17bdaa
--- /dev/null
+++ b/include/linux/platform_data/sram.h
@@ -0,0 +1,25 @@
+/*
+ * include/linux/platform_data/sram.h
+ *
+ * Platform data for generic sram driver
+ *
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _SRAM_H_
+#define _SRAM_H_
+
+struct sram_pdata {
+	unsigned alloc_order;	/* Optional: driver defaults to PAGE_SHIFT */
+};
+
+#endif /* _SRAM_H_ */
-- 
1.7.10.4

