Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab2CZMzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 08:55:49 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30929 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2CZMzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 08:55:47 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Mon, 26 Mar 2012 14:55:34 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH v12 3/3] iommu/exynos: Add iommu driver for Exynos Platforms
In-reply-to: <000301cd0286$2f4310d0$8dc93270$%cho@samsung.com>
To: "'Cho KyongHo'" <pullip.cho@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>
Message-id: <001401cd0b4f$bbf0e120$33d2a360$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: Ac0Chi8xxCxRpflBTjm2kOFd23HL0AIv3Feg
References: <000301cd0286$2f4310d0$8dc93270$%cho@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm sorry for a delay, I was quite busy recently, but I have finally found some
time to review the code.

On Thursday, March 15, 2012 9:33 AM Cho KyongHo wrote:

> This is the System MMU driver and IOMMU API implementation for
> Exynos SOC platforms. Exynos platforms has more than 10 System
> MMUs dedicated for each multimedia accelerators.
> 
> The System MMU driver is already in arc/arm/plat-s5p but it is
> moved to drivers/iommu due to Ohad Ben-Cohen gathered IOMMU drivers
> there
> 
> Any device driver in Exynos platforms that needs to control its
> System MMU must call platform_set_sysmmu() to inform System MMU
> driver who will control it.
> platform_set_sysmmu() is defined in <mach/sysmmu.h>
> 
> Cc: Joerg Roedel <joerg.roedel@amd.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>


(snipped)

> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> new file mode 100644
> index 0000000..b8daf7c
> --- /dev/null
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -0,0 +1,1057 @@
> +/* linux/drivers/iommu/exynos_iommu.c
> + *
> + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */

(snipped)

> +static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
> +{
> +	/* SYSMMU is in blocked when interrupt occurred. */
> +	struct sysmmu_drvdata *data = dev_id;
> +	struct resource *irqres;
> +	struct platform_device *pdev;
> +	enum exynos_sysmmu_inttype itype;
> +	unsigned long addr = -1;
> +
> +	int i, ret = -ENOSYS;
> +
> +	read_lock(&data->lock);
> +
> +	WARN_ON(!is_sysmmu_active(data));
> +
> +	pdev = to_platform_device(data->sysmmu);
> +	for (i = 0; i < pdev->num_resources; i++) {
> +		irqres = platform_get_resource(pdev, IORESOURCE_IRQ, i);
> +		if (irqres && ((int)irqres->start == irq))
> +			break;
> +	}
> +
> +	if (i == pdev->num_resources) {
> +		itype = SYSMMU_FAULT_UNKNOWN;
> +	} else {
> +		i /= 2;
> +
> +		itype = (enum exynos_sysmmu_inttype)
> +			__ffs(__raw_readl(data->sfrbases[i] + REG_INT_STATUS));
> +		if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
> +			itype = SYSMMU_FAULT_UNKNOWN;
> +		else
> +			addr = __raw_readl(
> +				data->sfrbases[i] + fault_reg_offset[itype]);
> +	}
> +
> +	if (data->domain)
> +		ret = report_iommu_fault(data->domain, data->dev,
> +				addr, itype);
> +
> +	if ((ret == -ENOSYS) && data->fault_handler) {
> +		unsigned long base = data->pgtable;
> +		if (itype != SYSMMU_FAULT_UNKNOWN)
> +			base = __raw_readl(
> +					data->sfrbases[i] + REG_PT_BASE_ADDR);
> +		ret = data->fault_handler(itype, base, addr);
> +	}
> +
> +	if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
> +		__raw_writel(1 << itype, data->sfrbases[i] + REG_INT_CLEAR);
> +	else
> +		dev_dbg(data->sysmmu, "(%s) %s is not handled.\n",
> +				data->dbgname, sysmmu_fault_name[itype]);
> +
> +	if (itype != SYSMMU_FAULT_UNKNOWN)
> +		sysmmu_unblock(data->sfrbases[i]);
> +
> +	read_unlock(&data->lock);
> +
> +	return IRQ_HANDLED;
> +}

(snipped)

