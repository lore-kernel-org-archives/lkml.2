Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab1CIGOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 01:14:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43609 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1CIGOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 01:14:37 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 9 Mar 2011 15:07:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] memcg: fix leak on wrong LRU with FUSE
Message-Id: <20110309150750.d570798c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110308181832.6386da5f.nishimura@mxp.nes.nec.co.jp>
References: <20110308135612.e971e1f3.kamezawa.hiroyu@jp.fujitsu.com>
	<20110308181832.6386da5f.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Mar 2011 18:18:32 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Tue, 8 Mar 2011 13:56:12 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > fs/fuse/dev.c::fuse_try_move_page() does
> > 
> >    (1) remove a page by ->steal()
> >    (2) re-add the page to page cache 
> >    (3) link the page to LRU if it was not on LRU at (1)
> > 
> > This implies the page is _on_ LRU when it's added to radix-tree.
> > So, the page is added to  memory cgroup while it's on LRU.
> > because LRU is lazy and no one flushs it.
> > 
> > This is the same behavior as SwapCache and needs special care as
> >  - remove page from LRU before overwrite pc->mem_cgroup.
> >  - add page to LRU after overwrite pc->mem_cgroup.
> > 
> > And we need to taking care of pagevec.
> > 
> > If PageLRU(page) is set before we add PCG_USED bit, the page
> > will not be added to memcg's LRU (in short period).
> > So, regardlress of PageLRU(page) value before commit_charge(),
> > we need to check PageLRU(page) after commit_charge().
> > 
> > Changelog:
> >   - clean up.
> >   - cover !PageLRU() by pagevec case.
> > 
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  mm/memcontrol.c |   53 ++++++++++++++++++++++++++++++++++-------------------
> >  1 file changed, 34 insertions(+), 19 deletions(-)
> > 
> > Index: mmotm-0303/mm/memcontrol.c
> > ===================================================================
> > --- mmotm-0303.orig/mm/memcontrol.c
> > +++ mmotm-0303/mm/memcontrol.c
> > @@ -926,13 +926,12 @@ void mem_cgroup_add_lru_list(struct page
> >  }
> >  
> >  /*
> > - * At handling SwapCache, pc->mem_cgroup may be changed while it's linked to
> > - * lru because the page may.be reused after it's fully uncharged (because of
> > - * SwapCache behavior).To handle that, unlink page_cgroup from LRU when charge
> > - * it again. This function is only used to charge SwapCache. It's done under
> > - * lock_page and expected that zone->lru_lock is never held.
> > + * At handling SwapCache and other FUSE stuff, pc->mem_cgroup may be changed
> > + * while it's linked to lru because the page may be reused after it's fully
> > + * uncharged. To handle that, unlink page_cgroup from LRU when charge it again.
> > + * It's done under lock_page and expected that zone->lru_lock isnever held.
> >   */
> > -static void mem_cgroup_lru_del_before_commit_swapcache(struct page *page)
> > +static void mem_cgroup_lru_del_before_commit(struct page *page)
> >  {
> >  	unsigned long flags;
> >  	struct zone *zone = page_zone(page);
> > @@ -948,7 +947,7 @@ static void mem_cgroup_lru_del_before_co
> >  	spin_unlock_irqrestore(&zone->lru_lock, flags);
> >  }
> >  
> > -static void mem_cgroup_lru_add_after_commit_swapcache(struct page *page)
> > +static void mem_cgroup_lru_add_after_commit(struct page *page)
> >  {
> >  	unsigned long flags;
> >  	struct zone *zone = page_zone(page);
> > @@ -2431,9 +2430,28 @@ static void
> >  __mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr,
> >  					enum charge_type ctype);
> >  
> > +static void
> > +__mem_cgroup_commit_charge_lrucare(struct page *page, struct mem_cgroup *mem,
> > +					enum charge_type ctype)
> > +{
> > +	struct page_cgroup *pc = lookup_page_cgroup(page);
> > +	/*
> > +	 * In some case, SwapCache, FUSE(splice_buf->radixtree), the page
> > +	 * is already on LRU. It means the page may on some other page_cgroup's
> > +	 * LRU. Take care of it.
> > +	 */
> > +	if (unlikely(PageLRU(page)))
> > +		mem_cgroup_lru_del_before_commit(page);
> > +	__mem_cgroup_commit_charge(mem, page, 1, pc, ctype);
> > +	if (unlikely(PageLRU(page)))
> > +		mem_cgroup_lru_add_after_commit(page);
> > +	return;
> > +}
> > +
> >  int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
> >  				gfp_t gfp_mask)
> >  {
> > +	struct mem_cgroup *mem = NULL;
> >  	int ret;
> >  
> >  	if (mem_cgroup_disabled())
> > @@ -2468,14 +2486,15 @@ int mem_cgroup_cache_charge(struct page 
> >  	if (unlikely(!mm))
> >  		mm = &init_mm;
> >  
> > -	if (page_is_file_cache(page))
> > -		return mem_cgroup_charge_common(page, mm, gfp_mask,
> > -				MEM_CGROUP_CHARGE_TYPE_CACHE);
> > -
> > +	if (page_is_file_cache(page)) {
> > +		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, &mem, true);
> > +		if (ret || !mem)
> > +			return ret;
> > +		__mem_cgroup_commit_charge_lrucare(page, mem,
> > +					MEM_CGROUP_CHARGE_TYPE_CACHE);
> > +	}
> We should do "return 0" here, or do:
> 
> } else {
> 	/* shmem */
> 	if (PageSwapCache(page)) {
> 		..
> 	} else {
> 		..
> 	}
> }
> 
> Otherwise, the page cache will be charged twice.
> 

Ahh, thanks. I'll send v3.

-Kame

