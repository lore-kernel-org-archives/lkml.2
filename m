Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195Ab2C3LTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:19:50 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:51544 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934075Ab2C3LSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:18:48 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 74/76] ACPI: Add support for exposing BGRT data
Date: Fri, 30 Mar 2012 06:14:17 -0400
Message-id: <d1ff4b1cdbabb9ab9813f3d6e1cbec42cc5d6ed8.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

ACPI 5.0 adds the BGRT, a table that contains a pointer to the firmware
boot splash and associated metadata. This simple driver exposes it via
/sys/firmware/acpi in order to allow bootsplash applications to draw their
splash around the firmware image and reduce the number of jarring graphical
transitions during boot.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/ABI/testing/sysfs-firmware-acpi |   20 +++
 drivers/acpi/Kconfig                          |    9 ++
 drivers/acpi/Makefile                         |    1 +
 drivers/acpi/bgrt.c                           |  175 +++++++++++++++++++++++++
 4 files changed, 205 insertions(+)
 create mode 100644 drivers/acpi/bgrt.c

diff --git a/Documentation/ABI/testing/sysfs-firmware-acpi b/Documentation/ABI/testing/sysfs-firmware-acpi
index 4f9ba3c..dd930c8 100644
--- a/Documentation/ABI/testing/sysfs-firmware-acpi
+++ b/Documentation/ABI/testing/sysfs-firmware-acpi
@@ -1,3 +1,23 @@
+What:		/sys/firmware/acpi/bgrt/
+Date:		January 2012
+Contact:	Matthew Garrett <mjg@redhat.com>
+Description:
+		The BGRT is an ACPI 5.0 feature that allows the OS
+		to obtain a copy of the firmware boot splash and
+		some associated metadata. This is intended to be used
+		by boot splash applications in order to interact with
+		the firmware boot splash in order to avoid jarring
+		transitions.
+
+		image: The image bitmap. Currently a 32-bit BMP.
+		status: 1 if the image is valid, 0 if firmware invalidated it.
+		type: 0 indicates image is in BMP format.
+		version: The version of the BGRT. Currently 1.
+		xoffset: The number of pixels between the left of the screen
+			 and the left edge of the image.
+		yoffset: The number of pixels between the top of the screen
+			 and the top edge of the image.
+
 What:		/sys/firmware/acpi/interrupts/
 Date:		February 2008
 Contact:	Len Brown <lenb@kernel.org>
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 7556913..47768ff 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -384,6 +384,15 @@ config ACPI_CUSTOM_METHOD
 	  load additional kernel modules after boot, this feature may be used
 	  to override that restriction).
 
+config ACPI_BGRT
+        tristate "Boottime Graphics Resource Table support"
+        default n
+        help
+	  This driver adds support for exposing the ACPI Boottime Graphics
+	  Resource Table, which allows the operating system to obtain
+	  data from the firmware boot splash. It will appear under
+	  /sys/firmware/acpi/bgrt/ .
+
 source "drivers/acpi/apei/Kconfig"
 
 endif	# ACPI
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 1567028..47199e2 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -62,6 +62,7 @@ obj-$(CONFIG_ACPI_SBS)		+= sbs.o
 obj-$(CONFIG_ACPI_HED)		+= hed.o
 obj-$(CONFIG_ACPI_EC_DEBUGFS)	+= ec_sys.o
 obj-$(CONFIG_ACPI_CUSTOM_METHOD)+= custom_method.o
+obj-$(CONFIG_ACPI_BGRT)		+= bgrt.o
 
 # processor has its own "processor." module_param namespace
 processor-y			:= processor_driver.o processor_throttling.o
