Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab2JAKZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:25:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35802 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab2JAKZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:25:31 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v2 7/7] usb: dwc3: core: add dt support for dwc3 core
Date: Mon, 1 Oct 2012 15:55:07 +0530
Message-ID: <1349087107-18229-8-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349087107-18229-1-git-send-email-kishon@ti.com>
References: <1349087107-18229-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added dwc3 support for dwc3 core and update the documentation with
device tree binding information.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/usb/dwc3.txt |   23 +++++++++++++++++++++++
 drivers/usb/dwc3/core.c                        |   14 ++++++++++++--
 2 files changed, 35 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/dwc3.txt

diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
new file mode 100644
index 0000000..9ec9316
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/dwc3.txt
@@ -0,0 +1,23 @@
+synopsys DWC3 CORE
+
+DWC3- USB3 CONTROLLER
+
+Required properties:
+ - compatible: must be "synopsys,dwc3"
+ - reg : Address and length of the register set for the device
+ - interrupts: Interrupts used by the dwc3 controller.
+ - interrupt-parent: the phandle for the interrupt controller that
+   services interrupts for this device.
+
+Optional properties:
+ - tx-fifo-resize: determines if the FIFO *has* to be reallocated.
+
+This is usually a subnode to DWC3 glue to which it is connected.
+
+dwc3@4a030000 {
+	compatible = "synopsys,dwc3";
+	reg = <0x4a030000 0xcfff>;
+	interrupts = <0 92 4>
+	interrupt-parent = <&gic>
+	tx-fifo-resize;
+};
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 08a5738..4335a17 100644
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
+static const struct of_device_id of_dwc3_match[] = {
+	{
+		.compatible = "synopsys,dwc3"
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, of_dwc3_match);
+#endif
+
 static struct platform_driver dwc3_driver = {
 	.probe		= dwc3_probe,
 	.remove		= __devexit_p(dwc3_remove),
 	.driver		= {
 		.name	= "dwc3",
+		.of_match_table	= of_match_ptr(of_dwc3_match),
 	},
 };
 
-- 
1.7.9.5

