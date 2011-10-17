Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1JQMNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:13:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34099 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1JQMNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 08:13:53 -0400
Date: Mon, 17 Oct 2011 13:13:50 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@suse.de, linus.walleij@stericsson.com, jamie@jamieiles.com,
        arnd@arndb.de
Subject: Re: [PATCH 2/6] drivers/base: add bus for System-on-Chip devices
Message-ID: <20111017121350.GF4992@totoro>
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
 <1318852378-14180-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318852378-14180-3-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

I'll have a proper look and test at this later, but it looks pretty good 
to me, so just a couple of minor nits.

Jamie

On Mon, Oct 17, 2011 at 12:52:54PM +0100, Lee Jones wrote:
[...]
> diff --git a/drivers/base/soc.c b/drivers/base/soc.c
> new file mode 100644
> index 0000000..1578e4e
> --- /dev/null
> +++ b/drivers/base/soc.c
> @@ -0,0 +1,115 @@
> +/*
> + * Copyright (C) ST-Ericsson SA 2011
> + *
> + * Author: Lee Jones <lee.jones@linaro.org> for ST-Ericsson.
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#include <linux/sysfs.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/stat.h>
> +#include <linux/slab.h>
> +#include <linux/sys_soc.h>
> +#include <linux/err.h>
> +
> +static ssize_t soc_info_get(struct device *dev,
> +			    struct device_attribute *attr,
> +			    char *buf);
> +
> +static DEVICE_ATTR(machine,  S_IRUGO, soc_info_get,  NULL);
> +static DEVICE_ATTR(family,   S_IRUGO, soc_info_get,  NULL);
> +static DEVICE_ATTR(soc_id,   S_IRUGO, soc_info_get,  NULL);
> +static DEVICE_ATTR(revision, S_IRUGO, soc_info_get,  NULL);
> +
> +static ssize_t soc_info_get(struct device *dev,
> +			    struct device_attribute *attr,
> +			    char *buf)
> +{
> +	struct soc_device *soc_dev =
> +		container_of(dev, struct soc_device, dev);
> +
> +	if (attr == &dev_attr_machine)
> +		return sprintf(buf, "%s\n", soc_dev->attr->machine);
> +	if (attr == &dev_attr_family)
> +		return sprintf(buf, "%s\n", soc_dev->attr->family);
> +	if (attr == &dev_attr_revision)
> +		return sprintf(buf, "%s\n", soc_dev->attr->revision);
> +	if (attr == &dev_attr_soc_id)
> +		return sprintf(buf, "%s\n", soc_dev->attr->soc_id);
> +
> +	return -EINVAL;
> +
> +}
> +
> +struct bus_type soc_bus_type = {
> +	.name  = "soc",
> +};

static?

> +
> +static int __init soc_bus_register(void)
> +{
> +	return bus_register(&soc_bus_type);
> +}
> +core_initcall(soc_bus_register);
> +
> +struct attribute *soc_attr[] = {
> +	&dev_attr_machine.attr,
> +	&dev_attr_family.attr,
> +	&dev_attr_soc_id.attr,
> +	&dev_attr_revision.attr,
> +	NULL,
> +};

static?

> +
> +struct attribute_group soc_attr_group = {
> +	.attrs = soc_attr,
> +};

static const?

> +
> +struct device *soc_device_register(struct soc_device_attribute *soc_dev_attr)
> +{
> +	struct soc_device *soc_dev;
> +	static atomic_t soc_device_num = ATOMIC_INIT(0);
> +	int ret;
> +
> +	soc_dev = kzalloc(sizeof(*soc_dev), GFP_KERNEL);
> +	if (!soc_dev)
> +		return ERR_PTR(-ENOMEM);
> +
> +	soc_dev->attr = soc_dev_attr;
> +	soc_dev->dev.bus = &soc_bus_type;
> +
> +	dev_set_name(&soc_dev->dev, "soc%d",
> +		atomic_inc_return(&soc_device_num) - 1);
> +
> +	ret = device_register(&soc_dev->dev);
> +	if (ret)
> +		goto out1;
> +
> +	ret = sysfs_create_group(&soc_dev->dev.kobj, &soc_attr_group);
> +	if (ret)
> +		goto out2;

If you create an array of struct attribute_group's and set 
soc_dev->dev.groups to that then the driver core will handle creating 
the attributes for you and removing them at cleanup.  It also means the 
attributes will get created at device creation time so there isn't a 
potential race with udev events looking for attributes that haven't been 
created yet.

> +
> +	return &soc_dev->dev;
> +
> +out2:
> +	device_unregister(&soc_dev->dev);
> +out1:
> +	kfree(soc_dev);
> +	kfree(soc_dev->attr);
> +	return ERR_PTR(ret);
> +}
> +
> +void soc_device_unregister(struct device *dev)
> +{
> +	struct soc_device *soc_dev =
> +		container_of(dev, struct soc_device, dev);
> +
> +	sysfs_remove_group(&dev->kobj, &soc_attr_group);
> +
> +	if (device_is_registered(dev))
> +		device_unregister(dev);

I don't think you need this - I think it's fine to say that a 
precondition of calling this is that the device is registered (that's 
what the platform_device layer does).

> +
> +	bus_unregister(&soc_bus_type);

I don't think this is quite right - we're freeing the bus on the first 
unregister and we won't be able to register any more soc devices.  As 
this can't sensibly be a loadable module I think it's fine to leave it 
always registered.

> +
> +	kfree(soc_dev->attr);
> +	kfree(soc_dev);

device_unregister() should do this for you.  The device could still be 
hanging around after device_unregister() if there are active references 
to it so we don't want to free the memory too early.  We should have a 
release function in the struct device set in soc_device_register that 
frees the struct soc_device.

> +}
> diff --git a/include/linux/sys_soc.h b/include/linux/sys_soc.h
> new file mode 100644
> index 0000000..2485a0f2
> --- /dev/null
> +++ b/include/linux/sys_soc.h
> @@ -0,0 +1,38 @@
> +/*
> + * Copyright (C) ST-Ericsson SA 2011
> + * Author: Lee Jones <lee.jones@linaro.org> for ST-Ericsson.
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +#ifndef __SOC_BUS_H
> +#define __SOC_BUS_H
> +
> +#include <linux/kobject.h>
> +#include <linux/device.h>
> +#include <linux/platform_device.h>

I'm not sure you need kobject.h and platform_device.h here.

> +
> +struct soc_device_attribute {
> +	const char *machine;
> +	const char *family;
> +	const char *revision;
> +	const char *soc_id;
> +};
> +
> +struct soc_device {
> +	struct device dev;
> +	struct soc_device_attribute *attr;
> +};

This can be private to the implementation file.

> +
> +/**
> + * soc_device_register - register SoC as a device
> + * @soc_plat_dev_attr: Attributes passed from platform to be attributed to a SoC
> + */
> +struct device *soc_device_register(
> +	struct soc_device_attribute *soc_plat_dev_attr);
> +
> +/**
> + * soc_device_unregister - unregister SoC device
> + * @dev: SoC device to be unregistered
> + */
> +void soc_device_unregister(struct device *dev);
> +
> +#endif /* __SOC_BUS_H */
> -- 
> 1.7.5.4
> 
