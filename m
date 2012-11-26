Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212Ab2KZRws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:52:48 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:18131 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab2KZRwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:52:32 -0500
Message-ID: <1353951848.26955.73.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 1/4] ACPI: Support system notify handler via
 .sys_notify
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com
Date: Mon, 26 Nov 2012 10:44:08 -0700
In-Reply-To: <1534747.XBnkTFzSlv@vostro.rjw.lan>
References: <1352406227-32629-1-git-send-email-toshi.kani@hp.com>
	 <1352406227-32629-2-git-send-email-toshi.kani@hp.com>
	 <1534747.XBnkTFzSlv@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Thanks for reviewing!  My comments are in-line.

On Sat, 2012-11-24 at 23:01 +0100, Rafael J. Wysocki wrote:
> On Thursday, November 08, 2012 01:23:44 PM Toshi Kani wrote:
> > Added a new .sys_notify interface, which allows ACPI drivers to
> > register their system-level (ex. hotplug) notify handlers through
> > their acpi_driver table.  This removes redundant ACPI namespace
> > walks from ACPI drivers for faster booting.
> > 
> > The global notify handler acpi_bus_notify() is called for all
> > system-level ACPI notifications, which then calls an appropriate
> > driver's handler if any.  ACPI drivers no longer need to register
> > or unregister driver's handler to each ACPI device object.  It also
> > supports dynamic ACPI namespace with LoadTable & Unload opcode
> > without any modification in ACPI drivers.
> > 
> > Added a common system notify handler acpi_bus_sys_notify(), which
> > allows ACPI drivers to set it to .sys_notify when this function is
> > fully implemented.
> 
> I don't really understand this.

Currently, acpi_bus_notify() is partially implemented as the common
notify handler, but it may not be fully implemented under the current
design.  When a notify event is sent, ACPICA calls both
acpi_bus_notify() and driver's handler registered through
acpi_install_notify_handler().  However, a same event cannot be handled
by both handlers.  Since acpi_bus_notify() may not know if an event has
already been handled by driver's handler, it cannot do anything that may
conflict with the driver's handler.

Therefore, the partially implemented common handler code in
acpi_bus_notify() is moved to a separate function acpi_bus_sys_notify()
in this patchset.  This function can now be fully implemented as
necessary.


> > It removes functional conflict between driver's
> > notify handler and the global notify handler acpi_bus_notify().
> > 
> > Note that the changes maintain backward compatibility for ACPI
> > drivers.  Any drivers registered their hotplug handler through the
> > existing interfaces, such as acpi_install_notify_handler() and
> > register_acpi_bus_notifier(), will continue to work as before.
> 
> I really wouldn't like to add new callbacks to struct acpi_device_ops, because
> I'd like that whole thing to go away entirely eventually, along with struct
> acpi_driver.

acpi_device may need to be changed, but I think ACPI drivers are still
necessary to support vendor-unique PNPIDs in an extendable way, which is
currently done by adding drivers, such as asus_acpi_driver,
cmpc_accel_acpi_driver, eeepc_acpi_driver, acpi_fujitsu_driver,
lis3lv02d_driver, etc...


> Moreover, in this particular case, it really is not useful to have to define
> a struct acpi_driver so that one can register for receiving system
> notifications from ACPI.  It would be really nice if non-ACPI drivers, such
> as PCI or platform, could do that too.
>
> Besides, acpi_os_execute_deferred() is always run on CPU0, because of some
> SMI-related peculiarity, which is not very efficient as far as the events
> handling is concerned, but we can improve the situation a bit by queing the
> execution of the registered handlers in a different workqueue.  Maybe it's
> worth considering if we're going to change this code anyway?

Will reply to other email.


> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > ---
> >  drivers/acpi/bus.c      | 64 ++++++++++++++++++++++++++++----------
> >  drivers/acpi/scan.c     | 83 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/acpi/acpi_bus.h |  6 ++++
> >  3 files changed, 137 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> > index 07a20ee..b256bcf2 100644
> > --- a/drivers/acpi/bus.c
> > +++ b/drivers/acpi/bus.c
> > @@ -779,21 +779,16 @@ void unregister_acpi_bus_notifier(struct notifier_block *nb)
> >  EXPORT_SYMBOL_GPL(unregister_acpi_bus_notifier);
> >  
> >  /**
> > - * acpi_bus_notify
> > - * ---------------
> > - * Callback for all 'system-level' device notifications (values 0x00-0x7F).
> > + * acpi_bus_sys_notify: Common system notify handler
> > + *
> > + * ACPI drivers may specify this common handler to its sys_notify entry.
> > + * TBD: This handler is not implemented yet.
> >   */
> > -static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
> > +void acpi_bus_sys_notify(acpi_handle handle, u32 type, void *data)
> 
> This isn't used anywhere.  Are drivers supposed to use it?  If so, what about
> the BUS_CHECK and DEVICE_CHECK notifications?

