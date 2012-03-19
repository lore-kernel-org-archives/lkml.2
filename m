Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162235Ab2CSQtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:49:55 -0400
Received: from mail-we0-f194.google.com ([74.125.82.194]:32922 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162218Ab2CSQtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:49:52 -0400
Date: Mon, 19 Mar 2012 17:49:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/eficross changes for v3.4
Message-ID: <20120319164948.GA12608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-eficross-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-eficross-for-linus

   HEAD: 1adbfa3511ee1c1118e16a9a0246870f12fef4e6 x86, efi: Allow basic init with mixed 32/64-bit efi/kernel

 Thanks,

	Ingo

------------------>
Olof Johansson (5):
      x86, efi: Refactor efi_init() a bit
      x86, efi: Convert printk to pr_*()
      x86, efi: Cleanup config table walking
      x86, efi: Add basic error handling
      x86, efi: Allow basic init with mixed 32/64-bit efi/kernel


 arch/x86/include/asm/efi.h  |    2 +-
 arch/x86/kernel/setup.c     |   10 +-
 arch/x86/platform/efi/efi.c |  377 +++++++++++++++++++++++++++++++------------
 include/linux/efi.h         |   45 +++++
 4 files changed, 324 insertions(+), 110 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 844f735..c9dcc18 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -95,7 +95,7 @@ extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
 
 extern int add_efi_memmap;
 extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
-extern void efi_memblock_x86_reserve_range(void);
+extern int efi_memblock_x86_reserve_range(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d7d5099..8863888 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -749,10 +749,16 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #ifdef CONFIG_EFI
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     EFI_LOADER_SIGNATURE, 4)) {
+		     "EL32", 4)) {
 		efi_enabled = 1;
-		efi_memblock_x86_reserve_range();
+		efi_64bit = false;
+	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
+		     "EL64", 4)) {
+		efi_enabled = 1;
+		efi_64bit = true;
 	}
+	if (efi_enabled && efi_memblock_x86_reserve_range())
+		efi_enabled = 0;
 #endif
 
 	x86_init.oem.arch_setup();
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 4cf9bd0..92660eda 100644
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
@@ -67,6 +68,9 @@ EXPORT_SYMBOL(efi);
 
 struct efi_memory_map memmap;
 
+bool efi_64bit;
+static bool efi_native;
+
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
@@ -254,7 +258,7 @@ int efi_set_rtc_mmss(unsigned long nowtime)
 
 	status = efi.get_time(&eft, &cap);
 	if (status != EFI_SUCCESS) {
-		printk(KERN_ERR "Oops: efitime: can't read time!\n");
+		pr_err("Oops: efitime: can't read time!\n");
 		return -1;
 	}
 
@@ -268,7 +272,7 @@ int efi_set_rtc_mmss(unsigned long nowtime)
 
 	status = efi.set_time(&eft);
 	if (status != EFI_SUCCESS) {
-		printk(KERN_ERR "Oops: efitime: can't write time!\n");
+		pr_err("Oops: efitime: can't write time!\n");
 		return -1;
 	}
 	return 0;
@@ -282,7 +286,7 @@ unsigned long efi_get_time(void)
 
 	status = efi.get_time(&eft, &cap);
 	if (status != EFI_SUCCESS)
-		printk(KERN_ERR "Oops: efitime: can't read time!\n");
+		pr_err("Oops: efitime: can't read time!\n");
 
 	return mktime(eft.year, eft.month, eft.day, eft.hour,
 		      eft.minute, eft.second);
@@ -338,11 +342,16 @@ static void __init do_add_efi_memmap(void)
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
 
