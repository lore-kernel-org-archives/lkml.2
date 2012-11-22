Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab2KVSqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:46:32 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:43510 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab2KVSqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:46:30 -0500
From: "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
To: rob.herring@calxeda.com, robherring2@gmail.com,
        francescolavra.fl@gmail.com, anton.vorontsov@linaro.org
Cc: lee.jones@linaro.org, arnd@arndb.de, linus.walleij@stericsson.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        STEricsson_nomadik_linux@list.st.com, rajanikanth.hv@stericsson.com,
        "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
Subject: [PATCH 4/4] mfd: ab8500: add devicetree support for chargalg
Date: Fri, 23 Nov 2012 00:13:47 +0530
Message-Id: <1353609827-8218-5-git-send-email-rajanikanth.hv@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353609827-8218-1-git-send-email-rajanikanth.hv@linaro.org>
References: <1353609827-8218-1-git-send-email-rajanikanth.hv@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>

This patch adds device tree support for charging algorithm
driver

Signed-off-by: Rajanikanth H.V <rajanikanth.hv@linaro.org>
---
 .../bindings/power_supply/ab8500/chargalg.txt      |   16 ++++++
 arch/arm/boot/dts/dbx5x0.dtsi                      |    5 ++
 drivers/mfd/ab8500-core.c                          |    5 ++
 drivers/power/abx500_chargalg.c                    |   56 ++++++++++++++------
 include/linux/mfd/abx500.h                         |    6 ---
 5 files changed, 66 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/ab8500/chargalg.txt

diff --git a/Documentation/devicetree/bindings/power_supply/ab8500/chargalg.txt b/Documentation/devicetree/bindings/power_supply/ab8500/chargalg.txt
new file mode 100644
index 0000000..ef53283
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/ab8500/chargalg.txt
@@ -0,0 +1,16 @@
+=== AB8500 Charging Algorithm Driver ===
+
+The properties below describes the node for chargalg driver.
+
+Required Properties:
+- compatible = Shall be: "stericsson,ab8500-chargalg"
+- battery = Shall be battery specific information
+
+Example:
+ab8500_chargalg {
+	compatible = "stericsson,ab8500-chargalg";
+	battery	   = <&ab8500_battery>;
+};
+
+For information on battery specific node, Ref:
+Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 7e9c01a..f1661b3 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -357,6 +357,11 @@
 					thermistor-on-batctrl;
 				};
 
+				ab8500-chargalg {
+					compatible	= "stericsson,ab8500-chargalg";
+					battery		= <&ab8500_battery>;
+				};
+
 				ab8500-charger {
 					compatible	= "stericsson,ab8500-charger";
 					battery		= <&ab8500_battery>;
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index c7a120b..5ec70f2 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1071,8 +1071,13 @@ static struct mfd_cell __devinitdata ab8500_bm_devs[] = {
 	},
 	{
 		.name = "ab8500-chargalg",
+		.of_compatible = "stericsson,ab8500-chargalg",
 		.num_resources = ARRAY_SIZE(ab8500_chargalg_resources),
 		.resources = ab8500_chargalg_resources,
+#ifndef CONFIG_OF
+		.platform_data = &ab8500_bm_data,
+		.pdata_size = sizeof(ab8500_bm_data),
+#endif
 	},
 };
 
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 94bf69b..96eb2c5 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -21,6 +21,8 @@
 #include <linux/completion.h>
 #include <linux/workqueue.h>
 #include <linux/kobject.h>
+#include <linux/of.h>
+#include <linux/mfd/core.h>
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/abx500/ux500_chargalg.h>
 #include <linux/mfd/abx500/ab8500-bm.h>
