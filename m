Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab0DIFBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 01:01:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48782 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0DIFBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 01:01:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Apr 2010 13:56:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 02/13] mm: Revalidate anon_vma in page_lock_anon_vma()
Message-Id: <20100409135657.8f234c9a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100409031641.GG5683@laptop>
References: <20100408191737.296180458@chello.nl>
	<20100408192722.687144862@chello.nl>
	<20100409031641.GG5683@laptop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Apr 2010 13:16:41 +1000
Nick Piggin <npiggin@suse.de> wrote:

> On Thu, Apr 08, 2010 at 09:17:39PM +0200, Peter Zijlstra wrote:
> > There is nothing preventing the anon_vma from being detached while we
> > are spinning to acquire the lock. Most (all?) current users end up
> > calling something like vma_address(page, vma) on it, which has a
> > fairly good chance of weeding out wonky vmas.
> > 
> > However suppose the anon_vma got freed and re-used while we were
> > waiting to acquire the lock, and the new anon_vma fits with the
> > page->index (because that is the only thing vma_address() uses to
> > determine if the page fits in a particular vma, we could end up
> > traversing faulty anon_vma chains.
> > 
> > Close this hole for good by re-validating that page->mapping still
> > holds the very same anon_vma pointer after we acquire the lock, if not
> > be utterly paranoid and retry the whole operation (which will very
> > likely bail, because it's unlikely the page got attached to a different
> > anon_vma in the meantime).
> 
> Hm, looks like a bugfix? How was this supposed to be safe?
> 
IIUC.

Before Rik's change to anon_vma, once page->mapping is set as anon_vma | 0x1,
it's not modified until the page is freed.
After the patch, do_wp_page() overwrite page->mapping when it reuse existing
page.

==
static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
                unsigned long address, pte_t *page_table, pmd_t *pmd,
                spinlock_t *ptl, pte_t orig_pte)
{
....
        if (PageAnon(old_page) && !PageKsm(old_page)) {
                if (!trylock_page(old_page)) {
                        page_cache_get(old_page);
....
                reuse = reuse_swap_page(old_page);
                if (reuse)
                        /*
                         * The page is all ours.  Move it to our anon_vma so
                         * the rmap code will not search our parent or siblings.
                         * Protected against the rmap code by the page lock.
                         */
                        page_move_anon_rmap(old_page, vma, address); ----(*)
}
===		
(*) is new.

Then, this new check makes sense in the current kernel.



>  
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > ---
> >  mm/rmap.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > Index: linux-2.6/mm/rmap.c
> > ===================================================================
> > --- linux-2.6.orig/mm/rmap.c
> > +++ linux-2.6/mm/rmap.c
> > @@ -294,6 +294,7 @@ struct anon_vma *page_lock_anon_vma(stru
> >  	unsigned long anon_mapping;
> >  
> >  	rcu_read_lock();
> > +again:
> >  	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
> >  	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
> >  		goto out;
> > @@ -302,6 +303,12 @@ struct anon_vma *page_lock_anon_vma(stru
> >  
> >  	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
> >  	spin_lock(&anon_vma->lock);
> > +
> > +	if (page_rmapping(page) != anon_vma) {
> 
> very unlikely()?
> 
I think so.

Thanks,
-Kame

