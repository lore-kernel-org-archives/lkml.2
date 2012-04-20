Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab2DTA3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:29:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53155 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab2DTA3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:29:05 -0400
Date: Thu, 19 Apr 2012 17:28:55 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-4c5023a3fa2ec12b7ed313b276b157917575745b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <1334794610-5546-6-git-send-email-hpa@zytor.com>
References: <1334794610-5546-6-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86-32:
  Handle exception table entries during early boot
Git-Commit-ID: 4c5023a3fa2ec12b7ed313b276b157917575745b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 19 Apr 2012 17:29:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c5023a3fa2ec12b7ed313b276b157917575745b
Gitweb:     http://git.kernel.org/tip/4c5023a3fa2ec12b7ed313b276b157917575745b
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Wed, 18 Apr 2012 17:16:50 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 19 Apr 2012 16:45:02 -0700

x86-32: Handle exception table entries during early boot

If we get an exception during early boot, walk the exception table to
see if we should intercept it.  The main use case for this is to allow
rdmsr_safe()/wrmsr_safe() during CPU initialization.

Since the exception table is currently sorted at runtime, and fairly
late in startup, this code walks the exception table linearly.  We
obviously don't need to worry about modules, however: none have been
loaded at this point.

This patch changes the early IDT setup to look a lot more like x86-64:
we now install handlers for all 32 exception vectors.  The output of
the early exception handler has changed somewhat as it directly
reflects the stack frame of the exception handler, and the stack frame
has been somewhat restructured.

Finally, centralize the code that can and should be run only once.

[ v2: Use early_fixup_exception() instead of linear search ]

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1334794610-5546-6-git-send-email-hpa@zytor.com
---
 arch/x86/kernel/head_32.S |  223 ++++++++++++++++++++++++++-------------------
 1 files changed, 129 insertions(+), 94 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index ce0be7c..463c979 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -21,6 +21,7 @@
 #include <asm/msr-index.h>
 #include <asm/cpufeature.h>
 #include <asm/percpu.h>
+#include <asm/nops.h>
 
 /* Physical address */
 #define pa(X) ((X) - __PAGE_OFFSET)
@@ -363,28 +364,23 @@ default_entry:
 	pushl $0
 	popfl
 
-#ifdef CONFIG_SMP
-	cmpb $0, ready
-	jnz checkCPUtype
-#endif /* CONFIG_SMP */
-
 /*
  * start system 32-bit setup. We need to re-do some of the things done
  * in 16-bit mode for the "real" operations.
  */
-	call setup_idt
-
-checkCPUtype:
-
-	movl $-1,X86_CPUID		#  -1 for no CPUID initially
-
+	movl setup_once_ref,%eax
+	andl %eax,%eax
+	jz 1f				# Did we do this already?
+	call *%eax
+1:
+	
 /* check if it is 486 or 386. */
 /*
  * XXX - this does a lot of unnecessary setup.  Alignment checks don't
  * apply at our cpl of 0 and the stack ought to be aligned already, and
  * we don't need to preserve eflags.
  */
-
+	movl $-1,X86_CPUID	# -1 for no CPUID initially
 	movb $3,X86		# at least 386
 	pushfl			# push EFLAGS
 	popl %eax		# get EFLAGS
@@ -450,21 +446,6 @@ is386:	movl $2,%ecx		# set MP
 	movl $(__KERNEL_PERCPU), %eax
 	movl %eax,%fs			# set this cpu's percpu
 
-#ifdef CONFIG_CC_STACKPROTECTOR
-	/*
-	 * The linker can't handle this by relocation.  Manually set
-	 * base address in stack canary segment descriptor.
-	 */
-	cmpb $0,ready
-	jne 1f
-	movl $gdt_page,%eax
-	movl $stack_canary,%ecx
-	movw %cx, 8 * GDT_ENTRY_STACK_CANARY + 2(%eax)
-	shrl $16, %ecx
-	movb %cl, 8 * GDT_ENTRY_STACK_CANARY + 4(%eax)
-	movb %ch, 8 * GDT_ENTRY_STACK_CANARY + 7(%eax)
-1:
-#endif
 	movl $(__KERNEL_STACK_CANARY),%eax
 	movl %eax,%gs
 
@@ -473,7 +454,6 @@ is386:	movl $2,%ecx		# set MP
 
 	cld			# gcc2 wants the direction flag cleared at all times
 	pushl $0		# fake return address for unwinder
-	movb $1, ready
 	jmp *(initial_code)
 
 /*
@@ -495,81 +475,122 @@ check_x87:
 	.byte 0xDB,0xE4		/* fsetpm for 287, ignored by 387 */
 	ret
 
+	
+#include "verify_cpu.S"
+
 /*
- *  setup_idt
+ *  setup_once
  *
- *  sets up a idt with 256 entries pointing to
- *  ignore_int, interrupt gates. It doesn't actually load
- *  idt - that can be done only after paging has been enabled
- *  and the kernel moved to PAGE_OFFSET. Interrupts
- *  are enabled elsewhere, when we can be relatively
- *  sure everything is ok.
+ *  The setup work we only want to run on the BSP.
  *
  *  Warning: %esi is live across this function.
  */
