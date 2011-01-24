Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1AXXey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:34:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35668 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab1AXXdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:33:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 3/8] ACPI: Change acpi_ioremap_lock into a mutex
Date: Tue, 25 Jan 2011 00:28:14 +0100
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
Message-Id: <201101250028.14992.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

There's no reason why acpi_ioremap_lock has to be a spinlock,
because all of the functions it is used in may sleep anyway and
there's no reason why it should be locked with interrupts off.
Use a mutex instead (that's going to allow us to put some more
operations under the lock later).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/osl.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

Index: linux-2.6/drivers/acpi/osl.c
===================================================================
--- linux-2.6.orig/drivers/acpi/osl.c
+++ linux-2.6/drivers/acpi/osl.c
@@ -109,7 +109,7 @@ struct acpi_ioremap {
 };
 
 static LIST_HEAD(acpi_ioremaps);
-static DEFINE_SPINLOCK(acpi_ioremap_lock);
+static DEFINE_MUTEX(acpi_ioremap_lock);
 
 static void __init acpi_osi_setup_late(void);
 
@@ -303,7 +303,6 @@ void __iomem *__init_refok
 acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
 {
 	struct acpi_ioremap *map, *tmp_map;
-	unsigned long flags;
 	void __iomem *virt;
 	acpi_physical_address pg_off;
 	acpi_size pg_sz;
@@ -334,18 +333,18 @@ acpi_os_map_memory(acpi_physical_address
 	map->size = pg_sz;
 	kref_init(&map->ref);
 
-	spin_lock_irqsave(&acpi_ioremap_lock, flags);
+	mutex_lock(&acpi_ioremap_lock);
 	/* Check if page has already been mapped. */
 	tmp_map = acpi_map_lookup(phys, size);
 	if (tmp_map) {
 		kref_get(&tmp_map->ref);
-		spin_unlock_irqrestore(&acpi_ioremap_lock, flags);
+		mutex_unlock(&acpi_ioremap_lock);
 		iounmap(map->virt);
 		kfree(map);
 		return tmp_map->virt + (phys - tmp_map->phys);
 	}
 	list_add_tail_rcu(&map->list, &acpi_ioremaps);
-	spin_unlock_irqrestore(&acpi_ioremap_lock, flags);
+	mutex_unlock(&acpi_ioremap_lock);
 
 	return map->virt + (phys - map->phys);
 }
@@ -362,7 +361,6 @@ static void acpi_kref_del_iomap(struct k
 void __ref acpi_os_unmap_memory(void __iomem *virt, acpi_size size)
 {
 	struct acpi_ioremap *map;
-	unsigned long flags;
 	int del;
 
 	if (!acpi_gbl_permanent_mmap) {
@@ -370,17 +368,17 @@ void __ref acpi_os_unmap_memory(void __i
 		return;
 	}
 
-	spin_lock_irqsave(&acpi_ioremap_lock, flags);
+	mutex_lock(&acpi_ioremap_lock);
 	map = acpi_map_lookup_virt(virt, size);
 	if (!map) {
-		spin_unlock_irqrestore(&acpi_ioremap_lock, flags);
+		mutex_unlock(&acpi_ioremap_lock);
 		printk(KERN_ERR PREFIX "%s: bad address %p\n", __func__, virt);
 		dump_stack();
 		return;
 	}
 
 	del = kref_put(&map->ref, acpi_kref_del_iomap);
-	spin_unlock_irqrestore(&acpi_ioremap_lock, flags);
+	mutex_unlock(&acpi_ioremap_lock);
 
 	if (!del)
 		return;
@@ -417,7 +415,6 @@ static int acpi_os_map_generic_address(s
 static void acpi_os_unmap_generic_address(struct acpi_generic_address *addr)
 {
 	void __iomem *virt;
-	unsigned long flags;
 	acpi_size size = addr->bit_width / 8;
 
 	if (addr->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
@@ -426,9 +423,9 @@ static void acpi_os_unmap_generic_addres
 	if (!addr->address || !addr->bit_width)
 		return;
 
-	spin_lock_irqsave(&acpi_ioremap_lock, flags);
+	mutex_lock(&acpi_ioremap_lock);
 	virt = acpi_map_vaddr_lookup(addr->address, size);
-	spin_unlock_irqrestore(&acpi_ioremap_lock, flags);
+	mutex_unlock(&acpi_ioremap_lock);
 
 	acpi_os_unmap_memory(virt, size);
 }

