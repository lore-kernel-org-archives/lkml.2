Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab2GFEm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 00:42:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:44656 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab2GFEmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 00:42:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="161978221"
From: Saranya Gopal <saranya.gopal@intel.com>
To: lars@metafoo.de, cbou@mail.ru, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Saranya Gopal <saranya.gopal@intel.com>
Subject: [PATCHv4] bq27x00_battery: Add support for BQ27425 chip
Date: Fri,  6 Jul 2012 10:06:32 +0530
Message-Id: <1341549392-22170-1-git-send-email-saranya.gopal@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for BQ27425 (TI) chip. This chip is same as
BQ27500 with few registers removed and register address map changed.
The data sheet for this chip is publicly available at
 http://www.ti.com/product/bq27425-g1

Changes since v3:
	Add bq27xxx as prefix for the newly added function.
	Define SOC register address plus offset for bq27425 instead
	   of register address alone to align with other register reads.

Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
---
 drivers/power/bq27x00_battery.c |   85 +++++++++++++++++++++++++++++++-------
 1 files changed, 69 insertions(+), 16 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index f5d6d37..43f86c7 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -22,6 +22,7 @@
  * Datasheets:
  * http://focus.ti.com/docs/prod/folders/print/bq27000.html
  * http://focus.ti.com/docs/prod/folders/print/bq27500.html
+ * http://www.ti.com/product/bq27425-g1
  */
 
 #include <linux/module.h>
@@ -67,6 +68,10 @@
 #define BQ27500_FLAG_SOC1		BIT(2) /* State-of-Charge threshold 1 */
 #define BQ27500_FLAG_FC			BIT(9)
 
+/* bq27425 register addresses are same as bq27x00 addresses minus 4 */
+#define BQ27425_REG_OFFSET		0x04
+#define BQ27425_REG_SOC			0x18 /* Register address plus offset */
+
 #define BQ27000_RS			20 /* Resistor sense */
 
 struct bq27x00_device_info;
@@ -74,7 +79,7 @@ struct bq27x00_access_methods {
 	int (*read)(struct bq27x00_device_info *di, u8 reg, bool single);
 };
 
-enum bq27x00_chip { BQ27000, BQ27500 };
+enum bq27x00_chip { BQ27000, BQ27500, BQ27425};
 
 struct bq27x00_reg_cache {
 	int temperature;
@@ -125,6 +130,20 @@ static enum power_supply_property bq27x00_battery_props[] = {
 	POWER_SUPPLY_PROP_ENERGY_NOW,
 };
 
+static enum power_supply_property bq27425_battery_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
+	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_CHARGE_FULL,
+	POWER_SUPPLY_PROP_CHARGE_NOW,
+	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
+};
+
 static unsigned int poll_interval = 360;
 module_param(poll_interval, uint, 0644);
 MODULE_PARM_DESC(poll_interval, "battery poll interval in seconds - " \
@@ -137,10 +156,24 @@ MODULE_PARM_DESC(poll_interval, "battery poll interval in seconds - " \
 static inline int bq27x00_read(struct bq27x00_device_info *di, u8 reg,
 		bool single)
 {
+	if (di->chip == BQ27425)
+		return di->bus.read(di, reg - BQ27425_REG_OFFSET, single);
 	return di->bus.read(di, reg, single);
 }
 
 /*
+ * Higher versions of the chip like BQ27425 and BQ27500
+ * differ from BQ27000 and BQ27200 in calculation of certain
+ * parameters. Hence we need to check for the chip type.
+ */
+static bool bq27xxx_is_chip_version_higher(struct bq27x00_device_info *di)
+{
+	if (di->chip == BQ27425 || di->chip == BQ27500)
+		return true;
+	return false;
+}
+
+/*
  * Return the battery Relative State-of-Charge
  * Or < 0 if something fails.
  */
@@ -150,6 +183,8 @@ static int bq27x00_battery_read_rsoc(struct bq27x00_device_info *di)
 
 	if (di->chip == BQ27500)
 		rsoc = bq27x00_read(di, BQ27500_REG_SOC, false);
+	else if (di->chip == BQ27425)
+		rsoc = bq27x00_read(di, BQ27425_REG_SOC, false);
 	else
 		rsoc = bq27x00_read(di, BQ27000_REG_RSOC, true);
 
@@ -174,7 +209,7 @@ static int bq27x00_battery_read_charge(struct bq27x00_device_info *di, u8 reg)
 		return charge;
 	}
 
-	if (di->chip == BQ27500)
+	if (bq27xxx_is_chip_version_higher(di))
 		charge *= 1000;
 	else
 		charge = charge * 3570 / BQ27000_RS;
@@ -208,7 +243,7 @@ static int bq27x00_battery_read_ilmd(struct bq27x00_device_info *di)
 {
 	int ilmd;
 
-	if (di->chip == BQ27500)
+	if (bq27xxx_is_chip_version_higher(di))
 		ilmd = bq27x00_read(di, BQ27500_REG_DCAP, false);
 	else
 		ilmd = bq27x00_read(di, BQ27000_REG_ILMD, true);
@@ -218,7 +253,7 @@ static int bq27x00_battery_read_ilmd(struct bq27x00_device_info *di)
 		return ilmd;
 	}
 
-	if (di->chip == BQ27500)
+	if (bq27xxx_is_chip_version_higher(di))
 		ilmd *= 1000;
 	else
 		ilmd = ilmd * 256 * 3570 / BQ27000_RS;
@@ -262,7 +297,7 @@ static int bq27x00_battery_read_temperature(struct bq27x00_device_info *di)
 		return temp;
 	}
 
