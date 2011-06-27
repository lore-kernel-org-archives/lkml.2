Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab1F0VAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 17:00:43 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58677 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab1F0VAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 17:00:12 -0400
Date: Mon, 27 Jun 2011 15:00:07 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Subject: Re: [RFC 2/8] remoteproc: add omap implementation
Message-ID: <20110627210007.GC20865@ponder.secretlab.ca>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-3-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308640714-17961-3-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 10:18:28AM +0300, Ohad Ben-Cohen wrote:
> From: Guzman Lugo, Fernando <fernando.lugo@ti.com>
> 
> Add remoteproc implementation for OMAP4, so we can load the M3 and DSP
> remote processors.
> 
> Based on code by Hari Kanigeri <h-kanigeri2@ti.com>
> 
> While this code is functional, and works on OMAP4 & its M3's,
> it is still preliminary and going to substantially change:
> 
> 1. Splitting physically contiguous regions to pages should happen
>    inside the IOMMU API framework, and not here (so omap_rproc_map_unmap
>    should go away).
> 2. IOMMU programming in general should go away too; it should be handled by
>    generic code (preferably using the DMA mapping API), and not by an OMAP
>    specific component.
> 
> This patch depends on OMAP's IOMMU API migration, as posted here:
> https://lkml.org/lkml/2011/6/2/369
> 
> [ohad@wizery.com: commit log, generic iommu api migration, refactoring, cleanups]
> 
> Signed-off-by: Guzman Lugo, Fernando <fernando.lugo@ti.com>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
>  arch/arm/plat-omap/include/plat/remoteproc.h |   41 +++++
>  drivers/remoteproc/Kconfig                   |   21 +++
>  drivers/remoteproc/Makefile                  |    1 +
>  drivers/remoteproc/omap_remoteproc.c         |  243 ++++++++++++++++++++++++++
>  4 files changed, 306 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/plat-omap/include/plat/remoteproc.h
>  create mode 100644 drivers/remoteproc/omap_remoteproc.c
> 
> diff --git a/arch/arm/plat-omap/include/plat/remoteproc.h b/arch/arm/plat-omap/include/plat/remoteproc.h
> new file mode 100644
> index 0000000..6494570
> --- /dev/null
> +++ b/arch/arm/plat-omap/include/plat/remoteproc.h
> @@ -0,0 +1,41 @@
> +/*
> + * Remote Processor - omap-specific bits
> + *
> + * Copyright (C) 2011 Texas Instruments, Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef _PLAT_REMOTEPROC_H
> +#define _PLAT_REMOTEPROC_H
> +
> +#include <linux/remoteproc.h>
> +
> +/*
> + * struct omap_rproc_pdata - omap remoteproc's platform data
> + * @name: the remoteproc's name, cannot exceed RPROC_MAX_NAME bytes
> + * @iommu_name: iommu device we're behind of
> + * @oh_name: omap hwmod device
> + * @oh_name_opt: optional, secondary omap hwmod device
> + * @firmware: name of firmware file to load
> + * @ops: start/stop rproc handlers
> + * @memory_maps: table of da-to-pa iommu memory maps
> + */
> +struct omap_rproc_pdata {
> +	const char *name;
> +	const char *iommu_name;
> +	const char *oh_name;
> +	const char *oh_name_opt;
> +	const char *firmware;
> +	const struct rproc_ops *ops;
> +	const struct rproc_mem_entry *memory_maps;
> +};
> +
> +#endif /* _PLAT_REMOTEPROC_H */
> diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
> index a60bb12..88421bd 100644
> --- a/drivers/remoteproc/Kconfig
> +++ b/drivers/remoteproc/Kconfig
> @@ -5,3 +5,24 @@
>  # REMOTE_PROC gets selected by whoever wants it
>  config REMOTE_PROC
>  	tristate
> +
> +# for tristate, either expose omap_device_* or pass it via pdata
> +config OMAP_REMOTE_PROC
> +	bool "OMAP remoteproc support"
> +	depends on ARCH_OMAP4
> +	select OMAP_IOMMU
> +	select REMOTE_PROC
> +	select OMAP_MBOX_FWK
> +	default y
> +	help
> +	  Say y here to support OMAP's remote processors (dual M3
> +	  and DSP on OMAP4) via the remote processor framework.
> +
> +	  Currently only supported on OMAP4.
> +
> +	  Usually you want to say y here, in order to enable multimedia
> +	  use-cases to run on your platform (multimedia codecs are
> +	  offloaded to remote DSP processors using this framework).
> +
> +	  It's safe to say n here if you're not interested in multimedia
> +	  offloading or just want a bare minimum kernel.
> diff --git a/drivers/remoteproc/Makefile b/drivers/remoteproc/Makefile
> index d0f60c7..0198b1d 100644
> --- a/drivers/remoteproc/Makefile
> +++ b/drivers/remoteproc/Makefile
> @@ -3,3 +3,4 @@
>  #
>  
>  obj-$(CONFIG_REMOTE_PROC)		+= remoteproc.o
> +obj-$(CONFIG_OMAP_REMOTE_PROC)		+= omap_remoteproc.o
> diff --git a/drivers/remoteproc/omap_remoteproc.c b/drivers/remoteproc/omap_remoteproc.c
> new file mode 100644
> index 0000000..91f7f11
> --- /dev/null
> +++ b/drivers/remoteproc/omap_remoteproc.c
> @@ -0,0 +1,243 @@
> +/*
> + * Remote processor machine-specific module for OMAP4
> + *
> + * Copyright (C) 2011 Texas Instruments, Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#define pr_fmt(fmt)    "%s: " fmt, __func__
> +
> +#include <linux/kernel.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/iommu.h>
> +#include <linux/slab.h>
> +#include <linux/remoteproc.h>
> +
> +#include <plat/iommu.h>
> +#include <plat/omap_device.h>
> +#include <plat/remoteproc.h>
> +
> +struct omap_rproc_priv {
> +	struct iommu_domain *domain;
> +	struct device *iommu;
> +};
> +
> +/*
> + * Map a physically contiguous memory region using biggest pages possible.
> + * TODO: this code should go away; it belongs in the generic IOMMU layer
> + */
> +static int omap_rproc_map_unmap(struct iommu_domain *domain,
> +				const struct rproc_mem_entry *me, bool map)
> +{
> +	u32 all_bits;
> +	/* these are the page sizes supported by OMAP's IOMMU */
> +	u32 pg_size[] = {SZ_16M, SZ_1M, SZ_64K, SZ_4K};
> +	int i, ret, size = me->size;
> +	u32 da = me->da;
> +	u32 pa = me->pa;
> +	int order;
> +	int flags;
> +
> +	/* must be aligned at least with the smallest supported iommu page */
> +	if (!IS_ALIGNED(size, SZ_4K) || !IS_ALIGNED(da | pa, SZ_4K)) {
> +		pr_err("misaligned: size %x da 0x%x pa 0x%x\n", size, da, pa);
> +		return -EINVAL;
> +	}
> +
> +	while (size) {
> +		/* find the max page size with which both pa, da are aligned */
> +		all_bits = pa | da;
> +		for (i = 0; i < ARRAY_SIZE(pg_size); i++) {
> +			if ((size >= pg_size[i]) &&
> +				((all_bits & (pg_size[i] - 1)) == 0)) {
> +				break;
> +			}
> +		}
> +
> +		order = get_order(pg_size[i]);
> +
> +		/* OMAP4's M3 is little endian, so no need for conversions */
> +		flags = MMU_RAM_ENDIAN_LITTLE | MMU_RAM_ELSZ_NONE;
> +
> +		if (map)
> +			ret = iommu_map(domain, da, pa, order, flags);
> +		else
> +			ret = iommu_unmap(domain, da, order);
> +
> +		if (ret)
> +			return ret;
> +
> +		size -= pg_size[i];
> +		da += pg_size[i];
> +		pa += pg_size[i];
> +	}
> +
> +	return 0;
> +}
> +
> +/* bootaddr isn't needed for the dual M3's */
> +static inline int omap_rproc_start(struct rproc *rproc, u64 bootaddr)
> +{
> +	struct device *dev = rproc->dev;
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct omap_rproc_pdata *pdata = dev->platform_data;
> +	struct iommu_domain *domain;
> +	struct device *iommu;
> +	struct omap_rproc_priv *priv;
> +	int ret, i;
> +
> +	if (!iommu_found()) {
> +		dev_err(&pdev->dev, "iommu not found\n");
> +		return -ENODEV;
> +	}
> +
> +	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv) {
> +		dev_err(&pdev->dev, "kzalloc failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	/*
> +	 * Use the specified iommu name to find our iommu device.
> +	 * TODO: solve this generically so other platforms can use it, too
> +	 */
> +	iommu = omap_find_iommu_device(pdata->iommu_name);
> +	if (!iommu) {
> +		dev_err(dev, "omap_find_iommu_device failed\n");
> +		ret = -ENODEV;
> +		goto free_mem;
> +	}
> +
> +	domain = iommu_domain_alloc();
> +	if (!domain) {
> +		dev_err(&pdev->dev, "can't alloc iommu domain\n");
> +		ret = -ENODEV;
> +		goto free_mem;
> +	}
> +
> +	priv->iommu = iommu;
> +	priv->domain = domain;
> +	rproc->priv = priv;
> +
> +	ret = iommu_attach_device(domain, iommu);
> +	if (ret) {
> +		dev_err(&pdev->dev, "can't attach iommu device: %d\n", ret);
> +		goto free_domain;
> +	}
> +
> +	for (i = 0; rproc->memory_maps[i].size; i++) {
> +		const struct rproc_mem_entry *me = &rproc->memory_maps[i];
> +
> +		ret = omap_rproc_map_unmap(domain, me, true);
> +		if (ret) {
> +			dev_err(&pdev->dev, "iommu_map failed: %d\n", ret);
> +			goto unmap_regions;
> +		}
> +	}
> +
> +	/* power on the remote processor itself */
> +	ret = omap_device_enable(pdev);
> +	if (ret)
> +		goto unmap_regions;
> +
> +	return 0;
> +
> +unmap_regions:
> +	for (--i; i >= 0 && rproc->memory_maps[i].size; i--) {
> +		const struct rproc_mem_entry *me = &rproc->memory_maps[i];
> +		omap_rproc_map_unmap(domain, me, false);
> +	}
> +free_domain:
> +	iommu_domain_free(domain);
> +free_mem:
> +	kfree(priv);
> +	return ret;
> +}
> +
> +static inline int omap_rproc_stop(struct rproc *rproc)
> +{
> +	struct device *dev = rproc->dev;
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct omap_rproc_priv *priv = rproc->priv;
> +	struct iommu_domain *domain = priv->domain;
> +	struct device *iommu = priv->iommu;
> +	int ret, i;
> +
> +	/* power off the remote processor itself */
> +	ret = omap_device_shutdown(pdev);
> +	if (ret) {
> +		dev_err(dev, "failed to shutdown: %d\n", ret);
> +		goto out;
> +	}
> +
> +	for (i = 0; rproc->memory_maps[i].size; i++) {
> +		const struct rproc_mem_entry *me = &rproc->memory_maps[i];
> +
> +		ret = omap_rproc_map_unmap(domain, me, false);
> +		if (ret) {
> +			dev_err(&pdev->dev, "iommu_unmap failed: %d\n", ret);
> +			goto out;
> +		}
> +	}
> +
> +	iommu_detach_device(domain, iommu);
> +	iommu_domain_free(domain);
> +
> +out:
> +	return ret;
> +}
> +
> +static struct rproc_ops omap_rproc_ops = {
> +	.start = omap_rproc_start,
> +	.stop = omap_rproc_stop,
> +};
> +
> +static int omap_rproc_probe(struct platform_device *pdev)
> +{
> +	struct omap_rproc_pdata *pdata = pdev->dev.platform_data;
> +
> +	return rproc_register(&pdev->dev, pdata->name, &omap_rproc_ops,
> +				pdata->firmware, pdata->memory_maps,
> +				THIS_MODULE);

Very little for me to comment on here.  However, something I just
noticed.  Why is it necessary to pass in THIS_MODULE to the
rproc_register function?  Having a reference to the pdev gives you the
pointer to the driver, which has the THIS_MODULE value in it.  That
should be sufficient.

/me also isn't sure if incrementing the refcount on the module is the
best way to prevent the rproc from going away, but I haven't dug into
the details in the driver code to find out.  Drivers can get unbound
from devices without the driver being unloaded, so I imagine there is
an in-use count on the device itself that would prevent driver
unbinding.

> +}
> +
> +static int __devexit omap_rproc_remove(struct platform_device *pdev)
> +{
> +	struct omap_rproc_pdata *pdata = pdev->dev.platform_data;
> +
> +	return rproc_unregister(pdata->name);
> +}
> +
> +static struct platform_driver omap_rproc_driver = {
> +	.probe = omap_rproc_probe,
> +	.remove = __devexit_p(omap_rproc_remove),
> +	.driver = {
> +		.name = "omap-rproc",
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +static int __init omap_rproc_init(void)
> +{
> +	return platform_driver_register(&omap_rproc_driver);
> +}
> +/* must be ready in time for device_initcall users */
> +subsys_initcall(omap_rproc_init);
> +
> +static void __exit omap_rproc_exit(void)
> +{
> +	platform_driver_unregister(&omap_rproc_driver);
> +}
> +module_exit(omap_rproc_exit);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("OMAP Remote Processor control driver");
> -- 
> 1.7.1
> 
