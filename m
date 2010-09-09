Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0IIT6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:58:07 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36020 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab0IIT6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:58:05 -0400
Subject: Re: [PATCH] time: compensate for rounding on odd-frequency
 clocksources
From: john stultz <johnstul@us.ibm.com>
To: Kasper Pedersen <kkp2010@kasperkp.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <4C7FD6B8.7080401@kasperkp.dk>
References: <4C7FD6B8.7080401@kasperkp.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 12:58:00 -0700
Message-ID: <1284062280.2762.113.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 18:54 +0200, Kasper Pedersen wrote:
> When the clocksource is not a multiple of HZ, the clock will be off. 
> For acpi_pm, HZ=1000 the error is 127.111 ppm:
> 
> The rounding of cycle_interval ends up generating a false error term 
> in ntp_error accumulation since xtime_interval is not exactly 1/HZ. 
> So, we subtract out the error caused by the rounding.

Yes, this has been a long outstanding granularity error issue and I
argued with Roman way back in the day about it until I just gave up on
it (as long as the error is constant from boot to boot, and not terribly
bad, NTPd can correct for it).


> This has been visible since 2.6.32-rc2
> 	commit a092ff0f90cae22b2ac8028ecd2c6f6c1a9e4601
> 	time: Implement logarithmic time accumulation
> That commit raised NTP_INTERVAL_FREQ and exposed the rounding error.

Well, only for CONFIG_NOHZ=y systems. Otherwise, the issue has been
present since 2.6.18/2.6.21. Having the longer ntp interval did help
minimize this error, but caused other issues with coarse accumulation.


> testing tool: http://n1.taur.dk/permanent/testpmt.c
> Also tested with ntpd and a frequency counter.
> 
> patch against 2.6.36-rc3-next. 
> 
> 
> Signed-off-by: Kasper Pedersen <kkp2010@kasperkp.dk>
> ---
>  kernel/time/timekeeping.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 77e930d..5ee5dea 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -32,6 +32,8 @@ struct timekeeper {
>  	cycle_t cycle_interval;
>  	/* Number of clock shifted nano seconds in one NTP interval. */
>  	u64	xtime_interval;
> +	/* shifted nano seconds left over when rounding cycle_interval */
> +	s64	xtime_remainder;
>  	/* Raw nano seconds accumulated per NTP interval. */
>  	u32	raw_interval;
> 
> @@ -62,7 +64,7 @@ struct timekeeper timekeeper;
>  static void timekeeper_setup_internals(struct clocksource *clock)
>  {
>  	cycle_t interval;
> -	u64 tmp;
> +	u64 tmp, ntpinterval;
> 
>  	timekeeper.clock = clock;
>  	clock->cycle_last = clock->read(clock);
> @@ -70,6 +72,7 @@ static void timekeeper_setup_internals(struct clocksource *clock)
>  	/* Do the ns -> cycle conversion first, using original mult */
>  	tmp = NTP_INTERVAL_LENGTH;
>  	tmp <<= clock->shift;
> +	ntpinterval = tmp;
>  	tmp += clock->mult/2;
>  	do_div(tmp, clock->mult);
>  	if (tmp == 0)
> @@ -80,6 +83,7 @@ static void timekeeper_setup_internals(struct clocksource *clock)
> 
>  	/* Go back from cycles -> shifted ns */
>  	timekeeper.xtime_interval = (u64) interval * clock->mult;
> +	timekeeper.xtime_remainder = ntpinterval - timekeeper.xtime_interval;
>  	timekeeper.raw_interval =
>  		((u64) interval * clock->mult) >> clock->shift;


So the above looks ok. 


> @@ -746,7 +750,8 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
> 
>  	/* Accumulate error between NTP and clock interval */
>  	timekeeper.ntp_error += tick_length << shift;
> -	timekeeper.ntp_error -= timekeeper.xtime_interval <<
> +	timekeeper.ntp_error -=
> +	    (timekeeper.xtime_interval + timekeeper.xtime_remainder) <<
>  				(timekeeper.ntp_error_shift + shift);


I like that you used the error value to handle the correction, its
equivalent, but cleaner than my earlier attempt of altering the base ntp
interval used to calculate tick_length so that it matched a multiple of
the clocksource period.

However, one concern might be: by always adding the clocksource-constant
xtime_remainder value, do you cause issues with the freq adjustments, as
they are only made against the xtime_interval, and not both?

In other words: If the initial error is removed with this patch, if you
make a 10ppm adjustment, does the system time accurately skew at 10ppm? 

Intuitively it seems the xtime_remainder would be so small, that the
error in the specified freq adjustment would be negligible. The freq
error should be the result of the adjustment * corrected error.

So in the acpi_pm case of 127ppm granularity error, with a maximum
adjustment of 500ppm, the freq error should be ~60ppb (that's
*billion*). 

Assuming the granularity of all clocks are under 500ppm (otherwise ntp
couldn't fix it), that limited the maximum freq error to 250ppb.

I'd say that's small enough that we don't care. But let me know if you
see an issue with my math.

thanks
-john

