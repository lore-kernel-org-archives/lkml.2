Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab2LKKGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 05:06:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48390 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2LKKGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 05:06:51 -0500
Date: Tue, 11 Dec 2012 11:06:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm changes for v3.8
Message-ID: <20121211100646.GA24919@gmail.com>
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

   HEAD: 6c8d8b3c69cef1330e0c5cbc2a8b9268024927a0 x86_32: Return actual stack when requesting sp from regs

Two fixlets and a cleanup.

 Thanks,

	Ingo

------------------>
Ma Ling (1):
      x86/asm: Clean up copy_page_*() comments and code

Salman Qazi (1):
      x86: Don't clobber top of pt_regs in nested NMI

Steven Rostedt (1):
      x86_32: Return actual stack when requesting sp from regs


 arch/x86/include/asm/ptrace.h |   9 ++++
 arch/x86/kernel/entry_64.S    |  41 ++++++++++-----
 arch/x86/lib/copy_page_64.S   | 120 +++++++++++++++++++++---------------------
 3 files changed, 95 insertions(+), 75 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index dcfde52..2233713 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -246,6 +246,15 @@ static inline unsigned long regs_get_register(struct pt_regs *regs,
 {
 	if (unlikely(offset > MAX_REG_OFFSET))
 		return 0;
+#ifdef CONFIG_X86_32
+	/*
+	 * Traps from the kernel do not save sp and ss.
+	 * Use the helper function to retrieve sp.
+	 */
+	if (offset == offsetof(struct pt_regs, sp) &&
+	    regs->cs == __KERNEL_CS)
+		return kernel_stack_pointer(regs);
+#endif
 	return *(unsigned long *)((unsigned long)regs + offset);
 }
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b51b2c7..811795d 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1699,9 +1699,10 @@ nested_nmi:
 
 1:
 	/* Set up the interrupted NMIs stack to jump to repeat_nmi */
-	leaq -6*8(%rsp), %rdx
+	leaq -1*8(%rsp), %rdx
 	movq %rdx, %rsp
-	CFI_ADJUST_CFA_OFFSET 6*8
+	CFI_ADJUST_CFA_OFFSET 1*8
+	leaq -10*8(%rsp), %rdx
 	pushq_cfi $__KERNEL_DS
 	pushq_cfi %rdx
 	pushfq_cfi
@@ -1709,8 +1710,8 @@ nested_nmi:
 	pushq_cfi $repeat_nmi
 
 	/* Put stack back */
-	addq $(11*8), %rsp
-	CFI_ADJUST_CFA_OFFSET -11*8
+	addq $(6*8), %rsp
+	CFI_ADJUST_CFA_OFFSET -6*8
 
 nested_nmi_out:
 	popq_cfi %rdx
@@ -1736,18 +1737,18 @@ first_nmi:
 	 * +-------------------------+
 	 * | NMI executing variable  |
 	 * +-------------------------+
-	 * | Saved SS                |
-	 * | Saved Return RSP        |
-	 * | Saved RFLAGS            |
-	 * | Saved CS                |
-	 * | Saved RIP               |
-	 * +-------------------------+
 	 * | copied SS               |
 	 * | copied Return RSP       |
 	 * | copied RFLAGS           |
 	 * | copied CS               |
 	 * | copied RIP              |
 	 * +-------------------------+
+	 * | Saved SS                |
+	 * | Saved Return RSP        |
+	 * | Saved RFLAGS            |
+	 * | Saved CS                |
+	 * | Saved RIP               |
+	 * +-------------------------+
 	 * | pt_regs                 |
 	 * +-------------------------+
 	 *
@@ -1763,9 +1764,14 @@ first_nmi:
 	/* Set the NMI executing variable on the stack. */
 	pushq_cfi $1
 
+	/*
+	 * Leave room for the "copied" frame
+	 */
+	subq $(5*8), %rsp
+
 	/* Copy the stack frame to the Saved frame */
 	.rept 5
-	pushq_cfi 6*8(%rsp)
+	pushq_cfi 11*8(%rsp)
 	.endr
 	CFI_DEF_CFA_OFFSET SS+8-RIP
 
@@ -1786,12 +1792,15 @@ repeat_nmi:
 	 * is benign for the non-repeat case, where 1 was pushed just above
 	 * to this very stack slot).
 	 */
