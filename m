Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1GVObZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:31:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46558 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab1GVObX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:31:23 -0400
Date: Fri, 22 Jul 2011 16:30:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm changes for v3.1
Message-ID: <20110722143036.GA11939@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-asm-for-linus


out-of-topic modifications in x86-asm-for-linus:
------------------------------------------------
arch/um/sys-i386/Makefile          # a738669: x86: Unify rwsem assembly impleme
arch/um/sys-x86_64/Makefile        # a738669: x86: Unify rwsem assembly impleme

 Thanks,

	Ingo

------------------>
Borislav Petkov (5):
      x86, asm: Thin down SAVE/RESTORE_* asm macros
      x86, asm: Flip SAVE_ARGS arguments logic
      x86, asm: Flip RESTORE_ARGS arguments logic
      x86, asm: Cleanup thunk_64.S
      x86, asm: Fix binutils 2.16 issue with __USER32_CS

Jan Beulich (3):
      x86: Unify rwlock assembly implementation
      x86: Unify rwsem assembly implementation
      x86: Fix write lock scalability 64-bit issue


 arch/um/sys-i386/Makefile             |    2 +-
 arch/um/sys-x86_64/Makefile           |    2 +-
 arch/x86/ia32/ia32entry.S             |   10 +-
 arch/x86/include/asm/asm.h            |    5 +-
 arch/x86/include/asm/calling.h        |  130 +++++++++++++--------------------
 arch/x86/include/asm/frame.h          |   11 ++-
 arch/x86/include/asm/rwlock.h         |   43 +++++++++++-
 arch/x86/include/asm/segment.h        |    2 +-
 arch/x86/include/asm/spinlock.h       |   37 ++++++----
 arch/x86/include/asm/spinlock_types.h |    6 +-
 arch/x86/kernel/entry_64.S            |    6 +-
 arch/x86/lib/Makefile                 |    7 +-
 arch/x86/lib/rwlock.S                 |   44 +++++++++++
 arch/x86/lib/rwlock_64.S              |   38 ----------
 arch/x86/lib/{rwsem_64.S => rwsem.S}  |   75 +++++++++++++++----
 arch/x86/lib/semaphore_32.S           |  124 -------------------------------
 arch/x86/lib/thunk_64.S               |   45 +++++-------
 17 files changed, 263 insertions(+), 324 deletions(-)
 create mode 100644 arch/x86/lib/rwlock.S
 delete mode 100644 arch/x86/lib/rwlock_64.S
 rename arch/x86/lib/{rwsem_64.S => rwsem.S} (55%)
 delete mode 100644 arch/x86/lib/semaphore_32.S

diff --git a/arch/um/sys-i386/Makefile b/arch/um/sys-i386/Makefile
index b1da91c..15587ed 100644
--- a/arch/um/sys-i386/Makefile
+++ b/arch/um/sys-i386/Makefile
@@ -8,7 +8,7 @@ obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
 
 obj-$(CONFIG_BINFMT_ELF) += elfcore.o
 
-subarch-obj-y = lib/semaphore_32.o lib/string_32.o
+subarch-obj-y = lib/rwsem.o lib/string_32.o
 subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem_32.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
 
diff --git a/arch/um/sys-x86_64/Makefile b/arch/um/sys-x86_64/Makefile
index c1ea9eb..61fc99a 100644
--- a/arch/um/sys-x86_64/Makefile
+++ b/arch/um/sys-x86_64/Makefile
@@ -9,7 +9,7 @@ obj-y = bug.o bugs.o delay.o fault.o ldt.o mem.o ptrace.o ptrace_user.o \
 	sysrq.o ksyms.o tls.o
 
 subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o \
-		lib/rwsem_64.o
+		lib/rwsem.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
 
 ldt-y = ../sys-i386/ldt.o
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index c1870dd..a0e866d 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -143,7 +143,7 @@ ENTRY(ia32_sysenter_target)
 	CFI_REL_OFFSET rip,0
 	pushq_cfi %rax
 	cld
-	SAVE_ARGS 0,0,1
+	SAVE_ARGS 0,1,0
  	/* no need to do an access_ok check here because rbp has been
  	   32bit zero extended */ 
 1:	movl	(%rbp),%ebp
@@ -173,7 +173,7 @@ sysexit_from_sys_call:
 	andl  $~0x200,EFLAGS-R11(%rsp) 
 	movl	RIP-R11(%rsp),%edx		/* User %eip */
 	CFI_REGISTER rip,rdx
-	RESTORE_ARGS 1,24,1,1,1,1
+	RESTORE_ARGS 0,24,0,0,0,0
 	xorq	%r8,%r8
 	xorq	%r9,%r9
 	xorq	%r10,%r10
@@ -289,7 +289,7 @@ ENTRY(ia32_cstar_target)
 	 * disabled irqs and here we enable it straight after entry:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	SAVE_ARGS 8,1,1
