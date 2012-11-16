Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab2KPKEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 05:04:43 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:48284 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab2KPKEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:04:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, bhelgaas@google.com,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 3/3] i2c / ACPI: add ACPI enumeration support
Date: Fri, 16 Nov 2012 11:09:03 +0100
Message-ID: <2439178.tCj2rUMYJS@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1352977397-2280-4-git-send-email-mika.westerberg@linux.intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com> <1352977397-2280-4-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 15, 2012 01:03:17 PM Mika Westerberg wrote:
> ACPI 5 introduced I2cSerialBus resource that makes it possible to enumerate
> and configure the I2C slave devices behind the I2C controller. This patch
> adds helper functions to support I2C slave enumeration.
> 
> An ACPI enabled I2C controller driver only needs to call acpi_i2c_register_devices()
> in order to get its slave devices enumerated, created and bound to the
> corresponding ACPI handle.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Are there any objections against this patch or comments?

Worfram? Jean? Ben?

Rafael


> ---
>  drivers/acpi/Kconfig     |    6 ++
>  drivers/acpi/Makefile    |    1 +
>  drivers/acpi/acpi_i2c.c  |  212 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/i2c/i2c-core.c   |   10 +++
>  include/linux/acpi_i2c.h |   27 ++++++
>  5 files changed, 256 insertions(+)
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
> index 7289828..2a4502b 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -70,6 +70,7 @@ obj-$(CONFIG_ACPI_HED)		+= hed.o
>  obj-$(CONFIG_ACPI_EC_DEBUGFS)	+= ec_sys.o
>  obj-$(CONFIG_ACPI_CUSTOM_METHOD)+= custom_method.o
>  obj-$(CONFIG_ACPI_BGRT)		+= bgrt.o
> +obj-$(CONFIG_ACPI_I2C)		+= acpi_i2c.o
>  
>  # processor has its own "processor." module_param namespace
>  processor-y			:= processor_driver.o processor_throttling.o
> diff --git a/drivers/acpi/acpi_i2c.c b/drivers/acpi/acpi_i2c.c
> new file mode 100644
> index 0000000..5bf2dad
> --- /dev/null
> +++ b/drivers/acpi/acpi_i2c.c
> @@ -0,0 +1,212 @@
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
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/export.h>
> +#include <linux/i2c.h>
> +#include <linux/ioport.h>
> +
> +ACPI_MODULE_NAME("i2c");
> +
> +static int acpi_i2c_add_resource(struct acpi_resource *ares, void *data)
> +{
> +	struct acpi_resource_i2c_serialbus *sb;
> +	struct i2c_board_info *info = data;
> +
> +	if (ares->type != ACPI_RESOURCE_TYPE_SERIAL_BUS)
> +		return 0;
> +
> +	sb = &ares->data.i2c_serial_bus;
> +	if (sb->type != ACPI_RESOURCE_SERIAL_TYPE_I2C)
> +		return 0;
> +
> +	info->addr = sb->slave_address;
> +	if (sb->access_mode == ACPI_I2C_10BIT_MODE)
> +		info->flags |= I2C_CLIENT_TEN;
> +
> +	return 1;
> +}
> +
> +static acpi_status acpi_i2c_add_device(acpi_handle handle, u32 level,
> +				       void *data, void **return_value)
> +{
> +	struct i2c_adapter *adapter = data;
> +	struct resource_list_entry *rentry;
> +	struct list_head resource_list;
> +	struct i2c_board_info info;
> +	struct acpi_device *adev;
> +	int ret;
> +
> +	if (acpi_bus_get_device(handle, &adev))
> +		return AE_OK;
> +	if (acpi_bus_get_status(adev) || !adev->status.present)
> +		return AE_OK;
> +
> +	memset(&info, 0, sizeof(info));
> +
> +	INIT_LIST_HEAD(&resource_list);
> +	ret = acpi_dev_get_resources(adev, &resource_list,
> +				     acpi_i2c_add_resource, &info);
> +	if (ret < 0)
> +		return AE_OK;
> +
> +	list_for_each_entry(rentry, &resource_list, node) {
> +		struct resource *r = &rentry->res;
> +
> +		if (resource_type(r) == IORESOURCE_IRQ) {
> +			info.irq = r->start;
> +			break;
> +		}
> +	}
> +
> +	acpi_dev_free_resource_list(&resource_list);
> +
> +	if (!info.addr)
> +		return AE_OK;
> +
> +	strlcpy(info.type, dev_name(&adev->dev), sizeof(info.type));
> +	if (!i2c_new_device(adapter, &info)) {
> +		dev_err(&adapter->dev,
> +			"failed to add I2C device %s from ACPI\n",
> +			dev_name(&adev->dev));
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
> +	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
> +				     acpi_i2c_add_device, NULL,
> +				     adapter, NULL);
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
> +static int acpi_i2c_find_child_address(struct acpi_resource *ares, void *data)
> +{
> +	struct acpi_resource_i2c_serialbus *sb;
> +	struct acpi_i2c_find *i2c_find = data;
> +
> +	if (ares->type != ACPI_RESOURCE_TYPE_SERIAL_BUS)
> +		return 1;
> +
> +	sb = &ares->data.i2c_serial_bus;
> +	if (sb->type != ACPI_RESOURCE_SERIAL_TYPE_I2C)
> +		return 1;
> +
> +	if (sb->slave_address == i2c_find->addr)
> +		i2c_find->found = true;
> +
> +	return 1;
> +}
> +
> +static acpi_status acpi_i2c_find_child(acpi_handle handle, u32 level,
> +				       void *data, void **return_value)
> +{
> +	struct acpi_i2c_find *i2c_find = data;
> +	struct list_head resource_list;
> +	struct acpi_device *adev;
> +	int ret;
> +
> +	if (acpi_bus_get_device(handle, &adev))
> +		return AE_OK;
> +	if (acpi_bus_get_status(adev) || !adev->status.present)
> +		return AE_OK;
> +
> +	INIT_LIST_HEAD(&resource_list);
> +	ret = acpi_dev_get_resources(adev, &resource_list,
> +				     acpi_i2c_find_child_address, i2c_find);
> +	if (ret < 0)
> +		return AE_OK;
> +
> +	acpi_dev_free_resource_list(&resource_list);
> +
> +	if (i2c_find->found) {
> +		i2c_find->handle = handle;
> +		return AE_CTRL_TERMINATE;
> +	}
> +	return AE_OK;
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
> +	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, parent, 1,
> +				     acpi_i2c_find_child, NULL,
> +				     &i2c_find, NULL);
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
> index a7edf98..7385de2f 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -39,6 +39,8 @@
>  #include <linux/irqflags.h>
>  #include <linux/rwsem.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/acpi.h>
> +#include <linux/acpi_i2c.h>
>  #include <asm/uaccess.h>
>  
>  #include "i2c-core.h"
> @@ -78,6 +80,10 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
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
> @@ -1298,6 +1304,8 @@ static int __init i2c_init(void)
>  	retval = i2c_add_driver(&dummy_driver);
>  	if (retval)
>  		goto class_err;
> +
> +	acpi_i2c_bus_register();
>  	return 0;
>  
>  class_err:
> @@ -1311,6 +1319,8 @@ bus_err:
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
> index 0000000..cf2233f
> --- /dev/null
> +++ b/include/linux/acpi_i2c.h
> @@ -0,0 +1,27 @@
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
> +struct i2c_adapter;
> +
> +#if IS_ENABLED(CONFIG_ACPI_I2C)
> +extern void acpi_i2c_register_devices(struct i2c_adapter *adap);
> +extern void acpi_i2c_bus_register(void);
> +extern void acpi_i2c_bus_unregister(void);
> +#else
> +static inline void acpi_i2c_register_devices(struct i2c_adapter *adap) {}
> +static inline void acpi_i2c_bus_register(void) {}
> +static inline void acpi_i2c_bus_unregister(void) {}
> +#endif /* IS_ENABLED(CONFIG_ACPI_I2C) */
> +
> +#endif /* LINUX_ACPI_I2C_H */
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
