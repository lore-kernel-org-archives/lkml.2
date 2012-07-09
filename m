Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab2GICmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:42:15 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:49274 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab2GICmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 22:42:13 -0400
Message-ID: <1341801721.2439.29.camel@ThinkPad-T420>
Subject: Re: [PATCH SLAB 1/2 v3] duplicate the cache name in SLUB's
 saved_alias list, SLAB, and SLOB
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm <linux-mm@kvack.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>
Date: Mon, 09 Jul 2012 10:42:01 +0800
In-Reply-To: <alpine.DEB.2.00.1207060855320.26441@router.home>
References: <1341561286.24895.9.camel@ThinkPad-T420>
	 <alpine.DEB.2.00.1207060855320.26441@router.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12070902-2000-0000-0000-000008320EE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 08:56 -0500, Christoph Lameter wrote:
> I thought I posted this a couple of days ago. Would this not fix things
> without having to change all the allocators?

I was pointed by Glauber to the slab common code patches. I need some
more time to read the patches. Now I think the slab/slot changes in this
v3 are not needed, and can be ignored.

But for the SLUB's saved_alias list issue, I don't think the following
patch helps. Details below: (Maybe I am wrong, as I'm reading the patch
based on the 3.5-rc6 code ...)

> 
> 
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

		......
		up_write(&slub_lock);
		return s; 
	}

Here, the function returns without name string n be kfreed. 

But we couldn't kfree n here, because in sysfs_slab_alias(), if
(slab_state < SYS_FS), the name need to be kept valid until
slab_sysfs_init() is finished adding the entry into sysfs. 
		
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


