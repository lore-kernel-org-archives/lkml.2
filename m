Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab1KGPD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:03:27 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55957 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1KGPDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:03:00 -0500
From: jic23@cam.ac.uk
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: guenter.roeck@ericsson.com, khali@linux-fr.org, dmitry.torokhov@gmail.com,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        alan@lxorguk.ukuu.org.uk, arnd@arndb.de, linus.walleij@linaro.org,
        lars@metafoo.de, maxime.ripard@free-electrons.com,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 5/6] IIO:imu:adis16400 partial move from staging.
Date: Mon,  7 Nov 2011 14:52:42 +0000
Message-Id: <1320677563-18378-6-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.7.2
In-Reply-To: <1320677563-18378-1-git-send-email-jic23@cam.ac.uk>
References: <1320677563-18378-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>

This driver made use of a few convenient corners of scan_type so
I have lifted those elements into iio_chan_spec structure for now
(in initial iio core support patch).

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/iio/Kconfig              |    1 +
 drivers/iio/Makefile             |    1 +
 drivers/iio/imu/Kconfig          |   12 +
 drivers/iio/imu/Makefile         |    6 +
 drivers/iio/imu/adis16400.h      |  180 ++++++
 drivers/iio/imu/adis16400_core.c | 1142 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 1342 insertions(+), 0 deletions(-)

diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
index 5dcd9e5..308bc97 100644
--- a/drivers/iio/Kconfig
+++ b/drivers/iio/Kconfig
@@ -12,6 +12,7 @@ menuconfig IIO
 if IIO
 
 source "drivers/iio/adc/Kconfig"
+source "drivers/iio/imu/Kconfig"
 source "drivers/iio/light/Kconfig"
 
 endif # IIO
diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
index 0e59946..db3c426 100644
--- a/drivers/iio/Makefile
+++ b/drivers/iio/Makefile
@@ -6,4 +6,5 @@ obj-$(CONFIG_IIO) += iio.o
 industrialio-y := core.o
 
 obj-y += adc/
+obj-y += imu/
 obj-y += light/
