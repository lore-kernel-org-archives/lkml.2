Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab1ACP5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:57:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab1ACP5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 10:57:02 -0500
Date: Mon, 3 Jan 2011 16:49:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 08/17] sched: Drop the rq argument to
	sched_class::select_task_rq()
Message-ID: <20110103154918.GB7632@redhat.com>
References: <20101224122338.172750730@chello.nl> <20101224123742.887559254@chello.nl> <20101229143136.GC2728@zhy> <1294053409.2016.59.camel@laptop> <20110103145902.GA7632@redhat.com> <1294068061.2016.84.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294068061.2016.84.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03, Peter Zijlstra wrote:
>
> On Mon, 2011-01-03 at 15:59 +0100, Oleg Nesterov wrote:
> > On 01/03, Peter Zijlstra wrote:
> > >
> > > On Wed, 2010-12-29 at 22:31 +0800, Yong Zhang wrote:
> > > > > -	/*
> > > > > -	 * select_task_rq() can race against ->cpus_allowed
> > > > > -	 */
> > > > > -	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
> > > > > -	    likely(cpu_active(dest_cpu)) && migrate_task(p, rq)) {
> > > > > +	if (likely(cpu_active(dest_cpu)) && need_migrate_task(p)) {
> > > >
> > > > If we drop rq_lock, need_migrate_task() maybe return true but
> > > > p is already running on other cpu. Thus we do a wrong migration
> > > > call.
> > >
> > > Yeah, too bad.. ;-) exec load balancing is more an optimistic thing
> > > anyway, if it got rebalanced under out feet we don't care.
> >
> > I don't understand this need_migrate_task() at all (with or without
> > the patch). This task is current/running, it should always return T.
>
> This is true for the sched_exec() case, yes.
>
> > I guess, migrate_task() was needed before to initialize migration_req.
>
> But afaict you can call set_cpus_allowed_ptr() on !self.

Ah, sorry for the confusion, I only meant sched_exec() case.
set_cpus_allowed_ptr() does need need_migrate_task(), of course.


As for set_cpus_allowed_ptr()->need_migrate_task() path, I have another
question,

	static bool need_migrate_task(struct task_struct *p)
	{
		/*
		 * If the task is not on a runqueue (and not running), then
		 * the next wake-up will properly place the task.
		 */
		smp_rmb(); /* finish_lock_switch() */
		return p->on_rq || p->on_cpu;
	}

I don't understand this smp_rmb(). Yes, finish_lock_switch() does
wmb() before it clears ->on_cpu, but how these 2 barriers can pair?

In fact, I am completely confused. I do not understand why do we
check task_running() at all. If we see on_rq == 0 && on_cpu == 1,
then this task is going to clear its on_cpu soon, once it finishes
context_switch().

Probably, this check was needed before, try_to_wake_up() could
activate the task_running() task without migrating. But, at first
glance, this is no longer possible after this series?

Oleg.

