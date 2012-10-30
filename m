Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab2J3H6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 03:58:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:46298 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab2J3H6f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 03:58:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,677,1344236400"; 
   d="scan'208";a="234473147"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <jbeulich@suse.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: RE: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Topic: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Index: AQHNtdJ8Ti91BiFLfUibRvXA4zlK85fRdOaA
Date: Tue, 30 Oct 2012 07:58:15 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335374C86@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
 <5089676602000078000A4928@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com>
 <508A89CB020000780008E6ED@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537292E@SHSMSX101.ccr.corp.intel.com>
 <20121026201409.GF2708@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC8292335373918@SHSMSX101.ccr.corp.intel.com>
 <20121029123950.GK2708@phenom.dumpdata.com>
In-Reply-To: <20121029123950.GK2708@phenom.dumpdata.com>
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
> On Mon, Oct 29, 2012 at 03:38:14AM +0000, Liu, Jinsong wrote:
>> It's doable to register a stub for xen. However, it's not preferred,
>> say, to make xen pad as module, considering the case 'rmmod
>> xen_acpi_pad' then 'insmod acpi_pad'? Under such case there is risk
>> of mwait #UD, if we want to remove mwait check as 'patch 2/2:
>> Revert-pad-config-check-in-xen_check_mwait.patch' did, advantages of
>> which is to enjoy deep Cx.     
> 
> You are missing my point. This is what I was thinking off:
> 
> 
> From 5f30320b8a1c21d60a2c22e98bcf013b7773938b Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Mon, 29 Oct 2012 08:38:22 -0400
> Subject: [PATCH] xen/acpi: Provide a stub function to register for
>  ACPI PAD module.
> 
> TODO: Give more details.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/Kconfig             |    5 ++
>  drivers/xen/Makefile            |    3 +-
>  drivers/xen/xen-acpi-pad-stub.c |  128
>  +++++++++++++++++++++++++++++++++++++++ drivers/xen/xen-acpi.h      
>  |    2 + 4 files changed, 137 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/xen/xen-acpi-pad-stub.c
>  create mode 100644 drivers/xen/xen-acpi.h
> 
> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> index d4dffcd..9156a08 100644
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -204,4 +204,9 @@ config XEN_MCE_LOG
>  	  Allow kernel fetching MCE error from Xen platform and
>  	  converting it into Linux mcelog format for mcelog tools
> 
> +config XEN_ACPI_PAD_STUB
> +	bool
> +	depends on XEN_DOM0 && X86_64 && ACPI
> +	default n
> +

This Kconfig is pointless, if CONFIG_XEN_ACPI_PAD_STUB = n, native pad would successfully registerred, and then mwait #UD (we would revert df88b2d96e36d9a9e325bfcd12eb45671cbbc937, right?). So xen stub logic should unconditionally built-in kernel.

