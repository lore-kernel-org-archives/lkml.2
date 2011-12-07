Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423Ab1LGVUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:20:00 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:42482 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757798Ab1LGVTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:19:24 -0500
From: Bastian Blank <waldi@debian.org>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: konrad.wilk@oracle.com
Subject: [PATCH 1/4] xen: Add privcmd device driver
Date: Wed,  7 Dec 2011 22:13:13 +0100
Message-Id: <1323292396-19523-2-git-send-email-waldi@debian.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323292396-19523-1-git-send-email-waldi@debian.org>
References: <1323292396-19523-1-git-send-email-waldi@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Access to arbitrary hypercalls is currently provided via xenfs. This
adds a standard character device to handle this. The support in xenfs
remains for backward compatibility and uses the device driver code.

Signed-off-by: Bastian Blank <waldi@debian.org>
---
 drivers/xen/Kconfig               |    7 ++++++
 drivers/xen/Makefile              |    2 +
 drivers/xen/{xenfs => }/privcmd.c |   39 ++++++++++++++++++++++++++++++++++++-
 drivers/xen/privcmd.h             |    3 ++
 drivers/xen/xenfs/Makefile        |    2 +-
 drivers/xen/xenfs/super.c         |    3 +-
 drivers/xen/xenfs/xenfs.h         |    1 -
 7 files changed, 53 insertions(+), 4 deletions(-)
 rename drivers/xen/{xenfs => }/privcmd.c (92%)
 create mode 100644 drivers/xen/privcmd.h

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 8795480..a1ced52 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -86,6 +86,7 @@ config XEN_BACKEND
 
 config XENFS
 	tristate "Xen filesystem"
+	select XEN_PRIVCMD
 	default y
 	help
 	  The xen filesystem provides a way for domains to share
@@ -171,4 +172,10 @@ config XEN_PCIDEV_BACKEND
 	  xen-pciback.hide=(03:00.0)(04:00.0)
 
 	  If in doubt, say m.
+
+config XEN_PRIVCMD
+	tristate
+	depends on XEN
+	default m
+
 endmenu
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 974fffd..aa31337 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -19,7 +19,9 @@ obj-$(CONFIG_XEN_TMEM)			+= tmem.o
 obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
 obj-$(CONFIG_XEN_DOM0)			+= pci.o
 obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
+obj-$(CONFIG_XEN_PRIVCMD)		+= xen-privcmd.o
 
 xen-evtchn-y				:= evtchn.o
 xen-gntdev-y				:= gntdev.o
 xen-gntalloc-y				:= gntalloc.o
+xen-privcmd-y				:= privcmd.o
diff --git a/drivers/xen/xenfs/privcmd.c b/drivers/xen/privcmd.c
similarity index 92%
rename from drivers/xen/xenfs/privcmd.c
rename to drivers/xen/privcmd.c
index dbd3b16..863fbd0 100644
--- a/drivers/xen/xenfs/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -18,6 +19,7 @@
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
 #include <linux/seq_file.h>
+#include <linux/miscdevice.h>
 
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
@@ -32,6 +34,10 @@
 #include <xen/page.h>
 #include <xen/xen-ops.h>
 
+#include "privcmd.h"
+
+MODULE_LICENSE("GPL");
+
 #ifndef HAVE_ARCH_PRIVCMD_MMAP
 static int privcmd_enforce_singleshot_mapping(struct vm_area_struct *vma);
 #endif
@@ -394,7 +400,38 @@ static int privcmd_enforce_singleshot_mapping(struct vm_area_struct *vma)
 }
 #endif
 
-const struct file_operations privcmd_file_ops = {
+const struct file_operations xen_privcmd_fops = {
+	.owner = THIS_MODULE,
 	.unlocked_ioctl = privcmd_ioctl,
 	.mmap = privcmd_mmap,
 };
+EXPORT_SYMBOL_GPL(xen_privcmd_fops);
+
+static struct miscdevice privcmd_dev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "xen/privcmd",
+	.fops = &xen_privcmd_fops,
+};
+
+static int __init privcmd_init(void)
+{
+	int err;
+
+	if (!xen_domain())
+		return -ENODEV;
+
+	err = misc_register(&privcmd_dev);
+	if (err != 0) {
+		printk(KERN_ERR "Could not register privcmd device\n");
+		return err;
+	}
+	return 0;
+}
+
+static void __exit privcmd_exit(void)
+{
+	misc_deregister(&privcmd_dev);
+}
+
+module_init(privcmd_init);
+module_exit(privcmd_exit);
diff --git a/drivers/xen/privcmd.h b/drivers/xen/privcmd.h
new file mode 100644
index 0000000..14facae
--- /dev/null
+++ b/drivers/xen/privcmd.h
@@ -0,0 +1,3 @@
+#include <linux/fs.h>
+
+extern const struct file_operations xen_privcmd_fops;
diff --git a/drivers/xen/xenfs/Makefile b/drivers/xen/xenfs/Makefile
index 4fde944..5d45ff1 100644
--- a/drivers/xen/xenfs/Makefile
+++ b/drivers/xen/xenfs/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_XENFS) += xenfs.o
 
-xenfs-y			  = super.o xenbus.o privcmd.o
+xenfs-y			  = super.o xenbus.o
 xenfs-$(CONFIG_XEN_DOM0) += xenstored.o
diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index 1aa3897..a55fbf9 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -16,6 +16,7 @@
 #include <xen/xen.h>
 
 #include "xenfs.h"
+#include "../privcmd.h"
 
 #include <asm/xen/hypervisor.h>
 
@@ -84,7 +85,7 @@ static int xenfs_fill_super(struct super_block *sb, void *data, int silent)
 		[1] = {},
 		{ "xenbus", &xenbus_file_ops, S_IRUSR|S_IWUSR },
 		{ "capabilities", &capabilities_file_ops, S_IRUGO },
-		{ "privcmd", &privcmd_file_ops, S_IRUSR|S_IWUSR },
+		{ "privcmd", &xen_privcmd_fops, S_IRUSR|S_IWUSR },
 		{""},
 	};
 	int rc;
diff --git a/drivers/xen/xenfs/xenfs.h b/drivers/xen/xenfs/xenfs.h
index b68aa62..5056306 100644
--- a/drivers/xen/xenfs/xenfs.h
+++ b/drivers/xen/xenfs/xenfs.h
@@ -2,7 +2,6 @@
 #define _XENFS_XENBUS_H
 
 extern const struct file_operations xenbus_file_ops;
-extern const struct file_operations privcmd_file_ops;
 extern const struct file_operations xsd_kva_file_ops;
 extern const struct file_operations xsd_port_file_ops;
 
-- 
1.7.7.3

