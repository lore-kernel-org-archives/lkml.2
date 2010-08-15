Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab0HOPaO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 11:30:14 -0400
Received: from mail.openrapids.net ([64.15.138.104]:54500 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753107Ab0HOPaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 11:30:12 -0400
Date: Sun, 15 Aug 2010 09:35:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20100815133513.GA18175@Krystal>
References: <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal> <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com> <1280903273.1923.682.camel@laptop> <1281537273.3058.14.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281537273.3058.14.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:22:40 up 204 days, 15:59,  3 users,  load average: 0.09, 0.12,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> Egad! Go on vacation and the world falls apart.
> 
> On Wed, 2010-08-04 at 08:27 +0200, Peter Zijlstra wrote:
> > On Tue, 2010-08-03 at 11:56 -0700, Linus Torvalds wrote:
> > > On Tue, Aug 3, 2010 at 10:18 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > >
> > > > FWIW I really utterly detest the whole concept of sub-buffers.
> > > 
> > > I'm not quite sure why. Is it something fundamental, or just an
> > > implementation issue?
> > 
> > The sub-buffer thing that both ftrace and lttng have is creating a large
> > buffer from a lot of small buffers, I simply don't see the point of
> > doing that. It adds complexity and limitations for very little gain.
> 
> So, I want to allocate a 10Meg buffer. I need to make sure the kernel
> has 10megs of memory available. If the memory is quite fragmented, then
> too bad, I lose out.
> 
> Oh wait, I could also use vmalloc. But then again, now I'm blasting
> valuable TLB entries for a tracing utility, thus making the tracer have
> a even bigger impact on the entire system.
> 
> BAH!
> 
> I originally wanted to go with the continuous buffer, but I was
> convinced after trying to implement it, that it was a bad choice.
> Specifically, because of needing to 1) get large amounts of memory that
> is continuous, or 2) eating up TLB entries and causing the system to
> perform poorer.
> 
> I chose page size "sub-buffers" to solve the above. It also made
> implementing splice trivial. OK, I admit, I never thought about mmapping
> the buffers, just because I figured splice was faster. But I do have
> patches that allow a user to mmap the entire ring buffer, but only in a
> "producer/consumer" mode.

FYI: the generic ring buffer also implements the mmap() interface for the flight
recorder mode.

> 
> Note, I use page size sub-buffers, but the design could work with any
> size sub-buffers. I just never implemented that (even though, when I
> wrote the code it was secretly on my todo list).

The main difference between our designs is that Ftrace use a linked list and the
generic ring buffer lib. uses a sub-buffer/page table. Considering the use-case
of reading available flight recorder pages in reverse order I've hear about at
LinuxCon (heard about it from both from Peter and Masami, and it actually makes
a whole lot of sense, because the data we care about the most and want to read
ASAP is the last subbuffers), I think the page table is more appropriate (and
flexible) than a single-direction linked list, because it allows to pick a
random page (or subbuffer) in the buffer without walking over all pages.

> 
> 
> > 
> > Their benefit is known synchronization points into the stream, you can
> > parse each sub-buffer independently, but you can always break up a
> > continuous stream into smaller parts or use a transport that includes
> > index points or whatever.
> > 
> > Their down side is that you can never have individual events larger than
> > the sub-buffer, you need to be aware of the sub-buffer when reserving
> > space etc..
> 
> The answer to that is to make a macro to do the assignment of the event,
> and add a new API.
> 
> 	event = ring_buffer_reserve_unlimited();
> 
> 	ring_buffer_assign(event, data1);
> 	ring_buffer_assign(event, data2);
> 
> 	ring_buffer_commit(event);
> 
> The ring_buffer_reserve_unlimited() could reserve a bunch of space
> beyond one ring buffer. It could reserve data in fragments. Then the
> ring_buffer_assgin() could either copy directly to the event (if the
> event exists on one sub buffer) or do a copy the space was fragmented.
> 
> Of course, userspace would need to know how to read it. And it can get
> complex due to interrupts coming in and also reserving between
> fragments, or what happens if a partial fragment is overwritten. But all
> these are not impossible to solve.

Dealing with fragmentation, sub-buffer loss, etc. is then pushed up to the trace
analyzer. While I agree that we have to keep the burden of complexity out of the
kernel as much as possible, I also think that an elegant design at the data
producer level which keeps the trace reader/analyzer simple and reliable should
be favored if it keeps a similar level of complexity in the kernel code.

A good argument supporting this is that some tracing users want to use a mmap()
scheme directly on the trace buffers to analyze the data directly in user-space
on the traced machine. In these cases, the complexity/overhead added to the
analyzer will impact the overall performance of the system being traced.

Thanks,

Mathieu

> 
> -- Steve
> 
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
