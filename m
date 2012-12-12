Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab2LLW15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:27:57 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59054 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab2LLW1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:27:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH 1/6] ACPI: Separate adding ACPI device objects from probing ACPI drivers
Date: Wed, 12 Dec 2012 23:32:57 +0100
Message-ID: <2789050.ITilpEgQsC@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50C8B2E9.5050700@gmail.com>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <4002729.BbipMAJtM0@vostro.rjw.lan> <50C8B2E9.5050700@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 13, 2012 12:38:01 AM Jiang Liu wrote:
> On 12/10/2012 07:00 AM, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Currently, as soon as an ACPI device node object (struct acpi_device)
> snip
>   
> > @@ -1600,48 +1608,77 @@ static acpi_status acpi_bus_check_add(ac
> >  	 * We may already have an acpi_device from a previous enumeration.  If
> >  	 * so, we needn't add it again, but we may still have to start it.
> >  	 */
> > -	device = NULL;
> >  	acpi_bus_get_device(handle, &device);
> >  	if (ops->acpi_op_add && !device) {
> > -		acpi_add_single_object(&device, handle, type, sta, ops);
> > -		/* Is the device a known good platform device? */
> > -		if (device
> > -		    && !acpi_match_device_ids(device, acpi_platform_device_ids))
> > -			acpi_create_platform_device(device);
> > -	}
> > +		struct acpi_bus_ops add_ops = *ops;
> >  
> > -	if (!device)
> > -		return AE_CTRL_DEPTH;
> > -
> > -	if (ops->acpi_op_start && !(ops->acpi_op_add)) {
> > -		status = acpi_start_single_object(device);
> > -		if (ACPI_FAILURE(status))
> > +		add_ops.acpi_op_match = 0;
> > +		acpi_add_single_object(&device, handle, type, sta, &add_ops);
> > +		if (!device)
> >  			return AE_CTRL_DEPTH;
> > +
> > +		device->bus_ops.acpi_op_match = 1;
> >  	}
> >  
> >  	if (!*return_value)
> >  		*return_value = device;
> > +
> >  	return AE_OK;
> >  }
> >  
> > +static acpi_status acpi_bus_probe_start(acpi_handle handle, u32 lvl,
> > +					void *context, void **not_used)
> > +{
> > +	struct acpi_bus_ops *ops = context;
> > +	struct acpi_device *device;
> > +	acpi_status status = AE_OK;
> > +
> > +	if (acpi_bus_get_device(handle, &device))
> > +		return AE_CTRL_DEPTH;
> > +
> > +	if (ops->acpi_op_add) {
> > +		if (!acpi_match_device_ids(device, acpi_platform_device_ids)) {
> > +			/* This is a known good platform device. */
> > +			acpi_create_platform_device(device);
> > +		} else {
> > +			int ret = device_attach(&device->dev);
> > +			acpi_hot_add_bind(device);
> > +			if (ret)
> > +				status = AE_CTRL_DEPTH;
> > +		}
> > +	} else if (ops->acpi_op_start) {
> > +		if (ACPI_FAILURE(acpi_start_single_object(device)))
> > +			status = AE_CTRL_DEPTH;
> > +	}
> > +	return status;
> > +}
> > +
> >  static int acpi_bus_scan(acpi_handle handle, struct acpi_bus_ops *ops,
> >  			 struct acpi_device **child)
> >  {
> > -	acpi_status status;
> >  	void *device = NULL;
> > +	acpi_status status;
> > +	int ret = 0;
> >  
> >  	status = acpi_bus_check_add(handle, 0, ops, &device);
> > -	if (ACPI_SUCCESS(status))
> > +	if (ACPI_FAILURE(status)) {
> > +		ret = -ENODEV;
> > +		goto out;
> > +	}
> > +
> > +	acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> > +			    acpi_bus_check_add, NULL, ops, &device);
> > +	if (device)
> >  		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> > -				    acpi_bus_check_add, NULL, ops, &device);
> > +				    acpi_bus_probe_start, NULL, ops, NULL);
> Hi Rafael,
> 	Should we call acpi_bus_probe_start for the top device corresponding to 
> "handle" too here?

Do you mean separately?  I don't think so.  It will be covered by the namespace
walking, won't it?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
