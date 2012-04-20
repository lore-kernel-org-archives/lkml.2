Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab2DTA2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:28:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53132 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab2DTA2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:28:16 -0400
Date: Thu, 19 Apr 2012 17:28:04 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-9900aa2f95844eb81428c1d3d202c01b7f3ac77a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1334794610-5546-5-git-send-email-hpa@zytor.com>
References: <1334794610-5546-5-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86-64:
  Handle exception table entries during early boot
Git-Commit-ID: 9900aa2f95844eb81428c1d3d202c01b7f3ac77a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 19 Apr 2012 17:28:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9900aa2f95844eb81428c1d3d202c01b7f3ac77a
Gitweb:     http://git.kernel.org/tip/9900aa2f95844eb81428c1d3d202c01b7f3ac77a
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Wed, 18 Apr 2012 17:16:49 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 19 Apr 2012 15:42:45 -0700

x86-64: Handle exception table entries during early boot

If we get an exception during early boot, walk the exception table to
see if we should intercept it.  The main use case for this is to allow
rdmsr_safe()/wrmsr_safe() during CPU initialization.

Since the exception table is currently sorted at runtime, and fairly
late in startup, this code walks the exception table linearly.  We
obviously don't need to worry about modules, however: none have been
loaded at this point.

[ v2: Use early_fixup_exception() instead of linear search ]

Link: http://lkml.kernel.org/r/1334794610-5546-5-git-send-email-hpa@zytor.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/segment.h |    2 +-
 arch/x86/kernel/head_64.S      |   76 ++++++++++++++++++++++++++++++----------
 2 files changed, 58 insertions(+), 20 deletions(-)

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
index d1e112c..7a40f24 100644
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
+	# 104(%rsp) %rflags
+	#  96(%rsp) %cs
+	#  88(%rsp) %rip
+	#  80(%rsp) error code
 	i = 0
 	.rept NUM_EXCEPTION_VECTORS
-	movl $i, %esi
+	.if (EXCEPTION_ERRCODE_MASK >> i) & 1
+	ASM_NOP2
+	.else
+	pushq $0		# Dummy error code, to make stack frame uniform
+	.endif
+	pushq $i		# 72(%rsp) Vector number
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
+	pushq %rax		# 64(%rsp)
+	pushq %rcx		# 56(%rsp)
+	pushq %rdx		# 48(%rsp)
+	pushq %rsi		# 40(%rsp)
+	pushq %rdi		# 32(%rsp)
+	pushq %r8		# 24(%rsp)
+	pushq %r9		# 16(%rsp)
+	pushq %r10		#  8(%rsp)
+	pushq %r11		#  0(%rsp)
+
+	cmpl $__KERNEL_CS,96(%rsp)
+	jne 10f
+
+	leaq 88(%rsp),%rdi	# Pointer to %rip
+	call early_fixup_exception
+	andl %eax,%eax
+	jnz 20f			# Found an exception entry
+
+10:
+#ifdef CONFIG_EARLY_PRINTK
+	GET_CR2_INTO(%r9)	# can clobber any volatile register if pv
+	movl 80(%rsp),%r8d	# error code
+	movl 72(%rsp),%esi	# vector number
+	movl 96(%rsp),%edx	# %cs
+	movq 88(%rsp),%rcx	# %rip
 	xorl %eax,%eax
 	leaq early_idt_msg(%rip),%rdi
 	call early_printk
@@ -308,17 +331,32 @@ ENTRY(early_idt_handler)
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
+	popq %r11
+	popq %r10
+	popq %r9
+	popq %r8
+	popq %rdi
+	popq %rsi
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
