Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab0LTFGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 00:06:35 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55360 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab0LTFGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 00:06:34 -0500
From: "Janorkar, Mayuresh" <mayur@ti.com>
To: Alexey Charkov <alchark@gmail.com>, Paul Mundt <lethal@linux-sh.org>
CC: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Date: Mon, 20 Dec 2010 10:36:24 +0530
Subject: RE: [PATCH] fbdev: Minor cleanup in WM8505-related code
Thread-Topic: [PATCH] fbdev: Minor cleanup in WM8505-related code
Thread-Index: AcufqGypdVjFWBtETfyrhCodw47Y2gAWxpbg
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB0322F86AE6@dbde02.ent.ti.com>
References: <20101219181300.GA32645@alchark-u3s>
In-Reply-To: <20101219181300.GA32645@alchark-u3s>
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

Alexey,

How about sending this as two different patches?
1) Correcting vsync
2) code cleanup

-Thanks,
Mayuresh
> -----Original Message-----
> From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-
> owner@vger.kernel.org] On Behalf Of Alexey Charkov
> Sent: Sunday, December 19, 2010 11:43 PM
> To: Paul Mundt
> Cc: linux-fbdev@vger.kernel.org; linux-kernel@vger.kernel.org; vt8500-
> wm8505-linux-kernel@googlegroups.com
> Subject: [PATCH] fbdev: Minor cleanup in WM8505-related code
> 
> This fixes vsync timing calculation in wm8505fb.c (was off by one,
> which caused some flicker with larger panels) and replaces the last
> remaining driver name reference with the macro for uniformity.
> 
> In addition, the error return path in wmt_ge_rops.c is made more
> uniform by getting rid of goto's in remaining places.
> 
> Signed-off-by: Alexey Charkov <alchark@gmail.com>
> ---
> 
> Paul, could you please apply this to your fbdev tree? The patch seems
> to be trivial, and it would bring the mainline code in line with what
> people use when pulling from our Gitorious development repo.
> 
> Best regards,
> Alexey
> 
> diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
> index e37251b..96e34a5 100644
> --- a/drivers/video/wm8505fb.c
> +++ b/drivers/video/wm8505fb.c
> @@ -88,7 +88,7 @@ static int wm8505fb_set_timing(struct fb_info *info)
>  	int v_start = info->var.upper_margin;
>  	int v_end = v_start + info->var.yres;
>  	int v_all = v_end + info->var.lower_margin;
> -	int v_sync = info->var.vsync_len + 1;
> +	int v_sync = info->var.vsync_len;
> 
>  	writel(0, fbi->regbase + WMT_GOVR_TG);
> 
> @@ -291,7 +291,7 @@ static int __devinit wm8505fb_probe(struct
> platform_device *pdev)
>  		goto failed_fbi;
>  	}
> 
> -	res = request_mem_region(res->start, resource_size(res),
> "wm8505fb");
> +	res = request_mem_region(res->start, resource_size(res),
> DRIVER_NAME);
>  	if (res == NULL) {
>  		dev_err(&pdev->dev, "failed to request I/O memory\n");
>  		ret = -EBUSY;
> diff --git a/drivers/video/wmt_ge_rops.c b/drivers/video/wmt_ge_rops.c
> index f31883f..45832b7 100644
> --- a/drivers/video/wmt_ge_rops.c
> +++ b/drivers/video/wmt_ge_rops.c
> @@ -127,13 +127,11 @@ EXPORT_SYMBOL_GPL(wmt_ge_sync);
>  static int __devinit wmt_ge_rops_probe(struct platform_device *pdev)
>  {
>  	struct resource *res;
> -	int ret;
> 
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (res == NULL) {
>  		dev_err(&pdev->dev, "no I/O memory resource defined\n");
> -		ret = -ENODEV;
> -		goto error;
> +		return -ENODEV;
>  	}
> 
>  	/* Only one ROP engine is presently supported. */
> @@ -145,17 +143,13 @@ static int __devinit wmt_ge_rops_probe(struct
> platform_device *pdev)
>  	regbase = ioremap(res->start, resource_size(res));
>  	if (regbase == NULL) {
>  		dev_err(&pdev->dev, "failed to map I/O memory\n");
> -		ret = -EBUSY;
> -		goto error;
> +		return -EBUSY;
>  	}
> 
>  	writel(1, regbase + GE_ENABLE_OFF);
>  	printk(KERN_INFO "Enabled support for WMT GE raster
> acceleration\n");
> 
>  	return 0;
> -
> -error:
> -	return ret;
>  }
> 
>  static int __devexit wmt_ge_rops_remove(struct platform_device *pdev)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
