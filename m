Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab1LWQTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 11:19:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:42223 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab1LWQTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 11:19:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="89790074"
Subject: Re: [PATCH] intel_mid_dma: remove legacy pm interface
From: Vinod Koul <vinod.koul@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20111215223225.10295.40514.stgit@bob.linux.org.uk>
References: <20111215223225.10295.40514.stgit@bob.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Dec 2011 21:49:14 +0530
Message-ID: <1324657154.1633.21.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 22:32 +0000, Alan Cox wrote:
> From: Kristen Carlson Accardi <kristen@linux.intel.com>
> 
> Drivers should not support both legacy pm and new framework.
Not really.

I am using this driver in our system where we go to D0i3 aka
runtime_suspend when DMA is idle.
Also we goto D3/S3 aka when traditional suspend is invoked.

So we need both.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/dma/intel_mid_dma.c      |   12 +++++++-----
>  drivers/dma/intel_mid_dma_regs.h |    2 +-
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
> index 01929ed..d67cecf 100644
> --- a/drivers/dma/intel_mid_dma.c
> +++ b/drivers/dma/intel_mid_dma.c
> @@ -868,7 +868,7 @@ static int intel_mid_dma_alloc_chan_resources(struct dma_chan *chan)
>  	pm_runtime_get_sync(&mid->pdev->dev);
>  
>  	if (mid->state == SUSPENDED) {
> -		if (dma_resume(mid->pdev)) {
> +		if (dma_resume(&mid->pdev->dev)) {
>  			pr_err("ERR_MDMA: resume failed");
>  			return -EFAULT;
>  		}
> @@ -1337,8 +1337,9 @@ static void __devexit intel_mid_dma_remove(struct pci_dev *pdev)
>  *
>  * This function is called by OS when a power event occurs
>  */
> -int dma_suspend(struct pci_dev *pci, pm_message_t state)
> +int dma_suspend(struct device *dev)
>  {
> +	struct pci_dev *pci = to_pci_dev(dev);
>  	int i;
>  	struct middma_device *device = pci_get_drvdata(pci);
>  	pr_debug("MDMA: dma_suspend called\n");
> @@ -1362,8 +1363,9 @@ int dma_suspend(struct pci_dev *pci, pm_message_t state)
>  *
>  * This function is called by OS when a power event occurs
>  */
> -int dma_resume(struct pci_dev *pci)
> +int dma_resume(struct device *dev)
>  {
> +	struct pci_dev *pci = to_pci_dev(dev);
>  	int ret;
>  	struct middma_device *device = pci_get_drvdata(pci);
>  
> @@ -1429,6 +1431,8 @@ static const struct dev_pm_ops intel_mid_dma_pm = {
>  	.runtime_suspend = dma_runtime_suspend,
>  	.runtime_resume = dma_runtime_resume,
>  	.runtime_idle = dma_runtime_idle,
> +	.suspend = dma_suspend,
> +	.resume = dma_resume,
>  };
>  
>  static struct pci_driver intel_mid_dma_pci_driver = {
> @@ -1437,8 +1441,6 @@ static struct pci_driver intel_mid_dma_pci_driver = {
>  	.probe		=	intel_mid_dma_probe,
>  	.remove		=	__devexit_p(intel_mid_dma_remove),
>  #ifdef CONFIG_PM
> -	.suspend = dma_suspend,
> -	.resume = dma_resume,
>  	.driver = {
>  		.pm = &intel_mid_dma_pm,
>  	},
> diff --git a/drivers/dma/intel_mid_dma_regs.h b/drivers/dma/intel_mid_dma_regs.h
> index c6de919..c83d35b 100644
> --- a/drivers/dma/intel_mid_dma_regs.h
> +++ b/drivers/dma/intel_mid_dma_regs.h
> @@ -296,6 +296,6 @@ static inline struct intel_mid_dma_slave *to_intel_mid_dma_slave
>  }
>  
> 
> -int dma_resume(struct pci_dev *pci);
> +int dma_resume(struct device *dev);
>  
>  #endif /*__INTEL_MID_DMAC_REGS_H__*/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
~Vinod

