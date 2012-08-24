Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704Ab2HXQHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:07:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36253 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab2HXQG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:06:58 -0400
MIME-Version: 1.0
In-Reply-To: <1345042960-6287-2-git-send-email-js1304@gmail.com>
References: <1345042960-6287-1-git-send-email-js1304@gmail.com>
	<1345042960-6287-2-git-send-email-js1304@gmail.com>
Date: Sat, 25 Aug 2012 01:06:57 +0900
Message-ID: <CAAmzW4MjqETWfZuyzJUMF+5q-aGgZ20gKpgWSvFTYWp-LqdrHA@mail.gmail.com>
Subject: Re: [PATCH 2/2] slub: remove one code path and reduce lock contention
 in __slab_free()
From: JoonSoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/16 Joonsoo Kim <js1304@gmail.com>:
> When we try to free object, there is some of case that we need
> to take a node lock. This is the necessary step for preventing a race.
> After taking a lock, then we try to cmpxchg_double_slab().
> But, there is a possible scenario that cmpxchg_double_slab() is failed
> with taking a lock. Following example explains it.
>
> CPU A               CPU B
> need lock
> ...                 need lock
> ...                 lock!!
> lock..but spin      free success
> spin...             unlock
> lock!!
> free fail
>
> In this case, retry with taking a lock is occured in CPU A.
> I think that in this case for CPU A,
> "release a lock first, and re-take a lock if necessary" is preferable way.
>
> There are two reasons for this.
>
> First, this makes __slab_free()'s logic somehow simple.
> With this patch, 'was_frozen = 1' is "always" handled without taking a lock.
> So we can remove one code path.
>
> Second, it may reduce lock contention.
> When we do retrying, status of slab is already changed,
> so we don't need a lock anymore in almost every case.
> "release a lock first, and re-take a lock if necessary" policy is
> helpful to this.
>
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> Cc: Christoph Lameter <cl@linux.com>
> Acked-by: Christoph Lameter <cl@linux.com>
>
> diff --git a/mm/slub.c b/mm/slub.c
> index ca778e5..efce427 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2421,7 +2421,6 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
>         void *prior;
>         void **object = (void *)x;
>         int was_frozen;
> -       int inuse;
>         struct page new;
>         unsigned long counters;
>         struct kmem_cache_node *n = NULL;
> @@ -2433,13 +2432,17 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
>                 return;
>
>         do {
> +               if (unlikely(n)) {
> +                       spin_unlock_irqrestore(&n->list_lock, flags);
> +                       n = NULL;
> +               }
>                 prior = page->freelist;
>                 counters = page->counters;
>                 set_freepointer(s, object, prior);
>                 new.counters = counters;
>                 was_frozen = new.frozen;
>                 new.inuse--;
> -               if ((!new.inuse || !prior) && !was_frozen && !n) {
> +               if ((!new.inuse || !prior) && !was_frozen) {
>
>                         if (!kmem_cache_debug(s) && !prior)
>
> @@ -2464,7 +2467,6 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
>
>                         }
>                 }
> -               inuse = new.inuse;
>
>         } while (!cmpxchg_double_slab(s, page,
>                 prior, counters,
> @@ -2490,25 +2492,17 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
>                  return;
>          }
>
> +       if (unlikely(!new.inuse && n->nr_partial > s->min_partial))
> +               goto slab_empty;
> +
>         /*
> -        * was_frozen may have been set after we acquired the list_lock in
> -        * an earlier loop. So we need to check it here again.
> +        * Objects left in the slab. If it was not on the partial list before
> +        * then add it.
>          */
> -       if (was_frozen)
> -               stat(s, FREE_FROZEN);
> -       else {
> -               if (unlikely(!inuse && n->nr_partial > s->min_partial))
> -                        goto slab_empty;
> -
> -               /*
> -                * Objects left in the slab. If it was not on the partial list before
> -                * then add it.
> -                */
> -               if (unlikely(!prior)) {
> -                       remove_full(s, page);
> -                       add_partial(n, page, DEACTIVATE_TO_TAIL);
> -                       stat(s, FREE_ADD_PARTIAL);
> -               }
> +       if (kmem_cache_debug(s) && unlikely(!prior)) {
> +               remove_full(s, page);
> +               add_partial(n, page, DEACTIVATE_TO_TAIL);
> +               stat(s, FREE_ADD_PARTIAL);
>         }
>         spin_unlock_irqrestore(&n->list_lock, flags);
>         return;
> --
> 1.7.9.5
>

Hello, Pekka.
Could you review this patch and comment it, please?
