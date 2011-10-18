Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab1JRMHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 08:07:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53163 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab1JRMHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 08:07:02 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, jic23@cam.ac.uk, hemanthv@ti.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCHv2 5/7] Input: add CMR3000 gyrsocope driver
Date: Tue, 18 Oct 2011 14:06:34 +0200
Message-Id: <1318939596-27330-6-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1318939596-27330-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1318939596-27330-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for CMR3000 Tri-axis accelerometer. CMR3000 supports both
I2C/SPI bus communication, currently the driver supports SPI
communication, since I have no hardware to test the I2C communication.

---

v3: Fixes suggested by Jonathan Cameron
	-Code Stype
	-Check pdata!=NULL
	-SPI align Cacheline
	-More clear based on
	-%s/set/write/
	-%s/accl/gyro/
	-remove READ/SET macros

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/input/misc/Kconfig           |   24 ++
 drivers/input/misc/Makefile          |    2 +
 drivers/input/misc/cmr3000_d0x.c     |  382 ++++++++++++++++++++++++++++++++++
 drivers/input/misc/cmr3000_d0x.h     |   45 ++++
 drivers/input/misc/cmr3000_d0x_spi.c |  178 ++++++++++++++++
 include/linux/input/cmr3000.h        |   54 +++++
 6 files changed, 685 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/cmr3000_d0x.c
 create mode 100644 drivers/input/misc/cmr3000_d0x.h
 create mode 100644 drivers/input/misc/cmr3000_d0x_spi.c
 create mode 100644 include/linux/input/cmr3000.h

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index b9f2e93..7c56f94 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -524,6 +524,30 @@ config INPUT_CMA3000_SPI
 	  To compile this driver as a module, choose M here: the
 	  module will be called cma3000_d0x_spi.
 
+config INPUT_CMR3000
+	tristate "VTI CMR3000 Tri-axis gyroscope"
+	help
+	  Say Y here if you want to use VTI CMR3000_D0x Gyroscope
+	  driver
+
+	  This driver currently only supports SPI interface to the
+	  controller. Also select the SPI method.
+
+	  If unsure, say N
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cmr3000_d0x.
+
+config INPUT_CMR3000_SPI
+	tristate "Support SPI bus connection"
+	depends on INPUT_CMR3000 && SPI
+	help
+	  Say Y here if you want to use VTI CMR3000_D0x Gyroscope
+	  through SPI interface.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cmr3000_d0x_spi.
+
 config INPUT_XEN_KBDDEV_FRONTEND
 	tristate "Xen virtual keyboard and mouse support"
 	depends on XEN_FBDEV_FRONTEND
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 7305f6f..c7fe09a 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -21,6 +21,8 @@ obj-$(CONFIG_INPUT_CM109)		+= cm109.o
 obj-$(CONFIG_INPUT_CMA3000)		+= cma3000_d0x.o
 obj-$(CONFIG_INPUT_CMA3000_I2C)		+= cma3000_d0x_i2c.o
 obj-$(CONFIG_INPUT_CMA3000_SPI)		+= cma3000_d0x_spi.o
+obj-$(CONFIG_INPUT_CMR3000)		+= cmr3000_d0x.o
+obj-$(CONFIG_INPUT_CMR3000_SPI)		+= cmr3000_d0x_spi.o
 obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
 obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