+	SAVE_ARGS 8,0,0
 	movl 	%eax,%eax	/* zero extension */
 	movq	%rax,ORIG_RAX-ARGOFFSET(%rsp)
 	movq	%rcx,RIP-ARGOFFSET(%rsp)
@@ -328,7 +328,7 @@ cstar_dispatch:
 	jnz sysretl_audit
 sysretl_from_sys_call:
 	andl $~TS_COMPAT,TI_status(%r10)
-	RESTORE_ARGS 1,-ARG_SKIP,1,1,1
+	RESTORE_ARGS 0,-ARG_SKIP,0,0,0
 	movl RIP-ARGOFFSET(%rsp),%ecx
 	CFI_REGISTER rip,rcx
 	movl EFLAGS-ARGOFFSET(%rsp),%r11d	
@@ -419,7 +419,7 @@ ENTRY(ia32_syscall)
 	cld
 	/* note the registers are not zero extended to the sf.
 	   this could be a problem. */
-	SAVE_ARGS 0,0,1
+	SAVE_ARGS 0,1,0
 	GET_THREAD_INFO(%r10)
 	orl   $TS_COMPAT,TI_status(%r10)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index b3ed1e1..9412d65 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -3,9 +3,11 @@
 
 #ifdef __ASSEMBLY__
 # define __ASM_FORM(x)	x
+# define __ASM_FORM_COMMA(x) x,
 # define __ASM_EX_SEC	.section __ex_table, "a"
 #else
 # define __ASM_FORM(x)	" " #x " "
+# define __ASM_FORM_COMMA(x) " " #x ","
 # define __ASM_EX_SEC	" .section __ex_table,\"a\"\n"
 #endif
 
@@ -15,7 +17,8 @@
 # define __ASM_SEL(a,b) __ASM_FORM(b)
 #endif
 
-#define __ASM_SIZE(inst)	__ASM_SEL(inst##l, inst##q)
+#define __ASM_SIZE(inst, ...)	__ASM_SEL(inst##l##__VA_ARGS__, \
+					  inst##q##__VA_ARGS__)
 #define __ASM_REG(reg)		__ASM_SEL(e##reg, r##reg)
 
 #define _ASM_PTR	__ASM_SEL(.long, .quad)
diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index 30af5a8..a9e3a74 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -46,6 +46,7 @@ For 32-bit we have the following conventions - kernel is built with
 
 */
 
