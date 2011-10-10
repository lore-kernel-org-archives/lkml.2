Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab1JJQiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:38:13 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:4010 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab1JJQiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:38:08 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org,
        robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/4] dmaengine: at_hdmac: add device tree support
Date: Mon, 10 Oct 2011 18:37:50 +0200
Message-Id: <3780f07b118f8b6a31ed6a27a81312bfff7356f9.1318264339.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <9723283e7097730f568bf7c2f3a93ae42c6bc5ca.1318264339.git.nicolas.ferre@atmel.com>
References: <1314075338.22120.3.camel@vkoul-udesk3>
 <9723283e7097730f568bf7c2f3a93ae42c6bc5ca.1318264339.git.nicolas.ferre@atmel.com>
In-Reply-To: <9723283e7097730f568bf7c2f3a93ae42c6bc5ca.1318264339.git.nicolas.ferre@atmel.com>
References: <9723283e7097730f568bf7c2f3a93ae42c6bc5ca.1318264339.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree probe support for atmel at_hdmac DMA driver.
Bindings are added to specify DMA controller configuration.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 .../devicetree/bindings/dma/atmel-dma.txt          |   14 +++++++++
 drivers/dma/at_hdmac.c                             |   30 +++++++++++++++++++-
 2 files changed, 43 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/atmel-dma.txt

diff --git a/Documentation/devicetree/bindings/dma/atmel-dma.txt b/Documentation/devicetree/bindings/dma/atmel-dma.txt
new file mode 100644
index 0000000..3c046ee
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/atmel-dma.txt
@@ -0,0 +1,14 @@
+* Atmel Direct Memory Access Controller (DMA)
+
+Required properties:
+- compatible: Should be "atmel,<chip>-dma"
+- reg: Should contain DMA registers location and length
+- interrupts: Should contain DMA interrupt
+
+Examples:
+
+dma@ffffec00 {
+	compatible = "atmel,at91sam9g45-dma";
+	reg = <0xffffec00 0x200>;
+	interrupts = <21>;
+};
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index fef57bc..6d25b6a 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -23,6 +23,8 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #include "at_hdmac_regs.h"
 
@@ -1175,6 +1177,20 @@ static void atc_free_chan_resources(struct dma_chan *chan)
 
 /*--  Module Management  -----------------------------------------------*/
 
+#if defined(CONFIG_OF)
+static const struct of_device_id atmel_dma_dt_ids[] = {
+	{
+		.compatible = "atmel,at91sam9rl-dma",
+		.data = (void *)ATDMA_DEVTYPE_SAM9RL
+	}, {
+		.compatible = "atmel,at91sam9g45-dma",
+		.data = (void *)ATDMA_DEVTYPE_SAM9G45
+	}, { /* sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, atmel_dma_dt_ids);
+#endif
+
 static struct platform_device_id atdma_devtypes[] = {
 	{
 		.name = "at91sam9rl_dma",
@@ -1187,6 +1203,17 @@ static struct platform_device_id atdma_devtypes[] = {
 	}
 };
 
+static inline enum atdma_devtype __init at_dma_get_driver_data(
+					struct platform_device *pdev)
+{
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(atmel_dma_dt_ids, pdev->dev.of_node);
+		return (enum atdma_devtype)match->data;
+	}
+	return platform_get_device_id(pdev)->driver_data;
+}
+
 /**
  * at_dma_off - disable DMA controller
  * @atdma: the Atmel HDAMC device
@@ -1218,7 +1245,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 	dma_cap_set(DMA_MEMCPY, cap_mask);
 
 	/* get DMA parameters from controller type */
-	atdmatype = platform_get_device_id(pdev)->driver_data;
+	atdmatype = at_dma_get_driver_data(pdev);
 
 	switch (atdmatype) {
 	case ATDMA_DEVTYPE_SAM9RL:
@@ -1526,6 +1553,7 @@ static struct platform_driver at_dma_driver = {
 	.driver = {
 		.name	= "at_hdmac",
 		.pm	= &at_dma_dev_pm_ops,
+		.of_match_table	= of_match_ptr(atmel_dma_dt_ids),
 	},
 };
 
-- 
1.7.5.4

