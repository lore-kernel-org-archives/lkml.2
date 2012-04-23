Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab2DWLTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:19:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38087 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab2DWLTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:19:52 -0400
X-AuditID: cbfee61b-b7cb4ae000000d81-e7-4f953ad67c52
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, cw00.choi@samsung.com,
        myungjoo.ham@gmail.com, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Remove "switch" class in drivers/staging/android/switch
Date: Mon, 23 Apr 2012 20:19:57 +0900
Message-id: <1335179997-9911-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <CAJ0PZbQu6NCo=nYWr_D3yMF5ypaz_SDr6mFWxyN04VO13VmW=Q@mail.gmail.com>
References: <CAJ0PZbQu6NCo=nYWr_D3yMF5ypaz_SDr6mFWxyN04VO13VmW=Q@mail.gmail.com>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because extcon can also be a switch class for legacy userspace (Android)
and is a superset of switch class in drivers/staging/android/switch,
switch class may be removed.

- Remove switch class
- Remove switch class consideration in extcon class

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/extcon/extcon_class.c                 |   12 +-
 drivers/staging/android/Kconfig               |    3 -
 drivers/staging/android/Makefile              |    1 -
 drivers/staging/android/switch/Kconfig        |   11 --
 drivers/staging/android/switch/Makefile       |    4 -
 drivers/staging/android/switch/switch.h       |   53 --------
 drivers/staging/android/switch/switch_class.c |  174 -------------------------
 drivers/staging/android/switch/switch_gpio.c  |  172 ------------------------
 8 files changed, 6 insertions(+), 424 deletions(-)
 delete mode 100644 drivers/staging/android/switch/Kconfig
 delete mode 100644 drivers/staging/android/switch/Makefile
 delete mode 100644 drivers/staging/android/switch/switch.h
 delete mode 100644 drivers/staging/android/switch/switch_class.c
 delete mode 100644 drivers/staging/android/switch/switch_gpio.c

diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
index 3bc4b8a..dbd3bfb 100644
--- a/drivers/extcon/extcon_class.c
+++ b/drivers/extcon/extcon_class.c
@@ -65,9 +65,9 @@ const char *extcon_cable_name[] = {
 };
 
 struct class *extcon_class;
-#if defined(CONFIG_ANDROID) && !defined(CONFIG_ANDROID_SWITCH)
+#if defined(CONFIG_ANDROID)
 static struct class_compat *switch_class;
-#endif /* CONFIG_ANDROID && !defined(CONFIG_ANDROID_SWITCH) */
+#endif /* CONFIG_ANDROID */
 
 static LIST_HEAD(extcon_dev_list);
 static DEFINE_MUTEX(extcon_dev_list_lock);
@@ -532,11 +532,11 @@ static int create_extcon_class(void)
 			return PTR_ERR(extcon_class);
 		extcon_class->dev_attrs = extcon_attrs;
 
-#if defined(CONFIG_ANDROID) && !defined(CONFIG_ANDROID_SWITCH)
+#if defined(CONFIG_ANDROID)
 		switch_class = class_compat_register("switch");
 		if (WARN(!switch_class, "cannot allocate"))
 			return -ENOMEM;
-#endif /* CONFIG_ANDROID && !defined(CONFIG_ANDROID_SWITCH) */
+#endif /* CONFIG_ANDROID */
 	}
 
 	return 0;
@@ -749,11 +749,11 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 		put_device(edev->dev);
 		goto err_dev;
 	}
-#if defined(CONFIG_ANDROID) && !defined(CONFIG_ANDROID_SWITCH)
+#if defined(CONFIG_ANDROID)
 	if (switch_class)
 		ret = class_compat_create_link(switch_class, edev->dev,
 					       dev);
-#endif /* CONFIG_ANDROID && !defined(CONFIG_ANDROID_SWITCH) */
+#endif /* CONFIG_ANDROID */
 
 	spin_lock_init(&edev->lock);
 
diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index eb1dee2..c706635 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -53,8 +53,6 @@ config ANDROID_LOW_MEMORY_KILLER
 	---help---
 	  Register processes to be killed when memory is low
 
-source "drivers/staging/android/switch/Kconfig"
-
 config ANDROID_INTF_ALARM
 	bool "Android alarm driver"
 	depends on RTC_CLASS
@@ -80,7 +78,6 @@ config ANDROID_ALARM_OLDDRV_COMPAT
 	  Provides preprocessor alias to aid compatability with
 	  older out-of-tree drivers that use the Android Alarm
 	  in-kernel API. This will be removed eventually.
-
 endif # if ANDROID
 
 endmenu
