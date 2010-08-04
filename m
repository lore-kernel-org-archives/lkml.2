Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab0HDOpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:45:45 -0400
Received: from mail.openrapids.net ([64.15.138.104]:52350 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932841Ab0HDOpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:45:42 -0400
Date: Wed, 4 Aug 2010 10:45:39 -0400
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
Message-ID: <20100804144539.GA4617@Krystal>
References: <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com> <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal> <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <20100803182556.GA13798@Krystal> <1280904410.1923.700.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280904410.1923.700.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:06:31 up 193 days, 16:43,  6 users,  load average: 0.06, 0.06,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2010-08-03 at 14:25 -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > On Thu, 2010-07-15 at 12:26 -0400, Mathieu Desnoyers wrote:
> > > 
> > > > I was more thinking along the lines of making sure a ring buffer has the proper
> > > > support for your use-case. It shares a lot of requirements with a standard ring
> > > > buffer:
> > > > 
> > > > - Need to be lock-less
> > > > - Need to reserve space, write data in a buffer
> > > > 
> > > > By configuring a ring buffer with 4k sub-buffer size (that's configurable
> > > > dynamically), 
> > > 
> > > FWIW I really utterly detest the whole concept of sub-buffers.
> > 
> > This reluctance against splitting a buffer into sub-buffers might contribute to
> > explain the poor performance experienced with the Perf ring buffer.
> 
> That's just unsubstantiated FUD.

Extracted from:
http://lkml.org/lkml/2010/7/9/368

(executive summary)

* Throughput

   * Flight recorder mode

Ring Buffer Library        83 ns/entry (512kB sub-buffers, no reader)
                           89 ns/entry (512kB sub-buffers: read 0.3M entries/s)


Ftrace Ring Buffer:       103 ns/entry (no reader)
                          187 ns/entry (read by event:     read 0.4M entries/s)

Perf record               (flight recorder mode unavailable)


   * Discard mode

Ring Buffer Library:      96 ns/entry discarded
                          257 ns/entry written (read: 2.8M entries/s)

Perf Ring Buffer:         423 ns/entry written (read: 2.3M entries/s)
(Note that this number is based on the perf event approximation output (based on
a 24 bytes/entry estimation) rather than the benchmark module count due its
inaccuracy, which is caused by perf not letting the benchmark module know about
discarded events.)

It is really hard to get a clear picture of the data write overhead with perf,
because you _need_ to consume data. Making perf support flight recorder mode
would really help getting benchmarks that are easier to compare.

> 
> >  These
> > "sub-buffers" are really nothing new: these are called "periods" in the audio
> > world. They help lowering the ring buffer performance overhead because:
> > 
> > 1) They allow writing into the ring buffer without SMP-safe synchronization
> > primitives and memory barriers for each record. Synchronization is only needed
> > across sub-buffer boundaries, which amortizes the cost over a large number of
> > events.
> 
> The only SMP barrier we (should) have is when we update the user visible
> head pointer. The buffer code itself uses local{,64}_t for all other
> atomic ops.
> 
> If you want to amortize that barrier, simply hold off the head update
> for a while, no need to introduce sub-buffers.

I understand your point about amortized synchronization. However I still don't
see how you can achieve flight recorder mode, efficient seek on multi-GB traces
without reading the whole event stream, and live streaming without sub-buffers
(and, ideally, without much headhaches involved). ;)

> 
> > 2) They are much more splice (and, in general, page-exchange) friendly, because
> > records written after a synchronization point start at the beginning of a page.
> > This removes the need for extra copies.
> 
> This just doesn't make any sense at all, I could splice full pages just
> fine, splice keeps page order so these synchronization points aren't
> critical in any way.

If you need to read non-filled pages, then you need to splice pages piece-wise.
This does not fit well with flight recorder tracing, for which the solution
Steven and I have found is to atomically exchange pages (for Ftrace) or
sub-buffers (for the generic ring buffer library) between the reader and writer.

