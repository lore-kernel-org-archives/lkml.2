Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab0LQIIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 03:08:50 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:63305 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab0LQIIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 03:08:49 -0500
Date: Fri, 17 Dec 2010 03:08:27 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Jack Steiner <steiner@sgi.com>
Cc: hpa@zytor.com, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        tony.luck@gmail.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, gbeshers@sgi.com
Subject: [PATCH] ACPI: use ioremap_cache()
In-reply-to: <alpine.LFD.2.00.1012162149370.20940@x980>
Message-id: <alpine.LFD.2.00.1012170307080.20940@x980>
References: <20101214220932.GA1206@sgi.com>
 <alpine.LFD.2.00.1012141903210.25387@x980> <20101215024136.GB19601@sgi.com>
 <alpine.LFD.2.00.1012142302110.4878@x980> <20101215164635.GA27373@sgi.com>
 <alpine.LFD.2.00.1012151536510.21167@x980>
 <alpine.LFD.2.00.1012162149370.20940@x980>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
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
---
 arch/ia64/include/asm/io.h |    5 +++++
 drivers/acpi/osl.c         |    6 +++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index cc8335e..009a7e0 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -426,6 +426,11 @@ extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size)
 extern void iounmap (volatile void __iomem *addr);
 extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned long size);
 extern void early_iounmap (volatile void __iomem *addr, unsigned long size);
+static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
+{
+	return ioremap(unsigned long phys_addr, unsigned long size);
+}
+
 
 /*
  * String version of IO memory access ops:
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 966fedd..85eba53 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -324,7 +324,7 @@ acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
 
 	pg_off = round_down(phys, PAGE_SIZE);
 	pg_sz = round_up(phys + size, PAGE_SIZE) - pg_off;
-	virt = ioremap(pg_off, pg_sz);
+	virt = ioremap_cache(pg_off, pg_sz);
 	if (!virt) {
 		kfree(map);
 		return NULL;
@@ -646,7 +646,7 @@ acpi_os_read_memory(acpi_physical_address phys_addr, u32 * value, u32 width)
 	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
 	rcu_read_unlock();
 	if (!virt_addr) {
-		virt_addr = ioremap(phys_addr, size);
+		virt_addr = ioremap_cache(phys_addr, size);
 		unmap = 1;
 	}
 	if (!value)
@@ -682,7 +682,7 @@ acpi_os_write_memory(acpi_physical_address phys_addr, u32 value, u32 width)
 	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
 	rcu_read_unlock();
 	if (!virt_addr) {
-		virt_addr = ioremap(phys_addr, size);
+		virt_addr = ioremap_cache(phys_addr, size);
 		unmap = 1;
 	}
 
-- 
1.7.3.3.557.gb5c17


