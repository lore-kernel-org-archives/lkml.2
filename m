Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0DTPdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 11:33:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab0DTPdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 11:33:12 -0400
Date: Tue, 20 Apr 2010 17:30:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
Message-ID: <20100420153023.GA9351@redhat.com>
References: <20100331155106.4181.50759.sendpatchset@localhost6.localdomain6> <20100331155228.4181.61294.sendpatchset@localhost6.localdomain6> <20100413183537.GA17538@redhat.com> <20100415093506.GA2064@linux.vnet.ibm.com> <20100419193139.GA24080@redhat.com> <20100420124358.GA20675@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420124358.GA20675@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20, Srikar Dronamraju wrote:
>
> > > > > +static void cleanup_uprocess(struct uprobe_process *uproc,
> > > > > +					struct task_struct *start)
> > > > > +		tsk = next_thread(tsk);
> > > >
> > I meant, it is not safe to use next_thread(tsk) if tsk was already
> > removed from list by __unhash_process before we take rcu_read_lock().
>
> Okay, cleanup_process() gets called only and only if add_utask() fails
> to allocated utask struct.

Yes, but afaics we have the same issues in find_next_thread() called
by create_uprocess().

> Based on your inputs I will synchronize
> exit_signals() and uprobe_free_utask(). However it still can happen that
> uprobe calls cleanup_uprocess() with reference to task struct which has just
> called __unhash_process(). Is there a way out of this?

In this particular case, probably we can rely on uprobe_mutex. Currently
cleanup_uprocess() is called with start == cur_t. Instead, we should use
the last task on which add_utask() succeeded, it can't exit (assuming we
fix other discussed races with exit) because uprobe_free_utask() takes
this mutex too.

However, perhaps it is better to rework this all. Say, can't we move
uprobe_free_utask() into __put_task_struct() ? Afaics, this can greatly
simplify things. If we add mm_struct->uproc, then utask doesn't need
the pointer to uprobe_process.

