Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab1CUP5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 11:57:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64639 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab1CUP47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 11:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QSHjLftkz8oYCeVahScX8zAGKU5vS17bklR1Kysp8wPTHb5nAYFlaREAjbS8aNodU4
         9KDKBvKJQJ6AIghKvGy2o+Haz0GrrC98WbhWZdcNUbe381CfRQxcEWrrh3dcvN6/peLB
         x7UgBtn2hVzQ0hXoFXrLhquLuoArUIjXT3Gyw=
Date: Mon, 21 Mar 2011 16:52:50 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 1/8] job control: Don't set group_stop exit_code if
 re-entering job control stop
Message-ID: <20110321155250.GE12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
 <1299614199-25142-2-git-send-email-tj@kernel.org>
 <20110321132024.GA18777@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321132024.GA18777@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Mon, Mar 21, 2011 at 02:20:24PM +0100, Oleg Nesterov wrote:
> I hope you still remember you sent these patches, perhaps you can
> even recall what they should do ;)

Yeah, was about to ping you actually.  BTW, I biked for a couple of
hours and had a beer and am feeling pretty stupid at the moment, so my
chance of writing something stupid is higher than usual.

> > -		sig->group_exit_code = signr;
> > +		if (!(sig->flags & SIGNAL_STOP_STOPPED))
> > +			sig->group_exit_code = signr;
> > +		else
> > +			WARN_ON_ONCE(!task_ptrace(current));
> 
> Yes. But WARN_ON_ONCE() is wrong. Suppose that the tracee was stopped,
> then PTRACE_CONT'ed, then it gets another SIGSTOP and reports it. Now
> suppose that debugger does PTRACE_CONT(SIGSTOP) and exits before the
> tracee processes this signal.

I see.  It can't happen for PTRACE_DETACH due to ptrace_check_attach()
but can if the debugger is exiting.

> OTOH, this WARN_ON_ONCE() makes sense, but we should fix __ptrace_unlink().
> This path should take siglock and check SIGNAL_STOP_STOPPED unconditionally.
> This should also fix other problems with detach && SIGNAL_STOP_STOPPED.

Right, the task_is_traced() tests.  I agree that the culprit is
__ptrace_unlink().  It should always put the tracee in the appropriate
state.  I'll prep a patch for this.

> Also. We should take ->group_stop_count != 0 into account, we should not
> set (change) ->group_exit_code in this case too.

Hmmm... I'm not sure whether this matters.  If the group stop hasn't
completed yet, I don't think we need to guarantee which one is
reported.  With single thread, the condition can't happen and, with
multithread, the userland has no way to tell which one of the two
signals actually started group stop so we can report any.  The
ordering is undefined.

It might be cleaner that way but I think the current code could be
easier to explain.  Mights and coulds.

> But lets look at the code below,
> 
> 		for (t = next_thread(current); t != current;
> 		     t = next_thread(t)) {
> 			t->group_stop &= ~GROUP_STOP_SIGMASK;
> 			/*
> 			 * Setting state to TASK_STOPPED for a group
> 			 * stop is always done with the siglock held,
> 			 * so this check has no races.
> 			 */
> 			if (!(t->flags & PF_EXITING) && !task_is_stopped(t)) {
> 				t->group_stop |= signr | gstop;
> 				sig->group_stop_count++;
> 				signal_wake_up(t, 0);
> 			} else {
> 				task_clear_group_stop_pending(t);
> 			}
> 		}
> 
> Somehow I no longer understand "else task_clear_group_stop_pending()".
> I mean, is it really needed?
> 
> If task_is_stopped() == T or it is PF_EXITING, this task has already
> done task_participate_group_stop(), no?

Hmm... I think this is from the older implementation where
task_clear_group_stop_pending() did more than just clearing the two
flags.  We can remove it.

> Also. I do not think it is correct to change the "signr" part of
> ->group_stop (unless it is zero) when ->group_stop_count != 0
> for other threads. This is minor, but still doesn't look exactly
> correct. Probably we can ignore this.

GROUP_STOP_SIGMASK only affects ptracers.  The extra stop signal is
visible to one ptracer and possibly other ptracers too, so I think
it's more appropriate to report the newest signal.  Please consider
the following scenario.

* Two threads in a process.  SIGNAL_STOP_STOPPED.

* PTRACE_ATTACH on both threads and both are PTRACE_CONT'd.

* A stopsig is delivered to one of them which initiates group stop.

* Both ptracers notice the tracees participating in the group stop.

> Hmm. it turns out "group_stop & GROUP_STOP_SIGMASK" is only needed
> to handle this special case: if debugger PTRACE_CONT's or more
> stopped tracees and then som thread initiates the stop again, other
> threads need to know that "signr". Otherwise this part of ->group_stop
> is only valid "inside" the retry loop in do_signal_stop(), it can
> be a local variable. I wonder if we can simply report SIGSTOP in
> this case and kill the GROUP_STOP_SIGMASK logic. Nevermind.

I think there was a reason why it couldn't be a local variable.  Let's
see if I can remember it.  Ah, okay, please consider the following
scenario.  This one needs to be documented.

* A thread does group stop and the parent consumed exit code.

* ptracer attaches and sees the group stop signal.

* PTRACE_CONT and the thread leaves do_signal_stop().

* PTRACE_DETACH.  The thread returns to do_signal_stop() and re-enters
  TASK_STOPPED.

* Another ptracer does PTRACE_ATTACH.

The second ptracer wants to know the signo too but if it were stored
in a local variable, it wouldn't be available anywhere.

> And. I think this code does something we do not really want. Why do
> we _always_ ask the task_is_traced() threads to participate?
> 
> 2 threads T1 and T2, both stopped. they are TASK_TRACED, I mean
> SIGNAL_STOP_STOPPED is stopped and both have already participated.
> 
> Debuggere PTRACE_CONTs T1, then it calls do_signal_stop() again
> and sets T2->group_stop = GROUP_STOP_PENDING | GROUP_STOP_CONSUME.
> This T2->group_stop doesn't look right, we can report the wrong
> extra CLD_STOPPED after detach while ->group_exit_code can be 0.
> I think that !task_ptrace(current) case in do_signal_stop() should
> take SIGNAL_STOP_STOPPED into account, but perhaps we need another
> GROUP_STOP_REPORTED bit, I am not sure.

Isn't this addressed by the last patch in this thread?

> Or, if debugger PTRACE_CONT's T2, it will report another
> ptrace_stop(CLD_STOPPED) immediately, this differs from the current
> behaviour although probably we do not care.

This was changed by "signal: Use GROUP_STOP_PENDING to stop once for a
single group stop".  The previous behavior was inconsistent.  If the
tracee was running it would get notified; otherwise, not.  Also, the
tracer could be notified multiple times for the same group stop.  I
think the new behavior is sane and falls within the boundaries set by
the inconsistencies of the previous behavior.

Thanks.

-- 
tejun
