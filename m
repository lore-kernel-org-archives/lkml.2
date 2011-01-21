Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab1AUVHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 16:07:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40977 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1AUVHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 16:07:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH 0/11] ACPI: Fixes and cleanups related to iomaps management
Date: Fri, 21 Jan 2011 22:06:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <201101201226.41021.rjw@sisk.pl> <201101210104.43641.rjw@sisk.pl> <AANLkTi=3JZUa3AtfcxnSuS36ORZLbS2-M+fJAR6_Moof@mail.gmail.com>
In-Reply-To: <AANLkTi=3JZUa3AtfcxnSuS36ORZLbS2-M+fJAR6_Moof@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201101212206.37469.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 21, 2011, Jeff Chua wrote:
> 2011/1/21 Rafael J. Wysocki <rjw@sisk.pl>:
> > Thanks, but unfortunately this wasn't conclusive.  Please apply the patch below
> > instead of the previous one (on top of [1/11] - [11/11]) and collect dmesg
> > output containing a (failing) suspend attempt.
> >
> > Please attach full dmesg, so that I can see the size and address of your
> > system's NVS region.
> 
> Attached.

So, below is a replacement for [11/11].  Please test it on top of
[1/11] - [10/11] (the current Linus' tree already contains [1/11] and [2/11])
and let me know if it works for you (in either case, please attach dmesg
output containing a suspend attempt).

If it works, I'll remove the diagnostic messages and submit along with the
rest of the patchset.

Thanks,
Rafael

---
Subject: ACPI / PM: Make NVS save/restore code use slightly less memory (test)

Remove the unnecessary field phys_start from struct nvs_page and
modify the code in nvs.c to use an array of struct nvs_page objects
instead of a list which makes it a bit more straightforward (in
addition to saving a little memory).

Not-signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/nvs.c |  125 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 79 insertions(+), 46 deletions(-)

Index: linux-2.6/drivers/acpi/nvs.c
===================================================================
--- linux-2.6.orig/drivers/acpi/nvs.c
+++ linux-2.6/drivers/acpi/nvs.c
@@ -22,15 +22,15 @@
  */
 
 struct nvs_page {
-	unsigned long phys_start;
 	unsigned int size;
-	void *kaddr;
+	void __iomem *kaddr;
 	void *data;
 	bool unmap;
-	struct list_head node;
 };
 
-static LIST_HEAD(nvs_list);
+static struct nvs_page *nvs;
+static unsigned long nvs_start;
+static unsigned int nvs_span;
 
 /**
  *	suspend_nvs_register - register platform NVS memory region to save
@@ -43,31 +43,40 @@ static LIST_HEAD(nvs_list);
  */
 int suspend_nvs_register(unsigned long start, unsigned long size)
 {
-	struct nvs_page *entry, *next;
+	struct nvs_page *p, *p_end;
+	unsigned int head, tail;
 
-	while (size > 0) {
-		unsigned int nr_bytes;
+	pr_info("PM: Registering ACPI NVS region at %lx (%ld bytes)\n",
+		start, size);
 
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
+	nvs_start = start;
+	head = PAGE_SIZE - (start & ~PAGE_MASK);
+	if (head) {
+		nvs_span = 1;
+		size -= size > head ? head : size;
+	} else {
+		nvs_span = 0;
+		head = PAGE_SIZE;
 	}
-	return 0;
+	nvs_span += size >> PAGE_SHIFT;
+	tail = size & ~PAGE_MASK;
+	if (tail)
+		nvs_span++;
+	else
+		tail = PAGE_SIZE;
+
+	nvs = kzalloc(sizeof(*nvs) * nvs_span, GFP_KERNEL);
+	if (!nvs)
+		return -ENOMEM;
+
+	p = nvs;
+	p->size = head;
+	for (p++, p_end = nvs + nvs_span - 1; p < p_end; p++)
+		p->size = PAGE_SIZE;
+	if (p_end > nvs)
+		p_end->size = tail;
 
- Error:
-	list_for_each_entry_safe(entry, next, &nvs_list, node) {
-		list_del(&entry->node);
-		kfree(entry);
-	}
-	return -ENOMEM;
+	return 0;
 }
 
 /**
@@ -75,17 +84,23 @@ int suspend_nvs_register(unsigned long s
  */
 void suspend_nvs_free(void)
 {
-	struct nvs_page *entry;
+	struct nvs_page *entry, *end;
 
-	list_for_each_entry(entry, &nvs_list, node)
+	for (entry = nvs, end = nvs + nvs_span; entry < end; entry++)
 		if (entry->data) {
 			free_page((unsigned long)entry->data);
 			entry->data = NULL;
 			if (entry->kaddr) {
 				if (entry->unmap) {
+					pr_info("%s: Unmapping %p\n", __func__,
+						entry->kaddr);
+
 					iounmap(entry->kaddr);
 					entry->unmap = false;
 				} else {
+					pr_info("%s: Releasing %p\n", __func__,
+						entry->kaddr);
+
 					acpi_os_unmap_memory(entry->kaddr,
 							     entry->size);
 				}
@@ -99,9 +114,9 @@ void suspend_nvs_free(void)
  */
 int suspend_nvs_alloc(void)
 {
-	struct nvs_page *entry;
+	struct nvs_page *entry, *end;
 
-	list_for_each_entry(entry, &nvs_list, node) {
+	for (entry = nvs, end = nvs + nvs_span; entry < end; entry++) {
 		entry->data = (void *)__get_free_page(GFP_KERNEL);
 		if (!entry->data) {
 			suspend_nvs_free();
@@ -116,26 +131,44 @@ int suspend_nvs_alloc(void)
  */
 int suspend_nvs_save(void)
 {
-	struct nvs_page *entry;
+	struct nvs_page *entry, *end;
+	unsigned long phys = nvs_start;
 
 	printk(KERN_INFO "PM: Saving platform NVS memory\n");
 
-	list_for_each_entry(entry, &nvs_list, node)
-		if (entry->data) {
-			unsigned long phys = entry->phys_start;
-			unsigned int size = entry->size;
+	for (entry = nvs, end = nvs + nvs_span; entry < end; entry++) {
+		unsigned int size = entry->size;
+		void __iomem *kaddr;
 
-			entry->kaddr = acpi_os_get_iomem(phys, size);
-			if (!entry->kaddr) {
-				entry->kaddr = acpi_os_ioremap(phys, size);
-				entry->unmap = true;
-			}
-			if (!entry->kaddr) {
-				suspend_nvs_free();
-				return -ENOMEM;
-			}
-			memcpy(entry->data, entry->kaddr, entry->size);
+		if (!entry->data) {
+			suspend_nvs_free();
+			return -ENOMEM;
+		}
+
+		pr_info("%s: Trying to map %lx, %d\n", __func__, phys, size);
+
+		kaddr = acpi_os_get_iomem(phys, size);
+		if (!kaddr) {
+			kaddr = acpi_os_ioremap(phys, size);
+			entry->unmap = !!kaddr;
+		} else {
+			pr_info("%s: Got address %p\n", __func__, kaddr);
 		}
+		entry->kaddr = kaddr;
+
+		if (!entry->kaddr) {
+			pr_info("%s: Mapping failed\n", __func__);
+
+			suspend_nvs_free();
+			return -EIO;
+		} else {
+			pr_info("%s: Using address %p\n", __func__, entry->kaddr);
+		}
+
+		memcpy(entry->data, entry->kaddr, size);
+
+		phys += size;
+	}
 
 	return 0;
 }
@@ -148,11 +181,11 @@ int suspend_nvs_save(void)
  */
 void suspend_nvs_restore(void)
 {
-	struct nvs_page *entry;
+	struct nvs_page *entry, *end;
 
 	printk(KERN_INFO "PM: Restoring platform NVS memory\n");
 
-	list_for_each_entry(entry, &nvs_list, node)
+	for (entry = nvs, end = nvs + nvs_span; entry < end; entry++)
 		if (entry->data)
 			memcpy(entry->kaddr, entry->data, entry->size);
 }
