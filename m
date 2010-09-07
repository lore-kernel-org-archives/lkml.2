Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab0IGTMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:12:17 -0400
Received: from mail.openrapids.net ([64.15.138.104]:59584 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756992Ab0IGTMO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 15:12:14 -0400
Date: Tue, 7 Sep 2010 15:12:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [ANNOUNCEMENT] LTTng tracer re-packaged as stand-alone modules
Message-ID: <20100907191210.GB17491@Krystal>
References: <20100903131213.GA3230@Krystal> <20100903164742.087da8f4@basil.nowhere.org> <20100906172920.GA18220@Krystal> <20100907092240.7f4b3a68@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20100907092240.7f4b3a68@basil.nowhere.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:16:05 up 227 days, 19:52,  4 users,  load average: 0.01, 0.04,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> On Mon, 6 Sep 2010 13:29:20 -0400
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> Mathieu,
> 
> One experience I have with closely looking at other long term
> forked patchkits is that over time they tend to accumulate
> stuff that is not really needed and various things which
> are very easy to integrate. It sounds like you have some 
> candidates like this here.
> 
> > - Adding interfaces to dynamic kprobes and tracepoints to list the
> > currently available instrumentation as well as notifiers to let LTTng
> > know about events appearing while tracing runs (e.g. module loaded,
> > new dynamic probe added).
> 
> That sounds trivial.
> 
> > - Export the splice_to_pipe symbol (and probably some more I do not
> > recall at the moment).
> 
> Dito.
> 
> > - Add ability to read the module list coherently in multiple reads
> > when racing with module load/unload.
> 
> Can't you just take the module_mutex?

I just looked over my code again to remember that LTTng don't use read() to list
the available markers anymore. It shows them in a debugfs directory tree
instead, which makes the problem caused by chunk-wise read() of seqfiles go
away. So by making sure the LTTng tracepoint table mutex always nests inside the
modules mutex, I should be OK. Now that the modules_mutex is exported to
modules, it should work fine.

module load
  lock module_mutex (1)
  execute module notifiers
  call lttng callback
    lock lttng tracepoint mutex (2)

trace session creation
  lock module_mutex (1)
  lock lttng tracepoint mutex (2)
  iterate on core kernel tracepoints
  iterate on each module's tracepoints
  unlock lttng tracepoint mutex
  unlock module_mutex

> 
> > - Either add the ability to fault in NMI handlers, or add call to
> >   vmalloc_sync_all() each time a module is loaded, or export
> > vmalloc_sync_all() to GPL modules so they can ensure that the
> > fault-in memory after using vmalloc but before the memory is used by
> > the tracer.
> 
> I thought Linus had fixed that in the page fault handler?
> 
> It's a generic problem hit by other code, so it needs to be fixed
> in mainline in any case.

Yes, Linus and I exchanged a few emails about this, and I think it lead to an
interesting solution (we still had to take care of MCE by using another stack
rather than reserving space at the beginning of the NMI stack). I had to
postpone working more on this issue, since I have to follow the priority of the
companies for whom I'm contracting. I plan to work more on this as soon as I can
push the more pressing stuff into mainline.

> 
> >   - CPU idle notifier notifiers (for trace streaming with deferrable
> > timers).
> 
> x86 has them already, otherwise i7300_idle et.al. wouldn't work.
> What do you need what they don't do?

The problem is that this is only implemented for x86, and LTTng is
arch-agnostic. So I need this cpu idle notifiers for all architectures, and at
least a dummy notifier chain that lets LTTng build on architectures other than
x86. We can complement this with a HAVE_CPU_IDLE_NOTIFIER build define so the
arch-agnostic code can choose to use deferrable timers or not.

> 
> >   - Poll wait exclusive (to address thundering herd problem in
> > poll()).
> 
> How does that work?

I let the LTTng poll file operation calls a new:

poll_wait_set_exclusive(wait);

Which makes sure that when we have multiple threads waiting on the same file
descriptor (which represents a ring buffer), only one of the threads is woken
up.

> Wouldn't that break poll semantics?

The way I currently do it, yes, but I think we could do better.

Basically, what I need is that a poll wakeup triggers an exclusive synchronous
wakeup, and then re-checks the wakeup condition. AFAIU, the usual poll semantics
seems to be that all poll()/epoll() should be notified of state changes on all
examined file descriptors. But wether we should do the wakeup first, wait for
the woken up thread to run (possibly consume the data), and then only after that
check if we must continue going through the wakeup chain is left as a grey zone
(ref.  http://www.opengroup.org/onlinepubs/009695399/functions/poll.html).


> If not it sounds like a general improvement.
> 
> I assume epoll already does it?

Nope, if I believe epoll(7):


"      Q2  Can two epoll instances wait for the same file descriptor?  If  so,
           are events reported to both epoll file descriptors?

       A2  Yes,  and  events would be reported to both.  However, careful pro‐
           gramming may be needed to do this correctly."


> 
> >   - prio_heap.c new remove_maximum(), replace() and cherrypick().
> >   - Inline memcpy().
> 
> What's that? gcc does inline memcpy

My understanding (and the result of some testing) is that gcc provides inline
memcpy when the length to copy is known statically (and smaller or eq. to 64
bytes). However, as soon as the length is determined dynamically, we go for the
function call in the Linux kernel. The problem with tracing is that the typical
data copy is 

a) of a small payload
b) which has an unknown size

