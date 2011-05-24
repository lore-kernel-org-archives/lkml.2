Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab1EXVut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:50:49 -0400
Received: from mail.kionix.com ([66.152.113.154]:56709 "EHLO mail.kionix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833Ab1EXVur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:50:47 -0400
X-ASG-Debug-ID: 1306273843-0332000e0000-xx1T2L
X-Barracuda-URL: http://10.0.0.213:8000/cgi-bin/mark.cgi
From: Chris Hudson <chudson@kionix.com>
To: linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jonathan.cameron@gmail.com,
        linux-kernel@vger.kernel.org, Chris Hudson <chudson@kionix.com>
X-ASG-Orig-Subj: [PATCH v3] input: Add support for Kionix KXTJ9 accelerometer
Subject: [PATCH v3] input: Add support for Kionix KXTJ9 accelerometer
Date: Tue, 24 May 2011 17:51:17 -0400
Message-Id: <1306273877-28503-1-git-send-email-chudson@kionix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-Barracuda-Connect: UNKNOWN[10.0.0.125]
X-Barracuda-Start-Time: 1306273844
X-Barracuda-Virus-Scanned: by Barracuda Spam Firewall at kionix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many small changes and some larger ones in this version (thanks Jonathan!).

Note the custom i2c_read funtion is used to ensure block read functionality;
on my test hardware my function works but i2c_smbus_read_block_data does not
for some reason.

I also have an RFC on linux-input regarding the usage of the delay sysfs
attribute.  Currently it accepts an integer in milliseconds, and uses this to
set the output data rate of the part and the new poll interval if applicable,
and I want to be sure that this is a reasonable implementation.

There is also some discussion about the axis_map and negate platform data
variables.  Currently the system is set up so that the device manufacturer can
mount the sensor in any orientation within the host device, and still have the
driver output data relative to the device instead of the part itself.  The
current implementation also allows the device manufacturer to support their
chosen operating system's API requirements for axis direction (right-hand-rule
vs. left-hand-rule), but at 6 variables it could be a little confusing or
excessive.