diff --git a/drivers/staging/android/Makefile b/drivers/staging/android/Makefile
index 9b6c9ed..045d17b 100644
--- a/drivers/staging/android/Makefile
+++ b/drivers/staging/android/Makefile
@@ -6,6 +6,5 @@ obj-$(CONFIG_ANDROID_RAM_CONSOLE)	+= ram_console.o
 obj-$(CONFIG_ANDROID_TIMED_OUTPUT)	+= timed_output.o
 obj-$(CONFIG_ANDROID_TIMED_GPIO)	+= timed_gpio.o
 obj-$(CONFIG_ANDROID_LOW_MEMORY_KILLER)	+= lowmemorykiller.o
-obj-$(CONFIG_ANDROID_SWITCH)		+= switch/
 obj-$(CONFIG_ANDROID_INTF_ALARM)	+= alarm.o
 obj-$(CONFIG_ANDROID_INTF_ALARM_DEV)	+= alarm-dev.o
diff --git a/drivers/staging/android/switch/Kconfig b/drivers/staging/android/switch/Kconfig
deleted file mode 100644
index 36846f6..0000000
--- a/drivers/staging/android/switch/Kconfig
+++ /dev/null
@@ -1,11 +0,0 @@
-menuconfig ANDROID_SWITCH
-	tristate "Android Switch class support"
-	help
-	  Say Y here to enable Android switch class support. This allows
-	  monitoring switches by userspace via sysfs and uevent.
-
-config ANDROID_SWITCH_GPIO
-	tristate "Android GPIO Switch support"
-	depends on GENERIC_GPIO && ANDROID_SWITCH
-	help
-	  Say Y here to enable GPIO based switch support.
diff --git a/drivers/staging/android/switch/Makefile b/drivers/staging/android/switch/Makefile
deleted file mode 100644
index d76bfdc..0000000
--- a/drivers/staging/android/switch/Makefile
+++ /dev/null
@@ -1,4 +0,0 @@
-# Android Switch Class Driver
-obj-$(CONFIG_ANDROID_SWITCH)		+= switch_class.o
-obj-$(CONFIG_ANDROID_SWITCH_GPIO)	+= switch_gpio.o
-
diff --git a/drivers/staging/android/switch/switch.h b/drivers/staging/android/switch/switch.h
deleted file mode 100644
index 4fcb310..0000000
--- a/drivers/staging/android/switch/switch.h
+++ /dev/null
@@ -1,53 +0,0 @@
-/*
- *  Switch class driver
- *
- * Copyright (C) 2008 Google, Inc.
- * Author: Mike Lockwood <lockwood@android.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
-*/
-
-#ifndef __LINUX_SWITCH_H__
-#define __LINUX_SWITCH_H__
-
-struct switch_dev {
-	const char	*name;
-	struct device	*dev;
-	int		index;
-	int		state;
-
-	ssize_t	(*print_name)(struct switch_dev *sdev, char *buf);
-	ssize_t	(*print_state)(struct switch_dev *sdev, char *buf);
-};
-
-struct gpio_switch_platform_data {
-	const char *name;
-	unsigned	gpio;
-
-	/* if NULL, switch_dev.name will be printed */
-	const char *name_on;
-	const char *name_off;
-	/* if NULL, "0" or "1" will be printed */
-	const char *state_on;
-	const char *state_off;
-};
-
-extern int switch_dev_register(struct switch_dev *sdev);
-extern void switch_dev_unregister(struct switch_dev *sdev);
-
-static inline int switch_get_state(struct switch_dev *sdev)
-{
-	return sdev->state;
-}
-
-extern void switch_set_state(struct switch_dev *sdev, int state);
-
-#endif /* __LINUX_SWITCH_H__ */
diff --git a/drivers/staging/android/switch/switch_class.c b/drivers/staging/android/switch/switch_class.c
deleted file mode 100644
index 7468044..0000000
--- a/drivers/staging/android/switch/switch_class.c
+++ /dev/null
@@ -1,174 +0,0 @@
-/*
- * switch_class.c
- *
- * Copyright (C) 2008 Google, Inc.
- * Author: Mike Lockwood <lockwood@android.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
-*/
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/device.h>
-#include <linux/fs.h>
-#include <linux/err.h>
-#include "switch.h"
-
-struct class *switch_class;
-static atomic_t device_count;
-
-static ssize_t state_show(struct device *dev, struct device_attribute *attr,
-		char *buf)
-{
-	struct switch_dev *sdev = (struct switch_dev *)
-		dev_get_drvdata(dev);
-
-	if (sdev->print_state) {
-		int ret = sdev->print_state(sdev, buf);
-		if (ret >= 0)
-			return ret;
-	}
-	return sprintf(buf, "%d\n", sdev->state);
-}
-
-static ssize_t name_show(struct device *dev, struct device_attribute *attr,
-		char *buf)
-{
-	struct switch_dev *sdev = (struct switch_dev *)
-		dev_get_drvdata(dev);
-
-	if (sdev->print_name) {
-		int ret = sdev->print_name(sdev, buf);
-		if (ret >= 0)
-			return ret;
-	}
-	return sprintf(buf, "%s\n", sdev->name);
-}
-
-static DEVICE_ATTR(state, S_IRUGO | S_IWUSR, state_show, NULL);
-static DEVICE_ATTR(name, S_IRUGO | S_IWUSR, name_show, NULL);
-
-void switch_set_state(struct switch_dev *sdev, int state)
-{
-	char name_buf[120];
-	char state_buf[120];
-	char *prop_buf;
-	char *envp[3];
-	int env_offset = 0;
-	int length;
-
-	if (sdev->state != state) {
-		sdev->state = state;
-
-		prop_buf = (char *)get_zeroed_page(GFP_KERNEL);
-		if (prop_buf) {
-			length = name_show(sdev->dev, NULL, prop_buf);
-			if (length > 0) {
-				if (prop_buf[length - 1] == '\n')
-					prop_buf[length - 1] = 0;
-				snprintf(name_buf, sizeof(name_buf),
-					"SWITCH_NAME=%s", prop_buf);
-				envp[env_offset++] = name_buf;
-			}
-			length = state_show(sdev->dev, NULL, prop_buf);
-			if (length > 0) {
-				if (prop_buf[length - 1] == '\n')
-					prop_buf[length - 1] = 0;
-				snprintf(state_buf, sizeof(state_buf),
-					"SWITCH_STATE=%s", prop_buf);
-				envp[env_offset++] = state_buf;
-			}
-			envp[env_offset] = NULL;
-			kobject_uevent_env(&sdev->dev->kobj, KOBJ_CHANGE, envp);
-			free_page((unsigned long)prop_buf);
-		} else {
-			printk(KERN_ERR "out of memory in switch_set_state\n");
-			kobject_uevent(&sdev->dev->kobj, KOBJ_CHANGE);
-		}
-	}
-}
-EXPORT_SYMBOL_GPL(switch_set_state);
-
-static int create_switch_class(void)
-{
-	if (!switch_class) {
-		switch_class = class_create(THIS_MODULE, "switch");
-		if (IS_ERR(switch_class))
-			return PTR_ERR(switch_class);
-		atomic_set(&device_count, 0);
-	}
-
-	return 0;
-}
-
-int switch_dev_register(struct switch_dev *sdev)
-{
-	int ret;
-
-	if (!switch_class) {
-		ret = create_switch_class();
-		if (ret < 0)
-			return ret;
-	}
-
-	sdev->index = atomic_inc_return(&device_count);
-	sdev->dev = device_create(switch_class, NULL,
-		MKDEV(0, sdev->index), NULL, sdev->name);
-	if (IS_ERR(sdev->dev))
-		return PTR_ERR(sdev->dev);
-
-	ret = device_create_file(sdev->dev, &dev_attr_state);
-	if (ret < 0)
-		goto err_create_file_1;
-	ret = device_create_file(sdev->dev, &dev_attr_name);
-	if (ret < 0)
-		goto err_create_file_2;
-
-	dev_set_drvdata(sdev->dev, sdev);
-	sdev->state = 0;
-	return 0;
-
-err_create_file_2:
-	device_remove_file(sdev->dev, &dev_attr_state);
-err_create_file_1:
-	device_destroy(switch_class, MKDEV(0, sdev->index));
-	printk(KERN_ERR "switch: Failed to register driver %s\n", sdev->name);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(switch_dev_register);
-
-void switch_dev_unregister(struct switch_dev *sdev)
-{
-	device_remove_file(sdev->dev, &dev_attr_name);
-	device_remove_file(sdev->dev, &dev_attr_state);
-	device_destroy(switch_class, MKDEV(0, sdev->index));
-	dev_set_drvdata(sdev->dev, NULL);
-}
-EXPORT_SYMBOL_GPL(switch_dev_unregister);
-
-static int __init switch_class_init(void)
-{
-	return create_switch_class();
-}
-
-static void __exit switch_class_exit(void)
-{
-	class_destroy(switch_class);
-}
-
-module_init(switch_class_init);
-module_exit(switch_class_exit);
-
-MODULE_AUTHOR("Mike Lockwood <lockwood@android.com>");
-MODULE_DESCRIPTION("Switch class driver");
-MODULE_LICENSE("GPL");
diff --git a/drivers/staging/android/switch/switch_gpio.c b/drivers/staging/android/switch/switch_gpio.c
deleted file mode 100644
index 38b2c2f..0000000
--- a/drivers/staging/android/switch/switch_gpio.c
+++ /dev/null
@@ -1,172 +0,0 @@
-/*
- * switch_gpio.c
- *
- * Copyright (C) 2008 Google, Inc.
- * Author: Mike Lockwood <lockwood@android.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
-*/
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/platform_device.h>
-#include <linux/slab.h>
-#include <linux/workqueue.h>
-#include <linux/gpio.h>
-#include "switch.h"
-
-struct gpio_switch_data {
-	struct switch_dev sdev;
-	unsigned gpio;
-	const char *name_on;
-	const char *name_off;
-	const char *state_on;
-	const char *state_off;
-	int irq;
-	struct work_struct work;
-};
-
-static void gpio_switch_work(struct work_struct *work)
-{
-	int state;
-	struct gpio_switch_data	*data =
-		container_of(work, struct gpio_switch_data, work);
-
-	state = gpio_get_value(data->gpio);
-	switch_set_state(&data->sdev, state);
-}
-
-static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
-{
-	struct gpio_switch_data *switch_data =
-	    (struct gpio_switch_data *)dev_id;
-
-	schedule_work(&switch_data->work);
-	return IRQ_HANDLED;
-}
-
-static ssize_t switch_gpio_print_state(struct switch_dev *sdev, char *buf)
-{
-	struct gpio_switch_data	*switch_data =
-		container_of(sdev, struct gpio_switch_data, sdev);
-	const char *state;
-	if (switch_get_state(sdev))
-		state = switch_data->state_on;
-	else
-		state = switch_data->state_off;
-
-	if (state)
-		return sprintf(buf, "%s\n", state);
-	return -1;
-}
-
-static int gpio_switch_probe(struct platform_device *pdev)
-{
-	struct gpio_switch_platform_data *pdata = pdev->dev.platform_data;
-	struct gpio_switch_data *switch_data;
-	int ret = 0;
-
-	if (!pdata)
-		return -EBUSY;
-
-	switch_data = kzalloc(sizeof(struct gpio_switch_data), GFP_KERNEL);
-	if (!switch_data)
-		return -ENOMEM;
-
-	switch_data->sdev.name = pdata->name;
-	switch_data->gpio = pdata->gpio;
-	switch_data->name_on = pdata->name_on;
-	switch_data->name_off = pdata->name_off;
-	switch_data->state_on = pdata->state_on;
-	switch_data->state_off = pdata->state_off;
-	switch_data->sdev.print_state = switch_gpio_print_state;
-
-	ret = switch_dev_register(&switch_data->sdev);
-	if (ret < 0)
-		goto err_switch_dev_register;
-
-	ret = gpio_request(switch_data->gpio, pdev->name);
-	if (ret < 0)
-		goto err_request_gpio;
-
-	ret = gpio_direction_input(switch_data->gpio);
-	if (ret < 0)
-		goto err_set_gpio_input;
-
-	INIT_WORK(&switch_data->work, gpio_switch_work);
-
-	switch_data->irq = gpio_to_irq(switch_data->gpio);
-	if (switch_data->irq < 0) {
-		ret = switch_data->irq;
-		goto err_detect_irq_num_failed;
-	}
-
-	ret = request_irq(switch_data->irq, gpio_irq_handler,
-			  IRQF_TRIGGER_LOW, pdev->name, switch_data);
-	if (ret < 0)
-		goto err_request_irq;
-
-	/* Perform initial detection */
-	gpio_switch_work(&switch_data->work);
-
-	return 0;
-
-err_request_irq:
-err_detect_irq_num_failed:
-err_set_gpio_input:
-	gpio_free(switch_data->gpio);
-err_request_gpio:
-	switch_dev_unregister(&switch_data->sdev);
-err_switch_dev_register:
-	kfree(switch_data);
-
-	return ret;
-}
-
-static int __devexit gpio_switch_remove(struct platform_device *pdev)
-{
-	struct gpio_switch_data *switch_data = platform_get_drvdata(pdev);
-
-	cancel_work_sync(&switch_data->work);
-	gpio_free(switch_data->gpio);
-	switch_dev_unregister(&switch_data->sdev);
-	kfree(switch_data);
-
-	return 0;
-}
-
-static struct platform_driver gpio_switch_driver = {
-	.probe		= gpio_switch_probe,
-	.remove		= __devexit_p(gpio_switch_remove),
-	.driver		= {
-		.name	= "switch-gpio",
-		.owner	= THIS_MODULE,
-	},
-};
-
-static int __init gpio_switch_init(void)
-{
-	return platform_driver_register(&gpio_switch_driver);
-}
-
-static void __exit gpio_switch_exit(void)
-{
-	platform_driver_unregister(&gpio_switch_driver);
-}
-
-module_init(gpio_switch_init);
-module_exit(gpio_switch_exit);
-
-MODULE_AUTHOR("Mike Lockwood <lockwood@android.com>");
-MODULE_DESCRIPTION("GPIO Switch driver");
-MODULE_LICENSE("GPL");
-- 
1.7.4.1

