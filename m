Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab3ACN1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:27:45 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:39173 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800Ab3ACN1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:27:33 -0500
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2013 08:27:32 EST
From: Matt Fleming <matt@console-pimps.org>
To: Steve Langasek <steve.langasek@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Olof Johansson <olof@lixom.net>,
        Tony Luck <tony.luck@intel.com>, Matt Fleming <matt.fleming@intel.com>,
        David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Dave Jiang <dave.jiang@intel.com>, Peter Jones <pjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [RFC PATCH 1/2] efi: Make 'efi_enabled' a function to query EFI facilities
Date: Thu,  3 Jan 2013 13:18:04 +0000
Message-Id: <1357219085-4312-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357219085-4312-1-git-send-email-matt@console-pimps.org>
References: <1357219085-4312-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Originally 'efi_enabled' indicated whether a kernel was booted from
EFI firmware. Over time its semantics have changed, and it now
indicates whether or not we are booted on an EFI machine with
bit-native firmware, e.g. 64-bit kernel with 64-bit firmware.

But users actually want to query 'efi_enabled' for different reasons -
what they really want access to is the list of available EFI
facilities.

For instance, the x86 reboot code needs to know whether it can invoke
the ResetSystem() function provided by the EFI runtime services, while
the ACPI OSL code wants to know whether the EFI config tables were
mapped successfully. There are also checks in some of the platform
driver code to simply see if they're running on an EFI machine (which
would make it a bad idea to do BIOS-y things).

A machine's EFI facilities are naturally represented by a bitfield.

Cc: David Airlie <airlied@linux.ie>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Peter Jones <pjones@redhat.com>
Cc: Steve Langasek <steve.langasek@canonical.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/include/asm/efi.h             |  1 +
 arch/x86/kernel/reboot.c               |  2 +-
 arch/x86/kernel/setup.c                | 28 ++++++++---------
 arch/x86/platform/efi/efi.c            | 55 ++++++++++++++++++++--------------
 drivers/acpi/osl.c                     |  2 +-
 drivers/firmware/dmi_scan.c            |  2 +-
 drivers/firmware/efivars.c             |  4 +--
 drivers/firmware/iscsi_ibft_find.c     |  2 +-
 drivers/gpu/drm/radeon/radeon_device.c |  3 +-
 drivers/platform/x86/ibm_rtl.c         |  2 +-
 drivers/scsi/isci/init.c               |  2 +-
 include/linux/efi.h                    | 24 +++++++++++----
 init/main.c                            |  4 +--
 13 files changed, 77 insertions(+), 54 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 6e8fdf5..28677c5 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -94,6 +94,7 @@ extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
 #endif /* CONFIG_X86_32 */
 
 extern int add_efi_memmap;
+extern unsigned long x86_efi_facility;
 extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern int efi_memblock_x86_reserve_range(void);
 extern void efi_call_phys_prelog(void);
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 4e8ba39..76fa1e9 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -584,7 +584,7 @@ static void native_machine_emergency_restart(void)
 			break;
 
 		case BOOT_EFI:
-			if (efi_enabled)
+			if (efi_enabled(EFI_RUNTIME_SERVICES))
 				efi.reset_system(reboot_mode ?
 						 EFI_RESET_WARM :
 						 EFI_RESET_COLD,
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ca45696..3583477 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -733,15 +733,15 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_EFI
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
 		     "EL32", 4)) {
-		efi_enabled = 1;
-		efi_64bit = false;
+		set_bit(EFI_BOOT, &x86_efi_facility);
 	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
 		     "EL64", 4)) {
-		efi_enabled = 1;
-		efi_64bit = true;
+		set_bit(EFI_BOOT, &x86_efi_facility);
+		set_bit(EFI_64BIT, &x86_efi_facility);
 	}
-	if (efi_enabled && efi_memblock_x86_reserve_range())
-		efi_enabled = 0;
+
+	if (efi_enabled(EFI_BOOT))
+		efi_memblock_x86_reserve_range();
 #endif
 
 	x86_init.oem.arch_setup();
@@ -814,7 +814,7 @@ void __init setup_arch(char **cmdline_p)
 
 	finish_e820_parsing();
 
