Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0INTVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:21:50 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54599 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab0INTVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:21:48 -0400
Date: Mon, 13 Sep 2010 16:17:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
        David Miller <davem@davemloft.net>,
        Manfred Spraul <manfred@colorfullife.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, dipankar@in.ibm.com
Subject: Re: [PATCH, RFC] RCU: New scalable, multi-GP and preemptible RCU
 implementation
Message-ID: <20100913231756.GB18902@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4C7B7A80.2040105@cn.fujitsu.com>
 <20100830235705.GQ2420@linux.vnet.ibm.com>
 <4C7C70EF.5020507@cn.fujitsu.com>
 <20100908195310.GA10797@linux.vnet.ibm.com>
 <4C8E18C1.7060806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8E18C1.7060806@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 08:27:45PM +0800, Lai Jiangshan wrote:
> On 09/09/2010 03:53 AM, Paul E. McKenney wrote:
> > On Tue, Aug 31, 2010 at 11:03:11AM +0800, Lai Jiangshan wrote:
> >> On 08/31/2010 07:57 AM, Paul E. McKenney wrote:
> >>> On Mon, Aug 30, 2010 at 05:31:44PM +0800, Lai Jiangshan wrote:
> >>>>
> >>>> 0) contents
> >>>> 1) overview
> >>>> 2) scalable
> >>>> 3) multi-GP
> >>>> 4) integrated expedited synchronize_rcu
> >>>> 5) preemptible
> >>>> 6) top-down implies
> >>>> 7) speech
> >>>> 8) core rcuring
> >>>
> >>> Interesting!  I can't claim to have dug through every detail, but figured
> >>> I should ask a few questions first.
> >>>
> >>> 							Thanx, Paul
> >>>
> >>> Of course, the first question is whether it passes rcutorture, and if
> >>> so on what hardware configuration.
> >>
> >> Only in x86(32bit and 64bit) system.
> >> Did you patch it in power and test it? It' need more test for different archs,
> >> but I have no other arch.
> >>
> >> What is "hardware configuration"?
> > 
> > Mainly the number of CPUs.  The socket/core/thread counts could also
> > be helpful.

Any info?  ;-)

