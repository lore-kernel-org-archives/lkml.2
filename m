Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2BRXVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 18:21:40 -0500
Received: from claw.goop.org ([74.207.240.146]:34572 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab2BRXVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 18:21:13 -0500
Message-ID: <4F403268.7040804@goop.org>
Date: Sat, 18 Feb 2012 15:21:12 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Tejun Heo <tj@kernel.org>, John Stultz <johnstul@us.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 1/1] linux headers: header file(s) changes to enable spinlock
 use jumplabel
References: <20120217082527.15283.72980.sendpatchset@oc5400248562.ibm.com>
In-Reply-To: <20120217082527.15283.72980.sendpatchset@oc5400248562.ibm.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2012 12:25 AM, Raghavendra K T wrote:
> From:  Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>
> Changelog:
>   Reordering in header files and adding declarations to enable
>  spinlock header to use jump label technique.
>     
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  I was re-basing Jermey patches (https://lkml.org/lkml/2011/10/12/496), while working
> on paravirtualized ticket spinlock (3.3.-rc3).
>
> Currently <jump_label.h> includes <workqueue.h> (commit: b202952075f62603bea9bfb6ebc6b0420db11949)
>
>  So we get following error when we try to include jump_label.h from
> arch/x86/include/asm/spinlock.h because of cyclic dependency
> <spinlock.h> -> <jumplabe.h> -> <workque.h> -> ... <seqlock.h> -> <spinlock.h>

What about splitting the jump_label_key_deferred stuff into a separate
jump_label_deferred.h, and just include that where it's needed?

J

>
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CC      arch/x86/kernel/asm-offsets.s
> In file included from include/linux/time.h:8:0,
>                  from include/linux/ktime.h:24,
>                  from include/linux/timer.h:5,
>                  from include/linux/workqueue.h:8,
>                  from include/linux/jump_label.h:6,
>                  from /home/raghu/linux-3.3-rc3/arch/x86/include/asm/spinlock.h:4,
>                  from include/linux/spinlock.h:87,
>                  from include/linux/mmzone.h:7,
>                  from include/linux/gfp.h:4,
>                  from include/linux/slab.h:12,
>                  from include/linux/crypto.h:23,
>                  from arch/x86/kernel/asm-offsets.c:8:
> include/linux/seqlock.h: In function ‘write_seqlock’:
> include/linux/seqlock.h:60:2: error: implicit declaration of function ‘spin_lock’ [-Werror=implicit-function-declaration]
> include/linux/seqlock.h: In function ‘write_sequnlock’:
> include/linux/seqlock.h:69:2: error: implicit declaration of function ‘spin_unlock’ [-Werror=implicit-function-declaration]
> include/linux/seqlock.h: In function ‘write_tryseqlock’:
> include/linux/seqlock.h:74:2: error: implicit declaration of function ‘spin_trylock’ [-Werror=implicit-function-declaration]
> In file included from include/linux/mmzone.h:7:0,
>                  from include/linux/gfp.h:4,
>                  from include/linux/slab.h:12,
>                  from include/linux/crypto.h:23,
>                  from arch/x86/kernel/asm-offsets.c:8:
> include/linux/spinlock.h: At top level:
> include/linux/spinlock.h:283:20: warning: conflicting types for ‘spin_lock’ [enabled by default]
> include/linux/spinlock.h:283:20: error: static declaration of ‘spin_lock’ follows non-static declaration
> include/linux/seqlock.h:60:2: note: previous implicit declaration of ‘spin_lock’ was here
> include/linux/spinlock.h:293:19: error: static declaration of ‘spin_trylock’ follows non-static declaration
> include/linux/seqlock.h:74:12: note: previous implicit declaration of ‘spin_trylock’ was here
> include/linux/spinlock.h:323:20: warning: conflicting types for ‘spin_unlock’ [enabled by default]
> include/linux/spinlock.h:323:20: error: static declaration of ‘spin_unlock’ follows non-static declaration
> include/linux/seqlock.h:69:2: note: previous implicit declaration of ‘spin_unlock’ was here
> cc1: some warnings being treated as errors
>
> make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2
>
> The patch below fixes it. (Is there any alternative? But this patch is needed before paravirt
> ticket-spinlock can go in :( ).
>
> Tesing:
> Compile tested with i386 defconfig and  x86_64 defconfig. Below result is for x86_64
>
> size Before the patch
> ================
>    text	   data	    bss	    dec	    hex	filename
> 9901730	 937168	1146880	11985778	 b6e372	vmlinux
>
> size After the patch
> ================
>    text	   data	    bss	    dec	    hex	filename
> 9901730	 937168	1146880	11985778	 b6e372	vmlinux
>
>  include/linux/ktime.h     |    2 ++
>  include/linux/seqlock.h   |    4 ++++
>  include/linux/time.h      |   20 +++++++++++---------
>  include/linux/timer.h     |    4 ++--
>  include/linux/timex.h     |   11 ++++++-----
>  include/linux/workqueue.h |    3 +++
>  6 files changed, 28 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/ktime.h b/include/linux/ktime.h
> index 603bec2..90547eb 100644
> --- a/include/linux/ktime.h
> +++ b/include/linux/ktime.h
> @@ -289,6 +289,8 @@ static inline int ktime_equal(const ktime_t cmp1, const ktime_t cmp2)
>  	return cmp1.tv64 == cmp2.tv64;
>  }
>  
> +extern struct timeval ns_to_timeval(const s64 nsec);
> +
>  static inline s64 ktime_to_us(const ktime_t kt)
>  {
>  	struct timeval tv = ktime_to_timeval(kt);
> diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
> index c6db9fb..5b4a9e9 100644
> --- a/include/linux/seqlock.h
> +++ b/include/linux/seqlock.h
> @@ -51,6 +51,10 @@ typedef struct {
>  #define DEFINE_SEQLOCK(x) \
>  		seqlock_t x = __SEQLOCK_UNLOCKED(x)
>  
> +static inline void spin_lock(spinlock_t *lock);
> +static inline int spin_trylock(spinlock_t *lock);
> +static inline void spin_unlock(spinlock_t *lock);
> +
>  /* Lock out other writers and update the count.
>   * Acts like a normal spin_lock/unlock.
>   * Don't need preempt_disable() because that is in the spin_lock already.
> diff --git a/include/linux/time.h b/include/linux/time.h
> index b306178..b3ce366 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -3,12 +3,6 @@
>  
>  #include <linux/types.h>
>  
> -#ifdef __KERNEL__
> -# include <linux/cache.h>
> -# include <linux/seqlock.h>
> -# include <linux/math64.h>
> -#endif
> -
>  #ifndef _STRUCT_TIMESPEC
>  #define _STRUCT_TIMESPEC
>  struct timespec {
> @@ -28,9 +22,6 @@ struct timezone {
>  };
>  
>  #ifdef __KERNEL__
> -
> -extern struct timezone sys_tz;
> -
>  /* Parameters used to convert the timespec values: */
>  #define MSEC_PER_SEC	1000L
>  #define USEC_PER_MSEC	1000L
> @@ -42,6 +33,17 @@ extern struct timezone sys_tz;
>  
>  #define TIME_T_MAX	(time_t)((1UL << ((sizeof(time_t) << 3) - 1)) - 1)
>  
> +# include <linux/cache.h>
> +# include <linux/seqlock.h>
> +# include <linux/math64.h>
> +#endif
> +
> +
> +#ifdef __KERNEL__
> +
> +extern struct timezone sys_tz;
> +
> +
>  static inline int timespec_equal(const struct timespec *a,
>                                   const struct timespec *b)
>  {
> diff --git a/include/linux/timer.h b/include/linux/timer.h
> index 6abd913..25bd863 100644
> --- a/include/linux/timer.h
> +++ b/include/linux/timer.h
> @@ -2,9 +2,7 @@
>  #define _LINUX_TIMER_H
>  
>  #include <linux/list.h>
> -#include <linux/ktime.h>
>  #include <linux/stddef.h>
> -#include <linux/debugobjects.h>
>  #include <linux/stringify.h>
>  
>  struct tvec_base;
> @@ -33,6 +31,8 @@ struct timer_list {
>  #endif
>  };
>  
> +#include <linux/ktime.h>
> +#include <linux/debugobjects.h>
>  extern struct tvec_base boot_tvec_bases;
>  
>  #ifdef CONFIG_LOCKDEP
> diff --git a/include/linux/timex.h b/include/linux/timex.h
> index aa60fe7..91ef0fa 100644
> --- a/include/linux/timex.h
> +++ b/include/linux/timex.h
> @@ -53,6 +53,12 @@
>  #ifndef _LINUX_TIMEX_H
>  #define _LINUX_TIMEX_H
>  
> +#ifdef __KERNEL__
> +/* The clock frequency of the i8253/i8254 PIT */
> +#define PIT_TICK_RATE 1193182ul
> +#include <asm/timex.h>
> +#endif /* __KERNEL__ */
> +
>  #include <linux/time.h>
>  
>  #define NTP_API		4	/* NTP API version */
> @@ -171,8 +177,6 @@ struct timex {
>  #include <linux/types.h>
>  #include <linux/param.h>
>  
> -#include <asm/timex.h>
> -
>  /*
>   * SHIFT_PLL is used as a dampening factor to define how much we
>   * adjust the frequency correction for a given offset in PLL mode.
> @@ -273,9 +277,6 @@ extern void hardpps(const struct timespec *, const struct timespec *);
>  
>  int read_current_timer(unsigned long *timer_val);
>  
> -/* The clock frequency of the i8253/i8254 PIT */
> -#define PIT_TICK_RATE 1193182ul
> -
>  #endif /* KERNEL */
>  
>  #endif /* LINUX_TIMEX_H */
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index eb8b9f1..ba1588e 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -397,6 +397,9 @@ extern bool workqueue_congested(unsigned int cpu, struct workqueue_struct *wq);
>  extern unsigned int work_cpu(struct work_struct *work);
>  extern unsigned int work_busy(struct work_struct *work);
>  
> +extern int del_timer_sync(struct timer_list *timer);
> +extern int del_timer(struct timer_list *timer);
> +
>  /*
>   * Kill off a pending schedule_delayed_work().  Note that the work callback
>   * function may still be running on return from cancel_delayed_work(), unless
>

