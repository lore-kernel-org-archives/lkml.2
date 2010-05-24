Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab0EXUN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 16:13:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59779 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab0EXUN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 16:13:56 -0400
X-Authority-Analysis: v=1.1 cv=ThiPuEJrAfM5PTlEgIT3cJp8+3pkHBIG3CaogqDGxqo= c=1 sm=0 a=jOljwp8wn3oA:10 a=GQCbJdZ--msA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=FyswP2SAAAAA:20 a=lX0pNLQDw8PexL8TjC8A:9 a=5K2oLiZsNvUa09PDahwA:7 a=N1I2skkw_Ux6DiTwpMENnwNZ6jYA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=Kz8HLbjuxK3CeO3w:21 a=RpznDMgqAt4lgdW0:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
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
In-Reply-To: <20100521174945.GA4404@elte.hu>
References: <1274291514.26328.930.camel@gandalf.stny.rr.com>
	 <20100520093131.GA30929@elte.hu>
	 <1274366318.26328.2292.camel@gandalf.stny.rr.com>
	 <20100521174945.GA4404@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 24 May 2010 16:13:47 -0400
Message-ID: <1274732027.22648.167.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 19:49 +0200, Ingo Molnar wrote: 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 

> > > The thing is, in tracing land and more broadly in 
> > > instrumentation land we have _much_ more earthly problems 
> > > these days:
> > > 
> > >  - Lets face it, performance of the ring-buffer sucks, in 
> > >    a big way. I've recently benchmarked it and it takes 
> > >    hundreds of instructions to trace a single event. 
> > >    Puh-lease ...
> > 
> > "Puh-lease"?
> 
> Yeah, we suck :-/

But the question is, do we want to suck more?

> 
> > Hmm, what were the timings?  I just ran the 
> > ring_buffer_benchmark module. It's in mainline, so 
> > anyone could do the same. [...]
> 
> i tested it with perf stat and got 700+ instructions for 
> the sched:sched_wakeup tracepoint.
> 
> That's without extracting the trace - that would add 
> another significant chunk of overhead.
> 
> Btw., it's not just ftrace, on the perf side i see big 
> tracing overhead as well, it's even worse than this 
> because we layer it on each other and because perf does a 
> few stupid things (that need fixing).

But this has nothing to do with the ring buffer. It has to do with the
way the trace event itself is set up. There's little room for
improvement if we want to keep things automated. Otherwise, all trace
events will need to be written by us, or make all writers of
TRACE_EVENT() into tracing experts.

The beauty of TRACE_EVENT() was to make it simple enough that anyone
could add one without needing to know the details of how it appears.

The are also flexible enough to have in kernel users attach directly to
them.


[coming back up after reading below ]

Did you test only the event 
"echo 1 > /debug/tracing/event/sched/sched_wakeup" or did you only do it
in conjunction with the sched_switch tracer?

> 
> > [...] Remember to disable KERNEL_DEBUG because things 
> > like lockdep can have a significant impact on it.
> 
> I had lockdep off.
> 
> > Note, instructions themselves are not that bad, but what 
> > those instructions do count a lot more. I avoid all lock 
> > functions and memory barriers which cause the code to be 
> > a little bigger. But a single cmpxchg can take much more 
> > time than a lot of other instructions put together.
> 
> It's bad cycle-wise as well and obviously running through 
> 700 instructions is bad no matter what.
> 
> > On this machine:
> > 
> > model name	: Intel(R) Core(TM)2 Quad  CPU   Q9450  @ 2.66GHz
> > 
> > It's a 2x2 (4 cores)
> > 
> > With running:
> > 
> > # modprobe ring_buffer_benchmark producer_fifo=10
> > # sleep 30
> > # cat /debug/tracing/trace
> > 
> > 
> >            <...>-2636  [003]   761.969850: ring_buffer_producer_thread: Starting ring buffer hammer
> >            <...>-2636  [003]   771.910121: ring_buffer_producer_thread: End ring buffer hammer
> >            <...>-2636  [003]   771.910172: ring_buffer_producer_thread: Running Consumer at nice: 19
> >            <...>-2636  [003]   771.910172: ring_buffer_producer_thread: Running Producer at SCHED_FIFO 10
> >            <...>-2636  [003]   771.910173: ring_buffer_producer_thread: Time:     9965321 (usecs)
> >            <...>-2636  [003]   771.910173: ring_buffer_producer_thread: Overruns: 0
> >            <...>-2636  [003]   771.910174: ring_buffer_producer_thread: Read:     76580325  (by pages)
> >            <...>-2636  [003]   771.910175: ring_buffer_producer_thread: Entries:  75
> >            <...>-2636  [003]   771.910175: ring_buffer_producer_thread: Total:    76580400
> >            <...>-2636  [003]   771.910175: ring_buffer_producer_thread: Missed:   0
> >            <...>-2636  [003]   771.910176: ring_buffer_producer_thread: Hit:      76580400
> >            <...>-2636  [003]   771.910176: ring_buffer_producer_thread: Entries per millisec: 7684
> >            <...>-2636  [003]   771.910176: ring_buffer_producer_thread: 130 ns per entry
> >            <...>-2636  [003]   771.910177: ring_buffer_producer_thread: Sleeping for 10 secs
> > 
> >            <...>-2636  [003]   781.884686: ring_buffer_producer_thread: Starting ring buffer hammer
> >            <...>-2636  [003]   790.862392: ring_buffer_producer_thread: End ring buffer hammer
> >            <...>-2636  [003]   790.897399: ring_buffer_producer_thread: Running Consumer at nice: 19
> >            <...>-2636  [003]   790.897400: ring_buffer_producer_thread: Running Producer at SCHED_FIFO 10
> >            <...>-2636  [003]   790.897401: ring_buffer_producer_thread: Time:     9000321 (usecs)
> >            <...>-2636  [003]   790.897401: ring_buffer_producer_thread: Overruns: 26581200
> >            <...>-2636  [003]   790.897402: ring_buffer_producer_thread: Read:     6767200  (by events)
> >            <...>-2636  [003]   790.897403: ring_buffer_producer_thread: Entries:  0
> >            <...>-2636  [003]   790.897403: ring_buffer_producer_thread: Total:    33348400
> >            <...>-2636  [003]   790.897403: ring_buffer_producer_thread: Missed:   0
> >            <...>-2636  [003]   790.897404: ring_buffer_producer_thread: Hit:      33348400
> >            <...>-2636  [003]   790.897404: ring_buffer_producer_thread: Entries per millisec: 3705
> >            <...>-2636  [003]   790.897405: ring_buffer_producer_thread: 269 ns per entry
> > 
> > While having the reader read by pages (splice mode) a 
> > write takes 130ns per entry. Not that bad.
> 
> I tried a simple loop of:
> 
> int main(void)
> {
>         int i;
> 
>         for (i = 0; i < 1000000; i++)
>                 getppid();
> 
>         return 0;
> }
> 
> with kernel/timer.c's getppid syscall having this:
> 
> #undef CREATE_TRACE_POINTS
> #include <trace/events/sched.h>
> 
> SYSCALL_DEFINE0(getppid)
> ...
> 	trace_sched_wakeup(current, 0);
> 
> and then used:
> 
>    echo 1 > /debug/tracing/events/sched/sched_wakeup/enable
>    echo sched_switch > /debug/tracing/current_tracer

