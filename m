Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab1IAW1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:27:18 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:49917 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab1IAW1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:27:17 -0400
Date: Thu, 1 Sep 2011 18:26:31 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: gregkh@suse.de, martyn.welch@ge.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: vme: make match() driver specific to
 improve non-VME64x support
Message-ID: <20110901222631.GA1835@t61>
References: <1314868526-13230-1-git-send-email-manohar.vanga@cern.ch>
 <1314868526-13230-4-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314868526-13230-4-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches 1 and 2 are hunky dory. This one still needs a bit of work,
but not much really. See below.

All in all this is good stuff, keep it up!

		Emilio

On Thu, Sep 01, 2011 at 11:15:26 +0200, Manohar Vanga wrote:
> For jumper based boards (non VME64x), there is no mechanism
> for detecting the card that is plugged into a specific slot. This
> leads to issues in non-autodiscovery crates/cards when a card is
> plugged into a slot that is "claimed" by a different driver. In
> reality, there is no problem, but the driver rejects such a
> configuration due to its dependence on the concept of slots.
> 
> This patch makes the concept of slots less critical and pushes the
> driver match() to individual drivers (similar to what happens in the
> ISA bus in driver/base/isa.c). This allows drivers to register the
> number of devices that they expect without any restrictions. Devices
> in this new model are now formatted as $driver_name-$bus_id.$device_id
> (as compared to the earlier vme-$bus_id.$slot_number).
> 
> This model also makes the device model more logical as devices
> are only registered when they actually exist whereas earlier,
> a set of devices were being created automatically regardless of
> them actually being there.
> 
> Another change introduced in this patch is that devices are now created
> within the VME driver structure rather than in the VME bridge structure.
> This way, things don't go haywire if the bridge driver is removed while
> a driver is using it.
> 
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
> ---
>  drivers/staging/vme/bridges/vme_ca91cx42.c |    3 +
>  drivers/staging/vme/bridges/vme_tsi148.c   |    3 +
>  drivers/staging/vme/devices/vme_user.c     |   53 +++-----
>  drivers/staging/vme/devices/vme_user.h     |    2 +-
>  drivers/staging/vme/vme.c                  |  206 ++++++++++++++--------------
>  drivers/staging/vme/vme.h                  |   23 +++-
>  drivers/staging/vme/vme_api.txt            |   60 ++++----
>  drivers/staging/vme/vme_bridge.h           |    5 +-
>  8 files changed, 180 insertions(+), 175 deletions(-)
> 
> diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
> index 0e4feac..5b3dcb5 100644
> --- a/drivers/staging/vme/bridges/vme_ca91cx42.c
> +++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
> @@ -1774,6 +1774,9 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	lm->monitors = 4;
>  	list_add_tail(&lm->list, &ca91cx42_bridge->lm_resources);
>  
> +	/* Initialize the list for bridge devices */
> +	INIT_LIST_HEAD(&ca91cx42_bridge->devices);
> +
>  	ca91cx42_bridge->slave_get = ca91cx42_slave_get;
>  	ca91cx42_bridge->slave_set = ca91cx42_slave_set;
>  	ca91cx42_bridge->master_get = ca91cx42_master_get;
> diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
> index 6c1167c..ea13116 100644
> --- a/drivers/staging/vme/bridges/vme_tsi148.c
> +++ b/drivers/staging/vme/bridges/vme_tsi148.c
> @@ -2448,6 +2448,9 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	lm->monitors = 4;
>  	list_add_tail(&lm->list, &tsi148_bridge->lm_resources);
>  
> +	/* Initialize the list for bridge devices */
> +	INIT_LIST_HEAD(&tsi148_bridge->devices);
> +

Probably it makes more sense to handle this in vme.c:vme_add_bus(), since
the particular bridge drivers do not manage at all the device list.

>  	tsi148_bridge->slave_get = tsi148_slave_get;
>  	tsi148_bridge->slave_set = tsi148_slave_set;
>  	tsi148_bridge->master_get = tsi148_master_get;
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

this could be another patch, but duh..