Signed-off-by: Chris Hudson <chudson@kionix.com>
---
 drivers/input/misc/Kconfig  |   10 +
 drivers/input/misc/Makefile |    1 +
 drivers/input/misc/kxtj9.c  |  635 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/input/kxtj9.h |   90 ++++++
 4 files changed, 736 insertions(+), 0 deletions(-)
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
index 0000000..5f4cd66
--- /dev/null
+++ b/drivers/input/misc/kxtj9.c
@@ -0,0 +1,635 @@
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
+	atomic_t enabled;
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
+		ret = -1;
+
+	return ret;
+}
+
+int kxtj9_update_g_range(struct kxtj9_data *tj9, u8 new_g_range)
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
+int kxtj9_update_odr(struct kxtj9_data *tj9, int poll_interval)
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
+	if (atomic_read(&tj9->enabled)) {
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
+		/* Valid input_dev indicates that input_init passed and this
+		 * workqueue is available */
+		if (tj9->input_dev) {
+			if (!tj9->pdata.drdy_enable) {
+				cancel_delayed_work_sync(&tj9->input_work);
+				schedule_delayed_work(&tj9->input_work,
+					msecs_to_jiffies(poll_interval));
+			}
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
+	err = i2c_smbus_write_byte_data(tj9->client, INT_CTRL1,
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
+static void kxtj9_report_values(struct kxtj9_data *tj9, s16 *xyz)
+{
+	input_report_abs(tj9->input_dev, ABS_X, (int) xyz[0]);
+	input_report_abs(tj9->input_dev, ABS_Y, (int) xyz[1]);
+	input_report_abs(tj9->input_dev, ABS_Z, (int) xyz[2]);
+}
+
+static int kxtj9_get_acceleration_data(struct kxtj9_data *tj9, s16 *xyz)
+{
+	int err;
+	/* Data bytes from hardware xL, xH, yL, yH, zL, zH */
+	s16 acc_data[3];
+
+	err = kxtj9_i2c_read(tj9, XOUT_L, (u8 *)acc_data, 6);
+	if (err < 0)
+		return err;
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
+	return err;
+}
+
+static irqreturn_t kxtj9_isr(int irq, void *dev)
+{
+	struct kxtj9_data *tj9 = dev;
+	int ret;
+	s16 xyz[3];
+
+	/* data ready is the only possible interrupt type */
+	if (kxtj9_get_acceleration_data(tj9, xyz) == 0)
+		kxtj9_report_values(tj9, xyz);
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
+	int err;
+
+	if (!atomic_cmpxchg(&tj9->enabled, 0, 1)) {
+		err = kxtj9_device_power_on(tj9);
+		if (err < 0) {
+			dev_err(&tj9->client->dev,
+					"error during power-on: %d\n", err);
+			atomic_set(&tj9->enabled, 0);
+			return err;
+		}
+		err = i2c_smbus_read_byte_data(tj9->client, INT_REL);
+		if (err < 0) {
+			dev_err(&tj9->client->dev,
+					"error clearing interrupt: %d\n", err);
+			atomic_set(&tj9->enabled, 0);
+			return err;
+		}
+		if (!tj9->pdata.drdy_enable)
+			schedule_delayed_work(&tj9->input_work,
+				msecs_to_jiffies(tj9->pdata.poll_interval));
+	}
+
+	return 0;
+}
+
+static int kxtj9_disable(struct kxtj9_data *tj9)
+{
+	if (atomic_cmpxchg(&tj9->enabled, 1, 0)) {
+		if (!tj9->pdata.drdy_enable)
+			cancel_delayed_work_sync(&tj9->input_work);
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
+	s16 xyz[3];
+	mutex_lock(&tj9->lock);
+
+	if (kxtj9_get_acceleration_data(tj9, xyz) == 0)
+		kxtj9_report_values(tj9, xyz);
+
+	schedule_delayed_work(&tj9->input_work,
+			msecs_to_jiffies(tj9->pdata.poll_interval));
+	mutex_unlock(&tj9->lock);
+}
+
+int kxtj9_input_open(struct input_dev *input)
+{
+	return kxtj9_enable(input_get_drvdata(input));
+}
+
+void kxtj9_input_close(struct input_dev *dev)
+{
+	kxtj9_disable(input_get_drvdata(dev));
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
+/* kxtj9_delay_show: returns the currently selected poll interval (in ms) */
+static ssize_t kxtj9_delay_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct kxtj9_data *tj9 = i2c_get_clientdata(to_i2c_client(dev));
+	return sprintf(buf, "%d\n", tj9->pdata.poll_interval);
+}
+
+/* kxtj9_delay_store: allows the user to select a new poll interval (in ms) */
+static ssize_t kxtj9_delay_store(struct device *dev,
+					struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct kxtj9_data *tj9 = i2c_get_clientdata(to_i2c_client(dev));
+	unsigned long val;
+	int ret = kstrtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&tj9->lock);
+	/* the selected interval is the greater of the minimum interval or
+	the requested interval */
+	tj9->pdata.poll_interval = max((int)val, tj9->pdata.min_interval);
+	kxtj9_update_odr(tj9, tj9->pdata.poll_interval);
+	mutex_unlock(&tj9->lock);
+
+	return count;
+}
+
+/* kxtj9_enable_show: returns the enable status of the part */
+static ssize_t kxtj9_enable_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct kxtj9_data *tj9 = i2c_get_clientdata(to_i2c_client(dev));
+	return sprintf(buf, "%d\n", atomic_read(&tj9->enabled));
+}
+
+/* kxtj9_enable_store: allows the user to enable or disable the part */
+static ssize_t kxtj9_enable_store(struct device *dev,
+					struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct kxtj9_data *tj9 = i2c_get_clientdata(to_i2c_client(dev));
+	unsigned long val;
+	int ret = kstrtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&tj9->lock);
+	if (val)	/* non-zero argument enables the part */
+		kxtj9_enable(tj9);
+	else		/* zero argument disables the part */
+		kxtj9_disable(tj9);
+	mutex_unlock(&tj9->lock);
+
+	return count;
+}
+
+static DEVICE_ATTR(delay, S_IRUGO|S_IWUSR, kxtj9_delay_show, kxtj9_delay_store);
+static DEVICE_ATTR(enable, S_IRUGO|S_IWUSR, kxtj9_enable_show,
+							kxtj9_enable_store);
+
+static struct attribute *kxtj9_attributes[] = {
+	&dev_attr_delay.attr,
+	&dev_attr_enable.attr,
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
+	tj9->resume[RES_CTRL_REG1] = tj9->pdata.res_12bit | tj9->pdata.g_range |
+							tj9->pdata.drdy_enable;
+	tj9->resume[RES_INT_CTRL1] = tj9->pdata.int_response |
+						tj9->pdata.int_polarity |
+						tj9->pdata.int_enable;
+	tj9->resume[RES_DATA_CTRL] = tj9->pdata.data_odr_init;
+
+	err = kxtj9_device_power_on(tj9);
+	if (err < 0)
+		goto err3;
+	atomic_set(&tj9->enabled, 1);
+
+	err = kxtj9_verify(tj9);
+	if (err < 0) {
+		dev_err(&client->dev, "device not recognized\n");
+		goto err4;
+	}
+
+	err = kxtj9_input_init(tj9);
+	if (err < 0)
+		goto err4;
+
+	kxtj9_device_power_off(tj9);
+	atomic_set(&tj9->enabled, 0);
+
+	if (client->irq) {
+		err = request_threaded_irq(client->irq, NULL, kxtj9_isr,
+			IRQF_TRIGGER_RISING | IRQF_ONESHOT, "kxtj9-irq", tj9);
+		if (err < 0) {
+			pr_err("%s: request irq failed: %d\n", __func__, err);
+			goto err5;
+		}
+	}
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
+	disable_irq_nosync(client->irq);
+	free_irq(client->irq, tj9);
+	kxtj9_input_cleanup(tj9);
+	kxtj9_device_power_off(tj9);
+	if (tj9->pdata.exit)
+		tj9->pdata.exit();
+	sysfs_remove_group(&client->dev.kobj, &kxtj9_attribute_group);
+	kfree(tj9);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int kxtj9_resume(struct i2c_client *client)
+{
+	return kxtj9_enable(i2c_get_clientdata(client));
+}
+
+static int kxtj9_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	return kxtj9_disable(i2c_get_clientdata(client));
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
diff --git a/include/linux/input/kxtj9.h b/include/linux/input/kxtj9.h
new file mode 100644
index 0000000..55c4b57
--- /dev/null
+++ b/include/linux/input/kxtj9.h
@@ -0,0 +1,90 @@
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
+	u8 negate_x;
+	u8 negate_y;
+	u8 negate_z;
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
+	/* Data ready funtion enable bit */
+	#define DRDYE			(1 << 5)
+	u8 drdy_enable;
+
+	/* INT_CTRL_REG1: set interrupt pin enable, polarity, and response */
+	/* Interrupt pin response: set = pulse mode; unset = latch mode */
+	#define KXTJ9_IEL		(1 << 3)
+	u8 int_response;
+	/* Interrupt pin polarity: set = active high; unset = active low */
+	#define KXTJ9_IEA		(1 << 4)
+	u8 int_polarity;
+	/* Interrupt pin enable: set = enable; unset = disable */
+	#define KXTJ9_IEN		(1 << 5)
+	u8 int_enable;
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

