Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1ATLi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:38:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60055 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab1ATLiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:38:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 3/11] ACPI: Fix acpi_os_read_memory() and acpi_os_write_memory()
Date: Thu, 20 Jan 2011 12:30:09 +0100
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
Message-Id: <201101201230.10048.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The functions acpi_os_read_memory() and acpi_os_write_memory() do
two wrong things.  First, they shouldn't call rcu_read_unlock()
before the looked up address is actually used for I/O, because in
that case the mapping it belongs to may be removed before the I/O
is done.  Second, they shouldn't use the physical address if
there's no mapping for it, because that may lead to problems (at
least for the "write" case it's like sending data to a random
physical address in the hope it's going to work).

Make the rcu_read_unlock() be called by these functions when the I/O
is complete and modify them to dump stack and return error code if
the requested physical address is not present in the ACPI iomaps.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/osl.c |   31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/acpi/osl.c
===================================================================
--- linux-2.6.orig/drivers/acpi/osl.c
+++ linux-2.6/drivers/acpi/osl.c
@@ -638,17 +638,17 @@ acpi_os_read_memory(acpi_physical_addres
 {
 	u32 dummy;
 	void __iomem *virt_addr;
-	int size = width / 8, unmap = 0;
+
+	if (!value)
+		value = &dummy;
 
 	rcu_read_lock();
-	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
-	rcu_read_unlock();
+	virt_addr = acpi_map_vaddr_lookup(phys_addr, width / 8);
 	if (!virt_addr) {
-		virt_addr = acpi_os_ioremap(phys_addr, size);
-		unmap = 1;
+		rcu_read_unlock();
+		WARN(true, "Address not mapped: %llx\n", phys_addr);
+		return AE_BAD_ADDRESS;
 	}
-	if (!value)
-		value = &dummy;
 
 	switch (width) {
 	case 8:
@@ -663,9 +663,7 @@ acpi_os_read_memory(acpi_physical_addres
 	default:
 		BUG();
 	}
-
-	if (unmap)
-		iounmap(virt_addr);
+	rcu_read_unlock();
 
 	return AE_OK;
 }
@@ -674,14 +672,13 @@ acpi_status
 acpi_os_write_memory(acpi_physical_address phys_addr, u32 value, u32 width)
 {
 	void __iomem *virt_addr;
-	int size = width / 8, unmap = 0;
 
 	rcu_read_lock();
-	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
-	rcu_read_unlock();
+	virt_addr = acpi_map_vaddr_lookup(phys_addr, width / 8);
 	if (!virt_addr) {
-		virt_addr = acpi_os_ioremap(phys_addr, size);
-		unmap = 1;
+		rcu_read_unlock();
+		WARN(true, "Address not mapped: %llx\n", phys_addr);
+		return AE_BAD_ADDRESS;
 	}
 
 	switch (width) {
@@ -697,9 +694,7 @@ acpi_os_write_memory(acpi_physical_addre
 	default:
 		BUG();
 	}
-
-	if (unmap)
-		iounmap(virt_addr);
+	rcu_read_unlock();
 
 	return AE_OK;
 }

