Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab2KEPRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:17:25 -0500
Received: from smtp.citrix.com ([66.165.176.89]:22558 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387Ab2KEPRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:17:24 -0500
X-IronPort-AV: E=Sophos;i="4.80,715,1344211200"; 
   d="scan'208";a="43445437"
Date: Mon, 5 Nov 2012 15:16:40 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: "Liu, Jinsong" <jinsong.liu@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <jbeulich@suse.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
In-Reply-To: <20121102164937.GC27213@konrad-lan.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1211051512260.2689@kaball.uk.xensource.com>
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com> <5089676602000078000A4928@nat28.tlf.novell.com> <DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com> <508A89CB020000780008E6ED@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com> <DE8DF0795D48FD4CA783C40EC829233537292E@SHSMSX101.ccr.corp.intel.com> <20121026201409.GF2708@phenom.dumpdata.com> <DE8DF0795D48FD4CA783C40EC8292335377346@SHSMSX101.ccr.corp.intel.com>
 <20121102164937.GC27213@konrad-lan.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.80.2.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> > index 0e86370..a2af622 100644
> > --- a/drivers/xen/Makefile
> > +++ b/drivers/xen/Makefile
> > @@ -29,6 +29,7 @@ obj-$(CONFIG_XEN_MCE_LOG)           += mcelog.o
> >  obj-$(CONFIG_XEN_PCIDEV_BACKEND)     += xen-pciback/
> >  obj-$(CONFIG_XEN_PRIVCMD)            += xen-privcmd.o
> >  obj-$(CONFIG_XEN_ACPI_PROCESSOR)     += xen-acpi-processor.o
> > +obj-$(CONFIG_XEN_DOM0)                       += xen_acpi_pad.o
> >  xen-evtchn-y                         := evtchn.o
> >  xen-gntdev-y                         := gntdev.o
> >  xen-gntalloc-y                               := gntalloc.o

it should really depend on ACPI and maybe also X86, otherwise it is
going to break the ARM build


> > diff --git a/drivers/xen/xen_acpi_pad.c b/drivers/xen/xen_acpi_pad.c
> > new file mode 100644
> > index 0000000..e8c26a4
> > --- /dev/null
> > +++ b/drivers/xen/xen_acpi_pad.c
> > @@ -0,0 +1,206 @@
> > +/*
> > + * xen_acpi_pad.c - Xen pad interface
> > + *
> > + * Copyright (c) 2012, Intel Corporation.
> > + *    Author: Liu, Jinsong <jinsong.liu@intel.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> > + * more details.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/types.h>
> > +#include <acpi/acpi_bus.h>
> > +#include <acpi/acpi_drivers.h>
> > +#include <asm/xen/hypercall.h>
> > +#include <xen/interface/version.h>
> > +
> > +#define ACPI_PROCESSOR_AGGREGATOR_CLASS      "acpi_pad"
> > +#define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
> > +#define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
> > +
> > +static DEFINE_MUTEX(xen_pad_lock);
> > +
> > +static int xen_pad_set_idle_cpus(int num_cpus)
> > +{
> > +     struct xen_platform_op op;
> > +
> > +     if (num_cpus < 0)
> > +             return -EINVAL;
> > +
> > +     /* set cpu nums expected to be idled */
> > +     op.cmd = XENPF_core_parking;
> > +     op.u.core_parking.type = XEN_CORE_PARKING_SET;
> > +     op.u.core_parking.idle_nums = num_cpus;
> > +
> > +     return HYPERVISOR_dom0_op(&op);
> > +}
> > +
> > +/*
> > + * Cannot get idle cpus by using hypercall once (shared with _SET)
> > + * because of the characteristic of Xen continue_hypercall_on_cpu
> > + */
> > +static int xen_pad_get_idle_cpus(void)
> > +{
> > +     int ret;
> > +     struct xen_platform_op op;
> > +
> > +     /* get cpu nums actually be idled */
> > +     op.cmd = XENPF_core_parking;
> > +     op.u.core_parking.type = XEN_CORE_PARKING_GET;
> > +     ret = HYPERVISOR_dom0_op(&op);
> > +     if (ret < 0)
> > +             return ret;
> > +
> > +     return op.u.core_parking.idle_nums;
> > +}
> > +
> > +/*
> > + * Query firmware how many CPUs should be idle
> > + * return -1 on failure
> > + */
> > +static int xen_acpi_pad_pur(acpi_handle handle)
> > +{
> > +     struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};
> > +     union acpi_object *package;
> > +     int num = -1;
> > +
> > +     if (ACPI_FAILURE(acpi_evaluate_object(handle, "_PUR", NULL, &buffer)))
> > +             return num;
> > +
> > +     if (!buffer.length || !buffer.pointer)
> > +             return num;
> > +
> > +     package = buffer.pointer;
> > +
> > +     if (package->type == ACPI_TYPE_PACKAGE &&
> > +             package->package.count == 2 &&
> > +             package->package.elements[0].integer.value == 1) /* rev 1 */
> > +
> > +             num = package->package.elements[1].integer.value;
> > +
> > +     kfree(buffer.pointer);
> > +     return num;
> > +}
> > +
> > +/* Notify firmware how many CPUs are idle */
> > +static void xen_acpi_pad_ost(acpi_handle handle, int stat,
> > +     uint32_t idle_cpus)
> > +{
> > +     union acpi_object params[3] = {
> > +             {.type = ACPI_TYPE_INTEGER,},
> > +             {.type = ACPI_TYPE_INTEGER,},
> > +             {.type = ACPI_TYPE_BUFFER,},
> > +     };
> > +     struct acpi_object_list arg_list = {3, params};
> > +
> > +     params[0].integer.value = ACPI_PROCESSOR_AGGREGATOR_NOTIFY;
> > +     params[1].integer.value =  stat;
> > +     params[2].buffer.length = 4;
> > +     params[2].buffer.pointer = (void *)&idle_cpus;
> > +     acpi_evaluate_object(handle, "_OST", &arg_list, NULL);
> > +}
> > +
> > +static void xen_acpi_pad_handle_notify(acpi_handle handle)
> > +{
> > +     int num_cpus;
> > +
> > +     num_cpus = xen_acpi_pad_pur(handle);
> > +     if (num_cpus < 0)
> > +             return;
> > +
> > +     mutex_lock(&xen_pad_lock);
> > +     if (xen_pad_set_idle_cpus(num_cpus)) {
> > +             mutex_unlock(&xen_pad_lock);
> > +             return;
> > +     }
> > +
> > +     num_cpus = xen_pad_get_idle_cpus();
> > +     if (num_cpus < 0) {
> > +             mutex_unlock(&xen_pad_lock);
> > +             return;
> > +     }
> > +     mutex_unlock(&xen_pad_lock);
> > +
> > +     xen_acpi_pad_ost(handle, 0, num_cpus);
> > +}
> > +
> > +static void xen_acpi_pad_notify(acpi_handle handle, u32 event,
> > +     void *data)
> > +{
> > +     switch (event) {
> > +     case ACPI_PROCESSOR_AGGREGATOR_NOTIFY:
> > +             xen_acpi_pad_handle_notify(handle);
> > +             break;
> > +     default:
> > +             pr_warn("Unsupported event [0x%x]\n", event);
> > +             break;
> > +     }
> > +}
> > +
> > +static int xen_acpi_pad_add(struct acpi_device *device)
> > +{
> > +     acpi_status status;
> > +
> > +     strcpy(acpi_device_name(device), ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME);
> > +     strcpy(acpi_device_class(device), ACPI_PROCESSOR_AGGREGATOR_CLASS);
> > +
> > +     status = acpi_install_notify_handler(device->handle,
> > +              ACPI_DEVICE_NOTIFY, xen_acpi_pad_notify, device);
> > +     if (ACPI_FAILURE(status))
> > +             return -ENODEV;
> > +
> > +     return 0;
> > +}
> > +
> > +static int xen_acpi_pad_remove(struct acpi_device *device,
> > +     int type)
> > +{
> > +     mutex_lock(&xen_pad_lock);
> > +     xen_pad_set_idle_cpus(0);
> > +     mutex_unlock(&xen_pad_lock);
> > +
> > +     acpi_remove_notify_handler(device->handle,
> > +             ACPI_DEVICE_NOTIFY, xen_acpi_pad_notify);
> > +     return 0;
> > +}
> > +
> > +static const struct acpi_device_id pad_device_ids[] = {
> > +     {"ACPI000C", 0},
> > +     {"", 0},
> > +};
> > +
> > +static struct acpi_driver xen_acpi_pad_driver = {
> > +     .name = "processor_aggregator",
> > +     .class = ACPI_PROCESSOR_AGGREGATOR_CLASS,
> > +     .ids = pad_device_ids,
> > +     .ops = {
> > +             .add = xen_acpi_pad_add,
> > +             .remove = xen_acpi_pad_remove,
> > +     },
> > +};
> > +
> > +static int __init xen_acpi_pad_init(void)
> > +{
> > +     int ret = -ENOSYS;
> > +     unsigned int version = HYPERVISOR_xen_version(XENVER_version, NULL);
> 
> Heh. so if you run this on baremetal I wonder what will happen.
> 
> > +     unsigned int major = version >> 16;
> > +     unsigned int minor = version & 0xffff;
> > +
> > +     /* Only DOM0 is responsible for Xen acpi pad */
> > +     if (!xen_initial_domain())
> > +             return -ENODEV;
> > +
> 
> I think the check for version should happen here.
> 
> > +     /* Only Xen4.2 or later support Xen acpi pad */
> > +     if (((major == 4) && (minor >= 2)) || (major > 4))
> > +             ret = acpi_bus_register_driver(&xen_acpi_pad_driver);
> > +
> > +     return ret;
> > +}
> > +subsys_initcall(xen_acpi_pad_init);
> > diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
> > index 4755b5f..a3be54c 100644
> > --- a/include/xen/interface/platform.h
> > +++ b/include/xen/interface/platform.h
> > @@ -324,6 +324,22 @@ struct xenpf_cpu_ol {
> >  };
> >  DEFINE_GUEST_HANDLE_STRUCT(xenpf_cpu_ol);
> >
> > +/*
> > + * CMD 58 and 59 are reserved for cpu hotadd and memory hotadd,
> > + * which are already occupied at Xen hypervisor side.
> > + */
> > +#define XENPF_core_parking   60
> > +struct xenpf_core_parking {
> > +     /* IN variables */
> > +#define XEN_CORE_PARKING_SET 1
> > +#define XEN_CORE_PARKING_GET 2
> > +     uint32_t type;
> > +     /* IN variables:  set cpu nums expected to be idled */
> > +     /* OUT variables: get cpu nums actually be idled */
> > +     uint32_t idle_nums;
> > +};
> > +DEFINE_GUEST_HANDLE_STRUCT(xenpf_core_parking);
> > +
> >  struct xen_platform_op {
> >       uint32_t cmd;
> >       uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
> > @@ -341,6 +357,7 @@ struct xen_platform_op {
> >               struct xenpf_set_processor_pminfo set_pminfo;
> >               struct xenpf_pcpuinfo          pcpu_info;
> >               struct xenpf_cpu_ol            cpu_ol;
> > +             struct xenpf_core_parking      core_parking;
> >               uint8_t                        pad[128];
> >       } u;
> >  };
> > --
> > 1.7.1
> 
> 
> > _______________________________________________
> > Xen-devel mailing list
> > Xen-devel@lists.xen.org
> > http://lists.xen.org/xen-devel
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
