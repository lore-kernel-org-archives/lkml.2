Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab1LJSaf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 13:30:35 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:51218 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab1LJSaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 13:30:02 -0500
From: Bastian Blank <waldi@debian.org>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: konrad.wilk@oracle.com
Subject: [PATCH 6/6] xen/xenbus-backend: Only register device if communication ring is local
Date: Sat, 10 Dec 2011 19:29:51 +0100
Message-Id: <1323541791-18006-7-git-send-email-waldi@debian.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323541791-18006-1-git-send-email-waldi@debian.org>
References: <1323541791-18006-1-git-send-email-waldi@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bastian Blank <waldi@debian.org>
---
 drivers/xen/xenbus/Makefile             |    2 +-
 drivers/xen/xenbus/xenbus_dev_backend.c |   13 ++-----------
 drivers/xen/xenbus/xenbus_dev_backend.h |    2 ++
 drivers/xen/xenbus/xenbus_probe.c       |   18 ++++++++++++++++++
 4 files changed, 23 insertions(+), 12 deletions(-)
 create mode 100644 drivers/xen/xenbus/xenbus_dev_backend.h

diff --git a/drivers/xen/xenbus/Makefile b/drivers/xen/xenbus/Makefile
index 31e2e90..d751f45 100644
--- a/drivers/xen/xenbus/Makefile
+++ b/drivers/xen/xenbus/Makefile
@@ -7,8 +7,8 @@ xenbus-objs += xenbus_comms.o
 xenbus-objs += xenbus_xs.o
 xenbus-objs += xenbus_probe.o
 
+xenbus-be-objs-$(CONFIG_XEN_BACKEND) += xenbus_dev_backend.o
 xenbus-be-objs-$(CONFIG_XEN_BACKEND) += xenbus_probe_backend.o
 xenbus-objs += $(xenbus-be-objs-y)
 
-obj-$(CONFIG_XEN_BACKEND) += xenbus_dev_backend.o
 obj-$(CONFIG_XEN_XENBUS_FRONTEND) += xenbus_probe_frontend.o
diff --git a/drivers/xen/xenbus/xenbus_dev_backend.c b/drivers/xen/xenbus/xenbus_dev_backend.c
index a2092bd..fb87f1b 100644
--- a/drivers/xen/xenbus/xenbus_dev_backend.c
+++ b/drivers/xen/xenbus/xenbus_dev_backend.c
@@ -3,7 +3,6 @@
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
-#include <linux/module.h>
 #include <linux/capability.h>
 
 #include <xen/page.h>
@@ -11,8 +10,6 @@
 
 #include "xenbus_comms.h"
 
-MODULE_LICENSE("GPL");
-
 static int xenbus_backend_open(struct inode *inode, struct file *filp)
 {
 	if (!capable(CAP_SYS_ADMIN))
@@ -67,23 +64,17 @@ static struct miscdevice xenbus_backend_dev = {
 	.fops = &xenbus_backend_fops,
 };
 
-static int __init xenbus_backend_init(void)
+int __init xenbus_backend_init(void)
 {
 	int err;
 
-	if (!xen_initial_domain())
-		return -ENODEV;
-
 	err = misc_register(&xenbus_backend_dev);
 	if (err)
 		printk(KERN_ERR "Could not register xenbus backend device\n");
 	return err;
 }
 
-static void __exit xenbus_backend_exit(void)
+void __exit xenbus_backend_exit(void)
 {
 	misc_deregister(&xenbus_backend_dev);
 }
-
-module_init(xenbus_backend_init);
-module_exit(xenbus_backend_exit);
diff --git a/drivers/xen/xenbus/xenbus_dev_backend.h b/drivers/xen/xenbus/xenbus_dev_backend.h
new file mode 100644
index 0000000..d986853
--- /dev/null
+++ b/drivers/xen/xenbus/xenbus_dev_backend.h
@@ -0,0 +1,2 @@
+int xenbus_backend_init(void);
+void xenbus_backend_exit(void);
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 1b178c6..4eff095 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -60,6 +60,7 @@
 #include <xen/hvm.h>
 
 #include "xenbus_comms.h"
+#include "xenbus_dev_backend.h"
 #include "xenbus_probe.h"
 
 
@@ -641,6 +642,10 @@ EXPORT_SYMBOL_GPL(xenbus_dev_cancel);
 /* A flag to determine if xenstored is 'ready' (i.e. has started) */
 int xenstored_ready;
 
+/* A flag to determine if xenstored is 'local' */
+#ifdef CONFIG_XEN_BACKEND
+static int xenstored_local;
+#endif
 
 int register_xenstore_notifier(struct notifier_block *nb)
 {
@@ -675,6 +680,14 @@ static int __init xenbus_probe_initcall(void)
 	if (!xen_domain())
 		return -ENODEV;
 
+#ifdef CONFIG_XEN_BACKEND
+	if (xenstored_local) {
+		int ret = xenbus_backend_init();
+		if (ret)
+			return ret;
+	}
+#endif
+
 	if (xen_initial_domain() || xen_hvm_domain())
 		return 0;
 
@@ -747,9 +760,14 @@ static int __init xenbus_init(void)
 		if (xen_store_evtchn)
 			xenstored_ready = 1;
 		else {
+#ifdef CONFIG_XEN_BACKEND
+			xenstored_local = 1;
 			err = xenstored_local_init();
 			if (err)
 				goto out_error;
+#else
+			BUG();
+#endif
 		}
 		xen_store_interface = mfn_to_virt(xen_store_mfn);
 	}
-- 
1.7.7.3

