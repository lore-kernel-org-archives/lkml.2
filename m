Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab2AXTPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 14:15:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42776 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab2AXTO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 14:14:57 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=NWX5JnvlZeMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=5WcQuiXMsR5-gZOgG24A:9 a=pl1NlZEBrWKLD5u8n2QA:7 a=jeBq3FmKZ4MA:10 a=WQWkcIQXz9eVFseg:21 a=846VDRlgS7jXVbfn:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120124191454.345715521@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 24 Jan 2012 13:53:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andi Kleen <ak@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Clark Williams <williams@redhat.com>,
        Luis Goncalves <lgoncalv@redhat.com>
Subject: [PATCH RT 2/2][RFC] preempt-rt/x86: Delay calling singals in int3
References: <20120124185350.092483803@goodmis.org>
Content-Disposition: inline; filename=fix-rt-int3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_64 we must disable preemption before we enable interrupts
for int3 and debugging, because the current task is using a per CPU
debug stack defined by the IST. If we schedule out, another task
can come in and use the same stack and cause the stack to be corrupted
and crash the kernel on return.

When CONFIG_PREEMPT_RT_FULL is enabled, spin_locks become mutexes, and
one of these is the spin lock used in signal handling.

Some of the debug code (int3) causes do_trap() to send a signal.
This function calls a spin lock that has been converted to a mutex
and has the possibility to sleep. If this happens, the above issues with
the corrupted stack is possible.

Instead of calling the signal right away, for PREEMPT_RT and x86_64,
the signal information is stored on the stacks task_struct and a
new TIF flag is set (TIF_FORCE_SIG_TRAP). On exit of the exception,
in paranoid_exit, if NEED_RESCHED is set, the task stack is switched
back to the kernel stack and interrupts is enabled. In this code
the TIF_FORCE_SIG_TRAP is also checked and a function is called to
do the force_sig() in a context that may schedule.

Note, to get into this path, the NEED_RESCHED flag is also set.
But as this only happens in debug context, an extra schedule should not
be an issue.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/arch/x86/include/asm/thread_info.h
===================================================================
--- linux-rt.git.orig/arch/x86/include/asm/thread_info.h
+++ linux-rt.git/arch/x86/include/asm/thread_info.h
@@ -95,6 +95,7 @@ struct thread_info {
 #define TIF_BLOCKSTEP		25	/* set when we want DEBUGCTLMSR_BTF */
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
 #define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
+#define TIF_FORCE_SIG_TRAP	29	/* force a signal coming back from trap */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -117,6 +118,7 @@ struct thread_info {
 #define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
+#define _TIF_FORCE_SIG_TRAP	(1 << TIF_FORCE_SIG_TRAP)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
@@ -266,5 +268,14 @@ extern void arch_task_cache_init(void);
 extern void free_thread_info(struct thread_info *ti);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
 #define arch_task_cache_init arch_task_cache_init
+
+struct siginfo;
+/*
+ * Hacks for RT to get around signal processing with int3 and do_debug.
+ */
+void
+force_sig_info_rt(int sig, struct siginfo *info, struct task_struct *p, int rt);
+void send_sigtrap_rt(struct task_struct *tsk, struct pt_regs *regs,
+		     int error_code, int si_code);
 #endif
 #endif /* _ASM_X86_THREAD_INFO_H */
Index: linux-rt.git/arch/x86/kernel/entry_64.S
===================================================================
--- linux-rt.git.orig/arch/x86/kernel/entry_64.S
+++ linux-rt.git/arch/x86/kernel/entry_64.S
@@ -1391,6 +1391,13 @@ paranoid_userspace:
 paranoid_schedule:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_ANY)
+#ifdef CONFIG_PREEMPT_RT_FULL
+	movl TI_flags(%rcx),%ebx
+	testl $_TIF_FORCE_SIG_TRAP,%ebx
+	jz paranoid_do_schedule
+	call do_force_sig_trap
+paranoid_do_schedule:
+#endif
 	call schedule
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
Index: linux-rt.git/arch/x86/kernel/ptrace.c
===================================================================
--- linux-rt.git.orig/arch/x86/kernel/ptrace.c
+++ linux-rt.git/arch/x86/kernel/ptrace.c
@@ -1341,14 +1341,31 @@ void user_single_step_siginfo(struct tas
 	fill_sigtrap_info(tsk, regs, 0, TRAP_BRKPT, info);
 }
 
-void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
-					 int error_code, int si_code)
+static void __send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
+		  int error_code, int si_code, int rt)
 {
 	struct siginfo info;
 
 	fill_sigtrap_info(tsk, regs, error_code, si_code, &info);
 	/* Send us the fake SIGTRAP */
-	force_sig_info(SIGTRAP, &info, tsk);
+	force_sig_info_rt(SIGTRAP, &info, tsk, rt);
+}
+
+void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
+		  int error_code, int si_code)
+{
+	__send_sigtrap(tsk, regs, error_code, si_code, 0);
+}
+
+void send_sigtrap_rt(struct task_struct *tsk, struct pt_regs *regs,
+		  int error_code, int si_code)
+{
+#if defined(CONFIG_X86_64) && defined(CONFIG_PREEMPT_RT_FULL)
+	int rt = 1;
+#else
+	int rt = 0;
+#endif
+	__send_sigtrap(tsk, regs, error_code, si_code, rt);
 }
 
 
