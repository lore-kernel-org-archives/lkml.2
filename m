Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab0HCS0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:26:06 -0400
Received: from mail.openrapids.net ([64.15.138.104]:38071 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932325Ab0HCS0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:26:00 -0400
Date: Tue, 3 Aug 2010 14:25:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100803182556.GA13798@Krystal>
References: <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com> <20100714193652.GA13630@nowhere> <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com> <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal> <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280855904.1923.675.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:49:46 up 192 days, 20:26,  6 users,  load average: 0.05, 0.09,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2010-07-15 at 12:26 -0400, Mathieu Desnoyers wrote:
> 
> > I was more thinking along the lines of making sure a ring buffer has the proper
> > support for your use-case. It shares a lot of requirements with a standard ring
> > buffer:
> > 
> > - Need to be lock-less
> > - Need to reserve space, write data in a buffer
> > 
> > By configuring a ring buffer with 4k sub-buffer size (that's configurable
> > dynamically), 
> 
> FWIW I really utterly detest the whole concept of sub-buffers.

This reluctance against splitting a buffer into sub-buffers might contribute to
explain the poor performance experienced with the Perf ring buffer. These
"sub-buffers" are really nothing new: these are called "periods" in the audio
world. They help lowering the ring buffer performance overhead because:

1) They allow writing into the ring buffer without SMP-safe synchronization
primitives and memory barriers for each record. Synchronization is only needed
across sub-buffer boundaries, which amortizes the cost over a large number of
events.

2) They are much more splice (and, in general, page-exchange) friendly, because
records written after a synchronization point start at the beginning of a page.
This removes the need for extra copies.

So I have to ask: do you detest the sub-buffer concept only because you are tied
to the current Perf userspace ABI which cannot support this without an ABI
change ?

I'm trying to help out here, but it does not make the task easy if we have both
hands tied in our back because we have to keep backward ABI compatibility for a
tool (perf) forever, even considering its sources are shipped with the kernel.

> 
> > all we need to add is the ability to squash a previously saved
> > record from the buffer. I am confident we can provide a clean API for this that
> > would allow discard of previously committed entry as long as we are still on the
> > same non-fully-committed sub-buffer. This fits your use-case exactly, so that's
> > fine.
> 
> squash? truncate you mean? So we can allocate/reserve the largest
> possible event size and write the actual event and then truncate to the
> actually used size?

Nope. I'm thinking that we can use a buffer just to save the stack as we call
functions and return, e.g.

call X -> reserve space to save "X" and arguments.
call Y -> same for Y.
call Z -> same for Z.
return -> discard event for Z.
return -> discard event for Y.

if we grab the buffer content at that point, then we have X and its arguments,
which is the function currently executed. That would require the ability to
uncommit and unreserve an event, which is not a problem as long as we have not
committed a full sub-buffer.

> 
> I really dislike how that will end up with huge holes in the buffer when
> you get nested events.

This buffer only works like a stack. I don't think your comment apply.

> 
> Also, I think you're forgetting that doing the stack unwind is a very
> costly pointer chase, adding a simple linear copy really doesn't seem
> like a problem.

I thought that this buffer was chasing the function entry/exits rather than
doing a stack unwind, but I might be wrong. Perhaps Frederic could tell us more
about his use-case ?

> 
> Additionally, if you have multiple consumers you can simply copy the
> stacktrace again, avoiding the whole pointer chase exercise. While you
> could conceivably copy from one ringbuffer into another that will result
> in very nasty serialization issues.

Assuming Frederic is saving information to this stack-like ring buffer at each
function entry and discarding at each function return, then we don't have the
pointer chase.

What I am proposing does not even involve a copy: when we want to take a
snapshot, we just have to force a sub-buffer switch on the ring buffer. The
"returns" happening at the beginning of the next (empty) sub-buffer would
clearly fail to discard records (expecting non-existing entry records). We would
then have to save a small record saying that a function return occurred. The
current stack frame at the end of the next sub-buffer could be deduced from the
complete collection of stack frame samples.

> 
> > You could have one 4k ring buffer per cpu per execution context. 
> 
> Why?

This seems to fit what Frederic described he needed: he uses one separate buffer
per cpu per execution context at the moment. But we could arguably save
all this stack-shaped information in per-cpu buffers.

> 
> >  I wonder if
> > each Linux architecture have support for separated thread vs softirtq vs irq vs
> > nmi stacks ? 
> 
> Why would that be relevant? We can have NMI inside IRQ inside soft-IRQ
> inside task context in general (dismissing the nested IRQ mess). You
> don't need to have a separate stack for each context in order to nest
> them.

I was asking this because Frederic seems to rely on having separate buffers per
cpu and per execution context to deal with concurrency (so not expecting
concurrency from interrupts or NMIs when writing into the softirq per-cpu stack
buffer).

> 
> > Even then, given you have only one stack for all shared irqs, you
> > need something that is concurrency-aware at the ring buffer level.
> 
> I'm failing to see you point. 

My point is that we might need to expect concurrency from local execution
contexts (e.g. interrupts nested over other interrupt handlers) in the design of
this stack-like ring buffer. I'm not sure Frederic's approach of using one
buffer per execution context per cpu makes sense for all cases. The memory vs
context isolation trade-off seems rather odd if we have to create e.g. one
buffer per IRQ number.

> 
> > These small stack-like ring buffers could be used to save your temporary stack
> > copy. When you really need to save it to a larger ring buffer along with a
> > trace, then you just take a snapshot of the stack ring buffers.
> 
> OK, why? Your proposal includes the exact same extra copy but introduces
> a ton of extra code to effect the same, not a win.

Please refer to the "no extra copy" solution I explain in the reply here (see
above). I did not want to go into too much details regarding performance
optimization in the initial mail to Frederic, as these things can be done
incrementally. But given that you insist... :)

> 
> > So you get to use one single ring buffer synchronization and memory allocation
> > mechanism, that everyone has reviewed. The advantage is that we would not be
> > having this nmi race discussion in the first place: the generic ring buffer uses
> > "get page" directly rather than relying on vmalloc, because these bugs have
> > already been identified and dealt with years ago.
> 
> That's like saying don't use percpu_alloc() but open-code the thing
> using kmalloc()/get_pages().. I really don't see any merit in that.

I'm not saying "open-code this". I'm saying "use a specialized library that does
this get_pages() allocation and execution context synchronization for you", so
we stop the code duplication madness.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
