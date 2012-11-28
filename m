Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab2K1A7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 19:59:51 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:42126 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab2K1A7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 19:59:49 -0500
Date: Tue, 27 Nov 2012 16:59:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Gilad.Ben-Yossef.gilad@benyossef.com
Subject: Re: [PATCH] context_tracking: New context tracking susbsystem
Message-ID: <20121128005942.GV2474@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1354041205-6989-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354041205-6989-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112800-5518-0000-0000-000009979990
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 07:33:25PM +0100, Frederic Weisbecker wrote:
> Create a new subsystem that probes on kernel boundaries
> to keep track of the transitions between level contexts
> with two basic initial contexts: user or kernel.
> 
> This is an abstraction of some RCU code that use such tracking
> to implement its userspace extended quiescent state.
> 
> We need to pull this up from RCU into this new level of indirection
> because this tracking is also going to be used to implement an "on
> demand" generic virtual cputime accounting. A necessary step to
> shutdown the tick while still accounting the cputime.

I have queued this, and if it passes tests and inspection will try
pushing it for 3.8.

							Thanx, Paul

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Li Zhong <zhong@linux.vnet.ibm.com>
> Cc: Gilad Ben-Yossef gilad@benyossef.com
> ---
>  Changes since last version address Gilad's comments and include ifdef fixes.
>  Also CONTEXT_TRACKING_FORCE option has been moved below RCU user mode config
>  as it's the only user for now.
> 
>  arch/Kconfig                                       |   15 ++--
>  arch/x86/Kconfig                                   |    2 +-
>  arch/x86/include/asm/{rcu.h => context_tracking.h} |   15 ++--
>  arch/x86/kernel/entry_64.S                         |    2 +-
>  arch/x86/kernel/ptrace.c                           |    8 +-
>  arch/x86/kernel/signal.c                           |    5 +-
>  arch/x86/kernel/traps.c                            |    2 +-
>  arch/x86/mm/fault.c                                |    2 +-
>  include/linux/context_tracking.h                   |   18 ++++
>  include/linux/rcupdate.h                           |    2 -
>  init/Kconfig                                       |   28 ++++----
>  kernel/Makefile                                    |    1 +
>  kernel/context_tracking.c                          |   83 ++++++++++++++++++++
>  kernel/rcutree.c                                   |   64 +---------------
>  kernel/sched/core.c                                |   11 ++-
>  15 files changed, 150 insertions(+), 108 deletions(-)
>  rename arch/x86/include/asm/{rcu.h => context_tracking.h} (63%)
>  create mode 100644 include/linux/context_tracking.h
>  create mode 100644 kernel/context_tracking.c
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 366ec06..cc74aae 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -300,15 +300,16 @@ config SECCOMP_FILTER
> 
>  	  See Documentation/prctl/seccomp_filter.txt for details.
> 
> -config HAVE_RCU_USER_QS
> +config HAVE_CONTEXT_TRACKING
>  	bool
>  	help
> -	  Provide kernel entry/exit hooks necessary for userspace
> -	  RCU extended quiescent state. Syscalls need to be wrapped inside
> -	  rcu_user_exit()-rcu_user_enter() through the slow path using
> -	  TIF_NOHZ flag. Exceptions handlers must be wrapped as well. Irqs
> -	  are already protected inside rcu_irq_enter/rcu_irq_exit() but
> -	  preemption or signal handling on irq exit still need to be protected.
> +	  Provide kernel/user boundaries probes necessary for subsystems
> +	  that need it, such as userspace RCU extended quiescent state.
> +	  Syscalls need to be wrapped inside user_exit()-user_enter() through
> +	  the slow path using TIF_NOHZ flag. Exceptions handlers must be
> +	  wrapped as well. Irqs are already protected inside
> +	  rcu_irq_enter/rcu_irq_exit() but preemption or signal handling on
> +	  irq exit still need to be protected.
> 
>  config HAVE_VIRT_CPU_ACCOUNTING
>  	bool
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 46c3bff..110cfad 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -106,7 +106,7 @@ config X86
>  	select KTIME_SCALAR if X86_32
>  	select GENERIC_STRNCPY_FROM_USER
>  	select GENERIC_STRNLEN_USER
> -	select HAVE_RCU_USER_QS if X86_64
> +	select HAVE_CONTEXT_TRACKING if X86_64
>  	select HAVE_IRQ_TIME_ACCOUNTING
>  	select GENERIC_KERNEL_THREAD
>  	select GENERIC_KERNEL_EXECVE
> diff --git a/arch/x86/include/asm/rcu.h b/arch/x86/include/asm/context_tracking.h
> similarity index 63%
> rename from arch/x86/include/asm/rcu.h
> rename to arch/x86/include/asm/context_tracking.h
> index d1ac07a..1616562 100644
> --- a/arch/x86/include/asm/rcu.h
> +++ b/arch/x86/include/asm/context_tracking.h
> @@ -1,27 +1,26 @@
> -#ifndef _ASM_X86_RCU_H
> -#define _ASM_X86_RCU_H
> +#ifndef _ASM_X86_CONTEXT_TRACKING_H
> +#define _ASM_X86_CONTEXT_TRACKING_H
> 
>  #ifndef __ASSEMBLY__
> -
> -#include <linux/rcupdate.h>
> +#include <linux/context_tracking.h>
>  #include <asm/ptrace.h>
> 
>  static inline void exception_enter(struct pt_regs *regs)
>  {
> -	rcu_user_exit();
> +	user_exit();
>  }
> 
>  static inline void exception_exit(struct pt_regs *regs)
>  {
> -#ifdef CONFIG_RCU_USER_QS
> +#ifdef CONFIG_CONTEXT_TRACKING
>  	if (user_mode(regs))
> -		rcu_user_enter();
> +		user_enter();
>  #endif
>  }
> 
>  #else /* __ASSEMBLY__ */
> 
> -#ifdef CONFIG_RCU_USER_QS
> +#ifdef CONFIG_CONTEXT_TRACKING
>  # define SCHEDULE_USER call schedule_user
>  #else
>  # define SCHEDULE_USER call schedule
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 0c58952..98faeb3 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -56,7 +56,7 @@
>  #include <asm/ftrace.h>
>  #include <asm/percpu.h>
>  #include <asm/asm.h>
> -#include <asm/rcu.h>
> +#include <asm/context_tracking.h>
>  #include <asm/smap.h>
>  #include <linux/err.h>
> 
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index eff5b8c..65b88a5 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -21,7 +21,7 @@
>  #include <linux/signal.h>
>  #include <linux/perf_event.h>
>  #include <linux/hw_breakpoint.h>
> -#include <linux/rcupdate.h>
> +#include <linux/context_tracking.h>
> 
>  #include <asm/uaccess.h>
>  #include <asm/pgtable.h>
> @@ -1461,7 +1461,7 @@ long syscall_trace_enter(struct pt_regs *regs)
>  {
>  	long ret = 0;
> 
> -	rcu_user_exit();
> +	user_exit();
> 
>  	/*
>  	 * If we stepped into a sysenter/syscall insn, it trapped in
> @@ -1516,7 +1516,7 @@ void syscall_trace_leave(struct pt_regs *regs)
>  	 * or do_notify_resume(), in which case we can be in RCU
>  	 * user mode.
>  	 */
> -	rcu_user_exit();
> +	user_exit();
> 
>  	audit_syscall_exit(regs);
> 
> @@ -1534,5 +1534,5 @@ void syscall_trace_leave(struct pt_regs *regs)
>  	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
>  		tracehook_report_syscall_exit(regs, step);
> 
> -	rcu_user_enter();
> +	user_enter();
>  }
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index 29ad351..20ecac1 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -22,6 +22,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/user-return-notifier.h>
>  #include <linux/uprobes.h>
> +#include <linux/context_tracking.h>
> 
>  #include <asm/processor.h>
>  #include <asm/ucontext.h>
> @@ -816,7 +817,7 @@ static void do_signal(struct pt_regs *regs)
>  void
>  do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
>  {
> -	rcu_user_exit();
> +	user_exit();
> 
>  #ifdef CONFIG_X86_MCE
>  	/* notify userspace of pending MCEs */
> @@ -840,7 +841,7 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
>  	if (thread_info_flags & _TIF_USER_RETURN_NOTIFY)
>  		fire_user_return_notifiers();
> 
> -	rcu_user_enter();
> +	user_enter();
>  }
> 
>  void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 8276dc6..eb85866 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -55,7 +55,7 @@
>  #include <asm/i387.h>
>  #include <asm/fpu-internal.h>
>  #include <asm/mce.h>
> -#include <asm/rcu.h>
> +#include <asm/context_tracking.h>
> 
>  #include <asm/mach_traps.h>
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 8e13ecb..b0b1f1d 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -18,7 +18,7 @@
>  #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
>  #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
>  #include <asm/fixmap.h>			/* VSYSCALL_START		*/
> -#include <asm/rcu.h>			/* exception_enter(), ...	*/
> +#include <asm/context_tracking.h>		/* exception_enter(), ...	*/
> 
>  /*
>   * Page fault error code bits:
> diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
> new file mode 100644
> index 0000000..e24339c
> --- /dev/null
> +++ b/include/linux/context_tracking.h
> @@ -0,0 +1,18 @@
> +#ifndef _LINUX_CONTEXT_TRACKING_H
> +#define _LINUX_CONTEXT_TRACKING_H
> +
> +#ifdef CONFIG_CONTEXT_TRACKING
> +#include <linux/sched.h>
> +
> +extern void user_enter(void);
> +extern void user_exit(void);
> +extern void context_tracking_task_switch(struct task_struct *prev,
> +					 struct task_struct *next);
> +#else
> +static inline void user_enter(void) { }
> +static inline void user_exit(void) { }
> +static inline void context_tracking_task_switch(struct task_struct *prev,
> +						struct task_struct *next) { }
> +#endif /* !CONFIG_CONTEXT_TRACKING */
> +
> +#endif
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 8fe7c18..275aa3f 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -222,8 +222,6 @@ extern void rcu_user_enter(void);
>  extern void rcu_user_exit(void);
>  extern void rcu_user_enter_after_irq(void);
>  extern void rcu_user_exit_after_irq(void);
> -extern void rcu_user_hooks_switch(struct task_struct *prev,
> -				  struct task_struct *next);
>  #else
>  static inline void rcu_user_enter(void) { }
>  static inline void rcu_user_exit(void) { }
> diff --git a/init/Kconfig b/init/Kconfig
> index 5ac6ee0..2054e04 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -486,9 +486,13 @@ config PREEMPT_RCU
>  	  This option enables preemptible-RCU code that is common between
>  	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
> 
> +config CONTEXT_TRACKING
> +       bool
> +
>  config RCU_USER_QS
>  	bool "Consider userspace as in RCU extended quiescent state"
> -	depends on HAVE_RCU_USER_QS && SMP
> +	depends on HAVE_CONTEXT_TRACKING && SMP
> +	select CONTEXT_TRACKING
>  	help
>  	  This option sets hooks on kernel / userspace boundaries and
>  	  puts RCU in extended quiescent state when the CPU runs in
> @@ -497,24 +501,20 @@ config RCU_USER_QS
>  	  try to keep the timer tick on for RCU.
> 
>  	  Unless you want to hack and help the development of the full
> -	  tickless feature, you shouldn't enable this option.  It also
> +	  dynticks mode, you shouldn't enable this option.  It also
>  	  adds unnecessary overhead.
> 
>  	  If unsure say N
> 
> -config RCU_USER_QS_FORCE
> -	bool "Force userspace extended QS by default"
> -	depends on RCU_USER_QS
> +config CONTEXT_TRACKING_FORCE
> +	bool "Force context tracking"
> +	depends on CONTEXT_TRACKING
>  	help
> -	  Set the hooks in user/kernel boundaries by default in order to
> -	  test this feature that treats userspace as an extended quiescent
> -	  state until we have a real user like a full adaptive nohz option.
> -
> -	  Unless you want to hack and help the development of the full
> -	  tickless feature, you shouldn't enable this option. It adds
> -	  unnecessary overhead.
> -
> -	  If unsure say N
> +	  Probe on user/kernel boundaries by default in order to
> +	  test the features that rely on it such as userspace RCU extended
> +	  quiescent states.
> +	  This test is there for debugging until we have a real user like the
> +	  full dynticks mode.
> 
>  config RCU_FANOUT
>  	int "Tree-based hierarchical RCU fanout value"
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 0dfeca4..f90bbfc 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -110,6 +110,7 @@ obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
>  obj-$(CONFIG_PADATA) += padata.o
>  obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
>  obj-$(CONFIG_JUMP_LABEL) += jump_label.o
> +obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
> 
>  $(obj)/configs.o: $(obj)/config_data.h
> 
> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
> new file mode 100644
> index 0000000..e0e07fd
> --- /dev/null
> +++ b/kernel/context_tracking.c
> @@ -0,0 +1,83 @@
> +#include <linux/context_tracking.h>
> +#include <linux/rcupdate.h>
> +#include <linux/sched.h>
> +#include <linux/percpu.h>
> +#include <linux/hardirq.h>
> +
> +struct context_tracking {
> +	/*
> +	 * When active is false, hooks are not set to
> +	 * minimize overhead: TIF flags are cleared
> +	 * and calls to user_enter/exit are ignored. This
> +	 * may be further optimized using static keys.
> +	 */
> +	bool active;
> +	enum {
> +		IN_KERNEL = 0,
> +		IN_USER,
> +	} state;
> +};
> +
> +static DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
> +#ifdef CONFIG_CONTEXT_TRACKING_FORCE
> +	.active = true,
> +#endif
> +};
> +
> +void user_enter(void)
> +{
> +	unsigned long flags;
> +
> +	/*
> +	 * Some contexts may involve an exception occuring in an irq,
> +	 * leading to that nesting:
> +	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
> +	 * This would mess up the dyntick_nesting count though. And rcu_irq_*()
> +	 * helpers are enough to protect RCU uses inside the exception. So
> +	 * just return immediately if we detect we are in an IRQ.
> +	 */
> +	if (in_interrupt())
> +		return;
> +
> +	WARN_ON_ONCE(!current->mm);
> +
> +	local_irq_save(flags);
> +	if (__this_cpu_read(context_tracking.active) &&
> +	    __this_cpu_read(context_tracking.state) != IN_USER) {
> +		__this_cpu_write(context_tracking.state, IN_USER);
> +		rcu_user_enter();
> +	}
> +	local_irq_restore(flags);
> +}
> +
> +void user_exit(void)
> +{
> +	unsigned long flags;
> +
> +	/*
> +	 * Some contexts may involve an exception occuring in an irq,
> +	 * leading to that nesting:
> +	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
> +	 * This would mess up the dyntick_nesting count though. And rcu_irq_*()
> +	 * helpers are enough to protect RCU uses inside the exception. So
> +	 * just return immediately if we detect we are in an IRQ.
> +	 */
> +	if (in_interrupt())
> +		return;
> +
> +	local_irq_save(flags);
> +	if (__this_cpu_read(context_tracking.state) == IN_USER) {
> +		__this_cpu_write(context_tracking.state, IN_KERNEL);
> +		rcu_user_exit();
> +	}
> +	local_irq_restore(flags);
> +}
> +
> +void context_tracking_task_switch(struct task_struct *prev,
> +			     struct task_struct *next)
> +{
> +	if (__this_cpu_read(context_tracking.active)) {
> +		clear_tsk_thread_flag(prev, TIF_NOHZ);
> +		set_tsk_thread_flag(next, TIF_NOHZ);
> +	}
> +}
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 7733eb5..e441b77 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -207,9 +207,6 @@ EXPORT_SYMBOL_GPL(rcu_note_context_switch);
>  DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
>  	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
>  	.dynticks = ATOMIC_INIT(1),
> -#if defined(CONFIG_RCU_USER_QS) && !defined(CONFIG_RCU_USER_QS_FORCE)
> -	.ignore_user_qs = true,
> -#endif
>  };
> 
>  static long blimit = 10;	/* Maximum callbacks per rcu_do_batch. */
> @@ -420,29 +417,7 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
>   */
>  void rcu_user_enter(void)
>  {
> -	unsigned long flags;
> -	struct rcu_dynticks *rdtp;
> -
> -	/*
> -	 * Some contexts may involve an exception occuring in an irq,
> -	 * leading to that nesting:
> -	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
> -	 * This would mess up the dyntick_nesting count though. And rcu_irq_*()
> -	 * helpers are enough to protect RCU uses inside the exception. So
> -	 * just return immediately if we detect we are in an IRQ.
> -	 */
> -	if (in_interrupt())
> -		return;
> -
> -	WARN_ON_ONCE(!current->mm);
> -
> -	local_irq_save(flags);
> -	rdtp = &__get_cpu_var(rcu_dynticks);
> -	if (!rdtp->ignore_user_qs && !rdtp->in_user) {
> -		rdtp->in_user = true;
> -		rcu_eqs_enter(true);
> -	}
> -	local_irq_restore(flags);
> +	rcu_eqs_enter(1);
>  }
> 
>  /**
> @@ -579,27 +554,7 @@ EXPORT_SYMBOL_GPL(rcu_idle_exit);
>   */
>  void rcu_user_exit(void)
>  {
> -	unsigned long flags;
> -	struct rcu_dynticks *rdtp;
> -
> -	/*
> -	 * Some contexts may involve an exception occuring in an irq,
> -	 * leading to that nesting:
> -	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
> -	 * This would mess up the dyntick_nesting count though. And rcu_irq_*()
> -	 * helpers are enough to protect RCU uses inside the exception. So
> -	 * just return immediately if we detect we are in an IRQ.
> -	 */
> -	if (in_interrupt())
> -		return;
> -
> -	local_irq_save(flags);
> -	rdtp = &__get_cpu_var(rcu_dynticks);
> -	if (rdtp->in_user) {
> -		rdtp->in_user = false;
> -		rcu_eqs_exit(true);
> -	}
> -	local_irq_restore(flags);
> +	rcu_eqs_exit(1);
>  }
> 
>  /**
> @@ -722,21 +677,6 @@ int rcu_is_cpu_idle(void)
>  }
>  EXPORT_SYMBOL(rcu_is_cpu_idle);
> 
> -#ifdef CONFIG_RCU_USER_QS
> -void rcu_user_hooks_switch(struct task_struct *prev,
> -			   struct task_struct *next)
> -{
> -	struct rcu_dynticks *rdtp;
> -
> -	/* Interrupts are disabled in context switch */
> -	rdtp = &__get_cpu_var(rcu_dynticks);
> -	if (!rdtp->ignore_user_qs) {
> -		clear_tsk_thread_flag(prev, TIF_NOHZ);
> -		set_tsk_thread_flag(next, TIF_NOHZ);
> -	}
> -}
> -#endif /* #ifdef CONFIG_RCU_USER_QS */
> -
>  #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU)
> 
>  /*
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 36f2608..80f80df 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -72,6 +72,7 @@
>  #include <linux/slab.h>
>  #include <linux/init_task.h>
>  #include <linux/binfmts.h>
> +#include <linux/context_tracking.h>
> 
>  #include <asm/switch_to.h>
>  #include <asm/tlb.h>
> @@ -1886,8 +1887,8 @@ context_switch(struct rq *rq, struct task_struct *prev,
>  	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
>  #endif
> 
> +	context_tracking_task_switch(prev, next);
>  	/* Here we just switch the register state and the stack. */
> -	rcu_user_hooks_switch(prev, next);
>  	switch_to(prev, next, prev);
> 
>  	barrier();
> @@ -2911,7 +2912,7 @@ asmlinkage void __sched schedule(void)
>  }
>  EXPORT_SYMBOL(schedule);
> 
> -#ifdef CONFIG_RCU_USER_QS
> +#ifdef CONFIG_CONTEXT_TRACKING
>  asmlinkage void __sched schedule_user(void)
>  {
>  	/*
> @@ -2920,9 +2921,9 @@ asmlinkage void __sched schedule_user(void)
>  	 * we haven't yet exited the RCU idle mode. Do it here manually until
>  	 * we find a better solution.
>  	 */
> -	rcu_user_exit();
> +	user_exit();
>  	schedule();
> -	rcu_user_enter();
> +	user_enter();
>  }
>  #endif
> 
> @@ -3027,7 +3028,7 @@ asmlinkage void __sched preempt_schedule_irq(void)
>  	/* Catch callers which need to be fixed */
>  	BUG_ON(ti->preempt_count || !irqs_disabled());
> 
> -	rcu_user_exit();
> +	user_exit();
>  	do {
>  		add_preempt_count(PREEMPT_ACTIVE);
>  		local_irq_enable();
> -- 
> 1.7.5.4
> 

