Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab0GAUtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:49:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755647Ab0GAUs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:48:59 -0400
Date: Thu, 1 Jul 2010 13:48:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <avorontsov@mvista.com>
Cc: Ben Dooks <ben@simtec.co.uk>,
       Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sdhci-pltfm: Add support for CNS3xxx SoC devices
Message-Id: <20100701134839.d7cb4841.akpm@linux-foundation.org>
In-Reply-To: <20100625180644.GC18241@oksana.dev.rtsoft.ru>
References: <20100625180527.GA11280@oksana.dev.rtsoft.ru>
	<20100625180644.GC18241@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010 22:06:44 +0400
Anton Vorontsov <avorontsov@mvista.com> wrote:

> There's nothing special, just SoC-specific ops and quirks.
> 
> ...
>
> +static void sdhci_cns3xxx_set_clock(struct sdhci_host *host, unsigned int clock)
> +{
> +	struct device *dev = mmc_dev(host->mmc);
> +	int div = 1;
> +	u16 clk;
> +	unsigned long timeout;
> +
> +	if (clock == host->clock)
> +		return;

I assume that mmc core prevents this function from being exectued twice
at the same time?

> +	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
> +
> +	if (clock == 0)
> +		goto out;
> +
> +	while (host->max_clk / div > clock) {
> +		/*
> +		 * On CNS3xxx divider grows linearly up to 4, and then
> +		 * exponentially up to 256.
> +		 */
> +		if (div < 4)
> +			div += 1;
> +		else if (div < 256)
> +			div *= 2;
> +		else
> +			break;
> +	}
> +
> +	dev_dbg(dev, "desired SD clock: %d, actual: %d\n",
> +		clock, host->max_clk / div);
> +
> +	/* Divide by 3 is special. */
> +	if (div != 3)
> +		div >>= 1;
> +
> +	clk = div << SDHCI_DIVIDER_SHIFT;
> +	clk |= SDHCI_CLOCK_INT_EN;
> +	sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
> +
> +	timeout = 20;
> +	while (!((clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL))
> +			& SDHCI_CLOCK_INT_STABLE)) {
> +		if (timeout == 0) {
> +			dev_warn(dev, "clock is unstable");
> +			break;
> +		}
> +		timeout--;
> +		mdelay(1);

Could we have used the more polite msleep() here?

> +	}
> +
> +	clk |= SDHCI_CLOCK_CARD_EN;
> +	sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
> +out:
> +	host->clock = clock;
> +}
> +
>
> ...
>
> --- a/drivers/mmc/host/sdhci-pltfm.c
> +++ b/drivers/mmc/host/sdhci-pltfm.c
> @@ -158,6 +158,9 @@ static int __devexit sdhci_pltfm_remove(struct platform_device *pdev)
>  
>  static const struct platform_device_id sdhci_pltfm_ids[] = {
>  	{ "sdhci", },
> +#ifdef CONFIG_MMC_SDHCI_CNS3XXX
> +	{ "sdhci-cns3xxx", (kernel_ulong_t)&sdhci_cns3xxx_pdata },
> +#endif

What the heck is this kernel_ulong_t thing and why did `struct
platform_device_id' see a need to invent it??


>  	{ },
>  };
>  MODULE_DEVICE_TABLE(platform, sdhci_pltfm_ids);
>
> ...
>
