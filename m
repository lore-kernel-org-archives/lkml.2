Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab2A1MHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 07:07:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56532 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab2A1MHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 07:07:16 -0500
Date: Sat, 28 Jan 2012 04:06:54 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-39be350127ec60a078edffe5b4915dafba4ba514@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        axboe@kernel.dk, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, axboe@kernel.dk, tglx@linutronix.de
In-Reply-To: <1327579450.2446.95.camel@twins>
References: <1327579450.2446.95.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, block: Unify cache detection
Git-Commit-ID: 39be350127ec60a078edffe5b4915dafba4ba514
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Jan 2012 04:07:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39be350127ec60a078edffe5b4915dafba4ba514
Gitweb:     http://git.kernel.org/tip/39be350127ec60a078edffe5b4915dafba4ba514
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 26 Jan 2012 12:44:34 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 27 Jan 2012 13:28:48 +0100

sched, block: Unify cache detection

The block layer has some code trying to determine if two CPUs share a
cache, the scheduler has a similar function. Expose the function used
by the scheduler and make the block layer use it, thereby removing the
block layers usage of CONFIG_SCHED* and topology bits.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Jens Axboe <axboe@kernel.dk>
Link: http://lkml.kernel.org/r/1327579450.2446.95.camel@twins
---
 block/blk-softirq.c   |   16 ++++++++--------
 block/blk.h           |   16 ----------------
 include/linux/sched.h |    8 ++++++++
 kernel/sched/core.c   |    6 +++---
 4 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 1366a89..467c8de 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -8,6 +8,7 @@
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
+#include <linux/sched.h>
 
 #include "blk.h"
 
@@ -103,9 +104,10 @@ static struct notifier_block __cpuinitdata blk_cpu_notifier = {
 
 void __blk_complete_request(struct request *req)
 {
-	int ccpu, cpu, group_cpu = NR_CPUS;
+	int ccpu, cpu;
 	struct request_queue *q = req->q;
 	unsigned long flags;
+	bool shared = false;
 
 	BUG_ON(!q->softirq_done_fn);
 
@@ -117,22 +119,20 @@ void __blk_complete_request(struct request *req)
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
diff --git a/block/blk.h b/block/blk.h
index 7efd772..df5b59a 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -164,22 +164,6 @@ static inline int queue_congestion_off_threshold(struct request_queue *q)
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
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 513f524..0e19595 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1052,6 +1052,8 @@ static inline int test_sd_parent(struct sched_domain *sd, int flag)
 unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu);
 unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
 
+bool cpus_share_cache(int this_cpu, int that_cpu);
+
 #else /* CONFIG_SMP */
 
 struct sched_domain_attr;
@@ -1061,6 +1063,12 @@ partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
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
 
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5255c9d..d7c4322 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1507,7 +1507,7 @@ static int ttwu_activate_remote(struct task_struct *p, int wake_flags)
 }
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 
-static inline int ttwu_share_cache(int this_cpu, int that_cpu)
+bool cpus_share_cache(int this_cpu, int that_cpu)
 {
 	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
 }
@@ -1518,7 +1518,7 @@ static void ttwu_queue(struct task_struct *p, int cpu)
 	struct rq *rq = cpu_rq(cpu);
 
 #if defined(CONFIG_SMP)
-	if (sched_feat(TTWU_QUEUE) && !ttwu_share_cache(smp_processor_id(), cpu)) {
+	if (sched_feat(TTWU_QUEUE) && !cpus_share_cache(smp_processor_id(), cpu)) {
 		sched_clock_cpu(cpu); /* sync clocks x-cpu */
 		ttwu_queue_remote(p, cpu);
 		return;
@@ -5754,7 +5754,7 @@ static void destroy_sched_domains(struct sched_domain *sd, int cpu)
  *
  * Also keep a unique ID per domain (we use the first cpu number in
  * the cpumask of the domain), this allows us to quickly tell if
- * two cpus are in the same cache domain, see ttwu_share_cache().
+ * two cpus are in the same cache domain, see cpus_share_cache().
  */
 DEFINE_PER_CPU(struct sched_domain *, sd_llc);
 DEFINE_PER_CPU(int, sd_llc_id);
