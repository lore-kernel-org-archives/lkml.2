Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab0DIGej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:34:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60319 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab0DIGeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:34:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 02/13] mm: Revalidate anon_vma in page_lock_anon_vma()
Cc: kosaki.motohiro@jp.fujitsu.com, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20100409135657.8f234c9a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100409031641.GG5683@laptop> <20100409135657.8f234c9a.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20100409150335.80E3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  9 Apr 2010 15:34:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 9 Apr 2010 13:16:41 +1000
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > On Thu, Apr 08, 2010 at 09:17:39PM +0200, Peter Zijlstra wrote:
> > > There is nothing preventing the anon_vma from being detached while we
> > > are spinning to acquire the lock. Most (all?) current users end up
> > > calling something like vma_address(page, vma) on it, which has a
> > > fairly good chance of weeding out wonky vmas.
> > > 
> > > However suppose the anon_vma got freed and re-used while we were
> > > waiting to acquire the lock, and the new anon_vma fits with the
> > > page->index (because that is the only thing vma_address() uses to
> > > determine if the page fits in a particular vma, we could end up
> > > traversing faulty anon_vma chains.
> > > 
> > > Close this hole for good by re-validating that page->mapping still
> > > holds the very same anon_vma pointer after we acquire the lock, if not
> > > be utterly paranoid and retry the whole operation (which will very
> > > likely bail, because it's unlikely the page got attached to a different
> > > anon_vma in the meantime).
> > 
> > Hm, looks like a bugfix? How was this supposed to be safe?
> > 
> IIUC.
> 
> Before Rik's change to anon_vma, once page->mapping is set as anon_vma | 0x1,
> it's not modified until the page is freed.
> After the patch, do_wp_page() overwrite page->mapping when it reuse existing
> page.

Why?
IIUC. page->mapping dereference in page_lock_anon_vma() makes four story.

1. the anon_vma is valid
	-> do page_referenced_one(). 
2. the anon_vma is invalid and freed to buddy
	-> bail out by page_mapped(), no touch anon_vma
3. the anon_vma is kfreed, and not reused
	-> bail out by page_mapped()
4. the anon_vma is kfreed, but reused as another anon_vma
	-> bail out by page_check_address()

Now we have to consider 5th story.

5. the anon_vma is exchanged another anon_vma by do_wp_page.
	-> bail out by above bailing out stuff.


I agree peter's patch makes sense. but I don't think Rik's patch change
locking rule.


> 
> ==
> static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
>                 unsigned long address, pte_t *page_table, pmd_t *pmd,
>                 spinlock_t *ptl, pte_t orig_pte)
> {
> ....
>         if (PageAnon(old_page) && !PageKsm(old_page)) {
>                 if (!trylock_page(old_page)) {
>                         page_cache_get(old_page);
> ....
>                 reuse = reuse_swap_page(old_page);
>                 if (reuse)
>                         /*
>                          * The page is all ours.  Move it to our anon_vma so
>                          * the rmap code will not search our parent or siblings.
>                          * Protected against the rmap code by the page lock.
>                          */
>                         page_move_anon_rmap(old_page, vma, address); ----(*)
> }
> ===		
> (*) is new.
> 
> Then, this new check makes sense in the current kernel.





