Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab2F2QE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:04:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53335 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab2F2QEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:04:54 -0400
Message-ID: <4FEDD222.7050905@wwwdotorg.org>
Date: Fri, 29 Jun 2012 10:04:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1340976167-27298-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 07:22 AM, Alexandre Courbot wrote:
> Add support for an optional power regulator and enable/disable GPIO.
> This scheme is commonly used in embedded systems.

> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c

> -	dev_dbg(&pdev->dev, "got pwm for backlight\n");
> -

That seems like an unrelated change?

> @@ -231,6 +271,22 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>  	if (data->pwm_period_ns > 0)
>  		pwm_set_period(pb->pwm, data->pwm_period_ns);
>  
> +
> +	pb->power_reg = devm_regulator_get(&pdev->dev, "power");

There's an extra blank line there.

> +	if (IS_ERR(pb->power_reg))
> +		return PTR_ERR(pb->power_reg);
> +
> +	pb->enable_gpio = -EINVAL;
> +	if (data->use_enable_gpio) {
> +		ret = devm_gpio_request_one(&pdev->dev, data->enable_gpio,
> +				GPIOF_OUT_INIT_HIGH, "backlight_enable");
> +		if (ret)
> +			dev_warn(&pdev->dev,
> +				"error %d requesting control gpio\n", ret);

Shouldn't that be a hard error? If the user specified that some GPIO be
used, and the GPIO could not be requested, shouldn't the driver fail to
initialize?

> +		else
> +			pb->enable_gpio = data->enable_gpio;

Aside from that, this looks good to me.
