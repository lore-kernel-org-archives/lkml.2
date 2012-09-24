Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab2IXWcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 18:32:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5710 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2IXWca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 18:32:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6845"; a="238326405"
Message-ID: <5060DF7D.9000305@codeaurora.org>
Date: Mon, 24 Sep 2012 15:32:29 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/10] msm: iommu: Convert to clk_prepare/unprepare
References: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org> <1348194419-11486-4-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1348194419-11486-4-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 07:26 PM, Stephen Boyd wrote:
> Add calls to clk_prepare and unprepare so that MSM can migrate to
> the common clock framework. We never unprepare the clocks until
> driver remove because the clocks are enabled and disabled in irq
> context. Finer grained power management is possible in the future
> via runtime power management techniques.
>
> Signed-off-by: Stephen Boyd<sboyd@codeaurora.org>
> ---
>   drivers/iommu/msm_iommu_dev.c | 17 ++++++++++-------
>   1 file changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/iommu/msm_iommu_dev.c b/drivers/iommu/msm_iommu_dev.c
> index 8e8fb07..d344f6a 100644
> --- a/drivers/iommu/msm_iommu_dev.c
> +++ b/drivers/iommu/msm_iommu_dev.c
> @@ -160,7 +160,7 @@ static int msm_iommu_probe(struct platform_device *pdev)
>   		goto fail;
>   	}
>
> -	ret = clk_enable(iommu_pclk);
> +	ret = clk_prepare_enable(iommu_pclk);
>   	if (ret)
>   		goto fail_enable;
>
> @@ -170,7 +170,7 @@ static int msm_iommu_probe(struct platform_device *pdev)
>   		if (clk_get_rate(iommu_clk) == 0)
>   			clk_set_min_rate(iommu_clk, 1);
>
> -		ret = clk_enable(iommu_clk);
> +		ret = clk_prepare_enable(iommu_clk);
>   		if (ret) {
>   			clk_put(iommu_clk);
>   			goto fail_pclk;
> @@ -261,7 +261,7 @@ fail_clk:
>   		clk_put(iommu_clk);
>   	}
>   fail_pclk:
> -	clk_disable(iommu_pclk);
> +	clk_disable_unprepare(iommu_pclk);
>   fail_enable:
>   	clk_put(iommu_pclk);
>   fail:
> @@ -275,8 +275,11 @@ static int msm_iommu_remove(struct platform_device *pdev)
>
>   	drv = platform_get_drvdata(pdev);
>   	if (drv) {
> -		if (drv->clk)
> +		if (drv->clk) {
> +			clk_unprepare(drv->clk);
>   			clk_put(drv->clk);
> +		}
> +		clk_unprepare(drv->pclk);

Are these changes right? Every other clk API change in this patch is 
using the combined prepare_enable/disable_unprepare() calls. So, when 
would we end up at this location with the clocks prepared but not enabled?

Also, what if the device gets probed and then immediately removed. Will 
it work correctly?

-Saravana

>   		clk_put(drv->pclk);
>   		memset(drv, 0, sizeof(*drv));
>   		kfree(drv);
> @@ -314,14 +317,14 @@ static int msm_iommu_ctx_probe(struct platform_device *pdev)
>   	INIT_LIST_HEAD(&ctx_drvdata->attached_elm);
>   	platform_set_drvdata(pdev, ctx_drvdata);
>
> -	ret = clk_enable(drvdata->pclk);
> +	ret = clk_prepare_enable(drvdata->pclk);
>   	if (ret)
>   		goto fail;
>
>   	if (drvdata->clk) {
> -		ret = clk_enable(drvdata->clk);
> +		ret = clk_prepare_enable(drvdata->clk);
>   		if (ret) {
> -			clk_disable(drvdata->pclk);
> +			clk_disable_unprepare(drvdata->pclk);
>   			goto fail;
>   		}
>   	}


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
