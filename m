Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab2I1Myg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:54:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37847 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757725Ab2I1Mx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:53:57 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>
Subject: [PATCH 6/6] usb: dwc3: core: add dt support for dwc3 core
Date: Fri, 28 Sep 2012 18:23:15 +0530
Message-ID: <1348836795-4783-7-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348836795-4783-1-git-send-email-kishon@ti.com>
References: <1348836795-4783-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added dwc3 support for dwc3 core and update the documentation with
device tree binding information.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/usb/dwc3.txt |   24 ++++++++++++++++++++++++
 drivers/usb/dwc3/core.c                        |   14 ++++++++++++--
 2 files changed, 36 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/dwc3.txt

diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
new file mode 100644
index 0000000..87d5eeb
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/dwc3.txt
@@ -0,0 +1,24 @@
+SYNOPSIS DWC3 CORE
+
+DWC3- USB3 CONTROLLER
+
+Required properties:
+ - compatible: Should be "synopsis,dwc3"
+ - reg : Address and length of the register set for the device
+ - interrupts: Interrupts used by the dwc3 controller.
+ - interrupt-parent: the phandle for the interrupt controller that
+   services interrupts for this device.
+
+Optional properties:
+ - tx-fifo-resize: determines if the fifo spaces can be reallocated according
+ to use-cases.
+
+This is usually a subnode to DWC3 glue to which it is connected.
+
+dwc3@4a030000 {
+	compatible = "synopsis,dwc3";
+	reg = <0x4a030000 0xcfff>;
+	interrupts = <0 92 4>
+	interrupt-parent = <&gic>
+	tx-fifo-resize;
+};
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 08a5738..0c17a7a 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -484,8 +484,7 @@ static int __devinit dwc3_probe(struct platform_device *pdev)
 	else
 		dwc->maximum_speed = DWC3_DCFG_SUPERSPEED;
 
-	if (of_get_property(node, "tx-fifo-resize", NULL))
-		dwc->needs_fifo_resize = true;
+	dwc->needs_fifo_resize = of_property_read_bool(node, "tx-fifo-resize");
 
 	pm_runtime_enable(dev);
 	pm_runtime_get_sync(dev);
@@ -602,11 +601,22 @@ static int __devexit dwc3_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id of_dwc3_matach[] = {
+	{
+		.compatible = "synopsis,dwc3"
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, of_dwc3_matach);
+#endif
+
 static struct platform_driver dwc3_driver = {
 	.probe		= dwc3_probe,
 	.remove		= __devexit_p(dwc3_remove),
 	.driver		= {
 		.name	= "dwc3",
+		.of_match_table	= of_match_ptr(of_dwc3_matach),
 	},
 };
 
-- 
1.7.10.4

