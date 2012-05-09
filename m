Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2EIFtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:49:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:7414 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab2EIFtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:49:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163789056"
From: Jenny TC <jenny.tc@intel.com>
To: cbouatmailru@gmail.com, anton.vorontsov@linaro.org
Cc: linux-kernel@vger.kernel.org, durgadoss.r@intel.com,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCH] power_supply: Register battery as a thermal zone
Date: Wed,  9 May 2012 16:48:38 +0530
Message-Id: <1336562318-16096-1-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Battery and charger contribute to Thermals in most of the embedded
devices. So, it makes sense to identify them as Thermal zones in a
particular platform.

This patch registers a thermal zone if the power supply is reporting
a temperature property. The thermal zone will be used by platform's
thermal management solution.

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 drivers/power/power_supply_core.c |   52 ++++++++++++++++++++++++++++++++++++-
 include/linux/power_supply.h      |    3 ++
 2 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 6ad6127..ea690ba 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -17,6 +17,7 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/power_supply.h>
+#include <linux/thermal.h>
 #include "power_supply.h"
 
 /* exported for the APM Power driver, APM emulation */
@@ -169,10 +170,36 @@ static void power_supply_dev_release(struct device *dev)
 	kfree(dev);
 }
 
+#ifdef CONFIG_THERMAL
+static int power_supply_read_temp(struct thermal_zone_device *tzd,
+		unsigned long *temp)
+{
+	struct power_supply *psy;
+	union power_supply_propval val;
+	int ret;
+
+	WARN_ON(tzd == NULL);
+	psy = tzd->devdata;
+	WARN_ON(psy == NULL);
+	ret = psy->get_property(psy,
+				  POWER_SUPPLY_PROP_TEMP, &val);
+	if (!ret)
+		*temp = val.intval * 100;
+	return ret;
+}
+
+static struct thermal_zone_device_ops psy_tzd_ops = {
+	.get_temp = power_supply_read_temp,
+};
+#endif
+
 int power_supply_register(struct device *parent, struct power_supply *psy)
 {
 	struct device *dev;
 	int rc;
+#ifdef CONFIG_THERMAL
+	int i;
+#endif
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
@@ -196,7 +223,21 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 	rc = device_add(dev);
 	if (rc)
 		goto device_add_failed;
-
+#ifdef CONFIG_THERMAL
+	/* Register battery zone device psy reports temperature */
+	for (i = 0; i < psy->num_properties; i++) {
+		if (psy->properties[i] == POWER_SUPPLY_PROP_TEMP) {
+			psy->tzd = thermal_zone_device_register(
+					(char *)psy->name, 0, psy,
+					&psy_tzd_ops, 0, 0, 0, 0);
+			if (IS_ERR(psy->tzd)) {
+				rc = PTR_ERR(psy->tzd);
+				goto therm_zone_reg_failed;
+			}
+			break;
+		}
+	}
+#endif
 	rc = power_supply_create_triggers(psy);
 	if (rc)
 		goto create_triggers_failed;
@@ -206,6 +247,11 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 	goto success;
 
 create_triggers_failed:
+#ifdef CONFIG_THERMAL
+therm_zone_reg_failed:
+	if (!IS_ERR(psy->tzd))
+		thermal_zone_device_unregister(psy->tzd);
+#endif
 	device_del(dev);
 kobject_set_name_failed:
 device_add_failed:
@@ -220,6 +266,10 @@ void power_supply_unregister(struct power_supply *psy)
 	cancel_work_sync(&psy->changed_work);
 	sysfs_remove_link(&psy->dev->kobj, "powers");
 	power_supply_remove_triggers(psy);
+#ifdef CONFIG_THERMAL
+	if (psy->tzd)
+		thermal_zone_device_unregister(psy->tzd);
+#endif
 	device_unregister(psy->dev);
 }
 EXPORT_SYMBOL_GPL(power_supply_unregister);
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index c38c13d..1f58435 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -172,6 +172,9 @@ struct power_supply {
 	/* private */
 	struct device *dev;
 	struct work_struct changed_work;
+#ifdef CONFIG_THERMAL
+	struct thermal_zone_device *tzd;
+#endif
 
 #ifdef CONFIG_LEDS_TRIGGERS
 	struct led_trigger *charging_full_trig;
-- 
1.7.1

