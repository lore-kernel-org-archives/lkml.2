Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2ALE5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 23:57:00 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61540 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab2ALE45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 23:56:57 -0500
Message-ID: <1326344195.7311.1.camel@phoenix>
Subject: [PATCH] power_supply: charger-manager: Clean up for better
 readability
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>
Date: Thu, 12 Jan 2012 12:56:35 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below changes:

* Some code change for better readability.
* Current code in probe already ensures desc->charger_regulators is not NULL.
  No need to check if it is NULL or not before calling regulator_bulk_free().
* Use dev_get_drvdata() in cm_suspend_prepare() and cm_suspend_complete()

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/charger-manager.c |   61 ++++++++++++++++----------------------
 1 files changed, 26 insertions(+), 35 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 88fd971..e610e6b 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -134,12 +134,11 @@ static int get_batt_uV(struct charger_manager *cm, int *uV)
 	union power_supply_propval val;
 	int ret;
 
-	if (cm->fuel_gauge)
-		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
-				POWER_SUPPLY_PROP_VOLTAGE_NOW, &val);
-	else
+	if (!cm->fuel_gauge)
 		return -ENODEV;
 
+	ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
+				POWER_SUPPLY_PROP_VOLTAGE_NOW, &val);
 	if (ret)
 		return ret;
 
@@ -245,9 +244,7 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 	struct charger_desc *desc = cm->desc;
 
 	/* Ignore if it's redundent command */
-	if (enable && cm->charger_enabled)
-		return 0;
-	if (!enable && !cm->charger_enabled)
+	if (enable == cm->charger_enabled)
 		return 0;
 
 	if (enable) {
@@ -309,9 +306,7 @@ static void uevent_notify(struct charger_manager *cm, const char *event)
 
 		if (!strncmp(env_str_save, event, UEVENT_BUF_SIZE))
 			return; /* Duplicated. */
-		else
-			strncpy(env_str_save, event, UEVENT_BUF_SIZE);
-
+		strncpy(env_str_save, event, UEVENT_BUF_SIZE);
 		return;
 	}
 
@@ -387,8 +382,10 @@ static bool cm_monitor(void)
 
 	mutex_lock(&cm_list_mtx);
 
-	list_for_each_entry(cm, &cm_list, entry)
-		stop = stop || _cm_monitor(cm);
+	list_for_each_entry(cm, &cm_list, entry) {
+		if (_cm_monitor(cm))
+			stop = true;
+	}
 
 	mutex_unlock(&cm_list_mtx);
 
@@ -697,8 +694,10 @@ bool cm_suspend_again(void)
 	mutex_lock(&cm_list_mtx);
 	list_for_each_entry(cm, &cm_list, entry) {
 		if (cm->status_save_ext_pwr_inserted != is_ext_pwr_online(cm) ||
-		    cm->status_save_batt != is_batt_present(cm))
+		    cm->status_save_batt != is_batt_present(cm)) {
 			ret = false;
+			break;
+		}
 	}
 	mutex_unlock(&cm_list_mtx);
 
@@ -855,11 +854,10 @@ static int charger_manager_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, cm);
 
-	memcpy(&cm->charger_psy, &psy_default,
-				sizeof(psy_default));
+	memcpy(&cm->charger_psy, &psy_default, sizeof(psy_default));
+
 	if (!desc->psy_name) {
-		strncpy(cm->psy_name_buf, psy_default.name,
-				PSY_NAME_MAX);
+		strncpy(cm->psy_name_buf, psy_default.name, PSY_NAME_MAX);
 	} else {
 		strncpy(cm->psy_name_buf, desc->psy_name, PSY_NAME_MAX);
 	}
@@ -894,15 +892,15 @@ static int charger_manager_probe(struct platform_device *pdev)
 				POWER_SUPPLY_PROP_CURRENT_NOW;
 		cm->charger_psy.num_properties++;
 	}
-	if (!desc->measure_battery_temp) {
-		cm->charger_psy.properties[cm->charger_psy.num_properties] =
-				POWER_SUPPLY_PROP_TEMP_AMBIENT;
-		cm->charger_psy.num_properties++;
-	}
+
 	if (desc->measure_battery_temp) {
 		cm->charger_psy.properties[cm->charger_psy.num_properties] =
 				POWER_SUPPLY_PROP_TEMP;
 		cm->charger_psy.num_properties++;
+	} else {
+		cm->charger_psy.properties[cm->charger_psy.num_properties] =
+				POWER_SUPPLY_PROP_TEMP_AMBIENT;
+		cm->charger_psy.num_properties++;
 	}
 
 	ret = power_supply_register(NULL, &cm->charger_psy);
@@ -933,9 +931,8 @@ static int charger_manager_probe(struct platform_device *pdev)
 	return 0;
 
 err_chg_enable:
-	if (desc->charger_regulators)
-		regulator_bulk_free(desc->num_charger_regulators,
-					desc->charger_regulators);
+	regulator_bulk_free(desc->num_charger_regulators,
+			    desc->charger_regulators);
 err_bulk_get:
 	power_supply_unregister(&cm->charger_psy);
 err_register:
@@ -961,10 +958,8 @@ static int __devexit charger_manager_remove(struct platform_device *pdev)
 	list_del(&cm->entry);
 	mutex_unlock(&cm_list_mtx);
 
-	if (desc->charger_regulators)
-		regulator_bulk_free(desc->num_charger_regulators,
-					desc->charger_regulators);
-
+	regulator_bulk_free(desc->num_charger_regulators,
+			    desc->charger_regulators);
 	power_supply_unregister(&cm->charger_psy);
 	kfree(cm->charger_psy.properties);
 	kfree(cm->charger_stat);
@@ -982,9 +977,7 @@ MODULE_DEVICE_TABLE(platform, charger_manager_id);
 
 static int cm_suspend_prepare(struct device *dev)
 {
-	struct platform_device *pdev = container_of(dev, struct platform_device,
-						    dev);
-	struct charger_manager *cm = platform_get_drvdata(pdev);
+	struct charger_manager *cm = dev_get_drvdata(dev);
 
 	if (!cm_suspended) {
 		if (rtc_dev) {
@@ -1020,9 +1013,7 @@ static int cm_suspend_prepare(struct device *dev)
 
 static void cm_suspend_complete(struct device *dev)
 {
-	struct platform_device *pdev = container_of(dev, struct platform_device,
-						    dev);
-	struct charger_manager *cm = platform_get_drvdata(pdev);
+	struct charger_manager *cm = dev_get_drvdata(dev);
 
 	if (cm_suspended) {
 		if (rtc_dev) {
-- 
1.7.5.4



