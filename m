Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab1ASDoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 22:44:03 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:47356 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752643Ab1ASDoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 22:44:01 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/+SDQwKuH+kH5HJJ6hTzpTHZXFFhyZZVwwNYLgEd
	i73iUhH4XgQtxd
Subject: Re: Bug in scheduler when using rt_mutex
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, samu.p.onkalo@nokia.com,
        mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
In-Reply-To: <AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
References: <1295275365.12840.13.camel@kolo>
	 <1295280032.30950.128.camel@laptop> <1295339012.11678.35.camel@kolo>
	 <AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	 <1295357746.30950.681.camel@laptop>
	 <AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 04:43:57 +0100
Message-ID: <1295408637.8017.56.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 10:38 +0800, Yong Zhang wrote:

> > Index: linux-2.6/kernel/sched_fair.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched_fair.c
> > +++ linux-2.6/kernel/sched_fair.c
> > @@ -4075,6 +4075,22 @@ static void prio_changed_fair(struct rq
> >  static void switched_to_fair(struct rq *rq, struct task_struct *p,
> >                             int running)
> >  {
> > +       struct sched_entity *se = &p->se;
> > +       struct cfs_rq *cfs_rq = cfs_rq_of(se);
> > +
> > +       if (se->on_rq && cfs_rq->curr != se)
> 
> (cfs_rq->curr != se) equals to (!running), no?

No, running is task_of(se) == rq->curr.  Another class or fair group
task may be rq_of(cfs_rq)->curr

> > +               __dequeue_entity(cfs_rq, se);
> > +
> > +       /*
> > +        * se->vruntime can be completely out there, there is no telling
> > +        * how long this task was !fair and on what CPU if any it became
> > +        * !fair. Therefore, reset it to a known, reasonable value.
> > +        */
> > +       se->vruntime = cfs_rq->min_vruntime;
> 
> But this is not fair for !SLEEP task.
> You know se->vruntime -= cfs_rq->min_vruntime for !SLEEP task,
> then after it go through sched_fair-->sched_rt-->sched_fair by some
> means, current cfs_rq->min_vruntime is added back.

It drops lag for all, positive or negative.

> But here se is putted before where it should be. Is this what we want?

It may move forward or backward.  If transitions can happen at high
frequency it could be a problem, otherwise, it's a cornercase blip.

An alternative is to leave lag alone. and normalize sleepers, but that's
(did that) considerably more intrusive.

	-Mike

