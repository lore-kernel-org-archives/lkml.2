Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab1FHSx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 14:53:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51692 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab1FHSxY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 14:53:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=o5qy3tI/9rVy/k3cn/y1Hg/ZlNBe8KK3F2HKejpH/UihOPbfYCuS1VsB6DbGETUmja
         PWKRakxG5PQemAvK5i41PZSQxP1Zb0KiOwuc6pXtnp7nS7GPjQ9soACXaPIznV41GEnX
         L4B4/dgBfggNA4wXKyBrAr9NhN87i9n2HOQQE=
MIME-Version: 1.0
In-Reply-To: <201105240059.p4O0xPfN009516@hera.kernel.org>
References: <201105240059.p4O0xPfN009516@hera.kernel.org>
Date: Wed, 8 Jun 2011 20:53:23 +0200
X-Google-Sender-Auth: gKUiLkd9phkAGdwO0-IUO4hlBgg
Message-ID: <BANLkTim1=DBd1AvPw1VuPfGi_Z5ktAhyPg@mail.gmail.com>
Subject: Re: ARM: 6910/1: MTD: physmap: let set_vpp() pass a platform_device
 instead of a map_info
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 02:59, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
>    ARM: 6910/1: MTD: physmap: let set_vpp() pass a platform_device instead of a map_info
>
>    The set_vpp() method provided by physmap passes a map_info back to
>    the platform code, which has little relevance as far as the platform
>    is concerned (this parameter is completely unused).
>
>    Instead, pass the platform_device, which can be used in the pismo
>    driver to retrieve some important information in a nicer way, instead
>    of the hack that was in place.
>
>    The empty set_vpp function in board-at572d940hf_ek.c is left untouched,
>    as the board/SoC is scheduled for removal.
>
>    Cc: Andrew Victor <linux@maxim.org.za>
>    Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
>    Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>    Cc: Philipp Zabel <philipp.zabel@gmail.com>
>    Cc: Eric Miao <eric.y.miao@gmail.com>
>    Cc: Ben Dooks <ben-linux@fluff.org>
>    Acked-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
>    Acked-by: David Woodhouse <dwmw2@infradead.org>
>    Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

> --- a/include/linux/mtd/physmap.h
> +++ b/include/linux/mtd/physmap.h
> @@ -24,7 +24,7 @@ struct physmap_flash_data {
>        unsigned int            width;
>        int                     (*init)(struct platform_device *);
>        void                    (*exit)(struct platform_device *);
> -       void                    (*set_vpp)(struct map_info *, int);
> +       void                    (*set_vpp)(struct platform_device *, int);
>        unsigned int            nr_parts;
>        unsigned int            pfow_base;
>        char                    *probe_type;

You forgot to update the set_vpp parameter of physmap_configure():

void physmap_configure(unsigned long addr, unsigned long size,
                int bankwidth, void (*set_vpp)(struct map_info *, int) );

causing

drivers/mtd/maps/physmap.c: In function ‘physmap_configure’:
drivers/mtd/maps/physmap.c:255: warning: assignment from incompatible
pointer type

Interestingly, there are no (in-tree) users of physmap_configure()?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
