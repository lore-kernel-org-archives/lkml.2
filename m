Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab1BLTkf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 14:40:35 -0500
Received: from smtp-out-246.synserver.de ([212.40.185.246]:1034 "HELO
	smtp-out-246.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752648Ab1BLTjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 14:39:40 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24377
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 07/14] bq27X00: Cache battery registers
Date: Sat, 12 Feb 2011 20:39:07 +0100
Message-Id: <1297539554-13957-9-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297539554-13957-1-git-send-email-lars@metafoo.de>
References: <1297539554-13957-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a register cache to the bq27x00 battery driver.
Usually multiple, if not all, power_supply properties are queried at once,
for example when an uevent is generated. Since some registers are used by
multiple properties caching the registers should reduce the number of
reads.

The cache is valid for 5 seconds this roughly matches the internal update
interval of the current register for the bq27000/bq27200.

Fast changing properties(*_NOW) which can be obtained by reading a single
register are not cached.

It will also be used in the follow up patch to check if the battery status
has been changed since the last update to emit power_supply_changed events.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/bq27x00_battery.c |  272 +++++++++++++++++++++-----------------
 1 files changed, 150 insertions(+), 122 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index ae4677f..0c94693 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -19,7 +19,6 @@
 #include <linux/module.h>
 #include <linux/param.h>
 #include <linux/jiffies.h>
-#include <linux/workqueue.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
@@ -51,17 +50,30 @@
 
 struct bq27x00_device_info;
 struct bq27x00_access_methods {
-	int (*read)(struct bq27x00_device_info *, u8 reg, int *rt_value,
-			bool single);
+	int (*read)(struct bq27x00_device_info *di, u8 reg, bool single);
 };
 
 enum bq27x00_chip { BQ27000, BQ27500 };
 
