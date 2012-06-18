Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab2FRGTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:19:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:16402 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab2FRGTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:19:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="157533396"
From: Saranya Gopal <saranya.gopal@intel.com>
To: cbou@mail.ru, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Saranya Gopal <saranya.gopal@intel.com>
Subject: [PATCH] bq27x00_battery: Add support for BQ27425 chip
Date: Mon, 18 Jun 2012 11:40:40 +0530
Message-Id: <1339999840-12532-1-git-send-email-saranya.gopal@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for BQ27425 (TI) chip. This
chip is same as BQ27500 with few registers removed
and register address map changed. The data sheet for
this chip is publicly available at
http://www.ti.com/product/bq27425-g1

Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
---
 drivers/power/Kconfig           |    7 +++
 drivers/power/bq27x00_battery.c |   85 +++++++++++++++++++++++++++++---------
 2 files changed, 72 insertions(+), 20 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index e3a3b49..38f6807 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -157,6 +157,13 @@ config BATTERY_BQ27X00_PLATFORM
 	help
 	  Say Y here to enable support for batteries with BQ27000 (HDQ) chips.
 
+config BATTERY_BQ27425
+	bool "BQ27425 support"
+	depends on BATTERY_BQ27x00
+	depends on BATTERY_BQ27X00_I2C
+	help
+	  Say Y here to enable support for batteries with BQ27425 (I2C) chip.
+
 config BATTERY_DA9030
 	tristate "DA9030 battery driver"
 	depends on PMIC_DA903X
diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index f5d6d37..d22e415 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -22,6 +22,7 @@
  * Datasheets:
  * http://focus.ti.com/docs/prod/folders/print/bq27000.html
  * http://focus.ti.com/docs/prod/folders/print/bq27500.html
+ * http://www.ti.com/product/bq27425-g1
  */
 
 #include <linux/module.h>
@@ -67,6 +68,14 @@
 #define BQ27500_FLAG_SOC1		BIT(2) /* State-of-Charge threshold 1 */
 #define BQ27500_FLAG_FC			BIT(9)
 
+#define BQ27425_REG_TEMP		0x02
+#define BQ27425_REG_VOLT		0x04
+#define BQ27425_REG_FLAGS		0x06
+#define BQ27425_REG_NAC			0x08
+#define BQ27425_REG_FCC			0x0E
+#define BQ27425_REG_AI			0x10
+#define BQ27425_REG_SOC			0x1C
+
 #define BQ27000_RS			20 /* Resistor sense */
 
 struct bq27x00_device_info;
@@ -74,7 +83,7 @@ struct bq27x00_access_methods {
 	int (*read)(struct bq27x00_device_info *di, u8 reg, bool single);
 };
 
-enum bq27x00_chip { BQ27000, BQ27500 };
+enum bq27x00_chip { BQ27000, BQ27500, BQ27425};
 
 struct bq27x00_reg_cache {
 	int temperature;
@@ -114,15 +123,17 @@ static enum power_supply_property bq27x00_battery_props[] = {
 	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
 	POWER_SUPPLY_PROP_TEMP,
+#ifndef CONFIG_BATTERY_BQ27425
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
+	POWER_SUPPLY_PROP_CYCLE_COUNT,
+	POWER_SUPPLY_PROP_ENERGY_NOW,
+#endif
 	POWER_SUPPLY_PROP_TECHNOLOGY,
 	POWER_SUPPLY_PROP_CHARGE_FULL,
 	POWER_SUPPLY_PROP_CHARGE_NOW,
 	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
-	POWER_SUPPLY_PROP_CYCLE_COUNT,
-	POWER_SUPPLY_PROP_ENERGY_NOW,
 };
 
 static unsigned int poll_interval = 360;
@@ -150,6 +161,8 @@ static int bq27x00_battery_read_rsoc(struct bq27x00_device_info *di)
 
 	if (di->chip == BQ27500)
 		rsoc = bq27x00_read(di, BQ27500_REG_SOC, false);
+	else if (di->chip == BQ27425)
+		rsoc = bq27x00_read(di, BQ27425_REG_SOC, false);
 	else
 		rsoc = bq27x00_read(di, BQ27000_REG_RSOC, true);
 
@@ -174,7 +187,7 @@ static int bq27x00_battery_read_charge(struct bq27x00_device_info *di, u8 reg)
 		return charge;
 	}
 
