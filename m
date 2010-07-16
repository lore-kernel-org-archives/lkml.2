Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965179Ab0GPLLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 07:11:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43425 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965122Ab0GPLLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 07:11:42 -0400
From: Thomas Renninger <trenn@suse.de>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: [PATCH 2/7] ACPI: Provide /sys/kernel/debug//ec/ec0/io for binary access to the EC
Date: Fri, 16 Jul 2010 13:11:32 +0200
Message-Id: <1279278697-3694-3-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1279278697-3694-1-git-send-email-trenn@suse.de>
References: <1279278697-3694-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A userspace app to easily read/write the EC can be found here:
ftp://ftp.suse.com/pub/people/trenn/sources/ec/ec_access.c

Multiple ECs are not supported, but shouldn't be hard to add as soon
as the ec driver itself will support them.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org
CC: linux-acpi@vger.kernel.org
CC: platform-driver-x86@vger.kernel.org
---
 drivers/acpi/ec_sys.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/ec_sys.c b/drivers/acpi/ec_sys.c
index 834c21a..3ef9781 100644
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
 #include <linux/acpi.h>
 #include <linux/debugfs.h>
@@ -7,12 +17,87 @@ MODULE_AUTHOR("Thomas Renninger <trenn@suse.de>");
 MODULE_DESCRIPTION("ACPI EC sysfs access driver");
 MODULE_LICENSE("GPL");
 
+#define EC_SPACE_SIZE 256
+
 struct sysdev_class acpi_ec_sysdev_class = {
 	.name = "ec",
 };
 
 static struct dentry *acpi_ec_debugfs_dir;
 
+static int acpi_ec_open_io(struct inode *i, struct file *f)
+{
+	f->private_data = i->i_private;
+	return 0;
+}
+
+static ssize_t acpi_ec_read_io(struct file *f, char __user *buf,
+			       size_t count, loff_t *off)
+{
+	/* Use this if support reading/writing multiple ECs exists in ec.c:
+	 * struct acpi_ec *ec = ((struct seq_file *)f->private_data)->private;
+	 */
+	unsigned int size = EC_SPACE_SIZE;
+	u8 *data = (u8 *) buf;
+	loff_t init_off = *off;
+	int err = 0;
+
+	if (*off >= size)
+		return 0;
+	if (*off + count >= size) {
+		size -= *off;
+		count = size;
+	} else
+		size = count;
+
+	while (size) {
+		err = ec_read(*off, &data[*off - init_off]);
+		if (err)
+			return err;
+		*off += 1;
+		size--;
+	}
+	return count;
+}
+
+static ssize_t acpi_ec_write_io(struct file *f, const char __user *buf,
+				size_t count, loff_t *off)
+{
+	/* Use this if support reading/writing multiple ECs exists in ec.c:
+	 * struct acpi_ec *ec = ((struct seq_file *)f->private_data)->private;
+	 */
+
+	unsigned int size = count;
+	loff_t init_off = *off;
+	u8 *data = (u8 *) buf;
+	int err = 0;
+
+	if (*off >= EC_SPACE_SIZE)
+		return 0;
+	if (*off + count >= EC_SPACE_SIZE) {
+		size = EC_SPACE_SIZE - *off;
+		count = size;
+	}
+
+	while (size) {
+		u8 byte_write = data[*off - init_off];
+		err = ec_write(*off, byte_write);
+		if (err)
+			return err;
+
+		*off += 1;
+		size--;
+	}
+	return count;
+}
+
+static struct file_operations acpi_ec_io_ops = {
+	.owner = THIS_MODULE,
+	.open  = acpi_ec_open_io,
+	.read  = acpi_ec_read_io,
+	.write = acpi_ec_write_io,
+};
+
 int acpi_ec_add_debugfs(struct acpi_ec *ec, unsigned int ec_device_count)
 {
 	struct dentry *dev_dir;
@@ -35,6 +120,7 @@ int acpi_ec_add_debugfs(struct acpi_ec *ec, unsigned int ec_device_count)
 	debugfs_create_x32("gpe", 0444, dev_dir, (u32 *)&first_ec->gpe);
 	debugfs_create_bool("use_global_lock", 0444, dev_dir,
 			    (u32 *)&first_ec->global_lock);
+	debugfs_create_file("io", 0666, dev_dir, ec, &acpi_ec_io_ops);
 	return 0;
 }
 
-- 
1.6.3

