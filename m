Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab2ACRMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 12:12:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52751 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab2ACRMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 12:12:07 -0500
From: Olof Johansson <olof@lixom.net>
To: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 5/5] x86: efi: allow basic init with mixed 32/64-bit efi/kernel
Date: Tue,  3 Jan 2012 09:11:22 -0800
Message-Id: <1325610682-24811-6-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.8.GIT
In-Reply-To: <1325610682-24811-1-git-send-email-olof@lixom.net>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Traditionally the kernel has refused to setup EFI at all if there's been
a mismatch in 32/64-bit mode between EFI and the kernel.

On some platforms that boot natively through EFI (Chrome OS being one),
we still need to get at least some of the static data such as memory
configuration out of EFI. Runtime services aren't as critical, and
it's a significant amount of work to implement switching between the
operating modes to call between kernel and firmware for thise cases. So
I'm ignoring it for now.

v3:
* Reorganized to a series of patches to make it easier to review, and
  do some of the cleanups I had left out before.

v2:
* Added graceful error handling for 32-bit kernel that gets passed
  EFI data above 4GB.
* Removed some warnings that were missed in first version.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 arch/x86/include/asm/efi.h  |    2 +-
 arch/x86/kernel/setup.c     |   10 ++-
 arch/x86/platform/efi/efi.c |  234 ++++++++++++++++++++++++++++++++-----------
 include/linux/efi.h         |   45 ++++++++
 4 files changed, 228 insertions(+), 63 deletions(-)

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
index e5ec213..6b53e32 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -67,6 +67,9 @@ EXPORT_SYMBOL(efi);
 
 struct efi_memory_map memmap;
 
+bool efi_64bit;
+static bool efi_native;
+
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
@@ -254,7 +257,7 @@ int efi_set_rtc_mmss(unsigned long nowtime)
 
 	status = efi.get_time(&eft, &cap);
 	if (status != EFI_SUCCESS) {
-		pr_err("Oops: efitime: can't read time!\n");
+		printk(KERN_ERR "Oops: efitime: can't read time!\n");
 		return -1;
 	}
 
@@ -268,7 +271,7 @@ int efi_set_rtc_mmss(unsigned long nowtime)
 
 	status = efi.set_time(&eft);
 	if (status != EFI_SUCCESS) {
-		pr_err("Oops: efitime: can't write time!\n");
+		printk(KERN_ERR "Oops: efitime: can't write time!\n");
 		return -1;
 	}
 	return 0;
@@ -282,7 +285,7 @@ unsigned long efi_get_time(void)
 
 	status = efi.get_time(&eft, &cap);
 	if (status != EFI_SUCCESS)
-		pr_err("Oops: efitime: can't read time!\n");
+		printk(KERN_ERR "Oops: efitime: can't read time!\n");
 
 	return mktime(eft.year, eft.month, eft.day, eft.hour,
 		      eft.minute, eft.second);
@@ -338,11 +341,14 @@ static void __init do_add_efi_memmap(void)
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
 
