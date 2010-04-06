Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab0DFKLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 06:11:30 -0400
Received: from smtp.nokia.com ([192.100.122.233]:22083 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab0DFKLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 06:11:23 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH 1/1] misc: bh1770glc: Driver for bh1770glc combined als and ps sensor
Date: Tue,  6 Apr 2010 13:10:54 +0300
Message-Id: <1270548654-7196-2-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1270548654-7196-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1270548654-7196-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 06 Apr 2010 10:10:57.0894 (UTC) FILETIME=[737AF860:01CAD571]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for combined ambient light and proximity sensor.
BH1770GLC and SW compatible SFH7770 sensors are supported.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/misc/Kconfig          |   12 +
 drivers/misc/Makefile         |    3 +
 drivers/misc/bh1770glc.h      |  169 ++++++++++++
 drivers/misc/bh1770glc_als.c  |  424 +++++++++++++++++++++++++++++
 drivers/misc/bh1770glc_core.c |  301 +++++++++++++++++++++
 drivers/misc/bh1770glc_ps.c   |  585 +++++++++++++++++++++++++++++++++++++++++
 include/linux/bh1770glc.h     |   39 +++
 7 files changed, 1533 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/bh1770glc.h
 create mode 100644 drivers/misc/bh1770glc_als.c
 create mode 100644 drivers/misc/bh1770glc_core.c
 create mode 100644 drivers/misc/bh1770glc_ps.c
 create mode 100644 include/linux/bh1770glc.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 2191c8d..4594703 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -311,6 +311,18 @@ config TI_DAC7512
 	  This driver can also be built as a module. If so, the module
 	  will be calles ti_dac7512.
 
+config BH1770GLC
+	 tristate "Rohm BH1770GLC ambient light and proximity sensor"
+	 depends on I2C
+	 default n
+	 ---help---
+	   Say Y here if you want to build a driver for BH1770GLC
+	   combined ambient light and proximity sensor chip.
+	   Driver supports also Osram SFH7770 version of the chip.
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called bh1770glc. If unsure, say N here.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 27c4843..5201667 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -2,6 +2,8 @@
 # Makefile for misc devices that really don't fit anywhere else.
 #
 
+bh1770glc-objs  := bh1770glc_core.o bh1770glc_als.o bh1770glc_ps.o
+
 obj-$(CONFIG_IBM_ASM)		+= ibmasm/
 obj-$(CONFIG_HDPU_FEATURES)	+= hdpuftrs/
 obj-$(CONFIG_AD525X_DPOT)	+= ad525x_dpot.o
@@ -25,6 +27,7 @@ obj-$(CONFIG_SENSORS_TSL2550)	+= tsl2550.o
 obj-$(CONFIG_EP93XX_PWM)	+= ep93xx_pwm.o
 obj-$(CONFIG_DS1682)		+= ds1682.o
 obj-$(CONFIG_TI_DAC7512)	+= ti_dac7512.o
+obj-$(CONFIG_BH1770GLC)		+= bh1770glc.o
 obj-$(CONFIG_C2PORT)		+= c2port/
 obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
 obj-y				+= eeprom/
