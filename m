Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161944Ab2CSQPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:15:33 -0400
Received: from mail-wi0-f194.google.com ([209.85.212.194]:58314 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031924Ab2CSQP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:15:26 -0400
Date: Mon, 19 Mar 2012 17:15:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm changes for v3.4
Message-ID: <20120319161521.GA7950@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-asm-for-linus

   HEAD: a240ada241dafe290e7532d1ddeb98fdf1419068 x86: Include probe_roms.h in probe_roms.c


out-of-topic modifications in x86-asm-for-linus:
------------------------------------------------
include/asm-generic/getorder.h     # b893485: bitops: Add missing parentheses t
                                   # d66acc3: bitops: Optimise get_order()
                                   # e0891a9: bitops: Adjust the comment on get

 Thanks,

	Ingo

------------------>
Alex Shi (1):
      x86/numa: Improve internode cache alignment

David Howells (2):
      bitops: Adjust the comment on get_order() to describe the size==0 case
      bitops: Optimise get_order()

Jan Beulich (10):
      x86-64: Slightly shorten copy_page()
      x86-64: Fix memset() to support sizes of 4Gb and above
      x86-64: Fix memcpy() to support sizes of 4Gb and above
      x86-64: Handle byte-wise tail copying in memcpy() without a loop
      x86/spinlocks: Eliminate TICKET_MASK
      x86-64: Fix CFI annotations for NMI nesting code
      x86-64: Improve insn scheduling in SAVE_ARGS_IRQ
      x86: Tighten dependencies of CPU_SUP_*_32
      x86/32: Print control and debug registers for kerenel context
      x86: Include probe_roms.h in probe_roms.c

Joerg Roedel (1):
      bitops: Add missing parentheses to new get_order macro

Steven Rostedt (1):
      x86: Fix the NMI nesting comments


 arch/x86/Kconfig.cpu                  |    5 +-
 arch/x86/include/asm/spinlock.h       |    4 +-
 arch/x86/include/asm/spinlock_types.h |    1 -
 arch/x86/kernel/dumpstack_32.c        |    2 +-
 arch/x86/kernel/entry_64.S            |   71 +++++++++++++++++---------------
 arch/x86/kernel/probe_roms.c          |    1 +
 arch/x86/lib/copy_page_64.S           |   12 ++----
 arch/x86/lib/memcpy_64.S              |   44 +++++++++-----------
 arch/x86/lib/memset_64.S              |   33 +++++++--------
 include/asm-generic/getorder.h        |   53 +++++++++++++++++++++----
 10 files changed, 128 insertions(+), 98 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 3c57033..706e12e 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -303,7 +303,6 @@ config X86_GENERIC
 config X86_INTERNODE_CACHE_SHIFT
 	int
 	default "12" if X86_VSMP
-	default "7" if NUMA
 	default X86_L1_CACHE_SHIFT
 
 config X86_CMPXCHG
@@ -441,7 +440,7 @@ config CPU_SUP_INTEL
 config CPU_SUP_CYRIX_32
 	default y
 	bool "Support Cyrix processors" if PROCESSOR_SELECT
-	depends on !64BIT
+	depends on M386 || M486 || M586 || M586TSC || M586MMX || (EXPERT && !64BIT)
 	---help---
 	  This enables detection, tunings and quirks for Cyrix processors
 
@@ -495,7 +494,7 @@ config CPU_SUP_TRANSMETA_32
 config CPU_SUP_UMC_32
 	default y
 	bool "Support UMC processors" if PROCESSOR_SELECT
-	depends on !64BIT
+	depends on M386 || M486 || (EXPERT && !64BIT)
 	---help---
 	  This enables detection, tunings and quirks for UMC processors
 
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index a82c2bf..76bfa2c 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -88,14 +88,14 @@ static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
 {
 	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
-	return !!(tmp.tail ^ tmp.head);
+	return tmp.tail != tmp.head;
 }
 
 static inline int __ticket_spin_is_contended(arch_spinlock_t *lock)
 {
 	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
-	return ((tmp.tail - tmp.head) & TICKET_MASK) > 1;
+	return (__ticket_t)(tmp.tail - tmp.head) > 1;
 }
 
 #ifndef CONFIG_PARAVIRT_SPINLOCKS
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 8ebd5df..ad0ad07 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -16,7 +16,6 @@ typedef u32 __ticketpair_t;
 #endif
 
 #define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
-#define TICKET_MASK	((__ticket_t)((1 << TICKET_SHIFT) - 1))
 
 typedef struct arch_spinlock {
 	union {
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index c99f9ed..88ec912 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -87,7 +87,7 @@ void show_registers(struct pt_regs *regs)
 	int i;
 
 	print_modules();
-	__show_regs(regs, 0);
+	__show_regs(regs, !user_mode_vm(regs));
 
 	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)\n",
 		TASK_COMM_LEN, current->comm, task_pid_nr(current),
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1333d98..a63dabe 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -320,7 +320,7 @@ ENDPROC(native_usergs_sysret64)
 	movq %rsp, %rsi
 
 	leaq -RBP(%rsp),%rdi	/* arg1 for handler */
-	testl $3, CS(%rdi)
+	testl $3, CS-RBP(%rsi)
 	je 1f
 	SWAPGS
 	/*
@@ -330,11 +330,10 @@ ENDPROC(native_usergs_sysret64)
 	 * moving irq_enter into assembly, which would be too much work)
 	 */
 1:	incl PER_CPU_VAR(irq_count)
-	jne 2f
-	mov PER_CPU_VAR(irq_stack_ptr),%rsp
+	cmovzq PER_CPU_VAR(irq_stack_ptr),%rsp
 	CFI_DEF_CFA_REGISTER	rsi
 
-2:	/* Store previous stack value */
+	/* Store previous stack value */
 	pushq %rsi
 	CFI_ESCAPE	0x0f /* DW_CFA_def_cfa_expression */, 6, \
 			0x77 /* DW_OP_breg7 */, 0, \
@@ -1530,6 +1529,7 @@ ENTRY(nmi)
 
 	/* Use %rdx as out temp variable throughout */
 	pushq_cfi %rdx
+	CFI_REL_OFFSET rdx, 0
 
 	/*
 	 * If %cs was not the kernel segment, then the NMI triggered in user
@@ -1554,6 +1554,7 @@ ENTRY(nmi)
 	 */
 	lea 6*8(%rsp), %rdx
 	test_in_nmi rdx, 4*8(%rsp), nested_nmi, first_nmi
+	CFI_REMEMBER_STATE
 
 nested_nmi:
 	/*
@@ -1585,10 +1586,12 @@ nested_nmi:
 
 nested_nmi_out:
 	popq_cfi %rdx
+	CFI_RESTORE rdx
 
 	/* No need to check faults here */
 	INTERRUPT_RETURN
 
+	CFI_RESTORE_STATE
 first_nmi:
 	/*
 	 * Because nested NMIs will use the pushed location that we
@@ -1620,10 +1623,15 @@ first_nmi:
 	 * | pt_regs                 |
 	 * +-------------------------+
 	 *
-	 * The saved RIP is used to fix up the copied RIP that a nested
-	 * NMI may zero out. The original stack frame and the temp storage
+	 * The saved stack frame is used to fix up the copied stack frame
+	 * that a nested NMI may change to make the interrupted NMI iret jump
+	 * to the repeat_nmi. The original stack frame and the temp storage
 	 * is also used by nested NMIs and can not be trusted on exit.
 	 */
+	/* Do not pop rdx, nested NMIs will corrupt that part of the stack */
+	movq (%rsp), %rdx
+	CFI_RESTORE rdx
+
 	/* Set the NMI executing variable on the stack. */
 	pushq_cfi $1
 
@@ -1631,22 +1639,39 @@ first_nmi:
 	.rept 5
 	pushq_cfi 6*8(%rsp)
 	.endr
+	CFI_DEF_CFA_OFFSET SS+8-RIP
+
+	/* Everything up to here is safe from nested NMIs */
+
+	/*
+	 * If there was a nested NMI, the first NMI's iret will return
+	 * here. But NMIs are still enabled and we can take another
+	 * nested NMI. The nested NMI checks the interrupted RIP to see
+	 * if it is between repeat_nmi and end_repeat_nmi, and if so
+	 * it will just return, as we are about to repeat an NMI anyway.
+	 * This makes it safe to copy to the stack frame that a nested
+	 * NMI will update.
+	 */
+repeat_nmi:
+	/*
+	 * Update the stack variable to say we are still in NMI (the update
+	 * is benign for the non-repeat case, where 1 was pushed just above
+	 * to this very stack slot).
+	 */
+	movq $1, 5*8(%rsp)
 
 	/* Make another copy, this one may be modified by nested NMIs */
 	.rept 5
 	pushq_cfi 4*8(%rsp)
 	.endr
-
-	/* Do not pop rdx, nested NMIs will corrupt it */
-	movq 11*8(%rsp), %rdx
+	CFI_DEF_CFA_OFFSET SS+8-RIP
+end_repeat_nmi:
 
 	/*
 	 * Everything below this point can be preempted by a nested
-	 * NMI if the first NMI took an exception. Repeated NMIs
-	 * caused by an exception and nested NMI will start here, and
-	 * can still be preempted by another NMI.
+	 * NMI if the first NMI took an exception and reset our iret stack
+	 * so that we repeat another NMI.
 	 */
-restart_nmi:
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
@@ -1675,26 +1700,6 @@ nmi_restore:
 	CFI_ENDPROC
 END(nmi)
 
-	/*
-	 * If an NMI hit an iret because of an exception or breakpoint,
-	 * it can lose its NMI context, and a nested NMI may come in.
-	 * In that case, the nested NMI will change the preempted NMI's
-	 * stack to jump to here when it does the final iret.
-	 */
-repeat_nmi:
-	INTR_FRAME
-	/* Update the stack variable to say we are still in NMI */
-	movq $1, 5*8(%rsp)
-
-	/* copy the saved stack back to copy stack */
-	.rept 5
-	pushq_cfi 4*8(%rsp)
-	.endr
-
-	jmp restart_nmi
-	CFI_ENDPROC
-end_repeat_nmi:
-
 ENTRY(ignore_sysret)
 	CFI_STARTPROC
 	mov $-ENOSYS,%eax
diff --git a/arch/x86/kernel/probe_roms.c b/arch/x86/kernel/probe_roms.c
index 34e06e8..0bc72e2 100644
--- a/arch/x86/kernel/probe_roms.c
+++ b/arch/x86/kernel/probe_roms.c
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/export.h>
 
+#include <asm/probe_roms.h>
 #include <asm/pci-direct.h>
 #include <asm/e820.h>
 #include <asm/mmzone.h>
diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
index 01c805b..6b34d04 100644
--- a/arch/x86/lib/copy_page_64.S
+++ b/arch/x86/lib/copy_page_64.S
@@ -20,14 +20,12 @@ ENDPROC(copy_page_c)
 
 ENTRY(copy_page)
 	CFI_STARTPROC
-	subq	$3*8,%rsp
-	CFI_ADJUST_CFA_OFFSET 3*8
+	subq	$2*8,%rsp
+	CFI_ADJUST_CFA_OFFSET 2*8
 	movq	%rbx,(%rsp)
 	CFI_REL_OFFSET rbx, 0
 	movq	%r12,1*8(%rsp)
 	CFI_REL_OFFSET r12, 1*8
-	movq	%r13,2*8(%rsp)
-	CFI_REL_OFFSET r13, 2*8
 
 	movl	$(4096/64)-5,%ecx
 	.p2align 4
@@ -91,10 +89,8 @@ ENTRY(copy_page)
 	CFI_RESTORE rbx
 	movq	1*8(%rsp),%r12
 	CFI_RESTORE r12
-	movq	2*8(%rsp),%r13
-	CFI_RESTORE r13
-	addq	$3*8,%rsp
-	CFI_ADJUST_CFA_OFFSET -3*8
+	addq	$2*8,%rsp
+	CFI_ADJUST_CFA_OFFSET -2*8
 	ret
 .Lcopy_page_end:
 	CFI_ENDPROC
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index efbf2a0..1c273be 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -27,9 +27,8 @@
 	.section .altinstr_replacement, "ax", @progbits
 .Lmemcpy_c:
 	movq %rdi, %rax
-
-	movl %edx, %ecx
-	shrl $3, %ecx
+	movq %rdx, %rcx
+	shrq $3, %rcx
 	andl $7, %edx
 	rep movsq
 	movl %edx, %ecx
@@ -48,8 +47,7 @@
 	.section .altinstr_replacement, "ax", @progbits
 .Lmemcpy_c_e:
 	movq %rdi, %rax
-
-	movl %edx, %ecx
+	movq %rdx, %rcx
 	rep movsb
 	ret
 .Lmemcpy_e_e:
@@ -60,10 +58,7 @@ ENTRY(memcpy)
 	CFI_STARTPROC
 	movq %rdi, %rax
 
-	/*
-	 * Use 32bit CMP here to avoid long NOP padding.
-	 */
-	cmp  $0x20, %edx
+	cmpq $0x20, %rdx
 	jb .Lhandle_tail
 
 	/*
@@ -72,7 +67,7 @@ ENTRY(memcpy)
 	 */
 	cmp  %dil, %sil
 	jl .Lcopy_backward
-	subl $0x20, %edx
+	subq $0x20, %rdx
 .Lcopy_forward_loop:
 	subq $0x20,	%rdx
 
@@ -91,7 +86,7 @@ ENTRY(memcpy)
 	movq %r11,	3*8(%rdi)
 	leaq 4*8(%rdi),	%rdi
 	jae  .Lcopy_forward_loop
-	addq $0x20,	%rdx
+	addl $0x20,	%edx
 	jmp  .Lhandle_tail
 
 .Lcopy_backward:
@@ -123,11 +118,11 @@ ENTRY(memcpy)
 	/*
 	 * Calculate copy position to head.
 	 */
-	addq $0x20,	%rdx
+	addl $0x20,	%edx
 	subq %rdx,	%rsi
 	subq %rdx,	%rdi
 .Lhandle_tail:
-	cmpq $16,	%rdx
+	cmpl $16,	%edx
 	jb   .Lless_16bytes
 
 	/*
@@ -144,7 +139,7 @@ ENTRY(memcpy)
 	retq
 	.p2align 4
 .Lless_16bytes:
-	cmpq $8,	%rdx
+	cmpl $8,	%edx
 	jb   .Lless_8bytes
 	/*
 	 * Move data from 8 bytes to 15 bytes.
@@ -156,7 +151,7 @@ ENTRY(memcpy)
 	retq
 	.p2align 4
 .Lless_8bytes:
-	cmpq $4,	%rdx
+	cmpl $4,	%edx
 	jb   .Lless_3bytes
 
 	/*
@@ -169,18 +164,19 @@ ENTRY(memcpy)
 	retq
 	.p2align 4
 .Lless_3bytes:
-	cmpl $0, %edx
-	je .Lend
+	subl $1, %edx
+	jb .Lend
 	/*
 	 * Move data from 1 bytes to 3 bytes.
 	 */
-.Lloop_1:
-	movb (%rsi), %r8b
-	movb %r8b, (%rdi)
-	incq %rdi
-	incq %rsi
-	decl %edx
-	jnz .Lloop_1
+	movzbl (%rsi), %ecx
+	jz .Lstore_1byte
+	movzbq 1(%rsi), %r8
+	movzbq (%rsi, %rdx), %r9
+	movb %r8b, 1(%rdi)
+	movb %r9b, (%rdi, %rdx)
+.Lstore_1byte:
+	movb %cl, (%rdi)
 
 .Lend:
 	retq
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 79bd454..2dcb380 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -19,16 +19,15 @@
 	.section .altinstr_replacement, "ax", @progbits
 .Lmemset_c:
 	movq %rdi,%r9
-	movl %edx,%r8d
-	andl $7,%r8d
-	movl %edx,%ecx
-	shrl $3,%ecx
+	movq %rdx,%rcx
+	andl $7,%edx
+	shrq $3,%rcx
 	/* expand byte value  */
 	movzbl %sil,%esi
 	movabs $0x0101010101010101,%rax
-	mulq %rsi		/* with rax, clobbers rdx */
+	imulq %rsi,%rax
 	rep stosq
-	movl %r8d,%ecx
+	movl %edx,%ecx
 	rep stosb
 	movq %r9,%rax
 	ret
@@ -50,7 +49,7 @@
 .Lmemset_c_e:
 	movq %rdi,%r9
 	movb %sil,%al
-	movl %edx,%ecx
+	movq %rdx,%rcx
 	rep stosb
 	movq %r9,%rax
 	ret
@@ -61,12 +60,11 @@ ENTRY(memset)
 ENTRY(__memset)
 	CFI_STARTPROC
 	movq %rdi,%r10
-	movq %rdx,%r11
 
 	/* expand byte value  */
 	movzbl %sil,%ecx
 	movabs $0x0101010101010101,%rax
-	mul    %rcx		/* with rax, clobbers rdx */
+	imulq  %rcx,%rax
 
 	/* align dst */
 	movl  %edi,%r9d
@@ -75,13 +73,13 @@ ENTRY(__memset)
 	CFI_REMEMBER_STATE
 .Lafter_bad_alignment:
 
-	movl %r11d,%ecx
-	shrl $6,%ecx
+	movq  %rdx,%rcx
+	shrq  $6,%rcx
 	jz	 .Lhandle_tail
 
 	.p2align 4
 .Lloop_64:
-	decl   %ecx
+	decq  %rcx
 	movq  %rax,(%rdi)
 	movq  %rax,8(%rdi)
 	movq  %rax,16(%rdi)
@@ -97,7 +95,7 @@ ENTRY(__memset)
 	   to predict jump tables. */
 	.p2align 4
 .Lhandle_tail:
-	movl	%r11d,%ecx
+	movl	%edx,%ecx
 	andl    $63&(~7),%ecx
 	jz 		.Lhandle_7
 	shrl	$3,%ecx
@@ -109,12 +107,11 @@ ENTRY(__memset)
 	jnz    .Lloop_8
 
 .Lhandle_7:
-	movl	%r11d,%ecx
-	andl	$7,%ecx
+	andl	$7,%edx
 	jz      .Lende
 	.p2align 4
 .Lloop_1:
-	decl    %ecx
+	decl    %edx
 	movb 	%al,(%rdi)
 	leaq	1(%rdi),%rdi
 	jnz     .Lloop_1
@@ -125,13 +122,13 @@ ENTRY(__memset)
 
 	CFI_RESTORE_STATE
 .Lbad_alignment:
-	cmpq $7,%r11
+	cmpq $7,%rdx
 	jbe	.Lhandle_7
 	movq %rax,(%rdi)	/* unaligned store */
 	movq $8,%r8
 	subq %r9,%r8
 	addq %r8,%rdi
-	subq %r8,%r11
+	subq %r8,%rdx
 	jmp .Lafter_bad_alignment
 .Lfinal:
 	CFI_ENDPROC
diff --git a/include/asm-generic/getorder.h b/include/asm-generic/getorder.h
index 67e7245..65e4468 100644
--- a/include/asm-generic/getorder.h
+++ b/include/asm-generic/getorder.h
@@ -4,21 +4,58 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/compiler.h>
+#include <linux/log2.h>
 
-/* Pure 2^n version of get_order */
-static inline __attribute_const__ int get_order(unsigned long size)
+/*
+ * Runtime evaluation of get_order()
+ */
+static inline __attribute_const__
+int __get_order(unsigned long size)
 {
 	int order;
 
-	size = (size - 1) >> (PAGE_SHIFT - 1);
-	order = -1;
-	do {
-		size >>= 1;
-		order++;
-	} while (size);
+	size--;
+	size >>= PAGE_SHIFT;
+#if BITS_PER_LONG == 32
+	order = fls(size);
+#else
+	order = fls64(size);
+#endif
 	return order;
 }
 
+/**
+ * get_order - Determine the allocation order of a memory size
+ * @size: The size for which to get the order
+ *
+ * Determine the allocation order of a particular sized block of memory.  This
+ * is on a logarithmic scale, where:
+ *
+ *	0 -> 2^0 * PAGE_SIZE and below
+ *	1 -> 2^1 * PAGE_SIZE to 2^0 * PAGE_SIZE + 1
+ *	2 -> 2^2 * PAGE_SIZE to 2^1 * PAGE_SIZE + 1
+ *	3 -> 2^3 * PAGE_SIZE to 2^2 * PAGE_SIZE + 1
+ *	4 -> 2^4 * PAGE_SIZE to 2^3 * PAGE_SIZE + 1
+ *	...
+ *
+ * The order returned is used to find the smallest allocation granule required
+ * to hold an object of the specified size.
+ *
+ * The result is undefined if the size is 0.
+ *
+ * This function may be used to initialise variables with compile time
+ * evaluations of constants.
+ */
+#define get_order(n)						\
+(								\
+	__builtin_constant_p(n) ? (				\
+		((n) == 0UL) ? BITS_PER_LONG - PAGE_SHIFT :	\
+		(((n) < (1UL << PAGE_SHIFT)) ? 0 :		\
+		 ilog2((n) - 1) - PAGE_SHIFT + 1)		\
+	) :							\
+	__get_order(n)						\
+)
+
 #endif	/* __ASSEMBLY__ */
 
 #endif	/* __ASM_GENERIC_GETORDER_H */
