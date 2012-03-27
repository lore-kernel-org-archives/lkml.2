Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab2C0PXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:23:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab2C0PXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:23:49 -0400
Date: Tue, 27 Mar 2012 17:22:09 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 07/39] autonuma: introduce kthread_bind_node()
Message-ID: <20120327152209.GL5906@redhat.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
 <1332783986-24195-8-git-send-email-aarcange@redhat.com>
 <1332786755.16159.174.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332786755.16159.174.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 08:32:35PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-03-26 at 19:45 +0200, Andrea Arcangeli wrote:
> > +void kthread_bind_node(struct task_struct *p, int nid)
> > +{
> > +       /* Must have done schedule() in kthread() before we set_task_cpu */
> > +       if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
> > +               WARN_ON(1);
> > +               return;
> > +       }
> > +
> > +       /* It's safe because the task is inactive. */
> > +       do_set_cpus_allowed(p, cpumask_of_node(nid));
> > +       p->flags |= PF_THREAD_BOUND;
> > +}
> > +EXPORT_SYMBOL(kthread_bind_node);
> 
> That's a wrong use of PF_THREAD_BOUND, we should only use that for
> cpumask_weight(tsk_cpus_allowed()) == 1.

I don't see what's wrong with more than 1 CPU in the hard bind cpumask.

The only two places that care about PF_THREAD_BOUND are quoted.

This is just to avoid the "root" user to shoot itself in the foot and
crash the kernel by changing the CPU bindings for the kernel thread
(potentially leading to breaking assumptions the kernel thread does on
numa_node_id).

knuma_migratedN for example BUG_ON if the binding is changed under it
before anything bad can happen.

Maybe this wasn't the supposed initial semantic of PF_THREAD_BOUND,
but this extends it without apparent downsides and it adds a bit more
of robustness.

int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
{
	unsigned long flags;
	struct rq *rq;
	unsigned int dest_cpu;
	int ret = 0;

	rq = task_rq_lock(p, &flags);

	if (cpumask_equal(&p->cpus_allowed, new_mask))
		goto out;

	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
		ret = -EINVAL;
		goto out;
	}

	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current)) {
		ret = -EINVAL;
		goto out;
	}
[..]

static int cpuset_can_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
{
	struct cpuset *cs = cgroup_cs(cgrp);
	struct task_struct *task;
	int ret;

	if (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
		return -ENOSPC;

	cgroup_taskset_for_each(task, cgrp, tset) {
		/*
		 * Kthreads bound to specific cpus cannot be moved to a new
		 * cpuset; we cannot change their cpu affinity and
		 * isolating such threads by their set of allowed nodes is
		 * unnecessary.  Thus, cpusets are not applicable for such
		 * threads.  This prevents checking for success of
		 * set_cpus_allowed_ptr() on all attached tasks before
		 * cpus_allowed may be changed.
		 */
		if (task->flags & PF_THREAD_BOUND)
			return -EINVAL;
[..]
