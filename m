Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252Ab2K0Iyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:54:46 -0500
Received: from mga14.intel.com ([143.182.124.37]:45801 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758396Ab2K0Iyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:54:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,326,1352102400"; 
   d="scan'208";a="222873895"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Jenny TC <jenny.tc@intel.com>, Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 1/2] power_supply: Add charge control struct in power supply class
Date: Tue, 27 Nov 2012 13:09:05 +0530
Message-Id: <1354001946-24509-2-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1354001946-24509-1-git-send-email-ramakrishna.pallala@intel.com>
References: <1354001946-24509-1-git-send-email-ramakrishna.pallala@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds power supply charge control structure to power_supply struct
and add a Kconfig flag to use these controls by charger frameworks.

This patch also adds a helper function/API to return the charge control
struct to the charger frameworks.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/Kconfig             |    6 ++++++
 drivers/power/power_supply_core.c |   18 ++++++++++++++++++
 include/linux/power_supply.h      |   26 ++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 263499f..782067b 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -346,6 +346,12 @@ config AB8500_BM
 	help
 	  Say Y to include support for AB8500 battery management.
 
+config PSY_CM_LOW_LEVEL_SUPPORT
+	bool "Low level driver support for charger managers"
+	help
+	  Say Y here to enable low level power supply class drivers
+	  support for charger manager or framework.
+
 endif # POWER_SUPPLY
 
 source "drivers/power/avs/Kconfig"
diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index f984da1..0f393c6 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -158,6 +158,24 @@ struct power_supply *power_supply_get_by_name(char *name)
 }
 EXPORT_SYMBOL_GPL(power_supply_get_by_name);
 
+#ifdef CONFIG_PSY_CM_LOW_LEVEL_SUPPORT
+struct power_supply_charger_control
+		*power_supply_get_chrg_cntl_by_name(const char *name)
+{
+	struct device *dev = class_find_device(power_supply_class, NULL,
+			(char *)name, power_supply_match_device_by_name);
+
+	return dev ? ((struct power_supply *)dev_get_drvdata(dev))->chrg_cntl : NULL;
+}
+#else
+struct power_supply_charger_control
+		*power_supply_get_chrg_cntl_by_name(const char *name)
+{
+	return NULL;
+}
+#endif
+EXPORT_SYMBOL_GPL(power_supply_get_chrg_cntl_by_name);
+
 int power_supply_powers(struct power_supply *psy, struct device *dev)
 {
 	return sysfs_create_link(&psy->dev->kobj, &dev->kobj, "powers");
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 1f0ab90..35cdf2c 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -191,6 +191,10 @@ struct power_supply {
 	struct thermal_cooling_device *tcd;
 #endif
 
+#ifdef CONFIG_PSY_CM_LOW_LEVEL_SUPPORT
+	struct power_supply_charger_control *chrg_cntl;
+#endif
+
 #ifdef CONFIG_LEDS_TRIGGERS
 	struct led_trigger *charging_full_trig;
 	char *charging_full_trig_name;
@@ -224,7 +228,29 @@ struct power_supply_info {
 	int use_for_apm;
 };
 
+struct power_supply_charger_control {
+	const char *name;
+	/* get charging status */
+	int (*is_charging_enabled)(void);
+	int (*is_charger_enabled)(void);
+
+	/* set charging parameters */
+	int (*set_in_current_limit)(int uA);
+	int (*set_charge_current)(int uA);
+	int (*set_charge_voltage)(int uV);
+
+	/* control battery charging */
+	int (*enable_charging)(void);
+	int (*disable_charging)(void);
+
+	/* control VSYS or system supply */
+	int (*turnon_charger)(void);
+	int (*turnoff_charger)(void);
+};
+
 extern struct power_supply *power_supply_get_by_name(char *name);
+extern struct power_supply_charger_control
+		*power_supply_get_chrg_cntl_by_name(const char *name);
 extern void power_supply_changed(struct power_supply *psy);
 extern int power_supply_am_i_supplied(struct power_supply *psy);
 extern int power_supply_set_battery_charged(struct power_supply *psy);
-- 
1.7.0.4