@@ -205,7 +207,6 @@ enum maxim_ret {
  * @chg_info:		information about connected charger types
  * @batt_data:		data of the battery
  * @susp_status:	current charger suspension status
- * @pdata:		pointer to the abx500_chargalg platform data
  * @bat:		pointer to the abx500_bm platform data
  * @chargalg_psy:	structure that holds the battery properties exposed by
  *			the charging algorithm
@@ -231,7 +232,6 @@ struct abx500_chargalg {
 	struct abx500_chargalg_charger_info chg_info;
 	struct abx500_chargalg_battery_data batt_data;
 	struct abx500_chargalg_suspension_status susp_status;
-	struct abx500_bmdevs_plat_data *pdata;
 	struct abx500_bm_data *bat;
 	struct power_supply chargalg_psy;
 	struct ux500_charger *ac_chg;
@@ -1795,35 +1795,55 @@ static int __devexit abx500_chargalg_remove(struct platform_device *pdev)
 	flush_scheduled_work();
 	power_supply_unregister(&di->chargalg_psy);
 	platform_set_drvdata(pdev, NULL);
-	kfree(di);
 
 	return 0;
 }
 
+static char *supply_interface[] = {
+	"ab8500_fg",
+};
+
 static int __devinit abx500_chargalg_probe(struct platform_device *pdev)
 {
-	struct abx500_bmdevs_plat_data *plat_data;
+	struct device_node *np = pdev->dev.of_node;
+	struct abx500_chargalg *di;
 	int ret = 0;
 
-	struct abx500_chargalg *di =
-		kzalloc(sizeof(struct abx500_chargalg), GFP_KERNEL);
-	if (!di)
+	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
+	if (!di) {
+		dev_err(&pdev->dev, "%s no mem for ab8500_chargalg\n",
+			__func__);
 		return -ENOMEM;
+	}
+
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
+			dev_err(&pdev->dev, "missing dt node for ab8500_chargalg\n");
+			return -EINVAL;
+		}
+	} else {
+		dev_info(&pdev->dev, "falling back to legacy platform data\n");
+	}
 
 	/* get device struct */
 	di->dev = &pdev->dev;
 
-	plat_data = pdev->dev.platform_data;
-	di->pdata = plat_data;
-
 	/* chargalg supply */
 	di->chargalg_psy.name = "abx500_chargalg";
 	di->chargalg_psy.type = POWER_SUPPLY_TYPE_BATTERY;
 	di->chargalg_psy.properties = abx500_chargalg_props;
 	di->chargalg_psy.num_properties = ARRAY_SIZE(abx500_chargalg_props);
 	di->chargalg_psy.get_property = abx500_chargalg_get_property;
-	di->chargalg_psy.supplied_to = di->pdata->supplied_to;
-	di->chargalg_psy.num_supplicants = di->pdata->num_supplicants;
+	di->chargalg_psy.supplied_to = supply_interface;
+	di->chargalg_psy.num_supplicants = ARRAY_SIZE(supply_interface),
 	di->chargalg_psy.external_power_changed =
 		abx500_chargalg_external_power_changed;
 
@@ -1843,7 +1863,7 @@ static int __devinit abx500_chargalg_probe(struct platform_device *pdev)
 		create_singlethread_workqueue("abx500_chargalg_wq");
 	if (di->chargalg_wq == NULL) {
 		dev_err(di->dev, "failed to create work queue\n");
-		goto free_device_info;
+		return -ENOMEM;
 	}
 
 	/* Init work for chargalg */
@@ -1884,20 +1904,24 @@ free_psy:
 	power_supply_unregister(&di->chargalg_psy);
 free_chargalg_wq:
 	destroy_workqueue(di->chargalg_wq);
-free_device_info:
-	kfree(di);
 
 	return ret;
 }
 
+static const struct of_device_id ab8500_chargalg_match[] = {
+	{ .compatible = "stericsson,ab8500-chargalg", },
+	{ },
+};
+
 static struct platform_driver abx500_chargalg_driver = {
 	.probe = abx500_chargalg_probe,
 	.remove = __devexit_p(abx500_chargalg_remove),
 	.suspend = abx500_chargalg_suspend,
 	.resume = abx500_chargalg_resume,
 	.driver = {
-		.name = "abx500-chargalg",
+		.name = "ab8500-chargalg",
 		.owner = THIS_MODULE,
+		.of_match_table = ab8500_chargalg_match,
 	},
 };
 
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 33f2c58..2138bd3 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -274,12 +274,6 @@ struct abx500_bm_data {
 
 extern struct abx500_bm_data ab8500_bm_data;
 
-struct abx500_bmdevs_plat_data {
-	char	**supplied_to;
-	size_t	num_supplicants;
-	bool	autopower_cfg;
-};
-
 enum {
 	NTC_EXTERNAL = 0,
 	NTC_INTERNAL,
-- 
1.7.10.4

