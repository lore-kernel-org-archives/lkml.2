Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030229Ab2CUVki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:40:38 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:47195 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964935Ab2CUVkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:40:31 -0400
Message-ID: <1332366080.3858.52.camel@key-ThinkPad-W510>
Subject: [PATCH 15/17] powerpc: crypto: sysfs routines and docs for the nx
 device driver
From: Kent Yoder <key@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, rcj@linux.vnet.ibm.com,
        benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org
Date: Wed, 21 Mar 2012 16:41:20 -0500
In-Reply-To: <1332365297.3858.5.camel@key-ThinkPad-W510>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032121-4242-0000-0000-0000011DCFD8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These routines add sysfs files supporting the Power7+ in-Nest encryption
accelerator driver.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 Documentation/powerpc/pfo-nx-crypto.txt |   52 ++++++++
 arch/powerpc/crypto/nx/nx_sysfs.c       |  194 +++++++++++++++++++++++++++++++
 2 files changed, 246 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/powerpc/pfo-nx-crypto.txt
 create mode 100644 arch/powerpc/crypto/nx/nx_sysfs.c

diff --git a/Documentation/powerpc/pfo-nx-crypto.txt b/Documentation/powerpc/pfo-nx-crypto.txt
new file mode 100644
index 0000000..63440d3
--- /dev/null
+++ b/Documentation/powerpc/pfo-nx-crypto.txt
@@ -0,0 +1,52 @@
+
+Documentation for the sysfs interfaces provided by the nx-crypto driver, built
+in arch/powerpc/crypto/nx.
+
+The driver provides 2 sets of sysfs files, 1 for confirming that the device is
+actually being used and 1 for error detection.
+
+All sysfs files can be found in:
+
+	/sys/bus/vio/drivers/nx
+
+Error Detection
+===============
+
+errors:
+- A u32 providing a total count of errors since the driver was loaded. The
+only errors counted here are those returned from the hcall, H_COP_OP.
+
+last_error:
+- The most recent non-zero return code from the H_COP_OP hcall. -EBUSY is not
+recorded here (the hcall will retry until -EBUSY goes away).
+
+last_error_pid:
+- The process ID of the process who received the most recent error from the
+hcall.
+
+Notes on error detection:
+  H_RH_PARM (invalid hardware resource ID) and H_HARDWARE (hardware failure)
+are not recorded in the errors or last_error sysfs files, since they are
+signals to the driver to fall back to software.
+
+Device Use
+==========
+
+aes_bytes:
+- The total number of bytes encrypted using AES in any of the driver's
+supported modes.
+
+aes_ops:
+- The total number of AES operations submitted to the hardware.
+
+sha256_bytes:
+- The total number of bytes hashed by the hardware using SHA-256.
+
+sha256_ops:
+- The total number of SHA-256 operations submitted to the hardware.
+
+sha512_bytes:
+- The total number of bytes hashed by the hardware using SHA-512.
+
+sha512_ops:
+- The total number of SHA-512 operations submitted to the hardware.
diff --git a/arch/powerpc/crypto/nx/nx_sysfs.c b/arch/powerpc/crypto/nx/nx_sysfs.c
new file mode 100644
index 0000000..02c84e7
--- /dev/null
+++ b/arch/powerpc/crypto/nx/nx_sysfs.c
@@ -0,0 +1,194 @@
+/**
+ * sysfs routines supporting the Power 7+ Nest Accelerators driver
+ *
+ * Copyright (C) 2011-2012 International Business Machines Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 only.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Author: Kent Yoder <yoder1@us.ibm.com>
+ */
+
+#include <linux/device.h>
+#include <linux/kobject.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/crypto.h>
+#include <crypto/hash.h>
+#include <asm/vio.h>
+
+#include "nx_csbcpb.h"
+#include "nx.h"
+
+
+/* sysfs attributes and callbacks
+ *
+ * For documentation on these attributes, please see:
+ *
+ * Documentation/powerpc/pfo-nx-crypto.txt
+ */
+static ssize_t
+nx_attr_show_sha256_ops(struct device_driver *driver, char *buf)
+{
+	return sprintf(buf, "%d\n", atomic_read(&nx_driver.stats.sha256_ops));
+}
+static DRIVER_ATTR(sha256_ops, S_IRUGO, nx_attr_show_sha256_ops, NULL);
+
+static ssize_t
+nx_attr_show_sha256_bytes(struct device_driver *driver, char *buf)
+{
+	return sprintf(buf, "%ld\n",
+		       atomic64_read(&nx_driver.stats.sha256_bytes));
+}
+static DRIVER_ATTR(sha256_bytes, S_IRUGO, nx_attr_show_sha256_bytes, NULL);
+
+static ssize_t
+nx_attr_show_sha512_ops(struct device_driver *driver, char *buf)
+{
+	return sprintf(buf, "%d\n", atomic_read(&nx_driver.stats.sha512_ops));
+}
+static DRIVER_ATTR(sha512_ops, S_IRUGO, nx_attr_show_sha512_ops, NULL);
+
+static ssize_t
+nx_attr_show_sha512_bytes(struct device_driver *driver, char *buf)
+{
+	return sprintf(buf, "%ld\n",
+		       atomic64_read(&nx_driver.stats.sha512_bytes));
+}
+static DRIVER_ATTR(sha512_bytes, S_IRUGO, nx_attr_show_sha512_bytes, NULL);
+
+static ssize_t
+nx_attr_show_aes_ops(struct device_driver *driver, char *buf)
+{
+	return sprintf(buf, "%d\n", atomic_read(&nx_driver.stats.aes_ops));
+}
+static DRIVER_ATTR(aes_ops, S_IRUGO, nx_attr_show_aes_ops, NULL);
+
+static ssize_t
+nx_attr_show_aes_bytes(struct device_driver *driver, char *buf)
+{
+	return sprintf(buf, "%ld\n", atomic64_read(&nx_driver.stats.aes_bytes));
+}
+static DRIVER_ATTR(aes_bytes, S_IRUGO, nx_attr_show_aes_bytes, NULL);
+
+static ssize_t
+nx_attr_show_sync_ops(struct device_driver *driver, char *buf)
+{
+	return sprintf(buf, "%d\n", atomic_read(&nx_driver.stats.sync_ops));
+}
+static DRIVER_ATTR(sync_ops, S_IRUGO, nx_attr_show_sync_ops, NULL);
+
+static ssize_t
+nx_attr_show_errors(struct device_driver *driver, char *buf)
+{
+	return sprintf(buf, "%d\n", atomic_read(&nx_driver.stats.errors));
+}
+static DRIVER_ATTR(errors, S_IRUGO, nx_attr_show_errors, NULL);
+
+static ssize_t
+nx_attr_show_last_error(struct device_driver *driver, char *buf)
+{
+	return sprintf(buf, "%d\n", atomic_read(&nx_driver.stats.last_error));
+}
+static DRIVER_ATTR(last_error, S_IRUGO, nx_attr_show_last_error, NULL);
+
+static ssize_t
+nx_attr_show_last_error_pid(struct device_driver *driver, char *buf)
+{
+	return sprintf(buf, "%d\n",
+		       atomic_read(&nx_driver.stats.last_error_pid));
+}
+static DRIVER_ATTR(last_error_pid, S_IRUGO, nx_attr_show_last_error_pid, NULL);
+
+int
+nx_sysfs_init(struct device_driver *drv)
+{
+	int rc;
+
+	rc = driver_create_file(drv, &driver_attr_aes_ops);
+	if (rc)
+		goto out;
+
+	rc = driver_create_file(drv, &driver_attr_aes_bytes);
+	if (rc)
+		goto out2_unreg;
+
+	rc = driver_create_file(drv, &driver_attr_sync_ops);
+	if (rc)
+		goto out3_unreg;
+
+	rc = driver_create_file(drv, &driver_attr_sha256_ops);
+	if (rc)
+		goto out4_unreg;
+
+	rc = driver_create_file(drv, &driver_attr_sha256_bytes);
+	if (rc)
+		goto out5_unreg;
+
+	rc = driver_create_file(drv, &driver_attr_sha512_ops);
+	if (rc)
+		goto out6_unreg;
+
+	rc = driver_create_file(drv, &driver_attr_sha512_bytes);
+	if (rc)
+		goto out7_unreg;
+
+	rc = driver_create_file(drv, &driver_attr_errors);
+	if (rc)
+		goto out8_unreg;
+
+	rc = driver_create_file(drv, &driver_attr_last_error);
+	if (rc)
+		goto out9_unreg;
+
+	rc = driver_create_file(drv, &driver_attr_last_error_pid);
+	if (rc)
+		goto out10_unreg;
+
+	goto out;
+
+out10_unreg:
+	driver_remove_file(drv, &driver_attr_last_error);
+out9_unreg:
+	driver_remove_file(drv, &driver_attr_errors);
+out8_unreg:
+	driver_remove_file(drv, &driver_attr_sha512_bytes);
+out7_unreg:
+	driver_remove_file(drv, &driver_attr_sha512_ops);
+out6_unreg:
+	driver_remove_file(drv, &driver_attr_sha256_bytes);
+out5_unreg:
+	driver_remove_file(drv, &driver_attr_sha256_ops);
+out4_unreg:
+	driver_remove_file(drv, &driver_attr_sync_ops);
+out3_unreg:
+	driver_remove_file(drv, &driver_attr_aes_bytes);
+out2_unreg:
+	driver_remove_file(drv, &driver_attr_aes_ops);
+out:
+	return rc;
+}
+
+void
+nx_sysfs_fini(struct device_driver *drv)
+{
+	driver_remove_file(drv, &driver_attr_sync_ops);
+	driver_remove_file(drv, &driver_attr_aes_bytes);
+	driver_remove_file(drv, &driver_attr_aes_ops);
+	driver_remove_file(drv, &driver_attr_sha256_bytes);
+	driver_remove_file(drv, &driver_attr_sha256_ops);
+	driver_remove_file(drv, &driver_attr_sha512_bytes);
+	driver_remove_file(drv, &driver_attr_sha512_ops);
+}
-- 
1.7.1


