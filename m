Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1KXCFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 21:05:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34028 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab1KXCFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 21:05:33 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
Date: Thu, 24 Nov 2011 11:05:31 +0900
X-Google-Sender-Auth: E6THQ4gj4bmivj72fgZIjQB1ciA
Message-ID: <CAJ0PZbSF_iEY0=rSrA+nUEVuPA5Co_XtXZY3gCAXHnfc9VBuhg@mail.gmail.com>
Subject: [RFC PATCH 1/3] Multistate Switch Class: import Android's switch
 class and modify.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, MyungJoo Ham <myungjoo.ham@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multistate switch class is based on and an extension of Android
kernel's switch class located at linux/drivers/switch/.
This patch provides the before-extension switch class moved to the
location where multistate switch class will be located.

The before-extension class, switch class of Android kernel, commits
imported are:

switch: switch class and GPIO drivers.
Author: Mike Lockwood <lockwood@android.com>

switch: gpio: Don't call request_irq with interrupts disabled
Author: Arve Hj첩nnev책g <arve@android.com>

switch: Use device_create instead of device_create_drvdata.
Author: Arve Hj첩nnev책g <arve@android.com>

switch_gpio: Add missing #include <linux/interrupt.h>
Author: Mike Lockwood <lockwood@android.com>

In this patch, upon the commits of Android kernel, we have added:
- Relocated and renamed for multistate switch class
- Comments, module name, and author information are updated
- Code clean for successing patches
- Bugfix: enabling write access without write functions

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/Makefile            |    1 +
 drivers/misc/Kconfig        |   21 +++++
 drivers/misc/Makefile       |    2 +
 drivers/misc/switch_class.c |  183 +++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/switch_gpio.c  |  174 ++++++++++++++++++++++++++++++++++++++++
 include/linux/switch.h      |   77 ++++++++++++++++++
 6 files changed, 458 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/switch_class.c
 create mode 100644 drivers/misc/switch_gpio.c
 create mode 100644 include/linux/switch.h

diff --git a/drivers/Makefile b/drivers/Makefile
index 1b31421..7b042da 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_CPU_IDLE)		+= cpuidle/
 obj-$(CONFIG_MMC)		+= mmc/
 obj-$(CONFIG_MEMSTICK)		+= memstick/
 obj-y				+= leds/
+obj-$(CONFIG_SWITCH)		+= switch/
 obj-$(CONFIG_INFINIBAND)	+= infiniband/
 obj-$(CONFIG_SGI_SN)		+= sn/
 obj-y				+= firmware/
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index d593878..6c3285c 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -499,6 +499,27 @@ config USB_SWITCH_FSA9480
 	  stereo and mono audio, video, microphone and UART data to use
 	  a common connector port.

+menuconfig MULTISTATE_SWITCH
+	tristate "Multistate Switch Class support"
+	help
+	  Say Y here to enable multistate switch class support. This allows
+	  monitoring switches by userspace via sysfs and uevent and supports
+	  switches with multiple states; i.e., a port that may have multiple
+	  external ports attached. For example, a port of a device may
+	  be used to connect an HDMI port and a AC adaptor, and to host USB
+	  ports. Many of 30-pin connectors including PDMI are also good
+	  examples.
+
+if MULTISTATE_SWITCH
+
+config MULTISTATE_SWITCH_GPIO
+	tristate "GPIO Multistate Switch support"
+	depends on GENERIC_GPIO
+	help
+	  Say Y here to enable GPIO based multistate switch support.
+
+endif # MULTISTATE_SWITCH
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index b26495a..1201c17 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -48,3 +48,5 @@ obj-y				+= lis3lv02d/
 obj-y				+= carma/
 obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
 obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
