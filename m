Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab1KAVU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:20:59 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:23413 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395Ab1KAVUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:20:54 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        fweisbec@gmail.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH v2 08/14] Report steal time for cgroup
Date: Tue,  1 Nov 2011 19:19:14 -0200
Message-Id: <1320182360-20043-9-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320182360-20043-1-git-send-email-glommer@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
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
 kernel/sched.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7dd4dea..c7ac150 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9662,6 +9662,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 	struct timespec boottime;
 #ifdef CONFIG_CGROUP_SCHED
 	struct task_group *tg;
+	struct task_group *sib;
 
 	if (cgrp)
 		tg = cgroup_tg(cgrp);
@@ -9700,6 +9701,21 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 		guest += kcpustat->cpustat[GUEST];
 		guest_nice += kcpustat->cpustat[GUEST_NICE];
 		total_forks += kcpustat->cpustat[TOTAL_FORKS];
+#ifdef CONFIG_CGROUP_SCHED
+		if (static_branch(&sched_cgroup_enabled)) {
+			list_for_each_entry(sib, &tg->siblings, siblings) {
+				struct kernel_cpustat *ksib;
+				if (!sib)
+					continue;
+
+				ksib = per_cpu_ptr(sib->cpustat, i);
+				steal += ksib->cpustat[USER] +
+					 ksib->cpustat[SYSTEM] +
+					 ksib->cpustat[IRQ] +
+					 ksib->cpustat[SOFTIRQ];
+			}
+		}
+#endif
 		kstat_unlock();
 
 		for (j = 0; j < NR_SOFTIRQS; j++) {
@@ -9744,6 +9760,21 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 		steal -= kcpustat->cpustat[STEAL_BASE];
 		guest = kcpustat->cpustat[GUEST];
 		guest_nice = kcpustat->cpustat[GUEST_NICE];
+#ifdef CONFIG_CGROUP_SCHED
+		if (static_branch(&sched_cgroup_enabled)) {
+			list_for_each_entry(sib, &tg->siblings, siblings) {
+				struct kernel_cpustat *ksib;
+				if (!sib)
+					continue;
+
+				ksib = per_cpu_ptr(sib->cpustat, i);
+				steal += ksib->cpustat[USER] +
+					 ksib->cpustat[SYSTEM] +
+					 ksib->cpustat[IRQ] +
+					 ksib->cpustat[SOFTIRQ];
+			}
+		}
+#endif
 		kstat_unlock();
 		seq_printf(p,
 			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu "
-- 
1.7.6.4