This is not fair, you just enabled two probes, not just one. There's the
sched_wakeup generic event "/debug/tracing/events/sched/sched_wakeup"
and the sched_switch tracer that adds its own probe. Thus, the
trace_sched_wakeup() calls two probes each time.

Have you seen the code for the probe of sched_switch tracer's
trace_sched_wakeup?  What you did will cause the getppid to call both
the generic TRACE_EVENT() probe as well as the sched_switch attached
probe.

Here is the sched_switch sched_wakeup probe:


static void
probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee, int success)
{
	struct trace_array_cpu *data;
	unsigned long flags;
	int cpu, pc;

	if (unlikely(!sched_ref))
		return;

	tracing_record_cmdline(current);

	if (!tracer_enabled || sched_stopped)
		return;

	pc = preempt_count();
	local_irq_save(flags);
	cpu = raw_smp_processor_id();
	data = ctx_trace->data[cpu];

	if (likely(!atomic_read(&data->disabled)))
		tracing_sched_wakeup_trace(ctx_trace, wakee, current,
					   flags, pc);

	local_irq_restore(flags);
}


It also disables interrupts, but lets look at some of the functions it
calls:

void tracing_record_cmdline(struct task_struct *tsk)
{
	if (atomic_read(&trace_record_cmdline_disabled) || !tracer_enabled ||
	    !tracing_is_on())
		return;

	trace_save_cmdline(tsk);
}

static void trace_save_cmdline(struct task_struct *tsk)
{
	unsigned pid, idx;

	if (!tsk->pid || unlikely(tsk->pid > PID_MAX_DEFAULT))
		return;

	/*
	 * It's not the end of the world if we don't get
	 * the lock, but we also don't want to spin
	 * nor do we want to disable interrupts,
	 * so if we miss here, then better luck next time.
	 */
	if (!arch_spin_trylock(&trace_cmdline_lock))
		return;

	idx = map_pid_to_cmdline[tsk->pid];
	if (idx == NO_CMDLINE_MAP) {
		idx = (cmdline_idx + 1) % SAVED_CMDLINES;

		/*
		 * Check whether the cmdline buffer at idx has a pid
		 * mapped. We are going to overwrite that entry so we
		 * need to clear the map_pid_to_cmdline. Otherwise we
		 * would read the new comm for the old pid.
		 */
		pid = map_cmdline_to_pid[idx];
		if (pid != NO_CMDLINE_MAP)
			map_pid_to_cmdline[pid] = NO_CMDLINE_MAP;

		map_cmdline_to_pid[idx] = tsk->pid;
		map_pid_to_cmdline[tsk->pid] = idx;

		cmdline_idx = idx;
	}

	memcpy(&saved_cmdlines[idx], tsk->comm, TASK_COMM_LEN);

	arch_spin_unlock(&trace_cmdline_lock);
}

The above is grabbing a spinlock!


tracing_sched_wakeup_trace(struct trace_array *tr,
			   struct task_struct *wakee,
			   struct task_struct *curr,
			   unsigned long flags, int pc)
{
	struct ftrace_event_call *call = &event_wakeup;
	struct ring_buffer_event *event;
	struct ctx_switch_entry *entry;
	struct ring_buffer *buffer = tr->buffer;

	event = trace_buffer_lock_reserve(buffer, TRACE_WAKE,
					  sizeof(*entry), flags, pc);
	if (!event)
		return;
	entry	= ring_buffer_event_data(event);
	entry->prev_pid			= curr->pid;
	entry->prev_prio		= curr->prio;
	entry->prev_state		= curr->state;
	entry->next_pid			= wakee->pid;
	entry->next_prio		= wakee->prio;
	entry->next_state		= wakee->state;
	entry->next_cpu			= task_cpu(wakee);

	if (!filter_check_discard(call, entry, buffer, event))
		ring_buffer_unlock_commit(buffer, event);
	ftrace_trace_stack(tr->buffer, flags, 6, pc);
	ftrace_trace_userstack(tr->buffer, flags, pc);
}


