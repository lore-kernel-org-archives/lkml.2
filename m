Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab2HWUfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:35:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57612 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932795Ab2HWUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:35:49 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX197Bx5nnph7R9fRy203kvATI4BWmQTCcla+DNqZV2
	9Clvr2jYExDK1R
Message-ID: <5036941F.2070305@gmx.de>
Date: Thu, 23 Aug 2012 20:35:43 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Damien Cassou <damien.cassou@lifl.fr>
CC: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] drivers/video/ep93xx-fb.c: use devm_ functions
References: <1343742860-16213-1-git-send-email-damien.cassou@lifl.fr> <1343742860-16213-2-git-send-email-damien.cassou@lifl.fr>
In-Reply-To: <1343742860-16213-2-git-send-email-damien.cassou@lifl.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 01:54 PM, Damien Cassou wrote:
> From: Damien Cassou <damien.cassou@lifl.fr>
> 
> The various devm_ functions allocate memory that is released when a driver
> detaches.  This patch uses these functions for data that is allocated in
> the probe function of a platform device and is only freed in the remove
> function.
> 
> Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>

Applied.


Thanks,

Florian Tobias Schandinat

> 
> ---
>  drivers/video/ep93xx-fb.c |   17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/video/ep93xx-fb.c b/drivers/video/ep93xx-fb.c
> index 345d962..69c89f2 100644
> --- a/drivers/video/ep93xx-fb.c
> +++ b/drivers/video/ep93xx-fb.c
> @@ -529,7 +529,8 @@ static int __devinit ep93xxfb_probe(struct platform_device *pdev)
>  	 * any of the framebuffer registers.
>  	 */
>  	fbi->res = res;
> -	fbi->mmio_base = ioremap(res->start, resource_size(res));
> +	fbi->mmio_base = devm_ioremap(&pdev->dev, res->start,
> +				      resource_size(res));
>  	if (!fbi->mmio_base) {
>  		err = -ENXIO;
>  		goto failed_resource;
> @@ -553,20 +554,20 @@ static int __devinit ep93xxfb_probe(struct platform_device *pdev)
>  	if (err == 0) {
>  		dev_err(info->dev, "No suitable video mode found\n");
>  		err = -EINVAL;
> -		goto failed_mode;
> +		goto failed_resource;
>  	}
>  
>  	if (mach_info->setup) {
>  		err = mach_info->setup(pdev);
>  		if (err)
> -			goto failed_mode;
> +			goto failed_resource;
>  	}
>  
>  	err = ep93xxfb_check_var(&info->var, info);
>  	if (err)
>  		goto failed_check;
>  
> -	fbi->clk = clk_get(info->dev, NULL);
> +	fbi->clk = devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(fbi->clk)) {
>  		err = PTR_ERR(fbi->clk);
>  		fbi->clk = NULL;
> @@ -578,19 +579,15 @@ static int __devinit ep93xxfb_probe(struct platform_device *pdev)
>  
>  	err = register_framebuffer(info);
>  	if (err)
> -		goto failed;
> +		goto failed_check;
>  
>  	dev_info(info->dev, "registered. Mode = %dx%d-%d\n",
>  		 info->var.xres, info->var.yres, info->var.bits_per_pixel);
>  	return 0;
>  
> -failed:
> -	clk_put(fbi->clk);
>  failed_check:
>  	if (fbi->mach_info->teardown)
>  		fbi->mach_info->teardown(pdev);
> -failed_mode:
> -	iounmap(fbi->mmio_base);
>  failed_resource:
>  	ep93xxfb_dealloc_videomem(info);
>  failed_videomem:
> @@ -609,8 +606,6 @@ static int __devexit ep93xxfb_remove(struct platform_device *pdev)
>  
>  	unregister_framebuffer(info);
>  	clk_disable(fbi->clk);
> -	clk_put(fbi->clk);
> -	iounmap(fbi->mmio_base);
>  	ep93xxfb_dealloc_videomem(info);
>  	fb_dealloc_cmap(&info->cmap);
>  
> 
> 

