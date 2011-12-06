Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1LFWAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:00:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45748 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab1LFWAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:00:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Driver core: leave runtime PM enabled during system shutdown
Date: Tue, 6 Dec 2011 23:03:28 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: NeilBrown <neilb@suse.de>, Ming Lei <tom.leiming@gmail.com>,
        "Chen Peter-B29397" <B29397@freescale.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@vger.kernel.org>,
        "hzpeterchen@gmail.com" <hzpeterchen@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>
References: <Pine.LNX.4.44L0.1112061024240.1469-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1112061024240.1469-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112062303.29191.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 06, 2011, Alan Stern wrote:
> Disabling all runtime PM during system shutdown turns out not to be a
> good idea, because some devices may need to be woken up from a
> low-power state at that time.
> 
> The whole point of disabling runtime PM for system shutdown was to
> prevent untimely runtime-suspend method calls.  This patch (as1504)
> accomplishes the same result by incrementing the usage count for each
> device and waiting for ongoing runtime-PM callbacks to finish.  This
> is what we already do during system suspend and hibernation, which
> makes sense since the shutdown method is pretty much a legacy analog
> of the pm->poweroff method.
> 
> This fixes a regression on some OMAP systems.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Reported-by: NeilBrown <neilb@suse.de>
> CC: Chen Peter-B29397 <B29397@freescale.com>

Greg, do you have any objections against this patch and, if you don't,
would you mind if I took it (it fixes one that went in through my tree).

Thanks,
Rafael


> ---
> 
>  drivers/base/core.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Index: usb-3.2/drivers/base/core.c
> ===================================================================
> --- usb-3.2.orig/drivers/base/core.c
> +++ usb-3.2/drivers/base/core.c
> @@ -1743,8 +1743,10 @@ void device_shutdown(void)
>  		 */
>  		list_del_init(&dev->kobj.entry);
>  		spin_unlock(&devices_kset->list_lock);
> -		/* Disable all device's runtime power management */
> -		pm_runtime_disable(dev);
> +
> +		/* Don't allow any more runtime suspends */
> +		pm_runtime_get_noresume(dev);
> +		pm_runtime_barrier(dev);
>  
>  		if (dev->bus && dev->bus->shutdown) {
>  			dev_dbg(dev, "shutdown\n");
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

