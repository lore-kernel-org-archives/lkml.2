Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1ATLis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:38:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60035 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467Ab1ATLil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:38:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 1/11] ACPI: Introduce acpi_os_ioremap()
Date: Thu, 20 Jan 2011 12:27:55 +0100
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
Message-Id: <201101201227.55407.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit ca9b600 (ACPI / PM: Make suspend_nvs_save() use
acpi_os_map_memory()) attempted to prevent the code in osl.c and
nvs.c from using different ioremap() variants by making the latter
use acpi_os_map_memory() for mapping the NVS pages.  However, that
also requires acpi_os_unmap_memory() to be used for unmapping them,
which causes synchronize_rcu() to be executed many times in a row
unnecessarily and introduces substantial delays during resume on
some systems.

Instead of using acpi_os_map_memory() for mapping the NVS pages in
nvs.c introduce acpi_os_ioremap() calling ioremap_cache() and make
the code in both osl.c and nvs.c use it.

Reported-and-tested-by: Jeff Chua <jeff.chua.linux@gmail.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/nvs.c      |    7 ++++---
 drivers/acpi/osl.c      |   12 +++++++-----
 include/linux/acpi.h    |    3 ---
 include/linux/acpi_io.h |   16 ++++++++++++++++
 4 files changed, 27 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/acpi/osl.c
===================================================================
--- linux-2.6.orig/drivers/acpi/osl.c
+++ linux-2.6/drivers/acpi/osl.c
@@ -38,6 +38,7 @@
 #include <linux/workqueue.h>
 #include <linux/nmi.h>
 #include <linux/acpi.h>
+#include <linux/acpi_io.h>
 #include <linux/efi.h>
 #include <linux/ioport.h>
 #include <linux/list.h>
@@ -302,9 +303,10 @@ void __iomem *__init_refok
 acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
 {
 	struct acpi_ioremap *map, *tmp_map;
-	unsigned long flags, pg_sz;
+	unsigned long flags;
 	void __iomem *virt;
-	phys_addr_t pg_off;
+	acpi_physical_address pg_off;
+	acpi_size pg_sz;
 
 	if (phys > ULONG_MAX) {
 		printk(KERN_ERR PREFIX "Cannot map memory that high\n");
@@ -320,7 +322,7 @@ acpi_os_map_memory(acpi_physical_address
 
 	pg_off = round_down(phys, PAGE_SIZE);
 	pg_sz = round_up(phys + size, PAGE_SIZE) - pg_off;
-	virt = ioremap_cache(pg_off, pg_sz);
+	virt = acpi_os_ioremap(pg_off, pg_sz);
 	if (!virt) {
 		kfree(map);
 		return NULL;
@@ -642,7 +644,7 @@ acpi_os_read_memory(acpi_physical_addres
 	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
 	rcu_read_unlock();
 	if (!virt_addr) {
-		virt_addr = ioremap_cache(phys_addr, size);
+		virt_addr = acpi_os_ioremap(phys_addr, size);
 		unmap = 1;
 	}
 	if (!value)
@@ -678,7 +680,7 @@ acpi_os_write_memory(acpi_physical_addre
 	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
 	rcu_read_unlock();
 	if (!virt_addr) {
-		virt_addr = ioremap_cache(phys_addr, size);
+		virt_addr = acpi_os_ioremap(phys_addr, size);
 		unmap = 1;
 	}
 
Index: linux-2.6/drivers/acpi/nvs.c
===================================================================
--- linux-2.6.orig/drivers/acpi/nvs.c
+++ linux-2.6/drivers/acpi/nvs.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
+#include <linux/acpi_io.h>
 #include <acpi/acpiosxf.h>
 
 /*
@@ -80,7 +81,7 @@ void suspend_nvs_free(void)
 			free_page((unsigned long)entry->data);
 			entry->data = NULL;
 			if (entry->kaddr) {
-				acpi_os_unmap_memory(entry->kaddr, entry->size);
+				iounmap(entry->kaddr);
 				entry->kaddr = NULL;
 			}
 		}
@@ -114,8 +115,8 @@ int suspend_nvs_save(void)
 
 	list_for_each_entry(entry, &nvs_list, node)
 		if (entry->data) {
-			entry->kaddr = acpi_os_map_memory(entry->phys_start,
-							  entry->size);
+			entry->kaddr = acpi_os_ioremap(entry->phys_start,
+						    entry->size);
 			if (!entry->kaddr) {
 				suspend_nvs_free();
 				return -ENOMEM;
Index: linux-2.6/include/linux/acpi.h
===================================================================
--- linux-2.6.orig/include/linux/acpi.h
+++ linux-2.6/include/linux/acpi.h
@@ -306,9 +306,6 @@ extern acpi_status acpi_pci_osc_control_
 					     u32 *mask, u32 req);
 extern void acpi_early_init(void);
 
-int acpi_os_map_generic_address(struct acpi_generic_address *addr);
-void acpi_os_unmap_generic_address(struct acpi_generic_address *addr);
-
 #else	/* !CONFIG_ACPI */
 
 #define acpi_disabled 1
Index: linux-2.6/include/linux/acpi_io.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/acpi_io.h
@@ -0,0 +1,16 @@
+#ifndef _ACPI_IO_H_
+#define _ACPI_IO_H_
+
+#include <linux/io.h>
+#include <acpi/acpi.h>
+
+static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
+					    acpi_size size)
+{
+       return ioremap_cache(phys, size);
+}
+
+int acpi_os_map_generic_address(struct acpi_generic_address *addr);
+void acpi_os_unmap_generic_address(struct acpi_generic_address *addr);
+
+#endif