-	movq $1, 5*8(%rsp)
+	movq $1, 10*8(%rsp)
 
 	/* Make another copy, this one may be modified by nested NMIs */
+	addq $(10*8), %rsp
+	CFI_ADJUST_CFA_OFFSET -10*8
 	.rept 5
-	pushq_cfi 4*8(%rsp)
+	pushq_cfi -6*8(%rsp)
 	.endr
+	subq $(5*8), %rsp
 	CFI_DEF_CFA_OFFSET SS+8-RIP
 end_repeat_nmi:
 
@@ -1842,8 +1851,12 @@ nmi_swapgs:
 	SWAPGS_UNSAFE_STACK
 nmi_restore:
 	RESTORE_ALL 8
+
+	/* Pop the extra iret frame */
+	addq $(5*8), %rsp
+
 	/* Clear the NMI executing stack variable */
-	movq $0, 10*8(%rsp)
+	movq $0, 5*8(%rsp)
 	jmp irq_return
 	CFI_ENDPROC
 END(nmi)
diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
index 6b34d04..176cca6 100644
--- a/arch/x86/lib/copy_page_64.S
+++ b/arch/x86/lib/copy_page_64.S
@@ -5,91 +5,89 @@
 #include <asm/alternative-asm.h>
 
 	ALIGN
-copy_page_c:
+copy_page_rep:
 	CFI_STARTPROC
-	movl $4096/8,%ecx
-	rep movsq
+	movl	$4096/8, %ecx
+	rep	movsq
 	ret
 	CFI_ENDPROC
-ENDPROC(copy_page_c)
+ENDPROC(copy_page_rep)
 
-/* Don't use streaming store because it's better when the target
-   ends up in cache. */
-	    
-/* Could vary the prefetch distance based on SMP/UP */
+/*
+ *  Don't use streaming copy unless the CPU indicates X86_FEATURE_REP_GOOD.
+ *  Could vary the prefetch distance based on SMP/UP.
+*/
 
 ENTRY(copy_page)
 	CFI_STARTPROC
-	subq	$2*8,%rsp
+	subq	$2*8,	%rsp
 	CFI_ADJUST_CFA_OFFSET 2*8
-	movq	%rbx,(%rsp)
+	movq	%rbx,	(%rsp)
 	CFI_REL_OFFSET rbx, 0
-	movq	%r12,1*8(%rsp)
+	movq	%r12,	1*8(%rsp)
 	CFI_REL_OFFSET r12, 1*8
 
-	movl	$(4096/64)-5,%ecx
+	movl	$(4096/64)-5,	%ecx
 	.p2align 4
 .Loop64:
-  	dec     %rcx
-
-	movq        (%rsi), %rax
-	movq      8 (%rsi), %rbx
-	movq     16 (%rsi), %rdx
-	movq     24 (%rsi), %r8
-	movq     32 (%rsi), %r9
-	movq     40 (%rsi), %r10
-	movq     48 (%rsi), %r11
-	movq     56 (%rsi), %r12
+	dec	%rcx
+	movq	0x8*0(%rsi), %rax
+	movq	0x8*1(%rsi), %rbx
+	movq	0x8*2(%rsi), %rdx
+	movq	0x8*3(%rsi), %r8
+	movq	0x8*4(%rsi), %r9
+	movq	0x8*5(%rsi), %r10
+	movq	0x8*6(%rsi), %r11
+	movq	0x8*7(%rsi), %r12
 
 	prefetcht0 5*64(%rsi)
 
