Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab1ACLUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:20:08 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52375 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1ACLUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:20:07 -0500
Subject: Re: [RFC][PATCH 14/17] sched: Remove rq argument to ttwu_stat()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
In-Reply-To: <20101229144044.GD2728@zhy>
References: <20101224122338.172750730@chello.nl>
	 <20101224123743.206056628@chello.nl>  <20101229144044.GD2728@zhy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 Jan 2011 12:20:22 +0100
Message-ID: <1294053622.2016.63.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-29 at 22:40 +0800, Yong Zhang wrote:
> On Fri, Dec 24, 2010 at 01:23:52PM +0100, Peter Zijlstra wrote:
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  kernel/sched.c |    8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > Index: linux-2.6/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -2367,10 +2367,11 @@ static void update_avg(u64 *avg, u64 sam
> >  #endif
> >  
> >  static void
> > -ttwu_stat(struct rq *rq, struct task_struct *p, int cpu, int wake_flags)
> > +ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
> >  {
> >  #ifdef CONFIG_SCHEDSTATS
> >  	int this_cpu = smp_processor_id();
> > +	struct rq *rq = this_rq();
> 
> 			task_rq(p)?

No we cannot change stats on task_rq() since we don't hold any locks
there, but since we have IRQs disabled we can change stats on the local
rq.

It changes the accounting slightly (instead of accounting the wakeup on
the task's rq we account it on the waking cpu's rq) but that shouldn't
matter.

> >  
> >  	schedstat_inc(rq, ttwu_count);
> >  	schedstat_inc(p, se.statistics.nr_wakeups);
> > @@ -2491,9 +2492,10 @@ try_to_wake_up(struct task_struct *p, un
> >  	activate_task(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
> >  out_running:
> >  	ttwu_post_activation(p, rq, wake_flags);
> > -	ttwu_stat(rq, p, cpu, wake_flags);
> >  	success = 1;
> >  	__task_rq_unlock(rq);
> > +
> > +	ttwu_stat(p, cpu, wake_flags);
> 
> Typo? You just put it out of rq_lock.

That's the purpose of this patch, we need to be able to do ttwu_stat()
without holding rq->lock.

I should have written a changelog but it was either finish all fancy
changelogs on an rfc series and post after the holidays or post
before ;-)
