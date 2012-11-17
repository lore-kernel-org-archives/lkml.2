Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab2KQA1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:27:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37688 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2KQA1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:27:37 -0500
Date: Fri, 16 Nov 2012 16:26:54 -0800
From: tip-bot for Alexander Duyck <alexander.h.duyck@intel.com>
Message-ID: <tip-132bc57b030fcdc0968e7cd217e3063f64ec5dce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        alexander.h.duyck@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        alexander.h.duyck@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20121116215640.8521.80483.stgit@ahduyck-cp1.jf.intel.com>
References: <20121116215640.8521.80483.stgit@ahduyck-cp1.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86:
  Use __pa_symbol instead of __pa on C visible symbols
Git-Commit-ID: 132bc57b030fcdc0968e7cd217e3063f64ec5dce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 16 Nov 2012 16:27:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  132bc57b030fcdc0968e7cd217e3063f64ec5dce
Gitweb:     http://git.kernel.org/tip/132bc57b030fcdc0968e7cd217e3063f64ec5dce
Author:     Alexander Duyck <alexander.h.duyck@intel.com>
AuthorDate: Fri, 16 Nov 2012 13:57:13 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 16 Nov 2012 15:20:42 -0800

x86: Use __pa_symbol instead of __pa on C visible symbols

When I made an attempt at separating __pa_symbol and __pa I found that there
were a number of cases where __pa was used on an obvious symbol.

I also caught one non-obvious case as _brk_start and _brk_end are based on the
address of __brk_base which is a C visible symbol.

In mark_rodata_ro I was able to reduce the overhead of kernel symbol to
virtual memory translation by using a combination of __va(__pa_symbol())
instead of page_address(virt_to_page()).

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Link: http://lkml.kernel.org/r/20121116215640.8521.80483.stgit@ahduyck-cp1.jf.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/intel.c |  2 +-
 arch/x86/kernel/setup.c     | 16 ++++++++--------
 arch/x86/mm/init_64.c       | 18 ++++++++----------
 arch/x86/mm/pageattr.c      |  8 ++++----
 arch/x86/platform/efi/efi.c |  4 ++--
 arch/x86/realmode/init.c    |  8 ++++----
 6 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 198e019..2249e7e 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -168,7 +168,7 @@ int __cpuinit ppro_with_ram_bug(void)
 #ifdef CONFIG_X86_F00F_BUG
 static void __cpuinit trap_init_f00f_bug(void)
 {
-	__set_fixmap(FIX_F00F_IDT, __pa(&idt_table), PAGE_KERNEL_RO);
+	__set_fixmap(FIX_F00F_IDT, __pa_symbol(idt_table), PAGE_KERNEL_RO);
 
 	/*
 	 * Update the IDT descriptor and reload the IDT so that
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ca45696..2702c5d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -300,8 +300,8 @@ static void __init cleanup_highmap(void)
 static void __init reserve_brk(void)
 {
 	if (_brk_end > _brk_start)
-		memblock_reserve(__pa(_brk_start),
-				 __pa(_brk_end) - __pa(_brk_start));
+		memblock_reserve(__pa_symbol(_brk_start),
+				 _brk_end - _brk_start);
 
 	/* Mark brk area as locked down and no longer taking any
 	   new allocations */
@@ -761,12 +761,12 @@ void __init setup_arch(char **cmdline_p)
 	init_mm.end_data = (unsigned long) _edata;
 	init_mm.brk = _brk_end;
 
-	code_resource.start = virt_to_phys(_text);
-	code_resource.end = virt_to_phys(_etext)-1;
-	data_resource.start = virt_to_phys(_etext);
-	data_resource.end = virt_to_phys(_edata)-1;
-	bss_resource.start = virt_to_phys(&__bss_start);
-	bss_resource.end = virt_to_phys(&__bss_stop)-1;
+	code_resource.start = __pa_symbol(_text);
+	code_resource.end = __pa_symbol(_etext)-1;
+	data_resource.start = __pa_symbol(_etext);
+	data_resource.end = __pa_symbol(_edata)-1;
+	bss_resource.start = __pa_symbol(__bss_start);
+	bss_resource.end = __pa_symbol(__bss_stop)-1;
 
 #ifdef CONFIG_CMDLINE_BOOL
 #ifdef CONFIG_CMDLINE_OVERRIDE
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 3baff25..0374a10 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -770,12 +770,10 @@ void set_kernel_text_ro(void)
 void mark_rodata_ro(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
-	unsigned long rodata_start =
-		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
+	unsigned long rodata_start = PFN_ALIGN(__start_rodata);
 	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
-	unsigned long text_end = PAGE_ALIGN((unsigned long) &__stop___ex_table);
-	unsigned long rodata_end = PAGE_ALIGN((unsigned long) &__end_rodata);
-	unsigned long data_start = (unsigned long) &_sdata;
+	unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
+	unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -800,12 +798,12 @@ void mark_rodata_ro(void)
 #endif
 
 	free_init_pages("unused kernel memory",
-			(unsigned long) page_address(virt_to_page(text_end)),
-			(unsigned long)
-				 page_address(virt_to_page(rodata_start)));
+			(unsigned long) __va(__pa_symbol(text_end)),
+			(unsigned long) __va(__pa_symbol(rodata_start)));
+
 	free_init_pages("unused kernel memory",
-			(unsigned long) page_address(virt_to_page(rodata_end)),
-			(unsigned long) page_address(virt_to_page(data_start)));
+			(unsigned long) __va(__pa_symbol(rodata_end)),
+			(unsigned long) __va(__pa_symbol(_sdata)));
 }
 
 #endif
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index a718e0d..40f92f3 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -94,12 +94,12 @@ static inline void split_page_count(int level) { }
 
 static inline unsigned long highmap_start_pfn(void)
 {
-	return __pa(_text) >> PAGE_SHIFT;
+	return __pa_symbol(_text) >> PAGE_SHIFT;
 }
 
 static inline unsigned long highmap_end_pfn(void)
 {
-	return __pa(roundup(_brk_end, PMD_SIZE)) >> PAGE_SHIFT;
+	return __pa_symbol(roundup(_brk_end, PMD_SIZE)) >> PAGE_SHIFT;
 }
 
 #endif
