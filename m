Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab2BLVZB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 16:25:01 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61812 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab2BLVY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 16:24:58 -0500
MIME-Version: 1.0
From: Olof Johansson <olof@lixom.net>
To: x86@kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, matt.fleming@intel.com, mjg@redhat.com,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH v5 1/5] x86: efi: refactor efi_init() a bit
Date: Sun, 12 Feb 2012 13:24:25 -0800
Message-Id: <1329081869-20779-2-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.9.209.gb6b3b
In-Reply-To: <1329081869-20779-1-git-send-email-olof@lixom.net>
References: <1329081869-20779-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Break out some of the init steps into helper functions.

Only change to execution flow is the removal of the warning when the
kernel memdesc structure differ in size from what firmware specifies
since it's a bogus warning (it's a valid difference per spec).

v4:
* Removed memdesc warning as per above

Signed-off-by: Olof Johansson <olof@lixom.net>
Acked-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/platform/efi/efi.c |   89 ++++++++++++++++++++++++++-----------------
 1 files changed, 54 insertions(+), 35 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 264cc6e..fec2b2e 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -436,23 +436,8 @@ static void __init efi_free_boot_services(void)
 	}
 }
 
-void __init efi_init(void)
+static void __init efi_systab_init(void *phys)
 {
-	efi_config_table_t *config_tables;
-	efi_runtime_services_t *runtime;
-	efi_char16_t *c16;
-	char vendor[100] = "unknown";
-	int i = 0;
-	void *tmp;
-
-#ifdef CONFIG_X86_32
-	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
-#else
-	efi_phys.systab = (efi_system_table_t *)
-		(boot_params.efi_info.efi_systab |
-		 ((__u64)boot_params.efi_info.efi_systab_hi<<32));
-#endif
-
 	efi.systab = early_ioremap((unsigned long)efi_phys.systab,
 				   sizeof(efi_system_table_t));
 	if (efi.systab == NULL)
@@ -471,22 +456,12 @@ void __init efi_init(void)
 		       "%d.%02d, expected 1.00 or greater!\n",
 		       efi.systab->hdr.revision >> 16,
 		       efi.systab->hdr.revision & 0xffff);
+}
 
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
-
-	printk(KERN_INFO "EFI v%u.%.02u by %s\n",
-	       efi.systab->hdr.revision >> 16,
-	       efi.systab->hdr.revision & 0xffff, vendor);
+static void __init efi_config_init(u64 tables, int nr_tables)
+{
+	efi_config_table_t *config_tables;
+	int i;
 
 	/*
 	 * Let's see what config tables the firmware passed to us.
@@ -533,6 +508,11 @@ void __init efi_init(void)
 	printk("\n");
 	early_iounmap(config_tables,
 			  efi.systab->nr_tables * sizeof(efi_config_table_t));
+}
+
+static void __init efi_runtime_init(void)
+{
+	efi_runtime_services_t *runtime;
 
 	/*
 	 * Check out the runtime services table. We need to map
@@ -561,7 +541,10 @@ void __init efi_init(void)
 		printk(KERN_ERR "Could not map the EFI runtime service "
 		       "table!\n");
 	early_iounmap(runtime, sizeof(efi_runtime_services_t));
+}
 
+static void __init efi_memmap_init(void)
+{
 	/* Map the EFI memory map */
 	memmap.map = early_ioremap((unsigned long)memmap.phys_map,
 				   memmap.nr_map * memmap.desc_size);
@@ -569,12 +552,48 @@ void __init efi_init(void)
 		printk(KERN_ERR "Could not map the EFI memory map!\n");
 	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
 
-	if (memmap.desc_size != sizeof(efi_memory_desc_t))
-		printk(KERN_WARNING
-		  "Kernel-defined memdesc doesn't match the one from EFI!\n");
-
 	if (add_efi_memmap)
 		do_add_efi_memmap();
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
+	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
+#else
+	efi_phys.systab = (efi_system_table_t *)
+		(boot_params.efi_info.efi_systab |
+		 ((__u64)boot_params.efi_info.efi_systab_hi<<32));
+#endif
+
+	efi_systab_init(efi_phys.systab);
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
+		printk(KERN_ERR PFX "Could not map the firmware vendor!\n");
+	early_iounmap(tmp, 2);
+
+	printk(KERN_INFO "EFI v%u.%.02u by %s\n",
+	       efi.systab->hdr.revision >> 16,
+	       efi.systab->hdr.revision & 0xffff, vendor);
+
+	efi_config_init(efi.systab->tables, efi.systab->nr_tables);
+
+	efi_runtime_init();
+
+	efi_memmap_init();
 
 #ifdef CONFIG_X86_32
 	x86_platform.get_wallclock = efi_get_time;
-- 
1.7.9.209.gb6b3b

