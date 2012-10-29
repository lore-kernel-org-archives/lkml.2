Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888Ab2J2S7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:59:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59289 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab2J2S7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:59:34 -0400
Date: Mon, 29 Oct 2012 11:59:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Input: introduce managed input devices (add devres
 support)
Message-ID: <20121029185919.GA13256@core.coreip.homeip.net>
References: <20121023053513.GA15642@core.coreip.homeip.net>
 <20121029182253.GA8015@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029182253.GA8015@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Mon, Oct 29, 2012 at 07:22:53PM +0100, Henrik Rydberg wrote:
> Hi Dmitry Torokhov wrote:
> 
> > There is a demand from driver's writers to use managed devices framework
> > for their drivers. Unfortunately up to this moment input devices did not
> > provide support for managed devices and that lead to mixing two styles
> > of resource management which usually introduced more bugs, such as
> > manually unregistering input device but relying in devres to free
> > interrupt handler which (unless device is properly shut off) can cause
> > ISR to reference already freed memory.
> > 
> > This change introduces devm_input_allocate_device() that will allocate
> > managed instance of input device so that driver writers who prefer
> > using devm_* framework do not have to mix 2 styles.
> > 
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > ---
> 
> It seems devm always operates on the parent device, so strictly
> speaking, the input device is not handled by devm, is that correct?
> For instance, one cannot call devm_release_all() on the input device,
> expecting the device to unregister itself from the input bus.

Well, I guess it depends on a point of view. devm_ manages resources
owned by a parent device, such as IRQs, memory, io regions, clocks,
regulators, and now input devices. So devm_ does manage input devces as
resources of their parent devices.

