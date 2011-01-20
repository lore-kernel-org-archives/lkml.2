Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab1ATLjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:39:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60072 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab1ATLjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:39:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 11/11] ACPI / PM: Make NVS save/restore code use slightly less memory
Date: Thu, 20 Jan 2011 12:37:34 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <201101201226.41021.rjw@sisk.pl>
In-Reply-To: <201101201226.41021.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101201237.34551.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Remove the unnecessary field phys_start from struct nvs_page and
rework the code in nvs.c to reflect that change.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/nvs.c |   45 ++++++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/acpi/nvs.c
===================================================================
--- linux-2.6.orig/drivers/acpi/nvs.c
+++ linux-2.6/drivers/acpi/nvs.c
@@ -22,7 +22,6 @@
  */
 
 struct nvs_page {
-	unsigned long phys_start;
 	unsigned int size;
 	void *kaddr;
 	void *data;
@@ -31,6 +30,8 @@ struct nvs_page {
 };
 
 static LIST_HEAD(nvs_list);
+static unsigned long nvs_start;
+static unsigned int nvs_offset;
 
 /**
  *	suspend_nvs_register - register platform NVS memory region to save
@@ -44,25 +45,28 @@ static LIST_HEAD(nvs_list);
 int suspend_nvs_register(unsigned long start, unsigned long size)
 {
 	struct nvs_page *entry, *next;
+	unsigned int offset;
 
+	nvs_start = round_down(start, PAGE_SIZE);
+	nvs_offset = start - nvs_start;
+	offset = nvs_offset;
 	while (size > 0) {
-		unsigned int nr_bytes;
+		unsigned int nr_bytes = PAGE_SIZE - offset;
 
 		entry = kzalloc(sizeof(struct nvs_page), GFP_KERNEL);
 		if (!entry)
-			goto Error;
+			goto err_out;
 
 		list_add_tail(&entry->node, &nvs_list);
-		entry->phys_start = start;
-		nr_bytes = PAGE_SIZE - (start & ~PAGE_MASK);
 		entry->size = (size < nr_bytes) ? size : nr_bytes;
 
 		start += entry->size;
 		size -= entry->size;
+		offset -= offset;
 	}
 	return 0;
 
- Error:
+ err_out:
 	list_for_each_entry_safe(entry, next, &nvs_list, node) {
 		list_del(&entry->node);
 		kfree(entry);
@@ -117,25 +121,32 @@ int suspend_nvs_alloc(void)
 int suspend_nvs_save(void)
 {
 	struct nvs_page *entry;
+	unsigned long page_addr = nvs_start;
+	unsigned int offset = nvs_offset;
 
 	printk(KERN_INFO "PM: Saving platform NVS memory\n");
 
-	list_for_each_entry(entry, &nvs_list, node)
-		if (entry->data) {
-			unsigned long phys = entry->phys_start;
-			unsigned int size = entry->size;
+	list_for_each_entry(entry, &nvs_list, node) {
+		unsigned long phys = page_addr + offset;
+		unsigned int size = entry->size;
 
-			entry->kaddr = acpi_os_get_iomem(phys, size);
-			if (!entry->kaddr) {
-				entry->kaddr = acpi_os_ioremap(phys, size);
-				entry->unmap = true;
-			}
+		if (!entry->data)
+			return -ENOMEM;
+
+		entry->kaddr = acpi_os_get_iomem(phys, size);
+		if (!entry->kaddr) {
+			entry->kaddr = acpi_os_ioremap(phys, size);
 			if (!entry->kaddr) {
 				suspend_nvs_free();
-				return -ENOMEM;
+				return -EIO;
 			}
-			memcpy(entry->data, entry->kaddr, entry->size);
+			entry->unmap = true;
 		}
+		memcpy(entry->data, entry->kaddr, entry->size);
+
+		page_addr += PAGE_SIZE;
+		offset -= offset;
+	}
 
 	return 0;
 }

