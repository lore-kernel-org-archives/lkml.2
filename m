Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab2LRQTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 11:19:50 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:29001 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab2LRQTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 11:19:48 -0500
Message-ID: <1355847041.18964.369.camel@misato.fc.hp.com>
Subject: Re: [PATCH rev.2 1/6] ACPI: Separate adding ACPI device objects
 from probing ACPI drivers
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Date: Tue, 18 Dec 2012 09:10:41 -0700
In-Reply-To: <4082842.31rfDviYHK@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan>
	 <1525730.exQ7msTINR@vostro.rjw.lan>
	 <1355789297.18964.334.camel@misato.fc.hp.com>
	 <4082842.31rfDviYHK@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-18 at 02:48 +0100, Rafael J. Wysocki wrote:
> On Monday, December 17, 2012 05:08:17 PM Toshi Kani wrote:
> > On Thu, 2012-12-13 at 23:17 +0100, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > 
> > (snip)
> > 
> > >  struct acpi_device_ops {
> > > Index: linux/drivers/acpi/scan.c
> > > ===================================================================
> > > --- linux.orig/drivers/acpi/scan.c
> > > +++ linux/drivers/acpi/scan.c
> > > @@ -494,7 +494,8 @@ static int acpi_bus_match(struct device
> > >  	struct acpi_device *acpi_dev = to_acpi_device(dev);
> > >  	struct acpi_driver *acpi_drv = to_acpi_driver(drv);
> > >  
> > > -	return !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
> > > +	return acpi_dev->bus_ops.acpi_op_match
> > > +		&& !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
> > >  }
> > >  
> > >  static int acpi_device_uevent(struct device *dev, struct kobj_uevent_env *env)
> > > @@ -1418,6 +1419,17 @@ static int acpi_bus_remove(struct acpi_d
> > >  	return 0;
> > >  }
> > >  
> > > +/*
> > > + * acpi_hot_add_bind - Bind _ADR-based devices on hot-add.
> > > + * @device: ACPI device node to bind.
> > > + */
> > > +static void acpi_hot_add_bind(struct acpi_device *device)
> > > +{
> > > +	if (device->flags.bus_address
> > > +	    && device->parent && device->parent->ops.bind)
> > > +		device->parent->ops.bind(device);
> > > +}
> > > +
> > >  static int acpi_add_single_object(struct acpi_device **child,
> > >  				  acpi_handle handle, int type,
> > >  				  unsigned long long sta,
> > > @@ -1490,13 +1502,8 @@ static int acpi_add_single_object(struct
> > >  
> > >  	result = acpi_device_register(device);
> > >  
> > > -	/*
> > > -	 * Bind _ADR-Based Devices when hot add
> > > -	 */
> > > -	if (device->flags.bus_address) {
> > > -		if (device->parent && device->parent->ops.bind)
> > > -			device->parent->ops.bind(device);
> > > -	}
> > 
> > I think the original code above is hot-add only because ops.bind is not
> > set at boot since the acpi_pci driver has not been registered yet.  It
> > seems that acpi_pci_bridge_scan() called from acpi_pci_root_add() takes
> > care of the binding.
> 
> Ah, I see the problem.  During boot the PCI root bridge driver is not present
> yet when all struct acpi_device "devices" are registered, so their parents'
> .bind() callbacks are all empty, so the code above has no effect.
> 
> But say we're doing a PCI root bridge hotplug, in which case the driver is
> present, so acpi_pci_bind() will be executed both from acpi_pci_bridge_scan()
> and from here, won't it?

Right.


> OK, this needs to be addressed.
> 
> > This brings me a question for acpi_bus_probe_start() below...
> > 
> > 
> > > +	if (device->bus_ops.acpi_op_match)
> > > +		acpi_hot_add_bind(device);
> > >  
> > >  end:
> > >  	if (!result) {
> > > @@ -1522,6 +1529,7 @@ static void acpi_bus_add_power_resource(
> > >  	struct acpi_bus_ops ops = {
> > >  		.acpi_op_add = 1,
> > >  		.acpi_op_start = 1,
> > > +		.acpi_op_match = 1,
> > >  	};
> > >  	struct acpi_device *device = NULL;
> > >  
> > > @@ -1574,9 +1582,9 @@ static acpi_status acpi_bus_check_add(ac
> > >  				      void *context, void **return_value)
> > >  {
> > >  	struct acpi_bus_ops *ops = context;
> > > +	struct acpi_device *device = NULL;
> > >  	int type;
> > >  	unsigned long long sta;
> > > -	struct acpi_device *device;
> > >  	acpi_status status;
> > >  	int result;
> > >  
> > > @@ -1596,52 +1604,86 @@ static acpi_status acpi_bus_check_add(ac
> > >  		return AE_CTRL_DEPTH;
> > >  	}
> > >  
> > > -	/*
> > > -	 * We may already have an acpi_device from a previous enumeration.  If
> > > -	 * so, we needn't add it again, but we may still have to start it.
> > > -	 */
> > > -	device = NULL;
> > >  	acpi_bus_get_device(handle, &device);
> > >  	if (ops->acpi_op_add && !device) {
> > > -		acpi_add_single_object(&device, handle, type, sta, ops);
> > > -		/* Is the device a known good platform device? */
> > > -		if (device
> > > -		    && !acpi_match_device_ids(device, acpi_platform_device_ids))
> > > -			acpi_create_platform_device(device);
> > > -	}
> > > -
> > > -	if (!device)
> > > -		return AE_CTRL_DEPTH;
> > > +		struct acpi_bus_ops add_ops = *ops;
> > >  
> > > -	if (ops->acpi_op_start && !(ops->acpi_op_add)) {
> > > -		status = acpi_start_single_object(device);
> > > -		if (ACPI_FAILURE(status))
> > > +		add_ops.acpi_op_match = 0;
> > > +		acpi_add_single_object(&device, handle, type, sta, &add_ops);
> > > +		if (!device)
> > >  			return AE_CTRL_DEPTH;
> > > +
> > > +		device->bus_ops.acpi_op_match = 1;
> > >  	}
> > >  
> > >  	if (!*return_value)
> > >  		*return_value = device;
> > > +
> > >  	return AE_OK;
> > >  }
> > >  
> > > +static acpi_status acpi_bus_probe_start(acpi_handle handle, u32 lvl,
> > > +					void *context, void **not_used)
> > > +{
> > > +	struct acpi_bus_ops *ops = context;
> > > +	acpi_status status = AE_OK;
> > > +	struct acpi_device *device;
> > > +	unsigned long long sta_not_used;
> > > +	int type_not_used;
> > > +
> > > +	/*
> > > +	 * Ignore errors ignored by acpi_bus_check_add() to avoid terminating
> > 
> > "ignore" seems duplicated. 
>  
> It is not.  This is supposed to mean that the errors previously ignored by
> acpi_bus_check_add() should be ignored here as well.

Oh, I see.  Thanks for the clarification.


> > > +	 * namespace walks prematurely.
> > > +	 */
> > > +	if (acpi_bus_type_and_status(handle, &type_not_used, &sta_not_used))
> > > +		return AE_OK;
> > > +
> > > +	if (acpi_bus_get_device(handle, &device))
> > > +		return AE_CTRL_DEPTH;
> > > +
> > > +	if (ops->acpi_op_add) {
> > > +		if (!acpi_match_device_ids(device, acpi_platform_device_ids)) {
> > > +			/* This is a known good platform device. */
> > > +			acpi_create_platform_device(device);
> > > +		} else {
> > > +			int ret = device_attach(&device->dev);
> > > +			acpi_hot_add_bind(device);
> > 
> > Since acpi_pci_root_add() is called by device_attach(), I think this
> > acpi_hot_add_bind() calls .bind() of a device at boot since its .bind()
> > may be set.  Is that correct?  If so, how does it coordinate with the
> > bind procedure in acpi_pci_bridge_scan()?
> 
> It actually doesn't.
> 
> However, the $subject patch doesn't change this particular aspect of the
> original behavior, because with it applied the PCI root bridge driver is still
> not present when the device_attach() above is executed for all objects in the
> given namespace scope, so the .bind() callbacks should all be empty.  In other
> words, it doesn't change the boot case.
> 
> It also reproduces the original behavior in the hotplug case which may not be
> correct.  Patch [2/6], however, kind of changes the boot case into the hotplug
> case and things start to get ugly.

Yes, I was concerned with the behavior when patch [2/6] applied.  It is
actually a good thing that this hotplug issue is now exposed in the boot
path.  This means that boot and hot-add paths are consistent.  So, we
just need to fix it.


> Well, what about calling acpi_hot_add_bind() from acpi_bus_check_add(),
> right after doing the acpi_add_single_object()?  It would avoid calling
> acpi_pci_bind() twice for the same device during root bridge hotplug too,
> because in that case acpi_pci_root_add() will be called after all of these
> acpi_hot_add_bind() calls.  At the same time if a single device is
> hot-added and its parent happens to have .bind() set, it will be run
> from acpi_bus_check_add().

I may be missing something here, but in case of root bridge hot-add, I
think acpi_pci_root_add() still calls .bind() after acpi_bus_check_add()
called it.  So, it's called twice, isn't it? 

We need to decide which module is responsible for calling .bind().  I
think it should be the ACPI scan module, not the ACPI PCI root bridge
driver, because:

 - bind() needs to be called when _ADR device is added.  The ACPI scan
module can scan any devices, while the PCI root driver can only scan
when it is added.
 - acpi_bus_remove() calls unbind() at hot-remove.  The same module
should be responsible for both bind() and unbind() handling.
 - It is cleaner to keep struct acpi_device_ops interface to be called
by the ACPI core.

So, I would propose the following changes.

 - Move the acpi_hot_add_bind() call back to the original place after
the device_attach() call.
 - Rename the name of acpi_hot_add_bind() to something like
acpi_bind_adr_device() since it is no longer hot-add only (and is
specific to _ADR devices).
 - Create its pair function, acpi_unbind_adr_device(), which is called
from acpi_bus_remove().  When a constructor interface is introduced, its
destructor should be introduced as well. 
 - Remove the binding procedure from acpi_pci_root_add().  This should
be done in patch [2/6].

Thanks,
-Toshi

