Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab2LMSOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:14:03 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:50694 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab2LMSOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:14:01 -0500
Date: Thu, 13 Dec 2012 19:13:54 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Cc: linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cong Ding <dinggnu@gmail.com>
Subject: Re: [PATCH 1/2 v3] Fix memory freeing issues
Message-ID: <20121213181354.GI4261@local>
References: <201212101118.08463.vitas@nppfactor.kiev.ua>
 <201212101144.45967.vitas@nppfactor.kiev.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201212101144.45967.vitas@nppfactor.kiev.ua>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 11:44:45AM +0200, Vitalii Demianets wrote:
> 1. uioinfo was kfreed based on the presence of pdev->dev.of_node, which was
> obviously wrong and unrelated to the fact if uioinfo was allocated statically
> or dynamically. This patch introduces new flag which clearly shows if uioinfo
> was allocated dynamically and kfrees uioinfo based on that flag;
> 2. Fix: priv data was not freed in case platform_get_irq() failed. As it was
> caused mainly by improper exit labels naming, labels were renamed too;
> 3. The case of uioinfo AND pdev->dev.of_node both NULL (not initialized
> in platform data) was not treated properly.
> 
> Signed-off-by: Vitalii Demianets <vitas@nppfactor.kiev.ua>
> ---
> v2: Constants naming style
> v3: Comments: better wording in comment accompanying flags initialization &
>  removed obsoleted OF comment

That comment is obsolete as well.

> 
> ---
>  drivers/uio/uio_pdrv_genirq.c |   47 ++++++++++++++++++++++++----------------
>  1 files changed, 28 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index 42202cd..cc5233b 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -30,6 +30,11 @@
>  
>  #define DRIVER_NAME "uio_pdrv_genirq"
>  
> +enum {
> +	UIO_IRQ_DISABLED = 0,
> +	UIO_INFO_ALLOCED = 1,
> +};

We don't need these flags.

> +
>  struct uio_pdrv_genirq_platdata {
>  	struct uio_info *uioinfo;
>  	spinlock_t lock;
> @@ -63,7 +68,7 @@ static irqreturn_t uio_pdrv_genirq_handler(int irq, struct uio_info *dev_info)
>  	 * remember the state so we can allow user space to enable it later.
>  	 */
>  
> -	if (!test_and_set_bit(0, &priv->flags))
> +	if (!test_and_set_bit(UIO_IRQ_DISABLED, &priv->flags))

Remove the "if" completely, we need to disable the irq unconditionally.

>  		disable_irq_nosync(irq);
>  
>  	return IRQ_HANDLED;
> @@ -83,10 +88,10 @@ static int uio_pdrv_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
>  
>  	spin_lock_irqsave(&priv->lock, flags);
>  	if (irq_on) {
> -		if (test_and_clear_bit(0, &priv->flags))
> +		if (test_and_clear_bit(UIO_IRQ_DISABLED, &priv->flags))
>  			enable_irq(dev_info->irq);
>  	} else {
> -		if (!test_and_set_bit(0, &priv->flags))
> +		if (!test_and_set_bit(UIO_IRQ_DISABLED, &priv->flags))
>  			disable_irq(dev_info->irq);

Same here: irqcontrol has to enable/disable the irq unconditionally.

>  	}
>  	spin_unlock_irqrestore(&priv->lock, flags);
> @@ -101,8 +106,9 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  	struct uio_mem *uiomem;
>  	int ret = -EINVAL;
>  	int i;
> +	bool uioinfo_alloced = false;
>  
> -	if (!uioinfo) {
> +	if (!uioinfo && pdev->dev.of_node) {
>  		int irq;
>  
>  		/* alloc uioinfo for one device */
> @@ -110,10 +116,11 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  		if (!uioinfo) {
>  			ret = -ENOMEM;
>  			dev_err(&pdev->dev, "unable to kmalloc\n");
> -			goto bad2;
> +			goto out;
>  		}
>  		uioinfo->name = pdev->dev.of_node->name;
>  		uioinfo->version = "devicetree";
> +		uioinfo_alloced = true;
>  
>  		/* Multiple IRQs are not supported */
>  		irq = platform_get_irq(pdev, 0);
> @@ -125,32 +132,35 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  
>  	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
>  		dev_err(&pdev->dev, "missing platform_data\n");
> -		goto bad0;
> +		goto out_uioinfo;
>  	}
>  
>  	if (uioinfo->handler || uioinfo->irqcontrol ||
>  	    uioinfo->irq_flags & IRQF_SHARED) {
>  		dev_err(&pdev->dev, "interrupt configuration error\n");
> -		goto bad0;
> +		goto out_uioinfo;
>  	}
>  
>  	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>  	if (!priv) {
>  		ret = -ENOMEM;
>  		dev_err(&pdev->dev, "unable to kmalloc\n");
> -		goto bad0;
> +		goto out_uioinfo;
>  	}
>  
>  	priv->uioinfo = uioinfo;
>  	spin_lock_init(&priv->lock);
> -	priv->flags = 0; /* interrupt is enabled to begin with */
> +	/* Interrupt is enabled to begin with,
> +	 * that's why UIO_IRQ_DISABLED flag is not initially set.
> +	 */
> +	priv->flags = uioinfo_alloced ? BIT_MASK(UIO_INFO_ALLOCED) : 0;
>  	priv->pdev = pdev;
>  
>  	if (!uioinfo->irq) {
>  		ret = platform_get_irq(pdev, 0);
>  		if (ret < 0) {
>  			dev_err(&pdev->dev, "failed to get IRQ\n");
> -			goto bad0;
> +			goto out_priv;
>  		}
>  		uioinfo->irq = ret;
>  	}
> @@ -205,19 +215,19 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  	ret = uio_register_device(&pdev->dev, priv->uioinfo);
>  	if (ret) {
>  		dev_err(&pdev->dev, "unable to register uio device\n");
> -		goto bad1;
> +		goto out_pm;
>  	}
>  
>  	platform_set_drvdata(pdev, priv);
>  	return 0;
> - bad1:
> -	kfree(priv);
> +out_pm:
>  	pm_runtime_disable(&pdev->dev);
> - bad0:
> -	/* kfree uioinfo for OF */
> -	if (pdev->dev.of_node)
> +out_priv:
> +	kfree(priv);
> +out_uioinfo:
> +	if (uioinfo_alloced)
>  		kfree(uioinfo);

why check that variable? kfree can handle NULL pointers very well.

> - bad2:
> +out:
>  	return ret;
>  }
>  
> @@ -231,8 +241,7 @@ static int uio_pdrv_genirq_remove(struct platform_device *pdev)
>  	priv->uioinfo->handler = NULL;
>  	priv->uioinfo->irqcontrol = NULL;
>  
> -	/* kfree uioinfo for OF */
> -	if (pdev->dev.of_node)
> +	if (test_bit(UIO_INFO_ALLOCED, &priv->flags))
>  		kfree(priv->uioinfo);
>  
>  	kfree(priv);
> -- 
> 1.7.8.6
> 
