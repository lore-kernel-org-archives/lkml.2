Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0DVLlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 07:41:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44959 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab0DVLln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 07:41:43 -0400
Date: Thu, 22 Apr 2010 13:41:41 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: Russell King <linux@arm.linux.org.uk>,
       Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mxc: Change gpt timer code to be more generic by using
	V2 instead of MX3
Message-ID: <20100422114141.GQ7882@pengutronix.de>
References: <d882e9d8c3986d793a331071afdeb8c48229040f.1271864854.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d882e9d8c3986d793a331071afdeb8c48229040f.1271864854.git.amit.kucheria@canonical.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:41:34 up 33 days, 31 min, 61 users,  load average: 4.45, 2.66,
	2.97
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 09:34:36PM +0300, Amit Kucheria wrote:
> Replace mx3_ with v2_ since the register layout is the same for all SoCs using
> version 2 of the timer (mx25, mx31, mx37 and now mx51)

Ok, applied.

> 
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> ---
>  arch/arm/plat-mxc/time.c |   44 ++++++++++++++++++++++----------------------
>  1 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/arm/plat-mxc/time.c b/arch/arm/plat-mxc/time.c
> index c1ce51a..714bdef 100644
> --- a/arch/arm/plat-mxc/time.c
> +++ b/arch/arm/plat-mxc/time.c
> @@ -54,14 +54,14 @@
>  #define MX2_TSTAT_COMP		(1 << 0)
>  
>  /* MX31, MX35, MX25, MXC91231, MX5 */
> -#define MX3_TCTL_WAITEN		(1 << 3) /* Wait enable mode */
> -#define MX3_TCTL_CLK_IPG	(1 << 6)
> -#define MX3_TCTL_FRR		(1 << 9)
> -#define MX3_IR			0x0c
> -#define MX3_TSTAT		0x08
> -#define MX3_TSTAT_OF1		(1 << 0)
> -#define MX3_TCN			0x24
> -#define MX3_TCMP		0x10
> +#define V2_TCTL_WAITEN		(1 << 3) /* Wait enable mode */
> +#define V2_TCTL_CLK_IPG		(1 << 6)
> +#define V2_TCTL_FRR		(1 << 9)
> +#define V2_IR			0x0c
> +#define V2_TSTAT		0x08
> +#define V2_TSTAT_OF1		(1 << 0)
> +#define V2_TCN			0x24
> +#define V2_TCMP			0x10
>  
>  #define timer_is_v1()	(cpu_is_mx1() || cpu_is_mx21() || cpu_is_mx27())
>  #define timer_is_v2()	(!timer_is_v1())
> @@ -76,7 +76,7 @@ static inline void gpt_irq_disable(void)
>  	unsigned int tmp;
>  
>  	if (timer_is_v2())
> -		__raw_writel(0, timer_base + MX3_IR);
> +		__raw_writel(0, timer_base + V2_IR);
>  	else {
>  		tmp = __raw_readl(timer_base + MXC_TCTL);
>  		__raw_writel(tmp & ~MX1_2_TCTL_IRQEN, timer_base + MXC_TCTL);
> @@ -86,7 +86,7 @@ static inline void gpt_irq_disable(void)
>  static inline void gpt_irq_enable(void)
>  {
>  	if (timer_is_v2())
> -		__raw_writel(1<<0, timer_base + MX3_IR);
> +		__raw_writel(1<<0, timer_base + V2_IR);
>  	else {
>  		__raw_writel(__raw_readl(timer_base + MXC_TCTL) | MX1_2_TCTL_IRQEN,
>  			timer_base + MXC_TCTL);
> @@ -110,9 +110,9 @@ static cycle_t mx1_2_get_cycles(struct clocksource *cs)
>  	return __raw_readl(timer_base + MX1_2_TCN);
>  }
>  
> -static cycle_t mx3_get_cycles(struct clocksource *cs)
> +static cycle_t v2_get_cycles(struct clocksource *cs)
>  {
> -	return __raw_readl(timer_base + MX3_TCN);
> +	return __raw_readl(timer_base + V2_TCN);
>  }
>  
>  static struct clocksource clocksource_mxc = {
> @@ -129,7 +129,7 @@ static int __init mxc_clocksource_init(struct clk *timer_clk)
>  	unsigned int c = clk_get_rate(timer_clk);
>  
>  	if (timer_is_v2())
> -		clocksource_mxc.read = mx3_get_cycles;
> +		clocksource_mxc.read = v2_get_cycles;
>  
>  	clocksource_mxc.mult = clocksource_hz2mult(c,
>  					clocksource_mxc.shift);
> @@ -153,16 +153,16 @@ static int mx1_2_set_next_event(unsigned long evt,
>  				-ETIME : 0;
>  }
>  
> -static int mx3_set_next_event(unsigned long evt,
> +static int v2_set_next_event(unsigned long evt,
>  			      struct clock_event_device *unused)
>  {
>  	unsigned long tcmp;
>  
> -	tcmp = __raw_readl(timer_base + MX3_TCN) + evt;
> +	tcmp = __raw_readl(timer_base + V2_TCN) + evt;
>  
> -	__raw_writel(tcmp, timer_base + MX3_TCMP);
> +	__raw_writel(tcmp, timer_base + V2_TCMP);
>  
> -	return (int)(tcmp - __raw_readl(timer_base + MX3_TCN)) < 0 ?
> +	return (int)(tcmp - __raw_readl(timer_base + V2_TCN)) < 0 ?
>  				-ETIME : 0;
>  }
>  
> @@ -192,8 +192,8 @@ static void mxc_set_mode(enum clock_event_mode mode,
>  	if (mode != clockevent_mode) {
>  		/* Set event time into far-far future */
>  		if (timer_is_v2())
> -			__raw_writel(__raw_readl(timer_base + MX3_TCN) - 3,
> -					timer_base + MX3_TCMP);
> +			__raw_writel(__raw_readl(timer_base + V2_TCN) - 3,
> +					timer_base + V2_TCMP);
>  		else
>  			__raw_writel(__raw_readl(timer_base + MX1_2_TCN) - 3,
>  					timer_base + MX1_2_TCMP);
> @@ -245,7 +245,7 @@ static irqreturn_t mxc_timer_interrupt(int irq, void *dev_id)
>  	uint32_t tstat;
>  
>  	if (timer_is_v2())
> -		tstat = __raw_readl(timer_base + MX3_TSTAT);
> +		tstat = __raw_readl(timer_base + V2_TSTAT);
>  	else
>  		tstat = __raw_readl(timer_base + MX1_2_TSTAT);
>  
> @@ -276,7 +276,7 @@ static int __init mxc_clockevent_init(struct clk *timer_clk)
>  	unsigned int c = clk_get_rate(timer_clk);
>  
>  	if (timer_is_v2())
> -		clockevent_mxc.set_next_event = mx3_set_next_event;
> +		clockevent_mxc.set_next_event = v2_set_next_event;
>  
>  	clockevent_mxc.mult = div_sc(c, NSEC_PER_SEC,
>  					clockevent_mxc.shift);
> @@ -308,7 +308,7 @@ void __init mxc_timer_init(struct clk *timer_clk, void __iomem *base, int irq)
>  	__raw_writel(0, timer_base + MXC_TPRER); /* see datasheet note */
>  
>  	if (timer_is_v2())
> -		tctl_val = MX3_TCTL_CLK_IPG | MX3_TCTL_FRR | MX3_TCTL_WAITEN | MXC_TCTL_TEN;
> +		tctl_val = V2_TCTL_CLK_IPG | V2_TCTL_FRR | V2_TCTL_WAITEN | MXC_TCTL_TEN;
>  	else
>  		tctl_val = MX1_2_TCTL_FRR | MX1_2_TCTL_CLK_PCLK1 | MXC_TCTL_TEN;
>  
> -- 
> 1.7.0.4
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
