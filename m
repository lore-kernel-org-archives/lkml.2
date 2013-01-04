Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3ADAtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:49:46 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26754 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab3ADAth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:49:37 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7u1 08/31] x86, 64bit: early #PF handler set page table
Date: Thu,  3 Jan 2013 16:48:28 -0800
Message-Id: <1357260531-11115-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

two use cases:
1. We will support load and run kernel above 4G, and zero_page, ramdisk
   will be above 4G, too
2. need to access ramdisk early to get microcode to update that as
   early possible.

We could use early_iomap to access them, but it will make code to
messy and hard to unified with 32bit.

So here comes #PF handler to set page page.

When #PF happen, handler will use pages in __initdata to set page page
to cover accessed page.

those code and page in __INIT sections, so will not increase ram usages.

The good point is: with help of #PF handler, we can set kernel mapping
from blank, and switch to init_level4_pgt later.

switchover in head_64.S is only using three page to handle kernel
crossing 1G, 512G with shareing page, most insteresting part.

early_make_pgtable is using kernel high mapping address to access pages
to set page table.

-v4: Add phys_base offset to make kexec happy, and add
	init_mapping_kernel()   - Yinghai
-v5: fix compiling with xen, and add back ident level3 and level2 for xen
     also move back init_level4_pgt from BSS to DATA again.
     because we have to clear it anyway.  - Yinghai
-v6: switch to init_level4_pgt in init_mem_mapping. - Yinghai
-v7: remove not needed clear_page for init_level4_page
     it is with fill 512,8,0 already in head_64.S  - Yinghai
-v8: we need to keep that handler alive until init_mem_mapping and don't
     let early_trap_init to trash that early #PF handler.
     So split early_trap_pf_init out and move it down. - Yinghai
-v9: switchover only cover kernel space instead of 1G so could avoid
     touch possible mem holes. - Yinghai
-v11: change far jmp back to far return to initial_code, that is needed
     to fix failure that is reported by Konrad on AMD system.  - Yinghai

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/pgtable_64_types.h |    4 +
 arch/x86/include/asm/processor.h        |    1 +
 arch/x86/kernel/head64.c                |   81 ++++++++++--
 arch/x86/kernel/head_64.S               |  210 +++++++++++++++++++------------
 arch/x86/kernel/setup.c                 |    2 +
 arch/x86/kernel/traps.c                 |    9 ++
 arch/x86/mm/init.c                      |    3 +-
 7 files changed, 219 insertions(+), 91 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 766ea16..2d88344 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_PGTABLE_64_DEFS_H
 #define _ASM_X86_PGTABLE_64_DEFS_H
 
+#include <asm/sparsemem.h>
+
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 
@@ -60,4 +62,6 @@ typedef struct { pteval_t pte; } pte_t;
 #define MODULES_END      _AC(0xffffffffff000000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 
+#define EARLY_DYNAMIC_PAGE_TABLES	64
+
 #endif /* _ASM_X86_PGTABLE_64_DEFS_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 888184b..bdee8bd 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -731,6 +731,7 @@ extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
 extern void early_trap_init(void);
+void early_trap_pf_init(void);
 
 /* Defined in head.S */
 extern struct desc_ptr		early_gdt_descr;
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index c0a25e0..25591f9 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -26,11 +26,73 @@
 #include <asm/e820.h>
 #include <asm/bios_ebda.h>
 
