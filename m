Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab2JXJgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:36:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54700 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab2JXJgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:36:14 -0400
Date: Wed, 24 Oct 2012 02:34:50 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-vn7p3ynbwqt3qqewhdlvjltc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, riel@redhat.com,
        akpm@linux-foundation.org, aarcange@redhat.com, tglx@linutronix.de
Reply-To: riel@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        aarcange@redhat.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] numa, sched:
  Implement slow start for working set sampling
Git-Commit-ID: 4c7ab9c516a9778cfa2122119210b6513cccbd2f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:34:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c7ab9c516a9778cfa2122119210b6513cccbd2f
Gitweb:     http://git.kernel.org/tip/4c7ab9c516a9778cfa2122119210b6513cccbd2f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 22 Oct 2012 20:15:40 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 08:51:55 +0200

numa, sched: Implement slow start for working set sampling

Add a 1 second delay before starting to scan the working set of
a task and starting to balance it amongst nodes.

The theory is that short-run tasks benefit very little from NUMA
placement: they come and go, and they better stick to the node
they were started on. As tasks mature and rebalance to other CPUs
and nodes, so does their NUMA placement have to change and so
does it start to matter more and more.

In practice this change fixes an observable kbuild regression:

   # [ a perf stat --null --repeat 10 test of ten bzImage builds to /dev/shm ]

   !NUMA:
   45.291088843 seconds time elapsed                                          ( +-  0.40% )
   45.154231752 seconds time elapsed                                          ( +-  0.36% )

   +NUMA, no slow start:
   46.172308123 seconds time elapsed                                          ( +-  0.30% )
   46.343168745 seconds time elapsed                                          ( +-  0.25% )

   +NUMA, 1 sec slow start:
   45.224189155 seconds time elapsed                                          ( +-  0.25% )
   45.160866532 seconds time elapsed                                          ( +-  0.17% )

and it also fixes an observable perf bench (hackbench) regression:

   # perf stat --null --repeat 10 perf bench sched messaging

   -NUMA:

   -NUMA:                  0.246225691 seconds time elapsed                   ( +-  1.31% )
   +NUMA no slow start:    0.252620063 seconds time elapsed                   ( +-  1.13% )

   +NUMA 1sec delay:       0.248076230 seconds time elapsed                   ( +-  1.35% )

