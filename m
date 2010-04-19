Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab0DSQUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 12:20:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:54239 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab0DSQUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 12:20:14 -0400
Date: Mon, 19 Apr 2010 17:20:10 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
cc: Dave Airlie <airlied@redhat.com>, linux-fbdev@vger.kernel.org,
       nouveau@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>,
       Peter Jones <pjones@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vga16fb, drm: vga16fb->drm handoff
In-Reply-To: <20100418215751.GA2733@joi.lan>
Message-ID: <alpine.LFD.2.00.1004191716020.2733@casper.infradead.org>
References: <1270929334-3742-1-git-send-email-marcin.slusarz@gmail.com> <1271030068.3554.1.camel@localhost> <20100412113438.GB2789@joi.lan> <1271104101.5726.3.camel@t60prh> <20100412213327.GA4463@joi.lan> <20100413195004.GA4402@joi.lan>
 <20100418215751.GA2733@joi.lan>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> More generic approach below - it should work for all drm drivers.
> Unfortunately vga16fb handoff has 2 other issues:
> - It can be compiled as module, so it can be loaded after KMS driver (and
>   nothing prevents it right now)
> - vga16fb registration error path is iounmapping memory which was not
>   ioremapped.
> I'm going to fix it soon.

Nak. See comments below.
 
> ---
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> Subject: [PATCH] vga16fb, drm: vga16fb->drm handoff
> 
> let vga16fb claim 0xA0000+0x10000 region as its aperture;
> drm drivers don't use it, so we have to detect it and kick
> vga16fb manually - but only if drm is driving the primary card
> (by checking IORESOURCE_ROM_SHADOW resource flag)
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> ---
>  drivers/gpu/drm/i915/intel_fb.c         |    1 +
>  drivers/gpu/drm/nouveau/nouveau_fbcon.c |    1 +
>  drivers/gpu/drm/nouveau/nouveau_state.c |    3 ++-
>  drivers/gpu/drm/radeon/radeon_fb.c      |    1 +
>  drivers/gpu/drm/vmwgfx/vmwgfx_fb.c      |    1 +
>  drivers/video/fbmem.c                   |   19 ++++++++++++++++---
>  drivers/video/vga16fb.c                 |   26 +++++++++++++++++++-------
>  include/linux/fb.h                      |    4 +++-
>  8 files changed, 44 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
> index 6dbc277..8e403be 100644
> --- a/drivers/gpu/drm/i915/intel_fb.c
> +++ b/drivers/gpu/drm/i915/intel_fb.c
> @@ -201,6 +201,7 @@ static int intelfb_create(struct drm_device *dev, uint32_t fb_width,
>  		info->apertures->ranges[0].size = pci_resource_len(dev->pdev, 2);
>  	else
>  		info->apertures->ranges[0].size = pci_resource_len(dev->pdev, 0);
> +	info->pcidev = dev->pdev;

No pci junk in struct fb_info. It needs to be bus independent.

> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index 7cfcd71..4628a59 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -32,6 +32,7 @@
>  #include <linux/device.h>
>  #include <linux/efi.h>
>  #include <linux/fb.h>
> +#include <linux/pci.h>

Please remove pci header.
  
>  #include <asm/fb.h>
>  
> @@ -1500,19 +1501,30 @@ static bool fb_do_apertures_overlap(struct apertures_struct *gena,
>  	return false;
>  }
>  
> -void remove_conflicting_framebuffers(struct apertures_struct *a, const char *name)
> +#define VGA_FB_PHYS 0xA0000
> +void remove_conflicting_framebuffers(struct apertures_struct *a,
> +				     const char *name, struct pci_dev *pcidev)
>  {
>  	int i;
> +	bool primary = false;
> +
> +	if (pcidev)
> +		primary = pcidev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW;

Not portable. Please use fb_is_primary_device(info) instead. It will also 
make your code cleaner.

