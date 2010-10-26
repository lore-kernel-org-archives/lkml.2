Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab0JZCz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:55:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577Ab0JZCzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:55:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 30/43] MN10300: Make the FPU operate in non-lazy mode under
 SMP
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:55:41 +0100
Message-ID: <20101026025541.23512.21899.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

Make the FPU operate in non-lazy mode under SMP so that when the process that
is currently using the FPU migrates to a different CPU, we don't have to ping
its previous CPU to flush the FPU context.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/Kconfig                    |   15 ++
 arch/mn10300/include/asm/elf.h          |    2 
 arch/mn10300/include/asm/exceptions.h   |    1 
 arch/mn10300/include/asm/fpu.h          |  157 ++++++++++++------
 arch/mn10300/include/asm/processor.h    |    1 
 arch/mn10300/include/asm/system.h       |   16 ++
 arch/mn10300/kernel/Makefile            |    8 +
 arch/mn10300/kernel/asm-offsets.c       |    9 +
 arch/mn10300/kernel/fpu-low.S           |  265 +++++++++++++++++++------------
 arch/mn10300/kernel/fpu-nofpu-low.S     |   39 +++++
 arch/mn10300/kernel/fpu-nofpu.c         |   30 ++++
 arch/mn10300/kernel/fpu.c               |  141 +++++++---------
 arch/mn10300/kernel/traps.c             |    2 
 arch/mn10300/proc-mn103e010/proc-init.c |    2 
 14 files changed, 440 insertions(+), 248 deletions(-)
 create mode 100644 arch/mn10300/kernel/fpu-nofpu-low.S
 create mode 100644 arch/mn10300/kernel/fpu-nofpu.c


diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 7bd920b..a1f334c 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -140,6 +140,21 @@ config FPU
 	default y
 	depends on MN10300_PROC_MN103E010
 
+config LAZY_SAVE_FPU
+	bool "Save FPU state lazily"
+	default y
+	depends on FPU && !SMP
+	help
+	  Enable this to be lazy in the saving of the FPU state to the owning
+	  task's thread struct.  This is useful if most tasks on the system
+	  don't use the FPU as only those tasks that use it will pass it
+	  between them, and the state needn't be saved for a task that isn't
+	  using it.
+
+	  This can't be so easily used on SMP as the process that owns the FPU
+	  state on a CPU may be currently running on another CPU, so for the
+	  moment, it is disabled.
+
 source "arch/mn10300/mm/Kconfig.cache"
 
 config MN10300_TLB_USE_PIDR
diff --git a/arch/mn10300/include/asm/elf.h b/arch/mn10300/include/asm/elf.h
index e5fa97c..a30d220 100644
--- a/arch/mn10300/include/asm/elf.h
+++ b/arch/mn10300/include/asm/elf.h
@@ -47,8 +47,6 @@ typedef struct {
 	u_int32_t	fpcr;
 } elf_fpregset_t;
 
-extern int dump_fpu(struct pt_regs *, elf_fpregset_t *);
-
 /*
  * This is used to ensure we don't load something for the wrong architecture
  */
diff --git a/arch/mn10300/include/asm/exceptions.h b/arch/mn10300/include/asm/exceptions.h
index 3f3826a..7d8080b 100644
--- a/arch/mn10300/include/asm/exceptions.h
+++ b/arch/mn10300/include/asm/exceptions.h
@@ -101,7 +101,6 @@ extern asmlinkage void dtlb_aerror(void);
 extern asmlinkage void raw_bus_error(void);
 extern asmlinkage void double_fault(void);
 extern asmlinkage int  system_call(struct pt_regs *);
-extern asmlinkage void fpu_exception(struct pt_regs *, enum exception_code);
 extern asmlinkage void nmi(struct pt_regs *, enum exception_code);
 extern asmlinkage void uninitialised_exception(struct pt_regs *,
 					       enum exception_code);
diff --git a/arch/mn10300/include/asm/fpu.h b/arch/mn10300/include/asm/fpu.h
index 64a2b83..b7625de 100644
--- a/arch/mn10300/include/asm/fpu.h
+++ b/arch/mn10300/include/asm/fpu.h
@@ -12,74 +12,125 @@
 #ifndef _ASM_FPU_H
 #define _ASM_FPU_H
 
-#include <asm/processor.h>
+#ifndef __ASSEMBLY__
+
+#include <linux/sched.h>
+#include <asm/exceptions.h>
 #include <asm/sigcontext.h>
-#include <asm/user.h>
 
 #ifdef __KERNEL__
 
-/* the task that owns the FPU state */
+extern asmlinkage void fpu_disabled(void);
+
+#ifdef CONFIG_FPU
+
+#ifdef CONFIG_LAZY_SAVE_FPU
+/* the task that currently owns the FPU state */
 extern struct task_struct *fpu_state_owner;
+#endif
 
-#define set_using_fpu(tsk)				\
-do {							\
-	(tsk)->thread.fpu_flags |= THREAD_USING_FPU;	\
-} while (0)
+#if (THREAD_USING_FPU & ~0xff)
+#error THREAD_USING_FPU must be smaller than 0x100.
+#endif
 
