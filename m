Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750966Ab1FYEuV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 00:50:21 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61576 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1FYEuT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 00:50:19 -0400
MIME-Version: 1.0
In-Reply-To: <1308924659-31894-2-git-send-email-marc.zyngier@arm.com>
References: <1308924659-31894-1-git-send-email-marc.zyngier@arm.com> <1308924659-31894-2-git-send-email-marc.zyngier@arm.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 24 Jun 2011 22:49:56 -0600
X-Google-Sender-Auth: F1B3Wff3dpUEWLyF1VXBquf7E4A
Message-ID: <BANLkTi=7cM2dXniHM4mnXs46KaTc05hh-Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] dt: early platform devices support
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <robherring2@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing linux kernel since I discuss driver core issues]
[cc'ing greg and kay, 'cause I've included a patch I'd like you to
look at (see end of email)]

On Fri, Jun 24, 2011 at 8:10 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> Add support for populating early platform devices from the device
> tree, by walking the tree and adding nodes whose 'compatible'
> property matches the 'class' string passed as a parameter.
>
> This allows devices to be probed long before the whole device
> infrastructure is available.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/of/platform.c       |   26 ++++++++++++++++++++++++++
>  include/linux/of_platform.h |    1 +
>  2 files changed, 27 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index e75af39..2a323ee 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -458,4 +458,30 @@ int of_platform_populate(struct device_node *root,
>        of_node_put(root);
>        return rc;
>  }
> +
> +/**
> + * of_early_platform_populate() - Populate early platform devices from DT
> + * @class: string to compare to the 'compatible' attributes
> + *
> + * This function walks the device tree and register devices whose
> + * 'compatible' property matches the 'class' parameter.
> + *
> + * Returns 0 on success, < 0 on failure.
> + */
> +int of_early_platform_populate(const char *class)
> +{
> +       struct platform_device *pdev;
> +       struct device_node *np = NULL;
> +
> +       while ((np = of_find_compatible_node(np, NULL, class))) {

for_each_compatible_node()

> +               pdev = of_device_alloc(np, NULL, NULL);
> +               if (!pdev)
> +                       return -ENOMEM;
> +               list_del(&pdev->dev.devres_head);
> +               memset(&pdev->dev.devres_head, 0, sizeof(pdev->dev.devres_head));
> +               early_platform_add_devices(&pdev, 1);

I'm not sure this will work reliably.  The of_platform semantics are
still slightly different from 'regular' platform devices (which I do
intend to fix though), so it may cause problems with how the device
name gets assigned.  I'd need to dig into it though.

> +       }
> +
> +       return 0;
> +}

Hmmm, I'd really rather not go down the path of having different
'classes' of devices that need to be registered at different times.
There just isn't a really good generic way to know which devices
should be the 'early' ones, it gets hairy with regard to making sure
devices don't get registered twice, and it doesn't actually solve the
problem that there is no way to handle dependencies between devices in
the Linux device model.

What I /want/ to do is allow drivers to defer initialization at .probe
time if some of the resources it needs aren't yet available.
Unfortunately, that doesn't work so well for interrupt controllers
since irq numbers are expected to be correctly populated in the
platform device resource table.  What complicates things further is
that most gpio controllers are doubling as irq controllers nowdays,
and those are typically modelled with platform devices themselves.

One possible approach is to manipulate the order that devices get
registered in by looking explicitly at each device's interrupt-parent
and *-gpio properties, and making sure that interrupt-controllers and
gpio-controllers get registered before any dependent modules, but that
could get complex in a hurry and it doesn't actually solve anything if
one of the irq controller drivers is loaded as a module.  To make it
work, of_platform_populate() would have to actually defer registration
dependent devices until after the irq controller is bound to a driver.
 Blech!  It would be doable by keeping a list of nodes that a device
is dependant on, and snooping bus registrations to look for drivers
bound to the devices referencing that node, but it would be ugly and
would just gloss over the lack of handling dependencies in the driver
core.  Right now we fudge it by messing about with initcall ordering
on the device drivers so that the device driver registration order
doesn't matter, but that doesn't solve the problem caused by drivers
loaded by modules.

More and more, I'm think the solution is to do dependency checking at
.probe time.  If some asynchronous resources (irqs, gpios, phys, etc)
aren't available yet, then it need to be possible to defer
initialization, either by not binding the driver and returning
something like -EAGAIN to say "try me again later", or by letting the
driver explicitly call a deferred init api that with a callback for
when the resources do become available.  I'm really not sure which is
best.  I worry that a deferred init api will end up being complex and
unwieldy, so I'm kind of leaning towards the -EAGAIN solution since it
doesn't require drivers to create a new initialization path.  It would
mean that the driver core would have to keep a list of devices that
had a driver return -EAGAIN, and arrange to reattempt binding at some
point in the future.  Probably after a 'significant' event, such as
another device getting bound to a driver.