+obj-$(CONFIG_MULTISTATE_SWITCH)		+= switch_class.o
+obj-$(CONFIG_MULTISTATE_SWITCH_GPIO)	+= switch_gpio.o
diff --git a/drivers/misc/switch_class.c b/drivers/misc/switch_class.c
new file mode 100644
index 0000000..b17a4be
--- /dev/null
+++ b/drivers/misc/switch_class.c
@@ -0,0 +1,183 @@
+/*
+ *  drivers/misc/switch_class.c
+ *
+ *  Multistate switch class driver
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
+#include <linux/switch.h>
+
+struct class *switch_class;
+static atomic_t device_count;
+
+static ssize_t state_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct switch_dev *sdev = (struct switch_dev *)
+		dev_get_drvdata(dev);
+
+	if (sdev->print_state) {
+		int ret = sdev->print_state(sdev, buf);
+		if (ret >= 0)
+			return ret;
+	}
+	return sprintf(buf, "%u\n", sdev->state);
+}
+
+static ssize_t name_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct switch_dev *sdev = (struct switch_dev *)
+		dev_get_drvdata(dev);
+
+	if (sdev->print_name) {
+		int ret = sdev->print_name(sdev, buf);
+		if (ret >= 0)
+			return ret;
+	}
+	return sprintf(buf, "%s\n", sdev->name);
+}
+
+static DEVICE_ATTR(state, S_IRUGO, state_show, NULL);
+static DEVICE_ATTR(name, S_IRUGO, name_show, NULL);
+
+void switch_set_state(struct switch_dev *sdev, u32 state)
+{
+	char name_buf[120];
+	char state_buf[120];
+	char *prop_buf;
+	char *envp[3];
+	int env_offset = 0;
+	int length;
+
+	if (sdev->state != state) {
+		sdev->state = state;
+
+		prop_buf = (char *)get_zeroed_page(GFP_KERNEL);
+		if (prop_buf) {
+			length = name_show(sdev->dev, NULL, prop_buf);
+			if (length > 0) {
+				if (prop_buf[length - 1] == '\n')
+					prop_buf[length - 1] = 0;
+				snprintf(name_buf, sizeof(name_buf),
+					"SWITCH_NAME=%s", prop_buf);
+				envp[env_offset++] = name_buf;
+			}
+			length = state_show(sdev->dev, NULL, prop_buf);
+			if (length > 0) {
+				if (prop_buf[length - 1] == '\n')
+					prop_buf[length - 1] = 0;
+				snprintf(state_buf, sizeof(state_buf),
+					"SWITCH_STATE=%s", prop_buf);
+				envp[env_offset++] = state_buf;
+			}
+			envp[env_offset] = NULL;
+			kobject_uevent_env(&sdev->dev->kobj, KOBJ_CHANGE, envp);
+			free_page((unsigned long)prop_buf);
+		} else {
+			printk(KERN_ERR "out of memory in switch_set_state\n");
+			kobject_uevent(&sdev->dev->kobj, KOBJ_CHANGE);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(switch_set_state);
+
+static int create_switch_class(void)
+{
+	if (!switch_class) {
+		switch_class = class_create(THIS_MODULE, "switch");
+		if (IS_ERR(switch_class))
+			return PTR_ERR(switch_class);
+		atomic_set(&device_count, 0);
+	}
+
+	return 0;
+}
+
+int switch_dev_register(struct switch_dev *sdev)
+{
+	int ret;
+
+	if (!switch_class) {
+		ret = create_switch_class();
+		if (ret < 0)
+			return ret;
+	}
+
+	sdev->index = atomic_inc_return(&device_count);
+	sdev->dev = device_create(switch_class, NULL,
+		MKDEV(0, sdev->index), NULL, sdev->name);
+	if (IS_ERR(sdev->dev))
+		return PTR_ERR(sdev->dev);
+
+	ret = device_create_file(sdev->dev, &dev_attr_state);
+	if (ret < 0)
+		goto err_create_file_1;
+	ret = device_create_file(sdev->dev, &dev_attr_name);
+	if (ret < 0)
+		goto err_create_file_2;
+
+	dev_set_drvdata(sdev->dev, sdev);
+	sdev->state = 0;
+	return 0;
+
+err_create_file_2:
+	device_remove_file(sdev->dev, &dev_attr_state);
+err_create_file_1:
+	device_destroy(switch_class, MKDEV(0, sdev->index));
+	printk(KERN_ERR "switch: Failed to register driver %s\n", sdev->name);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(switch_dev_register);
+
+void switch_dev_unregister(struct switch_dev *sdev)
+{
+	device_remove_file(sdev->dev, &dev_attr_name);
+	device_remove_file(sdev->dev, &dev_attr_state);
+	device_destroy(switch_class, MKDEV(0, sdev->index));
+	dev_set_drvdata(sdev->dev, NULL);
+}
+EXPORT_SYMBOL_GPL(switch_dev_unregister);
+
+static int __init switch_class_init(void)
+{
+	return create_switch_class();
+}
+
+static void __exit switch_class_exit(void)
+{
+	class_destroy(switch_class);
+}
+
+module_init(switch_class_init);
+module_exit(switch_class_exit);
+
+MODULE_AUTHOR("Mike Lockwood <lockwood@android.com>");
+MODULE_AUTHOR("Donggeun Kim <dg77.kim@samsung.com>");
+MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
+MODULE_DESCRIPTION("Multistate switch class driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/misc/switch_gpio.c b/drivers/misc/switch_gpio.c
new file mode 100644
index 0000000..ef3c736
--- /dev/null
+++ b/drivers/misc/switch_gpio.c
@@ -0,0 +1,174 @@
+/*
+ *  drivers/misc/switch_gpio.c
+ *
+ *  Single-state GPIO switch driver based on Multistate switch class
+ *
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
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/switch.h>
+#include <linux/workqueue.h>
+#include <linux/gpio.h>
+
+struct gpio_switch_data {
+	struct switch_dev sdev;
+	unsigned gpio;
+	const char *name_on;
+	const char *name_off;
+	const char *state_on;
+	const char *state_off;
+	int irq;
+	struct work_struct work;
+};
+
+static void gpio_switch_work(struct work_struct *work)
+{
+	int state;
+	struct gpio_switch_data	*data =
+		container_of(work, struct gpio_switch_data, work);
+
+	state = gpio_get_value(data->gpio);
+	switch_set_state(&data->sdev, state);
+}
+
+static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
+{
+	struct gpio_switch_data *switch_data =
+	    (struct gpio_switch_data *)dev_id;
+
+	schedule_work(&switch_data->work);
+	return IRQ_HANDLED;
+}
+
+static ssize_t switch_gpio_print_state(struct switch_dev *sdev, char *buf)
+{
+	struct gpio_switch_data	*switch_data =
+		container_of(sdev, struct gpio_switch_data, sdev);
+	const char *state;
+	if (switch_get_state(sdev))
+		state = switch_data->state_on;
+	else
+		state = switch_data->state_off;
+
+	if (state)
+		return sprintf(buf, "%s\n", state);
+	return -1;
+}
+
+static int gpio_switch_probe(struct platform_device *pdev)
+{
+	struct gpio_switch_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_switch_data *switch_data;
+	int ret = 0;
+
+	if (!pdata)
+		return -EBUSY;
+
+	switch_data = kzalloc(sizeof(struct gpio_switch_data), GFP_KERNEL);
+	if (!switch_data)
+		return -ENOMEM;
+
+	switch_data->sdev.name = pdata->name;
+	switch_data->gpio = pdata->gpio;
+	switch_data->name_on = pdata->name_on;
+	switch_data->name_off = pdata->name_off;
+	switch_data->state_on = pdata->state_on;
+	switch_data->state_off = pdata->state_off;
+	switch_data->sdev.print_state = switch_gpio_print_state;
+
+	ret = switch_dev_register(&switch_data->sdev);
+	if (ret < 0)
+		goto err_switch_dev_register;
+
+	ret = gpio_request(switch_data->gpio, pdev->name);
+	if (ret < 0)
+		goto err_request_gpio;
+
+	ret = gpio_direction_input(switch_data->gpio);
+	if (ret < 0)
+		goto err_set_gpio_input;
+
+	INIT_WORK(&switch_data->work, gpio_switch_work);
+
+	switch_data->irq = gpio_to_irq(switch_data->gpio);
+	if (switch_data->irq < 0) {
+		ret = switch_data->irq;
+		goto err_detect_irq_num_failed;
+	}
+
+	ret = request_irq(switch_data->irq, gpio_irq_handler,
+			  IRQF_TRIGGER_LOW, pdev->name, switch_data);
+	if (ret < 0)
+		goto err_request_irq;
+
+	/* Perform initial detection */
+	gpio_switch_work(&switch_data->work);
+
+	return 0;
+
+err_request_irq:
+err_detect_irq_num_failed:
+err_set_gpio_input:
+	gpio_free(switch_data->gpio);
+err_request_gpio:
+	switch_dev_unregister(&switch_data->sdev);
+err_switch_dev_register:
+	kfree(switch_data);
+
+	return ret;
+}
+
+static int __devexit gpio_switch_remove(struct platform_device *pdev)
+{
+	struct gpio_switch_data *switch_data = platform_get_drvdata(pdev);
+
+	cancel_work_sync(&switch_data->work);
+	gpio_free(switch_data->gpio);
+	switch_dev_unregister(&switch_data->sdev);
+	kfree(switch_data);
+
+	return 0;
+}
+
+static struct platform_driver gpio_switch_driver = {
+	.probe		= gpio_switch_probe,
+	.remove		= __devexit_p(gpio_switch_remove),
+	.driver		= {
+		.name	= "switch-gpio",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init gpio_switch_init(void)
+{
+	return platform_driver_register(&gpio_switch_driver);
+}
+
+static void __exit gpio_switch_exit(void)
+{
+	platform_driver_unregister(&gpio_switch_driver);
+}
+
+module_init(gpio_switch_init);
+module_exit(gpio_switch_exit);
+
+MODULE_AUTHOR("Mike Lockwood <lockwood@android.com>");
+MODULE_DESCRIPTION("GPIO Switch driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/switch.h b/include/linux/switch.h
new file mode 100644
index 0000000..a4bddf7
--- /dev/null
+++ b/include/linux/switch.h
@@ -0,0 +1,77 @@
+/*
+ *  Multistate switch class driver
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
+#ifndef __LINUX_SWITCH_H__
+#define __LINUX_SWITCH_H__
+
+struct switch_dev {
+	/* --- User initializing data --- */
+	const char	*name;
+	struct device	*dev;
+
+	/* --- Optional callbacks to override class functions --- */
+	ssize_t	(*print_name)(struct switch_dev *sdev, char *buf);
+	ssize_t	(*print_state)(struct switch_dev *sdev, char *buf);
+
+	/* --- Internal data. Please do not set. --- */
+	u32		state;
+	int		index;
+};
+
+struct gpio_switch_platform_data {
+	const char *name;
+	unsigned gpio;
+
+	/* if NULL, switch_dev.name will be printed */
+	const char *name_on;
+	const char *name_off;
+	/* if NULL, "0" or "1" will be printed */
+	const char *state_on;
+	const char *state_off;
+};
+
+#ifdef CONFIG_MULTISTATE_SWITCH
+extern int switch_dev_register(struct switch_dev *sdev);
+extern void switch_dev_unregister(struct switch_dev *sdev);
+
+static inline u32 switch_get_state(struct switch_dev *sdev)
+{
+	return sdev->state;
+}
+
+extern void switch_set_state(struct switch_dev *sdev, u32 state);
+#else /* CONFIG_MULTISTATE_SWITCH */
+static inline int switch_dev_register(struct switch_dev *sdev)
+{
+	return 0;
+}
+
+static inline void switch_dev_unregister(struct switch_dev *sdev) { }
+
+static inline u32 switch_get_state(struct switch_dev *sdev)
+{
+	return 0;
+}
+
+static inline void switch_set_state(struct switch_dev *sdev, u32 state) { }
+#endif /* CONFIG_MULTISTATE_SWITCH */
+#endif /* __LINUX_SWITCH_H__ */
-- 
1.7.4.1
