Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0FCNLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:11:42 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30773 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab0FCNLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:11:38 -0400
X-IronPort-AV: E=Sophos;i="4.53,354,1272859200"; 
   d="scan'208";a="99909031"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: Stefano.Stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
       jeremy@goop.org, ddutile@redhat.com, sheng@linux.intel.com,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 12/12] Unplug emulated disks and nics
Date: Thu,  3 Jun 2010 14:10:45 +0100
Message-Id: <1275570645-27189-12-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-OriginalArrivalTime: 03 Jun 2010 13:11:37.0147 (UTC) FILETIME=[4C2338B0:01CB031E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Add a xen_emul_unplug command line option to the kernel to unplug
xen emulated disks and nics.

Set the default value of xen_emul_unplug depending on whether or
not the Xen PV frontends and the Xen platform PCI driver have
been compiled for this kernel (modules or built-in are both OK).

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 Documentation/kernel-parameters.txt |   11 +++
 arch/x86/xen/Makefile               |    2 +-
 arch/x86/xen/enlighten.c            |    1 +
 arch/x86/xen/platform-pci-unplug.c  |  131 +++++++++++++++++++++++++++++++++++
 arch/x86/xen/xen-ops.h              |    1 +
 drivers/xen/platform-pci.c          |    4 +
 drivers/xen/xenbus/xenbus_probe.c   |    4 +
 include/xen/platform_pci.h          |   27 +++++++
 8 files changed, 180 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/xen/platform-pci-unplug.c
 create mode 100644 include/xen/platform_pci.h

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 839b21b..716eea8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -113,6 +113,7 @@ parameter is applicable:
 			More X86-64 boot options can be found in
 			Documentation/x86/x86_64/boot-options.txt .
 	X86	Either 32bit or 64bit x86 (same as X86-32+X86-64)
+	XEN	Xen support is enabled
 
 In addition, the following text indicates that the option:
 
@@ -2834,6 +2835,16 @@ and is between 256 and 4096 characters. It is defined in the file
 	xd=		[HW,XT] Original XT pre-IDE (RLL encoded) disks.
 	xd_geo=		See header of drivers/block/xd.c.
 
+	xen_emul_unplug=		[HW,X86,XEN]
+			Unplug Xen emulated devices
+			Format: [unplug0,][unplug1]
+			ide-disks -- unplug primary master IDE devices
+			aux-ide-disks -- unplug non-primary-master IDE devices
+			nics -- unplug network devices
+			all -- unplug all emulated devices (NICs and IDE disks)
+			ignore -- continue loading the Xen platform PCI driver even
+				if the version check failed
+
 	xirc2ps_cs=	[NET,PCMCIA]
 			Format:
 			<irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]]
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 3bb4fc2..9309546 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -12,7 +12,7 @@ CFLAGS_mmu.o			:= $(nostackp)
 
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			time.o xen-asm.o xen-asm_$(BITS).o \
-			grant-table.o suspend.o
+			grant-table.o suspend.o platform-pci-unplug.o
 
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index e90dfcd..209cfd9 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1354,6 +1354,7 @@ void __init xen_guest_init(void)
 	if (xen_feature(XENFEAT_hvm_callback_vector))
 		xen_have_vector_callback = 1;
 	register_cpu_notifier(&xen_hvm_cpu_notifier);
+	xen_unplug_emulated_devices();
 	have_vcpu_info_placement = 0;
 	x86_init.irqs.intr_init = xen_init_IRQ;
 	init_hvm_time();
