Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab1CVSx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:53:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab1CVSx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:53:56 -0400
Date: Tue, 22 Mar 2011 19:44:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 1/8] job control: Don't set group_stop exit_code if
	re-entering job control stop
Message-ID: <20110322184415.GA28038@redhat.com>
References: <1299614199-25142-1-git-send-email-tj@kernel.org> <1299614199-25142-2-git-send-email-tj@kernel.org> <20110321132024.GA18777@redhat.com> <20110321155250.GE12003@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321155250.GE12003@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21, Tejun Heo wrote:
>
> On Mon, Mar 21, 2011 at 02:20:24PM +0100, Oleg Nesterov wrote:
> > Also. We should take ->group_stop_count != 0 into account, we should not
> > set (change) ->group_exit_code in this case too.
>
> Hmmm... I'm not sure whether this matters.  If the group stop hasn't
> completed yet, I don't think we need to guarantee which one is
> reported.

I agree, this is minor, but

> with
> multithread, the userland has no way to tell which one of the two
> signals actually started group stop so we can report any.  The
> ordering is undefined.

Yes, if two threads dequeue the sig_kernel_stop() signals, the ordering
is undefined. But ptrace should not change sig->group_exit_code once
it was already set by the thread which starts the group stop.

Suppose that debugger PTRACE_CONTs the stopped thread and then it
gets SIGSTOP and calls do_signal_stop() again. In theory this all is
possible before SIGNAL_STOP_STOPPED. This can confuse real_parent.
Say, real_parent itself sends SIGTTIN to the child and naturally
expects WIFSTOPPED() == SIGTTIN.

And btw, I think we should not change/set ->group_stop_count if

But again, even if I am right this is minor and we can change this
later. And btw, I think we should not change/set ->group_stop_count
if SIGNAL_STOP_STOPPED || group_stop_count. We will see.

IOW. In short - you can skip the whole email. I do not see any
real problems which could delay this patch.

> > 			if (!(t->flags & PF_EXITING) && !task_is_stopped(t)) {
> > 				t->group_stop |= signr | gstop;
> > 				sig->group_stop_count++;
> > 				signal_wake_up(t, 0);
> > 			} else {
> > 				task_clear_group_stop_pending(t);
> > 			}
> > 		}
> >
> > Somehow I no longer understand "else task_clear_group_stop_pending()".
> > I mean, is it really needed?
> >
> > If task_is_stopped() == T or it is PF_EXITING, this task has already
> > done task_participate_group_stop(), no?
>
> Hmm... I think this is from the older implementation where
> task_clear_group_stop_pending() did more than just clearing the two
> flags.  We can remove it.

OK, good.

> > Also. I do not think it is correct to change the "signr" part of
> > ->group_stop (unless it is zero) when ->group_stop_count != 0
> > for other threads. This is minor, but still doesn't look exactly
> > correct. Probably we can ignore this.
>
> GROUP_STOP_SIGMASK only affects ptracers.  The extra stop signal is
> visible to one ptracer and possibly other ptracers too, so I think
> it's more appropriate to report the newest signal.  Please consider
> the following scenario.
>
> * Two threads in a process.  SIGNAL_STOP_STOPPED.
>
> * PTRACE_ATTACH on both threads and both are PTRACE_CONT'd.
>
> * A stopsig is delivered to one of them which initiates group stop.
>
> * Both ptracers notice the tracees participating in the group stop.

Sure, this is correct. But I meant another case. In the scenario
above, suppose that only one thread was PTRACE_CONT'ed.

Again, again, again. This is very minor. I do not mean it makes sense
to change this, at least right now. Just I have a vague feeling we
can cleanup this a little bit later.

For example. Ignoring task_participate_group_stop(), why
task_clear_group_stop_pending() preserves the GROUP_STOP_SIGMASK ?
This doesn't hurt, sure. But looks a bit inconsistent.

Anyway, please forget. Right now this is off-topic.

> > Hmm. it turns out "group_stop & GROUP_STOP_SIGMASK" is only needed
> > to handle this special case: if debugger PTRACE_CONT's or more
> > stopped tracees and then som thread initiates the stop again, other
> > threads need to know that "signr". Otherwise this part of ->group_stop
> > is only valid "inside" the retry loop in do_signal_stop(), it can
> > be a local variable. I wonder if we can simply report SIGSTOP in
> > this case and kill the GROUP_STOP_SIGMASK logic. Nevermind.
>
> I think there was a reason why it couldn't be a local variable.  Let's
> see if I can remember it.  Ah, okay, please consider the following
> scenario.  This one needs to be documented.
>
> * A thread does group stop and the parent consumed exit code.
>
> * ptracer attaches and sees the group stop signal.
>
> * PTRACE_CONT and the thread leaves do_signal_stop().
>
> * PTRACE_DETACH.  The thread returns to do_signal_stop() and re-enters
>   TASK_STOPPED.
>
> * Another ptracer does PTRACE_ATTACH.
>
> The second ptracer wants to know the signo too but if it were stored
> in a local variable, it wouldn't be available anywhere.

Yes, sure. But this is basically the same case. My point was, this
signr must be correct inside the retry loop, otherwise we could just
report SIGSTOP because we can't guarantee the "correct" signr anyway.

Let's look at your example again. Suppose that the process was stopped
by SIGSTOP.

When the first ptracer attaches, each thread correctly reports SIGSTOP.
But if it plays with PTRACE_CONT and then detaches, the next ptracer can
see, say, SIGTTIN. And different threads can report different signals.


Again, again, again. I do not want to delay this changes. But _perhaps_
we can cleanup this a bit later.

OK, lets keep GROUP_STOP_SIGMASK. Then, perhaps, we should never change
"group_stop & GROUP_STOP_SIGMASK" if it is non-zero. PTRACE_CONT should
clear it.

The only special case is stop->PTRACE_CONT->do_signal_stop(). In this
case the tracee should keep its "group_stop & GROUP_STOP_SIGMASK" but
use "int signr" passed to do_signal_stop() as an argument for
ptrace_stop().

Not that I seriously think this needs the attention. In any case,
not now.

> > And. I think this code does something we do not really want. Why do
> > we _always_ ask the task_is_traced() threads to participate?
> >
> > 2 threads T1 and T2, both stopped. they are TASK_TRACED, I mean
> > SIGNAL_STOP_STOPPED is stopped and both have already participated.
> >
> > Debuggere PTRACE_CONTs T1, then it calls do_signal_stop() again
> > and sets T2->group_stop = GROUP_STOP_PENDING | GROUP_STOP_CONSUME.
> > This T2->group_stop doesn't look right, we can report the wrong
> > extra CLD_STOPPED after detach while ->group_exit_code can be 0.
> > I think that !task_ptrace(current) case in do_signal_stop() should
> > take SIGNAL_STOP_STOPPED into account, but perhaps we need another
> > GROUP_STOP_REPORTED bit, I am not sure.
>
> Isn't this addressed by the last patch in this thread?

Yes, it was.

> > Or, if debugger PTRACE_CONT's T2, it will report another
> > ptrace_stop(CLD_STOPPED) immediately, this differs from the current
> > behaviour although probably we do not care.
>
> This was changed by "signal: Use GROUP_STOP_PENDING to stop once for a
> single group stop".

Not sure I understand... We are setting GROUP_STOP_PENDING | CONSUME
again. T2 has already reported ptrace_stop(CLD_STOPPED) to the tracer.
It is stopped. Now it will report another CLD_STOPPED after PTRACE_CONT.

Oleg.

