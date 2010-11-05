Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab0KEF1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 01:27:09 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65275 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab0KEF1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 01:27:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qtYzWvjy0Y1GosFEi0USRswjytbNt5xwZVIupdj9smTJjAlKEN/E4gIYG+Ji4UwsXq
         KIErKrq7/8O+YvLR1qdIlDl5yclp0zks1N9bk5v7zox4iwn5b2D0+fJGZG2seRDQlXLu
         pessPu+9MooLtmGm2aj/WWf5FAjMbxoeJUo74=
MIME-Version: 1.0
In-Reply-To: <a1c4c46381ac1867c4af3edb811e58a721957842.1288925425.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
	<alpine.DEB.2.00.1011031108260.11625@router.home>
	<a1c4c46381ac1867c4af3edb811e58a721957842.1288925425.git.joe@perches.com>
Date: Fri, 5 Nov 2010 13:27:05 +0800
Message-ID: <AANLkTinpKni-pfEzo=OwZZePVHapafVHJOydDoDU268_@mail.gmail.com>
Subject: Re: [PATCH 36/49] drivers/video: Use vzalloc
From: Dave Young <hidave.darkstar@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Jaya Kumar <jayalk@intworks.biz>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xen.org,
        virtualization@lists.osdl.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 5, 2010 at 11:08 AM, Joe Perches <joe@perches.com> wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/video/arcfb.c        |    5 ++---
>  drivers/video/broadsheetfb.c |    4 +---
>  drivers/video/hecubafb.c     |    5 ++---
>  drivers/video/metronomefb.c  |    4 +---
>  drivers/video/xen-fbfront.c  |    3 +--
>  5 files changed, 7 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/video/arcfb.c b/drivers/video/arcfb.c
> index 3ec4923..86573e2 100644
> --- a/drivers/video/arcfb.c
> +++ b/drivers/video/arcfb.c
> @@ -515,11 +515,10 @@ static int __devinit arcfb_probe(struct platform_device *dev)
>
>        /* We need a flat backing store for the Arc's
>           less-flat actual paged framebuffer */
> -       if (!(videomemory = vmalloc(videomemorysize)))
> +       videomemory = vmalloc(videomemorysize);

typo?

> +       if (!videomemory)
>                return retval;
>
> -       memset(videomemory, 0, videomemorysize);
> -
>        info = framebuffer_alloc(sizeof(struct arcfb_par), &dev->dev);
>        if (!info)
>                goto err;
> diff --git a/drivers/video/broadsheetfb.c b/drivers/video/broadsheetfb.c
> index ebda687..377dde3 100644
> --- a/drivers/video/broadsheetfb.c
> +++ b/drivers/video/broadsheetfb.c
> @@ -1101,12 +1101,10 @@ static int __devinit broadsheetfb_probe(struct platform_device *dev)
>
>        videomemorysize = roundup((dpyw*dpyh), PAGE_SIZE);
>
> -       videomemory = vmalloc(videomemorysize);
> +       videomemory = vzalloc(videomemorysize);
>        if (!videomemory)
>                goto err_fb_rel;
>
> -       memset(videomemory, 0, videomemorysize);
> -
>        info->screen_base = (char *)videomemory;
>        info->fbops = &broadsheetfb_ops;
>
> diff --git a/drivers/video/hecubafb.c b/drivers/video/hecubafb.c
> index c77bcc6..a941e6f 100644
> --- a/drivers/video/hecubafb.c
> +++ b/drivers/video/hecubafb.c
> @@ -231,11 +231,10 @@ static int __devinit hecubafb_probe(struct platform_device *dev)
>
>        videomemorysize = (DPY_W*DPY_H)/8;
>
> -       if (!(videomemory = vmalloc(videomemorysize)))
> +       videomemory = vzalloc(videomemorysize);
> +       if (!videomemory)
>                return retval;
>
> -       memset(videomemory, 0, videomemorysize);
> -
>        info = framebuffer_alloc(sizeof(struct hecubafb_par), &dev->dev);
>        if (!info)
>                goto err_fballoc;
> diff --git a/drivers/video/metronomefb.c b/drivers/video/metronomefb.c
> index 63ed3b7..c0c358c 100644
> --- a/drivers/video/metronomefb.c
> +++ b/drivers/video/metronomefb.c
> @@ -628,12 +628,10 @@ static int __devinit metronomefb_probe(struct platform_device *dev)
>        /* we need to add a spare page because our csum caching scheme walks
>         * to the end of the page */
>        videomemorysize = PAGE_SIZE + (fw * fh);
> -       videomemory = vmalloc(videomemorysize);
> +       videomemory = vzalloc(videomemorysize);
>        if (!videomemory)
>                goto err_fb_rel;
>
> -       memset(videomemory, 0, videomemorysize);
> -
>        info->screen_base = (char __force __iomem *)videomemory;
>        info->fbops = &metronomefb_ops;
>
> diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
> index 428d273..81fcaea 100644
> --- a/drivers/video/xen-fbfront.c
> +++ b/drivers/video/xen-fbfront.c
> @@ -395,10 +395,9 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
>        spin_lock_init(&info->dirty_lock);
>        spin_lock_init(&info->resize_lock);
>
> -       info->fb = vmalloc(fb_size);
> +       info->fb = vzalloc(fb_size);
>        if (info->fb == NULL)
>                goto error_nomem;
> -       memset(info->fb, 0, fb_size);
>
>        info->nr_pages = (fb_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
>
> --
> 1.7.3.1.g432b3.dirty
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards
dave