>  /*
>   * VMEbus Master Window Configuration Structure
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index 76e08f3..cc55c35 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
> @@ -1329,8 +1329,16 @@ static int vme_add_bus(struct vme_bridge *bridge)
>  
>  static void vme_remove_bus(struct vme_bridge *bridge)
>  {
> +	struct vme_dev *vdev;
> +	struct vme_dev *tmp;
> +
>  	mutex_lock(&vme_buses_lock);
>  	vme_bus_numbers &= ~(1 << bridge->num);
> +	list_for_each_entry_safe(vdev, tmp, &bridge->devices, bridge_list) {
> +		list_del(&vdev->drv_list);
> +		list_del(&vdev->bridge_list);
> +		device_unregister(&vdev->dev);
> +	}

I like this. All the management of both lists is now correctly done with
vme_buses_lock held--except, perhaps, the initialisation of the bridge list,
but that's ok.

>  	list_del(&bridge->bus_list);
>  	mutex_unlock(&vme_buses_lock);
>  }
> @@ -1342,153 +1350,150 @@ static void vme_dev_release(struct device *dev)
>  
>  int vme_register_bridge(struct vme_bridge *bridge)
>  {
> -	struct vme_dev *vdev;
> -	int retval;
> -	int i;
> +	return vme_add_bus(bridge);
> +}
> +EXPORT_SYMBOL(vme_register_bridge);

Consider sending a subsequent patch cleaning up functions like these.
But don't do it in this patch; this patch, if anything, needs to go
on a diet.

> -	retval = vme_add_bus(bridge);
> -	if (retval)
> -		return retval;
> +void vme_unregister_bridge(struct vme_bridge *bridge)
> +{
> +	vme_remove_bus(bridge);
> +}
> +EXPORT_SYMBOL(vme_unregister_bridge);

ditto

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

I know you're keeping this comment from what's already in the file,
but personally I simply find it distracting.

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

Now the slot field has lots its meaning, and AFAICT its use, see below.

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
> +			list_add_tail(&vdev->drv_list, &drv->devices);
> +			list_add_tail(&vdev->bridge_list, &bridge->devices);

buses_lock is held upon calling the function. Good!

> +		} else
> +			device_unregister(&vdev->dev);
> +	}
> +	return 0;
>  
> -err_reg:
> +err_dev_reg:

Leaving the previous label would be better, it's easier to review.

>  	kfree(vdev);
> -err_devalloc:
> -	while (--i >= 0) {
> -		vdev = bridge->dev[i];
> +err_alloc:

ditto

> +	list_for_each_entry_safe(vdev, tmp, &drv->devices, drv_list) {
> +		list_del(&vdev->drv_list);
> +		list_del(&vdev->bridge_list);
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
>  
> -
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
>  
> -	return driver_register(&drv->driver);
> +	err = __vme_register_driver(drv, ndevs);
> +	if (err)
> +		vme_unregister_driver(drv);

If __vme_register_driver() fails, we can be sure the created devices
(and their corresponding lists) have been cleaned up before the
function returned the failure. So here it seems clearer to call
unregister_driver().

> +
> +	return err;
>  }
>  EXPORT_SYMBOL(vme_register_driver);
>  
>  void vme_unregister_driver(struct vme_driver *drv)
>  {
> +	struct vme_dev *dev, *dev_tmp;
> +
> +	list_for_each_entry_safe(dev, dev_tmp, &drv->devices, drv_list) {
> +		list_del(&dev->drv_list);
> +		list_del(&dev->bridge_list);
> +		device_unregister(&dev->dev);
> +	}

All code operating on both lists is protected by vme_buses_lock, except the
one in this function, which seems dangerous. vme_unregister_driver may race
with vme_unregister_bridge. We need to acquire the lock here too.

>  	driver_unregister(&drv->driver);
>  }
>  EXPORT_SYMBOL(vme_unregister_driver);
>  
>  /* - Bus Registration ------------------------------------------------------ */
>  
> -static struct vme_driver *dev_to_vme_driver(struct device *dev)
> -{
> -	if (dev->driver == NULL)
> -		printk(KERN_ERR "Bugger dev->driver is NULL\n");
> -
> -	return container_of(dev->driver, struct vme_driver, driver);
> -}
> -
>  static int vme_bus_match(struct device *dev, struct device_driver *drv)
>  {
> -	struct vme_dev *vdev;
> -	struct vme_bridge *bridge;
> -	struct vme_driver *driver;
> -	int i, num;
> -
> -	vdev = dev_to_vme_dev(dev);
> -	bridge = vdev->bridge;
> -	driver = container_of(drv, struct vme_driver, driver);
> +	struct vme_driver *vme_drv;
>  
> -	num = vdev->id.slot;
> -	if (num <= 0 || num >= VME_SLOTS_MAX)
> -		goto err_dev;
> -
> -	if (driver->bind_table == NULL) {
> -		dev_err(dev, "Bind table NULL\n");
> -		goto err_table;
> -	}
> +	vme_drv = container_of(drv, struct vme_driver, driver);
>  
> -	i = 0;
> -	while ((driver->bind_table[i].bus != 0) ||
> -		(driver->bind_table[i].slot != 0)) {
> +	if (dev->platform_data == vme_drv) {
> +		struct vme_dev *vdev = dev_to_vme_dev(dev);
>  
> -		if (bridge->num == driver->bind_table[i].bus) {
> -			if (num == driver->bind_table[i].slot)
> -				return 1;
> +		if (vme_drv->match && vme_drv->match(vdev))
> +			return 1;
>  
> -			if (driver->bind_table[i].slot == VME_SLOT_ALL)
> -				return 1;
> -
> -			if ((driver->bind_table[i].slot == VME_SLOT_CURRENT) &&
> -				(num == vme_slot_get(vdev)))
> -				return 1;
> -		}
> -		i++;
> +		dev->platform_data = NULL;
>  	}
> -
> -err_dev:
> -err_table:
>  	return 0;
>  }
>  
>  static int vme_bus_probe(struct device *dev)
>  {
> -	struct vme_driver *driver;
> -	struct vme_dev *vdev;
>  	int retval = -ENODEV;
> +	struct vme_driver *driver;
> +	struct vme_dev *vdev = dev_to_vme_dev(dev);
>  
> -	driver = dev_to_vme_driver(dev);
> -	vdev = dev_to_vme_dev(dev);
> +	driver = dev->platform_data;
>  
>  	if (driver->probe != NULL)
>  		retval = driver->probe(vdev);
> @@ -1498,12 +1503,11 @@ static int vme_bus_probe(struct device *dev)
>  
>  static int vme_bus_remove(struct device *dev)
>  {
> -	struct vme_driver *driver;
> -	struct vme_dev *vdev;
>  	int retval = -ENODEV;
> +	struct vme_driver *driver;
> +	struct vme_dev *vdev = dev_to_vme_dev(dev);
>  
> -	driver = dev_to_vme_driver(dev);
> -	vdev = dev_to_vme_dev(dev);
> +	driver = dev->platform_data;
>  
>  	if (driver->remove != NULL)
>  		retval = driver->remove(vdev);
> diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
> index d442cce..95224d7 100644
> --- a/drivers/staging/vme/vme.h
> +++ b/drivers/staging/vme/vme.h
> @@ -88,15 +88,21 @@ struct vme_resource {
>  
>  extern struct bus_type vme_bus_type;
>  
> +/* VME_MAX_BRIDGES comes from the type of vme_bus_numbers */
> +#define VME_MAX_BRIDGES		(sizeof(unsigned int)*8)
> +#define VME_MAX_SLOTS		32
> +
>  #define VME_SLOT_CURRENT	-1
>  #define VME_SLOT_ALL		-2
>  
>  /**
>   * VME device identifier structure
> + * @num: The device ID (ranges from 0 to N-1 for N devices)
>   * @bus: The bus ID of the bus the device is on
>   * @slot: The slot this device is plugged into
>   */
>  struct vme_device_id {
> +	int num;
>  	int bus;
>  	int slot;

As I mentioned earlier, AFAICT the slot field is meaningless now.
Consider submitting a subsequent patch that removes it.

>  };
> @@ -106,21 +112,26 @@ struct vme_device_id {
>   * @id: The ID of the device (currently the bus and slot number)
>   * @bridge: Pointer to the bridge device this device is on
>   * @dev: Internal device structure
> + * @drv_list: List of devices (per driver)
> + * @bridge_list: List of devices (per bridge)
>   */
>  struct vme_dev {
>  	struct vme_device_id id;
>  	struct vme_bridge *bridge;
>  	struct device dev;
> +	struct list_head drv_list;
> +	struct list_head bridge_list;
>  };
>  
>  struct vme_driver {
>  	struct list_head node;
>  	const char *name;
> -	const struct vme_device_id *bind_table;
> -	int (*probe)  (struct vme_dev *);
> -	int (*remove) (struct vme_dev *);
> -	void (*shutdown) (void);
> -	struct device_driver    driver;
> +	int (*match)(struct vme_dev *);
> +	int (*probe)(struct vme_dev *);
> +	int (*remove)(struct vme_dev *);
> +	void (*shutdown)(void);
> +	struct device_driver driver;
> +	struct list_head devices;
>  };
>  
>  void *vme_alloc_consistent(struct vme_resource *, size_t, dma_addr_t *);
> @@ -179,7 +190,7 @@ void vme_lm_free(struct vme_resource *);
>  
>  int vme_slot_get(struct vme_dev *);

AFAICT this is an exported symbol that after this patch has no callers
and no meaning. Consider submitting a subsequent patch that removes it,
possibly together with the removal of struct vme_device_id.slot.
btw remember to update the documentation, I'm sure I'd forget.

> -int vme_register_driver(struct vme_driver *);
> +int vme_register_driver(struct vme_driver *, unsigned int);
>  void vme_unregister_driver(struct vme_driver *);
>  
>  
> diff --git a/drivers/staging/vme/vme_api.txt b/drivers/staging/vme/vme_api.txt
> index 03f4813..ffe28c3 100644
> --- a/drivers/staging/vme/vme_api.txt
> +++ b/drivers/staging/vme/vme_api.txt
> @@ -18,24 +18,37 @@ registration function. The structure is as follows:
>  
>  	struct vme_driver {
>  		struct list_head node;
> -		char *name;
> -		const struct vme_device_id *bind_table;
> -		int (*probe)  (struct vme_dev *);
> -		int (*remove) (struct vme_dev *);
> -		void (*shutdown) (void);
> -		struct device_driver    driver;
> +		const char *name;
> +		int (*match)(struct vme_dev *);
> +		int (*probe)(struct vme_dev *);
> +		int (*remove)(struct vme_dev *);
> +		void (*shutdown)(void);
> +		struct device_driver driver;
> +		struct list_head devices;
> +		unsigned int ndev;
>  	};
>  
> -At the minimum, the '.name', '.probe' and '.bind_table' elements of this
> -structure should be correctly set. The '.name' element is a pointer to a string
> -holding the device driver's name. The '.probe' element should contain a pointer
> -to the probe routine.
> +At the minimum, the '.name', '.match' and '.probe' elements of this structure
> +should be correctly set. The '.name' element is a pointer to a string holding
> +the device driver's name.
>  
> -The arguments of the probe routine are as follows:
> +The '.match' function allows controlling the number of devices that need to
> +be registered. The match function should return 1 if a device should be
> +probed and 0 otherwise. This example match function (from vme_user.c) limits
> +the number of devices probed to one:
>  
> -	probe(struct vme_dev *dev);
> +	#define VME_USER_BUS_MAX	1
> +	...
> +	static int vme_user_match(struct vme_dev *vdev)
> +	{
> +		if (vdev->id.num >= VME_USER_BUS_MAX)
> +			return 0;
> +		return 1;
> +	}
>  
> -The device structure looks like the following:
> +The '.probe' element should contain a pointer to the probe routine. The
> +probe routine is passed a 'struct vme_dev' pointer as an argument. The
> +'struct vme_dev' structure looks like the following:
>  
>  	struct vme_dev {
>  		struct vme_device_id id;
> @@ -49,25 +62,12 @@ contains information useful for the probe function:
>  	struct vme_device_id {
>  		int bus;
>  		int slot;
> +		int num;
>  	};
>  
> -'bus' is the number of the bus the device being probed is on. 'slot' refers
> -to the specific slot on the VME bus.
> -
> -The '.bind_table' is a pointer to an array of type 'vme_device_id':
> -
> -	struct vme_device_id {
> -		int bus;
> -		int slot;
> -	};
> -
> -Each structure in this array should provide a bus and slot number where the core
> -should probe, using the driver's probe routine, for a device on the specified
> -VME bus.
> -
> -The VME subsystem supports a single VME driver per 'slot'. There are considered
> -to be 32 slots per bus, one for each slot-ID as defined in the ANSI/VITA 1-1994
> -specification and are analogious to the physical slots on the VME backplane.
> +Here, 'bus' is the number of the bus the device being probed is on. 'slot'
> +refers to the specific slot on the VME bus. The 'num' field refers to the
> +sequential device ID for this specific driver.
>  
>  A function is also provided to unregister the driver from the VME core and is
>  usually called from the device driver's exit routine:
> diff --git a/drivers/staging/vme/vme_bridge.h b/drivers/staging/vme/vme_bridge.h
> index 6dd2f4c..c2deda2 100644
> --- a/drivers/staging/vme/vme_bridge.h
> +++ b/drivers/staging/vme/vme_bridge.h
> @@ -2,7 +2,6 @@
>  #define _VME_BRIDGE_H_
>  
>  #define VME_CRCSR_BUF_SIZE (508*1024)
> -#define VME_SLOTS_MAX 32

So this should in fact be part of the "slot cleanup" patch.

>  /*
>   * Resource structures
>   */
> @@ -108,15 +107,13 @@ struct vme_bridge {
>  	struct list_head lm_resources;
>  
>  	struct list_head vme_errors;	/* List for errors generated on VME */
> +	struct list_head devices;	/* List of devices on this bridge */

As you can see the locking of this list and that on each bridge got
a bit complex. This is OK, locks tend to spread, but it's important
to be aware of it. Perhaps adding a comment somewhere (possibly
but not necessarily here) would avoid future bugs/deadlocks.

>  
>  	/* Bridge Info - XXX Move to private structure? */
>  	struct device *parent;	/* Parent device (eg. pdev->dev for PCI) */
>  	void *driver_priv;	/* Private pointer for the bridge driver */
>  	struct list_head bus_list; /* list of VME buses */
>  
> -	struct vme_dev *dev[VME_SLOTS_MAX];	/* Device registered
> -						 * on VME bus */
> -
>  	/* Interrupt callbacks */
>  	struct vme_irq irq[7];
>  	/* Locking for VME irq callback configuration */
> -- 
> 1.7.4.1
> 
