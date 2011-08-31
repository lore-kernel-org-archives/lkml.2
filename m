Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab1HaVVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:21:11 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:37710 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab1HaVVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:21:08 -0400
Date: Wed, 31 Aug 2011 17:20:47 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: gregkh@suse.de, martyn.welch@ge.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: vme: make match() driver specific to
 improve non-VME64x support
Message-ID: <20110831212047.GB5339@flamenco.cs.columbia.edu>
References: <1314785146-19163-1-git-send-email-manohar.vanga@cern.ch>
 <1314785146-19163-4-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314785146-19163-4-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was hard to review. There are references to functions that
are not committed in Greg's tree yet ("staging" tree @ git.kernel.org).

I assume this patch was applied before you wrote the v4 patchset:

	https://lkml.org/lkml/2011/8/12/107

On Wed, Aug 31, 2011 at 12:05:46 +0200, Manohar Vanga wrote:
(snip)
> Another change introduced in this patch is that devices are now created
> within the VME driver structure rather than in the VME bridge structure.
> This way, things don't go haywire if the bridge driver is removed while
> a driver is using it (this is also additionally prevented by having
> reference counting of used bridge modules).

The mention to refcounting seems outdated. As I stated in my reply
to v0, we should just safely remove devices under the bus when
vme_unregister_bus() is called.

