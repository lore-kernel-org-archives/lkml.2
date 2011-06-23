Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840Ab1FWSfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:35:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46098 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759401Ab1FWSfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:35:19 -0400
Date: Thu, 23 Jun 2011 14:35:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI / PM: Block races between runtime PM and system
 sleep
In-Reply-To: <201106231946.30004.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1106231433130.2033-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011, Rafael J. Wysocki wrote:

> OK, so what about the appended patch (the last hunk is necessary to make the
> SCSI error handling work when runtime PM is disabled, it should be a separate
> patch)?
> 
> Rafael
> 
> ---
>  drivers/base/power/main.c    |   27 ++++++++++++++++++++++-----
>  drivers/base/power/runtime.c |   10 ++++++----
>  2 files changed, 28 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6/drivers/base/power/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/main.c
> +++ linux-2.6/drivers/base/power/main.c
> @@ -505,6 +505,7 @@ static int legacy_resume(struct device *
>  static int device_resume(struct device *dev, pm_message_t state, bool async)
>  {
>  	int error = 0;
> +	bool put = false;
>  
>  	TRACE_DEVICE(dev);
>  	TRACE_RESUME(0);
> @@ -521,6 +522,9 @@ static int device_resume(struct device *
>  	if (!dev->power.is_suspended)
>  		goto Unlock;
>  
> +	pm_runtime_enable(dev);
> +	put = true;
> +
>  	if (dev->pwr_domain) {
>  		pm_dev_dbg(dev, state, "power domain ");
>  		error = pm_op(dev, &dev->pwr_domain->ops, state);
> @@ -563,6 +567,10 @@ static int device_resume(struct device *
>  	complete_all(&dev->power.completion);
>  
>  	TRACE_RESUME(error);
> +
> +	if (put)
> +		pm_runtime_put_sync(dev);
> +
>  	return error;
>  }
>  
> @@ -843,16 +851,22 @@ static int __device_suspend(struct devic
>  	int error = 0;
>  
>  	dpm_wait_for_children(dev, async);
> -	device_lock(dev);
>  
>  	if (async_error)
> -		goto Unlock;
> +		return 0;
> +
> +	pm_runtime_get_noresume(dev);
> +	if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
> +		pm_wakeup_event(dev, 0);
>  
>  	if (pm_wakeup_pending()) {
> +		pm_runtime_put_sync(dev);
>  		async_error = -EBUSY;
> -		goto Unlock;
> +		return 0;
>  	}
>  
> +	device_lock(dev);
> +
>  	if (dev->pwr_domain) {
>  		pm_dev_dbg(dev, state, "power domain ");
>  		error = pm_op(dev, &dev->pwr_domain->ops, state);
> @@ -890,12 +904,15 @@ static int __device_suspend(struct devic
>   End:
>  	dev->power.is_suspended = !error;
>  
> - Unlock:
>  	device_unlock(dev);
>  	complete_all(&dev->power.completion);
>  
> -	if (error)
> +	if (error) {
> +		pm_runtime_put_sync(dev);
>  		async_error = error;
> +	} else if (dev->power.is_suspended) {
> +		__pm_runtime_disable(dev, false);
> +	}
>  
>  	return error;
>  }

Looks right.


> Index: linux-2.6/drivers/base/power/runtime.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/runtime.c
> +++ linux-2.6/drivers/base/power/runtime.c
> @@ -455,12 +455,14 @@ static int rpm_resume(struct device *dev
>  	dev_dbg(dev, "%s flags 0x%x\n", __func__, rpmflags);
>  
>   repeat:
> -	if (dev->power.runtime_error)
> +	if (dev->power.runtime_error) {
>  		retval = -EINVAL;
> -	else if (dev->power.disable_depth > 0)
> -		retval = -EAGAIN;
> -	if (retval)
>  		goto out;
> +	} else if (dev->power.disable_depth > 0) {
> +		if (!(rpmflags & RPM_GET_PUT))
> +			retval = -EAGAIN;

Do you also want to check the current status?  If it isn't RPM_ACTIVE 
then perhaps you should return an error.

> +		goto out;
> +	}
>  
>  	/*
>  	 * Other scheduled or pending requests need to be canceled.  Small

Alan Stern

