Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab2JISOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:14:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:7942 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829Ab2JISN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:13:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,561,1344236400"; 
   d="scan'208";a="203532538"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Jenny TC <jenny.tc@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH 2/2] power_supply: Register power supply for thermal cooling device
Date: Tue,  9 Oct 2012 22:25:59 +0530
Message-Id: <1349801759-19647-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch registers the power supply as a cooling device if the
power supply has support for charge throttling.

Now with this change low level drivers need not register with
thermal framework as it is automatically done by power supply framework.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/power_supply_core.c |  100 +++++++++++++++++++++++++++++++++++++
 include/linux/power_supply.h      |    1 +
 2 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 08cc8a3..3338d49 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -216,6 +216,89 @@ static void psy_unregister_thermal(struct power_supply *psy)
 		return;
 	thermal_zone_device_unregister(psy->tzd);
 }
+
+/* thermal cooling device callbacks */
+static int ps_get_max_charge_cntl_limit(struct thermal_cooling_device *tcd,
+						unsigned long *state)
+{
+	struct power_supply *psy;
+	union power_supply_propval val;
+	int ret;
+
+	WARN_ON(tcd == NULL);
+	psy = tcd->devdata;
+	ret = psy->get_property(psy,
+		POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX, &val);
+	if (!ret)
+		*state = val.intval;
+
+	return ret;
+}
+
+static int ps_get_cur_chrage_cntl_limit(struct thermal_cooling_device *tcd,
+						unsigned long *state)
+{
+	struct power_supply *psy;
+	union power_supply_propval val;
+	int ret;
+
+	WARN_ON(tcd == NULL);
+	psy = tcd->devdata;
+	ret = psy->get_property(psy,
+		POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT, &val);
+	if (!ret)
+		*state = val.intval;
+
+	return ret;
+}
+
+static int ps_set_cur_charge_cntl_limit(struct thermal_cooling_device *tcd,
+							unsigned long state)
+{
+	struct power_supply *psy;
+	union power_supply_propval val;
+	int ret;
+
+	WARN_ON(tcd == NULL);
+	psy = tcd->devdata;
+	val.intval = state;
+	ret = psy->set_property(psy,
+		POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT, &val);
+
+	return ret;
+}
+
+static struct thermal_cooling_device_ops psy_tcd_ops = {
+	.get_max_state = ps_get_max_charge_cntl_limit,
+	.get_cur_state = ps_get_cur_chrage_cntl_limit,
+	.set_cur_state = ps_set_cur_charge_cntl_limit,
+};
+
+static int psy_register_cooler(struct power_supply *psy)
+{
+	int i;
+
+	/* Register for cooling device if psy can control charging */
+	for (i = 0; i < psy->num_properties; i++) {
+		if (psy->properties[i] ==
+				POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT) {
+			psy->tcd = thermal_cooling_device_register(
+							(char *)psy->name,
+							psy, &psy_tcd_ops);
+			if (IS_ERR(psy->tcd))
+				return PTR_ERR(psy->tcd);
+			break;
+		}
+	}
+	return 0;
+}
+
+static void psy_unregister_cooler(struct power_supply *psy)
+{
+	if (IS_ERR_OR_NULL(psy->tcd))
+		return;
+	thermal_cooling_device_unregister(psy->tcd);
+}
 #else
 static int psy_register_thermal(struct power_supply *psy)
 {
@@ -225,6 +308,16 @@ static int psy_register_thermal(struct power_supply *psy)
 static void psy_unregister_thermal(struct power_supply *psy)
 {
 }
+
+static int psy_register_cooler(struct power_supply *psy)
+{
+	return 0;
+}
+
+static void psy_unregister_cooler(struct power_supply *psy)
+{
+
+}
 #endif
 
 int power_supply_register(struct device *parent, struct power_supply *psy)
@@ -259,6 +352,10 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 	if (rc)
 		goto register_thermal_failed;
 
+	rc = psy_register_cooler(psy);
+	if (rc)
+		goto register_cooler_failed;
+
 	rc = power_supply_create_triggers(psy);
 	if (rc)
 		goto create_triggers_failed;
@@ -268,6 +365,8 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 	goto success;
 
 create_triggers_failed:
+	psy_unregister_cooler(psy);
+register_cooler_failed:
 	psy_unregister_thermal(psy);
 register_thermal_failed:
 	device_del(dev);
@@ -284,6 +383,7 @@ void power_supply_unregister(struct power_supply *psy)
 	cancel_work_sync(&psy->changed_work);
 	sysfs_remove_link(&psy->dev->kobj, "powers");
 	power_supply_remove_triggers(psy);
+	psy_unregister_cooler(psy);
 	psy_unregister_thermal(psy);
 	device_unregister(psy->dev);
 }
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 445b4b2..1f0ab90 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -188,6 +188,7 @@ struct power_supply {
 	struct work_struct changed_work;
 #ifdef CONFIG_THERMAL
 	struct thermal_zone_device *tzd;
+	struct thermal_cooling_device *tcd;
 #endif
 
 #ifdef CONFIG_LEDS_TRIGGERS
-- 
1.7.0.4