This function is not fully implemented yet, as explained above.  This
patchset only fixed the current structural issue.  So, drivers are not
supposed to use it now.


> >  {
> > -	struct acpi_device *device = NULL;
> > -	struct acpi_driver *driver;
> > -
> >  	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Notification %#02x to handle %p\n",
> >  			  type, handle));
> >  
> > -	blocking_notifier_call_chain(&acpi_bus_notify_list,
> > -		type, (void *)handle);
> > -
> >  	switch (type) {
> >  
> >  	case ACPI_NOTIFY_BUS_CHECK:
> > @@ -842,14 +837,51 @@ static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
> >  				  type));
> >  		break;
> >  	}
> > +}
> > +
> > +/**
> > + * acpi_bus_drv_notify: Call driver's system-level notify handler
> > + */
> > +void acpi_bus_drv_notify(struct acpi_driver *driver,
> > +		struct acpi_device *device, acpi_handle handle,
> > +		u32 type, void *data)
> > +{
> > +	BUG_ON(!driver);
> 
> Rule: Don't crash the kernel if you don't have to.  Try to recover instead.
> 
> It seems that
> 
> if (WARN_ON(!driver))
> 	return;
> 
> would be sufficient in this particulare case, wouldn't it?

Agreed.


> > +
> > +	if (driver->ops.sys_notify)
> > +		driver->ops.sys_notify(handle, type, data);
> > +	else if (device && driver->ops.notify &&
> 
> Why "else if"?  The existing code does this unconditionally.  Is that incorrect?

Good point.  I agree that this should be changed to "if".
ACPI_DRIVER_ALL_NOTIFY_EVENTS could be deprecated after .sys_notify is
added, though.


> > +		 (driver->flags & ACPI_DRIVER_ALL_NOTIFY_EVENTS))
> > +		driver->ops.notify(device, type);
> > +
> > +	return;
> > +}
> > +
> > +/**
> > + * acpi_bus_notify: The system-level global notify handler
> > + *
> > + * The global notify handler for all 'system-level' device notifications
> > + * (values 0x00-0x7F).  This handler calls a driver's notify handler for
> > + * the notified ACPI device.
> > + */
> > +static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
> > +{
> > +	struct acpi_device *device = NULL;
> > +
> > +	/* call registered handlers in the bus notify list */
> > +	blocking_notifier_call_chain(&acpi_bus_notify_list,
> > +						type, (void *)handle);
> >  
> > +	/* obtain an associated driver if already bound */
> >  	acpi_bus_get_device(handle, &device);
> > -	if (device) {
> > -		driver = device->driver;
> > -		if (driver && driver->ops.notify &&
> > -		    (driver->flags & ACPI_DRIVER_ALL_NOTIFY_EVENTS))
> > -			driver->ops.notify(device, type);
> > -	}
> > +
> > +	/* call the driver's system-level notify handler */
> > +	if (device && device->driver)
> > +		acpi_bus_drv_notify(device->driver, device, handle, type, data);
> > +	else
> > +		acpi_lookup_drv_notify(handle, type, data);
> > +
> > +	return;
> >  }
> >  
> >  /* --------------------------------------------------------------------------
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index 95ff1e8..333e57f 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -1758,3 +1758,86 @@ int __init acpi_scan_init(void)
> >  
> >  	return result;
> >  }
> > +
> > +/* callback args for acpi_match_drv_notify() */
> > +struct acpi_notify_args {
> > +	struct acpi_device	*device;
> > +	acpi_handle		handle;
> > +	u32			event;
> > +	void			*data;
> > +};
> > +
> > +static int acpi_match_drv_notify(struct device_driver *drv, void *data)
> > +{
> > +	struct acpi_driver *driver = to_acpi_driver(drv);
> > +	struct acpi_notify_args *args = (struct acpi_notify_args *) data;
> > +
> > +	/* check if this driver matches with the device */
> > +	if (acpi_match_device_ids(args->device, driver->ids))
> > +		return 0;
> > +
> > +	/* call the driver's notify handler */
> > +	acpi_bus_drv_notify(driver, NULL, args->handle,
> > +					args->event, args->data);
> > +
> > +	return 1;
> > +}
> > +
> > +/**
> > + * acpi_lookup_drv_notify: Look up and call driver's notify handler
> > + * @handle: ACPI handle of the notified device object
> > + * @event: Notify event
> > + * @data: Context
> > + *
> > + * Look up and call the associated driver's notify handler for the ACPI
> > + * device object by walking through the list of ACPI drivers.
> 
> What exactly is the purpose of this?

For hot-add, an acpi_device object is not created for the notified
object yet.  Therefore, acpi_bus_notify() calls this function to find an
associated driver for the device.  It walks thru the ACPI driver list to
find a matching driver.  


> > + */
> > +void acpi_lookup_drv_notify(acpi_handle handle, u32 event, void *data)
> > +{
> > +	struct acpi_notify_args args;
> > +	struct acpi_device *device;
> > +	unsigned long long sta;
> > +	int type;
> > +	int ret;
> > +
> > +	/* allocate a temporary device object */
> > +	device = kzalloc(sizeof(struct acpi_device), GFP_KERNEL);
> > +	if (!device) {
> > +		pr_err(PREFIX "No memory to allocate a tmp device\n");
> > +		return;
> > +	}
> > +	INIT_LIST_HEAD(&device->pnp.ids);
> > +
> > +	/* obtain device type */
> > +	ret = acpi_bus_type_and_status(handle, &type, &sta);
> > +	if (ret) {
> > +		pr_err(PREFIX "Failed to get device type\n");
> > +		goto out;
> > +	}
> > +
> > +	/* setup this temporary device object */
> > +	device->device_type = type;
> > +	device->handle = handle;
> > +	device->parent = acpi_bus_get_parent(handle);
> > +	device->dev.bus = &acpi_bus_type;
> > +	device->driver = NULL;
> > +	STRUCT_TO_INT(device->status) = sta;
> > +	device->status.present = 1;
> > +
> > +	/* set HID to this device object */
> > +	acpi_device_set_id(device);
> > +
> > +	/* set args */
> > +	args.device = device;
> > +	args.handle = handle;
> > +	args.event = event;
> > +	args.data = data;
> > +
> > +	/* call a matched driver's notify handler */
> > +	(void) bus_for_each_drv(device->dev.bus, NULL,
> > +					&args, acpi_match_drv_notify);
> 
> Excuse me?  What makes you think I would accept anything like this?

Sorry, I admit that allocating a temporary acpi_device object is a hack
since acpi_device_set_id() requires it.  I tried to change
acpi_device_set_id(), but it needed more changes than I expected.  I can
try to clean this up, if the overall design still makes sense.


Thanks,
-Toshi


> > +
> > +out:
> > +	acpi_device_release(&device->dev);
> > +	return;
> > +}
> > diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> > index 2242c10..4052406 100644
> > --- a/include/acpi/acpi_bus.h
> > +++ b/include/acpi/acpi_bus.h
> > @@ -94,6 +94,7 @@ typedef int (*acpi_op_start) (struct acpi_device * device);
> >  typedef int (*acpi_op_bind) (struct acpi_device * device);
> >  typedef int (*acpi_op_unbind) (struct acpi_device * device);
> >  typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
> > +typedef void (*acpi_op_sys_notify) (acpi_handle handle, u32 event, void *data);
> >  
> >  struct acpi_bus_ops {
> >  	u32 acpi_op_add:1;
> > @@ -107,6 +108,7 @@ struct acpi_device_ops {
> >  	acpi_op_bind bind;
> >  	acpi_op_unbind unbind;
> >  	acpi_op_notify notify;
> > +	acpi_op_sys_notify sys_notify;
> >  };
> >  
> >  #define ACPI_DRIVER_ALL_NOTIFY_EVENTS	0x1	/* system AND device events */
> > @@ -328,6 +330,10 @@ extern int unregister_acpi_notifier(struct notifier_block *);
> >  
> >  extern int register_acpi_bus_notifier(struct notifier_block *nb);
> >  extern void unregister_acpi_bus_notifier(struct notifier_block *nb);
> > +extern void acpi_lookup_drv_notify(acpi_handle handle, u32 event, void *data);
> > +extern void acpi_bus_drv_notify(struct acpi_driver *driver,
> > +	struct acpi_device *device, acpi_handle handle, u32 type, void *data);
> > +
> >  /*
> >   * External Functions
> >   */
> > 
> 
> Thanks,
> Rafael
> 
> 


