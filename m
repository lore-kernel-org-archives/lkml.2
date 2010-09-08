Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0IHTxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 15:53:36 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55752 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab0IHTxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 15:53:30 -0400
Date: Wed, 8 Sep 2010 12:53:10 -0700
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
Message-ID: <20100908195310.GA10797@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4C7B7A80.2040105@cn.fujitsu.com>
 <20100830235705.GQ2420@linux.vnet.ibm.com>
 <4C7C70EF.5020507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7C70EF.5020507@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 11:03:11AM +0800, Lai Jiangshan wrote:
> On 08/31/2010 07:57 AM, Paul E. McKenney wrote:
> > On Mon, Aug 30, 2010 at 05:31:44PM +0800, Lai Jiangshan wrote:
> >>
> >> 0) contents
> >> 1) overview
> >> 2) scalable
> >> 3) multi-GP
> >> 4) integrated expedited synchronize_rcu
> >> 5) preemptible
> >> 6) top-down implies
> >> 7) speech
> >> 8) core rcuring
> > 
> > Interesting!  I can't claim to have dug through every detail, but figured
> > I should ask a few questions first.
> > 
> > 							Thanx, Paul
> > 
> > Of course, the first question is whether it passes rcutorture, and if
> > so on what hardware configuration.
> 
> Only in x86(32bit and 64bit) system.
> Did you patch it in power and test it? It' need more test for different archs,
> but I have no other arch.
> 
> What is "hardware configuration"?

Mainly the number of CPUs.  The socket/core/thread counts could also
be helpful.

> > At first glance, it looks to live somewhere between Manfred Spraul's
> > counter-based hierarchical RCU and classic RCU.  There are also some
> > resemblances to K42's "generations" RCU-like mechanism.
> > 
> >> 1) overview
> >> This is a new RCU implementation: RCURING. It uses a ring atomic counters
> >> to control the completion of GPs and a ring callbacks batches to process
> >> the callbacks.
> > 
> > The ring is a set of grace periods, correct?
> 
> correct. A GP is also controled by a set ring counters in
> (domain's done_complete, this GP's complete], this GP is only completed
> until all these conters become zero.

Understood.

> I pull up a question of your here:
> > For a given grace period, all quiescent states hit the same counter.
> > Or am I missing something?
> 
> No.
> any rcu read site has a locked_complete, if a cpu hold a locked_complete,
> the counter of this locked_complete will not become zero.
> 
> Any quiescent states will release its previous rcu read site's locked_complete,
> so different QS may hit different counter.
> QS alway locks the newest GP(not started to waiting, domain's curr_complete)
> for next rcu read site and get the new locked_complete.
> 
> What I said seems still indistinct, more questions are wellcome, questions
> also help for documents. Thank you very much.

OK, here is my assessment thus far.  First my understanding of how this
all works:

o	Maintain a circular array of counters.  Maintain a parallel
	circular array of callback lists.

o	Each non-dyntick-idle CPU holds a reference to one element of the
	array.	If Ring RCU is idle, it holds a reference to the element
	that will serve the next grace period.	Similarly, if a given
	CPU has passed through a quiescent state for all existing grace
	periods, it will hold a reference to the element that will serve
	for the next grace period.

o	Upon encountering a quiescent state, we acquire a reference to
	the element that will serve for the next grace period, and
	then release the reference to the element that we were holding.  

	The rcuring_lock() function acquires a reference to the element
	that will serve for the next grace period.  Not yet clear what
	the atomic_inc_not_zero() is for.  If the reference count is zero,
	what makes it non-zero?

	The rcuring_dup_lock() function acquires another reference to
	the element that the CPU already holds a reference to.  This
	is used in preemptible RCU when a task is preempted in an
	RCU read-side critical section.

	The rcuring_unlock() function releases a reference.

	The rcuring_advance_lock() acquires a new reference, then
	releases the old one.  This is used when a CPU passes through
	a quiescent state.

o	When a CPU enters dyntick-idle mode, it releases its reference.
	When it exits dyntick-idle mode (including irq and NMI), it
	acquires a referent to the element that will serve for the next
	grace period.

o	The __rcu_check_callbacks() function checks to see if the
	oldest grace period is now reference-free, and, if so,
	rcuring_advance_done_complete() retires the old grace periods.
	The advance_callbacks() then moves any affected callbacks to
	be invoked.

o	If RCU callbacks are not invoked quickly enough (10 jiffies),
	force_quiescent_state() sends IPIs to CPUs needing help
	reaching a quiescent state.


So there were some things that struck me as being really good with
your approach, most of which I intend to pull into the current RCU
implementations:

o	Offsets into task_struct, allowing inlining of rcu_read_lock()
	and the fastpath of rcu_read_unlock().

o	Faster grace periods, at least when the system is busy.

o	Placement of rcu_copy_process() and exit_rcu() into
	include/linux/ringrcu.h.  Not clear that this maps nicely
	to tree/tiny implementations, though.

o	Defining __rcu_barrier() in terms of __call_rcu() instead of the
	various call_rcu*() variants.  Ditto for __synchronize_rcu().


There are some things that I am unsure of, perhaps because I am still
misunderstanting something:

o	The per-CPU reference-counting scheme can gain much of the
	benefit that TREE_RCU gains by handling large numbers of updates
	with a single grace period.  However, CPUs that pass through
	quiescent states quickly, for example, by frequently interrupting
	out of dyntick-idle state, can incur lots of cache misses cycling
	through lots of RING RCU array elements.

o	Aggressive code shrinkage through large cpp macros.  You seem to
	share my ambivalence given that you use it in only some of the
	situations where it might be applied.  ;-)

	The savings of lines of code does vary -- many definitions can
	be placed under a single #ifdef, after all.

o	Use of kref rather than a simple counter.  Saves a line or two,
	adds a function.

o	__rcu_check_callbacks() won't force a grace period if there
	are no callbacks waiting to be invoked.  On the one hand, one
	can argue that forcing a grace period is useless in that case,
	but on the other hand, there is usually more than one CPU.
	This is probably a consequence of the force_quiescent_state()
	time being based on callback residence time rather than on
	grace-period duration -- only CPUs with callbacks can possibly
	measure a meaningful residence time.

o	NMI handling?  Note that raw_local_irq_save() does not
	block NMIs, so need to analyze recursion into rcu_kernel_enter()
	and rcu_kernel_exit().  Looks like it might be OK, but...
	Ironically enough, courtesy of the atomic instructions and
	cache misses that are so scary in these functions.  ;-)

o	Eliminating rcu_pending() might be a good thing, though perhaps
	simplifying it (making it less exact) might be the right thing
	to do in TREE_RCU, particularly given that priority boosting
	turns RCU_SOFTIRQ into a kthread.


Here are some things that could be problematic about Ring RCU.  Some
of them are fixable, others might or might not be:

o	Potentially high memory contention on a given ring: worst case
	is quite bad on large SMP systems.  On the other hand, best
	case is really good, given that each CPU could get its own
	rcuring counter.  Average case is likely to be modestly bad.
	The default value of 4 for RCURING_COUNTERS_SHIFT maps to 16
	array elements, which could easily show worst case behavior from
	time to time on large systems.

o	Real-time latency could be problematic due to:

	o	Scans across CPUs and across grace-period ring elements.

	o	Worst-case memory contention.

	o	High interrupt rates out of dyntick-idle state.

o	Potentially large memory consumption due to RCURING_IDX_MAX
	arrays in rcu_data and rcuring structures.  The default of
	16 elements should be OK.

o	Use of atomic instructions in dyntick path.  (Not just one, but
	potentially a long string of them -- and implied cache misses.
	Understand that the expected case is a single atomic in
	rcuring_lock() -- but worst case is at least somewhat important.)

	Benefit is that you don't need to scan the CPUs to check for
	dyntick-idle CPUs -- force_quiescent_state() is then limited to
	resched IPIs.  Unless of course the dyntick-idle CPUs remain in
	dyntick-idle state throughout, in which case they get IPIed.  This
	situation limits dyntick-idle state to 10 jiffies, which would
	result in the energy-efficiency guys screaming bloody murder.
	The battery-powered embedded guys would not bother screaming,
	but could instead be expected to come after us with pitchforks.

o	Energy efficiency: see above paragraph.


The remainder are shortcomings that should be easy to fix:

o	force_quiescent_state() for preemptible variant not implemented.
	(Waiting on RCU priority boosting.)

o	Constants in __rcu_check_callbacks() really need to be
	macroized.  "10"?  "2 * HZ"?

o	rcu_do_batch() needs to self-limit in multi-CPU configurations.
	Otherwise, latency is a problem.  TINY_RCU gets away without
	this (for the time being, anyway), but TREE_RCU and CLASSIC_RCU
	before it need the blimit functionality.  Otherwise the
	Linux Audio guys will scream.

o	Too much stuff directly called from scheduling-clock-interrupt
	context!  Full scan of CPUs in __force_quiescent_state(), for
	example.  Need to hand off to RCU_SOFTIRQ or a kthread.

o	print_rcuring_stall() does not dump stacks.

So, what am I still missing about your approach?

							Thanx, Paul

