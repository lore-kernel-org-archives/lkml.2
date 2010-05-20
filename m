Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab0ETOiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:38:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64408 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab0ETOio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:38:44 -0400
X-Authority-Analysis: v=1.1 cv=APwCx09NCuKDvl2mjFwkKdJZScS8XOZHPgx3WG6BpL0= c=1 sm=0 a=jOljwp8wn3oA:10 a=GQCbJdZ--msA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=FyswP2SAAAAA:20 a=cO93fxbv8_thgNfO_0YA:9 a=WOnk40Lnz2q3YOabrjwA:7 a=TA68gEQmYh5IlgV8m1R7eXKBvvMA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFD] Future tracing/instrumentation directions
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
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
In-Reply-To: <20100520093131.GA30929@elte.hu>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com>
	 <20100520093131.GA30929@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 20 May 2010 10:38:38 -0400
Message-ID: <1274366318.26328.2292.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 11:31 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > More than a year and a half ago (September 2008), at 
> > Linux Plumbers, we had a meeting with several kernel 
> > developers to come up with a unified ring buffer. A 
> > generic ring buffer in the kernel that any subsystem 
> > could use. After coming up with a set of requirements, I 
> > worked on implementing it. One of the requirements was 
> > to start off simple and work to become a more complete 
> > buffering system.
> >
> > [...]
> 
> The thing is, in tracing land and more broadly in 
> instrumentation land we have _much_ more earthly problems 
> these days:
> 
>  - Lets face it, performance of the ring-buffer sucks, in 
>    a big way. I've recently benchmarked it and it takes 
>    hundreds of instructions to trace a single event. 
>    Puh-lease ...

"Puh-lease"?

Hmm, what were the timings?  I just ran the ring_buffer_benchmark
module. It's in mainline, so anyone could do the same. Remember to
disable KERNEL_DEBUG because things like lockdep can have a significant
impact on it.

Note, instructions themselves are not that bad, but what those
instructions do count a lot more. I avoid all lock functions and memory
barriers which cause the code to be a little bigger. But a single
cmpxchg can take much more time than a lot of other instructions put
together.

On this machine:

model name	: Intel(R) Core(TM)2 Quad  CPU   Q9450  @ 2.66GHz

It's a 2x2 (4 cores)

With running:

# modprobe ring_buffer_benchmark producer_fifo=10
# sleep 30
# cat /debug/tracing/trace


           <...>-2636  [003]   761.969850: ring_buffer_producer_thread: Starting ring buffer hammer
           <...>-2636  [003]   771.910121: ring_buffer_producer_thread: End ring buffer hammer
           <...>-2636  [003]   771.910172: ring_buffer_producer_thread: Running Consumer at nice: 19
           <...>-2636  [003]   771.910172: ring_buffer_producer_thread: Running Producer at SCHED_FIFO 10
           <...>-2636  [003]   771.910173: ring_buffer_producer_thread: Time:     9965321 (usecs)
           <...>-2636  [003]   771.910173: ring_buffer_producer_thread: Overruns: 0
           <...>-2636  [003]   771.910174: ring_buffer_producer_thread: Read:     76580325  (by pages)
           <...>-2636  [003]   771.910175: ring_buffer_producer_thread: Entries:  75
           <...>-2636  [003]   771.910175: ring_buffer_producer_thread: Total:    76580400
           <...>-2636  [003]   771.910175: ring_buffer_producer_thread: Missed:   0
           <...>-2636  [003]   771.910176: ring_buffer_producer_thread: Hit:      76580400
           <...>-2636  [003]   771.910176: ring_buffer_producer_thread: Entries per millisec: 7684
           <...>-2636  [003]   771.910176: ring_buffer_producer_thread: 130 ns per entry
           <...>-2636  [003]   771.910177: ring_buffer_producer_thread: Sleeping for 10 secs

           <...>-2636  [003]   781.884686: ring_buffer_producer_thread: Starting ring buffer hammer
           <...>-2636  [003]   790.862392: ring_buffer_producer_thread: End ring buffer hammer
           <...>-2636  [003]   790.897399: ring_buffer_producer_thread: Running Consumer at nice: 19
           <...>-2636  [003]   790.897400: ring_buffer_producer_thread: Running Producer at SCHED_FIFO 10
           <...>-2636  [003]   790.897401: ring_buffer_producer_thread: Time:     9000321 (usecs)
           <...>-2636  [003]   790.897401: ring_buffer_producer_thread: Overruns: 26581200
           <...>-2636  [003]   790.897402: ring_buffer_producer_thread: Read:     6767200  (by events)
           <...>-2636  [003]   790.897403: ring_buffer_producer_thread: Entries:  0
           <...>-2636  [003]   790.897403: ring_buffer_producer_thread: Total:    33348400
           <...>-2636  [003]   790.897403: ring_buffer_producer_thread: Missed:   0
           <...>-2636  [003]   790.897404: ring_buffer_producer_thread: Hit:      33348400
           <...>-2636  [003]   790.897404: ring_buffer_producer_thread: Entries per millisec: 3705
           <...>-2636  [003]   790.897405: ring_buffer_producer_thread: 269 ns per entry

