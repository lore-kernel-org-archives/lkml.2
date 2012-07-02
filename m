Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2GBG2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 02:28:46 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35409 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750720Ab2GBG2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 02:28:44 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX199FVZjwTd9ZVKwoEbhRC4dUQJDXe7aK5ANqDB1J8
	S33bQn6nHWEU9L
Message-ID: <4FF13F9C.5050104@gmx.de>
Date: Mon, 02 Jul 2012 06:28:44 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Liu Ying <Ying.Liu@freescale.com>
CC: g.liakhovetski@gmx.de, liu.y.victor@gmail.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] mx3fb: support pan display with fb_set_var
References: <1339376810-8247-1-git-send-email-Ying.Liu@freescale.com> <1339376810-8247-2-git-send-email-Ying.Liu@freescale.com>
In-Reply-To: <1339376810-8247-2-git-send-email-Ying.Liu@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 01:06 AM, Liu Ying wrote:
> Users may call FBIOPUT_VSCREENINFO ioctrl to do pan display.
> This ioctrl relies on fb_set_var() to do the job. fb_set_var()
> calls the custom fb_set_par() method and then calls the custom
> fb_pan_display() method. Before calling the custom fb_pan_display()
> method, info->var is already updated from the new *var in fb_set_var().
> And, the custom fb_pan_display() method checks if xoffset and yoffset
> in info->var and the new *var are different before doing actual panning,
> which prevents the panning from happening within fb_set_var() context.
> This patch caches the current var info locally in mx3fb driver so that
> pan display with fb_set_var is supported.
> 
> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>

Applied patches 2 and 3 of this series.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/mx3fb.c |   33 ++++++++++++++++++++++++++-------
>  1 files changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
> index d53db60..2dd11c4 100644
> --- a/drivers/video/mx3fb.c
> +++ b/drivers/video/mx3fb.c
> @@ -268,7 +268,7 @@ struct mx3fb_info {
>  	dma_cookie_t			cookie;
>  	struct scatterlist		sg[2];
>  
> -	u32				sync;	/* preserve var->sync flags */
> +	struct fb_var_screeninfo	cur_var; /* current var info */
>  };
>  
>  static void mx3fb_dma_done(void *);
> @@ -723,7 +723,7 @@ static void mx3fb_dma_done(void *arg)
>  
>  static int __set_par(struct fb_info *fbi, bool lock)
>  {
> -	u32 mem_len;
> +	u32 mem_len, cur_xoffset, cur_yoffset;
>  	struct ipu_di_signal_cfg sig_cfg;
>  	enum ipu_panel mode = IPU_PANEL_TFT;
>  	struct mx3fb_info *mx3_fbi = fbi->par;
> @@ -805,8 +805,25 @@ static int __set_par(struct fb_info *fbi, bool lock)
>  	video->out_height	= fbi->var.yres;
>  	video->out_stride	= fbi->var.xres_virtual;
>  
> -	if (mx3_fbi->blank == FB_BLANK_UNBLANK)
> +	if (mx3_fbi->blank == FB_BLANK_UNBLANK) {
>  		sdc_enable_channel(mx3_fbi);
> +		/*
> +		 * sg[0] points to fb smem_start address
> +		 * and is actually active in controller.
> +		 */
> +		mx3_fbi->cur_var.xoffset = 0;
> +		mx3_fbi->cur_var.yoffset = 0;
> +	}
> +
> +	/*
> +	 * Preserve xoffset and yoffest in case they are
> +	 * inactive in controller as fb is blanked.
> +	 */
> +	cur_xoffset = mx3_fbi->cur_var.xoffset;
> +	cur_yoffset = mx3_fbi->cur_var.yoffset;
> +	mx3_fbi->cur_var = fbi->var;
> +	mx3_fbi->cur_var.xoffset = cur_xoffset;
> +	mx3_fbi->cur_var.yoffset = cur_yoffset;
>  
>  	return 0;
>  }
> @@ -926,8 +943,8 @@ static int mx3fb_check_var(struct fb_var_screeninfo *var, struct fb_info *fbi)
>  	var->grayscale = 0;
>  
>  	/* Preserve sync flags */
> -	var->sync |= mx3_fbi->sync;
> -	mx3_fbi->sync |= var->sync;
> +	var->sync |= mx3_fbi->cur_var.sync;
> +	mx3_fbi->cur_var.sync |= var->sync;
>  
>  	return 0;
>  }
> @@ -1073,8 +1090,8 @@ static int mx3fb_pan_display(struct fb_var_screeninfo *var,
>  		return -EINVAL;
>  	}
>  
> -	if (fbi->var.xoffset == var->xoffset &&
> -	    fbi->var.yoffset == var->yoffset)
> +	if (mx3_fbi->cur_var.xoffset == var->xoffset &&
> +	    mx3_fbi->cur_var.yoffset == var->yoffset)
>  		return 0;	/* No change, do nothing */
>  
>  	y_bottom = var->yoffset;
> @@ -1157,6 +1174,8 @@ static int mx3fb_pan_display(struct fb_var_screeninfo *var,
>  	else
>  		fbi->var.vmode &= ~FB_VMODE_YWRAP;
>  
> +	mx3_fbi->cur_var = fbi->var;
> +
>  	mutex_unlock(&mx3_fbi->mutex);
>  
>  	dev_dbg(fbi->device, "Update complete\n");

