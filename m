Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab2BHA1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 19:27:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65166 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab2BHA1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 19:27:14 -0500
From: Olof Johansson <olof@lixom.net>
To: x86@kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, matt.fleming@intel.com, mjg@redhat.com,
        Olof Johansson <olof@lixom.net>, Joe Perches <joe@perches.com>
Subject: [PATCH 2/5] x86: efi: convert printk to pr_*()
Date: Tue,  7 Feb 2012 16:25:29 -0800
Message-Id: <1328660732-27263-3-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1328660732-27263-1-git-send-email-olof@lixom.net>
References: <1328660732-27263-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alright, I guess I'll go through and convert them, even though
there's no net gain to speak of.

v4:
* Switched to pr_fmt and removed some redundant use of "EFI" in
  messages.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Joe Perches <joe@perches.com>
---
 arch/x86/platform/efi/efi.c |   58 +++++++++++++++++++++---------------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index fec2b2e..777de17 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -26,6 +26,8 @@
  *	Skip non-WB memory and ignore empty memory ranges.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/efi.h>
@@ -47,7 +49,6 @@
 #include <asm/x86_init.h>
 
 #define EFI_DEBUG	1
-#define PFX 		"EFI: "
 
 int efi_enabled;
 EXPORT_SYMBOL(efi_enabled);
@@ -254,7 +255,7 @@ int efi_set_rtc_mmss(unsigned long nowtime)
 
 	status = efi.get_time(&eft, &cap);
 	if (status != EFI_SUCCESS) {
-		printk(KERN_ERR "Oops: efitime: can't read time!\n");
+		pr_err("Oops: efitime: can't read time!\n");
 		return -1;
 	}
 
@@ -268,7 +269,7 @@ int efi_set_rtc_mmss(unsigned long nowtime)
 
 	status = efi.set_time(&eft);
 	if (status != EFI_SUCCESS) {
-		printk(KERN_ERR "Oops: efitime: can't write time!\n");
+		pr_err("Oops: efitime: can't write time!\n");
 		return -1;
 	}
 	return 0;
@@ -282,7 +283,7 @@ unsigned long efi_get_time(void)
 
 	status = efi.get_time(&eft, &cap);
 	if (status != EFI_SUCCESS)
-		printk(KERN_ERR "Oops: efitime: can't read time!\n");
+		pr_err("Oops: efitime: can't read time!\n");
 
 	return mktime(eft.year, eft.month, eft.day, eft.hour,
 		      eft.minute, eft.second);
@@ -374,7 +375,7 @@ static void __init print_efi_memmap(void)
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
 		md = p;
