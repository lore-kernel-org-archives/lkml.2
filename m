Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175Ab0EYUVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:21:50 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:39111 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996Ab0EYUVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:21:47 -0400
X-Greylist: delayed 6481 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2010 16:21:47 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U+GpcxycrHKUm9XwBwSpXpoc48NLJ4HdouF7tUhfVBIAexBIOyp5Y/e8PnBzz0ZO+Z
         zmKYDLwzuiy9PAGmFSQY6BeGuuv5UhbdUhGCpLaaBsqIDFZKWCX+Dtq6ElBAzku2vDMe
         8itVKx/3y33CzB32WaTTTprM8+IPe1O2GHrF4=
Date: Tue, 25 May 2010 13:21:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
       Michael Roth <mroth@nessie.de>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] touchscreen: ads7846: please don't touch free'd memory
Message-ID: <20100525202135.GC4455@core.coreip.homeip.net>
References: <1274226413-8520-1-git-send-email-khilman@deeprootsystems.com>
 <20100519000019.GA17475@core.coreip.homeip.net>
 <87mxvnlpxv.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mxvnlpxv.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 12:52:12PM -0700, Kevin Hilman wrote:
> Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
> 
> > On Tue, May 18, 2010 at 04:46:53PM -0700, Kevin Hilman wrote:
> >> If the _probe() method fails, the 'ts' struct is freed, yet it is
> >> still used as the drvdata passed to suspend/resume/remove methods.
> >> Even though the input device does not get registerd, the driver's
> >> suspend/resume methods still get called as it's a registered SPI
> >> device.  This patch adds sanity checks to these methods to ensure that
> >> drvdata is valid before using it.
> >> 
> >
> > This is a load of crap. If probe() fails that means that driver does not
> > manage the device and thus ads7846_suspend() and ads7846_resume() should
> > not be called _at all_. If SPI core manages to call random methods from
> > the drivers that failed to bind to a device that should be fixed in SPI
> > core.
> 
> Agreed, this is indeed a bug in the SPI driver core.
> 
> However, by fixing the SPI core to unregister the driver on failure
> (patch below), we prevent the suspend & resume methods from being
> called, but the driver's ->remove() method will still be called due to
> the driver_unregister().  So at least the remove() method needs fixing
> to prevent accessing free'd memory.
> 
> Unless there are objections, I'll post the below along with an updated
> version of ads7846 patch.
> 
> Kevin
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index b3a1f92..42d4d26 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -175,6 +175,8 @@ static void spi_drv_shutdown(struct device *dev)
>   */
>  int spi_register_driver(struct spi_driver *sdrv)
>  {
> +	int ret;
> +
>  	sdrv->driver.bus = &spi_bus_type;
>  	if (sdrv->probe)
>  		sdrv->driver.probe = spi_drv_probe;
> @@ -182,7 +184,12 @@ int spi_register_driver(struct spi_driver *sdrv)
>  		sdrv->driver.remove = spi_drv_remove;
>  	if (sdrv->shutdown)
>  		sdrv->driver.shutdown = spi_drv_shutdown;
> -	return driver_register(&sdrv->driver);
> +
> +	ret = driver_register(&sdrv->driver);
> +	if (!ret)
> +		driver_unregister(&sdrv->driver);

This is still wrong. driver_register() should properly clean up after
itself and not require calls to driver_unregister() (and I believe it
does).

Besides, I do not see how this patch changes anything with regard to
binding devices and drivers. Even if driver_register() succeeds, binding
may still fail and we should not be calling neither ->remove(), nor
->suspend()/->resume() for the devices that failed to be bound.

Still NAK, sorry.

-- 
Dmitry
