Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab2I0QtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 12:49:09 -0400
Received: from mail.lang.hm ([64.81.33.126]:43472 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab2I0QtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 12:49:07 -0400
Date: Thu, 27 Sep 2012 09:48:19 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Mike Galbraith <efault@gmx.de>,
        Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
In-Reply-To: <1348734104.3292.5.camel@twins>
Message-ID: <alpine.DEB.2.02.1209270935080.5162@asgard.lang.hm>
References: <1348505683.11847.111.camel@twins>  <1348511193.6951.44.camel@marge.simpson.net>  <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>  <20120924192056.GB4082@liondog.tnic>  <1348538258.7100.23.camel@marge.simpson.net> 
 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>  <1348574286.3881.40.camel@twins> <20120925131736.GA30652@x1.osrc.amd.com>  <20120925170058.GC30158@x1.osrc.amd.com>  <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
  <20120926163233.GA5339@x1.osrc.amd.com>  <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com> <1348734104.3292.5.camel@twins>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012, Peter Zijlstra wrote:

> On Wed, 2012-09-26 at 11:19 -0700, Linus Torvalds wrote:
>>
>> For example, it starts with the maximum target scheduling domain, and
>> works its way in over the scheduling groups within that domain. What
>> the f*ck is the logic of that kind of crazy thing? It never makes
>> sense to look at a biggest domain first.
>
> That's about SMT, it was felt that you don't want SMT siblings first
> because typically SMT siblings are somewhat under-powered compared to
> actual cores.
>
> Also, the whole scheduler topology thing doesn't have L2/L3 domains, it
> only has the LLC domain, if you want more we'll need to fix that. For
> now its a fixed:
>
> SMT
> MC (llc)
> CPU (package/machine-for-!numa)
> NUMA
>
> So in your patch, your for_each_domain() loop will really only do the
> SMT/MC levels and prefer an SMT sibling over an idle core.

I think you are bing too smart for your own good. you don't know if it's 
best to move them further apart or not. I'm arguing that you can't know.

so I'm saying do the simple thing.

if a core is overloaded, move to an idle core that is as close as possible 
to the core you start from (as much shared as possible).

if this does not overload the shared resource, you did the right thing.

if this does overload the shared resource, it's still no worse than 
leaving it on the original core (which was shared everything, so you've 
reduced the sharing a little bit)

the next balancing cycle you then work to move something again, and since 
both the original and new core show as overloaded (due to the contention 
on the shared resources), you move something to another core that shares 
just a little less.

Yes, this means that it may take more balancing cycles to move things far 
enough apartto reduce the sharing enough to avoid overload of the shared 
resource, but I don't see any way that you can possibly guess if two 
processes are going to overload the shared resource ahead of time.

It may be that simply moving to a HT core (and no longer contending for 
registers) is enough to let both processes fly, or it may be that the 
overload is in a shared floating point unit or L1 cache and you need to 
move further away, or you may find the contention is in the L2 cache and 
move further away, or it could be in the L3 cache, or it could be in the 
memory interface (NUMA)

Without being able to predict the future, you don't know how far away you 
need to move the tasks to have them operate at th eoptimal level. All that 
you do know is that the shorter the move, the less expensive the move. So 
make each move be as short as possible, and measure again to see if that 
was enough.

For some workloads, it will be. For many workloads the least expensive 
move won't be.

The question is if doing multiple, cheap moves (requiring simple checking 
for each moves) ends up being a win compared to do better guessing over 
when the more expensive moves are worth it.

Give how chips change from year to year, I don't see how the 'better 
guessing' is going to survive more than a couple of chip releases in any 
case.

David Lang
