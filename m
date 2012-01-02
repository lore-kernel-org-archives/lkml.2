Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab2ABHeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 02:34:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52561 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2ABHeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 02:34:11 -0500
Date: Mon, 2 Jan 2012 00:34:06 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        rob.herring@calxeda.com, kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, patches@linaro.org
Subject: Re: [RFC][PATCH 4/4] lcd: platform-lcd: Add device tree support
Message-ID: <20120102073406.GG13015@ponder.secretlab.ca>
References: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>
 <1325483675-21908-2-git-send-email-thomas.abraham@linaro.org>
 <1325483675-21908-3-git-send-email-thomas.abraham@linaro.org>
 <1325483675-21908-4-git-send-email-thomas.abraham@linaro.org>
 <1325483675-21908-5-git-send-email-thomas.abraham@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325483675-21908-5-git-send-email-thomas.abraham@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 11:24:35AM +0530, Thomas Abraham wrote:
> Add device tree based initialization for Hydis hv070wsa lcd panel.
> 
> Cc: Ben Dooks <ben-linux@fluff.org>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> ---
>  drivers/video/backlight/platform_lcd.c |   33 ++++++++++++++++++++++++++++++++
>  1 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
> index feb4fd0..ebdddfd 100644
> --- a/drivers/video/backlight/platform_lcd.c
> +++ b/drivers/video/backlight/platform_lcd.c
> @@ -18,6 +18,8 @@
>  #include <linux/lcd.h>
>  #include <linux/slab.h>
>  #include <linux/gpio.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
>  
>  #include <video/platform_lcd.h>
>  
> @@ -81,9 +83,18 @@ static struct lcd_ops platform_lcd_ops = {
>  	.check_fb	= platform_lcd_match,
>  };
>  
> +static const struct of_device_id platform_lcd_dt_match[];
> +
>  static inline struct plat_lcd_driver_data *platform_lcd_get_driver_data(
>  			struct platform_device *pdev)
>  {
> +#ifdef CONFIG_OF
> +	if (pdev->dev.of_node) {
> +		const struct of_device_id *match;
> +		match = of_match_node(platform_lcd_dt_match, pdev->dev.of_node);
> +		return (struct plat_lcd_driver_data *)match->data;

.data is already void*; the cast should not be necessary.

> +	}
> +#endif
>  	return (struct plat_lcd_driver_data *)
>  			platform_get_device_id(pdev)->driver_data;
>  }
> @@ -167,6 +178,19 @@ static int lcd_hv070wsa_init(struct platform_lcd *plcd)
>  	struct plat_lcd_hydis_hv070wsa_pdata *pdata = plcd->lcd_pdata;
>  	int err;
>  
> +#ifdef CONFIG_OF
> +	if (of_have_populated_dt()) {
> +		plcd->lcd_pdata = devm_kzalloc(plcd->us,
> +						sizeof(*pdata), GFP_KERNEL);
> +		if (!plcd->lcd_pdata) {
> +			dev_err(plcd->us, "mem alloc for pdata failed\n");
> +			return -ENOMEM;
> +		}
> +		pdata = plcd->lcd_pdata;
> +		pdata->gpio = of_get_gpio(plcd->us->of_node, 0);
> +	}
> +#endif
> +
>  	if (!pdata) {
>  		dev_err(plcd->us, "no platform data\n");
>  		return -EINVAL;
> @@ -214,10 +238,19 @@ static struct platform_device_id platform_lcd_driver_ids[] = {
>  };
>  MODULE_DEVICE_TABLE(platform, platform_lcd_driver_ids);
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id platform_lcd_dt_match[] = {
> +	{ .compatible = "hydis,hv070wsa", .data = (void *)HV070WSA_DRV_DATA},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, platform_lcd_dt_match);
> +#endif
> +
>  static struct platform_driver platform_lcd_driver = {
>  	.driver		= {
>  		.name	= "platform-lcd",
>  		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(platform_lcd_dt_match),
>  	},
>  	.probe		= platform_lcd_probe,
>  	.remove		= __devexit_p(platform_lcd_remove),
> -- 
> 1.6.6.rc2
> 
