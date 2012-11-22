Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab2KVSqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:46:21 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:43510 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577Ab2KVSqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:46:16 -0500
From: "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
To: rob.herring@calxeda.com, robherring2@gmail.com,
        francescolavra.fl@gmail.com, anton.vorontsov@linaro.org
Cc: lee.jones@linaro.org, arnd@arndb.de, linus.walleij@stericsson.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        STEricsson_nomadik_linux@list.st.com, rajanikanth.hv@stericsson.com,
        "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
Subject: =?UTF-8?q?=5BPATCH=202/4=5D=20mfd=3A=20ab8500=3A=20add=20devicetree=20support=20for=20btemp?=
Date: Fri, 23 Nov 2012 00:13:45 +0530
Message-Id: <1353609827-8218-3-git-send-email-rajanikanth.hv@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353609827-8218-1-git-send-email-rajanikanth.hv@linaro.org>
References: <1353609827-8218-1-git-send-email-rajanikanth.hv@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>

This patch adds device tree support for
battery-temperature-monitor driver

Signed-off-by: Rajanikanth H.V <rajanikanth.hv@linaro.org>
---
 Documentation/devicetree/bindings/mfd/ab8500.txt   |    6 ++
 .../bindings/power_supply/ab8500/btemp.txt         |   16 +++++
 arch/arm/boot/dts/dbx5x0.dtsi                      |    5 ++
 drivers/mfd/ab8500-core.c                          |    5 ++
 drivers/power/Kconfig                              |    6 --
 drivers/power/ab8500_bmdata.c                      |    4 +-
 drivers/power/ab8500_btemp.c                       |   65 ++++++++++++--------
 7 files changed, 73 insertions(+), 34 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/ab8500/btemp.txt

diff --git a/Documentation/devicetree/bindings/mfd/ab8500.txt b/Documentation/devicetree/bindings/mfd/ab8500.txt
index 6ca8d81..f2ee0e7 100644
--- a/Documentation/devicetree/bindings/mfd/ab8500.txt
+++ b/Documentation/devicetree/bindings/mfd/ab8500.txt
@@ -30,6 +30,12 @@ ab8500-fg                : 			: vddadc       : Fuel Gauge
 			 : LOW_BAT_F		:	       : LOW threshold battery voltage
 			 : CC_INT_CALIB		:	       : Coulomb Counter Internal Calibration
 			 : CCEOC		:	       : Coulomb Counter End of Conversion
+ab8500-btemp		 :			: vtvout       : Battery Temperature
+			 : BAT_CTRL_INDB        :              : Battery Removal Indicator
+			 : BTEMP_LOW            :              : Btemp < BtempLow, if battery temperature is lower than -10°C
+			 : BTEMP_LOW_MEDIUM     :              : BtempLow < Btemp < BtempMedium,if battery temperature is between -10 and 0°C
+			 : BTEMP_MEDIUM_HIGH    :	       : BtempMedium < Btemp < BtempHigh,if battery temperature is between 0°C and“MaxTemp
+			 : BTEMP_HIGH           :              : Btemp > BtempHigh, if battery temperature is higher than “MaxTemp
 ab8500-gpadc             : HW_CONV_END          : vddadc       : Analogue to Digital Converter
                            SW_CONV_END          :              :
 ab8500-gpio              :                      :              : GPIO Controller
diff --git a/Documentation/devicetree/bindings/power_supply/ab8500/btemp.txt b/Documentation/devicetree/bindings/power_supply/ab8500/btemp.txt
new file mode 100644
index 0000000..0ba1bcc
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/ab8500/btemp.txt
@@ -0,0 +1,16 @@
+=== AB8500 Battery Temperature Monitor Driver ===
+
+The properties below describes the node for btemp driver.
+
+Required Properties:
+- compatible = Shall be: "stericsson,ab8500-btemp"
+- battery = Shall be battery specific information
+
+	Example:
+	ab8500_btemp {
+		compatible = "stericsson,ab8500-btemp";
+		battery	   = <&ab8500_battery>;
+	};
+
+For information on battery specific node, Ref:
+Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 155cf53..3f1d899 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -357,6 +357,11 @@
 					thermistor-on-batctrl;
 				};
 
