Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761421Ab0HFONx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 10:13:53 -0400
Received: from mail.openrapids.net ([64.15.138.104]:51794 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756064Ab0HFONv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 10:13:51 -0400
Date: Fri, 6 Aug 2010 10:13:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <20100806141348.GB30349@Krystal>
References: <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com> <1280903273.1923.682.camel@laptop> <20100804140605.GA29371@Krystal> <1280933410.1923.1267.camel@laptop> <20100806014231.GA496@Krystal> <1281089471.1947.399.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281089471.1947.399.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:47:33 up 195 days, 16:24,  5 users,  load average: 0.04, 0.05,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2010-08-05 at 21:42 -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > On Wed, 2010-08-04 at 10:06 -0400, Mathieu Desnoyers wrote:
[...]
> > > > A second major gain: having these sub-buffers lets the trace analyzer seek in
> > > > the trace very efficiently by allowing it to perform a binary search for time to
> > > > find the appropriate sub-buffer. It becomes immensely useful with large traces.
> > > 
> > > You can add sync events with a specific magic cookie in. Once you find
> > > the cookie you can sync and start reading it reliably
> > 
> > You need to read the whole trace to find these cookies (even if it is just once
> > at the beginning if you create an index).
> 
> Depends on what you want to do, you can start reading at any point in
> the stream and be guaranteed to find a sync point within sync-distance
> +max-event-size.

At _any_ point in the stream ?

So if I take, let's say, a few kB of Perf ring buffer data and I choose to
encode than into an event into another buffer (e.g. we're tracing part of the
network traffic). Then we end up in a situation where the event payload will
contain your "so special" sync point data. Basically, you have no guarantee that
you won't mix up standard event data and your synchronization event headers.

Your sync point solution just kills all encapsulation good practices in one go.

> >  My experience with users have shown me
> > that the delay between stopping trace gathering having the data shown to the
> > user is very important, because this is repeatedly done while debugging a
> > problem, and this is time the user is sitting in front of his screen, waiting.
> 
> Yeah, because after having had to wait for 36h for the problem to
> trigger that extra minute really kills.
> 
> All I can say is that in my experience brain throughput is the limiting
> factor in debugging. Not some ability to draw fancy pictures.

Here I have to bring up the fact that Linux kernel developers are not the only
tracer users.

Traces of multi-GB can be generated easily within a few seconds/minutes on many
workloads, so we're not talking of many-hours-traces here. But if we need to
read the whole trace before it can be shown, we're adding a significant delay
before the trace can be accessed.

In my experience, both brain and data gathering throughputs are limiting factors
to debugging. Drawing fancy pictures merely helps speeding up the brain process
in some cases.


> 
> > > -- the advantage
> > > is that sync events are very easy to have as an option and don't
> > > complicate the reserve path.
> > 
> > Perf, on its reserve/commit fast paths:
> > 
> > perf_output_begin: 543 bytes
> >   (perf_output_get_handle is inlined)
> > 
> > perf_output_put_handle: 201 bytes
> > perf_output_end:         77 bytes
> >   calls perf_output_put_handle
> > 
> > Total for perf:         821 bytes
> > 
> > Generic Ring Buffer Library reserve/commit fast paths:
> > 
> > Reserve:                       511 bytes
> > Commit:                        266 bytes
> > Total for Generic Ring Buffer: 777 bytes
> > 
> > So the generic ring buffer is not only faster and supports sub-buffers (along
> > with all the nice features this brings); its reserve and commit hot paths
> > fit in less instructions: it is *less* complicated than Perf's.
> 
> All I can say is that less code doesn't equal less complex (nor faster
> per-se).

Less code = less instruction cache overhead. I've also shown that the LTTng code
is at least twice faster. In terms of complexity, it is not much more complex; I
also took the extra care of doing the formal proofs to make sure the
corner-cases were dealt with, which I don't reckon neither Steven nor yourself
have done.

> Nor have I spend all my time on writing the ring-buffer,
> there's more interesting things to do.

I must admit that I probably spent much more time working on the ring buffer
than you did. It looks like one's interest can only focus on so many areas at
once. So if you are not that interested in ring buffers, can you at least stop
opposing to people who care deeply ?

If we agree that we don't care about the same use-cases, there might be room for
many ring buffers in the kernel. It's just a shame that we have to multiply
amount of code-review. We have to note that this goes against Linus' request for
a shared and common ring buffer used by all tracers.


> And the last time I ran perf on perf, the buffer wasn't the thing that
> was taking most time.

Very interesting. I know the trace clock performance are terrible too. But let's
keep that for another discussion please.

> 
> And unlike what you claim below, it most certainly can deal with events
> larger than a single page.

What I said below was: perf cannot write events larger than its buffer size. So
it already has to take that "test" branch for maximum event size. I said nothing
about page size in this context.

> 
> > > If you worry about the cost of parsing the events, you can amortize that
> > > by things like keeping the offset of the first event in every page in
> > > the pageframe, or the offset of the next sync event or whatever scheme
> > > you want.
> > 
> > Hrm ? AFAIK, the page-frame is an internal kernel-only data structure. That
> > won't be exported to user-space, so how is the parser supposed to see this
> > information exactly to help it speeding up parsing ?
> 
> Its about the kernel parsing the buffer to push the tail ahead of the
> reserve window, so that you have a reliable point to start reading the
> trace from -- or didn't you actually get the intent of that patch?

I got the intent of the patch, I just somehow missed that this paragraph was
applying to the patch specifically.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
