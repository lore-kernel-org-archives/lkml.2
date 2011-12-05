Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab1LEX62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:58:28 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16812 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696Ab1LEX61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:58:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 05 Dec 2011 15:58:21 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 1/2] power: sbs-battery: Rename bq20z75 to sbs-battery
Date: Mon,  5 Dec 2011 15:57:02 -0800
Message-Id: <1323129423-24705-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The register set used in the bq20z75 is really just the set
defined by the SBS spec. With that in mind, this patch is intended
to generalize the driver to in name support any SBS compliant
gas gauge.

-Rename source files to sbs-battery.*
-Rename internals with "sbs"

Change-Id: Ibdfae134c7af9dc1b730d01b36f010f9a1923968
Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/Kconfig             |    8 +-
 drivers/power/Makefile            |    2 +-
 drivers/power/bq20z75.c           |  792 -------------------------------------
 drivers/power/sbs-battery.c       |  775 ++++++++++++++++++++++++++++++++++++
 include/linux/power/bq20z75.h     |   42 --
 include/linux/power/sbs-battery.h |   42 ++
 6 files changed, 822 insertions(+), 839 deletions(-)
 delete mode 100644 drivers/power/bq20z75.c
 create mode 100644 drivers/power/sbs-battery.c
 delete mode 100644 include/linux/power/bq20z75.h
 create mode 100644 include/linux/power/sbs-battery.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index e57b50b..4da63de 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -115,12 +115,12 @@ config BATTERY_WM97XX
 	help
 	  Say Y to enable support for battery measured by WM97xx aux port.
 
-config BATTERY_BQ20Z75
-        tristate "TI BQ20z75 gas gauge"
+config BATTERY_SBS
+        tristate "SBS Compliant gas gauge"
         depends on I2C
         help
-         Say Y to include support for TI BQ20z75 SBS-compliant
-         gas gauge and protection IC.
+         Say Y to include support for SBS battery driver for SBS-compliant
+         gas gauges.
 
 config BATTERY_BQ27x00
 	tristate "BQ27x00 battery driver"
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 009a90f..9a180e8 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -22,7 +22,7 @@ obj-$(CONFIG_BATTERY_OLPC)	+= olpc_battery.o
 obj-$(CONFIG_BATTERY_TOSA)	+= tosa_battery.o
 obj-$(CONFIG_BATTERY_COLLIE)	+= collie_battery.o
 obj-$(CONFIG_BATTERY_WM97XX)	+= wm97xx_battery.o
-obj-$(CONFIG_BATTERY_BQ20Z75)	+= bq20z75.o
+obj-$(CONFIG_BATTERY_SBS)	+= sbs-battery.o
 obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00_battery.o
 obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
 obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