-void __init efi_memblock_x86_reserve_range(void)
+int __init efi_memblock_x86_reserve_range(void)
 {
 	unsigned long pmap;
 
 #ifdef CONFIG_X86_32
+	/* Can't handle data above 4GB at this time */
+	if (boot_params.efi_info.efi_memmap_hi) {
+		pr_err("Memory map is above 4GB, disabling EFI.\n");
+		return -EINVAL;
+	}
 	pmap = boot_params.efi_info.efi_memmap;
 #else
 	pmap = (boot_params.efi_info.efi_memmap |
@@ -354,6 +363,8 @@ void __init efi_memblock_x86_reserve_range(void)
 	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
 	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
 	memblock_reserve(pmap, memmap.nr_map * memmap.desc_size);
+
+	return 0;
 }
 
 #if EFI_DEBUG
@@ -367,7 +378,7 @@ static void __init print_efi_memmap(void)
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
 		md = p;
-		printk(KERN_INFO PFX "mem%02u: type=%u, attr=0x%llx, "
+		pr_info("mem%02u: type=%u, attr=0x%llx, "
 			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
 			i, md->type, md->attribute, md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
@@ -400,7 +411,7 @@ void __init efi_reserve_boot_services(void)
 			memblock_is_region_reserved(start, size)) {
 			/* Could not reserve, skip it */
 			md->num_pages = 0;
-			memblock_dbg(PFX "Could not reserve boot range "
+			memblock_dbg("Could not reserve boot range "
 					"[0x%010llx-0x%010llx]\n",
 						start, start+size-1);
 		} else
@@ -429,103 +440,172 @@ static void __init efi_free_boot_services(void)
 	}
 }
 
-void __init efi_init(void)
+static int __init efi_systab_init(void *phys)
 {
-	efi_config_table_t *config_tables;
-	efi_runtime_services_t *runtime;
-	efi_char16_t *c16;
-	char vendor[100] = "unknown";
-	int i = 0;
-	void *tmp;
+	if (efi_64bit) {
+		efi_system_table_64_t *systab64;
+		u64 tmp = 0;
+
+		systab64 = early_ioremap((unsigned long)phys,
+					 sizeof(*systab64));
+		if (systab64 == NULL) {
+			pr_err("Couldn't map the system table!\n");
+			return -ENOMEM;
+		}
 
+		efi_systab.hdr = systab64->hdr;
+		efi_systab.fw_vendor = systab64->fw_vendor;
+		tmp |= systab64->fw_vendor;
+		efi_systab.fw_revision = systab64->fw_revision;
+		efi_systab.con_in_handle = systab64->con_in_handle;
+		tmp |= systab64->con_in_handle;
+		efi_systab.con_in = systab64->con_in;
+		tmp |= systab64->con_in;
+		efi_systab.con_out_handle = systab64->con_out_handle;
+		tmp |= systab64->con_out_handle;
+		efi_systab.con_out = systab64->con_out;
+		tmp |= systab64->con_out;
+		efi_systab.stderr_handle = systab64->stderr_handle;
+		tmp |= systab64->stderr_handle;
+		efi_systab.stderr = systab64->stderr;
+		tmp |= systab64->stderr;
+		efi_systab.runtime = (void *)(unsigned long)systab64->runtime;
+		tmp |= systab64->runtime;
+		efi_systab.boottime = (void *)(unsigned long)systab64->boottime;
+		tmp |= systab64->boottime;
+		efi_systab.nr_tables = systab64->nr_tables;
+		efi_systab.tables = systab64->tables;
+		tmp |= systab64->tables;
+
+		early_iounmap(systab64, sizeof(*systab64));
 #ifdef CONFIG_X86_32
-	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
-#else
-	efi_phys.systab = (efi_system_table_t *)
-		(boot_params.efi_info.efi_systab |
-		 ((__u64)boot_params.efi_info.efi_systab_hi<<32));
+		if (tmp >> 32) {
+			pr_err("EFI data located above 4GB, disabling EFI.\n");
+			return -EINVAL;
+		}
 #endif
+	} else {
+		efi_system_table_32_t *systab32;
+
+		systab32 = early_ioremap((unsigned long)phys,
+					 sizeof(*systab32));
+		if (systab32 == NULL) {
+			pr_err("Couldn't map the system table!\n");
+			return -ENOMEM;
+		}
+
+		efi_systab.hdr = systab32->hdr;
+		efi_systab.fw_vendor = systab32->fw_vendor;
+		efi_systab.fw_revision = systab32->fw_revision;
+		efi_systab.con_in_handle = systab32->con_in_handle;
+		efi_systab.con_in = systab32->con_in;
+		efi_systab.con_out_handle = systab32->con_out_handle;
+		efi_systab.con_out = systab32->con_out;
+		efi_systab.stderr_handle = systab32->stderr_handle;
+		efi_systab.stderr = systab32->stderr;
+		efi_systab.runtime = (void *)(unsigned long)systab32->runtime;
+		efi_systab.boottime = (void *)(unsigned long)systab32->boottime;
+		efi_systab.nr_tables = systab32->nr_tables;
+		efi_systab.tables = systab32->tables;
+
+		early_iounmap(systab32, sizeof(*systab32));
+	}
 
-	efi.systab = early_ioremap((unsigned long)efi_phys.systab,
-				   sizeof(efi_system_table_t));
-	if (efi.systab == NULL)
-		printk(KERN_ERR "Couldn't map the EFI system table!\n");
-	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
-	early_iounmap(efi.systab, sizeof(efi_system_table_t));
 	efi.systab = &efi_systab;
 
 	/*
 	 * Verify the EFI Table
 	 */
-	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
-		printk(KERN_ERR "EFI system table signature incorrect!\n");
+	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE) {
+		pr_err("System table signature incorrect!\n");
+		return -EINVAL;
+	}
 	if ((efi.systab->hdr.revision >> 16) == 0)
-		printk(KERN_ERR "Warning: EFI system table version "
+		pr_err("Warning: System table version "
 		       "%d.%02d, expected 1.00 or greater!\n",
 		       efi.systab->hdr.revision >> 16,
 		       efi.systab->hdr.revision & 0xffff);
 
-	/*
-	 * Show what we know for posterity
-	 */
-	c16 = tmp = early_ioremap(efi.systab->fw_vendor, 2);
-	if (c16) {
-		for (i = 0; i < sizeof(vendor) - 1 && *c16; ++i)
-			vendor[i] = *c16++;
-		vendor[i] = '\0';
-	} else
-		printk(KERN_ERR PFX "Could not map the firmware vendor!\n");
-	early_iounmap(tmp, 2);
+	return 0;
+}
 
-	printk(KERN_INFO "EFI v%u.%.02u by %s\n",
-	       efi.systab->hdr.revision >> 16,
-	       efi.systab->hdr.revision & 0xffff, vendor);
+static int __init efi_config_init(u64 tables, int nr_tables)
+{
+	void *config_tables, *tablep;
+	int i, sz;
+
+	if (efi_64bit)
+		sz = sizeof(efi_config_table_64_t);
+	else
+		sz = sizeof(efi_config_table_32_t);
 
 	/*
 	 * Let's see what config tables the firmware passed to us.
 	 */
-	config_tables = early_ioremap(
-		efi.systab->tables,
-		efi.systab->nr_tables * sizeof(efi_config_table_t));
-	if (config_tables == NULL)
-		printk(KERN_ERR "Could not map EFI Configuration Table!\n");
+	config_tables = early_ioremap(tables, nr_tables * sz);
+	if (config_tables == NULL) {
+		pr_err("Could not map Configuration table!\n");
+		return -ENOMEM;
+	}
 
-	printk(KERN_INFO);
+	tablep = config_tables;
+	pr_info("");
 	for (i = 0; i < efi.systab->nr_tables; i++) {
-		if (!efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID)) {
-			efi.mps = config_tables[i].table;
-			printk(" MPS=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					ACPI_20_TABLE_GUID)) {
-			efi.acpi20 = config_tables[i].table;
-			printk(" ACPI 2.0=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					ACPI_TABLE_GUID)) {
-			efi.acpi = config_tables[i].table;
-			printk(" ACPI=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					SMBIOS_TABLE_GUID)) {
-			efi.smbios = config_tables[i].table;
-			printk(" SMBIOS=0x%lx ", config_tables[i].table);
+		efi_guid_t guid;
+		unsigned long table;
+
+		if (efi_64bit) {
+			u64 table64;
+			guid = ((efi_config_table_64_t *)tablep)->guid;
+			table64 = ((efi_config_table_64_t *)tablep)->table;
+			table = table64;
+#ifdef CONFIG_X86_32
+			if (table64 >> 32) {
+				pr_cont("\n");
+				pr_err("Table located above 4GB, disabling EFI.\n");
+				early_iounmap(config_tables,
+					      efi.systab->nr_tables * sz);
+				return -EINVAL;
+			}
+#endif
+		} else {
+			guid = ((efi_config_table_32_t *)tablep)->guid;
+			table = ((efi_config_table_32_t *)tablep)->table;
+		}
+		if (!efi_guidcmp(guid, MPS_TABLE_GUID)) {
+			efi.mps = table;
+			pr_cont(" MPS=0x%lx ", table);
+		} else if (!efi_guidcmp(guid, ACPI_20_TABLE_GUID)) {
+			efi.acpi20 = table;
+			pr_cont(" ACPI 2.0=0x%lx ", table);
+		} else if (!efi_guidcmp(guid, ACPI_TABLE_GUID)) {
+			efi.acpi = table;
+			pr_cont(" ACPI=0x%lx ", table);
+		} else if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID)) {
+			efi.smbios = table;
+			pr_cont(" SMBIOS=0x%lx ", table);
 #ifdef CONFIG_X86_UV
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					UV_SYSTEM_TABLE_GUID)) {
-			efi.uv_systab = config_tables[i].table;
-			printk(" UVsystab=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(guid, UV_SYSTEM_TABLE_GUID)) {
+			efi.uv_systab = table;
+			pr_cont(" UVsystab=0x%lx ", table);
 #endif
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					HCDP_TABLE_GUID)) {
-			efi.hcdp = config_tables[i].table;
-			printk(" HCDP=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					UGA_IO_PROTOCOL_GUID)) {
-			efi.uga = config_tables[i].table;
-			printk(" UGA=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(guid, HCDP_TABLE_GUID)) {
+			efi.hcdp = table;
+			pr_cont(" HCDP=0x%lx ", table);
+		} else if (!efi_guidcmp(guid, UGA_IO_PROTOCOL_GUID)) {
+			efi.uga = table;
+			pr_cont(" UGA=0x%lx ", table);
 		}
+		tablep += sz;
 	}
-	printk("\n");
-	early_iounmap(config_tables,
-			  efi.systab->nr_tables * sizeof(efi_config_table_t));
+	pr_cont("\n");
+	early_iounmap(config_tables, efi.systab->nr_tables * sz);
+	return 0;
+}
+
+static int __init efi_runtime_init(void)
+{
+	efi_runtime_services_t *runtime;
 
 	/*
 	 * Check out the runtime services table. We need to map
@@ -535,43 +615,116 @@ void __init efi_init(void)
 	 */
 	runtime = early_ioremap((unsigned long)efi.systab->runtime,
 				sizeof(efi_runtime_services_t));
-	if (runtime != NULL) {
-		/*
-		 * We will only need *early* access to the following
-		 * two EFI runtime services before set_virtual_address_map
-		 * is invoked.
-		 */
-		efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
-		efi_phys.set_virtual_address_map =
-			(efi_set_virtual_address_map_t *)
-			runtime->set_virtual_address_map;
-		/*
-		 * Make efi_get_time can be called before entering
-		 * virtual mode.
-		 */
-		efi.get_time = phys_efi_get_time;
-	} else
-		printk(KERN_ERR "Could not map the EFI runtime service "
-		       "table!\n");
+	if (!runtime) {
+		pr_err("Could not map the runtime service table!\n");
+		return -ENOMEM;
+	}
+	/*
+	 * We will only need *early* access to the following
+	 * two EFI runtime services before set_virtual_address_map
+	 * is invoked.
+	 */
+	efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
+	efi_phys.set_virtual_address_map =
+		(efi_set_virtual_address_map_t *)
+		runtime->set_virtual_address_map;
+	/*
+	 * Make efi_get_time can be called before entering
+	 * virtual mode.
+	 */
+	efi.get_time = phys_efi_get_time;
 	early_iounmap(runtime, sizeof(efi_runtime_services_t));
 
+	return 0;
+}
+
+static int __init efi_memmap_init(void)
+{
 	/* Map the EFI memory map */
 	memmap.map = early_ioremap((unsigned long)memmap.phys_map,
 				   memmap.nr_map * memmap.desc_size);
-	if (memmap.map == NULL)
-		printk(KERN_ERR "Could not map the EFI memory map!\n");
+	if (memmap.map == NULL) {
+		pr_err("Could not map the memory map!\n");
+		return -ENOMEM;
+	}
 	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
 
-	if (memmap.desc_size != sizeof(efi_memory_desc_t))
-		printk(KERN_WARNING
-		  "Kernel-defined memdesc doesn't match the one from EFI!\n");
-
 	if (add_efi_memmap)
 		do_add_efi_memmap();
 
+	return 0;
+}
+
+void __init efi_init(void)
+{
+	efi_char16_t *c16;
+	char vendor[100] = "unknown";
+	int i = 0;
+	void *tmp;
+
+#ifdef CONFIG_X86_32
+	if (boot_params.efi_info.efi_systab_hi ||
+	    boot_params.efi_info.efi_memmap_hi) {
+		pr_info("Table located above 4GB, disabling EFI.\n");
+		efi_enabled = 0;
+		return;
+	}
+	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
+	efi_native = !efi_64bit;
+#else
+	efi_phys.systab = (efi_system_table_t *)
+			  (boot_params.efi_info.efi_systab |
+			  ((__u64)boot_params.efi_info.efi_systab_hi<<32));
+	efi_native = efi_64bit;
+#endif
+
+	if (efi_systab_init(efi_phys.systab)) {
+		efi_enabled = 0;
+		return;
+	}
+
+	/*
+	 * Show what we know for posterity
+	 */
+	c16 = tmp = early_ioremap(efi.systab->fw_vendor, 2);
+	if (c16) {
+		for (i = 0; i < sizeof(vendor) - 1 && *c16; ++i)
+			vendor[i] = *c16++;
+		vendor[i] = '\0';
+	} else
+		pr_err("Could not map the firmware vendor!\n");
+	early_iounmap(tmp, 2);
+
+	pr_info("EFI v%u.%.02u by %s\n",
+		efi.systab->hdr.revision >> 16,
+		efi.systab->hdr.revision & 0xffff, vendor);
+
+	if (efi_config_init(efi.systab->tables, efi.systab->nr_tables)) {
+		efi_enabled = 0;
+		return;
+	}
+
+	/*
+	 * Note: We currently don't support runtime services on an EFI
+	 * that doesn't match the kernel 32/64-bit mode.
+	 */
+
+	if (!efi_native)
+		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
+	else if (efi_runtime_init()) {
+		efi_enabled = 0;
+		return;
+	}
+
+	if (efi_memmap_init()) {
+		efi_enabled = 0;
+		return;
+	}
 #ifdef CONFIG_X86_32
-	x86_platform.get_wallclock = efi_get_time;
-	x86_platform.set_wallclock = efi_set_rtc_mmss;
+	if (efi_native) {
+		x86_platform.get_wallclock = efi_get_time;
+		x86_platform.set_wallclock = efi_set_rtc_mmss;
+	}
 #endif
 
 #if EFI_DEBUG
@@ -629,6 +782,14 @@ void __init efi_enter_virtual_mode(void)
 
 	efi.systab = NULL;
 
+	/*
+	 * We don't do virtual mode, since we don't do runtime services, on
+	 * non-native EFI
+	 */
+
+	if (!efi_native)
+		goto out;
+
 	/* Merge contiguous regions of the same type and attribute */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		u64 prev_size;
@@ -677,7 +838,7 @@ void __init efi_enter_virtual_mode(void)
 		md->virt_addr = (u64) (unsigned long) va;
 
 		if (!va) {
-			printk(KERN_ERR PFX "ioremap of 0x%llX failed!\n",
+			pr_err("ioremap of 0x%llX failed!\n",
 			       (unsigned long long)md->phys_addr);
 			continue;
 		}
@@ -711,8 +872,8 @@ void __init efi_enter_virtual_mode(void)
 		(efi_memory_desc_t *)__pa(new_memmap));
 
 	if (status != EFI_SUCCESS) {
-		printk(KERN_ALERT "Unable to switch EFI into virtual mode "
-		       "(status=%lx)!\n", status);
+		pr_alert("Unable to switch EFI into virtual mode "
+			 "(status=%lx)!\n", status);
 		panic("EFI call to SetVirtualAddressMap() failed!");
 	}
 
@@ -744,6 +905,8 @@ void __init efi_enter_virtual_mode(void)
 	efi.query_capsule_caps = virt_efi_query_capsule_caps;
 	if (__supported_pte_mask & _PAGE_NX)
 		runtime_code_page_mkexec();
+
+out:
 	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
 	memmap.map = NULL;
 	kfree(new_memmap);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 37c3007..47fbf6b 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -315,6 +315,16 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 
 typedef struct {
 	efi_guid_t guid;
+	u64 table;
+} efi_config_table_64_t;
+
+typedef struct {
+	efi_guid_t guid;
+	u32 table;
+} efi_config_table_32_t;
+
+typedef struct {
+	efi_guid_t guid;
 	unsigned long table;
 } efi_config_table_t;
 
@@ -329,6 +339,40 @@ typedef struct {
 
 typedef struct {
 	efi_table_hdr_t hdr;
+	u64 fw_vendor;	/* physical addr of CHAR16 vendor string */
+	u32 fw_revision;
+	u32 __pad1;
+	u64 con_in_handle;
+	u64 con_in;
+	u64 con_out_handle;
+	u64 con_out;
+	u64 stderr_handle;
+	u64 stderr;
+	u64 runtime;
+	u64 boottime;
+	u32 nr_tables;
+	u32 __pad2;
+	u64 tables;
+} efi_system_table_64_t;
+
+typedef struct {
+	efi_table_hdr_t hdr;
+	u32 fw_vendor;	/* physical addr of CHAR16 vendor string */
+	u32 fw_revision;
+	u32 con_in_handle;
+	u32 con_in;
+	u32 con_out_handle;
+	u32 con_out;
+	u32 stderr_handle;
+	u32 stderr;
+	u32 runtime;
+	u32 boottime;
+	u32 nr_tables;
+	u32 tables;
+} efi_system_table_32_t;
+
+typedef struct {
+	efi_table_hdr_t hdr;
 	unsigned long fw_vendor;	/* physical addr of CHAR16 vendor string */
 	u32 fw_revision;
 	unsigned long con_in_handle;
@@ -497,6 +541,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #ifdef CONFIG_EFI
 # ifdef CONFIG_X86
    extern int efi_enabled;
+   extern bool efi_64bit;
 # else
 #  define efi_enabled 1
 # endif
