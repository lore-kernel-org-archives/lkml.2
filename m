Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2DSAR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 20:17:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43457 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2DSARy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 20:17:54 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 5/5] x86-32: Handle exception table entries during early boot
Date: Wed, 18 Apr 2012 17:16:50 -0700
Message-Id: <1334794610-5546-6-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1334794610-5546-1-git-send-email-hpa@zytor.com>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 18 Apr 2012 17:17:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

If we get an exception during early boot, walk the exception table to
see if we should intercept it.  The main use case for this is to allow
rdmsr_safe()/wrmsr_safe() during CPU initialization.

Since the exception table is currently sorted at runtime, and fairly
late in startup, this code walks the exception table linearly.  We
obviously don't need to worry about modules, however: none have been
loaded at this point.

In the future it would be better to have the table sorted at compile
time, or even better, turned into a perfect hash.  At that point this
code should be changed out from doing a linear search.

This patch changes the early IDT setup to look a lot more like x86-64:
we now install handlers for all 32 exception vectors.  The output of
the early exception handler has changed somewhat as it directly
reflects the stack frame of the exception handler, and the stack frame
has been somewhat restructured.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/head_32.S |  142 +++++++++++++++++++++++++++++----------------
 1 files changed, 91 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index ce0be7c..3a3cd0d 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -21,6 +21,7 @@
 #include <asm/msr-index.h>
 #include <asm/cpufeature.h>
 #include <asm/percpu.h>
+#include <asm/nops.h>
 
 /* Physical address */
 #define pa(X) ((X) - __PAGE_OFFSET)
@@ -508,68 +509,94 @@ check_x87:
  *  Warning: %esi is live across this function.
  */
 setup_idt:
-	lea ignore_int,%edx
+	movl $idt_table,%edi
+	movl $early_idt_handlers,%eax
+	movl $NUM_EXCEPTION_VECTORS,%ecx
+1:
+	movl %eax,(%edi)
+	movl %eax,4(%edi)
+	/* interrupt gate, dpl=0, present */
+	movl $(0x8E000000 + __KERNEL_CS),2(%edi)
+	addl $9,%eax
+	addl $8,%edi
+	loop 1b
+
+	movl $256 - NUM_EXCEPTION_VECTORS,%ecx
+	movl $ignore_int,%edx
 	movl $(__KERNEL_CS << 16),%eax
 	movw %dx,%ax		/* selector = 0x0010 = cs */
 	movw $0x8E00,%dx	/* interrupt gate - dpl=0, present */
-
-	lea idt_table,%edi
-	mov $256,%ecx
-rp_sidt:
+2:
 	movl %eax,(%edi)
 	movl %edx,4(%edi)
 	addl $8,%edi
-	dec %ecx
-	jne rp_sidt
-
-.macro	set_early_handler handler,trapno
-	lea \handler,%edx
-	movl $(__KERNEL_CS << 16),%eax
-	movw %dx,%ax
-	movw $0x8E00,%dx	/* interrupt gate - dpl=0, present */
-	lea idt_table,%edi
-	movl %eax,8*\trapno(%edi)
-	movl %edx,8*\trapno+4(%edi)
-.endm
-
-	set_early_handler handler=early_divide_err,trapno=0
-	set_early_handler handler=early_illegal_opcode,trapno=6
-	set_early_handler handler=early_protection_fault,trapno=13
-	set_early_handler handler=early_page_fault,trapno=14
-
+	loop 2b
+	
 	ret
 
-early_divide_err:
-	xor %edx,%edx
-	pushl $0	/* fake errcode */
-	jmp early_fault
+	.globl early_idt_handlers
+early_idt_handlers:
+	# 36(%esp) %eflags
+	# 32(%esp) %cs
+	# 28(%esp) %eip
+	# 24(%rsp) error code
+	i = 0
+	.rept NUM_EXCEPTION_VECTORS
+	.if (EXCEPTION_ERRCODE_MASK >> i) & 1
+	ASM_NOP2
+	.else
+	pushl $0		# Dummy error code, to make stack frame uniform
+	.endif
+	pushl $i		# 20(%esp) Vector number
+	jmp early_idt_handler
+	i = i + 1
+	.endr
+
+	/* This is global to keep gas from relaxing the jumps */
+	.globl	early_idt_handler
+early_idt_handler:
+	cld
+	cmpl $2,%ss:early_recursion_flag
+	je hlt_loop
+	incl %ss:early_recursion_flag
 
