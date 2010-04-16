Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab0DPBrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 21:47:18 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:50112 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758185Ab0DPBrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 21:47:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iBrsCeaOgt/ACoTrI0+vDzcw0dKtJnYj5YYCX98KzW0pKH31IN106Hl9SYWauqbPMc
         dyRVDoP5xHW34KwxmwTmVrjxftl4FpryQ0Zj+XFhMQB6Le6t+jtq2GPS4XBqnh7oLyZX
         fIoouJ8FXn1QbpWYLnIgZTYIKiRBWiPLKsl28=
Date: Fri, 16 Apr 2010 03:47:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100416014712.GC15570@nowhere>
References: <1271366710-17468-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271366710-17468-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 05:25:10PM -0400, Don Zickus wrote:
> The new nmi_watchdog (which uses the perf event subsystem) is very
> similar in structure to the softlockup detector.  Using Ingo's suggestion,
> I combined the two functionalities into one file, kernel/watchdog.c.
> 
> Now both the nmi_watchdog (or hardlockup detector) and softlockup detector
> sit on top of the perf event subsystem, which is run every 60 seconds or so
> to see if there are any lockups.
> 
> To detect hardlockups, cpus not responding to interrupts, I implemented an
> hrtimer that runs 5 times for every perf event overflow event.  If that stops
> counting on a cpu, then the cpu is most likely in trouble.
> 
> To detect softlockups, tasks not yielding to the scheduler, I used the
> previous kthread idea that now gets kicked every time the hrtimer fires.
> If the kthread isn't being scheduled neither is anyone else and the
> warning is printed to the console.
> 
> I tested this on x86_64 and both the softlockup and hardlockup paths work.
> 
> V2:
> - cleaned up the Kconfig and softlockup combination
> - surrounded hardlockup cases with #ifdef CONFIG_PERF_EVENTS_NMI
> - seperated out the softlockup case from perf event subsystem
> - re-arranged the enabling/disabling nmi watchdog from proc space
> - added cpumasks for hardlockup failure cases
> - removed fallback to soft events if no PMU exists for hard events
> 
> TODO:
> - figure out how to make an arch-agnostic clock2cycles call (if possible)
>   to feed into perf events as a sample period



In fact we also have the sample_freq thing that let you run
against a frequency (events per sec) rather than a sample
period.

We do some calculations that recompute the actual sample
period on top of this frequency in a regular base as the
events come.

It's rather unfortunate we can't have 0.xxxx frequencies
but may be we can work that out by adding a freq_unscale
field, which would basically produce the frequency like
this:

	freq = event->attr.sample_freq * (10 ^ -event->attr.freq_unscale)

This is not trivial though, so let's rather focus on the
real matter for now :)


> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
> index e8b78a0..79425f9 100644
> --- a/arch/x86/kernel/apic/hw_nmi.c
> +++ b/arch/x86/kernel/apic/hw_nmi.c
> @@ -89,7 +89,7 @@ int hw_nmi_is_cpu_stuck(struct pt_regs *regs)
>  
>  u64 hw_nmi_get_sample_period(void)
>  {
> -	return cpu_khz * 1000;
> +	return (u64)(cpu_khz) * 1000 * 60;
>  }
>  
>  #ifdef ARCH_HAS_NMI_WATCHDOG
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 6f7bba9..83be6d7 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -338,6 +338,12 @@ extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
>  					 size_t *lenp, loff_t *ppos);
>  #endif
>  
> +#ifdef CONFIG_NMI_WATCHDOG
> +extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
> +				  void __user *buffer,
> +				  size_t *lenp, loff_t *ppos);
> +#endif
> +
>  /* Attach to any functions which should be ignored in wchan output. */
>  #define __sched		__attribute__((__section__(".sched.text")))
>  
> diff --git a/init/Kconfig b/init/Kconfig
> index 7331a16..0b83612 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -948,6 +948,7 @@ config PERF_USE_VMALLOC
>  
>  config PERF_EVENTS_NMI
>  	bool
> +	depends on PERF_EVENTS
>  	help
>  	  Arch has support for nmi_watchdog



