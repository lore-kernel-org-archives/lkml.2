Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab2FVIBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 04:01:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46097 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761576Ab2FVIA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 04:00:59 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1206220012470.7671@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206220012470.7671@swampdragon.chaosbits.net>
Date: Fri, 22 Jun 2012 13:30:58 +0530
Message-ID: <CAHdPZaMCDO2GAyxR_WYxqpwC1Ym307uj3CXFG7r0LybMLH7Pig@mail.gmail.com>
Subject: Re: [PATCH] mgag200: Fix a memory leak in mgag200fb_create()
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Dave Airlie <airlied@redhat.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 3:43 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> First we allocate memory for 'sysram' with vmalloc() and subsequently
> we allocate for 'info' with framebuffer_alloc(). If the second
> allocation fails we return -ENOMEM, but neglect to vfree() the memory
> we previously allocated for 'sysram', thus leaking it.
>
Hi Jesper,

> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/gpu/drm/mgag200/mgag200_fb.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/mgag200/mgag200_fb.c b/drivers/gpu/drm/mgag200/mgag200_fb.c
> index 880d336..3c837e5 100644
> --- a/drivers/gpu/drm/mgag200/mgag200_fb.c
> +++ b/drivers/gpu/drm/mgag200/mgag200_fb.c
> @@ -156,8 +156,10 @@ static int mgag200fb_create(struct mga_fbdev *mfbdev,
>                return -ENOMEM;
>
>        info = framebuffer_alloc(0, device);
> -       if (info == NULL)
> +       if (info == NULL) {
> +               vfree(sysram);
>                return -ENOMEM;
> +       }
>
>        info->par = mfbdev;
>
This looks ok. but what about the error path?
there are more leaks at error paths. mgag200_framebuffer_init failcase
and the functions below like,
fb_alloc_cmap,
alloc_apertures,
?

> --
> 1.7.11
>
>
> --
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
