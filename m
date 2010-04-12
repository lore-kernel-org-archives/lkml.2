Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0DLSmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 14:42:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:42511 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab0DLSmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 14:42:04 -0400
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Borislav Petkov <bp@alien8.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
In-Reply-To: <alpine.LFD.2.00.1004120941310.26679@i5.linux-foundation.org>
References: <20100409191425.GB10780@a1.tnic>
	 <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>
	 <20100409204328.GG28964@cmpxchg.org>
	 <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
	 <20100410003110.GI28964@cmpxchg.org>
	 <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org>
	 <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic>
	 <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>
	 <20100410163828.GA25579@a1.tnic>
	 <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
	 <1271083207.4807.18.camel@twins>  <4BC33A02.8000307@redhat.com>
	 <1271088103.20295.3383.camel@laptop> <4BC34501.5060401@redhat.com>
	 <alpine.LFD.2.00.1004120941310.26679@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 12 Apr 2010 20:40:38 +0200
Message-ID: <1271097638.4807.129.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-12 at 09:46 -0700, Linus Torvalds wrote: 
> 
> On Mon, 12 Apr 2010, Rik van Riel wrote:
> 
> > On 04/12/2010 12:01 PM, Peter Zijlstra wrote:
> > 
> > > @@ -864,15 +889,8 @@ void page_remove_rmap(struct page *page)
> > >   		__dec_zone_page_state(page, NR_FILE_MAPPED);
> > >   		mem_cgroup_update_file_mapped(page, -1);
> > >   	}
> > > -	/*
> > > -	 * It would be tidy to reset the PageAnon mapping here,
> > > -	 * but that might overwrite a racing page_add_anon_rmap
> > > -	 * which increments mapcount after us but sets mapping
> > > -	 * before us: so leave the reset to free_hot_cold_page,
> > > -	 * and remember that it's only reliable while mapped.
> > > -	 * Leaving it set also helps swapoff to reinstate ptes
> > > -	 * faster for those pages still in swapcache.
> > > -	 */
> > > +
> > > +	page->mapping = NULL;
> > >   }
> > 
> > That would be a bug for file pages :)
> > 
> > I could see how it could work for anonymous memory, though.
> 
> I think it's scary for anonymous pages too. The _common_ case of 
> page_remove_rmap() is from unmap/exit, which holds no locks on the page 
> what-so-ever. So assuming the page could be reachable some other way (swap 
> cache etc), I think the above is pretty scary. 

Fully agreed.

> Also do note that the bug we've been chasing has _always_ had that test 
> for "page_mapped(page)". See my other email about why the unmapped case 
> isn't even interesting, because it's so easy to see how page->mapping can 
> be stale for unmapped pages.
> 
> It's the _mapped_ case that is interesting, not the unmapped one. So 
> setting page->mapping to NULL when unmapping is perhaps a nice consistency 
> issue ("never have stale pointers"), but it's missing the fact that it's 
> not really the case we care about.

Yes, I don't think this is the problem that has been plaguing us for
over a week now.

But while staring at that code it did get me worried that the current
code (page_lock_anon_vma):

- is missing the smp_read_barrier_depends() after the ACCESS_ONCE
- isn't properly ordered wrt page->mapping and page->_mapcount.
- doesn't appear to guarantee much at all when returning an anon_vma
  since it locks after checking page->_mapcount so:
    * it can return !NULL for an unmapped page (your patch cures that)
    * it can return !NULL but for a different anon_vma
      (my earlier patch checking page_rmapping() after the spin_lock
       cures that, but doesn't cure the above):

        [ highly unlikely but not impossible race ]

        page_referenced(page_A)

			try_to_unmap(page_A)

					unrelated fault

							fault page_A

	CPU0		CPU1		CPU2		CPU3

	rcu_read_lock()
	anon_vma = page->mapping;
	if (!anon_vma & ANON_BIT)
	  goto out
	if (!page_mapped(page))
	  goto out

			page_remove_rmap()
			...
			anon_vma_free()-----\
					    v
					anon_vma_alloc()
					
							anon_vma_alloc()
							page_add_anon_rmap()
					   ^
	spin_lock(anon_vma->lock)----------/


    Now I don't think the above can happen due to how our slab
    allocators work, they won't share a slab page between cpus like
    that, but once we make the whole thing preemptible this race
    becomes a lot more likely.


So a page_lock_anon_vma(), that looks a little like the below should
(I think) cure all our problems with it.


struct anon_vma *page_lock_anon_vma(struct page *page)
{
	struct anon_vma *anon_vma;
	unsigned long anon_mapping;

	rcu_read_lock();
again:
	anon_mapping = (unsigned long)rcu_dereference(page->mapping);
	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
		goto out;
	anon_vma = (struct anon_vma *)(anon_mapping - PAGE_MAPPING_ANON);

	/*
	 * The RCU read lock ensures we can safely dereference anon_vma
	 * since it ensures the backing slab won't go away. It will however
	 * not guarantee it's the right object.
	 *
	 * First take the anon_vma->lock, this will, per anon_vma_unlink()
	 * avoid this anon_vma from being freed if it is a valid object.
	 */
	spin_lock(&anon_vma->lock);

	/*
	 * Secondly, we have to re-read page->mapping, so ensure it
	 * has not changed, rely on spin_lock() being at least a
	 * compiler barrier to force the re-read.
	 */
	if (unlikely(page_rmapping(page) != anon_vma)) {
		spin_unlock(&anon_vma->lock);
		goto again;
	}

	/*
	 * Ensure we read page->mapping before page->_mapcount,
	 * orders against atomic_add_negative() in page_remove_rmap().
	 */
	smp_rmb();

	/*
	 * Finally check that the page is still mapped,
	 * if not, this can't possibly be the right anon_vma.
	 */
	if (!page_mapped(page))
		goto unlock;

	return anon_vma;

unlock:
	spin_unlock(&anon_vma->lock);
out:
	rcu_read_unlock();
	return NULL;
}


With this, I think we can actually drop the RCU read lock when returning
since if this is indeed a valid anon_vma for this page, then the page is
still mapped, and hence the anon_vma was not deleted, and a possible
future delete will be held back by us holding the anon_vma->lock.

Now I could be totally wrong and have confused myself throroughly, but
how does this look?
