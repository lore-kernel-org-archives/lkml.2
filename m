Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab2DSARr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 20:17:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43452 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2DSARp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 20:17:45 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 4/5] x86-64: Handle exception table entries during early boot
Date: Wed, 18 Apr 2012 17:16:49 -0700
Message-Id: <1334794610-5546-5-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1334794610-5546-1-git-send-email-hpa@zytor.com>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 18 Apr 2012 17:17:32 -0700 (PDT)
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
---
 arch/x86/include/asm/segment.h |    2 +-
 arch/x86/kernel/head_64.S      |   72 +++++++++++++++++++++++++++++----------
 2 files changed, 54 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 58c1e6c..c48a950 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -213,7 +213,7 @@
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
-extern const char early_idt_handlers[NUM_EXCEPTION_VECTORS][10];
+extern const char early_idt_handlers[NUM_EXCEPTION_VECTORS][2+2+5];
 
 /*
  * Load a segment. Fall back on loading the zero
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index d1e112c..8b89239 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -19,6 +19,7 @@
 #include <asm/cache.h>
 #include <asm/processor-flags.h>
 #include <asm/percpu.h>
+#include <asm/nops.h>
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/asm-offsets.h>
@@ -26,6 +27,7 @@
 #define GET_CR2_INTO(reg) GET_CR2_INTO_RAX ; movq %rax, reg
 #else
 #define GET_CR2_INTO(reg) movq %cr2, reg
+#define INTERRUPT_RETURN iretq
 #endif
 
 /* we are not able to switch in one step to the final KERNEL ADDRESS SPACE
@@ -271,35 +273,56 @@ bad_address:
 	jmp bad_address
 
 	.section ".init.text","ax"
-#ifdef CONFIG_EARLY_PRINTK
 	.globl early_idt_handlers
 early_idt_handlers:
+	# 56(%rsp) %rflags
+	# 48(%rsp) %cs
+	# 40(%rsp) %rip
+	# 32(%rsp) error code
 	i = 0
 	.rept NUM_EXCEPTION_VECTORS
-	movl $i, %esi
+	.if (EXCEPTION_ERRCODE_MASK >> i) & 1
+	ASM_NOP2
+	.else
+	pushq $0		# Dummy error code, to make stack frame uniform
+	.endif
+	pushq $i		# 24(%rsp) Vector number
 	jmp early_idt_handler
 	i = i + 1
 	.endr
-#endif
 
 ENTRY(early_idt_handler)
-#ifdef CONFIG_EARLY_PRINTK
+	cld
+
 	cmpl $2,early_recursion_flag(%rip)
 	jz  1f
 	incl early_recursion_flag(%rip)
-	GET_CR2_INTO(%r9)
-	xorl %r8d,%r8d		# zero for error code
-	movl %esi,%ecx		# get vector number
-	# Test %ecx against mask of vectors that push error code.
-	cmpl $31,%ecx
-	ja 0f
-	movl $1,%eax
-	salq %cl,%rax
-	testl $EXCEPTION_ERRCODE_MASK,%eax
-	je 0f
-	popq %r8		# get error code
-0:	movq 0(%rsp),%rcx	# get ip
-	movq 8(%rsp),%rdx	# get cs
+
+	pushq %rax		# 16(%rsp)
+	pushq %rcx		#  8(%rsp)
+	pushq %rdx		#  0(%rsp)
+
+	cmpl $__KERNEL_CS,48(%rsp)
+	jne 10f
+
+	movq 40(%rsp),%rax	# %rip
+	leaq __start___ex_table(%rip),%rcx
+	leaq __stop___ex_table(%rip),%rdx
+
+11:
+	cmpq (%rcx),%rax
+	je 20f			# Found an exception entry
+	addq $16,%rcx
+	cmpq %rdx,%rcx
+	jb 11b
+
+10:
+#ifdef CONFIG_EARLY_PRINTK
+	GET_CR2_INTO(%r9)	# can clobber any volatile register if pv
+	movl 32(%rsp),%r8d	# error code
+	movl 24(%rsp),%esi	# vector number
+	movl 48(%rsp),%edx	# %cs
+	movq 40(%rsp),%rcx	# %rip
 	xorl %eax,%eax
 	leaq early_idt_msg(%rip),%rdi
 	call early_printk
@@ -308,17 +331,28 @@ ENTRY(early_idt_handler)
 	call dump_stack
 #ifdef CONFIG_KALLSYMS	
 	leaq early_idt_ripmsg(%rip),%rdi
-	movq 0(%rsp),%rsi	# get rip again
+	movq 40(%rsp),%rsi	# %rip again
 	call __print_symbol
 #endif
 #endif /* EARLY_PRINTK */
 1:	hlt
 	jmp 1b
 
-#ifdef CONFIG_EARLY_PRINTK
+20:	# Exception table entry found
+	movq 8(%rcx),%rax	# exception table target
+	movq %rax,40(%rsp)	# change %rip on stack
+	popq %rdx
+	popq %rcx
+	popq %rax
+	addq $16,%rsp		# drop vector number and error code
+	decl early_recursion_flag(%rip)
+	INTERRUPT_RETURN
+
+	.balign 4
 early_recursion_flag:
 	.long 0
 
+#ifdef CONFIG_EARLY_PRINTK
 early_idt_msg:
 	.asciz "PANIC: early exception %02lx rip %lx:%lx error %lx cr2 %lx\n"
 early_idt_ripmsg:
-- 
1.7.6.5

