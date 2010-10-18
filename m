Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab0JRKGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 06:06:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:51597 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab0JRKGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 06:06:38 -0400
Subject: Re: BUG: dead loop in PowerPC hcall tracepoint (Was: [LTP] [PATCH
 v2] Add ftrace-stress-test to LTP)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: subrata@linux.vnet.ibm.com, ltp-list@lists.sourceforge.net,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <4CBBBCB0.8070406@cn.fujitsu.com>
References: <4C85A88D.10700@cn.fujitsu.com>
	 <1285689961.11429.12.camel@subratamodak.linux.ibm.com>
	 <1286954486.4893.15.camel@subratamodak.linux.ibm.com>
	 <4CB55FE6.6000604@cn.fujitsu.com> <4CB5615C.4070406@cn.fujitsu.com>
	 <4CB59825.7060504@cn.fujitsu.com>
	 <1286995066.4893.17.camel@subratamodak.linux.ibm.com>
	 <4CBBBCB0.8070406@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 21:05:44 +1100
Message-ID: <1287396344.2341.6.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 11:19 +0800, Li Zefan wrote:
> Cc: Steven
> Cc: Ingo
> Cc: Peter
> Cc: Anton Blanchard <anton@samba.org>
> Cc: Paul Mackerras <paulus@samba.org>
> 
> For those Cced, More information here:
> 
> http://marc.info/?l=ltp-list&m=128569007015044&w=2
> http://marc.info/?l=ltp-list&m=128696942432669&w=2

Hrm... that's nasty...

Should we have some kind of flag to avoid spin_yield() calling H_CEDE
(or whatever it calls) when tracing an hcall to prevent that ? Anton,
Paulus, any other smart idea ? A TLF_ would do...

Cheers,
Ben.

