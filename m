Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab1ACLRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:17:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:41319 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1ACLRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:17:00 -0500
Subject: Re: [RFC][PATCH 08/17] sched: Drop the rq argument to
 sched_class::select_task_rq()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101229143136.GC2728@zhy>
References: <20101224122338.172750730@chello.nl>
	 <20101224123742.887559254@chello.nl>  <20101229143136.GC2728@zhy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 Jan 2011 12:16:49 +0100
Message-ID: <1294053409.2016.59.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-29 at 22:31 +0800, Yong Zhang wrote:
> On Fri, Dec 24, 2010 at 01:23:46PM +0100, Peter Zijlstra wrote:
> > In preparation of calling select_task_rq() without rq->lock held, drop
> > the dependency on the rq argument.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> > @@ -3416,27 +3409,22 @@ void sched_exec(void)
> >  {
> >  	struct task_struct *p = current;
> >  	unsigned long flags;
> > -	struct rq *rq;
> >  	int dest_cpu;
> >  
> > -	rq = task_rq_lock(p, &flags);
> > -	dest_cpu = p->sched_class->select_task_rq(rq, p, SD_BALANCE_EXEC, 0);
> > +	raw_spin_lock_irqsave(&p->pi_lock, flags);
> 
> Seems this should go to patch 07/17 ;)

Ah, the reason its here is that this patch removes the rq argument and
thus we no longer need rq->lock. So this part relies on the property
introduced by patch 7.

> > +	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
> >  	if (dest_cpu == smp_processor_id())
> >  		goto unlock;
> >  
> > -	/*
> > -	 * select_task_rq() can race against ->cpus_allowed
> > -	 */
> > -	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
> > -	    likely(cpu_active(dest_cpu)) && migrate_task(p, rq)) {
> > +	if (likely(cpu_active(dest_cpu)) && need_migrate_task(p)) {
> 
> If we drop rq_lock, need_migrate_task() maybe return true but
> p is already running on other cpu. Thus we do a wrong migration
> call.

Yeah, too bad.. ;-) exec load balancing is more an optimistic thing
anyway, if it got rebalanced under out feet we don't care.
