Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab2ADLl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 06:41:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab2ADLlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 06:41:25 -0500
Date: Wed, 4 Jan 2012 12:35:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
        =?utf-8?Q?=C5=81ukasz?= Michalik <lmi@ift.uni.wroc.pl>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: ptrace fixes for 3.2
Message-ID: <20120104113534.GA15307@redhat.com>
References: <201112281955.55200.vda.linux@googlemail.com> <20111229113245.GA18062@redhat.com> <20111229120506.GA23653@redhat.com> <20120103142941.GA25488@redhat.com> <20120103154404.GA28930@redhat.com> <20120103163023.GA31746@google.com> <20120103170927.GA31795@redhat.com> <20120103191808.GF31746@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103191808.GF31746@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/03, Tejun Heo wrote:
>
> On Tue, Jan 03, 2012 at 06:09:27PM +0100, Oleg Nesterov wrote:
>
> > 	2. We can not rely on ->ptrace to detect this case.
> >
> > 	   Suppose that the tracer is multithreaded, it has
> > 	   two threads T1 and T2, T1 traces our child.
> >
> > 	   - T2 does do_wait(WEXITED), sets EXIT_DEAD, drops
> > 	     tasklist_lock.
> >
> > 	   - T1 exits and does __ptrace_detach(), this means
> > 	     __ptrace_unlink() and nothing more.
> >
> > 	   - Now, real_parent does do_wait() and sees the
> > 	     EXIT_DEAD child but ->ptrace = 0.
> >
> > 	   - finally T2 sets EXIT_DEAD but it is too late,
>
> You mean EXIT_ZOMBIE here, right?

Yes, typo...

> So, to rephrase, ZOMBIE -> DEAD ->
> ZOMBIE dancing may race against tracer detaching.  Urgh... why do we
> even allow tasks which aren't the direct tracer to wait for ptraced
> children anyway when ptrace ops are restricted to the ptracing task?

If only I knew ;) I am not even sure this is by design... OTOH, it is
not clear how we should restrict do_wait() if the tracee is not
ptrace_reparented().

Anyway we can't change this.

> > I am not sure too. But why do_wait() should sleep if it is called
> > without WEXITED (lets ignore WCONTINUED) and the child is ZOMBIE?
> > I think it should return -ECHILD, like it does if the child is not
> > traced.
> >
> > IOW. Suppose we have a single EXIT_ZOMBIE child. If it is not traced,
> > do_wait(WSTOPPED) returns -ECHILD. If the child is traced (by another
> > process) do_wait() sleeps until detach just to return the same error.
> > This looks a bit strange.
>
> I don't think it really matter either way.  To me, both behaviors seem
> understandable and I don't think the current behavior would cause any
> real problem.

Yes I agree this is minor, surely not a bug.

OK, in any case this has nothing to do with this fix, I'll remove this
sentence from the changelog to avoid the confusion.

Tejun, do you see any problem with the 2nd fix below?

Oleg.

------------------------------------------------------------------------------
Can't understand how did we miss this, but WARN_ON_ONCE(!ptrace)
in do_signal_stop() is not right. Debugger can resume the stopped
task, and it can clone the _untraced_ thread running in the stopped
group.

And even if the new thread is auto-attached, we have the problems
with JOBCTL_STOP_SIGMASK.

I do not want to discuss the "proper" solution here. I think the
necessary changes are simple, but I do not think this is the 3.1
material, and 3.1 needs some trivial fix.

What do you think about the patch below? I am going to send it to
Linus unless you see something wrong.




And I'd like to explain why I prefer to add the (temporary) hack
into __ptrace_unlink() instead of adding

	if (unlikely(ptrace) && current->ptrace) {
		...
		child->jobctl = current->jobctl & JOBCTL_STOP_SIGMASK;
		...
	}

