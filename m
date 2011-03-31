Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab1CaQnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:43:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51691 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab1CaQnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:43:51 -0400
Date: Thu, 31 Mar 2011 10:43:48 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Michal Simek <monstr@monstr.eu>
Cc: devicetree-discuss@lists.ozlabs.org, john.williams@petalogix.com,
        linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de
Subject: Re: [PATCH] uio/pdrv_genirq: Add OF support
Message-ID: <20110331164348.GI26709@ponder.secretlab.ca>
References: <1301574600-4861-1-git-send-email-monstr@monstr.eu>
 <1301574600-4861-2-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301574600-4861-2-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 02:30:00PM +0200, Michal Simek wrote:
> Support OF support. "generic-uio" compatible property is used.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  drivers/uio/uio_pdrv_genirq.c |   60 ++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 57 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index 7174d51..9e89806 100644
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
> @@ -92,11 +96,44 @@ static int uio_pdrv_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
>  static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  {
>  	struct uio_info *uioinfo = pdev->dev.platform_data;
> -	struct uio_pdrv_genirq_platdata *priv;
> +	struct uio_pdrv_genirq_platdata *priv = NULL;
>  	struct uio_mem *uiomem;
>  	int ret = -EINVAL;
>  	int i;
>  
> +	if (!uioinfo) {
> +		struct resource r_irq; /* Interrupt resources */
> +		int rc = 0;
> +
> +		rc = of_address_to_resource(pdev->dev.of_node, 0,
> +							&pdev->resource[0]);
> +		if (rc) {
> +			dev_err(&pdev->dev, "invalid address\n");
> +			goto bad2;
> +		}
> +		pdev->num_resources = 1;

You shouldn't need this anymore.  Device tree sourced platform_devices
get their resource table populated automatically.  Also, drivers
should /never/ modify the resource values set in the device because it
messes up driver rebinding.

> +
> +		/* alloc uioinfo for one device */
> +		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
> +		if (!uioinfo) {
> +			ret = -ENOMEM;
> +			dev_err(&pdev->dev, "unable to kmalloc\n");
> +			goto bad2;
> +		}
> +		uioinfo->name = pdev->dev.of_node->name;
> +		/* Use version for storing full IP name for identification */
> +		uioinfo->version = pdev->dev.of_node->full_name;

Comment on the binding: You should probably use the first entry in the
compatible list for the name of the device.  Node names should be
generic and usually they will say what a device does, but not what a
device actually /is/ (this is the Generic Names recommended practice).

Modern convention is to rely on the first compatible entry for
describing what ip block it is.


> +
> +		/* Get IRQ for the device */
> +		rc = of_irq_to_resource(pdev->dev.of_node, 0, &r_irq);

Ditto here, the pdev should already have the irq resource populated.

> +		if (rc == NO_IRQ)
> +			dev_err(&pdev->dev, "no IRQ found\n");
> +		else {
> +			uioinfo->irq = r_irq.start;
> +			dev_info(&pdev->dev, "irq %d\n", (u32)uioinfo->irq);
> +		}
> +	}
> +
>  	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
>  		dev_err(&pdev->dev, "missing platform_data\n");
>  		goto bad0;
> @@ -176,10 +213,15 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, priv);
>  	return 0;
> - bad1:
> +
> +bad1:
>  	kfree(priv);
>  	pm_runtime_disable(&pdev->dev);
> - bad0:
> +bad0:
> +	/* kfree uioinfo for CONFIG_OF */
> +	if (!pdev->dev.platform_data)
> +		kfree(uioinfo);
> +bad2:
>  	return ret;
>  }
>  
> @@ -215,6 +257,17 @@ static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
>  	.runtime_resume = uio_pdrv_genirq_runtime_nop,
>  };
>  
> +#ifdef CONFIG_OF
> +/* Match table for of_platform binding */
> +static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
> +	{ .compatible = "generic-uio", },
> +	{ /* end of list */ },
> +};
> +MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
> +#else
> +# define uio_of_genirq_match NULL
> +#endif
> +
>  static struct platform_driver uio_pdrv_genirq = {
>  	.probe = uio_pdrv_genirq_probe,
>  	.remove = uio_pdrv_genirq_remove,
> @@ -222,6 +275,7 @@ static struct platform_driver uio_pdrv_genirq = {
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
