Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab2EYPUC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:20:02 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:47929 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2EYPT7 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 25 May 2012 11:19:59 -0400
Message-Id: <4FBFBF5F020000780008637F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 25 May 2012 16:20:31 +0100
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
however: While so far early get-time calls were done in physical mode,
this doesn't work properly for x86-64, as virtual addresses would still
need to be set up for all runtime regions (which wasn't the case on the
system I have access to), so instead the patch moves the call to
efi_enter_virtual_mode() ahead (which in turn allows to drop all code
related to calling efi-get-time in physical mode).

Additionally the earlier calling of efi_set_executable() requires the
CPA code to cope, i.e. during early boot it must be avoided to call
cpa_flush_array(), as the first thing this function does is a
BUG_ON(irqs_disabled()).

Also make the two EFI functions in question here static - they're not
being referenced elsewhere.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>

---
(Note that due to the lack of hardware I wasn't able to test this on
32-bit EFI - Matt offered to do so subsequently.)

---
 arch/x86/mm/pageattr.c      |   10 ++++++----
 arch/x86/platform/efi/efi.c |   30 ++++--------------------------
 include/linux/efi.h         |    2 --
 init/main.c                 |    8 ++++----
 4 files changed, 14 insertions(+), 36 deletions(-)

--- 3.4/arch/x86/mm/pageattr.c
+++ 3.4-x86_64-EFI-time/arch/x86/mm/pageattr.c
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
--- 3.4/arch/x86/platform/efi/efi.c
+++ 3.4-x86_64-EFI-time/arch/x86/platform/efi/efi.c
@@ -234,22 +234,7 @@ static efi_status_t __init phys_efi_set_
 	return status;
 }
 
-static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
-					     efi_time_cap_t *tc)
-{
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	efi_call_phys_prelog();
-	status = efi_call_phys2(efi_phys.get_time, virt_to_phys(tm),
-				virt_to_phys(tc));
-	efi_call_phys_epilog();
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
-}
-
-int efi_set_rtc_mmss(unsigned long nowtime)
+static int efi_set_rtc_mmss(unsigned long nowtime)
 {
 	int real_seconds, real_minutes;
 	efi_status_t 	status;
@@ -278,7 +263,7 @@ int efi_set_rtc_mmss(unsigned long nowti
 	return 0;
 }
 
-unsigned long efi_get_time(void)
+static unsigned long efi_get_time(void)
 {
 	efi_status_t status;
 	efi_time_t eft;
@@ -621,18 +606,13 @@ static int __init efi_runtime_init(void)
 	}
 	/*
 	 * We will only need *early* access to the following
-	 * two EFI runtime services before set_virtual_address_map
+	 * EFI runtime service before set_virtual_address_map
 	 * is invoked.
 	 */
-	efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
 	efi_phys.set_virtual_address_map =
 		(efi_set_virtual_address_map_t *)
 		runtime->set_virtual_address_map;
-	/*
-	 * Make efi_get_time can be called before entering
-	 * virtual mode.
-	 */
-	efi.get_time = phys_efi_get_time;
+
 	early_iounmap(runtime, sizeof(efi_runtime_services_t));
 
 	return 0;
@@ -720,12 +700,10 @@ void __init efi_init(void)
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
--- 3.4/include/linux/efi.h
+++ 3.4-x86_64-EFI-time/include/linux/efi.h
@@ -503,8 +503,6 @@ extern u64 efi_mem_attribute (unsigned l
 extern int __init efi_uart_console_only (void);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
-extern unsigned long efi_get_time(void);
-extern int efi_set_rtc_mmss(unsigned long nowtime);
 extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
 
--- 3.4/init/main.c
+++ 3.4-x86_64-EFI-time/init/main.c
@@ -460,6 +460,10 @@ static void __init mm_init(void)
 	percpu_init_late();
 	pgtable_cache_init();
 	vmalloc_init();
+#ifdef CONFIG_X86
+	if (efi_enabled)
+		efi_enter_virtual_mode();
+#endif
 }
 
 asmlinkage void __init start_kernel(void)
@@ -604,10 +608,6 @@ asmlinkage void __init start_kernel(void
 	calibrate_delay();
 	pidmap_init();
 	anon_vma_init();
-#ifdef CONFIG_X86
-	if (efi_enabled)
-		efi_enter_virtual_mode();
-#endif
 	thread_info_cache_init();
 	cred_init();
 	fork_init(totalram_pages);


