Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab2K1T0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:26:23 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25464 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab2K1T0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:26:21 -0500
Date: Wed, 28 Nov 2012 14:26:01 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [PATCH V1 1/2] Xen acpi memory hotplug driver
Message-ID: <20121128192601.GA15871@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923353942F9@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923353942F9@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 11:45:04AM +0000, Liu, Jinsong wrote:
> >From 630c65690c878255ce71e7c1172338ed08709273 Mon Sep 17 00:00:00 2001
> From: Liu Jinsong <jinsong.liu@intel.com>
> Date: Tue, 20 Nov 2012 21:14:37 +0800
> Subject: [PATCH 1/2] Xen acpi memory hotplug driver
> 
> Xen acpi memory hotplug consists of 2 logic components:
> Xen acpi memory hotplug driver and Xen hypercall.
> 
> This patch implement Xen acpi memory hotplug driver. When running
> under xen platform, Xen driver will early occupy (so native driver

How will it 'early occupy'? Can you spell it out here please?

> will be blocked). When acpi memory notify OSPM, xen driver will take
> effect, adding related memory device and parsing memory information.
> 
> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
> ---
>  drivers/xen/Kconfig               |   11 +
>  drivers/xen/Makefile              |    1 +
>  drivers/xen/xen-acpi-memhotplug.c |  383 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 395 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/xen/xen-acpi-memhotplug.c
> 
> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> index 126d8ce..abd0396 100644
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -206,4 +206,15 @@ config XEN_MCE_LOG
>  	  Allow kernel fetching MCE error from Xen platform and
>  	  converting it into Linux mcelog format for mcelog tools
>  
> +config XEN_ACPI_MEMORY_HOTPLUG
> +	bool "Xen ACPI memory hotplug"

There should be a way to make this a module.


> +	depends on XEN_DOM0 && X86_64 && ACPI
> +	default n
> +	help
> +	  This is Xen acpi memory hotplug.
                      ^^^^ -> ACPI

> +
> +	  Currently Xen only support acpi memory hot-add. If you want
                                     ^^^^-> ACPI

> +	  to hot-add memory at runtime (the hot-added memory cannot be
> +	  removed until machine stop), select Y here, otherwise select N.
> +
>  endmenu
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 7435470..c339eb4 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -30,6 +30,7 @@ obj-$(CONFIG_XEN_MCE_LOG)		+= mcelog.o
>  obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
>  obj-$(CONFIG_XEN_PRIVCMD)		+= xen-privcmd.o
>  obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+= xen-acpi-processor.o
> +obj-$(CONFIG_XEN_ACPI_MEMORY_HOTPLUG)	+= xen-acpi-memhotplug.o
>  xen-evtchn-y				:= evtchn.o
>  xen-gntdev-y				:= gntdev.o
>  xen-gntalloc-y				:= gntalloc.o
> diff --git a/drivers/xen/xen-acpi-memhotplug.c b/drivers/xen/xen-acpi-memhotplug.c
> new file mode 100644
> index 0000000..f0c7990
> --- /dev/null
> +++ b/drivers/xen/xen-acpi-memhotplug.c
> @@ -0,0 +1,383 @@
> +/*
> + * Copyright (C) 2012 Intel Corporation
> + *    Author: Liu Jinsong <jinsong.liu@intel.com>
> + *    Author: Jiang Yunhong <yunhong.jiang@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or (at
> + * your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + * NON INFRINGEMENT.  See the GNU General Public License for more
> + * details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/types.h>
> +#include <acpi/acpi_drivers.h>
> +
> +#define ACPI_MEMORY_DEVICE_CLASS		"memory"
> +#define ACPI_MEMORY_DEVICE_HID			"PNP0C80"
> +#define ACPI_MEMORY_DEVICE_NAME			"Hotplug Mem Device"

Weird tabs?

> +
> +#undef PREFIX

Why the #undef ?
> +#define PREFIX "ACPI:memory_hp:"


Not "ACPI:memory_xen:" ?


> +
> +static int acpi_memory_device_add(struct acpi_device *device);
> +static int acpi_memory_device_remove(struct acpi_device *device, int type);
> +
> +static const struct acpi_device_id memory_device_ids[] = {
> +	{ACPI_MEMORY_DEVICE_HID, 0},
> +	{"", 0},
> +};
> +
> +static struct acpi_driver acpi_memory_device_driver = {
> +	.name = "acpi_memhotplug",

Not 'xen_acpi_memhotplug' ?

> +	.class = ACPI_MEMORY_DEVICE_CLASS,
> +	.ids = memory_device_ids,
> +	.ops = {
> +		.add = acpi_memory_device_add,
> +		.remove = acpi_memory_device_remove,

Just for sake of clarity I would prefix those with 'xen_'.

> +		},
> +};
> +
> +struct acpi_memory_info {
> +	struct list_head list;
> +	u64 start_addr;		/* Memory Range start physical addr */
> +	u64 length;		/* Memory Range length */
> +	unsigned short caching;	/* memory cache attribute */
> +	unsigned short write_protect;	/* memory read/write attribute */

