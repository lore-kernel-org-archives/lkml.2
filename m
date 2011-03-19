Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab1CSK1O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 06:27:14 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:50053 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab1CSK1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 06:27:08 -0400
X-IronPort-AV: E=Sophos;i="4.63,209,1299474000"; 
   d="scan'208";a="30965876"
From: <cliff.cai@analog.com>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
CC: drivers@analog.com, jic23@cam.ac.uk,
        device-drivers-devel@blackfin.uclinux.org,
        Cliff Cai <cliff.cai@analog.com>, Cliff Cai <cliff@analog.com>
Subject: [PATCH RESEND v2]IIO driver for Analog Devices Digital Output Gyroscope ADXRS450
Date: Sat, 19 Mar 2011 17:27:26 +0800
Message-ID: <1300526846-27183-1-git-send-email-cliff.cai@analog.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

Change v2:v1:

Make modification according to Michael Hennerich's comments,
correct the spi transfer way,use existing sysfs interfaces.

Signed-off-by: Cliff Cai<cliff@analog.com>
---
 drivers/staging/iio/gyro/Kconfig         |   10 +
 drivers/staging/iio/gyro/Makefile        |    3 +
 drivers/staging/iio/gyro/adxrs450.h      |   59 ++++
 drivers/staging/iio/gyro/adxrs450_core.c |  471 ++++++++++++++++++++++++++++++
 4 files changed, 543 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/iio/gyro/adxrs450.h
 create mode 100644 drivers/staging/iio/gyro/adxrs450_core.c

diff --git a/drivers/staging/iio/gyro/Kconfig b/drivers/staging/iio/gyro/Kconfig
index 236f15f..3432967 100644
--- a/drivers/staging/iio/gyro/Kconfig
+++ b/drivers/staging/iio/gyro/Kconfig
@@ -45,3 +45,13 @@ config ADIS16251
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called adis16251.
+
+config ADXRS450
+	tristate "Analog Devices ADXRS450 Digital Output Gyroscope SPI driver"
+	depends on SPI
+	help
+	  Say yes here to build support for Analog Devices ADXRS450 programmable
+	  digital output gyroscope.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called adxrs450.
diff --git a/drivers/staging/iio/gyro/Makefile b/drivers/staging/iio/gyro/Makefile
index 2764c15..2212240 100644
--- a/drivers/staging/iio/gyro/Makefile
+++ b/drivers/staging/iio/gyro/Makefile
@@ -17,3 +17,6 @@ obj-$(CONFIG_ADIS16260) += adis16260.o
 
 adis16251-y             := adis16251_core.o
 obj-$(CONFIG_ADIS16251) += adis16251.o