diff --git a/drivers/acpi/bgrt.c b/drivers/acpi/bgrt.c
new file mode 100644
index 0000000..8cf6c46
--- /dev/null
+++ b/drivers/acpi/bgrt.c
@@ -0,0 +1,175 @@
+/*
+ * Copyright 2012 Red Hat, Inc <mjg@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/sysfs.h>
+#include <acpi/acpi.h>
+#include <acpi/acpi_bus.h>
+
+static struct acpi_table_bgrt *bgrt_tab;
+static struct kobject *bgrt_kobj;
+
+struct bmp_header {
+	u16 id;
+	u32 size;
+} __attribute ((packed));
+
+static struct bmp_header bmp_header;
+
+static ssize_t show_version(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab->version);
+}
+static DEVICE_ATTR(version, S_IRUGO, show_version, NULL);
+
+static ssize_t show_status(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab->status);
+}
+static DEVICE_ATTR(status, S_IRUGO, show_status, NULL);
+
+static ssize_t show_type(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab->image_type);
+}
+static DEVICE_ATTR(type, S_IRUGO, show_type, NULL);
+
+static ssize_t show_xoffset(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab->image_offset_x);
+}
+static DEVICE_ATTR(xoffset, S_IRUGO, show_xoffset, NULL);
+
+static ssize_t show_yoffset(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab->image_offset_y);
+}
+static DEVICE_ATTR(yoffset, S_IRUGO, show_yoffset, NULL);
+
+static ssize_t show_image(struct file *file, struct kobject *kobj,
+	       struct bin_attribute *attr, char *buf, loff_t off, size_t count)
+{
+	int size = attr->size;
+	void __iomem *image = attr->private;
+
+	if (off >= size) {
+		count = 0;
+	} else {
+		if (off + count > size)
+			count = size - off;
+
+		memcpy_fromio(buf, image+off, count);
+	}
+
+	return count;
+}
+
+static struct bin_attribute image_attr = {
+	.attr = {
+		.name = "image",
+		.mode = S_IRUGO,
+	},
+	.read = show_image,
+};
+
+static struct attribute *bgrt_attributes[] = {
+	&dev_attr_version.attr,
+	&dev_attr_status.attr,
+	&dev_attr_type.attr,
+	&dev_attr_xoffset.attr,
+	&dev_attr_yoffset.attr,
+	NULL,
+};
+
+static struct attribute_group bgrt_attribute_group = {
+	.attrs = bgrt_attributes,
+};
+
+static int __init bgrt_init(void)
+{
+	acpi_status status;
+	int ret;
+	void __iomem *bgrt;
+
+	if (acpi_disabled)
+		return -ENODEV;
+
+	status = acpi_get_table("BGRT", 0,
+				(struct acpi_table_header **)&bgrt_tab);
+
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	sysfs_bin_attr_init(&image_attr);
+
+	bgrt = ioremap(bgrt_tab->image_address, sizeof(struct bmp_header));
+
+	if (!bgrt) {
+		ret = -EINVAL;
+		goto out_err;
+	}
+
+	memcpy_fromio(&bmp_header, bgrt, sizeof(bmp_header));
+	image_attr.size = bmp_header.size;
+	iounmap(bgrt);
+
+	image_attr.private = ioremap(bgrt_tab->image_address, image_attr.size);
+
+	if (!image_attr.private) {
+		ret = -EINVAL;
+		goto out_err;
+	}
+
+
+	bgrt_kobj = kobject_create_and_add("bgrt", acpi_kobj);
+	if (!bgrt_kobj) {
+		ret = -EINVAL;
+		goto out_iounmap;
+	}
+
+	ret = sysfs_create_group(bgrt_kobj, &bgrt_attribute_group);
+	if (ret)
+		goto out_kobject;
+
+	ret = sysfs_create_bin_file(bgrt_kobj, &image_attr);
+	if (ret)
+		goto out_group;
+
+	return 0;
+
+out_group:
+	sysfs_remove_group(bgrt_kobj, &bgrt_attribute_group);
+out_kobject:
+	kobject_put(bgrt_kobj);
+out_iounmap:
+	iounmap(image_attr.private);
+out_err:
+	return ret;
+}
+
+static void __exit bgrt_exit(void)
+{
+	iounmap(image_attr.private);
+	sysfs_remove_group(bgrt_kobj, &bgrt_attribute_group);
+	sysfs_remove_bin_file(bgrt_kobj, &image_attr);
+}
+
+module_init(bgrt_init);
+module_exit(bgrt_exit);
+
+MODULE_AUTHOR("Matthew Garrett");
+MODULE_DESCRIPTION("BGRT boot graphic support");
+MODULE_LICENSE("GPL");
-- 
1.7.10.rc2.19.gfae9d