+struct bq27x00_reg_cache {
+	int temperature;
+	int time_to_empty;
+	int time_to_empty_avg;
+	int time_to_full;
+	int capacity;
+	int flags;
+
+	int current_now;
+};
+
 struct bq27x00_device_info {
 	struct device 		*dev;
 	int			id;
 	enum bq27x00_chip	chip;
 
+	struct bq27x00_reg_cache cache;
+	unsigned long last_update;
+
 	struct power_supply	bat;
 
 	struct bq27x00_access_methods bus;
@@ -85,48 +97,93 @@ static enum power_supply_property bq27x00_battery_props[] = {
  */
 
 static inline int bq27x00_read(struct bq27x00_device_info *di, u8 reg,
-		int *rt_value, bool single)
+		bool single)
 {
-	return di->bus.read(di, reg, rt_value, single);
+	return di->bus.read(di, reg, single);
 }
 
 /*
- * Return the battery temperature in tenths of degree Celsius
+ * Return the battery Relative State-of-Charge
  * Or < 0 if something fails.
  */
-static int bq27x00_battery_temperature(struct bq27x00_device_info *di)
+static int bq27x00_battery_read_rsoc(struct bq27x00_device_info *di)
 {
-	int ret;
-	int temp = 0;
-
-	ret = bq27x00_read(di, BQ27x00_REG_TEMP, &temp, false);
-	if (ret) {
-		dev_err(di->dev, "error reading temperature\n");
-		return ret;
-	}
+	int rsoc;
 
 	if (di->chip == BQ27500)
-		return temp - 2731;
+		rsoc = bq27x00_read(di, BQ27500_REG_SOC, false);
 	else
-		return ((temp * 5) - 5463) / 2;
+		rsoc = bq27x00_read(di, BQ27000_REG_RSOC, true);
+
+	if (rsoc < 0)
+		dev_err(di->dev, "error reading relative State-of-Charge\n");
+
+	return rsoc;
 }
 
 /*
- * Return the battery Voltage in milivolts
- * Or < 0 if something fails.
+ * Read a time register.
+ * Return < 0 if something fails.
  */
-static int bq27x00_battery_voltage(struct bq27x00_device_info *di)
+static int bq27x00_battery_read_time(struct bq27x00_device_info *di, u8 reg)
 {
-	int ret;
-	int volt = 0;
+	int tval;
 
-	ret = bq27x00_read(di, BQ27x00_REG_VOLT, &volt, false);
-	if (ret) {
-		dev_err(di->dev, "error reading voltage\n");
-		return ret;
+	tval = bq27x00_read(di, reg, false);
+	if (tval < 0) {
+		dev_err(di->dev, "error reading register %02x: %d\n", reg, tval);
+		return tval;
+	}
+
+	if (tval == 65535)
+		return -ENODATA;
+
+	return tval * 60;
+}
+
+static void bq27x00_update(struct bq27x00_device_info *di)
+{
+	struct bq27x00_reg_cache cache = {0, };
+	bool is_bq27500 = di->chip == BQ27500;
+
+	cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, is_bq27500);
+	if (cache.flags >= 0) {
+		cache.capacity = bq27x00_battery_read_rsoc(di);
+		cache.temperature = bq27x00_read(di, BQ27x00_REG_TEMP, false);
+		cache.time_to_empty = bq27x00_battery_read_time(di, BQ27x00_REG_TTE);
+		cache.time_to_empty_avg = bq27x00_battery_read_time(di, BQ27x00_REG_TTECP);
+		cache.time_to_full = bq27x00_battery_read_time(di, BQ27x00_REG_TTF);
+
+		if (!is_bq27500)
+			cache.current_now = bq27x00_read(di, BQ27x00_REG_AI, false);
 	}
 
-	return volt * 1000;
+	/* Ignore current_now which is a snapshot of the current battery state
+	 * and is likely to be different even between two consecutive reads */
+	if (memcmp(&di->cache, &cache, sizeof(cache) - sizeof(int)) != 0) {
+		di->cache = cache;
+		power_supply_changed(&di->bat);
+	}
+
+	di->last_update = jiffies;
+}
+
+/*
+ * Return the battery temperature in tenths of degree Celsius
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_temperature(struct bq27x00_device_info *di,
+	union power_supply_propval *val)
+{
+	if (di->cache.temperature < 0)
+		return di->cache.temperature;
+
+	if (di->chip == BQ27500)
+		val->intval = di->cache.temperature - 2731;
+	else
+		val->intval = ((di->cache.temperature * 5) - 5463) / 2;
+
+	return 0;
 }
 
 /*
@@ -134,109 +191,84 @@ static int bq27x00_battery_voltage(struct bq27x00_device_info *di)
  * Note that current can be negative signed as well
  * Or 0 if something fails.
  */
-static int bq27x00_battery_current(struct bq27x00_device_info *di)
+static int bq27x00_battery_current(struct bq27x00_device_info *di,
+	union power_supply_propval *val)
 {
-	int ret;
-	int curr = 0;
-	int flags = 0;
+	int curr;
 
-	ret = bq27x00_read(di, BQ27x00_REG_AI, &curr, false);
-	if (ret) {
-		dev_err(di->dev, "error reading current\n");
-		return 0;
-	}
+	if (di->chip == BQ27000)
+	    curr = bq27x00_read(di, BQ27x00_REG_AI, false);
+	else
+	    curr = di->cache.current_now;
+
+	if (curr < 0)
+		return curr;
 
 	if (di->chip == BQ27500) {
 		/* bq27500 returns signed value */
-		curr = (int)((s16)curr) * 1000;
+		val->intval = (int)((s16)curr) * 1000;
 	} else {
-		ret = bq27x00_read(di, BQ27x00_REG_FLAGS, &flags, false);
-		if (ret < 0) {
-			dev_err(di->dev, "error reading flags\n");
-			return 0;
-		}
-		if (flags & BQ27000_FLAG_CHGS) {
+		if (di->cache.flags & BQ27000_FLAG_CHGS) {
 			dev_dbg(di->dev, "negative current!\n");
 			curr = -curr;
 		}
-		curr = curr * 3570 / BQ27000_RS;
-	}
-
-	return curr;
-}
-
-/*
- * Return the battery Relative State-of-Charge
- * Or < 0 if something fails.
- */
-static int bq27x00_battery_rsoc(struct bq27x00_device_info *di)
-{
-	int ret;
-	int rsoc = 0;
 
-	if (di->chip == BQ27500)
-		ret = bq27x00_read(di, BQ27500_REG_SOC, &rsoc, false);
-	else
-		ret = bq27x00_read(di, BQ27000_REG_RSOC, &rsoc, true);
-	if (ret) {
-		dev_err(di->dev, "error reading relative State-of-Charge\n");
-		return ret;
+		val->intval = curr * 3570 / BQ27000_RS;
 	}
 
-	return rsoc;
+	return 0;
 }
 
 static int bq27x00_battery_status(struct bq27x00_device_info *di,
-				  union power_supply_propval *val)
+	union power_supply_propval *val)
 {
-	int flags = 0;
 	int status;
-	int ret;
-
-	ret = bq27x00_read(di, BQ27x00_REG_FLAGS, &flags, false);
-	if (ret < 0) {
-		dev_err(di->dev, "error reading flags\n");
-		return ret;
-	}
 
 	if (di->chip == BQ27500) {
-		if (flags & BQ27500_FLAG_FC)
+		if (di->cache.flags & BQ27500_FLAG_FC)
 			status = POWER_SUPPLY_STATUS_FULL;
-		else if (flags & BQ27500_FLAG_DSC)
+		else if (di->cache.flags & BQ27500_FLAG_DSC)
 			status = POWER_SUPPLY_STATUS_DISCHARGING;
 		else
 			status = POWER_SUPPLY_STATUS_CHARGING;
 	} else {
-		if (flags & BQ27000_FLAG_CHGS)
+		if (di->cache.flags & BQ27000_FLAG_CHGS)
 			status = POWER_SUPPLY_STATUS_CHARGING;
 		else
 			status = POWER_SUPPLY_STATUS_DISCHARGING;
 	}
 
 	val->intval = status;
+
 	return 0;
 }
 
 /*
- * Read a time register.
- * Return < 0 if something fails.
+ * Return the battery Voltage in milivolts
+ * Or < 0 if something fails.
  */
-static int bq27x00_battery_time(struct bq27x00_device_info *di, int reg,
-				union power_supply_propval *val)
+static int bq27x00_battery_voltage(struct bq27x00_device_info *di,
+	union power_supply_propval *val)
 {
-	int tval = 0;
-	int ret;
+	int volt;
 
-	ret = bq27x00_read(reg, &tval, false);
-	if (ret) {
-		dev_err(di->dev, "error reading register %02x\n", reg);
-		return ret;
-	}
+	volt = bq27x00_read(di, BQ27x00_REG_VOLT, false);
+	if (volt < 0)
+		return volt;
 
-	if (tval == 65535)
-		return -ENODATA;
+	val->intval = volt * 1000;
+
+	return 0;
+}
+
+static int bq27x00_simple_value(int value,
+	union power_supply_propval *val)
+{
+	if (value < 0)
+		return value;
+
+	val->intval = value;
 
-	val->intval = tval * 60;
 	return 0;
 }
 
@@ -249,9 +281,11 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 {
 	int ret = 0;
 	struct bq27x00_device_info *di = to_bq27x00_device_info(psy);
-	int voltage = bq27x00_battery_voltage(di);
 
-	if (psp != POWER_SUPPLY_PROP_PRESENT && voltage <= 0)
+	if (time_is_before_jiffies(di->last_update + 5 * HZ))
+		bq27x00_update(di);
+
+	if (psp != POWER_SUPPLY_PROP_PRESENT && di->cache.flags < 0)
 		return -ENODEV;
 
 	switch (psp) {
@@ -259,29 +293,28 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 		ret = bq27x00_battery_status(di, val);
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		val->intval = voltage;
+		ret = bq27x00_battery_voltage(di, val);
 		break;
 	case POWER_SUPPLY_PROP_PRESENT:
-		if (psp == POWER_SUPPLY_PROP_PRESENT)
-			val->intval = voltage <= 0 ? 0 : 1;
+		val->intval = di->cache.flags < 0 ? 0 : 1;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
-		val->intval = bq27x00_battery_current(di);
+		ret = bq27x00_battery_current(di, val);
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
-		val->intval = bq27x00_battery_rsoc(di);
+		ret = bq27x00_simple_value(di->cache.capacity, val);
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
-		val->intval = bq27x00_battery_temperature(di);
+		ret = bq27x00_battery_temperature(di, val);
 		break;
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW:
-		ret = bq27x00_battery_time(di, BQ27x00_REG_TTE, val);
+		ret = bq27x00_simple_value(di->cache.time_to_empty, val);
 		break;
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
-		ret = bq27x00_battery_time(di, BQ27x00_REG_TTECP, val);
+		ret = bq27x00_simple_value(di->cache.time_to_empty_avg, val);
 		break;
 	case POWER_SUPPLY_PROP_TIME_TO_FULL_NOW:
-		ret = bq27x00_battery_time(di, BQ27x00_REG_TTF, val);
+		ret = bq27x00_simple_value(di->cache.time_to_full, val);
 		break;
 	case POWER_SUPPLY_PROP_TECHNOLOGY:
 		val->intval = POWER_SUPPLY_TECHNOLOGY_LION;
@@ -311,6 +344,8 @@ static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
 
 	dev_info(di->dev, "support ver. %s enabled\n", DRIVER_VERSION);
 
+	bq27x00_update(di);
+
 	return 0;
 }
 
@@ -324,13 +359,12 @@ static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
 static DEFINE_IDR(battery_id);
 static DEFINE_MUTEX(battery_mutex);
 
-static int bq27x00_read_i2c(struct bq27x00_device_info *di, u8 reg,
-			int *rt_value, bool single)
+static int bq27x00_read_i2c(struct bq27x00_device_info *di, u8 reg, bool single)
 {
 	struct i2c_client *client = to_i2c_client(di->dev);
 	struct i2c_msg msg[1];
 	unsigned char data[2];
-	int err;
+	int ret;
 
 	if (!client->adapter)
 		return -ENODEV;
@@ -341,26 +375,24 @@ static int bq27x00_read_i2c(struct bq27x00_device_info *di, u8 reg,
 	msg->buf = data;
 
 	data[0] = reg;
-	err = i2c_transfer(client->adapter, msg, 1);
+	ret = i2c_transfer(client->adapter, msg, 1);
 
-	if (err >= 0) {
+	if (ret >= 0) {
 		if (!single)
 			msg->len = 2;
 		else
 			msg->len = 1;
 
 		msg->flags = I2C_M_RD;
-		err = i2c_transfer(client->adapter, msg, 1);
-		if (err >= 0) {
+		ret = i2c_transfer(client->adapter, msg, 1);
+		if (ret >= 0) {
 			if (!single)
-				*rt_value = get_unaligned_le16(data);
+				ret = get_unaligned_le16(data);
 			else
-				*rt_value = data[0];
-
-			return 0;
+				ret = data[0];
 		}
 	}
-	return err;
+	return ret;
 }
 
 static int bq27x00_battery_probe(struct i2c_client *client,
@@ -477,7 +509,7 @@ static inline void bq27x00_battery_i2c_exit(void) {};
 #ifdef CONFIG_BATTERY_BQ27X00_PLATFORM
 
 static int bq27000_read_platform(struct bq27x00_device_info *di, u8 reg,
-			int *rt_value, bool single)
+			bool single)
 {
 	struct device *dev = di->dev;
 	struct bq27000_platform_data *pdata = dev->platform_data;
@@ -504,14 +536,10 @@ static int bq27000_read_platform(struct bq27x00_device_info *di, u8 reg,
 		if (timeout == 0)
 			return -EIO;
 
-		*rt_value = (upper << 8) | lower;
-	} else {
-		lower = pdata->read(dev, reg);
-		if (lower < 0)
-			return lower;
-		*rt_value = lower;
+		return (upper << 8) | lower;
 	}
-	return 0;
+
+	return pdata->read(dev, reg);
 }
 
 static int __devinit bq27000_battery_probe(struct platform_device *pdev)
-- 
1.7.2.3