-	movq     %rax,    (%rdi)
-	movq     %rbx,  8 (%rdi)
-	movq     %rdx, 16 (%rdi)
-	movq     %r8,  24 (%rdi)
-	movq     %r9,  32 (%rdi)
-	movq     %r10, 40 (%rdi)
-	movq     %r11, 48 (%rdi)
-	movq     %r12, 56 (%rdi)
+	movq	%rax, 0x8*0(%rdi)
+	movq	%rbx, 0x8*1(%rdi)
+	movq	%rdx, 0x8*2(%rdi)
+	movq	%r8,  0x8*3(%rdi)
+	movq	%r9,  0x8*4(%rdi)
+	movq	%r10, 0x8*5(%rdi)
+	movq	%r11, 0x8*6(%rdi)
+	movq	%r12, 0x8*7(%rdi)
 
-	leaq    64 (%rsi), %rsi
-	leaq    64 (%rdi), %rdi
+	leaq	64 (%rsi), %rsi
+	leaq	64 (%rdi), %rdi
 
-	jnz     .Loop64
+	jnz	.Loop64
 
-	movl	$5,%ecx
+	movl	$5, %ecx
 	.p2align 4
 .Loop2:
-	decl   %ecx
-
-	movq        (%rsi), %rax
-	movq      8 (%rsi), %rbx
-	movq     16 (%rsi), %rdx
-	movq     24 (%rsi), %r8
-	movq     32 (%rsi), %r9
-	movq     40 (%rsi), %r10
-	movq     48 (%rsi), %r11
-	movq     56 (%rsi), %r12
-
-	movq     %rax,    (%rdi)
-	movq     %rbx,  8 (%rdi)
-	movq     %rdx, 16 (%rdi)
-	movq     %r8,  24 (%rdi)
-	movq     %r9,  32 (%rdi)
-	movq     %r10, 40 (%rdi)
-	movq     %r11, 48 (%rdi)
-	movq     %r12, 56 (%rdi)
-
-	leaq	64(%rdi),%rdi
-	leaq	64(%rsi),%rsi
-
+	decl	%ecx
+
+	movq	0x8*0(%rsi), %rax
+	movq	0x8*1(%rsi), %rbx
+	movq	0x8*2(%rsi), %rdx
+	movq	0x8*3(%rsi), %r8
+	movq	0x8*4(%rsi), %r9
+	movq	0x8*5(%rsi), %r10
+	movq	0x8*6(%rsi), %r11
+	movq	0x8*7(%rsi), %r12
+
+	movq	%rax, 0x8*0(%rdi)
+	movq	%rbx, 0x8*1(%rdi)
+	movq	%rdx, 0x8*2(%rdi)
+	movq	%r8,  0x8*3(%rdi)
+	movq	%r9,  0x8*4(%rdi)
+	movq	%r10, 0x8*5(%rdi)
+	movq	%r11, 0x8*6(%rdi)
+	movq	%r12, 0x8*7(%rdi)
+
+	leaq	64(%rdi), %rdi
+	leaq	64(%rsi), %rsi
 	jnz	.Loop2
 
-	movq	(%rsp),%rbx
+	movq	(%rsp), %rbx
 	CFI_RESTORE rbx
-	movq	1*8(%rsp),%r12
+	movq	1*8(%rsp), %r12
 	CFI_RESTORE r12
-	addq	$2*8,%rsp
+	addq	$2*8, %rsp
 	CFI_ADJUST_CFA_OFFSET -2*8
 	ret
 .Lcopy_page_end:
@@ -103,7 +101,7 @@ ENDPROC(copy_page)
 
 	.section .altinstr_replacement,"ax"
 1:	.byte 0xeb					/* jmp <disp8> */
-	.byte (copy_page_c - copy_page) - (2f - 1b)	/* offset */
+	.byte (copy_page_rep - copy_page) - (2f - 1b)	/* offset */
 2:
 	.previous
 	.section .altinstructions,"a"
