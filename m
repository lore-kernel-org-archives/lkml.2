Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab2LRAR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 19:17:28 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:38448 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2LRARY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 19:17:24 -0500
Message-ID: <1355789297.18964.334.camel@misato.fc.hp.com>
Subject: Re: [PATCH rev.2 1/6] ACPI: Separate adding ACPI device objects
 from probing ACPI drivers
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Date: Mon, 17 Dec 2012 17:08:17 -0700
In-Reply-To: <1525730.exQ7msTINR@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan>
	 <1499423.ez5cZl2uAf@vostro.rjw.lan> <1525730.exQ7msTINR@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-13 at 23:17 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 

(snip)

>  struct acpi_device_ops {
> Index: linux/drivers/acpi/scan.c
> ===================================================================
> --- linux.orig/drivers/acpi/scan.c
> +++ linux/drivers/acpi/scan.c
> @@ -494,7 +494,8 @@ static int acpi_bus_match(struct device
>  	struct acpi_device *acpi_dev = to_acpi_device(dev);
>  	struct acpi_driver *acpi_drv = to_acpi_driver(drv);
>  
> -	return !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
> +	return acpi_dev->bus_ops.acpi_op_match
> +		&& !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
>  }
>  
>  static int acpi_device_uevent(struct device *dev, struct kobj_uevent_env *env)
> @@ -1418,6 +1419,17 @@ static int acpi_bus_remove(struct acpi_d
>  	return 0;
>  }
>  
> +/*
> + * acpi_hot_add_bind - Bind _ADR-based devices on hot-add.
> + * @device: ACPI device node to bind.
> + */
> +static void acpi_hot_add_bind(struct acpi_device *device)
> +{
> +	if (device->flags.bus_address
> +	    && device->parent && device->parent->ops.bind)
> +		device->parent->ops.bind(device);
> +}
> +
>  static int acpi_add_single_object(struct acpi_device **child,
>  				  acpi_handle handle, int type,
>  				  unsigned long long sta,
> @@ -1490,13 +1502,8 @@ static int acpi_add_single_object(struct
>  
>  	result = acpi_device_register(device);
>  
> -	/*
> -	 * Bind _ADR-Based Devices when hot add
> -	 */
> -	if (device->flags.bus_address) {
> -		if (device->parent && device->parent->ops.bind)
> -			device->parent->ops.bind(device);
> -	}

I think the original code above is hot-add only because ops.bind is not
set at boot since the acpi_pci driver has not been registered yet.  It
seems that acpi_pci_bridge_scan() called from acpi_pci_root_add() takes
care of the binding.

This brings me a question for acpi_bus_probe_start() below...


> +	if (device->bus_ops.acpi_op_match)
> +		acpi_hot_add_bind(device);
>  
>  end:
>  	if (!result) {
> @@ -1522,6 +1529,7 @@ static void acpi_bus_add_power_resource(
>  	struct acpi_bus_ops ops = {
>  		.acpi_op_add = 1,
>  		.acpi_op_start = 1,
> +		.acpi_op_match = 1,
>  	};
>  	struct acpi_device *device = NULL;
>  
> @@ -1574,9 +1582,9 @@ static acpi_status acpi_bus_check_add(ac
>  				      void *context, void **return_value)
>  {
>  	struct acpi_bus_ops *ops = context;
> +	struct acpi_device *device = NULL;
>  	int type;
>  	unsigned long long sta;
> -	struct acpi_device *device;
>  	acpi_status status;
>  	int result;
>  
> @@ -1596,52 +1604,86 @@ static acpi_status acpi_bus_check_add(ac
>  		return AE_CTRL_DEPTH;
>  	}
>  
> -	/*
> -	 * We may already have an acpi_device from a previous enumeration.  If
> -	 * so, we needn't add it again, but we may still have to start it.
> -	 */
> -	device = NULL;
>  	acpi_bus_get_device(handle, &device);
>  	if (ops->acpi_op_add && !device) {
> -		acpi_add_single_object(&device, handle, type, sta, ops);
> -		/* Is the device a known good platform device? */
> -		if (device
> -		    && !acpi_match_device_ids(device, acpi_platform_device_ids))
> -			acpi_create_platform_device(device);
> -	}
> -
> -	if (!device)
> -		return AE_CTRL_DEPTH;
> +		struct acpi_bus_ops add_ops = *ops;
>  
> -	if (ops->acpi_op_start && !(ops->acpi_op_add)) {
> -		status = acpi_start_single_object(device);
> -		if (ACPI_FAILURE(status))
> +		add_ops.acpi_op_match = 0;
> +		acpi_add_single_object(&device, handle, type, sta, &add_ops);
> +		if (!device)
>  			return AE_CTRL_DEPTH;
> +
> +		device->bus_ops.acpi_op_match = 1;
>  	}
>  
>  	if (!*return_value)
>  		*return_value = device;
> +
>  	return AE_OK;
>  }
>  
> +static acpi_status acpi_bus_probe_start(acpi_handle handle, u32 lvl,
> +					void *context, void **not_used)
> +{
> +	struct acpi_bus_ops *ops = context;
> +	acpi_status status = AE_OK;
> +	struct acpi_device *device;
> +	unsigned long long sta_not_used;
> +	int type_not_used;
> +
> +	/*
> +	 * Ignore errors ignored by acpi_bus_check_add() to avoid terminating

"ignore" seems duplicated. 

> +	 * namespace walks prematurely.
> +	 */
> +	if (acpi_bus_type_and_status(handle, &type_not_used, &sta_not_used))
> +		return AE_OK;
> +
> +	if (acpi_bus_get_device(handle, &device))
> +		return AE_CTRL_DEPTH;
> +
> +	if (ops->acpi_op_add) {
> +		if (!acpi_match_device_ids(device, acpi_platform_device_ids)) {
> +			/* This is a known good platform device. */
> +			acpi_create_platform_device(device);
> +		} else {
> +			int ret = device_attach(&device->dev);
> +			acpi_hot_add_bind(device);

Since acpi_pci_root_add() is called by device_attach(), I think this
acpi_hot_add_bind() calls .bind() of a device at boot since its .bind()
may be set.  Is that correct?  If so, how does it coordinate with the
bind procedure in acpi_pci_bridge_scan()?


Thanks,
-Toshi