This has little to do with the ring buffer, or the way ftrace does
events. It can certainly be made faster, but wakeups are rather rare
(compared to other events that are traced).




> 
>    perf stat --repeat 10 -e instructions -e cycles ./getppid-1m
> 
> with the tracepoint off i got:
> 
>  # perf stat -B --repeat 10 -e instructions -e cycles ./getppid-1m
> 
>  Performance counter stats for './getppid-1m' (10 runs):
> 
>          89.700.970  instructions             #      0,614 IPC     ( +-   0,146% )
>         146.204.088  cycles                     ( +-   1,160% )
> 
>         0,046142868  seconds time elapsed   ( +-   1,200% )
> 
> 
> with it on i got:
> 
>  # perf stat -B --repeat 10 -e instructions -e cycles ./getppid-1m
> 
>  Performance counter stats for './getppid-1m' (10 runs):
> 
>       1.241.321.592  instructions             #      1,617 IPC     ( +-   0,054% )
>         767.890.685  cycles                     ( +-   1,298% )
> 
>         0,241048084  seconds time elapsed   ( +-   1,288% )
> 
> 
> i.e. from 89 instructions to 1241 instructions. From 146 
> cycles to 767 cycles.

But you enabled sched_switch too, right? That would cause two probes to
execute, and one is a lot bigger than the other.

> 
> And that's just the recording - doesnt count the 
> recovering of the trace. (which can argued to be a 
> slowpath in many tracing workflows when buffers are big 
> enough.)

But still, you inflated the numbers by enabling the sched_switch tracer.

> 
> Nehalem box. Can send the config.
> 
> > But when the reader is reading each event, (I'm assuming 
> > we get some cache line bouncing here, it is still 
> > lockless), a write takes 269ns.
> 
> That would be like 800 cycles? So it's roughly the same 
> ballpark figure as mine - we suck. (this is a 3GHz box)

That was with an aggressive reader, which even though it is lockless,
the reader is still dirtying the writer's cache lines.

> 
> > Note, the reader is an aggressive reader. That is, it 
> > goes into a strong loop and just reads as fast as it 
> > can. Which would cause cache line bouncing.
> > 
> > When I disable the reader and just measure what a write 
> > takes:
> > 
> > # rmmod ring_buffer_benchmark
> > # modprobe ring_buffer_benchmark disable_reader=1 producer_fifo=10
> > # sleep 30
> > # cat /debug/tracing/trace
> > 
> >            <...>-2649  [003]  1141.981639: ring_buffer_producer_thread: Starting ring buffer hammer
> >            <...>-2649  [003]  1151.950840: ring_buffer_producer_thread: End ring buffer hammer
> >            <...>-2649  [003]  1151.950841: ring_buffer_producer_thread: Running Producer at SCHED_FIFO 10
> >            <...>-2649  [003]  1151.950842: ring_buffer_producer_thread: Time:     9994238 (usecs)
> >            <...>-2649  [003]  1151.950842: ring_buffer_producer_thread: Overruns: 90635670
> >            <...>-2649  [003]  1151.950843: ring_buffer_producer_thread: Read:     (reader disabled)
> >            <...>-2649  [003]  1151.950843: ring_buffer_producer_thread: Entries:  62480
> >            <...>-2649  [003]  1151.950844: ring_buffer_producer_thread: Total:    90698150
> >            <...>-2649  [003]  1151.950844: ring_buffer_producer_thread: Missed:   0
> >            <...>-2649  [003]  1151.950844: ring_buffer_producer_thread: Hit:      90698150
> >            <...>-2649  [003]  1151.950845: ring_buffer_producer_thread: Entries per millisec: 9075
> >            <...>-2649  [003]  1151.950845: ring_buffer_producer_thread: 110 ns per entry
> >            <...>-2649  [003]  1151.950846: ring_buffer_producer_thread: Sleeping for 10 secs
> > 
> > It takes just a 110ns.
> 
> I dont seem to be able to get such low numbers

Well, don't run the sched_switch tracer ;-)

> - but even 
> ~250 instructions are pretty expensive.


That bench mark only tested the ring buffer by allocating its own ring
buffer. It did not use the ftrace infrastructure. I tried to do the same
with perf but gave up because of the limitations of the perf ring
buffer.


