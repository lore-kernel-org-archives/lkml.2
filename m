Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab0LOUP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:15:56 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:5815 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755063Ab0LOUPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:15:54 -0500
Message-ID: <4D092256.4090605@bluewatersys.com>
Date: Thu, 16 Dec 2010 09:17:26 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>,
        arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH] base: add sysfs socs info
References: <1292330417-13703-1-git-send-email-plagnioj@jcrosoft.com>
In-Reply-To: <1292330417-13703-1-git-send-email-plagnioj@jcrosoft.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 01:40 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> this provide an easy way to register soc information

This idea has been kicked around a few times in various forms, both as a
proc file and as sysfs files. Cc'ed the arm-linux and embedded-linux
lists since this patch mainly affects them.

> arch, family, model, id, revision

Some SoCs want to expose additional information also. This patch doesn't
appear to provide any standard way of extending the information
available in sysfs.

> as this for at91sam9g20
> 
> $ cat /sys/devices/system/soc/soc0/arch
> current

What does this mean? Shouldn't it be ARM? Also, we already have ways to
determine the architecture/cpu type.

> $ cat /sys/devices/system/soc/soc0/family
> at91
> $ cat /sys/devices/system/soc/soc0/id
> at91sam9g20
> $ cat /sys/devices/system/soc/soc0/model
> 0x00000000019905a0
> $ cat /sys/devices/system/soc/soc0/revision
> 1.1

What is the difference between model and revision? Do these fields make
sense for all SoCs?

What userspace tools actually need this information? Some of the
extended information for various SoCs may be useful, but I can't think
of many good reasons for a userspace application to care about the SoC
family or revision.

> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Patrice VILCHEZ <patrice.vilchez@atmel.com>
> ---
>  drivers/base/Makefile |    3 +-
>  drivers/base/base.h   |    1 +
>  drivers/base/init.c   |    1 +
>  drivers/base/soc.c    |  124 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/soc.h   |   27 +++++++++++
>  5 files changed, 155 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/base/soc.c
>  create mode 100644 include/linux/soc.h
> 
> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> index 5f51c3b..cf3e59f 100644
> --- a/drivers/base/Makefile
> +++ b/drivers/base/Makefile
> @@ -3,7 +3,8 @@
>  obj-y			:= core.o sys.o bus.o dd.o \
>  			   driver.o class.o platform.o \
>  			   cpu.o firmware.o init.o map.o devres.o \
> -			   attribute_container.o transport_class.o
> +			   attribute_container.o transport_class.o \
> +			   soc.o
>  obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
>  obj-y			+= power/
>  obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
> diff --git a/drivers/base/base.h b/drivers/base/base.h
> index 2ca7f5b..e2daaf6 100644
> --- a/drivers/base/base.h
> +++ b/drivers/base/base.h
> @@ -107,6 +107,7 @@ static inline int hypervisor_init(void) { return 0; }
>  extern int platform_bus_init(void);
>  extern int system_bus_init(void);
>  extern int cpu_dev_init(void);
> +extern int soc_dev_init(void);
>  
>  extern int bus_add_device(struct device *dev);
>  extern void bus_probe_device(struct device *dev);
> diff --git a/drivers/base/init.c b/drivers/base/init.c
> index c8a934e..f908faa 100644
> --- a/drivers/base/init.c
> +++ b/drivers/base/init.c
> @@ -33,5 +33,6 @@ void __init driver_init(void)
>  	platform_bus_init();
>  	system_bus_init();
>  	cpu_dev_init();
> +	soc_dev_init();
>  	memory_dev_init();
>  }
> diff --git a/drivers/base/soc.c b/drivers/base/soc.c
> new file mode 100644
> index 0000000..c24bb41
> --- /dev/null
> +++ b/drivers/base/soc.c
> @@ -0,0 +1,124 @@
> +/*
> + * drivers/base/soc.c - basic SOC class support
> + *
> + * Copyright (C) 2010 Jean-Chrisotphe PLAGNIOL-VILLARD * <plagnioj@jcrosoft.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/sysdev.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/soc.h>
> +#include <linux/device.h>
> +
> +#include "base.h"
> +
> +static int nb_socs;
> +
> +struct sysdev_class soc_sysdev_class = {
> +	.name = "soc",
> +};
> +EXPORT_SYMBOL_GPL(soc_sysdev_class);
> +
> +#define print_u64_attr(field)							\
> +static ssize_t print_socs_##field(struct sys_device *dev,			\
> +				  struct sysdev_attribute *attr, char *buf)	\
> +{										\
> +	struct soc *soc = container_of(dev, struct soc, sysdev);		\
> +										\
> +	return sprintf(buf, "0x%016Lx\n", soc->field);				\
> +}										\
> +static SYSDEV_ATTR(field, 0444, print_socs_##field, NULL);			\
> +
> +#define print_str_attr(field)							\
> +static ssize_t print_socs_##field(struct sys_device *dev,			\
> +				  struct sysdev_attribute *attr, char *buf)	\
> +{										\
> +	struct soc *soc = container_of(dev, struct soc, sysdev);		\
> +										\
> +	return sprintf(buf, "%s\n", soc->field);				\
> +}										\
> +static SYSDEV_ATTR(field, 0444, print_socs_##field, NULL);			\

At first glance this looks like two functions with the same name because
of the identical print_socs##field bit. I intuitively expect field to
just be the name of the sysfs file.

> +print_u64_attr(id)
> +print_str_attr(arch)
> +print_str_attr(family)
> +print_str_attr(model)
> +print_str_attr(revision)

These should have semicolons at the end (drop the final one from the
macro name). Also I think the names should be in caps and should be
renamed to better reflect what the do, i.e. SOC_SYSFS_U64_ATTR and
SOC_SYSFS_STRING_ATTR.

> +static char *arch_current = "current";

Should be const.

> +/*
> + * register_soc - Setup a sysfs device for a SOC.
> + *
> + * Initialize and register the SOC device.
> + */
> +int register_soc(struct soc *soc)
> +{

This name implies that it does much more than just adding some sysfs
files :-).