> 
> >  drivers/input/input.c | 175 ++++++++++++++++++++++++++++++++++++++++++--------
> >  include/linux/input.h |   7 +-
> >  2 files changed, 154 insertions(+), 28 deletions(-)
> > 
> > diff --git a/drivers/input/input.c b/drivers/input/input.c
> > index 53a0dde..7fe74f8 100644
> > --- a/drivers/input/input.c
> > +++ b/drivers/input/input.c
> > @@ -1723,7 +1723,7 @@ EXPORT_SYMBOL_GPL(input_class);
> >  /**
> >   * input_allocate_device - allocate memory for new input device
> >   *
> > - * Returns prepared struct input_dev or NULL.
> > + * Returns prepared struct input_dev or %NULL.
> >   *
> >   * NOTE: Use input_free_device() to free devices that have not been
> >   * registered; input_unregister_device() should be used for already
> > @@ -1750,6 +1750,70 @@ struct input_dev *input_allocate_device(void)
> >  }
> >  EXPORT_SYMBOL(input_allocate_device);
> >  
> > +struct input_devres {
> > +	struct input_dev *input;
> > +};
> > +
> > +static int devm_input_device_match(struct device *dev, void *res, void *data)
> > +{
> > +	struct input_devres *devres = res;
> > +
> > +	return devres->input == data;
> > +}
> > +
> > +static void devm_input_device_release(struct device *dev, void *res)
> > +{
> > +	struct input_devres *devres = res;
> > +	struct input_dev *input = devres->input;
> > +
> > +	dev_dbg(dev, "%s: dropping reference to %s\n",
> > +		__func__, dev_name(&input->dev));
> > +	input_put_device(input);
> > +}
> > +
> > +/**
> > + * devm_input_allocate_device - allocate managed input device
> > + * @dev: device owning the input device being created
> > + *
> > + * Returns prepared struct input_dev or %NULL.
> > + *
> > + * Managed input devices do not need to be explicitly unregistered or
> > + * freed as it will be done automatically when owner device unbinds from
> > + * its driver (or binding fails). Once managed input device is allocated,
> > + * it is ready to be set up and registered in the same fashion as regular
> > + * input device. There are no special devm_input_device_[un]register()
> > + * variants, regular ones work with both managed and unmanaged devices.
> > + *
> > + * NOTE: the owner device is set up as parent of input device and users
> > + * should not override it.
> > + */
> > +
> > +struct input_dev *devm_input_allocate_device(struct device *dev)
> > +{
> > +	struct input_dev *input;
> > +	struct input_devres *devres;
> > +
> > +	devres = devres_alloc(devm_input_device_release,
> > +			      sizeof(struct input_devres), GFP_KERNEL);
> > +	if (!devres)
> > +		return NULL;
> > +
> > +	input = input_allocate_device();
> > +	if (!input) {
> > +		devres_free(devres);
> > +		return NULL;
> > +	}
> > +
> > +	input->dev.parent = dev;
> > +	input->devres_managed = true;
> > +
> > +	devres->input = input;
> > +	devres_add(dev, devres);
> > +
> > +	return input;
> > +}
> > +EXPORT_SYMBOL(devm_input_allocate_device);
> > +
> >  /**
> >   * input_free_device - free memory occupied by input_dev structure
> >   * @dev: input device to free
> > @@ -1766,8 +1830,14 @@ EXPORT_SYMBOL(input_allocate_device);
> >   */
> >  void input_free_device(struct input_dev *dev)
> >  {
> > -	if (dev)
> > +	if (dev) {
> > +		if (dev->devres_managed)
> > +			WARN_ON(devres_destroy(dev->dev.parent,
> > +						devm_input_device_release,
> > +						devm_input_device_match,
> > +						dev));
> >  		input_put_device(dev);
> 
> Device is put twice?

No, devres_destroy() does not actually run the release handler so we
need to call it explicitly.

> 
> > +	}
> >  }
> >  EXPORT_SYMBOL(input_free_device);
> >  
> > @@ -1888,6 +1958,38 @@ static void input_cleanse_bitmasks(struct input_dev *dev)
> >  	INPUT_CLEANSE_BITMASK(dev, SW, sw);
> >  }
> >  
> > +static void __input_unregister_device(struct input_dev *dev)
> > +{
> > +	struct input_handle *handle, *next;
> > +
> > +	input_disconnect_device(dev);
> > +
> > +	mutex_lock(&input_mutex);
> > +
> > +	list_for_each_entry_safe(handle, next, &dev->h_list, d_node)
> > +		handle->handler->disconnect(handle);
> > +	WARN_ON(!list_empty(&dev->h_list));
> > +
> > +	del_timer_sync(&dev->timer);
> > +	list_del_init(&dev->node);
> > +
> > +	input_wakeup_procfs_readers();
> > +
> > +	mutex_unlock(&input_mutex);
> > +
> > +	device_del(&dev->dev);
> > +}
> > +
> > +static void devm_input_device_unregister(struct device *dev, void *res)
> > +{
> > +	struct input_devres *devres = res;
> > +	struct input_dev *input = devres->input;
> > +
> > +	dev_dbg(dev, "%s: unregistering device %s\n",
> > +		__func__, dev_name(&input->dev));
> > +	__input_unregister_device(input);
> > +}
> > +
> >  /**
> >   * input_register_device - register device with input core
> >   * @dev: device to be registered
> > @@ -1903,11 +2005,21 @@ static void input_cleanse_bitmasks(struct input_dev *dev)
> >  int input_register_device(struct input_dev *dev)
> >  {
> >  	static atomic_t input_no = ATOMIC_INIT(0);
> > +	struct input_devres *devres = NULL;
> >  	struct input_handler *handler;
> >  	unsigned int packet_size;
> >  	const char *path;
> >  	int error;
> >  
> > +	if (dev->devres_managed) {
> > +		devres = devres_alloc(devm_input_device_unregister,
> > +				      sizeof(struct input_devres), GFP_KERNEL);
> > +		if (!devres)
> > +			return -ENOMEM;
> > +
> > +		devres->input = dev;
> > +	}
> > +
> >  	/* Every input device generates EV_SYN/SYN_REPORT events. */
> >  	__set_bit(EV_SYN, dev->evbit);
> >  
> > @@ -1923,8 +2035,10 @@ int input_register_device(struct input_dev *dev)
> >  
> >  	dev->max_vals = max(dev->hint_events_per_packet, packet_size) + 2;
> >  	dev->vals = kcalloc(dev->max_vals, sizeof(*dev->vals), GFP_KERNEL);
> > -	if (!dev->vals)
> > -		return -ENOMEM;
> > +	if (!dev->vals) {
> > +		error = -ENOMEM;
> > +		goto err_devres_free;
> > +	}
> >  
> >  	/*
> >  	 * If delay and period are pre-set by the driver, then autorepeating
> > @@ -1949,7 +2063,7 @@ int input_register_device(struct input_dev *dev)
> >  
> >  	error = device_add(&dev->dev);
> >  	if (error)
> > -		return error;
> > +		goto err_free_vals;
> >  
> >  	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
> >  	pr_info("%s as %s\n",
> > @@ -1958,10 +2072,8 @@ int input_register_device(struct input_dev *dev)
> >  	kfree(path);
> >  
> >  	error = mutex_lock_interruptible(&input_mutex);
> > -	if (error) {
> > -		device_del(&dev->dev);
> > -		return error;
> > -	}
> > +	if (error)
> > +		goto err_device_del;
> >  
> >  	list_add_tail(&dev->node, &input_dev_list);
> >  
> > @@ -1972,7 +2084,20 @@ int input_register_device(struct input_dev *dev)
> >  
> >  	mutex_unlock(&input_mutex);
> >  
> > +	if (dev->devres_managed) {
> > +		dev_info(dev->dev.parent, "%s: registerign %s with devres.\n",
> > +			__func__, dev->name ?: "N/A");
> > +		devres_add(dev->dev.parent, devres);
> > +	}
> 
> Why not add the resource to the input device instead? For one, it
> would make the order of unregister and release more apparent.

And what would that achieve? What would trigger unregistration?

> Right
> now, the code seems to rely on the reverse for-loop in the devres
> implementation.

That is the whole point of devres: it releases resources attached to
the parent device (either when ->probe() fails or after ->remove() is
called) in the opposed order of acquiring said resources. Think of it as
calling destructors in C++ code.

> 
> >  	return 0;
> > +
> > +err_device_del:
> > +	device_del(&dev->dev);
> > +err_free_vals:
> > +	kfree(dev->vals);
> > +err_devres_free:
> > +	devres_free(devres);
> > +	return error;
> >  }
> >  EXPORT_SYMBOL(input_register_device);
> >  
> > @@ -1985,24 +2110,20 @@ EXPORT_SYMBOL(input_register_device);
> >   */
> >  void input_unregister_device(struct input_dev *dev)
> >  {
> > -	struct input_handle *handle, *next;
> > -
> > -	input_disconnect_device(dev);
> > -
> > -	mutex_lock(&input_mutex);
> > -
> > -	list_for_each_entry_safe(handle, next, &dev->h_list, d_node)
> > -		handle->handler->disconnect(handle);
> > -	WARN_ON(!list_empty(&dev->h_list));
> > -
> > -	del_timer_sync(&dev->timer);
> > -	list_del_init(&dev->node);
> > -
> > -	input_wakeup_procfs_readers();
> > -
> > -	mutex_unlock(&input_mutex);
> > -
> > -	device_unregister(&dev->dev);
> > +	if (dev->devres_managed) {
> > +		WARN_ON(devres_destroy(dev->dev.parent,
> > +					devm_input_device_unregister,
> > +					devm_input_device_match,
> > +					dev));
> > +		__input_unregister_device(dev);
> 
> Unregistering twice?

Nope ;) See above about devres_destroy().

> 
> > +		/*
> > +		 * We do not do input_put_device() here because it will be done
> > +		 * when 2nd devres fires up.
> > +		 */
> > +	} else {
> > +		__input_unregister_device(dev);
> > +		input_put_device(dev);
> > +	}
> >  }
> >  EXPORT_SYMBOL(input_unregister_device);
> >  
> > diff --git a/include/linux/input.h b/include/linux/input.h
> > index 15464ba..bfc479c 100644
> > --- a/include/linux/input.h
> > +++ b/include/linux/input.h
> > @@ -1256,6 +1256,8 @@ struct input_value {
> >   * @h_list: list of input handles associated with the device. When
> >   *	accessing the list dev->mutex must be held
> >   * @node: used to place the device onto input_dev_list
> > + * @devres_managed: indicates that devices is managed with devres framework
> > + *	and needs not be explicitly unregistered or freed.
> >   */
> >  struct input_dev {
> >  	const char *name;
> > @@ -1324,6 +1326,8 @@ struct input_dev {
> >  	unsigned int num_vals;
> >  	unsigned int max_vals;
> >  	struct input_value *vals;
> > +
> > +	bool devres_managed;
> >  };
> >  #define to_input_dev(d) container_of(d, struct input_dev, dev)
> >  
> > @@ -1467,7 +1471,8 @@ struct input_handle {
> >  	struct list_head	h_node;
> >  };
> >  
> > -struct input_dev *input_allocate_device(void);
> > +struct input_dev __must_check *input_allocate_device(void);
> > +struct input_dev __must_check *devm_input_allocate_device(struct device *);
> >  void input_free_device(struct input_dev *dev);
> >  
> >  static inline struct input_dev *input_get_device(struct input_dev *dev)
> > -- 
> > 1.7.11.7
> 
> Thanks,
> Henrik

Thanks.

-- 
Dmitry
