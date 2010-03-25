Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab0CYN4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:56:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55602 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab0CYN4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:56:16 -0400
Message-Id: <20100325135413.938004390@chello.nl>
References: <20100325135148.626077692@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 25 Mar 2010 14:51:50 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Markus Metzger <markus.t.metzger@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/3] x86, ptrace, bts: Delete the never used ptrace-bts code
Content-Disposition: inline; filename=undo-ptrace-bts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TIF_DEBUGCTLMSR is trampling all over that MSR without regard for
other uses (perf) and doesn't provide the flexibility needed for perf.

Its users are ptrace-block-step and ptrace-bts, since ptrace-bts was
never used and ptrace-block-step can be implemented using a much
simpler approach axe all of it.

Cc: Markus Metzger <markus.t.metzger@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/Kconfig.cpu               |   20 
 arch/x86/Kconfig.debug             |    9 
 arch/x86/include/asm/ds.h          |  302 -------
 arch/x86/include/asm/processor.h   |   32 
 arch/x86/include/asm/ptrace-abi.h  |   59 -
 arch/x86/include/asm/ptrace.h      |   10 
 arch/x86/include/asm/thread_info.h |    6 
 arch/x86/kernel/Makefile           |    2 
 arch/x86/kernel/cpu/intel.c        |    2 
 arch/x86/kernel/ds.c               | 1437 -------------------------------------
 arch/x86/kernel/ds_selftest.c      |  408 ----------
 arch/x86/kernel/ds_selftest.h      |   15 
 arch/x86/kernel/dumpstack.c        |    5 
 arch/x86/kernel/kprobes.c          |    6 
 arch/x86/kernel/process.c          |    9 
 arch/x86/kernel/process_32.c       |    8 
 arch/x86/kernel/process_64.c       |    8 
 arch/x86/kernel/ptrace.c           |  382 ---------
 arch/x86/kernel/step.c             |   36 
 arch/x86/kernel/traps.c            |    5 
 include/linux/ftrace.h             |   12 
 include/linux/mm.h                 |    4 
 include/linux/ptrace.h             |   12 
 include/linux/sched.h              |    9 
 kernel/fork.c                      |    3 
 kernel/ptrace.c                    |    1 
 kernel/sched.c                     |   43 -
 kernel/trace/Kconfig               |   11 
 kernel/trace/Makefile              |    1 
 kernel/trace/trace.h               |    4 
 kernel/trace/trace_entries.h       |   12 
 kernel/trace/trace_hw_branches.c   |  312 --------
 kernel/trace/trace_selftest.c      |   57 -
 mm/mlock.c                         |   41 -
 34 files changed, 8 insertions(+), 3275 deletions(-)

Index: linux-2.6/arch/x86/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/ptrace.c
+++ linux-2.6/arch/x86/kernel/ptrace.c
@@ -2,9 +2,6 @@
 /*
  * Pentium III FXSR, SSE support
  *	Gareth Hughes <gareth@valinux.com>, May 2000
- *
- * BTS tracing
- *	Markus Metzger <markus.t.metzger@intel.com>, Dec 2007
  */
 
 #include <linux/kernel.h>
@@ -21,7 +18,6 @@
 #include <linux/audit.h>
 #include <linux/seccomp.h>
 #include <linux/signal.h>
-#include <linux/workqueue.h>
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
 
@@ -35,7 +31,6 @@
 #include <asm/desc.h>
 #include <asm/prctl.h>
 #include <asm/proto.h>
-#include <asm/ds.h>
 #include <asm/hw_breakpoint.h>
 
 #include "tls.h"
@@ -788,342 +783,6 @@ static int ioperm_get(struct task_struct
 				   0, IO_BITMAP_BYTES);
 }
 