-	if (di->chip == BQ27500)
+	if (di->chip == BQ27500 || di->chip == BQ27425)
 		charge *= 1000;
 	else
 		charge = charge * 3570 / BQ27000_RS;
@@ -188,6 +201,8 @@ static int bq27x00_battery_read_charge(struct bq27x00_device_info *di, u8 reg)
  */
 static inline int bq27x00_battery_read_nac(struct bq27x00_device_info *di)
 {
+	if (di->chip == BQ27425)
+		return bq27x00_battery_read_charge(di, BQ27425_REG_NAC);
 	return bq27x00_battery_read_charge(di, BQ27x00_REG_NAC);
 }
 
@@ -197,6 +212,8 @@ static inline int bq27x00_battery_read_nac(struct bq27x00_device_info *di)
  */
 static inline int bq27x00_battery_read_lmd(struct bq27x00_device_info *di)
 {
+	if (di->chip == BQ27425)
+		return bq27x00_battery_read_charge(di, BQ27425_REG_FCC);
 	return bq27x00_battery_read_charge(di, BQ27x00_REG_LMD);
 }
 
@@ -208,7 +225,7 @@ static int bq27x00_battery_read_ilmd(struct bq27x00_device_info *di)
 {
 	int ilmd;
 
-	if (di->chip == BQ27500)
+	if (di->chip == BQ27500  || di->chip == BQ27425)
 		ilmd = bq27x00_read(di, BQ27500_REG_DCAP, false);
 	else
 		ilmd = bq27x00_read(di, BQ27000_REG_ILMD, true);
@@ -218,7 +235,7 @@ static int bq27x00_battery_read_ilmd(struct bq27x00_device_info *di)
 		return ilmd;
 	}
 
-	if (di->chip == BQ27500)
+	if (di->chip == BQ27500 || di->chip == BQ27425)
 		ilmd *= 1000;
 	else
 		ilmd = ilmd * 256 * 3570 / BQ27000_RS;
