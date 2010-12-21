Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab0LURcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:32:04 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:62046 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0LURcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:32:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=am6HAv8qIZgdW7NGhnf52fKoT0BkQjC+h+mPWtpZPiUqZmOP2+EarKB8XSz722dPUc
         gVLd271QH0f7tvc15fsxqcbXZ182qpOArFXlsxBmb1zzQwOmtHZgS4K7P984PVg5uZ2i
         JtDDRLbQD9LqN4Qq4sXG/dm6jpxAFWnh6D8Mg=
Date: Tue, 21 Dec 2010 18:31:56 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 10/16] ptrace: clean transitions between TASK_STOPPED
 and TRACED
Message-ID: <20101221173155.GE13285@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
 <1291654624-6230-11-git-send-email-tj@kernel.org>
 <20101220150037.GE11583@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220150037.GE11583@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 04:00:37PM +0100, Oleg Nesterov wrote:
> > +		if (!task_is_traced(child) && !kill) {
> > +			/*
> > +			 * If GROUP_STOP_TRAPPING is set, it is known that
> > +			 * the tracee will enter either TRACED or the bit
> > +			 * will be cleared in definite amount of (userland)
> > +			 * time.  Wait while the bit is set.
> > +			 *
> > +			 * This hides PTRACE_ATTACH initiated transition
> > +			 * from STOPPED to TRACED from userland.
> > +			 */
> > +			if (child->group_stop & GROUP_STOP_TRAPPING) {
> > +				const int bit = ilog2(GROUP_STOP_TRAPPING);
> > +				DEFINE_WAIT_BIT(wait, &child->group_stop, bit);
> 
> Unused "wait_bit_queue wait"

Oops, left over from a previous waitqueue based implementation.

> > +
> > +				spin_unlock_irq(&child->sighand->siglock);
> > +				read_unlock(&tasklist_lock);
> > +
> > +				wait_on_bit(&child->group_stop, bit,
> 
> Hmm. we could probably use ->wait_chldexit/__wake_up_parent instead,
> although I am not sure this would be more clean...

Hmmmm, I actually think that would be cleaner.  I just didn't know it
was there.  Will convert over to it.

> > +					    ptrace_wait_trap,
> > +					    TASK_UNINTERRUPTIBLE);
> 
> I am nervous ;) To me, TASK_KILLABLE makes more sense, and it is
> safer if we have a bug.

Sure thing.

> > +				goto relock;
> 
> We already set ret = 0. "relock" should set -ESRCH.
> 
> > +			}
> >  			ret = -ESRCH;
> > +		}
> 
> Probably this deserves a minor cleanup,
> 
> 	relock:
> 		ret = -ESRCH;
> 		read_lock(&tasklist_lock);
> 		if (task_is_traced() || kill) {
> 			ret = 0;
> 		} else {
> 		...

Updated.

> OK. So, ptrace_attach() asks a stopped tracee to s/STOPPED/TRACED/.
> If it is not stopped, it should call ptrace_stop() eventually.
> 
> This doesn't work if ptrace_attach() races with clone(CLONE_STOPPED).
> ptrace_check_attach() can return the wrong ESRCH after that. Perhaps
> it is time to kill the CLONE_STOPPED code in do_fork().

Ah, thanks for spotting it.  I missed that.  We should be able to
convert it to call ptrace_stop(), right?

> > @@ -204,6 +231,26 @@ int ptrace_attach(struct task_struct *task)
> >  	__ptrace_link(task, current);
> >  	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
> >
> > +	spin_lock(&task->sighand->siglock);
> > +
> > +	/*
> > +	 * If the task is already STOPPED, set GROUP_STOP_PENDING and
> > +	 * TRAPPING, and kick it so that it transits to TRACED.  TRAPPING
> > +	 * will be cleared if the child completes the transition or any
> > +	 * event which clears the group stop states happens.  The bit is
> > +	 * waited by ptrace_check_attach() to hide the transition from
> > +	 * userland.
> > +	 *
> > +	 * The following is safe as both transitions in and out of STOPPED
> > +	 * are protected by siglock.
> > +	 */
> > +	if (task_is_stopped(task)) {
> > +		task->group_stop |= GROUP_STOP_PENDING | GROUP_STOP_TRAPPING;
> > +		signal_wake_up(task, 1);
> > +	}
> > +
> > +	spin_unlock(&task->sighand->siglock);
> 
> Well. I do not know whether this matters, but "hide the transition from
> userland" is not 100% correct. I mean, this change is still visible.
> 
> ptrace_check_attach()->wait_on_bit() logic fixes the previous example,
> but:
> 
> 	1. the tracer knows that the tracee is stopped
> 
> 	2. the tracer does ptrace(ATTACH)
> 
> 	3. the tracer does do_wait()
> 
> In this case do_wait() can see the tracee in TASK_RUNNING state,
> this breaks wait_task_stopped(ptrace => true).
> 
> Jan?

I see.  I can move the transition wait logic into PTRACE_ATTACH.
Would that be good enough?

This is also related to how to wait for attach completion for a new
more transparent attach.  Would it be better for such a request to
make sure the operation to complete before returning or is it
preferable to keep using wait(2) for that?  We'll probably be able to
share the transition wait logic with it.  I think it would be better
to return after the attach is actually complete but is there any
reason that I'm missing which makes using wait(2) preferrable?

> > @@ -1799,22 +1830,28 @@ static int do_signal_stop(int signr)
> >  		 */
> >  		sig->group_exit_code = signr;
> >
> > -		current->group_stop = gstop;
> > +		current->group_stop &= ~GROUP_STOP_SIGMASK;
> > +		current->group_stop |= signr | gstop;
> >  		sig->group_stop_count = 1;
> > -		for (t = next_thread(current); t != current; t = next_thread(t))
> > +		for (t = next_thread(current); t != current;
> > +		     t = next_thread(t)) {
> > +			t->group_stop &= ~GROUP_STOP_SIGMASK;
> >  			/*
> >  			 * Setting state to TASK_STOPPED for a group
> >  			 * stop is always done with the siglock held,
> >  			 * so this check has no races.
> >  			 */
> >  			if (!(t->flags & PF_EXITING) && !task_is_stopped(t)) {
> > -				t->group_stop = gstop;
> > +				t->group_stop |= signr | gstop;
> >  				sig->group_stop_count++;
> >  				signal_wake_up(t, 0);
> > -			} else
> > +			} else {
> >  				task_clear_group_stop(t);
> 
> This looks racy. Suppose that "current" is ptraced, in this case
> it can initiate the new group-stop even if SIGNAL_STOP_STOPPED
> is set and we have another TASK_STOPPED thead T.
> 
> Suppose that another (or same) debugger ataches to this thread T,
> wakes it up and sets GROUP_STOP_TRAPPING.
> 
> T resumes, calls ptrace_stop() in TASK_STOPPED, and temporary drops
> ->siglock.
> 
> Now, this task_clear_group_stop(T) confuses ptrace_check_attach(T).
> 
> I think ptrace_stop() should be called in TASK_RUNNING state.
> This also makes sense because we may call arch_ptrace_stop().

I'm feeling a bit too dense to process the above right now.  I'll
respond to the above next morning after a strong cup of coffee. :-)

> > +				t->group_stop |= signr;
> 
> Probably this doesn't really matter, but why do we need to
> change the GROUP_STOP_SIGMASK part of t->group_stop? If it
> is exiting, this is not needed. If it is already stopped, then
> it already has the correct (previous) signr.

The GROUP_STOP_SIGMASK part of t->group_stop is supposed to track the
signr of the latest stop attempt.  Hmmm... but yeah, not changing the
value there would result in more consistent behavior.  Updating...

> > +			}
> > +		}
> >  	}
> > -
> > +retry:
> >  	current->exit_code = sig->group_exit_code;
> >  	__set_current_state(TASK_STOPPED);
> 
> It is no longer needed to set ->exit_code here. The only reason
> was s/STOPPED/TRACED/ change in ptrace_check_attach(). Now that
> we rely on ptrace_stop() which sets ->exit_state, this can be
> removed.

I see.  Removed.

> And,
> 
> > @@ -1842,7 +1879,18 @@ static int do_signal_stop(int signr)
> >
> >  		spin_lock_irq(&current->sighand->siglock);
> >  	} else
> > -		ptrace_stop(current->exit_code, CLD_STOPPED, 0, NULL);
> > +		ptrace_stop(current->group_stop & GROUP_STOP_SIGMASK,
> > +			    CLD_STOPPED, 0, NULL);
> 
> Perhaps it would be more clean to clear ->exit_code here, in the
> "else" branch.

Hmmm... and dropping current->exit_code clearing from the
do_signal_stop(), right?  I'm a bit confused about the use of
current->exit_code tho.  Why aren't we clearing it from ptrace_stop()?

Thanks.

-- 
tejun
