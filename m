Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1ATE7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 23:59:35 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:44793 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755225Ab1ATE7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 23:59:33 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+6Wm5EOXi6huIkcIPUnnLXXyVxQgPQT65QHW4TKr
	VQbLUKkTUV4PFt
Subject: Re: Bug in scheduler when using rt_mutex
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, samu.p.onkalo@nokia.com,
        mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <AANLkTinQ4sczEwZYCk1_tLmeJyjyXj4TVoSZbjg+KiRq@mail.gmail.com>
References: <1295275365.12840.13.camel@kolo>
	 <1295280032.30950.128.camel@laptop> <1295339012.11678.35.camel@kolo>
	 <AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	 <1295357746.30950.681.camel@laptop>
	 <AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
	 <1295430276.30950.1414.camel@laptop> <1295433498.30950.1482.camel@laptop>
	 <1295436632.30950.1542.camel@laptop> <1295441881.11678.41.camel@kolo>
	 <1295442799.11678.43.camel@kolo> <1295443822.28776.23.camel@laptop>
	 <AANLkTinQ4sczEwZYCk1_tLmeJyjyXj4TVoSZbjg+KiRq@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 05:59:28 +0100
Message-ID: <1295499568.8027.30.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 12:18 +0800, Yong Zhang wrote:
> On Wed, Jan 19, 2011 at 9:30 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > +static void switched_from_fair(struct rq *rq, struct task_struct *p)
> > +{
> > +       struct sched_entity *se = &p->se;
> > +       struct cfs_rq *cfs_rq = cfs_rq_of(se);
> > +
> > +       /*
> > +        * Ensure the task's vruntime is normalized, so that when its
> > +        * switched back to the fair class the enqueue_entity(.flags=0) will
> > +        * do the right thing.
> > +        *
> > +        * If it was on_rq, then the dequeue_entity(.flags=0) will already
> > +        * have normalized the vruntime, if it was !on_rq, then only when
> > +        * the task is sleeping will it still have non-normalized vruntime.
> > +        */
> > +       if (!se->on_rq && p->state != TASK_RUNNING)
> > +               se->vruntime -= cfs_rq->min_vruntime;
> 
> Here it's possible that se->vruntime is little than cfs_rq->min_vruntime.

The idea of normalizing is to preserve the offset, so the task can be
enqueued at this same offset, regardless of movement.

For sleepers, we can't usually do this until enqueue time, lest their
sleep time be unaccountable.  Here, we have to normalize, so the task's
sleep stops from the vantage point of fair_class upon class exit, and
either resumes where it left off upon re-entry, or the task is enqueued
at it's last offset as usual for runnable tasks.

	-Mike

