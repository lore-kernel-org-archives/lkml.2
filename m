Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab2JLLmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:42:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:54696 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758512Ab2JLLmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:42:39 -0400
Date: Fri, 12 Oct 2012 13:42:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] timers for 3.7
In-Reply-To: <alpine.LFD.2.02.1210121240160.2779@ionos>
Message-ID: <alpine.LFD.2.02.1210121338330.2779@ionos>
References: <alpine.LFD.2.02.1210121240160.2779@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012, Thomas Gleixner wrote:

> Linus,
> 
> please pull the latest timers-core-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

Forgot to add the short description:

       * Bug fixes (one for a long standing dead loop issue)
       * Rework of time related vsyscalls
       * Timer extensions for workqueues
       * Alarm timer updates
       * Jiffies updates to remove compile time dependencies

Thanks,
 
 	tglx
 
> ------------------>
> Arnd Bergmann (1):
>       time/jiffies: bring back unconditional LATCH definition
> 
> Dan Carpenter (1):
>       timekeeping: Cast raw_interval to u64 to avoid shift overflow
> 
> Hildner, Christian (1):
>       timers: Fix endless looping between cascade() and internal_add_timer()
> 
> John Stultz (11):
>       alarmtimer: Use hrtimer per-alarm instead of per-base
>       alarmtimer: Remove unused helpers & defines
>       alarmtimer: Rename alarmtimer_remove to alarmtimer_dequeue
>       jiffies: Kill unused TICK_USEC_TO_NSEC
>       jiffies: Remove compile time assumptions about CLOCK_TICK_RATE
>       time: Move timekeeper structure to timekeeper_internal.h for vsyscall changes
>       time: Move update_vsyscall definitions to timekeeper_internal.h
>       time: Convert CONFIG_GENERIC_TIME_VSYSCALL to CONFIG_GENERIC_TIME_VSYSCALL_OLD
>       time: Introduce new GENERIC_TIME_VSYSCALL
>       time: Only do nanosecond rounding on GENERIC_TIME_VSYSCALL_OLD systems
>       time: Convert x86_64 to using new update_vsyscall
> 
> Tejun Heo (4):
>       timer: Generalize timer->base flags handling
>       timer: Relocate declarations of init_timer_on_stack_key()
>       timer: Clean up timer initializers
>       timer: Implement TIMER_IRQSAFE
> 
> Todd Poynor (1):
>       alarmtimer: Implement minimum alarm interval for allowing suspend
> 
> 
>  arch/ia64/Kconfig                   |    2 +-
>  arch/ia64/kernel/time.c             |    4 +-
>  arch/powerpc/Kconfig                |    2 +-
>  arch/powerpc/kernel/time.c          |    4 +-
>  arch/s390/Kconfig                   |    2 +-
>  arch/s390/kernel/time.c             |    4 +-
>  arch/x86/include/asm/vgtod.h        |    4 +-
>  arch/x86/kernel/setup.c             |    3 +
>  arch/x86/kernel/vsyscall_64.c       |   49 ++++++----
>  arch/x86/vdso/vclock_gettime.c      |   22 +++--
>  include/linux/alarmtimer.h          |   31 +------
>  include/linux/clocksource.h         |   16 ----
>  include/linux/jiffies.h             |   20 +----
>  include/linux/timekeeper_internal.h |  108 +++++++++++++++++++++++
>  include/linux/timer.h               |  165 ++++++++++++++---------------------
>  kernel/time.c                       |    2 +-
>  kernel/time/Kconfig                 |    4 +
>  kernel/time/alarmtimer.c            |  118 +++++++++----------------
>  kernel/time/jiffies.c               |   32 +++++++-
>  kernel/time/timekeeping.c           |  117 +++++++------------------
>  kernel/timer.c                      |  118 ++++++++++++-------------
>  21 files changed, 403 insertions(+), 424 deletions(-)
>  create mode 100644 include/linux/timekeeper_internal.h
> 
> diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
> index 310cf57..f9e673c 100644
> --- a/arch/ia64/Kconfig
> +++ b/arch/ia64/Kconfig
> @@ -38,7 +38,7 @@ config IA64
>  	select ARCH_TASK_STRUCT_ALLOCATOR
>  	select ARCH_THREAD_INFO_ALLOCATOR
>  	select ARCH_CLOCKSOURCE_DATA
> -	select GENERIC_TIME_VSYSCALL
> +	select GENERIC_TIME_VSYSCALL_OLD
>  	default y
>  	help
>  	  The Itanium Processor Family is Intel's 64-bit successor to
> diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
> index ecc904b..d2f4e26 100644
> --- a/arch/ia64/kernel/time.c
> +++ b/arch/ia64/kernel/time.c
> @@ -19,7 +19,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/efi.h>
>  #include <linux/timex.h>
> -#include <linux/clocksource.h>
> +#include <linux/timekeeper_internal.h>
>  #include <linux/platform_device.h>
>  
>  #include <asm/machvec.h>
> @@ -454,7 +454,7 @@ void update_vsyscall_tz(void)
>  {
>  }
>  
> -void update_vsyscall(struct timespec *wall, struct timespec *wtm,
> +void update_vsyscall_old(struct timespec *wall, struct timespec *wtm,
>  			struct clocksource *c, u32 mult)
>  {
>  	write_seqcount_begin(&fsyscall_gtod_data.seq);
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 352f416..0881660 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -135,7 +135,7 @@ config PPC
>  	select ARCH_HAVE_NMI_SAFE_CMPXCHG
>  	select GENERIC_SMP_IDLE_THREAD
>  	select GENERIC_CMOS_UPDATE
> -	select GENERIC_TIME_VSYSCALL
> +	select GENERIC_TIME_VSYSCALL_OLD
>  	select GENERIC_CLOCKEVENTS
>  	select GENERIC_STRNCPY_FROM_USER
>  	select GENERIC_STRNLEN_USER
> diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
> index e49e931..c825809 100644
> --- a/arch/powerpc/kernel/time.c
> +++ b/arch/powerpc/kernel/time.c
> @@ -73,7 +73,7 @@
>  /* powerpc clocksource/clockevent code */
>  
>  #include <linux/clockchips.h>
> -#include <linux/clocksource.h>
> +#include <linux/timekeeper_internal.h>
>  
>  static cycle_t rtc_read(struct clocksource *);
>  static struct clocksource clocksource_rtc = {
> @@ -712,7 +712,7 @@ static cycle_t timebase_read(struct clocksource *cs)
>  	return (cycle_t)get_tb();
>  }
>  
> -void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
> +void update_vsyscall_old(struct timespec *wall_time, struct timespec *wtm,
>  			struct clocksource *clock, u32 mult)
>  {
>  	u64 new_tb_to_xs, new_stamp_xsec;
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 107610e..ba488aa 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -121,7 +121,7 @@ config S390
>  	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
>  	select ARCH_WANT_IPC_PARSE_VERSION
>  	select GENERIC_SMP_IDLE_THREAD
> -	select GENERIC_TIME_VSYSCALL
> +	select GENERIC_TIME_VSYSCALL_OLD
>  	select GENERIC_CLOCKEVENTS
>  	select KTIME_SCALAR if 32BIT
>  	select HAVE_ARCH_SECCOMP_FILTER
> diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
> index dcec960..c5430bf 100644
> --- a/arch/s390/kernel/time.c
> +++ b/arch/s390/kernel/time.c
> @@ -34,7 +34,7 @@
>  #include <linux/profile.h>
>  #include <linux/timex.h>
>  #include <linux/notifier.h>
> -#include <linux/clocksource.h>
> +#include <linux/timekeeper_internal.h>
>  #include <linux/clockchips.h>
>  #include <linux/gfp.h>
>  #include <linux/kprobes.h>
> @@ -219,7 +219,7 @@ struct clocksource * __init clocksource_default_clock(void)
>  	return &clocksource_tod;
>  }
>  
> -void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
> +void update_vsyscall_old(struct timespec *wall_time, struct timespec *wtm,
>  			struct clocksource *clock, u32 mult)
>  {
>  	if (clock != &clocksource_tod)
> diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
> index 8b38be2..46e24d3 100644
> --- a/arch/x86/include/asm/vgtod.h
> +++ b/arch/x86/include/asm/vgtod.h
> @@ -17,8 +17,8 @@ struct vsyscall_gtod_data {
>  
>  	/* open coded 'struct timespec' */
>  	time_t		wall_time_sec;
> -	u32		wall_time_nsec;
> -	u32		monotonic_time_nsec;
> +	u64		wall_time_snsec;
> +	u64		monotonic_time_snsec;
>  	time_t		monotonic_time_sec;
>  
>  	struct timezone sys_tz;
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index f4b9b80..4062f15 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -68,6 +68,7 @@
>  #include <linux/percpu.h>
>  #include <linux/crash_dump.h>
>  #include <linux/tboot.h>
> +#include <linux/jiffies.h>
>  
>  #include <video/edid.h>
>  
> @@ -1034,6 +1035,8 @@ void __init setup_arch(char **cmdline_p)
>  	mcheck_init();
>  
>  	arch_init_ideal_nops();
> +
> +	register_refined_jiffies(CLOCK_TICK_RATE);
>  }
>  
>  #ifdef CONFIG_X86_32
> diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
> index 8d141b3..3a3e8c9 100644
> --- a/arch/x86/kernel/vsyscall_64.c
> +++ b/arch/x86/kernel/vsyscall_64.c
> @@ -28,7 +28,7 @@
>  #include <linux/jiffies.h>
>  #include <linux/sysctl.h>
>  #include <linux/topology.h>
> -#include <linux/clocksource.h>
> +#include <linux/timekeeper_internal.h>
>  #include <linux/getcpu.h>
>  #include <linux/cpu.h>
>  #include <linux/smp.h>
> @@ -82,32 +82,41 @@ void update_vsyscall_tz(void)
>  	vsyscall_gtod_data.sys_tz = sys_tz;
>  }
>  
> -void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
> -			struct clocksource *clock, u32 mult)
> +void update_vsyscall(struct timekeeper *tk)
>  {
> -	struct timespec monotonic;
> +	struct vsyscall_gtod_data *vdata = &vsyscall_gtod_data;
>  
> -	write_seqcount_begin(&vsyscall_gtod_data.seq);
> +	write_seqcount_begin(&vdata->seq);
>  
>  	/* copy vsyscall data */
> -	vsyscall_gtod_data.clock.vclock_mode	= clock->archdata.vclock_mode;
> -	vsyscall_gtod_data.clock.cycle_last	= clock->cycle_last;
> -	vsyscall_gtod_data.clock.mask		= clock->mask;
> -	vsyscall_gtod_data.clock.mult		= mult;
> -	vsyscall_gtod_data.clock.shift		= clock->shift;
> -
> -	vsyscall_gtod_data.wall_time_sec	= wall_time->tv_sec;
> -	vsyscall_gtod_data.wall_time_nsec	= wall_time->tv_nsec;
> +	vdata->clock.vclock_mode	= tk->clock->archdata.vclock_mode;
> +	vdata->clock.cycle_last		= tk->clock->cycle_last;
> +	vdata->clock.mask		= tk->clock->mask;
> +	vdata->clock.mult		= tk->mult;
> +	vdata->clock.shift		= tk->shift;
> +
> +	vdata->wall_time_sec		= tk->xtime_sec;
> +	vdata->wall_time_snsec		= tk->xtime_nsec;
> +
> +	vdata->monotonic_time_sec	= tk->xtime_sec
> +					+ tk->wall_to_monotonic.tv_sec;
> +	vdata->monotonic_time_snsec	= tk->xtime_nsec
> +					+ (tk->wall_to_monotonic.tv_nsec
> +						<< tk->shift);
> +	while (vdata->monotonic_time_snsec >=
> +					(((u64)NSEC_PER_SEC) << tk->shift)) {
> +		vdata->monotonic_time_snsec -=
> +					((u64)NSEC_PER_SEC) << tk->shift;
> +		vdata->monotonic_time_sec++;
> +	}
>  
> -	monotonic = timespec_add(*wall_time, *wtm);
> -	vsyscall_gtod_data.monotonic_time_sec	= monotonic.tv_sec;
> -	vsyscall_gtod_data.monotonic_time_nsec	= monotonic.tv_nsec;
> +	vdata->wall_time_coarse.tv_sec	= tk->xtime_sec;
> +	vdata->wall_time_coarse.tv_nsec	= (long)(tk->xtime_nsec >> tk->shift);
>  
> -	vsyscall_gtod_data.wall_time_coarse	= __current_kernel_time();
> -	vsyscall_gtod_data.monotonic_time_coarse =
> -		timespec_add(vsyscall_gtod_data.wall_time_coarse, *wtm);
> +	vdata->monotonic_time_coarse	= timespec_add(vdata->wall_time_coarse,
> +							tk->wall_to_monotonic);
>  
> -	write_seqcount_end(&vsyscall_gtod_data.seq);
> +	write_seqcount_end(&vdata->seq);
>  }
>  
>  static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
> index 885eff4..4df6c37 100644
> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -80,7 +80,7 @@ notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
>  }
>  
>  
> -notrace static inline long vgetns(void)
> +notrace static inline u64 vgetsns(void)
>  {
>  	long v;
>  	cycles_t cycles;
> @@ -91,21 +91,24 @@ notrace static inline long vgetns(void)
>  	else
>  		return 0;
>  	v = (cycles - gtod->clock.cycle_last) & gtod->clock.mask;
> -	return (v * gtod->clock.mult) >> gtod->clock.shift;
> +	return v * gtod->clock.mult;
>  }
>  
>  /* Code size doesn't matter (vdso is 4k anyway) and this is faster. */
>  notrace static int __always_inline do_realtime(struct timespec *ts)
>  {
> -	unsigned long seq, ns;
> +	unsigned long seq;
> +	u64 ns;
>  	int mode;
>  
> +	ts->tv_nsec = 0;
>  	do {
>  		seq = read_seqcount_begin(&gtod->seq);
>  		mode = gtod->clock.vclock_mode;
>  		ts->tv_sec = gtod->wall_time_sec;
> -		ts->tv_nsec = gtod->wall_time_nsec;
> -		ns = vgetns();
> +		ns = gtod->wall_time_snsec;
> +		ns += vgetsns();
> +		ns >>= gtod->clock.shift;
>  	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
>  
>  	timespec_add_ns(ts, ns);
> @@ -114,15 +117,18 @@ notrace static int __always_inline do_realtime(struct timespec *ts)
>  
>  notrace static int do_monotonic(struct timespec *ts)
>  {
> -	unsigned long seq, ns;
> +	unsigned long seq;
> +	u64 ns;
>  	int mode;
>  
> +	ts->tv_nsec = 0;
>  	do {
>  		seq = read_seqcount_begin(&gtod->seq);
>  		mode = gtod->clock.vclock_mode;
>  		ts->tv_sec = gtod->monotonic_time_sec;
> -		ts->tv_nsec = gtod->monotonic_time_nsec;
> -		ns = vgetns();
> +		ns = gtod->monotonic_time_snsec;
> +		ns += vgetsns();
> +		ns >>= gtod->clock.shift;
>  	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
>  	timespec_add_ns(ts, ns);
>  
> diff --git a/include/linux/alarmtimer.h b/include/linux/alarmtimer.h
> index 96c5c24..9069694 100644
> --- a/include/linux/alarmtimer.h
> +++ b/include/linux/alarmtimer.h
> @@ -21,7 +21,6 @@ enum alarmtimer_restart {
>  
>  #define ALARMTIMER_STATE_INACTIVE	0x00
>  #define ALARMTIMER_STATE_ENQUEUED	0x01
> -#define ALARMTIMER_STATE_CALLBACK	0x02
>  
>  /**
>   * struct alarm - Alarm timer structure
> @@ -35,6 +34,7 @@ enum alarmtimer_restart {
>   */
>  struct alarm {
>  	struct timerqueue_node	node;
> +	struct hrtimer		timer;
>  	enum alarmtimer_restart	(*function)(struct alarm *, ktime_t now);
>  	enum alarmtimer_type	type;
>  	int			state;
> @@ -43,39 +43,12 @@ struct alarm {
>  
>  void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
>  		enum alarmtimer_restart (*function)(struct alarm *, ktime_t));
> -void alarm_start(struct alarm *alarm, ktime_t start);
> +int alarm_start(struct alarm *alarm, ktime_t start);
>  int alarm_try_to_cancel(struct alarm *alarm);
>  int alarm_cancel(struct alarm *alarm);
>  
>  u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval);
>  
> -/*
> - * A alarmtimer is active, when it is enqueued into timerqueue or the
> - * callback function is running.
> - */
> -static inline int alarmtimer_active(const struct alarm *timer)
> -{
> -	return timer->state != ALARMTIMER_STATE_INACTIVE;
> -}
> -
> -/*
> - * Helper function to check, whether the timer is on one of the queues
> - */
> -static inline int alarmtimer_is_queued(struct alarm *timer)
> -{
> -	return timer->state & ALARMTIMER_STATE_ENQUEUED;
> -}
> -
> -/*
> - * Helper function to check, whether the timer is running the callback
> - * function
> - */
> -static inline int alarmtimer_callback_running(struct alarm *timer)
> -{
> -	return timer->state & ALARMTIMER_STATE_CALLBACK;
> -}
> -
> -
>  /* Provide way to access the rtc device being used by alarmtimers */
>  struct rtc_device *alarmtimer_get_rtcdev(void);
>  
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index fbe89e1..4dceaf8 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -319,22 +319,6 @@ static inline void __clocksource_updatefreq_khz(struct clocksource *cs, u32 khz)
>  	__clocksource_updatefreq_scale(cs, 1000, khz);
>  }
>  
> -#ifdef CONFIG_GENERIC_TIME_VSYSCALL
> -extern void
> -update_vsyscall(struct timespec *ts, struct timespec *wtm,
> -			struct clocksource *c, u32 mult);
> -extern void update_vsyscall_tz(void);
> -#else
> -static inline void
> -update_vsyscall(struct timespec *ts, struct timespec *wtm,
> -			struct clocksource *c, u32 mult)
> -{
> -}
> -
> -static inline void update_vsyscall_tz(void)
> -{
> -}
> -#endif
>  
>  extern void timekeeping_notify(struct clocksource *clock);
>  
> diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
> index 8268054..c6d5b2a 100644
> --- a/include/linux/jiffies.h
> +++ b/include/linux/jiffies.h
> @@ -51,31 +51,17 @@
>  #define SH_DIV(NOM,DEN,LSH) (   (((NOM) / (DEN)) << (LSH))              \
>                               + ((((NOM) % (DEN)) << (LSH)) + (DEN) / 2) / (DEN))
>  
> -#ifdef CLOCK_TICK_RATE
>  /* LATCH is used in the interval timer and ftape setup. */
> -# define LATCH ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
> +#define LATCH ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
>  
> -/*
> - * HZ is the requested value. However the CLOCK_TICK_RATE may not allow
> - * for exactly HZ. So SHIFTED_HZ is high res HZ ("<< 8" is for accuracy)
> - */
> -# define SHIFTED_HZ (SH_DIV(CLOCK_TICK_RATE, LATCH, 8))
> -#else
> -# define SHIFTED_HZ (HZ << 8)
> -#endif
> +extern int register_refined_jiffies(long clock_tick_rate);
>  
>  /* TICK_NSEC is the time between ticks in nsec assuming SHIFTED_HZ */
> -#define TICK_NSEC (SH_DIV(1000000UL * 1000, SHIFTED_HZ, 8))
> +#define TICK_NSEC ((NSEC_PER_SEC+HZ/2)/HZ)
>  
>  /* TICK_USEC is the time between ticks in usec assuming fake USER_HZ */
>  #define TICK_USEC ((1000000UL + USER_HZ/2) / USER_HZ)
>  
> -/*
> - * TICK_USEC_TO_NSEC is the time between ticks in nsec assuming SHIFTED_HZ and
> - * a value TUSEC for TICK_USEC (can be set bij adjtimex)
> - */
> -#define TICK_USEC_TO_NSEC(TUSEC) (SH_DIV(TUSEC * USER_HZ * 1000, SHIFTED_HZ, 8))
> -
>  /* some arch's have a small-data section that can be accessed register-relative
>   * but that can only take up to, say, 4-byte variables. jiffies being part of
>   * an 8-byte variable may not be correctly accessed unless we force the issue
> diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
> new file mode 100644
> index 0000000..e1d558e
> --- /dev/null
> +++ b/include/linux/timekeeper_internal.h
> @@ -0,0 +1,108 @@
> +/*
> + * You SHOULD NOT be including this unless you're vsyscall
> + * handling code or timekeeping internal code!
> + */
> +
> +#ifndef _LINUX_TIMEKEEPER_INTERNAL_H
> +#define _LINUX_TIMEKEEPER_INTERNAL_H
> +
> +#include <linux/clocksource.h>
> +#include <linux/jiffies.h>
> +#include <linux/time.h>
> +
> +/* Structure holding internal timekeeping values. */
> +struct timekeeper {
> +	/* Current clocksource used for timekeeping. */
> +	struct clocksource	*clock;
> +	/* NTP adjusted clock multiplier */
> +	u32			mult;
> +	/* The shift value of the current clocksource. */
> +	u32			shift;
> +	/* Number of clock cycles in one NTP interval. */
> +	cycle_t			cycle_interval;
> +	/* Number of clock shifted nano seconds in one NTP interval. */
> +	u64			xtime_interval;
> +	/* shifted nano seconds left over when rounding cycle_interval */
> +	s64			xtime_remainder;
> +	/* Raw nano seconds accumulated per NTP interval. */
> +	u32			raw_interval;
> +
> +	/* Current CLOCK_REALTIME time in seconds */
> +	u64			xtime_sec;
> +	/* Clock shifted nano seconds */
> +	u64			xtime_nsec;
> +
> +	/* Difference between accumulated time and NTP time in ntp
> +	 * shifted nano seconds. */
> +	s64			ntp_error;
> +	/* Shift conversion between clock shifted nano seconds and
> +	 * ntp shifted nano seconds. */
> +	u32			ntp_error_shift;
> +
> +	/*
> +	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
> +	 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
> +	 * at zero at system boot time, so wall_to_monotonic will be negative,
> +	 * however, we will ALWAYS keep the tv_nsec part positive so we can use
> +	 * the usual normalization.
> +	 *
> +	 * wall_to_monotonic is moved after resume from suspend for the
> +	 * monotonic time not to jump. We need to add total_sleep_time to
> +	 * wall_to_monotonic to get the real boot based time offset.
> +	 *
> +	 * - wall_to_monotonic is no longer the boot time, getboottime must be
> +	 * used instead.
> +	 */
> +	struct timespec		wall_to_monotonic;
> +	/* Offset clock monotonic -> clock realtime */
> +	ktime_t			offs_real;
> +	/* time spent in suspend */
> +	struct timespec		total_sleep_time;
> +	/* Offset clock monotonic -> clock boottime */
> +	ktime_t			offs_boot;
> +	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
> +	struct timespec		raw_time;
> +	/* Seqlock for all timekeeper values */
> +	seqlock_t		lock;
> +};
> +
> +static inline struct timespec tk_xtime(struct timekeeper *tk)
> +{
> +	struct timespec ts;
> +
> +	ts.tv_sec = tk->xtime_sec;
> +	ts.tv_nsec = (long)(tk->xtime_nsec >> tk->shift);
> +	return ts;
> +}
> +
> +
> +#ifdef CONFIG_GENERIC_TIME_VSYSCALL
> +
> +extern void update_vsyscall(struct timekeeper *tk);
> +extern void update_vsyscall_tz(void);
> +
> +#elif defined(CONFIG_GENERIC_TIME_VSYSCALL_OLD)
> +
> +extern void update_vsyscall_old(struct timespec *ts, struct timespec *wtm,
> +				struct clocksource *c, u32 mult);
> +extern void update_vsyscall_tz(void);
> +
> +static inline void update_vsyscall(struct timekeeper *tk)
> +{
> +	struct timespec xt;
> +
> +	xt = tk_xtime(tk);
> +	update_vsyscall_old(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
> +}
> +
> +#else
> +
> +static inline void update_vsyscall(struct timekeeper *tk)
> +{
> +}
> +static inline void update_vsyscall_tz(void)
> +{
> +}
> +#endif
> +
> +#endif /* _LINUX_TIMEKEEPER_INTERNAL_H */
> diff --git a/include/linux/timer.h b/include/linux/timer.h
> index 6abd913..8c5a197 100644
> --- a/include/linux/timer.h
> +++ b/include/linux/timer.h
> @@ -49,147 +49,112 @@ extern struct tvec_base boot_tvec_bases;
>  #endif
>  
>  /*
> - * Note that all tvec_bases are 2 byte aligned and lower bit of
> - * base in timer_list is guaranteed to be zero. Use the LSB to
> - * indicate whether the timer is deferrable.
> + * Note that all tvec_bases are at least 4 byte aligned and lower two bits
> + * of base in timer_list is guaranteed to be zero. Use them for flags.
>   *
>   * A deferrable timer will work normally when the system is busy, but
>   * will not cause a CPU to come out of idle just to service it; instead,
>   * the timer will be serviced when the CPU eventually wakes up with a
>   * subsequent non-deferrable timer.
> + *
> + * An irqsafe timer is executed with IRQ disabled and it's safe to wait for
> + * the completion of the running instance from IRQ handlers, for example,
> + * by calling del_timer_sync().
> + *
> + * Note: The irq disabled callback execution is a special case for
> + * workqueue locking issues. It's not meant for executing random crap
> + * with interrupts disabled. Abuse is monitored!
>   */
> -#define TBASE_DEFERRABLE_FLAG		(0x1)
> +#define TIMER_DEFERRABLE		0x1LU
> +#define TIMER_IRQSAFE			0x2LU
>  
> -#define TIMER_INITIALIZER(_function, _expires, _data) {		\
> +#define TIMER_FLAG_MASK			0x3LU
> +
> +#define __TIMER_INITIALIZER(_function, _expires, _data, _flags) { \
>  		.entry = { .prev = TIMER_ENTRY_STATIC },	\
>  		.function = (_function),			\
>  		.expires = (_expires),				\
>  		.data = (_data),				\
> -		.base = &boot_tvec_bases,			\
> +		.base = (void *)((unsigned long)&boot_tvec_bases + (_flags)), \
>  		.slack = -1,					\
>  		__TIMER_LOCKDEP_MAP_INITIALIZER(		\
>  			__FILE__ ":" __stringify(__LINE__))	\
>  	}
>  
> -#define TBASE_MAKE_DEFERRED(ptr) ((struct tvec_base *)		\
> -		  ((unsigned char *)(ptr) + TBASE_DEFERRABLE_FLAG))
> +#define TIMER_INITIALIZER(_function, _expires, _data)		\
> +	__TIMER_INITIALIZER((_function), (_expires), (_data), 0)
>  
> -#define TIMER_DEFERRED_INITIALIZER(_function, _expires, _data) {\
> -		.entry = { .prev = TIMER_ENTRY_STATIC },	\
> -		.function = (_function),			\
> -		.expires = (_expires),				\
> -		.data = (_data),				\
> -		.base = TBASE_MAKE_DEFERRED(&boot_tvec_bases),	\
> -		__TIMER_LOCKDEP_MAP_INITIALIZER(		\
> -			__FILE__ ":" __stringify(__LINE__))	\
> -	}
> +#define TIMER_DEFERRED_INITIALIZER(_function, _expires, _data)	\
> +	__TIMER_INITIALIZER((_function), (_expires), (_data), TIMER_DEFERRABLE)
>  
>  #define DEFINE_TIMER(_name, _function, _expires, _data)		\
>  	struct timer_list _name =				\
>  		TIMER_INITIALIZER(_function, _expires, _data)
>  
> -void init_timer_key(struct timer_list *timer,
> -		    const char *name,
> -		    struct lock_class_key *key);
> -void init_timer_deferrable_key(struct timer_list *timer,
> -			       const char *name,
> -			       struct lock_class_key *key);
> +void init_timer_key(struct timer_list *timer, unsigned int flags,
> +		    const char *name, struct lock_class_key *key);
> +
> +#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
> +extern void init_timer_on_stack_key(struct timer_list *timer,
> +				    unsigned int flags, const char *name,
> +				    struct lock_class_key *key);
> +extern void destroy_timer_on_stack(struct timer_list *timer);
> +#else
> +static inline void destroy_timer_on_stack(struct timer_list *timer) { }
> +static inline void init_timer_on_stack_key(struct timer_list *timer,
> +					   unsigned int flags, const char *name,
> +					   struct lock_class_key *key)
> +{
> +	init_timer_key(timer, flags, name, key);
> +}
> +#endif
>  
>  #ifdef CONFIG_LOCKDEP
> -#define init_timer(timer)						\
> +#define __init_timer(_timer, _flags)					\
>  	do {								\
>  		static struct lock_class_key __key;			\
> -		init_timer_key((timer), #timer, &__key);		\
> +		init_timer_key((_timer), (_flags), #_timer, &__key);	\
>  	} while (0)
>  
> -#define init_timer_deferrable(timer)					\
> +#define __init_timer_on_stack(_timer, _flags)				\
>  	do {								\
>  		static struct lock_class_key __key;			\
> -		init_timer_deferrable_key((timer), #timer, &__key);	\
> +		init_timer_on_stack_key((_timer), (_flags), #_timer, &__key); \
>  	} while (0)
> +#else
> +#define __init_timer(_timer, _flags)					\
> +	init_timer_key((_timer), (_flags), NULL, NULL)
> +#define __init_timer_on_stack(_timer, _flags)				\
> +	init_timer_on_stack_key((_timer), (_flags), NULL, NULL)
> +#endif
>  
> +#define init_timer(timer)						\
> +	__init_timer((timer), 0)
> +#define init_timer_deferrable(timer)					\
> +	__init_timer((timer), TIMER_DEFERRABLE)
>  #define init_timer_on_stack(timer)					\
> +	__init_timer_on_stack((timer), 0)
> +
> +#define __setup_timer(_timer, _fn, _data, _flags)			\
>  	do {								\
> -		static struct lock_class_key __key;			\
> -		init_timer_on_stack_key((timer), #timer, &__key);	\
> +		__init_timer((_timer), (_flags));			\
> +		(_timer)->function = (_fn);				\
> +		(_timer)->data = (_data);				\
>  	} while (0)
>  
> -#define setup_timer(timer, fn, data)					\
> +#define __setup_timer_on_stack(_timer, _fn, _data, _flags)		\
>  	do {								\
> -		static struct lock_class_key __key;			\
> -		setup_timer_key((timer), #timer, &__key, (fn), (data));\
> +		__init_timer_on_stack((_timer), (_flags));		\
> +		(_timer)->function = (_fn);				\
> +		(_timer)->data = (_data);				\
>  	} while (0)
>  
> +#define setup_timer(timer, fn, data)					\
> +	__setup_timer((timer), (fn), (data), 0)
>  #define setup_timer_on_stack(timer, fn, data)				\
> -	do {								\
> -		static struct lock_class_key __key;			\
> -		setup_timer_on_stack_key((timer), #timer, &__key,	\
> -					 (fn), (data));			\
> -	} while (0)
> +	__setup_timer_on_stack((timer), (fn), (data), 0)
>  #define setup_deferrable_timer_on_stack(timer, fn, data)		\
> -	do {								\
> -		static struct lock_class_key __key;			\
> -		setup_deferrable_timer_on_stack_key((timer), #timer,	\
> -						    &__key, (fn),	\
> -						    (data));		\
> -	} while (0)
> -#else
> -#define init_timer(timer)\
> -	init_timer_key((timer), NULL, NULL)
> -#define init_timer_deferrable(timer)\
> -	init_timer_deferrable_key((timer), NULL, NULL)
> -#define init_timer_on_stack(timer)\
> -	init_timer_on_stack_key((timer), NULL, NULL)
> -#define setup_timer(timer, fn, data)\
> -	setup_timer_key((timer), NULL, NULL, (fn), (data))
> -#define setup_timer_on_stack(timer, fn, data)\
> -	setup_timer_on_stack_key((timer), NULL, NULL, (fn), (data))
> -#define setup_deferrable_timer_on_stack(timer, fn, data)\
> -	setup_deferrable_timer_on_stack_key((timer), NULL, NULL, (fn), (data))
> -#endif
> -
> -#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
> -extern void init_timer_on_stack_key(struct timer_list *timer,
> -				    const char *name,
> -				    struct lock_class_key *key);
> -extern void destroy_timer_on_stack(struct timer_list *timer);
> -#else
> -static inline void destroy_timer_on_stack(struct timer_list *timer) { }
> -static inline void init_timer_on_stack_key(struct timer_list *timer,
> -					   const char *name,
> -					   struct lock_class_key *key)
> -{
> -	init_timer_key(timer, name, key);
> -}
> -#endif
> -
> -static inline void setup_timer_key(struct timer_list * timer,
> -				const char *name,
> -				struct lock_class_key *key,
> -				void (*function)(unsigned long),
> -				unsigned long data)
> -{
> -	timer->function = function;
> -	timer->data = data;
> -	init_timer_key(timer, name, key);
> -}
> -
> -static inline void setup_timer_on_stack_key(struct timer_list *timer,
> -					const char *name,
> -					struct lock_class_key *key,
> -					void (*function)(unsigned long),
> -					unsigned long data)
> -{
> -	timer->function = function;
> -	timer->data = data;
> -	init_timer_on_stack_key(timer, name, key);
> -}
> -
> -extern void setup_deferrable_timer_on_stack_key(struct timer_list *timer,
> -						const char *name,
> -						struct lock_class_key *key,
> -						void (*function)(unsigned long),
> -						unsigned long data);
> +	__setup_timer_on_stack((timer), (fn), (data), TIMER_DEFERRABLE)
>  
>  /**
>   * timer_pending - is a timer pending?
> diff --git a/kernel/time.c b/kernel/time.c
> index ba744cf..d226c6a 100644
> --- a/kernel/time.c
> +++ b/kernel/time.c
> @@ -30,7 +30,7 @@
>  #include <linux/export.h>
>  #include <linux/timex.h>
>  #include <linux/capability.h>
> -#include <linux/clocksource.h>
> +#include <linux/timekeeper_internal.h>
>  #include <linux/errno.h>
>  #include <linux/syscalls.h>
>  #include <linux/security.h>
> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> index fd42bd4..8601f0d 100644
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -16,6 +16,10 @@ config ARCH_CLOCKSOURCE_DATA
>  config GENERIC_TIME_VSYSCALL
>  	bool
>  
> +# Timekeeping vsyscall support
> +config GENERIC_TIME_VSYSCALL_OLD
> +	bool
> +
>  # ktime_t scalar 64bit nsec representation
>  config KTIME_SCALAR
>  	bool
> diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
> index aa27d39..f11d83b 100644
> --- a/kernel/time/alarmtimer.c
> +++ b/kernel/time/alarmtimer.c
> @@ -37,7 +37,6 @@
>  static struct alarm_base {
>  	spinlock_t		lock;
>  	struct timerqueue_head	timerqueue;
> -	struct hrtimer		timer;
>  	ktime_t			(*gettime)(void);
>  	clockid_t		base_clockid;
>  } alarm_bases[ALARM_NUMTYPE];
> @@ -46,6 +45,8 @@ static struct alarm_base {
>  static ktime_t freezer_delta;
>  static DEFINE_SPINLOCK(freezer_delta_lock);
>  
> +static struct wakeup_source *ws;
> +
>  #ifdef CONFIG_RTC_CLASS
>  /* rtc timer and device for setting alarm wakeups at suspend */
>  static struct rtc_timer		rtctimer;
> @@ -130,50 +131,35 @@ static inline void alarmtimer_rtc_timer_init(void) { }
>   * @base: pointer to the base where the timer is being run
>   * @alarm: pointer to alarm being enqueued.
>   *
> - * Adds alarm to a alarm_base timerqueue and if necessary sets
> - * an hrtimer to run.
> + * Adds alarm to a alarm_base timerqueue
>   *
>   * Must hold base->lock when calling.
>   */
>  static void alarmtimer_enqueue(struct alarm_base *base, struct alarm *alarm)
>  {
> +	if (alarm->state & ALARMTIMER_STATE_ENQUEUED)
> +		timerqueue_del(&base->timerqueue, &alarm->node);
> +
>  	timerqueue_add(&base->timerqueue, &alarm->node);
>  	alarm->state |= ALARMTIMER_STATE_ENQUEUED;
> -
> -	if (&alarm->node == timerqueue_getnext(&base->timerqueue)) {
> -		hrtimer_try_to_cancel(&base->timer);
> -		hrtimer_start(&base->timer, alarm->node.expires,
> -				HRTIMER_MODE_ABS);
> -	}
>  }
>  
>  /**
> - * alarmtimer_remove - Removes an alarm timer from an alarm_base timerqueue
> + * alarmtimer_dequeue - Removes an alarm timer from an alarm_base timerqueue
>   * @base: pointer to the base where the timer is running
>   * @alarm: pointer to alarm being removed
>   *
> - * Removes alarm to a alarm_base timerqueue and if necessary sets
> - * a new timer to run.
> + * Removes alarm to a alarm_base timerqueue
>   *
>   * Must hold base->lock when calling.
>   */
> -static void alarmtimer_remove(struct alarm_base *base, struct alarm *alarm)
> +static void alarmtimer_dequeue(struct alarm_base *base, struct alarm *alarm)
>  {
> -	struct timerqueue_node *next = timerqueue_getnext(&base->timerqueue);
> -
>  	if (!(alarm->state & ALARMTIMER_STATE_ENQUEUED))
>  		return;
>  
>  	timerqueue_del(&base->timerqueue, &alarm->node);
>  	alarm->state &= ~ALARMTIMER_STATE_ENQUEUED;
> -
> -	if (next == &alarm->node) {
> -		hrtimer_try_to_cancel(&base->timer);
> -		next = timerqueue_getnext(&base->timerqueue);
> -		if (!next)
> -			return;
> -		hrtimer_start(&base->timer, next->expires, HRTIMER_MODE_ABS);
> -	}
>  }
>  
>  
> @@ -188,42 +174,23 @@ static void alarmtimer_remove(struct alarm_base *base, struct alarm *alarm)
>   */
>  static enum hrtimer_restart alarmtimer_fired(struct hrtimer *timer)
>  {
> -	struct alarm_base *base = container_of(timer, struct alarm_base, timer);
> -	struct timerqueue_node *next;
> +	struct alarm *alarm = container_of(timer, struct alarm, timer);
> +	struct alarm_base *base = &alarm_bases[alarm->type];
>  	unsigned long flags;
> -	ktime_t now;
>  	int ret = HRTIMER_NORESTART;
>  	int restart = ALARMTIMER_NORESTART;
>  
>  	spin_lock_irqsave(&base->lock, flags);
> -	now = base->gettime();
> -	while ((next = timerqueue_getnext(&base->timerqueue))) {
> -		struct alarm *alarm;
> -		ktime_t expired = next->expires;
> -
> -		if (expired.tv64 > now.tv64)
> -			break;
> -
> -		alarm = container_of(next, struct alarm, node);
> -
> -		timerqueue_del(&base->timerqueue, &alarm->node);
> -		alarm->state &= ~ALARMTIMER_STATE_ENQUEUED;
> -
> -		alarm->state |= ALARMTIMER_STATE_CALLBACK;
> -		spin_unlock_irqrestore(&base->lock, flags);
> -		if (alarm->function)
> -			restart = alarm->function(alarm, now);
> -		spin_lock_irqsave(&base->lock, flags);
> -		alarm->state &= ~ALARMTIMER_STATE_CALLBACK;
> +	alarmtimer_dequeue(base, alarm);
> +	spin_unlock_irqrestore(&base->lock, flags);
>  
> -		if (restart != ALARMTIMER_NORESTART) {
> -			timerqueue_add(&base->timerqueue, &alarm->node);
> -			alarm->state |= ALARMTIMER_STATE_ENQUEUED;
> -		}
> -	}
> +	if (alarm->function)
> +		restart = alarm->function(alarm, base->gettime());
>  
> -	if (next) {
> -		hrtimer_set_expires(&base->timer, next->expires);
> +	spin_lock_irqsave(&base->lock, flags);
> +	if (restart != ALARMTIMER_NORESTART) {
> +		hrtimer_set_expires(&alarm->timer, alarm->node.expires);
> +		alarmtimer_enqueue(base, alarm);
>  		ret = HRTIMER_RESTART;
>  	}
>  	spin_unlock_irqrestore(&base->lock, flags);
> @@ -250,6 +217,7 @@ static int alarmtimer_suspend(struct device *dev)
>  	unsigned long flags;
>  	struct rtc_device *rtc;
>  	int i;
> +	int ret;
>  
>  	spin_lock_irqsave(&freezer_delta_lock, flags);
>  	min = freezer_delta;
> @@ -279,8 +247,10 @@ static int alarmtimer_suspend(struct device *dev)
>  	if (min.tv64 == 0)
>  		return 0;
>  
> -	/* XXX - Should we enforce a minimum sleep time? */
> -	WARN_ON(min.tv64 < NSEC_PER_SEC);
> +	if (ktime_to_ns(min) < 2 * NSEC_PER_SEC) {
> +		__pm_wakeup_event(ws, 2 * MSEC_PER_SEC);
> +		return -EBUSY;
> +	}
>  
>  	/* Setup an rtc timer to fire that far in the future */
>  	rtc_timer_cancel(rtc, &rtctimer);
> @@ -288,9 +258,11 @@ static int alarmtimer_suspend(struct device *dev)
>  	now = rtc_tm_to_ktime(tm);
>  	now = ktime_add(now, min);
>  
> -	rtc_timer_start(rtc, &rtctimer, now, ktime_set(0, 0));
> -
> -	return 0;
> +	/* Set alarm, if in the past reject suspend briefly to handle */
> +	ret = rtc_timer_start(rtc, &rtctimer, now, ktime_set(0, 0));
> +	if (ret < 0)
> +		__pm_wakeup_event(ws, MSEC_PER_SEC);
> +	return ret;
>  }
>  #else
>  static int alarmtimer_suspend(struct device *dev)
> @@ -324,6 +296,9 @@ void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
>  		enum alarmtimer_restart (*function)(struct alarm *, ktime_t))
>  {
>  	timerqueue_init(&alarm->node);
> +	hrtimer_init(&alarm->timer, alarm_bases[type].base_clockid,
> +			HRTIMER_MODE_ABS);
> +	alarm->timer.function = alarmtimer_fired;
>  	alarm->function = function;
>  	alarm->type = type;
>  	alarm->state = ALARMTIMER_STATE_INACTIVE;
> @@ -334,17 +309,19 @@ void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
>   * @alarm: ptr to alarm to set
>   * @start: time to run the alarm
>   */
> -void alarm_start(struct alarm *alarm, ktime_t start)
> +int alarm_start(struct alarm *alarm, ktime_t start)
>  {
>  	struct alarm_base *base = &alarm_bases[alarm->type];
>  	unsigned long flags;
> +	int ret;
>  
>  	spin_lock_irqsave(&base->lock, flags);
> -	if (alarmtimer_active(alarm))
> -		alarmtimer_remove(base, alarm);
>  	alarm->node.expires = start;
>  	alarmtimer_enqueue(base, alarm);
> +	ret = hrtimer_start(&alarm->timer, alarm->node.expires,
> +				HRTIMER_MODE_ABS);
>  	spin_unlock_irqrestore(&base->lock, flags);
> +	return ret;
>  }
>  
>  /**
> @@ -358,18 +335,12 @@ int alarm_try_to_cancel(struct alarm *alarm)
>  {
>  	struct alarm_base *base = &alarm_bases[alarm->type];
>  	unsigned long flags;
> -	int ret = -1;
> -	spin_lock_irqsave(&base->lock, flags);
> -
> -	if (alarmtimer_callback_running(alarm))
> -		goto out;
> +	int ret;
>  
> -	if (alarmtimer_is_queued(alarm)) {
> -		alarmtimer_remove(base, alarm);
> -		ret = 1;
> -	} else
> -		ret = 0;
> -out:
> +	spin_lock_irqsave(&base->lock, flags);
> +	ret = hrtimer_try_to_cancel(&alarm->timer);
> +	if (ret >= 0)
> +		alarmtimer_dequeue(base, alarm);
>  	spin_unlock_irqrestore(&base->lock, flags);
>  	return ret;
>  }
> @@ -802,10 +773,6 @@ static int __init alarmtimer_init(void)
>  	for (i = 0; i < ALARM_NUMTYPE; i++) {
>  		timerqueue_init_head(&alarm_bases[i].timerqueue);
>  		spin_lock_init(&alarm_bases[i].lock);
> -		hrtimer_init(&alarm_bases[i].timer,
> -				alarm_bases[i].base_clockid,
> -				HRTIMER_MODE_ABS);
> -		alarm_bases[i].timer.function = alarmtimer_fired;
>  	}
>  
>  	error = alarmtimer_rtc_interface_setup();
> @@ -821,6 +788,7 @@ static int __init alarmtimer_init(void)
>  		error = PTR_ERR(pdev);
>  		goto out_drv;
>  	}
> +	ws = wakeup_source_register("alarmtimer");
>  	return 0;
>  
>  out_drv:
> diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
> index 46da053..6629bf7 100644
> --- a/kernel/time/jiffies.c
> +++ b/kernel/time/jiffies.c
> @@ -37,7 +37,7 @@
>   * requested HZ value. It is also not recommended
>   * for "tick-less" systems.
>   */
> -#define NSEC_PER_JIFFY	((u32)((((u64)NSEC_PER_SEC)<<8)/SHIFTED_HZ))
> +#define NSEC_PER_JIFFY	((NSEC_PER_SEC+HZ/2)/HZ)
>  
>  /* Since jiffies uses a simple NSEC_PER_JIFFY multiplier
>   * conversion, the .shift value could be zero. However
> @@ -95,3 +95,33 @@ struct clocksource * __init __weak clocksource_default_clock(void)
>  {
>  	return &clocksource_jiffies;
>  }
> +
> +struct clocksource refined_jiffies;
> +
> +int register_refined_jiffies(long cycles_per_second)
> +{
> +	u64 nsec_per_tick, shift_hz;
> +	long cycles_per_tick;
> +
> +
> +
> +	refined_jiffies = clocksource_jiffies;
> +	refined_jiffies.name = "refined-jiffies";
> +	refined_jiffies.rating++;
> +
> +	/* Calc cycles per tick */
> +	cycles_per_tick = (cycles_per_second + HZ/2)/HZ;
> +	/* shift_hz stores hz<<8 for extra accuracy */
> +	shift_hz = (u64)cycles_per_second << 8;
> +	shift_hz += cycles_per_tick/2;
> +	do_div(shift_hz, cycles_per_tick);
> +	/* Calculate nsec_per_tick using shift_hz */
> +	nsec_per_tick = (u64)NSEC_PER_SEC << 8;
> +	nsec_per_tick += (u32)shift_hz/2;
> +	do_div(nsec_per_tick, (u32)shift_hz);
> +
> +	refined_jiffies.mult = ((u32)nsec_per_tick) << JIFFIES_SHIFT;
> +
> +	clocksource_register(&refined_jiffies);
> +	return 0;
> +}
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index d3b91e7..3eb3fc7c 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -8,6 +8,7 @@
>   *
>   */
>  
> +#include <linux/timekeeper_internal.h>
>  #include <linux/module.h>
>  #include <linux/interrupt.h>
>  #include <linux/percpu.h>
> @@ -21,61 +22,6 @@
>  #include <linux/tick.h>
>  #include <linux/stop_machine.h>
>  
> -/* Structure holding internal timekeeping values. */
> -struct timekeeper {
> -	/* Current clocksource used for timekeeping. */
> -	struct clocksource	*clock;
> -	/* NTP adjusted clock multiplier */
> -	u32			mult;
> -	/* The shift value of the current clocksource. */
> -	u32			shift;
> -	/* Number of clock cycles in one NTP interval. */
> -	cycle_t			cycle_interval;
> -	/* Number of clock shifted nano seconds in one NTP interval. */
> -	u64			xtime_interval;
> -	/* shifted nano seconds left over when rounding cycle_interval */
> -	s64			xtime_remainder;
> -	/* Raw nano seconds accumulated per NTP interval. */
> -	u32			raw_interval;
> -
> -	/* Current CLOCK_REALTIME time in seconds */
> -	u64			xtime_sec;
> -	/* Clock shifted nano seconds */
> -	u64			xtime_nsec;
> -
> -	/* Difference between accumulated time and NTP time in ntp
> -	 * shifted nano seconds. */
> -	s64			ntp_error;
> -	/* Shift conversion between clock shifted nano seconds and
> -	 * ntp shifted nano seconds. */
> -	u32			ntp_error_shift;
> -
> -	/*
> -	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
> -	 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
> -	 * at zero at system boot time, so wall_to_monotonic will be negative,
> -	 * however, we will ALWAYS keep the tv_nsec part positive so we can use
> -	 * the usual normalization.
> -	 *
> -	 * wall_to_monotonic is moved after resume from suspend for the
> -	 * monotonic time not to jump. We need to add total_sleep_time to
> -	 * wall_to_monotonic to get the real boot based time offset.
> -	 *
> -	 * - wall_to_monotonic is no longer the boot time, getboottime must be
> -	 * used instead.
> -	 */
> -	struct timespec		wall_to_monotonic;
> -	/* Offset clock monotonic -> clock realtime */
> -	ktime_t			offs_real;
> -	/* time spent in suspend */
> -	struct timespec		total_sleep_time;
> -	/* Offset clock monotonic -> clock boottime */
> -	ktime_t			offs_boot;
> -	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
> -	struct timespec		raw_time;
> -	/* Seqlock for all timekeeper values */
> -	seqlock_t		lock;
> -};
>  
>  static struct timekeeper timekeeper;
>  
> @@ -96,15 +42,6 @@ static inline void tk_normalize_xtime(struct timekeeper *tk)
>  	}
>  }
>  
> -static struct timespec tk_xtime(struct timekeeper *tk)
> -{
> -	struct timespec ts;
> -
> -	ts.tv_sec = tk->xtime_sec;
> -	ts.tv_nsec = (long)(tk->xtime_nsec >> tk->shift);
> -	return ts;
> -}
> -
>  static void tk_set_xtime(struct timekeeper *tk, const struct timespec *ts)
>  {
>  	tk->xtime_sec = ts->tv_sec;
> @@ -246,14 +183,11 @@ static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
>  /* must hold write on timekeeper.lock */
>  static void timekeeping_update(struct timekeeper *tk, bool clearntp)
>  {
> -	struct timespec xt;
> -
>  	if (clearntp) {
>  		tk->ntp_error = 0;
>  		ntp_clear();
>  	}
> -	xt = tk_xtime(tk);
> -	update_vsyscall(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
> +	update_vsyscall(tk);
>  }
>  
>  /**
> @@ -1111,7 +1045,7 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
>  	accumulate_nsecs_to_secs(tk);
>  
>  	/* Accumulate raw time */
> -	raw_nsecs = tk->raw_interval << shift;
> +	raw_nsecs = (u64)tk->raw_interval << shift;
>  	raw_nsecs += tk->raw_time.tv_nsec;
>  	if (raw_nsecs >= NSEC_PER_SEC) {
>  		u64 raw_secs = raw_nsecs;
> @@ -1128,6 +1062,33 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
>  	return offset;
>  }
>  
> +#ifdef CONFIG_GENERIC_TIME_VSYSCALL_OLD
> +static inline void old_vsyscall_fixup(struct timekeeper *tk)
> +{
> +	s64 remainder;
> +
> +	/*
> +	* Store only full nanoseconds into xtime_nsec after rounding
> +	* it up and add the remainder to the error difference.
> +	* XXX - This is necessary to avoid small 1ns inconsistnecies caused
> +	* by truncating the remainder in vsyscalls. However, it causes
> +	* additional work to be done in timekeeping_adjust(). Once
> +	* the vsyscall implementations are converted to use xtime_nsec
> +	* (shifted nanoseconds), and CONFIG_GENERIC_TIME_VSYSCALL_OLD
> +	* users are removed, this can be killed.
> +	*/
> +	remainder = tk->xtime_nsec & ((1ULL << tk->shift) - 1);
> +	tk->xtime_nsec -= remainder;
> +	tk->xtime_nsec += 1ULL << tk->shift;
> +	tk->ntp_error += remainder << tk->ntp_error_shift;
> +
> +}
> +#else
> +#define old_vsyscall_fixup(tk)
> +#endif
> +
> +
> +
>  /**
>   * update_wall_time - Uses the current clocksource to increment the wall time
>   *
> @@ -1139,7 +1100,6 @@ static void update_wall_time(void)
>  	cycle_t offset;
>  	int shift = 0, maxshift;
>  	unsigned long flags;
> -	s64 remainder;
>  
>  	write_seqlock_irqsave(&tk->lock, flags);
>  
> @@ -1181,20 +1141,11 @@ static void update_wall_time(void)
>  	/* correct the clock when NTP error is too big */
>  	timekeeping_adjust(tk, offset);
>  
> -
>  	/*
> -	* Store only full nanoseconds into xtime_nsec after rounding
> -	* it up and add the remainder to the error difference.
> -	* XXX - This is necessary to avoid small 1ns inconsistnecies caused
> -	* by truncating the remainder in vsyscalls. However, it causes
> -	* additional work to be done in timekeeping_adjust(). Once
> -	* the vsyscall implementations are converted to use xtime_nsec
> -	* (shifted nanoseconds), this can be killed.
> -	*/
> -	remainder = tk->xtime_nsec & ((1ULL << tk->shift) - 1);
> -	tk->xtime_nsec -= remainder;
> -	tk->xtime_nsec += 1ULL << tk->shift;
> -	tk->ntp_error += remainder << tk->ntp_error_shift;
> +	 * XXX This can be killed once everyone converts
> +	 * to the new update_vsyscall.
> +	 */
> +	old_vsyscall_fixup(tk);
>  
>  	/*
>  	 * Finally, make sure that after the rounding
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 8c5e7b9..367d008 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -63,6 +63,7 @@ EXPORT_SYMBOL(jiffies_64);
>  #define TVR_SIZE (1 << TVR_BITS)
>  #define TVN_MASK (TVN_SIZE - 1)
>  #define TVR_MASK (TVR_SIZE - 1)
> +#define MAX_TVAL ((unsigned long)((1ULL << (TVR_BITS + 4*TVN_BITS)) - 1))
>  
>  struct tvec {
>  	struct list_head vec[TVN_SIZE];
> @@ -92,24 +93,25 @@ static DEFINE_PER_CPU(struct tvec_base *, tvec_bases) = &boot_tvec_bases;
>  /* Functions below help us manage 'deferrable' flag */
>  static inline unsigned int tbase_get_deferrable(struct tvec_base *base)
>  {
> -	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
> +	return ((unsigned int)(unsigned long)base & TIMER_DEFERRABLE);
>  }
>  
> -static inline struct tvec_base *tbase_get_base(struct tvec_base *base)
> +static inline unsigned int tbase_get_irqsafe(struct tvec_base *base)
>  {
> -	return ((struct tvec_base *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
> +	return ((unsigned int)(unsigned long)base & TIMER_IRQSAFE);
>  }
>  
> -static inline void timer_set_deferrable(struct timer_list *timer)
> +static inline struct tvec_base *tbase_get_base(struct tvec_base *base)
>  {
> -	timer->base = TBASE_MAKE_DEFERRED(timer->base);
> +	return ((struct tvec_base *)((unsigned long)base & ~TIMER_FLAG_MASK));
>  }
>  
>  static inline void
>  timer_set_base(struct timer_list *timer, struct tvec_base *new_base)
>  {
> -	timer->base = (struct tvec_base *)((unsigned long)(new_base) |
> -				      tbase_get_deferrable(timer->base));
> +	unsigned long flags = (unsigned long)timer->base & TIMER_FLAG_MASK;
> +
> +	timer->base = (struct tvec_base *)((unsigned long)(new_base) | flags);
>  }
>  
>  static unsigned long round_jiffies_common(unsigned long j, int cpu,
> @@ -358,11 +360,12 @@ __internal_add_timer(struct tvec_base *base, struct timer_list *timer)
>  		vec = base->tv1.vec + (base->timer_jiffies & TVR_MASK);
>  	} else {
>  		int i;
> -		/* If the timeout is larger than 0xffffffff on 64-bit
> -		 * architectures then we use the maximum timeout:
> +		/* If the timeout is larger than MAX_TVAL (on 64-bit
> +		 * architectures or with CONFIG_BASE_SMALL=1) then we
> +		 * use the maximum timeout.
>  		 */
> -		if (idx > 0xffffffffUL) {
> -			idx = 0xffffffffUL;
> +		if (idx > MAX_TVAL) {
> +			idx = MAX_TVAL;
>  			expires = idx + base->timer_jiffies;
>  		}
>  		i = (expires >> (TVR_BITS + 3 * TVN_BITS)) & TVN_MASK;
> @@ -563,16 +566,14 @@ static inline void debug_timer_assert_init(struct timer_list *timer)
>  	debug_object_assert_init(timer, &timer_debug_descr);
>  }
>  
> -static void __init_timer(struct timer_list *timer,
> -			 const char *name,
> -			 struct lock_class_key *key);
> +static void do_init_timer(struct timer_list *timer, unsigned int flags,
> +			  const char *name, struct lock_class_key *key);
>  
> -void init_timer_on_stack_key(struct timer_list *timer,
> -			     const char *name,
> -			     struct lock_class_key *key)
> +void init_timer_on_stack_key(struct timer_list *timer, unsigned int flags,
> +			     const char *name, struct lock_class_key *key)
>  {
>  	debug_object_init_on_stack(timer, &timer_debug_descr);
> -	__init_timer(timer, name, key);
> +	do_init_timer(timer, flags, name, key);
>  }
>  EXPORT_SYMBOL_GPL(init_timer_on_stack_key);
>  
> @@ -613,12 +614,13 @@ static inline void debug_assert_init(struct timer_list *timer)
>  	debug_timer_assert_init(timer);
>  }
>  
> -static void __init_timer(struct timer_list *timer,
> -			 const char *name,
> -			 struct lock_class_key *key)
> +static void do_init_timer(struct timer_list *timer, unsigned int flags,
> +			  const char *name, struct lock_class_key *key)
>  {
> +	struct tvec_base *base = __raw_get_cpu_var(tvec_bases);
> +
>  	timer->entry.next = NULL;
> -	timer->base = __raw_get_cpu_var(tvec_bases);
> +	timer->base = (void *)((unsigned long)base | flags);
>  	timer->slack = -1;
>  #ifdef CONFIG_TIMER_STATS
>  	timer->start_site = NULL;
> @@ -628,22 +630,10 @@ static void __init_timer(struct timer_list *timer,
>  	lockdep_init_map(&timer->lockdep_map, name, key, 0);
>  }
>  
> -void setup_deferrable_timer_on_stack_key(struct timer_list *timer,
> -					 const char *name,
> -					 struct lock_class_key *key,
> -					 void (*function)(unsigned long),
> -					 unsigned long data)
> -{
> -	timer->function = function;
> -	timer->data = data;
> -	init_timer_on_stack_key(timer, name, key);
> -	timer_set_deferrable(timer);
> -}
> -EXPORT_SYMBOL_GPL(setup_deferrable_timer_on_stack_key);
> -
>  /**
>   * init_timer_key - initialize a timer
>   * @timer: the timer to be initialized
> + * @flags: timer flags
>   * @name: name of the timer
>   * @key: lockdep class key of the fake lock used for tracking timer
>   *       sync lock dependencies
> @@ -651,24 +641,14 @@ EXPORT_SYMBOL_GPL(setup_deferrable_timer_on_stack_key);
>   * init_timer_key() must be done to a timer prior calling *any* of the
>   * other timer functions.
>   */
> -void init_timer_key(struct timer_list *timer,
> -		    const char *name,
> -		    struct lock_class_key *key)
> +void init_timer_key(struct timer_list *timer, unsigned int flags,
> +		    const char *name, struct lock_class_key *key)
>  {
>  	debug_init(timer);
> -	__init_timer(timer, name, key);
> +	do_init_timer(timer, flags, name, key);
>  }
>  EXPORT_SYMBOL(init_timer_key);
>  
> -void init_timer_deferrable_key(struct timer_list *timer,
> -			       const char *name,
> -			       struct lock_class_key *key)
> -{
> -	init_timer_key(timer, name, key);
> -	timer_set_deferrable(timer);
> -}
> -EXPORT_SYMBOL(init_timer_deferrable_key);
> -
>  static inline void detach_timer(struct timer_list *timer, bool clear_pending)
>  {
>  	struct list_head *entry = &timer->entry;
> @@ -686,7 +666,7 @@ detach_expired_timer(struct timer_list *timer, struct tvec_base *base)
>  {
>  	detach_timer(timer, true);
>  	if (!tbase_get_deferrable(timer->base))
> -		timer->base->active_timers--;
> +		base->active_timers--;
>  }
>  
>  static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
> @@ -697,7 +677,7 @@ static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
>  
>  	detach_timer(timer, clear_pending);
>  	if (!tbase_get_deferrable(timer->base)) {
> -		timer->base->active_timers--;
> +		base->active_timers--;
>  		if (timer->expires == base->next_timer)
>  			base->next_timer = base->timer_jiffies;
>  	}
> @@ -1029,14 +1009,14 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
>   *
>   * Synchronization rules: Callers must prevent restarting of the timer,
>   * otherwise this function is meaningless. It must not be called from
> - * interrupt contexts. The caller must not hold locks which would prevent
> - * completion of the timer's handler. The timer's handler must not call
> - * add_timer_on(). Upon exit the timer is not queued and the handler is
> - * not running on any CPU.
> + * interrupt contexts unless the timer is an irqsafe one. The caller must
> + * not hold locks which would prevent completion of the timer's
> + * handler. The timer's handler must not call add_timer_on(). Upon exit the
> + * timer is not queued and the handler is not running on any CPU.
>   *
> - * Note: You must not hold locks that are held in interrupt context
> - *   while calling this function. Even if the lock has nothing to do
> - *   with the timer in question.  Here's why:
> + * Note: For !irqsafe timers, you must not hold locks that are held in
> + *   interrupt context while calling this function. Even if the lock has
> + *   nothing to do with the timer in question.  Here's why:
>   *
>   *    CPU0                             CPU1
>   *    ----                             ----
> @@ -1073,7 +1053,7 @@ int del_timer_sync(struct timer_list *timer)
>  	 * don't use it in hardirq context, because it
>  	 * could lead to deadlock.
>  	 */
> -	WARN_ON(in_irq());
> +	WARN_ON(in_irq() && !tbase_get_irqsafe(timer->base));
>  	for (;;) {
>  		int ret = try_to_del_timer_sync(timer);
>  		if (ret >= 0)
> @@ -1180,19 +1160,27 @@ static inline void __run_timers(struct tvec_base *base)
>  		while (!list_empty(head)) {
>  			void (*fn)(unsigned long);
>  			unsigned long data;
> +			bool irqsafe;
>  
>  			timer = list_first_entry(head, struct timer_list,entry);
>  			fn = timer->function;
>  			data = timer->data;
> +			irqsafe = tbase_get_irqsafe(timer->base);
>  
>  			timer_stats_account_timer(timer);
>  
>  			base->running_timer = timer;
>  			detach_expired_timer(timer, base);
>  
> -			spin_unlock_irq(&base->lock);
> -			call_timer_fn(timer, fn, data);
> -			spin_lock_irq(&base->lock);
> +			if (irqsafe) {
> +				spin_unlock(&base->lock);
> +				call_timer_fn(timer, fn, data);
> +				spin_lock(&base->lock);
> +			} else {
> +				spin_unlock_irq(&base->lock);
> +				call_timer_fn(timer, fn, data);
> +				spin_lock_irq(&base->lock);
> +			}
>  		}
>  	}
>  	base->running_timer = NULL;
> @@ -1791,9 +1779,13 @@ static struct notifier_block __cpuinitdata timers_nb = {
>  
>  void __init init_timers(void)
>  {
> -	int err = timer_cpu_notify(&timers_nb, (unsigned long)CPU_UP_PREPARE,
> -				(void *)(long)smp_processor_id());
> +	int err;
> +
> +	/* ensure there are enough low bits for flags in timer->base pointer */
> +	BUILD_BUG_ON(__alignof__(struct tvec_base) & TIMER_FLAG_MASK);
>  
> +	err = timer_cpu_notify(&timers_nb, (unsigned long)CPU_UP_PREPARE,
> +			       (void *)(long)smp_processor_id());
>  	init_timer_stats();
>  
>  	BUG_ON(err != NOTIFY_OK);
> 