The implementation is simple and straightforward, most of the patch
deals with adding the /proc/sys/kernel/sched_numa_scan_delay_ms tunable
knob and with renaming task_period to scan_period.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Link: http://lkml.kernel.org/n/tip-vn7p3ynbwqt3qqewhdlvjltc@git.kernel.org
[ Wrote the changelog, ran measurements, tuned the default. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |    7 ++++---
 kernel/sched/core.c   |    2 +-
 kernel/sched/fair.c   |   21 ++++++++++++---------
 kernel/sysctl.c       |   15 +++++++++++----
 4 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 63c011e..2eedef9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1484,7 +1484,7 @@ struct task_struct {
 	int node;			/* task home node   */
 	int numa_scan_seq;
 	int numa_migrate_seq;
-	unsigned int numa_task_period;
+	unsigned int numa_scan_period;
 	u64 node_stamp;			/* migration stamp  */
 	unsigned long numa_contrib;
 	unsigned long *numa_faults;
@@ -2020,8 +2020,9 @@ enum sched_tunable_scaling {
 };
 extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;
 
-extern unsigned int sysctl_sched_numa_task_period_min;
-extern unsigned int sysctl_sched_numa_task_period_max;
+extern unsigned int sysctl_sched_numa_scan_delay;
+extern unsigned int sysctl_sched_numa_scan_period_min;
+extern unsigned int sysctl_sched_numa_scan_period_max;
 extern unsigned int sysctl_sched_numa_scan_size;
 extern unsigned int sysctl_sched_numa_settle_count;
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 67221c0..407fd65f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1545,7 +1545,7 @@ static void __sched_fork(struct task_struct *p)
 	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
 	p->numa_migrate_seq = p->mm ? p->mm->numa_scan_seq - 1 : 0;
 	p->numa_faults = NULL;
-	p->numa_task_period = sysctl_sched_numa_task_period_min;
+	p->numa_scan_period = sysctl_sched_numa_scan_delay;
 	p->numa_work.next = &p->numa_work;
 #endif /* CONFIG_SCHED_NUMA */
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f8b3539..1dad296 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -825,11 +825,12 @@ static void account_numa_dequeue(struct rq *rq, struct task_struct *p)
 }
 
 /*
- * numa task sample period in ms: 5s
+ * Scan @scan_size MB every @scan_period after an initial @scan_delay.
  */
-unsigned int sysctl_sched_numa_task_period_min = 100;
-unsigned int sysctl_sched_numa_task_period_max = 100*16;
-unsigned int sysctl_sched_numa_scan_size = 256;   /* MB */
+unsigned int sysctl_sched_numa_scan_delay = 1000;	/* ms */
+unsigned int sysctl_sched_numa_scan_period_min = 100;	/* ms */
+unsigned int sysctl_sched_numa_scan_period_max = 100*16;/* ms */
+unsigned int sysctl_sched_numa_scan_size = 256;		/* MB */
 
 /*
  * Wait for the 2-sample stuff to settle before migrating again
@@ -862,15 +863,15 @@ static void task_numa_placement(struct task_struct *p)
 		return;
 
 	if (p->node != max_node) {
-		p->numa_task_period = sysctl_sched_numa_task_period_min;
+		p->numa_scan_period = sysctl_sched_numa_scan_period_min;
 		if (sched_feat(NUMA_SETTLE) &&
 		    (seq - p->numa_migrate_seq) <= (int)sysctl_sched_numa_settle_count)
 			return;
 		p->numa_migrate_seq = seq;
 		sched_setnode(p, max_node);
 	} else {
-		p->numa_task_period = min(sysctl_sched_numa_task_period_max,
-				p->numa_task_period * 2);
+		p->numa_scan_period = min(sysctl_sched_numa_scan_period_max,
+				p->numa_scan_period * 2);
 	}
 }
 
@@ -928,7 +929,7 @@ void task_numa_work(struct callback_head *work)
 	if (time_before(now, migrate))
 		return;
 
-	next_scan = now + 2*msecs_to_jiffies(sysctl_sched_numa_task_period_min);
+	next_scan = now + 2*msecs_to_jiffies(sysctl_sched_numa_scan_period_min);
 	if (cmpxchg(&mm->numa_next_scan, migrate, next_scan) != migrate)
 		return;
 
@@ -989,9 +990,11 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 	 * NUMA placement.
 	 */
 	now = curr->se.sum_exec_runtime;
-	period = (u64)curr->numa_task_period * NSEC_PER_MSEC;
+	period = (u64)curr->numa_scan_period * NSEC_PER_MSEC;
 
 	if (now - curr->node_stamp > period) {
+		if (!curr->node_stamp)
+			curr->numa_scan_period = sysctl_sched_numa_scan_period_min;
 		curr->node_stamp = now;
 
 		if (!time_before(jiffies, curr->mm->numa_next_scan)) {
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0f0cb60..2f7e671 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -351,15 +351,22 @@ static struct ctl_table kern_table[] = {
 #endif /* CONFIG_SMP */
 #ifdef CONFIG_SCHED_NUMA
 	{
-		.procname	= "sched_numa_task_period_min_ms",
-		.data		= &sysctl_sched_numa_task_period_min,
+		.procname	= "sched_numa_scan_delay_ms",
+		.data		= &sysctl_sched_numa_scan_delay,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
 	{
-		.procname	= "sched_numa_task_period_max_ms",
-		.data		= &sysctl_sched_numa_task_period_max,
+		.procname	= "sched_numa_scan_period_min_ms",
+		.data		= &sysctl_sched_numa_scan_period_min,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "sched_numa_scan_period_max_ms",
+		.data		= &sysctl_sched_numa_scan_period_max,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
