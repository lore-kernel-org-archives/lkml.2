Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab1LJOcu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 09:32:50 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34745 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1LJOct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 09:32:49 -0500
MIME-Version: 1.0
In-Reply-To: <20111210104840.107647845@chello.nl>
References: <20111210104341.592561407@chello.nl>
	<20111210104840.107647845@chello.nl>
Date: Sat, 10 Dec 2011 22:32:48 +0800
Message-ID: <CACVXFVO7jtONN=Dbi-64n8Q-1Rbs9gNgsp6Qq5-o3NBAKTrNbw@mail.gmail.com>
Subject: Re: [PATCH 1/3] kref: Inline all functions
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Dec 10, 2011 at 6:43 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> These are tiny functions, there's no point in having them out-of-line.

Looks like no much text size increase in built vmlinux for ARM.

[tom@linux-2.6-omap]$size vmlinux
   text	   data	    bss	    dec	    hex	filename
6030247	2083292	7912356	16025895	 f48927	vmlinux

[tom@linux-2.6-omap]$size vmlinux-before-kref-inline
   text	   data	    bss	    dec	    hex	filename
6023264	2083300	7912356	16018920	 f46de8	vmlinux-before-kref-inline

>
> Cc: adobriyan@gmail.com
> Cc: eric.dumazet@gmail.com
> Cc: mingo@elte.hu
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/kref.h |   79 ++++++++++++++++++++++++++++++++++++++---
>  lib/Makefile         |    2 -
>  lib/kref.c           |   97 ---------------------------------------------------
>  3 files changed, 75 insertions(+), 103 deletions(-)
>
> Index: linux-2.6/include/linux/kref.h
> ===================================================================
> --- linux-2.6.orig/include/linux/kref.h
> +++ linux-2.6/include/linux/kref.h
> @@ -21,10 +21,79 @@ struct kref {
>        atomic_t refcount;
>  };
>
> -void kref_init(struct kref *kref);
> -void kref_get(struct kref *kref);
> -int kref_put(struct kref *kref, void (*release) (struct kref *kref));
> -int kref_sub(struct kref *kref, unsigned int count,
> -            void (*release) (struct kref *kref));
> +/**
> + * kref_init - initialize object.
> + * @kref: object in question.
> + */
> +static inline void kref_init(struct kref *kref)
> +{
> +       atomic_set(&kref->refcount, 1);
> +       smp_mb();
> +}
>
> +/**
> + * kref_get - increment refcount for object.
> + * @kref: object.
> + */
> +static inline void kref_get(struct kref *kref)
> +{
> +       WARN_ON(!atomic_read(&kref->refcount));
> +       atomic_inc(&kref->refcount);
> +       smp_mb__after_atomic_inc();
> +}
> +
> +/**
> + * kref_put - decrement refcount for object.
> + * @kref: object.
> + * @release: pointer to the function that will clean up the object when the
> + *          last reference to the object is released.
> + *          This pointer is required, and it is not acceptable to pass kfree
> + *          in as this function.
> + *
> + * Decrement the refcount, and if 0, call release().
> + * Return 1 if the object was removed, otherwise return 0.  Beware, if this
> + * function returns 0, you still can not count on the kref from remaining in
> + * memory.  Only use the return value if you want to see if the kref is now
> + * gone, not present.
> + */
> +static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref))
> +{
> +       WARN_ON(release == NULL);
> +       WARN_ON(release == (void (*)(struct kref *))kfree);

<linux/slab.h> is needed to avoid compiling failure.

> +
> +       if (atomic_dec_and_test(&kref->refcount)) {
> +               release(kref);
> +               return 1;
> +       }
> +       return 0;
> +}
> +
> +
> +/**
> + * kref_sub - subtract a number of refcounts for object.
> + * @kref: object.
> + * @count: Number of recounts to subtract.
> + * @release: pointer to the function that will clean up the object when the
> + *          last reference to the object is released.
> + *          This pointer is required, and it is not acceptable to pass kfree
> + *          in as this function.
> + *
> + * Subtract @count from the refcount, and if 0, call release().
> + * Return 1 if the object was removed, otherwise return 0.  Beware, if this
> + * function returns 0, you still can not count on the kref from remaining in
> + * memory.  Only use the return value if you want to see if the kref is now
> + * gone, not present.
> + */
> +static inline int kref_sub(struct kref *kref, unsigned int count,
> +            void (*release)(struct kref *kref))
> +{
> +       WARN_ON(release == NULL);
> +       WARN_ON(release == (void (*)(struct kref *))kfree);
> +
> +       if (atomic_sub_and_test((int) count, &kref->refcount)) {
> +               release(kref);
> +               return 1;
> +       }
> +       return 0;
> +}
>  #endif /* _KREF_H_ */
> Index: linux-2.6/lib/kref.c
> ===================================================================
> --- linux-2.6.orig/lib/kref.c
> +++ /dev/null
> @@ -1,97 +0,0 @@
> -/*
> - * kref.c - library routines for handling generic reference counted objects
> - *
> - * Copyright (C) 2004 Greg Kroah-Hartman <greg@kroah.com>
> - * Copyright (C) 2004 IBM Corp.
> - *
> - * based on lib/kobject.c which was:
> - * Copyright (C) 2002-2003 Patrick Mochel <mochel@osdl.org>
> - *
> - * This file is released under the GPLv2.
> - *
> - */
> -
> -#include <linux/kref.h>
> -#include <linux/module.h>
> -#include <linux/slab.h>
> -
> -/**
> - * kref_init - initialize object.
> - * @kref: object in question.
> - */
> -void kref_init(struct kref *kref)
> -{
> -       atomic_set(&kref->refcount, 1);
> -       smp_mb();
> -}
> -
> -/**
> - * kref_get - increment refcount for object.
> - * @kref: object.
> - */
> -void kref_get(struct kref *kref)
> -{
> -       WARN_ON(!atomic_read(&kref->refcount));
> -       atomic_inc(&kref->refcount);
> -       smp_mb__after_atomic_inc();
> -}
> -
> -/**
> - * kref_put - decrement refcount for object.
> - * @kref: object.
> - * @release: pointer to the function that will clean up the object when the
> - *          last reference to the object is released.
> - *          This pointer is required, and it is not acceptable to pass kfree
> - *          in as this function.
> - *
> - * Decrement the refcount, and if 0, call release().
> - * Return 1 if the object was removed, otherwise return 0.  Beware, if this
> - * function returns 0, you still can not count on the kref from remaining in
> - * memory.  Only use the return value if you want to see if the kref is now
> - * gone, not present.
> - */
> -int kref_put(struct kref *kref, void (*release)(struct kref *kref))
> -{
> -       WARN_ON(release == NULL);
> -       WARN_ON(release == (void (*)(struct kref *))kfree);
> -
> -       if (atomic_dec_and_test(&kref->refcount)) {
> -               release(kref);
> -               return 1;
> -       }
> -       return 0;
> -}
> -
> -
> -/**
> - * kref_sub - subtract a number of refcounts for object.
> - * @kref: object.
> - * @count: Number of recounts to subtract.
> - * @release: pointer to the function that will clean up the object when the
> - *          last reference to the object is released.
> - *          This pointer is required, and it is not acceptable to pass kfree
> - *          in as this function.
> - *
> - * Subtract @count from the refcount, and if 0, call release().
> - * Return 1 if the object was removed, otherwise return 0.  Beware, if this
> - * function returns 0, you still can not count on the kref from remaining in
> - * memory.  Only use the return value if you want to see if the kref is now
> - * gone, not present.
> - */
> -int kref_sub(struct kref *kref, unsigned int count,
> -            void (*release)(struct kref *kref))
> -{
> -       WARN_ON(release == NULL);
> -       WARN_ON(release == (void (*)(struct kref *))kfree);
> -
> -       if (atomic_sub_and_test((int) count, &kref->refcount)) {
> -               release(kref);
> -               return 1;
> -       }
> -       return 0;
> -}
> -
> -EXPORT_SYMBOL(kref_init);
> -EXPORT_SYMBOL(kref_get);
> -EXPORT_SYMBOL(kref_put);
> -EXPORT_SYMBOL(kref_sub);
> Index: linux-2.6/lib/Makefile
> ===================================================================
> --- linux-2.6.orig/lib/Makefile
> +++ linux-2.6/lib/Makefile
> @@ -17,7 +17,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
>  lib-$(CONFIG_MMU) += ioremap.o
>  lib-$(CONFIG_SMP) += cpumask.o
>
> -lib-y  += kobject.o kref.o klist.o
> +lib-y  += kobject.o klist.o
>
>  obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
>         bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


thanks,
-- 
Ming Lei
