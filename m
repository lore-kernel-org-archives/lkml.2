Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031005Ab2B2OAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:00:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58468 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030973Ab2B2OAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:00:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rsayakhova@gmail.com designates 10.180.90.212 as permitted sender) smtp.mail=rsayakhova@gmail.com; dkim=pass header.i=rsayakhova@gmail.com
From: Renata Sayakhova <rsayakhova@gmail.com>
To: zbr@ioremap.net
Cc: linux-kernel@vger.kernel.org, rsayakhova@gmail.com
Subject: [PATCH] DS2781 Maxim Stand-Alone Fuel Gauge battery and w1 slave drivers
Date: Wed, 29 Feb 2012 14:58:53 +0100
Message-Id: <1330523933-32344-2-git-send-email-rsayakhova@gmail.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1330523933-32344-1-git-send-email-rsayakhova@gmail.com>
References: <1330523933-32344-1-git-send-email-rsayakhova@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Renata Sayakhova <rsayakhova@gmail.com>
---
 drivers/power/Kconfig          |   14 +
 drivers/power/Makefile         |    1 +
 drivers/power/ds2781_battery.c |  874 ++++++++++++++++++++++++++++++++++++++++
 drivers/w1/slaves/Kconfig      |   13 +
 drivers/w1/slaves/Makefile     |    1 +
 drivers/w1/slaves/w1_ds2781.c  |  201 +++++++++
 drivers/w1/slaves/w1_ds2781.h  |  136 +++++++
 drivers/w1/w1_family.h         |    1 +
 8 files changed, 1241 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/ds2781_battery.c
 create mode 100644 drivers/w1/slaves/w1_ds2781.c
 create mode 100644 drivers/w1/slaves/w1_ds2781.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 3a8daf8..459f664 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -76,6 +76,20 @@ config BATTERY_DS2780
 	help
 	  Say Y here to enable support for batteries with ds2780 chip.
 
+config BATTERY_DS2781
+	tristate "2781 battery driver"
+	depends on HAS_IOMEM
+	select W1
+	select W1_SLAVE_DS2781
+	help
+	  If you enable this you will have the DS2781 battery driver support.
+
+	  The battery monitor chip is used in many batteries/devices
+	  as the one who is responsible for charging/discharging/monitoring
+	  Li+ batteries.
+
+	  If you are unsure, say N.
+
 config BATTERY_DS2782
 	tristate "DS2782/DS2786 standalone gas-gauge"
 	depends on I2C
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index e429008..c590fa5 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_TEST_POWER)	+= test_power.o
 
 obj-$(CONFIG_BATTERY_DS2760)	+= ds2760_battery.o
 obj-$(CONFIG_BATTERY_DS2780)	+= ds2780_battery.o
+obj-$(CONFIG_BATTERY_DS2781)	+= ds2781_battery.o
 obj-$(CONFIG_BATTERY_DS2782)	+= ds2782_battery.o
 obj-$(CONFIG_BATTERY_PMU)	+= pmu_battery.o
 obj-$(CONFIG_BATTERY_OLPC)	+= olpc_battery.o
