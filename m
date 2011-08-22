Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab1HVHMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 03:12:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:19498 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab1HVHMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 03:12:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="40863848"
Message-ID: <4E520149.3010802@intel.com>
Date: Mon, 22 Aug 2011 15:12:09 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Iceowl/1.0b2 Icedove/3.1.11
MIME-Version: 1.0
To: Pavel Ivanov <paivanof@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: APEI: Can not request iomem region for GARs
References: <CAG1a4rs4Cr1z50gGuK9SLE6aOvibE1sdV_GSLPv+gqYC8g+ORQ@mail.gmail.com> <CAErSpo4FfBoGDUquoLNsJ9=z-M-x6NQgP8xJL_VqEXpsL2H5PA@mail.gmail.com>
In-Reply-To: <CAErSpo4FfBoGDUquoLNsJ9=z-M-x6NQgP8xJL_VqEXpsL2H5PA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090102040203000401060301"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090102040203000401060301
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi, Pavel,

Do you have time to try the patch attached with the mail?
acpi_nvs.patch should go first.

Best Regards,
Huang Ying


--------------090102040203000401060301
Content-Type: text/x-patch;
 name="acpi_nvs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="acpi_nvs.patch"

Subject: [PATCH] ACPI, Record ACPI NVS regions

Some firmware will access memory in ACPI NVS region via APEI.  That
is, instructions in APEI ERST/EINJ table will read/write ACPI NVS
region.  The original resource conflict checking in APEI code will
check memory/ioport accessed by APEI via general resource management
mech.  But ACPI NVS region is marked as busy already, so that the
false resource conflict will prevent APEI ERST/EINJ to work.

To fix this, this patch record ACPI NVS regions, so that we can avoid
request resources for memory region inside it.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/kernel/e820.c |    4 ++--
 drivers/acpi/Makefile  |    3 ++-
 drivers/acpi/nvs.c     |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/acpi.h   |   20 ++++++++++++++------
 4 files changed, 64 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -713,7 +713,7 @@ void __init e820_mark_nosave_regions(uns
 }
 #endif
 
-#ifdef CONFIG_HIBERNATION
+#ifdef CONFIG_ACPI
 /**
  * Mark ACPI NVS memory region, so that we can save/restore it during
  * hibernation and the subsequent resume.
@@ -726,7 +726,7 @@ static int __init e820_mark_nvs_memory(v
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
@@ -15,6 +15,50 @@
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
+	if (region)
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
+	struct nvs_region *region;
+
+	list_for_each_entry(region, &nvs_region_list, node)
+		func(region->phys_start, region->size, data);
+}
+
+
+#ifdef CONFIG_ACPI_SLEEP
 /*
  * Platforms, like ACPI, may want us to save some memory used by them during
  * suspend and to restore the contents of this memory during the subsequent
@@ -41,7 +85,7 @@ static LIST_HEAD(nvs_list);
  *	things so that the data from page-aligned addresses in this region will
  *	be copied into separate RAM pages.
  */
-int suspend_nvs_register(unsigned long start, unsigned long size)
+static int suspend_nvs_register(unsigned long start, unsigned long size)
 {
 	struct nvs_page *entry, *next;
 
@@ -159,3 +203,4 @@ void suspend_nvs_restore(void)
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

--------------090102040203000401060301
Content-Type: text/x-patch;
 name="nvs_exclude.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nvs_exclude.patch"

Subject: [BUGFIX] ACPI, APEI, Resolve false conflict between ACPI NVS and APEI

Some firmware will access memory in ACPI NVS region via APEI.  That
is, instructions in APEI ERST/EINJ table will read/write ACPI NVS
region.  The original resource conflict checking in APEI code will
check memory/ioport accessed by APEI via general resource management
mech.  But ACPI NVS region is marked as busy already, so that the
false resource conflict will prevent APEI ERST/EINJ to work.

To fix this, this patch excludes ACPI NVS regions when APEI components
request resources.  So that they will not conflict with ACPI NVS
regions.

Reported-by: Pavel Ivanov <paivanof@gmail.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/apei-base.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -449,8 +449,19 @@ int apei_resources_sub(struct apei_resou
 }
 EXPORT_SYMBOL_GPL(apei_resources_sub);
 
+static int apei_get_nvs_callback(__u64 start, __u64 size, void *data)
+{
+	struct apei_resources *resources = data;
+	return apei_res_add(&resources->iomem, start, size);
+}
+
+static int apei_get_nvs_resources(struct apei_resources *resources)
+{
+	return acpi_nvs_for_each_region(apei_get_nvs_callback, resources);
+}
+
 /*
- * IO memory/port rersource management mechanism is used to check
+ * IO memory/port resource management mechanism is used to check
  * whether memory/port area used by GARs conflicts with normal memory
  * or IO memory/port of devices.
  */
@@ -459,12 +470,24 @@ int apei_resources_request(struct apei_r
 {
 	struct apei_res *res, *res_bak = NULL;
 	struct resource *r;
+	struct apei_resources nvs_resources;
 	int rc;
 
 	rc = apei_resources_sub(resources, &apei_resources_all);
 	if (rc)
 		return rc;
 
+	/*
+	 * Some firmware uses ACPI NVS region, that has been marked as
+	 * busy, so exclude it from APEI resources to avoid false
+	 * conflict.
+	 */
+	apei_resources_init(&nvs_resources);
+	apei_get_nvs_resources(&nvs_resources);
+	rc = apei_resources_sub(resources, &nvs_resources);
+	if (rc)
+		goto res_fini;
+
 	rc = -EINVAL;
 	list_for_each_entry(res, &resources->iomem, list) {
 		r = request_mem_region(res->start, res->end - res->start,
@@ -511,6 +534,8 @@ err_unmap_iomem:
 			break;
 		release_mem_region(res->start, res->end - res->start);
 	}
+res_fini:
+	apei_resources_fini(&nvs_resources);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(apei_resources_request);

--------------090102040203000401060301--
