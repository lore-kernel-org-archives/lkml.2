Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab1HGFdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 01:33:17 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57480 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1HGFcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 01:32:53 -0400
Date: Sat, 6 Aug 2011 22:09:33 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: at_hdmac: add device tree probe
Message-ID: <20110807040932.GF7667@ponder.secretlab.ca>
References: <1312549120-22266-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312549120-22266-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 01:58:40PM +0100, Nicolas Ferre wrote:
> Add device tree probe support for atmel at_hdmac DMA driver.
> Bindings are added to specify the number of channels that the implementation of
> the controller actually has. They also allow to tell if the peripherals/DMA
> transfer is supported by the IP.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  .../devicetree/bindings/dma/atmel-hdmac.txt        |   23 +++++++++
>  drivers/dma/at_hdmac.c                             |   51 ++++++++++++++++----
>  2 files changed, 65 insertions(+), 9 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/dma/atmel-hdmac.txt
> 
> diff --git a/Documentation/devicetree/bindings/dma/atmel-hdmac.txt b/Documentation/devicetree/bindings/dma/atmel-hdmac.txt
> new file mode 100644
> index 0000000..0e48553
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/atmel-hdmac.txt
> @@ -0,0 +1,23 @@
> +* Atmel Direct Memory Access Controller
> +
> +Required properties:
> +- compatible: Should be "atmel,<chip>-hdmac"
> +- reg: Should contain DMA registers location and length
> +- interrupts: Should contain DMA interrupt
> +- atmel,hdmac-nr-channels: Should contain number of channels
> +  available in the controller
> +
> +Optional properties:
> +- atmel,hdmac-cap-memcpy: Chip can do memory to memory transfers
> +- atmel,hdmac-cap-slave: Chip can do peripherals/memory transfers

Heh, ignore my comments on the other patch about missing documentation
for the dma engine.  :-)

Otherwise the patch looks pretty good.  I suspect there is a thing or
two that won't compile correctly when !CONFIG_OF, but I haven't
checked closely.  Just make sure !CONFIG_OF is tested.  :-)

g.


> +
> +Examples:
> +
> +dma@ffffec00 {
> +	compatible = "atmel,at91sam9g45-hdmac";
> +	reg = <0xffffec00 0x200>;
> +	interrupts = <21>;
> +	atmel,hdmac-nr-channels = <8>;
> +	atmel,hdmac-cap-memcpy;
> +	atmel,hdmac-cap-slave;
> +};
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index 8f1d2ee..4a0cefe 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -23,6 +23,8 @@
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
>  
>  #include "at_hdmac_regs.h"
>  
> @@ -1167,6 +1169,18 @@ static void atc_free_chan_resources(struct dma_chan *chan)
>  
>  /*--  Module Management  -----------------------------------------------*/
>  
> +#if defined(CONFIG_OF)
> +static const struct of_device_id atmel_dma_dt_ids[] = {
> +	{ .compatible = "atmel,at91sam9rl-hdmac" },
> +	{ .compatible = "atmel,at91sam9g45-hdmac" },
> +	{ /* sentinel */ }
> +};
> +
> +MODULE_DEVICE_TABLE(of, atmel_dma_dt_ids);
> +#else
> +#define atmel_dma_dt_ids NULL
> +#endif
> +
>  /**
>   * at_dma_off - disable DMA controller
>   * @atdma: the Atmel HDAMC device
> @@ -1185,17 +1199,36 @@ static void at_dma_off(struct at_dma *atdma)
>  
>  static int __init at_dma_probe(struct platform_device *pdev)
>  {
> -	struct at_dma_platform_data *pdata;
> +	const struct of_device_id *of_id =
> +			of_match_device(atmel_dma_dt_ids, &pdev->dev);
> +	struct device_node	*np = pdev->dev.of_node;
> +	struct at_dma_platform_data *pdata = pdev->dev.platform_data;
>  	struct resource		*io;
>  	struct at_dma		*atdma;
>  	size_t			size;
>  	int			irq;
>  	int			err;
>  	int			i;
> +	u32			nr_channels;
> +	dma_cap_mask_t		cap_mask = {};
> +
> +	/* get DMA Controller parameters */
> +	if (of_id) {
> +		if (of_property_read_u32(np, "atmel,hdmac-nr-channels",
> +					&nr_channels))
> +			return -EINVAL;
> +		if (of_find_property(np, "atmel,hdmac-cap-memcpy", NULL))
> +			dma_cap_set(DMA_MEMCPY, cap_mask);
> +		if (of_find_property(np, "atmel,hdmac-cap-slave", NULL))
> +			dma_cap_set(DMA_SLAVE, cap_mask);
> +	} else if (pdata) {
> +		nr_channels = pdata->nr_channels;
> +		cap_mask = pdata->cap_mask;
> +	} else {
> +		return -EINVAL;
> +	}
>  
> -	/* get DMA Controller parameters from platform */
> -	pdata = pdev->dev.platform_data;
> -	if (!pdata || pdata->nr_channels > AT_DMA_MAX_NR_CHANNELS)
> +	if (!nr_channels || nr_channels > AT_DMA_MAX_NR_CHANNELS)
>  		return -EINVAL;
>  
>  	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> @@ -1207,14 +1240,13 @@ static int __init at_dma_probe(struct platform_device *pdev)
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
> +	atdma->dma_common.cap_mask = cap_mask;
> +	atdma->all_chan_mask = (1 << nr_channels) - 1;
>  
>  	size = io->end - io->start + 1;
>  	if (!request_mem_region(io->start, size, pdev->dev.driver->name)) {
> @@ -1260,7 +1292,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
>  
>  	/* initialize channels related values */
>  	INIT_LIST_HEAD(&atdma->dma_common.channels);
> -	for (i = 0; i < pdata->nr_channels; i++, atdma->dma_common.chancnt++) {
> +	for (i = 0; i < nr_channels; i++, atdma->dma_common.chancnt++) {
>  		struct at_dma_chan	*atchan = &atdma->chan[i];
>  
>  		atchan->chan_common.device = &atdma->dma_common;
> @@ -1406,6 +1438,7 @@ static struct platform_driver at_dma_driver = {
>  	.driver = {
>  		.name	= "at_hdmac",
>  		.pm	= &at_dma_dev_pm_ops,
> +		.of_match_table	= atmel_dma_dt_ids,
>  	},
>  };
>  
> -- 
> 1.7.4.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
