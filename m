Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab0DII2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 04:28:33 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46685 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab0DII22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 04:28:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Apr 2010 17:24:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 02/13] mm: Revalidate anon_vma in page_lock_anon_vma()
Message-Id: <20100409172432.84a74cc3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100409170349.3b09bd2a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100409150335.80E3.A69D9226@jp.fujitsu.com>
	<20100409154730.e9945cbc.kamezawa.hiroyu@jp.fujitsu.com>
	<20100409160252.80E6.A69D9226@jp.fujitsu.com>
	<20100409165703.8d65ae92.kamezawa.hiroyu@jp.fujitsu.com>
	<20100409170349.3b09bd2a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Apr 2010 17:03:49 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Fri, 9 Apr 2010 16:57:03 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Fri,  9 Apr 2010 16:29:59 +0900 (JST)
> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > > Hmm, I think following.
> > > > 
> > > > Assume a page is ANON and SwapCache, and it has only one reference.
> > > > Consider it's read-only mapped and cause do_wp_page().
> > > > page_mapcount(page) == 1 here.
> > > > 
> > > >     CPU0                          CPU1
> > > > 
> > > > 1. do_wp_page()
> > > > 2. .....
> > > > 3. replace anon_vma.     anon_vma = lock_page_anon_vma()
> > > > 
> > > > So, lock_page_anon_vma() may have lock on wrong anon_vma, here.(mapcount=1)
> > > > 
> > > > 4. modify pte to writable.        do something...
> > > > 
> > > > After lock, in CPU1, a pte of estimated address by vma_address(vma, page)
> > > > containes pfn of the page and page_check_address() will success.
> > > > 
> > > > I'm not sure how this is dangerouns.
> > > > But it's possible that CPU1 cannot notice there was anon_vma replacement.
> > > > And modifies pte withoug holding anon vma's lock which the code believes
> > > > it's holded.
> > > 
> > > 
> > > Hehe, page_referenced() already can take unstable VM_LOCKED value. So,
> > > In worst case we make false positive pageout, but it's not disaster.
> > > I think. Anyway "use after free" don't happen by this blutal code.
> > > 
> > > However, I think you pointed one good thing. before Rik patch, we don't have
> > > page->mapping reassignment. then, we didn't need rcu_dereference().
> > > but now it can happen. so, I think rcu_dereference() is better.
> > > 
> > > Perhaps, I'm missing something.
> > > 
> > 
> > Hmm. I wonder we can check "whether we lock valid anon_vma or not" only under
> > pte_lock or lock_page().
> > ==
> > 	anon_vma = page_anon_vma();
> > 	lock(anon_vma->lock);
> > 	....
> > 	page_check_address(page)
> > 		....
> > 		pte_lock();
> > 		if (page_anon_vma(page) == anon_vma)
> > 			# anon_vma replacement happens!
> > 	unlock(anon_vma->lock);
> > ==
> > So, rather than page_lock_anon_vma(),  page_check_address() may have to check anon_vma
> > replacement....But I cannot think of dangerous case which can cause panic for now.
> > I may miss something...
> > 
> Ah...anon_vma replacemet occurs under lock_page() and pte_lock.
> Almost all callers of page_lock_anon_vma() holds lock_page(). So, I think
> this anon_vma replacement is not very serious.
Sorry for short mails ;(


Note:vmscan.c::shrink_active_list()
	-> page_referenced()
doesn't take lock_page() and may see wrong anon_vma by replacement.

Don't we need lock_page() around ?

Thanks,
-Kame