> 
> > Lets now use perf to see what is happening:
> > 
> > # perf record -a -c10000 -f
> > (wait 30 secs)
> > Ctrl-C
> > 
> > # perf report
> > 
> > no symbols found in /usr/sbin/irqbalance, maybe install a debug package?
> > # Samples: 1995496
> > #
> > # Overhead          Command                                                     Shared Object  Symbol
> > # ........  ...............  ................................................................  ......
> > #
> >     23.80%      rb_producer  [kernel.kallsyms]                                                 [k] native_sched_clock
> >     14.83%      rb_producer  [kernel.kallsyms]                                                 [k] rb_reserve_next_event
> >     13.20%      rb_producer  [kernel.kallsyms]                                                 [k] ring_buffer_unlock_commit
> >     12.84%      rb_producer  [kernel.kallsyms]                                                 [k] ring_buffer_lock_reserve
> >      9.27%      rb_producer  [kernel.kallsyms]                                                 [k] rb_end_commit
> >      9.19%      rb_producer  [kernel.kallsyms]                                                 [k] __rb_reserve_next
> >      5.24%      rb_producer  [kernel.kallsyms]                                                 [k] trace_clock_local
> >      3.11%      rb_producer  [kernel.kallsyms]                                                 [k] ring_buffer_event_data
> >      2.88%      rb_producer  [ring_buffer_benchmark]                                           [k] ring_buffer_benchmark_init
> >      2.53%      rb_producer  [kernel.kallsyms]                                                 [k] trace_recursive_unlock
> >      0.39%      rb_producer  [kernel.kallsyms]                                                 [k] do_gettimeofday
> >      0.34%      rb_producer  [kernel.kallsyms]                                                 [k] read_tsc
> >      0.18%      rb_producer  [kernel.kallsyms]                                                 [k] getnstimeofday
> >      0.14%          swapper  [kernel.kallsyms]                                                 [k] mwait_idle
> > 
> > 
> > Now that the sched_clock is %23.8 percent, it doesn't 
> > look as bad.
> > 
> > rb_reserve_next_event is 14.83, 
> > ring_buffer_unlock_commit is 13.20, 
> > ring_buffer_lock_reserve is 12.84, rb_end_commit is 
> > 9.27, __rb_reserve_next is 8.18, trace_clock_local is 
> > 5.24 (which only disables preemption and calls 
> > sched_clock), ring_buffer_event_data is 3.11 which only 
> > returns a pointer on a structure (once a event).
> > 
> > ring_buffer_benchmark_init is the benchmark code itself, 
> > and trace_recursive_unlock is the code you asked me to 
> > add to check for cases where the tracer could have 
> > recursed itself.
> > 
> > 14.83 + 13.20 + 9.27 + 8.18 + 5.24 + 3.11 = 53.83%
> > 
> > Considering that the system is basically idle except for 
> > this benchmark, that makes sense to have it that high. 
> > We need to compare it. The sched_clock() takes up 1/3 of 
> > the entire trace event.
> 
> Should be better on my box, which has a usable TSC and my 
> sched_clock() is in essence an RDTSC.

Hmm, this box does have an unstable TSC, but doesn't sched_clock still
do rdtsc?

> 
> 
> > >  - It has grown a lot of slack. It's complex and hard to
> > >    read.
> > 
> > I admit, that it got over designed, and I'm all for 
> > replacing it. We were all involved in the initial 
> > design, [...]
> 
> Yes, by implication i definitely suck too, no argument 
> about that :-)
> 
> > [...] and I posted several versions of RFC when I 
> > created it. But I admit, it became complex, and now that 
> > we know what we want, we can take a step back and 
> > redesign a new one from scratch.
> > 
> > But until we do so, I'm continuing to support the 
> > current one, and adding small updates when needed.
> > 
> > > 
> > >  - Over the last year or so the majority of bleeding-edge
> > >    tracing developers have gradually migrated over to perf 
> > >    and 'perf trace' / 'perf probe' in particular. As far 
> > >    as the past two merge windows go they are 
> > >    out-developing the old ftrace UIs by a ratio of 4:1.
> > 
> > Of course a new project will be in a high state of flux. 
> > I'm quite satisfied with the interface with ftrace and 
> > did not feel that it needed changing.
> > 
> > > 
> > >    So this angle is becoming a prime thing to improve and
> > >    users and developers are hurting from the ftrace/perf
> > >    duality.
> > 
> > I agree.
> > 
> > > 
> > >  - [ While it's still a long way off, if this trend continues
> > >      we eventually might even be able to get rid of the 
> > >      /debug/tracing/ temporary debug API and get rid of 
> > >      the ugly in-kernel pretty-printing bits. This is 
> > >      good: it may make Andrew very happy for a change ;-)
> > 
> > So how do you plan on getting rid of the in-kernel 
> > pretty-printing bits and keeping the trace_dump_on_oops?  
> > There's a strong dependency between those two.
> 
> One approach would be to add a library that can turn the 
> specification into a pretty-print output - say in 
> tools/perf/lib/printlib/ (or lib/printlib/), and co-build 
> it both in perf and in the kernel.

Not sure how this would work. But wouldn't this be a nightmare for
package developers? What about other tools that use the perf interface.
You allow them right?

An ideal world, the kernel should have an awesome tracing infrastructure
that several tools could use.

> 
> That way we get most of the pretty-printing functionality 
> at oops (or critical event) time, but have it in a 
> manageable form.
> 
> > >      The main detail here to be careful of is that lots of
> > >      people are fond of the simplicity of the 
> > >      /debug/tracing/ debug UI, so when we replace it we 
> > >      want to do it by keeping that simple workflow (or 
> > >      best by making it even simpler). I have a few ideas 
> > >      how to do this.
> > 
> > Note, I still would not want to remove the /debug 
> > interface. It is a debug interface anyway. Having both a 
> > syscall access the functionality of the code and having 
> > a debug interface access it very trivial. This could 
> > also be a way we can debug the tool too.
> > 
> > We can officially support only the tool side, but why 
> > throw away the baby with the bath water?
> 
> As long as we declare it to go away the moment we have 
> something equivalent or better on the 'perf ftrace' / 
> 'ftrace' tool side, sure.
> 
> I worry about what Andrew mentioned a few months (years?) 
> ago: unintentional ABI tool bindings to /debug/tracing, 
> just due to us offering it.

Well, it is in the /debug fs. Depending on something called "debug" is
always a risk.

> 
> We want to gravitate towards offering one superb solution 
> for all the tracing goodies we've built and are going to 
> build.

Right, and lets make it so any utility could bind to it and perform
well.


> 
> 
> > >      There's also the detail that in some cases we want to
> > >      print events in the kernel in a human readable way: 
> > >      for example EDAC/MCE and other critical events,
> > >      trace-on-oops, etc. This too can be solved. ]
> > 
> > But if the code for trace-on-oops is there, then the 
> > pretty print code is also there.
> 
> Not if we share it with the user-space tool (in a generic 
> way) and drive it from the user-space side, not the kernel 
> side.
> 
> The executable instructions will still be there in the 
> kernel, for those relatively rare cases that need it (lets 
> face it, the usage proportion between ordinary tracing and 
> dump-on-oops is probably 1:100 or worse).


