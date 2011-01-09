Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1AIWFK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:05:10 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58081 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab1AIWFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:05:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Qs2xxNk8jFy4K3GBB4Zzr8jSx11NAo2Q1bKlFqc17X8vYXlTKnhqFcCd4d8d1tChLO
         G56c5kC7UbyDkilaeXu3aV5hczp72+5tkobtjzfcU7pam3g2Uv2z0QdfMlLA7nCt2B37
         +rNWKVDagifT6F8bNTa1OPnOjC9V8uqxNpSrs=
Date: Sun, 9 Jan 2011 17:05:04 -0500
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 7/7] ptrace: clean transitions between TASK_STOPPED and
 TRACED
Message-ID: <20110109220504.GA25707@mtj.dyndns.org>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
 <1293199257-11255-8-git-send-email-tj@kernel.org>
 <20110105163542.GA19474@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110105163542.GA19474@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.  Sorry about the delay.  I've been and still am
travelling and won't be very responsive until mid next week.

On Wed, Jan 05, 2011 at 05:35:42PM +0100, Oleg Nesterov wrote:
> To me, the whole series is fine.

Awesome.

> As for the user-visible changes, I believe they are carefully documented,
> hopefully Roland and Jan can take a look.

I think it would be a good idea to document the defined and probably
more importantly undefined aspects of the ptrace behavior somewhere
along with rational and implementation peculiarities.  Probably we
should create a file under Documentation and also make sure the ptrace
man page is kept synchronized with and point to it.

> This patch looks good too, a couple of minor nits below.
> 
> On 12/24, Tejun Heo wrote:
> >
> > + * task_clear_group_stop_trapping - clear group stop trapping bit
> > + * @task: target task
> > + *
> > + * If GROUP_STOP_TRAPPING is set, a ptracer is waiting for us.  Clear it
> > + * and wake up the ptracer.  Note that we don't need any further locking.
> > + * @task->siglock guarantees that @task->parent points to the ptracer.
> > + *
> > + * CONTEXT:
> > + * Must be called with @task->sighand->siglock held.
> > + */
> > +static void task_clear_group_stop_trapping(struct task_struct *task)
> > +{
> > +	if (unlikely(task->group_stop & GROUP_STOP_TRAPPING)) {
> > +		task->group_stop &= ~GROUP_STOP_TRAPPING;
> > +		__wake_up_sync(&task->parent->signal->wait_chldexit,
> > +			       TASK_UNINTERRUPTIBLE, 1);
> 
> OK... we are doing __wake_up_sync_key(key => NULL), this looks unfriendly
> to child_wait_callback(). But TASK_UNINTERRUPTIBLE means we can't abuse
> the tracer's subthreads doing do_wait().

Yeah, given the complexities around wait_chldexit, I'm not entirely
sure whether multiplexing it actually is a good idea.  It definitely
fits the purpose but I still feel dirty adding more subtleties to it.

> >  void task_clear_group_stop(struct task_struct *task)
> >  {
> >  	task->group_stop &= ~(GROUP_STOP_PENDING | GROUP_STOP_CONSUME);
> > +	task_clear_group_stop_trapping(task);
> >  }
> 
> Not a comment, but the question. I am not sure task_clear_group_stop()
> needs task_clear_group_stop_trapping(), please see below...

Hmm... I wanted to make sure that task_clear_group_stop() clears all
group stop related status.  As the function may be called from kill
path too, I wanted to make sure it is guaranteed to be cleared
together.  That was the rationale but maybe there's a better place for
it.

> > @@ -1694,6 +1716,14 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
> >  	}
> >  
> >  	/*
> > +	 * We're committing to trapping.  Clearing GROUP_STOP_TRAPPING and
> > +	 * transition to TASK_TRACED should be atomic with respect to
> > +	 * siglock.  Do it after the arch hook as siglock is released and
> > +	 * regrabbed across it.
> > +	 */
> > +	task_clear_group_stop_trapping(current);
> 
> This wakes up the tracer. It can return from sys_ptrace(), call do_wait(),
> and take tasklist_lock before us.
>
> Of course, this is only theoretical problem, but perhaps it makes sense
> to do this after __set_current_state(TASK_TRACED), otherwise
> task_stopped_code() can fail.

Right.  That's a slim possibility but definitely possible.

> > @@ -1839,13 +1875,25 @@ static int do_signal_stop(int signr)
> >  		schedule();
> >
> >  		spin_lock_irq(&current->sighand->siglock);
> > -	} else
> > -		ptrace_stop(current->exit_code, CLD_STOPPED, 0, NULL);
> > +	} else {
> > +		ptrace_stop(current->group_stop & GROUP_STOP_SIGMASK,
> > +			    CLD_STOPPED, 0, NULL);
> > +		current->exit_code = 0;
> > +	}
> > +
> > +	/*
> > +	 * GROUP_STOP_PENDING could be set if another group stop has
> > +	 * started since being woken up or ptrace wants us to transit
> > +	 * between TASK_STOPPED and TRACED.  Retry group stop.
> > +	 */
> > +	if (current->group_stop & GROUP_STOP_PENDING) {
> > +		WARN_ON_ONCE(!(current->group_stop & GROUP_STOP_SIGMASK));
> > +		goto retry;
> > +	}
> >
> >  	spin_unlock_irq(&current->sighand->siglock);
> 
> Can't we add task_clear_group_stop_trapping() right before we drop
> ->siglock ? This way we can remove it from task_clear_group_stop(),
> afaics. Once again, this is up to you. Looks more clean to me, but
> this is of course subjective.
> 
> If GROUP_STOP_PENDING is not set, but GROUP_STOP_TRAPPING is set,
> then this task was SIGKILL'ed or SIGCONT'ed, we can notify the
> tracer.
> 
> Otherwise (ignoring ptrace_stop), there is no reasons to check
> GROUP_STOP_TRAPPING. It was set under ->siglock when the tracee
> was in TASK_STOPPED state few lines above.

Hmm... I don't really mind one way or the other.  I like the idea that
clear_group_stop() clears everything but at the same time the
suggested placing makes it more explicit which is a plus.  I'll think
a bit more about it but if it doesnt break anything let's move it.

Thanks.

-- 
tejun
