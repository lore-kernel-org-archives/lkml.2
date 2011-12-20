Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab1LTJNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 04:13:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33704 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1LTJNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 04:13:38 -0500
Subject: Re: [PATCH 3/3] dmaengine: intel_mid_dma: remove legacy pm
 interface
From: Vinod Koul <vkoul@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: vinod.koul@intel.com, Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kristen Carlson Accardi <kristen@linux.intel.com>
In-Reply-To: <1324026100-3124-4-git-send-email-adrian.hunter@intel.com>
References: <1324026100-3124-1-git-send-email-adrian.hunter@intel.com>
	 <1324026100-3124-4-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Dec 2011 14:43:16 +0530
Message-ID: <1324372396.1641.10064.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 11:01 +0200, Adrian Hunter wrote:
> From: Kristen Carlson Accardi <kristen@linux.intel.com>
> 
> Drivers should not support both legacy pm and new framework.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
There seems to be a similar patch from Kristen sent by Alan??

> ---
>  drivers/dma/intel_mid_dma.c      |   12 +++++++-----
>  drivers/dma/intel_mid_dma_regs.h |    2 +-
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
> index bbcd470..74f70aa 100644
> --- a/drivers/dma/intel_mid_dma.c
> +++ b/drivers/dma/intel_mid_dma.c
> @@ -873,7 +873,7 @@ static int intel_mid_dma_alloc_chan_resources(struct dma_chan *chan)
>  	pm_runtime_get_sync(&mid->pdev->dev);
>  
>  	if (mid->state == SUSPENDED) {
> -		if (dma_resume(mid->pdev)) {
> +		if (dma_resume(&mid->pdev->dev)) {
>  			pr_err("ERR_MDMA: resume failed");
>  			return -EFAULT;
>  		}
> @@ -1346,8 +1346,9 @@ static void __devexit intel_mid_dma_remove(struct pci_dev *pdev)
>  *
>  * This function is called by OS when a power event occurs
>  */
> -int dma_suspend(struct pci_dev *pci, pm_message_t state)
> +static int dma_suspend(struct device *dev)
>  {
> +	struct pci_dev *pci = to_pci_dev(dev);
>  	int i;
>  	struct middma_device *device = pci_get_drvdata(pci);
>  	pr_debug("MDMA: dma_suspend called\n");
> @@ -1371,8 +1372,9 @@ int dma_suspend(struct pci_dev *pci, pm_message_t state)
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
> @@ -1438,6 +1440,8 @@ static const struct dev_pm_ops intel_mid_dma_pm = {
>  	.runtime_suspend = dma_runtime_suspend,
>  	.runtime_resume = dma_runtime_resume,
>  	.runtime_idle = dma_runtime_idle,
> +	.suspend = dma_suspend,
> +	.resume = dma_resume,
>  };
>  
>  static struct pci_driver intel_mid_dma_pci_driver = {
> @@ -1446,8 +1450,6 @@ static struct pci_driver intel_mid_dma_pci_driver = {
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



