Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab1HJKOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 06:14:35 -0400
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:42664 "EHLO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab1HJKOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 06:14:34 -0400
Message-ID: <4E425A06.7020208@ge.com>
Date: Wed, 10 Aug 2011 11:14:30 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] staging: vme: add struct vme_dev for VME devices
References: <1312968830-13377-1-git-send-email-manohar.vanga@cern.ch> <1312968830-13377-6-git-send-email-manohar.vanga@cern.ch>
In-Reply-To: <1312968830-13377-6-git-send-email-manohar.vanga@cern.ch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2011 10:11:14.0155 (UTC) FILETIME=[D5FF73B0:01CC5745]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/11 10:33, Manohar Vanga wrote:
> Instead of using a vanilla 'struct device' for VME devices, add new
> 'struct vme_dev'. Modifications have been made to the VME framework
> API as well as all in-tree VME drivers.
> 
> The new vme_dev structure has the following advantages from the
> current model used by the driver:
> 
>     * Driver functions (probe, remove) now receive a VME device
>       instead of a pointer to the bridge device (cleaner design)
>     * It's easier to differenciate API calls as bridge-based or
>       device-based (ie. cleaner interface).
> 
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>

This is going to impact vme_api.txt. Please can you update that as well please.

Martyn

> ---
>  drivers/staging/vme/devices/vme_user.c |   14 ++--
>  drivers/staging/vme/vme.c              |  120 +++++++++++++------------------
>  drivers/staging/vme/vme.h              |   37 +++++++---
>  drivers/staging/vme/vme_bridge.h       |    5 +-
>  4 files changed, 85 insertions(+), 91 deletions(-)
> 
> diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
> index 3cbeb2a..bb33dc2 100644
> --- a/drivers/staging/vme/devices/vme_user.c
> +++ b/drivers/staging/vme/devices/vme_user.c
> @@ -116,7 +116,7 @@ static struct driver_stats statistics;
>  
>  static struct cdev *vme_user_cdev;		/* Character device */
>  static struct class *vme_user_sysfs_class;	/* Sysfs class */
> -static struct device *vme_user_bridge;		/* Pointer to bridge device */
> +static struct vme_dev *vme_user_bridge;		/* Pointer to user device */
>  
>  
>  static const int type[VME_DEVS] = {	MASTER_MINOR,	MASTER_MINOR,
> @@ -135,8 +135,8 @@ static ssize_t vme_user_write(struct file *, const char __user *, size_t,
>  static loff_t vme_user_llseek(struct file *, loff_t, int);
>  static long vme_user_unlocked_ioctl(struct file *, unsigned int, unsigned long);
>  
> -static int __devinit vme_user_probe(struct device *, int, int);
> -static int __devexit vme_user_remove(struct device *, int, int);
> +static int __devinit vme_user_probe(struct vme_dev *);
> +static int __devexit vme_user_remove(struct vme_dev *);
>  
>  static const struct file_operations vme_user_fops = {
>  	.open = vme_user_open,
> @@ -689,8 +689,7 @@ err_nocard:
>   * as practical. We will therefore reserve the buffers and request the images
>   * here so that we don't have to do it later.
>   */
> -static int __devinit vme_user_probe(struct device *dev, int cur_bus,
> -	int cur_slot)
> +static int __devinit vme_user_probe(struct vme_dev *vdev)
>  {
>  	int i, err;
>  	char name[12];
> @@ -702,7 +701,7 @@ static int __devinit vme_user_probe(struct device *dev, int cur_bus,
>  		err = -EINVAL;
>  		goto err_dev;
>  	}
> -	vme_user_bridge = dev;
> +	vme_user_bridge = vdev;
>  
>  	/* Initialise descriptors */
>  	for (i = 0; i < VME_DEVS; i++) {
> @@ -865,8 +864,7 @@ err_dev:
>  	return err;
>  }
>  
> -static int __devexit vme_user_remove(struct device *dev, int cur_bus,
> -	int cur_slot)
> +static int __devexit vme_user_remove(struct vme_dev *dev)
>  {
>  	int i;
>  
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index 0504007..360acc9 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
> @@ -42,13 +42,9 @@ static DEFINE_MUTEX(vme_buses_lock);
>  static void __exit vme_exit(void);
>  static int __init vme_init(void);
>  
> -
> -/*
> - * Find the bridge resource associated with a specific device resource
> - */
> -static struct vme_bridge *dev_to_bridge(struct device *dev)
> +static struct vme_dev *dev_to_vme_dev(struct device *dev)
>  {
> -	return dev->platform_data;
> +	return container_of(dev, struct vme_dev, dev);
>  }
>  
>  /*
> @@ -284,7 +280,7 @@ static int vme_check_window(vme_address_t aspace, unsigned long long vme_base,
>   * Request a slave image with specific attributes, return some unique
>   * identifier.
>   */
> -struct vme_resource *vme_slave_request(struct device *dev,
> +struct vme_resource *vme_slave_request(struct vme_dev *vdev,
>  	vme_address_t address, vme_cycle_t cycle)
>  {
>  	struct vme_bridge *bridge;
> @@ -293,7 +289,7 @@ struct vme_resource *vme_slave_request(struct device *dev,
>  	struct vme_slave_resource *slave_image = NULL;
>  	struct vme_resource *resource = NULL;
>  
> -	bridge = dev_to_bridge(dev);
> +	bridge = vdev->bridge;
>  	if (bridge == NULL) {
>  		printk(KERN_ERR "Can't find VME bus\n");
>  		goto err_bus;
> @@ -440,7 +436,7 @@ EXPORT_SYMBOL(vme_slave_free);
>   * Request a master image with specific attributes, return some unique
>   * identifier.
>   */
> -struct vme_resource *vme_master_request(struct device *dev,
> +struct vme_resource *vme_master_request(struct vme_dev *vdev,
>  	vme_address_t address, vme_cycle_t cycle, vme_width_t dwidth)
>  {
>  	struct vme_bridge *bridge;
> @@ -449,7 +445,7 @@ struct vme_resource *vme_master_request(struct device *dev,
>  	struct vme_master_resource *master_image = NULL;
>  	struct vme_resource *resource = NULL;
>  
> -	bridge = dev_to_bridge(dev);
> +	bridge = vdev->bridge;
>  	if (bridge == NULL) {
>  		printk(KERN_ERR "Can't find VME bus\n");
>  		goto err_bus;
> @@ -698,7 +694,8 @@ EXPORT_SYMBOL(vme_master_free);
>   * Request a DMA controller with specific attributes, return some unique
>   * identifier.
>   */
> -struct vme_resource *vme_dma_request(struct device *dev, vme_dma_route_t route)
> +struct vme_resource *vme_dma_request(struct vme_dev *vdev,
> +	vme_dma_route_t route)
>  {
>  	struct vme_bridge *bridge;
>  	struct list_head *dma_pos = NULL;
> @@ -709,7 +706,7 @@ struct vme_resource *vme_dma_request(struct device *dev, vme_dma_route_t route)
>  	/* XXX Not checking resource attributes */
>  	printk(KERN_ERR "No VME resource Attribute tests done\n");
>  
> -	bridge = dev_to_bridge(dev);
> +	bridge = vdev->bridge;
>  	if (bridge == NULL) {
>  		printk(KERN_ERR "Can't find VME bus\n");
>  		goto err_bus;
> @@ -1042,13 +1039,13 @@ void vme_irq_handler(struct vme_bridge *bridge, int level, int statid)
>  }
>  EXPORT_SYMBOL(vme_irq_handler);
>  
> -int vme_irq_request(struct device *dev, int level, int statid,
> +int vme_irq_request(struct vme_dev *vdev, int level, int statid,
>  	void (*callback)(int, int, void *),
>  	void *priv_data)
>  {
>  	struct vme_bridge *bridge;
>  
> -	bridge = dev_to_bridge(dev);
> +	bridge = vdev->bridge;
>  	if (bridge == NULL) {
>  		printk(KERN_ERR "Can't find VME bus\n");
>  		return -EINVAL;
> @@ -1085,11 +1082,11 @@ int vme_irq_request(struct device *dev, int level, int statid,
>  }
>  EXPORT_SYMBOL(vme_irq_request);
>  
> -void vme_irq_free(struct device *dev, int level, int statid)
> +void vme_irq_free(struct vme_dev *vdev, int level, int statid)
>  {
>  	struct vme_bridge *bridge;
>  
> -	bridge = dev_to_bridge(dev);
> +	bridge = vdev->bridge;
>  	if (bridge == NULL) {
>  		printk(KERN_ERR "Can't find VME bus\n");
>  		return;
> @@ -1120,11 +1117,11 @@ void vme_irq_free(struct device *dev, int level, int statid)
>  }
>  EXPORT_SYMBOL(vme_irq_free);
>  
> -int vme_irq_generate(struct device *dev, int level, int statid)
> +int vme_irq_generate(struct vme_dev *vdev, int level, int statid)
>  {
>  	struct vme_bridge *bridge;
>  
> -	bridge = dev_to_bridge(dev);
> +	bridge = vdev->bridge;
>  	if (bridge == NULL) {
>  		printk(KERN_ERR "Can't find VME bus\n");
>  		return -EINVAL;
> @@ -1147,7 +1144,7 @@ EXPORT_SYMBOL(vme_irq_generate);
>  /*
>   * Request the location monitor, return resource or NULL
>   */
> -struct vme_resource *vme_lm_request(struct device *dev)
> +struct vme_resource *vme_lm_request(struct vme_dev *vdev)
>  {
>  	struct vme_bridge *bridge;
>  	struct list_head *lm_pos = NULL;
> @@ -1155,7 +1152,7 @@ struct vme_resource *vme_lm_request(struct device *dev)
>  	struct vme_lm_resource *lm = NULL;
>  	struct vme_resource *resource = NULL;
>  
> -	bridge = dev_to_bridge(dev);
> +	bridge = vdev->bridge;
>  	if (bridge == NULL) {
>  		printk(KERN_ERR "Can't find VME bus\n");
>  		goto err_bus;
> @@ -1336,11 +1333,11 @@ void vme_lm_free(struct vme_resource *resource)
>  }
>  EXPORT_SYMBOL(vme_lm_free);
>  
> -int vme_slot_get(struct device *bus)
> +int vme_slot_get(struct vme_dev *vdev)
>  {
>  	struct vme_bridge *bridge;
>  
> -	bridge = dev_to_bridge(bus);
> +	bridge = vdev->bridge;
>  	if (bridge == NULL) {
>  		printk(KERN_ERR "Can't find VME bus\n");
>  		return -EINVAL;
> @@ -1412,7 +1409,7 @@ static void vme_remove_bus(struct vme_bridge *bridge)
>  
>  int vme_register_bridge(struct vme_bridge *bridge)
>  {
> -	struct device *dev;
> +	struct vme_dev *vdev;
>  	int retval;
>  	int i;
>  
> @@ -1425,20 +1422,23 @@ int vme_register_bridge(struct vme_bridge *bridge)
>  	 * specification.
>  	 */
>  	for (i = 0; i < VME_SLOTS_MAX; i++) {
> -		dev = &bridge->dev[i];
> -		memset(dev, 0, sizeof(struct device));
> -
> -		dev->parent = bridge->parent;
> -		dev->bus = &vme_bus_type;
> +		vdev = &bridge->dev[i];
> +		memset(vdev, 0, sizeof(struct vme_dev));
> +
> +		vdev->id.bus = bridge->num;
> +		vdev->id.slot = i + 1;
> +		vdev->bridge = bridge;
> +		vdev->dev.parent = bridge->parent;
> +		vdev->dev.bus = &vme_bus_type;
>  		/*
>  		 * We save a pointer to the bridge in platform_data so that we
>  		 * can get to it later. We keep driver_data for use by the
>  		 * driver that binds against the slot
>  		 */
> -		dev->platform_data = bridge;
> -		dev_set_name(dev, "vme-%x.%x", bridge->num, i + 1);
> +		vdev->dev.platform_data = bridge;
> +		dev_set_name(&vdev->dev, "vme-%x.%x", bridge->num, i + 1);
>  
> -		retval = device_register(dev);
> +		retval = device_register(&vdev->dev);
>  		if (retval)
>  			goto err_reg;
>  	}
> @@ -1447,8 +1447,8 @@ int vme_register_bridge(struct vme_bridge *bridge)
>  
>  err_reg:
>  	while (--i >= 0) {
> -		dev = &bridge->dev[i];
> -		device_unregister(dev);
> +		vdev = &bridge->dev[i];
> +		device_unregister(&vdev->dev);
>  	}
>  	vme_remove_bus(bridge);
>  	return retval;
> @@ -1458,12 +1458,12 @@ EXPORT_SYMBOL(vme_register_bridge);
>  void vme_unregister_bridge(struct vme_bridge *bridge)
>  {
>  	int i;
> -	struct device *dev;
> +	struct vme_dev *vdev;
>  
>  
>  	for (i = 0; i < VME_SLOTS_MAX; i++) {
> -		dev = &bridge->dev[i];
> -		device_unregister(dev);
> +		vdev = &bridge->dev[i];
> +		device_unregister(&vdev->dev);
>  	}
>  	vme_remove_bus(bridge);
>  }
> @@ -1489,32 +1489,6 @@ EXPORT_SYMBOL(vme_unregister_driver);
>  
>  /* - Bus Registration ------------------------------------------------------ */
>  
> -static int vme_calc_slot(struct device *dev)
> -{
> -	struct vme_bridge *bridge;
> -	int num;
> -
> -	bridge = dev_to_bridge(dev);
> -
> -	/* Determine slot number */
> -	num = 0;
> -	while (num < VME_SLOTS_MAX) {
> -		if (&bridge->dev[num] == dev)
> -			break;
> -
> -		num++;
> -	}
> -	if (num == VME_SLOTS_MAX) {
> -		dev_err(dev, "Failed to identify slot\n");
> -		num = 0;
> -		goto err_dev;
> -	}
> -	num++;
> -
> -err_dev:
> -	return num;
> -}
> -
>  static struct vme_driver *dev_to_vme_driver(struct device *dev)
>  {
>  	if (dev->driver == NULL)
> @@ -1525,15 +1499,17 @@ static struct vme_driver *dev_to_vme_driver(struct device *dev)
>  
>  static int vme_bus_match(struct device *dev, struct device_driver *drv)
>  {
> +	struct vme_dev *vdev;
>  	struct vme_bridge *bridge;
>  	struct vme_driver *driver;
>  	int i, num;
>  
> -	bridge = dev_to_bridge(dev);
> +	vdev = dev_to_vme_dev(dev);
> +	bridge = vdev->bridge;
>  	driver = container_of(drv, struct vme_driver, driver);
>  
> -	num = vme_calc_slot(dev);
> -	if (!num)
> +	num = vdev->id.slot;
> +	if (num <= 0 || num >= VME_SLOTS_MAX)
>  		goto err_dev;
>  
>  	if (driver->bind_table == NULL) {
> @@ -1553,7 +1529,7 @@ static int vme_bus_match(struct device *dev, struct device_driver *drv)
>  				return 1;
>  
>  			if ((driver->bind_table[i].slot == VME_SLOT_CURRENT) &&
> -				(num == vme_slot_get(dev)))
> +				(num == vme_slot_get(vdev)))
>  				return 1;
>  		}
>  		i++;
> @@ -1568,14 +1544,16 @@ static int vme_bus_probe(struct device *dev)
>  {
>  	struct vme_bridge *bridge;
>  	struct vme_driver *driver;
> +	struct vme_dev *vdev;
>  	int retval = -ENODEV;
>  
>  	driver = dev_to_vme_driver(dev);
> -	bridge = dev_to_bridge(dev);
> +	vdev = dev_to_vme_dev(dev);
> +	bridge = vdev->bridge;
>  
>  	vme_bridge_get(bridge->num);
>  	if (driver->probe != NULL)
> -		retval = driver->probe(dev, bridge->num, vme_calc_slot(dev));
> +		retval = driver->probe(vdev);
>  
>  	if (retval)
>  		vme_bridge_put(bridge);
> @@ -1587,13 +1565,15 @@ static int vme_bus_remove(struct device *dev)
>  {
>  	struct vme_bridge *bridge;
>  	struct vme_driver *driver;
> +	struct vme_dev *vdev;
>  	int retval = -ENODEV;
>  
>  	driver = dev_to_vme_driver(dev);
> -	bridge = dev_to_bridge(dev);
> +	vdev = dev_to_vme_dev(dev);
> +	bridge = vdev->bridge;
>  
>  	if (driver->remove != NULL)
> -		retval = driver->remove(dev, bridge->num, vme_calc_slot(dev));
> +		retval = driver->remove(vdev);
>  
>  	vme_bridge_put(bridge);
>  
> diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
> index 8fb35e2..356b06e 100644
> --- a/drivers/staging/vme/vme.h
> +++ b/drivers/staging/vme/vme.h
> @@ -93,17 +93,34 @@ extern struct bus_type vme_bus_type;
>  #define VME_SLOT_CURRENT	-1
>  #define VME_SLOT_ALL		-2
>  
> +/**
> + * VME device identifier structure
> + * @bus: The bus ID of the bus the device is on
> + * @slot: The slot this device is plugged into
> + */
>  struct vme_device_id {
>  	int bus;
>  	int slot;
>  };
>  
> +/**
> + * Structure representing a VME device
> + * @id: The ID of the device (currently the bus and slot number)
> + * @bridge: Pointer to the bridge device this device is on
> + * @dev: Internal device structure
> + */
> +struct vme_dev {
> +	struct vme_device_id id;
> +	struct vme_bridge *bridge;
> +	struct device dev;
> +};
> +
>  struct vme_driver {
>  	struct list_head node;
>  	const char *name;
>  	const struct vme_device_id *bind_table;
> -	int (*probe)  (struct device *, int, int);
> -	int (*remove) (struct device *, int, int);
> +	int (*probe)  (struct vme_dev *);
> +	int (*remove) (struct vme_dev *);
>  	void (*shutdown) (void);
>  	struct device_driver    driver;
>  };
> @@ -114,7 +131,7 @@ void vme_free_consistent(struct vme_resource *, size_t,  void *,
>  
>  size_t vme_get_size(struct vme_resource *);
>  
> -struct vme_resource *vme_slave_request(struct device *, vme_address_t,
> +struct vme_resource *vme_slave_request(struct vme_dev *, vme_address_t,
>  	vme_cycle_t);
>  int vme_slave_set(struct vme_resource *, int, unsigned long long,
>  	unsigned long long, dma_addr_t, vme_address_t, vme_cycle_t);
> @@ -122,7 +139,7 @@ int vme_slave_get(struct vme_resource *, int *, unsigned long long *,
>  	unsigned long long *, dma_addr_t *, vme_address_t *, vme_cycle_t *);
>  void vme_slave_free(struct vme_resource *);
>  
> -struct vme_resource *vme_master_request(struct device *, vme_address_t,
> +struct vme_resource *vme_master_request(struct vme_dev *, vme_address_t,
>  	vme_cycle_t, vme_width_t);
>  int vme_master_set(struct vme_resource *, int, unsigned long long,
>  	unsigned long long, vme_address_t, vme_cycle_t, vme_width_t);
> @@ -134,7 +151,7 @@ unsigned int vme_master_rmw(struct vme_resource *, unsigned int, unsigned int,
>  	unsigned int, loff_t);
>  void vme_master_free(struct vme_resource *);
>  
> -struct vme_resource *vme_dma_request(struct device *, vme_dma_route_t);
> +struct vme_resource *vme_dma_request(struct vme_dev *, vme_dma_route_t);
>  struct vme_dma_list *vme_new_dma_list(struct vme_resource *);
>  struct vme_dma_attr *vme_dma_pattern_attribute(u32, vme_pattern_t);
>  struct vme_dma_attr *vme_dma_pci_attribute(dma_addr_t);
> @@ -147,12 +164,12 @@ int vme_dma_list_exec(struct vme_dma_list *);
>  int vme_dma_list_free(struct vme_dma_list *);
>  int vme_dma_free(struct vme_resource *);
>  
> -int vme_irq_request(struct device *, int, int,
> +int vme_irq_request(struct vme_dev *, int, int,
>  	void (*callback)(int, int, void *), void *);
> -void vme_irq_free(struct device *, int, int);
> -int vme_irq_generate(struct device *, int, int);
> +void vme_irq_free(struct vme_dev *, int, int);
> +int vme_irq_generate(struct vme_dev *, int, int);
>  
> -struct vme_resource * vme_lm_request(struct device *);
> +struct vme_resource * vme_lm_request(struct vme_dev *);
>  int vme_lm_count(struct vme_resource *);
>  int vme_lm_set(struct vme_resource *, unsigned long long, vme_address_t,
>  	vme_cycle_t);
> @@ -162,7 +179,7 @@ int vme_lm_attach(struct vme_resource *, int, void (*callback)(int));
>  int vme_lm_detach(struct vme_resource *, int);
>  void vme_lm_free(struct vme_resource *);
>  
> -int vme_slot_get(struct device *);
> +int vme_slot_get(struct vme_dev *);
>  
>  int vme_register_driver(struct vme_driver *);
>  void vme_unregister_driver(struct vme_driver *);
> diff --git a/drivers/staging/vme/vme_bridge.h b/drivers/staging/vme/vme_bridge.h
> index ef751a4..74d0103 100644
> --- a/drivers/staging/vme/vme_bridge.h
> +++ b/drivers/staging/vme/vme_bridge.h
> @@ -115,9 +115,8 @@ struct vme_bridge {
>  	struct list_head bus_list; /* list of VME buses */
>  	struct module *owner;	/* module that owns the bridge */
>  
> -	struct device dev[VME_SLOTS_MAX];	/* Device registered with
> -						 * device model on VME bus
> -						 */
> +	struct vme_dev dev[VME_SLOTS_MAX];	/* Device registered
> +						 * on VME bus */
>  
>  	/* Interrupt callbacks */
>  	struct vme_irq irq[7];


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
