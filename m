Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab3AII5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:57:04 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:36836 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab3AII5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:57:02 -0500
Date: Wed, 9 Jan 2013 08:56:56 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Steve Glendinning <steve.glendinning@shawell.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] net/smsc911x: Provide common clock functionality
Message-ID: <20130109085656.GC31678@gmail.com>
References: <1355937587-31730-1-git-send-email-lee.jones@linaro.org>
 <1355937587-31730-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355937587-31730-4-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012, Lee Jones wrote:

> Some platforms provide clocks which require enabling before the
> SMSC911x chip will power on. This patch uses the new common clk
> framework to do just that. If no clock is provided, it will just
> be ignored and the driver will continue to assume that no clock
> is required for the chip to run successfully.
> 
> Cc: Steve Glendinning <steve.glendinning@shawell.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/net/ethernet/smsc/smsc911x.c |   31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
> index 4616bf2..f6196cd 100644
> --- a/drivers/net/ethernet/smsc/smsc911x.c
> +++ b/drivers/net/ethernet/smsc/smsc911x.c
> @@ -33,6 +33,7 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
>  #include <linux/crc32.h>
> +#include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/errno.h>
>  #include <linux/etherdevice.h>
> @@ -144,6 +145,9 @@ struct smsc911x_data {
>  
>  	/* regulators */
>  	struct regulator_bulk_data supplies[SMSC911X_NUM_SUPPLIES];
> +
> +	/* clock */
> +	struct clk *clk;
>  };
>  
>  /* Easy access to information */
> @@ -369,7 +373,7 @@ out:
>  }
>  
>  /*
> - * enable resources, currently just regulators.
> + * enable regulator and clock resources.
>   */
>  static int smsc911x_enable_resources(struct platform_device *pdev)
>  {
> @@ -382,6 +386,13 @@ static int smsc911x_enable_resources(struct platform_device *pdev)
>  	if (ret)
>  		netdev_err(ndev, "failed to enable regulators %d\n",
>  				ret);
> +
> +	if (pdata->clk) {
> +		ret = clk_prepare_enable(pdata->clk);
> +		if (ret < 0)
> +			netdev_err(ndev, "failed to enable clock %d\n", ret);
> +	}
> +
>  	return ret;
>  }
>  
> @@ -396,6 +407,10 @@ static int smsc911x_disable_resources(struct platform_device *pdev)
>  
>  	ret = regulator_bulk_disable(ARRAY_SIZE(pdata->supplies),
>  			pdata->supplies);
> +
> +	if (pdata->clk)
> +		clk_disable_unprepare(pdata->clk);
> +
>  	return ret;
>  }
>  
> @@ -421,6 +436,14 @@ static int smsc911x_request_resources(struct platform_device *pdev)
>  	if (ret)
>  		netdev_err(ndev, "couldn't get regulators %d\n",
>  				ret);
> +
> +	/* Request clock */
> +	pdata->clk = clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(pdata->clk)) {
> +		netdev_warn(ndev, "couldn't get clock %d\n", PTR_ERR(pdata->clk));
> +		pdata->clk = NULL;
> +	}
> +
>  	return ret;
>  }
>  
> @@ -436,6 +459,12 @@ static void smsc911x_free_resources(struct platform_device *pdev)
>  	/* Free regulators */
>  	regulator_bulk_free(ARRAY_SIZE(pdata->supplies),
>  			pdata->supplies);
> +
> +	/* Free clock */
> +	if (pdata->clk) {
> +		clk_put(pdata->clk);
> +		pdata->clk = NULL;
> +	}
>  }
>  
>  /* waits for MAC not busy, with timeout.  Only called by smsc911x_mac_read
> -- 
> 1.7.9.5
> 

I still need a maintiner Ack for this before I can push it.

Mike?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
