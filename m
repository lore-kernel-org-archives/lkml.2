Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab0DGJjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 05:39:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:44695 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab0DGJi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 05:38:58 -0400
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <20100407091611.GC5183@cmpxchg.org>
References: <4BBB475A.7070002@redhat.com>
	 <1270568096.1814.145.camel@barrios-desktop>
	 <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>
	 <1270571019.1814.163.camel@barrios-desktop>
	 <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org>
	 <1270572327.1711.3.camel@barrios-desktop>
	 <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
	 <4BBB69A9.5090906@redhat.com>
	 <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org>
	 <1270629403.5109.552.camel@twins>  <20100407091611.GC5183@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 07 Apr 2010 11:37:23 +0200
Message-ID: <1270633043.5109.575.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-07 at 11:16 +0200, Johannes Weiner wrote:
> On Wed, Apr 07, 2010 at 10:36:43AM +0200, Peter Zijlstra wrote:
> > On Tue, 2010-04-06 at 11:28 -0700, Linus Torvalds wrote:
> > > Just as an example of the kind of code that makes me worry:
> > > 
> > >         void unlink_anon_vmas(struct vm_area_struct *vma)
> > >         {
> > >                 struct anon_vma_chain *avc, *next;
> > >                         
> > >                 /* Unlink each anon_vma chained to the VMA. */
> > >                 list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
> > >                         anon_vma_unlink(avc);
> > >                         list_del(&avc->same_vma);
> > >                         anon_vma_chain_free(avc);
> > >                 }
> > >         }
> > > 
> > > Now, think about what happens for the *last* entry in that avc chain. It 
> > > will call that "anon_vma_unlink()" thing, which will delete perhaps the 
> > > last entry in the "same_anon_vma" one, and then it does
> > > 
> > >         if (empty)
> > >                 anon_vma_free(anon_vma);
> > > 
> > > *before* unlink_anon_vma's has actually does that
> > > 
> > >         list_del(&avc->same_vma);
> > > 
> > > and what we essentially have is a stale anon_vma_chain entry that still 
> > > exists on that same_vma list, and points to an anon_vma that already got 
> > > deleted.
> > > 
> > > Does it matter? I really can't see that it does. 
> > 
> > I think it does, the anon_vma thing has an RCU destroyed slab, but that
> > doesn't mean the anon_vma object itself is rcu delayed. The moment we
> > free it it can be re-used. So the above use after free is a bug.
> 
> It frees avc->anon_vma, not avc.

Sure, freeing avc does not involve RCU in any way.

>   So the sequence is
> 
> 	free(avc->anon_vma) in anon_vma_unlink()
> 	list_del(&avc->same_vma) in unlink_anon_vmas()
> 
> It's not a use-after free.  A problem would be if somebody should find the
> avc through this list (it is the vma->anon_vma_chain list) when its anon_vma
> pointer is invalid.
> 
> I don't think this can happen, however.  Both the unlinking and the looking
> at the list happen under vma->vm_mm's mmap_sem held for writing.

What I was worried about was it freeing anon_vma and then still having
the avc on list. But I guess that cannot happen because it only frees if
its actually empty.


