Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab1IZRi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 13:38:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab1IZRi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 13:38:28 -0400
Date: Mon, 26 Sep 2011 19:34:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: 3.1 && ptrace/jobctl problems
Message-ID: <20110926173456.GA18216@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

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

