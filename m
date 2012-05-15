Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab2EOMRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:17:53 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:44940 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428Ab2EOMRw convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 15 May 2012 08:17:52 -0400
Message-Id: <4FB265AB0200007800083CC5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 15 May 2012 13:18:19 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <matt.fleming@linux.intel.com>, <mjg@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: use EFI to deal with platform wall clock
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other than ix86, x86-64 on EFI so far didn't set the {g,s}et_wallclock
accessors to the EFI routines, thus incorrectly using raw RTC accesses
instead.

Simply removing the #ifdef around the respective code isn't enough,
however: The runtime code must not only be forced to be executable, it
also must have a proper virtual address set (which on at least the
system I'm testing on isn't the case for all necessary regions, or at
least not as early as they're now being required).

The earlier calling of efi_set_executable() in turn require the CPA
code to cope, i.e. during early boot it must be avoided to call
cpa_flush_array(), as the first thing this function does is a
BUG_ON(irqs_disabled()).

Also make the two EFI functions in question here static - they're not
being referenced elsewhere.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>

---
 arch/x86/mm/pageattr.c         |   10 ++++++----
 arch/x86/platform/efi/efi.c    |    6 ++----
 arch/x86/platform/efi/efi_64.c |   10 +++++++++-
 include/linux/efi.h            |    2 --
 4 files changed, 17 insertions(+), 11 deletions(-)

--- 3.4-rc7/arch/x86/mm/pageattr.c
+++ 3.4-rc7-x86_64-EFI-time/arch/x86/mm/pageattr.c
@@ -919,11 +919,13 @@ static int change_page_attr_set_clr(unsi
 
 	/*
 	 * On success we use clflush, when the CPU supports it to
-	 * avoid the wbindv. If the CPU does not support it and in the
-	 * error case we fall back to cpa_flush_all (which uses
-	 * wbindv):
+	 * avoid the wbindv. If the CPU does not support it, in the
+	 * error case, and during early boot (for EFI) we fall back
+	 * to cpa_flush_all (which uses wbinvd):
 	 */
-	if (!ret && cpu_has_clflush) {
+	if (early_boot_irqs_disabled)
+		__cpa_flush_all((void *)(long)cache);
+	else if (!ret && cpu_has_clflush) {
 		if (cpa.flags & (CPA_PAGES_ARRAY | CPA_ARRAY)) {
 			cpa_flush_array(addr, numpages, cache,
 					cpa.flags, pages);
--- 3.4-rc7/arch/x86/platform/efi/efi.c
+++ 3.4-rc7-x86_64-EFI-time/arch/x86/platform/efi/efi.c
@@ -249,7 +249,7 @@ static efi_status_t __init phys_efi_get_
 	return status;
 }
 
-int efi_set_rtc_mmss(unsigned long nowtime)
+static int efi_set_rtc_mmss(unsigned long nowtime)
 {
 	int real_seconds, real_minutes;
 	efi_status_t 	status;
@@ -278,7 +278,7 @@ int efi_set_rtc_mmss(unsigned long nowti
 	return 0;
 }
 
-unsigned long efi_get_time(void)
+static unsigned long efi_get_time(void)
 {
 	efi_status_t status;
 	efi_time_t eft;
@@ -720,12 +720,10 @@ void __init efi_init(void)
 		efi_enabled = 0;
 		return;
 	}
-#ifdef CONFIG_X86_32
 	if (efi_native) {
 		x86_platform.get_wallclock = efi_get_time;
 		x86_platform.set_wallclock = efi_set_rtc_mmss;
 	}
-#endif
 
 #if EFI_DEBUG
 	print_efi_memmap();
--- 3.4-rc7/arch/x86/platform/efi/efi_64.c
+++ 3.4-rc7-x86_64-EFI-time/arch/x86/platform/efi/efi_64.c
@@ -53,8 +53,16 @@ static void __init early_code_mapping_se
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 		if (md->type == EFI_RUNTIME_SERVICES_CODE ||
-		    md->type == EFI_BOOT_SERVICES_CODE)
+		    md->type == EFI_BOOT_SERVICES_CODE) {
+			if (!md->virt_addr) {
+				/*
+				 * We have to hope that the mappings set up so
+				 * far cover all that's needed for the call.
+				 */
+				md->virt_addr = (u64)__va(md->phys_addr);
+			}
 			efi_set_executable(md, executable);
+		}
 	}
 }
 
--- 3.4-rc7/include/linux/efi.h
+++ 3.4-rc7-x86_64-EFI-time/include/linux/efi.h
@@ -503,8 +503,6 @@ extern u64 efi_mem_attribute (unsigned l
 extern int __init efi_uart_console_only (void);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
-extern unsigned long efi_get_time(void);
-extern int efi_set_rtc_mmss(unsigned long nowtime);
 extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
 



