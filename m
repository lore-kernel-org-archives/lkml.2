Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab0DFSdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 14:33:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755649Ab0DFSdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 14:33:38 -0400
Date: Tue, 6 Apr 2010 11:28:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
In-Reply-To: <4BBB69A9.5090906@redhat.com>
Message-ID: <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org>
References: <20100402175937.GA19690@liondog.tnic>  <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>  <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <4BBB475A.7070002@redhat.com>   <1270568096.1814.145.camel@barrios-desktop> 
 <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>  <1270571019.1814.163.camel@barrios-desktop>  <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org> <1270572327.1711.3.camel@barrios-desktop> <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
 <4BBB69A9.5090906@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Apr 2010, Rik van Riel wrote:
> 
> Which other cases? When do we ever walk the "same_vma" list
> not from the context of the process owning the vma?

That's the point. What does 'owning the vma' mean? That's exactly what I'm 
asking to be documented.

Quite frankly, the thing is a mess. There is _no_ comment on why it's ok 
to modify the list or walk the list, except for the one totally misleading 
one, since the page_table_lock has at most a _secondary_ meaning in the 
whole ownership (ie it is used only when we do _not_ own the vma chain 
exclusively).

So your very comment shows the whole confusion. No, we do not "own the 
vma" in all cases. Sometimes we just have a read-lock on it.

> This bug in page_referenced is walking the "same_anon_vma" list,
> which is locked with the anon_vma->lock.

Umm. Wake the hell up, Rik!

It's walking a _corrupt_ same_anon_vma list.  In other words, we _know_ 
that the 'anon_vma_chain' entry is crap. We know that exactly because it 
contains "impossible" values with regard to the list.

And what's the easiest way to get such a corrupt list, considering that 
the locking looks correct for that particular list?

That's right: by having something like anon_vma_clone() do something bad 
when it walks the same avc entries using the 'same_vma' list and creates 
copies of it.

You can't just say "but but but same_anon_vma list is always locked 
properly". Because it doesn't matter if that list is locked properly if 
walking _another_ list doesn't work right.

I really don't understand why you keep on harping on thatr same_anon_vma 
list. The fact that that was the corrupt list IN ABSOLUTELY NO WAY implies 
that that is the list that caused the corruption.

For example, let's say that the 'anon_vma_chain' list is corrupted. Never 
mind how. So what could happen is that you'd have vma->anon_vma pointing 
to one thing, and one or more entries on the 'vma->anon_vma_chain' list 
pointing to _another_ anon_vma.

What happens then? I have no idea. Maybe nothing bad. But the point is, if 
one avc list is corrupted and you may end up referencing those avc's in 
unexpected cases, how can you trust the other list that is in the same 
data structure?

For example, maybe some list corruption causes us to do that 
"anon_vma_chain_link()" _twice_ on the same avc entry. So we do that 
"list_add_tail(&avc->same_anon_vma, &anon_vma->head);" on an entry that 
already had "same_anon_vma" on one list.

No, I really don't see how that could happen, but my argument is that a 
corrupt list can do odd things. The same entry might end up pointing to 
itself, so that you end up freeing it twice or something.

Just as an example of the kind of code that makes me worry:

	void unlink_anon_vmas(struct vm_area_struct *vma)
	{
	        struct anon_vma_chain *avc, *next;
	                
	        /* Unlink each anon_vma chained to the VMA. */
	        list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
	                anon_vma_unlink(avc);
	                list_del(&avc->same_vma);
	                anon_vma_chain_free(avc);
	        }
	}

Now, think about what happens for the *last* entry in that avc chain. It 
will call that "anon_vma_unlink()" thing, which will delete perhaps the 
last entry in the "same_anon_vma" one, and then it does

	if (empty)
		anon_vma_free(anon_vma);

*before* unlink_anon_vma's has actually does that

	list_del(&avc->same_vma);

and what we essentially have is a stale anon_vma_chain entry that still 
exists on that same_vma list, and points to an anon_vma that already got 
deleted.

Does it matter? I really can't see that it does. But that's the kind of 
thing that makes me nervous. It makes me _especially_ nervous when the 
whole locking for that anon_vma_chain thing isn't entirely obvious.

		Linus
