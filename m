Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934328Ab2HWUlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:41:12 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:34546 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934288Ab2HWUlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:41:08 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18pgNBIKb4pZAxn2kiVWWXtIxqR+IcCafP2Ggnavo
	Ry9/ACZFxddlq6
Message-ID: <5036955F.6000806@gmx.de>
Date: Thu, 23 Aug 2012 20:41:03 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Damien Cassou <damien.cassou@lifl.fr>
CC: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] drivers/video/jz4740_fb.c: use devm_ functions
References: <1344008414-2894-1-git-send-email-damien.cassou@lifl.fr> <1344008414-2894-3-git-send-email-damien.cassou@lifl.fr>
In-Reply-To: <1344008414-2894-3-git-send-email-damien.cassou@lifl.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 03:40 PM, Damien Cassou wrote:
> From: Damien Cassou <damien.cassou@lifl.fr>
> 
> The various devm_ functions allocate memory that is released when a driver
> detaches. This patch uses these functions for data that is allocated in the
> probe function of a platform device and is only freed in the remove function.
> 
> Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>

Applied.


Thanks,

Florian Tobias Schandinat

> 
> ---
>  drivers/video/jz4740_fb.c |   22 ++++++----------------
>  1 file changed, 6 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/video/jz4740_fb.c b/drivers/video/jz4740_fb.c
> index de36693..7669770 100644
> --- a/drivers/video/jz4740_fb.c
> +++ b/drivers/video/jz4740_fb.c
> @@ -659,25 +659,25 @@ static int __devinit jzfb_probe(struct platform_device *pdev)
>  	jzfb->pdata = pdata;
>  	jzfb->mem = mem;
> 
> -	jzfb->ldclk = clk_get(&pdev->dev, "lcd");
> +	jzfb->ldclk = devm_clk_get(&pdev->dev, "lcd");
>  	if (IS_ERR(jzfb->ldclk)) {
>  		ret = PTR_ERR(jzfb->ldclk);
>  		dev_err(&pdev->dev, "Failed to get lcd clock: %d\n", ret);
>  		goto err_framebuffer_release;
>  	}
> 
> -	jzfb->lpclk = clk_get(&pdev->dev, "lcd_pclk");
> +	jzfb->lpclk = devm_clk_get(&pdev->dev, "lcd_pclk");
>  	if (IS_ERR(jzfb->lpclk)) {
>  		ret = PTR_ERR(jzfb->lpclk);
>  		dev_err(&pdev->dev, "Failed to get lcd pixel clock: %d\n", ret);
> -		goto err_put_ldclk;
> +		goto err_framebuffer_release;
>  	}
> 
> -	jzfb->base = ioremap(mem->start, resource_size(mem));
> +	jzfb->base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
>  	if (!jzfb->base) {
>  		dev_err(&pdev->dev, "Failed to ioremap register memory region\n");
>  		ret = -EBUSY;
> -		goto err_put_lpclk;
> +		goto err_framebuffer_release;
>  	}
> 
>  	platform_set_drvdata(pdev, jzfb);
> @@ -693,7 +693,7 @@ static int __devinit jzfb_probe(struct platform_device *pdev)
>  	ret = jzfb_alloc_devmem(jzfb);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to allocate video memory\n");
> -		goto err_iounmap;
> +		goto err_framebuffer_release;
>  	}
> 
>  	fb->fix = jzfb_fix;
> @@ -734,12 +734,6 @@ err_free_devmem:
> 
>  	fb_dealloc_cmap(&fb->cmap);
>  	jzfb_free_devmem(jzfb);
> -err_iounmap:
> -	iounmap(jzfb->base);
> -err_put_lpclk:
> -	clk_put(jzfb->lpclk);
> -err_put_ldclk:
> -	clk_put(jzfb->ldclk);
>  err_framebuffer_release:
>  	framebuffer_release(fb);
>  err_release_mem_region:
> @@ -756,7 +750,6 @@ static int __devexit jzfb_remove(struct platform_device *pdev)
>  	jz_gpio_bulk_free(jz_lcd_ctrl_pins, jzfb_num_ctrl_pins(jzfb));
>  	jz_gpio_bulk_free(jz_lcd_data_pins, jzfb_num_data_pins(jzfb));
> 
> -	iounmap(jzfb->base);
>  	release_mem_region(jzfb->mem->start, resource_size(jzfb->mem));
> 
>  	fb_dealloc_cmap(&jzfb->fb->cmap);
> @@ -764,9 +757,6 @@ static int __devexit jzfb_remove(struct platform_device *pdev)
> 
>  	platform_set_drvdata(pdev, NULL);
> 
> -	clk_put(jzfb->lpclk);
> -	clk_put(jzfb->ldclk);
> -
>  	framebuffer_release(jzfb->fb);
> 
>  	return 0;
> 

