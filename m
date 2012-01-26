Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab2AZMEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 07:04:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56135 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2AZMEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 07:04:30 -0500
Message-ID: <1327579450.2446.95.camel@twins>
Subject: Re: [RFC PATCH v1 1/2] sched: unified sched_powersavings sysfs
 tunable
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Indan Zupancic <indan@nul.nu>, Youquan Song <youquan.song@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jan 2012 13:04:10 +0100
In-Reply-To: <4F21386C.5000809@kernel.dk>
References: <20120116161740.29759.4679.stgit@localhost>
	   <20120116162241.29759.13220.stgit@localhost>
	  <1327503181.2614.76.camel@laptop> <4F212DFF.8060802@kernel.dk>
	 <1327576091.2446.87.camel@twins> <4F21386C.5000809@kernel.dk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-26 at 12:26 +0100, Jens Axboe wrote:
> O
> Yeah, I think that would suit my purpose nicely, in fact. What level of
> cache sharing is being used here? The block code wanted a per-socket
> type operation, but since it's a heuristic, perhaps the above is even
> better (or equivelant, perhaps).

It uses the biggest shared cache exposed in the topology information the
scheduler has (which is currently somewhat funny but is on the todo list
for improvements).

Effectively it ends up being the socket wide LLC for modern Intel chips
though.

Would something like the below work for you (compile tested only).

---
Subject: sched, block: Unify cache detection
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Jan 26 12:44:34 CET 2012

The block layer has some code trying to determine if two CPUs share a
cache, the scheduler has a similar function. Expose the function used
by the scheduler and make the block layer use it, thereby removing the
block layers usage of CONFIG_SCHED* and topology bits.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 block/blk-softirq.c   |   16 ++++++++--------
 block/blk.h           |   16 ----------------
 include/linux/sched.h |    8 ++++++++
 kernel/sched/core.c   |    6 +++---
 4 files changed, 19 insertions(+), 27 deletions(-)

--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -8,6 +8,7 @@
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
+#include <linux/sched.h>
 
 #include "blk.h"
 
@@ -103,9 +104,10 @@ static struct notifier_block __cpuinitda
 
 void __blk_complete_request(struct request *req)
 {
-	int ccpu, cpu, group_cpu = NR_CPUS;
+	int ccpu, cpu;
 	struct request_queue *q = req->q;
 	unsigned long flags;
+	bool shared = false;
 
 	BUG_ON(!q->softirq_done_fn);
 
@@ -117,22 +119,20 @@ void __blk_complete_request(struct reque
 	 */
 	if (req->cpu != -1) {
 		ccpu = req->cpu;
-		if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags)) {
-			ccpu = blk_cpu_to_group(ccpu);
-			group_cpu = blk_cpu_to_group(cpu);
-		}
+		if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags))
+			shared = cpus_share_cache(cpu, ccpu);
 	} else
 		ccpu = cpu;
 
 	/*
-	 * If current CPU and requested CPU are in the same group, running
-	 * softirq in current CPU. One might concern this is just like
+	 * If current CPU and requested CPU share a cache, run the softirq on
+	 * the current CPU. One might concern this is just like
 	 * QUEUE_FLAG_SAME_FORCE, but actually not. blk_complete_request() is
 	 * running in interrupt handler, and currently I/O controller doesn't
 	 * support multiple interrupts, so current CPU is unique actually. This
 	 * avoids IPI sending from current CPU to the first CPU of a group.
 	 */
-	if (ccpu == cpu || ccpu == group_cpu) {
+	if (ccpu == cpu || shared) {
 		struct list_head *list;
 do_local:
 		list = &__get_cpu_var(blk_cpu_done);
--- a/block/blk.h
+++ b/block/blk.h
@@ -164,22 +164,6 @@ static inline int queue_congestion_off_t
 	return q->nr_congestion_off;
 }
 
-static inline int blk_cpu_to_group(int cpu)
-{
-	int group = NR_CPUS;
-#ifdef CONFIG_SCHED_MC
-	const struct cpumask *mask = cpu_coregroup_mask(cpu);
-	group = cpumask_first(mask);
-#elif defined(CONFIG_SCHED_SMT)
-	group = cpumask_first(topology_thread_cpumask(cpu));
-#else
-	return cpu;
-#endif
-	if (likely(group < NR_CPUS))
-		return group;
-	return cpu;
-}
-
 /*
  * Contribute to IO statistics IFF:
  *
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1052,6 +1052,8 @@ static inline int test_sd_parent(struct
 unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu);
 unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
 
+bool cpus_share_cache(int this_cpu, int that_cpu);
+
 #else /* CONFIG_SMP */
 
 struct sched_domain_attr;
@@ -1061,6 +1063,12 @@ partition_sched_domains(int ndoms_new, c
 			struct sched_domain_attr *dattr_new)
 {
 }
+
+static inline bool cpus_share_cache(int this_cpu, int that_cpu)
+{
+	return true;
+}
+
 #endif	/* !CONFIG_SMP */
 
 
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1512,7 +1512,7 @@ static int ttwu_activate_remote(struct t
 }
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 
-static inline int ttwu_share_cache(int this_cpu, int that_cpu)
+bool cpus_share_cache(int this_cpu, int that_cpu)
 {
 	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
 }
@@ -1523,7 +1523,7 @@ static void ttwu_queue(struct task_struc
 	struct rq *rq = cpu_rq(cpu);
 
 #if defined(CONFIG_SMP)
-	if (sched_feat(TTWU_QUEUE) && !ttwu_share_cache(smp_processor_id(), cpu)) {
+	if (sched_feat(TTWU_QUEUE) && !cpus_share_cache(smp_processor_id(), cpu)) {
 		sched_clock_cpu(cpu); /* sync clocks x-cpu */
 		ttwu_queue_remote(p, cpu);
 		return;
@@ -5759,7 +5759,7 @@ static void destroy_sched_domains(struct
  *
  * Also keep a unique ID per domain (we use the first cpu number in
  * the cpumask of the domain), this allows us to quickly tell if
- * two cpus are in the same cache domain, see ttwu_share_cache().
+ * two cpus are in the same cache domain, see cpus_share_cache().
  */
 DEFINE_PER_CPU(struct sched_domain *, sd_llc);
 DEFINE_PER_CPU(int, sd_llc_id);