But there should be a system wide tracing, that would most likely be
used within the kernel. This would require a global buffer and a way to
write to (and read from) in the kernel.


> 
> > > Regarding performance and complexity, which is our 
> > > main worry atm, fortunately there's work going on in 
> > > that direction - please see PeterZ's recent string of 
> > > patches on lkml:
> > > 
> > >   4f41c01: perf/ftrace: Optimize perf/tracepoint interaction for single events
> > >   a19d35c: perf: Optimize buffer placement by allocating buffers NUMA aware
> > >   ef60777: perf: Optimize the perf_output() path by removing IRQ-disables
> > >   fa58815: perf: Optimize the hotpath by converting the perf output buffer to local_t
> > >   6d1acfd: perf: Optimize perf_output_*() by avoiding local_xchg()
> > 
> > Yes, I saw these, and it helps a little, but still not everything is
> > there.
> 
> Most definitely. We still suck :-)
> 
> > > And it may sound harsh but at this stage i'm 
> > > personally not at all interested in big design talk.
> > 
> > Rewriting ftrace on top of perf is a big design change.
> 
> Yeah, and a pretty rewarding one.
> 
> > > This isnt rocket science, we have developers and users 
> > > and we know what they are doing and we know what we 
> > > need to do: we need to improve our crap and we need to 
> > > reduce complexity. Less is more.
> > > 
> > > So i'd like to see iterative, useful action first, and 
> > > i am somewhat sceptical about yet another grand 
> > > tracing design trying to match 100 requirements.
> > 
> > Here's a few things that I find required:
> > 
> > The ability to use splice. You keep telling me this is 
> > not important, but splice is magnitudes faster than 
> > mmaping into userspace and then copying into a file. 
> > [...]
> 
> That claim i find hard to believe, have you got the 
> numbers for that?

Well, it's hard to compare since perf does only mmap, and trace-cmd does
only splice. But I can compare the two, although the way things are done
differently, which affect the results.

In my email I showed how I tested both perf and ftrace, by using the one
common denominator of both: TRACE_EVENT(). I modified the
ring_buffer_benchmark to test the time it takes to call a simple event.
I showed what I did in the previous email. This takes a look at how both
ftrace and perf handles events.

I just tested both perf and trace-cmd against 2.6.34 and latest
tip/perf/core. Here's the results I have:

On vanilla 2.6.34:

[root@ixf9 linux-trace.git]# perf record -c1 -e rb_bench:rb_benchmark  -a sleep 60
[ perf record: Woken up 62 times to write data ]
[ perf record: Captured and wrote 1031.015 MB perf.data (~45045722 samples) ]

>From console:
-------------
wait to start
starting
Starting ring buffer hammer
End ring buffer hammer
Running Producer at SCHED_FIFO 10
Time:     9603958 (usecs)
Overruns: 0
Read:     (reader disabled)
Entries:  0
Total:    0
Missed:   0
Hit:      11041600
Entries per millisec: 1149
870 ns per entry
Sleeping for 10 secs
wait to start
starting
Starting ring buffer hammer
End ring buffer hammer
Running Producer at SCHED_FIFO 10
Time:     9973544 (usecs)
Overruns: 0
Read:     (reader disabled)
Entries:  0
Total:    0
Missed:   0
Hit:      11518850
Entries per millisec: 1155
865 ns per entry
Sleeping for 10 secs
wait to start
starting
Starting ring buffer hammer
End ring buffer hammer
Running Producer at SCHED_FIFO 10
Time:     9973545 (usecs)
Overruns: 0
Read:     (reader disabled)
Entries:  0
Total:    0
Missed:   0
Hit:      10900500
Entries per millisec: 1093
914 ns per entry
Sleeping for 10 secs

[root@ixf9 linux-trace.git]# perf trace | grep rb_producer | wc -l
16495123


[root@ixf9 linux-trace.git]# trace-cmd record -b 512 -s10 -e rb_bench:rb_benchmark sleep 60
disable all
enable rb_bench:rb_benchmark
path = /debug/tracing/events/rb_bench/rb_benchmark/enable
offset=163000
offset=163000
offset=47a5e000
offset=47a5e000
Kernel buffer statistics:
  Note: "entries" are the entries left in the kernel ring buffer and are not
        recorded in the trace data. They should all be zero.

CPU: 0
entries: 0
overrun: 0
commit overrun: 0

CPU: 1
entries: 0
overrun: 102010404
commit overrun: 0

CPU: 2
entries: 0
overrun: 0
commit overrun: 0

CPU: 3
entries: 0
overrun: 0
commit overrun: 0



>From console:
-------------
wait to start
starting
Starting ring buffer hammer
End ring buffer hammer
Running Producer at SCHED_FIFO 10
Time:     9162808 (usecs)
Overruns: 0
Read:     (reader disabled)
Entries:  0
Total:    0
Missed:   0
Hit:      49703550
Entries per millisec: 5424
184 ns per entry
Sleeping for 10 secs
wait to start
starting
Starting ring buffer hammer
End ring buffer hammer
Running Producer at SCHED_FIFO 10
Time:     9973570 (usecs)
Overruns: 0
Read:     (reader disabled)
Entries:  0
Total:    0
Missed:   0
Hit:      54054950
Entries per millisec: 5420
184 ns per entry
Sleeping for 10 secs
wait to start
starting
Starting ring buffer hammer
End ring buffer hammer
Running Producer at SCHED_FIFO 10
Time:     9973501 (usecs)
Overruns: 0
Read:     (reader disabled)
Entries:  0
Total:    0
Missed:   0
Hit:      53908300
Entries per millisec: 5405
185 ns per entry
Sleeping for 10 secs

