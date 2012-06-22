Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab2FVNeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:34:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38373 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932988Ab2FVNdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:33:00 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <kishon@ti.com>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <balbi@ti.com>,
        <hvaibhav@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: [RFC PATCH 08/10] drivers: usb: musb: Add device tree support for omap musb glue
Date: Fri, 22 Jun 2012 19:02:17 +0530
Message-ID: <1340371939-23572-9-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340371939-23572-1-git-send-email-kishon@ti.com>
References: <1340371939-23572-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added device tree support for omap musb driver and updated the
Documentation with device tree binding information.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/usb/omap-usb.txt |   32 +++++++++++++
 drivers/usb/musb/omap2430.c                        |   48 ++++++++++++++++++++
 2 files changed, 80 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
index 1c38feb..16bc4c9 100644
--- a/Documentation/devicetree/bindings/usb/omap-usb.txt
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -12,3 +12,35 @@ usb2phy@0x4a0ad080 {
 	compatible = "ti,omap-usb2";
 	reg = <0x4a0ad080 0x58>;
 };
+
+OMAP MUSB GLUE
+ - compatible : Should be "ti,musb-omap2430"
+ - ti,hwmods : must be "usb_otg_hs"
+ - multipoint : Should be "1" indicating the musb controller supports
+   multipoint. This is a MUSB configuration-specific setting.
+ - num_eps : Specifies the number of endpoints. This is also a
+   MUSB configuration-specific setting. Should be set to "16"
+ - ram_bits : Specifies the ram address size. Should be set to "12"
+ - interface_type : This is a board specific setting to describe the type of
+   interface between the controller and the phy. It should be "0" or "1"
+   specifying ULPI and UTMI respectively.
+ - mode : Should be "3" to represent OTG. "1" signifies HOST and "2"
+   represents PERIPHERAL.
+ - power : Should be "50". This signifies the controller can supply upto
+   100mA when operating in host mode.
+
+SOC specific device node entry
+usb_otg_hs: usb_otg_hs@4a0ab000 {
+	compatible = "ti,musb-omap2430";
+	ti,hwmods = "usb_otg_hs";
+	multipoint = <1>;
+	num_eps = <16>;
+	ram_bits = <12>;
+};
+
+Board specific device node entry
+&usb_otg_hs {
+	interface_type = <1>;
+	mode = <3>;
+	power = <50>;
+};
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 9a836e8..8e98c18 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/io.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/pm_runtime.h>
@@ -461,8 +462,11 @@ static u64 omap2430_dmamask = DMA_BIT_MASK(32);
 static int __devinit omap2430_probe(struct platform_device *pdev)
 {
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
+	struct omap_musb_board_data	*data;
 	struct platform_device		*musb;
 	struct omap2430_glue		*glue;
+	struct device_node		*np = pdev->dev.of_node;
+	struct musb_hdrc_config		*config;
 	int				ret = -ENOMEM;
 
 	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
@@ -486,6 +490,43 @@ static int __devinit omap2430_probe(struct platform_device *pdev)
 	glue->status			= OMAP_MUSB_UNKNOWN;
 	glue->control_dev		= omap_control_get();
 
+	if (np) {
+		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+		if (!pdata) {
+			dev_err(&pdev->dev,
+				"failed to allocate musb platfrom data\n");
+			ret = -ENOMEM;
+			goto err1;
+		}
+
+		data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+		if (!data) {
+			dev_err(&pdev->dev,
+					"failed to allocate musb board data\n");
+			ret = -ENOMEM;
+			goto err1;
+		}
+
+		config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
+		if (!data) {
+			dev_err(&pdev->dev,
+				"failed to allocate musb hdrc config\n");
+			goto err1;
+		}
+
+		of_property_read_u32(np, "mode", (u32 *)&pdata->mode);
+		of_property_read_u32(np, "interface_type",
+						(u32 *)&data->interface_type);
+		of_property_read_u32(np, "num_eps", (u32 *)&config->num_eps);
+		of_property_read_u32(np, "ram_bits", (u32 *)&config->ram_bits);
+		of_property_read_u32(np, "mode", (u32 *)&pdata->mode);
+		of_property_read_u32(np, "power", (u32 *)&pdata->power);
+		config->multipoint = of_property_read_bool(np, "multipoint");
+
+		pdata->board_data	= data;
+		pdata->config		= config;
+	}
+
 	pdata->platform_ops		= &omap2430_ops;
 
 	platform_set_drvdata(pdev, glue);
@@ -583,12 +624,19 @@ static struct dev_pm_ops omap2430_pm_ops = {
 #define DEV_PM_OPS	NULL
 #endif
 
+static const struct of_device_id omap2430_id_table[] = {
+	{ .compatible = "ti,musb-omap2430" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, omap2430_id_table);
+
 static struct platform_driver omap2430_driver = {
 	.probe		= omap2430_probe,
 	.remove		= __devexit_p(omap2430_remove),
 	.driver		= {
 		.name	= "musb-omap2430",
 		.pm	= DEV_PM_OPS,
+		.of_match_table = of_match_ptr(omap2430_id_table),
 	},
 };
 
-- 
1.7.5.4

