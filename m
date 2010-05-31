Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab0EaG76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 02:59:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50035 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab0EaG74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 02:59:56 -0400
Date: Mon, 31 May 2010 08:59:38 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Stuart Longland <redhatter@gentoo.org>
Cc: linux-arm-kernel@lists.infradead.org, Sascha Hauer <kernel@pengutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ARM: Add SSI Clock Adjustment for i.MX27 TO2
Message-ID: <20100531065938.GA26820@pengutronix.de>
References: <1275267300-30687-1-git-send-email-redhatter@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1275267300-30687-1-git-send-email-redhatter@gentoo.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:30:50 up 1 day, 15:39, 10 users,  load average: 0.13, 0.22,
	0.34
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stuart,

On Mon, May 31, 2010 at 10:55:00AM +1000, Stuart Longland wrote:
> This adds support for adjusting the SSI clocks using the generic clock
> infrastructure.
> 
> Known bug:
> 	The generated clock is approximately 1/4 of what is requested.
> 	I'm not sure if this is due to a bug in reading MCLK, or
> 	something else dividing the clock down.  Hence the printk's in
> 	get_rate_ssix, and the patch's "RFC" status.

The SSI clock can be switched between mpll and spll in CSCR/SSIx_SEL,
currently this is not handled. Could this be the problem?
Do you measure the resulting clock on the SSI clock pin? If yes, you
could try using the CLKO pin to measure the input clock of the SSI unit.

> 
> This should open the door to using the SSI ports on the i.MX27 in I²S
> Master mode amongst other things.
> 
> Signed-off-by: Stuart Longland <redhatter@gentoo.org>
> ---
>  arch/arm/mach-mx2/clock_imx27.c |   75 +++++++++++++++++++++++++++++++++++++--
>  1 files changed, 72 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-mx2/clock_imx27.c b/arch/arm/mach-mx2/clock_imx27.c
> index 0f0823c..48a4f62 100644
> --- a/arch/arm/mach-mx2/clock_imx27.c
> +++ b/arch/arm/mach-mx2/clock_imx27.c
> @@ -244,12 +244,59 @@ static unsigned long get_rate_ssix(struct clk *clk, unsigned long pdf)
>  
>  	parent_rate = clk_get_rate(clk->parent);
>  
> +	printk("%s: parent = %ld Hz; raw pdf = %ld\n",
> +		__FUNCTION__, parent_rate, pdf );
> +

Please use __func__. Probably doesn't matter because the printks will go
away anyway.

Sascha


>  	if (mx27_revision() >= CHIP_REV_2_0)
>  		pdf += 4;  /* MX27 TO2+ */
>  	else
>  		pdf = (pdf < 2) ? 124UL : pdf;  /* MX21 & MX27 TO1 */
>  
> -	return 2UL * parent_rate / pdf;
> +	printk("%s: parent = %ld Hz;     pdf = %ld\n",
> +		__FUNCTION__, parent_rate, pdf );
> +
> +	return (2UL * parent_rate) / pdf;
> +}
> +
> +static unsigned long set_rate_ssix(struct clk *clk, unsigned long rate)
> +{
> +	unsigned long parent_rate;
> +	unsigned long pdf;
> +
> +	parent_rate = clk_get_rate(clk->parent);
> +	pdf = (2UL * parent_rate) / rate;
> +
> +	if (mx27_revision() >= CHIP_REV_2_0)
> +		pdf -= 4;  /* MX27 TO2+ */
> +
> +	/* TODO: Not sure how to handle other CPU types */
> +#if 0
> +	else
> +		pdf = (pdf < 2) ? 124UL : pdf;  /* MX21 & MX27 TO1 */
> +#endif
> +	printk("%s: %ld Hz => %ld; pdf = %ld\n",
> +			__FUNCTION__, parent_rate, rate, pdf );
> +
> +	return pdf & 0x3f;
> +}
> +
> +static unsigned long round_rate_ssix(struct clk *clk, unsigned long rate)
> +{
> +	unsigned long div;
> +	unsigned long parent_rate = clk_get_rate(clk->parent);
> +
> +	div = (2UL * parent_rate) / rate;
> +	printk("%s: 2* %ld Hz / %ld Hz = %ld\n",
> +			__FUNCTION__, parent_rate, rate, div );
> +
> +	if ( ( div < 4 ) || ( div > 67 ) )
> +		/* Corresponds to divider value < 2 or > 33.5 */
> +		return -EINVAL;
> +
> +	printk("%s: 2* %ld Hz / %ld = %ld\n",
> +			__FUNCTION__, parent_rate, div, (2UL*parent_rate) / div);
> +
> +	return (2UL * parent_rate) / div;
>  }
>  
>  static unsigned long get_rate_ssi1(struct clk *clk)
> @@ -257,11 +304,33 @@ static unsigned long get_rate_ssi1(struct clk *clk)
>  	return get_rate_ssix(clk, (__raw_readl(CCM_PCDR0) >> 16) & 0x3f);
>  }
>  
> +static int set_rate_ssi1(struct clk *clk, unsigned long rate)
> +{
> +	__raw_writel( set_rate_ssix(clk, rate) << 16, CCM_PCDR0 );
> +	return 0;
> +}
> +
> +static unsigned long round_rate_ssi1(struct clk *clk, unsigned long rate)
> +{
> +	return round_rate_ssix(clk, rate);
> +}
> +
>  static unsigned long get_rate_ssi2(struct clk *clk)
>  {
>  	return get_rate_ssix(clk, (__raw_readl(CCM_PCDR0) >> 26) & 0x3f);
>  }
>  
> +static int set_rate_ssi2(struct clk *clk, unsigned long rate)
> +{
> +	__raw_writel( set_rate_ssix(clk, rate) << 26, CCM_PCDR0 );
> +	return 0;
> +}
> +
> +static unsigned long round_rate_ssi2(struct clk *clk, unsigned long rate)
> +{
> +	return round_rate_ssix(clk, rate);
> +}
> +
>  static unsigned long get_rate_nfc(struct clk *clk)
>  {
>  	unsigned long nfc_pdf;
> @@ -564,8 +633,8 @@ DEFINE_CLOCK(cspi1_clk1,   0, PCCR0, 31, NULL, NULL, &ipg_clk);
>  
>  DEFINE_CLOCK(mstick_clk,   0, PCCR1,  2, NULL, &mstick_clk1, &ipg_clk);
>  DEFINE_CLOCK(nfc_clk,      0, PCCR1,  3, get_rate_nfc, NULL, &cpu_clk);
> -DEFINE_CLOCK(ssi2_clk,     1, PCCR1,  4, get_rate_ssi2, &ssi2_clk1, &mpll_main2_clk);
> -DEFINE_CLOCK(ssi1_clk,     0, PCCR1,  5, get_rate_ssi1, &ssi1_clk1, &mpll_main2_clk);
> +DEFINE_CLOCK1(ssi2_clk,     1, PCCR1,  4, ssi2, &ssi2_clk1, &mpll_main2_clk);
> +DEFINE_CLOCK1(ssi1_clk,     0, PCCR1,  5, ssi1, &ssi1_clk1, &mpll_main2_clk);
>  DEFINE_CLOCK(vpu_clk,      0, PCCR1,  6, get_rate_vpu, &vpu_clk1, &mpll_main2_clk);
>  DEFINE_CLOCK1(per4_clk,    3, PCCR1,  7, per, NULL, &mpll_main2_clk);
>  DEFINE_CLOCK1(per3_clk,    2, PCCR1,  8, per, NULL, &mpll_main2_clk);
> -- 
> 1.6.4.4
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
