Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2EUTPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:15:54 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57858 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab2EUTPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:15:52 -0400
Date: Mon, 21 May 2012 21:15:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
Message-ID: <20120521191546.GA28819@gmail.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
 <20120521082240.GA31407@gmail.com>
 <20120521093648.GC28930@dhcp-26-207.brq.redhat.com>
 <20120521124025.GC17065@gmail.com>
 <20120521144812.GD28930@dhcp-26-207.brq.redhat.com>
 <20120521145904.GA7068@gmail.com>
 <CA+55aFxJxfx+OfDiATCCPojVAPew_Hy+2=jx9g4=2_WRvixBFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxJxfx+OfDiATCCPojVAPew_Hy+2=jx9g4=2_WRvixBFw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, May 21, 2012 at 7:59 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > For example we don't execute tasks for 100 usecs on one CPU, 
> > then jump to another CPU and execute 100 usecs there, then 
> > to yet another CPU to create an 'absolutely balanced use of 
> > CPU resources'. Why? Because the cache-misses would be 
> > killing us.
> 
> That is likely generally not true within a single socket, 
> though.
> 
> Interrupt handlers will basically never hit in the L1 anyway 
> (*maybe* it happens if the CPU is totally idle, but quite 
> frankly, I doubt it). Even the L2 is likely not large enough 
> to have much cache across irqs, unless it's one of the big 
> Core 2 L2's that are largely shared per socket anyway.

Indeed, you are right as far as the L1 cache is concerned:

For networking we have about 180 L1 misses per IRQ handler 
invocation, if the L1 cache is cold - so most IRQ handlers 
easily fit int the L1 cache. I have measured this using a 
constant rate of networking IRQs and doing:

   perf stat -a -C 0 --repeat 10 -e L1-dcache-load-misses:k sleep 1

It only takes another 180 cache misses for these lines to get 
evicted, and this happens very easily:

On the same testsystem a parallel kernel build will evict about 
25 million L1 cachelines/sec/CPU. That means that an IRQ 
handler's working set in the L1 cache is indeed gone in less 
than 8 microseconds.

When the workload is RAM-bound then the L1 working set of an IRQ 
handler is gone in about 80 usecs. That corresponds to an IRQ 
rate of about 12,500/sec/CPU: if IRQs are coming in faster than 
this then they can still see some of the previous execution's 
footprint in the cache.

Wrt. the L2 cache the numbers come in much more in favor of not 
moving IRQ handlers across L2 cache domains - this means that 
allowing the hardware to distribute them per socket is a pretty 
sensible default.

> So it may well make perfect sense to allow a mask of CPU's for 
> interrupt delivery, but just make sure that the mask all 
> points to CPU's on the same socket. That would give the 
> hardware some leeway in choosing the actual core - it's very 
> possible that hardware could avoid cores that are running with 
> irq's disabled (possibly improving latecy) or even more likely 
> - avoid cores that are in deeper powersaving modes.

Indeed, and that's an important argument.

The one negative effect I mentioned, affine wakeups done by the 
scheduler, could still bite us - this has to be measured and 
affine wakeups have to be made less prominent if IRQ handlers 
start jumping around. We definitely don't want tasks to follow 
round-robin IRQs around.

> Avoiding waking up CPU's that are in C6 would not only help 
> latency, it would help power use. I don't know how well the 
> irq handling actually works on a hw level, but that's exactly 
> the kind of thing I would expect HW to do well (and sw would 
> do badly, because the latencies for things like CPU power 
> states are low enough that trying to do SW irq balancing at 
> that level is entirely and completely idiotic).
> 
> So I do think that we should aim for *allowing* hardware to do 
> these kinds of choices for us. Limiting irq delivery to a 
> particular core is very limiting for very little gain (almost 
> no cache benefits), but limiting it to a particular socket 
> could certainly be a valid thing. You might want to limit it 
> to a particular socket anyway, just because the hardware 
> itself may well be closer to one socket (coming off the PCIe 
> lanes of that particular socket) than anything else.

Ok, I'm convinced.

Limiting to a socket is I suspect an important constraint: we 
shouldn't just feed the hardware whatever mask user-space sends 
us, user-space might not be aware of (or confused about) socket 
boundaries.

Thanks,

	Ingo
