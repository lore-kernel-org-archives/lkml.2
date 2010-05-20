Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab0ETJc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 05:32:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39017 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790Ab0ETJcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 05:32:23 -0400
Date: Thu, 20 May 2010 11:31:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Lin Ming <ming.m.lin@intel.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Robert Richter <robert.richter@amd.com>
Subject: [RFD] Future tracing/instrumentation directions
Message-ID: <20100520093131.GA30929@elte.hu>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274291514.26328.930.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1887]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt <rostedt@goodmis.org> wrote:

> More than a year and a half ago (September 2008), at 
> Linux Plumbers, we had a meeting with several kernel 
> developers to come up with a unified ring buffer. A 
> generic ring buffer in the kernel that any subsystem 
> could use. After coming up with a set of requirements, I 
> worked on implementing it. One of the requirements was 
> to start off simple and work to become a more complete 
> buffering system.
>
> [...]

The thing is, in tracing land and more broadly in 
instrumentation land we have _much_ more earthly problems 
these days:

 - Lets face it, performance of the ring-buffer sucks, in 
   a big way. I've recently benchmarked it and it takes 
   hundreds of instructions to trace a single event. 
   Puh-lease ...

 - It has grown a lot of slack. It's complex and hard to
   read.

 - Over the last year or so the majority of bleeding-edge
   tracing developers have gradually migrated over to perf 
   and 'perf trace' / 'perf probe' in particular. As far 
   as the past two merge windows go they are 
   out-developing the old ftrace UIs by a ratio of 4:1.

   So this angle is becoming a prime thing to improve and
   users and developers are hurting from the ftrace/perf
   duality.

 - [ While it's still a long way off, if this trend continues
     we eventually might even be able to get rid of the 
     /debug/tracing/ temporary debug API and get rid of 
     the ugly in-kernel pretty-printing bits. This is 
     good: it may make Andrew very happy for a change ;-)

     The main detail here to be careful of is that lots of
     people are fond of the simplicity of the 
     /debug/tracing/ debug UI, so when we replace it we 
     want to do it by keeping that simple workflow (or 
     best by making it even simpler). I have a few ideas 
     how to do this.

     There's also the detail that in some cases we want to
     print events in the kernel in a human readable way: 
     for example EDAC/MCE and other critical events,
     trace-on-oops, etc. This too can be solved. ]

Regarding performance and complexity, which is our main 
worry atm, fortunately there's work going on in that 
direction - please see PeterZ's recent string of patches 
on lkml:

  4f41c01: perf/ftrace: Optimize perf/tracepoint interaction for single events
  a19d35c: perf: Optimize buffer placement by allocating buffers NUMA aware
  ef60777: perf: Optimize the perf_output() path by removing IRQ-disables
  fa58815: perf: Optimize the hotpath by converting the perf output buffer to local_t
  6d1acfd: perf: Optimize perf_output_*() by avoiding local_xchg()

And it may sound harsh but at this stage i'm personally 
not at all interested in big design talk. This isnt rocket 
science, we have developers and users and we know what 
they are doing and we know what we need to do: we need to 
improve our crap and we need to reduce complexity. Less is 
more.

So i'd like to see iterative, useful action first, and i 
am somewhat sceptical about yet another grand tracing 
design trying to match 100 requirements.

Steve, Mathieu, if you are interested please help out 
Peter with the performance and simplification work. The 
last thing we need is yet another replace-everything 
event.

If we really want to create a new ring-buffer abstraction 
i'd suggest we start with Peter's, it has a quite sane 
design and stayed simple and flexible - if then it could 
be factored out a bit.

Here are more bits of what i see as the 'action' going 
forward, in no particular order:

1) Push the /debug/tracing/events/ event description
   into sysfs, as per this thread on lkml:

     [RFC][PATCH v2 06/11] perf: core, export pmus via sysfs

     http://groups.google.com/group/linux.kernel/msg/ab9aa075016c639e

   I.e. one more step towards integrating ftrace into perf.

2) Use 1) to unify the perf events and the ftrace
   ring-buffer. This, as things are standing is
   best done by factoring out Peter's ring-buffer
   in kernel/perf_event.c. It's properly abstracted
   and it _far_ simpler than kernel/tracing/ring_buffer.c,
   which has become a monstrosity.

   (but i'm open to other simplifications as well)

3) Add the function-tracer and function-graph tracer
   as an event and integrate it into perf.

   This will live-test the efficiency of the unification
   and brings over the last big ftrace plugin to perf.

4) Gradually convert/port/migrate all the remaining 
   plugins over as well. We need to do this very gently 
   because there are users - but stop piling new 
   functionality on to the old ftrace side. This usually 
   involves:

    - Conversion of an explicit tracing callback to
      TRACE_EVENT (for example in the case of mmiotrace),
      while keeping all tool functionality.

    - Migrate any 'special' ftrace feature to perf 
      capabilities so that it's available via the 
      syscall interface as well. (for example 
      'latency maximum tracking' is something that we 
      probably want to do with kernel-side help - we 
      probably dont want to implement it via tracing 
      everything all the time and finding the maximum 
      based on terabytes of data.)

   (And there are other complications here too, but you 
    get the idea.)

All in one, i think we can reuse more than 50% of all 
current ftrace code (possibly up to 70-80%) - and we are 
already reusing bits of it.

Thanks,

	Ingo
