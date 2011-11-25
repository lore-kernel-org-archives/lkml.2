Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1KYBeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 20:34:44 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:47126 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab1KYBem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 20:34:42 -0500
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: lizf@cn.fujitsu.com, daniel.lezcano@free.fr, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, pjt@google.com, cgroups@vger.kernel.org,
        devel@openvz.org, Glauber Costa <glommer@parallels.com>
Subject: [PATCH 3/4] Move part of cpuacct code
Date: Thu, 24 Nov 2011 23:33:25 -0200
Message-Id: <1322184806-20421-4-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1322184806-20421-1-git-send-email-glommer@parallels.com>
References: <1322184806-20421-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is just a preparation patch for the next one in the series.
It moves the cpuacct structure definition and some helper functions early
in the file so we can access its members from here on.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Paul Tuner <pjt@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   77 +++++++++++++++++++++++++++----------------------------
 1 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d504c7b..9b70305 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1596,6 +1596,44 @@ enum cpuacct_stat_index {
 };
 
 #ifdef CONFIG_CGROUP_CPUACCT
+/*
+ * CPU accounting code for task groups.
+ *
+ * Based on the work by Paul Menage (menage@google.com) and Balbir Singh
+ * (balbir@in.ibm.com).
+ */
+
+/* track cpu usage of a group of tasks and its child groups */
+struct cpuacct {
+	struct cgroup_subsys_state css;
+	/* cpuusage holds pointer to a u64-type object on every cpu */
+	u64 __percpu *cpuusage;
+	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
+};
+
+struct cgroup_subsys cpuacct_subsys;
+
+/* return cpu accounting group corresponding to this container */
+static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
+{
+	return container_of(cgroup_subsys_state(cgrp, cpuacct_subsys_id),
+			    struct cpuacct, css);
+}
+
+/* return cpu accounting group to which this task belongs */
+static inline struct cpuacct *task_ca(struct task_struct *tsk)
+{
+	return container_of(task_subsys_state(tsk, cpuacct_subsys_id),
+			    struct cpuacct, css);
+}
+
+static inline struct cpuacct *parent_ca(struct cpuacct *ca)
+{
+	if (!ca || !ca->css.cgroup->parent)
+		return NULL;
+	return cgroup_ca(ca->css.cgroup->parent);
+}
+
 static void cpuacct_charge(struct task_struct *tsk, u64 cputime);
 static void cpuacct_update_stats(struct task_struct *tsk,
 		enum cpuacct_stat_index idx, cputime_t val);
@@ -9495,45 +9533,6 @@ struct cgroup_subsys cpu_cgroup_subsys = {
 #endif	/* CONFIG_CGROUP_SCHED */
 
 #ifdef CONFIG_CGROUP_CPUACCT
-
-/*
- * CPU accounting code for task groups.
- *
- * Based on the work by Paul Menage (menage@google.com) and Balbir Singh
- * (balbir@in.ibm.com).
- */
-
-/* track cpu usage of a group of tasks and its child groups */
-struct cpuacct {
-	struct cgroup_subsys_state css;
-	/* cpuusage holds pointer to a u64-type object on every cpu */
-	u64 __percpu *cpuusage;
-	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
-};
-
-struct cgroup_subsys cpuacct_subsys;
-
-/* return cpu accounting group corresponding to this container */
-static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
-{
-	return container_of(cgroup_subsys_state(cgrp, cpuacct_subsys_id),
-			    struct cpuacct, css);
-}
-
-/* return cpu accounting group to which this task belongs */
-static inline struct cpuacct *task_ca(struct task_struct *tsk)
-{
-	return container_of(task_subsys_state(tsk, cpuacct_subsys_id),
-			    struct cpuacct, css);
-}
-
-static inline struct cpuacct *parent_ca(struct cpuacct *ca)
-{
-	if (!ca || !ca->css.cgroup->parent)
-		return NULL;
-	return cgroup_ca(ca->css.cgroup->parent);
-}
-
 /* create a new cpu accounting group */
 static struct cgroup_subsys_state *cpuacct_create(
 	struct cgroup_subsys *ss, struct cgroup *cgrp)
-- 
1.7.6.4

