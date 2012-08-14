Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab2HNToP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 15:44:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46388 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2HNToN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 15:44:13 -0400
Date: Tue, 14 Aug 2012 12:43:46 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-f026cfa82f628db24b8cea41b9d6202af104cecb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, jbeulich@suse.com,
        matt.fleming@intel.com, akpm@linux-foundation.org, tglx@linutronix.de,
        cJ-ko@zougloub.eu
Reply-To: mingo@kernel.org, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, jbeulich@suse.com, matt.fleming@intel.com,
        akpm@linux-foundation.org, cJ-ko@zougloub.eu, tglx@linutronix.de
In-Reply-To: <20120805172903.5f8bb24c@zougloub.eu>
References: <20120805172903.5f8bb24c@zougloub.eu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] Revert "x86-64/efi:
  Use EFI to deal with platform wall clock"
Git-Commit-ID: f026cfa82f628db24b8cea41b9d6202af104cecb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 14 Aug 2012 12:43:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f026cfa82f628db24b8cea41b9d6202af104cecb
Gitweb:     http://git.kernel.org/tip/f026cfa82f628db24b8cea41b9d6202af104cecb
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 14 Aug 2012 09:53:38 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 14 Aug 2012 09:58:25 -0700

Revert "x86-64/efi: Use EFI to deal with platform wall clock"

This reverts commit bacef661acdb634170a8faddbc1cf28e8f8b9eee.

This commit has been found to cause serious regressions on a number of
ASUS machines at the least.  We probably need to provide a 1:1 map in
addition to the EFI virtual memory map in order for this to work.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Reported-and-bisected-by: Jérôme Carretero <cJ-ko@zougloub.eu>
Cc: Jan Beulich <jbeulich@suse.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120805172903.5f8bb24c@zougloub.eu
---
 arch/x86/mm/pageattr.c      |   10 ++++------
 arch/x86/platform/efi/efi.c |   30 ++++++++++++++++++++++++++----
 include/linux/efi.h         |    2 ++
 init/main.c                 |    8 ++++----
 4 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 931930a..a718e0d 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -919,13 +919,11 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 
 	/*
 	 * On success we use clflush, when the CPU supports it to
-	 * avoid the wbindv. If the CPU does not support it, in the
-	 * error case, and during early boot (for EFI) we fall back
-	 * to cpa_flush_all (which uses wbinvd):
+	 * avoid the wbindv. If the CPU does not support it and in the
+	 * error case we fall back to cpa_flush_all (which uses
+	 * wbindv):
 	 */
-	if (early_boot_irqs_disabled)
-		__cpa_flush_all((void *)(long)cache);
-	else if (!ret && cpu_has_clflush) {
+	if (!ret && cpu_has_clflush) {
 		if (cpa.flags & (CPA_PAGES_ARRAY | CPA_ARRAY)) {
 			cpa_flush_array(addr, numpages, cache,
 					cpa.flags, pages);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 2dc29f5..92660eda 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -234,7 +234,22 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 	return status;
 }
 
-static int efi_set_rtc_mmss(unsigned long nowtime)
+static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
+					     efi_time_cap_t *tc)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	efi_call_phys_prelog();
+	status = efi_call_phys2(efi_phys.get_time, virt_to_phys(tm),
+				virt_to_phys(tc));
+	efi_call_phys_epilog();
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
+}
+
+int efi_set_rtc_mmss(unsigned long nowtime)
 {
 	int real_seconds, real_minutes;
 	efi_status_t 	status;
@@ -263,7 +278,7 @@ static int efi_set_rtc_mmss(unsigned long nowtime)
 	return 0;
 }
 
-static unsigned long efi_get_time(void)
+unsigned long efi_get_time(void)
 {
 	efi_status_t status;
 	efi_time_t eft;
@@ -606,13 +621,18 @@ static int __init efi_runtime_init(void)
 	}
 	/*
 	 * We will only need *early* access to the following
-	 * EFI runtime service before set_virtual_address_map
+	 * two EFI runtime services before set_virtual_address_map
 	 * is invoked.
 	 */
+	efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
 	efi_phys.set_virtual_address_map =
 		(efi_set_virtual_address_map_t *)
 		runtime->set_virtual_address_map;
-
+	/*
+	 * Make efi_get_time can be called before entering
+	 * virtual mode.
+	 */
+	efi.get_time = phys_efi_get_time;
 	early_iounmap(runtime, sizeof(efi_runtime_services_t));
 
 	return 0;
@@ -700,10 +720,12 @@ void __init efi_init(void)
 		efi_enabled = 0;
 		return;
 	}
+#ifdef CONFIG_X86_32
 	if (efi_native) {
 		x86_platform.get_wallclock = efi_get_time;
 		x86_platform.set_wallclock = efi_set_rtc_mmss;
 	}
+#endif
 
 #if EFI_DEBUG
 	print_efi_memmap();
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 103adc6..ec45ccd 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -503,6 +503,8 @@ extern u64 efi_mem_attribute (unsigned long phys_addr, unsigned long size);
 extern int __init efi_uart_console_only (void);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
+extern unsigned long efi_get_time(void);
+extern int efi_set_rtc_mmss(unsigned long nowtime);
 extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
 
diff --git a/init/main.c b/init/main.c
index e60679d..b286730 100644
--- a/init/main.c
+++ b/init/main.c
@@ -461,10 +461,6 @@ static void __init mm_init(void)
 	percpu_init_late();
 	pgtable_cache_init();
 	vmalloc_init();
-#ifdef CONFIG_X86
-	if (efi_enabled)
-		efi_enter_virtual_mode();
-#endif
 }
 
 asmlinkage void __init start_kernel(void)
@@ -606,6 +602,10 @@ asmlinkage void __init start_kernel(void)
 	calibrate_delay();
 	pidmap_init();
 	anon_vma_init();
+#ifdef CONFIG_X86
+	if (efi_enabled)
+		efi_enter_virtual_mode();
+#endif
 	thread_info_cache_init();
 	cred_init();
 	fork_init(totalram_pages);
