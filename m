Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab1DUV3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:29:37 -0400
Received: from 90-46-11-204.rar.beartech.net ([204.11.46.90]:38669 "EHLO
	exchsrvr.taosinc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754195Ab1DUV3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:29:36 -0400
Subject: [PATCH v2]TAOS 2571 Device Driver
From: Jon Brenner <jbrenner@taosinc.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-iio <linux-iio@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Apr 2011 16:29:35 -0500
Message-ID: <1303421375.21291.8.camel@jonz-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH v2] for TAOS tsl2571 Device driver 

Patch for tsl2571 driver.  
Driver includes (iio_event/interrupt).
Corrected various functions to return proper status (vs eating status).
Corrected various formatting issues.
Changed term in lux calculation from 2^13 to 2^8 to accommodate updated lux table (glass coefficients).
Updated default lux table (clear glass).
   
Signed-off-by: Jon August Brenner <jbrenner@taosinc.com>

---
 drivers/staging/iio/light/Kconfig   |   10 +
 drivers/staging/iio/light/Makefile  |    1 +
 drivers/staging/iio/light/tsl2571.c | 1362 +++++++++++++++++++++++++++++++++++
 3 files changed, 1373 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/light/Kconfig b/drivers/staging/iio/light/Kconfig
index 36d8bbe..7f9897c 100644
--- a/drivers/staging/iio/light/Kconfig
+++ b/drivers/staging/iio/light/Kconfig
@@ -24,3 +24,13 @@ config SENSORS_ISL29018
          in lux, proximity infrared sensing and normal infrared sensing.
          Data from sensor is accessible via sysfs.

+config SENSORS_TSL2571
+	tristate "TAOS TSL2571 ambient light sensor"
+	depends on I2C
+	help
+	 If you say yes here you get support for the TAOS TSL2571,
+	 ambient light sensor with interrupt.
+
+	 This driver can also be built as a module.  If so, the module
+	 will be called tsl2571.
+
diff --git a/drivers/staging/iio/light/Makefile b/drivers/staging/iio/light/Makefile
index 9142c0e..fa08012 100644
--- a/drivers/staging/iio/light/Makefile
+++ b/drivers/staging/iio/light/Makefile
@@ -4,3 +4,4 @@

 obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
 obj-$(CONFIG_SENSORS_ISL29018)	+= isl29018.o
