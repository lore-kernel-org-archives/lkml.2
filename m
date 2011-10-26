Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab1JZFPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 01:15:36 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:57633 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab1JZFPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 01:15:35 -0400
Message-ID: <4EA79629.3040403@snapgear.com>
Date: Wed, 26 Oct 2011 15:10:01 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        lkml <linux-kernel@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>,
        uClinux development list <uclinux-dev@uclinux.org>
Subject: Re: [PATCH 6/8] clocksource: m86k: Convert to clocksource_register_hz/khz
References: <4ea6fbe8.43310e0a.592c.5416SMTPIN_ADDED@mx.google.com>	 <CAMuHMdWVdaq+uuCLxuN0EsmJiQdyr9xWpqg6oAeHg3NP_u2V8g@mail.gmail.com> <1319568370.17505.21.camel@work-vm>
In-Reply-To: <1319568370.17505.21.camel@work-vm>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On 26/10/11 04:46, john stultz wrote:
> Updated to merge the valid bits of the two m68k patches.
>
> This converts the m86k clocksources to use clocksource_register_hz/khz
>
> This is untested, so any assistance in testing would be appreciated!

This looks good. I test compiled across all targets these files affect.
And run tested on ColdFire/5208 (which uses pit.c).


> CC: Geert Uytterhoeven<geert@linux-m68k.org>
> CC: Greg Ungerer<gerg@uclinux.org>
> Signed-off-by: John Stultz<johnstul@us.ibm.com>

Acked-by: Greg Ungerer <gerg@uclinux.org>

Do you want me to push these via the m68knommu git tree?

Regards
Greg


