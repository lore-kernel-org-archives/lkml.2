Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab1LNK3C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 05:29:02 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24647 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab1LNK2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 05:28:18 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-f5-4ee87a3f8dad
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Mike Lockwood <lockwood@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, MyungJoo Ham <myungjoo.ham@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, NeilBrown <neilb@suse.de>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH v2 1/3] Extcon (external connector): import Android's switch
 class and modify.
Date: Wed, 14 Dec 2011 19:28:26 +0900
Message-id: <1323858508-27198-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1323858508-27198-1-git-send-email-myungjoo.ham@samsung.com>
References: <1323858508-27198-1-git-send-email-myungjoo.ham@samsung.com>
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

External connector class (extcon) is based on and an extension of Android
kernel's switch class located at linux/drivers/switch/.
This patch provides the before-extension switch class moved to the
location where the extcon will be located (linux/drivers/extcon/).

The before-extension class, switch class of Android kernel, commits
imported are:

switch: switch class and GPIO drivers.
Author: Mike Lockwood <lockwood@android.com>

switch: gpio: Don't call request_irq with interrupts disabled
Author: Arve Hjønnevåg <arve@android.com>

switch: Use device_create instead of device_create_drvdata.
Author: Arve Hjønnevåg <arve@android.com>

switch_gpio: Add missing #include <linux/interrupt.h>
Author: Mike Lockwood <lockwood@android.com>

In this patch, upon the commits of Android kernel, we have added:
- Relocated and renamed for extcon.
- Comments, module name, and author information are updated
- Code clean for successing patches
- Bugfix: enabling write access without write functions

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

--
Changes from RFC
- Renamed to extcon (external connector) from multistate switch
- Added a seperated directory (drivers/extcon)
- Added kerneldoc comments
- Removed unused variables from extcon_gpio.c
- Added ABI Documentation.
---
 Documentation/ABI/testing/sysfs-class-extcon |   26 ++++
 drivers/Kconfig                              |    2 +
 drivers/Makefile                             |    1 +
 drivers/extcon/Kconfig                       |   22 +++
 drivers/extcon/Makefile                      |    6 +
 drivers/extcon/extcon_class.c                |  206 ++++++++++++++++++++++++++
 drivers/extcon/extcon_gpio.c                 |  173 +++++++++++++++++++++
 include/linux/extcon.h                       |  101 +++++++++++++
 8 files changed, 537 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-extcon
 create mode 100644 drivers/extcon/Kconfig
 create mode 100644 drivers/extcon/Makefile
 create mode 100644 drivers/extcon/extcon_class.c
 create mode 100644 drivers/extcon/extcon_gpio.c
 create mode 100644 include/linux/extcon.h

diff --git a/Documentation/ABI/testing/sysfs-class-extcon b/Documentation/ABI/testing/sysfs-class-extcon
new file mode 100644
index 0000000..59a4b1c
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-extcon
@@ -0,0 +1,26 @@
+What:		/sys/class/extcon/.../
+Date:		December 2011
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		Provide a place in sysfs for the extcon objects.
+		This allows accessing extcon specific variables.
+		The name of extcon object denoted as ... is the name given
+		with extcon_dev_register.
+
+What:		/sys/class/extcon/.../name
+Date:		December 2011
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/class/extcon/.../name shows the name of the extcon
+		object. If the extcon object has an optional callback
+		"show_name" defined, the callback will provide the name with
+		this sysfs node.
+
+What:		/sys/class/extcon/.../state
+Date:		December 2011
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/class/extcon/.../state shows the cable attach/detach
+		information of the corresponding extcon object. If the extcon
+		objecct has an optional callback "show_state" defined, the
+		callback will provide the name with this sysfs node.
diff --git a/drivers/Kconfig b/drivers/Kconfig
index b5e6f24..da57c81 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -136,4 +136,6 @@ source "drivers/hv/Kconfig"
 
 source "drivers/devfreq/Kconfig"
 
+source "drivers/extcon/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 1b31421..38ed177 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -132,3 +132,4 @@ obj-$(CONFIG_VIRT_DRIVERS)	+= virt/
 obj-$(CONFIG_HYPERV)		+= hv/
 
 obj-$(CONFIG_PM_DEVFREQ)	+= devfreq/
