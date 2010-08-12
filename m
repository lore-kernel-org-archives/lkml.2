Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab0HLRg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 13:36:59 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55742 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0HLRg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 13:36:58 -0400
Date: Thu, 12 Aug 2010 19:38:12 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joerg Roedel <joro@8bytes.org>, "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>,
        "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
        "greg@kroah.com" <greg@kroah.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86-32: Fix crashes with CPU hotplug on AMD
 machines
Message-ID: <20100812173812.GA4127@aftab>
References: <1280940316-7966-1-git-send-email-bp@amd64.org>
 <1280940316-7966-2-git-send-email-bp@amd64.org>
 <4C59F24B.1010702@zytor.com>
 <20100805074503.GI18307@amd.com>
 <4C5AC736.20903@zytor.com>
 <20100812144142.GY23755@8bytes.org>
 <4C64148D.5080305@zytor.com>
 <20100812154756.GD2070@aftab>
 <4C6417AB.1050105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6417AB.1050105@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, Aug 12, 2010 at 11:47:55AM -0400

> On 08/12/2010 08:47 AM, Borislav Petkov wrote:
> >>
> >> Agreed.  I do have a concern about the kernel page tables not being
> >> synchronized into trampoline_pg_dir (it's only an issue for 32-bit
> >> !PAE), so at the very least we need to keep an eye out for it...
> > 
> > I've been working on what you suggested and the patch boots on a 32-bit
> > PAE kernel but keeps rebooting on non-PAE after setting the stack_start
> > on the AP. I could send it out later for you to look at, if you like -
> > you should be able to spot what I'm missing :)...
> > 
> 
> Sounds good.  This is obviously .37-or-higher material.

Definitely, this needs a lot of hammering before going upstream.

So here's what I got so far, I went and changed everything called
swapper_* when used to prep the initial page table to initial_*. Then
in setup_arch I switch to the swapper_pg_dir after copying the kernel
address mappings into it so all other places touching swapper_pg_dir can
remain unchanged. Then, initial_page_table is still used for booting the
APs.

The nice effect is that we drop all that swsusp_pg_dir for ACPI_SLEEP
and unifying the do_boot_cpu() part of start_secondary() even more.

So this boots fine on 32-bit PAE but reboots the machine on !PAE when
the AP does

	/* Set up the stack pointer */
	lss stack_start,%esp

	pushl $0
	popfl

in head_32.S. I've debugged this by adding endless loops in the manner of 

@@@ -274,6 -274,6 +274,7 @@@ ENTRY(startup_32_smp
        movl %eax,%es
        movl %eax,%fs
        movl %eax,%gs
+      movl $0xdeadbeef, %ebx
  #endif /* CONFIG_SMP */

so that this happens only on the AP and then did

+667:
+      cmpl $0xdeadbeef, %ebx
+      je 667b
+

So when the loop is before the "pushl.. popfl" sequence above, the
BSP would print "CPU stuck??" for the AP and continue booting by not
bringing the AP online. If I put the endless loop after that sequence,
the machine reboots. This is also nicely reproducible in kvm for even
faster and safer experimenting with the code.


Thanks.

--
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
index 2984a25..8abde9e 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -26,6 +26,7 @@ struct mm_struct;
 struct vm_area_struct;
 
 extern pgd_t swapper_pg_dir[1024];
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
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index fcc3c61..48d89d6 100644
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
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 37c3d4b..80b0961 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -177,7 +177,7 @@ default_entry:
 #ifdef CONFIG_X86_PAE
 
 	/*
-	 * In PAE mode swapper_pg_dir is statically defined to contain enough
+	 * In PAE mode initial_page_table is statically defined to contain enough
 	 * entries to cover the VMSPLIT option (that is the top 1, 2 or 3
 	 * entries). The identity mapping is handled by pointing two PGD
 	 * entries to the first kernel PMD.
@@ -191,7 +191,7 @@ default_entry:
 	xorl %ebx,%ebx				/* %ebx is kept at zero */
 
 	movl $pa(__brk_base), %edi
-	movl $pa(swapper_pg_pmd), %edx
+	movl $pa(initial_pg_pmd), %edx
 	movl $PTE_IDENT_ATTR, %eax
 10:
 	leal PDE_IDENT_ATTR(%edi),%ecx		/* Create PMD entry */
@@ -220,14 +220,14 @@ default_entry:
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
@@ -251,8 +251,8 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	movl %eax, pa(max_pfn_mapped)
 
 	/* Do early initialization of the fixmap area */
-	movl $pa(swapper_pg_fixmap)+PDE_IDENT_ATTR,%eax
-	movl %eax,pa(swapper_pg_dir+0xffc)
+	movl $pa(initial_pg_fixmap)+PDE_IDENT_ATTR,%eax
+	movl %eax,pa(initial_page_table+0xffc)
 #endif
 	jmp 3f
 /*
@@ -328,7 +328,7 @@ ENTRY(startup_32_smp)
 /*
  * Enable paging
  */
-	movl $pa(swapper_pg_dir),%eax
+	movl $pa(initial_page_table),%eax
 	movl %eax,%cr3		/* set the page table pointer.. */
 	movl %cr0,%eax
 	orl  $X86_CR0_PG,%eax
@@ -615,16 +615,18 @@ ENTRY(initial_code)
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
 ENTRY(empty_zero_page)
 	.fill 4096,1,0
+ENTRY(swapper_pg_dir)
+	.fill 1024,4,0
 
 /*
  * This starts the data section.
@@ -633,20 +635,20 @@ ENTRY(empty_zero_page)
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
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b4ae4ac..ba19c9e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -727,6 +727,15 @@ void __init setup_arch(char **cmdline_p)
 	int k8 = 0;
 
 #ifdef CONFIG_X86_32
+       /* Copy kernel address range */
+       clone_pgd_range(swapper_pg_dir + KERNEL_PGD_BOUNDARY,
+                       initial_page_table + KERNEL_PGD_BOUNDARY,
+                       min_t(unsigned long, KERNEL_PGD_PTRS,
+                             KERNEL_PGD_BOUNDARY));
+
+       load_cr3(swapper_pg_dir);
+       __flush_tlb_all();
+
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
 #else
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c4f33b2..d1bd555 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -73,7 +73,6 @@
 
 #ifdef CONFIG_X86_32
 u8 apicid_2_node[MAX_APICID];
-static int low_mappings;
 #endif
 
 /* State of each CPU */
@@ -300,8 +299,7 @@ notrace static void __cpuinit start_secondary(void *unused)
 	}
 
 #ifdef CONFIG_X86_32
-	while (low_mappings)
-		cpu_relax();
+	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
 #endif
 
@@ -894,20 +892,7 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 
-#ifdef CONFIG_X86_32
-	/* init low mem mapping */
-	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + KERNEL_PGD_BOUNDARY,
-		min_t(unsigned long, KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
-	flush_tlb_all();
-	low_mappings = 1;
-
 	err = do_boot_cpu(apicid, cpu);
-
-	zap_low_mappings(false);
-	low_mappings = 0;
-#else
-	err = do_boot_cpu(apicid, cpu);
-#endif
 	if (err) {
 		pr_debug("do_boot_cpu failed %d\n", err);
 		return -EIO;
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
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
