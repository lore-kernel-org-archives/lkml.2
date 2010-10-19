Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab0JSNwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:52:32 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:51910 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab0JSNwb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:2>);
	Tue, 19 Oct 2010 09:52:31 -0400
Message-Id: <4CBDBEBA020000780001E05A@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 19 Oct 2010 14:52:26 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <akpm@linux-foundation.org>,
        <hpa@zytor.com>
Cc: <heukelum@fastmail.fm>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix CFI macro invocations to deal with
	 shortcomings in gas
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gas prior to (perhaps) 2.16.90 has problems with passing non-
parenthesized expressions containing spaces to macros. Spaces, however,
get inserted by cpp between any macro expanding to a number and a
subsequent + or -. For the +, current x86 gas then removes the space
again (future gas may not do so), but for the - the space gets retained
and is then considered a separator between macro arguments.

Fix the respective definitions for both the - and + cases, so that they
neither contain spaces nor make cpp insert any (the latter by adding
seemingly redundant parentheses).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>

---
 Kbuild                            |    2 -
 arch/x86/include/asm/calling.h    |   52 +++++++++++++++++++-------------------
 arch/x86/include/asm/entry_arch.h |   19 ++-----------
 arch/x86/include/asm/segment.h    |   32 +++++++++++------------
 arch/x86/kernel/asm-offsets_32.c  |    4 --
 arch/x86/kernel/entry_32.S        |    6 ++--
 arch/x86/kernel/entry_64.S        |   20 ++------------
 7 files changed, 56 insertions(+), 79 deletions(-)

--- 2.6.36-rc8-x86-cfi.orig/Kbuild
+++ 2.6.36-rc8-x86-cfi/Kbuild
@@ -53,7 +53,7 @@ targets += arch/$(SRCARCH)/kernel/asm-of
 # Default sed regexp - multiline due to syntax constraints
 define sed-y
 	"/^->/{s:->#\(.*\):/* \1 */:; \
-	s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
+	s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 (\2) /* \3 */:; \
 	s:->::; p;}"
 endef
 
--- 2.6.36-rc8-x86-cfi.orig/arch/x86/include/asm/calling.h
+++ 2.6.36-rc8-x86-cfi/arch/x86/include/asm/calling.h
@@ -48,36 +48,38 @@ For 32-bit we have the following convent
 
 
 /*
- * 64-bit system call stack frame layout defines and helpers,
- * for assembly code:
+ * 64-bit system call stack frame layout defines and helpers, for
+ * assembly code (note that the seemingly unnecessary parentheses
+ * are to prevent cpp from inserting spaces in expressions that get
+ * passed to macros):
  */
 
-#define R15		  0
-#define R14		  8
-#define R13		 16
-#define R12		 24
-#define RBP		 32
-#define RBX		 40
+#define R15		  (0)
+#define R14		  (8)
+#define R13		 (16)
+#define R12		 (24)
+#define RBP		 (32)
+#define RBX		 (40)
 
 /* arguments: interrupts/non tracing syscalls only save up to here: */
-#define R11		 48
-#define R10		 56
-#define R9		 64
-#define R8		 72
-#define RAX		 80
-#define RCX		 88
-#define RDX		 96
-#define RSI		104
-#define RDI		112
-#define ORIG_RAX	120       /* + error_code */
+#define R11		 (48)
+#define R10		 (56)
+#define R9		 (64)
+#define R8		 (72)
+#define RAX		 (80)
+#define RCX		 (88)
+#define RDX		 (96)
+#define RSI		(104)
+#define RDI		(112)
+#define ORIG_RAX	(120)       /* + error_code */
 /* end of arguments */
 
 /* cpu exception frame or undefined in case of fast syscall: */
-#define RIP		128
-#define CS		136
-#define EFLAGS		144
-#define RSP		152
-#define SS		160
+#define RIP		(128)
+#define CS		(136)
+#define EFLAGS		(144)
+#define RSP		(152)
+#define SS		(160)
 
 #define ARGOFFSET	R11
 #define SWFRAME		ORIG_RAX
@@ -111,7 +113,7 @@ For 32-bit we have the following convent
 	.endif
 	.endm
 
-#define ARG_SKIP	9*8
+#define ARG_SKIP	(9*8)
 
 	.macro RESTORE_ARGS skiprax=0, addskip=0, skiprcx=0, skipr11=0, \
 			    skipr8910=0, skiprdx=0
@@ -169,7 +171,7 @@ For 32-bit we have the following convent
 	.endif
 	.endm
 
-#define REST_SKIP	6*8
+#define REST_SKIP	(6*8)
 
 	.macro SAVE_REST
 	subq $REST_SKIP, %rsp
