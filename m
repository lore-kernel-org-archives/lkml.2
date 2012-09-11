Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab2IKJL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 05:11:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45464 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756967Ab2IKJLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 05:11:54 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <kishon@ti.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: [PATCH v2 3/3] usb: musb: omap: Add device tree support for omap musb glue
Date: Tue, 11 Sep 2012 14:39:40 +0530
Message-ID: <1347354580-5895-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347354580-5895-1-git-send-email-kishon@ti.com>
References: <1347354580-5895-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added device tree support for omap musb driver and updated the
Documentation with device tree binding information.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/usb/omap-usb.txt |   33 ++++++++++++
 drivers/usb/musb/omap2430.c                        |   54 ++++++++++++++++++++
 2 files changed, 87 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/omap-usb.txt

diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
new file mode 100644
index 0000000..29a043e
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -0,0 +1,33 @@
+OMAP GLUE
+
+OMAP MUSB GLUE
+ - compatible : Should be "ti,omap4-musb" or "ti,omap3-musb"
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
+	compatible = "ti,omap4-musb";
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
index f4d9503..d96873b 100644
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
@@ -470,8 +471,11 @@ static u64 omap2430_dmamask = DMA_BIT_MASK(32);
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
 
@@ -501,6 +505,42 @@ static int __devinit omap2430_probe(struct platform_device *pdev)
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
@@ -597,12 +637,26 @@ static struct dev_pm_ops omap2430_pm_ops = {
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

