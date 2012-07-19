Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2GSJdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:33:14 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44312 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2GSJdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:33:11 -0400
Date: Thu, 19 Jul 2012 11:33:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] time: Cleanup offs_real/wall_to_mono and
 offs_boot/total_sleep_time updates
Message-ID: <20120719093305.GA27086@gmail.com>
References: <1342660753-10382-1-git-send-email-john.stultz@linaro.org>
 <1342660753-10382-3-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342660753-10382-3-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> For performance reasons, we maintain ktime_t based duplicates of
> wall_to_monotonic (offs_real) and total_sleep_time (offs_boot).
> 
> Since large problems could occur (such as the resume regression
> on 3.5-rc7, or the leapsecond hrtimer issue) if these value pairs
> were to be inconsistently updated, this patch this cleans up how
> we modify these value pairs to ensure we are always consistent.
> 
> As a side-effect this is also more efficient as we only
> caulculate the duplicate values when they are changed,
> rather then every update_wall_time call.

Makes sense.

> This also provides WARN_ONs to detect if future changes break
> the invariants.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Prarit Bhargava <prarit@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  kernel/time/timekeeping.c |   94 ++++++++++++++++++++++++++++-----------------
>  1 file changed, 59 insertions(+), 35 deletions(-)
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index f045cc5..0b780bd 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -65,14 +65,14 @@ struct timekeeper {
>  	 * used instead.
>  	 */
>  	struct timespec		wall_to_monotonic;
> -	/* time spent in suspend */
> -	struct timespec		total_sleep_time;
> -	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
> -	struct timespec		raw_time;
>  	/* Offset clock monotonic -> clock realtime */
>  	ktime_t			offs_real;
> +	/* time spent in suspend */
> +	struct timespec		total_sleep_time;
>  	/* Offset clock monotonic -> clock boottime */
>  	ktime_t			offs_boot;
> +	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
> +	struct timespec		raw_time;
>  	/* Seqlock for all timekeeper values */
>  	seqlock_t		lock;
>  };
> @@ -117,6 +117,36 @@ static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)
>  	tk->xtime_nsec += ts->tv_nsec << tk->shift;
>  }
>  
> +

Stray newline.

> +static void tk_set_wall_to_mono(struct timekeeper *tk, struct timespec wtm)
> +{
> +	struct timespec tmp;
> +
> +	/*
> +	 * Verify consistency of: offset_real = -wall_to_monotonic
> +	 * before modifying anything
> +	 */
> +	set_normalized_timespec(&tmp, -tk->wall_to_monotonic.tv_sec,
> +					-tk->wall_to_monotonic.tv_nsec);
> +	WARN_ON_ONCE(tk->offs_real.tv64 != timespec_to_ktime(tmp).tv64);
> +	tk->wall_to_monotonic = wtm;
> +	set_normalized_timespec(&tmp, -wtm.tv_sec, -wtm.tv_nsec);
> +	tk->offs_real = timespec_to_ktime(tmp);
> +}
> +
> +

Stray newline.

> +static void tk_set_sleep_time(struct timekeeper *tk, struct timespec t)
> +{
> +	/* Verify consistency before modifying */
> +	WARN_ON_ONCE(tk->offs_boot.tv64 !=
> +				timespec_to_ktime(tk->total_sleep_time).tv64);

asserts like this can be put into a single line - we rarely need 
to read them if they don't trigger - and making them 
non-intrusive oneliners is a bonus.

> +
> +	tk->total_sleep_time = t;
> +	tk->offs_boot = timespec_to_ktime(t);
> +}
> +
> +
> +

Stray newlines.

