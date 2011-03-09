Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1CIXn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 18:43:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46928 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab1CIXnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:43:25 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Mar 2011 08:36:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] memcg: fix leak on wrong LRU with FUSE
Message-Id: <20110310083659.fd8b1c3f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110309100020.GD30778@cmpxchg.org>
References: <20110308135612.e971e1f3.kamezawa.hiroyu@jp.fujitsu.com>
	<20110308181832.6386da5f.nishimura@mxp.nes.nec.co.jp>
	<20110309150750.d570798c.kamezawa.hiroyu@jp.fujitsu.com>
	<20110309164801.3a4c8d10.kamezawa.hiroyu@jp.fujitsu.com>
	<20110309100020.GD30778@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Mar 2011 11:00:20 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Wed, Mar 09, 2011 at 04:48:01PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Wed, 9 Mar 2011 15:07:50 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > > } else {
> > > > 	/* shmem */
> > > > 	if (PageSwapCache(page)) {
> > > > 		..
> > > > 	} else {
> > > > 		..
> > > > 	}
> > > > }
> > > > 
> > > > Otherwise, the page cache will be charged twice.
> > > > 
> > > 
> > > Ahh, thanks. I'll send v3.
> > > 
> > 
> > Okay, this is a fixed one.
> > ==
> > 
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
> > Changelog v2=>v3:
> >   - fixed double accounting.
> > 
> > Changelog v1=>v2:
> >   - clean up.
> >   - cover !PageLRU() by pagevec case.
> > 
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Thanks for the fix.  I have a few comments below.  Only nitpicks
> though, the patch looks correct to me.
> 
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> 

Thank you for review.


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
> 
> Do we need the extra check?  mem_cgroup_lru_del_before_commit() will
> do the right thing if the page is not on the list.
> 

lru_del_before_commit does checks under zone->lru_lock. So, it's very very heavy.
Hmm, I'll move the check under mem_cgroup_lru_del_before_commit() before lock.


> > +	__mem_cgroup_commit_charge(mem, page, 1, pc, ctype);
> > +	if (unlikely(PageLRU(page)))
> > +		mem_cgroup_lru_add_after_commit(page);
> 
> Same here, mem_cgroup_lru_add_after_commit() has its own check for
> PG_lru.
> 

I'll move the check.


> > @@ -2468,14 +2486,16 @@ int mem_cgroup_cache_charge(struct page 
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
> 
> I think the comment about why we need to take care of the LRU status
> would make more sense here (rather than in the _lrucare function),
> because it is here where you make handling the lru a consequence of
> the page being a file page.
> 
Sure.

> How about this?
> 
> 		/*
> 		 * FUSE reuses pages without going through the final
> 		 * put that would remove them from the LRU list, make
> 		 * sure that they get relinked properly.
> 		 */


will add. Thank you !

-Kame

