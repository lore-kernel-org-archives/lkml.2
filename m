Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab1EIIiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 04:38:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58039 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1EIIh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 04:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lK1M8il0jQlwMdMgFZA6WB+/NhWd2f4VZcxLq0GQ3lqcfuePKZisjnIgdbbJTnLukZ
         mjQ0I84iwX2p/dbZ45CzfN/qXIek2dSRyd3bc2JH+8YNbCsQpBNHAGyUjQgHPNvs4ATA
         ZwzUUCWToUKlj82HvF6enFiRGQbshQl9xwU4U=
Date: Mon, 9 May 2011 10:37:54 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH ptrace] ptrace: use GROUP_STOP_TRAPPING for
 PTRACE_DETACH too
Message-ID: <20110509083754.GC1661@htj.dyndns.org>
References: <20110508144424.GB29783@htj.dyndns.org>
 <20110508160720.GA11705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110508160720.GA11705@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Sun, May 08, 2011 at 06:07:20PM +0200, Oleg Nesterov wrote:
> > 	  for (i = 0; i < 100000; i++) {
> > 		  ptrace(PTRACE_ATTACH, tracee, NULL, NULL);
> > 		  waitid(P_PID, tracee, &si, WSTOPPED | WNOHANG);
> > 		  if (!si.si_pid)
> > 			  nr_wait_fails++;
> 
> OK, this is clear, waitid(WSTOPPED | WNOHANG) can fail if it sees the
> tracee inside the transition.
> 
> But,
> 
> > 		  if (ptrace(PTRACE_DETACH, tracee, NULL, NULL)) {
> > 			  nr_ptrace_fails++;
> 
> I assume this can only fail for the same reason if waitid() fails?
> Or there is something else?

Oh yeah, I was just curious about the timing and see how many fail
waitid() but succeed ptrace().

> >  	/*
> >  	 * Reinstate GROUP_STOP_PENDING if group stop is in effect and
> > -	 * @child isn't dead.
> > +	 * @child isn't dead.  This will trigger TRACED -> RUNNING ->
> > +	 * STOPPED transition.  As this transition can affect the next
> > +	 * ptracer if it attaches before the transition completes, set
> > +	 * TRAPPING too.  Read comment in ptrace_attach() for more details.
> >  	 */
> >  	if (!(child->flags & PF_EXITING) &&
> >  	    (child->signal->flags & SIGNAL_STOP_STOPPED ||
> >  	     child->signal->group_stop_count))
> > -		child->group_stop |= GROUP_STOP_PENDING;
> > +		child->group_stop |= GROUP_STOP_PENDING | GROUP_STOP_TRAPPING;
> 
> This doesn't look safe, see below. We do not know what the tracee does,
> it can be even running.

Ah, right.  Setting TRAPPING should probably depend on JOBCTL_TRAPPED
flag which is added later.

> >  static int ptrace_attach(struct task_struct *task)
> >  {
> > -	bool wait_trap = false;
> >  	int retval;
> >
> >  	audit_ptrace(task);
> > @@ -245,7 +247,6 @@ static int ptrace_attach(struct task_str
> >  	if (task_is_stopped(task)) {
> >  		task->group_stop |= GROUP_STOP_PENDING | GROUP_STOP_TRAPPING;
> >  		signal_wake_up(task, 1);
> > -		wait_trap = true;
> >  	}
> >
> >  	spin_unlock(&task->sighand->siglock);
> > @@ -256,9 +257,8 @@ unlock_tasklist:
> >  unlock_creds:
> >  	mutex_unlock(&task->signal->cred_guard_mutex);
> >  out:
> > -	if (wait_trap)
> > -		wait_event(current->signal->wait_chldexit,
> > -			   !(task->group_stop & GROUP_STOP_TRAPPING));
> > +	wait_event(current->signal->wait_chldexit,
> > +		   !(task->group_stop & GROUP_STOP_TRAPPING));
> 
> Suppose that SIGCONT or, worse, SIGKILL comes in between.

Please ignore this one for now.  I'll re-do it after the SEIZE series.

Thanks.

-- 
tejun