> >>> At first glance, it looks to live somewhere between Manfred Spraul's
> >>> counter-based hierarchical RCU and classic RCU.  There are also some
> >>> resemblances to K42's "generations" RCU-like mechanism.
> >>>
> >>>> 1) overview
> >>>> This is a new RCU implementation: RCURING. It uses a ring atomic counters
> >>>> to control the completion of GPs and a ring callbacks batches to process
> >>>> the callbacks.
> >>>
> >>> The ring is a set of grace periods, correct?
> >>
> >> correct. A GP is also controled by a set ring counters in
> >> (domain's done_complete, this GP's complete], this GP is only completed
> >> until all these conters become zero.
> > 
> > Understood.
> > 
> >> I pull up a question of your here:
> >>> For a given grace period, all quiescent states hit the same counter.
> >>> Or am I missing something?
> >>
> >> No.
> >> any rcu read site has a locked_complete, if a cpu hold a locked_complete,
> >> the counter of this locked_complete will not become zero.
> >>
> >> Any quiescent states will release its previous rcu read site's locked_complete,
> >> so different QS may hit different counter.
> >> QS alway locks the newest GP(not started to waiting, domain's curr_complete)
> >> for next rcu read site and get the new locked_complete.
> >>
> >> What I said seems still indistinct, more questions are wellcome, questions
> >> also help for documents. Thank you very much.
> > 
> > OK, here is my assessment thus far.  First my understanding of how this
> > all works:
> > 
> > o	Maintain a circular array of counters.  Maintain a parallel
> > 	circular array of callback lists.
> > 
> > o	Each non-dyntick-idle CPU holds a reference to one element of the
> > 	array.	If Ring RCU is idle, it holds a reference to the element
> > 	that will serve the next grace period.	Similarly, if a given
> > 	CPU has passed through a quiescent state for all existing grace
> > 	periods, it will hold a reference to the element that will serve
> > 	for the next grace period.
> > 
> > o	Upon encountering a quiescent state, we acquire a reference to
> > 	the element that will serve for the next grace period, and
> > 	then release the reference to the element that we were holding.  
> > 
> > 	The rcuring_lock() function acquires a reference to the element
> > 	that will serve for the next grace period.  Not yet clear what
> > 	the atomic_inc_not_zero() is for.  If the reference count is zero,
> > 	what makes it non-zero?
> 
> rcuring_lock() may be called when current CPU did not hold any reference
> of rcuring, so the rcuring may completes many GPs while rcuring_lock()
> is requiring reference. but rcuring_lock() should not require the finish
> complete GP's reference. so I use atomic_inc_not_zero():  If the reference count
> is zero, it maybe finish complete GP's reference, we should try again.
> 
> In rcuring_advance_lock(), we have no such problem, we can use rcuring_dup_lock()
> actually.

Got it, thank you!

> > 	The rcuring_dup_lock() function acquires another reference to
> > 	the element that the CPU already holds a reference to.  This
> > 	is used in preemptible RCU when a task is preempted in an
> > 	RCU read-side critical section.
> > 
> > 	The rcuring_unlock() function releases a reference.
> > 
> > 	The rcuring_advance_lock() acquires a new reference, then
> > 	releases the old one.  This is used when a CPU passes through
> > 	a quiescent state.
> > 
> > o	When a CPU enters dyntick-idle mode, it releases its reference.
> > 	When it exits dyntick-idle mode (including irq and NMI), it
> > 	acquires a referent to the element that will serve for the next
> > 	grace period.
> 
> Yes, the rcuring will totally ignore this cpu, if it did not hold
> any referent.

Good!

> > o	The __rcu_check_callbacks() function checks to see if the
> > 	oldest grace period is now reference-free, and, if so,
> > 	rcuring_advance_done_complete() retires the old grace periods.
> > 	The advance_callbacks() then moves any affected callbacks to
> > 	be invoked.
> > 
> > o	If RCU callbacks are not invoked quickly enough (10 jiffies),
> > 	force_quiescent_state() sends IPIs to CPUs needing help
> > 	reaching a quiescent state.
> > 
> > 
> > So there were some things that struck me as being really good with
> > your approach, most of which I intend to pull into the current RCU
> > implementations:
> 
> I will do this, also.

Very good!!!

The first and last (offsets and __rcu_barrier()/__synchronize_rcu())
seem like the most important in the short term.

> > o	Offsets into task_struct, allowing inlining of rcu_read_lock()
> > 	and the fastpath of rcu_read_unlock().
> > 
> > o	Faster grace periods, at least when the system is busy.
> > 
> > o	Placement of rcu_copy_process() and exit_rcu() into
> > 	include/linux/ringrcu.h.  Not clear that this maps nicely
> > 	to tree/tiny implementations, though.
> > 
> > o	Defining __rcu_barrier() in terms of __call_rcu() instead of the
> > 	various call_rcu*() variants.  Ditto for __synchronize_rcu().
> > 
> > 
> > There are some things that I am unsure of, perhaps because I am still
> > misunderstanting something:
> > 
> > o	The per-CPU reference-counting scheme can gain much of the
> > 	benefit that TREE_RCU gains by handling large numbers of updates
> > 	with a single grace period.  However, CPUs that pass through
> > 	quiescent states quickly, for example, by frequently interrupting
> > 	out of dyntick-idle state, can incur lots of cache misses cycling
> > 	through lots of RING RCU array elements.
> 
> It is true. I think frequently interrupting is seldom happened when
> dyntick-idle state. And this can be fixed easily.

That is the intention for dyntick-idle state, but fast transitions can
happen for some workloads.

> > o	Aggressive code shrinkage through large cpp macros.  You seem to
> > 	share my ambivalence given that you use it in only some of the
> > 	situations where it might be applied.  ;-)
> > 
> > 	The savings of lines of code does vary -- many definitions can
> > 	be placed under a single #ifdef, after all.
> 
> I tried my best to abstract rcu, and to retry the common codes,
> I think we can use it for rcutree.

We should of course decide on a case-by-case basis.

> > o	Use of kref rather than a simple counter.  Saves a line or two,
> > 	adds a function.
> 
> I want the save the comments, kref is always inited as 1.
> code itself is comments.

Fair point, so probably worth doing.

> > o	__rcu_check_callbacks() won't force a grace period if there
> > 	are no callbacks waiting to be invoked.  On the one hand, one
> > 	can argue that forcing a grace period is useless in that case,
> > 	but on the other hand, there is usually more than one CPU.
> > 	This is probably a consequence of the force_quiescent_state()
> > 	time being based on callback residence time rather than on
> > 	grace-period duration -- only CPUs with callbacks can possibly
> > 	measure a meaningful residence time.
> 
> I think it's useless to FQS when there is no callbacks in current cpu.
> FQS is not scalable because is require global lock.

On systems with large numbers of CPUs that need real-time response, it
will likely be necessary to make fqs be incremental, in which case it is
good to have CPUs that have no callbacks help out.  (I have gotten one
request for incremental fqs, sent then the patch, and didn't hear anything
since.)

> > o	NMI handling?  Note that raw_local_irq_save() does not
> > 	block NMIs, so need to analyze recursion into rcu_kernel_enter()
> > 	and rcu_kernel_exit().  Looks like it might be OK, but...
> > 	Ironically enough, courtesy of the atomic instructions and
> > 	cache misses that are so scary in these functions.  ;-)
> 
> It's safe when NMI, I added barrier()s.
> 
> +static void __rcu_kernel_enter_outmost(int cpu)
> +{
> +       GEN_CODES(LOCK_COMPLETE)
> +
> +       barrier();
> +       per_cpu(kernel_count, cpu) = 1;
> +       barrier();
> +
> +       GEN_CODES(SAVE_COMPLETE)
> +}

It does look plausible, but will need careful checking.

