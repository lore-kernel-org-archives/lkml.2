Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab0DFQAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:00:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682Ab0DFP7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:59:55 -0400
Date: Tue, 6 Apr 2010 08:55:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
cc: Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
In-Reply-To: <1270568096.1814.145.camel@barrios-desktop>
Message-ID: <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>
References: <20100402175937.GA19690@liondog.tnic>  <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>  <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <4BBB475A.7070002@redhat.com> <1270568096.1814.145.camel@barrios-desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Apr 2010, Minchan Kim wrote:
> 
> Let's see the unlink_anon_vmas. 
> 
> 1. list_for_each_entry_safe(avc,next, vma->anon_vma_chain, same_vma)
> 2. 	anon_vma_unlink
> 3. 		spin_lock(anon_vma->lock) <-- HERE LOCK.
> 4.		list_del(anon_vma_chain->same_anon_vma);
> 
> What if anon_vma is destroyed and reuse by SLAB_XXX_RCU for another
> anon_vma object between 2 and 3?
> I mean how to make sure 3) does lock valid anon_vma? 
> 
> I hope it is culprit.

I don't think so. That isn't the racy case. We're working with a 
anon_vma_chain, so the anonvma is all there.

The racy case is when we look up an anonvma by the page, and the page gets 
unmapped at the same time because somebody else is travelling over the LRU 
list of the page itself, isn't it?

I do wonder if "page_lock_anon_vma()" should check the whole 
"page_mapped()" case _after_ taking the anon_vma lock. Because if the race 
happens, we're following a anon_vma list that has nothing to do with that 
page (it's stilla _valid_ list, since we locked the anon_vma, but will it 
be ok?)

IOW, what is it that really keeps the anon_vma list reliable _and_ 
relevant wrt the page? We know we may get a stale anon_vma, are we ok if 
that anon_vma list doesn't actually have anything to do with the page any 
more?

I think the first check in "page_address_in_vma()" protects us, but 
whatever.

However, that made me look at the PAGE_MIGRATION case. That seems to be 
just broken. It's doing that page_anon_vma() + spin_lock without holding 
any RCU locks, so there is no guarantee that anon_vma there is at all 
valid.

Is that function always called with rcu_read_lock()? 

			Linus
