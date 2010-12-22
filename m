Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab0LVPPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:15:11 -0500
Received: from mail-bw0-f67.google.com ([209.85.214.67]:44511 "EHLO
	mail-bw0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab0LVPPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 10:15:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aA0atnTPYqYp+B+8TNhW1RgtPXIBoK2IchH6lAYubTpv5v1jPIvaecpmf5JjIE9jFn
         ljf4aMm7KVmM6pJ9ZC3Vd6BZtnSJV2h2auzXtQ+6fi4x/7Jm90S9ZuLdgeJWMXYVN48h
         7/rC3Oh1DugH9DVZcOqQzht5NSTXqXbHU/yTM=
Date: Wed, 22 Dec 2010 16:14:29 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 10/16] ptrace: clean transitions between TASK_STOPPED
 and TRACED
Message-ID: <20101222151429.GC8061@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
 <1291654624-6230-11-git-send-email-tj@kernel.org>
 <20101220150037.GE11583@redhat.com>
 <20101221173155.GE13285@htj.dyndns.org>
 <20101222113948.GA30266@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101222113948.GA30266@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 12:39:48PM +0100, Oleg Nesterov wrote:
> > > This doesn't work if ptrace_attach() races with clone(CLONE_STOPPED).
> > > ptrace_check_attach() can return the wrong ESRCH after that. Perhaps
> > > it is time to kill the CLONE_STOPPED code in do_fork().
> >
> > Ah, thanks for spotting it.  I missed that.  We should be able to
> > convert it to call ptrace_stop(), right?
> 
> Perhaps... But then we should wakeup the new child. Perhaps we can
> just kill that code, CLONE_STOPPED is deprecated and triggers the
> warning since bdff746a (Feb 4 2008).

I see.  Added a patch to kill CLONE_STOPPED.

> > I see.  I can move the transition wait logic into PTRACE_ATTACH.
> > Would that be good enough?
> 
> Yes, I thought about this too. But ptrace's semantics is really strange,
> even if we move wait_on_bit() into ptrace_attach() we still have a
> user-visible change.
> 
> sys_ptrace() only works for the single thread who did PTRACE_ATTACH,
> but do_wait() should work for its sub-threads.
> 
> 	1. the tracer knows that the tracee is stopped
> 
> 	2. the tracer does ptrace(ATTACH)
> 
> 	3. the tracer's sub-thread does do_wait()
> 
> Note! Personally I think we can ignore this "problem", I do not
> think it can break anything except some specialized test-case.

But if ptrace(ATTACH) doesn't return until the transition is complete
when the task is already stopped, the tracer's sub-thread's do_wait()
will behave exactly the same.  The only difference would be that
ptrace(ATTACH) may now block and/or is failed by a signal delivery.

How would #3 behave differently if STOPPED -> TRACED transition is
guaranteed to be complete by the end of #2?

> > This is also related to how to wait for attach completion for a new
> > more transparent attach.  Would it be better for such a request to
> > make sure the operation to complete before returning or is it
> > preferable to keep using wait(2) for that?  We'll probably be able to
> > share the transition wait logic with it.  I think it would be better
> > to return after the attach is actually complete but is there any
> > reason that I'm missing which makes using wait(2) preferrable?
> 
> Oh, I do not know. This is the main problem with ptrace. You can
> always understand what the code does, but you can never know what
> was the supposed behaviour ;)
> 
> That is why I am asking Jan and Roland who understand the userland
> needs.
> 
> Personally, I _think_ it makes sense to keep do_wait() working after
> ptrace_attach(), if it is called by the thread which did attach.
> But perhaps even this is not really important.

Hmmm... I see.  After this fix / cleanup rounds are complete, I'll
just write up something.  It would be much easier to decide which way
to go with a working implementation and switching between wait(2)
based one and with implicit wait shouldn't be too difficult anyway.

> > @@ -1799,22 +1830,28 @@ static int do_signal_stop(int signr)
> > > >  		 */
> > > >  		sig->group_exit_code = signr;
> > > >
> > > > -		current->group_stop = gstop;
> > > > +		current->group_stop &= ~GROUP_STOP_SIGMASK;
> > > > +		current->group_stop |= signr | gstop;
> > > >  		sig->group_stop_count = 1;
> > > > -		for (t = next_thread(current); t != current; t = next_thread(t))
> > > > +		for (t = next_thread(current); t != current;
> > > > +		     t = next_thread(t)) {
> > > > +			t->group_stop &= ~GROUP_STOP_SIGMASK;
> > > >  			/*
> > > >  			 * Setting state to TASK_STOPPED for a group
> > > >  			 * stop is always done with the siglock held,
> > > >  			 * so this check has no races.
> > > >  			 */
> > > >  			if (!(t->flags & PF_EXITING) && !task_is_stopped(t)) {
> > > > -				t->group_stop = gstop;
> > > > +				t->group_stop |= signr | gstop;
> > > >  				sig->group_stop_count++;
> > > >  				signal_wake_up(t, 0);
> > > > -			} else
> > > > +			} else {
> > > >  				task_clear_group_stop(t);
> > >
> > > This looks racy. Suppose that "current" is ptraced, in this case
> > > it can initiate the new group-stop even if SIGNAL_STOP_STOPPED
> > > is set and we have another TASK_STOPPED thead T.
> > >
> > > Suppose that another (or same) debugger ataches to this thread T,
> > > wakes it up and sets GROUP_STOP_TRAPPING.
> > >
> > > T resumes, calls ptrace_stop() in TASK_STOPPED, and temporary drops
> > > ->siglock.

On resume, T is in TASK_RUNNING and the lock is only dropped in
ptrace_stop() if arch_ptrace_stop_needed() is true.

> > > Now, this task_clear_group_stop(T) confuses ptrace_check_attach(T).
> > >
> > > I think ptrace_stop() should be called in TASK_RUNNING state.
> > > This also makes sense because we may call arch_ptrace_stop().
> >
> > I'm feeling a bit too dense to process the above right now.  I'll
> > respond to the above next morning after a strong cup of coffee. :-)
> 
> OK ;)
> 
> But look. Even if the race doesn't exist. ptrace_stop() can drop
> ->siglock and call arch_ptrace_stop() which can fault/sleep/whatever.

So, yes, the temporary lock dropping can definitely confuse
ptrace_check_attach().

> I think this doesn't really matter, but otoh it would be more clean
> to do this in TASK_RUNNING state anyway. At least, in anny case
> arch_ptrace_stop() can return in TASK_RUNNING.

I agree.  I'll update toward that direction.

Thanks.

-- 
tejun
