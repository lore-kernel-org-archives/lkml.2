Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab0KRGkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 01:40:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46261 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0KRGkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 01:40:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=FkQ58FFQIAvWMXkYL8M8ovAI4dWrz9+m5BOk3TNRBSXz8y39VfIepX0CCvVZ+oEcCb
         RSU8pxIEVmANMOxAURF9JKHQ0Dg3z7PADBM1MVl3C93oW21npRfh9+ahJWgYYy8KS7it
         iaC825rv/y17YJXanNapn/ZQSnINZA1vsIn4s=
MIME-Version: 1.0
Date: Thu, 18 Nov 2010 07:40:19 +0100
X-Google-Sender-Auth: VGQuZbyjb9xjHU-GyK1stSPMP3E
Message-ID: <AANLkTimYDAJr9x00sjGGnDF2vOVXU12qmbnmfuzA5_0h@mail.gmail.com>
Subject: abs() vs. abs64() (was: Re: [PATCH] fbdev: fix nearest mode search)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: michalj@gmail.com, Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAI6ejk6008722

[Don't use the obsolete linux-fbdev-devel address]

On Thu, Nov 18, 2010 at 00:08, Michal Januszewski <michalj@gmail.com> wrote:
> In the framebuffer subsystem the abs() macro is often used as a part of
> the calculation of a Manhattan metric, which in turn is used as a measure
> of similarity between video modes.  The arguments of abs() are sometimes
> unsigned numbers.  This worked fine until commit a49c59c0, which changed
> the definition of abs() to prevent truncation.  As a result of this
> change, in the following piece of code:
>
>  u32 a = 0, b = 1;
>  u32 c = abs(a - b);

Indeed, the difference of 2 numbers is unsigned, as per C.

> 'c' will end up with a value of 0xffffffff instead of the expected 0x1.

This happens on 64-bit only, right?

Anyway, I think commit a49c59c0 is wrong: abs() operates on signed
(32-bit) numbers. For larger (64-bit signed) numbers, we have abs64().

> A problem caused by this change and visible by the end user is that
> framebuffer drivers relying on functions from modedb.c will fail to
> find high resolution video modes similar to that explicitly requested
> by the user if an exact match cannot be found (see e.g.
> https://bugs.gentoo.org/show_bug.cgi?id=296539).
>
> Fix this problem by casting all arguments of abs() to an int prior
> to the macro evaluation in modedb.c and uvesafb.c.
>
> Signed-off-by: Michal Januszewski <michalj@gmail.com>
> ---
> diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
> index 0a4dbdc..878bea1 100644
> --- a/drivers/video/modedb.c
> +++ b/drivers/video/modedb.c
> @@ -636,8 +636,10 @@ done:
>                        if (refresh_specified && db[i].refresh == refresh) {
>                                return 1;
>                        } else {
> -                               if (abs(db[i].refresh - refresh) < diff) {
> -                                       diff = abs(db[i].refresh - refresh);
> +                               if (abs((int)(db[i].refresh - refresh)) <
> +                                   diff) {
> +                                       diff = abs((int)(db[i].refresh -
> +                                               refresh));
>                                        best = i;
>                                }
>                        }
> @@ -654,8 +656,8 @@ done:
>        for (i = 0; i < dbsize; i++) {
>                DPRINTK("Trying %ix%i\n", db[i].xres, db[i].yres);
>                if (!fb_try_mode(var, info, &db[i], bpp)) {
> -                       tdiff = abs(db[i].xres - xres) +
> -                               abs(db[i].yres - yres);
> +                       tdiff = abs((int)(db[i].xres - xres)) +
> +                               abs((int)(db[i].yres - yres));
>
>                        /*
>                         * Penalize modes with resolutions smaller
> @@ -851,13 +853,13 @@ const struct fb_videomode *fb_find_nearest_mode(const struct fb_videomode *mode,
>                modelist = list_entry(pos, struct fb_modelist, list);
>                cmode = &modelist->mode;
>
> -               d = abs(cmode->xres - mode->xres) +
> -                       abs(cmode->yres - mode->yres);
> +               d = abs((int)(cmode->xres - mode->xres)) +
> +                       abs((int)(cmode->yres - mode->yres));
>                if (diff > d) {
>                        diff = d;
>                        best = cmode;
>                } else if (diff == d) {
> -                       d = abs(cmode->refresh - mode->refresh);
> +                       d = abs((int)(cmode->refresh - mode->refresh));
>                        if (diff_refresh > d) {
>                                diff_refresh = d;
>                                best = cmode;
> diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
> index 7b8839e..6621427 100644
> --- a/drivers/video/uvesafb.c
> +++ b/drivers/video/uvesafb.c
> @@ -320,9 +320,9 @@ static int uvesafb_vbe_find_mode(struct uvesafb_par *par,
>        int i, match = -1, h = 0, d = 0x7fffffff;
>
>        for (i = 0; i < par->vbe_modes_cnt; i++) {
> -               h = abs(par->vbe_modes[i].x_res - xres) +
> -                   abs(par->vbe_modes[i].y_res - yres) +
> -                   abs(depth - par->vbe_modes[i].depth);
> +               h = abs((int)(par->vbe_modes[i].x_res - xres)) +
> +                   abs((int)(par->vbe_modes[i].y_res - yres)) +
> +                   abs((int)(depth - par->vbe_modes[i].depth));
>
>                /*
>                 * We have an exact match in terms of resolution
> @@ -1375,7 +1375,7 @@ static int uvesafb_check_var(struct fb_var_screeninfo *var,
>         * which is theoretically incorrect, but which we'll try to handle
>         * here.
>         */
> -       if (depth == 0 || abs(depth - var->bits_per_pixel) >= 8)
> +       if (depth == 0 || abs((int)(depth - var->bits_per_pixel)) >= 8)
>                depth = var->bits_per_pixel;
>
>        match = uvesafb_vbe_find_mode(par, var->xres, var->yres, depth,

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