diff --git a/drivers/misc/bh1770glc.h b/drivers/misc/bh1770glc.h
new file mode 100644
index 0000000..096777e
--- /dev/null
+++ b/drivers/misc/bh1770glc.h
@@ -0,0 +1,169 @@
+/*
+ * This file is part of the ROHM BH1770GLC / OSRAM SFH7770 sensor driver.
+ * Chip is combined proximity and ambient light sensor.
+ *
+ * Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
+ *
+ * Contact: Samu Onkalo <samu.p.onkalo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __BH1770GLC_HEADER__
+#define __BH1770GLC_HEADER__
+
+#define BHCHIP_ALS_CONTROL	0x80 /* ALS operation mode control */
+#define BHCHIP_PS_CONTROL	0x81 /* PS operation mode control */
+#define BHCHIP_I_LED		0x82 /* active LED and LED1, LED2 current */
+#define BHCHIP_I_LED3		0x83 /* LED3 current setting */
+#define BHCHIP_ALS_PS_MEAS	0x84 /* Forced mode trigger */
+#define BHCHIP_PS_MEAS_RATE	0x85 /* PS meas. rate at stand alone mode */
+#define BHCHIP_ALS_MEAS_RATE	0x86 /* ALS meas. rate at stand alone mode */
+#define BHCHIP_PART_ID		0x8a /* Part number and revision ID */
+#define BHCHIP_MANUFACT_ID	0x8b /* Manufacturerer ID */
+#define BHCHIP_ALS_DATA_0	0x8c /* ALS DATA low byte */
+#define BHCHIP_ALS_DATA_1	0x8d /* ALS DATA high byte */
+#define BHCHIP_ALS_PS_STATUS	0x8e /* Measurement data and int status */
+#define BHCHIP_PS_DATA_LED1	0x8f /* PS data from LED1 */
+#define BHCHIP_PS_DATA_LED2	0x90 /* PS data from LED2 */
+#define BHCHIP_PS_DATA_LED3	0x91 /* PS data from LED3 */
+#define BHCHIP_INTERRUPT	0x92 /* Interrupt setting */
+#define BHCHIP_PS_TH_LED1	0x93 /* PS interrupt threshold for LED1 */
+#define BHCHIP_PS_TH_LED2	0x94 /* PS interrupt threshold for LED2 */
+#define BHCHIP_PS_TH_LED3	0x95 /* PS interrupt threshold for LED3 */
+#define BHCHIP_ALS_TH_UP_0	0x96 /* ALS upper threshold low byte */
+#define BHCHIP_ALS_TH_UP_1	0x97 /* ALS upper threshold high byte */
+#define BHCHIP_ALS_TH_LOW_0	0x98 /* ALS lower threshold low byte */
+#define BHCHIP_ALS_TH_LOW_1	0x99 /* ALS lower threshold high byte */
+
+/* MANUFACT_ID */
+#define BHCHIP_MANUFACT_ROHM	0x01
+#define BHCHIP_MANUFACT_OSRAM	0x03
+
+/* PART_ID */
+#define BHCHIP_PART		0x90
+#define BHCHIP_PART_MASK	0xf0
+#define BHCHIP_REV_MASK		0x0f
+#define BHCHIP_REV_SHIFT	0
+#define BHCHIP_REV_0		0x00
+
+/* Operating modes for both */
+#define BHCHIP_STANDBY		0x00
+#define BHCHIP_FORCED		0x02
+#define BHCHIP_STANDALONE	0x03
+
+#define BHCHIP_PS_TRIG_MEAS	(1 << 0)
+#define BHCHIP_ALS_TRIG_MEAS	(1 << 1)
+
+/* Interrupt control */
+#define BHCHIP_INT_OUTPUT_MODE	(1 << 3) /* 0 = latched */
+#define BHCHIP_INT_POLARITY	(1 << 2) /* 1 = active high */
+#define BHCHIP_INT_ALS_ENA	(1 << 1)
+#define BHCHIP_INT_PS_ENA	(1 << 0)
+
+/* Interrupt status */
+#define BHCHIP_INT_LED1_DATA	(1 << 0)
+#define BHCHIP_INT_LED1_INT	(1 << 1)
+#define BHCHIP_INT_LED2_DATA	(1 << 2)
+#define BHCHIP_INT_LED2_INT	(1 << 3)
+#define BHCHIP_INT_LED3_DATA	(1 << 4)
+#define BHCHIP_INT_LED3_INT	(1 << 5)
+#define BHCHIP_INT_LEDS_INT	((1 << 1) | (1 << 3) | (1 << 5))
+#define BHCHIP_INT_ALS_DATA	(1 << 6)
+#define BHCHIP_INT_ALS_INT	(1 << 7)
+
+#define BHCHIP_DISABLE		0
+#define BHCHIP_ENABLE		1
+
+ /* Following are milliseconds */
+#define BHCHIP_ALS_DEFAULT_RATE	200
+#define BHCHIP_PS_DEFAULT_RATE	40
+#define BHCHIP_PS_DEF_RATE_THRESH 200
+#define BHCHIP_PS_INIT_DELAY    15
+#define BHCHIP_STARTUP_DELAY	50
+
+#define BHCHIP_ALS_RANGE	65535
+#define BHCHIP_PS_RANGE		255
+#define BHCHIP_CALIB_SCALER	1000
+#define BHCHIP_ALS_NEUTRAL_CALIB_VALUE (1 * BHCHIP_CALIB_SCALER)
+#define BHCHIP_PS_NEUTRAL_CALIB_VALUE  (1 * BHCHIP_CALIB_SCALER)
+#define BHCHIP_ALS_DEF_SENS	10
+#define BHCHIP_ALS_DEF_THRES	1000
+#define BHCHIP_PS_DEF_THRES	20
+
+#define ALS_NBR_FORMAT		512
+/* coef as decimal = ALS_COEF / *(ALS_NBR_FORMAT ^ 2) */
+#define ALS_COEF		1536
+/* Scaler coefficient at zero level */
+#define ALS_ZERO_LEVEL		(ALS_NBR_FORMAT / 4)
+
+#define PS_ABOVE_THRESHOLD	1
+#define PS_BELOW_THRESHOLD	0
+
+#define BHCHIP_PS_CHANNELS 3
+
+struct bh1770glc_chip {
+	struct i2c_client		*client;
+	struct bh1770glc_platform_data	*pdata;
+	struct mutex			mutex; /* avoid parallel access */
+	struct regulator_bulk_data	regs[2];
+
+	bool				int_mode_ps;
+	bool				int_mode_als;
+
+	wait_queue_head_t		als_misc_wait; /* WQ for ALS part */
+	wait_queue_head_t		ps_misc_wait; /* WQ for PS part */
+	struct delayed_work		ps_work; /* For ps low threshold */
+
+	char				chipname[10];
+	u8				revision;
+
+	u32	als_calib;
+	int	als_rate;
+	int	als_mode;
+	int	als_users;
+	u16	als_data;
+	u16	als_threshold_hi;
+	u16	als_threshold_lo;
+	u16	als_sens;
+	loff_t	als_offset;
+
+	loff_t	ps_offset;
+	u32	ps_calib[BHCHIP_PS_CHANNELS];
+	int	ps_rate;
+	int	ps_rate_threshold;
+	int	ps_mode;
+	int	ps_users;
+	u8	ps_data[BHCHIP_PS_CHANNELS];
+	u8	ps_thresholds[BHCHIP_PS_CHANNELS];
+	u8	ps_leds[BHCHIP_PS_CHANNELS];
+	u8	ps_channels; /* nbr of leds */
+};
+
+extern struct bh1770glc_chip *bh1770glc;
+
+extern int bh1770glc_ps_mode(struct bh1770glc_chip *chip, int mode);
+extern int bh1770glc_ps_init(struct bh1770glc_chip *chip);
+extern int bh1770glc_ps_destroy(struct bh1770glc_chip *chip);
+extern void bh1770glc_ps_interrupt_handler(struct bh1770glc_chip *chip,
+					int status);
+
+extern int bh1770glc_als_mode(struct bh1770glc_chip *chip, int mode);
+extern int bh1770glc_als_init(struct bh1770glc_chip *chip);
+extern int bh1770glc_als_destroy(struct bh1770glc_chip *chip);
+extern void bh1770glc_als_interrupt_handler(struct bh1770glc_chip *chip,
+					int status);
+#endif
diff --git a/drivers/misc/bh1770glc_als.c b/drivers/misc/bh1770glc_als.c
new file mode 100644
index 0000000..81f41c6
--- /dev/null
+++ b/drivers/misc/bh1770glc_als.c
@@ -0,0 +1,424 @@
+/*
+ * This file is part of the ROHM BH1770GLC / OSRAM SFH7770 sensor driver.
+ * Chip is combined proximity and ambient light sensor.
+ *
+ * Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
+ *
+ * Contact: Samu Onkalo <samu.p.onkalo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <linux/miscdevice.h>
+#include <linux/poll.h>
+#include <linux/bh1770glc.h>
+#include <linux/uaccess.h>
+#include <linux/delay.h>
+#include <linux/regulator/consumer.h>
+#include "bh1770glc.h"
+
+/* Supported stand alone rates in ms from chip data sheet */
+static s16 als_rates[] = {100, 200, 500, 1000, 2000};
+
+/* chip->mutex must be locked during this function */
+static int bh1770glc_als_interrupt_control(struct bh1770glc_chip *chip,
+					   int als)
+{
+	chip->int_mode_als = als;
+
+	/* Set ALS interrupt mode, interrupt active low, latched */
+	return i2c_smbus_write_byte_data(chip->client,
+					BHCHIP_INTERRUPT,
+					(als << 1) | (chip->int_mode_ps << 0));
+}
+
+int bh1770glc_als_mode(struct bh1770glc_chip *chip, int mode)
+{
+	int r;
+
+	r = i2c_smbus_write_byte_data(chip->client, BHCHIP_ALS_CONTROL, mode);
+
+	if (r == 0)
+		chip->als_mode = mode;
+
+	return r;
+}
+
+static int bh1770glc_als_rate(struct bh1770glc_chip *chip, int rate)
+{
+	int ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(als_rates); i++)
+		if (als_rates[i] == rate) {
+			ret = i2c_smbus_write_byte_data(chip->client,
+							BHCHIP_ALS_MEAS_RATE,
+							i);
+			if (ret == 0)
+				chip->als_rate = rate;
+			break;
+		}
+	return ret;
+}
+
+static int bh1770glc_als_set_threshold(struct bh1770glc_chip *chip,
+				int threshold_hi,
+				int threshold_lo)
+{
+	u8 data[4];
+	int ret;
+
+	chip->als_threshold_hi = threshold_hi;
+	chip->als_threshold_lo = threshold_lo;
+
+	data[0] = threshold_hi;
+	data[1] = threshold_hi >> 8;
+	data[2] = threshold_lo;
+	data[3] = threshold_lo >> 8;
+
+	ret = i2c_smbus_write_i2c_block_data(chip->client,
+					BHCHIP_ALS_TH_UP_0,
+					ARRAY_SIZE(data),
+					data);
+	return ret;
+}
+
+static int bh1770glc_als_calc_thresholds(struct bh1770glc_chip *chip, u16 data)
+{
+	int scaler;
+	int hi_thres;
+	int lo_thres;
+	int sens;
+	int ret;
+
+	/*
+	 * Recalculate new threshold limits to simulate delta measurement
+	 * mode. New limits are relative to latest measurement data.
+	 */
+	scaler = ((int)data * ALS_COEF) / ALS_NBR_FORMAT + ALS_ZERO_LEVEL;
+	sens = chip->als_sens * scaler / ALS_NBR_FORMAT;
+
+	hi_thres = min(data + sens, BHCHIP_ALS_RANGE);
+	lo_thres = max(data - sens, 0);
+
+	mutex_lock(&chip->mutex);
+	ret = bh1770glc_als_set_threshold(chip,
+					hi_thres,
+					lo_thres);
+	mutex_unlock(&chip->mutex);
+
+	return ret;
+}
+
+static int bh1770glc_als_read_result(struct bh1770glc_chip *chip)
+{
+	u16 data;
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(chip->client, BHCHIP_ALS_DATA_0);
+	if (ret < 0)
+		goto exit;
+
+	data = ret & 0xff;
+	ret = i2c_smbus_read_byte_data(chip->client, BHCHIP_ALS_DATA_1);
+	if (ret < 0)
+		goto exit;
+
+	data = data | ((ret & 0xff) << 8);
+	chip->als_data = data;
+	chip->als_offset += sizeof(struct bh1770glc_als);
+
+	ret = bh1770glc_als_calc_thresholds(chip, data);
+exit:
+	return ret;
+}
+
+void bh1770glc_als_interrupt_handler(struct bh1770glc_chip *chip, int status)
+{
+	if (chip->int_mode_als)
+		if (status & BHCHIP_INT_ALS_INT) {
+			bh1770glc_als_read_result(chip);
+			wake_up_interruptible(&bh1770glc->als_misc_wait);
+		}
+}
+
+static ssize_t bh1770glc_als_read(struct file *file, char __user *buf,
+			size_t count, loff_t *offset)
+{
+	struct bh1770glc_als als;
+	struct bh1770glc_chip *chip = bh1770glc;
+	u32 lux;
+
+	if (count < sizeof(als))
+		return -EINVAL;
+
+	if (*offset >= chip->als_offset) {
+		if (file->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+		if (wait_event_interruptible(bh1770glc->als_misc_wait,
+						(*offset < chip->als_offset)))
+			return -ERESTARTSYS;
+	}
+	lux = ((u32)chip->als_data * chip->als_calib) /
+		BHCHIP_CALIB_SCALER;
+	lux = min(lux, (u32)BHCHIP_ALS_RANGE);
+
+	als.lux = lux;
+
+	*offset = chip->als_offset;
+
+	return copy_to_user(buf, &als, sizeof(als)) ? -EFAULT : sizeof(als);
+}
+
+static int bh1770glc_als_open(struct inode *inode, struct file *file)
+{
+
+	struct bh1770glc_chip *chip = bh1770glc;
+	int ret = 0;
+
+	mutex_lock(&chip->mutex);
+	if (!chip->als_users) {
+		ret = regulator_bulk_enable(ARRAY_SIZE(chip->regs),
+					chip->regs);
+		if (ret < 0)
+			goto release_lock;
+
+		if (!chip->ps_users)
+			msleep(BHCHIP_STARTUP_DELAY);
+
+		ret = bh1770glc_als_mode(chip, BHCHIP_STANDALONE);
+		if (ret < 0)
+			goto exit;
+
+		ret = bh1770glc_als_rate(chip, chip->als_rate);
+		if (ret < 0)
+			goto exit;
+
+		ret = bh1770glc_als_interrupt_control(chip, BHCHIP_ENABLE);
+		if (ret < 0)
+			goto exit;
+	}
+	/* Trig measurement and refresh the measurement result */
+	bh1770glc_als_set_threshold(chip, BHCHIP_ALS_DEF_THRES,
+				BHCHIP_ALS_DEF_THRES);
+
+	if (ret == 0)
+		chip->als_users++;
+exit:
+	if (ret < 0)
+		regulator_bulk_disable(ARRAY_SIZE(chip->regs), chip->regs);
+release_lock:
+	file->f_pos = chip->als_offset;
+	/* In case of two or more user, provide newest results available */
+	if (chip->als_users > 1 &&
+	    file->f_pos >= sizeof(struct bh1770glc_als))
+		file->f_pos -= sizeof(struct bh1770glc_als);
+
+	mutex_unlock(&chip->mutex);
+	return ret;
+}
+
+static unsigned int bh1770glc_als_poll(struct file *file, poll_table *wait)
+{
+	poll_wait(file, &bh1770glc->als_misc_wait, wait);
+	if (file->f_pos < bh1770glc->als_offset)
+		return POLLIN | POLLRDNORM;
+	return 0;
+}
+
+static int bh1770glc_als_close(struct inode *inode, struct file *file)
+{
+	struct bh1770glc_chip *chip = bh1770glc;
+	mutex_lock(&chip->mutex);
+	if (!--chip->als_users) {
+		bh1770glc_als_interrupt_control(chip, BHCHIP_DISABLE);
+		bh1770glc_als_mode(chip, BHCHIP_STANDBY);
+		regulator_bulk_disable(ARRAY_SIZE(chip->regs), chip->regs);
+	}
+	mutex_unlock(&chip->mutex);
+	return 0;
+}
+
+
+/* SYSFS interface */
+static ssize_t bh1770glc_als_calib_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct bh1770glc_chip *chip = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", chip->als_calib);
+}
+
+static ssize_t bh1770glc_als_calib_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t len)
+{
+	struct bh1770glc_chip *chip = dev_get_drvdata(dev);
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	chip->als_calib = value;
+
+	return len;
+}
+
+static ssize_t bh1770glc_get_als_mode(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bh1770glc_chip *chip =  dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", chip->als_mode);
+}
+
+static ssize_t bh1770glc_get_als_rate(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bh1770glc_chip *chip =  dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", chip->als_rate);
+}
+
+static ssize_t bh1770glc_set_als_rate(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct bh1770glc_chip *chip =  dev_get_drvdata(dev);
+	unsigned long rate;
+	int ret;
+
+	if (strict_strtoul(buf, 0, &rate))
+		return -EINVAL;
+
+	mutex_lock(&chip->mutex);
+	ret = bh1770glc_als_rate(chip, rate);
+	mutex_unlock(&chip->mutex);
+
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static ssize_t bh1770glc_get_als_sens(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bh1770glc_chip *chip =  dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", chip->als_sens);
+}
+
+static ssize_t bh1770glc_set_als_sens(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct bh1770glc_chip *chip =  dev_get_drvdata(dev);
+	int ret;
+	unsigned long sens;
+
+	if (strict_strtoul(buf, 0, &sens))
+		return -EINVAL;
+
+	chip->als_sens = sens;
+
+	/* Trick measurement by setting default thresholds */
+	mutex_lock(&chip->mutex);
+	ret = bh1770glc_als_set_threshold(chip,
+					BHCHIP_ALS_DEF_THRES,
+					BHCHIP_ALS_DEF_THRES);
+
+	mutex_unlock(&chip->mutex);
+	if (ret < 0)
+		return ret;
+	return count;
+}
+
+static DEVICE_ATTR(als_calib, S_IRUGO | S_IWUSR, bh1770glc_als_calib_show,
+						 bh1770glc_als_calib_store);
+static DEVICE_ATTR(als_mode, S_IRUGO , bh1770glc_get_als_mode, NULL);
+static DEVICE_ATTR(als_rate, S_IRUGO | S_IWUSR, bh1770glc_get_als_rate,
+						bh1770glc_set_als_rate);
+static DEVICE_ATTR(als_sens, S_IRUGO | S_IWUSR, bh1770glc_get_als_sens,
+						bh1770glc_set_als_sens);
+
+static struct attribute *sysfs_attrs[] = {
+	&dev_attr_als_calib.attr,
+	&dev_attr_als_mode.attr,
+	&dev_attr_als_rate.attr,
+	&dev_attr_als_sens.attr,
+	NULL
+};
+
+static struct attribute_group bh1770glc_attribute_group = {
+	.attrs = sysfs_attrs
+};
+
+static const struct file_operations bh1770glc_als_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.read		= bh1770glc_als_read,
+	.poll		= bh1770glc_als_poll,
+	.open		= bh1770glc_als_open,
+	.release	= bh1770glc_als_close,
+};
+
+static struct miscdevice bh1770glc_als_miscdevice = {
+       .minor = MISC_DYNAMIC_MINOR,
+       .name  = "bh1770glc_als",
+       .fops  = &bh1770glc_als_fops
+};
+
+int bh1770glc_als_init(struct bh1770glc_chip *chip)
+{
+	int err;
+	err = bh1770glc_als_mode(chip, BHCHIP_STANDBY);
+	if (err < 0)
+		goto fail;
+
+	err = bh1770glc_als_interrupt_control(chip, BHCHIP_DISABLE);
+	if (err < 0)
+		goto fail;
+
+	chip->als_rate = BHCHIP_ALS_DEFAULT_RATE;
+
+	bh1770glc_als_miscdevice.parent = &chip->client->dev;
+	err = misc_register(&bh1770glc_als_miscdevice);
+	if (err < 0) {
+		dev_err(&chip->client->dev, "Device registration failed\n");
+		goto fail;
+	}
+
+	err = sysfs_create_group(&chip->client->dev.kobj,
+				&bh1770glc_attribute_group);
+	if (err < 0) {
+		dev_err(&chip->client->dev, "Sysfs registration failed\n");
+		goto fail2;
+	}
+	return 0;
+fail2:
+	misc_deregister(&bh1770glc_als_miscdevice);
+fail:
+	return err;
+}
+
+int bh1770glc_als_destroy(struct bh1770glc_chip *chip)
+{
+	sysfs_remove_group(&chip->client->dev.kobj,
+			&bh1770glc_attribute_group);
+	misc_deregister(&bh1770glc_als_miscdevice);
+	return 0;
+}
diff --git a/drivers/misc/bh1770glc_core.c b/drivers/misc/bh1770glc_core.c
new file mode 100644
index 0000000..36d0443
--- /dev/null
+++ b/drivers/misc/bh1770glc_core.c
@@ -0,0 +1,301 @@
+/*
+ * This file is part of the ROHM BH1770GLC / OSRAM SFH7770 sensor driver.
+ * Chip is combined proximity and ambient light sensor.
+ *
+ * Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
+ *
+ * Contact: Samu Onkalo <samu.p.onkalo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/mutex.h>
+#include <linux/bh1770glc.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+#include "bh1770glc.h"
+
+struct bh1770glc_chip *bh1770glc;
+
+static const char reg_vcc[] = "Vcc";
+static const char reg_vleds[] = "Vleds";
+
+static int bh1770glc_detect(struct bh1770glc_chip *chip)
+{
+	struct i2c_client *client = chip->client;
+	s32 ret;
+	u8 manu;
+	u8 part;
+
+	ret = i2c_smbus_read_byte_data(client, BHCHIP_MANUFACT_ID);
+	if (ret < 0)
+		goto error;
+
+	manu = (u8)ret;
+
+	ret = i2c_smbus_read_byte_data(client, BHCHIP_PART_ID);
+	if (ret < 0)
+		goto error;
+	part = (u8)ret;
+	chip->revision = (part & BHCHIP_REV_MASK) >> BHCHIP_REV_SHIFT;
+
+	if ((manu == BHCHIP_MANUFACT_ROHM) &&
+	    ((part & BHCHIP_PART_MASK)	== BHCHIP_PART)) {
+		snprintf(chip->chipname, sizeof(chip->chipname), "BH1770GLC");
+		return 0;
+	}
+
+	if ((manu == BHCHIP_MANUFACT_OSRAM) &&
+	    ((part & BHCHIP_PART_MASK)	== BHCHIP_PART)) {
+		snprintf(chip->chipname, sizeof(chip->chipname), "SFH7770");
+		return 0;
+	}
+
+	ret = -ENODEV;
+error:
+	dev_dbg(&client->dev, "BH1770GLC or SFH7770 not found\n");
+
+	return ret;
+}
+
+/* This is threaded irq handler */
+static irqreturn_t bh1770glc_irq(int irq, void *data)
+{
+	struct bh1770glc_chip *chip = data;
+	int status;
+
+	status = i2c_smbus_read_byte_data(chip->client, BHCHIP_ALS_PS_STATUS);
+
+	/* Acknowledge interrupt by reading this register */
+	i2c_smbus_read_byte_data(chip->client, BHCHIP_INTERRUPT);
+
+	bh1770glc_als_interrupt_handler(chip, status);
+	bh1770glc_ps_interrupt_handler(chip, status);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit bh1770glc_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct bh1770glc_chip *chip;
+	int err;
+	int i;
+
+	chip = kzalloc(sizeof *chip, GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	bh1770glc = chip;
+
+	init_waitqueue_head(&chip->ps_misc_wait);
+	init_waitqueue_head(&chip->als_misc_wait);
+
+	i2c_set_clientdata(client, chip);
+	chip->client  = client;
+
+	mutex_init(&chip->mutex);
+	chip->pdata	= client->dev.platform_data;
+	chip->als_calib = BHCHIP_ALS_NEUTRAL_CALIB_VALUE;
+	chip->als_sens	= BHCHIP_ALS_DEF_SENS;
+	for (i = 0; i < BHCHIP_PS_CHANNELS; i++)
+		chip->ps_calib[i] = BHCHIP_PS_NEUTRAL_CALIB_VALUE;
+
+	/*
+	 * Platform data contains led configuration and safety limits.
+	 * Too strong current can damage HW permanently.
+	 * Platform data filled with zeros causes minimum current.
+	 */
+	if (chip->pdata == NULL) {
+		dev_err(&client->dev, "platform data is mandatory\n");
+		err = -EINVAL;
+		goto fail1;
+	}
+
+	if (chip->pdata->setup_resources) {
+		err = chip->pdata->setup_resources();
+		if (err) {
+			err = -EINVAL;
+			goto fail1;
+		}
+	}
+
+	switch (chip->pdata->leds) {
+	case BH1770GLC_LED1:
+		chip->ps_channels = 1;
+		break;
+	case BH1770GLC_LED12:
+	case BH1770GLC_LED13:
+		chip->ps_channels = 2;
+		break;
+	case BH1770GLC_LED123:
+		chip->ps_channels = 3;
+		break;
+	default:
+		err = -EINVAL;
+		goto fail1;
+	}
+
+	chip->regs[0].supply = reg_vcc;
+	chip->regs[1].supply = reg_vleds;
+
+	err = regulator_bulk_get(&client->dev,
+				 ARRAY_SIZE(chip->regs), chip->regs);
+	if (err < 0) {
+		dev_err(&client->dev, "Cannot get regulators\n");
+		goto fail1;
+	}
+
+	err = regulator_bulk_enable(ARRAY_SIZE(chip->regs), chip->regs);
+	if (err < 0) {
+		dev_err(&client->dev, "Cannot enable regulators\n");
+		goto fail2;
+	}
+
+	err = bh1770glc_detect(chip);
+	if (err < 0)
+		goto fail3;
+
+	err = bh1770glc_als_init(chip);
+	if (err < 0)
+		goto fail3;
+
+	err = bh1770glc_ps_init(chip);
+	if (err < 0)
+		goto fail4;
+
+	err = request_threaded_irq(client->irq, NULL,
+				bh1770glc_irq,
+				IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				"bh1770glc", chip);
+	if (err) {
+		dev_err(&client->dev, "could not get IRQ %d\n",
+			client->irq);
+		goto fail5;
+	}
+	regulator_bulk_disable(ARRAY_SIZE(chip->regs), chip->regs);
+	return err;
+fail5:
+	bh1770glc_ps_destroy(chip);
+fail4:
+	bh1770glc_als_destroy(chip);
+fail3:
+	regulator_bulk_disable(ARRAY_SIZE(chip->regs), chip->regs);
+fail2:
+	regulator_bulk_free(ARRAY_SIZE(chip->regs), chip->regs);
+fail1:
+	kfree(chip);
+	return err;
+}
+
+static int __devexit bh1770glc_remove(struct i2c_client *client)
+{
+	struct bh1770glc_chip *chip = i2c_get_clientdata(client);
+
+	free_irq(client->irq, chip);
+
+	if (chip->pdata && chip->pdata->release_resources)
+		chip->pdata->release_resources();
+
+	bh1770glc_als_destroy(chip);
+	bh1770glc_ps_destroy(chip);
+	regulator_bulk_free(ARRAY_SIZE(chip->regs), chip->regs);
+	kfree(chip);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int bh1770glc_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	struct bh1770glc_chip *chip = i2c_get_clientdata(client);
+
+	mutex_lock(&chip->mutex);
+	if (chip->als_users)
+		bh1770glc_als_mode(chip, BHCHIP_STANDBY);
+	if (chip->ps_users)
+		bh1770glc_ps_mode(chip, BHCHIP_STANDBY);
+	mutex_unlock(&chip->mutex);
+	return 0;
+}
+
+static int bh1770glc_resume(struct i2c_client *client)
+{
+	struct bh1770glc_chip *chip = i2c_get_clientdata(client);
+
+	mutex_lock(&chip->mutex);
+	if (chip->als_users)
+		bh1770glc_als_mode(chip, BHCHIP_STANDALONE);
+	if (chip->ps_users)
+		bh1770glc_ps_mode(chip, BHCHIP_STANDALONE);
+	mutex_unlock(&chip->mutex);
+	return 0;
+}
+
+static void bh1770glc_shutdown(struct i2c_client *client)
+{
+	struct bh1770glc_chip *chip = i2c_get_clientdata(client);
+
+	bh1770glc_als_mode(chip, BHCHIP_STANDBY);
+	bh1770glc_ps_mode(chip, BHCHIP_STANDBY);
+}
+
+#else
+#define bh1770glc_suspend  NULL
+#define bh1770glc_shutdown NULL
+#define bh1770glc_resume   NULL
+#endif
+
+static const struct i2c_device_id bh1770glc_id[] = {
+	{"bh1770glc", 0 },
+	{"SFH7770", 0 },
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, bh1770glc_id);
+
+static struct i2c_driver bh1770glc_driver = {
+	.driver	 = {
+		.name	= "bh1770glc",
+		.owner	= THIS_MODULE,
+	},
+	.suspend  = bh1770glc_suspend,
+	.shutdown = bh1770glc_shutdown,
+	.resume	  = bh1770glc_resume,
+	.probe	  = bh1770glc_probe,
+	.remove	  = __devexit_p(bh1770glc_remove),
+	.id_table = bh1770glc_id,
+};
+
+static int __init bh1770glc_init(void)
+{
+	return i2c_add_driver(&bh1770glc_driver);
+}
+
+static void __exit bh1770glc_exit(void)
+{
+	i2c_del_driver(&bh1770glc_driver);
+}
+
+MODULE_DESCRIPTION("BH1770GLC combined ALS and proximity sensor");
+MODULE_AUTHOR("Samu Onkalo, Nokia Corporation");
+MODULE_LICENSE("GPL v2");
+
+module_init(bh1770glc_init);
+module_exit(bh1770glc_exit);
diff --git a/drivers/misc/bh1770glc_ps.c b/drivers/misc/bh1770glc_ps.c
new file mode 100644
index 0000000..5e68efe
--- /dev/null
+++ b/drivers/misc/bh1770glc_ps.c
@@ -0,0 +1,585 @@
+/*
+ * This file is part of the ROHM BH1770GLC / OSRAM SFH7770 sensor driver.
+ * Chip is combined proximity and ambient light sensor.
+ *
+ * Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
+ *
+ * Contact: Samu Onkalo <samu.p.onkalo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <linux/miscdevice.h>
+#include <linux/poll.h>
+#include <linux/bh1770glc.h>
+#include <linux/uaccess.h>
+#include <linux/delay.h>
+#include <linux/regulator/consumer.h>
+#include <linux/workqueue.h>
+#include <linux/jiffies.h>
+#include "bh1770glc.h"
+
+/* Supported stand alone rates in ms from chip data sheet */
+static s16 ps_rates[] = {10, 20, 30, 40, 70, 100, 200, 500, 1000, 2000};
+
+/* Supported IR-led currents in mA */
+static const u8 ps_curr_ma[] = {5, 10, 20, 50, 100, 150, 200};
+
+/* chip->mutex must be locked during this function */
+static int bh1770glc_ps_interrupt_control(struct bh1770glc_chip *chip, int ps)
+{
+	chip->int_mode_ps = ps;
+
+	/* Set PS interrupt mode, interrupt active low, latched */
+	return i2c_smbus_write_byte_data(chip->client,
+					BHCHIP_INTERRUPT,
+					(chip->int_mode_als << 1) | (ps << 0));
+}
+
+/* LEDs are controlled by the chip during proximity scanning */
+static int bh1770glc_led_cfg(struct bh1770glc_chip *chip, u8 ledcurr[3])
+{
+	u8 ledcfg;
+	int ret, i;
+
+	ledcfg = chip->pdata->leds;
+
+	for (i = 0; i < BHCHIP_PS_CHANNELS; i++)
+		if (ledcurr[i] > chip->pdata->led_max_curr)
+			return -EINVAL;
+
+	for (i = 0; i < BHCHIP_PS_CHANNELS; i++)
+		chip->ps_leds[i] = ledcurr[i];
+
+	/* LED cfg, current for leds 1 and 2 */
+	ret = i2c_smbus_write_byte_data(chip->client,
+					BHCHIP_I_LED,
+					(ledcfg << 6) | (ledcurr[1] << 3) |
+					 ledcurr[0]);
+	if (ret < 0)
+		goto fail;
+
+	/* Current for led 3*/
+	ret = i2c_smbus_write_byte_data(chip->client,
+					BHCHIP_I_LED3,
+					ledcurr[2]);
+fail:
+	return ret;
+}
+
+int bh1770glc_ps_mode(struct bh1770glc_chip *chip, int mode)
+{
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(chip->client, BHCHIP_PS_CONTROL, mode);
+	if (ret == 0)
+		chip->ps_mode = mode;
+	return ret;
+}
+
+static int bh1770glc_ps_rates(struct bh1770glc_chip *chip, int rate,
+			int rate_threshold)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ps_rates); i++) {
+		if (ps_rates[i] == rate) {
+			chip->ps_rate = i;
+			break;
+		}
+	}
+	if (i == ARRAY_SIZE(ps_rates))
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(ps_rates); i++) {
+		if (ps_rates[i] == rate_threshold) {
+			chip->ps_rate_threshold = i;
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
+static int bh1770glc_ps_rate(struct bh1770glc_chip *chip, int mode)
+{
+	int ret;
+	int rate;
+
+	rate = (mode == PS_ABOVE_THRESHOLD) ?
+		chip->ps_rate_threshold : chip->ps_rate;
+
+	ret = i2c_smbus_write_byte_data(chip->client,
+					BHCHIP_PS_MEAS_RATE,
+					rate);
+	return ret;
+}
+
+static int bh1770glc_ps_read_result(struct bh1770glc_chip *chip)
+{
+	int ret;
+	int i;
+
+	mutex_lock(&chip->mutex);
+	for (i = 0; i < ARRAY_SIZE(chip->ps_data); i++) {
+		ret = i2c_smbus_read_byte_data(chip->client,
+					BHCHIP_PS_DATA_LED1 + i);
+		if (ret < 0)
+			goto out;
+		chip->ps_data[i] = ret;
+	}
+	chip->ps_offset += sizeof(struct bh1770glc_ps);
+out:
+	mutex_unlock(&chip->mutex);
+	return ret;
+}
+
+static int bh1770glc_ps_set_thresholds(struct bh1770glc_chip *chip)
+{
+	int ret, i;
+	u8 data[BHCHIP_PS_CHANNELS];
+	u32 tmp;
+
+	for (i = 0; i < BHCHIP_PS_CHANNELS; i++) {
+		tmp = ((u32)chip->ps_thresholds[i] * BHCHIP_CALIB_SCALER) /
+			chip->ps_calib[i];
+		if (tmp > BHCHIP_PS_RANGE)
+			tmp = BHCHIP_PS_RANGE;
+		data[i] = tmp;
+	}
+
+	ret = i2c_smbus_write_i2c_block_data(chip->client,
+					 BHCHIP_PS_TH_LED1,
+					 BHCHIP_PS_CHANNELS,
+					 data);
+	return ret;
+}
+
+static ssize_t bh1770glc_ps_read(struct file *file, char __user *buf,
+			size_t count, loff_t *offset)
+{
+	struct bh1770glc_ps ps;
+	struct bh1770glc_chip *chip = bh1770glc;
+	int i;
+	u16 data[BHCHIP_PS_CHANNELS];
+
+	if (count < sizeof(ps))
+		return -EINVAL;
+
+	if (*offset >= chip->ps_offset) {
+		if (file->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+		if (wait_event_interruptible(bh1770glc->ps_misc_wait,
+						(*offset < chip->ps_offset)))
+			return -ERESTARTSYS;
+	}
+
+	for (i = 0; i < BHCHIP_PS_CHANNELS; i++) {
+		data[i] = ((u32)chip->ps_data[i] * chip->ps_calib[i]) /
+			BHCHIP_CALIB_SCALER;
+		if (data[i] > BHCHIP_PS_RANGE)
+			data[i] = BHCHIP_PS_RANGE;
+	}
+
+	ps.led1 = data[0];
+	ps.led2 = data[1];
+	ps.led3 = data[2];
+
+	*offset = chip->ps_offset;
+
+	return copy_to_user(buf, &ps, sizeof(ps)) ? -EFAULT : sizeof(ps);
+}
+
+static void bh1770glc_ps_work(struct work_struct *work)
+{
+	struct bh1770glc_chip *chip =
+		container_of(work, struct bh1770glc_chip, ps_work.work);
+
+	bh1770glc_ps_rate(chip, PS_BELOW_THRESHOLD);
+	bh1770glc_ps_read_result(chip);
+	wake_up_interruptible(&chip->ps_misc_wait);
+}
+
+void bh1770glc_ps_interrupt_handler(struct bh1770glc_chip *chip, int status)
+{
+	if (chip->int_mode_ps)
+		if (status & BHCHIP_INT_LEDS_INT) {
+			int rate = ps_rates[chip->ps_rate_threshold];
+
+			bh1770glc_ps_read_result(chip);
+			bh1770glc_ps_rate(chip, PS_ABOVE_THRESHOLD);
+			wake_up_interruptible(&bh1770glc->ps_misc_wait);
+
+			cancel_delayed_work_sync(&chip->ps_work);
+			/*
+			 * Let's recheck situation 50 ms after the next
+			 * expected threshold interrupt.
+			 */
+			schedule_delayed_work(&chip->ps_work,
+			  msecs_to_jiffies(rate + 50));
+		}
+}
+
+/* Proximity misc device */
+static unsigned int bh1770glc_ps_poll(struct file *file, poll_table *wait)
+{
+	poll_wait(file, &bh1770glc->ps_misc_wait, wait);
+	if (file->f_pos < bh1770glc->ps_offset)
+		return POLLIN | POLLRDNORM;
+	return 0;
+}
+
+static int bh1770glc_ps_open(struct inode *inode, struct file *file)
+{
+	struct bh1770glc_chip *chip = bh1770glc;
+	int err;
+
+	mutex_lock(&chip->mutex);
+	err = 0;
+	if (!chip->ps_users) {
+		err = regulator_bulk_enable(ARRAY_SIZE(chip->regs),
+					chip->regs);
+		if (err < 0)
+			goto release_lock;
+
+		if (!chip->als_users)
+			msleep(BHCHIP_STARTUP_DELAY);
+
+		/* Refresh all configs in case of regulators were off */
+		err = bh1770glc_ps_set_thresholds(chip);
+		if (err < 0)
+			goto exit;
+
+		err = bh1770glc_led_cfg(chip, chip->ps_leds);
+		if (err < 0)
+			goto exit;
+
+		err = bh1770glc_ps_rate(chip, PS_BELOW_THRESHOLD);
+		if (err < 0)
+			goto exit;
+
+		err = bh1770glc_ps_interrupt_control(chip, BHCHIP_ENABLE);
+		if (err < 0)
+			goto exit;
+
+		err = bh1770glc_ps_mode(chip, BHCHIP_STANDALONE);
+	}
+	if (err == 0)
+		chip->ps_users++;
+exit:
+	if (err < 0)
+		regulator_bulk_disable(ARRAY_SIZE(chip->regs), chip->regs);
+
+release_lock:
+	file->f_pos = chip->ps_offset;
+	mutex_unlock(&chip->mutex);
+
+	if (err == 0) {
+		cancel_delayed_work_sync(&chip->ps_work);
+		schedule_delayed_work(&chip->ps_work,
+				msecs_to_jiffies(BHCHIP_PS_INIT_DELAY));
+	}
+
+	return err;
+}
+
+static int bh1770glc_ps_close(struct inode *inode, struct file *file)
+{
+	struct bh1770glc_chip *chip = bh1770glc;
+	mutex_lock(&chip->mutex);
+	if (!--chip->ps_users) {
+		bh1770glc_ps_interrupt_control(chip, BHCHIP_DISABLE);
+		bh1770glc_ps_mode(chip, BHCHIP_STANDBY);
+		regulator_bulk_disable(ARRAY_SIZE(chip->regs), chip->regs);
+	}
+	mutex_unlock(&chip->mutex);
+	return 0;
+}
+
+static ssize_t bh1770glc_get_ps_mode(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bh1770glc_chip *chip =  dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", chip->ps_mode);
+}
+
+static ssize_t bh1770glc_get_ps_rate(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bh1770glc_chip *chip =  dev_get_drvdata(dev);
+	return sprintf(buf, "%d %d\n", ps_rates[chip->ps_rate],
+		ps_rates[chip->ps_rate_threshold]);
+}
+
+static ssize_t bh1770glc_set_ps_rate(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct bh1770glc_chip *chip =  dev_get_drvdata(dev);
+	int rate = 0, rate_threshold = 0;
+	int ret;
+
+	ret = sscanf(buf, "%d %d", &rate, &rate_threshold);
+	if (ret < 0)
+		return ret;
+
+	if (ret == 0)
+		return count;
+
+	/* Second value is optional */
+	if (ret == 1)
+		rate_threshold = ps_rates[chip->ps_rate_threshold];
+
+	mutex_lock(&chip->mutex);
+	ret = bh1770glc_ps_rates(chip, rate, rate_threshold);
+	mutex_unlock(&chip->mutex);
+
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static ssize_t bh1770glc_ps_calib_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct bh1770glc_chip *chip = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%u %u %u\n", chip->ps_calib[0],
+			chip->ps_calib[1], chip->ps_calib[2]);
+}
+
+static ssize_t bh1770glc_ps_calib_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t len)
+{
+	struct bh1770glc_chip *chip = dev_get_drvdata(dev);
+	int calib[BHCHIP_PS_CHANNELS];
+	int i, ret;
+
+	for (i = 0; i < BHCHIP_PS_CHANNELS; i++)
+		calib[i] = BHCHIP_PS_NEUTRAL_CALIB_VALUE;
+	ret = sscanf(buf, "%d %d %d", &calib[0], &calib[1], &calib[2]);
+	if (ret < 0)
+		return ret;
+	if (ret < chip->ps_channels)
+		return -EINVAL;
+
+	for (i = 0; i < chip->ps_channels; i++)
+		chip->ps_calib[i] = calib[i];
+
+	return len;
+}
+
+static ssize_t bh1770glc_get_ps_thres(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bh1770glc_chip *chip =  dev_get_drvdata(dev);
+	return sprintf(buf, "%d %d %d\n", chip->ps_thresholds[0],
+		chip->ps_thresholds[1],
+		chip->ps_thresholds[2]);
+}
+
+static ssize_t bh1770glc_set_ps_thres(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct bh1770glc_chip *chip =  dev_get_drvdata(dev);
+	int input[BHCHIP_PS_CHANNELS];
+	int ret;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(input); i++)
+		input[i] = BHCHIP_PS_RANGE;
+	ret = sscanf(buf, "%d %d %d", &input[0], &input[1], &input[2]);
+
+	if (ret < 0)
+		return ret;
+	if (ret < chip->ps_channels)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(input); i++) {
+		if ((input[i] < 0) ||
+		    (input[i] > BHCHIP_PS_RANGE))
+			return -EINVAL;
+		chip->ps_thresholds[i] = input[i];
+	}
+
+	mutex_lock(&chip->mutex);
+	ret = bh1770glc_ps_set_thresholds(chip);
+	mutex_unlock(&chip->mutex);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static ssize_t bh1770glc_ps_leds_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bh1770glc_chip *chip =  dev_get_drvdata(dev);
+	u8 led_current[BHCHIP_PS_CHANNELS];
+	int i;
+
+	memset(led_current, 0, sizeof(led_current));
+	for (i = 0; i < chip->ps_channels; i++)
+		led_current[i] = ps_curr_ma[chip->ps_leds[i]];
+
+	return sprintf(buf, "%d %d %d\n", led_current[0],
+		led_current[1],
+		led_current[2]);
+}
+
+static ssize_t bh1770glc_ps_leds_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct bh1770glc_chip *chip =  dev_get_drvdata(dev);
+	int input[BHCHIP_PS_CHANNELS];
+	u8 led_curr[BHCHIP_PS_CHANNELS];
+	int ret;
+	int i, j;
+
+	ret = sscanf(buf, "%d %d %d", &input[0], &input[1], &input[2]);
+	if (ret < 0)
+		return ret;
+	if (ret < chip->ps_channels)
+		return -EINVAL;
+
+	/* Set minimum current */
+	for (i = chip->ps_channels; i < BHCHIP_PS_CHANNELS; i++)
+		led_curr[i] = BH1770GLC_LED_5mA;
+
+	for (i = 0; i < chip->ps_channels; i++) {
+		for (j = 0; j < ARRAY_SIZE(ps_curr_ma); j++)
+			if (input[i] == ps_curr_ma[j]) {
+				led_curr[i] = j;
+				break;
+			}
+		if (j == ARRAY_SIZE(ps_curr_ma))
+			return -EINVAL;
+	}
+
+	mutex_lock(&chip->mutex);
+	ret = bh1770glc_led_cfg(chip, led_curr);
+	mutex_unlock(&chip->mutex);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static ssize_t bh1770glc_chip_id_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bh1770glc_chip *chip =  dev_get_drvdata(dev);
+	return sprintf(buf, "%s rev %d\n", chip->chipname, chip->revision);
+}
+
+static DEVICE_ATTR(ps_mode, S_IRUGO, bh1770glc_get_ps_mode, NULL);
+static DEVICE_ATTR(ps_rate, S_IRUGO | S_IWUSR, bh1770glc_get_ps_rate,
+						bh1770glc_set_ps_rate);
+static DEVICE_ATTR(ps_threshold, S_IRUGO | S_IWUSR, bh1770glc_get_ps_thres,
+						bh1770glc_set_ps_thres);
+static DEVICE_ATTR(ps_calib, S_IRUGO | S_IWUSR, bh1770glc_ps_calib_show,
+						 bh1770glc_ps_calib_store);
+static DEVICE_ATTR(ps_leds, S_IRUGO | S_IWUSR, bh1770glc_ps_leds_show,
+						 bh1770glc_ps_leds_store);
+static DEVICE_ATTR(chip_id, S_IRUGO, bh1770glc_chip_id_show, NULL);
+
+static struct attribute *sysfs_attrs[] = {
+	&dev_attr_ps_calib.attr,
+	&dev_attr_ps_mode.attr,
+	&dev_attr_ps_rate.attr,
+	&dev_attr_ps_threshold.attr,
+	&dev_attr_ps_leds.attr,
+	&dev_attr_chip_id.attr,
+	NULL
+};
+
+static struct attribute_group bh1770glc_attribute_group = {
+	.attrs = sysfs_attrs
+};
+
+static const struct file_operations bh1770glc_ps_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.read		= bh1770glc_ps_read,
+	.poll		= bh1770glc_ps_poll,
+	.open		= bh1770glc_ps_open,
+	.release	= bh1770glc_ps_close,
+};
+
+static struct miscdevice bh1770glc_ps_miscdevice = {
+       .minor = MISC_DYNAMIC_MINOR,
+       .name = "bh1770glc_ps",
+       .fops = &bh1770glc_ps_fops
+};
+
+int bh1770glc_ps_init(struct bh1770glc_chip *chip)
+{
+	int err;
+	int i;
+
+	for (i = 0; i < BHCHIP_PS_CHANNELS; i++) {
+		chip->ps_thresholds[i] = BHCHIP_PS_DEF_THRES;
+		chip->ps_leds[i] = chip->pdata->led_def_curr[i];
+	}
+
+	err = bh1770glc_ps_mode(chip, BHCHIP_STANDBY);
+	if (err < 0)
+		goto fail1;
+
+	err = bh1770glc_ps_interrupt_control(chip, BHCHIP_DISABLE);
+	if (err < 0)
+		goto fail1;
+
+	bh1770glc_ps_rates(chip, BHCHIP_PS_DEFAULT_RATE,
+			BHCHIP_PS_DEF_RATE_THRESH);
+
+	INIT_DELAYED_WORK(&chip->ps_work, bh1770glc_ps_work);
+
+	bh1770glc_ps_miscdevice.parent = &chip->client->dev;
+	err = misc_register(&bh1770glc_ps_miscdevice);
+	if (err < 0) {
+		dev_err(&chip->client->dev, "Device registration failed\n");
+		goto fail1;
+	}
+
+	err = sysfs_create_group(&chip->client->dev.kobj,
+				&bh1770glc_attribute_group);
+	if (err < 0) {
+		dev_err(&chip->client->dev, "Sysfs registration failed\n");
+		goto fail2;
+	}
+	return 0;
+fail2:
+	misc_deregister(&bh1770glc_ps_miscdevice);
+fail1:
+	return err;
+
+}
+
+int bh1770glc_ps_destroy(struct bh1770glc_chip *chip)
+{
+	cancel_delayed_work_sync(&chip->ps_work);
+	sysfs_remove_group(&chip->client->dev.kobj,
+			&bh1770glc_attribute_group);
+	misc_deregister(&bh1770glc_ps_miscdevice);
+	return 0;
+}
diff --git a/include/linux/bh1770glc.h b/include/linux/bh1770glc.h
new file mode 100644
index 0000000..27d2d7c
--- /dev/null
+++ b/include/linux/bh1770glc.h
@@ -0,0 +1,39 @@
+#ifndef __BH1770GLC_H__
+#define __BH1770GLC_H__
+
+struct bh1770glc_platform_data {
+/* IR-Led configuration for proximity sensing */
+#define BH1770GLC_LED1	    0x00
+#define BH1770GLC_LED12	    0x01
+#define BH1770GLC_LED13	    0x02
+#define BH1770GLC_LED123    0x03
+
+	__u8 leds;
+/* led_max_curr is a safetylimit for IR leds */
+#define BH1770GLC_LED_5mA   0
+#define BH1770GLC_LED_10mA  1
+#define BH1770GLC_LED_20mA  2
+#define BH1770GLC_LED_50mA  3
+#define BH1770GLC_LED_100mA 4
+#define BH1770GLC_LED_150mA 5
+#define BH1770GLC_LED_200mA 6
+	__u8 led_max_curr;
+	__u8 led_def_curr[3];
+
+	int (*setup_resources)(void);
+	int (*release_resources)(void);
+};
+
+/* Device name: /dev/bh1770glc_ps */
+struct bh1770glc_ps {
+	__u8 led1;
+	__u8 led2;
+	__u8 led3;
+} __attribute__((packed));
+
+/* Device name: /dev/bh1770glc_als */
+struct bh1770glc_als {
+	__u16 lux;
+} __attribute__((packed));
+
+#endif
-- 
1.6.0.4

