Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab1KAVVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:21:25 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:7378 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab1KAVVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:21:21 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        fweisbec@gmail.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH v2 12/14] Keep number of running processes per-cgroup
Date: Tue,  1 Nov 2011 19:19:18 -0200
Message-Id: <1320182360-20043-13-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320182360-20043-1-git-send-email-glommer@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This relies on the fact that the scheduler classes keep the number
of running processes internally in their entities.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/sched.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6ef6e1b..d93cfd4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9763,6 +9763,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 	struct timespec boottime;
 	unsigned long tg_iowait = 0;
 	u64 tg_nr_switches = 0;
+	unsigned long tg_nr_running = 0;
 #ifdef CONFIG_CGROUP_SCHED
 	struct task_group *tg;
 	struct task_group *sib;
@@ -9822,6 +9823,18 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 		}
 #endif
 		kstat_unlock();
+#ifdef CONFIG_CGROUP_SCHED
+		/* root task group has autogrouping, so this doesn't hold */
+		if  (tg != &root_task_group) {
+#ifdef CONFIG_FAIR_GROUP_SCHED
+			tg_nr_running += cpu_rq(i)->cfs.nr_running;
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+			tg_nr_running += cpu_rq(i)->rt.rt_nr_running;
+#endif
+		} else
+#endif
+			tg_nr_running += cpu_rq(i)->nr_running;
 
 		for (j = 0; j < NR_SOFTIRQS; j++) {
 			unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
@@ -9911,7 +9924,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 		tg_nr_switches,
 		(unsigned long)jif,
 		total_forks,
-		nr_running(),
+		tg_nr_running,
 		tg_iowait),
 
 	seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
-- 
1.7.6.4

