Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab2I1Mxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:53:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37797 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757628Ab2I1Mxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:53:46 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>
Subject: [PATCH 2/6] usb: dwc3-omap: use runtime API's to enable clocks
Date: Fri, 28 Sep 2012 18:23:11 +0530
Message-ID: <1348836795-4783-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348836795-4783-1-git-send-email-kishon@ti.com>
References: <1348836795-4783-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before accessing any register, runtime API's should be invoked to enable
the clocks. runtime API's are added here to prevent abort during register
access.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 34578de..6a0e17f 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -43,6 +43,7 @@
 #include <linux/spinlock.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/dwc3-omap.h>
+#include <linux/pm_runtime.h>
 #include <linux/dma-mapping.h>
 #include <linux/ioport.h>
 #include <linux/io.h>
@@ -281,6 +282,13 @@ static int __devinit dwc3_omap_probe(struct platform_device *pdev)
 	omap->irq	= irq;
 	omap->base	= base;
 
+	pm_runtime_enable(dev);
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		dev_err(dev, "get_sync failed with err %d\n", ret);
+			goto err1;
+	}
+
 	reg = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
 
 	utmi_mode = of_get_property(node, "utmi-mode", &size);
@@ -354,6 +362,8 @@ err1:
 static int __devexit dwc3_omap_remove(struct platform_device *pdev)
 {
 	device_for_each_child(&pdev->dev, NULL, dwc3_remove_core);
+	pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 
 	return 0;
 }
-- 
1.7.10.4

