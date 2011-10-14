Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab1JNXZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 19:25:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46232 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab1JNXZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 19:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <17609.1318584129@redhat.com>
References: <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com>
	<2150.1314882260@redhat.com>
	<CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com>
	<CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com>
	<5149.1317036720@redhat.com>
	<CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com>
	<CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com>
	<6324.1317308270@redhat.com>
	<CAOH1cHn0tc-_dFe1PovpKmTE5pnMp40ZXi5TR9+i=ozviTdinA@mail.gmail.com>
	<12748.1317313818@redhat.com>
	<CAOH1cHmFuXn3uZbyZy94-cBGCPDxLsJuskkYRteeBs75iLhssw@mail.gmail.com>
	<CAOH1cHn3_aeVYC73YO43zf5piKOO_=MJwbbVfhW8eAWnDahRrw@mail.gmail.com>
	<18003.1317336244@redhat.com>
	<CAOH1cHmeX56+dZEidR4AAwEkz2kr7-J12vky5G8s0vzfbO39yw@mail.gmail.com>
	<6261.1317385734@redhat.com>
	<CAOH1cHkVjTSBvqvaoWnxTB1V-dOtj1cCT_kMZpJdsyNNeUoBag@mail.gmail.com>
	<8905.1317984176@redhat.com>
	<9908.1318413955@redhat.com>
	<CAOH1cHkg_eQRCHxOxiOPgO=-aZfnjts-tLFQFKffk5JjEfqy2w@mail.gmail.com>
	<CAOH1cHnagaAVQ+8h_thqe7sneeiE6dCcD-U_NgZoO2PZRbixMg@mail.gmail.com>
	<32454.1318519287@redhat.com>
	<CAOH1cHkFitTHBkHzg+m7cZycOZTgWW8hF0g0=+pX6bPNVZNTxw@mail.gmail.com>
	<17609.1318584129@redhat.com>
Date: Fri, 14 Oct 2011 16:25:03 -0700
Message-ID: <CAOH1cHkrtzr4o=ygqrMnUfDhwC=U+QJOtuqS+vfQyeXP_TvjaQ@mail.gmail.com>
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
From: Mark Moseley <moseleymark@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=bcaec520e903135baa04af4a9113
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec520e903135baa04af4a9113
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 14, 2011 at 2:22 AM, David Howells <dhowells@redhat.com> wrote:
> Mark Moseley <moseleymark@gmail.com> wrote:
>
>> > Did you look at /proc/fs/fscache/stats at all?
>>
>> I didn't but I can repeat it. Which of the stats in
>> /proc/fs/fscache/stats would be best to track?
>
> If you could get two snapshots a couple of minutes apart, that'd be usefu=
l.
> What I'm interested in is what stops changing and anything in the CacheOp=
 list
> at the bottom that becomes wedged on a non-zero value.

Patch is applied. I'm attaching a file with stats and a df of the
fscache partition. I cleared the cache and waited till it got
reasonably full before starting this capture. No crash yet, btw.

You can see that for the past couple of hours the byte counts on the
partition have only fluctuated a handful of Kb.

Incidentally, my cachefilesd.conf (I don't think I've sent it before
in this thread):

# cat /etc/cachefilesd.conf
dir /var/cache/fscache
tag mycache
brun  40%
bcull 30%
bstop 20%
frun  10%
fcull 7%
fstop 3%
culltable 20


# cachefilesd -v
cachefilesd version 0.10.1


Presumably it gets to bcull and stops storing but nothing's getting
pruned. I can see cachefilesd is in constant activity right now.
Looking at strace, maybe it can't find anything to prune because it
thinks it's all active. I'm seeing a constant loop that looks similar
to this:

read(3, "cull=3D1 frun=3D2d82a fcull=3D1fdb7 fst"..., 4096) =3D 78
fchdir(11)                              =3D 0
newfstatat(11, "@9c", {st_mode=3D02, st_size=3D17592186044416, ...}, 0) =3D=
 0
