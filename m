Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab0LCTao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 14:30:44 -0500
Received: from sous-sol.org ([216.99.217.87]:50744 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752460Ab0LCTan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 14:30:43 -0500
Date: Fri, 3 Dec 2010 11:30:08 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Rik van Riel <riel@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
Message-ID: <20101203193008.GK10050@sequoia.sous-sol.org>
References: <20101202144129.4357fe00@annuminas.surriel.com>
 <20101202144423.3ad1908d@annuminas.surriel.com>
 <20101203005008.GU10050@sequoia.sous-sol.org>
 <4CF9368C.8030309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF9368C.8030309@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel (riel@redhat.com) wrote:
> On 12/02/2010 07:50 PM, Chris Wright wrote:
> >>+/*
> >>+ * Yield the CPU, giving the remainder of our time slice to task p.
> >>+ * Typically used to hand CPU time to another thread inside the same
> >>+ * process, eg. when p holds a resource other threads are waiting for.
> >>+ * Giving priority to p may help get that resource released sooner.
> >>+ */
> >>+void yield_to(struct task_struct *p)
> >>+{
> >>+	unsigned long flags;
> >>+	struct sched_entity *se =&p->se;
> >>+	struct rq *rq;
> >>+	struct cfs_rq *cfs_rq;
> >>+	u64 remain = slice_remain(current);
> >>+
> >>+	rq = task_rq_lock(p,&flags);
> >>+	if (task_running(rq, p) || task_has_rt_policy(p))
> >>+		goto out;
> >>+	cfs_rq = cfs_rq_of(se);
> >>+	se->vruntime -= remain;
> >>+	if (se->vruntime<  cfs_rq->min_vruntime)
> >>+		se->vruntime = cfs_rq->min_vruntime;
> >
> >Should these details all be in sched_fair?  Seems like the wrong layer
> >here.  And would that condition go the other way?  If new vruntime is
> >smaller than min, then it becomes new cfs_rq->min_vruntime?
> 
> That would be nice.  Unfortunately, EXPORT_SYMBOL() does
> not seem to work right from sched_fair.c, which is included
> from sched.c instead of being built from the makefile!

add a ->yield_to() to properly isolate (only relevant then in
sched_fair)?
