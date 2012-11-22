Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab2KVSq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:46:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33078 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab2KVSqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:46:23 -0500
From: "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
To: rob.herring@calxeda.com, robherring2@gmail.com,
        francescolavra.fl@gmail.com, anton.vorontsov@linaro.org
Cc: lee.jones@linaro.org, arnd@arndb.de, linus.walleij@stericsson.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        STEricsson_nomadik_linux@list.st.com, rajanikanth.hv@stericsson.com,
        "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
Subject: =?UTF-8?q?=5BPATCH=203/4=5D=20mfd=3A=20ab8500=3A=20add=20devicetree=20support=20for=20charger?=
Date: Fri, 23 Nov 2012 00:13:46 +0530
Message-Id: <1353609827-8218-4-git-send-email-rajanikanth.hv@linaro.org>
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

This patch adds device tree support for ab8500-charger
driver

Signed-off-by: Rajanikanth H.V <rajanikanth.hv@linaro.org>
---
 Documentation/devicetree/bindings/mfd/ab8500.txt   |   14 ++++
 .../bindings/power_supply/ab8500/charger.txt       |   25 +++++++
 arch/arm/boot/dts/dbx5x0.dtsi                      |    6 ++
 drivers/mfd/ab8500-core.c                          |    5 ++
 drivers/power/ab8500_charger.c                     |   73 ++++++++++++--------
 5 files changed, 96 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/ab8500/charger.txt

diff --git a/Documentation/devicetree/bindings/mfd/ab8500.txt b/Documentation/devicetree/bindings/mfd/ab8500.txt
index f2ee0e7..13b707b 100644
--- a/Documentation/devicetree/bindings/mfd/ab8500.txt
+++ b/Documentation/devicetree/bindings/mfd/ab8500.txt
@@ -36,6 +36,20 @@ ab8500-btemp		 :			: vtvout       : Battery Temperature
 			 : BTEMP_LOW_MEDIUM     :              : BtempLow < Btemp < BtempMedium,if battery temperature is between -10 and 0°C
 			 : BTEMP_MEDIUM_HIGH    :	       : BtempMedium < Btemp < BtempHigh,if battery temperature is between 0°C and“MaxTemp
 			 : BTEMP_HIGH           :              : Btemp > BtempHigh, if battery temperature is higher than “MaxTemp
+ab8500-charger		 :			: vddadc       : Charger interface
+			 : MAIN_CH_UNPLUG_DET	:	       : main charger unplug detection management (not in 8505)
+			 : MAIN_CHARGE_PLUG_DET	:	       : main charger plug detection management (not in 8505)
+			 : MAIN_EXT_CH_NOT_OK	:	       : main charger not OK
+			 : MAIN_CH_TH_PROT_R	:	       : Die temp is above main charger
+			 : MAIN_CH_TH_PROT_F	:	       : Die temp is below main charger
+			 : VBUS_DET_F		:	       : VBUS falling detected
+			 : VBUS_DET_R		:	       : VBUS rising detected
+			 : USB_LINK_STATUS	:	       : USB link status has changed
+			 : USB_CH_TH_PROT_R	:	       : Die temp is above usb charger
+			 : USB_CH_TH_PROT_F	:	       : Die temp is below usb charger
+			 : USB_CHARGER_NOT_OKR	:	       : allowed USB charger not ok detection
+			 : VBUS_OVV		:	       : Overvoltage on Vbus ball detected (USB charge is stopped)
+			 : CH_WD_EXP		:	       : Charger watchdog detected
 ab8500-gpadc             : HW_CONV_END          : vddadc       : Analogue to Digital Converter
                            SW_CONV_END          :              :
 ab8500-gpio              :                      :              : GPIO Controller
