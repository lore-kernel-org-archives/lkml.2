Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab1D0TlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 15:41:18 -0400
Received: from 90-46-11-204.rar.beartech.net ([204.11.46.90]:59607 "EHLO
	exchsrvr.taosinc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753021Ab1D0TlQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 15:41:16 -0400
Subject: [PATCH V1] TAOS tsl2671 Device Driver
From: Jon Brenner <jbrenner@taosinc.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-iio <linux-iio@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 27 Apr 2011 14:41:26 -0500
Message-ID: <1303933286.22898.9.camel@jonz-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH v1] for TAOS tsl2671 (Proximity Only) Device driver

Driver includes (iio_event/interrupt).

Signed-off-by: Jon Brenner <jbrenner@taosinc.com>

---
 drivers/staging/iio/light/Kconfig   |    9 +
 drivers/staging/iio/light/Makefile  |    1 +
 drivers/staging/iio/light/tsl2671.c | 1080 +++++++++++++++++++++++++++++++++++
 3 files changed, 1090 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/light/Kconfig b/drivers/staging/iio/light/Kconfig
index 36d8bbe..3ead1c5 100644
--- a/drivers/staging/iio/light/Kconfig
+++ b/drivers/staging/iio/light/Kconfig
@@ -24,3 +24,12 @@ config SENSORS_ISL29018
          in lux, proximity infrared sensing and normal infrared sensing.
          Data from sensor is accessible via sysfs.

+config SENSORS_TSL2671
+	tristate "TAOS TSL2671 proximity sensor"
+	depends on I2C
+	help
+	 Y = in kernel.
+	 M = as module.
+	 Provides support for TAOS tsl2671 devices.
+	 Access PROXIMITY data via iio, sysfs.
+
diff --git a/drivers/staging/iio/light/Makefile b/drivers/staging/iio/light/Makefile
index 9142c0e..0528443 100644
--- a/drivers/staging/iio/light/Makefile
+++ b/drivers/staging/iio/light/Makefile
@@ -4,3 +4,4 @@

 obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
 obj-$(CONFIG_SENSORS_ISL29018)	+= isl29018.o
