Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254Ab2CGPQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:16:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47274 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab2CGPQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:16:29 -0500
Message-ID: <4F577BC8.8050409@canonical.com>
Date: Wed, 07 Mar 2012 10:16:24 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120302 Thunderbird/11.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: torvalds@linux-foundation, airlied@linux.ie, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm, gma500: Fix Cedarview boot failures in 3.3-rc
References: <20120302233037.027fcc66@pyramind.ukuu.org.uk>
In-Reply-To: <20120302233037.027fcc66@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 06:30 PM, Alan Cox wrote:
>
> Production GMA3600/3650 hardware turns out to be subtly different to the
> development platforms. This combined with a minor driver bug is causing
> the kernel to hang on these platforms.
>
> This patch does the following
>
> - turn down a couple of messages that were meant to be debug and are
>    causing much confusion
>
> - ensure the hotplug interrupt is disabled on Cedartrail systems.
>
> - fix a bug where gtt roll mode called psbfb_sync, which tries to sync
>    the 2D engine. On other devices it is harmless as the 2D engine is
>    present but not in use when in gtt roll mode, on Cedartrail it causes
>    a hang
>
> Signed-off-by: Alan Cox<alan@linux.intel.com>
>
> diff --git a/drivers/gpu/drm/gma500/cdv_device.c b/drivers/gpu/drm/gma500/cdv_device.c
> index 4a5b099..53404af 100644
> --- a/drivers/gpu/drm/gma500/cdv_device.c
> +++ b/drivers/gpu/drm/gma500/cdv_device.c
> @@ -321,6 +321,8 @@ static int cdv_chip_setup(struct drm_device *dev)
>   	cdv_get_core_freq(dev);
>   	gma_intel_opregion_init(dev);
>   	psb_intel_init_bios(dev);
> +	REG_WRITE(PORT_HOTPLUG_EN, 0);
> +	REG_WRITE(PORT_HOTPLUG_STAT, REG_READ(PORT_HOTPLUG_STAT));
>   	return 0;
>   }
>
> diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
> index 830dfdd6b..be61673 100644
> --- a/drivers/gpu/drm/gma500/framebuffer.c
> +++ b/drivers/gpu/drm/gma500/framebuffer.c
> @@ -247,7 +247,6 @@ static struct fb_ops psbfb_roll_ops = {
>   	.fb_imageblit = cfb_imageblit,
>   	.fb_pan_display = psbfb_pan,
>   	.fb_mmap = psbfb_mmap,
> -	.fb_sync = psbfb_sync,
>   	.fb_ioctl = psbfb_ioctl,
>   };
>
> diff --git a/drivers/gpu/drm/gma500/gtt.c b/drivers/gpu/drm/gma500/gtt.c
> index 5d5330f..aff194f 100644
> --- a/drivers/gpu/drm/gma500/gtt.c
> +++ b/drivers/gpu/drm/gma500/gtt.c
> @@ -446,10 +446,9 @@ int psb_gtt_init(struct drm_device *dev, int resume)
>   	pg->gtt_start = pci_resource_start(dev->pdev, PSB_GTT_RESOURCE);
>   	gtt_pages = pci_resource_len(dev->pdev, PSB_GTT_RESOURCE)
>   								>>  PAGE_SHIFT;
> -	/* Some CDV firmware doesn't report this currently. In which case the
> -	   system has 64 gtt pages */
> +	/* CDV doesn't report this. In which case the system has 64 gtt pages */
>   	if (pg->gtt_start == 0 || gtt_pages == 0) {
> -		dev_err(dev->dev, "GTT PCI BAR not initialized.\n");
> +		dev_dbg(dev->dev, "GTT PCI BAR not initialized.\n");
>   		gtt_pages = 64;
>   		pg->gtt_start = dev_priv->pge_ctl;
>   	}
> @@ -461,10 +460,10 @@ int psb_gtt_init(struct drm_device *dev, int resume)
>
>   	if (pg->gatt_pages == 0 || pg->gatt_start == 0) {
>   		static struct resource fudge;	/* Preferably peppermint */
> -		/* This can occur on CDV SDV systems. Fudge it in this case.
> +		/* This can occur on CDV systems. Fudge it in this case.
>   		   We really don't care what imaginary space is being allocated
>   		   at this point */
> -		dev_err(dev->dev, "GATT PCI BAR not initialized.\n");
> +		dev_dbg(dev->dev, "GATT PCI BAR not initialized.\n");
>   		pg->gatt_start = 0x40000000;
>   		pg->gatt_pages = (128 * 1024 * 1024)>>  PAGE_SHIFT;
>   		/* This is a little confusing but in fact the GTT is providing
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

I don't see stable@vger.kernel.org in the Cc list.  Will this patch be 
submitted to stable?

Thanks,

Joe
