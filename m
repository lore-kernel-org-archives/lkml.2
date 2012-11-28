Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab2K1AYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 19:24:37 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34771 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab2K1AYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 19:24:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-acpi@vger.kernel.org
Cc: Toshi Kani <toshi.kani@hp.com>, lenb@kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com
Subject: Re: [PATCH v3 1/4] ACPI: Support system notify handler via .sys_notify
Date: Wed, 28 Nov 2012 01:29:18 +0100
Message-ID: <4386143.a25EdxFGm5@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353951848.26955.73.camel@misato.fc.hp.com>
References: <1352406227-32629-1-git-send-email-toshi.kani@hp.com> <1534747.XBnkTFzSlv@vostro.rjw.lan> <1353951848.26955.73.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 26, 2012 10:44:08 AM Toshi Kani wrote:
> Hi Rafael,
> 
> Thanks for reviewing!  My comments are in-line.
> 
> On Sat, 2012-11-24 at 23:01 +0100, Rafael J. Wysocki wrote:
> > On Thursday, November 08, 2012 01:23:44 PM Toshi Kani wrote:
> > > Added a new .sys_notify interface, which allows ACPI drivers to
> > > register their system-level (ex. hotplug) notify handlers through
> > > their acpi_driver table.  This removes redundant ACPI namespace
> > > walks from ACPI drivers for faster booting.
> > > 
> > > The global notify handler acpi_bus_notify() is called for all
> > > system-level ACPI notifications, which then calls an appropriate
> > > driver's handler if any.  ACPI drivers no longer need to register
> > > or unregister driver's handler to each ACPI device object.  It also
> > > supports dynamic ACPI namespace with LoadTable & Unload opcode
> > > without any modification in ACPI drivers.
> > > 
> > > Added a common system notify handler acpi_bus_sys_notify(), which
> > > allows ACPI drivers to set it to .sys_notify when this function is
> > > fully implemented.
> > 
> > I don't really understand this.
> 
> Currently, acpi_bus_notify() is partially implemented as the common
> notify handler, but it may not be fully implemented under the current
> design.  When a notify event is sent, ACPICA calls both
> acpi_bus_notify() and driver's handler registered through
> acpi_install_notify_handler().  However, a same event cannot be handled
> by both handlers.

Yes, it can, as long as they don't do conflicting things. :-)

Usually, the event will be discarded by one of them.

> Since acpi_bus_notify() may not know if an event has
> already been handled by driver's handler, it cannot do anything that may
> conflict with the driver's handler.

Not really.  acpi_bus_notify() is always called first, so it actually
knows that no one has done anything with that event before.  However,
it doesn't know who else will be called for the same event going
forward.

But I agree, acpi_bus_notify() shouldn't register for the same types of
events that are handled by drivers individually.  And we may not need
acpi_bus_notify() at all as far as I can say at the moment.

> Therefore, the partially implemented common handler code in
> acpi_bus_notify() is moved to a separate function acpi_bus_sys_notify()
> in this patchset.  This function can now be fully implemented as
> necessary.

Not really, because notifiers that don't use it may be called for the
same events.

> > > It removes functional conflict between driver's
> > > notify handler and the global notify handler acpi_bus_notify().
> > > 
> > > Note that the changes maintain backward compatibility for ACPI
> > > drivers.  Any drivers registered their hotplug handler through the
> > > existing interfaces, such as acpi_install_notify_handler() and
> > > register_acpi_bus_notifier(), will continue to work as before.
> > 
> > I really wouldn't like to add new callbacks to struct acpi_device_ops, because
> > I'd like that whole thing to go away entirely eventually, along with struct
> > acpi_driver.
> 
> acpi_device may need to be changed, but I think ACPI drivers are still
> necessary to support vendor-unique PNPIDs in an extendable way, which is
> currently done by adding drivers, such as asus_acpi_driver,
> cmpc_accel_acpi_driver, eeepc_acpi_driver, acpi_fujitsu_driver,
> lis3lv02d_driver, etc...

