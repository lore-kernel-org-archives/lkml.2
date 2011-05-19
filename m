Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab1ESA5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 20:57:41 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44998 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab1ESA5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 20:57:40 -0400
Subject: Re: [patch 2/7] clocksource: Get rid of the hardcoded 5 seconds
 sleep time limit
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110518210136.109811585@linutronix.de>
References: <20110518205713.947614271@linutronix.de>
	 <20110518210136.109811585@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 17:57:35 -0700
Message-ID: <1305766655.2915.187.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 21:33 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (clocksource-make-shift-mult-calc-more-clever.patch)
> Slow clocksources can have a way longer sleep time than 5 seconds and
> even fast ones can easily cope with 600 seconds and still maintain
> proper accuracy.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/time/clocksource.c |   38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> Index: linux-2.6-tip/kernel/time/clocksource.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/time/clocksource.c
> +++ linux-2.6-tip/kernel/time/clocksource.c
> @@ -626,19 +626,6 @@ static void clocksource_enqueue(struct c
>  	list_add(&cs->list, entry);
>  }
> 
> -
> -/*
> - * Maximum time we expect to go between ticks. This includes idle
> - * tickless time. It provides the trade off between selecting a
> - * mult/shift pair that is very precise but can only handle a short
> - * period of time, vs. a mult/shift pair that can handle long periods
> - * of time but isn't as precise.
> - *
> - * This is a subsystem constant, and actual hardware limitations
> - * may override it (ie: clocksources that wrap every 3 seconds).
> - */
> -#define MAX_UPDATE_LENGTH 5 /* Seconds */
> -
>  /**
>   * __clocksource_updatefreq_scale - Used update clocksource with new freq
>   * @t:		clocksource to be registered
> @@ -652,15 +639,28 @@ static void clocksource_enqueue(struct c
>   */
>  void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
>  {
> +	unsigned long sec;
> +
>  	/*
> -	 * Ideally we want to use  some of the limits used in
> -	 * clocksource_max_deferment, to provide a more informed
> -	 * MAX_UPDATE_LENGTH. But for now this just gets the
> -	 * register interface working properly.
> +	 * Calc the maximum number of seconds which we can run before
> +	 * wrapping around. For clocksources which have a mask > 32bit
> +	 * we need to limit the max sleep time to have a good
> +	 * conversion precision. 10 minutes is still a reasonable
> +	 * amount. That results in a shift value of 24 for a
> +	 * clocksource with mask >= 40bit and f >= 4GHz. That maps to
> +	 * ~ 0.06ppm granularity for NTP. We apply the same 12.5%
> +	 * margin as we do in clocksource_max_deferment()
>  	 */

So, its not clear to me that the 12.5% margin really needed, since we
take it out when we calculate clocksource_max_deferment(). Although with
or without the margin I get the same mult/shift/max_idle_ns values for
the hardware I'm testing.

Another nice detail from the change: It doesn't affect clocksources that
normally wrap quickly:

Without your patch:
--------------
JDB: hpet mult: 2684354560 shift: 26 max_idle: 83214991360
JDB: acpi_pm mult: 2343484437 shift: 23 max_idle: 4540500826
JDB: tsc mult: 1342183991 shift: 31 max_idle: 2600481483

With your patch:
---------------
JDB: hpet mult: 2684354560 shift: 26 max_idle: 83214991360
JDB: acpi_pm mult: 2343484437 shift: 23 max_idle: 4540500826
JDB: tsc mult: 10485812 shift: 24 max_idle: 332861616128

Although interestingly 332 secs calculated for the max idle is more then
12% off of 600.

> +	sec = (cs->mask - (cs->mask >> 5));
> +	do_div(sec, freq);
> +	do_div(sec, scale);
> +	if (!sec)
> +		sec = 1;
> +	else if (sec > 600 && cs->mask > UINT_MAX)
> +		sec = 600;
> +
>  	clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
> -				      NSEC_PER_SEC/scale,
> -				      MAX_UPDATE_LENGTH*scale);
> +			       NSEC_PER_SEC / scale, sec * scale);
>  	cs->max_idle_ns = clocksource_max_deferment(cs);
>  }
>  EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);

Overall it looks good. I'm doing some NTP testing with the TSC shift
change to make sure we don't get any odd side effects. I'll let you know
how those go.

thanks
-john



