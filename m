Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0JTV2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 17:28:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:53518 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab0JTV2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 17:28:39 -0400
Date: Wed, 20 Oct 2010 21:28:14 GMT
From: tip-bot for Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, bp@alien8.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de, hpa@linux.intel.com
In-Reply-To: <20101020070526.GA9588@liondog.tnic>
References: <20101020070526.GA9588@liondog.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86-32, mm: Add an initial page table for core bootstrapping
Message-ID: <tip-b40827fa7268fda8a62490728a61c2856f33830b@git.kernel.org>
Git-Commit-ID: b40827fa7268fda8a62490728a61c2856f33830b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Oct 2010 21:28:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b40827fa7268fda8a62490728a61c2856f33830b
Gitweb:     http://git.kernel.org/tip/b40827fa7268fda8a62490728a61c2856f33830b
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Sat, 28 Aug 2010 15:58:33 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 20 Oct 2010 14:23:55 -0700

x86-32, mm: Add an initial page table for core bootstrapping

This patch adds an initial page table with low mappings used exclusively
for booting APs/resuming after ACPI suspend/machine restart. After this,
there's no need to add low mappings to swapper_pg_dir and zap them later
or create own swsusp PGD page solely for ACPI sleep needs - we have
initial_page_table for that.

Signed-off-by: Borislav Petkov <bp@alien8.de>
LKML-Reference: <20101020070526.GA9588@liondog.tnic>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/pgtable_32.h |    2 +-
 arch/x86/include/asm/tlbflush.h   |    2 -
 arch/x86/include/asm/trampoline.h |    3 --
 arch/x86/kernel/acpi/sleep.c      |    7 ++++-
 arch/x86/kernel/head32.c          |    1 +
 arch/x86/kernel/head_32.S         |   55 +++++++++++++++++--------------------
 arch/x86/kernel/reboot.c          |   10 +-----
 arch/x86/kernel/setup.c           |   18 +++++++++++-
 arch/x86/kernel/smpboot.c         |   16 +++--------
 arch/x86/kernel/trampoline.c      |   16 -----------
 arch/x86/mm/init_32.c             |   45 ------------------------------
 11 files changed, 56 insertions(+), 119 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
index f686f49..8abde9e 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -26,7 +26,7 @@ struct mm_struct;
 struct vm_area_struct;
 
 extern pgd_t swapper_pg_dir[1024];
-extern pgd_t trampoline_pg_dir[1024];
+extern pgd_t initial_page_table[1024];
 
 static inline void pgtable_cache_init(void) { }
 static inline void check_pgt_cache(void) { }
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 7f3eba0..169be89 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -172,6 +172,4 @@ static inline void flush_tlb_kernel_range(unsigned long start,
 	flush_tlb_all();
 }
 
-extern void zap_low_mappings(bool early);
-
 #endif /* _ASM_X86_TLBFLUSH_H */
diff --git a/arch/x86/include/asm/trampoline.h b/arch/x86/include/asm/trampoline.h
index 4dde797..f4500fb 100644
--- a/arch/x86/include/asm/trampoline.h
+++ b/arch/x86/include/asm/trampoline.h
@@ -13,16 +13,13 @@ extern unsigned char *trampoline_base;
 
 extern unsigned long init_rsp;
 extern unsigned long initial_code;
-extern unsigned long initial_page_table;
 extern unsigned long initial_gs;
 
 #define TRAMPOLINE_SIZE roundup(trampoline_end - trampoline_data, PAGE_SIZE)
 
 extern unsigned long setup_trampoline(void);
-extern void __init setup_trampoline_page_table(void);
 extern void __init reserve_trampoline_memory(void);
 #else
-static inline void setup_trampoline_page_table(void) {}
 static inline void reserve_trampoline_memory(void) {}
 #endif /* CONFIG_X86_TRAMPOLINE */
 
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 33cec15..b35e1ab 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -12,6 +12,11 @@
 #include <asm/segment.h>
 #include <asm/desc.h>
 
+#ifdef CONFIG_X86_32
+#include <asm/pgtable.h>
+#include <asm/pgtable_32.h>
+#endif
+
 #include "realmode/wakeup.h"
 #include "sleep.h"
 
