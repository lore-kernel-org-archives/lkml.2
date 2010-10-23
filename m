Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab0JWPBr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 11:01:47 -0400
Received: from www.tglx.de ([62.245.132.106]:48999 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab0JWPBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 11:01:46 -0400
Date: Sat, 23 Oct 2010 17:01:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 debug for 2.6.37
Message-ID: <alpine.LFD.2.00.1010231628100.2516@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-debug-for-linus


out-of-topic modifications in x86-debug-for-linus:
--------------------------------------------------
Kbuild                             # a22dcdb: x86, asm: Fix ancient-GAS workaro
                                   # 3234282: x86, asm: Fix CFI macro invocatio

Thanks,

	tglx

------------------>
Alexander van Heukelum (1):
      x86, asm: Fix ancient-GAS workaround

Jan Beulich (2):
      x86, asm: Fix CFI macro invocations to deal with shortcomings in gas
      x86, asm: Restore parentheses around one pushl_cfi argument


 Kbuild                            |    1 +
 arch/x86/include/asm/calling.h    |   52 +++++++++++++++++++-----------------
 arch/x86/include/asm/entry_arch.h |   19 +++----------
 arch/x86/include/asm/segment.h    |   32 +++++++++++-----------
 arch/x86/kernel/asm-offsets_32.c  |    4 +--
 arch/x86/kernel/entry_32.S        |    6 ++--
 arch/x86/kernel/entry_64.S        |   20 +++-----------
 7 files changed, 56 insertions(+), 78 deletions(-)

diff --git a/Kbuild b/Kbuild
index e3737ad..431f7ca 100644
--- a/Kbuild
+++ b/Kbuild
@@ -53,6 +53,7 @@ targets += arch/$(SRCARCH)/kernel/asm-offsets.s
 # Default sed regexp - multiline due to syntax constraints
 define sed-y
 	"/^->/{s:->#\(.*\):/* \1 */:; \
+	s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 (\2) /* \3 */:; \
 	s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
 	s:->::; p;}"
 endef
diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index 0e63c9a..30af5a8 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -48,36 +48,38 @@ For 32-bit we have the following conventions - kernel is built with
 
 
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
@@ -111,7 +113,7 @@ For 32-bit we have the following conventions - kernel is built with
 	.endif
 	.endm
 
-#define ARG_SKIP	9*8
+#define ARG_SKIP	(9*8)
 
 	.macro RESTORE_ARGS skiprax=0, addskip=0, skiprcx=0, skipr11=0, \
 			    skipr8910=0, skiprdx=0
@@ -169,7 +171,7 @@ For 32-bit we have the following conventions - kernel is built with
 	.endif
 	.endm
 
-#define REST_SKIP	6*8
+#define REST_SKIP	(6*8)
 
 	.macro SAVE_REST
 	subq $REST_SKIP, %rsp
diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index 8e8ec66..4d2966e 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -16,22 +16,11 @@ BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
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
diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 14e0ed8..231f1c1 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
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
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index dfdbf64..1a4088d 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -99,9 +99,7 @@ void foo(void)
 
 	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
 	DEFINE(PAGE_SHIFT_asm, PAGE_SHIFT);
-	DEFINE(PTRS_PER_PTE, PTRS_PER_PTE);
-	DEFINE(PTRS_PER_PMD, PTRS_PER_PMD);
-	DEFINE(PTRS_PER_PGD, PTRS_PER_PGD);
+	DEFINE(THREAD_SIZE_asm, THREAD_SIZE);
 
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
 
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 9fb188d..59e175e 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
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
+	pushl_cfi (TI_sysenter_return-THREAD_SIZE_asm+8+4*4)(%esp)
 	CFI_REL_OFFSET eip, 0
 
 	pushl_cfi %eax
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 8851a2b..9cc9a71 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -963,22 +963,10 @@ apicinterrupt X86_PLATFORM_IPI_VECTOR \
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
