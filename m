Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab0HTSk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 14:40:29 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:60440 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab0HTSkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 14:40:01 -0400
Subject: Re: [KVM timekeeping 17/35] Implement getnsboottime kernel API
From: john stultz <johnstul@us.ibm.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1282291669-25709-18-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
	 <1282291669-25709-18-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 11:39:54 -0700
Message-ID: <1282329594.3302.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 22:07 -1000, Zachary Amsden wrote:
> Add a kernel call to get the number of nanoseconds since boot.  This
> is generally useful enough to make it a generic call.

Few comments here.

> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
> ---
>  include/linux/time.h      |    1 +
>  kernel/time/timekeeping.c |   27 +++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/time.h b/include/linux/time.h
> index ea3559f..5d04108 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -145,6 +145,7 @@ extern void getnstimeofday(struct timespec *tv);
>  extern void getrawmonotonic(struct timespec *ts);
>  extern void getboottime(struct timespec *ts);
>  extern void monotonic_to_bootbased(struct timespec *ts);
> +extern s64 getnsboottime(void);

So instead of converting the timespec from getboottime, why did you add
a new interface? Also if not a timespec, why did you pick a s64 instead
of a ktime_t?


>  extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
>  extern int timekeeping_valid_for_hres(void);
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index caf8d4d..d250f0a 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -285,6 +285,33 @@ void ktime_get_ts(struct timespec *ts)
>  }
>  EXPORT_SYMBOL_GPL(ktime_get_ts);
> 
> +
> +/**
> + * getnsboottime - get the bootbased clock in nsec format
> + *
> + * The function calculates the bootbased clock from the realtime
> + * clock and the wall_to_monotonic offset and stores the result
> + * in normalized timespec format in the variable pointed to by @ts.
> + */
> +s64 getnsboottime(void)
> +{
> +	unsigned int seq;
> +	s64 secs, nsecs;
> +
> +	WARN_ON(timekeeping_suspended);
> +
> +	do {
> +		seq = read_seqbegin(&xtime_lock);
> +		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
> +		secs += total_sleep_time.tv_sec;
> +		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
> +		nsecs += total_sleep_time.tv_nsec + timekeeping_get_ns();
> +
> +	} while (read_seqretry(&xtime_lock, seq));
> +	return nsecs + (secs * NSEC_PER_SEC);
> +}
> +EXPORT_SYMBOL_GPL(getnsboottime);

You forgot to include the boottime.tv_sec/nsec offset in this. Take a
look again at getboottime()

thanks
-john


