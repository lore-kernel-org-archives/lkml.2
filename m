Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab2GHWCi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 18:02:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40497 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752382Ab2GHWCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 18:02:37 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19lVFVq1vFlAGKflb2wZta2xCUfxDDSl9bKkZqdXY
	ftBfxUGZDVyGiT
Message-ID: <4FFA0380.2050006@gmx.de>
Date: Sun, 08 Jul 2012 22:02:40 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Emil Goode <emilgoode@gmail.com>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] grvga: Fix error handling issues
References: <1340663852-11719-1-git-send-email-emilgoode@gmail.com>
In-Reply-To: <1340663852-11719-1-git-send-email-emilgoode@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 10:37 PM, Emil Goode wrote:
> This patch fixes two problems with the error handling in the
> grvga_probe function and simplifies it making the code
> easier to read.
> 
> - If the call to grvga_parse_custom on line 370 fails we use
>   the wrong label so that release_mem_region will be called
>   without a call to request_mem_region being made.
> 
> - If the call to ioremap on line 436 fails we should not try
>   to call iounmap in the error handling code.
> 
> This patch introduces the following changes:
> 
> - Converts request_mem_region into its devm_ equivalent
>   which simplifies the otherwise messy clean up code.
> 
> - Changes the labels for correct error handling and their
>   names to make the code easier to read.
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
> v2: Simplifies the error handling by converting to
>     devm_request_mem_region
> 
>  drivers/video/grvga.c |   47 ++++++++++++++++++++++-------------------------
>  1 file changed, 22 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/video/grvga.c b/drivers/video/grvga.c
> index da066c2..5245f9a 100644
> --- a/drivers/video/grvga.c
> +++ b/drivers/video/grvga.c
> @@ -354,7 +354,7 @@ static int __devinit grvga_probe(struct platform_device *dev)
>  	 */
>  	if (fb_get_options("grvga", &options)) {
>  		retval = -ENODEV;
> -		goto err;
> +		goto free_fb;
>  	}
>  
>  	if (!options || !*options)
> @@ -370,7 +370,7 @@ static int __devinit grvga_probe(struct platform_device *dev)
>  			if (grvga_parse_custom(this_opt, &info->var) < 0) {
>  				dev_err(&dev->dev, "Failed to parse custom mode (%s).\n", this_opt);
>  				retval = -EINVAL;
> -				goto err1;
> +				goto free_fb;
>  			}
>  		} else if (!strncmp(this_opt, "addr", 4))
>  			grvga_fix_addr = simple_strtoul(this_opt + 5, NULL, 16);
> @@ -387,10 +387,11 @@ static int __devinit grvga_probe(struct platform_device *dev)
>  	info->flags = FBINFO_DEFAULT | FBINFO_PARTIAL_PAN_OK | FBINFO_HWACCEL_YPAN;
>  	info->fix.smem_len = grvga_mem_size;
>  
> -	if (!request_mem_region(dev->resource[0].start, resource_size(&dev->resource[0]), "grlib-svgactrl regs")) {
> +	if (!devm_request_mem_region(&dev->dev, dev->resource[0].start,
> +		    resource_size(&dev->resource[0]), "grlib-svgactrl regs")) {
>  		dev_err(&dev->dev, "registers already mapped\n");
>  		retval = -EBUSY;
> -		goto err;
> +		goto free_fb;
>  	}
>  
>  	par->regs = of_ioremap(&dev->resource[0], 0,
> @@ -400,14 +401,14 @@ static int __devinit grvga_probe(struct platform_device *dev)
>  	if (!par->regs) {
>  		dev_err(&dev->dev, "failed to map registers\n");
>  		retval = -ENOMEM;
> -		goto err1;
> +		goto free_fb;
>  	}
>  
>  	retval = fb_alloc_cmap(&info->cmap, 256, 0);
>  	if (retval < 0) {
>  		dev_err(&dev->dev, "failed to allocate mem with fb_alloc_cmap\n");
>  		retval = -ENOMEM;
> -		goto err2;
> +		goto unmap_regs;
>  	}
>  
>  	if (mode_opt) {
> @@ -415,7 +416,7 @@ static int __devinit grvga_probe(struct platform_device *dev)
>  				      grvga_modedb, sizeof(grvga_modedb), &grvga_modedb[0], 8);
>  		if (!retval || retval == 4) {
>  			retval = -EINVAL;
> -			goto err3;
> +			goto dealloc_cmap;
>  		}
>  	}
>  
> @@ -427,10 +428,11 @@ static int __devinit grvga_probe(struct platform_device *dev)
>  
>  		physical_start = grvga_fix_addr;
>  
> -		if (!request_mem_region(physical_start, grvga_mem_size, dev->name)) {
> +		if (!devm_request_mem_region(&dev->dev, physical_start,
> +					     grvga_mem_size, dev->name)) {
>  			dev_err(&dev->dev, "failed to request memory region\n");
>  			retval = -ENOMEM;
> -			goto err3;
> +			goto dealloc_cmap;
>  		}
>  
>  		virtual_start = (unsigned long) ioremap(physical_start, grvga_mem_size);
> @@ -438,7 +440,7 @@ static int __devinit grvga_probe(struct platform_device *dev)
>  		if (!virtual_start) {
>  			dev_err(&dev->dev, "error mapping framebuffer memory\n");
>  			retval = -ENOMEM;
> -			goto err4;
> +			goto dealloc_cmap;
>  		}
>  	} else {	/* Allocate frambuffer memory */
>  
> @@ -451,7 +453,7 @@ static int __devinit grvga_probe(struct platform_device *dev)
>  				"unable to allocate framebuffer memory (%lu bytes)\n",
>  				grvga_mem_size);
>  			retval = -ENOMEM;
> -			goto err3;
> +			goto dealloc_cmap;
>  		}
>  
>  		physical_start = dma_map_single(&dev->dev, (void *)virtual_start, grvga_mem_size, DMA_TO_DEVICE);
> @@ -484,7 +486,7 @@ static int __devinit grvga_probe(struct platform_device *dev)
>  	retval = register_framebuffer(info);
>  	if (retval < 0) {
>  		dev_err(&dev->dev, "failed to register framebuffer\n");
> -		goto err4;
> +		goto free_mem;
>  	}
>  
>  	__raw_writel(physical_start, &par->regs->fb_pos);
> @@ -493,21 +495,18 @@ static int __devinit grvga_probe(struct platform_device *dev)
>  
>  	return 0;
>  
> -err4:
> +free_mem:
>  	dev_set_drvdata(&dev->dev, NULL);
> -	if (grvga_fix_addr) {
> -		release_mem_region(physical_start, grvga_mem_size);
> +	if (grvga_fix_addr)
>  		iounmap((void *)virtual_start);
> -	} else
> +	else
>  		kfree((void *)virtual_start);
> -err3:
> +dealloc_cmap:
>  	fb_dealloc_cmap(&info->cmap);
> -err2:
> +unmap_regs:
>  	of_iounmap(&dev->resource[0], par->regs,
>  		   resource_size(&dev->resource[0]));
> -err1:
> -	release_mem_region(dev->resource[0].start, resource_size(&dev->resource[0]));
> -err:
> +free_fb:
>  	framebuffer_release(info);
>  
>  	return retval;
> @@ -524,12 +523,10 @@ static int __devexit grvga_remove(struct platform_device *device)
>  
>  		of_iounmap(&device->resource[0], par->regs,
>  			   resource_size(&device->resource[0]));
> -		release_mem_region(device->resource[0].start, resource_size(&device->resource[0]));
>  
> -		if (!par->fb_alloced) {
> -			release_mem_region(info->fix.smem_start, info->fix.smem_len);
> +		if (!par->fb_alloced)
>  			iounmap(info->screen_base);
> -		} else
> +		else
>  			kfree((void *)info->screen_base);
>  
>  		framebuffer_release(info);

