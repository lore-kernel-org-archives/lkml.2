Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1LLTVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 14:21:22 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53709 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab1LLTVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 14:21:21 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        a.p.zijlstra@chello.nl
Cc: patches@linaro.org, Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC] sched: Ensure cpu_power periodic update
Date: Mon, 12 Dec 2011 20:21:08 +0100
Message-Id: <1323717668-2143-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a lot of small tasks, the softirq sched is nearly never called
when no_hz is enable. In this case the load_balance is mainly called with
the newly_idle mode which doesn't update the cpu_power.
Add a next_update field which ensure a maximum update period when
there is short activity

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 include/linux/sched.h |    1 +
 kernel/sched/fair.c   |   24 ++++++++++++++++--------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 64527c4..7178446 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -903,6 +903,7 @@ struct sched_group_power {
 	 * single CPU.
 	 */
 	unsigned int power, power_orig;
+	unsigned long next_update;
 	/*
 	 * Number of busy cpus in this group.
 	 */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a4d2b7a..809f484 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -215,6 +215,8 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 
 const struct sched_class fair_sched_class;
 
+static unsigned long __read_mostly max_load_balance_interval = HZ/10;
+
 /**************************************************************
  * CFS operations on generic schedulable entities:
  */
@@ -3786,6 +3788,11 @@ void update_group_power(struct sched_domain *sd, int cpu)
 	struct sched_domain *child = sd->child;
 	struct sched_group *group, *sdg = sd->groups;
 	unsigned long power;
+	unsigned long interval;
+
+	interval = msecs_to_jiffies(sd->balance_interval);
+	interval = clamp(interval, 1UL, max_load_balance_interval);
+	sdg->sgp->next_update = jiffies + interval;
 
 	if (!child) {
 		update_cpu_power(sd, cpu);
@@ -3893,12 +3900,15 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	 * domains. In the newly idle case, we will allow all the cpu's
 	 * to do the newly idle load balance.
 	 */
-	if (idle != CPU_NEWLY_IDLE && local_group) {
-		if (balance_cpu != this_cpu) {
-			*balance = 0;
-			return;
-		}
-		update_group_power(sd, this_cpu);
+	if (local_group) {
+		if (idle != CPU_NEWLY_IDLE) {
+			if (balance_cpu != this_cpu) {
+				*balance = 0;
+				return;
+			}
+			update_group_power(sd, this_cpu);
+		} else if (time_after_eq(jiffies, group->sgp->next_update))
+			update_group_power(sd, this_cpu);
 	}
 
 	/* Adjust by relative CPU power of the group */
@@ -4917,8 +4927,6 @@ void select_nohz_load_balancer(int stop_tick)
 
 static DEFINE_SPINLOCK(balancing);
 
-static unsigned long __read_mostly max_load_balance_interval = HZ/10;
-
 /*
  * Scale the max load_balance interval with the number of CPUs in the system.
  * This trades load-balance latency on larger machines for less cross talk.
-- 
1.7.4.1

