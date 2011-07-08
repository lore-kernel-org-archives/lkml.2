Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab1GHKde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 06:33:34 -0400
Received: from service87.mimecast.com ([94.185.240.25]:57277 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751002Ab1GHKdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 06:33:33 -0400
Message-ID: <4E16DCFA.5050903@arm.com>
Date: Fri, 08 Jul 2011 11:33:30 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC PATCH v2 2/4] Core device subsystem implementation
References: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>	<1310115250-3859-3-git-send-email-marc.zyngier@arm.com> <CAHXqBFJcO8-7v+SZ88jx6XjDQBFUybTjOU=LWdsc3ChD4bU_=g@mail.gmail.com>
In-Reply-To: <CAHXqBFJcO8-7v+SZ88jx6XjDQBFUybTjOU=LWdsc3ChD4bU_=g@mail.gmail.com>
X-Enigmail-Version: 1.1.2
X-OriginalArrivalTime: 08 Jul 2011 10:33:26.0434 (UTC) FILETIME=[78775820:01CC3D5A]
X-MC-Unique: 111070811333003101
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/11 11:18, Micha³ Miros³aw wrote:
> 2011/7/8 Marc Zyngier <marc.zyngier@arm.com>:
>> There is a small number of devices that the core kernel needs very
>> early in the boot process, namely an interrupt controller and a timer,
>> long before the device model is up and running.
>>
>> The "core device subsystem" offers a class based device/driver
>> matching model, doesn't rely on any other subsystem, is very (too?)
>> simple, and support getting information both from DT as well as from
>> static data provided by the platform. It also gives the opportunity to
>> define the probing order by offering a sorting hook at runtime.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> [...]
>> --- /dev/null
>> +++ b/drivers/base/core_device.c
>> @@ -0,0 +1,108 @@
> [...]
>> +static int __init core_device_match(struct core_device *dev,
>> +                                   struct core_device_id *ids)
>> +{
>> +       int i;
>> +#ifdef CONFIG_OF
>> +       if (dev->of_node)
>> +               for (i = 0; ids[i].name != NULL; i++)
>> +                       if (of_device_is_compatible(dev->of_node,
>> +                                                   ids[i].name))
>> +                               return 1;
> 
> Add an else here? I assume DT devices shouldn't be matched by name.

Good point. I'll update that.

>> +#endif
>> +       for (i = 0; ids[i].name != NULL; i++)
>> +               if (!strcmp(dev->name, ids[i].name))
>> +                       return 1;
>> +
>> +       return 0;
>> +}
>> +
> [...]
>> --- /dev/null
>> +++ b/include/linux/core_device.h
>> @@ -0,0 +1,69 @@
>> +/*
>> + * Copyright (C) 2011 ARM Ltd
>> + * Written by Marc Zyngier <marc.zyngier@arm.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * Core device init support
>> + */
>> +
>> +#ifndef _CORE_DEVICE_H
>> +#define _CORE_DEVICE_H
>> +
>> +#include <linux/list.h>
>> +#include <linux/ioport.h>
>> +#include <linux/of.h>
>> +
>> +struct core_device_id {
>> +       const char              *name;
>> +};
>> +
>> +enum core_device_class {
>> +       CORE_DEV_CLASS_IRQ,
>> +       CORE_DEV_CLASS_TIMER,
>> +       CORE_DEV_CLASS_MAX              /* Do not use as a class */
>> +};
> 
> CORE_DEV_CLASS_MAX -> CORE_DEV_CLASS_COUNT
> 
> _MAX suggests that this is the largest value, but in this case it is a count.

_MAX seem to be the established usage in the kernel (I just grep-ed for
"_MAX," in include/linux, and found a number of similar uses, while only
ACPI seem to be using _COUNT).

>> +
>> +struct core_device {
>> +       const char              *name;
>> +       u32                     num_resources;
>> +       struct resource         *resource;
>> +#ifdef CONFIG_OF
>> +       struct device_node      *of_node;
>> +#endif
>> +       struct list_head        entry;
>> +};
>> +
>> +struct core_driver {
>> +       int                     (*init)(struct core_device *);
>> +       struct core_device_id   *ids;
>> +};
>> +
>> +void core_device_register(enum core_device_class class,
>> +                         struct core_device *dev);
>> +void core_driver_init_class(enum core_device_class class,
>> +                           void (*sort)(struct list_head *));
>> +#ifdef CONFIG_OF
>> +void of_core_device_populate(enum core_device_class class,
>> +                            struct of_device_id *matches);
>> +#else
>> +static inline void of_core_device_populate(enum core_device_class class,
>> +                                          struct of_device_id *matches)
>> +{
>> +}
>> +#endif
>> +
>> +struct core_driver_setup_block {
>> +       enum core_device_class  class;
>> +       struct core_driver      *drv;
>> +};
>> +
>> +#define core_driver_register(cls, drv)                                 \
>> +static struct core_driver_setup_block __core_driver_block_##cls##_##drv        \
>> +       __used __section(.init.core_driver)                             \
>> +       __attribute__((aligned((sizeof(long)))))                        \
>> +       = { cls, &drv }
>> +
>> +#endif
> 
> Since core_driver_register() is not a function it shouldn't look like
> one. Something like DEFINE_CORE_DRIVER_ENTRY() would be better. I
> would make cls to be only the last word of CORE_DEV_CLASS_* values so
> its less typing in the board files (unless you don't like CPP string
> concatenation).
> 
> +#define DEFINE_CORE_DRIVER_ENTRY(cls, drv)                               \
> +static struct core_driver_setup_block __core_driver_block_##cls##_##drv  \
> +       __used __section(.init.core_driver)                               \
> +       = { CORE_DEV_CLASS_##cls, &drv }

I fully agree with the "not a function" approach. I'm more cautious with
the "CORE_DEV_CLASS_##cls" bit.  I feel like it's hiding a bit too much
of what's going on, but it's only my own feeling, and I'd be happy to
change it if that's what people prefer.

Thanks for reviewing,

	M.
-- 
Jazz is not dead. It just smells funny...