+				ab8500-btemp {
+					compatible = "stericsson,ab8500-btemp";
+					battery	   = <&ab8500_battery>;
+				};
+
 				ab8500-fg {
 					compatible = "stericsson,ab8500-fg";
 					battery	   = <&ab8500_battery>;
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 7c3017b..94d45be 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1046,8 +1046,13 @@ static struct mfd_cell __devinitdata ab8500_bm_devs[] = {
 	},
 	{
 		.name = "ab8500-btemp",
+		.of_compatible = "stericsson,ab8500-btemp",
 		.num_resources = ARRAY_SIZE(ab8500_btemp_resources),
 		.resources = ab8500_btemp_resources,
+#ifndef CONFIG_OF
+		.platform_data = &ab8500_bm_data,
+		.pdata_size = sizeof(ab8500_bm_data),
+#endif
 	},
 	{
 		.name = "ab8500-fg",
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 49a8939..027f74e 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -329,12 +329,6 @@ config AB8500_BM
 	help
 	  Say Y to include support for AB8500 battery management.
 
-config AB8500_BATTERY_THERM_ON_BATCTRL
-	bool "Thermistor connected on BATCTRL ADC"
-	depends on AB8500_BM
-	help
-	  Say Y to enable battery temperature measurements using
-	  thermistor connected on BATCTRL ADC.
 endif # POWER_SUPPLY
 
 source "drivers/power/avs/Kconfig"
diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
index 0366270..ff8f055 100644
--- a/drivers/power/ab8500_bmdata.c
+++ b/drivers/power/ab8500_bmdata.c
@@ -29,7 +29,7 @@ static struct abx500_res_to_temp temp_tbl_A_thermistor[] = {
 	{65, 12500},
 };
 static struct abx500_res_to_temp temp_tbl_B_thermistor[] = {
-	{-5, 165418},
+	{-5, 200000},
 	{ 0, 159024},
 	{ 5, 151921},
 	{10, 144300},
@@ -237,7 +237,7 @@ struct abx500_battery_type bat_type_thermistor[] = {
 },
 {
 	.name = POWER_SUPPLY_TECHNOLOGY_LIPO,
-	.resis_high = 165418,
+	.resis_high = 200000,
 	.resis_low = 82869,
 	.battery_resistance = 300,
 	.charge_full_design = 900,
diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index abc2abc..b5dfc77 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -20,11 +20,13 @@
 #include <linux/power_supply.h>
 #include <linux/completion.h>
 #include <linux/workqueue.h>
-#include <linux/mfd/abx500/ab8500.h>
+#include <linux/jiffies.h>
+#include <linux/of.h>
+#include <linux/mfd/core.h>
 #include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500.h>
 #include <linux/mfd/abx500/ab8500-bm.h>
 #include <linux/mfd/abx500/ab8500-gpadc.h>
-#include <linux/jiffies.h>
 
 #define VTVOUT_V			1800
 
@@ -76,7 +78,6 @@ struct ab8500_btemp_ranges {
  * @parent:		Pointer to the struct ab8500
  * @gpadc:		Pointer to the struct gpadc
  * @fg:			Pointer to the struct fg
- * @pdata:		Pointer to the abx500_btemp platform data
  * @bat:		Pointer to the abx500_bm platform data
  * @btemp_psy:		Structure for BTEMP specific battery properties
  * @events:		Structure for information about events triggered
@@ -93,7 +94,6 @@ struct ab8500_btemp {
 	struct ab8500 *parent;
 	struct ab8500_gpadc *gpadc;
 	struct ab8500_fg *fg;
-	struct abx500_bmdevs_plat_data *pdata;
 	struct abx500_bm_data *bat;
 	struct power_supply btemp_psy;
 	struct ab8500_btemp_events events;
@@ -955,48 +955,58 @@ static int __devexit ab8500_btemp_remove(struct platform_device *pdev)
 	flush_scheduled_work();
 	power_supply_unregister(&di->btemp_psy);
 	platform_set_drvdata(pdev, NULL);
-	kfree(di);
 
 	return 0;
 }
 
+static char *supply_interface[] = {
+	"ab8500_chargalg",
+	"ab8500_fg",
+};
+
 static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 {
-	struct abx500_bmdevs_plat_data *plat_data = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
 	struct ab8500_btemp *di;
 	int irq, i, ret = 0;
 	u8 val;
 
-	if (!plat_data) {
-		dev_err(&pdev->dev, "No platform data\n");
-		return -EINVAL;
+	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
+	if (!di) {
+		dev_err(&pdev->dev, "%s no mem for ab8500_btemp\n", __func__);
+		return -ENOMEM;
 	}
 
-	di = kzalloc(sizeof(*di), GFP_KERNEL);
-	if (!di)
-		return -ENOMEM;
+	di->bat = pdev->mfd_cell->platform_data;
+	if (!di->bat) {
+		if (np) {
+			ret = bmdevs_of_probe(&pdev->dev, np, &di->bat);
+			if (ret) {
+				dev_err(&pdev->dev,
+					"failed to get battery information\n");
+				return ret;
+			}
+		} else {
+			dev_err(&pdev->dev, "missing dt node for ab8500_btemp\n");
+			return -EINVAL;
+		}
+	} else {
+		dev_info(&pdev->dev, "falling back to legacy platform data\n");
+	}
 
 	/* get parent data */
 	di->dev = &pdev->dev;
 	di->parent = dev_get_drvdata(pdev->dev.parent);
 	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 
-	/* get btemp specific platform data */
-	di->pdata = plat_data;
-	if (!di->pdata) {
-		dev_err(di->dev, "no btemp platform data supplied\n");
-		ret = -EINVAL;
-		goto free_device_info;
-	}
-
 	/* BTEMP supply */
 	di->btemp_psy.name = "ab8500_btemp";
 	di->btemp_psy.type = POWER_SUPPLY_TYPE_BATTERY;
 	di->btemp_psy.properties = ab8500_btemp_props;
 	di->btemp_psy.num_properties = ARRAY_SIZE(ab8500_btemp_props);
 	di->btemp_psy.get_property = ab8500_btemp_get_property;
-	di->btemp_psy.supplied_to = di->pdata->supplied_to;
-	di->btemp_psy.num_supplicants = di->pdata->num_supplicants;
+	di->btemp_psy.supplied_to = supply_interface;
+	di->btemp_psy.num_supplicants = ARRAY_SIZE(supply_interface);
 	di->btemp_psy.external_power_changed =
 		ab8500_btemp_external_power_changed;
 
@@ -1006,8 +1016,7 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 		create_singlethread_workqueue("ab8500_btemp_wq");
 	if (di->btemp_wq == NULL) {
 		dev_err(di->dev, "failed to create work queue\n");
-		ret = -ENOMEM;
-		goto free_device_info;
+		return -ENOMEM;
 	}
 
 	/* Init work for measuring temperature periodically */
@@ -1085,12 +1094,15 @@ free_irq:
 	}
 free_btemp_wq:
 	destroy_workqueue(di->btemp_wq);
-free_device_info:
-	kfree(di);
 
 	return ret;
 }
 
+static const struct of_device_id ab8500_btemp_match[] = {
+	{ .compatible = "stericsson,ab8500-btemp", },
+	{ },
+};
+
 static struct platform_driver ab8500_btemp_driver = {
 	.probe = ab8500_btemp_probe,
 	.remove = __devexit_p(ab8500_btemp_remove),
@@ -1099,6 +1111,7 @@ static struct platform_driver ab8500_btemp_driver = {
 	.driver = {
 		.name = "ab8500-btemp",
 		.owner = THIS_MODULE,
+		.of_match_table = ab8500_btemp_match,
 	},
 };
 
-- 
1.7.10.4

