Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab2AGD0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 22:26:10 -0500
Received: from us-mx3.synaptics.com ([12.239.217.85]:43232 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759084Ab2AGD0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 22:26:07 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Fri, 06 Jan 2012 19:13:48 -0800
Message-ID: <4F07BB4D.2040004@synaptics.com>
Date: Fri, 6 Jan 2012 19:26:05 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [RFC PATCH 2/11] input: RMI4 core bus and sensor drivers.
References: <1324519802-23894-1-git-send-email-cheiny@synaptics.com> <1324519802-23894-3-git-send-email-cheiny@synaptics.com> <20120106023416.GA10062@core.coreip.homeip.net>
In-Reply-To: <20120106023416.GA10062@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2012 06:34 PM, Dmitry Torokhov wrote:
> Hi Christopher,
>
> Please find my [incomplete] comments below.

And my responses.  Most of them are just ACKing your input, but there's 
a few point of disagreement, which I've called out.

>
> On Wed, Dec 21, 2011 at 06:09:53PM -0800, Christopher Heiny wrote:
>> Signed-off-by: Christopher Heiny<cheiny@synaptics.com>
>>
>> Cc: Dmitry Torokhov<dmitry.torokhov@gmail.com>
>> Cc: Linus Walleij<linus.walleij@stericsson.com>
>> Cc: Naveen Kumar Gaddipati<naveen.gaddipati@stericsson.com>
>> Cc: Joeri de Gram<j.de.gram@gmail.com>
>>
>> ---
>>
>>   drivers/input/rmi4/rmi_bus.c    |  436 ++++++++++++
>>   drivers/input/rmi4/rmi_driver.c | 1488 +++++++++++++++++++++++++++++++++++++++
>>   drivers/input/rmi4/rmi_driver.h |   97 +++
>>   3 files changed, 2021 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/input/rmi4/rmi_bus.c b/drivers/input/rmi4/rmi_bus.c

[snip]

>> +static int rmi_bus_match(struct device *dev, struct device_driver *driver)
>> +{
>> +	struct rmi_driver *rmi_driver;
>> +	struct rmi_device *rmi_dev;
>> +	struct rmi_device_platform_data *pdata;
>> +
>> +	rmi_driver = to_rmi_driver(driver);
>> +	rmi_dev = to_rmi_device(dev);
>> +	pdata = to_rmi_platform_data(rmi_dev);
>> +	dev_dbg(dev, "Matching %s.\n", pdata->sensor_name);
>> +
>> +	if (!strcmp(pdata->driver_name, rmi_driver->driver.name)) {
>> +		rmi_dev->driver = rmi_driver;
>> +		dev_dbg(dev, "%s: Match %s to %s succeeded.\n", __func__,
>> +			pdata->driver_name, rmi_driver->driver.name);
>> +		return 1;
>> +	}
>> +
>> +	dev_err(dev, "%s: Match %s to %s failed.\n", __func__,
>> +		pdata->driver_name, rmi_driver->driver.name);
>
> Why is this an error? dev_vdbg() at most, better yet just remove it.

It's useful when helping new customers bring up the driver on their 
product.  However, dev_dbg or dev_vdbg is a better choice for 
production, so we'll change to that.

>
>> +	return 0;
>> +}
>> +
>> +#ifdef CONFIG_PM
>> +static int rmi_bus_suspend(struct device *dev)
>> +{
>> +#ifdef GENERIC_SUBSYS_PM_OPS
>> +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>> +
>> +	if (pm&&  pm->suspend)
>> +		return pm->suspend(dev);
>> +#endif
>> +
>> +	return 0;
>> +}
>> +
>> +static int rmi_bus_resume(struct device *dev)
>> +{
>> +#ifdef GENERIC_SUBSYS_PM_OPS
>> +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>> +
>> +	if (pm&&  pm->resume)
>> +		return pm->resume(dev);
>> +#endif
>> +
>> +	return 0;
>> +}
>> +#endif
>
> These are not needed if you switch to generic_subsys_pm_ops.

Unfortunately, we've got some customers on kernels that don't support 
generic_subsys_pm_ops.  We'll probably drop support for that later this 
year, but in the meantime we'd like to retain it.


[snip]

>> +int rmi_register_phys_device(struct rmi_phys_device *phys)
>> +{
>> +	struct rmi_device_platform_data *pdata = phys->dev->platform_data;
>> +	struct rmi_device *rmi_dev;
>> +
>> +	if (!pdata) {
>> +		dev_err(phys->dev, "no platform data!\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	rmi_dev = kzalloc(sizeof(struct rmi_device), GFP_KERNEL);
>> +	if (!rmi_dev)
>> +		return -ENOMEM;
>> +
>> +	rmi_dev->phys = phys;
>> +	rmi_dev->dev.bus =&rmi_bus_type;
>> +
>> +	mutex_lock(&rmi_bus_mutex);
>> +	rmi_dev->number = physical_device_count;
>> +	physical_device_count++;
>> +	mutex_unlock(&rmi_bus_mutex);
>
> Do
> 	rmi_dev->number = atomic_inc_return(&rmi_no) - 1;
>
> and  stick "static atomic_t rmi_no = ATOMIC_INIT(0)"; at the beginning
> of the function. Then you don't need to take mutex here. Do you need
> rmi_dev->number?

Yes, it's used elsewhere.  atomic_inc is a tidier way to manage this, so 
we'll switch to that.

>
>> +
>> +	dev_set_name(&rmi_dev->dev, "sensor%02d", rmi_dev->number);
>> +	pr_debug("%s: Registered %s as %s.\n", __func__, pdata->sensor_name,
>> +		dev_name(&rmi_dev->dev));
>> +
>> +	phys->rmi_dev = rmi_dev;
>> +	return device_register(&rmi_dev->dev);
>> +}
>> +EXPORT_SYMBOL(rmi_register_phys_device);
>> +
>> +void rmi_unregister_phys_device(struct rmi_phys_device *phys)
>> +{
>> +	struct rmi_device *rmi_dev = phys->rmi_dev;
>> +
>> +	device_unregister(&rmi_dev->dev);
>> +	kfree(rmi_dev);
>
> This is lifetime rules violation; rmi_dev->dev might still be referenced
> and you are freeing it. Please provide proper release function.

Agreed.  Thanks for catching this.

>
>> +}
>> +EXPORT_SYMBOL(rmi_unregister_phys_device);
>> +
>> +int rmi_register_driver(struct rmi_driver *driver)
>> +{
>> +	driver->driver.bus =&rmi_bus_type;
>> +	return driver_register(&driver->driver);
>> +}
>> +EXPORT_SYMBOL(rmi_register_driver);
>> +
>> +static int __rmi_driver_remove(struct device *dev, void *data)
>> +{
>> +	struct rmi_driver *driver = data;
>> +	struct rmi_device *rmi_dev = to_rmi_device(dev);
>> +
>> +	if (rmi_dev->driver == driver)
>> +		rmi_dev->driver = NULL;
>
> No cleanup whatsoever?

That certainly looks like a bug.

>
>> +
>> +	return 0;
>> +}
>> +
>> +void rmi_unregister_driver(struct rmi_driver *driver)
>> +{
>> +	bus_for_each_dev(&rmi_bus_type, NULL, driver, __rmi_driver_remove);
>
> Why don't you rely on driver core to unbind devices upon driver removal
> instead of rolling your own (and highly likely broken) implementation.

We'll look into that.

>
>> +	driver_unregister(&driver->driver);
>> +}
>> +EXPORT_SYMBOL(rmi_unregister_driver);
>> +
[snip]

>> +
>> +void rmi_unregister_function_driver(struct rmi_function_handler *fh)
>> +{
>> +	struct rmi_function_list *entry, *n;
>> +
>> +	/* notify devices of the removal of the function handler */
>> +	bus_for_each_dev(&rmi_bus_type, NULL, fh, __rmi_bus_fh_remove);
>> +
>> +	list_for_each_entry_safe(entry, n,&rmi_supported_functions.list,
>> +									list) {
>> +		if (entry->fh->func == fh->func) {
>> +			list_del(&entry->list);
>> +			kfree(entry);
>> +		}
>> +	}
>
> You are still rolling partly your own infrastructure. It looks like you
> need 2 types of devices on rmi bus - composite RMI device and sensor
> device, see struct device_type. Make 2 of those and match drivers
> depending on the device type. Then driver core will maintain all the
> lists for you.

Much better.  We'll look into that.

>
>> +
>> +}
>> +EXPORT_SYMBOL(rmi_unregister_function_driver);
>> +
>> +struct rmi_function_handler *rmi_get_function_handler(int id)
>> +{
>> +	struct rmi_function_list *entry;
>> +
>> +	list_for_each_entry(entry,&rmi_supported_functions.list, list)
>> +		if (entry->fh->func == id)
>> +			return entry->fh;
>> +
>> +	return NULL;
>> +}
>> +EXPORT_SYMBOL(rmi_get_function_handler);
>> +
>> +static void rmi_release_character_device(struct device *dev)
>> +{
>> +	dev_dbg(dev, "%s: Called.\n", __func__);
>> +	return;
>
> No, no, no. Do not try to shut up warnings from device core; they are
> there for a reason.

I don't think that's what this is trying to do.  But certainly it should 
be doing something other than quietly saying "here".

>
>> +}

[snip]

>> +
>> +int rmi_register_character_driver(struct rmi_char_driver *char_driver)
>> +{
>> +	struct rmi_character_driver_list *entry;
>> +	int retval;
>> +
>> +	pr_debug("%s: Registering character driver %s.\n", __func__,
>> +		char_driver->driver.name);
>> +
>> +	char_driver->driver.bus =&rmi_bus_type;
>> +	INIT_LIST_HEAD(&char_driver->devices);
>> +	retval = driver_register(&char_driver->driver);
>> +	if (retval) {
>> +		pr_err("%s: Failed to register %s, code: %d.\n", __func__,
>> +		       char_driver->driver.name, retval);
>> +		return retval;
>> +	}
>> +
>> +	entry = kzalloc(sizeof(struct rmi_character_driver_list), GFP_KERNEL);
>> +	if (!entry)
>> +		return -ENOMEM;
>> +	entry->cd = char_driver;
>> +
>> +	mutex_lock(&rmi_bus_mutex);
>> +	list_add_tail(&entry->list,&rmi_character_drivers.list);
>> +	mutex_unlock(&rmi_bus_mutex);
>> +
>> +	/* notify devices of the removal of the function handler */
>> +	bus_for_each_dev(&rmi_bus_type, NULL, char_driver,
>> +			 rmi_register_character_device);
>
> Hmm, thisi is very roundabout way of attaching RMI chardevice... Does it
> even work if driver [re]appears after rmi_dev module was loaded?
>
> IFF we agree on keeping rmi_dev interface then I think something more
> elegant could be cooked via bus's blocking notifier.

It does appear to work in that situation, at least on the bench.  We'll 
look into the blocking notifier, though - like you say, better to avoid 
re-inventing the functionality.

[snip]

>> +
>> +static int __init rmi_bus_init(void)
>> +{
>> +	int error;
>> +
>> +	mutex_init(&rmi_bus_mutex);
>> +	INIT_LIST_HEAD(&rmi_supported_functions.list);
>> +	INIT_LIST_HEAD(&rmi_character_drivers.list);
>> +
>> +	error = bus_register(&rmi_bus_type);
>> +	if (error<  0) {
>> +		pr_err("%s: error registering the RMI bus: %d\n", __func__,
>> +		       error);
>> +		return error;
>> +	}
>> +	pr_info("%s: successfully registered RMI bus.\n", __func__);
>
> This is all useless noise. Just do:
>
> 	return bus_register(&rmi_bus_type);

Not entirely useless, as it helps customers debug failures when first 
integrating the driver.  However, we'll switch pr_info to pr_debug.

>
>> +
>> +	return 0;
>> +}
>> +
>> +static void __exit rmi_bus_exit(void)
>> +{
>> +	struct rmi_function_list *entry, *n;
>> +
>> +	list_for_each_entry_safe(entry, n,&rmi_supported_functions.list,
>> +				 list) {
>> +		list_del(&entry->list);
>> +		kfree(entry);
>> +	}
>
> How can this list be non-free? Your bus code is reference by function
> drivers so module count is non zero until all such drivers are unloaded,
> and therefore rmi_bus_exit() can not be called.

Agreed.  Will address this.

>
>> +
>> +	bus_unregister(&rmi_bus_type);
>> +}
>> +
>> +module_init(rmi_bus_init);
>> +module_exit(rmi_bus_exit);
>> +
>> +MODULE_AUTHOR("Eric Andersson<eric.andersson@unixphere.com>");
>> +MODULE_DESCRIPTION("RMI bus");
>> +MODULE_LICENSE("GPL");
>> diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
>> new file mode 100644
>> index 0000000..07097bb
>> --- /dev/null
>> +++ b/drivers/input/rmi4/rmi_driver.c
>> @@ -0,0 +1,1488 @@
>> +/*
>> + * Copyright (c) 2011 Synaptics Incorporated
>> + * Copyright (c) 2011 Unixphere
>> + *
>> + * This driver adds support for generic RMI4 devices from Synpatics. It
>> + * implements the mandatory f01 RMI register and depends on the presence of
>> + * other required RMI functions.
>> + *
>> + * The RMI4 specification can be found here (URL split after files/ for
>> + * style reasons):
>> + * http://www.synaptics.com/sites/default/files/
>> + *           511-000136-01-Rev-E-RMI4%20Intrfacing%20Guide.pdf
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>> + */
>> +
>> +#include<linux/kernel.h>
>> +#include<linux/delay.h>
>> +#include<linux/device.h>
>> +#include<linux/module.h>
>> +#include<linux/device.h>
>> +#include<linux/slab.h>
>> +#include<linux/list.h>
>> +#include<linux/pm.h>
>> +#include<linux/rmi.h>
>> +#include "rmi_driver.h"
>> +
>> +#define DELAY_DEBUG 0
>> +#define REGISTER_DEBUG 0
>> +
>> +#define PDT_END_SCAN_LOCATION	0x0005
>> +#define PDT_PROPERTIES_LOCATION 0x00EF
>> +#define BSR_LOCATION 0x00FE
>> +#define HAS_BSR_MASK 0x20
>> +#define HAS_NONSTANDARD_PDT_MASK 0x40
>> +#define RMI4_END_OF_PDT(id) ((id) == 0x00 || (id) == 0xff)
>> +#define RMI4_MAX_PAGE 0xff
>> +#define RMI4_PAGE_SIZE 0x100
>> +
>> +#define RMI_DEVICE_RESET_CMD	0x01
>> +#define DEFAULT_RESET_DELAY_MS	20
>> +
>> +#ifdef CONFIG_HAS_EARLYSUSPEND
>> +static void rmi_driver_early_suspend(struct early_suspend *h);
>> +static void rmi_driver_late_resume(struct early_suspend *h);
>> +#endif
>
> Does not appear to be in mainline; please trim.

Understood, but we're trying to support Android kernels without forking 
the heck out of our codebase.

>
>> +
>> +/* sysfs files for attributes for driver values. */
>> +static ssize_t rmi_driver_hasbsr_show(struct device *dev,
>> +				      struct device_attribute *attr, char *buf);
>
> Well, if it does not have bsr why do you even create bsr attribute?

We've been asking that very same question, and plan to change that.

>
>> +
>> +static ssize_t rmi_driver_bsr_show(struct device *dev,
>> +				   struct device_attribute *attr, char *buf);
>> +
>> +static ssize_t rmi_driver_bsr_store(struct device *dev,
>> +				    struct device_attribute *attr,
>> +				    const char *buf, size_t count);
>> +
>> +static ssize_t rmi_driver_enabled_show(struct device *dev,
>> +				       struct device_attribute *attr,
>> +				       char *buf);
>> +
>> +static ssize_t rmi_driver_enabled_store(struct device *dev,
>> +					struct device_attribute *attr,
>> +					const char *buf, size_t count);
>
> Should rely on load/unload or bind/unbind; no need for yet another
> mechanism.

This is needed as part of the support for the RED/Design Studio tools. 
The variable name is misleading, though - it doesn't enable/disable the 
driver, but enables/disables touch data processing for a single sensor. 
  We'll change the name of this.

>
>> +
>> +static ssize_t rmi_driver_phys_show(struct device *dev,
>> +				       struct device_attribute *attr,
>> +				       char *buf);
>> +
>> +static ssize_t rmi_driver_version_show(struct device *dev,
>> +				       struct device_attribute *attr,
>> +				       char *buf);
>
> Should be /sys/module/xxx/version already.

I don't find that.  I'll look into why not.



>> +
>> +#if REGISTER_DEBUG
>> +static ssize_t rmi_driver_reg_store(struct device *dev,
>> +					struct device_attribute *attr,
>> +
> 					const char *buf, size_t count);
> debugfs

Agree.

>> +#endif
>> +
>> +#if DELAY_DEBUG
>> +static ssize_t rmi_delay_show(struct device *dev,
>> +				       struct device_attribute *attr,
>> +				       char *buf);
>> +
>> +static ssize_t rmi_delay_store(struct device *dev,
>> +					struct device_attribute *attr,
>> +					const char *buf, size_t count);
>
> debugfs

Agree.

[snip]
[snip]

>> +	dev_dbg(dev, "%s: Creating sysfs files.", __func__);
>> +	for (attr_count = 0; attr_count<  ARRAY_SIZE(attrs); attr_count++) {
>> +		error = device_create_file(dev,&attrs[attr_count]);
>> +		if (error<  0) {
>> +			dev_err(dev, "%s: Failed to create sysfs file %s.\n",
>> +				__func__, attrs[attr_count].attr.name);
>> +			goto err_free_data;
>> +		}
>> +	}
>
> Use attribute group or driver infrastructure for registering common
> attributes.

Agree.  We're looking into this.

>
>> +
>> +	__mutex_init(&data->irq_mutex, "irq_mutex",&data->irq_key);
>
> Why not standard mutex_init()?

Not sure.  Will correct this.

>
>
>> +	data->current_irq_mask = kzalloc(sizeof(u8)*data->num_of_irq_regs,
>
> Spaces around arithmetic and other operations are appreciated.

Agree.


>
>> +					 GFP_KERNEL);
>> +	if (!data->current_irq_mask) {
>> +		dev_err(dev, "Failed to allocate current_irq_mask.\n");
>> +		error = -ENOMEM;
>> +		goto err_free_data;
>> +	}
>> +	error = rmi_read_block(rmi_dev,
>> +				data->f01_container->fd.control_base_addr+1,
>> +				data->current_irq_mask, data->num_of_irq_regs);
>> +	if (error<  0) {
>> +		dev_err(dev, "%s: Failed to read current IRQ mask.\n",
>> +			__func__);
>> +		goto err_free_data;
>> +	}
>> +	data->irq_mask_store = kzalloc(sizeof(u8)*data->num_of_irq_regs,
>> +				       GFP_KERNEL);
>> +	if (!data->irq_mask_store) {
>> +		dev_err(dev, "Failed to allocate mask store.\n");
>> +		error = -ENOMEM;
>> +		goto err_free_data;
>> +	}
>> +
>> +#ifdef	CONFIG_PM
>> +	data->pm_data = pdata->pm_data;
>> +	data->pre_suspend = pdata->pre_suspend;
>> +	data->post_resume = pdata->post_resume;
>
> Is it really platform dependent?

Yes.  Some platforms have special things they want to do before/after 
the touchpad suspends/resumes.

>
>> +
>> +	mutex_init(&data->suspend_mutex);
>> +
>> +#ifdef CONFIG_HAS_EARLYSUSPEND
>> +	rmi_dev->early_suspend_handler.level =
>> +		EARLY_SUSPEND_LEVEL_BLANK_SCREEN + 1;
>> +	rmi_dev->early_suspend_handler.suspend = rmi_driver_early_suspend;
>> +	rmi_dev->early_suspend_handler.resume = rmi_driver_late_resume;
>> +	register_early_suspend(&rmi_dev->early_suspend_handler);
>
> Not in mainline.

Yes, but as noted before we need to support Android without forking our 
driver codebase.

>
>> +#endif /* CONFIG_HAS_EARLYSUSPEND */
>> +#endif /* CONFIG_PM */
>> +	data->enabled = true;
>> +
>> +	dev_info(dev, "connected RMI device manufacturer: %s product: %s\n",
>> +		 data->manufacturer_id == 1 ? "synaptics" : "unknown",
>> +		 data->product_id);
>> +
>> +	return 0;
>> +
>> + err_free_data:
>> +	rmi_free_function_list(rmi_dev);
>> +	for (attr_count--; attr_count>= 0; attr_count--)
>> +		device_remove_file(dev,&attrs[attr_count]);
>> +	if (data) {
>
> You exit earlier if data is NULL.

Agree.

>
>> +		if (data->f01_container)
>> +			kfree(data->f01_container->irq_mask);
>> +		kfree(data->irq_mask_store);
>> +		kfree(data->current_irq_mask);
>> +		kfree(data);
>> +		rmi_set_driverdata(rmi_dev, NULL);
>> +	}
>> +	return error;
>> +}
>> +
>> +#ifdef CONFIG_PM
>> +static int rmi_driver_suspend(struct device *dev)
>> +{
>> +	struct rmi_device *rmi_dev;
>> +	struct rmi_driver_data *data;
>> +	struct rmi_function_container *entry;
>> +	int retval = 0;
>> +
>> +	rmi_dev = to_rmi_device(dev);
>> +	data = rmi_get_driverdata(rmi_dev);
>> +
>> +	mutex_lock(&data->suspend_mutex);
>> +	if (data->suspended)
>> +		goto exit;
>> +
>> +#ifndef	CONFIG_HAS_EARLYSUSPEND
>> +	if (data->pre_suspend) {
>> +		retval = data->pre_suspend(data->pm_data);
>> +		if (retval)
>> +			goto exit;
>> +	}
>> +#endif  /* !CONFIG_HAS_EARLYSUSPEND */
>> +
>> +	list_for_each_entry(entry,&data->rmi_functions.list, list)
>> +		if (entry->fh&&  entry->fh->suspend) {
>> +			retval = entry->fh->suspend(entry);
>> +			if (retval<  0)
>> +				goto exit;
>> +		}
>> +
>> +	if (data->f01_container&&  data->f01_container->fh
>> +				&&  data->f01_container->fh->suspend) {
>> +		retval = data->f01_container->fh->suspend(data->f01_container);
>> +		if (retval<  0)
>> +			goto exit;
>> +	}
>> +	data->suspended = true;
>> +
>> +exit:
>> +	mutex_unlock(&data->suspend_mutex);
>> +	return retval;
>
> Once it is better integrated in driver core this will be much simpler.

OK.

>
>> +}
>> +
>> +static int rmi_driver_resume(struct device *dev)
>> +{
>> +	struct rmi_device *rmi_dev;
>> +	struct rmi_driver_data *data;
>> +	struct rmi_function_container *entry;
>> +	int retval = 0;
>> +
>> +	rmi_dev = to_rmi_device(dev);
>> +	data = rmi_get_driverdata(rmi_dev);
>> +
>> +	mutex_lock(&data->suspend_mutex);
>> +	if (!data->suspended)
>> +		goto exit;
>> +
>> +	if (data->f01_container&&  data->f01_container->fh
>> +				&&  data->f01_container->fh->resume) {
>> +		retval = data->f01_container->fh->resume(data->f01_container);
>> +		if (retval<  0)
>> +			goto exit;
>> +	}
>> +
>> +	list_for_each_entry(entry,&data->rmi_functions.list, list)
>> +		if (entry->fh&&  entry->fh->resume) {
>> +			retval = entry->fh->resume(entry);
>> +			if (retval<  0)
>> +				goto exit;
>> +		}
>> +
>> +#ifndef	CONFIG_HAS_EARLYSUSPEND
>> +	if (data->post_resume) {
>> +		retval = data->post_resume(data->pm_data);
>> +		if (retval)
>> +			goto exit;
>> +	}
>> +#endif  /* !CONFIG_HAS_EARLYSUSPEND */
>> +
>> +	data->suspended = false;
>> +
>> +exit:
>> +	mutex_unlock(&data->suspend_mutex);
>> +	return retval;
>
> This one too.

OK

[snip]

>> +
>> +static ssize_t rmi_delay_show(struct device *dev,
>> +				       struct device_attribute *attr, char *buf)
>> +{
>> +	struct rmi_device *rmi_dev;
>> +	struct rmi_device_platform_data *pdata;
>> +
>> +	rmi_dev = to_rmi_device(dev);
>> +	pdata = rmi_dev->phys->dev->platform_data;
>> +
>> +	return snprintf(buf, PAGE_SIZE, "%d %d %d %d %d\n",
>> +		pdata->spi_data.read_delay_us, pdata->spi_data.write_delay_us,
>> +		pdata->spi_data.block_delay_us,
>> +		pdata->spi_data.pre_delay_us, pdata->spi_data.post_delay_us);
>
> This violates "one value per attribute" principle. Also it does not look
> like it is essential for device operation but rather diagnostic
> facility. Switch to debugfs?

Agree with debugfs. However, these are values that really ought to be 
managed as a group, rather than one at a time.

>
>> +}
>> +#endif
>> +
>> +static ssize_t rmi_driver_phys_show(struct device *dev,
>> +				       struct device_attribute *attr, char *buf)
>> +{
>> +	struct rmi_device *rmi_dev;
>> +	struct rmi_phys_info *info;
>> +
>> +	rmi_dev = to_rmi_device(dev);
>> +	info =&rmi_dev->phys->info;
>> +
>> +	return snprintf(buf, PAGE_SIZE, "%-5s %ld %ld %ld %ld %ld %ld %ld\n",
>> +		 info->proto ? info->proto : "unk",
>> +		 info->tx_count, info->tx_bytes, info->tx_errs,
>> +		 info->rx_count, info->rx_bytes, info->rx_errs,
>> +		 info->attn_count);
>
> Same as delay.

Agree with the debugfs part.  However, this is a bunch of related 
numbers that capture the state of the system at particular point in 
time, and it doesn't make sense to me to spread it across a bunch of 
different files.  We used things like /proc/loadavg for the model here, 
for good or ill.

[snip]

Thanks for all the input!