> 02:37, Subrata Modak wrote:
> > I get a bigger trace with this patch:
> > 
> > Unable to handle kernel paging request for data at address 0x00000000
> > Faulting instruction address: 0xc0000000002133f0
> > cpu 0x2: Vector: 300 (Data Access) at [c0000000d9f8b560]
> >     pc: c0000000002133f0: .trace_clock_global+0xb4/0x2a0
> >     lr: c000000000213458: .trace_clock_global+0x11c/0x2a0
> >     sp: c0000000d9f8b7e0
> >    msr: 800000000200b032
> >    dar: 0
> >  dsisr: 40000000
> >   current = 0xc0000000d9f7d100
> >   paca    = 0xc000000007fc8e00
> >     pid   = 1667, comm = ftrace_stack_tr
> > Unrecoverable FP Unavailable Exception 800 at c0000000016a9540
> > cpu 0x0: Vector: 8Unable to handle0 kernel paging r0 equest for data (at
> > address 0xbffFffffe0175b688
> > PU UnavaFaulting instruciltion address: 0xac0000000001017fcb
> > le) at [c0000000d9f8a6a0]
> > p   pc: c0000000016a9540: etnetre r?  ?f ofro rh ehlepl
> > 
> > 
> >     lr: [c000000000016a9540: key_type_dns_resolver+0x15110/0x365f8
> >     sp: c0000000018804e8
> >    msr: 8000000000001032
> >   current = 0xc0000000d838d100
> >   paca    = 0xc000000007fc8000
> >     pid   = 1668, comm = ftrace_stack_ma
> >  pid   = 1668, cc0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> > [c0000000d9f8b9b0] c000000000223178 .ring_buffer_lock_reserve
> > +0x24c/0x2a4
> > [c0000000d9f8ba40] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> > [c0000000d9f8baf0] c00000000022ec9c .trace_current_buffer_lock_reserve
> > +0x44/0x6c
> > [c0000000d9f8bb80] c000000000011c5c .ftrace_raw_event_hcall_entry
> > +0x7c/0x144
> > [c0000000d9f8bc40] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> > [c0000000d9f8bcd0] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> > [c0000000d9f8bd40] c0000000000749c8 .__spin_yield+0x130/0x15c
> > [c0000000d9f8bdd0] c000000000213458 .trace_clock_global+0x11c/0x2a0
> 
> This is a dead loop:
> 
> trace_hcall_entry() -> trace_clock_global() -> trace_hcall_entry() ..
> 
> And this is a PPC specific bug. Hope some ppc guys will fix it?
> Or we kill trace_clock_global() if no one actually uses it..
> 
> --
> Li Zefan
> 
> > [c0000000d9f8be90] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> > [c0000000d9f8bfa0] c000000000223178 .ring_buffer_lock_reserve
> > +0x24c/0x2a4
> > [c0000000d9f8c030] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> > [c0000000d9f8c0e0] c00000000022ec9c .trace_current_buffer_lock_reserve
> > +0x44/0x6c
> > [c0000000d9f8c170] c000000000011c5c .ftrace_raw_event_hcall_entry
> > +0x7c/0x144
> > [c0000000d9f8c230] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> > [c0000000d9f8c2c0] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> > [c0000000d9f8c330] c0000000000749c8 .__spin_yield+0x130/0x15c
> > [c0000000d9f8c3c0] c000000000213458 .trace_clock_global+0x11c/0x2a0
> > [c0000000d9f8c480] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> > [c0000000d9f8c590] c000000000223178 .ring_buffer_lock_reserve
> > +0x24c/0x2a4
> > [c0000000d9f8c620] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> > [c0000000d9f8c6d0] c00000000022ec9c .trace_current_buffer_lock_reserve
> > +0x44/0x6c
> > [c0000000d9f8c760] c000000000011c5c .ftrace_raw_event_hcall_entry
> > +0x7c/0x144
> > [c0000000d9f8c820] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> > [c0000000d9f8c8b0] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> > [c0000000d9f8c920] c0000000000749c8 .__spin_yield+0x130/0x15c
> > [c0000000d9f8c9b0] c000000000213458 .trace_clock_global+0x11c/0x2a0
> > [c0000000d9f8ca70] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> > [c0000000d9f8cb80] c000000000223178 .ring_buffer_lock_reserve
> > +0x24c/0x2a4
> > [c0000000d9f8cc10] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> > [c0000000d9f8ccc0] c00000000022ec9c .trace_current_buffer_lock_reserve
> > +0x44/0x6c
> > [c0000000d9f8cd50] c000000000011c5c .ftrace_raw_event_hcall_entry
> > +0x7c/0x144
> > [c0000000d9f8ce10] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> > [c0000000d9f8cea0] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> > [c0000000d9f8cf10] c0000000000749c8 .__spin_yield+0x130/0x15c
> > [c0000000d9f8cfa0] c000000000213458 .trace_clock_global+0x11c/0x2a0
> > [c0000000d9f8d060] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> > [c0000000d9f8d170] c000000000223178 .ring_buffer_lock_reserve
> > +0x24c/0x2a4
> > [c0000000d9f8d200] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> > [c0000000d9f8d2b0] c00000000022ec9c .trace_current_buffer_lock_reserve
> > +0x44/0x6c
> > [c0000000d9f8d340] c000000000011c5c .ftrace_raw_event_hcall_entry
> > +0x7c/0x144
> > [c0000000d9f8d400] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> > [c0000000d9f8d490] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> > [c0000000d9f8d500] c0000000000749c8 .__spin_yield+0x130/0x15c
> > [c0000000d9f8d590] c000000000213458 .trace_clock_global+0x11c/0x2a0
> > [c0000000d9f8d650] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> > [c0000000d9f8d760] c000000000223178 .ring_buffer_lock_reserve
> > +0x24c/0x2a4
> > [c0000000d9f8d7f0] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> > [c0000000d9f8d8a0] c00000000022ec9c .trace_current_buffer_lock_reserve
> > +0x44/0x6c
> > [c0000000d9f8d930] c000000000011c5c .ftrace_raw_event_hcall_entry
> > +0x7c/0x144
> > [c0000000d9f8d9f0] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> > [c0000000d9f8da80] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> > [c0000000d9f8daf0] c0000000000749c8 .__spin_yield+0x130/0x15c
> > [c0000000d9f8db80] c000000000213458 .trace_clock_global+0x11c/0x2a0
> > [c0000000d9f8dc40] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> > [c0000000d9f8dd50] c000000000223178 .ring_buffer_lock_reserve
> > +0x24c/0x2a4
> > [c0000000d9f8dde0] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> > [c0000000d9f8de90] c00000000022ec9c .trace_current_buffer_lock_reserve
> > +0x44/0x6c
> > [c0000000d9f8df20] c000000000011c5c .ftrace_raw_event_hcall_entry
> > +0x7c/0x144
> > [c0000000d9f8dfe0] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> > [c0000000d9f8e070] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> > [c0000000d9f8e0e0] c0000000000749c8 .__spin_yield+0x130/0x15c
> > [c0000000d9f8e170] c000000000213458 .trace_clock_global+0x11c/0x2a0
> > [c0000000d9f8e230] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> > 
> > Regards--
> > Subrata
> > 
> > On Wed, 2010-10-13 at 19:29 +0800, Li Zefan wrote:
> >> Li Zefan wrote:
> >>> Li Zefan wrote:
> >>>> Subrata Modak wrote:
> >>>>> Li,
> >>>>>
> >>>>> Can you kindly fix the below issues and send me a new patch ?
> >>>>>
> >>>> Sure, I will.
> >>>>
> >>> At a first glance, the kernel bug doesn't seem to come from ftrace,
> >>> at least not directly from it.
> >>>
> >>> Question:
> >>>
> >>> Can you trigger this bug in latest kernel (2.6.36-rc7)? If you
> >>> haven't tried it, could you test it? Thanks!
> >>>
> >> I got a patch from Peter, though he's not sure about the bug yet.
> >> So could you try this?
> >>
> >> Note, I don't know if this patch can be applied to 2.6.35-4..
> >>
> >> ======================
> >>
> >> (From Peter)
> >>
> >> Hrmm, not something I've seen before.. but since the migration thread
> >> and stop_machine are involved, does the below patch which rewrites the
> >> migration-thread/stop_macehine/scheduler interaction cure this?
> >>
> >> This patch is probably .37 fodder, but who knows..
> >>
> >> ---
> >> Subject: sched: Create special class for stop/migrate work
> >> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >> Date: Wed Sep 22 13:53:15 CEST 2010
> >>
> >> In order to separate the stop/migrate work thread from the SCHED_FIFO
> >> implementation, create a special class for it that is of higher priority
> >> than SCHED_FIFO itself.
> >>
> >> This currently solves a problem where cpu-hotplug consumes so much cpu-time
> >> that the SCHED_FIFO class gets throttled, but has the bandwidth replenishment
> >> timer pending on the now dead cpu.
> >>
> >> It is also required for when we add the planned deadline scheduling class
> >> above SCHED_FIFO, as the stop/migrate thread still needs to transcent those
> >> tasks.
> >>
> >> Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> >> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >> LKML-Reference: <1285165776.2275.1022.camel@laptop>
> >> ---
> >>  kernel/sched.c          |   54 ++++++++++++++++++++----
> >>  kernel/sched_stoptask.c |  108 ++++++++++++++++++++++++++++++++++++++++++++++++
> >>  kernel/stop_machine.c   |    8 ++-
> >>  3 files changed, 158 insertions(+), 12 deletions(-)
> >>
> >> Index: linux-2.6/kernel/sched.c
> >> ===================================================================
> >> --- linux-2.6.orig/kernel/sched.c
> >> +++ linux-2.6/kernel/sched.c
> >> @@ -486,7 +486,7 @@ struct rq {
> >>  	 */
> >>  	unsigned long nr_uninterruptible;
> >>
> >> -	struct task_struct *curr, *idle;
> >> +	struct task_struct *curr, *idle, *stop;
> >>  	unsigned long next_balance;
> >>  	struct mm_struct *prev_mm;
> >>
> >> @@ -1837,7 +1837,7 @@ static inline void __set_task_cpu(struct
> >>
> >>  static const struct sched_class rt_sched_class;
> >>
> >> -#define sched_class_highest (&rt_sched_class)
> >> +#define sched_class_highest (&stop_sched_class)
> >>  #define for_each_class(class) \
> >>     for (class = sched_class_highest; class; class = class->next)
> >>
> >> @@ -1917,10 +1917,41 @@ static void deactivate_task(struct rq *r
> >>  #include "sched_idletask.c"
> >>  #include "sched_fair.c"
> >>  #include "sched_rt.c"
> >> +#include "sched_stoptask.c"
> >>  #ifdef CONFIG_SCHED_DEBUG
> >>  # include "sched_debug.c"
> >>  #endif
> >>
> >> +void sched_set_stop_task(int cpu, struct task_struct *stop)
> >> +{
> >> +	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
> >> +	struct task_struct *old_stop = cpu_rq(cpu)->stop;
> >> +
> >> +	if (stop) {
> >> +		/*
> >> +		 * Make it appear like a SCHED_FIFO task, its something
> >> +		 * userspace knows about and won't get confused about.
> >> +		 *
> >> +		 * Also, it will make PI more or less work without too
> >> +		 * much confusion -- but then, stop work should not
> >> +		 * rely on PI working anyway.
> >> +		 */
> >> +		sched_setscheduler_nocheck(stop, SCHED_FIFO, &param);
> >> +
> >> +		stop->sched_class = &stop_sched_class;
> >> +	}
> >> +
> >> +	cpu_rq(cpu)->stop = stop;
> >> +
> >> +	if (old_stop) {
> >> +		/*
> >> +		 * Reset it back to a normal scheduling class so that
> >> +		 * it can die in pieces.
> >> +		 */
> >> +		old_stop->sched_class = &rt_sched_class;
> >> +	}
> >> +}
> >> +
> >>  /*
> >>   * __normal_prio - return the priority that is based on the static prio
> >>   */
> >> @@ -3720,17 +3751,13 @@ pick_next_task(struct rq *rq)
> >>  			return p;
> >>  	}
> >>
> >> -	class = sched_class_highest;
> >> -	for ( ; ; ) {
> >> +	for_each_class(class) {
> >>  		p = class->pick_next_task(rq);
> >>  		if (p)
> >>  			return p;
> >> -		/*
> >> -		 * Will never be NULL as the idle class always
> >> -		 * returns a non-NULL p:
> >> -		 */
> >> -		class = class->next;
> >>  	}
> >> +
> >> +	BUG(); /* the idle class will always have a runnable task */
> >>  }
> >>
> >>  /*
> >> @@ -4659,6 +4686,15 @@ static int __sched_setscheduler(struct t
> >>  	 */
> >>  	rq = __task_rq_lock(p);
> >>
> >> +	/*
> >> +	 * Changing the policy of the stop threads its a very bad idea
> >> +	 */
> >> +	if (p == rq->stop) {
> >> +		__task_rq_unlock(rq);
> >> +		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
> >> +		return -EINVAL;
> >> +	}
> >> +
> >>  #ifdef CONFIG_RT_GROUP_SCHED
> >>  	if (user) {
> >>  		/*
> >> Index: linux-2.6/kernel/stop_machine.c
> >> ===================================================================
> >> --- linux-2.6.orig/kernel/stop_machine.c
> >> +++ linux-2.6/kernel/stop_machine.c
> >> @@ -287,11 +287,12 @@ static int cpu_stopper_thread(void *data
> >>  	goto repeat;
> >>  }
> >>
> >> +extern void sched_set_stop_task(int cpu, struct task_struct *stop);
> >> +
> >>  /* manage stopper for a cpu, mostly lifted from sched migration thread mgmt */
> >>  static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
> >>  					   unsigned long action, void *hcpu)
> >>  {
> >> -	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
> >>  	unsigned int cpu = (unsigned long)hcpu;
> >>  	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
> >>  	struct task_struct *p;
> >> @@ -304,13 +305,13 @@ static int __cpuinit cpu_stop_cpu_callba
> >>  				   cpu);
> >>  		if (IS_ERR(p))
> >>  			return NOTIFY_BAD;
> >> -		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
> >>  		get_task_struct(p);
> >> +		kthread_bind(p, cpu);
> >> +		sched_set_stop_task(cpu, p);
> >>  		stopper->thread = p;
> >>  		break;
> >>
> >>  	case CPU_ONLINE:
> >> -		kthread_bind(stopper->thread, cpu);
> >>  		/* strictly unnecessary, as first user will wake it */
> >>  		wake_up_process(stopper->thread);
> >>  		/* mark enabled */
> >> @@ -325,6 +326,7 @@ static int __cpuinit cpu_stop_cpu_callba
> >>  	{
> >>  		struct cpu_stop_work *work;
> >>
> >> +		sched_set_stop_task(cpu, NULL);
> >>  		/* kill the stopper */
> >>  		kthread_stop(stopper->thread);
> >>  		/* drain remaining works */
> >> Index: linux-2.6/kernel/sched_stoptask.c
> >> ===================================================================
> >> --- /dev/null
> >> +++ linux-2.6/kernel/sched_stoptask.c
> >> @@ -0,0 +1,108 @@
> >> +/*
> >> + * stop-task scheduling class.
> >> + *
> >> + * The stop task is the highest priority task in the system, it preempts
> >> + * everything and will be preempted by nothing.
> >> + *
> >> + * See kernel/stop_machine.c
> >> + */
> >> +
> >> +#ifdef CONFIG_SMP
> >> +static int
> >> +select_task_rq_stop(struct rq *rq, struct task_struct *p,
> >> +		    int sd_flag, int flags)
> >> +{
> >> +	return task_cpu(p); /* stop tasks as never migrate */
> >> +}
> >> +#endif /* CONFIG_SMP */
> >> +
> >> +static void
> >> +check_preempt_curr_stop(struct rq *rq, struct task_struct *p, int flags)
> >> +{
> >> +	resched_task(rq->curr); /* we preempt everything */
> >> +}
> >> +
> >> +static struct task_struct *pick_next_task_stop(struct rq *rq)
> >> +{
> >> +	struct task_struct *stop = rq->stop;
> >> +
> >> +	if (stop && stop->state == TASK_RUNNING)
> >> +		return stop;
> >> +
> >> +	return NULL;
> >> +}
> >> +
> >> +static void
> >> +enqueue_task_stop(struct rq *rq, struct task_struct *p, int flags)
> >> +{
> >> +}
> >> +
> >> +static void
> >> +dequeue_task_stop(struct rq *rq, struct task_struct *p, int flags)
> >> +{
> >> +}
> >> +
> >> +static void yield_task_stop(struct rq *rq)
> >> +{
> >> +	BUG(); /* the stop task should never yield, its pointless. */
> >> +}
> >> +
> >> +static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
> >> +{
> >> +}
> >> +
> >> +static void task_tick_stop(struct rq *rq, struct task_struct *curr, int queued)
> >> +{
> >> +}
> >> +
> >> +static void set_curr_task_stop(struct rq *rq)
> >> +{
> >> +}
> >> +
> >> +static void switched_to_stop(struct rq *rq, struct task_struct *p,
> >> +			     int running)
> >> +{
> >> +	BUG(); /* its impossible to change to this class */
> >> +}
> >> +
> >> +static void prio_changed_stop(struct rq *rq, struct task_struct *p,
> >> +			      int oldprio, int running)
> >> +{
> >> +	BUG(); /* how!?, what priority? */
> >> +}
> >> +
> >> +static unsigned int
> >> +get_rr_interval_stop(struct rq *rq, struct task_struct *task)
> >> +{
> >> +	return 0;
> >> +}
> >> +
> >> +/*
> >> + * Simple, special scheduling class for the per-CPU stop tasks:
> >> + */
> >> +static const struct sched_class stop_sched_class = {
> >> +	.next			= &rt_sched_class,
> >> +
> >> +	.enqueue_task		= enqueue_task_stop,
> >> +	.dequeue_task		= dequeue_task_stop,
> >> +	.yield_task		= yield_task_stop,
> >> +
> >> +	.check_preempt_curr	= check_preempt_curr_stop,
> >> +
> >> +	.pick_next_task		= pick_next_task_stop,
> >> +	.put_prev_task		= put_prev_task_stop,
> >> +
> >> +#ifdef CONFIG_SMP
> >> +	.select_task_rq		= select_task_rq_stop,
> >> +#endif
> >> +
> >> +	.set_curr_task          = set_curr_task_stop,
> >> +	.task_tick		= task_tick_stop,
> >> +
> >> +	.get_rr_interval	= get_rr_interval_stop,
> >> +
> >> +	.prio_changed		= prio_changed_stop,
> >> +	.switched_to		= switched_to_stop,
> >> +
> >> +	/* no .task_new for stop tasks */
> >> +};
> >>
> >>
> >>
> > 
> > 
> > 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


