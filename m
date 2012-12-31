Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab2LaT2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 14:28:36 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:61816 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab2LaT2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 14:28:33 -0500
Message-ID: <50E1E62B.3090501@gmail.com>
Date: Mon, 31 Dec 2012 20:23:23 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Cho KyongHo <pullip.cho@samsung.com>
CC: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v6 05/12] iommu/exynos: support for device tree
References: <003801cde30b$d9667b90$8c3372b0$%cho@samsung.com>
In-Reply-To: <003801cde30b$d9667b90$8c3372b0$%cho@samsung.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2012 02:53 AM, Cho KyongHo wrote:
> This commit adds device tree support for System MMU.
> 
> Signed-off-by: KyongHo Cho<pullip.cho@samsung.com>

Cc: devicetree-discuss@lists.ozlabs.org

Please note any patches adding new device tree bindings should be sent
to this mailing list. I have few comments, please see below.

> ---
>   drivers/iommu/Kconfig        |   2 +-
>   drivers/iommu/exynos-iommu.c | 282 ++++++++++++++++++++++++++-----------------
>   2 files changed, 174 insertions(+), 110 deletions(-)
> 
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index e39f9db..64586f1 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -168,7 +168,7 @@ config TEGRA_IOMMU_SMMU
> 
>   config EXYNOS_IOMMU
>   	bool "Exynos IOMMU Support"
> -	depends on ARCH_EXYNOS&&  EXYNOS_DEV_SYSMMU
> +	depends on ARCH_EXYNOS
>   	select IOMMU_API
>   	help
>   	  Support for the IOMMU(System MMU) of Samsung Exynos application
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 5847508..5b35820 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -1,6 +1,6 @@
> -/* linux/drivers/iommu/exynos_iommu.c
> +/* linux/drivers/iommu/exynos-iommu.c
>    *
> - * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> + * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
>    *		http://www.samsung.com
>    *
>    * This program is free software; you can redistribute it and/or modify
> @@ -12,6 +12,7 @@
>   #define DEBUG
>   #endif
> 
> +#include<linux/kernel.h>
>   #include<linux/io.h>
>   #include<linux/interrupt.h>
>   #include<linux/platform_device.h>
> @@ -25,11 +26,10 @@
>   #include<linux/list.h>
>   #include<linux/memblock.h>
>   #include<linux/export.h>
> +#include<linux/of.h>
> +#include<linux/of_platform.h>
> 
>   #include<asm/cacheflush.h>
> -#include<asm/pgtable.h>
> -
> -#include<mach/sysmmu.h>
> 
>   /* We does not consider super section mapping (16MB) */
>   #define SECT_ORDER 20
> @@ -161,14 +161,13 @@ struct sysmmu_drvdata {
>   	struct list_head node; /* entry of exynos_iommu_domain.clients */
>   	struct device *sysmmu;	/* System MMU's device descriptor */
>   	struct device *dev;	/* Owner of system MMU */
> -	char *dbgname;
>   	int nsfrs;
> -	void __iomem **sfrbases;
> -	struct clk *clk[2];
> +	struct clk *clk;
>   	int activations;
>   	spinlock_t lock;
>   	struct iommu_domain *domain;
>   	unsigned long pgtable;
> +	void __iomem *sfrbases[0];
>   };
> 
>   static bool set_sysmmu_active(struct sysmmu_drvdata *data)
> @@ -373,10 +372,8 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
>   	for (i = 0; i<  data->nsfrs; i++)
>   		__raw_writel(CTRL_DISABLE, data->sfrbases[i] + REG_MMU_CTRL);
> 
> -	if (data->clk[1])
> -		clk_disable(data->clk[1]);
> -	if (data->clk[0])
> -		clk_disable(data->clk[0]);
> +	if (data->clk)
> +		clk_disable(data->clk);
> 
>   	disabled = true;
>   	data->pgtable = 0;
> @@ -385,10 +382,10 @@ finish:
>   	spin_unlock_irqrestore(&data->lock, flags);
> 
>   	if (disabled)
> -		dev_dbg(data->sysmmu, "(%s) Disabled\n", data->dbgname);
> +		dev_dbg(data->sysmmu, "Disabled\n");
>   	else
> -		dev_dbg(data->sysmmu, "(%s) %d times left to be disabled\n",
> -					data->dbgname, data->activations);
> +		dev_dbg(data->sysmmu, "%d times left to be disabled\n",
> +					data->activations);
> 
>   	return disabled;
>   }
> @@ -415,14 +412,12 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
>   			ret = 1;
>   		}
> 
> -		dev_dbg(data->sysmmu, "(%s) Already enabled\n", data->dbgname);
> +		dev_dbg(data->sysmmu, "Already enabled\n");
>   		goto finish;
>   	}
> 
> -	if (data->clk[0])
> -		clk_enable(data->clk[0]);
> -	if (data->clk[1])
> -		clk_enable(data->clk[1]);
> +	if (data->clk)
> +		clk_enable(data->clk);
> 
>   	data->pgtable = pgtable;
> 
> @@ -442,7 +437,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
> 
>   	data->domain = domain;
> 
> -	dev_dbg(data->sysmmu, "(%s) Enabled\n", data->dbgname);
> +	dev_dbg(data->sysmmu, "Enabled\n");
>   finish:
>   	spin_unlock_irqrestore(&data->lock, flags);
> 
> @@ -458,7 +453,7 @@ int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
> 
>   	ret = pm_runtime_get_sync(data->sysmmu);
>   	if (ret<  0) {
> -		dev_dbg(data->sysmmu, "(%s) Failed to enable\n", data->dbgname);
> +		dev_dbg(data->sysmmu, "Failed to enable\n");
>   		return ret;
>   	}
> 
> @@ -466,8 +461,8 @@ int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
>   	if (WARN_ON(ret<  0)) {
>   		pm_runtime_put(data->sysmmu);
>   		dev_err(data->sysmmu,
> -			"(%s) Already enabled with page table %#lx\n",
> -			data->dbgname, data->pgtable);
> +			"Already enabled with page table %#lx\n",
> +			data->pgtable);
>   	} else {
>   		data->dev = dev;
>   	}
> @@ -504,8 +499,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
>   		}
>   	} else {
>   		dev_dbg(data->sysmmu,
> -			"(%s) Disabled. Skipping invalidating TLB.\n",
> -			data->dbgname);
> +			"Disabled. Skipping invalidating TLB.\n");
>   	}
> 
>   	spin_unlock_irqrestore(&data->lock, flags);
> @@ -528,138 +522,208 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
>   		}
>   	} else {
>   		dev_dbg(data->sysmmu,
> -			"(%s) Disabled. Skipping invalidating TLB.\n",
> -			data->dbgname);
> +			"Disabled. Skipping invalidating TLB.\n");
>   	}
> 
>   	spin_unlock_irqrestore(&data->lock, flags);
>   }
> 
> -static int exynos_sysmmu_probe(struct platform_device *pdev)
> +static int __init __sysmmu_init_clock(struct device *sysmmu,
> +					struct sysmmu_drvdata *drvdata,
> +					struct device *master)
>   {
> -	int i, ret;
> -	struct device *dev;
> -	struct sysmmu_drvdata *data;
> +	char *conid;
> +	struct clk *parent_clk;
> +	int ret;
> 
> -	dev =&pdev->dev;
> +	drvdata->clk = clk_get(sysmmu, "sysmmu");
> +	if (IS_ERR(drvdata->clk)) {
> +		dev_dbg(sysmmu, "No gating clock found.\n");
> +		drvdata->clk = NULL;
> +		return 0;
> +	}
> 
> -	data = kzalloc(sizeof(*data), GFP_KERNEL);
> -	if (!data) {
> -		dev_dbg(dev, "Not enough memory\n");
> -		ret = -ENOMEM;
> -		goto err_alloc;
> +	if (!master)
> +		return 0;
> +
> +	conid = dev_get_platdata(sysmmu);
> +	if (!conid) {
> +		dev_dbg(sysmmu, "No parent clock specified.\n");
> +		return 0;
>   	}
> 
> -	ret = dev_set_drvdata(dev, data);
> +	parent_clk = clk_get(master, conid);
> +	if (IS_ERR(parent_clk)) {
> +		parent_clk = clk_get(NULL, conid);
> +		if (IS_ERR(parent_clk)) {
> +			clk_put(drvdata->clk);
> +			dev_err(sysmmu, "No parent clock '%s,%s' found\n",
> +				dev_name(master), conid);
> +			return PTR_ERR(parent_clk);
> +		}
> +	}
> +
> +	ret = clk_set_parent(drvdata->clk, parent_clk);
>   	if (ret) {
> -		dev_dbg(dev, "Unabled to initialize driver data\n");
> -		goto err_init;
> +		clk_put(drvdata->clk);
> +		dev_err(sysmmu, "Failed to set parent clock '%s,%s'\n",
> +				dev_name(master), conid);
>   	}
> 
> -	data->nsfrs = pdev->num_resources / 2;
> -	data->sfrbases = kmalloc(sizeof(*data->sfrbases) * data->nsfrs,
> -								GFP_KERNEL);
> -	if (data->sfrbases == NULL) {
> -		dev_dbg(dev, "Not enough memory\n");
> -		ret = -ENOMEM;
> -		goto err_init;
> +	clk_put(parent_clk);
> +
> +	return ret;
> +}
> +
> +static int __init __sysmmu_setup(struct device *sysmmu,
> +				struct sysmmu_drvdata *drvdata)
> +{
> +	struct device_node *master_node;
> +	const char *compat;
> +	struct platform_device *pmaster = NULL;
> +	u32 master_inst_no = -1;
> +	int ret;
> +
> +	master_node = of_parse_phandle(sysmmu->of_node, "mmu-master", 0);
> +	if (!master_node&&  !of_property_read_string(
> +			sysmmu->of_node, "mmu-master-compat",&compat)) {
> +		of_property_read_u32_array(sysmmu->of_node,
> +					"mmu-master-no",&master_inst_no, 1);
> +		for_each_compatible_node(master_node, NULL, compat) {
> +			pmaster = of_find_device_by_node(master_node);
> +			if (pmaster&&  (pmaster->id == master_inst_no))
> +				break;
> +			of_dev_put(pmaster);
> +			pmaster = NULL;
> +		}
> +	} else if (master_node) {
> +		pmaster = of_find_device_by_node(master_node);
> +	}
> +
> +	if (!pmaster) {
> +		dev_dbg(sysmmu, "No master device is specified.\n");
> +		return __sysmmu_init_clock(sysmmu, drvdata, NULL);
> +	}
> +
> +	pmaster->dev.archdata.iommu = sysmmu;
> +
> +	ret = __sysmmu_init_clock(sysmmu, drvdata,&pmaster->dev);
> +	if (ret)
> +		dev_err(sysmmu, "Failed to initialize gating clocks\n");
> +
> +	of_dev_put(pmaster);
> +
> +	return ret;
> +}
> +
> +static int __init exynos_sysmmu_probe(struct platform_device *pdev)
> +{
> +	int i, ret;
> +	struct device *dev =&pdev->dev;
> +	struct sysmmu_drvdata *data;
> +
> +	if (pdev->num_resources == 0) {
> +		dev_err(dev, "No System MMU resource defined\n");
> +		return -ENODEV;
> +	}
> +
> +	data = devm_kzalloc(dev,
> +			sizeof(*data)
> +			+ sizeof(*data->sfrbases) * (pdev->num_resources / 2),
> +			GFP_KERNEL);
> +	if (!data) {
> +		dev_err(dev, "Not enough memory\n");
> +		return -ENOMEM;
>   	}
> 
> +	data->nsfrs = pdev->num_resources / 2;
> +
>   	for (i = 0; i<  data->nsfrs; i++) {
>   		struct resource *res;
>   		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
>   		if (!res) {
> -			dev_dbg(dev, "Unable to find IOMEM region\n");
> -			ret = -ENOENT;
> -			goto err_res;
> +			dev_err(dev, "Unable to find IOMEM region\n");
> +			return -ENOENT;
>   		}
> 
> -		data->sfrbases[i] = ioremap(res->start, resource_size(res));
> +		data->sfrbases[i] = devm_request_and_ioremap(dev, res);
>   		if (!data->sfrbases[i]) {
> -			dev_dbg(dev, "Unable to map IOMEM @ PA:%#x\n",
> +			dev_err(dev, "Unable to map IOMEM @ PA:%#x\n",
>   							res->start);
> -			ret = -ENOENT;
> -			goto err_res;
> +			return -EBUSY;
>   		}
>   	}
> 
>   	for (i = 0; i<  data->nsfrs; i++) {
>   		ret = platform_get_irq(pdev, i);
>   		if (ret<= 0) {
> -			dev_dbg(dev, "Unable to find IRQ resource\n");
> -			goto err_irq;
> +			dev_err(dev, "Unable to find IRQ resource\n");
> +			return ret;
>   		}
> 
> -		ret = request_irq(ret, exynos_sysmmu_irq, 0,
> +		ret = devm_request_irq(dev, ret, exynos_sysmmu_irq, 0,
>   					dev_name(dev), data);
>   		if (ret) {
> -			dev_dbg(dev, "Unabled to register interrupt handler\n");
> -			goto err_irq;
> +			dev_err(dev, "Unabled to register interrupt handler\n");
> +			return ret;
>   		}
>   	}
> 
> -	if (dev_get_platdata(dev)) {
> -		char *deli, *beg;
> -		struct sysmmu_platform_data *platdata = dev_get_platdata(dev);
> -
> -		beg = platdata->clockname;
> -
> -		for (deli = beg; (*deli != '\0')&&  (*deli != ','); deli++)
> -			/* NOTHING */;
> -
> -		if (*deli == '\0')
> -			deli = NULL;
> -		else
> -			*deli = '\0';
> -
> -		data->clk[0] = clk_get(dev, beg);
> -		if (IS_ERR(data->clk[0])) {
> -			data->clk[0] = NULL;
> -			dev_dbg(dev, "No clock descriptor registered\n");
> -		}
> -
> -		if (data->clk[0]&&  deli) {
> -			*deli = ',';
> -			data->clk[1] = clk_get(dev, deli + 1);
> -			if (IS_ERR(data->clk[1]))
> -				data->clk[1] = NULL;
> -		}
> -
> -		data->dbgname = platdata->dbgname;
> -	}
> 
> -	data->sysmmu = dev;
> -	spin_lock_init(&data->lock);
> -	INIT_LIST_HEAD(&data->node);
> +	ret = __sysmmu_setup(dev, data);
> +	if (!ret) {
> +		data->sysmmu = dev;
> +		spin_lock_init(&data->lock);
> +		INIT_LIST_HEAD(&data->node);
> 
> -	if (dev->parent)
>   		pm_runtime_enable(dev);
> 
> -	dev_dbg(dev, "(%s) Initialized\n", data->dbgname);
> -	return 0;
> -err_irq:
> -	while (i-->  0) {
> -		int irq;
> +		platform_set_drvdata(pdev, data);
> 
> -		irq = platform_get_irq(pdev, i);
> -		free_irq(irq, data);
> +		dev_dbg(dev, "Initialized\n");
>   	}
> -err_res:
> -	while (data->nsfrs-->  0)
> -		iounmap(data->sfrbases[data->nsfrs]);
> -	kfree(data->sfrbases);
> -err_init:
> -	kfree(data);
> -err_alloc:
> -	dev_err(dev, "Failed to initialize\n");
> +
>   	return ret;
>   }
> 
> -static struct platform_driver exynos_sysmmu_driver = {
> +/*
> + * Descriptions of Device Tree node for System MMU
> + *
> + * A System MMU should be described by a single tree node.
> + *
> + * A System MMU node should have the following properties:
> + * - reg: tuples of the base address and the size of the IO region of System MMU
> + * - compatible: it must be "samsung,exynos-sysmmu".

I think this compatible property is too generic. It should include
specific SoC
name in it, e.g. samsung,exynos4210-sysmmu. Please refer to this thread
http://www.spinics.net/lists/linux-omap/msg83512.html, which discusses
similar issue.

> + * - interrupt-parent = specify if the interrupt of System MMU is generated by
> + *   interrupt combiner or interrupt controller.
> + * - interrupts: tuples of interrupt numbers. a tuple has 2 elements if
> + *   @interrupt-parent is '<&combiner>', 3 elements otherwise.

It's probably enough to say that format of the interrupts property is
dependant on
the interrupt controller used.

> + *
> + * 'mmuname', 'reg' and 'interrupts' properties can be an array if the System
> + * MMU driver controls several number of System MMUs at the same time. Note that
> + * the number of elements in those three properties must be the same.

It might be useful to provide some example here.

> + * The following properties are optional:
> + * - mmuname: name of the System MMU for debugging purpose

Not sure if it is something that is supposed to be included in FDT. You
could
probably derive it from the 'compatible' property, if it is really
needed. The device
tree bindings should not be treated as direct replacement for platform data
structures.

> + * - mmu-master: reference to the node of the master device.
> + * - mmu-master-compat: 'compatible' proberty of the node of the master device
> + *    of System MMU. This is ignored if @mmu-master is currectly specified.
> + * - mmu-master-no: instance number of the master device of System MMU. This is
> + *    ignored if @mmu-master is correctly specified. This is '0' by default.

Maybe device node aliases would be better alternative here ? But what
would be
a use case where you can't set 'mmu-master' and 'mmu-master-no' is needed ?

> + */
> +#ifdef CONFIG_OF
> +static struct of_device_id sysmmu_of_match[] __initconst = {
> +	{ .compatible = "samsung,exynos-sysmmu", },
> +	{ },
> +};
> +#endif
> +
> +static struct platform_driver exynos_sysmmu_driver __refdata = {
>   	.probe		= exynos_sysmmu_probe,
>   	.driver		= {
>   		.owner		= THIS_MODULE,
>   		.name		= "exynos-sysmmu",
> +		.of_match_table = of_match_ptr(sysmmu_of_match),
>   	}
>   };
