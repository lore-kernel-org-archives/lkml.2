Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1GHNIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 09:08:10 -0400
Received: from service87.mimecast.com ([94.185.240.25]:54740 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751890Ab1GHNIG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 09:08:06 -0400
Message-ID: <4E170134.1020306@arm.com>
Date: Fri, 08 Jul 2011 14:08:04 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC PATCH v2 0/4] Core device subsystem
References: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com> <CAHXqBFJiovYq5x_JDAxikvFs-t1To6yC-1uajBJFRX_jwjvejA@mail.gmail.com>
In-Reply-To: <CAHXqBFJiovYq5x_JDAxikvFs-t1To6yC-1uajBJFRX_jwjvejA@mail.gmail.com>
X-Enigmail-Version: 1.1.2
X-OriginalArrivalTime: 08 Jul 2011 13:08:00.0625 (UTC) FILETIME=[10509610:01CC3D70]
X-MC-Unique: 111070814080301701
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/11 12:37, Micha³ Miros³aw wrote:
> 2011/7/8 Marc Zyngier <marc.zyngier@arm.com>:
>> There is a small number of devices that the core kernel needs very
>> early in the boot process, namely an interrupt controller and a timer,
>> long before the driver model is up and running.
>>
>> Most architectures implement this requirement by hardcoding the
>> initialisation of a "well known" piece of hardware which is standard
>> enough to work on any platform.
>>
>> This is very different on the ARM architecture, where platforms have a
>> variety of interrupt controllers and timers. While the same hardcoding
>> is possible (and is actually used), it makes it almost impossible to
>> support several platforms in the same kernel.
>>
>> Though the device tree is helping greatly to solve this problem, some
>> platform won't ever be converted to DT, hence the need to have a
>> mechanism supporting a variety of information source. Early platform
>> devices having been deemed unsuitable (complexity, abuse of various
>> subsystems), this subsystem has been designed to provide the very
>> minimal level of functionality.
>>
>> The "core device subsystem" offers a class based device/driver
>> matching model, doesn't rely on any other subsystem, is very (too?)
>> simple, and support getting information both from DT as well as from
>> static data provided by the platform. It also gives the opportunity to
>> define the probing order by offering a sorting hook at run-time.
> [...]
> 
> I gave it some thought and it looks like your idea can be modified to
> make it even less demanding on machine setup code.
> 
> For the DT case, all this can work without adding a single
> board-specific code (even machine_desc->init_irq() is not needed).

machine_desc->init_irq() is only here for legacy purpose.
And this call is already outside of the platform code.

> of_init_core_device_class(class)
> {
>   int ids_count = 0;
>   struct of_device_id *ids, *p;
> 
>   for_each_core_device_driver(drv, class)
>     for_each_core_device_id(id, drv)
>       ++ids_count;
> 
>   p = ids = kzalloc(...);
> 
>   for_each_core_device_driver(drv, class)
>     for_each_core_device_id(id, drv) {
>       p->compatible = id->name;
>       p->data = drv;
>     }
> 
>   // generate matching device list from devicetree
> 
>   if (class == CORE_DEV_CLASS_IRQ)
>     // sort the list (for intc class)
> 
>   core_driver_init_class(class);
>   // call above could use matched ids' data field for finding
>   // driver struct instead of traversing the driver list again
> }

So you're basically folding of_core_device_populate() and
core_driver_init_class() into one call, and generating the
of_device_ids on the fly. If you're going down that road,
it would be even simpler to directly use of_device_ids
instead of core_device_ids and skip the generation altogether.

That would also remove the static declaration of devices to be
probed in the architecture support code...

Let me think of it and prototype that.

> For non-DT case, the board code would need to provide the devices with
> core_device_register() in init_irq() or wherever is apropriate.

That's the way it is supposed to work already
(from my local pb11mp board file):

[...]
#ifndef CONFIG_OF
static struct resource realview_pb11mp_primary_gic_resources[] __initdata = {
[...]
};

static struct core_device realview_pb11mp_primary_gic __initdata = {
	.name		= "arm_gic",
	.resource	= realview_pb11mp_primary_gic_resources,
	.num_resources	= ARRAY_SIZE(realview_pb11mp_primary_gic_resources),
};

static struct resource realview_pb11mp_secondary_gic_resources[] __initdata = {
[...]
};

static struct core_device realview_pb11mp_secondary_gic __initdata = {
	.name		= "arm_gic",
	.resource	= realview_pb11mp_secondary_gic_resources,
	.num_resources	= ARRAY_SIZE(realview_pb11mp_secondary_gic_resources),
};
#endif

static void __init gic_init_irq(void)
{
	unsigned int pldctrl;

	/* new irq mode with no DCC */
	writel(0x0000a05f, __io_address(REALVIEW_SYS_LOCK));
	pldctrl = readl(__io_address(REALVIEW_SYS_BASE)	+ REALVIEW_PB11MP_SYS_PLD_CTRL1);
	pldctrl |= 2 << 22;
	writel(pldctrl, __io_address(REALVIEW_SYS_BASE) + REALVIEW_PB11MP_SYS_PLD_CTRL1);
	writel(0x00000000, __io_address(REALVIEW_SYS_LOCK));
#ifndef CONFIG_OF
	core_device_register(CORE_DEV_CLASS_IRQ, &realview_pb11mp_primary_gic);
	core_device_register(CORE_DEV_CLASS_IRQ, &realview_pb11mp_secondary_gic);
#endif
}


> For simplicity I thing mixing static and DT initialization should not
> be allowed (for a single machine) - then static/DT initialization
> order won't matter.

I don't think I ever thought of supporting such a setup, at least not
within a single class (different classes are definitely supported).

> I hope this is useful for you. :)

It is. Thanks for the comments!

	M.
-- 
Jazz is not dead. It just smells funny...

