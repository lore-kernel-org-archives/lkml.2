Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab2GLGEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:04:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49792 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab2GLGD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:03:59 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-7f-4ffe68b5691e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: cbouatmailru@gmail.com, jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/2] charger-manager: Use EXTCON Subsystem to detect charger
 cables for charging
Date: Thu, 12 Jul 2012 15:03:25 +0900
Message-id: <1342073005-9425-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t9jAd2tGf/8DV79U7C4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZT1c1sxW89qmYPnEWSwPjGbsuRg4OCQETiYObvLoYOYFMMYkL
	99azdTFycQgJLGKUWPBsISuEs5RJYuPDeWwgVWwCWhL7X9wAs0UE5CRer/3LBFLELHCKUeLR
	xRPMIFOFBZIkllzyBalhEVCV6L49lxnE5hVwkbh5ezk7xDYFidZlh9gnMHIvYGRYxSiaWpBc
	UJyUnmukV5yYW1yal66XnJ+7iRHswWfSOxhXNVgcYhTgYFTi4b0Q+c9fiDWxrLgy9xCjBAez
	kgivI0iINyWxsiq1KD++qDQntfgQozQHi5I4r4n3V38hgfTEktTs1NSC1CKYLBMHp1QDY4zb
	Y6+2c2v2lrbYfTqoYrPoxZs2pSulrz5zz/nlvnvxOcFvgsmV3wRmyP3ruHPgZ5X43/iXMf+M
	rMoEF28qDmPYVaiRIlI04bL/3Rm80tu//crrlVDIc51iqdJs+jTTL+FhrU5HmkIxV1Hq8r9p
	55Xrr/A9ZPtxfGNk+r//u6/FNCT+4Uj4rsRSnJFoqMVcVJwIAF1nKKTcAQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch support that charger-manager use EXTCON(External Connector)
Subsystem to detect the state of charger cables for enabling or disabling
charger(regulator) and select the charger cable for charging among
a number of external cable according to policy of H/W board.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/charger-manager.c       |  137 +++++++++++++++++++++++++++++----
 include/linux/power/charger-manager.h |   59 ++++++++++++++-
 2 files changed, 179 insertions(+), 17 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 86935ec..af03f23 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -271,16 +271,13 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 	if (enable) {
 		if (cm->emergency_stop)
 			return -EAGAIN;
-		err = regulator_bulk_enable(desc->num_charger_regulators,
-					desc->charger_regulators);
+		for (i = 0 ; i < desc->num_charger_regulators ; i++)
+			regulator_enable(desc->charger_regulators[i].consumer);
 	} else {
 		/*
 		 * Abnormal battery state - Stop charging forcibly,
 		 * even if charger was enabled at the other places
 		 */
-		err = regulator_bulk_disable(desc->num_charger_regulators,
-					desc->charger_regulators);
-
 		for (i = 0; i < desc->num_charger_regulators; i++) {
 			if (regulator_is_enabled(
 				    desc->charger_regulators[i].consumer)) {
@@ -288,7 +285,7 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 					desc->charger_regulators[i].consumer);
 				dev_warn(cm->dev,
 					"Disable regulator(%s) forcibly.\n",
-					desc->charger_regulators[i].supply);
+					desc->charger_regulators[i].regulator_name);
 			}
 		}
 	}
@@ -994,11 +991,77 @@ int setup_charger_manager(struct charger_global_desc *gd)
 }
 EXPORT_SYMBOL_GPL(setup_charger_manager);
 