+obj-$(CONFIG_SENSORS_TSL2671)	+= tsl2671.o
diff --git a/drivers/staging/iio/light/tsl2671.c b/drivers/staging/iio/light/tsl2671.c
new file mode 100644
index 0000000..a521130
--- /dev/null
+++ b/drivers/staging/iio/light/tsl2671.c
@@ -0,0 +1,1080 @@
+/*
+ * Device driver for the TAOS TSL2671 proximity sensor.
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
+#define TSL2671_MAX_DEVICE_REGS	32
+#define	TSL2671_REG_MAX		16
+
+/* Device Registers and Masks */
+#define TSL2671_CNTRL			0x00
+#define TSL2671_PRX_MINTHRESHLO	0X08
+#define TSL2671_PRX_MINTHRESHHI	0X09
+#define TSL2671_PRX_MAXTHRESHLO	0X0A
+#define TSL2671_PRX_MAXTHRESHHI	0X0B
+
+#define TSL2671_PERSISTENCE		0x0c
+
+#define TSL2671_PRX_COUNT		0x0E
+#define TSL2671_GAIN			0x0f
+#define	TSL2671_STATUS			0x13
+#define TSL2671_REVID			0x11
+#define TSL2671_CHIPID			0x12
+#define TSL2671_PRX_LO			0x18
+#define TSL2671_PRX_HI			0x19
+
+/* tsl2671 cmd reg masks */
+#define TSL2671_CMD_REG			0x80
+#define TSL2671_CMD_SPL_FN		0x60
+
+#define CMD_PROXALS_INT_CLR		0X07
+
+/* tsl2671 cntrl reg masks */
+#define TSL2671_CNTL_ADC_ENBL	0x02
+#define TSL2671_CNTL_PWR_ON		0x01
+
+/* tsl2671 status reg masks */
+#define TSL2671_STA_ADC_VALID	0x01
+#define TSL2671_STA_PRX_VALID	0x02
+#define TSL2671_STA_ADC_PRX_VALID	0x03
+#define STA_ADCINTR			0x10
+#define STA_PRXINTR			0x20
+
+#define TSL2671_STA_ADC_INTR	0x10
+
+/* Triton cntrl reg masks */
+#define CNTL_REG_CLEAR			0x00
+#define CNTL_PROX_INT_ENBL		0X20
+#define TSL2671_CNTL_WAIT_TMR_ENBL	0X08
+#define CNTL_PROX_DET_ENBL		0X04
+#define CNTL_ADC_ENBL			0x02
+#define TSL2671_CNTL_PWRON		0x01
+#define CNTL_PROXPON_ENBL		0x0F
+#define CNTL_INTPROXPON_ENBL	0x2F
+#define TSL2671_CMD_PROXALS_INTCLR	0X07
+
+/*Prox diode to use */
+#define DIODE0				0x10
+#define DIODE1				0x20
+#define DIODE_BOTH			0x30
+
+/* LED Power */
+#define mA100				0x00
+#define mA50				0x40
+#define mA25				0x80
+#define mA13				0xD0
+
+/* Cal defs*/
+#define	PROX_STAT_CAL	0
+#define	PROX_STAT_SAMP	1
+#define	MAX_SAMPLES_CAL	200
+
+enum {
+	TSL2671_CHIP_UNKNOWN = 0,
+	TSL2671_CHIP_WORKING = 1,
+	TSL2671_CHIP_SUSPENDED = 2
+} TSL2671_CHIP_WORKING_STATUS;
+
+/* proximity data */
+struct taos_prox_info {
+	u16 prox_data;
+	int prox_event;
+};
+
+struct prox_stat {
+	u16 min;
+	u16 max;
+	u16 mean;
+	unsigned long stddev;
+} ;
+
+struct taos_settings {
+	u8	interrupt;
+	u8	persistence;
+	int	prox_thres;
+	int	prox_pulse_count;
+	int	prox_max_samples_cal;	/* for calibration mode*/
+
+};
+
+#define	MAXPROXFILTER	100
+
+u16 taos_prox_filter_data[MAXPROXFILTER];	/*history buffer*/
+
+struct tsl2671_chip {
+	struct mutex prox_mutex;
+	struct i2c_client *client;
+	struct iio_dev *iio_dev;
+	struct taos_prox_info prox_cur_info;
+	struct taos_settings taos_settings;
+	int taos_chip_status;
+	u8 taos_config[TSL2671_REG_MAX];
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
+static u8 tsl2671_taos_config[] = {
+		0x00, 0xee, 0xFF, 0xF5, 0x00, 0x00, 0x00, 0x00,
+	/*	Enabl itime ptime wtime NA    NA    NA    NA   */
+		0x00, 0x00, 0x00, 0x03,	0x10, 0x00, 0x0a, 0x20
+	/*	PtL0  PtL1  PtH0  PtH1  Pers  CFG   Pcnt  CTRL */
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
+		ret = i2c_smbus_write_byte(client, (TSL2671_CMD_REG | reg));
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
+ * Proximity poll function - if valid data is available, read and form the ch0
+ * and prox data values, check for limits on the ch0 value, and check the prox
+ * data against the current thresholds, to set the event status accordingly.
+ */
+int taos_prox_poll(struct i2c_client *client)
+{
+#define CONSECUTIVE_RETRIES 50
+
+int i;
+int ret;
+u8 status;
+u8 chdata[2];
+int err_cnt;
+struct tsl2671_chip *chip = i2c_get_clientdata(client);
+
+	if (mutex_trylock(&chip->prox_mutex) == 0) {
+		dev_err(&client->dev, "Can't get prox mutex\n");
+	return -1;
+	}
+
+	err_cnt = 0;
+
+tryAgain:
+	ret = taos_i2c_read(client,
+		(TSL2671_CMD_REG | TSL2671_STATUS), &status, 1);
+	if (ret < 0) {
+		dev_err(&client->dev,
+			"Read regs failed in taos_prox_poll() - A\n");
+		mutex_unlock(&chip->prox_mutex);
+		return ret;
+	}
+
+	/*Prox interrupt asserted*/
+	if (((chip->taos_settings.interrupt << 4) & CNTL_PROX_INT_ENBL)) {
+		if (!(status & TSL2671_STA_ADC_VALID)) {
+			err_cnt++;
+			if (err_cnt > CONSECUTIVE_RETRIES) {
+				mutex_unlock(&chip->prox_mutex);
+				dev_err(&client->dev, "Consec. retries exceeded\n");
+				return chip->prox_cur_info.prox_event;
+			}
+			goto tryAgain;
+		}
+	}
+
+	for (i = 0; i < 2; i++) {
+		ret = taos_i2c_read(client,
+			(TSL2671_CMD_REG |
+					(TSL2671_PRX_LO + i)), &chdata[i], 1);
+		if (ret < 0) {
+			dev_err(&client->dev,
+			"Read regs failed in taos_prox_poll() - B\n");
+			mutex_unlock(&chip->prox_mutex);
+			return ret;
+		}
+	}
+
+	chip->prox_cur_info.prox_data = (chdata[1]<<8)|chdata[0];
+
+	if (chip->prox_cur_info.prox_data >= chip->taos_settings.prox_thres)
+		chip->prox_cur_info.prox_event = 1;
+	else
+		chip->prox_cur_info.prox_event = 0;
+
+	mutex_unlock(&chip->prox_mutex);
+	return chip->prox_cur_info.prox_event;
+}
+
+/*
+ * Proximity detect interrupt BH - called when proximity of an object
+ * to the sensor is detected (event = 1), or, once detected, it has moved away
+ * from the sensor (event = 0).
+ * Prox info is stored into the structure "prox_cur_inf",
+ * and signal is issued to any waiting user mode threads -
+ * which must be (of course) registered to be signaled.
+ * This is the called from the 'bottom half' of IRQ.
+ */
+void taos_prox_adjust_level(struct work_struct *prox)
+{
+	int ret = 0, i;
+	u16 cdelta;
+	u8 prox_low[2];
+	u8 prox_high[2];
+	struct tsl2671_chip *chip
+	= container_of(prox,
+			struct tsl2671_chip, work_thresh);
+
+	taos_prox_poll(chip->client);
+
+	if (chip->prox_cur_info.prox_data > chip->taos_settings.prox_thres) {
+		dev_info(&chip->client->dev,
+			"prox_data > prox_thres");
+		/*Rail the threshold so we don't keep interrupting*/
+		prox_high[0] = 0xFF;
+		prox_high[1] = 0xFF;
+		for (i = 0; i < 2; i++) {
+			ret = i2c_smbus_write_byte_data(chip->client,
+				(TSL2671_CMD_REG |
+				(TSL2671_PRX_MAXTHRESHLO + i)),
+				prox_high[i]);
+
+			if (ret < 0)
+				dev_err(&chip->client->dev,
+				"FAILED: to update PROX HIGH THRESH (A).\n");
+		}
+
+		cdelta = chip->taos_settings.prox_thres - 100;
+
+		if (cdelta < 10)
+			cdelta = chip->taos_settings.prox_thres - 1;
+
+		prox_low[0] = (cdelta) & 0xFF;
+		prox_low[1] = (cdelta >> 8) & 0xFF;
+		for (i = 0; i < 2; i++) {
+			i2c_smbus_write_byte_data(chip->client,
+				(TSL2671_CMD_REG |
+				(TSL2671_PRX_MINTHRESHLO + i)),
+				prox_low[i]);
+
+			if (ret < 0)
+				dev_err(&chip->client->dev,
+				"FAILED: to update the PROX LOW THRESH (B).\n");
+		}
+	} else if (chip->prox_cur_info.prox_data <
+			chip->taos_settings.prox_thres) {
+		dev_info(&chip->client->dev,
+		"prox_data <= prox_thres");
+		prox_low[0] = 0x00;
+		prox_low[1] = 0x00;
+		for (i = 0; i < 2; i++) {
+			ret = i2c_smbus_write_byte_data(chip->client,
+				(TSL2671_CMD_REG |
+				(TSL2671_PRX_MINTHRESHLO + i)),
+				prox_low[i]);
+
+			if (ret < 0)
+				dev_err(&chip->client->dev,
+				"FAILED: to update the PROX LOW THRESH (C).\n");
+		}
+		/*Lastly we put the high threshols back to where we started*/
+		prox_high[0] = (chip->taos_settings.prox_thres) & 0xFF;
+		prox_high[1] = (chip->taos_settings.prox_thres >> 8) & 0xFF;
+		for (i = 0; i < 2; i++) {
+			ret = i2c_smbus_write_byte_data(chip->client,
+				(TSL2671_CMD_REG |
+				(TSL2671_PRX_MAXTHRESHLO + i)),
+				prox_high[i]);
+
+			if (ret < 0)
+				dev_err(&chip->client->dev,
+				"FAILED: to update PROX HIGH THRESH (D).\n");
+		}
+
+	}
+
+return;
+}
+
+/*
+ * Proximity interrupt BH - called when the proximity threshold
+ * falls above or below a set value.
+ */
+void taos_interrupt_bh(struct work_struct *prox)
+{
+int ret;
+int value;
+u8  reg_val;
+
+struct tsl2671_chip *chip
+	= container_of(prox,
+		struct tsl2671_chip, work_thresh);
+
+	value = i2c_smbus_read_byte_data(chip->client,
+		TSL2671_CMD_REG | TSL2671_STATUS);
+
+	if ((value & STA_PRXINTR) &&
+		(chip->taos_settings.interrupt & CNTL_PROX_INT_ENBL)) {
+		iio_push_event(chip->iio_dev, 0,
+			IIO_UNMOD_EVENT_CODE(IIO_EV_CLASS_PROXIMITY,
+				0,
+				IIO_EV_TYPE_THRESH,
+				IIO_EV_DIR_EITHER),
+				chip->event_timestamp);
+		taos_prox_adjust_level(prox);
+	}
+
+	if (!chip->init_done) {
+		/* Maintain the persistence value */
+		ret = taos_i2c_read(chip->client,
+			(TSL2671_CMD_REG | (TSL2671_PERSISTENCE)),
+			&reg_val, 1);
+		if (ret < 0)
+			dev_info(&chip->client->dev,
+			"Failed to get the persistence register value\n");
+
+			reg_val = chip->taos_settings.persistence;
+
+		ret = i2c_smbus_write_byte_data(chip->client,
+			(TSL2671_CMD_REG | TSL2671_PERSISTENCE), reg_val);
+		if (ret < 0)
+			dev_info(&chip->client->dev,
+			"FAILED: update the persistence (B).\n");
+		}
+
+		chip->init_done = 1;
+
+	/* Clear out any initial irq status */
+	ret = i2c_smbus_write_byte(chip->client,
+		(TSL2671_CMD_REG |
+				TSL2671_CMD_SPL_FN |
+				TSL2671_CMD_PROXALS_INTCLR));
+	if (ret < 0)
+		dev_info(&chip->client->dev,
+		"taos_interrupt_bh FAILED to clear irqs: err = %d\n", ret);
+
+	enable_irq(chip->irq_no);
+
+return;
+}
+
+/*
+ * Provides initial operational parameter defaults.
+ * These defaults may be changed through the device's ABI.
+ */
+static void taos_defaults(struct tsl2671_chip *chip)
+{
+	/* Operational parameters */
+	chip->taos_settings.persistence = 0x10;
+	/* Number of 'out of limits' ADC readings */
+	chip->taos_settings.interrupt = 0x30;
+	/* Default interrupt enabled. */
+	chip->taos_settings.prox_thres = 512;
+	/*default threshold (adjust either manually or with cal routine*/
+	chip->taos_settings.prox_max_samples_cal = 100;
+	chip->taos_settings.prox_pulse_count = 10;
+
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
+	struct tsl2671_chip *chip = i2c_get_clientdata(client);
+	u8 reg_val;
+
+	/* Non calculated parameters */
+	chip->taos_config[TSL2671_PERSISTENCE] =
+		chip->taos_settings.persistence;
+
+	chip->taos_config[TSL2671_PRX_COUNT] =
+			chip->taos_settings.prox_pulse_count;
+	chip->taos_config[TSL2671_PRX_MINTHRESHLO] = 0;
+	chip->taos_config[TSL2671_PRX_MAXTHRESHLO] =
+			chip->taos_settings.prox_thres;
+
+	/* and make sure we're not already on */
+	if (chip->taos_chip_status == TSL2671_CHIP_WORKING) {
+		/* if forcing a register update - turn off, then on */
+		dev_info(&client->dev, "device is already enabled\n");
+		return -EINVAL;
+	}
+
+	/* Set the emitter and gain based on taos_settings struct */
+	chip->taos_config[TSL2671_GAIN] = (mA100 | DIODE_BOTH);
+
+	/* TSL2671 Specific power-on / adc enable sequence
+	 * Power on the device 1st. */
+	utmp = TSL2671_CNTL_PWR_ON;
+	ret = i2c_smbus_write_byte_data(client,
+		TSL2671_CMD_REG | TSL2671_CNTRL, utmp);
+	if (ret < 0) {
+		dev_err(&client->dev, "taos_chip_on failed on CNTRL reg.\n");
+		return -1;
+	}
+
+	/* Use the following shadow copy for our delay before enabling ADC.
+	 * Write all the registers. */
+	for (i = 0, uP = chip->taos_config; i < TSL2671_REG_MAX; i++) {
+		ret = i2c_smbus_write_byte_data(client, TSL2671_CMD_REG + i,
+						*uP++);
+		if (ret < 0) {
+			dev_err(&client->dev,
+				"taos_chip_on failed on write to reg %d.\n", i);
+			return ret;
+		}
+	}
+
+	msleep(3);
+	/* NOW enable the ADC */
+	utmp = TSL2671_CNTL_PWR_ON | TSL2671_CNTL_ADC_ENBL;
+	ret = i2c_smbus_write_byte_data(client, TSL2671_CMD_REG | TSL2671_CNTRL,
+					utmp);
+	if (ret < 0) {
+		dev_err(&client->dev, "taos_chip_on failed on 2nd CTRL reg.\n");
+		return ret;
+		}
+
+	chip->taos_chip_status = TSL2671_CHIP_WORKING;
+
+	/* If interrupts are enabled */
+	chip->init_done = 0;
+
+	if (chip->taos_settings.interrupt) {
+		dev_info(&client->dev, "Setting Up Interrupt(s)\n");
+		/* first time interrupt */
+		chip->init_done = 0;
+
+		/*First make sure we have persistence > 0
+		else we'll interrupt continuously.*/
+		ret = taos_i2c_read(client,
+			(TSL2671_CMD_REG | TSL2671_PERSISTENCE), &reg_val, 1);
+	if (ret < 0)
+		dev_err(&client->dev,
+			"Failed to get the persistence register value\n");
+
+	/*Prox Interrupt after 1 reading out of range */
+	if ((reg_val & 0x0F) == 0) {
+		reg_val |= 0x10;
+		ret = i2c_smbus_write_byte_data(client,
+			(TSL2671_CMD_REG | (TSL2671_PERSISTENCE)), reg_val);
+
+	if (ret < 0)
+		dev_err(&client->dev,
+		"taos_i2c_write to update the persistance register.\n");
+	}
+
+	reg_val = TSL2671_CNTL_PWR_ON | CNTL_ADC_ENBL | CNTL_PROX_DET_ENBL;
+	reg_val |= chip->taos_settings.interrupt;
+
+	ret = i2c_smbus_write_byte_data(client,
+		(TSL2671_CMD_REG | TSL2671_CNTRL), reg_val);
+	if (ret < 0)
+		dev_err(&client->dev,
+		"taos_i2c_write to device failed in TAOS_IOCTL_INT_SET.\n");
+
+	/* Clear out any initial interrupt */
+	ret = i2c_smbus_write_byte(client,
+		TSL2671_CMD_REG | TSL2671_CMD_SPL_FN |
+		TSL2671_CMD_PROXALS_INTCLR);
+	if (ret < 0) {
+		dev_err(&client->dev,
+			"taos_i2c_write_command failed in taos_chip_on\n");
+	    return ret;
+		}
+	}
+
+	return ret;
+
+}
+
+static int taos_chip_off(struct i2c_client *client)
+{
+	struct tsl2671_chip *chip = i2c_get_clientdata(client);
+
+	/* turn device off */
+	chip->taos_chip_status = TSL2671_CHIP_SUSPENDED;
+	return i2c_smbus_write_byte_data(client,
+		TSL2671_CMD_REG | TSL2671_CNTRL, 0x00);
+}
+
+/**
+ * Integer Square Root
+ * We need an integer version since 1st Floating point is not allowed
+ * in driver world, 2nd, cannot count on the devices having a FPU, and
+ * 3rd software FP emulation may be excessive.
+ */
+unsigned long taos_isqrt(unsigned long x)
+{
+register unsigned long op, res, one;
+op = x;
+res = 0;
+
+	one = 1 << 30;
+	while (one > op)
+		one >>= 2;
+
+	while (one != 0) {
+		if (op >= res + one) {
+			op -= res + one;
+			res += one << 1;
+		}
+		res >>= 1;
+		one >>= 2;
+	}
+	return res;
+}
+
+/*
+ * Proximity calibration helper function
+ * runs through a collection of data samples,
+ * sets the min, max, mean, and std dev.
+ */
+void taos_prox_calculate(u16 *data, int length, struct prox_stat *statP)
+{
+
+int i;
+int min, max, sum, mean;
+unsigned long stddev;
+int tmp;
+
+	if (length == 0)
+		length = 1;
+
+	sum = 0;
+	min = 0xffff;
+	max = 0;
+	for (i = 0; i < length; i++) {
+		sum += data[i];
+		if (data[i] < min)
+			min = data[i];
+		if (data[i] > max)
+			max = data[i];
+	}
+	mean = sum/length;
+	statP->min = min;
+	statP->max = max;
+	statP->mean = mean;
+
+	sum = 0;
+	for (i = 0; i < length; i++) {
+		tmp = data[i]-mean;
+		sum += tmp * tmp;
+	}
+	stddev = taos_isqrt((long)sum)/length;
+	statP->stddev = stddev;
+
+}
+
+/*
+ * Proximity calibration - collects a number of samples,
+ * calculates a standard deviation based on the samples,
+ * and sets the threshold accordingly.
+ */
+void taos_prox_cal(struct i2c_client *client)
+{
+u16 prox_history[MAX_SAMPLES_CAL+1];
+int i;
+struct prox_stat prox_stat_data[2];
+struct prox_stat *calP;
+struct tsl2671_chip *chip = i2c_get_clientdata(client);
+u8 tmp_irq_settings;
+
+	if (chip->taos_settings.prox_max_samples_cal > MAX_SAMPLES_CAL) {
+		dev_err(&client->dev,
+			"max prox samples cal is too big: %d\n",
+			chip->taos_settings.prox_max_samples_cal);
+		chip->taos_settings.prox_max_samples_cal = MAX_SAMPLES_CAL;
+	}
+
+	/* have to stop to change settings */
+	taos_chip_off(chip->client);
+
+	/* Enable proximity detection save just in case prox not wanted yet*/
+	tmp_irq_settings = chip->taos_settings.interrupt;
+	chip->taos_settings.interrupt |= CNTL_PROX_INT_ENBL;
+
+	/*turn on device if not already on*/
+	taos_chip_on(chip->client);
+
+	/*gather the samples*/
+	for (i = 0; i < chip->taos_settings.prox_max_samples_cal; i++) {
+		mdelay(15);
+		taos_prox_poll(chip->client);
+		prox_history[i] = chip->prox_cur_info.prox_data;
+		dev_info(&client->dev, "2 i=%d prox data= %d\n",
+			i, chip->prox_cur_info.prox_data);
+
+	}
+
+	taos_chip_off(chip->client);
+
+	calP = &prox_stat_data[PROX_STAT_CAL];
+	taos_prox_calculate(prox_history,
+		chip->taos_settings.prox_max_samples_cal, calP);
+	chip->taos_settings.prox_thres = (calP->max << 1) - calP->mean;
+
+	dev_info(&client->dev, " cal min=%d mean=%d max=%d\n",
+		calP->min, calP->mean, calP->max);
+	dev_info(&client->dev,
+		"TAOS: proximity threshold set to %d, basic mode\n",
+		chip->taos_settings.prox_thres);
+
+	/* back to the way they were */
+	chip->taos_settings.interrupt = tmp_irq_settings;
+}
+
+/* ---------- Sysfs Interface Functions ------------- */
+
+static ssize_t taos_device_id(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2671_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%s\n", chip->client->name);
+}
+
+static ssize_t taos_power_state_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2671_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%d\n", chip->taos_chip_status);
+}
+
+static ssize_t taos_power_state_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2671_chip *chip = indio_dev->dev_data;
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
+
+static ssize_t taos_prox_interrupt_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2671_chip *chip = indio_dev->dev_data;
+	if (chip->taos_settings.interrupt & 0x20)
+		return sprintf(buf, "%d\n", 1);
+	else
+		return sprintf(buf, "%d\n", 0);
+}
+
+static ssize_t taos_prox_interrupt_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2671_chip *chip = indio_dev->dev_data;
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if (value > 1)
+		return -EINVAL;
+	if (value)
+		chip->taos_settings.interrupt |= 0x20;
+	else
+		chip->taos_settings.interrupt &= 0x10;
+
+	return len;
+}
+
+static ssize_t taos_prox_thresh_high_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2671_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%d\n", chip->taos_settings.prox_thres);
+}
+
+static ssize_t taos_prox_thresh_high_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2671_chip *chip = indio_dev->dev_data;
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	chip->taos_settings.prox_thres = value;
+
+	return len;
+}
+
+/* sampling_frequency AKA persistence in data sheet */
+static ssize_t taos_persistence_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2671_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "0x%02X\n", chip->taos_settings.persistence);
+}
+
+static ssize_t taos_persistence_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2671_chip *chip = indio_dev->dev_data;
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	chip->taos_settings.persistence = value;
+
+	return len;
+}
+
+static ssize_t taos_persistence_available_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "0x0. - 0xF. (0 - 240)\n");
+}
+
+static ssize_t taos_do_prox_calibrate(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2671_chip *chip = indio_dev->dev_data;
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if (value == 1)
+		taos_prox_cal(chip->client);
+
+	return len;
+}
+
+static DEVICE_ATTR(name, S_IRUGO, taos_device_id, NULL);
+static DEVICE_ATTR(power_state, S_IRUGO | S_IWUSR,
+		taos_power_state_show, taos_power_state_store);
+
+static DEVICE_ATTR(proximity_calibrate, S_IWUSR, NULL, taos_do_prox_calibrate);
+
+static DEVICE_ATTR(sampling_frequency, S_IRUGO | S_IWUSR,
+		taos_persistence_show, taos_persistence_store);
+
+static DEVICE_ATTR(sampling_frequency_available, S_IRUGO,
+		taos_persistence_available_show, NULL);
+
+static DEVICE_ATTR(proximity_thresh_value, S_IRUGO | S_IWUSR,
+		taos_prox_thresh_high_show, taos_prox_thresh_high_store);
+
+static struct attribute *sysfs_attrs_ctrl[] = {
+	&dev_attr_name.attr,
+	&dev_attr_power_state.attr,
+	&dev_attr_sampling_frequency.attr,		/* persist*/
+	&dev_attr_sampling_frequency_available.attr,
+	&dev_attr_proximity_thresh_value.attr,	/*Prox thresh */
+	&dev_attr_proximity_calibrate.attr,
+	NULL
+};
+
+static struct attribute_group tsl2671_attribute_group = {
+	.attrs = sysfs_attrs_ctrl,
+};
+
+/*
+ * Run-time interrupt handler - this handler queues up
+ * the bottom-half tasklet, to handle all valid interrupts.
+ */
+static int taos_interrupt_th(struct iio_dev *dev_info,
+	int index,
+	s64 timestamp,
+	int not_test)
+{
+	struct tsl2671_chip *chip = dev_info->dev_data;
+
+	schedule_work(&chip->work_thresh);
+	return 0;
+}
+
+IIO_EVENT_SH(threshold, &taos_interrupt_th);
+
+IIO_EVENT_ATTR_SH(proximity_thresh_en,
+		  iio_event_threshold,
+		  taos_prox_interrupt_show,
+		  taos_prox_interrupt_store,
+		  STA_PRXINTR);
+
+static struct attribute *tsl2671_event_attributes[] = {
+	&iio_event_attr_proximity_thresh_en.dev_attr.attr,
+	NULL,
+};
+
+static struct attribute_group tsl2671_event_attribute_group = {
+	.attrs = tsl2671_event_attributes,
+};
+
+/* Use the default register values to identify the Taos device */
+static int taos_TSL2671_device(unsigned char *bufp)
+{
+	return ((bufp[TSL2671_CHIPID] & 0xf0) == 0x00);
+}
+
+/*
+ * Client probe function - When a valid device is found, the driver's device
+ * data structure is updated, and initialization completes successfully.
+ */
+static int __devinit taos_probe(struct i2c_client *clientp,
+	const struct i2c_device_id *idp)
+{
+	int i, ret = 0;
+	unsigned char buf[TSL2671_MAX_DEVICE_REGS];
+	static struct tsl2671_chip *chip;
+
+	if (!i2c_check_functionality(clientp->adapter,
+		I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_err(&clientp->dev,
+			"taos_probe() - i2c smbus byte data "
+			"functions unsupported\n");
+		return -EOPNOTSUPP;
+	}
+
+	chip = kzalloc(sizeof(struct tsl2671_chip), GFP_KERNEL);
+
+	chip->client = clientp;
+	i2c_set_clientdata(clientp, chip);
+
+	mutex_init(&chip->prox_mutex);
+
+	chip->taos_chip_status = TSL2671_CHIP_UNKNOWN;
+	memcpy(chip->taos_config, tsl2671_taos_config,
+		sizeof(chip->taos_config));
+
+	for (i = 0; i < TSL2671_MAX_DEVICE_REGS; i++) {
+		ret = i2c_smbus_write_byte(clientp,
+				(TSL2671_CMD_REG | (TSL2671_CNTRL + i)));
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
+	if (!taos_TSL2671_device(buf)) {
+		dev_info(&clientp->dev, "i2c device found but does not match "
+			"expected id in taos_probe()\n");
+		goto fail1;
+	}
+
+	ret = i2c_smbus_write_byte(clientp, (TSL2671_CMD_REG | TSL2671_CNTRL));
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
+	chip->iio_dev->attrs = &tsl2671_attribute_group;
+	chip->iio_dev->dev.parent = &clientp->dev;
+	chip->iio_dev->dev_data = (void *)(chip);
+	chip->iio_dev->num_interrupt_lines = 1;
+	chip->iio_dev->event_attrs = &tsl2671_event_attribute_group;
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
+						  "tsl2671");
+		if (ret)
+			goto fail1;
+
+		iio_add_event_to_list(&iio_event_threshold,
+			&chip->iio_dev->interrupts[0]->ev_list);
+	}
+
+	/* Load up the defaults
+	 * (these are can be changed in the device[x]/ABI) */
+	taos_defaults(chip);
+
+	/* Assume board info already established
+	chip->irq_no = IRQ_EINT4;
+	*/
+
+	INIT_WORK(&chip->work_thresh, taos_interrupt_bh);
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
+	struct tsl2671_chip *chip = i2c_get_clientdata(client);
+	int ret = 0;
+
+	mutex_lock(&chip->prox_mutex);
+
+	if (chip->taos_chip_status == TSL2671_CHIP_WORKING) {
+		ret = taos_chip_off(client);
+		chip->taos_chip_status = TSL2671_CHIP_SUSPENDED;
+	}
+
+	mutex_unlock(&chip->prox_mutex);
+	return ret;
+}
+
+static int taos_resume(struct i2c_client *client)
+{
+	struct tsl2671_chip *chip = i2c_get_clientdata(client);
+	int ret = 0;
+
+	mutex_lock(&chip->prox_mutex);
+
+	if (chip->taos_chip_status == TSL2671_CHIP_SUSPENDED)
+		ret = taos_chip_on(client);
+
+	mutex_unlock(&chip->prox_mutex);
+	return ret;
+}
+
+
+static int __devexit taos_remove(struct i2c_client *client)
+{
+	struct tsl2671_chip *chip = i2c_get_clientdata(client);
+
+	taos_chip_off(client);
+
+	if (chip->irq_no)
+		free_irq(chip->irq_no, chip->client->name);
+
+	flush_scheduled_work();
+
+	iio_device_unregister(chip->iio_dev);
+
+	kfree(chip);
+	return 0;
+}
+
+static struct i2c_device_id taos_idtable[] = {
+	{ "tsl2671", 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, taos_idtable);
+
+/* Driver definition */
+static struct i2c_driver taos_driver = {
+	.driver = {
+		.name = "tsl2671",
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
+MODULE_DESCRIPTION("TAOS tsl2671 proximity sensor driver");
+MODULE_LICENSE("GPL");
+
--
1.7.0.4

