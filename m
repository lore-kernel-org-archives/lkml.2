Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab1ATLjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:39:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60065 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab1ATLjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:39:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 8/11] ACPI: Do not use krefs under a mutex in osl.c
Date: Thu, 20 Jan 2011 12:34:57 +0100
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
Message-Id: <201101201234.57619.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The reference counting of ACPI iomaps is carried out entirely under
acpi_ioremap_lock, so it is sufficient to use simple counters instead
of krefs for this purpose.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/osl.c |   36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

Index: linux-2.6/drivers/acpi/osl.c
===================================================================
--- linux-2.6.orig/drivers/acpi/osl.c
+++ linux-2.6/drivers/acpi/osl.c
@@ -105,7 +105,7 @@ struct acpi_ioremap {
 	void __iomem *virt;
 	acpi_physical_address phys;
 	acpi_size size;
-	struct kref ref;
+	unsigned long refcount;
 };
 
 static LIST_HEAD(acpi_ioremaps);
@@ -319,7 +319,7 @@ acpi_os_map_memory(acpi_physical_address
 	/* Check if there's a suitable mapping already. */
 	map = acpi_map_lookup(phys, size);
 	if (map) {
-		kref_get(&map->ref);
+		map->refcount++;
 		goto out;
 	}
 
@@ -342,7 +342,7 @@ acpi_os_map_memory(acpi_physical_address
 	map->virt = virt;
 	map->phys = pg_off;
 	map->size = pg_sz;
-	kref_init(&map->ref);
+	map->refcount = 1;
 
 	list_add_tail_rcu(&map->list, &acpi_ioremaps);
 
@@ -352,25 +352,24 @@ acpi_os_map_memory(acpi_physical_address
 }
 EXPORT_SYMBOL_GPL(acpi_os_map_memory);
 
-static void acpi_kref_del_iomap(struct kref *ref)
+static void acpi_os_drop_map_ref(struct acpi_ioremap *map)
 {
-	struct acpi_ioremap *map;
-
-	map = container_of(ref, struct acpi_ioremap, ref);
-	list_del_rcu(&map->list);
+	if (!--map->refcount)
+		list_del_rcu(&map->list);
 }
 
-static void acpi_os_remove_map(struct acpi_ioremap *map)
+static void acpi_os_map_cleanup(struct acpi_ioremap *map)
 {
-	synchronize_rcu();
-	iounmap(map->virt);
-	kfree(map);
+	if (!map->refcount) {
+		synchronize_rcu();
+		iounmap(map->virt);
+		kfree(map);
+	}
 }
 
 void __ref acpi_os_unmap_memory(void __iomem *virt, acpi_size size)
 {
 	struct acpi_ioremap *map;
-	int del;
 
 	if (!acpi_gbl_permanent_mmap) {
 		__acpi_unmap_table(virt, size);
@@ -384,11 +383,10 @@ void __ref acpi_os_unmap_memory(void __i
 		WARN(true, PREFIX "%s: bad address %p\n", __func__, virt);
 		return;
 	}
-	del = kref_put(&map->ref, acpi_kref_del_iomap);
+	acpi_os_drop_map_ref(map);
 	mutex_unlock(&acpi_ioremap_lock);
 
-	if (del)
-		acpi_os_remove_map(map);
+	acpi_os_map_cleanup(map);
 }
 EXPORT_SYMBOL_GPL(acpi_os_unmap_memory);
 
@@ -418,7 +416,6 @@ static int acpi_os_map_generic_address(s
 static void acpi_os_unmap_generic_address(struct acpi_generic_address *addr)
 {
 	struct acpi_ioremap *map;
-	int del;
 
 	if (addr->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
 		return;
@@ -432,11 +429,10 @@ static void acpi_os_unmap_generic_addres
 		mutex_unlock(&acpi_ioremap_lock);
 		return;
 	}
-	del = kref_put(&map->ref, acpi_kref_del_iomap);
+	acpi_os_drop_map_ref(map);
 	mutex_unlock(&acpi_ioremap_lock);
 
-	if (del)
-		acpi_os_remove_map(map);
+	acpi_os_map_cleanup(map);
 }
 
 #ifdef ACPI_FUTURE_USAGE

