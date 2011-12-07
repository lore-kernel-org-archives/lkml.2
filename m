Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382Ab1LGVT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:19:27 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:42476 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526Ab1LGVTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:19:24 -0500
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Dec 2011 16:19:23 EST
From: Bastian Blank <waldi@debian.org>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: konrad.wilk@oracle.com
Subject: [PATCH 3/4] xen: Add xenbusd device driver
Date: Wed,  7 Dec 2011 22:13:15 +0100
Message-Id: <1323292396-19523-4-git-send-email-waldi@debian.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323292396-19523-1-git-send-email-waldi@debian.org>
References: <1323292396-19523-1-git-send-email-waldi@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Access for xenstored to the event channel and pre-allocated ring is
managed via xenfs.  This adds its own device driver featuring mmap for
the ring and an ioctl for the event channel.

Signed-off-by: Bastian Blank <waldi@debian.org>
---
 drivers/xen/xenbus/Makefile             |    1 +
 drivers/xen/xenbus/xenbus_dev_backend.c |   79 +++++++++++++++++++++++++++++++
 include/xen/xenbus_dev.h                |   41 ++++++++++++++++
 3 files changed, 121 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xen/xenbus/xenbus_dev_backend.c
 create mode 100644 include/xen/xenbus_dev.h

diff --git a/drivers/xen/xenbus/Makefile b/drivers/xen/xenbus/Makefile
index a2ea363..31e2e90 100644
--- a/drivers/xen/xenbus/Makefile
+++ b/drivers/xen/xenbus/Makefile
@@ -10,4 +10,5 @@ xenbus-objs += xenbus_probe.o
 xenbus-be-objs-$(CONFIG_XEN_BACKEND) += xenbus_probe_backend.o
 xenbus-objs += $(xenbus-be-objs-y)
 
+obj-$(CONFIG_XEN_BACKEND) += xenbus_dev_backend.o
 obj-$(CONFIG_XEN_XENBUS_FRONTEND) += xenbus_probe_frontend.o
diff --git a/drivers/xen/xenbus/xenbus_dev_backend.c b/drivers/xen/xenbus/xenbus_dev_backend.c
new file mode 100644
index 0000000..58cf621
--- /dev/null
+++ b/drivers/xen/xenbus/xenbus_dev_backend.c
@@ -0,0 +1,79 @@
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+
+#include <xen/page.h>
+#include <xen/xenbus_dev.h>
+
+#include "xenbus_comms.h"
+
+MODULE_LICENSE("GPL");
+
+static long xenbusd_ioctl(struct file *file, unsigned int cmd, unsigned long data)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	switch (cmd) {
+		case IOCTL_XENBUSD_EVTCHN:
+			if (xen_store_evtchn > 0)
+				return xen_store_evtchn;
+			return -ENODEV;
+
+		default:
+			return -ENOTTY;
+	}
+}
+
+static int xenbusd_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	size_t size = vma->vm_end - vma->vm_start;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if ((size > PAGE_SIZE) || (vma->vm_pgoff != 0))
+		return -EINVAL;
+
+	if (remap_pfn_range(vma, vma->vm_start,
+			    virt_to_pfn(xen_store_interface),
+			    size, vma->vm_page_prot))
+		return -EAGAIN;
+
+	return 0;
+}
+
+const struct file_operations xenbusd_fops = {
+	.mmap = xenbusd_mmap,
+	.unlocked_ioctl = xenbusd_ioctl,
+};
+
+static struct miscdevice xenbusd_dev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "xen/xenbusd",
+	.fops = &xenbusd_fops,
+};
+
+static int __init xenbusd_init(void)
+{
+	int err;
+
+	if (!xen_initial_domain())
+		return -ENODEV;
+
+	err = misc_register(&xenbusd_dev);
+	if (err)
+		printk(KERN_ERR "Could not register xenbus device\n");
+	return err;
+}
+
+static void __exit xenbusd_exit(void)
+{
+	misc_deregister(&xenbusd_dev);
+}
+
+module_init(xenbusd_init);
+module_exit(xenbusd_exit);
diff --git a/include/xen/xenbus_dev.h b/include/xen/xenbus_dev.h
new file mode 100644
index 0000000..3008c03
--- /dev/null
+++ b/include/xen/xenbus_dev.h
@@ -0,0 +1,41 @@
+/******************************************************************************
+ * evtchn.h
+ *
+ * Interface to /dev/xen/xenbusd.
+ *
+ * Copyright (c) 2011 Bastian Blank <waldi@debian.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#ifndef __LINUX_XEN_XENBUS_DEV_H__
+#define __LINUX_XEN_XENBUS_DEV_H__
+
+#include <linux/ioctl.h>
+
+#define IOCTL_XENBUSD_EVTCHN				\
+	_IOC(_IOC_NONE, 'B', 0, 0)
+
+#endif /* __LINUX_XEN_XENBUS_DEV_H__ */
-- 
1.7.7.3

