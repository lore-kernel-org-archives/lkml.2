Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab1GJI6h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 04:58:37 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50527 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab1GJI63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 04:58:29 -0400
Date: Sun, 10 Jul 2011 06:29:24 +0900
From: Grant Likely <grant.likely@secretlab.ca>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/4] Core devices: documentation
Message-ID: <20110709212924.GD2805@ponder.secretlab.ca>
References: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>
 <1310115250-3859-5-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310115250-3859-5-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 09:54:10AM +0100, Marc Zyngier wrote:
> Add the documentation file for core devices.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  Documentation/core_devices.txt |  247 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 247 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/core_devices.txt
> 
> diff --git a/Documentation/core_devices.txt b/Documentation/core_devices.txt
> new file mode 100644
> index 0000000..5d1581f
> --- /dev/null
> +++ b/Documentation/core_devices.txt
> @@ -0,0 +1,247 @@
> +Core Device Subsystem:
> +=====================
> +
> +There is a small number of devices that the core kernel needs very
> +early in the boot process, namely an interrupt controller and a timer,
> +long before the driver model is up and running.
> +
> +Most architectures implement this requirement by hardcoding the
> +initialisation of a "well known" piece of hardware which is standard
> +enough to work on any platform.
> +
> +This is very different on the ARM architecture, where platforms have a
> +variety of interrupt controllers and timers. While the same hardcoding
> +is possible (and is actually used), it makes it almost impossible to
> +support several platforms in the same kernel.
> +
> +Though the device tree is helping greatly to solve this problem, some
> +platform won't ever be converted to DT, hence the need to have a
> +mechanism supporting a variety of information source. Early platform
> +devices having been deemed unsuitable (complexity, abuse of various
> +subsystems), this subsystem has been designed to provide the very
> +minimal level of functionality.
> +
> +The "core device subsystem" offers a class based device/driver
> +matching model, doesn't rely on any other subsystem, is very (too?)
> +simple, and support getting information both from DT as well as from
> +static data provided by the platform. It also gives the opportunity to
> +define the probing order by offering a sorting hook at run-time.
> +
> +As for the Linux driver model, the core device subsystem deals mainly
> +with device and driver objects. It also has the notion of "class" to
> +designate a group of devices implementing the same functionality, and
> +a group of drivers to be matched against the above devices
> +(CORE_DEV_CLASS_TIMER for example).
> +
> +One of the features is that the whole subsystem is discarded once the
> +kernel has booted. No structures can or should be retained after the
> +device has been probed. Of course, no support for module or other
> +evolved features. Another design feature is that it is *NOT* thread
> +safe. If you need any kind of mutual exclusion, you're probably using
> +core devices for something they are not designed for.
> +
> +* Core Device:
> +  ===========
> +
> +The struct core_device is fairly similar to a platform_device.
> +From "include/linux/core_device.h":
> +
> +struct core_device {
> +	const char		*name;
> +	u32			num_resources;
> +	struct resource		*resource;
> +	struct device_node	*of_node;
> +	struct list_head	entry;
> +};
> +
> +- name: friendly name for the device, will be used to match the driver
> +- num_resources: number of resources associated with the device
> +- resource: address of the resource array
> +- of_node: pointer to the DT node if the device has been populated by
> +  parsing the device tree. This is managed internally by the subsystem.
> +- entry: internal management list (not to be initialised).

Ignoring the question of "which devices are actually core devices" for
the moment, (which is a question that does need to be answered
regardless), I don't think the 'struct core_device' abstraction, or at
least the "core_device_register()" abstraction is what is needed.
When doing early setup for an SoC family, I better already have a
pretty darn good idea about what devices are "core devices".  We *do*
need a way to hook in setup code for a lot of different hardware in
abstract ways, but something like a device model I think goes to far.