-static void __init zap_identity_mappings(void)
+/*
+ * Manage page tables very early on.
+ */
+extern pgd_t early_level4_pgt[PTRS_PER_PGD];
+extern pmd_t early_dynamic_pgts[EARLY_DYNAMIC_PAGE_TABLES][PTRS_PER_PMD];
+static unsigned int __initdata next_early_pgt = 2;
+
+/* Wipe all early page tables except for the kernel symbol map */
+static void __init reset_early_page_tables(void)
 {
-	pgd_t *pgd = pgd_offset_k(0UL);
-	pgd_clear(pgd);
-	__flush_tlb_all();
+	unsigned long i;
+
+	for (i = 0; i < PTRS_PER_PGD-1; i++)
+		early_level4_pgt[i].pgd = 0;
+
+	next_early_pgt = 0;
+
+	write_cr3(__pa(early_level4_pgt));
+}
+
+/* Create a new PMD entry */
+int __init early_make_pgtable(unsigned long address)
+{
+	unsigned long physaddr = address - __PAGE_OFFSET;
+	unsigned long i;
+	pgdval_t pgd, *pgd_p;
+	pudval_t *pud_p;
+	pmdval_t pmd, *pmd_p;
+
+	/* Invalid address or early pgt is done ?  */
+	if (physaddr >= MAXMEM || read_cr3() != __pa(early_level4_pgt))
+		return -1;
+
+	i = (address >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1);
+	pgd_p = &early_level4_pgt[i].pgd;
+	pgd = *pgd_p;
+
+	/*
+	 * The use of __START_KERNEL_map rather than __PAGE_OFFSET here is
+	 * critical -- __PAGE_OFFSET would point us back into the dynamic
+	 * range and we might end up looping forever...
+	 */
+	if (pgd && next_early_pgt < EARLY_DYNAMIC_PAGE_TABLES) {
+		pud_p = (pudval_t *)((pgd & PTE_PFN_MASK) + __START_KERNEL_map - phys_base);
+	} else {
+		if (next_early_pgt >= EARLY_DYNAMIC_PAGE_TABLES-1)
+			reset_early_page_tables();
+
+		pud_p = (pudval_t *)early_dynamic_pgts[next_early_pgt++];
+		for (i = 0; i < PTRS_PER_PUD; i++)
+			pud_p[i] = 0;
+
+		*pgd_p = (pgdval_t)pud_p - __START_KERNEL_map + phys_base + _KERNPG_TABLE;
+	}
+	i = (address >> PUD_SHIFT) & (PTRS_PER_PUD - 1);
+	pud_p += i;
+
+	pmd_p = (pmdval_t *)early_dynamic_pgts[next_early_pgt++];
+	pmd = (physaddr & PUD_MASK) + (__PAGE_KERNEL_LARGE & ~_PAGE_GLOBAL);
+	for (i = 0; i < PTRS_PER_PMD; i++) {
+		pmd_p[i] = pmd;
+		pmd += PMD_SIZE;
+	}
+
+	*pud_p = (pudval_t)pmd_p - __START_KERNEL_map + phys_base + _KERNPG_TABLE;
+
+	return 0;
 }
 
 /* Don't add a printk in there. printk relies on the PDA which is not initialized 
@@ -70,12 +132,13 @@ void __init x86_64_start_kernel(char * real_mode_data)
 				(__START_KERNEL & PGDIR_MASK)));
 	BUILD_BUG_ON(__fix_to_virt(__end_of_fixed_addresses) <= MODULES_END);
 
+	/* Kill off the identity-map trampoline */
+	reset_early_page_tables();
+
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
 
-	/* Make NULL pointers segfault */
-	zap_identity_mappings();
-
+	/* XXX - this is wrong... we need to build page tables from scratch */
 	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
 
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
@@ -92,6 +155,10 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	if (console_loglevel == 10)
 		early_printk("Kernel alive\n");
 
+	clear_page(init_level4_pgt);
+	/* set init_level4_pgt kernel high mapping*/
+	init_level4_pgt[511] = early_level4_pgt[511];
+
 	x86_64_start_reservations(real_mode_data);
 }
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 980053c..d94f6d6 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -47,14 +47,13 @@ L3_START_KERNEL = pud_index(__START_KERNEL_map)
 	.code64
 	.globl startup_64
 startup_64:
-
 	/*
 	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 1,
 	 * and someone has loaded an identity mapped page table
 	 * for us.  These identity mapped page tables map all of the
 	 * kernel pages and possibly all of memory.
 	 *
-	 * %esi holds a physical pointer to real_mode_data.
+	 * %rsi holds a physical pointer to real_mode_data.
 	 *
 	 * We come here either directly from a 64bit bootloader, or from
 	 * arch/x86_64/boot/compressed/head.S.
@@ -66,7 +65,8 @@ startup_64:
 	 * tables and then reload them.
 	 */
 