@@ -90,7 +95,7 @@ int acpi_save_state_mem(void)
 
 #ifndef CONFIG_64BIT
 	header->pmode_entry = (u32)&wakeup_pmode_return;
-	header->pmode_cr3 = (u32)(swsusp_pg_dir - __PAGE_OFFSET);
+	header->pmode_cr3 = (u32)__pa(&initial_page_table);
 	saved_magic = 0x12345678;
 #else /* CONFIG_64BIT */
 	header->trampoline_segment = setup_trampoline() >> 4;
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 784360c..8b9c201 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -17,6 +17,7 @@
 #include <asm/apic.h>
 #include <asm/io_apic.h>
 #include <asm/bios_ebda.h>
+#include <asm/tlbflush.h>
 
 static void __init i386_default_early_setup(void)
 {
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index fa8c1b8..bcece91 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -183,13 +183,12 @@ default_entry:
 #ifdef CONFIG_X86_PAE
 
 	/*
-	 * In PAE mode swapper_pg_dir is statically defined to contain enough
-	 * entries to cover the VMSPLIT option (that is the top 1, 2 or 3
-	 * entries). The identity mapping is handled by pointing two PGD
-	 * entries to the first kernel PMD.
+	 * In PAE mode initial_page_table is statically defined to contain
+	 * enough entries to cover the VMSPLIT option (that is the top 1, 2 or 3
+	 * entries). The identity mapping is handled by pointing two PGD entries
+	 * to the first kernel PMD.
 	 *
-	 * Note the upper half of each PMD or PTE are always zero at
-	 * this stage.
+	 * Note the upper half of each PMD or PTE are always zero at this stage.
 	 */
 
 #define KPMDS (((-__PAGE_OFFSET) >> 30) & 3) /* Number of kernel PMDs */
@@ -197,7 +196,7 @@ default_entry:
 	xorl %ebx,%ebx				/* %ebx is kept at zero */
 
 	movl $pa(__brk_base), %edi
-	movl $pa(swapper_pg_pmd), %edx
+	movl $pa(initial_pg_pmd), %edx
 	movl $PTE_IDENT_ATTR, %eax
 10:
 	leal PDE_IDENT_ATTR(%edi),%ecx		/* Create PMD entry */
@@ -226,14 +225,14 @@ default_entry:
 	movl %eax, pa(max_pfn_mapped)
 
 	/* Do early initialization of the fixmap area */
-	movl $pa(swapper_pg_fixmap)+PDE_IDENT_ATTR,%eax
-	movl %eax,pa(swapper_pg_pmd+0x1000*KPMDS-8)
+	movl $pa(initial_pg_fixmap)+PDE_IDENT_ATTR,%eax
+	movl %eax,pa(initial_pg_pmd+0x1000*KPMDS-8)
 #else	/* Not PAE */
 
 page_pde_offset = (__PAGE_OFFSET >> 20);
 
 	movl $pa(__brk_base), %edi
-	movl $pa(swapper_pg_dir), %edx
+	movl $pa(initial_page_table), %edx
 	movl $PTE_IDENT_ATTR, %eax
 10:
 	leal PDE_IDENT_ATTR(%edi),%ecx		/* Create PDE entry */
@@ -257,8 +256,8 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	movl %eax, pa(max_pfn_mapped)
 
 	/* Do early initialization of the fixmap area */
-	movl $pa(swapper_pg_fixmap)+PDE_IDENT_ATTR,%eax
-	movl %eax,pa(swapper_pg_dir+0xffc)
+	movl $pa(initial_pg_fixmap)+PDE_IDENT_ATTR,%eax
+	movl %eax,pa(initial_page_table+0xffc)
 #endif
 	jmp 3f
 /*
@@ -334,7 +333,7 @@ ENTRY(startup_32_smp)
 /*
  * Enable paging
  */
-	movl pa(initial_page_table), %eax
+	movl $pa(initial_page_table), %eax
 	movl %eax,%cr3		/* set the page table pointer.. */
 	movl %cr0,%eax
 	orl  $X86_CR0_PG,%eax
@@ -614,8 +613,6 @@ ignore_int:
 .align 4
 ENTRY(initial_code)
 	.long i386_start_kernel
-ENTRY(initial_page_table)
-	.long pa(swapper_pg_dir)
 
 /*
  * BSS section
@@ -623,20 +620,18 @@ ENTRY(initial_page_table)
 __PAGE_ALIGNED_BSS
 	.align PAGE_SIZE_asm
 #ifdef CONFIG_X86_PAE
-swapper_pg_pmd:
+initial_pg_pmd:
 	.fill 1024*KPMDS,4,0
 #else
-ENTRY(swapper_pg_dir)
+ENTRY(initial_page_table)
 	.fill 1024,4,0
 #endif
-swapper_pg_fixmap:
+initial_pg_fixmap:
 	.fill 1024,4,0
-#ifdef CONFIG_X86_TRAMPOLINE
-ENTRY(trampoline_pg_dir)
-	.fill 1024,4,0
-#endif
 ENTRY(empty_zero_page)
 	.fill 4096,1,0
+ENTRY(swapper_pg_dir)
+	.fill 1024,4,0
 
 /*
  * This starts the data section.
@@ -645,20 +640,20 @@ ENTRY(empty_zero_page)
 __PAGE_ALIGNED_DATA
 	/* Page-aligned for the benefit of paravirt? */
 	.align PAGE_SIZE_asm
-ENTRY(swapper_pg_dir)
-	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR),0	/* low identity map */
+ENTRY(initial_page_table)
+	.long	pa(initial_pg_pmd+PGD_IDENT_ATTR),0	/* low identity map */
 # if KPMDS == 3
