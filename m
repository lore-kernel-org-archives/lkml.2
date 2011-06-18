Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015Ab1FRRL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 13:11:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1FRRL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 13:11:57 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=Caq5pGLvaXcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=KPl2t01FOZKwL_jAz-gA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: update cpupri for runqueue when its priority
 changes
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTimUd3BWFg4hi6OWLjUYsxvWRRBUZg@mail.gmail.com>
References: <BANLkTint_00+oHVGpgV4n4E2A9W5O8nJxA@mail.gmail.com>
	 <1308275405.9218.156.camel@gandalf.stny.rr.com>
	 <BANLkTik8PpdwGgLOE7rAauXqGYdnT53GpQ@mail.gmail.com>
	 <1308322563.9218.184.camel@gandalf.stny.rr.com>
	 <BANLkTimUd3BWFg4hi6OWLjUYsxvWRRBUZg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 18 Jun 2011 13:11:54 -0400
Message-ID: <1308417114.9218.220.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-06-18 at 22:54 +0800, Hillf Danton wrote:

> >> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> >> index 08e9374..9508168 100644
> >> --- a/kernel/sched_rt.c
> >> +++ b/kernel/sched_rt.c
> >> @@ -1158,6 +1158,8 @@ static struct task_struct
> >> *pick_next_task_rt(struct rq *rq)
> >>          * lock again later if there is no need to push
> >>          */
> >>         rq->post_schedule = has_pushable_tasks(rq);
> >> +
> >> +       cpupri_set(&rq->rd->cpupri, rq->cpu, p == NULL ? MAX_RT_PRIO : p->prio);
> >
> > In pick_next_task_rt(), p is the highes prio that is queued. Thus,
> > cpupri is already set to p->prio. If p is NULL, then there is no rt
> > tasks queued on this rq, and cpupri is set to MAX_RT_PRIO. Your patch
> > here does not change anything.
> >
> 
> There are two cases that NULL is returned in _pick_next_task_rt(), it is the
> second case, after checking rt_rq->rt_nr_running, that is captured, and if
> NULL is returned in the second case, the CPU priority does change.

The two cases are:

1) no rt task exists
2) the runqueue is throttled.

We already talked about the throttled case. The case where no rt task
exists means that the last rt task has been dequeued. When that happens,
the cpupri is updated then. I don't see any bug. There's no need to
update cpupri at this point.

> 
> In another scenario that has little with {en, de}queue, as shown by
> requeue_task_rt(), the CPU priority will change if other RT tasks exist.
> 

The requeue_task_rt() does not change the priority of the CPU. It just
updates the task in its order of placement in the queue of other tasks
of the same priority.

-- Steve


