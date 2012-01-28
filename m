Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab2A1MH5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 07:07:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56542 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab2A1MHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 07:07:55 -0500
Date: Sat, 28 Jan 2012 04:07:42 -0800
From: tip-bot for Vincent Guittot <vincent.guittot@linaro.org>
Message-ID: <tip-4ec4412e1e91f44a3dcb97b6c9172a13fc78bac9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, vincent.guittot@linaro.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <1323717668-2143-1-git-send-email-vincent.guittot@linaro.org>
References: <1323717668-2143-1-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Ensure cpu_power periodic update
Git-Commit-ID: 4ec4412e1e91f44a3dcb97b6c9172a13fc78bac9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Jan 2012 04:07:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ec4412e1e91f44a3dcb97b6c9172a13fc78bac9
Gitweb:     http://git.kernel.org/tip/4ec4412e1e91f44a3dcb97b6c9172a13fc78bac9
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Mon, 12 Dec 2011 20:21:08 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 27 Jan 2012 13:28:49 +0100

sched: Ensure cpu_power periodic update

With a lot of small tasks, the softirq sched is nearly never called
when no_hz is enabled. In this case load_balance() is mainly called
with the newly_idle mode which doesn't update the cpu_power.

Add a next_update field which ensure a maximum update period when
there is short activity.

Having stale cpu_power information can skew the load-balancing
decisions, this is cured by the guaranteed update.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1323717668-2143-1-git-send-email-vincent.guittot@linaro.org
---
 include/linux/sched.h |    1 +
 kernel/sched/fair.c   |   24 ++++++++++++++++--------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0e19595..92313a3f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -905,6 +905,7 @@ struct sched_group_power {
 	 * single CPU.
 	 */
 	unsigned int power, power_orig;
+	unsigned long next_update;
 	/*
 	 * Number of busy cpus in this group.
 	 */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7c6414f..8e77a6b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -215,6 +215,8 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 
 const struct sched_class fair_sched_class;
 
+static unsigned long __read_mostly max_load_balance_interval = HZ/10;
+
 /**************************************************************
  * CFS operations on generic schedulable entities:
  */
@@ -3776,6 +3778,11 @@ void update_group_power(struct sched_domain *sd, int cpu)
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
@@ -3883,12 +3890,15 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
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
@@ -4945,8 +4955,6 @@ static int __cpuinit sched_ilb_notifier(struct notifier_block *nfb,
 
 static DEFINE_SPINLOCK(balancing);
 
-static unsigned long __read_mostly max_load_balance_interval = HZ/10;
-
 /*
  * Scale the max load_balance interval with the number of CPUs in the system.
  * This trades load-balance latency on larger machines for less cross talk.
