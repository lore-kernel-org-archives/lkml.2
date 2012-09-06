Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab2IFS0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:26:41 -0400
Received: from zose-mta-11.w4a.fr ([178.33.204.86]:40731 "EHLO
	zose-mta11.web4all.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932373Ab2IFS0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:26:40 -0400
Date: Thu, 6 Sep 2012 20:31:58 +0200 (CEST)
From: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>,
        shawn guo <shawn.guo@linaro.org>,
        thierry reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <996111492.3799131.1346956318651.JavaMail.root@advansee.com>
In-Reply-To: <1346935695-25179-8-git-send-email-s.hauer@pengutronix.de>
Subject: Re: [PATCH 7/9] pwm i.MX: fix clock lookup
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [88.188.188.98]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Win)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 6, 2012 2:48:13 PM, Sascha Hauer wrote:
> 
> From: Philipp Zabel <p.zabel@pengutronix.de>
> 
> The i.MX pwm core has two clocks: The ipg clock and the ipg highfreq
> (peripheral) clock. The ipg clock has to be enabled for this hardware
> to work. The actual pwm output can either be driven by the ipg clock
> or the ipg highfreq. The ipg highfreq has the advantage that it runs
> even when the SoC is in low power modes.
> This patch requests both clocks and enables the ipg clock for
> accessing
> registers and the peripheral clock to actually turn on the pwm.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
> Reviewed-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
> ---
>  drivers/pwm/pwm-imx.c |   35 +++++++++++++++++++++++++++--------
>  1 file changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
> index ea4ab2c..d45d44f 100644
> --- a/drivers/pwm/pwm-imx.c
> +++ b/drivers/pwm/pwm-imx.c
> @@ -40,7 +40,8 @@
>  #define MX3_PWMCR_EN              (1 << 0)
>  
>  struct imx_chip {
> -	struct clk	*clk;
> +	struct clk	*clk_per;
> +	struct clk	*clk_ipg;
>  
>  	int		enabled;
>  	void __iomem	*mmio_base;
> @@ -105,7 +106,7 @@ static int imx_pwm_config_v2(struct pwm_chip
> *chip,
>  	unsigned long period_cycles, duty_cycles, prescale;
>  	u32 cr;
>  
> -	c = clk_get_rate(imx->clk);
> +	c = clk_get_rate(imx->clk_per);
>  	c = c * period_ns;
>  	do_div(c, 1000000000);
>  	period_cycles = c;
> @@ -160,8 +161,17 @@ static int imx_pwm_config(struct pwm_chip *chip,
>  		struct pwm_device *pwm, int duty_ns, int period_ns)
>  {
>  	struct imx_chip *imx = to_imx_chip(chip);
> +	int ret;
> +
> +	ret = clk_prepare_enable(imx->clk_ipg);
> +	if (ret)
> +		return ret;
>  
> -	return imx->config(chip, pwm, duty_ns, period_ns);
> +	ret = imx->config(chip, pwm, duty_ns, period_ns);
> +
> +	clk_disable_unprepare(imx->clk_ipg);
> +
> +	return ret;
>  }
>  
>  static int imx_pwm_enable(struct pwm_chip *chip, struct pwm_device
>  *pwm)
> @@ -169,7 +179,7 @@ static int imx_pwm_enable(struct pwm_chip *chip,
> struct pwm_device *pwm)
>  	struct imx_chip *imx = to_imx_chip(chip);
>  	int ret;
>  
> -	ret = clk_prepare_enable(imx->clk);
> +	ret = clk_prepare_enable(imx->clk_per);
>  	if (ret)
>  		return ret;

Have you tested that this actually works on i.MX53?

I have tested it successfully on i.MX35 (with a few additions to platform code).
But i.MX35 has a single bit controlling both PWM IPG and PER clock gates.

On i.MX53, there are 2 separate control bits for these. So, if ipg clk is
strictly required to access PWM registers, even if per clk is enabled, this code
should not work without adding

+	ret = clk_prepare_enable(imx->clk_ipg);
+	if (ret)
+		return ret;

and

+	clk_disable_unprepare(imx->clk_ipg);

around each call to set_enable().

>  
> @@ -186,7 +196,7 @@ static void imx_pwm_disable(struct pwm_chip
> *chip, struct pwm_device *pwm)
>  
>  	imx->set_enable(chip, false);
>  
> -	clk_disable_unprepare(imx->clk);
> +	clk_disable_unprepare(imx->clk_per);
>  	imx->enabled = 0;
>  }
>  
> @@ -238,10 +248,19 @@ static int __devinit imx_pwm_probe(struct
> platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	imx->clk = devm_clk_get(&pdev->dev, "pwm");
> +	imx->clk_per = devm_clk_get(&pdev->dev, "per");
> +	if (IS_ERR(imx->clk_per)) {
> +		dev_err(&pdev->dev, "getting per clock failed with %ld\n",
> +				PTR_ERR(imx->clk_per));
> +		return PTR_ERR(imx->clk_per);
> +	}
>  
> -	if (IS_ERR(imx->clk))
> -		return PTR_ERR(imx->clk);
> +	imx->clk_ipg = devm_clk_get(&pdev->dev, "ipg");
> +	if (IS_ERR(imx->clk_ipg)) {
> +		dev_err(&pdev->dev, "getting ipg clock failed with %ld\n",
> +				PTR_ERR(imx->clk_ipg));
> +		return PTR_ERR(imx->clk_ipg);
> +	}
>  
>  	imx->chip.ops = &imx_pwm_ops;
>  	imx->chip.dev = &pdev->dev;

Best regards,
Benoît
