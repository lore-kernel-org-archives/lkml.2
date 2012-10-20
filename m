Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab2JTGkR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 02:40:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55049 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab2JTGkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 02:40:15 -0400
Message-ID: <5082473D.9080306@ti.com>
Date: Sat, 20 Oct 2012 12:09:57 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: <mchehab@infradead.org>, <laurent.pinchart@ideasonboard.com>,
        <manjunath.hadli@ti.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux-davincidsp.com>
Subject: Re: [PATCH] media:davinci: clk - {prepare/unprepare} for common clk
 framework
References: <1350670341-18982-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1350670341-18982-1-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Murali,

On Friday 19 October 2012 11:42 PM, Murali Karicheri wrote:
> As a first step towards migrating davinci platforms to use common clock
> framework, replace all instances of clk_enable() with clk_prepare_enable()
> and clk_disable() with clk_disable_unprepare().
> 
> Also fixes some issues related to clk clean up in the driver
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>  drivers/media/video/davinci/dm355_ccdc.c  |    8 ++++++--
>  drivers/media/video/davinci/dm644x_ccdc.c |   16 ++++++++++------
>  drivers/media/video/davinci/isif.c        |    5 ++++-
>  drivers/media/video/davinci/vpbe.c        |   10 +++++++---
>  drivers/media/video/davinci/vpif.c        |    8 ++++----
>  5 files changed, 31 insertions(+), 16 deletions(-)
> 
Thanks for the patch. Can you rebase this patch on 3.7, Since
the folder structure for media drivers has been reorganised.
And for some reason this patch hasn't reached any mailing list.

Thanks And Regards,
--Prabhakar Lad

