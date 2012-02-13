Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab2BMV2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:28:23 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:60247 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758194Ab2BMV2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:28:22 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18n8QFJLm0nHVWyRiJIgTyWGlX6JssW7e/n+q5RDC
	jNudfN83P1hLwr
Message-ID: <4F398066.1050602@gmx.de>
Date: Mon, 13 Feb 2012 21:28:06 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
CC: linux-fbdev@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] video:da8xx-fb: calculate pixel clock period for the
 panel
References: <1328768646-25169-1-git-send-email-prakash.pm@ti.com>
In-Reply-To: <1328768646-25169-1-git-send-email-prakash.pm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2012 06:24 AM, Manjunathappa, Prakash wrote:
> Patch calculates pixel clock period in pico seconds and updates
> the same in variable screen information structure. fbset utility
> uses this information.
> 
> Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
> Since v1:
> Fixed the spelling mistake.
> 
>  drivers/video/da8xx-fb.c |   19 ++++++++++++++++++-
>  1 files changed, 18 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
> index f360d62..882dd67 100644
> --- a/drivers/video/da8xx-fb.c
> +++ b/drivers/video/da8xx-fb.c
> @@ -32,6 +32,7 @@
>  #include <linux/console.h>
>  #include <linux/slab.h>
>  #include <video/da8xx-fb.h>
> +#include <asm/div64.h>
>  
>  #define DRIVER_NAME "da8xx_lcdc"
>  
> @@ -174,7 +175,6 @@ static struct fb_var_screeninfo da8xx_fb_var __devinitdata = {
>  	.activate = 0,
>  	.height = -1,
>  	.width = -1,
> -	.pixclock = 46666,	/* 46us - AUO display */
>  	.accel_flags = 0,
>  	.left_margin = LEFT_MARGIN,
>  	.right_margin = RIGHT_MARGIN,
> @@ -1048,6 +1048,22 @@ static struct fb_ops da8xx_fb_ops = {
>  	.fb_blank = cfb_blank,
>  };
>  
> +/* Calculate and return pixel clock period in pico seconds */
> +static unsigned int da8xxfb_pixel_clk_period(struct da8xx_fb_par *par)
> +{
> +	unsigned int lcd_clk, div;
> +	unsigned int configured_pix_clk;
> +	unsigned long long pix_clk_period_picosec = 1000000000000ULL;
> +
> +	lcd_clk = clk_get_rate(par->lcdc_clk);
> +	div = lcd_clk / par->pxl_clk;
> +	configured_pix_clk = (lcd_clk / div);
> +
> +	do_div(pix_clk_period_picosec, configured_pix_clk);
> +
> +	return pix_clk_period_picosec;
> +}
> +
>  static int __devinit fb_probe(struct platform_device *device)
>  {
>  	struct da8xx_lcdc_platform_data *fb_pdata =
> @@ -1209,6 +1225,7 @@ static int __devinit fb_probe(struct platform_device *device)
>  
>  	da8xx_fb_var.hsync_len = lcdc_info->hsw;
>  	da8xx_fb_var.vsync_len = lcdc_info->vsw;
> +	da8xx_fb_var.pixclock = da8xxfb_pixel_clk_period(par);
>  
>  	/* Initialize fbinfo */
>  	da8xx_fb_info->flags = FBINFO_FLAG_DEFAULT;

