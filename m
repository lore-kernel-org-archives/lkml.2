Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab2HaL2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 07:28:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:32808 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2HaL2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 07:28:52 -0400
Date: Fri, 31 Aug 2012 06:28:45 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
        HACHIMI Samir <shachimi@adeneo-embedded.com>,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 9/9] pwm i.MX: add devicetree support
Message-ID: <20120830222843.GE3613@r65073-Latitude-D630>
References: <1346154504-5623-1-git-send-email-s.hauer@pengutronix.de>
 <1346154504-5623-10-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346154504-5623-10-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shouldn't this patch be merged into #5?  Also, a binding doc should
be added.

Regards,
Shawn

On Tue, Aug 28, 2012 at 01:48:24PM +0200, Sascha Hauer wrote:
> From: Philipp Zabel <p.zabel@pengutronix.de>
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/pwm/pwm-imx.c |   25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
> index 308ab51..dce2acb 100644
> --- a/drivers/pwm/pwm-imx.c
> +++ b/drivers/pwm/pwm-imx.c
> @@ -206,9 +206,25 @@ static struct pwm_ops imx_pwm_ops = {
>  	.owner = THIS_MODULE,
>  };
>  
> +struct imx_pwm_data {
> +	int (*config)(struct pwm_chip *chip,
> +		struct pwm_device *pwm, int duty_ns, int period_ns);
> +	void (*set_enable)(struct pwm_chip *chip, bool enable);
> +};
> +
> +static struct imx_pwm_data imx_pwm_data_v1 = {
> +	.config = imx_pwm_config_v1,
> +	.set_enable = imx_pwm_set_enable_v1,
> +};
> +
> +static struct imx_pwm_data imx_pwm_data_v2 = {
> +	.config = imx_pwm_config_v2,
> +	.set_enable = imx_pwm_set_enable_v2,
> +};
> +
>  static const struct of_device_id imx_pwm_dt_ids[] = {
> -	{ .compatible = "fsl,imx1-pwm", .data = &imx_pwm_config_v1, },
> -	{ .compatible = "fsl,imx27-pwm", .data = &imx_pwm_config_v2, },
> +	{ .compatible = "fsl,imx1-pwm", .data = &imx_pwm_data_v1, },
> +	{ .compatible = "fsl,imx27-pwm", .data = &imx_pwm_data_v2, },
>  	{ /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(of, imx_pwm_of_match);
> @@ -257,7 +273,9 @@ static int __devinit imx_pwm_probe(struct platform_device *pdev)
>  		return -EADDRNOTAVAIL;
>  
>  	if (of_id) {
> -		imx->config = of_id->data;
> +		struct imx_pwm_data *data = of_id->data;
> +		imx->config = data->config;
> +		imx->set_enable = data->set_enable;
>  	} else {
>  		if (cpu_is_mx1() || cpu_is_mx21()) {
>  			imx->config = imx_pwm_config_v1;
> @@ -290,6 +308,7 @@ static int __devexit imx_pwm_remove(struct platform_device *pdev)
>  static struct platform_driver imx_pwm_driver = {
>  	.driver		= {
>  		.name	= "mxc_pwm",
> +		.of_match_table = of_match_ptr(imx_pwm_dt_ids),
>  	},
>  	.probe		= imx_pwm_probe,
>  	.remove		= __devexit_p(imx_pwm_remove),
> -- 
> 1.7.10.4
> 
