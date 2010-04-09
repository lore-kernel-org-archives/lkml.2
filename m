Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab0DIHaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 03:30:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44072 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab0DIHaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 03:30:06 -0400
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
In-Reply-To: <20100409154730.e9945cbc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100409150335.80E3.A69D9226@jp.fujitsu.com> <20100409154730.e9945cbc.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20100409160252.80E6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  9 Apr 2010 16:29:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri,  9 Apr 2010 15:34:33 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > On Fri, 9 Apr 2010 13:16:41 +1000
> > > Nick Piggin <npiggin@suse.de> wrote:
> > > 
> > > > On Thu, Apr 08, 2010 at 09:17:39PM +0200, Peter Zijlstra wrote:
> > > > > There is nothing preventing the anon_vma from being detached while we
> > > > > are spinning to acquire the lock. Most (all?) current users end up
> > > > > calling something like vma_address(page, vma) on it, which has a
> > > > > fairly good chance of weeding out wonky vmas.
> > > > > 
> > > > > However suppose the anon_vma got freed and re-used while we were
> > > > > waiting to acquire the lock, and the new anon_vma fits with the
> > > > > page->index (because that is the only thing vma_address() uses to
> > > > > determine if the page fits in a particular vma, we could end up
> > > > > traversing faulty anon_vma chains.
> > > > > 
> > > > > Close this hole for good by re-validating that page->mapping still
> > > > > holds the very same anon_vma pointer after we acquire the lock, if not
> > > > > be utterly paranoid and retry the whole operation (which will very
> > > > > likely bail, because it's unlikely the page got attached to a different
> > > > > anon_vma in the meantime).
> > > > 
> > > > Hm, looks like a bugfix? How was this supposed to be safe?
> > > > 
> > > IIUC.
> > > 
> > > Before Rik's change to anon_vma, once page->mapping is set as anon_vma | 0x1,
> > > it's not modified until the page is freed.
> > > After the patch, do_wp_page() overwrite page->mapping when it reuse existing
> > > page.
> > 
> > Why?
> > IIUC. page->mapping dereference in page_lock_anon_vma() makes four story.
> > 
> > 1. the anon_vma is valid
> > 	-> do page_referenced_one(). 
> > 2. the anon_vma is invalid and freed to buddy
> > 	-> bail out by page_mapped(), no touch anon_vma
> > 3. the anon_vma is kfreed, and not reused
> > 	-> bail out by page_mapped()
> > 4. the anon_vma is kfreed, but reused as another anon_vma
> > 	-> bail out by page_check_address()
> > 
> > Now we have to consider 5th story.
> > 
> > 5. the anon_vma is exchanged another anon_vma by do_wp_page.
> > 	-> bail out by above bailing out stuff.
> > 
> > 
> > I agree peter's patch makes sense. but I don't think Rik's patch change
> > locking rule.
> > 
> 
> Hmm, I think following.
> 
> Assume a page is ANON and SwapCache, and it has only one reference.
> Consider it's read-only mapped and cause do_wp_page().
> page_mapcount(page) == 1 here.
> 
>     CPU0                          CPU1
> 
> 1. do_wp_page()
> 2. .....
> 3. replace anon_vma.     anon_vma = lock_page_anon_vma()
> 
> So, lock_page_anon_vma() may have lock on wrong anon_vma, here.(mapcount=1)
> 
> 4. modify pte to writable.        do something...
> 
> After lock, in CPU1, a pte of estimated address by vma_address(vma, page)
> containes pfn of the page and page_check_address() will success.
> 
> I'm not sure how this is dangerouns.
> But it's possible that CPU1 cannot notice there was anon_vma replacement.
> And modifies pte withoug holding anon vma's lock which the code believes
> it's holded.


Hehe, page_referenced() already can take unstable VM_LOCKED value. So,
In worst case we make false positive pageout, but it's not disaster.
I think. Anyway "use after free" don't happen by this blutal code.

However, I think you pointed one good thing. before Rik patch, we don't have
page->mapping reassignment. then, we didn't need rcu_dereference().
but now it can happen. so, I think rcu_dereference() is better.

Perhaps, I'm missing something.


diff --git a/mm/rmap.c b/mm/rmap.c
index 8b088f0..b4a0b5b 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -295,7 +295,7 @@ struct anon_vma *page_lock_anon_vma(struct page *page)
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
-	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
+	anon_mapping = (unsigned long) rcu_dereference(page->mapping);
 	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
 		goto out;
 	if (!page_mapped(page))