--- 2.6.36-rc8-x86-cfi.orig/arch/x86/include/asm/entry_arch.h
+++ 2.6.36-rc8-x86-cfi/arch/x86/include/asm/entry_arch.h
@@ -16,22 +16,11 @@ BUILD_INTERRUPT(call_function_single_int
 BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
 BUILD_INTERRUPT(reboot_interrupt,REBOOT_VECTOR)
 
-BUILD_INTERRUPT3(invalidate_interrupt0,INVALIDATE_TLB_VECTOR_START+0,
-		 smp_invalidate_interrupt)
-BUILD_INTERRUPT3(invalidate_interrupt1,INVALIDATE_TLB_VECTOR_START+1,
-		 smp_invalidate_interrupt)
-BUILD_INTERRUPT3(invalidate_interrupt2,INVALIDATE_TLB_VECTOR_START+2,
-		 smp_invalidate_interrupt)
-BUILD_INTERRUPT3(invalidate_interrupt3,INVALIDATE_TLB_VECTOR_START+3,
-		 smp_invalidate_interrupt)
-BUILD_INTERRUPT3(invalidate_interrupt4,INVALIDATE_TLB_VECTOR_START+4,
-		 smp_invalidate_interrupt)
-BUILD_INTERRUPT3(invalidate_interrupt5,INVALIDATE_TLB_VECTOR_START+5,
-		 smp_invalidate_interrupt)
-BUILD_INTERRUPT3(invalidate_interrupt6,INVALIDATE_TLB_VECTOR_START+6,
-		 smp_invalidate_interrupt)
-BUILD_INTERRUPT3(invalidate_interrupt7,INVALIDATE_TLB_VECTOR_START+7,
+.irpc idx, "01234567"
+BUILD_INTERRUPT3(invalidate_interrupt\idx,
+		 (INVALIDATE_TLB_VECTOR_START)+\idx,
 		 smp_invalidate_interrupt)
+.endr
 #endif
 
 BUILD_INTERRUPT(x86_platform_ipi, X86_PLATFORM_IPI_VECTOR)
--- 2.6.36-rc8-x86-cfi.orig/arch/x86/include/asm/segment.h
+++ 2.6.36-rc8-x86-cfi/arch/x86/include/asm/segment.h
@@ -73,31 +73,31 @@
 
 #define GDT_ENTRY_DEFAULT_USER_DS	15
 
-#define GDT_ENTRY_KERNEL_BASE	12
+#define GDT_ENTRY_KERNEL_BASE		(12)
 
-#define GDT_ENTRY_KERNEL_CS		(GDT_ENTRY_KERNEL_BASE + 0)
+#define GDT_ENTRY_KERNEL_CS		(GDT_ENTRY_KERNEL_BASE+0)
 
-#define GDT_ENTRY_KERNEL_DS		(GDT_ENTRY_KERNEL_BASE + 1)
+#define GDT_ENTRY_KERNEL_DS		(GDT_ENTRY_KERNEL_BASE+1)
 
-#define GDT_ENTRY_TSS			(GDT_ENTRY_KERNEL_BASE + 4)
-#define GDT_ENTRY_LDT			(GDT_ENTRY_KERNEL_BASE + 5)
+#define GDT_ENTRY_TSS			(GDT_ENTRY_KERNEL_BASE+4)
+#define GDT_ENTRY_LDT			(GDT_ENTRY_KERNEL_BASE+5)
 
-#define GDT_ENTRY_PNPBIOS_BASE		(GDT_ENTRY_KERNEL_BASE + 6)
-#define GDT_ENTRY_APMBIOS_BASE		(GDT_ENTRY_KERNEL_BASE + 11)
+#define GDT_ENTRY_PNPBIOS_BASE		(GDT_ENTRY_KERNEL_BASE+6)
+#define GDT_ENTRY_APMBIOS_BASE		(GDT_ENTRY_KERNEL_BASE+11)
 
-#define GDT_ENTRY_ESPFIX_SS		(GDT_ENTRY_KERNEL_BASE + 14)
-#define __ESPFIX_SS (GDT_ENTRY_ESPFIX_SS * 8)
+#define GDT_ENTRY_ESPFIX_SS		(GDT_ENTRY_KERNEL_BASE+14)
+#define __ESPFIX_SS			(GDT_ENTRY_ESPFIX_SS*8)
 
-#define GDT_ENTRY_PERCPU			(GDT_ENTRY_KERNEL_BASE + 15)
+#define GDT_ENTRY_PERCPU		(GDT_ENTRY_KERNEL_BASE+15)
 #ifdef CONFIG_SMP
 #define __KERNEL_PERCPU (GDT_ENTRY_PERCPU * 8)
 #else
 #define __KERNEL_PERCPU 0
 #endif
 
-#define GDT_ENTRY_STACK_CANARY		(GDT_ENTRY_KERNEL_BASE + 16)
+#define GDT_ENTRY_STACK_CANARY		(GDT_ENTRY_KERNEL_BASE+16)
 #ifdef CONFIG_CC_STACKPROTECTOR
-#define __KERNEL_STACK_CANARY		(GDT_ENTRY_STACK_CANARY * 8)
+#define __KERNEL_STACK_CANARY		(GDT_ENTRY_STACK_CANARY*8)
 #else
 #define __KERNEL_STACK_CANARY		0
 #endif
@@ -182,10 +182,10 @@
 
 #endif
 
-#define __KERNEL_CS	(GDT_ENTRY_KERNEL_CS * 8)
-#define __KERNEL_DS	(GDT_ENTRY_KERNEL_DS * 8)
-#define __USER_DS     (GDT_ENTRY_DEFAULT_USER_DS* 8 + 3)
-#define __USER_CS     (GDT_ENTRY_DEFAULT_USER_CS* 8 + 3)
+#define __KERNEL_CS	(GDT_ENTRY_KERNEL_CS*8)
+#define __KERNEL_DS	(GDT_ENTRY_KERNEL_DS*8)
+#define __USER_DS	(GDT_ENTRY_DEFAULT_USER_DS*8+3)
+#define __USER_CS	(GDT_ENTRY_DEFAULT_USER_CS*8+3)
 #ifndef CONFIG_PARAVIRT
 #define get_kernel_rpl()  0
 #endif
--- 2.6.36-rc8-x86-cfi.orig/arch/x86/kernel/asm-offsets_32.c
+++ 2.6.36-rc8-x86-cfi/arch/x86/kernel/asm-offsets_32.c
@@ -99,9 +99,7 @@ void foo(void)
 
 	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
 	DEFINE(PAGE_SHIFT_asm, PAGE_SHIFT);
-	DEFINE(PTRS_PER_PTE, PTRS_PER_PTE);
-	DEFINE(PTRS_PER_PMD, PTRS_PER_PMD);
-	DEFINE(PTRS_PER_PGD, PTRS_PER_PGD);
+	DEFINE(THREAD_SIZE_asm, THREAD_SIZE);
 
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
 
--- 2.6.36-rc8-x86-cfi.orig/arch/x86/kernel/entry_32.S
+++ 2.6.36-rc8-x86-cfi/arch/x86/kernel/entry_32.S
@@ -382,20 +382,20 @@ sysenter_past_esp:
 	 * enough kernel state to call TRACE_IRQS_OFF can be called - but
 	 * we immediately enable interrupts at that point anyway.
 	 */
-	pushl_cfi $(__USER_DS)
+	pushl_cfi $__USER_DS
 	/*CFI_REL_OFFSET ss, 0*/
 	pushl_cfi %ebp
 	CFI_REL_OFFSET esp, 0
 	pushfl_cfi
 	orl $X86_EFLAGS_IF, (%esp)
-	pushl_cfi $(__USER_CS)
+	pushl_cfi $__USER_CS
 	/*CFI_REL_OFFSET cs, 0*/
 	/*
 	 * Push current_thread_info()->sysenter_return to the stack.
 	 * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
 	 * pushed above; +8 corresponds to copy_thread's esp0 setting.
 	 */
-	pushl_cfi (TI_sysenter_return-THREAD_SIZE+8+4*4)(%esp)
+	pushl_cfi TI_sysenter_return-THREAD_SIZE_asm+8+4*4(%esp)
 	CFI_REL_OFFSET eip, 0
 
 	pushl_cfi %eax
--- 2.6.36-rc8-x86-cfi.orig/arch/x86/kernel/entry_64.S
+++ 2.6.36-rc8-x86-cfi/arch/x86/kernel/entry_64.S
@@ -964,22 +964,10 @@ apicinterrupt X86_PLATFORM_IPI_VECTOR \
 	x86_platform_ipi smp_x86_platform_ipi
 
 #ifdef CONFIG_SMP
-apicinterrupt INVALIDATE_TLB_VECTOR_START+0 \
-	invalidate_interrupt0 smp_invalidate_interrupt
-apicinterrupt INVALIDATE_TLB_VECTOR_START+1 \
-	invalidate_interrupt1 smp_invalidate_interrupt
-apicinterrupt INVALIDATE_TLB_VECTOR_START+2 \
-	invalidate_interrupt2 smp_invalidate_interrupt
-apicinterrupt INVALIDATE_TLB_VECTOR_START+3 \
-	invalidate_interrupt3 smp_invalidate_interrupt
-apicinterrupt INVALIDATE_TLB_VECTOR_START+4 \
-	invalidate_interrupt4 smp_invalidate_interrupt
-apicinterrupt INVALIDATE_TLB_VECTOR_START+5 \
-	invalidate_interrupt5 smp_invalidate_interrupt
-apicinterrupt INVALIDATE_TLB_VECTOR_START+6 \
-	invalidate_interrupt6 smp_invalidate_interrupt
-apicinterrupt INVALIDATE_TLB_VECTOR_START+7 \
-	invalidate_interrupt7 smp_invalidate_interrupt
+.irpc idx, "01234567"
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+\idx \
+	invalidate_interrupt\idx smp_invalidate_interrupt
+.endr
 #endif
 
 apicinterrupt THRESHOLD_APIC_VECTOR \


