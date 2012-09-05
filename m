Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600Ab2IEVhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:37:23 -0400
Received: from zose-mta11.web4all.fr ([178.33.204.87]:58728 "EHLO
	zose-mta11.web4all.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759553Ab2IEVhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:37:19 -0400
Date: Wed, 5 Sep 2012 23:42:34 +0200 (CEST)
From: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>,
        shawn guo <shawn.guo@linaro.org>,
        thierry reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <811985020.3713350.1346881354214.JavaMail.root@advansee.com>
In-Reply-To: <1346852127-25226-6-git-send-email-s.hauer@pengutronix.de>
Subject: Re: [PATCH 5/8] pwm i.MX: add devicetree support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [88.172.188.148]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Win)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 5, 2012 3:35:24 PM, Sascha Hauer wrote:
> 
> From: Philipp Zabel <p.zabel@pengutronix.de>
> 
> At the same time remove platform based support. No user for
> this driver has made it into mainline so far, so all we break
> is out of tree stuff.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  Documentation/devicetree/bindings/pwm/imx-pwm.txt |   17 ++++++++
>  drivers/pwm/pwm-imx.c                             |   45
>  ++++++++++++++++-----
>  2 files changed, 52 insertions(+), 10 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pwm/imx-pwm.txt
> 
> diff --git a/Documentation/devicetree/bindings/pwm/imx-pwm.txt
> b/Documentation/devicetree/bindings/pwm/imx-pwm.txt
> new file mode 100644
> index 0000000..9b9b185
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/imx-pwm.txt
> @@ -0,0 +1,17 @@
> +Freescale i.MX PWM controller
> +
> +Required properties:
> +- compatible: should be "fsl,<soc>-pwm"
> +- reg: physical base address and length of the controller's
> registers
> +- #pwm-cells: should be 2.  The first cell specifies the per-chip
> index
> +  of the PWM to use and the second cell is the duty cycle in
> nanoseconds.
> +- interrupts: The interrupt for the pwm controller
> +
> +Example:
> +
> +pwm1: pwm@53fb4000 {
> +	#pwm-cells = <2>;
> +	compatible = "fsl,imx53-pwm", "fsl,imx27-pwm";
> +	reg = <0x53fb4000 0x4000>;
> +	interrupts = <61>;
> +};
> diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
> index a689144..af77045 100644
> --- a/drivers/pwm/pwm-imx.c
> +++ b/drivers/pwm/pwm-imx.c
> @@ -16,8 +16,7 @@
>  #include <linux/clk.h>
>  #include <linux/io.h>
>  #include <linux/pwm.h>
> -#include <mach/hardware.h>
> -
> +#include <linux/of_device.h>
>  
>  /* i.MX1 and i.MX21 share the same PWM function block: */
>  
> @@ -203,12 +202,41 @@ static struct pwm_ops imx_pwm_ops = {
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
> +static const struct of_device_id imx_pwm_dt_ids[] = {
> +	{ .compatible = "fsl,imx1-pwm", .data = &imx_pwm_data_v1, },
> +	{ .compatible = "fsl,imx27-pwm", .data = &imx_pwm_data_v2, },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, imx_pwm_dt_ids);
> +
>  static int __devinit imx_pwm_probe(struct platform_device *pdev)
>  {
> +	const struct of_device_id *of_id =
> +			of_match_device(imx_pwm_dt_ids, &pdev->dev);
> +	struct imx_pwm_data *data;
>  	struct imx_chip *imx;
>  	struct resource *r;
>  	int ret = 0;
>  
> +	if (!of_id)
> +		return -ENODEV;
> +
>  	imx = devm_kzalloc(&pdev->dev, sizeof(*imx), GFP_KERNEL);
>  	if (imx == NULL) {
>  		dev_err(&pdev->dev, "failed to allocate memory\n");
> @@ -235,13 +263,9 @@ static int __devinit imx_pwm_probe(struct
> platform_device *pdev)
>  	if (imx->mmio_base == NULL)
>  		return -EADDRNOTAVAIL;
>  
> -	if (cpu_is_mx1() || cpu_is_mx21()) {
> -		imx->config = imx_pwm_config_v1;
> -		imx->set_enable = imx_pwm_set_enable_v1;
> -	} else {
> -		imx->config = imx_pwm_config_v2;
> -		imx->set_enable = imx_pwm_set_enable_v2;
> -	}
> +	data = of_id->data;
> +	imx->config = data->config;
> +	imx->set_enable = data->set_enable;
>  
>  	ret = pwmchip_add(&imx->chip);
>  	if (ret < 0)
> @@ -264,7 +288,8 @@ static int __devexit imx_pwm_remove(struct
> platform_device *pdev)
>  
>  static struct platform_driver imx_pwm_driver = {
>  	.driver		= {
> -		.name	= "mxc_pwm",
> +		.name	= "imx-pwm",
> +		.of_match_table = of_match_ptr(imx_pwm_dt_ids),
>  	},
>  	.probe		= imx_pwm_probe,
>  	.remove		= __devexit_p(imx_pwm_remove),

Since this is supposed to remove platform-based support, why don't you also
remove the PWM stuff from arch/arm/plat-mxc and
arch/arm/mach-imx/devices-imx*.h?

Best regards,
Benoît
