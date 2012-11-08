Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab2KHQ6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 11:58:25 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50199 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2KHQ6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 11:58:23 -0500
Message-ID: <509BE4AD.30701@wwwdotorg.org>
Date: Thu, 08 Nov 2012 09:58:21 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linus.walleij@linaro.org, grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] gpio: tegra: read output value when gpio is set in direction_out
References: <1352356047-24817-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1352356047-24817-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 11:27 PM, Laxman Dewangan wrote:
> Read the output value when gpio is set for the output mode for
> gpio_get_value(). Reading input value in direction out does not
> give correct value.

That's an unfortunate HW design, but oh well. Do you have any idea why
reading the input register doesn't work? If you look at the Tegra20 TRM,
page 666 figure 32 "SFIO/GPIO Pin Multiplexing Architecture", there's
not indication that the input path wouldn't work if the output path is
active. Perhaps the issue is in the GPIO module not the pinmux module?

> diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c

>  static int tegra_gpio_get(struct gpio_chip *chip, unsigned offset)
>  {
> +	int bit_val = BIT(GPIO_BIT(offset));
> +
> +	/* If gpio is in output mode then read from the out value */
> +	if (tegra_gpio_readl(GPIO_OE(offset)) & bit_val)
> +		return !!(tegra_gpio_readl(GPIO_OUT(offset)) & bit_val);
> +
>  	return (tegra_gpio_readl(GPIO_IN(offset)) >> GPIO_BIT(offset)) & 0x1;
>  }

Any chance of using the same kind of logic to isolate the bit value? One
branch above does !!(val & mask) and the other (val >> shift) & 1.
