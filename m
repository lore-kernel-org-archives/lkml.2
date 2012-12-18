Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab2LRBm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:42:56 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36500 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841Ab2LRBmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:42:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH rev.2 1/6] ACPI: Separate adding ACPI device objects from probing ACPI drivers
Date: Tue, 18 Dec 2012 02:48:04 +0100
Message-ID: <4082842.31rfDviYHK@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1355789297.18964.334.camel@misato.fc.hp.com>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <1525730.exQ7msTINR@vostro.rjw.lan> <1355789297.18964.334.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 17, 2012 05:08:17 PM Toshi Kani wrote:
> On Thu, 2012-12-13 at 23:17 +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> 
> (snip)
> 
> >  struct acpi_device_ops {
> > Index: linux/drivers/acpi/scan.c
> > ===================================================================
> > --- linux.orig/drivers/acpi/scan.c
> > +++ linux/drivers/acpi/scan.c
> > @@ -494,7 +494,8 @@ static int acpi_bus_match(struct device
> >  	struct acpi_device *acpi_dev = to_acpi_device(dev);
> >  	struct acpi_driver *acpi_drv = to_acpi_driver(drv);
> >  
> > -	return !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
> > +	return acpi_dev->bus_ops.acpi_op_match
> > +		&& !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
> >  }
> >  
> >  static int acpi_device_uevent(struct device *dev, struct kobj_uevent_env *env)
> > @@ -1418,6 +1419,17 @@ static int acpi_bus_remove(struct acpi_d
> >  	return 0;
> >  }
> >  
> > +/*
> > + * acpi_hot_add_bind - Bind _ADR-based devices on hot-add.
> > + * @device: ACPI device node to bind.
> > + */
> > +static void acpi_hot_add_bind(struct acpi_device *device)
> > +{
> > +	if (device->flags.bus_address
> > +	    && device->parent && device->parent->ops.bind)
> > +		device->parent->ops.bind(device);
> > +}
> > +
> >  static int acpi_add_single_object(struct acpi_device **child,
> >  				  acpi_handle handle, int type,
> >  				  unsigned long long sta,
> > @@ -1490,13 +1502,8 @@ static int acpi_add_single_object(struct
> >  
> >  	result = acpi_device_register(device);
> >  
> > -	/*
> > -	 * Bind _ADR-Based Devices when hot add
> > -	 */
> > -	if (device->flags.bus_address) {
> > -		if (device->parent && device->parent->ops.bind)
> > -			device->parent->ops.bind(device);
> > -	}
> 
> I think the original code above is hot-add only because ops.bind is not
> set at boot since the acpi_pci driver has not been registered yet.  It
> seems that acpi_pci_bridge_scan() called from acpi_pci_root_add() takes
> care of the binding.

Ah, I see the problem.  During boot the PCI root bridge driver is not present
yet when all struct acpi_device "devices" are registered, so their parents'
.bind() callbacks are all empty, so the code above has no effect.

But say we're doing a PCI root bridge hotplug, in which case the driver is
present, so acpi_pci_bind() will be executed both from acpi_pci_bridge_scan()
and from here, won't it?

OK, this needs to be addressed.

> This brings me a question for acpi_bus_probe_start() below...
> 
> 
> > +	if (device->bus_ops.acpi_op_match)
> > +		acpi_hot_add_bind(device);
> >  
> >  end:
> >  	if (!result) {
> > @@ -1522,6 +1529,7 @@ static void acpi_bus_add_power_resource(
> >  	struct acpi_bus_ops ops = {
> >  		.acpi_op_add = 1,
> >  		.acpi_op_start = 1,
> > +		.acpi_op_match = 1,
> >  	};
> >  	struct acpi_device *device = NULL;
> >  
> > @@ -1574,9 +1582,9 @@ static acpi_status acpi_bus_check_add(ac
> >  				      void *context, void **return_value)
> >  {
> >  	struct acpi_bus_ops *ops = context;
> > +	struct acpi_device *device = NULL;
> >  	int type;
> >  	unsigned long long sta;
> > -	struct acpi_device *device;
> >  	acpi_status status;
> >  	int result;
> >  
> > @@ -1596,52 +1604,86 @@ static acpi_status acpi_bus_check_add(ac
> >  		return AE_CTRL_DEPTH;
> >  	}
> >  
> > -	/*
> > -	 * We may already have an acpi_device from a previous enumeration.  If
> > -	 * so, we needn't add it again, but we may still have to start it.
> > -	 */
> > -	device = NULL;
> >  	acpi_bus_get_device(handle, &device);
> >  	if (ops->acpi_op_add && !device) {
> > -		acpi_add_single_object(&device, handle, type, sta, ops);
> > -		/* Is the device a known good platform device? */
> > -		if (device
> > -		    && !acpi_match_device_ids(device, acpi_platform_device_ids))
> > -			acpi_create_platform_device(device);
> > -	}
> > -
> > -	if (!device)
> > -		return AE_CTRL_DEPTH;
> > +		struct acpi_bus_ops add_ops = *ops;
> >  
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
> > +	acpi_status status = AE_OK;
> > +	struct acpi_device *device;
> > +	unsigned long long sta_not_used;
> > +	int type_not_used;
> > +
> > +	/*
> > +	 * Ignore errors ignored by acpi_bus_check_add() to avoid terminating
> 
> "ignore" seems duplicated. 
 
It is not.  This is supposed to mean that the errors previously ignored by
acpi_bus_check_add() should be ignored here as well.

> > +	 * namespace walks prematurely.
> > +	 */
> > +	if (acpi_bus_type_and_status(handle, &type_not_used, &sta_not_used))
> > +		return AE_OK;
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
> 
> Since acpi_pci_root_add() is called by device_attach(), I think this
> acpi_hot_add_bind() calls .bind() of a device at boot since its .bind()
> may be set.  Is that correct?  If so, how does it coordinate with the
> bind procedure in acpi_pci_bridge_scan()?

It actually doesn't.

However, the $subject patch doesn't change this particular aspect of the
original behavior, because with it applied the PCI root bridge driver is still
not present when the device_attach() above is executed for all objects in the
given namespace scope, so the .bind() callbacks should all be empty.  In other
words, it doesn't change the boot case.

It also reproduces the original behavior in the hotplug case which may not be
correct.  Patch [2/6], however, kind of changes the boot case into the hotplug
case and things start to get ugly.

Well, what about calling acpi_hot_add_bind() from acpi_bus_check_add(),
right after doing the acpi_add_single_object()?  It would avoid calling
acpi_pci_bind() twice for the same device during root bridge hotplug too,
because in that case acpi_pci_root_add() will be called after all of these
acpi_hot_add_bind() calls.  At the same time if a single device is
hot-added and its parent happens to have .bind() set, it will be run
from acpi_bus_check_add().

Updated patch is appended.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI: Separate adding ACPI device objects from probing ACPI drivers

Split the ACPI namespace scanning for devices into two passes, such
that struct acpi_device objects are registerd in the first pass
without probing ACPI drivers and the drivers are probed against them
directly in the second pass.

There are two main reasons for doing that.

First, the ACPI PCI root bridge driver's .add() routine,
acpi_pci_root_add(), causes struct pci_dev objects to be created for
all PCI devices under the given root bridge.  Usually, there are
corresponding ACPI device nodes in the ACPI namespace for some of
those devices and therefore there should be "companion" struct
acpi_device objects to attach those struct pci_dev objects to.  These
struct acpi_device objects should exist when the corresponding
struct pci_dev objects are created, but that is only guaranteed
during boot and not during hotplug.  This leads to a number of
functional differences between the boot and the hotplug cases which
are not strictly necessary and make the code more complicated.

For example, this forces the ACPI PCI root bridge driver to defer the
registration of the just created struct pci_dev objects and to use a
special .start() callback routine, acpi_pci_root_start(), to make
sure that all of the "companion" struct acpi_device objects will be
present at PCI devices registration time during hotplug.

If those differences can be eliminated, we will be able to
consolidate the boot and hotplug code paths for the enumeration and
registration of PCI devices and to reduce the complexity of that
code quite a bit.

The second reason is that, in general, it should be possible to
resolve conflicts of resources assigned by the BIOS to different
devices represented by ACPI namespace nodes before any drivers bind
to them and before they are attached to "companion" objects
representing physical devices (such as struct pci_dev).  However, for
this purpose we first need to enumerate all ACPI device nodes in the
given namespace scope.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c     |  103 +++++++++++++++++++++++++++++++++---------------
 include/acpi/acpi_bus.h |    1 
 2 files changed, 73 insertions(+), 31 deletions(-)

Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -98,6 +98,7 @@ typedef void (*acpi_op_notify) (struct a
 struct acpi_bus_ops {
 	u32 acpi_op_add:1;
 	u32 acpi_op_start:1;
+	u32 acpi_op_match:1;
 };
 
 struct acpi_device_ops {
Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -494,7 +494,8 @@ static int acpi_bus_match(struct device
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 	struct acpi_driver *acpi_drv = to_acpi_driver(drv);
 
-	return !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
+	return acpi_dev->bus_ops.acpi_op_match
+		&& !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
 }
 
 static int acpi_device_uevent(struct device *dev, struct kobj_uevent_env *env)
@@ -1418,6 +1419,17 @@ static int acpi_bus_remove(struct acpi_d
 	return 0;
 }
 
+/*
+ * acpi_hot_add_bind - Bind _ADR-based devices on hot-add.
+ * @device: ACPI device node to bind.
+ */
+static void acpi_hot_add_bind(struct acpi_device *device)
+{
+	if (device->flags.bus_address
+	    && device->parent && device->parent->ops.bind)
+		device->parent->ops.bind(device);
+}
+
 static int acpi_add_single_object(struct acpi_device **child,
 				  acpi_handle handle, int type,
 				  unsigned long long sta,
@@ -1490,13 +1502,8 @@ static int acpi_add_single_object(struct
 
 	result = acpi_device_register(device);
 
-	/*
-	 * Bind _ADR-Based Devices when hot add
-	 */
-	if (device->flags.bus_address) {
-		if (device->parent && device->parent->ops.bind)
-			device->parent->ops.bind(device);
-	}
+	if (device->bus_ops.acpi_op_match)
+		acpi_hot_add_bind(device);
 
 end:
 	if (!result) {
@@ -1522,6 +1529,7 @@ static void acpi_bus_add_power_resource(
 	struct acpi_bus_ops ops = {
 		.acpi_op_add = 1,
 		.acpi_op_start = 1,
+		.acpi_op_match = 1,
 	};
 	struct acpi_device *device = NULL;
 
@@ -1574,9 +1582,9 @@ static acpi_status acpi_bus_check_add(ac
 				      void *context, void **return_value)
 {
 	struct acpi_bus_ops *ops = context;
+	struct acpi_device *device = NULL;
 	int type;
 	unsigned long long sta;
-	struct acpi_device *device;
 	acpi_status status;
 	int result;
 
@@ -1596,52 +1604,84 @@ static acpi_status acpi_bus_check_add(ac
 		return AE_CTRL_DEPTH;
 	}
 
-	/*
-	 * We may already have an acpi_device from a previous enumeration.  If
-	 * so, we needn't add it again, but we may still have to start it.
-	 */
-	device = NULL;
 	acpi_bus_get_device(handle, &device);
 	if (ops->acpi_op_add && !device) {
-		acpi_add_single_object(&device, handle, type, sta, ops);
-		/* Is the device a known good platform device? */
-		if (device
-		    && !acpi_match_device_ids(device, acpi_platform_device_ids))
-			acpi_create_platform_device(device);
-	}
-
-	if (!device)
-		return AE_CTRL_DEPTH;
+		struct acpi_bus_ops add_ops = *ops;
 
-	if (ops->acpi_op_start && !(ops->acpi_op_add)) {
-		status = acpi_start_single_object(device);
-		if (ACPI_FAILURE(status))
+		add_ops.acpi_op_match = 0;
+		acpi_add_single_object(&device, handle, type, sta, &add_ops);
+		if (!device)
 			return AE_CTRL_DEPTH;
+
+		device->bus_ops.acpi_op_match = 1;
+		acpi_hot_add_bind(device);
 	}
 
 	if (!*return_value)
 		*return_value = device;
+
 	return AE_OK;
 }
 
+static acpi_status acpi_bus_probe_start(acpi_handle handle, u32 lvl,
+					void *context, void **not_used)
+{
+	struct acpi_bus_ops *ops = context;
+	acpi_status status = AE_OK;
+	struct acpi_device *device;
+	unsigned long long sta_not_used;
+	int type_not_used;
+
+	/*
+	 * Ignore errors ignored by acpi_bus_check_add() to avoid terminating
+	 * namespace walks prematurely.
+	 */
+	if (acpi_bus_type_and_status(handle, &type_not_used, &sta_not_used))
+		return AE_OK;
+
+	if (acpi_bus_get_device(handle, &device))
+		return AE_CTRL_DEPTH;
+
+	if (ops->acpi_op_add) {
+		if (!acpi_match_device_ids(device, acpi_platform_device_ids)) {
+			/* This is a known good platform device. */
+			acpi_create_platform_device(device);
+		} else if (device_attach(&device->dev)) {
+			status = AE_CTRL_DEPTH;
+		}
+	} else if (ops->acpi_op_start) {
+		if (ACPI_FAILURE(acpi_start_single_object(device)))
+			status = AE_CTRL_DEPTH;
+	}
+	return status;
+}
+
 static int acpi_bus_scan(acpi_handle handle, struct acpi_bus_ops *ops,
 			 struct acpi_device **child)
 {
-	acpi_status status;
 	void *device = NULL;
+	acpi_status status;
+	int ret = -ENODEV;
 
 	status = acpi_bus_check_add(handle, 0, ops, &device);
 	if (ACPI_SUCCESS(status))
 		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
 				    acpi_bus_check_add, NULL, ops, &device);
 
+	if (!device)
+		goto out;
+
+	ret = 0;
+	status = acpi_bus_probe_start(handle, 0, ops, NULL);
+	if (ACPI_SUCCESS(status))
+		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
+				    acpi_bus_probe_start, NULL, ops, NULL);
+
+ out:
 	if (child)
 		*child = device;
 
-	if (device)
-		return 0;
-	else
-		return -ENODEV;
+	return ret;
 }
 
 /*
@@ -1752,6 +1792,7 @@ static int acpi_bus_scan_fixed(void)
 	memset(&ops, 0, sizeof(ops));
 	ops.acpi_op_add = 1;
 	ops.acpi_op_start = 1;
+	ops.acpi_op_match = 1;
 
 	/*
 	 * Enumerate all fixed-feature devices.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
