Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1DNXGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 19:06:14 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:33663 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab1DNXGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 19:06:09 -0400
Date: Fri, 15 Apr 2011 01:06:02 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Michal Simek <monstr@monstr.eu>
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de, w.sang@pengutronix.de, arnd@arndb.de
Subject: Re: [PATCH v2] uio/pdrv_genirq: Add OF support
Message-ID: <20110414230602.GC2780@local>
References: <1302774106-32764-1-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302774106-32764-1-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 11:41:46AM +0200, Michal Simek wrote:
> Support OF support. "generic-uio" compatible property is used.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> 
> ---
> v2: Remove additional resource binding
>     Setup correct version string
>     Clear compatible string
> ---
>  drivers/uio/uio_pdrv_genirq.c |   45 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 45 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index 7174d51..fd84a93 100644
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
> @@ -97,6 +101,28 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  	int ret = -EINVAL;
>  	int i;
>  
> +	if (!uioinfo) {
> +		/* alloc uioinfo for one device */
> +		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
> +		if (!uioinfo) {
> +			ret = -ENOMEM;
> +			dev_err(&pdev->dev, "unable to kmalloc\n");
> +			goto bad2;
> +		}
> +		uioinfo->name = pdev->dev.of_node->name;
> +		uioinfo->version = "dt";

Can that be something more descriptive?

> +
> +		/* Multiple IRQs are not supported */

But multiple mappings are, and also no mappings.

> +		if (pdev->num_resources > 1) {
> +			struct resource *r = &pdev->resource[1];
> +			uioinfo->irq = r->start;

Why has the irq be resource[1] ?

> +			dev_info(&pdev->dev, "irq %d\n", (u32)uioinfo->irq);
> +		} else {
> +			uioinfo->irq = UIO_IRQ_NONE;
> +			dev_info(&pdev->dev, "no IRQ found\n");
> +		}
> +	}
> +
>  	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
>  		dev_err(&pdev->dev, "missing platform_data\n");
>  		goto bad0;
> @@ -180,6 +206,10 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  	kfree(priv);
>  	pm_runtime_disable(&pdev->dev);
>   bad0:
> +	/* kfree uioinfo for CONFIG_OF */
> +	if (!pdev->dev.platform_data)
> +		kfree(uioinfo);
> + bad2:
>  	return ret;
>  }
>  
> @@ -215,6 +245,20 @@ static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
>  	.runtime_resume = uio_pdrv_genirq_runtime_nop,
>  };
>  
> +#ifdef CONFIG_OF
> +/*
> + * Empty match table for of_platform binding
> + * Select your custom compatible string in format
> + * { .compatible = "<compatible string>", },
> + */
> +static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
> +	{ /* end of list */ },

doesn't that want a NULL termination?

> +};
> +MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
> +#else
> +# define uio_of_genirq_match NULL
> +#endif
> +
>  static struct platform_driver uio_pdrv_genirq = {
>  	.probe = uio_pdrv_genirq_probe,
>  	.remove = uio_pdrv_genirq_remove,
> @@ -222,6 +266,7 @@ static struct platform_driver uio_pdrv_genirq = {
>  		.name = DRIVER_NAME,
>  		.owner = THIS_MODULE,
>  		.pm = &uio_pdrv_genirq_dev_pm_ops,
> +		.of_match_table = uio_of_genirq_match,
>  	},
>  };
>  
> -- 
> 1.5.5.6
> 
> 
