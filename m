Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2B0MQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 07:16:26 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47239 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab2B0MPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 07:15:35 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7b78ae000001ceb-1e-4f4b73e3c0d8
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: NeilBrown <neilb@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, gregkh@linuxfoundation.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com
Subject: [PATCH v6 1/5] Extcon (external connector): import Android's switch
 class and modify.
Date: Mon, 27 Feb 2012 21:15:35 +0900
Message-id: <1330344939-18394-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
References: <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
 <1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

External connector class (extcon) is based on and an extension of
Android kernel's switch class located at linux/drivers/switch/.

This patch provides the before-extension switch class moved to the
location where the extcon will be located (linux/drivers/extcon/) and
updates to handle class properly.

The before-extension class, switch class of Android kernel, commits
imported are:

switch: switch class and GPIO drivers. (splitted)
Author: Mike Lockwood <lockwood@android.com>

switch: Use device_create instead of device_create_drvdata.
Author: Arve Hjønnevåg <arve@android.com>

In this patch, upon the commits of Android kernel, we have added:
- Relocated and renamed for extcon.
- Comments, module name, and author information are updated
- Code clean for successing patches
- Bugfix: enabling write access without write functions
- Class/device/sysfs create/remove handling
- Added comments about uevents
- Format changes for extcon_dev_register() to have a parent dev.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

--
Changes from v5
- Split the patch
- Style fixes
- "Android-compatible" mode is enabled by Kconfig option.

Changes from v2
- Updated name_show
- Sysfs entries are handled by class itself.
- Updated the method to add/remove devices for the class
- Comments on uevent send
- Able to become a module
- Compatible with Android platform

Changes from RFC
- Renamed to extcon (external connector) from multistate switch
- Added a seperated directory (drivers/extcon)
- Added kerneldoc comments
- Removed unused variables from extcon_gpio.c
- Added ABI Documentation.
---
 Documentation/ABI/testing/sysfs-class-extcon |   26 +++
 drivers/Kconfig                              |    2 +
 drivers/Makefile                             |    1 +
 drivers/extcon/Kconfig                       |   28 ++++
 drivers/extcon/Makefile                      |    5 +
 drivers/extcon/extcon_class.c                |  226 ++++++++++++++++++++++++++
 include/linux/extcon.h                       |   82 ++++++++++
 7 files changed, 370 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-extcon
 create mode 100644 drivers/extcon/Kconfig
 create mode 100644 drivers/extcon/Makefile
 create mode 100644 drivers/extcon/extcon_class.c
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
index 5afe5d1..537d126 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -136,4 +136,6 @@ source "drivers/virt/Kconfig"
 
 source "drivers/devfreq/Kconfig"
 
+source "drivers/extcon/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index c07be02..6faceab 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -132,3 +132,4 @@ obj-$(CONFIG_VIRT_DRIVERS)	+= virt/
 obj-$(CONFIG_HYPERV)		+= hv/
 
 obj-$(CONFIG_PM_DEVFREQ)	+= devfreq/
