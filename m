Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab0FCNMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:12:52 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:7383 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab0FCNLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:11:22 -0400
X-IronPort-AV: E=Sophos;i="4.53,354,1272859200"; 
   d="scan'208";a="99908934"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: Stefano.Stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
       jeremy@goop.org, ddutile@redhat.com, sheng@linux.intel.com,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 04/12] Xen PCI platform device driver
Date: Thu,  3 Jun 2010 14:10:37 +0100
Message-Id: <1275570645-27189-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-OriginalArrivalTime: 03 Jun 2010 13:11:21.0335 (UTC) FILETIME=[42B68070:01CB031E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Add the xen pci platform device driver that is responsible
for initializing the grant table and xenbus in PV on HVM mode.
Few changes to xenbus and grant table are necessary to allow the delayed
initialization in HVM mode.
Grant table needs few additional modifications to work in HVM mode.

The Xen PCI platform device raises an irq every time an event has been
delivered to us. However these interrupts are only delivered to vcpu 0.
The Xen PCI platform interrupt handler calls xen_hvm_evtchn_do_upcall
that is a little wrapper around __xen_evtchn_do_upcall, the traditional
Xen upcall handler, the very same used with traditional PV guests.

When running on HVM the event channel upcall is never called while in
progress because it is a normal Linux irq handler, therefore we cannot
be sure that evtchn_upcall_pending is 0 when returning.
For this reason if evtchn_upcall_pending is set by Xen we need to loop
again on the event channels set pending otherwise we might loose some
event channel deliveries.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 drivers/xen/Kconfig                 |    9 ++
 drivers/xen/Makefile                |    3 +-
 drivers/xen/events.c                |    7 +-
 drivers/xen/grant-table.c           |   69 ++++++++++++--
 drivers/xen/platform-pci.c          |  186 +++++++++++++++++++++++++++++++++++
 drivers/xen/xenbus/xenbus_probe.c   |   20 +++-
 include/linux/pci_ids.h             |    3 +
 include/xen/grant_table.h           |    1 +
 include/xen/interface/grant_table.h |    1 +
 include/xen/xenbus.h                |    1 +
 10 files changed, 284 insertions(+), 16 deletions(-)
 create mode 100644 drivers/xen/platform-pci.c

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index fad3df2..8819202 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -62,4 +62,13 @@ config XEN_SYS_HYPERVISOR
 	 virtual environment, /sys/hypervisor will still be present,
 	 but will have no xen contents.
 
+config XEN_PLATFORM_PCI
+	tristate "xen platform pci device driver"
+	depends on XEN
+	default y
+	help
+	  Driver for the Xen PCI Platform device: it is responsible for
+	  initializing xenbus and grant_table when running in a Xen HVM
+	  domain. As a consequence this driver is required to run any Xen PV
+	  frontend on Xen HVM.
 endmenu
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 7c28434..e392fb7 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -9,4 +9,5 @@ obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
 obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
 obj-$(CONFIG_XEN_DEV_EVTCHN)	+= evtchn.o
 obj-$(CONFIG_XENFS)		+= xenfs/
-obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
\ No newline at end of file
+obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
+obj-$(CONFIG_XEN_PLATFORM_PCI)	+= platform-pci.o
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 8604604..be378e1 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -665,7 +665,7 @@ static void __xen_evtchn_do_upcall(void)
 
 		count = __get_cpu_var(xed_nesting_count);
 		__get_cpu_var(xed_nesting_count) = 0;
-	} while(count != 1);
+	} while(count != 1 || vcpu_info->evtchn_upcall_pending);
 
 out:
 
@@ -725,7 +725,10 @@ static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 	struct evtchn_bind_vcpu bind_vcpu;
 	int evtchn = evtchn_from_irq(irq);
 
