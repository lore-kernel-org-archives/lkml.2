Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0H2UcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 16:32:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51695 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab0H2UcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 16:32:13 -0400
Date: Sun, 29 Aug 2010 22:32:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, Joerg Roedel <joro@8bytes.org>,
        "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>,
        "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
        "greg@kroah.com" <greg@kroah.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-32, mm: Add an initial page table for core
 bootstrapping
Message-ID: <20100829203205.GA6888@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
	Joerg Roedel <joro@8bytes.org>,
	"Roedel, Joerg" <Joerg.Roedel@amd.com>,
	"mingo@elte.hu" <mingo@elte.hu>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
	"Seidel, Conny" <Conny.Seidel@amd.com>,
	"Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
	"greg@kroah.com" <greg@kroah.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1280940316-7966-1-git-send-email-bp@amd64.org>
 <1280940316-7966-2-git-send-email-bp@amd64.org>
 <4C59F24B.1010702@zytor.com>
 <20100805074503.GI18307@amd.com>
 <4C5AC736.20903@zytor.com>
 <20100812144142.GY23755@8bytes.org>
 <4C64148D.5080305@zytor.com>
 <20100812154756.GD2070@aftab>
 <4C6417AB.1050105@zytor.com>
 <20100824073344.GA4793@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100824073344.GA4793@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an initial page table with low mappings used exclusively
for booting APs/resuming after ACPI suspend/machine restart. After this,
there's no need to add low mappings to swapper_pg_dir and zap them later
or create own swsusp PGD page solely for ACPI sleep needs.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---

Ok, here's the initial version. This patch has survived a whole weekend
of randconfig builds and has been boot/reboot/suspend/resume tested on
32-bit kvm guests and bare metal in all possible configurations of PAE
and !PAE kernels with all possible VMSPLIT_* config options.

Patch is against tip/x86/urgent ontop of Hugh's CONFIG_VMSPLIT_1G and
2G_OPT fix.

 arch/x86/include/asm/pgtable_32.h |    2 +-
 arch/x86/include/asm/tlbflush.h   |    2 -
 arch/x86/include/asm/trampoline.h |    3 --
 arch/x86/kernel/acpi/sleep.c      |    7 ++++-
 arch/x86/kernel/head32.c          |    1 +
 arch/x86/kernel/head_32.S         |   55 +++++++++++++++++--------------------
 arch/x86/kernel/reboot.c          |   10 +-----
 arch/x86/kernel/setup.c           |   18 +++++++++++-
 arch/x86/kernel/smpboot.c         |   19 ++++---------
 arch/x86/kernel/trampoline.c      |   16 -----------
 arch/x86/mm/init_32.c             |   45 ------------------------------
 11 files changed, 58 insertions(+), 120 deletions(-)

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
index 33cec15..d04500e 100644
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
+	header->pmode_cr3 = (u32)(initial_page_table - __PAGE_OFFSET);
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
index e3af342..ce5566e 100644
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
index c3a4fbb..b315b37 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -730,6 +730,17 @@ void __init setup_arch(char **cmdline_p)
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
@@ -1014,7 +1025,12 @@ void __init setup_arch(char **cmdline_p)
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
index 8b3bfc4..0d86d0b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -300,22 +300,17 @@ notrace static void __cpuinit start_secondary(void *unused)
 	 * most necessary things.
 	 */
 
-#ifdef CONFIG_X86_32
-	/*
-	 * Switch away from the trampoline page-table
-	 *
-	 * Do this before cpu_init() because it needs to access per-cpu
-	 * data which may not be mapped in the trampoline page-table.
-	 */
-	load_cr3(swapper_pg_dir);
-	__flush_tlb_all();
-#endif
-
 	vmi_bringup();
 	cpu_init();
 	preempt_disable();
 	smp_callin();
 
+#ifdef CONFIG_X86_32
+	/* switch away from the initial page table */
+	load_cr3(swapper_pg_dir);
+	__flush_tlb_all();
+#endif
+
 	/* otherwise gcc will move up smp_processor_id before the cpu_init */
 	barrier();
 	/*
@@ -774,7 +769,6 @@ do_rest:
 #ifdef CONFIG_X86_32
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	irq_ctx_init(cpu);
-	initial_page_table = __pa(&trampoline_pg_dir);
 #else
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 	initial_gs = per_cpu_offset(cpu);
@@ -923,7 +917,6 @@ int __cpuinit native_cpu_up(unsigned int cpu)
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
index bca7909..adad48b 100644
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
-	memcpy(swsusp_pg_dir, swapper_pg_dir, PAGE_SIZE);
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
-- 
1.7.1

-- 
Regards/Gruss,
    Boris.
