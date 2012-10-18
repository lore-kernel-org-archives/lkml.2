Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab2JRLMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:12:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:20418 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab2JRLMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:12:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="206020569"
From: Jenny TC <jenny.tc@intel.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
Cc: Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, myungjoo.ham@samsung.com,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCH 6/7] power_supply: enable charger framework callbacks
Date: Thu, 18 Oct 2012 22:14:05 +0530
Message-Id: <1350578646-3315-7-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350578646-3315-1-git-send-email-jenny.tc@intel.com>
References: <1350578646-3315-1-git-send-email-jenny.tc@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The charger framework needs to be notified on registering
a new charger, on power supply changed event or on a thermal
throttle request. This patch enables support for the same
Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 drivers/power/power_supply.h      |   20 ++++++++++++++++++++
 drivers/power/power_supply_core.c |   12 ++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/power/power_supply.h b/drivers/power/power_supply.h
index cc439fd..ae2d66c 100644
--- a/drivers/power/power_supply.h
+++ b/drivers/power/power_supply.h
@@ -40,3 +40,23 @@ static inline int power_supply_create_triggers(struct power_supply *psy)
 static inline void power_supply_remove_triggers(struct power_supply *psy) {}
 
 #endif /* CONFIG_LEDS_TRIGGERS */
+#ifdef CONFIG_POWER_SUPPLY_CHARGER
+
+extern void power_supply_trigger_charging_handler(struct power_supply *psy);
+extern int power_supply_register_charger(struct power_supply *psy);
+extern int power_supply_unregister_charger(struct power_supply *psy);
+extern int psy_charger_throttle_charger(struct power_supply *psy,
+					unsigned long state);
+
+#else
+
+static inline void power_supply_trigger_charging_handler(struct power_supply *psy) { }
+static inline int power_supply_register_charger(struct power_supply *psy) 
+{ return 0; }
+static inline int power_supply_unregister_charger(struct power_supply *psy) 
+{ return 0; }
+static inline int psy_charger_throttle_charger(struct power_supply *psy,
+					unsigned long state)
+{ return 0; }
+
+#endif
diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 3338d49..73ac6e4 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -19,6 +19,7 @@
 #include <linux/power_supply.h>
 #include <linux/thermal.h>
 #include "power_supply.h"
+#include "power_supply_charger.h"
 
 /* exported for the APM Power driver, APM emulation */
 struct class *power_supply_class;
@@ -49,6 +50,7 @@ static void power_supply_changed_work(struct work_struct *work)
 
 	class_for_each_device(power_supply_class, NULL, psy,
 			      __power_supply_changed_work);
+		power_supply_trigger_charging_handler(psy);
 
 	power_supply_update_leds(psy);
 
@@ -265,6 +267,8 @@ static int ps_set_cur_charge_cntl_limit(struct thermal_cooling_device *tcd,
 	ret = psy->set_property(psy,
 		POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT, &val);
 
+	psy_charger_throttle_charger(psy,state);	
+
 	return ret;
 }
 
@@ -360,10 +364,16 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 	if (rc)
 		goto create_triggers_failed;
 
+	if (IS_CHARGER(psy))
+		rc = power_supply_register_charger(psy);
+	if (rc)
+		goto charger_register_failed;
+
 	power_supply_changed(psy);
 
 	goto success;
 
+charger_register_failed:
 create_triggers_failed:
 	psy_unregister_cooler(psy);
 register_cooler_failed:
@@ -382,6 +392,8 @@ void power_supply_unregister(struct power_supply *psy)
 {
 	cancel_work_sync(&psy->changed_work);
 	sysfs_remove_link(&psy->dev->kobj, "powers");
+	if (IS_CHARGER(psy))
+		 power_supply_unregister_charger(psy);
 	power_supply_remove_triggers(psy);
 	psy_unregister_cooler(psy);
 	psy_unregister_thermal(psy);
-- 
1.7.9.5

