Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab1CATxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:53:48 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51517 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757195Ab1CATxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:53:47 -0500
Date: Tue, 1 Mar 2011 14:53:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pierre Tardy <tardyp@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-pm@lists.linux-foundation.org>,
        <linux-mmc@vger.kernel.org>
Subject: Re: [linux-pm] [RFC, PATCHv3 3/3] mmc: sdhci: handle wake-up from
 runtime_pm
In-Reply-To: <b01ca43311e25bf24c6e60e9f6d6d7b91ae3a130.1298820826.git.tardyp@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1103011448430.2034-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Pierre Tardy wrote:

> When sdhci is runtime_suspended, it can still receive a wake-up
> because of card insertion.
> The wake-up will then be signaled by an interrupt which cannot be serviced
> immediatly, as the device is powered off, and register are not accessibles.
> 
> We cannot call pm_runtime_get_sync() in irq context as on some architecture (e.g. intel_mid),
> runtime_resume can lead to too much latency, due to e.g. PLL warm-up and such aggressive
> power gating.
> 
> We temporarly disable the interrupt, and trigger a runtime_resume of the device
> The interrupt will be re-enabled when resume is finished.
> 
> Signed-off-by: Pierre Tardy <tardyp@gmail.com>
> ---
>  drivers/mmc/host/sdhci-pci.c |    8 +-------
>  drivers/mmc/host/sdhci.c     |   30 +++++++++++++++++++++++++++++-
>  include/linux/mmc/sdhci.h    |    2 ++
>  scripts/checkpatch.pl        |    6 +++---
>  4 files changed, 35 insertions(+), 11 deletions(-)

> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 735c3f7..85a1956 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1599,6 +1599,21 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
>  	u32 intmask;
>  	int cardint = 0;
>  
> +	/* we might come from a sd insertion or sdio irq wake.. */
> +	if (pm_runtime_suspended()) {
> +		host->waking_up = 1;
> +		/* Note that we disable temporarly the interrupt until we do the
> +		 * resume. If we don't then we'll get constantly interrupted
> +		 * until we actually resume.
> +		 *
> +		 * as the irq is shared, this might not be very friendly to our
> +		 * irq sharers but the pm_runtime workqueue should really be
> +		 * called soon.

Instead of disabling the IRQ, would it be possible to tell the device 
to stop generating an interrupt request?

> +		 */
> +		disable_irq_nosync(irq);
> +		pm_runtime_get(host->mmc->parent);

Does this pm_runtime_get() have a corresponding pm_runtime_put()?  I 
didn't notice one anywhere.

> +		return IRQ_NONE;
> +	}
>  	spin_lock(&host->lock);
>  
>  	intmask = sdhci_readl(host, SDHCI_INT_STATUS);
> @@ -1747,7 +1762,12 @@ EXPORT_SYMBOL_GPL(sdhci_enable_irq_wakeups);
>  
>  int sdhci_runtime_suspend(struct sdhci_host *host)
>  {
> -	/* nothing to do yet */
> +	u8 val;
> +	/* make sure we wake up on sdcard insert/remove enabled */
> +	val = SDHCI_WAKE_ON_INSERT | SDHCI_WAKE_ON_REMOVE;
> +	if (host->mmc->pm_flags & MMC_PM_WAKE_SDIO_IRQ)
> +		val |= SDHCI_WAKE_ON_INT;
> +	sdhci_writeb(host, val, SDHCI_WAKE_UP_CONTROL);
>  	return 0;
>  }
>  
> @@ -1768,6 +1788,14 @@ int sdhci_runtime_resume(struct sdhci_host *host)
>  	sdhci_set_ios(host->mmc, &host->mmc->ios);
>  	mmiowb();
>  
> +	if (host->waking_up) {
> +		host->waking_up = 0;
> +		/* Re-enable the irq now we are perfectly resumed.
> +		 * Any yet unhandled interrupt (i.e. the wake) will retrigger
> +		 * irq
> +		 */
> +		irq_enable(host->irq);
> +	}
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(sdhci_runtime_resume);

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index e3c7fc0..17aeda3 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1325,8 +1325,8 @@ sub process {
>  		$prefix = "$filename:$realline: " if ($emacs && $file);
>  		$prefix = "$filename:$linenr: " if ($emacs && !$file);
>  
> -		$here = "#$linenr: " if (!$file);
> -		$here = "#$realline: " if ($file);
> +		$here = "" if (!$file);
> +		$here = "" if ($file);
>  
>  		# extract the filename as it passes
>  		if ($line =~ /^diff --git.*?(\S+)$/) {
> @@ -1349,7 +1349,7 @@ sub process {
>  			next;
>  		}
>  
> -		$here .= "FILE: $realfile:$realline:" if ($realcnt != 0);
> +		$here .= "$realfile:$realline:" if ($realcnt != 0);
>  
>  		my $hereline = "$here\n$rawline\n";
>  		my $herecurr = "$here\n$rawline\n";
> 

Surely this doesn't belong in the patch.

Alan Stern

