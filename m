Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761207Ab2EIUoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:44:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37962 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761165Ab2EIUoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:44:21 -0400
Message-ID: <4FAAD721.3070101@wwwdotorg.org>
Date: Wed, 09 May 2012 14:44:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 06/12] pinctrl/nomadik: implement pin configuration
References: <1336470302-23670-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1336470302-23670-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 03:45 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This implements the pin configuration interface for the
> Nomadik pin controller.
> 
> As part of the exercise we add a bit in the pin_cfg_t for
> the Nomadik pinctrl driver that indicates if the pin should
> be forced into GPIO mode. This is not done to go behind the
> back of the GPIO subsystem, but to ensure that default modes
> can be set by hogs on boot and system suspend/resume states.
> It was used implicitly by the old code defining all config
> settings and modes in a single config word but we now have
> a split between pinmux and pinconf leading to the need to
> have this.

Yes, I have wondered if we should have always represented the
GPIO/pinctrl interaction as a pinctrl "function" of "GPIO. There are a
few gotchas that prevented me moving forward with this though:

1) On Tegra at least, GPIO-vs-pinmux is actually a bit in the GPIO
controller, so that mux is after the pinmux's output mux

2) I'm not sure how it'd work when you could mux "GPIO controller A GPIO
x" or "GPIO controller B pin y" onto the same pinctrl pin

3) On Tegra at least, special-function muxing is at a per-pingroup
level, but GPIO muxing is at a per-pin level. So much for regular HW:-(

> @@ -1561,7 +1562,8 @@ int nmk_gpio_request_enable(struct pinctrl_dev *pctldev,
>  
>  	clk_enable(nmk_chip->clk);
>  	bit = offset % NMK_GPIO_PER_CHIP;
> -	__nmk_gpio_set_mode_safe(nmk_chip, bit, NMK_GPIO_ALT_GPIO, false);
> +	/* There is no glitch when converting any pin to GPIO */
> +	__nmk_gpio_set_mode(nmk_chip, bit, NMK_GPIO_ALT_GPIO);

Was that meant to be squashed into some other earlier change?