-#define clear_using_fpu(tsk)				\
-do {							\
-	(tsk)->thread.fpu_flags &= ~THREAD_USING_FPU;	\
-} while (0)
+static inline void set_using_fpu(struct task_struct *tsk)
+{
+	asm volatile(
+		"bset %0,(0,%1)"
+		:
+		: "i"(THREAD_USING_FPU), "a"(&tsk->thread.fpu_flags)
+		: "memory", "cc");
+}
 
-#define is_using_fpu(tsk) ((tsk)->thread.fpu_flags & THREAD_USING_FPU)
+static inline void clear_using_fpu(struct task_struct *tsk)
+{
+	asm volatile(
+		"bclr %0,(0,%1)"
+		:
+		: "i"(THREAD_USING_FPU), "a"(&tsk->thread.fpu_flags)
+		: "memory", "cc");
+}
 
-#define unlazy_fpu(tsk)					\
-do {							\
-	preempt_disable();				\
-	if (fpu_state_owner == (tsk))			\
-		fpu_save(&tsk->thread.fpu_state);	\
-	preempt_enable();				\
-} while (0)
-
-#define exit_fpu()				\
-do {						\
-	struct task_struct *__tsk = current;	\
-	preempt_disable();			\
-	if (fpu_state_owner == __tsk)		\
-		fpu_state_owner = NULL;		\
-	preempt_enable();			\
-} while (0)
-
-#define flush_fpu()					\
-do {							\
-	struct task_struct *__tsk = current;		\
-	preempt_disable();				\
-	if (fpu_state_owner == __tsk) {			\
-		fpu_state_owner = NULL;			\
-		__tsk->thread.uregs->epsw &= ~EPSW_FE;	\
-	}						\
-	preempt_enable();				\
-	clear_using_fpu(__tsk);				\
-} while (0)
+#define is_using_fpu(tsk) ((tsk)->thread.fpu_flags & THREAD_USING_FPU)
 
-extern asmlinkage void fpu_init_state(void);
 extern asmlinkage void fpu_kill_state(struct task_struct *);
-extern asmlinkage void fpu_disabled(struct pt_regs *, enum exception_code);
 extern asmlinkage void fpu_exception(struct pt_regs *, enum exception_code);
-
-#ifdef CONFIG_FPU
+extern asmlinkage void fpu_invalid_op(struct pt_regs *, enum exception_code);
+extern asmlinkage void fpu_init_state(void);
 extern asmlinkage void fpu_save(struct fpu_state_struct *);
-extern asmlinkage void fpu_restore(struct fpu_state_struct *);
-#else
-#define fpu_save(a)
-#define fpu_restore(a)
-#endif /* CONFIG_FPU  */
-
-/*
- * signal frame handlers
- */
 extern int fpu_setup_sigcontext(struct fpucontext *buf);
 extern int fpu_restore_sigcontext(struct fpucontext *buf);
 
+static inline void unlazy_fpu(struct task_struct *tsk)
+{
+	preempt_disable();
+#ifndef CONFIG_LAZY_SAVE_FPU
+	if (tsk->thread.fpu_flags & THREAD_HAS_FPU) {
+		fpu_save(&tsk->thread.fpu_state);
+		tsk->thread.fpu_flags &= ~THREAD_HAS_FPU;
+		tsk->thread.uregs->epsw &= ~EPSW_FE;
+	}
+#else
+	if (fpu_state_owner == tsk)
+		fpu_save(&tsk->thread.fpu_state);
+#endif
+	preempt_enable();
+}
+
+static inline void exit_fpu(void)
+{
+#ifdef CONFIG_LAZY_SAVE_FPU
+	struct task_struct *tsk = current;
+
+	preempt_disable();
+	if (fpu_state_owner == tsk)
+		fpu_state_owner = NULL;
+	preempt_enable();
+#endif
+}
+
+static inline void flush_fpu(void)
+{
+	struct task_struct *tsk = current;
+
+	preempt_disable();
+#ifndef CONFIG_LAZY_SAVE_FPU
+	if (tsk->thread.fpu_flags & THREAD_HAS_FPU) {
+		tsk->thread.fpu_flags &= ~THREAD_HAS_FPU;
+		tsk->thread.uregs->epsw &= ~EPSW_FE;
+	}
+#else
+	if (fpu_state_owner == tsk) {
+		fpu_state_owner = NULL;
+		tsk->thread.uregs->epsw &= ~EPSW_FE;
+	}
+#endif
+	preempt_enable();
+	clear_using_fpu(tsk);
+}
+
+#else /* CONFIG_FPU */
+
+extern asmlinkage
+void unexpected_fpu_exception(struct pt_regs *, enum exception_code);
+#define fpu_invalid_op unexpected_fpu_exception
+#define fpu_exception unexpected_fpu_exception
+
+struct task_struct;
+struct fpu_state_struct;
+static inline bool is_using_fpu(struct task_struct *tsk) { return false; }
+static inline void set_using_fpu(struct task_struct *tsk) {}
+static inline void clear_using_fpu(struct task_struct *tsk) {}
+static inline void fpu_init_state(void) {}
+static inline void fpu_save(struct fpu_state_struct *s) {}
+static inline void fpu_kill_state(struct task_struct *tsk) {}
+static inline void unlazy_fpu(struct task_struct *tsk) {}
+static inline void exit_fpu(void) {}
+static inline void flush_fpu(void) {}
+static inline int fpu_setup_sigcontext(struct fpucontext *buf) { return 0; }
+static inline int fpu_restore_sigcontext(struct fpucontext *buf) { return 0; }
+#endif /* CONFIG_FPU  */
+
 #endif /* __KERNEL__ */
