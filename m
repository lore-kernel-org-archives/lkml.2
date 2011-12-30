Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751031Ab1L3FYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 00:24:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32953 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1L3FYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 00:24:36 -0500
From: Olof Johansson <olof@lixom.net>
To: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH] x86: efi: Allow basic EFI use on mixed 32/64 firmware/kernel
Date: Thu, 29 Dec 2011 21:23:52 -0800
Message-Id: <1325222632-28382-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.8.GIT
In-Reply-To: <1325218186-6443-1-git-send-email-olof@lixom.net>
References: <1325218186-6443-1-git-send-email-olof@lixom.net>
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

I have tested this on 64-bit EFI with 64- and 32-bit kernels. I
unfortunately don't have ready access to a 64-bit capable system that
runs a 32-bit EFI to test it that way around. If someone else has such
a system, I would appreciate a Tested-by.

EFI was already quite lenient when it came to checking for error
conditions, and while I tried to be a bit better here, I didn't
significantly revamp any of the error handling. I also used the same
printk usage as the surrounding code instead of introducing a mix of
pr_<level>() and printk() usage -- I'm sure someone will just convert
the whole file at some point anyway.

v2:
* Added graceful error handling for 32-bit kernel that gets passed
  EFI data above 4GB.
* Removed some warnings that were missed in first version.

Signed-off-by: Olof Johansson <olof@lixom.net>
---

Argh, should have let the first patch sit a little longer, here's a
version with better error handling -- based on IRC discussion it's quite
likely to be needed due to EFI passing in high data. Don't try to deal with it,
just abort gracefully.

 arch/x86/include/asm/efi.h  |    2 +-
 arch/x86/kernel/setup.c     |   10 +-
 arch/x86/platform/efi/efi.c |  321 +++++++++++++++++++++++++++++++------------
 include/linux/efi.h         |   45 ++++++
 4 files changed, 289 insertions(+), 89 deletions(-)

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
index d7d5099..9a1e027 100644
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
+		efi_64bit = 0;
+	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
+		     "EL64", 4)) {
+		efi_enabled = 1;
+		efi_64bit = 1;
 	}
+	if (efi_enabled && efi_memblock_x86_reserve_range())
+		efi_enabled = 0;
 #endif
 
 	x86_init.oem.arch_setup();
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 4cf9bd0..7db1e48 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -67,6 +67,9 @@ EXPORT_SYMBOL(efi);
 
 struct efi_memory_map memmap;
 
+bool efi_64bit;
+static bool efi_native;
+
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
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
@@ -429,29 +437,77 @@ static void __init efi_free_boot_services(void)
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
+		_efi_system_table_64_t *systab64;
+		u64 tmp = 0;
+
+		systab64 = early_ioremap((unsigned long)phys,
+					 sizeof(*systab64));
+		if (systab64 == NULL) {
+			printk(KERN_ERR "Couldn't map the EFI system table!\n");
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
+			printk(KERN_ERR "EFI data located above 4GB, disabling.\n");
+			return -EINVAL;
+		}
 #endif
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
+	}
 
