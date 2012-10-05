Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab2JEPgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:36:44 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62181 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab2JEPgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:36:40 -0400
MIME-Version: 1.0
In-Reply-To: <1348818006.10877.323.camel@rui.sh.intel.com>
References: <1348818006.10877.323.camel@rui.sh.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 5 Oct 2012 09:36:19 -0600
Message-ID: <CAErSpo5NK4Gs_Kg1UkYvdsYMQ4eSTqy2nGW4W7RPEofU5ZADsA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/6] ACPI: introduce acpi_get_generic_resources
To: Zhang Rui <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 1:40 AM, Zhang Rui <rui.zhang@intel.com> wrote:
> From 9a851d177794129a89f720c7122cb39fd163126b Mon Sep 17 00:00:00 2001
> From: Zhang Rui <rui.zhang@intel.com>
> Date: Fri, 28 Sep 2012 08:34:05 +0800
> Subject: [RFC PATCH 3/6] ACPI: introduce acpi_get_generic_resources
>
> Introduce acpi_get_generic_resources() to convert
> ACPI style resources to struct resource.

This seems obviously similar to drivers/pnp/pnpacpi/rsparser.c, but
only handles a few of the resource types.  Do you plan to extend this
to support everything rsparser.c supports?  Do you envision replacing
the current PNPACPI/PNPBIOS/ISAPNP stuff with something built on what
you're doing here?  We already have two ways for drivers to bind to
ACPI devices (pnp_register_driver() and acpi_bus_register_driver()).
I hope we are moving toward *one* way rather than three ways :)

> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/acpi/Makefile   |    1 +
>  drivers/acpi/resource.c |  165 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/acpi/acpi_bus.h |    1 +
>  3 files changed, 167 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/acpi/resource.c
>
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index 6b1d535..4b65608 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -46,6 +46,7 @@ acpi-$(CONFIG_ACPI_PROCFS_POWER) += cm_sbs.o
>  ifdef CONFIG_ACPI_VIDEO
>  acpi-y                         += video_detect.o
>  endif
> +acpi-y                         += resource.o
>
>  # These are (potentially) separate modules
>  obj-$(CONFIG_ACPI_AC)          += ac.o
> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> new file mode 100644
> index 0000000..30a5204
> --- /dev/null
> +++ b/drivers/acpi/resource.c
> @@ -0,0 +1,165 @@
> +/*
> + * resource.c -- convert ACPI resource to generic resource
> + *
> + * Copyright (c) 2012 Zhang Rui <rui.zhang@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + */
> +#include <linux/kernel.h>
> +#include <linux/export.h>
> +#include <linux/acpi.h>
> +
> +static int irq_flags(int triggering, int polarity, int sharable)
> +{
> +       int flags;
> +
> +       if (triggering == ACPI_LEVEL_SENSITIVE) {
> +               if (polarity == ACPI_ACTIVE_LOW)
> +                       flags = IORESOURCE_IRQ_LOWLEVEL;
> +               else
> +                       flags = IORESOURCE_IRQ_HIGHLEVEL;
> +       } else {
> +               if (polarity == ACPI_ACTIVE_LOW)
> +                       flags = IORESOURCE_IRQ_LOWEDGE;
> +               else
> +                       flags = IORESOURCE_IRQ_HIGHEDGE;
> +       }
> +
> +       if (sharable == ACPI_SHARED)
> +               flags |= IORESOURCE_IRQ_SHAREABLE;
> +
> +       return flags;
> +}
> +
> +static void acpi_get_irq_resource(struct acpi_resource *res,
> +                                 struct resource *resource)
> +{
> +       struct acpi_resource_irq *irq = &res->data.irq;
> +       int t, p;
> +
> +       if (irq->interrupt_count == 0)
> +               resource->flags = IORESOURCE_DISABLED;
> +
> +       if (!acpi_get_override_irq(irq->interrupts[0], &t, &p)) {
> +               t = t ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE;
> +               p = p ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
> +
> +               if (irq->triggering != t || irq->polarity != p) {
> +                       irq->triggering = t;
> +                       irq->polarity = p;
> +               }
> +       }
> +
> +       resource->flags =
> +           irq_flags(irq->triggering, irq->polarity, irq->sharable);
> +       resource->flags |= IORESOURCE_IRQ;
> +       resource->start = irq->interrupts[0];
> +       resource->end = irq->interrupts[0];
> +}
> +
> +static void acpi_get_extended_irq_resource(struct acpi_resource *res,
> +                                          struct resource *resource)
> +{
> +       struct acpi_resource_extended_irq *irq = &res->data.extended_irq;
> +       int t, p;
> +
> +       if (irq->interrupt_count == 0)
> +               resource->flags = IORESOURCE_DISABLED;
> +
> +       if (!acpi_get_override_irq(irq->interrupts[0], &t, &p)) {
> +               t = t ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE;
> +               p = p ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
> +
> +               if (irq->triggering != t || irq->polarity != p) {
> +                       irq->triggering = t;
> +                       irq->polarity = p;
> +               }
> +       }
> +
> +       resource->flags =
> +           irq_flags(irq->triggering, irq->polarity, irq->sharable);
> +       resource->flags |= IORESOURCE_IRQ;
> +       resource->start = irq->interrupts[0];
> +       resource->end = irq->interrupts[0];
> +}
> +
> +static void acpi_get_mem_resource(struct acpi_resource *res,
> +                                 struct resource *resource)
> +{
> +       struct acpi_resource_fixed_memory32 *mem = &res->data.fixed_memory32;
> +
> +       if (mem->address_length == 0)
> +               resource->flags |= IORESOURCE_DISABLED;
> +       if (mem->write_protect == ACPI_READ_WRITE_MEMORY)
> +               resource->flags |= IORESOURCE_MEM_WRITEABLE;
> +
> +       resource->flags |= IORESOURCE_MEM;
> +       resource->start = mem->address;
> +       resource->end = mem->address + mem->address_length - 1;
> +}
> +
> +int acpi_get_generic_resources(struct acpi_device *device,
> +                              struct resource **resources)
> +{
> +       acpi_status status;
> +       struct acpi_buffer buffer;
> +       struct acpi_resource *res;
> +       struct resource *p;
> +       int res_count;
> +       int i;
> +
> +       status = acpi_get_current_resources(device->handle, &buffer);
> +       if (ACPI_FAILURE(status)) {
> +               dev_err(&device->dev, "can't get ACPI resources\n");
> +               return -EINVAL;
> +       }
> +
> +       res_count = (buffer.length - 1) / sizeof(struct acpi_resource) - 1;
> +       p = kzalloc(sizeof(struct resource) * res_count, GFP_KERNEL);
> +       if (!resources) {
> +               kfree(buffer.pointer);
> +               return -ENOMEM;
> +       }
> +
> +       res = (struct acpi_resource *)buffer.pointer;
> +       i = 0;
> +
> +       while (res->type != ACPI_RESOURCE_TYPE_END_TAG) {
> +
> +               switch (res->type) {
> +               case ACPI_RESOURCE_TYPE_IRQ:
> +                       acpi_get_irq_resource(res, &p[i]);
> +                       break;
> +               case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
> +                       acpi_get_extended_irq_resource(res, &p[i]);
> +                       break;
> +               case ACPI_RESOURCE_TYPE_MEMORY32:
> +                       acpi_get_mem_resource(res, &p[i]);
> +                       break;
> +               default:
> +                       i--;
> +                       break;
> +               }
> +               i++;
> +               res = ACPI_NEXT_RESOURCE(res);
> +       }
> +
> +       /* Get rid of unsupported ACPI resources */
> +       if (i != res_count)
> +               p =
> +                   kmemdup(p, sizeof(struct resource) * i, GFP_KERNEL);
> +
> +       *resources = p;
> +       kfree(buffer.pointer);
> +       return i;
> +}
> +
> +EXPORT_SYMBOL(acpi_get_generic_resources);
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index 8b5b124..a4f8eaf 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -381,6 +381,7 @@ int acpi_match_device_ids(struct acpi_device *device,
>  int acpi_match_device_id(const struct device *, const char *);
>  int acpi_create_dir(struct acpi_device *);
>  void acpi_remove_dir(struct acpi_device *);
> +int acpi_get_generic_resources(struct acpi_device *, struct resource **);
>
>  /*
>   * Bind physical devices with ACPI devices
> --
> 1.7.7.6
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
