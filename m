Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab1CaH3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 03:29:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52805 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab1CaH3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 03:29:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=csfWvI8tFD3uLTIr68YFfFXYLhpfUEAGlBj6Zs1k/9XidBEOtNFtDpyiTc1ehc+wfO
         5gg0VJMM1sKLrBzU4WLVmjdoa/zg57BtfbwiMucbJAJcemiA9ra1q71T37pyTN22kF2x
         V3+wANyOH6jigNuavjCl0qNOlPHUjmDRTjRL4=
Date: Thu, 31 Mar 2011 09:29:42 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: Re: [PATCH 3/3] signal, ptrace: Fix delayed CONTINUED notification
 when ptraced
Message-ID: <20110331072942.GB3385@htj.dyndns.org>
References: <20110329144603.GA29865@htj.dyndns.org>
 <20110329144648.GB29865@htj.dyndns.org>
 <20110329144710.GC29865@htj.dyndns.org>
 <20110330192918.GA14861@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330192918.GA14861@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Wed, Mar 30, 2011 at 09:29:18PM +0200, Oleg Nesterov wrote:
> > @@ -652,6 +657,21 @@ void signal_wake_up(struct task_struct *t, int sig_type)
> >  		mask = TASK_INTERRUPTIBLE;
> >  		break;
> >
> > +	case SIGCONT:
> > +		/*
> > +		 * If there is a handler for SIGCONT, we must make sure
> > +		 * that no thread returns to user mode before we post the
> > +		 * signal, in case it was the only thread eligible to run
> > +		 * the signal handler--then it must not do anything between
> > +		 * resuming and running the handler.  This is ensured by
> > +		 * setting TIF_SIGPENDING before waking up.
> > +		 */
> > +		mask = __TASK_STOPPED;
> > +		if (sig_user_defined(t, SIGCONT) &&
> > +		    !sigismember(&t->blocked, SIGCONT))
> > +			mask |= TASK_INTERRUPTIBLE;
> > +		break;
> > +
> >  	case SIGTRAP:
> >  		mask = TASK_INTERRUPTIBLE | __TASK_STOPPED | __TASK_TRACED;
> >  		break;
> > @@ -821,31 +841,9 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
> >  		rm_from_queue(SIG_KERNEL_STOP_MASK, &signal->shared_pending);
> >  		t = p;
> >  		do {
> > [...snip...]
> > -			wake_up_state(t, state);
> > +			signal_wake_up(t, SIGCONT);
> >  		} while_each_thread(p, t);
> 
> I don't think this logic should be moved into signal_wake_up(). Simply
> because it is wrong.
>
> Forget about SIGSTOP. Suppose that the thread group is running, and we
> are doing tkill(SIGCONT). Now, why every thread gets TIF_SIGPENDING +
> wakeup? This is not correct.

Right, while running, it generates spurious TIF_SIGPENDINGs.  It can
be trivially worked around by testing if (group_stop_count ||
STOP_STOPPED) before calling signal_wake_up().

> Even the kill(SIGCONT) case is not exactly right. This should be
> handled by complete_signal(). I think we had to set TIF_SIGPENDING
> before, now the locking is different. I'll try to make the patch.

The wake up is for continuation from group stop, which should be
handled simiarly to signal delivery but isn't exactly the same thing.
Maybe moving it to complete_signal() is cleaner but I don't think it's
a problem of being right or wrong.

> Now, lets recall about ptrace. But please forget about the lost
> notification. We are going to implement the new trap anyway. Ignoring
> all details, how we can implement this? I think the most natural and
> approach is something like this:
> 
> 	- add the new GROUP_STOP_CONTTRAP (the name is random), it
> 	  lives in task->group_stop
> 
> 	- this bit should be considered by recalc_sigpending_tsk()
> 	  along with GROUP_STOP_PENDING
> 
> 	- it should be set by prepare_signal(SIGCONT) if the task
> 	  is traced
> 
> 	- this bit should be checked by get_signal_to_deliver() to
> 	  trigger ptrace_stop()
> 
> Does this make any sense?

Yeah, that sounds reasonable.  I was thinking more along the line of
just adding another ptrace_stop() call after the one for group stop
but the flag based approach solves the notification to running tracees
automatically, so it sounds good.

> If yes, then everything works "automagically" after that. The tracee
> will call get_signal_to_deliver() if it is running, and check
> SIGNAL_CLD_MASK.
> 
> What do you think?

I think it's good but I don't think it necessarily changes a lot about
this patch.  We'll be calling signal_wake_up() for that trap from
prepare_signal() after all, right?

Thanks.

-- 
tejun