While having the reader read by pages (splice mode) a write takes 130ns
per entry. Not that bad.

But when the reader is reading each event, (I'm assuming we get some
cache line bouncing here, it is still lockless), a write takes 269ns.

Note, the reader is an aggressive reader. That is, it goes into a strong
loop and just reads as fast as it can. Which would cause cache line
bouncing.

When I disable the reader and just measure what a write takes:

# rmmod ring_buffer_benchmark
# modprobe ring_buffer_benchmark disable_reader=1 producer_fifo=10
# sleep 30
# cat /debug/tracing/trace

           <...>-2649  [003]  1141.981639: ring_buffer_producer_thread: Starting ring buffer hammer
           <...>-2649  [003]  1151.950840: ring_buffer_producer_thread: End ring buffer hammer
           <...>-2649  [003]  1151.950841: ring_buffer_producer_thread: Running Producer at SCHED_FIFO 10
           <...>-2649  [003]  1151.950842: ring_buffer_producer_thread: Time:     9994238 (usecs)
           <...>-2649  [003]  1151.950842: ring_buffer_producer_thread: Overruns: 90635670
           <...>-2649  [003]  1151.950843: ring_buffer_producer_thread: Read:     (reader disabled)
           <...>-2649  [003]  1151.950843: ring_buffer_producer_thread: Entries:  62480
           <...>-2649  [003]  1151.950844: ring_buffer_producer_thread: Total:    90698150
           <...>-2649  [003]  1151.950844: ring_buffer_producer_thread: Missed:   0
           <...>-2649  [003]  1151.950844: ring_buffer_producer_thread: Hit:      90698150
           <...>-2649  [003]  1151.950845: ring_buffer_producer_thread: Entries per millisec: 9075
           <...>-2649  [003]  1151.950845: ring_buffer_producer_thread: 110 ns per entry
           <...>-2649  [003]  1151.950846: ring_buffer_producer_thread: Sleeping for 10 secs

It takes just a 110ns.

Lets now use perf to see what is happening:

# perf record -a -c10000 -f
(wait 30 secs)
Ctrl-C

# perf report

no symbols found in /usr/sbin/irqbalance, maybe install a debug package?
# Samples: 1995496
#
# Overhead          Command                                                     Shared Object  Symbol
# ........  ...............  ................................................................  ......
#
    23.80%      rb_producer  [kernel.kallsyms]                                                 [k] native_sched_clock
    14.83%      rb_producer  [kernel.kallsyms]                                                 [k] rb_reserve_next_event
    13.20%      rb_producer  [kernel.kallsyms]                                                 [k] ring_buffer_unlock_commit
    12.84%      rb_producer  [kernel.kallsyms]                                                 [k] ring_buffer_lock_reserve
     9.27%      rb_producer  [kernel.kallsyms]                                                 [k] rb_end_commit
     9.19%      rb_producer  [kernel.kallsyms]                                                 [k] __rb_reserve_next
     5.24%      rb_producer  [kernel.kallsyms]                                                 [k] trace_clock_local
     3.11%      rb_producer  [kernel.kallsyms]                                                 [k] ring_buffer_event_data
     2.88%      rb_producer  [ring_buffer_benchmark]                                           [k] ring_buffer_benchmark_init
     2.53%      rb_producer  [kernel.kallsyms]                                                 [k] trace_recursive_unlock
     0.39%      rb_producer  [kernel.kallsyms]                                                 [k] do_gettimeofday
     0.34%      rb_producer  [kernel.kallsyms]                                                 [k] read_tsc
     0.18%      rb_producer  [kernel.kallsyms]                                                 [k] getnstimeofday
     0.14%          swapper  [kernel.kallsyms]                                                 [k] mwait_idle


Now that the sched_clock is %23.8 percent, it doesn't look as bad.

rb_reserve_next_event is 14.83, ring_buffer_unlock_commit is 13.20,
ring_buffer_lock_reserve is 12.84, rb_end_commit is 9.27,
__rb_reserve_next is 8.18, trace_clock_local is 5.24 (which only
disables preemption and calls sched_clock), ring_buffer_event_data is
3.11 which only returns a pointer on a structure (once a event).

