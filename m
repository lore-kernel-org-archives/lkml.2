Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab2JAKZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:25:34 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35800 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab2JAKZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:25:31 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v2 2/7] usb: dwc3-omap: use of_platform API to create dwc3 core pdev
Date: Mon, 1 Oct 2012 15:55:02 +0530
Message-ID: <1349087107-18229-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349087107-18229-1-git-send-email-kishon@ti.com>
References: <1349087107-18229-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used of_platform_populate() to populate dwc3 core platform_device
from device tree data. Since now the allocation of unique device id is
handled be of_*, removed the call to dwc3_get_device_id.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c |   52 ++++++++----------------------------------
 1 file changed, 10 insertions(+), 42 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index e335da3..cb4037a 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -47,6 +47,7 @@
 #include <linux/ioport.h>
 #include <linux/io.h>
 #include <linux/of.h>
+#include <linux/of_platform.h>
 
 #include "core.h"
 
@@ -130,7 +131,6 @@ struct dwc3_omap {
 	/* device lock */
 	spinlock_t		lock;
 
-	struct platform_device	*dwc3;
 	struct device		*dev;
 
 	int			irq;
@@ -218,12 +218,10 @@ static int __devinit dwc3_omap_probe(struct platform_device *pdev)
 	struct dwc3_omap_data	*pdata = pdev->dev.platform_data;
 	struct device_node	*node = pdev->dev.of_node;
 
-	struct platform_device	*dwc3;
 	struct dwc3_omap	*omap;
 	struct resource		*res;
 	struct device		*dev = &pdev->dev;
 
-	int			devid;
 	int			size;
 	int			ret = -ENOMEM;
 	int			irq;
@@ -260,34 +258,19 @@ static int __devinit dwc3_omap_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	devid = dwc3_get_device_id();
-	if (devid < 0)
-		return -ENODEV;
-
-	dwc3 = platform_device_alloc("dwc3", devid);
-	if (!dwc3) {
-		dev_err(dev, "couldn't allocate dwc3 device\n");
-		goto err1;
-	}
-
 	context = devm_kzalloc(dev, resource_size(res), GFP_KERNEL);
 	if (!context) {
 		dev_err(dev, "couldn't allocate dwc3 context memory\n");
-		goto err2;
+		return -ENOMEM;
 	}
 
 	spin_lock_init(&omap->lock);
-	dma_set_coherent_mask(&dwc3->dev, dev->coherent_dma_mask);
 
-	dwc3->dev.parent = dev;
-	dwc3->dev.dma_mask = dev->dma_mask;
-	dwc3->dev.dma_parms = dev->dma_parms;
 	omap->resource_size = resource_size(res);
 	omap->context	= context;
 	omap->dev	= dev;
 	omap->irq	= irq;
 	omap->base	= base;
-	omap->dwc3	= dwc3;
 
 	reg = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
 
@@ -332,7 +315,7 @@ static int __devinit dwc3_omap_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(dev, "failed to request IRQ #%d --> %d\n",
 				omap->irq, ret);
-		goto err2;
+		return ret;
 	}
 
 	/* enable all IRQs */
@@ -351,35 +334,20 @@ static int __devinit dwc3_omap_probe(struct platform_device *pdev)
 
 	dwc3_omap_writel(omap->base, USBOTGSS_IRQENABLE_SET_1, reg);
 
-	ret = platform_device_add_resources(dwc3, pdev->resource,
-			pdev->num_resources);
-	if (ret) {
-		dev_err(dev, "couldn't add resources to dwc3 device\n");
-		goto err2;
-	}
-
-	ret = platform_device_add(dwc3);
-	if (ret) {
-		dev_err(dev, "failed to register dwc3 device\n");
-		goto err2;
+	if (node) {
+		ret = of_platform_populate(node, NULL, NULL, dev);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"failed to add create dwc3 core\n");
+			return ret;
+		}
 	}
 
 	return 0;
-
-err2:
-	platform_device_put(dwc3);
-
-err1:
-	dwc3_put_device_id(devid);
-
-	return ret;
 }
 
 static int __devexit dwc3_omap_remove(struct platform_device *pdev)
 {
-	struct dwc3_omap	*omap = platform_get_drvdata(pdev);
-
-	dwc3_put_device_id(omap->dwc3->id);
 	device_for_each_child(&pdev->dev, NULL, dwc3_omap_remove_core);
 
 	return 0;
-- 
1.7.9.5

