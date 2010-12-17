Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab0LQHPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 02:15:50 -0500
Received: from cantor.suse.de ([195.135.220.2]:47314 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab0LQHPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 02:15:49 -0500
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <mgalbraith@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <1292569018.7772.75.camel@marge.simson.net>
References: <20101213224434.7495edb2@annuminas.surriel.com>
	 <20101213224657.7e141746@annuminas.surriel.com>
	 <1292306896.7448.157.camel@marge.simson.net>  <4D0A6D34.6070806@redhat.com>
	 <1292569018.7772.75.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 17 Dec 2010 08:15:43 +0100
Message-Id: <1292570143.7772.84.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 07:57 +0100, Mike Galbraith wrote:
> On Thu, 2010-12-16 at 14:49 -0500, Rik van Riel wrote:

> > >> +static void yield_to_fair(struct rq *rq, struct task_struct *p)
> > >> +{
> > >> +	struct sched_entity *se =&p->se;
> > >> +	struct cfs_rq *cfs_rq = cfs_rq_of(se);
> > >> +	u64 remain = slice_remain(current);
> > >> +
> > >> +	dequeue_task(rq, p, 0);
> > >> +	se->vruntime -= remain;
> > >> +	if (se->vruntime<  cfs_rq->min_vruntime)
> > >> +		se->vruntime = cfs_rq->min_vruntime;
> > >
> > > This has an excellent chance of moving the recipient rightward.. and the
> > > yielding task didn't yield anything.  This may achieve the desired
> > > result or may just create a nasty latency spike... but it makes no
> > > arithmetic sense.
> > 
> > Good point, the current task calls yield() in the function
> > that calls yield_to_fair, but I seem to have lost the code
> > that penalizes the current task's runtime...
> > 
> > I'll reinstate that.
> 
> See comment in parentheses above :)

BTW, with this vruntime donation thingy, what prevents a task from
forking off accomplices who do nothing but wait for a wakeup and
yield_to(exploit)?

Even swapping vruntimes in the same cfs_rq is dangerous as hell, because
one party is going backward.

	-Mike