+/**
+ * charger_extcon_work - enable/diable charger according to the state
+ *			of charger cable
+ *
+ * @work: work_struct of the function charger_extcon_work.
+ */
+static void charger_extcon_work(struct work_struct *work)
+{
+	struct charger_cable *cable =
+			container_of(work, struct charger_cable, wq);
+
+	try_charger_enable(cable->cm, cable->attached);
+}
+
+/**
+ * charger_extcon_notifier - receive the state of charger cable
+ *			when registered cable is attached or detached.
+ *
+ * @self: the notifier block of the charger_extcon_notifier.
+ * @event: the cable state.
+ * @ptr: the data pointer of notifier block.
+ */
+static int charger_extcon_notifier(struct notifier_block *self,
+			unsigned long event, void *ptr)
+{
+	struct charger_cable *cable =
+		container_of(self, struct charger_cable, nb);
+
+	cable->attached = event;
+	schedule_work(&cable->wq);
+
+	return NOTIFY_DONE;
+}
+
+/**
+ * charger_extcon_init - register external connector to use it
+ *			as the charger cable
+ *
+ * @cm: the Charger Manager representing the battery.
+ * @cable: the Charger cable representing the external connector.
+ */
+static int charger_extcon_init(struct charger_manager *cm,
+		struct charger_cable *cable)
+ {
+	int ret = 0;
+
+	/*
+	 * Charger manager use Extcon framework to identify
+	 * the charger cable among various external connector
+	 * cable (e.g., TA, USB, MHL, Dock).
+	 */
+	INIT_WORK(&cable->wq, charger_extcon_work);
+	cable->nb.notifier_call = charger_extcon_notifier;
+	ret = extcon_register_interest(&cable->extcon_dev,
+			cable->extcon_name, cable->name, &cable->nb);
+	if (ret < 0) {
+		pr_info("Cannot register extcon_dev for %s(cable: %s).\n",
+				cable->extcon_name,
+				cable->name);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
 static int charger_manager_probe(struct platform_device *pdev)
 {
 	struct charger_desc *desc = dev_get_platdata(&pdev->dev);
 	struct charger_manager *cm;
 	int ret = 0, i = 0;
+	int j = 0;
 	union power_supply_propval val;
 
 	if (g_desc && !rtc_dev && g_desc->rtc_name) {
@@ -1167,11 +1230,31 @@ static int charger_manager_probe(struct platform_device *pdev)
 		goto err_register;
 	}
 
-	ret = regulator_bulk_get(&pdev->dev, desc->num_charger_regulators,
-				 desc->charger_regulators);
-	if (ret) {
-		dev_err(&pdev->dev, "Cannot get charger regulators.\n");
-		goto err_bulk_get;
+	for (i = 0 ; i < desc->num_charger_regulators ; i++) {
+		struct charger_regulator *charger
+					= &desc->charger_regulators[i];
+
+		charger->consumer = regulator_get(&pdev->dev,
+					charger->regulator_name);
+		if (charger->consumer == NULL) {
+			dev_err(&pdev->dev, "Cannot find charger(%s)n",
+						charger->regulator_name);
+			ret = -EINVAL;
+			goto err_chg_get;
+		}
+
+		for (j = 0 ; j < charger->num_cables ; j++) {
+			struct charger_cable *cable = &charger->cables[j];
+
+			ret = charger_extcon_init(cm, cable);
+			if (ret < 0) {
+				dev_err(&pdev->dev, "Cannot find charger(%s)n",
+						charger->regulator_name);
+				goto err_extcon;
+			}
+			cable->charger = charger;
+			cable->cm = cm;
+		}
 	}
 
 	ret = try_charger_enable(cm, true);
@@ -1197,9 +1280,19 @@ static int charger_manager_probe(struct platform_device *pdev)
 	return 0;
 
 err_chg_enable:
-	regulator_bulk_free(desc->num_charger_regulators,
-			    desc->charger_regulators);
-err_bulk_get:
+err_extcon:
+	for (i = 0 ; i < desc->num_charger_regulators ; i++) {
+		struct charger_regulator *charger
+				= &desc->charger_regulators[i];
+		for (j = 0 ; j < charger->num_cables ; j++) {
+			struct charger_cable *cable = &charger->cables[j];
+			extcon_unregister_interest(&cable->extcon_dev);
+		}
+	}
+err_chg_get:
+	for (i = 0 ; i < desc->num_charger_regulators ; i++)
+		regulator_put(desc->charger_regulators[i].consumer);
+
 	power_supply_unregister(&cm->charger_psy);
 err_register:
 	kfree(cm->charger_psy.properties);
@@ -1218,6 +1311,8 @@ static int __devexit charger_manager_remove(struct platform_device *pdev)
 {
 	struct charger_manager *cm = platform_get_drvdata(pdev);
 	struct charger_desc *desc = cm->desc;
+	int i = 0;
+	int j = 0;
 
 	/* Remove from the list */
 	mutex_lock(&cm_list_mtx);
@@ -1229,8 +1324,18 @@ static int __devexit charger_manager_remove(struct platform_device *pdev)
 	if (delayed_work_pending(&cm_monitor_work))
 		cancel_delayed_work_sync(&cm_monitor_work);
 
-	regulator_bulk_free(desc->num_charger_regulators,
-			    desc->charger_regulators);
+	for (i = 0 ; i < desc->num_charger_regulators ; i++) {
+		struct charger_regulator *charger
+				= &desc->charger_regulators[i];
+		for (j = 0 ; j < charger->num_cables ; j++) {
+			struct charger_cable *cable = &charger->cables[j];
+			extcon_unregister_interest(&cable->extcon_dev);
+		}
+	}
+
+	for (i = 0 ; i < desc->num_charger_regulators ; i++)
+		regulator_put(desc->charger_regulators[i].consumer);
+
 	power_supply_unregister(&cm->charger_psy);
 
 	try_charger_enable(cm, false);
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index 241065c..6cb9fbc 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -16,6 +16,7 @@
 #define _CHARGER_MANAGER_H
 
 #include <linux/power_supply.h>
+#include <linux/extcon.h>
 
 enum data_source {
 	CM_BATTERY_PRESENT,
@@ -65,6 +66,62 @@ struct charger_global_desc {
 };
 
 /**
+ * struct charger_cable
+ * @extcon_name: the name of extcon device.
+ * @name: the name of charger cable(external connector).
+ * @extcon_dev: the extcon device.
+ * @wq: the workqueue to control charger according to the state of
+ *	charger cable. If charger cable is attached, enable charger.
+ *	But if charger cable is detached, disable charger.
+ * @nb: the notifier block to receive changed state from EXTCON
+ *	(External Connector) when charger cable is attached/detached.
+ * @attached: the state of charger cable.
+ *	true: the charger cable is attached
+ *	false: the charger cable is detached
+ * @charger: the instance of struct charger_regulator.
+ * @cm: the Charger Manager representing the battery.
+ */
+struct charger_cable {
+	const char *extcon_name;
+	const char *name;
+
+	/* The charger-manager use Exton framework*/
+	struct extcon_specific_cable_nb extcon_dev;
+	struct work_struct wq;
+	struct notifier_block nb;
+
+	/* The state of charger cable */
+	bool attached;
+
+	struct charger_regulator *charger;
+	struct charger_manager *cm;
+};
+
+/**
+ * struct charger_regulator
+ * @regulator_name: the name of regulator for using charger.
+ * @consumer: the regulator consumer for the charger.
+ * @cables:
+ *	the array of charger cables to enable/disable charger
+ *	and set current limit according to constratint data of
+ *	struct charger_cable if only charger cable included
+ *	in the array of charger cables is attached/detached.
+ * @num_cables: the number of charger cables.
+ */
+struct charger_regulator {
+	/* The name of regulator for charging */
+	const char *regulator_name;
+	struct regulator *consumer;
+
+	/*
+	 * Store constraint information related to current limit,
+	 * each cable have different condition for charging.
+	 */
+	struct charger_cable *cables;
+	int num_cables;
+};
+
+/**
  * struct charger_desc
  * @psy_name: the name of power-supply-class for charger manager
  * @polling_mode:
@@ -109,7 +166,7 @@ struct charger_desc {
 	char **psy_charger_stat;
 
 	int num_charger_regulators;
-	struct regulator_bulk_data *charger_regulators;
+	struct charger_regulator *charger_regulators;
 
 	char *psy_fuel_gauge;
 
-- 
1.7.0.4

