Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101Ab0LNKYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:24:16 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:57739 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab0LNKYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:24:15 -0500
Date: Tue, 14 Dec 2010 15:54:09 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
Message-ID: <20101214102409.GA3665@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20101213224434.7495edb2@annuminas.surriel.com>
 <20101213224657.7e141746@annuminas.surriel.com>
 <1292306896.7448.157.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292306896.7448.157.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 07:08:16AM +0100, Mike Galbraith wrote:
> > +/*
> > + * Yield the CPU, giving the remainder of our time slice to task p.
> > + * Typically used to hand CPU time to another thread inside the same
> > + * process, eg. when p holds a resource other threads are waiting for.
> > + * Giving priority to p may help get that resource released sooner.
> > + */
> > +void yield_to(struct task_struct *p)
> > +{
> > +	unsigned long flags;
> > +	struct rq *rq, *p_rq;
> > +
> > +	local_irq_save(flags);
> > +	rq = this_rq();
> > +again:
> > +	p_rq = task_rq(p);
> > +	double_rq_lock(rq, p_rq);
> > +	if (p_rq != task_rq(p)) {
> > +		double_rq_unlock(rq, p_rq);
> > +		goto again;
> > +	}
> > +
> > +	/* We can't yield to a process that doesn't want to run. */
> > +	if (!p->se.on_rq)
> > +		goto out;
> > +
> > +	/*
> > +	 * We can only yield to a runnable task, in the same schedule class
> > +	 * as the current task, if the schedule class implements yield_to_task.
> > +	 */
> > +	if (!task_running(rq, p) && current->sched_class == p->sched_class &&
> > +			current->sched_class->yield_to)
> > +		current->sched_class->yield_to(rq, p);
> > +
> > +out:
> > +	double_rq_unlock(rq, p_rq);
> > +	local_irq_restore(flags);
> > +	yield();
> > +}
> > +EXPORT_SYMBOL_GPL(yield_to);
> 
> That part looks ok, except for the yield cross cpu bit.  Trying to yield
> a resource you don't have doesn't make much sense to me.

So another (crazy) idea is to move the "yieldee" task on another cpu over to 
yielding task's cpu, let it run till the end of yielding tasks slice and then
let it go back to the original cpu at the same vruntime position!

- vatsa
