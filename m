Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2LLQiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:38:19 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56092 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab2LLQiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:38:16 -0500
Message-ID: <50C8B2E9.5050700@gmail.com>
Date: Thu, 13 Dec 2012 00:38:01 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH 1/6] ACPI: Separate adding ACPI device objects from probing
 ACPI drivers
References: <8498184.VilrUmatxI@vostro.rjw.lan> <4002729.BbipMAJtM0@vostro.rjw.lan>
In-Reply-To: <4002729.BbipMAJtM0@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 07:00 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Currently, as soon as an ACPI device node object (struct acpi_device)
snip
  
> @@ -1600,48 +1608,77 @@ static acpi_status acpi_bus_check_add(ac
>  	 * We may already have an acpi_device from a previous enumeration.  If
>  	 * so, we needn't add it again, but we may still have to start it.
>  	 */
> -	device = NULL;
>  	acpi_bus_get_device(handle, &device);
>  	if (ops->acpi_op_add && !device) {
> -		acpi_add_single_object(&device, handle, type, sta, ops);
> -		/* Is the device a known good platform device? */
> -		if (device
> -		    && !acpi_match_device_ids(device, acpi_platform_device_ids))
> -			acpi_create_platform_device(device);
> -	}
> +		struct acpi_bus_ops add_ops = *ops;
>  
> -	if (!device)
> -		return AE_CTRL_DEPTH;
> -
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
> +	struct acpi_device *device;
> +	acpi_status status = AE_OK;
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
> +			if (ret)
> +				status = AE_CTRL_DEPTH;
> +		}
> +	} else if (ops->acpi_op_start) {
> +		if (ACPI_FAILURE(acpi_start_single_object(device)))
> +			status = AE_CTRL_DEPTH;
> +	}
> +	return status;
> +}
> +
>  static int acpi_bus_scan(acpi_handle handle, struct acpi_bus_ops *ops,
>  			 struct acpi_device **child)
>  {
> -	acpi_status status;
>  	void *device = NULL;
> +	acpi_status status;
> +	int ret = 0;
>  
>  	status = acpi_bus_check_add(handle, 0, ops, &device);
> -	if (ACPI_SUCCESS(status))
> +	if (ACPI_FAILURE(status)) {
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +
> +	acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> +			    acpi_bus_check_add, NULL, ops, &device);
> +	if (device)
>  		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> -				    acpi_bus_check_add, NULL, ops, &device);
> +				    acpi_bus_probe_start, NULL, ops, NULL);
Hi Rafael,
	Should we call acpi_bus_probe_start for the top device corresponding to 
"handle" too here?

> +	else
> +		ret = -ENODEV;
>  
> + out:
>  	if (child)
>  		*child = device;
>  
> -	if (device)
> -		return 0;
> -	else
> -		return -ENODEV;
> +	return ret;
>  }
>  
>  /*
> @@ -1752,6 +1789,7 @@ static int acpi_bus_scan_fixed(void)
>  	memset(&ops, 0, sizeof(ops));
>  	ops.acpi_op_add = 1;
>  	ops.acpi_op_start = 1;
> +	ops.acpi_op_match = 1;
>  
>  	/*
>  	 * Enumerate all fixed-feature devices.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

