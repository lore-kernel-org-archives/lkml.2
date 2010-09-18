Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab0IRTBo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:01:44 -0400
Received: from kroah.org ([198.145.64.141]:51114 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab0IRTBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:14 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:53 2010
Message-Id: <20100918185953.586127120@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Amit Arora <amitarora@in.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>, Mike Galbraith <efault@gmx.de>
Subject: [009/123] sched: kill migration thread in CPU_POST_DEAD instead of CPU_DEAD
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-kill-migration-thread-in-cpu_post_dead-instead-of-cpu_dead.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Arora <amitarora@in.ibm.com>

[Fixed in a different manner upstream, due to rewrites in this area]

Problem : In a stress test where some heavy tests were running along with
regular CPU offlining and onlining, a hang was observed. The system seems to
be hung at a point where migration_call() tries to kill the migration_thread
of the dying CPU, which just got moved to the current CPU. This migration
thread does not get a chance to run (and die) since rt_throttled is set to 1
on current, and it doesn't get cleared as the hrtimer which is supposed to
reset the rt bandwidth (sched_rt_period_timer) is tied to the CPU which we just
marked dead!

Solution : This patch pushes the killing of migration thread to "CPU_POST_DEAD"
event. By then all the timers (including sched_rt_period_timer) should have got
migrated (along with other callbacks).

Signed-off-by: Amit Arora <amitarora@in.ibm.com>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7752,14 +7752,24 @@ migration_call(struct notifier_block *nf
 		cpu_rq(cpu)->migration_thread = NULL;
 		break;
 
+	case CPU_POST_DEAD:
+		/*
+		 * Bring the migration thread down in CPU_POST_DEAD event,
+		 * since the timers should have got migrated by now and thus
+		 * we should not see a deadlock between trying to kill the
+		 * migration thread and the sched_rt_period_timer.
+		 */
+		rq = cpu_rq(cpu);
+		kthread_stop(rq->migration_thread);
+		put_task_struct(rq->migration_thread);
+		rq->migration_thread = NULL;
+		break;
+
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
-		kthread_stop(rq->migration_thread);
-		put_task_struct(rq->migration_thread);
-		rq->migration_thread = NULL;
 		/* Idle task back to normal (off runqueue, low prio) */
 		spin_lock_irq(&rq->lock);
 		update_rq_clock(rq);


