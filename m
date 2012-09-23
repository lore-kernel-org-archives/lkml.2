Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab2IWTo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 15:44:58 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35388 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754155Ab2IWTo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 15:44:57 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1++3axD9+e+sc6p1x80UxSKwIfjqnVPtO9dkS1sn8
	+UjQrJMlplR/0I
Message-ID: <505F66AF.7000200@gmx.de>
Date: Sun, 23 Sep 2012 19:44:47 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Damien Cassou <damien.cassou@lifl.fr>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbdev: jz4740: Use devm_request_and_ioremap
References: <1347205121-5551-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1347205121-5551-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2012 03:38 PM, Lars-Peter Clausen wrote:
> Use devm_request_and_ioremap instead of request_mem_region + devm_ioremap.
> 
> This also fixes the following compile error introduced in commit b2ca7f4d
> ("drivers/video/jz4740_fb.c: use devm_ functions"):
> 
> drivers/video/jz4740_fb.c: In function 'jzfb_probe':
> 	drivers/video/jz4740_fb.c:676:2: error: implicit declaration of function 'devm_ioremap'
> 	drivers/video/jz4740_fb.c:676:13: warning: assignment makes pointer from integer without a cast
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Applied. Thanks for pointing this out and fixing it.


Best regards,

Florian Tobias Schandinat

> ---
>  drivers/video/jz4740_fb.c |   24 +++---------------------
>  1 files changed, 3 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/video/jz4740_fb.c b/drivers/video/jz4740_fb.c
> index 7669770..b0df279 100644
> --- a/drivers/video/jz4740_fb.c
> +++ b/drivers/video/jz4740_fb.c
> @@ -632,23 +632,10 @@ static int __devinit jzfb_probe(struct platform_device *pdev)
>  		return -ENXIO;
>  	}
>  
> -	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!mem) {
> -		dev_err(&pdev->dev, "Failed to get register memory resource\n");
> -		return -ENXIO;
> -	}
> -
> -	mem = request_mem_region(mem->start, resource_size(mem), pdev->name);
> -	if (!mem) {
> -		dev_err(&pdev->dev, "Failed to request register memory region\n");
> -		return -EBUSY;
> -	}
> -
>  	fb = framebuffer_alloc(sizeof(struct jzfb), &pdev->dev);
>  	if (!fb) {
>  		dev_err(&pdev->dev, "Failed to allocate framebuffer device\n");
> -		ret = -ENOMEM;
> -		goto err_release_mem_region;
> +		return -ENOMEM;
>  	}
>  
>  	fb->fbops = &jzfb_ops;
> @@ -657,7 +644,6 @@ static int __devinit jzfb_probe(struct platform_device *pdev)
>  	jzfb = fb->par;
>  	jzfb->pdev = pdev;
>  	jzfb->pdata = pdata;
> -	jzfb->mem = mem;
>  
>  	jzfb->ldclk = devm_clk_get(&pdev->dev, "lcd");
>  	if (IS_ERR(jzfb->ldclk)) {
> @@ -673,9 +659,9 @@ static int __devinit jzfb_probe(struct platform_device *pdev)
>  		goto err_framebuffer_release;
>  	}
>  
> -	jzfb->base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	jzfb->base = devm_request_and_ioremap(&pdev->dev, mem);
>  	if (!jzfb->base) {
> -		dev_err(&pdev->dev, "Failed to ioremap register memory region\n");
>  		ret = -EBUSY;
>  		goto err_framebuffer_release;
>  	}
> @@ -736,8 +722,6 @@ err_free_devmem:
>  	jzfb_free_devmem(jzfb);
>  err_framebuffer_release:
>  	framebuffer_release(fb);
> -err_release_mem_region:
> -	release_mem_region(mem->start, resource_size(mem));
>  	return ret;
>  }
>  
> @@ -750,8 +734,6 @@ static int __devexit jzfb_remove(struct platform_device *pdev)
>  	jz_gpio_bulk_free(jz_lcd_ctrl_pins, jzfb_num_ctrl_pins(jzfb));
>  	jz_gpio_bulk_free(jz_lcd_data_pins, jzfb_num_data_pins(jzfb));
>  
> -	release_mem_region(jzfb->mem->start, resource_size(jzfb->mem));
> -
>  	fb_dealloc_cmap(&jzfb->fb->cmap);
>  	jzfb_free_devmem(jzfb);
>  

