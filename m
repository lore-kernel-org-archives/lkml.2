Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964770Ab2AEVCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:02:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34853 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914Ab2AEVCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:02:34 -0500
From: Olof Johansson <olof@lixom.net>
To: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH 4/5] x86: efi: add basic error handling
Date: Thu,  5 Jan 2012 13:02:10 -0800
Message-Id: <1325797331-14758-5-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.8.GIT
In-Reply-To: <1325797331-14758-1-git-send-email-olof@lixom.net>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
 <1325797331-14758-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not perfect, but way better than before. Mark efi_enabled as false in
case of error and at least stop dereferencing pointers that are known to
be invalid.

The only significant missing piece is the lack of undoing the
memblock_reserve of the memory that efi marks as in use. On the other
hand, it's not a large amount of memory, and leaving it unavailable for
system use should be the safer choice anyway.

Signed-off-by: Olof Johansson <olof@lixom.net>
Acked-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/platform/efi/efi.c |   85 +++++++++++++++++++++++++++++--------------
 1 files changed, 57 insertions(+), 28 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 03259d1..5a053e7 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -430,12 +430,14 @@ static void __init efi_free_boot_services(void)
 	}
 }
 
-static void __init efi_systab_init(void *phys)
+static int __init efi_systab_init(void *phys)
 {
 	efi.systab = early_ioremap((unsigned long)efi_phys.systab,
 				   sizeof(efi_system_table_t));
-	if (efi.systab == NULL)
+	if (efi.systab == NULL) {
 		pr_err("Couldn't map the system table!\n");
+		return -ENOMEM;
+	}
 	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
 	early_iounmap(efi.systab, sizeof(efi_system_table_t));
 	efi.systab = &efi_systab;
@@ -443,16 +445,20 @@ static void __init efi_systab_init(void *phys)
 	/*
 	 * Verify the EFI Table
 	 */
-	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
+	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE) {
 		pr_err("System table signature incorrect!\n");
+		return -EINVAL;
+	}
 	if ((efi.systab->hdr.revision >> 16) == 0)
 		pr_err("Warning: System table version "
 		       "%d.%02d, expected 1.00 or greater!\n",
 		       efi.systab->hdr.revision >> 16,
 		       efi.systab->hdr.revision & 0xffff);
+
+	return 0;
 }
 
-static void __init efi_config_init(u64 tables, int nr_tables)
+static int __init efi_config_init(u64 tables, int nr_tables)
 {
 	efi_config_table_t *config_tables;
 	int i, sz = sizeof(efi_config_table_t);
@@ -462,8 +468,10 @@ static void __init efi_config_init(u64 tables, int nr_tables)
 	 */
 	config_tables = early_ioremap(efi.systab->tables,
 				      efi.systab->nr_tables * sz);
-	if (config_tables == NULL)
+	if (config_tables == NULL) {
 		pr_err("Could not map Configuration table!\n");
+		return -ENOMEM;
+	}
 
 	pr_info("");
 	for (i = 0; i < efi.systab->nr_tables; i++) {
@@ -497,9 +505,11 @@ static void __init efi_config_init(u64 tables, int nr_tables)
 	}
 	pr_cont("\n");
 	early_iounmap(config_tables, efi.systab->nr_tables * sz);
+
+	return 0;
 }
 
-static void __init efi_runtime_init(void)
+static int __init efi_runtime_init(void)
 {
 	efi_runtime_services_t *runtime;
 
@@ -511,37 +521,44 @@ static void __init efi_runtime_init(void)
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
+	if (!runtime) {
 		pr_err("Could not map the runtime service table!\n");
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
+
+	return 0;
 }
 
-static void __init efi_memmap_init(void)
+static int __init efi_memmap_init(void)
 {
 	/* Map the EFI memory map */
 	memmap.map = early_ioremap((unsigned long)memmap.phys_map,
 				   memmap.nr_map * memmap.desc_size);
-	if (memmap.map == NULL)
+	if (memmap.map == NULL) {
 		pr_err("Could not map the memory map!\n");
+		return -ENOMEM;
+	}
 	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
 
 	if (add_efi_memmap)
 		do_add_efi_memmap();
+
+	return 0;
 }
 
 void __init efi_init(void)
@@ -559,7 +576,10 @@ void __init efi_init(void)
 		 ((__u64)boot_params.efi_info.efi_systab_hi<<32));
 #endif
 
-	efi_systab_init(efi_phys.systab);
+	if (efi_systab_init(efi_phys.systab)) {
+		efi_enabled = 0;
+		return;
+	}
 
 	/*
 	 * Show what we know for posterity
@@ -577,11 +597,20 @@ void __init efi_init(void)
 		efi.systab->hdr.revision >> 16,
 		efi.systab->hdr.revision & 0xffff, vendor);
 
-	efi_config_init(efi.systab->tables, efi.systab->nr_tables);
+	if (efi_config_init(efi.systab->tables, efi.systab->nr_tables)) {
+		efi_enabled = 0;
+		return;
+	}
 
-	efi_runtime_init();
+	if (efi_runtime_init()) {
+		efi_enabled = 0;
+		return;
+	}
 
-	efi_memmap_init();
+	if (efi_memmap_init()) {
+		efi_enabled = 0;
+		return;
+	}
 
 #ifdef CONFIG_X86_32
 	x86_platform.get_wallclock = efi_get_time;
-- 
1.7.8.GIT

