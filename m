Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab2LUPKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 10:10:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5571 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab2LUPJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 10:09:58 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=bpIaNEhXRBcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=KWSkTqdrn6sA:10 a=jII-vq7XzK0VYV2_v4MA:9 a=PUjeQqilurYA:10 a=gc17JPqUFYkJUpom:21 a=IxeEIw3vpCT2TGZK:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1356102595.5896.105.camel@gandalf.local.home>
Subject: Re: [PATCH 05/24] cputime: Safely read cputime of full dynticks CPUs
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 21 Dec 2012 10:09:55 -0500
In-Reply-To: <1356028391-14427-6-git-send-email-fweisbec@gmail.com>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
	 <1356028391-14427-6-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-20 at 19:32 +0100, Frederic Weisbecker wrote:

> --- a/include/linux/init_task.h
> +++ b/include/linux/init_task.h
> @@ -10,6 +10,7 @@
>  #include <linux/pid_namespace.h>
>  #include <linux/user_namespace.h>
>  #include <linux/securebits.h>
> +#include <linux/seqlock.h>
>  #include <net/net_namespace.h>
>  
>  #ifdef CONFIG_SMP
> @@ -141,6 +142,13 @@ extern struct task_group root_task_group;
>  # define INIT_PERF_EVENTS(tsk)
>  #endif
>  
> +#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
> +#define INIT_VTIME(tsk)						\
> +	.vtime_seqlock = __SEQLOCK_UNLOCKED(tsk.vtime_seqlock),	\
> +	.prev_jiffies = INITIAL_JIFFIES, /* CHECKME */		\
> +	.prev_jiffies_whence = JIFFIES_SYS,

#else
# define INIT_VTIME(tsk)
#endif

Otherwise it fails to compile when CONFIG_VIRT_CPU_ACCOUNTING_GEN is not
set.

-- Steve

