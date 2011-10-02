Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1JBTXB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:23:01 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:35353 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192Ab1JBTWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:22:37 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 07/10] Report steal time for cgroup
Date: Sun,  2 Oct 2011 23:21:24 +0400
Message-Id: <1317583287-18300-8-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1317583287-18300-1-git-send-email-glommer@parallels.com>
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a functionality commonly found in
hypervisors: steal time.

For those not particularly familiar with it, steal time
is defined as any time in which a virtual machine (or container)
wanted to perform cpu work, but could not due to another
VM/container being scheduled in its place. Note that idle
time is never defined as steal time.

Assuming each container will live in its cgroup, we can
very easily and nicely calculate steal time as all user/system
time recorded in our sibling cgroups.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/sched.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a2554b7..dec73c4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9175,6 +9175,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 	struct timespec boottime;
 #ifdef CONFIG_CGROUP_SCHED
 	struct task_group *tg;
+	struct task_group *sib;
 
 	if (cgrp)
 		tg = cgroup_tg(cgrp);
@@ -9215,6 +9216,20 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 		guest += kstat->cpustat[GUEST];
 		guest_nice += kstat->cpustat[GUEST_NICE];
 		total_forks += kstat->cpustat[TOTAL_FORKS];
+		steal += kstat->cpustat[STEAL];
+#ifdef CONFIG_CGROUP_SCHED
+		rcu_read_lock();
+		list_for_each_entry(sib, &tg->siblings, siblings) {
+			struct kernel_stat *ksib;
+			if (!sib)
+				continue;
+
+			ksib = per_cpu_ptr(sib->cpustat, i);
+			steal += ksib->cpustat[USER] + ksib->cpustat[SYSTEM] +
+				 ksib->cpustat[IRQ] + ksib->cpustat[SOFTIRQ];
+		}
+		rcu_read_unlock();
+#endif
 		sum += kstat_cpu_irqs_sum(i);
 		sum += arch_irq_stat_cpu(i);
 
@@ -9260,6 +9275,19 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 		irq = kstat->cpustat[IRQ];
 		softirq = kstat->cpustat[SOFTIRQ];
 		steal = kstat->cpustat[STEAL];
+#ifdef CONFIG_CGROUP_SCHED
+		rcu_read_lock();
+		list_for_each_entry(sib, &tg->siblings, siblings) {
+			struct kernel_stat *ksib;
+			if (!sib)
+				continue;
+
+			ksib = per_cpu_ptr(sib->cpustat, i);
+			steal += ksib->cpustat[USER] + ksib->cpustat[SYSTEM] +
+				 ksib->cpustat[IRQ] + ksib->cpustat[SOFTIRQ];
+		}
+		rcu_read_unlock();
+#endif
 		guest = kstat->cpustat[GUEST];
 		guest_nice = kstat->cpustat[GUEST_NICE];
 		seq_printf(p,
-- 
1.7.6

