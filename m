Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab2GTGCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 02:02:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:62228 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab2GTGCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 02:02:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="181094050"
Subject: Re: [PATCH] dma: tegra: enable/disable dma clock
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org, swarren@nvidia.com,
        linux-tegra@vger.kernel.org
In-Reply-To: <1342601769-13852-1-git-send-email-ldewangan@nvidia.com>
References: <1342601769-13852-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Jul 2012 11:32:21 +0530
Message-ID: <1342764141.1726.199.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 14:26 +0530, Laxman Dewangan wrote:
> Enable the DMA clock when registering DMA driver and
> disable clock when removing the DMA driver.
> 
> The failure was observed on Tegra20 based system by
> Stephen Warren. However, it is working fine on tegra30
> based system and probably becasue uboot enable the clock
> on Tegra30.
Don't know much about the clock subsystem, but shouldn't the clocks be
enabled runtime..... when you actually start using the controller??
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Reported-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
>  drivers/dma/tegra20-apb-dma.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
> index d52dbc6..ccfdaf4 100644
> --- a/drivers/dma/tegra20-apb-dma.c
> +++ b/drivers/dma/tegra20-apb-dma.c
> @@ -1255,6 +1255,12 @@ static int __devinit tegra_dma_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	ret = clk_prepare_enable(tdma->dma_clk);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "clk_prepare_enable failed: %d\n", ret);
> +		goto err_pm_disable;
> +	}
> +
>  	/* Reset DMA controller */
>  	tegra_periph_reset_assert(tdma->dma_clk);
>  	udelay(2);
> @@ -1363,6 +1369,7 @@ static int __devexit tegra_dma_remove(struct platform_device *pdev)
>  	if (!pm_runtime_status_suspended(&pdev->dev))
>  		tegra_dma_runtime_suspend(&pdev->dev);
>  
> +	clk_disable_unprepare(tdma->dma_clk);
>  	return 0;
>  }
>  


-- 
~Vinod

