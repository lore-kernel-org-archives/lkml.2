Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1LIXCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:02:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51350 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab1LIXCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:02:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] PM / Sleep: Simplify generic system suspend callbacks
Date: Sat, 10 Dec 2011 00:05:24 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <201111180037.22157.rjw@sisk.pl> <201111271341.36155.rjw@sisk.pl>
In-Reply-To: <201111271341.36155.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112100005.24798.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 27, 2011, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The pm_runtime_suspended() check in __pm_generic_call() doesn't
> really help and may cause problems to happen, because in some cases
> the system suspend callbacks need to be called even if the given
> device has been suspended by runtime PM.  For example, if the device
> generally supports remote wakeup and is not enabled to wake up
> the system from sleep, it should be prevented from generating wakeup
> signals during system suspend and that has to be done by the
> suspend callbacks that the pm_runtime_suspended() check prevents from
> being executed.
> 
> Similarly, it may not be a good idea to unconditionally change
> the runtime PM status of the device to 'active' in
> __pm_generic_resume(), because the driver may want to leave the
> device in the 'suspended' state, depending on what happened to it
> before the system suspend and whether or not it is enabled to
> wake up the system.
> 
> For the above reasons, remove the pm_runtime_suspended()
> check from __pm_generic_call() and remove the code changing the
> device's runtime PM status from __pm_generic_resume().
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Well, I'm not seeing any objections, so I gather so this change is fine
by everyone.  I'm going to put it into linux-pm/linux-next, then.

Thanks,
Rafael


> ---
>  drivers/base/power/generic_ops.c |   15 ++-------------
>  1 file changed, 2 insertions(+), 13 deletions(-)
> 
> Index: linux/drivers/base/power/generic_ops.c
> ===================================================================
> --- linux.orig/drivers/base/power/generic_ops.c
> +++ linux/drivers/base/power/generic_ops.c
> @@ -106,7 +106,7 @@ static int __pm_generic_call(struct devi
>  	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>  	int (*callback)(struct device *);
>  
> -	if (!pm || pm_runtime_suspended(dev))
> +	if (!pm)
>  		return 0;
>  
>  	switch (event) {
> @@ -224,7 +224,6 @@ static int __pm_generic_resume(struct de
>  {
>  	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>  	int (*callback)(struct device *);
> -	int ret;
>  
>  	if (!pm)
>  		return 0;
> @@ -241,17 +240,7 @@ static int __pm_generic_resume(struct de
>  		break;
>  	}
>  
> -	if (!callback)
> -		return 0;
> -
> -	ret = callback(dev);
> -	if (!ret && !noirq && pm_runtime_enabled(dev)) {
> -		pm_runtime_disable(dev);
> -		pm_runtime_set_active(dev);
> -		pm_runtime_enable(dev);
> -	}
> -
> -	return ret;
> +	return callback ? callback(dev) : 0;
>  }
>  
>  /**
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

