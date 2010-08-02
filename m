Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab0HBHsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:48:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:53447 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab0HBHsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:48:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,302,1278313200"; 
   d="scan'208";a="591970037"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>
Subject: [PATCH 4/4] ACPI, APEI, ERST debug support
Date: Mon,  2 Aug 2010 15:48:25 +0800
Message-Id: <1280735305-15379-5-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280735305-15379-1-git-send-email-ying.huang@intel.com>
References: <1280735305-15379-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds debugging/testing support to ERST. A misc device is
implemented to export raw ERST read/write/clear etc operations to user
space. With this patch, we can add ERST testing support to
linuxfirmwarekit ISO (linuxfirmwarekit.org) to verify the kernel
support and the firmware implementation.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/acpi/apei/Kconfig    |    9 +
 drivers/acpi/apei/Makefile   |    1 
 drivers/acpi/apei/erst-dbg.c |  206 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 216 insertions(+)
 create mode 100644 drivers/acpi/apei/erst-dbg.c

--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -28,3 +28,12 @@ config ACPI_APEI_EINJ
 	  EINJ provides a hardware error injection mechanism, it is
 	  mainly used for debugging and testing the other parts of
 	  APEI and some other RAS features.
+
+config ACPI_APEI_ERST_DEBUG
+	tristate "APEI Error Record Serialization Table (ERST) Debug Support"
+	depends on ACPI_APEI
+	help
+	  ERST is a way provided by APEI to save and retrieve hardware
+	  error infomation to and from a persistent store. Enable this
+	  if you want to debugging and testing the ERST kernel support
+	  and firmware implementation.
--- a/drivers/acpi/apei/Makefile
+++ b/drivers/acpi/apei/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_ACPI_APEI)		+= apei.o
 obj-$(CONFIG_ACPI_APEI_GHES)	+= ghes.o
 obj-$(CONFIG_ACPI_APEI_EINJ)	+= einj.o
+obj-$(CONFIG_ACPI_APEI_ERST_DEBUG) += erst-dbg.o
 
 apei-y := apei-base.o hest.o cper.o erst.o