-		printk(KERN_INFO PFX "mem%02u: type=%u, attr=0x%llx, "
+		pr_info("mem%02u: type=%u, attr=0x%llx, "
 			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
 			i, md->type, md->attribute, md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
@@ -407,7 +408,7 @@ void __init efi_reserve_boot_services(void)
 			memblock_is_region_reserved(start, size)) {
 			/* Could not reserve, skip it */
 			md->num_pages = 0;
-			memblock_dbg(PFX "Could not reserve boot range "
+			memblock_dbg("Could not reserve boot range "
 					"[0x%010llx-0x%010llx]\n",
 						start, start+size-1);
 		} else
@@ -441,7 +442,7 @@ static void __init efi_systab_init(void *phys)
 	efi.systab = early_ioremap((unsigned long)efi_phys.systab,
 				   sizeof(efi_system_table_t));
 	if (efi.systab == NULL)
-		printk(KERN_ERR "Couldn't map the EFI system table!\n");
+		pr_err("Couldn't map the system table!\n");
 	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
 	early_iounmap(efi.systab, sizeof(efi_system_table_t));
 	efi.systab = &efi_systab;
@@ -450,9 +451,9 @@ static void __init efi_systab_init(void *phys)
 	 * Verify the EFI Table
 	 */
 	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
-		printk(KERN_ERR "EFI system table signature incorrect!\n");
+		pr_err("System table signature incorrect!\n");
 	if ((efi.systab->hdr.revision >> 16) == 0)
-		printk(KERN_ERR "Warning: EFI system table version "
+		pr_err("Warning: System table version "
 		       "%d.%02d, expected 1.00 or greater!\n",
 		       efi.systab->hdr.revision >> 16,
 		       efi.systab->hdr.revision & 0xffff);
@@ -470,42 +471,42 @@ static void __init efi_config_init(u64 tables, int nr_tables)
 		efi.systab->tables,
 		efi.systab->nr_tables * sizeof(efi_config_table_t));
 	if (config_tables == NULL)
-		printk(KERN_ERR "Could not map EFI Configuration Table!\n");
+		pr_err("Could not map Configuration table!\n");
 
-	printk(KERN_INFO);
+	pr_info("");
 	for (i = 0; i < efi.systab->nr_tables; i++) {
 		if (!efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID)) {
 			efi.mps = config_tables[i].table;
-			printk(" MPS=0x%lx ", config_tables[i].table);
+			pr_cont(" MPS=0x%lx ", config_tables[i].table);
 		} else if (!efi_guidcmp(config_tables[i].guid,
 					ACPI_20_TABLE_GUID)) {
 			efi.acpi20 = config_tables[i].table;
-			printk(" ACPI 2.0=0x%lx ", config_tables[i].table);
+			pr_cont(" ACPI 2.0=0x%lx ", config_tables[i].table);
 		} else if (!efi_guidcmp(config_tables[i].guid,
 					ACPI_TABLE_GUID)) {
 			efi.acpi = config_tables[i].table;
-			printk(" ACPI=0x%lx ", config_tables[i].table);
+			pr_cont(" ACPI=0x%lx ", config_tables[i].table);
 		} else if (!efi_guidcmp(config_tables[i].guid,
 					SMBIOS_TABLE_GUID)) {
 			efi.smbios = config_tables[i].table;
-			printk(" SMBIOS=0x%lx ", config_tables[i].table);
+			pr_cont(" SMBIOS=0x%lx ", config_tables[i].table);
 #ifdef CONFIG_X86_UV
 		} else if (!efi_guidcmp(config_tables[i].guid,
 					UV_SYSTEM_TABLE_GUID)) {
 			efi.uv_systab = config_tables[i].table;
-			printk(" UVsystab=0x%lx ", config_tables[i].table);
+			pr_cont(" UVsystab=0x%lx ", config_tables[i].table);
 #endif
 		} else if (!efi_guidcmp(config_tables[i].guid,
 					HCDP_TABLE_GUID)) {
 			efi.hcdp = config_tables[i].table;
-			printk(" HCDP=0x%lx ", config_tables[i].table);
+			pr_cont(" HCDP=0x%lx ", config_tables[i].table);
 		} else if (!efi_guidcmp(config_tables[i].guid,
 					UGA_IO_PROTOCOL_GUID)) {
 			efi.uga = config_tables[i].table;
-			printk(" UGA=0x%lx ", config_tables[i].table);
+			pr_cont(" UGA=0x%lx ", config_tables[i].table);
 		}
 	}
-	printk("\n");
+	pr_cont("\n");
 	early_iounmap(config_tables,
 			  efi.systab->nr_tables * sizeof(efi_config_table_t));
 }
@@ -538,8 +539,7 @@ static void __init efi_runtime_init(void)
 		 */
 		efi.get_time = phys_efi_get_time;
 	} else
-		printk(KERN_ERR "Could not map the EFI runtime service "
-		       "table!\n");
+		pr_err("Could not map the runtime service table!\n");
 	early_iounmap(runtime, sizeof(efi_runtime_services_t));
 }
 
@@ -549,7 +549,7 @@ static void __init efi_memmap_init(void)
 	memmap.map = early_ioremap((unsigned long)memmap.phys_map,
 				   memmap.nr_map * memmap.desc_size);
 	if (memmap.map == NULL)
-		printk(KERN_ERR "Could not map the EFI memory map!\n");
+		pr_err("Could not map the memory map!\n");
 	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
 
 	if (add_efi_memmap)
@@ -582,12 +582,12 @@ void __init efi_init(void)
 			vendor[i] = *c16++;
 		vendor[i] = '\0';
 	} else
-		printk(KERN_ERR PFX "Could not map the firmware vendor!\n");
+		pr_err("Could not map the firmware vendor!\n");
 	early_iounmap(tmp, 2);
 
-	printk(KERN_INFO "EFI v%u.%.02u by %s\n",
-	       efi.systab->hdr.revision >> 16,
-	       efi.systab->hdr.revision & 0xffff, vendor);
+	pr_info("EFI v%u.%.02u by %s\n",
+		efi.systab->hdr.revision >> 16,
+		efi.systab->hdr.revision & 0xffff, vendor);
 
 	efi_config_init(efi.systab->tables, efi.systab->nr_tables);
 
@@ -714,7 +714,7 @@ void __init efi_enter_virtual_mode(void)
 		md->virt_addr = (u64) (unsigned long) va;
 
 		if (!va) {
-			printk(KERN_ERR PFX "ioremap of 0x%llX failed!\n",
+			pr_err("ioremap of 0x%llX failed!\n",
 			       (unsigned long long)md->phys_addr);
 			continue;
 		}
@@ -741,8 +741,8 @@ void __init efi_enter_virtual_mode(void)
 		(efi_memory_desc_t *)__pa(new_memmap));
 
 	if (status != EFI_SUCCESS) {
-		printk(KERN_ALERT "Unable to switch EFI into virtual mode "
-		       "(status=%lx)!\n", status);
+		pr_alert("Unable to switch EFI into virtual mode "
+			 "(status=%lx)!\n", status);
 		panic("EFI call to SetVirtualAddressMap() failed!");
 	}
 
-- 
1.7.9.111.gf3fb0