Index: linux-rt.git/arch/x86/kernel/traps.c
===================================================================
--- linux-rt.git.orig/arch/x86/kernel/traps.c
+++ linux-rt.git/arch/x86/kernel/traps.c
@@ -116,9 +116,83 @@ static inline void preempt_conditional_c
 #endif
 }
 
+#if defined(CONFIG_X86_64) && defined(CONFIG_PREEMPT_RT_FULL)
+/*
+ * In PREEMP_RT_FULL, the signal spinlocks are mutexes. But if
+ * do_int3 calls do_trap, we are running on the debug stack, and
+ * not the task struct stack. We must keep preemption disabled
+ * because the current stack is per CPU not per task.
+ *
+ * Instead, we set the
+
+ */
+void
+__force_sig_info_rt(int sig, struct siginfo *info, struct task_struct *p, int rt)
+{
+	if (!rt) {
+		/* simple case */
+		if (info)
+			force_sig_info(sig, info, p);
+		else
+			force_sig(sig, p);
+		return;
+	}
+	trace_printk("doing delayed force_sig info=%p\n", info);
+	/*
+	 * Sad, but to make things easier we set need resched,
+	 * this forces the paranoid exit in traps to swap out
+	 * of the debug stack and back to the users stack.
+	 * Then there we call do_force_sig_trap() which does
+	 * the delayed force_sig() with interrupts enabled and
+	 * a thread stack that we can schedule on.
+	 */
+	set_need_resched();
+	set_thread_flag(TIF_FORCE_SIG_TRAP);
+	if (info) {
+		memcpy(&p->stored_info, info, sizeof(p->stored_info));
+		p->stored_info_set = 1;
+	} else
+		p->stored_info_set = 0;
+
+}
+
+void force_sig_rt(int sig, struct task_struct *p, int rt)
+{
+	__force_sig_info_rt(sig, NULL, p, rt);
+}
+
+void
+force_sig_info_rt(int sig, struct siginfo *info, struct task_struct *p, int rt)
+{
+	__force_sig_info_rt(sig, info, p, rt);
+}
+
+void do_force_sig_trap(void)
+{
+	struct task_struct *p = current;
+
+	trace_printk("forced sig! (set=%d)\n", p->stored_info_set);
+	if (p->stored_info_set)
+		force_sig_info(SIGTRAP, &p->stored_info, p);
+	else
+		force_sig(SIGTRAP, p);
+	p->stored_info_set = 0;
+	clear_thread_flag(TIF_FORCE_SIG_TRAP);
+}
+#else
+void force_sig_rt(int sig, struct task_struct *p, int rt)
+{
+	force_sig(sig, p);
+}
+void force_sig_info_rt(int sig, struct siginfo *info, struct task_struct *p, int rt)
+{
+	force_sig_info(sig, info, p);
+}
+#endif
+
 static void __kprobes
-do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
-	long error_code, siginfo_t *info)
+__do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
+	  long error_code, siginfo_t *info, int rt)
 {
 	struct task_struct *tsk = current;
 
@@ -167,7 +241,7 @@ trap_signal:
 	if (info)
 		force_sig_info(signr, info, tsk);
 	else
-		force_sig(signr, tsk);
+		force_sig_rt(signr, tsk, rt);
 	return;
 
 kernel_trap:
@@ -187,6 +261,13 @@ vm86_trap:
 #endif
 }
 
+static void __kprobes
+do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
+	long error_code, siginfo_t *info)
+{
+	__do_trap(trapnr, signr, str, regs, error_code, info, 0);
+}
+
 #define DO_ERROR(trapnr, signr, str, name)				\
 dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
@@ -326,7 +407,7 @@ dotraplinkage void __kprobes do_int3(str
 #endif
 
 	preempt_conditional_sti(regs);
-	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
+	__do_trap(3, SIGTRAP, "int3", regs, error_code, NULL, 1);
 	preempt_conditional_cli(regs);
 }
 
@@ -444,7 +525,7 @@ dotraplinkage void __kprobes do_debug(st
 	}
 	si_code = get_si_code(tsk->thread.debugreg6);
 	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS) || user_icebp)
-		send_sigtrap(tsk, regs, error_code, si_code);
+		send_sigtrap_rt(tsk, regs, error_code, si_code);
 	preempt_conditional_cli(regs);
 
 	return;
Index: linux-rt.git/include/linux/sched.h
===================================================================
--- linux-rt.git.orig/include/linux/sched.h
+++ linux-rt.git/include/linux/sched.h
@@ -1599,6 +1599,10 @@ struct task_struct {
 #ifdef CONFIG_PREEMPT_RT_BASE
 	struct rcu_head put_rcu;
 	int softirq_nestcnt;
+#ifdef CONFIG_X86_64
+	struct siginfo stored_info;
+	int stored_info_set;
+#endif
 #endif
 #if defined CONFIG_PREEMPT_RT_FULL && defined CONFIG_HIGHMEM
 	int kmap_idx;

