Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0D1LTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 07:19:36 -0400
Received: from smtp-out.google.com ([74.125.121.35]:12651 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab0D1LTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 07:19:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=o/x7mFmT57955yftbM+dC/VcIvt5zZ5DXEsdc8axHl5gVYpX2m9x6TYplTHgQI3W8
	rTj9xQmXesgo61+4lhFdA==
Subject: [PATCH v2 4/6] sched: unthrottle cfs_rq(s) who ran out of quota at
	period refresh
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Paul Menage <menage@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Chris Friesen <cfriesen@nortel.com>, Avi Kivity <avi@redhat.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Mike Waychison <mikew@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 28 Apr 2010 04:17:07 -0700
Message-ID: <20100428111706.7954.65869.stgit@kitami.corp.google.com>
In-Reply-To: <20100428110720.7954.53537.stgit@kitami.corp.google.com>
References: <20100428110720.7954.53537.stgit@kitami.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the start of a new period there are several actions we must take:
- Refresh global bandwidth pool
- Unthrottle entities who ran out of quota as refreshed bandwidth permits

Unthrottled entities have the cfs_rq->throttled flag set and are re-enqueued
into the cfs entity hierarchy.

sched_rt_period_mask() is refactored slightly into sched_bw_period_mask()
since it is now shared by both cfs and rt bandwidth period timers.

The !CONFIG_RT_GROUP_SCHED && CONFIG_SMP case has been collapsed to use
rd->span instead of cpu_online_mask since I think that was incorrect before
(don't want to hit cpu's outside of your root_domain for RT bandwidth).

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c      |   16 +++++++++++++
 kernel/sched_fair.c |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched_rt.c   |   19 +--------------
 3 files changed, 79 insertions(+), 19 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d072881..aca1d32 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1529,6 +1529,8 @@ static int tg_nop(struct task_group *tg, void *data)
 }
 #endif
 
+static inline const struct cpumask *sched_bw_period_mask(void);
+
 #ifdef CONFIG_SMP
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
@@ -1916,6 +1918,18 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 
 static const struct sched_class rt_sched_class;
 
+#ifdef CONFIG_SMP
+static inline const struct cpumask *sched_bw_period_mask(void)
+{
+	return cpu_rq(smp_processor_id())->rd->span;
+}
+#else
+static inline const struct cpumask *sched_bw_period_mask(void)
+{
+	return cpu_online_mask;
+}
+#endif
+
 #ifdef CONFIG_CFS_BANDWIDTH
 /*
  * default period for cfs group bandwidth.
@@ -8904,6 +8918,8 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 
 		raw_spin_lock_irq(&rq->lock);
 		init_cfs_rq_quota(cfs_rq);
+		if (cfs_rq_throttled(cfs_rq))
+			unthrottle_cfs_rq(cfs_rq);
 		raw_spin_unlock_irq(&rq->lock);
 	}
 	mutex_unlock(&mutex);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0e480ae..11de5de 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -268,6 +268,13 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_CFS_BANDWIDTH
+static inline
+struct cfs_rq *cfs_bandwidth_cfs_rq(struct cfs_bandwidth *cfs_b, int cpu)
+{
+	return container_of(cfs_b, struct task_group,
+			cfs_bandwidth)->cfs_rq[cpu];
+}
+
 static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 {
 	return &tg->cfs_bandwidth;
@@ -1224,6 +1231,24 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	cfs_rq->throttled = 1;
 }
 
+static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	struct sched_entity *se;
+
+	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+
+	cfs_rq->throttled = 0;
+	for_each_sched_entity(se) {
+		if (se->on_rq)
+			break;
+
+		cfs_rq = cfs_rq_of(se);
+		enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
+		if (cfs_rq_throttled(cfs_rq))
+			break;
+	}
+}
+
 static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec)
 {
@@ -1246,8 +1271,44 @@ static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
 
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
-	return 1;
+	int i, idle = 1;
+	u64 delta;
+	const struct cpumask *span;
+
+	if (cfs_b->quota == RUNTIME_INF)
+		return 1;
+
+	/* reset group quota */
+	raw_spin_lock(&cfs_b->lock);
+	cfs_b->runtime = cfs_b->quota;
+	raw_spin_unlock(&cfs_b->lock);
+
+	span = sched_bw_period_mask();
+	for_each_cpu(i, span) {
+		struct rq *rq = cpu_rq(i);
+		struct cfs_rq *cfs_rq = cfs_bandwidth_cfs_rq(cfs_b, i);
+
+		if (cfs_rq->nr_running)
+			idle = 0;
+
+		if (!cfs_rq_throttled(cfs_rq))
+			continue;
+
+		delta = tg_request_cfs_quota(cfs_rq->tg);
+
+		if (delta) {
+			raw_spin_lock(&rq->lock);
+			cfs_rq->quota_assigned += delta;
+
+			if (cfs_rq->quota_used < cfs_rq->quota_assigned)
+				unthrottle_cfs_rq(cfs_rq);
+			raw_spin_unlock(&rq->lock);
+		}
+	}
+
+	return idle;
 }
+
 #endif
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index b5b920a..15bbc45 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -241,18 +241,6 @@ static int rt_se_boosted(struct sched_rt_entity *rt_se)
 	return p->prio != p->normal_prio;
 }
 
-#ifdef CONFIG_SMP
-static inline const struct cpumask *sched_rt_period_mask(void)
-{
-	return cpu_rq(smp_processor_id())->rd->span;
-}
-#else
-static inline const struct cpumask *sched_rt_period_mask(void)
-{
-	return cpu_online_mask;
-}
-#endif
-
 static inline
 struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
 {
@@ -302,11 +290,6 @@ static inline int rt_rq_throttled(struct rt_rq *rt_rq)
 	return rt_rq->rt_throttled;
 }
 
-static inline const struct cpumask *sched_rt_period_mask(void)
-{
-	return cpu_online_mask;
-}
-
 static inline
 struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
 {
@@ -524,7 +507,7 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
 		return 1;
 
-	span = sched_rt_period_mask();
+	span = sched_bw_period_mask();
 	for_each_cpu(i, span) {
 		int enqueue = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);