-early_illegal_opcode:
-	movl $6,%edx
-	pushl $0	/* fake errcode */
-	jmp early_fault
+	push %eax		# 16(%esp)
+	push %ecx		# 12(%esp)
+	push %edx		#  8(%esp)
+	push %ds		#  4(%esp)
+	push %es		#  0(%esp)
+	movl $(__KERNEL_DS),%eax
+	movl %eax,%ds
+	movl %eax,%es
 
-early_protection_fault:
-	movl $13,%edx
-	jmp early_fault
+	cmpl $(__KERNEL_CS),32(%esp)
+	jne 10f
 
-early_page_fault:
-	movl $14,%edx
-	jmp early_fault
+	movl 28(%esp),%eax	# %eip
+	movl $__start___ex_table,%ecx
+	movl $__stop___ex_table,%edx
+11:
+	cmpl (%ecx),%eax
+	je ex_entry		/* found an exception entry */
+	addl $8,%ecx
+	cmpl %edx,%ecx
+	jb 11b
 
-early_fault:
-	cld
+10:
 #ifdef CONFIG_PRINTK
-	pusha
-	movl $(__KERNEL_DS),%eax
-	movl %eax,%ds
-	movl %eax,%es
-	cmpl $2,early_recursion_flag
-	je hlt_loop
-	incl early_recursion_flag
+	xorl %eax,%eax
+	movw %ax,2(%esp)	/* clean up the segment values on some cpus */
+	movw %ax,6(%esp)
+	movw %ax,34(%esp)
+	leal  40(%esp),%eax
+	pushl %eax		/* %esp before the exception */
+	pushl %ebx
+	pushl %ebp
+	pushl %esi
+	pushl %edi
 	movl %cr2,%eax
 	pushl %eax
-	pushl %edx		/* trapno */
+	pushl (20+6*4)(%esp)	/* trapno */
 	pushl $fault_msg
 	call printk
 #endif
@@ -578,6 +605,18 @@ hlt_loop:
 	hlt
 	jmp hlt_loop
 
+ex_entry:
+	movl 4(%ecx),%eax
+	movl %eax,28(%esp)	/* change %eip on the stack */
+	pop %es
+	pop %ds
+	pop %edx
+	pop %ecx
+	pop %eax
+	addl $8,%esp		/* drop vector number and error code */
+	decl %ss:early_recursion_flag
+	iret
+
 /* This is the default interrupt "handler" :-) */
 	ALIGN
 ignore_int:
@@ -681,11 +720,12 @@ int_msg:
 fault_msg:
 /* fault info: */
 	.ascii "BUG: Int %d: CR2 %p\n"
-/* pusha regs: */
-	.ascii "     EDI %p  ESI %p  EBP %p  ESP %p\n"
-	.ascii "     EBX %p  EDX %p  ECX %p  EAX %p\n"
+/* regs pushed in early_idt_handler: */
+	.ascii "     EDI %p  ESI %p  EBP %p  EBX %p\n"
+	.ascii "     ESP %p   ES %p   DS %p\n"
+	.ascii "     EDX %p  ECX %p  EAX %p\n"
 /* fault frame: */
-	.ascii "     err %p  EIP %p   CS %p  flg %p\n"
+	.ascii "     vec %p  err %p  EIP %p   CS %p  flg %p\n"
 	.ascii "Stack: %p %p %p %p %p %p %p %p\n"
 	.ascii "       %p %p %p %p %p %p %p %p\n"
 	.asciz "       %p %p %p %p %p %p %p %p\n"
-- 
1.7.6.5

