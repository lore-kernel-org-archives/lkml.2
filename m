Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966437Ab2JZU0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:26:43 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:51014 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966399Ab2JZU0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:26:42 -0400
Date: Fri, 26 Oct 2012 16:14:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Jan Beulich <jbeulich@suse.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Message-ID: <20121026201409.GF2708@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
 <5089676602000078000A4928@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com>
 <508A89CB020000780008E6ED@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537292E@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233537292E@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 02:00:36PM +0000, Liu, Jinsong wrote:
> Updated per Jan's comments.
> 
> Thanks,
> Jinsong
> 
> ===============
> 
> >From e6d4eceba9538c6873f9c970425e65e257fd9bf0 Mon Sep 17 00:00:00 2001
> From: Liu, Jinsong <jinsong.liu@intel.com>
> Date: Sat, 27 Oct 2012 05:34:50 +0800
> Subject: [PATCH 1/2] Xen acpi pad implement
> 
> PAD is acpi Processor Aggregator Device which provides a control point
> that enables the platform to perform specific processor configuration
> and control that applies to all processors in the platform.
> 
> This patch is to implement Xen acpi pad logic. When running under Xen
> virt platform, native pad driver would not work. Instead Xen pad driver,
> a self-contained and very thin logic level, would take over acpi pad staff.
> When acpi pad notify OSPM, xen pad logic intercept and parse _PUR object
> and then hypercall to hyervisor for the rest work, say, core parking.
> 
> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> ---
>  drivers/xen/Makefile             |    1 +
>  drivers/xen/xen_acpi_pad.c       |  201 ++++++++++++++++++++++++++++++++++++++
>  include/xen/interface/platform.h |   17 +++
>  3 files changed, 219 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/xen/xen_acpi_pad.c
> 
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 0e86370..a2af622 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -29,6 +29,7 @@ obj-$(CONFIG_XEN_MCE_LOG)		+= mcelog.o
>  obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
>  obj-$(CONFIG_XEN_PRIVCMD)		+= xen-privcmd.o
>  obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+= xen-acpi-processor.o
> +obj-$(CONFIG_XEN_DOM0)			+= xen_acpi_pad.o

We should have a Kconfig option. In it, please mention what
version of hypervisor supports this functionality.

