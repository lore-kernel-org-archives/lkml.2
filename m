Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab0K2K56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:57:58 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46993 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab0K2K5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:57:48 -0500
Message-ID: <37129.10.24.255.17.1291028260.squirrel@dbdmail.itg.ti.com>
Date: Mon, 29 Nov 2010 16:27:40 +0530 (IST)
Subject: PATCH V4 1/2] input: CMA3000 Accelerometer Driver
From: "Hemanth V" <hemanthv@ti.com>
To: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, jic23@cam.ac.uk,
        saaguirre@ti.com, Shubhrajyoti@ti.com
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9985dc1211ae33baa877489c26920dfd1c29bb35 Mon Sep 17 00:00:00 2001
From: Hemanth V <hemanthv@ti.com>
Date: Thu, 26 Aug 2010 17:44:48 +0530
Subject: [PATCH] input: CMA3000 Accelerometer Driver

Add support for CMA3000 Tri-axis accelerometer, which
supports Motion detect, Measurement and Free fall modes.
CMA3000 supports both I2C/SPI bus for communication, currently the
driver supports I2C based communication.

Driver reports acceleration data through input subsystem

Signed-off-by: Hemanth V <hemanthv@ti.com>
Reviewed-by: Jonathan Cameron <jic23@cam.ac.uk>
Reviewed-by: Sergio Aguirre <saaguirre@ti.com>
Reviewed-by: Shubhrajyoti <Shubhrajyoti@ti.com>
---
This is V4 of patch, which currently doesnot support a
sysfs interface. Discussions are ongoing to create a
standard sysfs interface for sensors under input subsystem.
This interface would be adopted by the driver subsequently.

 Documentation/input/cma3000_d0x.txt  |  115 ++++++++++++
 drivers/input/misc/Kconfig           |   24 +++
 drivers/input/misc/Makefile          |    2 +
 drivers/input/misc/cma3000_d0x.c     |  334 ++++++++++++++++++++++++++++++++++
 drivers/input/misc/cma3000_d0x.h     |   53 ++++++
 drivers/input/misc/cma3000_d0x_i2c.c |  142 ++++++++++++++
 include/linux/input/cma3000.h        |   60 ++++++
 7 files changed, 730 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/input/cma3000_d0x.txt
 create mode 100644 drivers/input/misc/cma3000_d0x.c
 create mode 100644 drivers/input/misc/cma3000_d0x.h
 create mode 100644 drivers/input/misc/cma3000_d0x_i2c.c
 create mode 100644 include/linux/input/cma3000.h

