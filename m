Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1HJKSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 06:18:34 -0400
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:59707 "EHLO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab1HJKSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 06:18:33 -0400
Message-ID: <4E425AF4.2050204@ge.com>
Date: Wed, 10 Aug 2011 11:18:28 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] staging: vme: make match() driver specific to improve
 non-VME64x support
References: <1312968830-13377-1-git-send-email-manohar.vanga@cern.ch> <1312968830-13377-7-git-send-email-manohar.vanga@cern.ch>
In-Reply-To: <1312968830-13377-7-git-send-email-manohar.vanga@cern.ch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2011 10:15:11.0939 (UTC) FILETIME=[63BA6930:01CC5746]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/11 10:33, Manohar Vanga wrote:
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
> a driver is using it (this is also additionally prevented by having
> reference counting of used bridge modules).
> 
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>

This is going to impact vme_api.txt. Please can you update that as well please.

Martyn

> ---
>  drivers/staging/vme/devices/vme_user.c |   25 +++-
>  drivers/staging/vme/devices/vme_user.h |    2 +-
>  drivers/staging/vme/vme.c              |  220 ++++++++++++++++----------------
>  drivers/staging/vme/vme.h              |   19 ++-
>  drivers/staging/vme/vme_bridge.h       |    4 -
>  5 files changed, 147 insertions(+), 123 deletions(-)
> 
> diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
> index bb33dc2..41a82a1 100644
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
> @@ -643,10 +645,10 @@ static int __init vme_user_init(void)
>  	/* Let's start by supporting one bus, we can support more than one
>  	 * in future revisions if that ever becomes necessary.
>  	 */
> -	if (bus_num > USER_BUS_MAX) {
> +	if (bus_num > VME_USER_BUS_MAX) {
>  		printk(KERN_ERR "%s: Driver only able to handle %d buses\n",
> -			driver_name, USER_BUS_MAX);
> -		bus_num = USER_BUS_MAX;
> +			driver_name, VME_USER_BUS_MAX);
> +		bus_num = VME_USER_BUS_MAX;
>  	}
>  
>  
> @@ -671,7 +673,13 @@ static int __init vme_user_init(void)
>  
>  	vme_user_driver.bind_table = ids;
>  
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
> @@ -684,6 +692,13 @@ err_nocard:
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
> index 360acc9..99d1505 100644
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
>  
>  /*
>   * Increments the reference count of a VME bridge.
> @@ -1409,150 +1406,160 @@ static void vme_remove_bus(struct vme_bridge *bridge)
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
>  
> -	/* This creates 32 vme "slot" devices. This equates to a slot for each
> -	 * ID available in a system conforming to the ANSI/VITA 1-1994
> -	 * specification.
> -	 */
> -	for (i = 0; i < VME_SLOTS_MAX; i++) {
> -		vdev = &bridge->dev[i];
> -		memset(vdev, 0, sizeof(struct vme_dev));
>  
> +/* - Driver Registration --------------------------------------------------- */
> +
> +static void vme_dev_release(struct device *dev)
> +{
> +	kfree(dev_to_vme_dev(dev));
> +}
> +
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
> -		/*
> -		 * We save a pointer to the bridge in platform_data so that we
> -		 * can get to it later. We keep driver_data for use by the
> -		 * driver that binds against the slot
> -		 */
> -		vdev->dev.platform_data = bridge;
> -		dev_set_name(&vdev->dev, "vme-%x.%x", bridge->num, i + 1);
> -
> -		retval = device_register(&vdev->dev);
> -		if (retval)
> -			goto err_reg;
> +		dev_set_name(&vdev->dev, "%s.%u-%u", drv->name, vdev->id.bus,
> +			vdev->id.num);
> +
> +		err = device_register(&vdev->dev);
> +		if (err)
> +			goto err_dev_reg;
> +
> +		if (vdev->dev.platform_data) {
> +			list_add_tail(&vdev->list, &drv->devices);
> +			drv->ndev++;
> +		} else {
> +			device_unregister(&vdev->dev);
> +			kfree(vdev);
> +		}
>  	}
> +	return 0;
>  
> -	return retval;
> -
> -err_reg:
> -	while (--i >= 0) {
> -		vdev = &bridge->dev[i];
> +err_dev_reg:
> +	kfree(vdev);
> +err_alloc:
> +	list_for_each_entry_safe(vdev, tmp, &drv->devices, list) {
> +		list_del(&vdev->list);
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
> -		vdev = &bridge->dev[i];
> -		device_unregister(&vdev->dev);
> +	mutex_lock(&vme_buses_lock);
> +	list_for_each_entry(bridge, &vme_bus_list, bus_list) {
> +		/*
> +		 * We increase the refcount of the bridge module here to
> +		 * prevent it from being removed during driver registration
> +		 */
> +		if (!vme_bridge_get(bridge->num))
> +			continue;
> +		mutex_unlock(&vme_buses_lock);
> +		err = __vme_register_driver_bus(drv, bridge, ndevs);
> +		mutex_lock(&vme_buses_lock);
> +		vme_bridge_put(bridge);
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
> -
> -	return driver_register(&drv->driver);
> +	INIT_LIST_HEAD(&drv->devices);
> +
> +	err = driver_register(&drv->driver);
> +	if (err)
> +		return err;
> +
> +	err = __vme_register_driver(drv, ndevs);
> +	if (!err & (drv->ndev == 0))
> +		err = -ENODEV;
> +	if (err)
> +		vme_unregister_driver(drv);
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
> +	}
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
> -
> -	num = vdev->id.slot;
> -	if (num <= 0 || num >= VME_SLOTS_MAX)
> -		goto err_dev;
> +	struct vme_driver *vme_drv;
>  
> -	if (driver->bind_table == NULL) {
> -		dev_err(dev, "Bind table NULL\n");
> -		goto err_table;
> -	}
> -
> -	i = 0;
> -	while ((driver->bind_table[i].bus != 0) ||
> -		(driver->bind_table[i].slot != 0)) {
> +	vme_drv = container_of(drv, struct vme_driver, driver);
>  
> -		if (bridge->num == driver->bind_table[i].bus) {
> -			if (num == driver->bind_table[i].slot)
> -				return 1;
> +	if (dev->platform_data == vme_drv) {
> +		struct vme_dev *vdev = dev_to_vme_dev(dev);
>  
> -			if (driver->bind_table[i].slot == VME_SLOT_ALL)
> -				return 1;
> +		if (vme_drv->match && vme_drv->match(vdev))
> +			return 1;
>  
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
> -	struct vme_bridge *bridge;
> +	int retval = 0;
>  	struct vme_driver *driver;
> -	struct vme_dev *vdev;
> -	int retval = -ENODEV;
> -
> -	driver = dev_to_vme_driver(dev);
> -	vdev = dev_to_vme_dev(dev);
> -	bridge = vdev->bridge;
> +	struct vme_dev *vdev = dev_to_vme_dev(dev);
> +	struct vme_bridge *bridge = vdev->bridge;
>  
>  	vme_bridge_get(bridge->num);
> -	if (driver->probe != NULL)
> +
> +	driver = dev->platform_data;
> +	if (driver->probe)
>  		retval = driver->probe(vdev);
>  
>  	if (retval)
> @@ -1563,16 +1570,13 @@ static int vme_bus_probe(struct device *dev)
>  
>  static int vme_bus_remove(struct device *dev)
>  {
> -	struct vme_bridge *bridge;
> +	int retval = 0;
>  	struct vme_driver *driver;
> -	struct vme_dev *vdev;
> -	int retval = -ENODEV;
> -
> -	driver = dev_to_vme_driver(dev);
> -	vdev = dev_to_vme_dev(dev);
> -	bridge = vdev->bridge;
> +	struct vme_dev *vdev = dev_to_vme_dev(dev);
> +	struct vme_bridge *bridge = vdev->bridge;
>  
> -	if (driver->remove != NULL)
> +	driver = dev->platform_data;
> +	if (driver->remove)
>  		retval = driver->remove(vdev);
>  
>  	vme_bridge_put(bridge);
> diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
> index 356b06e..80ade64 100644
> --- a/drivers/staging/vme/vme.h
> +++ b/drivers/staging/vme/vme.h
> @@ -90,15 +90,19 @@ extern struct bus_type vme_bus_type;
>  
>  /* VME_MAX_BRIDGES comes from the type of vme_bus_numbers */
>  #define VME_MAX_BRIDGES		(sizeof(unsigned int)*8)
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
>  };
> @@ -108,21 +112,26 @@ struct vme_device_id {
>   * @id: The ID of the device (currently the bus and slot number)
>   * @bridge: Pointer to the bridge device this device is on
>   * @dev: Internal device structure
> + * @list: List of devices (per driver)
>   */
>  struct vme_dev {
>  	struct vme_device_id id;
>  	struct vme_bridge *bridge;
>  	struct device dev;
> +	struct list_head list;
>  };
>  
>  struct vme_driver {
>  	struct list_head node;
>  	const char *name;
>  	const struct vme_device_id *bind_table;
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
> +	unsigned int ndev;
>  };
>  
>  void *vme_alloc_consistent(struct vme_resource *, size_t, dma_addr_t *);
> @@ -181,7 +190,7 @@ void vme_lm_free(struct vme_resource *);
>  
>  int vme_slot_get(struct vme_dev *);
>  
> -int vme_register_driver(struct vme_driver *);
> +int vme_register_driver(struct vme_driver *, unsigned int);
>  void vme_unregister_driver(struct vme_driver *);
>  
>  struct vme_bridge *vme_bridge_get(unsigned int bus_id);
> diff --git a/drivers/staging/vme/vme_bridge.h b/drivers/staging/vme/vme_bridge.h
> index 74d0103..24cb4b8 100644
> --- a/drivers/staging/vme/vme_bridge.h
> +++ b/drivers/staging/vme/vme_bridge.h
> @@ -2,7 +2,6 @@
>  #define _VME_BRIDGE_H_
>  
>  #define VME_CRCSR_BUF_SIZE (508*1024)
> -#define VME_SLOTS_MAX 32
>  /*
>   * Resource structures
>   */
> @@ -115,9 +114,6 @@ struct vme_bridge {
>  	struct list_head bus_list; /* list of VME buses */
>  	struct module *owner;	/* module that owns the bridge */
>  
> -	struct vme_dev dev[VME_SLOTS_MAX];	/* Device registered
> -						 * on VME bus */
> -
>  	/* Interrupt callbacks */
>  	struct vme_irq irq[7];
>  	/* Locking for VME irq callback configuration */


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
