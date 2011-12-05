Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab1LEX7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:59:25 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16905 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab1LEX7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:59:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 05 Dec 2011 15:59:18 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 2/5] power: sbs-battery: rename internals to new name
Date: Mon,  5 Dec 2011 15:58:04 -0800
Message-Id: <1323129487-24859-2-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323129487-24859-1-git-send-email-rklein@nvidia.com>
References: <1323129487-24859-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that this driver is named more generally, this change updates
the internal variables, defines and functions to use this new name.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/sbs-battery.c       |  425 ++++++++++++++++++-------------------
 include/linux/power/sbs-battery.h |   10 +-
 2 files changed, 209 insertions(+), 226 deletions(-)

diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index ce95ff7..761500c 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -1,5 +1,5 @@
 /*
- * Gas Gauge driver for TI's BQ20Z75
+ * Gas Gauge driver for SBS Compliant Batteries
  *
  * Copyright (c) 2010, NVIDIA Corporation.
  *
@@ -28,7 +28,7 @@
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
 
-#include <linux/power/bq20z75.h>
+#include <linux/power/sbs-battery.h>
 
 enum {
 	REG_MANUFACTURER_DATA,
@@ -53,7 +53,7 @@ enum {
 /* Battery Mode defines */
 #define BATTERY_MODE_OFFSET		0x03
 #define BATTERY_MODE_MASK		0x8000
-enum bq20z75_battery_mode {
+enum sbs_battery_mode {
 	BATTERY_MODE_AMPS,
 	BATTERY_MODE_WATTS
 };
@@ -67,62 +67,56 @@ enum bq20z75_battery_mode {
 #define BATTERY_FULL_CHARGED		0x20
 #define BATTERY_FULL_DISCHARGED		0x10
 
-#define BQ20Z75_DATA(_psp, _addr, _min_value, _max_value) { \
+#define SBS_DATA(_psp, _addr, _min_value, _max_value) { \
 	.psp = _psp, \
 	.addr = _addr, \
 	.min_value = _min_value, \
 	.max_value = _max_value, \
 }
 
-static const struct bq20z75_device_data {
+static const struct chip_data {
 	enum power_supply_property psp;
 	u8 addr;
 	int min_value;
 	int max_value;
-} bq20z75_data[] = {
+} sbs_data[] = {
 	[REG_MANUFACTURER_DATA] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_PRESENT, 0x00, 0, 65535),
+		SBS_DATA(POWER_SUPPLY_PROP_PRESENT, 0x00, 0, 65535),
 	[REG_TEMPERATURE] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_TEMP, 0x08, 0, 65535),
+		SBS_DATA(POWER_SUPPLY_PROP_TEMP, 0x08, 0, 65535),
 	[REG_VOLTAGE] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_VOLTAGE_NOW, 0x09, 0, 20000),
+		SBS_DATA(POWER_SUPPLY_PROP_VOLTAGE_NOW, 0x09, 0, 20000),
 	[REG_CURRENT] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_CURRENT_NOW, 0x0A, -32768,
-			32767),
+		SBS_DATA(POWER_SUPPLY_PROP_CURRENT_NOW, 0x0A, -32768, 32767),
 	[REG_CAPACITY] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_CAPACITY, 0x0E, 0, 100),
+		SBS_DATA(POWER_SUPPLY_PROP_CAPACITY, 0x0E, 0, 100),
 	[REG_REMAINING_CAPACITY] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_ENERGY_NOW, 0x0F, 0, 65535),
+		SBS_DATA(POWER_SUPPLY_PROP_ENERGY_NOW, 0x0F, 0, 65535),
 	[REG_REMAINING_CAPACITY_CHARGE] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_CHARGE_NOW, 0x0F, 0, 65535),
+		SBS_DATA(POWER_SUPPLY_PROP_CHARGE_NOW, 0x0F, 0, 65535),
 	[REG_FULL_CHARGE_CAPACITY] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_ENERGY_FULL, 0x10, 0, 65535),
+		SBS_DATA(POWER_SUPPLY_PROP_ENERGY_FULL, 0x10, 0, 65535),
 	[REG_FULL_CHARGE_CAPACITY_CHARGE] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_CHARGE_FULL, 0x10, 0, 65535),
+		SBS_DATA(POWER_SUPPLY_PROP_CHARGE_FULL, 0x10, 0, 65535),
 	[REG_TIME_TO_EMPTY] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG, 0x12, 0,
-			65535),
+		SBS_DATA(POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG, 0x12, 0, 65535),
 	[REG_TIME_TO_FULL] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_TIME_TO_FULL_AVG, 0x13, 0,
-			65535),
+		SBS_DATA(POWER_SUPPLY_PROP_TIME_TO_FULL_AVG, 0x13, 0, 65535),
 	[REG_STATUS] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_STATUS, 0x16, 0, 65535),
+		SBS_DATA(POWER_SUPPLY_PROP_STATUS, 0x16, 0, 65535),
 	[REG_CYCLE_COUNT] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_CYCLE_COUNT, 0x17, 0, 65535),