>  /**
>   * timekeeper_setup_internals - Set up internals to use clocksource clock.
>   *
> @@ -217,13 +247,6 @@ static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
>  	return nsec + arch_gettimeoffset();
>  }
>  
> -static void update_rt_offset(struct timekeeper *tk)
> -{
> -	struct timespec tmp, *wtm = &tk->wall_to_monotonic;
> -
> -	set_normalized_timespec(&tmp, -wtm->tv_sec, -wtm->tv_nsec);
> -	tk->offs_real = timespec_to_ktime(tmp);
> -}
>  
>  /* must hold write on timekeeper.lock */
>  static void timekeeping_update(struct timekeeper *tk, bool clearntp)
> @@ -234,7 +257,6 @@ static void timekeeping_update(struct timekeeper *tk, bool clearntp)
>  		tk->ntp_error = 0;
>  		ntp_clear();
>  	}
> -	update_rt_offset(tk);
>  	xt = tk_xtime(tk);
>  	update_vsyscall(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
>  }
> @@ -420,8 +442,8 @@ int do_settimeofday(const struct timespec *tv)
>  	ts_delta.tv_sec = tv->tv_sec - xt.tv_sec;
>  	ts_delta.tv_nsec = tv->tv_nsec - xt.tv_nsec;
>  
> -	timekeeper.wall_to_monotonic =
> -			timespec_sub(timekeeper.wall_to_monotonic, ts_delta);
> +	tk_set_wall_to_mono(&timekeeper,
> +			timespec_sub(timekeeper.wall_to_monotonic, ts_delta));
>  
>  	tk_set_xtime(&timekeeper, tv);
>  
> @@ -456,8 +478,8 @@ int timekeeping_inject_offset(struct timespec *ts)
>  
>  
>  	tk_xtime_add(&timekeeper, ts);
> -	timekeeper.wall_to_monotonic =
> -				timespec_sub(timekeeper.wall_to_monotonic, *ts);
> +	tk_set_wall_to_mono(&timekeeper,
> +			timespec_sub(timekeeper.wall_to_monotonic, *ts));

There's a *lot* of unnecessary ugliness here and in many other 
places in kernel/time/ due to repeating patterns of 
"timekeeper.", which gets repeated many times and blows up line 
length.

Please add this to the highest level (system call, irq handler, 
etc.) code:

	struct timekeeper *tk = &timekeeper;

and pass that down to lower levels. The tk-> pattern will be the 
obvious thing to type in typical time handling functions.

This increases readability and clarifies the data flow and might 
bring other advantages in the future.

>  	timekeeping_update(&timekeeper, true);
>  
> @@ -624,7 +646,7 @@ void __init timekeeping_init(void)
>  {
>  	struct clocksource *clock;
>  	unsigned long flags;
> -	struct timespec now, boot;
> +	struct timespec now, boot, tmp;
>  
>  	read_persistent_clock(&now);
>  	read_boot_clock(&boot);
> @@ -645,23 +667,19 @@ void __init timekeeping_init(void)
>  	if (boot.tv_sec == 0 && boot.tv_nsec == 0)
>  		boot = tk_xtime(&timekeeper);
>  
> -	set_normalized_timespec(&timekeeper.wall_to_monotonic,
> -				-boot.tv_sec, -boot.tv_nsec);
> -	update_rt_offset(&timekeeper);
> -	timekeeper.total_sleep_time.tv_sec = 0;
> -	timekeeper.total_sleep_time.tv_nsec = 0;
> +	set_normalized_timespec(&tmp, -boot.tv_sec, -boot.tv_nsec);
> +	tk_set_wall_to_mono(&timekeeper, tmp);
> +
> +	tmp.tv_sec = 0;
> +	tmp.tv_nsec = 0;
> +	tk_set_sleep_time(&timekeeper, tmp);
> +
>  	write_sequnlock_irqrestore(&timekeeper.lock, flags);
>  }
>  
>  /* time in seconds when suspend began */
>  static struct timespec timekeeping_suspend_time;
>  
> -static void update_sleep_time(struct timespec t)
> -{
> -	timekeeper.total_sleep_time = t;
> -	timekeeper.offs_boot = timespec_to_ktime(t);
> -}
> -
>  /**
>   * __timekeeping_inject_sleeptime - Internal function to add sleep interval
>   * @delta: pointer to a timespec delta value
> @@ -677,10 +695,9 @@ static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
>  					"sleep delta value!\n");
>  		return;
>  	}
> -
>  	tk_xtime_add(tk, delta);
> -	tk->wall_to_monotonic = timespec_sub(tk->wall_to_monotonic, *delta);
> -	update_sleep_time(timespec_add(tk->total_sleep_time, *delta));
> +	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *delta));
> +	tk_set_sleep_time(tk, timespec_add(tk->total_sleep_time, *delta));
>  }
>  
>  

Stray newline.

I see a pattern with the newlines there - and this isnt the 
first patch from you that has that problem.

Thanks,

	Ingo
