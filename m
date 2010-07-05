Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab0GEENG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 00:13:06 -0400
Received: from imr3.ericy.com ([198.24.6.13]:45024 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab0GEEMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 00:12:50 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Hans de Goede <hdegoede@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>, Crane Cai <crane.cai@amd.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Ralf Baechle <ralf@linux-mips.org>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-i2c@vger.kernel.org, Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH/RFC v2 1/4] hwmon: PMBus device driver
Date: Sun, 4 Jul 2010 21:10:15 -0700
Message-ID: <1278303018-22069-2-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <1278303018-22069-1-git-send-email-guenter.roeck@ericsson.com>
References: <1278303018-22069-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds support for hardware monitoring features of various PMBus
devices.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/hwmon/Kconfig  |   12 +
 drivers/hwmon/Makefile |    1 +
 drivers/hwmon/pmbus.c  | 1396 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/hwmon/pmbus.h  |  209 ++++++++
 4 files changed, 1618 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hwmon/pmbus.c
 create mode 100644 drivers/hwmon/pmbus.h

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index e19cf8e..8d53cf7 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -702,6 +702,18 @@ config SENSORS_PCF8591
 	  These devices are hard to detect and rarely found on mainstream
 	  hardware.  If unsure, say N.
 
+config SENSORS_PMBUS
+	tristate "PMBus devices"
+	depends on I2C && EXPERIMENTAL
+	default n
+	help
+	  If you say yes here you get hardware monitoring support for various
+	  PMBus devices, including but not limited to BMR45x, LTC2978, MAX16064,
+	  MAX8688, and UCD92xx.
+
+	  This driver can also be built as a module. If so, the module will
+	  be called pmbus.
+
 config SENSORS_SHT15
 	tristate "Sensiron humidity and temperature sensors. SHT15 and compat."
 	depends on GENERIC_GPIO
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 2138ceb..88b043e 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -83,6 +83,7 @@ obj-$(CONFIG_SENSORS_MC13783_ADC)+= mc13783-adc.o
 obj-$(CONFIG_SENSORS_PC87360)	+= pc87360.o
 obj-$(CONFIG_SENSORS_PC87427)	+= pc87427.o
 obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
+obj-$(CONFIG_SENSORS_PMBUS)	+= pmbus.o
 obj-$(CONFIG_SENSORS_S3C)	+= s3c-hwmon.o
 obj-$(CONFIG_SENSORS_SHT15)	+= sht15.o
 obj-$(CONFIG_SENSORS_SIS5595)	+= sis5595.o