That looks too general. It's more about the fact the arch supports
cpu cycle events and generates NMIs on overflow.


  
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 8a5abe5..56ba99d 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -75,9 +75,11 @@ obj-$(CONFIG_GCOV_KERNEL) += gcov/
>  obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
>  obj-$(CONFIG_KPROBES) += kprobes.o
>  obj-$(CONFIG_KGDB) += kgdb.o
> +ifneq ($(CONFIG_NMI_WATCHDOG),y)
>  obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
> -obj-$(CONFIG_NMI_WATCHDOG) += nmi_watchdog.o
> +endif



I'm confused, do we have two versions of the softlockup
detector now? You should drop the older one.



>  obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
> +obj-$(CONFIG_NMI_WATCHDOG) += watchdog.o
>  obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
>  obj-$(CONFIG_SECCOMP) += seccomp.o
>  obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index ac72c9e..2165b22 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -704,6 +704,15 @@ static struct ctl_table kern_table[] = {
>  		.mode           = 0644,
>  		.proc_handler   = proc_nmi_enabled,
>  	},
> +	{
> +		.procname	= "watchdog_thresh",
> +		.data		= &softlockup_thresh,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dowatchdog_thresh,
> +		.extra1		= &neg_one,
> +		.extra2		= &sixty,
> +	},
>  #endif
>  #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86) && !defined(CONFIG_NMI_WATCHDOG)
>  	{
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> new file mode 100644
> index 0000000..fad5b1a
> --- /dev/null
> +++ b/kernel/watchdog.c
> @@ -0,0 +1,570 @@
> +/*
> + * Detect Hard/Soft Lockups using the NMI



Well, softlockups detection doesn't use NMI.



> +/*
> + * Returns seconds, approximately.  We don't need nanosecond
> + * resolution, and we don't need to waste time with a big divide when
> + * 2^30ns == 1.074s.
> + */
> +static unsigned long get_timestamp(int this_cpu)
> +{
> +	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
> +}
> +
> +static unsigned long get_sample_period(void)
> +{
> +	/*
> +	 * convert softlockup_thresh from seconds to ns
> +	 * the divide by 5 is to give hrtimer 5 chances to
> +	 * increment before the hardlockup detector generates
> +	 * a warning
> +	 */
> +	return softlockup_thresh / 5 * NSEC_PER_SEC;
> +}
> +
> +/* Commands for resetting the watchdog */
> +static void __touch_watchdog(void)
> +{
> +	int this_cpu = raw_smp_processor_id();
> +
> +	__raw_get_cpu_var(watchdog_touch_ts) = get_timestamp(this_cpu);



Please use __get_cpu_var() instead so that we keep the preempt disabled
check from smp_processor_id()



> +}
> +
> +void touch_watchdog(void)
> +{
> +	__raw_get_cpu_var(watchdog_touch_ts) = 0;


Same here.



> +}
> +EXPORT_SYMBOL(touch_watchdog);
> +
> +void touch_all_watchdog(void)
> +{
> +	int cpu;
> +
> +	for_each_online_cpu(cpu)
> +		per_cpu(watchdog_touch_ts, cpu) = 0;
> +}
> +
> +/* deprecated functions */
> +void touch_nmi_watchdog(void)
> +{
> +	touch_watchdog();
> +}
> +EXPORT_SYMBOL(touch_nmi_watchdog);
> +
> +void touch_all_nmi_watchdog(void)
> +{
> +	touch_all_watchdog();
> +}
> +
> +void touch_softlockup_watchdog(void)
> +{
> +	touch_watchdog();
> +}
> +
> +void touch_all_softlockup_watchdogs(void)
> +{
> +	touch_all_watchdog();
> +}
> +
> +void softlockup_tick(void)
> +{
> +}
> +/* end of deprecated functions */



You should replace the call sites directly.



> +#ifdef CONFIG_PERF_EVENTS_NMI
> +/* watchdog detector functions */
> +static int is_hardlockup(int cpu)
> +{
> +	unsigned long hrint = per_cpu(hrtimer_interrupts, cpu);
> +
> +	if (per_cpu(hrtimer_interrupts_saved, cpu) == hrint)
> +		return 1;
> +
> +	per_cpu(hrtimer_interrupts_saved, cpu) = hrint;
> +	return 0;
> +}
> +#endif
> +
> +static int is_softlockup(unsigned long touch_ts, int cpu)
> +{
> +	unsigned long now = get_timestamp(cpu);
> +
> +	/* Warn about unreasonable delays: */
> +	if (now > (touch_ts + softlockup_thresh))
> +		return now - touch_ts;
> +
> +	return 0;
> +}
> +
> +static int
> +watchdog_panic(struct notifier_block *this, unsigned long event, void *ptr)
> +{
> +	did_panic = 1;
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block panic_block = {
> +	.notifier_call = watchdog_panic,
> +};
> +
> +#ifdef CONFIG_PERF_EVENTS_NMI
> +struct perf_event_attr wd_hw_attr = {
> +	.type		= PERF_TYPE_HARDWARE,
> +	.config		= PERF_COUNT_HW_CPU_CYCLES,
> +	.size		= sizeof(struct perf_event_attr),
> +	.pinned		= 1,
> +	.disabled	= 1,
> +};
> +
> +struct perf_event_attr wd_sw_attr = {
> +	.type		= PERF_TYPE_SOFTWARE,
> +	.config		= PERF_COUNT_SW_CPU_CLOCK,
> +	.size		= sizeof(struct perf_event_attr),
> +	.pinned		= 1,
> +	.disabled	= 1,
> +};




Why do you keep the software clock, I don't see how it can be
useful to detect hardlockups. It triggers in a regular irq
not an NMI.



> +
> +/* Callback function for perf event subsystem */
> +void watchdog_overflow_callback(struct perf_event *event, int nmi,
> +		 struct perf_sample_data *data,
> +		 struct pt_regs *regs)
> +{
> +	int this_cpu = smp_processor_id();
> +	unsigned long touch_ts = per_cpu(watchdog_touch_ts, this_cpu);
> +
> +	if (touch_ts == 0) {
> +		__touch_watchdog();
> +		return;
> +	}
> +
> +	/* check for a hardlockup
> +	 * This is done by making sure our timer interrupt
> +	 * is incrementing.  The timer interrupt should have
> +	 * fired multiple times before we overflow'd.  If it hasn't
> +	 * then this is a good indication the cpu is stuck
> +	 */
> +	if (is_hardlockup(this_cpu)) {
> +		/* only print hardlockups once */
> +		if (cpumask_test_cpu(this_cpu, to_cpumask(hardlockup_mask)))
> +			return;
> +
> +		if (hardlockup_panic)
> +			panic("Watchdog detected hard LOCKUP on cpu %d", this_cpu);
> +		else
> +			WARN(1, "Watchdog detected hard LOCKUP on cpu %d", this_cpu);
> +
> +		cpumask_set_cpu(this_cpu, to_cpumask(hardlockup_mask));



May be have an arch spin lock there to update your cpu mask safely.



> +		return;
> +	}
> +
> +	cpumask_clear_cpu(this_cpu, to_cpumask(hardlockup_mask));



Hmm...this is probably not necessary.



> +	return;
> +}
> +#endif /* CONFIG_PERF_EVENTS_NMI */
> +
> +/* watchdog kicker functions */
> +static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
> +{
> +	int this_cpu = smp_processor_id();
> +	unsigned long touch_ts = per_cpu(watchdog_touch_ts, this_cpu);
> +	struct pt_regs *regs = get_irq_regs();
> +	int duration;
> +
> +#ifdef CONFIG_PERF_EVENTS_NMI
> +	/* kick the hardlockup detector */
> +	__get_cpu_var(hrtimer_interrupts)++;
> +#endif



Please avoid such ifdefs in the middle of the code.

It's better to gather hardlockup matters in a single ifdef block:

#ifdef CONFIG_PERF_EVENTS_NMI
define your functions here
#else
define (if needed) your off case functions here (static inline stubs)
#endif



> +
> +	/* kick the softlockup detector */
> +	wake_up_process(__get_cpu_var(softlockup_watchdog));
> +
> +	/* .. and repeat */
> +	hrtimer_forward_now(hrtimer, ns_to_ktime(get_sample_period()));
> +
> +	if (touch_ts == 0) {
> +		__touch_watchdog();
> +		return HRTIMER_RESTART;
> +	}
> +
> +	/* check for a softlockup
> +	 * This is done by making sure a high priority task is
> +	 * being scheduled.  The task touches the watchdog to
> +	 * indicate it is getting cpu time.  If it hasn't then
> +	 * this is a good indication some task is hogging the cpu
> +	 */
> +	duration = is_softlockup(touch_ts, this_cpu);
> +	if (duration) {
> +		printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
> +			this_cpu, duration,
> +			current->comm, task_pid_nr(current));
> +		print_modules();
> +		print_irqtrace_events(current);
> +		if (regs)
> +			show_regs(regs);
> +		else
> +			dump_stack();
> +
> +		if (softlockup_panic)
> +			panic("softlockup: hung tasks");



You probably want a backtrace cpu mask here as well
(but better don't use the same than the hardlockup thing)



> +	}
> +
> +	return HRTIMER_RESTART;
> +}
> +
> +
> +/*
> + * The watchdog thread - touches the timestamp.
> + */
> +static int watchdog(void *__bind_cpu)
> +{
> +	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
> +	struct hrtimer *hrtimer = &per_cpu(watchdog_hrtimer, (unsigned long)__bind_cpu);
> +
> +	sched_setscheduler(current, SCHED_FIFO, &param);
> +
> +	/* initialize timestamp */
> +	__touch_watchdog();
> +
> +	/* kick off the timer for the hardlockup detector */
> +	/* done here because hrtimer_start can only pin to smp_processor_id() */
> +	hrtimer_start(hrtimer, ns_to_ktime(get_sample_period()),
> +		      HRTIMER_MODE_REL_PINNED);
> +
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	/*
> +	 * Run briefly once per second to reset the softlockup timestamp.
> +	 * If this gets delayed for more than 60 seconds then the
> +	 * debug-printout triggers in softlockup_tick().
> +	 */
> +	while (!kthread_should_stop()) {
> +		__touch_watchdog();
> +		schedule();
> +
> +		if (kthread_should_stop())
> +			break;
> +
> +		set_current_state(TASK_INTERRUPTIBLE);
> +	}
> +	__set_current_state(TASK_RUNNING);
> +
> +	return 0;
> +}
> +
> +
> +/* prepare/enable/disable routines */
> +static int watchdog_prepare_cpu(int cpu)
> +{
> +	struct hrtimer *hrtimer = &per_cpu(watchdog_hrtimer, cpu);
> +
> +	BUG_ON(per_cpu(softlockup_watchdog, cpu));



Please warn here instead, nothing seriously dangerous is going to
happen.



> +	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	hrtimer->function = watchdog_timer_fn;
> +
> +	return 0;
> +}
> +
> +static int watchdog_enable(int cpu)
> +{
> +	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
> +#ifdef CONFIG_PERF_EVENTS_NMI
> +	struct perf_event_attr *wd_attr;
> +	struct perf_event *event = per_cpu(watchdog_ev, cpu);
> +
> +	/* is it already setup and enabled? */
> +	if (event && event->state > PERF_EVENT_STATE_OFF)
> +		goto out;
> +
> +	/* it is setup but not enabled */
> +	if (event != NULL)
> +		goto out_enable;
> +
> +	/* Try to register using hardware perf events */
> +	wd_attr = &wd_hw_attr;
> +	wd_attr->sample_period = hw_nmi_get_sample_period();
> +	event = perf_event_create_kernel_counter(wd_attr, cpu, -1, watchdog_overflow_callback);
> +	if (!IS_ERR(event)) {
> +		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
> +		goto out_save;
> +	}
> +
> +	printk(KERN_ERR "NMI watchdog failed to create perf event on cpu%i: %p\n", cpu, event);
> +	return -1;
> +
> +	/* success path */
> +out_save:
> +	per_cpu(watchdog_ev, cpu) = event;
> +out_enable:
> +	perf_event_enable(per_cpu(watchdog_ev, cpu));
> +out:
> +#endif /* CONFIG_PERF_EVENTS_NMI */



Especially such kind of idef in a function plus goto in the middle, we really
want to avoid that.

You want a watchdog_nmi_enable() call instead that does nothing
if !CONFIG_PERF_EVENTS_NMI.



> +
> +	/* create the watchdog thread */
> +	if (!p) {
> +		p = kthread_create(watchdog, (void *)(unsigned long)cpu, "watchdog/%d", cpu);
> +		if (IS_ERR(p)) {
> +			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
> +			return -1;
> +		}
> +		kthread_bind(p, cpu);
> +		per_cpu(watchdog_touch_ts, cpu) = 0;
> +		per_cpu(softlockup_watchdog, cpu) = p;
> +		wake_up_process(p);
> +	}
> +
> +	return 0;
> +}
> +
> +static void watchdog_disable(int cpu)
> +{
> +	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
> +	struct hrtimer *hrtimer = &per_cpu(watchdog_hrtimer, cpu);
> +#ifdef CONFIG_PERF_EVENTS_NMI
> +	struct perf_event *event = per_cpu(watchdog_ev, cpu);
> +#endif
> +
> +	/*
> +	 * cancel the timer first to stop incrementing the stats
> +	 * and waking up the kthread
> +	 */
> +	hrtimer_cancel(hrtimer);
> +
> +#ifdef CONFIG_PERF_EVENTS_NMI
> +	if (event) {
> +		perf_event_disable(event);
> +		per_cpu(watchdog_ev, cpu) = NULL;
> +
> +		/* should be in cleanup, but blocks oprofile */
> +		perf_event_release_kernel(event);
> +	}
> +#endif
> +
> +	if (p) {
> +		per_cpu(softlockup_watchdog, cpu) = NULL;
> +		kthread_stop(p);
> +	}
> +
> +	/* if any cpu succeeds, watchdog is considered enabled for the system */
> +	nmi_watchdog_enabled = 1;
> +}
> +
> +static void watchdog_cleanup(int cpu)
> +{
> +
> +}
> +
> +static void watchdog_enable_all_cpus(void)
> +{
> +	int cpu;
> +	int result;
> +
> +	for_each_online_cpu(cpu)
> +		result += watchdog_enable(cpu);
> +
> +	if (result)
> +		printk(KERN_ERR "watchdog: failed to be enabled on some cpus\n");
> +
> +}
> +
> +static void watchdog_disable_all_cpus(void)
> +{
> +	int cpu;
> +
> +	for_each_online_cpu(cpu)
> +		watchdog_disable(cpu);
> +
> +	/* if all watchdogs are disabled, then they are disabled for the system */
> +	nmi_watchdog_enabled = 0;
> +}
> +
> +
> +/* sysctl functions */
> +#ifdef CONFIG_SYSCTL
> +/*
> + * proc handler for /proc/sys/kernel/nmi_watchdog
> + */
> +
> +int proc_nmi_enabled(struct ctl_table *table, int write,
> +		     void __user *buffer, size_t *length, loff_t *ppos)
> +{
> +	touch_all_watchdog();



Why do you need to touch watchdogs here?



> +	proc_dointvec(table, write, buffer, length, ppos);
> +
> +	if (nmi_watchdog_enabled)
> +		watchdog_enable_all_cpus();
> +	else
> +		watchdog_disable_all_cpus();
> +	return 0;
> +}
> +
> +int proc_dowatchdog_thresh(struct ctl_table *table, int write,
> +			     void __user *buffer,
> +			     size_t *lenp, loff_t *ppos)
> +{
> +	touch_all_watchdog();



Same here?


> +	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
> +}
> +
> +/* stub functions */
> +int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
> +			     void __user *buffer,
> +			     size_t *lenp, loff_t *ppos)
> +{
> +	return proc_dowatchdog_thresh(table, write, buffer, lenp, ppos);
> +}
> +/* end of stub functions */
> +#endif /* CONFIG_SYSCTL */
> +
> +
> +/*
> + * Create/destroy watchdog threads as CPUs come and go:
> + */
> +static int __cpuinit
> +cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
> +{
> +	int hotcpu = (unsigned long)hcpu;
> +
> +	switch (action) {
> +	case CPU_UP_PREPARE:
> +	case CPU_UP_PREPARE_FROZEN:
> +		if (watchdog_prepare_cpu(hotcpu))
> +			return NOTIFY_BAD;
> +		break;
> +	case CPU_ONLINE:
> +	case CPU_ONLINE_FROZEN:
> +		if (watchdog_enable(hotcpu))
> +			return NOTIFY_BAD;
> +		break;
> +#ifdef CONFIG_HOTPLUG_CPU
> +	case CPU_UP_CANCELED:
> +	case CPU_UP_CANCELED_FROZEN:
> +		watchdog_disable(hotcpu);
> +		break;
> +	case CPU_DEAD:
> +	case CPU_DEAD_FROZEN:
> +		watchdog_disable(hotcpu);
> +		watchdog_cleanup(hotcpu);
> +		break;
> +#endif /* CONFIG_HOTPLUG_CPU */
> +	}
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block __cpuinitdata cpu_nfb = {
> +	.notifier_call = cpu_callback
> +};
> +
> +static int __init spawn_watchdog_task(void)
> +{
> +	void *cpu = (void *)(long)smp_processor_id();
> +	int err;
> +
> +	if (no_watchdog)
> +		return 0;
> +
> +	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
> +	if (err == NOTIFY_BAD) {
> +		BUG();



Please warn instead, there is nothing fatal here.



> +		return 1;
> +	}
> +	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
> +	register_cpu_notifier(&cpu_nfb);
> +
> +	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
> +
> +	return 0;
> +}
> +early_initcall(spawn_watchdog_task);
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index e2e73cc..280794a 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -171,15 +171,24 @@ config DETECT_SOFTLOCKUP
>  	   support it.)
>  
>  config NMI_WATCHDOG
> -	bool "Detect Hard Lockups with an NMI Watchdog"
> -	depends on DEBUG_KERNEL && PERF_EVENTS && PERF_EVENTS_NMI
> +	bool "Detect Hard and Soft Lockups"
> +	depends on DEBUG_KERNEL
> +	default DETECT_SOFTLOCKUP



I'd suggest to drop the NMI prefix, this is not anymore
about detecting hard lockups only.

May be config WATCHDOG or config LOCKUP_DETECTOR if it's taken
already.


Also you should half-drop the DETECT_SOFTLOCKUP thing:
keep it's definition but drop the ability to choose it from
the prompt:

config DETECT_SOFTLOCKUP
	bool
	depends on DEBUG_KERNEL && !S390
	default y

This way we keep it for compatibility with def_configs, it will
enable the WATCHDOG by default if it is "y", we can schedule
its removal later.


Thanks.

