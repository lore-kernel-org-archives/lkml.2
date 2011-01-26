Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab1AZL5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:57:48 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58602 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab1AZL5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:57:47 -0500
Date: Wed, 26 Jan 2011 13:00:56 +0100
From: Borislav Petkov <bp@amd64.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/7] sysdev: Do not register with sysdev when erroring
 on add
Message-ID: <20110126120056.GA25525@aftab>
References: <1295882943-11184-1-git-send-email-bp@amd64.org>
 <1295882943-11184-2-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295882943-11184-2-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 10:28:57AM -0500, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> When encountering an error while executing the driver's ->add method, we
> should cancel registration and unwind what we've regged so far. The low
> level ->add methods do return proper error codes but those aren't looked
> at in sysdev_driver_register(). Fix that by sharing the unregistering
> code.
> 
> Also, fixup warning messages formatting while at it.
> 
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Greg, can I get an ACK/NACK please :) ?

Also, whether it is ok to go through -tip?

Thanks.

> ---
>  drivers/base/sys.c |   65 ++++++++++++++++++++++++++++++++++++---------------
>  1 files changed, 46 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/base/sys.c b/drivers/base/sys.c
> index 1667aaf..f6fb547 100644
> --- a/drivers/base/sys.c
> +++ b/drivers/base/sys.c
> @@ -166,6 +166,36 @@ EXPORT_SYMBOL_GPL(sysdev_class_unregister);
>  
>  static DEFINE_MUTEX(sysdev_drivers_lock);
>  
> +/*
> + * @dev != NULL means that we're unwinding because some drv->add()
> + * failed for some reason. You need to grab sysdev_drivers_lock before
> + * calling this.
> + */
> +static void __sysdev_driver_remove(struct sysdev_class *cls,
> +				   struct sysdev_driver *drv,
> +				   struct sys_device *from_dev)
> +{
> +	struct sys_device *dev = from_dev;
> +
> +	list_del_init(&drv->entry);
> +	if (!cls)
> +		return;
> +
> +	if (!drv->remove)
> +		goto kset_put;
> +
> +	if (dev)
> +		list_for_each_entry_continue_reverse(dev, &cls->kset.list,
> +						     kobj.entry)
> +			drv->remove(dev);
> +	else
> +		list_for_each_entry(dev, &cls->kset.list, kobj.entry)
> +			drv->remove(dev);
> +
> +kset_put:
> +	kset_put(&cls->kset);
> +}
> +
>  /**
>   *	sysdev_driver_register - Register auxillary driver
>   *	@cls:	Device class driver belongs to.
> @@ -175,14 +205,14 @@ static DEFINE_MUTEX(sysdev_drivers_lock);
>   *	called on each operation on devices of that class. The refcount
>   *	of @cls is incremented.
>   */
> -
>  int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
>  {
> +	struct sys_device *dev = NULL;
>  	int err = 0;
>  
>  	if (!cls) {
> -		WARN(1, KERN_WARNING "sysdev: invalid class passed to "
> -			"sysdev_driver_register!\n");
> +		WARN(1, KERN_WARNING "sysdev: invalid class passed to %s!\n",
> +			__func__);
>  		return -EINVAL;
>  	}
>  
> @@ -198,19 +228,27 @@ int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
>  
>  		/* If devices of this class already exist, tell the driver */
>  		if (drv->add) {
> -			struct sys_device *dev;
> -			list_for_each_entry(dev, &cls->kset.list, kobj.entry)
> -				drv->add(dev);
> +			list_for_each_entry(dev, &cls->kset.list, kobj.entry) {
> +				err = drv->add(dev);
> +				if (err)
> +					goto unwind;
> +			}
>  		}
>  	} else {
>  		err = -EINVAL;
>  		WARN(1, KERN_ERR "%s: invalid device class\n", __func__);
>  	}
> +
> +	goto unlock;
> +
> +unwind:
> +	__sysdev_driver_remove(cls, drv, dev);
> +
> +unlock:
>  	mutex_unlock(&sysdev_drivers_lock);
>  	return err;
>  }
>  
> -
>  /**
>   *	sysdev_driver_unregister - Remove an auxillary driver.
>   *	@cls:	Class driver belongs to.
> @@ -220,23 +258,12 @@ void sysdev_driver_unregister(struct sysdev_class *cls,
>  			      struct sysdev_driver *drv)
>  {
>  	mutex_lock(&sysdev_drivers_lock);
> -	list_del_init(&drv->entry);
> -	if (cls) {
> -		if (drv->remove) {
> -			struct sys_device *dev;
> -			list_for_each_entry(dev, &cls->kset.list, kobj.entry)
> -				drv->remove(dev);
> -		}
> -		kset_put(&cls->kset);
> -	}
> +	__sysdev_driver_remove(cls, drv, NULL);
>  	mutex_unlock(&sysdev_drivers_lock);
>  }
> -
>  EXPORT_SYMBOL_GPL(sysdev_driver_register);
>  EXPORT_SYMBOL_GPL(sysdev_driver_unregister);
>  
> -
> -
>  /**
>   *	sysdev_register - add a system device to the tree
>   *	@sysdev:	device in question
> -- 
> 1.7.4.rc2
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
