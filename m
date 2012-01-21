Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab2AUNxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 08:53:20 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:40413 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751756Ab2AUNxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 08:53:16 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18H3SskqOMHFbFfoVdUhc/Vunf5Nx6uUYVDWJp1+z
	Eg7M96s/ShzwAU
Message-ID: <4F1AC33E.90405@gmx.de>
Date: Sat, 21 Jan 2012 13:53:02 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>
Subject: Re: [PATCH 2/4] drivers/video/au*fb.c: use devm_ functions
References: <1327094732-9050-1-git-send-email-Julia.Lawall@lip6.fr> <1327094732-9050-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1327094732-9050-3-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC'ing Manuel Lauss as he knows those drivers better than I do]

On 01/20/2012 09:25 PM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The various devm_ functions allocate memory that is released when a driver
> detaches.  This patch uses these functions for data that is allocated in
> the probe function of a platform device and is only freed in the remove
> function.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> In the case of au1100fb.c, should the failed label return something other
> than 0?
> In the case of au1200fb.c, should the error-handling code under the new
> call to dma_alloc_noncoherent jump to failed, like the other error handling
> code?  I was not sure that there was actually anything for failed to do at
> this point in the function.

Maybe Manuel is able to answer these questions. I've queued this patch and if he
doesn't respond I'll apply it after some time.


Best regards,

Florian Tobias Schandinat

