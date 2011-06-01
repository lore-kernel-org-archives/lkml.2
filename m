Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab1FAQST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 12:18:19 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:54947 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab1FAQSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 12:18:18 -0400
Message-ID: <4DE66645.6020406@tilera.com>
Date: Wed, 1 Jun 2011 12:18:13 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] clocksource: tile: convert to use clocksource_register_hz
References: <1306913570-9445-1-git-send-email-john.stultz@linaro.org> <1306913570-9445-7-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1306913570-9445-7-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/2011 3:32 AM, John Stultz wrote:
> From: John Stultz <johnstul@us.ibm.com>
>
> Convert tile to use clocksource_register_hz.
>
> Untested. Help from maintainers would be appreciated.
>
> CC: Chris Metcalf <cmetcalf@tilera.com>

This patch boots up fine on tile.  It provides a shift count of 31, with a
mult value in the billions.  This does mean that clocksource_cyc2ns() will
only be able to give correct timer conversions for up to about 9 seconds. 
Is this believed to be adequate for all the uses the cycle counter is put
to?  I can run our normal regression tests, but I'd like to get a
high-level sanity check from the clocksource folks.

The original shift of 22 was put in by commit
749dc6f252b57d5cb9c1f4c1c4aafe4c92a28207 back in August.

> CC: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> ---
>  arch/tile/kernel/time.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
> index c4be58c..f6f50f2a 100644
> --- a/arch/tile/kernel/time.c
> +++ b/arch/tile/kernel/time.c
> @@ -78,7 +78,6 @@ static struct clocksource cycle_counter_cs = {
>  	.rating = 300,
>  	.read = clocksource_get_cycles,
>  	.mask = CLOCKSOURCE_MASK(64),
> -	.shift = 22,   /* typical value, e.g. x86 tsc uses this */
>  	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
>  };
>  
> @@ -91,8 +90,6 @@ void __init setup_clock(void)
>  	cycles_per_sec = hv_sysconf(HV_SYSCONF_CPU_SPEED);
>  	sched_clock_mult =
>  		clocksource_hz2mult(cycles_per_sec, SCHED_CLOCK_SHIFT);
> -	cycle_counter_cs.mult =
> -		clocksource_hz2mult(cycles_per_sec, cycle_counter_cs.shift);
>  }
>  
>  void __init calibrate_delay(void)
> @@ -107,7 +104,7 @@ void __init calibrate_delay(void)
>  void __init time_init(void)
>  {
>  	/* Initialize and register the clock source. */
> -	clocksource_register(&cycle_counter_cs);
> +	clocksource_register_hz(&cycle_counter_cs, cycles_per_sec);
>  
>  	/* Start up the tile-timer interrupt source on the boot cpu. */
>  	setup_tile_timer();

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