+#endif /* !__ASSEMBLY__ */
 #endif /* _ASM_FPU_H */
diff --git a/arch/mn10300/include/asm/processor.h b/arch/mn10300/include/asm/processor.h
index fd96c18..0032fc7 100644
--- a/arch/mn10300/include/asm/processor.h
+++ b/arch/mn10300/include/asm/processor.h
@@ -95,6 +95,7 @@ struct thread_struct {
 	struct pt_regs		*__frame;
 	unsigned long		fpu_flags;
 #define THREAD_USING_FPU	0x00000001	/* T if this task is using the FPU */
+#define THREAD_HAS_FPU		0x00000002	/* T if this task owns the FPU right now */
 	struct fpu_state_struct	fpu_state;
 };
 
diff --git a/arch/mn10300/include/asm/system.h b/arch/mn10300/include/asm/system.h
index 9f7c7e1..3c272a1 100644
--- a/arch/mn10300/include/asm/system.h
+++ b/arch/mn10300/include/asm/system.h
@@ -19,6 +19,21 @@
 #include <linux/kernel.h>
 #include <linux/irqflags.h>
 
+#if !defined(CONFIG_LAZY_SAVE_FPU)
+struct fpu_state_struct;
+extern asmlinkage void fpu_save(struct fpu_state_struct *);
+#define switch_fpu(prev, next)						\
+	do {								\
+		if ((prev)->thread.fpu_flags & THREAD_HAS_FPU) {	\
+			(prev)->thread.fpu_flags &= ~THREAD_HAS_FPU;	\
+			(prev)->thread.uregs->epsw &= ~EPSW_FE;		\
+			fpu_save(&(prev)->thread.fpu_state);		\
+		}							\
+	} while (0)
+#else
+#define switch_fpu(prev, next) do {} while (0)
+#endif
+
 struct task_struct;
 struct thread_struct;
 
