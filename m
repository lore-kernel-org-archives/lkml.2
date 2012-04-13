Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab2DMTMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:12:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45297 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab2DMTMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:12:22 -0400
MIME-Version: 1.0
In-Reply-To: <1330629779-1449-1-git-send-email-daniel.vetter@ffwll.ch>
References: <20120229153216.8c3ae31d.akpm@linux-foundation.org>
	<1330629779-1449-1-git-send-email-daniel.vetter@ffwll.ch>
Date: Fri, 13 Apr 2012 21:12:21 +0200
X-Google-Sender-Auth: U71WIKXrTjeWFyAK3ZOKsQv0rzc
Message-ID: <CAMuHMdXBEiDGyJQ+szoBKxo0pS=n3xKfpb=F+rNkMQUv4SdTQA@mail.gmail.com>
Subject: Re: [PATCH] mm: extend prefault helpers to fault in more than PAGE_SIZE
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 20:22, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> +/* Multipage variants of the above prefault helpers, useful if more than
> + * PAGE_SIZE of date needs to be prefaulted. These are separate from the above
> + * functions (which only handle up to PAGE_SIZE) to avoid clobbering the
> + * filemap.c hotpaths. */
> +static inline int fault_in_multipages_writeable(char __user *uaddr, int size)
> +{
> +       int ret;
> +       const char __user *end = uaddr + size - 1;

Please drop the const.

> +
> +       if (unlikely(size == 0))
> +               return 0;
> +
> +       /*
> +        * Writing zeroes into userspace here is OK, because we know that if
> +        * the zero gets there, we'll be overwriting it.
> +        */
> +       while (uaddr <= end) {
> +               ret = __put_user(0, uaddr);
> +               if (ret != 0)
> +                       return ret;
> +               uaddr += PAGE_SIZE;
> +       }
> +
> +       /* Check whether the range spilled into the next page. */
> +       if (((unsigned long)uaddr & PAGE_MASK) ==
> +                       ((unsigned long)end & PAGE_MASK))
> +               ret = __put_user(0, end);

include/linux/pagemap.h:483:3: error: read-only location '*end' used
as 'asm' output

Now in -next:

http://kisskb.ellerman.id.au/kisskb/buildresult/6100650/
http://kisskb.ellerman.id.au/kisskb/buildresult/6100673/
http://kisskb.ellerman.id.au/kisskb/buildresult/6100860/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
