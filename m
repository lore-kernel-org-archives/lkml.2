Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab2FOWDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:03:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59032 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab2FOWDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:03:48 -0400
Date: Fri, 15 Jun 2012 15:03:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove(v2)
Message-ID: <20120615220343.GA8928@kroah.com>
References: <1339391600-17815-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339391600-17815-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 01:13:20PM +0800, Ming Lei wrote:
> Firstly, .shutdown callback may touch a uninitialized hardware
> if dev->driver is set and .probe is not completed.
> 
> Secondly, device_shutdown() may dereference a null pointer to cause
> oops when dev->driver is cleared after it is checked in
> device_shutdown().
> 
> So just try to hold device lock and its parent lock(if it has) to
> fix the races.
> 
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: stable@vger.kernel.org

Why stable?  Are there known systems that crash right now without this
change?  I don't think we ever heard back from the original poster about
this issue as to what exactly was going wrong.


> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
> v2:
> 	- take Alan's suggestion to use device_trylock to avoid
> 	hanging during shutdown by buggy device or driver
> 	- hold parent reference counter
> 
>  drivers/base/core.c |   32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 346be8b..f2fc989 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1796,6 +1796,16 @@ out:
>  }
>  EXPORT_SYMBOL_GPL(device_move);
>  
> +static int __try_lock(struct device *dev)
> +{
> +	int i = 0;
> +
> +	while (!device_trylock(dev) && i++ < 100)
> +		msleep(10);
> +
> +	return i < 100;
> +}

That's a totally arbritary time, why does this work and other times do
not?  And what is this returning, if the lock was grabbed successfully?
What's with the __ naming?

I really don't like this at all.


> +
>  /**
>   * device_shutdown - call ->shutdown() on each device to shutdown.
>   */
> @@ -1810,8 +1820,11 @@ void device_shutdown(void)
>  	 * devices offline, even as the system is shutting down.
>  	 */
>  	while (!list_empty(&devices_kset->list)) {
> +		int nonlocked;
> +
>  		dev = list_entry(devices_kset->list.prev, struct device,
>  				kobj.entry);
> +		get_device(dev->parent);

Why grab the parent reference?

>  		get_device(dev);
>  		/*
>  		 * Make sure the device is off the kset list, in the
> @@ -1820,6 +1833,18 @@ void device_shutdown(void)
>  		list_del_init(&dev->kobj.entry);
>  		spin_unlock(&devices_kset->list_lock);
>  
> +		/* hold lock to avoid race with .probe/.release */
> +		if (dev->parent && !__try_lock(dev->parent))
> +			nonlocked = 2;
> +		else if (!__try_lock(dev))
> +			nonlocked = 1;
> +		else
> +			nonlocked = 0;

Ick ick ick.  Why can't we just grab the lock to try to only call these
callbacks one at a time?  What is causing the big problem here that I am
missing?

> +
> +		if (nonlocked)
> +			dev_err(dev, "can't hold %slock for shutdown\n",
> +					nonlocked == 1 ? "" : "parent ");

What can anyone do with this message?  I sure wouldn't know what to do
with it, do you?  If so, what?

greg k-h