> 
>  drivers/video/au1100fb.c |   30 +++++++++++-------------------
>  drivers/video/au1200fb.c |    9 +--------
>  2 files changed, 12 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/video/au1100fb.c b/drivers/video/au1100fb.c
> index de9da67..8f7b7d7 100644
> --- a/drivers/video/au1100fb.c
> +++ b/drivers/video/au1100fb.c
> @@ -477,7 +477,8 @@ static int __devinit au1100fb_drv_probe(struct platform_device *dev)
>  	u32 sys_clksrc;
>  
>  	/* Allocate new device private */
> -	fbdev = kzalloc(sizeof(struct au1100fb_device), GFP_KERNEL);
> +	fbdev = devm_kzalloc(&dev->dev, sizeof(struct au1100fb_device),
> +			     GFP_KERNEL);
>  	if (!fbdev) {
>  		print_err("fail to allocate device private record");
>  		return -ENOMEM;
> @@ -498,8 +499,9 @@ static int __devinit au1100fb_drv_probe(struct platform_device *dev)
>  	au1100fb_fix.mmio_start = regs_res->start;
>  	au1100fb_fix.mmio_len = resource_size(regs_res);
>  
> -	if (!request_mem_region(au1100fb_fix.mmio_start, au1100fb_fix.mmio_len,
> -				DRIVER_NAME)) {
> +	if (!devm_request_mem_region(au1100fb_fix.mmio_start,
> +				     au1100fb_fix.mmio_len,
> +				     DRIVER_NAME)) {
>  		print_err("fail to lock memory region at 0x%08lx",
>  				au1100fb_fix.mmio_start);
>  		return -EBUSY;
> @@ -514,8 +516,9 @@ static int __devinit au1100fb_drv_probe(struct platform_device *dev)
>  	fbdev->fb_len = fbdev->panel->xres * fbdev->panel->yres *
>  		  	(fbdev->panel->bpp >> 3) * AU1100FB_NBR_VIDEO_BUFFERS;
>  
> -	fbdev->fb_mem = dma_alloc_coherent(&dev->dev, PAGE_ALIGN(fbdev->fb_len),
> -					&fbdev->fb_phys, GFP_KERNEL);
> +	fbdev->fb_mem = dmam_alloc_coherent(&dev->dev, &dev->dev,
> +					    PAGE_ALIGN(fbdev->fb_len),
> +					    &fbdev->fb_phys, GFP_KERNEL);
>  	if (!fbdev->fb_mem) {
>  		print_err("fail to allocate frambuffer (size: %dK))",
>  			  fbdev->fb_len / 1024);
> @@ -557,14 +560,14 @@ static int __devinit au1100fb_drv_probe(struct platform_device *dev)
>  	fbdev->info.fbops = &au1100fb_ops;
>  	fbdev->info.fix = au1100fb_fix;
>  
> -	if (!(fbdev->info.pseudo_palette = kzalloc(sizeof(u32) * 16, GFP_KERNEL))) {
> +	fbdev->info.pseudo_palette =
> +		devm_kzalloc(&dev->dev, sizeof(u32) * 16, GFP_KERNEL);
> +	if (!fbdev->info.pseudo_palette)
>  		return -ENOMEM;
> -	}
>  
>  	if (fb_alloc_cmap(&fbdev->info.cmap, AU1100_LCD_NBR_PALETTE_ENTRIES, 0) < 0) {
>  		print_err("Fail to allocate colormap (%d entries)",
>  			   AU1100_LCD_NBR_PALETTE_ENTRIES);
> -		kfree(fbdev->info.pseudo_palette);
>  		return -EFAULT;
>  	}
>  
> @@ -582,9 +585,6 @@ static int __devinit au1100fb_drv_probe(struct platform_device *dev)
>  	return 0;
>  
>  failed:
> -	if (fbdev->regs) {
> -		release_mem_region(fbdev->regs_phys, fbdev->regs_len);
> -	}
>  	if (fbdev->fb_mem) {
>  		dma_free_noncoherent(&dev->dev, fbdev->fb_len, fbdev->fb_mem,
>  				     fbdev->fb_phys);
> @@ -592,7 +592,6 @@ failed:
>  	if (fbdev->info.cmap.len != 0) {
>  		fb_dealloc_cmap(&fbdev->info.cmap);
>  	}
> -	kfree(fbdev);
>  	platform_set_drvdata(dev, NULL);
>  
>  	return 0;
> @@ -615,14 +614,7 @@ int au1100fb_drv_remove(struct platform_device *dev)
>  	/* Clean up all probe data */
>  	unregister_framebuffer(&fbdev->info);
>  
> -	release_mem_region(fbdev->regs_phys, fbdev->regs_len);
> -
> -	dma_free_coherent(&dev->dev, PAGE_ALIGN(fbdev->fb_len), fbdev->fb_mem,
> -			  fbdev->fb_phys);
> -
>  	fb_dealloc_cmap(&fbdev->info.cmap);
> -	kfree(fbdev->info.pseudo_palette);
> -	kfree((void*)fbdev);
>  
>  	return 0;
>  }
> diff --git a/drivers/video/au1200fb.c b/drivers/video/au1200fb.c
> index 04e4479..3e9a773 100644
> --- a/drivers/video/au1200fb.c
> +++ b/drivers/video/au1200fb.c
> @@ -1724,7 +1724,7 @@ static int __devinit au1200fb_drv_probe(struct platform_device *dev)
>  		/* Allocate the framebuffer to the maximum screen size */
>  		fbdev->fb_len = (win->w[plane].xres * win->w[plane].yres * bpp) / 8;
>  
> -		fbdev->fb_mem = dma_alloc_noncoherent(&dev->dev,
> +		fbdev->fb_mem = dmam_alloc_noncoherent(&dev->dev, &dev->dev,
>  				PAGE_ALIGN(fbdev->fb_len),
>  				&fbdev->fb_phys, GFP_KERNEL);
>  		if (!fbdev->fb_mem) {
> @@ -1788,9 +1788,6 @@ static int __devinit au1200fb_drv_probe(struct platform_device *dev)
>  
>  failed:
>  	/* NOTE: This only does the current plane/window that failed; others are still active */
> -	if (fbdev->fb_mem)
> -		dma_free_noncoherent(&dev->dev, PAGE_ALIGN(fbdev->fb_len),
> -				fbdev->fb_mem, fbdev->fb_phys);
>  	if (fbi) {
>  		if (fbi->cmap.len != 0)
>  			fb_dealloc_cmap(&fbi->cmap);
> @@ -1817,10 +1814,6 @@ static int __devexit au1200fb_drv_remove(struct platform_device *dev)
>  
>  		/* Clean up all probe data */
>  		unregister_framebuffer(fbi);
> -		if (fbdev->fb_mem)
> -			dma_free_noncoherent(&dev->dev,
> -					PAGE_ALIGN(fbdev->fb_len),
> -					fbdev->fb_mem, fbdev->fb_phys);
>  		if (fbi->cmap.len != 0)
>  			fb_dealloc_cmap(&fbi->cmap);
>  		kfree(fbi->pseudo_palette);
> 