> 
> The only problem I have with splice atm is that we don't have a buffer
> interface without mmap() and we cannot splice pages out from under
> mmap() on all architectures in a sane manner.

The problem Perf has is probably more with flight recorder (overwrite) tracing
support than splice() per se, in this you are right.

> 
> > So I have to ask: do you detest the sub-buffer concept only because you are tied
> > to the current Perf userspace ABI which cannot support this without an ABI
> > change ?
> 
> No because I don't see the point.

OK, good to know you are open to ABI changes if I present convincing arguments.

> 
> > I'm trying to help out here, but it does not make the task easy if we have both
> > hands tied in our back because we have to keep backward ABI compatibility for a
> > tool (perf) forever, even considering its sources are shipped with the kernel.
> 
> Dude, its a published user<->kernel ABI, also you're not saying why you
> would want to break it. In your other email you allude to things like
> flight recorder mode, that could be done with the current set-up, no
> need to break the ABI at all. All you need to do is track the tail
> pointer and publish it.

How do you plan to read the data concurrently with the writer overwriting the
data while you are reading it without corruption ?

> 
> > Nope. I'm thinking that we can use a buffer just to save the stack as we call
> > functions and return, e.g.
> 
> We don't have a callback on function entry, and I'm not going to use
> mcount for that, that's simply insane.

OK, now I get a clearer picture of what Frederic is trying to do.

> 
> > call X -> reserve space to save "X" and arguments.
> > call Y -> same for Y.
> > call Z -> same for Z.
> > return -> discard event for Z.
> > return -> discard event for Y.
> > 
> > if we grab the buffer content at that point, then we have X and its arguments,
> > which is the function currently executed. That would require the ability to
> > uncommit and unreserve an event, which is not a problem as long as we have not
> > committed a full sub-buffer.
> 
> Again, I'm not really seeing the point of using sub-buffers at all.

This part of the email is unrelated to sub-buffers.

> 
> Also, what happens when we write an event after Y? Then the discard must
> fail or turn Y into a NOP, leaving a hole in the buffer.

Given that this buffer is simply used to dump the stack unwind result then I
think my scenario above was simply mislead.

> 
> > I thought that this buffer was chasing the function entry/exits rather than
> > doing a stack unwind, but I might be wrong. Perhaps Frederic could tell us more
> > about his use-case ?
> 
> No, its a pure stack unwind from NMI context. When we get an event (PMI,
> tracepoint, whatever) we write out event, if the consumer asked for a
> stacktrace with each event, we unwind the stack for him.

So why the copy ? Frederic seems to put the stack unwind in a special temporary
buffer. Why is it not saved directly into the trace buffers ?

> > > Additionally, if you have multiple consumers you can simply copy the
> > > stacktrace again, avoiding the whole pointer chase exercise. While you
> > > could conceivably copy from one ringbuffer into another that will result
> > > in very nasty serialization issues.
> > 
> > Assuming Frederic is saving information to this stack-like ring buffer at each
> > function entry and discarding at each function return, then we don't have the
> > pointer chase.
> > 
> > What I am proposing does not even involve a copy: when we want to take a
> > snapshot, we just have to force a sub-buffer switch on the ring buffer. The
> > "returns" happening at the beginning of the next (empty) sub-buffer would
> > clearly fail to discard records (expecting non-existing entry records). We would
> > then have to save a small record saying that a function return occurred. The
> > current stack frame at the end of the next sub-buffer could be deduced from the
> > complete collection of stack frame samples.
> 
> And suppose the stack-trace was all of 16 entries (not uncommon for a
> kernel stack), then you waste a whole page for 128 bytes (assuming your
> sub-buffer is page sized). I'll take the memcopy, thank you.

Well, now that I understand what you are trying to achieve, I retract my
proposal of using a stack-like ring buffer for this. I think that the stack dump
should simply be saved directly to the ring buffer, without copy. The
dump_stack() functions might have to be extended so they don't just save text
dumbly, but can also be used to save events into the trace in binary format,
perhaps with the continuation cookie Linus was proposing.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
