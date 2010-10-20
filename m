Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab0JTBhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 21:37:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:62723 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757312Ab0JTBhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 21:37:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,353,1283756400"; 
   d="scan'208";a="565620670"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 9/9] ACPI, APEI, Generic Hardware Error Source POLL/IRQ/NMI notification type support
Date: Wed, 20 Oct 2010 09:37:00 +0800
Message-Id: <1287538620-7442-10-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
References: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic Hardware Error Source provides a way to report platform
hardware errors (such as that from chipset). It works in so called
"Firmware First" mode, that is, hardware errors are reported to
firmware firstly, then reported to Linux by firmware. This way, some
non-standard hardware error registers or non-standard hardware link
can be checked by firmware to produce more valuable hardware error
information for Linux.

This patch adds POLL/IRQ/NMI notification types support.

Because the memory area used to transfer hardware error information
from BIOS to Linux can be determined only in NMI, IRQ or timer
handler, but general ioremap can not be used in atomic context, so a
special version of atomic ioremap is implemented for that.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/kernel/acpi/boot.c |    1 
 arch/x86/kernel/dumpstack.c |    1 
 drivers/acpi/apei/ghes.c    |  366 +++++++++++++++++++++++++++++++++++---------
 kernel/panic.c              |    1 
 lib/ioremap.c               |    2 
 mm/vmalloc.c                |    1 
 6 files changed, 304 insertions(+), 68 deletions(-)

