Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab0DABin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:38:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758553Ab0DABil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:38:41 -0400
Date: Wed, 31 Mar 2010 18:33:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
cc: San Mehat <san@google.com>, linux-kernel@vger.kernel.org,
       Brian Swetland <swetland@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] proc: pagemap: Hold mmap_sem during page walk
In-Reply-To: <1270071636.3552.978.camel@calx>
Message-ID: <alpine.LFD.2.00.1003311754110.3707@i5.linux-foundation.org>
References: <1270056227-5442-1-git-send-email-san@google.com>  <alpine.LFD.2.00.1003311036200.3707@i5.linux-foundation.org> <1270071636.3552.978.camel@calx>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Mar 2010, Matt Mackall wrote:
>
> Linus, I must say your charm has really worn thin. I've just stuck a
> post-it on my monitor saying "don't be Linus" to remind me not to be
> rude to my contributors. 

You didn't actually answer the problem, though.

I'm rude, because I think the code is buggy. I pointed out how, and why I 
think it's pretty fundamental. You quoted it, but you didn't answer it.

> If I recall correctly, the get_user_pages is there to force all the
> output pages to be guaranteed present before we later fill them so that
> the output needn't be double-buffered and the locking and recursion on
> the page tables is significantly simpler and faster. put_user is then
> actually easier than "writing to the physical pages through the array".

Umm. Why would get_user_pages() guarantee that the pages don't get swapped 
out in the meantime, and you end up with a page fault _anyway_?

Yes, it makes those page faults much rarer, but that just makes things 
much worse. Now you have a nasty subtle fundamental bug that is hard to 
trigger too.

NOTE! The fact that we mark the page dirty (and increment the page count) 
in get_user_pages() (not in the later loop, which does indeed look 
pointless) should mean that the page doesn't go away physically, and if it 
gets mapped out the same page will be mapped back in on access. That's how 
things like direct-IO work (modulo a concurrent fork(), when they don't 
work, but that's a separate issue).

But the problem with the deadlock is not that "same physical page" issue, 
it's simply the problem of the page fault code itself wanting to do a 
down_read() on the mmap_sem. So the fact that the physical page is 
reliable in the array doesn't actually solve the bug I was pointing out.

See? 

So the

	nr = get_user_pages(.. 1, 0, ..)

	...

	for_each_page()
		mark_it_dirty();

pattern is a valid pattern, but it is _only_ valid if you then do the 
write to the physical page you looked up. If you do the accesses through 
the virtual addresses, it makes zero sense.

> You're right that the SetPageDirty() at cleanup is redundant (but
> harmless), and I probably copied that pattern from another user of
> get_user_pages.

Fine. So then you'd do get_user_pages() and do _nothing_ with the array? 
Please explain what the point of that is, again?

See above: there are valid reasons for things like direct-IO to do that 
exact "get_user_pages()" pattern - they mark the pages dirty both early 
_and_ late, and both page dirtying is required:

 - the first one (done by get_user_pages() itself) is to make sure that an
   anonymous page doesn't get switched around to another anonymous page 
   that just happens to have the same contents (ie if the page gets 
   swapped out, the swapout code will turn it into a swap-cache page).

   Once it's a swap-out page, the page refcount will then guarantee that 
   it doesn't get replaced with anything else, so now you can trust the 
   physical page.

 - the second "mark it dirty afterwards" is required in case swapout did 
   happen, and the page got marked clean before the direct-IO actually 
   wrote to it. So you mark it dirty again - this time not to force any 
   swap cache things, but simply because there might have been a race 
   between cleaning the page and the thing that wrote to it through the 
   physical address.

So there is a very real reason for that pattern existing. It's just that 
that reason has nothing to do with locking the thing into the page tables. 
That is absolutely NOT guaranteed by the get_user_pages() physical page 
pinning (munmap() is an extreme example of this, but I think swapout will 
clear it too in try_to_unmap_one().

In fact, even without swapping the page out, the accessed and dirty bit 
stuff may end up being done by software and have that page fault happen.

What I'm trying to explain is simply that all these VM rules mean that you 
must never do a virtual user space access while holding mmap_sem. And 
doing get_user_pages() in no way changes that fundamental rule.

Now, I will _happily_ admit that the above is all very complicated, and 
very easy to get wrong. There is a real reason why I hate direct-IO. It's 
a total nightmare from a VM standpoint. We've had bugs here. So I can well 
see that people don't always understand all the rules.

Quite frankly, the only reason that /proc/self/pagemap code got merged is 
because it came through Andrew. Andrew knows the VM layer. Probably way 
better than I do by now. So when I get patches that touch things like this 
through the -mm tree, I tend to apply them.

And looking now at the code again, I really think it was a mistake.

> Earlier versions of the pagewalk code studiously avoided calling
> find_vma and only looked at the page tables (with either caller doing
> locking or accepting the non-atomicity) to avoid the sort of issue that
> San has run into, but it looks like I forgot about that and let it sneak
> back in when other folks added more hugepage support.

Ok, that would fix the problem. The page tables can be accessed even 
without holding mmap_sem. And once you don't need mmap_sem, all the 
deadlocks go away. The get_user_pages() pattern still doesn't make sense, 
but at that point it's a _harmless_ problem, and doesn't really hurt.

See what I'm saying?

> The deeper problem is that hugepages have various nasty layering
> violations associated with them like being tied to vmas so until some
> hugepage genius shows up and tells us how to do this cleanly, we'll
> probably have to deal with the associated mmap_sem.
>
> San, your patch is touching the wrong mm_sem, I think. The interesting
> races are going to happen on the target mm, not current's (generally not
> the same).

The thing is, you need to hold the mmap_sem over the whole loop in 
pagemap_pte_range (since you're using the vma inside the loop). And that 
means that you'd hold mmap sem over the add_to_pagemap(), and the 
put_user() reference. Which has deadlock bug I pointed out, and that you 
totally ignored.

The fact that it's a separate mm doesn't change the deadlock in _any_ 
shape or form. It _could_ be the same mm, but even if it was another VM 
entirely, it would just make the deadlock possible as an ABBA thing across 
two different VM's instead of through a single VM.

> Holding the mm_sem across the entire walk is also prohibitive, it 
> probably needs to be localized to individual find_vma calls.

You'd need to do it for each individual page, as far as I can tell, and 
move the find_vma() inside the loop itself in order to avoid the whole 
"hold mmap-sem while potentially doing a page fault" case.

At that point, it looks like it wouldn't be buggy any more, it would just 
suck horribly from a performance standpoint.

So Matt, please actually address the _bug_ I pointed out rather than talk 
about other things. And yes, getting rid of the vma accesses sounds like 
it would fix it best. If that means that it doesn't work for hugepages, so 
be it.

			Linus