-	if (!VALID_EVTCHN(evtchn))
+	/* events delivered via platform PCI interrupts are always
+	 * routed to vcpu 0 */
+	if (!VALID_EVTCHN(evtchn) ||
+		(xen_hvm_domain() && !xen_have_vector_callback))
 		return -1;
 
 	/* Send future instances of this interrupt to other vcpu. */
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index f66db3b..4c959a5 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -37,11 +37,13 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/uaccess.h>
+#include <linux/io.h>
 
 #include <xen/xen.h>
 #include <xen/interface/xen.h>
 #include <xen/page.h>
 #include <xen/grant_table.h>
+#include <xen/interface/memory.h>
 #include <asm/xen/hypercall.h>
 
 #include <asm/pgtable.h>
@@ -59,6 +61,7 @@ static unsigned int boot_max_nr_grant_frames;
 static int gnttab_free_count;
 static grant_ref_t gnttab_free_head;
 static DEFINE_SPINLOCK(gnttab_list_lock);
+static unsigned long hvm_pv_resume_frames;
 
 static struct grant_entry *shared;
 
@@ -449,6 +452,30 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 	unsigned int nr_gframes = end_idx + 1;
 	int rc;
 
+	if (xen_hvm_domain()) {
+		struct xen_add_to_physmap xatp;
+		unsigned int i = end_idx;
+		rc = 0;
+		/*
+		 * Loop backwards, so that the first hypercall has the largest
+		 * index, ensuring that the table will grow only once.
+		 */
+		do {
+			xatp.domid = DOMID_SELF;
+			xatp.idx = i;
+			xatp.space = XENMAPSPACE_grant_table;
+			xatp.gpfn = (hvm_pv_resume_frames >> PAGE_SHIFT) + i;
+			rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
+			if (rc != 0) {
+				printk(KERN_WARNING
+						"grant table add_to_physmap failed, err=%d\n", rc);
+				break;
+			}
+		} while (i-- > start_idx);
+
+		return rc;
+	}
+
 	frames = kmalloc(nr_gframes * sizeof(unsigned long), GFP_ATOMIC);
 	if (!frames)
 		return -ENOMEM;
@@ -476,9 +503,28 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 
 int gnttab_resume(void)
 {
-	if (max_nr_grant_frames() < nr_grant_frames)
+	unsigned int max_nr_gframes;
+
+	max_nr_gframes = max_nr_grant_frames();
+	if (max_nr_gframes < nr_grant_frames)
 		return -ENOSYS;
-	return gnttab_map(0, nr_grant_frames - 1);
+
+	if (xen_pv_domain())
+		return gnttab_map(0, nr_grant_frames - 1);
+
+	if (!hvm_pv_resume_frames) {
+		hvm_pv_resume_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
+		shared = ioremap(hvm_pv_resume_frames, PAGE_SIZE * max_nr_gframes);
+		if (shared == NULL) {
+			printk(KERN_WARNING
+					"Fail to ioremap gnttab share frames\n");
+			return -ENOMEM;
+		}
+	}
+
+	gnttab_map(0, nr_grant_frames - 1);
+
+	return 0;
 }
 
 int gnttab_suspend(void)
@@ -505,15 +551,12 @@ static int gnttab_expand(unsigned int req_entries)
 	return rc;
 }
 
-static int __devinit gnttab_init(void)
+int gnttab_init(void)
 {
 	int i;
 	unsigned int max_nr_glist_frames, nr_glist_frames;
 	unsigned int nr_init_grefs;
 
-	if (!xen_domain())
-		return -ENODEV;
-
 	nr_grant_frames = 1;
 	boot_max_nr_grant_frames = __max_nr_grant_frames();
 
@@ -557,4 +600,16 @@ static int __devinit gnttab_init(void)
 	return -ENOMEM;
 }
 
