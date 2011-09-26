Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab1IZVCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 17:02:15 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35206 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab1IZVCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 17:02:14 -0400
MIME-Version: 1.0
In-Reply-To: <5149.1317036720@redhat.com>
References: <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com>
	<2150.1314882260@redhat.com>
	<CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com>
	<CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com>
	<5149.1317036720@redhat.com>
Date: Mon, 26 Sep 2011 14:02:13 -0700
Message-ID: <CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com>
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
From: Mark Moseley <moseleymark@gmail.com>
Cc: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 4:32 AM, David Howells <dhowells@redhat.com> wrote:
> Mark Moseley <moseleymark@gmail.com> wrote:
>
>> I thought I'd be extra-helpful by getting that trace with a 3.0.4
>> kernel but got a completely different error this time (there was
>> nothing logged above this though). There was a
>> '__fscache_read_or_alloc_pages' crash for the previous boot too,
>> though it went for about 2.5 hours that time (with an empty cache
>> partition though).
>
> I'm fairly certain I know what the cause of this one is: Invalidation upon
> server change isn't handled correctly.  NFS tries to invalidate a file by
> discarding that file's attachment to the cache - without first clearing up the
> operations it has outstanding on the cache for that file.
>
> I'm working on adding formal invalidation at the moment.
>
> The attached patch may get you more precise information.  The first hunk is the
> main catcher.
>
> David
> ---
> diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
> index 9905350..48c63b8 100644
> --- a/fs/fscache/cookie.c
> +++ b/fs/fscache/cookie.c
> @@ -452,6 +452,13 @@ void __fscache_relinquish_cookie(struct fscache_cookie *cookie, int retire)
>
>                _debug("RELEASE OBJ%x", object->debug_id);
>
> +               if (atomic_read(&object->n_reads)) {
> +                       spin_unlock(&cookie->lock);
> +                       printk(KERN_ERR "FS-Cache: Cookie '%s' still has outstanding reads\n",
> +                              cookie->def->name);
> +                       BUG();
> +               }
> +
>                /* detach each cache object from the object cookie */
>                spin_lock(&object->lock);
>                hlist_del_init(&object->cookie_link);
> diff --git a/fs/fscache/page.c b/fs/fscache/page.c
> index b8b62f4..f087051 100644
> --- a/fs/fscache/page.c
> +++ b/fs/fscache/page.c
> @@ -496,6 +496,7 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
>        if (fscache_submit_op(object, &op->op) < 0)
>                goto nobufs_unlock;
>        spin_unlock(&cookie->lock);
> +       ASSERTCMP(object->cookie, ==, cookie);
>
>        fscache_stat(&fscache_n_retrieval_ops);
>
> @@ -513,6 +514,26 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
>                goto error;
>
>        /* ask the cache to honour the operation */
> +       if (!object->cookie) {
> +               const char prefix[] = "fs-";
> +               printk(KERN_ERR "%sobject: OBJ%x\n",
> +                      prefix, object->debug_id);
> +               printk(KERN_ERR "%sobjstate=%s fl=%lx wbusy=%x ev=%lx[%lx]\n",
> +                      prefix, fscache_object_states[object->state],
> +                      object->flags, work_busy(&object->work),
> +                      object->events,
> +                      object->event_mask & FSCACHE_OBJECT_EVENTS_MASK);
> +               printk(KERN_ERR "%sops=%u inp=%u exc=%u\n",
> +                      prefix, object->n_ops, object->n_in_progress,
> +                      object->n_exclusive);
> +               printk(KERN_ERR "%sparent=%p\n",
> +                      prefix, object->parent);
> +               printk(KERN_ERR "%scookie=%p [pr=%p nd=%p fl=%lx]\n",
> +                      prefix, object->cookie,
> +                      cookie->parent, cookie->netfs_data, cookie->flags);
> +       }
> +       ASSERTCMP(object->cookie, ==, cookie);
> +
>        if (test_bit(FSCACHE_COOKIE_NO_DATA_YET, &object->cookie->flags)) {
>                fscache_stat(&fscache_n_cop_allocate_pages);
>                ret = object->cache->ops->allocate_pages(
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Ok, patched and running now. This same box was running 3.0.3 over the
weekend but it died without a stacktrace (and I had set it up to not
start cachefilesd on boot for the next boot). After I get the trace
for 3.0.4, I'll boot back into 3.0.3 and see if I can get that
previous trace again.
