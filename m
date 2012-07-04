Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab2GDJAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 05:00:50 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:60484 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab2GDJAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 05:00:47 -0400
Message-ID: <1341392420.18505.41.camel@ThinkPad-T420>
Subject: Re: [PATCH powerpc 2/2] kfree the cache name  of pgtable cache if
 SLUB is used
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm <linux-mm@kvack.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>
Date: Wed, 04 Jul 2012 17:00:20 +0800
In-Reply-To: <alpine.DEB.2.00.1207031535330.14703@router.home>
References: <1340617984.13778.37.camel@ThinkPad-T420>
	 <1340618099.13778.39.camel@ThinkPad-T420>
	 <alpine.DEB.2.00.1207031344240.14703@router.home>
	 <alpine.DEB.2.00.1207031535330.14703@router.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12070323-3568-0000-0000-0000021445A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 15:36 -0500, Christoph Lameter wrote:
> Looking through the emails it seems that there is an issue with alias
> strings. 

To be more precise, there seems no big issue currently. I just wanted to
make following usage of kmem_cache_create (SLUB) possible:

	name = some string kmalloced
	kmem_cache_create(name, ...)
	kfree(name);

And from my understanding of the code, the saved_alias list, which is
used to keep track of the alias entries during early boot (slab_state <
SYSFS), is a blocker. It needs the name string to be valid until
slab_sysfs_init() is finished. 

> That can be solved by duping the name of the slab earlier in kmem_cache_create().
> Does this patch fix the issue?

I'm afraid not...

With the patch below, we still need to kfree the duplicated name in
slab_sysfs_init().

And I think it would be easier to understand if we duplicate the name
string when creating one entry for saved_alias list, and kfree it when
we remove one entry from saved_alias list. 

I'm not sure whether you got the patch #1 of the two I sent previously.
If not, would you kindly spend some time reviewing it to see if I missed
anything? Link below for your convenience:
  https://lkml.org/lkml/2012/6/27/83

Btw, as Ben suggested, I'm now working on duplicating the name string in
SLAB to make them consistent, so we don't need the #ifdef CONFIG_SLUB
any more. Will send it out for your review after it is finished.

> Subject: slub: Dup name earlier in kmem_cache_create
> 
> Dup the name earlier in kmem_cache_create so that alias
> processing is done using the copy of the string and not
> the string itself.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  mm/slub.c |   29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
> 
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2012-06-11 08:49:56.000000000 -0500
> +++ linux-2.6/mm/slub.c	2012-07-03 15:17:37.000000000 -0500
> @@ -3933,8 +3933,12 @@ struct kmem_cache *kmem_cache_create(con
>  	if (WARN_ON(!name))
>  		return NULL;
> 
> +	n = kstrdup(name, GFP_KERNEL);
> +	if (!n)
> +		goto out;
> +
>  	down_write(&slub_lock);
> -	s = find_mergeable(size, align, flags, name, ctor);
> +	s = find_mergeable(size, align, flags, n, ctor);
>  	if (s) {
>  		s->refcount++;
>  		/*
> @@ -3944,7 +3948,7 @@ struct kmem_cache *kmem_cache_create(con
>  		s->objsize = max(s->objsize, (int)size);
>  		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
> 
> -		if (sysfs_slab_alias(s, name)) {
> +		if (sysfs_slab_alias(s, n)) {
>  			s->refcount--;
>  			goto err;
>  		}
> @@ -3952,31 +3956,26 @@ struct kmem_cache *kmem_cache_create(con
>  		return s;
>  	}
> 
> -	n = kstrdup(name, GFP_KERNEL);
> -	if (!n)
> -		goto err;
> -
>  	s = kmalloc(kmem_size, GFP_KERNEL);
>  	if (s) {
>  		if (kmem_cache_open(s, n,
>  				size, align, flags, ctor)) {
>  			list_add(&s->list, &slab_caches);
>  			up_write(&slub_lock);
> -			if (sysfs_slab_add(s)) {
> -				down_write(&slub_lock);
> -				list_del(&s->list);
> -				kfree(n);
> -				kfree(s);
> -				goto err;
> -			}
> -			return s;
> +			if (!sysfs_slab_add(s))
> +				return s;
> +
> +			down_write(&slub_lock);
> +			list_del(&s->list);
>  		}
>  		kfree(s);
>  	}
> -	kfree(n);
> +
>  err:
> +	kfree(n);
>  	up_write(&slub_lock);
> 
> +out:
>  	if (flags & SLAB_PANIC)
>  		panic("Cannot create slabcache %s\n", name);
>  	else
> 


