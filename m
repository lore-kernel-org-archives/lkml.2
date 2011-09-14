Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab1INUGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:06:34 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:19197 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933151Ab1INUGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:06:32 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: xemul@parallels.com, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, mingo@elte.hu, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH 9/9] Report steal time for cgroup
Date: Wed, 14 Sep 2011 17:04:55 -0300
Message-Id: <1316030695-19826-10-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316030695-19826-1-git-send-email-glommer@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
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
 kernel/sched.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8f254d0..2dad1e0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9321,6 +9321,7 @@ static int cpuacct_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 	struct cpuacct *ca = cgroup_ca(cgrp);
 	struct timespec ts;
 	u64 *cpustat;
+	struct cgroup *sib;
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
@@ -9343,6 +9344,20 @@ static int cpuacct_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 		irq = cputime64_add(irq, cpustat[CPUACCT_STAT_IRQ]);
 		softirq = cputime64_add(softirq, cpustat[CPUACCT_STAT_SOFTIRQ]);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
+		rcu_read_lock();
+		list_for_each_entry(sib, &ca->css.cgroup->sibling, sibling) {
+			u64 *cpustat_sib;
+			struct cpuacct *ca_sib = cgroup_ca(sib);
+			if (!ca_sib)
+				continue;
+
+			cpustat_sib = per_cpu_ptr(ca_sib->cpustat, i);
+			steal = cputime64_add(steal, cpustat_sib[CPUACCT_STAT_USER]);
+			steal = cputime64_add(steal, cpustat_sib[CPUACCT_STAT_SYSTEM]);
+			steal = cputime64_add(steal, cpustat_sib[CPUACCT_STAT_IRQ]);
+			steal = cputime64_add(steal, cpustat_sib[CPUACCT_STAT_SOFTIRQ]);
+		}
+		rcu_read_unlock();
 		guest = cputime64_add(guest, cpustat[CPUACCT_STAT_GUEST]);
 		guest_nice = cputime64_add(guest_nice,
 			cpustat[CPUACCT_STAT_GUEST_NICE]);
@@ -9384,6 +9399,21 @@ static int cpuacct_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 		irq = cpustat[CPUACCT_STAT_IRQ];
 		softirq = cpustat[CPUACCT_STAT_SOFTIRQ];
 		steal = kstat_cpu(i).cpustat.steal;
+		rcu_read_lock();
+		list_for_each_entry(sib, &ca->css.cgroup->sibling, sibling) {
+			u64 *cpustat_sib;
+			struct cpuacct *ca_sib = cgroup_ca(sib);
+
+			if (!ca_sib)
+				continue;
+			cpustat_sib = per_cpu_ptr(ca_sib->cpustat, i);
+			steal = cputime64_add(steal, cpustat_sib[CPUACCT_STAT_USER]);
+			steal = cputime64_add(steal, cpustat_sib[CPUACCT_STAT_SYSTEM]);
+			steal = cputime64_add(steal, cpustat_sib[CPUACCT_STAT_IRQ]);
+			steal = cputime64_add(steal, cpustat_sib[CPUACCT_STAT_SOFTIRQ]);
+		}
+		rcu_read_unlock();
+
 		guest = cpustat[CPUACCT_STAT_GUEST];
 		guest_nice = cpustat[CPUACCT_STAT_GUEST_NICE];
 		seq_printf(p,
-- 
1.7.6

