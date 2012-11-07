Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2KGQQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:16:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31825 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2KGQQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:16:11 -0500
Date: Wed, 7 Nov 2012 11:03:01 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Message-ID: <20121107160301.GF18615@phenom.dumpdata.com>
References: <20121026201409.GF2708@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC8292335377346@SHSMSX101.ccr.corp.intel.com>
 <20121102164937.GC27213@konrad-lan.dumpdata.com>
 <alpine.DEB.2.02.1211051512260.2689@kaball.uk.xensource.com>
 <DE8DF0795D48FD4CA783C40EC829233537B10C@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537B147@SHSMSX101.ccr.corp.intel.com>
 <alpine.DEB.2.02.1211061455150.2689@kaball.uk.xensource.com>
 <DE8DF0795D48FD4CA783C40EC829233537B479@SHSMSX101.ccr.corp.intel.com>
 <20121106164303.GO9966@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC829233537B99E@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233537B99E@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 12:58:19PM +0000, Liu, Jinsong wrote:
> >>> 
> >>> If it is generic ACPI code, than it can depend only on ACPI.
> >>> If it is ACPI code that contains X86 specific info, than it needs to
> >>> depend on X86 too.
> >> 
> >> No x86 specific so let's depend on ACPI.
> > 
> > Huh? This feature is x86 specific isn't it? I mean it is in the ACPI
> > spec, but only x86 does it right?
> 
> OK, updated w/ ACPI & X86 dependency, and per other comments.

Ok. Could you send all the patchset in one go. I am bit lost of which
one to review as none of them seem to have the version information
[vX: Did this yyy]

right above your name or in the title:
[PATCH vX 1/2]: yyyy

anyhow, some comments below.

> 
> Thanks,
> Jinsong
> 
> =================
> 
> >From d5f462cc8029863955a574f1541bece72aafb986 Mon Sep 17 00:00:00 2001
> From: Liu, Jinsong <jinsong.liu@intel.com>
> Date: Thu, 8 Nov 2012 04:29:07 +0800
> Subject: [PATCH 1/2] Xen acpi pad implement

The title should be: xen/acpi: ACPI PAD driver

