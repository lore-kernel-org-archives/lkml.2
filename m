Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab1ADGvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 01:51:03 -0500
Received: from ozlabs.org ([203.10.76.45]:32838 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab1ADGvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 01:51:01 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: x86@kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: initialize initial_page_table before paravirt jumps
Date: Tue, 4 Jan 2011 17:20:54 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
References: <201012221259.01671.rusty@rustcorp.com.au>
In-Reply-To: <201012221259.01671.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101041720.54535.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010 12:59:00 pm Rusty Russell wrote:
> v2.6.36-rc8-54-gb40827f (x86-32, mm: Add an initial page table for
> core bootstrapping) made x86 boot using initial_page_table and broke
> lguest.
> 
> For 2.6.37 we simply cut & paste the initialization code into lguest
> (da32dac10126 "lguest: populate initial_page_table"), now we fix it
> properly by doing that initialization before the paravirt jump.

Ping?  Ingo?  I don't see this in -tip...

Thanks,
Rusty.

Subject: x86: initialize initial_page_table before paravirt jumps

v2.6.36-rc8-54-gb40827f (x86-32, mm: Add an initial page table for
core bootstrapping) made x86 boot using initial_page_table and broke
lguest.

For 2.6.37 we simply cut & paste the initialization code into lguest
(da32dac10126 "lguest: populate initial_page_table"), now we fix it
properly by doing that initialization before the paravirt jump.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/kernel/head_32.S   |   77 ++++++++++++++++----------------
 arch/x86/lguest/i386_head.S |  105 --------------------------------------------
 2 files changed, 39 insertions(+), 143 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -139,39 +139,6 @@ 1:
 	movl %eax, pa(olpc_ofw_pgd)
 #endif
 
-#ifdef CONFIG_PARAVIRT
-	/* This is can only trip for a broken bootloader... */
-	cmpw $0x207, pa(boot_params + BP_version)
-	jb default_entry
-
-	/* Paravirt-compatible boot parameters.  Look to see what architecture
-		we're booting under. */
-	movl pa(boot_params + BP_hardware_subarch), %eax
-	cmpl $num_subarch_entries, %eax
-	jae bad_subarch
-
-	movl pa(subarch_entries)(,%eax,4), %eax
-	subl $__PAGE_OFFSET, %eax
-	jmp *%eax
-
-bad_subarch:
-WEAK(lguest_entry)
-WEAK(xen_entry)
-	/* Unknown implementation; there's really
-	   nothing we can do at this point. */
-	ud2a
-
-	__INITDATA
-
-subarch_entries:
-	.long default_entry		/* normal x86/PC */
-	.long lguest_entry		/* lguest hypervisor */
-	.long xen_entry			/* Xen hypervisor */
-	.long default_entry		/* Moorestown MID */
-num_subarch_entries = (. - subarch_entries) / 4
-.previous
-#endif /* CONFIG_PARAVIRT */
-
 /*
  * Initialize page tables.  This creates a PDE and a set of page
  * tables, which are located immediately beyond __brk_base.  The variable
@@ -181,7 +148,6 @@ num_subarch_entries = (. - subarch_entri
  *
  * Note that the stack is not yet set up!
  */
-default_entry:
 #ifdef CONFIG_X86_PAE
 
 	/*
@@ -261,7 +227,42 @@ 11:
 	movl $pa(initial_pg_fixmap)+PDE_IDENT_ATTR,%eax
 	movl %eax,pa(initial_page_table+0xffc)
 #endif
-	jmp 3f
+
+#ifdef CONFIG_PARAVIRT
+	/* This is can only trip for a broken bootloader... */
+	cmpw $0x207, pa(boot_params + BP_version)
+	jb default_entry
+
+	/* Paravirt-compatible boot parameters.  Look to see what architecture
+		we're booting under. */
+	movl pa(boot_params + BP_hardware_subarch), %eax
+	cmpl $num_subarch_entries, %eax
+	jae bad_subarch
+
+	movl pa(subarch_entries)(,%eax,4), %eax
+	subl $__PAGE_OFFSET, %eax
+	jmp *%eax
+
+bad_subarch:
+WEAK(lguest_entry)
+WEAK(xen_entry)
+	/* Unknown implementation; there's really
+	   nothing we can do at this point. */
+	ud2a
+
+	__INITDATA
+
+subarch_entries:
+	.long default_entry		/* normal x86/PC */
+	.long lguest_entry		/* lguest hypervisor */
+	.long xen_entry			/* Xen hypervisor */
+	.long default_entry		/* Moorestown MID */
+num_subarch_entries = (. - subarch_entries) / 4
+.previous
+#else
+	jmp default_entry
+#endif /* CONFIG_PARAVIRT */
+
 /*
  * Non-boot CPU entry point; entered from trampoline.S
  * We can't lgdt here, because lgdt itself uses a data segment, but
@@ -282,7 +283,7 @@ ENTRY(startup_32_smp)
 	movl %eax,%fs
 	movl %eax,%gs
 #endif /* CONFIG_SMP */
-3:
+default_entry:
 
 /*
  *	New page tables may be in 4Mbyte page mode and may
@@ -622,13 +623,13 @@ ENTRY(initial_code)
 __PAGE_ALIGNED_BSS
 	.align PAGE_SIZE_asm
 #ifdef CONFIG_X86_PAE
-ENTRY(initial_pg_pmd)
+initial_pg_pmd:
 	.fill 1024*KPMDS,4,0
 #else
 ENTRY(initial_page_table)
 	.fill 1024,4,0
 #endif
-ENTRY(initial_pg_fixmap)
+initial_pg_fixmap:
 	.fill 1024,4,0
 ENTRY(empty_zero_page)
 	.fill 4096,1,0
diff --git a/arch/x86/lguest/i386_head.S b/arch/x86/lguest/i386_head.S
--- a/arch/x86/lguest/i386_head.S
+++ b/arch/x86/lguest/i386_head.S
@@ -4,7 +4,6 @@
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
 #include <asm/processor-flags.h>
-#include <asm/pgtable.h>
 
 /*G:020
  * Our story starts with the kernel booting into startup_32 in
@@ -38,113 +37,9 @@ ENTRY(lguest_entry)
 	/* Set up the initial stack so we can run C code. */
 	movl $(init_thread_union+THREAD_SIZE),%esp
 
-	call init_pagetables
-
 	/* Jumps are relative: we're running __PAGE_OFFSET too low. */
 	jmp lguest_init+__PAGE_OFFSET
 
-/*
- * Initialize page tables.  This creates a PDE and a set of page
- * tables, which are located immediately beyond __brk_base.  The variable
- * _brk_end is set up to point to the first "safe" location.
- * Mappings are created both at virtual address 0 (identity mapping)
- * and PAGE_OFFSET for up to _end.
- *
- * FIXME: This code is taken verbatim from arch/x86/kernel/head_32.S: they
- * don't have a stack at this point, so we can't just use call and ret.
- */
-init_pagetables:
-#if PTRS_PER_PMD > 1
-#define PAGE_TABLE_SIZE(pages) (((pages) / PTRS_PER_PMD) + PTRS_PER_PGD)
-#else
-#define PAGE_TABLE_SIZE(pages) ((pages) / PTRS_PER_PGD)
-#endif
-#define pa(X) ((X) - __PAGE_OFFSET)
-
-/* Enough space to fit pagetables for the low memory linear map */
-MAPPING_BEYOND_END = \
-	PAGE_TABLE_SIZE(((1<<32) - __PAGE_OFFSET) >> PAGE_SHIFT) << PAGE_SHIFT
-#ifdef CONFIG_X86_PAE
-
-	/*
-	 * In PAE mode initial_page_table is statically defined to contain
-	 * enough entries to cover the VMSPLIT option (that is the top 1, 2 or 3
-	 * entries). The identity mapping is handled by pointing two PGD entries
-	 * to the first kernel PMD.
-	 *
-	 * Note the upper half of each PMD or PTE are always zero at this stage.
-	 */
-
-#define KPMDS (((-__PAGE_OFFSET) >> 30) & 3) /* Number of kernel PMDs */
-
-	xorl %ebx,%ebx				/* %ebx is kept at zero */
-
-	movl $pa(__brk_base), %edi
-	movl $pa(initial_pg_pmd), %edx
-	movl $PTE_IDENT_ATTR, %eax
-10:
-	leal PDE_IDENT_ATTR(%edi),%ecx		/* Create PMD entry */
-	movl %ecx,(%edx)			/* Store PMD entry */
-						/* Upper half already zero */
-	addl $8,%edx
-	movl $512,%ecx
-11:
-	stosl
-	xchgl %eax,%ebx
-	stosl
-	xchgl %eax,%ebx
-	addl $0x1000,%eax
-	loop 11b
-
-	/*
-	 * End condition: we must map up to the end + MAPPING_BEYOND_END.
-	 */
-	movl $pa(_end) + MAPPING_BEYOND_END + PTE_IDENT_ATTR, %ebp
-	cmpl %ebp,%eax
-	jb 10b
-1:
-	addl $__PAGE_OFFSET, %edi
-	movl %edi, pa(_brk_end)
-	shrl $12, %eax
-	movl %eax, pa(max_pfn_mapped)
-
-	/* Do early initialization of the fixmap area */
-	movl $pa(initial_pg_fixmap)+PDE_IDENT_ATTR,%eax
-	movl %eax,pa(initial_pg_pmd+0x1000*KPMDS-8)
-#else	/* Not PAE */
-
-page_pde_offset = (__PAGE_OFFSET >> 20);
-
-	movl $pa(__brk_base), %edi
-	movl $pa(initial_page_table), %edx
-	movl $PTE_IDENT_ATTR, %eax
-10:
-	leal PDE_IDENT_ATTR(%edi),%ecx		/* Create PDE entry */
-	movl %ecx,(%edx)			/* Store identity PDE entry */
-	movl %ecx,page_pde_offset(%edx)		/* Store kernel PDE entry */
-	addl $4,%edx
-	movl $1024, %ecx
-11:
-	stosl
-	addl $0x1000,%eax
-	loop 11b
-	/*
-	 * End condition: we must map up to the end + MAPPING_BEYOND_END.
-	 */
-	movl $pa(_end) + MAPPING_BEYOND_END + PTE_IDENT_ATTR, %ebp
-	cmpl %ebp,%eax
-	jb 10b
-	addl $__PAGE_OFFSET, %edi
-	movl %edi, pa(_brk_end)
-	shrl $12, %eax
-	movl %eax, pa(max_pfn_mapped)
-
-	/* Do early initialization of the fixmap area */
-	movl $pa(initial_pg_fixmap)+PDE_IDENT_ATTR,%eax
-	movl %eax,pa(initial_page_table+0xffc)
-#endif
-	ret
-
 /*G:055
  * We create a macro which puts the assembler code between lgstart_ and lgend_
  * markers.  These templates are put in the .text section: they can't be
