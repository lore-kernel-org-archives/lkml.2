Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab2LHVm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 16:42:29 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:57635 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758211Ab2LHVm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 16:42:27 -0500
Message-ID: <1355002958.14981.11.camel@gitbox>
Subject: Re: [PATCH] drivers/video/wm8505fb.c: use devm_ functions
From: Tony Prisk <linux@prisktech.co.nz>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: linux-fbdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Date: Sun, 09 Dec 2012 10:42:38 +1300
In-Reply-To: <1354984288-773-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1354984288-773-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-08 at 17:31 +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The various devm_ functions allocate memory that is released when a driver
> detaches.  This patch uses these functions for data that is allocated in
> the probe function of a platform device and is only freed in the remove
> function.
> 
> The patch makes some other cleanups.  First, the original code used
> devm_kzalloc, but kfree.  This would lead to a double free.  The problem
> was found using the following semantic match (http://coccinelle.lip6.fr/):
> 
> // <smpl>
> @@
> expression x,e;
> @@
> x = devm_kzalloc(...)
> ... when != x = e
> ?-kfree(x,...);
> // </smpl>
> 
> The error-handling code for the call to dma_alloc_coherent is copied to the
> end of the function, like the other error-handling code.  Given the
> introduction of the devm functions, this is just for uniformity, because
> the label at the end of the function now just returns the error code.
> 
> A semicolon is removed at the end of this error handling code.
> 
> The call platform_set_drvdata(pdev, NULL); is moved up under the label
> failed_free_cmap, because platform_set_drvdata(pdev, fbi); doesn't happen
> in the function until after gotos to this label are reached.
> 
> The initializations of fbi and ret are not necessary and are removed.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/video/wm8505fb.c |   44 ++++++++------------------------------------
>  1 file changed, 8 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
> index 77539c1..3bad805 100644
> --- a/drivers/video/wm8505fb.c
> +++ b/drivers/video/wm8505fb.c
> @@ -274,9 +274,6 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
>  	unsigned long fb_mem_len;
>  	void *fb_mem_virt;
>  
> -	ret = -ENOMEM;
> -	fbi = NULL;
> -
>  	fbi = devm_kzalloc(&pdev->dev, sizeof(struct wm8505fb_info) +
>  			sizeof(u32) * 16, GFP_KERNEL);
>  	if (!fbi) {
> @@ -308,31 +305,19 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
>  	fbi->fb.pseudo_palette	= addr;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (res == NULL) {
> -		dev_err(&pdev->dev, "no I/O memory resource defined\n");
> -		ret = -ENODEV;
> -		goto failed_fbi;
> -	}
> -
> -	res = request_mem_region(res->start, resource_size(res), DRIVER_NAME);
> -	if (res == NULL) {
> -		dev_err(&pdev->dev, "failed to request I/O memory\n");
> -		ret = -EBUSY;
> -		goto failed_fbi;
> -	}
>  
> -	fbi->regbase = ioremap(res->start, resource_size(res));
> +	fbi->regbase = devm_request_and_ioremap(&pdev->dev, res);
>  	if (fbi->regbase == NULL) {
>  		dev_err(&pdev->dev, "failed to map I/O memory\n");
>  		ret = -EBUSY;
> -		goto failed_free_res;
> +		goto failed;
>  	}
>  
>  	np = of_parse_phandle(pdev->dev.of_node, "default-mode", 0);
>  	if (!np) {
>  		pr_err("%s: No display description in Device Tree\n", __func__);
>  		ret = -EINVAL;
> -		goto failed_free_res;
> +		goto failed;
>  	}
>  
>  	/*
> @@ -351,7 +336,7 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
>  	ret |= of_property_read_u32(np, "bpp", &bpp);
>  	if (ret) {
>  		pr_err("%s: Unable to read display properties\n", __func__);
> -		goto failed_free_res;
> +		goto failed;
>  	}
>  
>  	of_mode.vmode = FB_VMODE_NONINTERLACED;
> @@ -369,8 +354,9 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
>  				GFP_KERNEL);
>  	if (!fb_mem_virt) {
>  		pr_err("%s: Failed to allocate framebuffer\n", __func__);
> -		return -ENOMEM;
> -	};
> +		ret = -ENOMEM;
> +		goto failed;
> +	}
>  
>  	fbi->fb.var.xres_virtual	= of_mode.xres;
>  	fbi->fb.var.yres_virtual	= of_mode.yres * 2;
> @@ -384,7 +370,7 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
>  	if (fb_alloc_cmap(&fbi->fb.cmap, 256, 0) < 0) {
>  		dev_err(&pdev->dev, "Failed to allocate color map\n");
>  		ret = -ENOMEM;
> -		goto failed_free_io;
> +		goto failed;
>  	}
>  
>  	wm8505fb_init_hw(&fbi->fb);
> @@ -420,13 +406,7 @@ static int __devinit wm8505fb_probe(struct platform_device *pdev)
>  failed_free_cmap:
>  	if (fbi->fb.cmap.len)
>  		fb_dealloc_cmap(&fbi->fb.cmap);
> -failed_free_io:
> -	iounmap(fbi->regbase);
> -failed_free_res:
> -	release_mem_region(res->start, resource_size(res));
> -failed_fbi:
>  	platform_set_drvdata(pdev, NULL);
> -	kfree(fbi);
>  failed:
>  	return ret;
>  }
> @@ -434,7 +414,6 @@ failed:
>  static int __devexit wm8505fb_remove(struct platform_device *pdev)
>  {
>  	struct wm8505fb_info *fbi = platform_get_drvdata(pdev);
> -	struct resource *res;
>  
>  	device_remove_file(&pdev->dev, &dev_attr_contrast);
>  
> @@ -445,13 +424,6 @@ static int __devexit wm8505fb_remove(struct platform_device *pdev)
>  	if (fbi->fb.cmap.len)
>  		fb_dealloc_cmap(&fbi->fb.cmap);
>  
> -	iounmap(fbi->regbase);
> -
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	release_mem_region(res->start, resource_size(res));
> -
> -	kfree(fbi);
> -
>  	return 0;
>  }
>  
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

Julia,

Thanks for the cleanup on this driver. Perhaps I could suggest just one
additional thing.

There are only two paths which lead to failed_free_cmap. Moving

...
	fbi->contrast = 0x80;
	ret = wm8505fb_set_par(&fbi->fb);
	if (ret) {
		dev_err(&pdev->dev, "Failed to set parameters\n");
		goto failed_free_cmap;
	}
...

above the following line removes the need to have the failed_free_cmap
path at all.

...
if (fb_alloc_cmap(&fbi->fb.cmap, 256, 0) < 0) {
...



If that is done, only this code leads to the failed_free_cmap path:
...
ret = register_framebuffer(&fbi->fb);
	if (ret < 0) {
		dev_err(&pdev->dev,
			"Failed to register framebuffer device: %d\n", ret);
		goto failed_free_cmap;
	}
...


Rather than the goto, add the fail path code in directly, and return.


ret = register_framebuffer(&fbi->fb);
if (ret < 0) {
  dev_err(&pdev->dev,
  "Failed to register framebuffer device: %d\n", ret);
  if (fbi->fb.cmap.len)
    fb_dealloc_cmap(&fbi->fb.cmap);
  return ret;
}

Now there is no need for any goto commands, and all the rest can be
replaced with 'return ret' or equiv.


Regards
Tony P

