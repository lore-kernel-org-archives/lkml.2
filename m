Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2KIQrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:47:40 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53884 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab2KIQpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:45:08 -0500
Date: Fri, 9 Nov 2012 08:45:03 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Subject: Re: [PATCH 1/3] input: stmpe-keyboard: Use devm_*() routines
Message-ID: <20121109164503.GA17752@core.coreip.homeip.net>
References: <3d6f34ca5960203a5efb761f4d56b4e10ee24827.1352474824.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d6f34ca5960203a5efb761f4d56b4e10ee24827.1352474824.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Fri, Nov 09, 2012 at 08:57:48PM +0530, Viresh Kumar wrote:
> This patch frees stmpe-keyboard driver from tension of freeing resources :)
> devm_* derivatives of multiple routines are used while allocating resources,
> which would be freed automatically by kernel.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/input/keyboard/stmpe-keypad.c | 31 ++++++++++---------------------
>  1 file changed, 10 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/input/keyboard/stmpe-keypad.c b/drivers/input/keyboard/stmpe-keypad.c
> index 470a877..6e25497 100644
> --- a/drivers/input/keyboard/stmpe-keypad.c
> +++ b/drivers/input/keyboard/stmpe-keypad.c
> @@ -275,15 +275,14 @@ static int __devinit stmpe_keypad_probe(struct platform_device *pdev)
>  	if (irq < 0)
>  		return irq;
>  
> -	keypad = kzalloc(sizeof(struct stmpe_keypad), GFP_KERNEL);
> +	keypad = devm_kzalloc(&pdev->dev, sizeof(struct stmpe_keypad),
> +			GFP_KERNEL);
>  	if (!keypad)
>  		return -ENOMEM;
>  
> -	input = input_allocate_device();
> -	if (!input) {
> -		ret = -ENOMEM;
> -		goto out_freekeypad;
> -	}
> +	input = devm_input_allocate_device(&pdev->dev);
> +	if (!input)
> +		return -ENOMEM;
>  
>  	input->name = "STMPE keypad";
>  	input->id.bustype = BUS_I2C;
> @@ -294,7 +293,7 @@ static int __devinit stmpe_keypad_probe(struct platform_device *pdev)
>  					 STMPE_KEYPAD_MAX_COLS,
>  					 keypad->keymap, input);
>  	if (ret)
> -		goto out_freeinput;
> +		return ret;
>  
>  	input_set_capability(input, EV_MSC, MSC_SCAN);
>  	if (!plat->no_autorepeat)
> @@ -314,17 +313,17 @@ static int __devinit stmpe_keypad_probe(struct platform_device *pdev)
>  
>  	ret = stmpe_keypad_chip_init(keypad);
>  	if (ret < 0)
> -		goto out_freeinput;
> +		return ret;
>  
>  	ret = input_register_device(input);
>  	if (ret) {
>  		dev_err(&pdev->dev,
>  			"unable to register input device: %d\n", ret);
> -		goto out_freeinput;
> +		return ret;
>  	}
>  
> -	ret = request_threaded_irq(irq, NULL, stmpe_keypad_irq, IRQF_ONESHOT,
> -				   "stmpe-keypad", keypad);
> +	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL, stmpe_keypad_irq,
> +			IRQF_ONESHOT, "stmpe-keypad", keypad);
>  	if (ret) {
>  		dev_err(&pdev->dev, "unable to get irq: %d\n", ret);
>  		goto out_unregisterinput;
> @@ -336,11 +335,6 @@ static int __devinit stmpe_keypad_probe(struct platform_device *pdev)
>  
>  out_unregisterinput:
>  	input_unregister_device(input);

If input device was alocated with devm_* interface it does not need be
explicitly unregistered/freed.

Thanks.

-- 
Dmitry