...

I should probably actually propose some kind of solution rather than
babbling on about the problem.  I took some time tonight to hack
together what I think the solution should look like.  Take a look at
the following and let me know what you think.  Greg/Kay, I could
certainly use your feedback on this (apologies for any work wrapping,
I'm pasting this into gmail).

---

commit efc3b3168879d0bd9bf9fa3ebfbb1a348394c76f
Author: Grant Likely <grant.likely@secretlab.ca>
Date:   Fri Jun 24 22:33:46 2011 -0600

    drivercore: Add driver probe deferral mechanism

    Allow drivers to report at probe time that they cannot get all the resources
    required by the device, and should be retried at a later time.

    This should completely solve the problem of getting devices
    initialized in the right order.  Right now this is mostly handled by
    mucking about with initcall ordering which is a complete hack, and
    doesn't even remotely handle the case where device drivers are in
    modules.  This approach completely sidesteps the issues by allowing
    driver registration to occur in any order, and any driver can request
    to be retried after a few more other drivers get probed.

    This patch is *completely untested* and probably utterly broken.
    There is absolutely no locking implemented, and there needs to be
    something around the accesses to the deferred_probe_list (most likely
    a spin lock that gets dropped before each call to bus_probe_device()).
    I'd like to get feedback on if this is the correct approach before I
    do the work of actually making it correct.  :-)

    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

diff --git a/drivers/base/core.c b/drivers/base/core.c
index bc8729d..83aafff 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -588,6 +588,7 @@ void device_initialize(struct device *dev)
 {
 	dev->kobj.kset = devices_kset;
 	kobject_init(&dev->kobj, &device_ktype);
+	INIT_LIST_HEAD(&dev->deferred_probe);
 	INIT_LIST_HEAD(&dev->dma_pools);
 	mutex_init(&dev->mutex);
 	lockdep_set_novalidate_class(&dev->mutex);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 6658da7..3694661 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -28,6 +28,18 @@
 #include "base.h"
 #include "power/power.h"

+/**
+ * deferred_probe_work_func() - Retry probing devices in the deferred list.
+ */
+static LIST_HEAD(deferred_probe_list);
+static void deferred_probe_work_func(struct work_struct *work)
+{
+	struct device *dev;
+	list_for_each_entry(dev, &deferred_probe_list, deferred_probe) {
+		bus_probe_device(dev);
+	}
+}
+static DECLARE_WORK(deferred_probe_work, deferred_probe_work_func);

 static void driver_bound(struct device *dev)
 {
@@ -41,6 +53,9 @@ static void driver_bound(struct device *dev)
 		 __func__, dev->driver->name);

 	klist_add_tail(&dev->p->knode_driver, &dev->driver->p->klist_devices);
+	if (!list_empty(&dev->deferred_probe))
+		list_del_init(&dev->deferred_probe);
+	schedule_work(&deferred_probe_work);

 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
@@ -142,7 +157,17 @@ probe_failed:
 	driver_sysfs_remove(dev);
 	dev->driver = NULL;

-	if (ret != -ENODEV && ret != -ENXIO) {
+	if (ret == -EAGAIN) {
+		/*
+		 * Probe could not obtain all resources for device and requested
+		 * to be reprobed with the availble drivers at some future point
+		 * in time.  Log the deferral request and add the device to the
+		 * deferred probe list.
+		 */
+		dev_info(dev, "Driver %s requests probe deferral\n", drv->name);
+		if (list_empty(&dev->deferred_probe))
+			list_add(&dev->deferred_probe, &deferred_probe_list);
+	} else if (ret != -ENODEV && ret != -ENXIO) {
 		/* driver matched but the probe failed */
 		printk(KERN_WARNING
 		       "%s: probe of %s failed with error %d\n",
diff --git a/include/linux/device.h b/include/linux/device.h
index c66111a..50cc399 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -506,6 +506,10 @@ struct device_dma_parameters {
  * @mutex:	Mutex to synchronize calls to its driver.
  * @bus:	Type of bus device is on.
  * @driver:	Which driver has allocated this
+ * @deferred_probe: entry in deferred_probe_list which is used to retry the
+ * 		binding of drivers which were unable to get all the resources
+ * 		needed by the device; typically because it depends on another
+ * 		driver getting probed first.
  * @platform_data: Platform data specific to the device.
  * 		Example: For devices on custom boards, as typical of embedded
  * 		and SOC based hardware, Linux often uses platform_data to point
@@ -565,6 +569,7 @@ struct device {
 	struct bus_type	*bus;		/* type of bus device is on */
 	struct device_driver *driver;	/* which driver has allocated this
 					   device */
+	struct list_head	deferred_probe;
 	void		*platform_data;	/* Platform specific data, device
 					   core doesn't touch it */
 	struct dev_pm_info	power;