@@ -276,8 +276,8 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	 * The .rodata section needs to be read-only. Using the pfn
 	 * catches all aliases.
 	 */
-	if (within(pfn, __pa((unsigned long)__start_rodata) >> PAGE_SHIFT,
-		   __pa((unsigned long)__end_rodata) >> PAGE_SHIFT))
+	if (within(pfn, __pa_symbol(__start_rodata) >> PAGE_SHIFT,
+		   __pa_symbol(__end_rodata) >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_RW;
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ad44391..1b60026 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -410,8 +410,8 @@ void __init efi_reserve_boot_services(void)
 		 * - Not within any part of the kernel
 		 * - Not the bios reserved area
 		*/
-		if ((start+size >= virt_to_phys(_text)
-				&& start <= virt_to_phys(_end)) ||
+		if ((start+size >= __pa_symbol(_text)
+				&& start <= __pa_symbol(_end)) ||
 			!e820_all_mapped(start, start+size, E820_RAM) ||
 			memblock_is_region_reserved(start, size)) {
 			/* Could not reserve, skip it */
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index cbca565..8045026 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -62,9 +62,9 @@ void __init setup_real_mode(void)
 		__va(real_mode_header->trampoline_header);
 
 #ifdef CONFIG_X86_32
-	trampoline_header->start = __pa(startup_32_smp);
+	trampoline_header->start = __pa_symbol(startup_32_smp);
 	trampoline_header->gdt_limit = __BOOT_DS + 7;
-	trampoline_header->gdt_base = __pa(boot_gdt);
+	trampoline_header->gdt_base = __pa_symbol(boot_gdt);
 #else
 	/*
 	 * Some AMD processors will #GP(0) if EFER.LMA is set in WRMSR
@@ -78,8 +78,8 @@ void __init setup_real_mode(void)
 	*trampoline_cr4_features = read_cr4();
 
 	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
-	trampoline_pgd[0] = __pa(level3_ident_pgt) + _KERNPG_TABLE;
-	trampoline_pgd[511] = __pa(level3_kernel_pgt) + _KERNPG_TABLE;
+	trampoline_pgd[0] = __pa_symbol(level3_ident_pgt) + _KERNPG_TABLE;
+	trampoline_pgd[511] = __pa_symbol(level3_kernel_pgt) + _KERNPG_TABLE;
 #endif
 }
 