+
+adxrs450-y             := adxrs450_core.o
+obj-$(CONFIG_ADXRS450) += adxrs450.o
diff --git a/drivers/staging/iio/gyro/adxrs450.h b/drivers/staging/iio/gyro/adxrs450.h
new file mode 100644
index 0000000..4633ef9
--- /dev/null
+++ b/drivers/staging/iio/gyro/adxrs450.h
@@ -0,0 +1,59 @@
+#ifndef SPI_ADXRS450_H_
+#define SPI_ADXRS450_H_
+
+#define ADXRS450_STARTUP_DELAY	50 /* ms */
+
+/* The MSB for the spi commands */
+#define ADXRS450_SENSOR_DATA    0x20
+#define ADXRS450_WRITE_DATA	0x40
+#define ADXRS450_READ_DATA	0x80
+
+#define ADXRS450_RATE1	0x00	/* Rate Registers */
+#define ADXRS450_TEMP1	0x02	/* Temperature Registers */
+#define ADXRS450_LOCST1	0x04	/* Low CST Memory Registers */
+#define ADXRS450_HICST1	0x06	/* High CST Memory Registers */
+#define ADXRS450_QUAD1	0x08	/* Quad Memory Registers */
+#define ADXRS450_FAULT1	0x0A	/* Fault Registers */
+#define ADXRS450_PID1	0x0C	/* Part ID Register 1 */
+#define ADXRS450_PID0	0x0D	/* Part ID Register 0 */
+#define ADXRS450_SNH	0x0E	/* Serial Number Registers, 4 bytes */
+#define ADXRS450_SNL	0x10
+#define ADXRS450_DNC1	0x12	/* Dynamic Null Correction Registers */
+/* Check bits */
+#define ADXRS450_P	0x01
+#define ADXRS450_CHK	0x02
+#define ADXRS450_CST	0x04
+#define ADXRS450_PWR	0x08
+#define ADXRS450_POR	0x10
+#define ADXRS450_NVM	0x20
+#define ADXRS450_Q	0x40
+#define ADXRS450_PLL	0x80
+#define ADXRS450_UV	0x100
+#define ADXRS450_OV	0x200
+#define ADXRS450_AMP	0x400
+#define ADXRS450_FAIL	0x800
+
+#define ADXRS450_WRERR_MASK	(0x7 << 29)
+
+#define ADXRS450_MAX_RX 8
+#define ADXRS450_MAX_TX 8
+
+#define ADXRS450_GET_ST(a)	((a >> 26) & 0x3)
+
+/**
+ * struct adxrs450_state - device instance specific data
+ * @us:			actual spi_device
+ * @indio_dev:		industrial I/O device structure
+ * @tx:			transmit buffer
+ * @rx:			recieve buffer
+ * @buf_lock:		mutex to protect tx and rx
+ **/
+struct adxrs450_state {
+	struct spi_device		*us;
+	struct iio_dev			*indio_dev;
+	u8				*tx;
+	u8				*rx;
+	struct mutex			buf_lock;
+};
+
+#endif /* SPI_ADXRS450_H_ */
diff --git a/drivers/staging/iio/gyro/adxrs450_core.c b/drivers/staging/iio/gyro/adxrs450_core.c
new file mode 100644
index 0000000..f4f9d49
--- /dev/null
+++ b/drivers/staging/iio/gyro/adxrs450_core.c
@@ -0,0 +1,471 @@
+/*
+ * ADXRS450 Digital Output Gyroscope Driver
+ *
+ * Copyright 2010 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/mutex.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/spi/spi.h>
+#include <linux/slab.h>
+#include <linux/sysfs.h>
+#include <linux/list.h>
+
+#include "../iio.h"
+#include "../sysfs.h"
+#include "gyro.h"
+#include "../adc/adc.h"
+
+#include "adxrs450.h"
+
+#define DRIVER_NAME		"ADXRS450"
+
+/**
+ * adxrs450_spi_read_reg_16() - read 2 bytes from a register pair
+ * @dev: device associated with child of actual device (iio_dev or iio_trig)
+ * @reg_address: the address of the lower of the two registers,which should be an even address,
+ * Second register's address is reg_address + 1.
+ * @val: somewhere to pass back the value read
+ **/
+static int adxrs450_spi_read_reg_16(struct device *dev,
+		u8 reg_address,
+		u16 *val)
+{
+	struct spi_message msg;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct adxrs450_state *st = iio_dev_get_devdata(indio_dev);
+	int ret;
+	struct spi_transfer xfers[] = {
+		{
+			.tx_buf = st->tx,
+			.rx_buf = st->rx,
+			.bits_per_word = 8,
+			.len = 4,
+		},
+	};
+	/* Needs to send the command twice to get the wanted value */
+	mutex_lock(&st->buf_lock);
+	st->tx[0] = ADXRS450_READ_DATA | reg_address >> 7;
+	st->tx[1] = reg_address << 1;
+	st->tx[2] = 0;
+	st->tx[3] = 0;
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfers[0], &msg);
+	ret = spi_sync(st->us, &msg);
+	if (ret) {
+		dev_err(&st->us->dev, "problem while reading 16 bit register 0x%02x\n",
+				reg_address);
+		goto error_ret;
+	}
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfers[0], &msg);
+	ret = spi_sync(st->us, &msg);
+	if (ret) {
+		dev_err(&st->us->dev, "problem while reading 16 bit register 0x%02x\n",
+				reg_address);
+		goto error_ret;
+	}
+
+	*val = (st->rx[1] & 0x1f) << 11 | st->rx[2] << 3 | (st->rx[3] & 0xe0) >> 5;
+
+error_ret:
+	mutex_unlock(&st->buf_lock);
+	return ret;
+}
+
+/**
+ * adxrs450_spi_write_reg_16() - write 2 bytes data to a register pair
+ * @dev: device associated with child of actual device (iio_dev or iio_trig)
+ * @reg_address: the address of the lower of the two registers,which should be an even address,
+ * Second register's address is reg_address + 1.
+ * @val: value to be written.
+ **/
+static int adxrs450_spi_write_reg_16(struct device *dev,
+		u8 reg_address,
+		u16 *val)
+{
+	struct spi_message msg;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct adxrs450_state *st = iio_dev_get_devdata(indio_dev);
+	int ret;
+	struct spi_transfer xfers[] = {
+		{
+			.tx_buf = st->tx,
+			.rx_buf = st->rx,
+			.bits_per_word = 8,
+			.len = 4,
+		},
+	};
+
+	mutex_lock(&st->buf_lock);
+	st->tx[0] = ADXRS450_WRITE_DATA | reg_address >> 7;
+	st->tx[1] = reg_address << 1 | *val >> 15;
+	st->tx[2] = *val >> 7;
+	st->tx[3] = *val << 1;
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfers[0], &msg);
+	ret = spi_sync(st->us, &msg);
+	if (ret) {
+		dev_err(&st->us->dev, "problem while writing 16 bit register 0x%02x\n",
+				reg_address);
+		goto error_ret;
+	}
+
+error_ret:
+	mutex_unlock(&st->buf_lock);
+	return ret;
+}
+
+/**
+ * adxrs450_spi_sensor_data() - read 2 bytes sensor data
+ * @dev: device associated with child of actual device (iio_dev or iio_trig)
+ * @val: somewhere to pass back the value read
+ **/
+static int adxrs450_spi_sensor_data(struct device *dev, u16 *val)
+{
+	struct spi_message msg;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct adxrs450_state *st = iio_dev_get_devdata(indio_dev);
+	int ret;
+	struct spi_transfer xfers[] = {
+		{
+			.tx_buf = st->tx,
+			.rx_buf = st->rx,
+			.bits_per_word = 8,
+			.len = 4,
+		}
+	};
+
+	mutex_lock(&st->buf_lock);
+	st->tx[0] = ADXRS450_SENSOR_DATA;
+	st->tx[1] = 0;
+	st->tx[2] = 0;
+	st->tx[3] = 0;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfers[0], &msg);
+	ret = spi_sync(st->us, &msg);
+	if (ret) {
+		dev_err(&st->us->dev, "Problem while reading sensor data\n");
+		goto error_ret;
+	}
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfers[0], &msg);
+	ret = spi_sync(st->us, &msg);
+	if (ret) {
+		dev_err(&st->us->dev, "Problem while reading sensor data\n");
+		goto error_ret;
+	}
+
+	*val = (st->rx[0] & 0x03) << 14 | st->rx[1] << 6 | (st->rx[2] & 0xfc) >> 2;
+error_ret:
+	mutex_unlock(&st->buf_lock);
+	return ret;
+}
+
+/**
+ * adxrs450_spi_initial() - use for initializing procedure.
+ * @dev: device associated with child of actual device (iio_dev or iio_trig)
+ * @val: somewhere to pass back the value read
+ **/
+static int adxrs450_spi_initial(struct device *dev,
+		u32 *val, char chk)
+{
+	struct spi_message msg;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct adxrs450_state *st = iio_dev_get_devdata(indio_dev);
+	int ret;
+	struct spi_transfer xfers[] = {
+		{
+			.tx_buf = st->tx,
+			.rx_buf = st->rx,
+			.bits_per_word = 8,
+			.len = 4,
+		},
+	};
+
+	mutex_lock(&st->buf_lock);
+	st->tx[0] = ADXRS450_SENSOR_DATA;
+	st->tx[1] = 0;
+	st->tx[2] = 0;
+	st->tx[3] = 0;
+	if (chk)
+		st->tx[3] |= (ADXRS450_CHK | ADXRS450_P);
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfers[0], &msg);
+	ret = spi_sync(st->us, &msg);
+	if (ret) {
+		dev_err(&st->us->dev, "Problem while reading initializing data\n");
+		goto error_ret;
+	}
+
+	*val = st->rx[0] << 24 | st->rx[1] << 16 | st->rx[2] << 8 | st->rx[3];
+
+error_ret:
+	mutex_unlock(&st->buf_lock);
+	return ret;
+}
+
+static ssize_t adxrs450_read_temp(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	int ret, len = 0;
+	u16 t;
+	ret = adxrs450_spi_read_reg_16(dev,
+			ADXRS450_TEMP1,
+			&t);
+	if (ret)
+		return ret;
+	len = sprintf(buf, "%d\n", t);
+	return len;
+}
+
+static ssize_t adxrs450_read_quad(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	int ret, len = 0;
+	u16 t;
+	ret = adxrs450_spi_read_reg_16(dev,
+			ADXRS450_QUAD1,
+			&t);
+	if (ret)
+		return ret;
+	len = sprintf(buf, "%d\n", t);
+	return len;
+}
+
+static ssize_t adxrs450_write_dnc(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf,
+		size_t len)
+{
+	int ret;
+	u16 val;
+
+	if (len == 0 || len > 2)
+		return -EINVAL;
+	memcpy(&val, buf, len);
+	ret = adxrs450_spi_write_reg_16(dev,
+			ADXRS450_DNC1,
+			&val);
+	return ret ? ret : len;
+}
+
+static ssize_t adxrs450_read_sensor_data(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	int ret, len = 0;
+	u16 t;
+
+	ret = adxrs450_spi_sensor_data(dev, &t);
+	if (ret)
+		return ret;
+
+	len = sprintf(buf, "%d\n", t);
+	return len;
+}
+
+/* Recommended Startup Sequence by spec */
+static int adxrs450_initial_setup(struct adxrs450_state *st)
+{
+	u32 t;
+	u16 data;
+	int ret;
+	struct device *dev = &st->indio_dev->dev;
+
+	msleep(ADXRS450_STARTUP_DELAY*2);
+	ret = adxrs450_spi_initial(dev, &t, 1);
+	if (ret)
+		return ret;
+	if (t != 0x01) {
+		dev_err(&st->us->dev, "The initial response is not correct!\n");
+		return -ENODEV;
+
+	}
+
+	msleep(ADXRS450_STARTUP_DELAY);
+	ret = adxrs450_spi_initial(dev, &t, 0);
+	if (ret)
+		return ret;
+
+	msleep(ADXRS450_STARTUP_DELAY);
+	ret = adxrs450_spi_initial(dev, &t, 0);
+	if (ret)
+		return ret;
+	if (((t & 0xff) | 0x01) != 0xff || ADXRS450_GET_ST(t) != 2) {
+		dev_err(&st->us->dev, "The second response is not correct!\n");
+		return -EIO;
+
+	}
+	ret = adxrs450_spi_initial(dev, &t, 0);
+	if (ret)
+		return ret;
+	if (((t & 0xff) | 0x01) != 0xff || ADXRS450_GET_ST(t) != 2) {
+		dev_err(&st->us->dev, "The third response is not correct!\n");
+		return -EIO;
+
+	}
+	ret = adxrs450_spi_read_reg_16(dev, ADXRS450_FAULT1, &data);
+	if (ret)
+		return ret;
+	if (data & 0x0fff) {
+		dev_err(&st->us->dev, "The device is not in normal status!\n");
+		return -EINVAL;
+	}
+	ret = adxrs450_spi_read_reg_16(dev, ADXRS450_PID1, &data);
+	if (ret)
+		return ret;
+	dev_info(&st->us->dev, "The Part ID is 0x%x\n", data);
+
+	ret = adxrs450_spi_read_reg_16(dev, ADXRS450_SNL, &data);
+	if (ret)
+		return ret;
+	t = data;
+	ret = adxrs450_spi_read_reg_16(dev, ADXRS450_SNH, &data);
+	if (ret)
+		return ret;
+	t |= data << 16;
+	dev_info(&st->us->dev, "The Serial Number is 0x%x\n", t);
+
+	dev_info(&st->us->dev, "%s at CS%d\n", DRIVER_NAME,
+			st->us->chip_select);
+
+	return 0;
+}
+
+static IIO_DEV_ATTR_GYRO_Z(adxrs450_read_sensor_data, 0);
+static IIO_DEV_ATTR_TEMP_RAW(adxrs450_read_temp);
+static IIO_DEVICE_ATTR(quad, S_IRUGO,
+		adxrs450_read_quad, NULL, 0);
+static IIO_DEVICE_ATTR(dynamic_null_correction, S_IWUGO,
+		NULL, adxrs450_write_dnc, 0);
+static IIO_CONST_ATTR(name, "adxrs450");
+
+static struct attribute *adxrs450_attributes[] = {
+
+	&iio_dev_attr_gyro_z_raw.dev_attr.attr,
+	&iio_dev_attr_temp_raw.dev_attr.attr,
+	&iio_dev_attr_quad.dev_attr.attr,
+	&iio_dev_attr_dynamic_null_correction.dev_attr.attr,
+	&iio_const_attr_name.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group adxrs450_attribute_group = {
+	.attrs = adxrs450_attributes,
+};
+
+static int __devinit adxrs450_probe(struct spi_device *spi)
+{
+	int ret, regdone = 0;
+	struct adxrs450_state *st = kzalloc(sizeof *st, GFP_KERNEL);
+	if (!st) {
+		ret =  -ENOMEM;
+		goto error_ret;
+	}
+	/* This is only used for removal purposes */
+	spi_set_drvdata(spi, st);
+
+	/* Allocate the comms buffers */
+	st->rx = kzalloc(sizeof(*st->rx)*ADXRS450_MAX_RX, GFP_KERNEL);
+	if (st->rx == NULL) {
+		ret = -ENOMEM;
+		goto error_free_st;
+	}
+	st->tx = kzalloc(sizeof(*st->tx)*ADXRS450_MAX_TX, GFP_KERNEL);
+	if (st->tx == NULL) {
+		ret = -ENOMEM;
+		goto error_free_rx;
+	}
+	st->us = spi;
+	mutex_init(&st->buf_lock);
+	/* setup the industrialio driver allocated elements */
+	st->indio_dev = iio_allocate_device();
+	if (st->indio_dev == NULL) {
+		ret = -ENOMEM;
+		goto error_free_tx;
+	}
+
+	st->indio_dev->dev.parent = &spi->dev;
+	st->indio_dev->attrs = &adxrs450_attribute_group;
+	st->indio_dev->dev_data = (void *)(st);
+	st->indio_dev->driver_module = THIS_MODULE;
+	st->indio_dev->modes = INDIO_DIRECT_MODE;
+
+	ret = iio_device_register(st->indio_dev);
+	if (ret)
+		goto error_free_dev;
+	regdone = 1;
+
+	/* Get the device into a sane initial state */
+	ret = adxrs450_initial_setup(st);
+	if (ret)
+		goto error_initial;
+	return 0;
+
+error_initial:
+error_free_dev:
+	if (regdone)
+		iio_device_unregister(st->indio_dev);
+	else
+		iio_free_device(st->indio_dev);
+error_free_tx:
+	kfree(st->tx);
+error_free_rx:
+	kfree(st->rx);
+error_free_st:
+	kfree(st);
+error_ret:
+	return ret;
+}
+
+/* fixme, confirm ordering in this function */
+static int adxrs450_remove(struct spi_device *spi)
+{
+	struct adxrs450_state *st = spi_get_drvdata(spi);
+	struct iio_dev *indio_dev = st->indio_dev;
+
+	iio_device_unregister(indio_dev);
+	kfree(st->tx);
+	kfree(st->rx);
+	kfree(st);
+
+	return 0;
+}
+
+static struct spi_driver adxrs450_driver = {
+	.driver = {
+		.name = "adxrs450",
+		.owner = THIS_MODULE,
+	},
+	.probe = adxrs450_probe,
+	.remove = __devexit_p(adxrs450_remove),
+};
+
+static __init int adxrs450_init(void)
+{
+	return spi_register_driver(&adxrs450_driver);
+}
+module_init(adxrs450_init);
+
+static __exit void adxrs450_exit(void)
+{
+	spi_unregister_driver(&adxrs450_driver);
+}
+module_exit(adxrs450_exit);
+
+MODULE_AUTHOR("Cliff Cai <cliff.cai@analog.com>");
+MODULE_DESCRIPTION("Analog Devices ADXRS450 Gyroscope SPI driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.1

