Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab2EFOOh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 10:14:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:64652 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab2EFOOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 10:14:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="162593351"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] power_supply: Add charge_current and charge_voltage properties and use it in smb347
Date: Sun,  6 May 2012 18:16:44 +0530
Message-Id: <1336308404-25129-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Constant Charge Current(CC) is charging parameter which limit the
maximum current which can be pumped into the battery during charge cycle.

Constant Charge Voltage(CV) is also charging parameter which limit the
maximum voltage that battery can reach during charge cycle.

It is very common practice that at low or high temperatures we
do not charge the batteries upto it's fullest charge voltage
to avoid battery and user safety issues.

These sysfs properties will be useful for debug and to implement
certain user space policies like "Charging limited due to OverTemp".

This patch also makes use of these two properties in smb347 charger driver.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 Documentation/power/power_supply_class.txt |    4 +
 drivers/power/power_supply_sysfs.c         |    2 +
 drivers/power/smb347-charger.c             |  123 ++++++++++++++++++++++++++--
 include/linux/power_supply.h               |    4 +
 4 files changed, 127 insertions(+), 6 deletions(-)

diff --git a/Documentation/power/power_supply_class.txt b/Documentation/power/power_supply_class.txt
index 211831d..c0f62ae 100644
--- a/Documentation/power/power_supply_class.txt
+++ b/Documentation/power/power_supply_class.txt
@@ -112,6 +112,10 @@ CHARGE_COUNTER - the current charge counter (in µAh).  This could easily
 be negative; there is no empty or full value.  It is only useful for
 relative, time-based measurements.
 
+CONSTANT_CHARGE_CURRENT - constant charge current programmed by charger.
+
+CONSTANT_CHARGE_VOLTAGE - constant charge voltage programmed by charger.
+
 ENERGY_FULL, ENERGY_EMPTY - same as above but for energy.
 
 CAPACITY - capacity in percents.
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 4150747..58846d9 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -159,6 +159,8 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(charge_now),
 	POWER_SUPPLY_ATTR(charge_avg),
 	POWER_SUPPLY_ATTR(charge_counter),
+	POWER_SUPPLY_ATTR(constant_charge_current),
+	POWER_SUPPLY_ATTR(constant_charge_voltage),
 	POWER_SUPPLY_ATTR(energy_full_design),
 	POWER_SUPPLY_ATTR(energy_empty_design),
 	POWER_SUPPLY_ATTR(energy_full),
diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
index 09d19d2..79d22b9 100644
--- a/drivers/power/smb347-charger.c
+++ b/drivers/power/smb347-charger.c
@@ -195,6 +195,14 @@ static const unsigned int ccc_tbl[] = {
 	1200000,
 };
 
+/* Convert register value to current using lookup table */
+static int hw_to_current(const unsigned int *tbl, size_t size, unsigned int val)
+{
+	if (val >= size)
+		return -EINVAL;
+	return tbl[val];
+}
+
 /* Convert current to register value using lookup table */
 static int current_to_hw(const unsigned int *tbl, size_t size, unsigned int val)
 {
@@ -840,22 +848,101 @@ fail:
 	return ret;
 }
 
