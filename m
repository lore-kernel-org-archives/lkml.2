Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965103Ab0GPKrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 06:47:32 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41455 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965078Ab0GPKr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 06:47:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=at+voJh6SkWZRHXfMV5yzmB1h9+JrvPew10QfRKDI30j9qUmNe9k1n0e47luDNy8yu
         ch9ltN4P4V6wGM0Sc+T+pkMf1CE6dS3jTB9Ku12ynFlJ6S8xjWABmDrQfXsJl2wOxklb
         bODIYCWF1Keu2MSmxGlTxNDIuYzPBVZOJ0ftg=
Date: Fri, 16 Jul 2010 12:47:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100716104716.GA5377@nowhere>
References: <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com> <20100714184642.GA9728@elte.hu> <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com> <AANLkTinfmoKvi1SauDA5_RiTmu6bztTDk8b_ycS-lr8S@mail.gmail.com> <20100714195617.GC22373@basil.fritz.box> <20100714200552.GA22096@Krystal> <20100714223116.GB14533@nowhere> <AANLkTik-sJL_pAJg38Hzpl_jpn2v90t7tppYqOGmu6p-@mail.gmail.com> <20100715141118.GA6417@nowhere> <1279205173.4190.53.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279205173.4190.53.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 10:46:13AM -0400, Steven Rostedt wrote:
> On Thu, 2010-07-15 at 16:11 +0200, Frederic Weisbecker wrote:
> 
> > >  - make sure that you only ever use _one_ single top-level entry for
> > > all vmalloc issues, and can make sure that all processes are created
> > > with that static entry filled in. This is optimal, but it just doesn't
> > > work on all architectures (eg on 32-bit x86, it would limit the
> > > vmalloc space to 4MB in non-PAE, whatever)
> > 
> > 
> > But then, even if you ensure that, don't we need to also fill lower level
> > entries for the new mapping.
> 
> If I understand your question, you do not need to worry about the lower
> level entries because all the processes will share the same top level.
> 
> process 1's GPD ------,
>                       |
>                       +------> PMD --> ...
>                       |
> process 2' GPD -------'
> 
> Thus we have one page entry shared by all processes. The issue happens
> when the vm space crosses the PMD boundary and we need to update all the
> GPD's of all processes to point to the new PMD we need to add to handle
> the spread of the vm space.




Oh right. We point to that PMD, and the update has been made itself inside
the lower level entries pointed by the PMD. Indeed.



> 
> > 
> > Also, why is this a worry for vmalloc but not for kmalloc? Don't we also
> > risk to add a new memory mapping for new memory allocated with kmalloc?
> 
> Because all of memory (well 800 some megs on 32 bit) is mapped into
> memory for all processes. That is, kmalloc only uses this memory (as
> does get_free_page()). All processes have a PMD (or PUD, whatever) that
> maps this memory. The issues only arises when we use new virtual memory,
> which vmalloc does. Vmalloc may map to physical memory that is already
> mapped to all processes but the address that the vmalloc uses to access
> that memory is not yet mapped.



Ok I see.




> 
> The usual reason the kernel uses vmalloc is to get a contiguous range of
> memory. The vmalloc can map several pages as one contiguous piece of
> memory that in reality is several different pages scattered around
> physical memory. kmalloc can only map pages that are contiguous in
> physical memory. That is, if kmalloc gets 8192 bytes on an arch with
> 4096 byte pages, it will allocate two consecutive pages in physical
> memory. If two contiguous pages are not available even if thousand of
> single pages are, the kmalloc will fail, where as the vmalloc will not.
> 
> An allocation of vmalloc can use two different pages and just map the
> page table to make them contiguous in view of the kernel. Note, this
> comes at a cost. One is when we do this, we suffer the case where we
> need to update a bunch of page tables. The other is that we must waste
> TLB entries to point to these separate pages. Kmalloc and
> get_free_page() uses the big memory mappings. That is, if the TLB allows
> us to map large pages, we can do that for kernel memory since we just
> want the contiguous memory as it is in physical memory.
> 
> Thus the kernel maps the physical memory with the fewest TLB entries as
> needed (large pages and large TLB entries). If we can map 64K pages, we
> do that. Then kmalloc just allocates within this range, it does not need
> to map any pages. They are already mapped.
> 
> Does this make a bit more sense?



Totally! You've made it very clear to me.
Moreover I did not know we can have such variable page size. I mean I thought
we can have variable page size but that would apply to every pages.





> 
> > 
> > 
> > 
> > >  - at vmalloc time, when adding a new page directory entry, walk all
> > > the tens of thousands of existing page tables under a lock that
> > > guarantees that we don't add any new ones (ie it will lock out fork())
> > > and add the required pgd entry to them.
> > > 
> > >  - or just take the fault and do the "fill the page tables" on demand.
> > > 
> > > Quite frankly, most of the time it's probably better to make that last
> > > choice (unless your hardware makes it easy to make the first choice,
> > > which is obviously simplest for everybody). It makes it _much_ cheaper
> > > to do vmalloc. It also avoids that nasty latency issue. And it's just
> > > simpler too, and has no interesting locking issues with how/when you
> > > expose the page tables in fork() etc.
> > > 
> > > So the only downside is that you do end up taking a fault in the
> > > (rare) case where you have a newly created task that didn't get an
> > > even newer vmalloc entry.
> > 
> > 
> > But then how did the previous tasks get this new mapping? You said
> > we don't walk through every process page tables for vmalloc.
> 
> Actually we don't even need to walk the page tables in the first task
> (although we might do that). When the kernel accesses that memory we
> take the page fault, the page fault will see that this memory is vmalloc
> data and fill in the page tables for the task at that time.



Right.




> > 
> > I would understand this race if we were to walk on every processes page
> > tables and add the new mapping on them, but we missed one new task that
> > forked or so, because we didn't lock (or just rcu).
> > 
> > 
> > 
> > > And that fault can sometimes be in an
> > > interrupt or an NMI. Normally it's trivial to handle that fairly
> > > simple nested fault. But NMI has that inconvenient "iret unblocks
> > > NMI's, because there is no dedicated 'nmiret' instruction" problem on
> > > x86.
> > 
> > 
> > Yeah.
> > 
> > 
> > So the parts of the problem I don't understand are:
> > 
> > - why don't we have this problem with kmalloc() ?
> 
> I hope I explained that above.



Yeah :)

Thanks a lot for your explanations!

