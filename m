Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1EMSNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:13:31 -0400
Received: from mail.kionix.com ([66.152.113.154]:58307 "EHLO mail.kionix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab1EMSN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:13:29 -0400
X-ASG-Debug-ID: 1305310406-3bf400180000-xx1T2L
X-Barracuda-URL: http://10.0.0.213:8000/cgi-bin/mark.cgi
From: Chris@vger.kernel.org, Hudson@vger.kernel.org
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Hudson <chudson@kionix.com>
X-ASG-Orig-Subj: [PATCH 1/1] input: Add support for Kionix KXTJ9 accelerometer
Subject: [PATCH 1/1] input: Add support for Kionix KXTJ9 accelerometer
Date: Fri, 13 May 2011 14:13:26 -0400
Message-Id: <1305310406-9870-2-git-send-email-chudson@kionix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1305310406-9870-1-git-send-email-chudson@kionix.com>
References: <>
 <1305310406-9870-1-git-send-email-chudson@kionix.com>
X-Barracuda-Connect: UNKNOWN[10.0.0.125]
X-Barracuda-Start-Time: 1305310406
X-Barracuda-Virus-Scanned: by Barracuda Spam Firewall at kionix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Hudson <chudson@kionix.com>


Signed-off-by: Chris Hudson <chudson@kionix.com>
---
 drivers/input/misc/Kconfig  |   10 +
 drivers/input/misc/Makefile |    1 +
 drivers/input/misc/kxtj9.c  |  824 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/kxtj9.h       |   76 ++++
 4 files changed, 911 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/kxtj9.c
 create mode 100644 include/linux/kxtj9.h

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index f9cf088..567f3d2 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -467,4 +467,14 @@ config INPUT_XEN_KBDDEV_FRONTEND
 	  To compile this driver as a module, choose M here: the
 	  module will be called xen-kbdfront.
 
+config INPUT_KXTJ9
+	tristate "Kionix KXTJ9 tri-axis digital accelerometer"
+	depends on I2C && SYSFS
+	help
+	  If you say yes here you get support for the Kionix KXTJ9 digital
+	  tri-axis accelerometer.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called kxtj9.
+
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index e3f7984..f2477ef 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
 obj-$(CONFIG_INPUT_KEYSPAN_REMOTE)	+= keyspan_remote.o
+obj-$(CONFIG_INPUT_KXTJ9)		+= kxtj9.o
 obj-$(CONFIG_INPUT_M68K_BEEP)		+= m68kspkr.o
 obj-$(CONFIG_INPUT_MAX8925_ONKEY)	+= max8925_onkey.o
 obj-$(CONFIG_INPUT_PCAP)		+= pcap_keys.o
diff --git a/drivers/input/misc/kxtj9.c b/drivers/input/misc/kxtj9.c
new file mode 100644
index 0000000..42a39c7
--- /dev/null
+++ b/drivers/input/misc/kxtj9.c
@@ -0,0 +1,824 @@
+/*
+ * Copyright (C) 2011 Kionix, Inc.
+ * Written by Chris Hudson <chudson@kionix.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307, USA
+ */
+
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/i2c.h>
+#include <linux/input.h>
+#include <linux/uaccess.h>
+#include <linux/workqueue.h>
+#include <linux/irq.h>
+#include <linux/gpio.h>
+#include <linux/kthread.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/kxtj9.h>
+
+#define NAME			"kxtj9"
+#define G_MAX			8000
+/* OUTPUT REGISTERS */
+#define XOUT_L			0x06
+#define WHO_AM_I		0x0F
+/* CONTROL REGISTERS */
+#define INT_REL		0x1A
+#define CTRL_REG1		0x1B
+#define INT_CTRL1		0x1E
+#define DATA_CTRL		0x21
+/* CONTROL REGISTER 1 BITS */
+#define PC1_OFF		0x7F
+#define PC1_ON			0x80
+/* INPUT_ABS CONSTANTS */
+#define FUZZ			3
+#define FLAT			3
+/* RESUME STATE INDICES */
+#define RES_DATA_CTRL		0
+#define RES_CTRL_REG1		1
+#define RES_INT_CTRL1		2
+#define RESUME_ENTRIES		3
+
+/*
+ * The following table lists the maximum appropriate poll interval for each
+ * available output data rate.
+ */
+struct {
+	unsigned int cutoff;
+	u8 mask;
+} kxtj9_odr_table[] = {
+	{
+	3,	ODR800F}, {
+	5,	ODR400F}, {
+	10,	ODR200F}, {
+	20,	ODR100F}, {
+	40,	ODR50F}, {
+	80,	ODR25F}, {
+	0,	ODR12_5F},
+};
+
+struct kxtj9_data {
+	struct i2c_client *client;
+	struct kxtj9_platform_data *pdata;
+	struct mutex lock;
+	struct delayed_work input_work;
+	struct input_dev *input_dev;
+	struct work_struct irq_work;
+
+	int hw_initialized;
+	atomic_t enabled;
+	u8 resume[RESUME_ENTRIES];
+	int res_interval;
+	int drdy_enabled;
+	int irq;
+};
+
+static int kxtj9_i2c_read(struct kxtj9_data *tj9, u8 addr, u8 *data, int len)
+{
+	int err;
+
+	struct i2c_msg msgs[] = {
+		{
+		 .addr = tj9->client->addr,
+		 .flags = tj9->client->flags,
+		 .len = 1,
+		 .buf = &addr,
+		 },
+		{
+		 .addr = tj9->client->addr,
+		 .flags = tj9->client->flags | I2C_M_RD,
+		 .len = len,
+		 .buf = data,
+		 },
+	};
+	err = i2c_transfer(tj9->client->adapter, msgs, 2);
+
+	if (err != 2)
+		dev_err(&tj9->client->dev, "read transfer error\n");
+	else
+		err = 0;
+
+	return err;
+}
+
+static int kxtj9_i2c_write(struct kxtj9_data *tj9, u8 addr, u8 *data, int len)
+{
+	int err;
+	int i;
+	u8 buf[len + 1];
+
+	struct i2c_msg msgs[] = {
+		{
+		 .addr = tj9->client->addr,
+		 .flags = tj9->client->flags,
+		 .len = len + 1,
+		 .buf = buf,
+		 },
+	};
+
+	buf[0] = addr;
+	for (i = 0; i < len; i++)
+		buf[i + 1] = data[i];
+
+	err = i2c_transfer(tj9->client->adapter, msgs, 1);
+
+	if (err != 1)
+		dev_err(&tj9->client->dev, "write transfer error\n");
+	else
+		err = 0;
+
+	return err;
+}
+
+static int kxtj9_verify(struct kxtj9_data *tj9)
+{
+	int err;
+	u8 buf;
+
+	err = kxtj9_i2c_read(tj9, WHO_AM_I, &buf, 1);
+	if (err < 0)
+		dev_err(&tj9->client->dev, "read err int source\n");
+	if (buf != 0x06)
+		err = -1;
+
+	return err;
+}
+
+int kxtj9_update_g_range(struct kxtj9_data *tj9, u8 new_g_range)
+{
+	int err;
+	u8 shift;
+	u8 buf;
+	u8 out;
+
+	switch (new_g_range) {
+	case KXTJ9_G_2G:
+		shift = SHIFT_ADJ_2G;
+		break;
+	case KXTJ9_G_4G:
+		shift = SHIFT_ADJ_4G;
+		break;
+	case KXTJ9_G_8G:
+		shift = SHIFT_ADJ_8G;
+		break;
+	default:
+		dev_err(&tj9->client->dev, "invalid g range request\n");
+		return -EINVAL;
+	}
+
+	out = (tj9->resume[RES_CTRL_REG1] & 0xE7) | new_g_range;
+	if (shift != tj9->pdata->shift_adj) {
+		if (atomic_read(&tj9->enabled)) {
+			buf = 0;
+			err = kxtj9_i2c_write(tj9, CTRL_REG1, &buf, 1);
+			if (err < 0)
+				return err;
+			err = kxtj9_i2c_write(tj9, CTRL_REG1, &out, 1);
+			if (err < 0)
+				return err;
+		}
+	}
+
+	tj9->resume[RES_CTRL_REG1] = out;
+	tj9->pdata->shift_adj = shift;
+
+	return 0;
+}
+
+int kxtj9_update_odr(struct kxtj9_data *tj9, int poll_interval)
+{
+	int err = -1;
+	int i;
+	u8 config;
+	u8 temp = 0;
+
+	/* Use the lowest ODR that can support the requested poll interval */
+	for (i = 0; i < ARRAY_SIZE(kxtj9_odr_table); i++) {
+		config = kxtj9_odr_table[i].mask;
+		if (poll_interval < kxtj9_odr_table[i].cutoff)
+			break;
+	}
+
+	if (atomic_read(&tj9->enabled)) {
+		err = kxtj9_i2c_write(tj9, CTRL_REG1, &temp, 1);
+		if (err < 0)
+			return err;
+		err = kxtj9_i2c_write(tj9, DATA_CTRL, &config, 1);
+		if (err < 0)
+			return err;
+		temp = tj9->resume[RES_CTRL_REG1];
+		err = kxtj9_i2c_write(tj9, CTRL_REG1, &temp, 1);
+		if (err < 0)
+			return err;
+		/* Valid input_dev indicates that input_init passed and this
+		 * workqueue is available */
+		if (tj9->input_dev) {
+			cancel_delayed_work_sync(&tj9->input_work);
+			schedule_delayed_work(&tj9->input_work,
+				       msecs_to_jiffies(poll_interval));
+		}
+	}
+	tj9->resume[RES_DATA_CTRL] = config;
+
+	return 0;
+}
+
+static int kxtj9_hw_init(struct kxtj9_data *tj9)
+{
+	int err;
+	u8 buf = 0;
+
+	err = kxtj9_i2c_write(tj9, CTRL_REG1, &buf, 1);
+	if (err < 0)
+		return err;
+	err = kxtj9_i2c_write(tj9, DATA_CTRL, &tj9->resume[RES_DATA_CTRL], 1);
+	if (err < 0)
+		return err;
+	err = kxtj9_i2c_write(tj9, INT_CTRL1, &tj9->resume[RES_INT_CTRL1], 1);
+	if (err < 0)
+		return err;
+
+	err = kxtj9_update_g_range(tj9, tj9->pdata->g_range);
+	if (err < 0)
+		return err;
+
+	buf = (tj9->resume[RES_CTRL_REG1] | PC1_ON);
+	err = kxtj9_i2c_write(tj9, CTRL_REG1, &buf, 1);
+	if (err < 0)
+		return err;
+	tj9->resume[RES_CTRL_REG1] = buf;
+
+	if ((buf & DRDYE) > 0)
+		tj9->drdy_enabled = 1;
+	else
+		tj9->drdy_enabled = 0;
+
+	err = kxtj9_update_odr(tj9, tj9->res_interval);
+	if (err < 0)
+		return err;
+
+	tj9->hw_initialized = 1;
+
+	return 0;
+}
+
+static void kxtj9_device_power_off(struct kxtj9_data *tj9)
+{
+	int err;
+	u8 buf;
+
+	buf = tj9->resume[RES_CTRL_REG1] & PC1_OFF;
+	err = kxtj9_i2c_write(tj9, CTRL_REG1, &buf, 1);
+	if (err < 0)
+		dev_err(&tj9->client->dev, "soft power off failed\n");
+	disable_irq(tj9->irq);
+	if (tj9->pdata->power_off)
+		tj9->pdata->power_off();
+	tj9->resume[RES_CTRL_REG1] = buf;
+	tj9->hw_initialized = 0;
+}
+
+static int kxtj9_device_power_on(struct kxtj9_data *tj9)
+{
+	int err;
+
+	if (tj9->pdata->power_on) {
+		err = tj9->pdata->power_on();
+		if (err < 0)
+			return err;
+	}
+	enable_irq(tj9->irq);
+	if (!tj9->hw_initialized) {
+		mdelay(40);
+		err = kxtj9_hw_init(tj9);
+		if (err < 0) {
+			kxtj9_device_power_off(tj9);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static irqreturn_t kxtj9_isr(int irq, void *dev)
+{
+	struct kxtj9_data *tj9 = dev;
+
+	disable_irq_nosync(irq);
+	schedule_work(&tj9->irq_work);
+
+	return IRQ_HANDLED;
+}
+
+static int kxtj9_get_acceleration_data(struct kxtj9_data *tj9, int *xyz)
+{
+	int err;
+	/* Data bytes from hardware xL, xH, yL, yH, zL, zH */
+	u8 acc_data[6];
+	/* x,y,z hardware values */
+	int hw_d[3];
+
+	err = kxtj9_i2c_read(tj9, XOUT_L, acc_data, 6);
+	if (err < 0)
+		return err;
+
+
+	hw_d[0] = (int) (((acc_data[1]) << 8) | acc_data[0]);
+	hw_d[1] = (int) (((acc_data[3]) << 8) | acc_data[2]);
+	hw_d[2] = (int) (((acc_data[5]) << 8) | acc_data[4]);
+
+	if (hw_d[0] & 0x8000)
+		hw_d[0] |= 0xFFFF0000;
+	if (hw_d[1] & 0x8000)
+		hw_d[1] |= 0xFFFF0000;
+	if (hw_d[2] & 0x8000)
+		hw_d[2] |= 0xFFFF0000;
+
+	hw_d[0] >>= tj9->pdata->shift_adj;
+	hw_d[1] >>= tj9->pdata->shift_adj;
+	hw_d[2] >>= tj9->pdata->shift_adj;
+
+	xyz[0] = ((tj9->pdata->negate_x) ? (-hw_d[tj9->pdata->axis_map_x])
+		  : (hw_d[tj9->pdata->axis_map_x]));
+	xyz[1] = ((tj9->pdata->negate_y) ? (-hw_d[tj9->pdata->axis_map_y])
+		  : (hw_d[tj9->pdata->axis_map_y]));
+	xyz[2] = ((tj9->pdata->negate_z) ? (-hw_d[tj9->pdata->axis_map_z])
+		  : (hw_d[tj9->pdata->axis_map_z]));
+
+	return err;
+}
+
+static void kxtj9_report_values(struct kxtj9_data *tj9, int *xyz)
+{
+	input_report_abs(tj9->input_dev, ABS_X, xyz[0]);
+	input_report_abs(tj9->input_dev, ABS_Y, xyz[1]);
+	input_report_abs(tj9->input_dev, ABS_Z, xyz[2]);
+}
+
+static void kxtj9_irq_work_func(struct work_struct *work)
+{
+	int err;
+	u8 buf;
+	int xyz[3];
+
+	struct kxtj9_data *tj9
+			= container_of(work, struct kxtj9_data, irq_work);
+
+	/* data ready is the only possible interrupt type */
+	if (kxtj9_get_acceleration_data(tj9, xyz) == 0)
+		kxtj9_report_values(tj9, xyz);
+
+	err = kxtj9_i2c_read(tj9, INT_REL, &buf, 1);
+	if (err < 0)
+		dev_err(&tj9->client->dev,
+				"error clearing interrupt status: %d\n", err);
+
+	enable_irq(tj9->irq);
+}
+
+static int kxtj9_enable(struct kxtj9_data *tj9)
+{
+	int err;
+	u8 buf;
+
+	if (!atomic_cmpxchg(&tj9->enabled, 0, 1)) {
+		err = kxtj9_device_power_on(tj9);
+		err = kxtj9_i2c_read(tj9, INT_REL, &buf, 1);
+		if (err < 0) {
+			dev_err(&tj9->client->dev,
+					"error clearing interrupt: %d\n", err);
+			atomic_set(&tj9->enabled, 0);
+			return err;
+		}
+		schedule_delayed_work(&tj9->input_work,
+			msecs_to_jiffies(tj9->res_interval));
+	}
+
+	return 0;
+}
+
+static int kxtj9_disable(struct kxtj9_data *tj9)
+{
+	if (atomic_cmpxchg(&tj9->enabled, 1, 0)) {
+		cancel_delayed_work_sync(&tj9->input_work);
+		kxtj9_device_power_off(tj9);
+	}
+
+	return 0;
+}
+
+static void kxtj9_input_work_func(struct work_struct *work)
+{
+	struct kxtj9_data *tj9 = container_of((struct delayed_work *)work,
+						struct kxtj9_data, input_work);
+	int xyz[3] = { 0 };
+
+	if (tj9->drdy_enabled == 0) {
+		mutex_lock(&tj9->lock);
+
+		if (kxtj9_get_acceleration_data(tj9, xyz) == 0)
+			kxtj9_report_values(tj9, xyz);
+
+		schedule_delayed_work(&tj9->input_work,
+				msecs_to_jiffies(tj9->res_interval));
+		mutex_unlock(&tj9->lock);
+	}
+}
+
+int kxtj9_input_open(struct input_dev *input)
+{
+	struct kxtj9_data *tj9 = input_get_drvdata(input);
+
+	return kxtj9_enable(tj9);
+}
+
+void kxtj9_input_close(struct input_dev *dev)
+{
+	struct kxtj9_data *tj9 = input_get_drvdata(dev);
+
+	kxtj9_disable(tj9);
+}
+
+static int kxtj9_input_init(struct kxtj9_data *tj9)
+{
+	int err;
+
+	INIT_DELAYED_WORK(&tj9->input_work, kxtj9_input_work_func);
+	tj9->input_dev = input_allocate_device();
+	if (!tj9->input_dev) {
+		err = -ENOMEM;
+		dev_err(&tj9->client->dev, "input device allocate failed\n");
+		goto err0;
+	}
+	tj9->input_dev->open = kxtj9_input_open;
+	tj9->input_dev->close = kxtj9_input_close;
+
+	input_set_drvdata(tj9->input_dev, tj9);
+
+	set_bit(EV_ABS, tj9->input_dev->evbit);
+	set_bit(EV_REL, tj9->input_dev->evbit);
+
+	input_set_abs_params(tj9->input_dev, ABS_X, -G_MAX, G_MAX, FUZZ, FLAT);
+	input_set_abs_params(tj9->input_dev, ABS_Y, -G_MAX, G_MAX, FUZZ, FLAT);
+	input_set_abs_params(tj9->input_dev, ABS_Z, -G_MAX, G_MAX, FUZZ, FLAT);
+
+	tj9->input_dev->name = "kxtj9_accel";
+
+	err = input_register_device(tj9->input_dev);
+	if (err) {
+		dev_err(&tj9->client->dev,
+			"unable to register input polled device %s: %d\n",
+			tj9->input_dev->name, err);
+		goto err1;
+	}
+
+	return 0;
+err1:
+	input_free_device(tj9->input_dev);
+err0:
+	return err;
+}
+
+static void kxtj9_input_cleanup(struct kxtj9_data *tj9)
+{
+	input_unregister_device(tj9->input_dev);
+}
+
+/* sysfs */
+static ssize_t kxtj9_delay_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct kxtj9_data *tj9 = i2c_get_clientdata(client);
+	return sprintf(buf, "%d\n", tj9->res_interval);
+}
+
+static ssize_t kxtj9_delay_store(struct device *dev,
+					struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct kxtj9_data *tj9 = i2c_get_clientdata(client);
+	int val = simple_strtoul(buf, NULL, 10);
+
+	tj9->res_interval = max(val, tj9->pdata->min_interval);
+	kxtj9_update_odr(tj9, tj9->res_interval);
+
+	return count;
+}
+
+static ssize_t kxtj9_enable_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct kxtj9_data *tj9 = i2c_get_clientdata(client);
+	return sprintf(buf, "%d\n", atomic_read(&tj9->enabled));
+}
+
+static ssize_t kxtj9_enable_store(struct device *dev,
+					struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct kxtj9_data *tj9 = i2c_get_clientdata(client);
+	int val = simple_strtoul(buf, NULL, 10);
+	if (val)
+		kxtj9_enable(tj9);
+	else
+		kxtj9_disable(tj9);
+	return count;
+}
+
+static ssize_t kxtj9_res_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct kxtj9_data *tj9 = i2c_get_clientdata(client);
+	u8 val = tj9->resume[RES_CTRL_REG1] & RES_12BIT;
+	if (val)
+		return sprintf(buf, "%d\n", 12);
+	else
+		return sprintf(buf, "%d\n", 8);
+}
+
+static ssize_t kxtj9_res_store(struct device *dev,
+					struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct kxtj9_data *tj9 = i2c_get_clientdata(client);
+	int val = simple_strtoul(buf, NULL, 10);
+	if (val == 12)
+		tj9->resume[RES_CTRL_REG1] |= RES_12BIT;
+	else if (val == 8)
+		tj9->resume[RES_CTRL_REG1] &= (~RES_12BIT);
+	else
+		dev_err(&client->dev, "resolution must be 8 or 12 (bits)\n");
+	if (atomic_read(&tj9->enabled)) {
+		kxtj9_disable(tj9);
+		kxtj9_enable(tj9);
+	}
+	return count;
+}
+
+static ssize_t kxtj9_drdyenable_store(struct device *dev,
+					struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct kxtj9_data *tj9 = i2c_get_clientdata(client);
+	int val = simple_strtoul(buf, NULL, 10);
+	if (val)
+		tj9->resume[RES_CTRL_REG1] |= DRDYE;
+	else
+		tj9->resume[RES_CTRL_REG1] &= (~DRDYE);
+	if (atomic_read(&tj9->enabled)) {
+		kxtj9_disable(tj9);
+		kxtj9_enable(tj9);
+	}
+	return count;
+}
+
+static ssize_t kxtj9_grange_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct kxtj9_data *tj9 = i2c_get_clientdata(client);
+	u8 val = tj9->resume[RES_CTRL_REG1] & 0x18;
+	if (val == KXTJ9_G_2G)
+		return sprintf(buf, "%d\n", 2);
+	else if (val == KXTJ9_G_4G)
+		return sprintf(buf, "%d\n", 4);
+	else
+		return sprintf(buf, "%d\n", 8);
+}
+
+static ssize_t kxtj9_grange_store(struct device *dev,
+					struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct kxtj9_data *tj9 = i2c_get_clientdata(client);
+	int val = simple_strtoul(buf, NULL, 10);
+	u8 new_range = 0;
+	if (val == 8)
+		new_range = KXTJ9_G_8G;
+	else if (val == 4)
+		new_range = KXTJ9_G_4G;
+	else if (val == 2)
+		new_range = KXTJ9_G_2G;
+	else
+		dev_err(&client->dev, "g-range must be 2, 4, or 8; selecting 2\n");
+	kxtj9_update_g_range(tj9, new_range);
+	return count;
+}
+
+static DEVICE_ATTR(delay, S_IRUGO|S_IWUSR, kxtj9_delay_show, kxtj9_delay_store);
+static DEVICE_ATTR(enable, S_IRUGO|S_IWUSR, kxtj9_enable_show,
+							kxtj9_enable_store);
+static DEVICE_ATTR(res, S_IRUGO|S_IWUSR, kxtj9_res_show, kxtj9_res_store);
+static DEVICE_ATTR(drdyenable, S_IRUGO|S_IWUSR, NULL, kxtj9_drdyenable_store);
+static DEVICE_ATTR(grange, S_IRUGO|S_IWUSR, kxtj9_grange_show,
+							kxtj9_grange_store);
+
+static struct attribute *kxtj9_attributes[] = {
+	&dev_attr_delay.attr,
+	&dev_attr_enable.attr,
+	&dev_attr_res.attr,
+	&dev_attr_drdyenable.attr,
+	&dev_attr_grange.attr,
+	NULL
+};
+
+static struct attribute_group kxtj9_attribute_group = {
+	.attrs = kxtj9_attributes
+};
+/* /sysfs */
+
+static int __devinit kxtj9_probe(struct i2c_client *client,
+						const struct i2c_device_id *id)
+{
+	int err = -1;
+	struct kxtj9_data *tj9 = kzalloc(sizeof(*tj9), GFP_KERNEL);
+	if (tj9 == NULL) {
+		dev_err(&client->dev,
+			"failed to allocate memory for module data\n");
+		err = -ENOMEM;
+		goto err0;
+	}
+	if (client->dev.platform_data == NULL) {
+		dev_err(&client->dev, "platform data is NULL; exiting\n");
+		err = -ENODEV;
+		goto err0;
+	}
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev, "client not i2c capable\n");
+		err = -ENODEV;
+		goto err0;
+	}
+	mutex_init(&tj9->lock);
+	mutex_lock(&tj9->lock);
+	tj9->client = client;
+	i2c_set_clientdata(client, tj9);
+
+	INIT_WORK(&tj9->irq_work, kxtj9_irq_work_func);
+	tj9->pdata = kmalloc(sizeof(*tj9->pdata), GFP_KERNEL);
+	if (tj9->pdata == NULL)
+		goto err1;
+
+	err = sysfs_create_group(&client->dev.kobj, &kxtj9_attribute_group);
+	if (err)
+		goto err1;
+
+	memcpy(tj9->pdata, client->dev.platform_data, sizeof(*tj9->pdata));
+	if (tj9->pdata->init) {
+		err = tj9->pdata->init();
+		if (err < 0)
+			goto err2;
+	}
+
+	tj9->irq = gpio_to_irq(tj9->pdata->gpio);
+
+	memset(tj9->resume, 0, ARRAY_SIZE(tj9->resume));
+	tj9->resume[RES_DATA_CTRL] = tj9->pdata->data_odr_init;
+	tj9->resume[RES_CTRL_REG1] = tj9->pdata->ctrl_reg1_init;
+	tj9->resume[RES_INT_CTRL1] = tj9->pdata->int_ctrl_init;
+	tj9->res_interval = tj9->pdata->poll_interval;
+
+	err = kxtj9_device_power_on(tj9);
+	if (err < 0)
+		goto err3;
+	atomic_set(&tj9->enabled, 1);
+
+	err = kxtj9_verify(tj9);
+	if (err < 0) {
+		dev_err(&client->dev, "unresolved i2c client\n");
+		goto err4;
+	}
+
+	err = kxtj9_update_g_range(tj9, tj9->pdata->g_range);
+	if (err < 0)
+		goto err4;
+
+	err = kxtj9_update_odr(tj9, tj9->res_interval);
+	if (err < 0)
+		goto err4;
+
+	err = kxtj9_input_init(tj9);
+	if (err < 0)
+		goto err4;
+
+	kxtj9_device_power_off(tj9);
+	atomic_set(&tj9->enabled, 0);
+
+	err = request_irq(tj9->irq, kxtj9_isr,
+			IRQF_TRIGGER_RISING | IRQF_DISABLED, "kxtj9-irq", tj9);
+	if (err < 0) {
+		pr_err("%s: request irq failed: %d\n", __func__, err);
+		goto err5;
+	}
+	disable_irq_nosync(tj9->irq);
+
+	mutex_unlock(&tj9->lock);
+
+	return 0;
+
+err5:
+	kxtj9_input_cleanup(tj9);
+err4:
+	kxtj9_device_power_off(tj9);
+err3:
+	if (tj9->pdata->exit)
+		tj9->pdata->exit();
+err2:
+	kfree(tj9->pdata);
+	sysfs_remove_group(&client->dev.kobj, &kxtj9_attribute_group);
+err1:
+	mutex_unlock(&tj9->lock);
+	kfree(tj9);
+err0:
+	return err;
+}
+
+static int __devexit kxtj9_remove(struct i2c_client *client)
+{
+	struct kxtj9_data *tj9 = i2c_get_clientdata(client);
+
+	free_irq(tj9->irq, tj9);
+	gpio_free(tj9->pdata->gpio);
+	kxtj9_input_cleanup(tj9);
+	kxtj9_device_power_off(tj9);
+	if (tj9->pdata->exit)
+		tj9->pdata->exit();
+	kfree(tj9->pdata);
+	sysfs_remove_group(&client->dev.kobj, &kxtj9_attribute_group);
+	kfree(tj9);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int kxtj9_resume(struct i2c_client *client)
+{
+	struct kxtj9_data *tj9 = i2c_get_clientdata(client);
+
+	return kxtj9_enable(tj9);
+}
+
+static int kxtj9_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	struct kxtj9_data *tj9 = i2c_get_clientdata(client);
+
+	return kxtj9_disable(tj9);
+}
+#endif
+
+static const struct i2c_device_id kxtj9_id[] = {
+	{NAME, 0},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, kxtj9_id);
+
+static struct i2c_driver kxtj9_driver = {
+	.driver = {
+		   .name = NAME,
+		   },
+	.probe = kxtj9_probe,
+	.remove = __devexit_p(kxtj9_remove),
+	.resume = kxtj9_resume,
+	.suspend = kxtj9_suspend,
+	.id_table = kxtj9_id,
+};
+
+static int __init kxtj9_init(void)
+{
+	return i2c_add_driver(&kxtj9_driver);
+}
+
+static void __exit kxtj9_exit(void)
+{
+	i2c_del_driver(&kxtj9_driver);
+}
+
+module_init(kxtj9_init);
+module_exit(kxtj9_exit);
+
+MODULE_DESCRIPTION("KXTJ9 accelerometer driver");
+MODULE_AUTHOR("Chris Hudson <chudson@kionix.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/kxtj9.h b/include/linux/kxtj9.h
new file mode 100644
index 0000000..67a08da
--- /dev/null
+++ b/include/linux/kxtj9.h
@@ -0,0 +1,76 @@
+/*
+ * Copyright (C) 2011 Kionix, Inc.
+ * Written by Chris Hudson <chudson@kionix.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307, USA
+ */
+
+#ifndef __KXTJ9_H__
+#define __KXTJ9_H__
+
+#define KXTJ9_I2C_ADDR		0x0F
+/* CONTROL REGISTER 1 BITS */
+#define RES_12BIT		0x40
+#define KXTJ9_G_2G		0x00
+#define KXTJ9_G_4G		0x08
+#define KXTJ9_G_8G		0x10
+#define SHIFT_ADJ_2G		4
+#define SHIFT_ADJ_4G		3
+#define SHIFT_ADJ_8G		2
+#define DRDYE			0x20	/* data ready function enable bit */
+/* INTERRUPT CONTROL REGISTER 1 BITS */
+#define KXTJ9_IEN		0x20	/* interrupt enable */
+#define KXTJ9_IEA		0x10	/* interrupt polarity */
+#define KXTJ9_IEL		0x08	/* interrupt response */
+/* DATA CONTROL REGISTER BITS */
+#define ODR800F			0x06	/* lpf output ODR masks */
+#define ODR400F			0x05
+#define ODR200F			0x04
+#define ODR100F			0x03
+#define ODR50F			0x02
+#define ODR25F			0x01
+#define ODR12_5F		0x00
+
+#ifdef __KERNEL__
+struct kxtj9_platform_data {
+	int poll_interval;
+	int min_interval;
+
+	u8 g_range;
+	u8 shift_adj;
+
+	u8 axis_map_x;
+	u8 axis_map_y;
+	u8 axis_map_z;
+
+	u8 negate_x;
+	u8 negate_y;
+	u8 negate_z;
+
+	u8 data_odr_init;
+	u8 ctrl_reg1_init;
+	u8 int_ctrl_init;
+
+	int (*init)(void);
+	void (*exit)(void);
+	int (*power_on)(void);
+	int (*power_off)(void);
+
+	int gpio;
+};
+#endif /* __KERNEL__ */
+
+#endif  /* __KXTJ9_H__ */
+
-- 
1.5.4.3