+/*
+ * Returns the constant charge current programmed
+ * into the charger in uA.
+ */
+static int get_const_charge_current(struct smb347_charger *smb)
+{
+	int ret, intval;
+	unsigned int v;
+
+	if (!smb347_is_ps_online(smb))
+		return -ENODATA;
+
+	ret = regmap_read(smb->regmap, STAT_B, &v);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * The current value is composition of FCC and PCC values
+	 * and we can detect which table to use from bit 5.
+	 */
+	if (v & 0x20) {
+		intval = hw_to_current(fcc_tbl, ARRAY_SIZE(fcc_tbl), v & 7);
+	} else {
+		v >>= 3;
+		intval = hw_to_current(pcc_tbl, ARRAY_SIZE(pcc_tbl), v & 7);
+	}
+
+	return intval;
+}
+
+/*
+ * Returns the constant charge voltage programmed
+ * into the charger in uV.
+ */
+static int get_const_charge_voltage(struct smb347_charger *smb)
+{
+	int ret, intval;
+	unsigned int v;
+
+	if (!smb347_is_ps_online(smb))
+		return -ENODATA;
+
+	ret = regmap_read(smb->regmap, STAT_A, &v);
+	if (ret < 0)
+		return ret;
+
+	v &= STAT_A_FLOAT_VOLTAGE_MASK;
+	if (v > 0x3d)
+		v = 0x3d;
+
+	intval = 3500000 + v * 20000;
+
+	return intval;
+}
+
 static int smb347_mains_get_property(struct power_supply *psy,
 				     enum power_supply_property prop,
 				     union power_supply_propval *val)
 {
 	struct smb347_charger *smb =
 		container_of(psy, struct smb347_charger, mains);
+	int ret;
 
-	if (prop == POWER_SUPPLY_PROP_ONLINE) {
+	switch (prop) {
+	case POWER_SUPPLY_PROP_ONLINE:
 		val->intval = smb->mains_online;
-		return 0;
+		break;
+
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE:
+		ret = get_const_charge_voltage(smb);
+		if (ret < 0)
+			return ret;
+		else
+			val->intval = ret;
+		break;
+
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT:
+		ret = get_const_charge_current(smb);
+		if (ret < 0)
+			return ret;
+		else
+			val->intval = ret;
+		break;
+
+	default:
+		return -EINVAL;
 	}
-	return -EINVAL;
+
+	return 0;
 }
 
 static enum power_supply_property smb347_mains_properties[] = {
 	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT,
+	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE,
 };
 
 static int smb347_usb_get_property(struct power_supply *psy,
@@ -864,16 +951,40 @@ static int smb347_usb_get_property(struct power_supply *psy,
 {
 	struct smb347_charger *smb =
 		container_of(psy, struct smb347_charger, usb);
+	int ret;
 
-	if (prop == POWER_SUPPLY_PROP_ONLINE) {
+	switch (prop) {
+	case POWER_SUPPLY_PROP_ONLINE:
 		val->intval = smb->usb_online;
-		return 0;
+		break;
+
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE:
+		ret = get_const_charge_voltage(smb);
+		if (ret < 0)
+			return ret;
+		else
+			val->intval = ret;
+		break;
+
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT:
+		ret = get_const_charge_current(smb);
+		if (ret < 0)
+			return ret;
+		else
+			val->intval = ret;
+		break;
+
+	default:
+		return -EINVAL;
 	}
-	return -EINVAL;
+
+	return 0;
 }
 
 static enum power_supply_property smb347_usb_properties[] = {
 	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT,
+	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE,
 };
 
 static int smb347_battery_get_property(struct power_supply *psy,
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 3b912be..a6471bc 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -109,6 +109,8 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_CHARGE_NOW,
 	POWER_SUPPLY_PROP_CHARGE_AVG,
 	POWER_SUPPLY_PROP_CHARGE_COUNTER,
+	POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT,
+	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE,
 	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_FULL,
@@ -236,6 +238,7 @@ static inline bool power_supply_is_amp_property(enum power_supply_property psp)
 	case POWER_SUPPLY_PROP_CHARGE_NOW:
 	case POWER_SUPPLY_PROP_CHARGE_AVG:
 	case POWER_SUPPLY_PROP_CHARGE_COUNTER:
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT:
 	case POWER_SUPPLY_PROP_CURRENT_MAX:
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 	case POWER_SUPPLY_PROP_CURRENT_AVG:
@@ -263,6 +266,7 @@ static inline bool power_supply_is_watt_property(enum power_supply_property psp)
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
 	case POWER_SUPPLY_PROP_VOLTAGE_OCV:
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE:
 	case POWER_SUPPLY_PROP_POWER_NOW:
 		return 1;
 	default:
-- 
1.7.0.4

