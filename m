Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab0DGPZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:25:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:29579 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab0DGPZd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=APoVbA+aemjlchRnYBXcDYeGzsPAvrP0cPxbeOGl+vEaKyF+U48rHJPJn+7fNJLl+r
         hqrso63I4MLwCWg7Q2ObNBKH/YJgRS6NwIA7m5vCDC//MxTC8HuEqHkZgLBATtgedW7b
         aTCQZ1wEqDmlM/ivZ3mIkDYLrERb7/cOFKVQ0=
MIME-Version: 1.0
In-Reply-To: <k2s4810ea571004020021hade8123mb571b803b8472aef@mail.gmail.com>
References: <k2s4810ea571004020021hade8123mb571b803b8472aef@mail.gmail.com>
Date: Wed, 7 Apr 2010 18:25:31 +0300
X-Google-Sender-Auth: 270d9ee67d769449
Message-ID: <p2k84144f021004070825jd3530d04v9d339c8d50c4593d@mail.gmail.com>
Subject: Re: [PATCH] Fix missing of last user while dumping slab corruption 
	log
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ShiYong LI <a22381@motorola.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mpm@selenic.com,
       linux-mm@kvack.org, tghk48@motorola.com, dwmw2@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(I'm cc'ing David who did some fixes in this area previously.)

On Fri, Apr 2, 2010 at 10:21 AM, ShiYong LI <a22381@motorola.com> wrote:
> Even with SLAB_RED_ZONE and SLAB_STORE_USER enabled, kernel would NOT
> store redzone and last user data around allocated memory space if arch
> cache line > sizeof(unsigned long long). As a result, last user information
> is unexpectedly MISSED while dumping slab corruption log.
>
> This patch makes sure that redzone and last user tags get stored whatever
> arch cache line.
>
> Compared to original codes, the change surely affects head redzone (redzone1).
> Actually, with SLAB_RED_ZONE and SLAB_STORE_USER enabled,
> allocated memory layout is as below:
>
> [ redzone1 ]   <--------- Affected area.
> [ real object space ]
> [ redzone2 ]
> [ last user ]
> [ ... ]
>
> Let's do some analysis: (whatever SLAB_STORE_USER is).
>
> 1) With SLAB_RED_ZONE on, "align" >= sizeof(unsigned long long) according to
>    the following codes:
>        /* 2) arch mandated alignment */
>        if (ralign < ARCH_SLAB_MINALIGN) {
>                ralign = ARCH_SLAB_MINALIGN;
>        }
>        /* 3) caller mandated alignment */
>        if (ralign < align) {
>                ralign = align;
>        }
>        ...
>        /*
>         * 4) Store it.
>         */
>        align = ralign;
>
>    That's to say, could guarantee that redzone1 does NOT get broken
> at all. Meanwhile,
>    Real object space could meet the need of cache line size by using
> "align"  argument.
>
> 2) With SLAB_RED_ZONE off, the change has no impact.
>
>
> From 03b28964311090533643acd267abe0cbc3c9b0a5 Mon Sep 17 00:00:00 2001
> From: Shiyong Li <shi-yong.li@motorola.com>
> Date: Fri, 2 Apr 2010 14:50:30 +0800
> Subject: [PATCH] Fix missing of last user info while getting
> DEBUG_SLAB config enabled.
>
> Even with SLAB_RED_ZONE and SLAB_STORE_USER enabled, kernel would NOT
> store redzone and last user data around allocated memory space if arch
> cache line > sizeof(unsigned long long). As a result, last user information
> is unexpectedly MISSED while dumping slab corruption log.
>
> This fix makes sure that redzone and last user tags get stored whatever
> cache line.
>
> Signed-off-by: Shiyong Li <shi-yong.li@motorola.com>
> ---
>  mm/slab.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/mm/slab.c b/mm/slab.c
> index a8a38ca..84af997 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2267,9 +2267,6 @@ kmem_cache_create (const char *name, size_t
> size, size_t align,
>        if (ralign < align) {
>                ralign = align;
>        }
> -       /* disable debug if necessary */
> -       if (ralign > __alignof__(unsigned long long))
> -               flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
>        /*
>         * 4) Store it.
>         */
> @@ -2289,8 +2286,8 @@ kmem_cache_create (const char *name, size_t
> size, size_t align,
>         */
>        if (flags & SLAB_RED_ZONE) {
>                /* add space for red zone words */
> -               cachep->obj_offset += sizeof(unsigned long long);
> -               size += 2 * sizeof(unsigned long long);
> +               cachep->obj_offset += align;
> +               size += align + sizeof(unsigned long long);
>        }
>        if (flags & SLAB_STORE_USER) {
>                /* user store requires one word storage behind the end of

The problem I have with this patch is that I am unable to convince
myself that it's correct.

The code in question is pretty hard to follow and it can break on
architectures with strict alignment requirements. I'm not sure I fully
understand why we've been disabling debugging in the first place.

On which architectures have you verified this fix?

                        Pekka
