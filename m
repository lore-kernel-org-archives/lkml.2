Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396Ab0GOOq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 10:46:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63230 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933300Ab0GOOq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 10:46:28 -0400
X-Authority-Analysis: v=1.1 cv=kjawQlkT3vujM0lFy4b69hWxQTW3SR1XdVtFii1ut0g= c=1 sm=0 a=ZI5MULQygNwA:10 a=ood2b7iyd8MA:10 a=IkcTkHD0fZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=jYIOoZeK8QlzqPWDRXMA:9 a=qXj2JIwm7jtW7AS_HngA:7 a=1O09rVNqkn0AgtXVm2vV65bJs_0A:4 a=QEXdDO2ut3YA:10 a=20IoW0z8CdRksmjC:21 a=w03dbDNknYe0WTzl:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
In-Reply-To: <20100715141118.GA6417@nowhere>
References: <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
	 <20100714170617.GB4955@Krystal>
	 <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	 <20100714184642.GA9728@elte.hu>
	 <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
	 <AANLkTinfmoKvi1SauDA5_RiTmu6bztTDk8b_ycS-lr8S@mail.gmail.com>
	 <20100714195617.GC22373@basil.fritz.box> <20100714200552.GA22096@Krystal>
	 <20100714223116.GB14533@nowhere>
	 <AANLkTik-sJL_pAJg38Hzpl_jpn2v90t7tppYqOGmu6p-@mail.gmail.com>
	 <20100715141118.GA6417@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Jul 2010 10:46:13 -0400
Message-ID: <1279205173.4190.53.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-15 at 16:11 +0200, Frederic Weisbecker wrote:

> >  - make sure that you only ever use _one_ single top-level entry for
> > all vmalloc issues, and can make sure that all processes are created
> > with that static entry filled in. This is optimal, but it just doesn't
> > work on all architectures (eg on 32-bit x86, it would limit the
> > vmalloc space to 4MB in non-PAE, whatever)
> 
> 
> But then, even if you ensure that, don't we need to also fill lower level
> entries for the new mapping.

If I understand your question, you do not need to worry about the lower
level entries because all the processes will share the same top level.

process 1's GPD ------,
                      |
                      +------> PMD --> ...
                      |
process 2' GPD -------'

Thus we have one page entry shared by all processes. The issue happens
when the vm space crosses the PMD boundary and we need to update all the
GPD's of all processes to point to the new PMD we need to add to handle
the spread of the vm space.

> 
> Also, why is this a worry for vmalloc but not for kmalloc? Don't we also
> risk to add a new memory mapping for new memory allocated with kmalloc?

Because all of memory (well 800 some megs on 32 bit) is mapped into
memory for all processes. That is, kmalloc only uses this memory (as
does get_free_page()). All processes have a PMD (or PUD, whatever) that
maps this memory. The issues only arises when we use new virtual memory,
which vmalloc does. Vmalloc may map to physical memory that is already
mapped to all processes but the address that the vmalloc uses to access
that memory is not yet mapped.

The usual reason the kernel uses vmalloc is to get a contiguous range of
memory. The vmalloc can map several pages as one contiguous piece of
memory that in reality is several different pages scattered around
physical memory. kmalloc can only map pages that are contiguous in
physical memory. That is, if kmalloc gets 8192 bytes on an arch with
4096 byte pages, it will allocate two consecutive pages in physical
memory. If two contiguous pages are not available even if thousand of
single pages are, the kmalloc will fail, where as the vmalloc will not.

An allocation of vmalloc can use two different pages and just map the
page table to make them contiguous in view of the kernel. Note, this
comes at a cost. One is when we do this, we suffer the case where we
need to update a bunch of page tables. The other is that we must waste
TLB entries to point to these separate pages. Kmalloc and
get_free_page() uses the big memory mappings. That is, if the TLB allows
us to map large pages, we can do that for kernel memory since we just
want the contiguous memory as it is in physical memory.

Thus the kernel maps the physical memory with the fewest TLB entries as
needed (large pages and large TLB entries). If we can map 64K pages, we
do that. Then kmalloc just allocates within this range, it does not need
to map any pages. They are already mapped.

Does this make a bit more sense?

> 
> 
> 
> >  - at vmalloc time, when adding a new page directory entry, walk all
> > the tens of thousands of existing page tables under a lock that
> > guarantees that we don't add any new ones (ie it will lock out fork())
> > and add the required pgd entry to them.
> > 
> >  - or just take the fault and do the "fill the page tables" on demand.
> > 
> > Quite frankly, most of the time it's probably better to make that last
> > choice (unless your hardware makes it easy to make the first choice,
> > which is obviously simplest for everybody). It makes it _much_ cheaper
> > to do vmalloc. It also avoids that nasty latency issue. And it's just
> > simpler too, and has no interesting locking issues with how/when you
> > expose the page tables in fork() etc.
> > 
> > So the only downside is that you do end up taking a fault in the
> > (rare) case where you have a newly created task that didn't get an
> > even newer vmalloc entry.
> 
> 
> But then how did the previous tasks get this new mapping? You said
> we don't walk through every process page tables for vmalloc.

Actually we don't even need to walk the page tables in the first task
(although we might do that). When the kernel accesses that memory we
take the page fault, the page fault will see that this memory is vmalloc
data and fill in the page tables for the task at that time.

> 
> I would understand this race if we were to walk on every processes page
> tables and add the new mapping on them, but we missed one new task that
> forked or so, because we didn't lock (or just rcu).
> 
> 
> 
> > And that fault can sometimes be in an
> > interrupt or an NMI. Normally it's trivial to handle that fairly
> > simple nested fault. But NMI has that inconvenient "iret unblocks
> > NMI's, because there is no dedicated 'nmiret' instruction" problem on
> > x86.
> 
> 
> Yeah.
> 
> 
> So the parts of the problem I don't understand are:
> 
> - why don't we have this problem with kmalloc() ?

I hope I explained that above.

> - did I understand well the race that makes the fault necessary,
>   ie: we walk the tasklist lockless, add the new mapping if
>   not present, but we might miss a task lately forked, but
>   the fault will fix that.

I'm lost on this race. If we do a lock and walk all page tables I think
the race goes away. So I don't understand this either?

-- Steve