-	if (di->chip == BQ27500)
+	if (bq27xxx_is_chip_version_higher(di))
 		temp -= 2731;
 	else
 		temp = ((temp * 5) - 5463) / 2;
@@ -310,10 +345,12 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 {
 	struct bq27x00_reg_cache cache = {0, };
 	bool is_bq27500 = di->chip == BQ27500;
+	bool is_bq27425 = di->chip == BQ27425;
 
 	cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);
 	if (cache.flags >= 0) {
-		if (!is_bq27500 && (cache.flags & BQ27000_FLAG_CI)) {
+		if (!is_bq27500 && !is_bq27425
+				&& (cache.flags & BQ27000_FLAG_CI)) {
 			dev_info(di->dev, "battery is not calibrated! ignoring capacity values\n");
 			cache.capacity = -ENODATA;
 			cache.energy = -ENODATA;
@@ -323,14 +360,23 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 			cache.charge_full = -ENODATA;
 		} else {
 			cache.capacity = bq27x00_battery_read_rsoc(di);
-			cache.energy = bq27x00_battery_read_energy(di);
-			cache.time_to_empty = bq27x00_battery_read_time(di, BQ27x00_REG_TTE);
-			cache.time_to_empty_avg = bq27x00_battery_read_time(di, BQ27x00_REG_TTECP);
-			cache.time_to_full = bq27x00_battery_read_time(di, BQ27x00_REG_TTF);
+			if (!is_bq27425) {
+				cache.energy = bq27x00_battery_read_energy(di);
+				cache.time_to_empty =
+					bq27x00_battery_read_time(di,
+							BQ27x00_REG_TTE);
+				cache.time_to_empty_avg =
+					bq27x00_battery_read_time(di,
+							BQ27x00_REG_TTECP);
+				cache.time_to_full =
+					bq27x00_battery_read_time(di,
+							BQ27x00_REG_TTF);
+			}
 			cache.charge_full = bq27x00_battery_read_lmd(di);
 		}
 		cache.temperature = bq27x00_battery_read_temperature(di);
-		cache.cycle_count = bq27x00_battery_read_cyct(di);
+		if (!is_bq27425)
+			cache.cycle_count = bq27x00_battery_read_cyct(di);
 
 		/* We only have to read charge design full once */
 		if (di->charge_design_full <= 0)
@@ -376,7 +422,7 @@ static int bq27x00_battery_current(struct bq27x00_device_info *di,
 		return curr;
 	}
 
-	if (di->chip == BQ27500) {
+	if (bq27xxx_is_chip_version_higher(di)) {
 		/* bq27500 returns signed value */
 		val->intval = (int)((s16)curr) * 1000;
 	} else {
@@ -397,7 +443,7 @@ static int bq27x00_battery_status(struct bq27x00_device_info *di,
 {
 	int status;
 
-	if (di->chip == BQ27500) {
+	if (bq27xxx_is_chip_version_higher(di)) {
 		if (di->cache.flags & BQ27500_FLAG_FC)
 			status = POWER_SUPPLY_STATUS_FULL;
 		else if (di->cache.flags & BQ27500_FLAG_DSC)
@@ -425,7 +471,7 @@ static int bq27x00_battery_capacity_level(struct bq27x00_device_info *di,
 {
 	int level;
 
-	if (di->chip == BQ27500) {
+	if (bq27xxx_is_chip_version_higher(di)) {
 		if (di->cache.flags & BQ27500_FLAG_FC)
 			level = POWER_SUPPLY_CAPACITY_LEVEL_FULL;
 		else if (di->cache.flags & BQ27500_FLAG_SOC1)
@@ -570,8 +616,14 @@ static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
 	int ret;
 
 	di->bat.type = POWER_SUPPLY_TYPE_BATTERY;
-	di->bat.properties = bq27x00_battery_props;
-	di->bat.num_properties = ARRAY_SIZE(bq27x00_battery_props);
+	di->chip = BQ27425;
+	if (di->chip == BQ27425) {
+		di->bat.properties = bq27425_battery_props;
+		di->bat.num_properties = ARRAY_SIZE(bq27425_battery_props);
+	} else {
+		di->bat.properties = bq27x00_battery_props;
+		di->bat.num_properties = ARRAY_SIZE(bq27x00_battery_props);
+	}
 	di->bat.get_property = bq27x00_battery_get_property;
 	di->bat.external_power_changed = bq27x00_external_power_changed;
 
@@ -729,6 +781,7 @@ static int bq27x00_battery_remove(struct i2c_client *client)
 static const struct i2c_device_id bq27x00_id[] = {
 	{ "bq27200", BQ27000 },	/* bq27200 is same as bq27000, but with i2c */
 	{ "bq27500", BQ27500 },
+	{ "bq27425", BQ27425 },
 	{},
 };
 MODULE_DEVICE_TABLE(i2c, bq27x00_id);
-- 
1.7.1

