Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935164Ab0HFBmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:42:39 -0400
Received: from mail.openrapids.net ([64.15.138.104]:38324 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934131Ab0HFBmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:42:35 -0400
Date: Thu, 5 Aug 2010 21:42:31 -0400
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
Message-ID: <20100806014231.GA496@Krystal>
References: <20100714223107.GA2350@Krystal> <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com> <1280903273.1923.682.camel@laptop> <20100804140605.GA29371@Krystal> <1280933410.1923.1267.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280933410.1923.1267.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 20:54:13 up 195 days,  3:30,  5 users,  load average: 0.04, 0.05,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2010-08-04 at 10:06 -0400, Mathieu Desnoyers wrote:
> 
> > The first major gain is the ability to implement flight recorder tracing
> > (overwrite mode), which Perf still lacks.
> 
> http://lkml.org/lkml/2009/7/6/178
> 
> I've send out something like that several times, but nobody took it
> (that is, tested it and provided a user). Note how it doesn't require
> anything like sub-buffers.

+static void perf_output_tail(struct perf_mmap_data *data, unsigned int head)
...
+       unsigned long tail, new;
...
+       unsigned long size;

+       while (tail + size - head < 0) {
....
+       }

How is the while condition ever be supposed to be true ? I guess nobody took it
because it simply was not ready for testing.

> 
> > A second major gain: having these sub-buffers lets the trace analyzer seek in
> > the trace very efficiently by allowing it to perform a binary search for time to
> > find the appropriate sub-buffer. It becomes immensely useful with large traces.
> 
> You can add sync events with a specific magic cookie in. Once you find
> the cookie you can sync and start reading it reliably

You need to read the whole trace to find these cookies (even if it is just once
at the beginning if you create an index). My experience with users have shown me
that the delay between stopping trace gathering having the data shown to the
user is very important, because this is repeatedly done while debugging a
problem, and this is time the user is sitting in front of his screen, waiting.

> -- the advantage
> is that sync events are very easy to have as an option and don't
> complicate the reserve path.

Perf, on its reserve/commit fast paths:

perf_output_begin: 543 bytes
  (perf_output_get_handle is inlined)

perf_output_put_handle: 201 bytes
perf_output_end:         77 bytes
  calls perf_output_put_handle

Total for perf:         821 bytes

Generic Ring Buffer Library reserve/commit fast paths:

Reserve:                       511 bytes
Commit:                        266 bytes
Total for Generic Ring Buffer: 777 bytes

So the generic ring buffer is not only faster and supports sub-buffers (along
with all the nice features this brings); its reserve and commit hot paths
fit in less instructions: it is *less* complicated than Perf's.


> 
> > The third major gain: for live streaming of traces, having sub-buffer lets you
> > "package" the event data you send over the network into sub-buffers.
> 
> See the sync events.

I am guessing you plan to rely on these sync events to know which data "blocs"
are fully received. This could possibly be made to work.

> Also, a transport can rewrite the stream any which
> way it pretty well wants to, as long as the kernel<->user interface is
> reliable an unreliable user<->user transport can repackage it to suit
> its needs.

repackage = copy = poor performance. No thanks.

> 
> > Making sure events don't cross sub-buffer boundaries simplify a lot of things,
> > starting with dealing with "overwritten" sub-buffers in flight recorder mode.
> > Trying to deal with a partially overwritten event is just insane.
> 
> See the above patch, simply parse the events and push the tail pointer
> ahead of the reservation before you trample on it.

I'm not sure that patch is ready for prime-time yet. As you point out in your
following email, you need to stop tracing to consume data, which does not fit my
users'use-cases.

> 
> If you worry about the cost of parsing the events, you can amortize that
> by things like keeping the offset of the first event in every page in
> the pageframe, or the offset of the next sync event or whatever scheme
> you want.

Hrm ? AFAIK, the page-frame is an internal kernel-only data structure. That
won't be exported to user-space, so how is the parser supposed to see this
information exactly to help it speeding up parsing ?

> 
> Again, no need for sub-buffers.

I don't see this claim as satisfactorily supported here, sorry.

> 
> Also, not having sub-buffers makes reservation easier since you don't
> need to worry about those empty tails.

So far I've shown that you sub-buffer-less implementation is not even simpler
than a implementation using sub-buffers.

By the way, even with your sub-buffer free scheme, you cannot write an event
bigger than your buffer size. So you have a likewise limitation in terms of
maximum event size (so you already have to test this on your fast path).

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
