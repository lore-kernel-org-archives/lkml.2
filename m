Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab2KHQin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 11:38:43 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61147 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363Ab2KHQil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 11:38:41 -0500
Date: Thu, 8 Nov 2012 08:38:35 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Subject: Re: [PATCH 1/3] input: spear-keyboard: Use devm_*() routines
Message-ID: <20121108163835.GA8877@core.coreip.homeip.net>
References: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Thu, Nov 08, 2012 at 07:10:47PM +0530, Viresh Kumar wrote:
> This patch frees spear-keyboard driver from tension of freeing resources :)
> devm_* derivatives of multiple routines are used while allocating resources,
> which would be freed automatically by kernel.

It also breaks the error unwinding/removal of the driver as it frees
input device while IRQ handler is still active.

I will push the patch which implements devm_input_allocate_device() to
my 'next' branch in a few, please use it because it will make sure input
device will stick around long enough.

Also below.

> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/input/keyboard/spear-keyboard.c | 37 +++++++++++----------------------
>  1 file changed, 12 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/input/keyboard/spear-keyboard.c b/drivers/input/keyboard/spear-keyboard.c
> index c7ca97f..1d24fb2 100644
> --- a/drivers/input/keyboard/spear-keyboard.c
> +++ b/drivers/input/keyboard/spear-keyboard.c
> @@ -203,7 +203,7 @@ static int __devinit spear_kbd_probe(struct platform_device *pdev)
>  		return irq;
>  	}
>  
> -	kbd = kzalloc(sizeof(*kbd), GFP_KERNEL);
> +	kbd = devm_kzalloc(&pdev->dev, sizeof(*kbd), GFP_KERNEL);
>  	input_dev = input_allocate_device();
>  	if (!kbd || !input_dev) {
>  		dev_err(&pdev->dev, "out of memory\n");
> @@ -224,25 +224,25 @@ static int __devinit spear_kbd_probe(struct platform_device *pdev)
>  		kbd->suspended_rate = pdata->suspended_rate;
>  	}
>  
> -	kbd->res = request_mem_region(res->start, resource_size(res),
> -				      pdev->name);
> +	kbd->res = devm_request_mem_region(&pdev->dev, res->start,
> +			resource_size(res), pdev->name);
>  	if (!kbd->res) {
>  		dev_err(&pdev->dev, "keyboard region already claimed\n");
>  		error = -EBUSY;
>  		goto err_free_mem;
>  	}
>  
> -	kbd->io_base = ioremap(res->start, resource_size(res));
> +	kbd->io_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));

There is devm_request_and_ioremap() which you can use here.

>  	if (!kbd->io_base) {
>  		dev_err(&pdev->dev, "ioremap failed for kbd_region\n");
>  		error = -ENOMEM;
> -		goto err_release_mem_region;
> +		goto err_free_mem;
>  	}
>  
> -	kbd->clk = clk_get(&pdev->dev, NULL);
> +	kbd->clk = devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(kbd->clk)) {
>  		error = PTR_ERR(kbd->clk);
> -		goto err_iounmap;
> +		goto err_free_mem;
>  	}
>  
>  	input_dev->name = "Spear Keyboard";
> @@ -259,7 +259,7 @@ static int __devinit spear_kbd_probe(struct platform_device *pdev)
>  					   kbd->keycodes, input_dev);
>  	if (error) {
>  		dev_err(&pdev->dev, "Failed to build keymap\n");
> -		goto err_put_clk;
> +		goto err_free_mem;
>  	}
>  
>  	if (kbd->rep)
> @@ -268,16 +268,17 @@ static int __devinit spear_kbd_probe(struct platform_device *pdev)
>  
>  	input_set_drvdata(input_dev, kbd);
>  
> -	error = request_irq(irq, spear_kbd_interrupt, 0, "keyboard", kbd);
> +	error = devm_request_irq(&pdev->dev, irq, spear_kbd_interrupt, 0,
> +			"keyboard", kbd);
>  	if (error) {
>  		dev_err(&pdev->dev, "request_irq fail\n");
> -		goto err_put_clk;
> +		goto err_free_mem;
>  	}
>  
>  	error = input_register_device(input_dev);
>  	if (error) {
>  		dev_err(&pdev->dev, "Unable to register keyboard device\n");
> -		goto err_free_irq;
> +		goto err_free_mem;
>  	}
>  
>  	device_init_wakeup(&pdev->dev, 1);
> @@ -285,17 +286,8 @@ static int __devinit spear_kbd_probe(struct platform_device *pdev)
>  
>  	return 0;
>  
> -err_free_irq:
> -	free_irq(kbd->irq, kbd);
> -err_put_clk:
> -	clk_put(kbd->clk);
> -err_iounmap:
> -	iounmap(kbd->io_base);
> -err_release_mem_region:
> -	release_mem_region(res->start, resource_size(res));
>  err_free_mem:
>  	input_free_device(input_dev);
> -	kfree(kbd);
>  
>  	return error;
>  }
> @@ -304,12 +296,7 @@ static int __devexit spear_kbd_remove(struct platform_device *pdev)
>  {
>  	struct spear_kbd *kbd = platform_get_drvdata(pdev);
>  
> -	free_irq(kbd->irq, kbd);
>  	input_unregister_device(kbd->input);
> -	clk_put(kbd->clk);
> -	iounmap(kbd->io_base);
> -	release_mem_region(kbd->res->start, resource_size(kbd->res));
> -	kfree(kbd);
>  
>  	device_init_wakeup(&pdev->dev, 0);
>  	platform_set_drvdata(pdev, NULL);
> -- 
> 1.7.12.rc2.18.g61b472e
> 

Thanks.

-- 
Dmitry