@@ -30,6 +45,7 @@ struct task_struct *__switch_to(struct thread_struct *prev,
 /* context switching is now performed out-of-line in switch_to.S */
 #define switch_to(prev, next, last)					\
 do {									\
+	switch_fpu(prev, next);						\
 	current->thread.wchan = (u_long) __builtin_return_address(0);	\
 	(last) = __switch_to(&(prev)->thread, &(next)->thread, (prev));	\
 	mb();								\
diff --git a/arch/mn10300/kernel/Makefile b/arch/mn10300/kernel/Makefile
index c4289e3..9902235 100644
--- a/arch/mn10300/kernel/Makefile
+++ b/arch/mn10300/kernel/Makefile
@@ -3,13 +3,15 @@
 #
 extra-y := head.o init_task.o vmlinux.lds
 
-obj-y   := process.o signal.o entry.o fpu.o traps.o irq.o \
+fpu-obj-y := fpu-nofpu.o fpu-nofpu-low.o
+fpu-obj-$(CONFIG_FPU) := fpu.o fpu-low.o
+
+obj-y   := process.o signal.o entry.o traps.o irq.o \
 	   ptrace.o setup.o time.o sys_mn10300.o io.o kthread.o \
-	   switch_to.o mn10300_ksyms.o kernel_execve.o
+	   switch_to.o mn10300_ksyms.o kernel_execve.o $(fpu-obj-y)
 
 obj-$(CONFIG_MN10300_WD_TIMER) += mn10300-watchdog.o mn10300-watchdog-low.o
 
-obj-$(CONFIG_FPU) += fpu-low.o
 
 obj-$(CONFIG_MN10300_TTYSM) += mn10300-serial.o mn10300-serial-low.o \
 			       mn10300-debug.o
diff --git a/arch/mn10300/kernel/asm-offsets.c b/arch/mn10300/kernel/asm-offsets.c
index 02dc7e4..78e290e 100644
--- a/arch/mn10300/kernel/asm-offsets.c
+++ b/arch/mn10300/kernel/asm-offsets.c
@@ -67,6 +67,15 @@ void foo(void)
 	OFFSET(THREAD_A3,		thread_struct, a3);
 	OFFSET(THREAD_USP,		thread_struct, usp);
 	OFFSET(THREAD_FRAME,		thread_struct, __frame);
+#ifdef CONFIG_FPU
+	OFFSET(THREAD_FPU_FLAGS,	thread_struct, fpu_flags);
+	OFFSET(THREAD_FPU_STATE,	thread_struct, fpu_state);
+	DEFINE(__THREAD_USING_FPU,	THREAD_USING_FPU);
+	DEFINE(__THREAD_HAS_FPU,	THREAD_HAS_FPU);
+#endif /* CONFIG_FPU */
+	BLANK();
+
+	OFFSET(TASK_THREAD,		task_struct, thread);
 	BLANK();
 
 	DEFINE(CLONE_VM_asm,		CLONE_VM);
diff --git a/arch/mn10300/kernel/fpu-low.S b/arch/mn10300/kernel/fpu-low.S
index 96cfd47..78df25c 100644
--- a/arch/mn10300/kernel/fpu-low.S
+++ b/arch/mn10300/kernel/fpu-low.S
@@ -8,25 +8,14 @@
  * as published by the Free Software Foundation; either version
  * 2 of the Licence, or (at your option) any later version.
  */
+#include <linux/linkage.h>
 #include <asm/cpu-regs.h>
+#include <asm/smp.h>
+#include <asm/thread_info.h>
+#include <asm/asm-offsets.h>
+#include <asm/frame.inc>
 
-###############################################################################
-#
-# void fpu_init_state(void)
-# - initialise the FPU
-#
-###############################################################################
-	.globl	fpu_init_state
-	.type	fpu_init_state,@function
-fpu_init_state:
-	mov	epsw,d0
-	or	EPSW_FE,epsw
-
-#ifdef CONFIG_MN10300_PROC_MN103E010
-	nop
-	nop
-	nop
-#endif
+.macro FPU_INIT_STATE_ALL
 	fmov	0,fs0
 	fmov	fs0,fs1
 	fmov	fs0,fs2
@@ -60,7 +49,100 @@ fpu_init_state:
 	fmov	fs0,fs30
 	fmov	fs0,fs31
 	fmov	FPCR_INIT,fpcr
+.endm
+
+.macro FPU_SAVE_ALL areg,dreg
+	fmov	fs0,(\areg+)
+	fmov	fs1,(\areg+)
+	fmov	fs2,(\areg+)
+	fmov	fs3,(\areg+)
+	fmov	fs4,(\areg+)
+	fmov	fs5,(\areg+)
+	fmov	fs6,(\areg+)
+	fmov	fs7,(\areg+)
+	fmov	fs8,(\areg+)
+	fmov	fs9,(\areg+)
+	fmov	fs10,(\areg+)
+	fmov	fs11,(\areg+)
+	fmov	fs12,(\areg+)
+	fmov	fs13,(\areg+)
+	fmov	fs14,(\areg+)
+	fmov	fs15,(\areg+)
+	fmov	fs16,(\areg+)
+	fmov	fs17,(\areg+)
+	fmov	fs18,(\areg+)
+	fmov	fs19,(\areg+)
+	fmov	fs20,(\areg+)
+	fmov	fs21,(\areg+)
+	fmov	fs22,(\areg+)
+	fmov	fs23,(\areg+)
+	fmov	fs24,(\areg+)
+	fmov	fs25,(\areg+)
+	fmov	fs26,(\areg+)
+	fmov	fs27,(\areg+)
+	fmov	fs28,(\areg+)
+	fmov	fs29,(\areg+)
+	fmov	fs30,(\areg+)
+	fmov	fs31,(\areg+)
+	fmov	fpcr,\dreg
+	mov	\dreg,(\areg)
+.endm
+
+.macro FPU_RESTORE_ALL areg,dreg
+	fmov	(\areg+),fs0
+	fmov	(\areg+),fs1
+	fmov	(\areg+),fs2
+	fmov	(\areg+),fs3
+	fmov	(\areg+),fs4
+	fmov	(\areg+),fs5
+	fmov	(\areg+),fs6
+	fmov	(\areg+),fs7
+	fmov	(\areg+),fs8
+	fmov	(\areg+),fs9
+	fmov	(\areg+),fs10
+	fmov	(\areg+),fs11
+	fmov	(\areg+),fs12
+	fmov	(\areg+),fs13
+	fmov	(\areg+),fs14
+	fmov	(\areg+),fs15
+	fmov	(\areg+),fs16
+	fmov	(\areg+),fs17
+	fmov	(\areg+),fs18
+	fmov	(\areg+),fs19
+	fmov	(\areg+),fs20
+	fmov	(\areg+),fs21
+	fmov	(\areg+),fs22
+	fmov	(\areg+),fs23
+	fmov	(\areg+),fs24
+	fmov	(\areg+),fs25
+	fmov	(\areg+),fs26
+	fmov	(\areg+),fs27
+	fmov	(\areg+),fs28
+	fmov	(\areg+),fs29
+	fmov	(\areg+),fs30
+	fmov	(\areg+),fs31
+	mov	(\areg),\dreg
+	fmov	\dreg,fpcr
+.endm
 
+###############################################################################
+#
+# void fpu_init_state(void)
+# - initialise the FPU
+#
+###############################################################################
+	.globl	fpu_init_state
+	.type	fpu_init_state,@function
+fpu_init_state:
+	mov	epsw,d0
+	or	EPSW_FE,epsw
+
+#ifdef CONFIG_MN10300_PROC_MN103E010
+	nop
+	nop
+	nop
+#endif
+	FPU_INIT_STATE_ALL
 #ifdef CONFIG_MN10300_PROC_MN103E010
 	nop
 	nop
@@ -89,40 +171,7 @@ fpu_save:
 	nop
 #endif
 	mov	d0,a0
-	fmov	fs0,(a0+)
-	fmov	fs1,(a0+)
-	fmov	fs2,(a0+)
-	fmov	fs3,(a0+)
-	fmov	fs4,(a0+)
-	fmov	fs5,(a0+)
-	fmov	fs6,(a0+)
-	fmov	fs7,(a0+)
-	fmov	fs8,(a0+)
-	fmov	fs9,(a0+)
-	fmov	fs10,(a0+)
-	fmov	fs11,(a0+)
-	fmov	fs12,(a0+)
-	fmov	fs13,(a0+)
-	fmov	fs14,(a0+)
-	fmov	fs15,(a0+)
-	fmov	fs16,(a0+)
-	fmov	fs17,(a0+)
-	fmov	fs18,(a0+)
-	fmov	fs19,(a0+)
-	fmov	fs20,(a0+)
-	fmov	fs21,(a0+)
-	fmov	fs22,(a0+)
-	fmov	fs23,(a0+)
-	fmov	fs24,(a0+)
-	fmov	fs25,(a0+)
-	fmov	fs26,(a0+)
-	fmov	fs27,(a0+)
-	fmov	fs28,(a0+)
-	fmov	fs29,(a0+)
-	fmov	fs30,(a0+)
-	fmov	fs31,(a0+)
-	fmov	fpcr,d0
-	mov	d0,(a0)
+	FPU_SAVE_ALL	a0,d0
 #ifdef CONFIG_MN10300_PROC_MN103E010
 	nop
 	nop
@@ -135,63 +184,75 @@ fpu_save:
 
 ###############################################################################
 #
-# void fpu_restore(struct fpu_state_struct *)
-# - restore the fpu state
-# - note that an FPU Operational exception might occur during this process
+# void fpu_disabled(void)
+# - handle an exception due to the FPU being disabled
+#   when CONFIG_FPU is enabled
 #
 ###############################################################################
-	.globl	fpu_restore
-	.type	fpu_restore,@function
-fpu_restore:
-	mov	epsw,d1
-	or	EPSW_FE,epsw		/* enable the FPU so we can access it */
-
-#ifdef CONFIG_MN10300_PROC_MN103E010
+	.type	fpu_disabled,@function
+	.globl	fpu_disabled
+fpu_disabled:
+	or	EPSW_nAR|EPSW_FE,epsw
 	nop
 	nop
-#endif
-	mov	d0,a0
-	fmov	(a0+),fs0
-	fmov	(a0+),fs1
-	fmov	(a0+),fs2
-	fmov	(a0+),fs3
-	fmov	(a0+),fs4
-	fmov	(a0+),fs5
-	fmov	(a0+),fs6
-	fmov	(a0+),fs7
-	fmov	(a0+),fs8
-	fmov	(a0+),fs9
-	fmov	(a0+),fs10
-	fmov	(a0+),fs11
-	fmov	(a0+),fs12
-	fmov	(a0+),fs13
-	fmov	(a0+),fs14
-	fmov	(a0+),fs15
-	fmov	(a0+),fs16
-	fmov	(a0+),fs17
-	fmov	(a0+),fs18
-	fmov	(a0+),fs19
-	fmov	(a0+),fs20
-	fmov	(a0+),fs21
-	fmov	(a0+),fs22
-	fmov	(a0+),fs23
-	fmov	(a0+),fs24
-	fmov	(a0+),fs25
-	fmov	(a0+),fs26
-	fmov	(a0+),fs27
-	fmov	(a0+),fs28
-	fmov	(a0+),fs29
-	fmov	(a0+),fs30
-	fmov	(a0+),fs31
-	mov	(a0),d0
-	fmov	d0,fpcr
-#ifdef CONFIG_MN10300_PROC_MN103E010
 	nop
+
+	mov	sp,a1
+	mov	(a1),d1			/* get epsw of user context */
+	and	~(THREAD_SIZE-1),a1	/* a1: (thread_info *ti) */
+	mov	(TI_task,a1),a2		/* a2: (task_struct *tsk) */
+	btst	EPSW_nSL,d1
+	beq	fpu_used_in_kernel
+
+	or	EPSW_FE,d1
+	mov	d1,(sp)
+	mov	(TASK_THREAD+THREAD_FPU_FLAGS,a2),d1
+#ifndef CONFIG_LAZY_SAVE_FPU
+	or	__THREAD_HAS_FPU,d1
+	mov	d1,(TASK_THREAD+THREAD_FPU_FLAGS,a2)
+#else  /* !CONFIG_LAZY_SAVE_FPU */
+	mov	(fpu_state_owner),a0
+	cmp	0,a0
+	beq	fpu_regs_save_end
+
+	mov	(TASK_THREAD+THREAD_UREGS,a0),a1
+	add	TASK_THREAD+THREAD_FPU_STATE,a0
+	FPU_SAVE_ALL a0,d0
+
+	mov	(REG_EPSW,a1),d0
+	and	~EPSW_FE,d0
+	mov	d0,(REG_EPSW,a1)
+
+fpu_regs_save_end:
+	mov	a2,(fpu_state_owner)
+#endif /* !CONFIG_LAZY_SAVE_FPU */
+
+	btst	__THREAD_USING_FPU,d1
+	beq	fpu_regs_init
+	add	TASK_THREAD+THREAD_FPU_STATE,a2
+	FPU_RESTORE_ALL a2,d0
+	rti
+
+fpu_regs_init:
+	FPU_INIT_STATE_ALL
+	add	TASK_THREAD+THREAD_FPU_FLAGS,a2
+	bset	__THREAD_USING_FPU,(0,a2)
+	rti
+
+fpu_used_in_kernel:
+	and	~(EPSW_nAR|EPSW_FE),epsw
 	nop
 	nop
-#endif
 
-	mov	d1,epsw
-	ret	[],0
+	add	-4,sp
+	SAVE_ALL
+	mov	-1,d0
+	mov	d0,(REG_ORIG_D0,fp)
+
+	and	~EPSW_NMID,epsw
+
+	mov	fp,d0
+	call	fpu_disabled_in_kernel[],0
+	jmp	ret_from_exception
 
-	.size	fpu_restore,.-fpu_restore
+	.size	fpu_disabled,.-fpu_disabled
diff --git a/arch/mn10300/kernel/fpu-nofpu-low.S b/arch/mn10300/kernel/fpu-nofpu-low.S
new file mode 100644
index 0000000..7ea087a
--- /dev/null
+++ b/arch/mn10300/kernel/fpu-nofpu-low.S
@@ -0,0 +1,39 @@
+/* MN10300 Low level FPU management operations
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/linkage.h>
+#include <asm/cpu-regs.h>
+#include <asm/smp.h>
+#include <asm/thread_info.h>
+#include <asm/asm-offsets.h>
+#include <asm/frame.inc>
+
+###############################################################################
+#
+# void fpu_disabled(void)
+# - handle an exception due to the FPU being disabled
+#   when CONFIG_FPU is disabled
+#
+###############################################################################
+	.type	fpu_disabled,@function
+	.globl	fpu_disabled
+fpu_disabled:
+	add	-4,sp
+	SAVE_ALL
+	mov	-1,d0
+	mov	d0,(REG_ORIG_D0,fp)
+
+	and	~EPSW_NMID,epsw
+
+	mov	fp,d0
+	call	unexpected_fpu_exception[],0
+	jmp	ret_from_exception
+
+	.size	fpu_disabled,.-fpu_disabled
diff --git a/arch/mn10300/kernel/fpu-nofpu.c b/arch/mn10300/kernel/fpu-nofpu.c
new file mode 100644
index 0000000..31c765b
--- /dev/null
+++ b/arch/mn10300/kernel/fpu-nofpu.c
@@ -0,0 +1,30 @@
+/* MN10300 FPU management
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <asm/fpu.h>
+
+/*
+ * handle an FPU operational exception
+ * - there's a possibility that if the FPU is asynchronous, the signal might
+ *   be meant for a process other than the current one
+ */
+asmlinkage
+void unexpected_fpu_exception(struct pt_regs *regs, enum exception_code code)
+{
+	panic("An FPU exception was received, but there's no FPU enabled.");
+}
+
+/*
+ * fill in the FPU structure for a core dump
+ */
+int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpreg)
+{
+	return 0; /* not valid */
+}
diff --git a/arch/mn10300/kernel/fpu.c b/arch/mn10300/kernel/fpu.c
index e705f25..5f9c3fa 100644
--- a/arch/mn10300/kernel/fpu.c
+++ b/arch/mn10300/kernel/fpu.c
@@ -12,56 +12,19 @@
 #include <asm/fpu.h>
 #include <asm/elf.h>
 #include <asm/exceptions.h>
+#include <asm/system.h>
 
+#ifdef CONFIG_LAZY_SAVE_FPU
 struct task_struct *fpu_state_owner;
+#endif
 
 /*
- * handle an exception due to the FPU being disabled
+ * error functions in FPU disabled exception
  */
-asmlinkage void fpu_disabled(struct pt_regs *regs, enum exception_code code)
+asmlinkage void fpu_disabled_in_kernel(struct pt_regs *regs)
 {
-	struct task_struct *tsk = current;
-
-	if (!user_mode(regs))
-		die_if_no_fixup("An FPU Disabled exception happened in"
-				" kernel space\n",
-				regs, code);
-
-#ifdef CONFIG_FPU
-	preempt_disable();
-
-	/* transfer the last process's FPU state to memory */
-	if (fpu_state_owner) {
-		fpu_save(&fpu_state_owner->thread.fpu_state);
-		fpu_state_owner->thread.uregs->epsw &= ~EPSW_FE;
-	}
-
-	/* the current process now owns the FPU state */
-	fpu_state_owner = tsk;
-	regs->epsw |= EPSW_FE;
-
-	/* load the FPU with the current process's FPU state or invent a new
-	 * clean one if the process doesn't have one */
-	if (is_using_fpu(tsk)) {
-		fpu_restore(&tsk->thread.fpu_state);
-	} else {
-		fpu_init_state();
-		set_using_fpu(tsk);
-	}
-
-	preempt_enable();
-#else
-	{
-		siginfo_t info;
-
-		info.si_signo = SIGFPE;
-		info.si_errno = 0;
-		info.si_addr = (void *) tsk->thread.uregs->pc;
-		info.si_code = FPE_FLTINV;
-
-		force_sig_info(SIGFPE, &info, tsk);
-	}
-#endif  /* CONFIG_FPU */
+	die_if_no_fixup("An FPU Disabled exception happened in kernel space\n",
+			regs, EXCEP_FPU_DISABLED);
 }
 
 /*
@@ -71,15 +34,16 @@ asmlinkage void fpu_disabled(struct pt_regs *regs, enum exception_code code)
  */
 asmlinkage void fpu_exception(struct pt_regs *regs, enum exception_code code)
 {
-	struct task_struct *tsk = fpu_state_owner;
+	struct task_struct *tsk = current;
 	siginfo_t info;
+	u32 fpcr;
 
 	if (!user_mode(regs))
 		die_if_no_fixup("An FPU Operation exception happened in"
 				" kernel space\n",
 				regs, code);
 
-	if (!tsk)
+	if (!is_using_fpu(tsk))
 		die_if_no_fixup("An FPU Operation exception happened,"
 				" but the FPU is not in use",
 				regs, code);
@@ -89,48 +53,45 @@ asmlinkage void fpu_exception(struct pt_regs *regs, enum exception_code code)
 	info.si_addr = (void *) tsk->thread.uregs->pc;
 	info.si_code = FPE_FLTINV;
 
-#ifdef CONFIG_FPU
-	{
-		u32 fpcr;
+	unlazy_fpu(tsk);
 
-		/* get FPCR (we need to enable the FPU whilst we do this) */
-		asm volatile("	or	%1,epsw		\n"
-#ifdef CONFIG_MN10300_PROC_MN103E010
-			     "	nop			\n"
-			     "	nop			\n"
-			     "	nop			\n"
-#endif
-			     "	fmov	fpcr,%0		\n"
-#ifdef CONFIG_MN10300_PROC_MN103E010
-			     "	nop			\n"
-			     "	nop			\n"
-			     "	nop			\n"
-#endif
-			     "	and	%2,epsw		\n"
-			     : "=&d"(fpcr)
-			     : "i"(EPSW_FE), "i"(~EPSW_FE)
-			     );
-
-		if (fpcr & FPCR_EC_Z)
-			info.si_code = FPE_FLTDIV;
-		else if	(fpcr & FPCR_EC_O)
-			info.si_code = FPE_FLTOVF;
-		else if	(fpcr & FPCR_EC_U)
-			info.si_code = FPE_FLTUND;
-		else if	(fpcr & FPCR_EC_I)
-			info.si_code = FPE_FLTRES;
-	}
-#endif
+	fpcr = tsk->thread.fpu_state.fpcr;
+
+	if (fpcr & FPCR_EC_Z)
+		info.si_code = FPE_FLTDIV;
+	else if	(fpcr & FPCR_EC_O)
+		info.si_code = FPE_FLTOVF;
+	else if	(fpcr & FPCR_EC_U)
+		info.si_code = FPE_FLTUND;
+	else if	(fpcr & FPCR_EC_I)
+		info.si_code = FPE_FLTRES;
 
 	force_sig_info(SIGFPE, &info, tsk);
 }
 
 /*
+ * handle an FPU invalid_op exception
+ * - Derived from DO_EINFO() macro in arch/mn10300/kernel/traps.c
+ */
+asmlinkage void fpu_invalid_op(struct pt_regs *regs, enum exception_code code)
+{
+	siginfo_t info;
+
+	if (!user_mode(regs))
+		die_if_no_fixup("FPU invalid opcode", regs, code);
+
+	info.si_signo = SIGILL;
+	info.si_errno = 0;
+	info.si_code = ILL_COPROC;
+	info.si_addr = (void *) regs->pc;
+	force_sig_info(info.si_signo, &info, current);
+}
+
+/*
  * save the FPU state to a signal context
  */
 int fpu_setup_sigcontext(struct fpucontext *fpucontext)
 {
-#ifdef CONFIG_FPU
 	struct task_struct *tsk = current;
 
 	if (!is_using_fpu(tsk))
@@ -142,11 +103,19 @@ int fpu_setup_sigcontext(struct fpucontext *fpucontext)
 	 */
 	preempt_disable();
 
+#ifndef CONFIG_LAZY_SAVE_FPU
+	if (tsk->thread.fpu_flags & THREAD_HAS_FPU) {
+		fpu_save(&tsk->thread.fpu_state);
+		tsk->thread.uregs->epsw &= ~EPSW_FE;
+		tsk->thread.fpu_flags &= ~THREAD_HAS_FPU;
+	}
+#else /* !CONFIG_LAZY_SAVE_FPU */
 	if (fpu_state_owner == tsk) {
 		fpu_save(&tsk->thread.fpu_state);
 		fpu_state_owner->thread.uregs->epsw &= ~EPSW_FE;
 		fpu_state_owner = NULL;
 	}
+#endif /* !CONFIG_LAZY_SAVE_FPU */
 
 	preempt_enable();
 
@@ -161,9 +130,6 @@ int fpu_setup_sigcontext(struct fpucontext *fpucontext)
 		return -1;
 
 	return 1;
-#else
-	return 0;
-#endif
 }
 
 /*
@@ -171,17 +137,23 @@ int fpu_setup_sigcontext(struct fpucontext *fpucontext)
  */
 void fpu_kill_state(struct task_struct *tsk)
 {
-#ifdef CONFIG_FPU
 	/* disown anything left in the FPU */
 	preempt_disable();
 
+#ifndef CONFIG_LAZY_SAVE_FPU
+	if (tsk->thread.fpu_flags & THREAD_HAS_FPU) {
+		tsk->thread.uregs->epsw &= ~EPSW_FE;
+		tsk->thread.fpu_flags &= ~THREAD_HAS_FPU;
+	}
+#else /* !CONFIG_LAZY_SAVE_FPU */
 	if (fpu_state_owner == tsk) {
 		fpu_state_owner->thread.uregs->epsw &= ~EPSW_FE;
 		fpu_state_owner = NULL;
 	}
+#endif /* !CONFIG_LAZY_SAVE_FPU */
 
 	preempt_enable();
-#endif
+
 	/* we no longer have a valid current FPU state */
 	clear_using_fpu(tsk);
 }
@@ -195,8 +167,7 @@ int fpu_restore_sigcontext(struct fpucontext *fpucontext)
 	int ret;
 
 	/* load up the old FPU state */
-	ret = copy_from_user(&tsk->thread.fpu_state,
-			     fpucontext,
+	ret = copy_from_user(&tsk->thread.fpu_state, fpucontext,
 			     min(sizeof(struct fpu_state_struct),
 				 sizeof(struct fpucontext)));
 	if (!ret)
diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index c7257a1..716a221 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -101,7 +101,6 @@ DO_EINFO(SIGILL,  {}, "invalid opcode",		invalid_op,	ILL_ILLOPC);
 DO_EINFO(SIGILL,  {}, "invalid ex opcode",	invalid_exop,	ILL_ILLOPC);
 DO_EINFO(SIGBUS,  {}, "invalid address",	mem_error,	BUS_ADRERR);
 DO_EINFO(SIGBUS,  {}, "bus error",		bus_error,	BUS_ADRERR);
-DO_EINFO(SIGILL,  {}, "FPU invalid opcode", 	fpu_invalid_op,	ILL_COPROC);
 
 DO_ERROR(SIGTRAP,
 #ifndef CONFIG_MN10300_USING_JTAG
@@ -561,7 +560,6 @@ void __init trap_init(void)
 	set_excp_vector(EXCEP_PRIVINSACC,	insn_acc_error);
 	set_excp_vector(EXCEP_PRIVDATACC,	data_acc_error);
 	set_excp_vector(EXCEP_DATINSACC,	insn_acc_error);
-	set_excp_vector(EXCEP_FPU_DISABLED,	fpu_disabled);
 	set_excp_vector(EXCEP_FPU_UNIMPINS,	fpu_invalid_op);
 	set_excp_vector(EXCEP_FPU_OPERATION,	fpu_exception);
 
diff --git a/arch/mn10300/proc-mn103e010/proc-init.c b/arch/mn10300/proc-mn103e010/proc-init.c
index 9a482ef..0cee787 100644
--- a/arch/mn10300/proc-mn103e010/proc-init.c
+++ b/arch/mn10300/proc-mn103e010/proc-init.c
@@ -9,6 +9,7 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 #include <linux/kernel.h>
+#include <asm/fpu.h>
 #include <asm/rtc.h>
 
 /*
@@ -28,6 +29,7 @@ asmlinkage void __init processor_init(void)
 	__set_intr_stub(EXCEP_DAERROR,		dtlb_aerror);
 	__set_intr_stub(EXCEP_BUSERROR,		raw_bus_error);
 	__set_intr_stub(EXCEP_DOUBLE_FAULT,	double_fault);
+	__set_intr_stub(EXCEP_FPU_DISABLED,	fpu_disabled);
 	__set_intr_stub(EXCEP_SYSCALL0,		system_call);
 
 	__set_intr_stub(EXCEP_NMI,		nmi_handler);