-void __init efi_memblock_x86_reserve_range(void)
+int __init efi_memblock_x86_reserve_range(void)
 {
 	unsigned long pmap;
 
 #ifdef CONFIG_X86_32
+	/* Can't handle data above 4GB at this time */
+	if (boot_params.efi_info.efi_memmap_hi)
+		return -EINVAL;
 	pmap = boot_params.efi_info.efi_memmap;
 #else
 	pmap = (boot_params.efi_info.efi_memmap |
@@ -354,6 +360,8 @@ void __init efi_memblock_x86_reserve_range(void)
 	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
 	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
 	memblock_reserve(pmap, memmap.nr_map * memmap.desc_size);
+
+	return 0;
 }
 
 #if EFI_DEBUG
@@ -367,7 +375,7 @@ static void __init print_efi_memmap(void)
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
 		md = p;
-		pr_info(PFX "mem%02u: type=%u, attr=0x%llx, "
+		printk(KERN_INFO PFX "mem%02u: type=%u, attr=0x%llx, "
 			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
 			i, md->type, md->attribute, md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
@@ -431,25 +439,84 @@ static void __init efi_free_boot_services(void)
 
 static int __init efi_systab_init(void *phys)
 {
-	efi.systab = early_ioremap((unsigned long)efi_phys.systab,
-				   sizeof(efi_system_table_t));
-	if (efi.systab == NULL) {
-		pr_err("Couldn't map the EFI system table!\n");
-		return -ENOMEM;
+	if (efi_64bit) {
+		_efi_system_table_64_t *systab64;
+		u64 tmp = 0;
+
+		systab64 = early_ioremap((unsigned long)phys,
+					 sizeof(*systab64));
+		if (systab64 == NULL) {
+			printk(KERN_ERR "Couldn't map the EFI system table!\n");
+			return -ENOMEM;
+		}
+
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
+#ifdef CONFIG_X86_32
+		if (tmp >> 32) {
+			printk(KERN_ERR "EFI data located above 4GB, disabling.\n");
+			return -EINVAL;
+		}
+#endif
+	} else {
+		_efi_system_table_32_t *systab32;
+
+		systab32 = early_ioremap((unsigned long)phys,
+					 sizeof(*systab32));
+		if (systab32 == NULL) {
+			printk(KERN_ERR "Couldn't map the EFI system table!\n");
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
 	}
-	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
-	early_iounmap(efi.systab, sizeof(efi_system_table_t));
+
 	efi.systab = &efi_systab;
 
 	/*
 	 * Verify the EFI Table
 	 */
-	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE) {
-		pr_err("EFI system table signature incorrect!\n");
-		return -EINVAL;
-	}
+	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
+		printk(KERN_ERR "EFI system table signature incorrect!\n");
 	if ((efi.systab->hdr.revision >> 16) == 0)
-		pr_err("Warning: EFI system table version "
+		printk(KERN_ERR "Warning: EFI system table version "
 		       "%d.%02d, expected 1.00 or greater!\n",
 		       efi.systab->hdr.revision >> 16,
 		       efi.systab->hdr.revision & 0xffff);
@@ -459,52 +526,75 @@ static int __init efi_systab_init(void *phys)
 
 static int __init efi_config_init(u64 tables, int nr_tables)
 {
-	efi_config_table_t *config_tables;
-	int i, sz = sizeof(efi_config_table_t);
+	void *mapped_table, *tablep;
+	int i, sz;
+
+	if (efi_64bit)
+		sz = sizeof(_efi_config_table_64_t);
+	else
+		sz = sizeof(_efi_config_table_32_t);
 
 	/*
 	 * Let's see what config tables the firmware passed to us.
 	 */
-	config_tables = early_ioremap(efi.systab->tables,
-				      efi.systab->nr_tables * sz);
-	if (config_tables == NULL) {
-		pr_err("Could not map EFI Configuration Table!\n");
+	mapped_table = early_ioremap(tables, nr_tables * sz);
+	if (mapped_table == NULL) {
+		printk(KERN_ERR "Could not map EFI Configuration Table!\n");
 		return -ENOMEM;
 	}
 
-	pr_info("");
+	tablep = mapped_table;
+	printk(KERN_INFO);
 	for (i = 0; i < efi.systab->nr_tables; i++) {
-		efi_guid_t guid = config_tables[i].guid;
-		unsigned long table = config_tables[i].table;
-
+		efi_guid_t guid;
+		unsigned long table;
+
+		if (efi_64bit) {
+			u64 table64;
+			guid = ((_efi_config_table_64_t *)tablep)->guid;
+			table64 = ((_efi_config_table_64_t *)tablep)->table;
+			table = table64;
+#ifdef CONFIG_X86_32
+			if (table64 >> 32) {
+				printk(KERN_ERR "EFI table located above "
+						"4GB, disabling.\n");
+				early_iounmap(mapped_table,
+					      efi.systab->nr_tables * sz);
+				return -EINVAL;
+			}
+#endif
+		} else {
+			guid = ((_efi_config_table_32_t *)tablep)->guid;
+			table = ((_efi_config_table_32_t *)tablep)->table;
+		}
 		if (!efi_guidcmp(guid, MPS_TABLE_GUID)) {
 			efi.mps = table;
-			pr_cont(" MPS=0x%lx ", table);
+			printk(" MPS=0x%lx ", table);
 		} else if (!efi_guidcmp(guid, ACPI_20_TABLE_GUID)) {
 			efi.acpi20 = table;
-			pr_cont(" ACPI 2.0=0x%lx ", table);
+			printk(" ACPI 2.0=0x%lx ", table);
 		} else if (!efi_guidcmp(guid, ACPI_TABLE_GUID)) {
 			efi.acpi = table;
-			pr_cont(" ACPI=0x%lx ", table);
+			printk(" ACPI=0x%lx ", table);
 		} else if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID)) {
 			efi.smbios = table;
-			pr_cont(" SMBIOS=0x%lx ", table);
+			printk(" SMBIOS=0x%lx ", table);
 #ifdef CONFIG_X86_UV
 		} else if (!efi_guidcmp(guid, UV_SYSTEM_TABLE_GUID)) {
 			efi.uv_systab = table;
-			pr_cont(" UVsystab=0x%lx ", table);
+			printk(" UVsystab=0x%lx ", table);
 #endif
 		} else if (!efi_guidcmp(guid, HCDP_TABLE_GUID)) {
 			efi.hcdp = table;
-			pr_cont(" HCDP=0x%lx ", table);
+			printk(" HCDP=0x%lx ", table);
 		} else if (!efi_guidcmp(guid, UGA_IO_PROTOCOL_GUID)) {
 			efi.uga = table;
-			pr_cont(" UGA=0x%lx ", table);
+			printk(" UGA=0x%lx ", table);
 		}
+		tablep += sz;
 	}
-	pr_cont("\n");
-	early_iounmap(config_tables, efi.systab->nr_tables * sz);
-
+	printk("\n");
+	early_iounmap(mapped_table, efi.systab->nr_tables * sz);
 	return 0;
 }
 
@@ -512,17 +602,11 @@ static int __init efi_runtime_init(void)
 {
 	efi_runtime_services_t *runtime;
 
-	/*
-	 * Check out the runtime services table. We need to map
-	 * the runtime services table so that we can grab the physical
-	 * address of several of the EFI runtime functions, needed to
-	 * set the firmware into virtual mode.
-	 */
 	runtime = early_ioremap((unsigned long)efi.systab->runtime,
 				sizeof(efi_runtime_services_t));
-
-	if (!runtime) {
-		pr_err("Could not map the EFI runtime service table!\n");
+	if (runtime == NULL) {
+		printk(KERN_ERR "Could not map the EFI runtime service "
+		       "table!\n");
 		return -ENOMEM;
 	}
 	/*
@@ -550,7 +634,7 @@ static int __init efi_memmap_init(void)
 	memmap.map = early_ioremap((unsigned long)memmap.phys_map,
 				   memmap.nr_map * memmap.desc_size);
 	if (memmap.map == NULL) {
-		pr_err("Could not map the EFI memory map!\n");
+		pr_warn("Could not map the EFI memory map!\n");
 		return -ENOMEM;
 	}
 	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
@@ -573,11 +657,19 @@ void __init efi_init(void)
 	void *tmp;
 
 #ifdef CONFIG_X86_32
+	if (boot_params.efi_info.efi_systab_hi ||
+	    boot_params.efi_info.efi_memmap_hi) {
+		printk(KERN_INFO "EFI tables located above 4GB, disabling.\n");
+		efi_enabled = 0;
+		return;
+	}
 	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
+	efi_native = !efi_64bit;
 #else
 	efi_phys.systab = (efi_system_table_t *)
-		(boot_params.efi_info.efi_systab |
-		 ((__u64)boot_params.efi_info.efi_systab_hi<<32));
+			  (boot_params.efi_info.efi_systab |
+			  ((__u64)boot_params.efi_info.efi_systab_hi<<32));
+	efi_native = efi_64bit;
 #endif
 
 	if (efi_systab_init(efi_phys.systab)) {
@@ -594,31 +686,44 @@ void __init efi_init(void)
 			vendor[i] = *c16++;
 		vendor[i] = '\0';
 	} else
-		pr_err(PFX "Could not map the firmware vendor!\n");
+		printk(KERN_ERR PFX "Could not map the firmware vendor!\n");
 	early_iounmap(tmp, 2);
 
-	pr_info("EFI v%u.%.02u by %s\n",
-		efi.systab->hdr.revision >> 16,
-		efi.systab->hdr.revision & 0xffff, vendor);
+	printk(KERN_INFO "EFI v%u.%.02u by %s\n",
+	       efi.systab->hdr.revision >> 16,
+	       efi.systab->hdr.revision & 0xffff, vendor);
 
 	if (efi_config_init(efi.systab->tables, efi.systab->nr_tables)) {
 		efi_enabled = 0;
 		return;
 	}
 
-	if (efi_runtime_init()) {
+	/*
+	 * Check out the runtime services table. We need to map
+	 * the runtime services table so that we can grab the physical
+	 * address of several of the EFI runtime functions, needed to
+	 * set the firmware into virtual mode.
+	 *
+	 * Note: We currently don't support runtime services on an EFI
+	 * that doesn't match the kernel 32/64-bit mode.
+	 */
+
+	if (efi_native && efi_runtime_init()) {
 		efi_enabled = 0;
 		return;
-	}
+	} else
+		printk(KERN_INFO "Not initializing EFI runtime due to "
+				 "32/64 bit mismatch with kernel\n");
 
 	if (efi_memmap_init()) {
 		efi_enabled = 0;
 		return;
 	}
-
 #ifdef CONFIG_X86_32
-	x86_platform.get_wallclock = efi_get_time;
-	x86_platform.set_wallclock = efi_set_rtc_mmss;
+	if (efi_native) {
+		x86_platform.get_wallclock = efi_get_time;
+		x86_platform.set_wallclock = efi_set_rtc_mmss;
+	}
 #endif
 
 #if EFI_DEBUG
@@ -676,6 +781,13 @@ void __init efi_enter_virtual_mode(void)
 
 	efi.systab = NULL;
 
+	/* We don't do virtual mode, since we don't do runtime services, on
+	 * non-native EFI
+	 */
+
+	if (!efi_native)
+		goto out;
+
 	/* Merge contiguous regions of the same type and attribute */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		u64 prev_size;
@@ -724,7 +836,7 @@ void __init efi_enter_virtual_mode(void)
 		md->virt_addr = (u64) (unsigned long) va;
 
 		if (!va) {
-			pr_err(PFX "ioremap of 0x%llX failed!\n",
+			printk(KERN_ERR PFX "ioremap of 0x%llX failed!\n",
 			       (unsigned long long)md->phys_addr);
 			continue;
 		}
@@ -758,7 +870,7 @@ void __init efi_enter_virtual_mode(void)
 		(efi_memory_desc_t *)__pa(new_memmap));
 
 	if (status != EFI_SUCCESS) {
-		pr_alert("Unable to switch EFI into virtual mode "
+		printk(KERN_ALERT "Unable to switch EFI into virtual mode "
 		       "(status=%lx)!\n", status);
 		panic("EFI call to SetVirtualAddressMap() failed!");
 	}
@@ -791,6 +903,8 @@ void __init efi_enter_virtual_mode(void)
 	efi.query_capsule_caps = virt_efi_query_capsule_caps;
 	if (__supported_pte_mask & _PAGE_NX)
 		runtime_code_page_mkexec();
+
+out:
 	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
 	memmap.map = NULL;
 	kfree(new_memmap);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 37c3007..17385ba 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -315,6 +315,16 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 
 typedef struct {
 	efi_guid_t guid;
+	u64 table;
+} _efi_config_table_64_t;
+
+typedef struct {
+	efi_guid_t guid;
+	u32 table;
+} _efi_config_table_32_t;
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
+} _efi_system_table_64_t;
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
+} _efi_system_table_32_t;
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
-- 
1.7.8.GIT

