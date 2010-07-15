Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab0GOLjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 07:39:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:32785 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab0GOLjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 07:39:51 -0400
Date: Thu, 15 Jul 2010 12:39:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NUC900: patch for implement clk_get_rate
Message-ID: <20100715113939.GE29322@n2100.arm.linux.org.uk>
References: <4C175ED4.8080303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C175ED4.8080303@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 07:07:00PM +0800, Wan ZongShun wrote:
> According to Baruch's advice, I re-orgnize previous patch named
> 'Add platform support for nuc900 i2c driver'.
> 
> This patch is for implementing clk_get_rate, there are four clk
> rates were needed to get, cpufreq,ahb,apb and external crystal.
> clk_get_rate return value is for external crystal.
> 
> ---
>  arch/arm/mach-w90x900/clock.c |    9 +++++++
>  arch/arm/mach-w90x900/clock.h |    5 ++++
>  arch/arm/mach-w90x900/cpu.c   |   50 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 64 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-w90x900/clock.c b/arch/arm/mach-w90x900/clock.c
> index 2c371ff..6325642 100644
> --- a/arch/arm/mach-w90x900/clock.c
> +++ b/arch/arm/mach-w90x900/clock.c
> @@ -57,6 +57,15 @@ EXPORT_SYMBOL(clk_disable);
> 
>  unsigned long clk_get_rate(struct clk *clk)
>  {
> +	unsigned long flags, ret;
> +
> +	if (clk == NULL || IS_ERR(clk))
> +		return -EPERM;

Is there a reason to check for these cases?

> +	spin_lock_irqsave(&clocks_lock, flags);
> +	ret = nuc900_get_cpuclock(&clk->cpufreq, &clk->ahbfreq, &clk->apbfreq);
> +	spin_unlock_irqrestore(&clocks_lock, flags);
> +	if (ret)
> +		return ret;

Hmm, I don't follow this - and it doesn't seem to sit with the clk API
model at all well.  cpufreq/ahbfreq/apbfreq seem to only ever be
written, but never read.  I'm not sure either why every struct clk has
to have these - they seem to be separate clocks unrelated to the
struct clk that's being dealt with.

Wouldn't it make more sense to have these three as separate struct clks?

The other issue is that we're introducing an "apb_pclk" for all
primecells using drivers/amba/bus.c in order to support SoCs which gate
the APB pclk signal to individual primecells.  It sounds like this clock
would be the natural owner what you call 'apbfreq' in your patch.