diff --git a/drivers/power/ds2781_battery.c b/drivers/power/ds2781_battery.c
new file mode 100644
index 0000000..ca0d653
--- /dev/null
+++ b/drivers/power/ds2781_battery.c
@@ -0,0 +1,874 @@
+/*
+ * 1-wire client/driver for the Maxim/Dallas DS2781 Stand-Alone Fuel Gauge IC
+ *
+ * Author: Renata Sayakhova <renata@oktetlabs.ru>
+ *
+ * Based on ds2780_battery drivers
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/param.h>
+#include <linux/pm.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/idr.h>
+
+#include "../w1/w1.h"
+#include "../w1/slaves/w1_ds2781.h"
+
+/* Current unit measurement in uA for a 1 milli-ohm sense resistor */
+#define DS2781_CURRENT_UNITS	1563
+/* Charge unit measurement in uAh for a 1 milli-ohm sense resistor */
+#define DS2781_CHARGE_UNITS		6250
+/* Number of bytes in user EEPROM space */
+#define DS2781_USER_EEPROM_SIZE		(DS2781_EEPROM_BLOCK0_END - \
+					DS2781_EEPROM_BLOCK0_START + 1)
+/* Number of bytes in parameter EEPROM space */
+#define DS2781_PARAM_EEPROM_SIZE	(DS2781_EEPROM_BLOCK1_END - \
+					DS2781_EEPROM_BLOCK1_START + 1)
+
+struct ds2781_device_info {
+	struct device *dev;
+	struct power_supply bat;
+	struct device *w1_dev;
+	struct task_struct *mutex_holder;
+};
+
+enum current_types {
+	CURRENT_NOW,
+	CURRENT_AVG,
+};
+
+static const char model[] = "DS2781";
+static const char manufacturer[] = "Maxim/Dallas";
+
+static inline struct ds2781_device_info *
+to_ds2781_device_info(struct power_supply *psy)
+{
+	return container_of(psy, struct ds2781_device_info, bat);
+}
+
+static inline struct power_supply *to_power_supply(struct device *dev)
+{
+	return dev_get_drvdata(dev);
+}
+
+static inline int ds2781_battery_io(struct ds2781_device_info *dev_info,
+	char *buf, int addr, size_t count, int io)
+{
+	if (dev_info->mutex_holder == current)
+		return w1_ds2781_io_nolock(dev_info->w1_dev, buf, addr,
+				count, io);
+	else
+		return w1_ds2781_io(dev_info->w1_dev, buf, addr, count, io);
+}
+
+int w1_ds2781_read(struct ds2781_device_info *dev_info, char *buf,
+		int addr, size_t count)
+{
+	return ds2781_battery_io(dev_info, buf, addr, count, 0);
+}
+
+static inline int ds2781_read8(struct ds2781_device_info *dev_info, u8 *val,
+	int addr)
+{
+	return ds2781_battery_io(dev_info, val, addr, sizeof(u8), 0);
+}
+
+static int ds2781_read16(struct ds2781_device_info *dev_info, s16 *val,
+	int addr)
+{
+	int ret;
+	u8 raw[2];
+
+	ret = ds2781_battery_io(dev_info, raw, addr, sizeof(raw), 0);
+	if (ret < 0)
+		return ret;
+
+	*val = (raw[0] << 8) | raw[1];
+
+	return 0;
+}
+
+static inline int ds2781_read_block(struct ds2781_device_info *dev_info,
+	u8 *val, int addr, size_t count)
+{
+	return ds2781_battery_io(dev_info, val, addr, count, 0);
+}
+
+static inline int ds2781_write(struct ds2781_device_info *dev_info, u8 *val,
+	int addr, size_t count)
+{
+	return ds2781_battery_io(dev_info, val, addr, count, 1);
+}
+
+static inline int ds2781_store_eeprom(struct device *dev, int addr)
+{
+	return w1_ds2781_eeprom_cmd(dev, addr, W1_DS2781_COPY_DATA);
+}
+
+static inline int ds2781_recall_eeprom(struct device *dev, int addr)
+{
+	return w1_ds2781_eeprom_cmd(dev, addr, W1_DS2781_RECALL_DATA);
+}
+
+static int ds2781_save_eeprom(struct ds2781_device_info *dev_info, int reg)
+{
+	int ret;
+
+	ret = ds2781_store_eeprom(dev_info->w1_dev, reg);
+	if (ret < 0)
+		return ret;
+
+	ret = ds2781_recall_eeprom(dev_info->w1_dev, reg);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/* Set sense resistor value in mhos */
+static int ds2781_set_sense_register(struct ds2781_device_info *dev_info,
+	u8 conductance)
+{
+	int ret;
+
+	ret = ds2781_write(dev_info, &conductance,
+				DS2781_RSNSP, sizeof(u8));
+	if (ret < 0)
+		return ret;
+
+	return ds2781_save_eeprom(dev_info, DS2781_RSNSP);
+}
+
+/* Get RSGAIN value from 0 to 1.999 in steps of 0.001 */
+static int ds2781_get_rsgain_register(struct ds2781_device_info *dev_info,
+	u16 *rsgain)
+{
+	return ds2781_read16(dev_info, rsgain, DS2781_RSGAIN_MSB);
+}
+
+/* Set RSGAIN value from 0 to 1.999 in steps of 0.001 */
+static int ds2781_set_rsgain_register(struct ds2781_device_info *dev_info,
+	u16 rsgain)
+{
+	int ret;
+	u8 raw[] = {rsgain >> 8, rsgain & 0xFF};
+
+	ret = ds2781_write(dev_info, raw,
+				DS2781_RSGAIN_MSB, sizeof(raw));
+	if (ret < 0)
+		return ret;
+
+	return ds2781_save_eeprom(dev_info, DS2781_RSGAIN_MSB);
+}
+
+static int ds2781_get_voltage(struct ds2781_device_info *dev_info,
+	int *voltage_uV)
+{
+	int ret;
+	char val[2];
+	int voltage_raw;
+
+	ret = w1_ds2781_read(dev_info, val, DS2781_VOLT_MSB, 2 * sizeof(u8));
+	if (ret < 0)
+		return ret;
+	/*
+	 * The voltage value is located in 10 bits across the voltage MSB
+	 * and LSB registers in two's compliment form
+	 * Sign bit of the voltage value is in bit 7 of the voltage MSB register
+	 * Bits 9 - 3 of the voltage value are in bits 6 - 0 of the
+	 * voltage MSB register
+	 * Bits 2 - 0 of the voltage value are in bits 7 - 5 of the
+	 * voltage LSB register
+	 */
+	voltage_raw = (val[0] << 3) |
+		(val[1] >> 5);
+
+	/* DS2781 reports voltage in units of 9.76mV, but the battery class
+	 * reports in units of uV, so convert by multiplying by 9760. */
+	*voltage_uV = voltage_raw * 9760;
+
+	return 0;
+}
+
+static int ds2781_get_temperature(struct ds2781_device_info *dev_info,
+	int *temp)
+{
+	int ret;
+	char val[2];
+	int temp_raw;
+
+	ret = w1_ds2781_read(dev_info, val, DS2781_TEMP_MSB, 2 * sizeof(u8));
+	if (ret < 0)
+		return ret;
+	/*
+	 * The temperature value is located in 10 bits across the temperature
+	 * MSB and LSB registers in two's compliment form
+	 * Sign bit of the temperature value is in bit 7 of the temperature
+	 * MSB register
+	 * Bits 9 - 3 of the temperature value are in bits 6 - 0 of the
+	 * temperature MSB register
+	 * Bits 2 - 0 of the temperature value are in bits 7 - 5 of the
+	 * temperature LSB register
+	 */
+	temp_raw = ((val[0]) << 3) |
+		(val[1] >> 5);
+	*temp = temp_raw + (temp_raw / 4);
+
+	return 0;
+}
+
+static int ds2781_get_current(struct ds2781_device_info *dev_info,
+	enum current_types type, int *current_uA)
+{
+	int ret, sense_res;
+	s16 current_raw;
+	u8 sense_res_raw, reg_msb;
+
+	/*
+	 * The units of measurement for current are dependent on the value of
+	 * the sense resistor.
+	 */
+	ret = ds2781_read8(dev_info, &sense_res_raw, DS2781_RSNSP);
+	if (ret < 0)
+		return ret;
+
+	if (sense_res_raw == 0) {
+		dev_err(dev_info->dev, "sense resistor value is 0\n");
+		return -EINVAL;
+	}
+	sense_res = 1000 / sense_res_raw;
+
+	if (type == CURRENT_NOW)
+		reg_msb = DS2781_CURRENT_MSB;
+	else if (type == CURRENT_AVG)
+		reg_msb = DS2781_IAVG_MSB;
+	else
+		return -EINVAL;
+
+	/*
+	 * The current value is located in 16 bits across the current MSB
+	 * and LSB registers in two's compliment form
+	 * Sign bit of the current value is in bit 7 of the current MSB register
+	 * Bits 14 - 8 of the current value are in bits 6 - 0 of the current
+	 * MSB register
+	 * Bits 7 - 0 of the current value are in bits 7 - 0 of the current
+	 * LSB register
+	 */
+	ret = ds2781_read16(dev_info, &current_raw, reg_msb);
+	if (ret < 0)
+		return ret;
+
+	*current_uA = current_raw * (DS2781_CURRENT_UNITS / sense_res);
+	return 0;
+}
+
+static int ds2781_get_accumulated_current(struct ds2781_device_info *dev_info,
+	int *accumulated_current)
+{
+	int ret, sense_res;
+	s16 current_raw;
+	u8 sense_res_raw;
+
+	/*
+	 * The units of measurement for accumulated current are dependent on
+	 * the value of the sense resistor.
+	 */
+	ret = ds2781_read8(dev_info, &sense_res_raw, DS2781_RSNSP);
+	if (ret < 0)
+		return ret;
+
+	if (sense_res_raw == 0) {
+		dev_err(dev_info->dev, "sense resistor value is 0\n");
+		return -EINVAL;
+	}
+	sense_res = 1000 / sense_res_raw;
+
+	/*
+	 * The ACR value is located in 16 bits across the ACR MSB and
+	 * LSB registers
+	 * Bits 15 - 8 of the ACR value are in bits 7 - 0 of the ACR
+	 * MSB register
+	 * Bits 7 - 0 of the ACR value are in bits 7 - 0 of the ACR
+	 * LSB register
+	 */
+	ret = ds2781_read16(dev_info, &current_raw, DS2781_ACR_MSB);
+	if (ret < 0)
+		return ret;
+
+	*accumulated_current = current_raw * (DS2781_CHARGE_UNITS / sense_res);
+	return 0;
+}
+
+static int ds2781_get_capacity(struct ds2781_device_info *dev_info,
+	int *capacity)
+{
+	int ret;
+	u8 raw;
+
+	ret = ds2781_read8(dev_info, &raw, DS2781_RARC);
+	if (ret < 0)
+		return ret;
+
+	*capacity = raw;
+	return 0;
+}
+
+static int ds2781_get_status(struct ds2781_device_info *dev_info, int *status)
+{
+	int ret, current_uA, capacity;
+
+	ret = ds2781_get_current(dev_info, CURRENT_NOW, &current_uA);
+	if (ret < 0)
+		return ret;
+
+	ret = ds2781_get_capacity(dev_info, &capacity);
+	if (ret < 0)
+		return ret;
+
+	if (power_supply_am_i_supplied(&dev_info->bat)) {
+		if (capacity == 100)
+			*status = POWER_SUPPLY_STATUS_FULL;
+		else if (current_uA > 50000)
+			*status = POWER_SUPPLY_STATUS_CHARGING;
+		else
+			*status = POWER_SUPPLY_STATUS_NOT_CHARGING;
+	} else {
+		*status = POWER_SUPPLY_STATUS_DISCHARGING;
+	}
+	return 0;
+}
+
+static int ds2781_get_charge_now(struct ds2781_device_info *dev_info,
+	int *charge_now)
+{
+	int ret;
+	u16 charge_raw;
+
+	/*
+	 * The RAAC value is located in 16 bits across the RAAC MSB and
+	 * LSB registers
+	 * Bits 15 - 8 of the RAAC value are in bits 7 - 0 of the RAAC
+	 * MSB register
+	 * Bits 7 - 0 of the RAAC value are in bits 7 - 0 of the RAAC
+	 * LSB register
+	 */
+	ret = ds2781_read16(dev_info, &charge_raw, DS2781_RAAC_MSB);
+	if (ret < 0)
+		return ret;
+
+	*charge_now = charge_raw * 1600;
+	return 0;
+}
+
+static int ds2781_get_control_register(struct ds2781_device_info *dev_info,
+	u8 *control_reg)
+{
+	return ds2781_read8(dev_info, control_reg, DS2781_CONTROL);
+}
+
+static int ds2781_set_control_register(struct ds2781_device_info *dev_info,
+	u8 control_reg)
+{
+	int ret;
+
+	ret = ds2781_write(dev_info, &control_reg,
+				DS2781_CONTROL, sizeof(u8));
+	if (ret < 0)
+		return ret;
+
+	return ds2781_save_eeprom(dev_info, DS2781_CONTROL);
+}
+
+static int ds2781_battery_get_property(struct power_supply *psy,
+	enum power_supply_property psp,
+	union power_supply_propval *val)
+{
+	int ret = 0;
+	struct ds2781_device_info *dev_info = to_ds2781_device_info(psy);
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		ret = ds2781_get_voltage(dev_info, &val->intval);
+		break;
+
+	case POWER_SUPPLY_PROP_TEMP:
+		ret = ds2781_get_temperature(dev_info, &val->intval);
+		break;
+
+	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval = model;
+		break;
+
+	case POWER_SUPPLY_PROP_MANUFACTURER:
+		val->strval = manufacturer;
+		break;
+
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		ret = ds2781_get_current(dev_info, CURRENT_NOW, &val->intval);
+		break;
+
+	case POWER_SUPPLY_PROP_CURRENT_AVG:
+		ret = ds2781_get_current(dev_info, CURRENT_AVG, &val->intval);
+		break;
+
+	case POWER_SUPPLY_PROP_STATUS:
+		ret = ds2781_get_status(dev_info, &val->intval);
+		break;
+
+	case POWER_SUPPLY_PROP_CAPACITY:
+		ret = ds2781_get_capacity(dev_info, &val->intval);
+		break;
+
+	case POWER_SUPPLY_PROP_CHARGE_COUNTER:
+		ret = ds2781_get_accumulated_current(dev_info, &val->intval);
+		break;
+
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+		ret = ds2781_get_charge_now(dev_info, &val->intval);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static enum power_supply_property ds2781_battery_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_MODEL_NAME,
+	POWER_SUPPLY_PROP_MANUFACTURER,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_CURRENT_AVG,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_CHARGE_COUNTER,
+	POWER_SUPPLY_PROP_CHARGE_NOW,
+};
+
+static ssize_t ds2781_get_pmod_enabled(struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	int ret;
+	u8 control_reg;
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2781_device_info *dev_info = to_ds2781_device_info(psy);
+
+	/* Get power mode */
+	ret = ds2781_get_control_register(dev_info, &control_reg);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%d\n",
+		 !!(control_reg & DS2781_CONTROL_PMOD));
+}
+
+static ssize_t ds2781_set_pmod_enabled(struct device *dev,
+	struct device_attribute *attr,
+	const char *buf,
+	size_t count)
+{
+	int ret;
+	u8 control_reg, new_setting;
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2781_device_info *dev_info = to_ds2781_device_info(psy);
+
+	/* Set power mode */
+	ret = ds2781_get_control_register(dev_info, &control_reg);
+	if (ret < 0)
+		return ret;
+
+	ret = kstrtou8(buf, 0, &new_setting);
+	if (ret < 0)
+		return ret;
+
+	if ((new_setting != 0) && (new_setting != 1)) {
+		dev_err(dev_info->dev, "Invalid pmod setting (0 or 1)\n");
+		return -EINVAL;
+	}
+
+	if (new_setting)
+		control_reg |= DS2781_CONTROL_PMOD;
+	else
+		control_reg &= ~DS2781_CONTROL_PMOD;
+
+	ret = ds2781_set_control_register(dev_info, control_reg);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static ssize_t ds2781_get_sense_resistor_value(struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	int ret;
+	u8 sense_resistor;
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2781_device_info *dev_info = to_ds2781_device_info(psy);
+
+	ret = ds2781_read8(dev_info, &sense_resistor, DS2781_RSNSP);
+	if (ret < 0)
+		return ret;
+
+	ret = sprintf(buf, "%d\n", sense_resistor);
+	return ret;
+}
+
+static ssize_t ds2781_set_sense_resistor_value(struct device *dev,
+	struct device_attribute *attr,
+	const char *buf,
+	size_t count)
+{
+	int ret;
+	u8 new_setting;
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2781_device_info *dev_info = to_ds2781_device_info(psy);
+
+	ret = kstrtou8(buf, 0, &new_setting);
+	if (ret < 0)
+		return ret;
+
+	ret = ds2781_set_sense_register(dev_info, new_setting);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static ssize_t ds2781_get_rsgain_setting(struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	int ret;
+	u16 rsgain;
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2781_device_info *dev_info = to_ds2781_device_info(psy);
+
+	ret = ds2781_get_rsgain_register(dev_info, &rsgain);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%d\n", rsgain);
+}
+
+static ssize_t ds2781_set_rsgain_setting(struct device *dev,
+	struct device_attribute *attr,
+	const char *buf,
+	size_t count)
+{
+	int ret;
+	u16 new_setting;
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2781_device_info *dev_info = to_ds2781_device_info(psy);
+
+	ret = kstrtou16(buf, 0, &new_setting);
+	if (ret < 0)
+		return ret;
+
+	/* Gain can only be from 0 to 1.999 in steps of .001 */
+	if (new_setting > 1999) {
+		dev_err(dev_info->dev, "Invalid rsgain setting (0 - 1999)\n");
+		return -EINVAL;
+	}
+
+	ret = ds2781_set_rsgain_register(dev_info, new_setting);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static ssize_t ds2781_get_pio_pin(struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	int ret;
+	u8 sfr;
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2781_device_info *dev_info = to_ds2781_device_info(psy);
+
+	ret = ds2781_read8(dev_info, &sfr, DS2781_SFR);
+	if (ret < 0)
+		return ret;
+
+	ret = sprintf(buf, "%d\n", sfr & DS2781_SFR_PIOSC);
+	return ret;
+}
+
+static ssize_t ds2781_set_pio_pin(struct device *dev,
+	struct device_attribute *attr,
+	const char *buf,
+	size_t count)
+{
+	int ret;
+	u8 new_setting;
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2781_device_info *dev_info = to_ds2781_device_info(psy);
+
+	ret = kstrtou8(buf, 0, &new_setting);
+	if (ret < 0)
+		return ret;
+
+	if ((new_setting != 0) && (new_setting != 1)) {
+		dev_err(dev_info->dev, "Invalid pio_pin setting (0 or 1)\n");
+		return -EINVAL;
+	}
+
+	ret = ds2781_write(dev_info, &new_setting,
+				DS2781_SFR, sizeof(u8));
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static ssize_t ds2781_read_param_eeprom_bin(struct file *filp,
+				struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2781_device_info *dev_info = to_ds2781_device_info(psy);
+
+	count = min_t(loff_t, count,
+		DS2781_EEPROM_BLOCK1_END -
+		DS2781_EEPROM_BLOCK1_START + 1 - off);
+
+	return ds2781_read_block(dev_info, buf,
+				DS2781_EEPROM_BLOCK1_START + off, count);
+}
+
+static ssize_t ds2781_write_param_eeprom_bin(struct file *filp,
+				struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2781_device_info *dev_info = to_ds2781_device_info(psy);
+	int ret;
+
+	count = min_t(loff_t, count,
+		DS2781_EEPROM_BLOCK1_END -
+		DS2781_EEPROM_BLOCK1_START + 1 - off);
+
+	ret = ds2781_write(dev_info, buf,
+				DS2781_EEPROM_BLOCK1_START + off, count);
+	if (ret < 0)
+		return ret;
+
+	ret = ds2781_save_eeprom(dev_info, DS2781_EEPROM_BLOCK1_START);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static struct bin_attribute ds2781_param_eeprom_bin_attr = {
+	.attr = {
+		.name = "param_eeprom",
+		.mode = S_IRUGO | S_IWUSR,
+	},
+	.size = DS2781_EEPROM_BLOCK1_END - DS2781_EEPROM_BLOCK1_START + 1,
+	.read = ds2781_read_param_eeprom_bin,
+	.write = ds2781_write_param_eeprom_bin,
+};
+
+static ssize_t ds2781_read_user_eeprom_bin(struct file *filp,
+				struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2781_device_info *dev_info = to_ds2781_device_info(psy);
+
+	count = min_t(loff_t, count,
+		DS2781_EEPROM_BLOCK0_END -
+		DS2781_EEPROM_BLOCK0_START + 1 - off);
+
+	return ds2781_read_block(dev_info, buf,
+				DS2781_EEPROM_BLOCK0_START + off, count);
+
+}
+
+static ssize_t ds2781_write_user_eeprom_bin(struct file *filp,
+				struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2781_device_info *dev_info = to_ds2781_device_info(psy);
+	int ret;
+
+	count = min_t(loff_t, count,
+		DS2781_EEPROM_BLOCK0_END -
+		DS2781_EEPROM_BLOCK0_START + 1 - off);
+
+	ret = ds2781_write(dev_info, buf,
+				DS2781_EEPROM_BLOCK0_START + off, count);
+	if (ret < 0)
+		return ret;
+
+	ret = ds2781_save_eeprom(dev_info, DS2781_EEPROM_BLOCK0_START);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static struct bin_attribute ds2781_user_eeprom_bin_attr = {
+	.attr = {
+		.name = "user_eeprom",
+		.mode = S_IRUGO | S_IWUSR,
+	},
+	.size = DS2781_EEPROM_BLOCK0_END - DS2781_EEPROM_BLOCK0_START + 1,
+	.read = ds2781_read_user_eeprom_bin,
+	.write = ds2781_write_user_eeprom_bin,
+};
+
+static DEVICE_ATTR(pmod_enabled, S_IRUGO | S_IWUSR, ds2781_get_pmod_enabled,
+	ds2781_set_pmod_enabled);
+static DEVICE_ATTR(sense_resistor_value, S_IRUGO | S_IWUSR,
+	ds2781_get_sense_resistor_value, ds2781_set_sense_resistor_value);
+static DEVICE_ATTR(rsgain_setting, S_IRUGO | S_IWUSR, ds2781_get_rsgain_setting,
+	ds2781_set_rsgain_setting);
+static DEVICE_ATTR(pio_pin, S_IRUGO | S_IWUSR, ds2781_get_pio_pin,
+	ds2781_set_pio_pin);
+
+
+static struct attribute *ds2781_attributes[] = {
+	&dev_attr_pmod_enabled.attr,
+	&dev_attr_sense_resistor_value.attr,
+	&dev_attr_rsgain_setting.attr,
+	&dev_attr_pio_pin.attr,
+	NULL
+};
+
+static const struct attribute_group ds2781_attr_group = {
+	.attrs = ds2781_attributes,
+};
+
+static int __devinit ds2781_battery_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct ds2781_device_info *dev_info;
+
+	dev_info = kzalloc(sizeof(*dev_info), GFP_KERNEL);
+	if (!dev_info) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	platform_set_drvdata(pdev, dev_info);
+
+	dev_info->dev			= &pdev->dev;
+	dev_info->w1_dev		= pdev->dev.parent;
+	dev_info->bat.name		= dev_name(&pdev->dev);
+	dev_info->bat.type		= POWER_SUPPLY_TYPE_BATTERY;
+	dev_info->bat.properties	= ds2781_battery_props;
+	dev_info->bat.num_properties	= ARRAY_SIZE(ds2781_battery_props);
+	dev_info->bat.get_property	= ds2781_battery_get_property;
+	dev_info->mutex_holder		= current;
+
+	ret = power_supply_register(&pdev->dev, &dev_info->bat);
+	if (ret) {
+		dev_err(dev_info->dev, "failed to register battery\n");
+		goto fail_free_info;
+	}
+
+	ret = sysfs_create_group(&dev_info->bat.dev->kobj, &ds2781_attr_group);
+	if (ret) {
+		dev_err(dev_info->dev, "failed to create sysfs group\n");
+		goto fail_unregister;
+	}
+
+	ret = sysfs_create_bin_file(&dev_info->bat.dev->kobj,
+					&ds2781_param_eeprom_bin_attr);
+	if (ret) {
+		dev_err(dev_info->dev,
+				"failed to create param eeprom bin file");
+		goto fail_remove_group;
+	}
+
+	ret = sysfs_create_bin_file(&dev_info->bat.dev->kobj,
+					&ds2781_user_eeprom_bin_attr);
+	if (ret) {
+		dev_err(dev_info->dev,
+				"failed to create user eeprom bin file");
+		goto fail_remove_bin_file;
+	}
+
+	dev_info->mutex_holder = NULL;
+
+	return 0;
+
+fail_remove_bin_file:
+	sysfs_remove_bin_file(&dev_info->bat.dev->kobj,
+				&ds2781_param_eeprom_bin_attr);
+fail_remove_group:
+	sysfs_remove_group(&dev_info->bat.dev->kobj, &ds2781_attr_group);
+fail_unregister:
+	power_supply_unregister(&dev_info->bat);
+fail_free_info:
+	kfree(dev_info);
+fail:
+	return ret;
+}
+
+static int __devexit ds2781_battery_remove(struct platform_device *pdev)
+{
+	struct ds2781_device_info *dev_info = platform_get_drvdata(pdev);
+
+	dev_info->mutex_holder = current;
+
+	/* remove attributes */
+	sysfs_remove_group(&dev_info->bat.dev->kobj, &ds2781_attr_group);
+
+	power_supply_unregister(&dev_info->bat);
+
+	kfree(dev_info);
+	return 0;
+}
+
+static struct platform_driver ds2781_battery_driver = {
+	.driver = {
+		.name = "ds2781-battery",
+	},
+	.probe	  = ds2781_battery_probe,
+	.remove   = __devexit_p(ds2781_battery_remove),
+};
+
+static int __init ds2781_battery_init(void)
+{
+	return platform_driver_register(&ds2781_battery_driver);
+}
+
+static void __exit ds2781_battery_exit(void)
+{
+	platform_driver_unregister(&ds2781_battery_driver);
+}
+
+module_init(ds2781_battery_init);
+module_exit(ds2781_battery_exit);
+
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Renata Sayakhova <renata@oktetlabs.ru>");
+MODULE_DESCRIPTION("Maxim/Dallas DS2781 Stand-Alone Fuel Gauage IC driver");
+MODULE_ALIAS("platform:ds2781-battery");
+
diff --git a/drivers/w1/slaves/Kconfig b/drivers/w1/slaves/Kconfig
index d0cb01b..eb9e376 100644
--- a/drivers/w1/slaves/Kconfig
+++ b/drivers/w1/slaves/Kconfig
@@ -81,6 +81,19 @@ config W1_SLAVE_DS2780
 
 	  If you are unsure, say N.
 
+config W1_SLAVE_DS2781
+	tristate "Dallas 2781 battery monitor chip"
+	depends on W1
+	help
+	  If you enable this you will have the DS2781 battery monitor
+	  chip support.
+
+	  The battery monitor chip is used in many batteries/devices
+	  as the one who is responsible for charging/discharging/monitoring
+	  Li+ batteries.
+
+	  If you are unsure, say N.
+
 config W1_SLAVE_BQ27000
 	tristate "BQ27000 slave support"
 	depends on W1
diff --git a/drivers/w1/slaves/Makefile b/drivers/w1/slaves/Makefile
index 1f31e9f..c4f1859 100644
--- a/drivers/w1/slaves/Makefile
+++ b/drivers/w1/slaves/Makefile
@@ -10,4 +10,5 @@ obj-$(CONFIG_W1_SLAVE_DS2431)	+= w1_ds2431.o
 obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
 obj-$(CONFIG_W1_SLAVE_DS2760)	+= w1_ds2760.o
 obj-$(CONFIG_W1_SLAVE_DS2780)	+= w1_ds2780.o
+obj-$(CONFIG_W1_SLAVE_DS2781)	+= w1_ds2781.o
 obj-$(CONFIG_W1_SLAVE_BQ27000)	+= w1_bq27000.o
diff --git a/drivers/w1/slaves/w1_ds2781.c b/drivers/w1/slaves/w1_ds2781.c
new file mode 100644
index 0000000..0d0c798
--- /dev/null
+++ b/drivers/w1/slaves/w1_ds2781.c
@@ -0,0 +1,201 @@
+/*
+ * 1-Wire implementation for the ds2781 chip
+ *
+ * Author: Renata Sayakhova <renata@oktetlabs.ru>
+ *
+ * Based on w1-ds2780 driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/idr.h>
+
+#include "../w1.h"
+#include "../w1_int.h"
+#include "../w1_family.h"
+#include "w1_ds2781.h"
+
+static int w1_ds2781_do_io(struct device *dev, char *buf, int addr,
+			size_t count, int io)
+{
+	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
+
+	if (addr > DS2781_DATA_SIZE || addr < 0)
+		return 0;
+
+	count = min_t(int, count, DS2781_DATA_SIZE - addr);
+
+	if (w1_reset_select_slave(sl) == 0) {
+		if (io) {
+			w1_write_8(sl->master, W1_DS2781_WRITE_DATA);
+			w1_write_8(sl->master, addr);
+			w1_write_block(sl->master, buf, count);
+		} else {
+			w1_write_8(sl->master, W1_DS2781_READ_DATA);
+			w1_write_8(sl->master, addr);
+			count = w1_read_block(sl->master, buf, count);
+		}
+	}
+
+	return count;
+}
+
+int w1_ds2781_io(struct device *dev, char *buf, int addr, size_t count,
+			int io)
+{
+	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
+	int ret;
+
+	if (!dev)
+		return -ENODEV;
+
+	mutex_lock(&sl->master->mutex);
+
+	ret = w1_ds2781_do_io(dev, buf, addr, count, io);
+
+	mutex_unlock(&sl->master->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(w1_ds2781_io);
+
+int w1_ds2781_io_nolock(struct device *dev, char *buf, int addr, size_t count,
+			int io)
+{
+	int ret;
+
+	if (!dev)
+		return -ENODEV;
+
+	ret = w1_ds2781_do_io(dev, buf, addr, count, io);
+
+	return ret;
+}
+EXPORT_SYMBOL(w1_ds2781_io_nolock);
+
+int w1_ds2781_eeprom_cmd(struct device *dev, int addr, int cmd)
+{
+	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
+
+	if (!dev)
+		return -EINVAL;
+
+	mutex_lock(&sl->master->mutex);
+
+	if (w1_reset_select_slave(sl) == 0) {
+		w1_write_8(sl->master, cmd);
+		w1_write_8(sl->master, addr);
+	}
+
+	mutex_unlock(&sl->master->mutex);
+	return 0;
+}
+EXPORT_SYMBOL(w1_ds2781_eeprom_cmd);
+
+static ssize_t w1_ds2781_read_bin(struct file *filp,
+				  struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
+				  char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	return w1_ds2781_io(dev, buf, off, count, 0);
+}
+
+static struct bin_attribute w1_ds2781_bin_attr = {
+	.attr = {
+		.name = "w1_slave",
+		.mode = S_IRUGO,
+	},
+	.size = DS2781_DATA_SIZE,
+	.read = w1_ds2781_read_bin,
+};
+
+static DEFINE_IDA(bat_ida);
+
+static int w1_ds2781_add_slave(struct w1_slave *sl)
+{
+	int ret;
+	int id;
+	struct platform_device *pdev;
+
+	id = ida_simple_get(&bat_ida, 0, 0, GFP_KERNEL);
+	if (id < 0) {
+		ret = id;
+		goto noid;
+	}
+
+	pdev = platform_device_alloc("ds2781-battery", id);
+	if (!pdev) {
+		ret = -ENOMEM;
+		goto pdev_alloc_failed;
+	}
+	pdev->dev.parent = &sl->dev;
+
+	ret = platform_device_add(pdev);
+	if (ret)
+		goto pdev_add_failed;
+
+	ret = sysfs_create_bin_file(&sl->dev.kobj, &w1_ds2781_bin_attr);
+	if (ret)
+		goto bin_attr_failed;
+
+	dev_set_drvdata(&sl->dev, pdev);
+
+	return 0;
+
+bin_attr_failed:
+pdev_add_failed:
+	platform_device_unregister(pdev);
+pdev_alloc_failed:
+	ida_simple_remove(&bat_ida, id);
+noid:
+	return ret;
+}
+
+static void w1_ds2781_remove_slave(struct w1_slave *sl)
+{
+	struct platform_device *pdev = dev_get_drvdata(&sl->dev);
+	int id = pdev->id;
+
+	platform_device_unregister(pdev);
+	ida_simple_remove(&bat_ida, id);
+	sysfs_remove_bin_file(&sl->dev.kobj, &w1_ds2781_bin_attr);
+}
+
+static struct w1_family_ops w1_ds2781_fops = {
+	.add_slave    = w1_ds2781_add_slave,
+	.remove_slave = w1_ds2781_remove_slave,
+};
+
+static struct w1_family w1_ds2781_family = {
+	.fid = W1_FAMILY_DS2781,
+	.fops = &w1_ds2781_fops,
+};
+
+static int __init w1_ds2781_init(void)
+{
+	ida_init(&bat_ida);
+	return w1_register_family(&w1_ds2781_family);
+}
+
+static void __exit w1_ds2781_exit(void)
+{
+	w1_unregister_family(&w1_ds2781_family);
+	ida_destroy(&bat_ida);
+}
+
+module_init(w1_ds2781_init);
+module_exit(w1_ds2781_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Renata Sayakhova <renata@oktetlabs.ru>");
+MODULE_DESCRIPTION("1-wire Driver for Maxim/Dallas DS2781 Stand-Alone Fuel Gauge IC");
diff --git a/drivers/w1/slaves/w1_ds2781.h b/drivers/w1/slaves/w1_ds2781.h
new file mode 100644
index 0000000..82bc664
--- /dev/null
+++ b/drivers/w1/slaves/w1_ds2781.h
@@ -0,0 +1,136 @@
+/*
+ * 1-Wire implementation for the ds2780 chip
+ *
+ * Author: Renata Sayakhova <renata@oktetlabs.ru>
+ *
+ * Based on w1-ds2760 driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef _W1_DS2781_H
+#define _W1_DS2781_H
+
+/* Function commands */
+#define W1_DS2781_READ_DATA		0x69
+#define W1_DS2781_WRITE_DATA		0x6C
+#define W1_DS2781_COPY_DATA		0x48
+#define W1_DS2781_RECALL_DATA		0xB8
+#define W1_DS2781_LOCK			0x6A
+
+/* Register map */
+/* Register 0x00 Reserved */
+#define DS2781_STATUS			0x01
+#define DS2781_RAAC_MSB			0x02
+#define DS2781_RAAC_LSB			0x03
+#define DS2781_RSAC_MSB			0x04
+#define DS2781_RSAC_LSB			0x05
+#define DS2781_RARC			0x06
+#define DS2781_RSRC			0x07
+#define DS2781_IAVG_MSB			0x08
+#define DS2781_IAVG_LSB			0x09
+#define DS2781_TEMP_MSB			0x0A
+#define DS2781_TEMP_LSB			0x0B
+#define DS2781_VOLT_MSB			0x0C
+#define DS2781_VOLT_LSB			0x0D
+#define DS2781_CURRENT_MSB		0x0E
+#define DS2781_CURRENT_LSB		0x0F
+#define DS2781_ACR_MSB			0x10
+#define DS2781_ACR_LSB			0x11
+#define DS2781_ACRL_MSB			0x12
+#define DS2781_ACRL_LSB			0x13
+#define DS2781_AS			0x14
+#define DS2781_SFR			0x15
+#define DS2781_FULL_MSB			0x16
+#define DS2781_FULL_LSB			0x17
+#define DS2781_AE_MSB			0x18
+#define DS2781_AE_LSB			0x19
+#define DS2781_SE_MSB			0x1A
+#define DS2781_SE_LSB			0x1B
+/* Register 0x1C - 0x1E Reserved */
+#define DS2781_EEPROM		0x1F
+#define DS2781_EEPROM_BLOCK0_START	0x20
+/* Register 0x20 - 0x2F User EEPROM */
+#define DS2781_EEPROM_BLOCK0_END	0x2F
+/* Register 0x30 - 0x5F Reserved */
+#define DS2781_EEPROM_BLOCK1_START	0x60
+#define DS2781_CONTROL			0x60
+#define DS2781_AB			0x61
+#define DS2781_AC_MSB			0x62
+#define DS2781_AC_LSB			0x63
+#define DS2781_VCHG			0x64
+#define DS2781_IMIN			0x65
+#define DS2781_VAE			0x66
+#define DS2781_IAE			0x67
+#define DS2781_AE_40			0x68
+#define DS2781_RSNSP			0x69
+#define DS2781_FULL_40_MSB		0x6A
+#define DS2781_FULL_40_LSB		0x6B
+#define DS2781_FULL_4_SLOPE		0x6C
+#define DS2781_FULL_3_SLOPE		0x6D
+#define DS2781_FULL_2_SLOPE		0x6E
+#define DS2781_FULL_1_SLOPE		0x6F
+#define DS2781_AE_4_SLOPE		0x70
+#define DS2781_AE_3_SLOPE		0x71
+#define DS2781_AE_2_SLOPE		0x72
+#define DS2781_AE_1_SLOPE		0x73
+#define DS2781_SE_4_SLOPE		0x74
+#define DS2781_SE_3_SLOPE		0x75
+#define DS2781_SE_2_SLOPE		0x76
+#define DS2781_SE_1_SLOPE		0x77
+#define DS2781_RSGAIN_MSB		0x78
+#define DS2781_RSGAIN_LSB		0x79
+#define DS2781_RSTC			0x7A
+#define DS2781_COB			0x7B
+#define DS2781_TBP34			0x7C
+#define DS2781_TBP23			0x7D
+#define DS2781_TBP12			0x7E
+#define DS2781_EEPROM_BLOCK1_END	0x7F
+/* Register 0x7D - 0xFF Reserved */
+
+#define DS2781_FSGAIN_MSB		0xB0
+#define DS2781_FSGAIN_LSB		0xB1
+
+/* Number of valid register addresses */
+#define DS2781_DATA_SIZE		0xB2
+
+/* Status register bits */
+#define DS2781_STATUS_CHGTF		(1 << 7)
+#define DS2781_STATUS_AEF		(1 << 6)
+#define DS2781_STATUS_SEF		(1 << 5)
+#define DS2781_STATUS_LEARNF		(1 << 4)
+/* Bit 3 Reserved */
+#define DS2781_STATUS_UVF		(1 << 2)
+#define DS2781_STATUS_PORF		(1 << 1)
+/* Bit 0 Reserved */
+
+/* Control register bits */
+/* Bit 7 Reserved */
+#define DS2781_CONTROL_NBEN		(1 << 7)
+#define DS2781_CONTROL_UVEN		(1 << 6)
+#define DS2781_CONTROL_PMOD		(1 << 5)
+#define DS2781_CONTROL_RNAOP		(1 << 4)
+#define DS1781_CONTROL_UVTH		(1 << 3)
+/* Bit 0 - 2 Reserved */
+
+/* Special feature register bits */
+/* Bit 1 - 7 Reserved */
+#define DS2781_SFR_PIOSC		(1 << 0)
+
+/* EEPROM register bits */
+#define DS2781_EEPROM_EEC		(1 << 7)
+#define DS2781_EEPROM_LOCK		(1 << 6)
+/* Bit 2 - 6 Reserved */
+#define DS2781_EEPROM_BL1		(1 << 1)
+#define DS2781_EEPROM_BL0		(1 << 0)
+
+extern int w1_ds2781_io(struct device *dev, char *buf, int addr, size_t count,
+			int io);
+extern int w1_ds2781_io_nolock(struct device *dev, char *buf, int addr,
+			size_t count, int io);
+extern int w1_ds2781_eeprom_cmd(struct device *dev, int addr, int cmd);
+
+#endif /* !_W1_DS2781_H */
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index 490cda2..874aeb0 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -38,6 +38,7 @@
 #define W1_EEPROM_DS2431	0x2D
 #define W1_FAMILY_DS2760	0x30
 #define W1_FAMILY_DS2780	0x32
+#define W1_FAMILY_DS2781	0x3D
 #define W1_THERM_DS28EA00	0x42
 
 #define MAXNAMELEN		32
-- 
1.7.6.3