-	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR),0
-	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR+0x1000),0
-	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR+0x2000),0
+	.long	pa(initial_pg_pmd+PGD_IDENT_ATTR),0
+	.long	pa(initial_pg_pmd+PGD_IDENT_ATTR+0x1000),0
+	.long	pa(initial_pg_pmd+PGD_IDENT_ATTR+0x2000),0
 # elif KPMDS == 2
 	.long	0,0
-	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR),0
-	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR+0x1000),0
+	.long	pa(initial_pg_pmd+PGD_IDENT_ATTR),0
+	.long	pa(initial_pg_pmd+PGD_IDENT_ATTR+0x1000),0
 # elif KPMDS == 1
 	.long	0,0
 	.long	0,0
-	.long	pa(swapper_pg_pmd+PGD_IDENT_ATTR),0
+	.long	pa(initial_pg_pmd+PGD_IDENT_ATTR),0
 # else
 #  error "Kernel PMDs should be 1, 2 or 3"
 # endif
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 7a4cf14..f7f53dc 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -371,16 +371,10 @@ void machine_real_restart(const unsigned char *code, int length)
 	CMOS_WRITE(0x00, 0x8f);
 	spin_unlock(&rtc_lock);
 
-	/* Remap the kernel at virtual address zero, as well as offset zero
-	   from the kernel segment.  This assumes the kernel segment starts at
-	   virtual address PAGE_OFFSET. */
-	memcpy(swapper_pg_dir, swapper_pg_dir + KERNEL_PGD_BOUNDARY,
-		sizeof(swapper_pg_dir [0]) * KERNEL_PGD_PTRS);
-
 	/*
-	 * Use `swapper_pg_dir' as our page directory.
+	 * Switch back to the initial page table.
 	 */
-	load_cr3(swapper_pg_dir);
+	load_cr3(initial_page_table);
 
 	/* Write 0x1234 to absolute memory location 0x472.  The BIOS reads
 	   this on booting to tell it to "Bypass memory test (also warm
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 322b24f..af6cf2b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -728,6 +728,17 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
+
+	/*
+	 * copy kernel address range established so far and switch
+	 * to the proper swapper page table
+	 */
+	clone_pgd_range(swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
+			initial_page_table + KERNEL_PGD_BOUNDARY,
+			KERNEL_PGD_PTRS);
+
+	load_cr3(swapper_pg_dir);
+	__flush_tlb_all();
 #else
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
@@ -1009,7 +1020,12 @@ void __init setup_arch(char **cmdline_p)
 	paging_init();
 	x86_init.paging.pagetable_setup_done(swapper_pg_dir);
 