ring_buffer_benchmark_init is the benchmark code itself, and
trace_recursive_unlock is the code you asked me to add to check for
cases where the tracer could have recursed itself.

14.83 + 13.20 + 9.27 + 8.18 + 5.24 + 3.11 = 53.83%

Considering that the system is basically idle except for this benchmark,
that makes sense to have it that high. We need to compare it. The
sched_clock() takes up 1/3 of the entire trace event.




> 
>  - It has grown a lot of slack. It's complex and hard to
>    read.

I admit, that it got over designed, and I'm all for replacing it. We
were all involved in the initial design, and I posted several versions
of RFC when I created it. But I admit, it became complex, and now that
we know what we want, we can take a step back and redesign a new one
from scratch.

But until we do so, I'm continuing to support the current one, and
adding small updates when needed.


> 
>  - Over the last year or so the majority of bleeding-edge
>    tracing developers have gradually migrated over to perf 
>    and 'perf trace' / 'perf probe' in particular. As far 
>    as the past two merge windows go they are 
>    out-developing the old ftrace UIs by a ratio of 4:1.

Of course a new project will be in a high state of flux. I'm quite
satisfied with the interface with ftrace and did not feel that it needed
changing.

> 
>    So this angle is becoming a prime thing to improve and
>    users and developers are hurting from the ftrace/perf
>    duality.

I agree.

> 
>  - [ While it's still a long way off, if this trend continues
>      we eventually might even be able to get rid of the 
>      /debug/tracing/ temporary debug API and get rid of 
>      the ugly in-kernel pretty-printing bits. This is 
>      good: it may make Andrew very happy for a change ;-)

So how do you plan on getting rid of the in-kernel pretty-printing bits
and keeping the trace_dump_on_oops?  There's a strong dependency between
those two.


> 
>      The main detail here to be careful of is that lots of
>      people are fond of the simplicity of the 
>      /debug/tracing/ debug UI, so when we replace it we 
>      want to do it by keeping that simple workflow (or 
>      best by making it even simpler). I have a few ideas 
>      how to do this.

Note, I still would not want to remove the /debug interface. It is a
debug interface anyway. Having both a syscall access the functionality
of the code and having a debug interface access it very trivial. This
could also be a way we can debug the tool too.

We can officially support only the tool side, but why throw away the
baby with the bath water?


> 
>      There's also the detail that in some cases we want to
>      print events in the kernel in a human readable way: 
>      for example EDAC/MCE and other critical events,
>      trace-on-oops, etc. This too can be solved. ]

But if the code for trace-on-oops is there, then the pretty print code
is also there.

> 
> Regarding performance and complexity, which is our main 
> worry atm, fortunately there's work going on in that 
> direction - please see PeterZ's recent string of patches 
> on lkml:
> 
>   4f41c01: perf/ftrace: Optimize perf/tracepoint interaction for single events
>   a19d35c: perf: Optimize buffer placement by allocating buffers NUMA aware
>   ef60777: perf: Optimize the perf_output() path by removing IRQ-disables
>   fa58815: perf: Optimize the hotpath by converting the perf output buffer to local_t
>   6d1acfd: perf: Optimize perf_output_*() by avoiding local_xchg()

Yes, I saw these, and it helps a little, but still not everything is
there.

> 
> And it may sound harsh but at this stage i'm personally 
> not at all interested in big design talk.

Rewriting ftrace on top of perf is a big design change.


>  This isnt rocket 
> science, we have developers and users and we know what 
> they are doing and we know what we need to do: we need to 
> improve our crap and we need to reduce complexity. Less is 
> more.
> 
> So i'd like to see iterative, useful action first, and i 
> am somewhat sceptical about yet another grand tracing 
> design trying to match 100 requirements.

Here's a few things that I find required:

The ability to use splice. You keep telling me this is not important,
but splice is magnitudes faster than mmaping into userspace and then
copying into a file. If the splice removes the extra copy as we are
working on, it will get even faster. It also makes writing over the
network much easier. Which trace-cmd does, and it took me half a day to
make it do so.

We also need a way to easily read the buffer from the kernel. This is
for trace-on-oops.

Overwrite mode must also be supported. I know that Peter thinks its
silly to do this and have it write to a file, but I find it helpful to
do so. But fine, I can live without overwrite to a file, if no one else
cares. But overwrite mode itself must work for trace-on-oops.

We need a way to start and stop tracing from the kernel and userspace.
Again, for trace-on-oops. When a bug is hit, we need a way to stop it.
We also must have a way to easily start it again from userspace.

