Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab2EDMF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:05:57 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:36366 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756491Ab2EDMFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:05:55 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Dmitry Torokhov <dtor@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH] Input: tl6040-vibra: Device Tree support
Date: Fri,  4 May 2012 15:05:13 +0300
Message-Id: <1336133113-12224-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable DT based probing of the vibra driver.

Example of dts section to load the twl6040-vibra driver:
twl6040: twl6040@4b {
	...
	twl6040_vibra: twl6040@1 {
		compatible = "ti,twl6040-vibra";
		interrupts = <4>;
		vddvibl-supply = <&vbat>;
		vddvibr-supply = <&vbat>;
		vibldrv_res = <8>;
		vibrdrv_res = <3>;
		viblmotor_res = <10>;
		vibrmotor_res = <10>;
	};
};

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---

Hello,

Device tree support for the other twl6040 drivers (MFD core, ASoC codec) will
go via the appropriate subsystem since we do not have compile time or runtime
dependencies on them.

Regards,
Peter

 .../devicetree/bindings/input/twl6040-vibra.txt    |   37 ++++++++++++++++
 drivers/input/misc/twl6040-vibra.c                 |   46 +++++++++++++++-----
 2 files changed, 72 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/twl6040-vibra.txt

diff --git a/Documentation/devicetree/bindings/input/twl6040-vibra.txt b/Documentation/devicetree/bindings/input/twl6040-vibra.txt
new file mode 100644
index 0000000..5b1918b
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/twl6040-vibra.txt
@@ -0,0 +1,37 @@
+Vibra driver for the twl6040 family
+
+The vibra driver is a child of the twl6040 MFD dirver.
+Documentation/devicetree/bindings/mfd/twl6040.txt
+
+Required properties:
+- compatible : Must be "ti,twl6040-vibra";
+- interrupts: 4, Vibra overcurrent interrupt
+- vddvibl-supply: Regulator supplying the left vibra motor
+- vddvibr-supply: Regulator supplying the right vibra motor
+- vibldrv_res: Board specific left driver resistance
+- vibrdrv_res: Board specific right driver resistance
+- viblmotor_res: Board specific left motor resistance
+- vibrmotor_res: Board specific right motor resistance
+
+Optional properties:
+- vddvibl_uV: If the vddvibl default voltage need to be changed
+- vddvibr_uV: If the vddvibr default voltage need to be changed
+
+Example:
+/*
+ * 8-channel high quality low-power audio codec
+ * http://www.ti.com/lit/ds/symlink/twl6040.pdf
+ */
+twl6040: twl6040@4b {
+	...
+	twl6040_vibra: twl6040@1 {
+		compatible = "ti,twl6040-vibra";
+		interrupts = <4>;
+		vddvibl-supply = <&vbat>;
+		vddvibr-supply = <&vbat>;
+		vibldrv_res = <8>;
+		vibrdrv_res = <3>;
+		viblmotor_res = <10>;
+		vibrmotor_res = <10>;
+	};
+};
diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
index 14e94f5..bb134ce 100644
--- a/drivers/input/misc/twl6040-vibra.c
+++ b/drivers/input/misc/twl6040-vibra.c
@@ -27,6 +27,7 @@
  */
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/of_device.h>
 #include <linux/workqueue.h>
 #include <linux/input.h>
 #include <linux/mfd/twl6040.h>
@@ -258,10 +259,13 @@ static SIMPLE_DEV_PM_OPS(twl6040_vibra_pm_ops, twl6040_vibra_suspend, NULL);
 static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 {
 	struct twl6040_vibra_data *pdata = pdev->dev.platform_data;
+	struct device_node *node = pdev->dev.of_node;
 	struct vibra_info *info;
+	int vddvibl_uV = 0;
+	int vddvibr_uV = 0;
 	int ret;
 
-	if (!pdata) {
+	if (!pdata && !node) {
 		dev_err(&pdev->dev, "platform_data not available\n");
 		return -EINVAL;
 	}
@@ -273,11 +277,26 @@ static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 	}
 
 	info->dev = &pdev->dev;
+
 	info->twl6040 = dev_get_drvdata(pdev->dev.parent);
-	info->vibldrv_res = pdata->vibldrv_res;
-	info->vibrdrv_res = pdata->vibrdrv_res;
-	info->viblmotor_res = pdata->viblmotor_res;
-	info->vibrmotor_res = pdata->vibrmotor_res;
+	if (pdata) {
+		info->vibldrv_res = pdata->vibldrv_res;
+		info->vibrdrv_res = pdata->vibrdrv_res;
+		info->viblmotor_res = pdata->viblmotor_res;
+		info->vibrmotor_res = pdata->vibrmotor_res;
+		vddvibl_uV = pdata->vddvibl_uV;
+		vddvibr_uV = pdata->vddvibr_uV;
+	} else {
+		of_property_read_u32(node, "vibldrv_res", &info->vibldrv_res);
+		of_property_read_u32(node, "vibrdrv_res", &info->vibrdrv_res);
+		of_property_read_u32(node, "viblmotor_res",
+				     &info->viblmotor_res);
+		of_property_read_u32(node, "vibrmotor_res",
+				     &info->vibrmotor_res);
+		of_property_read_u32(node, "vddvibl_uV", &vddvibl_uV);
+		of_property_read_u32(node, "vddvibr_uV", &vddvibr_uV);
+	}
+
 	if ((!info->vibldrv_res && !info->viblmotor_res) ||
 	    (!info->vibrdrv_res && !info->vibrmotor_res)) {
 		dev_err(info->dev, "invalid vibra driver/motor resistance\n");
@@ -339,10 +358,9 @@ static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 		goto err_regulator;
 	}
 
-	if (pdata->vddvibl_uV) {
+	if (vddvibl_uV) {
 		ret = regulator_set_voltage(info->supplies[0].consumer,
-					    pdata->vddvibl_uV,
-					    pdata->vddvibl_uV);
+					    vddvibl_uV, vddvibl_uV);
 		if (ret) {
 			dev_err(info->dev, "failed to set VDDVIBL volt %d\n",
 				ret);
@@ -350,10 +368,9 @@ static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (pdata->vddvibr_uV) {
+	if (vddvibr_uV) {
 		ret = regulator_set_voltage(info->supplies[1].consumer,
-					    pdata->vddvibr_uV,
-					    pdata->vddvibr_uV);
+					    vddvibr_uV, vddvibr_uV);
 		if (ret) {
 			dev_err(info->dev, "failed to set VDDVIBR volt %d\n",
 				ret);
@@ -401,6 +418,12 @@ static int __devexit twl6040_vibra_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id twl6040_vibra_of_match[] = {
+	{.compatible = "ti,twl6040-vibra", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, twl6040_vibra_of_match);
+
 static struct platform_driver twl6040_vibra_driver = {
 	.probe		= twl6040_vibra_probe,
 	.remove		= __devexit_p(twl6040_vibra_remove),
@@ -408,6 +431,7 @@ static struct platform_driver twl6040_vibra_driver = {
 		.name	= "twl6040-vibra",
 		.owner	= THIS_MODULE,
 		.pm	= &twl6040_vibra_pm_ops,
+		.of_match_table = twl6040_vibra_of_match,
 	},
 };
 module_platform_driver(twl6040_vibra_driver);
-- 
1.7.8.6