+obj-$(CONFIG_EXTCON)		+= extcon/
diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
new file mode 100644
index 0000000..11db865
--- /dev/null
+++ b/drivers/extcon/Kconfig
@@ -0,0 +1,28 @@
+menuconfig EXTCON
+	tristate "External Connector Class (extcon) support"
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
+comment "Extcon Class Configuration"
+
+config EXTCON_ANDROID_COMPATIBLE
+	bool "Class name uses 'switch' to be compatible with Android kernel"
+	depends on ANDROID
+	help
+	  The class name of extcon device drivers are set 'switch' in order
+	  to be compatible with Android kernel switch framework. With this
+	  option enabled, Android userspace platform may use extcon device
+	  drivers as if they are switch device drivers.
+
+comment "Extcon Device Drivers"
+
+endif # MULTISTATE_SWITCH
diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
new file mode 100644
index 0000000..6bc6921
--- /dev/null
+++ b/drivers/extcon/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for external connector class (extcon) devices
+#
+
+obj-$(CONFIG_EXTCON)		+= extcon_class.o
diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
new file mode 100644
index 0000000..9bc062b
--- /dev/null
+++ b/drivers/extcon/extcon_class.c
@@ -0,0 +1,226 @@
+/*
+ *  drivers/extcon/extcon_class.c
+ *
+ *  External connector (extcon) class driver
+ *
+ * Copyright (C) 2012 Samsung Electronics
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
+#include <linux/slab.h>
+
+struct class *extcon_class;
+
+static ssize_t state_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
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
+	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
+
+	/* Optional callback given by the user */
+	if (edev->print_name) {
+		int ret = edev->print_name(edev, buf);
+		if (ret >= 0)
+			return ret;
+	}
+
+	return sprintf(buf, "%s\n", dev_name(edev->dev));
+}
+
+/**
+ * extcon_set_state() - Set the cable attach states of the extcon device.
+ * @edev:	the extcon device
+ * @state:	new cable attach status for @edev
+ *
+ * Changing the state sends uevent with environment variable containing
+ * the name of extcon device (envp[0]) and the state output (envp[1]).
+ * Tizen uses this format for extcon device to get events from ports.
+ * Android uses this format as well.
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
+			dev_err(edev->dev, "out of memory in extcon_set_state\n");
+			kobject_uevent(&edev->dev->kobj, KOBJ_CHANGE);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(extcon_set_state);
+
+static struct device_attribute extcon_attrs[] = {
+	__ATTR_RO(state),
+	__ATTR_RO(name),
+};
+
+static int create_extcon_class(void)
+{
+	if (!extcon_class) {
+#ifdef CONFIG_ANDROID
+		extcon_class = class_create(THIS_MODULE, "switch");
+#else /* !CONFIG_ANDROID */
+		extcon_class = class_create(THIS_MODULE, "extcon");
+#endif /* CONFIG_ANDROID */
+		if (IS_ERR(extcon_class))
+			return PTR_ERR(extcon_class);
+		extcon_class->dev_attrs = extcon_attrs;
+	}
+
+	return 0;
+}
+
+static void extcon_cleanup(struct extcon_dev *edev, bool skip)
+{
+	if (!skip && get_device(edev->dev)) {
+		device_unregister(edev->dev);
+		put_device(edev->dev);
+	}
+
+	kfree(edev->dev);
+}
+
+static void extcon_dev_release(struct device *dev)
+{
+	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
+
+	extcon_cleanup(edev, true);
+}
+
+/**
+ * extcon_dev_register() - Register a new extcon device
+ * @edev	: the new extcon device (should be allocated before calling)
+ * @dev		: the parent device for this extcon device.
+ *
+ * Among the members of edev struct, please set the "user initializing data"
+ * in any case and set the "optional callbacks" if required. However, please
+ * do not set the values of "internal data", which are initialized by
+ * this function.
+ */
+int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
+{
+	int ret;
+
+	if (!extcon_class) {
+		ret = create_extcon_class();
+		if (ret < 0)
+			return ret;
+	}
+
+	edev->dev = kzalloc(sizeof(struct device), GFP_KERNEL);
+	edev->dev->parent = dev;
+	edev->dev->class = extcon_class;
+	edev->dev->release = extcon_dev_release;
+
+	dev_set_name(edev->dev, edev->name ? edev->name : dev_name(dev));
+	ret = device_register(edev->dev);
+	if (ret) {
+		put_device(edev->dev);
+		goto err_dev;
+	}
+
+	dev_set_drvdata(edev->dev, edev);
+	edev->state = 0;
+	return 0;
+
+err_dev:
+	kfree(edev->dev);
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
+	extcon_cleanup(edev, false);
+}
+EXPORT_SYMBOL_GPL(extcon_dev_unregister);
+
+static int __init extcon_class_init(void)
+{
+	return create_extcon_class();
+}
+module_init(extcon_class_init);
+
+static void __exit extcon_class_exit(void)
+{
+	class_destroy(extcon_class);
+}
+module_exit(extcon_class_exit);
+
+MODULE_AUTHOR("Mike Lockwood <lockwood@android.com>");
+MODULE_AUTHOR("Donggeun Kim <dg77.kim@samsung.com>");
+MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
+MODULE_DESCRIPTION("External connector (extcon) class driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
new file mode 100644
index 0000000..cd732ab
--- /dev/null
+++ b/include/linux/extcon.h
@@ -0,0 +1,82 @@
+/*
+ *  External connector (extcon) class driver
+ *
+ * Copyright (C) 2012 Samsung Electronics
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
+ * @name	The name of this extcon device. Parent device name is used
+ *		if NULL.
+ * @print_name	An optional callback to override the method to print the
+ *		name of the extcon device.
+ * @print_state	An optional callback to override the method to print the
+ *		status of the extcon device.
+ * @dev		Device of this extcon. Do not provide at register-time.
+ * @state	Attach/detach state of this extcon. Do not provide at
+ *		register-time
+ *
+ * In most cases, users only need to provide "User initializing data" of
+ * this struct when registering an extcon. In some exceptional cases,
+ * optional callbacks may be needed. However, the values in "internal data"
+ * are overwritten by register function.
+ */
+struct extcon_dev {
+	/* --- Optional user initializing data --- */
+	const char	*name;
+
+	/* --- Optional callbacks to override class functions --- */
+	ssize_t	(*print_name)(struct extcon_dev *edev, char *buf);
+	ssize_t	(*print_state)(struct extcon_dev *edev, char *buf);
+
+	/* --- Internal data. Please do not set. --- */
+	struct device	*dev;
+	u32		state;
+};
+
+#ifdef CONFIG_EXTCON
+extern int extcon_dev_register(struct extcon_dev *edev, struct device *dev);
+extern void extcon_dev_unregister(struct extcon_dev *edev);
+
+static inline u32 extcon_get_state(struct extcon_dev *edev)
+{
+	return edev->state;
+}
+
+extern void extcon_set_state(struct extcon_dev *edev, u32 state);
+#else /* CONFIG_EXTCON */
+static inline int extcon_dev_register(struct extcon_dev *edev,
+				      struct device *dev)
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

