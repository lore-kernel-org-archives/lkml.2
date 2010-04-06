Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab0DFVcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:32:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932080Ab0DFVc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:32:26 -0400
Date: Tue, 6 Apr 2010 14:27:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
In-Reply-To: <20100406205123.GC20357@a1.tnic>
Message-ID: <alpine.LFD.2.00.1004061403170.3487@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org> <1270571019.1814.163.camel@barrios-desktop> <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org> <1270572327.1711.3.camel@barrios-desktop> <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
 <4BBB69A9.5090906@redhat.com> <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org> <20100406120315.53ad7390.akpm@linux-foundation.org> <20100406194238.GB20357@a1.tnic> <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org>
 <20100406205123.GC20357@a1.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Apr 2010, Borislav Petkov wrote:
> > So again, it's actually anon_vma.head.next that is NULL, not any of the 
> > entries on the list itself.
> > 
> > Now, I can see several cases for this:
> > 
> >  - the obvious one: anon_vma just wasn't correctly initialized, and is 
> >    missing a INIT_LIST_HEAD(&anon_vma->head). That's either a slab bug (we 
> >    don't have a whole lot of coverage of constructors), or somebody 
> >    allocated an anon_vma without using the anon_vma_cachep.
> 
> I've added code to verify this and am suspend/resuming now... Wait a
> minute, Linus, you're good! :) :
> 
> [  873.083074] PM: Preallocating image memory... 
> [  873.254359] NULL anon_vma->head.next, page 2182681

Yeah, I was pretty sure of that thing.

I still don't see _how_ it happens, though. That 'struct anon_vma' is very 
simple, and contains literally just the lock and that list_head.

Now, 'head.next' is kind of magical, because it contains that magic 
low-bit "have I been locked" thing (see "vm_lock_anon_vma()" in 
mm/mmap.c). But I'm not seeing anything else touching it.

And if you allocate a anon_vma the proper way, the SLUB constructor should 
have made sure that the head is initialized. And no normal list operation 
ever sets any list pointer to zero, although a "list_del()" on the first 
list entry could do it if that first list entry had a NULL next pointer. 

> Now, how do we track back to the place which is missing anon_vma->head
> init? Can we use the struct page *page arg to page_referenced_anon()
> somehow?

You might enable SLUB debugging (both SLUB_DEBUG _and_ SLUB_DEBUG_ON), and 
then make the "object_err()" function in mm/slub.c be non-static. You 
could call it when you see the problem, perhaps.

Or you could just add tests to both alloc_anon_vma() and free_anon_vma() 
to check that 'list_empty(&anon_vma->head)' is true. I dunno.

> >    I haven't looked at the kernel config files: do they perhaps share the 
> >    same (odd?) SLUB/SLAB/SLOB config?
> 
> what is an odd SL[AOU]B config?

Probably anything but the default SLUB these days.  But Steinar already 
said he had SLUB, so it's unlikely to be something odd.

> >  - anon_vma isn't actually an anonvma at all. 'page->mapping' was crud 
> >    with the low bit set. That sounds unlikely, but who knows. The ksm code 
> >    sets mapping to "stable_node + PAGE_MAPPING_ANON | PAGE_MAPPING_KSM"
> > 
> >    Did people have KSM enabled?
> 
> Nope, KSM is off here.

Yeah, wasn't for Steinar either. So it doesn't look like it's any odd 
corner case that depends on some odd configuration.

		Linus