--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -512,6 +512,7 @@ int acpi_isa_irq_to_gsi(unsigned isa_irq
 	*gsi = irq_to_gsi(isa_irq);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
 
 /*
  * success: return IRQ number (>=0)
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -240,6 +240,7 @@ unsigned __kprobes long oops_begin(void)
 	bust_spinlocks(1);
 	return flags;
 }
+EXPORT_SYMBOL_GPL(oops_begin);
 
 void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 {
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -12,10 +12,6 @@
  * For more information about Generic Hardware Error Source, please
  * refer to ACPI Specification version 4.0, section 17.3.2.6
  *
- * Now, only SCI notification type and memory errors are
- * supported. More notification type and hardware error type will be
- * added later.
- *
  * Copyright 2010 Intel Corp.
  *   Author: Huang Ying <ying.huang@intel.com>
  *
@@ -39,15 +35,18 @@
 #include <linux/acpi.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
+#include <linux/timer.h>
 #include <linux/cper.h>
 #include <linux/kdebug.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
+#include <linux/vmalloc.h>
 #include <linux/herror.h>
 #include <acpi/apei.h>
 #include <acpi/atomicio.h>
 #include <acpi/hed.h>
 #include <asm/mce.h>
+#include <asm/tlbflush.h>
 
 #include "apei-internal.h"
 
@@ -56,42 +55,116 @@
 #define GHES_ESTATUS_MAX_SIZE		65536
 
 /*
- * One struct ghes is created for each generic hardware error
- * source.
- *
+ * One struct ghes is created for each generic hardware error source.
  * It provides the context for APEI hardware error timer/IRQ/SCI/NMI
- * handler. Handler for one generic hardware error source is only
- * triggered after the previous one is done. So handler can uses
- * struct ghes without locking.
+ * handler.
  *
  * estatus: memory buffer for error status block, allocated during
  * HEST parsing.
  */
 #define GHES_TO_CLEAR		0x0001
+#define GHES_EXITING		0x0002
 
 struct ghes {
 	struct acpi_hest_generic *generic;
 	struct acpi_hest_generic_status *estatus;
-	struct list_head list;
 	u64 buffer_paddr;
 	unsigned long flags;
 	struct herr_dev *herr_dev;
+	union {
+		struct list_head list;
+		struct timer_list timer;
+		unsigned int irq;
+	};
 };
 
+static int ghes_panic_timeout	__read_mostly = 30;
+
 /*
- * Error source lists, one list for each notification method. The
- * members in lists are struct ghes.
+ * All error sources notified with SCI shares one notifier function,
+ * so they need to be linked and checked one by one.  This is applied
+ * to NMI too.
  *
- * The list members are only added in HEST parsing and deleted during
- * module_exit, that is, single-threaded. So no lock is needed for
- * that.
+ * RCU is used for these lists, so ghes_list_mutex is only used only
+ * for list changing, not for traversing.
  *
- * But the mutual exclusion is needed between members adding/deleting
- * and timer/IRQ/SCI/NMI handler, which may traverse the list. RCU is
- * used for that.
+ * NMI may be triggered on any CPU, so ghes_nmi_lock is used for
+ * mutual exclusion of ghest_nmi list.
  */
 static LIST_HEAD(ghes_sci);
+static LIST_HEAD(ghes_nmi);
 static DEFINE_MUTEX(ghes_list_mutex);
+static DEFINE_RAW_SPINLOCK(ghes_nmi_lock);
+
+/*
+ * Because the memory area used to transfer hardware error information
+ * from BIOS to Linux can be determined only in NMI, IRQ or timer
+ * handler, but general ioremap can not be used in atomic context, so
+ * a special version of atomic ioremap is implemented for that.
+ */
+
+/* virtual memory area for atomic ioremap */
+static struct vm_struct *ghes_ioremap_area;
+/*
+ * These 2 spinlock is used to prevent atomic ioremap virtual memory
+ * area from being mapped simultaneously.
+ */
+static DEFINE_RAW_SPINLOCK(ghes_ioremap_lock_nmi);
+static DEFINE_SPINLOCK(ghes_ioremap_lock_irq);
+
+static int ghes_ioremap_init(void)
+{
+	ghes_ioremap_area = __get_vm_area(PAGE_SIZE * 2, VM_IOREMAP,
+					  VMALLOC_START, VMALLOC_END);
+	if (!ghes_ioremap_area) {
+		pr_err(GHES_PFX
+		"Failed to allocate virtual memory area for atomic ioremap.\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void ghes_ioremap_exit(void)
+{
+	free_vm_area(ghes_ioremap_area);
+}
+
+static void *ghes_ioremap_pfn_nmi(u64 pfn)
+{
+	unsigned long vaddr;
+
+	vaddr = (unsigned long)ghes_ioremap_area->addr;
+	ioremap_page_range(vaddr, vaddr + PAGE_SIZE,
+			   pfn << PAGE_SHIFT, PAGE_KERNEL);
+
+	return (void *)vaddr;
+}
+
+static void *ghes_ioremap_pfn_irq(u64 pfn)
+{
+	unsigned long vaddr;
+
+	vaddr = (unsigned long)ghes_ioremap_area->addr + PAGE_SIZE;
+	ioremap_page_range(vaddr, vaddr + PAGE_SIZE,
+			   pfn << PAGE_SHIFT, PAGE_KERNEL);
+
+	return (void *)vaddr;
+}
+
+static void ghes_iounmap_nmi(void *vaddr)
+{
+	BUG_ON(vaddr != ghes_ioremap_area->addr);
+	unmap_kernel_range_noflush((unsigned long)vaddr, PAGE_SIZE);
+	__flush_tlb_one((unsigned long)vaddr);
+}
+
+static void ghes_iounmap_irq(void *vaddr)
+{
+	BUG_ON(vaddr != ghes_ioremap_area->addr + PAGE_SIZE);
+	unmap_kernel_range_noflush((unsigned long)vaddr, PAGE_SIZE);
+	__flush_tlb_one((unsigned long)vaddr);
+}
 
 static struct ghes *ghes_new(struct acpi_hest_generic *generic)
 {
@@ -103,7 +176,6 @@ static struct ghes *ghes_new(struct acpi
 	if (!ghes)
 		return ERR_PTR(-ENOMEM);
 	ghes->generic = generic;
-	INIT_LIST_HEAD(&ghes->list);
 	rc = acpi_pre_map_gar(&generic->error_status_address);
 	if (rc)
 		goto err_free;
@@ -160,22 +232,41 @@ static inline int ghes_severity(int seve
 	}
 }
 
-/* SCI handler run in work queue, so ioremap can be used here */
-static int ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
-				 int from_phys)
+static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
+				  int from_phys)
 {
 	void *vaddr;
-
-	vaddr = ioremap_cache(paddr, len);
-	if (!vaddr)
-		return -ENOMEM;
-	if (from_phys)
-		memcpy(buffer, vaddr, len);
-	else
-		memcpy(vaddr, buffer, len);
-	iounmap(vaddr);
-
-	return 0;
+	unsigned long flags = 0;
+	int in_nmi = in_nmi();
+	u64 offset;
+	u32 trunk;
+
+	while (len > 0) {
+		offset = paddr - (paddr & PAGE_MASK);
+		if (in_nmi) {
+			raw_spin_lock(&ghes_ioremap_lock_nmi);
+			vaddr = ghes_ioremap_pfn_nmi(paddr >> PAGE_SHIFT);
+		} else {
+			spin_lock_irqsave(&ghes_ioremap_lock_irq, flags);
+			vaddr = ghes_ioremap_pfn_irq(paddr >> PAGE_SHIFT);
+		}
+		trunk = PAGE_SIZE - offset;
+		trunk = min(trunk, len);
+		if (from_phys)
+			memcpy(buffer, vaddr + offset, trunk);
+		else
+			memcpy(vaddr + offset, buffer, trunk);
+		len -= trunk;
+		paddr += trunk;
+		buffer += trunk;
+		if (in_nmi) {
+			ghes_iounmap_nmi(vaddr);
+			raw_spin_unlock(&ghes_ioremap_lock_nmi);
+		} else {
+			ghes_iounmap_irq(vaddr);
+			spin_unlock_irqrestore(&ghes_ioremap_lock_irq, flags);
+		}
+	}
 }
 
 static int ghes_read_estatus(struct ghes *ghes, int silent)
@@ -196,10 +287,8 @@ static int ghes_read_estatus(struct ghes
 	if (!buf_paddr)
 		return -ENOENT;
 
-	rc = ghes_copy_tofrom_phys(ghes->estatus, buf_paddr,
-				   sizeof(*ghes->estatus), 1);
-	if (rc)
-		return rc;
+	ghes_copy_tofrom_phys(ghes->estatus, buf_paddr,
+			      sizeof(*ghes->estatus), 1);
 	if (!ghes->estatus->block_status)
 		return -ENOENT;
 
@@ -214,17 +303,15 @@ static int ghes_read_estatus(struct ghes
 		goto err_read_block;
 	if (apei_estatus_check_header(ghes->estatus))
 		goto err_read_block;
-	rc = ghes_copy_tofrom_phys(ghes->estatus + 1,
-				   buf_paddr + sizeof(*ghes->estatus),
-				   len - sizeof(*ghes->estatus), 1);
-	if (rc)
-		return rc;
+	ghes_copy_tofrom_phys(ghes->estatus + 1,
+			      buf_paddr + sizeof(*ghes->estatus),
+			      len - sizeof(*ghes->estatus), 1);
 	if (apei_estatus_check(ghes->estatus))
 		goto err_read_block;
 	rc = 0;
 
 err_read_block:
-	if (rc && !silent)
+	if (rc && !silent && printk_ratelimit())
 		pr_warning(FW_WARN GHES_PFX
 			   "Failed to read error status block!\n");
 	return rc;
@@ -303,6 +390,43 @@ out:
 	return 0;
 }
 
+static void ghes_add_timer(struct ghes *ghes)
+{
+	struct acpi_hest_generic *g = ghes->generic;
+	unsigned long expire;
+
+	if (!g->notify.poll_interval) {
+		pr_warning(FW_WARN GHES_PFX "Poll interval is 0 for "
+			   "generaic hardware error source: %d, disabled.",
+			   g->header.source_id);
+		return;
+	}
+	expire = jiffies + msecs_to_jiffies(g->notify.poll_interval);
+	ghes->timer.expires = round_jiffies_relative(expire);
+	add_timer(&ghes->timer);
+}
+
+static void ghes_poll_func(unsigned long data)
+{
+	struct ghes *ghes = (void *)data;
+
+	ghes_proc(ghes);
+	if (!(ghes->flags & GHES_EXITING))
+		ghes_add_timer(ghes);
+}
+
+static irqreturn_t ghes_irq_func(int irq, void *data)
+{
+	struct ghes *ghes = data;
+	int rc;
+
+	rc = ghes_proc(ghes);
+	if (rc)
+		return IRQ_NONE;
+
+	return IRQ_HANDLED;
+}
+
 static int ghes_notify_sci(struct notifier_block *this,
 				  unsigned long event, void *data)
 {
@@ -319,10 +443,63 @@ static int ghes_notify_sci(struct notifi
 	return ret;
 }
 
+static int ghes_notify_nmi(struct notifier_block *this,
+				  unsigned long cmd, void *data)
+{
+	struct ghes *ghes, *ghes_global = NULL;
+	int sev, sev_global = -1;
+	int ret = NOTIFY_DONE;
+
+	if (cmd != DIE_NMI && cmd != DIE_NMI_IPI)
+		return ret;
+
+	raw_spin_lock(&ghes_nmi_lock);
+	list_for_each_entry_rcu(ghes, &ghes_nmi, list) {
+		if (ghes_read_estatus(ghes, 1)) {
+			ghes_clear_estatus(ghes);
+			continue;
+		}
+		ghes_report(ghes);
+		sev = ghes_severity(ghes->estatus->error_severity);
+		if (sev > sev_global) {
+			sev_global = sev;
+			ghes_global = ghes;
+		}
+		ret = NOTIFY_STOP;
+	}
+
+	if (ret == NOTIFY_DONE)
+		goto out;
+
+	if (sev_global >= GHES_SEV_PANIC) {
+		herr_persist_all_records();
+		oops_begin();
+		/* reboot to log the error! */
+		if (panic_timeout == 0)
+			panic_timeout = ghes_panic_timeout;
+		panic(GHES_PFX "generic hardware fatal error!\n");
+	}
+
+	list_for_each_entry_rcu(ghes, &ghes_nmi, list) {
+		if (!(ghes->flags & GHES_TO_CLEAR))
+			continue;
+		ghes_do_proc(ghes);
+		ghes_clear_estatus(ghes);
+	}
+
+out:
+	raw_spin_unlock(&ghes_nmi_lock);
+	return ret;
+}
+
 static struct notifier_block ghes_notifier_sci = {
 	.notifier_call = ghes_notify_sci,
 };
 
+static struct notifier_block ghes_notifier_nmi = {
+	.notifier_call = ghes_notify_nmi,
+};
+
 static int __devinit ghes_probe(struct platform_device *ghes_dev)
 {
 	struct acpi_hest_generic *generic;
@@ -334,30 +511,21 @@ static int __devinit ghes_probe(struct p
 	if (!generic->enabled)
 		goto err;
 
-	if (generic->notify.type != ACPI_HEST_NOTIFY_SCI) {
-		char *notify = NULL;
-
-		switch (generic->notify.type) {
-		case ACPI_HEST_NOTIFY_POLLED:
-			notify = "POLL";
-			break;
-		case ACPI_HEST_NOTIFY_EXTERNAL:
-		case ACPI_HEST_NOTIFY_LOCAL:
-			notify = "IRQ";
-			break;
-		case ACPI_HEST_NOTIFY_NMI:
-			notify = "NMI";
-			break;
-		}
-		if (notify) {
-			pr_warning(GHES_PFX
-"Generic hardware error source: %d notified via %s is not supported!\n",
-				   generic->header.source_id, notify);
-		} else {
-			pr_warning(FW_WARN GHES_PFX
+	switch (generic->notify.type) {
+	case ACPI_HEST_NOTIFY_POLLED:
+	case ACPI_HEST_NOTIFY_EXTERNAL:
+	case ACPI_HEST_NOTIFY_SCI:
+	case ACPI_HEST_NOTIFY_NMI:
+		break;
+	case ACPI_HEST_NOTIFY_LOCAL:
+		pr_warning(GHES_PFX
+"Generic hardware error source: %d notified via local interrupt is not supported!\n",
+			   generic->header.source_id);
+		goto err;
+	default:
+		pr_warning(FW_WARN GHES_PFX
 "Unknown notification type: %u for generic hardware error source: %d\n",
-			generic->notify.type, generic->header.source_id);
-		}
+			   generic->notify.type, generic->header.source_id);
 		goto err;
 	}
 
@@ -388,6 +556,28 @@ static int __devinit ghes_probe(struct p
 		goto err;
 	}
 	switch (generic->notify.type) {
+	case ACPI_HEST_NOTIFY_POLLED:
+		init_timer(&ghes->timer);
+		ghes->timer.function = ghes_poll_func;
+		ghes->timer.data = (unsigned long)ghes;
+		ghes_add_timer(ghes);
+		break;
+	case ACPI_HEST_NOTIFY_EXTERNAL:
+		/* External interrupt vector is GSI */
+		if (acpi_gsi_to_irq(generic->notify.vector, &ghes->irq)) {
+			pr_err(GHES_PFX
+	"Failed to map GSI to IRQ for generic hardware error source: %d\n",
+			       generic->header.source_id);
+			goto err_unreg;
+		}
+		if (request_irq(ghes->irq, ghes_irq_func,
+				0, "GHES IRQ", ghes)) {
+			pr_err(GHES_PFX
+	"Failed to register IRQ for generic hardware error source: %d\n",
+			       generic->header.source_id);
+			goto err_unreg;
+		}
+		break;
 	case ACPI_HEST_NOTIFY_SCI:
 		mutex_lock(&ghes_list_mutex);
 		if (list_empty(&ghes_sci))
@@ -395,12 +585,21 @@ static int __devinit ghes_probe(struct p
 		list_add_rcu(&ghes->list, &ghes_sci);
 		mutex_unlock(&ghes_list_mutex);
 		break;
+	case ACPI_HEST_NOTIFY_NMI:
+		mutex_lock(&ghes_list_mutex);
+		if (list_empty(&ghes_nmi))
+			register_die_notifier(&ghes_notifier_nmi);
+		list_add_rcu(&ghes->list, &ghes_nmi);
+		mutex_unlock(&ghes_list_mutex);
+		break;
 	default:
 		BUG();
 	}
 	platform_set_drvdata(ghes_dev, ghes);
 
 	return 0;
+err_unreg:
+	herr_dev_unregister(ghes->herr_dev);
 err:
 	if (ghes) {
 		ghes_fini(ghes);
@@ -417,7 +616,15 @@ static int __devexit ghes_remove(struct
 	ghes = platform_get_drvdata(ghes_dev);
 	generic = ghes->generic;
 
+	ghes->flags |= GHES_EXITING;
+
 	switch (generic->notify.type) {
+	case ACPI_HEST_NOTIFY_POLLED:
+		del_timer_sync(&ghes->timer);
+		break;
+	case ACPI_HEST_NOTIFY_EXTERNAL:
+		free_irq(ghes->irq, ghes);
+		break;
 	case ACPI_HEST_NOTIFY_SCI:
 		mutex_lock(&ghes_list_mutex);
 		list_del_rcu(&ghes->list);
@@ -426,6 +633,14 @@ static int __devexit ghes_remove(struct
 		mutex_unlock(&ghes_list_mutex);
 		synchronize_rcu();
 		break;
+	case ACPI_HEST_NOTIFY_NMI:
+		mutex_lock(&ghes_list_mutex);
+		list_del_rcu(&ghes->list);
+		if (list_empty(&ghes_nmi))
+			unregister_die_notifier(&ghes_notifier_nmi);
+		mutex_unlock(&ghes_list_mutex);
+		synchronize_rcu();
+		break;
 	default:
 		BUG();
 		break;
@@ -451,6 +666,8 @@ static struct platform_driver ghes_platf
 
 static int __init ghes_init(void)
 {
+	int rc;
+
 	if (acpi_disabled)
 		return -ENODEV;
 
@@ -459,12 +676,25 @@ static int __init ghes_init(void)
 		return -EINVAL;
 	}
 
-	return platform_driver_register(&ghes_platform_driver);
+	rc = ghes_ioremap_init();
+	if (rc)
+		goto err;
+
+	rc = platform_driver_register(&ghes_platform_driver);
+	if (rc)
+		goto err_ioremap_exit;
+
+	return 0;
+err_ioremap_exit:
+	ghes_ioremap_exit();
+err:
+	return rc;
 }
 
 static void __exit ghes_exit(void)
 {
 	platform_driver_unregister(&ghes_platform_driver);
+	ghes_ioremap_exit();
 }
 
 module_init(ghes_init);
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -34,6 +34,7 @@ static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
 
 int panic_timeout;
+EXPORT_SYMBOL_GPL(panic_timeout);
 
 ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
--- a/lib/ioremap.c
+++ b/lib/ioremap.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/io.h>
+#include <linux/module.h>
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
@@ -90,3 +91,4 @@ int ioremap_page_range(unsigned long add
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(ioremap_page_range);
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1160,6 +1160,7 @@ void unmap_kernel_range_noflush(unsigned
 {
 	vunmap_page_range(addr, addr + size);
 }
+EXPORT_SYMBOL_GPL(unmap_kernel_range_noflush);
 
 /**
  * unmap_kernel_range - unmap kernel VM area and flush cache and TLB
