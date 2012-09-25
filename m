Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab2IYQWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:22:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758Ab2IYQNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:40 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 23/57] power: Add plaform data charger configurables
Date: Tue, 25 Sep 2012 10:12:20 -0600
Message-Id: <1348589574-25655-24-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Loic Pallardy <loic.pallardy@stericsson.com>

Allow to indicate wheter AC and USB charge capabilities are
supported from platform data.

Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-on: http://gerrit.lud.stericsson.com/gerrit/58093
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Olivier CLERGEAUD <olivier.clergeaud@stericsson.com>
---
 drivers/power/ab8500_charger.c            |   36 ++++++++++++++++++----------
 include/linux/mfd/abx500.h                |    2 +
 include/linux/mfd/abx500/ux500_chargalg.h |    2 +
 3 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index cbc9fd7..3100f11 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -2878,8 +2878,11 @@ static int __devexit ab8500_charger_remove(struct platform_device *pdev)
 	destroy_workqueue(di->charger_wq);
 
 	flush_scheduled_work();
-	power_supply_unregister(&di->usb_chg.psy);
-	power_supply_unregister(&di->ac_chg.psy);
+	if (di->usb_chg.enabled)
+		power_supply_unregister(&di->usb_chg.psy);
+	if (di->ac_chg.enabled)
+		power_supply_unregister(&di->ac_chg.psy);
+
 	platform_set_drvdata(pdev, NULL);
 	kfree(di);
 
@@ -2942,6 +2945,7 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 		ARRAY_SIZE(ab8500_charger_voltage_map) - 1];
 	di->ac_chg.max_out_curr = ab8500_charger_current_map[
 		ARRAY_SIZE(ab8500_charger_current_map) - 1];
+	di->ac_chg.enabled = di->pdata->ac_enabled;
 
 	/* USB supply */
 	/* power_supply base class */
@@ -2960,7 +2964,7 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 		ARRAY_SIZE(ab8500_charger_voltage_map) - 1];
 	di->usb_chg.max_out_curr = ab8500_charger_current_map[
 		ARRAY_SIZE(ab8500_charger_current_map) - 1];
-
+	di->usb_chg.enabled = di->pdata->usb_enabled;
 
 	/* Create a work queue for the charger */
 	di->charger_wq =
@@ -3036,17 +3040,21 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	}
 
 	/* Register AC charger class */
-	ret = power_supply_register(di->dev, &di->ac_chg.psy);
-	if (ret) {
-		dev_err(di->dev, "failed to register AC charger\n");
-		goto free_regulator;
+	if (di->ac_chg.enabled) {
+		ret = power_supply_register(di->dev, &di->ac_chg.psy);
+		if (ret) {
+			dev_err(di->dev, "failed to register AC charger\n");
+			goto free_regulator;
+		}
 	}
 
 	/* Register USB charger class */
-	ret = power_supply_register(di->dev, &di->usb_chg.psy);
-	if (ret) {
-		dev_err(di->dev, "failed to register USB charger\n");
-		goto free_ac;
+	if (di->usb_chg.enabled) {
+		ret = power_supply_register(di->dev, &di->usb_chg.psy);
+		if (ret) {
+			dev_err(di->dev, "failed to register USB charger\n");
+			goto free_ac;
+		}
 	}
 
 	di->usb_phy = usb_get_phy(USB_PHY_TYPE_USB2);
@@ -3122,9 +3130,11 @@ free_irq:
 put_usb_phy:
 	usb_put_phy(di->usb_phy);
 free_usb:
-	power_supply_unregister(&di->usb_chg.psy);
+	if (di->usb_chg.enabled)
+		power_supply_unregister(&di->usb_chg.psy);
 free_ac:
-	power_supply_unregister(&di->ac_chg.psy);
+	if (di->ac_chg.enabled)
+		power_supply_unregister(&di->ac_chg.psy);
 free_regulator:
 	regulator_put(di->regu);
 free_charger_wq:
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 4d44a10..eef1ddc 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -398,6 +398,8 @@ struct abx500_charger_platform_data {
 	char **supplied_to;
 	size_t num_supplicants;
 	bool autopower_cfg;
+	bool ac_enabled;
+	bool usb_enabled;
 };
 
 struct abx500_btemp_platform_data {
diff --git a/include/linux/mfd/abx500/ux500_chargalg.h b/include/linux/mfd/abx500/ux500_chargalg.h
index 9b07725..5b77a61 100644
--- a/include/linux/mfd/abx500/ux500_chargalg.h
+++ b/include/linux/mfd/abx500/ux500_chargalg.h
@@ -27,12 +27,14 @@ struct ux500_charger_ops {
  * @ops			ux500 charger operations
  * @max_out_volt	maximum output charger voltage in mV
  * @max_out_curr	maximum output charger current in mA
+ * @enabled		indicates if this charger is used or not
  */
 struct ux500_charger {
 	struct power_supply psy;
 	struct ux500_charger_ops ops;
 	int max_out_volt;
 	int max_out_curr;
+	bool enabled;
 };
 
 #endif
-- 
1.7.5.4

