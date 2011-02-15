Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab1BOFs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 00:48:28 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54978 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab1BOFsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 00:48:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=aecFojEIviTOgBXXdAY+xDiOhn84ZLqXxIIGlQUgib3wy9wlYnNliAQg2Jd+6MNqXG
         dxwkzUxOnoxnICxxKuR+8u/Nzp93Va6HcnO68WmcB3q/cYvZUTYZTKa54dhtdB5DYWC6
         Za569H4ZhP9gN8Nxb0+Hwp2QPJ9QHtWW0bgoU=
MIME-Version: 1.0
In-Reply-To: <1297704922.2996.60.camel@edumazet-laptop>
References: <bug-27212-10286@https.bugzilla.kernel.org/>
	<20110120122549.85863a84.akpm@linux-foundation.org>
	<1295556085.2613.22.camel@edumazet-laptop>
	<4D393A99.9060104@kernel.org>
	<1297704922.2996.60.camel@edumazet-laptop>
Date: Tue, 15 Feb 2011 07:48:23 +0200
X-Google-Sender-Auth: 9fkfpWD_StqRo6aQ6A122WlLPRc
Message-ID: <AANLkTinKTdeO5mnE38n==aZMz5P1XKKM+kykhoBu0=9k@mail.gmail.com>
Subject: Re: [Bugme-new] [Bug 27212] New: Warning kmemcheck: Caught 64-bit
 read from uninitialized memory in netlink_broadcast_filtered
From: Pekka Enberg <penberg@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
        casteyde.christian@free.fr, Changli Gao <xiaosuo@gmail.com>,
        Vegard Nossum <vegardno@ifi.uio.no>,
        David Miller <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 7:35 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le vendredi 21 janvier 2011 à 09:49 +0200, Pekka Enberg a écrit :
>
>> It actually looks like a bug in SLUB+kmemcheck. The
>> kmemcheck_slab_alloc() call in slab_post_alloc_hook() should use ksize()
>> instead of s->objsize. SLAB seems to do the right thing already. Anyone
>> care to send a patch my way?
>>
>
> Hmm, what do you think of following patch ?
>
> Thanks, and sorry for the delay.

Looks good to me. Christoph, David, any objections to the patch?

> [PATCH] slub: fix kmemcheck calls to match ksize() hints
>
> Recent use of ksize() in network stack (commit ca44ac38 : net: don't
> reallocate skb->head unless the current one hasn't the needed extra size
> or is shared) triggers kmemcheck warnings, because ksize() can return
> more space than kmemcheck is aware of.
>
> Pekka Enberg noticed SLAB+kmemcheck is doing the right thing, while SLUB
> +kmemcheck doesnt.
>
> Bugzilla reference #27212
>
> Reported-by: Christian Casteyde <casteyde.christian@free.fr>
> Suggested-by: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> CC: David Miller <davem@davemloft.net>
> CC: Changli Gao <xiaosuo@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> ---
>  mm/slub.c |   49 ++++++++++++++++++++++++++-----------------------
>  1 file changed, 26 insertions(+), 23 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index e15aa7f..ee0aeb8 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -797,10 +797,34 @@ static inline int slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
>        return should_failslab(s->objsize, flags, s->flags);
>  }
>
> +static inline size_t slab_ksize(const struct kmem_cache *s)
> +{
> +#ifdef CONFIG_SLUB_DEBUG
> +       /*
> +        * Debugging requires use of the padding between object
> +        * and whatever may come after it.
> +        */
> +       if (s->flags & (SLAB_RED_ZONE | SLAB_POISON))
> +               return s->objsize;
> +
> +#endif
> +       /*
> +        * If we have the need to store the freelist pointer
> +        * back there or track user information then we can
> +        * only use the space before that information.
> +        */
> +       if (s->flags & (SLAB_DESTROY_BY_RCU | SLAB_STORE_USER))
> +               return s->inuse;
> +       /*
> +        * Else we can use all the padding etc for the allocation
> +        */
> +       return s->size;
> +}
> +
>  static inline void slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags, void *object)
>  {
>        flags &= gfp_allowed_mask;
> -       kmemcheck_slab_alloc(s, flags, object, s->objsize);
> +       kmemcheck_slab_alloc(s, flags, object, slab_ksize(s));
>        kmemleak_alloc_recursive(object, s->objsize, 1, s->flags, flags);
>  }
>
> @@ -2696,7 +2720,6 @@ EXPORT_SYMBOL(__kmalloc_node);
>  size_t ksize(const void *object)
>  {
>        struct page *page;
> -       struct kmem_cache *s;
>
>        if (unlikely(object == ZERO_SIZE_PTR))
>                return 0;
> @@ -2707,28 +2730,8 @@ size_t ksize(const void *object)
>                WARN_ON(!PageCompound(page));
>                return PAGE_SIZE << compound_order(page);
>        }
> -       s = page->slab;
>
> -#ifdef CONFIG_SLUB_DEBUG
> -       /*
> -        * Debugging requires use of the padding between object
> -        * and whatever may come after it.
> -        */
> -       if (s->flags & (SLAB_RED_ZONE | SLAB_POISON))
> -               return s->objsize;
> -
> -#endif
> -       /*
> -        * If we have the need to store the freelist pointer
> -        * back there or track user information then we can
> -        * only use the space before that information.
> -        */
> -       if (s->flags & (SLAB_DESTROY_BY_RCU | SLAB_STORE_USER))
> -               return s->inuse;
> -       /*
> -        * Else we can use all the padding etc for the allocation
> -        */
> -       return s->size;
> +       return slab_ksize(page->slab);
>  }
>  EXPORT_SYMBOL(ksize);
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
