Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2KSRpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:45:53 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58443 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab2KSRpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:45:52 -0500
MIME-Version: 1.0
In-Reply-To: <50AA6B1A.6060206@us.ibm.com>
References: <20121105220059.GA6379@www.outflux.net>
	<509DA63E.7070500@us.ibm.com>
	<CAGXu5jKq0=+XfH6yDSaJMcd-S3=o7xB67kspPkCRcXjRSGgciw@mail.gmail.com>
	<20121117025355.GC29966@lizard>
	<50A70199.9030109@us.ibm.com>
	<CAGXu5j+--cmhOHMR+7ewWt_ct-0p_o8sbK4bJWkgj067aeFjsw@mail.gmail.com>
	<50AA6B1A.6060206@us.ibm.com>
Date: Mon, 19 Nov 2012 09:45:51 -0800
X-Google-Sender-Auth: s7uFAbUCnPGVyX4yv9t6gGsEcck
Message-ID: <CAGXu5j+wmEZdmN=e047+SEXGfhaN_Gyob=WyqR4kKgKheCgqfQ@mail.gmail.com>
Subject: Re: [PATCH v2] pstore/ram: no timekeeping calls when unavailable
From: Kees Cook <keescook@chromium.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 9:23 AM, John Stultz <johnstul@us.ibm.com> wrote:
> On 11/18/2012 12:09 PM, Kees Cook wrote:
>>
>> On Fri, Nov 16, 2012 at 7:16 PM, John Stultz <johnstul@us.ibm.com> wrote:
>>>
>>> Yea, I wanted to revisit this, because it is an odd case.
>>>
>>> We don't want to call getnstimeofday() while the timekeeping code is
>>> suspended, since the clocksource cycle_last value may be invalid if the
>>> hardware was reset during suspend.  Kees is correct,  the WARN_ONs were
>>> there to make sure no one tries to use the timekeeping core before its
>>> resumed, so removing them is problematic.
>>>
>>> Your sugggestion of having the __do_gettimeofday() internal accessor that
>>> maybe returns an error if timekeeping has been suspended could work.
>>>
>>> The other possibility is depending on the needs for accuracy with the
>>> timestamp, current_kernel_time() might be a better interface to use,
>>> since
>>> it will return the time at the last tick, and doesn't require accessing
>>> the
>>> clocksource hardware.  Might that be a simpler solution? Or is sub-tick
>>> granularity necessary?
>>
>> I think it's only useful to have this to the same granularity as
>> sched_clock(), so things can be correlated to dmesg output. If it's
>> the same, I'd be fine to switch to using current_kernel_time().
>
> Oof.  That's another can of worms,   sched_clock() resolution isn't tied to
> getnstimeofday(), since you may have cases where the TSC is invalid for
> timekeeping (so we use something slow like the ACPI PM) but ok for
> scheduling, etc.
>
> Even so, its current_kernel_time() is just tick granularity, so that
> probably won't work for you.
>
> So I'm leaning towards Anton's suggestion of adding a new internal accessor
> that returns an error if we're suspended.
>
> Thomas, what do you think of something like what's below?
>
> thanks
> -john
>
>
> diff --git a/include/linux/time.h b/include/linux/time.h
> index 4d358e9..0015aea 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -158,6 +158,7 @@ extern int do_setitimer(int which, struct itimerval
> *value,
>                         struct itimerval *ovalue);
>  extern unsigned int alarm_setitimer(unsigned int seconds);
>  extern int do_getitimer(int which, struct itimerval *value);
> +extern int __getnstimeofday(struct timespec *tv);
>  extern void getnstimeofday(struct timespec *tv);
>  extern void getrawmonotonic(struct timespec *ts);
>  extern void getnstime_raw_and_real(struct timespec *ts_raw,
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index e424970..bb2638c 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -220,19 +220,20 @@ static void timekeeping_forward_now(struct timekeeper
> *tk)
>  }
>   /**
> - * getnstimeofday - Returns the time of day in a timespec
> + * __getnstimeofday - Returns the time of day in a timespec
>   * @ts:                pointer to the timespec to be set
>   *
> - * Returns the time of day in a timespec.
> + * Returns -1 if timekeeping is suspended.
> + * Returns 0 on success.
>   */
> -void getnstimeofday(struct timespec *ts)
> +int __getnstimeofday(struct timespec *ts)
>  {
>         struct timekeeper *tk = &timekeeper;
>         unsigned long seq;
>         s64 nsecs = 0;
>  -      WARN_ON(timekeeping_suspended);
> -
> +       if (unlikely(timekeeping_suspended));
> +               return -1;

Is it useful to make this -EAGAIN or something, just for clarity?
Also, this technically changes the semantics of callers that were
hitting WARN (there should be none) in that the timespec isn't updated
at all. In the prior code, a WARN would be emitted, but it would still
fill out the timespec and return.

When I looked at implementing this error path, I actually moved the
return -EAGAIN to the end of the function to keep the results the
same. All that said, this is much cleaner and more correct if not
touching the timespec on error is tolerable.

>         do {
>                 seq = read_seqbegin(&tk->lock);
>  @@ -243,6 +244,19 @@ void getnstimeofday(struct timespec *ts)
>         ts->tv_nsec = 0;
>         timespec_add_ns(ts, nsecs);
> +       return 0;
> +}
> +EXPORT_SYMBOL(__getnstimeofday);
> +
> +/**
> + * getnstimeofday - Returns the time of day in a timespec
> + * @ts:                pointer to the timespec to be set
> + *
> + * Returns the time of day in a timespec.
> + */
> +void getnstimeofday(struct timespec *ts)
> +{
> +       WARN_ON(__getnstimeofday(ts));
>  }
>  EXPORT_SYMBOL(getnstimeofday);
>

-Kees


-- 
Kees Cook
Chrome OS Security
