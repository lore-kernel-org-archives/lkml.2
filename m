Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab1EFWJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:09:51 -0400
Received: from mail.atheros.com ([12.19.149.2]:15471 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1EFWJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:09:48 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <akpm@linux-foundation.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
        <hpa@zytor.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <allen.kao@atheros.com>,
        <roman.gezikov@atheros.com>, <joonas.viskari@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 1/2] misc: add Atheros ar1520 GPS support
Date: Fri, 6 May 2011 15:09:39 -0700
Message-ID: <1304719780-27347-2-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.7.4.15.g7811d
In-Reply-To: <1304719780-27347-1-git-send-email-lrodriguez@atheros.com>
References: <1304719780-27347-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Allen Kao <allen.kao@atheros.com>

This adds support for the Atheros ar1520 GPS device.

Cc: Roman Gezikov <roman.gezikov@atheros.com>
Cc: Joonas Viskari <joonas.viskari@atheros.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org
Signed-off-by: Allen Kao <allen.kao@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/misc/Kconfig   |   10 ++
 drivers/misc/Makefile  |    1 +
 drivers/misc/ar1520.c  |  406 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/ar1520.h |   49 ++++++
 4 files changed, 466 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/ar1520.c
 create mode 100644 include/linux/ar1520.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 4e007c6..7108214 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -379,6 +379,16 @@ config HMC6352
 	  This driver provides support for the Honeywell HMC6352 compass,
 	  providing configuration and heading data via sysfs.
 
+config AR1520
+	tristate "Atheros AR1520 support"
+	depends on I2C
+	help
+	  If you say yes here you get support for the Atheros
+	  AR1520 GPS chip.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ar1520. If unsure, say N here.
+
 config EP93XX_PWM
 	tristate "EP93xx PWM support"
 	depends on ARCH_EP93XX
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index f546860..14745ff 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_TI_DAC7512)	+= ti_dac7512.o
 obj-$(CONFIG_C2PORT)		+= c2port/
 obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
 obj-$(CONFIG_HMC6352)		+= hmc6352.o
+obj-$(CONFIG_AR1520)		+= ar1520.o
 obj-y				+= eeprom/
 obj-y				+= cb710/
 obj-$(CONFIG_SPEAR13XX_PCIE_GADGET)	+= spear13xx_pcie_gadget.o
