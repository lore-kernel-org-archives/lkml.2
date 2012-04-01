Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab2DAAAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 20:00:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35730 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab2DAAA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 20:00:29 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 1 Apr 2012 00:00:00 +0000
Subject: [PATCH] x86-32: A better system call mechanism
Message-Id: <201204010000.quickdontsayit@terminus.zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 31 Mar 2012 17:00:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86-32, we currently use int $0x80 as the primary system call
mechanism.  Although there are some recent variants available on
certain hardware (sysenter, syscall) via the vdso, the primary system
call vector is still way up the interrupt vector table, which is
inefficient.

This patch adds a very small amount of code which permits the very
first vector to be used for system call.  That vector is #DE, divide
error, generally known as division by zero.

An example of how to use this new system call mechanism:

	.text
	.globl	_start
_start:
	movl $__NR_write, %eax
	movl $1, %ebx
	movl $str_1, %ecx
	movl $str_1_len, %edx
	aam $0

	movl $__NR_write, %eax
	movl $1, %ebx
	movl $str_2, %ecx
	movl $str_2_len, %edx
	divl %edx

	movl $__NR_exit, %eax
	xorl %ebx, %ebx
	divl %edx

	.type	_start, @function
	.size	_start, . - _start

	.section ".rodata", "a"
	.balign	128
str_1:
	.ascii "This works!\n"
str_1_len	= . - str_1

str_2:
	.ascii "This works too!\n"
str_2_len	= . - str_2

We use the shortest forms of the relevant instructions only, for
simplicity.  Why these mechanisms work is left as a trivial exercise
to the reader.

Suggested-by: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/entry_32.S |    5 ++++-
 arch/x86/kernel/traps.c    |    3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 7b784f4..0dfe246 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -497,7 +497,10 @@ ENDPROC(ia32_sysenter_target)
  */
 	.pushsection .kprobes.text, "ax"
 	# system call handler stub
-ENTRY(system_call)
+ENTRY(system_call_divide_error)
+	addl $2,(%esp)			# Skip past the faulting instruction
+	.globl system_call		# Don't use ENTRY because of padding
+system_call:
 	RING0_INT_FRAME			# can't unwind into user space anyway
 	pushl_cfi %eax			# save orig_eax
 	SAVE_ALL
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ff9281f1..d5bd411 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -67,6 +67,7 @@
 #include <asm/setup.h>
 
 asmlinkage int system_call(void);
+asmlinkage int system_call_divide_error(void);
 
 /* Do we ignore FPU interrupts ? */
 char ignore_fpu_irq;
@@ -679,7 +680,7 @@ void __init trap_init(void)
 	early_iounmap(p, 4);
 #endif
 
-	set_intr_gate(X86_TRAP_DE, &divide_error);
+	set_system_trap_gate(X86_TRAP_DE, &system_call_divide_error);
 	set_intr_gate_ist(X86_TRAP_NMI, &nmi, NMI_STACK);
 	/* int4 can be called from all */
 	set_system_intr_gate(X86_TRAP_OF, &overflow);
-- 
1.7.6.5