deleted file mode 100644
index e1adc0e..0000000
--- a/drivers/power/bq20z75.c
+++ /dev/null
@@ -1,792 +0,0 @@
-/*
- * Gas Gauge driver for TI's BQ20Z75
- *
- * Copyright (c) 2010, NVIDIA Corporation.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/err.h>
-#include <linux/power_supply.h>
-#include <linux/i2c.h>
-#include <linux/slab.h>
-#include <linux/interrupt.h>
-#include <linux/gpio.h>
-
-#include <linux/power/bq20z75.h>
-
-enum {
-	REG_MANUFACTURER_DATA,
-	REG_TEMPERATURE,
-	REG_VOLTAGE,
-	REG_CURRENT,
-	REG_CAPACITY,
-	REG_TIME_TO_EMPTY,
-	REG_TIME_TO_FULL,
-	REG_STATUS,
-	REG_CYCLE_COUNT,
-	REG_SERIAL_NUMBER,
-	REG_REMAINING_CAPACITY,
-	REG_REMAINING_CAPACITY_CHARGE,
-	REG_FULL_CHARGE_CAPACITY,
-	REG_FULL_CHARGE_CAPACITY_CHARGE,
-	REG_DESIGN_CAPACITY,
-	REG_DESIGN_CAPACITY_CHARGE,
-	REG_DESIGN_VOLTAGE,
-};
-
-/* Battery Mode defines */
-#define BATTERY_MODE_OFFSET		0x03
-#define BATTERY_MODE_MASK		0x8000
-enum bq20z75_battery_mode {
-	BATTERY_MODE_AMPS,
-	BATTERY_MODE_WATTS
-};
-
-/* manufacturer access defines */
-#define MANUFACTURER_ACCESS_STATUS	0x0006
-#define MANUFACTURER_ACCESS_SLEEP	0x0011
-
-/* battery status value bits */
-#define BATTERY_DISCHARGING		0x40
-#define BATTERY_FULL_CHARGED		0x20
-#define BATTERY_FULL_DISCHARGED		0x10
-
-#define BQ20Z75_DATA(_psp, _addr, _min_value, _max_value) { \
-	.psp = _psp, \
-	.addr = _addr, \
-	.min_value = _min_value, \
-	.max_value = _max_value, \
-}
-
-static const struct bq20z75_device_data {
-	enum power_supply_property psp;
-	u8 addr;
-	int min_value;
-	int max_value;
-} bq20z75_data[] = {
-	[REG_MANUFACTURER_DATA] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_PRESENT, 0x00, 0, 65535),
-	[REG_TEMPERATURE] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_TEMP, 0x08, 0, 65535),
-	[REG_VOLTAGE] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_VOLTAGE_NOW, 0x09, 0, 20000),
-	[REG_CURRENT] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_CURRENT_NOW, 0x0A, -32768,
-			32767),
-	[REG_CAPACITY] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_CAPACITY, 0x0E, 0, 100),
-	[REG_REMAINING_CAPACITY] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_ENERGY_NOW, 0x0F, 0, 65535),
-	[REG_REMAINING_CAPACITY_CHARGE] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_CHARGE_NOW, 0x0F, 0, 65535),
-	[REG_FULL_CHARGE_CAPACITY] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_ENERGY_FULL, 0x10, 0, 65535),
-	[REG_FULL_CHARGE_CAPACITY_CHARGE] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_CHARGE_FULL, 0x10, 0, 65535),
-	[REG_TIME_TO_EMPTY] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG, 0x12, 0,
-			65535),
-	[REG_TIME_TO_FULL] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_TIME_TO_FULL_AVG, 0x13, 0,
-			65535),
-	[REG_STATUS] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_STATUS, 0x16, 0, 65535),
-	[REG_CYCLE_COUNT] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_CYCLE_COUNT, 0x17, 0, 65535),
-	[REG_DESIGN_CAPACITY] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN, 0x18, 0,
-			65535),
-	[REG_DESIGN_CAPACITY_CHARGE] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN, 0x18, 0,
-			65535),
-	[REG_DESIGN_VOLTAGE] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN, 0x19, 0,
-			65535),
-	[REG_SERIAL_NUMBER] =
-		BQ20Z75_DATA(POWER_SUPPLY_PROP_SERIAL_NUMBER, 0x1C, 0, 65535),
-};
-
-static enum power_supply_property bq20z75_properties[] = {
-	POWER_SUPPLY_PROP_STATUS,
-	POWER_SUPPLY_PROP_HEALTH,
-	POWER_SUPPLY_PROP_PRESENT,
-	POWER_SUPPLY_PROP_TECHNOLOGY,
-	POWER_SUPPLY_PROP_CYCLE_COUNT,
-	POWER_SUPPLY_PROP_VOLTAGE_NOW,
-	POWER_SUPPLY_PROP_CURRENT_NOW,
-	POWER_SUPPLY_PROP_CAPACITY,
-	POWER_SUPPLY_PROP_TEMP,
-	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
-	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
-	POWER_SUPPLY_PROP_SERIAL_NUMBER,
-	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
-	POWER_SUPPLY_PROP_ENERGY_NOW,
-	POWER_SUPPLY_PROP_ENERGY_FULL,
-	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
-	POWER_SUPPLY_PROP_CHARGE_NOW,
-	POWER_SUPPLY_PROP_CHARGE_FULL,
-	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
-};
-
-struct bq20z75_info {
-	struct i2c_client		*client;
-	struct power_supply		power_supply;
-	struct bq20z75_platform_data	*pdata;
-	bool				is_present;
-	bool				gpio_detect;
-	bool				enable_detection;
-	int				irq;
-	int				last_state;
-	int				poll_time;
-	struct delayed_work		work;
-	int				ignore_changes;
-};
-
-static int bq20z75_read_word_data(struct i2c_client *client, u8 address)
-{
-	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
-	s32 ret = 0;
-	int retries = 1;
-
-	if (bq20z75_device->pdata)
-		retries = max(bq20z75_device->pdata->i2c_retry_count + 1, 1);
-
-	while (retries > 0) {
-		ret = i2c_smbus_read_word_data(client, address);
-		if (ret >= 0)
-			break;
-		retries--;
-	}
-
-	if (ret < 0) {
-		dev_dbg(&client->dev,
-			"%s: i2c read at address 0x%x failed\n",
-			__func__, address);
-		return ret;
-	}
-
-	return le16_to_cpu(ret);
-}
-
-static int bq20z75_write_word_data(struct i2c_client *client, u8 address,
-	u16 value)
-{
-	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
-	s32 ret = 0;
-	int retries = 1;
-
-	if (bq20z75_device->pdata)
-		retries = max(bq20z75_device->pdata->i2c_retry_count + 1, 1);
-
-	while (retries > 0) {
-		ret = i2c_smbus_write_word_data(client, address,
-			le16_to_cpu(value));
-		if (ret >= 0)
-			break;
-		retries--;
-	}
-
-	if (ret < 0) {
-		dev_dbg(&client->dev,
-			"%s: i2c write to address 0x%x failed\n",
-			__func__, address);
-		return ret;
-	}
-
-	return 0;
-}
-
-static int bq20z75_get_battery_presence_and_health(
-	struct i2c_client *client, enum power_supply_property psp,
-	union power_supply_propval *val)
-{
-	s32 ret;
-	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
-
-	if (psp == POWER_SUPPLY_PROP_PRESENT &&
-		bq20z75_device->gpio_detect) {
-		ret = gpio_get_value(
-			bq20z75_device->pdata->battery_detect);
-		if (ret == bq20z75_device->pdata->battery_detect_present)
-			val->intval = 1;
-		else
-			val->intval = 0;
-		bq20z75_device->is_present = val->intval;
-		return ret;
-	}
-
-	/* Write to ManufacturerAccess with
-	 * ManufacturerAccess command and then
-	 * read the status */
-	ret = bq20z75_write_word_data(client,
-		bq20z75_data[REG_MANUFACTURER_DATA].addr,
-		MANUFACTURER_ACCESS_STATUS);
-	if (ret < 0) {
-		if (psp == POWER_SUPPLY_PROP_PRESENT)
-			val->intval = 0; /* battery removed */
-		return ret;
-	}
-
-	ret = bq20z75_read_word_data(client,
-		bq20z75_data[REG_MANUFACTURER_DATA].addr);
-	if (ret < 0)
-		return ret;
-
-	if (ret < bq20z75_data[REG_MANUFACTURER_DATA].min_value ||
-	    ret > bq20z75_data[REG_MANUFACTURER_DATA].max_value) {
-		val->intval = 0;
-		return 0;
-	}
-
-	/* Mask the upper nibble of 2nd byte and
-	 * lower byte of response then
-	 * shift the result by 8 to get status*/
-	ret &= 0x0F00;
-	ret >>= 8;
-	if (psp == POWER_SUPPLY_PROP_PRESENT) {
-		if (ret == 0x0F)
-			/* battery removed */
-			val->intval = 0;
-		else
-			val->intval = 1;
-	} else if (psp == POWER_SUPPLY_PROP_HEALTH) {
-		if (ret == 0x09)
-			val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
-		else if (ret == 0x0B)
-			val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
-		else if (ret == 0x0C)
-			val->intval = POWER_SUPPLY_HEALTH_DEAD;
-		else
-			val->intval = POWER_SUPPLY_HEALTH_GOOD;
-	}
-
-	return 0;
-}
-
-static int bq20z75_get_battery_property(struct i2c_client *client,
-	int reg_offset, enum power_supply_property psp,
-	union power_supply_propval *val)
-{
-	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
-	s32 ret;
-
-	ret = bq20z75_read_word_data(client,
-		bq20z75_data[reg_offset].addr);
-	if (ret < 0)
-		return ret;
-
-	/* returned values are 16 bit */
-	if (bq20z75_data[reg_offset].min_value < 0)
-		ret = (s16)ret;
-
-	if (ret >= bq20z75_data[reg_offset].min_value &&
-	    ret <= bq20z75_data[reg_offset].max_value) {
-		val->intval = ret;
-		if (psp != POWER_SUPPLY_PROP_STATUS)
-			return 0;
-
-		if (ret & BATTERY_FULL_CHARGED)
-			val->intval = POWER_SUPPLY_STATUS_FULL;
-		else if (ret & BATTERY_FULL_DISCHARGED)
-			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
-		else if (ret & BATTERY_DISCHARGING)
-			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
-		else
-			val->intval = POWER_SUPPLY_STATUS_CHARGING;
-
-		if (bq20z75_device->poll_time == 0)
-			bq20z75_device->last_state = val->intval;
-		else if (bq20z75_device->last_state != val->intval) {
-			cancel_delayed_work_sync(&bq20z75_device->work);
-			power_supply_changed(&bq20z75_device->power_supply);
-			bq20z75_device->poll_time = 0;
-		}
-	} else {
-		if (psp == POWER_SUPPLY_PROP_STATUS)
-			val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
-		else
-			val->intval = 0;
-	}
-
-	return 0;
-}
-
-static void  bq20z75_unit_adjustment(struct i2c_client *client,
-	enum power_supply_property psp, union power_supply_propval *val)
-{
-#define BASE_UNIT_CONVERSION		1000
-#define BATTERY_MODE_CAP_MULT_WATT	(10 * BASE_UNIT_CONVERSION)
-#define TIME_UNIT_CONVERSION		60
-#define TEMP_KELVIN_TO_CELSIUS		2731
-	switch (psp) {
-	case POWER_SUPPLY_PROP_ENERGY_NOW:
-	case POWER_SUPPLY_PROP_ENERGY_FULL:
-	case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:
-		/* bq20z75 provides energy in units of 10mWh.
-		 * Convert to µWh
-		 */
-		val->intval *= BATTERY_MODE_CAP_MULT_WATT;
-		break;
-
-	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
-	case POWER_SUPPLY_PROP_CURRENT_NOW:
-	case POWER_SUPPLY_PROP_CHARGE_NOW:
-	case POWER_SUPPLY_PROP_CHARGE_FULL:
-	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
-		val->intval *= BASE_UNIT_CONVERSION;
-		break;
-
-	case POWER_SUPPLY_PROP_TEMP:
-		/* bq20z75 provides battery temperature in 0.1K
-		 * so convert it to 0.1°C
-		 */
-		val->intval -= TEMP_KELVIN_TO_CELSIUS;
-		break;
-
-	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
-	case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
-		/* bq20z75 provides time to empty and time to full in minutes.
-		 * Convert to seconds
-		 */
-		val->intval *= TIME_UNIT_CONVERSION;
-		break;
-
-	default:
-		dev_dbg(&client->dev,
-			"%s: no need for unit conversion %d\n", __func__, psp);
-	}
-}
-
-static enum bq20z75_battery_mode
-bq20z75_set_battery_mode(struct i2c_client *client,
-	enum bq20z75_battery_mode mode)
-{
-	int ret, original_val;
-
-	original_val = bq20z75_read_word_data(client, BATTERY_MODE_OFFSET);
-	if (original_val < 0)
-		return original_val;
-
-	if ((original_val & BATTERY_MODE_MASK) == mode)
-		return mode;
-
-	if (mode == BATTERY_MODE_AMPS)
-		ret = original_val & ~BATTERY_MODE_MASK;
-	else
-		ret = original_val | BATTERY_MODE_MASK;
-
-	ret = bq20z75_write_word_data(client, BATTERY_MODE_OFFSET, ret);
-	if (ret < 0)
-		return ret;
-
-	return original_val & BATTERY_MODE_MASK;
-}
-
-static int bq20z75_get_battery_capacity(struct i2c_client *client,
-	int reg_offset, enum power_supply_property psp,
-	union power_supply_propval *val)
-{
-	s32 ret;
-	enum bq20z75_battery_mode mode = BATTERY_MODE_WATTS;
-
-	if (power_supply_is_amp_property(psp))
-		mode = BATTERY_MODE_AMPS;
-
-	mode = bq20z75_set_battery_mode(client, mode);
-	if (mode < 0)
-		return mode;
-
-	ret = bq20z75_read_word_data(client, bq20z75_data[reg_offset].addr);
-	if (ret < 0)
-		return ret;
-
-	if (psp == POWER_SUPPLY_PROP_CAPACITY) {
-		/* bq20z75 spec says that this can be >100 %
-		* even if max value is 100 % */
-		val->intval = min(ret, 100);
-	} else
-		val->intval = ret;
-
-	ret = bq20z75_set_battery_mode(client, mode);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-static char bq20z75_serial[5];
-static int bq20z75_get_battery_serial_number(struct i2c_client *client,
-	union power_supply_propval *val)
-{
-	int ret;
-
-	ret = bq20z75_read_word_data(client,
-		bq20z75_data[REG_SERIAL_NUMBER].addr);
-	if (ret < 0)
-		return ret;
-
-	ret = sprintf(bq20z75_serial, "%04x", ret);
-	val->strval = bq20z75_serial;
-
-	return 0;
-}
-
-static int bq20z75_get_property_index(struct i2c_client *client,
-	enum power_supply_property psp)
-{
-	int count;
-	for (count = 0; count < ARRAY_SIZE(bq20z75_data); count++)
-		if (psp == bq20z75_data[count].psp)
-			return count;
-
-	dev_warn(&client->dev,
-		"%s: Invalid Property - %d\n", __func__, psp);
-
-	return -EINVAL;
-}
-
-static int bq20z75_get_property(struct power_supply *psy,
-	enum power_supply_property psp,
-	union power_supply_propval *val)
-{
-	int ret = 0;
-	struct bq20z75_info *bq20z75_device = container_of(psy,
-				struct bq20z75_info, power_supply);
-	struct i2c_client *client = bq20z75_device->client;
-
-	switch (psp) {
-	case POWER_SUPPLY_PROP_PRESENT:
-	case POWER_SUPPLY_PROP_HEALTH:
-		ret = bq20z75_get_battery_presence_and_health(client, psp, val);
-		if (psp == POWER_SUPPLY_PROP_PRESENT)
-			return 0;
-		break;
-
-	case POWER_SUPPLY_PROP_TECHNOLOGY:
-		val->intval = POWER_SUPPLY_TECHNOLOGY_LION;
-		break;
-
-	case POWER_SUPPLY_PROP_ENERGY_NOW:
-	case POWER_SUPPLY_PROP_ENERGY_FULL:
-	case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:
-	case POWER_SUPPLY_PROP_CHARGE_NOW:
-	case POWER_SUPPLY_PROP_CHARGE_FULL:
-	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
-	case POWER_SUPPLY_PROP_CAPACITY:
-		ret = bq20z75_get_property_index(client, psp);
-		if (ret < 0)
-			break;
-
-		ret = bq20z75_get_battery_capacity(client, ret, psp, val);
-		break;
-
-	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
-		ret = bq20z75_get_battery_serial_number(client, val);
-		break;
-
-	case POWER_SUPPLY_PROP_STATUS:
-	case POWER_SUPPLY_PROP_CYCLE_COUNT:
-	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-	case POWER_SUPPLY_PROP_CURRENT_NOW:
-	case POWER_SUPPLY_PROP_TEMP:
-	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
-	case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
-	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
-		ret = bq20z75_get_property_index(client, psp);
-		if (ret < 0)
-			break;
-
-		ret = bq20z75_get_battery_property(client, ret, psp, val);
-		break;
-
-	default:
-		dev_err(&client->dev,
-			"%s: INVALID property\n", __func__);
-		return -EINVAL;
-	}
-
-	if (!bq20z75_device->enable_detection)
-		goto done;
-
-	if (!bq20z75_device->gpio_detect &&
-		bq20z75_device->is_present != (ret >= 0)) {
-		bq20z75_device->is_present = (ret >= 0);
-		power_supply_changed(&bq20z75_device->power_supply);
-	}
-
-done:
-	if (!ret) {
-		/* Convert units to match requirements for power supply class */
-		bq20z75_unit_adjustment(client, psp, val);
-	}
-
-	dev_dbg(&client->dev,
-		"%s: property = %d, value = %x\n", __func__, psp, val->intval);
-
-	if (ret && bq20z75_device->is_present)
-		return ret;
-
-	/* battery not present, so return NODATA for properties */
-	if (ret)
-		return -ENODATA;
-
-	return 0;
-}
-
-static irqreturn_t bq20z75_irq(int irq, void *devid)
-{
-	struct power_supply *battery = devid;
-
-	power_supply_changed(battery);
-
-	return IRQ_HANDLED;
-}
-
-static void bq20z75_external_power_changed(struct power_supply *psy)
-{
-	struct bq20z75_info *bq20z75_device;
-
-	bq20z75_device = container_of(psy, struct bq20z75_info, power_supply);
-
-	if (bq20z75_device->ignore_changes > 0) {
-		bq20z75_device->ignore_changes--;
-		return;
-	}
-
-	/* cancel outstanding work */
-	cancel_delayed_work_sync(&bq20z75_device->work);
-
-	schedule_delayed_work(&bq20z75_device->work, HZ);
-	bq20z75_device->poll_time = bq20z75_device->pdata->poll_retry_count;
-}
-
-static void bq20z75_delayed_work(struct work_struct *work)
-{
-	struct bq20z75_info *bq20z75_device;
-	s32 ret;
-
-	bq20z75_device = container_of(work, struct bq20z75_info, work.work);
-
-	ret = bq20z75_read_word_data(bq20z75_device->client,
-				     bq20z75_data[REG_STATUS].addr);
-	/* if the read failed, give up on this work */
-	if (ret < 0) {
-		bq20z75_device->poll_time = 0;
-		return;
-	}
-
-	if (ret & BATTERY_FULL_CHARGED)
-		ret = POWER_SUPPLY_STATUS_FULL;
-	else if (ret & BATTERY_FULL_DISCHARGED)
-		ret = POWER_SUPPLY_STATUS_NOT_CHARGING;
-	else if (ret & BATTERY_DISCHARGING)
-		ret = POWER_SUPPLY_STATUS_DISCHARGING;
-	else
-		ret = POWER_SUPPLY_STATUS_CHARGING;
-
-	if (bq20z75_device->last_state != ret) {
-		bq20z75_device->poll_time = 0;
-		power_supply_changed(&bq20z75_device->power_supply);
-		return;
-	}
-	if (bq20z75_device->poll_time > 0) {
-		schedule_delayed_work(&bq20z75_device->work, HZ);
-		bq20z75_device->poll_time--;
-		return;
-	}
-}
-
-static int __devinit bq20z75_probe(struct i2c_client *client,
-	const struct i2c_device_id *id)
-{
-	struct bq20z75_info *bq20z75_device;
-	struct bq20z75_platform_data *pdata = client->dev.platform_data;
-	int rc;
-	int irq;
-
-	bq20z75_device = kzalloc(sizeof(struct bq20z75_info), GFP_KERNEL);
-	if (!bq20z75_device)
-		return -ENOMEM;
-
-	bq20z75_device->client = client;
-	bq20z75_device->enable_detection = false;
-	bq20z75_device->gpio_detect = false;
-	bq20z75_device->power_supply.name = "battery";
-	bq20z75_device->power_supply.type = POWER_SUPPLY_TYPE_BATTERY;
-	bq20z75_device->power_supply.properties = bq20z75_properties;
-	bq20z75_device->power_supply.num_properties =
-		ARRAY_SIZE(bq20z75_properties);
-	bq20z75_device->power_supply.get_property = bq20z75_get_property;
-	/* ignore first notification of external change, it is generated
-	 * from the power_supply_register call back
-	 */
-	bq20z75_device->ignore_changes = 1;
-	bq20z75_device->last_state = POWER_SUPPLY_STATUS_UNKNOWN;
-	bq20z75_device->power_supply.external_power_changed =
-		bq20z75_external_power_changed;
-
-	if (pdata) {
-		bq20z75_device->gpio_detect =
-			gpio_is_valid(pdata->battery_detect);
-		bq20z75_device->pdata = pdata;
-	}
-
-	i2c_set_clientdata(client, bq20z75_device);
-
-	if (!bq20z75_device->gpio_detect)
-		goto skip_gpio;
-
-	rc = gpio_request(pdata->battery_detect, dev_name(&client->dev));
-	if (rc) {
-		dev_warn(&client->dev, "Failed to request gpio: %d\n", rc);
-		bq20z75_device->gpio_detect = false;
-		goto skip_gpio;
-	}
-
-	rc = gpio_direction_input(pdata->battery_detect);
-	if (rc) {
-		dev_warn(&client->dev, "Failed to get gpio as input: %d\n", rc);
-		gpio_free(pdata->battery_detect);
-		bq20z75_device->gpio_detect = false;
-		goto skip_gpio;
-	}
-
-	irq = gpio_to_irq(pdata->battery_detect);
-	if (irq <= 0) {
-		dev_warn(&client->dev, "Failed to get gpio as irq: %d\n", irq);
-		gpio_free(pdata->battery_detect);
-		bq20z75_device->gpio_detect = false;
-		goto skip_gpio;
-	}
-
-	rc = request_irq(irq, bq20z75_irq,
-		IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
-		dev_name(&client->dev), &bq20z75_device->power_supply);
-	if (rc) {
-		dev_warn(&client->dev, "Failed to request irq: %d\n", rc);
-		gpio_free(pdata->battery_detect);
-		bq20z75_device->gpio_detect = false;
-		goto skip_gpio;
-	}
-
-	bq20z75_device->irq = irq;
-
-skip_gpio:
-
-	rc = power_supply_register(&client->dev, &bq20z75_device->power_supply);
-	if (rc) {
-		dev_err(&client->dev,
-			"%s: Failed to register power supply\n", __func__);
-		goto exit_psupply;
-	}
-
-	dev_info(&client->dev,
-		"%s: battery gas gauge device registered\n", client->name);
-
-	INIT_DELAYED_WORK(&bq20z75_device->work, bq20z75_delayed_work);
-
-	return 0;
-
-exit_psupply:
-	if (bq20z75_device->irq)
-		free_irq(bq20z75_device->irq, &bq20z75_device->power_supply);
-	if (bq20z75_device->gpio_detect)
-		gpio_free(pdata->battery_detect);
-
-	kfree(bq20z75_device);
-
-	return rc;
-}
-
-static int __devexit bq20z75_remove(struct i2c_client *client)
-{
-	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
-
-	if (bq20z75_device->irq)
-		free_irq(bq20z75_device->irq, &bq20z75_device->power_supply);
-	if (bq20z75_device->gpio_detect)
-		gpio_free(bq20z75_device->pdata->battery_detect);
-
-	power_supply_unregister(&bq20z75_device->power_supply);
-
-	cancel_delayed_work_sync(&bq20z75_device->work);
-
-	kfree(bq20z75_device);
-	bq20z75_device = NULL;
-
-	return 0;
-}
-
-#if defined CONFIG_PM
-static int bq20z75_suspend(struct i2c_client *client,
-	pm_message_t state)
-{
-	struct bq20z75_info *bq20z75_device = i2c_get_clientdata(client);
-	s32 ret;
-
-	if (bq20z75_device->poll_time > 0)
-		cancel_delayed_work_sync(&bq20z75_device->work);
-
-	/* write to manufacturer access with sleep command */
-	ret = bq20z75_write_word_data(client,
-		bq20z75_data[REG_MANUFACTURER_DATA].addr,
-		MANUFACTURER_ACCESS_SLEEP);
-	if (bq20z75_device->is_present && ret < 0)
-		return ret;
-
-	return 0;
-}
-#else
-#define bq20z75_suspend		NULL
-#endif
-/* any smbus transaction will wake up bq20z75 */
-#define bq20z75_resume		NULL
-
-static const struct i2c_device_id bq20z75_id[] = {
-	{ "bq20z75", 0 },
-	{}
-};
-MODULE_DEVICE_TABLE(i2c, bq20z75_id);
-
-static struct i2c_driver bq20z75_battery_driver = {
-	.probe		= bq20z75_probe,
-	.remove		= __devexit_p(bq20z75_remove),
-	.suspend	= bq20z75_suspend,
-	.resume		= bq20z75_resume,
-	.id_table	= bq20z75_id,
-	.driver = {
-		.name	= "bq20z75-battery",
-	},
-};
-
-static int __init bq20z75_battery_init(void)
-{
-	return i2c_add_driver(&bq20z75_battery_driver);
-}
-module_init(bq20z75_battery_init);
-
-static void __exit bq20z75_battery_exit(void)
-{
-	i2c_del_driver(&bq20z75_battery_driver);
-}
-module_exit(bq20z75_battery_exit);
-
-MODULE_DESCRIPTION("BQ20z75 battery monitor driver");
-MODULE_LICENSE("GPL");
diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
new file mode 100644
index 0000000..1e60a54
--- /dev/null
+++ b/drivers/power/sbs-battery.c
@@ -0,0 +1,775 @@
+/*
+ * Gas Gauge driver for SBS Compliant Batteries
+ *
+ * Copyright (c) 2010, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/power_supply.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+
+#include <linux/power/sbs-battery.h>
+
+enum {
+	REG_MANUFACTURER_DATA,
+	REG_TEMPERATURE,
+	REG_VOLTAGE,
+	REG_CURRENT,
+	REG_CAPACITY,
+	REG_TIME_TO_EMPTY,
+	REG_TIME_TO_FULL,
+	REG_STATUS,
+	REG_CYCLE_COUNT,
+	REG_SERIAL_NUMBER,
+	REG_REMAINING_CAPACITY,
+	REG_REMAINING_CAPACITY_CHARGE,
+	REG_FULL_CHARGE_CAPACITY,
+	REG_FULL_CHARGE_CAPACITY_CHARGE,
+	REG_DESIGN_CAPACITY,
+	REG_DESIGN_CAPACITY_CHARGE,
+	REG_DESIGN_VOLTAGE,
+};
+
+/* Battery Mode defines */
+#define BATTERY_MODE_OFFSET		0x03
+#define BATTERY_MODE_MASK		0x8000
+enum sbs_battery_mode {
+	BATTERY_MODE_AMPS,
+	BATTERY_MODE_WATTS
+};
+
+/* manufacturer access defines */
+#define MANUFACTURER_ACCESS_STATUS	0x0006
+#define MANUFACTURER_ACCESS_SLEEP	0x0011
+
+/* battery status value bits */
+#define BATTERY_DISCHARGING		0x40
+#define BATTERY_FULL_CHARGED		0x20
+#define BATTERY_FULL_DISCHARGED		0x10
+
+#define SBS_DATA(_psp, _addr, _min_value, _max_value) { \
+	.psp = _psp, \
+	.addr = _addr, \
+	.min_value = _min_value, \
+	.max_value = _max_value, \
+}
+
+static const struct chip_data {
+	enum power_supply_property psp;
+	u8 addr;
+	int min_value;
+	int max_value;
+} sbs_data[] = {
+	[REG_MANUFACTURER_DATA] =
+		SBS_DATA(POWER_SUPPLY_PROP_PRESENT, 0x00, 0, 65535),
+	[REG_TEMPERATURE] =
+		SBS_DATA(POWER_SUPPLY_PROP_TEMP, 0x08, 0, 65535),
+	[REG_VOLTAGE] =
+		SBS_DATA(POWER_SUPPLY_PROP_VOLTAGE_NOW, 0x09, 0, 20000),
+	[REG_CURRENT] =
+		SBS_DATA(POWER_SUPPLY_PROP_CURRENT_NOW, 0x0A, -32768, 32767),
+	[REG_CAPACITY] =
+		SBS_DATA(POWER_SUPPLY_PROP_CAPACITY, 0x0E, 0, 100),
+	[REG_REMAINING_CAPACITY] =
+		SBS_DATA(POWER_SUPPLY_PROP_ENERGY_NOW, 0x0F, 0, 65535),
+	[REG_REMAINING_CAPACITY_CHARGE] =
+		SBS_DATA(POWER_SUPPLY_PROP_CHARGE_NOW, 0x0F, 0, 65535),
+	[REG_FULL_CHARGE_CAPACITY] =
+		SBS_DATA(POWER_SUPPLY_PROP_ENERGY_FULL, 0x10, 0, 65535),
+	[REG_FULL_CHARGE_CAPACITY_CHARGE] =
+		SBS_DATA(POWER_SUPPLY_PROP_CHARGE_FULL, 0x10, 0, 65535),
+	[REG_TIME_TO_EMPTY] =
+		SBS_DATA(POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG, 0x12, 0, 65535),
+	[REG_TIME_TO_FULL] =
+		SBS_DATA(POWER_SUPPLY_PROP_TIME_TO_FULL_AVG, 0x13, 0, 65535),
+	[REG_STATUS] =
+		SBS_DATA(POWER_SUPPLY_PROP_STATUS, 0x16, 0, 65535),
+	[REG_CYCLE_COUNT] =
+		SBS_DATA(POWER_SUPPLY_PROP_CYCLE_COUNT, 0x17, 0, 65535),
+	[REG_DESIGN_CAPACITY] =
+		SBS_DATA(POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN, 0x18, 0, 65535),
+	[REG_DESIGN_CAPACITY_CHARGE] =
+		SBS_DATA(POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN, 0x18, 0, 65535),
+	[REG_DESIGN_VOLTAGE] =
+		SBS_DATA(POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN, 0x19, 0, 65535),
+	[REG_SERIAL_NUMBER] =
+		SBS_DATA(POWER_SUPPLY_PROP_SERIAL_NUMBER, 0x1C, 0, 65535),
+};
+
+static enum power_supply_property sbs_properties[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_CYCLE_COUNT,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
+	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
+	POWER_SUPPLY_PROP_SERIAL_NUMBER,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
+	POWER_SUPPLY_PROP_ENERGY_NOW,
+	POWER_SUPPLY_PROP_ENERGY_FULL,
+	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
+	POWER_SUPPLY_PROP_CHARGE_NOW,
+	POWER_SUPPLY_PROP_CHARGE_FULL,
+	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
+};
+
+struct sbs_info {
+	struct i2c_client		*client;
+	struct power_supply		power_supply;
+	struct sbs_platform_data	*pdata;
+	bool				is_present;
+	bool				gpio_detect;
+	bool				enable_detection;
+	int				irq;
+	int				last_state;
+	int				poll_time;
+	struct delayed_work		work;
+	int				ignore_changes;
+};
+
+static int sbs_read_word_data(struct i2c_client *client, u8 address)
+{
+	struct sbs_info *chip = i2c_get_clientdata(client);
+	s32 ret = 0;
+	int retries = 1;
+
+	if (chip->pdata)
+		retries = max(chip->pdata->i2c_retry_count + 1, 1);
+
+	while (retries > 0) {
+		ret = i2c_smbus_read_word_data(client, address);
+		if (ret >= 0)
+			break;
+		retries--;
+	}
+
+	if (ret < 0) {
+		dev_dbg(&client->dev,
+			"%s: i2c read at address 0x%x failed\n",
+			__func__, address);
+		return ret;
+	}
+
+	return le16_to_cpu(ret);
+}
+
+static int sbs_write_word_data(struct i2c_client *client, u8 address,
+	u16 value)
+{
+	struct sbs_info *chip = i2c_get_clientdata(client);
+	s32 ret = 0;
+	int retries = 1;
+
+	if (chip->pdata)
+		retries = max(chip->pdata->i2c_retry_count + 1, 1);
+
+	while (retries > 0) {
+		ret = i2c_smbus_write_word_data(client, address,
+			le16_to_cpu(value));
+		if (ret >= 0)
+			break;
+		retries--;
+	}
+
+	if (ret < 0) {
+		dev_dbg(&client->dev,
+			"%s: i2c write to address 0x%x failed\n",
+			__func__, address);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int sbs_get_battery_presence_and_health(
+	struct i2c_client *client, enum power_supply_property psp,
+	union power_supply_propval *val)
+{
+	s32 ret;
+	struct sbs_info *chip = i2c_get_clientdata(client);
+
+	if (psp == POWER_SUPPLY_PROP_PRESENT &&
+		chip->gpio_detect) {
+		ret = gpio_get_value(chip->pdata->battery_detect);
+		if (ret == chip->pdata->battery_detect_present)
+			val->intval = 1;
+		else
+			val->intval = 0;
+		chip->is_present = val->intval;
+		return ret;
+	}
+
+	/* Write to ManufacturerAccess with
+	 * ManufacturerAccess command and then
+	 * read the status */
+	ret = sbs_write_word_data(client, sbs_data[REG_MANUFACTURER_DATA].addr,
+					MANUFACTURER_ACCESS_STATUS);
+	if (ret < 0) {
+		if (psp == POWER_SUPPLY_PROP_PRESENT)
+			val->intval = 0; /* battery removed */
+		return ret;
+	}
+
+	ret = sbs_read_word_data(client, sbs_data[REG_MANUFACTURER_DATA].addr);
+	if (ret < 0)
+		return ret;
+
+	if (ret < sbs_data[REG_MANUFACTURER_DATA].min_value ||
+	    ret > sbs_data[REG_MANUFACTURER_DATA].max_value) {
+		val->intval = 0;
+		return 0;
+	}
+
+	/* Mask the upper nibble of 2nd byte and
+	 * lower byte of response then
+	 * shift the result by 8 to get status*/
+	ret &= 0x0F00;
+	ret >>= 8;
+	if (psp == POWER_SUPPLY_PROP_PRESENT) {
+		if (ret == 0x0F)
+			/* battery removed */
+			val->intval = 0;
+		else
+			val->intval = 1;
+	} else if (psp == POWER_SUPPLY_PROP_HEALTH) {
+		if (ret == 0x09)
+			val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
+		else if (ret == 0x0B)
+			val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
+		else if (ret == 0x0C)
+			val->intval = POWER_SUPPLY_HEALTH_DEAD;
+		else
+			val->intval = POWER_SUPPLY_HEALTH_GOOD;
+	}
+
+	return 0;
+}
+
+static int sbs_get_battery_property(struct i2c_client *client,
+	int reg_offset, enum power_supply_property psp,
+	union power_supply_propval *val)
+{
+	struct sbs_info *chip = i2c_get_clientdata(client);
+	s32 ret;
+
+	ret = sbs_read_word_data(client, sbs_data[reg_offset].addr);
+	if (ret < 0)
+		return ret;
+
+	/* returned values are 16 bit */
+	if (sbs_data[reg_offset].min_value < 0)
+		ret = (s16)ret;
+
+	if (ret >= sbs_data[reg_offset].min_value &&
+	    ret <= sbs_data[reg_offset].max_value) {
+		val->intval = ret;
+		if (psp != POWER_SUPPLY_PROP_STATUS)
+			return 0;
+
+		if (ret & BATTERY_FULL_CHARGED)
+			val->intval = POWER_SUPPLY_STATUS_FULL;
+		else if (ret & BATTERY_FULL_DISCHARGED)
+			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
+		else if (ret & BATTERY_DISCHARGING)
+			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+		else
+			val->intval = POWER_SUPPLY_STATUS_CHARGING;
+
+		if (chip->poll_time == 0)
+			chip->last_state = val->intval;
+		else if (chip->last_state != val->intval) {
+			cancel_delayed_work_sync(&chip->work);
+			power_supply_changed(&chip->power_supply);
+			chip->poll_time = 0;
+		}
+	} else {
+		if (psp == POWER_SUPPLY_PROP_STATUS)
+			val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
+		else
+			val->intval = 0;
+	}
+
+	return 0;
+}
+
+static void  sbs_unit_adjustment(struct i2c_client *client,
+	enum power_supply_property psp, union power_supply_propval *val)
+{
+#define BASE_UNIT_CONVERSION		1000
+#define BATTERY_MODE_CAP_MULT_WATT	(10 * BASE_UNIT_CONVERSION)
+#define TIME_UNIT_CONVERSION		60
+#define TEMP_KELVIN_TO_CELSIUS		2731
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ENERGY_NOW:
+	case POWER_SUPPLY_PROP_ENERGY_FULL:
+	case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:
+		/* sbs provides energy in units of 10mWh.
+		 * Convert to µWh
+		 */
+		val->intval *= BATTERY_MODE_CAP_MULT_WATT;
+		break;
+
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+	case POWER_SUPPLY_PROP_CHARGE_FULL:
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+		val->intval *= BASE_UNIT_CONVERSION;
+		break;
+
+	case POWER_SUPPLY_PROP_TEMP:
+		/* sbs provides battery temperature in 0.1K
+		 * so convert it to 0.1°C
+		 */
+		val->intval -= TEMP_KELVIN_TO_CELSIUS;
+		break;
+
+	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
+	case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
+		/* sbs provides time to empty and time to full in minutes.
+		 * Convert to seconds
+		 */
+		val->intval *= TIME_UNIT_CONVERSION;
+		break;
+
+	default:
+		dev_dbg(&client->dev,
+			"%s: no need for unit conversion %d\n", __func__, psp);
+	}
+}
+
+static enum sbs_battery_mode sbs_set_battery_mode(struct i2c_client *client,
+	enum sbs_battery_mode mode)
+{
+	int ret, original_val;
+
+	original_val = sbs_read_word_data(client, BATTERY_MODE_OFFSET);
+	if (original_val < 0)
+		return original_val;
+
+	if ((original_val & BATTERY_MODE_MASK) == mode)
+		return mode;
+
+	if (mode == BATTERY_MODE_AMPS)
+		ret = original_val & ~BATTERY_MODE_MASK;
+	else
+		ret = original_val | BATTERY_MODE_MASK;
+
+	ret = sbs_write_word_data(client, BATTERY_MODE_OFFSET, ret);
+	if (ret < 0)
+		return ret;
+
+	return original_val & BATTERY_MODE_MASK;
+}
+
+static int sbs_get_battery_capacity(struct i2c_client *client,
+	int reg_offset, enum power_supply_property psp,
+	union power_supply_propval *val)
+{
+	s32 ret;
+	enum sbs_battery_mode mode = BATTERY_MODE_WATTS;
+
+	if (power_supply_is_amp_property(psp))
+		mode = BATTERY_MODE_AMPS;
+
+	mode = sbs_set_battery_mode(client, mode);
+	if (mode < 0)
+		return mode;
+
+	ret = sbs_read_word_data(client, sbs_data[reg_offset].addr);
+	if (ret < 0)
+		return ret;
+
+	if (psp == POWER_SUPPLY_PROP_CAPACITY) {
+		/* sbs spec says that this can be >100 %
+		* even if max value is 100 % */
+		val->intval = min(ret, 100);
+	} else
+		val->intval = ret;
+
+	ret = sbs_set_battery_mode(client, mode);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static char sbs_serial[5];
+static int sbs_get_battery_serial_number(struct i2c_client *client,
+	union power_supply_propval *val)
+{
+	int ret;
+
+	ret = sbs_read_word_data(client, sbs_data[REG_SERIAL_NUMBER].addr);
+	if (ret < 0)
+		return ret;
+
+	ret = sprintf(sbs_serial, "%04x", ret);
+	val->strval = sbs_serial;
+
+	return 0;
+}
+
+static int sbs_get_property_index(struct i2c_client *client,
+	enum power_supply_property psp)
+{
+	int count;
+	for (count = 0; count < ARRAY_SIZE(sbs_data); count++)
+		if (psp == sbs_data[count].psp)
+			return count;
+
+	dev_warn(&client->dev,
+		"%s: Invalid Property - %d\n", __func__, psp);
+
+	return -EINVAL;
+}
+
+static int sbs_get_property(struct power_supply *psy,
+	enum power_supply_property psp,
+	union power_supply_propval *val)
+{
+	int ret = 0;
+	struct sbs_info *chip = container_of(psy,
+				struct sbs_info, power_supply);
+	struct i2c_client *client = chip->client;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_PRESENT:
+	case POWER_SUPPLY_PROP_HEALTH:
+		ret = sbs_get_battery_presence_and_health(client, psp, val);
+		if (psp == POWER_SUPPLY_PROP_PRESENT)
+			return 0;
+		break;
+
+	case POWER_SUPPLY_PROP_TECHNOLOGY:
+		val->intval = POWER_SUPPLY_TECHNOLOGY_LION;
+		break;
+
+	case POWER_SUPPLY_PROP_ENERGY_NOW:
+	case POWER_SUPPLY_PROP_ENERGY_FULL:
+	case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+	case POWER_SUPPLY_PROP_CHARGE_FULL:
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+	case POWER_SUPPLY_PROP_CAPACITY:
+		ret = sbs_get_property_index(client, psp);
+		if (ret < 0)
+			break;
+
+		ret = sbs_get_battery_capacity(client, ret, psp, val);
+		break;
+
+	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
+		ret = sbs_get_battery_serial_number(client, val);
+		break;
+
+	case POWER_SUPPLY_PROP_STATUS:
+	case POWER_SUPPLY_PROP_CYCLE_COUNT:
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+	case POWER_SUPPLY_PROP_TEMP:
+	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
+	case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+		ret = sbs_get_property_index(client, psp);
+		if (ret < 0)
+			break;
+
+		ret = sbs_get_battery_property(client, ret, psp, val);
+		break;
+
+	default:
+		dev_err(&client->dev,
+			"%s: INVALID property\n", __func__);
+		return -EINVAL;
+	}
+
+	if (!chip->enable_detection)
+		goto done;
+
+	if (!chip->gpio_detect &&
+		chip->is_present != (ret >= 0)) {
+		chip->is_present = (ret >= 0);
+		power_supply_changed(&chip->power_supply);
+	}
+
+done:
+	if (!ret) {
+		/* Convert units to match requirements for power supply class */
+		sbs_unit_adjustment(client, psp, val);
+	}
+
+	dev_dbg(&client->dev,
+		"%s: property = %d, value = %x\n", __func__, psp, val->intval);
+
+	if (ret && chip->is_present)
+		return ret;
+
+	/* battery not present, so return NODATA for properties */
+	if (ret)
+		return -ENODATA;
+
+	return 0;
+}
+
+static irqreturn_t sbs_irq(int irq, void *devid)
+{
+	struct power_supply *battery = devid;
+
+	power_supply_changed(battery);
+
+	return IRQ_HANDLED;
+}
+
+static void sbs_external_power_changed(struct power_supply *psy)
+{
+	struct sbs_info *chip;
+
+	chip = container_of(psy, struct sbs_info, power_supply);
+
+	if (chip->ignore_changes > 0) {
+		chip->ignore_changes--;
+		return;
+	}
+
+	/* cancel outstanding work */
+	cancel_delayed_work_sync(&chip->work);
+
+	schedule_delayed_work(&chip->work, HZ);
+	chip->poll_time = chip->pdata->poll_retry_count;
+}
+
+static void sbs_delayed_work(struct work_struct *work)
+{
+	struct sbs_info *chip;
+	s32 ret;
+
+	chip = container_of(work, struct sbs_info, work.work);
+
+	ret = sbs_read_word_data(chip->client, sbs_data[REG_STATUS].addr);
+	/* if the read failed, give up on this work */
+	if (ret < 0) {
+		chip->poll_time = 0;
+		return;
+	}
+
+	if (ret & BATTERY_FULL_CHARGED)
+		ret = POWER_SUPPLY_STATUS_FULL;
+	else if (ret & BATTERY_FULL_DISCHARGED)
+		ret = POWER_SUPPLY_STATUS_NOT_CHARGING;
+	else if (ret & BATTERY_DISCHARGING)
+		ret = POWER_SUPPLY_STATUS_DISCHARGING;
+	else
+		ret = POWER_SUPPLY_STATUS_CHARGING;
+
+	if (chip->last_state != ret) {
+		chip->poll_time = 0;
+		power_supply_changed(&chip->power_supply);
+		return;
+	}
+	if (chip->poll_time > 0) {
+		schedule_delayed_work(&chip->work, HZ);
+		chip->poll_time--;
+		return;
+	}
+}
+
+static int __devinit sbs_probe(struct i2c_client *client,
+	const struct i2c_device_id *id)
+{
+	struct sbs_info *chip;
+	struct sbs_platform_data *pdata = client->dev.platform_data;
+	int rc;
+	int irq;
+
+	chip = kzalloc(sizeof(struct sbs_info), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	chip->client = client;
+	chip->enable_detection = false;
+	chip->gpio_detect = false;
+	chip->power_supply.name = "battery";
+	chip->power_supply.type = POWER_SUPPLY_TYPE_BATTERY;
+	chip->power_supply.properties = sbs_properties;
+	chip->power_supply.num_properties = ARRAY_SIZE(sbs_properties);
+	chip->power_supply.get_property = sbs_get_property;
+	/* ignore first notification of external change, it is generated
+	 * from the power_supply_register call back
+	 */
+	chip->ignore_changes = 1;
+	chip->last_state = POWER_SUPPLY_STATUS_UNKNOWN;
+	chip->power_supply.external_power_changed = sbs_external_power_changed;
+
+	if (pdata) {
+		chip->gpio_detect = gpio_is_valid(pdata->battery_detect);
+		chip->pdata = pdata;
+	}
+
+	i2c_set_clientdata(client, chip);
+
+	if (!chip->gpio_detect)
+		goto skip_gpio;
+
+	rc = gpio_request(pdata->battery_detect, dev_name(&client->dev));
+	if (rc) {
+		dev_warn(&client->dev, "Failed to request gpio: %d\n", rc);
+		chip->gpio_detect = false;
+		goto skip_gpio;
+	}
+
+	rc = gpio_direction_input(pdata->battery_detect);
+	if (rc) {
+		dev_warn(&client->dev, "Failed to get gpio as input: %d\n", rc);
+		gpio_free(pdata->battery_detect);
+		chip->gpio_detect = false;
+		goto skip_gpio;
+	}
+
+	irq = gpio_to_irq(pdata->battery_detect);
+	if (irq <= 0) {
+		dev_warn(&client->dev, "Failed to get gpio as irq: %d\n", irq);
+		gpio_free(pdata->battery_detect);
+		chip->gpio_detect = false;
+		goto skip_gpio;
+	}
+
+	rc = request_irq(irq, sbs_irq,
+		IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+		dev_name(&client->dev), &chip->power_supply);
+	if (rc) {
+		dev_warn(&client->dev, "Failed to request irq: %d\n", rc);
+		gpio_free(pdata->battery_detect);
+		chip->gpio_detect = false;
+		goto skip_gpio;
+	}
+
+	chip->irq = irq;
+
+skip_gpio:
+
+	rc = power_supply_register(&client->dev, &chip->power_supply);
+	if (rc) {
+		dev_err(&client->dev,
+			"%s: Failed to register power supply\n", __func__);
+		goto exit_psupply;
+	}
+
+	dev_info(&client->dev,
+		"%s: battery gas gauge device registered\n", client->name);
+
+	INIT_DELAYED_WORK(&chip->work, sbs_delayed_work);
+
+	return 0;
+
+exit_psupply:
+	if (chip->irq)
+		free_irq(chip->irq, &chip->power_supply);
+	if (chip->gpio_detect)
+		gpio_free(pdata->battery_detect);
+
+	kfree(chip);
+
+	return rc;
+}
+
+static int __devexit sbs_remove(struct i2c_client *client)
+{
+	struct sbs_info *chip = i2c_get_clientdata(client);
+
+	if (chip->irq)
+		free_irq(chip->irq, &chip->power_supply);
+	if (chip->gpio_detect)
+		gpio_free(chip->pdata->battery_detect);
+
+	power_supply_unregister(&chip->power_supply);
+
+	cancel_delayed_work_sync(&chip->work);
+
+	kfree(chip);
+	chip = NULL;
+
+	return 0;
+}
+
+#if defined CONFIG_PM
+static int sbs_suspend(struct i2c_client *client,
+	pm_message_t state)
+{
+	struct sbs_info *chip = i2c_get_clientdata(client);
+	s32 ret;
+
+	if (chip->poll_time > 0)
+		cancel_delayed_work_sync(&chip->work);
+
+	/* write to manufacturer access with sleep command */
+	ret = sbs_write_word_data(client, sbs_data[REG_MANUFACTURER_DATA].addr,
+		MANUFACTURER_ACCESS_SLEEP);
+	if (chip->is_present && ret < 0)
+		return ret;
+
+	return 0;
+}
+#else
+#define sbs_suspend		NULL
+#endif
+/* any smbus transaction will wake up sbs */
+#define sbs_resume		NULL
+
+static const struct i2c_device_id sbs_id[] = {
+	{ "sbs-battery", 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, sbs_id);
+
+static struct i2c_driver sbs_battery_driver = {
+	.probe		= sbs_probe,
+	.remove		= __devexit_p(sbs_remove),
+	.suspend	= sbs_suspend,
+	.resume		= sbs_resume,
+	.id_table	= sbs_id,
+	.driver = {
+		.name	= "sbs-battery",
+	},
+};
+
+static int __init sbs_battery_init(void)
+{
+	return i2c_add_driver(&sbs_battery_driver);
+}
+module_init(sbs_battery_init);
+
+static void __exit sbs_battery_exit(void)
+{
+	i2c_del_driver(&sbs_battery_driver);
+}
+module_exit(sbs_battery_exit);
+
+MODULE_DESCRIPTION("SBS battery monitor driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/power/bq20z75.h b/include/linux/power/bq20z75.h
deleted file mode 100644
index 1398eb0..0000000
--- a/include/linux/power/bq20z75.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * Gas Gauge driver for TI's BQ20Z75
- *
- * Copyright (c) 2010, NVIDIA Corporation.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
- */
-
-#ifndef __LINUX_POWER_BQ20Z75_H_
-#define __LINUX_POWER_BQ20Z75_H_
-
-#include <linux/power_supply.h>
-#include <linux/types.h>
-
-/**
- * struct bq20z75_platform_data - platform data for bq20z75 devices
- * @battery_detect:		GPIO which is used to detect battery presence
- * @battery_detect_present:	gpio state when battery is present (0 / 1)
- * @i2c_retry_count:		# of times to retry on i2c IO failure
- * @poll_retry_count:		# of times to retry looking for new status after
- *				external change notification
- */
-struct bq20z75_platform_data {
-	int battery_detect;
-	int battery_detect_present;
-	int i2c_retry_count;
-	int poll_retry_count;
-};
-
-#endif
diff --git a/include/linux/power/sbs-battery.h b/include/linux/power/sbs-battery.h
new file mode 100644
index 0000000..2b0a9d9
--- /dev/null
+++ b/include/linux/power/sbs-battery.h
@@ -0,0 +1,42 @@
+/*
+ * Gas Gauge driver for SBS Compliant Gas Gauges
+ *
+ * Copyright (c) 2010, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#ifndef __LINUX_POWER_SBS_BATTERY_H_
+#define __LINUX_POWER_SBS_BATTERY_H_
+
+#include <linux/power_supply.h>
+#include <linux/types.h>
+
+/**
+ * struct sbs_platform_data - platform data for sbs devices
+ * @battery_detect:		GPIO which is used to detect battery presence
+ * @battery_detect_present:	gpio state when battery is present (0 / 1)
+ * @i2c_retry_count:		# of times to retry on i2c IO failure
+ * @poll_retry_count:		# of times to retry looking for new status after
+ *				external change notification
+ */
+struct sbs_platform_data {
+	int battery_detect;
+	int battery_detect_present;
+	int i2c_retry_count;
+	int poll_retry_count;
+};
+
+#endif
-- 
1.7.0.4

