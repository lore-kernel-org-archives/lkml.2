Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0KRTm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:42:57 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33648 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab0KRTm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:42:56 -0500
Subject: Re: [PATCHv4 14/17] pps: capture MONOTONIC_RAW timestamps as well
From: john stultz <johnstul@us.ibm.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Magnus Damm <damm@opensource.se>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <06dbeb207a3e418077674a4d28f440ef3506b0e6.1290087480.git.lasaine@lvk.cs.msu.su>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
	 <06dbeb207a3e418077674a4d28f440ef3506b0e6.1290087480.git.lasaine@lvk.cs.msu.su>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 11:42:47 -0800
Message-ID: <1290109367.12201.0.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 19:01 +0300, Alexander Gordeev wrote:
> MONOTONIC_RAW clock timestamps are ideally suited for frequency
> calculation and also fit well into the original NTP hardpps design. Now
> phase and frequency can be adjusted separately: the former based on
> REALTIME clock and the latter based on MONOTONIC_RAW clock.
> A new function getnstime_raw_and_real is added to timekeeping subsystem
> to capture both timestamps at the same time and atomically.
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Acked-by: John Stultz <johnstul@us.ibm.com>

> ---
>  include/linux/pps_kernel.h |    3 ++-
>  include/linux/time.h       |    2 ++
>  kernel/time/timekeeping.c  |   38 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 42 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
> index 5af0498..39fc7125 100644
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
> index 9f15ac7..1e6d3b5 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -158,6 +158,8 @@ extern unsigned int alarm_setitimer(unsigned int seconds);
>  extern int do_getitimer(int which, struct itimerval *value);
>  extern void getnstimeofday(struct timespec *tv);
>  extern void getrawmonotonic(struct timespec *ts);
> +extern void getnstime_raw_and_real(struct timespec *ts_raw,
> +		struct timespec *ts_real);
>  extern void getboottime(struct timespec *ts);
>  extern void monotonic_to_bootbased(struct timespec *ts);
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 49010d8..947c7dc 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -285,6 +285,44 @@ void ktime_get_ts(struct timespec *ts)
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
> +	WARN_ON_ONCE(timekeeping_suspended);
> +
> +	do {
> +		u32 arch_offset;
> +
> +		seq = read_seqbegin(&xtime_lock);
> +
> +		*ts_raw = raw_time;
> +		*ts_real = xtime;
> +
> +		nsecs_raw = timekeeping_get_ns_raw();
> +		nsecs_real = timekeeping_get_ns();
> +
> +		/* If arch requires, add in gettimeoffset() */
> +		arch_offset = arch_gettimeoffset();
> +		nsecs_raw += arch_offset;
> +		nsecs_real += arch_offset;
> +
> +	} while (read_seqretry(&xtime_lock, seq));
> +
> +	timespec_add_ns(ts_raw, nsecs_raw);
> +	timespec_add_ns(ts_real, nsecs_real);
> +}
> +EXPORT_SYMBOL(getnstime_raw_and_real);
> +
> +/**
>   * do_gettimeofday - Returns the time of day in a timeval
>   * @tv:		pointer to the timeval to be set
>   *