read(3, "cull=3D1 frun=3D2d82a fcull=3D1fdb7 fst"..., 4096) =3D 78
openat(11, "@9c", O_RDONLY|O_DIRECTORY) =3D 12
fstat(12, {st_mode=3DS_IFDIR, st_size=3D4096, ...}) =3D 0
fcntl(12, F_GETFL)                      =3D 0x18000 (flags
O_RDONLY|O_LARGEFILE|O_DIRECTORY)
fcntl(12, F_SETFD, FD_CLOEXEC)          =3D 0
fchdir(12)                              =3D 0
getdents(12, /* 23 entries */, 4096)    =3D 1896
newfstatat(12, "EI0001000Pgb0020000gvF0l0uU2L1QQG0080000001000IVThl4g000000=
000000",
{st_mode=3D01, st_size=3D5566277615616, ...}, 0) =3D 0
write(3, "inuse EI0001000Pgb0020000gvF0l0uU"..., 71) =3D -1 EBUSY
(Device or resource busy)
newfstatat(12, "EI0001000Pgb0020000gUSTv0lC2p9QQG0080000001000IVThl4g000000=
000000",
{st_mode=3D01, st_size=3D87170656239616, ...}, 0) =3D 0
write(3, "inuse EI0001000Pgb0020000gUSTv0lC"..., 71) =3D -1 EBUSY
(Device or resource busy)
newfstatat(12, "EI0001000Pgb00200000PHNi0Q1O11QQG0080000001000IVThl4g000000=
000000",
{st_mode=3D01, st_size=3D24099061497856, ...}, 0) =3D 0
write(3, "inuse EI0001000Pgb00200000PHNi0Q1"..., 71) =3D -1 EBUSY
(Device or resource busy)
newfstatat(12, "EI0001000Pgb0020000Mfm2f05I6O3QQG0080000001000IVThl4g000000=
000000",
{st_mode=3D01, st_size=3D36807869726720, ...}, 0) =3D 0
write(3, "inuse EI0001000Pgb0020000Mfm2f05I"..., 71) =3D -1 EBUSY
(Device or resource busy)
newfstatat(12, "EI0001000Pgb0020000MoS5j0667-2QQG0080000001000IVThl4g000000=
000000",
{st_mode=3D01, st_size=3D10642928959488, ...}, 0) =3D 0
write(3, "inuse EI0001000Pgb0020000MoS5j066"..., 71) =3D -1 EBUSY
(Device or resource busy)
newfstatat(12, "EI0001000Pgb0020000gaRds0iBnFKQQG0080000001000IVThl4g000000=
000000",
{st_mode=3D01, st_size=3D7314329305088, ...}, 0) =3D 0
write(3, "inuse EI0001000Pgb0020000gaRds0iB"..., 71) =3D -1 EBUSY
(Device or resource busy)
newfstatat(12, "EI0001000Pgb00200000794b0y2CYSQQG0080000001000IVThl4g000000=
000000",
{st_mode=3D01, st_size=3D22020297326592, ...}, 0) =3D 0
write(3, "inuse EI0001000Pgb00200000794b0y2"..., 71) =3D -1 EBUSY
(Device or resource busy)
newfstatat(12, "EI0001000Pgb0020000MGKZd0sai09RQG0080000001000IVThl4g000000=
000000",
{st_mode=3D01, st_size=3D210453397504, ...}, 0) =3D 0
write(3, "inuse EI0001000Pgb0020000MGKZd0sa"..., 71) =3D -1 EBUSY
(Device or resource busy)
newfstatat(12, "EI0001000Pgb00200000G07d0bH5AiQQG0080000001000IVThl4g000000=
000000",
{st_mode=3D01, st_size=3D16892106375168, ...}, 0) =3D 0
write(3, "inuse EI0001000Pgb00200000G07d0bH"..., 71) =3D -1 EBUSY
(Device or resource busy)
newfstatat(12, "EI0001000Pgb00200000ytn40zr8X1QQG0080000001000IVThl4g000000=
000000",
{st_mode=3D01, st_size=3D129596343189504, ...}, 0) =3D 0