So paying the price of an extra function call for each field hurts performances
a lot.

> 
> > - Trace clock
> >   - Faster trace clock implementation.
> 
> What's the problem here? If it's faster it should be integrated.
> 
> I know that the old sched_clock did some horrible things
> that could be improved.

I think the problem lays in many aspects. Let's have a looks at all 3 trace
clock flavors provided:

"local: CPU-local trace clock"

* uses sched_clock(), which provides completely inaccurate synchronization
  across CPUs.

"medium: scalable global clock with some jitter", which seems to be the
compromise between high overhead and precision:

* It can have a ~1 jiffy jitter between the CPUs. This is just too much for
  low-level tracing.

"global: globally monotonic, serialized clock"

* Disables interrupts (slow)
* Takes a spin lock (awefully slow, non-scalable)
* Uses sequence lock, deals with NMI deadlock risk by providing inaccurate
  clock values to NMI handlers.

In addition, the whole trace clock infrastructure in the Linux kernel is based
on callbacks, somehow assuming that function calls cost nothing, which is wrong.
Also, the mainline trace clock returns the time in nanoseconds, which adds
useless calculations on the fast path.


The LTTng trace clock does the following:

1) Uses a RCU read-side instead of a sequence lock to deal with concurrency in a
   NMI-safe fashion. RCU is faster than the sequence lock too because it does
   not require a memory barrier.
2) LTTng trace clock returns the time in an arbitrary unit, which is scaled to
   ns by exporting the unit to ns ratio once at trace start. For architectures
   with constant synchronized TSC, this means that reading time is a simple
   rdtsc.
3) LTTng trace clock implements the trace_clock() read function as a static
   inline, because it is typically embedded in the tracing function, so we
   save a function call.
4) (done on ARM OMAP3, not x86 yet) LTTng handles dynamic frequency scaling
   affecting the cycle counter speed by hooking into CPU freq notifiers and
   power management notifiers, which resynchronize on an external clock or
   simply change the current frequency and last time-to-cycles snapshot. Units
   returned are nanoseconds.  For x86, we would also need to hook in the idle
   loop to monitor the "hlt" instruction. The goal here is to ensure that the
   returned time is within a controlled max delta from other CPUs. All this
   management is done with RCU synchronization.

> 
> >   - Export the faster trace clock to userspace for UST through a vDSO.
> 
> A new vDSO? This should be just a register_posix_clock and some
> glue in x86 vdso/ Makes sense to have, although I would prefer
> a per thread clock than a per CPU clock I think. But per CPU
> should be also fine.

I'm not sure I follow. In LTTng, we don't really care about having per-cpu time.
We want a fast and precise enough global clock. Extending the posix clock
possibly makes sense, although it would be important that the fast path is not
much more than a "rdtsc" instruction and a few tests.

> 
> > - Jump based on asm goto, which will minimize the impact of disabled
> >   tracepoints. (the patchset is being proposed by Jason Baron)
> 
> I think that is in progress.

Yes, it is.

> 
> BTW I'm still hoping that the old "self modifying booleans"
> patchkit will make it back at some point. I liked it as a general
> facility.

I still have it in the LTTng tree, although I stopped actively pusing it when
the static jump patching project started, because this project has all I need
for tracing. We can revisit the "Immediate Values" patches once I get the most
important tracing pieces in.

> 
> > - Kernel OOPS "lttng_nesting" level printout.
> 
> This sounds very optional.

Sure. That's more for my own peace of mind when I see OOPS coming from my users:
it tells me if the problem came from the Linux kernel per se or from my tracer.
It's been a while since I've seen my tracer cause any OOPS though.

> 
> 
> > Ftrace event header size is slightly better than
> > Perf, but its handling of time-stamps with respect to concurrency can
> > lead users to wrong results in terms of irq and softirq handler
> > duration. 
> 
> What is the problem with ftrace time stamps? They should 
> be all just per CPU? 

Ftrace uses both per-cpu (the "local" flavor) and "global" timestamps (it can
choose between the two depending on the tracing scope). So already it's either
fast and inaccurate, or globally accurate and painfully slow/non-scalable. But
the problem goes further: In the Ftrace ring buffer implementation, all nested
commits have zero time deltas, so in the following execution sequence:

trace_some_event()
  reserve ring buffer space and read trace clock (time = 10000000 ns)
  start to copy data into the buffer
  - nested interrupt comes in
    trace_some_other_event()
      reserve ring buffer space and read trace clock (time = 10000000 ns)
      copy data into ring buffer
      commit event
    execute softirq
    trace_yet_another_event()
      reserve ring buffer space and read trace clock (time = 10000000 ns)
      copy data into ring buffer
      commit event
    iret
  finish copying data
  commit event

So we end up having all events nested over the tracing code (including interrupt
handlers and softirqs) having a duration of exactly 0 ns. This is not really
convenient when we try to figure out things like the average duration of an
interrupt handler, longest/shorted handler duration, etc.

Thanks,

Mathieu


> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