-	/* Compute the delta between the address I am compiled to run at and the
+	/*
+	 * Compute the delta between the address I am compiled to run at and the
 	 * address I am actually running at.
 	 */
 	leaq	_text(%rip), %rbp
@@ -78,45 +78,62 @@ startup_64:
 	testl	%eax, %eax
 	jnz	bad_address
 
-	/* Is the address too large? */
-	leaq	_text(%rip), %rdx
-	movq	$PGDIR_SIZE, %rax
-	cmpq	%rax, %rdx
-	jae	bad_address
-
-	/* Fixup the physical addresses in the page table
+	/*
+	 * Is the address too large?
 	 */
-	addq	%rbp, init_level4_pgt + 0(%rip)
-	addq	%rbp, init_level4_pgt + (L4_PAGE_OFFSET*8)(%rip)
-	addq	%rbp, init_level4_pgt + (L4_START_KERNEL*8)(%rip)
+	leaq	_text(%rip), %rax
+	shrq	$MAX_PHYSMEM_BITS, %rax
+	jnz	bad_address
 
-	addq	%rbp, level3_ident_pgt + 0(%rip)
+	/*
+	 * Fixup the physical addresses in the page table
+	 */
+	addq	%rbp, early_level4_pgt + (L4_START_KERNEL*8)(%rip)
 
 	addq	%rbp, level3_kernel_pgt + (510*8)(%rip)
 	addq	%rbp, level3_kernel_pgt + (511*8)(%rip)
 
 	addq	%rbp, level2_fixmap_pgt + (506*8)(%rip)
 
-	/* Add an Identity mapping if I am above 1G */
+	/*
+	 * Set up the identity mapping for the switchover.  These
+	 * entries should *NOT* have the global bit set!  This also
+	 * creates a bunch of nonsense entries but that is fine --
+	 * it avoids problems around wraparound.
+	 */
 	leaq	_text(%rip), %rdi
-	andq	$PMD_PAGE_MASK, %rdi
+	leaq	early_level4_pgt(%rip), %rbx
 
 	movq	%rdi, %rax
-	shrq	$PUD_SHIFT, %rax
-	andq	$(PTRS_PER_PUD - 1), %rax
-	jz	ident_complete
+	shrq	$PGDIR_SHIFT, %rax
 
