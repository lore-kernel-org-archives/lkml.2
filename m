Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab2B1Cr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:47:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49935 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392Ab2B1Cr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:47:27 -0500
Date: Mon, 27 Feb 2012 18:46:56 -0800
From: tip-bot for Olof Johansson <olof@lixom.net>
Message-ID: <tip-1adbfa3511ee1c1118e16a9a0246870f12fef4e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        olof@lixom.net, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        olof@lixom.net, tglx@linutronix.de
In-Reply-To: <1329081869-20779-6-git-send-email-olof@lixom.net>
References: <1329081869-20779-6-git-send-email-olof@lixom.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/eficross] x86, efi: Allow basic init with mixed 32/
 64-bit efi/kernel
Git-Commit-ID: 1adbfa3511ee1c1118e16a9a0246870f12fef4e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Feb 2012 18:47:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1adbfa3511ee1c1118e16a9a0246870f12fef4e6
Gitweb:     http://git.kernel.org/tip/1adbfa3511ee1c1118e16a9a0246870f12fef4e6
Author:     Olof Johansson <olof@lixom.net>
AuthorDate: Sun, 12 Feb 2012 13:24:29 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 23 Feb 2012 18:54:51 -0800

x86, efi: Allow basic init with mixed 32/64-bit efi/kernel

Traditionally the kernel has refused to setup EFI at all if there's been
a mismatch in 32/64-bit mode between EFI and the kernel.

On some platforms that boot natively through EFI (Chrome OS being one),
we still need to get at least some of the static data such as memory
configuration out of EFI. Runtime services aren't as critical, and
it's a significant amount of work to implement switching between the
operating modes to call between kernel and firmware for thise cases. So
I'm ignoring it for now.

v5:
* Fixed some printk strings based on feedback
* Renamed 32/64-bit specific types to not have _ prefix
* Fixed bug in printout of efi runtime disablement

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
Link: http://lkml.kernel.org/r/1329081869-20779-6-git-send-email-olof@lixom.net
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/efi.h  |    2 +-
 arch/x86/kernel/setup.c     |   10 ++-
 arch/x86/platform/efi/efi.c |  164 +++++++++++++++++++++++++++++++++++++------
 include/linux/efi.h         |   45 ++++++++++++
 4 files changed, 196 insertions(+), 25 deletions(-)

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
index 5a053e7..92660eda 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -68,6 +68,9 @@ EXPORT_SYMBOL(efi);
 
 struct efi_memory_map memmap;
 
+bool efi_64bit;
+static bool efi_native;
+
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
@@ -339,11 +342,16 @@ static void __init do_add_efi_memmap(void)
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
@@ -355,6 +363,8 @@ void __init efi_memblock_x86_reserve_range(void)
 	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
 	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
 	memblock_reserve(pmap, memmap.nr_map * memmap.desc_size);
+
+	return 0;
 }
 
 #if EFI_DEBUG
@@ -432,14 +442,75 @@ static void __init efi_free_boot_services(void)
 
 static int __init efi_systab_init(void *phys)
 {
-	efi.systab = early_ioremap((unsigned long)efi_phys.systab,
-				   sizeof(efi_system_table_t));
-	if (efi.systab == NULL) {
-		pr_err("Couldn't map the system table!\n");
-		return -ENOMEM;
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
+			pr_err("EFI data located above 4GB, disabling EFI.\n");
+			return -EINVAL;
+		}
+#endif
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
 	}
-	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
-	early_iounmap(efi.systab, sizeof(efi_system_table_t));
+
 	efi.systab = &efi_systab;
 
 	/*
@@ -460,24 +531,47 @@ static int __init efi_systab_init(void *phys)
 
 static int __init efi_config_init(u64 tables, int nr_tables)
 {
-	efi_config_table_t *config_tables;
-	int i, sz = sizeof(efi_config_table_t);
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
 		if (!efi_guidcmp(guid, MPS_TABLE_GUID)) {
 			efi.mps = table;
 			pr_cont(" MPS=0x%lx ", table);
@@ -502,10 +596,10 @@ static int __init efi_config_init(u64 tables, int nr_tables)
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
 
@@ -569,11 +663,19 @@ void __init efi_init(void)
 	void *tmp;
 
 #ifdef CONFIG_X86_32
+	if (boot_params.efi_info.efi_systab_hi ||
+	    boot_params.efi_info.efi_memmap_hi) {
+		pr_info("Table located above 4GB, disabling EFI.\n");
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
@@ -602,7 +704,14 @@ void __init efi_init(void)
 		return;
 	}
 
-	if (efi_runtime_init()) {
+	/*
+	 * Note: We currently don't support runtime services on an EFI
+	 * that doesn't match the kernel 32/64-bit mode.
+	 */
+
+	if (!efi_native)
+		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
+	else if (efi_runtime_init()) {
 		efi_enabled = 0;
 		return;
 	}
@@ -611,10 +720,11 @@ void __init efi_init(void)
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
@@ -672,6 +782,14 @@ void __init efi_enter_virtual_mode(void)
 
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
@@ -787,6 +905,8 @@ void __init efi_enter_virtual_mode(void)
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
