Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1JQLyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:54:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56650 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1JQLxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:53:09 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, linus.walleij@stericsson.com, jamie@jamieiles.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/6] drivers/base: add bus for System-on-Chip devices
Date: Mon, 17 Oct 2011 12:52:54 +0100
Message-Id: <1318852378-14180-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Traditionally, any System-on-Chip based platform creates a flat list
of platform_devices directly under /sys/devices/platform.

In order to give these some better structure, this introduces a new
bus type for soc_devices that are registered with the new
soc_device_register() function.  All devices that are on the same
chip should then be registered as child devices of the soc device.

The soc bus also exports a few standardised device attributes which
allow user space to query the specific type of soc.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/base/Kconfig    |    3 +
 drivers/base/Makefile   |    1 +
 drivers/base/soc.c      |  115 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sys_soc.h |   38 +++++++++++++++
 4 files changed, 157 insertions(+), 0 deletions(-)
 create mode 100644 drivers/base/soc.c
 create mode 100644 include/linux/sys_soc.h

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 21cf46f..707aeaf 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -172,6 +172,9 @@ config SYS_HYPERVISOR
 	bool
 	default n
 
+config SOC_BUS
+	bool
+
 source "drivers/base/regmap/Kconfig"
 
 endmenu
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 99a375a..6b84b36 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_MODULES)	+= module.o
 endif
 obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
 obj-$(CONFIG_REGMAP)	+= regmap/
+obj-$(CONFIG_SOC_BUS) += soc.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
 
diff --git a/drivers/base/soc.c b/drivers/base/soc.c
new file mode 100644
index 0000000..1578e4e
--- /dev/null
+++ b/drivers/base/soc.c
@@ -0,0 +1,115 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2011
+ *
+ * Author: Lee Jones <lee.jones@linaro.org> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/sysfs.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/stat.h>
+#include <linux/slab.h>
+#include <linux/sys_soc.h>
+#include <linux/err.h>
+
+static ssize_t soc_info_get(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf);
+
+static DEVICE_ATTR(machine,  S_IRUGO, soc_info_get,  NULL);
+static DEVICE_ATTR(family,   S_IRUGO, soc_info_get,  NULL);
+static DEVICE_ATTR(soc_id,   S_IRUGO, soc_info_get,  NULL);
+static DEVICE_ATTR(revision, S_IRUGO, soc_info_get,  NULL);
+
+static ssize_t soc_info_get(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct soc_device *soc_dev =
+		container_of(dev, struct soc_device, dev);
+
+	if (attr == &dev_attr_machine)
+		return sprintf(buf, "%s\n", soc_dev->attr->machine);
+	if (attr == &dev_attr_family)
+		return sprintf(buf, "%s\n", soc_dev->attr->family);
+	if (attr == &dev_attr_revision)
+		return sprintf(buf, "%s\n", soc_dev->attr->revision);
+	if (attr == &dev_attr_soc_id)
+		return sprintf(buf, "%s\n", soc_dev->attr->soc_id);
+
+	return -EINVAL;
+
+}
+
+struct bus_type soc_bus_type = {
+	.name  = "soc",
+};
+
+static int __init soc_bus_register(void)
+{
+	return bus_register(&soc_bus_type);
+}
+core_initcall(soc_bus_register);
+
+struct attribute *soc_attr[] = {
+	&dev_attr_machine.attr,
+	&dev_attr_family.attr,
+	&dev_attr_soc_id.attr,
+	&dev_attr_revision.attr,
+	NULL,
+};
+
+struct attribute_group soc_attr_group = {
+	.attrs = soc_attr,
+};
+
+struct device *soc_device_register(struct soc_device_attribute *soc_dev_attr)
+{
+	struct soc_device *soc_dev;
+	static atomic_t soc_device_num = ATOMIC_INIT(0);
+	int ret;
+
+	soc_dev = kzalloc(sizeof(*soc_dev), GFP_KERNEL);
+	if (!soc_dev)
+		return ERR_PTR(-ENOMEM);
+
+	soc_dev->attr = soc_dev_attr;
+	soc_dev->dev.bus = &soc_bus_type;
+
+	dev_set_name(&soc_dev->dev, "soc%d",
+		atomic_inc_return(&soc_device_num) - 1);
+
+	ret = device_register(&soc_dev->dev);
+	if (ret)
+		goto out1;
+
+	ret = sysfs_create_group(&soc_dev->dev.kobj, &soc_attr_group);
+	if (ret)
+		goto out2;
+
+	return &soc_dev->dev;
+
+out2:
+	device_unregister(&soc_dev->dev);
+out1:
+	kfree(soc_dev);
+	kfree(soc_dev->attr);
+	return ERR_PTR(ret);
+}
+
+void soc_device_unregister(struct device *dev)
+{
+	struct soc_device *soc_dev =
+		container_of(dev, struct soc_device, dev);
+
+	sysfs_remove_group(&dev->kobj, &soc_attr_group);
+
+	if (device_is_registered(dev))
+		device_unregister(dev);
+
+	bus_unregister(&soc_bus_type);
+
+	kfree(soc_dev->attr);
+	kfree(soc_dev);
+}
diff --git a/include/linux/sys_soc.h b/include/linux/sys_soc.h
new file mode 100644
index 0000000..2485a0f2
--- /dev/null
+++ b/include/linux/sys_soc.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2011
+ * Author: Lee Jones <lee.jones@linaro.org> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+#ifndef __SOC_BUS_H
+#define __SOC_BUS_H
+
+#include <linux/kobject.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+
+struct soc_device_attribute {
+	const char *machine;
+	const char *family;
+	const char *revision;
+	const char *soc_id;
+};
+
+struct soc_device {
+	struct device dev;
+	struct soc_device_attribute *attr;
+};
+
+/**
+ * soc_device_register - register SoC as a device
+ * @soc_plat_dev_attr: Attributes passed from platform to be attributed to a SoC
+ */
+struct device *soc_device_register(
+	struct soc_device_attribute *soc_plat_dev_attr);
+
+/**
+ * soc_device_unregister - unregister SoC device
+ * @dev: SoC device to be unregistered
+ */
+void soc_device_unregister(struct device *dev);
+
+#endif /* __SOC_BUS_H */
-- 
1.7.5.4

