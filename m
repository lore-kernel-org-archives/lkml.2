Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab1FRX5G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 19:57:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39142 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab1FRX5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 19:57:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] calling runtime PM from system PM methods
Date: Sun, 19 Jun 2011 01:57:31 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1106181123050.29370-100000@netrider.rowland.org> <201106182301.04090.rjw@sisk.pl>
In-Reply-To: <201106182301.04090.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106190157.31526.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 18, 2011, Rafael J. Wysocki wrote:
> On Saturday, June 18, 2011, Alan Stern wrote:
> > On Sat, 18 Jun 2011, Rafael J. Wysocki wrote:
...
> 
> Well, assuming that https://patchwork.kernel.org/patch/893722/ is applied,
> which is going to be, I think we can put
> 
> +       pm_runtime_get_noresume(dev);
> +       pm_runtime_enable(dev);
> 
> in device_resume() after the dev->power.is_suspended check and
> pm_runtime_put_noidle() under the End label.  That cause them to
> be called under the device lock, but that shouldn't be a big deal.
> 
> Accordingly, we can call pm_runtime_disable(dev) in __device_suspend(),
> right next to the setting of power.is_suspended.
> 
> This is implemented by the patch below.

Well, it hangs suspend on my Toshiba test box, I'm not sure why exactly.

This happens even if the pm_runtime_disable() is replaced with a version
that only increments the disable depth, so it looks like something down
the road relies on disable_depth being zero.  Which is worrisome.

Trying to figure out what the problem is I noticed that, for example,
the generic PM operations use pm_runtime_suspended() to decide whether or
not to execute system suspend callbacks, so the patch below would break it.

Also, after commit e8665002477f0278f84f898145b1f141ba26ee26 the
pm_runtime_suspended() check in __pm_generic_call() doesn't really make
sense.

Thanks,
Rafael


> ---
>  drivers/base/power/main.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/base/power/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/main.c
> +++ linux-2.6/drivers/base/power/main.c
> @@ -521,6 +521,9 @@ static int device_resume(struct device *
>  	if (!dev->power.is_suspended)
>  		goto Unlock;
>  
> +	pm_runtime_get_noresume(dev);
> +	pm_runtime_enable(dev);
> +
>  	if (dev->pwr_domain) {
>  		pm_dev_dbg(dev, state, "power domain ");
>  		error = pm_op(dev, &dev->pwr_domain->ops, state);
> @@ -557,6 +560,7 @@ static int device_resume(struct device *
>  
>   End:
>  	dev->power.is_suspended = false;
> +	pm_runtime_put_noidle(dev);
>  
>   Unlock:
>  	device_unlock(dev);
> @@ -888,7 +892,10 @@ static int __device_suspend(struct devic
>  	}
>  
>   End:
> -	dev->power.is_suspended = !error;
> +	if (!error) {
> +		dev->power.is_suspended = true;
> +		pm_runtime_disable(dev);
> +	}
>  
>   Unlock:
>  	device_unlock(dev);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

