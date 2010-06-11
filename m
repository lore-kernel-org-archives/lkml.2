Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab0FKXMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 19:12:53 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34351 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab0FKXMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 19:12:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6010"; a="44205908"
Subject: Re: [PATCH 2/2] gpio: msm7200a: Add irq support to msm-gpiolib.
From: Daniel Walker <dwalker@codeaurora.org>
To: Gregory Bean <gbean@codeaurora.org>
Cc: akpm@linux-foundation.org, linux-arm-msm@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>
In-Reply-To: <1276286332-13515-3-git-send-email-gbean@codeaurora.org>
References: <1276286332-13515-1-git-send-email-gbean@codeaurora.org>
	 <1276286332-13515-3-git-send-email-gbean@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jun 2010 16:12:29 -0700
Message-ID: <1276297949.4134.3.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 12:58 -0700, Gregory Bean wrote:

>  static int msm_gpio_probe(struct platform_device *dev)
>  {
>  	struct msm_gpio_dev *msm_gpio;
>  	struct msm7200a_gpio_platform_data *pdata =
>  		(struct msm7200a_gpio_platform_data *)dev->dev.platform_data;
> -	int ret;
> +	int i, irq, ret;
>  
>  	if (!pdata)
>  		return -EINVAL;
> @@ -146,13 +306,53 @@ static int msm_gpio_probe(struct platform_device *dev)
>  	msm_gpio->gpio_chip.direction_output = gpio_chip_direction_output;
>  	msm_gpio->gpio_chip.get              = gpio_chip_get;
>  	msm_gpio->gpio_chip.set              = gpio_chip_set;
> +	msm_gpio->gpio_chip.to_irq           = gpio_chip_to_irq;
> +	msm_gpio->irq_base                   = pdata->irq_base;
> +	msm_gpio->irq_summary                = pdata->irq_summary;
>  
>  	ret = gpiochip_add(&msm_gpio->gpio_chip);
>  	if (ret < 0)
> -		goto err;
> +		goto err_post_malloc;
> +
> +	for (i = 0; i < msm_gpio->gpio_chip.ngpio; ++i) {
> +		irq = msm_gpio->irq_base + i;
> +		set_irq_chip_data(irq, msm_gpio);
> +		set_irq_chip(irq, &msm_gpio_irq_chip);
> +		set_irq_handler(irq, handle_level_irq);
> +		set_irq_flags(irq, IRQF_VALID);
> +	}
> +
> +	/*
> +	 * We use a level-triggered interrupt because of the nature
> +	 * of the shared GPIO-group interrupt.
> +	 *
> +	 * Many GPIO chips may be sharing the same group IRQ line, and
> +	 * it is possible for GPIO interrupt to re-occur while the system
> +	 * is still servicing the group interrupt associated with it.
> +	 * The group IRQ line would not de-assert and re-assert, and
> +	 * we'd get no second edge to cause the group IRQ to be handled again.
> +	 *
> +	 * Using a level interrupt guarantees that the group IRQ handlers
> +	 * will continue to be called as long as any GPIO chip in the group
> +	 * is asserting, even if the condition began while the group
> +	 * handler was in mid-pass.
> +	 */
> +	ret = request_irq(msm_gpio->irq_summary,
> +			  msm_gpio_irq_handler,
> +			  IRQF_SHARED | IRQF_TRIGGER_HIGH,
> +			  dev->name,
> +			  msm_gpio);
> +	if (ret < 0)
> +		goto err_post_gpiochip_add;
>  
>  	return ret;
> -err:
> +err_post_gpiochip_add:
> +	/*
> +	 * Under no circumstances should a line be held on a gpiochip
> +	 * which hasn't finished probing.
> +	 */
> +	BUG_ON(gpiochip_remove(&msm_gpio->gpio_chip) < 0);
> +err_post_malloc:

It looks like some of this should go in the prior patch. Like this
BUG_ON() above. 

>  	kfree(msm_gpio);
>  	return ret;
>  }
> @@ -160,12 +360,16 @@ err:
>  static int msm_gpio_remove(struct platform_device *dev)
>  {
>  	struct msm_gpio_dev *msm_gpio = platform_get_drvdata(dev);
> -	int ret = gpiochip_remove(&msm_gpio->gpio_chip);
> +	int ret;
>  
> -	if (ret == 0)
> -		kfree(msm_gpio);
> +	ret = gpiochip_remove(&msm_gpio->gpio_chip);
> +	if (ret < 0)
> +		return ret;
>  
> -	return ret;
> +	free_irq(msm_gpio->irq_summary, msm_gpio);
> +	kfree(msm_gpio);
> +
> +	return 0;
>  }

Also some of the code here (msm_gpio_remove) seems like it's cleaning up
the prior patch to some degree. So it should potentially get moved into
that patch.

Daniel

