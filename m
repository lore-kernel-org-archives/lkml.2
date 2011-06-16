Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1FPHBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:01:20 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57613 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755579Ab1FPHBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:14 -0400
X-Sasl-enc: y31nhhK0mrfV4pGHgyKrIN/wNGatr8LNqaA4Zu1oC/5l 1308207673
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:34 2011
Message-Id: <20110616000234.795921317@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Jim Bos <jim876@xs4all.nl>, Matthew Garrett <mjg@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Yinghai Lu <yinghai@kernel.org>
Subject: [59/89] Revert "x86, efi: Retain boot service code until after switching to virtual mode"
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

This reverts commit 0aed459e8487eb6ebdb4efe8cefe1eafbc704b30, which was
commit 916f676f8dc016103f983c7ec54c18ecdbb6e349 upstream.

It breaks some people's machines, so this will all get worked out in the
3.0 kernel release, it's not quite ready for 2.6.39 just yet.

Thanks to Maarten Lankhorst <m.b.lankhorst@gmail.com> for reporting the
issue.

Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Jim Bos <jim876@xs4all.nl>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/setup.c        |    7 ------
 arch/x86/platform/efi/efi.c    |   45 -----------------------------------------
 arch/x86/platform/efi/efi_64.c |    5 +---
 include/linux/efi.h            |    1 
 4 files changed, 3 insertions(+), 55 deletions(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -912,13 +912,6 @@ void __init setup_arch(char **cmdline_p)
 	memblock.current_limit = get_max_mapped();
 	memblock_x86_fill();
 
-	/*
-	 * The EFI specification says that boot service code won't be called
-	 * after ExitBootServices(). This is, in fact, a lie.
-	 */
-	if (efi_enabled)
-		efi_reserve_boot_services();
-
 	/* preallocate 4k for mptable mpc */
 	early_reserve_e820_mpc_new();
 
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -315,40 +315,6 @@ static void __init print_efi_memmap(void
 }
 #endif  /*  EFI_DEBUG  */
 
-void __init efi_reserve_boot_services(void)
-{
-	void *p;
-
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		efi_memory_desc_t *md = p;
-		unsigned long long start = md->phys_addr;
-		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
-
-		if (md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
-			continue;
-
-		memblock_x86_reserve_range(start, start + size, "EFI Boot");
-	}
-}
-
-static void __init efi_free_boot_services(void)
-{
-	void *p;
-
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		efi_memory_desc_t *md = p;
-		unsigned long long start = md->phys_addr;
-		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
-
-		if (md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
-			continue;
-
-		free_bootmem_late(start, size);
-	}
-}
-
 void __init efi_init(void)
 {
 	efi_config_table_t *config_tables;
@@ -541,9 +507,7 @@ void __init efi_enter_virtual_mode(void)
 	efi.systab = NULL;
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
-		    md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
+		if (!(md->attribute & EFI_MEMORY_RUNTIME))
 			continue;
 
 		size = md->num_pages << EFI_PAGE_SHIFT;
@@ -594,13 +558,6 @@ void __init efi_enter_virtual_mode(void)
 	}
 
 	/*
-	 * Thankfully, it does seem that no runtime services other than
-	 * SetVirtualAddressMap() will touch boot services code, so we can
-	 * get rid of it all at this point
-	 */
-	efi_free_boot_services();
-
-	/*
 	 * Now that EFI is in virtual mode, update the function
 	 * pointers in the runtime service table to the new virtual addresses.
 	 *
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -64,11 +64,10 @@ static void __init early_runtime_code_ma
 	if (!(__supported_pte_mask & _PAGE_NX))
 		return;
 
-	/* Make EFI service code area executable */
+	/* Make EFI runtime service code area executable */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
-		if (md->type == EFI_RUNTIME_SERVICES_CODE ||
-		    md->type == EFI_BOOT_SERVICES_CODE) {
+		if (md->type == EFI_RUNTIME_SERVICES_CODE) {
 			unsigned long end;
 			end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
 			early_mapping_set_exec(md->phys_addr, end, executable);
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -299,7 +299,6 @@ extern void efi_initialize_iomem_resourc
 		struct resource *data_resource, struct resource *bss_resource);
 extern unsigned long efi_get_time(void);
 extern int efi_set_rtc_mmss(unsigned long nowtime);
-extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
 
 /**


