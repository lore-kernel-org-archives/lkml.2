Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab2IJLV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 07:21:57 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39788 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257Ab2IJLVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 07:21:55 -0400
MIME-Version: 1.0
Date: Mon, 10 Sep 2012 16:51:54 +0530
Message-ID: <CAB4BAktQz5MY_AHHWUAhRp7HtEzC3v8uFbP0enx1b7ibJLoZ4Q@mail.gmail.com>
Subject: mfd: Implement devicetree support for AB8500 Btemp
From: Rajanikanth HV <rajanikanth.hv@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        linus.walleij@stericsson.com, STEricsson_nomadik_linux@list.st.com,
        linaro-dev@lists.linaro.org, Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support for
battery temperature monitor driver

Signed-off-by: Rajanikanth H.V <rajanikanth.hv@stericsson.com>
---
 .../bindings/power_supply/ab8500/btemp.txt         |   52 ++++++
 arch/arm/boot/dts/dbx5x0.dtsi                      |    8 +
 drivers/mfd/ab8500-core.c                          |    1 +
 drivers/power/Kconfig                              |    6 -
 drivers/power/ab8500_bmdata.h                      |    4 +-
 drivers/power/ab8500_btemp.c                       |  181 ++++++++++++++++----
 6 files changed, 213 insertions(+), 39 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/power_supply/ab8500/btemp.txt

diff --git a/Documentation/devicetree/bindings/power_supply/ab8500/btemp.txt
b/Documentation/devicetree/bindings/power_supply/ab8500/btemp.txt
new file mode 100644
index 0000000..b214efc
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/ab8500/btemp.txt
@@ -0,0 +1,52 @@
+=== AB8500 Battery Temperature Monitor Driver ===
+
+The properties below describes the node for battery
+temperature monitor driver.
+
+Required Properties:
+- compatible = "stericsson,ab8500-btemp"
+
+supplied-to:
+	This is a logical binding w.r.t power supply event change
+	across energy-management-module drivers where in the
+	runtime battery properties are shared along with uevent
+	notification.
+	ref: di->btemp_psy.external_power_changed =
+		ab8500_btemp_external_power_changed;
+		ab8500_btemp.c
+
+	Need for this property:
+		btemp, fg and charger updates power-supply properties
+		based on the events listed above.
+		Event handler invokes power supply change notifier
+		which in-turn invokes registered power supply class call-back
+		based on the 'supplied_to' string.
+		ref:
+		power_supply_changed_work(..) ./drivers/power/power_supply_core.c
+
+	example:
+	ab8500-btemp {
+		/* Other enery management module */
+		supplied-to = "ab8500_chargalg", "ab8500_fg";
+		num_supplicants = <2>;
+	};
+
+thermister-interface:
+	'btemp' and 'batctrl' are the pins interfaced for battery temperature
+	measurement, btemp is used when NTC(negative temperature coefficient)
+	resister is interfaced external to battery and batctrl is used when
+	NTC resister is internal to battery.
+
+
+li-ion-9100-battery:
+	use this to add support for the 9100 Li-ION battery,
+	this adjust the bkup battery charger parameters
+	Note: this property is used for tablet version of snowball board.
+
+	example:
+	ab8500-btemp {
+		thermister-internal-to-battery = <1>;
+		li_ion_9100_battery = <0>;
+	};
+Note:
+interrupts are defined and registered in the driver
diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index d69c087..643e7fd 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -360,6 +360,14 @@
 					li_ion_9100  = <0>;
 				};

