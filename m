Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab0KBSkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 14:40:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab0KBSkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 14:40:05 -0400
Date: Tue, 2 Nov 2010 19:33:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] posix-cpu-timers: rcu_read_lock/unlock protect
	find_task_by_vpid call
Message-ID: <20101102183308.GA17720@redhat.com>
References: <20101102135821.GA5964@swordfish.minsk.epam.com> <alpine.LFD.2.00.1011021630150.9357@localhost6.localdomain6> <20101102160223.GC5964@swordfish.minsk.epam.com> <alpine.LFD.2.00.1011021704110.9357@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011021704110.9357@localhost6.localdomain6>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2 Nov 2010, Sergey Senozhatsky wrote:
>
> > On (11/02/10 16:31), Thomas Gleixner wrote:
> > > On Tue, 2 Nov 2010, Sergey Senozhatsky wrote:
> > >
> > > > Commit 4221a9918e38b7494cee341dda7b7b4bb8c04bde "Add RCU check for
> > > > find_task_by_vpid()" introduced rcu_lockdep_assert to find_task_by_pid_ns.
> > > > Add rcu_read_lock/rcu_read_unlock to call find_task_by_vpid.
> > > >
> > > > Tetsuo Handa wrote:
> > > >
> > > > Quoting from one of posts in that thead
> > > > http://kerneltrap.org/mailarchive/linux-kernel/2010/2/8/4536388
> > > >
> > > > | Usually tasklist gives enough protection, but if copy_process() fails
> > > > | it calls free_pid() lockless and does call_rcu(delayed_put_pid().
> > > > | This means, without rcu lock find_pid_ns() can't scan the hash table
> > > > | safely.
> > >
> > > We can remove the tasklist_lock while at it. rcu_read_lock is enough.
> > >

Yes, I believe posix-cpu-timers.c shouldn't use tasklist at all,
but it is not trivial to change this code.

Minor nit,

> > @@ -390,7 +390,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
> >
> >  	INIT_LIST_HEAD(&new_timer->it.cpu.entry);
> >
> > -	read_lock(&tasklist_lock);
> > +	rcu_read_lock();
> >  	if (CPUCLOCK_PERTHREAD(new_timer->it_clock)) {
> >  		if (pid == 0) {
> >  			p = current;
> > @@ -414,7 +414,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
> >  	} else {
> >  		ret = -EINVAL;
> >  	}
> > -	read_unlock(&tasklist_lock);
> > +	rcu_read_unlock();

I think this change is fine, but please note that thread_group_leader()
check is not relaible without tasklist. If we race with de_thread()
find_task_by_vpid() can find the new leader before it updates its
->group_leader. IOW, posix_cpu_timer_create() can fail when it shouldn't.

Not that I think this really matters, posix_cpu_timer_create() has
other problems with de_thread(). But perhaps it makes sense to
change posix_cpu_timer_create() to use has_group_leader_pid() instead,
just to make this code not look racy and avoid adding new problems.

The real fix, I think, should change cpu_timer_list to use
struct pid* instead of task_struct.

Oleg.

