Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab0LVLre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:47:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab0LVLrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:47:33 -0500
Date: Wed, 22 Dec 2010 12:39:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 10/16] ptrace: clean transitions between TASK_STOPPED
	and TRACED
Message-ID: <20101222113948.GA30266@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-11-git-send-email-tj@kernel.org> <20101220150037.GE11583@redhat.com> <20101221173155.GE13285@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221173155.GE13285@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Tejun Heo wrote:
>
> On Mon, Dec 20, 2010 at 04:00:37PM +0100, Oleg Nesterov wrote:
> > > +
> > > +				wait_on_bit(&child->group_stop, bit,
> >
> > Hmm. we could probably use ->wait_chldexit/__wake_up_parent instead,
> > although I am not sure this would be more clean...
>
> Hmmmm, I actually think that would be cleaner.  I just didn't know it
> was there.  Will convert over to it.

__wake_up_parent() needs tasklist to pin ->parent. But probably in
this particular case we can rely on rcu, or even ->siglock (given
that attach/detach take this lock too).

> > This doesn't work if ptrace_attach() races with clone(CLONE_STOPPED).
> > ptrace_check_attach() can return the wrong ESRCH after that. Perhaps
> > it is time to kill the CLONE_STOPPED code in do_fork().
>
> Ah, thanks for spotting it.  I missed that.  We should be able to
> convert it to call ptrace_stop(), right?

Perhaps... But then we should wakeup the new child. Perhaps we can
just kill that code, CLONE_STOPPED is deprecated and triggers the
warning since bdff746a (Feb 4 2008).

> > ptrace_check_attach()->wait_on_bit() logic fixes the previous example,
> > but:
> >
> > 	1. the tracer knows that the tracee is stopped
> >
> > 	2. the tracer does ptrace(ATTACH)
> >
> > 	3. the tracer does do_wait()
> >
> > In this case do_wait() can see the tracee in TASK_RUNNING state,
> > this breaks wait_task_stopped(ptrace => true).
> >
> > Jan?
>
> I see.  I can move the transition wait logic into PTRACE_ATTACH.
> Would that be good enough?

Yes, I thought about this too. But ptrace's semantics is really strange,
even if we move wait_on_bit() into ptrace_attach() we still have a
user-visible change.

sys_ptrace() only works for the single thread who did PTRACE_ATTACH,
but do_wait() should work for its sub-threads.

	1. the tracer knows that the tracee is stopped

	2. the tracer does ptrace(ATTACH)

	3. the tracer's sub-thread does do_wait()

Note! Personally I think we can ignore this "problem", I do not
think it can break anything except some specialized test-case.

> This is also related to how to wait for attach completion for a new
> more transparent attach.  Would it be better for such a request to
> make sure the operation to complete before returning or is it
> preferable to keep using wait(2) for that?  We'll probably be able to
> share the transition wait logic with it.  I think it would be better
> to return after the attach is actually complete but is there any
> reason that I'm missing which makes using wait(2) preferrable?

Oh, I do not know. This is the main problem with ptrace. You can
always understand what the code does, but you can never know what
was the supposed behaviour ;)

That is why I am asking Jan and Roland who understand the userland
needs.

Personally, I _think_ it makes sense to keep do_wait() working after
ptrace_attach(), if it is called by the thread which did attach.
But perhaps even this is not really important.

> @@ -1799,22 +1830,28 @@ static int do_signal_stop(int signr)
> > >  		 */
> > >  		sig->group_exit_code = signr;
> > >
> > > -		current->group_stop = gstop;
> > > +		current->group_stop &= ~GROUP_STOP_SIGMASK;
> > > +		current->group_stop |= signr | gstop;
> > >  		sig->group_stop_count = 1;
> > > -		for (t = next_thread(current); t != current; t = next_thread(t))
> > > +		for (t = next_thread(current); t != current;
> > > +		     t = next_thread(t)) {
> > > +			t->group_stop &= ~GROUP_STOP_SIGMASK;
> > >  			/*
> > >  			 * Setting state to TASK_STOPPED for a group
> > >  			 * stop is always done with the siglock held,
> > >  			 * so this check has no races.
> > >  			 */
> > >  			if (!(t->flags & PF_EXITING) && !task_is_stopped(t)) {
> > > -				t->group_stop = gstop;
> > > +				t->group_stop |= signr | gstop;
> > >  				sig->group_stop_count++;
> > >  				signal_wake_up(t, 0);
> > > -			} else
> > > +			} else {
> > >  				task_clear_group_stop(t);
> >
> > This looks racy. Suppose that "current" is ptraced, in this case
> > it can initiate the new group-stop even if SIGNAL_STOP_STOPPED
> > is set and we have another TASK_STOPPED thead T.
> >
> > Suppose that another (or same) debugger ataches to this thread T,
> > wakes it up and sets GROUP_STOP_TRAPPING.
> >
> > T resumes, calls ptrace_stop() in TASK_STOPPED, and temporary drops
> > ->siglock.
> >
> > Now, this task_clear_group_stop(T) confuses ptrace_check_attach(T).
> >
> > I think ptrace_stop() should be called in TASK_RUNNING state.
> > This also makes sense because we may call arch_ptrace_stop().
>
> I'm feeling a bit too dense to process the above right now.  I'll
> respond to the above next morning after a strong cup of coffee. :-)

OK ;)

But look. Even if the race doesn't exist. ptrace_stop() can drop
->siglock and call arch_ptrace_stop() which can fault/sleep/whatever.
I think this doesn't really matter, but otoh it would be more clean
to do this in TASK_RUNNING state anyway. At least, in anny case
arch_ptrace_stop() can return in TASK_RUNNING.

> > > @@ -1842,7 +1879,18 @@ static int do_signal_stop(int signr)
> > >
> > >  		spin_lock_irq(&current->sighand->siglock);
> > >  	} else
> > > -		ptrace_stop(current->exit_code, CLD_STOPPED, 0, NULL);
> > > +		ptrace_stop(current->group_stop & GROUP_STOP_SIGMASK,
> > > +			    CLD_STOPPED, 0, NULL);
> >
> > Perhaps it would be more clean to clear ->exit_code here, in the
> > "else" branch.
>
> Hmmm... and dropping current->exit_code clearing from the
> do_signal_stop(), right?  I'm a bit confused about the use of
> current->exit_code tho.

Oh, the right answer is: ptrace shouldn't use ->exit_code at all ;)
And its usage is very confusing.

> Why aren't we clearing it from ptrace_stop()?

ptrace_report_syscall() and ptrace_signal() check ->exit_code after
return from ptrace_stop(), otherwise we ignore the "data" argument
of ptrace_resume/ptrace_detach.

Oleg.

