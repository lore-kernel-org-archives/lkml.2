Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1EXL1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 07:27:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44679 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab1EXL1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 07:27:17 -0400
Message-ID: <4DDB960F.4050902@monstr.eu>
Date: Tue, 24 May 2011 13:27:11 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: devicetree-discuss@lists.ozlabs.org
CC: linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@hansjkoch.de>,
        Arnd Bergmann <arnd@arndb.de>,
        John Williams <john.williams@petalogix.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v5] uio/pdrv_genirq: Add OF support
References: <1304577644-4024-1-git-send-email-monstr@monstr.eu>
In-Reply-To: <1304577644-4024-1-git-send-email-monstr@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

can you please add it to your tree? I see you have sent pull request.

Thanks,
Michal

Michal Simek wrote:
> Adding OF binding to genirq.
> Version string is setup to the "devicetree".
> 
> Compatible string is not setup for now but you can add your
> custom compatible string to uio_of_genirq_match structure.
> 
> For example with "vendor,device" compatible string:
> static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
> 	{ .compatible = "vendor,device", },
> 	{ /* empty for now */ },
> };
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> CC: Hans J. Koch <hjk@hansjkoch.de>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: John Williams <john.williams@petalogix.com>
> CC: Grant Likely <grant.likely@secretlab.ca>
> CC: Wolfram Sang <w.sang@pengutronix.de>
> 
> ---
> v5: Free uioinfo in genirq_remove
>     Use pdev->dev.of_node for OF detection
> 
> v4: Remove dev_info messages
>     Check irq against -ENXIO for no irq
> 
> v3: Fix irq binding
>     Use "devicetree" as version string
> 
> v2: Remove additional resource binding
>     Setup correct version string
>     Clear compatible string
> ---
>  drivers/uio/uio_pdrv_genirq.c |   44 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 44 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index 7174d51..24bb395 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -23,6 +23,10 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/slab.h>
>  
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_address.h>
> +
>  #define DRIVER_NAME "uio_pdrv_genirq"
>  
>  struct uio_pdrv_genirq_platdata {
> @@ -97,6 +101,27 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  	int ret = -EINVAL;
>  	int i;
>  
> +	if (!uioinfo) {
> +		int irq;
> +
> +		/* alloc uioinfo for one device */
> +		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
> +		if (!uioinfo) {
> +			ret = -ENOMEM;
> +			dev_err(&pdev->dev, "unable to kmalloc\n");
> +			goto bad2;
> +		}
> +		uioinfo->name = pdev->dev.of_node->name;
> +		uioinfo->version = "devicetree";
> +
> +		/* Multiple IRQs are not supported */
> +		irq = platform_get_irq(pdev, 0);
> +		if (irq == -ENXIO)
> +			uioinfo->irq = UIO_IRQ_NONE;
> +		else
> +			uioinfo->irq = irq;
> +	}
> +
>  	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
>  		dev_err(&pdev->dev, "missing platform_data\n");
>  		goto bad0;
> @@ -180,6 +205,10 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  	kfree(priv);
>  	pm_runtime_disable(&pdev->dev);
>   bad0:
> +	/* kfree uioinfo for OF */
> +	if (pdev->dev.of_node)
> +		kfree(uioinfo);
> + bad2:
>  	return ret;
>  }
>  
> @@ -189,6 +218,11 @@ static int uio_pdrv_genirq_remove(struct platform_device *pdev)
>  
>  	uio_unregister_device(priv->uioinfo);
>  	pm_runtime_disable(&pdev->dev);
> +
> +	/* kfree uioinfo for OF */
> +	if (pdev->dev.of_node)
> +		kfree(priv->uioinfo);
> +
>  	kfree(priv);
>  	return 0;
>  }
> @@ -215,6 +249,15 @@ static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
>  	.runtime_resume = uio_pdrv_genirq_runtime_nop,
>  };
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
> +	{ /* empty for now */ },
> +};
> +MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
> +#else
> +# define uio_of_genirq_match NULL
> +#endif
> +
>  static struct platform_driver uio_pdrv_genirq = {
>  	.probe = uio_pdrv_genirq_probe,
>  	.remove = uio_pdrv_genirq_remove,
> @@ -222,6 +265,7 @@ static struct platform_driver uio_pdrv_genirq = {
>  		.name = DRIVER_NAME,
>  		.owner = THIS_MODULE,
>  		.pm = &uio_pdrv_genirq_dev_pm_ops,
> +		.of_match_table = uio_of_genirq_match,
>  	},
>  };
>  


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
