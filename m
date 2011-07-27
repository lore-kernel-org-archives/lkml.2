Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1G0JEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:04:08 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:60096 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484Ab1G0JEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:04:07 -0400
X-Greylist: delayed 2756 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jul 2011 05:04:06 EDT
Date: Wed, 27 Jul 2011 10:17:48 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@hansjkoch.de>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        John Williams <john.williams@petalogix.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 09/11] uio: uio_pdrv_genirq: Add OF support
Message-ID: <20110727081748.GA18674@local>
References: <20110726045707.GA2321@kroah.com>
 <1311739521-11014-1-git-send-email-gregkh@suse.de>
 <1311739521-11014-9-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311739521-11014-9-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 09:05:19PM -0700, Greg Kroah-Hartman wrote:
> From: "Hans J. Koch" <hjk@hansjkoch.de>

This should read From: Michal Simek <monstr@monstr.eu>

Thanks,
Hans

> 
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
> Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
> Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
> CC: Hans J. Koch <hjk@hansjkoch.de>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: John Williams <john.williams@petalogix.com>
> CC: Grant Likely <grant.likely@secretlab.ca>
> CC: Wolfram Sang <w.sang@pengutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/uio/uio_pdrv_genirq.c |   43 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index 0f424af..f8f81db 100644
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
> @@ -193,6 +222,10 @@ static int uio_pdrv_genirq_remove(struct platform_device *pdev)
>  	priv->uioinfo->handler = NULL;
>  	priv->uioinfo->irqcontrol = NULL;
>  
> +	/* kfree uioinfo for OF */
> +	if (pdev->dev.of_node)
> +		kfree(priv->uioinfo);
> +
>  	kfree(priv);
>  	return 0;
>  }
> @@ -219,6 +252,15 @@ static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
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
> @@ -226,6 +268,7 @@ static struct platform_driver uio_pdrv_genirq = {
>  		.name = DRIVER_NAME,
>  		.owner = THIS_MODULE,
>  		.pm = &uio_pdrv_genirq_dev_pm_ops,
> +		.of_match_table = uio_of_genirq_match,
>  	},
>  };
>  
> -- 
> 1.7.6
> 
> 
