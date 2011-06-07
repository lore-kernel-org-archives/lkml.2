Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab1FGJcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 05:32:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:48344 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1FGJcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:32:00 -0400
Subject: Re: [PATCH] sched: RCU-protect __set_task_cpu() in set_task_cpu()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110606164657.GA20752@redhat.com>
References: <20110531172651.GA4478@swordfish.minsk.epam.com>
	 <1307115427.2353.3456.camel@twins> <20110605191233.GA20462@redhat.com>
	 <1307351198.2353.7415.camel@twins>  <20110606164657.GA20752@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Jun 2011 11:31:47 +0200
Message-ID: <1307439107.2322.229.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 18:46 +0200, Oleg Nesterov wrote:
> On 06/06, Peter Zijlstra wrote:
> >
> > You're right, p->pi_lock for wakeups, rq->lock for runnable tasks.
> 
> Good, thanks.
> 
> Help! I have another question.
> 
> 	try_to_wake_up:
> 
> 		raw_spin_lock_irqsave(&p->pi_lock, flags);
> 		if (!(p->state & state))
> 			goto out;
> 
> 		cpu = task_cpu(p);
> 
> 		if (p->on_rq && ttwu_remote(p, wake_flags))
> 			goto stat;
> 
> This doesn't look a bit confusing, we can't trust "cpu = task_cpu" before
> we check ->on_rq. OK, not a problem, this cpu number can only be used in
> ttwu_stat(cpu).
> 
> But ttwu_stat(cpu) in turn does
> 
> 	if (cpu != task_cpu(p))
> 		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
> 
> Ignoring the theoretical races with pull_task/etc, how it is possible
> that cpu != task_cpu(p) ? Another caller is try_to_wake_up_local(), it
> obviously can't trigger this case.
> 
> This looks broken to me. Looking at its name, I guess nr_wakeups_migrate
> should be incremented if ttwu does set_task_cpu(), correct?
> 
> IOW. Don't we need something like the (untested/ucompiled) patch below?
> _If_ I am right, I can resend it with the changelog/etc but please feel
> free to make another fix.

You're right, I spotted the same a few days ago which resulted in:

---
commit f339b9dc1f03591761d5d930800db24bc0eda1e1
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Tue May 31 10:49:20 2011 +0200

    sched: Fix schedstat.nr_wakeups_migrate
    
    While looking over the code I found that with the ttwu rework the
    nr_wakeups_migrate test broke since we now switch cpus prior to
    calling ttwu_stat(), hence the test is always true.
    
    Cure this by passing the migration state in wake_flags. Also move the
    whole test under CONFIG_SMP, its hard to migrate tasks on UP :-)
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link: http://lkml.kernel.org/n/tip-pwwxl7gdqs5676f1d4cx6pj7@git.kernel.org
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8da84b7..483c1ed 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1063,6 +1063,7 @@ struct sched_domain;
  */
 #define WF_SYNC		0x01		/* waker goes to sleep after wakup */
 #define WF_FORK		0x02		/* child wakeup after fork */
+#define WF_MIGRATED	0x04		/* internal use, task got migrated */
 
 #define ENQUEUE_WAKEUP		1
 #define ENQUEUE_HEAD		2
diff --git a/kernel/sched.c b/kernel/sched.c
index 49cc70b..2fe98ed 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2447,6 +2447,10 @@ ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
 		}
 		rcu_read_unlock();
 	}
+
+	if (wake_flags & WF_MIGRATED)
+		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
+
 #endif /* CONFIG_SMP */
 
 	schedstat_inc(rq, ttwu_count);
@@ -2455,9 +2459,6 @@ ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
 	if (wake_flags & WF_SYNC)
 		schedstat_inc(p, se.statistics.nr_wakeups_sync);
 
-	if (cpu != task_cpu(p))
-		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
-
 #endif /* CONFIG_SCHEDSTATS */
 }
 
@@ -2675,8 +2676,10 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 		p->sched_class->task_waking(p);
 
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (task_cpu(p) != cpu)
+	if (task_cpu(p) != cpu) {
+		wake_flags |= WF_MIGRATED;
 		set_task_cpu(p, cpu);
+	}
 #endif /* CONFIG_SMP */
 
 	ttwu_queue(p, cpu);

