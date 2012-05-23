Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933944Ab2EWVoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:44:54 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51227 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933762Ab2EWVot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:44:49 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com
Subject: [PATCH 08/15] sched: add period support for -deadline tasks.
Date: Wed, 23 May 2012 23:42:48 +0200
Message-Id: <1337809375-24295-9-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
References: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Gustafsson <harald.gustafsson@ericsson.com>

Make it possible to specify a period (different or equal than
deadline) for -deadline tasks.

Signed-off-by: Harald Gustafsson <harald.gustafsson@ericsson.com>
Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |   15 ++++++++++++---
 kernel/sched/dl.c     |   10 +++++++---
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index fb8062c..dc5b753 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1265,6 +1265,7 @@ struct sched_dl_entity {
 	 */
 	u64 dl_runtime;		/* maximum runtime for each instance	*/
 	u64 dl_deadline;	/* relative deadline of each instance	*/
+	u64 dl_period;		/* separation of two instances (period) */
 
 	/*
 	 * Actual scheduling parameters. Initialized with the values above,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 051e609..fd09961 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1724,6 +1724,7 @@ static void __sched_fork(struct task_struct *p)
 	hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	p->dl.dl_runtime = p->dl.runtime = 0;
 	p->dl.dl_deadline = p->dl.deadline = 0;
+	p->dl.dl_period = 0;
 	p->dl.flags = 0;
 
 	INIT_LIST_HEAD(&p->rt.run_list);
@@ -4092,6 +4093,10 @@ __setparam_dl(struct task_struct *p, const struct sched_param2 *param2)
 	init_dl_task_timer(dl_se);
 	dl_se->dl_runtime = param2->sched_runtime;
 	dl_se->dl_deadline = param2->sched_deadline;
+	if (param2->sched_period != 0)
+		dl_se->dl_period = param2->sched_period;
+	else
+		dl_se->dl_period = dl_se->dl_deadline;
 	dl_se->flags = param2->sched_flags;
 	dl_se->dl_throttled = 0;
 	dl_se->dl_new = 1;
@@ -4105,19 +4110,23 @@ __getparam_dl(struct task_struct *p, struct sched_param2 *param2)
 	param2->sched_priority = p->rt_priority;
 	param2->sched_runtime = dl_se->dl_runtime;
 	param2->sched_deadline = dl_se->dl_deadline;
+	param2->sched_period = dl_se->dl_period;
 	param2->sched_flags = dl_se->flags;
 }
 
 /*
  * This function validates the new parameters of a -deadline task.
  * We ask for the deadline not being zero, and greater or equal
- * than the runtime.
+ * than the runtime, as well as the period of being zero or
+ * greater than deadline.
  */
 static bool
 __checkparam_dl(const struct sched_param2 *prm)
 {
-	return prm && (&prm->sched_deadline) != 0 &&
-	       (s64)(&prm->sched_deadline - &prm->sched_runtime) >= 0;
+	return prm && prm->sched_deadline != 0 &&
+	       (prm->sched_period == 0 ||
+		(s64)(prm->sched_period - prm->sched_deadline) >= 0) &&
+	       (s64)(prm->sched_deadline - prm->sched_runtime) >= 0;
 }
 
 /*
diff --git a/kernel/sched/dl.c b/kernel/sched/dl.c
index 0262c16..75de7cc 100644
--- a/kernel/sched/dl.c
+++ b/kernel/sched/dl.c
@@ -286,7 +286,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 * arbitrary large.
 	 */
 	while (dl_se->runtime <= 0) {
-		dl_se->deadline += dl_se->dl_deadline;
+		dl_se->deadline += dl_se->dl_period;
 		dl_se->runtime += dl_se->dl_runtime;
 	}
 
@@ -326,9 +326,13 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
  *
  * This function returns true if:
  *
- *   runtime / (deadline - t) > dl_runtime / dl_deadline ,
+ *   runtime / (deadline - t) > dl_runtime / dl_period ,
  *
  * IOW we can't recycle current parameters.
+ *
+ * Notice that the bandwidth check is done against the period. For
+ * task with deadline equal to period this is the same of using
+ * dl_deadline instead of dl_period in the equation above.
  */
 static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
 {
@@ -347,7 +351,7 @@ static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
 	 * to the (absolute) deadline. Therefore, overflowing the u64
 	 * type is very unlikely to occur in both cases.
 	 */
-	left = mul_u64_u64(dl_se->dl_deadline, dl_se->runtime);
+	left = mul_u64_u64(dl_se->dl_period, dl_se->runtime);
 	right = mul_u64_u64((dl_se->deadline - t), dl_se->dl_runtime);
 
 	if (cmp_u128(left, right) > 0)
-- 
1.7.9.5

