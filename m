Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2KCVxK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 17:53:10 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:37009 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab2KCVxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 17:53:06 -0400
Date: Sat, 3 Nov 2012 22:52:46 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/3] i2c / ACPI: add ACPI enumeration support
Message-ID: <20121103225246.66d4f094@endymion.delvare>
In-Reply-To: <1351928793-14375-4-git-send-email-mika.westerberg@linux.intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
	<1351928793-14375-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  3 Nov 2012 09:46:33 +0200, Mika Westerberg wrote:
> ACPI 5 introduced I2cSerialBus resource that makes it possible to enumerate
> and configure the I2C slave devices behind the I2C controller. This patch
> adds helper functions to support I2C slave enumeration.
> 
> An ACPI enabled I2C controller driver only needs to call acpi_i2c_register_devices()
> in order to get its slave devices enumerated, created and bound to the
> corresponding ACPI handle.

I'm very happy to finally see this happen. Out of curiosity, did you
try that code with an actual ACPI implementation?

Light review below:

> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/Kconfig     |    6 ++
>  drivers/acpi/Makefile    |    1 +
>  drivers/acpi/acpi_i2c.c  |  234 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/i2c/i2c-core.c   |    9 ++
>  include/linux/acpi_i2c.h |   29 ++++++
>  5 files changed, 279 insertions(+)
>  create mode 100644 drivers/acpi/acpi_i2c.c
>  create mode 100644 include/linux/acpi_i2c.h
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 119d58d..0300bf6 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -181,6 +181,12 @@ config ACPI_DOCK
>  	  This driver supports ACPI-controlled docking stations and removable
>  	  drive bays such as the IBM Ultrabay and the Dell Module Bay.
>  
> +config ACPI_I2C
> +	def_tristate I2C
> +	depends on I2C
> +	help
> +	  ACPI I2C enumeration support.
> +
>  config ACPI_PROCESSOR
>  	tristate "Processor"
>  	select THERMAL
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index a7badb5..8573346 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -69,6 +69,7 @@ obj-$(CONFIG_ACPI_HED)		+= hed.o
>  obj-$(CONFIG_ACPI_EC_DEBUGFS)	+= ec_sys.o
>  obj-$(CONFIG_ACPI_CUSTOM_METHOD)+= custom_method.o
>  obj-$(CONFIG_ACPI_BGRT)		+= bgrt.o
> +obj-$(CONFIG_ACPI_I2C)		+= acpi_i2c.o
>  
>  # processor has its own "processor." module_param namespace
>  processor-y			:= processor_driver.o processor_throttling.o
> diff --git a/drivers/acpi/acpi_i2c.c b/drivers/acpi/acpi_i2c.c
> new file mode 100644
> index 0000000..dc6997e
> --- /dev/null
> +++ b/drivers/acpi/acpi_i2c.c
> @@ -0,0 +1,234 @@
> +/*
> + * ACPI I2C enumeration support
> + *
> + * Copyright (C) 2012, Intel Corporation
> + * Author: Mika Westerberg <mika.westerberg@linux.intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>

You also need <linux/device.h> for dev_err() etc., and <linux/err.h> for
ENODEV etc.
> +
> +struct acpi_i2c {
> +	acpi_status (*callback)(struct acpi_device *, void *);
> +	void *data;
> +};
> +
> +static acpi_status acpi_i2c_enumerate_device(acpi_handle handle, u32 level,
> +					     void *data, void **return_value)
> +{
> +	struct acpi_i2c *acpi_i2c = data;
> +	struct acpi_device *adev;
> +
> +	if (acpi_bus_get_device(handle, &adev))
> +		return AE_OK;
> +	if (acpi_bus_get_status(adev) || !adev->status.present)
> +		return AE_OK;
> +
> +	return acpi_i2c->callback(adev, acpi_i2c->data);
> +}
> +
> +static acpi_status acpi_i2c_enumerate(acpi_handle handle,
> +	acpi_status (*callback)(struct acpi_device *, void *), void *data)
> +{
> +	struct acpi_i2c acpi_i2c;
> +
> +	acpi_i2c.callback = callback;
> +	acpi_i2c.data = data;
> +
> +	return acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
> +				   acpi_i2c_enumerate_device, NULL,
> +				   &acpi_i2c, NULL);
> +}
> +
> +struct acpi_i2c_device_info {
> +	struct i2c_board_info board;
> +	int triggering;
> +	int polarity;
> +	int gsi;
> +	bool valid;
> +};
> +
> +static acpi_status acpi_i2c_add_resources(struct acpi_resource *res, void *data)
> +{
> +	struct acpi_i2c_device_info *info = data;
> +	struct acpi_resource_i2c_serialbus *sb;
> +
> +	switch (res->type) {
> +	case ACPI_RESOURCE_TYPE_SERIAL_BUS:
> +		sb = &res->data.i2c_serial_bus;
> +		if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_I2C) {
> +			info->board.addr = sb->slave_address;
> +			if (sb->access_mode == ACPI_I2C_10BIT_MODE)
> +				info->board.flags |= I2C_CLIENT_TEN;
> +
> +			/*
> +			 * The info is valid once we have found the
> +			 * I2CSerialBus resource.
> +			 */
> +			info->valid = true;
> +		}
> +		break;
> +
> +	case ACPI_RESOURCE_TYPE_IRQ:
> +		info->gsi = res->data.irq.interrupts[0];
> +		info->triggering = res->data.irq.triggering;
> +		info->polarity = res->data.irq.polarity;
> +		break;
> +
> +	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
> +		info->gsi = res->data.extended_irq.interrupts[0];
> +		info->triggering = res->data.extended_irq.triggering;
> +		info->polarity = res->data.extended_irq.polarity;
> +		break;
> +	}
> +
> +	return AE_OK;
> +}
> +
> +static acpi_status acpi_i2c_add_device(struct acpi_device *adev, void *data)
> +{
> +	struct acpi_i2c_device_info info;
> +	struct i2c_adapter *adapter = data;
> +	acpi_status status;
> +
> +	memset(&info, 0, sizeof(info));
> +	info.gsi = -1;
> +
> +	status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
> +				     acpi_i2c_add_resources, &info);
> +	if (ACPI_FAILURE(status) || !info.valid)
> +		return status;
> +
> +	strlcpy(info.board.type, acpi_device_hid(adev),
> +		sizeof(info.board.type));

