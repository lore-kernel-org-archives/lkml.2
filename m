Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab2CLQIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:08:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:46941 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab2CLQI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:08:28 -0400
Date: Mon, 12 Mar 2012 17:08:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@lianro.org>
Subject: Re: [PATCH] time: x86: Fix race switching from vsyscall to non-vsyscall
 clock
In-Reply-To: <1331330647-31480-1-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.LFD.2.02.1203121703390.2466@ionos>
References: <1331330647-31480-1-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2012, John Stultz wrote:

> When switching from a vsyscall capable to a non-vsyscall capable
> clocksource, there was a small race, where the last vsyscall
> gettimeofday before the switch might return a invalid time value
> using the new non-vsyscall enabled clocksource values after the
> switch is complete.
> 
> This is due to the vsyscall code checking the vclock_mode once
> outside of the seqcount protected section. After it reads the
> vclock mode, it doesn't re-check that the sampled clock data
> that is obtained in the seqcount critical section still matches.
> 
> The fix is to sample vclock_mode inside the protected section,
> and as long as it isn't VCLOCK_NONE, return the calculated
> value. If it has changed and is now VCLOCK_NONE, fall back
> to the syscall gettime calculation.
> 
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: John Stultz <john.stultz@lianro.org>
> ---
>  arch/x86/vdso/vclock_gettime.c |   25 ++++++++++++++++++++-----
>  1 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
> index 6bc0e72..e7cf1dd 100644
> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -85,21 +85,28 @@ notrace static inline long vgetns(void)
>  notrace static noinline int do_realtime(struct timespec *ts)
>  {
>  	unsigned long seq, ns;
> +	int mode;
>  	do {
>  		seq = read_seqbegin(&gtod->lock);
> +		mode = gtod->clock.vclock_mode;
>  		ts->tv_sec = gtod->wall_time_sec;
>  		ts->tv_nsec = gtod->wall_time_nsec;
>  		ns = vgetns();
>  	} while (unlikely(read_seqretry(&gtod->lock, seq)));
> +
>  	timespec_add_ns(ts, ns);
> +	if (mode == VCLOCK_NONE)
> +		return -1;

Can't we just return mode and avoid repeated conditionals all over the
place ?

>  {
	res = VCLOCK_NONE;

>  	switch (clock) {
>  	case CLOCK_REALTIME:
> -		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE))
> -			return do_realtime(ts);

  			res = do_realtime(ts);
		break;			


>  	case CLOCK_MONOTONIC_COARSE:
>  		return do_monotonic_coarse(ts);
>  	}

	return res != VCLOCK_NONE ? 0 : vdso_fallback_gettime(clock, ts);

Thanks,

	tglx
