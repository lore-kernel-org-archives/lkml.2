Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab0GIJYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 05:24:54 -0400
Received: from trinity.develer.com ([83.149.158.210]:54323 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab0GIJYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 05:24:52 -0400
Date: Fri, 9 Jul 2010 11:24:50 +0200
From: Andrea Righi <arighi@develer.com>
To: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Vivek Goyal <vgoyal@redhat.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 03/11] blkiocg async: Hooks for iotrack
Message-ID: <20100709092450.GA1814@linux.develer.com>
References: <4C369009.80503@ds.jp.nec.com>
 <4C36948C.9000902@ds.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C36948C.9000902@ds.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 11:16:28PM -0400, Munehiro Ikeda wrote:
> Embedding hooks for iotrack to record process info, namely
> cgroup ID.
> This patch is based on a patch posted from Ryo Tsuruta on Oct 2,
> 2009 titled "Page tracking hooks".
> 
> Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
> Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
> ---
>  fs/buffer.c         |    2 ++
>  fs/direct-io.c      |    2 ++
>  mm/bounce.c         |    2 ++
>  mm/filemap.c        |    2 ++
>  mm/memory.c         |    5 +++++
>  mm/page-writeback.c |    2 ++
>  mm/swap_state.c     |    2 ++
>  7 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index d54812b..c418fdf 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -36,6 +36,7 @@
>  #include <linux/buffer_head.h>
>  #include <linux/task_io_accounting_ops.h>
>  #include <linux/bio.h>
> +#include <linux/blk-iotrack.h>
>  #include <linux/notifier.h>
>  #include <linux/cpu.h>
>  #include <linux/bitops.h>
> @@ -667,6 +668,7 @@ static void __set_page_dirty(struct page *page,
>  	if (page->mapping) {	/* Race with truncate? */
>  		WARN_ON_ONCE(warn && !PageUptodate(page));
>  		account_page_dirtied(page, mapping);
> +		blk_iotrack_reset_owner_pagedirty(page, current->mm);
>  		radix_tree_tag_set(&mapping->page_tree,
>  				page_index(page), PAGECACHE_TAG_DIRTY);
>  	}
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 7600aac..2c1f42f 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -33,6 +33,7 @@
>  #include <linux/err.h>
>  #include <linux/blkdev.h>
>  #include <linux/buffer_head.h>
> +#include <linux/blk-iotrack.h>
>  #include <linux/rwsem.h>
>  #include <linux/uio.h>
>  #include <asm/atomic.h>
> @@ -846,6 +847,7 @@ static int do_direct_IO(struct dio *dio)
>  			ret = PTR_ERR(page);
>  			goto out;
>  		}
> +		blk_iotrack_reset_owner(page, current->mm);
>  
>  		while (block_in_page < blocks_per_page) {
>  			unsigned offset_in_page = block_in_page << blkbits;
> diff --git a/mm/bounce.c b/mm/bounce.c
> index 13b6dad..04339df 100644
> --- a/mm/bounce.c
> +++ b/mm/bounce.c
> @@ -14,6 +14,7 @@
>  #include <linux/init.h>
>  #include <linux/hash.h>
>  #include <linux/highmem.h>
> +#include <linux/blk-iotrack.h>
>  #include <asm/tlbflush.h>
>  
>  #include <trace/events/block.h>
> @@ -211,6 +212,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
>  		to->bv_len = from->bv_len;
>  		to->bv_offset = from->bv_offset;
>  		inc_zone_page_state(to->bv_page, NR_BOUNCE);
> +		blk_iotrack_copy_owner(to->bv_page, page);
>  
>  		if (rw == WRITE) {
>  			char *vto, *vfrom;
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 20e5642..a255d0c 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -33,6 +33,7 @@
>  #include <linux/cpuset.h>
>  #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
>  #include <linux/memcontrol.h>
> +#include <linux/blk-iotrack.h>
>  #include <linux/mm_inline.h> /* for page_is_file_cache() */
>  #include "internal.h"
>  
> @@ -405,6 +406,7 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
>  					gfp_mask & GFP_RECLAIM_MASK);
>  	if (error)
>  		goto out;
> +	blk_iotrack_set_owner(page, current->mm);
>  
>  	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
>  	if (error == 0) {
> diff --git a/mm/memory.c b/mm/memory.c
> index 119b7cc..3eb2d0d 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -52,6 +52,7 @@
>  #include <linux/init.h>
>  #include <linux/writeback.h>
>  #include <linux/memcontrol.h>
> +#include <linux/blk-iotrack.h>
>  #include <linux/mmu_notifier.h>
>  #include <linux/kallsyms.h>
>  #include <linux/swapops.h>
> @@ -2283,6 +2284,7 @@ gotten:
>  		 */
>  		ptep_clear_flush(vma, address, page_table);
>  		page_add_new_anon_rmap(new_page, vma, address);
> +		blk_iotrack_set_owner(new_page, mm);
>  		/*
>  		 * We call the notify macro here because, when using secondary
>  		 * mmu page tables (such as kvm shadow page tables), we want the
> @@ -2718,6 +2720,7 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  	flush_icache_page(vma, page);
>  	set_pte_at(mm, address, page_table, pte);
>  	page_add_anon_rmap(page, vma, address);
> +	blk_iotrack_reset_owner(page, mm);
>  	/* It's better to call commit-charge after rmap is established */
>  	mem_cgroup_commit_charge_swapin(page, ptr);
>  
> @@ -2795,6 +2798,7 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  
>  	inc_mm_counter_fast(mm, MM_ANONPAGES);
>  	page_add_new_anon_rmap(page, vma, address);
> +	blk_iotrack_set_owner(page, mm);

We're tracking anonymous memory here. Should we charge the cost of the
swap IO to the root cgroup or the actual owner of the page? there was a
previous discussion about this topic, but can't remember the details,
sorry.

IMHO we could remove some overhead simply ignoring the tracking of
anonymous pages (swap IO) and just consider direct and writeback IO of
file pages.

>  setpte:
>  	set_pte_at(mm, address, page_table, entry);
>  
> @@ -2949,6 +2953,7 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  		if (anon) {
>  			inc_mm_counter_fast(mm, MM_ANONPAGES);
>  			page_add_new_anon_rmap(page, vma, address);
> +			blk_iotrack_set_owner(page, mm);

Ditto.

>  		} else {
>  			inc_mm_counter_fast(mm, MM_FILEPAGES);
>  			page_add_file_rmap(page);
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 54f28bd..f3e6b2c 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -23,6 +23,7 @@
>  #include <linux/init.h>
>  #include <linux/backing-dev.h>
>  #include <linux/task_io_accounting_ops.h>
> +#include <linux/blk-iotrack.h>
>  #include <linux/blkdev.h>
>  #include <linux/mpage.h>
>  #include <linux/rmap.h>
> @@ -1128,6 +1129,7 @@ int __set_page_dirty_nobuffers(struct page *page)
>  			BUG_ON(mapping2 != mapping);
>  			WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
>  			account_page_dirtied(page, mapping);
> +			blk_iotrack_reset_owner_pagedirty(page, current->mm);
>  			radix_tree_tag_set(&mapping->page_tree,
>  				page_index(page), PAGECACHE_TAG_DIRTY);
>  		}
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index e10f583..ab26978 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -19,6 +19,7 @@
>  #include <linux/pagevec.h>
>  #include <linux/migrate.h>
>  #include <linux/page_cgroup.h>
> +#include <linux/blk-iotrack.h>
>  
>  #include <asm/pgtable.h>
>  
> @@ -324,6 +325,7 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		/* May fail (-ENOMEM) if radix-tree node allocation failed. */
>  		__set_page_locked(new_page);
>  		SetPageSwapBacked(new_page);
> +		blk_iotrack_set_owner(new_page, current->mm);

Ditto.

>  		err = __add_to_swap_cache(new_page, entry);
>  		if (likely(!err)) {
>  			radix_tree_preload_end();
> -- 
> 1.6.2.5

Thanks,
-Andrea