> > o	Eliminating rcu_pending() might be a good thing, though perhaps
> > 	simplifying it (making it less exact) might be the right thing
> > 	to do in TREE_RCU, particularly given that priority boosting
> > 	turns RCU_SOFTIRQ into a kthread.
> > 
> > 
> > Here are some things that could be problematic about Ring RCU.  Some
> > of them are fixable, others might or might not be:
> > 
> > o	Potentially high memory contention on a given ring: worst case
> > 	is quite bad on large SMP systems.  On the other hand, best
> > 	case is really good, given that each CPU could get its own
> > 	rcuring counter.  Average case is likely to be modestly bad.
> > 	The default value of 4 for RCURING_COUNTERS_SHIFT maps to 16
> > 	array elements, which could easily show worst case behavior from
> > 	time to time on large systems.
> 
> It may be true, only a global rcuring for a rcu_domain.
> by it just do 6 atomic operations for a QS without any locks, will it reduce
> the pain of memory contention?

It does greatly reduce the best-case and (I think) average level of
memory contention, but I am still concerned about the case where
all CPUs have references to the next-to-be-used ring element, and
then a grace period starts.  All the CPUs will then need to do
rcuring_unlock() on the same element.  On a really large system,
this could be a problem.

> It is hard to fix this if it becomes a problem, but I believe
> it's very economical only 6 atomic operations for a QS.
> 
> (maybe the only way to fix: use hierarchy for RCURING)

That might be one possibility.

The big thing will be determining what RCURING is really good at compared
to existing implementations in the kernel.

> > o	Real-time latency could be problematic due to:
> > 
> > 	o	Scans across CPUs and across grace-period ring elements.
> 
> Scans across CPUs: only when FQS, but RCURING very very seldom do a FQS.
>                    and we can fix it. call FQS in kthread or... etc.

Or incrementally scan, one way or another.

> across grace-period ring elements: we use small RCURING_IDX_MAX.

True, though if you had a large number of CPUs, you would want to merge
the GPs in that case -- otherwise, you have very long grace-period
latencies.  (Maybe you already do merge GPs, but if so, I missed it.)

> > 	o	Worst-case memory contention.
> > 
> > 	o	High interrupt rates out of dyntick-idle state.
> > 
> > o	Potentially large memory consumption due to RCURING_IDX_MAX
> > 	arrays in rcu_data and rcuring structures.  The default of
> > 	16 elements should be OK.
> > 
> > o	Use of atomic instructions in dyntick path.  (Not just one, but
> > 	potentially a long string of them -- and implied cache misses.
> > 	Understand that the expected case is a single atomic in
> > 	rcuring_lock() -- but worst case is at least somewhat important.)
> > 
> > 	Benefit is that you don't need to scan the CPUs to check for
> > 	dyntick-idle CPUs -- force_quiescent_state() is then limited to
> > 	resched IPIs.  Unless of course the dyntick-idle CPUs remain in
> > 	dyntick-idle state throughout, in which case they get IPIed.  This
> > 	situation limits dyntick-idle state to 10 jiffies, which would
> > 	result in the energy-efficiency guys screaming bloody murder.
> > 	The battery-powered embedded guys would not bother screaming,
> > 	but could instead be expected to come after us with pitchforks.
> 
> I hate to call force_quiescent_state(), it is not scalable in RCURING/RCUTREE
> 
> In RCURING/RCUTREE, A GP is about 3 jiffies in average,
> so I use 10 jiffies for FQS interval, thus force_quiescent_state()
> is called rarely.
> 
> in force_quiescent_state(), I forgot to test the dest cpu's kernel_count,
> It will be fixed. RCURING is Energy efficiency.

Good!

> > o	Energy efficiency: see above paragraph.
> 
> Good catch.
> 
> > 
> > 
> > The remainder are shortcomings that should be easy to fix:
> > 
> > o	force_quiescent_state() for preemptible variant not implemented.
> > 	(Waiting on RCU priority boosting.)
> > 
> > o	Constants in __rcu_check_callbacks() really need to be
> > 	macroized.  "10"?  "2 * HZ"?
> > 
> > o	rcu_do_batch() needs to self-limit in multi-CPU configurations.
> > 	Otherwise, latency is a problem.  TINY_RCU gets away without
> > 	this (for the time being, anyway), but TREE_RCU and CLASSIC_RCU
> > 	before it need the blimit functionality.  Otherwise the
> > 	Linux Audio guys will scream.
> > 
> > o	Too much stuff directly called from scheduling-clock-interrupt
> > 	context!  Full scan of CPUs in __force_quiescent_state(), for
> > 	example.  Need to hand off to RCU_SOFTIRQ or a kthread.
> > 
> > o	print_rcuring_stall() does not dump stacks.
> > 
> > So, what am I still missing about your approach?
> > 
> 
> Thank you very much. I think the potentially high memory contention
> cold be a hard problem, but will you plan to merge it.

I do not know the answer to that yet.

Clearly, it would need to handle the various corner cases we have
discussed, and possibly others that we have not yet uncovered.  It would
also need to do something that the current RCU implementations can not be
made to handle well.  Otherwise, my approach is to merge implementations
(e.g., SRCU into TREE_PREEMPT_RCU and TINY_PREEMPT_RCU) rather than
adding new ones.

							THanx, Paul
