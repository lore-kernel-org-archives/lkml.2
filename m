Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220Ab1ESNlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:41:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49924 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921Ab1ESNlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:41:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: add /proc/tile, /proc/sys/tile, and a sysfs cpu attribute
Date: Thu, 19 May 2011 15:41:11 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201105181807.p4II7C5g015224@farm-0002.internal.tilera.com>
In-Reply-To: <201105181807.p4II7C5g015224@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105191541.11939.arnd@arndb.de>
X-Provags-ID: V02:K0:tZS002d4Mn1Mqxk/Cc0r9uefxvO5JTE7hx3QjAqgtIM
 uFAp/JZ6qWYXnaJquHN/S/VUAqAyizWnmnhbalJIVDS2d8efpp
 M1uxTFAvqXJHZc/YobTQ0pD9qD4kP3vgKmWFpu4HYbmYqP+eAW
 K8rzYQm2lr3pQoKSYIFRiucNXGjB5npeYztv6dmu8JyFpyH8Kz
 8618yvZbasJfsDj0VBpJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 May 2011, Chris Metcalf wrote:

> /proc/tile/hv
>   Version information about the running Tilera hypervisor
> 
> /proc/tile/hvconfig
>   Detailed configuration description of the hypervisor config
> 
> /proc/tile/board
>   Information on part numbers, serial numbers, etc., of the
>   hardware that the kernel is executing on
> 
> /proc/tile/switch
>   The type of control path for the onboard network switch, if any.
> 
> /proc/tile/hardwall
>   Information on the set of currently active hardwalls (note that
>   the implementation is already present in arch/tile/kernel/hardwall.c;
>   this change just enables it)

These all look like ideal candidates for sysfs attributes under
/sys/hypervisor, doing them one value per file, instead of grouping
them into multiple entries per file.

You can also turn each of these files into one directory under
/sys/hypervisor, with one or more files under it.

> diff --git a/arch/tile/kernel/sysfs.c b/arch/tile/kernel/sysfs.c
> new file mode 100644
> index 0000000..151deeb
> --- /dev/null
> +++ b/arch/tile/kernel/sysfs.c
> @@ -0,0 +1,52 @@
> +/*
> + * Copyright 2011 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + *
> + * /sys entry support.
> + */
> +
> +#include <linux/sysdev.h>
> +#include <linux/cpu.h>
> +#include <linux/smp.h>
> +
> +static ssize_t chip_width_show(struct sysdev_class *dev,
> +			       struct sysdev_class_attribute *attr,
> +			       char *page)
> +{
> +	return sprintf(page, "%u\n", smp_width);
> +}
> +static SYSDEV_CLASS_ATTR(chip_width, 0444, chip_width_show, NULL);
> +
> +static ssize_t chip_height_show(struct sysdev_class *dev,
> +				struct sysdev_class_attribute *attr,
> +				char *page)
> +{
> +	return sprintf(page, "%u\n", smp_height);
> +}
> +static SYSDEV_CLASS_ATTR(chip_height, 0444, chip_height_show, NULL);
> +
> +
> +static int __init create_cpu_entries(void)
> +{
> +	struct sysdev_class *cls = &cpu_sysdev_class;
> +	int err = 0;
> +
> +	if (!err)
> +		err = sysfs_create_file(&cls->kset.kobj,
> +					&attr_chip_width.attr);
> +	if (!err)
> +		err = sysfs_create_file(&cls->kset.kobj,
> +					&attr_chip_height.attr);
> +
> +	return err;
> +}

This should use sysdev_create_file instead of open-coding it.

	Arnd