>> >> [20839.802118] kernel BUG at fs/fscache/object-list.c:83!
>> >> [20839.802733] invalid opcode: 0000 [#1] SMP
>> >
>> > That fits with the previous BUG elsewhere in object-list.c. =A0It soun=
ds like
>> > there's a refcounting problem somewhere.
>>
>> Any sys or proc settings I should turn on to track that?
>
> Not really. =A0However, if you could apply the attached patch, it will mo=
ve the
> object list handling to next to where the object allocation and freeing i=
s
> done. =A0I'm curious to see if this makes a difference.
>
> The 'object list' is an RB tree keyed on the address of an object in RAM =
- so
> if an object is already there it must have been double-added somehow or m=
ust
> not have been removed.
>
> David
> ---
>
> =A0fs/cachefiles/interface.c =A0 =A0 | =A0 =A01 +
> =A0fs/fscache/cache.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A01 -
> =A0fs/fscache/cookie.c =A0 =A0 =A0 =A0 =A0 | =A0 =A01 -
> =A0fs/fscache/object-list.c =A0 =A0 =A0| =A0 =A01 +
> =A0include/linux/fscache-cache.h | =A0 19 +++++++++++--------
> =A05 files changed, 13 insertions(+), 10 deletions(-)
>
>
> diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
> index ef5c02d..3dcecdf 100644
> --- a/fs/cachefiles/interface.c
> +++ b/fs/cachefiles/interface.c
> @@ -104,6 +104,7 @@ nomem_key:
> =A0 =A0 =A0 =A0kfree(buffer);
> =A0nomem_buffer:
> =A0 =A0 =A0 =A0BUG_ON(test_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags))=
;
> + =A0 =A0 =A0 fscache_object_destroy(&object->fscache);
> =A0 =A0 =A0 =A0kmem_cache_free(cachefiles_object_jar, object);
> =A0 =A0 =A0 =A0fscache_object_destroyed(&cache->cache);
> =A0nomem_object:
> diff --git a/fs/fscache/cache.c b/fs/fscache/cache.c
> index b52aed1..98bca68 100644
> --- a/fs/fscache/cache.c
> +++ b/fs/fscache/cache.c
> @@ -263,7 +263,6 @@ int fscache_add_cache(struct fscache_cache *cache,
> =A0 =A0 =A0 =A0spin_lock(&cache->object_list_lock);
> =A0 =A0 =A0 =A0list_add_tail(&ifsdef->cache_link, &cache->object_list);
> =A0 =A0 =A0 =A0spin_unlock(&cache->object_list_lock);
> - =A0 =A0 =A0 fscache_objlist_add(ifsdef);
>
> =A0 =A0 =A0 =A0/* add the cache's netfs definition index object to the to=
p level index
> =A0 =A0 =A0 =A0 * cookie as a known backing object */
> diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
> index 8dcb114..47d8cde 100644
> --- a/fs/fscache/cookie.c
> +++ b/fs/fscache/cookie.c
> @@ -360,7 +360,6 @@ static int fscache_attach_object(struct fscache_cooki=
e *cookie,
> =A0 =A0 =A0 =A0atomic_inc(&cookie->usage);
> =A0 =A0 =A0 =A0hlist_add_head(&object->cookie_link, &cookie->backing_obje=
cts);
>
> - =A0 =A0 =A0 fscache_objlist_add(object);
> =A0 =A0 =A0 =A0ret =3D 0;
>
> =A0cant_attach_object:
> diff --git a/fs/fscache/object-list.c b/fs/fscache/object-list.c
> index f27c89d..f8fbb32 100644
> --- a/fs/fscache/object-list.c
> +++ b/fs/fscache/object-list.c
> @@ -69,6 +69,7 @@ void fscache_objlist_add(struct fscache_object *obj)
>
> =A0 =A0 =A0 =A0write_unlock(&fscache_object_list_lock);
> =A0}
> +EXPORT_SYMBOL(fscache_objlist_add);
>
> =A0/**
> =A0* fscache_object_destroy - Note that a cache object is about to be des=
troyed
> diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.=
h
> index 633b65d..f657c0a 100644
> --- a/include/linux/fscache-cache.h
> +++ b/include/linux/fscache-cache.h
> @@ -440,6 +440,14 @@ extern const char *fscache_object_states[];
>
> =A0extern void fscache_object_work_func(struct work_struct *work);
>
> +#ifdef CONFIG_FSCACHE_OBJECT_LIST
> +extern void fscache_objlist_add(struct fscache_object *obj);
> +extern void fscache_object_destroy(struct fscache_object *object);
> +#else
> +#define fscache_object_destroy(object) do {} while(0)
> +#define fscache_objlist_add(object) do {} while(0)
> +#endif
> +
> =A0/**
> =A0* fscache_object_init - Initialise a cache object description
> =A0* @object: Object description
> @@ -454,8 +462,6 @@ void fscache_object_init(struct fscache_object *objec=
t,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct fscache_cookie *co=
okie,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct fscache_cache *cac=
he)
> =A0{
> - =A0 =A0 =A0 atomic_inc(&cache->object_count);
> -
> =A0 =A0 =A0 =A0object->state =3D FSCACHE_OBJECT_INIT;
> =A0 =A0 =A0 =A0spin_lock_init(&object->lock);
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&object->cache_link);
> @@ -473,17 +479,14 @@ void fscache_object_init(struct fscache_object *obj=
ect,
> =A0 =A0 =A0 =A0object->cache =3D cache;
> =A0 =A0 =A0 =A0object->cookie =3D cookie;
> =A0 =A0 =A0 =A0object->parent =3D NULL;
> +
> + =A0 =A0 =A0 atomic_inc(&cache->object_count);
> + =A0 =A0 =A0 fscache_objlist_add(object);
> =A0}
>
> =A0extern void fscache_object_lookup_negative(struct fscache_object *obje=
ct);
> =A0extern void fscache_obtained_object(struct fscache_object *object);
>
> -#ifdef CONFIG_FSCACHE_OBJECT_LIST
> -extern void fscache_object_destroy(struct fscache_object *object);
> -#else
> -#define fscache_object_destroy(object) do {} while(0)
> -#endif
> -
> =A0/**
> =A0* fscache_object_destroyed - Note destruction of an object in a cache
> =A0* @cache: The cache from which the object came
>
>

--bcaec520e903135baa04af4a9113
Content-Type: application/x-gzip; name="fscache.stats.gz"
Content-Disposition: attachment; filename="fscache.stats.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtrsua8b0

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
--bcaec520e903135baa04af4a9113--
