Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab1KYBea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 20:34:30 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:15760 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab1KYBe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 20:34:29 -0500
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: lizf@cn.fujitsu.com, daniel.lezcano@free.fr, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, pjt@google.com, cgroups@vger.kernel.org,
        devel@openvz.org, Glauber Costa <glommer@parallels.com>
Subject: [PATCH 2/4] Reuse cgroup's parent pointer
Date: Thu, 24 Nov 2011 23:33:24 -0200
Message-Id: <1322184806-20421-3-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1322184806-20421-1-git-send-email-glommer@parallels.com>
References: <1322184806-20421-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have a pointer to the cgroup parent (whose data is more likely
to be in the cache than this, anyway), so there is no need to have this one
in cpuacct.

This patch makes the underlying cgroup be used instead.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Paul Tuner <pjt@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 2e57942..d504c7b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9509,7 +9509,6 @@ struct cpuacct {
 	/* cpuusage holds pointer to a u64-type object on every cpu */
 	u64 __percpu *cpuusage;
 	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
-	struct cpuacct *parent;
 };
 
 struct cgroup_subsys cpuacct_subsys;
@@ -9528,6 +9527,13 @@ static inline struct cpuacct *task_ca(struct task_struct *tsk)
 			    struct cpuacct, css);
 }
 
+static inline struct cpuacct *parent_ca(struct cpuacct *ca)
+{
+	if (!ca || !ca->css.cgroup->parent)
+		return NULL;
+	return cgroup_ca(ca->css.cgroup->parent);
+}
+
 /* create a new cpu accounting group */
 static struct cgroup_subsys_state *cpuacct_create(
 	struct cgroup_subsys *ss, struct cgroup *cgrp)
@@ -9546,9 +9552,6 @@ static struct cgroup_subsys_state *cpuacct_create(
 		if (percpu_counter_init(&ca->cpustat[i], 0))
 			goto out_free_counters;
 
-	if (cgrp->parent)
-		ca->parent = cgroup_ca(cgrp->parent);
-
 	return &ca->css;
 
 out_free_counters:
@@ -9715,7 +9718,7 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 
 	ca = task_ca(tsk);
 
-	for (; ca; ca = ca->parent) {
+	for (; ca; ca = parent_ca(ca)) {
 		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
 		*cpuusage += cputime;
 	}
@@ -9757,7 +9760,7 @@ static void cpuacct_update_stats(struct task_struct *tsk,
 
 	do {
 		__percpu_counter_add(&ca->cpustat[idx], val, batch);
-		ca = ca->parent;
+		ca = parent_ca(ca);
 	} while (ca);
 	rcu_read_unlock();
 }
-- 
1.7.6.4