[root@ixf9 linux-trace.git]# trace-cmd report | grep rb_producer | wc -l
59795170


[root@ixf9 linux-trace.git]# ls -l perf.data trace.dat 
-rw-------  1 root root 1082104985 2010-05-24 12:05 perf.data
-rw-r--r--. 1 root root 1202053120 2010-05-24 12:10 trace.dat


On latest tip/perf/core:

commit d67f088e084755bdceb4f15bc6e05e309db1eea7
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Sun May 23 22:36:51 2010 -0300

    perf report: Support multiple events on the TUI


[root@ixf9 linux-trace.git]# perf record -c1 -e rb_bench:rb_benchmark  -a sleep 60
[ perf record: Woken up 394 times to write data ]
[ perf record: Captured and wrote 1093.414 MB perf.data (~47771989 samples) ]


>From console:
-------------
wait to start
starting
Starting ring buffer hammer
End ring buffer hammer
Running Producer at SCHED_FIFO 10
Time:     9514214 (usecs)
Overruns: 0
Read:     (reader disabled)
Entries:  0
Total:    0
Missed:   0
Hit:      19149150
Entries per millisec: 2012
497 ns per entry
Sleeping for 10 secs
wait to start
starting
Starting ring buffer hammer
End ring buffer hammer
Running Producer at SCHED_FIFO 10
Time:     9972824 (usecs)
Overruns: 0
Read:     (reader disabled)
Entries:  0
Total:    0
Missed:   0
Hit:      20701150
Entries per millisec: 2075
481 ns per entry
Sleeping for 10 secs
wait to start
starting
Starting ring buffer hammer
End ring buffer hammer
Running Producer at SCHED_FIFO 10
Time:     9972802 (usecs)
Overruns: 0
Read:     (reader disabled)
Entries:  0
Total:    0
Missed:   0
Hit:      20365250
Entries per millisec: 2042
489 ns per entry
Sleeping for 10 secs

[root@ixf9 linux-trace.git]# perf trace | grep rb_producer | wc -l
17694461


[root@ixf9 linux-trace.git]# trace-cmd record -b 512 -s10 -e rb_bench:rb_benchmark sleep 60
disable all
enable rb_bench:rb_benchmark
path = /debug/tracing/events/rb_bench/rb_benchmark/enable
offset=15d000
offset=15d000
offset=343b2000
offset=343b2000
Kernel buffer statistics:
  Note: "entries" are the entries left in the kernel ring buffer and are not
        recorded in the trace data. They should all be zero.

CPU: 0
entries: 0
overrun: 0
commit overrun: 0

CPU: 1
entries: 0
overrun: 63560076
commit overrun: 0

CPU: 2
entries: 0
overrun: 0
commit overrun: 0

CPU: 3
entries: 0
overrun: 31949460
commit overrun: 0


>From console:
-------------
wait to start
starting
Starting ring buffer hammer
End ring buffer hammer
Running Producer at SCHED_FIFO 10
Time:     9461863 (usecs)
Overruns: 0
Read:     (reader disabled)
Entries:  0
Total:    0
Missed:   0
Hit:      50454750
Entries per millisec: 5332
187 ns per entry
Sleeping for 10 secs
wait to start
starting
Starting ring buffer hammer
End ring buffer hammer
Running Producer at SCHED_FIFO 10
Time:     9972793 (usecs)
Overruns: 0
Read:     (reader disabled)
Entries:  0
Total:    0
Missed:   0
Hit:      54203850
Entries per millisec: 5435
183 ns per entry
Sleeping for 10 secs
wait to start
starting
Starting ring buffer hammer
End ring buffer hammer
Running Producer at SCHED_FIFO 10
Time:     9972746 (usecs)
Overruns: 0
Read:     (reader disabled)
Entries:  0
Total:    0
Missed:   0
Hit:      53295900
Entries per millisec: 5344
187 ns per entry
Sleeping for 10 secs


[root@ixf9 linux-trace.git]# trace-cmd report | grep rb_producer | wc -l
65393428


[root@ixf9 linux-trace.git]# ls -l perf.data trace.dat 
-rw-------  1 root root 1147509728 2010-05-24 12:56 perf.data
-rw-r--r--. 1 root root 1314439168 2010-05-24 13:01 trace.dat



In vanilla 2.6.34 we have:

perf:  865ns - 914ns per event
ftrace: 184ns - 185ns per event

events recorded to file:

perf: 16,495,123 events
trace-cmd: 59,795,170 events

file size:

perf: 1,082,104,985 bytes
ftrace: 1,202,053,120 bytes

which gives us:

perf: ~65 bytes per event
ftrace: ~20 bytes per event



That was vanilla, now lets look at the results with all the latest
optimizations. This has improved things in perf:


In lastest tip/perf/core we have:

perf:  497ns - 489ns per event
ftrace: 187ns per event

events recorded to file:

perf: 17,694,461 events
trace-cmd: 65,393,428 events

file size:

perf: 1,147,509,728 bytes
trace-cmd: 1,314,439,168 bytes

which gives us:

perf: ~64 bytes per event
ftrace: ~20 bytes per event


Looks like Peter's lastest optimizations have cut the time to do a perf
trace event almost in half. But it is still 2 1/2 times longer to do a
perf event than a ftrace event.


But I noticed that even though perf is recording events faster, the
number of events that were saved to file hardly changed at all. Which
means the reader is still a bottle neck for both cases.