diff --git a/drivers/input/misc/cmr3000_d0x.c b/drivers/input/misc/cmr3000_d0x.c
new file mode 100644
index 0000000..a8b3e8b
--- /dev/null
+++ b/drivers/input/misc/cmr3000_d0x.c
@@ -0,0 +1,382 @@
+/*
+ * VTI CMR3000_D0x Gyroscope driver
+ *
+ * Copyright (C) 2011 Qtechnology
+ * Author: Ricardo Ribalda <ricardo.ribalda@gmail.com>
+ *
+ * Based on:
+ *	drivers/input/misc/cma3000_d0x.c by: Hemanth V
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/input.h>
+#include <linux/input/cmr3000.h>
+
+#include "cmr3000_d0x.h"
+
+#define CMR3000_REV         0x21
+
+#define CMR3000_WHOAMI      0x00
+#define CMR3000_REVID       0x01
+#define CMR3000_CTRL        0x02
+#define CMR3000_STATUS      0x03
+#define CMR3000_X_LSB       0x0C
+#define CMR3000_X_MSB       0x0D
+#define CMR3000_Y_LSB       0x0E
+#define CMR3000_Y_MSB       0x0F
+#define CMR3000_Z_LSB       0x10
+#define CMR3000_Z_MSB       0x11
+#define CMR3000_I2C_ADDR    0x22
+#define CMR3000_PDR         0x26
+
+#define CMR3000_IRQDIS     (1 << 0)
+#define CMR3000_MODEMASK   (3 << 1)
+#define CMR3000_BUSI2C     (0 << 4)
+#define CMR3000_BUSSPI     (1 << 4)
+#define CMR3000_INTLOW     (1 << 6)
+#define CMR3000_INTHIGH    (0 << 6)
+#define CMR3000_RST        (1 << 7)
+
+#define CMRMODE_SHIFT      1
+#define CMRIRQLEVEL_SHIFT  6
+
+#define CMR3000_STATUS_PERR    (1 << 0)
+#define CMR3000_STATUS_PORST   (1 << 3)
+
+/* Settling time delay in ms */
+#define CMR3000_SETDELAY    30
+
+/*
+ * Bit weights mult/div in dps for bit 0, other bits need
+ * multipy factor 2^n. 11th bit is the sign bit.
+ */
+#define BIT_TO_DPS_MUL  3
+#define BIT_TO_DPS_DIV 32
+
+static struct cmr3000_platform_data cmr3000_default_pdata = {
+	.irq_level = CMR3000_INTHIGH,
+	.mode = CMRMODE_MEAS80,
+	.irqflags = 0,
+	.fuzz_x = 1,
+	.fuzz_y = 1,
+	.fuzz_z = 1,
+};
+
+struct cmr3000_gyro_data {
+	const struct cmr3000_bus_ops *bus_ops;
+	const struct cmr3000_platform_data *pdata;
+
+	struct device *dev;
+	struct input_dev *input_dev;
+
+	int irq_level;
+	u8 mode;
+
+	int bit_to_mg;
+	int irq;
+
+	struct mutex mutex;
+	bool opened;
+	bool suspended;
+};
+
+static void decode_dps(struct cmr3000_gyro_data *data, int *datax,
+		       int *datay, int *dataz)
+{
+	/* Data in 2's complement, convert to dps */
+	*datax = (((s16) ((*datax) << 2)) * BIT_TO_DPS_MUL) / BIT_TO_DPS_DIV;
+	*datay = (((s16) ((*datay) << 2)) * BIT_TO_DPS_MUL) / BIT_TO_DPS_DIV;
+	*dataz = (((s16) ((*dataz) << 2)) * BIT_TO_DPS_MUL) / BIT_TO_DPS_DIV;
+}
+
+static irqreturn_t cmr3000_thread_irq(int irq, void *dev_id)
+{
+	struct cmr3000_gyro_data *data = dev_id;
+	int datax, datay, dataz;
+	u8 mode, intr_status;
+
+	intr_status = data->bus_ops->read(data->dev, CMR3000_STATUS,
+							"irq status");
+	intr_status = data->bus_ops->read(data->dev, CMR3000_CTRL,
+							"control mode");
+	if (intr_status < 0)
+		return IRQ_NONE;
+
+	/* Interrupt not for this device */
+	if (intr_status & CMR3000_IRQDIS)
+		return IRQ_NONE;
+
+	mode = (intr_status & CMR3000_MODEMASK) >> CMRMODE_SHIFT;
+	if ((mode != CMRMODE_MEAS80)
+	    && (mode != CMRMODE_MEAS20))
+		return IRQ_NONE;
+
+	datax = (data->bus_ops->read(data->dev, CMR3000_X_MSB, "X_MSB")) << 8;
+	datax |= data->bus_ops->read(data->dev, CMR3000_X_LSB, "X_LSB");
+	datay = (data->bus_ops->read(data->dev, CMR3000_Y_MSB, "Y_MSB")) << 8;
+	datay |= data->bus_ops->read(data->dev, CMR3000_Y_LSB, "Y_LSB");
+	dataz = (data->bus_ops->read(data->dev, CMR3000_Z_MSB, "Z_MSB")) << 8;
+	dataz |= data->bus_ops->read(data->dev, CMR3000_Z_LSB, "Z_LSB");
+
+	/* Device closed */
+	if ((data->mode != CMRMODE_MEAS80)
+	    && (data->mode != CMRMODE_MEAS20))
+		return IRQ_NONE;
+
+	/* Decode register values to dps */
+	decode_dps(data, &datax, &datay, &dataz);
+
+	input_report_abs(data->input_dev, ABS_X, datax);
+	input_report_abs(data->input_dev, ABS_Y, datay);
+	input_report_abs(data->input_dev, ABS_Z, dataz);
+	input_sync(data->input_dev);
+
+	return IRQ_HANDLED;
+}
+
+static int cmr3000_poweron(struct cmr3000_gyro_data *data)
+{
+	const struct cmr3000_platform_data *pdata = data->pdata;
+	u8 ctrl;
+	int ret;
+
+	ctrl = pdata->irq_level << CMRIRQLEVEL_SHIFT;
+	ctrl |= data->mode << CMRMODE_SHIFT;
+	ctrl |= data->bus_ops->ctrl_mod;
+	ret = data->bus_ops->write(data->dev, CMR3000_CTRL, ctrl,
+							"Mode setting");
+	if (ret < 0)
+		return -EIO;
+
+	msleep(CMR3000_SETDELAY);
+
+	return 0;
+}
+
+static int cmr3000_poweroff(struct cmr3000_gyro_data *data)
+{
+	int ret;
+	u8 ctrl = CMRMODE_POFF;
+
+	ctrl |= data->bus_ops->ctrl_mod;
+	ctrl |= CMR3000_IRQDIS;
+
+	ret = data->bus_ops->write(data->dev, CMR3000_CTRL, ctrl,
+							"Mode setting");
+	msleep(CMR3000_SETDELAY);
+
+	return ret;
+}
+
+static int cmr3000_reset(struct cmr3000_gyro_data *data)
+{
+	int val;
+
+	/* Reset chip */
+	data->bus_ops->write(data->dev, CMR3000_CTRL, CMR3000_RST, "Reset");
+	mdelay(2);
+
+	/* Settling time delay */
+	val = data->bus_ops->read(data->dev, CMR3000_STATUS, "Status");
+	if (val < 0) {
+		dev_err(data->dev, "Reset failed\n");
+		return val;
+	}
+
+	if (val & CMR3000_STATUS_PERR) {
+		dev_err(data->dev, "Parity Error\n");
+		return -EIO;
+	}
+
+	return cmr3000_poweroff(data);
+}
+
+static int cmr3000_open(struct input_dev *input_dev)
+{
+	struct cmr3000_gyro_data *data = input_get_drvdata(input_dev);
+
+	mutex_lock(&data->mutex);
+
+	if (!data->suspended)
+		cmr3000_poweron(data);
+
+	data->opened = true;
+
+	mutex_unlock(&data->mutex);
+
+	return 0;
+}
+
+static void cmr3000_close(struct input_dev *input_dev)
+{
+	struct cmr3000_gyro_data *data = input_get_drvdata(input_dev);
+
+	mutex_lock(&data->mutex);
+
+	if (!data->suspended)
+		cmr3000_poweroff(data);
+
+	data->opened = false;
+
+	mutex_unlock(&data->mutex);
+}
+
+void cmr3000_suspend(struct cmr3000_gyro_data *data)
+{
+	mutex_lock(&data->mutex);
+
+	if (!data->suspended && data->opened)
+		cmr3000_poweroff(data);
+
+	data->suspended = true;
+
+	mutex_unlock(&data->mutex);
+}
+EXPORT_SYMBOL(cmr3000_suspend);
+
+void cmr3000_resume(struct cmr3000_gyro_data *data)
+{
+	mutex_lock(&data->mutex);
+
+	if (data->suspended && data->opened)
+		cmr3000_poweron(data);
+
+	data->suspended = false;
+
+	mutex_unlock(&data->mutex);
+}
+EXPORT_SYMBOL(cmr3000_resume);
+
+struct cmr3000_gyro_data *cmr3000_init(struct device *dev, int irq,
+				       const struct cmr3000_bus_ops *bops)
+{
+	const struct cmr3000_platform_data *pdata = dev->platform_data;
+	struct cmr3000_gyro_data *data;
+	struct input_dev *input_dev;
+	int rev;
+	int error;
+
+	if (pdata == NULL) {
+		dev_info(dev, "platform data not found, using default\n");
+		pdata = &cmr3000_default_pdata;
+	}
+
+	/* if no IRQ return error */
+	if (irq == 0) {
+		error = -EINVAL;
+		goto err_out;
+	}
+
+	data = kzalloc(sizeof(struct cmr3000_gyro_data), GFP_KERNEL);
+	input_dev = input_allocate_device();
+	if (!data || !input_dev) {
+		error = -ENOMEM;
+		goto err_free_mem;
+	}
+
+	data->dev = dev;
+	data->input_dev = input_dev;
+	data->bus_ops = bops;
+	data->pdata = pdata;
+	data->irq = irq;
+	mutex_init(&data->mutex);
+
+	data->mode = pdata->mode;
+	if ((data->mode != CMRMODE_MEAS80)
+	    && (data->mode != CMRMODE_MEAS20)) {
+		data->mode = CMRMODE_MEAS80;
+		dev_warn(dev, "Invalid mode specified, assuming 80Hz\n");
+	}
+
+	data->irq_level = pdata->irq_level;
+	if ((data->irq_level != CMR3000_INTLOW)
+	    && (data->irq_level != CMR3000_INTHIGH)) {
+		data->irq_level = CMR3000_INTHIGH;
+		dev_warn(data->dev,
+			 "Invalid int level specified, assuming high\n");
+	}
+
+	input_dev->name = "cmr3000-gyroscope";
+	input_dev->id.bustype = bops->bustype;
+	input_dev->open = cmr3000_open;
+	input_dev->close = cmr3000_close;
+
+	__set_bit(EV_ABS, input_dev->evbit);
+
+	input_set_abs_params(input_dev, ABS_X,
+			     -CMRRANGE, CMRRANGE, pdata->fuzz_x, 0);
+	input_set_abs_params(input_dev, ABS_Y,
+			     -CMRRANGE, CMRRANGE, pdata->fuzz_y, 0);
+	input_set_abs_params(input_dev, ABS_Z,
+			     -CMRRANGE, CMRRANGE, pdata->fuzz_z, 0);
+
+	input_set_drvdata(input_dev, data);
+
+	error = cmr3000_reset(data);
+	if (error)
+		goto err_free_mem;
+
+	rev = data->bus_ops->read(data->dev, CMR3000_REVID, "Revid");
+	if (rev < 0) {
+		error = rev;
+		goto err_free_mem;
+	}
+	if (rev != CMR3000_REV) {
+		error = -EINVAL;
+		pr_err("CMR3000 Gyroscope: Unknown Revision %x\n", rev);
+		goto err_free_mem;
+	}
+	pr_info("CMR3000 Gyroscope: Revision %x\n", rev);
+
+	error = request_threaded_irq(irq, NULL, cmr3000_thread_irq,
+				     pdata->irqflags | IRQF_ONESHOT,
+				     "cmr3000_d0x", data);
+	if (error) {
+		dev_err(dev, "request_threaded_irq failed\n");
+		goto err_free_mem;
+	}
+
+	error = input_register_device(data->input_dev);
+	if (error) {
+		dev_err(dev, "Unable to register input device\n");
+		goto err_free_irq;
+	}
+
+	return data;
+
+err_free_irq:
+	free_irq(irq, data);
+err_free_mem:
+	input_free_device(input_dev);
+	kfree(data);
+err_out:
+	return ERR_PTR(error);
+}
+EXPORT_SYMBOL(cmr3000_init);
+
+void cmr3000_exit(struct cmr3000_gyro_data *data)
+{
+	input_unregister_device(data->input_dev);
+	free_irq(data->irq, data);
+	kfree(data);
+}
+EXPORT_SYMBOL(cmr3000_exit);
+
+MODULE_DESCRIPTION("CMR3000-D0x Gyroscope Driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ricardo Ribalda <ricardo.ribalda@gmail.com>");
diff --git a/drivers/input/misc/cmr3000_d0x.h b/drivers/input/misc/cmr3000_d0x.h
new file mode 100644
index 0000000..3d0984a
--- /dev/null
+++ b/drivers/input/misc/cmr3000_d0x.h
@@ -0,0 +1,45 @@
+/*
+ * VTI CMR3000_D0x Gyroscpe driver
+ *
+ * Copyright (C) 2011 Qtechnology
+ * Author: Ricardo Ribalda <ricardo.ribalda@gmail.com>
+ *
+ * Based on:
+ *	drivers/input/misc/cma3000_d0x.h by Hemanth V
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _INPUT_CMR3000_H
+#define _INPUT_CMR3000_H
+
+#include <linux/types.h>
+#include <linux/input.h>
+
+struct device;
+struct cmr3000_gyro_data;
+
+struct cmr3000_bus_ops {
+	u16 bustype;
+	u8 ctrl_mod;
+	int (*read) (struct device *, u8, char *);
+	int (*write) (struct device *, u8, u8, char *);
+};
+
+struct cmr3000_gyro_data *cmr3000_init(struct device *dev, int irq,
+				       const struct cmr3000_bus_ops *bops);
+void cmr3000_exit(struct cmr3000_gyro_data *);
+void cmr3000_suspend(struct cmr3000_gyro_data *);
+void cmr3000_resume(struct cmr3000_gyro_data *);
+
+#endif
diff --git a/drivers/input/misc/cmr3000_d0x_spi.c b/drivers/input/misc/cmr3000_d0x_spi.c
new file mode 100644
index 0000000..6243437
--- /dev/null
+++ b/drivers/input/misc/cmr3000_d0x_spi.c
@@ -0,0 +1,178 @@
+/*
+ * Implements SPI interface for VTI CMR300_D0x Accelerometer driver
+ *
+ * Copyright (C) 2011 Qtechnology
+ * Author: Ricardo Ribalda <ricardo.ribalda@gmail.com.com>
+ * Based on:
+ *	drivers/input/misc/cma3000_d0x_i2c.c by Hemanth V
+ *	drivers/input/mis/adxl34x-spi.c	by Michael Hennerich
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/spi/spi.h>
+#include <linux/input/cmr3000.h>
+#include "cmr3000_d0x.h"
+
+enum { DO_READ = 0, DO_WRITE };
+
+static int cmr3000_spi_cmd(struct spi_device *spi, u8 reg, u8 * val, int cmd,
+			   char *msg)
+{
+	int ret;
+	unsigned char tx_buf[2];
+	unsigned char rx_buf[2];
+	struct spi_transfer t = {
+		.rx_buf = rx_buf,
+		.tx_buf = tx_buf,
+		.len = 2,
+	};
+	struct spi_message m;
+
+	if (cmd == DO_WRITE) {
+		tx_buf[0] = (reg << 2) | 2;
+		tx_buf[1] = *val;
+	} else {
+		tx_buf[0] = reg << 2;
+		tx_buf[1] = 0;
+	}
+	spi_message_init(&m);
+	spi_message_add_tail(&t, &m);
+	ret = spi_sync(spi, &m);
+	if (ret < 0) {
+		dev_err(&spi->dev, "%s failed (%s, %d)\n", __func__, msg, ret);
+		return ret;
+	}
+	if (cmd == DO_READ)
+		*val = rx_buf[1];
+
+	if (rx_buf[0] & 0x41)
+		dev_err(&spi->dev,
+			"%s Invalid Zero mask(0x%x)\n", __func__, rx_buf[0]);
+
+	if ((rx_buf[0] & 0x2) != 0x2)
+		dev_err(&spi->dev,
+			"%s Invalid One mask (0x%x)\n", __func__, rx_buf[0]);
+
+	return 0;
+}
+
+static int cmr3000_spi_write(struct device *dev, u8 reg, u8 val, char *msg)
+{
+
+	struct spi_device *spi = to_spi_device(dev);
+
+	return cmr3000_spi_cmd(spi, reg, &val, DO_WRITE, msg);
+}
+
+static int cmr3000_spi_read(struct device *dev, u8 reg, char *msg)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	int ret;
+	u8 val;
+
+	ret = cmr3000_spi_cmd(spi, reg, &val, DO_READ, msg);
+	if (ret)
+		return ret;
+	return val;
+}
+
+static const struct cmr3000_bus_ops cmr3000_spi_bops = {
+	.bustype = BUS_SPI,
+#define CMR3000_BUSSPI     (1 << 4)
+	.ctrl_mod = CMR3000_BUSSPI,
+	.read = cmr3000_spi_read,
+	.write = cmr3000_spi_write,
+};
+
+static int __devinit cmr3000_spi_probe(struct spi_device *spi)
+{
+	struct cmr3000_gyro_data *data;
+
+	data = cmr3000_init(&spi->dev, spi->irq, &cmr3000_spi_bops);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	spi_set_drvdata(spi, data);
+
+	return 0;
+}
+
+static int __devexit cmr3000_spi_remove(struct spi_device *spi)
+{
+	struct cmr3000_gyro_data *data = dev_get_drvdata(&spi->dev);
+
+	cmr3000_exit(data);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int cmr3000_spi_suspend(struct device *dev)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct cmr3000_gyro_data *data = dev_get_drvdata(&spi->dev);
+
+	cmr3000_suspend(data);
+
+	return 0;
+}
+
+static int cmr3000_spi_resume(struct device *dev)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct cmr3000_gyro_data *data = dev_get_drvdata(&spi->dev);
+
+	cmr3000_resume(data);
+
+	return 0;
+}
+
+static const struct dev_pm_ops cmr3000_spi_pm_ops = {
+	.suspend = cmr3000_spi_suspend,
+	.resume = cmr3000_spi_resume,
+};
+#endif
+
+static SIMPLE_DEV_PM_OPS(cmr3000_spi_pm, cmr3000_spi_suspend,
+			 cmr3000_spi_resume);
+
+static struct spi_driver cmr3000_driver = {
+	.driver = {
+		   .name = "cmr3000_d01",
+		   .bus = &spi_bus_type,
+		   .owner = THIS_MODULE,
+		   .pm = &cmr3000_spi_pm,
+		   },
+	.probe = cmr3000_spi_probe,
+	.remove = __devexit_p(cmr3000_spi_remove),
+};
+
+static int __init cmr3000_spi_init(void)
+{
+	return spi_register_driver(&cmr3000_driver);
+}
+
+static void __exit cmr3000_spi_exit(void)
+{
+	spi_unregister_driver(&cmr3000_driver);
+}
+
+module_init(cmr3000_spi_init);
+module_exit(cmr3000_spi_exit);
+
+MODULE_DESCRIPTION("CMR3000-D0x Gyroscope SPI Driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ricardo Ribalda <ricardo.ribalda@gmail.com>");
diff --git a/include/linux/input/cmr3000.h b/include/linux/input/cmr3000.h
new file mode 100644
index 0000000..dfcf9e3
--- /dev/null
+++ b/include/linux/input/cmr3000.h
@@ -0,0 +1,54 @@
+/*
+ * VTI CMR3000_Dxx Gyroscope driver
+ *
+ * Copyright (C) 2011 Qtechnology
+ * Author: Ricardo Ribalda <ricardo.ribalda@gmail.com>
+ *
+ * Based on:
+ *	include/linux/input/cma3000.h by Hemanth V
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _LINUX_CMR3000_H
+#define _LINUX_CMR3000_H
+
+#define CMRMODE_DEFAULT    0
+#define CMRMODE_STANDBY    1
+#define CMRMODE_MEAS20     2
+#define CMRMODE_MEAS80     3
+#define CMRMODE_POFF       0
+
+#define CMRIRQLEVEL_LOW    1
+#define CMRIRQLEVEL_HIGH   0
+
+#define CMRRANGE   3072
+
+/**
+ * struct cmr3000_platform_data - CMR3000 Platform data
+ * @fuzz_x: Noise on X Axis
+ * @fuzz_y: Noise on Y Axis
+ * @fuzz_z: Noise on Z Axis
+ * @mode: Operating mode
+ * @irq_level: Irq level
+ */
+struct cmr3000_platform_data {
+	int fuzz_x;
+	int fuzz_y;
+	int fuzz_z;
+	uint8_t irq_level;
+	uint8_t mode;
+	unsigned long irqflags;
+};
+
+#endif
-- 
1.7.7