+#include "dwarf2.h"
 
 /*
  * 64-bit system call stack frame layout defines and helpers, for
@@ -84,72 +85,57 @@ For 32-bit we have the following conventions - kernel is built with
 #define ARGOFFSET	R11
 #define SWFRAME		ORIG_RAX
 
-	.macro SAVE_ARGS addskip=0, norcx=0, nor891011=0
+	.macro SAVE_ARGS addskip=0, save_rcx=1, save_r891011=1
 	subq  $9*8+\addskip, %rsp
 	CFI_ADJUST_CFA_OFFSET	9*8+\addskip
-	movq  %rdi, 8*8(%rsp)
-	CFI_REL_OFFSET	rdi, 8*8
-	movq  %rsi, 7*8(%rsp)
-	CFI_REL_OFFSET	rsi, 7*8
-	movq  %rdx, 6*8(%rsp)
-	CFI_REL_OFFSET	rdx, 6*8
-	.if \norcx
-	.else
-	movq  %rcx, 5*8(%rsp)
-	CFI_REL_OFFSET	rcx, 5*8
+	movq_cfi rdi, 8*8
+	movq_cfi rsi, 7*8
+	movq_cfi rdx, 6*8
+
+	.if \save_rcx
+	movq_cfi rcx, 5*8
 	.endif
-	movq  %rax, 4*8(%rsp)
-	CFI_REL_OFFSET	rax, 4*8
-	.if \nor891011
-	.else
-	movq  %r8, 3*8(%rsp)
-	CFI_REL_OFFSET	r8,  3*8
-	movq  %r9, 2*8(%rsp)
-	CFI_REL_OFFSET	r9,  2*8
-	movq  %r10, 1*8(%rsp)
-	CFI_REL_OFFSET	r10, 1*8
-	movq  %r11, (%rsp)
-	CFI_REL_OFFSET	r11, 0*8
+
+	movq_cfi rax, 4*8
+
+	.if \save_r891011
+	movq_cfi r8,  3*8
+	movq_cfi r9,  2*8
+	movq_cfi r10, 1*8
+	movq_cfi r11, 0*8
 	.endif
+
 	.endm
 
 #define ARG_SKIP	(9*8)
 
-	.macro RESTORE_ARGS skiprax=0, addskip=0, skiprcx=0, skipr11=0, \
-			    skipr8910=0, skiprdx=0
-	.if \skipr11
-	.else
-	movq (%rsp), %r11
-	CFI_RESTORE r11
+	.macro RESTORE_ARGS rstor_rax=1, addskip=0, rstor_rcx=1, rstor_r11=1, \
+			    rstor_r8910=1, rstor_rdx=1
+	.if \rstor_r11
+	movq_cfi_restore 0*8, r11
 	.endif
-	.if \skipr8910
-	.else
-	movq 1*8(%rsp), %r10
-	CFI_RESTORE r10
-	movq 2*8(%rsp), %r9
-	CFI_RESTORE r9
-	movq 3*8(%rsp), %r8
-	CFI_RESTORE r8
+
+	.if \rstor_r8910
+	movq_cfi_restore 1*8, r10
+	movq_cfi_restore 2*8, r9
+	movq_cfi_restore 3*8, r8
 	.endif
-	.if \skiprax
-	.else
-	movq 4*8(%rsp), %rax
-	CFI_RESTORE rax
+
+	.if \rstor_rax
+	movq_cfi_restore 4*8, rax
 	.endif
-	.if \skiprcx
-	.else
-	movq 5*8(%rsp), %rcx
-	CFI_RESTORE rcx
+
+	.if \rstor_rcx
+	movq_cfi_restore 5*8, rcx
 	.endif
-	.if \skiprdx
-	.else
-	movq 6*8(%rsp), %rdx
-	CFI_RESTORE rdx
+
+	.if \rstor_rdx
+	movq_cfi_restore 6*8, rdx
 	.endif
-	movq 7*8(%rsp), %rsi
-	CFI_RESTORE rsi
-	movq 8*8(%rsp), %rdi
-	CFI_RESTORE rdi
+
+	movq_cfi_restore 7*8, rsi
+	movq_cfi_restore 8*8, rdi
+
 	.if ARG_SKIP+\addskip > 0
 	addq $ARG_SKIP+\addskip, %rsp
 	CFI_ADJUST_CFA_OFFSET	-(ARG_SKIP+\addskip)
@@ -176,33 +162,21 @@ For 32-bit we have the following conventions - kernel is built with
 	.macro SAVE_REST
 	subq $REST_SKIP, %rsp
 	CFI_ADJUST_CFA_OFFSET	REST_SKIP
-	movq %rbx, 5*8(%rsp)
-	CFI_REL_OFFSET	rbx, 5*8
-	movq %rbp, 4*8(%rsp)
-	CFI_REL_OFFSET	rbp, 4*8
-	movq %r12, 3*8(%rsp)
-	CFI_REL_OFFSET	r12, 3*8
-	movq %r13, 2*8(%rsp)
-	CFI_REL_OFFSET	r13, 2*8
-	movq %r14, 1*8(%rsp)
-	CFI_REL_OFFSET	r14, 1*8
-	movq %r15, (%rsp)
-	CFI_REL_OFFSET	r15, 0*8
+	movq_cfi rbx, 5*8
+	movq_cfi rbp, 4*8
+	movq_cfi r12, 3*8
+	movq_cfi r13, 2*8
+	movq_cfi r14, 1*8
+	movq_cfi r15, 0*8
 	.endm
 
 	.macro RESTORE_REST
-	movq (%rsp),     %r15
-	CFI_RESTORE r15
-	movq 1*8(%rsp),  %r14
-	CFI_RESTORE r14
-	movq 2*8(%rsp),  %r13
-	CFI_RESTORE r13
-	movq 3*8(%rsp),  %r12
-	CFI_RESTORE r12
-	movq 4*8(%rsp),  %rbp
-	CFI_RESTORE rbp
-	movq 5*8(%rsp),  %rbx
-	CFI_RESTORE rbx
+	movq_cfi_restore 0*8, r15
+	movq_cfi_restore 1*8, r14
+	movq_cfi_restore 2*8, r13
+	movq_cfi_restore 3*8, r12
+	movq_cfi_restore 4*8, rbp
+	movq_cfi_restore 5*8, rbx
 	addq $REST_SKIP, %rsp
 	CFI_ADJUST_CFA_OFFSET	-(REST_SKIP)
 	.endm
@@ -214,7 +188,7 @@ For 32-bit we have the following conventions - kernel is built with
 
 	.macro RESTORE_ALL addskip=0
 	RESTORE_REST
-	RESTORE_ARGS 0, \addskip
+	RESTORE_ARGS 1, \addskip
 	.endm
 
 	.macro icebp
diff --git a/arch/x86/include/asm/frame.h b/arch/x86/include/asm/frame.h
index 2c6fc9e..3b629f4 100644
--- a/arch/x86/include/asm/frame.h
+++ b/arch/x86/include/asm/frame.h
@@ -1,5 +1,6 @@
 #ifdef __ASSEMBLY__
 
+#include <asm/asm.h>
 #include <asm/dwarf2.h>
 
 /* The annotation hides the frame from the unwinder and makes it look
@@ -7,13 +8,13 @@
    frame pointer later */
 #ifdef CONFIG_FRAME_POINTER
 	.macro FRAME
