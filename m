Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab1INUFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:05:46 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:42208 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140Ab1INUFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:05:45 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: xemul@parallels.com, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, mingo@elte.hu, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH 1/9] Remove parent field in cpuacct cgroup
Date: Wed, 14 Sep 2011 17:04:47 -0300
Message-Id: <1316030695-19826-2-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316030695-19826-1-git-send-email-glommer@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup already has parent pointers, so we  don't need to define our
own.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/sched.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ccacdbd..4cde3eb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9096,7 +9096,6 @@ struct cpuacct {
 	/* cpuusage holds pointer to a u64-type object on every cpu */
 	u64 __percpu *cpuusage;
 	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
-	struct cpuacct *parent;
 };
 
 struct cgroup_subsys cpuacct_subsys;
@@ -9115,6 +9114,16 @@ static inline struct cpuacct *task_ca(struct task_struct *tsk)
 			    struct cpuacct, css);
 }
 
+static inline struct cpuacct *parent_ca(struct cpuacct *ca)
+{
+	struct cpuacct *parent = NULL;
+	struct cgroup *cgrp = ca->css.cgroup;
+	if (cgrp->parent)
+		parent = container_of(cgroup_subsys_state(cgrp->parent, cpuacct_subsys_id),
+				    struct cpuacct, css);
+	return parent;
+}
+
 /* create a new cpu accounting group */
 static struct cgroup_subsys_state *cpuacct_create(
 	struct cgroup_subsys *ss, struct cgroup *cgrp)
@@ -9133,9 +9142,6 @@ static struct cgroup_subsys_state *cpuacct_create(
 		if (percpu_counter_init(&ca->cpustat[i], 0))
 			goto out_free_counters;
 
-	if (cgrp->parent)
-		ca->parent = cgroup_ca(cgrp->parent);
-
 	return &ca->css;
 
 out_free_counters:
@@ -9302,7 +9308,7 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 
 	ca = task_ca(tsk);
 
-	for (; ca; ca = ca->parent) {
+	for (; ca; ca = parent_ca(ca)) {
 		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
 		*cpuusage += cputime;
 	}
@@ -9344,7 +9350,7 @@ static void cpuacct_update_stats(struct task_struct *tsk,
 
 	do {
 		__percpu_counter_add(&ca->cpustat[idx], val, batch);
-		ca = ca->parent;
+		ca = parent_ca(ca);
 	} while (ca);
 	rcu_read_unlock();
 }
-- 
1.7.6

