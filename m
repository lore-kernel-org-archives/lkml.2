Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab0LCFyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 00:54:22 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:48286 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751788Ab0LCFyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 00:54:21 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+KjK1ipgGKiH4WAblKuNf7ako0RbTCDreJlWmgni
	awR2ao63VL9OuW
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <efault@gmx.de>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
In-Reply-To: <20101202144423.3ad1908d@annuminas.surriel.com>
References: <20101202144129.4357fe00@annuminas.surriel.com>
	 <20101202144423.3ad1908d@annuminas.surriel.com>
Content-Type: text/plain
Date: Fri, 03 Dec 2010 06:54:16 +0100
Message-Id: <1291355656.7633.124.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 14:44 -0500, Rik van Riel wrote:

> +#ifdef CONFIG_SCHED_HRTICK
> +/*
> + * Yield the CPU, giving the remainder of our time slice to task p.
> + * Typically used to hand CPU time to another thread inside the same
> + * process, eg. when p holds a resource other threads are waiting for.
> + * Giving priority to p may help get that resource released sooner.
> + */
> +void yield_to(struct task_struct *p)
> +{
> +	unsigned long flags;
> +	struct sched_entity *se = &p->se;
> +	struct rq *rq;
> +	struct cfs_rq *cfs_rq;
> +	u64 remain = slice_remain(current);

That "slice remaining" only shows the distance to last preempt, however
brief.  It shows nothing wrt tree position, the yielding task may well
already be right of the task it wants to yield to, having been a buddy.
 
> cfs_rq = cfs_rq_of(se);
> +	se->vruntime -= remain;
> +	if (se->vruntime < cfs_rq->min_vruntime)
> +		se->vruntime = cfs_rq->min_vruntime;

(This is usually done using max_vruntime())

If the recipient was already left of the fair stick (min_vruntime),
clipping advances it's vruntime, vaporizing entitlement from both donor
and recipient.

What if a task tries to yield to another not on the same cpu, and/or in
the same task group?  This would munge min_vruntime of other queues.  I
think you'd have to restrict this to same cpu, same group.  If tasks can
donate cross cfs_rq, (say) pinned task A cpu A running solo could donate
vruntime to selected tasks pinned to cpu B, for as long as minuscule
preemptions can resupply ammo.  Would suck to not be the favored child.

Maybe you could exchange vruntimes cooperatively (iff same cfs_rq)
between threads, but I don't think donations with clipping works.

	-Mike

