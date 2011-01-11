Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab1AKCfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 21:35:51 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37941 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab1AKCfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 21:35:44 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 11 Jan 2011 11:29:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, minchan.kim@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] mm: add replace_page_cache_page() function
Message-Id: <20110111112949.57fd6fd7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <E1PbGxV-0001ug-2r@pomaz-ex.szeredi.hu>
References: <E1PbGxV-0001ug-2r@pomaz-ex.szeredi.hu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Jan 2011 19:22:41 +0100
Miklos Szeredi <miklos@szeredi.hu> wrote:

> Here's an updated patch, addressing the review comments.
> 
> Hiroyuki-san, can you please review the newly introduced
> mem_cgroup_replace_cache_page(), as I'm not fully familiar with the
> memory cgroup code.
> 

Ok. Ccing Nishimura. see below.

> Thanks,
> Miklos
> ---
> 
> From: Miklos Szeredi <mszeredi@suse.cz>
> Subject: mm: add replace_page_cache_page() function
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
>  fs/fuse/dev.c              |   10 +++------
>  include/linux/memcontrol.h |    8 +++++++
>  include/linux/pagemap.h    |    1 
>  mm/filemap.c               |   50 +++++++++++++++++++++++++++++++++++++++++++++
>  mm/memcontrol.c            |   38 ++++++++++++++++++++++++++++++++++
>  5 files changed, 101 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6/mm/filemap.c
> ===================================================================
> --- linux-2.6.orig/mm/filemap.c	2011-01-07 17:53:39.000000000 +0100
> +++ linux-2.6/mm/filemap.c	2011-01-07 19:14:45.000000000 +0100
> @@ -390,6 +390,56 @@ int filemap_write_and_wait_range(struct
>  EXPORT_SYMBOL(filemap_write_and_wait_range);
>  
>  /**
> + * replace_page_cache_page - replace a pagecache page with a new one
> + * @old:	page to be replaced
> + * @new:	page to replace with
> + * @gfp_mask:	page allocation mode
> + *
> + * This function replaces a page in the pagecache with a new one.  On
> + * success it acquires the pagecache reference for the new page and
> + * drop it for the old page.  Both the old and new pages must be
> + * locked.  This function does not add the new page to the LRU, the
> + * caller must do that.
> + *
> + * The remove + add is atomic.  The only way this function can fail is
> + * memory allocation failure.
> + */
> +int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
> +{
> +	int error;
> +
> +	VM_BUG_ON(!PageLocked(old));
> +	VM_BUG_ON(!PageLocked(new));
> +	VM_BUG_ON(new->mapping);
> +
> +	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
> +	if (!error) {
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
> +		mem_cgroup_replace_cache_page(old, new);
> +		page_cache_release(old);
> +	}
> +
> +	return error;
> +}
> +EXPORT_SYMBOL_GPL(replace_page_cache_page);
> +
> +/**
>   * add_to_page_cache_locked - add a locked page to the pagecache
>   * @page:	page to add
>   * @mapping:	the page's address_space
> Index: linux-2.6/include/linux/pagemap.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pagemap.h	2011-01-07 17:53:39.000000000 +0100
> +++ linux-2.6/include/linux/pagemap.h	2011-01-07 19:14:45.000000000 +0100
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
> --- linux-2.6.orig/fs/fuse/dev.c	2011-01-07 17:53:39.000000000 +0100
> +++ linux-2.6/fs/fuse/dev.c	2011-01-07 19:14:45.000000000 +0100
> @@ -737,14 +737,12 @@ static int fuse_try_move_page(struct fus
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
> Index: linux-2.6/include/linux/memcontrol.h
> ===================================================================
> --- linux-2.6.orig/include/linux/memcontrol.h	2011-01-07 17:53:39.000000000 +0100
> +++ linux-2.6/include/linux/memcontrol.h	2011-01-07 19:14:45.000000000 +0100
> @@ -95,6 +95,9 @@ mem_cgroup_prepare_migration(struct page
>  extern void mem_cgroup_end_migration(struct mem_cgroup *mem,
>  	struct page *oldpage, struct page *newpage);
>  
> +extern void mem_cgroup_replace_cache_page(struct page *oldpage,
> +					  struct page *newpage);
> +
>  /*
>   * For memory reclaim.
>   */
> @@ -236,6 +239,11 @@ static inline void mem_cgroup_end_migrat
>  {
>  }
>  
> +static inline void mem_cgroup_replace_cache_page(struct page *oldpage,
> +					 	struct page *newpage)
> +{
> +}
> +
>  static inline int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem)
>  {
>  	return 0;
> Index: linux-2.6/mm/memcontrol.c
> ===================================================================
> --- linux-2.6.orig/mm/memcontrol.c	2011-01-07 17:53:39.000000000 +0100
> +++ linux-2.6/mm/memcontrol.c	2011-01-07 19:20:41.000000000 +0100
> @@ -2905,6 +2905,44 @@ void mem_cgroup_end_migration(struct mem
>  }
>  
>  /*
> + * This function moves the charge from oldpage to newpage.  The new
> + * page must not be already charged.
> + */
> +void mem_cgroup_replace_cache_page(struct page *oldpage, struct page *newpage)
> +{
> +	struct page_cgroup *old_pc;
> +	struct page_cgroup *new_pc;
> +	struct mem_cgroup *mem;
> +
> +	if (mem_cgroup_disabled())
> +		return;
> +
> +	old_pc = lookup_page_cgroup(oldpage);
> +	lock_page_cgroup(old_pc);
> +	if (!PageCgroupUsed(old_pc)) {
> +		unlock_page_cgroup(old_pc);
> +		return;
> +	}
> +
> +	mem = old_pc->mem_cgroup;
> +	css_get(&mem->css);
> +	ClearPageCgroupUsed(old_pc);
> +	unlock_page_cgroup(old_pc);
> +
> +	new_pc = lookup_page_cgroup(newpage);
> +	lock_page_cgroup(new_pc);
> +	BUG_ON(PageCgroupUsed(new_pc));
> +
> +	new_pc->mem_cgroup = mem;
> +	smp_wmb();
> +	SetPageCgroupCache(new_pc);
> +	SetPageCgroupUsed(new_pc);
> +	unlock_page_cgroup(new_pc);
> +	css_put(&mem->css);
> +}

I think some of moving flags are lacked and this new function is not necessary.


What I recommend is below. (Please see the newest -mm because of a bug fix for
mem cgroup) Considering page management on radix-tree, it can be considerd as
a kind of page-migration, which replaces pages on radix-tree.

==

> +int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
> +{
> +	int error;
> +
> +	VM_BUG_ON(!PageLocked(old));
> +	VM_BUG_ON(!PageLocked(new));
> +	VM_BUG_ON(new->mapping);
> +
	struct mem_cgroup *memcg;

	error = mem_cgroup_prepare_migration(old, new, &memcg);
	#
	# This function will charge against "newpage". But this expects
	# the caller allows GFP_KERNEL gfp_mask. 
	# After this, the newpage is in "charged" state.
	if (error)
		return -ENOMEM;

> +	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
> +	if (!error) {
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

> +		mem_cgroup_replace_cache_page(old, new); <== remove this.

		mem_cgroup_end_migraton(memcg, old, new, true);

> +		page_cache_release(old);
> +	} 
	else 
		mem_cgroup_end_migration(memcg, old, new, false);

	# Here, if the 4th argument is true, old page is uncharged.
	# if the 4th argument is false, the new page is uncharged.
	# Then, "charge" of the old page will be migrated onto the new page
	# if replacement is done.



> +
> +	return error;
> +}
> +EXPORT_SYMBOL_GPL(replace_page_cache_page);
> +

==

I think this is enough simple and this covers all memory cgroup's racy
problems.

Thanks,
-Kame

