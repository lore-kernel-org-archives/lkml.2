Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2JON2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:28:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43792 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab2JON2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:28:44 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <sshtylyov@mvista.com>
Subject: [PATCH v4 3/7] usb: dwc3-omap: use runtime API's to enable clocks
Date: Mon, 15 Oct 2012 18:57:56 +0530
Message-ID: <1350307680-24938-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350307680-24938-1-git-send-email-kishon@ti.com>
References: <1350307680-24938-1-git-send-email-kishon@ti.com>
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
 drivers/usb/dwc3/dwc3-omap.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 4aaeec4..1fdf7e2 100644
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
@@ -336,6 +337,13 @@ static int __devinit dwc3_omap_probe(struct platform_device *pdev)
 	omap->irq	= irq;
 	omap->base	= base;
 
+	pm_runtime_enable(dev);
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		dev_err(dev, "get_sync failed with err %d\n", ret);
+		return ret;
+	}
+
 	reg = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
 
 	utmi_mode = of_get_property(node, "utmi-mode", &size);
@@ -417,6 +425,9 @@ static int __devexit dwc3_omap_remove(struct platform_device *pdev)
 	platform_device_unregister(omap->usb2_phy);
 	platform_device_unregister(omap->usb3_phy);
 
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	device_for_each_child(&pdev->dev, NULL, dwc3_omap_remove_core);
 
 	return 0;
-- 
1.7.9.5