diff --git a/arch/x86/xen/platform-pci-unplug.c b/arch/x86/xen/platform-pci-unplug.c
new file mode 100644
index 0000000..1de8e6d
--- /dev/null
+++ b/arch/x86/xen/platform-pci-unplug.c
@@ -0,0 +1,131 @@
+/******************************************************************************
+ * platform-pci-unplug.c
+ *
+ * Xen platform PCI device driver
+ * Copyright (c) 2010, Citrix
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ */
+
+#include <asm/io.h>
+
+#include <linux/init.h>
+#include <linux/module.h>
+
+#include <xen/platform_pci.h>
+
+/* boolean to signal that the platform pci device can be used */
+bool xen_platform_pci_enabled;
+EXPORT_SYMBOL_GPL(xen_platform_pci_enabled);
+static int xen_emul_unplug;
+
+static int __init check_platform_magic(void)
+{
+	short magic;
+	char protocol;
+
+	magic = inw(XEN_IOPORT_MAGIC);
+	if (magic != XEN_IOPORT_MAGIC_VAL) {
+		printk(KERN_ERR "Xen Platform PCI: unrecognised magic value\n");
+		return -1;
+	}
+
+	protocol = inb(XEN_IOPORT_PROTOVER);
+
+	printk(KERN_DEBUG "Xen Platform PCI: I/O protocol version %d\n",
+			protocol);
+
+	switch (protocol) {
+	case 1:
+		outw(XEN_IOPORT_LINUX_PRODNUM, XEN_IOPORT_PRODNUM);
+		outl(XEN_IOPORT_LINUX_DRVVER, XEN_IOPORT_DRVVER);
+		if (inw(XEN_IOPORT_MAGIC) != XEN_IOPORT_MAGIC_VAL) {
+			printk(KERN_ERR "Xen Platform: blacklisted by host\n");
+			return -3;
+		}
+		break;
+	default:
+		printk(KERN_WARNING "Xen Platform PCI: unknown I/O protocol version");
+		return -2;
+	}
+
+	return 0;
+}
+
+void __init xen_unplug_emulated_devices(void)
+{
+	int r;
+
+	/* check the version of the xen platform PCI device */
+	r = check_platform_magic();
+	/* If the version matches enable the Xen platform PCI driver.
+	 * Also enable the Xen platform PCI driver if the version is really old
+	 * and the user told us to ignore it. */
+	if (!r || (r == -1 && (xen_emul_unplug & XEN_UNPLUG_IGNORE)))
+		xen_platform_pci_enabled = 1;
+	/* Set the default value of xen_emul_unplug depending on whether or
+	 * not the Xen PV frontends and the Xen platform PCI driver have
+	 * been compiled for this kernel (modules or built-in are both OK). */
+	if (xen_platform_pci_enabled && !xen_emul_unplug) {
+#if (defined(CONFIG_XEN_NETDEV_FRONTEND) || \
+		defined(CONFIG_XEN_NETDEV_FRONTEND_MODULE)) && \
+		(defined(CONFIG_XEN_PLATFORM_PCI) || \
+		 defined(CONFIG_XEN_PLATFORM_PCI_MODULE))
+		printk(KERN_INFO "Netfront and the Xen platform PCI driver have "
+				"been compiled for this kernel: unplug emulated NICs.\n");
+		xen_emul_unplug |= XEN_UNPLUG_ALL_NICS;
+#endif
+#if (defined(CONFIG_XEN_BLKDEV_FRONTEND) || \
+		defined(CONFIG_XEN_BLKDEV_FRONTEND_MODULE)) && \
+		(defined(CONFIG_XEN_PLATFORM_PCI) || \
+		 defined(CONFIG_XEN_PLATFORM_PCI_MODULE))
+		printk(KERN_INFO "Blkfront and the Xen platform PCI driver have "
+				"been compiled for this kernel: unplug emulated disks.\n"
+				"You might have to change the root device\n"
+				"from /dev/hd[a-d] to /dev/xvd[a-d]\n"
+				"in your root= kernel command line option\n");
+		xen_emul_unplug |= XEN_UNPLUG_ALL_IDE_DISKS;
+#endif
+	}
+	/* Now unplug the emulated devices */
+	if (xen_platform_pci_enabled && !(xen_emul_unplug & XEN_UNPLUG_IGNORE))
+		outw(xen_emul_unplug, XEN_IOPORT_UNPLUG);
+}
+
+static int __init parse_xen_emul_unplug(char *arg)
+{
+	char *p, *q;
+
+	for (p = arg; p; p = q) {
+		q = strchr(arg, ',');
+		if (q)
+			*q++ = '\0';
+		if (!strcmp(p, "all"))
+			xen_emul_unplug |= XEN_UNPLUG_ALL;
+		else if (!strcmp(p, "ide-disks"))
+			xen_emul_unplug |= XEN_UNPLUG_ALL_IDE_DISKS;
+		else if (!strcmp(p, "aux-ide-disks"))
+			xen_emul_unplug |= XEN_UNPLUG_AUX_IDE_DISKS;
+		else if (!strcmp(p, "nics"))
+			xen_emul_unplug |= XEN_UNPLUG_ALL_NICS;
+		else if (!strcmp(p, "ignore"))
+			xen_emul_unplug |= XEN_UNPLUG_IGNORE;
+		else
+			printk(KERN_WARNING "unrecognised option '%s' "
+				 "in module parameter 'dev_unplug'\n", p);
+	}
+	return 0;
+}
+early_param("xen_emul_unplug", parse_xen_emul_unplug);
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 01c9dd3..615e037 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -40,6 +40,7 @@ void xen_vcpu_restore(void);
 
 void xen_callback_vector(void);
 void xen_hvm_init_shared_info(void);
