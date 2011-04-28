Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab1D1HPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 03:15:36 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:36121 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab1D1HPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 03:15:35 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [RFC][PATCH 1/4] clock_rtoffset: new syscall
In-Reply-To: <alpine.LFD.2.02.1104271359580.3323@ionos>
References: <alpine.LFD.2.00.1103102040190.2787@localhost6.localdomain6> <1303901023-11568-1-git-send-email-virtuoso@slind.org> <alpine.LFD.2.02.1104271359580.3323@ionos>
User-Agent: Notmuch/0.5-83-g74bc93f (http://notmuchmail.org) Emacs/23.2.1 (x86_64-pc-linux-gnu)
Date: Thu, 28 Apr 2011 10:15:30 +0300
Message-ID: <8762pyonhp.fsf@shisha.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 16:02:33 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 27 Apr 2011, Alexander Shishkin wrote:
> 
> > In order to keep track of system time changes, we introduce a new
> > syscall which returns the offset of CLOCK_MONOTONIC clock against
> > CLOCK_REALTIME. The caller is to store this value and use it in
> > system calls (like clock_nanosleep or timerfd_settime) that will
> > compare it against the effective offset in order to ensure that
> > the caller's notion of the system time corresponds to the effective
> > system time at the moment of the action being carried out. If it
> > has changed, these system calls will return an error and the caller
> > will have to obtain this offset again.
> 
> No, we do not expose kernel internals like this to user space. The
> kernel internal representation of time is subject to change.
> 
> Also abusing the reminder argument of clock_nanosleep for handing back
> the offset is a horrible hack including the non standard -ECANCELED
> return value. No, we don't change posix interfaces that way.

Hm, https://lkml.org/lkml/2011/3/10/471

> We can add something to timerfd, but definitly not with another
> syscall and by bloating hrtimer and sprinkling cancellation calls all
> over the place. clock_was_set() should be enough and it already calls
> into the hrtimer code, the resume path calls into it as well, so
> there is no need to introduce such a mess.

Agreed.

> The completely untested patch below should solve the same problem in a
> sane way. Restricted to timerfd, but that really should be sufficient.

Looks useful to me. FWIW,

Reviewed-by: Alexander Shishkin <virtuoso@slind.org>

Regards,
--
Alex

> 
> Thanks,
> 
> 	tglx
> 
> ------------->
> 
> Subject: timerfd: Allow timers to be cancelled when clock was set
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, 27 Apr 2011 14:16:42 +0200
> 
> <Add proper changelog here>
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  fs/timerfd.c              |   57 +++++++++++++++++++++++++++++++++++++++++-----
>  include/linux/hrtimer.h   |    3 +-
>  include/linux/time.h      |    5 ++++
>  include/linux/timerfd.h   |    3 +-
>  kernel/hrtimer.c          |   41 +++++++++++++++++++++++++++------
>  kernel/time/timekeeping.c |   15 ++++++++++++
>  6 files changed, 109 insertions(+), 15 deletions(-)
> 
> Index: linux-2.6-tip/fs/timerfd.c
> ===================================================================
> --- linux-2.6-tip.orig/fs/timerfd.c
> +++ linux-2.6-tip/fs/timerfd.c
> @@ -26,10 +26,12 @@
>  struct timerfd_ctx {
>  	struct hrtimer tmr;
>  	ktime_t tintv;
> +	ktime_t moffs;
>  	wait_queue_head_t wqh;
>  	u64 ticks;
>  	int expired;
>  	int clockid;
> +	bool might_cancel;
>  };
>  
>  /*
> @@ -59,24 +61,52 @@ static ktime_t timerfd_get_remaining(str
>  	return remaining.tv64 < 0 ? ktime_set(0, 0): remaining;
>  }
>  
> -static void timerfd_setup(struct timerfd_ctx *ctx, int flags,
> -			  const struct itimerspec *ktmr)
> +static bool timerfd_cancelled(struct timerfd_ctx *ctx)
> +{
> +	ktime_t moffs;
> +
> +	if (!ctx->might_cancel)
> +		return false;
> +
> +	moffs = get_monotonic_offset();
> +
> +	if (moffs.tv64 == ctx->moffs.tv64)
> +		return false;
> +
> +	ctx->moffs = moffs;
> +	return true;
> +}
> +
> +static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
> +			 const struct itimerspec *ktmr)
>  {
>  	enum hrtimer_mode htmode;
>  	ktime_t texp;
> +	int clockid = ctx->clockid;
>  
>  	htmode = (flags & TFD_TIMER_ABSTIME) ?
>  		HRTIMER_MODE_ABS: HRTIMER_MODE_REL;
>  
> +	ctx->might_cancel = false;
> +	if (htmode == HRTIMER_MODE_ABS && ctx->clockid == CLOCK_REALTIME &&
> +	    (flags & TFD_TIMER_CANCELON_SET)) {
> +		clockid = CLOCK_REALTIME_COS;
> +		ctx->might_cancel = true;
> +	}
> +
>  	texp = timespec_to_ktime(ktmr->it_value);
>  	ctx->expired = 0;
>  	ctx->ticks = 0;
>  	ctx->tintv = timespec_to_ktime(ktmr->it_interval);
> -	hrtimer_init(&ctx->tmr, ctx->clockid, htmode);
> +	hrtimer_init(&ctx->tmr, clockid, htmode);
>  	hrtimer_set_expires(&ctx->tmr, texp);
>  	ctx->tmr.function = timerfd_tmrproc;
> -	if (texp.tv64 != 0)
> +	if (texp.tv64 != 0) {
>  		hrtimer_start(&ctx->tmr, texp, htmode);
> +		if (timerfd_cancelled(ctx))
> +			return -ECANCELED;
> +	}
> +	return 0;
>  }
>  
>  static int timerfd_release(struct inode *inode, struct file *file)
> @@ -118,8 +148,21 @@ static ssize_t timerfd_read(struct file 
>  		res = -EAGAIN;
>  	else
>  		res = wait_event_interruptible_locked_irq(ctx->wqh, ctx->ticks);
> +
>  	if (ctx->ticks) {
>  		ticks = ctx->ticks;
> +
> +		/*
> +		 * If clock has changed, we do not care about the
> +		 * ticks and we do not rearm the timer. Userspace must
> +		 * reevaluate anyway.
> +		 */
> +		if (timerfd_cancelled(ctx)) {
> +			ticks = 0;
> +			ctx->expired = 0;
> +			res = -ECANCELED;
> +		}
> +
>  		if (ctx->expired && ctx->tintv.tv64) {
>  			/*
>  			 * If tintv.tv64 != 0, this is a periodic timer that
> @@ -183,6 +226,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
>  	init_waitqueue_head(&ctx->wqh);
>  	ctx->clockid = clockid;
>  	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
> +	ctx->moffs = get_monotonic_offset();
>  
>  	ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx,
>  			       O_RDWR | (flags & TFD_SHARED_FCNTL_FLAGS));
> @@ -199,6 +243,7 @@ SYSCALL_DEFINE4(timerfd_settime, int, uf
>  	struct file *file;
>  	struct timerfd_ctx *ctx;
>  	struct itimerspec ktmr, kotmr;
> +	int ret;
>  
>  	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
>  		return -EFAULT;
> @@ -240,14 +285,14 @@ SYSCALL_DEFINE4(timerfd_settime, int, uf
>  	/*
>  	 * Re-program the timer to the new value ...
>  	 */
> -	timerfd_setup(ctx, flags, &ktmr);
> +	ret = timerfd_setup(ctx, flags, &ktmr);
>  
>  	spin_unlock_irq(&ctx->wqh.lock);
>  	fput(file);
>  	if (otmr && copy_to_user(otmr, &kotmr, sizeof(kotmr)))
>  		return -EFAULT;
>  
> -	return 0;
> +	return ret;
>  }
>  
>  SYSCALL_DEFINE2(timerfd_gettime, int, ufd, struct itimerspec __user *, otmr)
> Index: linux-2.6-tip/include/linux/hrtimer.h
> ===================================================================
> --- linux-2.6-tip.orig/include/linux/hrtimer.h
> +++ linux-2.6-tip/include/linux/hrtimer.h
> @@ -157,6 +157,7 @@ enum  hrtimer_base_type {
>  	HRTIMER_BASE_REALTIME,
>  	HRTIMER_BASE_MONOTONIC,
>  	HRTIMER_BASE_BOOTTIME,
> +	HRTIMER_BASE_REALTIME_COS,
>  	HRTIMER_MAX_CLOCK_BASES,
>  };
>  
> @@ -319,7 +320,7 @@ static inline int hrtimer_is_hres_active
>  extern ktime_t ktime_get(void);
>  extern ktime_t ktime_get_real(void);
>  extern ktime_t ktime_get_boottime(void);
> -
> +ktime_t get_monotonic_offset(void);
>  
>  DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
>  
> Index: linux-2.6-tip/include/linux/time.h
> ===================================================================
> --- linux-2.6-tip.orig/include/linux/time.h
> +++ linux-2.6-tip/include/linux/time.h
> @@ -295,6 +295,11 @@ struct itimerval {
>  #define CLOCK_MONOTONIC_COARSE		6
>  #define CLOCK_BOOTTIME			7
>  
> +#ifdef __KERNEL__
> +/* This clock is not exposed to user space */
> +#define CLOCK_REALTIME_COS		8
> +#endif
> +
>  /*
>   * The IDs of various hardware clocks:
>   */
> Index: linux-2.6-tip/include/linux/timerfd.h
> ===================================================================
> --- linux-2.6-tip.orig/include/linux/timerfd.h
> +++ linux-2.6-tip/include/linux/timerfd.h
> @@ -19,6 +19,7 @@
>   * shared O_* flags.
>   */
>  #define TFD_TIMER_ABSTIME (1 << 0)
> +#define TFD_TIMER_CANCELON_SET (1 << 1)
>  #define TFD_CLOEXEC O_CLOEXEC
>  #define TFD_NONBLOCK O_NONBLOCK
>  
> @@ -26,6 +27,6 @@
>  /* Flags for timerfd_create.  */
>  #define TFD_CREATE_FLAGS TFD_SHARED_FCNTL_FLAGS
>  /* Flags for timerfd_settime.  */
> -#define TFD_SETTIME_FLAGS TFD_TIMER_ABSTIME
> +#define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_TIMER_CANCELON_SET)
>  
>  #endif /* _LINUX_TIMERFD_H */
> Index: linux-2.6-tip/kernel/hrtimer.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/hrtimer.c
> +++ linux-2.6-tip/kernel/hrtimer.c
> @@ -78,6 +78,11 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, 
>  			.get_time = &ktime_get_boottime,
>  			.resolution = KTIME_LOW_RES,
>  		},
> +		{
> +			.index = CLOCK_REALTIME_COS,
> +			.get_time = &ktime_get_real,
> +			.resolution = KTIME_LOW_RES,
> +		},
>  	}
>  };
>  
> @@ -106,6 +111,7 @@ static void hrtimer_get_softirq_time(str
>  	base->clock_base[HRTIMER_BASE_REALTIME].softirq_time = xtim;
>  	base->clock_base[HRTIMER_BASE_MONOTONIC].softirq_time = mono;
>  	base->clock_base[HRTIMER_BASE_BOOTTIME].softirq_time = boot;
> +	base->clock_base[HRTIMER_BASE_REALTIME_COS].softirq_time = xtim;
>  }
>  
>  /*
> @@ -617,6 +623,8 @@ static int hrtimer_reprogram(struct hrti
>  	return res;
>  }
>  
> +static void
> +hrtimer_expire_cancelable(struct hrtimer_cpu_base *cpu_base, ktime_t now);
>  
>  /*
>   * Retrigger next event is called after clock was set
> @@ -626,13 +634,12 @@ static int hrtimer_reprogram(struct hrti
>  static void retrigger_next_event(void *arg)
>  {
>  	struct hrtimer_cpu_base *base;
> -	struct timespec realtime_offset, wtm, sleep;
> +	struct timespec realtime_offset, xtim, wtm, sleep;
>  
>  	if (!hrtimer_hres_active())
>  		return;
>  
> -	get_xtime_and_monotonic_and_sleep_offset(&realtime_offset, &wtm,
> -							&sleep);
> +	get_xtime_and_monotonic_and_sleep_offset(&xtim, &wtm, &sleep);
>  	set_normalized_timespec(&realtime_offset, -wtm.tv_sec, -wtm.tv_nsec);
>  
>  	base = &__get_cpu_var(hrtimer_bases);
> @@ -643,6 +650,10 @@ static void retrigger_next_event(void *a
>  		timespec_to_ktime(realtime_offset);
>  	base->clock_base[HRTIMER_BASE_BOOTTIME].offset =
>  		timespec_to_ktime(sleep);
> +	base->clock_base[HRTIMER_BASE_REALTIME_COS].offset =
> +		timespec_to_ktime(realtime_offset);
> +
> +	hrtimer_expire_cancelable(base, timespec_to_ktime(xtim));
>  
>  	hrtimer_force_reprogram(base, 0);
>  	raw_spin_unlock(&base->lock);
> @@ -715,7 +726,7 @@ static inline int hrtimer_enqueue_reprog
>   */
>  static int hrtimer_switch_to_hres(void)
>  {
> -	int cpu = smp_processor_id();
> +	int i, cpu = smp_processor_id();
>  	struct hrtimer_cpu_base *base = &per_cpu(hrtimer_bases, cpu);
>  	unsigned long flags;
>  
> @@ -731,9 +742,8 @@ static int hrtimer_switch_to_hres(void)
>  		return 0;
>  	}
>  	base->hres_active = 1;
> -	base->clock_base[HRTIMER_BASE_REALTIME].resolution = KTIME_HIGH_RES;
> -	base->clock_base[HRTIMER_BASE_MONOTONIC].resolution = KTIME_HIGH_RES;
> -	base->clock_base[HRTIMER_BASE_BOOTTIME].resolution = KTIME_HIGH_RES;
> +	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
> +		base->clock_base[i].resolution = KTIME_HIGH_RES;
>  
>  	tick_setup_sched_timer();
>  
> @@ -1221,6 +1231,22 @@ static void __run_hrtimer(struct hrtimer
>  	timer->state &= ~HRTIMER_STATE_CALLBACK;
>  }
>  
> +static void
> +hrtimer_expire_cancelable(struct hrtimer_cpu_base *cpu_base, ktime_t now)
> +{
> +	struct timerqueue_node *node;
> +	struct hrtimer_clock_base *base;
> +
> +	base = cpu_base->clock_base + HRTIMER_BASE_REALTIME_COS;
> +
> +	while ((node = timerqueue_getnext(&base->active))) {
> +			struct hrtimer *timer;
> +
> +			timer = container_of(node, struct hrtimer, node);
> +			__run_hrtimer(timer, &now);
> +	}
> +}
> +
>  #ifdef CONFIG_HIGH_RES_TIMERS
>  
>  /*
> @@ -1725,6 +1751,7 @@ void __init hrtimers_init(void)
>  	hrtimer_clock_to_base_table[CLOCK_REALTIME] = HRTIMER_BASE_REALTIME;
>  	hrtimer_clock_to_base_table[CLOCK_MONOTONIC] = HRTIMER_BASE_MONOTONIC;
>  	hrtimer_clock_to_base_table[CLOCK_BOOTTIME] = HRTIMER_BASE_BOOTTIME;
> +	hrtimer_clock_to_base_table[CLOCK_REALTIME_COS] = HRTIMER_BASE_REALTIME_COS;
>  
>  	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
>  			  (void *)(long)smp_processor_id());
> Index: linux-2.6-tip/kernel/time/timekeeping.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/time/timekeeping.c
> +++ linux-2.6-tip/kernel/time/timekeeping.c
> @@ -1049,6 +1049,21 @@ void get_xtime_and_monotonic_and_sleep_o
>  }
>  
>  /**
> + * get_monotonic_offset() - get wall_to_monotonic
> + */
> +ktime_t get_monotonic_offset(void)
> +{
> +	unsigned long seq;
> +	struct timespec wtom;
> +
> +	do {
> +		seq = read_seqbegin(&xtime_lock);
> +		wtom = wall_to_monotonic;
> +	} while (read_seqretry(&xtime_lock, seq));
> +	return timespec_to_ktime(wtom);
> +}
> +
> +/**
>   * xtime_update() - advances the timekeeping infrastructure
>   * @ticks:	number of ticks, that have elapsed since the last call.
>   *