> diff --git a/drivers/media/video/davinci/dm355_ccdc.c b/drivers/media/video/davinci/dm355_ccdc.c
> index 5b68847..af88cce 100644
> --- a/drivers/media/video/davinci/dm355_ccdc.c
> +++ b/drivers/media/video/davinci/dm355_ccdc.c
> @@ -1003,7 +1003,7 @@ static int __init dm355_ccdc_probe(struct platform_device *pdev)
>  		status = PTR_ERR(ccdc_cfg.mclk);
>  		goto fail_nomap;
>  	}
> -	if (clk_enable(ccdc_cfg.mclk)) {
> +	if (clk_prepare_enable(ccdc_cfg.mclk)) {
>  		status = -ENODEV;
>  		goto fail_mclk;
>  	}
> @@ -1014,7 +1014,7 @@ static int __init dm355_ccdc_probe(struct platform_device *pdev)
>  		status = PTR_ERR(ccdc_cfg.sclk);
>  		goto fail_mclk;
>  	}
> -	if (clk_enable(ccdc_cfg.sclk)) {
> +	if (clk_prepare_enable(ccdc_cfg.sclk)) {
>  		status = -ENODEV;
>  		goto fail_sclk;
>  	}
> @@ -1034,8 +1034,10 @@ static int __init dm355_ccdc_probe(struct platform_device *pdev)
>  	printk(KERN_NOTICE "%s is registered with vpfe.\n", ccdc_hw_dev.name);
>  	return 0;
>  fail_sclk:
> +	clk_disable_unprepare(ccdc_cfg.sclk);
>  	clk_put(ccdc_cfg.sclk);
>  fail_mclk:
> +	clk_disable_unprepare(ccdc_cfg.mclk);
>  	clk_put(ccdc_cfg.mclk);
>  fail_nomap:
>  	iounmap(ccdc_cfg.base_addr);
> @@ -1050,6 +1052,8 @@ static int dm355_ccdc_remove(struct platform_device *pdev)
>  {
>  	struct resource	*res;
>  
> +	clk_disable_unprepare(ccdc_cfg.sclk);
> +	clk_disable_unprepare(ccdc_cfg.mclk);
>  	clk_put(ccdc_cfg.mclk);
>  	clk_put(ccdc_cfg.sclk);
>  	iounmap(ccdc_cfg.base_addr);
> diff --git a/drivers/media/video/davinci/dm644x_ccdc.c b/drivers/media/video/davinci/dm644x_ccdc.c
> index 9303fe5..24388fa 100644
> --- a/drivers/media/video/davinci/dm644x_ccdc.c
> +++ b/drivers/media/video/davinci/dm644x_ccdc.c
> @@ -994,7 +994,7 @@ static int __init dm644x_ccdc_probe(struct platform_device *pdev)
>  		status = PTR_ERR(ccdc_cfg.mclk);
>  		goto fail_nomap;
>  	}
> -	if (clk_enable(ccdc_cfg.mclk)) {
> +	if (clk_prepare_enable(ccdc_cfg.mclk)) {
>  		status = -ENODEV;
>  		goto fail_mclk;
>  	}
> @@ -1005,7 +1005,7 @@ static int __init dm644x_ccdc_probe(struct platform_device *pdev)
>  		status = PTR_ERR(ccdc_cfg.sclk);
>  		goto fail_mclk;
>  	}
> -	if (clk_enable(ccdc_cfg.sclk)) {
> +	if (clk_prepare_enable(ccdc_cfg.sclk)) {
>  		status = -ENODEV;
>  		goto fail_sclk;
>  	}
> @@ -1013,8 +1013,10 @@ static int __init dm644x_ccdc_probe(struct platform_device *pdev)
>  	printk(KERN_NOTICE "%s is registered with vpfe.\n", ccdc_hw_dev.name);
>  	return 0;
>  fail_sclk:
> +	clk_disable_unprepare(ccdc_cfg.sclk);
>  	clk_put(ccdc_cfg.sclk);
>  fail_mclk:
> +	clk_disable_unprepare(ccdc_cfg.mclk);
>  	clk_put(ccdc_cfg.mclk);
>  fail_nomap:
>  	iounmap(ccdc_cfg.base_addr);
> @@ -1029,6 +1031,8 @@ static int dm644x_ccdc_remove(struct platform_device *pdev)
>  {
>  	struct resource	*res;
>  
> +	clk_disable_unprepare(ccdc_cfg.mclk);
> +	clk_disable_unprepare(ccdc_cfg.sclk);
>  	clk_put(ccdc_cfg.mclk);
>  	clk_put(ccdc_cfg.sclk);
>  	iounmap(ccdc_cfg.base_addr);
> @@ -1046,8 +1050,8 @@ static int dm644x_ccdc_suspend(struct device *dev)
>  	/* Disable CCDC */
>  	ccdc_enable(0);
>  	/* Disable both master and slave clock */
> -	clk_disable(ccdc_cfg.mclk);
> -	clk_disable(ccdc_cfg.sclk);
> +	clk_disable_unprepare(ccdc_cfg.mclk);
> +	clk_disable_unprepare(ccdc_cfg.sclk);
>  
>  	return 0;
>  }
> @@ -1055,8 +1059,8 @@ static int dm644x_ccdc_suspend(struct device *dev)
>  static int dm644x_ccdc_resume(struct device *dev)
>  {
>  	/* Enable both master and slave clock */
> -	clk_enable(ccdc_cfg.mclk);
> -	clk_enable(ccdc_cfg.sclk);
> +	clk_prepare_enable(ccdc_cfg.mclk);
> +	clk_prepare_enable(ccdc_cfg.sclk);
>  	/* Restore CCDC context */
>  	ccdc_restore_context();
>  
> diff --git a/drivers/media/video/davinci/isif.c b/drivers/media/video/davinci/isif.c
> index 5278fe7..d9c3116 100644
> --- a/drivers/media/video/davinci/isif.c
> +++ b/drivers/media/video/davinci/isif.c
> @@ -1053,7 +1053,7 @@ static int __init isif_probe(struct platform_device *pdev)
>  		status = PTR_ERR(isif_cfg.mclk);
>  		goto fail_mclk;
>  	}
> -	if (clk_enable(isif_cfg.mclk)) {
> +	if (clk_prepare_enable(isif_cfg.mclk)) {
>  		status = -ENODEV;
>  		goto fail_mclk;
>  	}
> @@ -1125,6 +1125,7 @@ fail_nobase_res:
>  		i--;
>  	}
>  fail_mclk:
> +	clk_disable_unprepare(isif_cfg.mclk);
>  	clk_put(isif_cfg.mclk);
>  	vpfe_unregister_ccdc_device(&isif_hw_dev);
>  	return status;
> @@ -1145,6 +1146,8 @@ static int isif_remove(struct platform_device *pdev)
>  		i++;
>  	}
>  	vpfe_unregister_ccdc_device(&isif_hw_dev);
> +	clk_disable_unprepare(isif_cfg.mclk);
> +	clk_put(isif_cfg.mclk);
>  	return 0;
>  }
>  
> diff --git a/drivers/media/video/davinci/vpbe.c b/drivers/media/video/davinci/vpbe.c
> index c4a82a1..7cfbc1e 100644
> --- a/drivers/media/video/davinci/vpbe.c
> +++ b/drivers/media/video/davinci/vpbe.c
> @@ -628,7 +628,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
>  			ret =  PTR_ERR(vpbe_dev->dac_clk);
>  			goto vpbe_unlock;
>  		}
> -		if (clk_enable(vpbe_dev->dac_clk)) {
> +		if (clk_prepare_enable(vpbe_dev->dac_clk)) {
>  			ret =  -ENODEV;
>  			goto vpbe_unlock;
>  		}
> @@ -777,8 +777,10 @@ vpbe_fail_sd_register:
>  vpbe_fail_v4l2_device:
>  	v4l2_device_unregister(&vpbe_dev->v4l2_dev);
>  vpbe_fail_clock:
> -	if (strcmp(vpbe_dev->cfg->module_name, "dm644x-vpbe-display") != 0)
> +	if (strcmp(vpbe_dev->cfg->module_name, "dm644x-vpbe-display") != 0) {
> +		clk_disable_unprepare(vpbe_dev->dac_clk);
>  		clk_put(vpbe_dev->dac_clk);
> +	}
>  vpbe_unlock:
>  	mutex_unlock(&vpbe_dev->lock);
>  	return ret;
> @@ -795,8 +797,10 @@ vpbe_unlock:
>  static void vpbe_deinitialize(struct device *dev, struct vpbe_device *vpbe_dev)
>  {
>  	v4l2_device_unregister(&vpbe_dev->v4l2_dev);
> -	if (strcmp(vpbe_dev->cfg->module_name, "dm644x-vpbe-display") != 0)
> +	if (strcmp(vpbe_dev->cfg->module_name, "dm644x-vpbe-display") != 0) {
> +		clk_disable_unprepare(vpbe_dev->dac_clk);
>  		clk_put(vpbe_dev->dac_clk);
> +	}
>  
>  	kfree(vpbe_dev->amp);
>  	kfree(vpbe_dev->encoders);
> diff --git a/drivers/media/video/davinci/vpif.c b/drivers/media/video/davinci/vpif.c
> index b3637af..2857ced 100644
> --- a/drivers/media/video/davinci/vpif.c
> +++ b/drivers/media/video/davinci/vpif.c
> @@ -442,7 +442,7 @@ static int __init vpif_probe(struct platform_device *pdev)
>  		status = PTR_ERR(vpif_clk);
>  		goto clk_fail;
>  	}
> -	clk_enable(vpif_clk);
> +	clk_prepare_enable(vpif_clk);
>  
>  	spin_lock_init(&vpif_lock);
>  	dev_info(&pdev->dev, "vpif probe success\n");
> @@ -458,7 +458,7 @@ fail:
>  static int __devexit vpif_remove(struct platform_device *pdev)
>  {
>  	if (vpif_clk) {
> -		clk_disable(vpif_clk);
> +		clk_disable_unprepare(vpif_clk);
>  		clk_put(vpif_clk);
>  	}
>  
> @@ -470,13 +470,13 @@ static int __devexit vpif_remove(struct platform_device *pdev)
>  #ifdef CONFIG_PM
>  static int vpif_suspend(struct device *dev)
>  {
> -	clk_disable(vpif_clk);
> +	clk_disable_unprepare(vpif_clk);
>  	return 0;
>  }
>  
>  static int vpif_resume(struct device *dev)
>  {
> -	clk_enable(vpif_clk);
> +	clk_prepare_enable(vpif_clk);
>  	return 0;
>  }
>  
> 

