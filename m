Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab1ADP0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:26:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab1ADP0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:26:13 -0500
Date: Tue, 4 Jan 2011 16:18:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 16/17] sched: Move the second half of ttwu() to
	the remote cpu
Message-ID: <20110104151826.GA6800@redhat.com>
References: <20101224122338.172750730@chello.nl> <20101224123743.303699501@chello.nl> <20110104142805.GA4347@redhat.com> <1294152441.2016.148.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294152441.2016.148.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04, Peter Zijlstra wrote:
>
> On Tue, 2011-01-04 at 15:28 +0100, Oleg Nesterov wrote:
> > On 12/24, Peter Zijlstra wrote:
> > >
> > > +static void
> > > +ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags)
> > > +{
> > > +#ifdef CONFIG_SMP
> > > +	if (task_cpu(p) != cpu_of(rq))
> > > +		set_task_cpu(p, cpu_of(rq));
> > > +#endif
> >
> > This looks a bit suspicious.
> >
> > If this is called by sched_ttwu_pending() we are holding rq->lock,
> > not task_rq_lock(). It seems, we can race with, say, migration
> > thread running on task_cpu().
>
> I don't think so, nobody should be migrating a TASK_WAKING task.

I am not sure...

Suppose that p was TASK_INTERRUPTIBLE and p->on_rq == 1 before, when
set_cpus_allowed_ptr() was called. To simplify, suppose that
the caller is preempted right after it drops p->pi_lock and before
it does stop_one_cpu(migration_cpu_stop).

After that p can complete chedule() and deactivate itself.

Now, try_to_wake_up() can set TASK_WAKING, choose another CPU,
and do ttwu_queue_remote().

Finally, the caller of set_cpus_allowed_ptr() resumes and
schedules migration_cpu_stop.



It is very possible I missed something, but what is the new
locking rules for set_task_cpu() anyway? I mean, which rq->lock
it needs?

Oleg.

