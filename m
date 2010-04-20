Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab0DTMoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 08:44:12 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:52831 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab0DTMoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 08:44:06 -0400
Date: Tue, 20 Apr 2010 18:13:58 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH v2 7/11] Uprobes Implementation
Message-ID: <20100420124358.GA20675@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100331155106.4181.50759.sendpatchset@localhost6.localdomain6>
 <20100331155228.4181.61294.sendpatchset@localhost6.localdomain6>
 <20100413183537.GA17538@redhat.com>
 <20100415093506.GA2064@linux.vnet.ibm.com>
 <20100419193139.GA24080@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100419193139.GA24080@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > +static void cleanup_uprocess(struct uprobe_process *uproc,
> > > > +					struct task_struct *start)
> > > > +{
> > > > +	struct task_struct *tsk = start;
> > > > +
> > > > +	if (!start)
> > > > +		return;
> > > > +
> > > > +	rcu_read_lock();
> > > > +	do {
> > > > +		if (tsk->utask) {
> > > > +			kfree(tsk->utask);
> > > > +			tsk->utask = NULL;
> > > > +		}
> > > > +		tsk = next_thread(tsk);
> > >
> > > This doesn't look right. We can't trust ->thread_group list even under
> > > rcu_read_lock(). The task can exit and __exit_signal() can remove it
> > > from ->thread_group list before we take rcu_read_lock().
> >
> > Oh Okay, I get that the thread could be exiting from the time we
> > allocated the utask to the time we are cleaning up here and hence we
> > could be leaking utask.
> >
> > Would it be okay if we explicitly (instead of the using
> > tracehook_report_exit) call uprobe_free_utask() just after we set
> > PF_EXITING. We could take the task_lock to synchronize with the
> > add_utask() and do_exit().
> 
> Not sure I understand....
> 
> I meant, it is not safe to use next_thread(tsk) if tsk was already
> removed from list by __unhash_process before we take rcu_read_lock().

Okay, cleanup_process() gets called only and only if add_utask() fails
to allocated utask struct.  Based on your inputs I will synchronize
exit_signals() and uprobe_free_utask(). However it still can happen that
uprobe calls cleanup_uprocess() with reference to task struct which has just
called __unhash_process(). Is there a way out of this?

[ snip ..]
> > >
> > > can't we race with clone(CLONE_THREAD) and miss the new thread? Probably
> > > I missed something, but afaics we need some barriers to ensure that either
> > > tracehook_report_clone() sees current->utask != NULL or find_next_thread()
> > > sees the new thread in ->thread_group.
> >
> > The tracehook_report_clone is called after the element gets added to the
> > thread_group list in copy_process().
> > Looking at three cases where current thread could be cloning a new thread.
> >
> > a) current thread has a utask and tracehook_report_clone is not yet
> > called.
> > 	utask for the new thread will be created by either
> > tracehook_report_clone or the find_next_thread whichever comes first.
> 
> Yes, but my point was, we probably need mb's on both sides. Of course,
> this is only theoretical problem, but tracehook_report_clone() can read
> current->utask == NULL before the result of copy_process()->list_add_tail()
> is visible to another CPU which does create_uprocess().

Okay. 

> 
> > > > +static struct pid *get_tg_leader(pid_t p)
> > > > +{
> > > > +	struct pid *pid = NULL;
> > > > +
> > > > +	rcu_read_lock();
> > > > +	if (current->nsproxy)
> > > > +		pid = find_vpid(p);
> > >
> > > Is it really possible to call register/unregister with nsproxy == NULL?
> 
> You didn't answer ;)

Can you please let me know when nsproxy is set to NULL? If we are sure
that register/unregister will be called with nsproxy set, then I am
happy to remove this check.

> 
> > Do you see a need for checking if the process is exiting before we place
> > the probes?
> 
> Oh, I don't know. You are going to change this code anyway, I can't see
> in advance.

Okay .

> 
> 
> I tried to read the next 8/11 patch, and I have a couple more random questions.
> 
> 	- uprobe_process->tg_leader is not really used ?

Currently we have a reference to pid struct from the time we created a
uprobe_process to the time we free the uprobe process.  So are you
suggesting that we dont have a reference to the pid structure or is that
we dont need to cache the pid struct and access it thro
task_pid(current) in free_uprobes()?


> 
> 	- looks like, 7/11 can't be compiled without the next 8/11 ?
> 	  say, the next patch defines arch_uprobe_disable_sstep() but
> 	  it is used by 7/11

Okay, I will take care of this in the next iteration.

> 
> 	- I don't understand why do we need uprobe_{en,dis}able_interrupts
> 	  helpers. pre_ssout() could just do local_irq_enable(). This path
> 	  leads to get_signal_to_deliver() which enables irqs anyway, it is
> 	  always safe to do this earlier and I don't think we need to disable
> 	  irqs again later. In any case, I don't understand why these helpers
> 	  use native_irq_xxx().

On i686, (unlike x86_64), do_notify_resume() gets called with irqs
disabled.  I had tried local_irq_enable couple of times but that didnt
help probably because CONFIG_PARAVIRT is set in my .config and hence
raw_local_irq_enable resolves to

static inline void raw_local_irq_enable(void)
{
	PVOP_VCALLEE0(pv_irq_ops.irq_enable);
}

What we need is the "sti" instruction.  It looks like local_irq_enable
actually doesnt do "sti".  So I had to go back to using
native_irq_enable().

Do you have any ideas how to force local_irq_enable to do a "sti."
Or Am I missing something?

Since I wasnt sure why do_notify_resume() was called under irqs_disabled
only for x86. I disabled irqs again just to be sure that I am not
messing some assumption.

> 
> 	- pre_ssout() does .xol_vaddr = xol_get_insn_slot(). This looks a
> 	  bit confusing, xol_get_insn_slot() should set .xol_vaddr correctly
> 	  under lock.

Can you please elaborate.

> 
> 	- pre_ssout() does user_bkpt_set_ip() after user_bkpt_pre_sstep().
> 	  Why? Shouldn't user_bkpt_pre_sstep() always set regs->ip ?
> 	  Otherwise uprobe_bkpt_notifier()->user_bkpt_pre_sstep() is not
> 	  right.

Right, user_bkpt_set_ip is redudant as user_bkpt_pre_sstep sets
regs->ip. I will remove user_bkpt_set_ip after user_bkpt_pre_sstep
	
> 
> 	- I don't really understand why ->handler_in_interrupt is really
> 	  useful, but never mind.
	
Uprobes can run handlers either in interrupt context or in task context.
If the user is sure that his handler is not going to sleep, then he can
set handler_in_interrupt flag while registering the probe.

There is a small overhead when running the handlers in task context. 
Here is a brief benchmark on a x86_64 machine.


========================================================================
Results when running a kernel without lockdep and other debug kernel
/ kernel hacking features.

Running benchmark not probed
pid is 5236
10000 interations in 0.000049 sec
0.004900 usec per iteration
sum = 50005000


Running benchmark .. interrupt context handler 
pid is 5252
10000 interations in 0.009123 sec
0.912300 usec per iteration
sum = 50005000
overhead per probe = (0.912300-0.004900) = .907400 usec

Running benchmark .. task context handler
pid is 5268
10000 interations in 0.010169 sec
1.016900 usec per iteration
sum = 50005000
overhead per probe = (1.016900-0.000049) = 1.016851 usec

overhead of task over interrupt =  (1.016851 - .907400) = .109451 usec
% additional overhead = (.109451/.907400) * 100 = 12.062%

=====================================================================
Results when running a kernel with lockdep and other debug kernel
/ kernel hacking features.

Running benchmark not probed
pid is 3778
10000 interations in 0.000043 sec
0.004300 usec per iteration
sum = 50005000


Running benchmark .. interrupt context handler 
pid is 3794
10000 interations in 0.020318 sec
2.031800 usec per iteration
sum = 50005000
overhead per probe = (2.031800-0.004300) = 2.027500 usecs


Running benchmark .. task context handler
pid is 3810
10000 interations in 0.021790 sec
2.179000 usec per iteration
sum = 50005000
overhead per probe = (2.179000-0.004300) = 2.174700 usecs

overhead of task over interrupt =  (2.174700 - 2.027500) = .147200 usec
%additional overhead = (0.147200/2.027500) * 100 = 7.26

=======================================================================

> 
> 	- However, handler_in_interrupt && !uses_xol_strategy() doesn't
> 	  look right. uprobe_bkpt_notifier() is called with irqs disabled,
> 	  right? but set_orig_insn() is might_sleep().
> 

	Yes, Uprobes currently supports only xol strategy. I.e I have
dropped single stepping inline strategy for uprobes. Hence when
user_bkpt_pre_sstep gets called from uprobe_bkpt_notifier; we are sure
that it doesnt call set_orig_insn().

[ snip ... ]

> > > OK, iiuc this should restore the original instruction, right?
> > >
> > > But what about clone(CLONE_VM)? In this case this child shares ->mm with
> > > parent.
> >
> > Okay, So I will remove the breakpoints only for ! CLONE(CLONE_VM) and
> > !CLONE(CLONE_THREAD)
> > For CLONE(CLONE_VM) I will create a new uproc and utask structures.
> > Since mm is shared; I guess the XOL vma gets shared between the processes.
> 
> Yes, I think CLONE_VM without CLONE_THREAD needs utask too, but do we need
> the new uproc? OK, please forget about this for the moment.
> 
> Suppose that register_uprobe() succeeds and does set_bkpt(). What if another
> process (not sub-thread) with the same ->mm hits this bp? uprobe_bkpt_notifier()
> will see ->utask == NULL and return 0. Then do_int3() sends SIGTRAP and kills
> this task. OK, probably CLONE_VM alone is exotic, but CLONE_VFORK | VM is not.
> 

I was looking at duplicating the uprobe_process. But yes that may not be
a nice idea, esp if new probes get added then we would have to take care
of updating both the uprobe_process lists.
Yes, we can share the uprobe_process shared between the process that
share mm. Thats a definitely a better idea than duplicating.

> I think uprobe_process should be per ->mm, not per-process.

True, One possibility could be to move the uprobe_process structure to
mm_struct. But now sure if VM folks would be okay with that idea.

> 
> I wonder if there any possibility to avoid task_struct->utask, or at least,
> if we can allocate it in uprobe_bkpt_notifier() on demand. Not sure.

Except for the pointer to uprobe_process, all other fields in utask are
per task. This per task information is mostly used at probe hit. Hence
having it in task_struct makes it easily accessible.  Do you have other
ideas from where we could refer utask.

I did think about allocating a utask on the first hit of a breakpoint. However
there are couple of issues.

1. Uprobes needs access to uprobe_process to search the breakpoints
installed for that process. Currently we hang it out of utask.
	However if uprobe_process is made a part of mm_struct, this would no
more be an issue. 

2. Currently when a breakpoint is hit, uprobes increments the refcount
for the corresponding probepoint, and sets active_ppt in the utask for
the current thread. This happens in interrupt context. Allocating utask
on first breakpoint hit for that thread; has to be handled in task
context. If the utask has to be allocated, then uprobes has to search
for the probepoint again in task context. 
	I dont think it would be an issue to search for the probepoint a
second time in the task context.

--
Thanks and Regards
Srikar