-setup_idt:
-	lea ignore_int,%edx
-	movl $(__KERNEL_CS << 16),%eax
-	movw %dx,%ax		/* selector = 0x0010 = cs */
-	movw $0x8E00,%dx	/* interrupt gate - dpl=0, present */
+__INIT
+setup_once:
+	/*
+	 * Set up a idt with 256 entries pointing to ignore_int,
+	 * interrupt gates. It doesn't actually load idt - that needs
+	 * to be done on each CPU. Interrupts are enabled elsewhere,
+	 * when we can be relatively sure everything is ok.
+	 */
 
-	lea idt_table,%edi
-	mov $256,%ecx
-rp_sidt:
+	movl $idt_table,%edi
+	movl $early_idt_handlers,%eax
+	movl $NUM_EXCEPTION_VECTORS,%ecx
+1:
 	movl %eax,(%edi)
-	movl %edx,4(%edi)
+	movl %eax,4(%edi)
+	/* interrupt gate, dpl=0, present */
+	movl $(0x8E000000 + __KERNEL_CS),2(%edi)
+	addl $9,%eax
 	addl $8,%edi
-	dec %ecx
-	jne rp_sidt
+	loop 1b
 
-.macro	set_early_handler handler,trapno
-	lea \handler,%edx
+	movl $256 - NUM_EXCEPTION_VECTORS,%ecx
+	movl $ignore_int,%edx
 	movl $(__KERNEL_CS << 16),%eax
-	movw %dx,%ax
+	movw %dx,%ax		/* selector = 0x0010 = cs */
 	movw $0x8E00,%dx	/* interrupt gate - dpl=0, present */
-	lea idt_table,%edi
-	movl %eax,8*\trapno(%edi)
-	movl %edx,8*\trapno+4(%edi)
-.endm
+2:
+	movl %eax,(%edi)
+	movl %edx,4(%edi)
+	addl $8,%edi
+	loop 2b
 
-	set_early_handler handler=early_divide_err,trapno=0
-	set_early_handler handler=early_illegal_opcode,trapno=6
-	set_early_handler handler=early_protection_fault,trapno=13
-	set_early_handler handler=early_page_fault,trapno=14
+#ifdef CONFIG_CC_STACKPROTECTOR
+	/*
+	 * Configure the stack canary. The linker can't handle this by
+	 * relocation.  Manually set base address in stack canary
+	 * segment descriptor.
+	 */
+	movl $gdt_page,%eax
+	movl $stack_canary,%ecx
+	movw %cx, 8 * GDT_ENTRY_STACK_CANARY + 2(%eax)
+	shrl $16, %ecx
+	movb %cl, 8 * GDT_ENTRY_STACK_CANARY + 4(%eax)
+	movb %ch, 8 * GDT_ENTRY_STACK_CANARY + 7(%eax)
+#endif
 
+	andl $0,setup_once_ref	/* Once is enough, thanks */
 	ret
 
-early_divide_err:
-	xor %edx,%edx
-	pushl $0	/* fake errcode */
-	jmp early_fault
+ENTRY(early_idt_handlers)
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
+ENDPROC(early_idt_handlers)
+	
+	/* This is global to keep gas from relaxing the jumps */
+ENTRY(early_idt_handler)
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
+	leal 28(%esp),%eax	# Pointer to %eip
+	call early_fixup_exception
+	andl %eax,%eax
+	jnz ex_entry		/* found an exception entry */
 
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
@@ -578,6 +599,17 @@ hlt_loop:
 	hlt
 	jmp hlt_loop
 
+ex_entry:
+	pop %es
+	pop %ds
+	pop %edx
+	pop %ecx
+	pop %eax
+	addl $8,%esp		/* drop vector number and error code */
+	decl %ss:early_recursion_flag
+	iret
+ENDPROC(early_idt_handler)
+
 /* This is the default interrupt "handler" :-) */
 	ALIGN
 ignore_int:
@@ -611,13 +643,18 @@ ignore_int:
 	popl %eax
 #endif
 	iret
+ENDPROC(ignore_int)
+__INITDATA
+	.align 4
+early_recursion_flag:
+	.long 0
 
-#include "verify_cpu.S"
-
-	__REFDATA
-.align 4
+__REFDATA
+	.align 4
 ENTRY(initial_code)
 	.long i386_start_kernel
+ENTRY(setup_once_ref)
+	.long setup_once
 
 /*
  * BSS section
@@ -670,22 +707,19 @@ ENTRY(initial_page_table)
 ENTRY(stack_start)
 	.long init_thread_union+THREAD_SIZE
 
-early_recursion_flag:
-	.long 0
-
-ready:	.byte 0
-
+__INITRODATA
 int_msg:
 	.asciz "Unknown interrupt or fault at: %p %p %p\n"
 
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
@@ -699,6 +733,7 @@ fault_msg:
  * segment size, and 32-bit linear address value:
  */
 
+	.data
 .globl boot_gdt_descr
 .globl idt_descr
 
