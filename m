Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275Ab2K0IzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:55:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:19205 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319Ab2K0IzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:55:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,326,1352102400"; 
   d="scan'208";a="222873947"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Jenny TC <jenny.tc@intel.com>, Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 2/2] charger_manager: Enable power supply driver support for charge controls
Date: Tue, 27 Nov 2012 13:09:06 +0530
Message-Id: <1354001946-24509-3-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1354001946-24509-1-git-send-email-ramakrishna.pallala@intel.com>
References: <1354001946-24509-1-git-send-email-ramakrishna.pallala@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the charger manager support for power supply drivers.

Note: this patch does change the variable/function names in charger
manager as it is just an enabling patch. I will submit incremental patches
to clean some of naming conventions to appeal more reasonable/logical to the
source code reader/developer.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/charger-manager.c       |   23 +++++----
 include/linux/power/charger-manager.h |   84 +++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+), 11 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 8a0aca6..8f6d525 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -336,7 +336,8 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 			if (desc->charger_regulators[i].externally_control)
 				continue;
 
-			err = regulator_enable(desc->charger_regulators[i].consumer);
+			err = psy_cms_enable_charging(
+					desc->charger_regulators[i].consumer);
 			if (err < 0) {
 				dev_warn(cm->dev,
 					"Cannot enable %s regulator\n",
@@ -355,7 +356,8 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 			if (desc->charger_regulators[i].externally_control)
 				continue;
 
-			err = regulator_disable(desc->charger_regulators[i].consumer);
+			err = psy_cms_disable_charging(
+				desc->charger_regulators[i].consumer);
 			if (err < 0) {
 				dev_warn(cm->dev,
 					"Cannot disable %s regulator\n",
@@ -368,9 +370,9 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 		 * even if charger was enabled at the other places
 		 */
 		for (i = 0; i < desc->num_charger_regulators; i++) {
-			if (regulator_is_enabled(
+			if (psy_cms_is_charging_enabled(
 				    desc->charger_regulators[i].consumer)) {
-				regulator_force_disable(
+				psy_cms_force_disable_charging(
 					desc->charger_regulators[i].consumer);
 				dev_warn(cm->dev,
 					"Disable regulator(%s) forcibly.\n",
@@ -1135,8 +1137,8 @@ static void charger_extcon_work(struct work_struct *work)
 	int ret;
 
 	if (cable->attached && cable->min_uA != 0 && cable->max_uA != 0) {
-		ret = regulator_set_current_limit(cable->charger->consumer,
-					cable->min_uA, cable->max_uA);
+		ret = psy_cms_set_current_limit(cable->charger->consumer,
+						cable->min_uA, cable->max_uA);
 		if (ret < 0) {
 			pr_err("Cannot set current limit of %s (%s)\n",
 				cable->charger->regulator_name, cable->name);
@@ -1239,7 +1241,7 @@ static ssize_t charger_state_show(struct device *dev,
 	int state = 0;
 
 	if (!charger->externally_control)
-		state = regulator_is_enabled(charger->consumer);
+		state = psy_cms_is_charging_enabled(charger->consumer);
 
 	return sprintf(buf, "%s\n", state ? "enabled" : "disabled");
 }
@@ -1507,8 +1509,7 @@ static int charger_manager_probe(struct platform_device *pdev)
 					= &desc->charger_regulators[i];
 		char buf[11];
 		char *str;
-
-		charger->consumer = regulator_get(&pdev->dev,
+		charger->consumer = psy_cms_get_consumer(&pdev->dev,
 					charger->regulator_name);
 		if (charger->consumer == NULL) {
 			dev_err(&pdev->dev, "Cannot find charger(%s)n",
@@ -1639,7 +1640,7 @@ err_extcon:
 	}
 err_chg_get:
 	for (i = 0 ; i < desc->num_charger_regulators ; i++)
-		regulator_put(desc->charger_regulators[i].consumer);
+		psy_cms_put_consumer(desc->charger_regulators[i].consumer);
 
 	power_supply_unregister(&cm->charger_psy);
 err_register:
@@ -1682,7 +1683,7 @@ static int __devexit charger_manager_remove(struct platform_device *pdev)
 	}
 
 	for (i = 0 ; i < desc->num_charger_regulators ; i++)
-		regulator_put(desc->charger_regulators[i].consumer);
+		psy_cms_put_consumer(desc->charger_regulators[i].consumer);
 
 	power_supply_unregister(&cm->charger_psy);
 
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index 0e86840..f6a5b79 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -127,7 +127,11 @@ struct charger_cable {
 struct charger_regulator {
 	/* The name of regulator for charging */
 	const char *regulator_name;
+#ifdef CONFIG_PSY_CM_LOW_LEVEL_SUPPORT
+	struct power_supply_charger_control *consumer;
+#else
 	struct regulator *consumer;
+#endif
 
 	/* charger never on when system is on */
 	int externally_control;
@@ -280,4 +284,84 @@ static inline bool cm_suspend_again(void) { return false; }
 static inline void cm_notify_event(struct power_supply *psy,
 				enum cm_event_types type, char *msg) { }
 #endif
+
+#ifdef CONFIG_PSY_CM_LOW_LEVEL_SUPPORT
+static inline int psy_cms_enable_charging(
+			struct power_supply_charger_control *consumer)
+{
+	return consumer->enable_charging();
+}
+
+static inline int psy_cms_disable_charging(
+			struct power_supply_charger_control *consumer)
+{
+	return consumer->disable_charging();
+}
+
+static inline int psy_cms_force_disable_charging(
+			struct power_supply_charger_control *consumer)
+{
+	return consumer->disable_charging();
+}
+
+static inline int psy_cms_set_current_limit(struct power_supply_charger_control
+					*consumer, int min_uA, int max_uA)
+{
+	return consumer->set_in_current_limit(min_uA);
+}
+
+static inline int psy_cms_is_charging_enabled(
+			struct power_supply_charger_control *consumer)
+{
+	return consumer->is_charging_enabled();
+}
+
+static inline struct power_supply_charger_control
+		*psy_cms_get_consumer(struct device *dev, const char *name)
+{
+	return power_supply_get_chrg_cntl_by_name(name);
+}
+
+static inline void psy_cms_put_consumer(
+				struct power_supply_charger_control *consumer)
+{
+}
+#else
+static inline int psy_cms_enable_charging(struct regulator *consumer)
+{
+	return regulator_enable(consumer);
+}
+
+static inline int psy_cms_disable_charging(struct regulator *consumer)
+{
+	return regulator_disable(consumer);
+}
+
+static inline int psy_cms_force_disable_charging(struct regulator *consumer)
+{
+	return regulator_force_disable(consumer);
+}
+
+static inline int psy_cms_set_current_limit(struct regulator *consumer,
+						int min_uA, int max_uA)
+{
+	return regulator_set_current_limit(consumer, min_uA, max_uA);
+}
+
+static inline int psy_cms_is_charging_enabled(struct regulator *consumer)
+{
+	return regulator_is_enabled(consumer);
+}
+
+static inline struct regulator *psy_cms_get_consumer(struct device *dev, const char *name)
+{
+	return regulator_get(dev, name);
+}
+
+static inline void psy_cms_put_consumer(struct regulator *consumer)
+{
+	regulator_put(consumer);
+}
+#endif
+
 #endif /* _CHARGER_MANAGER_H */
-- 
1.7.0.4

