Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab0HZRRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:17:11 -0400
Received: from relay2.sgi.com ([192.48.179.30]:46510 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751714Ab0HZRRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:17:08 -0400
Date: Thu, 26 Aug 2010 12:17:04 -0500
From: Jack Steiner <steiner@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>, hmh@hmh.eng.br, mingo@elte.hu,
        tglx@linutronix.de, lenb@kernel.org, tony.luck@gmail.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC  - V2] - Mapping ACPI tables as CACHED
Message-ID: <20100826171704.GA21584@sgi.com>
References: <20100722152220.GA18290@sgi.com> <20100724001449.GA9618@khazad-dum.debian.net> <4C743C0F.2010101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C743C0F.2010101@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Map ACPI tables as WB on x86_64. No substantive changes to IA64.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
V2 - Change the patch to unconditionally map ACPI tables as WB on x86_64.
     I'm still some paranoid about this because of the potential imapct on
     some platforms with weird BIOSs. However, note that on EFI-enabled
     systems (like UV), the ACPI tables are already mapped as WB memory.
     This is done in the EFI function efi_enter_virtual_mode().
     The ACPI code in acpi_os_map_memory() is not currently aware of the
     EFI mapping & currently maps the memory as UC. This seems like a bug.




 arch/ia64/kernel/acpi.c     |    5 +++++
 arch/x86/kernel/acpi/boot.c |   14 ++++++++++++++
 drivers/acpi/osl.c          |    2 +-
 include/linux/acpi.h        |    1 +
 4 files changed, 21 insertions(+), 1 deletion(-)

Index: linux/arch/ia64/kernel/acpi.c
===================================================================
--- linux.orig/arch/ia64/kernel/acpi.c	2010-08-26 09:32:46.000000000 -0500
+++ linux/arch/ia64/kernel/acpi.c	2010-08-26 11:51:05.544732478 -0500
@@ -172,6 +172,11 @@ char *__init __acpi_map_table(unsigned l
 	return __va(phys_addr);
 }
 
+char *__init __acpi_map_table_permanent(unsigned long phys_addr, unsigned long size)
+{
+	return ioremap(phys_addr, size);
+}
+
 void __init __acpi_unmap_table(char *map, unsigned long size)
 {
 }
Index: linux/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux.orig/arch/x86/kernel/acpi/boot.c	2010-08-26 09:32:48.000000000 -0500
+++ linux/arch/x86/kernel/acpi/boot.c	2010-08-26 11:57:27.408724846 -0500
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
+	    		e820_all_mapped(phys, phys + size, E820_ACPI) ||
+			e820_all_mapped(phys, phys + size, E820_NVS))
+		return ioremap_cache((unsigned long)phys, size);
+	else
+		return ioremap(phys, size);
+}
+
 #ifdef CONFIG_X86_LOCAL_APIC
 static int __init acpi_parse_madt(struct acpi_table_header *table)
 {
Index: linux/drivers/acpi/osl.c
===================================================================
--- linux.orig/drivers/acpi/osl.c	2010-08-26 09:32:48.276653117 -0500
+++ linux/drivers/acpi/osl.c	2010-08-26 11:45:33.488606489 -0500
@@ -271,7 +271,7 @@ acpi_os_map_memory(acpi_physical_address
 		/*
 		* ioremap checks to ensure this is in reserved space
 		*/
-		return ioremap((unsigned long)phys, size);
+		return __acpi_map_table_permanent((unsigned long)phys, size);
 	else
 		return __acpi_map_table((unsigned long)phys, size);
 }
Index: linux/include/linux/acpi.h
===================================================================
--- linux.orig/include/linux/acpi.h	2010-08-26 09:32:51.000000000 -0500
+++ linux/include/linux/acpi.h	2010-08-26 11:41:14.484709188 -0500
@@ -77,6 +77,7 @@ typedef int (*acpi_table_handler) (struc
 typedef int (*acpi_table_entry_handler) (struct acpi_subtable_header *header, const unsigned long end);
 
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
+char * __acpi_map_table_permanent (unsigned long phys_addr, unsigned long size);
 void __acpi_unmap_table(char *map, unsigned long size);
 int early_acpi_boot_init(void);
 int acpi_boot_init (void);