-	pushl_cfi %ebp
-	CFI_REL_OFFSET ebp,0
-	movl %esp,%ebp
+	__ASM_SIZE(push,_cfi)	%__ASM_REG(bp)
+	CFI_REL_OFFSET		__ASM_REG(bp), 0
+	__ASM_SIZE(mov)		%__ASM_REG(sp), %__ASM_REG(bp)
 	.endm
 	.macro ENDFRAME
-	popl_cfi %ebp
-	CFI_RESTORE ebp
+	__ASM_SIZE(pop,_cfi)	%__ASM_REG(bp)
+	CFI_RESTORE		__ASM_REG(bp)
 	.endm
 #else
 	.macro FRAME
diff --git a/arch/x86/include/asm/rwlock.h b/arch/x86/include/asm/rwlock.h
index 6a8c0d6..a5370a0 100644
--- a/arch/x86/include/asm/rwlock.h
+++ b/arch/x86/include/asm/rwlock.h
@@ -1,7 +1,48 @@
 #ifndef _ASM_X86_RWLOCK_H
 #define _ASM_X86_RWLOCK_H
 
-#define RW_LOCK_BIAS		 0x01000000
+#include <asm/asm.h>
+
+#if CONFIG_NR_CPUS <= 2048
+
+#ifndef __ASSEMBLY__
+typedef union {
+	s32 lock;
+	s32 write;
+} arch_rwlock_t;
+#endif
+
+#define RW_LOCK_BIAS		0x00100000
+#define READ_LOCK_SIZE(insn)	__ASM_FORM(insn##l)
+#define READ_LOCK_ATOMIC(n)	atomic_##n
+#define WRITE_LOCK_ADD(n)	__ASM_FORM_COMMA(addl n)
+#define WRITE_LOCK_SUB(n)	__ASM_FORM_COMMA(subl n)
+#define WRITE_LOCK_CMP		RW_LOCK_BIAS
+
+#else /* CONFIG_NR_CPUS > 2048 */
+
+#include <linux/const.h>
+
+#ifndef __ASSEMBLY__
+typedef union {
+	s64 lock;
+	struct {
+		u32 read;
+		s32 write;
+	};
+} arch_rwlock_t;
+#endif
+
+#define RW_LOCK_BIAS		(_AC(1,L) << 32)
+#define READ_LOCK_SIZE(insn)	__ASM_FORM(insn##q)
+#define READ_LOCK_ATOMIC(n)	atomic64_##n
+#define WRITE_LOCK_ADD(n)	__ASM_FORM(incl)
+#define WRITE_LOCK_SUB(n)	__ASM_FORM(decl)
+#define WRITE_LOCK_CMP		1
+
+#endif /* CONFIG_NR_CPUS */
+
+#define __ARCH_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
 
 /* Actual code is in asm/spinlock.h or in arch/x86/lib/rwlock.S */
 
diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index cd84f72..5e64171 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -162,7 +162,7 @@
 #define GDT_ENTRY_DEFAULT_USER32_CS 4
 #define GDT_ENTRY_DEFAULT_USER_DS 5
 #define GDT_ENTRY_DEFAULT_USER_CS 6
-#define __USER32_CS   (GDT_ENTRY_DEFAULT_USER32_CS * 8 + 3)
+#define __USER32_CS   (GDT_ENTRY_DEFAULT_USER32_CS*8+3)
 #define __USER32_DS	__USER_DS
 
 #define GDT_ENTRY_TSS 8	/* needs two entries */
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 3089f70..e9e51f7 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -2,7 +2,6 @@
 #define _ASM_X86_SPINLOCK_H
 
 #include <asm/atomic.h>