-	if (efi_enabled)
+	if (efi_enabled(EFI_BOOT))
 		efi_init();
 
 	dmi_scan_machine();
@@ -897,7 +897,7 @@ void __init setup_arch(char **cmdline_p)
 	 * The EFI specification says that boot service code won't be called
 	 * after ExitBootServices(). This is, in fact, a lie.
 	 */
-	if (efi_enabled)
+	if (efi_enabled(EFI_MEMMAP))
 		efi_reserve_boot_services();
 
 	/* preallocate 4k for mptable mpc */
@@ -1034,7 +1034,7 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
-	if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
+	if (!efi_enabled(EFI_BOOT) || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
 		conswitchp = &vga_con;
 #elif defined(CONFIG_DUMMY_CONSOLE)
 	conswitchp = &dummy_con;
@@ -1051,14 +1051,14 @@ void __init setup_arch(char **cmdline_p)
 	register_refined_jiffies(CLOCK_TICK_RATE);
 
 #ifdef CONFIG_EFI
-	/* Once setup is done above, disable efi_enabled on mismatched
-	 * firmware/kernel archtectures since there is no support for
-	 * runtime services.
+	/* Once setup is done above, unmap the EFI memory map on
+	 * mismatched firmware/kernel archtectures since there is no
+	 * support for runtime services.
 	 */
-	if (efi_enabled && IS_ENABLED(CONFIG_X86_64) != efi_64bit) {
+	if (efi_enabled(EFI_BOOT) &&
+	    IS_ENABLED(CONFIG_X86_64) != efi_enabled(EFI_64BIT)) {
 		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
 		efi_unmap_memmap();
-		efi_enabled = 0;
 	}
 #endif
 }
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ad44391..984ed2d 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -51,9 +51,6 @@
 
 #define EFI_DEBUG	1
 
-int efi_enabled;
-EXPORT_SYMBOL(efi_enabled);
-
 struct efi __read_mostly efi = {
 	.mps        = EFI_INVALID_TABLE_ADDR,
 	.acpi       = EFI_INVALID_TABLE_ADDR,
@@ -69,19 +66,27 @@ EXPORT_SYMBOL(efi);
 
 struct efi_memory_map memmap;
 
-bool efi_64bit;
-
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
 static inline bool efi_is_native(void)
 {
-	return IS_ENABLED(CONFIG_X86_64) == efi_64bit;
+	return IS_ENABLED(CONFIG_X86_64) == efi_enabled(EFI_64BIT);
+}
+
+unsigned long x86_efi_facility;
+
+/*
+ * Returns 1 if 'facility' is enabled, 0 otherwise.
+ */
+int efi_enabled(int facility)
+{
+	return test_bit(facility, &x86_efi_facility) != 0;
 }
 
 static int __init setup_noefi(char *arg)
 {
-	efi_enabled = 0;
+	clear_bit(EFI_BOOT, &x86_efi_facility);
 	return 0;
 }
 early_param("noefi", setup_noefi);
@@ -460,7 +465,7 @@ void __init efi_free_boot_services(void)
 
 static int __init efi_systab_init(void *phys)
 {
-	if (efi_64bit) {
+	if (efi_enabled(EFI_64BIT)) {
 		efi_system_table_64_t *systab64;
 		u64 tmp = 0;
 
@@ -552,7 +557,7 @@ static int __init efi_config_init(u64 tables, int nr_tables)
 	void *config_tables, *tablep;
 	int i, sz;
 
-	if (efi_64bit)
+	if (efi_enabled(EFI_64BIT))
 		sz = sizeof(efi_config_table_64_t);
 	else
 		sz = sizeof(efi_config_table_32_t);
@@ -572,7 +577,7 @@ static int __init efi_config_init(u64 tables, int nr_tables)
 		efi_guid_t guid;
 		unsigned long table;
 
-		if (efi_64bit) {
+		if (efi_enabled(EFI_64BIT)) {
 			u64 table64;
 			guid = ((efi_config_table_64_t *)tablep)->guid;
 			table64 = ((efi_config_table_64_t *)tablep)->table;
@@ -684,7 +689,6 @@ void __init efi_init(void)
 	if (boot_params.efi_info.efi_systab_hi ||
 	    boot_params.efi_info.efi_memmap_hi) {
 		pr_info("Table located above 4GB, disabling EFI.\n");
-		efi_enabled = 0;
 		return;
 	}
 	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
@@ -694,10 +698,10 @@ void __init efi_init(void)
 			  ((__u64)boot_params.efi_info.efi_systab_hi<<32));
 #endif
 
-	if (efi_systab_init(efi_phys.systab)) {
-		efi_enabled = 0;
+	if (efi_systab_init(efi_phys.systab))
 		return;
-	}
+
+	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
 
 	/*
 	 * Show what we know for posterity
@@ -715,10 +719,10 @@ void __init efi_init(void)
 		efi.systab->hdr.revision >> 16,
 		efi.systab->hdr.revision & 0xffff, vendor);
 
-	if (efi_config_init(efi.systab->tables, efi.systab->nr_tables)) {
-		efi_enabled = 0;
+	if (efi_config_init(efi.systab->tables, efi.systab->nr_tables))
 		return;
-	}
+
+	set_bit(EFI_CONFIG_TABLES, &x86_efi_facility);
 
 	/*
 	 * Note: We currently don't support runtime services on an EFI
@@ -727,15 +731,17 @@ void __init efi_init(void)
 
 	if (!efi_is_native())
 		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
-	else if (efi_runtime_init()) {
-		efi_enabled = 0;
-		return;
+	else {
+		if (efi_runtime_init())
+			return;
+		set_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
 	}
 
-	if (efi_memmap_init()) {
-		efi_enabled = 0;
+	if (efi_memmap_init())
 		return;
-	}
+
+	set_bit(EFI_MEMMAP, &x86_efi_facility);
+
 #ifdef CONFIG_X86_32
 	if (efi_is_native()) {
 		x86_platform.get_wallclock = efi_get_time;
@@ -969,6 +975,9 @@ u32 efi_mem_type(unsigned long phys_addr)
 	efi_memory_desc_t *md;
 	void *p;
 
+	if (!efi_enabled(EFI_MEMMAP))
+		return 0;
+
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 		if ((md->phys_addr <= phys_addr) &&
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 9eaf708..251435a 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -250,7 +250,7 @@ acpi_physical_address __init acpi_os_get_root_pointer(void)
 		return acpi_rsdp;
 #endif
 
-	if (efi_enabled) {
+	if (efi_enabled(EFI_CONFIG_TABLES)) {
 		if (efi.acpi20 != EFI_INVALID_TABLE_ADDR)
 			return efi.acpi20;
 		else if (efi.acpi != EFI_INVALID_TABLE_ADDR)
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index b298158..2d1539f 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -432,7 +432,7 @@ void __init dmi_scan_machine(void)
 	char __iomem *p, *q;
 	int rc;
 
-	if (efi_enabled) {
+	if (efi_enabled(EFI_CONFIG_TABLES)) {
 		if (efi.smbios == EFI_INVALID_TABLE_ADDR)
 			goto error;
 
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index d10c987..bfd8f43 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1224,7 +1224,7 @@ efivars_init(void)
 	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
 	       EFIVARS_DATE);
 
-	if (!efi_enabled)
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
 		return 0;
 
 	/* For now we'll register the efi directory at /sys/firmware/efi */
@@ -1262,7 +1262,7 @@ err_put:
 static void __exit
 efivars_exit(void)
 {
-	if (efi_enabled) {
+	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
 		unregister_efivars(&__efivars);
 		kobject_put(efi_kobj);
 	}
diff --git a/drivers/firmware/iscsi_ibft_find.c b/drivers/firmware/iscsi_ibft_find.c
index 4da4eb9..2224f1d 100644
--- a/drivers/firmware/iscsi_ibft_find.c
+++ b/drivers/firmware/iscsi_ibft_find.c
@@ -99,7 +99,7 @@ unsigned long __init find_ibft_region(unsigned long *sizep)
 	/* iBFT 1.03 section 1.4.3.1 mandates that UEFI machines will
 	 * only use ACPI for this */
 
-	if (!efi_enabled)
+	if (!efi_enabled(EFI_BOOT))
 		find_ibft_in_mem();
 
 	if (ibft_addr) {
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index e2f5f88..789074c 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -429,7 +429,8 @@ bool radeon_card_posted(struct radeon_device *rdev)
 {
 	uint32_t reg;
 
-	if (efi_enabled && rdev->pdev->subsystem_vendor == PCI_VENDOR_ID_APPLE)
+	if (efi_enabled(EFI_BOOT) &&
+	    rdev->pdev->subsystem_vendor == PCI_VENDOR_ID_APPLE)
 		return false;
 
 	/* first check CRTCs */
diff --git a/drivers/platform/x86/ibm_rtl.c b/drivers/platform/x86/ibm_rtl.c
index 7481146..97c2be1 100644
--- a/drivers/platform/x86/ibm_rtl.c
+++ b/drivers/platform/x86/ibm_rtl.c
@@ -244,7 +244,7 @@ static int __init ibm_rtl_init(void) {
 	if (force)
 		pr_warn("module loaded by force\n");
 	/* first ensure that we are running on IBM HW */
-	else if (efi_enabled || !dmi_check_system(ibm_rtl_dmi_table))
+	else if (efi_enabled(EFI_BOOT) || !dmi_check_system(ibm_rtl_dmi_table))
 		return -ENODEV;
 
 	/* Get the address for the Extended BIOS Data Area */
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index b74050b..9ac1e9d 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -633,7 +633,7 @@ static int __devinit isci_pci_probe(struct pci_dev *pdev, const struct pci_devic
 		return -ENOMEM;
 	pci_set_drvdata(pdev, pci_info);
 
-	if (efi_enabled)
+	if (efi_enabled(EFI_RUNTIME_SERVICES))
 		orom = isci_get_efi_var(pdev);
 
 	if (!orom)
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 8670eb1..9c77a8f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -542,18 +542,30 @@ extern int __init efi_setup_pcdp_console(char *);
 #endif
 
 /*
- * We play games with efi_enabled so that the compiler will, if possible, remove
- * EFI-related code altogether.
+ * We play games with efi_enabled so that the compiler will, if
+ * possible, remove EFI-related code altogether.
  */
+#define EFI_BOOT		0x00000001 /* Were we booted from EFI? */
+#define EFI_SYSTEM_TABLES	0x00000002 /* Can we use EFI system tables? */
+#define EFI_CONFIG_TABLES	0x00000004 /* Can we use EFI config tables? */
+#define EFI_RUNTIME_SERVICES	0x00000004 /* Can we use runtime services? */
+#define EFI_MEMMAP		0x00000008 /* Can we use EFI memory map? */
+#define EFI_64BIT		0x00000010 /* Is the firmware 64-bit? */
+
 #ifdef CONFIG_EFI
 # ifdef CONFIG_X86
-   extern int efi_enabled;
-   extern bool efi_64bit;
+extern int efi_enabled(int facility);
 # else
-#  define efi_enabled 1
+static inline int efi_enabled(int facility)
+{
+	return 1;
+}
 # endif
 #else
-# define efi_enabled 0
+static inline int efi_enabled(int facility)
+{
+	return 0;
+}
 #endif
 
 /*
diff --git a/init/main.c b/init/main.c
index e33e09d..e71d924 100644
--- a/init/main.c
+++ b/init/main.c
@@ -604,7 +604,7 @@ asmlinkage void __init start_kernel(void)
 	pidmap_init();
 	anon_vma_init();
 #ifdef CONFIG_X86
-	if (efi_enabled)
+	if (efi_enabled(EFI_RUNTIME_SERVICES))
 		efi_enter_virtual_mode();
 #endif
 	thread_info_cache_init();
@@ -632,7 +632,7 @@ asmlinkage void __init start_kernel(void)
 	acpi_early_init(); /* before LAPIC and SMP init */
 	sfi_init_late();
 
-	if (efi_enabled) {
+	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
 		efi_late_init();
 		efi_free_boot_services();
 	}
-- 
1.7.11.7

