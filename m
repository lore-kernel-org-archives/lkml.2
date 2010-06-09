Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab0FINXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 09:23:10 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45819 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab0FINXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 09:23:06 -0400
Date: Wed, 9 Jun 2010 14:22:46 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 10/28] mm: Make use of the anon_vma ref count
Message-ID: <20100609132245.GF5650@csn.ul.ie>
References: <20100607110654.606530953@chello.nl> <20100607111407.309924253@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100607111407.309924253@chello.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 01:07:04PM +0200, Peter Zijlstra wrote:
> This patch changes the anon_vma refcount to be 0 when the object is
> free. It does this by adding 1 ref to being in use in the anon_vma
> structure (iow. the anon_vma->head list is not empty).
> 
> This allows a simpler release scheme without having to check both the
> refcount and the list as well as avoids taking a ref for each entry
> on the list.
> 

Nice touch. It makes it closer to page reference counting as well so
should be familiar.

> We then convert page_lock_anon_vma() over to use refcounts. This is
> done for each of convertion of anon_vma from spinlock to mutex.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/rmap.h |   11 ++++-
>  mm/ksm.c             |    4 --
>  mm/rmap.c            |   94 ++++++++++++++++++++++-----------------------------
>  3 files changed, 52 insertions(+), 57 deletions(-)
> 
> Index: linux-2.6/include/linux/rmap.h
> ===================================================================
> --- linux-2.6.orig/include/linux/rmap.h
> +++ linux-2.6/include/linux/rmap.h
> @@ -73,7 +73,13 @@ static inline void get_anon_vma(struct a
>  	atomic_inc(&anon_vma->refcount);
>  }
>  
> -void put_anon_vma(struct anon_vma *);
> +void __put_anon_vma(struct anon_vma *anon_vma);
> +
> +static inline void put_anon_vma(struct anon_vma *anon_vma)
> +{
> +	if (atomic_dec_and_test(&anon_vma->refcount))
> +		__put_anon_vma(anon_vma);
> +}
>  
>  static inline struct anon_vma *page_anon_vma(struct page *page)
>  {
> @@ -116,7 +122,6 @@ void unlink_anon_vmas(struct vm_area_str
>  int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
>  int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
>  void __anon_vma_link(struct vm_area_struct *);
> -void anon_vma_free(struct anon_vma *);
>  
>  static inline void anon_vma_merge(struct vm_area_struct *vma,
>  				  struct vm_area_struct *next)
> @@ -125,6 +130,8 @@ static inline void anon_vma_merge(struct
>  	unlink_anon_vmas(next);
>  }
>  
> +struct anon_vma *page_get_anon_vma(struct page *page);
> +
>  /*
>   * rmap interfaces called when adding or removing pte of page
>   */
> Index: linux-2.6/mm/ksm.c
> ===================================================================
> --- linux-2.6.orig/mm/ksm.c
> +++ linux-2.6/mm/ksm.c
> @@ -323,9 +323,7 @@ static void hold_anon_vma(struct rmap_it
>  
>  static void ksm_put_anon_vma(struct rmap_item *rmap_item)
>  {
> -	struct anon_vma *anon_vma = rmap_item->anon_vma;
> -
> -	put_anon_vma(anon_vma);
> +	put_anon_vma(rmap_item->anon_vma);
>  }
>  
>  /*
> Index: linux-2.6/mm/rmap.c
> ===================================================================
> --- linux-2.6.orig/mm/rmap.c
> +++ linux-2.6/mm/rmap.c
> @@ -66,11 +66,24 @@ static struct kmem_cache *anon_vma_chain
>  
>  static inline struct anon_vma *anon_vma_alloc(void)
>  {
> -	return kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
> +	struct anon_vma *anon_vma;
> +
> +	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
> +	if (anon_vma) {
> +		atomic_set(&anon_vma->refcount, 1);
> +		/*
> +		 * This VMA had no anon_vma yet.  This anon_vma is
> +		 * the root of any anon_vma tree that might form.
> +		 */
> +		anon_vma->root = anon_vma;
> +	}

This comment is no longer strictly correct. anon_vma_alloc() can also be
called from anon_vma_fork where the root of the newly allocated anon_vma
will be set to the same as the parents anon_vma. Maybe something like

/*
 * Initialise the anon_vma root to point to itself. If called from
 * fork, the root will be reset to the parents anon_vma 
 */

Else, just leave the initialisation of the root where it was but only
init the refcount here.

> +
> +	return anon_vma;
>  }
>  
> -void anon_vma_free(struct anon_vma *anon_vma)
> +static inline void anon_vma_free(struct anon_vma *anon_vma)
>  {
> +	VM_BUG_ON(atomic_read(&anon_vma->refcount));
>  	kmem_cache_free(anon_vma_cachep, anon_vma);
>  }
>  
> @@ -132,11 +145,6 @@ int anon_vma_prepare(struct vm_area_stru
>  			if (unlikely(!anon_vma))
>  				goto out_enomem_free_avc;
>  			allocated = anon_vma;
> -			/*
> -			 * This VMA had no anon_vma yet.  This anon_vma is
> -			 * the root of any anon_vma tree that might form.
> -			 */
> -			anon_vma->root = anon_vma;
>  		}
>  
>  		anon_vma_lock(anon_vma);
> @@ -155,7 +163,7 @@ int anon_vma_prepare(struct vm_area_stru
>  		anon_vma_unlock(anon_vma);
>  
>  		if (unlikely(allocated))
> -			anon_vma_free(allocated);
> +			put_anon_vma(allocated);
>  		if (unlikely(avc))
>  			anon_vma_chain_free(avc);
>  	}
> @@ -248,7 +256,7 @@ int anon_vma_fork(struct vm_area_struct 
>  	return 0;
>  
>   out_error_free_anon_vma:
> -	anon_vma_free(anon_vma);
> +	put_anon_vma(anon_vma);
>   out_error:
>  	unlink_anon_vmas(vma);
>  	return -ENOMEM;
> @@ -265,16 +273,12 @@ static void anon_vma_unlink(struct anon_
>  
>  	anon_vma_lock(anon_vma);
>  	list_del(&anon_vma_chain->same_anon_vma);
> -
>  	/* We must garbage collect the anon_vma if it's empty */

Unnecessary whitespace change there.

> -	empty = list_empty(&anon_vma->head) && !atomic_read(&anon_vma->refcount);
> +	empty = list_empty(&anon_vma->head);
>  	anon_vma_unlock(anon_vma);
>  
> -	if (empty) {
> -		/* We no longer need the root anon_vma */
> -		put_anon_vma(anon_vma->root);
> -		anon_vma_free(anon_vma);
> -	}
> +	if (empty)
> +		put_anon_vma(anon_vma);
>  }
>  
>  void unlink_anon_vmas(struct vm_area_struct *vma)
> @@ -326,9 +330,9 @@ void __init anon_vma_init(void)
>   * that the anon_vma pointer from page->mapping is valid if there is a
>   * mapcount, we can dereference the anon_vma after observing those.
>   */
> -struct anon_vma *page_lock_anon_vma(struct page *page)
> +struct anon_vma *page_get_anon_vma(struct page *page)
>  {
> -	struct anon_vma *anon_vma;
> +	struct anon_vma *anon_vma = NULL;
>  	unsigned long anon_mapping;
>  

It's not clear why you split page_get_anon_vma and page_lock_anon_vma at
this point. Maybe you use it later in the series?

>  	rcu_read_lock();
> @@ -339,17 +343,28 @@ struct anon_vma *page_lock_anon_vma(stru
>  		goto out;
>  
>  	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
> -	anon_vma_lock(anon_vma);
> -	return anon_vma;
> +	if (!atomic_inc_not_zero(&anon_vma->refcount))
> +		anon_vma = NULL;
>  out:
>  	rcu_read_unlock();
> -	return NULL;
> +
> +	return anon_vma;
> +}
> +
> +struct anon_vma *page_lock_anon_vma(struct page *page)
> +{
> +	struct anon_vma *anon_vma = page_get_anon_vma(page);
> +
> +	if (anon_vma)
> +		anon_vma_lock(anon_vma);
> +
> +	return anon_vma;
>  }
>  
>  void page_unlock_anon_vma(struct anon_vma *anon_vma)
>  {
>  	anon_vma_unlock(anon_vma);
> -	rcu_read_unlock();
> +	put_anon_vma(anon_vma);
>  }
>  
>  /*
> @@ -1405,36 +1420,11 @@ int try_to_munlock(struct page *page)
>  		return try_to_unmap_file(page, TTU_MUNLOCK);
>  }
>  
> -/*
> - * Drop an anon_vma refcount, freeing the anon_vma and anon_vma->root
> - * if necessary.  Be careful to do all the tests under the lock.  Once
> - * we know we are the last user, nobody else can get a reference and we
> - * can do the freeing without the lock.
> - */
> -void put_anon_vma(struct anon_vma *anon_vma)
> -{
> -	if (atomic_dec_and_lock(&anon_vma->refcount, &anon_vma->root->lock)) {
> -		struct anon_vma *root = anon_vma->root;
> -		int empty = list_empty(&anon_vma->head);
> -		int last_root_user = 0;
> -		int root_empty = 0;
> -
> -		/*
> -		 * The refcount on a non-root anon_vma got dropped.  Drop
> -		 * the refcount on the root and check if we need to free it.
> -		 */
> -		if (empty && anon_vma != root) {
> -			last_root_user = atomic_dec_and_test(&root->refcount);
> -			root_empty = list_empty(&root->head);
> -		}
> -		anon_vma_unlock(anon_vma);
> -
> -		if (empty) {
> -			anon_vma_free(anon_vma);
> -			if (root_empty && last_root_user)
> -				anon_vma_free(root);
> -		}
> -	}
> +void __put_anon_vma(struct anon_vma *anon_vma)
> +{
> +	if (anon_vma->root != anon_vma)
> +		put_anon_vma(anon_vma->root);
> +	anon_vma_free(anon_vma);
>  }
>  
>  #ifdef CONFIG_MIGRATION
> 

In the first reading, nothing horrible jumped out at this point. I'm going
to run a few tests on just the first 10 patches in this series and see what
that looks like. For this patch in particular, I  want to be sure we are
not leaking anon_vma's.


-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