> 
> PAD is acpi Processor Aggregator Device which provides a control point
> that enables the platform to perform specific processor configuration
> and control that applies to all processors in the platform.
> 
> This patch is to implement Xen acpi pad logic. When running under Xen
> virt platform, native pad driver would not work. Instead Xen pad driver,
> a self-contained and thin logic level, would take over acpi pad logic.
> 
> When acpi pad notify OSPM, xen pad logic intercept and parse _PUR object
> to get the expected idle cpu number, and then hypercall to hypervisor.
> Xen hypervisor would then do the rest work, say, core parking, to idle
> specific number of cpus on its own policy.
> 
> Signed-off-by: Jan Beulich <JBeulich@suse.com>
> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
> ---
>  drivers/xen/Makefile             |    3 +-
>  drivers/xen/xen-acpi-pad.c       |  186 ++++++++++++++++++++++++++++++++++++++
>  include/xen/interface/platform.h |   17 ++++
>  include/xen/interface/version.h  |   15 +++
>  4 files changed, 220 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/xen/xen-acpi-pad.c
> 
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 0e86370..3c39717 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -10,7 +10,8 @@ CFLAGS_features.o			:= $(nostackp)
>  
>  dom0-$(CONFIG_PCI) += pci.o
>  dom0-$(CONFIG_USB_SUPPORT) += dbgp.o
> -dom0-$(CONFIG_ACPI) += acpi.o
> +dom0-$(CONFIG_ACPI) += acpi.o $(xen-pad-y)
> +xen-pad-$(CONFIG_X86) += xen-acpi-pad.o
>  dom0-$(CONFIG_X86) += pcpu.o
>  obj-$(CONFIG_XEN_DOM0)			+= $(dom0-y)
>  obj-$(CONFIG_BLOCK)			+= biomerge.o
> diff --git a/drivers/xen/xen-acpi-pad.c b/drivers/xen/xen-acpi-pad.c
> new file mode 100644
> index 0000000..f02d3ff
> --- /dev/null
> +++ b/drivers/xen/xen-acpi-pad.c
> @@ -0,0 +1,186 @@
> +/*
> + * xen-acpi-pad.c - Xen pad interface
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
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.

No address pls.

> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <acpi/acpi_bus.h>
> +#include <acpi/acpi_drivers.h>
> +#include <asm/xen/hypercall.h>
> +#include <xen/interface/version.h>
> +
> +#define ACPI_PROCESSOR_AGGREGATOR_CLASS	"acpi_pad"
> +#define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
> +#define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
> +
> +static DEFINE_MUTEX(xen_cpu_lock);
> +
> +static int xen_acpi_pad_idle_cpus(unsigned int idle_nums)
> +{
> +	struct xen_platform_op op;
> +
> +	op.cmd = XENPF_core_parking;
> +	op.u.core_parking.type = XEN_CORE_PARKING_SET;
> +	op.u.core_parking.idle_nums = idle_nums;
> +
> +	return HYPERVISOR_dom0_op(&op);
> +}
> +
> +static int xen_acpi_pad_idle_cpus_num(void)
> +{
> +	struct xen_platform_op op;
> +
> +	op.cmd = XENPF_core_parking;
> +	op.u.core_parking.type = XEN_CORE_PARKING_GET;
> +
> +	return HYPERVISOR_dom0_op(&op)
> +	       ?: op.u.core_parking.idle_nums;
> +}
> +
> +/*
> + * Query firmware how many CPUs should be idle
> + * return -1 on failure
> + */
> +static int acpi_pad_pur(acpi_handle handle)
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
> +static void acpi_pad_ost(acpi_handle handle, int stat,
> +	uint32_t idle_nums)
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
> +	params[2].buffer.pointer = (void *)&idle_nums;
> +	acpi_evaluate_object(handle, "_OST", &arg_list, NULL);
> +}
> +
> +static void acpi_pad_handle_notify(acpi_handle handle)
> +{
> +	int idle_nums;
> +
> +	mutex_lock(&xen_cpu_lock);
> +	idle_nums = acpi_pad_pur(handle);
> +	if (idle_nums < 0) {
> +		mutex_unlock(&xen_cpu_lock);
> +		return;
> +	}
> +
> +	idle_nums = xen_acpi_pad_idle_cpus(idle_nums)
> +		    ?: xen_acpi_pad_idle_cpus_num();
> +	if (idle_nums >= 0)
> +		acpi_pad_ost(handle, 0, idle_nums);
> +	mutex_unlock(&xen_cpu_lock);
> +}
> +
> +static void acpi_pad_notify(acpi_handle handle, u32 event,
> +	void *data)
> +{
> +	switch (event) {
> +	case ACPI_PROCESSOR_AGGREGATOR_NOTIFY:
> +		acpi_pad_handle_notify(handle);
> +		break;
> +	default:
> +		pr_warn("Unsupported event [0x%x]\n", event);
> +		break;
> +	}
> +}
> +
> +static int acpi_pad_add(struct acpi_device *device)
> +{
> +	acpi_status status;
> +
> +	strcpy(acpi_device_name(device), ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME);
> +	strcpy(acpi_device_class(device), ACPI_PROCESSOR_AGGREGATOR_CLASS);
> +
> +	status = acpi_install_notify_handler(device->handle,
> +		ACPI_DEVICE_NOTIFY, acpi_pad_notify, device);
> +	if (ACPI_FAILURE(status))
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +static int acpi_pad_remove(struct acpi_device *device,
> +	int type)
> +{
> +	mutex_lock(&xen_cpu_lock);
> +	xen_acpi_pad_idle_cpus(0);
> +	mutex_unlock(&xen_cpu_lock);
> +
> +	acpi_remove_notify_handler(device->handle,
> +		ACPI_DEVICE_NOTIFY, acpi_pad_notify);
> +	return 0;
> +}
> +
> +static const struct acpi_device_id pad_device_ids[] = {
> +	{"ACPI000C", 0},
> +	{"", 0},
> +};
> +
> +static struct acpi_driver acpi_pad_driver = {
> +	.name = "processor_aggregator",
> +	.class = ACPI_PROCESSOR_AGGREGATOR_CLASS,
> +	.ids = pad_device_ids,
> +	.ops = {
> +		.add = acpi_pad_add,
> +		.remove = acpi_pad_remove,
> +	},
> +};
> +
> +static int __init xen_acpi_pad_init(void)
> +{
> +	/* Only DOM0 and Xen4.2 or later support Xen acpi pad */
> +	if (!xen_initial_domain() ||
> +		!xen_running_on_version_or_later(4, 2))
> +		return -ENODEV;

Please restructure this. Just make it

	if (!xen_initial_domain())
		return -ENODEV;

	if (!xen_running..)
		return -ENODEV;

I know the compiler will end up with code that looks exactly
the same but it is easier to read than the '!' and '||' logic.

> +
> +	return acpi_bus_register_driver(&acpi_pad_driver);
> +}
> +subsys_initcall(xen_acpi_pad_init);
> +
> diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
> index 4755b5f..5e36932 100644
> --- a/include/xen/interface/platform.h
> +++ b/include/xen/interface/platform.h
> @@ -324,6 +324,22 @@ struct xenpf_cpu_ol {
>  };
>  DEFINE_GUEST_HANDLE_STRUCT(xenpf_cpu_ol);
>  
> +/*
> + * CMD 58 and 59 are reserved for cpu hotadd and memory hotadd,
> + * which are already occupied at Xen hypervisor side.
> + */
> +#define XENPF_core_parking     60
> +struct xenpf_core_parking {
> +	/* IN variables */
> +#define XEN_CORE_PARKING_SET   1
> +#define XEN_CORE_PARKING_GET   2
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
> diff --git a/include/xen/interface/version.h b/include/xen/interface/version.h
> index 7ff6498..96d8d3d 100644
> --- a/include/xen/interface/version.h
> +++ b/include/xen/interface/version.h
> @@ -63,4 +63,19 @@ struct xen_feature_info {
>  /* arg == xen_domain_handle_t. */
>  #define XENVER_guest_handle 8
>  
> +/* Check if running on Xen version (major, minor) or later */
> +static inline bool
> +xen_running_on_version_or_later(unsigned int major, unsigned int minor)
> +{
> +	unsigned int version;
> +
> +	if (!xen_domain())
> +		return false;
> +
> +	version = HYPERVISOR_xen_version(XENVER_version, NULL);
> +	if ((((version >> 16) == major) && ((version & 0xffff) >= minor)) ||
> +		((version >> 16) > major))
> +		return true;
> +	return false;
> +}
>  #endif /* __XEN_PUBLIC_VERSION_H__ */
> -- 
> 1.7.1


