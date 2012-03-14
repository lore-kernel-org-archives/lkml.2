Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021Ab2CNHxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:53:11 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:57005 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673Ab2CNHxH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:53:07 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Chris Ball <cjb@laptop.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/3] mmc: sdhci: check interrupt flags in ISR again
Date: Wed, 14 Mar 2012 08:53:05 +0100
Message-ID: <1994979.AaWWmIIAYQ@ws-stein>
User-Agent: KMail/4.7.4 (Linux/3.2.1-gentoo-r2; KDE/4.7.4; x86_64; ; )
In-Reply-To: <4F604B16.606@intel.com>
References: <1331659002-13743-1-git-send-email-alexander.stein@systec-electronic.com> <1331659002-13743-2-git-send-email-alexander.stein@systec-electronic.com> <4F604B16.606@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am Mittwoch, 14. März 2012, 09:39:02 schrieb Adrian Hunter:
> On 13/03/12 19:16, Alexander Stein wrote:
> > When using MSI it is possible that a new MSI is sent while an earlier
> > MSI is currently handled. In this case SDHCI_INT_STATUS only contains
> > SDHCI_INT_RESPONSE and the ISR would not be called again. But at the end
> > of the ISR SDHCI_INT_DATA_END is now also pending which would be
> > ignored.
> > 
> > Fix this by rereading the interrupt flags in the ISR until no interrupt
> > we care is pending.
> > 
> > Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
> [...]
> > @@ -2336,6 +2338,14 @@ static irqreturn_t sdhci_irq(int irq, void
> > *dev_id)> 
> >  		sdhci_writel(host, SDHCI_INT_BUS_POWER, SDHCI_INT_STATUS);
> >  	
> >  	}
> > 
> > +	intmask_unhandled = intmask;
> > +
> > +	intmask = sdhci_readl(host, SDHCI_INT_STATUS);
> > +
> > +	/* Do interrupt handling again if we got new flags */
> > +	if (intmask & ~intmask_unhandled)
> > +		goto again;
> > +
> > 
> >  	intmask &= ~SDHCI_INT_BUS_POWER;
> >  	
> >  	if (intmask & SDHCI_INT_CARD_INT)
> 
> Why not just replace mmiowb() i.e.
> 
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 8d66706..da8a101 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -2353,7 +2353,9 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
> 
>         result = IRQ_HANDLED;
> 
> -       mmiowb();
> +       intmask = sdhci_readl(host, SDHCI_INT_STATUS);
> +       if (intmask)
> +               goto again;
>  out:
>         spin_unlock(&host->lock);
> 

Well, I chose this way to only printk the error once. With your suggestion it 
might be printed in each loop, dunno how often/fast these IRQ stats are set 
again after clearing. This would end in an endless loop if error flags are set 
again fast enough, but see below.
But in general I like this approach.

> But maybe it would be safer limiting the number of loops i.e.
> 
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 8d66706..d88247d 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -2268,7 +2268,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
>         irqreturn_t result;
>         struct sdhci_host *host = dev_id;
>         u32 intmask;
> -       int cardint = 0;
> +       int cardint = 0, max_loops = 16;
> 
>         spin_lock(&host->lock);
> 
> @@ -2353,7 +2353,9 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
> 
>         result = IRQ_HANDLED;
> 
> -       mmiowb();
> +       intmask = sdhci_readl(host, SDHCI_INT_STATUS);
> +       if (intmask && --max_loops)
> +               goto again;
>  out:
>         spin_unlock(&host->lock);

The actual problem I saw was a CMD6 command with an R1b response where the IRQ 
for the 'not busy' event was sent during ISR for the response. So I think 
normally this should only occur once.
Regarding error flags I masked the unhandled flags out in order to print an 
error only once, even if they might be set again in the next loop. With a 
simple check on intmask they might occur up to 16 times in the kernel log.
IMHO it makes no sense to repeatedly print errors about interrupt flags we 
don't handle.

Suggestions to get a more clean way?

Best regards,
Alexander
-- 
Dipl.-Inf. Alexander Stein

SYS TEC electronic GmbH
August-Bebel-Str. 29
D-07973 Greiz

Tel: +49-3661-6279-0, Fax: +49-3661-6279-99
eMail:    Alexander.Stein@systec-electronic.com
Internet: http://www.systec-electronic.com

Managing Director: Dipl.-Phys. Siegmar Schmidt
Commercial registry: Amtsgericht Jena, HRB 205563
