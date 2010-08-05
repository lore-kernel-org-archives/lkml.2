Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066Ab0HEJ7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:59:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:39400 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab0HEJ6q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:58:46 -0400
Subject: Re: clock drift in set_task_cpu()
From: Peter Zijlstra <peterz@infradead.org>
To: Jack Daniel <wanders.thirst@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <AANLkTinNr28LM6NfsmbbmmV28mCzUugTTSI_Bq6N9-8C@mail.gmail.com>
References: <AANLkTinNr28LM6NfsmbbmmV28mCzUugTTSI_Bq6N9-8C@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 05 Aug 2010 11:58:42 +0200
Message-ID: <1281002322.1923.1708.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-21 at 17:10 +0530, Jack Daniel wrote:
> On a Xeon 55xx with 8 CPU's, I found out the new_rq->clock value is
> sometimes larger than old_rq->clock and so clock_offset tends to warp
> around leading to incorrect values.

What values get incorrect, do you observe vruntime funnies or only the
schedstat values?

>  You have very correctly noted in
> the commit header that all functions that access set_task_cpu() must
> do so after a call to sched_clock_remote(), in this case the function
> is sched_fork(). I validated by adding update_rq_clock(old_rq); into
> set_task_cpu() and that seems to fix the issue. 

Ah, so the problem is that task_fork_fair() does the task placement
without updated rq clocks? In which case I think we should at least do
an update_rq_clock(rq) in there (see the below patch).

> But I noticed that
> since CONFIG_HAVE_UNSTABLE_SCHED_CLOCK is already set, if
> (sched_clock_stable)  in sched_clock_cpu() will yield to true and the
> flow never gets to sched_clock_remote() or sched_clock_local().

sched_clock_stable being true implies the clock is stable across cores
and thus it shouldn't matter. Or are you saying you're seeing it being
set and still have issues?

> I bet you would have had come across this problem and hence chose to
> surgically remove the impeding code with commit 5afcdab. I now think
> it was a good choice but the right thing would have been to correct
> the problem itself. I think this code should have solved the problem.
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 1d39b00..5fd63f2 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2068,6 +2068,13 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
>         struct cfs_rq *old_cfsrq = task_cfs_rq(p),
>                       *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
>         u64 clock_offset;
> +       unsigned long flags;
> +
> +       rmb();
> +       local_irq_save(flags);
> +       update_rq_clock(old_rq);
> +       update_rq_clock(new_rq);
> +       local_irq_restore(flags);

The problem here is that your patch introduces the exact race I was
trying to close. We can only access rq->clock when also holding the
appropriate rq->lock, disabling IRQs, while also required is not
sufficient.

[ Also, that rmb() looks just plain wrong ]

Anyway, does the below cure your trouble? (Also, could you describe your
actually observed trouble in more detail?)

---

Subject: sched: ensure rq->clock get sync'ed when migrating tasks

sched_fork() -- we do task placement in ->task_fork_fair() ensure we
  update_rq_clock() so we work with current time. We leave the vruntime
  in relative state, so the time delay until wake_up_new_task() doesn't
  matter.

wake_up_new_task() -- Since task_fork_fair() left p->vruntime in
  relative state we can safely migrate, the activate_task() on the
  remote rq will call update_rq_clock() and causes the clock to be
  synced (enough).

try_to_wake_up() -- In case we'll migrate, we need to update the old
  rq->clock, the activate_task() in ttwu_activate() will already update
  the new rq->clock, and thus the clocks will get sync'ed.

load-balance -- Migrating running tasks always happens with both rq's
  locked, either through double_rq_lock() or double_lock_balance(). So
  sync the rq->clock there.

The problem seems to be that this all could result in too many rq->clock
updates, which are expensive.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |   20 ++++++++++++++++++--
 kernel/sched_fair.c |    2 ++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d3c0262..69584b4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1756,13 +1756,22 @@ static int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
  */
 static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
 {
+	int ret;
+
+#ifdef CONFIG_SCHED_DEBUG
 	if (unlikely(!irqs_disabled())) {
 		/* printk() doesn't work good under rq->lock */
 		raw_spin_unlock(&this_rq->lock);
 		BUG_ON(1);
 	}
+#endif
+
+	ret = _double_lock_balance(this_rq, busiest);
+
+	update_rq_clock(this_rq);
+	update_rq_clock(busiest);
 
-	return _double_lock_balance(this_rq, busiest);
+	return ret;
 }
 
 static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
@@ -1782,7 +1791,9 @@ static void double_rq_lock(struct rq *rq1, struct rq *rq2)
 	__acquires(rq1->lock)
 	__acquires(rq2->lock)
 {
+#ifdef CONFIG_SCHED_DEBUG
 	BUG_ON(!irqs_disabled());
+#endif
 	if (rq1 == rq2) {
 		raw_spin_lock(&rq1->lock);
 		__acquire(rq2->lock);	/* Fake it out ;) */
@@ -1795,6 +1806,9 @@ static void double_rq_lock(struct rq *rq1, struct rq *rq2)
 			raw_spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
 		}
 	}
+
+	update_rq_clock(rq1);
+	update_rq_clock(rq2);
 }
 
 /*
@@ -2395,8 +2409,10 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	}
 
 	cpu = select_task_rq(rq, p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu)
+	if (cpu != orig_cpu) {
 		set_task_cpu(p, cpu);
+		update_rq_clock(rq);
+	}
 	__task_rq_unlock(rq);
 
 	rq = cpu_rq(cpu);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9910e1b..f816e74 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3751,6 +3751,8 @@ static void task_fork_fair(struct task_struct *p)
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
+	update_rq_clock(rq);
+
 	if (unlikely(task_cpu(p) != this_cpu))
 		__set_task_cpu(p, this_cpu);
 