Well, not really.  Handling different PNPIDs has nothing to do with ACPI
drivers.  You only need a way for drivers in general to specify the ACPI
device IDs they can handle.  And after som changes that are waiting for the
v3.8 merge windown you'll be able to add a list of ACPI device IDs to other
types of drivers too (like platform drivers for one example).

[...]

> > > +
> > > +/* callback args for acpi_match_drv_notify() */
> > > +struct acpi_notify_args {
> > > +	struct acpi_device	*device;
> > > +	acpi_handle		handle;
> > > +	u32			event;
> > > +	void			*data;
> > > +};
> > > +
> > > +static int acpi_match_drv_notify(struct device_driver *drv, void *data)
> > > +{
> > > +	struct acpi_driver *driver = to_acpi_driver(drv);
> > > +	struct acpi_notify_args *args = (struct acpi_notify_args *) data;
> > > +
> > > +	/* check if this driver matches with the device */
> > > +	if (acpi_match_device_ids(args->device, driver->ids))
> > > +		return 0;
> > > +
> > > +	/* call the driver's notify handler */
> > > +	acpi_bus_drv_notify(driver, NULL, args->handle,
> > > +					args->event, args->data);
> > > +
> > > +	return 1;
> > > +}
> > > +
> > > +/**
> > > + * acpi_lookup_drv_notify: Look up and call driver's notify handler
> > > + * @handle: ACPI handle of the notified device object
> > > + * @event: Notify event
> > > + * @data: Context
> > > + *
> > > + * Look up and call the associated driver's notify handler for the ACPI
> > > + * device object by walking through the list of ACPI drivers.
> > 
> > What exactly is the purpose of this?
> 
> For hot-add, an acpi_device object is not created for the notified
> object yet.  Therefore, acpi_bus_notify() calls this function to find an
> associated driver for the device.  It walks thru the ACPI driver list to
> find a matching driver.  

This is just broken and not only because you're creating a struct acpi_device
object on the fly in there.

> > > + */
> > > +void acpi_lookup_drv_notify(acpi_handle handle, u32 event, void *data)
> > > +{
> > > +	struct acpi_notify_args args;
> > > +	struct acpi_device *device;
> > > +	unsigned long long sta;
> > > +	int type;
> > > +	int ret;
> > > +
> > > +	/* allocate a temporary device object */
> > > +	device = kzalloc(sizeof(struct acpi_device), GFP_KERNEL);
> > > +	if (!device) {
> > > +		pr_err(PREFIX "No memory to allocate a tmp device\n");
> > > +		return;
> > > +	}
> > > +	INIT_LIST_HEAD(&device->pnp.ids);
> > > +
> > > +	/* obtain device type */
> > > +	ret = acpi_bus_type_and_status(handle, &type, &sta);
> > > +	if (ret) {
> > > +		pr_err(PREFIX "Failed to get device type\n");
> > > +		goto out;
> > > +	}
> > > +
> > > +	/* setup this temporary device object */
> > > +	device->device_type = type;
> > > +	device->handle = handle;
> > > +	device->parent = acpi_bus_get_parent(handle);
> > > +	device->dev.bus = &acpi_bus_type;
> > > +	device->driver = NULL;
> > > +	STRUCT_TO_INT(device->status) = sta;
> > > +	device->status.present = 1;
> > > +
> > > +	/* set HID to this device object */
> > > +	acpi_device_set_id(device);
> > > +
> > > +	/* set args */
> > > +	args.device = device;
> > > +	args.handle = handle;
> > > +	args.event = event;
> > > +	args.data = data;
> > > +
> > > +	/* call a matched driver's notify handler */
> > > +	(void) bus_for_each_drv(device->dev.bus, NULL,
> > > +					&args, acpi_match_drv_notify);
> > 
> > Excuse me?  What makes you think I would accept anything like this?
> 
> Sorry, I admit that allocating a temporary acpi_device object is a hack
> since acpi_device_set_id() requires it.  I tried to change
> acpi_device_set_id(), but it needed more changes than I expected.  I can
> try to clean this up, if the overall design still makes sense.

No, it doesn't.  It is not correct to look for a random driver that happens to
match your handle from within a notification handler and call a notify method
from it.  It's just bad design and please don't do that.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
