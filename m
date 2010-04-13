Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab0DMHFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 03:05:06 -0400
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:52419 "EHLO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab0DMHFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 03:05:04 -0400
MIME-Version: 1.0
In-Reply-To: <w2z4810ea571004112250x855fadd5uecbc813726ae3412@mail.gmail.com>
References: <w2z4810ea571004112250x855fadd5uecbc813726ae3412@mail.gmail.com>
Date: Tue, 13 Apr 2010 15:05:00 +0800
Message-ID: <h2v5f4a33681004130005xc06eadf7jc94e9257c6af4350@mail.gmail.com>
Subject: Re: [PATCH - V2] Fix missing of last user while dumping slab 
	corruption log
From: TAO HU <tghk48@motorola.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mpm@selenic.com,
       linux-mm@kvack.org, dwmw2@infradead.org, TAO HU <taohu@motorola.com>,
       ShiYong LI <shi-yong.li@motorola.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,  Pekka Enberg

Actually we greped "kmem_cache_create" in whole kernel souce tree
(2.6.29 and 2.6.32).

Either "align" equal to "0" or flag SLAB_HWCACHE_ALIGN is used when
calling kmem_cache_create().
Seems all of arch's cache-line-size is multiple of 64-bit/8-byte
(sizeof(long long)) except  arch-microblaze (4-byte).
The smallest (except arch-microblaze) cache-line-size is 2^4= 16-byte
as I can see.
So even considering possible sizeof(long long) == 128-bit/16-byte, it
is still safe to apply Shiyong's original version.

Anyway, Shiyong's new patch check the weired situation that "align >
sizeof(long long) && align is NOT multiple of sizeof (long long)"
Let us know whether the new version address your concerns.

-- 
Best Regards
Hu Tao





On Mon, Apr 12, 2010 at 1:50 PM, ShiYong LI <shi-yong.li@motorola.com> wrote:
> Hi,
>
> Compared to previous version, add alignment checking to make sure
> memory space storing redzone2 and last user tags is 8 byte alignment.
>
> From 949e8c29e8681a2359e23a8fbd8b9d4833f42344 Mon Sep 17 00:00:00 2001
> From: Shiyong Li <shi-yong.li@motorola.com>
> Date: Mon, 12 Apr 2010 13:48:21 +0800
> Subject: [PATCH] Fix missing of last user info while getting
> DEBUG_SLAB config enabled.
>
> Even with SLAB_RED_ZONE and SLAB_STORE_USER enabled, kernel would NOT
> store redzone and last user data around allocated memory space if arch
> cache line > sizeof(unsigned long long). As a result, last user information
> is unexpectedly MISSED while dumping slab corruption log.
>
> This fix makes sure that redzone and last user tags get stored unless
> the required alignment breaks redzone's.
>
> Signed-off-by: Shiyong Li <shi-yong.li@motorola.com>
> ---
>  mm/slab.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/slab.c b/mm/slab.c
> index a8a38ca..b97c57e 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2267,8 +2267,8 @@ kmem_cache_create (const char *name, size_t
> size, size_t align,
>        if (ralign < align) {
>                ralign = align;
>        }
> -       /* disable debug if necessary */
> -       if (ralign > __alignof__(unsigned long long))
> +       /* disable debug if not aligning with REDZONE_ALIGN */
> +       if (ralign & (__alignof__(unsigned long long) - 1))
>                flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
>        /*
>         * 4) Store it.
> @@ -2289,8 +2289,8 @@ kmem_cache_create (const char *name, size_t
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
> --
> 1.6.0.4
>
>
>
>
>
> --
> Thanks & Best Regards
> Shiyong
>
