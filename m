Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab1CIBcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 20:32:25 -0500
Received: from 90-46-11-204.rar.beartech.net ([204.11.46.90]:45198 "EHLO
	exchsrvr.taosinc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755623Ab1CIBcY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 20:32:24 -0500
Subject: [PATCH 2.6.38-rc7]TAOS 258x: Device Driver
From: Jon Brenner <jbrenner@taosinc.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 08 Mar 2011 19:32:22 -0600
Message-ID: <1299634342.1785.20.camel@jonz-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. August Brenner <jbrenner@taosinc.com>

This driver supports the TAOS tsl258x family of ALS sensors.
This driver provides ALS data (lux), and device configuration via
isysfs/iio.
More significantly, this driver provides the capability to be fed 'glass
coefficients' to accommodate varying system designs (bezels, faceplates,
etc.).  

Signed-off-by: Jon August Brenner <jbrenner@taosinc.com>

---

>From 5b8364f9828dbad5fbfff96385e3fc2a6a6d56ed Mon Sep 17 00:00:00 2001
From: Jon Brenner <jbrenner@taosinc.com>
Date: Tue, 8 Mar 2011 18:37:13 -0600
Subject: [PATCH] TAOS driver for the tsl258x family of devices.

---
 Makefile                                           |    2 +-
 .../staging/iio/Documentation/sysfs-bus-iio-light  |   63 ++
 drivers/staging/iio/light/Kconfig                  |    7 +
 drivers/staging/iio/light/Makefile                 |    1 +
 drivers/staging/iio/light/tsl258x.c                | 1010 ++++++++++++++++++++
 5 files changed, 1082 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 26d7d82..2f7d922 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 38
-EXTRAVERSION = -rc6
+EXTRAVERSION = -rc7
 NAME = Flesh-Eating Bats with Fangs
 
 # *DOCUMENTATION*
diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
index 5d84856..5affc2a 100644
--- a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
+++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
@@ -62,3 +62,66 @@ Description:
 		sensing mode. This value should be the output from a reading
 		and if expressed in SI units, should include _input. If this
 		value is not in SI units, then it should include _raw.
+		
+What:		/sys/bus/iio/devices/device[n]/device_state
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This property gets/sets the TAOS tsl258x power state.
+
+What:		/sys/bus/iio/devices/device[n]/als_gain
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This property gets/sets the TAOS tsl258x analog gain settings
+		of the device.
+
+What:		/sys/bus/iio/devices/device[n]/als_time
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This property gets/sets the TAOS tsl258x ADC channel integration
+		time in 2.7ms increments.
+
+What:		/sys/bus/iio/devices/device[n]/als_trim
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This property gets/sets the TAOS tsl258x ADC active gain scale.
+		
+What:		/sys/bus/iio/devices/device[n]/als_target
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This property gets/sets the TAOS tsl258x ADC last known external
+		lux measurement used in calibration.
+		
+What:		/sys/bus/iio/devices/device[n]/lux
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This property gets the TAOS tsl258x calculated lux value.
+
+What:		/sys/bus/iio/devices/device[n]/lux_table
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This property gets/sets the TAOS tsl258x lux table of coefficients
+		that are used to calculate lux.
+		
+What:		/sys/bus/iio/devices/device[n]/reg_offset
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This property gets/sets an index the TAOS tsl258x internel register
+		for r/w of selected register.
+		
+What:		/sys/bus/iio/devices/device[n]/reg_offset
+KernelVersion:	2.6.37
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This property gets/sets an TAOS tsl258x internel register value
+		indexed by reg_offset.
+
+
+		
\ No newline at end of file
diff --git a/drivers/staging/iio/light/Kconfig b/drivers/staging/iio/light/Kconfig
index 36d8bbe..ae499b8 100644
--- a/drivers/staging/iio/light/Kconfig
+++ b/drivers/staging/iio/light/Kconfig
@@ -13,6 +13,13 @@ config SENSORS_TSL2563
 	 This driver can also be built as a module.  If so, the module
 	 will be called tsl2563.
 
+config TAOS_258x
+	tristate "TAOS TSL258x device driver"
+	default m
+	help
+	  Provides support for the TAOS tsl258x family of devices.
+	  Access ALS data/control via sysfs/iio.
+
 config SENSORS_ISL29018
         tristate "ISL 29018 light and proximity sensor"
         depends on I2C
diff --git a/drivers/staging/iio/light/Makefile b/drivers/staging/iio/light/Makefile
index 9142c0e..4395db8 100644
--- a/drivers/staging/iio/light/Makefile
+++ b/drivers/staging/iio/light/Makefile
@@ -3,4 +3,5 @@
 #
 
 obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
+obj-$(CONFIG_TAOS_258x)	+= tsl258x.o
 obj-$(CONFIG_SENSORS_ISL29018)	+= isl29018.o
