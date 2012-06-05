Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab2FELzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:55:07 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:48101 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992Ab2FELzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:55:05 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Dmitry Torokhov <dtor@mail.ru>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        peter.ujfalusi@ti.com
Subject: [PATCH v2] Input: twl6040-vibra: Update for device tree support
Date: Tue,  5 Jun 2012 14:54:32 +0300
Message-Id: <1338897272-24357-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The twl6040 DT support implementation has been changed from the originally
planned.
None of the child devices going to have compatible_of property which means
that the child devices of twl6040 will be created as traditional MFD devices.
The mfd core driver will decide (based on the DT blob) to create a device
for the twl6040-vibra or not. If the DT blob has 'vibra' section the device
will be created without pdata.
In this case the vibra driver will reach up to the parent node to get the
needed properties.
With DT booted kernel we no longer be able to link the regulators to the vibra
driver, they can be only linked to the MFD device (probed via DT). From the
vibra driver we ned to use pdev->dev.parent to get the regulators.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---

Hi Dmitry,

Changes since v1:
- Fixed compilation error when CONFIG_OF is not selected (for example x86_32
  allmodconfig)

Apart from testing this on OMAP I also compiled the kernel for x86_64 and
x86_32 with allmodconfig.
I have not seen any issues.

Regards,
Peter

 .../devicetree/bindings/input/twl6040-vibra.txt    |   37 ----------------
 drivers/input/misc/twl6040-vibra.c                 |   46 ++++++++++++-------
 2 files changed, 29 insertions(+), 54 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/input/twl6040-vibra.txt

diff --git a/Documentation/devicetree/bindings/input/twl6040-vibra.txt b/Documentation/devicetree/bindings/input/twl6040-vibra.txt
deleted file mode 100644
index 5b1918b..0000000
--- a/Documentation/devicetree/bindings/input/twl6040-vibra.txt
+++ /dev/null
@@ -1,37 +0,0 @@
-Vibra driver for the twl6040 family
-
-The vibra driver is a child of the twl6040 MFD dirver.
-Documentation/devicetree/bindings/mfd/twl6040.txt
-
-Required properties:
-- compatible : Must be "ti,twl6040-vibra";
-- interrupts: 4, Vibra overcurrent interrupt
-- vddvibl-supply: Regulator supplying the left vibra motor
-- vddvibr-supply: Regulator supplying the right vibra motor
-- vibldrv_res: Board specific left driver resistance
-- vibrdrv_res: Board specific right driver resistance
-- viblmotor_res: Board specific left motor resistance
-- vibrmotor_res: Board specific right motor resistance
-
-Optional properties:
-- vddvibl_uV: If the vddvibl default voltage need to be changed
-- vddvibr_uV: If the vddvibr default voltage need to be changed
-
-Example:
-/*
- * 8-channel high quality low-power audio codec
- * http://www.ti.com/lit/ds/symlink/twl6040.pdf
- */
-twl6040: twl6040@4b {
-	...
-	twl6040_vibra: twl6040@1 {
-		compatible = "ti,twl6040-vibra";
-		interrupts = <4>;
-		vddvibl-supply = <&vbat>;
-		vddvibr-supply = <&vbat>;
-		vibldrv_res = <8>;
-		vibrdrv_res = <3>;
-		viblmotor_res = <10>;
-		vibrmotor_res = <10>;
-	};
-};
diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
index c34f6c0..e8f3f5f 100644
--- a/drivers/input/misc/twl6040-vibra.c
+++ b/drivers/input/misc/twl6040-vibra.c
@@ -259,13 +259,19 @@ static SIMPLE_DEV_PM_OPS(twl6040_vibra_pm_ops, twl6040_vibra_suspend, NULL);
 static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 {
 	struct twl6040_vibra_data *pdata = pdev->dev.platform_data;
-	struct device_node *node = pdev->dev.of_node;
+	struct device *twl6040_core_dev = pdev->dev.parent;
+	struct device_node *twl6040_core_node = NULL;
 	struct vibra_info *info;
 	int vddvibl_uV = 0;
 	int vddvibr_uV = 0;
 	int ret;
 
-	if (!pdata && !node) {
+#ifdef CONFIG_OF
+	twl6040_core_node = of_find_node_by_name(twl6040_core_dev->of_node,
+						 "vibra");
+#endif
+
+	if (!pdata && !twl6040_core_node) {
 		dev_err(&pdev->dev, "platform_data not available\n");
 		return -EINVAL;
 	}
@@ -287,14 +293,18 @@ static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 		vddvibl_uV = pdata->vddvibl_uV;
 		vddvibr_uV = pdata->vddvibr_uV;
 	} else {
-		of_property_read_u32(node, "vibldrv_res", &info->vibldrv_res);
-		of_property_read_u32(node, "vibrdrv_res", &info->vibrdrv_res);
-		of_property_read_u32(node, "viblmotor_res",
+		of_property_read_u32(twl6040_core_node, "ti,vibldrv-res",
+				     &info->vibldrv_res);
+		of_property_read_u32(twl6040_core_node, "ti,vibrdrv-res",
+				     &info->vibrdrv_res);
+		of_property_read_u32(twl6040_core_node, "ti,viblmotor-res",
 				     &info->viblmotor_res);
-		of_property_read_u32(node, "vibrmotor_res",
+		of_property_read_u32(twl6040_core_node, "ti,vibrmotor-res",
 				     &info->vibrmotor_res);
-		of_property_read_u32(node, "vddvibl_uV", &vddvibl_uV);
-		of_property_read_u32(node, "vddvibr_uV", &vddvibr_uV);
+		of_property_read_u32(twl6040_core_node, "ti,vddvibl-uV",
+				     &vddvibl_uV);
+		of_property_read_u32(twl6040_core_node, "ti,vddvibr-uV",
+				     &vddvibr_uV);
 	}
 
 	if ((!info->vibldrv_res && !info->viblmotor_res) ||
@@ -351,8 +361,17 @@ static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 
 	info->supplies[0].supply = "vddvibl";
 	info->supplies[1].supply = "vddvibr";
-	ret = regulator_bulk_get(info->dev, ARRAY_SIZE(info->supplies),
-				 info->supplies);
+	/*
+	 * When booted with Device tree the regulators are attached to the
+	 * parent device (twl6040 MFD core)
+	 */
+	if (pdata)
+		ret = regulator_bulk_get(info->dev, ARRAY_SIZE(info->supplies),
+					info->supplies);
+	else
+		ret = regulator_bulk_get(twl6040_core_dev,
+					 ARRAY_SIZE(info->supplies),
+					 info->supplies);
 	if (ret) {
 		dev_err(info->dev, "couldn't get regulators %d\n", ret);
 		goto err_regulator;
@@ -418,12 +437,6 @@ static int __devexit twl6040_vibra_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id twl6040_vibra_of_match[] = {
-	{.compatible = "ti,twl6040-vibra", },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, twl6040_vibra_of_match);
-
 static struct platform_driver twl6040_vibra_driver = {
 	.probe		= twl6040_vibra_probe,
 	.remove		= __devexit_p(twl6040_vibra_remove),
@@ -431,7 +444,6 @@ static struct platform_driver twl6040_vibra_driver = {
 		.name	= "twl6040-vibra",
 		.owner	= THIS_MODULE,
 		.pm	= &twl6040_vibra_pm_ops,
-		.of_match_table = twl6040_vibra_of_match,
 	},
 };
 module_platform_driver(twl6040_vibra_driver);
-- 
1.7.8.6

