Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030236Ab2JKUuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:50:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:3452 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030222Ab2JKUtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:49:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,573,1344236400"; 
   d="scan'208";a="204515438"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v2 4/8] x86: Use __pa_symbol instead of __pa on C visible
	symbols
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Alexander Duyck <alexander.h.duyck@intel.com>
Date: Thu, 11 Oct 2012 13:50:13 -0700
Message-ID: <20121011205013.12787.70437.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121011204324.12787.30514.stgit@gitlad.jf.intel.com>
References: <20121011204324.12787.30514.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I made an attempt at separating __pa_symbol and __pa I found that there
were a number of cases where __pa was used on an obvious symbol.

I also caught one non-obvious case as _brk_start and _brk_end are based on the
address of __brk_base which is a C visible symbol.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---

 arch/x86/kernel/cpu/intel.c |    2 +-
 arch/x86/kernel/setup.c     |   16 ++++++++--------
 arch/x86/mm/pageattr.c      |    8 ++++----
 arch/x86/platform/efi/efi.c |    4 ++--
 arch/x86/realmode/init.c    |    8 ++++----
 5 files changed, 19 insertions(+), 19 deletions(-)

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
index d609be0..391f5f4 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -299,8 +299,8 @@ static void __init cleanup_highmap(void)
 static void __init reserve_brk(void)
 {
 	if (_brk_end > _brk_start)
-		memblock_reserve(__pa(_brk_start),
-				 __pa(_brk_end) - __pa(_brk_start));
+		memblock_reserve(__pa_symbol(_brk_start),
+				 _brk_end - _brk_start);
 
 	/* Mark brk area as locked down and no longer taking any
 	   new allocations */
@@ -760,12 +760,12 @@ void __init setup_arch(char **cmdline_p)
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
index aded2a9..e8d0320 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -406,8 +406,8 @@ void __init efi_reserve_boot_services(void)
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
 

