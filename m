Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2JTQiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:38:17 -0400
Received: from relay.sigmatic.fi ([80.69.161.51]:60364 "EHLO relay.sigmatic.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab2JTQiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:38:16 -0400
Date: Sat, 20 Oct 2012 19:38:14 +0300
From: Hannu Heikkinen <hannuxx@iki.fi>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, davinci-linux-open-source@linux.davincidsp.com,
        nsekhar@ti.com
Subject: Re: [PATCH v3] rtc: davinci: clean up probe/remove routines
Message-ID: <20121020163814.GA1124@archyar.homehannu>
References: <1350207822-4857-1-git-send-email-hannuxx@iki.fi>
 <1350223426-5369-1-git-send-email-hannuxx@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350223426-5369-1-git-send-email-hannuxx@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sekhar and others, any comments regarding this devm patch for Da Vinci?

br,
Hannu

On 14/10/12 17:03 +0300, Hannu Heikkinen wrote:
> Use the devres managed resource functions in the probe routine.
> Also affects the remove routine where the previously used free and
> release functions are not needed.
> 
> The devm_* functions eliminate the need for manual resource releasing and
> simplify error handling.  Resources allocated by devm_* are freed
> automatically on driver detach.
> 
> Signed-off-by: Hannu Heikkinen <hannuxx@iki.fi>
> ---
>  drivers/rtc/rtc-davinci.c | 59 +++++++++++++----------------------------------
>  1 file changed, 16 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
> index 14c2109..4a10b4b 100644
> --- a/drivers/rtc/rtc-davinci.c
> +++ b/drivers/rtc/rtc-davinci.c
> @@ -119,8 +119,6 @@ static DEFINE_SPINLOCK(davinci_rtc_lock);
>  struct davinci_rtc {
>  	struct rtc_device 		*rtc;
>  	void __iomem			*base;
> -	resource_size_t			pbase;
> -	size_t				base_size;
>  	int				irq;
>  };
>  
> @@ -482,46 +480,32 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
>  	struct davinci_rtc *davinci_rtc;
> -	struct resource *res, *mem;
> +	struct resource *res;
>  	int ret = 0;
>  
> -	davinci_rtc = kzalloc(sizeof(struct davinci_rtc), GFP_KERNEL);
> +	davinci_rtc = devm_kzalloc(&pdev->dev, sizeof(struct davinci_rtc),
> +		GFP_KERNEL);
>  	if (!davinci_rtc) {
>  		dev_dbg(dev, "could not allocate memory for private data\n");
>  		return -ENOMEM;
>  	}
>  
> -	davinci_rtc->irq = platform_get_irq(pdev, 0);
> -	if (davinci_rtc->irq < 0) {
> -		dev_err(dev, "no RTC irq\n");
> -		ret = davinci_rtc->irq;
> -		goto fail1;
> -	}
> -
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res) {
>  		dev_err(dev, "no mem resource\n");
> -		ret = -EINVAL;
> -		goto fail1;
> +		return -EINVAL;
>  	}
>  
> -	davinci_rtc->pbase = res->start;
> -	davinci_rtc->base_size = resource_size(res);
> -
> -	mem = request_mem_region(davinci_rtc->pbase, davinci_rtc->base_size,
> -				 pdev->name);
> -	if (!mem) {
> -		dev_err(dev, "RTC registers at %08x are not free\n",
> -			davinci_rtc->pbase);
> -		ret = -EBUSY;
> -		goto fail1;
> +	davinci_rtc->base = devm_request_and_ioremap(&pdev->dev, res);
> +	if (!davinci_rtc->base) {
> +		dev_err(&pdev->dev, "Unable to request mem region and grab IOs for device.\n");
> +		return -EBUSY;
>  	}
>  
> -	davinci_rtc->base = ioremap(davinci_rtc->pbase, davinci_rtc->base_size);
> -	if (!davinci_rtc->base) {
> -		dev_err(dev, "unable to ioremap MEM resource\n");
> -		ret = -ENOMEM;
> -		goto fail2;
> +	davinci_rtc->irq = platform_get_irq(pdev, 0);
> +	if (davinci_rtc->irq < 0) {
> +		dev_err(dev, "no RTC irq\n");
> +		return davinci_rtc->irq;
>  	}
>  
>  	platform_set_drvdata(pdev, davinci_rtc);
> @@ -529,9 +513,10 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
>  	davinci_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
>  				    &davinci_rtc_ops, THIS_MODULE);
>  	if (IS_ERR(davinci_rtc->rtc)) {
> +		ret = PTR_ERR(davinci_rtc->rtc);
>  		dev_err(dev, "unable to register RTC device, err %ld\n",
>  				PTR_ERR(davinci_rtc->rtc));
> -		goto fail3;
> +		return ret;
>  	}
>  
>  	rtcif_write(davinci_rtc, PRTCIF_INTFLG_RTCSS, PRTCIF_INTFLG);
> @@ -545,7 +530,7 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
>  			  0, "davinci_rtc", davinci_rtc);
>  	if (ret < 0) {
>  		dev_err(dev, "unable to register davinci RTC interrupt\n");
> -		goto fail4;
> +		goto err_dev_unreg;
>  	}
>  
>  	/* Enable interrupts */
> @@ -559,15 +544,8 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
>  
>  	return 0;
>  
> -fail4:
> +err_dev_unreg:
>  	rtc_device_unregister(davinci_rtc->rtc);
> -fail3:
> -	platform_set_drvdata(pdev, NULL);
> -	iounmap(davinci_rtc->base);
> -fail2:
> -	release_mem_region(davinci_rtc->pbase, davinci_rtc->base_size);
> -fail1:
> -	kfree(davinci_rtc);
>  
>  	return ret;
>  }
> @@ -584,13 +562,8 @@ static int __devexit davinci_rtc_remove(struct platform_device *pdev)
>  
>  	rtc_device_unregister(davinci_rtc->rtc);
>  
> -	iounmap(davinci_rtc->base);
> -	release_mem_region(davinci_rtc->pbase, davinci_rtc->base_size);
> -
>  	platform_set_drvdata(pdev, NULL);
>  
> -	kfree(davinci_rtc);
> -
>  	return 0;
>  }
>  
> -- 
> 1.7.12.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
-------------------------------------
Hannu Heikkinen
+358 45 8862828
hannuxx@iki.fi
PGP: BE4D3EEB
PGP Key fingerprint C450 D8F0 85D7 66DC D48E  58E1 6C9A 5ECE BE4D 3EEB
-------------------------------------