diff --git a/Documentation/input/cma3000_d0x.txt b/Documentation/input/cma3000_d0x.txt
new file mode 100644
index 0000000..9cc46af
--- /dev/null
+++ b/Documentation/input/cma3000_d0x.txt
@@ -0,0 +1,115 @@
+Kernel driver for CMA3000-D0x
+============================
+
+Supported chips:
+* VTI CMA3000-D0x
+Datasheet:
+  CMA3000-D0X Product Family Specification 8281000A.02.pdf
+  <http://www.vti.fi/en/>
+
+Author: Hemanth V <hemanthv@ti.com>
+
+
+Description
+-----------
+CMA3000 Tri-axis accelerometer supports Motion detect, Measurement and
+Free fall modes.
+
+Motion Detect Mode: Its the low power mode where interrupts are generated only
+when motion exceeds the defined thresholds.
+
+Measurement Mode: This mode is used to read the acceleration data on X,Y,Z
+axis and supports 400, 100, 40 Hz sample frequency.
+
+Free fall Mode: This mode is intented to save system resources.
+
+Threshold values: Chip supports defining threshold values for above modes
+which includes time and g value. Refer product specifications for more details.
+
+CMA3000 chip supports mutually exclusive I2C and SPI interfaces for
+communication, currently the driver supports I2C based communication only.
+Initial configuration for bus mode is set in non volatile memory and can later
+be modified through bus interface command.
+
+Driver reports acceleration data through input subsystem. It generates ABS_MISC
+event with value 1 when free fall is detected.
+
+Platform data need to be configured for initial default values.
+
+Platform Data
+-------------
+fuzz_x: Noise on X Axis
+
+fuzz_y: Noise on Y Axis
+
+fuzz_z: Noise on Z Axis
+
+g_range: G range in milli g i.e 2000 or 8000
+
+mode: Default Operating mode
+
+mdthr: Motion detect g range threshold value
+
+mdfftmr: Motion detect and free fall time threshold value
+
+ffthr: Free fall g range threshold value
+
+Input Interface
+--------------
+Input driver version is 1.0.0
+Input device ID: bus 0x18 vendor 0x0 product 0x0 version 0x0
+Input device name: "cma3000-accelerometer"
+Supported events:
+  Event type 0 (Sync)
+  Event type 3 (Absolute)
+    Event code 0 (X)
+      Value     47
+      Min    -8000
+      Max     8000
+      Fuzz     200
+    Event code 1 (Y)
+      Value    -28
+      Min    -8000
+      Max     8000
+      Fuzz     200
+    Event code 2 (Z)
+      Value    905
+      Min    -8000
+      Max     8000
+      Fuzz     200
+    Event code 40 (Misc)
+      Value      0
+      Min        0
+      Max        1
+  Event type 4 (Misc)
+
+
+Register/Platform parameters Description
+----------------------------------------
+
+mode:
+	0: power down mode
+	1: 100 Hz Measurement mode
+	2: 400 Hz Measurement mode
+	3: 40 Hz Measurement mode
+	4: Motion Detect mode (default)
+	5: 100 Hz Free fall mode
+	6: 40 Hz Free fall mode
+	7: Power off mode
+
+grange:
+	2000: 2000 mg or 2G Range
+	8000: 8000 mg or 8G Range
+
+mdthr:
+	X: X * 71mg (8G Range)
+	X: X * 18mg (2G Range)
+
+mdfftmr:
+	X: (X & 0x70) * 100 ms (MDTMR)
+	   (X & 0x0F) * 2.5 ms (FFTMR 400 Hz)
+	   (X & 0x0F) * 10 ms  (FFTMR 100 Hz)
+
+ffthr:
+       X: (X >> 2) * 18mg (2G Range)
+       X: (X & 0x0F) * 71 mg (8G Range)
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index b99b8cb..d5e5fd6 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -448,4 +448,28 @@ config INPUT_ADXL34X_SPI
 	  To compile this driver as a module, choose M here: the
 	  module will be called adxl34x-spi.

+config INPUT_CMA3000
+ 	tristate "VTI CMA3000 Tri-axis accelerometer"
+ 	help
+ 	  Say Y here if you want to use VTI CMA3000_D0x Accelerometer
+ 	  driver
+
+	  This driver currently only supports I2C interface to the
+	  controller. Also select the I2C method.
+
+	  If unsure, say N
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cma3000_d0x.
+
+config INPUT_CMA3000_I2C
+ 	tristate "Support I2C bus connection"
+ 	depends on INPUT_CMA3000 && I2C
+ 	help
+ 	  Say Y here if you want to use VTI CMA3000_D0x Accelerometer
+ 	  through I2C interface.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cma3000_d0x_i2c.
+
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 1fe1f6c..35bcfe4 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -18,6 +18,8 @@ obj-$(CONFIG_INPUT_ATI_REMOTE2)		+= ati_remote2.o
 obj-$(CONFIG_INPUT_ATLAS_BTNS)		+= atlas_btns.o
 obj-$(CONFIG_INPUT_BFIN_ROTARY)		+= bfin_rotary.o
 obj-$(CONFIG_INPUT_CM109)		+= cm109.o
+obj-$(CONFIG_INPUT_CMA3000)		+= cma3000_d0x.o
+obj-$(CONFIG_INPUT_CMA3000_I2C)		+= cma3000_d0x_i2c.o
 obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
 obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c