> +	int err;
> +
> +	if (!soc)
> +		return -EINVAL;

Wouldn't bother with this check. Just crash so that we can catch buggy code.

> +	soc->sysdev.id = nb_socs;
> +	soc->sysdev.cls = &soc_sysdev_class;
> +
> +	if (!soc->arch)
> +		soc->arch = arch_current;
> +
> +	err = sysdev_register(&soc->sysdev);
> +
> +	if (err)
> +		return err;

Why all the additional whitespace?
> +
> +	err = sysdev_create_file(&soc->sysdev, &attr_arch);
> +
> +	if (err)
> +		goto end;

You can use sysfs_create_group to register a bunch of files which will
greatly simply the code here.

> +	err = sysdev_create_file(&soc->sysdev, &attr_family);
> +
> +	if (err)
> +		goto end0;
> +
> +	err = sysdev_create_file(&soc->sysdev, &attr_model);
> +
> +	if (err)
> +		goto end1;
> +
> +	err = sysdev_create_file(&soc->sysdev, &attr_id);
> +
> +	if (err)
> +		goto end2;
> +
> +	err = sysdev_create_file(&soc->sysdev, &attr_revision);
> +
> +	if (err)
> +		goto end3;
> +
> +	nb_socs++;

If there is more than one SoC (SMP machine?) then how do you guarantee
the order of registration? Should the registration function take id as a
parameter?

> +	return 0;
> +
> +end3:
> +	sysdev_remove_file(&soc->sysdev, &attr_id);
> +end2:
> +	sysdev_remove_file(&soc->sysdev, &attr_model);
> +end1:
> +	sysdev_remove_file(&soc->sysdev, &attr_family);
> +end0:
> +	sysdev_remove_file(&soc->sysdev, &attr_arch);
> +end:
> +	sysdev_unregister(&soc->sysdev);
> +
> +	return err;
> +}

EXPORT_SYMBOL(register_soc)?

> +
> +int __init soc_dev_init(void)
> +{
> +	nb_socs = 0;
> +
> +	return sysdev_class_register(&soc_sysdev_class);
> +}

EXPORT_SYMBOL(soc_dev_init)?

> diff --git a/include/linux/soc.h b/include/linux/soc.h
> new file mode 100644
> index 0000000..55e6ea2
> --- /dev/null
> +++ b/include/linux/soc.h
> @@ -0,0 +1,27 @@
> +/*
> + * include/linux/soc.h - generic soc definition
> + *
> + * Copyright (C) 2010 Jean-Chrisotphe PLAGNIOL-VILLARD * <plagnioj@jcrosoft.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef _LINUX_SOC_H_
> +#define _LINUX_OSC_H_
> +
> +#include <linux/sysdev.h>
> +
> +struct soc {
> +	u64 id;
> +	char *arch;
> +	char *family;
> +	char *model;
> +	char *revision;
> +	struct sys_device sysdev;
> +};
> +
> +extern int register_soc(struct soc *soc);
> +extern struct sysdev_class soc_sysdev_class;
> +
> +#endif /* _LINUX_SOC_H_ */

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
