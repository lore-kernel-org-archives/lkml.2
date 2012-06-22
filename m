Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984Ab2FVNc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:32:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38366 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932968Ab2FVNcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:32:55 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <kishon@ti.com>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <balbi@ti.com>,
        <hvaibhav@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: [RFC PATCH 06/10] drivers: usb: twl4030: Add device tree support for twl4030 usb
Date: Fri, 22 Jun 2012 19:02:15 +0530
Message-ID: <1340371939-23572-7-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340371939-23572-1-git-send-email-kishon@ti.com>
References: <1340371939-23572-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support for twl6030 usb driver.
Update the Documentation with device tree binding information.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/usb/twlxxxx-usb.txt        |   19 ++++++++++++++
 drivers/usb/otg/twl4030-usb.c                      |   26 +++++++++++++++----
 2 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt b/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
index b952070..4a0b060 100644
--- a/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
+++ b/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
@@ -16,3 +16,22 @@ twl6030-usb {
 	regulator = "vusb";
 	vusb-supply = <&vusb>;
 };
+
+TWL4030 USB PHY AND COMPARATOR
+ - compatible : Should be "ti,twl4030-usb"
+ - interrupts : The interrupt numbers to the cpu should be specified. First
+   interrupt number is the otg interrupt number that raises ID interrupts
+   and VBUS interrupts. The second interrupt number is optional.
+ - <supply-name>-supply : phandle to the regulator device tree node.
+   <supply-name> should be vusb1v5, vusb1v8 and vusb3v1
+ - usb_mode : The mode used by the phy to connect to the controller. "1"
+   specifies "ULPI" mode and "2" specifies "CEA2011_3PIN" mode.
+
+twl4030-usb {
+	compatible = "ti,twl4030-usb";
+	interrupts = < 10 4 >;
+	vusb1v5-supply = <&vusb1v5>;
+	vusb1v8-supply = <&vusb1v8>;
+	vusb3v1-supply = <&vusb3v1>;
+	usb_mode = <1>;
+};
diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index 9da89b6..74855d6 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -585,23 +585,28 @@ static int __devinit twl4030_usb_probe(struct platform_device *pdev)
 	struct twl4030_usb	*twl;
 	int			status, err;
 	struct usb_otg		*otg;
-
-	if (!pdata) {
-		dev_dbg(&pdev->dev, "platform_data not available\n");
-		return -EINVAL;
-	}
+	struct device_node	*np = pdev->dev.of_node;
 
 	twl = devm_kzalloc(&pdev->dev, sizeof *twl, GFP_KERNEL);
 	if (!twl)
 		return -ENOMEM;
 
+	if (np)
+		of_property_read_u32(np, "usb_mode",
+				(enum twl4030_usb_mode *)&twl->usb_mode);
+	else if (pdata)
+		twl->usb_mode = pdata->usb_mode;
+	else {
+		dev_err(&pdev->dev, "twl4030 initialized without pdata\n");
+		return -EINVAL;
+	}
+
 	otg = devm_kzalloc(&pdev->dev, sizeof *otg, GFP_KERNEL);
 	if (!otg)
 		return -ENOMEM;
 
 	twl->dev		= &pdev->dev;
 	twl->irq		= platform_get_irq(pdev, 0);
-	twl->usb_mode		= pdata->usb_mode;
 	twl->vbus_supplied	= false;
 	twl->asleep		= 1;
 	twl->linkstat		= OMAP_MUSB_UNKNOWN;
@@ -690,12 +695,21 @@ static int __exit twl4030_usb_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id twl4030_usb_id_table[] = {
+	{ .compatible = "ti,twl4030-usb" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, twl4030_usb_id_table);
+#endif
+
 static struct platform_driver twl4030_usb_driver = {
 	.probe		= twl4030_usb_probe,
 	.remove		= __exit_p(twl4030_usb_remove),
 	.driver		= {
 		.name	= "twl4030_usb",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(twl4030_usb_id_table),
 	},
 };
 
-- 
1.7.5.4

