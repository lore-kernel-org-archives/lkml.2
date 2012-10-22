Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2JVPui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:50:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37636 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab2JVPuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:50:35 -0400
Date: Mon, 22 Oct 2012 08:50:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: tony@atomide.com, b-cousson@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121022155028.GA13791@core.coreip.homeip.net>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sourav,

On Mon, Oct 22, 2012 at 06:43:00PM +0530, Sourav Poddar wrote:
> Adapt keypad to use pinctrl framework.
> 
> Tested on omap4430 sdp with 3.7-rc1 kernel.

I do not see anything in the driver that would directly use pinctrl. Is
there a better place to select default pin configuration; maybe when
instantiating platform device?

Thanks.

> 
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> ---
> v1->v2
> - Added "PROBE_DEFER" check 
>  drivers/input/keyboard/omap4-keypad.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
> index c05f98c..502b832 100644
> --- a/drivers/input/keyboard/omap4-keypad.c
> +++ b/drivers/input/keyboard/omap4-keypad.c
> @@ -31,6 +31,7 @@
>  #include <linux/input.h>
>  #include <linux/slab.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/pinctrl/consumer.h>
>  
>  #include <linux/platform_data/omap4-keypad.h>
>  
> @@ -76,6 +77,7 @@ enum {
>  
>  struct omap4_keypad {
>  	struct input_dev *input;
> +	struct pinctrl	*pins;
>  
>  	void __iomem *base;
>  	unsigned int irq;
> @@ -298,6 +300,15 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
>  		goto err_release_mem;
>  	}
>  
> +	keypad_data->pins = devm_pinctrl_get_select_default(&pdev->dev);
> +	if (IS_ERR(keypad_data->pins)) {
> +		if (PTR_ERR(keypad_data->pins) == -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +
> +		dev_warn(&pdev->dev, "did not get pins for keypad error: %li\n",
> +					PTR_ERR(keypad_data->pins));
> +		keypad_data->pins = NULL;
> +	}
>  
>  	/*
>  	 * Enable clocks for the keypad module so that we can read
> -- 
> 1.7.1
> 

-- 
Dmitry
