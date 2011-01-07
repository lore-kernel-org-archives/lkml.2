Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab1AGAsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:48:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38190 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991Ab1AGAr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:47:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 5/5] ACPI: Use ioremap_cache()
Date: Fri, 7 Jan 2011 01:46:40 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Jiri Slaby <jirislaby@gmail.com>
References: <201101070141.02951.rjw@sisk.pl>
In-Reply-To: <201101070141.02951.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101070146.40348.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Although the temporary boot-time ACPI table mappings
were set up with CPU caching enabled, the permanent table
mappings and AML run-time region memory accesses were
set up with ioremap(), which on x86 is a synonym for
ioremap_nocache().

Changing this to ioremap_cache() improves performance as
seen when accessing the tables via acpidump,
or /sys/firmware/acpi/tables.  It should also improve
AML run-time performance.

No change on ia64.

Reported-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/ia64/include/asm/io.h |    5 +++++
 drivers/acpi/osl.c         |    6 +++---
 2 files changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/ia64/include/asm/io.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/io.h
+++ linux-2.6/arch/ia64/include/asm/io.h
@@ -426,6 +426,11 @@ extern void __iomem * ioremap_nocache (u
 extern void iounmap (volatile void __iomem *addr);
 extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned long size);
 extern void early_iounmap (volatile void __iomem *addr, unsigned long size);
+static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
+{
+	return ioremap(phys_addr, size);
+}
+
 
 /*
  * String version of IO memory access ops:
Index: linux-2.6/drivers/acpi/osl.c
===================================================================
--- linux-2.6.orig/drivers/acpi/osl.c
+++ linux-2.6/drivers/acpi/osl.c
@@ -320,7 +320,7 @@ acpi_os_map_memory(acpi_physical_address
 
 	pg_off = round_down(phys, PAGE_SIZE);
 	pg_sz = round_up(phys + size, PAGE_SIZE) - pg_off;
-	virt = ioremap(pg_off, pg_sz);
+	virt = ioremap_cache(pg_off, pg_sz);
 	if (!virt) {
 		kfree(map);
 		return NULL;
@@ -642,7 +642,7 @@ acpi_os_read_memory(acpi_physical_addres
 	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
 	rcu_read_unlock();
 	if (!virt_addr) {
-		virt_addr = ioremap(phys_addr, size);
+		virt_addr = ioremap_cache(phys_addr, size);
 		unmap = 1;
 	}
 	if (!value)
@@ -678,7 +678,7 @@ acpi_os_write_memory(acpi_physical_addre
 	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
 	rcu_read_unlock();
 	if (!virt_addr) {
-		virt_addr = ioremap(phys_addr, size);
+		virt_addr = ioremap_cache(phys_addr, size);
 		unmap = 1;
 	}
 

