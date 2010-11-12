Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab0KLSUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:20:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab0KLSUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:20:00 -0500
Date: Fri, 12 Nov 2010 19:12:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101112181240.GB8659@redhat.com>
References: <1287648715.9021.20.camel@marge.simson.net> <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins> <20101021162924.GA3225@redhat.com> <1288076838.11930.1.camel@marge.simson.net> <1288078144.7478.9.camel@marge.simson.net> <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com> <1289489200.11397.21.camel@maggy.simson.net> <20101111202703.GA16282@redhat.com> <1289514000.21413.204.camel@maggy.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289514000.21413.204.camel@maggy.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Mike Galbraith wrote:
>
> On Thu, 2010-11-11 at 21:27 +0100, Oleg Nesterov wrote:
>
> > But the real problem is that copy_process() can fail after that,
> > and in this case we have the unbalanced kref_get().
>
> Memory leak, will fix.
>
> > > +++ linux-2.6.36.git/kernel/exit.c
> > > @@ -174,6 +174,7 @@ repeat:
> > >  	write_lock_irq(&tasklist_lock);
> > >  	tracehook_finish_release_task(p);
> > >  	__exit_signal(p);
> > > +	sched_autogroup_exit(p);
> >
> > This doesn't look right. Note that "p" can run/sleep after that
> > (or in parallel), set_task_rq() can use the freed ->autogroup.
>
> So avoiding refcounting rcu released task_group backfired.  Crud.

Just in case, the lock order may be wrong. sched_autogroup_exit()
takes task_group_lock under write_lock(tasklist), while
sched_autogroup_handler() takes them in reverse order.


I am not sure, but perhaps this can be simpler?
wake_up_new_task() does autogroup_fork(), and do_exit() does
sched_autogroup_exit() before the last schedule. Possible?


> > Btw, I can't apply this patch...
>
> It depends on the patch below from Peter, or manual fixup.

Thanks. It also applies cleanly to 2.6.36.


Very basic question. Currently sched_autogroup_create_attach()
has the only caller, __proc_set_tty(). It is a bit strange that
signal->tty change is process-wide, but sched_autogroup_create_attach()
move the single thread, the caller. What about other threads in
this thread group? The same for proc_clear_tty().


> +void sched_autogroup_create_attach(struct task_struct *p)
> +{
> +       autogroup_move_task(p, autogroup_create());
> +
> +       /*
> +        * Correct freshly allocated group's refcount.
> + 	   * Move takes a reference on destination, but
> +        * create already initialized refcount to 1.
> +        */
> + 	if (p->autogroup != &autogroup_default)
> +               autogroup_kref_put(p->autogroup);
> +}

OK, but I don't understand "p->autogroup != &autogroup_default"
check. This is true if autogroup_create() succeeds. Otherwise
autogroup_create() does autogroup_kref_get(autogroup_default),
doesn't this mean we need unconditional _put ?

And can't resist, minor cosmetic nit,

>  static inline struct task_group *task_group(struct task_struct *p)
>  {
> +       struct task_group *tg;
>         struct cgroup_subsys_state *css;
>
>         css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
>                         lockdep_is_held(&task_rq(p)->lock));
> -       return container_of(css, struct task_group, css);
> +       tg = container_of(css, struct task_group, css);
> +
> +       autogroup_task_group(p, &tg);

Fell free to ignore, but imho

	return autogroup_task_group(p, tg);

looks a bit better. Why autogroup_task_group() returns its
result via pointer?

Oleg.

