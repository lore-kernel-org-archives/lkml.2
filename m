Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab2KLLwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:52:44 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:57589 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2KLLwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:52:40 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 53/55] ARC: Hostlink Pseudo-Driver for Metaware Debugger
Date: Mon, 12 Nov 2012 17:19:11 +0530
Message-ID: <1352720953-24321-23-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

This allows ARC Target to do I/O to host in absence of any peripherals
whatsoever, assisted by Metaware Hostlink facility.

Further we have a FUSE based filesystem which makes us mount/access host
filesystem on target and do fops.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig               |    9 +++
 arch/arc/kernel/Makefile       |    1 +
 arch/arc/kernel/arc_hostlink.c |  114 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 124 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/kernel/arc_hostlink.c

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 79e8f2f..4653070 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -394,6 +394,15 @@ config HZ
 	int "Timer Frequency"
 	default 100
 
+config ARC_METAWARE_HLINK
+	bool "Support for Metaware debugger assisted Host access"
+	default n
+	help
+	  This options allows a Linux userland apps to directly access
+	  host file system (open/creat/read/write etc) with help from
+	  Metaware Debugger. This can come in handy for Linux-host communication
+	  when there is no real usable peripheral such as EMAC.
+
 menuconfig ARC_DBG
 	bool "ARC debugging"
 	default y
diff --git a/arch/arc/kernel/Makefile b/arch/arc/kernel/Makefile
index a2b7493..ce14b45 100644
--- a/arch/arc/kernel/Makefile
+++ b/arch/arc/kernel/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_ARC_DW2_UNWIND)		+= unwind.o
 obj-$(CONFIG_KPROBES)      		+= kprobes.o
 obj-$(CONFIG_ARC_MISALIGN_ACCESS) 	+= unaligned.o
 obj-$(CONFIG_KGDB)			+= kgdb.o
+obj-$(CONFIG_ARC_METAWARE_HLINK)	+= arc_hostlink.o
 
 obj-$(CONFIG_ARC_FPU_SAVE_RESTORE)	+= fpu.o
 CFLAGS_fpu.o   += -mdpfp
diff --git a/arch/arc/kernel/arc_hostlink.c b/arch/arc/kernel/arc_hostlink.c
new file mode 100644
index 0000000..de3bc42
--- /dev/null
+++ b/arch/arc/kernel/arc_hostlink.c
@@ -0,0 +1,114 @@
+/*
+ * arc_hostlink.c: Pseudo-driver for Metaware provided "hostlink" facility
+ *
+ * Allows Linux userland access to host in absence of any peripherals.
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/fs.h>		/* file_operations */
+#include <linux/device.h>	/* class_create */
+#include <linux/cdev.h>		/* cdev */
+#include <linux/mm.h>		/* VM_IO */
+#include <linux/module.h>
+#include <linux/uaccess.h>
+
+static unsigned char __HOSTLINK__[4 * PAGE_SIZE] __aligned(PAGE_SIZE);
+
+static int arc_hl_mmap(struct file *fp, struct vm_area_struct *vma);
+static long arc_hl_ioctl(struct file *file, unsigned int cmd,
+			unsigned long arg);
+
+static const struct file_operations arc_hl_fops = {
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl	= arc_hl_ioctl,
+	.mmap		= arc_hl_mmap,
+};
+
+static int arc_hl_major;
+static int arc_hl_minor;
+static int arc_hl_nr_devs = 1;
+static const char arc_hl_devnm[] = "hostlink";
+static struct cdev arc_hl_cdev;
+static struct class *arc_hl_class;
+
+static int __init arc_hl_linux_glue(void)
+{
+	dev_t arc_hl_dev;
+	int i;
+
+	if (arc_hl_major) {	/* Preallocated MAJOR */
+
+		arc_hl_dev = MKDEV(arc_hl_major, arc_hl_minor);
+		register_chrdev_region(arc_hl_dev, arc_hl_nr_devs,
+				       arc_hl_devnm);
+	} else {		/* allocates Major to devices */
+		alloc_chrdev_region(&arc_hl_dev, 0, arc_hl_nr_devs,
+				    arc_hl_devnm);
+		arc_hl_major = MAJOR(arc_hl_dev);
+	}
+
+	/* Populate sysfs entries: creates /sys/class/ sub-node for device */
+
+	arc_hl_class = class_create(THIS_MODULE, arc_hl_devnm);
+
+	/* connect file ops with cdev */
+
+	cdev_init(&arc_hl_cdev, &arc_hl_fops);
+	arc_hl_cdev.owner = THIS_MODULE;
+
+	/* Connect major/minor number to cdev
+	 * makes device available.
+	 *  device nodes created with 'mknod` are probably already active.
+	 */
+
+	cdev_add(&arc_hl_cdev, arc_hl_dev, arc_hl_nr_devs);
+
+	/* creates /sys/devices/virtual/<dev_name>/<names[i]> node with
+	 *      link from/sys/class/<dev_name>, needed by mdev.
+	 */
+
+	for (i = 0; i < arc_hl_nr_devs; i++)
+		device_create(arc_hl_class, NULL, MKDEV(MAJOR(arc_hl_dev), i),
+			      NULL, arc_hl_devnm);
+
+	pr_info("Hostlink dev to mknod is %d:%d\n",
+		arc_hl_major, arc_hl_minor);
+	return 0;
+}
+
+static int __init arc_hl_init(void)
+{
+	arc_hl_linux_glue();
+
+	pr_info("Hlink buffer mmap @ 0x%p\n", __HOSTLINK__);
+
+	return 0;
+}
+
+static int arc_hl_mmap(struct file *fp, struct vm_area_struct *vma)
+{
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			       vma->vm_end - vma->vm_start,
+			       vma->vm_page_prot)) {
+		pr_warn("Hostlink buffer mmap ERROR\n");
+		return -EAGAIN;
+	}
+	return 0;
+}
+
+static long arc_hl_ioctl(struct file *file, unsigned int cmd,
+			unsigned long arg)
+{
+	/* we only support, returning the physical addr to mmap in user space */
+	put_user((unsigned int)__HOSTLINK__, (int __user *)arg);
+	return 0;
+}
+
+module_init(arc_hl_init);
-- 
1.7.4.1

