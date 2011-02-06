Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1BFLSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 06:18:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37048 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310Ab1BFLSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 06:18:15 -0500
Date: Sun, 6 Feb 2011 12:18:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110206111806.GA24482@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86-32: Make sure the stack is set up before we use it

Matthieu CASTET (1):
      x86, nx: Don't force pages RW when setting NX bits

Suresh Siddha (1):
      x86, mtrr: Avoid MTRR reprogramming on BP during boot on UP platforms


 arch/x86/include/asm/smp.h      |    5 +----
 arch/x86/kernel/acpi/sleep.c    |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c |   10 +++++++++-
 arch/x86/kernel/head_32.S       |   30 +++++++++++++-----------------
 arch/x86/kernel/smpboot.c       |    4 ++--
 arch/x86/mm/pageattr.c          |    8 --------
 6 files changed, 26 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 4c2f63c..1f46951 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -40,10 +40,7 @@ DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
 DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
 
 /* Static state in head.S used to set up a CPU */
-extern struct {
-	void *sp;
-	unsigned short ss;
-} stack_start;
+extern unsigned long stack_start; /* Initial stack pointer address */
 
 struct smp_ops {
 	void (*smp_prepare_boot_cpu)(void);
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 69fd72a..4d9ebba 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -100,7 +100,7 @@ int acpi_save_state_mem(void)
 #else /* CONFIG_64BIT */
 	header->trampoline_segment = setup_trampoline() >> 4;
 #ifdef CONFIG_SMP
-	stack_start.sp = temp_stack + sizeof(temp_stack);
+	stack_start = (unsigned long)temp_stack + sizeof(temp_stack);
 	early_gdt_descr.address =
 			(unsigned long)get_cpu_gdt_table(smp_processor_id());
 	initial_gs = per_cpu_offset(smp_processor_id());
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 01c0f3e..bebabec 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -793,13 +793,21 @@ void set_mtrr_aps_delayed_init(void)
 }
 
 /*
- * MTRR initialization for all AP's
+ * Delayed MTRR initialization for all AP's
  */
 void mtrr_aps_init(void)
 {
 	if (!use_intel())
 		return;
 
+	/*
+	 * Check if someone has requested the delay of AP MTRR initialization,
+	 * by doing set_mtrr_aps_delayed_init(), prior to this point. If not,
+	 * then we are done.
+	 */
+	if (!mtrr_aps_delayed_init)
+		return;
+
 	set_mtrr(~0U, 0, 0, 0);
 	mtrr_aps_delayed_init = false;
 }
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index fc293dc..767d6c4 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -85,6 +85,8 @@ RESERVE_BRK(pagetables, INIT_MAP_SIZE)
  */
 __HEAD
 ENTRY(startup_32)
+	movl pa(stack_start),%ecx
+	
 	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
 		us to not reload segments */
 	testb $(1<<6), BP_loadflags(%esi)
@@ -99,7 +101,9 @@ ENTRY(startup_32)
 	movl %eax,%es
 	movl %eax,%fs
 	movl %eax,%gs
+	movl %eax,%ss
 2:
+	leal -__PAGE_OFFSET(%ecx),%esp
 
 /*
  * Clear BSS first so that there are no surprises...
@@ -145,8 +149,6 @@ ENTRY(startup_32)
  * _brk_end is set up to point to the first "safe" location.
  * Mappings are created both at virtual address 0 (identity mapping)
  * and PAGE_OFFSET for up to _end.
- *
- * Note that the stack is not yet set up!
  */
 #ifdef CONFIG_X86_PAE
 
@@ -282,6 +284,9 @@ ENTRY(startup_32_smp)
 	movl %eax,%es
 	movl %eax,%fs
 	movl %eax,%gs
+	movl pa(stack_start),%ecx
+	movl %eax,%ss
+	leal -__PAGE_OFFSET(%ecx),%esp
 #endif /* CONFIG_SMP */
 default_entry:
 
@@ -347,8 +352,8 @@ default_entry:
 	movl %eax,%cr0		/* ..and set paging (PG) bit */
 	ljmp $__BOOT_CS,$1f	/* Clear prefetch and normalize %eip */
 1:
-	/* Set up the stack pointer */
-	lss stack_start,%esp
+	/* Shift the stack pointer to a virtual address */
+	addl $__PAGE_OFFSET, %esp
 
 /*
  * Initialize eflags.  Some BIOS's leave bits like NT set.  This would
@@ -360,9 +365,7 @@ default_entry:
 
 #ifdef CONFIG_SMP
 	cmpb $0, ready
-	jz  1f				/* Initial CPU cleans BSS */
-	jmp checkCPUtype
-1:
+	jnz checkCPUtype
 #endif /* CONFIG_SMP */
 
 /*
@@ -470,14 +473,7 @@ is386:	movl $2,%ecx		# set MP
 
 	cld			# gcc2 wants the direction flag cleared at all times
 	pushl $0		# fake return address for unwinder
-#ifdef CONFIG_SMP
-	movb ready, %cl
 	movb $1, ready
-	cmpb $0,%cl		# the first CPU calls start_kernel
-	je   1f
-	movl (stack_start), %esp
-1:
-#endif /* CONFIG_SMP */
 	jmp *(initial_code)
 
 /*
@@ -670,15 +666,15 @@ ENTRY(initial_page_table)
 #endif
 
 .data
+.balign 4
 ENTRY(stack_start)
 	.long init_thread_union+THREAD_SIZE
-	.long __BOOT_DS
-
-ready:	.byte 0
 
 early_recursion_flag:
 	.long 0
 
+ready:	.byte 0
+
 int_msg:
 	.asciz "Unknown interrupt or fault at: %p %p %p\n"
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 0cbe8c0..03273b6 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -638,7 +638,7 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 	 * target processor state.
 	 */
 	startup_ipi_hook(phys_apicid, (unsigned long) start_secondary,
-			 (unsigned long)stack_start.sp);
+			 stack_start);
 
 	/*
 	 * Run STARTUP IPI loop.
@@ -785,7 +785,7 @@ do_rest:
 #endif
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	initial_code = (unsigned long)start_secondary;
-	stack_start.sp = (void *) c_idle.idle->thread.sp;
+	stack_start  = c_idle.idle->thread.sp;
 
 	/* start_ip had better be page-aligned! */
 	start_ip = setup_trampoline();
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 8b830ca..d343b3c 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -256,7 +256,6 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 				   unsigned long pfn)
 {
 	pgprot_t forbidden = __pgprot(0);
-	pgprot_t required = __pgprot(0);
 
 	/*
 	 * The BIOS area between 640k and 1Mb needs to be executable for
@@ -282,12 +281,6 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	if (within(pfn, __pa((unsigned long)__start_rodata) >> PAGE_SHIFT,
 		   __pa((unsigned long)__end_rodata) >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_RW;
-	/*
-	 * .data and .bss should always be writable.
-	 */
-	if (within(address, (unsigned long)_sdata, (unsigned long)_edata) ||
-	    within(address, (unsigned long)__bss_start, (unsigned long)__bss_stop))
-		pgprot_val(required) |= _PAGE_RW;
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
 	/*
@@ -327,7 +320,6 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 #endif
 
 	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
-	prot = __pgprot(pgprot_val(prot) | pgprot_val(required));
 
 	return prot;
 }
