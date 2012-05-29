Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab2E2PH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 11:07:57 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:38103 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754001Ab2E2PHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 11:07:49 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18U+38LajYUk7ooPqB2UR8Gkzceb9XAbcW7ShSutZ
	S9GlM/JJPV1kpf
Message-ID: <4FC4E633.2090000@gmx.de>
Date: Tue, 29 May 2012 15:07:31 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120506 Icedove/3.0.11
MIME-Version: 1.0
To: Emil Goode <emilgoode@gmail.com>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] video: bfin_adv7393fb: Fix cleanup code
References: <1338224091-8322-1-git-send-email-emilgoode@gmail.com>
In-Reply-To: <1338224091-8322-1-git-send-email-emilgoode@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 04:54 PM, Emil Goode wrote:
> This patch fixes the cleanup code of the bfin_adv7393_fb_probe
> function.
> 
> 1) The resources were not freed in the order that we allocated them
>    so we call dma_free_coherent() before it was allocated.
> 2) The labels weren't in the right place which also meant that we
>    freed resources that weren't allocated.
> 3) We should free gpio_free(P_IDENT(P_PPI0_FS3)) before returning.
> 4) Lets change the label names into something more meaningful.
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
> v2: Changed the label names as well.
> 
>  drivers/video/bfin_adv7393fb.c |   43 +++++++++++++++++++++-------------------
>  1 file changed, 23 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/video/bfin_adv7393fb.c b/drivers/video/bfin_adv7393fb.c
> index 1a268a2..33ea874 100644
> --- a/drivers/video/bfin_adv7393fb.c
> +++ b/drivers/video/bfin_adv7393fb.c
> @@ -414,14 +414,14 @@ static int __devinit bfin_adv7393_fb_probe(struct i2c_client *client,
>  		if (ret) {
>  			dev_err(&client->dev, "PPI0_FS3 GPIO request failed\n");
>  			ret = -EBUSY;
> -			goto out_8;
> +			goto free_fbdev;
>  		}
>  	}
>  
>  	if (peripheral_request_list(ppi_pins, DRIVER_NAME)) {
>  		dev_err(&client->dev, "requesting PPI peripheral failed\n");
>  		ret = -EFAULT;
> -		goto out_8;
> +		goto free_gpio;
>  	}
>  
>  	fbdev->fb_mem =
> @@ -432,7 +432,7 @@ static int __devinit bfin_adv7393_fb_probe(struct i2c_client *client,
>  		dev_err(&client->dev, "couldn't allocate dma buffer (%d bytes)\n",
>  		       (u32) fbdev->fb_len);
>  		ret = -ENOMEM;
> -		goto out_7;
> +		goto free_ppi_pins;
>  	}
>  
>  	fbdev->info.screen_base = (void *)fbdev->fb_mem;
> @@ -464,27 +464,27 @@ static int __devinit bfin_adv7393_fb_probe(struct i2c_client *client,
>  	if (!fbdev->info.pseudo_palette) {
>  		dev_err(&client->dev, "failed to allocate pseudo_palette\n");
>  		ret = -ENOMEM;
> -		goto out_6;
> +		goto free_fb_mem;
>  	}
>  
>  	if (fb_alloc_cmap(&fbdev->info.cmap, BFIN_LCD_NBR_PALETTE_ENTRIES, 0) < 0) {
>  		dev_err(&client->dev, "failed to allocate colormap (%d entries)\n",
>  			   BFIN_LCD_NBR_PALETTE_ENTRIES);
>  		ret = -EFAULT;
> -		goto out_5;
> +		goto free_palette;
>  	}
>  
>  	if (request_dma(CH_PPI, "BF5xx_PPI_DMA") < 0) {
>  		dev_err(&client->dev, "unable to request PPI DMA\n");
>  		ret = -EFAULT;
> -		goto out_4;
> +		goto free_cmap;
>  	}
>  
>  	if (request_irq(IRQ_PPI_ERROR, ppi_irq_error, 0,
>  			"PPI ERROR", fbdev) < 0) {
>  		dev_err(&client->dev, "unable to request PPI ERROR IRQ\n");
>  		ret = -EFAULT;
> -		goto out_3;
> +		goto free_ch_ppi;
>  	}
>  
>  	fbdev->open = 0;
> @@ -494,14 +494,14 @@ static int __devinit bfin_adv7393_fb_probe(struct i2c_client *client,
>  
>  	if (ret) {
>  		dev_err(&client->dev, "i2c attach: init error\n");
> -		goto out_1;
> +		goto free_irq_ppi;
>  	}
>  
>  
>  	if (register_framebuffer(&fbdev->info) < 0) {
>  		dev_err(&client->dev, "unable to register framebuffer\n");
>  		ret = -EFAULT;
> -		goto out_1;
> +		goto free_irq_ppi;
>  	}
>  
>  	dev_info(&client->dev, "fb%d: %s frame buffer device\n",
> @@ -512,7 +512,7 @@ static int __devinit bfin_adv7393_fb_probe(struct i2c_client *client,
>  	if (!entry) {
>  		dev_err(&client->dev, "unable to create /proc entry\n");
>  		ret = -EFAULT;
> -		goto out_0;
> +		goto free_fb;
>  	}
>  
>  	entry->read_proc = adv7393_read_proc;
> @@ -521,22 +521,25 @@ static int __devinit bfin_adv7393_fb_probe(struct i2c_client *client,
>  
>  	return 0;
>  
> - out_0:
> +free_fb:
>  	unregister_framebuffer(&fbdev->info);
> - out_1:
> +free_irq_ppi:
>  	free_irq(IRQ_PPI_ERROR, fbdev);
> - out_3:
> +free_ch_ppi:
>  	free_dma(CH_PPI);
> - out_4:
> -	dma_free_coherent(NULL, fbdev->fb_len, fbdev->fb_mem,
> -			  fbdev->dma_handle);
> - out_5:
> +free_cmap:
>  	fb_dealloc_cmap(&fbdev->info.cmap);
> - out_6:
> +free_palette:
>  	kfree(fbdev->info.pseudo_palette);
> - out_7:
> +free_fb_mem:
> +	dma_free_coherent(NULL, fbdev->fb_len, fbdev->fb_mem,
> +			  fbdev->dma_handle);
> +free_ppi_pins:
>  	peripheral_free_list(ppi_pins);
> - out_8:
> +free_gpio:
> +	if (ANOMALY_05000400)
> +		gpio_free(P_IDENT(P_PPI0_FS3));
> +free_fbdev:
>  	kfree(fbdev);
>  
>  	return ret;