diff --git a/drivers/staging/iio/light/tsl258x.c b/drivers/staging/iio/light/tsl258x.c
new file mode 100644
index 0000000..225d85b
--- /dev/null
+++ b/drivers/staging/iio/light/tsl258x.c
@@ -0,0 +1,1010 @@
+/*
+ * Device driver for monitoring ambient light intensity (lux)
+ * within the TAOS tsl258x family of devices
+ *
+ * Copyright (c) 2011, TAOS Corporation.
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
+ * 51 Franklin Street, Fifth Floor, Boston, MA	02110-1301, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/i2c.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/string.h>
+#include <linux/mutex.h>
+#include "../iio.h"
+
+#define DEVICE_ID			"tsl258x"
+
+#define MAX_DEVICE_REGS		32
+
+/* Triton register offsets */
+#define	TAOS_REG_MAX		8
+
+/* Device Registers and Masks */
+#define TSL258X_CNTRL			0x00
+#define TSL258X_STATUS			0x00
+#define TSL258X_ALS_TIME		0X01
+#define TSL258X_INTERRUPT		0x02
+#define TSL258X_GAIN			0x07
+#define TSL258X_REVID			0x11
+#define TSL258X_CHIPID			0x12
+#define TSL258X_SMB_4			0x13
+#define TSL258X_ALS_CHAN0LO		0x14
+#define TSL258X_ALS_CHAN0HI		0x15
+#define TSL258X_ALS_CHAN1LO		0x16
+#define TSL258X_ALS_CHAN1HI		0x17
+#define TSL258X_TMR_LO			0x18
+#define TSL258X_TMR_HI			0x19
+
+/* Skate cmd reg masks */
+#define TSL258X_CMD_REG		0x80
+#define TSL258X_CMD_BYTE_RW		0x00
+#define TSL258X_CMD_WORD_BLK_RW	0x20
+#define TSL258X_CMD_SPL_FN		0x60
+#define TSL258X_CMD_ALS_INTCLR		0X01
+
+/* Skate cntrl reg masks */
+#define TSL258X_CNTL_REG_CLEAR		0x00
+#define TSL258X_CNTL_ALS_INT_ENBL	0x10
+#define TSL258X_CNTL_WAIT_TMR_ENBL	0x08
+#define TSL258X_CNTL_ADC_ENBL		0x02
+#define TSL258X_CNTL_PWRON		0x01
+#define TSL258X_CNTL_ALSPON_ENBL	0x03
+#define TSL258X_CNTL_INTALSPON_ENBL	0x13
+
+/* Skate status reg masks */
+#define TSL258X_STA_ADCVALID		0x01
+#define TSL258X_STA_ALSINTR		0x10
+#define TSL258X_STA_ADCINTR		0x10
+
+/* Lux constants */
+#define	MAX_LUX			65535
+
+enum {
+	TAOS_CHIP_UNKNOWN = 0, TAOS_CHIP_WORKING = 1, TAOS_CHIP_SLEEP = 2
+} TAOS_CHIP_WORKING_STATUS;
+
+/* Per-device data */
+struct taos_als_info {
+	u16 als_ch0;
+	u16 als_ch1;
+	u16 lux;
+};
+
+struct taos_settings {
+	int als_time;
+	int als_gain;
+	int als_gain_trim;
+	int als_cal_target;
+};
+
+struct tsl258x_chip {
+	struct mutex als_mutex;
+	struct i2c_client *client;
+	struct iio_dev *iio_dev;
+	struct delayed_work update_lux;
+	unsigned int addr;
+	char taos_id;
+	char valid;
+	unsigned long last_updated;
+	struct taos_als_info als_cur_info;
+	struct taos_settings taos_settings;
+	int als_time_scale;
+	int als_saturation;
+	int taos_chip_status;
+	u8 taos_config[8];
+};
+
+static int taos_i2c_read(struct i2c_client *client, u8 reg, u8 *val,
+	unsigned int len);
+static int taos_i2c_write_command(struct i2c_client *client, u8 reg);
+
+/*
+ * Initial values for device - this values can/will be changed by driver.
+ * and applications as needed.
+ * These values are dynamic.
+ */
+static const u8 taos_config[8] = {
+		0x00, 0xee, 0x00, 0x03, 0x00, 0xFF, 0xFF, 0x00
+}; /*	cntrl atime intC  Athl0 Athl1 Athh0 Athh1 gain */
+
+struct taos_lux {
+	unsigned int ratio;
+	unsigned int ch0;
+	unsigned int ch1;
+};
+
+/* This structure is intentionally large to accommodate updates via sysfs. */
+/* Sized to 11 = max 10 segments + 1 termination segment */
+struct taos_lux taos_device_lux[11] = {
+	{  9830,  8520, 15729 },
+	{ 12452, 10807, 23344 },
+	{ 14746,  6383, 11705 },
+	{ 17695,  4063,  6554 },
+};
+
+struct taos_lux taos_lux;
+
+struct gainadj {
+	s16 ch0;
+	s16 ch1;
+};
+
+/* Index = (0 - 3) Used to validate the gain selection index */
+static const struct gainadj gainadj[] = {
+	{ 1, 1 },
+	{ 8, 8 },
+	{ 16, 16 },
+	{ 107, 115 }
+};
+
+/*
+ * Provides initial operational parameter defaults.
+ * These defaults may be changed through the device's sysfs files.
+ */
+static void taos_defaults(struct tsl258x_chip *chip)
+{
+	/* Operational parameters */
+	chip->taos_settings.als_time = 450;
+	/* must be a multiple of 50mS */
+	chip->taos_settings.als_gain = 2;
+	/* this is actually an index into the gain table */
+	/* assume clear glass as default */
+	chip->taos_settings.als_gain_trim = 1000;
+	/* default gain trim to account for aperture effects */
+	chip->taos_settings.als_cal_target = 130;
+	/* Known external ALS reading used for calibration */
+
+	/* Initialize ALS data to defaults */
+	chip->als_cur_info.als_ch0 = 0;
+	chip->als_cur_info.als_ch1 = 0;
+	chip->als_cur_info.lux = 0;
+}
+
+/*
+ * Read a number of bytes starting at register (reg) location.
+ * Return 0, or i2c_smbus_write_byte ERROR code.
+ */
+static int
+taos_i2c_read(struct i2c_client *client, u8 reg, u8 *val, unsigned int len)
+{
+	int ret;
+	int i;
+
+	for (i = 0; i < len; i++) {
+		/* select register to write */
+		ret = i2c_smbus_write_byte(client, (TSL258X_CMD_REG | reg));
+		if (ret < 0) {
+			dev_err(&client->dev, "taos_i2c_read failed to write"
+				" register %x\n", reg);
+			return ret;
+		}
+		/* read the data */
+		*val = i2c_smbus_read_byte(client);
+		val++;
+		if ((reg & 0x1f) == 0x1f)
+			break;
+		reg++;
+	}
+	return 0;
+}
+
+/*
+ * This function is used to send a command to device command/control register
+ * All bytes sent using this command have their MSBit set - it's a command!
+ * Return 0, or i2c_smbus_write_byte error code.
+ */
+static int taos_i2c_write_command(struct i2c_client *client, u8 reg)
+{
+	int ret;
+
+	/* write the data */
+	ret = i2c_smbus_write_byte(client, (reg |= TSL258X_CMD_REG));
+	if (ret < 0) {
+		dev_err(&client->dev, "FAILED: i2c_smbus_write_byte\n");
+		return ret;
+	}
+	return 0;
+}
+
+/*
+ * Reads and calculates current lux value.
+ * The raw ch0 and ch1 values of the ambient light sensed in the last
+ * integration cycle are read from the device.
+ * Time scale factor array values are adjusted based on the integration time.
+ * The raw values are multiplied by a scale factor, and device gain is obtained
+ * using gain index. Limit checks are done next, then the ratio of a multiple
+ * of ch1 value, to the ch0 value, is calculated. The array taos_device_lux[]
+ * declared above is then scanned to find the first ratio value that is just
+ * above the ratio we just calculated. The ch0 and ch1 multiplier constants in
+ * the array are then used along with the time scale factor array values, to
+ * calculate the lux.
+ */
+static int taos_get_lux(struct i2c_client *client)
+{
+	u32 ch0, ch1; /* separated ch0/ch1 data from device */
+	u32 lux; /* raw lux calculated from device data */
+	u32 ratio;
+	u8 buf[5];
+	struct taos_lux *p;
+	struct tsl258x_chip *chip = i2c_get_clientdata(client);
+	int i, ret;
+	u32 ch0lux = 0;
+	u32 ch1lux = 0;
+
+	if (mutex_trylock(&chip->als_mutex) == 0) {
+		dev_info(&client->dev, "taos_get_lux device is busy\n");
+		return chip->als_cur_info.lux; /* busy, so return LAST VALUE */
+	}
+
+	if (chip->taos_chip_status != TAOS_CHIP_WORKING) {
+		/* device is not enabled */
+		dev_err(&client->dev, "taos_get_lux device is not enabled\n");
+		ret = -ENODEV;
+		goto out_unlock;
+	}
+
+	ret = taos_i2c_read(client, (TSL258X_CMD_REG), &buf[0], 1);
+	if (ret < 0) {
+		dev_err(&client->dev, "taos_get_lux failed to read CMD_REG\n");
+		goto out_unlock;
+	}
+	/* is data new & valid */
+	if (!(buf[0] & TSL258X_STA_ADCINTR)) {
+		dev_err(&client->dev, "taos_get_lux data not valid\n");
+		ret = chip->als_cur_info.lux; /* return LAST VALUE */
+		goto out_unlock;
+	}
+
+	for (i = 0; i < 4; i++) {
+		int reg = TSL258X_CMD_REG | (TSL258X_ALS_CHAN0LO + i);
+		ret = taos_i2c_read(client, reg, &buf[i], 1);
+		if (ret < 0) {
+			dev_err(&client->dev, "taos_get_lux failed to read"
+				" register %x\n", reg);
+			goto out_unlock;
+		}
+	}
+
+	/* clear status, really interrupt status (interrupts are off), but
+	 * we use the bit anyway */
+	ret = taos_i2c_write_command(client,
+		TSL258X_CMD_REG | TSL258X_CMD_SPL_FN | TSL258X_CMD_ALS_INTCLR);
+	if (ret < 0) {
+		dev_err(&client->dev,
+		"taos_i2c_write_command failed in "
+		"taos_get_lux, err = %d\n", ret);
+		goto out_unlock; /* have no data, so return failure */
+	}
+
+	/* extract ALS/lux data */
+	ch0 = (buf[1] << 8) | buf[0];
+	ch1 = (buf[3] << 8) | buf[2];
+
+	chip->als_cur_info.als_ch0 = ch0;
+	chip->als_cur_info.als_ch1 = ch1;
+
+	if ((ch0 >= chip->als_saturation) || (ch1 >= chip->als_saturation))
+		goto return_max;
+
+	if (ch0 == 0) {
+		/* have no data, so return LAST VALUE */
+		ret = chip->als_cur_info.lux = 0;
+		goto out_unlock;
+	}
+	/* calculate ratio */
+	ratio = (ch1 << 15) / ch0;
+	/* convert to unscaled lux using the pointer to the table */
+	for (p = (struct taos_lux *) taos_device_lux;
+	     p->ratio != 0 && p->ratio < ratio; p++)
+		;
+
+	if (p->ratio == 0) {
+		lux = 0;
+	} else {
+		ch0lux = ((ch0 * p->ch0) +
+			  (gainadj[chip->taos_settings.als_gain].ch0 >> 1))
+			 / gainadj[chip->taos_settings.als_gain].ch0;
+		ch1lux = ((ch1 * p->ch1) +
+			  (gainadj[chip->taos_settings.als_gain].ch1 >> 1))
+			 / gainadj[chip->taos_settings.als_gain].ch1;
+		lux = ch0lux - ch1lux;
+	}
+
+	/* note: lux is 31 bit max at this point */
+	if (ch1lux > ch0lux) {
+		dev_dbg(&client->dev, "No Data - Return last value\n");
+		ret = chip->als_cur_info.lux = 0;
+		goto out_unlock;
+	}
+
+	/* adjust for active time scale */
+	if (chip->als_time_scale == 0)
+		lux = 0;
+	else
+		lux = (lux + (chip->als_time_scale >> 1)) /
+			chip->als_time_scale;
+
+	/* adjust for active gain scale */
+	lux >>= 13; /* tables have factor of 8192 builtin for accuracy */
+	lux = (lux * chip->taos_settings.als_gain_trim + 500) / 1000;
+	if (lux > MAX_LUX) { /* check for overflow */
+return_max:
+		lux = MAX_LUX;
+	}
+
+	/* Update the structure with the latest VALID lux. */
+	chip->als_cur_info.lux = lux;
+	ret = lux;
+
+out_unlock:
+	mutex_unlock(&chip->als_mutex);
+	return ret;
+}
+
+/*
+ * Obtain single reading and calculate the als_gain_trim (later used
+ * to derive actual lux).
+ * Return updated gain_trim value.
+ */
+int taos_als_calibrate(struct i2c_client *client)
+{
+	struct tsl258x_chip *chip = i2c_get_clientdata(client);
+	u8 reg_val;
+	unsigned int gain_trim_val;
+	int ret;
+	int lux_val;
+
+	ret = i2c_smbus_write_byte(client, (TSL258X_CMD_REG | TSL258X_CNTRL));
+	if (ret < 0) {
+		dev_err(&client->dev, "taos_als_calibrate failed to reach the"
+			" CNTRL register, ret=%d\n", ret);
+		return ret;
+	}
+
+	reg_val = i2c_smbus_read_byte(client);
+	if ((reg_val & (TSL258X_CNTL_ADC_ENBL | TSL258X_CNTL_PWRON))
+			!= (TSL258X_CNTL_ADC_ENBL | TSL258X_CNTL_PWRON)) {
+		dev_err(&client->dev, "taos_als_calibrate failed because the"
+			" device is not powered on with ADC enabled\n");
+		return -ENODATA;
+	}
+
+	ret = i2c_smbus_write_byte(client, (TSL258X_CMD_REG | TSL258X_STATUS));
+	if (ret < 0) {
+		dev_err(&client->dev, "taos_als_calibrate failed to reach the"
+			" STATUS register, ret=%d\n", ret);
+		return ret;
+	}
+	reg_val = i2c_smbus_read_byte(client);
+
+	if ((reg_val & TSL258X_STA_ADCVALID) != TSL258X_STA_ADCVALID) {
+		dev_err(&client->dev, "taos_als_calibrate failed because the"
+			" STATUS did not indicate ADC valid.\n");
+		return -ENODATA;
+	}
+	lux_val = taos_get_lux(client);
+	if (lux_val < 0) {
+		dev_err(&client->dev, "taos_als_calibrate failed to get lux\n");
+		return lux_val;
+	}
+	gain_trim_val = (unsigned int) (((chip->taos_settings.als_cal_target)
+			* chip->taos_settings.als_gain_trim) / lux_val);
+
+	dev_info(&client->dev, "taos_settings.als_cal_target = %d\n"
+		"taos_settings.als_gain_trim = %d\nlux_val = %d\n",
+		chip->taos_settings.als_cal_target,
+		chip->taos_settings.als_gain_trim,
+		lux_val);
+
+	if ((gain_trim_val < 250) || (gain_trim_val > 4000)) {
+		dev_err(&client->dev, "taos_als_calibrate failed because"
+			"trim_val of %d is out of range\n", gain_trim_val);
+		return -ENODATA;
+	}
+	chip->taos_settings.als_gain_trim = (int) gain_trim_val;
+
+	return (int) gain_trim_val;
+}
+
+/*
+ * Turn the device on.
+ * Configuration must be set before calling this function.
+ */
+static int taos_chip_on(struct i2c_client *client)
+{
+	int i;
+	int ret = 0;
+	u8 *uP;
+	u8 utmp;
+	int als_count;
+	int als_time;
+	struct tsl258x_chip *chip = i2c_get_clientdata(client);
+
+	/* and make sure we're not already on */
+	if (chip->taos_chip_status == TAOS_CHIP_WORKING) {
+		/* if forcing a register update - turn off, then on */
+		dev_info(&client->dev, "device is already enabled\n");
+		return -1;
+	}
+
+	/* determine als integration regster */
+	als_count = (chip->taos_settings.als_time * 100 + 135) / 270;
+	if (als_count == 0)
+		als_count = 1; /* ensure at least one cycle */
+
+
+	/* convert back to time (encompasses overrides) */
+	als_time = (als_count * 27 + 5) / 10;
+	chip->taos_config[TSL258X_ALS_TIME] = 256 - als_count;
+
+
+	/* Set the gain based on taos_settings struct */
+	chip->taos_config[TSL258X_GAIN] = chip->taos_settings.als_gain;
+
+
+	/* set globals re scaling and saturation */
+	chip->als_saturation = als_count * 922; /* 90% of full scale */
+	chip->als_time_scale = (als_time + 25) / 50;
+
+	/* SKATE Specific power-on / adc enable sequence
+	 * Power on the device 1st. */
+	utmp = TSL258X_CNTL_PWRON;
+	ret = i2c_smbus_write_byte_data(client, TSL258X_CMD_REG | TSL258X_CNTRL,
+					utmp);
+	if (ret < 0) {
+		dev_err(&client->dev, "taos_chip_on failed on CNTRL reg.\n");
+		return -1;
+	}
+
+	/* Use the following shadow copy for our delay before enabling ADC.
+	 * Write all the registers. */
+	for (i = 0, uP = chip->taos_config; i < TAOS_REG_MAX; i++) {
+		ret = i2c_smbus_write_byte_data(client, TSL258X_CMD_REG + i,
+						*uP++);
+		if (ret < 0) {
+			dev_err(&client->dev,
+				"taos_chip_on failed on reg %d.\n", i);
+			return -1;
+		}
+	}
+
+	mdelay(3);
+	/* NOW enable the ADC
+	 * initialize the desired mode of operation */
+	utmp = TSL258X_CNTL_PWRON | TSL258X_CNTL_ADC_ENBL;
+	ret = i2c_smbus_write_byte_data(client, TSL258X_CMD_REG | TSL258X_CNTRL,
+					utmp);
+	if (ret < 0) {
+		dev_err(&client->dev, "taos_chip_on failed on 2nd CTRL reg.\n");
+		return -1;
+	}
+	chip->taos_chip_status = TAOS_CHIP_WORKING;
+	return ret; /* returns result of last i2cwrite */
+}
+
+/* Turn the device OFF. */
+static int taos_chip_off(struct i2c_client *client)
+{
+	struct tsl258x_chip *chip = i2c_get_clientdata(client);
+	int ret;
+	u8 utmp;
+
+	/* turn device off */
+	chip->taos_chip_status = TAOS_CHIP_SLEEP;
+	utmp = 0x00;
+	ret = i2c_smbus_write_byte_data(client, TSL258X_CMD_REG | TSL258X_CNTRL,
+					utmp);
+	return ret;
+}
+
+/* Sysfs Interface Functions */
+static ssize_t taos_device_id(struct device *dev,
+    struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n", DEVICE_ID);
+}
+
+static ssize_t taos_power_state_show(struct device *dev,
+    struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl258x_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%d\n", chip->taos_chip_status);
+}
+
+static ssize_t taos_power_state_store(struct device *dev,
+    struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl258x_chip *chip = indio_dev->dev_data;
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if (value == 0)
+		taos_chip_off(chip->client);
+	else
+		taos_chip_on(chip->client);
+
+	return len;
+}
+
+static ssize_t taos_gain_show(struct device *dev,
+    struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl258x_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%d\n", chip->taos_settings.als_gain);
+}
+
+static ssize_t taos_gain_store(struct device *dev,
+    struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl258x_chip *chip = indio_dev->dev_data;
+	unsigned long value;
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+	if (value) {
+		if (value > 4) {
+			dev_err(dev, "Invalid Gain Index\n");
+			return -1;
+		} else {
+			chip->taos_settings.als_gain = value;
+		}
+	}
+	return len;
+}
+
+static ssize_t taos_als_time_show(struct device *dev,
+    struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl258x_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%d\n", chip->taos_settings.als_time);
+}
+
+static ssize_t taos_als_time_store(struct device *dev,
+    struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl258x_chip *chip = indio_dev->dev_data;
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if (value)
+		chip->taos_settings.als_time = value;
+
+	return len;
+}
+
+static ssize_t taos_als_trim_show(struct device *dev,
+    struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl258x_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%d\n", chip->taos_settings.als_gain_trim);
+}
+
+static ssize_t taos_als_trim_store(struct device *dev,
+    struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl258x_chip *chip = indio_dev->dev_data;
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if (value)
+		chip->taos_settings.als_gain_trim = value;
+
+	return len;
+}
+
+static ssize_t taos_als_cal_target_show(struct device *dev,
+    struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl258x_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%d\n", chip->taos_settings.als_cal_target);
+}
+
+static ssize_t taos_als_cal_target_store(struct device *dev,
+    struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl258x_chip *chip = indio_dev->dev_data;
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if (value)
+		chip->taos_settings.als_cal_target = value;
+
+	return len;
+}
+
+static ssize_t taos_lux_show(struct device *dev, struct device_attribute *attr,
+    char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl258x_chip *chip = indio_dev->dev_data;
+	int lux = 0;
+
+	lux = taos_get_lux(chip->client);
+
+	return sprintf(buf, "%d\n", lux);
+}
+
+static ssize_t taos_do_calibrate(struct device *dev,
+    struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl258x_chip *chip = indio_dev->dev_data;
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if (value == 1)
+		taos_als_calibrate(chip->client);
+
+	return len;
+}
+
+static ssize_t taos_luxtable_show(struct device *dev,
+    struct device_attribute *attr, char *buf)
+{
+	int i;
+	int offset = 0;
+
+	for (i = 0; i < ARRAY_SIZE(taos_device_lux); i++) {
+		offset += sprintf(buf + offset, "%d,%d,%d,",
+				  taos_device_lux[i].ratio,
+				  taos_device_lux[i].ch0,
+				  taos_device_lux[i].ch1);
+		if (taos_device_lux[i].ratio == 0) {
+			/* We just printed the first "0" entry.
+			 * Now get rid of the extra "," and break. */
+			offset--;
+			break;
+		}
+	}
+
+	offset += sprintf(buf + offset, "\n");
+	return offset;
+}
+
+static ssize_t taos_luxtable_store(struct device *dev,
+    struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl258x_chip *chip = indio_dev->dev_data;
+#define MAX_LUX_TABLE_FIELDS 33
+	int value[MAX_LUX_TABLE_FIELDS];
+	int n;
+
+	get_options(buf, ARRAY_SIZE(value), value);
+
+	/* We now have an array of ints starting at value[1], and
+	 * enumerated by value[0].
+	 * We expect each group of three ints is one table entry,
+	 * and the last table entry is all 0.
+	 */
+	n = value[0];
+	if ((n % 3) || n < 6 || n > (MAX_LUX_TABLE_FIELDS - 3)) {
+		dev_info(dev, "LUX TABLE INPUT ERROR 1 Value[0]=%d\n", n);
+		return -EINVAL;
+	}
+	if ((value[(n - 2)] | value[(n - 1)] | value[n]) != 0) {
+		dev_info(dev, "LUX TABLE INPUT ERROR 2 Value[0]=%d\n", n);
+		return -EINVAL;
+	}
+
+	if (chip->taos_chip_status == TAOS_CHIP_WORKING)
+		taos_chip_off(chip->client);
+
+	/* Zero out the table */
+	memset(taos_device_lux, 0, sizeof(taos_device_lux));
+	memcpy(taos_device_lux, &value[1], (value[0] * 4));
+
+	taos_chip_on(chip->client);
+
+	return len;
+}
+
+static u8 reg_index;
+
+/* Sets a pointer to a register for R/W via sysfs */
+static ssize_t taos_reg_offset_show(struct device *dev,
+    struct device_attribute *attr, char *buf)
+{
+      return sprintf(buf, "%d\n", reg_index);
+      return 0;
+}
+
+static ssize_t taos_reg_offset_store(struct device *dev,
+    struct device_attribute *attr, const char *buf, size_t len)
+{
+	unsigned long value;
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if (value > MAX_DEVICE_REGS) {
+		dev_err(dev, "register offset exceeds MAX\n");
+		return -1;
+	} else {
+		reg_index = value;
+	}
+return len;
+}
+
+/* R/W a register for R/W via sysfs */
+static ssize_t taos_reg_show(struct device *dev,
+    struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl258x_chip *chip = indio_dev->dev_data;
+
+	u8 value = 0;
+	int ret = 0;
+
+	ret = i2c_smbus_write_byte(chip->client,
+		(TSL258X_CMD_REG | reg_index));
+	if (ret < 0) {
+		dev_err(dev, "i2c_smbus_write_byte to cmd reg failed "
+			"in taos_reg_offset_show(), err = %d\n", ret);
+		return ret;
+	}
+	value = i2c_smbus_read_byte(chip->client);
+	return sprintf(buf, "%d\n", value);
+
+return 0;
+}
+
+static ssize_t taos_reg_store(struct device *dev,
+    struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl258x_chip *chip = indio_dev->dev_data;
+
+	unsigned long value = 0;
+	int ret = 0;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	ret = i2c_smbus_write_byte_data(chip->client,
+		(TSL258X_CMD_REG | reg_index), value);
+	if (ret < 0) {
+		dev_err(dev, "i2c_smbus_write_byte_data failed in "
+			"taos_reg_store()\n");
+		return ret;
+	}
+
+return len;
+}
+
+static DEVICE_ATTR(name, S_IRUGO, taos_device_id, NULL);
+static DEVICE_ATTR(device_state, S_IRUGO | S_IWUSR,
+		taos_power_state_show, taos_power_state_store);
+static DEVICE_ATTR(als_gain, S_IRUGO | S_IWUSR,
+		taos_gain_show, taos_gain_store);
+static DEVICE_ATTR(als_time, S_IRUGO | S_IWUSR,
+		taos_als_time_show, taos_als_time_store);
+static DEVICE_ATTR(als_trim, S_IRUGO | S_IWUSR,
+		taos_als_trim_show, taos_als_trim_store);
+static DEVICE_ATTR(als_target, S_IRUGO | S_IWUSR,
+		taos_als_cal_target_show, taos_als_cal_target_store);
+static DEVICE_ATTR(lux, S_IRUGO, taos_lux_show, NULL);
+static DEVICE_ATTR(calibrate, S_IWUSR, NULL, taos_do_calibrate);
+static DEVICE_ATTR(lux_table, S_IRUGO | S_IWUSR,
+		taos_luxtable_show, taos_luxtable_store);
+static DEVICE_ATTR(reg_offset, S_IRUGO | S_IWUSR,
+      taos_reg_offset_show,
+      taos_reg_offset_store);
+static DEVICE_ATTR(reg, S_IRUGO | S_IWUSR,
+      taos_reg_show,
+      taos_reg_store);
+
+
+static struct attribute *sysfs_attrs_ctrl[] = {
+	&dev_attr_name.attr,
+	&dev_attr_device_state.attr,
+	&dev_attr_als_gain.attr,
+	&dev_attr_als_time.attr,
+	&dev_attr_als_trim.attr,
+	&dev_attr_als_target.attr,
+	&dev_attr_lux.attr,
+	&dev_attr_calibrate.attr,
+	&dev_attr_lux_table.attr,
+    &dev_attr_reg_offset.attr,
+    &dev_attr_reg.attr,
+	NULL
+};
+
+static struct attribute_group tsl258x_attribute_group = {
+	.attrs = sysfs_attrs_ctrl,
+};
+
+/* Use the default register values to identify the Taos device */
+static int taos_skate_device(unsigned char *bufp)
+{
+	if (((bufp[TSL258X_CHIPID] & 0xf0) == 0x90))
+		/* tsl258x */
+		return 1;
+	/* else unknown */
+	return 0;
+}
+
+/*
+ * Client probe function - When a valid device is found, the driver's device
+ * data structure is updated, and initialization completes successfully.
+ */
+static int __devinit taos_probe(struct i2c_client *clientp,
+		      const struct i2c_device_id *idp)
+{
+	int i, ret = 0;
+	unsigned char buf[MAX_DEVICE_REGS];
+	static struct tsl258x_chip *chip;
+
+	if (!i2c_check_functionality(clientp->adapter,
+		I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_err(&clientp->dev,
+			"taos_probe() - i2c smbus byte data "
+			"functions unsupported\n");
+		return -EOPNOTSUPP;
+	}
+	if (!i2c_check_functionality(clientp->adapter,
+		I2C_FUNC_SMBUS_WORD_DATA)) {
+		dev_warn(&clientp->dev,
+			"taos_probe() - i2c smbus word data "
+			"functions unsupported\n");
+	}
+	if (!i2c_check_functionality(clientp->adapter,
+		I2C_FUNC_SMBUS_BLOCK_DATA)) {
+		dev_err(&clientp->dev,
+			"taos_probe() - i2c smbus block data "
+			"functions unsupported\n");
+	}
+
+	chip = kmalloc(sizeof(struct tsl258x_chip), GFP_KERNEL);
+	if (!chip) {
+		dev_err(&clientp->dev, "taos_device_drvr: kmalloc for "
+			"struct tsl258x_chip failed in taos_probe()\n");
+		return -ENOMEM;
+	}
+	memset(chip, 0, sizeof(struct tsl258x_chip));
+	chip->client = clientp;
+	i2c_set_clientdata(clientp, chip);
+
+	mutex_init(&chip->als_mutex);
+	chip->taos_chip_status = TAOS_CHIP_UNKNOWN; /* uninitialized to start */
+	memcpy(chip->taos_config, taos_config, sizeof(chip->taos_config));
+
+	for (i = 0; i < MAX_DEVICE_REGS; i++) {
+		ret = i2c_smbus_write_byte(clientp,
+				(TSL258X_CMD_REG | (TSL258X_CNTRL + i)));
+		if (ret < 0) {
+			dev_err(&clientp->dev, "i2c_smbus_write_byte() to cmd "
+				"reg failed in taos_probe(), err = %d\n", ret);
+			goto fail1;
+		}
+		buf[i] = i2c_smbus_read_byte(clientp);
+	}
+	if (!taos_skate_device(buf)) {
+		dev_info(&clientp->dev, "i2c device found but does not match "
+			"expected id in taos_probe()\n");
+		goto fail1;
+	} else {
+		dev_info(&clientp->dev, "i2c device match in probe\n");
+	}
+	ret = i2c_smbus_write_byte(clientp, (TSL258X_CMD_REG | TSL258X_CNTRL));
+	if (ret < 0) {
+		dev_err(&clientp->dev, "i2c_smbus_write_byte() to cmd reg "
+			"failed in taos_probe(), err = %d\n", ret);
+		goto fail1;
+	}
+	chip->valid = 0;
+
+	chip->iio_dev = iio_allocate_device();
+	if (!chip->iio_dev) {
+		ret = -ENOMEM;
+		dev_err(&clientp->dev, "iio allocation failed\n");
+		goto fail1;
+	}
+
+	chip->iio_dev->attrs = &tsl258x_attribute_group;
+	chip->iio_dev->dev.parent = &clientp->dev;
+	chip->iio_dev->dev_data = (void *)(chip);
+	chip->iio_dev->driver_module = THIS_MODULE;
+	chip->iio_dev->modes = INDIO_DIRECT_MODE;
+	ret = iio_device_register(chip->iio_dev);
+	if (ret) {
+		dev_err(&clientp->dev, "iio registration failed\n");
+		goto fail1;
+	}
+
+	/* Load up the V2 defaults (these are hard coded defaults for now) */
+	taos_defaults(chip);
+
+	/* Make sure the chip is on */
+	taos_chip_on(clientp);
+
+	dev_info(&clientp->dev, "Light sensor found.\n");
+	return 0;
+
+fail1:
+	kfree(chip);
+
+	return ret;
+}
+
+static int __devexit taos_remove(struct i2c_client *client)
+{
+	struct tsl258x_chip *chip = i2c_get_clientdata(client);
+
+	iio_device_unregister(chip->iio_dev);
+
+	kfree(chip);
+	return 0;
+}
+
+static struct i2c_device_id taos_idtable[] = {
+	{ DEVICE_ID, 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, taos_idtable);
+
+/* Driver definition */
+static struct i2c_driver taos_driver = {
+	.driver = {
+		.name = "tsl258x",
+	},
+	.id_table = taos_idtable,
+	.probe = taos_probe,
+	.remove = __devexit_p(taos_remove),
+};
+
+static int __init taos_init(void)
+{
+	return i2c_add_driver(&taos_driver);
+}
+
+static void __exit taos_exit(void)
+{
+	i2c_del_driver(&taos_driver);
+}
+
+module_init(taos_init);
+module_exit(taos_exit);
+
+MODULE_AUTHOR("J. August Brenner<jbrenner@taosinc.com>");
+MODULE_DESCRIPTION("TAOS tsl258x ambient light sensor driver");
+MODULE_LICENSE("GPL");
+
-- 
1.7.0.4


