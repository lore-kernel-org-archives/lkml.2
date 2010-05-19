Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab0ESJGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:06:48 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:36241 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab0ESJGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:06:39 -0400
Date: Wed, 19 May 2010 14:35:57 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Brian King <brking@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Make sure timers have migrated before killing
	migration_thread
Message-ID: <20100519090557.GA15237@amitarora.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem : In a stress test where some heavy tests were running along with
regular CPU offlining and onlining, a hang was observed. The system seems to
be hung at a point where migration_call() tries to kill the migration_thread
of the dying CPU, which just got moved to the current CPU. This migration
thread does not get a chance to run (and die) since rt_throttled is set to 1
on current, and it doesn't get cleared as the hrtimer which is supposed to
reset the rt bandwidth (sched_rt_period_timer) is tied to the CPU being
offlined.

Solution : This patch pushes the killing of migration thread to "CPU_POST_DEAD"
event. By then all the timers (including sched_rt_period_timer) should have got
migrated (along with other callbacks).

Alternate Solution considered : Another option considered was to
increase the priority of the hrtimer cpu offline notifier, such that it
gets to run before scheduler's migration cpu offline notifier. In this
way we are sure that the timers will get migrated before migration_call
tries to kill migration_thread. But, this can have some non-obvious
implications, suggested Srivatsa.

Testing : Without the patch the stress tests didn't last for even 12
hours. And yes, the problem was reproducible. With the patch applied the
tests ran successfully for more than 48 hours.

Thanks!
--
Regards,
Amit Arora

 Signed-off-by: Amit Arora <aarora@in.ibm.com>
 Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
--
diff -Nuarp linux-2.6.34.org/kernel/sched.c linux-2.6.34/kernel/sched.c
--- linux-2.6.34.org/kernel/sched.c	2010-05-18 22:56:21.000000000 -0700
+++ linux-2.6.34/kernel/sched.c	2010-05-18 22:58:31.000000000 -0700
@@ -5942,14 +5942,26 @@ migration_call(struct notifier_block *nf
 		cpu_rq(cpu)->migration_thread = NULL;
 		break;
 
+	case CPU_POST_DEAD:
+		/*
+		  Bring the migration thread down in CPU_POST_DEAD event,
+		  since the timers should have got migrated by now and thus
+		  we should not see a deadlock between trying to kill the
+		  migration thread and the sched_rt_period_timer.
+		*/
+		cpuset_lock();
+		rq = cpu_rq(cpu);
+		kthread_stop(rq->migration_thread);
+		put_task_struct(rq->migration_thread);
+		rq->migration_thread = NULL;
+		cpuset_unlock();
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
 		raw_spin_lock_irq(&rq->lock);
 		update_rq_clock(rq);
