Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab0LCNq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 08:46:29 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56283 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059Ab0LCNq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 08:46:28 -0500
Date: Fri, 3 Dec 2010 19:16:18 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
Message-ID: <20101203134618.GG27994@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20101202144129.4357fe00@annuminas.surriel.com>
 <20101202144423.3ad1908d@annuminas.surriel.com>
 <1291355656.7633.124.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291355656.7633.124.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 06:54:16AM +0100, Mike Galbraith wrote:
> > +void yield_to(struct task_struct *p)
> > +{
> > +	unsigned long flags;
> > +	struct sched_entity *se = &p->se;
> > +	struct rq *rq;
> > +	struct cfs_rq *cfs_rq;
> > +	u64 remain = slice_remain(current);
> 
> That "slice remaining" only shows the distance to last preempt, however
> brief.  It shows nothing wrt tree position, the yielding task may well
> already be right of the task it wants to yield to, having been a buddy.

Good point.

> > cfs_rq = cfs_rq_of(se);
> > +	se->vruntime -= remain;
> > +	if (se->vruntime < cfs_rq->min_vruntime)
> > +		se->vruntime = cfs_rq->min_vruntime;
> 
> (This is usually done using max_vruntime())
> 
> If the recipient was already left of the fair stick (min_vruntime),
> clipping advances it's vruntime, vaporizing entitlement from both donor
> and recipient.
> 
> What if a task tries to yield to another not on the same cpu, and/or in
> the same task group?

In this case, target of yield_to is a vcpu belonging to the same VM and hence is
expected to be in same task group, but I agree its good to put a check.

>  This would munge min_vruntime of other queues.  I
> think you'd have to restrict this to same cpu, same group.  If tasks can
> donate cross cfs_rq, (say) pinned task A cpu A running solo could donate
> vruntime to selected tasks pinned to cpu B, for as long as minuscule
> preemptions can resupply ammo.  Would suck to not be the favored child.

IOW starving "non-favored" childs?

> Maybe you could exchange vruntimes cooperatively (iff same cfs_rq)
> between threads, but I don't think donations with clipping works.

Can't that lead to starvation again (as I pointed in a mail to Peterz):

p0 -> A0 B0 A1

A0/A1 enter a yield_to(other) deadlock, which means we keep swapping their
vruntimes, starving B0?

- vatsa
