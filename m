Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab1DSGIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:08:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57144 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab1DSGIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:08:19 -0400
Date: Tue, 19 Apr 2011 00:08:16 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Michal Simek <monstr@monstr.eu>
Cc: devicetree-discuss@lists.ozlabs.org, john.williams@petalogix.com,
        linux-kernel@vger.kernel.org, hjk@hansjkoch.de, w.sang@pengutronix.de,
        arnd@arndb.de
Subject: Re: [PATCH v3] uio/pdrv_genirq: Add OF support
Message-ID: <20110419060816.GA5252@ponder.secretlab.ca>
References: <1303116654-5042-1-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303116654-5042-1-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:50:54AM +0200, Michal Simek wrote:
> Adding OF binding to genirq.
> Version string is setup to the "devicetree".
> 
> Compatible string is not setup for now but you can add your
> custom compatible string to uio_of_genirq_match structure.
> 
> For example with "uio" compatible string:
> static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
> 	{ .compatible = "uio", },
> 	{ /* empty for now */ },
> };
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> 
> ---
> 
> v3: Fix irq binding
>     Use "devicetree" as version string
> 
> v2: Remove additional resource binding
>     Setup correct version string
>     Clear compatible string
> ---
>  drivers/uio/uio_pdrv_genirq.c |   42 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 42 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index 7174d51..c8d565a 100644
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
> @@ -97,6 +101,30 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
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
> +		if (irq < 0) {

PowerPC and x86 will return 0 for an unassigned IRQ, as will most platforms.

> +			uioinfo->irq = UIO_IRQ_NONE;
> +			dev_info(&pdev->dev, "no IRQ found\n");
> +		} else {
> +			uioinfo->irq = irq;
> +			dev_info(&pdev->dev, "irq %d\n", (u32)uioinfo->irq);
> +		}
> +	}
> +
>  	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
>  		dev_err(&pdev->dev, "missing platform_data\n");
>  		goto bad0;
> @@ -180,6 +208,10 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
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
> @@ -215,6 +247,15 @@ static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
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
> @@ -222,6 +263,7 @@ static struct platform_driver uio_pdrv_genirq = {
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
