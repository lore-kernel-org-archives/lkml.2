Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab0H0SFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:05:38 -0400
Received: from thoth.sbs.de ([192.35.17.2]:17236 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab0H0SFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:05:35 -0400
Message-ID: <4C77FE57.7050105@siemens.com>
Date: Fri, 27 Aug 2010 20:05:11 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 17/35] Implement getnsboottime kernel API
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-18-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-18-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Add a kernel call to get the number of nanoseconds since boot.  This
> is generally useful enough to make it a generic call.
> 
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
>  
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

This thing is not returning anything in some ts variable. And I also had
a hard time spotting the key difference to getboottime - the name is
really confusing.

Besides this, if you have good suggestion how to provide a compat
version for older kernels, I'm all ears. Please also have a careful look
at kvm-kmod's kvm_getboottime again, right now I'm a bit confused about
what it is supposed to return and what it actually does (note that
kvm-kmod cannot account for time spent in suspend state).

Thanks!
Jan

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
> +
>  /**
>   * do_gettimeofday - Returns the time of day in a timeval
>   * @tv:		pointer to the timeval to be set

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
