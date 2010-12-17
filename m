Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab0LQG5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 01:57:09 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:40510 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751039Ab0LQG5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 01:57:07 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX189dVg26k89fZbnnVbsCzIgt7uIeXJ8AELFu20aUQ
	t2q/4lj5sYpg4e
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <efault@gmx.de>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4D0A6D34.6070806@redhat.com>
References: <20101213224434.7495edb2@annuminas.surriel.com>
	 <20101213224657.7e141746@annuminas.surriel.com>
	 <1292306896.7448.157.camel@marge.simson.net>  <4D0A6D34.6070806@redhat.com>
Content-Type: text/plain
Date: Fri, 17 Dec 2010 07:56:58 +0100
Message-Id: <1292569018.7772.75.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 14:49 -0500, Rik van Riel wrote:
> On 12/14/2010 01:08 AM, Mike Galbraith wrote:

> >> +EXPORT_SYMBOL_GPL(yield_to);
> >
> > That part looks ok, except for the yield cross cpu bit.  Trying to yield
> > a resource you don't have doesn't make much sense to me.
> 
> The current task just donated the rest of its timeslice.

It doesn't have a tangible slice to donate.

> Surely that makes it a reasonable idea to call yield, and
> get one of the other tasks on the current CPU running for
> a bit?

There's nothing wrong with trying to give up the cpu.  It's the concept
of a cross cpu yield_to() that I find mighty strange.

> I'm open to suggestions on what to do instead.

If you want to yield_to(task), task needs to move to the resource you're
sitting on.  That's the only thing that makes any sense to me.  Pull the
task, maybe do some vruntime twiddling (likely very bad idea) to improve
success chances, and schedule.

Dunno how effective that would be at solving real problems though.  You
might get him to run, might not, you'll be fighting load balancing, and
maybe just inflicting cache misses on everyone as tasks bounce around.

> >> +static void yield_to_fair(struct rq *rq, struct task_struct *p)
> >> +{
> >> +	struct sched_entity *se =&p->se;
> >> +	struct cfs_rq *cfs_rq = cfs_rq_of(se);
> >> +	u64 remain = slice_remain(current);
> >> +
> >> +	dequeue_task(rq, p, 0);
> >> +	se->vruntime -= remain;
> >> +	if (se->vruntime<  cfs_rq->min_vruntime)
> >> +		se->vruntime = cfs_rq->min_vruntime;
> >
> > This has an excellent chance of moving the recipient rightward.. and the
> > yielding task didn't yield anything.  This may achieve the desired
> > result or may just create a nasty latency spike... but it makes no
> > arithmetic sense.
> 
> Good point, the current task calls yield() in the function
> that calls yield_to_fair, but I seem to have lost the code
> that penalizes the current task's runtime...
> 
> I'll reinstate that.

See comment in parentheses above :)

	-Mike

