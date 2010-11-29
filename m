Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab0K2L7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 06:59:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:48833 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab0K2L7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 06:59:34 -0500
Subject: Re: [tip:sched/core] sched: Do not account irq time to current task
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, venki@google.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <AANLkTin-U-kzr27ArR60K=eE5Jq+sPdTQ7JNhQg711c7@mail.gmail.com>
References: <1286237003-12406-7-git-send-email-venki@google.com>
	 <tip-305e6835e05513406fa12820e40e4a8ecb63743c@git.kernel.org>
	 <AANLkTin-U-kzr27ArR60K=eE5Jq+sPdTQ7JNhQg711c7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 29 Nov 2010 12:59:50 +0100
Message-ID: <1291031990.32004.24.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 16:45 +0800, Yong Zhang wrote:
> On Tue, Oct 19, 2010 at 3:26 AM, tip-bot for Venkatesh Pallipadi
> <venki@google.com> wrote:
> > Commit-ID:  305e6835e05513406fa12820e40e4a8ecb63743c
> > Gitweb:     http://git.kernel.org/tip/305e6835e05513406fa12820e40e4a8ecb63743c
> > Author:     Venkatesh Pallipadi <venki@google.com>
> > AuthorDate: Mon, 4 Oct 2010 17:03:21 -0700
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 18 Oct 2010 20:52:26 +0200
> >
> > sched: Do not account irq time to current task
> >
> > Scheduler accounts both softirq and interrupt processing times to the
> > currently running task. This means, if the interrupt processing was
> > for some other task in the system, then the current task ends up being
> > penalized as it gets shorter runtime than otherwise.
> >
> > Change sched task accounting to acoount only actual task time from
> > currently running task. Now update_curr(), modifies the delta_exec to
> > depend on rq->clock_task.
> >
> > Note that this change only handles CONFIG_IRQ_TIME_ACCOUNTING case. We can
> > extend this to CONFIG_VIRT_CPU_ACCOUNTING with minimal effort. But, thats
> > for later.
> >
> > This change will impact scheduling behavior in interrupt heavy conditions.
> >
> > Tested on a 4-way system with eth0 handled by CPU 2 and a network heavy
> > task (nc) running on CPU 3 (and no RSS/RFS). With that I have CPU 2
> > spending 75%+ of its time in irq processing. CPU 3 spending around 35%
> > time running nc task.
> >
> > Now, if I run another CPU intensive task on CPU 2, without this change
> > /proc/<pid>/schedstat shows 100% of time accounted to this task. With this
> > change, it rightly shows less than 25% accounted to this task as remaining
> > time is actually spent on irq processing.
> >
> > Signed-off-by: Venkatesh Pallipadi <venki@google.com>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > LKML-Reference: <1286237003-12406-7-git-send-email-venki@google.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  kernel/sched.c      |   43 ++++++++++++++++++++++++++++++++++++++++---
> >  kernel/sched_fair.c |    6 +++---
> >  kernel/sched_rt.c   |    8 ++++----
> >  3 files changed, 47 insertions(+), 10 deletions(-)
> >
> 
> [snip]
> 
> > diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> > index ab77aa0..bea7d79 100644
> > --- a/kernel/sched_rt.c
> > +++ b/kernel/sched_rt.c
> > @@ -609,7 +609,7 @@ static void update_curr_rt(struct rq *rq)
> >        if (!task_has_rt_policy(curr))
> >                return;
> >
> > -       delta_exec = rq->clock - curr->se.exec_start;
> > +       delta_exec = rq->clock_task - curr->se.exec_start;
> >        if (unlikely((s64)delta_exec < 0))
> >                delta_exec = 0;
> >
> > @@ -618,7 +618,7 @@ static void update_curr_rt(struct rq *rq)
> >        curr->se.sum_exec_runtime += delta_exec;
> >        account_group_exec_runtime(curr, delta_exec);
> >
> > -       curr->se.exec_start = rq->clock;
> > +       curr->se.exec_start = rq->clock_task;
> >        cpuacct_charge(curr, delta_exec);
> >
> >        sched_rt_avg_update(rq, delta_exec);
> 
> Seems the above changes to update_curr_rt() have some false positive
> to rt_bandwidth control.
> For example:
>   rt_period=1000000;
>   rt_runtime=950000;
>   then if in that period the irq_time is no zero(such as 50000), according to
>   the throttle mechanism, rt is not throttled. In the end we left no
> time to others.
>   It seems that this break the semantic of throttle.
> 
> Maybe we can revert the change to update_curr_rt()?

No, that's totally correct.

Its the correct and desired behaviour, IRQ time is not time spend
running the RT tasks, hence they should not be accounted for it.

If you still want to throttle RT tasks simply ensure their bandwidth
constraint is lower than the available time.



