Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab1GMNnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:43:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab1GMNnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:43:51 -0400
Date: Wed, 13 Jul 2011 09:43:36 -0400
From: Don Zickus <dzickus@redhat.com>
To: Alex Neronskiy <zakmagnus@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH] Track hard and soft "short lockups" or "stalls."
Message-ID: <20110713134336.GK2938@redhat.com>
References: <1310510811-12564-1-git-send-email-zakmagnus@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310510811-12564-1-git-send-email-zakmagnus@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 03:46:51PM -0700, Alex Neronskiy wrote:
> Enable the lockup watchdog to not only respond to lockups beyond a
> certain threshold, but also keep track of the worst sub-threshold
> lockup (called a "stall") seen so far. The stalls are communicated
> to userspace via /proc/sys/kernel/worst_softstall
> and worst_hardstall, as well as through the kernel log, where a
> stack trace is also included. Soft stalls are described by the length
> of time between successive instances of scheduling of the watchdog
> thread, and hard stalls are described by the number of interrupts
> recorded between successive perf event overflows. Some thresholds
> on these are set to attempt to prevent floods of useless data.
> Based on 3.0-rc7.

I like the idea of this patch.  It definitely helps with better statistics
when trying to set the appropriate values for a soft/hard lockup as
opposed to pulling numbers from the air.

> 
> Change-Id: I6db8432fd81ad5a2b40867699709c22c25165ba0
> ---
> The motivation here is to be able to gather more data about just how
> "extreme" latency conditions get inside the kernel, without
> necessarily triggering a threshold and potentially setting off a
> panic.
> The hardstall_thresh looks magical. Assuming no time is spent halted,
> there is time for watchdog_thresh / (2 * watchdog_thresh / 5) = 2.5
> interrupts in between the hard lockup checks. So, if only 2 of them
> happen, it doesn't indicate that anything is wrong with the system.
> I wasn't sure how to express the above programmatically, since in
> the code it would be a mixture of timings and cycle counts, plus
> various assumptions, so I just hardcoded it...

I understand what you are trying to do, but I am not sure this way is the
right way.  Most people I talk with want to shrink the time from 10
seconds to something like 2 seconds with the idea that a system shouldn't
have interrupts disabled for more than 2 seconds without knowing it and
calling touch_watchdog().  But because there is so many false positives it
is just safer to keep it at 10 seconds.

I am not sure your algorithm accomplishes that by checking to see if only
one interrupt happened over the 10 second period.  Then again I would be
curious if your testing uncovered anything.

It seems we would want to start the hardlockup sample period at a minimum
watermark that would trigger possible stalls and declare a hardlockup at
some maximum watermark.  But I am not sure how to properly increment it
such that we don't get repeated stalls or if that is even the right
approach.

I don't think I have problems with the softlockup approach other than a
couple of nitpicks below.

