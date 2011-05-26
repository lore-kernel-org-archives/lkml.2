Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab1EZWnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:43:05 -0400
Received: from mail.kionix.com ([66.152.113.154]:49548 "EHLO mail.kionix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab1EZWnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:43:04 -0400
X-ASG-Debug-ID: 1306449614-3dcd002b0000-xx1T2L
X-Barracuda-URL: http://10.0.0.213:8000/cgi-bin/mark.cgi
From: Chris Hudson <chudson@kionix.com>
To: linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jonathan.cameron@gmail.com,
        linux-kernel@vger.kernel.org, Chris Hudson <chudson@kionix.com>
X-ASG-Orig-Subj: [PATCH v4] input: Add support for Kionix KXTJ9 accelerometer
Subject: [PATCH v4] input: Add support for Kionix KXTJ9 accelerometer
Date: Thu, 26 May 2011 18:40:20 -0400
Message-Id: <1306449620-21879-1-git-send-email-chudson@kionix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-Barracuda-Connect: UNKNOWN[10.0.0.125]
X-Barracuda-Start-Time: 1306449618
X-Barracuda-Virus-Scanned: by Barracuda Spam Firewall at kionix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quite a few changes this time around (thanks Jonathan and Dmitry!):
- The sysfs node for poll_interval was changed to emulate input_polldev.  I
  could not actually use input_polldev because some commands need to be sent
  to the hardware when the poll interval is changed.
- Locking cleaned up throughout
- Cleared up distinction between IRQ and polling modes: if client->irq, then
  irq mode is enabled.  Removed register bits required for irq from the header;
  these will be set in the driver if client->irq is populated.
- Put .suspend and .resume into struct dev_pm_ops.
- Many other smaller changes, unnecessary variables removed, etc.

Signed-off-by: Chris Hudson <chudson@kionix.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/input/misc/Kconfig  |   10 +
 drivers/input/misc/Makefile |    1 +
 drivers/input/misc/kxtj9.c  |  606 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/input/kxtj9.h |   76 ++++++
 4 files changed, 693 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/kxtj9.c
 create mode 100644 include/linux/input/kxtj9.h

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
index 0000000..ef83182
--- /dev/null
+++ b/drivers/input/misc/kxtj9.c
@@ -0,0 +1,606 @@
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
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/input/kxtj9.h>
+
+#define NAME			"kxtj9"
+#define G_MAX			8000
+/* OUTPUT REGISTERS */
+#define XOUT_L			0x06
+#define WHO_AM_I		0x0F
+/* CONTROL REGISTERS */
+#define INT_REL			0x1A
+#define CTRL_REG1		0x1B
+#define INT_CTRL1		0x1E
+#define DATA_CTRL		0x21
+/* CONTROL REGISTER 1 BITS */
+#define PC1_OFF			0x7F
+#define PC1_ON			(1 << 7)
+/* Data ready funtion enable bit: set during probe if using irq mode */
+#define DRDYE			(1 << 5)
+/* INTERRUPT CONTROL REGISTER 1 BITS */
+/* Set these during probe if using irq mode */
+#define KXTJ9_IEL		(1 << 3)
+#define KXTJ9_IEA		(1 << 4)
+#define KXTJ9_IEN		(1 << 5)
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
+static const struct {
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
+	struct kxtj9_platform_data pdata;
+	struct mutex lock;
+	struct delayed_work input_work;
+	struct input_dev *input_dev;
+
+	bool hw_initialized;
+	bool enabled;
+	u8 shift;
+	u8 resume[RESUME_ENTRIES];
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
+	return err;
+}
+
+static int kxtj9_verify(struct kxtj9_data *tj9)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(tj9->client, WHO_AM_I);
+	if (ret < 0)
+		dev_err(&tj9->client->dev, "read err int source\n");
+	if (ret != 0x06)
+		ret = -EIO;
+
+	return ret;
+}
+
+static int kxtj9_update_g_range(struct kxtj9_data *tj9, u8 new_g_range)
+{
+	switch (new_g_range) {
+	case KXTJ9_G_2G:
+		tj9->shift = SHIFT_ADJ_2G;
+		break;
+	case KXTJ9_G_4G:
+		tj9->shift = SHIFT_ADJ_4G;
+		break;
+	case KXTJ9_G_8G:
+		tj9->shift = SHIFT_ADJ_8G;
+		break;
+	default:
+		return -EINVAL;
+	}
+	tj9->resume[RES_CTRL_REG1] = (tj9->resume[RES_CTRL_REG1] & 0xE7)
+								| new_g_range;
+
+	return 0;
+}
+
+static int kxtj9_update_odr(struct kxtj9_data *tj9, int poll_interval)
+{
+	int err;
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
+	if (tj9->enabled == true) {
+		err = i2c_smbus_write_byte_data(tj9->client, CTRL_REG1, temp);
+		if (err < 0)
+			return err;
+		err = i2c_smbus_write_byte_data(tj9->client, DATA_CTRL, config);
+		if (err < 0)
+			return err;
+		temp = tj9->resume[RES_CTRL_REG1];
+		err = i2c_smbus_write_byte_data(tj9->client, CTRL_REG1, temp);
+		if (err < 0)
+			return err;
+		/* Cancel and restart polling if not in irq mode */
+		if (!tj9->client->irq) {
+			cancel_delayed_work_sync(&tj9->input_work);
+			schedule_delayed_work(&tj9->input_work,
+					msecs_to_jiffies(poll_interval));
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
+	err = i2c_smbus_write_byte_data(tj9->client, CTRL_REG1, buf);
+	if (err < 0)
+		return err;
+	err = i2c_smbus_write_byte_data(tj9->client, DATA_CTRL,
+						tj9->resume[RES_DATA_CTRL]);
+	if (err < 0)
+		return err;
+	if (tj9->client->irq) /* only write INT_CTRL_REG1 if in irq mode */
+		err = i2c_smbus_write_byte_data(tj9->client, INT_CTRL1,
+						tj9->resume[RES_INT_CTRL1]);
+	if (err < 0)
+		return err;
+
+	err = kxtj9_update_g_range(tj9, tj9->pdata.g_range);
+	if (err < 0)
+		return err;
+
+	buf = (tj9->resume[RES_CTRL_REG1] | PC1_ON);
+	err = i2c_smbus_write_byte_data(tj9->client, CTRL_REG1, buf);
+	if (err < 0)
+		return err;
+	tj9->resume[RES_CTRL_REG1] = buf;
+
+	err = kxtj9_update_odr(tj9, tj9->pdata.poll_interval);
+	if (err < 0)
+		return err;
+
+	tj9->hw_initialized = true;
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
+	err = i2c_smbus_write_byte_data(tj9->client, CTRL_REG1, buf);
+	if (err < 0)
+		dev_err(&tj9->client->dev, "soft power off failed\n");
+	if (tj9->pdata.power_off)
+		tj9->pdata.power_off();
+	tj9->resume[RES_CTRL_REG1] = buf;
+	tj9->hw_initialized = false;
+}
+
+static int kxtj9_device_power_on(struct kxtj9_data *tj9)
+{
+	int err;
+
+	if (tj9->pdata.power_on) {
+		err = tj9->pdata.power_on();
+		if (err < 0)
+			return err;
+	}
+	if (!tj9->hw_initialized) {
+		msleep(40);
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
+static void kxtj9_get_acceleration_data(struct kxtj9_data *tj9, s16 *xyz)
+{
+	int err;
+	/* Data bytes from hardware xL, xH, yL, yH, zL, zH */
+	s16 acc_data[3];
+
+	err = kxtj9_i2c_read(tj9, XOUT_L, (u8 *)acc_data, 6);
+	if (err < 0)
+		dev_err(&tj9->client->dev, "accelerometer data read failed\n");
+
+	acc_data[0] = le16_to_cpu(acc_data[0]);
+	acc_data[1] = le16_to_cpu(acc_data[1]);
+	acc_data[2] = le16_to_cpu(acc_data[2]);
+
+	acc_data[0] >>= tj9->shift;
+	acc_data[1] >>= tj9->shift;
+	acc_data[2] >>= tj9->shift;
+
+	xyz[0] = (tj9->pdata.negate_x) ? (-acc_data[tj9->pdata.axis_map_x])
+		  : (acc_data[tj9->pdata.axis_map_x]);
+	xyz[1] = (tj9->pdata.negate_y) ? (-acc_data[tj9->pdata.axis_map_y])
+		  : (acc_data[tj9->pdata.axis_map_y]);
+	xyz[2] = (tj9->pdata.negate_z) ? (-acc_data[tj9->pdata.axis_map_z])
+		  : (acc_data[tj9->pdata.axis_map_z]);
+
+	input_report_abs(tj9->input_dev, ABS_X, (int) xyz[0]);
+	input_report_abs(tj9->input_dev, ABS_Y, (int) xyz[1]);
+	input_report_abs(tj9->input_dev, ABS_Z, (int) xyz[2]);
+	input_sync(tj9->input_dev);
+}
+
+static irqreturn_t kxtj9_isr(int irq, void *dev)
+{
+	struct kxtj9_data *tj9 = dev;
+	int ret;
+	s16 xyz[3];
+
+	/* data ready is the only possible interrupt type */
+	kxtj9_get_acceleration_data(tj9, xyz);
+
+	ret = i2c_smbus_read_byte_data(tj9->client, INT_REL);
+	if (ret < 0)
+		dev_err(&tj9->client->dev,
+				"error clearing interrupt status: %d\n", ret);
+
+	return IRQ_HANDLED;
+}
+
+static int kxtj9_enable(struct kxtj9_data *tj9)
+{
+	int err = 0;
+
+	mutex_lock(&tj9->lock);
+	if (tj9->enabled == false) {
+		err = kxtj9_device_power_on(tj9);
+		if (err < 0) {
+			dev_err(&tj9->client->dev,
+					"error during power-on: %d\n", err);
+			goto err0;
+		}
+		err = i2c_smbus_read_byte_data(tj9->client, INT_REL);
+		if (err < 0) {
+			dev_err(&tj9->client->dev,
+					"error clearing interrupt: %d\n", err);
+			goto err0;
+		}
+		if (!tj9->client->irq) /* queue polling if not in irq mode */
+			schedule_delayed_work(&tj9->input_work,
+				msecs_to_jiffies(tj9->pdata.poll_interval));
+		tj9->enabled = true;
+	}
+err0:
+	mutex_unlock(&tj9->lock);
+
+	return err;
+}
+
+static int kxtj9_disable(struct kxtj9_data *tj9)
+{
+	mutex_lock(&tj9->lock);
+	if (tj9->enabled == true) {
+		if (!tj9->client->irq) /* cancel polling if not in irq mode */
+			cancel_delayed_work_sync(&tj9->input_work);
+		kxtj9_device_power_off(tj9);
+		tj9->enabled = false;
+	}
+	mutex_unlock(&tj9->lock);
+
+	return 0;
+}
+
+static void kxtj9_input_work_func(struct work_struct *work)
+{
+	struct kxtj9_data *tj9 = container_of(work, struct kxtj9_data,
+							input_work.work);
+	s16 xyz[3];
+	mutex_lock(&tj9->lock);
+
+	kxtj9_get_acceleration_data(tj9, xyz);
+
+	schedule_delayed_work(&tj9->input_work,
+			msecs_to_jiffies(tj9->pdata.poll_interval));
+	mutex_unlock(&tj9->lock);
+}
+
+static int kxtj9_input_open(struct input_dev *input)
+{
+	return kxtj9_enable(input_get_drvdata(input));
+}
+
+static void kxtj9_input_close(struct input_dev *dev)
+{
+	kxtj9_disable(input_get_drvdata(dev));
+}
+
+static int kxtj9_input_init(struct kxtj9_data *tj9)
+{
+	int err;
+
+	if (!tj9->client->irq) /* only use input_work if not in irq mode */
+		INIT_DELAYED_WORK(&tj9->input_work, kxtj9_input_work_func);
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
+
+	input_set_abs_params(tj9->input_dev, ABS_X, -G_MAX, G_MAX, FUZZ, FLAT);
+	input_set_abs_params(tj9->input_dev, ABS_Y, -G_MAX, G_MAX, FUZZ, FLAT);
+	input_set_abs_params(tj9->input_dev, ABS_Z, -G_MAX, G_MAX, FUZZ, FLAT);
+
+	tj9->input_dev->name = "kxtj9_accel";
+	tj9->input_dev->id.bustype = BUS_I2C;
+	tj9->input_dev->dev.parent = &tj9->client->dev;
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
+/* kxtj9_delay_show: returns the currently selected poll interval (in ms) */
+static ssize_t kxtj9_get_poll(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct kxtj9_data *tj9 = i2c_get_clientdata(to_i2c_client(dev));
+	return sprintf(buf, "%d\n", tj9->pdata.poll_interval);
+}
+
+/* kxtj9_delay_store: allows the user to select a new poll interval (in ms) */
+static ssize_t kxtj9_set_poll(struct device *dev, struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct kxtj9_data *tj9 = i2c_get_clientdata(to_i2c_client(dev));
+	unsigned long interval;
+	int ret = kstrtoul(buf, 10, &interval);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&tj9->lock);
+	/* set current interval to the greater of the minimum interval or
+	the requested interval */
+	tj9->pdata.poll_interval = max((int)interval, tj9->pdata.min_interval);
+	mutex_unlock(&tj9->lock);
+
+	kxtj9_update_odr(tj9, tj9->pdata.poll_interval);
+
+	return count;
+}
+static DEVICE_ATTR(poll, S_IRUGO|S_IWUSR, kxtj9_get_poll, kxtj9_set_poll);
+
+static struct attribute *kxtj9_attributes[] = {
+	&dev_attr_poll.attr,
+	NULL
+};
+
+static struct attribute_group kxtj9_attribute_group = {
+	.attrs = kxtj9_attributes
+};
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
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C |
+						I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_err(&client->dev, "client not i2c capable\n");
+		err = -ENODEV;
+		goto err0;
+	}
+	mutex_init(&tj9->lock);
+	mutex_lock(&tj9->lock);
+	tj9->client = client;
+	i2c_set_clientdata(client, tj9);
+
+	memcpy(&tj9->pdata, client->dev.platform_data, sizeof(tj9->pdata));
+	if (tj9->pdata.init) {
+		err = tj9->pdata.init();
+		if (err < 0)
+			goto err1;
+	}
+
+	err = sysfs_create_group(&client->dev.kobj, &kxtj9_attribute_group);
+	if (err)
+		goto err2;
+
+	tj9->resume[RES_CTRL_REG1] = tj9->pdata.res_12bit | tj9->pdata.g_range;
+	tj9->resume[RES_DATA_CTRL] = tj9->pdata.data_odr_init;
+
+	if (client->irq) {
+		err = request_threaded_irq(client->irq, NULL, kxtj9_isr,
+			IRQF_TRIGGER_RISING | IRQF_ONESHOT, "kxtj9-irq", tj9);
+		if (err < 0) {
+			pr_err("%s: request irq failed: %d\n", __func__, err);
+			goto err5;
+		}
+		/* if in irq mode, populate INT_CTRL_REG1 and enable DRDY */
+		tj9->resume[RES_INT_CTRL1] = KXTJ9_IEN | KXTJ9_IEA | KXTJ9_IEL;
+		tj9->resume[RES_CTRL_REG1] |= DRDYE;
+	}
+
+	err = kxtj9_input_init(tj9);
+	if (err < 0)
+		goto err3;
+
+	err = kxtj9_device_power_on(tj9);
+	if (err < 0)
+		goto err4;
+	tj9->enabled = true;
+
+	err = kxtj9_verify(tj9);
+	if (err < 0) {
+		dev_err(&client->dev, "device not recognized\n");
+		goto err5;
+	}
+
+	mutex_unlock(&tj9->lock);
+
+	return 0;
+
+err5:
+	kxtj9_device_power_off(tj9);
+err4:
+	input_unregister_device(tj9->input_dev);
+err3:
+	sysfs_remove_group(&client->dev.kobj, &kxtj9_attribute_group);
+err2:
+	if (tj9->pdata.exit)
+		tj9->pdata.exit();
+err1:
+	mutex_unlock(&tj9->lock);
+err0:
+	kfree(tj9);
+	return err;
+}
+
+static int __devexit kxtj9_remove(struct i2c_client *client)
+{
+	struct kxtj9_data *tj9 = i2c_get_clientdata(client);
+
+	sysfs_remove_group(&client->dev.kobj, &kxtj9_attribute_group);
+	if (client->irq)
+		free_irq(client->irq, tj9);
+	input_unregister_device(tj9->input_dev);
+	kxtj9_device_power_off(tj9);
+	if (tj9->pdata.exit)
+		tj9->pdata.exit();
+	kfree(tj9);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int kxtj9_resume(struct device *dev)
+{
+	return kxtj9_enable(i2c_get_clientdata(to_i2c_client(dev)));
+}
+
+static int kxtj9_suspend(struct device *dev)
+{
+	return kxtj9_disable(i2c_get_clientdata(to_i2c_client(dev)));
+}
+
+static const struct dev_pm_ops kxtj9_pm_ops = {
+	.suspend = kxtj9_suspend,
+	.resume = kxtj9_resume,
+};
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
+		   .owner = THIS_MODULE,
+#ifdef CONFIG_PM
+		   .pm = &kxtj9_pm_ops,
+#endif
+		   },
+	.probe = kxtj9_probe,
+	.remove = __devexit_p(kxtj9_remove),
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
diff --git a/include/linux/input/kxtj9.h b/include/linux/input/kxtj9.h
new file mode 100644
index 0000000..cc5928b
--- /dev/null
+++ b/include/linux/input/kxtj9.h
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
+
+/* These shift values are used to provide consistent output data */
+#define SHIFT_ADJ_2G		4
+#define SHIFT_ADJ_4G		3
+#define SHIFT_ADJ_8G		2
+
+#ifdef __KERNEL__
+struct kxtj9_platform_data {
+	int poll_interval;	/* current poll interval (in milli-seconds) */
+	int min_interval;	/* minimum poll interval (in milli-seconds) */
+
+	/* by default, x is axis 0, y is axis 1, z is axis 2; these can be
+	changed to account for sensor orientation within the host device */
+	u8 axis_map_x;
+	u8 axis_map_y;
+	u8 axis_map_z;
+
+	/* each axis can be negated to account for sensor orientation within
+	the host device; 1 = negate this axis; 0 = do not negate this axis */
+	bool negate_x;
+	bool negate_y;
+	bool negate_z;
+
+	/* CTRL_REG1: set resolution, g-range, data ready enable */
+	/* Output resolution: 8-bit valid or 12-bit valid */
+	#define RES_8BIT		0
+	#define RES_12BIT		(1 << 6)
+	u8 res_12bit;
+	/* Output g-range: +/-2g, 4g, or 8g */
+	#define KXTJ9_G_2G		0
+	#define KXTJ9_G_4G		(1 << 3)
+	#define KXTJ9_G_8G		(1 << 4)
+	u8 g_range;
+
+	/* DATA_CTRL_REG: controls the output data rate of the part */
+	#define ODR12_5F		0
+	#define ODR25F			1
+	#define ODR50F			2
+	#define ODR100F			3
+	#define ODR200F			4
+	#define ODR400F			5
+	#define ODR800F			6
+	u8 data_odr_init;
+
+	int (*init)(void);
+	void (*exit)(void);
+	int (*power_on)(void);
+	int (*power_off)(void);
+};
+#endif /* __KERNEL__ */
+
+#endif  /* __KXTJ9_H__ */
+
-- 
1.5.4.3