>   arch/m68k/platform/68328/timers.c       |    4 +---
>   arch/m68k/platform/coldfire/dma_timer.c |    5 +----
>   arch/m68k/platform/coldfire/pit.c       |    4 +---
>   arch/m68k/platform/coldfire/sltimers.c  |    4 +---
>   arch/m68k/platform/coldfire/timers.c    |    4 +---
>   5 files changed, 5 insertions(+), 16 deletions(-)
>
> diff --git a/arch/m68k/platform/68328/timers.c b/arch/m68k/platform/68328/timers.c
> index 309f725..f267886 100644
> --- a/arch/m68k/platform/68328/timers.c
> +++ b/arch/m68k/platform/68328/timers.c
> @@ -93,7 +93,6 @@ static struct clocksource m68328_clk = {
>   	.name	= "timer",
>   	.rating	= 250,
>   	.read	= m68328_read_clk,
> -	.shift	= 20,
>   	.mask	= CLOCKSOURCE_MASK(32),
>   	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
>   };
> @@ -115,8 +114,7 @@ void hw_timer_init(void)
>
>   	/* Enable timer 1 */
>   	TCTL |= TCTL_TEN;
> -	m68328_clk.mult = clocksource_hz2mult(TICKS_PER_JIFFY*HZ, m68328_clk.shift);
> -	clocksource_register(&m68328_clk);
> +	clocksource_register_hz(&m68328_clk, TICKS_PER_JIFFY*HZ);
>   }
>
>   /***************************************************************************/
> diff --git a/arch/m68k/platform/coldfire/dma_timer.c b/arch/m68k/platform/coldfire/dma_timer.c
> index a5f5628..235ad57 100644
> --- a/arch/m68k/platform/coldfire/dma_timer.c
> +++ b/arch/m68k/platform/coldfire/dma_timer.c
> @@ -44,7 +44,6 @@ static struct clocksource clocksource_cf_dt = {
>   	.rating		= 200,
>   	.read		= cf_dt_get_cycles,
>   	.mask		= CLOCKSOURCE_MASK(32),
> -	.shift		= 20,
>   	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
>   };
>
> @@ -60,9 +59,7 @@ static int __init  init_cf_dt_clocksource(void)
>   	__raw_writeb(0x00, DTER0);
>   	__raw_writel(0x00000000, DTRR0);
>   	__raw_writew(DMA_DTMR_CLK_DIV_16 | DMA_DTMR_ENABLE, DTMR0);
> -	clocksource_cf_dt.mult = clocksource_hz2mult(DMA_FREQ,
> -						     clocksource_cf_dt.shift);
> -	return clocksource_register(&clocksource_cf_dt);
> +	return clocksource_register_hz(&clocksource_cf_dt, DMA_FREQ);
>   }
>
>   arch_initcall(init_cf_dt_clocksource);
> diff --git a/arch/m68k/platform/coldfire/pit.c b/arch/m68k/platform/coldfire/pit.c
> index c2b9809..02663d2 100644
> --- a/arch/m68k/platform/coldfire/pit.c
> +++ b/arch/m68k/platform/coldfire/pit.c
> @@ -144,7 +144,6 @@ static struct clocksource pit_clk = {
>   	.name	= "pit",
>   	.rating	= 100,
>   	.read	= pit_read_clk,
> -	.shift	= 20,
>   	.mask	= CLOCKSOURCE_MASK(32),
>   };
>
> @@ -162,8 +161,7 @@ void hw_timer_init(void)
>
>   	setup_irq(MCFINT_VECBASE + MCFINT_PIT1,&pit_irq);
>
> -	pit_clk.mult = clocksource_hz2mult(FREQ, pit_clk.shift);
> -	clocksource_register(&pit_clk);
> +	clocksource_register_hz(&pit_clk, FREQ);
>   }
>
>   /***************************************************************************/
> diff --git a/arch/m68k/platform/coldfire/sltimers.c b/arch/m68k/platform/coldfire/sltimers.c
> index 6a85daf..b7f822b 100644
> --- a/arch/m68k/platform/coldfire/sltimers.c
> +++ b/arch/m68k/platform/coldfire/sltimers.c
> @@ -114,7 +114,6 @@ static struct clocksource mcfslt_clk = {
>   	.name	= "slt",
>   	.rating	= 250,
>   	.read	= mcfslt_read_clk,
> -	.shift	= 20,
>   	.mask	= CLOCKSOURCE_MASK(32),
>   	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
>   };
> @@ -136,8 +135,7 @@ void hw_timer_init(void)
>
>   	setup_irq(MCF_IRQ_TIMER,&mcfslt_timer_irq);
>
> -	mcfslt_clk.mult = clocksource_hz2mult(MCF_BUSCLK, mcfslt_clk.shift);
> -	clocksource_register(&mcfslt_clk);
> +	clocksource_register_hz(&mcfslt_clk, MCF_BUSCLK);
>
>   #ifdef CONFIG_HIGHPROFILE
>   	mcfslt_profile_init();
> diff --git a/arch/m68k/platform/coldfire/timers.c b/arch/m68k/platform/coldfire/timers.c
> index 60242f6..0d90da3 100644
> --- a/arch/m68k/platform/coldfire/timers.c
> +++ b/arch/m68k/platform/coldfire/timers.c
> @@ -88,7 +88,6 @@ static struct clocksource mcftmr_clk = {
>   	.name	= "tmr",
>   	.rating	= 250,
>   	.read	= mcftmr_read_clk,
> -	.shift	= 20,
>   	.mask	= CLOCKSOURCE_MASK(32),
>   	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
>   };
> @@ -109,8 +108,7 @@ void hw_timer_init(void)
>   	__raw_writew(MCFTIMER_TMR_ENORI | MCFTIMER_TMR_CLK16 |
>   		MCFTIMER_TMR_RESTART | MCFTIMER_TMR_ENABLE, TA(MCFTIMER_TMR));
>
> -	mcftmr_clk.mult = clocksource_hz2mult(FREQ, mcftmr_clk.shift);
> -	clocksource_register(&mcftmr_clk);
> +	clocksource_register_hz(&mcftmr_clk, FREQ);
>
>   	setup_irq(MCF_IRQ_TIMER,&mcftmr_timer_irq);
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
