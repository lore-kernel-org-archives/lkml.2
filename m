Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab0IJEKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 00:10:41 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:43037 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab0IJEKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 00:10:40 -0400
Date: Fri, 10 Sep 2010 13:05:39 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mark Hills <mark@pogo.org.uk>, Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: cgroup: rmdir() does not complete
Message-Id: <20100910130539.9ac3c861.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100910111646.a03ed3ba.kamezawa.hiroyu@jp.fujitsu.com>
References: <alpine.NEB.2.01.1008261415240.8857@jrf.vwaro.pbz>
	<20100827095639.6e7297de.nishimura@mxp.nes.nec.co.jp>
	<20100827113506.2bbbb7b9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100827123948.b4427a15.nishimura@mxp.nes.nec.co.jp>
	<20100827144225.3190167a.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.NEB.2.01.1009011200050.6596@jrf.vwaro.pbz>
	<20100902084200.e9b773cf.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.NEB.2.01.1009091051400.17759@jrf.vwaro.pbz>
	<20100909100909.GM4443@balbir.in.ibm.com>
	<alpine.NEB.2.01.1009091234230.26366@jrf.vwaro.pbz>
	<1284033017.402.8.camel@laptop>
	<alpine.NEB.2.01.1009091416100.26432@jrf.vwaro.pbz>
	<20100910111646.a03ed3ba.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 11:16:46 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Fri, 10 Sep 2010 00:04:31 +0100 (BST)
> Mark Hills <mark@pogo.org.uk> wrote:
> > The report on the spinning process (23586) is dominated by calls from 
> > mem_cgroup_force_empty.
> > 
> > It seems to show lru_add_drain_all and drain_all_stock_sync are causing 
> > the load (I assume drain_all_stock_sync has been optimised out). But I 
> > don't think this is as important as what causes the spin.
> > 
> 
> I noticed you use FUSE and it seems there is a problem in FUSE v.s. memcg.
> I wrote a patch (onto 2.6.36 but can be applied..)
> 
Nice catch!

> Could you try this ? I'm sorry I don't use FUSE system and can't test
> right now.
> 
Sorry, I can't either.

> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> memory cgroup catches all pages which is added to radix-tree and
> assumes the pages will be added to LRU, somewhere.
> But there are pages which not on LRU but on radix-tree. Then,
> force_empty cannot find them and cannot finish ->pre_destroy(), rmdir
> operations.
> 
> This patch adds __GFP_NOMEMCGROUP and avoids unnecessary, out-of-control
> pages are registered to memory cgroup. 
> 
> Note: This gfp flag can be used for shmem handling, which now uses
>       complicated heuristics.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  fs/fuse/dev.c       |   11 ++++++++++-
>  include/linux/gfp.h |    7 +++++++
>  mm/memcontrol.c     |    2 +-
>  3 files changed, 18 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.36-rc3/fs/fuse/dev.c
> ===================================================================
> --- linux-2.6.36-rc3.orig/fs/fuse/dev.c
> +++ linux-2.6.36-rc3/fs/fuse/dev.c
> @@ -19,6 +19,7 @@
>  #include <linux/pipe_fs_i.h>
>  #include <linux/swap.h>
>  #include <linux/splice.h>
> +#include <linux/memcontrol.h>
>  
>  MODULE_ALIAS_MISCDEV(FUSE_MINOR);
>  MODULE_ALIAS("devname:fuse");
> @@ -683,6 +684,7 @@ static int fuse_try_move_page(struct fus
>  	struct pipe_buffer *buf = cs->pipebufs;
>  	struct address_space *mapping;
>  	pgoff_t index;
> +	gfp_t mask = GFP_KERNEL;
>  
>  	unlock_request(cs->fc, cs->req);
>  	fuse_copy_finish(cs);
> @@ -732,7 +734,14 @@ static int fuse_try_move_page(struct fus
>  	remove_from_page_cache(oldpage);
>  	page_cache_release(oldpage);
>  
> -	err = add_to_page_cache_locked(newpage, mapping, index, GFP_KERNEL);
> +	/*
> +	 * not-on-LRU pages are out of control. So, add to root cgroup.
> + 	 * See mm/memcontrol.c for details.
> +	 */
> +	if (buf->flags & PIPE_BUF_FLAG_LRU)
> +		mask |= __GFP_NOMEMCGROUP;
> +
> +	err = add_to_page_cache_locked(newpage, mapping, index, mask);
>  	if (err) {
>  		printk(KERN_WARNING "fuse_try_move_page: failed to add page");
>  		goto out_fallback_unlock;
> Index: linux-2.6.36-rc3/include/linux/gfp.h
> ===================================================================
> --- linux-2.6.36-rc3.orig/include/linux/gfp.h
> +++ linux-2.6.36-rc3/include/linux/gfp.h
> @@ -60,6 +60,13 @@ struct vm_area_struct;
>  #define __GFP_NOTRACK	((__force gfp_t)0)
>  #endif
>  
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> +#define __GFP_NOMEMCGROUP	((__force gfp_t)0x400000u)
> +	/* Don't track by memory cgroup */
> +#else
> +#define __GFP_NOMEMCGROUP	((__force gfp_t)0)
> +#endif
> +
>  /*
>   * This may seem redundant, but it's a way of annotating false positives vs.
>   * allocations that simply cannot be supported (e.g. page tables).
> Index: linux-2.6.36-rc3/mm/memcontrol.c
> ===================================================================
> --- linux-2.6.36-rc3.orig/mm/memcontrol.c
> +++ linux-2.6.36-rc3/mm/memcontrol.c
> @@ -2114,7 +2114,7 @@ int mem_cgroup_cache_charge(struct page 
>  
>  	if (mem_cgroup_disabled())
>  		return 0;
> -	if (PageCompound(page))
> +	if (PageCompound(page) || (gfp_mask & __GFP_NOMEMCGROUP))
>  		return 0;
>  	/*
>  	 * Corner case handling. This is called from add_to_page_cache()
> 
The comments above says "not-on-LRU pages are out of control. So, add to root cgroup.".
But this change means that we don't charge these pages at all.

Should it be:

	if (gfp_mask & __GFP_NOMEMCGROUP))
		mm = &init_mm;

?
Or, change the comment ?


Thanks,
Daisuke Nishimura.
