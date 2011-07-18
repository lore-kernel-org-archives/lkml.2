Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab1GRM2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 08:28:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261Ab1GRM2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 08:28:37 -0400
Date: Mon, 18 Jul 2011 08:28:20 -0400
From: Don Zickus <dzickus@redhat.com>
To: Alex Neronskiy <zakmagnus@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v2] Track hard and soft "short lockups" or "stalls."
Message-ID: <20110718122820.GB1808@redhat.com>
References: <1310760670-32232-1-git-send-email-zakmagnus@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310760670-32232-1-git-send-email-zakmagnus@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 01:11:10PM -0700, Alex Neronskiy wrote:
> Enable the lockup watchdog to not only respond to lockups beyond a
> certain threshold, but also keep track of the worst sub-threshold
> lockup (called a "stall") seen so far. The stalls are communicated
> to userspace via /proc/sys/kernel/worst_softstall
> and worst_hardstall, as well as through the kernel log, where a
> stack trace is also included. Hard lockups are checked for more
> frequently to collect additional data. Soft stalls are described
> by the length of time between successive instances of scheduling
> of the watchdog thread, and hard stalls are described by the
> number of times a hard lockup check found that no interrupts had
> been recorded. Some thresholds on these are set, to attempt to
> prevent floods of useless data.

I think this matches what I had in mind.  Though I keep wondering if there
is a simpler way to achieve this because this is only going to print in
the ints_missed = 3 and 4 cases.  But I can't, so I will do some testing
on my end to make sure it doesn't break some of the cases I deal with.

I think it will be fine though.

Thanks!

Cheers,
Don

