Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab2FEOrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 10:47:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52012 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751701Ab2FEOrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 10:47:04 -0400
Date: Tue, 5 Jun 2012 10:47:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
In-Reply-To: <1338886747-28088-1-git-send-email-ming.lei@canonical.com>
Message-ID: <Pine.LNX.4.44L0.1206051034350.1542-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012, Ming Lei wrote:

> Firstly, .shutdown callback may touch a uninitialized hardware
> if dev->driver is set and .probe is not completed.
> 
> Secondly, device_shutdown() may dereference a null pointer to cause
> oops when dev->driver is cleared after it is checked in device_shutdown().
> 
> This patch uses SRCU and ACCESS_ONCE to avoid the races:
> - don't start .shutdown until .probe in progess is completed
> - avoid running .probe and .remove once shutdown is started

Avoid running probe, that's fine.  But avoiding remove can lead to 
problems, because the subsystem and the driver will no longer agree on 
who should manage the device.

> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -49,6 +49,9 @@ static struct kobject *dev_kobj;
>  struct kobject *sysfs_dev_char_kobj;
>  struct kobject *sysfs_dev_block_kobj;
>  
> +struct srcu_struct driver_srcu;
> +int device_shutdown_started;
> +
>  #ifdef CONFIG_BLOCK
>  static inline int device_is_not_partition(struct device *dev)
>  {
> @@ -1803,6 +1806,9 @@ void device_shutdown(void)
>  {
>  	struct device *dev;
>  
> +	ACCESS_ONCE(device_shutdown_started) = 1;

This does not need to be ACCESS_ONCE.  ACCESS_ONCE is needed only in 
situations where the compiler might insert multiple reads or writes.

> +	synchronize_srcu(&driver_srcu);
> +
>  	spin_lock(&devices_kset->list_lock);
>  	/*
>  	 * Walk the devices list backward, shutting down each in turn.
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 1b1cbb5..5587037 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -250,8 +250,13 @@ static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
>  static int really_probe(struct device *dev, struct device_driver *drv)
>  {
>  	int ret = 0;
> +	int idx;
>  
> +	idx = srcu_read_lock(&driver_srcu);
>  	atomic_inc(&probe_count);
> +	if (ACCESS_ONCE(device_shutdown_started))

This doesn't need to be ACCESS_ONCE either.  If it would make you feel
better, you could write

	if (rcu_dereference(&device_shutdown_started))

> +		goto done;

You need to set ret to something other than 0, because the probe has
not succeeded.  For example, set it to -ESHUTDOWN.

> +
>  	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
>  		 drv->bus->name, __func__, drv->name, dev_name(dev));
>  	WARN_ON(!list_empty(&dev->devres_head));
> @@ -305,6 +310,7 @@ probe_failed:
>  done:
>  	atomic_dec(&probe_count);
>  	wake_up(&probe_waitqueue);
> +	srcu_read_unlock(&driver_srcu, idx);
>  	return ret;
>  }
>  
> @@ -467,6 +473,12 @@ EXPORT_SYMBOL_GPL(driver_attach);
>  static void __device_release_driver(struct device *dev)
>  {
>  	struct device_driver *drv;
> +	int idx;
> +
> +	idx = srcu_read_lock(&driver_srcu);
> +
> +	if (ACCESS_ONCE(device_shutdown_started))
> +		goto exit;

As mentioned above, this is not good.  I don't know... maybe it won't 
ever cause any difficulties.

Alan Stern

