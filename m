Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0LPBNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 20:13:31 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40569 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab0LPBN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 20:13:28 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Dec 2010 10:07:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add replace_page_cache_page() function
Message-Id: <20101216100744.e3a417cf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <E1PStc6-0006Cd-0Z@pomaz-ex.szeredi.hu>
References: <E1PStc6-0006Cd-0Z@pomaz-ex.szeredi.hu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010 16:49:58 +0100
Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> This function basically does:
> 
>      remove_from_page_cache(old);
>      page_cache_release(old);
>      add_to_page_cache_locked(new);
> 
> Except it does this atomically, so there's no possibility for the
> "add" to fail because of a race.
> 
> This is used by fuse to move pages into the page cache.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/fuse/dev.c           |   10 ++++------
>  include/linux/pagemap.h |    1 +
>  mm/filemap.c            |   41 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 46 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6/mm/filemap.c
> ===================================================================
> --- linux-2.6.orig/mm/filemap.c	2010-12-15 16:39:55.000000000 +0100
> +++ linux-2.6/mm/filemap.c	2010-12-15 16:41:24.000000000 +0100
> @@ -389,6 +389,47 @@ int filemap_write_and_wait_range(struct
>  }
>  EXPORT_SYMBOL(filemap_write_and_wait_range);
>  
> +int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
> +{
> +	int error;
> +
> +	VM_BUG_ON(!PageLocked(old));
> +	VM_BUG_ON(!PageLocked(new));
> +	VM_BUG_ON(new->mapping);
> +
> +	error = mem_cgroup_cache_charge(new, current->mm,
> +					gfp_mask & GFP_RECLAIM_MASK);

Hmm, then, the page will be recharged to "current" instead of the memcg
where "old" was under control. Is this design ? If so, why ?

In mm/migrate.c, following is called.

	 charge = mem_cgroup_prepare_migration(page, newpage, &mem);
	....do migration....
        if (!charge)
                mem_cgroup_end_migration(mem, page, newpage);

BTW, off topic, in fuse/dev.c

add_to_page_cache_locked(page)

is called and this page is "charged" to memory cgroup. But, IIUC, this page
will be never be on LRU and cannot be reclaimed by memory cgroup.
I think this looks like a memory leak at rmdir() of memory cgroup and
rmdir will fail wish -EBUSY always.

So, I'd like to change this call something like as

add_to_page_cache_locked_and_no_memory_cgroup_control().

So, I think just dropping this memory cgroup related code is okay for us
because this is a replacement for add_to_page_cache_locked() which seems
problematic.
This will put pages on fuse's private radix-tree out of control.

Or, is it possible to drain these radix-tree pages at rmdir() of memory
cgroup by some call ?

Thanks,
-Kame


> +	if (error)
> +		goto out;
> +
> +	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
> +	if (error == 0) {
> +		struct address_space *mapping = old->mapping;
> +		pgoff_t offset = old->index;
> +
> +		page_cache_get(new);
> +		new->mapping = mapping;
> +		new->index = offset;
> +
> +		spin_lock_irq(&mapping->tree_lock);
> +		__remove_from_page_cache(old);
> +		error = radix_tree_insert(&mapping->page_tree, offset, new);
> +		BUG_ON(error);
> +		mapping->nrpages++;
> +		__inc_zone_page_state(new, NR_FILE_PAGES);
> +		if (PageSwapBacked(new))
> +			__inc_zone_page_state(new, NR_SHMEM);
> +		spin_unlock_irq(&mapping->tree_lock);
> +		radix_tree_preload_end();
> +		mem_cgroup_uncharge_cache_page(old);
> +		page_cache_release(old);
> +	} else
> +		mem_cgroup_uncharge_cache_page(new);
> +out:
> +	return error;
> +}
> +EXPORT_SYMBOL_GPL(replace_page_cache_page);
> +
>  /**
>   * add_to_page_cache_locked - add a locked page to the pagecache
>   * @page:	page to add
> Index: linux-2.6/include/linux/pagemap.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pagemap.h	2010-12-15 16:39:39.000000000 +0100
> +++ linux-2.6/include/linux/pagemap.h	2010-12-15 16:41:24.000000000 +0100
> @@ -457,6 +457,7 @@ int add_to_page_cache_lru(struct page *p
>  				pgoff_t index, gfp_t gfp_mask);
>  extern void remove_from_page_cache(struct page *page);
>  extern void __remove_from_page_cache(struct page *page);
> +int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask);
>  
>  /*
>   * Like add_to_page_cache_locked, but used to add newly allocated pages:
> Index: linux-2.6/fs/fuse/dev.c
> ===================================================================
> --- linux-2.6.orig/fs/fuse/dev.c	2010-12-15 16:39:39.000000000 +0100
> +++ linux-2.6/fs/fuse/dev.c	2010-12-15 16:41:24.000000000 +0100
> @@ -729,14 +729,12 @@ static int fuse_try_move_page(struct fus
>  	if (WARN_ON(PageMlocked(oldpage)))
>  		goto out_fallback_unlock;
>  
> -	remove_from_page_cache(oldpage);
> -	page_cache_release(oldpage);
> -
> -	err = add_to_page_cache_locked(newpage, mapping, index, GFP_KERNEL);
> +	err = replace_page_cache_page(oldpage, newpage, GFP_KERNEL);
>  	if (err) {
> -		printk(KERN_WARNING "fuse_try_move_page: failed to add page");
> -		goto out_fallback_unlock;
> +		unlock_page(newpage);
> +		return err;
>  	}
> +
>  	page_cache_get(newpage);
>  
>  	if (!(buf->flags & PIPE_BUF_FLAG_LRU))
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom policy in Canada: sign http://dissolvethecrtc.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