--- /dev/null
+++ b/drivers/acpi/apei/erst-dbg.c
@@ -0,0 +1,206 @@
+/*
+ * APEI Error Record Serialization Table debug support
+ *
+ * ERST is a way provided by APEI to save and retrieve hardware error
+ * infomation to and from a persistent store. This file provide the
+ * debugging/testing support for ERST kernel support and firmware
+ * implementation.
+ *
+ * Copyright 2010 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <acpi/apei.h>
+#include <linux/miscdevice.h>
+
+#include "apei-internal.h"
+
+#define ERST_DBG_PFX			"ERST DBG: "
+
+#define ERST_DBG_RECORD_LEN_MAX		4096
+
+static void *erst_dbg_buf;
+static unsigned int erst_dbg_buf_len;
+
+/* Prevent erst_dbg_read/write from being invoked concurrently */
+static DEFINE_MUTEX(erst_dbg_mutex);
+
+static int erst_dbg_open(struct inode *inode, struct file *file)
+{
+	if (erst_disable)
+		return -ENODEV;
+
+	return nonseekable_open(inode, file);
+}
+
+static long erst_dbg_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+{
+	int rc;
+	u64 record_id;
+	u32 record_count;
+
+	switch (cmd) {
+	case APEI_ERST_CLEAR_RECORD:
+		rc = get_user(record_id, (u64 __user *)arg);
+		if (rc)
+			return rc;
+		return erst_clear(record_id);
+	case APEI_ERST_GET_RECORD_COUNT:
+		rc = erst_get_record_count();
+		if (rc < 0)
+			return rc;
+		record_count = rc;
+		rc = put_user(record_count, (u32 __user *)arg);
+		if (rc)
+			return rc;
+		return 0;
+	default:
+		return -ENOTTY;
+	}
+}
+
+static ssize_t erst_dbg_read(struct file *filp, char __user *ubuf,
+			     size_t usize, loff_t *off)
+{
+	int rc;
+	ssize_t len = 0;
+	u64 id;
+
+	if (*off != 0)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&erst_dbg_mutex) != 0)
+		return -EINTR;
+
+retry_next:
+	rc = erst_get_next_record_id(&id);
+	if (rc)
+		goto out;
+	/* no more record */
+	if (id == APEI_ERST_INVALID_RECORD_ID)
+		goto out;
+retry:
+	rc = len = erst_read(id, erst_dbg_buf, erst_dbg_buf_len);
+	/* The record may be cleared by others, try read next record */
+	if (rc == -ENOENT)
+		goto retry_next;
+	if (rc < 0)
+		goto out;
+	if (len > ERST_DBG_RECORD_LEN_MAX) {
+		pr_warning(ERST_DBG_PFX
+			   "Record (ID: 0x%llx) length is too long: 0x%lx\n",
+			   id, len);
+		rc = -EIO;
+		goto out;
+	}
+	if (len > erst_dbg_buf_len) {
+		kfree(erst_dbg_buf);
+		rc = -ENOMEM;
+		erst_dbg_buf = kmalloc(len, GFP_KERNEL);
+		if (!erst_dbg_buf)
+			goto out;
+		erst_dbg_buf_len = len;
+		goto retry;
+	}
+
+	rc = -EINVAL;
+	if (len > usize)
+		goto out;
+
+	rc = -EFAULT;
+	if (copy_to_user(ubuf, erst_dbg_buf, len))
+		goto out;
+	rc = 0;
+out:
+	mutex_unlock(&erst_dbg_mutex);
+	return rc ? rc : len;
+}
+
+static ssize_t erst_dbg_write(struct file *filp, const char __user *ubuf,
+			      size_t usize, loff_t *off)
+{
+	int rc;
+	struct cper_record_header *rcd;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (usize > ERST_DBG_RECORD_LEN_MAX) {
+		pr_err(ERST_DBG_PFX "Too long record to be written\n");
+		return -EINVAL;
+	}
+
+	if (mutex_lock_interruptible(&erst_dbg_mutex))
+		return -EINTR;
+	if (usize > erst_dbg_buf_len) {
+		kfree(erst_dbg_buf);
+		rc = -ENOMEM;
+		erst_dbg_buf = kmalloc(usize, GFP_KERNEL);
+		if (!erst_dbg_buf)
+			goto out;
+		erst_dbg_buf_len = usize;
+	}
+	rc = copy_from_user(erst_dbg_buf, ubuf, usize);
+	if (rc) {
+		rc = -EFAULT;
+		goto out;
+	}
+	rcd = erst_dbg_buf;
+	rc = -EINVAL;
+	if (rcd->record_length != usize)
+		goto out;
+
+	rc = erst_write(erst_dbg_buf);
+
+out:
+	mutex_unlock(&erst_dbg_mutex);
+	return rc < 0 ? rc : usize;
+}
+
+static const struct file_operations erst_dbg_ops = {
+	.owner		= THIS_MODULE,
+	.open		= erst_dbg_open,
+	.read		= erst_dbg_read,
+	.write		= erst_dbg_write,
+	.unlocked_ioctl	= erst_dbg_ioctl,
+};
+
+static struct miscdevice erst_dbg_dev = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "erst_dbg",
+	.fops	= &erst_dbg_ops,
+};
+
+static __init int erst_dbg_init(void)
+{
+	return misc_register(&erst_dbg_dev);
+}
+
+static __exit void erst_dbg_exit(void)
+{
+	misc_deregister(&erst_dbg_dev);
+	kfree(erst_dbg_buf);
+}
+
+module_init(erst_dbg_init);
+module_exit(erst_dbg_exit);
+
+MODULE_AUTHOR("Huang Ying");
+MODULE_DESCRIPTION("APEI Error Record Serialization Table debug support");
+MODULE_LICENSE("GPL");
