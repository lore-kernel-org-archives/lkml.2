Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab0GHPgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 11:36:41 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46971 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab0GHPgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 11:36:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kjq24ZlYDfkb+kSQB7ldyLdWTx9r/DkHTo51hSFXwRz1EI6UrMIjGmTr7+W2QxFswB
         +QeqrLvgSUmuPKtKGXaREV/4uVQ1fYiuicmgY2QLYoCE0IKUf7pfww8EoXn7if9v9S7h
         pTWSBsy06eMF/CNiTiCmITQp0GQZ/0QwOTXvM=
Date: Thu, 8 Jul 2010 19:36:29 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Dooks <ben@simtec.co.uk>,
       Richard =?utf-8?Q?R=C3=B6jfors?= <richard.rojfors@pelagicore.com>,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sdhci-pltfm: Add support for CNS3xxx SoC devices
Message-ID: <20100708153629.GA418@oksana.dev.rtsoft.ru>
References: <20100625180527.GA11280@oksana.dev.rtsoft.ru>
 <20100625180644.GC18241@oksana.dev.rtsoft.ru>
 <20100701134839.d7cb4841.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100701134839.d7cb4841.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delayed response,

On Thu, Jul 01, 2010 at 01:48:39PM -0700, Andrew Morton wrote:
> On Fri, 25 Jun 2010 22:06:44 +0400
> Anton Vorontsov <avorontsov@mvista.com> wrote:
> 
> > There's nothing special, just SoC-specific ops and quirks.
> > 
> > ...
> >
> > +static void sdhci_cns3xxx_set_clock(struct sdhci_host *host, unsigned int clock)
> > +{
> > +	struct device *dev = mmc_dev(host->mmc);
> > +	int div = 1;
> > +	u16 clk;
> > +	unsigned long timeout;
> > +
> > +	if (clock == host->clock)
> > +		return;
> 
> I assume that mmc core prevents this function from being exectued twice
> at the same time?

Yep, it's called under spin_lock_irqsave(&host->lock, flags).

[...]
> > +	timeout = 20;
> > +	while (!((clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL))
> > +			& SDHCI_CLOCK_INT_STABLE)) {
> > +		if (timeout == 0) {
> > +			dev_warn(dev, "clock is unstable");
> > +			break;
> > +		}
> > +		timeout--;
> > +		mdelay(1);
> 
> Could we have used the more polite msleep() here?

Unfortunately not, we're in the atomic context.

[...]
> > --- a/drivers/mmc/host/sdhci-pltfm.c
> > +++ b/drivers/mmc/host/sdhci-pltfm.c
> > @@ -158,6 +158,9 @@ static int __devexit sdhci_pltfm_remove(struct platform_device *pdev)
> >  
> >  static const struct platform_device_id sdhci_pltfm_ids[] = {
> >  	{ "sdhci", },
> > +#ifdef CONFIG_MMC_SDHCI_CNS3XXX
> > +	{ "sdhci-cns3xxx", (kernel_ulong_t)&sdhci_cns3xxx_pdata },
> > +#endif
> 
> What the heck is this kernel_ulong_t thing and why did `struct
> platform_device_id' see a need to invent it??

It's not only platform_device_id's thing. Sometimes drivers just
pass a constant instead of a pointer (e.g. DEVICE_IS_FOO,
DEVICE_IS_BAR), for example see drivers/hwmon/lm75.c (enum
lm75_type).

Other than this I don't think that there's a good reason for it.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
