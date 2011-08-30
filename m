Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab1H3KDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 06:03:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58861 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1H3KC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 06:02:57 -0400
Date: Tue, 30 Aug 2011 11:02:45 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>, Barry Song <21cnbao@gmail.com>,
        Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        David Brown <davidb@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/4 v5] drivers: create a pin control subsystem v5
Message-ID: <20110830100245.GD5414@pulham.picochip.com>
References: <1314609001-28052-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314609001-28052-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is looking really great!  A couple of pedantic nits inline, but 
with the gpio ranges support I think this covers all of the bases that 
we need from pin control, so thanks!

Jamie

On Mon, Aug 29, 2011 at 11:10:01AM +0200, Linus Walleij wrote:
[...]
> diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
> new file mode 100644
> index 0000000..596ce9f
> --- /dev/null
> +++ b/drivers/pinctrl/Makefile
> @@ -0,0 +1,6 @@
> +# generic pinmux support
> +
> +ccflags-$(CONFIG_DEBUG_PINMUX)	+= -DDEBUG
> +
> +obj-$(CONFIG_PINCTRL)		+= core.o
> +obj-$(CONFIG_PINMUX)		+= pinmux.o
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> new file mode 100644
> index 0000000..762e9e8
> --- /dev/null
> +++ b/drivers/pinctrl/core.c
> @@ -0,0 +1,539 @@
> +/*
> + * Core driver for the pin control subsystem
> + *
> + * Copyright (C) 2011 ST-Ericsson SA
> + * Written on behalf of Linaro for ST-Ericsson
> + * Based on bits of regulator core, gpio core and clk core
> + *
> + * Author: Linus Walleij <linus.walleij@linaro.org>
> + *
> + * License terms: GNU General Public License (GPL) version 2
> + */
> +#define pr_fmt(fmt) "pinctrl core: " fmt
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/radix-tree.h>
> +#include <linux/err.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/spinlock.h>
> +#include <linux/sysfs.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +#include <linux/pinctrl/pinctrl.h>
> +#include <linux/pinctrl/machine.h>
> +#include "core.h"
> +#include "pinmux.h"
> +
> +/* Global list of pin control devices */
> +static DEFINE_MUTEX(pinctrldev_list_mutex);
> +static LIST_HEAD(pinctrldev_list);
> +
> +/* sysfs interaction */
> +static ssize_t pinctrl_name_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct pinctrl_dev *pctldev = dev_get_drvdata(dev);

As you have a struct device in pctldev, you should be able to do:

#define to_pinctrl_dev(__dev) \
	container_of(__dev, struct pinctrl_dev, dev)

struct pinctrl_dev *pctldev = to_pinctrl_dev(dev);

then you don't need to use the driver data.