> 
>  include/linux/nmi.h |    6 ++-
>  kernel/sysctl.c     |   18 ++++++++-
>  kernel/watchdog.c   |  108 +++++++++++++++++++++++++++++++++++++++++++--------
>  3 files changed, 114 insertions(+), 18 deletions(-)
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
> index 3d0c56a..5f44130 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -29,6 +29,9 @@
>  
>  int watchdog_enabled = 1;
>  int __read_mostly watchdog_thresh = 10;
> +unsigned long worst_softstall;
> +static int softstall_cpu;
> +static DEFINE_SPINLOCK(softstall_lock);
>  
>  static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
>  static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
> @@ -41,7 +44,24 @@ static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
>  static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
>  static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
>  static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
> -#endif
> +
> +unsigned long worst_hardstall;
> +static int hardstall_cpu;
> +static DEFINE_SPINLOCK(hardstall_lock);
> +
> +/*
> + * The minimum expected number of saved interrupts in one hard
> + * lockup check period.
> + */
> +#define hardstall_thresh (2)
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
> @@ -98,19 +118,28 @@ __setup("nosoftlockup", nosoftlockup_setup);
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
> @@ -176,11 +205,31 @@ void touch_softlockup_watchdog_sync(void)
>  
>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
>  /* watchdog detector functions */
> -static int is_hardlockup(void)
> +static int is_hardlockup(int this_cpu)
>  {
>  	unsigned long hrint = __this_cpu_read(hrtimer_interrupts);
> +	unsigned long hrint_saved = __this_cpu_read(hrtimer_interrupts_saved);
>  
> -	if (__this_cpu_read(hrtimer_interrupts_saved) == hrint)
> +	unsigned long stall = hrint - hrint_saved;
> +
> +	/*
> +	 * Stalls of 0 are actually bites, and will be reported
> +	 * anyway. No need to make note of them here.
> +	 * worst_hardstall==0 means no stalls recorded thus far.
> +	 */
> +	if (stall < hardstall_thresh &&
> +			((!worst_hardstall) ||
> +			 (stall && stall < worst_hardstall))) {
> +		unsigned long flags;
> +		spin_lock_irqsave(&hardstall_lock, flags);
> +		if ((!worst_hardstall) || (stall && stall < worst_hardstall)) {
> +			worst_hardstall = stall;
> +			hardstall_cpu = this_cpu;
> +		}
> +		spin_unlock_irqrestore(&hardstall_lock, flags);
> +	}
> +
> +	if (hrint_saved == hrint)
>  		return 1;
>  
>  	__this_cpu_write(hrtimer_interrupts_saved, hrint);
> @@ -188,12 +237,24 @@ static int is_hardlockup(void)
>  }
>  #endif
>  
> -static int is_softlockup(unsigned long touch_ts)
> +static int is_softlockup(unsigned long touch_ts, int this_cpu)
>  {
> -	unsigned long now = get_timestamp(smp_processor_id());
> +	unsigned long now = get_timestamp(this_cpu);
> +	unsigned long stall = now - touch_ts;
> +
> +	if (stall > get_softstall_thresh() &&
> +			stall > worst_softstall + softstall_diff_thresh) {
> +		unsigned long flags;
> +		spin_lock_irqsave(&softstall_lock, flags);
> +		if (stall > worst_softstall + softstall_diff_thresh) {
> +			worst_softstall = stall;
> +			softstall_cpu = this_cpu;
> +		}
> +		spin_unlock_irqrestore(&softstall_lock, flags);
> +	}
>  
>  	/* Warn about unreasonable delays: */
> -	if (time_after(now, touch_ts + get_softlockup_thresh()))
> +	if (time_after(now, touch_ts + 1000 * get_softlockup_thresh()))
>  		return now - touch_ts;
Should this chunk be moved above the 'stall' stuff otherwise you would
wind up with two stack traces, one for the new 'worse_stall' and the
actual softlockup.  Then again the actual softlockup is technically your
new worse_stall.

>  
>  	return 0;
> @@ -213,6 +274,10 @@ static void watchdog_overflow_callback(struct perf_event *event, int nmi,
>  		 struct perf_sample_data *data,
>  		 struct pt_regs *regs)
>  {
> +	unsigned long old_stall = worst_hardstall;
> +	int lockup;
> +	int this_cpu = smp_processor_id();
> +
>  	/* Ensure the watchdog never gets throttled */
>  	event->hw.interrupts = 0;
>  
> @@ -227,9 +292,13 @@ static void watchdog_overflow_callback(struct perf_event *event, int nmi,
>  	 * fired multiple times before we overflow'd.  If it hasn't
>  	 * then this is a good indication the cpu is stuck
>  	 */
> -	if (is_hardlockup()) {
> -		int this_cpu = smp_processor_id();
> -
> +	lockup = is_hardlockup(this_cpu);
> +	if (this_cpu == hardstall_cpu && worst_hardstall != old_stall) {
> +		printk(KERN_WARNING "new worst hard stall seen on CPU#%d: %lu interrupts recorded\n",
> +			this_cpu, worst_hardstall);
> +		dump_stack();
> +	}
> +	if (lockup) {
>  		/* only print hardlockups once */
>  		if (__this_cpu_read(hard_watchdog_warn) == true)
>  			return;
> @@ -259,7 +328,9 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  {
>  	unsigned long touch_ts = __this_cpu_read(watchdog_touch_ts);
>  	struct pt_regs *regs = get_irq_regs();
> +	unsigned long old_stall = worst_softstall;
>  	int duration;
> +	int this_cpu = smp_processor_id();
>  
>  	/* kick the hardlockup detector */
>  	watchdog_interrupt_count();
> @@ -289,14 +360,19 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  	 * indicate it is getting cpu time.  If it hasn't then
>  	 * this is a good indication some task is hogging the cpu
>  	 */
> -	duration = is_softlockup(touch_ts);
> +	duration = is_softlockup(touch_ts, this_cpu);
> +	if (this_cpu == softstall_cpu && old_stall != worst_softstall) {
> +		printk(KERN_WARNING "new worst soft stall seen on CPU#%d: %lums\n",
> +			this_cpu, worst_softstall);
> +		dump_stack();
> +	}

I was a little worried about this, you write to softstall_cpu and
worst_softstall with the spinlock protected but you read them without
spinlocks.  This is always the possibility that another cpu might
overwrite those variables while you are reading them.

Would it make sense to put this printk inside the is_softlockup() code and
just use the local variables to print this info out?

>  	if (unlikely(duration)) {
>  		/* only warn once */
>  		if (__this_cpu_read(soft_watchdog_warn) == true)
>  			return HRTIMER_RESTART;
>  
> -		printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
> -			smp_processor_id(), duration,
> +		printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %ums! [%s:%d]\n",
> +			this_cpu, duration,

Was wondering if the change to ms would confuse end users.  Perhaps we
should just keep seconds and divide duration by a 1000?

>  			current->comm, task_pid_nr(current));
>  		print_modules();
>  		print_irqtrace_events(current);

Cheers,
Don