diff --git a/Documentation/devicetree/bindings/power_supply/ab8500/charger.txt b/Documentation/devicetree/bindings/power_supply/ab8500/charger.txt
new file mode 100644
index 0000000..6bdbb08
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/ab8500/charger.txt
@@ -0,0 +1,25 @@
+=== AB8500 Charger Driver ===
+
+Required Properties:
+- compatible = Shall be "stericsson,ab8500-charger"
+- battery = Shall be battery specific information
+	Example:
+	ab8500_charger {
+		compatible = "stericsson,ab8500-charger";
+		battery	   = <&ab8500_battery>;
+	};
+
+- vddadc-supply: Supply for USB and Main charger
+	Example:
+	ab8500-charger {
+		vddadc-supply	= <&ab8500_ldo_tvout_reg>;
+	}
+- autopower_cfg:
+	Boolean value depicting the presence of 'automatic poweron after powerloss'
+	Example:
+	ab8500-charger {
+		autopower_cfg;
+	};
+
+For information on battery specific node, Ref:
+Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 3f1d899..7e9c01a 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -357,6 +357,12 @@
 					thermistor-on-batctrl;
 				};
 
+				ab8500-charger {
+					compatible	= "stericsson,ab8500-charger";
+					battery		= <&ab8500_battery>;
+					vddadc-supply	= <&ab8500_ldo_tvout_reg>;
+				};
+
 				ab8500-btemp {
 					compatible = "stericsson,ab8500-btemp";
 					battery	   = <&ab8500_battery>;
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 94d45be..c7a120b 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1041,8 +1041,13 @@ static struct mfd_cell __devinitdata abx500_common_devs[] = {
 static struct mfd_cell __devinitdata ab8500_bm_devs[] = {
 	{
 		.name = "ab8500-charger",
+		.of_compatible = "stericsson,ab8500-charger",
 		.num_resources = ARRAY_SIZE(ab8500_charger_resources),
 		.resources = ab8500_charger_resources,
+#ifndef CONFIG_OF
+		.platform_data = &ab8500_bm_data,
+		.pdata_size = sizeof(ab8500_bm_data),
+#endif
 	},
 	{
 		.name = "ab8500-btemp",
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 723edb4..5156a98 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -23,6 +23,8 @@
 #include <linux/err.h>
 #include <linux/workqueue.h>
 #include <linux/kobject.h>
+#include <linux/of.h>
+#include <linux/mfd/core.h>
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/abx500/ab8500-bm.h>
@@ -181,9 +183,9 @@ struct ab8500_charger_usb_state {
  * @vbat		Battery voltage
  * @old_vbat		Previously measured battery voltage
  * @autopower		Indicate if we should have automatic pwron after pwrloss
+ * @autopower_cfg	platform specific power config support for "pwron after pwrloss"
  * @parent:		Pointer to the struct ab8500
  * @gpadc:		Pointer to the struct gpadc
- * @pdata:		Pointer to the abx500_charger platform data
  * @bat:		Pointer to the abx500_bm platform data
  * @flags:		Structure for information about events triggered
  * @usb_state:		Structure for usb stack information
@@ -218,9 +220,9 @@ struct ab8500_charger {
 	int vbat;
 	int old_vbat;
 	bool autopower;
+	bool autopower_cfg;
 	struct ab8500 *parent;
 	struct ab8500_gpadc *gpadc;
-	struct abx500_bmdevs_plat_data *pdata;
 	struct abx500_bm_data *bat;
 	struct ab8500_charger_event_flags flags;
 	struct ab8500_charger_usb_state usb_state;
@@ -322,7 +324,7 @@ static void ab8500_power_loss_handling(struct ab8500_charger *di)
 static void ab8500_power_supply_changed(struct ab8500_charger *di,
 					struct power_supply *psy)
 {
-	if (di->pdata->autopower_cfg) {
+	if (di->autopower_cfg) {
 		if (!di->usb.charger_connected &&
 		    !di->ac.charger_connected &&
 		    di->autopower) {
@@ -2526,25 +2528,47 @@ static int __devexit ab8500_charger_remove(struct platform_device *pdev)
 	power_supply_unregister(&di->usb_chg.psy);
 	power_supply_unregister(&di->ac_chg.psy);
 	platform_set_drvdata(pdev, NULL);
-	kfree(di);
 
 	return 0;
 }
 
+static char *supply_interface[] = {
+	"ab8500_chargalg",
+	"ab8500_fg",
+	"ab8500_btemp",
+};
+
 static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 {
-	struct abx500_bmdevs_plat_data *plat_data = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
 	struct ab8500_charger *di;
 	int irq, i, charger_status, ret = 0;
 
-	if (!plat_data) {
-		dev_err(&pdev->dev, "No platform data\n");
-		return -EINVAL;
+	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
+	if (!di) {
+		dev_err(&pdev->dev, "%s no mem for ab8500_charger\n", __func__);
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
+			di->autopower_cfg =
+				of_property_read_bool(np, "autopower_cfg");
+		} else {
+			dev_err(&pdev->dev, "missing dt node for ab8500_charger\n");
+			return -EINVAL;
+		}
+	} else {
+		dev_info(&pdev->dev, "falling back to legacy platform data\n");
+		di->autopower_cfg = false;
+	}
 
 	/* get parent data */
 	di->dev = &pdev->dev;
@@ -2554,14 +2578,6 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	/* initialize lock */
 	spin_lock_init(&di->usb_state.usb_lock);
 
-	/* get charger specific platform data */
-	di->pdata = plat_data;
-	if (!di->pdata) {
-		dev_err(di->dev, "no charger platform data supplied\n");
-		ret = -EINVAL;
-		goto free_device_info;
-	}
-
 	di->autopower = false;
 
 	/* AC supply */
@@ -2571,8 +2587,8 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	di->ac_chg.psy.properties = ab8500_charger_ac_props;
 	di->ac_chg.psy.num_properties = ARRAY_SIZE(ab8500_charger_ac_props);
 	di->ac_chg.psy.get_property = ab8500_charger_ac_get_property;
-	di->ac_chg.psy.supplied_to = di->pdata->supplied_to;
-	di->ac_chg.psy.num_supplicants = di->pdata->num_supplicants;
+	di->ac_chg.psy.supplied_to = supply_interface;
+	di->ac_chg.psy.num_supplicants = ARRAY_SIZE(supply_interface),
 	/* ux500_charger sub-class */
 	di->ac_chg.ops.enable = &ab8500_charger_ac_en;
 	di->ac_chg.ops.kick_wd = &ab8500_charger_watchdog_kick;
@@ -2589,8 +2605,8 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	di->usb_chg.psy.properties = ab8500_charger_usb_props;
 	di->usb_chg.psy.num_properties = ARRAY_SIZE(ab8500_charger_usb_props);
 	di->usb_chg.psy.get_property = ab8500_charger_usb_get_property;
-	di->usb_chg.psy.supplied_to = di->pdata->supplied_to;
-	di->usb_chg.psy.num_supplicants = di->pdata->num_supplicants;
+	di->usb_chg.psy.supplied_to = supply_interface;
+	di->usb_chg.psy.num_supplicants = ARRAY_SIZE(supply_interface),
 	/* ux500_charger sub-class */
 	di->usb_chg.ops.enable = &ab8500_charger_usb_en;
 	di->usb_chg.ops.kick_wd = &ab8500_charger_watchdog_kick;
@@ -2606,8 +2622,7 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 		create_singlethread_workqueue("ab8500_charger_wq");
 	if (di->charger_wq == NULL) {
 		dev_err(di->dev, "failed to create work queue\n");
-		ret = -ENOMEM;
-		goto free_device_info;
+		return -ENOMEM;
 	}
 
 	/* Init work for HW failure check */
@@ -2749,12 +2764,15 @@ free_regulator:
 	regulator_put(di->regu);
 free_charger_wq:
 	destroy_workqueue(di->charger_wq);
-free_device_info:
-	kfree(di);
 
 	return ret;
 }
 
+static const struct of_device_id ab8500_charger_match[] = {
+	{ .compatible = "stericsson,ab8500-charger", },
+	{ },
+};
+
 static struct platform_driver ab8500_charger_driver = {
 	.probe = ab8500_charger_probe,
 	.remove = __devexit_p(ab8500_charger_remove),
@@ -2763,6 +2781,7 @@ static struct platform_driver ab8500_charger_driver = {
 	.driver = {
 		.name = "ab8500-charger",
 		.owner = THIS_MODULE,
+		.of_match_table = ab8500_charger_match,
 	},
 };
 
-- 
1.7.10.4

