Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1AKD5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:57:22 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:61797 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab1AKD5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:57:15 -0500
Date: Tue, 11 Jan 2011 12:53:30 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
        minchan.kim@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] mm: add replace_page_cache_page() function
Message-Id: <20110111125330.e416cff5.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20110111112949.57fd6fd7.kamezawa.hiroyu@jp.fujitsu.com>
References: <E1PbGxV-0001ug-2r@pomaz-ex.szeredi.hu>
	<20110111112949.57fd6fd7.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What I recommend is below. (Please see the newest -mm because of a bug fix for
> mem cgroup) Considering page management on radix-tree, it can be considerd as
> a kind of page-migration, which replaces pages on radix-tree.
> 
> ==
> 
> > +int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
> > +{
> > +	int error;
> > +
> > +	VM_BUG_ON(!PageLocked(old));
> > +	VM_BUG_ON(!PageLocked(new));
> > +	VM_BUG_ON(new->mapping);
> > +
> 	struct mem_cgroup *memcg;
> 
I think it should be initialized to NULL.

> 	error = mem_cgroup_prepare_migration(old, new, &memcg);

I want some comments like:

	/*
	 * This is not page migration, but prepare_migration and end_migration
	 * does enough work for charge replacement.
	 */

> 	#
> 	# This function will charge against "newpage". But this expects
> 	# the caller allows GFP_KERNEL gfp_mask. 
> 	# After this, the newpage is in "charged" state.
> 	if (error)
> 		return -ENOMEM;
> 
> > +	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
> > +	if (!error) {
> > +		struct address_space *mapping = old->mapping;
> > +		pgoff_t offset = old->index;
> > +
> > +		page_cache_get(new);
> > +		new->mapping = mapping;
> > +		new->index = offset;
> > +
> > +		spin_lock_irq(&mapping->tree_lock);
> > +		__remove_from_page_cache(old);
> > +		error = radix_tree_insert(&mapping->page_tree, offset, new);
> > +		BUG_ON(error);
> > +		mapping->nrpages++;
> > +		__inc_zone_page_state(new, NR_FILE_PAGES);
> > +		if (PageSwapBacked(new))
> > +			__inc_zone_page_state(new, NR_SHMEM);
> > +		spin_unlock_irq(&mapping->tree_lock);
> > +		radix_tree_preload_end();
> 
> > +		mem_cgroup_replace_cache_page(old, new); <== remove this.
> 
> 		mem_cgroup_end_migraton(memcg, old, new, true);
> 
> > +		page_cache_release(old);
> > +	} 
> 	else 
> 		mem_cgroup_end_migration(memcg, old, new, false);
> 
> 	# Here, if the 4th argument is true, old page is uncharged.
> 	# if the 4th argument is false, the new page is uncharged.
> 	# Then, "charge" of the old page will be migrated onto the new page
> 	# if replacement is done.
> 
> 
> 
> > +
> > +	return error;
> > +}
> > +EXPORT_SYMBOL_GPL(replace_page_cache_page);
> > +
> 
> ==
> 
> I think this is enough simple and this covers all memory cgroup's racy
> problems.
> 
I agree.

Thanks,
Daisuke Nishimura.