> 
> Signed-off-by: Alex Neronskiy <zakmagnus@google.com>
> ---
> The motivation here is to be able to gather more data about just how
> "extreme" latency conditions get inside the kernel, without
> necessarily triggering a threshold and potentially setting off a
> panic.
> The way the hard lockup watchdog works has been changed to make it
> more compatible with this purpose. Previously it was hard to
> collect any data from it other than "lockup" or "not lockup."
> Now it has to fail 5 consecutive checks to be considered a lockup,
> somewhat similarly to how soft lockups work.
> 
>  include/linux/nmi.h |    6 ++-
>  kernel/sysctl.c     |   18 +++++++-
>  kernel/watchdog.c   |  122 +++++++++++++++++++++++++++++++++++++++++++-------
>  3 files changed, 127 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/nmi.h b/include/linux/nmi.h
> index 2d304ef..57cda21 100644
> --- a/include/linux/nmi.h
> +++ b/include/linux/nmi.h
> @@ -48,9 +48,13 @@ int hw_nmi_is_cpu_stuck(struct pt_regs *);
>  u64 hw_nmi_get_sample_period(int watchdog_thresh);
>  extern int watchdog_enabled;
>  extern int watchdog_thresh;
> +extern unsigned long worst_softstall;
> +#ifdef CONFIG_HARDLOCKUP_DETECTOR
> +extern unsigned long worst_hardstall;
> +#endif /* CONFIG_HARDLOCKUP_DETECTOR */
>  struct ctl_table;
>  extern int proc_dowatchdog(struct ctl_table *, int ,
>  			   void __user *, size_t *, loff_t *);
> -#endif
> +#endif /* CONFIG_LOCKUP_DETECTOR */
>  
>  #endif
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index f175d98..b52a4d5 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -767,7 +767,23 @@ static struct ctl_table kern_table[] = {
>  		.extra1		= &zero,
>  		.extra2		= &one,
>  	},
> -#endif
> +	{
> +		.procname       = "worst_softstall",
> +		.data           = &worst_softstall,
> +		.maxlen         = sizeof(unsigned long),
> +		.mode           = 0444,
> +		.proc_handler   = proc_doulongvec_minmax,
> +	},
> +#ifdef CONFIG_HARDLOCKUP_DETECTOR
> +	{
> +		.procname       = "worst_hardstall",
> +		.data           = &worst_hardstall,
> +		.maxlen         = sizeof(unsigned long),
> +		.mode           = 0444,
> +		.proc_handler   = proc_doulongvec_minmax,
> +	},
> +#endif /* CONFIG_HARDLOCKUP_DETECTOR */
> +#endif /* CONFIG_LOCKUP_DETECTOR */
>  #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
>  	{
>  		.procname       = "unknown_nmi_panic",
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 3d0c56a..7d37cc2 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -29,6 +29,8 @@
>  
>  int watchdog_enabled = 1;
>  int __read_mostly watchdog_thresh = 10;
> +unsigned long worst_softstall;
> +static DEFINE_SPINLOCK(softstall_lock);
>  
>  static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
>  static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
> @@ -40,8 +42,29 @@ static DEFINE_PER_CPU(bool, hard_watchdog_warn);
>  static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
>  static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
>  static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
> +static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_missed);
>  static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
> -#endif
> +
> +unsigned long worst_hardstall;
> +static DEFINE_SPINLOCK(hardstall_lock);
> +
> +/* The number of consecutive hard check failures before it's a lockup */
> +#define hardlockup_thresh (5)
> +
> +/*
> + * The minimum expected number of missed interrupts in a normal hard
> + * lockup check.
> + */
> +#define hardstall_thresh (2)
> +
> +#endif /* CONFIG_HARDLOCKUP_DETECTOR */
> +
> +/*
> + * The number of milliseconds by which a stall must be worse than the
> + * current worst in order to be recorded. This prevents bursts of near-
> + * identical stalls.
> + */
> +#define softstall_diff_thresh (100)
>  
>  /* boot commands */
>  /*
> @@ -98,19 +121,28 @@ __setup("nosoftlockup", nosoftlockup_setup);
>   * the thresholds with a factor: we make the soft threshold twice the amount of
>   * time the hard threshold is.
>   */
> -static int get_softlockup_thresh(void)
> +static inline int get_softlockup_thresh(void)
>  {
>  	return watchdog_thresh * 2;
>  }
>  
>  /*
> - * Returns seconds, approximately.  We don't need nanosecond
> + * This is just the period of the timer function. A "stall" shorter than
> + * this is the expected behavior and is therefore not noteworthy.
> + */
> +static inline int get_softstall_thresh(void)
> +{
> +	return 1000 / 5 * get_softlockup_thresh();
> +}
> +
> +/*
> + * Returns milliseconds, approximately.  We don't need nanosecond
>   * resolution, and we don't need to waste time with a big divide when
> - * 2^30ns == 1.074s.
> + * 2^20ns == 1.049ms.
>   */
>  static unsigned long get_timestamp(int this_cpu)
>  {
> -	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
> +	return cpu_clock(this_cpu) >> 20LL;  /* 2^20 ~= 10^6 */
>  }
>  
>  static unsigned long get_sample_period(void)
> @@ -176,25 +208,77 @@ void touch_softlockup_watchdog_sync(void)
>  
>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
>  /* watchdog detector functions */
> -static int is_hardlockup(void)
> +static void update_hardstall(unsigned long stall, int this_cpu)
> +{
> +	int update_stall = 0;
> +
> +	if (stall > hardstall_thresh && stall > worst_hardstall) {
> +		unsigned long flags;
> +		spin_lock_irqsave(&hardstall_lock, flags);
> +		update_stall = stall > worst_hardstall;
> +		if (update_stall)
> +			worst_hardstall = stall;
> +		spin_unlock_irqrestore(&hardstall_lock, flags);
> +	}
> +
> +	if (update_stall) {
> +		printk(KERN_WARNING "new worst hard stall seen on CPU#%d: %lu interrupts missed\n",
> +			this_cpu, stall);
> +		dump_stack();
> +	}
> +}
> +
> +static int is_hardlockup(int this_cpu)
>  {
>  	unsigned long hrint = __this_cpu_read(hrtimer_interrupts);
> +	unsigned long hrint_saved = __this_cpu_read(hrtimer_interrupts_saved);
> +	unsigned long ints_missed = 0;
> +
> +	__this_cpu_write(hrtimer_interrupts_saved, hrint);
>  
> -	if (__this_cpu_read(hrtimer_interrupts_saved) == hrint)
> +	if (hrint_saved == hrint)
> +		ints_missed = per_cpu(hrtimer_interrupts_missed, this_cpu)++;
> +	else
> +		__this_cpu_write(hrtimer_interrupts_missed, 0);
> +
> +	if (ints_missed >= hardlockup_thresh)
>  		return 1;
>  
> -	__this_cpu_write(hrtimer_interrupts_saved, hrint);
> +	update_hardstall(ints_missed, this_cpu);
>  	return 0;
>  }
>  #endif
>  
> -static int is_softlockup(unsigned long touch_ts)
> +static void update_softstall(unsigned long stall, int this_cpu)
>  {
> -	unsigned long now = get_timestamp(smp_processor_id());
> +	int update_stall = 0;
> +	if (stall > get_softstall_thresh() &&
> +			stall > worst_softstall + softstall_diff_thresh) {
> +		unsigned long flags;
> +		spin_lock_irqsave(&softstall_lock, flags);
> +		update_stall = stall > worst_softstall + softstall_diff_thresh;
> +		if (update_stall)
> +			worst_softstall = stall;
> +		spin_unlock_irqrestore(&softstall_lock, flags);
> +	}
> +
> +	if (update_stall) {
> +		printk(KERN_WARNING "new worst soft stall seen on CPU#%d: %lums\n",
> +				this_cpu, stall);
> +		dump_stack();
> +	}
> +}
> +
> +static int is_softlockup(unsigned long touch_ts, int this_cpu)
> +{
> +	unsigned long now = get_timestamp(this_cpu);
> +	unsigned long stall = now - touch_ts;
>  
>  	/* Warn about unreasonable delays: */
> -	if (time_after(now, touch_ts + get_softlockup_thresh()))
> -		return now - touch_ts;
> +	if (time_after(now, touch_ts + 1000 * get_softlockup_thresh()))
> +		return stall;
> +
> +	update_softstall(stall, this_cpu);
>  
>  	return 0;
>  }
> @@ -213,6 +297,9 @@ static void watchdog_overflow_callback(struct perf_event *event, int nmi,
>  		 struct perf_sample_data *data,
>  		 struct pt_regs *regs)
>  {
> +	int lockup;
> +	int this_cpu = smp_processor_id();
> +
>  	/* Ensure the watchdog never gets throttled */
>  	event->hw.interrupts = 0;
>  
> @@ -227,9 +314,8 @@ static void watchdog_overflow_callback(struct perf_event *event, int nmi,
>  	 * fired multiple times before we overflow'd.  If it hasn't
>  	 * then this is a good indication the cpu is stuck
>  	 */
> -	if (is_hardlockup()) {
> -		int this_cpu = smp_processor_id();
> -
> +	lockup = is_hardlockup(this_cpu);
> +	if (lockup) {
>  		/* only print hardlockups once */
>  		if (__this_cpu_read(hard_watchdog_warn) == true)
>  			return;
> @@ -260,6 +346,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  	unsigned long touch_ts = __this_cpu_read(watchdog_touch_ts);
>  	struct pt_regs *regs = get_irq_regs();
>  	int duration;
> +	int this_cpu = smp_processor_id();
>  
>  	/* kick the hardlockup detector */
>  	watchdog_interrupt_count();
> @@ -289,14 +376,14 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  	 * indicate it is getting cpu time.  If it hasn't then
>  	 * this is a good indication some task is hogging the cpu
>  	 */
> -	duration = is_softlockup(touch_ts);
> +	duration = is_softlockup(touch_ts, this_cpu);
>  	if (unlikely(duration)) {
>  		/* only warn once */
>  		if (__this_cpu_read(soft_watchdog_warn) == true)
>  			return HRTIMER_RESTART;
>  
>  		printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
> -			smp_processor_id(), duration,
> +			this_cpu, duration >> 10L,
>  			current->comm, task_pid_nr(current));
>  		print_modules();
>  		print_irqtrace_events(current);
> @@ -371,6 +458,7 @@ static int watchdog_nmi_enable(int cpu)
>  	/* Try to register using hardware perf events */
>  	wd_attr = &wd_hw_attr;
>  	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
> +	do_div(wd_attr->sample_period, hardlockup_thresh);
>  	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback);
>  	if (!IS_ERR(event)) {
>  		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
> -- 
> 1.7.3.1
> 
