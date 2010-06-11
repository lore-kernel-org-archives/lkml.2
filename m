Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab0FKQ7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 12:59:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab0FKQ7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 12:59:33 -0400
Date: Fri, 11 Jun 2010 18:57:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] thread_group_cputime: simplify, document the
	"alive" check
Message-ID: <20100611165750.GA7019@redhat.com>
References: <20100610230956.GA25921@redhat.com> <20100611143525.GA2586@dhcp-lab-161.englab.brq.redhat.com> <20100611151533.GA2867@redhat.com> <20100611164050.GA19325@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100611164050.GA19325@dhcp-lab-161.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11, Stanislaw Gruszka wrote:
>
> On Fri, Jun 11, 2010 at 05:15:33PM +0200, Oleg Nesterov wrote:
> > On 06/11, Stanislaw Gruszka wrote:
> > >
> > > On Fri, Jun 11, 2010 at 01:09:56AM +0200, Oleg Nesterov wrote:
> > > > thread_group_cputime() looks as if it is rcu-safe, but in fact this
> > > > was wrong until ea6d290c which pins task->signal to task_struct.
> > > > It checks ->sighand != NULL under rcu, but this can't help if ->signal
> > > > can go away. Fortunately the caller either holds ->siglock, or it is
> > > > fastpath_timer_check() which uses current and checks exit_state == 0.
> > >
> > > Hmm, I thought we avoided calling thread_group_cputime() from
> > > fastpatch_timer_check(), but seems it is still possible when we
> > > call run_posix_cpu_timers() on two different cpus simultaneously ...
> >
> > No, we can't. thread_group_cputimer() does test-and-set ->running
> > under cputimer->lock.
> >
> > But when I sent these patches, I realized we have another race here
> > (with or without these patches). I am already doing the fix.
>
> Don't know what you catch, I was thinking about:
>
> cpu0							cpu1
>
> fastpath_timer_check():
>
> if (sig->cputimer.running) {
>   struct task_cputime group_sample;
> 							stop_process_timers():	
>         						
> 							spin_lock_irqsave(&cputimer->lock, flags);
>         						cputimer->running = 0;
>         						spin_unlock_irqrestore(&cputimer->lock, flags);
> 				
>   thread_group_cputimer(tsk, &group_sample);

Yes, I was thinking about this race too. Please wait a bit, I'll send
the patch.

In short: it is safe to call thread_group_cputime() lockless, but
thread_group_cputimer() must not be called without siglock/tasklist
(oh, and imho we should rename them somehow, their names are almost
 identical). And in fact fastpath_timer_check() does not need
thread_group_cputimer().

> > > > - Since ea6d290c commit tsk->signal is stable, we can read it first
> > > >   and avoid the initialization from INIT_CPUTIME.
> > > >
> > > > - Even if tsk->signal is always valid, we still have to check it
> > > >   is safe to use next_thread() under rcu_read_lock(). Currently
> > > >   the code checks ->sighand != NULL, change it to use pid_alive()
> > > >   which is commonly used to ensure the task wasn't unhashed before
> > > >   we take rcu_read_lock().
> > >
> > > I'm not sure how important are values of almost dead task, but
> > > perhaps would be better to return times form all threads
> > > using as base sig->curr_target in loop.
> >
> > Could you clarify?
>
> Avoid pid_alive check and loop starting from sig->curr_target:
>
>        t = tsk = sig->curr_target;
>        do {
>                 times->utime = cputime_add(times->utime, t->utime);
>                 times->stime = cputime_add(times->stime, t->stime);
>                 times->sum_exec_runtime += t->se.sum_exec_runtime;
>        } while_each_thread(tsk, t);
>
> I don't know what are rules regarding accessing sig->curr_target, but
> if this is done under sighand->siglock we should be safe. Question
> if if we always have lock taken, we tried to assure that in the past,
> but if we really do?

Ah, you are talking about thread_group_cputime().

Without ->siglock this is not safe. We can change __exit_signal() to
nullify ->curr_target in the group_dead case, then the code above
could check sig->curr_target != NULL.

But this is too subtle imho, and not needed. Instead we should move
group_leader into ->signal (and kill signal->leader_pid). I am going
to do more cleanups in this area "later".


Anyway. This all has nothing to do with this patch. The 4/5 change
in thread_group_cputime() is cleanup, and it ccan help to make
/proc/pid/stat /proc/pid/status lockless.

With or without 5/5 thread_group_cputime() can be called lockless
and race with exit/fork. This is fine by itself, but this is wrong
because the caller sets ->running.

Oleg.

