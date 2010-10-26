Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab0JZC5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:57:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933045Ab0JZC5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:57:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 43/43] MN10300: Save frame pointer in thread_info struct
 rather than global var
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:56:51 +0100
Message-ID: <20101026025651.23512.89236.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save the current exception frame pointer in the thread_info struct rather than
in a global variable as the latter makes SMP tricky, especially when preemption
is also enabled.

This also replaces __frame with current_frame() and rearranges header file
inclusions to make it all compile.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
---

 arch/mn10300/include/asm/frame.inc     |   56 +++++++-------------------------
 arch/mn10300/include/asm/irq_regs.h    |    6 +++
 arch/mn10300/include/asm/pgalloc.h     |    1 -
 arch/mn10300/include/asm/processor.h   |   46 ++++++++++----------------
 arch/mn10300/include/asm/ptrace.h      |    6 ---
 arch/mn10300/include/asm/smp.h         |   13 -------
 arch/mn10300/include/asm/thread_info.h |   18 ++++++++--
 arch/mn10300/include/asm/uaccess.h     |    4 +-
 arch/mn10300/kernel/asm-offsets.c      |    2 +
 arch/mn10300/kernel/mn10300-watchdog.c |    2 +
 arch/mn10300/kernel/process.c          |   20 ++++++-----
 arch/mn10300/kernel/signal.c           |   20 ++++++-----
 arch/mn10300/kernel/switch_to.S        |   18 ----------
 arch/mn10300/kernel/traps.c            |    8 -----
 mm/maccess.c                           |    2 +
 15 files changed, 76 insertions(+), 146 deletions(-)


diff --git a/arch/mn10300/include/asm/frame.inc b/arch/mn10300/include/asm/frame.inc
index 406060e..2ee58e3 100644
--- a/arch/mn10300/include/asm/frame.inc
+++ b/arch/mn10300/include/asm/frame.inc
@@ -18,9 +18,7 @@
 #ifndef __ASM_OFFSETS_H__
 #include <asm/asm-offsets.h>
 #endif
-#ifdef CONFIG_SMP
-#include <proc/smp-regs.h>
-#endif
+#include <asm/thread_info.h>
 
 #define pi break
 
@@ -40,27 +38,15 @@
 	movm	[d2,d3,a2,a3,exreg0,exreg1,exother],(sp)
 	mov	sp,fp				# FRAME pointer in A3
 	add	-12,sp				# allow for calls to be made
-#ifdef CONFIG_SMP
-#ifdef CONFIG_PREEMPT /* FIXME */
-	mov	epsw,d2
-	and	~EPSW_IE,epsw
-#endif
-	mov	(CPUID),a0
-	add	a0,a0
-	add	a0,a0
-	mov	(___frame,a0),a1
-	mov	a1,(REG_NEXT,fp)
-	mov	fp,(___frame,a0)
-#ifdef CONFIG_PREEMPT /* FIXME */
-	mov	d2,epsw
-#endif
-#else  /* CONFIG_SMP */
-	mov	(__frame),a1
-	mov	a1,(REG_NEXT,fp)
-	mov	fp,(__frame)
-#endif /* CONFIG_SMP */
 
-	and	~EPSW_FE,epsw			# disable the FPU inside the kernel
+	# push the exception frame onto the front of the list
+	GET_THREAD_INFO a1
+	mov	(TI_frame,a1),a0
+	mov	a0,(REG_NEXT,fp)
+	mov	fp,(TI_frame,a1)
+
+	# disable the FPU inside the kernel
+	and	~EPSW_FE,epsw
 
 	# we may be holding current in E2
 #ifdef CONFIG_MN10300_CURRENT_IN_E2
@@ -76,27 +62,11 @@
 .macro RESTORE_ALL
 	# peel back the stack to the calling frame
 	# - this permits execve() to discard extra frames due to kernel syscalls