+obj-$(CONFIG_EXTCON)		+= extcon/
diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
new file mode 100644
index 0000000..bedf945
--- /dev/null
+++ b/drivers/extcon/Kconfig
@@ -0,0 +1,22 @@
+menuconfig EXTCON
+	bool "External Connector Class (extcon) support"
+	help
+	  Say Y here to enable external connector class (extcon) support.
+	  This allows monitoring external connectors by userspace
+	  via sysfs and uevent and supports external connectors with
+	  multiple states; i.e., an extcon that may have multiple
+	  cables attached. For example, an external connector of a device
+	  may be used to connect an HDMI cable and a AC adaptor, and to
+	  host USB ports. Many of 30-pin connectors including PDMI are
+	  also good examples.
+
+if EXTCON
+
+config EXTCON_GPIO
+	tristate "GPIO extcon support"
+	depends on GENERIC_GPIO
+	help
+	  Say Y here to enable GPIO based extcon support. Note that GPIO
+	  extcon supports single state per extcon instance.
+
+endif # MULTISTATE_SWITCH
diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
new file mode 100644
index 0000000..2c46d41
--- /dev/null
+++ b/drivers/extcon/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for external connector class (extcon) devices
+#
+
+obj-$(CONFIG_EXTCON)		+= extcon_class.o
+obj-$(CONFIG_EXTCON_GPIO)	+= extcon_gpio.o
diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
new file mode 100644
index 0000000..39fbe9f
--- /dev/null
+++ b/drivers/extcon/extcon_class.c
@@ -0,0 +1,206 @@
+/*
+ *  drivers/extcon/extcon_class.c
+ *
+ *  External connector (extcon) class driver
+ *
+ * Copyright (C) 2011 Samsung Electronics
+ * Author: Donggeun Kim <dg77.kim@samsung.com>
+ * Author: MyungJoo Ham <myungjoo.ham@samsung.com>
+ *
+ * based on android/drivers/switch/switch_class.c
+ * Copyright (C) 2008 Google, Inc.
+ * Author: Mike Lockwood <lockwood@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+*/
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/err.h>
+#include <linux/extcon.h>
+
+struct class *extcon_class;
+static atomic_t device_count;
+
+static ssize_t state_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct extcon_dev *edev = (struct extcon_dev *)
+		dev_get_drvdata(dev);
+
+	if (edev->print_state) {
+		int ret = edev->print_state(edev, buf);
+
+		if (ret >= 0)
+			return ret;
+		/* Use default if failed */
+	}
+	return sprintf(buf, "%u\n", edev->state);
+}
+
+static ssize_t name_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct extcon_dev *edev = (struct extcon_dev *)
+		dev_get_drvdata(dev);
+
+	if (edev->print_name) {
+		int ret = edev->print_name(edev, buf);
+		if (ret >= 0)
+			return ret;
+	}
+	return sprintf(buf, "%s\n", edev->name);
+}
+
+static DEVICE_ATTR(state, S_IRUGO, state_show, NULL);
+static DEVICE_ATTR(name, S_IRUGO, name_show, NULL);
+
+/**
+ * extcon_set_state() - Set the cable attach states of the extcon device.
+ * @edev:	the extcon device
+ * @state:	new cable attach status for @edev
+ */
+void extcon_set_state(struct extcon_dev *edev, u32 state)
+{
+	char name_buf[120];
+	char state_buf[120];
+	char *prop_buf;
+	char *envp[3];
+	int env_offset = 0;
+	int length;
+
+	if (edev->state != state) {
+		edev->state = state;
+
+		prop_buf = (char *)get_zeroed_page(GFP_KERNEL);
+		if (prop_buf) {
+			length = name_show(edev->dev, NULL, prop_buf);
+			if (length > 0) {
+				if (prop_buf[length - 1] == '\n')
+					prop_buf[length - 1] = 0;
+				snprintf(name_buf, sizeof(name_buf),
+					"SWITCH_NAME=%s", prop_buf);
+				envp[env_offset++] = name_buf;
+			}
+			length = state_show(edev->dev, NULL, prop_buf);
+			if (length > 0) {
+				if (prop_buf[length - 1] == '\n')
+					prop_buf[length - 1] = 0;
+				snprintf(state_buf, sizeof(state_buf),
+					"SWITCH_STATE=%s", prop_buf);
+				envp[env_offset++] = state_buf;
+			}
+			envp[env_offset] = NULL;
+			kobject_uevent_env(&edev->dev->kobj, KOBJ_CHANGE, envp);
+			free_page((unsigned long)prop_buf);
+		} else {
+			printk(KERN_ERR "out of memory in extcon_set_state\n");
+			kobject_uevent(&edev->dev->kobj, KOBJ_CHANGE);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(extcon_set_state);
+
+static int create_extcon_class(void)
+{
+	if (!extcon_class) {
+		extcon_class = class_create(THIS_MODULE, "extcon");
+		if (IS_ERR(extcon_class))
+			return PTR_ERR(extcon_class);
+		atomic_set(&device_count, 0);
+	}
+
+	return 0;
+}
+
+/**
+ * extcon_dev_register() - Register a new extcon device
+ * @edev	: the new extcon device (should be allocated before calling)
+ *
+ * Among the members of edev struct, please set the "user initializing data"
+ * in any case and set the "optional callbacks" if required. However, please
+ * do not set the values of "internal data", which are initialized by
+ * this function.
+ */
+int extcon_dev_register(struct extcon_dev *edev)
+{
+	int ret;
+
+	if (!extcon_class) {
+		ret = create_extcon_class();
+		if (ret < 0)
+			return ret;
+	}
+
+	edev->index = atomic_inc_return(&device_count);
+	edev->dev = device_create(extcon_class, NULL,
+		MKDEV(0, edev->index), NULL, edev->name);
+	if (IS_ERR(edev->dev))
+		return PTR_ERR(edev->dev);
+
+	ret = device_create_file(edev->dev, &dev_attr_state);
+	if (ret < 0)
+		goto err_create_file_1;
+	ret = device_create_file(edev->dev, &dev_attr_name);
+	if (ret < 0)
+		goto err_create_file_2;
+
+	dev_set_drvdata(edev->dev, edev);
+	edev->state = 0;
+	return 0;
+
+err_create_file_2:
+	device_remove_file(edev->dev, &dev_attr_state);
+err_create_file_1:
+	device_destroy(extcon_class, MKDEV(0, edev->index));
+	printk(KERN_ERR "extcon: Failed to register driver %s\n", edev->name);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(extcon_dev_register);
+
+/**
+ * extcon_dev_unregister() - Unregister the extcon device.
+ * @edev:	the extcon device instance to be unregitered.
+ *
+ * Note that this does not call kfree(edev) because edev was not allocated
+ * by this class.
+ */
+void extcon_dev_unregister(struct extcon_dev *edev)
+{
+	device_remove_file(edev->dev, &dev_attr_name);
+	device_remove_file(edev->dev, &dev_attr_state);
+	device_destroy(extcon_class, MKDEV(0, edev->index));
+	dev_set_drvdata(edev->dev, NULL);
+}
+EXPORT_SYMBOL_GPL(extcon_dev_unregister);
+
+static int __init extcon_class_init(void)
+{
+	return create_extcon_class();
+}
+
+static void __exit extcon_class_exit(void)
+{
+	class_destroy(extcon_class);
+}
+
+module_init(extcon_class_init);
+module_exit(extcon_class_exit);
+
+MODULE_AUTHOR("Mike Lockwood <lockwood@android.com>");
+MODULE_AUTHOR("Donggeun Kim <dg77.kim@samsung.com>");
+MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
+MODULE_DESCRIPTION("External connector (extcon) class driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/extcon/extcon_gpio.c b/drivers/extcon/extcon_gpio.c
new file mode 100644
index 0000000..88202de
--- /dev/null
+++ b/drivers/extcon/extcon_gpio.c
@@ -0,0 +1,173 @@
+/*
+ *  drivers/extcon/extcon_gpio.c
+ *
+ *  Single-state GPIO extcon driver based on extcon class
+ *
+ * Copyright (C) 2008 Google, Inc.
+ * Author: Mike Lockwood <lockwood@android.com>
+ *
+ * Modified by MyungJoo Ham <myungjoo.ham@samsung.com> to support extcon
+ * (originally switch class is supported)
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+*/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/extcon.h>
+#include <linux/workqueue.h>
+#include <linux/gpio.h>
+
+struct gpio_extcon_data {
+	struct extcon_dev edev;
+	unsigned gpio;
+	const char *state_on;
+	const char *state_off;
+	int irq;
+	struct work_struct work;
+};
+
+static void gpio_extcon_work(struct work_struct *work)
+{
+	int state;
+	struct gpio_extcon_data	*data =
+		container_of(work, struct gpio_extcon_data, work);
+
+	state = gpio_get_value(data->gpio);
+	extcon_set_state(&data->edev, state);
+}
+
+static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
+{
+	struct gpio_extcon_data *extcon_data =
+	    (struct gpio_extcon_data *)dev_id;
+
+	schedule_work(&extcon_data->work);
+	return IRQ_HANDLED;
+}
+
+static ssize_t extcon_gpio_print_state(struct extcon_dev *edev, char *buf)
+{
+	struct gpio_extcon_data	*extcon_data =
+		container_of(edev, struct gpio_extcon_data, edev);
+	const char *state;
+	if (extcon_get_state(edev))
+		state = extcon_data->state_on;
+	else
+		state = extcon_data->state_off;
+
+	if (state)
+		return sprintf(buf, "%s\n", state);
+	return -1;
+}
+
+static int gpio_extcon_probe(struct platform_device *pdev)
+{
+	struct gpio_extcon_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_extcon_data *extcon_data;
+	int ret = 0;
+
+	if (!pdata)
+		return -EBUSY;
+
+	extcon_data = kzalloc(sizeof(struct gpio_extcon_data), GFP_KERNEL);
+	if (!extcon_data)
+		return -ENOMEM;
+
+	extcon_data->edev.name = pdata->name;
+	extcon_data->gpio = pdata->gpio;
+	extcon_data->state_on = pdata->state_on;
+	extcon_data->state_off = pdata->state_off;
+	extcon_data->edev.print_state = extcon_gpio_print_state;
+
+	ret = extcon_dev_register(&extcon_data->edev);
+	if (ret < 0)
+		goto err_extcon_dev_register;
+
+	ret = gpio_request(extcon_data->gpio, pdev->name);
+	if (ret < 0)
+		goto err_request_gpio;
+
+	ret = gpio_direction_input(extcon_data->gpio);
+	if (ret < 0)
+		goto err_set_gpio_input;
+
+	INIT_WORK(&extcon_data->work, gpio_extcon_work);
+
+	extcon_data->irq = gpio_to_irq(extcon_data->gpio);
+	if (extcon_data->irq < 0) {
+		ret = extcon_data->irq;
+		goto err_detect_irq_num_failed;
+	}
+
+	ret = request_irq(extcon_data->irq, gpio_irq_handler,
+			  IRQF_TRIGGER_LOW, pdev->name, extcon_data);
+	if (ret < 0)
+		goto err_request_irq;
+
+	/* Perform initial detection */
+	gpio_extcon_work(&extcon_data->work);
+
+	return 0;
+
+err_request_irq:
+err_detect_irq_num_failed:
+err_set_gpio_input:
+	gpio_free(extcon_data->gpio);
+err_request_gpio:
+	extcon_dev_unregister(&extcon_data->edev);
+err_extcon_dev_register:
+	kfree(extcon_data);
+
+	return ret;
+}
+
+static int __devexit gpio_extcon_remove(struct platform_device *pdev)
+{
+	struct gpio_extcon_data *extcon_data = platform_get_drvdata(pdev);
+
+	cancel_work_sync(&extcon_data->work);
+	gpio_free(extcon_data->gpio);
+	extcon_dev_unregister(&extcon_data->edev);
+	kfree(extcon_data);
+
+	return 0;
+}
+
+static struct platform_driver gpio_extcon_driver = {
+	.probe		= gpio_extcon_probe,
+	.remove		= __devexit_p(gpio_extcon_remove),
+	.driver		= {
+		.name	= "extcon-gpio",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init gpio_extcon_init(void)
+{
+	return platform_driver_register(&gpio_extcon_driver);
+}
+
+static void __exit gpio_extcon_exit(void)
+{
+	platform_driver_unregister(&gpio_extcon_driver);
+}
+
+module_init(gpio_extcon_init);
+module_exit(gpio_extcon_exit);
+
+MODULE_AUTHOR("Mike Lockwood <lockwood@android.com>");
+MODULE_DESCRIPTION("GPIO extcon driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
new file mode 100644
index 0000000..9c92bfb
--- /dev/null
+++ b/include/linux/extcon.h
@@ -0,0 +1,101 @@
+/*
+ *  External connector (extcon) class driver
+ *
+ * Copyright (C) 2011 Samsung Electronics
+ * Author: Donggeun Kim <dg77.kim@samsung.com>
+ * Author: MyungJoo Ham <myungjoo.ham@samsung.com>
+ *
+ * based on switch class driver
+ * Copyright (C) 2008 Google, Inc.
+ * Author: Mike Lockwood <lockwood@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+*/
+
+#ifndef __LINUX_EXTCON_H__
+#define __LINUX_EXTCON_H__
+
+/**
+ * struct extcon_dev - An extcon device represents one external connector.
+ * @name	The name of this extcon device. Please provide one when
+ *		registering an extcon_dev.
+ * @print_name	An optional callback to override the method to print the
+ *		name of the extcon device.
+ * @print_state	An optional callback to override the method to print the
+ *		status of the extcon device.
+ * @dev		Device of this extcon. Do not provide at register-time.
+ * @state	Attach/detach state of this extcon. Do not provide at
+ *		register-time
+ * @index	Device index. Do not provide at register-time.
+ *
+ * In most cases, users only need to provide "User initializing data" of
+ * this struct when registering an extcon. In some exceptional cases,
+ * optional callbacks may be needed. However, the values in "internal data"
+ * are overwritten by register function.
+ */
+struct extcon_dev {
+	/* --- User initializing data --- */
+	const char	*name;
+
+	/* --- Optional callbacks to override class functions --- */
+	ssize_t	(*print_name)(struct extcon_dev *edev, char *buf);
+	ssize_t	(*print_state)(struct extcon_dev *edev, char *buf);
+
+	/* --- Internal data. Please do not set. --- */
+	struct device	*dev;
+	u32		state;
+	int		index;
+};
+
+/**
+ * struct gpio_extcon_platform_data - A simple GPIO-controlled extcon device.
+ * @name	The name of this GPIO extcon device.
+ * @gpio	Corresponding GPIO.
+ * @state_on	print_state is overriden with state_on if attached. If Null,
+ *		default method of extcon class is used.
+ * @state_off	print_state is overriden with state_on if dettached. If Null,
+ *		default method of extcon class is used.
+ */
+struct gpio_extcon_platform_data {
+	const char *name;
+	unsigned gpio;
+
+	/* if NULL, "0" or "1" will be printed */
+	const char *state_on;
+	const char *state_off;
+};
+
+#ifdef CONFIG_EXTCON
+extern int extcon_dev_register(struct extcon_dev *edev);
+extern void extcon_dev_unregister(struct extcon_dev *edev);
+
+static inline u32 extcon_get_state(struct extcon_dev *edev)
+{
+	return edev->state;
+}
+
+extern void extcon_set_state(struct extcon_dev *edev, u32 state);
+#else /* CONFIG_EXTCON */
+static inline int extcon_dev_register(struct extcon_dev *edev)
+{
+	return 0;
+}
+
+static inline void extcon_dev_unregister(struct extcon_dev *edev) { }
+
+static inline u32 extcon_get_state(struct extcon_dev *edev)
+{
+	return 0;
+}
+
+static inline void extcon_set_state(struct extcon_dev *edev, u32 state) { }
+#endif /* CONFIG_EXTCON */
+#endif /* __LINUX_EXTCON_H__ */
-- 
1.7.4.1