>  endmenu
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 0e863703..d1895d9 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -9,9 +9,10 @@ nostackp := $(call cc-option, -fno-stack-protector)
>  CFLAGS_features.o			:= $(nostackp)
> 
>  dom0-$(CONFIG_PCI) += pci.o
> -dom0-$(CONFIG_USB_SUPPORT) += dbgp.o
> +dom0-$(CONFIG_USB_EHCI_HCD) += dbgp.o
>  dom0-$(CONFIG_ACPI) += acpi.o
>  dom0-$(CONFIG_X86) += pcpu.o
> +dom0-$(CONFIG_XEN_ACPI_PAD_STUB)	+= xen-acpi-pad-stub.o
>  obj-$(CONFIG_XEN_DOM0)			+= $(dom0-y)
>  obj-$(CONFIG_BLOCK)			+= biomerge.o
>  obj-$(CONFIG_XEN_XENCOMM)		+= xencomm.o
> diff --git a/drivers/xen/xen-acpi-pad-stub.c
> b/drivers/xen/xen-acpi-pad-stub.c new file mode 100644
> index 0000000..cac9a39
> --- /dev/null
> +++ b/drivers/xen/xen-acpi-pad-stub.c
> @@ -0,0 +1,128 @@
> +/*
> + * Copyright 2012 by Oracle Inc
> + * Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> + *
> + * This code borrows ideas from https://lkml.org/lkml/2011/11/30/249
> + * so many thanks go to Kevin Tian <kevin.tian@intel.com>
> + * and Yu Ke <ke.yu@intel.com>.
> + *
> + * This program is free software; you can redistribute it and/or
> modify it + * under the terms and conditions of the GNU General
> Public License, + * version 2, as published by the Free Software
> Foundation. + *
> + * This program is distributed in the hope it will be useful, but
> WITHOUT + * ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> General Public License for + * more details.
> + *
> + */
> +
> +#include <linux/cpumask.h>
> +#include <linux/freezer.h>
> +#include <linux/kernel.h>
> +#include <linux/kthread.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <acpi/acpi_bus.h>
> +#include <acpi/acpi_drivers.h>
> +#include <acpi/processor.h>
> +
> +#include <xen/xen.h>
> +#include <xen/interface/platform.h>
> +#include <xen/interface/version.h>
> +#include <asm/xen/hypercall.h>
> +
> +/* TODO: Needs comments. */
> +static struct acpi_device_ops *xen_acpi_pad_ops;
> +static bool __read_mostly xen_acpi_pad_registered;
> +static DEFINE_SPINLOCK(xen_acpi_pad_spinlock);
> +
> +int xen_register_acpi_pad_owner(struct acpi_device_ops *ops)
> +{
> +	if (xen_acpi_pad_ops)
> +		return -EEXIST;
> +
> +	spin_lock(&xen_acpi_pad_spinlock);
> +	xen_acpi_pad_ops = ops;
> +	spin_unlock(&xen_acpi_pad_spinlock);
> +	return 0;
> +}
> +int xen_unregister_acpi_pad_owner(struct acpi_device_ops *ops)
> +{
> +	spin_lock(&xen_acpi_pad_spinlock);
> +	if (xen_acpi_pad_ops != ops) {
> +		spin_unlock(&xen_acpi_pad_spinlock);
> +		return -ENODEV;
> +	}
> +	xen_acpi_pad_ops = NULL;
> +	spin_unlock(&xen_acpi_pad_spinlock);
> +	return 0;
> +}
> +
> +static int xen_acpi_pad_remove(struct acpi_device *device, int type)
> +{
> +	int ret = -ENOSYS;
> +
> +	spin_lock(&xen_acpi_pad_spinlock);
> +	if (xen_acpi_pad_ops && xen_acpi_pad_ops->remove)
> +		ret = xen_acpi_pad_ops->remove(device, type);
> +	spin_unlock(&xen_acpi_pad_spinlock);
> +	return ret;
> +}
> +static int xen_acpi_pad_add(struct acpi_device *device)
> +{
> +	int ret = -ENOSYS;
> +	spin_lock(&xen_acpi_pad_spinlock);
> +	if (xen_acpi_pad_ops && xen_acpi_pad_ops->add)
> +		ret = xen_acpi_pad_ops->add(device);
> +	spin_unlock(&xen_acpi_pad_spinlock);
> +	return ret;
> +}
> +
> +static const struct acpi_device_id pad_device_ids[] = {
> +	{"ACPI000C", 0},
> +	{"", 0},
> +};
> +MODULE_DEVICE_TABLE(acpi, pad_device_ids);
> +#define ACPI_PROCESSOR_AGGREGATOR_CLASS "acpi_pad"
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
> +static int __init xen_acpi_pad_stub_init(void)
> +{
> +	int ret = -ENOSYS;
> +	unsigned version;
> +
> +	if (!xen_initial_domain())
> +		return -ENODEV;
> +
> +	version = HYPERVISOR_xen_version(XENVER_version, NULL);
> +
> +	if ((version >> 16 >= 4) && ((version & 0xffff) >= 2)) {
> +        	ret = acpi_bus_register_driver(&xen_acpi_pad_driver);
> +        	if (!ret)
> +			xen_acpi_pad_registered = true;
> +    	}
> +    	return ret;
> +}
> +#if 0
> +/* For testing purposes. */
> +static void __exit xen_acpi_pad_stub_exit(void)
> +{
> +	if (xen_acpi_pad_registered)
> +		acpi_bus_unregister_driver(&xen_acpi_pad_driver);
> +	/* The driver should have unregistered first ! */
> +	if (WARN_ON(xen_acpi_pad_ops))
> +		xen_acpi_pad_ops = NULL;
> +}
> +#endif
> +subsys_initcall(xen_acpi_pad_stub_init);

I'm still confused. In this way there are xen-acpi-pad-stub.c and xen-acpi-pad.c, and you want to let xen-acpi-pad loaded as module, right? how can xen-acpi-pad logic work when it was insmoded?

Thanks,
Jinsong