>  xen-evtchn-y				:= evtchn.o
>  xen-gntdev-y				:= gntdev.o
>  xen-gntalloc-y				:= gntalloc.o
> diff --git a/drivers/xen/xen_acpi_pad.c b/drivers/xen/xen_acpi_pad.c
> new file mode 100644
> index 0000000..0f1a1e6
> --- /dev/null
> +++ b/drivers/xen/xen_acpi_pad.c
> @@ -0,0 +1,201 @@
> +/*
> + * xen_acpi_pad.c - Xen pad interface
> + *
> + * Copyright (c) 2012, Intel Corporation.
> + *    Author: Liu, Jinsong <jinsong.liu@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <acpi/acpi_bus.h>
> +#include <acpi/acpi_drivers.h>
> +#include <asm/xen/hypercall.h>
> +
> +#if defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR) || \
> +		defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR_MODULE)

I don't think you need that.

> +
> +#define ACPI_PROCESSOR_AGGREGATOR_CLASS	"acpi_pad"
> +#define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
> +#define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
> +
> +static DEFINE_MUTEX(xen_pad_lock);
> +
> +static int xen_pad_set_idle_cpus(int num_cpus)
> +{
> +	struct xen_platform_op op;
> +
> +	if (num_cpus < 0)
> +		return -EINVAL;
> +
> +	/* set cpu nums expected to be idled */
> +	op.cmd = XENPF_core_parking;
> +	op.u.core_parking.type = XEN_CORE_PARKING_SET;
> +	op.u.core_parking.idle_nums = num_cpus;
> +
> +	return HYPERVISOR_dom0_op(&op);
> +}
> +
> +/*
> + * Cannot get idle cpus by using hypercall once (shared with _SET)
> + * because of the characteristic of Xen continue_hypercall_on_cpu
> + */
> +static int xen_pad_get_idle_cpus(void)
> +{
> +	int ret;
> +	struct xen_platform_op op;
> +
> +	/* get cpu nums actually be idled */
> +	op.cmd = XENPF_core_parking;
> +	op.u.core_parking.type = XEN_CORE_PARKING_GET;
> +	ret = HYPERVISOR_dom0_op(&op);
> +	if (ret < 0)
> +		return ret;
> +
> +	return op.u.core_parking.idle_nums;
> +}
> +
> +/*
> + * Query firmware how many CPUs should be idle
> + * return -1 on failure
> + */
> +static int xen_acpi_pad_pur(acpi_handle handle)
> +{
> +	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};
> +	union acpi_object *package;
> +	int num = -1;
> +
> +	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_PUR", NULL, &buffer)))
> +		return num;
> +
> +	if (!buffer.length || !buffer.pointer)
> +		return num;
> +
> +	package = buffer.pointer;
> +
> +	if (package->type == ACPI_TYPE_PACKAGE &&
> +		package->package.count == 2 &&
> +		package->package.elements[0].integer.value == 1) /* rev 1 */
> +
> +		num = package->package.elements[1].integer.value;
> +
> +	kfree(buffer.pointer);
> +	return num;
> +}
> +
> +/* Notify firmware how many CPUs are idle */
> +static void xen_acpi_pad_ost(acpi_handle handle, int stat,
> +	uint32_t idle_cpus)
> +{
> +	union acpi_object params[3] = {
> +		{.type = ACPI_TYPE_INTEGER,},
> +		{.type = ACPI_TYPE_INTEGER,},
> +		{.type = ACPI_TYPE_BUFFER,},
> +	};
> +	struct acpi_object_list arg_list = {3, params};
> +
> +	params[0].integer.value = ACPI_PROCESSOR_AGGREGATOR_NOTIFY;
> +	params[1].integer.value =  stat;
> +	params[2].buffer.length = 4;
> +	params[2].buffer.pointer = (void *)&idle_cpus;
> +	acpi_evaluate_object(handle, "_OST", &arg_list, NULL);
> +}
> +
> +static void xen_acpi_pad_handle_notify(acpi_handle handle)
> +{
> +	int num_cpus;
> +
> +	num_cpus = xen_acpi_pad_pur(handle);
> +	if (num_cpus < 0)
> +		return;
> +
> +	mutex_lock(&xen_pad_lock);
> +	if (xen_pad_set_idle_cpus(num_cpus)) {
> +		mutex_unlock(&xen_pad_lock);
> +		return;
> +	}
> +
> +	num_cpus = xen_pad_get_idle_cpus();
> +	if (num_cpus < 0) {
> +		mutex_unlock(&xen_pad_lock);
> +		return;
> +	}
> +	mutex_unlock(&xen_pad_lock);
> +
> +	xen_acpi_pad_ost(handle, 0, num_cpus);
> +}
> +
> +static void xen_acpi_pad_notify(acpi_handle handle, u32 event,
> +	void *data)
> +{
> +	switch (event) {
> +	case ACPI_PROCESSOR_AGGREGATOR_NOTIFY:
> +		xen_acpi_pad_handle_notify(handle);
> +		break;
> +	default:
> +		pr_warn("Unsupported event [0x%x]\n", event);
> +		break;
> +	}
> +}
> +
> +static int xen_acpi_pad_add(struct acpi_device *device)
> +{
> +	acpi_status status;
> +
> +	strcpy(acpi_device_name(device), ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME);
> +	strcpy(acpi_device_class(device), ACPI_PROCESSOR_AGGREGATOR_CLASS);
> +
> +	status = acpi_install_notify_handler(device->handle,
> +		 ACPI_DEVICE_NOTIFY, xen_acpi_pad_notify, device);
> +	if (ACPI_FAILURE(status))
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +static int xen_acpi_pad_remove(struct acpi_device *device,
> +	int type)
> +{
> +	mutex_lock(&xen_pad_lock);
> +	xen_pad_set_idle_cpus(0);
> +	mutex_unlock(&xen_pad_lock);
> +
> +	acpi_remove_notify_handler(device->handle,
> +		ACPI_DEVICE_NOTIFY, xen_acpi_pad_notify);
> +	return 0;
> +}
> +
> +static const struct acpi_device_id pad_device_ids[] = {
> +	{"ACPI000C", 0},
> +	{"", 0},
> +};
> +
> +static struct acpi_driver xen_acpi_pad_driver = {
> +	.name = "processor_aggregator",
> +	.class = ACPI_PROCESSOR_AGGREGATOR_CLASS,
> +	.ids = pad_device_ids,
> +	.ops = {
> +		.add = xen_acpi_pad_add,
> +		.remove = xen_acpi_pad_remove,
> +	},
> +};
> +
> +static int __init xen_acpi_pad_init(void)
> +{
> +	/* Only DOM0 is responsible for Xen acpi pad */
> +	if (xen_initial_domain())
> +		return acpi_bus_register_driver(&xen_acpi_pad_driver);
> +
> +	return -ENODEV;
> +}
> +subsys_initcall(xen_acpi_pad_init);


No way of making this a module? It would be nice - perhaps have a stub
function that registers the bus but does not do anything until this
proper module is loaded?

> +
> +#endif
> diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
> index 4755b5f..0f44376 100644
> --- a/include/xen/interface/platform.h
> +++ b/include/xen/interface/platform.h
> @@ -324,6 +324,22 @@ struct xenpf_cpu_ol {
>  };
>  DEFINE_GUEST_HANDLE_STRUCT(xenpf_cpu_ol);
>  
> +/*
> + * CMD 58 and 59 are reserved for cpu hotadd and memory hotadd,
> + * which already occupied at Xen hypervisor side.
           ^- are

> + */
> +#define XENPF_core_parking	60
> +struct xenpf_core_parking {
> +	/* IN variables */
> +#define XEN_CORE_PARKING_SET	1
> +#define XEN_CORE_PARKING_GET	2
> +	uint32_t type;
> +	/* IN variables:  set cpu nums expected to be idled */
> +	/* OUT variables: get cpu nums actually be idled */
> +	uint32_t idle_nums;
> +};
> +DEFINE_GUEST_HANDLE_STRUCT(xenpf_core_parking);
> +
>  struct xen_platform_op {
>  	uint32_t cmd;
>  	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
> @@ -341,6 +357,7 @@ struct xen_platform_op {
>  		struct xenpf_set_processor_pminfo set_pminfo;
>  		struct xenpf_pcpuinfo          pcpu_info;
>  		struct xenpf_cpu_ol            cpu_ol;
> +		struct xenpf_core_parking      core_parking;
>  		uint8_t                        pad[128];
>  	} u;
>  };
> -- 
> 1.7.1