I use to think that ftrace had bloated events, but perf triples the size
of each event. Perhaps this is also part of the reason perf events are
so slow.


> 
> It's faster for sure if implemented correctly, but i'd be 
> surprised if it made more than 20% of a difference to the 
> total tracing overhead.

It's hard to compare since there's so many variables. trace-cmd recorded
~13% more file than perf. But unless we can compare straight mmap vs
splice, I still take this with a grain of salt.


> 
> > [...] If the splice removes the extra copy as we are 
> > working on, it will get even faster. It also makes 
> > writing over the network much easier. Which trace-cmd 
> > does, and it took me half a day to make it do so.
> > 
> > We also need a way to easily read the buffer from the 
> > kernel. This is for trace-on-oops.
> > 
> > Overwrite mode must also be supported. I know that Peter 
> > thinks its silly to do this and have it write to a file, 
> > but I find it helpful to do so. But fine, I can live 
> > without overwrite to a file, if no one else cares. But 
> > overwrite mode itself must work for trace-on-oops.
> 
> We can do overwrite mode, it doesnt look like a central 
> issue.
> 
> I'm sure we'll find a dozen other things missing as well. 
> We have to start looking.
> 
> > We need a way to start and stop tracing from the kernel 
> > and userspace. Again, for trace-on-oops. When a bug is 
> > hit, we need a way to stop it. We also must have a way 
> > to easily start it again from userspace.
> > 
> > A simple on/off switch. This is something that you and 
> > Thomas hammered into me which was the creation of 
> > tracing_on.
> > 
> > The above can be done, but lets not just hack the 
> > changes in. Lets really look at a proper design.
> 
> This kind of capability would be met by persistent events 
> attached to struct user.
> 
> We have to start looking and doing.
> 
> > > Steve, Mathieu, if you are interested please help out 
> > > Peter with the performance and simplification work. 
> > > The last thing we need is yet another 
> > > replace-everything event.
> > 
> > But that is what you are asking to happen to ftrace. 
> > "replace-everything".
> 
> We've got two ring-buffer implementations right now, one 
> has to be replaced.

And you seem to be asking to replace the more efficient one.

I admit that my ring buffer can be replaced due to its complexity, but
perf needs a major face lift in its buffering scheme to keep up as a
competitive tracer.

> 
> It doesnt mean we should disrupt _two_ implementations and 
> put in a third one, unless there are strong technical 
> reasons for doing so.

But we have to disrupt perf anyway to make it come close to what ftrace
does today.

Since neither of the buffers seem to satisfy the other's requirements
then perhaps that's the best thing to do. Replace both of them.

I have yet to see that perf's ring buffer is any better than ftrace's.
On the contrary, the performance looks worse. Each time we add a
feature, it gets more complex, and the final result of the perf ring
buffer may end up being slower and more complex than the ftrace one.

I can't see hacking in changes to the perf ring buffer trying to make it
work. Perhaps the best thing to do is redesign it, start from scratch.
I'm willing to let the ftrace ring buffer be redesigned, why can't we do
that to perf as well, and merge the two utilities as we do it?

Lets start with a good design instead of just patching the current
design trying to make it work. That is what the O(1) scheduler suffered
from. Too many, "let's try this" hacks to fix inefficiencies. Replacing
it with a new design was the proper approach.


> 
> > > If we really want to create a new ring-buffer 
> > > abstraction i'd suggest we start with Peter's, it has 
> > > a quite sane design and stayed simple and flexible - 
> > > if then it could be factored out a bit.
> > 
> > I'm sorry, but it is very coupled with perf. [...]
> 
> Then decouple it.

I don't understand the coupling between perf and its ring buffer enough
to do it. I just tried to make it work with the ring_buffer_benchmark
and it became much more involved than I would like. It would require
Peter and/or Frederic to do this work.


> 
> > [...] It is simple and flexible with what perf does 
> > today, but not what ftrace does today, or to make perf 
> > do what ftrace does.
> 
> Why? Neither overwrite mode, nor splice support, nor 
> persistent buffering looks hard at all.

I tried to make it work by itself in the ring buffer benchmark. But it I
gave up because it is so coupled with perf's user interface.

1) I had no idea how to create a separate buffer. 

2) I had no idea how to read the buffer from the kernel.

I'm sure I can figure these out if I had the time, but I don't.


> 
> > > Here are more bits of what i see as the 'action' going 
> > > forward, in no particular order:
> > > 
> > > 1) Push the /debug/tracing/events/ event description
> > >    into sysfs, as per this thread on lkml:
> > > 
> > >      [RFC][PATCH v2 06/11] perf: core, export pmus via sysfs
> > > 
> > >      http://groups.google.com/group/linux.kernel/msg/ab9aa075016c639e
> > > 
> > >    I.e. one more step towards integrating ftrace into perf.
> > 
> > We could do something like this, but it is not as 
> > trivial as it may seem.
> 
> Never is.

Right, and moving perf to splice/overwrite/etc, is not going to be as
easy as you believe it will.

> 
> > > 2) Use 1) to unify the perf events and the ftrace
> > >    ring-buffer. This, as things are standing is
> > >    best done by factoring out Peter's ring-buffer
> > >    in kernel/perf_event.c. It's properly abstracted
> > >    and it _far_ simpler than kernel/tracing/ring_buffer.c,
> > >    which has become a monstrosity.
> > 
> > Sure, my code has become quite complex, I'll admit that. 
> > I'm for refactoring. I really don't care what code is 
> > used as long as I still have the requirements that make 
> > ftrace useful for me and several others.
> > 
> > And yes, any ring buffer needs to be factored out to a 
> > defined interface. The current ring buffer in perf is 
> > very coupled with the perf design. The event code 
> > written to perf in include/trace/ftrace.h is still quite 
> > a hack.
> 
> Then lets make it less of a hack.

