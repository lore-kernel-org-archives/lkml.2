Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab2HFNIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:08:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41696 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756258Ab2HFNIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:08:40 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <b-cousson@ti.com>, <rnayak@ti.com>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH v7 6/7] drivers: usb: musb: Add device tree support for omap musb glue
Date: Mon, 6 Aug 2012 18:37:59 +0530
Message-ID: <1344258480-4304-7-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344258480-4304-1-git-send-email-kishon@ti.com>
References: <1344258480-4304-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added device tree support for omap musb driver and updated the
Documentation with device tree binding information.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/usb/omap-usb.txt |   34 +++++++++++-
 drivers/usb/musb/omap2430.c                        |   54 ++++++++++++++++++++
 2 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
index 52f503b..49a90fb 100644
--- a/Documentation/devicetree/bindings/usb/omap-usb.txt
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -1,4 +1,4 @@
-OMAP USB PHY
+OMAP USB PHY AND GLUE
 
 OMAP USB2 PHY
 
@@ -15,3 +15,35 @@ usb2phy@4a0ad080 {
 	reg = <0x4a0ad080 0x58>,
 		<0x4a002300 0x1>;
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
index 74dbd6f..8b1d7c0 100644
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
@@ -469,8 +470,11 @@ static u64 omap2430_dmamask = DMA_BIT_MASK(32);
 static int __devinit omap2430_probe(struct platform_device *pdev)
 {
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
+	struct omap_musb_board_data	*data;
 	struct platform_device		*musb;
 	struct omap2430_glue		*glue;
+	struct device_node		*np = pdev->dev.of_node;
+	struct musb_hdrc_config		*config;
 	struct resource			*res;
 	int				ret = -ENOMEM;
 
@@ -500,6 +504,42 @@ static int __devinit omap2430_probe(struct platform_device *pdev)
 	if (glue->control_otghs == NULL)
 		dev_dbg(&pdev->dev, "Failed to obtain control memory\n");
 
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
+		of_property_read_u32(np, "power", (u32 *)&pdata->power);
+		config->multipoint = of_property_read_bool(np, "multipoint");
+
+		pdata->board_data	= data;
+		pdata->config		= config;
+	}
+
 	pdata->platform_ops		= &omap2430_ops;
 
 	platform_set_drvdata(pdev, glue);
@@ -596,12 +636,26 @@ static struct dev_pm_ops omap2430_pm_ops = {
 #define DEV_PM_OPS	NULL
 #endif
 
+#ifdef CONFIG_OF
+static const struct of_device_id omap2430_id_table[] = {
+	{
+		.compatible = "ti,omap4-musb"
+	},
+	{
+		.compatible = "ti,omap3-musb"
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, omap2430_id_table);
+#endif
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
1.7.9.5

