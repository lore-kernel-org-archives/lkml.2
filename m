Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab1JMDSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 23:18:25 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36325 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab1JMDSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 23:18:23 -0400
Date: Wed, 12 Oct 2011 21:18:19 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>, Barry Song <21cnbao@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stijn Devriendt <highguy@gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pin control subsystem v9
Message-ID: <20111013031819.GA15829@ponder.secretlab.ca>
References: <1317629862-13549-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317629862-13549-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 10:17:42AM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This creates a subsystem for handling of pin control devices.
> These are devices that control different aspects of package
> pins.
> 
> Currently it handles pinmuxing, i.e. assigning electronic
> functions to groups of pins on primarily PGA and BGA type of
> chip packages which are common in embedded systems.
> 
> The plan is to also handle other I/O pin control aspects
> such as biasing, driving, input properties such as
> schmitt-triggering, load capacitance etc within this
> subsystem, to remove a lot of ARM arch code as well as
> feature-creepy GPIO drivers which are implementing the same
> thing over and over again.
> 
> This is being done to depopulate the arch/arm/* directory
> of such custom drivers and try to abstract the infrastructure
> they all need. See the Documentation/pinctrl.txt file that is
> part of this patch for more details.
> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Stijn Devriendt <highguy@gmail.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Acked-by: Stephen Warren <swarren@nvidia.com>
> Tested-by: Barry Song <21cnbao@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v8->v9:
> 
> - Drop the bus_type and the sysfs attributes and all, we're not on
>   the clear about how this should be used for e.g. userspace
>   interfaces so let us save this for the future.
> 
> - Use the right name in MAINTAINERS, PIN CONTROL rather than
>   PINMUX
> 
> - Don't kfree() the device state holder, let the .remove() callback
>   handle this.
> 
> - Fix up numerous kerneldoc headers to have one line for the function
>   description and more verbose documentation below the parameters

Nit: put the changelog above the s-o-b lines so it will appear in the
linux commit log.

> ---
>  Documentation/pinctrl.txt       |  951 +++++++++++++++++++++++++++++++
>  MAINTAINERS                     |    5 +
>  drivers/Kconfig                 |    4 +
>  drivers/Makefile                |    2 +
>  drivers/pinctrl/Kconfig         |   29 +
>  drivers/pinctrl/Makefile        |    6 +
>  drivers/pinctrl/core.c          |  602 ++++++++++++++++++++
>  drivers/pinctrl/core.h          |   73 +++
>  drivers/pinctrl/pinmux.c        | 1179 +++++++++++++++++++++++++++++++++++++++
>  drivers/pinctrl/pinmux.h        |   47 ++
>  include/linux/pinctrl/machine.h |  107 ++++
>  include/linux/pinctrl/pinctrl.h |  133 +++++
>  include/linux/pinctrl/pinmux.h  |  117 ++++
>  13 files changed, 3255 insertions(+), 0 deletions(-)
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
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> new file mode 100644
> index 0000000..2915fea
> --- /dev/null
> +++ b/Documentation/pinctrl.txt
> @@ -0,0 +1,951 @@
[...]
> +The pin control subsystem will call the .list_groups() function repeatedly
> +beginning on 0 until it returns non-zero to determine legal selectors, then
> +it will call the other functions to retrieve the name and pins of the group.
> +Maintaining the data structure of the groups is up to the driver, this is
> +just a simple example - in practice you may need more entries in your group
> +structure, for example specific register ranges associated with each group
> +and so on.
> +
> +
> +Interaction with the GPIO subsystem
> +===================================
> +
> +The GPIO drivers may want to perform operations of various types on the same
> +physical pins that are also registered as GPIO pins.

...also registered as PINMUX pins?

> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 95b9e7e..40d3e16 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -56,6 +56,10 @@ source "drivers/pps/Kconfig"
>  
>  source "drivers/ptp/Kconfig"
>  
> +# pinctrl before gpio - gpio drivers may need it

This shouldn't actually be an ordering constraint.  It might be a
temporary restriction on the Makefiles, but it isn't at all for Kconfig.

> +
> +source "drivers/pinctrl/Kconfig"
> +
>  source "drivers/gpio/Kconfig"
>  
>  source "drivers/w1/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 7fa433a..e7afb3a 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -5,6 +5,8 @@
>  # Rewritten to use lists instead of if-statements.
>  #
>  
> +# GPIO must come after pinctrl as gpios may need to mux pins etc
> +obj-y				+= pinctrl/
>  obj-y				+= gpio/
>  obj-$(CONFIG_PCI)		+= pci/
>  obj-$(CONFIG_PARISC)		+= parisc/
> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> new file mode 100644
> index 0000000..7fa0fe0
> --- /dev/null
> +++ b/drivers/pinctrl/Kconfig
> @@ -0,0 +1,29 @@
> +#
> +# PINCTRL infrastructure and drivers
> +#
> +
> +menuconfig PINCTRL
> +	bool "PINCTRL Support"
> +	depends on SYSFS && EXPERIMENTAL

Why depends on SYSFS?  That shouldn't be a consideration at all.

> +	help
> +	  This enables the PINCTRL subsystem for controlling pins
> +	  on chip packages, for example multiplexing pins on primarily
> +	  PGA and BGA packages for systems on chip.
> +
> +	  If unsure, say N.
> +
> +if PINCTRL
> +
> +config PINMUX
> +	bool "Support pinmux controllers"
> +	help
> +	  Say Y here if you want the pincontrol subsystem to handle pin
> +	  multiplexing drivers.
> +
> +config DEBUG_PINCTRL
> +	bool "Debug PINCTRL calls"
> +	depends on DEBUG_KERNEL
> +	help
> +	  Say Y here to add some extra checks and diagnostics to PINCTRL calls.
> +
> +endif
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
> index 0000000..ff0c68c
> --- /dev/null
> +++ b/drivers/pinctrl/core.c
> @@ -0,0 +1,602 @@
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
> +static void pinctrl_dev_release(struct device *dev)
> +{
> +	struct pinctrl_dev *pctldev = dev_get_drvdata(dev);
> +	kfree(pctldev);
> +}
> +
> +const char *pctldev_get_name(struct pinctrl_dev *pctldev)
> +{
> +	/* We're not allowed to register devices without name */
> +	return pctldev->desc->name;
> +}
> +EXPORT_SYMBOL_GPL(pctldev_get_name);
> +
> +void *pctldev_get_drvdata(struct pinctrl_dev *pctldev)
> +{
> +	return pctldev->driver_data;
> +}
> +EXPORT_SYMBOL_GPL(pctldev_get_drvdata);
> +
> +/**
> + * get_pctldev_from_dev() - look up pin controller device

Naming abbreviation is a little agressive.  Please use pinctrl
everywhere instead of a mix between pctl and pinctrl.

> + * @dev: a device pointer, this may be NULL but then devname needs to be
> + *	defined instead
> + * @devname: the name of a device instance, as returned by dev_name(), this
> + *	may be NULL but then dev needs to be defined instead
> + *
> + * Looks up a pin control device matching a certain device name or pure device
> + * pointer, the pure device pointer will take precedence.
> + */
> +struct pinctrl_dev *get_pctldev_from_dev(struct device *dev,
> +					 const char *devname)
> +{
> +	struct pinctrl_dev *pctldev = NULL;
> +	bool found = false;
> +
> +	mutex_lock(&pinctrldev_list_mutex);
> +	list_for_each_entry(pctldev, &pinctrldev_list, node) {
> +		if (dev &&  &pctldev->dev == dev) {
> +			/* Matched on device pointer */
> +			found = true;
> +			break;
> +		}
> +
> +		if (devname &&
> +		    !strcmp(dev_name(&pctldev->dev), devname)) {
> +			/* Matched on device name */
> +			found = true;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&pinctrldev_list_mutex);
> +
> +	if (found)
> +		return pctldev;
> +
> +	return NULL;

or simply:

	return found ? pctldev : NULL;

> +/**
> + * pinctrl_get_device_gpio_range() - find device for GPIO range
> + * @gpio: the pin to locate the pin controller for
> + * @outdev: the pin control device if found
> + * @outrange: the GPIO range if found
> + *
> + * Find the pin controller handling a certain GPIO pin from the pinspace of
> + * the GPIO subsystem, return the device and the matching GPIO range. Returns
> + * negative if the GPIO range could not be found in any device.
> + */
> +int pinctrl_get_device_gpio_range(unsigned gpio,
> +				struct pinctrl_dev **outdev,
> +				struct pinctrl_gpio_range **outrange)
> +{
> +	struct pinctrl_dev *pctldev = NULL;
> +
> +	/* Loop over the pin controllers */
> +	mutex_lock(&pinctrldev_list_mutex);
> +	list_for_each_entry(pctldev, &pinctrldev_list, node) {
> +		struct pinctrl_gpio_range *range;
> +
> +		range = pinctrl_match_gpio_range(pctldev, gpio);
> +		if (range != NULL) {
> +			*outdev = pctldev;
> +			*outrange = range;
> +			return 0;

Neglected to drop mutex

> +		}
> +	}
> +	mutex_unlock(&pinctrldev_list_mutex);
> +
> +	return -EINVAL;
> +}
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

I urge you to consider carefully before relying on the ERR_PTR()
pattern.  It isn't easy to for a compiler or a human to check if
ERR_PTR values are being handled properly, and is therefore a likely
source of bugs.  Unless it is *absolutely critical* to return an error
code instead of NULL on error, I strongly recommend returning NULL
from this function on failure.

>From what I see from this function, the error codes are less useful
that using pr_err() calls.

> +	if (pctldesc->name == NULL)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* If we're implementing pinmuxing, check the ops for sanity */
> +	if (pctldesc->pmxops) {
> +		ret = pinmux_check_ops(pctldesc->pmxops);
> +		if (ret) {
> +			pr_err("%s pinmux ops lacks necessary functions\n",
> +			       pctldesc->name);
> +			return ERR_PTR(ret);
> +		}
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
> +	mutex_init(&pctldev->gpio_ranges_lock);
> +
> +	/* Register device */
> +	pctldev->dev.parent = dev;
> +	dev_set_name(&pctldev->dev, "pinctrl.%d",
> +		     atomic_inc_return(&pinmux_no) - 1);
> +	pctldev->dev.release = pinctrl_dev_release;
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
> +	pinmux_hog_maps(pctldev);
> +	return pctldev;
> +
> +out_err:
> +	put_device(&pctldev->dev);
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(pinctrl_register);
> +


I think this is pretty close to ready.  If you address the comments
I've made above then you can add my Acked-by:

Acked-by: Grant Likely <grant.likely@secretlab.ca>


