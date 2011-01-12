Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab1ALGR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 01:17:59 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:53563 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751405Ab1ALGR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 01:17:57 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/ggitQGfrgatpNg8yDTXHCoH9xsB2ixaOkDKnB5h
	JS+UgZbf0DrMNC
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Mike Galbraith <efault@gmx.de>
To: bharata@linux.vnet.ibm.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110112033709.GA2723@in.ibm.com>
References: <20110110091622.GF2772@in.ibm.com>
	 <1294655388.8197.22.camel@marge.simson.net>
	 <1294657154.2016.459.camel@laptop>
	 <1294677746.8345.4.camel@marge.simson.net>
	 <20110111171046.GL4772@in.ibm.com>
	 <1294771686.8006.15.camel@marge.simson.net>
	 <20110112033709.GA2723@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 07:17:52 +0100
Message-ID: <1294813072.8370.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 09:07 +0530, Bharata B Rao wrote:
> On Tue, Jan 11, 2011 at 07:48:06PM +0100, Mike Galbraith wrote:
> > On Tue, 2011-01-11 at 22:40 +0530, Bharata B Rao wrote:
> > > On Mon, Jan 10, 2011 at 05:42:26PM +0100, Mike Galbraith wrote:
> > > > Index: linux-2.6/kernel/sched_autogroup.c
> > > > ===================================================================
> > > > --- linux-2.6.orig/kernel/sched_autogroup.c
> > > > +++ linux-2.6/kernel/sched_autogroup.c
> > > > @@ -73,6 +73,15 @@ static inline struct autogroup *autogrou
> > > >  	ag->id = atomic_inc_return(&autogroup_seq_nr);
> > > >  	ag->tg = tg;
> > > >  	tg->autogroup = ag;
> > > > +#ifdef CONFIG_RT_GROUP_SCHED
> > > > +	/*
> > > > +	 * HACK: autogroup RT tasks run in the root task group.
> > > > +	 * This fools __sched_setscheduler() into proceeding on
> > > > +	 * so we can move the task to the appropriate runqueue
> > > > +	 * upon scheduling policy change.
> > > > +	 */
> > > > +	tg->rt_bandwidth.rt_runtime = RUNTIME_INF;
> > > > +#endif
> > > > 
> > > >  	return ag;
> > > > 
> > > > @@ -143,6 +152,15 @@ autogroup_move_group(struct task_struct
> > > >  	autogroup_kref_put(prev);
> > > >  }
> > > > 
> > > > +static inline void
> > > > +autogroup_setscheduler(struct task_struct *p, int on_rq)
> > > > +{
> > > > +	if (p->sched_class->task_move_group)
> > > > +		p->sched_class->task_move_group(p, on_rq);
> > > > +	else
> > > > +		set_task_rq(p, task_cpu(p));
> > > > +}
> > > > +
> > > 
> > > IIUC, with the above changes you are actually queing the task into
> > > rt_rq of an autogroup. But the task's autogroup interface
> > > (/proc/<pid>/autogroup) allows you to control the bandwidth of only
> > > cfs_rq tasks, while the rt tasks in the group get RUNTIME_INF bandwidth.
> > > 
> > > I think what we need is a real group change here (which is difficult I
> > > think) and not just sched_class change.
> > 
> > Unless I fscked up, set_task_rq() is the group change.  As soon as the
> > task's class changes, it'll be moved to the root_task_group.
> 
> Ok, this is what I understand, may be Peter Z can confirm...
> 
> set_task_rq() just changes the task's cfs_rq and rt_rq as per its
> task_group().

Exactly.  When you call task_group() for an RT task, it returns
&root_task_group, so a task making the transition to RT will be dequeued
from it's autogroup cfs_rq, and enqueued in root_task_group's rt_rq.

>  The normal way to change a task's group is to first
> change its cgroup pointer (task->cgroups, see cgroup_attach_task())
> After this you change the runqueues by calling set_task_rq() which
> now refers to new group's runqueues.

Autogroup doesn't need to do cgroup stuff.  If a task is in a cgroup,
it's autogroup remains intact, but is ignored.  Move it back to root,
and it's autogroup will be used again.

	-Mike

