Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab1LOBBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 20:01:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755008Ab1LOBBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 20:01:53 -0500
Date: Wed, 14 Dec 2011 17:01:08 -0800
From: Greg KH <gregkh@suse.de>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        MyungJoo Ham <myungjoo.ham@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, NeilBrown <neilb@suse.de>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2 1/3] Extcon (external connector): import Android's
 switch class and modify.
Message-ID: <20111215010108.GA15650@suse.de>
References: <1323858508-27198-1-git-send-email-myungjoo.ham@samsung.com>
 <1323858508-27198-2-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1323858508-27198-2-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 07:28:26PM +0900, MyungJoo Ham wrote:
> External connector class (extcon) is based on and an extension of Android
> kernel's switch class located at linux/drivers/switch/.
> This patch provides the before-extension switch class moved to the
> location where the extcon will be located (linux/drivers/extcon/).
> 
> The before-extension class, switch class of Android kernel, commits
> imported are:
> 
> switch: switch class and GPIO drivers.
> Author: Mike Lockwood <lockwood@android.com>
> 
> switch: gpio: Don't call request_irq with interrupts disabled
> Author: Arve Hjønnevåg <arve@android.com>
> 
> switch: Use device_create instead of device_create_drvdata.
> Author: Arve Hjønnevåg <arve@android.com>
> 
> switch_gpio: Add missing #include <linux/interrupt.h>
> Author: Mike Lockwood <lockwood@android.com>
> 
> In this patch, upon the commits of Android kernel, we have added:
> - Relocated and renamed for extcon.
> - Comments, module name, and author information are updated
> - Code clean for successing patches
> - Bugfix: enabling write access without write functions

Nice, but if we accept this, will someone also make the needed changes
to the Android userspace code to handle the user api changes that this
causes?

> --- /dev/null
> +++ b/drivers/extcon/Kconfig
> @@ -0,0 +1,22 @@
> +menuconfig EXTCON
> +	bool "External Connector Class (extcon) support"

Why can't this be a module?

> +	help
> +	  Say Y here to enable external connector class (extcon) support.
> +	  This allows monitoring external connectors by userspace
> +	  via sysfs and uevent and supports external connectors with
> +	  multiple states; i.e., an extcon that may have multiple
> +	  cables attached. For example, an external connector of a device
> +	  may be used to connect an HDMI cable and a AC adaptor, and to
> +	  host USB ports. Many of 30-pin connectors including PDMI are
> +	  also good examples.
> +
> +if EXTCON
> +
> +config EXTCON_GPIO
> +	tristate "GPIO extcon support"
> +	depends on GENERIC_GPIO
> +	help
> +	  Say Y here to enable GPIO based extcon support. Note that GPIO
> +	  extcon supports single state per extcon instance.
> +
> +endif # MULTISTATE_SWITCH
> diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
> new file mode 100644
> index 0000000..2c46d41
> --- /dev/null
> +++ b/drivers/extcon/Makefile
> @@ -0,0 +1,6 @@
> +#
> +# Makefile for external connector class (extcon) devices
> +#
> +
> +obj-$(CONFIG_EXTCON)		+= extcon_class.o
> +obj-$(CONFIG_EXTCON_GPIO)	+= extcon_gpio.o
> diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
> new file mode 100644
> index 0000000..39fbe9f
> --- /dev/null
> +++ b/drivers/extcon/extcon_class.c
> @@ -0,0 +1,206 @@
> +/*
> + *  drivers/extcon/extcon_class.c
> + *
> + *  External connector (extcon) class driver
> + *
> + * Copyright (C) 2011 Samsung Electronics
> + * Author: Donggeun Kim <dg77.kim@samsung.com>
> + * Author: MyungJoo Ham <myungjoo.ham@samsung.com>
> + *
> + * based on android/drivers/switch/switch_class.c
> + * Copyright (C) 2008 Google, Inc.
> + * Author: Mike Lockwood <lockwood@android.com>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> +*/
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/init.h>
> +#include <linux/device.h>
> +#include <linux/fs.h>
> +#include <linux/err.h>
> +#include <linux/extcon.h>
> +
> +struct class *extcon_class;
> +static atomic_t device_count;

this should use the idr subsystem, not just an atomic variable, as you
aren't properly handling devices being removed (which is something
overall this core code needs to properly handle.)


> +
> +static ssize_t state_show(struct device *dev, struct device_attribute *attr,
> +		char *buf)
> +{
> +	struct extcon_dev *edev = (struct extcon_dev *)
> +		dev_get_drvdata(dev);
> +
> +	if (edev->print_state) {
> +		int ret = edev->print_state(edev, buf);
> +
> +		if (ret >= 0)
> +			return ret;
> +		/* Use default if failed */
> +	}
> +	return sprintf(buf, "%u\n", edev->state);
> +}
> +
> +static ssize_t name_show(struct device *dev, struct device_attribute *attr,
> +		char *buf)
> +{
> +	struct extcon_dev *edev = (struct extcon_dev *)
> +		dev_get_drvdata(dev);
> +
> +	if (edev->print_name) {
> +		int ret = edev->print_name(edev, buf);
> +		if (ret >= 0)
> +			return ret;
> +	}
> +	return sprintf(buf, "%s\n", edev->name);
> +}

