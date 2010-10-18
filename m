Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab0JRTcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:32:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49192 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab0JRTcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:32:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6140"; a="58279557"
Message-ID: <4CBCA0BD.7060609@codeaurora.org>
Date: Mon, 18 Oct 2010 12:32:13 -0700
From: Stepan Moskovchenko <stepanm@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: mach-msm: fix error handling in msm_iommu_probe()
References: <1287327097-9025-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1287327097-9025-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/17/2010 7:51 AM, Vasiliy Kulikov wrote:
> msm_iommu_probe() didn't free mem_region and mapped IO.
> Also if request_mem_region() failed then error handling
> code dereferenced NULL pointer.
>
> Signed-off-by: Vasiliy Kulikov<segooon@gmail.com>
> ---
>   arch/arm/mach-msm/iommu_dev.c |   22 +++++++++++++---------
>   1 files changed, 13 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm/mach-msm/iommu_dev.c b/arch/arm/mach-msm/iommu_dev.c
> index c33ae78..9019cee 100644
> --- a/arch/arm/mach-msm/iommu_dev.c
> +++ b/arch/arm/mach-msm/iommu_dev.c
> @@ -128,7 +128,7 @@ static void msm_iommu_reset(void __iomem *base)
>
>   static int msm_iommu_probe(struct platform_device *pdev)
>   {
> -	struct resource *r;
> +	struct resource *r, *r2;
>   	struct clk *iommu_clk;
>   	struct msm_iommu_drvdata *drvdata;
>   	struct msm_iommu_dev *iommu_dev = pdev->dev.platform_data;
> @@ -183,27 +183,27 @@ static int msm_iommu_probe(struct platform_device *pdev)
>
>   		len = r->end - r->start + 1;
>
> -		r = request_mem_region(r->start, len, r->name);
> -		if (!r) {
> +		r2 = request_mem_region(r->start, len, r->name);
> +		if (!r2) {
>   			pr_err("Could not request memory region: "
>   			"start=%p, len=%d\n", (void *) r->start, len);
>   			ret = -EBUSY;
>   			goto fail;
>   		}
>
> -		regs_base = ioremap(r->start, len);
> +		regs_base = ioremap(r2->start, len);
>
>   		if (!regs_base) {
>   			pr_err("Could not ioremap: start=%p, len=%d\n",
> -				 (void *) r->start, len);
> +				 (void *) r2->start, len);
>   			ret = -EBUSY;
> -			goto fail;
> +			goto fail_mem;
>   		}
>
>   		irq = platform_get_irq_byname(pdev, "secure_irq");
>   		if (irq<  0) {
>   			ret = -ENODEV;
> -			goto fail;
> +			goto fail_io;
>   		}
>
>   		mb();
> @@ -211,14 +211,14 @@ static int msm_iommu_probe(struct platform_device *pdev)
>   		if (GET_IDR(regs_base) == 0) {
>   			pr_err("Invalid IDR value detected\n");
>   			ret = -ENODEV;
> -			goto fail;
> +			goto fail_io;
>   		}
>
>   		ret = request_irq(irq, msm_iommu_fault_handler, 0,
>   				"msm_iommu_secure_irpt_handler", drvdata);
>   		if (ret) {
>   			pr_err("Request IRQ %d failed with ret=%d\n", irq, ret);
> -			goto fail;
> +			goto fail_io;
>   		}
>
>   		msm_iommu_reset(regs_base);
> @@ -237,6 +237,10 @@ static int msm_iommu_probe(struct platform_device *pdev)
>
>   	return 0;
>
> +fail_io:
> +	iounmap(regs_base);
> +fail_mem:
> +	release_mem_region(r->start, len);
>   fail:
>   	kfree(drvdata);
>   	return ret;

Tested on hardware. Looks good. Thanks!

Acked-by: Stepan Moskovchenko <stepanm@codeaurora.org>

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.



