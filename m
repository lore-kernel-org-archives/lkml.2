Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab2BHA10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 19:27:26 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57580 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab2BHA1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 19:27:21 -0500
From: Olof Johansson <olof@lixom.net>
To: x86@kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, matt.fleming@intel.com, mjg@redhat.com,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH 5/5] x86: efi: allow basic init with mixed 32/64-bit efi/kernel
Date: Tue,  7 Feb 2012 16:25:32 -0800
Message-Id: <1328660732-27263-6-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1328660732-27263-1-git-send-email-olof@lixom.net>
References: <1328660732-27263-1-git-send-email-olof@lixom.net>
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

v4:
* Some of the earlier cleanup was accidentally reverted by this patch, fixed.
* Reworded some messages to not have to line wrap printk strings

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
 arch/x86/platform/efi/efi.c |  164 +++++++++++++++++++++++++++++++++++++------
 include/linux/efi.h         |   45 ++++++++++++
 4 files changed, 195 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 26d8c18..4103e4d 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -90,7 +90,7 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 
 extern int add_efi_memmap;
 extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
-extern void efi_memblock_x86_reserve_range(void);
+extern int efi_memblock_x86_reserve_range(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e22bb08..a7ce9b5 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -751,10 +751,16 @@ void __init setup_arch(char **cmdline_p)
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
index c1111f7..14449b3 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -68,6 +68,9 @@ EXPORT_SYMBOL(efi);
 
 struct efi_memory_map memmap;
 
+bool efi_64bit;
+static bool efi_native;
+
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
@@ -346,11 +349,16 @@ static void __init do_add_efi_memmap(void)
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
@@ -362,6 +370,8 @@ void __init efi_memblock_x86_reserve_range(void)
 	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
 	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
 	memblock_reserve(pmap, memmap.nr_map * memmap.desc_size);
+
+	return 0;
 }
 
 #if EFI_DEBUG
@@ -439,14 +449,75 @@ static void __init efi_free_boot_services(void)
 
 static int __init efi_systab_init(void *phys)
 {
-	efi.systab = early_ioremap((unsigned long)efi_phys.systab,
-				   sizeof(efi_system_table_t));
-	if (efi.systab == NULL) {
-		pr_err("Couldn't map the system table!\n");
-		return -ENOMEM;
+	if (efi_64bit) {
+		_efi_system_table_64_t *systab64;
+		u64 tmp = 0;
+
+		systab64 = early_ioremap((unsigned long)phys,
+					 sizeof(*systab64));
+		if (systab64 == NULL) {
+			pr_err("Couldn't map the system table!\n");
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
+			pr_err("EFI data located above 4GB, disabling.\n");
+			return -EINVAL;
+		}
+#endif
+	} else {
+		_efi_system_table_32_t *systab32;
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
 	}
-	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
-	early_iounmap(efi.systab, sizeof(efi_system_table_t));
+
 	efi.systab = &efi_systab;
 
 	/*
@@ -467,24 +538,47 @@ static int __init efi_systab_init(void *phys)
 
 static int __init efi_config_init(u64 tables, int nr_tables)
 {
-	efi_config_table_t *config_tables;
-	int i, sz = sizeof(efi_config_table_t);
+	void *config_tables, *tablep;
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
+	config_tables = early_ioremap(tables, nr_tables * sz);
 	if (config_tables == NULL) {
 		pr_err("Could not map Configuration table!\n");
 		return -ENOMEM;
 	}
 
+	tablep = config_tables;
 	pr_info("");
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
+				pr_cont("\n");
+				pr_err("Table located above 4GB, disabling.\n");
+				early_iounmap(config_tables,
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
 			pr_cont(" MPS=0x%lx ", table);
@@ -509,10 +603,10 @@ static int __init efi_config_init(u64 tables, int nr_tables)
 			efi.uga = table;
 			pr_cont(" UGA=0x%lx ", table);
 		}
+		tablep += sz;
 	}
 	pr_cont("\n");
 	early_iounmap(config_tables, efi.systab->nr_tables * sz);
-
 	return 0;
 }
 
@@ -576,11 +670,19 @@ void __init efi_init(void)
 	void *tmp;
 
 #ifdef CONFIG_X86_32
+	if (boot_params.efi_info.efi_systab_hi ||
+	    boot_params.efi_info.efi_memmap_hi) {
+		pr_info("Table located above 4GB, disabling.\n");
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
@@ -609,19 +711,26 @@ void __init efi_init(void)
 		return;
 	}
 
-	if (efi_runtime_init()) {
+	/*
+	 * Note: We currently don't support runtime services on an EFI
+	 * that doesn't match the kernel 32/64-bit mode.
+	 */
+
+	if (efi_native && efi_runtime_init()) {
 		efi_enabled = 0;
 		return;
-	}
+	} else
+		pr_info("No EFI runtime due to 32/64b mismatch with kernel\n");
 
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
@@ -679,6 +788,13 @@ void __init efi_enter_virtual_mode(void)
 
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
@@ -798,6 +914,8 @@ void __init efi_enter_virtual_mode(void)
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
1.7.9.111.gf3fb0