> ---
>  drivers/staging/vme/devices/vme_user.c |   53 +++-----
>  drivers/staging/vme/devices/vme_user.h |    2 +-
>  drivers/staging/vme/vme.c              |  201 +++++++++++++++-----------------
>  drivers/staging/vme/vme.h              |   22 +++-
>  drivers/staging/vme/vme_api.txt        |   60 +++++-----
>  drivers/staging/vme/vme_bridge.h       |    4 -
>  6 files changed, 163 insertions(+), 179 deletions(-)
> 
> diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
> index bb33dc2..f85be2c 100644
> --- a/drivers/staging/vme/devices/vme_user.c
> +++ b/drivers/staging/vme/devices/vme_user.c
> @@ -43,7 +43,7 @@
>  static DEFINE_MUTEX(vme_user_mutex);
>  static const char driver_name[] = "vme_user";
>  
> -static int bus[USER_BUS_MAX];
> +static int bus[VME_USER_BUS_MAX];
>  static unsigned int bus_num;
>  
>  /* Currently Documentation/devices.txt defines the following for VME:
> @@ -135,6 +135,7 @@ static ssize_t vme_user_write(struct file *, const char __user *, size_t,
>  static loff_t vme_user_llseek(struct file *, loff_t, int);
>  static long vme_user_unlocked_ioctl(struct file *, unsigned int, unsigned long);
>  
> +static int vme_user_match(struct vme_dev *);
>  static int __devinit vme_user_probe(struct vme_dev *);
>  static int __devexit vme_user_remove(struct vme_dev *);
>  
> @@ -620,6 +621,7 @@ static void buf_unalloc(int num)
>  
>  static struct vme_driver vme_user_driver = {
>  	.name = driver_name,
> +	.match = vme_user_match,
>  	.probe = vme_user_probe,
>  	.remove = __devexit_p(vme_user_remove),
>  };
> @@ -628,8 +630,6 @@ static struct vme_driver vme_user_driver = {
>  static int __init vme_user_init(void)
>  {
>  	int retval = 0;
> -	int i;
> -	struct vme_device_id *ids;
>  
>  	printk(KERN_INFO "VME User Space Access Driver\n");
>  
> @@ -643,47 +643,36 @@ static int __init vme_user_init(void)
>  	/* Let's start by supporting one bus, we can support more than one
>  	 * in future revisions if that ever becomes necessary.
>  	 */
> -	if (bus_num > USER_BUS_MAX) {
> +	if (bus_num > VME_USER_BUS_MAX) {
>  		printk(KERN_ERR "%s: Driver only able to handle %d buses\n",
> -			driver_name, USER_BUS_MAX);
> -		bus_num = USER_BUS_MAX;
> -	}
> -
> -
> -	/* Dynamically create the bind table based on module parameters */
> -	ids = kzalloc(sizeof(struct vme_device_id) * (bus_num + 1), GFP_KERNEL);
> -	if (ids == NULL) {
> -		printk(KERN_ERR "%s: Unable to allocate ID table\n",
> -			driver_name);
> -		retval = -ENOMEM;
> -		goto err_id;
> -	}
> -
> -	for (i = 0; i < bus_num; i++) {
> -		ids[i].bus = bus[i];
> -		/*
> -		 * We register the driver against the slot occupied by *this*
> -		 * card, since it's really a low level way of controlling
> -		 * the VME bridge
> -		 */
> -		ids[i].slot = VME_SLOT_CURRENT;
> +			driver_name, VME_USER_BUS_MAX);
> +		bus_num = VME_USER_BUS_MAX;
>  	}
>  
> -	vme_user_driver.bind_table = ids;
> -
> -	retval = vme_register_driver(&vme_user_driver);
> +	/*
> +	 * Here we just register the maximum number of devices we can and
> +	 * leave vme_user_match() to allow only 1 to go through to probe().
> +	 * This way, if we later want to allow multiple user access devices,
> +	 * we just change the code in vme_user_match().
> +	 */
> +	retval = vme_register_driver(&vme_user_driver, VME_MAX_SLOTS);
>  	if (retval != 0)
>  		goto err_reg;
>  
>  	return retval;
>  
>  err_reg:
> -	kfree(ids);
> -err_id:
>  err_nocard:
>  	return retval;
>  }
>  
> +static int vme_user_match(struct vme_dev *vdev)
> +{
> +	if (vdev->id.num >= VME_USER_BUS_MAX)
> +		return 0;
> +	return 1;
> +}
> +
>  /*
>   * In this simple access driver, the old behaviour is being preserved as much
>   * as practical. We will therefore reserve the buffers and request the images
> @@ -896,8 +885,6 @@ static int __devexit vme_user_remove(struct vme_dev *dev)
>  static void __exit vme_user_exit(void)
>  {
>  	vme_unregister_driver(&vme_user_driver);
> -
> -	kfree(vme_user_driver.bind_table);
>  }
>  
>  
> diff --git a/drivers/staging/vme/devices/vme_user.h b/drivers/staging/vme/devices/vme_user.h
> index 24bf4e5..d85a1e9 100644
> --- a/drivers/staging/vme/devices/vme_user.h
> +++ b/drivers/staging/vme/devices/vme_user.h
> @@ -1,7 +1,7 @@
>  #ifndef _VME_USER_H_
>  #define _VME_USER_H_
>  
> -#define USER_BUS_MAX                  1
> +#define VME_USER_BUS_MAX	1
>  
>  /*
>   * VMEbus Master Window Configuration Structure
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index 76e08f3..2c3d47d 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
> @@ -42,10 +42,7 @@ static DEFINE_MUTEX(vme_buses_lock);
>  static void __exit vme_exit(void);
>  static int __init vme_init(void);
>  
> -static struct vme_dev *dev_to_vme_dev(struct device *dev)
> -{
> -	return container_of(dev, struct vme_dev, dev);
> -}
> +#define dev_to_vme_dev(dev) container_of(dev, struct vme_dev, dev)

The function was added in patch 2. In general, you should not add code
that then gets removed, unless there's a good reason. In this case just
add either the function or the macro in patch 2, and stick to it.

>  
>  /*
>   * Find the bridge that the resource is associated with.
> @@ -1342,153 +1339,148 @@ static void vme_dev_release(struct device *dev)
>  
>  int vme_register_bridge(struct vme_bridge *bridge)
>  {
> -	struct vme_dev *vdev;
> -	int retval;
> -	int i;
> +	return vme_add_bus(bridge);
> +}
> +EXPORT_SYMBOL(vme_register_bridge);
>  
> -	retval = vme_add_bus(bridge);
> -	if (retval)
> -		return retval;
> +void vme_unregister_bridge(struct vme_bridge *bridge)
> +{
> +	vme_remove_bus(bridge);
> +}
> +EXPORT_SYMBOL(vme_unregister_bridge);

vme_remove_bus is in the separate patch:
   https://lkml.org/lkml/2011/8/12/107

+static void vme_remove_bus(struct vme_bridge *bridge)
+{
+	mutex_lock(&vme_buses_lock);
+	vme_bus_numbers &= ~(1 << bridge->num);
+	list_del(&bridge->bus_list);
+	mutex_unlock(&vme_buses_lock);
+}

It's quite unfortunate that we cannot easily see the old vs the
new vme_unregister_bridge in this patch. I paste here for clarity:

> -void vme_unregister_bridge(struct vme_bridge *bridge)
> {
> -	int i;
> -	struct vme_dev *vdev;
> -
> -
> -	for (i = 0; i < VME_SLOTS_MAX; i++) {
> -		vdev = bridge->dev[i];
> -		device_unregister(&vdev->dev);
> - 	}
> 	vme_remove_bus(bridge);
> }

So we're essentially leaving the devices there, even though the
bridge they're under will be removed. This doesn't seem right.
btw with the removal of the array of vme_dev's from struct vme_bridge,
the bridge cannot know which devices are under it.

We have to bear in mind that the drv->devices list needs to be
updated when devices come and go; possibly a bridge->devices list
could also be kept.

Helpers around device_register and _unregister may simplify the lists'
housekeeping.

>  
> -	/* This creates 32 vme "slot" devices. This equates to a slot for each
> -	 * ID available in a system conforming to the ANSI/VITA 1-1994
> -	 * specification.
> -	 */
> -	for (i = 0; i < VME_SLOTS_MAX; i++) {
> -		bridge->dev[i] = kzalloc(sizeof(struct vme_dev), GFP_KERNEL);
> -		if (!bridge->dev[i]) {
> -			retval = -ENOMEM;
> -			goto err_devalloc;
> -		}
> -		vdev = bridge->dev[i];
> -		memset(vdev, 0, sizeof(struct vme_dev));
> +/* - Driver Registration --------------------------------------------------- */
>  
> +static int __vme_register_driver_bus(struct vme_driver *drv,
> +	struct vme_bridge *bridge, unsigned int ndevs)
> +{
> +	int err;
> +	unsigned int i;
> +	struct vme_dev *vdev;
> +	struct vme_dev *tmp;
> +
> +	for (i = 0; i < ndevs; i++) {
> +		vdev = kzalloc(sizeof(struct vme_dev), GFP_KERNEL);
> +		if (!vdev) {
> +			err = -ENOMEM;
> +			goto err_alloc;
> +		}
> +		vdev->id.num = i;
>  		vdev->id.bus = bridge->num;
>  		vdev->id.slot = i + 1;
>  		vdev->bridge = bridge;
> +		vdev->dev.platform_data = drv;
> +		vdev->dev.release = vme_dev_release;
>  		vdev->dev.parent = bridge->parent;
>  		vdev->dev.bus = &vme_bus_type;
> -		vdev->dev.release = vme_dev_release;
> -		/*
> -		 * We save a pointer to the bridge in platform_data so that we
> -		 * can get to it later. We keep driver_data for use by the
> -		 * driver that binds against the slot
> -		 */
> -		vdev->dev.platform_data = bridge;
> -		dev_set_name(&vdev->dev, "vme-%x.%x", bridge->num, i + 1);
> +		dev_set_name(&vdev->dev, "%s.%u-%u", drv->name, vdev->id.bus,
> +			vdev->id.num);
>  
> -		retval = device_register(&vdev->dev);
> -		if (retval)
> -			goto err_reg;
> -	}
> +		err = device_register(&vdev->dev);
> +		if (err)
> +			goto err_dev_reg;
>  
> -	return retval;
> +		if (vdev->dev.platform_data) {
> +			list_add_tail(&vdev->list, &drv->devices);
> +			drv->ndev++;

Ok, so drv->ndev can only increase. In case a device is removed (when
a bus driver is removed) this may need to be decreased, which isn't
done in the corresponding list_del() calls (I've marked them).

In fact I wonder whether it is useful at all to have drv->ndev. What's
its purpose?

> +		} else
> +			device_unregister(&vdev->dev);
> +	}
> +	return 0;
>  
> -err_reg:
> +err_dev_reg:
>  	kfree(vdev);
> -err_devalloc:
> -	while (--i >= 0) {
> -		vdev = bridge->dev[i];
> +err_alloc:
> +	list_for_each_entry_safe(vdev, tmp, &drv->devices, list) {
> +		list_del(&vdev->list);

missing drv->ndev-- ?

>  		device_unregister(&vdev->dev);
>  	}
> -	vme_remove_bus(bridge);
> -	return retval;
> +	return err;
>  }
> -EXPORT_SYMBOL(vme_register_bridge);
>  
> -void vme_unregister_bridge(struct vme_bridge *bridge)
> +static int __vme_register_driver(struct vme_driver *drv, unsigned int ndevs)
>  {
> -	int i;
> -	struct vme_dev *vdev;
> -
> +	struct vme_bridge *bridge;
> +	int err = 0;
>  
> -	for (i = 0; i < VME_SLOTS_MAX; i++) {
> -		vdev = bridge->dev[i];
> -		device_unregister(&vdev->dev);
> +	mutex_lock(&vme_buses_lock);
> +	list_for_each_entry(bridge, &vme_bus_list, bus_list) {
> +		/*
> +		 * This cannot cause trouble as we already have vme_buses_lock
> +		 * and if the bridge is removed, it will have to go through
> +		 * vme_unregister_bridge() to do it (which calls remove() on
> +		 * the bridge which in turn tries to acquire vme_buses_lock and
> +		 * will have to wait). The probe() called after device
> +		 * registration in __vme_register_driver below will also fail
> +		 * as the bridge is being removed (since the probe() calls
> +		 * vme_bridge_get()).
> +		 */
> +		err = __vme_register_driver_bus(drv, bridge, ndevs);
> +		if (err)
> +			break;
>  	}
> -	vme_remove_bus(bridge);
> +	mutex_unlock(&vme_buses_lock);
> +	return err;
>  }
> -EXPORT_SYMBOL(vme_unregister_bridge);
> -
>  
> -/* - Driver Registration --------------------------------------------------- */
> -
> -int vme_register_driver(struct vme_driver *drv)
> +int vme_register_driver(struct vme_driver *drv, unsigned int ndevs)
>  {
> +	int err;
> +
>  	drv->driver.name = drv->name;
>  	drv->driver.bus = &vme_bus_type;
> +	INIT_LIST_HEAD(&drv->devices);
> +
> +	err = driver_register(&drv->driver);
> +	if (err)
> +		return err;
> +
> +	err = __vme_register_driver(drv, ndevs);
> +	if (err)
> +		vme_unregister_driver(drv);
>  
> -	return driver_register(&drv->driver);
> +	return err;
>  }
>  EXPORT_SYMBOL(vme_register_driver);
>  
>  void vme_unregister_driver(struct vme_driver *drv)
>  {
> +	struct vme_dev *dev, *dev_tmp;
> +
> +	list_for_each_entry_safe(dev, dev_tmp, &drv->devices, list) {
> +		device_unregister(&dev->dev);
> +		list_del(&dev->list);

missing drv->ndev-- ?

		Emilio

