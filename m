Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030789Ab2GMGEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 02:04:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42680 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030201Ab2GMGEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 02:04:36 -0400
Date: Fri, 13 Jul 2012 08:04:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 7/8] time: Move xtime_nsec adjustment underflow handling
 timekeeping_adjust
Message-ID: <20120713060431.GF18065@gmail.com>
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
 <1342156917-25092-8-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342156917-25092-8-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> When we make adjustments speeding up the clock, its possible
> for xtime_nsec to underflow. We already handle this properly,
> but we do so from update_wall_time() instead of the more logical
> timekeeping_adjust(), where the possible underflow actually
> occurs.
> 
> Thus, move the correction logic to the timekeeping_adjust, which
> is the function that causes the issue. Making update_wall_time()
> more readable.
> 
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Richard Cochran <richardcochran@gmail.com>
> CC: Prarit Bhargava <prarit@redhat.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> ---
>  kernel/time/timekeeping.c |   42 +++++++++++++++++++++---------------------
>  1 file changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index dd119355..4b76432 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -987,6 +987,27 @@ static void timekeeping_adjust(s64 offset)
>  	timekeeper.xtime_nsec -= offset;
>  	timekeeper.ntp_error -= (interval - offset) <<
>  				timekeeper.ntp_error_shift;
> +
> +	/*
> +	 * It may be possible that when we entered this function, xtime_nsec
> +	 * was very small.  Further, if we're slightly speeding the clocksource
> +	 * in the code above, its possible the required corrective factor to
> +	 * xtime_nsec could cause it to underflow.

s/slightly speeding/slightly speeding up ?

> +	 *
> +	 * Now, since we already accumulated the second, cannot simply roll
> +	 * the accumulated second back, since the NTP subsystem has been

s/cannot/we cannot ?

Thanks,

	Ingo
