Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934241Ab2HWUi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:38:58 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:42562 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932284Ab2HWUix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:38:53 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/bgaFPtjrboUaJAoNleQ3IwIJiNnztCR7vVg64bY
	10Q9zZUgz9eG+J
Message-ID: <503694D7.9060407@gmx.de>
Date: Thu, 23 Aug 2012 20:38:47 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Damien Cassou <damien.cassou@gmail.com>
CC: Jingoo Han <jg1.han@samsung.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH v2] video: exynos_dp: use devm_clk_get function
References: <877gti1t48.fsf@gmail.com>
In-Reply-To: <877gti1t48.fsf@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 04:20 PM, Damien Cassou wrote:
> From: Damien Cassou <damien.cassou@lifl.fr>
> 
> The devm_clk_get function allocates memory that is released when a driver
> detaches. This patch uses this function for data that is allocated in the probe
> function of a platform device and is only freed in the remove function.
> 
> Additionally, this patch removes a null check after platform_get_resource that
> is redundant with the one done by devm_request_and_ioremap.
> 
> Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>

Applied.


Thanks,

Florian Tobias Schandinat

> 
> ---
> Changed subject line and description
>  drivers/video/exynos/exynos_dp_core.c |   27 +++++++--------------------
>  1 file changed, 7 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
> index c6c016a..00fe4f0 100644
> --- a/drivers/video/exynos/exynos_dp_core.c
> +++ b/drivers/video/exynos/exynos_dp_core.c
> @@ -872,7 +872,7 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
>  
>  	dp->dev = &pdev->dev;
>  
> -	dp->clock = clk_get(&pdev->dev, "dp");
> +	dp->clock = devm_clk_get(&pdev->dev, "dp");
>  	if (IS_ERR(dp->clock)) {
>  		dev_err(&pdev->dev, "failed to get clock\n");
>  		return PTR_ERR(dp->clock);
> @@ -881,31 +881,24 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
>  	clk_enable(dp->clock);
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "failed to get registers\n");
> -		ret = -EINVAL;
> -		goto err_clock;
> -	}
>  
>  	dp->reg_base = devm_request_and_ioremap(&pdev->dev, res);
>  	if (!dp->reg_base) {
>  		dev_err(&pdev->dev, "failed to ioremap\n");
> -		ret = -ENOMEM;
> -		goto err_clock;
> +		return -ENOMEM;
>  	}
>  
>  	dp->irq = platform_get_irq(pdev, 0);
>  	if (!dp->irq) {
>  		dev_err(&pdev->dev, "failed to get irq\n");
> -		ret = -ENODEV;
> -		goto err_clock;
> +		return -ENODEV;
>  	}
>  
>  	ret = devm_request_irq(&pdev->dev, dp->irq, exynos_dp_irq_handler, 0,
>  				"exynos-dp", dp);
>  	if (ret) {
>  		dev_err(&pdev->dev, "failed to request irq\n");
> -		goto err_clock;
> +		return ret;
>  	}
>  
>  	dp->video_info = pdata->video_info;
> @@ -917,7 +910,7 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
>  	ret = exynos_dp_detect_hpd(dp);
>  	if (ret) {
>  		dev_err(&pdev->dev, "unable to detect hpd\n");
> -		goto err_clock;
> +		return ret;
>  	}
>  
>  	exynos_dp_handle_edid(dp);
> @@ -926,7 +919,7 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
>  				dp->video_info->link_rate);
>  	if (ret) {
>  		dev_err(&pdev->dev, "unable to do link train\n");
> -		goto err_clock;
> +		return ret;
>  	}
>  
>  	exynos_dp_enable_scramble(dp, 1);
> @@ -940,17 +933,12 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
>  	ret = exynos_dp_config_video(dp, dp->video_info);
>  	if (ret) {
>  		dev_err(&pdev->dev, "unable to config video\n");
> -		goto err_clock;
> +		return ret;
>  	}
>  
>  	platform_set_drvdata(pdev, dp);
>  
>  	return 0;
> -
> -err_clock:
> -	clk_put(dp->clock);
> -
> -	return ret;
>  }
>  
>  static int __devexit exynos_dp_remove(struct platform_device *pdev)
> @@ -962,7 +950,6 @@ static int __devexit exynos_dp_remove(struct platform_device *pdev)
>  		pdata->phy_exit();
>  
>  	clk_disable(dp->clock);
> -	clk_put(dp->clock);
>  
>  	return 0;
>  }
> 
> 

