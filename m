Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab2GSMhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:37:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab2GSMhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:37:18 -0400
Message-ID: <5007FF6C.3060302@redhat.com>
Date: Thu, 19 Jul 2012 08:37:00 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] time: Cleanup offs_real/wall_to_mono and offs_boot/total_sleep_time
 updates
References: <1342660753-10382-1-git-send-email-john.stultz@linaro.org> <1342660753-10382-3-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1342660753-10382-3-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/18/2012 09:19 PM, John Stultz wrote:
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
> 
> This also provides WARN_ONs to detect if future changes break
> the invariants.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Prarit Bhargava <prarit@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

<snip>

> @@ -1024,11 +1041,18 @@ static inline void accumulate_nsecs_to_secs(struct timekeeper *tk)
>  
>  		/* Figure out if its a leap sec and apply if needed */
>  		leap = second_overflow(tk->xtime_sec);
> -		tk->xtime_sec += leap;
> -		tk->wall_to_monotonic.tv_sec -= leap;
> -		if (leap)
> -			clock_was_set_delayed();
> +		if (unlikely(leap)) {

I'm likely a bit behind the times with this comment ...

I thought someone did a comparison of the usage of unlikely() within the kernel
and found that it didn't really add that much.  I'm not strongly opposed to it
in anyway, it is just that I'm curious about unlikely()'s continued usage within
the kernel; does it really add anything *other* than code readability at this point?

> +			struct timespec ts;
> +
> +			tk->xtime_sec += leap;
>  
> +			ts.tv_sec = leap;
> +			ts.tv_nsec = 0;

I wonder if this is true or not when the kernel handles the leap second.  I
suppose, in theory it is ... but it might be ahead by a bit.  I guess it is
"close enough" ;)

> +			tk_set_wall_to_mono(tk,
> +				timespec_sub(tk->wall_to_monotonic, ts));
> +
> +			clock_was_set_delayed();
> +		}
>  	}
>  }
>  