diff --git a/drivers/hwmon/pmbus.c b/drivers/hwmon/pmbus.c
new file mode 100644
index 0000000..549d915
--- /dev/null
+++ b/drivers/hwmon/pmbus.c
@@ -0,0 +1,1396 @@
+/*
+ * Hardware monitoring driver for PMBus devices
+ *
+ * Copyright (C) 2010 Ericsson AB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/delay.h>
+#include "pmbus.h"
+
+/*
+ * Constants needed to determine number of sensors, booleans, and labels.
+ */
+#define PMBUS_MAX_INPUT_SENSORS		11	/* 6*volt, 3*curr, 2*power */
+#define PMBUS_VOUT_SENSORS_PER_PAGE	5	/* input, min, max, lcrit,
+						   crit */
+#define PMBUS_IOUT_SENSORS_PER_PAGE	4	/* input, min, max, crit */
+#define PMBUS_POUT_SENSORS_PER_PAGE	4	/* input, cap, max, crit */
+#define PMBUS_MAX_SENSORS_PER_TEMP	5	/* input, min, max, lcrit,
+						   crit */
+
+#define PMBUS_MAX_INPUT_BOOLEANS	7	/* v: min_alarm, max_alarm,
+						   lcrit_alarm, crit_alarm;
+						   c: alarm, crit_alarm;
+						   p: crit_alarm */
+#define PMBUS_VOUT_BOOLEANS_PER_PAGE	4	/* min_alarm, max_alarm,
+						   lcrit_alarm, crit_alarm */
+#define PMBUS_IOUT_BOOLEANS_PER_PAGE	3	/* alarm, lcrit_alarm,
+						   crit_alarm */
+#define PMBUS_POUT_BOOLEANS_PER_PAGE	2	/* alarm, crit_alarm */
+#define PMBUS_MAX_BOOLEANS_PER_TEMP	4	/* min_alarm, max_alarm,
+						   lcrit_alarm, crit_alarm */
+
+#define PMBUS_MAX_INPUT_LABELS		4	/* vin, vcap, iin, pin */
+
+#define PMBUS_PAGES			32	/* Per PMBus specification */
+
+enum chips { ltc2978, max16064, max8688, pmbus, ucd9220, ucd9240 };
+
+enum pmbus_sensor_classes {
+	PSC_VOLTAGE = 0,
+	PSC_TEMPERATURE,
+	PSC_CURRENT,
+	PSC_POWER,
+	PSC_NUM_CLASSES		/* Number of power sensor classes */
+};
+
+struct pmbus_config {
+	int pages;		/* Total number of pages (= output sensors) */
+	bool direct;		/* true if device uses direct data format */
+	/*
+	 * Support one set of coefficients for each sensor type
+	 * Used for chips providing data in direct mode.
+	 */
+	int m[PSC_NUM_CLASSES];	/* mantissa for direct data format */
+	int b[PSC_NUM_CLASSES];	/* offset */
+	int R[PSC_NUM_CLASSES];	/* exponent */
+};
+
+#define PB_HAVE_STATUS_VOUT	(1<<0)
+#define PB_HAVE_STATUS_IOUT	(1<<1)
+#define PB_HAVE_STATUS_INPUT	(1<<2)
+#define PB_HAVE_STATUS_TEMP	(1<<3)
+
+/*
+ * status, status_vout, status_iout are paged.
+ * status_input and status_temp are unpaged.
+ */
+#define PB_NUM_STATUS_REG	(PMBUS_PAGES * 3 + 2)
+
+/*
+ * Index into status register array, per status register group
+ */
+#define PB_STATUS_BASE		0
+#define PB_STATUS_VOUT_BASE	(PB_STATUS_BASE + PMBUS_PAGES)
+#define PB_STATUS_IOUT_BASE	(PB_STATUS_VOUT_BASE + PMBUS_PAGES)
+#define PB_STATUS_INPUT_BASE	(PB_STATUS_IOUT_BASE + PMBUS_PAGES)
+#define PB_STATUS_TEMP_BASE	(PB_STATUS_INPUT_BASE + 1)
+
+struct pmbus_sensor {
+	char name[I2C_NAME_SIZE];	/* sysfs sensor name */
+	struct sensor_device_attribute attribute;
+	u8 page;			/* page number */
+	u8 reg;				/* register */
+	enum pmbus_sensor_classes class;/* sensor class */
+	bool update;			/* runtime sensor update needed */
+	u16 data;			/* Sensor data */
+};
+
+struct pmbus_boolean {
+	char name[I2C_NAME_SIZE];	/* sysfs boolean name */
+	struct sensor_device_attribute attribute;
+};
+
+struct pmbus_label {
+	char name[I2C_NAME_SIZE];	/* sysfs label name */
+	struct sensor_device_attribute attribute;
+	char label[I2C_NAME_SIZE];	/* label */
+};
+
+struct pmbus_data {
+	struct device *hwmon_dev;
+	enum chips type;
+
+	bool direct;
+	int pages;
+
+	/* Coefficients, for chips providing data in direct mode  */
+	int m[PSC_NUM_CLASSES];	/* mantissa for direct data format */
+	int b[PSC_NUM_CLASSES];	/* offset */
+	int R[PSC_NUM_CLASSES];	/* exponent */
+
+	int max_attributes;
+	int num_attributes;
+	struct attribute **attributes;
+	struct attribute_group group;
+
+	/*
+	 * Sensors cover both sensor and limit registers.
+	 */
+	int max_sensors;
+	int num_sensors;
+	struct pmbus_sensor *sensors;
+	/*
+	 * Booleans are used for alarms.
+	 * Values are determined from status registers.
+	 */
+	int max_booleans;
+	int num_booleans;
+	struct pmbus_boolean *booleans;
+	/*
+	 * Labels are used to map generic names (e.g., "in1")
+	 * to PMBus specific names (e.g., "vin" or "vout1").
+	 */
+	int max_labels;
+	int num_labels;
+	struct pmbus_label *labels;
+
+	struct mutex update_lock;
+	bool valid;
+	unsigned long last_updated;	/* in jiffies */
+
+	/*
+	 * A single status register covers multiple attributes,
+	 * so we keep them all together.
+	 */
+	u8 status_bits;
+	u8 status[PB_NUM_STATUS_REG];
+
+	u8 currpage;
+};
+
+static const struct pmbus_config pmbus_config[] = {
+	[pmbus] = {
+		.pages = 1,
+		},
+	[ltc2978] = {
+		.pages = 8,
+		},
+	[max16064] = {
+		.pages = 4,
+		.direct = true,
+		.m[PSC_VOLTAGE] = 19995, /* Coefficients from datasheet */
+		.b[PSC_VOLTAGE] = 0,
+		.R[PSC_VOLTAGE] = -1,
+		.m[PSC_TEMPERATURE] = -7612,
+		.b[PSC_TEMPERATURE] = 335,
+		.R[PSC_TEMPERATURE] = -3,
+		},
+	[max8688] = {
+		.pages = 1,
+		.direct = true,
+		.m[PSC_VOLTAGE] = 19995, /* Coefficients from datasheet */
+		.b[PSC_VOLTAGE] = 0,
+		.R[PSC_VOLTAGE] = -1,
+		.m[PSC_TEMPERATURE] = -7612,
+		.b[PSC_TEMPERATURE] = 335,
+		.R[PSC_TEMPERATURE] = -3,
+		.m[PSC_CURRENT] = 23109,
+		.b[PSC_CURRENT] = 0,
+		.R[PSC_CURRENT] = -2,
+		},
+	[ucd9220] = {
+		.pages = 2,
+		},
+	[ucd9240] = {
+		.pages = 4,
+		},
+};
+
+static int pmbus_set_page(struct i2c_client *client, u8 page)
+{
+	struct pmbus_data *data = i2c_get_clientdata(client);
+	int rv = 0;
+
+	if (page != data->currpage) {
+		rv = i2c_smbus_write_byte_data(client, PMBUS_PAGE, page);
+		data->currpage = page;
+	}
+	return rv;
+}
+
+static int pmbus_write_byte(struct i2c_client *client, u8 page, u8 value)
+{
+	int rv;
+
+	rv = pmbus_set_page(client, page);
+	if (rv < 0)
+		return rv;
+
+	return i2c_smbus_write_byte(client, value);
+}
+
+static int pmbus_write_word_data(struct i2c_client *client, u8 page, u8 reg,
+				 u16 word)
+{
+	int rv;
+
+	rv = pmbus_set_page(client, page);
+	if (rv < 0)
+		return rv;
+
+	return i2c_smbus_write_word_data(client, reg, word);
+}
+
+static int pmbus_read_word_data(struct i2c_client *client, u8 page, u8 reg)
+{
+	int rv;
+
+	rv = pmbus_set_page(client, page);
+	if (rv < 0)
+		return rv;
+
+	return i2c_smbus_read_word_data(client, reg);
+}
+
+static int pmbus_read_byte_data(struct i2c_client *client, u8 page, u8 reg)
+{
+	int rv;
+
+	rv = pmbus_set_page(client, page);
+	if (rv < 0)
+		return rv;
+
+	return i2c_smbus_read_byte_data(client, reg);
+}
+
+static void pmbus_clear_faults(struct i2c_client *client)
+{
+	struct pmbus_data *data = i2c_get_clientdata(client);
+	int i;
+
+	for (i = 0; i < data->pages; i++)
+		pmbus_write_byte(client, i, PMBUS_CLEAR_FAULTS);
+}
+
+static bool pmbus_check_byte_register(struct i2c_client *client, int page,
+				      int reg)
+{
+	return (pmbus_read_byte_data(client, page, reg) >= 0);
+}
+
+static bool pmbus_check_word_register(struct i2c_client *client, int page,
+				      int reg)
+{
+	return (pmbus_read_word_data(client, page, reg) >= 0);
+}
+
+static struct pmbus_data *pmbus_update_device(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct pmbus_data *data = i2c_get_clientdata(client);
+	struct pmbus_data *ret = data;
+
+	mutex_lock(&data->update_lock);
+	if (time_after(jiffies, data->last_updated + HZ) || !data->valid) {
+		int i, val;
+
+		for (i = 0; i < data->pages; i++) {
+			val = pmbus_read_byte_data(client, i,
+						   PMBUS_STATUS_BYTE);
+			if (val < 0) {
+				ret = ERR_PTR(val);
+				goto abort;
+			}
+			data->status[PB_STATUS_BASE + i] = val;
+		}
+		if (data->status_bits & PB_HAVE_STATUS_VOUT)
+			for (i = 0; i < data->pages; i++) {
+				val = pmbus_read_byte_data(client, i,
+							   PMBUS_STATUS_VOUT);
+				if (val < 0) {
+					ret = ERR_PTR(val);
+					goto abort;
+				}
+				data->status[PB_STATUS_VOUT_BASE + i] = val;
+			}
+		if (data->status_bits & PB_HAVE_STATUS_IOUT)
+			for (i = 0; i < data->pages; i++) {
+				val = pmbus_read_byte_data(client, i,
+							   PMBUS_STATUS_IOUT);
+				if (val < 0) {
+					ret = ERR_PTR(val);
+					goto abort;
+				}
+				data->status[PB_STATUS_IOUT_BASE + i] = val;
+			}
+		if (data->status_bits & PB_HAVE_STATUS_INPUT) {
+			val = pmbus_read_byte_data(client, 0,
+						   PMBUS_STATUS_INPUT);
+			if (val < 0) {
+				ret = ERR_PTR(val);
+				goto abort;
+			}
+			data->status[PB_STATUS_INPUT_BASE] = val;
+		}
+		if (data->status_bits & PB_HAVE_STATUS_TEMP) {
+			val = pmbus_read_byte_data(client, 0,
+						   PMBUS_STATUS_TEMPERATURE);
+			if (val < 0) {
+				ret = ERR_PTR(val);
+				goto abort;
+			}
+			data->status[PB_STATUS_TEMP_BASE] = val;
+		}
+		for (i = 0; i < data->num_sensors; i++) {
+			struct pmbus_sensor *sensor = &data->sensors[i];
+
+			if (!data->valid || sensor->update) {
+				val = pmbus_read_word_data(client, sensor->page,
+							   sensor->reg);
+				if (val < 0) {
+					ret = ERR_PTR(val);
+					goto abort;
+				}
+				sensor->data = val;
+			}
+		}
+		pmbus_clear_faults(client);
+		data->last_updated = jiffies;
+		data->valid = 1;
+	}
+abort:
+	mutex_unlock(&data->update_lock);
+	return ret;
+}
+
+/*
+ * Convert linear sensor values to milli- or micro-units
+ * depending on sensor type.
+ */
+static long pmbus_reg2data_linear(struct pmbus_data *data,
+				  struct pmbus_sensor *sensor)
+{
+	s16 exponent, mantissa;
+	long val;
+
+	exponent = sensor->data >> 11;
+	mantissa = sensor->data & 0x07ff;
+
+	if (exponent > 0x0f)
+		exponent |= 0xffe0;	/* sign extend exponent */
+	if (mantissa > 0x03ff)
+		mantissa |= 0xf800;	/* sign extend mantissa */
+
+	/* scale result to milli-units */
+	val = mantissa * 1000L;
+
+	/* scale result to micro-units for power sensors */
+	if (sensor->class == PSC_POWER)
+		val = val * 1000L;
+
+	if (exponent >= 0)
+		val <<= exponent;
+	else
+		val >>= -exponent;
+
+	return val;
+}
+
+/*
+ * Convert direct sensor values to milli- or micro-units
+ * depending on sensor type.
+ */
+static long pmbus_reg2data_direct(struct pmbus_data *data,
+				  struct pmbus_sensor *sensor)
+{
+	long val = (s16) sensor->data;
+	long m, b, R;
+
+	m = data->m[sensor->class];
+	b = data->b[sensor->class];
+	R = data->R[sensor->class];
+
+	if (m == 0)
+		return 0;
+
+	/* X = 1/m * (Y * 10^-R - b) */
+	R = -R + 3;		/* scale result to milli-units */
+	b *= 1000;		/* subtract milli-units */
+
+	/* scale result to micro-units for power sensors */
+	if (sensor->class == PSC_POWER) {
+		R += 3;
+		b *= 1000;
+	}
+
+	while (R > 0) {
+		val *= 10;
+		R--;
+	}
+	while (R < 0) {
+		val = DIV_ROUND_CLOSEST(val, 10);
+		R++;
+	}
+
+	return (val - b) / m;
+}
+
+static long pmbus_reg2data(struct pmbus_data *data, struct pmbus_sensor *sensor)
+{
+	long val;
+
+	if (data->direct)
+		val = pmbus_reg2data_direct(data, sensor);
+	else
+		val = pmbus_reg2data_linear(data, sensor);
+
+	return val;
+}
+
+#define MAX_MANTISSA	(1023 * 1000)
+#define MIN_MANTISSA	(511 * 1000)
+
+static u16 pmbus_data2reg_linear(struct pmbus_data *data,
+				 enum pmbus_sensor_classes class, long val)
+{
+	s16 exponent = 0, mantissa = 0;
+	bool negative = false;
+
+	/* simple case */
+	if (val == 0)
+		return 0;
+
+	if (val < 0) {
+		negative = true;
+		val = -val;
+	}
+
+	/* Power is in uW. Convert to mW before converting. */
+	if (class == PSC_POWER)
+		val = DIV_ROUND_CLOSEST(val, 1000L);
+
+	/* Reduce large mantissa until it fits into 10 bit */
+	while (val >= MAX_MANTISSA && exponent < 15) {
+		exponent++;
+		val >>= 1;
+	}
+	/* Increase small mantissa to improve precision */
+	while (val < MIN_MANTISSA && exponent > -15) {
+		exponent--;
+		val <<= 1;
+	}
+
+	/* Convert mantissa from milli-units to units */
+	mantissa = DIV_ROUND_CLOSEST(val, 1000);
+
+	/* Ensure that resulting number is within range */
+	if (mantissa > 0x3ff)
+		mantissa = 0x3ff;
+
+	/* restore sign */
+	if (negative)
+		mantissa = -mantissa;
+
+	/* Convert to 5 bit exponent, 11 bit mantissa */
+	return (mantissa & 0x7ff) | ((exponent << 11) & 0xf800);
+}
+
+static u16 pmbus_data2reg_direct(struct pmbus_data *data,
+				 enum pmbus_sensor_classes class, long val)
+{
+	long m, b, R;
+
+	m = data->m[class];
+	b = data->b[class];
+	R = data->R[class];
+
+	/* Power is in uW. Adjust R. */
+	if (class == PSC_POWER)
+		R -= 3;
+
+	/* Calculate Y = (m * X + b) * 10^R */
+	R -= 3;		/* Adjust R for data in milli-units */
+	val *= m;
+	val += b * 1000;
+
+	while (R > 0) {
+		val *= 10;
+		R--;
+	}
+	while (R < 0) {
+		val = DIV_ROUND_CLOSEST(val, 10);
+		R++;
+	}
+
+	return val;
+}
+
+static u16 pmbus_data2reg(struct pmbus_data *data,
+			  enum pmbus_sensor_classes class, long val)
+{
+	u16 regval;
+
+	if (data->direct)
+		regval = pmbus_data2reg_direct(data, class, val);
+	else
+		regval = pmbus_data2reg_linear(data, class, val);
+
+	return regval;
+}
+
+/* Return converted value from given object */
+static long pmbus_get_sensor(struct pmbus_data *data, int index)
+{
+	return pmbus_reg2data(data, &data->sensors[index]);
+}
+
+/*
+ * Return boolean calculated from converted data.
+ * <index> defines a status register index and mask, and optionally
+ * two sensor indexes.
+ * The upper half-word references the two sensors,
+ * the lower half word references status register and mask.
+ * The function returns true if (status[reg] & mask) is true and,
+ * if specified, if v1 >= v2.
+ * To determine if an object exceeds upper limits, specify <v, limit>.
+ * To determine if an object exceeds lower limits, specify <limit, v>.
+ */
+static long pmbus_get_boolean(struct pmbus_data *data, int index)
+{
+	u8 s1 = (index >> 24) & 0xff;
+	u8 s2 = (index >> 16) & 0xff;
+	u8 reg = (index >> 8) & 0xff;
+	u8 mask = index & 0xff;
+	int rv = 0;
+	u8 regval = data->status[reg] & mask;
+
+	if (!s1 && !s2)
+		rv = !!regval;
+	else {
+		int v1, v2;
+
+		v1 = pmbus_reg2data(data, &data->sensors[s1]);
+		v2 = pmbus_reg2data(data, &data->sensors[s2]);
+		rv = !!(regval && v1 >= v2);
+	}
+	return rv;
+}
+
+#define PMBUS_SHOW_INT(what) \
+	static ssize_t pmbus_show_##what(struct device *dev, \
+					 struct device_attribute *da, \
+					 char *buf) \
+{ \
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(da); \
+	struct pmbus_data *data = pmbus_update_device(dev); \
+	long val; \
+	if (IS_ERR(data)) \
+		return PTR_ERR(data); \
+	val = pmbus_get_##what(data, attr->index); \
+	return snprintf(buf, PAGE_SIZE, "%ld\n", val); \
+}
+
+PMBUS_SHOW_INT(sensor);
+PMBUS_SHOW_INT(boolean);
+
+static ssize_t pmbus_set_sensor(struct device *dev,
+				struct device_attribute *devattr,
+				const char *buf, size_t count)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct i2c_client *client = to_i2c_client(dev);
+	struct pmbus_data *data = i2c_get_clientdata(client);
+	struct pmbus_sensor *sensor = &data->sensors[attr->index];
+	ssize_t rv = count;
+	long val = 0;
+	int ret;
+	u16 regval;
+
+	if (strict_strtol(buf, 10, &val) < 0)
+		return -EINVAL;
+
+	mutex_lock(&data->update_lock);
+	regval = pmbus_data2reg(data, sensor->class, val);
+	ret = pmbus_write_word_data(client, sensor->page, sensor->reg, regval);
+	if (ret < 0)
+		rv = ret;
+	else
+		data->sensors[attr->index].data = regval;
+	mutex_unlock(&data->update_lock);
+	return rv;
+}
+
+static ssize_t pmbus_show_label(struct device *dev,
+				struct device_attribute *da,
+				char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct pmbus_data *data = i2c_get_clientdata(client);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
+
+	return snprintf(buf, PAGE_SIZE, "%s\n",
+			data->labels[attr->index].label);
+}
+
+#define PMBUS_ADD_ATTR(data, _name, _idx, _mode, _type, _show, _set)	\
+do {									\
+	struct sensor_device_attribute *a				\
+	    = &data->_type##s[data->num_##_type##s].attribute;		\
+	BUG_ON(data->num_attributes >= data->max_attributes);		\
+	a->dev_attr.attr.name = _name;					\
+	a->dev_attr.attr.mode = _mode;					\
+	a->dev_attr.show = _show;					\
+	a->dev_attr.store = _set;					\
+	a->index = _idx;						\
+	data->attributes[data->num_attributes] = &a->dev_attr.attr;	\
+	data->num_attributes++;						\
+} while (0)
+
+#define PMBUS_ADD_GET_ATTR(data, _name, _type, _idx)			\
+  PMBUS_ADD_ATTR(data, _name, _idx, S_IRUGO, _type,			\
+		       pmbus_show_##_type,  NULL)
+
+#define PMBUS_ADD_SET_ATTR(data, _name, _type, _idx)			\
+  PMBUS_ADD_ATTR(data, _name, _idx, S_IWUSR | S_IRUGO, _type,		\
+		       pmbus_show_##_type, pmbus_set_##_type)
+
+static void pmbus_add_boolean(struct pmbus_data *data,
+			      const char *name, const char *type, int seq,
+			      int val)
+{
+	struct pmbus_boolean *boolean;
+
+	BUG_ON(data->num_booleans >= data->max_booleans);
+
+	boolean = &data->booleans[data->num_booleans];
+
+	snprintf(boolean->name, sizeof(boolean->name), "%s%d_%s",
+		 name, seq, type);
+	PMBUS_ADD_GET_ATTR(data, boolean->name, boolean, val);
+	data->num_booleans++;
+}
+
+static void pmbus_add_boolean_reg(struct pmbus_data *data,
+				  const char *name, const char *type,
+				  int seq, int reg, int bit)
+{
+	pmbus_add_boolean(data, name, type, seq,
+			  (reg << 8) | bit);
+}
+
+static void pmbus_add_boolean_cmp(struct pmbus_data *data,
+				  const char *name, const char *type,
+				  int seq, int i1, int i2, int reg,
+				  int mask)
+{
+       pmbus_add_boolean(data, name, type, seq,
+			 (i1 << 24) | (i2 << 16) | (reg << 8) | mask);
+}
+
+static void pmbus_add_sensor(struct pmbus_data *data,
+			     const char *name, const char *type, int seq,
+			     int page, int reg, enum pmbus_sensor_classes class,
+			     bool update)
+{
+	struct pmbus_sensor *sensor;
+
+	BUG_ON(data->num_sensors >= data->max_sensors);
+
+	sensor = &data->sensors[data->num_sensors];
+	snprintf(sensor->name, sizeof(sensor->name), "%s%d_%s",
+		 name, seq, type);
+	sensor->page = page;
+	sensor->reg = reg;
+	sensor->class = class;
+	sensor->update = update;
+	if (update)
+		PMBUS_ADD_GET_ATTR(data, sensor->name, sensor,
+				   data->num_sensors);
+	else
+		PMBUS_ADD_SET_ATTR(data, sensor->name, sensor,
+				   data->num_sensors);
+	data->num_sensors++;
+}
+
+static void pmbus_add_label(struct pmbus_data *data,
+			    const char *name, int seq,
+			    const char *lstring, int index)
+{
+	struct pmbus_label *label;
+
+	BUG_ON(data->num_labels >= data->max_labels);
+
+	label = &data->labels[data->num_labels];
+	snprintf(label->name, sizeof(label->name), "%s%d_label",
+		 name, seq);
+	if (!index)
+		strncpy(label->label, lstring, sizeof(label->label) - 1);
+	else
+		snprintf(label->label, sizeof(label->label), "%s%d", lstring,
+			 index);
+
+	PMBUS_ADD_GET_ATTR(data, label->name, label, data->num_labels);
+	data->num_labels++;
+}
+
+/*
+ * Identify important chip parameters.
+ */
+static void pmbus_identify_generic(struct i2c_client *client,
+				   struct pmbus_data *data)
+{
+	/*
+	 * Check if the PAGE command is supported. If it is,
+	 * keep setting the page number until it fails or until the
+	 * maximum number of pages has been reached. Assume that
+	 * this is the number of pages supported by the chip.
+	 */
+	if (pmbus_check_byte_register(client, 0, PMBUS_PAGE)) {
+		int page;
+
+		for (page = 1; page < PMBUS_PAGES; page++) {
+			if (pmbus_set_page(client, page) < 0)
+				break;
+		}
+		pmbus_set_page(client, 0);
+		data->pages = page;
+	} else
+		data->pages = 1;
+
+	/*
+	 * We should check if the COEFFICIENTS register is supported.
+	 * If it is, select direct mode and read the coefficients from the
+	 * chip, one set per group of sensor registers.
+	 *
+	 * To do this, we will need access to a chip which actually supports the
+	 * COEFFICIENTS command, since the command is too complex to implement
+	 * without testing it.
+	 */
+}
+
+static int pmbus_temp_sensors[] = {
+	PMBUS_READ_TEMPERATURE_1,
+	PMBUS_READ_TEMPERATURE_2,
+	PMBUS_READ_TEMPERATURE_3
+};
+
+/*
+ * Determine maximum number of sensors, booleans, and labels.
+ * To keep things simple, only make a rough high estimate.
+ */
+static void pmbus_find_max_attr(struct i2c_client *client,
+				struct pmbus_data *data)
+{
+	int i, max_sensors, max_booleans, max_labels;
+
+	max_sensors = PMBUS_MAX_INPUT_SENSORS;
+	max_booleans = PMBUS_MAX_INPUT_BOOLEANS;
+	max_labels = PMBUS_MAX_INPUT_LABELS;
+
+	if (pmbus_check_word_register(client, 0, PMBUS_READ_VOUT)) {
+		max_sensors += data->pages * PMBUS_VOUT_SENSORS_PER_PAGE;
+		max_booleans += data->pages * PMBUS_VOUT_BOOLEANS_PER_PAGE;
+		max_labels += data->pages;
+	}
+	if (pmbus_check_word_register(client, 0, PMBUS_READ_IOUT)) {
+		max_sensors += data->pages * PMBUS_IOUT_SENSORS_PER_PAGE;
+		max_booleans += data->pages * PMBUS_IOUT_BOOLEANS_PER_PAGE;
+		max_labels += data->pages;
+	}
+	if (pmbus_check_word_register(client, 0, PMBUS_READ_POUT)) {
+		max_sensors += data->pages * PMBUS_POUT_SENSORS_PER_PAGE;
+		max_booleans += data->pages * PMBUS_POUT_BOOLEANS_PER_PAGE;
+		max_labels += data->pages;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(pmbus_temp_sensors); i++) {
+		if (!pmbus_check_word_register(client, 0,
+					       pmbus_temp_sensors[i]))
+			break;
+		max_sensors += PMBUS_MAX_SENSORS_PER_TEMP;
+		max_booleans += PMBUS_MAX_BOOLEANS_PER_TEMP;
+	}
+	data->max_sensors = max_sensors;
+	data->max_booleans = max_booleans;
+	data->max_labels = max_labels;
+	data->max_attributes = max_sensors + max_booleans + max_labels;
+}
+
+/*
+ * Search for attributes. Allocate sensors, booleans, and labels as needed.
+ */
+static void pmbus_find_attributes(struct i2c_client *client,
+				  struct pmbus_data *data)
+{
+	int i, i0, i1, in_index;
+
+	/*
+	 * Input voltage sensors
+	 */
+	in_index = 1;
+	if (pmbus_check_word_register(client, 0, PMBUS_READ_VIN)) {
+		i0 = data->num_sensors;
+		pmbus_add_label(data, "in", in_index, "vin", 0);
+		pmbus_add_sensor(data, "in", "input", in_index,
+				 0, PMBUS_READ_VIN, PSC_VOLTAGE, true);
+		if (pmbus_check_word_register(client, 0,
+					      PMBUS_VIN_UV_WARN_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "in", "min", in_index,
+					 0, PMBUS_VIN_UV_WARN_LIMIT,
+					 PSC_VOLTAGE, false);
+			if (data->status_bits & PB_HAVE_STATUS_INPUT)
+				pmbus_add_boolean_reg(data, "in", "min_alarm",
+						      in_index,
+						      PB_STATUS_INPUT_BASE,
+						      PB_VOLTAGE_UV_WARNING);
+		}
+		if (pmbus_check_word_register(client, 0,
+					      PMBUS_VIN_UV_FAULT_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "in", "lcrit", in_index,
+					 0, PMBUS_VIN_UV_FAULT_LIMIT,
+					 PSC_VOLTAGE, false);
+			if (data->status_bits & PB_HAVE_STATUS_INPUT)
+				pmbus_add_boolean_reg(data, "in", "lcrit_alarm",
+						      in_index,
+						      PB_STATUS_INPUT_BASE,
+						      PB_VOLTAGE_UV_FAULT);
+		}
+		if (pmbus_check_word_register(client, 0,
+					      PMBUS_VIN_OV_WARN_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "in", "max", in_index,
+					 0, PMBUS_VIN_OV_WARN_LIMIT,
+					 PSC_VOLTAGE, false);
+			if (data->status_bits & PB_HAVE_STATUS_INPUT)
+				pmbus_add_boolean_reg(data, "in", "max_alarm",
+						      in_index,
+						      PB_STATUS_INPUT_BASE,
+						      PB_VOLTAGE_OV_WARNING);
+		}
+		if (pmbus_check_word_register(client, 0,
+					      PMBUS_VIN_OV_FAULT_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "in", "crit", in_index,
+					 0, PMBUS_VIN_OV_FAULT_LIMIT,
+					 PSC_VOLTAGE, false);
+			if (data->status_bits & PB_HAVE_STATUS_INPUT)
+				pmbus_add_boolean_reg(data, "in", "crit_alarm",
+						      in_index,
+						      PB_STATUS_INPUT_BASE,
+						      PB_VOLTAGE_OV_FAULT);
+		}
+		in_index++;
+	}
+	if (pmbus_check_word_register(client, 0, PMBUS_READ_VCAP)) {
+		pmbus_add_label(data, "in", in_index, "vcap", 0);
+		pmbus_add_sensor(data, "in", "input", in_index, 0,
+				 PMBUS_READ_VCAP, PSC_VOLTAGE, true);
+		in_index++;
+	}
+
+	/*
+	 * Output voltage sensors
+	 */
+	for (i = 0; i < data->pages; i++) {
+		if (!pmbus_check_word_register(client, i, PMBUS_READ_VOUT))
+			break;
+
+		i0 = data->num_sensors;
+		pmbus_add_label(data, "in", in_index, "vout", i+1);
+		pmbus_add_sensor(data, "in", "input", in_index, i,
+				 PMBUS_READ_VOUT, PSC_VOLTAGE, true);
+		if (pmbus_check_word_register(client, i,
+					      PMBUS_VOUT_UV_WARN_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "in", "min", in_index, i,
+					 PMBUS_VOUT_UV_WARN_LIMIT, PSC_VOLTAGE,
+					 false);
+			if (data->status_bits & PB_HAVE_STATUS_VOUT)
+				pmbus_add_boolean_reg(data, "in", "min_alarm",
+						      in_index,
+						      PB_STATUS_VOUT_BASE + i,
+						      PB_VOLTAGE_UV_WARNING);
+		}
+		if (pmbus_check_word_register(client, i,
+					      PMBUS_VOUT_UV_FAULT_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "in", "lcrit", in_index, i,
+					 PMBUS_VOUT_UV_FAULT_LIMIT, PSC_VOLTAGE,
+					 false);
+			if (data->status_bits & PB_HAVE_STATUS_VOUT)
+				pmbus_add_boolean_reg(data, "in", "lcrit_alarm",
+						      in_index,
+						      PB_STATUS_VOUT_BASE + i,
+						      PB_VOLTAGE_UV_FAULT);
+		}
+		if (pmbus_check_word_register(client, i,
+					      PMBUS_VOUT_OV_WARN_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "in", "max", in_index, i,
+					 PMBUS_VOUT_OV_WARN_LIMIT, PSC_VOLTAGE,
+					 false);
+			if (data->status_bits & PB_HAVE_STATUS_VOUT) {
+				pmbus_add_boolean_reg(data, "in", "max_alarm",
+						      in_index,
+						      PB_STATUS_VOUT_BASE + i,
+						      PB_VOLTAGE_OV_WARNING);
+			}
+		}
+		if (pmbus_check_word_register(client, i,
+					      PMBUS_VOUT_OV_FAULT_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "in", "crit", in_index, i,
+					 PMBUS_VOUT_OV_FAULT_LIMIT, PSC_VOLTAGE,
+					 false);
+			if (data->status_bits & PB_HAVE_STATUS_VOUT)
+				pmbus_add_boolean_reg(data, "in", "crit_alarm",
+						      in_index,
+						      PB_STATUS_VOUT_BASE + i,
+						      PB_VOLTAGE_OV_FAULT);
+		}
+		in_index++;
+	}
+
+	/*
+	 * Current sensors
+	 */
+
+	/*
+	 * Input current sensors
+	 */
+	in_index = 1;
+	if (pmbus_check_word_register(client, 0, PMBUS_READ_IIN)) {
+		i0 = data->num_sensors;
+		pmbus_add_label(data, "curr", in_index, "iin", 0);
+		pmbus_add_sensor(data, "curr", "input", in_index,
+				 0, PMBUS_READ_IIN, PSC_CURRENT, true);
+		if (pmbus_check_word_register(client, 0,
+					      PMBUS_IIN_OC_WARN_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "curr", "max", in_index,
+					 0, PMBUS_IIN_OC_WARN_LIMIT,
+					 PSC_CURRENT, false);
+			if (data->status_bits & PB_HAVE_STATUS_INPUT) {
+				pmbus_add_boolean_reg(data, "curr", "alarm",
+						      in_index,
+						      PB_STATUS_INPUT_BASE,
+						      PB_IIN_OC_WARNING);
+			}
+		}
+		if (pmbus_check_word_register(client, 0,
+					      PMBUS_IIN_OC_FAULT_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "curr", "crit", in_index,
+					 0, PMBUS_IIN_OC_FAULT_LIMIT,
+					 PSC_CURRENT, false);
+			if (data->status_bits & PB_HAVE_STATUS_INPUT) {
+				pmbus_add_boolean_reg(data, "curr",
+						      "crit_alarm",
+						      in_index,
+						      PB_STATUS_INPUT_BASE,
+						      PB_IIN_OC_FAULT);
+			}
+		}
+		in_index++;
+	}
+
+	/*
+	 * Output Current sensors
+	 */
+	for (i = 0; i < data->pages; i++) {
+		if (!pmbus_check_word_register(client, i, PMBUS_READ_IOUT))
+			break;
+
+		i0 = data->num_sensors;
+		pmbus_add_label(data, "curr", in_index, "iout", i+1);
+		pmbus_add_sensor(data, "curr", "input", in_index, i,
+				 PMBUS_READ_IOUT, PSC_CURRENT, true);
+		if (pmbus_check_word_register(client, i,
+					      PMBUS_IOUT_OC_WARN_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "curr", "max", in_index, i,
+					 PMBUS_IOUT_OC_WARN_LIMIT, PSC_CURRENT,
+					 false);
+			if (data->status_bits & PB_HAVE_STATUS_IOUT)
+				pmbus_add_boolean_reg(data, "curr", "alarm",
+						      in_index,
+						      PB_STATUS_IOUT_BASE + i,
+						      PB_IOUT_OC_WARNING);
+		}
+		if (pmbus_check_word_register(client, i,
+					      PMBUS_IOUT_UC_FAULT_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "curr", "lcrit", in_index, i,
+					 PMBUS_IOUT_UC_FAULT_LIMIT, PSC_CURRENT,
+					 false);
+			if (data->status_bits & PB_HAVE_STATUS_IOUT)
+				pmbus_add_boolean_reg(data, "curr",
+						      "lcrit_alarm",
+						      in_index,
+						      PB_STATUS_IOUT_BASE + i,
+						      PB_IOUT_UC_FAULT);
+		}
+		if (pmbus_check_word_register(client, i,
+					      PMBUS_IOUT_OC_FAULT_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "curr", "crit", in_index, i,
+					 PMBUS_IOUT_OC_FAULT_LIMIT, PSC_CURRENT,
+					 false);
+			if (data->status_bits & PB_HAVE_STATUS_IOUT)
+				pmbus_add_boolean_reg(data, "curr",
+						      "crit_alarm",
+						      in_index,
+						      PB_STATUS_IOUT_BASE + i,
+						      PB_IOUT_OC_FAULT);
+		}
+		in_index++;
+	}
+
+	/*
+	 * Power sensors
+	 */
+	/*
+	 * Input Power sensors
+	 */
+	in_index = 1;
+	if (pmbus_check_word_register(client, 0, PMBUS_READ_PIN)) {
+		i0 = data->num_sensors;
+		pmbus_add_label(data, "power", in_index, "pin", 0);
+		pmbus_add_sensor(data, "power", "input", in_index,
+				 0, PMBUS_READ_PIN, PSC_POWER, true);
+		if (pmbus_check_word_register(client, 0,
+					      PMBUS_PIN_OP_WARN_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "power", "max", in_index,
+					 0, PMBUS_PIN_OP_WARN_LIMIT, PSC_POWER,
+					 false);
+			if (data->status_bits & PB_HAVE_STATUS_INPUT)
+				pmbus_add_boolean_reg(data, "power", "alarm",
+						      in_index,
+						      PB_STATUS_INPUT_BASE,
+						      PB_PIN_OP_WARNING);
+		}
+		in_index++;
+	}
+
+	/*
+	 * Output Power sensors
+	 */
+	for (i = 0; i < data->pages; i++) {
+		bool need_alarm = false;
+
+		if (!pmbus_check_word_register(client, i, PMBUS_READ_POUT))
+			break;
+
+		i0 = data->num_sensors;
+		pmbus_add_label(data, "power", in_index, "pout", i+1);
+		pmbus_add_sensor(data, "power", "input", in_index, i,
+				 PMBUS_READ_POUT, PSC_POWER, true);
+		/*
+		 * Per hwmon sysfs API, power_cap is to be used to limit output
+		 * power.
+		 * We have two registers related to maximum output power,
+		 * PMBUS_POUT_MAX and PMBUS_POUT_OP_WARN_LIMIT.
+		 * PMBUS_POUT_MAX matches the powerX_cap attribute definition.
+		 * There is no attribute in the API to match
+		 * PMBUS_POUT_OP_WARN_LIMIT. We use powerX_max for now.
+		 */
+		if (pmbus_check_word_register(client, i, PMBUS_POUT_MAX)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "power", "cap", in_index, i,
+					 PMBUS_POUT_MAX, PSC_POWER, false);
+			need_alarm = true;
+		}
+		if (pmbus_check_word_register(client, i,
+					      PMBUS_POUT_OP_WARN_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "power", "max", in_index, i,
+					 PMBUS_POUT_OP_WARN_LIMIT, PSC_POWER,
+					 false);
+			need_alarm = true;
+		}
+		if (need_alarm && (data->status_bits & PB_HAVE_STATUS_IOUT))
+			pmbus_add_boolean_reg(data, "power", "alarm",
+					      in_index,
+					      PB_STATUS_IOUT_BASE,
+					      PB_POUT_OP_WARNING
+					      | PB_POWER_LIMITING);
+
+		if (pmbus_check_word_register(client, i,
+					      PMBUS_POUT_OP_FAULT_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "power", "crit", in_index, i,
+					 PMBUS_POUT_OP_FAULT_LIMIT, PSC_POWER,
+					 false);
+			if (data->status_bits & PB_HAVE_STATUS_IOUT)
+				pmbus_add_boolean_reg(data, "power",
+						      "crit_alarm",
+						      in_index,
+						      PB_STATUS_IOUT_BASE,
+						      PB_POUT_OP_FAULT);
+		}
+		in_index++;
+	}
+
+	/*
+	 * Temperature sensors
+	 */
+	in_index = 1;
+	for (i = 0; i < ARRAY_SIZE(pmbus_temp_sensors); i++) {
+		if (!pmbus_check_word_register(client, 0,
+					       pmbus_temp_sensors[i]))
+			break;
+
+		i0 = data->num_sensors;
+		pmbus_add_sensor(data, "temp", "input", in_index, 0,
+				 pmbus_temp_sensors[i], PSC_TEMPERATURE, true);
+
+		/*
+		 * PMBus provides only one status register for all temperature
+		 * sensors. Thus, we can not use the status register to
+		 * determine which of the sensors actually caused an alarm.
+		 * Always compare current temperature against the limit
+		 * registers to determine alarm conditions for a specific
+		 * sensor.
+		 */
+		if (pmbus_check_word_register(client, 0, PMBUS_UT_WARN_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "temp", "min", in_index, 0,
+					 PMBUS_UT_WARN_LIMIT, PSC_TEMPERATURE,
+					 false);
+			if (data->status_bits & PB_HAVE_STATUS_TEMP)
+				pmbus_add_boolean_cmp(data, "temp", "min_alarm",
+						      in_index, i1, i0,
+						      PB_STATUS_TEMP_BASE,
+						      PB_TEMP_UT_WARNING);
+		}
+		if (pmbus_check_word_register(client, 0,
+					      PMBUS_UT_FAULT_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "temp", "lcrit", in_index, 0,
+					 PMBUS_UT_FAULT_LIMIT, PSC_TEMPERATURE,
+					 false);
+			if (data->status_bits & PB_HAVE_STATUS_TEMP)
+				pmbus_add_boolean_cmp(data, "temp", "lcrit",
+						      in_index, i1, i0,
+						      PB_STATUS_TEMP_BASE,
+						      PB_TEMP_UT_FAULT);
+		}
+		if (pmbus_check_word_register(client, 0, PMBUS_OT_WARN_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "temp", "max", in_index, 0,
+					 PMBUS_OT_WARN_LIMIT, PSC_TEMPERATURE,
+					 false);
+			if (data->status_bits & PB_HAVE_STATUS_TEMP)
+				pmbus_add_boolean_cmp(data, "temp", "max_alarm",
+						      in_index, i0, i1,
+						      PB_STATUS_TEMP_BASE,
+						      PB_TEMP_OT_WARNING);
+		}
+		if (pmbus_check_word_register(client, 0,
+					      PMBUS_OT_FAULT_LIMIT)) {
+			i1 = data->num_sensors;
+			pmbus_add_sensor(data, "temp", "crit", in_index, 0,
+					 PMBUS_OT_FAULT_LIMIT, PSC_TEMPERATURE,
+					 false);
+			if (data->status_bits & PB_HAVE_STATUS_TEMP)
+				pmbus_add_boolean_cmp(data, "temp",
+						      "crit_alarm",
+						      in_index, i0, i1,
+						      PB_STATUS_TEMP_BASE,
+						      PB_TEMP_OT_FAULT);
+		}
+		in_index++;
+	}
+
+	pmbus_clear_faults(client);
+}
+
+static int pmbus_probe(struct i2c_client *client,
+		       const struct i2c_device_id *id)
+{
+	struct pmbus_data *data;
+	int i, ret;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA
+				     | I2C_FUNC_SMBUS_WORD_DATA))
+		return -ENODEV;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	i2c_set_clientdata(client, data);
+	mutex_init(&data->update_lock);
+
+	data->type = id->driver_data;
+	data->direct = pmbus_config[data->type].direct;
+	data->pages = pmbus_config[data->type].pages;
+
+	/*
+	 * Bail out if status register or PMBus revision register
+	 * does not exist.
+	 */
+	if (!pmbus_check_byte_register(client, 0, PMBUS_STATUS_BYTE)
+	    || !pmbus_check_byte_register(client, 0, PMBUS_REVISION)) {
+		ret = -ENODEV;
+		goto out_data;
+	}
+
+	if (data->type == pmbus) {
+		pmbus_identify_generic(client, data);
+	} else {
+		/*
+		 * Bail out if more than one page was configured, but we can not
+		 * select the highest page. This is an indication that the wrong
+		 * chip type was selected. Better bail out now than keep
+		 * returning errors later on.
+		 */
+		if (data->pages > 1 && pmbus_set_page(client,
+						      data->pages-1) < 0) {
+			dev_err(&client->dev, "Failed to select page %d",
+				data->pages-1);
+			ret = -EINVAL;
+			goto out_data;
+		}
+		if (data->direct)
+			for (i = 0; i < PSC_NUM_CLASSES; i++) {
+				data->m[i] = pmbus_config[data->type].m[i];
+				data->b[i] = pmbus_config[data->type].b[i];
+				data->R[i] = pmbus_config[data->type].R[i];
+			}
+	}
+
+	/*
+	 * Identify supported status registers
+	 */
+	if (pmbus_check_byte_register(client, 0, PMBUS_STATUS_VOUT))
+		data->status_bits |= PB_HAVE_STATUS_VOUT;
+	if (pmbus_check_byte_register(client, 0, PMBUS_STATUS_IOUT))
+		data->status_bits |= PB_HAVE_STATUS_IOUT;
+	if (pmbus_check_byte_register(client, 0, PMBUS_STATUS_INPUT))
+		data->status_bits |= PB_HAVE_STATUS_INPUT;
+	if (pmbus_check_byte_register(client, 0, PMBUS_STATUS_TEMPERATURE))
+		data->status_bits |= PB_HAVE_STATUS_TEMP;
+
+	/* Determine maximum number of sensors, booleans, and labels */
+	pmbus_find_max_attr(client, data);
+
+	ret = -ENOMEM;
+	data->sensors = kzalloc(sizeof(struct pmbus_sensor) * data->max_sensors,
+				GFP_KERNEL);
+	if (!data->sensors)
+		goto out_data;
+
+	data->booleans = kzalloc(sizeof(struct pmbus_boolean)
+				 * data->max_booleans, GFP_KERNEL);
+	if (!data->booleans)
+		goto out_sensors;
+
+	data->labels = kzalloc(sizeof(struct pmbus_label) * data->max_labels,
+			       GFP_KERNEL);
+	if (!data->labels)
+		goto out_booleans;
+
+	data->attributes = kzalloc(sizeof(struct attribute *)
+				   * data->max_attributes, GFP_KERNEL);
+	if (!data->attributes)
+		goto out_labels;
+
+	pmbus_find_attributes(client, data);
+
+	/*
+	 * If there are no attributes, something is wrong.
+	 * Bail out instead of trying to register nothing.
+	 */
+	if (!data->num_attributes) {
+		ret = -ENODEV;
+		goto out_attributes;
+	}
+
+	/* Register sysfs hooks */
+	data->group.attrs = data->attributes;
+	ret = sysfs_create_group(&client->dev.kobj, &data->group);
+	if (ret)
+		goto out_attributes;
+	data->hwmon_dev = hwmon_device_register(&client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		ret = PTR_ERR(data->hwmon_dev);
+		goto out_hwmon_device_register;
+	}
+	return 0;
+out_hwmon_device_register:
+	sysfs_remove_group(&client->dev.kobj, &data->group);
+out_attributes:
+	kfree(data->attributes);
+out_labels:
+	kfree(data->labels);
+out_booleans:
+	kfree(data->booleans);
+out_sensors:
+	kfree(data->sensors);
+out_data:
+	kfree(data);
+out:
+	return ret;
+}
+
+static int pmbus_remove(struct i2c_client *client)
+{
+	struct pmbus_data *data = i2c_get_clientdata(client);
+	hwmon_device_unregister(data->hwmon_dev);
+	sysfs_remove_group(&client->dev.kobj, &data->group);
+	kfree(data->attributes);
+	kfree(data->labels);
+	kfree(data->booleans);
+	kfree(data->sensors);
+	kfree(data);
+	return 0;
+}
+
+static const struct i2c_device_id pmbus_id[] = {
+	{"bmr45x", pmbus},
+	{"ltc2978", ltc2978},
+	{"max16064", max16064},
+	{"max8688", max8688},
+	{"pmbus", pmbus},
+	{"ucd921x", pmbus},
+	{"ucd9220", ucd9220},
+	{"ucd9240", ucd9240},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, pmbus_id);
+
+/* This is the driver that will be inserted */
+static struct i2c_driver pmbus_driver = {
+	.driver = {
+		.name = "pmbus",
+		},
+	.probe = pmbus_probe,
+	.remove = pmbus_remove,
+	.id_table = pmbus_id,
+};
+
+static int __init pmbus_init(void)
+{
+	return i2c_add_driver(&pmbus_driver);
+}
+
+static void __exit pmbus_exit(void)
+{
+	i2c_del_driver(&pmbus_driver);
+}
+
+MODULE_AUTHOR("Guenter Roeck");
+MODULE_DESCRIPTION("PMBus driver");
+MODULE_LICENSE("GPL");
+module_init(pmbus_init);
+module_exit(pmbus_exit);
diff --git a/drivers/hwmon/pmbus.h b/drivers/hwmon/pmbus.h
new file mode 100644
index 0000000..2a8a027
--- /dev/null
+++ b/drivers/hwmon/pmbus.h
@@ -0,0 +1,209 @@
+/*
+ * pmbus.h - Common defines and structures for PMBus devices
+ *
+ * Copyright (c) 2010 Ericsson AB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef PMBUS_H
+#define PMBUS_H
+
+/*
+ * Registers
+ */
+#define PMBUS_PAGE			0x00
+#define PMBUS_OPERATION			0x01
+#define PMBUS_ON_OFF_CONFIG		0x02
+#define PMBUS_CLEAR_FAULTS		0x03
+#define PMBUS_PHASE			0x04
+
+#define PMBUS_CAPABILITY		0x19
+#define PMBUS_QUERY			0x1A
+
+#define PMBUS_VOUT_MODE			0x20
+#define PMBUS_VOUT_COMMAND		0x21
+#define PMBUS_VOUT_TRIM			0x22
+#define PMBUS_VOUT_CAL_OFFSET		0x23
+#define PMBUS_VOUT_MAX			0x24
+#define PMBUS_VOUT_MARGIN_HIGH		0x25
+#define PMBUS_VOUT_MARGIN_LOW		0x26
+#define PMBUS_VOUT_TRANSITION_RATE	0x27
+#define PMBUS_VOUT_DROOP		0x28
+#define PMBUS_VOUT_SCALE_LOOP		0x29
+#define PMBUS_VOUT_SCALE_MONITOR	0x2A
+
+#define PMBUS_COEFFICIENTS		0x30
+#define PMBUS_POUT_MAX			0x31
+
+#define PMBUS_VOUT_OV_FAULT_LIMIT	0x40
+#define PMBUS_VOUT_OV_FAULT_RESPONSE	0x41
+#define PMBUS_VOUT_OV_WARN_LIMIT	0x42
+#define PMBUS_VOUT_UV_WARN_LIMIT	0x43
+#define PMBUS_VOUT_UV_FAULT_LIMIT	0x44
+#define PMBUS_VOUT_UV_FAULT_RESPONSE	0x45
+#define PMBUS_IOUT_OC_FAULT_LIMIT	0x46
+#define PMBUS_IOUT_OC_FAULT_RESPONSE	0x47
+#define PMBUS_IOUT_OC_LV_FAULT_LIMIT	0x48
+#define PMBUS_IOUT_OC_LV_FAULT_RESPONSE	0x49
+#define PMBUS_IOUT_OC_WARN_LIMIT	0x4A
+#define PMBUS_IOUT_UC_FAULT_LIMIT	0x4B
+#define PMBUS_IOUT_UC_FAULT_RESPONSE	0x4C
+
+#define PMBUS_OT_FAULT_LIMIT		0x4F
+#define PMBUS_OT_FAULT_RESPONSE		0x50
+#define PMBUS_OT_WARN_LIMIT		0x51
+#define PMBUS_UT_WARN_LIMIT		0x52
+#define PMBUS_UT_FAULT_LIMIT		0x53
+#define PMBUS_UT_FAULT_RESPONSE		0x54
+#define PMBUS_VIN_OV_FAULT_LIMIT	0x55
+#define PMBUS_VIN_OV_FAULT_RESPONSE	0x56
+#define PMBUS_VIN_OV_WARN_LIMIT		0x57
+#define PMBUS_VIN_UV_WARN_LIMIT		0x58
+#define PMBUS_VIN_UV_FAULT_LIMIT	0x59
+
+#define PMBUS_IIN_OC_FAULT_LIMIT	0x5B
+#define PMBUS_IIN_OC_WARN_LIMIT		0x5D
+
+#define PMBUS_POUT_OP_FAULT_LIMIT	0x68
+#define PMBUS_POUT_OP_WARN_LIMIT	0x6A
+#define PMBUS_PIN_OP_WARN_LIMIT		0x6B
+
+#define PMBUS_STATUS_BYTE		0x78
+#define PMBUS_STATUS_WORD		0x79
+#define PMBUS_STATUS_VOUT		0x7A
+#define PMBUS_STATUS_IOUT		0x7B
+#define PMBUS_STATUS_INPUT		0x7C
+#define PMBUS_STATUS_TEMPERATURE	0x7D
+#define PMBUS_STATUS_CML		0x7E
+#define PMBUS_STATUS_OTHER		0x7F
+#define PMBUS_STATUS_MFR_SPECIFIC	0x80
+#define PMBUS_STATUS_FANS_1_2		0x81
+#define PMBUS_STATUS_FANS_3_4		0x82
+
+#define PMBUS_READ_VIN			0x88
+#define PMBUS_READ_IIN			0x89
+#define PMBUS_READ_VCAP			0x8A
+#define PMBUS_READ_VOUT			0x8B
+#define PMBUS_READ_IOUT			0x8C
+#define PMBUS_READ_TEMPERATURE_1	0x8D
+#define PMBUS_READ_TEMPERATURE_2	0x8E
+#define PMBUS_READ_TEMPERATURE_3	0x8F
+#define PMBUS_READ_FAN_SPEED_1		0x90
+#define PMBUS_READ_FAN_SPEED_2		0x91
+#define PMBUS_READ_FAN_SPEED_3		0x92
+#define PMBUS_READ_FAN_SPEED_4		0x93
+#define PMBUS_READ_DUTY_CYCLE		0x94
+#define PMBUS_READ_FREQUENCY		0x95
+#define PMBUS_READ_POUT			0x96
+#define PMBUS_READ_PIN			0x97
+
+#define PMBUS_REVISION			0x98
+#define PMBUS_MFR_ID			0x99
+#define PMBUS_MFR_MODEL			0x9A
+#define PMBUS_MFR_REVISION		0x9B
+#define PMBUS_MFR_LOCATION		0x9C
+#define PMBUS_MFR_DATE			0x9D
+#define PMBUS_MFR_SERIAL		0x9E
+
+#define LTC2978_MFR_SPECIAL_ID		0xE7
+
+/*
+ * CAPABILITY
+ */
+#define PB_CAPABILITY_SMBALERT		(1<<4)
+#define PB_CAPABILITY_ERROR_CHECK	(1<<7)
+
+/*
+ * VOUT_MODE
+ */
+#define PB_VOUT_MODE_MODE_MASK		0xe0
+#define PB_VOUT_MODE_PARAM_MASK		0x1f
+
+#define PB_VOUT_MODE_LINEAR		0x00
+#define PB_VOUT_MODE_VID		0x20
+#define PB_VOUT_MODE_DIRECT		0x40
+
+/*
+ * STATUS_BYTE, STATUS_WORD (lower)
+ */
+#define PB_STATUS_NONE_ABOVE		(1<<0)
+#define PB_STATUS_CML			(1<<1)
+#define PB_STATUS_TEMPERATURE		(1<<2)
+#define PB_STATUS_VIN_UV		(1<<3)
+#define PB_STATUS_IOUT_OC		(1<<4)
+#define PB_STATUS_VOUT_OV		(1<<5)
+#define PB_STATUS_OFF			(1<<6)
+#define PB_STATUS_BUSY			(1<<7)
+
+/*
+ * STATUS_WORD (upper)
+ */
+#define PB_STATUS_UNKNOWN		(1<<8)
+#define PB_STATUS_OTHER			(1<<9)
+#define PB_STATUS_FANS			(1<<10)
+#define PB_STATUS_POWER_GOOD_N		(1<<11)
+#define PB_STATUS_WORD_MFR		(1<<12)
+#define PB_STATUS_INPUT			(1<<13)
+#define PB_STATUS_IOUT_POUT		(1<<14)
+#define PB_STATUS_VOUT			(1<<15)
+
+/*
+ * STATUS_IOUT
+ */
+#define PB_POUT_OP_WARNING		(1<<0)
+#define PB_POUT_OP_FAULT		(1<<1)
+#define PB_POWER_LIMITING		(1<<2)
+#define PB_CURRENT_SHARE_FAULT		(1<<3)
+#define PB_IOUT_UC_FAULT		(1<<4)
+#define PB_IOUT_OC_WARNING		(1<<5)
+#define PB_IOUT_OC_LV_FAULT		(1<<6)
+#define PB_IOUT_OC_FAULT		(1<<7)
+
+/*
+ * STATUS_VOUT, STATUS_INPUT
+ */
+#define PB_VOLTAGE_UV_FAULT		(1<<4)
+#define PB_VOLTAGE_UV_WARNING		(1<<5)
+#define PB_VOLTAGE_OV_WARNING		(1<<6)
+#define PB_VOLTAGE_OV_FAULT		(1<<7)
+
+/*
+ * STATUS_INPUT
+ */
+#define PB_PIN_OP_WARNING		(1<<0)
+#define PB_IIN_OC_WARNING		(1<<1)
+#define PB_IIN_OC_FAULT			(1<<2)
+
+/*
+ * STATUS_TEMPERATURE
+ */
+#define PB_TEMP_UT_FAULT		(1<<4)
+#define PB_TEMP_UT_WARNING		(1<<5)
+#define PB_TEMP_OT_WARNING		(1<<6)
+#define PB_TEMP_OT_FAULT		(1<<7)
+
+/*
+ * CML_FAULT_STATUS
+ */
+#define	PB_CML_FAULT_OTHER_MEM_LOGIC	(1<<0)
+#define	PB_CML_FAULT_OTHER_COMM		(1<<1)
+#define	PB_CML_FAULT_PROCESSOR		(1<<3)
+#define	PB_CML_FAULT_MEMORY		(1<<4)
+#define	PB_CML_FAULT_PACKET_ERROR	(1<<5)
+#define	PB_CML_FAULT_INVALID_DATA	(1<<6)
+#define	PB_CML_FAULT_INVALID_COMMAND	(1<<7)
+
+#endif /* PB_H */
-- 
1.7.0.87.g0901d