@@ -256,13 +273,16 @@ static int bq27x00_battery_read_temperature(struct bq27x00_device_info *di)
 {
 	int temp;
 
-	temp = bq27x00_read(di, BQ27x00_REG_TEMP, false);
+	if (di->chip == BQ27425)
+		temp = bq27x00_read(di, BQ27425_REG_TEMP, false);
+	else
+		temp = bq27x00_read(di, BQ27x00_REG_TEMP, false);
 	if (temp < 0) {
 		dev_err(di->dev, "error reading temperature\n");
 		return temp;
 	}
 
-	if (di->chip == BQ27500)
+	if (di->chip == BQ27500 || di->chip == BQ27425)
 		temp -= 2731;
 	else
 		temp = ((temp * 5) - 5463) / 2;
@@ -310,10 +330,15 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 {
 	struct bq27x00_reg_cache cache = {0, };
 	bool is_bq27500 = di->chip == BQ27500;
+	bool is_bq27425 = di->chip == BQ27425;
 
-	cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);
+	if (is_bq27425)
+		cache.flags = bq27x00_read(di, BQ27425_REG_FLAGS, !is_bq27425);
+	else
+		cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);
 	if (cache.flags >= 0) {
-		if (!is_bq27500 && (cache.flags & BQ27000_FLAG_CI)) {
+		if (!is_bq27500 && !is_bq27425
+				&& (cache.flags & BQ27000_FLAG_CI)) {
 			dev_info(di->dev, "battery is not calibrated! ignoring capacity values\n");
 			cache.capacity = -ENODATA;
 			cache.energy = -ENODATA;
@@ -323,14 +348,23 @@ static void bq27x00_update(struct bq27x00_device_info *di)
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
@@ -370,13 +404,16 @@ static int bq27x00_battery_current(struct bq27x00_device_info *di,
 	int curr;
 	int flags;
 
-	curr = bq27x00_read(di, BQ27x00_REG_AI, false);
+	if (di->chip == BQ27425)
+		curr = bq27x00_read(di, BQ27425_REG_AI, false);
+	else
+		curr = bq27x00_read(di, BQ27x00_REG_AI, false);
 	if (curr < 0) {
 		dev_err(di->dev, "error reading current\n");
 		return curr;
 	}
 
-	if (di->chip == BQ27500) {
+	if (di->chip == BQ27500 || di->chip == BQ27425) {
 		/* bq27500 returns signed value */
 		val->intval = (int)((s16)curr) * 1000;
 	} else {
@@ -397,7 +434,7 @@ static int bq27x00_battery_status(struct bq27x00_device_info *di,
 {
 	int status;
 
-	if (di->chip == BQ27500) {
+	if (di->chip == BQ27500 || di->chip == BQ27425) {
 		if (di->cache.flags & BQ27500_FLAG_FC)
 			status = POWER_SUPPLY_STATUS_FULL;
 		else if (di->cache.flags & BQ27500_FLAG_DSC)
@@ -425,7 +462,7 @@ static int bq27x00_battery_capacity_level(struct bq27x00_device_info *di,
 {
 	int level;
 
-	if (di->chip == BQ27500) {
+	if (di->chip == BQ27500 || di->chip == BQ27425) {
 		if (di->cache.flags & BQ27500_FLAG_FC)
 			level = POWER_SUPPLY_CAPACITY_LEVEL_FULL;
 		else if (di->cache.flags & BQ27500_FLAG_SOC1)
@@ -459,7 +496,10 @@ static int bq27x00_battery_voltage(struct bq27x00_device_info *di,
 {
 	int volt;
 
-	volt = bq27x00_read(di, BQ27x00_REG_VOLT, false);
+	if (di->chip == BQ27425)
+		volt = bq27x00_read(di, BQ27425_REG_VOLT, false);
+	else
+		volt = bq27x00_read(di, BQ27x00_REG_VOLT, false);
 	if (volt < 0) {
 		dev_err(di->dev, "error reading voltage\n");
 		return volt;
@@ -523,6 +563,7 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_TEMP:
 		ret = bq27x00_simple_value(di->cache.temperature, val);
 		break;
+#ifndef CONFIG_BATTERY_BQ27425
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW:
 		ret = bq27x00_simple_value(di->cache.time_to_empty, val);
 		break;
@@ -532,6 +573,7 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_TIME_TO_FULL_NOW:
 		ret = bq27x00_simple_value(di->cache.time_to_full, val);
 		break;
+#endif
 	case POWER_SUPPLY_PROP_TECHNOLOGY:
 		val->intval = POWER_SUPPLY_TECHNOLOGY_LION;
 		break;
@@ -544,12 +586,14 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
 		ret = bq27x00_simple_value(di->charge_design_full, val);
 		break;
+#ifndef CONFIG_BATTERY_BQ27425
 	case POWER_SUPPLY_PROP_CYCLE_COUNT:
 		ret = bq27x00_simple_value(di->cache.cycle_count, val);
 		break;
 	case POWER_SUPPLY_PROP_ENERGY_NOW:
 		ret = bq27x00_simple_value(di->cache.energy, val);
 		break;
+#endif
 	default:
 		return -EINVAL;
 	}
@@ -729,6 +773,7 @@ static int bq27x00_battery_remove(struct i2c_client *client)
 static const struct i2c_device_id bq27x00_id[] = {
 	{ "bq27200", BQ27000 },	/* bq27200 is same as bq27000, but with i2c */
 	{ "bq27500", BQ27500 },
+	{ "bq27425", BQ27425 },
 	{},
 };
 MODULE_DEVICE_TABLE(i2c, bq27x00_id);
-- 
1.7.1