Agreed, lets redesign it :-)

> 
> > >    (but i'm open to other simplifications as well)
> > > 
> > > 3) Add the function-tracer and function-graph tracer
> > >    as an event and integrate it into perf.
> > 
> > Here's something that I think perf needs to do. It needs 
> > to become a bit more modulized, and not absorb 
> > everything into perf instead of having things use just a 
> > part of perf. Like the breakpoint code requires full 
> > perf to be done, and x86 has PERF_EVENTS permanently on. 
> > Which is really a PITA.
> 
> the Kconfig rule should be fixed so that PERF_EVENTS can 
> be disabled on EMBEDDED.
> 
> On non-embedded, why is it a PITA?

It was a PITA for me since I was not able to test !PERF_EVENTS generic
changes on x86.

> 
> > As I designed ftrace from day one, I tried to make it 
> > modular. Thus, the function trace 
> > (kernel/trace/ftrace.c) has always been a separate 
> > entity from ftrace itself. Heck, LTTng uses it. It would 
> > be actually trivial to implement the function tracer in 
> > perf today. Just register a function you want called at 
> > every function event and start running.
> 
> Here i disagree: the last thing Linux needs is various 
> fragmented pieces of instrumentation.
> 
> We try hard with perf to unify. It takes time but has to 
> happen.

I'm all for making it unified, it is that I do not want to have to learn
every aspect of perf just to change part of it. Or perhaps there's
another subsystem where it could use a part of perf nicely. This is
difficult to do with its design today.

> 
> > I need to abstract out the "what function to call bit" 
> > but that's about it.
> > 
> > > 
> > >    This will live-test the efficiency of the unification
> > >    and brings over the last big ftrace plugin to perf.
> > > 
> > > 4) Gradually convert/port/migrate all the remaining 
> > >    plugins over as well. We need to do this very gently 
> > >    because there are users - but stop piling new 
> > >    functionality on to the old ftrace side. This usually 
> > >    involves:
> > 
> > I have not been piling functionality into the ftrace 
> > side, as you stated at the beginning of the email, that 
> > the development has been quite slow. Yes, I've been 
> > still working on things, but I would say it is a far cry 
> > from "piling".
> 
> Sorry, that was a poor choice of a word. We did manage to 
> pile quite a bit of crap into the tracing hotpath though.

I was looking at the hot path of the ring buffer, and I think it was a
major design mistake in embedding the timestamp into the ring buffer
level. That should have been done in a higher level. By removing that
requirement, it would have made the ring buffer code hot path a lot
nicer.

We all failed in that design mistake. (I'm as guilty as anyone)

> 
> > I did add some simple features, like the "lost events" 
> > to the ring buffer, but that code can be looked at for 
> > ideas for the future. It does not make merging any more 
> > difficult than it already is.
> > 
> > Fine, I'll stop some of the code I was going to work on 
> > (multiple buffers for ftrace, event triggers, 
> > configuring events to stop the tracer (like for 
> > different kinds of BUG() and WARN_ON()), etc).
> 
> 
> I think those are excellent features that seem to fit 
> rather well into the persisent buffering concept, what do 
> you think?
> 
> Via the 'ftrace' tool we could as a first step extend 
> tracing sessions to per user. We could also bring the 
> start/stop/dont-worry-about-where-the-trace-is workflow to 
> perf trace that way.
> 
> Hm?
> 
> > >     - Conversion of an explicit tracing callback to
> > >       TRACE_EVENT (for example in the case of mmiotrace),
> > >       while keeping all tool functionality.
> > 
> > Not sure what this is.
> 
> We have a lot of explicit ad-hoc callbacks, hooks, 
> notifiers, function pointers in the kernel, which feed 
> some sort of event logging mechanism. These should be 
> unified while keeping their current functionality - but 
> exposing the callback as an event source as well. This 
> enriches total pool of events.
> 
> For example the mmiotrace tracepoints.

I'm not against any of this. Just need to take some time in finding a
proper design to this.

One thing we have to consider is looking at the use of the tracing
infrastructure in the kernel outside of kernel developers. At the Linux
Collaboration Summit, several people (non kernel developers) wanted to
have some amount of tracing happening in a production system. To have
this happen, the overhead must be at least configured to a minimum.

Especially if we want a real competitor to DTrace.

-- Steve

> 
> > >     - Migrate any 'special' ftrace feature to perf 
> > >       capabilities so that it's available via the 
> > >       syscall interface as well. (for example 
> > >       'latency maximum tracking' is something that we 
> > >       probably want to do with kernel-side help - we 
> > >       probably dont want to implement it via tracing 
> > >       everything all the time and finding the maximum 
> > >       based on terabytes of data.)
> > > 
> > >    (And there are other complications here too, but you 
> > >     get the idea.)
> > 
> > Yes, the latency tracers are special, and I treat them 
> > special in ftrace. They can be redesigned to keep their 
> > current functionality. That needed to be done anyway.
> 
> Yeah.
> 
> > > All in one, i think we can reuse more than 50% of all 
> > > current ftrace code (possibly up to 70-80%) - and we 
> > > are already reusing bits of it.
> > 
> > Ingo, as we have had this conversation, I don't know if 
> > you realized that I agreed to merge ftrace to perf. 
> > There's just some functionality about ftrace I really 
> > want to keep, which does include accessing via /debugfs, 
> > pretty-print (which is needed by trace-on-oops) and 
> > splice.
> 
> Ok, good :-)
> 
> Thanks,
> 
> 	Ingo