-	leaq	(level2_spare_pgt - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
-	leaq	level3_ident_pgt(%rip), %rbx
-	movq	%rdx, 0(%rbx, %rax, 8)
+	leaq	(4096 + _KERNPG_TABLE)(%rbx), %rdx
+	movq	%rdx, 0(%rbx,%rax,8)
+	movq	%rdx, 8(%rbx,%rax,8)
 
+	addq	$4096, %rdx
 	movq	%rdi, %rax
-	shrq	$PMD_SHIFT, %rax
-	andq	$(PTRS_PER_PMD - 1), %rax
-	leaq	__PAGE_KERNEL_IDENT_LARGE_EXEC(%rdi), %rdx
-	leaq	level2_spare_pgt(%rip), %rbx
-	movq	%rdx, 0(%rbx, %rax, 8)
-ident_complete:
+	shrq	$PUD_SHIFT, %rax
+	andl	$(PTRS_PER_PUD-1), %eax
+	movq	%rdx, (4096+0)(%rbx,%rax,8)
+	movq	%rdx, (4096+8)(%rbx,%rax,8)
+
+	addq	$8192, %rbx
+	movq	%rdi, %rax
+	shrq	$PMD_SHIFT, %rdi
+	addq	$(__PAGE_KERNEL_LARGE_EXEC & ~_PAGE_GLOBAL), %rax
+	leaq	(_end - 1)(%rip), %rcx
+	shrq	$PMD_SHIFT, %rcx
+	subq	%rdi, %rcx
+	incl	%ecx
+
+1:
+	andq	$(PTRS_PER_PMD - 1), %rdi
+	movq	%rax, (%rbx,%rdi,8)
+	incq	%rdi
+	addq	$PMD_SIZE, %rax
+	decl	%ecx
+	jnz	1b
 
 	/*
 	 * Fixup the kernel text+data virtual addresses. Note that
@@ -124,7 +141,6 @@ ident_complete:
 	 * cleanup_highmap() fixes this up along with the mappings
 	 * beyond _end.
 	 */
-
 	leaq	level2_kernel_pgt(%rip), %rdi
 	leaq	4096(%rdi), %r8
 	/* See if it is a valid page table entry */
@@ -139,17 +155,14 @@ ident_complete:
 	/* Fixup phys_base */
 	addq	%rbp, phys_base(%rip)
 
-	/* Due to ENTRY(), sometimes the empty space gets filled with
-	 * zeros. Better take a jmp than relying on empty space being
-	 * filled with 0x90 (nop)
-	 */
-	jmp secondary_startup_64
+	movq	$(early_level4_pgt - __START_KERNEL_map), %rax
+	jmp 1f
 ENTRY(secondary_startup_64)
 	/*
 	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 1,
 	 * and someone has loaded a mapped page table.
 	 *
-	 * %esi holds a physical pointer to real_mode_data.
+	 * %rsi holds a physical pointer to real_mode_data.
 	 *
 	 * We come here either from startup_64 (using physical addresses)
 	 * or from trampoline.S (using virtual addresses).
@@ -159,12 +172,14 @@ ENTRY(secondary_startup_64)
 	 * after the boot processor executes this code.
 	 */
 
+	movq	$(init_level4_pgt - __START_KERNEL_map), %rax
+1:
+
 	/* Enable PAE mode and PGE */
-	movl	$(X86_CR4_PAE | X86_CR4_PGE), %eax
-	movq	%rax, %cr4
+	movl	$(X86_CR4_PAE | X86_CR4_PGE), %ecx
+	movq	%rcx, %cr4
 
 	/* Setup early boot stage 4 level pagetables. */
-	movq	$(init_level4_pgt - __START_KERNEL_map), %rax
 	addq	phys_base(%rip), %rax
 	movq	%rax, %cr3
 
@@ -196,7 +211,7 @@ ENTRY(secondary_startup_64)
 	movq	%rax, %cr0
 
 	/* Setup a boot time stack */
-	movq stack_start(%rip),%rsp
+	movq stack_start(%rip), %rsp
 
 	/* zero EFLAGS after setting rsp */
 	pushq $0
@@ -236,15 +251,33 @@ ENTRY(secondary_startup_64)
 	movl	initial_gs+4(%rip),%edx
 	wrmsr	
 
-	/* esi is pointer to real mode structure with interesting info.
+	/* rsi is pointer to real mode structure with interesting info.
 	   pass it to C */
-	movl	%esi, %edi
+	movq	%rsi, %rdi
 	
 	/* Finally jump to run C code and to be on real kernel address
 	 * Since we are running on identity-mapped space we have to jump
 	 * to the full 64bit address, this is only possible as indirect
 	 * jump.  In addition we need to ensure %cs is set so we make this
 	 * a far return.
+	 *
+	 * Note: do not change to far jump indirect with 64bit offset.
+	 *
+	 * AMD does not support far jump indirect with 64bit offset.
+	 * AMD64 Architecture Programmer's Manual, Volume 3: states only
+	 *	JMP FAR mem16:16 FF /5 Far jump indirect,
+	 *		with the target specified by a far pointer in memory.
+	 *	JMP FAR mem16:32 FF /5 Far jump indirect,
+	 *		with the target specified by a far pointer in memory.
+	 *
+	 * Intel64 does support 64bit offset.
+	 * Software Developer Manual Vol 2: states:
+	 *	FF /5 JMP m16:16 Jump far, absolute indirect,
+	 *		address given in m16:16
+	 *	FF /5 JMP m16:32 Jump far, absolute indirect,
+	 *		address given in m16:32.
+	 *	REX.W + FF /5 JMP m16:64 Jump far, absolute indirect,
+	 *		address given in m16:64.
 	 */
 	movq	initial_code(%rip),%rax
 	pushq	$0		# fake return address to stop unwinder
@@ -270,13 +303,13 @@ ENDPROC(start_cpu0)
 
 	/* SMP bootup changes these two */
 	__REFDATA
-	.align	8
-	ENTRY(initial_code)
+	.balign	8
+	GLOBAL(initial_code)
 	.quad	x86_64_start_kernel
-	ENTRY(initial_gs)
+	GLOBAL(initial_gs)
 	.quad	INIT_PER_CPU_VAR(irq_stack_union)
 
-	ENTRY(stack_start)
+	GLOBAL(stack_start)
 	.quad  init_thread_union+THREAD_SIZE-8
 	.word  0
 	__FINITDATA
@@ -284,7 +317,7 @@ ENDPROC(start_cpu0)
 bad_address:
 	jmp bad_address
 
-	.section ".init.text","ax"
+	__INIT
 	.globl early_idt_handlers
 early_idt_handlers:
 	# 104(%rsp) %rflags
@@ -321,14 +354,22 @@ ENTRY(early_idt_handler)
 	pushq %r11		#  0(%rsp)
 
 	cmpl $__KERNEL_CS,96(%rsp)
-	jne 10f
+	jne 11f
+
+	cmpl $14,72(%rsp)	# Page fault?
+	jnz 10f
+	GET_CR2_INTO(%rdi)	# can clobber any volatile register if pv
+	call early_make_pgtable
+	andl %eax,%eax
+	jz 20f			# All good
 
+10:
 	leaq 88(%rsp),%rdi	# Pointer to %rip
 	call early_fixup_exception
 	andl %eax,%eax
 	jnz 20f			# Found an exception entry
 
-10:
+11:
 #ifdef CONFIG_EARLY_PRINTK
 	GET_CR2_INTO(%r9)	# can clobber any volatile register if pv
 	movl 80(%rsp),%r8d	# error code
@@ -350,7 +391,7 @@ ENTRY(early_idt_handler)
 1:	hlt
 	jmp 1b
 
-20:	# Exception table entry found
+20:	# Exception table entry found or page table generated
 	popq %r11
 	popq %r10
 	popq %r9
@@ -364,6 +405,8 @@ ENTRY(early_idt_handler)
 	decl early_recursion_flag(%rip)
 	INTERRUPT_RETURN
 
+	__INITDATA
+
 	.balign 4
 early_recursion_flag:
 	.long 0
@@ -374,11 +417,10 @@ early_idt_msg:
 early_idt_ripmsg:
 	.asciz "RIP %s\n"
 #endif /* CONFIG_EARLY_PRINTK */
-	.previous
 
 #define NEXT_PAGE(name) \
 	.balign	PAGE_SIZE; \
-ENTRY(name)
+GLOBAL(name)
 
 /* Automate the creation of 1 to 1 mapping pmd entries */
 #define PMDS(START, PERM, COUNT)			\
@@ -388,24 +430,37 @@ ENTRY(name)
 	i = i + 1 ;					\
 	.endr
 
+	__INITDATA
+NEXT_PAGE(early_level4_pgt)
+	.fill	511,8,0
+	.quad	level3_kernel_pgt - __START_KERNEL_map + _PAGE_TABLE
+
+NEXT_PAGE(early_dynamic_pgts)
+	.fill	512*EARLY_DYNAMIC_PAGE_TABLES,8,0
+
 	.data
-	/*
-	 * This default setting generates an ident mapping at address 0x100000
-	 * and a mapping for the kernel that precisely maps virtual address
-	 * 0xffffffff80000000 to physical address 0x000000. (always using
-	 * 2Mbyte large pages provided by PAE mode)
-	 */
+
+#ifndef CONFIG_XEN
 NEXT_PAGE(init_level4_pgt)
-	.quad	level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
-	.org	init_level4_pgt + L4_PAGE_OFFSET*8, 0
-	.quad	level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
-	.org	init_level4_pgt + L4_START_KERNEL*8, 0
+	.fill	512,8,0
+#else
+NEXT_PAGE(init_level4_pgt)
+	.quad   level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
+	.org    init_level4_pgt + L4_PAGE_OFFSET*8, 0
+	.quad   level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
+	.org    init_level4_pgt + L4_START_KERNEL*8, 0
 	/* (2^48-(2*1024*1024*1024))/(2^39) = 511 */
-	.quad	level3_kernel_pgt - __START_KERNEL_map + _PAGE_TABLE
+	.quad   level3_kernel_pgt - __START_KERNEL_map + _PAGE_TABLE
 
 NEXT_PAGE(level3_ident_pgt)
 	.quad	level2_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
-	.fill	511,8,0
+	.fill	511, 8, 0
+NEXT_PAGE(level2_ident_pgt)
+	/* Since I easily can, map the first 1G.
+	 * Don't set NX because code runs from these pages.
+	 */
+	PMDS(0, __PAGE_KERNEL_IDENT_LARGE_EXEC, PTRS_PER_PMD)
+#endif
 
 NEXT_PAGE(level3_kernel_pgt)
 	.fill	L3_START_KERNEL,8,0
@@ -413,21 +468,6 @@ NEXT_PAGE(level3_kernel_pgt)
 	.quad	level2_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE
 	.quad	level2_fixmap_pgt - __START_KERNEL_map + _PAGE_TABLE
 
-NEXT_PAGE(level2_fixmap_pgt)
-	.fill	506,8,0
-	.quad	level1_fixmap_pgt - __START_KERNEL_map + _PAGE_TABLE
-	/* 8MB reserved for vsyscalls + a 2MB hole = 4 + 1 entries */
-	.fill	5,8,0
-
-NEXT_PAGE(level1_fixmap_pgt)
-	.fill	512,8,0
-
-NEXT_PAGE(level2_ident_pgt)
-	/* Since I easily can, map the first 1G.
-	 * Don't set NX because code runs from these pages.
-	 */
-	PMDS(0, __PAGE_KERNEL_IDENT_LARGE_EXEC, PTRS_PER_PMD)
-
 NEXT_PAGE(level2_kernel_pgt)
 	/*
 	 * 512 MB kernel mapping. We spend a full page on this pagetable
@@ -442,11 +482,16 @@ NEXT_PAGE(level2_kernel_pgt)
 	PMDS(0, __PAGE_KERNEL_LARGE_EXEC,
 		KERNEL_IMAGE_SIZE/PMD_SIZE)
 
-NEXT_PAGE(level2_spare_pgt)
-	.fill   512, 8, 0
+NEXT_PAGE(level2_fixmap_pgt)
+	.fill	506,8,0
+	.quad	level1_fixmap_pgt - __START_KERNEL_map + _PAGE_TABLE
+	/* 8MB reserved for vsyscalls + a 2MB hole = 4 + 1 entries */
+	.fill	5,8,0
+
+NEXT_PAGE(level1_fixmap_pgt)
+	.fill	512,8,0
 
 #undef PMDS
-#undef NEXT_PAGE
 
 	.data
 	.align 16
@@ -472,6 +517,5 @@ ENTRY(nmi_idt_table)
 	.skip IDT_ENTRIES * 16
 
 	__PAGE_ALIGNED_BSS
-	.align PAGE_SIZE
-ENTRY(empty_zero_page)
+NEXT_PAGE(empty_zero_page)
 	.skip PAGE_SIZE
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 01b22d0..63160c6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -917,6 +917,8 @@ void __init setup_arch(char **cmdline_p)
 
 	init_mem_mapping();
 
+	early_trap_pf_init();
+
 	setup_real_mode();
 
 	memblock.current_limit = get_max_mapped();
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ecffca1..68bda7a 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -688,10 +688,19 @@ void __init early_trap_init(void)
 	set_intr_gate_ist(X86_TRAP_DB, &debug, DEBUG_STACK);
 	/* int3 can be called from all */
 	set_system_intr_gate_ist(X86_TRAP_BP, &int3, DEBUG_STACK);
+#ifdef CONFIG_X86_32
 	set_intr_gate(X86_TRAP_PF, &page_fault);
+#endif
 	load_idt(&idt_descr);
 }
 
+void __init early_trap_pf_init(void)
+{
+#ifdef CONFIG_X86_64
+	set_intr_gate(X86_TRAP_PF, &page_fault);
+#endif
+}
+
 void __init trap_init(void)
 {
 	int i;
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index c4293cf..ab26a15 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -437,9 +437,10 @@ void __init init_mem_mapping(void)
 	}
 #else
 	early_ioremap_page_table_range_init();
+#endif
+
 	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
-#endif
 
 	early_memtest(0, max_pfn_mapped << PAGE_SHIFT);
 }
-- 
1.7.10.4