-#ifdef CONFIG_X86_PTRACE_BTS
-/*
- * A branch trace store context.
- *
- * Contexts may only be installed by ptrace_bts_config() and only for
- * ptraced tasks.
- *
- * Contexts are destroyed when the tracee is detached from the tracer.
- * The actual destruction work requires interrupts enabled, so the
- * work is deferred and will be scheduled during __ptrace_unlink().
- *
- * Contexts hold an additional task_struct reference on the traced
- * task, as well as a reference on the tracer's mm.
- *
- * Ptrace already holds a task_struct for the duration of ptrace operations,
- * but since destruction is deferred, it may be executed after both
- * tracer and tracee exited.
- */
-struct bts_context {
-	/* The branch trace handle. */
-	struct bts_tracer	*tracer;
-
-	/* The buffer used to store the branch trace and its size. */
-	void			*buffer;
-	unsigned int		size;
-
-	/* The mm that paid for the above buffer. */
-	struct mm_struct	*mm;
-
-	/* The task this context belongs to. */
-	struct task_struct	*task;
-
-	/* The signal to send on a bts buffer overflow. */
-	unsigned int		bts_ovfl_signal;
-
-	/* The work struct to destroy a context. */
-	struct work_struct	work;
-};
-
-static int alloc_bts_buffer(struct bts_context *context, unsigned int size)
-{
-	void *buffer = NULL;
-	int err = -ENOMEM;
-
-	err = account_locked_memory(current->mm, current->signal->rlim, size);
-	if (err < 0)
-		return err;
-
-	buffer = kzalloc(size, GFP_KERNEL);
-	if (!buffer)
-		goto out_refund;
-
-	context->buffer = buffer;
-	context->size = size;
-	context->mm = get_task_mm(current);
-
-	return 0;
-
- out_refund:
-	refund_locked_memory(current->mm, size);
-	return err;
-}
-
-static inline void free_bts_buffer(struct bts_context *context)
-{
-	if (!context->buffer)
-		return;
-
-	kfree(context->buffer);
-	context->buffer = NULL;
-
-	refund_locked_memory(context->mm, context->size);
-	context->size = 0;
-
-	mmput(context->mm);
-	context->mm = NULL;
-}
-
-static void free_bts_context_work(struct work_struct *w)
-{
-	struct bts_context *context;
-
-	context = container_of(w, struct bts_context, work);
-
-	ds_release_bts(context->tracer);
-	put_task_struct(context->task);
-	free_bts_buffer(context);
-	kfree(context);
-}
-
-static inline void free_bts_context(struct bts_context *context)
-{
-	INIT_WORK(&context->work, free_bts_context_work);
-	schedule_work(&context->work);
-}
-
-static inline struct bts_context *alloc_bts_context(struct task_struct *task)
-{
-	struct bts_context *context = kzalloc(sizeof(*context), GFP_KERNEL);
-	if (context) {
-		context->task = task;
-		task->bts = context;
-
-		get_task_struct(task);
-	}
-
-	return context;
-}
-
-static int ptrace_bts_read_record(struct task_struct *child, size_t index,
-				  struct bts_struct __user *out)
-{
-	struct bts_context *context;
-	const struct bts_trace *trace;
-	struct bts_struct bts;
-	const unsigned char *at;
-	int error;
-
-	context = child->bts;
-	if (!context)
-		return -ESRCH;
-
-	trace = ds_read_bts(context->tracer);
-	if (!trace)
-		return -ESRCH;
-
-	at = trace->ds.top - ((index + 1) * trace->ds.size);
-	if ((void *)at < trace->ds.begin)
-		at += (trace->ds.n * trace->ds.size);
-
-	if (!trace->read)
-		return -EOPNOTSUPP;
-
-	error = trace->read(context->tracer, at, &bts);
-	if (error < 0)
-		return error;
-
-	if (copy_to_user(out, &bts, sizeof(bts)))
-		return -EFAULT;
-
-	return sizeof(bts);
-}
-
-static int ptrace_bts_drain(struct task_struct *child,
-			    long size,
-			    struct bts_struct __user *out)
-{
-	struct bts_context *context;
-	const struct bts_trace *trace;
-	const unsigned char *at;
-	int error, drained = 0;
-
-	context = child->bts;
-	if (!context)
-		return -ESRCH;
-
-	trace = ds_read_bts(context->tracer);
-	if (!trace)
-		return -ESRCH;
-
-	if (!trace->read)
-		return -EOPNOTSUPP;
-
-	if (size < (trace->ds.top - trace->ds.begin))
-		return -EIO;
-
-	for (at = trace->ds.begin; (void *)at < trace->ds.top;
-	     out++, drained++, at += trace->ds.size) {
-		struct bts_struct bts;
-
-		error = trace->read(context->tracer, at, &bts);
-		if (error < 0)
-			return error;
-
-		if (copy_to_user(out, &bts, sizeof(bts)))
-			return -EFAULT;
-	}
-
-	memset(trace->ds.begin, 0, trace->ds.n * trace->ds.size);
-
-	error = ds_reset_bts(context->tracer);
-	if (error < 0)
-		return error;
-
-	return drained;
-}
-
-static int ptrace_bts_config(struct task_struct *child,
-			     long cfg_size,
-			     const struct ptrace_bts_config __user *ucfg)
-{
-	struct bts_context *context;
-	struct ptrace_bts_config cfg;
-	unsigned int flags = 0;
-
-	if (cfg_size < sizeof(cfg))
-		return -EIO;
-
-	if (copy_from_user(&cfg, ucfg, sizeof(cfg)))
-		return -EFAULT;
-
-	context = child->bts;
-	if (!context)
-		context = alloc_bts_context(child);
-	if (!context)
-		return -ENOMEM;
-
-	if (cfg.flags & PTRACE_BTS_O_SIGNAL) {
-		if (!cfg.signal)
-			return -EINVAL;
-
-		return -EOPNOTSUPP;
-		context->bts_ovfl_signal = cfg.signal;
-	}
-
-	ds_release_bts(context->tracer);
-	context->tracer = NULL;
-
-	if ((cfg.flags & PTRACE_BTS_O_ALLOC) && (cfg.size != context->size)) {
-		int err;
-
-		free_bts_buffer(context);
-		if (!cfg.size)
-			return 0;
-
-		err = alloc_bts_buffer(context, cfg.size);
-		if (err < 0)
-			return err;
-	}
-
-	if (cfg.flags & PTRACE_BTS_O_TRACE)
-		flags |= BTS_USER;
-
-	if (cfg.flags & PTRACE_BTS_O_SCHED)
-		flags |= BTS_TIMESTAMPS;
-
-	context->tracer =
-		ds_request_bts_task(child, context->buffer, context->size,
-				    NULL, (size_t)-1, flags);
-	if (unlikely(IS_ERR(context->tracer))) {
-		int error = PTR_ERR(context->tracer);
-
-		free_bts_buffer(context);
-		context->tracer = NULL;
-		return error;
-	}
-
-	return sizeof(cfg);
-}
-
-static int ptrace_bts_status(struct task_struct *child,
-			     long cfg_size,
-			     struct ptrace_bts_config __user *ucfg)
-{
-	struct bts_context *context;
-	const struct bts_trace *trace;
-	struct ptrace_bts_config cfg;
-
-	context = child->bts;
-	if (!context)
-		return -ESRCH;
-
-	if (cfg_size < sizeof(cfg))
-		return -EIO;
-
-	trace = ds_read_bts(context->tracer);
-	if (!trace)
-		return -ESRCH;
-
-	memset(&cfg, 0, sizeof(cfg));
-	cfg.size	= trace->ds.end - trace->ds.begin;
-	cfg.signal	= context->bts_ovfl_signal;
-	cfg.bts_size	= sizeof(struct bts_struct);
-
-	if (cfg.signal)
-		cfg.flags |= PTRACE_BTS_O_SIGNAL;
-
-	if (trace->ds.flags & BTS_USER)
-		cfg.flags |= PTRACE_BTS_O_TRACE;
-
-	if (trace->ds.flags & BTS_TIMESTAMPS)
-		cfg.flags |= PTRACE_BTS_O_SCHED;
-
-	if (copy_to_user(ucfg, &cfg, sizeof(cfg)))
-		return -EFAULT;
-
-	return sizeof(cfg);
-}
-
-static int ptrace_bts_clear(struct task_struct *child)
-{
-	struct bts_context *context;
-	const struct bts_trace *trace;
-
-	context = child->bts;
-	if (!context)
-		return -ESRCH;
-
-	trace = ds_read_bts(context->tracer);
-	if (!trace)
-		return -ESRCH;
-
-	memset(trace->ds.begin, 0, trace->ds.n * trace->ds.size);
-
-	return ds_reset_bts(context->tracer);
-}
-
-static int ptrace_bts_size(struct task_struct *child)
-{
-	struct bts_context *context;
-	const struct bts_trace *trace;
-
-	context = child->bts;
-	if (!context)
-		return -ESRCH;
-
-	trace = ds_read_bts(context->tracer);
-	if (!trace)
-		return -ESRCH;
-
-	return (trace->ds.top - trace->ds.begin) / trace->ds.size;
-}
-
-/*
- * Called from __ptrace_unlink() after the child has been moved back
- * to its original parent.
- */
-void ptrace_bts_untrace(struct task_struct *child)
-{
-	if (unlikely(child->bts)) {
-		free_bts_context(child->bts);
-		child->bts = NULL;
-	}
-}
-#endif /* CONFIG_X86_PTRACE_BTS */
-
 /*
  * Called by kernel/ptrace.c when detaching..
  *
@@ -1251,39 +910,6 @@ long arch_ptrace(struct task_struct *chi
 		break;
 #endif
 
-	/*
-	 * These bits need more cooking - not enabled yet:
-	 */
-#ifdef CONFIG_X86_PTRACE_BTS
-	case PTRACE_BTS_CONFIG:
-		ret = ptrace_bts_config
-			(child, data, (struct ptrace_bts_config __user *)addr);
-		break;
-
-	case PTRACE_BTS_STATUS:
-		ret = ptrace_bts_status
-			(child, data, (struct ptrace_bts_config __user *)addr);
-		break;
-
-	case PTRACE_BTS_SIZE:
-		ret = ptrace_bts_size(child);
-		break;
-
-	case PTRACE_BTS_GET:
-		ret = ptrace_bts_read_record
-			(child, data, (struct bts_struct __user *) addr);
-		break;
-
-	case PTRACE_BTS_CLEAR:
-		ret = ptrace_bts_clear(child);
-		break;
-
-	case PTRACE_BTS_DRAIN:
-		ret = ptrace_bts_drain
-			(child, data, (struct bts_struct __user *) addr);
-		break;
-#endif /* CONFIG_X86_PTRACE_BTS */
-
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
@@ -1543,14 +1169,6 @@ long compat_arch_ptrace(struct task_stru
 
 	case PTRACE_GET_THREAD_AREA:
 	case PTRACE_SET_THREAD_AREA:
-#ifdef CONFIG_X86_PTRACE_BTS
-	case PTRACE_BTS_CONFIG:
-	case PTRACE_BTS_STATUS:
-	case PTRACE_BTS_SIZE:
-	case PTRACE_BTS_GET:
-	case PTRACE_BTS_CLEAR:
-	case PTRACE_BTS_DRAIN:
-#endif /* CONFIG_X86_PTRACE_BTS */
 		return arch_ptrace(child, request, addr, data);
 
 	default:
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -19,7 +19,6 @@ struct anon_vma;
 struct file_ra_state;
 struct user_struct;
 struct writeback_control;
-struct rlimit;
 
 #ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
@@ -1449,9 +1448,6 @@ int vmemmap_populate_basepages(struct pa
 int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
 void vmemmap_populate_print_last(void);
 
-extern int account_locked_memory(struct mm_struct *mm, struct rlimit *rlim,
-				 size_t size);
-extern void refund_locked_memory(struct mm_struct *mm, size_t size);
 
 enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
Index: linux-2.6/mm/mlock.c
===================================================================
--- linux-2.6.orig/mm/mlock.c
+++ linux-2.6/mm/mlock.c
@@ -607,44 +607,3 @@ void user_shm_unlock(size_t size, struct
 	spin_unlock(&shmlock_user_lock);
 	free_uid(user);
 }
-
-int account_locked_memory(struct mm_struct *mm, struct rlimit *rlim,
-			  size_t size)
-{
-	unsigned long lim, vm, pgsz;
-	int error = -ENOMEM;
-
-	pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
-
-	down_write(&mm->mmap_sem);
-
-	lim = ACCESS_ONCE(rlim[RLIMIT_AS].rlim_cur) >> PAGE_SHIFT;
-	vm   = mm->total_vm + pgsz;
-	if (lim < vm)
-		goto out;
-
-	lim = ACCESS_ONCE(rlim[RLIMIT_MEMLOCK].rlim_cur) >> PAGE_SHIFT;
-	vm   = mm->locked_vm + pgsz;
-	if (lim < vm)
-		goto out;
-
-	mm->total_vm  += pgsz;
-	mm->locked_vm += pgsz;
-
-	error = 0;
- out:
-	up_write(&mm->mmap_sem);
-	return error;
-}
-
-void refund_locked_memory(struct mm_struct *mm, size_t size)
-{
-	unsigned long pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
-
-	down_write(&mm->mmap_sem);
-
-	mm->total_vm  -= pgsz;
-	mm->locked_vm -= pgsz;
-
-	up_write(&mm->mmap_sem);
-}
Index: linux-2.6/arch/x86/Kconfig.cpu
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig.cpu
+++ linux-2.6/arch/x86/Kconfig.cpu
@@ -502,23 +502,3 @@ config CPU_SUP_UMC_32
 	  CPU might render the kernel unbootable.
 
 	  If unsure, say N.
-
-config X86_DS
-	def_bool X86_PTRACE_BTS
-	depends on X86_DEBUGCTLMSR
-	select HAVE_HW_BRANCH_TRACER
-
-config X86_PTRACE_BTS
-	bool "Branch Trace Store"
-	default y
-	depends on X86_DEBUGCTLMSR
-	depends on BROKEN
-	---help---
-	  This adds a ptrace interface to the hardware's branch trace store.
-
-	  Debuggers may use it to collect an execution trace of the debugged
-	  application in order to answer the question 'how did I get here?'.
-	  Debuggers may trace user mode as well as kernel mode.
-
-	  Say Y unless there is no application development on this machine
-	  and you want to save a small amount of code size.
Index: linux-2.6/arch/x86/include/asm/ptrace.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/ptrace.h
+++ linux-2.6/arch/x86/include/asm/ptrace.h
@@ -127,12 +127,10 @@ struct pt_regs {
 #endif /* __KERNEL__ */
 #endif /* !__i386__ */
 
-
 #ifdef __KERNEL__
 
-#include <linux/init.h>
+#include <linux/stddef.h>
 
-struct cpuinfo_x86;
 struct task_struct;
 
 extern unsigned long profile_pc(struct pt_regs *regs);
@@ -289,12 +287,6 @@ extern int do_get_thread_area(struct tas
 extern int do_set_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info, int can_allocate);
 
-#ifdef CONFIG_X86_PTRACE_BTS
-extern void ptrace_bts_untrace(struct task_struct *tsk);
-
-#define arch_ptrace_untrace(tsk)	ptrace_bts_untrace(tsk)
-#endif /* CONFIG_X86_PTRACE_BTS */
-
 #endif /* __KERNEL__ */
 
 #endif /* !__ASSEMBLY__ */
Index: linux-2.6/include/linux/ptrace.h
===================================================================
--- linux-2.6.orig/include/linux/ptrace.h
+++ linux-2.6/include/linux/ptrace.h
@@ -345,18 +345,6 @@ static inline void user_single_step_sigi
 #define arch_ptrace_stop(code, info)		do { } while (0)
 #endif
 
-#ifndef arch_ptrace_untrace
-/*
- * Do machine-specific work before untracing child.
- *
- * This is called for a normal detach as well as from ptrace_exit()
- * when the tracing task dies.
- *
- * Called with write_lock(&tasklist_lock) held.
- */
-#define arch_ptrace_untrace(task)		do { } while (0)
-#endif
-
 extern int task_current_syscall(struct task_struct *target, long *callno,
 				unsigned long args[6], unsigned int maxargs,
 				unsigned long *sp, unsigned long *pc);
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -99,7 +99,6 @@ struct futex_pi_state;
 struct robust_list_head;
 struct bio_list;
 struct fs_struct;
-struct bts_context;
 struct perf_event_context;
 
 /*
@@ -1268,12 +1267,6 @@ struct task_struct {
 	struct list_head ptraced;
 	struct list_head ptrace_entry;
 
-	/*
-	 * This is the tracer handle for the ptrace BTS extension.
-	 * This field actually belongs to the ptracer task.
-	 */
-	struct bts_context *bts;
-
 	/* PID/PID hash table linkage. */
 	struct pid_link pids[PIDTYPE_MAX];
 	struct list_head thread_group;
@@ -2119,10 +2112,8 @@ extern void set_task_comm(struct task_st
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
-extern void wait_task_context_switch(struct task_struct *p);
 extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
 #else
-static inline void wait_task_context_switch(struct task_struct *p) {}
 static inline unsigned long wait_task_inactive(struct task_struct *p,
 					       long match_state)
 {
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -1108,9 +1108,6 @@ static struct task_struct *copy_process(
 	p->memcg_batch.do_batch = 0;
 	p->memcg_batch.memcg = NULL;
 #endif
-
-	p->bts = NULL;
-
 	p->stack_start = stack_start;
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
Index: linux-2.6/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/kernel/ptrace.c
+++ linux-2.6/kernel/ptrace.c
@@ -76,7 +76,6 @@ void __ptrace_unlink(struct task_struct 
 	child->parent = child->real_parent;
 	list_del_init(&child->ptrace_entry);
 
-	arch_ptrace_untrace(child);
 	if (task_is_traced(child))
 		ptrace_untrace(child);
 }
Index: linux-2.6/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/processor.h
+++ linux-2.6/arch/x86/include/asm/processor.h
@@ -21,7 +21,6 @@ struct mm_struct;
 #include <asm/msr.h>
 #include <asm/desc_defs.h>
 #include <asm/nops.h>
-#include <asm/ds.h>
 
 #include <linux/personality.h>
 #include <linux/cpumask.h>
@@ -473,10 +472,6 @@ struct thread_struct {
 	unsigned long		iopl;
 	/* Max allowed port in the bitmap, in bytes: */
 	unsigned		io_bitmap_max;
-/* MSR_IA32_DEBUGCTLMSR value to switch in if TIF_DEBUGCTLMSR is set.  */
-	unsigned long	debugctlmsr;
-	/* Debug Store context; see asm/ds.h */
-	struct ds_context	*ds_ctx;
 };
 
 static inline unsigned long native_get_debugreg(int regno)
@@ -814,21 +809,6 @@ static inline unsigned long get_debugctl
     return debugctlmsr;
 }
 
-static inline unsigned long get_debugctlmsr_on_cpu(int cpu)
-{
-	u64 debugctlmsr = 0;
-	u32 val1, val2;
-
-#ifndef CONFIG_X86_DEBUGCTLMSR
-	if (boot_cpu_data.x86 < 6)
-		return 0;
-#endif
-	rdmsr_on_cpu(cpu, MSR_IA32_DEBUGCTLMSR, &val1, &val2);
-	debugctlmsr = val1 | ((u64)val2 << 32);
-
-	return debugctlmsr;
-}
-
 static inline void update_debugctlmsr(unsigned long debugctlmsr)
 {
 #ifndef CONFIG_X86_DEBUGCTLMSR
@@ -838,18 +818,6 @@ static inline void update_debugctlmsr(un
 	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctlmsr);
 }
 
-static inline void update_debugctlmsr_on_cpu(int cpu,
-					     unsigned long debugctlmsr)
-{
-#ifndef CONFIG_X86_DEBUGCTLMSR
-	if (boot_cpu_data.x86 < 6)
-		return;
-#endif
-	wrmsr_on_cpu(cpu, MSR_IA32_DEBUGCTLMSR,
-		     (u32)((u64)debugctlmsr),
-		     (u32)((u64)debugctlmsr >> 32));
-}
-
 /*
  * from system description table in BIOS. Mostly for MCA use, but
  * others may find it useful:
Index: linux-2.6/arch/x86/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process.c
+++ linux-2.6/arch/x86/kernel/process.c
@@ -20,7 +20,6 @@
 #include <asm/idle.h>
 #include <asm/uaccess.h>
 #include <asm/i387.h>
-#include <asm/ds.h>
 #include <asm/debugreg.h>
 
 unsigned long idle_halt;
@@ -50,8 +49,6 @@ void free_thread_xstate(struct task_stru
 		kmem_cache_free(task_xstate_cachep, tsk->thread.xstate);
 		tsk->thread.xstate = NULL;
 	}
-
-	WARN(tsk->thread.ds_ctx, "leaking DS context\n");
 }
 
 void free_thread_info(struct thread_info *ti)
@@ -198,12 +195,6 @@ void __switch_to_xtra(struct task_struct
 	prev = &prev_p->thread;
 	next = &next_p->thread;
 
-	if (test_tsk_thread_flag(next_p, TIF_DS_AREA_MSR) ||
-	    test_tsk_thread_flag(prev_p, TIF_DS_AREA_MSR))
-		ds_switch_to(prev_p, next_p);
-	else if (next->debugctlmsr != prev->debugctlmsr)
-		update_debugctlmsr(next->debugctlmsr);
-
 	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
 	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
 		/* prev and next are different */
Index: linux-2.6/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process_32.c
+++ linux-2.6/arch/x86/kernel/process_32.c
@@ -55,7 +55,6 @@
 #include <asm/cpu.h>
 #include <asm/idle.h>
 #include <asm/syscalls.h>
-#include <asm/ds.h>
 #include <asm/debugreg.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
@@ -238,13 +237,6 @@ int copy_thread(unsigned long clone_flag
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
-
-	clear_tsk_thread_flag(p, TIF_DS_AREA_MSR);
-	p->thread.ds_ctx = NULL;
-
-	clear_tsk_thread_flag(p, TIF_DEBUGCTLMSR);
-	p->thread.debugctlmsr = 0;
-
 	return err;
 }
 
Index: linux-2.6/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process_64.c
+++ linux-2.6/arch/x86/kernel/process_64.c
@@ -49,7 +49,6 @@
 #include <asm/ia32.h>
 #include <asm/idle.h>
 #include <asm/syscalls.h>
-#include <asm/ds.h>
 #include <asm/debugreg.h>
 
 asmlinkage extern void ret_from_fork(void);
@@ -313,13 +312,6 @@ int copy_thread(unsigned long clone_flag
 		if (err)
 			goto out;
 	}
-
-	clear_tsk_thread_flag(p, TIF_DS_AREA_MSR);
-	p->thread.ds_ctx = NULL;
-
-	clear_tsk_thread_flag(p, TIF_DEBUGCTLMSR);
-	p->thread.debugctlmsr = 0;
-
 	err = 0;
 out:
 	if (err && p->thread.io_bitmap_ptr) {
Index: linux-2.6/kernel/trace/trace_selftest.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_selftest.c
+++ linux-2.6/kernel/trace/trace_selftest.c
@@ -16,7 +16,6 @@ static inline int trace_valid_entry(stru
 	case TRACE_BRANCH:
 	case TRACE_GRAPH_ENT:
 	case TRACE_GRAPH_RET:
-	case TRACE_HW_BRANCHES:
 	case TRACE_KSYM:
 		return 1;
 	}
@@ -754,62 +753,6 @@ trace_selftest_startup_branch(struct tra
 }
 #endif /* CONFIG_BRANCH_TRACER */
 
-#ifdef CONFIG_HW_BRANCH_TRACER
-int
-trace_selftest_startup_hw_branches(struct tracer *trace,
-				   struct trace_array *tr)
-{
-	struct trace_iterator *iter;
-	struct tracer tracer;
-	unsigned long count;
-	int ret;
-
-	if (!trace->open) {
-		printk(KERN_CONT "missing open function...");
-		return -1;
-	}
-
-	ret = tracer_init(trace, tr);
-	if (ret) {
-		warn_failed_init_tracer(trace, ret);
-		return ret;
-	}
-
-	/*
-	 * The hw-branch tracer needs to collect the trace from the various
-	 * cpu trace buffers - before tracing is stopped.
-	 */
-	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
-	if (!iter)
-		return -ENOMEM;
-
-	memcpy(&tracer, trace, sizeof(tracer));
-
-	iter->trace = &tracer;
-	iter->tr = tr;
-	iter->pos = -1;
-	mutex_init(&iter->mutex);
-
-	trace->open(iter);
-
-	mutex_destroy(&iter->mutex);
-	kfree(iter);
-
-	tracing_stop();
-
-	ret = trace_test_buffer(tr, &count);
-	trace->reset(tr);
-	tracing_start();
-
-	if (!ret && !count) {
-		printk(KERN_CONT "no entries found..");
-		ret = -1;
-	}
-
-	return ret;
-}
-#endif /* CONFIG_HW_BRANCH_TRACER */
-
 #ifdef CONFIG_KSYM_TRACER
 static int ksym_selftest_dummy;
 
Index: linux-2.6/kernel/trace/trace_hw_branches.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_hw_branches.c
+++ /dev/null
@@ -1,312 +0,0 @@
-/*
- * h/w branch tracer for x86 based on BTS
- *
- * Copyright (C) 2008-2009 Intel Corporation.
- * Markus Metzger <markus.t.metzger@gmail.com>, 2008-2009
- */
-#include <linux/kallsyms.h>
-#include <linux/debugfs.h>
-#include <linux/ftrace.h>
-#include <linux/module.h>
-#include <linux/cpu.h>
-#include <linux/smp.h>
-#include <linux/fs.h>
-
-#include <asm/ds.h>
-
-#include "trace_output.h"
-#include "trace.h"
-
-
-#define BTS_BUFFER_SIZE (1 << 13)
-
-static DEFINE_PER_CPU(struct bts_tracer *, hwb_tracer);
-static DEFINE_PER_CPU(unsigned char[BTS_BUFFER_SIZE], hwb_buffer);
-
-#define this_tracer per_cpu(hwb_tracer, smp_processor_id())
-
-static int trace_hw_branches_enabled __read_mostly;
-static int trace_hw_branches_suspended __read_mostly;
-static struct trace_array *hw_branch_trace __read_mostly;
-
-
-static void bts_trace_init_cpu(int cpu)
-{
-	per_cpu(hwb_tracer, cpu) =
-		ds_request_bts_cpu(cpu, per_cpu(hwb_buffer, cpu),
-				   BTS_BUFFER_SIZE, NULL, (size_t)-1,
-				   BTS_KERNEL);
-
-	if (IS_ERR(per_cpu(hwb_tracer, cpu)))
-		per_cpu(hwb_tracer, cpu) = NULL;
-}
-
-static int bts_trace_init(struct trace_array *tr)
-{
-	int cpu;
-
-	hw_branch_trace = tr;
-	trace_hw_branches_enabled = 0;
-
-	get_online_cpus();
-	for_each_online_cpu(cpu) {
-		bts_trace_init_cpu(cpu);
-
-		if (likely(per_cpu(hwb_tracer, cpu)))
-			trace_hw_branches_enabled = 1;
-	}
-	trace_hw_branches_suspended = 0;
-	put_online_cpus();
-
-	/* If we could not enable tracing on a single cpu, we fail. */
-	return trace_hw_branches_enabled ? 0 : -EOPNOTSUPP;
-}
-
-static void bts_trace_reset(struct trace_array *tr)
-{
-	int cpu;
-
-	get_online_cpus();
-	for_each_online_cpu(cpu) {
-		if (likely(per_cpu(hwb_tracer, cpu))) {
-			ds_release_bts(per_cpu(hwb_tracer, cpu));
-			per_cpu(hwb_tracer, cpu) = NULL;
-		}
-	}
-	trace_hw_branches_enabled = 0;
-	trace_hw_branches_suspended = 0;
-	put_online_cpus();
-}
-
-static void bts_trace_start(struct trace_array *tr)
-{
-	int cpu;
-
-	get_online_cpus();
-	for_each_online_cpu(cpu)
-		if (likely(per_cpu(hwb_tracer, cpu)))
-			ds_resume_bts(per_cpu(hwb_tracer, cpu));
-	trace_hw_branches_suspended = 0;
-	put_online_cpus();
-}
-
-static void bts_trace_stop(struct trace_array *tr)
-{
-	int cpu;
-
-	get_online_cpus();
-	for_each_online_cpu(cpu)
-		if (likely(per_cpu(hwb_tracer, cpu)))
-			ds_suspend_bts(per_cpu(hwb_tracer, cpu));
-	trace_hw_branches_suspended = 1;
-	put_online_cpus();
-}
-
-static int __cpuinit bts_hotcpu_handler(struct notifier_block *nfb,
-				     unsigned long action, void *hcpu)
-{
-	int cpu = (long)hcpu;
-
-	switch (action) {
-	case CPU_ONLINE:
-	case CPU_DOWN_FAILED:
-		/* The notification is sent with interrupts enabled. */
-		if (trace_hw_branches_enabled) {
-			bts_trace_init_cpu(cpu);
-
-			if (trace_hw_branches_suspended &&
-			    likely(per_cpu(hwb_tracer, cpu)))
-				ds_suspend_bts(per_cpu(hwb_tracer, cpu));
-		}
-		break;
-
-	case CPU_DOWN_PREPARE:
-		/* The notification is sent with interrupts enabled. */
-		if (likely(per_cpu(hwb_tracer, cpu))) {
-			ds_release_bts(per_cpu(hwb_tracer, cpu));
-			per_cpu(hwb_tracer, cpu) = NULL;
-		}
-	}
-
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block bts_hotcpu_notifier __cpuinitdata = {
-	.notifier_call = bts_hotcpu_handler
-};
-
-static void bts_trace_print_header(struct seq_file *m)
-{
-	seq_puts(m, "# CPU#        TO  <-  FROM\n");
-}
-
-static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
-{
-	unsigned long symflags = TRACE_ITER_SYM_OFFSET;
-	struct trace_entry *entry = iter->ent;
-	struct trace_seq *seq = &iter->seq;
-	struct hw_branch_entry *it;
-
-	trace_assign_type(it, entry);
-
-	if (entry->type == TRACE_HW_BRANCHES) {
-		if (trace_seq_printf(seq, "%4d  ", iter->cpu) &&
-		    seq_print_ip_sym(seq, it->to, symflags) &&
-		    trace_seq_printf(seq, "\t  <-  ") &&
-		    seq_print_ip_sym(seq, it->from, symflags) &&
-		    trace_seq_printf(seq, "\n"))
-			return TRACE_TYPE_HANDLED;
-		return TRACE_TYPE_PARTIAL_LINE;
-	}
-	return TRACE_TYPE_UNHANDLED;
-}
-
-void trace_hw_branch(u64 from, u64 to)
-{
-	struct ftrace_event_call *call = &event_hw_branch;
-	struct trace_array *tr = hw_branch_trace;
-	struct ring_buffer_event *event;
-	struct ring_buffer *buf;
-	struct hw_branch_entry *entry;
-	unsigned long irq1;
-	int cpu;
-
-	if (unlikely(!tr))
-		return;
-
-	if (unlikely(!trace_hw_branches_enabled))
-		return;
-
-	local_irq_save(irq1);
-	cpu = raw_smp_processor_id();
-	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
-		goto out;
-
-	buf = tr->buffer;
-	event = trace_buffer_lock_reserve(buf, TRACE_HW_BRANCHES,
-					  sizeof(*entry), 0, 0);
-	if (!event)
-		goto out;
-	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, 0, from);
-	entry->ent.type = TRACE_HW_BRANCHES;
-	entry->from = from;
-	entry->to   = to;
-	if (!filter_check_discard(call, entry, buf, event))
-		trace_buffer_unlock_commit(buf, event, 0, 0);
-
- out:
-	atomic_dec(&tr->data[cpu]->disabled);
-	local_irq_restore(irq1);
-}
-
-static void trace_bts_at(const struct bts_trace *trace, void *at)
-{
-	struct bts_struct bts;
-	int err = 0;
-
-	WARN_ON_ONCE(!trace->read);
-	if (!trace->read)
-		return;
-
-	err = trace->read(this_tracer, at, &bts);
-	if (err < 0)
-		return;
-
-	switch (bts.qualifier) {
-	case BTS_BRANCH:
-		trace_hw_branch(bts.variant.lbr.from, bts.variant.lbr.to);
-		break;
-	}
-}
-
-/*
- * Collect the trace on the current cpu and write it into the ftrace buffer.
- *
- * pre: tracing must be suspended on the current cpu
- */
-static void trace_bts_cpu(void *arg)
-{
-	struct trace_array *tr = (struct trace_array *)arg;
-	const struct bts_trace *trace;
-	unsigned char *at;
-
-	if (unlikely(!tr))
-		return;
-
-	if (unlikely(atomic_read(&tr->data[raw_smp_processor_id()]->disabled)))
-		return;
-
-	if (unlikely(!this_tracer))
-		return;
-
-	trace = ds_read_bts(this_tracer);
-	if (!trace)
-		return;
-
-	for (at = trace->ds.top; (void *)at < trace->ds.end;
-	     at += trace->ds.size)
-		trace_bts_at(trace, at);
-
-	for (at = trace->ds.begin; (void *)at < trace->ds.top;
-	     at += trace->ds.size)
-		trace_bts_at(trace, at);
-}
-
-static void trace_bts_prepare(struct trace_iterator *iter)
-{
-	int cpu;
-
-	get_online_cpus();
-	for_each_online_cpu(cpu)
-		if (likely(per_cpu(hwb_tracer, cpu)))
-			ds_suspend_bts(per_cpu(hwb_tracer, cpu));
-	/*
-	 * We need to collect the trace on the respective cpu since ftrace
-	 * implicitly adds the record for the current cpu.
-	 * Once that is more flexible, we could collect the data from any cpu.
-	 */
-	on_each_cpu(trace_bts_cpu, iter->tr, 1);
-
-	for_each_online_cpu(cpu)
-		if (likely(per_cpu(hwb_tracer, cpu)))
-			ds_resume_bts(per_cpu(hwb_tracer, cpu));
-	put_online_cpus();
-}
-
-static void trace_bts_close(struct trace_iterator *iter)
-{
-	tracing_reset_online_cpus(iter->tr);
-}
-
-void trace_hw_branch_oops(void)
-{
-	if (this_tracer) {
-		ds_suspend_bts_noirq(this_tracer);
-		trace_bts_cpu(hw_branch_trace);
-		ds_resume_bts_noirq(this_tracer);
-	}
-}
-
-struct tracer bts_tracer __read_mostly =
-{
-	.name		= "hw-branch-tracer",
-	.init		= bts_trace_init,
-	.reset		= bts_trace_reset,
-	.print_header	= bts_trace_print_header,
-	.print_line	= bts_trace_print_line,
-	.start		= bts_trace_start,
-	.stop		= bts_trace_stop,
-	.open		= trace_bts_prepare,
-	.close		= trace_bts_close,
-#ifdef CONFIG_FTRACE_SELFTEST
-	.selftest	= trace_selftest_startup_hw_branches,
-#endif /* CONFIG_FTRACE_SELFTEST */
-};
-
-__init static int init_bts_trace(void)
-{
-	register_hotcpu_notifier(&bts_hotcpu_notifier);
-	return register_tracer(&bts_tracer);
-}
-device_initcall(init_bts_trace);
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2085,49 +2085,6 @@ migrate_task(struct task_struct *p, int 
 }
 
 /*
- * wait_task_context_switch -	wait for a thread to complete at least one
- *				context switch.
- *
- * @p must not be current.
- */
-void wait_task_context_switch(struct task_struct *p)
-{
-	unsigned long nvcsw, nivcsw, flags;
-	int running;
-	struct rq *rq;
-
-	nvcsw	= p->nvcsw;
-	nivcsw	= p->nivcsw;
-	for (;;) {
-		/*
-		 * The runqueue is assigned before the actual context
-		 * switch. We need to take the runqueue lock.
-		 *
-		 * We could check initially without the lock but it is
-		 * very likely that we need to take the lock in every
-		 * iteration.
-		 */
-		rq = task_rq_lock(p, &flags);
-		running = task_running(rq, p);
-		task_rq_unlock(rq, &flags);
-
-		if (likely(!running))
-			break;
-		/*
-		 * The switch count is incremented before the actual
-		 * context switch. We thus wait for two switches to be
-		 * sure at least one completed.
-		 */
-		if ((p->nvcsw - nvcsw) > 1)
-			break;
-		if ((p->nivcsw - nivcsw) > 1)
-			break;
-
-		cpu_relax();
-	}
-}
-
-/*
  * wait_task_inactive - wait for a thread to unschedule.
  *
  * If @match_state is nonzero, it's the @p->state value just checked and
Index: linux-2.6/kernel/trace/trace.h
===================================================================
--- linux-2.6.orig/kernel/trace/trace.h
+++ linux-2.6/kernel/trace/trace.h
@@ -34,7 +34,6 @@ enum trace_type {
 	TRACE_GRAPH_RET,
 	TRACE_GRAPH_ENT,
 	TRACE_USER_STACK,
-	TRACE_HW_BRANCHES,
 	TRACE_KMEM_ALLOC,
 	TRACE_KMEM_FREE,
 	TRACE_BLK,
@@ -229,7 +228,6 @@ extern void __ftrace_bad_type(void);
 			  TRACE_GRAPH_ENT);		\
 		IF_ASSIGN(var, ent, struct ftrace_graph_ret_entry,	\
 			  TRACE_GRAPH_RET);		\
-		IF_ASSIGN(var, ent, struct hw_branch_entry, TRACE_HW_BRANCHES);\
 		IF_ASSIGN(var, ent, struct kmemtrace_alloc_entry,	\
 			  TRACE_KMEM_ALLOC);	\
 		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
@@ -467,8 +465,6 @@ extern int trace_selftest_startup_syspro
 					       struct trace_array *tr);
 extern int trace_selftest_startup_branch(struct tracer *trace,
 					 struct trace_array *tr);
-extern int trace_selftest_startup_hw_branches(struct tracer *trace,
-					      struct trace_array *tr);
 extern int trace_selftest_startup_ksym(struct tracer *trace,
 					 struct trace_array *tr);
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
Index: linux-2.6/arch/x86/Kconfig.debug
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig.debug
+++ linux-2.6/arch/x86/Kconfig.debug
@@ -174,15 +174,6 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
-config X86_DS_SELFTEST
-    bool "DS selftest"
-    default y
-    depends on DEBUG_KERNEL
-    depends on X86_DS
-	---help---
-	  Perform Debug Store selftests at boot time.
-	  If in doubt, say "N".
-
 config HAVE_MMIOTRACE_SUPPORT
 	def_bool y
 
Index: linux-2.6/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile
+++ linux-2.6/arch/x86/kernel/Makefile
@@ -47,8 +47,6 @@ obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoli
 obj-y				+= process.o
 obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
-obj-$(CONFIG_X86_DS)		+= ds.o
-obj-$(CONFIG_X86_DS_SELFTEST)		+= ds_selftest.o
 obj-$(CONFIG_X86_32)		+= tls.o
 obj-$(CONFIG_IA32_EMULATION)	+= tls.o
 obj-y				+= step.o
Index: linux-2.6/arch/x86/include/asm/ptrace-abi.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/ptrace-abi.h
+++ linux-2.6/arch/x86/include/asm/ptrace-abi.h
@@ -80,63 +80,4 @@
 
 #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
 
-#ifndef __ASSEMBLY__
-#include <linux/types.h>
-
-/* configuration/status structure used in PTRACE_BTS_CONFIG and
-   PTRACE_BTS_STATUS commands.
-*/
-struct ptrace_bts_config {
-	/* requested or actual size of BTS buffer in bytes */
-	__u32 size;
-	/* bitmask of below flags */
-	__u32 flags;
-	/* buffer overflow signal */
-	__u32 signal;
-	/* actual size of bts_struct in bytes */
-	__u32 bts_size;
-};
-#endif /* __ASSEMBLY__ */
-
-#define PTRACE_BTS_O_TRACE	0x1 /* branch trace */
-#define PTRACE_BTS_O_SCHED	0x2 /* scheduling events w/ jiffies */
-#define PTRACE_BTS_O_SIGNAL     0x4 /* send SIG<signal> on buffer overflow
-				       instead of wrapping around */
-#define PTRACE_BTS_O_ALLOC	0x8 /* (re)allocate buffer */
-
-#define PTRACE_BTS_CONFIG	40
-/* Configure branch trace recording.
-   ADDR points to a struct ptrace_bts_config.
-   DATA gives the size of that buffer.
-   A new buffer is allocated, if requested in the flags.
-   An overflow signal may only be requested for new buffers.
-   Returns the number of bytes read.
-*/
-#define PTRACE_BTS_STATUS	41
-/* Return the current configuration in a struct ptrace_bts_config
-   pointed to by ADDR; DATA gives the size of that buffer.
-   Returns the number of bytes written.
-*/
-#define PTRACE_BTS_SIZE		42
-/* Return the number of available BTS records for draining.
-   DATA and ADDR are ignored.
-*/
-#define PTRACE_BTS_GET		43
-/* Get a single BTS record.
-   DATA defines the index into the BTS array, where 0 is the newest
-   entry, and higher indices refer to older entries.
-   ADDR is pointing to struct bts_struct (see asm/ds.h).
-*/
-#define PTRACE_BTS_CLEAR	44
-/* Clear the BTS buffer.
-   DATA and ADDR are ignored.
-*/
-#define PTRACE_BTS_DRAIN	45
-/* Read all available BTS records and clear the buffer.
-   ADDR points to an array of struct bts_struct.
-   DATA gives the size of that buffer.
-   BTS records are read from oldest to newest.
-   Returns number of BTS records drained.
-*/
-
 #endif /* _ASM_X86_PTRACE_ABI_H */
Index: linux-2.6/include/linux/ftrace.h
===================================================================
--- linux-2.6.orig/include/linux/ftrace.h
+++ linux-2.6/include/linux/ftrace.h
@@ -504,18 +504,6 @@ extern int ftrace_dump_on_oops;
 #define INIT_TRACE_RECURSION
 #endif
 
-#ifdef CONFIG_HW_BRANCH_TRACER
-
-void trace_hw_branch(u64 from, u64 to);
-void trace_hw_branch_oops(void);
-
-#else /* CONFIG_HW_BRANCH_TRACER */
-
-static inline void trace_hw_branch(u64 from, u64 to) {}
-static inline void trace_hw_branch_oops(void) {}
-
-#endif /* CONFIG_HW_BRANCH_TRACER */
-
 #ifdef CONFIG_FTRACE_SYSCALLS
 
 unsigned long arch_syscall_addr(int nr);
Index: linux-2.6/kernel/trace/Kconfig
===================================================================
--- linux-2.6.orig/kernel/trace/Kconfig
+++ linux-2.6/kernel/trace/Kconfig
@@ -44,9 +44,6 @@ config HAVE_FTRACE_MCOUNT_RECORD
 	help
 	  See Documentation/trace/ftrace-design.txt
 
-config HAVE_HW_BRANCH_TRACER
-	bool
-
 config HAVE_SYSCALL_TRACEPOINTS
 	bool
 	help
@@ -374,14 +371,6 @@ config STACK_TRACER
 
 	  Say N if unsure.
 
-config HW_BRANCH_TRACER
-	depends on HAVE_HW_BRANCH_TRACER
-	bool "Trace hw branches"
-	select GENERIC_TRACER
-	help
-	  This tracer records all branches on the system in a circular
-	  buffer, giving access to the last N branches for each cpu.
-
 config KMEMTRACE
 	bool "Trace SLAB allocations"
 	select GENERIC_TRACER
Index: linux-2.6/kernel/trace/Makefile
===================================================================
--- linux-2.6.orig/kernel/trace/Makefile
+++ linux-2.6/kernel/trace/Makefile
@@ -41,7 +41,6 @@ obj-$(CONFIG_MMIOTRACE) += trace_mmiotra
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += trace_functions_graph.o
 obj-$(CONFIG_TRACE_BRANCH_PROFILING) += trace_branch.o
-obj-$(CONFIG_HW_BRANCH_TRACER) += trace_hw_branches.o
 obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
 obj-$(CONFIG_WORKQUEUE_TRACER) += trace_workqueue.o
 obj-$(CONFIG_BLK_DEV_IO_TRACE) += blktrace.o
Index: linux-2.6/arch/x86/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/thread_info.h
+++ linux-2.6/arch/x86/include/asm/thread_info.h
@@ -92,8 +92,6 @@ struct thread_info {
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
 #define TIF_FREEZE		23	/* is freezing for suspend */
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
-#define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
-#define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
 #define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
 
@@ -115,8 +113,6 @@ struct thread_info {
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
-#define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
-#define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 
@@ -147,7 +143,7 @@ struct thread_info {
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
-	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_NOTSC)
+	(_TIF_IO_BITMAP|_TIF_NOTSC)
 
 #define _TIF_WORK_CTXSW_PREV (_TIF_WORK_CTXSW|_TIF_USER_RETURN_NOTIFY)
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)
Index: linux-2.6/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel.c
+++ linux-2.6/arch/x86/kernel/cpu/intel.c
@@ -12,7 +12,6 @@
 #include <asm/processor.h>
 #include <asm/pgtable.h>
 #include <asm/msr.h>
-#include <asm/ds.h>
 #include <asm/bugs.h>
 #include <asm/cpu.h>
 
@@ -367,7 +366,6 @@ static void __cpuinit init_intel(struct 
 			set_cpu_cap(c, X86_FEATURE_BTS);
 		if (!(l1 & (1<<12)))
 			set_cpu_cap(c, X86_FEATURE_PEBS);
-		ds_init_intel(c);
 	}
 
 	if (c->x86 == 6 && c->x86_model == 29 && cpu_has_clflush)
Index: linux-2.6/arch/x86/include/asm/ds.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/ds.h
+++ /dev/null
@@ -1,302 +0,0 @@
-/*
- * Debug Store (DS) support
- *
- * This provides a low-level interface to the hardware's Debug Store
- * feature that is used for branch trace store (BTS) and
- * precise-event based sampling (PEBS).
- *
- * It manages:
- * - DS and BTS hardware configuration
- * - buffer overflow handling (to be done)
- * - buffer access
- *
- * It does not do:
- * - security checking (is the caller allowed to trace the task)
- * - buffer allocation (memory accounting)
- *
- *
- * Copyright (C) 2007-2009 Intel Corporation.
- * Markus Metzger <markus.t.metzger@intel.com>, 2007-2009
- */
-
-#ifndef _ASM_X86_DS_H
-#define _ASM_X86_DS_H
-
-
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/err.h>
-
-
-#ifdef CONFIG_X86_DS
-
-struct task_struct;
-struct ds_context;
-struct ds_tracer;
-struct bts_tracer;
-struct pebs_tracer;
-
-typedef void (*bts_ovfl_callback_t)(struct bts_tracer *);
-typedef void (*pebs_ovfl_callback_t)(struct pebs_tracer *);
-
-
-/*
- * A list of features plus corresponding macros to talk about them in
- * the ds_request function's flags parameter.
- *
- * We use the enum to index an array of corresponding control bits;
- * we use the macro to index a flags bit-vector.
- */
-enum ds_feature {
-	dsf_bts = 0,
-	dsf_bts_kernel,
-#define BTS_KERNEL (1 << dsf_bts_kernel)
-	/* trace kernel-mode branches */
-
-	dsf_bts_user,
-#define BTS_USER (1 << dsf_bts_user)
-	/* trace user-mode branches */
-
-	dsf_bts_overflow,
-	dsf_bts_max,
-	dsf_pebs = dsf_bts_max,
-
-	dsf_pebs_max,
-	dsf_ctl_max = dsf_pebs_max,
-	dsf_bts_timestamps = dsf_ctl_max,
-#define BTS_TIMESTAMPS (1 << dsf_bts_timestamps)
-	/* add timestamps into BTS trace */
-
-#define BTS_USER_FLAGS (BTS_KERNEL | BTS_USER | BTS_TIMESTAMPS)
-};
-
-
-/*
- * Request BTS or PEBS
- *
- * Due to alignement constraints, the actual buffer may be slightly
- * smaller than the requested or provided buffer.
- *
- * Returns a pointer to a tracer structure on success, or
- * ERR_PTR(errcode) on failure.
- *
- * The interrupt threshold is independent from the overflow callback
- * to allow users to use their own overflow interrupt handling mechanism.
- *
- * The function might sleep.
- *
- * task: the task to request recording for
- * cpu:  the cpu to request recording for
- * base: the base pointer for the (non-pageable) buffer;
- * size: the size of the provided buffer in bytes
- * ovfl: pointer to a function to be called on buffer overflow;
- *       NULL if cyclic buffer requested
- * th: the interrupt threshold in records from the end of the buffer;
- *     -1 if no interrupt threshold is requested.
- * flags: a bit-mask of the above flags
- */
-extern struct bts_tracer *ds_request_bts_task(struct task_struct *task,
-					      void *base, size_t size,
-					      bts_ovfl_callback_t ovfl,
-					      size_t th, unsigned int flags);
-extern struct bts_tracer *ds_request_bts_cpu(int cpu, void *base, size_t size,
-					     bts_ovfl_callback_t ovfl,
-					     size_t th, unsigned int flags);
-extern struct pebs_tracer *ds_request_pebs_task(struct task_struct *task,
-						void *base, size_t size,
-						pebs_ovfl_callback_t ovfl,
-						size_t th, unsigned int flags);
-extern struct pebs_tracer *ds_request_pebs_cpu(int cpu,
-					       void *base, size_t size,
-					       pebs_ovfl_callback_t ovfl,
-					       size_t th, unsigned int flags);
-
-/*
- * Release BTS or PEBS resources
- * Suspend and resume BTS or PEBS tracing
- *
- * Must be called with irq's enabled.
- *
- * tracer: the tracer handle returned from ds_request_~()
- */
-extern void ds_release_bts(struct bts_tracer *tracer);
-extern void ds_suspend_bts(struct bts_tracer *tracer);
-extern void ds_resume_bts(struct bts_tracer *tracer);
-extern void ds_release_pebs(struct pebs_tracer *tracer);
-extern void ds_suspend_pebs(struct pebs_tracer *tracer);
-extern void ds_resume_pebs(struct pebs_tracer *tracer);
-
-/*
- * Release BTS or PEBS resources
- * Suspend and resume BTS or PEBS tracing
- *
- * Cpu tracers must call this on the traced cpu.
- * Task tracers must call ds_release_~_noirq() for themselves.
- *
- * May be called with irq's disabled.
- *
- * Returns 0 if successful;
- * -EPERM if the cpu tracer does not trace the current cpu.
- * -EPERM if the task tracer does not trace itself.
- *
- * tracer: the tracer handle returned from ds_request_~()
- */
-extern int ds_release_bts_noirq(struct bts_tracer *tracer);
-extern int ds_suspend_bts_noirq(struct bts_tracer *tracer);
-extern int ds_resume_bts_noirq(struct bts_tracer *tracer);
-extern int ds_release_pebs_noirq(struct pebs_tracer *tracer);
-extern int ds_suspend_pebs_noirq(struct pebs_tracer *tracer);
-extern int ds_resume_pebs_noirq(struct pebs_tracer *tracer);
-
-
-/*
- * The raw DS buffer state as it is used for BTS and PEBS recording.
- *
- * This is the low-level, arch-dependent interface for working
- * directly on the raw trace data.
- */
-struct ds_trace {
-	/* the number of bts/pebs records */
-	size_t n;
-	/* the size of a bts/pebs record in bytes */
-	size_t size;
-	/* pointers into the raw buffer:
-	   - to the first entry */
-	void *begin;
-	/* - one beyond the last entry */
-	void *end;
-	/* - one beyond the newest entry */
-	void *top;
-	/* - the interrupt threshold */
-	void *ith;
-	/* flags given on ds_request() */
-	unsigned int flags;
-};
-
-/*
- * An arch-independent view on branch trace data.
- */
-enum bts_qualifier {
-	bts_invalid,
-#define BTS_INVALID bts_invalid
-
-	bts_branch,
-#define BTS_BRANCH bts_branch
-
-	bts_task_arrives,
-#define BTS_TASK_ARRIVES bts_task_arrives
-
-	bts_task_departs,
-#define BTS_TASK_DEPARTS bts_task_departs
-
-	bts_qual_bit_size = 4,
-	bts_qual_max = (1 << bts_qual_bit_size),
-};
-
-struct bts_struct {
-	__u64 qualifier;
-	union {
-		/* BTS_BRANCH */
-		struct {
-			__u64 from;
-			__u64 to;
-		} lbr;
-		/* BTS_TASK_ARRIVES or BTS_TASK_DEPARTS */
-		struct {
-			__u64 clock;
-			pid_t pid;
-		} event;
-	} variant;
-};
-
-
-/*
- * The BTS state.
- *
- * This gives access to the raw DS state and adds functions to provide
- * an arch-independent view of the BTS data.
- */
-struct bts_trace {
-	struct ds_trace ds;
-
-	int (*read)(struct bts_tracer *tracer, const void *at,
-		    struct bts_struct *out);
-	int (*write)(struct bts_tracer *tracer, const struct bts_struct *in);
-};
-
-
-/*
- * The PEBS state.
- *
- * This gives access to the raw DS state and the PEBS-specific counter
- * reset value.
- */
-struct pebs_trace {
-	struct ds_trace ds;
-
-	/* the number of valid counters in the below array */
-	unsigned int counters;
-
-#define MAX_PEBS_COUNTERS 4
-	/* the counter reset value */
-	unsigned long long counter_reset[MAX_PEBS_COUNTERS];
-};
-
-
-/*
- * Read the BTS or PEBS trace.
- *
- * Returns a view on the trace collected for the parameter tracer.
- *
- * The view remains valid as long as the traced task is not running or
- * the tracer is suspended.
- * Writes into the trace buffer are not reflected.
- *
- * tracer: the tracer handle returned from ds_request_~()
- */
-extern const struct bts_trace *ds_read_bts(struct bts_tracer *tracer);
-extern const struct pebs_trace *ds_read_pebs(struct pebs_tracer *tracer);
-
-
-/*
- * Reset the write pointer of the BTS/PEBS buffer.
- *
- * Returns 0 on success; -Eerrno on error
- *
- * tracer: the tracer handle returned from ds_request_~()
- */
-extern int ds_reset_bts(struct bts_tracer *tracer);
-extern int ds_reset_pebs(struct pebs_tracer *tracer);
-
-/*
- * Set the PEBS counter reset value.
- *
- * Returns 0 on success; -Eerrno on error
- *
- * tracer: the tracer handle returned from ds_request_pebs()
- * counter: the index of the counter
- * value: the new counter reset value
- */
-extern int ds_set_pebs_reset(struct pebs_tracer *tracer,
-			     unsigned int counter, u64 value);
-
-/*
- * Initialization
- */
-struct cpuinfo_x86;
-extern void __cpuinit ds_init_intel(struct cpuinfo_x86 *);
-
-/*
- * Context switch work
- */
-extern void ds_switch_to(struct task_struct *prev, struct task_struct *next);
-
-#else /* CONFIG_X86_DS */
-
-struct cpuinfo_x86;
-static inline void __cpuinit ds_init_intel(struct cpuinfo_x86 *ignored) {}
-static inline void ds_switch_to(struct task_struct *prev,
-				struct task_struct *next) {}
-
-#endif /* CONFIG_X86_DS */
-#endif /* _ASM_X86_DS_H */
Index: linux-2.6/arch/x86/kernel/ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/ds.c
+++ /dev/null
@@ -1,1437 +0,0 @@
-/*
- * Debug Store support
- *
- * This provides a low-level interface to the hardware's Debug Store
- * feature that is used for branch trace store (BTS) and
- * precise-event based sampling (PEBS).
- *
- * It manages:
- * - DS and BTS hardware configuration
- * - buffer overflow handling (to be done)
- * - buffer access
- *
- * It does not do:
- * - security checking (is the caller allowed to trace the task)
- * - buffer allocation (memory accounting)
- *
- *
- * Copyright (C) 2007-2009 Intel Corporation.
- * Markus Metzger <markus.t.metzger@intel.com>, 2007-2009
- */
-
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/slab.h>
-#include <linux/mm.h>
-#include <linux/trace_clock.h>
-
-#include <asm/ds.h>
-
-#include "ds_selftest.h"
-
-/*
- * The configuration for a particular DS hardware implementation:
- */
-struct ds_configuration {
-	/* The name of the configuration: */
-	const char		*name;
-
-	/* The size of pointer-typed fields in DS, BTS, and PEBS: */
-	unsigned char		sizeof_ptr_field;
-
-	/* The size of a BTS/PEBS record in bytes: */
-	unsigned char		sizeof_rec[2];
-
-	/* The number of pebs counter reset values in the DS structure. */
-	unsigned char		nr_counter_reset;
-
-	/* Control bit-masks indexed by enum ds_feature: */
-	unsigned long		ctl[dsf_ctl_max];
-};
-static struct ds_configuration ds_cfg __read_mostly;
-
-
-/* Maximal size of a DS configuration: */
-#define MAX_SIZEOF_DS		0x80
-
-/* Maximal size of a BTS record: */
-#define MAX_SIZEOF_BTS		(3 * 8)
-
-/* BTS and PEBS buffer alignment: */
-#define DS_ALIGNMENT		(1 << 3)
-
-/* Number of buffer pointers in DS: */
-#define NUM_DS_PTR_FIELDS	8
-
-/* Size of a pebs reset value in DS: */
-#define PEBS_RESET_FIELD_SIZE	8
-
-/* Mask of control bits in the DS MSR register: */
-#define BTS_CONTROL				  \
-	( ds_cfg.ctl[dsf_bts]			| \
-	  ds_cfg.ctl[dsf_bts_kernel]		| \
-	  ds_cfg.ctl[dsf_bts_user]		| \
-	  ds_cfg.ctl[dsf_bts_overflow] )
-
-/*
- * A BTS or PEBS tracer.
- *
- * This holds the configuration of the tracer and serves as a handle
- * to identify tracers.
- */
-struct ds_tracer {
-	/* The DS context (partially) owned by this tracer. */
-	struct ds_context	*context;
-	/* The buffer provided on ds_request() and its size in bytes. */
-	void			*buffer;
-	size_t			size;
-};
-
-struct bts_tracer {
-	/* The common DS part: */
-	struct ds_tracer	ds;
-
-	/* The trace including the DS configuration: */
-	struct bts_trace	trace;
-
-	/* Buffer overflow notification function: */
-	bts_ovfl_callback_t	ovfl;
-
-	/* Active flags affecting trace collection. */
-	unsigned int		flags;
-};
-
-struct pebs_tracer {
-	/* The common DS part: */
-	struct ds_tracer	ds;
-
-	/* The trace including the DS configuration: */
-	struct pebs_trace	trace;
-
-	/* Buffer overflow notification function: */
-	pebs_ovfl_callback_t	ovfl;
-};
-
-/*
- * Debug Store (DS) save area configuration (see Intel64 and IA32
- * Architectures Software Developer's Manual, section 18.5)
- *
- * The DS configuration consists of the following fields; different
- * architetures vary in the size of those fields.
- *
- * - double-word aligned base linear address of the BTS buffer
- * - write pointer into the BTS buffer
- * - end linear address of the BTS buffer (one byte beyond the end of
- *   the buffer)
- * - interrupt pointer into BTS buffer
- *   (interrupt occurs when write pointer passes interrupt pointer)
- * - double-word aligned base linear address of the PEBS buffer
- * - write pointer into the PEBS buffer
- * - end linear address of the PEBS buffer (one byte beyond the end of
- *   the buffer)
- * - interrupt pointer into PEBS buffer
- *   (interrupt occurs when write pointer passes interrupt pointer)
- * - value to which counter is reset following counter overflow
- *
- * Later architectures use 64bit pointers throughout, whereas earlier
- * architectures use 32bit pointers in 32bit mode.
- *
- *
- * We compute the base address for the first 8 fields based on:
- * - the field size stored in the DS configuration
- * - the relative field position
- * - an offset giving the start of the respective region
- *
- * This offset is further used to index various arrays holding
- * information for BTS and PEBS at the respective index.
- *
- * On later 32bit processors, we only access the lower 32bit of the
- * 64bit pointer fields. The upper halves will be zeroed out.
- */
-
-enum ds_field {
-	ds_buffer_base = 0,
-	ds_index,
-	ds_absolute_maximum,
-	ds_interrupt_threshold,
-};
-
-enum ds_qualifier {
-	ds_bts = 0,
-	ds_pebs
-};
-
-static inline unsigned long
-ds_get(const unsigned char *base, enum ds_qualifier qual, enum ds_field field)
-{
-	base += (ds_cfg.sizeof_ptr_field * (field + (4 * qual)));
-	return *(unsigned long *)base;
-}
-
-static inline void
-ds_set(unsigned char *base, enum ds_qualifier qual, enum ds_field field,
-       unsigned long value)
-{
-	base += (ds_cfg.sizeof_ptr_field * (field + (4 * qual)));
-	(*(unsigned long *)base) = value;
-}
-
-
-/*
- * Locking is done only for allocating BTS or PEBS resources.
- */
-static DEFINE_SPINLOCK(ds_lock);
-
-/*
- * We either support (system-wide) per-cpu or per-thread allocation.
- * We distinguish the two based on the task_struct pointer, where a
- * NULL pointer indicates per-cpu allocation for the current cpu.
- *
- * Allocations are use-counted. As soon as resources are allocated,
- * further allocations must be of the same type (per-cpu or
- * per-thread). We model this by counting allocations (i.e. the number
- * of tracers of a certain type) for one type negatively:
- *   =0  no tracers
- *   >0  number of per-thread tracers
- *   <0  number of per-cpu tracers
- *
- * Tracers essentially gives the number of ds contexts for a certain
- * type of allocation.
- */
-static atomic_t tracers = ATOMIC_INIT(0);
-
-static inline int get_tracer(struct task_struct *task)
-{
-	int error;
-
-	spin_lock_irq(&ds_lock);
-
-	if (task) {
-		error = -EPERM;
-		if (atomic_read(&tracers) < 0)
-			goto out;
-		atomic_inc(&tracers);
-	} else {
-		error = -EPERM;
-		if (atomic_read(&tracers) > 0)
-			goto out;
-		atomic_dec(&tracers);
-	}
-
-	error = 0;
-out:
-	spin_unlock_irq(&ds_lock);
-	return error;
-}
-
-static inline void put_tracer(struct task_struct *task)
-{
-	if (task)
-		atomic_dec(&tracers);
-	else
-		atomic_inc(&tracers);
-}
-
-/*
- * The DS context is either attached to a thread or to a cpu:
- * - in the former case, the thread_struct contains a pointer to the
- *   attached context.
- * - in the latter case, we use a static array of per-cpu context
- *   pointers.
- *
- * Contexts are use-counted. They are allocated on first access and
- * deallocated when the last user puts the context.
- */
-struct ds_context {
-	/* The DS configuration; goes into MSR_IA32_DS_AREA: */
-	unsigned char		ds[MAX_SIZEOF_DS];
-
-	/* The owner of the BTS and PEBS configuration, respectively: */
-	struct bts_tracer	*bts_master;
-	struct pebs_tracer	*pebs_master;
-
-	/* Use count: */
-	unsigned long		count;
-
-	/* Pointer to the context pointer field: */
-	struct ds_context	**this;
-
-	/* The traced task; NULL for cpu tracing: */
-	struct task_struct	*task;
-
-	/* The traced cpu; only valid if task is NULL: */
-	int			cpu;
-};
-
-static DEFINE_PER_CPU(struct ds_context *, cpu_ds_context);
-
-
-static struct ds_context *ds_get_context(struct task_struct *task, int cpu)
-{
-	struct ds_context **p_context =
-		(task ? &task->thread.ds_ctx : &per_cpu(cpu_ds_context, cpu));
-	struct ds_context *context = NULL;
-	struct ds_context *new_context = NULL;
-
-	/* Chances are small that we already have a context. */
-	new_context = kzalloc(sizeof(*new_context), GFP_KERNEL);
-	if (!new_context)
-		return NULL;
-
-	spin_lock_irq(&ds_lock);
-
-	context = *p_context;
-	if (likely(!context)) {
-		context = new_context;
-
-		context->this = p_context;
-		context->task = task;
-		context->cpu = cpu;
-		context->count = 0;
-
-		*p_context = context;
-	}
-
-	context->count++;
-
-	spin_unlock_irq(&ds_lock);
-
-	if (context != new_context)
-		kfree(new_context);
-
-	return context;
-}
-
-static void ds_put_context(struct ds_context *context)
-{
-	struct task_struct *task;
-	unsigned long irq;
-
-	if (!context)
-		return;
-
-	spin_lock_irqsave(&ds_lock, irq);
-
-	if (--context->count) {
-		spin_unlock_irqrestore(&ds_lock, irq);
-		return;
-	}
-
-	*(context->this) = NULL;
-
-	task = context->task;
-
-	if (task)
-		clear_tsk_thread_flag(task, TIF_DS_AREA_MSR);
-
-	/*
-	 * We leave the (now dangling) pointer to the DS configuration in
-	 * the DS_AREA msr. This is as good or as bad as replacing it with
-	 * NULL - the hardware would crash if we enabled tracing.
-	 *
-	 * This saves us some problems with having to write an msr on a
-	 * different cpu while preventing others from doing the same for the
-	 * next context for that same cpu.
-	 */
-
-	spin_unlock_irqrestore(&ds_lock, irq);
-
-	/* The context might still be in use for context switching. */
-	if (task && (task != current))
-		wait_task_context_switch(task);
-
-	kfree(context);
-}
-
-static void ds_install_ds_area(struct ds_context *context)
-{
-	unsigned long ds;
-
-	ds = (unsigned long)context->ds;
-
-	/*
-	 * There is a race between the bts master and the pebs master.
-	 *
-	 * The thread/cpu access is synchronized via get/put_cpu() for
-	 * task tracing and via wrmsr_on_cpu for cpu tracing.
-	 *
-	 * If bts and pebs are collected for the same task or same cpu,
-	 * the same confiuration is written twice.
-	 */
-	if (context->task) {
-		get_cpu();
-		if (context->task == current)
-			wrmsrl(MSR_IA32_DS_AREA, ds);
-		set_tsk_thread_flag(context->task, TIF_DS_AREA_MSR);
-		put_cpu();
-	} else
-		wrmsr_on_cpu(context->cpu, MSR_IA32_DS_AREA,
-			     (u32)((u64)ds), (u32)((u64)ds >> 32));
-}
-
-/*
- * Call the tracer's callback on a buffer overflow.
- *
- * context: the ds context
- * qual: the buffer type
- */
-static void ds_overflow(struct ds_context *context, enum ds_qualifier qual)
-{
-	switch (qual) {
-	case ds_bts:
-		if (context->bts_master &&
-		    context->bts_master->ovfl)
-			context->bts_master->ovfl(context->bts_master);
-		break;
-	case ds_pebs:
-		if (context->pebs_master &&
-		    context->pebs_master->ovfl)
-			context->pebs_master->ovfl(context->pebs_master);
-		break;
-	}
-}
-
-
-/*
- * Write raw data into the BTS or PEBS buffer.
- *
- * The remainder of any partially written record is zeroed out.
- *
- * context: the DS context
- * qual:    the buffer type
- * record:  the data to write
- * size:    the size of the data
- */
-static int ds_write(struct ds_context *context, enum ds_qualifier qual,
-		    const void *record, size_t size)
-{
-	int bytes_written = 0;
-
-	if (!record)
-		return -EINVAL;
-
-	while (size) {
-		unsigned long base, index, end, write_end, int_th;
-		unsigned long write_size, adj_write_size;
-
-		/*
-		 * Write as much as possible without producing an
-		 * overflow interrupt.
-		 *
-		 * Interrupt_threshold must either be
-		 * - bigger than absolute_maximum or
-		 * - point to a record between buffer_base and absolute_maximum
-		 *
-		 * Index points to a valid record.
-		 */
-		base   = ds_get(context->ds, qual, ds_buffer_base);
-		index  = ds_get(context->ds, qual, ds_index);
-		end    = ds_get(context->ds, qual, ds_absolute_maximum);
-		int_th = ds_get(context->ds, qual, ds_interrupt_threshold);
-
-		write_end = min(end, int_th);
-
-		/*
-		 * If we are already beyond the interrupt threshold,
-		 * we fill the entire buffer.
-		 */
-		if (write_end <= index)
-			write_end = end;
-
-		if (write_end <= index)
-			break;
-
-		write_size = min((unsigned long) size, write_end - index);
-		memcpy((void *)index, record, write_size);
-
-		record = (const char *)record + write_size;
-		size -= write_size;
-		bytes_written += write_size;
-
-		adj_write_size = write_size / ds_cfg.sizeof_rec[qual];
-		adj_write_size *= ds_cfg.sizeof_rec[qual];
-
-		/* Zero out trailing bytes. */
-		memset((char *)index + write_size, 0,
-		       adj_write_size - write_size);
-		index += adj_write_size;
-
-		if (index >= end)
-			index = base;
-		ds_set(context->ds, qual, ds_index, index);
-
-		if (index >= int_th)
-			ds_overflow(context, qual);
-	}
-
-	return bytes_written;
-}
-
-
-/*
- * Branch Trace Store (BTS) uses the following format. Different
- * architectures vary in the size of those fields.
- * - source linear address
- * - destination linear address
- * - flags
- *
- * Later architectures use 64bit pointers throughout, whereas earlier
- * architectures use 32bit pointers in 32bit mode.
- *
- * We compute the base address for the fields based on:
- * - the field size stored in the DS configuration
- * - the relative field position
- *
- * In order to store additional information in the BTS buffer, we use
- * a special source address to indicate that the record requires
- * special interpretation.
- *
- * Netburst indicated via a bit in the flags field whether the branch
- * was predicted; this is ignored.
- *
- * We use two levels of abstraction:
- * - the raw data level defined here
- * - an arch-independent level defined in ds.h
- */
-
-enum bts_field {
-	bts_from,
-	bts_to,
-	bts_flags,
-
-	bts_qual		= bts_from,
-	bts_clock		= bts_to,
-	bts_pid			= bts_flags,
-
-	bts_qual_mask		= (bts_qual_max - 1),
-	bts_escape		= ((unsigned long)-1 & ~bts_qual_mask)
-};
-
-static inline unsigned long bts_get(const char *base, unsigned long field)
-{
-	base += (ds_cfg.sizeof_ptr_field * field);
-	return *(unsigned long *)base;
-}
-
-static inline void bts_set(char *base, unsigned long field, unsigned long val)
-{
-	base += (ds_cfg.sizeof_ptr_field * field);
-	(*(unsigned long *)base) = val;
-}
-
-
-/*
- * The raw BTS data is architecture dependent.
- *
- * For higher-level users, we give an arch-independent view.
- * - ds.h defines struct bts_struct
- * - bts_read translates one raw bts record into a bts_struct
- * - bts_write translates one bts_struct into the raw format and
- *   writes it into the top of the parameter tracer's buffer.
- *
- * return: bytes read/written on success; -Eerrno, otherwise
- */
-static int
-bts_read(struct bts_tracer *tracer, const void *at, struct bts_struct *out)
-{
-	if (!tracer)
-		return -EINVAL;
-
-	if (at < tracer->trace.ds.begin)
-		return -EINVAL;
-
-	if (tracer->trace.ds.end < (at + tracer->trace.ds.size))
-		return -EINVAL;
-
-	memset(out, 0, sizeof(*out));
-	if ((bts_get(at, bts_qual) & ~bts_qual_mask) == bts_escape) {
-		out->qualifier = (bts_get(at, bts_qual) & bts_qual_mask);
-		out->variant.event.clock = bts_get(at, bts_clock);
-		out->variant.event.pid = bts_get(at, bts_pid);
-	} else {
-		out->qualifier = bts_branch;
-		out->variant.lbr.from = bts_get(at, bts_from);
-		out->variant.lbr.to   = bts_get(at, bts_to);
-
-		if (!out->variant.lbr.from && !out->variant.lbr.to)
-			out->qualifier = bts_invalid;
-	}
-
-	return ds_cfg.sizeof_rec[ds_bts];
-}
-
-static int bts_write(struct bts_tracer *tracer, const struct bts_struct *in)
-{
-	unsigned char raw[MAX_SIZEOF_BTS];
-
-	if (!tracer)
-		return -EINVAL;
-
-	if (MAX_SIZEOF_BTS < ds_cfg.sizeof_rec[ds_bts])
-		return -EOVERFLOW;
-
-	switch (in->qualifier) {
-	case bts_invalid:
-		bts_set(raw, bts_from, 0);
-		bts_set(raw, bts_to, 0);
-		bts_set(raw, bts_flags, 0);
-		break;
-	case bts_branch:
-		bts_set(raw, bts_from, in->variant.lbr.from);
-		bts_set(raw, bts_to,   in->variant.lbr.to);
-		bts_set(raw, bts_flags, 0);
-		break;
-	case bts_task_arrives:
-	case bts_task_departs:
-		bts_set(raw, bts_qual, (bts_escape | in->qualifier));
-		bts_set(raw, bts_clock, in->variant.event.clock);
-		bts_set(raw, bts_pid, in->variant.event.pid);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return ds_write(tracer->ds.context, ds_bts, raw,
-			ds_cfg.sizeof_rec[ds_bts]);
-}
-
-
-static void ds_write_config(struct ds_context *context,
-			    struct ds_trace *cfg, enum ds_qualifier qual)
-{
-	unsigned char *ds = context->ds;
-
-	ds_set(ds, qual, ds_buffer_base, (unsigned long)cfg->begin);
-	ds_set(ds, qual, ds_index, (unsigned long)cfg->top);
-	ds_set(ds, qual, ds_absolute_maximum, (unsigned long)cfg->end);
-	ds_set(ds, qual, ds_interrupt_threshold, (unsigned long)cfg->ith);
-}
-
-static void ds_read_config(struct ds_context *context,
-			   struct ds_trace *cfg, enum ds_qualifier qual)
-{
-	unsigned char *ds = context->ds;
-
-	cfg->begin = (void *)ds_get(ds, qual, ds_buffer_base);
-	cfg->top = (void *)ds_get(ds, qual, ds_index);
-	cfg->end = (void *)ds_get(ds, qual, ds_absolute_maximum);
-	cfg->ith = (void *)ds_get(ds, qual, ds_interrupt_threshold);
-}
-
-static void ds_init_ds_trace(struct ds_trace *trace, enum ds_qualifier qual,
-			     void *base, size_t size, size_t ith,
-			     unsigned int flags) {
-	unsigned long buffer, adj;
-
-	/*
-	 * Adjust the buffer address and size to meet alignment
-	 * constraints:
-	 * - buffer is double-word aligned
-	 * - size is multiple of record size
-	 *
-	 * We checked the size at the very beginning; we have enough
-	 * space to do the adjustment.
-	 */
-	buffer = (unsigned long)base;
-
-	adj = ALIGN(buffer, DS_ALIGNMENT) - buffer;
-	buffer += adj;
-	size   -= adj;
-
-	trace->n = size / ds_cfg.sizeof_rec[qual];
-	trace->size = ds_cfg.sizeof_rec[qual];
-
-	size = (trace->n * trace->size);
-
-	trace->begin = (void *)buffer;
-	trace->top = trace->begin;
-	trace->end = (void *)(buffer + size);
-	/*
-	 * The value for 'no threshold' is -1, which will set the
-	 * threshold outside of the buffer, just like we want it.
-	 */
-	ith *= ds_cfg.sizeof_rec[qual];
-	trace->ith = (void *)(buffer + size - ith);
-
-	trace->flags = flags;
-}
-
-
-static int ds_request(struct ds_tracer *tracer, struct ds_trace *trace,
-		      enum ds_qualifier qual, struct task_struct *task,
-		      int cpu, void *base, size_t size, size_t th)
-{
-	struct ds_context *context;
-	int error;
-	size_t req_size;
-
-	error = -EOPNOTSUPP;
-	if (!ds_cfg.sizeof_rec[qual])
-		goto out;
-
-	error = -EINVAL;
-	if (!base)
-		goto out;
-
-	req_size = ds_cfg.sizeof_rec[qual];
-	/* We might need space for alignment adjustments. */
-	if (!IS_ALIGNED((unsigned long)base, DS_ALIGNMENT))
-		req_size += DS_ALIGNMENT;
-
-	error = -EINVAL;
-	if (size < req_size)
-		goto out;
-
-	if (th != (size_t)-1) {
-		th *= ds_cfg.sizeof_rec[qual];
-
-		error = -EINVAL;
-		if (size <= th)
-			goto out;
-	}
-
-	tracer->buffer = base;
-	tracer->size = size;
-
-	error = -ENOMEM;
-	context = ds_get_context(task, cpu);
-	if (!context)
-		goto out;
-	tracer->context = context;
-
-	/*
-	 * Defer any tracer-specific initialization work for the context until
-	 * context ownership has been clarified.
-	 */
-
-	error = 0;
- out:
-	return error;
-}
-
-static struct bts_tracer *ds_request_bts(struct task_struct *task, int cpu,
-					 void *base, size_t size,
-					 bts_ovfl_callback_t ovfl, size_t th,
-					 unsigned int flags)
-{
-	struct bts_tracer *tracer;
-	int error;
-
-	/* Buffer overflow notification is not yet implemented. */
-	error = -EOPNOTSUPP;
-	if (ovfl)
-		goto out;
-
-	error = get_tracer(task);
-	if (error < 0)
-		goto out;
-
-	error = -ENOMEM;
-	tracer = kzalloc(sizeof(*tracer), GFP_KERNEL);
-	if (!tracer)
-		goto out_put_tracer;
-	tracer->ovfl = ovfl;
-
-	/* Do some more error checking and acquire a tracing context. */
-	error = ds_request(&tracer->ds, &tracer->trace.ds,
-			   ds_bts, task, cpu, base, size, th);
-	if (error < 0)
-		goto out_tracer;
-
-	/* Claim the bts part of the tracing context we acquired above. */
-	spin_lock_irq(&ds_lock);
-
-	error = -EPERM;
-	if (tracer->ds.context->bts_master)
-		goto out_unlock;
-	tracer->ds.context->bts_master = tracer;
-
-	spin_unlock_irq(&ds_lock);
-
-	/*
-	 * Now that we own the bts part of the context, let's complete the
-	 * initialization for that part.
-	 */
-	ds_init_ds_trace(&tracer->trace.ds, ds_bts, base, size, th, flags);
-	ds_write_config(tracer->ds.context, &tracer->trace.ds, ds_bts);
-	ds_install_ds_area(tracer->ds.context);
-
-	tracer->trace.read  = bts_read;
-	tracer->trace.write = bts_write;
-
-	/* Start tracing. */
-	ds_resume_bts(tracer);
-
-	return tracer;
-
- out_unlock:
-	spin_unlock_irq(&ds_lock);
-	ds_put_context(tracer->ds.context);
- out_tracer:
-	kfree(tracer);
- out_put_tracer:
-	put_tracer(task);
- out:
-	return ERR_PTR(error);
-}
-
-struct bts_tracer *ds_request_bts_task(struct task_struct *task,
-				       void *base, size_t size,
-				       bts_ovfl_callback_t ovfl,
-				       size_t th, unsigned int flags)
-{
-	return ds_request_bts(task, 0, base, size, ovfl, th, flags);
-}
-
-struct bts_tracer *ds_request_bts_cpu(int cpu, void *base, size_t size,
-				      bts_ovfl_callback_t ovfl,
-				      size_t th, unsigned int flags)
-{
-	return ds_request_bts(NULL, cpu, base, size, ovfl, th, flags);
-}
-
-static struct pebs_tracer *ds_request_pebs(struct task_struct *task, int cpu,
-					   void *base, size_t size,
-					   pebs_ovfl_callback_t ovfl, size_t th,
-					   unsigned int flags)
-{
-	struct pebs_tracer *tracer;
-	int error;
-
-	/* Buffer overflow notification is not yet implemented. */
-	error = -EOPNOTSUPP;
-	if (ovfl)
-		goto out;
-
-	error = get_tracer(task);
-	if (error < 0)
-		goto out;
-
-	error = -ENOMEM;
-	tracer = kzalloc(sizeof(*tracer), GFP_KERNEL);
-	if (!tracer)
-		goto out_put_tracer;
-	tracer->ovfl = ovfl;
-
-	/* Do some more error checking and acquire a tracing context. */
-	error = ds_request(&tracer->ds, &tracer->trace.ds,
-			   ds_pebs, task, cpu, base, size, th);
-	if (error < 0)
-		goto out_tracer;
-
-	/* Claim the pebs part of the tracing context we acquired above. */
-	spin_lock_irq(&ds_lock);
-
-	error = -EPERM;
-	if (tracer->ds.context->pebs_master)
-		goto out_unlock;
-	tracer->ds.context->pebs_master = tracer;
-
-	spin_unlock_irq(&ds_lock);
-
-	/*
-	 * Now that we own the pebs part of the context, let's complete the
-	 * initialization for that part.
-	 */
-	ds_init_ds_trace(&tracer->trace.ds, ds_pebs, base, size, th, flags);
-	ds_write_config(tracer->ds.context, &tracer->trace.ds, ds_pebs);
-	ds_install_ds_area(tracer->ds.context);
-
-	/* Start tracing. */
-	ds_resume_pebs(tracer);
-
-	return tracer;
-
- out_unlock:
-	spin_unlock_irq(&ds_lock);
-	ds_put_context(tracer->ds.context);
- out_tracer:
-	kfree(tracer);
- out_put_tracer:
-	put_tracer(task);
- out:
-	return ERR_PTR(error);
-}
-
-struct pebs_tracer *ds_request_pebs_task(struct task_struct *task,
-					 void *base, size_t size,
-					 pebs_ovfl_callback_t ovfl,
-					 size_t th, unsigned int flags)
-{
-	return ds_request_pebs(task, 0, base, size, ovfl, th, flags);
-}
-
-struct pebs_tracer *ds_request_pebs_cpu(int cpu, void *base, size_t size,
-					pebs_ovfl_callback_t ovfl,
-					size_t th, unsigned int flags)
-{
-	return ds_request_pebs(NULL, cpu, base, size, ovfl, th, flags);
-}
-
-static void ds_free_bts(struct bts_tracer *tracer)
-{
-	struct task_struct *task;
-
-	task = tracer->ds.context->task;
-
-	WARN_ON_ONCE(tracer->ds.context->bts_master != tracer);
-	tracer->ds.context->bts_master = NULL;
-
-	/* Make sure tracing stopped and the tracer is not in use. */
-	if (task && (task != current))
-		wait_task_context_switch(task);
-
-	ds_put_context(tracer->ds.context);
-	put_tracer(task);
-
-	kfree(tracer);
-}
-
-void ds_release_bts(struct bts_tracer *tracer)
-{
-	might_sleep();
-
-	if (!tracer)
-		return;
-
-	ds_suspend_bts(tracer);
-	ds_free_bts(tracer);
-}
-
-int ds_release_bts_noirq(struct bts_tracer *tracer)
-{
-	struct task_struct *task;
-	unsigned long irq;
-	int error;
-
-	if (!tracer)
-		return 0;
-
-	task = tracer->ds.context->task;
-
-	local_irq_save(irq);
-
-	error = -EPERM;
-	if (!task &&
-	    (tracer->ds.context->cpu != smp_processor_id()))
-		goto out;
-
-	error = -EPERM;
-	if (task && (task != current))
-		goto out;
-
-	ds_suspend_bts_noirq(tracer);
-	ds_free_bts(tracer);
-
-	error = 0;
- out:
-	local_irq_restore(irq);
-	return error;
-}
-
-static void update_task_debugctlmsr(struct task_struct *task,
-				    unsigned long debugctlmsr)
-{
-	task->thread.debugctlmsr = debugctlmsr;
-
-	get_cpu();
-	if (task == current)
-		update_debugctlmsr(debugctlmsr);
-	put_cpu();
-}
-
-void ds_suspend_bts(struct bts_tracer *tracer)
-{
-	struct task_struct *task;
-	unsigned long debugctlmsr;
-	int cpu;
-
-	if (!tracer)
-		return;
-
-	tracer->flags = 0;
-
-	task = tracer->ds.context->task;
-	cpu  = tracer->ds.context->cpu;
-
-	WARN_ON(!task && irqs_disabled());
-
-	debugctlmsr = (task ?
-		       task->thread.debugctlmsr :
-		       get_debugctlmsr_on_cpu(cpu));
-	debugctlmsr &= ~BTS_CONTROL;
-
-	if (task)
-		update_task_debugctlmsr(task, debugctlmsr);
-	else
-		update_debugctlmsr_on_cpu(cpu, debugctlmsr);
-}
-
-int ds_suspend_bts_noirq(struct bts_tracer *tracer)
-{
-	struct task_struct *task;
-	unsigned long debugctlmsr, irq;
-	int cpu, error = 0;
-
-	if (!tracer)
-		return 0;
-
-	tracer->flags = 0;
-
-	task = tracer->ds.context->task;
-	cpu  = tracer->ds.context->cpu;
-
-	local_irq_save(irq);
-
-	error = -EPERM;
-	if (!task && (cpu != smp_processor_id()))
-		goto out;
-
-	debugctlmsr = (task ?
-		       task->thread.debugctlmsr :
-		       get_debugctlmsr());
-	debugctlmsr &= ~BTS_CONTROL;
-
-	if (task)
-		update_task_debugctlmsr(task, debugctlmsr);
-	else
-		update_debugctlmsr(debugctlmsr);
-
-	error = 0;
- out:
-	local_irq_restore(irq);
-	return error;
-}
-
-static unsigned long ds_bts_control(struct bts_tracer *tracer)
-{
-	unsigned long control;
-
-	control = ds_cfg.ctl[dsf_bts];
-	if (!(tracer->trace.ds.flags & BTS_KERNEL))
-		control |= ds_cfg.ctl[dsf_bts_kernel];
-	if (!(tracer->trace.ds.flags & BTS_USER))
-		control |= ds_cfg.ctl[dsf_bts_user];
-
-	return control;
-}
-
-void ds_resume_bts(struct bts_tracer *tracer)
-{
-	struct task_struct *task;
-	unsigned long debugctlmsr;
-	int cpu;
-
-	if (!tracer)
-		return;
-
-	tracer->flags = tracer->trace.ds.flags;
-
-	task = tracer->ds.context->task;
-	cpu  = tracer->ds.context->cpu;
-
-	WARN_ON(!task && irqs_disabled());
-
-	debugctlmsr = (task ?
-		       task->thread.debugctlmsr :
-		       get_debugctlmsr_on_cpu(cpu));
-	debugctlmsr |= ds_bts_control(tracer);
-
-	if (task)
-		update_task_debugctlmsr(task, debugctlmsr);
-	else
-		update_debugctlmsr_on_cpu(cpu, debugctlmsr);
-}
-
-int ds_resume_bts_noirq(struct bts_tracer *tracer)
-{
-	struct task_struct *task;
-	unsigned long debugctlmsr, irq;
-	int cpu, error = 0;
-
-	if (!tracer)
-		return 0;
-
-	tracer->flags = tracer->trace.ds.flags;
-
-	task = tracer->ds.context->task;
-	cpu  = tracer->ds.context->cpu;
-
-	local_irq_save(irq);
-
-	error = -EPERM;
-	if (!task && (cpu != smp_processor_id()))
-		goto out;
-
-	debugctlmsr = (task ?
-		       task->thread.debugctlmsr :
-		       get_debugctlmsr());
-	debugctlmsr |= ds_bts_control(tracer);
-
-	if (task)
-		update_task_debugctlmsr(task, debugctlmsr);
-	else
-		update_debugctlmsr(debugctlmsr);
-
-	error = 0;
- out:
-	local_irq_restore(irq);
-	return error;
-}
-
-static void ds_free_pebs(struct pebs_tracer *tracer)
-{
-	struct task_struct *task;
-
-	task = tracer->ds.context->task;
-
-	WARN_ON_ONCE(tracer->ds.context->pebs_master != tracer);
-	tracer->ds.context->pebs_master = NULL;
-
-	ds_put_context(tracer->ds.context);
-	put_tracer(task);
-
-	kfree(tracer);
-}
-
-void ds_release_pebs(struct pebs_tracer *tracer)
-{
-	might_sleep();
-
-	if (!tracer)
-		return;
-
-	ds_suspend_pebs(tracer);
-	ds_free_pebs(tracer);
-}
-
-int ds_release_pebs_noirq(struct pebs_tracer *tracer)
-{
-	struct task_struct *task;
-	unsigned long irq;
-	int error;
-
-	if (!tracer)
-		return 0;
-
-	task = tracer->ds.context->task;
-
-	local_irq_save(irq);
-
-	error = -EPERM;
-	if (!task &&
-	    (tracer->ds.context->cpu != smp_processor_id()))
-		goto out;
-
-	error = -EPERM;
-	if (task && (task != current))
-		goto out;
-
-	ds_suspend_pebs_noirq(tracer);
-	ds_free_pebs(tracer);
-
-	error = 0;
- out:
-	local_irq_restore(irq);
-	return error;
-}
-
-void ds_suspend_pebs(struct pebs_tracer *tracer)
-{
-
-}
-
-int ds_suspend_pebs_noirq(struct pebs_tracer *tracer)
-{
-	return 0;
-}
-
-void ds_resume_pebs(struct pebs_tracer *tracer)
-{
-
-}
-
-int ds_resume_pebs_noirq(struct pebs_tracer *tracer)
-{
-	return 0;
-}
-
-const struct bts_trace *ds_read_bts(struct bts_tracer *tracer)
-{
-	if (!tracer)
-		return NULL;
-
-	ds_read_config(tracer->ds.context, &tracer->trace.ds, ds_bts);
-	return &tracer->trace;
-}
-
-const struct pebs_trace *ds_read_pebs(struct pebs_tracer *tracer)
-{
-	if (!tracer)
-		return NULL;
-
-	ds_read_config(tracer->ds.context, &tracer->trace.ds, ds_pebs);
-
-	tracer->trace.counters = ds_cfg.nr_counter_reset;
-	memcpy(tracer->trace.counter_reset,
-	       tracer->ds.context->ds +
-	       (NUM_DS_PTR_FIELDS * ds_cfg.sizeof_ptr_field),
-	       ds_cfg.nr_counter_reset * PEBS_RESET_FIELD_SIZE);
-
-	return &tracer->trace;
-}
-
-int ds_reset_bts(struct bts_tracer *tracer)
-{
-	if (!tracer)
-		return -EINVAL;
-
-	tracer->trace.ds.top = tracer->trace.ds.begin;
-
-	ds_set(tracer->ds.context->ds, ds_bts, ds_index,
-	       (unsigned long)tracer->trace.ds.top);
-
-	return 0;
-}
-
-int ds_reset_pebs(struct pebs_tracer *tracer)
-{
-	if (!tracer)
-		return -EINVAL;
-
-	tracer->trace.ds.top = tracer->trace.ds.begin;
-
-	ds_set(tracer->ds.context->ds, ds_pebs, ds_index,
-	       (unsigned long)tracer->trace.ds.top);
-
-	return 0;
-}
-
-int ds_set_pebs_reset(struct pebs_tracer *tracer,
-		      unsigned int counter, u64 value)
-{
-	if (!tracer)
-		return -EINVAL;
-
-	if (ds_cfg.nr_counter_reset < counter)
-		return -EINVAL;
-
-	*(u64 *)(tracer->ds.context->ds +
-		 (NUM_DS_PTR_FIELDS * ds_cfg.sizeof_ptr_field) +
-		 (counter * PEBS_RESET_FIELD_SIZE)) = value;
-
-	return 0;
-}
-
-static const struct ds_configuration ds_cfg_netburst = {
-	.name = "Netburst",
-	.ctl[dsf_bts]		= (1 << 2) | (1 << 3),
-	.ctl[dsf_bts_kernel]	= (1 << 5),
-	.ctl[dsf_bts_user]	= (1 << 6),
-	.nr_counter_reset	= 1,
-};
-static const struct ds_configuration ds_cfg_pentium_m = {
-	.name = "Pentium M",
-	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
-	.nr_counter_reset	= 1,
-};
-static const struct ds_configuration ds_cfg_core2_atom = {
-	.name = "Core 2/Atom",
-	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
-	.ctl[dsf_bts_kernel]	= (1 << 9),
-	.ctl[dsf_bts_user]	= (1 << 10),
-	.nr_counter_reset	= 1,
-};
-static const struct ds_configuration ds_cfg_core_i7 = {
-	.name = "Core i7",
-	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
-	.ctl[dsf_bts_kernel]	= (1 << 9),
-	.ctl[dsf_bts_user]	= (1 << 10),
-	.nr_counter_reset	= 4,
-};
-
-static void
-ds_configure(const struct ds_configuration *cfg,
-	     struct cpuinfo_x86 *cpu)
-{
-	unsigned long nr_pebs_fields = 0;
-
-	printk(KERN_INFO "[ds] using %s configuration\n", cfg->name);
-
-#ifdef __i386__
-	nr_pebs_fields = 10;
-#else
-	nr_pebs_fields = 18;
-#endif
-
-	/*
-	 * Starting with version 2, architectural performance
-	 * monitoring supports a format specifier.
-	 */
-	if ((cpuid_eax(0xa) & 0xff) > 1) {
-		unsigned long perf_capabilities, format;
-
-		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_capabilities);
-
-		format = (perf_capabilities >> 8) & 0xf;
-
-		switch (format) {
-		case 0:
-			nr_pebs_fields = 18;
-			break;
-		case 1:
-			nr_pebs_fields = 22;
-			break;
-		default:
-			printk(KERN_INFO
-			       "[ds] unknown PEBS format: %lu\n", format);
-			nr_pebs_fields = 0;
-			break;
-		}
-	}
-
-	memset(&ds_cfg, 0, sizeof(ds_cfg));
-	ds_cfg = *cfg;
-
-	ds_cfg.sizeof_ptr_field =
-		(cpu_has(cpu, X86_FEATURE_DTES64) ? 8 : 4);
-
-	ds_cfg.sizeof_rec[ds_bts]  = ds_cfg.sizeof_ptr_field * 3;
-	ds_cfg.sizeof_rec[ds_pebs] = ds_cfg.sizeof_ptr_field * nr_pebs_fields;
-
-	if (!cpu_has(cpu, X86_FEATURE_BTS)) {
-		ds_cfg.sizeof_rec[ds_bts] = 0;
-		printk(KERN_INFO "[ds] bts not available\n");
-	}
-	if (!cpu_has(cpu, X86_FEATURE_PEBS)) {
-		ds_cfg.sizeof_rec[ds_pebs] = 0;
-		printk(KERN_INFO "[ds] pebs not available\n");
-	}
-
-	printk(KERN_INFO "[ds] sizes: address: %u bit, ",
-	       8 * ds_cfg.sizeof_ptr_field);
-	printk("bts/pebs record: %u/%u bytes\n",
-	       ds_cfg.sizeof_rec[ds_bts], ds_cfg.sizeof_rec[ds_pebs]);
-
-	WARN_ON_ONCE(MAX_PEBS_COUNTERS < ds_cfg.nr_counter_reset);
-}
-
-void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
-{
-	/* Only configure the first cpu. Others are identical. */
-	if (ds_cfg.name)
-		return;
-
-	switch (c->x86) {
-	case 0x6:
-		switch (c->x86_model) {
-		case 0x9:
-		case 0xd: /* Pentium M */
-			ds_configure(&ds_cfg_pentium_m, c);
-			break;
-		case 0xf:
-		case 0x17: /* Core2 */
-		case 0x1c: /* Atom */
-			ds_configure(&ds_cfg_core2_atom, c);
-			break;
-		case 0x1a: /* Core i7 */
-			ds_configure(&ds_cfg_core_i7, c);
-			break;
-		default:
-			/* Sorry, don't know about them. */
-			break;
-		}
-		break;
-	case 0xf:
-		switch (c->x86_model) {
-		case 0x0:
-		case 0x1:
-		case 0x2: /* Netburst */
-			ds_configure(&ds_cfg_netburst, c);
-			break;
-		default:
-			/* Sorry, don't know about them. */
-			break;
-		}
-		break;
-	default:
-		/* Sorry, don't know about them. */
-		break;
-	}
-}
-
-static inline void ds_take_timestamp(struct ds_context *context,
-				     enum bts_qualifier qualifier,
-				     struct task_struct *task)
-{
-	struct bts_tracer *tracer = context->bts_master;
-	struct bts_struct ts;
-
-	/* Prevent compilers from reading the tracer pointer twice. */
-	barrier();
-
-	if (!tracer || !(tracer->flags & BTS_TIMESTAMPS))
-		return;
-
-	memset(&ts, 0, sizeof(ts));
-	ts.qualifier		= qualifier;
-	ts.variant.event.clock	= trace_clock_global();
-	ts.variant.event.pid	= task->pid;
-
-	bts_write(tracer, &ts);
-}
-
-/*
- * Change the DS configuration from tracing prev to tracing next.
- */
-void ds_switch_to(struct task_struct *prev, struct task_struct *next)
-{
-	struct ds_context *prev_ctx	= prev->thread.ds_ctx;
-	struct ds_context *next_ctx	= next->thread.ds_ctx;
-	unsigned long debugctlmsr	= next->thread.debugctlmsr;
-
-	/* Make sure all data is read before we start. */
-	barrier();
-
-	if (prev_ctx) {
-		update_debugctlmsr(0);
-
-		ds_take_timestamp(prev_ctx, bts_task_departs, prev);
-	}
-
-	if (next_ctx) {
-		ds_take_timestamp(next_ctx, bts_task_arrives, next);
-
-		wrmsrl(MSR_IA32_DS_AREA, (unsigned long)next_ctx->ds);
-	}
-
-	update_debugctlmsr(debugctlmsr);
-}
-
-static __init int ds_selftest(void)
-{
-	if (ds_cfg.sizeof_rec[ds_bts]) {
-		int error;
-
-		error = ds_selftest_bts();
-		if (error) {
-			WARN(1, "[ds] selftest failed. disabling bts.\n");
-			ds_cfg.sizeof_rec[ds_bts] = 0;
-		}
-	}
-
-	if (ds_cfg.sizeof_rec[ds_pebs]) {
-		int error;
-
-		error = ds_selftest_pebs();
-		if (error) {
-			WARN(1, "[ds] selftest failed. disabling pebs.\n");
-			ds_cfg.sizeof_rec[ds_pebs] = 0;
-		}
-	}
-
-	return 0;
-}
-device_initcall(ds_selftest);
Index: linux-2.6/arch/x86/kernel/ds_selftest.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/ds_selftest.c
+++ /dev/null
@@ -1,408 +0,0 @@
-/*
- * Debug Store support - selftest
- *
- *
- * Copyright (C) 2009 Intel Corporation.
- * Markus Metzger <markus.t.metzger@intel.com>, 2009
- */
-
-#include "ds_selftest.h"
-
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/smp.h>
-#include <linux/cpu.h>
-
-#include <asm/ds.h>
-
-
-#define BUFFER_SIZE		521	/* Intentionally chose an odd size. */
-#define SMALL_BUFFER_SIZE	24	/* A single bts entry. */
-
-struct ds_selftest_bts_conf {
-	struct bts_tracer *tracer;
-	int error;
-	int (*suspend)(struct bts_tracer *);
-	int (*resume)(struct bts_tracer *);
-};
-
-static int ds_selftest_bts_consistency(const struct bts_trace *trace)
-{
-	int error = 0;
-
-	if (!trace) {
-		printk(KERN_CONT "failed to access trace...");
-		/* Bail out. Other tests are pointless. */
-		return -1;
-	}
-
-	if (!trace->read) {
-		printk(KERN_CONT "bts read not available...");
-		error = -1;
-	}
-
-	/* Do some sanity checks on the trace configuration. */
-	if (!trace->ds.n) {
-		printk(KERN_CONT "empty bts buffer...");
-		error = -1;
-	}
-	if (!trace->ds.size) {
-		printk(KERN_CONT "bad bts trace setup...");
-		error = -1;
-	}
-	if (trace->ds.end !=
-	    (char *)trace->ds.begin + (trace->ds.n * trace->ds.size)) {
-		printk(KERN_CONT "bad bts buffer setup...");
-		error = -1;
-	}
-	/*
-	 * We allow top in [begin; end], since its not clear when the
-	 * overflow adjustment happens: after the increment or before the
-	 * write.
-	 */
-	if ((trace->ds.top < trace->ds.begin) ||
-	    (trace->ds.end < trace->ds.top)) {
-		printk(KERN_CONT "bts top out of bounds...");
-		error = -1;
-	}
-
-	return error;
-}
-
-static int ds_selftest_bts_read(struct bts_tracer *tracer,
-				const struct bts_trace *trace,
-				const void *from, const void *to)
-{
-	const unsigned char *at;
-
-	/*
-	 * Check a few things which do not belong to this test.
-	 * They should be covered by other tests.
-	 */
-	if (!trace)
-		return -1;
-
-	if (!trace->read)
-		return -1;
-
-	if (to < from)
-		return -1;
-
-	if (from < trace->ds.begin)
-		return -1;
-
-	if (trace->ds.end < to)
-		return -1;
-
-	if (!trace->ds.size)
-		return -1;
-
-	/* Now to the test itself. */
-	for (at = from; (void *)at < to; at += trace->ds.size) {
-		struct bts_struct bts;
-		unsigned long index;
-		int error;
-
-		if (((void *)at - trace->ds.begin) % trace->ds.size) {
-			printk(KERN_CONT
-			       "read from non-integer index...");
-			return -1;
-		}
-		index = ((void *)at - trace->ds.begin) / trace->ds.size;
-
-		memset(&bts, 0, sizeof(bts));
-		error = trace->read(tracer, at, &bts);
-		if (error < 0) {
-			printk(KERN_CONT
-			       "error reading bts trace at [%lu] (0x%p)...",
-			       index, at);
-			return error;
-		}
-
-		switch (bts.qualifier) {
-		case BTS_BRANCH:
-			break;
-		default:
-			printk(KERN_CONT
-			       "unexpected bts entry %llu at [%lu] (0x%p)...",
-			       bts.qualifier, index, at);
-			return -1;
-		}
-	}
-
-	return 0;
-}
-
-static void ds_selftest_bts_cpu(void *arg)
-{
-	struct ds_selftest_bts_conf *conf = arg;
-	const struct bts_trace *trace;
-	void *top;
-
-	if (IS_ERR(conf->tracer)) {
-		conf->error = PTR_ERR(conf->tracer);
-		conf->tracer = NULL;
-
-		printk(KERN_CONT
-		       "initialization failed (err: %d)...", conf->error);
-		return;
-	}
-
-	/* We should meanwhile have enough trace. */
-	conf->error = conf->suspend(conf->tracer);
-	if (conf->error < 0)
-		return;
-
-	/* Let's see if we can access the trace. */
-	trace = ds_read_bts(conf->tracer);
-
-	conf->error = ds_selftest_bts_consistency(trace);
-	if (conf->error < 0)
-		return;
-
-	/* If everything went well, we should have a few trace entries. */
-	if (trace->ds.top == trace->ds.begin) {
-		/*
-		 * It is possible but highly unlikely that we got a
-		 * buffer overflow and end up at exactly the same
-		 * position we started from.
-		 * Let's issue a warning, but continue.
-		 */
-		printk(KERN_CONT "no trace/overflow...");
-	}
-
-	/* Let's try to read the trace we collected. */
-	conf->error =
-		ds_selftest_bts_read(conf->tracer, trace,
-				     trace->ds.begin, trace->ds.top);
-	if (conf->error < 0)
-		return;
-
-	/*
-	 * Let's read the trace again.
-	 * Since we suspended tracing, we should get the same result.
-	 */
-	top = trace->ds.top;
-
-	trace = ds_read_bts(conf->tracer);
-	conf->error = ds_selftest_bts_consistency(trace);
-	if (conf->error < 0)
-		return;
-
-	if (top != trace->ds.top) {
-		printk(KERN_CONT "suspend not working...");
-		conf->error = -1;
-		return;
-	}
-
-	/* Let's collect some more trace - see if resume is working. */
-	conf->error = conf->resume(conf->tracer);
-	if (conf->error < 0)
-		return;
-
-	conf->error = conf->suspend(conf->tracer);
-	if (conf->error < 0)
-		return;
-
-	trace = ds_read_bts(conf->tracer);
-
-	conf->error = ds_selftest_bts_consistency(trace);
-	if (conf->error < 0)
-		return;
-
-	if (trace->ds.top == top) {
-		/*
-		 * It is possible but highly unlikely that we got a
-		 * buffer overflow and end up at exactly the same
-		 * position we started from.
-		 * Let's issue a warning and check the full trace.
-		 */
-		printk(KERN_CONT
-		       "no resume progress/overflow...");
-
-		conf->error =
-			ds_selftest_bts_read(conf->tracer, trace,
-					     trace->ds.begin, trace->ds.end);
-	} else if (trace->ds.top < top) {
-		/*
-		 * We had a buffer overflow - the entire buffer should
-		 * contain trace records.
-		 */
-		conf->error =
-			ds_selftest_bts_read(conf->tracer, trace,
-					     trace->ds.begin, trace->ds.end);
-	} else {
-		/*
-		 * It is quite likely that the buffer did not overflow.
-		 * Let's just check the delta trace.
-		 */
-		conf->error =
-			ds_selftest_bts_read(conf->tracer, trace, top,
-					     trace->ds.top);
-	}
-	if (conf->error < 0)
-		return;
-
-	conf->error = 0;
-}
-
-static int ds_suspend_bts_wrap(struct bts_tracer *tracer)
-{
-	ds_suspend_bts(tracer);
-	return 0;
-}
-
-static int ds_resume_bts_wrap(struct bts_tracer *tracer)
-{
-	ds_resume_bts(tracer);
-	return 0;
-}
-
-static void ds_release_bts_noirq_wrap(void *tracer)
-{
-	(void)ds_release_bts_noirq(tracer);
-}
-
-static int ds_selftest_bts_bad_release_noirq(int cpu,
-					     struct bts_tracer *tracer)
-{
-	int error = -EPERM;
-
-	/* Try to release the tracer on the wrong cpu. */
-	get_cpu();
-	if (cpu != smp_processor_id()) {
-		error = ds_release_bts_noirq(tracer);
-		if (error != -EPERM)
-			printk(KERN_CONT "release on wrong cpu...");
-	}
-	put_cpu();
-
-	return error ? 0 : -1;
-}
-
-static int ds_selftest_bts_bad_request_cpu(int cpu, void *buffer)
-{
-	struct bts_tracer *tracer;
-	int error;
-
-	/* Try to request cpu tracing while task tracing is active. */
-	tracer = ds_request_bts_cpu(cpu, buffer, BUFFER_SIZE, NULL,
-				    (size_t)-1, BTS_KERNEL);
-	error = PTR_ERR(tracer);
-	if (!IS_ERR(tracer)) {
-		ds_release_bts(tracer);
-		error = 0;
-	}
-
-	if (error != -EPERM)
-		printk(KERN_CONT "cpu/task tracing overlap...");
-
-	return error ? 0 : -1;
-}
-
-static int ds_selftest_bts_bad_request_task(void *buffer)
-{
-	struct bts_tracer *tracer;
-	int error;
-
-	/* Try to request cpu tracing while task tracing is active. */
-	tracer = ds_request_bts_task(current, buffer, BUFFER_SIZE, NULL,
-				    (size_t)-1, BTS_KERNEL);
-	error = PTR_ERR(tracer);
-	if (!IS_ERR(tracer)) {
-		error = 0;
-		ds_release_bts(tracer);
-	}
-
-	if (error != -EPERM)
-		printk(KERN_CONT "task/cpu tracing overlap...");
-
-	return error ? 0 : -1;
-}
-
-int ds_selftest_bts(void)
-{
-	struct ds_selftest_bts_conf conf;
-	unsigned char buffer[BUFFER_SIZE], *small_buffer;
-	unsigned long irq;
-	int cpu;
-
-	printk(KERN_INFO "[ds] bts selftest...");
-	conf.error = 0;
-
-	small_buffer = (unsigned char *)ALIGN((unsigned long)buffer, 8) + 8;
-
-	get_online_cpus();
-	for_each_online_cpu(cpu) {
-		conf.suspend = ds_suspend_bts_wrap;
-		conf.resume = ds_resume_bts_wrap;
-		conf.tracer =
-			ds_request_bts_cpu(cpu, buffer, BUFFER_SIZE,
-					   NULL, (size_t)-1, BTS_KERNEL);
-		ds_selftest_bts_cpu(&conf);
-		if (conf.error >= 0)
-			conf.error = ds_selftest_bts_bad_request_task(buffer);
-		ds_release_bts(conf.tracer);
-		if (conf.error < 0)
-			goto out;
-
-		conf.suspend = ds_suspend_bts_noirq;
-		conf.resume = ds_resume_bts_noirq;
-		conf.tracer =
-			ds_request_bts_cpu(cpu, buffer, BUFFER_SIZE,
-					   NULL, (size_t)-1, BTS_KERNEL);
-		smp_call_function_single(cpu, ds_selftest_bts_cpu, &conf, 1);
-		if (conf.error >= 0) {
-			conf.error =
-				ds_selftest_bts_bad_release_noirq(cpu,
-								  conf.tracer);
-			/* We must not release the tracer twice. */
-			if (conf.error < 0)
-				conf.tracer = NULL;
-		}
-		if (conf.error >= 0)
-			conf.error = ds_selftest_bts_bad_request_task(buffer);
-		smp_call_function_single(cpu, ds_release_bts_noirq_wrap,
-					 conf.tracer, 1);
-		if (conf.error < 0)
-			goto out;
-	}
-
-	conf.suspend = ds_suspend_bts_wrap;
-	conf.resume = ds_resume_bts_wrap;
-	conf.tracer =
-		ds_request_bts_task(current, buffer, BUFFER_SIZE,
-				    NULL, (size_t)-1, BTS_KERNEL);
-	ds_selftest_bts_cpu(&conf);
-	if (conf.error >= 0)
-		conf.error = ds_selftest_bts_bad_request_cpu(0, buffer);
-	ds_release_bts(conf.tracer);
-	if (conf.error < 0)
-		goto out;
-
-	conf.suspend = ds_suspend_bts_noirq;
-	conf.resume = ds_resume_bts_noirq;
-	conf.tracer =
-		ds_request_bts_task(current, small_buffer, SMALL_BUFFER_SIZE,
-				   NULL, (size_t)-1, BTS_KERNEL);
-	local_irq_save(irq);
-	ds_selftest_bts_cpu(&conf);
-	if (conf.error >= 0)
-		conf.error = ds_selftest_bts_bad_request_cpu(0, buffer);
-	ds_release_bts_noirq(conf.tracer);
-	local_irq_restore(irq);
-	if (conf.error < 0)
-		goto out;
-
-	conf.error = 0;
- out:
-	put_online_cpus();
-	printk(KERN_CONT "%s.\n", (conf.error ? "failed" : "passed"));
-
-	return conf.error;
-}
-
-int ds_selftest_pebs(void)
-{
-	return 0;
-}
Index: linux-2.6/arch/x86/kernel/ds_selftest.h
===================================================================
--- linux-2.6.orig/arch/x86/kernel/ds_selftest.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Debug Store support - selftest
- *
- *
- * Copyright (C) 2009 Intel Corporation.
- * Markus Metzger <markus.t.metzger@intel.com>, 2009
- */
-
-#ifdef CONFIG_X86_DS_SELFTEST
-extern int ds_selftest_bts(void);
-extern int ds_selftest_pebs(void);
-#else
-static inline int ds_selftest_bts(void) { return 0; }
-static inline int ds_selftest_pebs(void) { return 0; }
-#endif
Index: linux-2.6/kernel/trace/trace_entries.h
===================================================================
--- linux-2.6.orig/kernel/trace/trace_entries.h
+++ linux-2.6/kernel/trace/trace_entries.h
@@ -318,18 +318,6 @@ FTRACE_ENTRY(branch, trace_branch,
 		 __entry->func, __entry->file, __entry->correct)
 );
 
-FTRACE_ENTRY(hw_branch, hw_branch_entry,
-
-	TRACE_HW_BRANCHES,
-
-	F_STRUCT(
-		__field(	u64,	from	)
-		__field(	u64,	to	)
-	),
-
-	F_printk("from: %llx to: %llx", __entry->from, __entry->to)
-);
-
 FTRACE_ENTRY(kmem_alloc, kmemtrace_alloc_entry,
 
 	TRACE_KMEM_ALLOC,
Index: linux-2.6/arch/x86/kernel/step.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/step.c
+++ linux-2.6/arch/x86/kernel/step.c
@@ -158,22 +158,6 @@ static int enable_single_step(struct tas
 }
 
 /*
- * Install this value in MSR_IA32_DEBUGCTLMSR whenever child is running.
- */
-static void write_debugctlmsr(struct task_struct *child, unsigned long val)
-{
-	if (child->thread.debugctlmsr == val)
-		return;
-
-	child->thread.debugctlmsr = val;
-
-	if (child != current)
-		return;
-
-	update_debugctlmsr(val);
-}
-
-/*
  * Enable single or block step.
  */
 static void enable_step(struct task_struct *child, bool block)
@@ -185,17 +169,9 @@ static void enable_step(struct task_stru
 	 * So noone should try to use debugger block stepping in a program
 	 * that uses user-mode single stepping itself.
 	 */
-	if (enable_single_step(child) && block) {
-		set_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
-		write_debugctlmsr(child,
-				  child->thread.debugctlmsr | DEBUGCTLMSR_BTF);
-	} else {
-		write_debugctlmsr(child,
-				  child->thread.debugctlmsr & ~DEBUGCTLMSR_BTF);
-
-		if (!child->thread.debugctlmsr)
-			clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
-	}
+	if (!enable_single_step(child))
+		return;
+	/* XXX */
 }
 
 void user_enable_single_step(struct task_struct *child)
@@ -213,11 +189,7 @@ void user_disable_single_step(struct tas
 	/*
 	 * Make sure block stepping (BTF) is disabled.
 	 */
-	write_debugctlmsr(child,
-			  child->thread.debugctlmsr & ~DEBUGCTLMSR_BTF);
-
-	if (!child->thread.debugctlmsr)
-		clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
+	/* XXX */
 
 	/* Always clear TIF_SINGLESTEP... */
 	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
Index: linux-2.6/arch/x86/kernel/kprobes.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/kprobes.c
+++ linux-2.6/arch/x86/kernel/kprobes.c
@@ -422,14 +422,12 @@ static void __kprobes set_current_kprobe
 
 static void __kprobes clear_btf(void)
 {
-	if (test_thread_flag(TIF_DEBUGCTLMSR))
-		update_debugctlmsr(0);
+	/* XXX */
 }
 
 static void __kprobes restore_btf(void)
 {
-	if (test_thread_flag(TIF_DEBUGCTLMSR))
-		update_debugctlmsr(current->thread.debugctlmsr);
+	/* XXX */
 }
 
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
Index: linux-2.6/arch/x86/kernel/dumpstack.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/dumpstack.c
+++ linux-2.6/arch/x86/kernel/dumpstack.c
@@ -224,11 +224,6 @@ unsigned __kprobes long oops_begin(void)
 	int cpu;
 	unsigned long flags;
 
-	/* notify the hw-branch tracer so it may disable tracing and
-	   add the last trace to the trace buffer -
-	   the earlier this happens, the more useful the trace. */
-	trace_hw_branch_oops();
-
 	oops_enter();
 
 	/* racy, but better than risking deadlock. */
Index: linux-2.6/arch/x86/kernel/traps.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/traps.c
+++ linux-2.6/arch/x86/kernel/traps.c
@@ -550,11 +550,6 @@ dotraplinkage void __kprobes do_debug(st
 
 	/* DR6 may or may not be cleared by the CPU */
 	set_debugreg(0, 6);
-	/*
-	 * The processor cleared BTF, so don't mark that we need it set.
-	 */
-	clear_tsk_thread_flag(tsk, TIF_DEBUGCTLMSR);
-	tsk->thread.debugctlmsr = 0;
 
 	/* Store the virtualized DR6 value */
 	tsk->thread.debugreg6 = dr6;

-- 