Why is the name somehow different from the device name in the first
place?

> +/**
> + * extcon_set_state() - Set the cable attach states of the extcon device.
> + * @edev:	the extcon device
> + * @state:	new cable attach status for @edev
> + */
> +void extcon_set_state(struct extcon_dev *edev, u32 state)
> +{
> +	char name_buf[120];
> +	char state_buf[120];
> +	char *prop_buf;
> +	char *envp[3];
> +	int env_offset = 0;
> +	int length;
> +
> +	if (edev->state != state) {
> +		edev->state = state;
> +
> +		prop_buf = (char *)get_zeroed_page(GFP_KERNEL);
> +		if (prop_buf) {
> +			length = name_show(edev->dev, NULL, prop_buf);

Heh, nice hack, but wouldn't it just be simpler to call the
evdev->print_name() function directly here?

> +			if (length > 0) {
> +				if (prop_buf[length - 1] == '\n')
> +					prop_buf[length - 1] = 0;
> +				snprintf(name_buf, sizeof(name_buf),
> +					"SWITCH_NAME=%s", prop_buf);
> +				envp[env_offset++] = name_buf;
> +			}
> +			length = state_show(edev->dev, NULL, prop_buf);

Same here.

> +			if (length > 0) {
> +				if (prop_buf[length - 1] == '\n')
> +					prop_buf[length - 1] = 0;
> +				snprintf(state_buf, sizeof(state_buf),
> +					"SWITCH_STATE=%s", prop_buf);
> +				envp[env_offset++] = state_buf;
> +			}
> +			envp[env_offset] = NULL;
> +			kobject_uevent_env(&edev->dev->kobj, KOBJ_CHANGE, envp);
> +			free_page((unsigned long)prop_buf);
> +		} else {
> +			printk(KERN_ERR "out of memory in extcon_set_state\n");

dev_err()?

> +			kobject_uevent(&edev->dev->kobj, KOBJ_CHANGE);

I really dislike using uevents, what is listening for them?  Are you
hooked into udev's event chain in userspace to properly handle this?  If
not, what is the point of sending them?

> +		}
> +	}
> +}
> +EXPORT_SYMBOL_GPL(extcon_set_state);
> +
> +static int create_extcon_class(void)
> +{
> +	if (!extcon_class) {
> +		extcon_class = class_create(THIS_MODULE, "extcon");
> +		if (IS_ERR(extcon_class))
> +			return PTR_ERR(extcon_class);
> +		atomic_set(&device_count, 0);
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * extcon_dev_register() - Register a new extcon device
> + * @edev	: the new extcon device (should be allocated before calling)
> + *
> + * Among the members of edev struct, please set the "user initializing data"
> + * in any case and set the "optional callbacks" if required. However, please
> + * do not set the values of "internal data", which are initialized by
> + * this function.
> + */
> +int extcon_dev_register(struct extcon_dev *edev)
> +{
> +	int ret;
> +
> +	if (!extcon_class) {
> +		ret = create_extcon_class();
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	edev->index = atomic_inc_return(&device_count);
> +	edev->dev = device_create(extcon_class, NULL,
> +		MKDEV(0, edev->index), NULL, edev->name);
> +	if (IS_ERR(edev->dev))
> +		return PTR_ERR(edev->dev);
> +
> +	ret = device_create_file(edev->dev, &dev_attr_state);
> +	if (ret < 0)
> +		goto err_create_file_1;
> +	ret = device_create_file(edev->dev, &dev_attr_name);
> +	if (ret < 0)
> +		goto err_create_file_2;

Why not use default attributes for the class?  That makes this code go
away, and solves the error handling issues as well.

> +
> +	dev_set_drvdata(edev->dev, edev);
> +	edev->state = 0;
> +	return 0;
> +
> +err_create_file_2:
> +	device_remove_file(edev->dev, &dev_attr_state);
> +err_create_file_1:
> +	device_destroy(extcon_class, MKDEV(0, edev->index));
> +	printk(KERN_ERR "extcon: Failed to register driver %s\n", edev->name);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(extcon_dev_register);
> +
> +/**
> + * extcon_dev_unregister() - Unregister the extcon device.
> + * @edev:	the extcon device instance to be unregitered.
> + *
> + * Note that this does not call kfree(edev) because edev was not allocated
> + * by this class.
> + */
> +void extcon_dev_unregister(struct extcon_dev *edev)
> +{
> +	device_remove_file(edev->dev, &dev_attr_name);
> +	device_remove_file(edev->dev, &dev_attr_state);
> +	device_destroy(extcon_class, MKDEV(0, edev->index));
> +	dev_set_drvdata(edev->dev, NULL);
> +}
> +EXPORT_SYMBOL_GPL(extcon_dev_unregister);

As stated before, you forgot to decrement the count, but use the idr
subsystem and remember to decrement it here also.

thanks,

greg k-h
