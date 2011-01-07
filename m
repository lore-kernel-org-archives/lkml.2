Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab1AGAru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:47:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38179 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab1AGArr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:47:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 2/5] PM / ACPI: Move NVS saving and restoring code to drivers/acpi
Date: Fri, 7 Jan 2011 01:43:44 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Jiri Slaby <jirislaby@gmail.com>
References: <201101070141.02951.rjw@sisk.pl>
In-Reply-To: <201101070141.02951.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101070143.44507.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The saving of the ACPI NVS area during hibernation and suspend and
restoring it during the subsequent resume is entirely specific to
ACPI, so move it to drivers/acpi and drop the CONFIG_SUSPEND_NVS
configuration option which is redundant.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/e820.c  |    1 
 drivers/acpi/Makefile   |    2 
 drivers/acpi/internal.h |    8 ++
 drivers/acpi/nvs.c      |  142 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h    |    9 +++
 include/linux/suspend.h |   17 -----
 kernel/power/Kconfig    |    5 -
 kernel/power/Makefile   |    1 
 kernel/power/nvs.c      |  142 ------------------------------------------------
 9 files changed, 161 insertions(+), 166 deletions(-)

Index: linux-2.6/drivers/acpi/nvs.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/acpi/nvs.c
@@ -0,0 +1,142 @@
+/*
+ * linux/kernel/power/hibernate_nvs.c - Routines for handling NVS memory
+ *
+ * Copyright (C) 2008,2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/suspend.h>
+
+/*
+ * Platforms, like ACPI, may want us to save some memory used by them during
+ * suspend and to restore the contents of this memory during the subsequent
+ * resume.  The code below implements a mechanism allowing us to do that.
+ */
+
+struct nvs_page {
+	unsigned long phys_start;
+	unsigned int size;
+	void *kaddr;
+	void *data;
+	struct list_head node;
+};
+
+static LIST_HEAD(nvs_list);
+
+/**
+ *	suspend_nvs_register - register platform NVS memory region to save
+ *	@start - physical address of the region
+ *	@size - size of the region
+ *
+ *	The NVS region need not be page-aligned (both ends) and we arrange
+ *	things so that the data from page-aligned addresses in this region will
+ *	be copied into separate RAM pages.
+ */
+int suspend_nvs_register(unsigned long start, unsigned long size)
+{
+	struct nvs_page *entry, *next;
+
+	while (size > 0) {
+		unsigned int nr_bytes;
+
+		entry = kzalloc(sizeof(struct nvs_page), GFP_KERNEL);
+		if (!entry)
+			goto Error;
+
+		list_add_tail(&entry->node, &nvs_list);
+		entry->phys_start = start;
+		nr_bytes = PAGE_SIZE - (start & ~PAGE_MASK);
+		entry->size = (size < nr_bytes) ? size : nr_bytes;
+
+		start += entry->size;
+		size -= entry->size;
+	}
+	return 0;
+
+ Error:
+	list_for_each_entry_safe(entry, next, &nvs_list, node) {
+		list_del(&entry->node);
+		kfree(entry);
+	}
+	return -ENOMEM;
+}
+
+/**
+ *	suspend_nvs_free - free data pages allocated for saving NVS regions
+ */
+void suspend_nvs_free(void)
+{
+	struct nvs_page *entry;
+
+	list_for_each_entry(entry, &nvs_list, node)
+		if (entry->data) {
+			free_page((unsigned long)entry->data);
+			entry->data = NULL;
+			if (entry->kaddr) {
+				iounmap(entry->kaddr);
+				entry->kaddr = NULL;
+			}
+		}
+}
+
+/**
+ *	suspend_nvs_alloc - allocate memory necessary for saving NVS regions
+ */
+int suspend_nvs_alloc(void)
+{
+	struct nvs_page *entry;
+
+	list_for_each_entry(entry, &nvs_list, node) {
+		entry->data = (void *)__get_free_page(GFP_KERNEL);
+		if (!entry->data) {
+			suspend_nvs_free();
+			return -ENOMEM;
+		}
+	}
+	return 0;
+}
+
+/**
+ *	suspend_nvs_save - save NVS memory regions
+ */
+int suspend_nvs_save(void)
+{
+	struct nvs_page *entry;
+
+	printk(KERN_INFO "PM: Saving platform NVS memory\n");
+
+	list_for_each_entry(entry, &nvs_list, node)
+		if (entry->data) {
+			entry->kaddr = ioremap(entry->phys_start, entry->size);
+			if (!entry->kaddr) {
+				suspend_nvs_free();
+				return -ENOMEM;
+			}
+			memcpy(entry->data, entry->kaddr, entry->size);
+		}
+
+	return 0;
+}
+
+/**
+ *	suspend_nvs_restore - restore NVS memory regions
+ *
+ *	This function is going to be called with interrupts disabled, so it
+ *	cannot iounmap the virtual addresses used to access the NVS region.
+ */
+void suspend_nvs_restore(void)
+{
+	struct nvs_page *entry;
+
+	printk(KERN_INFO "PM: Restoring platform NVS memory\n");
+
+	list_for_each_entry(entry, &nvs_list, node)
+		if (entry->data)
+			memcpy(entry->kaddr, entry->data, entry->size);
+}
Index: linux-2.6/kernel/power/nvs.c
===================================================================
--- linux-2.6.orig/kernel/power/nvs.c
+++ /dev/null
@@ -1,142 +0,0 @@
-/*
- * linux/kernel/power/hibernate_nvs.c - Routines for handling NVS memory
- *
- * Copyright (C) 2008,2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
- *
- * This file is released under the GPLv2.
- */
-
-#include <linux/io.h>
-#include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/mm.h>
-#include <linux/slab.h>
-#include <linux/suspend.h>
-
-/*
- * Platforms, like ACPI, may want us to save some memory used by them during
- * suspend and to restore the contents of this memory during the subsequent
- * resume.  The code below implements a mechanism allowing us to do that.
- */
-
-struct nvs_page {
-	unsigned long phys_start;
-	unsigned int size;
-	void *kaddr;
-	void *data;
-	struct list_head node;
-};
-
-static LIST_HEAD(nvs_list);
-
-/**
- *	suspend_nvs_register - register platform NVS memory region to save
- *	@start - physical address of the region
- *	@size - size of the region
- *
- *	The NVS region need not be page-aligned (both ends) and we arrange
- *	things so that the data from page-aligned addresses in this region will
- *	be copied into separate RAM pages.
- */
-int suspend_nvs_register(unsigned long start, unsigned long size)
-{
-	struct nvs_page *entry, *next;
-
-	while (size > 0) {
-		unsigned int nr_bytes;
-
-		entry = kzalloc(sizeof(struct nvs_page), GFP_KERNEL);
-		if (!entry)
-			goto Error;
-
-		list_add_tail(&entry->node, &nvs_list);
-		entry->phys_start = start;
-		nr_bytes = PAGE_SIZE - (start & ~PAGE_MASK);
-		entry->size = (size < nr_bytes) ? size : nr_bytes;
-
-		start += entry->size;
-		size -= entry->size;
-	}
-	return 0;
-
- Error:
-	list_for_each_entry_safe(entry, next, &nvs_list, node) {
-		list_del(&entry->node);
-		kfree(entry);
-	}
-	return -ENOMEM;
-}
-
-/**
- *	suspend_nvs_free - free data pages allocated for saving NVS regions
- */
-void suspend_nvs_free(void)
-{
-	struct nvs_page *entry;
-
-	list_for_each_entry(entry, &nvs_list, node)
-		if (entry->data) {
-			free_page((unsigned long)entry->data);
-			entry->data = NULL;
-			if (entry->kaddr) {
-				iounmap(entry->kaddr);
-				entry->kaddr = NULL;
-			}
-		}
-}
-
-/**
- *	suspend_nvs_alloc - allocate memory necessary for saving NVS regions
- */
-int suspend_nvs_alloc(void)
-{
-	struct nvs_page *entry;
-
-	list_for_each_entry(entry, &nvs_list, node) {
-		entry->data = (void *)__get_free_page(GFP_KERNEL);
-		if (!entry->data) {
-			suspend_nvs_free();
-			return -ENOMEM;
-		}
-	}
-	return 0;
-}
-
-/**
- *	suspend_nvs_save - save NVS memory regions
- */
-int suspend_nvs_save(void)
-{
-	struct nvs_page *entry;
-
-	printk(KERN_INFO "PM: Saving platform NVS memory\n");
-
-	list_for_each_entry(entry, &nvs_list, node)
-		if (entry->data) {
-			entry->kaddr = ioremap(entry->phys_start, entry->size);
-			if (!entry->kaddr) {
-				suspend_nvs_free();
-				return -ENOMEM;
-			}
-			memcpy(entry->data, entry->kaddr, entry->size);
-		}
-
-	return 0;
-}
-
-/**
- *	suspend_nvs_restore - restore NVS memory regions
- *
- *	This function is going to be called with interrupts disabled, so it
- *	cannot iounmap the virtual addresses used to access the NVS region.
- */
-void suspend_nvs_restore(void)
-{
-	struct nvs_page *entry;
-
-	printk(KERN_INFO "PM: Restoring platform NVS memory\n");
-
-	list_for_each_entry(entry, &nvs_list, node)
-		if (entry->data)
-			memcpy(entry->kaddr, entry->data, entry->size);
-}
Index: linux-2.6/include/linux/suspend.h
===================================================================
--- linux-2.6.orig/include/linux/suspend.h
+++ linux-2.6/include/linux/suspend.h
@@ -258,23 +258,6 @@ static inline int hibernate(void) { retu
 static inline bool system_entering_hibernation(void) { return false; }
 #endif /* CONFIG_HIBERNATION */
 
-#ifdef CONFIG_SUSPEND_NVS
-extern int suspend_nvs_register(unsigned long start, unsigned long size);
-extern int suspend_nvs_alloc(void);
-extern void suspend_nvs_free(void);
-extern int suspend_nvs_save(void);
-extern void suspend_nvs_restore(void);
-#else /* CONFIG_SUSPEND_NVS */
-static inline int suspend_nvs_register(unsigned long a, unsigned long b)
-{
-	return 0;
-}
-static inline int suspend_nvs_alloc(void) { return 0; }
-static inline void suspend_nvs_free(void) {}
-static inline int suspend_nvs_save(void) {}
-static inline void suspend_nvs_restore(void) {}
-#endif /* CONFIG_SUSPEND_NVS */
-
 #ifdef CONFIG_PM_SLEEP
 void save_processor_state(void);
 void restore_processor_state(void);
Index: linux-2.6/drivers/acpi/Makefile
===================================================================
--- linux-2.6.orig/drivers/acpi/Makefile
+++ linux-2.6/drivers/acpi/Makefile
@@ -24,7 +24,7 @@ acpi-y				+= atomicio.o
 # sleep related files
 acpi-y				+= wakeup.o
 acpi-y				+= sleep.o
-acpi-$(CONFIG_ACPI_SLEEP)	+= proc.o
+acpi-$(CONFIG_ACPI_SLEEP)	+= proc.o nvs.o
 
 
 #
Index: linux-2.6/drivers/acpi/internal.h
===================================================================
--- linux-2.6.orig/drivers/acpi/internal.h
+++ linux-2.6/drivers/acpi/internal.h
@@ -83,8 +83,16 @@ extern int acpi_sleep_init(void);
 
 #ifdef CONFIG_ACPI_SLEEP
 int acpi_sleep_proc_init(void);
+int suspend_nvs_alloc(void);
+void suspend_nvs_free(void);
+int suspend_nvs_save(void);
+void suspend_nvs_restore(void);
 #else
 static inline int acpi_sleep_proc_init(void) { return 0; }
+static inline int suspend_nvs_alloc(void) { return 0; }
+static inline void suspend_nvs_free(void) {}
+static inline int suspend_nvs_save(void) {}
+static inline void suspend_nvs_restore(void) {}
 #endif
 
 #endif /* _ACPI_INTERNAL_H_ */
Index: linux-2.6/include/linux/acpi.h
===================================================================
--- linux-2.6.orig/include/linux/acpi.h
+++ linux-2.6/include/linux/acpi.h
@@ -254,6 +254,15 @@ void __init acpi_old_suspend_ordering(vo
 void __init acpi_nvs_nosave(void);
 #endif /* CONFIG_PM_SLEEP */
 
+#ifdef CONFIG_ACPI_SLEEP
+int suspend_nvs_register(unsigned long start, unsigned long size);
+#else
+static inline int suspend_nvs_register(unsigned long a, unsigned long b)
+{
+	return 0;
+}
+#endif
+
 struct acpi_osc_context {
 	char *uuid_str; /* uuid string */
 	int rev;
Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -14,6 +14,7 @@
 #include <linux/bootmem.h>
 #include <linux/pfn.h>
 #include <linux/suspend.h>
+#include <linux/acpi.h>
 #include <linux/firmware-map.h>
 #include <linux/memblock.h>
 
Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig
+++ linux-2.6/kernel/power/Kconfig
@@ -100,13 +100,9 @@ config PM_SLEEP_ADVANCED_DEBUG
 	depends on PM_ADVANCED_DEBUG
 	default n
 
-config SUSPEND_NVS
-       bool
-
 config SUSPEND
 	bool "Suspend to RAM and standby"
 	depends on PM && ARCH_SUSPEND_POSSIBLE
-	select SUSPEND_NVS if HAS_IOMEM
 	default y
 	---help---
 	  Allow the system to enter sleep states in which main memory is
@@ -140,7 +136,6 @@ config HIBERNATION
 	depends on PM && SWAP && ARCH_HIBERNATION_POSSIBLE
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
-	select SUSPEND_NVS if HAS_IOMEM
 	---help---
 	  Enable the suspend to disk (STD) functionality, which is usually
 	  called "hibernation" in user interfaces.  STD checkpoints the
Index: linux-2.6/kernel/power/Makefile
===================================================================
--- linux-2.6.orig/kernel/power/Makefile
+++ linux-2.6/kernel/power/Makefile
@@ -7,6 +7,5 @@ obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o \
 				   block_io.o
-obj-$(CONFIG_SUSPEND_NVS)	+= nvs.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o

