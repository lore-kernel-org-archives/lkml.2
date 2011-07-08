Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab1GHKSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 06:18:50 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35701 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1GHKSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 06:18:48 -0400
MIME-Version: 1.0
In-Reply-To: <1310115250-3859-3-git-send-email-marc.zyngier@arm.com>
References: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>
	<1310115250-3859-3-git-send-email-marc.zyngier@arm.com>
Date: Fri, 8 Jul 2011 12:18:47 +0200
Message-ID: <CAHXqBFJcO8-7v+SZ88jx6XjDQBFUybTjOU=LWdsc3ChD4bU_=g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/4] Core device subsystem implementation
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/8 Marc Zyngier <marc.zyngier@arm.com>:
> There is a small number of devices that the core kernel needs very
> early in the boot process, namely an interrupt controller and a timer,
> long before the device model is up and running.
>
> The "core device subsystem" offers a class based device/driver
> matching model, doesn't rely on any other subsystem, is very (too?)
> simple, and support getting information both from DT as well as from
> static data provided by the platform. It also gives the opportunity to
> define the probing order by offering a sorting hook at runtime.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
[...]
> --- /dev/null
> +++ b/drivers/base/core_device.c
> @@ -0,0 +1,108 @@
[...]
> +static int __init core_device_match(struct core_device *dev,
> +                                   struct core_device_id *ids)
> +{
> +       int i;
> +#ifdef CONFIG_OF
> +       if (dev->of_node)
> +               for (i = 0; ids[i].name != NULL; i++)
> +                       if (of_device_is_compatible(dev->of_node,
> +                                                   ids[i].name))
> +                               return 1;

Add an else here? I assume DT devices shouldn't be matched by name.

> +#endif
> +       for (i = 0; ids[i].name != NULL; i++)
> +               if (!strcmp(dev->name, ids[i].name))
> +                       return 1;
> +
> +       return 0;
> +}
> +
[...]
> --- /dev/null
> +++ b/include/linux/core_device.h
> @@ -0,0 +1,69 @@
> +/*
> + * Copyright (C) 2011 ARM Ltd
> + * Written by Marc Zyngier <marc.zyngier@arm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Core device init support
> + */
> +
> +#ifndef _CORE_DEVICE_H
> +#define _CORE_DEVICE_H
> +
> +#include <linux/list.h>
> +#include <linux/ioport.h>
> +#include <linux/of.h>
> +
> +struct core_device_id {
> +       const char              *name;
> +};
> +
> +enum core_device_class {
> +       CORE_DEV_CLASS_IRQ,
> +       CORE_DEV_CLASS_TIMER,
> +       CORE_DEV_CLASS_MAX              /* Do not use as a class */
> +};

CORE_DEV_CLASS_MAX -> CORE_DEV_CLASS_COUNT

_MAX suggests that this is the largest value, but in this case it is a count.

> +
> +struct core_device {
> +       const char              *name;
> +       u32                     num_resources;
> +       struct resource         *resource;
> +#ifdef CONFIG_OF
> +       struct device_node      *of_node;
> +#endif
> +       struct list_head        entry;
> +};
> +
> +struct core_driver {
> +       int                     (*init)(struct core_device *);
> +       struct core_device_id   *ids;
> +};
> +
> +void core_device_register(enum core_device_class class,
> +                         struct core_device *dev);
> +void core_driver_init_class(enum core_device_class class,
> +                           void (*sort)(struct list_head *));
> +#ifdef CONFIG_OF
> +void of_core_device_populate(enum core_device_class class,
> +                            struct of_device_id *matches);
> +#else
> +static inline void of_core_device_populate(enum core_device_class class,
> +                                          struct of_device_id *matches)
> +{
> +}
> +#endif
> +
> +struct core_driver_setup_block {
> +       enum core_device_class  class;
> +       struct core_driver      *drv;
> +};
> +
> +#define core_driver_register(cls, drv)                                 \
> +static struct core_driver_setup_block __core_driver_block_##cls##_##drv        \
> +       __used __section(.init.core_driver)                             \
> +       __attribute__((aligned((sizeof(long)))))                        \
> +       = { cls, &drv }
> +
> +#endif

Since core_driver_register() is not a function it shouldn't look like
one. Something like DEFINE_CORE_DRIVER_ENTRY() would be better. I
would make cls to be only the last word of CORE_DEV_CLASS_* values so
its less typing in the board files (unless you don't like CPP string
concatenation).

+#define DEFINE_CORE_DRIVER_ENTRY(cls, drv)                               \
+static struct core_driver_setup_block __core_driver_block_##cls##_##drv  \
+       __used __section(.init.core_driver)                               \
+       = { CORE_DEV_CLASS_##cls, &drv }

Best Regards,
Micha³ Miros³aw
