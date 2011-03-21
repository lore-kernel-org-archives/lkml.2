Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab1CUEka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 00:40:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60271 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab1CUEk2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 00:40:28 -0400
From: "Janorkar, Mayuresh" <mayur@ti.com>
To: Carl Vanderlip <carlv@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
CC: Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 21 Mar 2011 10:10:09 +0530
Subject: RE: [PATCH 07/20] video: msm: Allow users to request a larger x and
 y virtual fb
Thread-Topic: [PATCH 07/20] video: msm: Allow users to request a larger x
 and y virtual fb
Thread-Index: AcvlvRtjYuoO3VPYSoK3AiaRNj9ztABw2boQ
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB033D22EAE7@dbde02.ent.ti.com>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
 <1300485381-27201-1-git-send-email-carlv@codeaurora.org>
In-Reply-To: <1300485381-27201-1-git-send-email-carlv@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-
> owner@vger.kernel.org] On Behalf Of Carl Vanderlip
> Sent: Saturday, March 19, 2011 3:26 AM
> To: David Brown; Daniel Walker; Bryan Huntsman
> Cc: Brian Swetland; Dima Zavin; Rebecca Schultz Zavin; Colin Cross; linux-
> fbdev@vger.kernel.org; Carl Vanderlip; linux-arm-
> kernel@lists.infradead.org; linux-arm-msm@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH 07/20] video: msm: Allow users to request a larger x and y
> virtual fb
> 
> As long as the total size fits inside the memory allocated to the
> framebuffer
> users can request a larger size. This change allows users to request a
> triple
> buffered fb.
> 
> Authors:
> Dima Zavin <dima@android.com>
> Rebecca Schultz Zavin <rebecca@android.com>
> Colin Cross <ccross@android.com>
> 
> Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
> ---
>  drivers/video/msm/msm_fb.c |   63 ++++++++++++++++++++++++++++++++++-----
> ----
>  1 files changed, 50 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/video/msm/msm_fb.c b/drivers/video/msm/msm_fb.c
> index 04d0067..6af8b41 100644
> --- a/drivers/video/msm/msm_fb.c
> +++ b/drivers/video/msm/msm_fb.c
> @@ -53,6 +53,9 @@ do { \
>  		printk(KERN_INFO "msmfb: "fmt, ##args); \
>  } while (0)
> 
> +#define BITS_PER_PIXEL(info) (info->fb->var.bits_per_pixel)
> +#define BYTES_PER_PIXEL(info) (info->fb->var.bits_per_pixel >> 3)
> +
>  static int msmfb_debug_mask;
>  module_param_named(msmfb_debug_mask, msmfb_debug_mask, int,
>  		   S_IRUGO | S_IWUSR | S_IWGRP);
> @@ -161,9 +164,10 @@ static int msmfb_start_dma(struct msmfb_info *msmfb)
>  	}
>  	spin_unlock_irqrestore(&msmfb->update_lock, irq_flags);
> 
> -	addr = ((msmfb->xres * (yoffset + y) + x) * 2);
> +	addr = ((msmfb->xres * (yoffset + y) + x) * BYTES_PER_PIXEL(msmfb));
>  	mdp->dma(mdp, addr + msmfb->fb->fix.smem_start,
> -		 msmfb->xres * 2, w, h, x, y, &msmfb->dma_callback,
> +		 msmfb->xres * BYTES_PER_PIXEL(msmfb), w, h, x, y,
> +		 &msmfb->dma_callback,
>  		 panel->interface_type);
>  	return 0;
>  error:
> @@ -323,14 +327,46 @@ error:
> 
>  static int msmfb_check_var(struct fb_var_screeninfo *var, struct fb_info
> *info)
>  {
> +	u32 size;
> +
>  	if ((var->xres != info->var.xres) ||
>  	    (var->yres != info->var.yres) ||
> -	    (var->xres_virtual != info->var.xres_virtual) ||
> -	    (var->yres_virtual != info->var.yres_virtual) ||
>  	    (var->xoffset != info->var.xoffset) ||
>  	    (var->bits_per_pixel != info->var.bits_per_pixel) ||
>  	    (var->grayscale != info->var.grayscale))
>  		 return -EINVAL;
> +
> +	size = var->xres_virtual * var->yres_virtual *
> +		(var->bits_per_pixel >> 3);

How about defining a new macro BYTES_PER_PIXEL_VAR for fb_var_screeninfo also? That would make code more readable.

> +	if (size > info->fix.smem_len)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static int msmfb_set_par(struct fb_info *info)
> +{
> +	struct fb_var_screeninfo *var = &info->var;
> +	struct fb_fix_screeninfo *fix = &info->fix;
> +
> +	/* we only support RGB ordering for now */
> +	if (var->bits_per_pixel == 32 || var->bits_per_pixel == 24) {
> +		var->red.offset = 0;
> +		var->red.length = 8;
> +		var->green.offset = 8;
> +		var->green.length = 8;
> +		var->blue.offset = 16;
> +		var->blue.length = 8;

var->red is a fb_bitfield variable.
It provides offset, length and msb_right.

struct fb_bitfield {
    __u32 offset;                   /* beginning of bitfield        */
    __u32 length;                   /* length of bitfield           */
    __u32 msb_right;                /* != 0 : Most significant bit is */ 
                                    /* right */ 
}
Please don't keep msb_right unassigned.

> +	} else if (var->bits_per_pixel == 16) {
> +		var->red.offset = 11;
> +		var->red.length = 5;
> +		var->green.offset = 5;
> +		var->green.length = 6;
> +		var->blue.offset = 0;
> +		var->blue.length = 5;
> +	} else
> +		return -1;

Please use standard error code provided by Linux kernel -EINVAL
(-22 Invalid argument)

> +	fix->line_length = var->xres * var->bits_per_pixel / 8;
Why to divide by 8? Atleast use >>3, bitwise operations that would take less cpu cycles)
As I stated earlier define a new macro for var also.

> +
>  	return 0;
>  }
> 
> @@ -427,6 +463,7 @@ static struct fb_ops msmfb_ops = {
>  	.fb_open = msmfb_open,
>  	.fb_release = msmfb_release,
>  	.fb_check_var = msmfb_check_var,
> +	.fb_set_par = msmfb_set_par,
>  	.fb_pan_display = msmfb_pan_display,
>  	.fb_fillrect = msmfb_fillrect,
>  	.fb_copyarea = msmfb_copyarea,
> @@ -438,8 +475,6 @@ static unsigned PP[16];
> 
> 
> 
> -#define BITS_PER_PIXEL 16
> -
>  static void setup_fb_info(struct msmfb_info *msmfb)
>  {
>  	struct fb_info *fb_info = msmfb->fb;
> @@ -462,7 +497,7 @@ static void setup_fb_info(struct msmfb_info *msmfb)
>  	fb_info->var.height = msmfb->panel->fb_data->height;
>  	fb_info->var.xres_virtual = msmfb->xres;
>  	fb_info->var.yres_virtual = msmfb->yres * 2;
> -	fb_info->var.bits_per_pixel = BITS_PER_PIXEL;
> +	fb_info->var.bits_per_pixel = 16;
>  	fb_info->var.accel_flags = 0;
> 
>  	fb_info->var.yoffset = 0;
> @@ -497,28 +532,30 @@ static int setup_fbmem(struct msmfb_info *msmfb,
> struct platform_device *pdev)
>  	struct fb_info *fb = msmfb->fb;
>  	struct resource *resource;
>  	unsigned long size = msmfb->xres * msmfb->yres *
> -			     (BITS_PER_PIXEL >> 3) * 2;
> +		BYTES_PER_PIXEL(msmfb) * 2;
> +	unsigned long resource_size;
>  	unsigned char *fbram;
> 
>  	/* board file might have attached a resource describing an fb */
>  	resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!resource)
>  		return -EINVAL;
> +	resource_size = resource->end - resource->start + 1;
> 
>  	/* check the resource is large enough to fit the fb */
> -	if (resource->end - resource->start < size) {
> -		printk(KERN_ERR "allocated resource is too small for "
> +	if (resource_size < size) {
> +		printk(KERN_ERR "msmfb: allocated resource is too small for "
>  				"fb\n");
>  		return -ENOMEM;
>  	}
>  	fb->fix.smem_start = resource->start;
> -	fb->fix.smem_len = resource->end - resource->start;
> -	fbram = ioremap(resource->start,
> -			resource->end - resource->start);
> +	fb->fix.smem_len = resource_size;
> +	fbram = ioremap(resource->start, resource_size);
>  	if (fbram == 0) {
>  		printk(KERN_ERR "msmfb: cannot allocate fbram!\n");
>  		return -ENOMEM;
>  	}
> +
>  	fb->screen_base = fbram;
>  	return 0;
>  }
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