+obj-$(CONFIG_SENSORS_TSL2571)	+= tsl2571.o
diff --git a/drivers/staging/iio/light/tsl2571.c b/drivers/staging/iio/light/tsl2571.c
new file mode 100644
index 0000000..1c28dca
--- /dev/null
+++ b/drivers/staging/iio/light/tsl2571.c
@@ -0,0 +1,1362 @@
+/*
+ * Device driver for monitoring ambient light intensity (lux)
+ * for the TAOS TSL257X devices (w/ interrupt iio_event functionality).
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
+#include <linux/unistd.h>
+#include <linux/interrupt.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+#include "../iio.h"
+#include "../sysfs.h"
+
+/* 2571 register offsets */
+#define TSL257X_MAX_DEVICE_REGS	32
+#define	TSL257X_REG_MAX		16
+
+/* Device Registers and Masks */
+#define TSL257X_CNTRL			0x00
+#define TSL257X_ALS_TIME		0X01
+
+#define TSL257X_ALS_MINTHRESHLO	0X04
+#define TSL257X_ALS_MINTHRESHHI	0X05
+#define TSL257X_ALS_MAXTHRESHLO	0X06
+#define TSL257X_ALS_MAXTHRESHHI	0X07
+
+#define TSL257X_PERSISTENCE		0x0c
+#define TSL257X_GAIN			0x0f
+#define	TSL257X_STATUS			0x13
+#define TSL257X_REVID			0x11
+#define TSL257X_CHIPID			0x12
+#define TSL257X_ALS_CHAN0LO		0x14
+#define TSL257X_ALS_CHAN0HI		0x15
+#define TSL257X_ALS_CHAN1LO		0x16
+#define TSL257X_ALS_CHAN1HI		0x17
+
+/* tsl2571 cmd reg masks */
+#define TSL257X_CMD_REG			0x80
+#define TSL257X_CMD_SPL_FN		0x60
+#define TSL257X_CMD_ALS_INT_CLR	0x06
+
+/* tsl2571 cntrl reg masks */
+#define TSL257X_CNTL_ADC_ENBL	0x02
+#define TSL257X_CNTL_PWR_ON		0x01
+
+/* tsl2571 status reg masks */
+#define TSL257X_STA_ADC_VALID	0x01
+#define TSL257X_STA_ALS_INTR	0x10
+
+/* Triton cntrl reg masks */
+#define CNTL_REG_CLEAR			0x00
+#define CNTL_PROX_INT_ENBL		0X20
+#define CNTL_ALS_INT_ENBL		0X10
+#define TSL257X_CNTL_WAIT_TMR_ENBL	0X08
+#define CNTL_PROX_DET_ENBL		0X04
+#define CNTL_ADC_ENBL			0x02
+#define TSL257X_CNTL_PWRON		0x01
+#define CNTL_ALSPON_ENBL		0x03
+#define CNTL_INTALSPON_ENBL		0x13
+#define CNTL_PROXPON_ENBL		0x0F
+#define CNTL_INTPROXPON_ENBL	0x2F
+#define TSL257X_CMD_PROXALS_INTCLR	0X07
+
+/* Lux calculation constants */
+#define	TSL257X_LUX_CALC_OVER_FLOW	65535
+
+enum {
+	TSL257X_CHIP_UNKNOWN = 0,
+	TSL257X_CHIP_WORKING = 1,
+	TSL257X_CHIP_SUSPENDED = 2
+} TSL257X_CHIP_WORKING_STATUS;
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
+	u8  als_interrupt;
+	u8  als_persistence;
+	int als_thresh_low;
+	int als_thresh_high;
+};
+
+static const u8 persistence_available[] = {
+	0, 1, 2, 3, 5, 10, 15, 20,
+	25, 30, 35, 40, 45, 50, 55, 60
+};
+
+struct tsl2571_chip {
+	struct mutex als_mutex;
+	struct i2c_client *client;
+	struct iio_dev *iio_dev;
+	struct taos_als_info als_cur_info;
+	struct taos_settings taos_settings;
+	int als_time_scale;
+	int als_saturation;
+	int taos_chip_status;
+	u8 taos_config[TSL257X_REG_MAX];
+	bool init_done;
+	struct work_struct	work_thresh;
+	s64	event_timestamp;
+	unsigned int irq_no;
+};
+
+/*
+ * Initial values for device - this values can/will be changed by driver.
+ * and applications as needed.
+ * These values are dynamic.
+ */
+static u8 taos_config[] = {
+		0x00, 0xee, 0x00, 0xF5, 0x03, 0x00, 0x00, 0x01,
+	/*  Enabl atime N/A   wtime ThL0  ThL1  ThH0  ThH1 */
+		0x00, 0x00, 0x00, 0x00,	0x30, 0x00, 0x00, 0x00
+	/*  N/A   N/A   N/A   N/A   prst  wlong  N/A  gain */
+};
+
+struct taos_lux {
+	unsigned int ratio;
+	unsigned int ch0;
+	unsigned int ch1;
+};
+
+/* This structure is intentionally large to accommodate updates via sysfs. */
+/* Sized to 11 = max 10 segments + 1 termination segment */
+/* Assumption is one and only one type of glass used     */
+struct taos_lux taos_device_lux[11] = {
+	{ 14461,   611,  1211 },
+	{ 18540,   352,   623 },
+	{     0,     0,     0 },
+};
+
+struct gainadj {
+	s16 ch0;
+	s16 ch1;
+};
+
+/* Used to validate the gain selection index */
+static const struct gainadj tsl2571_gainadj[] = {
+	{ 1, 1 },
+	{ 8, 8 },
+	{ 16, 16 },
+	{ 120, 120 }
+};
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
+		ret = i2c_smbus_write_byte(client, (TSL257X_CMD_REG | reg));
+		if (ret < 0) {
+			dev_err(&client->dev, "taos_i2c_read failed to write"
+				" register %x\n", reg);
+			return ret;
+		}
+		/* read the data */
+		*val = i2c_smbus_read_byte(client);
+		val++;
+		reg++;
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
+	u16 ch0, ch1; /* separated ch0/ch1 data from device */
+	u32 lux; /* raw lux calculated from device data */
+	u32 ratio;
+#pragma pack(4)
+	u8 buf[4];
+
+	struct taos_lux *p;
+	struct tsl2571_chip *chip = i2c_get_clientdata(client);
+	int i, ret;
+	u32 ch0lux = 0;
+	u32 ch1lux = 0;
+
+	if (mutex_trylock(&chip->als_mutex) == 0) {
+		dev_info(&client->dev, "taos_get_lux device is busy\n");
+		return chip->als_cur_info.lux; /* busy, so return LAST VALUE */
+	}
+
+	if (chip->taos_chip_status != TSL257X_CHIP_WORKING) {
+		/* device is not enabled */
+		dev_err(&client->dev, "taos_get_lux device is not enabled\n");
+		ret = -EBUSY ;
+		goto out_unlock;
+	}
+
+	ret = taos_i2c_read(client, (TSL257X_CMD_REG | TSL257X_STATUS),
+		&buf[0], 1);
+	if (ret < 0) {
+		dev_err(&client->dev, "taos_get_lux failed to read CMD_REG\n");
+		goto out_unlock;
+	}
+	/* is data new & valid */
+	if (!(buf[0] & TSL257X_STA_ADC_VALID)) {
+		dev_err(&client->dev, "taos_get_lux data not valid\n");
+		ret = chip->als_cur_info.lux; /* return LAST VALUE */
+		goto out_unlock;
+	}
+
+	for (i = 0; i < 4; i++) {
+		ret = taos_i2c_read(client,
+		(TSL257X_CMD_REG | (TSL257X_ALS_CHAN0LO + i)), &buf[i], 1);
+		if (ret < 0) {
+			dev_err(&client->dev, "taos_get_lux failed to read"
+				" register %x\n",
+				TSL257X_CMD_REG | (TSL257X_ALS_CHAN0LO + i));
+			goto out_unlock;
+		}
+	}
+
+	/* clear status, really interrupt status (interrupts are off), but
+	we use the bit anyway */
+	ret = i2c_smbus_write_byte(client,
+	(TSL257X_CMD_REG | TSL257X_CMD_SPL_FN | TSL257X_CMD_ALS_INT_CLR));
+
+	if (ret < 0) {
+		dev_err(&client->dev,
+		"taos_i2c_write_command failed in taos_get_lux, err = %d\n",
+			ret);
+		goto out_unlock; /* have no data, so return failure */
+	}
+
+	/* extract ALS/lux data */
+	ch0 = le16_to_cpup((const __le16 *)&buf[0]);
+	ch1 = le16_to_cpup((const __le16 *)&buf[2]);
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
+		(tsl2571_gainadj[chip->taos_settings.als_gain].ch0 >> 1))
+		 / tsl2571_gainadj[chip->taos_settings.als_gain].ch0;
+		ch1lux = ((ch1 * p->ch1) +
+		(tsl2571_gainadj[chip->taos_settings.als_gain].ch1 >> 1))
+		 / tsl2571_gainadj[chip->taos_settings.als_gain].ch1;
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
+	lux >>= 8;  /* tables have factor of 256 built in for accuracy */
+
+	lux = (lux * chip->taos_settings.als_gain_trim + 500) / 1000;
+
+	if (lux > TSL257X_LUX_CALC_OVER_FLOW) { /* check for overflow */
+return_max:
+		lux = TSL257X_LUX_CALC_OVER_FLOW;
+	}
+
+	/* Update the structure with the latest VALID lux. */
+	chip->als_cur_info.lux = lux;
+	ret = lux;
+
+out_unlock:
+	mutex_unlock(&chip->als_mutex);
+	return ret;
+
+}
+
+/*
+ * Ambient light transition sense interrupt BH - called when the ambient
+ * light falls above or below a band of ambient light. A signal is issued to
+ * any waiting user mode threads, and the above band is adjusted up or down?
+ * The ALS interrupt filter is initially set to 0x00 when ALS_ON is called, to
+ * force the first interrupt, after which it is set to the configured value.
+ */
+void taos_als_interrupt_bh(struct work_struct *als)
+{
+int ret;
+int i;
+u8 als_int_thresh[4];
+u8 chdata[4];
+unsigned int raw_ch0, raw_ch1, cdelta;
+int value;
+
+struct tsl2571_chip *chip
+	= container_of(als,
+		struct tsl2571_chip, work_thresh);
+
+	value = i2c_smbus_read_byte_data(chip->client,
+		TSL257X_CMD_REG | TSL257X_STATUS);
+
+	/* post the event */
+	if (value & 0x10) {
+		iio_push_event(chip->iio_dev, 0,
+			       IIO_UNMOD_EVENT_CODE(IIO_EV_CLASS_LIGHT,
+						    0,
+						    IIO_EV_TYPE_THRESH,
+						    IIO_EV_DIR_EITHER),
+			       chip->event_timestamp);
+	}
+
+	taos_get_lux(chip->client);
+
+	/* Clear interrupt */
+	ret = i2c_smbus_write_byte(chip->client,
+	(TSL257X_CMD_REG | TSL257X_CMD_SPL_FN | TSL257X_CMD_PROXALS_INTCLR));
+	if (ret < 0)
+		dev_info(&chip->client->dev,
+		"i2c_write_command failed in taos_chip_on, err = %d\n", ret);
+
+	/* re-adjust our upper and lower thresholds */
+	raw_ch0 = chip->als_cur_info.als_ch0;
+	raw_ch1 = chip->als_cur_info.als_ch1;
+	if (raw_ch0 == 0) {
+		chip->taos_settings.als_thresh_low = 0;
+		chip->taos_settings.als_thresh_high = 1;
+	} else if (raw_ch0 < 10) {
+		chip->taos_settings.als_thresh_low = raw_ch0 - 1;
+		chip->taos_settings.als_thresh_high = raw_ch0;
+	} else {
+		cdelta = (raw_ch0 * 5) / 100;
+		chip->taos_settings.als_thresh_low = raw_ch0 - cdelta;
+		chip->taos_settings.als_thresh_high = raw_ch0 + cdelta;
+		if (chip->taos_settings.als_thresh_high > 0xFFFF)
+			chip->taos_settings.als_thresh_high = 0xFFFF;
+	}
+
+	als_int_thresh[0] = (chip->taos_settings.als_thresh_low) & 0xFF;
+	als_int_thresh[1] = (chip->taos_settings.als_thresh_low >> 8) & 0xFF;
+	als_int_thresh[2] = (chip->taos_settings.als_thresh_high) & 0xFF;
+	als_int_thresh[3] = (chip->taos_settings.als_thresh_high >> 8) & 0xFF;
+
+	for (i = 0; i < 4; i++) {
+		ret = i2c_smbus_write_byte_data(chip->client,
+			(TSL257X_CMD_REG | (TSL257X_ALS_MINTHRESHLO + i)),
+			als_int_thresh[i]);
+		if (ret < 0) {
+			dev_info(&chip->client->dev,
+			"FAILED: update the ALS LOW THRESH (B).\n");
+		}
+	}
+
+	if (!chip->init_done) {
+		/* Maintain the persistence value that was there
+		 * if there was one */
+		ret = taos_i2c_read(chip->client,
+			(TSL257X_CMD_REG | (TSL257X_PERSISTENCE)),
+			&chdata[0], 1);
+		if (ret < 0)
+			dev_info(&chip->client->dev,
+			"Failed to get the persistence register value\n");
+
+			chdata[0] = chip->taos_settings.als_persistence;
+
+		ret = i2c_smbus_write_byte_data(chip->client,
+			(TSL257X_CMD_REG | TSL257X_PERSISTENCE), chdata[0]);
+		if (ret < 0)
+			dev_info(&chip->client->dev,
+			"FAILED: taos_i2c_write to upersistence (B).\n");
+
+		ret = i2c_smbus_write_byte(chip->client,
+		TSL257X_CMD_REG | TSL257X_CMD_SPL_FN | TSL257X_CMD_ALS_INT_CLR);
+		if (ret < 0) {
+			dev_info(&chip->client->dev,
+			"i2c_write failed to clear ALS irq, err = %d\n", ret);
+		}
+
+		chip->init_done = 1;
+	}
+
+	enable_irq(chip->irq_no);
+
+return;
+}
+
+/*
+ * Provides initial operational parameter defaults.
+ * These defaults may be changed through the device's sysfs files.
+ */
+static void taos_defaults(struct tsl2571_chip *chip)
+{
+	/* Operational parameters */
+	chip->taos_settings.als_time = 200;
+	/* must be a multiple of 50mS */
+	chip->taos_settings.als_gain = 0;
+	/* this is actually an index into the gain table */
+	/* assume clear glass as default */
+	chip->taos_settings.als_gain_trim = 1000;
+	/* default gain trim to account for aperture effects */
+	chip->taos_settings.als_cal_target = 130;
+	/* Known external ALS reading used for calibration */
+	chip->taos_settings.als_thresh_low = 03;
+	/* CH0 'low' count to trigger interrupt */
+	chip->taos_settings.als_thresh_high = 256;
+	/* CH0 'high' count to trigger interrupt */
+	chip->taos_settings.als_persistence = 3;
+	/* Number of 'out of limits' ADC readings */
+	chip->taos_settings.als_interrupt = 1;
+	/* Default with interrupt enabled */
+}
+
+
+/*
+ * Obtain single reading and calculate the als_gain_trim (later used
+ * to derive actual lux).
+ * Return updated gain_trim value.
+ */
+int taos_als_calibrate(struct i2c_client *client)
+{
+	struct tsl2571_chip *chip = i2c_get_clientdata(client);
+	u8 reg_val;
+	unsigned int gain_trim_val;
+	int ret;
+	int lux_val;
+
+	ret = i2c_smbus_write_byte(client, (TSL257X_CMD_REG | TSL257X_CNTRL));
+	if (ret < 0) {
+		dev_err(&client->dev,
+		"taos_als_calibrate failed read CNTRL register, ret=%d\n",
+			ret);
+		return ret;
+	}
+
+	reg_val = i2c_smbus_read_byte(client);
+	if ((reg_val & (TSL257X_CNTL_ADC_ENBL | TSL257X_CNTL_PWR_ON))
+			!= (TSL257X_CNTL_ADC_ENBL | TSL257X_CNTL_PWR_ON)) {
+		dev_err(&client->dev,
+		"taos_als_calibrate failed: ADC not enabled\n");
+		return -1;
+	}
+
+	ret = i2c_smbus_write_byte(client, (TSL257X_CMD_REG | TSL257X_CNTRL));
+	if (ret < 0) {
+		dev_err(&client->dev,
+		"taos_als_calibrate failed: read STATUS, ret=%d\n",
+			ret);
+		return ret;
+	}
+	reg_val = i2c_smbus_read_byte(client);
+
+	if ((reg_val & TSL257X_STA_ADC_VALID) != TSL257X_STA_ADC_VALID) {
+		dev_err(&client->dev,
+			"taos_als_calibrate failed: STATUS - ADC not valid.\n");
+		return -EINVAL;
+	}
+	lux_val = taos_get_lux(client);
+	if (lux_val < 0) {
+		dev_err(&client->dev, "taos_als_calibrate failed to get lux\n");
+		return lux_val;
+	}
+	gain_trim_val = (unsigned int) (((chip->taos_settings.als_cal_target)
+			* chip->taos_settings.als_gain_trim) / lux_val);
+
+	if ((gain_trim_val < 250) || (gain_trim_val > 4000)) {
+		dev_err(&client->dev,
+		"taos_als_calibrate failed: trim_val %d - out of range\n",
+			gain_trim_val);
+		return -ERANGE;
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
+	struct tsl2571_chip *chip = i2c_get_clientdata(client);
+	u8 reg_val;
+
+    /* Non calculated parameters */
+	chip->taos_config[TSL257X_ALS_MINTHRESHLO] =
+		(chip->taos_settings.als_thresh_low) & 0xFF;
+	chip->taos_config[TSL257X_ALS_MINTHRESHHI] =
+		(chip->taos_settings.als_thresh_low >> 8) & 0xFF;
+	chip->taos_config[TSL257X_ALS_MAXTHRESHLO] =
+		(chip->taos_settings.als_thresh_high) & 0xFF;
+	chip->taos_config[TSL257X_ALS_MAXTHRESHHI] =
+		(chip->taos_settings.als_thresh_high >> 8) & 0xFF;
+	chip->taos_config[TSL257X_PERSISTENCE] =
+		chip->taos_settings.als_persistence;
+
+	/* and make sure we're not already on */
+	if (chip->taos_chip_status == TSL257X_CHIP_WORKING) {
+			dev_info(&client->dev, "device is already enabled\n");
+		return -EINVAL;
+	}
+
+	/* determine als integration regster */
+	als_count = (chip->taos_settings.als_time * 100 + 135) / 270;
+	if (als_count == 0)
+		als_count = 1; /* ensure at least one cycle */
+
+	/* convert back to time (encompasses overrides) */
+	als_time = (als_count * 27 + 5) / 10;
+	chip->taos_config[TSL257X_ALS_TIME] = 256 - als_count;
+
+	/* Set the gain based on taos_settings struct */
+	chip->taos_config[TSL257X_GAIN] = chip->taos_settings.als_gain;
+
+	/* set chip struct re scaling and saturation */
+	chip->als_saturation = als_count * 922; /* 90% of full scale */
+	chip->als_time_scale = (als_time + 25) / 50;
+
+	/* TSL257X Specific power-on / adc enable sequence
+	 * Power on the device 1st. */
+	utmp = TSL257X_CNTL_PWR_ON;
+	ret = i2c_smbus_write_byte_data(client, TSL257X_CMD_REG | TSL257X_CNTRL,
+					utmp);
+	if (ret < 0) {
+		dev_err(&client->dev, "taos_chip_on failed on CNTRL reg.\n");
+		return ret;
+	}
+
+	/* Use the following shadow copy for our delay before enabling ADC.
+	 * Write all the registers. */
+	for (i = 0, uP = chip->taos_config; i < TSL257X_REG_MAX; i++) {
+		ret = i2c_smbus_write_byte_data(client, TSL257X_CMD_REG + i,
+						*uP++);
+		if (ret < 0) {
+			dev_err(&client->dev,
+				"taos_chip_on failed on write to reg %d.\n", i);
+			return ret;
+		}
+	}
+
+	msleep(3);
+	/* NOW enable the ADC
+	 * initialize the desired mode of operation */
+	utmp = TSL257X_CNTL_PWR_ON | TSL257X_CNTL_ADC_ENBL;
+	ret = i2c_smbus_write_byte_data(client, TSL257X_CMD_REG | TSL257X_CNTRL,
+					utmp);
+	if (ret < 0) {
+		dev_err(&client->dev, "taos_chip_on failed on 2nd CTRL reg.\n");
+		return ret;
+		}
+
+
+	/* If interrupts are enabled */
+	chip->init_done = 0;
+	if (chip->taos_settings.als_interrupt) {
+		dev_info(&client->dev, "ALS Interrupts on\n");
+	/*First make sure we have an ALS persistence > 0
+	else we'll interrupt continuously.*/
+	ret = taos_i2c_read(client,
+		(TSL257X_CMD_REG | TSL257X_PERSISTENCE), &reg_val, 1);
+	if (ret < 0) {
+		dev_err(&client->dev,
+			"Failed to get the persistence register value\n");
+		return ret;
+	}
+
+	/*ALS Interrupt after 3 consecutive reading out of range */
+	if ((reg_val & 0x0F) == 0) {
+		reg_val |= 0x03;
+		ret = i2c_smbus_write_byte_data(client,
+			(TSL257X_CMD_REG | (TSL257X_PERSISTENCE)), reg_val);
+
+	if (ret < 0)
+		dev_err(&client->dev,
+		"taos_i2c_write to update the persistence register.\n");
+		return ret;
+	}
+	reg_val = TSL257X_CNTL_PWRON |
+	CNTL_ADC_ENBL |
+	CNTL_ALS_INT_ENBL |
+	CNTL_INTALSPON_ENBL;
+
+	ret = i2c_smbus_write_byte_data(client,
+		(TSL257X_CMD_REG | TSL257X_CNTRL), reg_val);
+	if (ret < 0) {
+		dev_err(&client->dev,
+		"taos_i2c_write to device failed in TAOS_IOCTL_INT_SET.\n");
+		return ret;
+	}
+
+	/* Clear out any initial als interrupts */
+	ret = i2c_smbus_write_byte(client,
+		TSL257X_CMD_REG | TSL257X_CMD_SPL_FN |
+		TSL257X_CMD_PROXALS_INTCLR);
+	if (ret < 0) {
+		dev_err(&client->dev,
+		"Failed to clear interrupts: taos_chip_on\n");
+	    return ret;
+		}
+	}
+
+	chip->taos_chip_status = TSL257X_CHIP_WORKING;
+
+	return ret;
+
+}
+
+static int taos_chip_off(struct i2c_client *client)
+{
+	struct tsl2571_chip *chip = i2c_get_clientdata(client);
+
+	/* turn device off */
+	chip->taos_chip_status = TSL257X_CHIP_SUSPENDED;
+	return i2c_smbus_write_byte_data(client,
+		TSL257X_CMD_REG | TSL257X_CNTRL, 0x00);
+}
+
+/* ---------- Sysfs Interface Functions ------------- */
+
+static ssize_t taos_device_id(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%s\n", chip->client->name);
+}
+
+static ssize_t taos_power_state_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%d\n", chip->taos_chip_status);
+}
+
+static ssize_t taos_power_state_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
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
+	struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%d\n",
+		tsl2571_gainadj[chip->taos_settings.als_gain].ch0);
+}
+
+static ssize_t taos_gain_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+	unsigned long value;
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	switch (value) {
+	case 1:
+		chip->taos_settings.als_gain = 0;
+		break;
+	case 8:
+		chip->taos_settings.als_gain = 1;
+		break;
+	case 16:
+		chip->taos_settings.als_gain = 2;
+		break;
+	case 111:
+		chip->taos_settings.als_gain = 3;
+		break;
+	default:
+		dev_err(dev,
+			"Invalid Gain Index\n");
+		return -EINVAL;
+	}
+
+	return len;
+}
+
+static ssize_t taos_gain_available_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n", "1 8 16 111");
+}
+
+static ssize_t taos_als_time_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%d\n", chip->taos_settings.als_time);
+}
+
+static ssize_t taos_als_time_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if ((value < 50) || (value > 650))
+		return -EINVAL;
+
+	if (value % 50)
+		return -EINVAL;
+
+	 chip->taos_settings.als_time = value;
+
+	return len;
+}
+
+static ssize_t taos_als_time_available_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n",
+		"50 100 150 200 250 300 350 400 450 500 550 600 650");
+}
+
+static ssize_t taos_als_trim_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%d\n", chip->taos_settings.als_gain_trim);
+}
+
+static ssize_t taos_als_trim_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
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
+static ssize_t taos_adc_show(struct device *dev, struct device_attribute *attr,
+	char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+	int lux;
+
+	lux = taos_get_lux(chip->client);
+
+	return sprintf(buf, "%d,%d\n",
+		chip->als_cur_info.als_ch0, chip->als_cur_info.als_ch1);
+}
+
+static ssize_t taos_als_cal_target_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%d\n", chip->taos_settings.als_cal_target);
+}
+
+static ssize_t taos_als_cal_target_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
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
+static ssize_t taos_als_interrupt_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%d\n", chip->taos_settings.als_interrupt);
+}
+
+static ssize_t taos_als_interrupt_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if (value > 1)
+		return -EINVAL;
+	chip->taos_settings.als_interrupt = value;
+
+	return len;
+}
+
+static ssize_t taos_als_thresh_low_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%d\n", chip->taos_settings.als_thresh_low);
+}
+
+static ssize_t taos_als_thresh_low_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	chip->taos_settings.als_thresh_low = value;
+
+	return len;
+}
+
+static ssize_t taos_als_thresh_high_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%d\n", chip->taos_settings.als_thresh_high);
+}
+
+static ssize_t taos_als_thresh_high_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	chip->taos_settings.als_thresh_high = value;
+
+	return len;
+}
+
+/* sampling_frequency AKA persistence in data sheet */
+static ssize_t taos_als_persistence_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%d\n",
+		persistence_available[chip->taos_settings.als_persistence]);
+}
+
+static ssize_t taos_als_persistence_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t len)
+{
+	int i;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	for (i = 0; i < (sizeof(persistence_available) + 1); i++) {
+		if ((u8)value == persistence_available[i]) {
+			chip->taos_settings.als_persistence = i;
+			return len;
+		}
+	}
+
+	dev_err(dev,
+		"Invalid Persistence value\n");
+	return -EINVAL;
+}
+
+static ssize_t taos_als_persistence_available_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "0 1 2 3 5 10 15 20 25 30 35 40 45 5 55 60\n");
+}
+
+static ssize_t taos_lux_show(struct device *dev, struct device_attribute *attr,
+	char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+	int lux;
+
+	lux = taos_get_lux(chip->client);
+
+	return sprintf(buf, "%d\n", lux);
+}
+
+static ssize_t taos_do_calibrate(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
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
+	struct device_attribute *attr, char *buf)
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
+	struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2571_chip *chip = indio_dev->dev_data;
+	int value[ARRAY_SIZE(taos_device_lux)];
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
+	if ((n % 3) || n < 6 || n > ((ARRAY_SIZE(taos_device_lux) - 1) * 3)) {
+		dev_info(dev, "LUX TABLE INPUT ERROR 1 Value[0]=%d\n", n);
+		return -EINVAL;
+	}
+
+	if ((value[(n - 2)] | value[(n - 1)] | value[n]) != 0) {
+		dev_info(dev, "LUX TABLE INPUT ERROR 2 Value[0]=%d\n", n);
+		return -EINVAL;
+	}
+
+	if (chip->taos_chip_status == TSL257X_CHIP_WORKING)
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
+
+static DEVICE_ATTR(name, S_IRUGO, taos_device_id, NULL);
+static DEVICE_ATTR(power_state, S_IRUGO | S_IWUSR,
+		taos_power_state_show, taos_power_state_store);
+
+static DEVICE_ATTR(illuminance0_calibscale, S_IRUGO | S_IWUSR,
+		taos_gain_show, taos_gain_store);
+static DEVICE_ATTR(illuminance0_calibscale_available, S_IRUGO,
+		taos_gain_available_show, NULL);
+
+static DEVICE_ATTR(illuminance0_integration_time, S_IRUGO | S_IWUSR,
+		taos_als_time_show, taos_als_time_store);
+static DEVICE_ATTR(illuminance0_integration_time_available, S_IRUGO,
+		taos_als_time_available_show, NULL);
+
+static DEVICE_ATTR(illuminance0_calibbias, S_IRUGO | S_IWUSR,
+		taos_als_trim_show, taos_als_trim_store);
+
+static DEVICE_ATTR(illuminance0_input_target, S_IRUGO | S_IWUSR,
+		taos_als_cal_target_show, taos_als_cal_target_store);
+
+static DEVICE_ATTR(illuminance0_raw, S_IRUGO, taos_adc_show, NULL);
+
+static DEVICE_ATTR(illuminance0_input, S_IRUGO, taos_lux_show, NULL);
+static DEVICE_ATTR(illuminance0_calibrate, S_IWUSR, NULL, taos_do_calibrate);
+static DEVICE_ATTR(illuminance0_lux_table, S_IRUGO | S_IWUSR,
+		taos_luxtable_show, taos_luxtable_store);
+
+static DEVICE_ATTR(intensity0_both_thresh_falling_value, S_IRUGO | S_IWUSR,
+		taos_als_thresh_low_show, taos_als_thresh_low_store);
+
+static DEVICE_ATTR(intensity0_both_thresh_rising_value, S_IRUGO | S_IWUSR,
+		taos_als_thresh_high_show, taos_als_thresh_high_store);
+
+static DEVICE_ATTR(sampling_frequency, S_IRUGO | S_IWUSR,
+		taos_als_persistence_show, taos_als_persistence_store);
+
+static DEVICE_ATTR(sampling_frequency_available, S_IRUGO,
+		taos_als_persistence_available_show, NULL);
+
+static struct attribute *sysfs_attrs_ctrl[] = {
+	&dev_attr_name.attr,
+	&dev_attr_power_state.attr,
+	&dev_attr_illuminance0_calibscale.attr,	/* Gain  */
+	&dev_attr_illuminance0_calibscale_available.attr,
+	&dev_attr_illuminance0_integration_time.attr, /* I time*/
+	&dev_attr_illuminance0_integration_time_available.attr,
+	&dev_attr_illuminance0_calibbias.attr,	/* trim  */
+	&dev_attr_illuminance0_input_target.attr,
+	&dev_attr_illuminance0_raw.attr,
+	&dev_attr_illuminance0_input.attr,
+	&dev_attr_illuminance0_calibrate.attr,
+	&dev_attr_illuminance0_lux_table.attr,
+	&dev_attr_intensity0_both_thresh_falling_value.attr,/* Low T  */
+	&dev_attr_intensity0_both_thresh_rising_value.attr,	/* High T */
+	&dev_attr_sampling_frequency.attr,		/* persist*/
+	&dev_attr_sampling_frequency_available.attr,
+	NULL
+};
+
+static struct attribute_group tsl2571_attribute_group = {
+	.attrs = sysfs_attrs_ctrl,
+};
+
+/*
+ * Run-time interrupt handler - depending on whether the device is in ambient
+ * light sensing interrupt mode, this handler queues up
+ * the bottom-half tasklet, to handle all valid interrupts.
+ */
+static int taos_interrupt_th(struct iio_dev *dev_info,
+			int index,
+			s64 timestamp,
+			int not_test)
+{
+	struct tsl2571_chip *chip = dev_info->dev_data;
+
+	schedule_work(&chip->work_thresh);
+	return 0;
+}
+
+IIO_EVENT_SH(threshold, &taos_interrupt_th);
+
+IIO_EVENT_ATTR_SH(intensity0_both_thresh_en,
+		  iio_event_threshold,
+		  taos_als_interrupt_show,
+		  taos_als_interrupt_store,
+		  TSL257X_STA_ALS_INTR);
+
+static struct attribute *tsl2571_event_attributes[] = {
+	&iio_event_attr_intensity0_both_thresh_en.dev_attr.attr,
+	NULL,
+};
+
+static struct attribute_group tsl2571_event_attribute_group = {
+	.attrs = tsl2571_event_attributes,
+};
+
+/* Use the default register values to identify the Taos device */
+static int taos_TSL257X_device(unsigned char *bufp)
+{
+	return ((bufp[TSL257X_CHIPID] & 0xf0) == 0x00);
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
+	unsigned char buf[TSL257X_MAX_DEVICE_REGS];
+	static struct tsl2571_chip *chip;
+
+	if (!i2c_check_functionality(clientp->adapter,
+		I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_err(&clientp->dev,
+			"taos_probe() - i2c smbus byte data "
+			"functions unsupported\n");
+		return -EOPNOTSUPP;
+	}
+
+	chip = kzalloc(sizeof(struct tsl2571_chip), GFP_KERNEL);
+
+	chip->client = clientp;
+	i2c_set_clientdata(clientp, chip);
+
+	mutex_init(&chip->als_mutex);
+	chip->taos_chip_status = TSL257X_CHIP_UNKNOWN;
+	memcpy(chip->taos_config, taos_config, sizeof(chip->taos_config));
+
+	for (i = 0; i < TSL257X_MAX_DEVICE_REGS; i++) {
+		ret = i2c_smbus_write_byte(clientp,
+				(TSL257X_CMD_REG | (TSL257X_CNTRL + i)));
+		if (ret < 0) {
+			dev_err(&clientp->dev, "i2c_smbus_write_bytes() to cmd "
+				"reg failed in taos_probe(), err = %d\n", ret);
+			goto fail1;
+		}
+		ret = i2c_smbus_read_byte(clientp);
+		if (ret < 0) {
+			dev_err(&clientp->dev, "i2c_smbus_read_byte from "
+				"reg failed in taos_probe(), err = %d\n", ret);
+
+			goto fail1;
+		}
+		buf[i] = ret;
+	}
+
+	if (!taos_TSL257X_device(buf)) {
+		dev_info(&clientp->dev, "i2c device found but does not match "
+			"expected id in taos_probe()\n");
+		goto fail1;
+	}
+
+	ret = i2c_smbus_write_byte(clientp, (TSL257X_CMD_REG | TSL257X_CNTRL));
+	if (ret < 0) {
+		dev_err(&clientp->dev, "i2c_smbus_write_byte() to cmd reg "
+			"failed in taos_probe(), err = %d\n", ret);
+		goto fail1;
+	}
+
+	chip->iio_dev = iio_allocate_device();
+	if (!chip->iio_dev)
+		goto fail1;
+
+	chip->iio_dev->attrs = &tsl2571_attribute_group;
+	chip->iio_dev->dev.parent = &clientp->dev;
+	chip->iio_dev->dev_data = (void *)(chip);
+	chip->iio_dev->num_interrupt_lines = 1;
+	chip->iio_dev->event_attrs = &tsl2571_event_attribute_group;
+	chip->iio_dev->driver_module = THIS_MODULE;
+	chip->iio_dev->modes = INDIO_DIRECT_MODE;
+
+	ret = iio_device_register(chip->iio_dev);
+	if (ret)
+		goto fail1;
+
+	if (chip->irq_no) {
+		ret = iio_register_interrupt_line(chip->irq_no,
+						  chip->iio_dev,
+						  0,
+						  IRQF_TRIGGER_FALLING,
+						  "tsl2571");
+		if (ret)
+			goto fail1;
+
+		iio_add_event_to_list(&iio_event_threshold,
+				    &chip->iio_dev->interrupts[0]->ev_list);
+	}
+
+	/* Defaults - (these are can be changed in the device[x]/ABI) */
+	taos_defaults(chip);
+
+	INIT_WORK(&chip->work_thresh, taos_als_interrupt_bh);
+
+	/* Make sure the chip is on */
+	taos_chip_on(clientp);
+
+	dev_info(&clientp->dev, "Light sensor found.\n");
+
+	return 0;
+
+fail1:
+	kfree(chip);
+
+	return ret;
+}
+
+static int taos_suspend(struct i2c_client *client, pm_message_t state)
+{
+	struct tsl2571_chip *chip = i2c_get_clientdata(client);
+	int ret = 0;
+
+	mutex_lock(&chip->als_mutex);
+
+	if (chip->taos_chip_status == TSL257X_CHIP_WORKING) {
+		ret = taos_chip_off(client);
+		chip->taos_chip_status = TSL257X_CHIP_SUSPENDED;
+	}
+
+	mutex_unlock(&chip->als_mutex);
+	return ret;
+}
+
+static int taos_resume(struct i2c_client *client)
+{
+	struct tsl2571_chip *chip = i2c_get_clientdata(client);
+	int ret = 0;
+
+	mutex_lock(&chip->als_mutex);
+
+	if (chip->taos_chip_status == TSL257X_CHIP_SUSPENDED)
+		ret = taos_chip_on(client);
+
+	mutex_unlock(&chip->als_mutex);
+	return ret;
+}
+
+
+static int __devexit taos_remove(struct i2c_client *client)
+{
+	struct tsl2571_chip *chip = i2c_get_clientdata(client);
+
+	taos_chip_off(client);
+
+	if (chip->irq_no)
+		free_irq(chip->irq_no, chip->client->name);
+	flush_scheduled_work();
+	iio_device_unregister(chip->iio_dev);
+
+	kfree(chip);
+	return 0;
+}
+
+static struct i2c_device_id taos_idtable[] = {
+	{ "tsl2571", 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, taos_idtable);
+
+/* Driver definition */
+static struct i2c_driver taos_driver = {
+	.driver = {
+		.name = "tsl2571",
+	},
+	.id_table = taos_idtable,
+	.suspend	= taos_suspend,
+	.resume		= taos_resume,
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
+MODULE_DESCRIPTION("TAOS tsl2571 ambient light sensor driver");
+MODULE_LICENSE("GPL");
--
1.7.0.4


