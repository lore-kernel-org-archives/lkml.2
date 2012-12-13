Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab2LMTfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 14:35:32 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60826 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162Ab2LMTfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 14:35:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH 1/6] ACPI: Separate adding ACPI device objects from probing ACPI drivers
Date: Thu, 13 Dec 2012 20:40:33 +0100
Message-ID: <3742073.hTjabQ5pdD@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50C9D29F.9040508@gmail.com>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <2789050.ITilpEgQsC@vostro.rjw.lan> <50C9D29F.9040508@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 13, 2012 09:05:35 PM Jiang Liu wrote:
> On 12/13/2012 06:32 AM, Rafael J. Wysocki wrote:
> > On Thursday, December 13, 2012 12:38:01 AM Jiang Liu wrote:
> >> On 12/10/2012 07:00 AM, Rafael J. Wysocki wrote:
> >>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>>
> >>> Currently, as soon as an ACPI device node object (struct acpi_device)
> >> snip
> >>   
> >>> @@ -1600,48 +1608,77 @@ static acpi_status acpi_bus_check_add(ac
> >>>  	 * We may already have an acpi_device from a previous enumeration.  If
> >>>  	 * so, we needn't add it again, but we may still have to start it.
> >>>  	 */
> >>> -	device = NULL;
> >>>  	acpi_bus_get_device(handle, &device);
> >>>  	if (ops->acpi_op_add && !device) {
> >>> -		acpi_add_single_object(&device, handle, type, sta, ops);
> >>> -		/* Is the device a known good platform device? */
> >>> -		if (device
> >>> -		    && !acpi_match_device_ids(device, acpi_platform_device_ids))
> >>> -			acpi_create_platform_device(device);
> >>> -	}
> >>> +		struct acpi_bus_ops add_ops = *ops;
> >>>  
> >>> -	if (!device)
> >>> -		return AE_CTRL_DEPTH;
> >>> -
> >>> -	if (ops->acpi_op_start && !(ops->acpi_op_add)) {
> >>> -		status = acpi_start_single_object(device);
> >>> -		if (ACPI_FAILURE(status))
> >>> +		add_ops.acpi_op_match = 0;
> >>> +		acpi_add_single_object(&device, handle, type, sta, &add_ops);
> >>> +		if (!device)
> >>>  			return AE_CTRL_DEPTH;
> >>> +
> >>> +		device->bus_ops.acpi_op_match = 1;
> >>>  	}
> >>>  
> >>>  	if (!*return_value)
> >>>  		*return_value = device;
> >>> +
> >>>  	return AE_OK;
> >>>  }
> >>>  
> >>> +static acpi_status acpi_bus_probe_start(acpi_handle handle, u32 lvl,
> >>> +					void *context, void **not_used)
> >>> +{
> >>> +	struct acpi_bus_ops *ops = context;
> >>> +	struct acpi_device *device;
> >>> +	acpi_status status = AE_OK;
> >>> +
> >>> +	if (acpi_bus_get_device(handle, &device))
> >>> +		return AE_CTRL_DEPTH;
> >>> +
> >>> +	if (ops->acpi_op_add) {
> >>> +		if (!acpi_match_device_ids(device, acpi_platform_device_ids)) {
> >>> +			/* This is a known good platform device. */
> >>> +			acpi_create_platform_device(device);
> >>> +		} else {
> >>> +			int ret = device_attach(&device->dev);
> >>> +			acpi_hot_add_bind(device);
> >>> +			if (ret)
> >>> +				status = AE_CTRL_DEPTH;
> >>> +		}
> >>> +	} else if (ops->acpi_op_start) {
> >>> +		if (ACPI_FAILURE(acpi_start_single_object(device)))
> >>> +			status = AE_CTRL_DEPTH;
> >>> +	}
> >>> +	return status;
> >>> +}
> >>> +
> >>>  static int acpi_bus_scan(acpi_handle handle, struct acpi_bus_ops *ops,
> >>>  			 struct acpi_device **child)
> >>>  {
> >>> -	acpi_status status;
> >>>  	void *device = NULL;
> >>> +	acpi_status status;
> >>> +	int ret = 0;
> >>>  
> >>>  	status = acpi_bus_check_add(handle, 0, ops, &device);
> >>> -	if (ACPI_SUCCESS(status))
> >>> +	if (ACPI_FAILURE(status)) {
> >>> +		ret = -ENODEV;
> >>> +		goto out;
> >>> +	}
> >>> +
> >>> +	acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> >>> +			    acpi_bus_check_add, NULL, ops, &device);
> >>> +	if (device)
> >>>  		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> >>> -				    acpi_bus_check_add, NULL, ops, &device);
> >>> +				    acpi_bus_probe_start, NULL, ops, NULL);
> >> Hi Rafael,
> >> 	Should we call acpi_bus_probe_start for the top device corresponding to 
> >> "handle" too here?
> > 
> > Do you mean separately?  I don't think so.  It will be covered by the namespace
> > walking, won't it?
> Hi Rafael,
> 	According to test results from Yijing, we do need to call acpi_bus_probe_start
> for the top device corresponding to "handle".
> 	Comments for acpi_walk_namespace says:
> /*******************************************************************************
>  *
>  * FUNCTION:    acpi_walk_namespace
>  *
>  * DESCRIPTION: Performs a modified depth-first walk of the namespace tree,
>  *              starting (and ending) at the object specified by start_handle.
>                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  *              The callback function is called whenever an object that matches
>  *              the type parameter is found. If the callback function returns
>  *              a non-zero value, the search is terminated immediately and this
>  *              value is returned to the caller.
>  *
>  *              The point of this procedure is to provide a generic namespace
>  *              a non-zero value, the search is terminated immediately and this
>  *              value is returned to the caller.
>  *
>  *              The point of this procedure is to provide a generic namespace
>  *              walk routine that can be called from multiple places to
>  *              provide multiple services; the callback function(s) can be
>  *              tailored to each task, whether it is a print function,
>  *              a compare function, etc.
>  *
>  ******************************************************************************/
> 
> But acpi_ns_walk_namespace() doesn't really call the pre_order_visit and post_order_visit
> for the start_handle. That means acpi_walk_namespace won't call the callback for the top
> handle.

You are right.

I'll fix that and send updated series.  It looks like Bjorn wants me to rework
the changelogs anyway. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