+				ab8500-btemp {
+					compatible = "stericsson,ab8500-btemp";
+					supplied_to = "ab8500_chargalg", "ab8500_fg";
+					num_supplicants = <2>;
+					thermister_on_batctrl = <1>;
+					li_ion_9100  = <0>;
+				};
+
 				ab8500-usb {
 					compatible = "stericsson,ab8500-usb";
 					interrupts = < 90 0x4
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index c413cfa..7ffba9b 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1047,6 +1047,7 @@ static struct mfd_cell __devinitdata ab8500_bm_devs[] = {
 	},
 	{
 		.name = "ab8500-btemp",
+		.of_compatible = "stericsson,ab8500-btemp",
 		.num_resources = ARRAY_SIZE(ab8500_btemp_resources),
 		.resources = ab8500_btemp_resources,
 	},
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index c1892f3..1434871 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -304,12 +304,6 @@ config AB8500_BM
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
diff --git a/drivers/power/ab8500_bmdata.h b/drivers/power/ab8500_bmdata.h
index 748334a..0bd0a45 100644
--- a/drivers/power/ab8500_bmdata.h
+++ b/drivers/power/ab8500_bmdata.h
@@ -22,7 +22,7 @@ static struct abx500_res_to_temp temp_tbl_A_thermister[] = {
 	{65, 12500},
 };
 static struct abx500_res_to_temp temp_tbl_B_thermister[] = {
-	{-5, 165418},
+	{-5, 200000},
 	{ 0, 159024},
 	{ 5, 151921},
 	{10, 144300},
@@ -229,7 +229,7 @@ static struct abx500_battery_type bat_type_thermister[] = {
 },
 {
 	.name = POWER_SUPPLY_TECHNOLOGY_LIPO,
-	.resis_high = 165418,
+	.resis_high = 200000,
 	.resis_low = 82869,
 	.battery_resistance = 300,
 	.charge_full_design = 900,
diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index bba3cca..ac08f1a 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
 #include <linux/completion.h>
@@ -25,6 +26,7 @@
 #include <linux/mfd/abx500/ab8500-bm.h>
 #include <linux/mfd/abx500/ab8500-gpadc.h>
 #include <linux/jiffies.h>
+#include "ab8500_bmdata.h"

 #define VTVOUT_V			1800

@@ -960,42 +962,153 @@ static int __devexit ab8500_btemp_remove(struct
platform_device *pdev)
 	return 0;
 }

-static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
+static int __devinit
+btemp_of_probe(struct device *dev,
+		struct device_node *np,
+		struct abx500_bm_plat_data *bm_pdata)
 {
-	int irq, i, ret = 0;
-	u8 val;
-	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
-	struct ab8500_btemp *di;
-
-	if (!plat_data) {
-		dev_err(&pdev->dev, "No platform data\n");
-		return -EINVAL;
+	u8	val;
+	u32	pval;
+	int	i;
+	int	ext_thermister, lion_battery, ret = 0;
+	const char *bm_dev_name;
+	struct	abx500_btemp_platform_data *btemp = bm_pdata->btemp;
+	struct	abx500_bm_data		   *bat;
+	struct	abx500_battery_type	   *btype;
+
+	ret = of_property_read_u32(np, "num_supplicants", &pval);
+	if (ret) {
+		dev_err(dev, "missing property num_supplicants\n");
+		ret = -EINVAL;
+		goto inval_pval;
 	}
-
-	di = kzalloc(sizeof(*di), GFP_KERNEL);
-	if (!di)
-		return -ENOMEM;
-
-	/* get parent data */
-	di->dev = &pdev->dev;
-	di->parent = dev_get_drvdata(pdev->dev.parent);
-	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
-
-	/* get btemp specific platform data */
-	di->pdata = plat_data->btemp;
-	if (!di->pdata) {
-		dev_err(di->dev, "no btemp platform data supplied\n");
+	btemp->num_supplicants = pval;
+	btemp->supplied_to =
+		devm_kzalloc(dev, btemp->num_supplicants *
+			sizeof(const char *), GFP_KERNEL);
+	if (btemp->supplied_to == NULL) {
+		dev_err(dev, "%s no mem for supplied_to\n", __func__);
+		ret = -ENOMEM;
+		goto inval_pval;
+	}
+	for (val = 0; val < btemp->num_supplicants; ++val)
+		if (of_property_read_string_index
+			(np, "supplied_to", val, &bm_dev_name) == 0)
+			*(btemp->supplied_to + val) = (char *)bm_dev_name;
+		else {
+			dev_err(dev, "insufficient number of supplied_to data found\n");
+			ret = -EINVAL;
+			goto free_dev_mem;
+		}
+	ret = of_property_read_u32(np, "thermister_on_batctrl", &pval);
+	if (ret) {
+		dev_err(dev, "missing property thermister_on_batctrl\n");
 		ret = -EINVAL;
-		goto free_device_info;
+		goto free_dev_mem;
+	}
+	bm_pdata->battery = &ab8500_bm_data;
+	bat = bm_pdata->battery;
+	ext_thermister = 0;
+	if (pval == 0) {
+		bat->n_btypes = 4;
+		bat->bat_type = bat_type_ext_thermister;
+		bat->adc_therm = ABx500_ADC_THERM_BATTEMP;
+		ext_thermister = 1;
+	}
+	ret = of_property_read_u32(np, "li_ion_9100", &pval);
+	if (ret) {
+		dev_err(dev, "missing property li_ion_9100\n");
+		ret = -EINVAL;
+		goto free_dev_mem;
+	}
+	lion_battery = 0;
+	if (pval == 1) {
+		bat->no_maintenance = true;
+		bat->chg_unknown_bat = true;
+		bat->bat_type[BATTERY_UNKNOWN].charge_full_design = 2600;
+		bat->bat_type[BATTERY_UNKNOWN].termination_vol = 4150;
+		bat->bat_type[BATTERY_UNKNOWN].recharge_vol = 4130;
+		bat->bat_type[BATTERY_UNKNOWN].normal_cur_lvl = 520;
+		bat->bat_type[BATTERY_UNKNOWN].normal_vol_lvl = 4200;
+		lion_battery = 1;
+	}
+	/* select the battery resolution table */
+	for (i = 0; i < bat->n_btypes; ++i) {
+		btype = (bat->bat_type + i);
+		if (ext_thermister) {
+			btype->batres_tbl =
+				temp_to_batres_tbl_ext_thermister;
+		} else if (lion_battery) {
+			btype->batres_tbl =
+				temp_to_batres_tbl_9100;
+		} else {
+			btype->batres_tbl =
+				temp_to_batres_tbl_thermister;
+		}
+	}
+	return ret;
+free_dev_mem:
+	devm_kfree(dev, btemp->supplied_to);
+inval_pval:
+	return ret;
+}
+
+static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
+{
+	u8	val;
+	int	i;
+	int	irq, ret = 0;
+	struct	abx500_bm_plat_data *pdata = pdev->dev.platform_data;
+	struct	device_node	*np = pdev->dev.of_node;
+	struct	ab8500_btemp	*di;
+
+	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
+	if (!di) {
+		dev_err(&pdev->dev, "%s no mem for ab8500_btemp\n", __func__);
+		ret = -ENOMEM;
 	}

-	/* get battery specific platform data */
-	di->bat = plat_data->battery;
-	if (!di->bat) {
-		dev_err(di->dev, "no battery platform data supplied\n");
+	if (np) {
+		if (!pdata) {
+			pdata =
+			devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+			if (!pdata) {
+				dev_err(&pdev->dev,
+					"%s no mem for pdata\n", __func__);
+				ret = -ENOMEM;
+				goto err_no_mem;
+			}
+			pdata->btemp = devm_kzalloc(&pdev->dev,
+					sizeof(*pdata->btemp), GFP_KERNEL);
+			if (!pdata->btemp) {
+				devm_kfree(&pdev->dev, pdata);
+				dev_err(&pdev->dev,
+					"%s no mem for pdata->btemp\n",
+					__func__);
+				ret = -ENOMEM;
+				goto free_device_info;
+			}
+		}
+		/* get battery specific platform data */
+		ret = btemp_of_probe(&pdev->dev, np, pdata);
+		if (ret) {
+			devm_kfree(&pdev->dev, pdata->btemp);
+			devm_kfree(&pdev->dev, pdata);
+			goto free_device_info;
+		}
+	}
+	if (!pdata) {
+		dev_err(&pdev->dev,
+			"%s no btemp platform data found\n", __func__);
 		ret = -EINVAL;
 		goto free_device_info;
 	}
+	di->pdata = pdata->btemp;
+	di->bat = pdata->battery;
+	/* get parent data */
+	di->dev = &pdev->dev;
+	di->parent = dev_get_drvdata(pdev->dev.parent);
+	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");

 	/* BTEMP supply */
 	di->btemp_psy.name = "ab8500_btemp";
@@ -1008,7 +1121,6 @@ static int __devinit ab8500_btemp_probe(struct
platform_device *pdev)
 	di->btemp_psy.external_power_changed =
 		ab8500_btemp_external_power_changed;

-
 	/* Create a work queue for the btemp */
 	di->btemp_wq =
 		create_singlethread_workqueue("ab8500_btemp_wq");
@@ -1065,7 +1177,7 @@ static int __devinit ab8500_btemp_probe(struct
platform_device *pdev)
 			IRQF_SHARED | IRQF_NO_SUSPEND,
 			ab8500_btemp_irq[i].name, di);

-		if (ret) {
+		if (ret < 0) {
 			dev_err(di->dev, "failed to request %s IRQ %d: %d\n"
 				, ab8500_btemp_irq[i].name, irq, ret);
 			goto free_irq;
@@ -1093,11 +1205,17 @@ free_irq:
 free_btemp_wq:
 	destroy_workqueue(di->btemp_wq);
 free_device_info:
-	kfree(di);
+	devm_kfree(&pdev->dev, di);
+err_no_mem:

 	return ret;
 }

+static const struct of_device_id ab8500_btemp_match[] = {
+	{.compatible = "stericsson,ab8500-btemp",},
+	{},
+};
+
 static struct platform_driver ab8500_btemp_driver = {
 	.probe = ab8500_btemp_probe,
 	.remove = __devexit_p(ab8500_btemp_remove),
@@ -1106,6 +1224,7 @@ static struct platform_driver ab8500_btemp_driver = {
 	.driver = {
 		.name = "ab8500-btemp",
 		.owner = THIS_MODULE,
+		.of_match_table = ab8500_btemp_match,
 	},
 };

-- 
1.7.9.5