-#ifdef  CONFIG_SMP
-#ifdef CONFIG_PREEMPT /* FIXME */
-	mov	epsw,d2
-	and	~EPSW_IE,epsw
-#endif
-	mov	(CPUID),a0
-	add	a0,a0
-	add	a0,a0
-	mov	(___frame,a0),fp
-	mov	fp,sp
-	mov	(REG_NEXT,fp),d0                # userspace has regs->next == 0
-	mov	d0,(___frame,a0)
-#ifdef CONFIG_PREEMPT /* FIXME */
-	mov	d2,epsw
-#endif
-#else   /* CONFIG_SMP */
-	mov	(__frame),fp
+	GET_THREAD_INFO a0
+	mov	(TI_frame,a0),fp
 	mov	fp,sp
-	mov	(REG_NEXT,fp),d0                # userspace has regs->next == 0
-	mov	d0,(__frame)
-#endif  /* CONFIG_SMP */
+	mov	(REG_NEXT,fp),d0
+	mov	d0,(TI_frame,a0)                # userspace has regs->next == 0
 
 #ifndef CONFIG_MN10300_USING_JTAG
 	mov	(REG_EPSW,fp),d0
diff --git a/arch/mn10300/include/asm/irq_regs.h b/arch/mn10300/include/asm/irq_regs.h
index a848cd2..97d0cb5 100644
--- a/arch/mn10300/include/asm/irq_regs.h
+++ b/arch/mn10300/include/asm/irq_regs.h
@@ -18,7 +18,11 @@
 #define ARCH_HAS_OWN_IRQ_REGS
 
 #ifndef __ASSEMBLY__
-#define get_irq_regs() (__frame)
+static inline __attribute__((const))
+struct pt_regs *get_irq_regs(void)
+{
+	return current_frame();
+}
 #endif
 
 #endif /* _ASM_IRQ_REGS_H */
diff --git a/arch/mn10300/include/asm/pgalloc.h b/arch/mn10300/include/asm/pgalloc.h
index a19f113..146bacf 100644
--- a/arch/mn10300/include/asm/pgalloc.h
+++ b/arch/mn10300/include/asm/pgalloc.h
@@ -11,7 +11,6 @@
 #ifndef _ASM_PGALLOC_H
 #define _ASM_PGALLOC_H
 
-#include <asm/processor.h>
 #include <asm/page.h>
 #include <linux/threads.h>
 #include <linux/mm.h>		/* for struct page */
diff --git a/arch/mn10300/include/asm/processor.h b/arch/mn10300/include/asm/processor.h
index 75c422a..4c1b5cc 100644
--- a/arch/mn10300/include/asm/processor.h
+++ b/arch/mn10300/include/asm/processor.h
@@ -13,10 +13,13 @@
 #ifndef _ASM_PROCESSOR_H
 #define _ASM_PROCESSOR_H
 
+#include <linux/threads.h>
+#include <linux/thread_info.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include <asm/cpu-regs.h>
-#include <linux/threads.h>
+#include <asm/uaccess.h>
+#include <asm/current.h>
 
 /* Forward declaration, a strange C thing */
 struct task_struct;
@@ -83,10 +86,6 @@ extern void dodgy_tsc(void);
  */
 #define TASK_UNMAPPED_BASE	0x30000000
 
