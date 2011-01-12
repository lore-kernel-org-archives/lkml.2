Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1ALFkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 00:40:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab1ALFkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 00:40:46 -0500
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Mike Galbraith <mgalbraith@suse.de>
To: bharata@linux.vnet.ibm.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1294771686.8006.15.camel@marge.simson.net>
References: <20110110091622.GF2772@in.ibm.com>
	 <1294655388.8197.22.camel@marge.simson.net>
	 <1294657154.2016.459.camel@laptop>
	 <1294677746.8345.4.camel@marge.simson.net>
	 <20110111171046.GL4772@in.ibm.com>
	 <1294771686.8006.15.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 06:40:42 +0100
Message-ID: <1294810842.8370.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-11 at 19:48 +0100, Mike Galbraith wrote:
> On Tue, 2011-01-11 at 22:40 +0530, Bharata B Rao wrote:
> > On Mon, Jan 10, 2011 at 05:42:26PM +0100, Mike Galbraith wrote:
> > > Index: linux-2.6/kernel/sched_autogroup.c
> > > ===================================================================
> > > --- linux-2.6.orig/kernel/sched_autogroup.c
> > > +++ linux-2.6/kernel/sched_autogroup.c
> > > @@ -73,6 +73,15 @@ static inline struct autogroup *autogrou
> > >  	ag->id = atomic_inc_return(&autogroup_seq_nr);
> > >  	ag->tg = tg;
> > >  	tg->autogroup = ag;
> > > +#ifdef CONFIG_RT_GROUP_SCHED
> > > +	/*
> > > +	 * HACK: autogroup RT tasks run in the root task group.
> > > +	 * This fools __sched_setscheduler() into proceeding on
> > > +	 * so we can move the task to the appropriate runqueue
> > > +	 * upon scheduling policy change.
> > > +	 */
> > > +	tg->rt_bandwidth.rt_runtime = RUNTIME_INF;
> > > +#endif
> > > 
> > >  	return ag;
> > > 
> > > @@ -143,6 +152,15 @@ autogroup_move_group(struct task_struct
> > >  	autogroup_kref_put(prev);
> > >  }
> > > 
> > > +static inline void
> > > +autogroup_setscheduler(struct task_struct *p, int on_rq)
> > > +{
> > > +	if (p->sched_class->task_move_group)
> > > +		p->sched_class->task_move_group(p, on_rq);
> > > +	else
> > > +		set_task_rq(p, task_cpu(p));
> > > +}
> > > +
> > 
> > IIUC, with the above changes you are actually queing the task into
> > rt_rq of an autogroup. But the task's autogroup interface
> > (/proc/<pid>/autogroup) allows you to control the bandwidth of only
> > cfs_rq tasks, while the rt tasks in the group get RUNTIME_INF bandwidth.
> > 
> > I think what we need is a real group change here (which is difficult I
> > think) and not just sched_class change.
> 
> Unless I fscked up, set_task_rq() is the group change.  As soon as the
> task's class changes, it'll be moved to the root_task_group.

But it'd be better to not touch anything, just deflect RT tasks away
from useless queues from the start.

sched, autogroup: fix CONFIG_RT_GROUP_SCHED sched_setscheduler() failure.

If CONFIG_RT_GROUP_SCHED is set, sched_setscheduler() fails due to autogroup
not allocating rt_runtime.  Squirrel allocated but useless rt_se and rt_rq
away for group destruction time, and deflect RT tasks to the root task group.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Reported-by: Bharata B Rao <bharata@linux.vnet.ibm.com>

---
 kernel/sched_autogroup.c |   13 +++++++++++++
 kernel/sched_autogroup.h |    4 ++++
 2 files changed, 17 insertions(+)

Index: linux-2.6/kernel/sched_autogroup.c
===================================================================
--- linux-2.6.orig/kernel/sched_autogroup.c
+++ linux-2.6/kernel/sched_autogroup.c
@@ -27,6 +27,11 @@ static inline void autogroup_destroy(str
 {
 	struct autogroup *ag = container_of(kref, struct autogroup, kref);
 
+#ifdef CONFIG_RT_GROUP_SCHED
+	ag->tg->rt_se = ag->rt_se;
+	ag->tg->rt_rq = ag->rt_rq;
+	ag->tg->rt_bandwidth.rt_runtime = 0;
+#endif
 	sched_destroy_group(ag->tg);
 }
 
@@ -72,6 +77,14 @@ static inline struct autogroup *autogrou
 	init_rwsem(&ag->lock);
 	ag->id = atomic_inc_return(&autogroup_seq_nr);
 	ag->tg = tg;
+#ifdef CONFIG_RT_GROUP_SCHED
+	/* Sorry, we don't do RT, go away. */
+	ag->rt_se = tg->rt_se;
+	ag->rt_rq = tg->rt_rq;
+	tg->rt_se = root_task_group.rt_se;
+	tg->rt_rq = root_task_group.rt_rq;
+	tg->rt_bandwidth.rt_runtime = root_task_group.rt_bandwidth.rt_runtime;
+#endif
 	tg->autogroup = ag;
 
 	return ag;
Index: linux-2.6/kernel/sched_autogroup.h
===================================================================
--- linux-2.6.orig/kernel/sched_autogroup.h
+++ linux-2.6/kernel/sched_autogroup.h
@@ -6,6 +6,10 @@ struct autogroup {
 	struct rw_semaphore	lock;
 	unsigned long		id;
 	int			nice;
+#ifdef CONFIG_RT_GROUP_SCHED
+	struct sched_rt_entity **rt_se;
+	struct rt_rq **rt_rq;
+#endif
 };
 
 static inline struct task_group *
 


