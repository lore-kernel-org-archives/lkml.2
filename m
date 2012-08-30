Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab2HaL1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 07:27:03 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45554 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab2HaL1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 07:27:01 -0400
Date: Fri, 31 Aug 2012 06:26:53 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
        HACHIMI Samir <shachimi@adeneo-embedded.com>,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 5/9] pwm i.MX: add devicetree support
Message-ID: <20120830222650.GD3613@r65073-Latitude-D630>
References: <1346154504-5623-1-git-send-email-s.hauer@pengutronix.de>
 <1346154504-5623-6-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346154504-5623-6-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 01:48:20PM +0200, Sascha Hauer wrote:
> From: Philipp Zabel <p.zabel@pengutronix.de>
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/pwm/pwm-imx.c |   25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
> index a689144..dfc1bae 100644
> --- a/drivers/pwm/pwm-imx.c
> +++ b/drivers/pwm/pwm-imx.c
> @@ -16,9 +16,9 @@
>  #include <linux/clk.h>
>  #include <linux/io.h>
>  #include <linux/pwm.h>
> +#include <linux/of_device.h>
>  #include <mach/hardware.h>
>  
> -
>  /* i.MX1 and i.MX21 share the same PWM function block: */
>  
>  #define MX1_PWMC    0x00   /* PWM Control Register */
> @@ -203,8 +203,17 @@ static struct pwm_ops imx_pwm_ops = {
>  	.owner = THIS_MODULE,
>  };
>  
> +static const struct of_device_id imx_pwm_dt_ids[] = {
> +	{ .compatible = "fsl,imx1-pwm", .data = &imx_pwm_config_v1, },
> +	{ .compatible = "fsl,imx27-pwm", .data = &imx_pwm_config_v2, },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, imx_pwm_of_match);

s/imx_pwm_of_match/imx_pwm_dt_ids

Regards,
Shawn

> +
>  static int __devinit imx_pwm_probe(struct platform_device *pdev)
>  {
> +	const struct of_device_id *of_id =
> +			of_match_device(imx_pwm_dt_ids, &pdev->dev);
>  	struct imx_chip *imx;
>  	struct resource *r;
>  	int ret = 0;
> @@ -235,12 +244,16 @@ static int __devinit imx_pwm_probe(struct platform_device *pdev)
>  	if (imx->mmio_base == NULL)
>  		return -EADDRNOTAVAIL;
>  
> -	if (cpu_is_mx1() || cpu_is_mx21()) {
> -		imx->config = imx_pwm_config_v1;
> -		imx->set_enable = imx_pwm_set_enable_v1;
> +	if (of_id) {
> +		imx->config = of_id->data;
>  	} else {
> -		imx->config = imx_pwm_config_v2;
> -		imx->set_enable = imx_pwm_set_enable_v2;
> +		if (cpu_is_mx1() || cpu_is_mx21()) {
> +			imx->config = imx_pwm_config_v1;
> +			imx->set_enable = imx_pwm_set_enable_v1;
> +		} else {
> +			imx->config = imx_pwm_config_v2;
> +			imx->set_enable = imx_pwm_set_enable_v2;
> +		}
>  	}
>  
>  	ret = pwmchip_add(&imx->chip);
> -- 
> 1.7.10.4
> 
