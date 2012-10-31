Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935047Ab2JaH7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:59:46 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63679 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab2JaH7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:59:41 -0400
MIME-Version: 1.0
In-Reply-To: <1350386231-770-1-git-send-email-matthieu.castet@parrot.com>
References: <1350386231-770-1-git-send-email-matthieu.castet@parrot.com>
Date: Wed, 31 Oct 2012 09:59:40 +0200
X-Google-Sender-Auth: 08paSUQIyRbAQS_kElBNSuLoZzw
Message-ID: <CAOJsxLHQy7pshnskn+wMp=1D9+9wGQZBhFD+kjtbCSJvoW7q2Q@mail.gmail.com>
Subject: Re: [PATCH] slab : allow SLAB_RED_ZONE and SLAB_STORE_USER to work on arm
From: Pekka Enberg <penberg@kernel.org>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Matthieu CASTET <castet.matthieu@free.fr>,
        Russell King <rmk@arm.linux.org.uk>,
        Shiyong Li <shi-yong.li@motorola.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(Adding more people to CC.)

On Tue, Oct 16, 2012 at 2:17 PM, Matthieu CASTET
<matthieu.castet@parrot.com> wrote:
> From: Matthieu CASTET <castet.matthieu@free.fr>
>
> on cortexA8 (omap3) ralign is 64 and __alignof__(unsigned long long) is 8.
> So we always disable debug.
>
> This patch is based on 5c5e3b33b7cb959a401f823707bee006caadd76e, but fix
> case were align < sizeof(unsigned long long).
>
> Signed-off-by: Matthieu Castet <matthieu.castet@parrot.com>
> CC: Russell King <rmk@arm.linux.org.uk>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  mm/slab.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/mm/slab.c b/mm/slab.c
> index c685475..8427901 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2462,9 +2462,6 @@ __kmem_cache_create (const char *name, size_t size, size_t align,
>         if (ralign < align) {
>                 ralign = align;
>         }
> -       /* disable debug if necessary */
> -       if (ralign > __alignof__(unsigned long long))
> -               flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
>         /*
>          * 4) Store it.
>          */
> @@ -2491,8 +2488,9 @@ __kmem_cache_create (const char *name, size_t size, size_t align,
>          */
>         if (flags & SLAB_RED_ZONE) {
>                 /* add space for red zone words */
> -               cachep->obj_offset += sizeof(unsigned long long);
> -               size += 2 * sizeof(unsigned long long);
> +               int offset = max(align, sizeof(unsigned long long));
> +               cachep->obj_offset += offset;
> +               size += offset + sizeof(unsigned long long);
>         }
>         if (flags & SLAB_STORE_USER) {
>                 /* user store requires one word storage behind the end of

This piece of code tends to break in peculiar ways every time someone
touches it. I could use some more convincing in the changelog this
time it won't...