It should be sufficient to have either implicitly or explicitly
registered setup functions and a helper function (lets call it an
early setup agent) that knows how to call them (which is pretty much
what you've got implemented), but instead of a separate
core_device_register() step, SoC code can pass a list of core devices
to the setup agent directly.  Or in the DT case, a match table.

g.

> +
> +The device is registered with the core device subsystem with:
> +void core_device_register(enum core_device_class class,
> +			  struct core_device *dev);
> +
> +where:
> +- class is one of CORE_DEV_CLASS_IRQ or CORE_DEV_CLASS_TIMER
> +- dev is the core device to be registered.
> +
> +A typical use is the following:
> +static struct resources twd_resources[] __initdata = {
> +	{
> +		.start	= 0x1f000600,
> +		.end	= 0x1f0006ff,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_LOCALTIMER,
> +		.end	= IRQ_LOCALTIMER,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct core_device twd_device _initdata = {
> +	.name		= "arm_smp_twd",
> +	.resource	= twd_resources,
> +	.num_resources	= ARRAY_SIZE(twd_resources),
> +};
> +
> +static void __init timer_init(void)
> +{
> +	core_device_register(CORE_DEV_CLASS_TIMER, &twd_device);
> +}
> +
> +Note that all structures are marked as __inidata, as none of them is
> +expected to be used after the kernel has booted.
> +
> +The devices can also be automatically allocated and registered by
> +parsing the device tree (if available) with the following function:
> +
> +void of_core_device_populate(enum core_device_class class,
> +			     struct of_device_id *matches);
> +
> +The allocated core_device structures will have their of_node member
> +pointing to the corresponding DT node. Resources will be allocated and
> +populated according to attributes found in the device tree.
> +
> +
> +
> +* Core driver:
> +  ===========
> +
> +The struct core_driver is the pendant to the core_device.
> +
> +struct core_driver {
> +	int			(*init)(struct core_device *);
> +	struct core_device_id	*ids;
> +};
> +
> +- init: initialisation function. Returns 0 on success, error code on
> +  failure.
> +- ids: a null-terminated array of struct core_device_id against which
> +  the device is matched.
> +
> +struct core_device_id {
> +	const char		*name;
> +};
> +
> +- name: string against which the device is matched
> +
> +core_driver_register(class, driver);
> +
> +Note that core_driver_register() is *not* a function, but expands to a
> +static data structure stored in a discardable section.
> +
> +A typical use is the following:
> +
> +static int __init twd_core_init(struct core_device *dev)
> +{
> +	[...]
> +	return 0;
> +}
> +static struct core_device_id twd_core_ids[] __initdata = {
> +	{ .name = "arm,smp-twd", },
> +	{ .name	= "arm_smp_twd", },
> +	{},
> +};
> +
> +static struct core_driver twd_core_driver __initdata = {
> +	.init		= twd_core_init,
> +	.ids		= twd_core_ids,
> +};
> +
> +core_driver_register(CORE_DEV_CLASS_TIMER, twd_core_driver);
> +
> +As for the core_device, all structures should be marked __initdata,
> +and the init function should be marked __init. The driver code must
> +*not* hold any reference to the core_device, as it can be freed just
> +after the init function has returned.
> +
> +
> +
> +* Device/Driver matching:
> +  ======================
> +
> +The core kernel code directly controls when devices and drivers are
> +matched (no matching-at-register-time) by calling:
> +
> +void core_driver_init_class(enum core_device_class class,
> +			    void (*sort)(struct list_head *));
> +
> +Where:
> +- class is one of CORE_DEV_CLASS_IRQ or CORE_DEV_CLASS_TIMER,
> +- sort is a pointer to a function sorting the device list before they
> +  are matched (NULL if unused).
> +
> +When this function is called:
> +
> +- All devices registered in "class" are probed with the matching
> +  registered drivers
> +- Once the devices in the class have been tried against the compiled
> +  in drivers, they are removed from the list (whether they have
> +  actually been probed or not).
> +- If core devices have been dynamically allocated (by
> +  of_core_device_populate()), they are freed.
> +
> +For example:
> +
> +/* List of supported timers */
> +static struct of_device_id timer_ids[] __initdata = {
> +	{ .compatible = "arm,smp-twd", },
> +	{},
> +};
> +
> +static void __init __arm_late_time_init(void)
> +{
> +	if (arm_late_time_init)
> +		arm_late_time_init();
> +
> +	/* Fetch the supported timers from the device tree */
> +	of_core_device_populate(CORE_DEV_CLASS_TIMER, timer_ids);
> +	/* Init the devices (both DT based and static), no preliminary sort */
> +	core_driver_init_class(CORE_DEV_CLASS_TIMER, NULL);
> +}
> +
> +
> +
> +* Sorting functions
> +  =================
> +
> +This may well fall into the hack category, and is probably only useful
> +when used with the device tree.
> +
> +Imagine you have a bunch of interrupt controllers to initialise. There
> +is probably one controller directly attached to the CPUs, and all the
> +others cascading (in)directly into the first one. There is a strong
> +requirement that these controllers are initialised in the right order
> +(closest to the CPU first).
> +
> +This is easy enough to achieve when static core devices are registered
> +(the registration order is preserved when probing), but is very
> +unlikely to occur when devices are imported from the device tree.
> +
> +The "sort" function that can be passed to core_driver_init_class() is
> +used to solve such a problem. It is called just before the devices are
> +matched against the drivers, and is allowed to reorganise the list
> +completely. It must not drop elements from the list though.
> +
> +One such sorting function is core_device_irq_sort(), which is designed
> +to solve the above problem, and is used like this:
> +
> +static struct of_device_id of_irq_controller_ids[] __initdata = {
> +	{ .compatible   = "arm,gic-spi", },
> +	{},
> +};
> +
> +void __init init_IRQ(void)
> +{
> +	machine_desc->init_irq();
> +	of_core_device_populate(CORE_DEV_CLASS_IRQ, of_irq_controller_ids);
> +	core_driver_init_class(CORE_DEV_CLASS_IRQ, core_device_irq_sort);
> +}
> +
> +In this snippet, all the "arm,gic-spi" devices are registered, and
> +then sorted at initialisation time by core_device_irq_sort().
> -- 
> 1.7.0.4
> 
> 
