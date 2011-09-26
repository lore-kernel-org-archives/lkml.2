Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab1IZXsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 19:48:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:16873 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab1IZXsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 19:48:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,447,1312182000"; 
   d="scan'208";a="67708231"
Date: Mon, 26 Sep 2011 16:48:35 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: PME via interrupt or SCI mechanism?
Message-ID: <20110926234835.GA9551@xanatos>
References: <20110912171003.GA7939@xanatos>
 <20110922183201.GA4659@xanatos>
 <201109251653.04170.rjw@sisk.pl>
 <201109270020.26439.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <201109270020.26439.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 27, 2011 at 12:20:26AM +0200, Rafael J. Wysocki wrote:
> On Sunday, September 25, 2011, Rafael J. Wysocki wrote:
> > On Thursday, September 22, 2011, Sarah Sharp wrote:
> > > On Mon, Sep 19, 2011 at 11:43:33PM +0200, Rafael J. Wysocki wrote:
> > Without looking at the tables at the moment (I'll do that later),
> > I think that they are missing the information that GPE 0D is a wakeup
> > GPE for the xHCI device.
> 
> The DSDT appears to contain that information, so I'm not sure what's
> going on.  Perhaps you can put a debug printk into acpi_dev_run_wake()
> to see if that function is called for the xHCI controllers?

I put a printk in acpi_dev_run_wake(), and that shows up in the original
dmesg I sent:

Sep 22 10:47:09 talon kernel: [ 2026.211933] xhci_hcd 0000:00:14.0: acpi_pci_run_wake - enable dev wake
Sep 22 10:47:09 talon kernel: [ 2026.211936] acpi device:34: acpi_dev_run_wake - enable dev wake
Sep 22 10:47:09 talon kernel: [ 2026.211955] acpi device:34: acpi_dev_run_wake - return -19

The patch I've been using for adding debugging to the PCI and ACPI code
is attached.  I've been adding printks willy-nilly to try to understand
what's going on.

> > > In digging through the ACPI code, I noticed that acpi_bus_get_flags()
> > > looks for the ACPI methods _PR0 or _PS0 and sets
> > > device->flags.power_manageable to 1 if either of those methods are
> > > successfully invoked.  When I deassembled the ACPI tables, I didn't see
> > > either method for any of the USB host controllers in the system.
> 
> However, the power_manageable flag only indicates that the device can
> be put into low-power states through ACPI methods, it shouldn't have
> any effect on the wakeup settings.

Ok, good to know.

> > > device->flags.power_manageable is checked later when the runtime PM
> > > system attempts to put the PCI device into a lower state, but it seems
> > > to be ignored?  Is it supposed to be ignored?
> > 
> > Hmm, not really.  I'll have a look at that later.
> 
> It is used to decide whether or not to call __acpi_bus_set_power(), AFAICS.
> If it is not set, this function is not called, which is OK.  Still,
> devices for which it is not set may be put into low-power states and may
> generate wakeup signals.
> 
> For many PCI devices there are two possible power management interfaces,
> the native one and the ACPI-based one.  All of the modern devices support
> the native power management interface, so they can be put into low-power
> states even if the ACPI-based interface is missing for them (which is the
> case for your USB controllers).  For those devices, if the ACPI-based
> interface is not present, we simply use the native one only.

So if I understand you correctly, the kernel can use the native PCI power
management interface to put the PCI device into a lower power state...

> As far as wakeup is concerned, we should enable them to generate PME
> using the native interface and in addition to it we should use ACPI to
> enable the wakeup GPEs that are supposed to be triggered in response to
> the PME signals.

...but the kernel ACPI core will still be watching for the SCI that the
firmware generates on a PME wakeup?  Correct?

Is the native PCI power management interface you're referring to
implemented through the PCIe PME driver?  Because this particular host
controller is a PCIe device, not a PCI device.  I added some debug
statements to drivers/pci/pcie/pme.c, but the dmesg shows that none of
them got called.

> This apparently doesn't work correctly on your system and we need to figure
> out why.

Ok.  Do you have suggestions for any tests I can run or debugging
statements to add?  I'm really not an ACPI expert and I've been
basically fumbling in the dark.

Sarah Sharp

--5mCyUwZo2JvN/JJP
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="pci-acpi-debugging.patch"

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 437ddbf..a8c7fad 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -370,20 +370,23 @@ int acpi_bus_update_power(acpi_handle handle, int *state_p)
 }
 EXPORT_SYMBOL_GPL(acpi_bus_update_power);
 
 
 bool acpi_bus_power_manageable(acpi_handle handle)
 {
 	struct acpi_device *device;
 	int result;
 
 	result = acpi_bus_get_device(handle, &device);
+	printk(KERN_DEBUG "%s - result %u, device->flags.power_manageable %u\n",
+			__func__, result,
+			result ? 0 : device->flags.power_manageable);
 	return result ? false : device->flags.power_manageable;
 }
 
 EXPORT_SYMBOL(acpi_bus_power_manageable);
 
 bool acpi_bus_can_wakeup(acpi_handle handle)
 {
 	struct acpi_device *device;
 	int result;
 
diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index 2ef0409..94173e0 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -63,20 +63,21 @@ static int acpi_pci_bind(struct acpi_device *device)
 {
 	acpi_status status;
 	acpi_handle handle;
 	struct pci_bus *bus;
 	struct pci_dev *dev;
 
 	dev = acpi_get_pci_dev(device->handle);
 	if (!dev)
 		return 0;
 
+	dev_dbg(&dev->dev, "%s\n", __func__);
 	pci_acpi_add_pm_notifier(device, dev);
 	if (device->wakeup.flags.run_wake)
 		device_set_run_wake(&dev->dev, true);
 
 	/*
 	 * Install the 'bind' function to facilitate callbacks for
 	 * children of the P2P bridge.
 	 */
 	if (dev->subordinate) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 7f9eba9..2acdf70 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -416,20 +416,21 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 {
 	struct acpi_prt_entry *entry;
 	int gsi;
 	u8 pin;
 	int triggering = ACPI_LEVEL_SENSITIVE;
 	int polarity = ACPI_ACTIVE_LOW;
 	char *link = NULL;
 	char link_desc[16];
 	int rc;
 
+	dev_dbg(&dev->dev, "%s\n", __func__);
 	pin = dev->pin;
 	if (!pin) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "No interrupt pin configured for device %s\n",
 				  pci_name(dev)));
 		return 0;
 	}
 
 	entry = acpi_pci_irq_lookup(dev, pin);
 	if (!entry) {
@@ -499,20 +500,21 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 void __attribute__ ((weak)) acpi_unregister_gsi(u32 i)
 {
 }
 
 void acpi_pci_irq_disable(struct pci_dev *dev)
 {
 	struct acpi_prt_entry *entry;
 	int gsi;
 	u8 pin;
 
+	dev_dbg(&dev->dev, "%s\n", __func__);
 	pin = dev->pin;
 	if (!pin)
 		return;
 
 	entry = acpi_pci_irq_lookup(dev, pin);
 	if (!entry)
 		return;
 
 	if (entry->link)
 		gsi = acpi_pci_link_free_irq(entry->link);
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 2672c79..b508392 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -216,35 +216,37 @@ static acpi_status acpi_pci_run_osc(acpi_handle handle,
 				    const u32 *capbuf, u32 *retval)
 {
 	struct acpi_osc_context context = {
 		.uuid_str = pci_osc_uuid_str,
 		.rev = 1,
 		.cap.length = 12,
 		.cap.pointer = (void *)capbuf,
 	};
 	acpi_status status;
 
+	printk(KERN_DEBUG "%s\n", __func__);
 	status = acpi_run_osc(handle, &context);
 	if (ACPI_SUCCESS(status)) {
 		*retval = *((u32 *)(context.ret.pointer + 8));
 		kfree(context.ret.pointer);
 	}
 	return status;
 }
 
 static acpi_status acpi_pci_query_osc(struct acpi_pci_root *root,
 					u32 support,
 					u32 *control)
 {
 	acpi_status status;
 	u32 result, capbuf[3];
 
+	printk(KERN_DEBUG "%s\n", __func__);
 	support &= OSC_PCI_SUPPORT_MASKS;
 	support |= root->osc_support_set;
 
 	capbuf[OSC_QUERY_TYPE] = OSC_QUERY_ENABLE;
 	capbuf[OSC_SUPPORT_TYPE] = support;
 	if (control) {
 		*control &= OSC_PCI_CONTROL_MASKS;
 		capbuf[OSC_CONTROL_TYPE] = *control | root->osc_control_set;
 	} else {
 		/* Run _OSC query for all possible controls. */
@@ -258,20 +260,21 @@ static acpi_status acpi_pci_query_osc(struct acpi_pci_root *root,
 			*control = result;
 	}
 	return status;
 }
 
 static acpi_status acpi_pci_osc_support(struct acpi_pci_root *root, u32 flags)
 {
 	acpi_status status;
 	acpi_handle tmp;
 
+	printk(KERN_DEBUG "%s\n", __func__);
 	status = acpi_get_handle(root->device->handle, "_OSC", &tmp);
 	if (ACPI_FAILURE(status))
 		return status;
 	mutex_lock(&osc_lock);
 	status = acpi_pci_query_osc(root, flags, NULL);
 	mutex_unlock(&osc_lock);
 	return status;
 }
 
 struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle)
@@ -393,20 +396,21 @@ EXPORT_SYMBOL_GPL(acpi_get_pci_dev);
  * _OSC bits the BIOS has granted control of, but its contents are meaningless
  * on failure.
  **/
 acpi_status acpi_pci_osc_control_set(acpi_handle handle, u32 *mask, u32 req)
 {
 	struct acpi_pci_root *root;
 	acpi_status status;
 	u32 ctrl, capbuf[3];
 	acpi_handle tmp;
 
+	printk(KERN_DEBUG "%s\n", __func__);
 	if (!mask)
 		return AE_BAD_PARAMETER;
 
 	ctrl = *mask & OSC_PCI_CONTROL_MASKS;
 	if ((ctrl & req) != req)
 		return AE_TYPE;
 
 	root = acpi_pci_find_root(handle);
 	if (!root)
 		return AE_NOT_EXIST;
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 449c556..e3e5f57 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -937,29 +937,37 @@ static int acpi_bus_get_flags(struct acpi_device *device)
 		if (ACPI_SUCCESS(status))
 			device->flags.ejectable = 1;
 	}
 
 	/* Presence of _LCK indicates 'lockable' */
 	status = acpi_get_handle(device->handle, "_LCK", &temp);
 	if (ACPI_SUCCESS(status))
 		device->flags.lockable = 1;
 
 	/* Power resources cannot be power manageable. */
-	if (device->device_type == ACPI_BUS_TYPE_POWER)
+	if (device->device_type == ACPI_BUS_TYPE_POWER) {
+		printk(KERN_DEBUG "%s - power resources are not "
+				"power manageable\n", __func__);
 		return 0;
+	}
 
 	/* Presence of _PS0|_PR0 indicates 'power manageable' */
 	status = acpi_get_handle(device->handle, "_PS0", &temp);
-	if (ACPI_FAILURE(status))
+	if (ACPI_FAILURE(status)) {
+		printk(KERN_DEBUG "%s no _PS0\n", __func__);
 		status = acpi_get_handle(device->handle, "_PR0", &temp);
-	if (ACPI_SUCCESS(status))
+	}
+	if (ACPI_SUCCESS(status)) {
+		printk(KERN_DEBUG "%s _PR0\n", __func__);
 		device->flags.power_manageable = 1;
+	}
+	printk(KERN_DEBUG "%s no _PR0\n", __func__);
 
 	/* TBD: Performance management */
 
 	return 0;
 }
 
 static void acpi_device_get_busid(struct acpi_device *device)
 {
 	char bus_id[5] = { '?', 0 };
 	struct acpi_buffer buffer = { sizeof(bus_id), bus_id };
@@ -1227,20 +1235,21 @@ static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
 
 static int acpi_add_single_object(struct acpi_device **child,
 				  acpi_handle handle, int type,
 				  unsigned long long sta,
 				  struct acpi_bus_ops *ops)
 {
 	int result;
 	struct acpi_device *device;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 
+	printk(KERN_DEBUG "%s\n", __func__);
 	device = kzalloc(sizeof(struct acpi_device), GFP_KERNEL);
 	if (!device) {
 		printk(KERN_ERR PREFIX "Memory allocation error\n");
 		return -ENOMEM;
 	}
 
 	INIT_LIST_HEAD(&device->pnp.ids);
 	device->device_type = type;
 	device->handle = handle;
 	device->parent = acpi_bus_get_parent(handle);
@@ -1325,20 +1334,21 @@ end:
 			  ACPI_STA_DEVICE_UI      | ACPI_STA_DEVICE_FUNCTIONING)
 
 static void acpi_bus_add_power_resource(acpi_handle handle)
 {
 	struct acpi_bus_ops ops = {
 		.acpi_op_add = 1,
 		.acpi_op_start = 1,
 	};
 	struct acpi_device *device = NULL;
 
+	printk(KERN_DEBUG "%s\n", __func__);
 	acpi_bus_get_device(handle, &device);
 	if (!device)
 		acpi_add_single_object(&device, handle, ACPI_BUS_TYPE_POWER,
 					ACPI_STA_DEFAULT, &ops);
 }
 
 static int acpi_bus_type_and_status(acpi_handle handle, int *type,
 				    unsigned long long *sta)
 {
 	acpi_status status;
@@ -1380,20 +1390,21 @@ static int acpi_bus_type_and_status(acpi_handle handle, int *type,
 static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl,
 				      void *context, void **return_value)
 {
 	struct acpi_bus_ops *ops = context;
 	int type;
 	unsigned long long sta;
 	struct acpi_device *device;
 	acpi_status status;
 	int result;
 
+	printk(KERN_DEBUG "%s\n", __func__);
 	result = acpi_bus_type_and_status(handle, &type, &sta);
 	if (result)
 		return AE_OK;
 
 	if (!(sta & ACPI_STA_DEVICE_PRESENT) &&
 	    !(sta & ACPI_STA_DEVICE_FUNCTIONING)) {
 		struct acpi_device_wakeup wakeup;
 		acpi_handle temp;
 
 		status = acpi_get_handle(handle, "_PRW", &temp);
@@ -1548,20 +1559,21 @@ EXPORT_SYMBOL_GPL(acpi_bus_trim);
 static int acpi_bus_scan_fixed(void)
 {
 	int result = 0;
 	struct acpi_device *device = NULL;
 	struct acpi_bus_ops ops;
 
 	memset(&ops, 0, sizeof(ops));
 	ops.acpi_op_add = 1;
 	ops.acpi_op_start = 1;
 
+	printk(KERN_DEBUG "%s\n", __func__);
 	/*
 	 * Enumerate all fixed-feature devices.
 	 */
 	if ((acpi_gbl_FADT.flags & ACPI_FADT_POWER_BUTTON) == 0) {
 		result = acpi_add_single_object(&device, NULL,
 						ACPI_BUS_TYPE_POWER_BUTTON,
 						ACPI_STA_DEFAULT,
 						&ops);
 	}
 
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index d36f41e..e7885fe 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -24,35 +24,39 @@ static DEFINE_MUTEX(pci_acpi_pm_notify_mtx);
 /**
  * pci_acpi_wake_bus - Wake-up notification handler for root buses.
  * @handle: ACPI handle of a device the notification is for.
  * @event: Type of the signaled event.
  * @context: PCI root bus to wake up devices on.
  */
 static void pci_acpi_wake_bus(acpi_handle handle, u32 event, void *context)
 {
 	struct pci_bus *pci_bus = context;
 
-	if (event == ACPI_NOTIFY_DEVICE_WAKE && pci_bus)
+	printk(KERN_DEBUG "%s\n", __func__);
+	if (event == ACPI_NOTIFY_DEVICE_WAKE && pci_bus) {
+		dev_dbg(&pci_bus->self->dev, "%s\n", __func__);
 		pci_pme_wakeup_bus(pci_bus);
+	}
 }
 
 /**
  * pci_acpi_wake_dev - Wake-up notification handler for PCI devices.
  * @handle: ACPI handle of a device the notification is for.
  * @event: Type of the signaled event.
  * @context: PCI device object to wake up.
  */
 static void pci_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
 {
 	struct pci_dev *pci_dev = context;
 
 	if (event == ACPI_NOTIFY_DEVICE_WAKE && pci_dev) {
+		dev_dbg(&pci_dev->dev, "%s\n", __func__);
 		pci_wakeup_event(pci_dev);
 		pci_check_pme_status(pci_dev);
 		pm_runtime_resume(&pci_dev->dev);
 		if (pci_dev->subordinate)
 			pci_pme_wakeup_bus(pci_dev->subordinate);
 	}
 }
 
 /**
  * add_pm_notifier - Register PM notifier for given ACPI device.
@@ -136,20 +140,21 @@ acpi_status pci_acpi_remove_bus_pm_notifier(struct acpi_device *dev)
 }
 
 /**
  * pci_acpi_add_pm_notifier - Register PM notifier for given PCI device.
  * @dev: ACPI device to add the notifier for.
  * @pci_dev: PCI device to check for the PME status if an event is signaled.
  */
 acpi_status pci_acpi_add_pm_notifier(struct acpi_device *dev,
 				     struct pci_dev *pci_dev)
 {
+	dev_dbg(&pci_dev->dev, "%s\n", __func__);
 	return add_pm_notifier(dev, pci_acpi_wake_dev, pci_dev);
 }
 
 /**
  * pci_acpi_remove_pm_notifier - Unregister PCI device PM notifier.
  * @dev: ACPI device to remove the notifier from.
  */
 acpi_status pci_acpi_remove_pm_notifier(struct acpi_device *dev)
 {
 	return remove_pm_notifier(dev, pci_acpi_wake_dev);
@@ -198,20 +203,28 @@ static pci_power_t acpi_pci_choose_state(struct pci_dev *pdev)
 	case ACPI_STATE_D3_COLD:
 		return PCI_D3cold;
 	}
 	return PCI_POWER_ERROR;
 }
 
 static bool acpi_pci_power_manageable(struct pci_dev *dev)
 {
 	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
 
+	if (handle) {
+		dev_dbg(&dev->dev, "%s - dev is%s power manageable\n",
+				__func__,
+				 acpi_bus_power_manageable(handle) ?
+				 "" : " not");
+	} else
+		dev_dbg(&dev->dev, "%s - dev is NOT power manageable\n",
+				__func__);
 	return handle ? acpi_bus_power_manageable(handle) : false;
 }
 
 static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 {
 	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
 	acpi_handle tmp;
 	static const u8 state_conv[] = {
 		[PCI_D0] = ACPI_STATE_D0,
 		[PCI_D1] = ACPI_STATE_D1,
@@ -238,38 +251,48 @@ static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 		dev_printk(KERN_INFO, &dev->dev,
 				"power state changed by ACPI to D%d\n", state);
 
 	return error;
 }
 
 static bool acpi_pci_can_wakeup(struct pci_dev *dev)
 {
 	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
 
+	if (handle)
+		dev_dbg(&dev->dev, "%s - dev can%s wakeup\n",
+				__func__,
+				 acpi_bus_can_wakeup(handle) ?
+				 "" : " not");
+	else
+		dev_dbg(&dev->dev, "%s - dev is can wakeup\n",
+				__func__);
 	return handle ? acpi_bus_can_wakeup(handle) : false;
 }
 
 static void acpi_pci_propagate_wakeup_enable(struct pci_bus *bus, bool enable)
 {
 	while (bus->parent) {
 		if (!acpi_pm_device_sleep_wake(&bus->self->dev, enable))
 			return;
 		bus = bus->parent;
 	}
 
 	/* We have reached the root bus. */
 	if (bus->bridge)
 		acpi_pm_device_sleep_wake(bus->bridge, enable);
 }
 
 static int acpi_pci_sleep_wake(struct pci_dev *dev, bool enable)
 {
+	dev_dbg(&dev->dev, "%s - %s dev wake\n",
+			__func__, enable ? "enable" : "disable");
 	if (acpi_pci_can_wakeup(dev))
 		return acpi_pm_device_sleep_wake(&dev->dev, enable);
 
 	acpi_pci_propagate_wakeup_enable(dev->bus, enable);
 	return 0;
 }
 
 /**
  * acpi_dev_run_wake - Enable/disable wake-up for given device.
  * @phys_dev: Device to enable/disable the platform to wake-up the system for.
@@ -287,28 +310,31 @@ static int acpi_dev_run_wake(struct device *phys_dev, bool enable)
 	if (!device_run_wake(phys_dev))
 		return -EINVAL;
 
 	handle = DEVICE_ACPI_HANDLE(phys_dev);
 	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &dev))) {
 		dev_dbg(phys_dev, "ACPI handle has no context in %s!\n",
 			__func__);
 		return -ENODEV;
 	}
 
+	dev_dbg(&dev->dev, "%s - %s dev wake\n",
+			__func__, enable ? "enable" : "disable");
 	if (enable) {
 		acpi_enable_wakeup_device_power(dev, ACPI_STATE_S0);
 		acpi_enable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number);
 	} else {
 		acpi_disable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number);
 		acpi_disable_wakeup_device_power(dev);
 	}
 
+	dev_dbg(&dev->dev, "%s - return %i\n", __func__, error);
 	return error;
 }
 
 static void acpi_pci_propagate_run_wake(struct pci_bus *bus, bool enable)
 {
 	while (bus->parent) {
 		struct pci_dev *bridge = bus->self;
 
 		if (bridge->pme_interrupt)
 			return;
@@ -317,20 +343,22 @@ static void acpi_pci_propagate_run_wake(struct pci_bus *bus, bool enable)
 		bus = bus->parent;
 	}
 
 	/* We have reached the root bus. */
 	if (bus->bridge)
 		acpi_dev_run_wake(bus->bridge, enable);
 }
 
 static int acpi_pci_run_wake(struct pci_dev *dev, bool enable)
 {
+	dev_dbg(&dev->dev, "%s - %s dev wake\n",
+			__func__, enable ? "enable" : "disable");
 	if (dev->pme_interrupt)
 		return 0;
 
 	if (!acpi_dev_run_wake(&dev->dev, enable))
 		return 0;
 
 	acpi_pci_propagate_run_wake(dev->bus, enable);
 	return 0;
 }
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 08a95b3..2fcfa42 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -536,20 +536,22 @@ static inline int platform_pci_run_wake(struct pci_dev *dev, bool enable)
  * -EIO if device does not support PCI PM or its PM capabilities register has a
  * wrong version, or device doesn't support the requested state.
  * 0 if device already is in the requested state.
  * 0 if device's power state has been successfully changed.
  */
 static int pci_raw_set_power_state(struct pci_dev *dev, pci_power_t state)
 {
 	u16 pmcsr;
 	bool need_restore = false;
 
+	dev_dbg(&dev->dev, "%s from %d to %d\n", __func__,
+			dev->current_state, state);
 	/* Check if we're already there */
 	if (dev->current_state == state)
 		return 0;
 
 	if (!dev->pm_cap)
 		return -EIO;
 
 	if (state < PCI_D0 || state > PCI_D3hot)
 		return -EINVAL;
 
@@ -652,24 +654,26 @@ void pci_update_current_state(struct pci_dev *dev, pci_power_t state)
 /**
  * pci_platform_power_transition - Use platform to change device power state
  * @dev: PCI device to handle.
  * @state: State to put the device into.
  */
 static int pci_platform_power_transition(struct pci_dev *dev, pci_power_t state)
 {
 	int error;
 
 	if (platform_pci_power_manageable(dev)) {
+		dev_dbg(&dev->dev, "%s - is power managable\n", __func__);
 		error = platform_pci_set_power_state(dev, state);
 		if (!error)
 			pci_update_current_state(dev, state);
 	} else {
+		dev_dbg(&dev->dev, "%s - is NOT power managable\n", __func__);
 		error = -ENODEV;
 		/* Fall back to PCI_D0 if native PM is not supported */
 		if (!dev->pm_cap)
 			dev->current_state = PCI_D0;
 	}
 
 	return error;
 }
 
 /**
@@ -726,22 +730,24 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 		 * If the device or the parent bridge do not support PCI PM,
 		 * ignore the request if we're doing anything other than putting
 		 * it into D0 (which would only happen on boot).
 		 */
 		return 0;
 
 	__pci_start_power_transition(dev, state);
 
 	/* This device is quirked not to be put into D3, so
 	   don't put it in D3 */
-	if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
+	if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3)) {
+		dev_dbg(&dev->dev, "%s - quirk: don't put in D3.\n", __func__);
 		return 0;
+	}
 
 	error = pci_raw_set_power_state(dev, state);
 
 	if (!__pci_complete_power_transition(dev, state))
 		error = 0;
 	/*
 	 * When aspm_policy is "powersave" this call ensures
 	 * that ASPM is configured.
 	 */
 	if (!error && dev->bus->self)
diff --git a/drivers/pci/pcie/pme.c b/drivers/pci/pcie/pme.c
index 0057344..22c2f68 100644
--- a/drivers/pci/pcie/pme.c
+++ b/drivers/pci/pcie/pme.c
@@ -56,24 +56,27 @@ struct pcie_pme_service_data {
  * @enable: Enable or disable the interrupt.
  */
 void pcie_pme_interrupt_enable(struct pci_dev *dev, bool enable)
 {
 	int rtctl_pos;
 	u16 rtctl;
 
 	rtctl_pos = pci_pcie_cap(dev) + PCI_EXP_RTCTL;
 
 	pci_read_config_word(dev, rtctl_pos, &rtctl);
-	if (enable)
+	if (enable) {
 		rtctl |= PCI_EXP_RTCTL_PMEIE;
-	else
+		dev_dbg(&dev->dev, "%s - Enabling PME interrupt.\n", __func__);
+	} else {
 		rtctl &= ~PCI_EXP_RTCTL_PMEIE;
+		dev_dbg(&dev->dev, "%s - Disabling PME interrupt.\n", __func__);
+	}
 	pci_write_config_word(dev, rtctl_pos, rtctl);
 }
 
 /**
  * pcie_pme_walk_bus - Scan a PCI bus for devices asserting PME#.
  * @bus: PCI bus to scan.
  *
  * Scan given PCI bus and all buses under it for devices asserting PME#.
  */
 static bool pcie_pme_walk_bus(struct pci_bus *bus)
diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index ce22f4a..5ecba68 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -431,20 +431,21 @@ static int suspend_common(struct device *dev, bool do_wakeup)
 	pci_disable_device(pci_dev);
 	return retval;
 }
 
 static int resume_common(struct device *dev, int event)
 {
 	struct pci_dev		*pci_dev = to_pci_dev(dev);
 	struct usb_hcd		*hcd = pci_get_drvdata(pci_dev);
 	int			retval;
 
+	dev_dbg(dev, "%s\n", __func__);
 	if (HCD_RH_RUNNING(hcd) ||
 			(hcd->shared_hcd &&
 			 HCD_RH_RUNNING(hcd->shared_hcd))) {
 		dev_dbg(dev, "can't resume, not suspended!\n");
 		return 0;
 	}
 
 	retval = pci_enable_device(pci_dev);
 	if (retval < 0) {
 		dev_err(dev, "can't re-enable after resume, %d!\n", retval);
@@ -479,20 +480,21 @@ static int hcd_pci_suspend(struct device *dev)
 {
 	return suspend_common(dev, device_may_wakeup(dev));
 }
 
 static int hcd_pci_suspend_noirq(struct device *dev)
 {
 	struct pci_dev		*pci_dev = to_pci_dev(dev);
 	struct usb_hcd		*hcd = pci_get_drvdata(pci_dev);
 	int			retval;
 
+	dev_dbg(&pci_dev->dev, "%s\n", __func__);
 	retval = check_root_hub_suspended(dev);
 	if (retval)
 		return retval;
 
 	pci_save_state(pci_dev);
 
 	/* If the root hub is dead rather than suspended, disallow remote
 	 * wakeup.  usb_hc_died() should ensure that both hosts are marked as
 	 * dying, so we only need to check the primary roothub.
 	 */
@@ -518,27 +520,29 @@ static int hcd_pci_suspend_noirq(struct device *dev)
 	powermac_set_asic(pci_dev, 0);
 	return retval;
 }
 
 static int hcd_pci_resume_noirq(struct device *dev)
 {
 	struct pci_dev		*pci_dev = to_pci_dev(dev);
 
 	powermac_set_asic(pci_dev, 1);
 
+	dev_dbg(dev, "%s\n", __func__);
 	/* Go back to D0 and disable remote wakeup */
 	pci_back_from_sleep(pci_dev);
 	return 0;
 }
 
 static int hcd_pci_resume(struct device *dev)
 {
+	dev_dbg(dev, "%s\n", __func__);
 	return resume_common(dev, PM_EVENT_RESUME);
 }
 
 static int hcd_pci_restore(struct device *dev)
 {
 	return resume_common(dev, PM_EVENT_RESTORE);
 }
 
 #else
 
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 723f823..383b248 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -786,20 +786,21 @@ int xhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 #ifdef CONFIG_PM
 
 int xhci_bus_suspend(struct usb_hcd *hcd)
 {
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 	int max_ports, port_index;
 	__le32 __iomem **port_array;
 	struct xhci_bus_state *bus_state;
 	unsigned long flags;
 
+	xhci_dbg(xhci, "%s\n", __func__);
 	max_ports = xhci_get_ports(hcd, &port_array);
 	bus_state = &xhci->bus_state[hcd_index(hcd)];
 
 	spin_lock_irqsave(&xhci->lock, flags);
 
 	if (hcd->self.root_hub->do_remote_wakeup) {
 		port_index = max_ports;
 		while (port_index--) {
 			if (bus_state->resume_done[port_index] != 0) {
 				spin_unlock_irqrestore(&xhci->lock, flags);
@@ -871,20 +872,21 @@ int xhci_bus_suspend(struct usb_hcd *hcd)
 
 int xhci_bus_resume(struct usb_hcd *hcd)
 {
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 	int max_ports, port_index;
 	__le32 __iomem **port_array;
 	struct xhci_bus_state *bus_state;
 	u32 temp;
 	unsigned long flags;
 
+	xhci_dbg(xhci, "%s\n", __func__);
 	max_ports = xhci_get_ports(hcd, &port_array);
 	bus_state = &xhci->bus_state[hcd_index(hcd)];
 
 	if (time_before(jiffies, bus_state->next_statechange))
 		msleep(5);
 
 	spin_lock_irqsave(&xhci->lock, flags);
 	if (!HCD_HW_ACCESSIBLE(hcd)) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
 		return -ESHUTDOWN;
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index cb16de2..fad2691 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -247,20 +247,21 @@ static void xhci_pci_remove(struct pci_dev *dev)
 	usb_hcd_pci_remove(dev);
 	kfree(xhci);
 }
 
 #ifdef CONFIG_PM
 static int xhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 {
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 	int	retval = 0;
 
+	xhci_dbg(xhci, "%s\n", __func__);
 	if (hcd->state != HC_STATE_SUSPENDED ||
 			xhci->shared_hcd->state != HC_STATE_SUSPENDED)
 		return -EINVAL;
 
 	retval = xhci_suspend(xhci);
 
 	return retval;
 }
 
 static int xhci_pci_resume(struct usb_hcd *hcd, bool hibernated)
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 3a0f695..a75cc7f 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -689,20 +689,21 @@ static void xhci_clear_command_ring(struct xhci_hcd *xhci)
  * This is called when the machine transition into S3/S4 mode.
  *
  */
 int xhci_suspend(struct xhci_hcd *xhci)
 {
 	int			rc = 0;
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	u32			command;
 	int			i;
 
+	xhci_dbg(xhci, "%s\n", __func__);
 	spin_lock_irq(&xhci->lock);
 	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
 	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &xhci->shared_hcd->flags);
 	/* step 1: stop endpoint */
 	/* skipped assuming that port suspend has done */
 
 	/* step 2: clear Run/Stop bit */
 	command = xhci_readl(xhci, &xhci->op_regs->command);
 	command &= ~CMD_RUN;
 	xhci_writel(xhci, command, &xhci->op_regs->command);
@@ -744,20 +745,21 @@ int xhci_suspend(struct xhci_hcd *xhci)
  * This is called when the machine transition from S3/S4 mode.
  *
  */
 int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 {
 	u32			command, temp = 0;
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	struct usb_hcd		*secondary_hcd;
 	int			retval;
 
+	xhci_dbg(xhci, "%s\n", __func__);
 	/* Wait a bit if either of the roothubs need to settle from the
 	 * transition into bus suspend.
 	 */
 	if (time_before(jiffies, xhci->bus_state[0].next_statechange) ||
 			time_before(jiffies,
 				xhci->bus_state[1].next_statechange))
 		msleep(100);
 
 	spin_lock_irq(&xhci->lock);
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)

--5mCyUwZo2JvN/JJP--
