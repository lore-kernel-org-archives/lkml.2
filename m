Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab1KHClW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 21:41:22 -0500
Received: from mga14.intel.com ([143.182.124.37]:17611 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab1KHCjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 21:39:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,473,1315206000"; 
   d="scan'208";a="34288604"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 3/9] ACPI, Record ACPI NVS regions
Date: Tue,  8 Nov 2011 10:39:28 +0800
Message-Id: <1320719974-3598-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1320719974-3598-1-git-send-email-ying.huang@intel.com>
References: <1320719974-3598-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some firmware will access memory in ACPI NVS region via APEI.  That
is, instructions in APEI ERST/EINJ table will read/write ACPI NVS
region.  The original resource conflict checking in APEI code will
check memory/ioport accessed by APEI via general resource management
mechanism.  But ACPI NVS region is marked as busy already, so that the
false resource conflict will prevent APEI ERST/EINJ to work.

To fix this, this patch record ACPI NVS regions, so that we can avoid
request resources for memory region inside it.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/kernel/e820.c |    4 +--
 drivers/acpi/Makefile  |    3 +-
 drivers/acpi/nvs.c     |   53 ++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/acpi.h   |   20 ++++++++++++------
 4 files changed, 70 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -714,7 +714,7 @@ void __init e820_mark_nosave_regions(uns
 }
 #endif
 
-#ifdef CONFIG_HIBERNATION
+#ifdef CONFIG_ACPI
 /**
  * Mark ACPI NVS memory region, so that we can save/restore it during
  * hibernation and the subsequent resume.
@@ -727,7 +727,7 @@ static int __init e820_mark_nvs_memory(v
 		struct e820entry *ei = &e820.map[i];
 
 		if (ei->type == E820_NVS)
-			suspend_nvs_register(ei->addr, ei->size);
+			acpi_nvs_register(ei->addr, ei->size);
 	}
 
 	return 0;
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -20,11 +20,12 @@ obj-y				+= acpi.o \
 # All the builtin files are in the "acpi." module_param namespace.
 acpi-y				+= osl.o utils.o reboot.o
 acpi-y				+= atomicio.o
+acpi-y				+= nvs.o
 
 # sleep related files
 acpi-y				+= wakeup.o
 acpi-y				+= sleep.o
-acpi-$(CONFIG_ACPI_SLEEP)	+= proc.o nvs.o
+acpi-$(CONFIG_ACPI_SLEEP)	+= proc.o
 
 
 #
--- a/drivers/acpi/nvs.c
+++ b/drivers/acpi/nvs.c
@@ -15,6 +15,56 @@
 #include <linux/acpi_io.h>
 #include <acpi/acpiosxf.h>
 
+/* ACPI NVS regions, APEI may use it */
+
+struct nvs_region {
+	__u64 phys_start;
+	__u64 size;
+	struct list_head node;
+};
+
+static LIST_HEAD(nvs_region_list);
+
+#ifdef CONFIG_ACPI_SLEEP
+static int suspend_nvs_register(unsigned long start, unsigned long size);
+#else
+static inline int suspend_nvs_register(unsigned long a, unsigned long b)
+{
+	return 0;
+}
+#endif
+
+int acpi_nvs_register(__u64 start, __u64 size)
+{
+	struct nvs_region *region;
+
+	region = kmalloc(sizeof(*region), GFP_KERNEL);
+	if (!region)
+		return -ENOMEM;
+	region->phys_start = start;
+	region->size = size;
+	list_add_tail(&region->node, &nvs_region_list);
+
+	return suspend_nvs_register(start, size);
+}
+
+int acpi_nvs_for_each_region(int (*func)(__u64 start, __u64 size, void *data),
+			     void *data)
+{
+	int rc;
+	struct nvs_region *region;
+
+	list_for_each_entry(region, &nvs_region_list, node) {
+		rc = func(region->phys_start, region->size, data);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+
+#ifdef CONFIG_ACPI_SLEEP
 /*
  * Platforms, like ACPI, may want us to save some memory used by them during
  * suspend and to restore the contents of this memory during the subsequent
@@ -41,7 +91,7 @@ static LIST_HEAD(nvs_list);
  *	things so that the data from page-aligned addresses in this region will
  *	be copied into separate RAM pages.
  */
-int suspend_nvs_register(unsigned long start, unsigned long size)
+static int suspend_nvs_register(unsigned long start, unsigned long size)
 {
 	struct nvs_page *entry, *next;
 
@@ -159,3 +209,4 @@ void suspend_nvs_restore(void)
 		if (entry->data)
 			memcpy(entry->kaddr, entry->data, entry->size);
 }
+#endif
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -306,6 +306,11 @@ extern acpi_status acpi_pci_osc_control_
 					     u32 *mask, u32 req);
 extern void acpi_early_init(void);
 
+extern int acpi_nvs_register(__u64 start, __u64 size);
+
+extern int acpi_nvs_for_each_region(int (*func)(__u64, __u64, void *),
+				    void *data);
+
 #else	/* !CONFIG_ACPI */
 
 #define acpi_disabled 1
@@ -348,15 +353,18 @@ static inline int acpi_table_parse(char
 {
 	return -1;
 }
-#endif	/* !CONFIG_ACPI */
 
-#ifdef CONFIG_ACPI_SLEEP
-int suspend_nvs_register(unsigned long start, unsigned long size);
-#else
-static inline int suspend_nvs_register(unsigned long a, unsigned long b)
+static inline int acpi_nvs_register(__u64 start, __u64 size)
 {
 	return 0;
 }
-#endif
+
+static inline int acpi_nvs_for_each_region(int (*func)(__u64, __u64, void *),
+					   void *data)
+{
+	return 0;
+}
+
+#endif	/* !CONFIG_ACPI */
 
 #endif	/*_LINUX_ACPI_H*/
