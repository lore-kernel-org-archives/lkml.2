Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab1CRSlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 14:41:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab1CRSlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 14:41:45 -0400
Date: Fri, 18 Mar 2011 19:32:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>,
        Frantisek Hrbata <fhrbata@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 for 2.6.38] oom: select_bad_process: ignore
	TIF_MEMDIE zombies
Message-ID: <20110318183251.GA13988@redhat.com>
References: <AANLkTikOdG7iTKDKq5mCYhcVz-rgZ_F2Ja78oBCOCQ91@mail.gmail.com> <alpine.DEB.2.00.1103141512310.4425@chino.kir.corp.google.com> <20110315194737.GE21640@redhat.com> <alpine.DEB.2.00.1103151259380.558@chino.kir.corp.google.com> <20110315212754.GB28117@redhat.com> <alpine.DEB.2.00.1103151530200.5099@chino.kir.corp.google.com> <20110316155310.GA9797@redhat.com> <alpine.DEB.2.00.1103161220110.9710@chino.kir.corp.google.com> <20110316202131.GA20790@redhat.com> <alpine.DEB.2.00.1103161332490.11002@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103161332490.11002@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay...

Remove security, this has nothing to do with the released code.
But please see the question at the end...

On 03/16, David Rientjes wrote:
>
> On Wed, 16 Mar 2011, Oleg Nesterov wrote:
>
> > > > 	do {
> > > > 		list_for_each_entry(child, &t->children, sibling) {
> > > > 			unsigned int child_points;
> > > >
> > > > 			/*
> > > > 			 * oom_badness() returns 0 if the thread is unkillable
> > > > 			 */
> > > > 			child_points = oom_badness(child, mem, nodemask,
> > > > 								totalpages);
> > > >
> > > > child->mm can be NULL.
> > > >
> > >
> > > So child_points would be 0 here.
> >
> > Why? oom_badness() checks the whole group. group_leader can exit and
> > pass exit_mm(). But it still the leader and "represents" the whole
> > group even if it exits as thread.
> >
>
> If there are still child threads that have valid mm's, then they are
> eligible for oom kill and all threads sharing that mm will be killed once
> passed to oom_kill_task().  That may be the same as the selected task, p,
> passed to oom_kill_process() but all threads that share the mm would have
> to be killed anyway to free memory.

Not sure I understand... Yes, oom_kill_task() kills all processes that
share the same ->mm. (but to remind, "q->mm == mm" is not right for the
same reason, q->mm can be NULL). But the code above should filter out
the tasks with the same ->mm. It can't.

OK, this is really minor. CLONE_VM processes with the dead leader, this
is really exotics.

> > > > 	if (p->flags & PF_EXITING) {
> > > > 		set_tsk_thread_flag(p, TIF_MEMDIE);
> > > > 		boost_dying_task_prio(p, mem);
> > > > 		return 0;
> > > > 	}
> > > >
> > > > in oom_kill_process() whith -mm patches?
> > > >
> > > > We know that this thread (not process) was chosen by select_bad_process()
> > > > and p->mm != NULL. As Linus rightly pointed, this means this code can only
> > > > work in the small window between exit_signals() and exit_mm().
> > > >
> > > > So, what is the point?
> > > >
> > >
> > > Because there's no need to SIGKILL the task or emit anything to the kernel
> > > log.  We don't want anybody thinking that the oom killer killed it when it
> > > was already exiting on its own.
> >
> > OK. But this case is very unlikely. And I am still trying to understand
> > why this special case is important. But I can't.
> >
>
> It's actually not unlikely at all if mm->mmap_sem is held.

Do you mean OOM from with down_write(mmap_sem) ? OK, in this case we can
see a lot of PF_EXITING && mm threads. But this means they are likely
sleeping in exit_mm()->down_read(), how the code above can help?

> > 	> The combination of testing PF_EXITING and p->mm just doesn't seem to
> > 	> make any sense.
> > 	>
> >
> > 	Right, it doesn't (and I recently removed testing the combination from
> > 	select_bad_process() in -mm).
> >
> > How so? This is what we have now, no?
> >
>
> It's not required functionally for the oom killer,

OK, thanks.

> If any other threads can't actually exit yet,
> then they will automatically be selected when they invoke the oom killer
> (we automatically select current if it is PF_EXITING and the oom killer
> iterates over all threads in -mm) so we don't need to be concerned about
> them stalling at this point.

Again, it is unlikely that another thread triggers oom between exit_signals()
and exit_mm().

And what "other threads" actually mean? If you mean that we already killed
this process (iow, oom_kill_task() sent SIGKILL to any sub-thread in this
group) then yes, this thread probably needs TIF_MEMDIE.

But. In this case current won't call select_bad_process() at all. We have
the fatal_signal_pending() check at the top of out_of_memory(), and this
is the "special" case in oom_kill.c I can understand. I hope ;)

Btw. fatal_signal_pending() is not really good... it can be false negative.
signal_group_exit() looks better.

> In the quote above, Linus was referring to testing PF_EXITING and p->mm in
> oom_kill_process().  It doesn't make any sense if we have already filtered
> p->mm in select_bad_process()

No, I don't think this was the point.

This was discussed assuming the current code, select_bad_process() doesn't
filter !mm threads, and it is not per-thread.

> and we don't want to needlessly kill any
> children because p has executed exit_mm() between its selection and its
> kill: it's on the exit path and will probably be freeing memory soon.

OK, this is reasonable. And this is what I can understand. But this
case looks unlikely, and I am not sure it is right, please see below.

> While this code inspection is interesting, what would probably be more
> interesting is if you have any test cases that are problematic on the
> latest -mm tree

I sent one. it wasn't tested, but should be problematic. Doesn't really
matter, we can fix this.

I am just trying to understand the new "per-thread" direction. I can't.

OK. For example. Two threads T1 and T2. This process uses a lot of memory.

	1. T2 does, say, do_brk() and triggers OOM

	2. T2 calls out_of_memory->select_bad_process() and starts the
	   main do_each_thread() loop.

	   It finds T1, then T2. oom_badness() returns the same value,
	   so select_bad_process() returns T1.

	4. T1 exits, calls exit_mm() and sleeps on down_read().

	5. T2 calls oom_kill_process(), sees PF_EXITING, does
	   set_tsk_thread_flag(T1, TIF_MEMDIE) and returns.

Now. out_of_memory() will be called again, but select_bad_process()
is fooled. It will see T1 before T2 and return ERR_PTR() because of
T1 has TIF_MEMDIE.

And T2 can't access the memory reserves because it lacks TIF_MEMDIE.

No?

Oleg.

