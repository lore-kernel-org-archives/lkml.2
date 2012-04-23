Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab2DWSXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:23:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55289 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab2DWSXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:23:42 -0400
Message-ID: <4F959E2B.5090109@wwwdotorg.org>
Date: Mon, 23 Apr 2012 12:23:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Hiroshi DOYU <hdoyu@nvidia.com>
CC: linux-tegra@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] iommu/tegra: smmu: Reserve SMMU reg regions precisely
References: <1335182340-17237-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1335182340-17237-1-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 05:58 AM, Hiroshi DOYU wrote:
> SMMU register regions are located into 3 blocks discontiguously.
> 
> Get them and reserve each region respectively. This allows other
> module to use/reserve other register regions between SMMU register
> blocks.
> 
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>

This patch depends on the other series you sent which adds the Tegra AHB
driver, and modifies the SMMU driver to use it. At least you need to
mention the dependencies so e.g. these patches don't get applied without
the other series.

> @@ -875,9 +877,25 @@ static int tegra_smmu_probe(struct platform_device *pdev)
>  
>  	BUILD_BUG_ON(PAGE_SHIFT != SMMU_PAGE_SHIFT);
>  
> -	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	window = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	if (!regs || !window) {
> +	for (i = 0; i < ARRAY_SIZE(res); i++) {
> +		res[i] = platform_get_resource(pdev, IORESOURCE_MEM, i);
> +		if (!res[i])
> +			return -ENODEV;
> +
> +		res[i] = devm_request_mem_region(&pdev->dev, res[i]->start,
> +						 resource_size(res[i]),
> +						 dev_name(&pdev->dev));
> +		if (res[i])
> +			continue;
> +
> +		while (--i >= 0)
> +			devm_release_mem_region(&pdev->dev, res[i]->start,
> +						resource_size(res[i]));

The whole point of using the devm_* functions is that you no longer need
to write out all the error-handling and freeing code related to those
allocations. A similar comment applies to many other parts of this patch.

> +		return -EIO;
> +	}
> +
> +	window = platform_get_resource(pdev, IORESOURCE_MEM, 3);
> +	if (!window) {
>  		dev_err(dev, "No SMMU resources\n");
>  		return -ENODEV;
>  	}
> @@ -892,7 +910,8 @@ static int tegra_smmu_probe(struct platform_device *pdev)
>  	smmu->num_as = SMMU_NUM_ASIDS;
>  	smmu->iovmm_base = (unsigned long)window->start;
>  	smmu->page_count = resource_size(window) >> SMMU_PAGE_SHIFT;
> -	smmu->regs = devm_ioremap(dev, regs->start, resource_size(regs));
> +	smmu->regs = devm_ioremap(dev, res[0]->start,
> +				  res[2]->end - res[0]->start + 1);

So, you've retrieved 3 separate resources for the address space, but
only call ioremap once. That doesn't seem right; there should be a 1:1
relationship between the number of resources and ioremap calls. This is
only working because the SMMU driver isn't calling request_mem_region
for this whole range, and hence isn't conflicting with the
request_mem_region and ioremap callss that the AHB driver is (or rather,
should be) performing...

>  	smmu->as = devm_kzalloc(dev,
> -			sizeof(smmu->as[0]) * smmu->num_as, GFP_KERNEL);
> +				sizeof(smmu->as[0]) * smmu->num_as, GFP_KERNEL);

That looks unrelated.