> >> In 2008, I think out the idea, and wrote the first 300lines code of rcuring.c,
> >> but I'm too lazy to finish it
> >>
> >> 2) scalable
> >> There is only 2 locks in every RCU domain(rcu_bh, rcu_sched, rcu_preempt),
> >> one of them is for misc things, it is a infrequency lock, the other is
> >> for advancing complete, it is frequency lock. But somebody else would
> >> very probably do the same work for me if somebody else is holding this lock,
> >> so we alway use spin_trylock() for this lock, so it is scalable.
> >>
> >> We don't need any lock for reporting quiescent state, we just need 2
> >> atomic operations for every RCU domain.
> > 
> > If you have a single GP in flight, all CPUs need to do an atomic op on the
> > same element of the RCU ring, correct?  
> 
> Yes, but it seldom have only a single GP in flight. We start GPs when need.
> 
> > My first thought was that each CPU
> > was writing the current grace-period number to its own variable, but that
> > would not require an atomic operation.  Of course, the downside of this
> > latter approach is that some CPU would need to scan all CPUs' counters.
> > 
> >> 3) multi-GP
> >> All old rcu implementations have only one waiting GP.
> >>
> >> time  -----ta-tb--------------------tc----------------td------------->
> >> GP    -----|------GP1---------------|--------GP2------|------------->
> >> cpu#x ........|---------------------------------------|...............>
> >>               |->insert a callback                    |->handle callback
> >>
> >> the callback have to wait a partial GP1, and a full GP2, it may wait
> >> near 2 GPs in worse case because it have to wait the rcu read sites witch
> >> start at (tb, tc] which are needless to wait. In average, a callback
> >> have to wait (1 + 1/(1+1))= 1.5GPs
> >>
> >> if we can have three simultaneous waiting GPs:
> >>
> >> GPs   .....|------GP1---------------|..........................
> >>       ...........|--------GP2-----------|....................
> >>       ....................|---------GP3---------------|........
> >> cpu#x ........|-------------------------|..........................>
> >>               |->insert a callback      |->handle callback
> >> The callback is handled more quickly, In average, a callback have to wait
> >> (1 + 1/(3+1))=1.25GPs
> >>
> >> if we can have X simultaneous waiting GPs, a callback have to wait
> >> (1 + 1/(X+1)) GPs in average. The default X in this patch is 15
> >> (including the reserved GPs).
> > 
> > Assuming that the start times of the GPs are evenly spaced, correct?
> 
> No, We start GPs when need.
> If a cpu has queued some callbacks, and the callbacks's
> complete is equals to rcu domain's curr_complete, this cpu will
> start a new GPs for these callbacks.
> 
> > 
> >> 4) integrated expedited synchronize_rcu
> >> expedited synchronize_rcu is implemented in rcuring.c, not in other files.
> >> The whole of it is less than 50 lines of code. we just reserve several
> >> GPs for expedited synchronize_rcu, when a expedited callback is inserted,
> >> we start a new GP immediately(we have reserved GPs, this step will
> >> very probably success), and then force this new GP to be completed quickly.
> >> (thanks to multi-GP)
> > 
> > I would be more convinced had you implemented force_quiescent_state()
> > for preemptible RCU.  ;-)
> > 
> >> 5) preemptible
> >> new simple preemptible code, rcu_read_lock/unlock() is simple and is inline function.
> >> add new kernel-offset.c to avoid recursively header files inclusion.
> >>
> >> 6) top-down implies
> >> irq and local_irq_disable() implies preempt_disable()/rcu_read_lock_sched(),
> >> irq and local_irq_disable() implies rcu_read_lock(). (*)
> >> preempt_disable()/rcu_read_lock_sched() implies rcu_read_lock(). (*)
> >> *: In preemptible rcutree/rcutiny, it is false.
> >>
> >> 7) speech
> >> I will give a speech about RCU and this RCU implementation
> >> in Japan linuxcon 2010. Welcome to Japan Linuxcon 2010.
> > 
> > Congratulations!
> > 
> >> 8) core rcuring
> >> (Comments and document is still been writing)
> >>
> >> all read_read_lock/unlock_domain() is nested in a coresponding
> >> rcuring_lock/unlock(), and the algorithm handles a rcuring_lock/unlock()
> >> ciritcal region as a full rcu read site ciritcal region.
> >>
> >> read site:
> >>   rcuring_lock()
> >>     lock a complete, and ensure this locked_complete - done_complete(1) > 0
> >>       curr_complete(1) - locked_complete >= 0
> >>     mb(1)
> > 
> > This is really a compiler barrier?
> 
> a really memory barrier.
> these memory barriers are not in rcu_read_lock(), there in the code where
> pass QS.
> 
> > 
> >>
> >>   rcu_derefrence(ptr)
> >>
> >>   rcuring_unlock()
> >>     mb(2)
> > 
> > Ditto?
> > 
> >>     release its locked_complete.
> >>
> >> update site:
> >>   rcu_assign_pointer(ptr, new)
> >>
> >>   (handle callback:call_rcu()+rcu_do_batch())
> >>   (call_rcu():)
> >>   mb(3)
> >>   get the curr_complete(2)
> >>   set callback's complete as this curr_complete(2).
> >>     (we don't have any field to record the callback's complete, we just
> >>      emulate it by rdp->done_complete and the position of this callback
> >>      in rdp->batch.)
> >>
> >>   time pass... until done_complete(2) - callback's complete > 0
> > 
> > I have to ask about counter overflow on 32-bit systems.
> 
> The "complete" is "long" not "unsigned long"
> 
> if callback's complete - rdp->curr_complete > 0, we also queue
> this callback to done_batch.
> 
> > 
> >>   (rcu_do_batch():)
> >>   mb(4)
> >>   call the callback: (free old ptr, etc.)
> >>
> >> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> >> ---
> >>  Kbuild                   |   75 ++-
> >>  include/linux/rcupdate.h |    6 
> >>  include/linux/rcuring.h  |  195 +++++++++
> >>  include/linux/sched.h    |    6 
> >>  init/Kconfig             |   32 +
> >>  kernel/Makefile          |    1 
> >>  kernel/kernel-offsets.c  |   20 
> >>  kernel/rcuring.c         | 1002 +++++++++++++++++++++++++++++++++++++++++++++++
> >>  kernel/sched.c           |    2 
> >>  kernel/time/tick-sched.c |    4 
> >>  10 files changed, 1324 insertions(+), 19 deletions(-)
> >> diff --git a/Kbuild b/Kbuild
> >> index e3737ad..bce37cb 100644
> >> --- a/Kbuild
> >> +++ b/Kbuild
> >> @@ -3,7 +3,19 @@
> >>  # This file takes care of the following:
> >>  # 1) Generate bounds.h
> >>  # 2) Generate asm-offsets.h (may need bounds.h)
> >> -# 3) Check for missing system calls
> >> +# 3) Generate kernel-offsets.h
> >> +# 4) Check for missing system calls
> >> +
> >> +# Default sed regexp - multiline due to syntax constraints
> >> +define sed-y
> >> +	"/^->/{s:->#\(.*\):/* \1 */:; \
> >> +	s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
> >> +	s:->::; p;}"
> >> +endef
> >> +
> >> +quiet_cmd_offsets_cc_s_c = CC $(quiet_modtag)  $@
> >> +cmd_offsets_cc_s_c       = $(CC) -D__GENARATING_OFFSETS__               \
> > 
> > s/GENARATING/GENERATING/  just to be pedantic.  ;-)
> > 
> >> +                           $(c_flags) -fverbose-asm -S -o $@ $<
> > 
> > Pulling out the offsets might have the advantage of allowing both
> > rcu_read_lock() and rcu_read_unlock() to be inlined, but without pulling
> > in include/linux/sched.h everywhere.  I had been thinking in terms of
> > moving the state from the task struct to the taskinfo struct, but
> > this approach might be worth considering.
> > 
> >>  #####
> >>  # 1) Generate bounds.h
> >> @@ -43,22 +55,14 @@ $(obj)/$(bounds-file): kernel/bounds.s Kbuild
> >>  # 2) Generate asm-offsets.h
> >>  #
> >>
> >> -offsets-file := include/generated/asm-offsets.h
> >> +asm-offsets-file := include/generated/asm-offsets.h
> >>
> >> -always  += $(offsets-file)
> >> -targets += $(offsets-file)
> >> +always  += $(asm-offsets-file)
> >> +targets += $(asm-offsets-file)
> >>  targets += arch/$(SRCARCH)/kernel/asm-offsets.s
> >>
> >> -
> >> -# Default sed regexp - multiline due to syntax constraints
> >> -define sed-y
> >> -	"/^->/{s:->#\(.*\):/* \1 */:; \
> >> -	s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
> >> -	s:->::; p;}"
> >> -endef
> >> -
> >> -quiet_cmd_offsets = GEN     $@
> >> -define cmd_offsets
> >> +quiet_cmd_asm_offsets = GEN     $@
> >> +define cmd_asm_offsets
> >>  	(set -e; \
> >>  	 echo "#ifndef __ASM_OFFSETS_H__"; \
> >>  	 echo "#define __ASM_OFFSETS_H__"; \
> >> @@ -78,13 +82,48 @@ endef
> >>  arch/$(SRCARCH)/kernel/asm-offsets.s: arch/$(SRCARCH)/kernel/asm-offsets.c \
> >>                                        $(obj)/$(bounds-file) FORCE
> >>  	$(Q)mkdir -p $(dir $@)
> >> -	$(call if_changed_dep,cc_s_c)
> >> +	$(call if_changed_dep,offsets_cc_s_c)
> >> +
> >> +$(obj)/$(asm-offsets-file): arch/$(SRCARCH)/kernel/asm-offsets.s Kbuild
> >> +	$(call cmd,asm_offsets)
> >> +
> >> +#####
> >> +# 3) Generate kernel-offsets.h
> >> +#
> >> +
> >> +kernel-offsets-file := include/generated/kernel-offsets.h
> >> +
> >> +always  += $(kernel-offsets-file)
> >> +targets += $(kernel-offsets-file)
> >> +targets += kernel/kernel-offsets.s
> >> +
> >> +quiet_cmd_kernel_offsets = GEN     $@
> >> +define cmd_kernel_offsets
> >> +	(set -e; \
> >> +	 echo "#ifndef __LINUX_KERNEL_OFFSETS_H__"; \
> >> +	 echo "#define __LINUX_KERNEL_OFFSETS_H__"; \
> >> +	 echo "/*"; \
> >> +	 echo " * DO NOT MODIFY."; \
> >> +	 echo " *"; \
> >> +	 echo " * This file was generated by Kbuild"; \
> >> +	 echo " *"; \
> >> +	 echo " */"; \
> >> +	 echo ""; \
> >> +	 sed -ne $(sed-y) $<; \
> >> +	 echo ""; \
> >> +	 echo "#endif" ) > $@
> >> +endef
> >> +
> >> +# We use internal kbuild rules to avoid the "is up to date" message from make
> >> +kernel/kernel-offsets.s: kernel/kernel-offsets.c $(obj)/$(bounds-file) \
> >> +                         $(obj)/$(asm-offsets-file) FORCE
> >> +	$(call if_changed_dep,offsets_cc_s_c)
> >>
> >> -$(obj)/$(offsets-file): arch/$(SRCARCH)/kernel/asm-offsets.s Kbuild
> >> -	$(call cmd,offsets)
> >> +$(obj)/$(kernel-offsets-file): kernel/kernel-offsets.s Kbuild
> >> +	$(call cmd,kernel_offsets)
> >>
> >>  #####
> >> -# 3) Check for missing system calls
> >> +# 4) Check for missing system calls
> >>  #
> >>
> >>  quiet_cmd_syscalls = CALL    $<
> >> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> >> index 89414d6..42cd6bc 100644
> >> --- a/include/linux/rcupdate.h
> >> +++ b/include/linux/rcupdate.h
> >> @@ -124,6 +124,7 @@ extern void rcu_bh_qs(int cpu);
> >>  extern void rcu_check_callbacks(int cpu, int user);
> >>  struct notifier_block;
> >>
> >> +#ifndef CONFIG_RCURING
> >>  #ifdef CONFIG_NO_HZ
> >>
> >>  extern void rcu_enter_nohz(void);
> >> @@ -140,11 +141,14 @@ static inline void rcu_exit_nohz(void)
> >>  }
> >>
> >>  #endif /* #else #ifdef CONFIG_NO_HZ */
> >> +#endif
> >>
> >>  #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
> >>  #include <linux/rcutree.h>
> >>  #elif defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
> >>  #include <linux/rcutiny.h>
> >> +#elif defined(CONFIG_RCURING)
> >> +#include <linux/rcuring.h>
> >>  #else
> >>  #error "Unknown RCU implementation specified to kernel configuration"
> >>  #endif
> >> @@ -686,6 +690,7 @@ struct rcu_synchronize {
> >>
> >>  extern void wakeme_after_rcu(struct rcu_head  *head);
> >>
> >> +#ifndef CONFIG_RCURING
> >>  #ifdef CONFIG_PREEMPT_RCU
> >>
> >>  /**
> >> @@ -710,6 +715,7 @@ extern void call_rcu(struct rcu_head *head,
> >>  #define	call_rcu	call_rcu_sched
> >>
> >>  #endif /* #else #ifdef CONFIG_PREEMPT_RCU */
> >> +#endif
> >>
> >>  /**
> >>   * call_rcu_bh() - Queue an RCU for invocation after a quicker grace period.
> >> diff --git a/include/linux/rcuring.h b/include/linux/rcuring.h
> >> new file mode 100644
> >> index 0000000..343b932
> >> --- /dev/null
> >> +++ b/include/linux/rcuring.h
> >> @@ -0,0 +1,195 @@
> >> +/*
> >> + * Read-Copy Update mechanism for mutual exclusion
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published by
> >> + * the Free Software Foundation; either version 2 of the License, or
> >> + * (at your option) any later version.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + *
> >> + * You should have received a copy of the GNU General Public License
> >> + * along with this program; if not, write to the Free Software
> >> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> >> + *
> >> + * Copyright IBM Corporation, 2008
> >> + * Copyright Fujitsu 2008-2010 Lai Jiangshan
> >> + *
> >> + * Authors: Dipankar Sarma <dipankar@in.ibm.com>
> >> + *	    Manfred Spraul <manfred@colorfullife.com>
> >> + *	    Paul E. McKenney <paulmck@linux.vnet.ibm.com> Hierarchical version
> >> + *	    Lai Jiangshan <laijs@cn.fujitsu.com> RCURING version
> >> + */
> >> +
> >> +#ifndef __LINUX_RCURING_H
> >> +#define __LINUX_RCURING_H
> >> +
> >> +#define __rcu_read_lock_bh() local_bh_disable()
> >> +#define __rcu_read_unlock_bh() local_bh_enable()
> >> +#define __rcu_read_lock_sched() preempt_disable()
> >> +#define __rcu_read_unlock_sched() preempt_enable()
> >> +
> >> +#ifdef CONFIG_RCURING_BH
> >> +extern void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *));
> >> +extern void synchronize_rcu_bh(void);
> >> +extern void synchronize_rcu_bh_expedited(void);
> >> +extern void rcu_bh_qs(int cpu);
> >> +extern long rcu_batches_completed_bh(void);
> >> +extern void rcu_barrier_bh(void);
> >> +extern void rcu_bh_force_quiescent_state(void);
> >> +#else /* CONFIG_RCURING_BH */
> >> +#define call_rcu_bh call_rcu_sched
> >> +#define synchronize_rcu_bh synchronize_rcu_sched
> >> +#define synchronize_rcu_bh_expedited synchronize_rcu_sched_expedited
> >> +#define rcu_bh_qs(cpu) do { (void)(cpu); } while (0)
> >> +#define rcu_batches_completed_bh rcu_batches_completed_sched
> >> +#define rcu_barrier_bh rcu_barrier_sched
> >> +#define rcu_bh_force_quiescent_state rcu_sched_force_quiescent_state
> >> +#endif /* CONFIG_RCURING_BH */
> >> +
> >> +extern
> >> +void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *));
> >> +extern void synchronize_rcu_sched(void);
> >> +#define synchronize_sched synchronize_rcu_sched
> >> +extern void synchronize_rcu_sched_expedited(void);
> >> +#define synchronize_sched_expedited synchronize_rcu_sched_expedited
> >> +extern void rcu_note_context_switch(int cpu);
> >> +extern long rcu_batches_completed_sched(void);
> >> +extern void rcu_barrier_sched(void);
> >> +extern void rcu_sched_force_quiescent_state(void);
> >> +
> >> +/*
> >> + * The @flags is valid only when RCURING_PREEMPT_SAVED is set.
> >> + *
> >> + * When preemptible rcu read site is preempted, we save RCURING_PREEMPT_SAVED,
> >> + * RCURING_PREEMPT_QS and this read site's locked_complete(only the last
> >> + * RCURING_COUNTERS_SHIFT bits) in the @flags.
> >> + *
> >> + * When the outmost rcu read site is closed, we will clear
> >> + * RCURING_PREEMPT_QS bit if it's saved, and let rcu system knows
> >> + * this task has passed a quiescent state and release the old read site's
> >> + * locked_complete.
> >> + */
> >> +#define RCURING_PREEMPT_SAVED	(1 << 31)
> >> +#define RCURING_PREEMPT_QS	(1 << 30)
> >> +#define RCURING_PREEMPT_FLAGS	(RCURING_PREEMPT_SAVED | RCURING_PREEMPT_QS)
> >> +
> >> +struct rcu_task_preempt {
> >> +	unsigned int nesting;
> >> +	unsigned int flags;
> >> +};
> >> +
> >> +static inline void rcu_read_lock_preempt(struct rcu_task_preempt *rcu_task)
> >> +{
> >> +	rcu_task->nesting++;
> >> +	barrier();
> >> +}
> >> +
> >> +static inline void rcu_read_unlock_preempt(struct rcu_task_preempt *rcu_task)
> >> +{
> >> +	int nesting = rcu_task->nesting;
> >> +
> >> +	if (nesting == 1) {
> >> +		unsigned int flags;
> >> +
> >> +		barrier();
> >> +		flags = ACCESS_ONCE(rcu_task->flags);
> >> +
> >> +		if ((flags & RCURING_PREEMPT_FLAGS) == RCURING_PREEMPT_FLAGS) {
> >> +			flags &= ~RCURING_PREEMPT_QS;
> >> +			ACCESS_ONCE(rcu_task->flags) = flags;
> >> +		}
> >> +	}
> >> +
> >> +	barrier();
> >> +	rcu_task->nesting = nesting - 1;
> >> +}
> >> +
> >> +#ifdef CONFIG_RCURING_PREEMPT
> >> +
> >> +#ifdef __GENARATING_OFFSETS__
> >> +#define task_rcu_preempt(p) ((struct rcu_task_preempt *)NULL)
> > 
> > The above looks a bit strange.  The idea is that if you were generating
> > offsets for the fields within rcu_task_preempt, you would select the
> > fields?  Something like the following?
> 
> when  __GENARATING_OFFSETS__, no one really use task_rcu_preempt(),
> it just for avoiding the compiling warnings.
> 
> > 
> > #define example_offset(p) &(((struct rcu_task_preempt *)NULL)->field_a)
> > 
> >> +#else
> >> +#include <generated/kernel-offsets.h>
> >> +#define task_rcu_preempt(p)						\
> >> +	((struct rcu_task_preempt *)(((void *)p) + TASK_RCU_PREEMPT))
> >> +#endif
> >> +
> >> +#define current_rcu_preempt() task_rcu_preempt(current)
> >> +#define __rcu_read_lock() rcu_read_lock_preempt(current_rcu_preempt())
> >> +#define __rcu_read_unlock() rcu_read_unlock_preempt(current_rcu_preempt())
> >> +extern
> >> +void call_rcu_preempt(struct rcu_head *head, void (*func)(struct rcu_head *));
> >> +#define call_rcu call_rcu_preempt
> >> +extern void synchronize_rcu_preempt(void);
> >> +#define synchronize_rcu synchronize_rcu_preempt
> >> +extern void synchronize_rcu_preempt_expedited(void);
> >> +#define synchronize_rcu_expedited synchronize_rcu_preempt_expedited
> >> +extern long rcu_batches_completed_preempt(void);
> >> +#define rcu_batches_completed rcu_batches_completed_preempt
> >> +extern void rcu_barrier_preempt(void);
> >> +#define rcu_barrier rcu_barrier_preempt
> >> +extern void rcu_preempt_force_quiescent_state(void);
> >> +#define rcu_force_quiescent_state rcu_preempt_force_quiescent_state
> >> +
> >> +struct task_struct;
> >> +static inline void rcu_copy_process(struct task_struct *p)
> >> +{
> >> +	struct rcu_task_preempt *rcu_task = task_rcu_preempt(p);
> >> +
> >> +	rcu_task->nesting = 0;
> >> +	rcu_task->flags = 0;
> >> +}
> >> +
> >> +static inline void exit_rcu(void)
> >> +{
> >> +	if (current_rcu_preempt()->nesting) {
> >> +		WARN_ON(1);
> >> +		current_rcu_preempt()->nesting = 0;
> > 
> > If the RCU core was waiting on this task, how does it learn that this
> > task is no longer blocking the current grace period(s)?
> 
> A schedule() will be called after exit_rcu(), and RCU core collect infos
> when task do schedule().
> 
> > 
> >> +	}
> >> +}
> >> +
> >> +#else /*CONFIG_RCURING_PREEMPT */
> >> +
> >> +#define __rcu_read_lock() __rcu_read_lock_sched();
> >> +#define __rcu_read_unlock() __rcu_read_unlock_sched();
> >> +#define call_rcu call_rcu_sched
> >> +#define synchronize_rcu synchronize_rcu_sched
> >> +#define synchronize_rcu_expedited synchronize_rcu_sched_expedited
> >> +#define rcu_batches_completed rcu_batches_completed_sched
> >> +#define rcu_barrier rcu_barrier_sched
> >> +#define rcu_force_quiescent_state rcu_sched_force_quiescent_state
> >> +
> >> +static inline void rcu_copy_process(struct task_struct *p) {}
> >> +static inline void exit_rcu(void) {}
> >> +#endif /* CONFIG_RCURING_PREEMPT */
> >> +
> >> +#ifdef CONFIG_NO_HZ
> >> +extern void rcu_kernel_enter(void);
> >> +extern void rcu_kernel_exit(void);
> >> +
> >> +static inline void rcu_nmi_enter(void) { rcu_kernel_enter(); }
> >> +static inline void rcu_nmi_exit(void) { rcu_kernel_exit(); }
> >> +static inline void rcu_irq_enter(void) { rcu_kernel_enter(); }
> >> +static inline void rcu_irq_exit(void) { rcu_kernel_exit(); }
> >> +extern void rcu_enter_nohz(void);
> >> +extern void rcu_exit_nohz(void);
> >> +#else
> >> +static inline void rcu_nmi_enter(void) {}
> >> +static inline void rcu_nmi_exit(void) {}
> >> +static inline void rcu_irq_enter(void) {}
> >> +static inline void rcu_irq_exit(void) {}
> >> +static inline void rcu_enter_nohz(void) {}
> >> +static inline void rcu_exit_nohz(void) {}
> >> +#endif
> >> +
> >> +extern int rcu_needs_cpu(int cpu);
> >> +extern void rcu_check_callbacks(int cpu, int user);
> >> +
> >> +extern void rcu_scheduler_starting(void);
> >> +extern int rcu_scheduler_active __read_mostly;
> >> +
> >> +#endif /* __LINUX_RCURING_H */
> >> diff --git a/include/linux/sched.h b/include/linux/sched.h
> >> index e18473f..15b332d 100644
> >> --- a/include/linux/sched.h
> >> +++ b/include/linux/sched.h
> >> @@ -1211,6 +1211,10 @@ struct task_struct {
> >>  	struct rcu_node *rcu_blocked_node;
> >>  #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> >>
> >> +#ifdef CONFIG_RCURING_PREEMPT
> >> +	struct rcu_task_preempt rcu_task_preempt;
> >> +#endif
> >> +
> >>  #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
> >>  	struct sched_info sched_info;
> >>  #endif
> >> @@ -1757,7 +1761,7 @@ static inline void rcu_copy_process(struct task_struct *p)
> >>  	INIT_LIST_HEAD(&p->rcu_node_entry);
> >>  }
> >>
> >> -#else
> >> +#elif !defined(CONFIG_RCURING)
> >>
> >>  static inline void rcu_copy_process(struct task_struct *p)
> >>  {
> >> diff --git a/init/Kconfig b/init/Kconfig
> >> index a619a1a..48e58d9 100644
> >> --- a/init/Kconfig
> >> +++ b/init/Kconfig
> >> @@ -374,6 +374,9 @@ config TINY_PREEMPT_RCU
> >>  	  for real-time UP systems.  This option greatly reduces the
> >>  	  memory footprint of RCU.
> >>
> >> +config RCURING
> >> +	bool "Multi-GP ring based RCU"
> >> +
> >>  endchoice
> >>
> >>  config PREEMPT_RCU
> >> @@ -450,6 +453,35 @@ config TREE_RCU_TRACE
> >>  	  TREE_PREEMPT_RCU implementations, permitting Makefile to
> >>  	  trivially select kernel/rcutree_trace.c.
> >>
> >> +config RCURING_BH
> >> +	bool "RCU for bh"
> >> +	default y
> >> +	depends on RCURING && !PREEMPT_RT
> >> +	help
> >> +	  If Y, use a independent rcu domain for rcu_bh.
> >> +	  If N, rcu_bh will map to rcu_sched(except rcu_read_lock_bh,
> >> +	  rcu_read_unlock_bh).
> > 
> > If I understand correctly, "N" defeats the purpose of bh, which is to
> > have faster grace periods -- not having to wait for a context switch.
> 
> I remembered, BH is for defeating DOS, so somebody will not need
> rcu domain for BH if he don't care this kind of DOS.
> 
> > 
> >> +
> >> +config RCURING_BH_PREEMPT
> >> +	bool
> >> +	depends on PREEMPT_RT
> >> +	help
> >> +	  rcu_bh will map to rcu_preempt.
> > 
> > If I understand what you are doing, this config option will break
> > networking.
> 
> In PREEMPT_RT, BH will be preemptible. but RCURING_BH_PREEMPT
> is not used here, will be removed.
> 
> > 
> >> +
> >> +config RCURING_PREEMPT
> >> +	bool "RCURING based reemptible RCU"
> >> +	default n
> >> +	depends on RCURING && PREEMPT
> >> +	help
> >> +	  If Y, normal rcu functionality will map to rcu_preempt.
> >> +	  If N, normal rcu functionality will map to rcu_sched.
> >> +
> >> +config RCURING_COUNTERS_SHIFT
> >> +	int "RCURING's counter shift"
> >> +	range 1 10
> >> +	depends on RCURING
> >> +	default 4
> >> +
> >>  endmenu # "RCU Subsystem"
> >>
> >>  config IKCONFIG
> >> diff --git a/kernel/Makefile b/kernel/Makefile
> >> index 92b7420..66eab8c 100644
> >> --- a/kernel/Makefile
> >> +++ b/kernel/Makefile
> >> @@ -86,6 +86,7 @@ obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
> >>  obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
> >>  obj-$(CONFIG_TINY_RCU) += rcutiny.o
> >>  obj-$(CONFIG_TINY_PREEMPT_RCU) += rcutiny.o
> >> +obj-$(CONFIG_RCURING) += rcuring.o
> >>  obj-$(CONFIG_RELAY) += relay.o
> >>  obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
> >>  obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
> >> diff --git a/kernel/kernel-offsets.c b/kernel/kernel-offsets.c
> >> new file mode 100644
> >> index 0000000..0d30817
> >> --- /dev/null
> >> +++ b/kernel/kernel-offsets.c
> >> @@ -0,0 +1,20 @@
> >> +/*
> >> + * Generate definitions needed by assembly language modules.
> >> + *
> >> + * Copyright (C) 2008-2010 Lai Jiangshan
> >> + */
> >> +
> >> +#define __GENERATING_KERNEL_OFFSETS__
> >> +#include <linux/rcupdate.h>
> >> +#include <linux/sched.h>
> >> +#include <linux/kbuild.h>
> >> +
> >> +void foo(void);
> >> +
> >> +void foo(void)
> >> +{
> >> +#ifdef CONFIG_RCURING_PREEMPT
> >> +	OFFSET(TASK_RCU_PREEMPT, task_struct, rcu_task_preempt);
> >> +#endif
> >> +}
> >> +
> >> diff --git a/kernel/rcuring.c b/kernel/rcuring.c
> >> new file mode 100644
> >> index 0000000..e7cedb5
> >> --- /dev/null
> >> +++ b/kernel/rcuring.c
> >> @@ -0,0 +1,1002 @@
> >> +/*
> >> + * Read-Copy Update mechanism for mutual exclusion
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published by
> >> + * the Free Software Foundation; either version 2 of the License, or
> >> + * (at your option) any later version.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + *
> >> + * You should have received a copy of the GNU General Public License
> >> + * along with this program; if not, write to the Free Software
> >> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> >> + *
> >> + * Copyright IBM Corporation, 2008
> >> + * Copyright Fujitsu 2008-2010 Lai Jiangshan
> >> + *
> >> + * Authors: Dipankar Sarma <dipankar@in.ibm.com>
> >> + *	    Manfred Spraul <manfred@colorfullife.com>
> >> + *	    Paul E. McKenney <paulmck@linux.vnet.ibm.com> Hierarchical version
> >> + *	    Lai Jiangshan <laijs@cn.fujitsu.com> RCURING version
> >> + */
> >> +
> >> +#include <linux/rcupdate.h>
> >> +#include <linux/percpu.h>
> >> +#include <asm/atomic.h>
> >> +#include <linux/spinlock.h>
> >> +#include <linux/module.h>
> >> +#include <linux/interrupt.h>
> >> +#include <linux/cpu.h>
> >> +
> >> +#define RCURING_IDX_SHIFT	CONFIG_RCURING_COUNTERS_SHIFT
> >> +#define RCURING_IDX_MAX		(1L << RCURING_IDX_SHIFT)
> >> +#define RCURING_IDX_MASK	(RCURING_IDX_MAX - 1)
> >> +#define RCURING_IDX(complete)	((complete) & RCURING_IDX_MASK)
> >> +
> >> +struct rcuring {
> >> +	atomic_t	ctr[RCURING_IDX_MAX];
> >> +	long		curr_complete;
> >> +	long		done_complete;
> >> +
> >> +	raw_spinlock_t	lock;
> >> +};
> >> +
> >> +/* It is long history that we use -300 as an initial complete */
> >> +#define RCURING_INIT_COMPLETE	-300L
> >> +#define RCURING_INIT(name)						\
> >> +{									\
> >> +	{[RCURING_IDX(RCURING_INIT_COMPLETE)] = ATOMIC_INIT(1),},	\
> >> +	RCURING_INIT_COMPLETE,						\
> >> +	RCURING_INIT_COMPLETE - 1,					\
> >> +	__RAW_SPIN_LOCK_UNLOCKED(name.lock),				\
> > 
> > Please use the gcc-style initializers here.
> 
> I will be use gcc-style initializers in next version.
> 
> > 
> >> +}
> >> +
> >> +static inline
> >> +int rcuring_ctr_read(struct rcuring *rr, unsigned long complete)
> >> +{
> >> +	int res;
> >> +
> >> +	/* atomic_read() does not ensure to imply barrier(). */
> >> +	barrier();
> >> +	res = atomic_read(rr->ctr + RCURING_IDX(complete));
> >> +	barrier();
> >> +
> >> +	return res;
> >> +}
> >> +
> >> +void __rcuring_advance_done_complete(struct rcuring *rr)
> >> +{
> >> +	long wait_complete = rr->done_complete + 1;
> >> +
> >> +	if (!rcuring_ctr_read(rr, wait_complete)) {
> >> +		do {
> >> +			wait_complete++;
> >> +		} while (!rcuring_ctr_read(rr, wait_complete));
> >> +
> >> +		ACCESS_ONCE(rr->done_complete) = wait_complete - 1;
> >> +	}
> >> +}
> > 
> > For a given grace period, all quiescent states hit the same counter.
> > Or am I missing something?
> 
> No. see the top of this email.
> 
> > 
> >> +
> >> +static inline
> >> +int rcuring_could_advance_done_complete(struct rcuring *rr)
> >> +{
> >> +	return !rcuring_ctr_read(rr, rr->done_complete + 1);
> >> +}
> >> +
> >> +static inline
> >> +void rcuring_advance_done_complete(struct rcuring *rr)
> >> +{
> >> +	if (rcuring_could_advance_done_complete(rr)) {
> >> +		if (__raw_spin_trylock(&rr->lock)) {
> >> +			__rcuring_advance_done_complete(rr);
> >> +			__raw_spin_unlock(&rr->lock);
> >> +		}
> >> +	}
> >> +}
> >> +
> >> +void __rcuring_advance_curr_complete(struct rcuring *rr, long next_complete)
> >> +{
> >> +	long curr_complete = rr->curr_complete;
> >> +
> >> +	if (curr_complete + 1 == next_complete) {
> >> +		if (!rcuring_ctr_read(rr, next_complete)) {
> >> +			ACCESS_ONCE(rr->curr_complete) = next_complete;
> >> +			smp_mb__before_atomic_inc();
> >> +			atomic_inc(rr->ctr + RCURING_IDX(next_complete));
> >> +			smp_mb__after_atomic_inc();
> >> +			atomic_dec(rr->ctr + RCURING_IDX(curr_complete));
> >> +		}
> >> +	}
> >> +}
> >> +
> >> +static inline
> >> +int rcuring_could_advance_complete(struct rcuring *rr, long next_complete)
> >> +{
> >> +	if (rcuring_could_advance_done_complete(rr))
> >> +		return 1;
> >> +
> >> +	if (rr->curr_complete + 1 == next_complete) {
> >> +		if (!rcuring_ctr_read(rr, next_complete))
> >> +			return 1;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static inline
> >> +void rcuring_advance_complete(struct rcuring *rr, long next_complete)
> >> +{
> >> +	if (rcuring_could_advance_complete(rr, next_complete)) {
> >> +		if (__raw_spin_trylock(&rr->lock)) {
> >> +			__rcuring_advance_done_complete(rr);
> >> +			__rcuring_advance_curr_complete(rr, next_complete);
> >> +			__raw_spin_unlock(&rr->lock);
> >> +		}
> >> +	}
> >> +}
> >> +
> >> +static inline
> >> +void rcuring_advance_complete_force(struct rcuring *rr, long next_complete)
> >> +{
> >> +	if (rcuring_could_advance_complete(rr, next_complete)) {
> >> +		__raw_spin_lock(&rr->lock);
> >> +		__rcuring_advance_done_complete(rr);
> >> +		__rcuring_advance_curr_complete(rr, next_complete);
> >> +		__raw_spin_unlock(&rr->lock);
> >> +	}
> >> +}
> >> +
> >> +static inline long __locked_complete_adjust(int locked_idx, long complete)
> >> +{
> >> +	long locked_complete;
> >> +
> >> +	locked_complete = (complete & ~RCURING_IDX_MASK) | (long)locked_idx;
> >> +	if (locked_complete - complete <= 0)
> >> +		return locked_complete;
> >> +	else
> >> +		return locked_complete - RCURING_IDX_MAX;
> >> +}
> >> +
> >> +static long rcuring_lock(struct rcuring *rr)
> >> +{
> >> +	long locked_complete;
> >> +	int idx;
> >> +
> >> +	for (;;) {
> >> +		idx = RCURING_IDX(ACCESS_ONCE(rr->curr_complete));
> >> +		if (likely(atomic_inc_not_zero(rr->ctr + idx)))
> >> +			break;
> >> +	}
> >> +	smp_mb__after_atomic_inc();
> >> +
> >> +	locked_complete = ACCESS_ONCE(rr->curr_complete);
> >> +	if (likely(RCURING_IDX(locked_complete) == idx))
> >> +		return locked_complete;
> >> +	else
> >> +		return __locked_complete_adjust(idx, locked_complete);
> >> +}
> >> +
> >> +static void rcuring_unlock(struct rcuring *rr, long locked_complete)
> >> +{
> >> +	smp_mb__before_atomic_dec();
> >> +
> >> +	atomic_dec(rr->ctr + RCURING_IDX(locked_complete));
> >> +}
> >> +
> >> +static inline
> >> +void rcuring_dup_lock(struct rcuring *rr, long locked_complete)
> >> +{
> >> +	atomic_inc(rr->ctr + RCURING_IDX(locked_complete));
> >> +}
> >> +
> >> +static inline
> >> +long rcuring_advance_lock(struct rcuring *rr, long locked_complete)
> >> +{
> >> +	long new_locked_complete = locked_complete;
> >> +
> >> +	if (locked_complete != rr->curr_complete) {
> >> +		/*
> >> +		 * Lock the new complete at first, and then release
> >> +		 * the old one. It prevents errors when NMI/SMI occurs
> >> +		 * after rcuring_unlock() - we still lock it.
> >> +		 */
> >> +		new_locked_complete = rcuring_lock(rr);
> >> +		rcuring_unlock(rr, locked_complete);
> >> +	}
> >> +
> >> +	return new_locked_complete;
> >> +}
> >> +
> >> +static inline long rcuring_get_done_complete(struct rcuring *rr)
> >> +{
> >> +	return ACCESS_ONCE(rr->done_complete);
> >> +}
> >> +
> >> +static inline long rcuring_get_curr_complete(struct rcuring *rr)
> >> +{
> >> +	return ACCESS_ONCE(rr->curr_complete);
> >> +}
> >> +
> >> +struct rcu_batch {
> >> +	struct rcu_head *list, **tail;
> >> +};
> >> +
> >> +static void rcu_batch_merge(struct rcu_batch *to, struct rcu_batch *from)
> >> +{
> >> +	if (from->list != NULL) {
> >> +		*to->tail = from->list;
> >> +		to->tail = from->tail;
> >> +
> >> +		from->list = NULL;
> >> +		from->tail = &from->list;
> >> +	}
> >> +}
> >> +
> >> +static void rcu_batch_add(struct rcu_batch *batch, struct rcu_head *new)
> >> +{
> >> +	*batch->tail = new;
> >> +	batch->tail = &new->next;
> >> +}
> >> +
> >> +struct rcu_data {
> >> +	long locked_complete;
> >> +
> >> +	/*
> >> +	 * callbacks are in batches (done_complete, curr_complete]
> >> +	 * curr_complete - done_complete >= 0
> >> +	 * curr_complete - done_complete <= RCURING_IDX_MAX
> >> +	 * domain's curr_complete - curr_complete >= 0
> >> +	 * domain's done_complete - done_complete >= 0
> >> +	 *
> >> +	 * curr_complete == done_complete just means @batch is empty.
> >> +	 * we have at least one callback in batch[RCURING_IDX(done_complete)]
> >> +	 * if curr_complete != done_complete
> >> +	 */
> >> +	long curr_complete;
> >> +	long done_complete;
> >> +
> >> +	struct rcu_batch batch[RCURING_IDX_MAX];
> >> +	struct rcu_batch done_batch;
> >> +
> >> +	unsigned int qlen;
> >> +	unsigned long jiffies;
> >> +	unsigned long stall_jiffies;
> >> +};
> >> +
> >> +struct rcu_domain {
> >> +	struct rcuring rcuring;
> >> +	const char *domain_name;
> >> +	struct rcu_data __percpu *rcu_data;
> >> +
> >> +	spinlock_t lock; /* this lock is for fqs or other misc things */
> >> +	long fqs_complete;
> >> +	void (*force_quiescent_state)(struct rcu_domain *domain,
> >> +			long fqs_complete);
> >> +};
> >> +
> >> +#define EXPEDITED_GP_RESERVED_RECOMMEND (RCURING_IDX_SHIFT - 1)
> >> +
> >> +static inline long gp_reserved(struct rcu_domain *domain)
> >> +{
> >> +	return EXPEDITED_GP_RESERVED_RECOMMEND;
> >> +}
> >> +
> >> +static inline void __init rcu_data_init(struct rcu_data *rdp)
> >> +{
> >> +	int idx;
> >> +
> >> +	for (idx = 0; idx < RCURING_IDX_MAX; idx++)
> >> +		rdp->batch[idx].tail = &rdp->batch[idx].list;
> >> +
> >> +	rdp->done_batch.tail = &rdp->done_batch.list;
> >> +}
> >> +
> >> +static void do_advance_callbacks(struct rcu_data *rdp, long done_complete)
> >> +{
> >> +	int idx;
> >> +
> >> +	while (rdp->done_complete != done_complete) {
> >> +		rdp->done_complete++;
> >> +		idx = RCURING_IDX(rdp->done_complete);
> >> +		rcu_batch_merge(&rdp->done_batch, rdp->batch + idx);
> >> +	}
> >> +}
> >> +
> >> +/* Is value in the range (@left_open, @right_close] */
> >> +static inline bool in_range(long left_open, long right_close, long value)
> >> +{
> >> +	return left_open - value < 0 && value - right_close <= 0;
> >> +}
> >> +
> >> +static void advance_callbacks(struct rcu_data *rdp, long done_complete,
> >> +		long curr_complete)
> >> +{
> >> +	if (in_range(done_complete, curr_complete, rdp->curr_complete)) {
> >> +		do_advance_callbacks(rdp, done_complete);
> >> +	} else {
> >> +		do_advance_callbacks(rdp, rdp->curr_complete);
> >> +		rdp->curr_complete = done_complete;
> >> +		rdp->done_complete = done_complete;
> >> +	}
> >> +}
> >> +
> >> +static void __force_quiescent_state(struct rcu_domain *domain,
> >> +		long fqs_complete)
> >> +{
> >> +	int cpu;
> >> +	long fqs_complete_old;
> >> +	long curr_complete = rcuring_get_curr_complete(&domain->rcuring);
> >> +	long done_complete = rcuring_get_done_complete(&domain->rcuring);
> >> +
> >> +	spin_lock(&domain->lock);
> >> +
> >> +	fqs_complete_old = domain->fqs_complete;
> >> +	if (!in_range(done_complete, curr_complete, fqs_complete_old))
> >> +		fqs_complete_old = done_complete;
> >> +
> >> +	if (fqs_complete_old - fqs_complete >= 0) {
> >> +		spin_unlock(&domain->lock);
> >> +		return;
> >> +	}
> >> +
> >> +	domain->fqs_complete = fqs_complete;
> >> +	spin_unlock(&domain->lock);
> >> +
> >> +	for_each_online_cpu(cpu) {
> >> +		struct rcu_data *rdp = per_cpu_ptr(domain->rcu_data, cpu);
> >> +		long locked_complete = ACCESS_ONCE(rdp->locked_complete);
> >> +
> >> +		if (!in_range(fqs_complete_old, fqs_complete, locked_complete))
> >> +			continue;
> > 
> > Is preemption disabled here?
> 
> Yes, it called with local irq disabled.
> 
> > 
> >> +
> >> +		if (cpu == smp_processor_id())
> >> +			set_tsk_need_resched(current);
> >> +		else
> >> +			smp_send_reschedule(cpu);
> >> +	}
> >> +}
> >> +
> >> +static void force_quiescent_state(struct rcu_domain *domain, long fqs_complete)
> >> +{
> >> +	domain->force_quiescent_state(domain, fqs_complete);
> >> +}
> >> +
> >> +static
> >> +long prepare_for_new_callback(struct rcu_domain *domain, struct rcu_data *rdp)
> >> +{
> >> +	long curr_complete, done_complete;
> >> +	struct rcuring *rr = &domain->rcuring;
> >> +
> >> +	smp_mb();
> >> +	curr_complete = rcuring_get_curr_complete(rr);
> >> +	done_complete = rcuring_get_done_complete(rr);
> >> +
> >> +	advance_callbacks(rdp, done_complete, curr_complete);
> >> +	rdp->curr_complete = curr_complete;
> >> +
> >> +	if (!rdp->qlen) {
> >> +		rdp->jiffies = jiffies;
> >> +		rdp->stall_jiffies = jiffies;
> >> +	}
> >> +
> >> +	return curr_complete;
> >> +}
> >> +
> >> +static long __call_rcu(struct rcu_domain *domain, struct rcu_head *head,
> >> +		void (*func)(struct rcu_head *))
> >> +{
> >> +	struct rcu_data *rdp;
> >> +	long curr_complete;
> >> +
> >> +	head->next = NULL;
> >> +	head->func = func;
> >> +
> >> +	rdp = this_cpu_ptr(domain->rcu_data);
> >> +	curr_complete = prepare_for_new_callback(domain, rdp);
> >> +	rcu_batch_add(rdp->batch + RCURING_IDX(curr_complete), head);
> >> +	rdp->qlen++;
> >> +
> >> +	return curr_complete;
> >> +}
> >> +
> >> +static void print_rcuring_stall(struct rcu_domain *domain)
> >> +{
> >> +	struct rcuring *rr = &domain->rcuring;
> >> +	unsigned long curr_complete = rcuring_get_curr_complete(rr);
> >> +	unsigned long done_complete = rcuring_get_done_complete(rr);
> >> +	int cpu;
> >> +
> >> +	printk(KERN_ERR "RCU is stall, cpu=%d, domain_name=%s\n", smp_processor_id(),
> >> +			domain->domain_name);
> >> +
> >> +	printk(KERN_ERR "domain's complete(done/curr)=%ld/%ld\n",
> >> +			curr_complete, done_complete);
> >> +	printk(KERN_ERR "curr_ctr=%d, wait_ctr=%d\n",
> >> +			rcuring_ctr_read(rr, curr_complete),
> >> +			rcuring_ctr_read(rr, done_complete + 1));
> >> +
> >> +	for_each_online_cpu(cpu) {
> >> +		struct rcu_data *rdp = per_cpu_ptr(domain->rcu_data, cpu);
> >> +		printk(KERN_ERR "cpu=%d, qlen=%d, complete(locked/dome/curr/)="
> >> +				"%ld/%ld/%ld\n", cpu, rdp->qlen,
> >> +				rdp->locked_complete, rdp->done_complete,
> >> +				rdp->curr_complete);
> >> +	}
> >> +}
> >> +
> >> +static void __rcu_check_callbacks(struct rcu_domain *domain,
> >> +		struct rcu_data *rdp, int in_rcu_softirq)
> >> +{
> >> +	long curr_complete, done_complete;
> >> +	struct rcuring *rr = &domain->rcuring;
> >> +
> >> +	if (!rdp->qlen)
> >> +		return;
> >> +
> >> +	rcuring_advance_done_complete(rr);
> >> +
> >> +	curr_complete = rcuring_get_curr_complete(rr);
> >> +	done_complete = ACCESS_ONCE(rr->done_complete);
> >> +	advance_callbacks(rdp, done_complete, curr_complete);
> >> +
> >> +	if (rdp->curr_complete == curr_complete
> >> +			&& rdp->batch[RCURING_IDX(rdp->curr_complete)].list) {
> >> +		long max_gp_allow = RCURING_IDX_MAX - gp_reserved(domain);
> >> +
> >> +		if (curr_complete - done_complete <= max_gp_allow)
> >> +			rcuring_advance_complete(rr, curr_complete + 1);
> >> +	}
> >> +
> >> +	if (rdp->done_batch.list) {
> >> +		if (!in_rcu_softirq)
> >> +			raise_softirq(RCU_SOFTIRQ);
> >> +	} else {
> >> +		if (jiffies - rdp->jiffies > 10) {
> >> +			force_quiescent_state(domain, rdp->curr_complete);
> >> +			rdp->jiffies = jiffies;
> >> +		}
> >> +		if (jiffies - rdp->stall_jiffies > 2 * HZ) {
> >> +			print_rcuring_stall(domain);
> >> +			rdp->stall_jiffies = jiffies;
> >> +		}
> >> +	}
> >> +}
> >> +
> >> +static void rcu_do_batch(struct rcu_domain *domain, struct rcu_data *rdp)
> >> +{
> >> +	int count = 0;
> >> +	struct rcu_head *list, *next;
> >> +
> >> +	list = rdp->done_batch.list;
> >> +
> >> +	if (list) {
> >> +		rdp->done_batch.list = NULL;
> >> +		rdp->done_batch.tail = &rdp->done_batch.list;
> >> +
> >> +		local_irq_enable();
> >> +
> >> +		smp_mb();
> >> +
> >> +		while (list) {
> >> +			next = list->next;
> >> +			prefetch(next);
> >> +			list->func(list);
> >> +			count++;
> >> +			list = next;
> >> +		}
> >> +		local_irq_disable();
> >> +
> >> +		rdp->qlen -= count;
> >> +		rdp->jiffies = jiffies;
> >> +	}
> >> +}
> >> +
> >> +static int __rcu_needs_cpu(struct rcu_data *rdp)
> >> +{
> >> +	return !!rdp->qlen;
> >> +}
> >> +
> >> +static inline
> >> +void __rcu_qsctr_inc(struct rcu_domain *domain, struct rcu_data *rdp)
> >> +{
> >> +	rdp->locked_complete = rcuring_advance_lock(&domain->rcuring,
> >> +			rdp->locked_complete);
> >> +}
> >> +
> >> +static inline void rcu_preempt_save_complete(struct rcu_task_preempt *rcu_task,
> >> +		long locked_complete)
> >> +{
> >> +	unsigned int new_flags;
> >> +
> >> +	new_flags = RCURING_PREEMPT_FLAGS | RCURING_IDX(locked_complete);
> >> +	ACCESS_ONCE(rcu_task->flags) = new_flags;
> >> +}
> >> +
> >> +/*
> >> + * Every cpu hold a lock_complete. But for preempt rcu, any task may also
> >> + * hold a lock_complete. This function increases lock_complete for the current
> >> + * cpu and check(dup_lock_and_save or release or advance) the lock_complete of
> >> + * the current task.
> >> + */
> >> +static inline
> >> +void __rcu_preempt_qsctr_inc(struct rcu_domain *domain, struct rcu_data *rdp,
> >> +		struct rcu_task_preempt *rcu_task)
> >> +{
> >> +	long locked_complete = rdp->locked_complete;
> >> +	unsigned int flags = ACCESS_ONCE(rcu_task->flags);
> >> +
> >> +	if (!(flags & RCURING_PREEMPT_SAVED)) {
> >> +		BUG_ON(flags & RCURING_PREEMPT_QS);
> >> +		if (rcu_task->nesting) {
> >> +			/* dup_lock_and_save current task's lock_complete */
> >> +			rcuring_dup_lock(&domain->rcuring, locked_complete);
> >> +			rcu_preempt_save_complete(rcu_task, locked_complete);
> >> +		}
> >> +	} else if (!(rcu_task->nesting)) {
> >> +		/* release current task's lock_complete */
> >> +		rcuring_unlock(&domain->rcuring, (long)flags);
> >> +		ACCESS_ONCE(rcu_task->flags) = 0;
> >> +	} else if (!(flags & RCURING_PREEMPT_QS)) {
> >> +		/* advance_and_save current task's lock_complete */
> >> +		if (RCURING_IDX(locked_complete) != RCURING_IDX((long)flags)) {
> >> +			rcuring_unlock(&domain->rcuring, (long)flags);
> >> +			rcuring_dup_lock(&domain->rcuring, locked_complete);
> >> +		}
> >> +		rcu_preempt_save_complete(rcu_task, locked_complete);
> >> +	}
> >> +
> >> +	/* increases lock_complete for the current cpu */
> >> +	rdp->locked_complete = rcuring_advance_lock(&domain->rcuring,
> >> +			locked_complete);
> >> +}
> > 
> > When we need to boost the priority of preempted readers, how do we tell
> > who they are?
> 
> And struct list_head in struct rcu_task_preempt, and a ring struct list_head
> in rdp, and use percpu locks or scheduler's runqueues's locks
> protect all these struct list_head.
> 
> > 
> >> +
> >> +static void __synchronize_rcu(struct rcu_domain *domain, int expedited)
> >> +{
> >> +	struct rcu_synchronize rcu;
> >> +	long complete;
> >> +
> >> +	init_completion(&rcu.completion);
> >> +
> >> +	local_irq_disable();
> >> +	complete = __call_rcu(domain, &rcu.head, wakeme_after_rcu);
> >> +
> >> +	if (expedited) {
> >> +		/*
> >> +		 * Fore a new gp to be started immediately(can use reserved gp).
> >> +		 * But if all gp are used, it will fail to start new gp,
> >> +		 * and we have to wait until some new gps available.
> >> +		 */
> >> +		rcuring_advance_complete_force(&domain->rcuring,
> >> +				complete + 1);
> > 
> > It looks to me like rcuring_advance_complete_force() can just fail
> > silently.  How does this work?
> 
> If it fails, We have no GPs lefts, synchronize_rcu_expedited()
> will becomes synchronize_rcu(). the next fqs will expedite it only a little.
> 
> It's OK, we have 3 reserved GPs by default, It means we allows 3
> synchronize_rcu_expedited()s concurrent at least and it's enough.
> 
> > 
> >> +
> >> +		/* Fore qs and expedite the new gp */
> >> +		force_quiescent_state(domain, complete);
> >> +	}
> >> +	local_irq_enable();
> >> +
> >> +	wait_for_completion(&rcu.completion);
> >> +}
> >> +
> >> +static inline long __rcu_batches_completed(struct rcu_domain *domain)
> >> +{
> >> +	return rcuring_get_done_complete(&domain->rcuring);
> >> +}
> >> +
> >> +#ifdef CONFIG_RCURING_BH
> >> +#define gen_code_for_bh(gen_code, args...) gen_code(bh, ##args)
> > 
> > Where is gen_code() defined?
> > 
> >> +#else
> >> +#define gen_code_for_bh(gen_code, args...)
> >> +#endif
> >> +#define gen_code_for_sched(gen_code, args...) gen_code(sched, ##args)
> >> +#ifdef CONFIG_RCURING_PREEMPT
> >> +#define gen_code_for_preempt(gen_code, args...) gen_code(preempt, ##args)
> >> +#else
> >> +#define gen_code_for_preempt(gen_code, args...)
> >> +#endif
> >> +
> >> +#define GEN_CODES(gen_code, args...)			\
> >> +	gen_code_for_bh(gen_code, ##args)		\
> >> +	gen_code_for_sched(gen_code, ##args)		\
> >> +	gen_code_for_preempt(gen_code, ##args)		\
> >> +
> >> +#define gen_basic_code(domain)						\
> >> +									\
> >> +static void force_quiescent_state_##domain(struct rcu_domain *domain,	\
> >> +		long fqs_complete);					\
> >> +									\
> >> +static DEFINE_PER_CPU(struct rcu_data, rcu_data_##domain);		\
> >> +									\
> >> +struct rcu_domain rcu_domain_##domain =					\
> >> +{									\
> >> +	.rcuring = RCURING_INIT(rcu_domain_##domain.rcuring),		\
> >> +	.domain_name = #domain,						\
> >> +	.rcu_data = &rcu_data_##domain,					\
> >> +	.lock = __SPIN_LOCK_UNLOCKED(rcu_domain_##domain.lock),		\
> >> +	.force_quiescent_state = force_quiescent_state_##domain,	\
> >> +};									\
> >> +									\
> >> +void call_rcu_##domain(struct rcu_head *head,				\
> >> +		void (*func)(struct rcu_head *))			\
> >> +{									\
> >> +	unsigned long flags;						\
> >> +									\
> >> +	local_irq_save(flags);						\
> >> +	__call_rcu(&rcu_domain_##domain, head, func);			\
> >> +	local_irq_restore(flags);					\
> >> +}									\
> >> +EXPORT_SYMBOL_GPL(call_rcu_##domain);					\
> >> +									\
> >> +void synchronize_rcu_##domain(void)					\
> >> +{									\
> >> +	__synchronize_rcu(&rcu_domain_##domain, 0);			\
> >> +}									\
> >> +EXPORT_SYMBOL_GPL(synchronize_rcu_##domain);				\
> >> +									\
> >> +void synchronize_rcu_##domain##_expedited(void)				\
> >> +{									\
> >> +	__synchronize_rcu(&rcu_domain_##domain, 1);			\
> >> +}									\
> >> +EXPORT_SYMBOL_GPL(synchronize_rcu_##domain##_expedited);		\
> >> +									\
> >> +long rcu_batches_completed_##domain(void)				\
> >> +{									\
> >> +	return __rcu_batches_completed(&rcu_domain_##domain);		\
> >> +}									\
> >> +EXPORT_SYMBOL_GPL(rcu_batches_completed_##domain);			\
> >> +									\
> >> +void rcu_##domain##_force_quiescent_state(void)				\
> >> +{									\
> >> +	force_quiescent_state(&rcu_domain_##domain, 0);			\
> >> +}									\
> >> +EXPORT_SYMBOL_GPL(rcu_##domain##_force_quiescent_state);
> > 
> > I used to use a single macro for the synchronize_rcu*() APIs, but was
> > talked into separate functions.  Maybe some of the more ornate recent
> > macros have shifted people away from duplicate code in functions, so
> > might be time to try again.  ;-)
> 
> Too much dumplicated code, I have to do this :-)
> 
> > 
> >> +GEN_CODES(gen_basic_code)
> >> +
> >> +static DEFINE_PER_CPU(int, kernel_count);
> >> +
> >> +#define LOCK_COMPLETE(domain)						\
> >> +	long complete_##domain = rcuring_lock(&rcu_domain_##domain.rcuring);
> >> +#define SAVE_COMPLETE(domain)						\
> >> +	per_cpu(rcu_data_##domain, cpu).locked_complete = complete_##domain;
> >> +#define LOAD_COMPLETE(domain)						\
> >> +	int complete_##domain = per_cpu(rcu_data_##domain, cpu).locked_complete;
> >> +#define RELEASE_COMPLETE(domain)					\
> >> +	rcuring_unlock(&rcu_domain_##domain.rcuring, complete_##domain);
> >> +
> >> +static void __rcu_kernel_enter_outmost(int cpu)
> >> +{
> >> +	GEN_CODES(LOCK_COMPLETE)
> >> +
> >> +	barrier();
> >> +	per_cpu(kernel_count, cpu) = 1;
> >> +	barrier();
> >> +
> >> +	GEN_CODES(SAVE_COMPLETE)
> >> +}
> >> +
> >> +static void __rcu_kernel_exit_outmost(int cpu)
> >> +{
> >> +	GEN_CODES(LOAD_COMPLETE)
> >> +
> >> +	barrier();
> >> +	per_cpu(kernel_count, cpu) = 0;
> >> +	barrier();
> >> +
> >> +	GEN_CODES(RELEASE_COMPLETE)
> >> +}
> >> +
> >> +#ifdef CONFIG_RCURING_BH
> >> +static void force_quiescent_state_bh(struct rcu_domain *domain,
> >> +		long fqs_complete)
> >> +{
> >> +	__force_quiescent_state(domain, fqs_complete);
> >> +}
> >> +
> >> +static inline void rcu_bh_qsctr_inc_irqoff(int cpu)
> >> +{
> >> +	__rcu_qsctr_inc(&rcu_domain_bh, &per_cpu(rcu_data_bh, cpu));
> >> +}
> >> +
> >> +void rcu_bh_qs(int cpu)
> >> +{
> >> +	unsigned long flags;
> >> +
> >> +	local_irq_save(flags);
> >> +	rcu_bh_qsctr_inc_irqoff(cpu);
> >> +	local_irq_restore(flags);
> >> +}
> >> +
> >> +#else /* CONFIG_RCURING_BH */
> >> +static inline void rcu_bh_qsctr_inc_irqoff(int cpu) { (void)(cpu); }
> >> +#endif /* CONFIG_RCURING_BH */
> >> +
> >> +static void force_quiescent_state_sched(struct rcu_domain *domain,
> >> +		long fqs_complete)
> >> +{
> >> +	__force_quiescent_state(domain, fqs_complete);
> >> +}
> >> +
> >> +static inline void rcu_sched_qsctr_inc_irqoff(int cpu)
> >> +{
> >> +	__rcu_qsctr_inc(&rcu_domain_sched, &per_cpu(rcu_data_sched, cpu));
> >> +}
> >> +
> >> +#ifdef CONFIG_RCURING_PREEMPT
> >> +static void force_quiescent_state_preempt(struct rcu_domain *domain,
> >> +		long fqs_complete)
> >> +{
> >> +	/* To Be Implemented */
> >> +}
> >> +
> >> +static inline void rcu_preempt_qsctr_inc_irqoff(int cpu)
> >> +{
> >> +	__rcu_preempt_qsctr_inc(&rcu_domain_preempt,
> >> +			&per_cpu(rcu_data_preempt, cpu),
> >> +			&current->rcu_task_preempt);
> >> +}
> >> +
> >> +#else /* CONFIG_RCURING_PREEMPT */
> >> +static inline void rcu_preempt_qsctr_inc_irqoff(int cpu)
> >> +{
> >> +	(void)(cpu);
> >> +	(void)(__rcu_preempt_qsctr_inc);
> >> +}
> >> +#endif /* CONFIG_RCURING_PREEMPT */
> >> +
> >> +#define gen_needs_cpu(domain, cpu)					\
> >> +	if (__rcu_needs_cpu(&per_cpu(rcu_data_##domain, cpu)))		\
> >> +		return 1;
> >> +int rcu_needs_cpu(int cpu)
> >> +{
> >> +	GEN_CODES(gen_needs_cpu, cpu)
> >> +	return 0;
> >> +}
> >> +
> >> +#define call_func(domain, func, args...)				\
> >> +	func(&rcu_domain_##domain, &__get_cpu_var(rcu_data_##domain), ##args);
> >> +
> >> +/*
> >> + * Note a context switch. This is a quiescent state for RCU-sched,
> >> + * and requires special handling for preemptible RCU.
> >> + */
> >> +void rcu_note_context_switch(int cpu)
> >> +{
> >> +	unsigned long flags;
> >> +
> >> +#ifdef CONFIG_HOTPLUG_CPU
> >> +	/*
> >> +	 * The stoper thread need to schedule() to the idle thread
> >> +	 * after CPU_DYING.
> >> +	 */
> >> +	if (unlikely(!per_cpu(kernel_count, cpu))) {
> >> +		BUG_ON(cpu_online(cpu));
> >> +		return;
> >> +	}
> >> +#endif
> >> +
> >> +	local_irq_save(flags);
> >> +	rcu_bh_qsctr_inc_irqoff(cpu);
> >> +	rcu_sched_qsctr_inc_irqoff(cpu);
> >> +	rcu_preempt_qsctr_inc_irqoff(cpu);
> >> +	local_irq_restore(flags);
> >> +}
> >> +
> >> +static int rcu_cpu_idle(int cpu)
> >> +{
> >> +	return idle_cpu(cpu) && rcu_scheduler_active &&
> >> +		!in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT);
> >> +}
> >> +
> >> +void rcu_check_callbacks(int cpu, int user)
> >> +{
> >> +	unsigned long flags;
> >> +
> >> +	local_irq_save(flags);
> >> +
> >> +	if (user || rcu_cpu_idle(cpu)) {
> >> +		rcu_bh_qsctr_inc_irqoff(cpu);
> >> +		rcu_sched_qsctr_inc_irqoff(cpu);
> >> +		rcu_preempt_qsctr_inc_irqoff(cpu);
> >> +	} else if (!in_softirq())
> >> +		rcu_bh_qsctr_inc_irqoff(cpu);
> >> +
> >> +	GEN_CODES(call_func, __rcu_check_callbacks, 0)
> >> +	local_irq_restore(flags);
> >> +}
> >> +
> >> +static void rcu_process_callbacks(struct softirq_action *unused)
> >> +{
> >> +	local_irq_disable();
> >> +	GEN_CODES(call_func, __rcu_check_callbacks, 1)
> >> +	GEN_CODES(call_func, rcu_do_batch)
> >> +	local_irq_enable();
> >> +}
> >> +
> >> +static void __cpuinit __rcu_offline_cpu(struct rcu_domain *domain,
> >> +		struct rcu_data *off_rdp, struct rcu_data *rdp)
> >> +{
> >> +	if (off_rdp->qlen > 0) {
> >> +		unsigned long flags;
> >> +		long curr_complete;
> >> +
> >> +		/* move all callbacks in @off_rdp to @off_rdp->done_batch */
> >> +		do_advance_callbacks(off_rdp, off_rdp->curr_complete);
> >> +
> >> +		/* move all callbacks in @off_rdp to this cpu(@rdp) */
> >> +		local_irq_save(flags);
> >> +		curr_complete = prepare_for_new_callback(domain, rdp);
> >> +		rcu_batch_merge(rdp->batch + RCURING_IDX(curr_complete),
> >> +				&off_rdp->done_batch);
> >> +		rdp->qlen += off_rdp->qlen;
> >> +		local_irq_restore(flags);
> >> +
> >> +		off_rdp->qlen = 0;
> >> +	}
> >> +}
> >> +
> >> +#define gen_offline(domain, cpu, recieve_cpu)				\
> >> +	__rcu_offline_cpu(&rcu_domain_##domain,				\
> >> +			&per_cpu(rcu_data_##domain, cpu),		\
> >> +			&per_cpu(rcu_data_##domain, recieve_cpu));
> >> +
> >> +static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
> >> +				unsigned long action, void *hcpu)
> >> +{
> >> +	int cpu = (long)hcpu;
> >> +	int recieve_cpu;
> >> +
> >> +	(void)(recieve_cpu);
> >> +	(void)(__rcu_offline_cpu);
> >> +	(void)(__rcu_kernel_exit_outmost);
> >> +
> >> +	switch (action) {
> >> +#ifdef CONFIG_HOTPLUG_CPU
> >> +	case CPU_DYING:
> >> +	case CPU_DYING_FROZEN:
> >> +		/*
> >> +		 * the machine is stopped now, we can access to
> >> +		 * any other cpu data.
> >> +		 * */
> >> +		recieve_cpu = cpumask_any_but(cpu_online_mask, cpu);
> >> +		GEN_CODES(gen_offline, cpu, recieve_cpu)
> >> +		__rcu_kernel_exit_outmost(cpu);
> >> +		break;
> >> +#endif
> >> +	case CPU_STARTING:
> >> +	case CPU_STARTING_FROZEN:
> >> +		__rcu_kernel_enter_outmost(cpu);
> >> +	default:
> >> +		break;
> >> +	}
> >> +	return NOTIFY_OK;
> >> +}
> >> +
> >> +#define rcu_init_domain_data(domain, cpu)			\
> >> +	for_each_possible_cpu(cpu)				\
> >> +		rcu_data_init(&per_cpu(rcu_data_##domain, cpu));
> >> +
> >> +void __init rcu_init(void)
> >> +{
> >> +	int cpu;
> >> +
> >> +	GEN_CODES(rcu_init_domain_data, cpu)
> > 
> > This one actually consumes more lines than would writing out the
> > calls explicitly.  ;-)
> 
> like following? more lines and more "#ifdef"
> GEN_CODES reduces dumplicated code and reduces "#ifdef"s.
> 
> #ifdef CONFIG_RCURING_BH
> for_each_possible_cpu(cpu)
> 		rcu_data_init(&per_cpu(rcu_data_bh, cpu));
> #endif
> for_each_possible_cpu(cpu)
> 		rcu_data_init(&per_cpu(rcu_data_sched, cpu));
> #ifdef CONFIG_RCURING_PREEMPT
> for_each_possible_cpu(cpu)
> 		rcu_data_init(&per_cpu(rcu_data_preempt, cpu));
> #endif
> 
> > 
> >> +
> >> +	__rcu_kernel_enter_outmost(raw_smp_processor_id());
> >> +	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
> >> +	cpu_notifier(rcu_cpu_notify, 0);
> >> +}
> >> +
> >> +int rcu_scheduler_active __read_mostly;
> >> +EXPORT_SYMBOL_GPL(rcu_scheduler_active);
> >> +
> >> +/*
> >> + * This function is invoked towards the end of the scheduler's initialization
> >> + * process. Before this is called, the idle task might contain
> >> + * RCU read-side critical sections (during which time, this idle
> >> + * task is booting the system). After this function is called, the
> >> + * idle tasks are prohibited from containing RCU read-side critical
> >> + * sections. This function also enables RCU lockdep checking.
> >> + */
> >> +void rcu_scheduler_starting(void)
> >> +{
> >> +	rcu_scheduler_active = 1;
> >> +}
> >> +
> >> +#ifdef CONFIG_NO_HZ
> >> +
> >> +void rcu_kernel_enter(void)
> >> +{
> >> +	unsigned long flags;
> >> +
> >> +	raw_local_irq_save(flags);
> >> +	if (__get_cpu_var(kernel_count) == 0)
> >> +		__rcu_kernel_enter_outmost(raw_smp_processor_id());
> >> +	else
> >> +		__get_cpu_var(kernel_count)++;
> >> +	raw_local_irq_restore(flags);
> >> +}
> >> +
> >> +void rcu_kernel_exit(void)
> >> +{
> >> +	unsigned long flags;
> >> +
> >> +	raw_local_irq_save(flags);
> >> +	if (__get_cpu_var(kernel_count) == 1)
> >> +		__rcu_kernel_exit_outmost(raw_smp_processor_id());
> >> +	else
> >> +		__get_cpu_var(kernel_count)--;
> >> +	raw_local_irq_restore(flags);
> >> +}
> >> +
> >> +void rcu_enter_nohz(void)
> >> +{
> >> +	unsigned long flags;
> >> +
> >> +	raw_local_irq_save(flags);
> >> +	__rcu_kernel_exit_outmost(raw_smp_processor_id());
> >> +	raw_local_irq_restore(flags);
> >> +}
> >> +
> >> +void rcu_exit_nohz(void)
> >> +{
> >> +	unsigned long flags;
> >> +
> >> +	raw_local_irq_save(flags);
> >> +	__rcu_kernel_enter_outmost(raw_smp_processor_id());
> >> +	raw_local_irq_restore(flags);
> >> +}
> >> +#endif /* CONFIG_NO_HZ */
> >> +
> >> +static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head);
> >> +static struct completion rcu_barrier_completion;
> >> +static struct kref rcu_barrier_wait_ref;
> >> +static DEFINE_MUTEX(rcu_barrier_mutex);
> >> +
> >> +static void rcu_barrier_release_ref(struct kref *notused)
> >> +{
> >> +	complete(&rcu_barrier_completion);
> >> +}
> >> +
> >> +static void rcu_barrier_callback(struct rcu_head *notused)
> >> +{
> >> +	kref_put(&rcu_barrier_wait_ref, rcu_barrier_release_ref);
> >> +}
> >> +
> >> +static void rcu_barrier_func(void *data)
> >> +{
> >> +	struct rcu_domain *rcu_domain = data;
> >> +
> >> +	kref_get(&rcu_barrier_wait_ref);
> >> +	__call_rcu(rcu_domain, &__get_cpu_var(rcu_barrier_head),
> >> +			rcu_barrier_callback);
> >> +}
> >> +
> >> +static void __rcu_barrier(struct rcu_domain *rcu_domain)
> >> +{
> >> +	mutex_lock(&rcu_barrier_mutex);
> >> +
> >> +	init_completion(&rcu_barrier_completion);
> >> +	kref_init(&rcu_barrier_wait_ref);
> >> +
> >> +	/* queue barrier rcu_heads for every cpu */
> >> +	on_each_cpu(rcu_barrier_func, rcu_domain, 1);
> >> +
> >> +	kref_put(&rcu_barrier_wait_ref, rcu_barrier_release_ref);
> >> +	wait_for_completion(&rcu_barrier_completion);
> >> +
> >> +	mutex_unlock(&rcu_barrier_mutex);
> >> +}
> >> +
> >> +#define gen_rcu_barrier(domain)						\
> >> +void rcu_barrier_##domain(void)						\
> >> +{									\
> >> +	__rcu_barrier(&rcu_domain_##domain);				\
> >> +}									\
> >> +EXPORT_SYMBOL_GPL(rcu_barrier_##domain);
> >> +
> >> +GEN_CODES(gen_rcu_barrier)
> >> +
> >> diff --git a/kernel/sched.c b/kernel/sched.c
> >> index 09b574e..967f25a 100644
> >> --- a/kernel/sched.c
> >> +++ b/kernel/sched.c
> >> @@ -9113,6 +9113,7 @@ struct cgroup_subsys cpuacct_subsys = {
> >>  };
> >>  #endif	/* CONFIG_CGROUP_CPUACCT */
> >>
> >> +#ifndef CONFIG_RCURING
> >>  #ifndef CONFIG_SMP
> >>
> >>  void synchronize_sched_expedited(void)
> >> @@ -9182,3 +9183,4 @@ void synchronize_sched_expedited(void)
> >>  EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
> >>
> >>  #endif /* #else #ifndef CONFIG_SMP */
> >> +#endif /* CONFIG_RCURING */
> >> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> >> index 3e216e0..0eba561 100644
> >> --- a/kernel/time/tick-sched.c
> >> +++ b/kernel/time/tick-sched.c
> >> @@ -269,6 +269,10 @@ void tick_nohz_stop_sched_tick(int inidle)
> >>  	cpu = smp_processor_id();
> >>  	ts = &per_cpu(tick_cpu_sched, cpu);
> >>
> >> +	/* Don't enter nohz when cpu is offlining, it is going to die */
> >> +	if (cpu_is_offline(cpu))
> >> +		goto end;
> >> +
> >>  	/*
> >>  	 * Call to tick_nohz_start_idle stops the last_update_time from being
> >>  	 * updated. Thus, it must not be called in the event we are called from
> >>
> > 
> > 
> 
