Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab1JKOYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 10:24:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:13382 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab1JKOYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 10:24:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,523,1312182000"; 
   d="scan'208";a="76969843"
Subject: Re: [PATCH 1/4] dmaengine: at_hdmac: platform data move to use
 .id_table
From: Vinod Koul <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, robherring2@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca
In-Reply-To: <9723283e7097730f568bf7c2f3a93ae42c6bc5ca.1318264339.git.nicolas.ferre@atmel.com>
References: <1314075338.22120.3.camel@vkoul-udesk3>
	 <9723283e7097730f568bf7c2f3a93ae42c6bc5ca.1318264339.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 19:46:52 +0530
Message-ID: <1318342612.1546.352.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 18:37 +0200, Nicolas Ferre wrote:
> We remove platform data from DMA controller and move
> to the use of .id_table to distinguish between compatible
> types. The two implementations allow to determine the
> number of channels and the capabilities of the controller.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/dma/at_hdmac.c      |   48 ++++++++++++++++++++++++++++++++++---------
>  drivers/dma/at_hdmac_regs.h |    8 +++++++
>  2 files changed, 46 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index fcfa0a8..fef57bc 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -1175,6 +1175,18 @@ static void atc_free_chan_resources(struct dma_chan *chan)
>  
>  /*--  Module Management  -----------------------------------------------*/
>  
> +static struct platform_device_id atdma_devtypes[] = {
> +	{
> +		.name = "at91sam9rl_dma",
> +		.driver_data = ATDMA_DEVTYPE_SAM9RL,
> +	}, {
> +		.name = "at91sam9g45_dma",
> +		.driver_data = ATDMA_DEVTYPE_SAM9G45,
> +	}, {
> +		/* sentinel */
> +	}
> +};
> +
>  /**
>   * at_dma_off - disable DMA controller
>   * @atdma: the Atmel HDAMC device
> @@ -1193,18 +1205,32 @@ static void at_dma_off(struct at_dma *atdma)
>  
>  static int __init at_dma_probe(struct platform_device *pdev)
>  {
> -	struct at_dma_platform_data *pdata;
>  	struct resource		*io;
>  	struct at_dma		*atdma;
>  	size_t			size;
>  	int			irq;
>  	int			err;
>  	int			i;
> +	u32                     nr_channels;
> +	dma_cap_mask_t          cap_mask = {};
> +	enum atdma_devtype	atdmatype;
> +
> +	dma_cap_set(DMA_MEMCPY, cap_mask);
> +
> +	/* get DMA parameters from controller type */
> +	atdmatype = platform_get_device_id(pdev)->driver_data;
>  
> -	/* get DMA Controller parameters from platform */
> -	pdata = pdev->dev.platform_data;
> -	if (!pdata || pdata->nr_channels > AT_DMA_MAX_NR_CHANNELS)
> +	switch (atdmatype) {
> +	case ATDMA_DEVTYPE_SAM9RL:
> +		nr_channels = 2;
> +		break;
> +	case ATDMA_DEVTYPE_SAM9G45:
> +		nr_channels = 8;
> +		dma_cap_set(DMA_SLAVE, cap_mask);
> +		break;
> +	default:
>  		return -EINVAL;
> +	}
>  
>  	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!io)
> @@ -1215,14 +1241,15 @@ static int __init at_dma_probe(struct platform_device *pdev)
>  		return irq;
>  
>  	size = sizeof(struct at_dma);
> -	size += pdata->nr_channels * sizeof(struct at_dma_chan);
> +	size += nr_channels * sizeof(struct at_dma_chan);
>  	atdma = kzalloc(size, GFP_KERNEL);
>  	if (!atdma)
>  		return -ENOMEM;
>  
> -	/* discover transaction capabilites from the platform data */
> -	atdma->dma_common.cap_mask = pdata->cap_mask;
> -	atdma->all_chan_mask = (1 << pdata->nr_channels) - 1;
> +	/* discover transaction capabilites */
capabilities
> +	atdma->dma_common.cap_mask = cap_mask;
> +	atdma->all_chan_mask = (1 << nr_channels) - 1;
> +	atdma->devtype = atdmatype;
>  
>  	size = resource_size(io);
>  	if (!request_mem_region(io->start, size, pdev->dev.driver->name)) {
> @@ -1268,7 +1295,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
>  
>  	/* initialize channels related values */
>  	INIT_LIST_HEAD(&atdma->dma_common.channels);
> -	for (i = 0; i < pdata->nr_channels; i++) {
> +	for (i = 0; i < nr_channels; i++) {
>  		struct at_dma_chan	*atchan = &atdma->chan[i];
>  
>  		atchan->chan_common.device = &atdma->dma_common;
> @@ -1313,7 +1340,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
>  	dev_info(&pdev->dev, "Atmel AHB DMA Controller ( %s%s), %d channels\n",
>  	  dma_has_cap(DMA_MEMCPY, atdma->dma_common.cap_mask) ? "cpy " : "",
>  	  dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask)  ? "slave " : "",
> -	  pdata->nr_channels);
> +	  nr_channels);
indent?
>  
>  	dma_async_device_register(&atdma->dma_common);
>  
> @@ -1495,6 +1522,7 @@ static const struct dev_pm_ops at_dma_dev_pm_ops = {
>  static struct platform_driver at_dma_driver = {
>  	.remove		= __exit_p(at_dma_remove),
>  	.shutdown	= at_dma_shutdown,
> +	.id_table	= atdma_devtypes,
>  	.driver = {
>  		.name	= "at_hdmac",
>  		.pm	= &at_dma_dev_pm_ops,
> diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
> index aa4c9ae..d7d6737 100644
> --- a/drivers/dma/at_hdmac_regs.h
> +++ b/drivers/dma/at_hdmac_regs.h
> @@ -248,9 +248,16 @@ static inline struct at_dma_chan *to_at_dma_chan(struct dma_chan *dchan)
>  
>  /*--  Controller  ------------------------------------------------------*/
>  
> +enum atdma_devtype {
> +	ATDMA_DEVTYPE_UNDEFINED = 0,
> +	ATDMA_DEVTYPE_SAM9RL,	/* compatible with SAM9RL DMA controller */
> +	ATDMA_DEVTYPE_SAM9G45,	/* compatible with SAM9G45 DMA controller */
> +};
> +
>  /**
>   * struct at_dma - internal representation of an Atmel HDMA Controller
>   * @chan_common: common dmaengine dma_device object members
> + * @atdma_devtype: identifier of DMA controller compatibility
>   * @ch_regs: memory mapped register base
>   * @clk: dma controller clock
>   * @save_imr: interrupt mask register that is saved on suspend/resume cycle
> @@ -260,6 +267,7 @@ static inline struct at_dma_chan *to_at_dma_chan(struct dma_chan *dchan)
>   */
>  struct at_dma {
>  	struct dma_device	dma_common;
> +	enum atdma_devtype	devtype;
>  	void __iomem		*regs;
>  	struct clk		*clk;
>  	u32			save_imr;
Little confused at this, where is the remove of existing platfrom data
per the changelog?

-- 
~Vinod