[...]
> +static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
> +{
> +	static struct dentry *device_root;

Does device_root need to be static?

> +
> +	device_root = debugfs_create_dir(dev_name(&pctldev->dev),
> +					 debugfs_root);
> +	if (IS_ERR(device_root) || !device_root) {
> +		pr_warn("failed to create debugfs directory for %s\n",
> +			dev_name(&pctldev->dev));
> +		return;
> +	}
> +	debugfs_create_file("pins", S_IFREG | S_IRUGO,
> +			    device_root, pctldev, &pinctrl_pins_ops);
> +	debugfs_create_file("gpio-ranges", S_IFREG | S_IRUGO,
> +			    device_root, pctldev, &pinctrl_gpioranges_ops);
> +	pinmux_init_device_debugfs(device_root, pctldev);
> +}
> +
> +static void pinctrl_init_debugfs(void)
> +{
> +	debugfs_root = debugfs_create_dir("pinctrl", NULL);
> +	if (IS_ERR(debugfs_root) || !debugfs_root) {

IS_ERR_OR_NULL()?

> +		pr_warn("failed to create debugfs directory\n");
> +		debugfs_root = NULL;
> +		return;
> +	}
> +
> +	debugfs_create_file("pinctrl-devices", S_IFREG | S_IRUGO,
> +			    debugfs_root, NULL, &pinctrl_devices_ops);
> +	pinmux_init_debugfs(debugfs_root);
> +}
> +
> +#else /* CONFIG_DEBUG_FS */
> +
> +static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
> +{
> +}
> +
> +static void pinctrl_init_debugfs(void)
> +{
> +}
> +
> +#endif
> +
> +/**
> + * pinctrl_register() - register a pin controller device
> + * @pctldesc: descriptor for this pin controller
> + * @dev: parent device for this pin controller
> + * @driver_data: private pin controller data for this pin controller
> + */
> +struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
> +				    struct device *dev, void *driver_data)
> +{
> +	static atomic_t pinmux_no = ATOMIC_INIT(0);
> +	struct pinctrl_dev *pctldev;
> +	int ret;
> +
> +	if (pctldesc == NULL)
> +		return ERR_PTR(-EINVAL);
> +	if (pctldesc->name == NULL)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* If we're implementing pinmuxing, check the ops for sanity */
> +	if (pctldesc->pmxops) {
> +		ret = pinmux_check_ops(pctldesc->pmxops);
> +		if (ret)
> +			return ERR_PTR(ret);
> +	}
> +
> +	pctldev = kzalloc(sizeof(struct pinctrl_dev), GFP_KERNEL);
> +	if (pctldev == NULL)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Initialize pin control device struct */
> +	pctldev->owner = pctldesc->owner;
> +	pctldev->desc = pctldesc;
> +	pctldev->driver_data = driver_data;
> +	INIT_RADIX_TREE(&pctldev->pin_desc_tree, GFP_KERNEL);
> +	spin_lock_init(&pctldev->pin_desc_tree_lock);
> +	INIT_LIST_HEAD(&pctldev->gpio_ranges);
> +	spin_lock_init(&pctldev->gpio_ranges_lock);
> +
> +	/* Register device with sysfs */
> +	pctldev->dev.parent = dev;
> +	pctldev->dev.bus = &pinctrl_bus;
> +	pctldev->dev.type = &pinctrl_type;
> +	dev_set_name(&pctldev->dev, "pinctrl.%d",
> +		     atomic_inc_return(&pinmux_no) - 1);
> +	ret = device_register(&pctldev->dev);
> +	if (ret != 0) {
> +		pr_err("error in device registration\n");
> +		put_device(&pctldev->dev);
> +		kfree(pctldev);

I don't think you need the kfree() here as it should get called in the 
devices release method.

> +		goto out_err;
> +	}
> +	dev_set_drvdata(&pctldev->dev, pctldev);
> +
> +	/* Register all the pins */
> +	pr_debug("try to register %d pins on %s...\n",
> +		 pctldesc->npins, pctldesc->name);
> +	ret = pinctrl_register_pins(pctldev, pctldesc->pins, pctldesc->npins);
> +	if (ret) {
> +		pr_err("error during pin registration\n");
> +		pinctrl_free_pindescs(pctldev, pctldesc->pins,
> +				      pctldesc->npins);
> +		goto out_err;
> +	}
> +
> +	pinctrl_init_device_debugfs(pctldev);
> +	mutex_lock(&pinctrldev_list_mutex);
> +	list_add(&pctldev->node, &pinctrldev_list);
> +	mutex_unlock(&pinctrldev_list_mutex);
> +	return pctldev;
> +
> +out_err:
> +	put_device(&pctldev->dev);
> +	kfree(pctldev);

I think this needs to be a device_unregister() rather than put device, 
and the kfree() can be dropped.

Possibly also do a dev_set_drvdata(&pctldev->dev, NULL) here too?

> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
> new file mode 100644
> index 0000000..310d344
> --- /dev/null
> +++ b/drivers/pinctrl/pinmux.c
> @@ -0,0 +1,811 @@
> +/*
> + * Core driver for the pin muxing portions of the pin control subsystem
> + *
> + * Copyright (C) 2011 ST-Ericsson SA
> + * Written on behalf of Linaro for ST-Ericsson
> + * Based on bits of regulator core, gpio core and clk core
> + *
> + * Author: Linus Walleij <linus.walleij@linaro.org>
> + *
> + * License terms: GNU General Public License (GPL) version 2
> + */
> +#define pr_fmt(fmt) "pinmux core: " fmt
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/radix-tree.h>
> +#include <linux/err.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/spinlock.h>
> +#include <linux/sysfs.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +#include <linux/pinctrl/machine.h>
> +#include <linux/pinctrl/pinmux.h>
> +#include "core.h"
> +
> +/* Global list of pinmuxes */
> +static DEFINE_MUTEX(pinmux_list_mutex);
> +static LIST_HEAD(pinmux_list);
> +
> +/**
> + * struct pinmux - per-device pinmux state holder
> + * @node: global list node - only for internal use
> + * @dev: the device using this pinmux
> + * @map: corresponding pinmux map active for this pinmux setting
> + * @usecount: the number of active users of this mux setting, used to keep
> + *	track of nested use cases
> + * @pins: an array of discrete physical pins used in this mapping, taken
> + *	from the global pin enumeration space (copied from pinmux map)
> + * @num_pins: the number of pins in this mapping array, i.e. the number of
> + *	elements in .pins so we can iterate over that array (copied from
> + *	pinmux map)
> + * @pctldev: pin control device handling this pinmux
> + * @pmxdev_selector: the function selector for the pinmux device handling
> + *	this pinmux
> + * @pmxdev_position: the function position for the pinmux device and
> + *	selector handling this pinmux
> + * @mutex: a lock for the pinmux state holder
> + */
> +struct pinmux {
> +	struct list_head node;
> +	struct device *dev;
> +	struct pinmux_map const *map;
> +	unsigned usecount;
> +	struct pinctrl_dev *pctldev;
> +	unsigned pmxdev_selector;
> +	unsigned pmxdev_position;
> +	struct mutex mutex;
> +};
> +
> +/**
> + * pin_request() - request a single pin to be muxed in, typically for GPIO
> + * @pin: the pin number in the global pin space
> + * @function: a functional name to give to this pin, passed to the driver
> + *	so it knows what function to mux in, e.g. the string "gpioNN"
> + *	means that you want to mux in the pin for use as GPIO number NN
> + * @gpio: if this request concerns a single GPIO pin
> + * @gpio_range: the range matching the GPIO pin if this is a request for a
> + *	single GPIO pin
> + */
> +static int pin_request(struct pinctrl_dev *pctldev,
> +		       int pin, const char *function, bool gpio,
> +		       struct pinctrl_gpio_range *gpio_range)

@gpio_range is only valid if @gpio == true, so we could drop @gpio and 
only do gpio_request_enable if gpio_range != NULL?  At least that way we 
can't call gpio_request_enable with a NULL gpio_range (which I don't 
think is valid?).

[...]
> +/**
> + * pinmux_config() - configure a certain pinmux setting
> + * @pmx: the pinmux setting to configure
> + * @param: the parameter to configure
> + * @data: extra data to be passed to the configuration, also works as a
> + *	pointer to data returned from the function on success
> + */
> +int pinmux_config(struct pinmux *pmx, u16 param, unsigned long *data)
> +{
> +	struct pinctrl_dev *pctldev;
> +	const struct pinmux_ops *ops;
> +	int ret = 0;
> +
> +	if (pmx == NULL)
> +		return -ENODEV;
> +
> +	pctldev = pmx->pctldev;
> +	ops = pctldev->desc->pmxops;
> +
> +	/* This operation is not mandatory to implement */
> +	if (ops->config) {
> +		mutex_lock(&pmx->mutex);
> +		ret = ops->config(pctldev, pmx->pmxdev_selector, param, data);
> +		mutex_unlock(&pmx->mutex);
> +	}
> +
> +	return 0;

Shouldn't this return ret from ops->config()?
