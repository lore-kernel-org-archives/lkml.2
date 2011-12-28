Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1L1XzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 18:55:06 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:33518 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1L1XzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 18:55:02 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-7d-4efbac5425bd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20111227141550.GA3331@opensource.wolfsonmicro.com>
 <1324995372-3410-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1324995372-3410-5-git-send-email-broonie@opensource.wolfsonmicro.com>
In-reply-to: <1324995372-3410-5-git-send-email-broonie@opensource.wolfsonmicro.com>
Subject: RE: [PATCH 5/6] video: s3c-fb: Hold runtime PM references when
 touching registers
Date: Thu, 29 Dec 2011 08:55:00 +0900
Message-id: <000a01ccc5bc$1c4d4010$54e7c030$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczEohv5xoo2U+l+TGaIcUMhwdlEOwBGftFg
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Tuesday, December 27, 2011 11:16 PM
> To: Jingoo Han; Florian Tobias Schandinat
> Cc: linux-fbdev@vger.kernel.org; linux-kernel@vger.kernel.org; Mark Brown
> Subject: [PATCH 5/6] video: s3c-fb: Hold runtime PM references when touching registers
> 
> Take a runtime PM reference whenever updating registers in preparation
> for suspending the device when the framebuffer is blanked.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

		Acked-by: Jingoo Han <jg1.han@samsung.com>

> ---
>  drivers/video/s3c-fb.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
> index 688b9d8..84cf631 100644
> --- a/drivers/video/s3c-fb.c
> +++ b/drivers/video/s3c-fb.c
> @@ -496,6 +496,8 @@ static int s3c_fb_set_par(struct fb_info *info)
> 
>  	dev_dbg(sfb->dev, "setting framebuffer parameters\n");
> 
> +	pm_runtime_get_sync(sfb->dev);
> +
>  	shadow_protect_win(win, 1);
> 
>  	switch (var->bits_per_pixel) {
> @@ -692,6 +694,8 @@ static int s3c_fb_set_par(struct fb_info *info)
> 
>  	shadow_protect_win(win, 0);
> 
> +	pm_runtime_put_sync(sfb->dev);
> +
>  	return 0;
>  }
> 
> @@ -763,6 +767,8 @@ static int s3c_fb_setcolreg(unsigned regno,
>  	dev_dbg(sfb->dev, "%s: win %d: %d => rgb=%d/%d/%d\n",
>  		__func__, win->index, regno, red, green, blue);
> 
> +	pm_runtime_get_sync(sfb->dev);
> +
>  	switch (info->fix.visual) {
>  	case FB_VISUAL_TRUECOLOR:
>  		/* true-colour, use pseudo-palette */
> @@ -790,9 +796,11 @@ static int s3c_fb_setcolreg(unsigned regno,
>  		break;
> 
>  	default:
> +		pm_runtime_put_sync(sfb->dev);
>  		return 1;	/* unknown type */
>  	}
> 
> +	pm_runtime_put_sync(sfb->dev);
>  	return 0;
>  }
> 
> @@ -812,6 +820,8 @@ static int s3c_fb_blank(int blank_mode, struct fb_info *info)
> 
>  	dev_dbg(sfb->dev, "blank mode %d\n", blank_mode);
> 
> +	pm_runtime_get_sync(sfb->dev);
> +
>  	wincon = readl(sfb->regs + sfb->variant.wincon + (index * 4));
> 
>  	switch (blank_mode) {
> @@ -839,6 +849,7 @@ static int s3c_fb_blank(int blank_mode, struct fb_info *info)
>  	case FB_BLANK_VSYNC_SUSPEND:
>  	case FB_BLANK_HSYNC_SUSPEND:
>  	default:
> +		pm_runtime_put_sync(sfb->dev);
>  		return 1;
>  	}
> 
> @@ -869,6 +880,8 @@ static int s3c_fb_blank(int blank_mode, struct fb_info *info)
>  		shadow_protect_win(win, 0);
>  	}
> 
> +	pm_runtime_put_sync(sfb->dev);
> +
>  	return 0;
>  }
> 
> @@ -891,6 +904,8 @@ static int s3c_fb_pan_display(struct fb_var_screeninfo *var,
>  	void __iomem *buf	= sfb->regs + win->index * 8;
>  	unsigned int start_boff, end_boff;
> 
> +	pm_runtime_get_sync(sfb->dev);
> +
>  	/* Offset in bytes to the start of the displayed area */
>  	start_boff = var->yoffset * info->fix.line_length;
>  	/* X offset depends on the current bpp */
> @@ -909,6 +924,7 @@ static int s3c_fb_pan_display(struct fb_var_screeninfo *var,
>  			break;
>  		default:
>  			dev_err(sfb->dev, "invalid bpp\n");
> +			pm_runtime_put_sync(sfb->dev);
>  			return -EINVAL;
>  		}
>  	}
> @@ -924,6 +940,7 @@ static int s3c_fb_pan_display(struct fb_var_screeninfo *var,
> 
>  	shadow_protect_win(win, 0);
> 
> +	pm_runtime_put_sync(sfb->dev);
>  	return 0;
>  }
> 
> @@ -1013,11 +1030,16 @@ static int s3c_fb_wait_for_vsync(struct s3c_fb *sfb, u32 crtc)
>  	if (crtc != 0)
>  		return -ENODEV;
> 
> +	pm_runtime_get_sync(sfb->dev);
> +
>  	count = sfb->vsync_info.count;
>  	s3c_fb_enable_irq(sfb);
>  	ret = wait_event_interruptible_timeout(sfb->vsync_info.wait,
>  				       count != sfb->vsync_info.count,
>  				       msecs_to_jiffies(VSYNC_TIMEOUT_MSEC));
> +
> +	pm_runtime_put_sync(sfb->dev);
> +
>  	if (ret == 0)
>  		return -ETIMEDOUT;
> 
> --
> 1.7.7.3