A simple on/off switch. This is something that you and Thomas hammered
into me which was the creation of tracing_on.

The above can be done, but lets not just hack the changes in. Lets
really look at a proper design.

> 
> Steve, Mathieu, if you are interested please help out 
> Peter with the performance and simplification work. The 
> last thing we need is yet another replace-everything 
> event.

But that is what you are asking to happen to ftrace.
"replace-everything".

> 
> If we really want to create a new ring-buffer abstraction 
> i'd suggest we start with Peter's, it has a quite sane 
> design and stayed simple and flexible - if then it could 
> be factored out a bit.

I'm sorry, but it is very coupled with perf. It is simple and flexible
with what perf does today, but not what ftrace does today, or to make
perf do what ftrace does.

> 
> Here are more bits of what i see as the 'action' going 
> forward, in no particular order:
> 
> 1) Push the /debug/tracing/events/ event description
>    into sysfs, as per this thread on lkml:
> 
>      [RFC][PATCH v2 06/11] perf: core, export pmus via sysfs
> 
>      http://groups.google.com/group/linux.kernel/msg/ab9aa075016c639e
> 
>    I.e. one more step towards integrating ftrace into perf.

We could do something like this, but it is not as trivial as it may
seem.

> 
> 2) Use 1) to unify the perf events and the ftrace
>    ring-buffer. This, as things are standing is
>    best done by factoring out Peter's ring-buffer
>    in kernel/perf_event.c. It's properly abstracted
>    and it _far_ simpler than kernel/tracing/ring_buffer.c,
>    which has become a monstrosity.

Sure, my code has become quite complex, I'll admit that. I'm for
refactoring. I really don't care what code is used as long as I still
have the requirements that make ftrace useful for me and several others.

And yes, any ring buffer needs to be factored out to a defined
interface. The current ring buffer in perf is very coupled with the perf
design. The event code written to perf in include/trace/ftrace.h is
still quite a hack.

> 
>    (but i'm open to other simplifications as well)
> 
> 3) Add the function-tracer and function-graph tracer
>    as an event and integrate it into perf.

Here's something that I think perf needs to do. It needs to become a bit
more modulized, and not absorb everything into perf instead of having
things use just a part of perf. Like the breakpoint code requires full
perf to be done, and x86 has PERF_EVENTS permanently on. Which is really
a PITA.

As I designed ftrace from day one, I tried to make it modular. Thus, the
function trace (kernel/trace/ftrace.c) has always been a separate entity
from ftrace itself. Heck, LTTng uses it. It would be actually trivial to
implement the function tracer in perf today. Just register a function
you want called at every function event and start running.

I need to abstract out the "what function to call bit" but that's about
it.

> 
>    This will live-test the efficiency of the unification
>    and brings over the last big ftrace plugin to perf.
> 
> 4) Gradually convert/port/migrate all the remaining 
>    plugins over as well. We need to do this very gently 
>    because there are users - but stop piling new 
>    functionality on to the old ftrace side. This usually 
>    involves:

I have not been piling functionality into the ftrace side, as you stated
at the beginning of the email, that the development has been quite slow.
Yes, I've been still working on things, but I would say it is a far cry
from "piling".

I did add some simple features, like the "lost events" to the ring
buffer, but that code can be looked at for ideas for the future. It does
not make merging any more difficult than it already is.

Fine, I'll stop some of the code I was going to work on (multiple
buffers for ftrace, event triggers, configuring events to stop the
tracer (like for different kinds of BUG() and WARN_ON()), etc).

> 
>     - Conversion of an explicit tracing callback to
>       TRACE_EVENT (for example in the case of mmiotrace),
>       while keeping all tool functionality.

Not sure what this is.

> 
>     - Migrate any 'special' ftrace feature to perf 
>       capabilities so that it's available via the 
>       syscall interface as well. (for example 
>       'latency maximum tracking' is something that we 
>       probably want to do with kernel-side help - we 
>       probably dont want to implement it via tracing 
>       everything all the time and finding the maximum 
>       based on terabytes of data.)
> 
>    (And there are other complications here too, but you 
>     get the idea.)

Yes, the latency tracers are special, and I treat them special in
ftrace. They can be redesigned to keep their current functionality. That
needed to be done anyway.

> 
> All in one, i think we can reuse more than 50% of all 
> current ftrace code (possibly up to 70-80%) - and we are 
> already reusing bits of it.

Ingo, as we have had this conversation, I don't know if you realized
that I agreed to merge ftrace to perf. There's just some functionality
about ftrace I really want to keep, which does include accessing
via /debugfs, pretty-print (which is needed by trace-on-oops) and
splice.

-- Steve


