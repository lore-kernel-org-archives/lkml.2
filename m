Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab0LNWJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:09:38 -0500
Received: from relay2.sgi.com ([192.48.179.30]:56002 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753085Ab0LNWJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:09:37 -0500
Date: Tue, 14 Dec 2010 16:09:32 -0600
From: Jack Steiner <steiner@sgi.com>
To: lenb@kernel.org
Cc: hpa@zytor.com, hmh@hmh.eng.br, tony.luck@gmail.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gbeshers@sgi.com
Subject: [PATCH] - Mapping ACPI tables as CACHED
Message-ID: <20101214220932.GA1206@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Map ACPI tables as WB on x86_64. No substantive changes to IA64.

Large SGI UV systems (3072p, 5TB) take a long time to boot. A significant
part of the boot time is scanning ACPI tables. ACPI tables on UV systems
are located in RAM memory that is physically attached to node 0.

User programs (ex., acpidump) read the ACPI tables by mapping them thru
/dev/mem.  Although mmap tries to map the tables as CACHED, there are
existing kernel UNCACHED mapping that conflict and the tables end up as
being mapped UNCACHED.  (See the call to track_pfn_vma_new() in
remap_pfn_range()).

Much of the access is to small fields (bytes (checksums), shorts, etc).
Late in boot, there is significant scanning of the ACPI tables that take
place from nodes other than zero. Since the tables are not cached, each
reference accesses physical memory that is attached to remote nodes. These
memory requests must cross the numalink interconnect which adds several
hundred nsec to each access. This slows the boot process.  Access from
node 0, although faster, is still very slow.



The following patch changes the kernel mapping for ACPI tables
to CACHED. This eliminates the page attibute conflict & allows users to map
the tables CACHEABLE. This significantly speeds up boot:

        38 minutes without the patch
        27 minutes with the patch
                ~30% improvement

Time to run ACPIDUMP on a large system:
        527 seconds without the patch
          8 seconds with the patch



Signed-off-by: Jack Steiner <steiner@sgi.com>

---
(resend of earlier patch)
	http://marc.info/?l=linux-kernel&m=128206079905826&w=2
	http://marc.info/?l=linux-acpi&m=128284304032481&w=2


V2 - Change the patch to unconditionally map ACPI tables as WB on x86_64.

V3 - same as V2 except updated to 2.6.37-rc5


---
 arch/ia64/kernel/acpi.c     |    6 ++++++
 arch/x86/kernel/acpi/boot.c |   14 ++++++++++++++
 drivers/acpi/osl.c          |    2 +-
 include/linux/acpi.h        |    1 +
 4 files changed, 22 insertions(+), 1 deletion(-)

Index: linux/arch/ia64/kernel/acpi.c
===================================================================
--- linux.orig/arch/ia64/kernel/acpi.c	2010-12-14 15:51:33.230235579 -0600
+++ linux/arch/ia64/kernel/acpi.c	2010-12-14 16:02:26.718529904 -0600
@@ -176,6 +176,12 @@ void __init __acpi_unmap_table(char *map
 {
 }
 
+char *__init __acpi_map_table_permanent(unsigned long phys_addr,
+					unsigned long size)
+{
+	return ioremap(phys_addr, size);
+}
+
 /* --------------------------------------------------------------------------
                             Boot-time Table Parsing
    -------------------------------------------------------------------------- */
Index: linux/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux.orig/arch/x86/kernel/acpi/boot.c	2010-12-14 15:51:33.230235579 -0600
+++ linux/arch/x86/kernel/acpi/boot.c	2010-12-14 15:52:06.070227289 -0600
@@ -167,6 +167,20 @@ void __init __acpi_unmap_table(char *map
 	early_iounmap(map, size);
 }
 
+/*
+ * Permanently map memory for ACPI. Map ACPI tables and RAM as WB,
+ * other regions as UC.
+ */
+char *__init __acpi_map_table_permanent(unsigned long phys, unsigned long size)
+{
+	if (e820_all_mapped(phys, phys + size, E820_RAM) ||
+			e820_all_mapped(phys, phys + size, E820_ACPI) ||
+			e820_all_mapped(phys, phys + size, E820_NVS))
+		return ioremap_cache((unsigned long)phys, size);
+	 else
+		return ioremap(phys, size);
+}
+
 #ifdef CONFIG_X86_LOCAL_APIC
 static int __init acpi_parse_madt(struct acpi_table_header *table)
 {
Index: linux/drivers/acpi/osl.c
===================================================================
--- linux.orig/drivers/acpi/osl.c	2010-12-14 15:51:33.230235579 -0600
+++ linux/drivers/acpi/osl.c	2010-12-14 15:52:06.098240079 -0600
@@ -324,7 +324,7 @@ acpi_os_map_memory(acpi_physical_address
 
 	pg_off = round_down(phys, PAGE_SIZE);
 	pg_sz = round_up(phys + size, PAGE_SIZE) - pg_off;
-	virt = ioremap(pg_off, pg_sz);
+	virt = __acpi_map_table_permanent(pg_off, pg_sz);
 	if (!virt) {
 		kfree(map);
 		return NULL;
Index: linux/include/linux/acpi.h
===================================================================
--- linux.orig/include/linux/acpi.h	2010-12-14 15:51:33.230235579 -0600
+++ linux/include/linux/acpi.h	2010-12-14 16:03:23.042529564 -0600
@@ -77,6 +77,7 @@ typedef int (*acpi_table_handler) (struc
 typedef int (*acpi_table_entry_handler) (struct acpi_subtable_header *header, const unsigned long end);
 
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
+char *__acpi_map_table_permanent(unsigned long phys_addr, unsigned long size);
 void __acpi_unmap_table(char *map, unsigned long size);
 int early_acpi_boot_init(void);
 int acpi_boot_init (void);
