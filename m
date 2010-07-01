Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab0GAPDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:03:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:50879 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756548Ab0GAPCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:02:54 -0400
From: Thomas Renninger <trenn@suse.de>
To: lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, astarikovskiy@suse.de,
       Thomas Renninger <trenn@suse.de>
Subject: [PATCH 2/6] ACPI: Provide /sys/devices/system/ec/*/io for binary access to the EC
Date: Thu,  1 Jul 2010 17:02:46 +0200
Message-Id: <1277996570-2686-3-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1277996570-2686-1-git-send-email-trenn@suse.de>
References: <1277996570-2686-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Binary sysfs skeleton taken over from drivers/pci/pci-sysfs.c

/sys/devices/system/ec/*/io
A userspace app to easily read/write the EC can be found here:
ftp://ftp.suse.com/pub/people/trenn/sources/ec/ec_access.c

Signed-off-by: Thomas Renninger <trenn@suse.de>

Index: linux-2.6.34-master/drivers/acpi/ec_sys.c
===================================================================
---
 Documentation/acpi/ec_sysfs |   33 +++++++++++++++
 drivers/acpi/ec_sys.c       |   95 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 128 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/acpi/ec_sysfs

diff --git a/Documentation/acpi/ec_sysfs b/Documentation/acpi/ec_sysfs
new file mode 100644
index 0000000..479225b
--- /dev/null
+++ b/Documentation/acpi/ec_sysfs
@@ -0,0 +1,33 @@
+		EC Sysfs File Description
+
+This file descibes sysfs files under:
+/sys/devices/system/ec
+
+Currently only one Embedded Controller is supported.
+This could get extended easily if such an ACPI supporting
+system exist, but until know there has no need be seen.
+
+/sys/devices/system/ec/ec0/gpe
+An integer value showing the General Purpose Event the EC
+serves and has its handler installed on.
+A GPE is an ACPI interrupt (compare with /proc/interrupts)
+with a specific value retrieved from a HW register associated
+to it. If the value equals the EC GPE, this event is processed
+by the EC.
+The activity of the EC GPE can be monitored like that:
+GPE=`cat /sys/devices/system/ec/ec0/gpe`
+watch -n1 cat /sys/firmware/acpi/interrupts/gpe${GPE}
+
+/sys/devices/system/ec/ec0/use_global_lock
+Shows whether BIOS requested the OS to use the global ACPI
+lock on EC transitions (compare with ACPI specification for
+details).
+
+/sys/devices/system/ec/ec0/io
+Provides access to the 255 EC registers.
+Its input and output is binary.
+A userspace tool to easily read/write the EC can be found here:
+ftp://ftp.suse.com/pub/people/trenn/sources/ec/ec_access.c
+This file is for debugging purposes only.
+!!! THE EC MUST ONLY GET ACCESSED THROUGH THE KERNEL, INTERPRETING
+ACPI CODE ON PRODUCTIVE SYSTEMS !!!
diff --git a/drivers/acpi/ec_sys.c b/drivers/acpi/ec_sys.c
index c64236f..9793c57 100644
--- a/drivers/acpi/ec_sys.c
+++ b/drivers/acpi/ec_sys.c
@@ -1,3 +1,13 @@
+/*
+ * ec_sys.c
+ *
+ * Copyright (C) 2010 SUSE Products GmbH/Novell
+ * Author:
+ *      Thomas Renninger <trenn@suse.de>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ */
+
 #include <linux/kernel.h>
 #include <linux/sysdev.h>
 #include <linux/acpi.h>
@@ -8,6 +18,8 @@ MODULE_AUTHOR("Thomas Renninger <trenn@suse.de>");
 MODULE_DESCRIPTION("ACPI EC sysfs access driver");
 MODULE_LICENSE("GPL");
 
+#define EC_SPACE_SIZE 256
+
 struct sysdev_class acpi_ec_sysdev_class = {
 	.name = "ec",
 };
@@ -32,6 +44,84 @@ static ssize_t show_ec_global_lock(struct sys_device *dev,
 SYSDEV_ATTR(gpe, 0444, show_ec_gpe, NULL);
 SYSDEV_ATTR(use_global_lock, 0444, show_ec_global_lock, NULL);
 
+
+/* TBD: ec_read/ec_write is only supported for one EC in a system
+	This needs adjustion in ec.c first
+*/
+static ssize_t
+acpi_ec_read_io(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *bin_attr,
+		char *buf, loff_t off, size_t count)
+{
+	/* Use this if support reading/writing multiple ECs exists in ec.c:
+	   struct sys_device *sysdev = container_of(kobj, struct sys_device, kobj);
+	   struct acpi_ec *ec = container_of(sysdev, struct acpi_ec, sysdev);
+	*/
+	unsigned int size = EC_SPACE_SIZE;
+	u8 *data = (u8 *) buf;
+	loff_t init_off = off;
+	int err = 0;
+
+	if (off >= size)
+		return 0;
+	if (off + count >= size) {
+		size -= off;
+		count = size;
+	} else
+		size = count;
+
+	while (size) {
+		err = ec_read(off, &data[off - init_off]);
+		if (err)
+			return err;
+		off++;
+		size--;
+	}
+	return count;
+}
+
+static ssize_t
+acpi_ec_write_io(struct file *filp, struct kobject *kobj,
+		 struct bin_attribute *bin_attr,
+		 char *buf, loff_t off, size_t count)
+{
+	/* Use this if support reading/writing multiple ECs exists in ec.c:
+	   struct sys_device *sysdev = container_of(kobj, struct sys_device, kobj);
+	   struct acpi_ec *ec = container_of(sysdev, struct acpi_ec, sysdev);
+	*/
+	unsigned int size = count;
+	loff_t init_off = off;
+	u8 *data = (u8 *) buf;
+	int err = 0;
+
+	if (off >= EC_SPACE_SIZE)
+		return 0;
+	if (off + count >= EC_SPACE_SIZE) {
+		size = EC_SPACE_SIZE - off;
+		count = size;
+	}
+
+	while (size) {
+		u8 byte_write = data[off - init_off];
+		err = ec_write(off, byte_write);
+		if (err)
+			return err;
+		off++;
+		size--;
+	}
+	return count;
+}
+
+static struct bin_attribute acpi_ec_io_attr = {
+	.attr =	{
+		.name = "io",
+		.mode = S_IRUGO | S_IWUSR,
+	},
+	.size = EC_SPACE_SIZE,
+	.read = acpi_ec_read_io,
+	.write = acpi_ec_write_io,
+};
+
 int acpi_ec_add_sysfs(struct acpi_ec *ec, int ec_device_count)
 {
 	int err = 0;
@@ -53,8 +143,13 @@ int acpi_ec_add_sysfs(struct acpi_ec *ec, int ec_device_count)
 	err = sysdev_create_file(&ec->sysdev, &attr_gpe);
 	if (err)
 		goto file_err_2;
+	err = sysfs_create_bin_file(&ec->sysdev.kobj, &acpi_ec_io_attr);
+	if (err)
+		goto file_err_3;
 	return err;
 
+ file_err_3:
+	sysdev_remove_file(&ec->sysdev, &attr_gpe);
  file_err_2:
 	sysdev_remove_file(&ec->sysdev, &attr_use_global_lock);
  file_err_1:
-- 
1.6.3

