Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1AXXdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:33:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35667 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab1AXXdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:33:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 5/8] ACPI: Make acpi_os_map_memory() avoid creating unnecessary mappings
Date: Tue, 25 Jan 2011 00:29:35 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <201101201226.41021.rjw@sisk.pl> <201101250025.10817.rjw@sisk.pl>
In-Reply-To: <201101250025.10817.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101250029.35999.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Modify acpi_os_map_memory() so that it doesn't call acpi_os_ioremap()
unconditionally every time it is executed (except when
acpi_gbl_permanent_mmap is unset), which pretty much defeats the
purpose of maintaining the list of ACPI iomaps in osl.c.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/osl.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

Index: linux-2.6/drivers/acpi/osl.c
===================================================================
--- linux-2.6.orig/drivers/acpi/osl.c
+++ linux-2.6/drivers/acpi/osl.c
@@ -302,7 +302,7 @@ acpi_map_lookup_virt(void __iomem *virt,
 void __iomem *__init_refok
 acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
 {
-	struct acpi_ioremap *map, *tmp_map;
+	struct acpi_ioremap *map;
 	void __iomem *virt;
 	acpi_physical_address pg_off;
 	acpi_size pg_sz;
@@ -315,14 +315,25 @@ acpi_os_map_memory(acpi_physical_address
 	if (!acpi_gbl_permanent_mmap)
 		return __acpi_map_table((unsigned long)phys, size);
 
+	mutex_lock(&acpi_ioremap_lock);
+	/* Check if there's a suitable mapping already. */
+	map = acpi_map_lookup(phys, size);
+	if (map) {
+		kref_get(&map->ref);
+		goto out;
+	}
+
 	map = kzalloc(sizeof(*map), GFP_KERNEL);
-	if (!map)
+	if (!map) {
+		mutex_unlock(&acpi_ioremap_lock);
 		return NULL;
+	}
 
 	pg_off = round_down(phys, PAGE_SIZE);
 	pg_sz = round_up(phys + size, PAGE_SIZE) - pg_off;
 	virt = acpi_os_ioremap(pg_off, pg_sz);
 	if (!virt) {
+		mutex_unlock(&acpi_ioremap_lock);
 		kfree(map);
 		return NULL;
 	}
@@ -333,19 +344,10 @@ acpi_os_map_memory(acpi_physical_address
 	map->size = pg_sz;
 	kref_init(&map->ref);
 
-	mutex_lock(&acpi_ioremap_lock);
-	/* Check if page has already been mapped. */
-	tmp_map = acpi_map_lookup(phys, size);
-	if (tmp_map) {
-		kref_get(&tmp_map->ref);
-		mutex_unlock(&acpi_ioremap_lock);
-		iounmap(map->virt);
-		kfree(map);
-		return tmp_map->virt + (phys - tmp_map->phys);
-	}
 	list_add_tail_rcu(&map->list, &acpi_ioremaps);
-	mutex_unlock(&acpi_ioremap_lock);
 
+ out:
+	mutex_unlock(&acpi_ioremap_lock);
 	return map->virt + (phys - map->phys);
 }
 EXPORT_SYMBOL_GPL(acpi_os_map_memory);