> > > > > +static struct pid *get_tg_leader(pid_t p)
> > > > > +{
> > > > > +	struct pid *pid = NULL;
> > > > > +
> > > > > +	rcu_read_lock();
> > > > > +	if (current->nsproxy)
> > > > > +		pid = find_vpid(p);
> > > >
> > > > Is it really possible to call register/unregister with nsproxy == NULL?
> >
> > You didn't answer ;)
>
> Can you please let me know when nsproxy is set to NULL?

exit_notify()->exit_task_namespaces()

> If we are sure
> that register/unregister will be called with nsproxy set, then I am
> happy to remove this check.

I think the exiting task shouldn't call register/unregister.

> > 	- uprobe_process->tg_leader is not really used ?
>
> Currently we have a reference to pid struct from the time we created a
> uprobe_process to the time we free the uprobe process.

Yes, but

> So are you
> suggesting that we dont have a reference to the pid structure or is that
> we dont need to cache the pid struct and access it thro
> task_pid(current) in free_uprobes()?

I must have missed something. But I do not see where do we use
uprobe_process->tg_leader. We never read it, apart from
BUG_ON(uproc->tg_leader != tg_leader). No?

> > 	- I don't understand why do we need uprobe_{en,dis}able_interrupts
> > 	  helpers. pre_ssout() could just do local_irq_enable(). This path
> > 	  leads to get_signal_to_deliver() which enables irqs anyway, it is
> > 	  always safe to do this earlier and I don't think we need to disable
> > 	  irqs again later. In any case, I don't understand why these helpers
> > 	  use native_irq_xxx().
>
> On i686, (unlike x86_64), do_notify_resume() gets called with irqs
> disabled.  I had tried local_irq_enable couple of times but that didnt
> help probably because CONFIG_PARAVIRT is set in my .config and hence
> raw_local_irq_enable resolves to
>
> static inline void raw_local_irq_enable(void)
> {
> 	PVOP_VCALLEE0(pv_irq_ops.irq_enable);
> }
>
> What we need is the "sti" instruction.  It looks like local_irq_enable
> actually doesnt do "sti".  So I had to go back to using
> native_irq_enable().

Hmm. No, I can't explain this, I know nothing about paravirt. But this
doesn't look right to me. Probably this should be discussed with paravirt
developers...

> > 	- pre_ssout() does .xol_vaddr = xol_get_insn_slot(). This looks a
> > 	  bit confusing, xol_get_insn_slot() should set .xol_vaddr correctly
> > 	  under lock.
>
> Can you please elaborate.

pre_ssout() does

	if (!user_bkpt.xol_vaddr)
		user_bkpt.xol_vaddr = xol_get_insn_slot();

but it could just do

	if (!user_bkpt.xol_vaddr)
		xol_get_insn_slot();

because xol_get_insn_slot() populates user_bkpt.xol_vaddr.

Btw. Why do we have the !CONFIG_USER_BKPT_XOL code in
include/linux/user_bkpt_xol.h? CONFIG_UPROBES depends on CONFIG_USER_BKPT_XOL.

Also the declarations don't look nice... Probably I missed something,
but why the code uses "void *" instead of "user_bkpt_xol_area *" for
xol_area everywhere?

OK, even if "void *" makes sense for uproc->uprobe_process, why
xol_alloc_area/xol_get_insn_slot/etc do not use "user_bkpt_xol_area *" ?

> > 	- I don't really understand why ->handler_in_interrupt is really
> > 	  useful, but never mind.
>
> There is a small overhead when running the handlers in task context.

Sure, but

> overhead of task over interrupt =  (1.016851 - .907400) = .109451 usec
> % additional overhead = (.109451/.907400) * 100 = 12.062%

this overhead looks very minor. To me, it is better to simplify the
code, at least in the first version.

That said, this is up to you, I am not asking you to remove this
optimization. Just imho.

> > 	- However, handler_in_interrupt && !uses_xol_strategy() doesn't
> > 	  look right. uprobe_bkpt_notifier() is called with irqs disabled,
> > 	  right? but set_orig_insn() is might_sleep().
> >
>
> 	Yes, Uprobes currently supports only xol strategy. I.e I have
> dropped single stepping inline strategy for uprobes. Hence when
> user_bkpt_pre_sstep gets called from uprobe_bkpt_notifier; we are sure
> that it doesnt call set_orig_insn().

OK, thanks. Perhaps a small comment to explain this makes sense...

> > Suppose that register_uprobe() succeeds and does set_bkpt(). What if another
> > process (not sub-thread) with the same ->mm hits this bp? uprobe_bkpt_notifier()
> > will see ->utask == NULL and return 0. Then do_int3() sends SIGTRAP and kills
> > this task. OK, probably CLONE_VM alone is exotic, but CLONE_VFORK | VM is not.
> > ...
> > I think uprobe_process should be per ->mm, not per-process.
>
> True, One possibility could be to move the uprobe_process structure to
> mm_struct. But now sure if VM folks would be okay with that idea.

Yes, I was thinking about mm->struct->uproc too.

And, assuming we have this pointer in mm_struct:

> > I wonder if there any possibility to avoid task_struct->utask, or at least,
> > if we can allocate it in uprobe_bkpt_notifier() on demand. Not sure.
>
> Except for the pointer to uprobe_process, all other fields in utask are
> per task. This per task information is mostly used at probe hit. Hence
> having it in task_struct makes it easily accessible.  Do you have other
> ideas from where we could refer utask.

Well, we could add the list of uprobe_task's into uprobe_process, it
represents the tasks "inside" the probe hit. But yes, this is not easy,
lets forget this, at least for now.

> I did think about allocating a utask on the first hit of a breakpoint. However
> there are couple of issues.
>
> 1. Uprobes needs access to uprobe_process to search the breakpoints
> installed for that process. Currently we hang it out of utask.
> 	However if uprobe_process is made a part of mm_struct, this would no
> more be an issue.

Yes,

> 2. Currently when a breakpoint is hit, uprobes increments the refcount
> for the corresponding probepoint, and sets active_ppt in the utask for
> the current thread. This happens in interrupt context. Allocating utask
> on first breakpoint hit for that thread; has to be handled in task
> context.

we could use GFP_ATOMIC, but I agree, this is not nice.

> If the utask has to be allocated, then uprobes has to search
> for the probepoint again in task context.
> 	I dont think it would be an issue to search for the probepoint a
> second time in the task context.

Agreed. Although we need the new TIF_ bit for tracehook_notify_resume(),
it can't trust "if (current->utask...)" checks.


Alternatively, without the "on demand" allocations, register_uprobe()
has to find all threads which use the same ->mm and initialize ->utask.
This is not easy.

Oleg.

