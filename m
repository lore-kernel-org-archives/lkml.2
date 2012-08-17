Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab2HQR1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:27:14 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:47020 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758093Ab2HQR1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:27:04 -0400
MIME-Version: 1.0
In-Reply-To: <502e7651.241a700a.4d05.7e27@mx.google.com>
References: <502e7651.241a700a.4d05.7e27@mx.google.com>
Date: Fri, 17 Aug 2012 12:27:01 -0500
Message-ID: <CAO8GWq=5PEp5ikB_YZ+bUPuKoGWS8jNed7QZECCTmR2qDTMcXg@mail.gmail.com>
Subject: Re: [PATCH] staging: drm/omap: Add error handling
From: "Clark, Rob" <rob@ti.com>
To: emilgoode@gmail.com
Cc: gregkh@linuxfoundation.org, andy.gross@ti.com, daniel.vetter@ffwll.ch,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 11:53 AM,  <emilgoode@gmail.com> wrote:
> From: Emil Goode <emilgoode@gmail.com>
>
> This patch adds fail checks for kmalloc and kzalloc calls
> and also adds a error path that frees allocated pages by
> introducing a call to _drm_gem_put_pages.
>
> Signed-off-by: Emil Goode <emilgoode@gmail.com>

Looks good, thanks

Signed-off-by: Rob Clark <rob@ti.com>

> ---
>  drivers/staging/omapdrm/omap_gem.c |   17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/omapdrm/omap_gem.c b/drivers/staging/omapdrm/omap_gem.c
> index 74082aa..c828743 100644
> --- a/drivers/staging/omapdrm/omap_gem.c
> +++ b/drivers/staging/omapdrm/omap_gem.c
> @@ -226,7 +226,8 @@ static int omap_gem_attach_pages(struct drm_gem_object *obj)
>         struct drm_device *dev = obj->dev;
>         struct omap_gem_object *omap_obj = to_omap_bo(obj);
>         struct page **pages;
> -       int i, npages = obj->size >> PAGE_SHIFT;
> +       int npages = obj->size >> PAGE_SHIFT;
> +       int i, ret;
>         dma_addr_t *addrs;
>
>         WARN_ON(omap_obj->pages);
> @@ -246,18 +247,32 @@ static int omap_gem_attach_pages(struct drm_gem_object *obj)
>          */
>         if (omap_obj->flags & (OMAP_BO_WC|OMAP_BO_UNCACHED)) {
>                 addrs = kmalloc(npages * sizeof(addrs), GFP_KERNEL);
> +               if (!addrs) {
> +                       ret = -ENOMEM;
> +                       goto free_pages;
> +               }
> +
>                 for (i = 0; i < npages; i++) {
>                         addrs[i] = dma_map_page(dev->dev, pages[i],
>                                         0, PAGE_SIZE, DMA_BIDIRECTIONAL);
>                 }
>         } else {
>                 addrs = kzalloc(npages * sizeof(addrs), GFP_KERNEL);
> +               if (!addrs) {
> +                       ret = -ENOMEM;
> +                       goto free_pages;
> +               }
>         }
>
>         omap_obj->addrs = addrs;
>         omap_obj->pages = pages;
>
>         return 0;
> +
> +free_pages:
> +       _drm_gem_put_pages(obj, pages, true, false);
> +
> +       return ret;
>  }
>
>  /** release backing pages */
> --
> 1.7.10.4
>
