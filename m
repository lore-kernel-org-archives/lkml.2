Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab0JREof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 00:44:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48011 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0JREoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 00:44:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 18 Oct 2010 13:38:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Greg Thelen <gthelen@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [RFC][PATCH 1/2] memcg: avoiding unnecessary get_page at
 move_charge
Message-Id: <20101018133839.80d4bca2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101018132901.a05808d1.nishimura@mxp.nes.nec.co.jp>
References: <20101015170627.e5033fa4.kamezawa.hiroyu@jp.fujitsu.com>
	<20101015171109.d4575c95.kamezawa.hiroyu@jp.fujitsu.com>
	<20101018132901.a05808d1.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 13:29:01 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Fri, 15 Oct 2010 17:11:09 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > perf's log is
> >     10.82%     echo  [kernel.kallsyms]  [k] isolate_lru_page
> >     10.01%     echo  [kernel.kallsyms]  [k] mem_cgroup_move_account
> >      8.75%     echo  [kernel.kallsyms]  [k] is_target_pte_for_mc
> >      8.52%     echo  [kernel.kallsyms]  [k] ____pagevec_lru_add
> >      6.90%     echo  [kernel.kallsyms]  [k] putback_lru_page
> >      6.36%     echo  [kernel.kallsyms]  [k] mem_cgroup_add_lru_list
> >      6.22%     echo  [kernel.kallsyms]  [k] mem_cgroup_del_lru_list
> >      5.68%     echo  [kernel.kallsyms]  [k] lookup_page_cgroup
> >      5.28%     echo  [kernel.kallsyms]  [k] __lru_cache_add
> >      5.00%     echo  [kernel.kallsyms]  [k] release_pages
> >      3.79%     echo  [kernel.kallsyms]  [k] _raw_spin_lock_irq
> >      3.52%     echo  [kernel.kallsyms]  [k] memcg_check_events
> >      3.38%     echo  [kernel.kallsyms]  [k] bit_spin_lock
> >      3.25%     echo  [kernel.kallsyms]  [k] put_page
> > 
> > seems nice. I updated isolate_lru_page()'s comment, too.
> > 
> > # Note: isolate_lru_page() is necessary before account move for avoinding
> >         memcg's LRU manipulation.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  mm/memcontrol.c |   63 +++++++++++++++++++++++++++++++++++---------------------
> >  mm/vmscan.c     |    3 +-
> >  2 files changed, 42 insertions(+), 24 deletions(-)
> > 
> > Index: mmotm-1013/mm/memcontrol.c
> > ===================================================================
> > --- mmotm-1013.orig/mm/memcontrol.c
> > +++ mmotm-1013/mm/memcontrol.c
> > @@ -1169,7 +1169,6 @@ static void mem_cgroup_end_move(struct m
> >   *			  under hierarchy of moving cgroups. This is for
> >   *			  waiting at hith-memory prressure caused by "move".
> >   */
> > -
> >  static bool mem_cgroup_stealed(struct mem_cgroup *mem)
> >  {
> >  	VM_BUG_ON(!rcu_read_lock_held());
> > @@ -4471,11 +4470,14 @@ one_by_one:
> >   * Returns
> >   *   0(MC_TARGET_NONE): if the pte is not a target for move charge.
> >   *   1(MC_TARGET_PAGE): if the page corresponding to this pte is a target for
> > - *     move charge. if @target is not NULL, the page is stored in target->page
> > - *     with extra refcnt got(Callers should handle it).
> > + *     move charge and it's mapped.. if @target is not NULL, the page is
> > + *     stored in target->pagewithout extra refcnt.
>                                ^^ needs ' '.
> 
> >   *   2(MC_TARGET_SWAP): if the swap entry corresponding to this pte is a
> >   *     target for charge migration. if @target is not NULL, the entry is stored
> >   *     in target->ent.
> > + *   3(MC_TARGET_UNMAPPED_PAGE): if the page corresponding to this pte is a
> > + *     target for move charge. if @target is not NULL, the page is stored in
> > + *     target->page with extra refcnt got(Callers should handle it).
> >   *
> >   * Called with pte lock held.
> >   */
> > @@ -4486,8 +4488,9 @@ union mc_target {
> >  
> >  enum mc_target_type {
> >  	MC_TARGET_NONE,	/* not used */
> > -	MC_TARGET_PAGE,
> > +	MC_TARGET_PAGE, /* a page mapped */
> >  	MC_TARGET_SWAP,
> > +	MC_TARGET_UNMAPPED_PAGE, /* a page unmapped */
> >  };
> >  
> I prefer the order of "MC_TARGET_PAGE", "MC_TARGET_UNMAPPED_PAGE", and "MC_TARGET_SWAP".
> 
ok.

> >  static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
> > @@ -4504,9 +4507,10 @@ static struct page *mc_handle_present_pt
> >  	} else if (!move_file())
> >  		/* we ignore mapcount for file pages */
> >  		return NULL;
> > -	if (!get_page_unless_zero(page))
> > -		return NULL;
> > -
> > +	/*
> > + 	 * Because we're under pte_lock and the page is mapped,
> > +	 * get_page() isn't necessary
> > +	 */
> >  	return page;
> >  }
> >  
> > @@ -4570,14 +4574,18 @@ static int is_target_pte_for_mc(struct v
> >  	struct page *page = NULL;
> >  	struct page_cgroup *pc;
> >  	int ret = 0;
> > +	bool present = true;
> >  	swp_entry_t ent = { .val = 0 };
> >  
> >  	if (pte_present(ptent))
> >  		page = mc_handle_present_pte(vma, addr, ptent);
> > -	else if (is_swap_pte(ptent))
> > -		page = mc_handle_swap_pte(vma, addr, ptent, &ent);
> > -	else if (pte_none(ptent) || pte_file(ptent))
> > -		page = mc_handle_file_pte(vma, addr, ptent, &ent);
> > +	else {
> > +		present = false;
> > +	 	if (is_swap_pte(ptent))
> > +			page = mc_handle_swap_pte(vma, addr, ptent, &ent);
> > +		else if (pte_none(ptent) || pte_file(ptent))
> > +			page = mc_handle_file_pte(vma, addr, ptent, &ent);
> > +	}
> >  
> >  	if (!page && !ent.val)
> >  		return 0;
> > @@ -4589,11 +4597,15 @@ static int is_target_pte_for_mc(struct v
> >  		 * the lock.
> >  		 */
> >  		if (PageCgroupUsed(pc) && pc->mem_cgroup == mc.from) {
> > -			ret = MC_TARGET_PAGE;
> > +			if (present)
> > +				ret = MC_TARGET_PAGE;
> > +			else
> > +				ret = MC_TARGET_UNMAPPED_PAGE;
> >  			if (target)
> >  				target->page = page;
> >  		}
> > -		if (!ret || !target)
> > +		/* We got refcnt but the page is not for target */
> > +		if (!present && (!ret || !target))
> >  			put_page(page);
> >  	}
> >  	/* There is a swap entry and a page doesn't exist or isn't charged */
> > @@ -4780,19 +4792,24 @@ retry:
> >  		type = is_target_pte_for_mc(vma, addr, ptent, &target);
> >  		switch (type) {
> >  		case MC_TARGET_PAGE:
> > +		case MC_TARGET_UNMAPPED_PAGE:
> >  			page = target.page;
> > -			if (isolate_lru_page(page))
> > -				goto put;
> > -			pc = lookup_page_cgroup(page);
> > -			if (!mem_cgroup_move_account(pc,
> > +			if (!isolate_lru_page(page)) {
> > +				pc = lookup_page_cgroup(page);
> > +				if (!mem_cgroup_move_account(pc,
> >  						mc.from, mc.to, false)) {
> > -				mc.precharge--;
> > -				/* we uncharge from mc.from later. */
> > -				mc.moved_charge++;
> > +					mc.precharge--;
> > +					/* we uncharge from mc.from later. */
> > +					mc.moved_charge++;
> > +				}
> > +				putback_lru_page(page);
> >  			}
> > -			putback_lru_page(page);
> > -put:			/* is_target_pte_for_mc() gets the page */
> > -			put_page(page);
> > +			/*
> > +			 * Because we holds pte_lock, we have a stable reference			 * to the page if mapped. If not mapped, we have an
> 
> You need a new line :)
> 
yes.

I'll reorder patches and push this after dirty_ratio patches goes.
But before doing that, I'll show an extreme version.

Thanks,
-Kame