+		SBS_DATA(POWER_SUPPLY_PROP_CYCLE_COUNT, 0x17, 0, 65535),
 	[REG_DESIGN_CAPACITY] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN, 0x18, 0,
-			65535),
+		SBS_DATA(POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN, 0x18, 0, 65535),
 	[REG_DESIGN_CAPACITY_CHARGE] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN, 0x18, 0,
-			65535),
+		SBS_DATA(POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN, 0x18, 0, 65535),
 	[REG_DESIGN_VOLTAGE] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN, 0x19, 0,
-			65535),
+		SBS_DATA(POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN, 0x19, 0, 65535),
 	[REG_SERIAL_NUMBER] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_SERIAL_NUMBER, 0x1C, 0, 65535),
+		SBS_DATA(POWER_SUPPLY_PROP_SERIAL_NUMBER, 0x1C, 0, 65535),
 };
 
-static enum power_supply_property bq20z75_properties[] = {
+static enum power_supply_property sbs_properties[] = {
 	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_HEALTH,
 	POWER_SUPPLY_PROP_PRESENT,
@@ -144,10 +138,10 @@ static enum power_supply_property bq20z75_properties[] = {
 	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
 };
 
-struct bq20z75_info {
+struct sbs_info {
 	struct i2c_client		*client;
 	struct power_supply		power_supply;
-	struct bq20z75_platform_data	*pdata;
+	struct sbs_platform_data	*pdata;
 	bool				is_present;
 	bool				gpio_detect;
 	bool				enable_detection;
@@ -158,14 +152,14 @@ struct bq20z75_info {
 	int				ignore_changes;
 };
 
-static int bq20z75_read_word_data(struct i2c_client *client, u8 address)
+static int sbs_read_word_data(struct i2c_client *client, u8 address)
 {
-	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
+	struct sbs_info *chip = i2c_get_clientdata(client);
 	s32 ret = 0;
 	int retries = 1;
 
-	if (bq20z75_device->pdata)
-		retries = max(bq20z75_device->pdata->i2c_retry_count + 1, 1);
+	if (chip->pdata)
+		retries = max(chip->pdata->i2c_retry_count + 1, 1);
 
 	while (retries > 0) {
 		ret = i2c_smbus_read_word_data(client, address);
@@ -184,15 +178,15 @@ static int bq20z75_read_word_data(struct i2c_client *client, u8 address)
 	return le16_to_cpu(ret);
 }
 
-static int bq20z75_write_word_data(struct i2c_client *client, u8 address,
+static int sbs_write_word_data(struct i2c_client *client, u8 address,
 	u16 value)
 {
-	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
+	struct sbs_info *chip = i2c_get_clientdata(client);
 	s32 ret = 0;
 	int retries = 1;
 
-	if (bq20z75_device->pdata)
-		retries = max(bq20z75_device->pdata->i2c_retry_count + 1, 1);
+	if (chip->pdata)
+		retries = max(chip->pdata->i2c_retry_count + 1, 1);
 
 	while (retries > 0) {
 		ret = i2c_smbus_write_word_data(client, address,
@@ -212,44 +206,41 @@ static int bq20z75_write_word_data(struct i2c_client *client, u8 address,
 	return 0;
 }
 
-static int bq20z75_get_battery_presence_and_health(
+static int sbs_get_battery_presence_and_health(
 	struct i2c_client *client, enum power_supply_property psp,
 	union power_supply_propval *val)
 {
 	s32 ret;
-	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
+	struct sbs_info *chip = i2c_get_clientdata(client);
 
 	if (psp == POWER_SUPPLY_PROP_PRESENT &&
-		bq20z75_device->gpio_detect) {
-		ret = gpio_get_value(
-			bq20z75_device->pdata->battery_detect);
-		if (ret == bq20z75_device->pdata->battery_detect_present)
+		chip->gpio_detect) {
+		ret = gpio_get_value(chip->pdata->battery_detect);
+		if (ret == chip->pdata->battery_detect_present)
 			val->intval = 1;
 		else
 			val->intval = 0;
-		bq20z75_device->is_present = val->intval;
+		chip->is_present = val->intval;
 		return ret;
 	}
 
 	/* Write to ManufacturerAccess with
 	 * ManufacturerAccess command and then
 	 * read the status */
-	ret = bq20z75_write_word_data(client,
-		bq20z75_data[REG_MANUFACTURER_DATA].addr,
-		MANUFACTURER_ACCESS_STATUS);
+	ret = sbs_write_word_data(client, sbs_data[REG_MANUFACTURER_DATA].addr,
+					MANUFACTURER_ACCESS_STATUS);
 	if (ret < 0) {
 		if (psp == POWER_SUPPLY_PROP_PRESENT)
 			val->intval = 0; /* battery removed */
 		return ret;
 	}
 
-	ret = bq20z75_read_word_data(client,
-		bq20z75_data[REG_MANUFACTURER_DATA].addr);
+	ret = sbs_read_word_data(client, sbs_data[REG_MANUFACTURER_DATA].addr);
 	if (ret < 0)
 		return ret;
 
-	if (ret < bq20z75_data[REG_MANUFACTURER_DATA].min_value ||
-	    ret > bq20z75_data[REG_MANUFACTURER_DATA].max_value) {
+	if (ret < sbs_data[REG_MANUFACTURER_DATA].min_value ||
+	    ret > sbs_data[REG_MANUFACTURER_DATA].max_value) {
 		val->intval = 0;
 		return 0;
 	}
@@ -279,24 +270,23 @@ static int bq20z75_get_battery_presence_and_health(
 	return 0;
 }
 
-static int bq20z75_get_battery_property(struct i2c_client *client,
+static int sbs_get_battery_property(struct i2c_client *client,
 	int reg_offset, enum power_supply_property psp,
 	union power_supply_propval *val)
 {
-	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
+	struct sbs_info *chip = i2c_get_clientdata(client);
 	s32 ret;
 
-	ret = bq20z75_read_word_data(client,
-		bq20z75_data[reg_offset].addr);
+	ret = sbs_read_word_data(client, sbs_data[reg_offset].addr);
 	if (ret < 0)
 		return ret;
 
 	/* returned values are 16 bit */
-	if (bq20z75_data[reg_offset].min_value < 0)
+	if (sbs_data[reg_offset].min_value < 0)
 		ret = (s16)ret;
 
-	if (ret >= bq20z75_data[reg_offset].min_value &&
-	    ret <= bq20z75_data[reg_offset].max_value) {
+	if (ret >= sbs_data[reg_offset].min_value &&
+	    ret <= sbs_data[reg_offset].max_value) {
 		val->intval = ret;
 		if (psp != POWER_SUPPLY_PROP_STATUS)
 			return 0;
@@ -310,12 +300,12 @@ static int bq20z75_get_battery_property(struct i2c_client *client,
 		else
 			val->intval = POWER_SUPPLY_STATUS_CHARGING;
 
-		if (bq20z75_device->poll_time == 0)
-			bq20z75_device->last_state = val->intval;
-		else if (bq20z75_device->last_state != val->intval) {
-			cancel_delayed_work_sync(&bq20z75_device->work);
-			power_supply_changed(&bq20z75_device->power_supply);
-			bq20z75_device->poll_time = 0;
+		if (chip->poll_time == 0)
+			chip->last_state = val->intval;
+		else if (chip->last_state != val->intval) {
+			cancel_delayed_work_sync(&chip->work);
+			power_supply_changed(&chip->power_supply);
+			chip->poll_time = 0;
 		}
 	} else {
 		if (psp == POWER_SUPPLY_PROP_STATUS)
@@ -327,7 +317,7 @@ static int bq20z75_get_battery_property(struct i2c_client *client,
 	return 0;
 }
 
-static void  bq20z75_unit_adjustment(struct i2c_client *client,
+static void  sbs_unit_adjustment(struct i2c_client *client,
 	enum power_supply_property psp, union power_supply_propval *val)
 {
 #define BASE_UNIT_CONVERSION		1000
@@ -338,7 +328,7 @@ static void  bq20z75_unit_adjustment(struct i2c_client *client,
 	case POWER_SUPPLY_PROP_ENERGY_NOW:
 	case POWER_SUPPLY_PROP_ENERGY_FULL:
 	case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:
-		/* bq20z75 provides energy in units of 10mWh.
+		/* sbs provides energy in units of 10mWh.
 		 * Convert to µWh
 		 */
 		val->intval *= BATTERY_MODE_CAP_MULT_WATT;
@@ -354,7 +344,7 @@ static void  bq20z75_unit_adjustment(struct i2c_client *client,
 		break;
 
 	case POWER_SUPPLY_PROP_TEMP:
-		/* bq20z75 provides battery temperature in 0.1K
+		/* sbs provides battery temperature in 0.1K
 		 * so convert it to 0.1°C
 		 */
 		val->intval -= TEMP_KELVIN_TO_CELSIUS;
@@ -362,7 +352,7 @@ static void  bq20z75_unit_adjustment(struct i2c_client *client,
 
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
 	case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
-		/* bq20z75 provides time to empty and time to full in minutes.
+		/* sbs provides time to empty and time to full in minutes.
 		 * Convert to seconds
 		 */
 		val->intval *= TIME_UNIT_CONVERSION;
@@ -374,13 +364,12 @@ static void  bq20z75_unit_adjustment(struct i2c_client *client,
 	}
 }
 
-static enum bq20z75_battery_mode
-bq20z75_set_battery_mode(struct i2c_client *client,
-	enum bq20z75_battery_mode mode)
+static enum sbs_battery_mode sbs_set_battery_mode(struct i2c_client *client,
+	enum sbs_battery_mode mode)
 {
 	int ret, original_val;
 
-	original_val = bq20z75_read_word_data(client, BATTERY_MODE_OFFSET);
+	original_val = sbs_read_word_data(client, BATTERY_MODE_OFFSET);
 	if (original_val < 0)
 		return original_val;
 
@@ -392,68 +381,67 @@ bq20z75_set_battery_mode(struct i2c_client *client,
 	else
 		ret = original_val | BATTERY_MODE_MASK;
 
-	ret = bq20z75_write_word_data(client, BATTERY_MODE_OFFSET, ret);
+	ret = sbs_write_word_data(client, BATTERY_MODE_OFFSET, ret);
 	if (ret < 0)
 		return ret;
 
 	return original_val & BATTERY_MODE_MASK;
 }
 
-static int bq20z75_get_battery_capacity(struct i2c_client *client,
+static int sbs_get_battery_capacity(struct i2c_client *client,
 	int reg_offset, enum power_supply_property psp,
 	union power_supply_propval *val)
 {
 	s32 ret;
-	enum bq20z75_battery_mode mode = BATTERY_MODE_WATTS;
+	enum sbs_battery_mode mode = BATTERY_MODE_WATTS;
 
 	if (power_supply_is_amp_property(psp))
 		mode = BATTERY_MODE_AMPS;
 
-	mode = bq20z75_set_battery_mode(client, mode);
+	mode = sbs_set_battery_mode(client, mode);
 	if (mode < 0)
 		return mode;
 
-	ret = bq20z75_read_word_data(client, bq20z75_data[reg_offset].addr);
+	ret = sbs_read_word_data(client, sbs_data[reg_offset].addr);
 	if (ret < 0)
 		return ret;
 
 	if (psp == POWER_SUPPLY_PROP_CAPACITY) {
-		/* bq20z75 spec says that this can be >100 %
+		/* sbs spec says that this can be >100 %
 		* even if max value is 100 % */
 		val->intval = min(ret, 100);
 	} else
 		val->intval = ret;
 
-	ret = bq20z75_set_battery_mode(client, mode);
+	ret = sbs_set_battery_mode(client, mode);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-static char bq20z75_serial[5];
-static int bq20z75_get_battery_serial_number(struct i2c_client *client,
+static char sbs_serial[5];
+static int sbs_get_battery_serial_number(struct i2c_client *client,
 	union power_supply_propval *val)
 {
 	int ret;
 
-	ret = bq20z75_read_word_data(client,
-		bq20z75_data[REG_SERIAL_NUMBER].addr);
+	ret = sbs_read_word_data(client, sbs_data[REG_SERIAL_NUMBER].addr);
 	if (ret < 0)
 		return ret;
 
-	ret = sprintf(bq20z75_serial, "%04x", ret);
-	val->strval = bq20z75_serial;
+	ret = sprintf(sbs_serial, "%04x", ret);
+	val->strval = sbs_serial;
 
 	return 0;
 }
 
-static int bq20z75_get_property_index(struct i2c_client *client,
+static int sbs_get_property_index(struct i2c_client *client,
 	enum power_supply_property psp)
 {
 	int count;
-	for (count = 0; count < ARRAY_SIZE(bq20z75_data); count++)
-		if (psp == bq20z75_data[count].psp)
+	for (count = 0; count < ARRAY_SIZE(sbs_data); count++)
+		if (psp == sbs_data[count].psp)
 			return count;
 
 	dev_warn(&client->dev,
@@ -462,19 +450,19 @@ static int bq20z75_get_property_index(struct i2c_client *client,
 	return -EINVAL;
 }
 
-static int bq20z75_get_property(struct power_supply *psy,
+static int sbs_get_property(struct power_supply *psy,
 	enum power_supply_property psp,
 	union power_supply_propval *val)
 {
 	int ret = 0;
-	struct bq20z75_info *bq20z75_device = container_of(psy,
-				struct bq20z75_info, power_supply);
-	struct i2c_client *client = bq20z75_device->client;
+	struct sbs_info *chip = container_of(psy,
+				struct sbs_info, power_supply);
+	struct i2c_client *client = chip->client;
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_PRESENT:
 	case POWER_SUPPLY_PROP_HEALTH:
-		ret = bq20z75_get_battery_presence_and_health(client, psp, val);
+		ret = sbs_get_battery_presence_and_health(client, psp, val);
 		if (psp == POWER_SUPPLY_PROP_PRESENT)
 			return 0;
 		break;
@@ -490,15 +478,15 @@ static int bq20z75_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_CHARGE_FULL:
 	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
 	case POWER_SUPPLY_PROP_CAPACITY:
-		ret = bq20z75_get_property_index(client, psp);
+		ret = sbs_get_property_index(client, psp);
 		if (ret < 0)
 			break;
 
-		ret = bq20z75_get_battery_capacity(client, ret, psp, val);
+		ret = sbs_get_battery_capacity(client, ret, psp, val);
 		break;
 
 	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
-		ret = bq20z75_get_battery_serial_number(client, val);
+		ret = sbs_get_battery_serial_number(client, val);
 		break;
 
 	case POWER_SUPPLY_PROP_STATUS:
@@ -509,11 +497,11 @@ static int bq20z75_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
 	case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
 	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
-		ret = bq20z75_get_property_index(client, psp);
+		ret = sbs_get_property_index(client, psp);
 		if (ret < 0)
 			break;
 
-		ret = bq20z75_get_battery_property(client, ret, psp, val);
+		ret = sbs_get_battery_property(client, ret, psp, val);
 		break;
 
 	default:
@@ -522,25 +510,25 @@ static int bq20z75_get_property(struct power_supply *psy,
 		return -EINVAL;
 	}
 
-	if (!bq20z75_device->enable_detection)
+	if (!chip->enable_detection)
 		goto done;
 
-	if (!bq20z75_device->gpio_detect &&
-		bq20z75_device->is_present != (ret >= 0)) {
-		bq20z75_device->is_present = (ret >= 0);
-		power_supply_changed(&bq20z75_device->power_supply);
+	if (!chip->gpio_detect &&
+		chip->is_present != (ret >= 0)) {
+		chip->is_present = (ret >= 0);
+		power_supply_changed(&chip->power_supply);
 	}
 
 done:
 	if (!ret) {
 		/* Convert units to match requirements for power supply class */
-		bq20z75_unit_adjustment(client, psp, val);
+		sbs_unit_adjustment(client, psp, val);
 	}
 
 	dev_dbg(&client->dev,
 		"%s: property = %d, value = %x\n", __func__, psp, val->intval);
 
-	if (ret && bq20z75_device->is_present)
+	if (ret && chip->is_present)
 		return ret;
 
 	/* battery not present, so return NODATA for properties */
@@ -550,7 +538,7 @@ done:
 	return 0;
 }
 
-static irqreturn_t bq20z75_irq(int irq, void *devid)
+static irqreturn_t sbs_irq(int irq, void *devid)
 {
 	struct power_supply *battery = devid;
 
@@ -559,36 +547,35 @@ static irqreturn_t bq20z75_irq(int irq, void *devid)
 	return IRQ_HANDLED;
 }
 
-static void bq20z75_external_power_changed(struct power_supply *psy)
+static void sbs_external_power_changed(struct power_supply *psy)
 {
-	struct bq20z75_info *bq20z75_device;
+	struct sbs_info *chip;
 
-	bq20z75_device = container_of(psy, struct bq20z75_info, power_supply);
+	chip = container_of(psy, struct sbs_info, power_supply);
 
-	if (bq20z75_device->ignore_changes > 0) {
-		bq20z75_device->ignore_changes--;
+	if (chip->ignore_changes > 0) {
+		chip->ignore_changes--;
 		return;
 	}
 
 	/* cancel outstanding work */
-	cancel_delayed_work_sync(&bq20z75_device->work);
+	cancel_delayed_work_sync(&chip->work);
 
-	schedule_delayed_work(&bq20z75_device->work, HZ);
-	bq20z75_device->poll_time = bq20z75_device->pdata->poll_retry_count;
+	schedule_delayed_work(&chip->work, HZ);
+	chip->poll_time = chip->pdata->poll_retry_count;
 }
 
-static void bq20z75_delayed_work(struct work_struct *work)
+static void sbs_delayed_work(struct work_struct *work)
 {
-	struct bq20z75_info *bq20z75_device;
+	struct sbs_info *chip;
 	s32 ret;
 
-	bq20z75_device = container_of(work, struct bq20z75_info, work.work);
+	chip = container_of(work, struct sbs_info, work.work);
 
-	ret = bq20z75_read_word_data(bq20z75_device->client,
-				     bq20z75_data[REG_STATUS].addr);
+	ret = sbs_read_word_data(chip->client, sbs_data[REG_STATUS].addr);
 	/* if the read failed, give up on this work */
 	if (ret < 0) {
-		bq20z75_device->poll_time = 0;
+		chip->poll_time = 0;
 		return;
 	}
 
@@ -601,14 +588,14 @@ static void bq20z75_delayed_work(struct work_struct *work)
 	else
 		ret = POWER_SUPPLY_STATUS_CHARGING;
 
-	if (bq20z75_device->last_state != ret) {
-		bq20z75_device->poll_time = 0;
-		power_supply_changed(&bq20z75_device->power_supply);
+	if (chip->last_state != ret) {
+		chip->poll_time = 0;
+		power_supply_changed(&chip->power_supply);
 		return;
 	}
-	if (bq20z75_device->poll_time > 0) {
-		schedule_delayed_work(&bq20z75_device->work, HZ);
-		bq20z75_device->poll_time--;
+	if (chip->poll_time > 0) {
+		schedule_delayed_work(&chip->work, HZ);
+		chip->poll_time--;
 		return;
 	}
 }
@@ -618,17 +605,17 @@ static void bq20z75_delayed_work(struct work_struct *work)
 #include <linux/of_device.h>
 #include <linux/of_gpio.h>
 
-static const struct of_device_id bq20z75_dt_ids[] = {
-	{ .compatible = "ti,bq20z75" },
+static const struct of_device_id sbs_dt_ids[] = {
+	{ .compatible = "sbs,sbs-battery" },
 	{ }
 };
-MODULE_DEVICE_TABLE(i2c, bq20z75_dt_ids);
+MODULE_DEVICE_TABLE(i2c, sbs_dt_ids);
 
-static struct bq20z75_platform_data *bq20z75_of_populate_pdata(
+static struct sbs_platform_data *sbs_of_populate_pdata(
 		struct i2c_client *client)
 {
 	struct device_node *of_node = client->dev.of_node;
-	struct bq20z75_platform_data *pdata = client->dev.platform_data;
+	struct sbs_platform_data *pdata = client->dev.platform_data;
 	enum of_gpio_flags gpio_flags;
 	int rc;
 	u32 prop;
@@ -644,31 +631,31 @@ static struct bq20z75_platform_data *bq20z75_of_populate_pdata(
 	/* first make sure at least one property is set, otherwise
 	 * it won't change behavior from running without pdata.
 	 */
-	if (!of_get_property(of_node, "ti,i2c-retry-count", NULL) &&
-		!of_get_property(of_node, "ti,poll-retry-count", NULL) &&
-		!of_get_property(of_node, "ti,battery-detect-gpios", NULL))
+	if (!of_get_property(of_node, "sbs,i2c-retry-count", NULL) &&
+		!of_get_property(of_node, "sbs,poll-retry-count", NULL) &&
+		!of_get_property(of_node, "sbs,battery-detect-gpios", NULL))
 		goto of_out;
 
-	pdata = devm_kzalloc(&client->dev, sizeof(struct bq20z75_platform_data),
+	pdata = devm_kzalloc(&client->dev, sizeof(struct sbs_platform_data),
 				GFP_KERNEL);
 	if (!pdata)
 		goto of_out;
 
-	rc = of_property_read_u32(of_node, "ti,i2c-retry-count", &prop);
+	rc = of_property_read_u32(of_node, "sbs,i2c-retry-count", &prop);
 	if (!rc)
 		pdata->i2c_retry_count = prop;
 
-	rc = of_property_read_u32(of_node, "ti,poll-retry-count", &prop);
+	rc = of_property_read_u32(of_node, "sbs,poll-retry-count", &prop);
 	if (!rc)
 		pdata->poll_retry_count = prop;
 
-	if (!of_get_property(of_node, "ti,battery-detect-gpios", NULL)) {
+	if (!of_get_property(of_node, "sbs,battery-detect-gpios", NULL)) {
 		pdata->battery_detect = -1;
 		goto of_out;
 	}
 
 	pdata->battery_detect = of_get_named_gpio_flags(of_node,
-			"ti,battery-detect-gpios", 0, &gpio_flags);
+			"sbs,battery-detect-gpios", 0, &gpio_flags);
 
 	if (gpio_flags & OF_GPIO_ACTIVE_LOW)
 		pdata->battery_detect_present = 0;
@@ -679,60 +666,57 @@ of_out:
 	return pdata;
 }
 #else
-#define bq20z75_dt_ids NULL
-static struct bq20z75_platform_data *bq20z75_of_populate_pdata(
+#define sbs_dt_ids NULL
+static struct sbs_platform_data *sbs_of_populate_pdata(
 	struct i2c_client *client)
 {
 	return client->dev.platform_data;
 }
 #endif
 
-static int __devinit bq20z75_probe(struct i2c_client *client,
+static int __devinit sbs_probe(struct i2c_client *client,
 	const struct i2c_device_id *id)
 {
-	struct bq20z75_info *bq20z75_device;
-	struct bq20z75_platform_data *pdata = client->dev.platform_data;
+	struct sbs_info *chip;
+	struct sbs_platform_data *pdata = client->dev.platform_data;
 	int rc;
 	int irq;
 
-	bq20z75_device = kzalloc(sizeof(struct bq20z75_info), GFP_KERNEL);
-	if (!bq20z75_device)
+	chip = kzalloc(sizeof(struct sbs_info), GFP_KERNEL);
+	if (!chip)
 		return -ENOMEM;
 
-	bq20z75_device->client = client;
-	bq20z75_device->enable_detection = false;
-	bq20z75_device->gpio_detect = false;
-	bq20z75_device->power_supply.name = "battery";
-	bq20z75_device->power_supply.type = POWER_SUPPLY_TYPE_BATTERY;
-	bq20z75_device->power_supply.properties = bq20z75_properties;
-	bq20z75_device->power_supply.num_properties =
-		ARRAY_SIZE(bq20z75_properties);
-	bq20z75_device->power_supply.get_property = bq20z75_get_property;
+	chip->client = client;
+	chip->enable_detection = false;
+	chip->gpio_detect = false;
+	chip->power_supply.name = "battery";
+	chip->power_supply.type = POWER_SUPPLY_TYPE_BATTERY;
+	chip->power_supply.properties = sbs_properties;
+	chip->power_supply.num_properties = ARRAY_SIZE(sbs_properties);
+	chip->power_supply.get_property = sbs_get_property;
 	/* ignore first notification of external change, it is generated
 	 * from the power_supply_register call back
 	 */
-	bq20z75_device->ignore_changes = 1;
-	bq20z75_device->last_state = POWER_SUPPLY_STATUS_UNKNOWN;
-	bq20z75_device->power_supply.external_power_changed =
-		bq20z75_external_power_changed;
+	chip->ignore_changes = 1;
+	chip->last_state = POWER_SUPPLY_STATUS_UNKNOWN;
+	chip->power_supply.external_power_changed = sbs_external_power_changed;
 
-	pdata = bq20z75_of_populate_pdata(client);
+	pdata = sbs_of_populate_pdata(client);
 
 	if (pdata) {
-		bq20z75_device->gpio_detect =
-			gpio_is_valid(pdata->battery_detect);
-		bq20z75_device->pdata = pdata;
+		chip->gpio_detect = gpio_is_valid(pdata->battery_detect);
+		chip->pdata = pdata;
 	}
 
-	i2c_set_clientdata(client, bq20z75_device);
+	i2c_set_clientdata(client, chip);
 
-	if (!bq20z75_device->gpio_detect)
+	if (!chip->gpio_detect)
 		goto skip_gpio;
 
 	rc = gpio_request(pdata->battery_detect, dev_name(&client->dev));
 	if (rc) {
 		dev_warn(&client->dev, "Failed to request gpio: %d\n", rc);
-		bq20z75_device->gpio_detect = false;
+		chip->gpio_detect = false;
 		goto skip_gpio;
 	}
 
@@ -740,7 +724,7 @@ static int __devinit bq20z75_probe(struct i2c_client *client,
 	if (rc) {
 		dev_warn(&client->dev, "Failed to get gpio as input: %d\n", rc);
 		gpio_free(pdata->battery_detect);
-		bq20z75_device->gpio_detect = false;
+		chip->gpio_detect = false;
 		goto skip_gpio;
 	}
 
@@ -748,25 +732,25 @@ static int __devinit bq20z75_probe(struct i2c_client *client,
 	if (irq <= 0) {
 		dev_warn(&client->dev, "Failed to get gpio as irq: %d\n", irq);
 		gpio_free(pdata->battery_detect);
-		bq20z75_device->gpio_detect = false;
+		chip->gpio_detect = false;
 		goto skip_gpio;
 	}
 
-	rc = request_irq(irq, bq20z75_irq,
+	rc = request_irq(irq, sbs_irq,
 		IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
-		dev_name(&client->dev), &bq20z75_device->power_supply);
+		dev_name(&client->dev), &chip->power_supply);
 	if (rc) {
 		dev_warn(&client->dev, "Failed to request irq: %d\n", rc);
 		gpio_free(pdata->battery_detect);
-		bq20z75_device->gpio_detect = false;
+		chip->gpio_detect = false;
 		goto skip_gpio;
 	}
 
-	bq20z75_device->irq = irq;
+	chip->irq = irq;
 
 skip_gpio:
 
-	rc = power_supply_register(&client->dev, &bq20z75_device->power_supply);
+	rc = power_supply_register(&client->dev, &chip->power_supply);
 	if (rc) {
 		dev_err(&client->dev,
 			"%s: Failed to register power supply\n", __func__);
@@ -776,96 +760,95 @@ skip_gpio:
 	dev_info(&client->dev,
 		"%s: battery gas gauge device registered\n", client->name);
 
-	INIT_DELAYED_WORK(&bq20z75_device->work, bq20z75_delayed_work);
+	INIT_DELAYED_WORK(&chip->work, sbs_delayed_work);
 
-	bq20z75_device->enable_detection = true;
+	chip->enable_detection = true;
 
 	return 0;
 
 exit_psupply:
-	if (bq20z75_device->irq)
-		free_irq(bq20z75_device->irq, &bq20z75_device->power_supply);
-	if (bq20z75_device->gpio_detect)
+	if (chip->irq)
+		free_irq(chip->irq, &chip->power_supply);
+	if (chip->gpio_detect)
 		gpio_free(pdata->battery_detect);
 
-	kfree(bq20z75_device);
+	kfree(chip);
 
 	return rc;
 }
 
-static int __devexit bq20z75_remove(struct i2c_client *client)
+static int __devexit sbs_remove(struct i2c_client *client)
 {
-	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
+	struct sbs_info *chip = i2c_get_clientdata(client);
 
-	if (bq20z75_device->irq)
-		free_irq(bq20z75_device->irq, &bq20z75_device->power_supply);
-	if (bq20z75_device->gpio_detect)
-		gpio_free(bq20z75_device->pdata->battery_detect);
+	if (chip->irq)
+		free_irq(chip->irq, &chip->power_supply);
+	if (chip->gpio_detect)
+		gpio_free(chip->pdata->battery_detect);
 
-	power_supply_unregister(&bq20z75_device->power_supply);
+	power_supply_unregister(&chip->power_supply);
 
-	cancel_delayed_work_sync(&bq20z75_device->work);
+	cancel_delayed_work_sync(&chip->work);
 
-	kfree(bq20z75_device);
-	bq20z75_device = NULL;
+	kfree(chip);
+	chip = NULL;
 
 	return 0;
 }
 
 #if defined CONFIG_PM
-static int bq20z75_suspend(struct i2c_client *client,
+static int sbs_suspend(struct i2c_client *client,
 	pm_message_t state)
 {
-	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
+	struct sbs_info *chip = i2c_get_clientdata(client);
 	s32 ret;
 
-	if (bq20z75_device->poll_time > 0)
-		cancel_delayed_work_sync(&bq20z75_device->work);
+	if (chip->poll_time > 0)
+		cancel_delayed_work_sync(&chip->work);
 
 	/* write to manufacturer access with sleep command */
-	ret = bq20z75_write_word_data(client,
-		bq20z75_data[REG_MANUFACTURER_DATA].addr,
+	ret = sbs_write_word_data(client, sbs_data[REG_MANUFACTURER_DATA].addr,
 		MANUFACTURER_ACCESS_SLEEP);
-	if (bq20z75_device->is_present && ret < 0)
+	if (chip->is_present && ret < 0)
 		return ret;
 
 	return 0;
 }
 #else
-#define bq20z75_suspend		NULL
+#define sbs_suspend		NULL
 #endif
-/* any smbus transaction will wake up bq20z75 */
-#define bq20z75_resume		NULL
+/* any smbus transaction will wake up sbs */
+#define sbs_resume		NULL
 
-static const struct i2c_device_id bq20z75_id[] = {
-	{ "bq20z75", 0 },
+static const struct i2c_device_id sbs_id[] = {
+	{ "sbs-battery", 0 },
 	{}
 };
-MODULE_DEVICE_TABLE(i2c, bq20z75_id);
-
-static struct i2c_driver bq20z75_battery_driver = {
-	.probe		= bq20z75_probe,
-	.remove		= __devexit_p(bq20z75_remove),
-	.suspend	= bq20z75_suspend,
-	.resume		= bq20z75_resume,
-	.id_table	= bq20z75_id,
+MODULE_DEVICE_TABLE(i2c, sbs_id);
+
+static struct i2c_driver sbs_battery_driver = {
+	.probe		= sbs_probe,
+	.remove		= __devexit_p(sbs_remove),
+	.suspend	= sbs_suspend,
+	.resume		= sbs_resume,
+	.id_table	= sbs_id,
 	.driver = {
-		.name	= "bq20z75-battery",
-		.of_match_table = bq20z75_dt_ids,
+		.name	= "sbs-battery",
+		.of_match_table = sbs_dt_ids,
 	},
 };
 
-static int __init bq20z75_battery_init(void)
+static int __init sbs_battery_init(void)
 {
-	return i2c_add_driver(&bq20z75_battery_driver);
+	return i2c_add_driver(&sbs_battery_driver);
 }
-module_init(bq20z75_battery_init);
+module_init(sbs_battery_init);
 
-static void __exit bq20z75_battery_exit(void)
+static void __exit sbs_battery_exit(void)
 {
-	i2c_del_driver(&bq20z75_battery_driver);
+	i2c_del_driver(&sbs_battery_driver);
 }
-module_exit(bq20z75_battery_exit);
+module_exit(sbs_battery_exit);
 
-MODULE_DESCRIPTION("BQ20z75 battery monitor driver");
+MODULE_DESCRIPTION("SBS battery monitor driver");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/power/sbs-battery.h b/include/linux/power/sbs-battery.h
index 1398eb0..2b0a9d9 100644
--- a/include/linux/power/sbs-battery.h
+++ b/include/linux/power/sbs-battery.h
@@ -1,5 +1,5 @@
 /*
- * Gas Gauge driver for TI's BQ20Z75
+ * Gas Gauge driver for SBS Compliant Gas Gauges
  *
  * Copyright (c) 2010, NVIDIA Corporation.
  *
@@ -18,21 +18,21 @@
  * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  */
 
-#ifndef __LINUX_POWER_BQ20Z75_H_
-#define __LINUX_POWER_BQ20Z75_H_
+#ifndef __LINUX_POWER_SBS_BATTERY_H_
+#define __LINUX_POWER_SBS_BATTERY_H_
 
 #include <linux/power_supply.h>
 #include <linux/types.h>
 
 /**
- * struct bq20z75_platform_data - platform data for bq20z75 devices
+ * struct sbs_platform_data - platform data for sbs devices
  * @battery_detect:		GPIO which is used to detect battery presence
  * @battery_detect_present:	gpio state when battery is present (0 / 1)
  * @i2c_retry_count:		# of times to retry on i2c IO failure
  * @poll_retry_count:		# of times to retry looking for new status after
  *				external change notification
  */
-struct bq20z75_platform_data {
+struct sbs_platform_data {
 	int battery_detect;
 	int battery_detect_present;
 	int i2c_retry_count;
-- 
1.7.0.4

