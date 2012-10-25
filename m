Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab2JZNNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 09:13:16 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:53899 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758550Ab2JZNNN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 26 Oct 2012 09:13:13 -0400
Message-Id: <5089676602000078000A4928@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 25 Oct 2012 15:23:02 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jinsong Liu" <jinsong.liu@intel.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.10.12 at 14:19, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
> --- /dev/null
> +++ b/drivers/xen/xen_acpi_pad.c
> @@ -0,0 +1,173 @@
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
> +
> +#define ACPI_PROCESSOR_AGGREGATOR_CLASS	"acpi_pad"
> +#define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
> +#define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
> +
> +static int xen_acpi_pad_idle_cpus(int *num_cpus)
> +{
> +	int ret;
> +

Stray blank line.

> +	struct xen_platform_op op = {
> +		.cmd = XENPF_core_parking,
> +		.interface_version = XENPF_INTERFACE_VERSION,

This is redundant with HYPERVISOR_dom0_op().

> +	};
> +
> +	/* set cpu nums expected to be idled */
> +	op.u.core_parking.type = XEN_CORE_PARKING_SET;
> +	op.u.core_parking.idle_nums = (uint32_t)*num_cpus;

It is quite a bit more efficient in terms of generated code to
initialize all fields using assignments (the use of an initializer
setting only a subset of fields will cause all other fields to get
zero initialized). In any case I think it is bad style to mix both
approaches.

> +	ret = HYPERVISOR_dom0_op(&op);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * get cpu nums actually be idled
> +	 * cannot get it by using hypercall once (shared with _SET)
> +	 * because of the characteristic of Xen continue_hypercall_on_cpu
> +	 */
> +	op.u.core_parking.type = XEN_CORE_PARKING_GET;
> +	ret = HYPERVISOR_dom0_op(&op);
> +	if (ret)
> +		return ret;
> +
> +	*num_cpus = op.u.core_parking.idle_nums;

"num_cpus" doesn't need to be a pointer, and you don't need to
call _GET here either - callers that care for the count in effect
after the call can invoke the corresponding _GET on their own.

> +	return 0;
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
> +	int ret, num_cpus;
> +
> +	num_cpus = xen_acpi_pad_pur(handle);
> +	if (num_cpus < 0)
> +		return;
> +
> +	ret = xen_acpi_pad_idle_cpus(&num_cpus);
> +	if (ret)
> +		return;
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

.remove?

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
> +
> +#endif

Overall I'd recommend taking a look at the cleaned up driver in
our kernels.

Jan