-typedef struct {
-	unsigned long	seg;
-} mm_segment_t;
-
 struct fpu_state_struct {
 	unsigned long	fs[32];		/* fpu registers */
 	unsigned long	fpcr;		/* fpu control register */
@@ -99,7 +98,6 @@ struct thread_struct {
 	unsigned long		a3;		/* kernel FP */
 	unsigned long		wchan;
 	unsigned long		usp;
-	struct pt_regs		*frame;
 	unsigned long		fpu_flags;
 #define THREAD_USING_FPU	0x00000001	/* T if this task is using the FPU */
 #define THREAD_HAS_FPU		0x00000002	/* T if this task owns the FPU right now */
@@ -113,7 +111,6 @@ struct thread_struct {
 	.sp	= 0,		\
 	.a3	= 0,		\
 	.wchan	= 0,		\
-	.frame	= NULL,		\
 }
 
 #define INIT_MMAP \
@@ -125,27 +122,20 @@ struct thread_struct {
  * - need to discard the frame stacked by the kernel thread invoking the execve
  *   syscall (see RESTORE_ALL macro)
  */
-#if defined(CONFIG_SMP) && defined(CONFIG_PREEMPT) /* FIXME */
-#define start_thread(regs, new_pc, new_sp) do {		\
-	int cpu;					\
-	preempt_disable();				\
-	cpu = CPUID;					\
-	set_fs(USER_DS);				\
-	___frame[cpu] = current->thread.uregs;		\
-	___frame[cpu]->epsw = EPSW_nSL | EPSW_IE | EPSW_IM;\
-	___frame[cpu]->pc = new_pc;			\
-	___frame[cpu]->sp = new_sp;			\
-	preempt_enable();				\
-} while (0)
-#else  /* CONFIG_SMP && CONFIG_PREEMPT */
-#define start_thread(regs, new_pc, new_sp) do {		\
-	set_fs(USER_DS);				\
-	__frame = current->thread.uregs;		\
-	__frame->epsw = EPSW_nSL | EPSW_IE | EPSW_IM;	\
-	__frame->pc = new_pc;				\
-	__frame->sp = new_sp;				\
-} while (0)
-#endif /* CONFIG_SMP && CONFIG_PREEMPT */
+static inline void start_thread(struct pt_regs *regs,
+				unsigned long new_pc, unsigned long new_sp)
+{
+	struct thread_info *ti = current_thread_info();
+	struct pt_regs *frame0;
+	set_fs(USER_DS);
+
+	frame0 = thread_info_to_uregs(ti);
+	frame0->epsw = EPSW_nSL | EPSW_IE | EPSW_IM;
+	frame0->pc = new_pc;
+	frame0->sp = new_sp;
+	ti->frame = frame0;
+}
+
 
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
diff --git a/arch/mn10300/include/asm/ptrace.h b/arch/mn10300/include/asm/ptrace.h
index c2b77bd..b696181 100644
--- a/arch/mn10300/include/asm/ptrace.h
+++ b/arch/mn10300/include/asm/ptrace.h
@@ -86,12 +86,6 @@ struct pt_regs {
 
 #ifdef __KERNEL__
 
-#ifdef CONFIG_SMP
-extern struct pt_regs *___frame[];	/* current frame pointer */
-#else
-extern struct pt_regs *__frame;		/* current frame pointer */
-#endif
-
 #define user_mode(regs)			(((regs)->epsw & EPSW_nSL) == EPSW_nSL)
 #define instruction_pointer(regs)	((regs)->pc)
 #define user_stack_pointer(regs)	((regs)->sp)
diff --git a/arch/mn10300/include/asm/smp.h b/arch/mn10300/include/asm/smp.h
index b8585b4..a3930e4 100644
--- a/arch/mn10300/include/asm/smp.h
+++ b/arch/mn10300/include/asm/smp.h
@@ -93,19 +93,6 @@ extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
 #endif /* CONFIG_HOTPLUG_CPU */
 
-#ifdef CONFIG_PREEMPT /* FIXME */
-#define __frame					\
-	({					\
-		struct pt_regs *f;		\
-		preempt_disable();		\
-		f = ___frame[CPUID];		\
-		preempt_enable();		\
-		f;				\
-	})
-#else
-#define __frame ___frame[CPUID]
-#endif
-
 #endif /* __ASSEMBLY__ */
 #else /* CONFIG_SMP */
 #ifndef __ASSEMBLY__
diff --git a/arch/mn10300/include/asm/thread_info.h b/arch/mn10300/include/asm/thread_info.h
index 2001cb6..aa07a4a 100644
--- a/arch/mn10300/include/asm/thread_info.h
+++ b/arch/mn10300/include/asm/thread_info.h
@@ -16,10 +16,6 @@
 
 #include <asm/page.h>
 
-#ifndef __ASSEMBLY__
-#include <asm/processor.h>
-#endif
-
 #define PREEMPT_ACTIVE		0x10000000
 
 #ifdef CONFIG_4KSTACKS
@@ -38,10 +34,14 @@
  *   must also be changed
  */
 #ifndef __ASSEMBLY__
+typedef struct {
+	unsigned long	seg;
+} mm_segment_t;
 
 struct thread_info {
 	struct task_struct	*task;		/* main task structure */
 	struct exec_domain	*exec_domain;	/* execution domain */
+	struct pt_regs		*frame;		/* current exception frame */
 	unsigned long		flags;		/* low level flags */
 	__u32			cpu;		/* current CPU */
 	__s32			preempt_count;	/* 0 => preemptable, <0 => BUG */
@@ -55,6 +55,10 @@ struct thread_info {
 	__u8			supervisor_stack[0];
 };
 
+#define thread_info_to_uregs(ti)					\
+	((struct pt_regs *)						\
+	 ((unsigned long)ti + THREAD_SIZE - sizeof(struct pt_regs)))
+
 #else /* !__ASSEMBLY__ */
 
 #ifndef __ASM_OFFSETS_H__
@@ -102,6 +106,12 @@ struct thread_info *current_thread_info(void)
 	return ti;
 }
 
+static inline __attribute__((const))
+struct pt_regs *current_frame(void)
+{
+	return current_thread_info()->frame;
+}
+
 /* how to get the current stack pointer from C */
 static inline unsigned long current_stack_pointer(void)
 {
diff --git a/arch/mn10300/include/asm/uaccess.h b/arch/mn10300/include/asm/uaccess.h
index 47e7951..679dee0 100644
--- a/arch/mn10300/include/asm/uaccess.h
+++ b/arch/mn10300/include/asm/uaccess.h
@@ -14,9 +14,8 @@
 /*
  * User space memory access functions
  */
-#include <linux/sched.h>
+#include <linux/thread_info.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/errno.h>
 
 #define VERIFY_READ 0
@@ -29,7 +28,6 @@
  *
  * For historical reasons, these macros are grossly misnamed.
  */
-
 #define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
 
 #define KERNEL_XDS	MAKE_MM_SEG(0xBFFFFFFF)
diff --git a/arch/mn10300/kernel/asm-offsets.c b/arch/mn10300/kernel/asm-offsets.c
index 54cc5b6..96f24fa 100644
--- a/arch/mn10300/kernel/asm-offsets.c
+++ b/arch/mn10300/kernel/asm-offsets.c
@@ -23,6 +23,7 @@ void foo(void)
 
 	OFFSET(TI_task,			thread_info, task);
 	OFFSET(TI_exec_domain,		thread_info, exec_domain);
+	OFFSET(TI_frame,		thread_info, frame);
 	OFFSET(TI_flags,		thread_info, flags);
 	OFFSET(TI_cpu,			thread_info, cpu);
 	OFFSET(TI_preempt_count,	thread_info, preempt_count);
@@ -66,7 +67,6 @@ void foo(void)
 	OFFSET(THREAD_SP,		thread_struct, sp);
 	OFFSET(THREAD_A3,		thread_struct, a3);
 	OFFSET(THREAD_USP,		thread_struct, usp);
-	OFFSET(THREAD_FRAME,		thread_struct, frame);
 #ifdef CONFIG_FPU
 	OFFSET(THREAD_FPU_FLAGS,	thread_struct, fpu_flags);
 	OFFSET(THREAD_FPU_STATE,	thread_struct, fpu_state);
diff --git a/arch/mn10300/kernel/mn10300-watchdog.c b/arch/mn10300/kernel/mn10300-watchdog.c
index 965dd61..c5e12bf 100644
--- a/arch/mn10300/kernel/mn10300-watchdog.c
+++ b/arch/mn10300/kernel/mn10300-watchdog.c
@@ -122,7 +122,7 @@ void __init watchdog_go(void)
 static void watchdog_dump_register(void *dummy)
 {
 	printk(KERN_ERR "--- Register Dump (CPU%d) ---\n", CPUID);
-	show_registers(__frame);
+	show_registers(current_frame());
 }
 #endif
 
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index b2e85ed..0d0f804 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -228,6 +228,7 @@ int copy_thread(unsigned long clone_flags,
 		unsigned long c_usp, unsigned long ustk_size,
 		struct task_struct *p, struct pt_regs *kregs)
 {
+	struct thread_info *ti = task_thread_info(p);
 	struct pt_regs *c_uregs, *c_kregs, *uregs;
 	unsigned long c_ksp;
 
@@ -248,7 +249,7 @@ int copy_thread(unsigned long clone_flags,
 
 	/* the new TLS pointer is passed in as arg #5 to sys_clone() */
 	if (clone_flags & CLONE_SETTLS)
-		c_uregs->e2 = __frame->d3;
+		c_uregs->e2 = current_frame()->d3;
 
 	/* set up the return kernel frame if called from kernel_thread() */
 	c_kregs = c_uregs;
@@ -266,7 +267,7 @@ int copy_thread(unsigned long clone_flags,
 	}
 
 	/* set up things up so the scheduler can start the new task */
-	p->thread.frame = c_kregs;
+	ti->frame	= c_kregs;
 	p->thread.a3	= (unsigned long) c_kregs;
 	p->thread.sp	= c_ksp;
 	p->thread.pc	= (unsigned long) ret_from_fork;
@@ -278,25 +279,26 @@ int copy_thread(unsigned long clone_flags,
 
 /*
  * clone a process
- * - tlsptr is retrieved by copy_thread() from __frame->d3
+ * - tlsptr is retrieved by copy_thread() from current_frame()->d3
  */
 asmlinkage long sys_clone(unsigned long clone_flags, unsigned long newsp,
 			  int __user *parent_tidptr, int __user *child_tidptr,
 			  int __user *tlsptr)
 {
-	return do_fork(clone_flags, newsp ?: __frame->sp, __frame, 0,
-		       parent_tidptr, child_tidptr);
+	return do_fork(clone_flags, newsp ?: current_frame()->sp,
+		       current_frame(), 0, parent_tidptr, child_tidptr);
 }
 
 asmlinkage long sys_fork(void)
 {
-	return do_fork(SIGCHLD, __frame->sp, __frame, 0, NULL, NULL);
+	return do_fork(SIGCHLD, current_frame()->sp,
+		       current_frame(), 0, NULL, NULL);
 }
 
 asmlinkage long sys_vfork(void)
 {
-	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, __frame->sp, __frame,
-		       0, NULL, NULL);
+	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, current_frame()->sp,
+		       current_frame(), 0, NULL, NULL);
 }
 
 asmlinkage long sys_execve(const char __user *name,
@@ -310,7 +312,7 @@ asmlinkage long sys_execve(const char __user *name,
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		return error;
-	error = do_execve(filename, argv, envp, __frame);
+	error = do_execve(filename, argv, envp, current_frame());
 	putname(filename);
 	return error;
 }
diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index d4de05a..690f4e9 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -91,7 +91,7 @@ asmlinkage long sys_sigaction(int sig,
  */
 asmlinkage long sys_sigaltstack(const stack_t __user *uss, stack_t *uoss)
 {
-	return do_sigaltstack(uss, uoss, __frame->sp);
+	return do_sigaltstack(uss, uoss, current_frame()->sp);
 }
 
 /*
@@ -156,10 +156,11 @@ badframe:
  */
 asmlinkage long sys_sigreturn(void)
 {
-	struct sigframe __user *frame = (struct sigframe __user *) __frame->sp;
+	struct sigframe __user *frame;
 	sigset_t set;
 	long d0;
 
+	frame = (struct sigframe __user *) current_frame()->sp;
 	if (verify_area(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
 	if (__get_user(set.sig[0], &frame->sc.oldmask))
@@ -176,7 +177,7 @@ asmlinkage long sys_sigreturn(void)
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	if (restore_sigcontext(__frame, &frame->sc, &d0))
+	if (restore_sigcontext(current_frame(), &frame->sc, &d0))
 		goto badframe;
 
 	return d0;
@@ -191,11 +192,11 @@ badframe:
  */
 asmlinkage long sys_rt_sigreturn(void)
 {
-	struct rt_sigframe __user *frame =
-		(struct rt_sigframe __user *) __frame->sp;
+	struct rt_sigframe __user *frame;
 	sigset_t set;
-	unsigned long d0;
+	long d0;
 
+	frame = (struct rt_sigframe __user *) current_frame()->sp;
 	if (verify_area(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
 	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
@@ -207,10 +208,11 @@ asmlinkage long sys_rt_sigreturn(void)
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	if (restore_sigcontext(__frame, &frame->uc.uc_mcontext, &d0))
+	if (restore_sigcontext(current_frame(), &frame->uc.uc_mcontext, &d0))
 		goto badframe;
 
-	if (do_sigaltstack(&frame->uc.uc_stack, NULL, __frame->sp) == -EFAULT)
+	if (do_sigaltstack(&frame->uc.uc_stack, NULL, current_frame()->sp) ==
+	    -EFAULT)
 		goto badframe;
 
 	return d0;
@@ -572,7 +574,7 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, u32 thread_info_flags)
 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
-		tracehook_notify_resume(__frame);
+		tracehook_notify_resume(current_frame());
 		if (current->replacement_session_keyring)
 			key_replace_session_keyring();
 	}
diff --git a/arch/mn10300/kernel/switch_to.S b/arch/mn10300/kernel/switch_to.S
index b08cb2e..9074d0f 100644
--- a/arch/mn10300/kernel/switch_to.S
+++ b/arch/mn10300/kernel/switch_to.S
@@ -38,15 +38,6 @@ ENTRY(__switch_to)
 	mov	d1,a1
 
 	# save prev context
-#ifdef CONFIG_SMP
-	mov	(CPUID),a2
-	add	a2,a2
-	add	a2,a2
-	mov	(___frame,a2),d0
-#else  /* CONFIG_SMP */
-	mov	(__frame),d0
-#endif /* CONFIG_SMP */
-	mov	d0,(THREAD_FRAME,a0)
 	mov	__switch_back,d0
 	mov	d0,(THREAD_PC,a0)
 	mov	sp,a2
@@ -68,15 +59,6 @@ ENTRY(__switch_to)
 	mov	a2,e2
 #endif
 
-	mov	(THREAD_FRAME,a1),a2
-#ifdef CONFIG_SMP
-	mov	(CPUID),a0
-	add	a0,a0
-	add	a0,a0
-	mov	a2,(___frame,a0)
-#else  /* CONFIG_SMP */
-	mov	a2,(__frame)
-#endif /* CONFIG_SMP */
 	mov	(THREAD_PC,a1),a2
 	mov	d2,d0			# for ret_from_fork
 	mov	d0,a0			# for __switch_to
diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index c924a1d..b90c3f1 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -45,14 +45,6 @@
 #error "INTERRUPT_VECTOR_BASE not aligned to 16MiB boundary!"
 #endif
 
-#ifdef CONFIG_SMP
-struct pt_regs *___frame[NR_CPUS]; /* current frame pointer */
-EXPORT_SYMBOL(___frame);
-#else  /* CONFIG_SMP */
-struct pt_regs *__frame; /* current frame pointer */
-EXPORT_SYMBOL(__frame);
-#endif /* CONFIG_SMP */
-
 int kstack_depth_to_print = 24;
 
 spinlock_t die_lock = __SPIN_LOCK_UNLOCKED(die_lock);
diff --git a/mm/maccess.c b/mm/maccess.c
index 4e348db..e2b6f56 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -1,9 +1,9 @@
 /*
  * Access kernel memory without faulting.
  */
-#include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/uaccess.h>
 
 /**
  * probe_kernel_read(): safely attempt to read from a location