> +#endif
> +
>  #define INIT_TASK_COMM "swapper"
>  
>  /*
> @@ -210,6 +218,7 @@ extern struct task_group root_task_group;
>  	INIT_TRACE_RECURSION						\
>  	INIT_TASK_RCU_PREEMPT(tsk)					\
>  	INIT_CPUSET_SEQ							\
> +	INIT_VTIME(tsk)							\
>  }
>  
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 031afd0..727b988 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1360,6 +1360,15 @@ struct task_struct {
>  #ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
>  	struct cputime prev_cputime;
>  #endif
> +#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
> +	seqlock_t vtime_seqlock;
> +	long prev_jiffies;
> +	enum {
> +		JIFFIES_SLEEPING = 0,
> +		JIFFIES_USER,
> +		JIFFIES_SYS,
> +	} prev_jiffies_whence;
> +#endif
>  	unsigned long nvcsw, nivcsw; /* context switch counts */
>  	struct timespec start_time; 		/* monotonic time */
>  	struct timespec real_start_time;	/* boot based time */
> @@ -1769,6 +1778,12 @@ static inline void put_task_struct(struct task_struct *t)
>  		__put_task_struct(t);
>  }
>  
> +#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
> +extern void task_cputime(struct task_struct *t,
> +			 cputime_t *utime, cputime_t *stime);
> +extern void task_cputime_scaled(struct task_struct *t,
> +				cputime_t *utimescaled, cputime_t *stimescaled);
> +#else
>  static inline void task_cputime(struct task_struct *t,
>  				cputime_t *utime, cputime_t *stime)
>  {
> @@ -1787,6 +1802,7 @@ static inline void task_cputime_scaled(struct task_struct *t,
>  	if (stimescaled)
>  		*stimescaled = t->stimescaled;
>  }
> +#endif
>  extern void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
>  extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
>  
> diff --git a/include/linux/vtime.h b/include/linux/vtime.h
> index e57020d..81c7d84 100644
> --- a/include/linux/vtime.h
> +++ b/include/linux/vtime.h
> @@ -9,52 +9,52 @@ extern void vtime_account_system(struct task_struct *tsk);
>  extern void vtime_account_system_irqsafe(struct task_struct *tsk);
>  extern void vtime_account_idle(struct task_struct *tsk);
>  extern void vtime_account_user(struct task_struct *tsk);
> -extern void vtime_account(struct task_struct *tsk);
> +extern void vtime_account_irq_enter(struct task_struct *tsk);
>  
> -#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
> -extern bool vtime_accounting(void);
> -#else
> +#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
>  static inline bool vtime_accounting(void) { return true; }
>  #endif
>  
>  #else /* !CONFIG_VIRT_CPU_ACCOUNTING */
> +
>  static inline void vtime_task_switch(struct task_struct *prev) { }
>  static inline void vtime_account_system(struct task_struct *tsk) { }
>  static inline void vtime_account_system_irqsafe(struct task_struct *tsk) { }
>  static inline void vtime_account_user(struct task_struct *tsk) { }
> -static inline void vtime_account(struct task_struct *tsk) { }
> +static inline void vtime_account_irq_enter(struct task_struct *tsk) { }
>  static inline bool vtime_accounting(void) { return false; }
>  #endif
>  
>  #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
> -static inline void arch_vtime_task_switch(struct task_struct *tsk) { }
> +extern void arch_vtime_task_switch(struct task_struct *tsk);
> +extern void vtime_account_irq_exit(struct task_struct *tsk);
> +extern void vtime_user_enter(struct task_struct *tsk);
> +extern bool vtime_accounting(void);
> +#else
> +static inline void vtime_account_irq_exit(struct task_struct *tsk)
> +{
> +	/* On hard|softirq exit we always account to hard|softirq cputime */
> +	vtime_account_system(tsk);
> +}
> +static inline void vtime_enter_user(struct task_struct *tsk) { }
>  #endif
>  
> +
>  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
>  extern void irqtime_account_irq(struct task_struct *tsk);
>  #else
>  static inline void irqtime_account_irq(struct task_struct *tsk) { }
>  #endif
>  
> -static inline void vtime_account_irq_enter(struct task_struct *tsk)
> +static inline void account_irq_enter_time(struct task_struct *tsk)
>  {
> -	/*
> -	 * Hardirq can interrupt idle task anytime. So we need vtime_account()
> -	 * that performs the idle check in CONFIG_VIRT_CPU_ACCOUNTING.
> -	 * Softirq can also interrupt idle task directly if it calls
> -	 * local_bh_enable(). Such case probably don't exist but we never know.
> -	 * Ksoftirqd is not concerned because idle time is flushed on context
> -	 * switch. Softirqs in the end of hardirqs are also not a problem because
> -	 * the idle time is flushed on hardirq time already.
> -	 */
> -	vtime_account(tsk);
> +	vtime_account_irq_enter(tsk);
>  	irqtime_account_irq(tsk);
>  }
>  
> -static inline void vtime_account_irq_exit(struct task_struct *tsk)
> +static inline void account_irq_exit_time(struct task_struct *tsk)
>  {
> -	/* On hard|softirq exit we always account to hard|softirq cputime */
> -	vtime_account_system(tsk);
> +	vtime_account_irq_exit(tsk);
>  	irqtime_account_irq(tsk);
>  }
>  
> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
> index ca1e073..bd2f2fc 100644
> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -56,7 +56,7 @@ void user_enter(void)
>  	local_irq_save(flags);
>  	if (__this_cpu_read(context_tracking.active) &&
>  	    __this_cpu_read(context_tracking.state) != IN_USER) {
> -		vtime_account_system(current);
> +		vtime_user_enter(current);
>  		/*
>  		 * At this stage, only low level arch entry code remains and
>  		 * then we'll run in userspace. We can assume there won't be
> diff --git a/kernel/fork.c b/kernel/fork.c
> index a81efb8..efafcba 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1224,6 +1224,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  #ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
>  	p->prev_cputime.utime = p->prev_cputime.stime = 0;
>  #endif
> +#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
> +	seqlock_init(&p->vtime_seqlock);
> +	p->prev_jiffies_whence = JIFFIES_SLEEPING; /*CHECKME: idle tasks? */
> +	p->prev_jiffies = jiffies;
> +#endif
> +
>  #if defined(SPLIT_RSS_COUNTING)
>  	memset(&p->rss_stat, 0, sizeof(p->rss_stat));
>  #endif
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index 0603671..3f25e60 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -484,7 +484,7 @@ void vtime_task_switch(struct task_struct *prev)
>   * vtime_account().
>   */
>  #ifndef __ARCH_HAS_VTIME_ACCOUNT
> -void vtime_account(struct task_struct *tsk)
> +void vtime_account_irq_enter(struct task_struct *tsk)
>  {
>  	if (!in_interrupt()) {
>  		/*
> @@ -505,7 +505,7 @@ void vtime_account(struct task_struct *tsk)
>  	}
>  	vtime_account_system(tsk);
>  }
> -EXPORT_SYMBOL_GPL(vtime_account);
> +EXPORT_SYMBOL_GPL(vtime_account_irq_enter);
>  #endif /* __ARCH_HAS_VTIME_ACCOUNT */
>  #endif /* CONFIG_VIRT_CPU_ACCOUNTING */
>  
> @@ -616,41 +616,67 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
>  #endif /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
>  
>  #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
> -static DEFINE_PER_CPU(long, last_jiffies) = INITIAL_JIFFIES;
> -
> -static cputime_t get_vtime_delta(void)
> +static cputime_t get_vtime_delta(struct task_struct *tsk)
>  {
>  	long delta;
>  
> -	delta = jiffies - __this_cpu_read(last_jiffies);
> -	__this_cpu_add(last_jiffies, delta);
> +	delta = jiffies - tsk->prev_jiffies;
> +	tsk->prev_jiffies += delta;
>  
>  	return jiffies_to_cputime(delta);
>  }
>  
> -void vtime_account_system(struct task_struct *tsk)
> +static void __vtime_account_system(struct task_struct *tsk)
>  {
> -	cputime_t delta_cpu = get_vtime_delta();
> +	cputime_t delta_cpu = get_vtime_delta(tsk);
>  
>  	account_system_time(tsk, irq_count(), delta_cpu, cputime_to_scaled(delta_cpu));
>  }
>  
> +void vtime_account_system(struct task_struct *tsk)
> +{
> +	write_seqlock(&tsk->vtime_seqlock);
> +	__vtime_account_system(tsk);
> +	write_sequnlock(&tsk->vtime_seqlock);
> +}
> +
> +void vtime_account_irq_exit(struct task_struct *tsk)
> +{
> +	write_seqlock(&tsk->vtime_seqlock);
> +	if (context_tracking_in_user())
> +		tsk->prev_jiffies_whence = JIFFIES_USER;
> +	__vtime_account_system(tsk);
> +	write_sequnlock(&tsk->vtime_seqlock);
> +}
> +
>  void vtime_account_user(struct task_struct *tsk)
>  {
> -	cputime_t delta_cpu = get_vtime_delta();
> +	cputime_t delta_cpu = get_vtime_delta(tsk);
>  
>  	/*
>  	 * This is an unfortunate hack: if we flush user time only on
>  	 * irq entry, we miss the jiffies update and the time is spuriously
>  	 * accounted to system time.
>  	 */
> -	if (context_tracking_in_user())
> +	if (context_tracking_in_user()) {
> +		write_seqlock(&tsk->vtime_seqlock);
> +		tsk->prev_jiffies_whence = JIFFIES_SYS;
>  		account_user_time(tsk, delta_cpu, cputime_to_scaled(delta_cpu));
> +		write_sequnlock(&tsk->vtime_seqlock);
> +	}
> +}
> +
> +void vtime_user_enter(struct task_struct *tsk)
> +{
> +	write_seqlock(&tsk->vtime_seqlock);
> +	tsk->prev_jiffies_whence = JIFFIES_USER;
> +	__vtime_account_system(tsk);
> +	write_sequnlock(&tsk->vtime_seqlock);
>  }
>  
>  void vtime_account_idle(struct task_struct *tsk)
>  {
> -	cputime_t delta_cpu = get_vtime_delta();
> +	cputime_t delta_cpu = get_vtime_delta(tsk);
>  
>  	account_idle_time(delta_cpu);
>  }
> @@ -660,31 +686,64 @@ bool vtime_accounting(void)
>  	return context_tracking_active();
>  }
>  
> -static int __cpuinit vtime_cpu_notify(struct notifier_block *self,
> -				      unsigned long action, void *hcpu)
> +void arch_vtime_task_switch(struct task_struct *prev)
>  {
> -	long cpu = (long)hcpu;
> -	long *last_jiffies_cpu = per_cpu_ptr(&last_jiffies, cpu);
> +	write_seqlock(&prev->vtime_seqlock);
> +	prev->prev_jiffies_whence = JIFFIES_SLEEPING;
> +	write_sequnlock(&prev->vtime_seqlock);
>  
> -	switch (action) {
> -	case CPU_UP_PREPARE:
> -	case CPU_UP_PREPARE_FROZEN:
> -		/*
> -		 * CHECKME: ensure that's visible by the CPU
> -		 * once it wakes up
> -		 */
> -		*last_jiffies_cpu = jiffies;
> -	default:
> -		break;
> -	}
> +	write_seqlock(&current->vtime_seqlock);
> +	current->prev_jiffies_whence = JIFFIES_SYS;
> +	current->prev_jiffies = jiffies;
> +	write_sequnlock(&current->vtime_seqlock);
> +}
> +
> +void task_cputime(struct task_struct *t, cputime_t *utime, cputime_t *stime)
> +{
> +	unsigned int seq;
> +	long delta;
> +
> +	do {
> +		seq = read_seqbegin(&t->vtime_seqlock);
> +
> +		*utime = t->utime;
> +		*stime = t->utime;
> +
> +		if (t->prev_jiffies_whence == JIFFIES_SLEEPING || 
> +		    is_idle_task(t))
> +			continue;
>  
> -	return NOTIFY_OK;
> +		delta = jiffies - t->prev_jiffies;
> +
> +		if (t->prev_jiffies_whence == JIFFIES_USER)
> +			*utime += delta;
> +		else if (t->prev_jiffies_whence == JIFFIES_SYS)
> +			*stime += delta;
> +	} while (read_seqretry(&t->vtime_seqlock, seq));
>  }
>  
> -static int __init init_vtime(void)
> +void task_cputime_scaled(struct task_struct *t,
> +			 cputime_t *utimescaled, cputime_t *stimescaled)
>  {
> -	cpu_notifier(vtime_cpu_notify, 0);
> -	return 0;
> +	unsigned int seq;
> +	long delta;
> +
> +	do {
> +		seq = read_seqbegin(&t->vtime_seqlock);
> +
> +		*utimescaled = t->utimescaled;
> +		*stimescaled = t->utimescaled;
> +
> +		if (t->prev_jiffies_whence == JIFFIES_SLEEPING || 
> +		    is_idle_task(t))
> +			continue;
> +
> +		delta = jiffies - t->prev_jiffies;
> +
> +		if (t->prev_jiffies_whence == JIFFIES_USER)
> +			*utimescaled += jiffies_to_scaled(delta);
> +		else if (t->prev_jiffies_whence == JIFFIES_SYS)
> +			*stimescaled += jiffies_to_scaled(delta);
> +	} while (read_seqretry(&t->vtime_seqlock, seq));
>  }
> -early_initcall(init_vtime);
>  #endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index ed567ba..f5cc25f 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -221,7 +221,7 @@ asmlinkage void __do_softirq(void)
>  	current->flags &= ~PF_MEMALLOC;
>  
>  	pending = local_softirq_pending();
> -	vtime_account_irq_enter(current);
> +	account_irq_enter_time(current);
>  
>  	__local_bh_disable((unsigned long)__builtin_return_address(0),
>  				SOFTIRQ_OFFSET);
> @@ -272,7 +272,7 @@ restart:
>  
>  	lockdep_softirq_exit();
>  
> -	vtime_account_irq_exit(current);
> +	account_irq_exit_time(current);
>  	__local_bh_enable(SOFTIRQ_OFFSET);
>  	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
>  }
> @@ -341,7 +341,7 @@ static inline void invoke_softirq(void)
>   */
>  void irq_exit(void)
>  {
> -	vtime_account_irq_exit(current);
> +	account_irq_exit_time(current);
>  	trace_hardirq_exit();
>  	sub_preempt_count(IRQ_EXIT_OFFSET);
>  	if (!in_interrupt() && local_softirq_pending())


