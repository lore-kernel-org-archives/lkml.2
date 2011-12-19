Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab1LSIdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 03:33:08 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:42516 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab1LSIdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 03:33:05 -0500
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: [RFC PATCH 1/4] sched: Adding cpu.gang file to cpu cgroup
To: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Date: Mon, 19 Dec 2011 14:04:19 +0530
Message-ID: <20111219083401.32311.84994.stgit@abhimanyu.in.ibm.com>
In-Reply-To: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11121908-8256-0000-0000-0000008BAF60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce cpu.gang file in cpu controller, this will be used for enabling and
disabling gang scheduling for the task belonging to this cgroup.  This does
not take into account the cpu controller hierarchy while scheduling.

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
---

 kernel/sched/core.c  |   19 +++++++++++++++++++
 kernel/sched/fair.c  |   20 ++++++++++++++++++++
 kernel/sched/sched.h |    2 ++
 3 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3c5b21e..e96f861 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6862,6 +6862,7 @@ void __init sched_init(void)
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		root_task_group.shares = ROOT_TASK_GROUP_LOAD;
+		root_task_group.gang = 0;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
 		/*
 		 * How much cpu bandwidth does root_task_group get?
@@ -7585,6 +7586,19 @@ static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
 	return (u64) scale_load_down(tg->shares);
 }
 
+static int cpu_gang_write_u64(struct cgroup *cgrp, struct cftype *cftype,
+			      u64 shareval)
+{
+	return sched_group_set_gang(cgroup_tg(cgrp), shareval);
+}
+
+static u64 cpu_gang_read_u64(struct cgroup *cgrp, struct cftype *cft)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+
+	return (u64) tg->gang;
+}
+
 #ifdef CONFIG_CFS_BANDWIDTH
 static DEFINE_MUTEX(cfs_constraints_mutex);
 
@@ -7851,6 +7865,11 @@ static struct cftype cpu_files[] = {
 		.read_u64 = cpu_shares_read_u64,
 		.write_u64 = cpu_shares_write_u64,
 	},
+	{
+		.name = "gang",
+		.read_u64 = cpu_gang_read_u64,
+		.write_u64 = cpu_gang_write_u64,
+	},
 #endif
 #ifdef CONFIG_CFS_BANDWIDTH
 	{
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a4d2b7a..b95575f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5484,6 +5484,26 @@ done:
 	mutex_unlock(&shares_mutex);
 	return 0;
 }
+
+static DEFINE_MUTEX(gang_mutex);
+
+int sched_group_set_gang(struct task_group *tg, unsigned long gang)
+{
+	/*
+	 * root cgroup cannot be gang scheduled
+	 */
+	if (!tg->se[0])
+		return -EINVAL;
+
+	if (gang != 1 && gang != 0)
+		return -EINVAL;
+
+	mutex_lock(&gang_mutex);
+	tg->gang = gang;
+	mutex_unlock(&gang_mutex);
+	return 0;
+}
+
 #else /* CONFIG_FAIR_GROUP_SCHED */
 
 void free_fair_sched_group(struct task_group *tg) { }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d8d3613..f1a85e3 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -114,6 +114,7 @@ struct task_group {
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
 	unsigned long shares;
+	bool gang; /* should the tg be gang scheduled */
 
 	atomic_t load_weight;
 #endif
@@ -185,6 +186,7 @@ extern void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 			struct sched_entity *parent);
 extern void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
 extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
+extern int sched_group_set_gang(struct task_group *tg, unsigned long gang);
 
 extern void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b);
 extern void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b);