Can't the write_protect by a bit field like the 'enabled'? So
	unsigned int write_protect:1;
?
> +	unsigned int enabled:1;
> +};
> +
> +struct acpi_memory_device {
> +	struct acpi_device *device;
> +	struct list_head res_list;
> +};
> +
> +static int acpi_hotmem_initialized;

Just make it a bool and also use __read_mostly please.

> +
> +
> +int xen_acpi_memory_enable_device(struct acpi_memory_device *mem_device)
> +{
> +	return 0;
> +}

Why even have this function if it does not do anything?

> +
> +static acpi_status
> +acpi_memory_get_resource(struct acpi_resource *resource, void *context)
> +{
> +	struct acpi_memory_device *mem_device = context;
> +	struct acpi_resource_address64 address64;
> +	struct acpi_memory_info *info, *new;
> +	acpi_status status;
> +
> +	status = acpi_resource_to_address64(resource, &address64);
> +	if (ACPI_FAILURE(status) ||
> +	    (address64.resource_type != ACPI_MEMORY_RANGE))
> +		return AE_OK;
> +
> +	list_for_each_entry(info, &mem_device->res_list, list) {
> +		/* Can we combine the resource range information? */

I don't know? Is this is a future TODO?

> +		if ((info->caching == address64.info.mem.caching) &&
> +		    (info->write_protect == address64.info.mem.write_protect) &&
> +		    (info->start_addr + info->length == address64.minimum)) {
> +			info->length += address64.address_length;
> +			return AE_OK;
> +		}
> +	}
> +
> +	new = kzalloc(sizeof(struct acpi_memory_info), GFP_KERNEL);
> +	if (!new)
> +		return AE_ERROR;
> +
> +	INIT_LIST_HEAD(&new->list);
> +	new->caching = address64.info.mem.caching;
> +	new->write_protect = address64.info.mem.write_protect;
> +	new->start_addr = address64.minimum;
> +	new->length = address64.address_length;
> +	list_add_tail(&new->list, &mem_device->res_list);
> +
> +	return AE_OK;
> +}
> +
> +static int
> +acpi_memory_get_device_resources(struct acpi_memory_device *mem_device)
> +{
> +	acpi_status status;
> +	struct acpi_memory_info *info, *n;
> +
> +	if (!list_empty(&mem_device->res_list))
> +		return 0;
> +
> +	status = acpi_walk_resources(mem_device->device->handle,
> +		METHOD_NAME__CRS, acpi_memory_get_resource, mem_device);
> +
> +	if (ACPI_FAILURE(status)) {
> +		list_for_each_entry_safe(info, n, &mem_device->res_list, list)
> +			kfree(info);
> +		INIT_LIST_HEAD(&mem_device->res_list);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +acpi_memory_get_device(acpi_handle handle,
> +		       struct acpi_memory_device **mem_device)
> +{
> +	acpi_status status;
> +	acpi_handle phandle;
> +	struct acpi_device *device = NULL;
> +	struct acpi_device *pdevice = NULL;
> +	int result;
> +
> +	if (!acpi_bus_get_device(handle, &device) && device)
> +		goto end;
> +
> +	status = acpi_get_parent(handle, &phandle);
> +	if (ACPI_FAILURE(status)) {
> +		pr_warn(PREFIX "Cannot find acpi parent\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Get the parent device */
> +	result = acpi_bus_get_device(phandle, &pdevice);
> +	if (result) {
> +		pr_warn(PREFIX "Cannot get acpi bus device\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Now add the notified device.  This creates the acpi_device
> +	 * and invokes .add function
> +	 */
> +	result = acpi_bus_add(&device, pdevice, handle, ACPI_BUS_TYPE_DEVICE);
> +	if (result) {
> +		pr_warn(PREFIX "Cannot add acpi bus\n");
> +		return -EINVAL;
> +	}
> +
> +end:
> +	*mem_device = acpi_driver_data(device);
> +	if (!(*mem_device)) {
> +		pr_err(PREFIX "Driver data not found\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +static int acpi_memory_check_device(struct acpi_memory_device *mem_device)
> +{
> +	unsigned long long current_status;
> +
> +	/* Get device present/absent information from the _STA */
> +	if (ACPI_FAILURE(acpi_evaluate_integer(mem_device->device->handle,
> +				"_STA", NULL, &current_status)))
> +		return -ENODEV;
> +	/*
> +	 * Check for device status. Device should be
> +	 * present/enabled/functioning.
> +	 */
> +	if (!((current_status & ACPI_STA_DEVICE_PRESENT)
> +	      && (current_status & ACPI_STA_DEVICE_ENABLED)
> +	      && (current_status & ACPI_STA_DEVICE_FUNCTIONING)))
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
> +{
> +	pr_warn(PREFIX "Xen does not support memory hotremove\n");
> +
> +	return -ENOSYS;
> +}
> +
> +static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
> +{
> +	struct acpi_memory_device *mem_device;
> +	struct acpi_device *device;
> +	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
> +
> +	switch (event) {
> +	case ACPI_NOTIFY_BUS_CHECK:
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> +			"\nReceived BUS CHECK notification for device\n"));
> +		/* Fall Through */
> +	case ACPI_NOTIFY_DEVICE_CHECK:
> +		if (event == ACPI_NOTIFY_DEVICE_CHECK)
> +			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> +			"\nReceived DEVICE CHECK notification for device\n"));
> +
> +		if (acpi_memory_get_device(handle, &mem_device)) {
> +			pr_err(PREFIX "Cannot find driver data\n");
> +			break;
> +		}
> +
> +		ost_code = ACPI_OST_SC_SUCCESS;
> +		break;
> +
> +	case ACPI_NOTIFY_EJECT_REQUEST:
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> +			"\nReceived EJECT REQUEST notification for device\n"));
> +
> +		if (acpi_bus_get_device(handle, &device)) {
> +			pr_err(PREFIX "Device doesn't exist\n");
> +			break;
> +		}
> +		mem_device = acpi_driver_data(device);
> +		if (!mem_device) {
> +			pr_err(PREFIX "Driver Data is NULL\n");
> +			break;
> +		}
> +
> +		/*
> +		 * TBD: implement acpi_memory_disable_device and invoke
> +		 * acpi_bus_remove if Xen support hotremove in the future
> +		 */
> +		acpi_memory_disable_device(mem_device);
> +		break;
> +
> +	default:
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> +				  "Unsupported event [0x%x]\n", event));
> +		/* non-hotplug event; possibly handled by other handler */
> +		return;
> +	}
> +
> +	/* Inform firmware that the hotplug operation has completed */
> +	(void) acpi_evaluate_hotplug_ost(handle, event, ost_code, NULL);


Hm, even if we failed? Say for the ACPI_NOTIFY_EJECT_REQUEST ?

> +	return;
> +}
> +
> +static int acpi_memory_device_add(struct acpi_device *device)
> +{
> +	int result;
> +	struct acpi_memory_device *mem_device = NULL;
> +
> +
> +	if (!device)
> +		return -EINVAL;
> +
> +	mem_device = kzalloc(sizeof(struct acpi_memory_device), GFP_KERNEL);
> +	if (!mem_device)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&mem_device->res_list);
> +	mem_device->device = device;
> +	sprintf(acpi_device_name(device), "%s", ACPI_MEMORY_DEVICE_NAME);
> +	sprintf(acpi_device_class(device), "%s", ACPI_MEMORY_DEVICE_CLASS);
> +	device->driver_data = mem_device;
> +
> +	/* Get the range from the _CRS */
> +	result = acpi_memory_get_device_resources(mem_device);
> +	if (result) {
> +		kfree(mem_device);
> +		return result;
> +	}
> +
> +	/*
> +	 * Early boot code has recognized memory area by EFI/E820.
> +	 * If DSDT shows these memory devices on boot, hotplug is not necessary
> +	 * for them. So, it just returns until completion of this driver's
> +	 * start up.
> +	 */
> +	if (!acpi_hotmem_initialized)
> +		return 0;
> +
> +	if (!acpi_memory_check_device(mem_device))
> +		result = xen_acpi_memory_enable_device(mem_device);

This is a nop. Could you just do:
		result = 0;
?

> +
> +	return result;
> +}
> +
> +static int acpi_memory_device_remove(struct acpi_device *device, int type)
> +{
> +	struct acpi_memory_device *mem_device = NULL;
> +
> +	if (!device || !acpi_driver_data(device))
> +		return -EINVAL;
> +
> +	mem_device = acpi_driver_data(device);
> +	kfree(mem_device);
> +
> +	return 0;
> +}
> +
> +/*
> + * Helper function to check for memory device
> + */
> +static acpi_status is_memory_device(acpi_handle handle)
> +{
> +	char *hardware_id;
> +	acpi_status status;
> +	struct acpi_device_info *info;
> +
> +	status = acpi_get_object_info(handle, &info);
> +	if (ACPI_FAILURE(status))
> +		return status;
> +
> +	if (!(info->valid & ACPI_VALID_HID)) {
> +		kfree(info);
> +		return AE_ERROR;
> +	}
> +
> +	hardware_id = info->hardware_id.string;
> +	if ((hardware_id == NULL) ||
> +	    (strcmp(hardware_id, ACPI_MEMORY_DEVICE_HID)))
> +		status = AE_ERROR;
> +
> +	kfree(info);
> +	return status;
> +}
> +
> +static acpi_status
> +acpi_memory_register_notify_handler(acpi_handle handle,
> +				    u32 level, void *ctxt, void **retv)
> +{
> +	acpi_status status;
> +
> +	status = is_memory_device(handle);
> +	if (ACPI_FAILURE(status))
> +		return AE_OK;	/* continue */
> +
> +	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> +					     acpi_memory_device_notify, NULL);
> +	/* continue */
> +	return AE_OK;
> +}
> +
> +static int __init xen_acpi_memory_device_init(void)
> +{
> +	int result;
> +	acpi_status status;
> +
> +	/* only dom0 is responsible for xen acpi memory hotplug */
> +	if (!xen_initial_domain())
> +		return -ENODEV;
> +
> +	result = acpi_bus_register_driver(&acpi_memory_device_driver);
> +	if (result < 0)
> +		return -ENODEV;
> +
> +	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
> +				     ACPI_UINT32_MAX,
> +				     acpi_memory_register_notify_handler, NULL,
> +				     NULL, NULL);
> +
> +	if (ACPI_FAILURE(status)) {
> +		pr_warn(PREFIX "walk_namespace failed\n");
> +		acpi_bus_unregister_driver(&acpi_memory_device_driver);
> +		return -ENODEV;
> +	}
> +
> +	acpi_hotmem_initialized = 1;
> +	return 0;
> +}
> +subsys_initcall(xen_acpi_memory_device_init);
> -- 
> 1.7.1