I very much doubt the ACPI HID names will match the Linux i2c device
names. In other words you are instantiating devices no driver will want
to bind to. How do you plan to solve this issue?

> +	if (info.gsi >= 0)
> +		info.board.irq = acpi_register_gsi(&adev->dev, info.gsi,
> +						   info.triggering,
> +						   info.polarity);
> +
> +	request_module("%s%s", I2C_MODULE_PREFIX, info.board.type);
> +	if (!i2c_new_device(adapter, &info.board)) {
> +		dev_err(&adapter->dev, "failed to add i2c device from ACPI\n");
> +		if (info.gsi >= 0)
> +			acpi_unregister_gsi(info.gsi);
> +	}
> +
> +	return AE_OK;
> +}
> +
> +/**
> + * acpi_i2c_register_devices - enumerate I2C slave devices behind adapter
> + * @adapter: pointer to adapter
> + *
> + * Enumerate all I2C slave devices behind this adapter by walking the ACPI
> + * namespace. When a device is found it will be added to the Linux device
> + * model and bound to the corresponding ACPI handle.
> + */
> +void acpi_i2c_register_devices(struct i2c_adapter *adapter)
> +{
> +	acpi_handle handle;
> +	acpi_status status;
> +
> +	handle = adapter->dev.acpi_handle;
> +	if (!handle)
> +		return;
> +
> +	status = acpi_i2c_enumerate(handle, acpi_i2c_add_device, adapter);
> +	if (ACPI_FAILURE(status))
> +		dev_warn(&adapter->dev, "failed to enumerate I2C slaves\n");
> +}
> +EXPORT_SYMBOL_GPL(acpi_i2c_register_devices);
> +
> +struct acpi_i2c_find {
> +	acpi_handle handle;
> +	u16 addr;
> +	bool found;
> +};
> +
> +static acpi_status acpi_i2c_find_child_address(struct acpi_resource *res,
> +					       void *data)
> +{
> +	struct acpi_resource_i2c_serialbus *sb;
> +	struct acpi_i2c_find *i2c_find = data;
> +
> +	if (res->type != ACPI_RESOURCE_TYPE_SERIAL_BUS)
> +		return AE_OK;
> +
> +	sb = &res->data.i2c_serial_bus;
> +	if (sb->type != ACPI_RESOURCE_SERIAL_TYPE_I2C)
> +		return AE_OK;
> +
> +	if (sb->slave_address == i2c_find->addr) {
> +		i2c_find->found = true;
> +		return AE_CTRL_TERMINATE;
> +	}
> +
> +	return AE_OK;
> +}
> +
> +static acpi_status acpi_i2c_find_child(struct acpi_device *adev, void *data)
> +{
> +	struct acpi_i2c_find *i2c_find = data;
> +	acpi_status status;
> +
> +	status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
> +				     acpi_i2c_find_child_address, i2c_find);
> +	if (ACPI_FAILURE(status) || !i2c_find->found)
> +		return status;
> +
> +	i2c_find->handle = adev->handle;
> +	return AE_CTRL_TERMINATE;
> +}
> +
> +static int acpi_i2c_find_device(struct device *dev, acpi_handle *handle)
> +{
> +	struct acpi_i2c_find i2c_find;
> +	struct i2c_adapter *adapter;
> +	struct i2c_client *client;
> +	acpi_handle parent;
> +	acpi_status status;
> +
> +	client = i2c_verify_client(dev);
> +	if (!client)
> +		return -ENODEV;
> +
> +	adapter = client->adapter;
> +	if (!adapter)
> +		return -ENODEV;
> +
> +	parent = adapter->dev.acpi_handle;
> +	if (!parent)
> +		return -ENODEV;
> +
> +	memset(&i2c_find, 0, sizeof(i2c_find));
> +	i2c_find.addr = client->addr;
> +
> +	status = acpi_i2c_enumerate(parent, acpi_i2c_find_child, &i2c_find);
> +	if (ACPI_FAILURE(status) || !i2c_find.handle)
> +		return -ENODEV;
> +
> +	*handle = i2c_find.handle;
> +	return 0;
> +}
> +
> +static struct acpi_bus_type acpi_i2c_bus = {
> +	.bus = &i2c_bus_type,
> +	.find_device = acpi_i2c_find_device,
> +};
> +
> +void acpi_i2c_bus_register(void)
> +{
> +	register_acpi_bus_type(&acpi_i2c_bus);
> +}
> +EXPORT_SYMBOL_GPL(acpi_i2c_bus_register);
> +
> +void acpi_i2c_bus_unregister(void)
> +{
> +	unregister_acpi_bus_type(&acpi_i2c_bus);
> +}
> +EXPORT_SYMBOL_GPL(acpi_i2c_bus_unregister);
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index a7edf98..8b9d6fb 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -39,6 +39,7 @@
>  #include <linux/irqflags.h>
>  #include <linux/rwsem.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/acpi_i2c.h>
>  #include <asm/uaccess.h>
>  
>  #include "i2c-core.h"
> @@ -78,6 +79,10 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
>  	if (of_driver_match_device(dev, drv))
>  		return 1;
>  
> +	/* Then ACPI style match */
> +	if (acpi_driver_match_device(dev, drv))
> +		return 1;
> +
>  	driver = to_i2c_driver(drv);
>  	/* match on an id table if there is one */
>  	if (driver->id_table)
> @@ -1298,6 +1303,8 @@ static int __init i2c_init(void)
>  	retval = i2c_add_driver(&dummy_driver);
>  	if (retval)
>  		goto class_err;
> +
> +	acpi_i2c_bus_register();
>  	return 0;
>  
>  class_err:
> @@ -1311,6 +1318,8 @@ bus_err:
>  
>  static void __exit i2c_exit(void)
>  {
> +	acpi_i2c_bus_unregister();
> +
>  	i2c_del_driver(&dummy_driver);
>  #ifdef CONFIG_I2C_COMPAT
>  	class_compat_unregister(i2c_adapter_compat_class);
> diff --git a/include/linux/acpi_i2c.h b/include/linux/acpi_i2c.h
> new file mode 100644
> index 0000000..d4482df
> --- /dev/null
> +++ b/include/linux/acpi_i2c.h
> @@ -0,0 +1,29 @@
> +/*
> + * ACPI I2C enumeration support
> + *
> + * Copyright (C) 2012, Intel Corporation
> + * Author: Mika Westerberg <mika.westerberg@linux.intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef LINUX_ACPI_I2C_H
> +#define LINUX_ACPI_I2C_H
> +
> +#include <linux/acpi.h>

What for?

> +struct i2c_adapter;
> +
> +#if defined(CONFIG_ACPI_I2C) || defined(CONFIG_ACPI_I2C_MODULE)
> +extern void acpi_i2c_register_devices(struct i2c_adapter *adap);
> +extern void acpi_i2c_bus_register(void);
> +extern void acpi_i2c_bus_unregister(void);
> +#else
> +static inline void acpi_i2c_register_devices(struct i2c_adapter *adap) {}
> +static inline void acpi_i2c_bus_register(void) {}
> +static inline void acpi_i2c_bus_unregister(void) {}
> +#endif /* CONFIG_ACPI_I2C */
> +
> +#endif /* LINUX_ACPI_I2C_H */


-- 
Jean Delvare
