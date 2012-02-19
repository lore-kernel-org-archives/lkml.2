Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab2BSL5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 06:57:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:13407 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab2BSL5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 06:57:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="127138576"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Li, Shaohua" <shaohua.li@intel.com>, Jan Beulich <JBeulich@suse.com>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: RE: [PATCH 3/3] Xen pad logic and notification
Thread-Topic: [PATCH 3/3] Xen pad logic and notification
Thread-Index: AQHM7YGr1HfHeb7nTGSKH/iUASruopZEERig
Date: Sun, 19 Feb 2012 11:57:39 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350A0869@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233509D87E@SHSMSX101.ccr.corp.intel.com>
 <20120217143727.GC29110@phenom.dumpdata.com>
In-Reply-To: <20120217143727.GC29110@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> On Fri, Feb 17, 2012 at 08:58:38AM +0000, Liu, Jinsong wrote:
>>> From fee39804d2634dfba7b369dc82dac19b57400f84 Mon Sep 17 00:00:00
>>> 2001 
>> From: Liu, Jinsong <jinsong.liu@intel.com>
>> Date: Sat, 18 Feb 2012 00:46:29 +0800
>> Subject: [PATCH 3/3] Xen pad logic and notification
>> 
>> This patch implement Xen pad logic, and when getting pad device
>> notification, it hypercalls to Xen hypervisor for core parking.
> 
> CC-ing linux-acpi@vger.kernel.org and Len Brown.
> 
>> 
>> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com> ---
>>  drivers/xen/xen_acpi_pad.c       |  189
>>  ++++++++++++++++++++++++++++++++++++++
>>  include/xen/interface/platform.h |   14 +++ 2 files changed, 203
>> insertions(+), 0 deletions(-) 
>> 
>> diff --git a/drivers/xen/xen_acpi_pad.c b/drivers/xen/xen_acpi_pad.c
>> index 63ab2fb..ba66d51 100644
>> --- a/drivers/xen/xen_acpi_pad.c
>> +++ b/drivers/xen/xen_acpi_pad.c
>> @@ -1,8 +1,197 @@
>> +/*
>> + * xen_acpi_pad.c - Xen pad interface
>> + *
>> + * Copyright (c) 2012, Intel Corporation.
>> + *    Author: Liu, Jinsong <jinsong.liu@intel.com> + *
>> + * This program is free software; you can redistribute it and/or
>> modify it + * under the terms and conditions of the GNU General
>> Public License, + * version 2, as published by the Free Software
>> Foundation. + * + * This program is distributed in the hope it will
>> be useful, but WITHOUT + * ANY WARRANTY; without even the implied
>> warranty of MERCHANTABILITY or + * FITNESS FOR A PARTICULAR PURPOSE.
>> See the GNU General Public License for + * more details. + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/types.h>
>> +#include <acpi/acpi_bus.h>
>> +#include <acpi/acpi_drivers.h>
>> +
>> +#include <asm/xen/hypercall.h>
>> +
>> +#define ACPI_PROCESSOR_AGGREGATOR_CLASS "xen_acpi_pad"
>> +#define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Xen Processor
>> Aggregator" +#define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
>> +static DEFINE_MUTEX(xen_cpu_lock);
>> +
>> +static int xen_acpi_pad_idle_cpus(int *num_cpus)
>> +{
>> +	int ret;
>> +
>> +	struct xen_platform_op op = {
>> +		.cmd = XENPF_core_parking,
>> +		.interface_version = XENPF_INTERFACE_VERSION,
>> +	};
>> +
>> +	/* set cpu nums expected to be idled */
>> +	op.u.core_parking.type = XEN_CORE_PARKING_SET;
>> +	op.u.core_parking.idle_nums = (uint32_t)*num_cpus;
>> +	ret = HYPERVISOR_dom0_op(&op);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/*
>> +	 * get cpu nums actually be idled
>> +	 * cannot get it by using hypercall once (shared with _SET)
>> +	 * because of the characteristic of Xen continue_hypercall_on_cpu
>> +	 */ +	op.u.core_parking.type = XEN_CORE_PARKING_GET;
>> +	ret = HYPERVISOR_dom0_op(&op);
>> +	if (ret)
>> +		return ret;
>> +
>> +	*num_cpus = op.u.core_parking.idle_nums;
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Query firmware how many CPUs should be idle
>> + * return -1 on failure
>> + */
>> +static int xen_acpi_pad_pur(acpi_handle handle)
>> +{
>> +	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL}; +	union
>> acpi_object *package; +	int num = -1;
>> +
>> +	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_PUR", NULL,
>> &buffer))) +		return num; +
>> +	if (!buffer.length || !buffer.pointer)
>> +		return num;
>> +
>> +	package = buffer.pointer;
>> +
>> +	if (package->type == ACPI_TYPE_PACKAGE &&
>> +		package->package.count == 2 &&
>> +		package->package.elements[0].integer.value == 1) /* rev 1 */ +
>> +		num = package->package.elements[1].integer.value; +
>> +	kfree(buffer.pointer);
>> +	return num;
>> +}
>> +
>> +/* Notify firmware how many CPUs are idle */
>> +static void xen_acpi_pad_ost(acpi_handle handle, int stat,
>> +	uint32_t idle_cpus) +{
>> +	union acpi_object params[3] = {
>> +		{.type = ACPI_TYPE_INTEGER,},
>> +		{.type = ACPI_TYPE_INTEGER,},
>> +		{.type = ACPI_TYPE_BUFFER,},
>> +	};
>> +	struct acpi_object_list arg_list = {3, params};
>> +
>> +	params[0].integer.value = ACPI_PROCESSOR_AGGREGATOR_NOTIFY;
>> +	params[1].integer.value =  stat;
>> +	params[2].buffer.length = 4;
>> +	params[2].buffer.pointer = (void *)&idle_cpus;
>> +	acpi_evaluate_object(handle, "_OST", &arg_list, NULL); +}
>> +
>> +static void xen_acpi_pad_handle_notify(acpi_handle handle) +{
>> +	int ret, num_cpus;
>> +
>> +	mutex_lock(&xen_cpu_lock);
>> +	num_cpus = xen_acpi_pad_pur(handle);
>> +	if (num_cpus < 0) {
>> +		mutex_unlock(&xen_cpu_lock);
>> +		return;
>> +	}
>> +
>> +	ret = xen_acpi_pad_idle_cpus(&num_cpus);
>> +	if (ret) {
>> +		mutex_unlock(&xen_cpu_lock);
>> +		return;
>> +	}
>> +
>> +	xen_acpi_pad_ost(handle, 0, num_cpus);
>> +	mutex_unlock(&xen_cpu_lock);
>> +}
>> +
>> +static void xen_acpi_pad_notify(acpi_handle handle, u32 event,
>> +	void *data) +{
>> +	switch (event) {
>> +	case ACPI_PROCESSOR_AGGREGATOR_NOTIFY:
>> +		xen_acpi_pad_handle_notify(handle);
>> +		break;
>> +	default:
>> +		printk(KERN_WARNING "Unsupported event [0x%x]\n", event);
>> +		break; +	}
>> +}
>> +
>> +static int xen_acpi_pad_add(struct acpi_device *device) +{
>> +	acpi_status status;
>> +
>> +	strcpy(acpi_device_name(device),
>> ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME);
>> +	strcpy(acpi_device_class(device),
>> ACPI_PROCESSOR_AGGREGATOR_CLASS); + +	status =
>> acpi_install_notify_handler(device->handle, +		 ACPI_DEVICE_NOTIFY,
>> xen_acpi_pad_notify, device); +	if (ACPI_FAILURE(status)) +		return
>> -ENODEV; + +	return 0;
>> +}
>> +
>> +static int xen_acpi_pad_remove(struct acpi_device *device, +	int
>> type) +{
>> +	int num_cpus = 0;
>> +
>> +	mutex_lock(&xen_cpu_lock);
>> +	xen_acpi_pad_idle_cpus(&num_cpus);
>> +	mutex_unlock(&xen_cpu_lock);
>> +
>> +	acpi_remove_notify_handler(device->handle,
>> +		ACPI_DEVICE_NOTIFY, xen_acpi_pad_notify);
>> +	return 0;
>> +}
>> +
>> +static const struct acpi_device_id xen_pad_device_ids[] = {
>> +	{"ACPI000C", 0}, +	{"", 0},
>> +};
>> +
>> +static struct acpi_driver xen_acpi_pad_driver = {
>> +	.name = "xen_processor_aggregator",
>> +	.class = ACPI_PROCESSOR_AGGREGATOR_CLASS,
>> +	.ids = xen_pad_device_ids,
>> +	.ops = {
>> +		.add = xen_acpi_pad_add,
>> +		.remove = xen_acpi_pad_remove,
>> +	},
>> +};
>> +
>>  int xen_acpi_pad_init(void)
>>  {
>> +#ifdef CONFIG_ACPI_PROCESSOR_AGGREGATOR
> 
> How does that work when the the driver is booted under baremetal?
> Won't it kick out the native ACPI_PROCESSOR_AGGREGATOR_CLASS
> (acpi_pad.c) ? 
> 
> What about if the other ACPI_PROCESSOR_AGGREGATOR_CLASS gets called
> first? Won't this fail?
> 
> Or is the acpi_bus_register_driver smart enough to process more than
> one ACPI bus device?

When driver booted under baremetal, xen_acpi_pad.c would be disabled and native acpi_pad.c logic would work.

Thanks,
Jinsong

> 
>> +	return acpi_bus_register_driver(&xen_acpi_pad_driver); +#else
>>  	return 0;
>> +#endif
>>  }
>> 
>>  void xen_acpi_pad_exit(void)
>>  {
>> +#ifdef CONFIG_ACPI_PROCESSOR_AGGREGATOR
>> +	acpi_bus_unregister_driver(&xen_acpi_pad_driver); +#endif
>>  }
>> diff --git a/include/xen/interface/platform.h
>> b/include/xen/interface/platform.h index c168468..56ec72a 100644 ---
>> a/include/xen/interface/platform.h +++
>> b/include/xen/interface/platform.h @@ -297,6 +297,19 @@ struct
>>  xenpf_set_processor_pminfo {  };
>> DEFINE_GUEST_HANDLE_STRUCT(xenpf_set_processor_pminfo); 
>> 
>> +#define XENPF_core_parking      60
>> +
>> +#define XEN_CORE_PARKING_SET    1
>> +#define XEN_CORE_PARKING_GET    2
>> +struct xenpf_core_parking {
>> +	/* IN variables */
>> +	uint32_t type;
>> +	/* IN variables:  set cpu nums expected to be idled */
>> +	/* OUT variables: get cpu nums actually be idled */ +	uint32_t
>> idle_nums; +};
>> +DEFINE_GUEST_HANDLE_STRUCT(xenpf_core_parking);
>> +
>>  struct xen_platform_op {
>>  	uint32_t cmd;
>>  	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
>> @@ -312,6 +325,7 @@ struct xen_platform_op {
>>  		struct xenpf_change_freq       change_freq;
>>  		struct xenpf_getidletime       getidletime;
>>  		struct xenpf_set_processor_pminfo set_pminfo;
>> +		struct xenpf_core_parking      core_parking;
>>  		uint8_t                        pad[128];
>>  	} u;
>>  };
>> --
>> 1.7.1