new file mode 100644
index 0000000..158add9
--- /dev/null
+++ b/drivers/input/misc/cma3000_d0x.c
@@ -0,0 +1,334 @@
+/*
+ * cma3000_d0x.c
+ * VTI CMA3000_D0x Accelerometer driver
+ *	Supports I2C interface
+ *
+ * Copyright (C) 2010 Texas Instruments
+ * Author: Hemanth V <hemanthv@ti.com>
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
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/platform_device.h>
+#include <linux/input/cma3000.h>
+
+#include "cma3000_d0x.h"
+
+#define CMA3000_WHOAMI      0x00
+#define CMA3000_REVID       0x01
+#define CMA3000_CTRL        0x02
+#define CMA3000_STATUS      0x03
+#define CMA3000_RSTR        0x04
+#define CMA3000_INTSTATUS   0x05
+#define CMA3000_DOUTX       0x06
+#define CMA3000_DOUTY       0x07
+#define CMA3000_DOUTZ       0x08
+#define CMA3000_MDTHR       0x09
+#define CMA3000_MDFFTMR     0x0A
+#define CMA3000_FFTHR       0x0B
+
+#define CMA3000_RANGE2G    (1 << 7)
+#define CMA3000_RANGE8G    (0 << 7)
+#define CMA3000_BUSI2C     (0 << 4)
+#define CMA3000_MODEMASK   (7 << 1)
+#define CMA3000_GRANGEMASK (1 << 7)
+
+#define CMA3000_STATUS_PERR    1
+#define CMA3000_INTSTATUS_FFDET (1 << 2)
+
+/* Settling time delay in ms */
+#define CMA3000_SETDELAY    30
+
+/* Delay for clearing interrupt in us */
+#define CMA3000_INTDELAY    44
+
+
+/*
+ * Bit weights in mg for bit 0, other bits need
+ * multipy factor 2^n. Eight bit is the sign bit.
+ */
+#define BIT_TO_2G  18
+#define BIT_TO_8G  71
+
+#define CMA3000_READ(data, reg, msg) \
+	((data)->bus_ops->read(data, reg, msg))
+#define CMA3000_SET(data, reg, val, msg) \
+	((data)->bus_ops->write(data, reg, val, msg))
+/*
+ * Conversion for each of the eight modes to g, depending
+ * on G range i.e 2G or 8G. Some modes always operate in
+ * 8G.
+ */
+
+static int mode_to_mg[8][2] = {
+	{0, 0},
+	{BIT_TO_8G, BIT_TO_2G},
+	{BIT_TO_8G, BIT_TO_2G},
+	{BIT_TO_8G, BIT_TO_8G},
+	{BIT_TO_8G, BIT_TO_8G},
+	{BIT_TO_8G, BIT_TO_2G},
+	{BIT_TO_8G, BIT_TO_2G},
+	{0, 0},
+};
+
+static void decode_mg(struct cma3000_accl_data *data, int *datax,
+				int *datay, int *dataz)
+{
+	/* Data in 2's complement, convert to mg */
+	*datax = (((s8)(*datax)) * (data->bit_to_mg));
+	*datay = (((s8)(*datay)) * (data->bit_to_mg));
+	*dataz = (((s8)(*dataz)) * (data->bit_to_mg));
+}
+
+static irqreturn_t cma3000_thread_irq(int irq, void *dev_id)
+{
+	struct cma3000_accl_data *data = dev_id;
+	int  datax, datay, dataz;
+	u8 ctrl, mode, range, intr_status;
+
+	intr_status = CMA3000_READ(data, CMA3000_INTSTATUS, "interrupt status");
+	if (intr_status < 0)
+		return IRQ_NONE;
+
+	/* Check if free fall is detected, report immediately */
+	if (intr_status & CMA3000_INTSTATUS_FFDET) {
+		input_report_abs(data->input_dev, ABS_MISC, 1);
+		input_sync(data->input_dev);
+	} else {
+		input_report_abs(data->input_dev, ABS_MISC, 0);
+	}
+
+	datax = CMA3000_READ(data, CMA3000_DOUTX, "X");
+	datay = CMA3000_READ(data, CMA3000_DOUTY, "Y");
+	dataz = CMA3000_READ(data, CMA3000_DOUTZ, "Z");
+
+	ctrl = CMA3000_READ(data, CMA3000_CTRL, "ctrl");
+	mode = (ctrl & CMA3000_MODEMASK) >> 1;
+	range = (ctrl & CMA3000_GRANGEMASK) >> 7;
+
+	data->bit_to_mg = mode_to_mg[mode][range];
+
+	/* Interrupt not for this device */
+	if (data->bit_to_mg == 0)
+		return IRQ_NONE;
+
+	/* Decode register values to milli g */
+	decode_mg(data, &datax, &datay, &dataz);
+
+	input_report_abs(data->input_dev, ABS_X, datax);
+	input_report_abs(data->input_dev, ABS_Y, datay);
+	input_report_abs(data->input_dev, ABS_Z, dataz);
+	input_sync(data->input_dev);
+
+	return IRQ_HANDLED;
+}
+
+static int cma3000_reset(struct cma3000_accl_data *data)
+{
+	int ret;
+
+	/* Reset sequence */
+	CMA3000_SET(data, CMA3000_RSTR, 0x02, "Reset");
+	CMA3000_SET(data, CMA3000_RSTR, 0x0A, "Reset");
+	CMA3000_SET(data, CMA3000_RSTR, 0x04, "Reset");
+
+	/* Settling time delay */
+	mdelay(10);
+
+	ret = CMA3000_READ(data, CMA3000_STATUS, "Status");
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Reset failed\n");
+		return ret;
+	} else if (ret & CMA3000_STATUS_PERR) {
+		dev_err(&data->client->dev, "Parity Error\n");
+		return -EIO;
+	} else {
+		return 0;
+	}
+}
+
+int cma3000_poweron(struct cma3000_accl_data *data)
+{
+	uint8_t ctrl = 0, mdthr, mdfftmr, ffthr, mode;
+	int g_range, ret;
+
+	g_range = data->pdata.g_range;
+	mode = data->pdata.mode;
+	mdthr = data->pdata.mdthr;
+	mdfftmr = data->pdata.mdfftmr;
+	ffthr = data->pdata.ffthr;
+
+	if (mode < CMAMODE_DEFAULT || mode > CMAMODE_POFF) {
+		data->pdata.mode = CMAMODE_MOTDET;
+		mode = data->pdata.mode;
+		dev_info(&data->client->dev,
+			"Invalid mode specified, assuming Motion Detect\n");
+	}
+
+	if (g_range == CMARANGE_2G) {
+		ctrl = (mode << 1) | CMA3000_RANGE2G;
+	} else if (g_range == CMARANGE_8G) {
+		ctrl = (mode << 1) | CMA3000_RANGE8G;
+	} else {
+		dev_info(&data->client->dev,
+			"Invalid G range specified, assuming 8G\n");
+		ctrl = (mode << 1) | CMA3000_RANGE8G;
+		data->pdata.g_range = CMARANGE_8G;
+	}
+#if defined CONFIG_INPUT_CMA3000_I2C || defined CONFIG_INPUT_CMA3000_I2C_MODULE
+	ctrl |= CMA3000_BUSI2C;
+#endif
+
+	CMA3000_SET(data, CMA3000_MDTHR, mdthr, "Motion Detect Threshold");
+	CMA3000_SET(data, CMA3000_MDFFTMR, mdfftmr, "Time register");
+	CMA3000_SET(data, CMA3000_FFTHR, ffthr, "Free fall threshold");
+	ret = CMA3000_SET(data, CMA3000_CTRL, ctrl, "Mode setting");
+	if (ret < 0)
+		return -EIO;
+
+	msleep(CMA3000_SETDELAY);
+
+	return 0;
+}
+EXPORT_SYMBOL(cma3000_poweron);
+
+int cma3000_poweroff(struct cma3000_accl_data *data)
+{
+	int ret;
+
+	ret = CMA3000_SET(data, CMA3000_CTRL, CMAMODE_POFF, "Mode setting");
+	msleep(CMA3000_SETDELAY);
+
+	return ret;
+}
+EXPORT_SYMBOL(cma3000_poweroff);
+
+int cma3000_init(struct cma3000_accl_data *data)
+{
+	int ret = 0, fuzz_x, fuzz_y, fuzz_z, g_range;
+	uint32_t irqflags;
+
+	if (data->client->dev.platform_data == NULL) {
+		dev_err(&data->client->dev, "platform data not found\n");
+		ret = -EINVAL;
+		goto err_op1_failed;
+	}
+
+	/* if no IRQ return error */
+	if (data->client->irq == 0) {
+		ret = -EINVAL;
+		goto err_op1_failed;
+	}
+
+	memcpy(&(data->pdata), data->client->dev.platform_data,
+		sizeof(struct cma3000_platform_data));
+
+	ret = cma3000_reset(data);
+	if (ret)
+		goto err_op1_failed;
+
+	ret = CMA3000_READ(data, CMA3000_REVID, "Revid");
+	if (ret < 0)
+		goto err_op1_failed;
+
+	pr_info("CMA3000 Accelerometer : Revision %x\n", ret);
+
+	/* Bring it out of default power down state */
+	ret = cma3000_poweron(data);
+	if (ret < 0)
+		goto err_op1_failed;
+
+	fuzz_x = data->pdata.fuzz_x;
+	fuzz_y = data->pdata.fuzz_y;
+	fuzz_z = data->pdata.fuzz_z;
+	g_range = data->pdata.g_range;
+	irqflags = data->pdata.irqflags;
+
+	data->input_dev = input_allocate_device();
+	if (data->input_dev == NULL) {
+		ret = -ENOMEM;
+		dev_err(&data->client->dev,
+			"Failed to allocate input device\n");
+		goto err_op1_failed;
+	}
+
+	data->input_dev->name = "cma3000-accelerometer";
+
+#if defined CONFIG_INPUT_CMA3000_I2C || defined CONFIG_INPUT_CMA3000_I2C_MODULE
+	data->input_dev->id.bustype = BUS_I2C;
+#endif
+
+	 __set_bit(EV_ABS, data->input_dev->evbit);
+	 __set_bit(EV_MSC, data->input_dev->evbit);
+
+	input_set_abs_params(data->input_dev, ABS_X, -g_range,
+				g_range, fuzz_x, 0);
+	input_set_abs_params(data->input_dev, ABS_Y, -g_range,
+				g_range, fuzz_y, 0);
+	input_set_abs_params(data->input_dev, ABS_Z, -g_range,
+				g_range, fuzz_z, 0);
+	input_set_abs_params(data->input_dev, ABS_MISC, 0,
+				1, 0, 0);
+
+	mutex_init(&data->mutex);
+
+	ret = request_threaded_irq(data->client->irq, NULL,
+				cma3000_thread_irq,
+				irqflags | IRQF_ONESHOT,
+				data->client->name, data);
+
+	if (ret < 0) {
+		dev_err(&data->client->dev,
+			"request_threaded_irq failed\n");
+		goto err_op2_failed;
+	}
+
+	ret = input_register_device(data->input_dev);
+	if (ret) {
+		dev_err(&data->client->dev,
+			"Unable to register input device\n");
+		goto err_op3_failed;
+	}
+
+	return 0;
+
+err_op3_failed:
+	free_irq(data->client->irq, data);
+err_op2_failed:
+	mutex_destroy(&data->mutex);
+err_op1_failed:
+	input_free_device(data->input_dev);
+
+	return ret;
+}
+EXPORT_SYMBOL(cma3000_init);
+
+int cma3000_exit(struct cma3000_accl_data *data)
+{
+	int ret;
+
+	ret = cma3000_poweroff(data);
+	free_irq(data->client->irq, data);
+	mutex_destroy(&data->mutex);
+	input_unregister_device(data->input_dev);
+
+	return ret;
+}
+EXPORT_SYMBOL(cma3000_exit);
+
+MODULE_DESCRIPTION("CMA3000-D0x Accelerometer Driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Hemanth V <hemanthv@ti.com>");
diff --git a/drivers/input/misc/cma3000_d0x.h b/drivers/input/misc/cma3000_d0x.h
new file mode 100644
index 0000000..107b5fa
--- /dev/null
+++ b/drivers/input/misc/cma3000_d0x.h
@@ -0,0 +1,53 @@
+/*
+ * cma3000_d0x.h
+ * VTI CMA3000_D0x Accelerometer driver
+ *
+ * Copyright (C) 2010 Texas Instruments
+ * Author: Hemanth V <hemanthv@ti.com>
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
+#ifndef _INPUT_CMA3000_H
+#define _INPUT_CMA3000_H
+
+#include <linux/i2c.h>
+#include <linux/input.h>
+
+struct cma3000_accl_data;
+
+struct cma3000_bus_ops {
+	u16 bustype;
+	int (*read) (struct cma3000_accl_data *, u8, char *);
+	int (*write) (struct cma3000_accl_data *, u8, u8, char *);
+};
+
+struct cma3000_accl_data {
+#if defined CONFIG_INPUT_CMA3000_I2C || defined CONFIG_INPUT_CMA3000_I2C_MODULE
+	struct i2c_client *client;
+#endif
+	struct input_dev *input_dev;
+	struct cma3000_platform_data pdata;
+
+	/* mutex for sysfs operations */
+	struct mutex mutex;
+	const struct cma3000_bus_ops *bus_ops;
+	int bit_to_mg;
+};
+
+int cma3000_init(struct cma3000_accl_data *);
+int cma3000_exit(struct cma3000_accl_data *);
+int cma3000_poweron(struct cma3000_accl_data *);
+int cma3000_poweroff(struct cma3000_accl_data *);
+
+#endif
diff --git a/drivers/input/misc/cma3000_d0x_i2c.c b/drivers/input/misc/cma3000_d0x_i2c.c
new file mode 100644
index 0000000..f843478
--- /dev/null
+++ b/drivers/input/misc/cma3000_d0x_i2c.c
@@ -0,0 +1,142 @@
+/*
+ * cma3000_d0x_i2c.c
+ *
+ * Implements I2C interface for VTI CMA300_D0x Accelerometer driver
+ *
+ * Copyright (C) 2010 Texas Instruments
+ * Author: Hemanth V <hemanthv@ti.com>
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
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/input/cma3000.h>
+#include "cma3000_d0x.h"
+
+static int cma3000_set(struct cma3000_accl_data *accl, u8 reg, u8 val,
+			char *msg)
+{
+	int ret = i2c_smbus_write_byte_data(accl->client, reg, val);
+	if (ret < 0)
+		dev_err(&accl->client->dev,
+			"i2c_smbus_write_byte_data failed (%s)\n", msg);
+	return ret;
+}
+
+static int cma3000_read(struct cma3000_accl_data *accl, u8 reg, char *msg)
+{
+	int ret = i2c_smbus_read_byte_data(accl->client, reg);
+	if (ret < 0)
+		dev_err(&accl->client->dev,
+			"i2c_smbus_read_byte_data failed (%s)\n", msg);
+	return ret;
+}
+
+static const struct cma3000_bus_ops cma3000_i2c_bops = {
+	.bustype = BUS_I2C,
+	.read = cma3000_read,
+	.write = cma3000_set,
+};
+
+static int __devinit cma3000_accl_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	int ret;
+	struct cma3000_accl_data *data = NULL;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (data == NULL) {
+		ret = -ENOMEM;
+		goto err_op_failed;
+	}
+
+	data->client = client;
+	i2c_set_clientdata(client, data);
+	data->bus_ops = &cma3000_i2c_bops;
+
+	ret = cma3000_init(data);
+	if (ret)
+		goto err_op_failed;
+
+	return 0;
+
+err_op_failed:
+
+	kfree(data);
+	return ret;
+}
+
+static int __devexit cma3000_accl_remove(struct i2c_client *client)
+{
+	struct cma3000_accl_data *data = i2c_get_clientdata(client);
+	int ret;
+
+	ret = cma3000_exit(data);
+	i2c_set_clientdata(client, NULL);
+	kfree(data);
+
+	return ret;
+}
+
+#ifdef CONFIG_PM
+static int cma3000_accl_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	struct cma3000_accl_data *data = i2c_get_clientdata(client);
+
+	return cma3000_poweroff(data);
+}
+
+static int cma3000_accl_resume(struct i2c_client *client)
+{
+	struct cma3000_accl_data *data = i2c_get_clientdata(client);
+
+	return cma3000_poweron(data);
+}
+#endif
+
+static const struct i2c_device_id cma3000_id[] = {
+	{ "cma3000_d01", 0 },
+	{ },
+};
+
+static struct i2c_driver cma3000_accl_driver = {
+	.probe		= cma3000_accl_probe,
+	.remove		= cma3000_accl_remove,
+	.id_table	= cma3000_id,
+#ifdef CONFIG_PM
+	.suspend	= cma3000_accl_suspend,
+	.resume		= cma3000_accl_resume,
+#endif
+	.driver = {
+		.name = "cma3000_accl"
+	},
+};
+
+static int __init cma3000_accl_init(void)
+{
+	return i2c_add_driver(&cma3000_accl_driver);
+}
+
+static void __exit cma3000_accl_exit(void)
+{
+	i2c_del_driver(&cma3000_accl_driver);
+}
+
+module_init(cma3000_accl_init);
+module_exit(cma3000_accl_exit);
+
+MODULE_DESCRIPTION("CMA3000-D0x Accelerometer Driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Hemanth V <hemanthv@ti.com>");
diff --git a/include/linux/input/cma3000.h b/include/linux/input/cma3000.h
new file mode 100644
index 0000000..fcddece
--- /dev/null
+++ b/include/linux/input/cma3000.h
@@ -0,0 +1,60 @@
+/*
+ * cma3000.h
+ * VTI CMA3000_Dxx Accelerometer driver
+ *
+ * Copyright (C) 2010 Texas Instruments
+ * Author: Hemanth V <hemanthv@ti.com>
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
+#ifndef _LINUX_CMA3000_H
+#define _LINUX_CMA3000_H
+
+#define CMAMODE_DEFAULT    0
+#define CMAMODE_MEAS100    1
+#define CMAMODE_MEAS400    2
+#define CMAMODE_MEAS40     3
+#define CMAMODE_MOTDET     4
+#define CMAMODE_FF100      5
+#define CMAMODE_FF400      6
+#define CMAMODE_POFF       7
+
+#define CMARANGE_2G   2000
+#define CMARANGE_8G   8000
+
+/**
+ * struct cma3000_i2c_platform_data - CMA3000 Platform data
+ * @fuzz_x: Noise on X Axis
+ * @fuzz_y: Noise on Y Axis
+ * @fuzz_z: Noise on Z Axis
+ * @g_range: G range in milli g i.e 2000 or 8000
+ * @mode: Operating mode
+ * @mdthr: Motion detect threshold value
+ * @mdfftmr: Motion detect and free fall time value
+ * @ffthr: Free fall threshold value
+ */
+
+struct cma3000_platform_data {
+	int fuzz_x;
+	int fuzz_y;
+	int fuzz_z;
+	int g_range;
+	uint8_t  mode;
+	uint8_t  mdthr;
+	uint8_t  mdfftmr;
+	uint8_t  ffthr;
+	uint32_t  irqflags;
+};
+
+#endif
-- 
1.5.4.3