+void __init xen_unplug_emulated_devices(void);
 
 void __init xen_build_dynamic_phys_to_machine(void);
 
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index 6285bd9..32ec950 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 
+#include <xen/platform_pci.h>
 #include <xen/grant_table.h>
 #include <xen/xenbus.h>
 #include <xen/events.h>
@@ -198,6 +199,9 @@ static int __init platform_pci_module_init(void)
 {
 	int rc;
 
+	if (!xen_platform_pci_enabled)
+		return -ENODEV;
+
 	rc = pci_register_driver(&platform_driver);
 	if (rc) {
 		printk(KERN_INFO DRV_NAME
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index cf971da..b9427da 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -56,6 +56,7 @@
 #include <xen/events.h>
 #include <xen/page.h>
 
+#include <xen/platform_pci.h>
 #include <xen/hvm.h>
 
 #include "xenbus_comms.h"
@@ -974,6 +975,9 @@ static void wait_for_devices(struct xenbus_driver *xendrv)
 #ifndef MODULE
 static int __init boot_wait_for_devices(void)
 {
+	if (xen_hvm_domain() && !xen_platform_pci_enabled)
+		return -ENODEV;
+
 	ready_to_wait_for_devices = 1;
 	wait_for_devices(NULL);
 	return 0;
diff --git a/include/xen/platform_pci.h b/include/xen/platform_pci.h
new file mode 100644
index 0000000..22f5a13
--- /dev/null
+++ b/include/xen/platform_pci.h
@@ -0,0 +1,27 @@
+#ifndef _XEN_PLATFORM_PCI_H
+#define _XEN_PLATFORM_PCI_H
+
+#define XEN_IOPORT_MAGIC_VAL 0x49d2
+#define XEN_IOPORT_LINUX_PRODNUM 0x0003
+#define XEN_IOPORT_LINUX_DRVVER  0x0001
+
+#define XEN_IOPORT_BASE 0x10
+
+#define XEN_IOPORT_PLATFLAGS	(XEN_IOPORT_BASE + 0) /* 1 byte access (R/W) */
+#define XEN_IOPORT_MAGIC	(XEN_IOPORT_BASE + 0) /* 2 byte access (R) */
+#define XEN_IOPORT_UNPLUG	(XEN_IOPORT_BASE + 0) /* 2 byte access (W) */
+#define XEN_IOPORT_DRVVER	(XEN_IOPORT_BASE + 0) /* 4 byte access (W) */
+
+#define XEN_IOPORT_SYSLOG	(XEN_IOPORT_BASE + 2) /* 1 byte access (W) */
+#define XEN_IOPORT_PROTOVER	(XEN_IOPORT_BASE + 2) /* 1 byte access (R) */
+#define XEN_IOPORT_PRODNUM	(XEN_IOPORT_BASE + 2) /* 2 byte access (W) */
+
+#define XEN_UNPLUG_ALL_IDE_DISKS 1
+#define XEN_UNPLUG_ALL_NICS 2
+#define XEN_UNPLUG_AUX_IDE_DISKS 4
+#define XEN_UNPLUG_ALL 7
+#define XEN_UNPLUG_IGNORE 8
+
+extern bool xen_platform_pci_enabled;
+
+#endif /* _XEN_PLATFORM_PCI_H */
-- 
1.7.0.4

