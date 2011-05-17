Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab1EQIK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:10:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:64539 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab1EQIIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:08:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,224,1304319600"; 
   d="scan'208";a="2661647"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org
Subject: [PATCH 4/9] ACPI, APEI, GHES, printk support for recoverable error via NMI
Date: Tue, 17 May 2011 16:08:34 +0800
Message-Id: <1305619719-7480-5-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
References: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some APEI GHES recoverable errors are reported via NMI, but printk is
not safe in NMI context.

To solve the issue, a lock-less memory allocator is used to allocate
memory in NMI handler, save the error record into the allocated
memory, put the error record into a lock-less list.  On the other
hand, a irq_work is used to delay the operation from NMI context to
IRQ context.  The irq_work IRQ handler will remove nodes from
lock-less list, printk the error record and do some further processing
include recovery operation, then free the memory.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/Kconfig |    2 
 drivers/acpi/apei/ghes.c  |  193 ++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 181 insertions(+), 14 deletions(-)

--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -12,6 +12,8 @@ config ACPI_APEI_GHES
 	tristate "APEI Generic Hardware Error Source"
 	depends on ACPI_APEI && X86
 	select ACPI_HED
+	select LLIST
+	select GENERIC_ALLOCATOR
 	help
 	  Generic Hardware Error Source provides a way to report
 	  platform hardware errors (such as that from chipset). It
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -12,7 +12,7 @@
  * For more information about Generic Hardware Error Source, please
  * refer to ACPI Specification version 4.0, section 17.3.2.6
  *
- * Copyright 2010 Intel Corp.
+ * Copyright 2010,2011 Intel Corp.
  *   Author: Huang Ying <ying.huang@intel.com>
  *
  * This program is free software; you can redistribute it and/or
@@ -42,6 +42,9 @@
 #include <linux/mutex.h>
 #include <linux/ratelimit.h>
 #include <linux/vmalloc.h>
+#include <linux/irq_work.h>
+#include <linux/llist.h>
+#include <linux/genalloc.h>
 #include <acpi/apei.h>
 #include <acpi/atomicio.h>
 #include <acpi/hed.h>
@@ -53,6 +56,15 @@
 #define GHES_PFX	"GHES: "
 
 #define GHES_ESTATUS_MAX_SIZE		65536
