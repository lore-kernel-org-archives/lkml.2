Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2AQMW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:22:28 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:39595 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab2AQMWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:21 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 34/50] ACPI, Record ACPI NVS regions
Date: Tue, 17 Jan 2012 07:21:26 -0500
Message-id: <b54ac6d2a25084667da781c7ca2cebef52a2bcdd.1326802230.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

Some firmware will access memory in ACPI NVS region via APEI.  That
is, instructions in APEI ERST/EINJ table will read/write ACPI NVS
region.  The original resource conflict checking in APEI code will
check memory/ioport accessed by APEI via general resource management
mechanism.  But ACPI NVS region is marked as busy already, so that the
false resource conflict will prevent APEI ERST/EINJ to work.

To fix this, this patch record ACPI NVS regions, so that we can avoid
request resources for memory region inside it.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/e820.c |    4 +-
 drivers/acpi/Makefile  |    3 +-
 drivers/acpi/nvs.c     |   53 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/acpi.h   |   20 ++++++++++++-----
 4 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 303a0e4..51c3b18 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -714,7 +714,7 @@ void __init e820_mark_nosave_regions(unsigned long limit_pfn)
 }
 #endif
 
-#ifdef CONFIG_HIBERNATION
+#ifdef CONFIG_ACPI
 /**
  * Mark ACPI NVS memory region, so that we can save/restore it during
  * hibernation and the subsequent resume.
@@ -727,7 +727,7 @@ static int __init e820_mark_nvs_memory(void)
 		struct e820entry *ei = &e820.map[i];
 
 		if (ei->type == E820_NVS)
-			suspend_nvs_register(ei->addr, ei->size);
+			acpi_nvs_register(ei->addr, ei->size);
 	}
 
 	return 0;
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index ecb26b4..c07f44f 100644
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
diff --git a/drivers/acpi/nvs.c b/drivers/acpi/nvs.c
index 096787b..7a2035f 100644
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
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 6001b4da..26b7544 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -306,6 +306,11 @@ extern acpi_status acpi_pci_osc_control_set(acpi_handle handle,
 					     u32 *mask, u32 req);
 extern void acpi_early_init(void);
 
+extern int acpi_nvs_register(__u64 start, __u64 size);
+
+extern int acpi_nvs_for_each_region(int (*func)(__u64, __u64, void *),
+				    void *data);
+
 #else	/* !CONFIG_ACPI */
 
 #define acpi_disabled 1
@@ -348,15 +353,18 @@ static inline int acpi_table_parse(char *id,
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
-- 
1.7.9.rc1

