Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353Ab0GWPAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:00:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62553 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab0GWPAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:00:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eVhhMo0NbRRQgzNjwjfqvw6/ukA73UsYGCFasboZvs64Vc5Z4NmywrEIcXDBFRj6a1
         7qj7isACCBLpKhBOgN6GthAAyIAiNtJ2YY3yPVtcrXOCU5TRqpepgQSa3MkKKgS4yQzG
         36yzwEV7xrqx7LhgwBLxfMQ1z0Leq7MbMpnXM=
MIME-Version: 1.0
In-Reply-To: <20100723131034.GA6618@joi.lan>
References: <20100720191923.GA11056@joi.lan>
	<20100722172039.e935c67d.akpm@linux-foundation.org>
	<20100723131034.GA6618@joi.lan>
Date: Fri, 23 Jul 2010 17:00:09 +0200
X-Google-Sender-Auth: bWCxahRrQKeqyjCiaqdHQb3z3Tc
Message-ID: <AANLkTik4aFSwhfjvmA5RJxa+tLxmhC4_EHcOMpaGEhLD@mail.gmail.com>
Subject: Re: [PATCH v2] vga16fb: refuse to load in face of other driver 
	controlling primary card
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        nouveau@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 15:10, Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index 731fce6..cb19cae 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1504,6 +1504,7 @@ static bool fb_do_apertures_overlap(struct apertures_struct *gena,
>  }
>
>  #define VGA_FB_PHYS 0xA0000
> +#define VGA_FB_PHYS_LEN 65536

Does this really belong here?

>  void remove_conflicting_framebuffers(struct apertures_struct *a,
>                                     const char *name, bool primary)
>  {
> @@ -1532,6 +1533,17 @@ void remove_conflicting_framebuffers(struct apertures_struct *a,
>  }
>  EXPORT_SYMBOL(remove_conflicting_framebuffers);
>
> +struct resource *request_vga_mem_region(const char *name)
> +{
> +       struct resource *res = request_mem_region(VGA_FB_PHYS,
> +                                               VGA_FB_PHYS_LEN, name);
> +       if (res == NULL)
> +               printk(KERN_INFO "%s: other driver owns the primary card, refusing to load\n",
> +                                 name);
> +       return res;
> +}
> +EXPORT_SYMBOL(request_vga_mem_region);
> +
>  /**
>  *     register_framebuffer - registers a frame buffer device
>  *     @fb_info: frame buffer info structure
> @@ -1548,6 +1560,8 @@ register_framebuffer(struct fb_info *fb_info)
>        int i;
>        struct fb_event event;
>        struct fb_videomode mode;
> +       bool primary;
> +       struct resource *res = fb_info->resource;
>
>        if (num_registered_fb == FB_MAX)
>                return -ENXIO;
> @@ -1555,8 +1569,19 @@ register_framebuffer(struct fb_info *fb_info)
>        if (fb_check_foreignness(fb_info))
>                return -ENOSYS;
>
> +       primary = fb_is_primary_device(fb_info);
>        remove_conflicting_framebuffers(fb_info->apertures, fb_info->fix.id,
> -                                        fb_is_primary_device(fb_info));
> +                                       primary);
> +
> +       /*
> +        * if the card is primary and the resource was not already allocated
> +        * by framebuffer driver then lock vga memory region
> +        */
> +       if (primary && res == NULL) {
> +               res = request_vga_mem_region(fb_info->fix.id);
> +               if (res == NULL)
> +                       return -EBUSY;
> +       }

More VGA-specific stuff in drivers/video/fbmem.c.
Not all platforms have VGA memory.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
