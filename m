Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab1LGVT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:19:58 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:42480 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899Ab1LGVTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:19:24 -0500
From: Bastian Blank <waldi@debian.org>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: konrad.wilk@oracle.com
Subject: [PATCH 2/4] xen: Add xenbus device driver
Date: Wed,  7 Dec 2011 22:13:14 +0100
Message-Id: <1323292396-19523-3-git-send-email-waldi@debian.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323292396-19523-1-git-send-email-waldi@debian.org>
References: <1323292396-19523-1-git-send-email-waldi@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Access to xenbus is currently handled via xenfs. This adds a device
driver for xenbus and makes xenfs use this code.

Signed-off-by: Bastian Blank <waldi@debian.org>
---
 drivers/xen/xenbus/Makefile                        |    1 +
 drivers/xen/xenbus/xenbus_comms.h                  |    4 ++
 .../xenbus.c => xenbus/xenbus_dev_frontend.c}      |   37 ++++++++++++++++++--
 drivers/xen/xenfs/Makefile                         |    2 +-
 drivers/xen/xenfs/super.c                          |    3 +-
 drivers/xen/xenfs/xenfs.h                          |    1 -
 6 files changed, 42 insertions(+), 6 deletions(-)
 rename drivers/xen/{xenfs/xenbus.c => xenbus/xenbus_dev_frontend.c} (95%)

diff --git a/drivers/xen/xenbus/Makefile b/drivers/xen/xenbus/Makefile
index 8dca685..a2ea363 100644
--- a/drivers/xen/xenbus/Makefile
+++ b/drivers/xen/xenbus/Makefile
@@ -1,4 +1,5 @@
 obj-y	+= xenbus.o
+obj-y	+= xenbus_dev_frontend.o
 
 xenbus-objs =
 xenbus-objs += xenbus_client.o
diff --git a/drivers/xen/xenbus/xenbus_comms.h b/drivers/xen/xenbus/xenbus_comms.h
index c21db75..6e42800 100644
--- a/drivers/xen/xenbus/xenbus_comms.h
+++ b/drivers/xen/xenbus/xenbus_comms.h
@@ -31,6 +31,8 @@
 #ifndef _XENBUS_COMMS_H
 #define _XENBUS_COMMS_H
 
+#include <linux/fs.h>
+
 int xs_init(void);
 int xb_init_comms(void);
 
@@ -43,4 +45,6 @@ int xs_input_avail(void);
 extern struct xenstore_domain_interface *xen_store_interface;
 extern int xen_store_evtchn;
 
+extern const struct file_operations xen_xenbus_fops;
+
 #endif /* _XENBUS_COMMS_H */
diff --git a/drivers/xen/xenfs/xenbus.c b/drivers/xen/xenbus/xenbus_dev_frontend.c
similarity index 95%
rename from drivers/xen/xenfs/xenbus.c
rename to drivers/xen/xenbus/xenbus_dev_frontend.c
index bbd000f..fb30cff 100644
--- a/drivers/xen/xenfs/xenbus.c
+++ b/drivers/xen/xenbus/xenbus_dev_frontend.c
@@ -52,13 +52,16 @@
 #include <linux/namei.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
 
-#include "xenfs.h"
-#include "../xenbus/xenbus_comms.h"
+#include "xenbus_comms.h"
 
 #include <xen/xenbus.h>
 #include <asm/xen/hypervisor.h>
 
+MODULE_LICENSE("GPL");
+
 /*
  * An element of a list of outstanding transactions, for which we're
  * still waiting a reply.
@@ -583,7 +586,7 @@ static unsigned int xenbus_file_poll(struct file *file, poll_table *wait)
 	return 0;
 }
 
-const struct file_operations xenbus_file_ops = {
+const struct file_operations xen_xenbus_fops = {
 	.read = xenbus_file_read,
 	.write = xenbus_file_write,
 	.open = xenbus_file_open,
@@ -591,3 +594,31 @@ const struct file_operations xenbus_file_ops = {
 	.poll = xenbus_file_poll,
 	.llseek = no_llseek,
 };
+EXPORT_SYMBOL_GPL(xen_xenbus_fops);
+
+static struct miscdevice xenbus_dev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "xen/xenbus",
+	.fops = &xen_xenbus_fops,
+};
+
+static int __init xenbus_init(void)
+{
+	int err;
+
+	if (!xen_domain())
+		return -ENODEV;
+
+	err = misc_register(&xenbus_dev);
+	if (err)
+		printk(KERN_ERR "Could not register xenbus device\n");
+	return err;
+}
+
+static void __exit xenbus_exit(void)
+{
+	misc_deregister(&xenbus_dev);
+}
+
+module_init(xenbus_init);
+module_exit(xenbus_exit);
diff --git a/drivers/xen/xenfs/Makefile b/drivers/xen/xenfs/Makefile
index 5d45ff1..b019865 100644
--- a/drivers/xen/xenfs/Makefile
+++ b/drivers/xen/xenfs/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_XENFS) += xenfs.o
 
-xenfs-y			  = super.o xenbus.o
+xenfs-y			  = super.o
 xenfs-$(CONFIG_XEN_DOM0) += xenstored.o
diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index a55fbf9..a84b53c 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -17,6 +17,7 @@
 
 #include "xenfs.h"
 #include "../privcmd.h"
+#include "../xenbus/xenbus_comms.h"
 
 #include <asm/xen/hypervisor.h>
 
@@ -83,7 +84,7 @@ static int xenfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	static struct tree_descr xenfs_files[] = {
 		[1] = {},
-		{ "xenbus", &xenbus_file_ops, S_IRUSR|S_IWUSR },
+		{ "xenbus", &xen_xenbus_fops, S_IRUSR|S_IWUSR },
 		{ "capabilities", &capabilities_file_ops, S_IRUGO },
 		{ "privcmd", &xen_privcmd_fops, S_IRUSR|S_IWUSR },
 		{""},
diff --git a/drivers/xen/xenfs/xenfs.h b/drivers/xen/xenfs/xenfs.h
index 5056306..6b80c77 100644
--- a/drivers/xen/xenfs/xenfs.h
+++ b/drivers/xen/xenfs/xenfs.h
@@ -1,7 +1,6 @@
 #ifndef _XENFS_XENBUS_H
 #define _XENFS_XENBUS_H
 
-extern const struct file_operations xenbus_file_ops;
 extern const struct file_operations xsd_kva_file_ops;
 extern const struct file_operations xsd_port_file_ops;
 
-- 
1.7.7.3

