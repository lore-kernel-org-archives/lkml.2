Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118Ab0HDXEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:04:37 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50730 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab0HDXEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:04:30 -0400
Subject: Re: [PATCHv3 13/16] pps: capture MONOTONIC_RAW timestamps as well
From: john stultz <johnstul@us.ibm.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>
In-Reply-To: <7e78eaffb92829465df0237fa7e4d1b183a1a511.1280952801.git.lasaine@lvk.cs.msu.su>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
	 <7e78eaffb92829465df0237fa7e4d1b183a1a511.1280952801.git.lasaine@lvk.cs.msu.su>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 16:03:57 -0700
Message-ID: <1280963037.2678.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 01:06 +0400, Alexander Gordeev wrote:
> MONOTONIC_RAW clock timestamps are ideally suited for frequency
> calculation and also fit well into the original NTP hardpps design. Now
> phase and frequency can be adjusted separately: the former based on
> REALTIME clock and the latter based on MONOTONIC_RAW clock.
> A new function getnstime_raw_and_real is added to timekeeping subsystem
> to capture both timestamps at the same time and atomically.
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> ---
>  include/linux/pps_kernel.h |    3 ++-
>  include/linux/time.h       |    2 ++
>  kernel/time/timekeeping.c  |   34 ++++++++++++++++++++++++++++++++++
>  3 files changed, 38 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
> index 5af0498..39fc712 100644
> --- a/include/linux/pps_kernel.h
> +++ b/include/linux/pps_kernel.h
> @@ -48,6 +48,7 @@ struct pps_source_info {
>  };
> 
>  struct pps_event_time {
> +	struct timespec ts_raw;
>  	struct timespec ts_real;
>  };
> 
> @@ -111,7 +112,7 @@ static inline void timespec_to_pps_ktime(struct pps_ktime *kt,
> 
>  static inline void pps_get_ts(struct pps_event_time *ts)
>  {
> -	getnstimeofday(&ts->ts_real);
> +	getnstime_raw_and_real(&ts->ts_raw, &ts->ts_real);
>  }
> 
>  #endif /* LINUX_PPS_KERNEL_H */
> diff --git a/include/linux/time.h b/include/linux/time.h
> index ea3559f..1da8a7b 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -143,6 +143,8 @@ extern unsigned int alarm_setitimer(unsigned int seconds);
>  extern int do_getitimer(int which, struct itimerval *value);
>  extern void getnstimeofday(struct timespec *tv);
>  extern void getrawmonotonic(struct timespec *ts);
> +extern void getnstime_raw_and_real(struct timespec *ts_raw,
> +		struct timespec *ts_real);
>  extern void getboottime(struct timespec *ts);
>  extern void monotonic_to_bootbased(struct timespec *ts);
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index caf8d4d..ef37b14 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -286,6 +286,40 @@ void ktime_get_ts(struct timespec *ts)
>  EXPORT_SYMBOL_GPL(ktime_get_ts);
> 
>  /**
> + * getnstime_raw_and_real - Returns both the time of day an raw
> + * monotonic time in a timespec format
> + * @ts_mono_raw:	pointer to the timespec to be set to raw
> + *			monotonic time
> + * @ts_real:		pointer to the timespec to be set to the time
> + *			of day
> + */
> +void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
> +{
> +	unsigned long seq;
> +	s64 nsecs_raw, nsecs_real;
> +
> +	WARN_ON(timekeeping_suspended);
> +
> +	do {
> +		seq = read_seqbegin(&xtime_lock);
> +
> +		*ts_raw = raw_time;
> +		*ts_real = xtime;
> +
> +		nsecs_raw = timekeeping_get_ns_raw();
> +		nsecs_real = timekeeping_get_ns();
> +
> +		/* If arch requires, add in gettimeoffset() */
> +		nsecs_real += arch_gettimeoffset();

Hmm. So this brings up an interesting point. If the system is an one
which uses arch_gettimeoffset() (which means it doesn't have
clocksources), I'm not sure if this function would return what you'd
expect.

The issue is that jiffies is the basic clocksource that is in use on
these systems, but the arch_gettimeoffset() function returns an
inter-tick time value (usually by reading the interrupt generating
decrementer or whatnot). So in this case, you'd get a
CLOCK_MONOTONIC_RAW time that is based off the raw jiffies value at the
last tick, and CLOCK_REALTIME time value at the exact time of the call.

That offset between the two would then vary depending on when in the
inter-tick period the call was made.


The two solutions would be:
1) Add the arch_gettimeoffset() value to nsecs_raw as well. Should be
safe, as any freq variance from the raw freq will be limited to 1 tick
length and won't accumulate.

2) Don't add arch_gettimeoffset to either value, providing the raw and
real time values at the last tick.

I'd probably go with #1.

Otherwise, the code looks good.

thanks
-john


