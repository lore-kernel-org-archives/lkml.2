Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab1IWWZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:25:23 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:30971 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab1IWWZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:25:14 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com,
        Glauber Costa <glommer@parallels.com>
Subject: [RFD 6/9] Report steal time for cgroup
Date: Fri, 23 Sep 2011 19:20:29 -0300
Message-Id: <1316816432-9237-7-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316816432-9237-1-git-send-email-glommer@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
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
index 7612410..8a510ab 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9148,6 +9148,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft, struct seq_fil
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
 	struct timespec boottime;
 	struct task_group *tg;
+	struct task_group *sib;
 
 	if (cgrp)
 		tg = cgroup_tg(cgrp);
@@ -9177,6 +9178,19 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft, struct seq_fil
 		irq = cputime64_add(irq, kstat->cpustat[IRQ]);
 		softirq = cputime64_add(softirq, kstat->cpustat[SOFTIRQ]);
 		steal = cputime64_add(steal, kstat->cpustat[STEAL]);
+		rcu_read_lock();
+		list_for_each_entry(sib, &tg->siblings, siblings) {
+			struct kernel_stat *ksib;
+			if (!sib)
+				continue;
+
+			ksib = per_cpu_ptr(sib->cpustat, i);
+			steal = cputime64_add(steal, ksib->cpustat[USER]);
+			steal = cputime64_add(steal, ksib->cpustat[SYSTEM]);
+			steal = cputime64_add(steal, ksib->cpustat[IRQ]);
+			steal = cputime64_add(steal, ksib->cpustat[SOFTIRQ]);
+		}
+		rcu_read_unlock();
 		guest = cputime64_add(guest, kstat->cpustat[GUEST]);
 		guest_nice = cputime64_add(guest_nice,
 			kstat->cpustat[GUEST_NICE]);
@@ -9221,6 +9235,20 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft, struct seq_fil
 		irq = kstat->cpustat[IRQ];
 		softirq = kstat->cpustat[SOFTIRQ];
 		steal = kstat->cpustat[STEAL];
+		rcu_read_lock();
+		list_for_each_entry(sib, &tg->siblings, siblings) {
+			struct kernel_stat *ksib;
+			if (!sib)
+				continue;
+
+			ksib = per_cpu_ptr(sib->cpustat, i);
+			steal = cputime64_add(steal, ksib->cpustat[USER]);
+			steal = cputime64_add(steal, ksib->cpustat[SYSTEM]);
+			steal = cputime64_add(steal, ksib->cpustat[IRQ]);
+			steal = cputime64_add(steal, ksib->cpustat[SOFTIRQ]);
+		}
+		rcu_read_unlock();
+
 		guest = kstat->cpustat[GUEST];
 		guest_nice = kstat->cpustat[GUEST_NICE];
 		seq_printf(p,
-- 
1.7.6

