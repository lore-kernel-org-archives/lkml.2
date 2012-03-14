Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab2CNGC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 02:02:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34870 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab2CNGB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 02:01:56 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1 2/5] mmc: mxs-mmc: add dt probe support
Date: Wed, 14 Mar 2012 06:58:25 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: Dong Aisheng <b29396@freescale.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        vinod.koul@linux.intel.com, s.hauer@pengutronix.de,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        rdunlap@xenotime.net, kernel@pengutronix.de, cjb@laptop.org,
        shawn.guo@freescale.com
References: <1331628428-24017-1-git-send-email-b29396@freescale.com> <1331628428-24017-3-git-send-email-b29396@freescale.com>
In-Reply-To: <1331628428-24017-3-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203140658.25854.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Dong Aisheng,

> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> 
> ---
> The patch is still using a private way for dma part binding
> since the common dma binding is still under discussion.
> http://www.spinics.net/lists/linux-omap/msg65528.html
> 
> Will update to use common dma binding when it hits mainline.
> ---
>  .../devicetree/bindings/mmc/fsl-mxs-mmc.txt        |   23 ++++++
>  drivers/mmc/host/mxs-mmc.c                         |   82
> +++++++++++++++++++- 2 files changed, 102 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mmc/fsl-mxs-mmc.txt
> b/Documentation/devicetree/bindings/mmc/fsl-mxs-mmc.txt new file mode
> 100644
> index 0000000..adc1142
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mmc/fsl-mxs-mmc.txt
> @@ -0,0 +1,23 @@
> +* FREESCALE MXS MMC peripheral
> +
> +Required properties:
> +- compatible : Should be "fsl,<chip>-mmc"
> +- reg : Should contain registers location and length
> +- interrupts : Should contain interrupt.
> +  The format is <irq_err irq_dma>.
> +- dma_channel: Should contain the dma channel it uses
> +
> +Optional properties:
> +- wp-gpios : Specify GPIOs for write protection
> +- slot-4bit: Specify 4 bit mode support
> +- slot-8bit: Specify 8 bit and 4 bit mode support
> +
> +Examples:
> +mmc1: ssp@80010000 {
> +	compatible = "fsl,imx28-mmc";
> +	reg = <0x80010000 2000>;
> +	/* <irq_err irq_dma> */
> +	interrupts = <96 82>;
> +	dma_channel = <0>;
> +	slot-8bit;
> +};
> diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
> index 382c835..6cf2d17 100644
> --- a/drivers/mmc/host/mxs-mmc.c
> +++ b/drivers/mmc/host/mxs-mmc.c
> @@ -38,6 +38,10 @@
>  #include <linux/gpio.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_gpio.h>
> +#include <linux/slab.h>
> 
>  #include <mach/mxs.h>
>  #include <mach/common.h>
> @@ -673,17 +677,79 @@ static bool mxs_mmc_dma_filter(struct dma_chan *chan,
> void *param) return true;
>  }
> 
> +#ifdef CONFIG_OF
> +static struct resource * __devinit mxs_mmc_get_of_dmares(
> +				struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct resource *dmares;
> +	int ret;
> +
> +	if (!np)
> +		return NULL;
> +
> +	dmares = kzalloc(sizeof(*dmares), GFP_KERNEL);
> +	dmares->flags = IORESOURCE_DMA;
> +	ret = of_property_read_u32(np, "dma_channel", &dmares->start);
> +	if (ret) {
> +		dev_err(&pdev->dev, "unable to get dmares from dt\n");
> +		return NULL;
> +	}
> +	dmares->end = dmares->start;
> +
> +	return dmares;
> +}
> +
> +static int __devinit mxs_mmc_get_of_property(struct platform_device *pdev,
> +				struct mxs_mmc_platform_data **ppdata)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct mxs_mmc_platform_data *pdata = *ppdata;
> +
> +	if (!np)
> +		return -ENODEV;
> +
> +	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> +
> +	if (of_get_property(np, "slot-8bit", NULL))
> +		pdata->flags |= SLOTF_8_BIT_CAPABLE;
> +
> +	if (of_get_property(np, "slot-4bit", NULL))
> +		pdata->flags |= SLOTF_4_BIT_CAPABLE;
> +
> +	pdata->wp_gpio = of_get_named_gpio(np, "wp-gpios", 0);
> +
> +	dev_dbg(&pdev->dev, "wp-gpios %d flags %d\n", pdata->wp_gpio,
> +		pdata->flags);
> +
> +	return 0;
> +}
> +#else
> +static struct resource * __devinit mxs_mmc_get_of_dmares(
> +				struct platform_device *pdev)
> +{
> +	return NULL;
> +}
> +static inline int mxs_mmc_get_of_property(struct platform_device *pdev,
> +			struct mxs_mmc_platform_data *pdata)
> +{
> +	return -ENODEV;
> +}
> +#endif
> +
>  static int mxs_mmc_probe(struct platform_device *pdev)
>  {
>  	struct mxs_mmc_host *host;
>  	struct mmc_host *mmc;
>  	struct resource *iores, *dmares, *r;
> -	struct mxs_mmc_platform_data *pdata;
> +	struct mxs_mmc_platform_data *pdata = NULL;
>  	int ret = 0, irq_err, irq_dma;
>  	dma_cap_mask_t mask;
> 
>  	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 0);
> +	dmares = mxs_mmc_get_of_dmares(pdev);
> +	if (dmares == NULL)
> +		dmares = platform_get_resource(pdev, IORESOURCE_DMA, 0);
>  	irq_err = platform_get_irq(pdev, 0);
>  	irq_dma = platform_get_irq(pdev, 1);
>  	if (!iores || !dmares || irq_err < 0 || irq_dma < 0)
> @@ -740,7 +806,9 @@ static int mxs_mmc_probe(struct platform_device *pdev)
>  	mmc->caps = MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED |
>  		    MMC_CAP_SDIO_IRQ | MMC_CAP_NEEDS_POLL;
> 
> -	pdata =	mmc_dev(host->mmc)->platform_data;
> +	mxs_mmc_get_of_property(pdev, &pdata);
> +	if (pdata == NULL)
> +		pdata =	mmc_dev(host->mmc)->platform_data;
>  	if (pdata) {
>  		if (pdata->flags & SLOTF_8_BIT_CAPABLE)
>  			mmc->caps |= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA;
> @@ -851,6 +919,13 @@ static const struct dev_pm_ops mxs_mmc_pm_ops = {
>  };
>  #endif
> 
> +static const struct of_device_id mxs_mmc_dt_ids[] = {
> +	{ .compatible = "fsl,imx23-mmc", .data = NULL, },
> +	{ .compatible = "fsl,imx28-mmc", .data = NULL, },

Do you really need two distinct ones here?

> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, mxs_mmc_dt_ids);
> +
>  static struct platform_driver mxs_mmc_driver = {
>  	.probe		= mxs_mmc_probe,
>  	.remove		= mxs_mmc_remove,
> @@ -860,6 +935,7 @@ static struct platform_driver mxs_mmc_driver = {
>  #ifdef CONFIG_PM
>  		.pm	= &mxs_mmc_pm_ops,
>  #endif
> +		.of_match_table = mxs_mmc_dt_ids,
>  	},
>  };
