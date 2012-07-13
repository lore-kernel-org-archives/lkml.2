Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab2GMP7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:59:14 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:45250 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab2GMP7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:59:12 -0400
Message-ID: <1342194878.19100.31.camel@misato.fc.hp.com>
Subject: Re: [PATCH v4 3/3] acpi : acpi_bus_trim() stops removing devices
 when failing to remove the device
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: srivatsa.bhat@linux.vnet.ibm.com, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 13 Jul 2012 09:54:38 -0600
In-Reply-To: <4FFFE1EC.6040003@jp.fujitsu.com>
References: <4FFFE0DA.3050806@jp.fujitsu.com>
	 <4FFFE1EC.6040003@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-13 at 17:53 +0900, Yasuaki Ishimatsu wrote:
> acpi_bus_trim() stops removing devices, when acpi_bus_remove() return error
> number. But acpi_bus_remove() cannot return error number correctly.
> acpi_bus_remove() only return -EINVAL, when dev argument is NULL. Thus even if
> device cannot be removed correctly, acpi_bus_trim() ignores and continues to
> remove devices. acpi_bus_hot_remove_device() uses acpi_bus_trim() for removing
> devices. Therefore acpi_bus_hot_remove_device() can send "_EJ0" to firmware,
> even if the device is running on the system. In this case, the system cannot
> work well. So acpi_bus_trim() should check whether device was removed or not
> correctly. The patch adds error check into some functions to remove the device.
> 
> device_release_driver() can return error value by the patch. But the change
> does not impact other caller function excluding acpi_bus_trim(), since all
> of them does not check return value of device_releae_driver().

I think potential risk here is that __device_release_driver() now
performs rollback in case of error from driver's remove interface.  I
agree with doing the rollback, but this leads to a different situation
if the caller does not check error from device_release_driver() and
proceeds the operation.  So, we will need to make sure that:
 - Other driver's remove interfaces do not fail (or very unlikely to
fail), or
 - If other driver's remove interfaces failed, their end results are no
worse than today.

Thanks,
-Toshi


> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> ---
>  drivers/acpi/scan.c    |   15 ++++++++++++---
>  drivers/base/dd.c      |   22 +++++++++++++++++-----
>  include/linux/device.h |    2 +-
>  3 files changed, 30 insertions(+), 9 deletions(-)
> 
> Index: linux-3.5-rc6/drivers/acpi/scan.c
> ===================================================================
> --- linux-3.5-rc6.orig/drivers/acpi/scan.c	2012-07-13 15:10:46.136790418 +0900
> +++ linux-3.5-rc6/drivers/acpi/scan.c	2012-07-13 15:12:41.364349387 +0900
> @@ -425,12 +425,17 @@ static int acpi_device_remove(struct dev
>  {
>  	struct acpi_device *acpi_dev = to_acpi_device(dev);
>  	struct acpi_driver *acpi_drv = acpi_dev->driver;
> +	int ret;
> 
>  	if (acpi_drv) {
>  		if (acpi_drv->ops.notify)
>  			acpi_device_remove_notify_handler(acpi_dev);
> -		if (acpi_drv->ops.remove)
> -			acpi_drv->ops.remove(acpi_dev, acpi_dev->removal_type);
> +		if (acpi_drv->ops.remove) {
> +			ret = acpi_drv->ops.remove(acpi_dev,
> +						   acpi_dev->removal_type);
> +			if (ret)
> +				return ret;
> +		}
>  	}
>  	acpi_dev->driver = NULL;
>  	acpi_dev->driver_data = NULL;
> @@ -1208,11 +1213,15 @@ static int acpi_device_set_context(struc
> 
>  static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
>  {
> +	int ret;
> +
>  	if (!dev)
>  		return -EINVAL;
> 
>  	dev->removal_type = ACPI_BUS_REMOVAL_EJECT;
> -	device_release_driver(&dev->dev);
> +	ret = device_release_driver(&dev->dev);
> +	if (ret)
> +		return ret;
> 
>  	if (!rmdevice)
>  		return 0;
> Index: linux-3.5-rc6/drivers/base/dd.c
> ===================================================================
> --- linux-3.5-rc6.orig/drivers/base/dd.c	2012-07-13 15:10:46.136790418 +0900
> +++ linux-3.5-rc6/drivers/base/dd.c	2012-07-13 15:14:13.895193383 +0900
> @@ -464,9 +464,10 @@ EXPORT_SYMBOL_GPL(driver_attach);
>   * __device_release_driver() must be called with @dev lock held.
>   * When called for a USB interface, @dev->parent lock must be held as well.
>   */
> -static void __device_release_driver(struct device *dev)
> +static int __device_release_driver(struct device *dev)
>  {
>  	struct device_driver *drv;
> +	int ret = 0;
> 
>  	drv = dev->driver;
>  	if (drv) {
> @@ -482,9 +483,11 @@ static void __device_release_driver(stru
>  		pm_runtime_put_sync(dev);
> 
>  		if (dev->bus && dev->bus->remove)
> -			dev->bus->remove(dev);
> +			ret = dev->bus->remove(dev);
>  		else if (drv->remove)
> -			drv->remove(dev);
> +			ret = drv->remove(dev);
> +		if (ret)
> +			goto rollback;
>  		devres_release_all(dev);
>  		dev->driver = NULL;
>  		klist_remove(&dev->p->knode_driver);
> @@ -494,6 +497,12 @@ static void __device_release_driver(stru
>  						     dev);
> 
>  	}
> +
> +	return ret;
> +
> +rollback:
> +	driver_sysfs_add(dev);
> +	return ret;
>  }
> 
>  /**
> @@ -503,16 +512,19 @@ static void __device_release_driver(stru
>   * Manually detach device from driver.
>   * When called for a USB interface, @dev->parent lock must be held.
>   */
> -void device_release_driver(struct device *dev)
> +int device_release_driver(struct device *dev)
>  {
> +	int ret;
>  	/*
>  	 * If anyone calls device_release_driver() recursively from
>  	 * within their ->remove callback for the same device, they
>  	 * will deadlock right here.
>  	 */
>  	device_lock(dev);
> -	__device_release_driver(dev);
> +	ret = __device_release_driver(dev);
>  	device_unlock(dev);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(device_release_driver);
> 
> Index: linux-3.5-rc6/include/linux/device.h
> ===================================================================
> --- linux-3.5-rc6.orig/include/linux/device.h	2012-07-13 15:10:46.137790406 +0900
> +++ linux-3.5-rc6/include/linux/device.h	2012-07-13 15:12:41.371349562 +0900
> @@ -827,7 +827,7 @@ static inline void *dev_get_platdata(con
>   * for information on use.
>   */
>  extern int __must_check device_bind_driver(struct device *dev);
> -extern void device_release_driver(struct device *dev);
> +extern int device_release_driver(struct device *dev);
>  extern int  __must_check device_attach(struct device *dev);
>  extern int __must_check driver_attach(struct device_driver *drv);
>  extern int __must_check device_reprobe(struct device *dev);
> 


