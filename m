Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2CNHv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:51:59 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:54137
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758584Ab2CNHv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:51:57 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz1432Nzz1202h1082kzz8275dhz2dh2a8h668h839hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F604EBD.7060400@freescale.com>
Date: Wed, 14 Mar 2012 15:54:37 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <vinod.koul@linux.intel.com>, <s.hauer@pengutronix.de>,
        <rob.herring@calxeda.com>, <grant.likely@secretlab.ca>,
        <rdunlap@xenotime.net>, <kernel@pengutronix.de>, <cjb@laptop.org>,
        <shawn.guo@freescale.com>
Subject: Re: [PATCH v1 4/5] dma: mxs-dma: add dt probe support
References: <1331628428-24017-1-git-send-email-b29396@freescale.com> <1331628428-24017-5-git-send-email-b29396@freescale.com>
In-Reply-To: <1331628428-24017-5-git-send-email-b29396@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aisheng:
> From: Dong Aisheng<dong.aisheng@linaro.org>
>
> Signed-off-by: Dong Aisheng<dong.aisheng@linaro.org>
> ---
>   .../devicetree/bindings/dma/fsl-mxs-dma.txt        |   17 ++++++++
>   drivers/dma/mxs-dma.c                              |   44 +++++++++++++------
>   2 files changed, 47 insertions(+), 14 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/dma/fsl-mxs-dma.txt b/Documentation/devicetree/bindings/dma/fsl-mxs-dma.txt
> new file mode 100644
> index 0000000..cfa1730
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/fsl-mxs-dma.txt
> @@ -0,0 +1,17 @@
> +* Freescale MXS DMA
> +
> +Required properties:
> +- compatible : Should be "fsl,mxs-dma-apbh" or "fsl,mxs-dma-apbx"
> +- reg : Should contain registers location and length
> +
> +Examples:
> +
> +dma-apbh@80004000 {
> +	compatible = "fsl,mxs-dma-apbh";
> +	reg =<0x80004000 2000>;
> +};
> +
> +dma-apbx@80024000 {
> +	compatible = "fsl,mxs-dma-apbx";
> +	reg =<0x80024000 2000>;
> +};
> diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> index b06cd4c..45e8d46 100644
> --- a/drivers/dma/mxs-dma.c
> +++ b/drivers/dma/mxs-dma.c
> @@ -22,6 +22,9 @@
>   #include<linux/platform_device.h>
>   #include<linux/dmaengine.h>
>   #include<linux/delay.h>
> +#include<linux/module.h>
> +#include<linux/of.h>
> +#include<linux/of_device.h>
>
>   #include<asm/irq.h>
>   #include<mach/mxs.h>
> @@ -130,6 +133,25 @@ struct mxs_dma_engine {
>   	struct mxs_dma_chan		mxs_chans[MXS_DMA_CHANNELS];
>   };
>
> +static struct platform_device_id mxs_dma_type[] = {
> +	{
> +		.name = "mxs-dma-apbh",
> +		.driver_data = MXS_DMA_APBH,
> +	}, {
> +		.name = "mxs-dma-apbx",
> +		.driver_data = MXS_DMA_APBX,
> +	}, {
> +		/* end of list */
> +	}
> +};
> +
I think you should use the platform_device_id to distinguish different 
archs.
In the mx6q,  you will meet some compiler error for the macro cpu_is_mx23().

BR
Huang Shijie



> +static const struct of_device_id mxs_dma_dt_ids[] = {
> +	{ .compatible = "fsl,mxs-dma-apbh", .data =&mxs_dma_type[0], },
> +	{ .compatible = "fsl,mxs-dma-apbx", .data =&mxs_dma_type[1], },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, mxs_dma_dt_ids);
> +
>   static void mxs_dma_reset_chan(struct mxs_dma_chan *mxs_chan)
>   {
>   	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
> @@ -587,8 +609,8 @@ err_out:
>
>   static int __init mxs_dma_probe(struct platform_device *pdev)
>   {
> -	const struct platform_device_id *id_entry =
> -				platform_get_device_id(pdev);
> +	const struct platform_device_id *id_entry;
> +	const struct of_device_id *of_id;
>   	struct mxs_dma_engine *mxs_dma;
>   	struct resource *iores;
>   	int ret, i;
> @@ -597,6 +619,11 @@ static int __init mxs_dma_probe(struct platform_device *pdev)
>   	if (!mxs_dma)
>   		return -ENOMEM;
>
> +	of_id = of_match_device(mxs_dma_dt_ids,&pdev->dev);
> +	if (of_id)
> +		id_entry = of_id->data;
> +	else
> +		id_entry = platform_get_device_id(pdev);
>   	mxs_dma->dev_id = id_entry->driver_data;
>
>   	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> @@ -679,21 +706,10 @@ err_request_region:
>   	return ret;
>   }
>
> -static struct platform_device_id mxs_dma_type[] = {
> -	{
> -		.name = "mxs-dma-apbh",
> -		.driver_data = MXS_DMA_APBH,
> -	}, {
> -		.name = "mxs-dma-apbx",
> -		.driver_data = MXS_DMA_APBX,
> -	}, {
> -		/* end of list */
> -	}
> -};
> -
>   static struct platform_driver mxs_dma_driver = {
>   	.driver		= {
>   		.name	= "mxs-dma",
> +		.of_match_table = mxs_dma_dt_ids,
>   	},
>   	.id_table	= mxs_dma_type,
>   };