-#include <asm/rwlock.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 #include <linux/compiler.h>
@@ -234,7 +233,7 @@ static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
  */
 static inline int arch_read_can_lock(arch_rwlock_t *lock)
 {
-	return (int)(lock)->lock > 0;
+	return lock->lock > 0;
 }
 
 /**
@@ -243,12 +242,12 @@ static inline int arch_read_can_lock(arch_rwlock_t *lock)
  */
 static inline int arch_write_can_lock(arch_rwlock_t *lock)
 {
-	return (lock)->lock == RW_LOCK_BIAS;
+	return lock->write == WRITE_LOCK_CMP;
 }
 
 static inline void arch_read_lock(arch_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX " subl $1,(%0)\n\t"
+	asm volatile(LOCK_PREFIX READ_LOCK_SIZE(dec) " (%0)\n\t"
 		     "jns 1f\n"
 		     "call __read_lock_failed\n\t"
 		     "1:\n"
@@ -257,47 +256,55 @@ static inline void arch_read_lock(arch_rwlock_t *rw)
 
 static inline void arch_write_lock(arch_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX " subl %1,(%0)\n\t"
+	asm volatile(LOCK_PREFIX WRITE_LOCK_SUB(%1) "(%0)\n\t"
 		     "jz 1f\n"
 		     "call __write_lock_failed\n\t"
 		     "1:\n"
-		     ::LOCK_PTR_REG (rw), "i" (RW_LOCK_BIAS) : "memory");
+		     ::LOCK_PTR_REG (&rw->write), "i" (RW_LOCK_BIAS)
+		     : "memory");
 }
 
 static inline int arch_read_trylock(arch_rwlock_t *lock)
 {
-	atomic_t *count = (atomic_t *)lock;
+	READ_LOCK_ATOMIC(t) *count = (READ_LOCK_ATOMIC(t) *)lock;
 
-	if (atomic_dec_return(count) >= 0)
+	if (READ_LOCK_ATOMIC(dec_return)(count) >= 0)
 		return 1;
-	atomic_inc(count);
+	READ_LOCK_ATOMIC(inc)(count);
 	return 0;
 }
 
 static inline int arch_write_trylock(arch_rwlock_t *lock)
 {
-	atomic_t *count = (atomic_t *)lock;
+	atomic_t *count = (atomic_t *)&lock->write;
 
-	if (atomic_sub_and_test(RW_LOCK_BIAS, count))
+	if (atomic_sub_and_test(WRITE_LOCK_CMP, count))
 		return 1;
-	atomic_add(RW_LOCK_BIAS, count);
+	atomic_add(WRITE_LOCK_CMP, count);
 	return 0;
 }
 
 static inline void arch_read_unlock(arch_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX "incl %0" :"+m" (rw->lock) : : "memory");
+	asm volatile(LOCK_PREFIX READ_LOCK_SIZE(inc) " %0"
+		     :"+m" (rw->lock) : : "memory");
 }
 
 static inline void arch_write_unlock(arch_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX "addl %1, %0"
-		     : "+m" (rw->lock) : "i" (RW_LOCK_BIAS) : "memory");
+	asm volatile(LOCK_PREFIX WRITE_LOCK_ADD(%1) "%0"
+		     : "+m" (rw->write) : "i" (RW_LOCK_BIAS) : "memory");
 }
 
 #define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
 #define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
 