-	setup_trampoline_page_table();
+#ifdef CONFIG_X86_32
+	/* sync back kernel address range */
+	clone_pgd_range(initial_page_table + KERNEL_PGD_BOUNDARY,
+			swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
+			KERNEL_PGD_PTRS);
+#endif
 
 	tboot_probe();
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 63a1a55..e63bb51 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -298,22 +298,16 @@ notrace static void __cpuinit start_secondary(void *unused)
 	 * fragile that we want to limit the things done here to the
 	 * most necessary things.
 	 */
+	cpu_init();
+	preempt_disable();
+	smp_callin();
 
 #ifdef CONFIG_X86_32
-	/*
-	 * Switch away from the trampoline page-table
-	 *
-	 * Do this before cpu_init() because it needs to access per-cpu
-	 * data which may not be mapped in the trampoline page-table.
-	 */
+	/* switch away from the initial page table */
 	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
 #endif
 
-	cpu_init();
-	preempt_disable();
-	smp_callin();
-
 	/* otherwise gcc will move up smp_processor_id before the cpu_init */
 	barrier();
 	/*
@@ -772,7 +766,6 @@ do_rest:
 #ifdef CONFIG_X86_32
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	irq_ctx_init(cpu);
-	initial_page_table = __pa(&trampoline_pg_dir);
 #else
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 	initial_gs = per_cpu_offset(cpu);
@@ -921,7 +914,6 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 
 	err = do_boot_cpu(apicid, cpu);
-
 	if (err) {
 		pr_debug("do_boot_cpu failed %d\n", err);
 		return -EIO;
diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index e2a5952..f1488a3 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -38,19 +38,3 @@ unsigned long __trampinit setup_trampoline(void)
 	memcpy(trampoline_base, trampoline_data, TRAMPOLINE_SIZE);
 	return virt_to_phys(trampoline_base);
 }
-
-void __init setup_trampoline_page_table(void)
-{
-#ifdef CONFIG_X86_32
-	/* Copy kernel address range */
-	clone_pgd_range(trampoline_pg_dir + KERNEL_PGD_BOUNDARY,
-			swapper_pg_dir + KERNEL_PGD_BOUNDARY,
-			KERNEL_PGD_PTRS);
-
-	/* Initialize low mappings */
-	clone_pgd_range(trampoline_pg_dir,
-			swapper_pg_dir + KERNEL_PGD_BOUNDARY,
-			min_t(unsigned long, KERNEL_PGD_PTRS,
-			      KERNEL_PGD_BOUNDARY));
-#endif
-}
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 558f2d3..1aeac2d 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -548,48 +548,6 @@ static void __init pagetable_init(void)
 	permanent_kmaps_init(pgd_base);
 }
 
-#ifdef CONFIG_ACPI_SLEEP
-/*
- * ACPI suspend needs this for resume, because things like the intel-agp
- * driver might have split up a kernel 4MB mapping.
- */
-char swsusp_pg_dir[PAGE_SIZE]
-	__attribute__ ((aligned(PAGE_SIZE)));
-
-static inline void save_pg_dir(void)
-{
-	copy_page(swsusp_pg_dir, swapper_pg_dir);
-}
-#else /* !CONFIG_ACPI_SLEEP */
-static inline void save_pg_dir(void)
-{
-}
-#endif /* !CONFIG_ACPI_SLEEP */
-
-void zap_low_mappings(bool early)
-{
-	int i;
-
-	/*
-	 * Zap initial low-memory mappings.
-	 *
-	 * Note that "pgd_clear()" doesn't do it for
-	 * us, because pgd_clear() is a no-op on i386.
-	 */
-	for (i = 0; i < KERNEL_PGD_BOUNDARY; i++) {
-#ifdef CONFIG_X86_PAE
-		set_pgd(swapper_pg_dir+i, __pgd(1 + __pa(empty_zero_page)));
-#else
-		set_pgd(swapper_pg_dir+i, __pgd(0));
-#endif
-	}
-
-	if (early)
-		__flush_tlb();
-	else
-		flush_tlb_all();
-}
-
 pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL | _PAGE_IOMAP);
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
@@ -958,9 +916,6 @@ void __init mem_init(void)
 
 	if (boot_cpu_data.wp_works_ok < 0)
 		test_wp_bit();
-
-	save_pg_dir();
-	zap_low_mappings(true);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
