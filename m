Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab2JUSRZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 14:17:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36240 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab2JUSRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 14:17:24 -0400
Date: Sun, 21 Oct 2012 20:17:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, mgorman@suse.de, tglx@linutronix.de
Subject: Re: [tip:numa/core] sched/numa/mm: Improve migration
Message-ID: <20121021181718.GA4565@gmail.com>
References: <tip-yv9vbiz2s455zxq1ffzx3fye@git.kernel.org>
 <20121019135122.GI31863@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019135122.GI31863@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Thu, Oct 18, 2012 at 10:05:39AM -0700, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  713f937655c4b15131b5a0eae4610918a4febe17
> > Gitweb:     http://git.kernel.org/tip/713f937655c4b15131b5a0eae4610918a4febe17
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Fri, 12 Oct 2012 19:30:14 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Mon, 15 Oct 2012 14:18:40 +0200
> > 
> > sched/numa/mm: Improve migration
> > 
> > Add THP migration. Extend task_numa_fault() to absorb THP faults.
> > 
> > [ Would be nice if the gents on Cc: expressed their opinion about
> >   this change. A missing detail might be cgroup page accounting,
> >   plus the fact that some architectures might cache PMD_NONE pmds
> >   in their TLBs, needing some extra TLB magic beyond what we already
> >   do here? ]
> 
> Looks good to me, the cgroup fixup should be easy enough as well
> (added the calls inline below).
> 
> Of course I'm banging my head into a wall for not seeing earlier
> through the existing migration path how easy this could be.  It would
> be great for compaction to have this fastpath in the traditional
> migration code too.
> 
> Right now, unlike the traditional migration path, this breaks COW for
> every migration, but maybe you don't care about shared pages in the
> first place.  And fixing that should be nothing more than grabbing the
> anon_vma lock and using rmap to switch more than one pmd over, right?
> 
> It won't work for pages in swap, which is only a future problem.
> 
> It's slightly ugly that migrate_page_copy() actually modifies the
> existing page (deactivation, munlock) when you end up having to revert
> back to it.
> 
> The new page needs to be PageUptodate.
> 
> > +	task_numa_placement();
> > +
> > +	new_page = alloc_pages_node(node,
> > +	    (GFP_TRANSHUGE | GFP_THISNODE) & ~(__GFP_NO_KSWAPD | __GFP_WAIT),
> > +	    HPAGE_PMD_ORDER);
> > +
> > +	WARN_ON(PageLRU(new_page));

This WARN_ON() is somewhat problematic in OOM or OOLNM 
situations, so I removed it ;-)

> > +
> > +	if (!new_page)
> > +		goto alloc_fail;
> 
> 	mem_cgroup_prepare_migration(page, new_page, &memcg);
> 
> > +	lru = PageLRU(page);
> > +
> > +	if (lru && isolate_lru_page(page)) /* does an implicit get_page() */
> > +		goto alloc_fail;
> > +
> > +	if (!trylock_page(new_page))
> > +		BUG();
> > +
> > +	/* anon mapping, we can simply copy page->mapping to the new page: */
> > +	new_page->mapping = page->mapping;
> > +	new_page->index = page->index;
> > +
> > +	migrate_page_copy(new_page, page);
> > +
> > +	WARN_ON(PageLRU(new_page));
> >  
> > -do_fixup:
> >  	spin_lock(&mm->page_table_lock);
> > -	if (unlikely(!pmd_same(*pmd, entry)))
> > -		goto out_unlock;
> > -#endif
> > +	if (unlikely(!pmd_same(*pmd, entry))) {
> > +		spin_unlock(&mm->page_table_lock);
> > +		if (lru)
> > +			putback_lru_page(page);
> >  
> > -	/* change back to regular protection */
> > -	entry = pmd_modify(entry, vma->vm_page_prot);
> > -	if (pmdp_set_access_flags(vma, haddr, pmd, entry, 1))
> > -		update_mmu_cache(vma, address, entry);
> > +		unlock_page(new_page);
> > +		ClearPageActive(new_page);	/* Set by migrate_page_copy() */
> > +		new_page->mapping = NULL;
> > +		put_page(new_page);		/* Free it */
> >  
> > -out_unlock:
> > +		unlock_page(page);
> > +		put_page(page);			/* Drop the local reference */
> > +
> > +		return;
> > +	}
> > +
> > +	entry = mk_pmd(new_page, vma->vm_page_prot);
> > +	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
> > +	entry = pmd_mkhuge(entry);
> > +
> > +	page_add_new_anon_rmap(new_page, vma, haddr);
> > +
> > +	set_pmd_at(mm, haddr, pmd, entry);
> > +	update_mmu_cache(vma, address, entry);
> > +	page_remove_rmap(page);
> >  	spin_unlock(&mm->page_table_lock);
> > -	if (page)
> > +
> > +	put_page(page);			/* Drop the rmap reference */
> > +
> > +	task_numa_fault(node, HPAGE_PMD_NR);
> > +
> > +	if (lru)
> > +		put_page(page);		/* drop the LRU isolation reference */
> > +
> > +	unlock_page(new_page);
> 
> 	mem_cgroup_end_migration(memcg, page, new_page, true);
> 
> > +	unlock_page(page);
> > +	put_page(page);			/* Drop the local reference */
> > +
> > +	return;
> > +
> > +alloc_fail:
> > +	if (new_page)
> > +		put_page(new_page);
> 		mem_cgroup_end_migration(memcg, page, new_page, false);
> 	}
> 
> > +	task_numa_fault(page_to_nid(page), HPAGE_PMD_NR);
> > +	unlock_page(page);
> > +
> > +	spin_lock(&mm->page_table_lock);
> > +	if (unlikely(!pmd_same(*pmd, entry))) {
> >  		put_page(page);
> > +		page = NULL;
> > +		goto unlock;
> > +	}
> > +	goto fixup;
> >  }

Cool!

Would any of the gents be interested in turning the suggestions 
above into a suitable patch against this tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git numa/core

?

Thanks a ton!

	Ingo
