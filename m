Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab0G3ARx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 20:17:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40631 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab0G3ARv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 20:17:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 30 Jul 2010 09:12:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "balbir\@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura\@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        vgoyal@redhat.com, m-ikeda@ds.jp.nec.com,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5]  use ID in page cgroup
Message-Id: <20100730091259.052a2902.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <xr9339v2m970.fsf@ninji.mtv.corp.google.com>
References: <20100729184250.acdff587.kamezawa.hiroyu@jp.fujitsu.com>
	<20100729184606.df7e639f.kamezawa.hiroyu@jp.fujitsu.com>
	<xr9339v2m970.fsf@ninji.mtv.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010 11:31:15 -0700
Greg Thelen <gthelen@google.com> wrote:

> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > Now, addresses of memory cgroup can be calculated by their ID without complex.
> > This patch relplaces pc->mem_cgroup from a pointer to a unsigned short.
> > On 64bit architecture, this offers us more 6bytes room per page_cgroup.
> > Use 2bytes for blkio-cgroup's page tracking. More 4bytes will be used for
> > some light-weight concurrent access.
> >
> > We may able to move this id onto flags field but ...go step by step.
> >
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  include/linux/page_cgroup.h |    3 ++-
> >  mm/memcontrol.c             |   40 +++++++++++++++++++++++++---------------
> >  mm/page_cgroup.c            |    2 +-
> >  3 files changed, 28 insertions(+), 17 deletions(-)
> >
> > Index: mmotm-0727/include/linux/page_cgroup.h
> > ===================================================================
> > --- mmotm-0727.orig/include/linux/page_cgroup.h
> > +++ mmotm-0727/include/linux/page_cgroup.h
> > @@ -12,7 +12,8 @@
> >   */
> >  struct page_cgroup {
> >  	unsigned long flags;
> > -	struct mem_cgroup *mem_cgroup;
> > +	unsigned short mem_cgroup;	/* ID of assigned memory cgroup */
> > +	unsigned short blk_cgroup;	/* Not Used..but will be. */
> >  	struct page *page;
> >  	struct list_head lru;		/* per cgroup LRU list */
> >  };
> > Index: mmotm-0727/mm/page_cgroup.c
> > ===================================================================
> > --- mmotm-0727.orig/mm/page_cgroup.c
> > +++ mmotm-0727/mm/page_cgroup.c
> > @@ -15,7 +15,7 @@ static void __meminit
> >  __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
> >  {
> >  	pc->flags = 0;
> > -	pc->mem_cgroup = NULL;
> > +	pc->mem_cgroup = 0;
> >  	pc->page = pfn_to_page(pfn);
> >  	INIT_LIST_HEAD(&pc->lru);
> >  }
> > Index: mmotm-0727/mm/memcontrol.c
> > ===================================================================
> > --- mmotm-0727.orig/mm/memcontrol.c
> > +++ mmotm-0727/mm/memcontrol.c
> > @@ -376,7 +376,7 @@ struct cgroup_subsys_state *mem_cgroup_c
> >  static struct mem_cgroup_per_zone *
> >  page_cgroup_zoneinfo(struct page_cgroup *pc)
> >  {
> > -	struct mem_cgroup *mem = pc->mem_cgroup;
> > +	struct mem_cgroup *mem = id_to_memcg(pc->mem_cgroup);
> >  	int nid = page_cgroup_nid(pc);
> >  	int zid = page_cgroup_zid(pc);
> >  
> > @@ -581,7 +581,11 @@ static void mem_cgroup_charge_statistics
> >  					 bool charge)
> >  {
> >  	int val = (charge) ? 1 : -1;
> > -
> > +	if (pc->mem_cgroup == 0) {
> > +		show_stack(NULL, NULL);
> > +		printk("charge to 0\n");
> > +		while(1);
> > +	}
> Why hang the task here.  If this is bad then maybe BUG_ON()?

Ouch, debug code is remaining.

> >  	preempt_disable();
> >  
> >  	if (PageCgroupCache(pc))
> > @@ -718,6 +722,11 @@ static inline bool mem_cgroup_is_root(st
> >  	return (mem == root_mem_cgroup);
> >  }
> >  
> > +static inline bool mem_cgroup_is_rootid(unsigned short id)
> > +{
> > +	return (id == 1);
> > +}
> > +
> >  /*
> >   * Following LRU functions are allowed to be used without PCG_LOCK.
> >   * Operations are called by routine of global LRU independently from memcg.
> > @@ -750,7 +759,7 @@ void mem_cgroup_del_lru_list(struct page
> >  	 */
> >  	mz = page_cgroup_zoneinfo(pc);
> >  	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
> > -	if (mem_cgroup_is_root(pc->mem_cgroup))
> > +	if (mem_cgroup_is_rootid(pc->mem_cgroup))
> >  		return;
> >  	VM_BUG_ON(list_empty(&pc->lru));
> >  	list_del_init(&pc->lru);
> > @@ -777,7 +786,7 @@ void mem_cgroup_rotate_lru_list(struct p
> >  	 */
> >  	smp_rmb();
> >  	/* unused or root page is not rotated. */
> > -	if (!PageCgroupUsed(pc) || mem_cgroup_is_root(pc->mem_cgroup))
> > +	if (!PageCgroupUsed(pc) || mem_cgroup_is_rootid(pc->mem_cgroup))
> >  		return;
> >  	mz = page_cgroup_zoneinfo(pc);
> >  	list_move(&pc->lru, &mz->lists[lru]);
> > @@ -803,7 +812,7 @@ void mem_cgroup_add_lru_list(struct page
> >  	mz = page_cgroup_zoneinfo(pc);
> >  	MEM_CGROUP_ZSTAT(mz, lru) += 1;
> >  	SetPageCgroupAcctLRU(pc);
> > -	if (mem_cgroup_is_root(pc->mem_cgroup))
> > +	if (mem_cgroup_is_rootid(pc->mem_cgroup))
> >  		return;
> >  	list_add(&pc->lru, &mz->lists[lru]);
> >  }
> > @@ -1471,7 +1480,7 @@ void mem_cgroup_update_file_mapped(struc
> >  		return;
> >  
> >  	lock_page_cgroup(pc);
> > -	mem = pc->mem_cgroup;
> > +	mem = id_to_memcg(pc->mem_cgroup);
> >  	if (!mem || !PageCgroupUsed(pc))
> >  		goto done;
> >  
> > @@ -1859,7 +1868,7 @@ struct mem_cgroup *try_get_mem_cgroup_fr
> >  	pc = lookup_page_cgroup(page);
> >  	lock_page_cgroup(pc);
> >  	if (PageCgroupUsed(pc)) {
> > -		mem = pc->mem_cgroup;
> > +		mem = id_to_memcg(pc->mem_cgroup);
> >  		if (mem && !css_tryget(&mem->css))
> >  			mem = NULL;
> >  	} else if (PageSwapCache(page)) {
> > @@ -1895,7 +1904,7 @@ static void __mem_cgroup_commit_charge(s
> >  		return;
> >  	}
> >  
> > -	pc->mem_cgroup = mem;
> > +	pc->mem_cgroup = css_id(&mem->css);
> >  	/*
> >  	 * We access a page_cgroup asynchronously without lock_page_cgroup().
> >  	 * Especially when a page_cgroup is taken from a page, pc->mem_cgroup
> > @@ -1953,7 +1962,7 @@ static void __mem_cgroup_move_account(st
> >  	VM_BUG_ON(PageLRU(pc->page));
> >  	VM_BUG_ON(!PageCgroupLocked(pc));
> >  	VM_BUG_ON(!PageCgroupUsed(pc));
> > -	VM_BUG_ON(pc->mem_cgroup != from);
> > +	VM_BUG_ON(id_to_memcg(pc->mem_cgroup) != from);
> >  
> >  	if (PageCgroupFileMapped(pc)) {
> >  		/* Update mapped_file data for mem_cgroup */
> > @@ -1968,7 +1977,7 @@ static void __mem_cgroup_move_account(st
> >  		mem_cgroup_cancel_charge(from);
> >  
> >  	/* caller should have done css_get */
> > -	pc->mem_cgroup = to;
> > +	pc->mem_cgroup = css_id(&to->css);
> >  	mem_cgroup_charge_statistics(to, pc, true);
> >  	/*
> >  	 * We charges against "to" which may not have any tasks. Then, "to"
> > @@ -1988,7 +1997,7 @@ static int mem_cgroup_move_account(struc
> >  {
> >  	int ret = -EINVAL;
> >  	lock_page_cgroup(pc);
> > -	if (PageCgroupUsed(pc) && pc->mem_cgroup == from) {
> > +	if (PageCgroupUsed(pc) && id_to_memcg(pc->mem_cgroup) == from) {
> >  		__mem_cgroup_move_account(pc, from, to, uncharge);
> >  		ret = 0;
> >  	}
> > @@ -2327,9 +2336,9 @@ __mem_cgroup_uncharge_common(struct page
> >  
> >  	lock_page_cgroup(pc);
> >  
> > -	mem = pc->mem_cgroup;
> > +	mem = id_to_memcg(pc->mem_cgroup);
> >  
> > -	if (!PageCgroupUsed(pc))
> > +	if (!mem || !PageCgroupUsed(pc))
> Why add the extra !mem check here?
> 
> Can PageCgroupUsed() return true if mem==NULL?
> 
mem && PageCgroupUsed()  => what we want
mem && !PageCgroupUsed() => can be true
!mem && PageCgroupUsed() => never happens(bug?)
!mem && !PageCgroupUsed() => a clean state.

AH, yes. debug code again.

Thanks,
-Kame

