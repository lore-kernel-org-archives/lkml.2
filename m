Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1HSKsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 06:48:24 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47592 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1HSKsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 06:48:21 -0400
Date: Fri, 19 Aug 2011 11:48:16 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/4 v4] drivers: create a pin control subsystem
Message-ID: <20110819104816.GA5030@pulham.picochip.com>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is looking really nice.  I have a few comments/queries inline 
though.

Jamie

On Fri, Aug 19, 2011 at 11:53:50AM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This creates a subsystem for handling of pin control devices.
> These are devices that control different aspects of package
> pins.
> 
> Currently it handled pinmuxing, i.e. assign electronic functions
> to groups of pins of pins on primarily PGA and BGA type of chip
> packages and common in embedded systems.
> 
> The plan is to also handle other I/O pin control aspects such as
> biasing, driving, input properties such as schmitt-triggering,
> load capacitance etc within this subsystem.
> 
> This is being done to depopulate the arch/arm/* directory of such
> custom drivers and try to abstract the infrastructure they all
> need. See the Documentation/pinmux.txt file that is part of this
> patch for more details.
> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  Documentation/ABI/testing/sysfs-class-pinmux |   11 +
>  Documentation/pinctrl.txt                    |  512 +++++++++++++++++++
>  MAINTAINERS                                  |    5 +
>  drivers/Kconfig                              |    4 +
>  drivers/Makefile                             |    2 +
>  drivers/pinctrl/Kconfig                      |   29 ++
>  drivers/pinctrl/Makefile                     |    6 +
>  drivers/pinctrl/core.c                       |  437 ++++++++++++++++
>  drivers/pinctrl/core.h                       |   22 +
>  drivers/pinctrl/pinmux.c                     |  700 ++++++++++++++++++++++++++
>  drivers/pinctrl/pinmux.h                     |    4 +
>  include/linux/pinctrl/machine.h              |   62 +++
>  include/linux/pinctrl/pinctrl.h              |  120 +++++
>  include/linux/pinctrl/pinmux.h               |  122 +++++
>  14 files changed, 2036 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-pinmux
>  create mode 100644 Documentation/pinctrl.txt
>  create mode 100644 drivers/pinctrl/Kconfig
>  create mode 100644 drivers/pinctrl/Makefile
>  create mode 100644 drivers/pinctrl/core.c
>  create mode 100644 drivers/pinctrl/core.h
>  create mode 100644 drivers/pinctrl/pinmux.c
>  create mode 100644 drivers/pinctrl/pinmux.h
>  create mode 100644 include/linux/pinctrl/machine.h
>  create mode 100644 include/linux/pinctrl/pinctrl.h
>  create mode 100644 include/linux/pinctrl/pinmux.h
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-pinmux b/Documentation/ABI/testing/sysfs-class-pinmux
> new file mode 100644
> index 0000000..c2ea843
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-pinmux
> @@ -0,0 +1,11 @@
> +What:		/sys/class/pinmux/.../name
> +Date:		May 2011
> +KernelVersion:	3.1
> +Contact:	Linus Walleij <linus.walleij@linaro.org>
> +Description:
> +		Each pinmux directory will contain a field called
> +		name. This holds a string identifying the pinmux for
> +		display purposes.
> +
> +		NOTE: this will be empty if no suitable name is provided
> +		by platform or pinmux drivers.
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> new file mode 100644
> index 0000000..84a2557
> --- /dev/null
> +++ b/Documentation/pinctrl.txt
[...]
> +Interaction with the GPIO subsystem
> +===================================
> +
> +The GPIO drivers may want to perform operations of various types on the same
> +physical pins that are also registered as GPIO pins.
> +
> +Since the pin controller subsystem have its pinspace local to the pin
> +controller we need a mapping so that the pin control subsystem can figure out
> +which pin controller handles control of a certain GPIO pin. This member
> +in the pin controller descriptor handles this mapping:
> +
> +static struct pinctrl_desc foo_desc = {
> +	...
> +	.gpio_base = FIRST_PIN,
> +};
> +
> +When GPIO-specific functions in the pin control subsystem are called, these
> +mappings will be used to look up the apropriate pin controller by inspecting
> +and matching the pin to this pin range.

On our (difficultly muxed!) platform we have two types of GPIO - a 
Synopsys controller which is a fairly conventional GPIO controller, then 
a sigma-delta GPIO controller which can also do a an analogue type 
output (as well as digital).  For lots of our pads they can either be 
ARM GPIO, SD GPIO or some other function, so I don't see how this fits 
in with a single GPIO base.

> +The correspondence for the range from the GPIO subsystem to the pin controller
> +subsystem must be one-to-one. Thus the GPIO pins are in the pin controller
> +range [0 .. maxpin] where maxpin is the specified end of the pin range.

So doesn't this mean that the enumeration that was initially described 
as arbitrary actually has to enumerate the GPIO pins first?

[...]
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> new file mode 100644
> index 0000000..41f7ac1
> --- /dev/null
> +++ b/drivers/pinctrl/core.c
> @@ -0,0 +1,437 @@
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
> +static ssize_t pinctrl_name_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct pinctrl_dev *pctldev = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%s\n", pctldev_get_name(pctldev));
> +}
> +
> +static struct device_attribute pinctrl_dev_attrs[] = {
> +	__ATTR(name, 0444, pinctrl_name_show, NULL),
> +	__ATTR_NULL,
> +};
> +
> +static void pinctrl_dev_release(struct device *dev)
> +{
> +	struct pinctrl_dev *pctldev = dev_get_drvdata(dev);
> +	kfree(pctldev);
> +}
> +
> +static struct class pinctrl_class = {
> +	.name = "pinctrl",
> +	.dev_release = pinctrl_dev_release,
> +	.dev_attrs = pinctrl_dev_attrs,
> +};

Greg K-H has mentioned in the past that class is now deprecated for new 
use and that a bus_type should be used instead.

> +
> +/**
> + * Looks up a pin control device matching a certain pinmux map
> + */
> +struct pinctrl_dev *get_pctrldev_for_pinmux_map(struct pinmux_map const *map)
> +{
> +	struct pinctrl_dev *pctldev = NULL;
> +	bool found = false;
> +
> +	list_for_each_entry(pctldev, &pinctrldev_list, node) {
> +		if (map->ctrl_dev &&  &pctldev->dev == map->ctrl_dev) {
> +			/* Matched on device */
> +			found = true;
> +			break;
> +		}
> +
> +		if (map->ctrl_dev_name &&
> +		    !strcmp(dev_name(&pctldev->dev), map->ctrl_dev_name)) {
> +			/* Matched on device name */
> +			found = true;
> +			break;
> +		}
> +	}
> +
> +	if (found)
> +		return pctldev;
> +
> +	return NULL;
> +}
> +
> +struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, int pin)
> +{
> +	struct pin_desc *pindesc;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pctldev->pin_desc_tree_lock, flags);
> +	pindesc = radix_tree_lookup(&pctldev->pin_desc_tree, pin);
> +	spin_unlock_irqrestore(&pctldev->pin_desc_tree_lock, flags);
> +
> +	return pindesc;
> +}
> +
> +/**
> + * Tell us whether a certain pin exist on a certain pin controller
> + * or not. Pin lists may be sparse, so some pins may not exist.
> + * @pctldev: the pin control device to check the pin on
> + * @pin: pin to check, use the local pin controller index number
> + */
> +bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
> +{
> +	struct pin_desc *pindesc;
> +
> +	if (pin < 0)
> +		return false;
> +
> +	pindesc = pin_desc_get(pctldev, pin);
> +	if (pindesc == NULL)
> +		return false;
> +
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(pin_is_valid);
> +
> +/* Deletes a range of pin descriptors */
> +static void pinctrl_free_pindescs(struct pinctrl_dev *pctldev,
> +				  const struct pinctrl_pin_desc *pins,
> +				  unsigned num_pins)
> +{
> +	int i;
> +
> +	spin_lock(&pctldev->pin_desc_tree_lock);
> +	for (i = 0; i < num_pins; i++) {
> +		struct pin_desc *pindesc;
> +
> +		pindesc = radix_tree_lookup(&pctldev->pin_desc_tree,
> +					    pins[i].number);
> +		if (pindesc != NULL) {
> +			radix_tree_delete(&pctldev->pin_desc_tree,
> +					  pins[i].number);
> +		}
> +		kfree(pindesc);
> +	}
> +	spin_unlock(&pctldev->pin_desc_tree_lock);
> +}
> +
> +static int pinctrl_register_one_pin(struct pinctrl_dev *pctldev,
> +				    unsigned number, const char *name)
> +{
> +	struct pin_desc *pindesc;
> +
> +	pindesc = pin_desc_get(pctldev, number);
> +	if (pindesc != NULL) {
> +		pr_err("pin %d already registered on %s\n", number,
> +		       pctldev->desc->name);
> +		return -EINVAL;
> +	}
> +
> +	pindesc = kzalloc(sizeof(*pindesc), GFP_KERNEL);
> +	if (pindesc == NULL)
> +		return -ENOMEM;
> +
> +	/* Set owner */
> +	pindesc->pctldev = pctldev;
> +
> +	/* Copy optional basic pin info */
> +	if (name)
> +		strlcpy(pindesc->name, name, sizeof(pindesc->name));
> +
> +	spin_lock(&pctldev->pin_desc_tree_lock);
> +	radix_tree_insert(&pctldev->pin_desc_tree, number, pindesc);
> +	spin_unlock(&pctldev->pin_desc_tree_lock);
> +	pr_debug("registered pin %d (%s) on %s\n",
> +		 number, name ? name : "(unnamed)", pctldev->desc->name);
> +	return 0;
> +}
> +
> +static int pinctrl_register_pins(struct pinctrl_dev *pctldev,
> +				 struct pinctrl_pin_desc const *pins,
> +				 unsigned num_descs)
> +{
> +	unsigned i;
> +	int ret = 0;
> +
> +	for (i = 0; i < num_descs; i++) {
> +		ret = pinctrl_register_one_pin(pctldev,
> +					       pins[i].number, pins[i].name);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * pinctrl_get_device_for_gpio() - find the pin controller handling a certain
> + * pin from the pinspace in the GPIO subsystem
> + * @gpio: the pin to locate the pin controller for
> + */
> +struct pinctrl_dev *pinctrl_get_device_for_gpio(unsigned gpio)
> +{
> +	struct pinctrl_dev *pctldev = NULL;
> +	bool found;
> +
> +	list_for_each_entry(pctldev, &pinctrldev_list, node) {
> +		struct pinctrl_desc *desc = pctldev->desc;
> +
> +		/* Check if we're in the valid range */
> +		if (gpio >= desc->gpio_base &&
> +		    gpio <= desc->gpio_base + desc->maxpin) {
> +			found = true;
> +			break;
> +		}
> +	}
> +
> +	if (found)
> +		return pctldev;
> +	return NULL;
> +}
> +
> +#ifdef CONFIG_DEBUG_FS
> +
> +static int pinctrl_pins_show(struct seq_file *s, void *what)
> +{
> +	struct pinctrl_dev *pctldev = s->private;
> +	unsigned pin;
> +
> +	seq_printf(s, "registered pins: %d\n", pctldev->desc->npins);
> +	seq_printf(s, "max pin number: %d\n", pctldev->desc->maxpin);
> +
> +	/* The highest pin number need to be included in the loop, thus <= */
> +	for (pin = 0; pin <= pctldev->desc->maxpin; pin++) {
> +		struct pin_desc *desc;
> +
> +		desc = pin_desc_get(pctldev, pin);
> +		/* Pin space may be sparse */
> +		if (desc == NULL)
> +			continue;
> +
> +		seq_printf(s, "pin %d (%s)\n", pin,
> +			   desc->name ? desc->name : "unnamed");
> +	}
> +
> +	return 0;
> +}
> +
> +static int pinctrl_devices_show(struct seq_file *s, void *what)
> +{
> +	struct pinctrl_dev *pctldev;
> +
> +	seq_puts(s, "name [pinmux]\n");
> +	list_for_each_entry(pctldev, &pinctrldev_list, node) {
> +		seq_printf(s, "%s ", pctldev->desc->name);
> +		if (pctldev->desc->pmxops)
> +			seq_puts(s, "yes");
> +		else
> +			seq_puts(s, "no");
> +		seq_puts(s, "\n");
> +	}
> +
> +	return 0;
> +}
> +
> +static int pinctrl_pins_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, pinctrl_pins_show, inode->i_private);
> +}
> +
> +static int pinctrl_devices_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, pinctrl_devices_show, NULL);
> +}
> +
> +static const struct file_operations pinctrl_pins_ops = {
> +	.open		= pinctrl_pins_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
> +static const struct file_operations pinctrl_devices_ops = {
> +	.open		= pinctrl_devices_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
> +static struct dentry *debugfs_root;
> +
> +static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
> +{
> +	static struct dentry *device_root;
> +
> +	device_root = debugfs_create_dir(dev_name(&pctldev->dev),
> +					 debugfs_root);
> +	if (IS_ERR(device_root) || !device_root) {

IS_ERR_OR_NULL()?

> +		pr_warn("failed to create debugfs directory for %s\n",
> +			dev_name(&pctldev->dev));
> +		return;
> +	}
> +	debugfs_create_file("pins", S_IFREG | S_IRUGO,
> +			    device_root, pctldev, &pinctrl_pins_ops);
> +	pinmux_init_device_debugfs(device_root, pctldev);
> +}
> +
> +static void pinctrl_init_debugfs(void)
> +{
> +	debugfs_root = debugfs_create_dir("pinctrl", NULL);
> +	if (IS_ERR(debugfs_root) || !debugfs_root) {
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
> +
> +	/* Register device with sysfs */
> +	pctldev->dev.class = &pinctrl_class;
> +	pctldev->dev.parent = dev;
> +	dev_set_name(&pctldev->dev, "pinctrl.%d",
> +		     atomic_inc_return(&pinmux_no) - 1);
> +	ret = device_register(&pctldev->dev);
> +	if (ret != 0) {
> +		pr_err("error in device registration\n");
> +		put_device(&pctldev->dev);
> +		kfree(pctldev);
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
> +	mutex_unlock(&pinctrldev_list_mutex);
> +	put_device(&pctldev->dev);
> +	kfree(pctldev);
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(pinctrl_register);
> +
> +/**
> + * pinctrl_unregister() - unregister pinmux
> + * @pctldev: pin controller to unregister
> + *
> + * Called by pinmux drivers to unregister a pinmux.
> + */
> +void pinctrl_unregister(struct pinctrl_dev *pctldev)
> +{
> +	if (pctldev == NULL)
> +		return;
> +
> +	mutex_lock(&pinctrldev_list_mutex);
> +	list_del(&pctldev->node);
> +	device_unregister(&pctldev->dev);
> +	mutex_unlock(&pinctrldev_list_mutex);
> +	/* Destroy descriptor tree */
> +	pinctrl_free_pindescs(pctldev, pctldev->desc->pins,
> +			      pctldev->desc->npins);
> +}
> +EXPORT_SYMBOL_GPL(pinctrl_unregister);
> +
> +static int __init pinctrl_init(void)
> +{
> +	int ret;
> +
> +	ret = class_register(&pinctrl_class);
> +	pr_info("initialized pinctrl subsystem\n");
> +
> +	pinctrl_init_debugfs();
> +	return ret;
> +}
> +
> +/* init early since many drivers really need to initialized pinmux early */
> +core_initcall(pinctrl_init);
> diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
> new file mode 100644
> index 0000000..5315fc5
> --- /dev/null
> +++ b/drivers/pinctrl/core.h
> @@ -0,0 +1,22 @@
> +/**
> + * struct pin_desc - pin descriptor for each physical pin in the arch
> + * @pctldev: corresponding pin control device
> + * @name: a name for the pin, e.g. the name of the pin/pad/finger on a
> + *	datasheet or such
> + * @mux_requested: whether the pin is already requested by pinmux or not
> + * @mux_function: a named muxing function for the pin that will be passed to
> + *	subdrivers and shown in debugfs etc
> + */
> +struct pin_desc {
> +	struct pinctrl_dev *pctldev;
> +	char	name[16];
> +	/* These fields only added when supporting pinmux drivers */
> +#ifdef CONFIG_PINMUX
> +	bool	mux_requested;
> +	char	mux_function[16];
> +#endif
> +};
> +
> +struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, int pin);
> +struct pinctrl_dev *get_pctrldev_for_pinmux_map(struct pinmux_map const *map);
> +struct pinctrl_dev *pinctrl_get_device_for_gpio(unsigned gpio);
> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
> new file mode 100644
> index 0000000..2e0d99e
> --- /dev/null
> +++ b/drivers/pinctrl/pinmux.c
> @@ -0,0 +1,700 @@
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
> + * @pmxdev_selector: the selector for the pinmux device handling this pinmux
> + * @mutex: a lock for the pinmux state holder
> + */
> +struct pinmux {
> +	struct list_head node;
> +	struct device *dev;
> +	struct pinmux_map const *map;
> +	unsigned usecount;
> +	struct pinctrl_dev *pctldev;
> +	unsigned pmxdev_selector;
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
> + */
> +static int pin_request(struct pinctrl_dev *pctldev,
> +		       int pin, const char *function, bool gpio)
> +{
> +	struct pin_desc *desc;
> +	const struct pinmux_ops *ops;
> +	int status = -EINVAL;
> +
> +	pr_debug("request pin %d for %s\n", pin, function);
> +
> +	if (!pin_is_valid(pctldev, pin)) {
> +		pr_err("pin is invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!function) {
> +		pr_err("no function name given\n");
> +		return -EINVAL;
> +	}
> +
> +	desc = pin_desc_get(pctldev, pin);
> +	if (desc == NULL) {
> +		pr_err("pin is not registered so it cannot be requested\n");
> +		goto out;
> +	}
> +	if (desc->mux_requested) {
> +		pr_err("pin already requested\n");
> +		goto out;
> +	}
> +	ops = pctldev->desc->pmxops;
> +
> +	/* Let each pin increase references to this module */
> +	if (!try_module_get(pctldev->owner)) {
> +		pr_err("could not increase module refcount for pin %d\n", pin);
> +		status = -EINVAL;
> +		goto out;
> +	}
> +
> +	/*
> +	 * If there is no kind of request function for the pin we just assume
> +	 * we got it by default and proceed.
> +	 */
> +	if (gpio && ops->gpio_request_enable)
> +		/* This requests and enables a single GPIO pin */
> +		status = ops->gpio_request_enable(pctldev, pin);
> +	else if (ops->request)
> +		status = ops->request(pctldev, pin);
> +	else
> +		status = 0;
> +
> +	if (status) {
> +		pr_err("->request on device %s failed "
> +		       "for pin %d\n",
> +		       pctldev->desc->name, pin);
> +		goto out;
> +	}
> +
> +	desc->mux_requested = true;
> +	strncpy(desc->mux_function, function, sizeof(desc->mux_function));
> +
> +out:
> +	if (status)
> +		pr_err("pin-%d (%s) status %d\n",
> +		       pin, function ? : "?", status);
> +
> +	return status;
> +}
> +
> +/**
> + * pin_free() - release a single muxed in pin so something else can be muxed in
> + *	instead
> + * @pin: the pin to free
> + */
> +static void pin_free(struct pinctrl_dev *pctldev, int pin)
> +{
> +	const struct pinmux_ops *ops = pctldev->desc->pmxops;
> +	struct pin_desc *desc;
> +
> +	desc = pin_desc_get(pctldev, pin);
> +	if (desc == NULL) {
> +		pr_err("pin is not registered so it cannot be freed\n");
> +		return;
> +	}
> +
> +	if (ops->free)
> +		ops->free(pctldev, pin);
> +
> +	desc->mux_requested = false;
> +	desc->mux_function[0] = '\0';
> +	module_put(pctldev->owner);
> +}
> +
> +/**
> + * pinmux_request_gpio() - request a single pin to be muxed in to be used
> + *	as a GPIO pin
> + * @gpio: the GPIO pin number from the GPIO subsystem number space
> + */
> +int pinmux_request_gpio(unsigned gpio)
> +{
> +	char gpiostr[16];
> +	struct pinctrl_dev *pctldev;
> +	int pin;
> +
> +	pctldev = pinctrl_get_device_for_gpio(gpio);
> +	if (!pctldev)
> +		return -EINVAL;
> +
> +	/* Convert to the pin controllers number space */
> +	pin = gpio - pctldev->desc->gpio_base;
> +
> +	snprintf(gpiostr, 15, "gpio%d", gpio);
> +	return pin_request(pctldev, pin, gpiostr, true);
> +}
> +EXPORT_SYMBOL_GPL(pinmux_request_gpio);
> +
> +/**
> + * pinmux_free_gpio() - free a single pin, currently muxed in to be used
> + *	as a GPIO pin
> + * @gpio: the GPIO pin number from the GPIO subsystem number space
> + */
> +void pinmux_free_gpio(unsigned gpio)
> +{
> +	struct pinctrl_dev *pctldev;
> +	int pin;
> +
> +	pctldev = pinctrl_get_device_for_gpio(gpio);
> +	if (!pctldev)
> +		return;
> +
> +	/* Convert to the pin controllers number space */
> +	pin = gpio - pctldev->desc->gpio_base;
> +
> +	pin_free(pctldev, pin);
> +}
> +EXPORT_SYMBOL_GPL(pinmux_free_gpio);
> +
> +int pinmux_register_mappings(struct pinmux_map const *maps, unsigned num_maps)
> +{
> +	int ret = 0;
> +	int i;
> +
> +	pr_debug("add %d functions\n", num_maps);
> +	for (i = 0; i < num_maps; i++) {
> +		struct pinmux *pmx;
> +
> +		/* Sanity check the mapping */
> +		if (!maps[i].function) {
> +			pr_err("failed to register map %d - no function ID given\n", i);
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +		if (!maps[i].dev && !maps[i].dev_name) {
> +			pr_err("failed to register map %d - no device or device name given\n", i);
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		/*
> +		 * create the state cookie holder struct pinmux for each
> +		 * mapping, this is what consumers will get when requesting
> +		 * a pinmux handle with pinmux_get()
> +		 */
> +		pmx = kzalloc(sizeof(struct pinmux), GFP_KERNEL);
> +		if (pmx == NULL) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +		mutex_init(&pmx->mutex);
> +		pmx->map = &maps[i];
> +
> +		/* Add the pinmux */
> +		mutex_lock(&pinmux_list_mutex);
> +		list_add(&pmx->node, &pinmux_list);
> +		mutex_unlock(&pinmux_list_mutex);
> +		pr_debug("add function %s\n", maps[i].function);
> +	}
> +
> +out:
> +	return ret;
> +}
> +
> +/**
> + * acquire_pins() - acquire all the pins for a certain funcion on a certain
> + *	pinmux device
> + * @pctldev: the device to take the pins on
> + * @selector: the selector to acquire the pins for
> + */
> +static int acquire_pins(struct pinctrl_dev *pctldev, unsigned selector)
> +{
> +	const struct pinmux_ops *ops = pctldev->desc->pmxops;
> +	unsigned *pins;
> +	unsigned num_pins;
> +	const char *func = ops->get_function_name(pctldev, selector);
> +	int ret;
> +	int i;
> +
> +	ret = ops->get_function_pins(pctldev, selector, &pins, &num_pins);
> +	if (ret)
> +		return ret;
> +
> +	/* Try to allocate all pins in this pinmux map, one by one */
> +	for (i = 0; i < num_pins; i++) {
> +		ret = pin_request(pctldev, pins[i], func, false);
> +		if (ret) {
> +			pr_err("could not get pin %d for function %s "
> +			       "on device %s - conflicting mux mappings?\n",
> +			       pins[i], func ? : "(undefined)",
> +			       pctldev->desc->name);
> +			/* On error release all taken pins */
> +			i--; /* this pin just failed */
> +			for (; i >= 0; i--)
> +				pin_free(pctldev, pins[i]);
> +			return -ENODEV;

-EBUSY might be a better return here?

> +		}
> +	}
> +	return 0;
> +}
> +
> +/**
> + * release_pins() - release pins taken by earlier acquirement
> + * @pctldev: the device to free the pinx on
> + * @selector: the selector to free the pins for
> + */
> +static void release_pins(struct pinctrl_dev *pctldev, unsigned selector)
> +{
> +	const struct pinmux_ops *ops = pctldev->desc->pmxops;
> +	unsigned *pins;
> +	unsigned num_pins;
> +	int ret;
> +	int i;
> +
> +	ret = ops->get_function_pins(pctldev, selector, &pins, &num_pins);
> +	if (ret) {
> +		dev_err(&pctldev->dev, "could not get pins for selector %d\n",
> +			selector);
> +		return;
> +	}
> +	for (i = 0; i < num_pins; i++)
> +		pin_free(pctldev, pins[i]);
> +}
> +
> +/**
> + * pinmux_get() - retrieves the pinmux for a certain device
> + * @dev: the device to get the pinmux for
> + * @func: an optional mux name or NULL, the name is only needed
> + *	if a single device has multiple pinmux settings (i.e. if the
> + *	same device can be muxed out on different sets of pins) or if
> + *	you need an anonymous pinmux (not tied to any specific device)
> + */
> +struct pinmux *pinmux_get(struct device *dev, const char *func)
> +{
> +	struct pinmux_map const *map = NULL;
> +	struct pinctrl_dev *pctldev = NULL;
> +	const char *devname = NULL;
> +	struct pinmux *pmx;
> +	bool found_map = false;
> +	int ret = -ENODEV;
> +
> +	/* We must have dev or ID or both */
> +	if (!dev && !func)
> +		return ERR_PTR(-EINVAL);
> +
> +	mutex_lock(&pinmux_list_mutex);
> +
> +	if (dev)
> +		devname = dev_name(dev);
> +
> +	/* Iterate over the pinmux maps to locate the right one */
> +	list_for_each_entry(pmx, &pinmux_list, node) {
> +		map = pmx->map;
> +
> +		/*
> +		 * First, try to find the pctldev given in the map
> +		 */
> +		pctldev = get_pctrldev_for_pinmux_map(map);
> +		if (!pctldev) {
> +			const char *devname = NULL;
> +
> +			if (map->ctrl_dev)
> +				devname = dev_name(map->ctrl_dev);
> +			else if (map->ctrl_dev_name)
> +				devname = map->ctrl_dev_name;
> +
> +			pr_warning("could not find a pinctrl device for pinmux "
> +				   "function %s, fishy, they shall all have one\n",
> +				   map->function);
> +			pr_warning("given pinctrl device name: %s",
> +				   devname ? devname : "UNDEFINED");
> +
> +			/* Continue to check the other mappings anyway... */
> +			continue;
> +		}
> +
> +		pr_debug("found pctldev %s to handle function %s",
> +			 dev_name(&pctldev->dev), map->function);
> +
> +		/* If an function is given, it MUST match */
> +		if ((func != NULL) && strcmp(map->function, func))
> +			continue;
> +
> +		/*
> +		 * This is for the case where no device name is given, we
> +		 * already know that the function name matches from above
> +		 * code.
> +		 */
> +		if (!map->dev_name && (func != NULL)) {
> +			found_map = true;
> +			break;
> +		}
> +
> +		/* If the mapping has a device set up it must match */
> +		if (map->dev_name &&
> +		    (!devname || !strcmp(map->dev_name, devname))) {
> +			/* MATCH! */
> +			found_map = true;
> +			break;
> +		}
> +	}
> +
> +	mutex_unlock(&pinmux_list_mutex);
> +
> +	if (!found_map) {
> +		pr_err("could not find mux map for device %s, ID %s\n",
> +		       devname ? : "(anonymous)", func ? : "(undefined)");
> +		goto out;
> +	}
> +
> +	/* Make sure that noone else is using this function mapping */
> +	mutex_lock(&pmx->mutex);
> +	if (pmx->dev) {
> +		if (pmx->dev != dev) {
> +			mutex_unlock(&pmx->mutex);
> +			pr_err("mapping already in use device %s, ID %s\n",
> +			       devname ? : "(anonymous)", func ? : "(undefined)");
> +			goto out;
> +		} else {
> +			/* We already fetched this and requested pins */
> +			mutex_unlock(&pmx->mutex);
> +			ret = 0;
> +			goto out;
> +		}
> +	}
> +	mutex_unlock(&pmx->mutex);
> +
> +	{
> +		const struct pinmux_ops *ops = pctldev->desc->pmxops;
> +		unsigned selector = 0;
> +
> +		/* See if this pctldev has this function */
> +		while (ops->list_functions(pctldev, selector) >= 0) {
> +			const char *fname = ops->get_function_name(pctldev,
> +								   selector);
> +
> +			if (!strcmp(map->function, fname)) {
> +				ret = acquire_pins(pctldev, selector);
> +				if (ret)
> +					goto out;
> +				/* Found it! */
> +				mutex_lock(&pmx->mutex);
> +				pmx->dev = dev;
> +				pmx->pctldev = pctldev;
> +				pmx->pmxdev_selector = selector;
> +				mutex_unlock(&pmx->mutex);
> +				ret = 0;
> +				goto out;
> +			}
> +			selector++;
> +		}
> +	}
> +
> +	/* We couldn't find the driver for this pinmux */
> +	ret = -ENODEV;
> +
> +out:
> +	if (ret)
> +		pmx = ERR_PTR(ret);
> +
> +	return pmx;
> +}
> +EXPORT_SYMBOL_GPL(pinmux_get);
> +
> +/**
> + * pinmux_put() - release a previously claimed pinmux
> + * @pmx: a pinmux previously claimed by pinmux_get()
> + */
> +void pinmux_put(struct pinmux *pmx)
> +{
> +	if (pmx == NULL)
> +		return;
> +	mutex_lock(&pmx->mutex);
> +	if (pmx->usecount)
> +		pr_warn("releasing pinmux with active users!\n");
> +	/* Release all pins taken on pinmux_get() */
> +	release_pins(pmx->pctldev, pmx->pmxdev_selector);
> +	pmx->dev = NULL;
> +	pmx->pctldev = NULL;
> +	pmx->pmxdev_selector = 0;
> +	mutex_unlock(&pmx->mutex);
> +}
> +EXPORT_SYMBOL_GPL(pinmux_put);
> +
> +/**
> + * pinmux_enable() - enable a certain pinmux setting
> + * @pmx: the pinmux to enable, previously claimed by pinmux_get()
> + */
> +int pinmux_enable(struct pinmux *pmx)
> +{
> +	int ret = 0;
> +
> +	if (pmx == NULL)
> +		return -EINVAL;
> +	mutex_lock(&pmx->mutex);
> +	if (pmx->usecount++ == 0) {
> +		struct pinctrl_dev *pctldev = pmx->pctldev;
> +		const struct pinmux_ops *ops = pctldev->desc->pmxops;
> +
> +		ret = ops->enable(pctldev, pmx->pmxdev_selector);
> +		if (ret)
> +			pmx->usecount--;
> +	}
> +	mutex_unlock(&pmx->mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(pinmux_enable);
> +
> +/**
> + * pinmux_disable() - disable a certain pinmux setting
> + * @pmx: the pinmux to disable, previously claimed by pinmux_get()
> + */
> +void pinmux_disable(struct pinmux *pmx)
> +{
> +	if (pmx == NULL)
> +		return;
> +
> +	mutex_lock(&pmx->mutex);
> +	if (--pmx->usecount == 0) {
> +		struct pinctrl_dev *pctldev = pmx->pctldev;
> +		const struct pinmux_ops *ops = pctldev->desc->pmxops;
> +
> +		ops->disable(pctldev, pmx->pmxdev_selector);
> +	}
> +	mutex_unlock(&pmx->mutex);
> +}
> +EXPORT_SYMBOL_GPL(pinmux_disable);
> +
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
> +}
> +EXPORT_SYMBOL_GPL(pinmux_config);
> +
> +int pinmux_check_ops(const struct pinmux_ops *ops)
> +{
> +	/* Check that we implement required operations */
> +	if (!ops->list_functions ||
> +	    !ops->get_function_name ||
> +	    !ops->enable ||
> +	    !ops->disable)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_DEBUG_FS
> +
> +/* Called from pincontrol core */
> +static int pinmux_functions_show(struct seq_file *s, void *what)
> +{
> +	struct pinctrl_dev *pctldev = s->private;
> +	const struct pinmux_ops *ops = pctldev->desc->pmxops;
> +	unsigned selector = 0;
> +
> +	while (ops->list_functions(pctldev, selector) >= 0) {
> +		unsigned *pins;
> +		unsigned num_pins;
> +		const char *func = ops->get_function_name(pctldev, selector);
> +		int ret;
> +		int i;
> +
> +		ret = ops->get_function_pins(pctldev, selector,
> +					     &pins, &num_pins);
> +
> +		if (ret)
> +			seq_printf(s, "%s [ERROR GETTING PINS]\n",
> +				   func);
> +
> +		else {
> +			seq_printf(s, "function: %s, pins = [ ", func);
> +			for (i = 0; i < num_pins; i++)
> +				seq_printf(s, "%d ", pins[i]);
> +			seq_puts(s, "]\n");
> +		}
> +
> +		selector++;
> +
> +	}
> +
> +	return 0;
> +}
> +
> +static int pinmux_maps_show(struct seq_file *s, void *what)
> +{
> +	struct pinmux *pmx;
> +	const struct pinmux_map *map;
> +
> +	seq_puts(s, "Pinmux maps:\n");
> +	list_for_each_entry(pmx, &pinmux_list, node) {
> +		map = pmx->map;
> +
> +		seq_printf(s, "map: %s -> %s\n", map->function,
> +			   pmx->dev ? dev_name(pmx->dev) : "(unassigned)");
> +	}
> +
> +	return 0;
> +}
> +
> +static int pinmux_pins_show(struct seq_file *s, void *what)
> +{
> +	struct pinctrl_dev *pctldev = s->private;
> +	unsigned pin;
> +
> +	if (pctldev == NULL) {
> +		seq_puts(s, "device is gone\n");
> +		return 0;
> +	}
> +
> +	if (pctldev->desc == NULL) {
> +		seq_puts(s, "device is lacking descriptor\n");
> +		return 0;
> +	}
> +
> +	seq_puts(s, "Pinmux settings per pin\n");
> +	seq_puts(s, "Format: pin (name): pinmuxfunction [driver specifics]\n");
> +
> +	/* The highest pin number need to be included in the loop, thus <= */
> +	for (pin = 0; pin <= pctldev->desc->maxpin; pin++) {
> +
> +		struct pin_desc *desc;
> +
> +		desc = pin_desc_get(pctldev, pin);
> +		/* Pin space may be sparse */
> +		if (desc == NULL)
> +			continue;
> +
> +		else {
> +			seq_printf(s, "pin %d (%s): %s", pin,
> +				   desc->name ? desc->name : "unnamed",
> +				   desc->mux_requested ? desc->mux_function : "(unclaimed)");
> +
> +			if (pctldev->desc->pmxops->dbg_show)
> +				pctldev->desc->pmxops->dbg_show(pctldev, s, pin);
> +		}
> +		seq_puts(s, "\n");
> +	}
> +
> +	return 0;
> +}
> +
> +static int pinmux_functions_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, pinmux_functions_show, inode->i_private);
> +}
> +
> +static int pinmux_maps_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, pinmux_maps_show, NULL);
> +}
> +
> +static int pinmux_pins_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, pinmux_pins_show, inode->i_private);
> +}
> +
> +static const struct file_operations pinmux_functions_ops = {
> +	.open		= pinmux_functions_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
> +static const struct file_operations pinmux_maps_ops = {
> +	.open		= pinmux_maps_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
> +static const struct file_operations pinmux_pins_ops = {
> +	.open		= pinmux_pins_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
> +void pinmux_init_device_debugfs(struct dentry *devroot,
> +			 struct pinctrl_dev *pctldev)
> +{
> +	debugfs_create_file("pinmux-functions", S_IFREG | S_IRUGO,
> +			    devroot, pctldev, &pinmux_functions_ops);
> +	debugfs_create_file("pinmux-pins", S_IFREG | S_IRUGO,
> +			    devroot, pctldev, &pinmux_pins_ops);
> +}
> +
> +void pinmux_init_debugfs(struct dentry *subsys_root)
> +{
> +	debugfs_create_file("pinmux-maps", S_IFREG | S_IRUGO,
> +			    subsys_root, NULL, &pinmux_maps_ops);
> +}
> +
> +#endif /* CONFIG_DEBUG_FS */
> diff --git a/drivers/pinctrl/pinmux.h b/drivers/pinctrl/pinmux.h
> new file mode 100644
> index 0000000..ab672ef
> --- /dev/null
> +++ b/drivers/pinctrl/pinmux.h
> @@ -0,0 +1,4 @@
> +int pinmux_check_ops(const struct pinmux_ops *ops);
> +void pinmux_init_device_debugfs(struct dentry *devroot,
> +				struct pinctrl_dev *pctldev);
> +void pinmux_init_debugfs(struct dentry *subsys_root);
> diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
> new file mode 100644
> index 0000000..d3523bb
> --- /dev/null
> +++ b/include/linux/pinctrl/machine.h
> @@ -0,0 +1,62 @@
> +/*
> + * Machine interface for the pinctrl subsystem.
> + *
> + * Copyright (C) 2011 ST-Ericsson SA
> + * Written on behalf of Linaro for ST-Ericsson
> + * Based on bits of regulator core, gpio core and clk core
> + *
> + * Author: Linus Walleij <linus.walleij@linaro.org>
> + *
> + * License terms: GNU General Public License (GPL) version 2
> + */
> +#ifndef __LINUX_PINMUX_MACHINE_H
> +#define __LINUX_PINMUX_MACHINE_H
> +
> +/**
> + * struct pinmux_map - boards/machines shall provide this map for devices
> + * @function: a functional name for this mapping so it can be passed down
> + *	to the driver to invoke that function and be referenced by this ID
> + *	in e.g. pinmux_get()
> + * @dev: the device using this specific mapping, may be NULL if you provide
> + *	.dev_name instead (this is more common)
> + * @dev_name: the name of the device using this specific mapping, the name
> + *	must be the same as in your struct device*
> + * @ctrl_dev: the pin control device to be used by this mapping, may be NULL
> + *	if you provide .ctrl_dev_name instead (this is more common)
> + * @ctrl_dev_name: the name of the device controlling this specific mapping,
> + *	the name must be the same as in your struct device*
> + */
> +struct pinmux_map {
> +	const char *function;
> +	struct device *dev;
> +	const char *dev_name;
> +	struct device *ctrl_dev;
> +	const char *ctrl_dev_name;
> +};
> +
> +/* Convenience macro to set a simple map from a function to a named device */
> +#define PINMUX_MAP(a, b, c) \
> +	{ .function = a, .dev_name = b, .ctrl_dev_name = c }
> +/*
> + * Convenience macro to map a function onto the primary device pinctrl device
> + * this is especially helpful on systems that have only one pin controller
> + * or need to set up a lot of mappings on the primary controller.
> + */
> +#define PINMUX_MAP_PRIMARY(a, b) \
> +	{ .function = a, .dev_name = b, .ctrl_dev_name = "pinctrl.0" }
> +
> +#ifdef CONFIG_PINMUX
> +
> +extern int pinmux_register_mappings(struct pinmux_map const *map,
> +				unsigned num_maps);
> +
> +#else
> +
> +static inline int pinmux_register_mappings(struct pinmux_map const *map,
> +					   unsigned num_maps)
> +{
> +	return 0;
> +}
> +
> +#endif /* !CONFIG_PINCTRL */
> +#endif
> diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
> new file mode 100644
> index 0000000..f7532b8
> --- /dev/null
> +++ b/include/linux/pinctrl/pinctrl.h
> @@ -0,0 +1,120 @@
> +/*
> + * Interface the pinctrl subsystem
> + *
> + * Copyright (C) 2011 ST-Ericsson SA
> + * Written on behalf of Linaro for ST-Ericsson
> + * This interface is used in the core to keep track of pins.
> + *
> + * Author: Linus Walleij <linus.walleij@linaro.org>
> + *
> + * License terms: GNU General Public License (GPL) version 2
> + */
> +#ifndef __LINUX_PINCTRL_PINCTRL_H
> +#define __LINUX_PINCTRL_PINCTRL_H
> +
> +#ifdef CONFIG_PINCTRL
> +
> +#include <linux/radix-tree.h>
> +#include <linux/spinlock.h>
> +
> +struct pinmux_ops;
> +
> +/**
> + * struct pinctrl_pin_desc - boards/machines provide information on their
> + * pins, pads or other muxable units in this struct
> + * @number: unique pin number from the global pin number space
> + * @name: a name for this pin
> + */
> +struct pinctrl_pin_desc {
> +	unsigned number;
> +	const char *name;
> +};
> +
> +/* Convenience macro to define a single named or anonymous pin descriptor */
> +#define PINCTRL_PIN(a, b) { .number = a, .name = b }
> +#define PINCTRL_PIN_ANON(a) { .number = a }
> +
> +/**
> + * struct pinctrl_desc - pin controller descriptor, register this to pin
> + * control subsystem
> + * @name: name for the pin controller
> + * @pins: an array of pin descriptors describing all the pins handled by
> + *	this pin controller
> + * @npins: number of descriptors in the array, usually just ARRAY_SIZE()
> + *	of the pins field above
> + * @maxpin: since pin spaces may be sparse, there can he "holes" in the
> + *	pin range, this attribute gives the maximum pin number in the
> + *	total range. This should not be lower than npins for example,
> + *	but may be equal to npins if you have no holes in the pin range.
> + * @pmxops: pinmux operation vtable, if you support pinmuxing in your driver
> + * @gpio_base: the base offset of the pin range in the GPIO subsystem that
> + *	is handled by this controller, if applicable. This member is only
> + *	relevant if you want to e.g. control pins from the GPIO subsystem.
> + * @gpio_pins: the number of pins from (and including) the gpio_base offset
> + *	handled by this pin controller.
> + * @owner: module providing the pin controller, used for refcounting
> + */
> +struct pinctrl_desc {
> +	const char *name;
> +	struct pinctrl_pin_desc const *pins;
> +	unsigned int npins;
> +	unsigned int maxpin;
> +	struct pinmux_ops *pmxops;
> +	unsigned int gpio_base;
> +	unsigned int gpio_pins;
> +	struct module *owner;

Would it be better to put the owner in the ops structure like file_ops?  
I'm sure I remember someone saying that it's better to do that so that 
it's in the modules .data/.rodata section but I can't find that 
reference.

> +};
> +
> +/**
> + * struct pinctrl_dev - pin control class device
> + * @desc: the pin controller descriptor supplied when initializing this pin
> + *	controller
> + * @node: node to include this pin controller in the global pin controller list
> + * @dev: the device entry for this pin controller
> + * @owner: module providing the pin controller, used for refcounting
> + * @driver_data: driver data for drivers registering to the pin controller
> + *	subsystem
> + *
> + * This should be dereferenced and used by the pin controller core ONLY
> + */
> +struct pinctrl_dev {
> +	struct pinctrl_desc *desc;
> +	struct radix_tree_root pin_desc_tree;
> +	spinlock_t pin_desc_tree_lock;
> +	struct list_head node;
> +	struct device dev;
> +	struct module *owner;
> +	void *driver_data;

Couldn't the struct device driver_data be used here?

> +};
> +
> +/* These should only be used from drives */

s/drives/drivers?

> +static inline const char *pctldev_get_name(struct pinctrl_dev *pctldev)
> +{
> +	/* We're not allowed to register devices without name */
> +	return pctldev->desc->name;
> +}
> +
> +static inline void *pctldev_get_drvdata(struct pinctrl_dev *pctldev)
> +{
> +	return pctldev->driver_data;
> +}
> +
> +/* External interface to pin controller */
> +extern struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
> +				struct device *dev, void *driver_data);
> +extern void pinctrl_unregister(struct pinctrl_dev *pctldev);
> +extern bool pin_is_valid(struct pinctrl_dev *pctldev, int pin);
> +
> +#else
> +
> +struct pinctrl_dev;
> +
> +/* Sufficiently stupid default function when pinctrl is not in use */
> +static inline bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
> +{
> +	return pin >= 0;
> +}
> +
> +#endif /* !CONFIG_PINCTRL */
> +
> +#endif /* __LINUX_PINCTRL_PINCTRL_H */
> diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
> new file mode 100644
> index 0000000..582409b
> --- /dev/null
> +++ b/include/linux/pinctrl/pinmux.h
> @@ -0,0 +1,122 @@
> +/*
> + * Interface the pinmux subsystem
> + *
> + * Copyright (C) 2011 ST-Ericsson SA
> + * Written on behalf of Linaro for ST-Ericsson
> + * Based on bits of regulator core, gpio core and clk core
> + *
> + * Author: Linus Walleij <linus.walleij@linaro.org>
> + *
> + * License terms: GNU General Public License (GPL) version 2
> + */
> +#ifndef __LINUX_PINCTRL_PINMUX_H
> +#define __LINUX_PINCTRL_PINMUX_H
> +
> +#include <linux/list.h>
> +#include <linux/seq_file.h>
> +#include "pinctrl.h"
> +
> +/* This struct is private to the core and should be regarded as a cookie */
> +struct pinmux;
> +
> +#ifdef CONFIG_PINMUX
> +
> +struct pinctrl_dev;
> +
> +/**
> + * struct pinmux_ops - pinmux operations, to be implemented by pin controller
> + * drivers that support pinmuxing
> + * @request: called by the core to see if a certain pin can be made available
> + *	available for muxing. This is called by the core to acquire the pins
> + *	before selecting any actual mux setting across a function. The driver
> + *	is allowed to answer "no" by returning a negative error code
> + * @free: the reverse function of the request() callback, frees a pin after
> + *	being requested

So is the request like gpio_request() or just test if it the pin is 
available?  If its the latter then perhaps pin_is_available() might be a 
better name?

> + * @list_functions: list the number of selectable named functions available
> + *	in this pinmux driver, the core will begin on 0 and call this
> + *	repeatedly as long as it returns >= 0 to enumerate mux settings
> + * @get_function_name: return the function name of the muxing selector,
> + *	called by the core to figure out which mux setting it shall map a
> + *	certain device to
> + * @get_function_pins: return an array of pins corresponding to a certain
> + *	function selector in @pins, and the size of the array in @num_pins
> + * @enable: enable a certain muxing enumerator. The driver does not need to
> + *	figure out whether enabling this function conflicts some other use
> + *	of the pins, such collisions are handled by the pinmux subsystem
> + * @disable: disable a certain muxing enumerator
> + * @config: custom configuration function for a certain muxing enumerator -
> + *	this works a bit like an ioctl() and can pass in and return arbitrary
> + *	configuration data to the pinmux
> + * @gpio_request_enable: requests and enables GPIO on a certain pin.
> + *	Implement this only if you can mux every pin individually as GPIO. If
> + *	your gpio assignments are grouped, so you cannot control the GPIO
> + *	muxing of every indvidual pin.
> + * @dbg_show: optional debugfs display hook that will provide per-device
> + *	info for a certain pin in debugfs
> + */
> +struct pinmux_ops {
> +	int (*request) (struct pinctrl_dev *pctldev, unsigned offset);
> +	int (*free) (struct pinctrl_dev *pctldev, unsigned offset);
> +	int (*list_functions) (struct pinctrl_dev *pctldev, unsigned selector);
> +	const char *(*get_function_name) (struct pinctrl_dev *pctldev,
> +					  unsigned selector);
> +	int (*get_function_pins) (struct pinctrl_dev *pctldev,
> +				  unsigned selector, unsigned ** const pins,
> +				  unsigned * const num_pins);
> +	int (*enable) (struct pinctrl_dev *pctldev, unsigned selector);
> +	void (*disable) (struct pinctrl_dev *pctldev, unsigned selector);
> +	int (*config) (struct pinctrl_dev *pctldev, unsigned selector,
> +		       u16 param, unsigned long *data);
> +	int (*gpio_request_enable) (struct pinctrl_dev *pctldev,
> +				    unsigned offset);
> +	void (*dbg_show) (struct pinctrl_dev *pctldev, struct seq_file *s,
> +			  unsigned offset);
> +};
> +
> +/* External interface to pinmux */
> +extern int pinmux_request_gpio(unsigned gpio);
> +extern void pinmux_free_gpio(unsigned gpio);
> +extern struct pinmux *pinmux_get(struct device *dev, const char *func);
> +extern void pinmux_put(struct pinmux *pmx);
> +extern int pinmux_enable(struct pinmux *pmx);
> +extern void pinmux_disable(struct pinmux *pmx);
> +extern int pinmux_config(struct pinmux *pmx, u16 param, unsigned long *data);
> +
> +#else /* !CONFIG_PINMUX */
> +
> +static inline int pinmux_request_gpio(unsigned gpio)
> +{
> +	return 0;
> +}
> +
> +static inline void pinmux_free_gpio(unsigned gpio)
> +{
> +}
> +
> +static inline struct pinmux *pinmux_get(struct device *dev, const char *func)
> +{
> +	return NULL;
> +}

The CONFIG_PINMUX=y version of pinmux_get returns an ERR_PTR() encoded 
error so perhaps this should return something like ERR_PTR(-ENXIO)?

> +
> +static inline void pinmux_put(struct pinmux *pmx)
> +{
> +}
> +
> +static inline int pinmux_enable(struct pinmux *pmx)
> +{
> +	return 0;
> +}
> +
> +static inline void pinmux_disable(struct pinmux *pmx)
> +{
> +}
> +
> +static inline int pinmux_config(struct pinmux *pmx, u16 param,
> +				unsigned long *data)
> +{
> +	return 0;
> +}
> +
> +#endif /* CONFIG_PINMUX */
> +
> +#endif /* __LINUX_PINCTRL_PINMUX_H */
> -- 
> 1.7.3.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