+#define GHES_ESOURCE_PREALLOC_MAX_SIZE	65536
+
+#define GHES_ESTATUS_POOL_MIN_ALLOC_ORDER	3
+
+#define GHES_ESTATUS_NODE_LEN(estatus_len)			\
+	(sizeof(struct ghes_estatus_node) + (estatus_len))
+#define GHES_ESTATUS_FROM_NODE(estatus_node)				\
+	((struct acpi_hest_generic_status *)				\
+	 ((struct ghes_estatus_node *)(estatus_node) + 1))
 
 /*
  * One struct ghes is created for each generic hardware error source.
@@ -77,6 +89,11 @@ struct ghes {
 	};
 };
 
+struct ghes_estatus_node {
+	struct llist_node llnode;
+	struct acpi_hest_generic *generic;
+};
+
 static int ghes_panic_timeout	__read_mostly = 30;
 
 /*
@@ -121,6 +138,19 @@ static struct vm_struct *ghes_ioremap_ar
 static DEFINE_RAW_SPINLOCK(ghes_ioremap_lock_nmi);
 static DEFINE_SPINLOCK(ghes_ioremap_lock_irq);
 
+/*
+ * printk is not safe in NMI context.  So in NMI handler, we allocate
+ * required memory from lock-less memory allocator
+ * (ghes_estatus_pool), save estatus into it, put them into lock-less
+ * list (ghes_estatus_llist), then delay printk into IRQ context via
+ * irq_work (ghes_proc_irq_work).  ghes_estatus_size_request record
+ * required pool size by all NMI error source.
+ */
+static struct gen_pool *ghes_estatus_pool;
+static unsigned long ghes_estatus_pool_size_request;
+static struct llist_head ghes_estatus_llist;
+static struct irq_work ghes_proc_irq_work;
+
 static int ghes_ioremap_init(void)
 {
 	ghes_ioremap_area = __get_vm_area(PAGE_SIZE * GHES_IOREMAP_PAGES,
@@ -180,6 +210,55 @@ static void ghes_iounmap_irq(void __iome
 	__flush_tlb_one(vaddr);
 }
 
+static int ghes_estatus_pool_init(void)
+{
+	ghes_estatus_pool = gen_pool_create(GHES_ESTATUS_POOL_MIN_ALLOC_ORDER, -1);
+	if (!ghes_estatus_pool)
+		return -ENOMEM;
+	return 0;
+}
+
+static void ghes_estatus_pool_free_chunk_page(struct gen_pool *pool,
+					      struct gen_pool_chunk *chunk,
+					      void *data)
+{
+	free_page(chunk->start_addr);
+}
+
+static void ghes_estatus_pool_exit(void)
+{
+	gen_pool_for_each_chunk(ghes_estatus_pool,
+				ghes_estatus_pool_free_chunk_page, NULL);
+	gen_pool_destroy(ghes_estatus_pool);
+}
+
+static int ghes_estatus_pool_expand(unsigned long len)
+{
+	unsigned long i, pages, size, addr;
+	int ret;
+
+	ghes_estatus_pool_size_request += PAGE_ALIGN(len);
+	size = gen_pool_size(ghes_estatus_pool);
+	if (size >= ghes_estatus_pool_size_request)
+		return 0;
+	pages = (ghes_estatus_pool_size_request - size) / PAGE_SIZE;
+	for (i = 0; i < pages; i++) {
+		addr = __get_free_page(GFP_KERNEL);
+		if (!addr)
+			return -ENOMEM;
+		ret = gen_pool_add(ghes_estatus_pool, addr, PAGE_SIZE, -1);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static void ghes_estatus_pool_shrink(unsigned long len)
+{
+	ghes_estatus_pool_size_request -= PAGE_ALIGN(len);
+}
+
 static struct ghes *ghes_new(struct acpi_hest_generic *generic)
 {
 	struct ghes *ghes;
@@ -341,13 +420,13 @@ static void ghes_clear_estatus(struct gh
 	ghes->flags &= ~GHES_TO_CLEAR;
 }
 
-static void ghes_do_proc(struct ghes *ghes)
+static void ghes_do_proc(const struct acpi_hest_generic_status *estatus)
 {
 	int sev, processed = 0;
 	struct acpi_hest_generic_data *gdata;
 
-	sev = ghes_severity(ghes->estatus->error_severity);
-	apei_estatus_for_each_section(ghes->estatus, gdata) {
+	sev = ghes_severity(estatus->error_severity);
+	apei_estatus_for_each_section(estatus, gdata) {
 #ifdef CONFIG_X86_MCE
 		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
 				 CPER_SEC_PLATFORM_MEM)) {
@@ -360,13 +439,15 @@ static void ghes_do_proc(struct ghes *gh
 	}
 }
 
-static void ghes_print_estatus(const char *pfx, struct ghes *ghes)
+static void ghes_print_estatus(const char *pfx,
+			       const struct acpi_hest_generic *generic,
+			       const struct acpi_hest_generic_status *estatus)
 {
 	/* Not more than 2 messages every 5 seconds */
 	static DEFINE_RATELIMIT_STATE(ratelimit, 5*HZ, 2);
 
 	if (pfx == NULL) {
-		if (ghes_severity(ghes->estatus->error_severity) <=
+		if (ghes_severity(estatus->error_severity) <=
 		    GHES_SEV_CORRECTED)
 			pfx = KERN_WARNING HW_ERR;
 		else
@@ -375,8 +456,8 @@ static void ghes_print_estatus(const cha
 	if (__ratelimit(&ratelimit)) {
 		printk(
 	"%s""Hardware error from APEI Generic Hardware Error Source: %d\n",
-	pfx, ghes->generic->header.source_id);
-		apei_estatus_print(pfx, ghes->estatus);
+	pfx, generic->header.source_id);
+		apei_estatus_print(pfx, estatus);
 	}
 }
 
@@ -387,8 +468,8 @@ static int ghes_proc(struct ghes *ghes)
 	rc = ghes_read_estatus(ghes, 0);
 	if (rc)
 		goto out;
-	ghes_print_estatus(NULL, ghes);
-	ghes_do_proc(ghes);
+	ghes_print_estatus(NULL, ghes->generic, ghes->estatus);
+	ghes_do_proc(ghes->estatus);
 
 out:
 	ghes_clear_estatus(ghes);
@@ -447,6 +528,40 @@ static int ghes_notify_sci(struct notifi
 	return ret;
 }
 
+static void ghes_proc_in_irq(struct irq_work *irq_work)
+{
+	struct llist_node *llnode, *next, *tail = NULL;
+	struct ghes_estatus_node *estatus_node;
+	struct acpi_hest_generic_status *estatus;
+	u32 len, node_len;
+
+	/*
+	 * Because the time order of estatus in list is reversed,
+	 * revert it back to proper order.
+	 */
+	llnode = llist_del_all(&ghes_estatus_llist);
+	while (llnode) {
+		next = llnode->next;
+		llnode->next = tail;
+		tail = llnode;
+		llnode = next;
+	}
+	llnode = tail;
+	while (llnode) {
+		next = llnode->next;
+		estatus_node = llist_entry(llnode, struct ghes_estatus_node,
+					   llnode);
+		estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
+		len = apei_estatus_len(estatus);
+		node_len = GHES_ESTATUS_NODE_LEN(len);
+		ghes_do_proc(estatus);
+		ghes_print_estatus(NULL, estatus_node->generic, estatus);
+		gen_pool_free(ghes_estatus_pool, (unsigned long)estatus_node,
+			      node_len);
+		llnode = next;
+	}
+}
+
 static int ghes_notify_nmi(struct notifier_block *this,
 				  unsigned long cmd, void *data)
 {
@@ -476,7 +591,8 @@ static int ghes_notify_nmi(struct notifi
 
 	if (sev_global >= GHES_SEV_PANIC) {
 		oops_begin();
-		ghes_print_estatus(KERN_EMERG HW_ERR, ghes_global);
+		ghes_print_estatus(KERN_EMERG HW_ERR, ghes_global->generic,
+				   ghes_global->estatus);
 		/* reboot to log the error! */
 		if (panic_timeout == 0)
 			panic_timeout = ghes_panic_timeout;
@@ -484,12 +600,31 @@ static int ghes_notify_nmi(struct notifi
 	}
 
 	list_for_each_entry_rcu(ghes, &ghes_nmi, list) {
+#ifdef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+		u32 len, node_len;
+		struct ghes_estatus_node *estatus_node;
+		struct acpi_hest_generic_status *estatus;
+#endif
 		if (!(ghes->flags & GHES_TO_CLEAR))
 			continue;
-		/* Do not print estatus because printk is not NMI safe */
-		ghes_do_proc(ghes);
+#ifdef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+		/* Save estatus for further processing in IRQ context */
+		len = apei_estatus_len(ghes->estatus);
+		node_len = GHES_ESTATUS_NODE_LEN(len);
+		estatus_node = (void *)gen_pool_alloc(ghes_estatus_pool,
+						      node_len);
+		if (estatus_node) {
+			estatus_node->generic = ghes->generic;
+			estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
+			memcpy(estatus, ghes->estatus, len);
+			llist_add(&estatus_node->llnode, &ghes_estatus_llist);
+		}
+#endif
 		ghes_clear_estatus(ghes);
 	}
+#ifdef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+	irq_work_queue(&ghes_proc_irq_work);
+#endif
 
 out:
 	raw_spin_unlock(&ghes_nmi_lock);
@@ -504,10 +639,26 @@ static struct notifier_block ghes_notifi
 	.notifier_call = ghes_notify_nmi,
 };
 
+static unsigned long ghes_esource_prealloc_size(
+	const struct acpi_hest_generic *generic)
+{
+	unsigned long block_length, prealloc_records, prealloc_size;
+
+	block_length = min_t(unsigned long, generic->error_block_length,
+			     GHES_ESTATUS_MAX_SIZE);
+	prealloc_records = max_t(unsigned long,
+				 generic->records_to_preallocate, 1);
+	prealloc_size = min_t(unsigned long, block_length * prealloc_records,
+			      GHES_ESOURCE_PREALLOC_MAX_SIZE);
+
+	return prealloc_size;
+}
+
 static int __devinit ghes_probe(struct platform_device *ghes_dev)
 {
 	struct acpi_hest_generic *generic;
 	struct ghes *ghes = NULL;
+	unsigned long len;
 	int rc = -EINVAL;
 
 	generic = *(struct acpi_hest_generic **)ghes_dev->dev.platform_data;
@@ -573,6 +724,8 @@ static int __devinit ghes_probe(struct p
 		mutex_unlock(&ghes_list_mutex);
 		break;
 	case ACPI_HEST_NOTIFY_NMI:
+		len = ghes_esource_prealloc_size(generic);
+		ghes_estatus_pool_expand(len);
 		mutex_lock(&ghes_list_mutex);
 		if (list_empty(&ghes_nmi))
 			register_die_notifier(&ghes_notifier_nmi);
@@ -597,6 +750,7 @@ static int __devexit ghes_remove(struct
 {
 	struct ghes *ghes;
 	struct acpi_hest_generic *generic;
+	unsigned long len;
 
 	ghes = platform_get_drvdata(ghes_dev);
 	generic = ghes->generic;
@@ -627,6 +781,8 @@ static int __devexit ghes_remove(struct
 		 * freed after NMI handler finishes.
 		 */
 		synchronize_rcu();
+		len = ghes_esource_prealloc_size(generic);
+		ghes_estatus_pool_shrink(len);
 		break;
 	default:
 		BUG();
@@ -662,15 +818,23 @@ static int __init ghes_init(void)
 		return -EINVAL;
 	}
 
+	init_irq_work(&ghes_proc_irq_work, ghes_proc_in_irq);
+
 	rc = ghes_ioremap_init();
 	if (rc)
 		goto err;
 
-	rc = platform_driver_register(&ghes_platform_driver);
+	rc = ghes_estatus_pool_init();
 	if (rc)
 		goto err_ioremap_exit;
 
+	rc = platform_driver_register(&ghes_platform_driver);
+	if (rc)
+		goto err_pool_exit;
+
 	return 0;
+err_pool_exit:
+	ghes_estatus_pool_exit();
 err_ioremap_exit:
 	ghes_ioremap_exit();
 err:
@@ -680,6 +844,7 @@ err:
 static void __exit ghes_exit(void)
 {
 	platform_driver_unregister(&ghes_platform_driver);
+	ghes_estatus_pool_exit();
 	ghes_ioremap_exit();
 }
 
