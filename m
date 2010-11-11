Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab0KKVV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:21:58 -0500
Received: from usmamail.tilera.com ([72.1.168.231]:6381 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab0KKVV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:21:57 -0500
Message-ID: <4CDC5E70.90102@tilera.com>
Date: Thu, 11 Nov 2010 16:21:52 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 04/10] tile: convert to use clocksource_register_hz
References: <1288642350-1599-1-git-send-email-johnstul@us.ibm.com> <1288642350-1599-5-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1288642350-1599-5-git-send-email-johnstul@us.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/2010 4:12 PM, John Stultz wrote:
> Convert tile to use clocksource_register_hz.
>
> Untested. Help from maintainers would be appreciated.
>
> CC: Chris Metcalf <cmetcalf@tilera.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> ---
>  arch/tile/kernel/time.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
> index 6bed820..8c06cb2 100644
> --- a/arch/tile/kernel/time.c
> +++ b/arch/tile/kernel/time.c
> @@ -76,7 +76,6 @@ static struct clocksource cycle_counter_cs = {
>  	.rating = 300,
>  	.read = clocksource_get_cycles,
>  	.mask = CLOCKSOURCE_MASK(64),
> -	.shift = 22,   /* typical value, e.g. x86 tsc uses this */
>  	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
>  };

We were using clocksource_calc_mult_shift() for a while to compute both
this value and our sched_clock() value, and, like
clocksource_register_hz(), it suggested that a shift value of 31 was best.

Perhaps unsurprisingly, we saw wraparound with sched_clock(), which is why
we use a fixed shift value of "10" to avoid problems.  This is clearly
required since sched_clock() values are fairly long-lived.

I admit that I don't really understand what the wraparound implications of
using a shift of "31" for the clocksource is, but since it will cause the
clocksource to wrap around fairly quickly, I wanted to make sure this shift
value was OK for whatever uses that clocksource is put to.  (The underlying
clock in question is a 64-bit cycle counter, so with "<< 31" at e.g. 1 GHz
it will wrap negative after about four seconds.)

> @@ -89,8 +88,6 @@ void __init setup_clock(void)
>  	cycles_per_sec = hv_sysconf(HV_SYSCONF_CPU_SPEED);
>  	sched_clock_mult =
>  		clocksource_hz2mult(cycles_per_sec, SCHED_CLOCK_SHIFT);
> -	cycle_counter_cs.mult =
> -		clocksource_hz2mult(cycles_per_sec, cycle_counter_cs.shift);
>  }
>  
>  void __init calibrate_delay(void)
> @@ -105,7 +102,7 @@ void __init calibrate_delay(void)
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

