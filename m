Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab2DFHRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:17:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47661 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab2DFHP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:15:27 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Subject: [PATCH 08/16] sched: add period support for -deadline tasks.
Date: Fri,  6 Apr 2012 09:14:33 +0200
Message-Id: <1333696481-3433-9-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
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
 kernel/sched.c        |   15 ++++++++++++---
 kernel/sched_dl.c     |   10 +++++++---
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 416ce99..5961592 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1278,6 +1278,7 @@ struct sched_dl_entity {
 	 */
 	u64 dl_runtime;		/* maximum runtime for each instance	*/
 	u64 dl_deadline;	/* relative deadline of each instance	*/
+	u64 dl_period;		/* separation of two instances (period) */
 
 	/*
 	 * Actual scheduling parameters. Initialized with the values above,
diff --git a/kernel/sched.c b/kernel/sched.c
index 1a38ad1..9461958 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3024,6 +3024,7 @@ static void __sched_fork(struct task_struct *p)
 	hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	p->dl.dl_runtime = p->dl.runtime = 0;
 	p->dl.dl_deadline = p->dl.deadline = 0;
+	p->dl.dl_period = 0;
 	p->dl.flags = 0;
 
 	INIT_LIST_HEAD(&p->rt.run_list);
@@ -5490,6 +5491,10 @@ __setparam_dl(struct task_struct *p, const struct sched_param2 *param2)
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
@@ -5503,19 +5508,23 @@ __getparam_dl(struct task_struct *p, struct sched_param2 *param2)
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
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index 11c9b8d..8682ee2 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -266,7 +266,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 * arbitrary large.
 	 */
 	while (dl_se->runtime <= 0) {
-		dl_se->deadline += dl_se->dl_deadline;
+		dl_se->deadline += dl_se->dl_period;
 		dl_se->runtime += dl_se->dl_runtime;
 	}
 
@@ -293,7 +293,11 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
  * assigned (function returns true if it can).
  *
  * For this to hold, we must check if:
- *   runtime / (deadline - t) < dl_runtime / dl_deadline .
+ *   runtime / (deadline - t) < dl_runtime / dl_period .
+ *
+ * Notice that the bandwidth check is done against the period. For
+ * task with deadline equal to period this is the same of using
+ * dl_deadline instead of dl_period in the equation above.
  */
 static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
 {
@@ -312,7 +316,7 @@ static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
 	 * to the (absolute) deadline. Therefore, overflowing the u64
 	 * type is very unlikely to occur in both cases.
 	 */
-	left = dl_se->dl_deadline * dl_se->runtime;
+	left = dl_se->dl_period * dl_se->runtime;
 	right = (dl_se->deadline - t) * dl_se->dl_runtime;
 
 	return dl_time_before(right, left);
-- 
1.7.5.4

