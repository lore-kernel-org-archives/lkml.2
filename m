Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab2DWOZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 10:25:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51755 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2DWOZb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 10:25:31 -0400
Message-ID: <1335191104.28150.153.camel@twins>
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Mon, 23 Apr 2012 16:25:04 +0200
In-Reply-To: <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
> +/*
> + * This is the bandwidth enforcement timer callback. If here, we know
> + * a task is not on its dl_rq, since the fact that the timer was running
> + * means the task is throttled and needs a runtime replenishment.
> + *
> + * However, what we actually do depends on the fact the task is active,
> + * (it is on its rq) or has been removed from there by a call to
> + * dequeue_task_dl(). In the former case we must issue the runtime
> + * replenishment and add the task back to the dl_rq; in the latter, we just
> + * do nothing but clearing dl_throttled, so that runtime and deadline
> + * updating (and the queueing back to dl_rq) will be done by the
> + * next call to enqueue_task_dl().

OK, so that comment isn't entirely clear to me, how can that timer still
be active when the task isn't? You start the timer when you throttle it,
at that point it cannot in fact dequeue itself anymore.

The only possibility I see is the one mentioned with the dl_task() check
below, that someone else called sched_setscheduler() on it.

> + */
> +static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
> +{
> +       unsigned long flags;
> +       struct sched_dl_entity *dl_se = container_of(timer,
> +                                                    struct sched_dl_entity,
> +                                                    dl_timer);
> +       struct task_struct *p = dl_task_of(dl_se);
> +       struct rq *rq = task_rq_lock(p, &flags);
> +
> +       /*
> +        * We need to take care of a possible races here. In fact, the
> +        * task might have changed its scheduling policy to something
> +        * different from SCHED_DEADLINE (through sched_setscheduler()).
> +        */
> +       if (!dl_task(p))
> +               goto unlock;
> +
> +       dl_se->dl_throttled = 0;
> +       if (p->on_rq) {
> +               enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
> +               if (task_has_dl_policy(rq->curr))
> +                       check_preempt_curr_dl(rq, p, 0);
> +               else
> +                       resched_task(rq->curr);
> +       }

So I can't see how that cannot be true.

> +unlock:
> +       task_rq_unlock(rq, p, &flags);
> +
> +       return HRTIMER_NORESTART;
> +} 
