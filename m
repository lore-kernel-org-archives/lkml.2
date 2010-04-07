Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab0DGPup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:50:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932649Ab0DGPuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:50:44 -0400
Date: Wed, 7 Apr 2010 08:46:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
In-Reply-To: <1270629403.5109.552.camel@twins>
Message-ID: <alpine.LFD.2.00.1004070843060.3487@i5.linux-foundation.org>
References: <20100402175937.GA19690@liondog.tnic>  <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>  <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <4BBB475A.7070002@redhat.com>    <1270568096.1814.145.camel@barrios-desktop> 
 <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>  <1270571019.1814.163.camel@barrios-desktop>  <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org>  <1270572327.1711.3.camel@barrios-desktop>  <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
  <4BBB69A9.5090906@redhat.com>  <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org> <1270629403.5109.552.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Apr 2010, Peter Zijlstra wrote:

> On Tue, 2010-04-06 at 11:28 -0700, Linus Torvalds wrote:
> > Just as an example of the kind of code that makes me worry:
> > 
> >         void unlink_anon_vmas(struct vm_area_struct *vma)
> >         {
> >                 struct anon_vma_chain *avc, *next;
> >                         
> >                 /* Unlink each anon_vma chained to the VMA. */
> >                 list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
> >                         anon_vma_unlink(avc);
> >                         list_del(&avc->same_vma);
> >                         anon_vma_chain_free(avc);
> >                 }
> >         }
> > 
> > Now, think about what happens for the *last* entry in that avc chain. It 
> > will call that "anon_vma_unlink()" thing, which will delete perhaps the 
> > last entry in the "same_anon_vma" one, and then it does
> > 
> >         if (empty)
> >                 anon_vma_free(anon_vma);
> > 
> > *before* unlink_anon_vma's has actually does that
> > 
> >         list_del(&avc->same_vma);
> > 
> > and what we essentially have is a stale anon_vma_chain entry that still 
> > exists on that same_vma list, and points to an anon_vma that already got 
> > deleted.
> > 
> > Does it matter? I really can't see that it does. 
> 
> I think it does, the anon_vma thing has an RCU destroyed slab, but that
> doesn't mean the anon_vma object itself is rcu delayed. The moment we
> free it it can be re-used. So the above use after free is a bug.

Well, it's not really a "use after free" - it's just that a stale pointer 
still exists in a live data structure that is linked into the list. I 
don't think there is a real bug there, simply because I don't think 
anybody will be accessing that list (we should hopefully have all the 
sufficient mutual exclusion in place).

So I just think it is bad form to potentially free something before we get 
rid of all pointers to it. So to me it's a cleanliness issue: good code 
shouldn't do things like that, and it would be much cleaner to remove the 
AVC entry that has a pointer to the anon_vma _before_ we might be freeing 
the anon_vma.

Maybe I'm just anal.

		Linus