diff --git a/drivers/iio/imu/Kconfig b/drivers/iio/imu/Kconfig
new file mode 100644
index 0000000..fe3c28c
--- /dev/null
+++ b/drivers/iio/imu/Kconfig
@@ -0,0 +1,12 @@
+menu "Inertial measurement units (IMUs)"
+
+config IIO_ADIS16400
+	tristate "Analog Devices ADIS16400 and similar IMU SPI driver"
+	depends on SPI
+	help
+	  Say yes here to build support for Analog Devices adis16300, adis16350,
+	  adis16354, adis16355, adis16360, adis16362, adis16364, adis16365,
+	  adis16400 and adis16405 triaxial inertial sensors (adis16400 series
+	  also have magnetometers).
+
+endmenu
diff --git a/drivers/iio/imu/Makefile b/drivers/iio/imu/Makefile
new file mode 100644
index 0000000..eb4d31e
--- /dev/null
+++ b/drivers/iio/imu/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for IIO IMUs
+#
+
+iio_adis16400-y := adis16400_core.o
+obj-$(CONFIG_IIO_ADIS16400) += iio_adis16400.o
\ No newline at end of file
diff --git a/drivers/iio/imu/adis16400.h b/drivers/iio/imu/adis16400.h
new file mode 100644
index 0000000..78377ea
--- /dev/null
+++ b/drivers/iio/imu/adis16400.h
@@ -0,0 +1,180 @@
+/*
+ * adis16400.h	support Analog Devices ADIS16400
+ *		3d 18g accelerometers,
+ *		3d gyroscopes,
+ *		3d 2.5gauss magnetometers via SPI
+ *
+ * Copyright (c) 2009 Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
+ * Copyright (c) 2007 Jonathan Cameron <jic23@cam.ac.uk>
+ *
+ * Loosely based upon lis3l02dq.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef SPI_ADIS16400_H_
+#define SPI_ADIS16400_H_
+
+#define ADIS16400_STARTUP_DELAY	290 /* ms */
+#define ADIS16400_MTEST_DELAY 90 /* ms */
+
+#define ADIS16400_READ_REG(a)    a
+#define ADIS16400_WRITE_REG(a) ((a) | 0x80)
+
+#define ADIS16400_FLASH_CNT  0x00 /* Flash memory write count */
+#define ADIS16400_SUPPLY_OUT 0x02 /* Power supply measurement */
+#define ADIS16400_XGYRO_OUT 0x04 /* X-axis gyroscope output */
+#define ADIS16400_YGYRO_OUT 0x06 /* Y-axis gyroscope output */
+#define ADIS16400_ZGYRO_OUT 0x08 /* Z-axis gyroscope output */
+#define ADIS16400_XACCL_OUT 0x0A /* X-axis accelerometer output */
+#define ADIS16400_YACCL_OUT 0x0C /* Y-axis accelerometer output */
+#define ADIS16400_ZACCL_OUT 0x0E /* Z-axis accelerometer output */
+#define ADIS16400_XMAGN_OUT 0x10 /* X-axis magnetometer measurement */
+#define ADIS16400_YMAGN_OUT 0x12 /* Y-axis magnetometer measurement */
+#define ADIS16400_ZMAGN_OUT 0x14 /* Z-axis magnetometer measurement */
+#define ADIS16400_TEMP_OUT  0x16 /* Temperature output */
+#define ADIS16400_AUX_ADC   0x18 /* Auxiliary ADC measurement */
+
+#define ADIS16350_XTEMP_OUT 0x10 /* X-axis gyroscope temperature measurement */
+#define ADIS16350_YTEMP_OUT 0x12 /* Y-axis gyroscope temperature measurement */
+#define ADIS16350_ZTEMP_OUT 0x14 /* Z-axis gyroscope temperature measurement */
+
+#define ADIS16300_PITCH_OUT 0x12 /* X axis inclinometer output measurement */
+#define ADIS16300_ROLL_OUT  0x12 /* Y axis inclinometer output measurement */
+
+/* Calibration parameters */
+#define ADIS16400_XGYRO_OFF 0x1A /* X-axis gyroscope bias offset factor */
+#define ADIS16400_YGYRO_OFF 0x1C /* Y-axis gyroscope bias offset factor */
+#define ADIS16400_ZGYRO_OFF 0x1E /* Z-axis gyroscope bias offset factor */
+#define ADIS16400_XACCL_OFF 0x20 /* X-axis acceleration bias offset factor */
+#define ADIS16400_YACCL_OFF 0x22 /* Y-axis acceleration bias offset factor */
+#define ADIS16400_ZACCL_OFF 0x24 /* Z-axis acceleration bias offset factor */
+#define ADIS16400_XMAGN_HIF 0x26 /* X-axis magnetometer, hard-iron factor */
+#define ADIS16400_YMAGN_HIF 0x28 /* Y-axis magnetometer, hard-iron factor */
+#define ADIS16400_ZMAGN_HIF 0x2A /* Z-axis magnetometer, hard-iron factor */
+#define ADIS16400_XMAGN_SIF 0x2C /* X-axis magnetometer, soft-iron factor */
+#define ADIS16400_YMAGN_SIF 0x2E /* Y-axis magnetometer, soft-iron factor */
+#define ADIS16400_ZMAGN_SIF 0x30 /* Z-axis magnetometer, soft-iron factor */
+
+#define ADIS16400_GPIO_CTRL 0x32 /* Auxiliary digital input/output control */
+#define ADIS16400_MSC_CTRL  0x34 /* Miscellaneous control */
+#define ADIS16400_SMPL_PRD  0x36 /* Internal sample period (rate) control */
+#define ADIS16400_SENS_AVG  0x38 /* Dynamic range and digital filter control */
+#define ADIS16400_SLP_CNT   0x3A /* Sleep mode control */
+#define ADIS16400_DIAG_STAT 0x3C /* System status */
+
+/* Alarm functions */
+#define ADIS16400_GLOB_CMD  0x3E /* System command */
+#define ADIS16400_ALM_MAG1  0x40 /* Alarm 1 amplitude threshold */
+#define ADIS16400_ALM_MAG2  0x42 /* Alarm 2 amplitude threshold */
+#define ADIS16400_ALM_SMPL1 0x44 /* Alarm 1 sample size */
+#define ADIS16400_ALM_SMPL2 0x46 /* Alarm 2 sample size */
+#define ADIS16400_ALM_CTRL  0x48 /* Alarm control */
+#define ADIS16400_AUX_DAC   0x4A /* Auxiliary DAC data */
+
+#define ADIS16400_PRODUCT_ID 0x56 /* Product identifier */
+
+#define ADIS16400_ERROR_ACTIVE			(1<<14)
+#define ADIS16400_NEW_DATA			(1<<14)
+
+/* MSC_CTRL */
+#define ADIS16400_MSC_CTRL_MEM_TEST		(1<<11)
+#define ADIS16400_MSC_CTRL_INT_SELF_TEST	(1<<10)
+#define ADIS16400_MSC_CTRL_NEG_SELF_TEST	(1<<9)
+#define ADIS16400_MSC_CTRL_POS_SELF_TEST	(1<<8)
+#define ADIS16400_MSC_CTRL_GYRO_BIAS		(1<<7)
+#define ADIS16400_MSC_CTRL_ACCL_ALIGN		(1<<6)
+#define ADIS16400_MSC_CTRL_DATA_RDY_EN		(1<<2)
+#define ADIS16400_MSC_CTRL_DATA_RDY_POL_HIGH	(1<<1)
+#define ADIS16400_MSC_CTRL_DATA_RDY_DIO2	(1<<0)
+
+/* SMPL_PRD */
+#define ADIS16400_SMPL_PRD_TIME_BASE	(1<<7)
+#define ADIS16400_SMPL_PRD_DIV_MASK	0x7F
+
+/* DIAG_STAT */
+#define ADIS16400_DIAG_STAT_ZACCL_FAIL	(1<<15)
+#define ADIS16400_DIAG_STAT_YACCL_FAIL	(1<<14)
+#define ADIS16400_DIAG_STAT_XACCL_FAIL	(1<<13)
+#define ADIS16400_DIAG_STAT_XGYRO_FAIL	(1<<12)
+#define ADIS16400_DIAG_STAT_YGYRO_FAIL	(1<<11)
+#define ADIS16400_DIAG_STAT_ZGYRO_FAIL	(1<<10)
+#define ADIS16400_DIAG_STAT_ALARM2	(1<<9)
+#define ADIS16400_DIAG_STAT_ALARM1	(1<<8)
+#define ADIS16400_DIAG_STAT_FLASH_CHK	(1<<6)
+#define ADIS16400_DIAG_STAT_SELF_TEST	(1<<5)
+#define ADIS16400_DIAG_STAT_OVERFLOW	(1<<4)
+#define ADIS16400_DIAG_STAT_SPI_FAIL	(1<<3)
+#define ADIS16400_DIAG_STAT_FLASH_UPT	(1<<2)
+#define ADIS16400_DIAG_STAT_POWER_HIGH	(1<<1)
+#define ADIS16400_DIAG_STAT_POWER_LOW	(1<<0)
+
+/* GLOB_CMD */
+#define ADIS16400_GLOB_CMD_SW_RESET	(1<<7)
+#define ADIS16400_GLOB_CMD_P_AUTO_NULL	(1<<4)
+#define ADIS16400_GLOB_CMD_FLASH_UPD	(1<<3)
+#define ADIS16400_GLOB_CMD_DAC_LATCH	(1<<2)
+#define ADIS16400_GLOB_CMD_FAC_CALIB	(1<<1)
+#define ADIS16400_GLOB_CMD_AUTO_NULL	(1<<0)
+
+/* SLP_CNT */
+#define ADIS16400_SLP_CNT_POWER_OFF	(1<<8)
+
+#define ADIS16400_MAX_TX 24
+#define ADIS16400_MAX_RX 24
+
+#define ADIS16400_SPI_SLOW	(u32)(300 * 1000)
+#define ADIS16400_SPI_BURST	(u32)(1000 * 1000)
+#define ADIS16400_SPI_FAST	(u32)(2000 * 1000)
+
+#define ADIS16400_HAS_PROD_ID 1
+
+struct adis16400_chip_info {
+	const struct iio_chan_spec *channels;
+	const int num_channels;
+	const int product_id;
+	const long flags;
+	unsigned int gyro_scale_micro;
+	unsigned int accel_scale_micro;
+};
+
+/**
+ * struct adis16400_state - device instance specific data
+ * @us:			actual spi_device
+ * @trig:		data ready trigger registered with iio
+ * @tx:			transmit buffer
+ * @rx:			receive buffer
+ * @buf_lock:		mutex to protect tx and rx
+ **/
+struct adis16400_state {
+	struct spi_device		*us;
+	struct iio_trigger		*trig;
+	struct mutex			buf_lock;
+	struct adis16400_chip_info	*variant;
+
+	u8	tx[ADIS16400_MAX_TX] ____cacheline_aligned;
+	u8	rx[ADIS16400_MAX_RX] ____cacheline_aligned;
+};
+
+#define ADIS16400_SCAN_SUPPLY	0
+#define ADIS16400_SCAN_GYRO_X	1
+#define ADIS16400_SCAN_GYRO_Y	2
+#define ADIS16400_SCAN_GYRO_Z	3
+#define ADIS16400_SCAN_ACC_X	4
+#define ADIS16400_SCAN_ACC_Y	5
+#define ADIS16400_SCAN_ACC_Z	6
+#define ADIS16400_SCAN_MAGN_X	7
+#define ADIS16350_SCAN_TEMP_X	7
+#define ADIS16400_SCAN_MAGN_Y	8
+#define ADIS16350_SCAN_TEMP_Y	8
+#define ADIS16400_SCAN_MAGN_Z	9
+#define ADIS16350_SCAN_TEMP_Z	9
+#define ADIS16400_SCAN_TEMP	10
+#define ADIS16350_SCAN_ADC_0	10
+#define ADIS16400_SCAN_ADC_0	11
+#define ADIS16300_SCAN_INCLI_X	12
+#define ADIS16300_SCAN_INCLI_Y	13
+
+#endif /* SPI_ADIS16400_H_ */
diff --git a/drivers/iio/imu/adis16400_core.c b/drivers/iio/imu/adis16400_core.c
new file mode 100644
index 0000000..5e49742
--- /dev/null
+++ b/drivers/iio/imu/adis16400_core.c
@@ -0,0 +1,1142 @@
+/*
+ * adis16400.c	support a number of ADI IMUs
+ *
+ * Copyright (c) 2009 Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
+ * Copyright (c) 2007-2011 Jonathan Cameron <jic23@cam.ac.uk>
+ * Copyright (c) 2011 Analog Devices Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/delay.h>
+#include <linux/mutex.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/spi/spi.h>
+#include <linux/slab.h>
+#include <linux/sysfs.h>
+#include <linux/list.h>
+
+#include <linux/iio/iio.h>
+#include <linux/iio/sysfs.h>
+#include "adis16400.h"
+
+enum adis16400_chip_variant {
+	ADIS16300,
+	ADIS16334,
+	ADIS16350,
+	ADIS16360,
+	ADIS16362,
+	ADIS16364,
+	ADIS16365,
+	ADIS16400,
+};
+
+/**
+ * adis16400_spi_write_reg_8() - write single byte to a register
+ * @dev: device associated with child of actual device (iio_dev or iio_trig)
+ * @reg_address: the address of the register to be written
+ * @val: the value to write
+ */
+static int adis16400_spi_write_reg_8(struct iio_dev *indio_dev,
+				     u8 reg_address,
+				     u8 val)
+{
+	int ret;
+	struct adis16400_state *st = iio_priv(indio_dev);
+
+	mutex_lock(&st->buf_lock);
+	st->tx[0] = ADIS16400_WRITE_REG(reg_address);
+	st->tx[1] = val;
+
+	ret = spi_write(st->us, st->tx, 2);
+	mutex_unlock(&st->buf_lock);
+
+	return ret;
+}
+
+/**
+ * adis16400_spi_write_reg_16() - write 2 bytes to a pair of registers
+ * @dev: device associated with child of actual device (iio_dev or iio_trig)
+ * @reg_address: the address of the lower of the two registers. Second register
+ *               is assumed to have address one greater.
+ * @val: value to be written
+ *
+ * At the moment the spi framework doesn't allow global setting of cs_change.
+ * This means that use cannot be made of spi_write.
+ */
+static int adis16400_spi_write_reg_16(struct iio_dev *indio_dev,
+		u8 lower_reg_address,
+		u16 value)
+{
+	int ret;
+	struct spi_message msg;
+	struct adis16400_state *st = iio_priv(indio_dev);
+	struct spi_transfer xfers[] = {
+		{
+			.tx_buf = st->tx,
+			.bits_per_word = 8,
+			.len = 2,
+			.cs_change = 1,
+		}, {
+			.tx_buf = st->tx + 2,
+			.bits_per_word = 8,
+			.len = 2,
+		},
+	};
+
+	mutex_lock(&st->buf_lock);
+	st->tx[0] = ADIS16400_WRITE_REG(lower_reg_address);
+	st->tx[1] = value & 0xFF;
+	st->tx[2] = ADIS16400_WRITE_REG(lower_reg_address + 1);
+	st->tx[3] = (value >> 8) & 0xFF;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfers[0], &msg);
+	spi_message_add_tail(&xfers[1], &msg);
+	ret = spi_sync(st->us, &msg);
+	mutex_unlock(&st->buf_lock);
+
+	return ret;
+}
+
+/**
+ * adis16400_spi_read_reg_16() - read 2 bytes from a 16-bit register
+ * @indio_dev: iio device
+ * @reg_address: the address of the lower of the two registers. Second register
+ *               is assumed to have address one greater.
+ * @val: somewhere to pass back the value read
+ *
+ * At the moment the spi framework doesn't allow global setting of cs_change.
+ * This means that use cannot be made of spi_read.
+ **/
+static int adis16400_spi_read_reg_16(struct iio_dev *indio_dev,
+		u8 lower_reg_address,
+		u16 *val)
+{
+	struct spi_message msg;
+	struct adis16400_state *st = iio_priv(indio_dev);
+	int ret;
+	struct spi_transfer xfers[] = {
+		{
+			.tx_buf = st->tx,
+			.bits_per_word = 8,
+			.len = 2,
+			.cs_change = 1,
+		}, {
+			.rx_buf = st->rx,
+			.bits_per_word = 8,
+			.len = 2,
+		},
+	};
+
+	mutex_lock(&st->buf_lock);
+	st->tx[0] = ADIS16400_READ_REG(lower_reg_address);
+	st->tx[1] = 0;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfers[0], &msg);
+	spi_message_add_tail(&xfers[1], &msg);
+	ret = spi_sync(st->us, &msg);
+	if (ret) {
+		dev_err(&st->us->dev,
+			"problem when reading 16 bit register 0x%02X",
+			lower_reg_address);
+		goto error_ret;
+	}
+	*val = (st->rx[0] << 8) | st->rx[1];
+
+error_ret:
+	mutex_unlock(&st->buf_lock);
+	return ret;
+}
+
+static ssize_t adis16400_read_frequency(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	int ret, len = 0;
+	u16 t;
+	int sps;
+	ret = adis16400_spi_read_reg_16(indio_dev,
+			ADIS16400_SMPL_PRD,
+			&t);
+	if (ret)
+		return ret;
+	sps =  (t & ADIS16400_SMPL_PRD_TIME_BASE) ? 53 : 1638;
+	sps /= (t & ADIS16400_SMPL_PRD_DIV_MASK) + 1;
+	len = sprintf(buf, "%d SPS\n", sps);
+	return len;
+}
+
+static ssize_t adis16400_write_frequency(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf,
+		size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct adis16400_state *st = iio_priv(indio_dev);
+	long val;
+	int ret;
+	u8 t;
+
+	ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	mutex_lock(&indio_dev->mlock);
+
+	t = (1638 / val);
+	if (t > 0)
+		t--;
+	t &= ADIS16400_SMPL_PRD_DIV_MASK;
+	if ((t & ADIS16400_SMPL_PRD_DIV_MASK) >= 0x0A)
+		st->us->max_speed_hz = ADIS16400_SPI_SLOW;
+	else
+		st->us->max_speed_hz = ADIS16400_SPI_FAST;
+
+	ret = adis16400_spi_write_reg_8(indio_dev,
+			ADIS16400_SMPL_PRD,
+			t);
+
+	mutex_unlock(&indio_dev->mlock);
+
+	return ret ? ret : len;
+}
+
+static int adis16400_reset(struct iio_dev *indio_dev)
+{
+	int ret;
+	ret = adis16400_spi_write_reg_8(indio_dev,
+			ADIS16400_GLOB_CMD,
+			ADIS16400_GLOB_CMD_SW_RESET);
+	if (ret)
+		dev_err(&indio_dev->dev, "problem resetting device");
+
+	return ret;
+}
+
+static ssize_t adis16400_write_reset(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t len)
+{
+	bool val;
+	int ret;
+
+	ret = strtobool(buf, &val);
+	if (ret < 0)
+		return ret;
+	if (val) {
+		ret = adis16400_reset(dev_get_drvdata(dev));
+		if (ret < 0)
+			return ret;
+	}
+
+	return len;
+}
+
+/* Power down the device */
+static int adis16400_stop_device(struct iio_dev *indio_dev)
+{
+	int ret;
+	u16 val = ADIS16400_SLP_CNT_POWER_OFF;
+
+	ret = adis16400_spi_write_reg_16(indio_dev, ADIS16400_SLP_CNT, val);
+	if (ret)
+		dev_err(&indio_dev->dev,
+			"problem with turning device off: SLP_CNT");
+
+	return ret;
+}
+
+static int adis16400_check_status(struct iio_dev *indio_dev)
+{
+	u16 status;
+	int ret;
+	struct device *dev = &indio_dev->dev;
+
+	ret = adis16400_spi_read_reg_16(indio_dev,
+					ADIS16400_DIAG_STAT, &status);
+
+	if (ret < 0) {
+		dev_err(dev, "Reading status failed\n");
+		goto error_ret;
+	}
+	ret = status;
+	if (status & ADIS16400_DIAG_STAT_ZACCL_FAIL)
+		dev_err(dev, "Z-axis accelerometer self-test failure\n");
+	if (status & ADIS16400_DIAG_STAT_YACCL_FAIL)
+		dev_err(dev, "Y-axis accelerometer self-test failure\n");
+	if (status & ADIS16400_DIAG_STAT_XACCL_FAIL)
+		dev_err(dev, "X-axis accelerometer self-test failure\n");
+	if (status & ADIS16400_DIAG_STAT_XGYRO_FAIL)
+		dev_err(dev, "X-axis gyroscope self-test failure\n");
+	if (status & ADIS16400_DIAG_STAT_YGYRO_FAIL)
+		dev_err(dev, "Y-axis gyroscope self-test failure\n");
+	if (status & ADIS16400_DIAG_STAT_ZGYRO_FAIL)
+		dev_err(dev, "Z-axis gyroscope self-test failure\n");
+	if (status & ADIS16400_DIAG_STAT_ALARM2)
+		dev_err(dev, "Alarm 2 active\n");
+	if (status & ADIS16400_DIAG_STAT_ALARM1)
+		dev_err(dev, "Alarm 1 active\n");
+	if (status & ADIS16400_DIAG_STAT_FLASH_CHK)
+		dev_err(dev, "Flash checksum error\n");
+	if (status & ADIS16400_DIAG_STAT_SELF_TEST)
+		dev_err(dev, "Self test error\n");
+	if (status & ADIS16400_DIAG_STAT_OVERFLOW)
+		dev_err(dev, "Sensor overrange\n");
+	if (status & ADIS16400_DIAG_STAT_SPI_FAIL)
+		dev_err(dev, "SPI failure\n");
+	if (status & ADIS16400_DIAG_STAT_FLASH_UPT)
+		dev_err(dev, "Flash update failed\n");
+	if (status & ADIS16400_DIAG_STAT_POWER_HIGH)
+		dev_err(dev, "Power supply above 5.25V\n");
+	if (status & ADIS16400_DIAG_STAT_POWER_LOW)
+		dev_err(dev, "Power supply below 4.75V\n");
+
+error_ret:
+	return ret;
+}
+
+static int adis16400_self_test(struct iio_dev *indio_dev)
+{
+	int ret;
+	ret = adis16400_spi_write_reg_16(indio_dev,
+			ADIS16400_MSC_CTRL,
+			ADIS16400_MSC_CTRL_MEM_TEST);
+	if (ret) {
+		dev_err(&indio_dev->dev, "problem starting self test");
+		goto err_ret;
+	}
+
+	msleep(ADIS16400_MTEST_DELAY);
+	adis16400_check_status(indio_dev);
+
+err_ret:
+	return ret;
+}
+
+static int adis16400_initial_setup(struct iio_dev *indio_dev)
+{
+	int ret;
+	u16 prod_id, smp_prd;
+	struct adis16400_state *st = iio_priv(indio_dev);
+
+	/* use low spi speed for init */
+	st->us->max_speed_hz = ADIS16400_SPI_SLOW;
+	st->us->mode = SPI_MODE_3;
+	spi_setup(st->us);
+
+	ret = adis16400_self_test(indio_dev);
+	if (ret) {
+		dev_err(&indio_dev->dev, "self test failure");
+		goto err_ret;
+	}
+
+	ret = adis16400_check_status(indio_dev);
+	if (ret) {
+		adis16400_reset(indio_dev);
+		dev_err(&indio_dev->dev, "device not playing ball -> reset");
+		msleep(ADIS16400_STARTUP_DELAY);
+		ret = adis16400_check_status(indio_dev);
+		if (ret) {
+			dev_err(&indio_dev->dev, "giving up");
+			goto err_ret;
+		}
+	}
+	if (st->variant->flags & ADIS16400_HAS_PROD_ID) {
+		ret = adis16400_spi_read_reg_16(indio_dev,
+						ADIS16400_PRODUCT_ID, &prod_id);
+		if (ret)
+			goto err_ret;
+
+		if ((prod_id & 0xF000) != st->variant->product_id)
+			dev_warn(&indio_dev->dev, "incorrect id");
+
+		dev_info(&indio_dev->dev,
+			 "%s: prod_id 0x%04x at CS%d (irq %d)\n",
+			 indio_dev->name, prod_id,
+			 st->us->chip_select, st->us->irq);
+	}
+	/* use high spi speed if possible */
+	ret = adis16400_spi_read_reg_16(indio_dev,
+					ADIS16400_SMPL_PRD, &smp_prd);
+	if (!ret && (smp_prd & ADIS16400_SMPL_PRD_DIV_MASK) < 0x0A) {
+		st->us->max_speed_hz = ADIS16400_SPI_SLOW;
+		spi_setup(st->us);
+	}
+
+err_ret:
+	return ret;
+}
+
+static IIO_DEVICE_ATTR(sampling_frequency,
+		       S_IWUSR | S_IRUGO,
+		       adis16400_read_frequency,
+		       adis16400_write_frequency,
+		       0);
+
+static IIO_DEVICE_ATTR(reset, S_IWUSR, NULL, adis16400_write_reset, 0);
+
+static IIO_CONST_ATTR(sampling_frequency_available, "409 546 819 1638");
+
+enum adis16400_chan {
+	in_supply,
+	gyro_x,
+	gyro_y,
+	gyro_z,
+	accel_x,
+	accel_y,
+	accel_z,
+	magn_x,
+	magn_y,
+	magn_z,
+	temp,
+	temp0, temp1, temp2,
+	in1,
+	incli_x,
+	incli_y,
+};
+
+static u8 adis16400_addresses[17][2] = {
+	[in_supply] = { ADIS16400_SUPPLY_OUT },
+	[gyro_x] = { ADIS16400_XGYRO_OUT, ADIS16400_XGYRO_OFF },
+	[gyro_y] = { ADIS16400_YGYRO_OUT, ADIS16400_YGYRO_OFF },
+	[gyro_z] = { ADIS16400_ZGYRO_OUT, ADIS16400_ZGYRO_OFF },
+	[accel_x] = { ADIS16400_XACCL_OUT, ADIS16400_XACCL_OFF },
+	[accel_y] = { ADIS16400_YACCL_OUT, ADIS16400_YACCL_OFF },
+	[accel_z] = { ADIS16400_ZACCL_OUT, ADIS16400_ZACCL_OFF },
+	[magn_x] = { ADIS16400_XMAGN_OUT },
+	[magn_y] = { ADIS16400_YMAGN_OUT },
+	[magn_z] = { ADIS16400_ZMAGN_OUT },
+	[temp] = { ADIS16400_TEMP_OUT },
+	[temp0] = { ADIS16350_XTEMP_OUT },
+	[temp1] = { ADIS16350_YTEMP_OUT },
+	[temp2] = { ADIS16350_ZTEMP_OUT },
+	[in1] = { ADIS16400_AUX_ADC },
+	[incli_x] = { ADIS16300_PITCH_OUT },
+	[incli_y] = { ADIS16300_ROLL_OUT }
+};
+
+static int adis16400_write_raw(struct iio_dev *indio_dev,
+			       struct iio_chan_spec const *chan,
+			       int val,
+			       int val2,
+			       long mask)
+{
+	int ret;
+
+	switch (mask) {
+	case IIO_CHAN_INFO_CALIBBIAS:
+		mutex_lock(&indio_dev->mlock);
+		ret = adis16400_spi_write_reg_16(indio_dev,
+				adis16400_addresses[chan->address][1],
+				val);
+		mutex_unlock(&indio_dev->mlock);
+		return ret;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int adis16400_read_raw(struct iio_dev *indio_dev,
+			      struct iio_chan_spec const *chan,
+			      int *val,
+			      int *val2,
+			      long mask)
+{
+	struct adis16400_state *st = iio_priv(indio_dev);
+	int ret, shift;
+	s16 val16;
+
+	switch (mask) {
+	case 0:
+		mutex_lock(&indio_dev->mlock);
+		ret = adis16400_spi_read_reg_16(indio_dev,
+				adis16400_addresses[chan->address][0],
+				&val16);
+		if (ret) {
+			mutex_unlock(&indio_dev->mlock);
+			return ret;
+		}
+		val16 &= (1 << chan->scan_type.realbits) - 1;
+		if (chan->scan_type.sign == 's') {
+			shift = 16 - chan->scan_type.realbits;
+			val16 = (s16)(val16 << shift) >> shift;
+		}
+		*val = val16;
+		mutex_unlock(&indio_dev->mlock);
+		return IIO_VAL_INT;
+	case IIO_CHAN_INFO_SCALE:
+		switch (chan->type) {
+		case IIO_ANGL_VEL:
+			*val = 0;
+			*val2 = st->variant->gyro_scale_micro;
+			return IIO_VAL_INT_PLUS_MICRO;
+		case IIO_IN:
+			*val = 0;
+			if (chan->channel == 0)
+				*val2 = 2418;
+			else
+				*val2 = 806;
+			return IIO_VAL_INT_PLUS_MICRO;
+		case IIO_ACCEL:
+			*val = 0;
+			*val2 = st->variant->accel_scale_micro;
+			return IIO_VAL_INT_PLUS_MICRO;
+		case IIO_MAGN:
+			*val = 0;
+			*val2 = 500;
+			return IIO_VAL_INT_PLUS_MICRO;
+		case IIO_TEMP:
+			*val = 0;
+			*val2 = 140000;
+			return IIO_VAL_INT_PLUS_MICRO;
+		default:
+			return -EINVAL;
+		}
+	case IIO_CHAN_INFO_CALIBBIAS:
+		mutex_lock(&indio_dev->mlock);
+		ret = adis16400_spi_read_reg_16(indio_dev,
+				adis16400_addresses[chan->address][1],
+				&val16);
+		mutex_unlock(&indio_dev->mlock);
+		if (ret)
+			return ret;
+		val16 = ((val16 & 0xFFF) << 4) >> 4;
+		*val = val16;
+		return IIO_VAL_INT;
+	case IIO_CHAN_INFO_OFFSET:
+		/* currently only temperature */
+		*val = 198;
+		*val2 = 160000;
+		return IIO_VAL_INT_PLUS_MICRO;
+	default:
+		return -EINVAL;
+	}
+}
+
+static struct iio_chan_spec adis16400_channels[] = {
+	{
+		.type = IIO_VOLTAGE,
+		.indexed = 1,
+		.channel = 0,
+		.extend_name = "supply",
+		.info_mask = IIO_CHAN_INFO_SCALE_SEPARATE_BIT,
+		.address = in_supply,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 'u',
+		},
+	}, {
+		.type = IIO_ANGL_VEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_X,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = gyro_x,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ANGL_VEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_Y,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = gyro_y,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ANGL_VEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_Z,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = gyro_z,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ACCEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_X,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = accel_x,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ACCEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_Y,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = accel_y,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ACCEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_Z,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = accel_z,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_MAGN,
+		.modified = 1,
+		.channel2 = IIO_MOD_X,
+		.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = magn_x,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_MAGN,
+		.modified = 1,
+		.channel2 = IIO_MOD_Y,
+		.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = magn_y,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_MAGN,
+		.modified = 1,
+		.channel2 = IIO_MOD_Z,
+		.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = magn_z,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_TEMP,
+		.indexed = 1,
+		.channel = 0,
+		.info_mask = IIO_CHAN_INFO_OFFSET_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SEPARATE_BIT,
+		.address = temp,
+		.scan_type = {
+			.realbits = 12,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_IN,
+		.indexed = 1,
+		.channel = 1,
+		.info_mask = IIO_CHAN_INFO_SCALE_SEPARATE_BIT,
+		.address = in1,
+		.scan_type = {
+			.realbits = 12,
+			.sign = 'u',
+		},
+	},
+};
+
+static struct iio_chan_spec adis16350_channels[] = {
+	{
+		.type = IIO_VOLTAGE,
+		.indexed = 1,
+		.channel = 0,
+		.extend_name = "supply",
+		.info_mask = IIO_CHAN_INFO_SCALE_SEPARATE_BIT,
+		.address = in_supply,
+		.scan_type = {
+			.realbits = 12,
+			.sign = 'u',
+		},
+	}, {
+		.type = IIO_ANGL_VEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_X,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = gyro_x,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ANGL_VEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_Y,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = gyro_y,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ANGL_VEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_Z,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = gyro_z,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ACCEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_X,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = accel_x,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ACCEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_Y,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = accel_y,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ACCEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_Z,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = accel_z,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_TEMP,
+		.indexed = 1,
+		.channel = 0,
+		.extend_name = "x",
+		.info_mask = IIO_CHAN_INFO_OFFSET_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SEPARATE_BIT,
+		.address = temp0,
+		.scan_type = {
+			.realbits = 12,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_TEMP,
+		.indexed = 1,
+		.channel = 1,
+		.extend_name = "y",
+		.info_mask = IIO_CHAN_INFO_OFFSET_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SEPARATE_BIT,
+		.address = temp1,
+		.scan_type = {
+			.realbits = 12,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_TEMP,
+		.indexed = 1,
+		.channel = 2,
+		.extend_name = "z",
+		.info_mask = IIO_CHAN_INFO_OFFSET_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SEPARATE_BIT,
+		.address = temp2,
+		.scan_type = {
+			.realbits = 12,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_IN,
+		.indexed = 1,
+		.channel = 1,
+		.info_mask = IIO_CHAN_INFO_SCALE_SEPARATE_BIT,
+		.address = in1,
+		.scan_type = {
+			.realbits = 12,
+			.sign = 'u',
+		},
+	},
+};
+
+static struct iio_chan_spec adis16300_channels[] = {
+	{
+		.type = IIO_VOLTAGE,
+		.indexed = 1,
+		.channel = 0,
+		.extend_name = "supply",
+		.info_mask = IIO_CHAN_INFO_SCALE_SEPARATE_BIT,
+		.address = in_supply,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 'u',
+		},
+	}, {
+		.type = IIO_ANGL_VEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_X,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = gyro_x,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ACCEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_X,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = accel_x,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ACCEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_Y,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = accel_y,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ACCEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_Z,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = accel_z,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_TEMP,
+		.indexed = 1,
+		.channel = 0,
+		.info_mask = IIO_CHAN_INFO_OFFSET_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SEPARATE_BIT,
+		.address = temp,
+		.scan_type = {
+			.realbits = 12,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_IN,
+		.indexed = 1,
+		.channel = 1,
+		.info_mask = IIO_CHAN_INFO_SCALE_SEPARATE_BIT,
+		.address = in1,
+		.scan_type = {
+			.realbits = 12,
+			.sign = 'u',
+		},
+	}, {
+		.type = IIO_INCLI,
+		.modified = 1,
+		.channel2 = IIO_MOD_X,
+		.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = incli_x,
+		.scan_type = {
+			.realbits = 13,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_INCLI,
+		.modified = 1,
+		.channel2 = IIO_MOD_Y,
+		.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = incli_y,
+		.scan_type = {
+			.realbits = 13,
+			.sign = 's',
+		},
+	},
+};
+
+static const struct iio_chan_spec adis16334_channels[] = {
+	{
+		.type = IIO_ANGL_VEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_X,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = gyro_x,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ANGL_VEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_Y,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = gyro_y,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ANGL_VEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_Z,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = gyro_z,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ACCEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_X,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = accel_x,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ACCEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_Y,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = accel_y,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_ACCEL,
+		.modified = 1,
+		.channel2 = IIO_MOD_Z,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = accel_z,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	}, {
+		.type = IIO_TEMP,
+		.indexed = 1,
+		.channel = 0,
+		.info_mask = IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT |
+		IIO_CHAN_INFO_SCALE_SHARED_BIT,
+		.address = accel_z,
+		.scan_type = {
+			.realbits = 14,
+			.sign = 's',
+		},
+	},
+};
+
+static struct attribute *adis16400_attributes[] = {
+	&iio_dev_attr_sampling_frequency.dev_attr.attr,
+	&iio_const_attr_sampling_frequency_available.dev_attr.attr,
+	&iio_dev_attr_reset.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group adis16400_attribute_group = {
+	.attrs = adis16400_attributes,
+};
+
+static struct adis16400_chip_info adis16400_chips[] = {
+	[ADIS16300] = {
+		.channels = adis16300_channels,
+		.num_channels = ARRAY_SIZE(adis16300_channels),
+		.gyro_scale_micro = 873,
+		.accel_scale_micro = 5884,
+	},
+	[ADIS16334] = {
+		.channels = adis16334_channels,
+		.num_channels = ARRAY_SIZE(adis16334_channels),
+		.gyro_scale_micro = 873,
+		.accel_scale_micro = 981,
+	},
+	[ADIS16350] = {
+		.channels = adis16350_channels,
+		.num_channels = ARRAY_SIZE(adis16350_channels),
+		.gyro_scale_micro = 872664,
+		.accel_scale_micro = 24732,
+	},
+	[ADIS16360] = {
+		.channels = adis16350_channels,
+		.num_channels = ARRAY_SIZE(adis16350_channels),
+		.flags = ADIS16400_HAS_PROD_ID,
+		.product_id = 0x3FE8,
+		.gyro_scale_micro = 1279,
+		.accel_scale_micro = 24732,
+	},
+	[ADIS16362] = {
+		.channels = adis16350_channels,
+		.num_channels = ARRAY_SIZE(adis16350_channels),
+		.flags = ADIS16400_HAS_PROD_ID,
+		.product_id = 0x3FEA,
+		.gyro_scale_micro = 1279,
+		.accel_scale_micro = 24732,
+	},
+	[ADIS16364] = {
+		.channels = adis16350_channels,
+		.num_channels = ARRAY_SIZE(adis16350_channels),
+		.flags = ADIS16400_HAS_PROD_ID,
+		.product_id = 0x3FEC,
+		.gyro_scale_micro = 1279,
+		.accel_scale_micro = 24732,
+	},
+	[ADIS16365] = {
+		.channels = adis16350_channels,
+		.num_channels = ARRAY_SIZE(adis16350_channels),
+		.flags = ADIS16400_HAS_PROD_ID,
+		.product_id = 0x3FED,
+		.gyro_scale_micro = 1279,
+		.accel_scale_micro = 24732,
+	},
+	[ADIS16400] = {
+		.channels = adis16400_channels,
+		.num_channels = ARRAY_SIZE(adis16400_channels),
+		.flags = ADIS16400_HAS_PROD_ID,
+		.product_id = 0x4015,
+		.gyro_scale_micro = 873,
+		.accel_scale_micro = 32656,
+	}
+};
+
+static const struct iio_info adis16400_info = {
+	.driver_module = THIS_MODULE,
+	.read_raw = &adis16400_read_raw,
+	.write_raw = &adis16400_write_raw,
+	.attrs = &adis16400_attribute_group,
+};
+
+static int __devinit adis16400_probe(struct spi_device *spi)
+{
+	int ret;
+	struct adis16400_state *st;
+	struct iio_dev *indio_dev;
+
+	indio_dev = iio_device_allocate(sizeof(*st));
+	if (indio_dev == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	st = iio_priv(indio_dev);
+	/* this is only used for removal purposes */
+	spi_set_drvdata(spi, indio_dev);
+
+	st->us = spi;
+	mutex_init(&st->buf_lock);
+
+	/* setup the industrialio driver allocated elements */
+	st->variant = &adis16400_chips[spi_get_device_id(spi)->driver_data];
+	indio_dev->dev.parent = &spi->dev;
+	indio_dev->name = spi_get_device_id(spi)->name;
+	indio_dev->channels = st->variant->channels;
+	indio_dev->num_channels = st->variant->num_channels;
+	indio_dev->info = &adis16400_info;
+
+	ret = iio_device_register(indio_dev);
+	if (ret)
+		goto error_free_dev;
+
+	/* Get the device into a sane initial state */
+	ret = adis16400_initial_setup(indio_dev);
+	if (ret)
+		goto error_unregister_dev;
+
+	return 0;
+
+error_unregister_dev:
+	iio_device_unregister(indio_dev);
+error_free_dev:
+	iio_device_free(indio_dev);
+error_ret:
+	return ret;
+}
+
+/* fixme, confirm ordering in this function */
+static int adis16400_remove(struct spi_device *spi)
+{
+	int ret;
+	struct iio_dev *indio_dev = spi_get_drvdata(spi);
+
+	iio_device_unregister(indio_dev);
+
+	ret = adis16400_stop_device(indio_dev);
+	if (ret)
+		return ret;
+
+	iio_device_free(indio_dev);
+
+	return 0;
+}
+
+static const struct spi_device_id adis16400_id[] = {
+	{"adis16300", ADIS16300},
+	{"adis16334", ADIS16334},
+	{"adis16350", ADIS16350},
+	{"adis16354", ADIS16350},
+	{"adis16355", ADIS16350},
+	{"adis16360", ADIS16360},
+	{"adis16362", ADIS16362},
+	{"adis16364", ADIS16364},
+	{"adis16365", ADIS16365},
+	{"adis16400", ADIS16400},
+	{"adis16405", ADIS16400},
+	{}
+};
+
+static struct spi_driver adis16400_driver = {
+	.driver = {
+		.name = "adis16400",
+		.owner = THIS_MODULE,
+	},
+	.id_table = adis16400_id,
+	.probe = adis16400_probe,
+	.remove = __devexit_p(adis16400_remove),
+};
+
+static __init int adis16400_init(void)
+{
+	return spi_register_driver(&adis16400_driver);
+}
+module_init(adis16400_init);
+
+static __exit void adis16400_exit(void)
+{
+	spi_unregister_driver(&adis16400_driver);
+}
+module_exit(adis16400_exit);
+
+MODULE_AUTHOR("Manuel Stahl <manuel.stahl@iis.fraunhofer.de>");
+MODULE_DESCRIPTION("Analog Devices ADIS16400/5 IMU SPI driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.7.2

