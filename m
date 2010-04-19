Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0DSTjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:39:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab0DSTjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:39:08 -0400
Date: Mon, 19 Apr 2010 21:31:39 +0200
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
Message-ID: <20100419193139.GA24080@redhat.com>
References: <20100331155106.4181.50759.sendpatchset@localhost6.localdomain6> <20100331155228.4181.61294.sendpatchset@localhost6.localdomain6> <20100413183537.GA17538@redhat.com> <20100415093506.GA2064@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415093506.GA2064@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar, sorry for delay...

On 04/15, Srikar Dronamraju wrote:
>
> > > +static void cleanup_uprocess(struct uprobe_process *uproc,
> > > +					struct task_struct *start)
> > > +{
> > > +	struct task_struct *tsk = start;
> > > +
> > > +	if (!start)
> > > +		return;
> > > +
> > > +	rcu_read_lock();
> > > +	do {
> > > +		if (tsk->utask) {
> > > +			kfree(tsk->utask);
> > > +			tsk->utask = NULL;
> > > +		}
> > > +		tsk = next_thread(tsk);
> >
> > This doesn't look right. We can't trust ->thread_group list even under
> > rcu_read_lock(). The task can exit and __exit_signal() can remove it
> > from ->thread_group list before we take rcu_read_lock().
>
> Oh Okay, I get that the thread could be exiting from the time we
> allocated the utask to the time we are cleaning up here and hence we
> could be leaking utask.
>
> Would it be okay if we explicitly (instead of the using
> tracehook_report_exit) call uprobe_free_utask() just after we set
> PF_EXITING. We could take the task_lock to synchronize with the
> add_utask() and do_exit().

Not sure I understand....

I meant, it is not safe to use next_thread(tsk) if tsk was already
removed from list by __unhash_process before we take rcu_read_lock().

> > > +static struct uprobe_task *add_utask(struct task_struct *t,
> > > +					struct uprobe_process *uproc)
> > > +{
> > > +	struct uprobe_task *utask;
> > > +
> > > +	if (!t)
> > > +		return NULL;
> > > +	utask = kzalloc(sizeof *utask, GFP_USER);
> > > +	if (unlikely(utask == NULL))
> > > +		return ERR_PTR(-ENOMEM);
> > > +
> > > +	utask->uproc = uproc;
> > > +	utask->active_ppt = NULL;
> > > +	t->utask = utask;
> > > +	atomic_inc(&uproc->refcount);
> > > +
> > > +	return utask;
> > > +}
> >
> > This is called by create_uprocess(). Who will free t->utask if t has
> > already passed tracehook_report_exit() ?
>
> Okay.
> Would it work if we
>
> [... snip ...]

I think yes. But see below.

> > > +	 * Create and populate one utask per thread in this process.  We
> > > +	 * can't call add_utask() while holding RCU lock, so we:
> > > +	 *	1. rcu_read_lock()
> > > +	 *	2. Find the next thread, add_me, in this process that's not
> > > +	 *	having a utask struct allocated.
> > > +	 *	3. rcu_read_unlock()
> > > +	 *	4. add_utask(add_me, uproc)
> > > +	 *	Repeat 1-4 'til we have utasks for all threads.
> > > +	 */
> > > +	cur_t = get_pid_task(tg_leader, PIDTYPE_PID);
> > > +	do {
> > > +		utask = add_utask(cur_t, uproc);
> > > +		if (IS_ERR(utask)) {
> > > +			err = PTR_ERR(utask);
> > > +			goto fail;
> > > +		}
> > > +		add_me = find_next_thread(uproc, cur_t);
> > > +		put_task_struct(cur_t);
> > > +		cur_t = add_me;
> > > +	} while (add_me != NULL);
> >
> > can't we race with clone(CLONE_THREAD) and miss the new thread? Probably
> > I missed something, but afaics we need some barriers to ensure that either
> > tracehook_report_clone() sees current->utask != NULL or find_next_thread()
> > sees the new thread in ->thread_group.
>
> The tracehook_report_clone is called after the element gets added to the
> thread_group list in copy_process().
> Looking at three cases where current thread could be cloning a new thread.
>
> a) current thread has a utask and tracehook_report_clone is not yet
> called.
> 	utask for the new thread will be created by either
> tracehook_report_clone or the find_next_thread whichever comes first.

Yes, but my point was, we probably need mb's on both sides. Of course,
this is only theoretical problem, but tracehook_report_clone() can read
current->utask == NULL before the result of copy_process()->list_add_tail()
is visible to another CPU which does create_uprocess().

> > > +static struct pid *get_tg_leader(pid_t p)
> > > +{
> > > +	struct pid *pid = NULL;
> > > +
> > > +	rcu_read_lock();
> > > +	if (current->nsproxy)
> > > +		pid = find_vpid(p);
> >
> > Is it really possible to call register/unregister with nsproxy == NULL?

You didn't answer ;)

> Do you see a need for checking if the process is exiting before we place
> the probes?

Oh, I don't know. You are going to change this code anyway, I can't see
in advance.


I tried to read the next 8/11 patch, and I have a couple more random questions.

	- uprobe_process->tg_leader is not really used ?

	- looks like, 7/11 can't be compiled without the next 8/11 ?
	  say, the next patch defines arch_uprobe_disable_sstep() but
	  it is used by 7/11

	- I don't understand why do we need uprobe_{en,dis}able_interrupts
	  helpers. pre_ssout() could just do local_irq_enable(). This path
	  leads to get_signal_to_deliver() which enables irqs anyway, it is
	  always safe to do this earlier and I don't think we need to disable
	  irqs again later. In any case, I don't understand why these helpers
	  use native_irq_xxx().

	- pre_ssout() does .xol_vaddr = xol_get_insn_slot(). This looks a
	  bit confusing, xol_get_insn_slot() should set .xol_vaddr correctly
	  under lock.

	- pre_ssout() does user_bkpt_set_ip() after user_bkpt_pre_sstep().
	  Why? Shouldn't user_bkpt_pre_sstep() always set regs->ip ?
	  Otherwise uprobe_bkpt_notifier()->user_bkpt_pre_sstep() is not
	  right.

	- I don't really understand why ->handler_in_interrupt is really
	  useful, but never mind.

	- However, handler_in_interrupt && !uses_xol_strategy() doesn't
	  look right. uprobe_bkpt_notifier() is called with irqs disabled,
	  right? but set_orig_insn() is might_sleep().


> > > +	} else {
> > > +		struct uprobe_probept *ppt;
> > > +		int ret;
> > > +
> > > +		/*
> > > +		 * New process spawned by parent.  Remove the probepoints
> > > +		 * in the child's text.
> > > +		 *
> > > +		 * We also hold the uproc->mutex for the parent - so no
> > > +		 * new uprobes will be registered 'til we return.
> > > +		 */
> > > +		mutex_lock(&uproc->mutex);
> > > +		ctask = child->utask;
> > > +		if (unlikely(ctask)) {
> > > +			/*
> > > +			 * create_uprocess() ran just as this fork
> > > +			 * happened, and has already created a new utask.
> > > +			 */
> > > +			mutex_unlock(&uproc->mutex);
> > > +			return;
> > > +		}
> > > +		list_for_each_entry(ppt, &uproc->uprobe_list, ut_node) {
> > > +			ret = user_bkpt_remove_bkpt(child, &ppt->user_bkpt);
> >
> > OK, iiuc this should restore the original instruction, right?
> >
> > But what about clone(CLONE_VM)? In this case this child shares ->mm with
> > parent.
>
> Okay, So I will remove the breakpoints only for ! CLONE(CLONE_VM) and
> !CLONE(CLONE_THREAD)
> For CLONE(CLONE_VM) I will create a new uproc and utask structures.
> Since mm is shared; I guess the XOL vma gets shared between the processes.

Yes, I think CLONE_VM without CLONE_THREAD needs utask too, but do we need
the new uproc? OK, please forget about this for the moment.

Suppose that register_uprobe() succeeds and does set_bkpt(). What if another
process (not sub-thread) with the same ->mm hits this bp? uprobe_bkpt_notifier()
will see ->utask == NULL and return 0. Then do_int3() sends SIGTRAP and kills
this task. OK, probably CLONE_VM alone is exotic, but CLONE_VFORK | VM is not.

I think uprobe_process should be per ->mm, not per-process.

I wonder if there any possibility to avoid task_struct->utask, or at least,
if we can allocate it in uprobe_bkpt_notifier() on demand. Not sure.

Oleg.