+#undef READ_LOCK_SIZE
+#undef READ_LOCK_ATOMIC
+#undef WRITE_LOCK_ADD
+#undef WRITE_LOCK_SUB
+#undef WRITE_LOCK_CMP
+
 #define arch_spin_relax(lock)	cpu_relax()
 #define arch_read_relax(lock)	cpu_relax()
 #define arch_write_relax(lock)	cpu_relax()
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index dcb48b2..7c7a486 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -11,10 +11,6 @@ typedef struct arch_spinlock {
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
 
-typedef struct {
-	unsigned int lock;
-} arch_rwlock_t;
-
-#define __ARCH_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
+#include <asm/rwlock.h>
 
 #endif /* _ASM_X86_SPINLOCK_TYPES_H */
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 8a445a0..0412bcb 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -473,7 +473,7 @@ ENTRY(system_call_after_swapgs)
 	 * and short:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	SAVE_ARGS 8,1
+	SAVE_ARGS 8,0
 	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
@@ -508,7 +508,7 @@ sysret_check:
 	TRACE_IRQS_ON
 	movq RIP-ARGOFFSET(%rsp),%rcx
 	CFI_REGISTER	rip,rcx
-	RESTORE_ARGS 0,-ARG_SKIP,1
+	RESTORE_ARGS 1,-ARG_SKIP,0
 	/*CFI_REGISTER	rflags,r11*/
 	movq	PER_CPU_VAR(old_rsp), %rsp
 	USERGS_SYSRET64
@@ -858,7 +858,7 @@ retint_restore_args:	/* return to kernel space */
 	 */
 	TRACE_IRQS_IRETQ
 restore_args:
-	RESTORE_ARGS 0,8,0
+	RESTORE_ARGS 1,8,1
 
 irq_return:
 	INTERRUPT_RETURN
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index f2479f1..5d46ddc 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -20,6 +20,8 @@ lib-y := delay.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
+lib-$(CONFIG_SMP) += rwlock.o
+lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o
 
 obj-y += msr.o msr-reg.o msr-reg-export.o
@@ -29,7 +31,7 @@ ifeq ($(CONFIG_X86_32),y)
         lib-y += atomic64_cx8_32.o
         lib-y += checksum_32.o
         lib-y += strstr_32.o
-        lib-y += semaphore_32.o string_32.o
+        lib-y += string_32.o
         lib-y += cmpxchg.o
 ifneq ($(CONFIG_X86_CMPXCHG64),y)
         lib-y += cmpxchg8b_emu.o atomic64_386_32.o
@@ -40,7 +42,6 @@ else
         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
         lib-y += thunk_64.o clear_page_64.o copy_page_64.o
         lib-y += memmove_64.o memset_64.o
-        lib-y += copy_user_64.o rwlock_64.o copy_user_nocache_64.o
-	lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem_64.o
+        lib-y += copy_user_64.o copy_user_nocache_64.o
 	lib-y += cmpxchg16b_emu.o
 endif
diff --git a/arch/x86/lib/rwlock.S b/arch/x86/lib/rwlock.S
new file mode 100644
index 0000000..1cad221
--- /dev/null
+++ b/arch/x86/lib/rwlock.S
@@ -0,0 +1,44 @@
+/* Slow paths of read/write spinlocks. */
+
+#include <linux/linkage.h>
+#include <asm/alternative-asm.h>
+#include <asm/frame.h>
+#include <asm/rwlock.h>
+
+#ifdef CONFIG_X86_32
+# define __lock_ptr eax
+#else
+# define __lock_ptr rdi
+#endif
+
+ENTRY(__write_lock_failed)
+	CFI_STARTPROC
+	FRAME
+0:	LOCK_PREFIX
+	WRITE_LOCK_ADD($RW_LOCK_BIAS) (%__lock_ptr)
+1:	rep; nop
+	cmpl	$WRITE_LOCK_CMP, (%__lock_ptr)
+	jne	1b
+	LOCK_PREFIX
+	WRITE_LOCK_SUB($RW_LOCK_BIAS) (%__lock_ptr)
+	jnz	0b
+	ENDFRAME
+	ret
+	CFI_ENDPROC
+END(__write_lock_failed)
+
+ENTRY(__read_lock_failed)
+	CFI_STARTPROC
+	FRAME
+0:	LOCK_PREFIX
+	READ_LOCK_SIZE(inc) (%__lock_ptr)
+1:	rep; nop
+	READ_LOCK_SIZE(cmp) $1, (%__lock_ptr)
+	js	1b
+	LOCK_PREFIX
+	READ_LOCK_SIZE(dec) (%__lock_ptr)
+	js	0b
+	ENDFRAME
+	ret
+	CFI_ENDPROC
+END(__read_lock_failed)
diff --git a/arch/x86/lib/rwlock_64.S b/arch/x86/lib/rwlock_64.S
deleted file mode 100644
index 05ea55f..0000000
--- a/arch/x86/lib/rwlock_64.S
+++ /dev/null
@@ -1,38 +0,0 @@
-/* Slow paths of read/write spinlocks. */
-
-#include <linux/linkage.h>
-#include <asm/rwlock.h>
-#include <asm/alternative-asm.h>
-#include <asm/dwarf2.h>
-
-/* rdi:	pointer to rwlock_t */
-ENTRY(__write_lock_failed)
-	CFI_STARTPROC
-	LOCK_PREFIX
-	addl $RW_LOCK_BIAS,(%rdi)
-1:	rep
-	nop
-	cmpl $RW_LOCK_BIAS,(%rdi)
-	jne 1b
-	LOCK_PREFIX
-	subl $RW_LOCK_BIAS,(%rdi)
-	jnz  __write_lock_failed
-	ret
-	CFI_ENDPROC
-END(__write_lock_failed)
-
-/* rdi:	pointer to rwlock_t */
-ENTRY(__read_lock_failed)
-	CFI_STARTPROC
-	LOCK_PREFIX
-	incl (%rdi)
-1:	rep
-	nop
-	cmpl $1,(%rdi)
-	js 1b
-	LOCK_PREFIX
-	decl (%rdi)
-	js __read_lock_failed
-	ret
-	CFI_ENDPROC
-END(__read_lock_failed)
diff --git a/arch/x86/lib/rwsem_64.S b/arch/x86/lib/rwsem.S
similarity index 55%
rename from arch/x86/lib/rwsem_64.S
rename to arch/x86/lib/rwsem.S
index 6774397..5dff5f0 100644
--- a/arch/x86/lib/rwsem_64.S
+++ b/arch/x86/lib/rwsem.S
@@ -1,4 +1,51 @@
 /*
+ * x86 semaphore implementation.
+ *
+ * (C) Copyright 1999 Linus Torvalds
+ *
+ * Portions Copyright 1999 Red Hat, Inc.
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ * rw semaphores implemented November 1999 by Benjamin LaHaise <bcrl@kvack.org>
+ */
+
+#include <linux/linkage.h>
+#include <asm/alternative-asm.h>
+#include <asm/dwarf2.h>
+
+#define __ASM_HALF_REG(reg)	__ASM_SEL(reg, e##reg)
+#define __ASM_HALF_SIZE(inst)	__ASM_SEL(inst##w, inst##l)
+
+#ifdef CONFIG_X86_32
+
+/*
+ * The semaphore operations have a special calling sequence that
+ * allow us to do a simpler in-line version of them. These routines
+ * need to convert that sequence back into the C sequence when
+ * there is contention on the semaphore.
+ *
+ * %eax contains the semaphore pointer on entry. Save the C-clobbered
+ * registers (%eax, %edx and %ecx) except %eax whish is either a return
+ * value or just clobbered..
+ */
+
+#define save_common_regs \
+	pushl_cfi %ecx; CFI_REL_OFFSET ecx, 0
+
+#define restore_common_regs \
+	popl_cfi %ecx; CFI_RESTORE ecx
+
+	/* Avoid uglifying the argument copying x86-64 needs to do. */
+	.macro movq src, dst
+	.endm
+
+#else
+
+/*
  * x86-64 rwsem wrappers
  *
  * This interfaces the inline asm code to the slow-path
@@ -16,12 +63,6 @@
  * but %rdi, %rsi, %rcx, %r8-r11 always need saving.
  */
 
-#include <linux/linkage.h>
-#include <asm/rwlock.h>
-#include <asm/alternative-asm.h>
-#include <asm/frame.h>
-#include <asm/dwarf2.h>
-
 #define save_common_regs \
 	pushq_cfi %rdi; CFI_REL_OFFSET rdi, 0; \
 	pushq_cfi %rsi; CFI_REL_OFFSET rsi, 0; \
@@ -40,16 +81,18 @@
 	popq_cfi %rsi; CFI_RESTORE rsi; \
 	popq_cfi %rdi; CFI_RESTORE rdi
 
+#endif
+
 /* Fix up special calling conventions */
 ENTRY(call_rwsem_down_read_failed)
 	CFI_STARTPROC
 	save_common_regs
-	pushq_cfi %rdx
-	CFI_REL_OFFSET rdx, 0
+	__ASM_SIZE(push,_cfi) %__ASM_REG(dx)
+	CFI_REL_OFFSET __ASM_REG(dx), 0
 	movq %rax,%rdi
 	call rwsem_down_read_failed
-	popq_cfi %rdx
-	CFI_RESTORE rdx
+	__ASM_SIZE(pop,_cfi) %__ASM_REG(dx)
+	CFI_RESTORE __ASM_REG(dx)
 	restore_common_regs
 	ret
 	CFI_ENDPROC
@@ -67,7 +110,8 @@ ENDPROC(call_rwsem_down_write_failed)
 
 ENTRY(call_rwsem_wake)
 	CFI_STARTPROC
-	decl %edx	/* do nothing if still outstanding active readers */
+	/* do nothing if still outstanding active readers */
+	__ASM_HALF_SIZE(dec) %__ASM_HALF_REG(dx)
 	jnz 1f
 	save_common_regs
 	movq %rax,%rdi
@@ -77,16 +121,15 @@ ENTRY(call_rwsem_wake)
 	CFI_ENDPROC
 ENDPROC(call_rwsem_wake)
 
-/* Fix up special calling conventions */
 ENTRY(call_rwsem_downgrade_wake)
 	CFI_STARTPROC
 	save_common_regs
-	pushq_cfi %rdx
-	CFI_REL_OFFSET rdx, 0
+	__ASM_SIZE(push,_cfi) %__ASM_REG(dx)
+	CFI_REL_OFFSET __ASM_REG(dx), 0
 	movq %rax,%rdi
 	call rwsem_downgrade_wake
-	popq_cfi %rdx
-	CFI_RESTORE rdx
+	__ASM_SIZE(pop,_cfi) %__ASM_REG(dx)
+	CFI_RESTORE __ASM_REG(dx)
 	restore_common_regs
 	ret
 	CFI_ENDPROC
diff --git a/arch/x86/lib/semaphore_32.S b/arch/x86/lib/semaphore_32.S
deleted file mode 100644
index 06691da..0000000
--- a/arch/x86/lib/semaphore_32.S
+++ /dev/null
@@ -1,124 +0,0 @@
-/*
- * i386 semaphore implementation.
- *
- * (C) Copyright 1999 Linus Torvalds
- *
- * Portions Copyright 1999 Red Hat, Inc.
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License
- *	as published by the Free Software Foundation; either version
- *	2 of the License, or (at your option) any later version.
- *
- * rw semaphores implemented November 1999 by Benjamin LaHaise <bcrl@kvack.org>
- */
-
-#include <linux/linkage.h>
-#include <asm/rwlock.h>
-#include <asm/alternative-asm.h>
-#include <asm/frame.h>
-#include <asm/dwarf2.h>
-
-/*
- * The semaphore operations have a special calling sequence that
- * allow us to do a simpler in-line version of them. These routines
- * need to convert that sequence back into the C sequence when
- * there is contention on the semaphore.
- *
- * %eax contains the semaphore pointer on entry. Save the C-clobbered
- * registers (%eax, %edx and %ecx) except %eax whish is either a return
- * value or just clobbered..
- */
-	.section .sched.text, "ax"
-
-/*
- * rw spinlock fallbacks
- */
-#ifdef CONFIG_SMP
-ENTRY(__write_lock_failed)
-	CFI_STARTPROC
-	FRAME
-2: 	LOCK_PREFIX
-	addl	$ RW_LOCK_BIAS,(%eax)
-1:	rep; nop
-	cmpl	$ RW_LOCK_BIAS,(%eax)
-	jne	1b
-	LOCK_PREFIX
-	subl	$ RW_LOCK_BIAS,(%eax)
-	jnz	2b
-	ENDFRAME
-	ret
-	CFI_ENDPROC
-	ENDPROC(__write_lock_failed)
-
-ENTRY(__read_lock_failed)
-	CFI_STARTPROC
-	FRAME
-2: 	LOCK_PREFIX
-	incl	(%eax)
-1:	rep; nop
-	cmpl	$1,(%eax)
-	js	1b
-	LOCK_PREFIX
-	decl	(%eax)
-	js	2b
-	ENDFRAME
-	ret
-	CFI_ENDPROC
-	ENDPROC(__read_lock_failed)
-
-#endif
-
-#ifdef CONFIG_RWSEM_XCHGADD_ALGORITHM
-
-/* Fix up special calling conventions */
-ENTRY(call_rwsem_down_read_failed)
-	CFI_STARTPROC
-	pushl_cfi %ecx
-	CFI_REL_OFFSET ecx,0
-	pushl_cfi %edx
-	CFI_REL_OFFSET edx,0
-	call rwsem_down_read_failed
-	popl_cfi %edx
-	popl_cfi %ecx
-	ret
-	CFI_ENDPROC
-	ENDPROC(call_rwsem_down_read_failed)
-
-ENTRY(call_rwsem_down_write_failed)
-	CFI_STARTPROC
-	pushl_cfi %ecx
-	CFI_REL_OFFSET ecx,0
-	calll rwsem_down_write_failed
-	popl_cfi %ecx
-	ret
-	CFI_ENDPROC
-	ENDPROC(call_rwsem_down_write_failed)
-
-ENTRY(call_rwsem_wake)
-	CFI_STARTPROC
-	decw %dx    /* do nothing if still outstanding active readers */
-	jnz 1f
-	pushl_cfi %ecx
-	CFI_REL_OFFSET ecx,0
-	call rwsem_wake
-	popl_cfi %ecx
-1:	ret
-	CFI_ENDPROC
-	ENDPROC(call_rwsem_wake)
-
-/* Fix up special calling conventions */
-ENTRY(call_rwsem_downgrade_wake)
-	CFI_STARTPROC
-	pushl_cfi %ecx
-	CFI_REL_OFFSET ecx,0
-	pushl_cfi %edx
-	CFI_REL_OFFSET edx,0
-	call rwsem_downgrade_wake
-	popl_cfi %edx
-	popl_cfi %ecx
-	ret
-	CFI_ENDPROC
-	ENDPROC(call_rwsem_downgrade_wake)
-
-#endif
diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
index 782b082..a63efd6 100644
--- a/arch/x86/lib/thunk_64.S
+++ b/arch/x86/lib/thunk_64.S
@@ -5,50 +5,41 @@
  * Added trace_hardirqs callers - Copyright 2007 Steven Rostedt, Red Hat, Inc.
  * Subject to the GNU public license, v.2. No warranty of any kind.
  */
+#include <linux/linkage.h>
+#include <asm/dwarf2.h>
+#include <asm/calling.h>
 
-	#include <linux/linkage.h>
-	#include <asm/dwarf2.h>
-	#include <asm/calling.h>			
-	#include <asm/rwlock.h>
-		
-	/* rdi:	arg1 ... normal C conventions. rax is saved/restored. */ 	
-	.macro thunk name,func
-	.globl \name
-\name:	
-	CFI_STARTPROC
-	SAVE_ARGS
-	call \func
-	jmp  restore
-	CFI_ENDPROC
-	.endm
-
-#ifdef CONFIG_TRACE_IRQFLAGS
-	/* put return address in rdi (arg1) */
-	.macro thunk_ra name,func
+	/* rdi:	arg1 ... normal C conventions. rax is saved/restored. */
+	.macro THUNK name, func, put_ret_addr_in_rdi=0
 	.globl \name
 \name:
 	CFI_STARTPROC
+
+	/* this one pushes 9 elems, the next one would be %rIP */
 	SAVE_ARGS
-	/* SAVE_ARGS pushs 9 elements */
-	/* the next element would be the rip */
-	movq 9*8(%rsp), %rdi
+
+	.if \put_ret_addr_in_rdi
+	movq_cfi_restore 9*8, rdi
+	.endif
+
 	call \func
 	jmp  restore
 	CFI_ENDPROC
 	.endm
 
-	thunk_ra trace_hardirqs_on_thunk,trace_hardirqs_on_caller
-	thunk_ra trace_hardirqs_off_thunk,trace_hardirqs_off_caller
+#ifdef CONFIG_TRACE_IRQFLAGS
+	THUNK trace_hardirqs_on_thunk,trace_hardirqs_on_caller,1
+	THUNK trace_hardirqs_off_thunk,trace_hardirqs_off_caller,1
 #endif
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-	thunk lockdep_sys_exit_thunk,lockdep_sys_exit
+	THUNK lockdep_sys_exit_thunk,lockdep_sys_exit
 #endif
-	
+
 	/* SAVE_ARGS below is used only for the .cfi directives it contains. */
 	CFI_STARTPROC
 	SAVE_ARGS
 restore:
 	RESTORE_ARGS
-	ret	
+	ret
 	CFI_ENDPROC
