Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2GaPr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:47:59 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55563 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab2GaPr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:47:58 -0400
MIME-Version: 1.0
In-Reply-To: <1343742860-16213-3-git-send-email-damien.cassou@lifl.fr>
References: <1343742860-16213-1-git-send-email-damien.cassou@lifl.fr>
	<1343742860-16213-3-git-send-email-damien.cassou@lifl.fr>
Date: Tue, 31 Jul 2012 21:17:57 +0530
Message-ID: <CAK9yfHxy4DGCwZjDCdc3A-a3oKoMGQruDMhfq0uR+2+7nfFHoA@mail.gmail.com>
Subject: Re: [PATCH 4/5] drivers/video/da8xx-fb.c: use devm_ functions
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Damien Cassou <damien.cassou@lifl.fr>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 July 2012 19:24, Damien Cassou <damien.cassou@lifl.fr> wrote:
> From: Damien Cassou <damien.cassou@lifl.fr>
>
> The various devm_ functions allocate memory that is released when a driver
> detaches.  This patch uses these functions for data that is allocated in
> the probe function of a platform device and is only freed in the remove
> function.
>
> Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>
>
> ---
>  drivers/video/da8xx-fb.c |   34 ++++++++--------------------------
>  1 file changed, 8 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
> index 7ae9d53..0429431 100644
> --- a/drivers/video/da8xx-fb.c
> +++ b/drivers/video/da8xx-fb.c
> @@ -947,12 +947,9 @@ static int __devexit fb_remove(struct platform_device *dev)
>                                   par->p_palette_base);
>                 dma_free_coherent(NULL, par->vram_size, par->vram_virt,
>                                   par->vram_phys);
> -               free_irq(par->irq, par);
>                 clk_disable(par->lcdc_clk);
>                 clk_put(par->lcdc_clk);
>                 framebuffer_release(info);
> -               iounmap((void __iomem *)da8xx_fb_reg_base);
> -               release_mem_region(lcdc_regs->start, resource_size(lcdc_regs));
>
>         }
>         return 0;
> @@ -1149,7 +1146,7 @@ static int __devinit fb_probe(struct platform_device *device)
>         struct fb_info *da8xx_fb_info;
>         struct clk *fb_clk = NULL;
>         struct da8xx_fb_par *par;
> -       resource_size_t len;
> +
>         int ret, i;
>         unsigned long ulcm;
>
> @@ -1159,29 +1156,20 @@ static int __devinit fb_probe(struct platform_device *device)
>         }
>
>         lcdc_regs = platform_get_resource(device, IORESOURCE_MEM, 0);
> -       if (!lcdc_regs) {
> -               dev_err(&device->dev,
> -                       "Can not get memory resource for LCD controller\n");
> -               return -ENOENT;
> -       }
> -
> -       len = resource_size(lcdc_regs);
>
> -       lcdc_regs = request_mem_region(lcdc_regs->start, len, lcdc_regs->name);
> -       if (!lcdc_regs)
> -               return -EBUSY;
> -
> -       da8xx_fb_reg_base = (resource_size_t)ioremap(lcdc_regs->start, len);
> +       da8xx_fb_reg_base =
> +               (resource_size_t) devm_request_and_ioremap(&device->dev,
> +                                                          lcdc_regs);
>         if (!da8xx_fb_reg_base) {
>                 ret = -EBUSY;
> -               goto err_request_mem;
> +               return ret;

You can directly do
                  return -EBUSY;
and remove the braces.

>         }
>
>         fb_clk = clk_get(&device->dev, NULL);
>         if (IS_ERR(fb_clk)) {
>                 dev_err(&device->dev, "Can not get device clock\n");
>                 ret = -ENODEV;
> -               goto err_ioremap;
> +               return ret;

ditto

>         }
>         ret = clk_enable(fb_clk);
>         if (ret)
> @@ -1359,8 +1347,8 @@ static int __devinit fb_probe(struct platform_device *device)
>         else
>                 lcdc_irq_handler = lcdc_irq_handler_rev02;
>
> -       ret = request_irq(par->irq, lcdc_irq_handler, 0,
> -                       DRIVER_NAME, par);
> +       ret = devm_request_irq(&device->dev, par->irq, lcdc_irq_handler, 0,
> +                              DRIVER_NAME, par);
>         if (ret)
>                 goto irq_freq;
>         return 0;
> @@ -1391,12 +1379,6 @@ err_clk_disable:
>  err_clk_put:
>         clk_put(fb_clk);
>
> -err_ioremap:
> -       iounmap((void __iomem *)da8xx_fb_reg_base);
> -
> -err_request_mem:
> -       release_mem_region(lcdc_regs->start, len);
> -
>         return ret;
>  }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With warm regards,
Sachin
