Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801Ab2B1IHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:07:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53592 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab2B1IHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:07:02 -0500
Date: Tue, 28 Feb 2012 09:06:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/7] time: Condense timekeeper.xtime into xtime_sec
Message-ID: <20120228080647.GC21106@elte.hu>
References: <1330388974-27793-1-git-send-email-john.stultz@linaro.org>
 <1330388974-27793-2-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330388974-27793-2-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -39,8 +39,11 @@ struct timekeeper {
>  	/* Raw nano seconds accumulated per NTP interval. */
>  	u32	raw_interval;
>  
> -	/* Clock shifted nano seconds remainder not stored in xtime.tv_nsec. */
> +	/* Current CLOCK_REALTIME time in seconds */
> +	u64	xtime_sec;
> +	/* Clock shifted nano seconds */
>  	u64	xtime_nsec;
> +
>  	/* Difference between accumulated time and NTP time in ntp
>  	 * shifted nano seconds. */
>  	s64	ntp_error;
> @@ -48,8 +51,6 @@ struct timekeeper {
>  	 * ntp shifted nano seconds. */
>  	int	ntp_error_shift;
>  
> -	/* The current time */
> -	struct timespec xtime;

Please use consistent vertical spacing for this structure.

> +static struct timespec timekeeper_xtime(struct timekeeper *tk)
> +{
> +	struct timespec ts;
> +
> +	ts.tv_sec = tk->xtime_sec;
> +	ts.tv_nsec = (long)(tk->xtime_nsec >> tk->shift);
> +	return ts;
> +}

btw., is tk->shift intentionally a signed int? If not then it 
would be better to make it u32, like tk->mult, to make sure the 
compiler never does complex signed arithmetics - and to clean up 
'struct timekeeper'.

> +
> +static void timekeeper_set_xtime(struct timekeeper *tk,
> +					const struct timespec *ts)

Pointless (because ugly) line break.

> +{
> +	tk->xtime_sec = ts->tv_sec;
> +	tk->xtime_nsec = ts->tv_nsec << tk->shift;
> +}
> +
> +
> +static void timekeeper_xtime_add(struct timekeeper *tk,
> +					const struct timespec *ts)

Pointless (because ugly) line break.

Thanks,

	Ingo