into ptrace_init_task(). I think that jobctl & JOBCTL_STOP_SIGMASK"
should be cleanuped. Look, once we set JOBCTL_STOP_SIGMASK we never
clear it. Yes, this doesn't really matter but this can hide an error,
for example this can "fool" the WARN_ON(!signr) in do_jobctl_trap().
Imho, at least SIGCONT should clear this part of ->jobctl. IOW, it
should be non-zero only if/when it has effect.

That is why I do not want to change ptrace_init_task() until we
decide what should we do with CLONE_THREAD && SIGNAL_STOP_STOPPED,
to avoid the bogus (jobctl & JOBCTL_STOP_SIGMASK) != 0. IOW I prefer
the change in __ptrace_unlink() to catch the other possible problems
like this.

Also, I'd like to defend 6634ae10
"ptrace_init_task: initialize child->jobctl explicitly" which can
be blamed for the 2nd problem. Afaics, this change is really needed
and it fixes the bug. The changelog says "Currently this is harmless"
but this is not right, dup_task_struct() can happen between SIGSTOP and
SIGCONT, in this case the child can have the wrong JOBCTL_STOP_PENDING.

So, what do you think?

Oleg.

-------------------------------------------------------------------------------
[PATCH for 3.1] ptrace_unlink: ensure JOBCTL_STOP_SIGMASK is not zero

This is the temporary simple fix for 3.1, we need more changes in this
area.

1. do_signal_stop() assumes that the running untraced thread in the
   stopped thread group is not possible. This was our goal but it is
   not yet achieved: a stopped-but-resumed tracee can clone the running
   thread which can initiate another group-stop.

   Remove WARN_ON_ONCE(!current->ptrace).

2. A new thread always starts with ->jobctl = 0. If it is auto-attached
   and this group is stopped, __ptrace_unlink() sets JOBCTL_STOP_PENDING
   but JOBCTL_STOP_SIGMASK part is zero, this triggers WANR_ON(!signr)
   in do_jobctl_trap() if another debugger attaches.

   Change __ptrace_unlink() to set the artificial SIGSTOP for report.

   Alternatively we could change ptrace_init_task() to copy signr from
   current, but this means we can copy it for no reason and hide the
   possible similar problems.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |    2 --
 kernel/ptrace.c |   13 ++++++++++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

--- 3.1/kernel/signal.c~2_traced_stop_and_clone	2011-09-25 19:14:32.000000000 +0200
+++ 3.1/kernel/signal.c	2011-09-25 19:53:54.000000000 +0200
@@ -1986,8 +1986,6 @@ static bool do_signal_stop(int signr)
 		 */
 		if (!(sig->flags & SIGNAL_STOP_STOPPED))
 			sig->group_exit_code = signr;
-		else
-			WARN_ON_ONCE(!current->ptrace);
 
 		sig->group_stop_count = 0;
 
--- 3.1/kernel/ptrace.c~2_traced_stop_and_clone	2011-09-25 19:40:57.000000000 +0200
+++ 3.1/kernel/ptrace.c	2011-09-25 20:05:25.000000000 +0200
@@ -96,9 +96,20 @@ void __ptrace_unlink(struct task_struct 
 	 */
 	if (!(child->flags & PF_EXITING) &&
 	    (child->signal->flags & SIGNAL_STOP_STOPPED ||
-	     child->signal->group_stop_count))
+	     child->signal->group_stop_count)) {
 		child->jobctl |= JOBCTL_STOP_PENDING;
 
+		/*
+		 * This is only possible if this thread was cloned by the
+		 * traced task running in the stopped group, set the signal
+		 * for the future reports.
+		 * FIXME: we should change ptrace_init_task() to handle this
+		 * case.
+		 */
+		if (!(child->jobctl & JOBCTL_STOP_SIGMASK))
+			child->jobctl |= SIGSTOP;
+	}
+
 	/*
 	 * If transition to TASK_STOPPED is pending or in TASK_TRACED, kick
 	 * @child in the butt.  Note that @resume should be used iff @child

