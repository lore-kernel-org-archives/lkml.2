Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059Ab0DHSXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:23:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:59909 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932998Ab0DHSXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:23:06 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+opEoEaMKoeHi8DvLMPI5SGDT0P5qGZt9AhEEdTg
	E2zhPCchBHBMOd
Message-ID: <4BBE1F01.5000800@gmx.de>
Date: Thu, 08 Apr 2010 20:22:57 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/16] [FB] viafb: Fix various resource leaks during module_init()
References: <1270746946-12467-1-git-send-email-corbet@lwn.net> <1270746946-12467-2-git-send-email-corbet@lwn.net>
In-Reply-To: <1270746946-12467-2-git-send-email-corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.41999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet schrieb:
> From: Harald Welte <laforge@gnumonks.org>
> 
> The current code executed from module_init() in viafb does not have
> proper error checking and [partial] resoure release paths in case
> an error happens half way through driver initialization.
> 
> This patch adresses the most obvious of those issues, such as a
> leftover i2c bus if module_init (and thus module load) fails.
> 
> [jc: fixed merge conflicts]
> Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
> ---
>  drivers/video/via/viafbdev.c |   52 ++++++++++++++++++++++++++++++-----------
>  1 files changed, 38 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
> index 3028e7d..91bfe6d 100644
> --- a/drivers/video/via/viafbdev.c
> +++ b/drivers/video/via/viafbdev.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
> + * Copyright 1998-2009 VIA Technologies, Inc. All Rights Reserved.
>   * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
>  
>   * This program is free software; you can redistribute it and/or
> @@ -1847,7 +1847,7 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
>  				   const struct pci_device_id *ent)
>  {
>  	u32 default_xres, default_yres;
> -	int vmode_index;
> +	int rc, vmode_index;
>  	u32 viafb_par_length;
>  
>  	DEBUG_MSG(KERN_INFO "VIAFB PCI Probe!!\n");
> @@ -1862,7 +1862,7 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
>  		&pdev->dev);
>  	if (!viafbinfo) {
>  		printk(KERN_ERR"Could not allocate memory for viafb_info.\n");
> -		return -ENODEV;
> +		return -ENOMEM;
>  	}
>  
>  	viaparinfo = (struct viafb_par *)viafbinfo->par;
> @@ -1886,7 +1886,9 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
>  		viafb_dual_fb = 0;
>  
>  	/* Set up I2C bus stuff */
> -	viafb_create_i2c_bus(viaparinfo);
> +	rc = viafb_create_i2c_bus(viaparinfo);
> +	if (rc)
> +		goto out_fb_release;
>  
>  	viafb_init_chip_info(pdev, ent);
>  	viaparinfo->fbmem = pci_resource_start(pdev, 0);
> @@ -1897,7 +1899,8 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
>  		viaparinfo->memsize);
>  	if (!viafbinfo->screen_base) {
>  		printk(KERN_INFO "ioremap failed\n");
> -		return -ENOMEM;
> +		rc = -EIO;

I don't know whether this is right (changing the return code) as Andrew 
recommend a while ago:
"It should return -ENOMEM rather than -1, but that's minor."
So I did and now I wonder which one is correct?

> +		goto out_delete_i2c;
>  	}
>  
>  	viafbinfo->fix.mmio_start = pci_resource_start(pdev, 1);
> @@ -1988,8 +1991,7 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
>  		if (!viafbinfo1) {
>  			printk(KERN_ERR
>  			"allocate the second framebuffer struct error\n");
> -			framebuffer_release(viafbinfo);
> -			return -ENOMEM;

rc = -ENOMEM;
is missing?

> +			goto out_delete_i2c;
>  		}
>  		viaparinfo1 = viafbinfo1->par;
>  		memcpy(viaparinfo1, viaparinfo, viafb_par_length);
> @@ -2044,21 +2046,26 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
>  	viaparinfo->depth = fb_get_color_depth(&viafbinfo->var,
>  		&viafbinfo->fix);
>  	default_var.activate = FB_ACTIVATE_NOW;
> -	fb_alloc_cmap(&viafbinfo->cmap, 256, 0);
> +	rc = fb_alloc_cmap(&viafbinfo->cmap, 256, 0);
> +	if (rc)
> +		goto out_fb1_release;
>  
>  	if (viafb_dual_fb && (viafb_primary_dev == LCD_Device)
>  	    && (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)) {
> -		if (register_framebuffer(viafbinfo1) < 0)
> -			return -EINVAL;
> +		rc = register_framebuffer(viafbinfo1);
> +		if (rc)
> +			goto out_dealloc_cmap;
>  	}
> -	if (register_framebuffer(viafbinfo) < 0)
> -		return -EINVAL;
> +	rc = register_framebuffer(viafbinfo);
> +	if (rc)
> +		goto out_fb1_unreg_lcd_cle266;
>  
>  	if (viafb_dual_fb && ((viafb_primary_dev != LCD_Device)
>  			|| (viaparinfo->chip_info->gfx_chip_name !=
>  			UNICHROME_CLE266))) {
> -		if (register_framebuffer(viafbinfo1) < 0)
> -			return -EINVAL;
> +		rc = register_framebuffer(viafbinfo1);
> +		if (rc)
> +			goto out_fb_unreg;
>  	}
>  	DEBUG_MSG(KERN_INFO "fb%d: %s frame buffer device %dx%d-%dbpp\n",
>  		  viafbinfo->node, viafbinfo->fix.id, default_var.xres,
> @@ -2067,6 +2074,23 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
>  	viafb_init_proc(&viaparinfo->shared->proc_entry);
>  	viafb_init_dac(IGA2);
>  	return 0;
> +
> +out_fb_unreg:
> +	unregister_framebuffer(viafbinfo);
> +out_fb1_unreg_lcd_cle266:
> +	if (viafb_dual_fb && (viafb_primary_dev == LCD_Device)
> +            && (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266))
> +		unregister_framebuffer(viafbinfo1);
> +out_dealloc_cmap:
> +	fb_dealloc_cmap(&viafbinfo->cmap);
> +out_fb1_release:
> +	if (viafbinfo1)
> +		framebuffer_release(viafbinfo1);
> +out_delete_i2c:
> +	viafb_delete_i2c_buss(viaparinfo);
> +out_fb_release:
> +	framebuffer_release(viafbinfo);
> +	return rc;
>  }
>  
>  static void __devexit via_pci_remove(struct pci_dev *pdev)

Otherwise it looks okay.


Thanks,

Florian Tobias Schandinat