-core_initcall(gnttab_init);
+static int __devinit __gnttab_init(void)
+{
+	/* Delay grant-table initialization in the PV on HVM case */
+	if (xen_hvm_domain())
+		return 0;
+
+	if (!xen_pv_domain())
+		return -ENODEV;
+
+	return gnttab_init();
+}
+
+core_initcall(__gnttab_init);
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
new file mode 100644
index 0000000..9cb7242
--- /dev/null
+++ b/drivers/xen/platform-pci.c
@@ -0,0 +1,186 @@
+/******************************************************************************
+ * platform-pci.c
+ *
+ * Xen platform PCI device driver
+ * Copyright (c) 2005, Intel Corporation.
+ * Copyright (c) 2007, XenSource Inc.
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
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include <xen/grant_table.h>
+#include <xen/xenbus.h>
+#include <xen/events.h>
+#include <xen/hvm.h>
+
+#define DRV_NAME    "xen-platform-pci"
+
+MODULE_AUTHOR("ssmith@xensource.com and stefano.stabellini@eu.citrix.com");
+MODULE_DESCRIPTION("Xen platform PCI device");
+MODULE_LICENSE("GPL");
+
+static unsigned long platform_mmio;
+static unsigned long platform_mmio_alloc;
+static unsigned long platform_mmiolen;
+
+unsigned long alloc_xen_mmio(unsigned long len)
+{
+	unsigned long addr;
+
+	addr = platform_mmio + platform_mmio_alloc;
+	platform_mmio_alloc += len;
+	BUG_ON(platform_mmio_alloc > platform_mmiolen);
+
+	return addr;
+}
+
+static uint64_t get_callback_via(struct pci_dev *pdev)
+{
+	u8 pin;
+	int irq;
+
+	irq = pdev->irq;
+	if (irq < 16)
+		return irq; /* ISA IRQ */
+
+	pin = pdev->pin;
+
+	/* We don't know the GSI. Specify the PCI INTx line instead. */
+	return ((uint64_t)0x01 << 56) | /* PCI INTx identifier */
+		((uint64_t)pci_domain_nr(pdev->bus) << 32) |
+		((uint64_t)pdev->bus->number << 16) |
+		((uint64_t)(pdev->devfn & 0xff) << 8) |
+		((uint64_t)(pin - 1) & 3);
+}
+
+static irqreturn_t do_hvm_evtchn_intr(int irq, void *dev_id)
+{
+	xen_hvm_evtchn_do_upcall();
+	return IRQ_HANDLED;
+}
+
+static int xen_allocate_irq(struct pci_dev *pdev)
+{
+	return request_irq(pdev->irq, do_hvm_evtchn_intr,
+			IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TRIGGER_RISING,
+			"xen-platform-pci", pdev);
+}
+
+static int __devinit platform_pci_init(struct pci_dev *pdev,
+				       const struct pci_device_id *ent)
+{
+	int i, ret;
+	long ioaddr, iolen;
+	long mmio_addr, mmio_len;
+	uint64_t callback_via;
+
+	i = pci_enable_device(pdev);
+	if (i)
+		return i;
+
+	ioaddr = pci_resource_start(pdev, 0);
+	iolen = pci_resource_len(pdev, 0);
+
+	mmio_addr = pci_resource_start(pdev, 1);
+	mmio_len = pci_resource_len(pdev, 1);
+
+	if (mmio_addr == 0 || ioaddr == 0) {
+		dev_err(&pdev->dev, "no resources found\n");
+		ret = -ENOENT;
+	}
+
+	if (request_mem_region(mmio_addr, mmio_len, DRV_NAME) == NULL) {
+		dev_err(&pdev->dev, "MEM I/O resource 0x%lx @ 0x%lx busy\n",
+		       mmio_addr, mmio_len);
+		ret = -EBUSY;
+	}
+
+	if (request_region(ioaddr, iolen, DRV_NAME) == NULL) {
+		dev_err(&pdev->dev, "I/O resource 0x%lx @ 0x%lx busy\n",
+		       iolen, ioaddr);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	platform_mmio = mmio_addr;
+	platform_mmiolen = mmio_len;
+
+	if (!xen_have_vector_callback) {
+		ret = xen_allocate_irq(pdev);
+		if (ret) {
+			printk(KERN_WARNING "request_irq failed err=%d\n", ret);
+			goto out;
+		}
+		callback_via = get_callback_via(pdev);
+		ret = xen_set_callback_via(callback_via);
+		if (ret) {
+			printk(KERN_WARNING
+					"Unable to set the evtchn callback err=%d\n", ret);
+			goto out;
+		}
+	}
+
+	ret = gnttab_init();
+	if (ret)
+		goto out;
+	ret = xenbus_probe_init();
+	if (ret)
+		goto out;
+
+out:
+	if (ret) {
+		release_mem_region(mmio_addr, mmio_len);
+		release_region(ioaddr, iolen);
+		pci_disable_device(pdev);
+	}
+
+	return ret;
+}
+
+static struct pci_device_id platform_pci_tbl[] __devinitdata = {
+	{PCI_VENDOR_ID_XEN, PCI_DEVICE_ID_XEN_PLATFORM,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{0,}
+};
+
+MODULE_DEVICE_TABLE(pci, platform_pci_tbl);
+
+static struct pci_driver platform_driver = {
+	.name =           DRV_NAME,
+	.probe =          platform_pci_init,
+	.id_table =       platform_pci_tbl,
+};
+
+static int __init platform_pci_module_init(void)
+{
+	int rc;
+
+	rc = pci_register_driver(&platform_driver);
+	if (rc) {
+		printk(KERN_INFO DRV_NAME
+		       ": No platform pci device model found\n");
+		return rc;
+	}
+	return 0;
+}
+
+module_init(platform_pci_module_init);
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 0b05b62..dc6ed06 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -782,16 +782,24 @@ void xenbus_probe(struct work_struct *unused)
 	blocking_notifier_call_chain(&xenstore_chain, 0, NULL);
 }
 
-static int __init xenbus_probe_init(void)
+static int __init __xenbus_probe_init(void)
+{
+	/* Delay initialization in the PV on HVM case */
+	if (xen_hvm_domain())
+		return 0;
+
+	if (!xen_pv_domain())
+		return -ENODEV;
+
+	return xenbus_probe_init();
+}
+
+int xenbus_probe_init(void)
 {
 	int err = 0;
 
 	DPRINTK("");
 
-	err = -ENODEV;
-	if (!xen_domain())
-		goto out_error;
-
 	/* Register ourselves with the kernel bus subsystem */
 	err = bus_register(&xenbus_frontend.bus);
 	if (err)
@@ -857,7 +865,7 @@ static int __init xenbus_probe_init(void)
 	return err;
 }
 
-postcore_initcall(xenbus_probe_init);
+postcore_initcall(__xenbus_probe_init);
 
 MODULE_LICENSE("GPL");
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 9f688d2..64b528d 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2718,3 +2718,6 @@
 #define PCI_DEVICE_ID_RME_DIGI32	0x9896
 #define PCI_DEVICE_ID_RME_DIGI32_PRO	0x9897
 #define PCI_DEVICE_ID_RME_DIGI32_8	0x9898
+
+#define PCI_VENDOR_ID_XEN	0x5853
+#define PCI_DEVICE_ID_XEN_PLATFORM	0x0001
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index a40f1cd..811cda5 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -51,6 +51,7 @@ struct gnttab_free_callback {
 	u16 count;
 };
 
+int gnttab_init(void);
 int gnttab_suspend(void);
 int gnttab_resume(void);
 
diff --git a/include/xen/interface/grant_table.h b/include/xen/interface/grant_table.h
index 39da93c..39e5717 100644
--- a/include/xen/interface/grant_table.h
+++ b/include/xen/interface/grant_table.h
@@ -28,6 +28,7 @@
 #ifndef __XEN_PUBLIC_GRANT_TABLE_H__
 #define __XEN_PUBLIC_GRANT_TABLE_H__
 
+#include <xen/interface/xen.h>
 
 /***********************************
  * GRANT TABLE REPRESENTATION
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 43e2d7d..ffa97de 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -174,6 +174,7 @@ void unregister_xenbus_watch(struct xenbus_watch *watch);
 void xs_suspend(void);
 void xs_resume(void);
 void xs_suspend_cancel(void);
+int xenbus_probe_init(void);
 
 /* Used by xenbus_dev to borrow kernel's store connection. */
 void *xenbus_dev_request_and_reply(struct xsd_sockmsg *msg);
-- 
1.7.0.4