-	efi.systab = early_ioremap((unsigned long)efi_phys.systab,
-				   sizeof(efi_system_table_t));
-	if (efi.systab == NULL)
-		printk(KERN_ERR "Couldn't map the EFI system table!\n");
-	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
-	early_iounmap(efi.systab, sizeof(efi_system_table_t));
 	efi.systab = &efi_systab;
 
 	/*
@@ -465,6 +521,141 @@ void __init efi_init(void)
 		       efi.systab->hdr.revision >> 16,
 		       efi.systab->hdr.revision & 0xffff);
 
+	return 0;
+}
+
+static int __init efi_config_init(u64 tables, int nr_tables)
+{
+	void *mapped_table, *tablep;
+	int i, sz;
+
+	if (efi_64bit)
+		sz = sizeof(_efi_config_table_64_t);
+	else
+		sz = sizeof(_efi_config_table_32_t);
+
+	/*
+	 * Let's see what config tables the firmware passed to us.
+	 */
+	mapped_table = early_ioremap(tables, nr_tables * sz);
+	if (mapped_table == NULL) {
+		printk(KERN_ERR "Could not map EFI Configuration Table!\n");
+		return -ENOMEM;
+	}
+
+	tablep = mapped_table;
+	printk(KERN_INFO);
+	for (i = 0; i < efi.systab->nr_tables; i++) {
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
+		if (!efi_guidcmp(guid, MPS_TABLE_GUID)) {
+			efi.mps = table;
+			printk(" MPS=0x%lx ", table);
+		} else if (!efi_guidcmp(guid, ACPI_20_TABLE_GUID)) {
+			efi.acpi20 = table;
+			printk(" ACPI 2.0=0x%lx ", table);
+		} else if (!efi_guidcmp(guid, ACPI_TABLE_GUID)) {
+			efi.acpi = table;
+			printk(" ACPI=0x%lx ", table);
+		} else if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID)) {
+			efi.smbios = table;
+			printk(" SMBIOS=0x%lx ", table);
+#ifdef CONFIG_X86_UV
+		} else if (!efi_guidcmp(guid, UV_SYSTEM_TABLE_GUID)) {
+			efi.uv_systab = table;
+			printk(" UVsystab=0x%lx ", table);
+#endif
+		} else if (!efi_guidcmp(guid, HCDP_TABLE_GUID)) {
+			efi.hcdp = table;
+			printk(" HCDP=0x%lx ", table);
+		} else if (!efi_guidcmp(guid, UGA_IO_PROTOCOL_GUID)) {
+			efi.uga = table;
+			printk(" UGA=0x%lx ", table);
+		}
+		tablep += sz;
+	}
+	printk("\n");
+	early_iounmap(mapped_table, efi.systab->nr_tables * sz);
+	return 0;
+}
+
+static int __init efi_runtime_init(void)
+{
+	efi_runtime_services_t *runtime;
+
+	runtime = early_ioremap((unsigned long)efi.systab->runtime,
+				sizeof(efi_runtime_services_t));
+	if (runtime == NULL) {
+		printk(KERN_ERR "Could not map the EFI runtime service "
+		       "table!\n");
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
+	early_iounmap(runtime, sizeof(efi_runtime_services_t));
+
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
+		printk(KERN_INFO "EFI tables located above 4GB, disabling.\n");
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
 	/*
 	 * Show what we know for posterity
 	 */
@@ -481,79 +672,26 @@ void __init efi_init(void)
 	       efi.systab->hdr.revision >> 16,
 	       efi.systab->hdr.revision & 0xffff, vendor);
 
-	/*
-	 * Let's see what config tables the firmware passed to us.
-	 */
-	config_tables = early_ioremap(
-		efi.systab->tables,
-		efi.systab->nr_tables * sizeof(efi_config_table_t));
-	if (config_tables == NULL)
-		printk(KERN_ERR "Could not map EFI Configuration Table!\n");
-
-	printk(KERN_INFO);
-	for (i = 0; i < efi.systab->nr_tables; i++) {
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
-#ifdef CONFIG_X86_UV
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					UV_SYSTEM_TABLE_GUID)) {
-			efi.uv_systab = config_tables[i].table;
-			printk(" UVsystab=0x%lx ", config_tables[i].table);
-#endif
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					HCDP_TABLE_GUID)) {
-			efi.hcdp = config_tables[i].table;
-			printk(" HCDP=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					UGA_IO_PROTOCOL_GUID)) {
-			efi.uga = config_tables[i].table;
-			printk(" UGA=0x%lx ", config_tables[i].table);
-		}
+	if (efi_config_init(efi.systab->tables, efi.systab->nr_tables)) {
+		efi_enabled = 0;
+		return;
 	}
-	printk("\n");
-	early_iounmap(config_tables,
-			  efi.systab->nr_tables * sizeof(efi_config_table_t));
 
 	/*
 	 * Check out the runtime services table. We need to map
 	 * the runtime services table so that we can grab the physical
 	 * address of several of the EFI runtime functions, needed to
 	 * set the firmware into virtual mode.
+	 *
+	 * Note: We currently don't support runtime services on an EFI
+	 * that doesn't match the kernel 32/64-bit mode.
 	 */
-	runtime = early_ioremap((unsigned long)efi.systab->runtime,
-				sizeof(efi_runtime_services_t));
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
-	early_iounmap(runtime, sizeof(efi_runtime_services_t));
+
+	if (efi_native)
+		efi_runtime_init();
+	else
+		printk(KERN_INFO "Not initializing EFI runtime due to "
+				 "32/64 bit mismatch with kernel\n");
 
 	/* Map the EFI memory map */
 	memmap.map = early_ioremap((unsigned long)memmap.phys_map,
@@ -570,8 +708,10 @@ void __init efi_init(void)
 		do_add_efi_memmap();
 
 #ifdef CONFIG_X86_32
-	x86_platform.get_wallclock = efi_get_time;
-	x86_platform.set_wallclock = efi_set_rtc_mmss;
+	if (efi_native) {
+		x86_platform.get_wallclock = efi_get_time;
+		x86_platform.set_wallclock = efi_set_rtc_mmss;
+	}
 #endif
 
 #if EFI_DEBUG
@@ -629,6 +769,13 @@ void __init efi_enter_virtual_mode(void)
 
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
@@ -744,6 +891,8 @@ void __init efi_enter_virtual_mode(void)
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

