Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309Ab0FJPTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:19:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38994 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab0FJPTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:19:47 -0400
Subject: Re: [PATCH] [10/23] SCHED: Only allocate per cpu cpu mask buffer
 with offstack cpumasks
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <87fx0v3p1x.fsf@basil.nowhere.org>
References: <20100610110.764742110@firstfloor.org>
	 <20100610111046.18EB4B1A2B@basil.firstfloor.org>
	 <1276181030.2077.399.camel@twins> <20100610145243.GC19561@basil.fritz.box>
	 <1276181743.2077.426.camel@twins>  <87fx0v3p1x.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 17:19:36 +0200
Message-ID: <1276183176.2077.484.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 17:06 +0200, Andi Kleen wrote:
> +#if defined(CONFIG_CPUMASK_OFFSTACK) || defined(CONFIG_FAIR_GROUP_SCHED)

Still wrong.. something like the below might work, but I really think
its not worth the trouble.

---
 kernel/sched.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 19b3c5d..af40894 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7689,7 +7689,9 @@ static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 void __init sched_init(void)
 {
 	int i, j;
-	unsigned long alloc_size = 0, ptr;
+
+#if defined CONFIG_FAIR_GROUP_SCHED || defined CONFIG_RT_GROUP_SCHED || defined CONFIG_CPUMASK_OFFSTACK
+	unsigned long alloc_size = 0;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
@@ -7701,6 +7703,8 @@ void __init sched_init(void)
 	alloc_size += num_possible_cpus() * cpumask_size();
 #endif
 	if (alloc_size) {
+		unsigned long ptr;
+	       
 		ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -7726,6 +7730,7 @@ void __init sched_init(void)
 		}
 #endif /* CONFIG_CPUMASK_OFFSTACK */
 	}
+#endif /* {FAIR,RT}_GROUP,OFFSTACK */
 
 #ifdef CONFIG_SMP
 	init_defrootdomain();
@@ -7762,7 +7767,6 @@ void __init sched_init(void)
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.shares = init_task_group_load;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
-#ifdef CONFIG_CGROUP_SCHED
 		/*
 		 * How much cpu bandwidth does init_task_group get?
 		 *
@@ -7783,16 +7787,13 @@ void __init sched_init(void)
 		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
 		 */
 		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, 1, NULL);
-#endif
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 		rq->rt.rt_runtime = def_rt_bandwidth.rt_runtime;
 #ifdef CONFIG_RT_GROUP_SCHED
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
-#ifdef CONFIG_CGROUP_SCHED
 		init_tg_rt_entry(&init_task_group, &rq->rt, NULL, i, 1, NULL);
 #endif
-#endif
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
 			rq->cpu_load[j] = 0;

