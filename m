Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab1DZLv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 07:51:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51911 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab1DZLvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 07:51:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [linux-pm] [PATCH/RFC] MMC: remove unbalanced pm_runtime_suspend()
Date: Tue, 26 Apr 2011 13:51:59 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
        Alan Stern <stern@rowland.harvard.edu>, linux-mmc@vger.kernel.org,
        Magnus Damm <damm@opensource.se>, LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1104221709030.1791-100000@iolanthe.rowland.org> <201104251229.27263.rjw@sisk.pl> <Pine.LNX.4.64.1104261239270.11811@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1104261239270.11811@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104261351.59622.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 26, 2011, Guennadi Liakhovetski wrote:
> Hi

Hi,

> On Mon, 25 Apr 2011, Rafael J. Wysocki wrote:
> 
> > On Saturday, April 23, 2011, Rafael J. Wysocki wrote:
> > > On Friday, April 22, 2011, Alan Stern wrote:
> > > > On Fri, 22 Apr 2011, Rafael J. Wysocki wrote:
> > > > 
> > > > > > The barrier would not prevent the race between the notifier and runtie PM
> > > > > > from taking place.  Why don't we do something like this instead:
> > > > > > 
> > > > > > ---
> > > > > >  drivers/base/dd.c |    3 ++-
> > > > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > > > 
> > > > > > Index: linux-2.6/drivers/base/dd.c
> > > > > > ===================================================================
> > > > > > --- linux-2.6.orig/drivers/base/dd.c
> > > > > > +++ linux-2.6/drivers/base/dd.c
> > > > > > @@ -326,6 +326,8 @@ static void __device_release_driver(stru
> > > > > >  						     BUS_NOTIFY_UNBIND_DRIVER,
> > > > > >  						     dev);
> > > > > >  
> > > > > > +		pm_runtime_put_sync(dev);
> > > > > > +
> > > > > 
> > > > > In fact, I think this one may be _noidle.  If we allow the bus/driver
> > > > > to do what they wont, we might as well let them handle the "device idle"
> > > > > case from ->remove().
> > > > 
> > > > Maybe...  But keeping it put_sync doesn't do any harm.  In Guennadi's 
> > > > case, it might allow him to get rid of the pm_runtime_suspend() call in 
> > > > the remove routine.
> > > > 
> > > > > >  		if (dev->bus && dev->bus->remove)
> > > > > >  			dev->bus->remove(dev);
> > > > > >  		else if (drv->remove)
> > > > > > @@ -338,7 +340,6 @@ static void __device_release_driver(stru
> > > > > >  						     BUS_NOTIFY_UNBOUND_DRIVER,
> > > > > >  						     dev);
> > > > > >  
> > > > > > -		pm_runtime_put_sync(dev);
> > > > > >  	}
> > > > > >  }
> > > > 
> > > > Basically this is okay with me, and it should allow Guennadi to avoid
> > > > the extra put/get pair.
> > > 
> > > OK, so I'm going to put the appended patch into my linux-next branch
> > > (hopefully, the problem is explained sufficiently in the changelog).
> > 
> > I thought about that a bit more and came to the conclusion that we should
> > do things a bit differently in __device_release_driver().  Namely, the fact
> > that the device can be resumed (either synchronously or asynchronously) after
> > the pm_runtime_barrier() has returned may be problematic too, because it
> > may race with the bus notifier in some cases.  For this reason, I think it
> > would be better to do pm_runtime_get_sync() instead of the
> > pm_runtime_get_noresume() and pm_runtime_barrier().
> > 
> > So, I think the appended patch would be better than the previous one.
> 
> I refrained in taking part in the general rtpm API behaviour, I'd rather 
> rely on others here. If you push this your patch, I'll have to change my 
> TMIO/SDHI and MMCIF patches as follows:
> 
> diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
> index 1889d64..3a22e55 100644
> --- a/drivers/mmc/host/sh_mmcif.c
> +++ b/drivers/mmc/host/sh_mmcif.c
> @@ -1117,6 +1117,8 @@ static int __devexit sh_mmcif_remove(struct platform_device *pdev)
>  	struct sh_mmcif_host *host = platform_get_drvdata(pdev);
>  	int irq[2];
>  
> +	pm_runtime_get_sync(&pdev->dev);
> +
>  	mmc_remove_host(host->mmc);
>  	sh_mmcif_release_dma(host);
>  
> @@ -1137,7 +1139,6 @@ static int __devexit sh_mmcif_remove(struct platform_device *pdev)
>  	mmc_free_host(host->mmc);
>  	pm_runtime_put_sync(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
> -	pm_runtime_get_noresume(&pdev->dev);
>  
>  	return 0;
>  }
> diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
> index 26598f1..86eaa68 100644
> --- a/drivers/mmc/host/tmio_mmc_pio.c
> +++ b/drivers/mmc/host/tmio_mmc_pio.c
> @@ -956,17 +956,9 @@ void tmio_mmc_host_remove(struct tmio_mmc_host *host)
>  	iounmap(host->ctl);
>  	mmc_free_host(host->mmc);
>  
> -	/*
> -	 * Now rtpm usage_count = 2, because we incremented it once in probe()
> -	 * above, and dd.c incremented it again, before calling .release(). So.
> -	 * to power the device down we have to decrement the counter to 0 and
> -	 * suspend it, because after our disable() suspending from dd.c will
> -	 * only decrement the counter, but not call any callbacks
> -	 */
> -	pm_runtime_put_noidle(&pdev->dev);
> +	/* Compensate for pm_runtime_get_sync() in probe() above */
>  	pm_runtime_put_sync(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
> -	pm_runtime_get_noresume(&pdev->dev);
>  }
>  EXPORT_SYMBOL(tmio_mmc_host_remove);

So you won't get the reversed _put/_get calls any more here, good. :-)

> Is this your patch final and shall I submit updated versions of my patches 

This patch will be final if there are no objections from other people.

> or shall I wait for your patch to take its final form and hit "next?"

It generally is better to wait for a patch to appear in linux-next before
basing you work on top of it.

Thanks,
Rafael
