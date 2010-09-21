Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0IUWeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:34:12 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17518 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab0IUWeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:34:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Tue, 21 Sep 2010 15:34:10 -0700
From: rklein@nvidia.com
To: cbouatmailru@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org, olof@lixom.net,
        achew@nvidia.com, Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 1/1] power: bq20z75: Adding Devicekit Power support
Date: Tue, 21 Sep 2010 15:33:55 -0700
Message-Id: <1285108435-30044-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 21 Sep 2010 22:34:10.0462 (UTC) FILETIME=[1C1EDBE0:01CB59DD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rhyland Klein <rklein@nvidia.com>

Adding properties to support devicekit power.
Also create io wrapper functions and fixed some issues found while
testing, including unit conversions to match the power_supply types.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/bq20z75.c |  204 ++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 156 insertions(+), 48 deletions(-)

diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
index a1c7ae2..492da27 100644
--- a/drivers/power/bq20z75.c
+++ b/drivers/power/bq20z75.c
@@ -36,7 +36,11 @@ enum {
 	REG_TIME_TO_FULL,
 	REG_STATUS,
 	REG_CYCLE_COUNT,
-	REG_SERIAL_NUMBER
+	REG_SERIAL_NUMBER,
+	REG_REMAINING_CAPACITY,
+	REG_FULL_CHARGE_CAPACITY,
+	REG_DESIGN_CAPACITY,
+	REG_DESIGN_VOLTAGE,
 };
 
 /* manufacturer access defines */
@@ -44,7 +48,7 @@ enum {
 #define MANUFACTURER_ACCESS_SLEEP	0x0011
 
 /* battery status value bits */
-#define BATTERY_CHARGING		0x40
+#define BATTERY_DISCHARGING		0x40
 #define BATTERY_FULL_CHARGED		0x20
 #define BATTERY_FULL_DISCHARGED		0x10
 
@@ -72,6 +76,10 @@ static const struct bq20z75_device_data {
 			32767),
 	[REG_CAPACITY] =
 		BQ20Z75_DATA(POWER_SUPPLY_PROP_CAPACITY, 0x0E, 0, 100),
+	[REG_REMAINING_CAPACITY] =
+		BQ20Z75_DATA(POWER_SUPPLY_PROP_ENERGY_NOW, 0x0F, 0, 65535),
+	[REG_FULL_CHARGE_CAPACITY] =
+		BQ20Z75_DATA(POWER_SUPPLY_PROP_ENERGY_FULL, 0x10, 0, 65535),
 	[REG_TIME_TO_EMPTY] =
 		BQ20Z75_DATA(POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG, 0x12, 0,
 			65535),
@@ -82,6 +90,12 @@ static const struct bq20z75_device_data {
 		BQ20Z75_DATA(POWER_SUPPLY_PROP_STATUS, 0x16, 0, 65535),
 	[REG_CYCLE_COUNT] =
 		BQ20Z75_DATA(POWER_SUPPLY_PROP_CYCLE_COUNT, 0x17, 0, 65535),
+	[REG_DESIGN_CAPACITY] =
+		BQ20Z75_DATA(POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN, 0x18, 0,
+			65535),
+	[REG_DESIGN_VOLTAGE] =
+		BQ20Z75_DATA(POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN, 0x19, 0,
+			65535),
 	[REG_SERIAL_NUMBER] =
 		BQ20Z75_DATA(POWER_SUPPLY_PROP_SERIAL_NUMBER, 0x1C, 0, 65535),
 };
@@ -99,6 +113,10 @@ static enum power_supply_property bq20z75_properties[] = {
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
 	POWER_SUPPLY_PROP_SERIAL_NUMBER,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
+	POWER_SUPPLY_PROP_ENERGY_NOW,
+	POWER_SUPPLY_PROP_ENERGY_FULL,
+	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
 };
 
 struct bq20z75_info {
@@ -106,6 +124,35 @@ struct bq20z75_info {
 	struct power_supply	power_supply;
 };
 
+static int bq20z75_read_word_data(struct i2c_client *client, u8 address)
+{
+	s32 ret;
+
+	ret = i2c_smbus_read_word_data(client, address);
+	if (ret < 0) {
+		dev_err(&client->dev,
+			"%s: i2c read at address 0x%x failed\n",
+			__func__, address);
+		return ret;
+	}
+	return le16_to_cpu(ret);
+}
+
+static int bq20z75_write_word_data(struct i2c_client *client, u8 address,
+	u16 value)
+{
+	s32 ret;
+
+	ret = i2c_smbus_write_word_data(client, address, le16_to_cpu(value));
+	if (ret < 0) {
+		dev_err(&client->dev,
+			"%s: i2c write to address 0x%x failed\n",
+			__func__, address);
+		return ret;
+	}
+	return 0;
+}
+
 static int bq20z75_get_battery_presence_and_health(
 	struct i2c_client *client, enum power_supply_property psp,
 	union power_supply_propval *val)
@@ -115,24 +162,17 @@ static int bq20z75_get_battery_presence_and_health(
 	/* Write to ManufacturerAccess with
 	 * ManufacturerAccess command and then
 	 * read the status */
-	ret = i2c_smbus_write_word_data(client,
+	ret = bq20z75_write_word_data(client,
 		bq20z75_data[REG_MANUFACTURER_DATA].addr,
 		MANUFACTURER_ACCESS_STATUS);
-	if (ret < 0) {
-		dev_err(&client->dev,
-			"%s: i2c write for battery presence failed\n",
-			__func__);
-		return -ENODEV;
-	}
+	if (ret < 0)
+		return ret;
 
-	ret = i2c_smbus_read_word_data(client,
+
+	ret = bq20z75_read_word_data(client,
 		bq20z75_data[REG_MANUFACTURER_DATA].addr);
-	if (ret < 0) {
-		dev_err(&client->dev,
-			"%s: i2c read for battery presence failed\n",
-			__func__);
-		return -EIO;
-	}
+	if (ret < 0)
+		return ret;
 
 	if (ret < bq20z75_data[REG_MANUFACTURER_DATA].min_value ||
 	    ret > bq20z75_data[REG_MANUFACTURER_DATA].max_value) {
@@ -171,31 +211,28 @@ static int bq20z75_get_battery_property(struct i2c_client *client,
 {
 	s32 ret;
 
-	ret = i2c_smbus_read_word_data(client,
+	ret = bq20z75_read_word_data(client,
 		bq20z75_data[reg_offset].addr);
-	if (ret < 0) {
-		dev_err(&client->dev,
-			"%s: i2c read for %d failed\n", __func__, reg_offset);
-		return -EIO;
-	}
+	if (ret < 0)
+		return ret;
+
+	/* returned values are 16 bit */
+	if (bq20z75_data[reg_offset].min_value < 0)
+		ret = (s16)ret;
 
 	if (ret >= bq20z75_data[reg_offset].min_value &&
 	    ret <= bq20z75_data[reg_offset].max_value) {
 		val->intval = ret;
 		if (psp == POWER_SUPPLY_PROP_STATUS) {
-			if (ret & BATTERY_CHARGING)
-				val->intval = POWER_SUPPLY_STATUS_CHARGING;
-			else if (ret & BATTERY_FULL_CHARGED)
+			if (ret & BATTERY_FULL_CHARGED)
 				val->intval = POWER_SUPPLY_STATUS_FULL;
 			else if (ret & BATTERY_FULL_DISCHARGED)
 				val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
-			else
+			else if (ret & BATTERY_DISCHARGING)
 				val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+			else
+				val->intval = POWER_SUPPLY_STATUS_CHARGING;
 		}
-		/* bq20z75 provides battery tempreture in 0.1°K
-		 * so convert it to °C */
-		else if (psp == POWER_SUPPLY_PROP_TEMP)
-			val->intval = ret - 2731;
 	} else {
 		if (psp == POWER_SUPPLY_PROP_STATUS)
 			val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
@@ -206,21 +243,77 @@ static int bq20z75_get_battery_property(struct i2c_client *client,
 	return 0;
 }
 
+static void  bq20z75_unit_adjustment(struct i2c_client *client,
+	enum power_supply_property psp, union power_supply_propval *val)
+{
+#define BASE_UNIT_CONVERSION		1000
+#define BATTERY_MODE_CAP_MULT_WATT	(10 * BASE_UNIT_CONVERSION)
+#define TIME_UNIT_CONVERSION		600
+#define TEMP_KELVIN_TO_CELCIUS		2731
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ENERGY_NOW:
+	case POWER_SUPPLY_PROP_ENERGY_FULL:
+	case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:
+		val->intval *= BATTERY_MODE_CAP_MULT_WATT;
+		break;
+
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		val->intval *= BASE_UNIT_CONVERSION;
+		break;
+
+	case POWER_SUPPLY_PROP_TEMP:
+		/* bq20z75 provides battery tempreture in 0.1°K
+		 * so convert it to 0.1°C */
+		val->intval -= TEMP_KELVIN_TO_CELCIUS;
+		val->intval *= 10;
+		break;
+
+	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
+	case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
+		val->intval *= TIME_UNIT_CONVERSION;
+		break;
+
+	default:
+		dev_dbg(&client->dev,
+			"%s: no need for unit conversion %d\n", __func__, psp);
+	}
+}
+
 static int bq20z75_get_battery_capacity(struct i2c_client *client,
+	int reg_offset, enum power_supply_property psp,
 	union power_supply_propval *val)
 {
 	s32 ret;
 
-	ret = i2c_smbus_read_byte_data(client, bq20z75_data[REG_CAPACITY].addr);
-	if (ret < 0) {
-		dev_err(&client->dev,
-			"%s: i2c read for %d failed\n", __func__, REG_CAPACITY);
-		return -EIO;
-	}
+	ret = bq20z75_read_word_data(client, bq20z75_data[reg_offset].addr);
+	if (ret < 0)
+		return ret;
 
-	/* bq20z75 spec says that this can be >100 %
-	 * even if max value is 100 % */
-	val->intval = min(ret, 100);
+	if (psp == POWER_SUPPLY_PROP_CAPACITY) {
+		/* bq20z75 spec says that this can be >100 %
+		* even if max value is 100 % */
+		val->intval = min(ret, 100);
+	} else
+		val->intval = ret;
+
+	return 0;
+}
+
+static char bq20z75_serial[5];
+static int bq20z75_get_battery_serial_number(struct i2c_client *client,
+	union power_supply_propval *val)
+{
+	int ret;
+
+	ret = bq20z75_read_word_data(client,
+		bq20z75_data[REG_SERIAL_NUMBER].addr);
+	if (ret < 0)
+		return ret;
+
+	ret = sprintf(bq20z75_serial, "%04x", ret);
+	val->strval = bq20z75_serial;
 
 	return 0;
 }
@@ -247,8 +340,23 @@ static int bq20z75_get_property(struct power_supply *psy,
 		val->intval = POWER_SUPPLY_TECHNOLOGY_LION;
 		break;
 
+	case POWER_SUPPLY_PROP_ENERGY_NOW:
+	case POWER_SUPPLY_PROP_ENERGY_FULL:
+	case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:
 	case POWER_SUPPLY_PROP_CAPACITY:
-		ret = bq20z75_get_battery_capacity(client, val);
+		for (count = 0; count < ARRAY_SIZE(bq20z75_data); count++) {
+			if (psp == bq20z75_data[count].psp)
+				break;
+		}
+
+		ret = bq20z75_get_battery_capacity(client, count, psp, val);
+		if (ret)
+			return ret;
+
+		break;
+
+	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
+		ret = bq20z75_get_battery_serial_number(client, val);
 		if (ret)
 			return ret;
 		break;
@@ -260,7 +368,7 @@ static int bq20z75_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_TEMP:
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
 	case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
-	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
 		for (count = 0; count < ARRAY_SIZE(bq20z75_data); count++) {
 			if (psp == bq20z75_data[count].psp)
 				break;
@@ -269,6 +377,7 @@ static int bq20z75_get_property(struct power_supply *psy,
 		ret = bq20z75_get_battery_property(client, count, psp, val);
 		if (ret)
 			return ret;
+
 		break;
 
 	default:
@@ -277,6 +386,9 @@ static int bq20z75_get_property(struct power_supply *psy,
 		return -EINVAL;
 	}
 
+	/* Convert units to match requirements for power supply class */
+	bq20z75_unit_adjustment(client, psp, val);
+
 	dev_dbg(&client->dev,
 		"%s: property = %d, value = %d\n", __func__, psp, val->intval);
 
@@ -335,15 +447,11 @@ static int bq20z75_suspend(struct i2c_client *client,
 	s32 ret;
 
 	/* write to manufacturer access with sleep command */
-	ret = i2c_smbus_write_word_data(client,
+	ret = bq20z75_write_word_data(client,
 		bq20z75_data[REG_MANUFACTURER_DATA].addr,
 		MANUFACTURER_ACCESS_SLEEP);
-	if (ret < 0) {
-		dev_err(&client->dev,
-			"%s: i2c write for %d failed\n",
-			__func__, MANUFACTURER_ACCESS_SLEEP);
-		return -EIO;
-	}
+	if (ret < 0)
+		return ret;
 
 	return 0;
 }
-- 
1.7.0.4

