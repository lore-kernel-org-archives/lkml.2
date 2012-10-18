Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2JRLM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:12:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:20418 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab2JRLM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:12:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="206020479"
From: Jenny TC <jenny.tc@intel.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
Cc: Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, myungjoo.ham@samsung.com,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCH 2/7] power_supply: Add charger control properties
Date: Thu, 18 Oct 2012 22:14:01 +0530
Message-Id: <1350578646-3315-3-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350578646-3315-1-git-send-email-jenny.tc@intel.com>
References: <1350578646-3315-1-git-send-email-jenny.tc@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The battery charger needs to have control path along
with the reporting charger properties. In existing solutions
this is implemented using regulator framework. A regulator
framework doesn't fit a charger driver requirement because of the
following reason
Charger needs support two paths - charger path (charger to platform)
and charging (charger to battery).Disabling the charging path alone
(eg over battery temperature) will allow the platform to work with
power from charger without discharging the battery. And the charger
may need to be disabled completely based on the charger temperature
or the platform temperature.
Charger has more than one pair of voltage/current to control (CC,CV,INLMT)
These features will not directly fit in the regulator framework

Since the charger driver sits in the power supply subsystem it make sense
to add the properties to control the charger.

Also this patch adds/modify the power supply properties to meet the
requirements for charger control

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 drivers/power/power_supply_sysfs.c |   16 ++++++++++++----
 include/linux/power_supply.h       |   24 ++++++++++++++++--------
 2 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 40fa3b7..3166d00 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -160,12 +160,13 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(charge_now),
 	POWER_SUPPLY_ATTR(charge_avg),
 	POWER_SUPPLY_ATTR(charge_counter),
-	POWER_SUPPLY_ATTR(constant_charge_current),
-	POWER_SUPPLY_ATTR(constant_charge_current_max),
-	POWER_SUPPLY_ATTR(constant_charge_voltage),
-	POWER_SUPPLY_ATTR(constant_charge_voltage_max),
+	POWER_SUPPLY_ATTR(charge_current),
+	POWER_SUPPLY_ATTR(max_charge_current),
+	POWER_SUPPLY_ATTR(charge_voltage),
+	POWER_SUPPLY_ATTR(max_charge_voltage),
 	POWER_SUPPLY_ATTR(charge_control_limit),
 	POWER_SUPPLY_ATTR(charge_control_limit_max),
+	POWER_SUPPLY_ATTR(input_cur_limit),
 	POWER_SUPPLY_ATTR(energy_full_design),
 	POWER_SUPPLY_ATTR(energy_empty_design),
 	POWER_SUPPLY_ATTR(energy_full),
@@ -177,6 +178,8 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(capacity_alert_max),
 	POWER_SUPPLY_ATTR(capacity_level),
 	POWER_SUPPLY_ATTR(temp),
+	POWER_SUPPLY_ATTR(max_temp),
+	POWER_SUPPLY_ATTR(min_temp),
 	POWER_SUPPLY_ATTR(temp_alert_min),
 	POWER_SUPPLY_ATTR(temp_alert_max),
 	POWER_SUPPLY_ATTR(temp_ambient),
@@ -188,6 +191,11 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(time_to_full_avg),
 	POWER_SUPPLY_ATTR(type),
 	POWER_SUPPLY_ATTR(scope),
+	POWER_SUPPLY_ATTR(charge_term_cur),
+	POWER_SUPPLY_ATTR(enable_charging),
+	POWER_SUPPLY_ATTR(enable_charger),
+	POWER_SUPPLY_ATTR(cable_type),
+	POWER_SUPPLY_ATTR(priority),
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_ATTR(model_name),
 	POWER_SUPPLY_ATTR(manufacturer),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 1f0ab90..7c06956 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -110,12 +110,13 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_CHARGE_NOW,
 	POWER_SUPPLY_PROP_CHARGE_AVG,
 	POWER_SUPPLY_PROP_CHARGE_COUNTER,
-	POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT,
-	POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX,
-	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE,
-	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX,
+	POWER_SUPPLY_PROP_CHARGE_CURRENT,
+	POWER_SUPPLY_PROP_MAX_CHARGE_CURRENT,
+	POWER_SUPPLY_PROP_CHARGE_VOLTAGE,
+	POWER_SUPPLY_PROP_MAX_CHARGE_VOLTAGE,
 	POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT,
 	POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX,
+	POWER_SUPPLY_PROP_INLMT,
 	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_FULL,
@@ -127,6 +128,8 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_CAPACITY_ALERT_MAX, /* in percents! */
 	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
 	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_MAX_TEMP,
+	POWER_SUPPLY_PROP_MIN_TEMP,
 	POWER_SUPPLY_PROP_TEMP_ALERT_MIN,
 	POWER_SUPPLY_PROP_TEMP_ALERT_MAX,
 	POWER_SUPPLY_PROP_TEMP_AMBIENT,
@@ -138,6 +141,11 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
 	POWER_SUPPLY_PROP_TYPE, /* use power_supply.type instead */
 	POWER_SUPPLY_PROP_SCOPE,
+	POWER_SUPPLY_PROP_CHARGE_TERM_CUR,
+	POWER_SUPPLY_PROP_ENABLE_CHARGING,
+	POWER_SUPPLY_PROP_ENABLE_CHARGER,
+	POWER_SUPPLY_PROP_CABLE_TYPE,
+	POWER_SUPPLY_PROP_PRIORITY,
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
@@ -253,8 +261,8 @@ static inline bool power_supply_is_amp_property(enum power_supply_property psp)
 	case POWER_SUPPLY_PROP_CHARGE_NOW:
 	case POWER_SUPPLY_PROP_CHARGE_AVG:
 	case POWER_SUPPLY_PROP_CHARGE_COUNTER:
-	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT:
-	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX:
+	case POWER_SUPPLY_PROP_CHARGE_CURRENT:
+	case POWER_SUPPLY_PROP_MAX_CHARGE_CURRENT:
 	case POWER_SUPPLY_PROP_CURRENT_MAX:
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 	case POWER_SUPPLY_PROP_CURRENT_AVG:
@@ -281,9 +289,9 @@ static inline bool power_supply_is_watt_property(enum power_supply_property psp)
 	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+	case POWER_SUPPLY_PROP_CHARGE_VOLTAGE:
 	case POWER_SUPPLY_PROP_VOLTAGE_OCV:
-	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE:
-	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX:
+	case POWER_SUPPLY_PROP_MAX_CHARGE_VOLTAGE:
 	case POWER_SUPPLY_PROP_POWER_NOW:
 		return 1;
 	default:
-- 
1.7.9.5