diff --git a/drivers/misc/ar1520.c b/drivers/misc/ar1520.c
new file mode 100644
index 0000000..360eb54
--- /dev/null
+++ b/drivers/misc/ar1520.c
@@ -0,0 +1,406 @@
+/*
+ * ar1520.c: driver for Atheros AR1520 GPS chipset
+ *
+ * Copyright (c) 2011 Atheros Communications Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA  02110-1301, USA.
+ *
+ * I2C code is derived from i2c-dev.c - i2c-bus driver, char device interface
+ * Copyright (C) 1995-97 Simon G. Vogl
+ * Copyright (C) 1998-99 Frodo Looijaard <frodol@dds.nl>
+ * Copyright (C) 2003 Greg Kroah-Hartman <greg@kroah.com>
+ *
+ * GPIO code is derived from tc35894xbg.c: Keypad driver for Toshiba TC35894XBG
+ *
+ * (C) Copyright 2010 Intel Corporation
+ * Author: Charlie Paul (z8cpaul@windriver.com)
+ *
+ * You need a userspace application to cooperate with this driver. It and
+ * more information about this driver can be obtained here:
+ *
+ * http://wireless.kernel.org/en/users/Drivers/ar5120
+ *
+ */
+
+#ifndef __KERNEL__
+#define __KERNEL__
+#endif
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/wait.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/irq.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/cdev.h>
+#include <linux/poll.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/major.h>
+#include <linux/version.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <asm/system.h>
+#include <linux/ar1520.h>
+
+#define DRV_VERSION		"1.0.0.2"
+
+static int driver_major;
+static struct class *ar1520_class;
+static struct ar1520_data *ar1520_data;
+static char empty_data[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
+
+static irqreturn_t ar1520_irq_handler(int irq, void *dev_id)
+{
+	ar1520_data->irq_rx = true;
+	wake_up_interruptible(&ar1520_data->wait_irq);
+
+	return IRQ_HANDLED;
+}
+
+static int ar1520_gpio_init(void)
+{
+	int ret;
+	ret = gpio_request(ar1520_data->gps_gpio_reset, "reset");
+	if (ret < 0) {
+		pr_err("GPIO pin %d request failed, error %d\n",
+			ar1520_data->gps_gpio_reset, ret);
+		return 1;
+	}
+	ret = gpio_direction_output(ar1520_data->gps_gpio_reset, 1);
+	if (ret < 0) {
+		pr_err("GPIO pin %d direction configuration failed, error %d\n",
+			ar1520_data->gps_gpio_reset, ret);
+		goto err_release_gpio_reset;
+	}
+
+	ret = gpio_request(ar1520_data->gps_gpio_wakeup, "wakeup");
+	if (ret < 0) {
+		pr_err("GPIO pin %d request failed, error %d\n",
+			ar1520_data->gps_gpio_wakeup, ret);
+		goto err_release_gpio_reset;
+	}
+
+	ret = gpio_direction_output(ar1520_data->gps_gpio_wakeup, 1);
+	if (ret < 0) {
+		pr_err("GPIO pin %d direction configuration failed, error %d\n",
+			ar1520_data->gps_gpio_wakeup, ret);
+		goto err_release_gpio_wakeup;
+	}
+
+	ret = gpio_request(ar1520_data->gps_gpio_rts, "rts");
+	if (ret < 0) {
+		pr_err("GPIO pin %d request failed, error %d\n",
+			ar1520_data->gps_gpio_rts, ret);
+		goto err_release_gpio_wakeup;
+	}
+
+	ret = gpio_direction_input(ar1520_data->gps_gpio_rts);
+	if (ret < 0) {
+		pr_err("GPIO pin %d direction configuration failed, error %d\n",
+			ar1520_data->gps_gpio_rts, ret);
+		goto err_release_gpio_rts;
+	}
+
+	ret = gpio_to_irq(ar1520_data->gps_gpio_rts);
+	if (ret < 0) {
+		pr_err("GPIO pin %d to IRQ failed, error %d\n",
+			ar1520_data->gps_gpio_rts, ret);
+		goto err_release_gpio_rts;
+	}
+
+	ar1520_data->gps_irq = ret;
+
+	ret = request_threaded_irq(ar1520_data->gps_irq,
+				   NULL,
+				   ar1520_irq_handler,
+				   IRQF_TRIGGER_RISING,
+				   "ar1520_rts",
+				   ar1520_data);
+	if (ret) {
+		pr_err("Could not get GPS_IRQ = %d\n", ar1520_data->gps_irq);
+		goto err_release_irq;
+	}
+
+	return 0;
+
+err_release_irq:
+	free_irq(ar1520_data->gps_irq, ar1520_data);
+err_release_gpio_rts:
+	gpio_free(ar1520_data->gps_gpio_rts);
+err_release_gpio_wakeup:
+	gpio_free(ar1520_data->gps_gpio_wakeup);
+err_release_gpio_reset:
+	gpio_free(ar1520_data->gps_gpio_reset);
+
+	return 1;
+}
+
+static int ar1520_gpio_signal(int gpio)
+{
+	if (!gpio)
+		return 0;
+
+	gpio_set_value(gpio, 0);
+	msleep(100);
+	gpio_set_value(gpio, 1);
+
+	return 0;
+}
+
+static ssize_t ar1520_write(struct file *file,
+			    const char __user *buf,
+			    size_t count,
+			    loff_t *offset)
+{
+	int ret;
+	char *tmp;
+
+	if (count > 8192)
+		count = 8192;
+
+	tmp = memdup_user(buf, count);
+	if (IS_ERR(tmp))
+		return PTR_ERR(tmp);
+
+	ret = i2c_master_send(ar1520_data->i2c_client, tmp, count);
+	if (ret < 0) {
+		dev_err(&ar1520_data->i2c_client->dev, "send error: %d\n", ret);
+		return ret;
+	}
+
+	kfree(tmp);
+
+	return ret;
+}
+
+static ssize_t ar1520_read(struct file *file,
+			   char __user *buf,
+			   size_t count,
+			   loff_t *offset)
+{
+	char *tmp;
+	int ret = 0;
+
+	if (count > 8192)
+		count = 8192;
+
+	tmp = kmalloc(count, GFP_KERNEL);
+	if (tmp == NULL)
+		return -ENOMEM;
+
+	ret = i2c_master_recv(ar1520_data->i2c_client, tmp, count);
+	if (ret < 0)
+		goto out;
+
+	if (memcmp(tmp, empty_data, 10) != 0)
+		goto get_data;
+
+	/*
+	 * no data was available from the device, if we were blocked, wait
+	 * until we get an IRQ and then try again.
+	 */
+
+	if (ar1520_data->blocking) {
+		long time;
+
+		time = wait_event_interruptible_timeout(ar1520_data->wait_irq,
+							ar1520_data->irq_rx,
+							msecs_to_jiffies(3142));
+		if (!time) {
+			ret = -ETIMEDOUT;
+			goto out;
+		}
+
+		ar1520_data->irq_rx = false;
+
+		ret = i2c_master_recv(ar1520_data->i2c_client, tmp, count);
+		if (ret < 0)
+			goto out;
+	}
+
+get_data:
+	ret = copy_to_user(buf, tmp, count) ? -EFAULT : ret;
+out:
+	kfree(tmp);
+	return ret;
+}
+
+
+static int ar1520_open(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static void ar1520_update_blocking(unsigned long arg)
+{
+	struct ar1520_ioctl_t ar1520_ioctl_pl;
+
+	memset(&ar1520_ioctl_pl, 0, sizeof(struct ar1520_ioctl_t));
+	copy_from_user(&ar1520_ioctl_pl, (void __user *) arg,
+		       sizeof(struct ar1520_ioctl_t));
+	ar1520_data->blocking = !!ar1520_ioctl_pl.enable_blocking;
+}
+
+static long ar1520_ioctl(struct file *filep,
+			 unsigned int cmd,
+			 unsigned long arg)
+{
+	int err = 0;
+
+	if (_IOC_TYPE(cmd) != AR1520_IOCTL_MAGIC)
+		return -ENOTTY;
+	if (_IOC_NR(cmd) > AR1520_IOCTL_MAXNR)
+		return -ENOTTY;
+	if (_IOC_DIR(cmd) & _IOC_READ)
+		err = !access_ok(VERIFY_WRITE,
+			(void __user *)arg, _IOC_SIZE(cmd));
+	else if (_IOC_DIR(cmd) & _IOC_WRITE)
+		err = !access_ok(VERIFY_READ,
+			(void __user *)arg, _IOC_SIZE(cmd));
+
+	if (err)
+		return -EFAULT;
+
+	switch (cmd) {
+	case AR1520_IOCTL_RESET:
+		ar1520_gpio_signal(ar1520_data->gps_gpio_reset);
+		break;
+	case AR1520_IOCTL_WAKEUP:
+		ar1520_gpio_signal(ar1520_data->gps_gpio_wakeup);
+		break;
+	case AR1520_IOCTL_BLOCKING:
+		ar1520_update_blocking(arg);
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+static const struct file_operations ar1520_fops = {
+	.owner		= THIS_MODULE,
+	.read		= ar1520_read,
+	.write		= ar1520_write,
+	.open		= ar1520_open,
+	.unlocked_ioctl = ar1520_ioctl,
+};
+
+static struct i2c_driver ar1520_driver;
+
+static int __init ar1520_probe(struct i2c_client *client,
+			       const struct i2c_device_id *id)
+{
+	struct ar1520_platform_data *pdata;
+
+	pdata = client->dev.platform_data;
+	if (!pdata) {
+		dev_err(&client->dev, "no platform data\n");
+		return -ENODEV;
+	}
+
+	ar1520_data = kzalloc(sizeof(struct ar1520_data), GFP_KERNEL);
+	if (!ar1520_data) {
+		dev_err(&client->dev,
+			"could not allocate AR1520 device\n");
+		return -ENOMEM;
+	}
+
+	ar1520_data->i2c_client = client;
+
+	ar1520_data->gps_gpio_reset = pdata->gps_gpio_reset;
+	ar1520_data->gps_gpio_wakeup = pdata->gps_gpio_wakeup;
+	ar1520_data->gps_gpio_rts = pdata->gps_gpio_rts;
+
+	i2c_set_clientdata(client, ar1520_data);
+
+	init_waitqueue_head(&ar1520_data->wait_irq);
+
+	ar1520_gpio_init();
+
+	return 0;
+}
+
+static int ar1520_remove(struct i2c_client *client)
+{
+	wake_up_interruptible(&ar1520_data->wait_irq);
+
+	free_irq(ar1520_data->gps_irq, ar1520_data);
+
+	gpio_free(ar1520_data->gps_gpio_rts);
+	gpio_free(ar1520_data->gps_gpio_wakeup);
+	gpio_free(ar1520_data->gps_gpio_reset);
+
+	return 0;
+}
+
+static const struct i2c_device_id ar1520_id[] = {
+	{ "ath1520a", 0 },
+	{ }
+};
+
+static struct i2c_driver ar1520_driver = {
+	.driver = {
+		.name	= "ath1520a",
+		.owner  = THIS_MODULE,
+	},
+	.probe		= ar1520_probe,
+	.remove		= ar1520_remove,
+	.id_table	= ar1520_id,
+};
+
+static int __init ar1520_init(void)
+{
+	driver_major = register_chrdev(0, AR1520_DEV, &ar1520_fops);
+	if (driver_major < 0) {
+		pr_err("Register character device failed\n");
+		return -EFAULT;
+	}
+
+	ar1520_class = class_create(THIS_MODULE, AR1520_DEV);
+	if (IS_ERR(ar1520_class))
+		return -EFAULT;
+
+	device_create(ar1520_class, NULL, MKDEV(driver_major, 0),
+		      NULL, AR1520_DEV);
+
+	pr_info("ar1520 v.%s", DRV_VERSION);
+	i2c_add_driver(&ar1520_driver);
+
+	return 0;
+}
+
+static void __exit ar1520_exit(void)
+{
+	i2c_del_driver(&ar1520_driver);
+	unregister_chrdev(driver_major, AR1520_DEV);
+	device_destroy(ar1520_class, MKDEV(driver_major, 0));
+	class_destroy(ar1520_class);
+}
+
+module_init(ar1520_init);
+module_exit(ar1520_exit);
+
+MODULE_AUTHOR("Allen Kao <allen.kao@atheros.com>");
+MODULE_DESCRIPTION("Atheros AR1520a driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
diff --git a/include/linux/ar1520.h b/include/linux/ar1520.h
new file mode 100644
index 0000000..08a9529
--- /dev/null
+++ b/include/linux/ar1520.h
@@ -0,0 +1,49 @@
+/*
+* Copyright (c) 2011 Atheros Communications Inc.
+*
+* Permission to use, copy, modify, and/or distribute this software for any
+* purpose with or without fee is hereby granted, provided that the above
+* copyright notice and this permission notice appear in all copies.
+*
+* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+* ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+* ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+* OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+*/
+
+
+#ifndef LINUX_AR1520_H
+#define LINUX_AR1520_H
+
+struct ar1520_platform_data {
+	int gps_gpio_rts;
+	int gps_gpio_wakeup;
+	int gps_gpio_reset;
+};
+
+struct ar1520_data {
+	int gps_gpio_rts;
+	int gps_gpio_wakeup;
+	int gps_gpio_reset;
+	unsigned int gps_irq;
+	struct i2c_client *i2c_client;
+	bool irq_rx;
+	bool blocking;
+	wait_queue_head_t wait_irq;
+};
+
+struct ar1520_ioctl_t {
+	__u32 enable_blocking;
+};
+
+#define AR1520_DEV              "ar1520"
+#define AR1520_IOCTL_MAGIC      0xc2
+#define AR1520_IOCTL_MAXNR      3
+#define AR1520_IOCTL_RESET	_IO(AR1520_IOCTL_MAGIC, 1)
+#define AR1520_IOCTL_WAKEUP	_IO(AR1520_IOCTL_MAGIC, 2)
+#define AR1520_IOCTL_BLOCKING	\
+	_IOW(AR1520_IOCTL_MAGIC, 3, struct ar1520_ioctl_t)
+#endif
-- 
1.7.4.15.g7811d

