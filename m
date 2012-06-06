Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab2FFPQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:16:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39875 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab2FFPQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:16:40 -0400
Date: Wed, 6 Jun 2012 08:16:10 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-bacef661acdb634170a8faddbc1cf28e8f8b9eee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, jbeulich@suse.com,
        matt.fleming@intel.com, akpm@linux-foundation.org, JBeulich@suse.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, jbeulich@suse.com, matt.fleming@intel.com,
        akpm@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de
In-Reply-To: <4FBFBF5F020000780008637F@nat28.tlf.novell.com>
References: <4FBFBF5F020000780008637F@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86-64/efi: Use EFI to deal with platform wall clock
Git-Commit-ID: bacef661acdb634170a8faddbc1cf28e8f8b9eee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:16:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bacef661acdb634170a8faddbc1cf28e8f8b9eee
Gitweb:     http://git.kernel.org/tip/bacef661acdb634170a8faddbc1cf28e8f8b9eee
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 25 May 2012 16:20:31 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 11:48:05 +0200

x86-64/efi: Use EFI to deal with platform wall clock

Other than ix86, x86-64 on EFI so far didn't set the
{g,s}et_wallclock accessors to the EFI routines, thus
incorrectly using raw RTC accesses instead.

Simply removing the #ifdef around the respective code isn't
enough, however: While so far early get-time calls were done in
physical mode, this doesn't work properly for x86-64, as virtual
addresses would still need to be set up for all runtime regions
(which wasn't the case on the system I have access to), so
instead the patch moves the call to efi_enter_virtual_mode()
ahead (which in turn allows to drop all code related to calling
efi-get-time in physical mode).

Additionally the earlier calling of efi_set_executable()
requires the CPA code to cope, i.e. during early boot it must be
avoided to call cpa_flush_array(), as the first thing this
function does is a BUG_ON(irqs_disabled()).

Also make the two EFI functions in question here static -
they're not being referenced elsewhere.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Tested-by: Matt Fleming <matt.fleming@intel.com>
Acked-by: Matthew Garrett <mjg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4FBFBF5F020000780008637F@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/pageattr.c      |   10 ++++++----
 arch/x86/platform/efi/efi.c |   30 ++++--------------------------
 include/linux/efi.h         |    2 --
 init/main.c                 |    8 ++++----
 4 files changed, 14 insertions(+), 36 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index e1ebde3..ee09aca 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -919,11 +919,13 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 
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
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 92660eda..2dc29f5 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -234,22 +234,7 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
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
@@ -278,7 +263,7 @@ int efi_set_rtc_mmss(unsigned long nowtime)
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
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ec45ccd..103adc6 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -503,8 +503,6 @@ extern u64 efi_mem_attribute (unsigned long phys_addr, unsigned long size);
 extern int __init efi_uart_console_only (void);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
-extern unsigned long efi_get_time(void);
-extern int efi_set_rtc_mmss(unsigned long nowtime);
 extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
 
diff --git a/init/main.c b/init/main.c
index 1ca6b32..eef3012 100644
--- a/init/main.c
+++ b/init/main.c
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
@@ -601,10 +605,6 @@ asmlinkage void __init start_kernel(void)
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
