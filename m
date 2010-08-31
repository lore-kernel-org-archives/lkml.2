Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab0HaK2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 06:28:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56940 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab0HaK2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 06:28:44 -0400
Date: Tue, 31 Aug 2010 19:28:42 +0900
From: Minkyu Kang <mk7.kang@samsung.com>
Subject: [PATCH] misc: adds support the FSA9480 USB Switch
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: kyungmin.park@samsung.com
Message-id: <4C7CD95A.5040309@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=EUC-KR
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ko; rv:1.9.2.7)
 Gecko/20100713 Thunderbird/3.1.1
X-OriginalArrivalTime: 31 Aug 2010 10:28:42.0425 (UTC)
 FILETIME=[48B6C290:01CB48F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FSA9480 is a USB port accessory detector and switch.
This patch adds support the FSA9480 USB Switch.

Signed-off-by: Minkyu Kang <mk7.kang@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/misc/Kconfig    |    9 +
 drivers/misc/Makefile   |    1 +
 drivers/misc/fsa9480.c  |  556 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fsa9480.h |   40 ++++
 4 files changed, 606 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/fsa9480.c
 create mode 100644 include/linux/fsa9480.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 0b591b6..191137e 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -390,6 +390,15 @@ config BMP085
 	  To compile this driver as a module, choose M here: the
 	  module will be called bmp085.
 
+config USB_SWITCH_FSA9480
+	tristate "FSA9480 USB Switch"
+	depends on I2C
+	help
+	  The FSA9480 is a USB port accessory detector and switch.
+	  The FSA9480 is fully controlled using I2C and enables USB data,
+	  stereo and mono audio, video, microphone and UART data to use
+	  a common connector port.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 255a80d..071b380 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -35,3 +35,4 @@ obj-y				+= eeprom/
 obj-y				+= cb710/
 obj-$(CONFIG_VMWARE_BALLOON)	+= vmware_balloon.o
 obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
+obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
diff --git a/drivers/misc/fsa9480.c b/drivers/misc/fsa9480.c
new file mode 100644
index 0000000..c140410
--- /dev/null
+++ b/drivers/misc/fsa9480.c
@@ -0,0 +1,556 @@
+/*
+ * fsa9480.c - FSA9480 micro USB switch device driver
+ *
+ * Copyright (C) 2010 Samsung Electronics
+ * Minkyu Kang <mk7.kang@samsung.com>
+ * Wonguk Jeong <wonguk.jeong@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/fsa9480.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+/* FSA9480 I2C registers */
+#define FSA9480_REG_DEVID		0x01
+#define FSA9480_REG_CTRL		0x02
+#define FSA9480_REG_INT1		0x03
+#define FSA9480_REG_INT2		0x04
+#define FSA9480_REG_INT1_MASK		0x05
+#define FSA9480_REG_INT2_MASK		0x06
+#define FSA9480_REG_ADC			0x07
+#define FSA9480_REG_TIMING1		0x08
+#define FSA9480_REG_TIMING2		0x09
+#define FSA9480_REG_DEV_T1		0x0a
+#define FSA9480_REG_DEV_T2		0x0b
+#define FSA9480_REG_BTN1		0x0c
+#define FSA9480_REG_BTN2		0x0d
+#define FSA9480_REG_CK			0x0e
+#define FSA9480_REG_CK_INT1		0x0f
+#define FSA9480_REG_CK_INT2		0x10
+#define FSA9480_REG_CK_INTMASK1		0x11
+#define FSA9480_REG_CK_INTMASK2		0x12
+#define FSA9480_REG_MANSW1		0x13
+#define FSA9480_REG_MANSW2		0x14
+
+/* Control */
+#define CON_SWITCH_OPEN		(1 << 4)
+#define CON_RAW_DATA		(1 << 3)
+#define CON_MANUAL_SW		(1 << 2)
+#define CON_WAIT		(1 << 1)
+#define CON_INT_MASK		(1 << 0)
+#define CON_MASK		(CON_SWITCH_OPEN | CON_RAW_DATA | \
+				CON_MANUAL_SW | CON_WAIT)
+
+/* Device Type 1 */
+#define DEV_USB_OTG		(1 << 7)
+#define DEV_DEDICATED_CHG	(1 << 6)
+#define DEV_USB_CHG		(1 << 5)
+#define DEV_CAR_KIT		(1 << 4)
+#define DEV_UART		(1 << 3)
+#define DEV_USB			(1 << 2)
+#define DEV_AUDIO_2		(1 << 1)
+#define DEV_AUDIO_1		(1 << 0)
+
+#define DEV_T1_USB_MASK		(DEV_USB_OTG | DEV_USB)
+#define DEV_T1_UART_MASK	(DEV_UART)
+#define DEV_T1_CHARGER_MASK	(DEV_DEDICATED_CHG | DEV_USB_CHG)
+
+/* Device Type 2 */
+#define DEV_AV			(1 << 6)
+#define DEV_TTY			(1 << 5)
+#define DEV_PPD			(1 << 4)
+#define DEV_JIG_UART_OFF	(1 << 3)
+#define DEV_JIG_UART_ON		(1 << 2)
+#define DEV_JIG_USB_OFF		(1 << 1)
+#define DEV_JIG_USB_ON		(1 << 0)
+
+#define DEV_T2_USB_MASK		(DEV_JIG_USB_OFF | DEV_JIG_USB_ON)
+#define DEV_T2_UART_MASK	(DEV_JIG_UART_OFF | DEV_JIG_UART_ON)
+#define DEV_T2_JIG_MASK		(DEV_JIG_USB_OFF | DEV_JIG_USB_ON | \
+				DEV_JIG_UART_OFF | DEV_JIG_UART_ON)
+
+/*
+ * Manual Switch
+ * D- [7:5] / D+ [4:2]
+ * 000: Open all / 001: USB / 010: AUDIO / 011: UART / 100: V_AUDIO
+ */
+#define SW_VAUDIO		((4 << 5) | (4 << 2))
+#define SW_UART			((3 << 5) | (3 << 2))
+#define SW_AUDIO		((2 << 5) | (2 << 2))
+#define SW_DHOST		((1 << 5) | (1 << 2))
+#define SW_AUTO			((0 << 5) | (0 << 2))
+
+/* Interrupt 1 */
+#define INT_DETACH		(1 << 1)
+#define INT_ATTACH		(1 << 0)
+
+struct fsa9480_usbsw {
+	struct i2c_client		*client;
+	struct fsa9480_platform_data	*pdata;
+	struct work_struct		work;
+	int				dev1;
+	int				dev2;
+	int				mansw;
+};
+
+static struct fsa9480_usbsw *chip;
+
+static int fsa9480_write_reg(struct i2c_client *client,
+		int reg, int value)
+{
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(client, reg, value);
+
+	if (ret < 0)
+		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
+
+	return ret;
+}
+
+static int fsa9480_read_reg(struct i2c_client *client, int reg)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(client, reg);
+
+	if (ret < 0)
+		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
+
+	return ret;
+}
+
+static int fsa9480_read_irq(struct i2c_client *client, int *value)
+{
+	int ret;
+
+	ret = i2c_smbus_read_i2c_block_data(client,
+			FSA9480_REG_INT1, 2, (u8 *)value);
+	*value &= 0xffff;
+
+	if (ret < 0)
+		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
+
+	return ret;
+}
+
+void fsa9480_set_switch(const char *buf)
+{
+	struct fsa9480_usbsw *usbsw = chip;
+	struct i2c_client *client = usbsw->client;
+	unsigned int value;
+	unsigned int path = 0;
+
+	value = fsa9480_read_reg(client, FSA9480_REG_CTRL);
+
+	if (!strncmp(buf, "VAUDIO", 6)) {
+		path = SW_VAUDIO;
+		value &= ~CON_MANUAL_SW;
+	} else if (!strncmp(buf, "UART", 4)) {
+		path = SW_UART;
+		value &= ~CON_MANUAL_SW;
+	} else if (!strncmp(buf, "AUDIO", 5)) {
+		path = SW_AUDIO;
+		value &= ~CON_MANUAL_SW;
+	} else if (!strncmp(buf, "DHOST", 5)) {
+		path = SW_DHOST;
+		value &= ~CON_MANUAL_SW;
+	} else if (!strncmp(buf, "AUTO", 4)) {
+		path = SW_AUTO;
+		value |= CON_MANUAL_SW;
+	} else {
+		printk(KERN_ERR "Wrong command\n");
+		return;
+	}
+
+	usbsw->mansw = path;
+	fsa9480_write_reg(client, FSA9480_REG_MANSW1, path);
+	fsa9480_write_reg(client, FSA9480_REG_CTRL, value);
+}
+EXPORT_SYMBOL_GPL(fsa9480_set_switch);
+
+ssize_t fsa9480_get_switch(char *buf)
+{
+	struct fsa9480_usbsw *usbsw = chip;
+	struct i2c_client *client = usbsw->client;
+	unsigned int value;
+
+	value = fsa9480_read_reg(client, FSA9480_REG_MANSW1);
+
+	if (value == SW_VAUDIO)
+		return sprintf(buf, "VAUDIO\n");
+	else if (value == SW_UART)
+		return sprintf(buf, "UART\n");
+	else if (value == SW_AUDIO)
+		return sprintf(buf, "AUDIO\n");
+	else if (value == SW_DHOST)
+		return sprintf(buf, "DHOST\n");
+	else if (value == SW_AUTO)
+		return sprintf(buf, "AUTO\n");
+	else
+		return sprintf(buf, "%x", value);
+}
+EXPORT_SYMBOL_GPL(fsa9480_get_switch);
+
+static ssize_t fsa9480_show_status(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	struct fsa9480_usbsw *usbsw = dev_get_drvdata(dev);
+	struct i2c_client *client = usbsw->client;
+	int devid, ctrl, adc, dev1, dev2, intr,
+	    intmask1, intmask2, time1, time2, mansw1;
+
+	devid = fsa9480_read_reg(client, FSA9480_REG_DEVID);
+	ctrl = fsa9480_read_reg(client, FSA9480_REG_CTRL);
+	adc = fsa9480_read_reg(client, FSA9480_REG_ADC);
+	intmask1 = fsa9480_read_reg(client, FSA9480_REG_INT1_MASK);
+	intmask2 = fsa9480_read_reg(client, FSA9480_REG_INT2_MASK);
+	dev1 = fsa9480_read_reg(client, FSA9480_REG_DEV_T1);
+	dev2 = fsa9480_read_reg(client, FSA9480_REG_DEV_T2);
+	time1 = fsa9480_read_reg(client, FSA9480_REG_TIMING1);
+	time2 = fsa9480_read_reg(client, FSA9480_REG_TIMING2);
+	mansw1 = fsa9480_read_reg(client, FSA9480_REG_MANSW1);
+
+	fsa9480_read_irq(client, &intr);
+
+	return sprintf(buf, "Device ID(%02x), CTRL(%02x)\n"
+			"ADC(%02x), DEV_T1(%02x), DEV_T2(%02x)\n"
+			"INT(%04x), INTMASK(%02x, %02x)\n"
+			"TIMING(%02x, %02x), MANSW1(%02x)\n",
+			devid, ctrl, adc, dev1, dev2, intr,
+			intmask1, intmask2, time1, time2, mansw1);
+}
+
+static ssize_t fsa9480_show_manualsw(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return fsa9480_get_switch(buf);
+
+}
+
+static ssize_t fsa9480_set_manualsw(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	fsa9480_set_switch(buf);
+
+	return count;
+}
+
+static DEVICE_ATTR(status, S_IRUGO, fsa9480_show_status, NULL);
+static DEVICE_ATTR(switch, S_IRUGO | S_IWUGO,
+		fsa9480_show_manualsw, fsa9480_set_manualsw);
+
+static struct attribute *fsa9480_attributes[] = {
+	&dev_attr_status.attr,
+	&dev_attr_switch.attr,
+	NULL
+};
+
+static const struct attribute_group fsa9480_group = {
+	.attrs = fsa9480_attributes,
+};
+
+static irqreturn_t fsa9480_irq_handler(int irq, void *data)
+{
+	struct fsa9480_usbsw *usbsw = data;
+
+	if (!work_pending(&usbsw->work)) {
+		disable_irq_nosync(irq);
+		schedule_work(&usbsw->work);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void fsa9480_detect_dev(struct fsa9480_usbsw *usbsw, int intr)
+{
+	int val1, val2, ctrl;
+	struct fsa9480_platform_data *pdata = usbsw->pdata;
+	struct i2c_client *client = usbsw->client;
+
+	val1 = fsa9480_read_reg(client, FSA9480_REG_DEV_T1);
+	val2 = fsa9480_read_reg(client, FSA9480_REG_DEV_T2);
+	ctrl = fsa9480_read_reg(client, FSA9480_REG_CTRL);
+
+	dev_info(&client->dev, "intr: 0x%x, dev1: 0x%x, dev2: 0x%x\n",
+			intr, val1, val2);
+
+	if (!intr)
+		goto out;
+
+	if (intr & INT_ATTACH) {	/* Attached */
+		/* USB */
+		if (val1 & DEV_T1_USB_MASK || val2 & DEV_T2_USB_MASK) {
+			if (pdata->usb_cb)
+				pdata->usb_cb(FSA9480_ATTACHED);
+
+			if (usbsw->mansw) {
+				fsa9480_write_reg(client,
+					FSA9480_REG_MANSW1, usbsw->mansw);
+			}
+		}
+
+		/* UART */
+		if (val1 & DEV_T1_UART_MASK || val2 & DEV_T2_UART_MASK) {
+			if (pdata->uart_cb)
+				pdata->uart_cb(FSA9480_ATTACHED);
+
+			if (!(ctrl & CON_MANUAL_SW)) {
+				fsa9480_write_reg(client,
+					FSA9480_REG_MANSW1, SW_UART);
+			}
+		}
+
+		/* CHARGER */
+		if (val1 & DEV_T1_CHARGER_MASK) {
+			if (pdata->charger_cb)
+				pdata->charger_cb(FSA9480_ATTACHED);
+		}
+
+		/* JIG */
+		if (val2 & DEV_T2_JIG_MASK) {
+			if (pdata->jig_cb)
+				pdata->jig_cb(FSA9480_ATTACHED);
+		}
+	} else if (intr & INT_DETACH) {	/* Detached */
+		/* USB */
+		if (usbsw->dev1 & DEV_T1_USB_MASK ||
+			usbsw->dev2 & DEV_T2_USB_MASK) {
+			if (pdata->usb_cb)
+				pdata->usb_cb(FSA9480_DETACHED);
+		}
+
+		/* UART */
+		if (usbsw->dev1 & DEV_T1_UART_MASK ||
+			usbsw->dev2 & DEV_T2_UART_MASK) {
+			if (pdata->uart_cb)
+				pdata->uart_cb(FSA9480_DETACHED);
+		}
+
+		/* CHARGER */
+		if (usbsw->dev1 & DEV_T1_CHARGER_MASK) {
+			if (pdata->charger_cb)
+				pdata->charger_cb(FSA9480_DETACHED);
+		}
+
+		/* JIG */
+		if (usbsw->dev2 & DEV_T2_JIG_MASK) {
+			if (pdata->jig_cb)
+				pdata->jig_cb(FSA9480_DETACHED);
+		}
+	}
+
+	usbsw->dev1 = val1;
+	usbsw->dev2 = val2;
+
+out:
+	ctrl &= ~CON_INT_MASK;
+	fsa9480_write_reg(client, FSA9480_REG_CTRL, ctrl);
+}
+
+static void fsa9480_work_cb(struct work_struct *work)
+{
+	int intr;
+	struct fsa9480_usbsw *usbsw =
+		container_of(work, struct fsa9480_usbsw, work);
+	struct i2c_client *client = usbsw->client;
+
+	/* clear interrupt */
+	fsa9480_read_irq(client, &intr);
+
+	/* device detection */
+	fsa9480_detect_dev(usbsw, intr);
+
+	enable_irq(client->irq);
+}
+
+static int fsa9480_irq_init(struct fsa9480_usbsw *usbsw)
+{
+	struct fsa9480_platform_data *pdata = usbsw->pdata;
+	struct i2c_client *client = usbsw->client;
+	int ret;
+	int intr;
+	unsigned int ctrl = CON_MASK;
+
+	/* clear interrupt */
+	fsa9480_read_irq(client, &intr);
+
+	/* unmask interrupt (attach/detach only) */
+	fsa9480_write_reg(client, FSA9480_REG_INT1_MASK, 0xfc);
+	fsa9480_write_reg(client, FSA9480_REG_INT2_MASK, 0x1f);
+
+	usbsw->mansw = fsa9480_read_reg(client, FSA9480_REG_MANSW1);
+
+	if (usbsw->mansw)
+		ctrl &= ~CON_MANUAL_SW;	/* Manual Switching Mode */
+
+	fsa9480_write_reg(client, FSA9480_REG_CTRL, ctrl);
+
+	INIT_WORK(&usbsw->work, fsa9480_work_cb);
+
+	if (pdata && pdata->cfg_gpio)
+		pdata->cfg_gpio();
+
+	if (client->irq) {
+		ret = request_irq(client->irq, fsa9480_irq_handler,
+				IRQF_TRIGGER_LOW | IRQF_DISABLED,
+				"fsa9480 micro USB", usbsw);
+		if (ret) {
+			dev_err(&client->dev, "failed to reqeust IRQ\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int __devinit fsa9480_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	struct fsa9480_usbsw *usbsw;
+	int ret = 0;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -EIO;
+
+	usbsw = kzalloc(sizeof(struct fsa9480_usbsw), GFP_KERNEL);
+	if (!usbsw) {
+		dev_err(&client->dev, "failed to allocate driver data\n");
+		return -ENOMEM;
+	}
+
+	usbsw->client = client;
+	usbsw->pdata = client->dev.platform_data;
+
+	chip = usbsw;
+
+	i2c_set_clientdata(client, usbsw);
+
+	ret = fsa9480_irq_init(usbsw);
+	if (ret)
+		goto fail1;
+
+	ret = sysfs_create_group(&client->dev.kobj, &fsa9480_group);
+	if (ret) {
+		dev_err(&client->dev,
+				"failed to create fsa9480 attribute group\n");
+		goto fail2;
+	}
+
+	/* ADC Detect Time: 500ms */
+	fsa9480_write_reg(client, FSA9480_REG_TIMING1, 0x6);
+
+	if (chip->pdata->reset_cb)
+		chip->pdata->reset_cb();
+
+	/* device detection */
+	fsa9480_detect_dev(usbsw, INT_ATTACH);
+
+	return 0;
+
+fail2:
+	if (client->irq)
+		free_irq(client->irq, NULL);
+fail1:
+	i2c_set_clientdata(client, NULL);
+	kfree(usbsw);
+	return ret;
+}
+
+static int __devexit fsa9480_remove(struct i2c_client *client)
+{
+	struct fsa9480_usbsw *usbsw = i2c_get_clientdata(client);
+	if (client->irq)
+		free_irq(client->irq, NULL);
+	i2c_set_clientdata(client, NULL);
+
+	sysfs_remove_group(&client->dev.kobj, &fsa9480_group);
+	kfree(usbsw);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+
+static int fsa9480_suspend(struct i2c_client *client, pm_message_t state)
+{
+	return 0;
+}
+
+static int fsa9480_resume(struct i2c_client *client)
+{
+	struct fsa9480_usbsw *usbsw = i2c_get_clientdata(client);
+	int dev1, dev2;
+
+	dev1 = fsa9480_read_reg(client, FSA9480_REG_DEV_T1);
+	dev2 = fsa9480_read_reg(client, FSA9480_REG_DEV_T2);
+
+	/* device detection */
+	fsa9480_detect_dev(usbsw, (dev1 || dev2) ? INT_ATTACH : INT_DETACH);
+
+	return 0;
+}
+
+#else
+
+#define fsa9480_suspend NULL
+#define fsa9480_resume NULL
+
+#endif /* CONFIG_PM */
+
+static const struct i2c_device_id fsa9480_id[] = {
+	{"fsa9480", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, fsa9480_id);
+
+static struct i2c_driver fsa9480_i2c_driver = {
+	.driver = {
+		.name = "fsa9480",
+	},
+	.probe = fsa9480_probe,
+	.remove = __devexit_p(fsa9480_remove),
+	.resume = fsa9480_resume,
+	.suspend = fsa9480_suspend,
+	.id_table = fsa9480_id,
+};
+
+static int __init fsa9480_init(void)
+{
+	return i2c_add_driver(&fsa9480_i2c_driver);
+}
+module_init(fsa9480_init);
+
+static void __exit fsa9480_exit(void)
+{
+	i2c_del_driver(&fsa9480_i2c_driver);
+}
+module_exit(fsa9480_exit);
+
+MODULE_AUTHOR("Minkyu Kang <mk7.kang@samsung.com>");
+MODULE_DESCRIPTION("FSA9480 USB Switch driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/fsa9480.h b/include/linux/fsa9480.h
new file mode 100644
index 0000000..5a2c00f
--- /dev/null
+++ b/include/linux/fsa9480.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright (C) 2010 Samsung Electronics
+ * Minkyu Kang <mk7.kang@samsung.com>
+ * Wonguk Jeong <wonguk.jeong@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ */
+
+#ifndef _FSA9480_H_
+#define _FSA9480_H_
+
+#define FSA9480_ATTACHED	1
+#define FSA9480_DETACHED	0
+
+struct fsa9480_platform_data {
+	void (*cfg_gpio) (void);
+	void (*usb_cb) (u8 attached);
+	void (*uart_cb) (u8 attached);
+	void (*charger_cb) (u8 attached);
+	void (*jig_cb) (u8 attached);
+	void (*reset_cb) (void);
+};
+
+void fsa9480_set_switch(const char *buf);
+ssize_t fsa9480_get_switch(char *buf);
+
+#endif /* _FSA9480_H_ */
-- 
1.7.0.4