> +static int exynos_sysmmu_probe(struct platform_device *pdev)
> +{
> +	int i, ret;
> +	struct device *dev;
> +	struct sysmmu_drvdata *data;
> +
> +	dev = &pdev->dev;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data) {
> +		dev_dbg(dev, "Not enough memory\n");
> +		ret = -ENOMEM;
> +		goto err_alloc;
> +	}
> +
> +	ret = dev_set_drvdata(dev, data);
> +	if (ret) {
> +		dev_dbg(dev, "Unabled to initialize driver data\n");
> +		goto err_init;
> +	}
> +
> +	data->nsfrs = pdev->num_resources / 2;
> +	data->sfrbases = kmalloc(sizeof(*data->sfrbases) * data->nsfrs,
> +								GFP_KERNEL);
> +	if (data->sfrbases == NULL) {
> +		dev_dbg(dev, "Not enough memory\n");
> +		ret = -ENOMEM;
> +		goto err_init;
> +	}
> +
> +	for (i = 0; i < data->nsfrs; i++) {
> +		struct resource *res;
> +		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
> +		if (!res) {
> +			dev_dbg(dev, "Unable to find IOMEM region\n");
> +			ret = -ENOENT;
> +			goto err_res;
> +		}
> +
> +		data->sfrbases[i] = ioremap(res->start, resource_size(res));
> +		if (!data->sfrbases[i]) {
> +			dev_dbg(dev, "Unable to map IOMEM @ PA:%#x\n",
> +							res->start);
> +			ret = -ENOENT;
> +			goto err_res;
> +		}
> +	}
> +
> +	for (i = 0; i < data->nsfrs; i++) {
> +		ret = platform_get_irq(pdev, i);
> +		if (ret <= 0) {
> +			dev_dbg(dev, "Unable to find IRQ resource\n");
> +			goto err_irq;
> +		}
> +
> +		ret = request_irq(ret, exynos_sysmmu_irq, 0,
> +					dev_name(dev), data);
> +		if (ret) {
> +			dev_dbg(dev, "Unabled to register interrupt handler\n");
> +			goto err_irq;
> +		}
> +	}

Please look at those loops and the interrupt function above. Those for-loops over 
all the resources looks really ugly and makes the driver less portable. The previous 
version (v8 afair) had much cleaned design.

It would be better not to squash multiple sysmmu controllers into a single instance
of the driver. Please keep the driver simple. Sysmmu driver's resource should consist
only of one io register area and one irq, nothing more. Such approach will remove 
the need for all that custom data in platform_data and it also make the future 
integration much easier for other non-samsung platforms (the sysmmu hardware is also
used by other hw vendors). Support for device tree is also easier to add if the device
driver is kept simple (supporting only one instance of the hardware block).

The only reason I can see, which might have suggested you to squash hardware sysmmu 
controllers into one single instance was to provide the same virtual io mappings
for all these sub-devices (it is mainly used by fims-isp complex block). 

This can be achieved in a much clearer design by using one, common iommu domain 
and attaching all these separate iommu controllers to it. Of course this will also
require having a separate platform devices for each sub-device, but sooner or later
you will need them anyway. The good example here is the MFC module, which already
have separate devices: mfc_l and mfc_r for each memory controller.

> +	if (dev_get_platdata(dev)) {
> +		char *deli, *beg;
> +		struct sysmmu_platform_data *platdata = dev_get_platdata(dev);
> +
> +		beg = platdata->clockname;
> +
> +		for (deli = beg; (*deli != '\0') && (*deli != ','); deli++)
> +			/* NOTHING */;
> +
> +		if (*deli == '\0')
> +			deli = NULL;
> +		else
> +			*deli = '\0';
> +
> +		data->clk[0] = clk_get(dev, beg);
> +		if (IS_ERR(data->clk[0])) {
> +			data->clk[0] = NULL;
> +			dev_dbg(dev, "No clock descriptor registered\n");
> +		}
> +
> +		if (data->clk[0] && deli) {
> +			*deli = ',';
> +			data->clk[1] = clk_get(dev, deli + 1);
> +			if (IS_ERR(data->clk[1]))
> +				data->clk[1] = NULL;
> +		}
> +
> +		data->dbgname = platdata->dbgname;
> +	}

Passing clocks via platform data is also considered as a bad idea, especially if 
you need to parse string to extract the clock names. It would be much cleaner to
have 2 (or more if required) variants of sysmmu driver, each one for a different
version of the sysmmu hardware (I noticed only that some of the sysmmu units 
require one clock, the other require 2 clocks).

> +
> +	data->sysmmu = dev;
> +	rwlock_init(&data->lock);
> +	INIT_LIST_HEAD(&data->node);
> +
> +	__set_fault_handler(data, &default_fault_handler);
> +
> +	if (dev->parent)
> +		pm_runtime_enable(dev);
> +
> +	dev_dbg(dev, "(%s) Initialized\n", data->dbgname);
> +	return 0;
> +err_irq:
> +	while (i-- > 0) {
> +		int irq;
> +
> +		irq = platform_get_irq(pdev, i);
> +		free_irq(irq, data);
> +	}
> +err_res:
> +	while (data->nsfrs-- > 0)
> +		iounmap(data->sfrbases[data->nsfrs]);
> +	kfree(data->sfrbases);
> +err_init:
> +	kfree(data);
> +err_alloc:
> +	dev_err(dev, "Failed to initialize\n");
> +	return ret;
> +}
> +
> +static struct platform_driver exynos_sysmmu_driver = {
> +	.probe		= exynos_sysmmu_probe,
> +	.driver		= {
> +		.owner		= THIS_MODULE,
> +		.name		= "exynos-sysmmu",
> +	}
> +};
> +

(snipped)

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



